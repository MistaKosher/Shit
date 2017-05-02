//+------------------------------------------------------------------+
//|                                                 ax_adv_009_2.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property version   "1.00"
#property strict
//Accelerator

#import "fx_sample_001.dll"
        void   axInit();
        void   axDeinit();
        void   axAddOrder(int ticket, double sl, int fibo_level, int ext_data, double by_rsi);
        void   axRemoveOrder(int ticket);
        double axGetOrderSL(int ticket);
        int    axGetOrderFiboLevel(int ticket);
        int    axGetOrderExtData(int ticket);
        double axGetOrderByRSI(int ticket);
        bool   axSetOrderSL(int ticket, double sl);
        bool   axSetOrderFiboLevel(int ticket, int fibo_level);
        bool   axSetOrderExtData(int ticket, int ext_data);
        bool   axSetOrderByRSI(int ticket, double by_rsi);
        void   axClearArray();
        void   axAddArrayValue(double v);
        double axGetArrayMinValue();
        double axGetArrayMaxValue();
#import

#include <stdlib.mqh>

//#define BUY
//#define SELL

//MqlRates g_mqlrates[];
MqlRates g_ready_bar;

int g_ticket=-1;//����� �������� ������
input int g_delta_points=2;//����� ����, � ������
double g_lots=0.01;//������ ����
//input double g_lots_3=0.01;//������ ���� 3
//input double g_lots_2=0.01;//������ ���� 2
input double g_lot=0.01;//���
input int g_slippage=3;//���������������
//input double g_gator_magic_value=1.00000018;//��������� ����� ������
//double g_gator_magic_value=1.001;//��������� ����� ������
double g_gator_wake_up_val=1.001;//������ �����������
double g_gator_sleep_val=1.0001;//����� ������� �����
bool g_set_tp=false;//������������� ���� TakeProfit
int g_reversal_bar_cnt_wait=3;//���������� ����� ��� ��������� �����������
//int g_direct_order_exp_bar_count=3;//����� �������� ��������� (������ �����),� �����
//int g_reverse_order_exp_bar_count=21;//����� �������� ��������� (�������� �����),� �����
input int g_order_exp_bar_count=21;//����� �������� ���������,� �����
int g_order_count;//���������� ������� ������� 
double g_gator_bar_diff=1;//���������� ����� ������� � ����� (�����������) (� �����:))
double g_profit_coef=1.0;//������� TakeProfit � ��������� TakeProfit/StopLoss
//input double g_direct_profit_coef=1.0;//(direct)������� TakeProfit � ��������� TakeProfit/StopLoss
//input double g_reverse_profit_coef=1.0;//(reverse)������� TakeProfit � ��������� TakeProfit/StopLoss
int g_gator_sleeps_bar_count=5;//����� ������� ����� ����������, ��� ����� ������� ����
int gator_sleep_bar_count=0;
int g_handle;
int g_orders_to_modify=0;
int g_green3_ticket=-1;
int g_green2_ticket=-1;
int g_red3_ticket=-1;
int g_red2_ticket=-1;
double g_profit=1.5;
double g_loss=-0.5;
double g_fibo_coef=0.382;//0.236 0.382 0.500 0.618
input int g_rsi_period=14;//RSI ������
input int g_demark_period=5;//DeMarker ������
double g_percent_bar_to_extrem=0.01;

double g_buy_max;
double g_sell_min;
double g_buy_loc_min;
double g_sell_loc_max;
double g_upper_frac;
double g_lower_frac;

double g_fibo_coefs[5];

#include "ax_bar_utils.mqh"

input adv_trade_mode g_trade_mode;//����� ������ 0-������ BUY,1-������ SELL,2-� BUY, � SELL

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
 axInit();
 
 g_ticket=-1;//������ ���
 
 g_order_count=0; 

 g_fibo_coefs[FIBO_100]=1.000;
 //g_fibo_coefs[FIBO_618]=0.618;
 g_fibo_coefs[FIBO_618]=0.764;
 g_fibo_coefs[FIBO_500]=0.500;
 g_fibo_coefs[FIBO_382]=0.382;
 g_fibo_coefs[FIBO_236]=0.236;
 
 //����� �������� �������� ���������� ��������������� ����
 MqlRates rates[];
 ArrayCopyRates(rates,NULL,0);

 g_ready_bar=rates[1]; 
 
 /*Comment("������������ ������ ����=",MarketInfo(Symbol(),MODE_MAXLOT),  
         "\n������������ ������ �����=",AccountLeverage(),
         "\n������=",AccountBalance(), 
         "\n��������=",AccountFreeMargin());*/
 
 return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---
 axDeinit();
 
 FileClose(g_handle);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
 MqlRates rates[];
 ArrayCopyRates(rates,NULL,0);
 
 if(!ax_bar_utils::is_equal(g_ready_bar,rates[1]))//������� ��������� ���
 {
  g_ready_bar=rates[1];//��� ����� ����� �������������� ��� - �������� � ���
  
  ax_order_settings direct_set(g_lot,g_slippage,"DIRECT",g_order_exp_bar_count,0,FIBO_618);
  
  switch(ax_bar_utils::get_rsi_mode())
  {
   case RSIMODE_MIDDLE_UPPER: axClearArray();
   case RSIMODE_UPPER: axAddArrayValue(g_ready_bar.high); break;
   
   case RSIMODE_MIDDLE_LOWER: axClearArray();
   case RSIMODE_LOWER:axAddArrayValue(g_ready_bar.low); break;
   
   case RSIMODE_UPPER_MIDDLE: //����� ����� � BUY
                              ax_bar_utils::SetAllOrderSLbyFibo3(OP_BUY,axGetArrayMaxValue());
                              axClearArray();
                              break;
   case RSIMODE_LOWER_MIDDLE: //����� ����� � SELL
                              ax_bar_utils::SetAllOrderSLbyFibo3(OP_SELL,axGetArrayMinValue());
                              axClearArray();
                              break;
  }//switch
  
  string err_msg;
  
  macd_trade_mode mtm_d1=ax_bar_utils::get_tm_by_macd(PERIOD_D1,1);
  
  macd_trade_mode mtm=ax_bar_utils::get_tm_by_macd(PERIOD_CURRENT,1);
  
  if(g_trade_mode==ADVTRADEMODE_BUY || g_trade_mode==ADVTRADEMODE_BOTH)
  {
   if(mtm_d1==MACDTRADEMODE_BUY && mtm==MACDTRADEMODE_BUY)
   {
    ax_bar_utils::trade(rates,TRADEMODE_BUY,direct_set,err_msg);
   }//if mtm
  }//if g_trade_mode
  
  if(g_trade_mode==ADVTRADEMODE_SELL || g_trade_mode==ADVTRADEMODE_BOTH)
  {
   if(mtm_d1==MACDTRADEMODE_SELL && mtm==MACDTRADEMODE_SELL)
   {
    ax_bar_utils::trade(rates,TRADEMODE_SELL,direct_set,err_msg);
   }//if mtm
  }//if g_trade_mode
  
  if(err_msg!="")
   Print(err_msg);
 }//������� ��������� ���
}
//+------------------------------------------------------------------+
