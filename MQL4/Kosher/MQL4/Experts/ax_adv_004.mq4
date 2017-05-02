//+------------------------------------------------------------------+
//|                                                   ax_adv_004.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property version   "1.00"
#property strict

#include <stdlib.mqh>

MqlRates g_mqlrates[];

MqlRates g_ready_bar;

int g_ticket=-1;//����� �������� ������
int g_delta_points=1;//
input double g_lots=0.01;//������ ����
input int g_slippage=3;//���������������
//input double g_gator_magic_value=1.00000018;//��������� ����� ������
//double g_gator_magic_value=1.001;//��������� ����� ������
double g_gator_wake_up_val=1.001;//������ �����������
double g_gator_sleep_val=1.0001;//����� ������� �����
input bool g_set_tp=false;//������������� ���� TakeProfit
int g_reversal_bar_cnt_wait=2;//������� ����� ����� ������������ �����, ����� ����� ���������
int g_order_count;//���������� ������� ������� 
double g_gator_bar_diff=1;//���������� ����� ������� � ����� (�����������) (� �����:))
double g_profit_coef=2.5;//������� TakeProfit � ��������� TakeProfit/StopLoss
input int g_gator_sleeps_bar_count=5;//����� ������� ����� ����������, ��� ����� ������� ����
int gator_sleep_bar_count=0;
int g_handle;
int g_orders_to_modify=0;

#include "ax_bar_utils.mqh"

double g_prev_ao_val=0;
ao_trend_mode g_AO_trend;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
 g_ticket=-1;//������ ���
 
 g_delta_points=1; 
 
 g_reversal_bar_cnt_wait=1;
 
 g_order_count=0; 

 g_gator_wake_up_val   =ax_bar_utils::get_gator_wake_up_val(); 
 g_gator_sleep_val     =ax_bar_utils::get_gator_sleep_val();
 
 gator_sleep_bar_count =0;
 
 g_orders_to_modify=0;
 
 //����� �������� �������� ���������� ��������������� ����
 ArrayCopyRates(g_mqlrates,NULL,0);

 g_ready_bar=g_mqlrates[1]; 
 
 //�������� ��� �������� ����� � �� ��� ���������� ������� �����
 g_prev_ao_val=iAO(NULL,0,1);
 
 double prev_ao_val2=iAO(NULL,0,2);
 
 g_AO_trend=AOTREND_HOR;
 
 if(g_prev_ao_val>prev_ao_val2)
  g_AO_trend=AOTREND_UP;

 if(g_prev_ao_val<prev_ao_val2)
  g_AO_trend=AOTREND_DOWN;
  
 string filename=Symbol()+"_"+IntegerToString(Period())+".log"; 
 
 g_handle=FileOpen(filename,FILE_WRITE|FILE_TXT); 
 
 if(g_handle<0) 
  Comment(filename,"\n",ErrorDescription(GetLastError())); 
 
 return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---
 FileClose(g_handle);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
 ArrayCopyRates(g_mqlrates,NULL,0);
   
 string msg="";
  
 if(!ax_bar_utils::is_equal(g_ready_bar,g_mqlrates[1]))//������� ��������� ���
 {
  g_ready_bar=g_mqlrates[1];//��� ����� ����� �������������� ��� - �������� � ���
  
///////////////////////////////////////  
/* double val_up=iFractals(NULL,0,MODE_UPPER,3);
 double val_down=iFractals(NULL,0,MODE_LOWER,3);
 
 Comment("UP:",DoubleToString(NormalizeDouble(val_up,Digits),Digits),"\n",
         "DOWN:",DoubleToString(NormalizeDouble(val_down,Digits),Digits));
 
 return;*/
//////////////////////////////////////
  
  
  
  
  if(ax_bar_utils::gator_waked_up())//����� ���������
  {
   gator_sleep_bar_count=0;
   
   //���������� ��� ������������� ����
   bar_types bar_type=ax_bar_utils::get_type(g_ready_bar,g_mqlrates[2]);
   
   if(bar_type!=BARTYPE_NONE)//��� �����������
   {
    if(ax_bar_utils::is_out_of_gator(g_ready_bar,bar_type))//����������� ��� ��� ������
    {
     //������ ����� �����
     if(bar_type==BARTYPE_BULLISH)//��������
     {
      string err_msg;    
      int ticket=ax_bar_utils::OpenOrder2(g_ready_bar,TRADEMODE_BUY,err_msg);
   
      if(ticket<0)
       msg+="[BUYSTOP]:"+err_msg;
      else
      {
       g_ticket=ticket;
       g_orders_to_modify++;
      }
     }//if ��������
    
     if(bar_type==BARTYPE_BEARISH)//�������
     {
      string err_msg;    
      int ticket=ax_bar_utils::OpenOrder2(g_ready_bar,TRADEMODE_SELL,err_msg);
   
      if(ticket<0)
       msg+="[SELLSTOP]:"+err_msg;
      else
      {
       g_ticket=ticket;
       g_orders_to_modify++;
      }
     }//if �������
    }//out of gator
   }//�����������
   else//������� (�� �����������)
   {
   }
  }//if gator �� ����
  else//gator ����
  {
   if(ax_bar_utils::gator_sleeps())//������, ��� ����� ��������
    gator_sleep_bar_count++;
   
   if(gator_sleep_bar_count>=g_gator_sleeps_bar_count)//���������, ��� ������� ������
   {
    //������������� ������� ��� ��������� ������
    //���� �������� ������� ���� ���������, �� �� ���� ��� ��� ����� �� ���������
    //������� �������� ���������� �� ��������� ���� ������� ������
    g_orders_to_modify=ax_bar_utils::CloseAllOrders();
   }
  }//����
  
  double ao_val=iAO(NULL,0,1);

  if(g_AO_trend==AOTREND_UP && ao_val<g_prev_ao_val)
  {
   //������������ � �������� �� ������� - ����� ����� � BUY �������
   g_AO_trend=AOTREND_DOWN;
   
   g_orders_to_modify=1;//��������� - ��� ����, ����� ��������� ������������ ������ ������ ���� �� ��������� ����
   
   //if(!g_set_tp)//������ ��� ������ ����� ������ - ������ �� ���������
   // g_orders_to_modify=ax_bar_utils::SetAllOrderSL(g_ready_bar,g_AO_trend);
  }
  
  if(g_AO_trend==AOTREND_DOWN && ao_val>g_prev_ao_val)
  {
   //������������ � �������� �� ������� - ����� ����� � SELL �������
   g_AO_trend=AOTREND_UP;
   
   g_orders_to_modify=1;//��������� - ��� ����, ����� ��������� ������������ ������ ������ ���� �� ��������� ����
   
   //if(!g_set_tp)
   // g_orders_to_modify=ax_bar_utils::SetAllOrderSL(g_ready_bar,g_AO_trend);
  }
  
  g_prev_ao_val=ao_val;
  
  //ax_bar_utils::WriteFile(g_handle,msg);
 }
 else//��� �� ����� ���
 {
  //�������� ��������� �� �������� ������ ����� ��� �� �����
  //����� ����� ��� g_gator_sleeps_bar_count ����� ������� � ����� ������ �����������
  //��� ���, ��� ���������, �� ���������, � ���������� ����� �������� ������, � ��� ��������� ������������ ����� �����
  if(!g_set_tp && g_orders_to_modify!=0)
   g_orders_to_modify=ax_bar_utils::SetAllOrderSL(g_ready_bar,g_AO_trend);
 }
 
 Comment(msg);
}
//+------------------------------------------------------------------+
