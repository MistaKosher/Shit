//+------------------------------------------------------------------+
//|                                          Sample_TrailingStop.mqh |
//|                                        MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

class CTrailingStop{
   protected:
      string m_symbol;              // ������
      ENUM_TIMEFRAMES m_timeframe;  // ���������
      bool m_eachtick;              // �������� �� ������ ����
      bool m_indicator;             // ���������� ��������� �� �������
      bool m_button;                // ���������� ������ ���������/����������
      int m_button_x;               // ���������� � ������
      int m_button_y;               // ���������� � ������
      color m_bgcolor;              // ���� ������
      color m_txtcolor;             // ���� ������� ������
      int m_shift;                  // �������� ����
      bool m_onoff;                 // ��������/���������
      int m_handle;                 // ����� ����������
      datetime m_lasttime;          // ����� ���������� ���������� �������� �����
      //MqlTradeRequest m_request;    // ��������� ��������� �������
     // MqlTradeResult m_result;      // ��������� ���������� ��������� �������
      int m_digits;                 // ���������� ������ ����� ������� � ����
      double m_point;               // �������� ������
      string m_objname;             // ��� ������
      string m_typename;            // ��� ���� �������� �����
      string m_caption;             // ������� �� ������
   public:   
   void CTrailingStop(){};
   void ~CTrailingStop(){};
   
      //--- ����� ������������� �������� �����
      void Init(string             symbol,
                ENUM_TIMEFRAMES timeframe,
                bool    eachtick  =  true,
                bool    indicator = false,
                bool    button    = false,
                int     button_x  =     5,
                int     button_y  =    15,
                color   bgcolor   = Silver,
                color   txtcolor  =   Blue)
           {
         //--- ��������� ����������
         m_symbol    = symbol;    // ������
         m_timeframe = timeframe; // ���������
         m_eachtick  = eachtick;  // true - �������� �� ������ ����, false - �������� ��� �� ��� 
            //--- ��������� ���� � �������� ������������ �������� ����������
            if(eachtick){ 
               m_shift=0; // ������������� ���, ��� ��������� ������
            }
            else{
               m_shift=1;  // �������������� ��� ��� �������� ������
            }          
         m_indicator = indicator; // true - ������������ ��������� �� ������
         m_button = button;       // true - ��������� ������ ��� ���������/���������� �������� �����
         m_button_x = button_x;   // ���������� � ������
         m_button_y = button_y;   // ���������� Y ������
         m_bgcolor = bgcolor;     // ���� ������
         m_txtcolor = txtcolor;   // ���� ������� �� ������   
         //--- ��������� ���������� �������� ����������     
         m_digits=(int)SymbolInfoInteger(m_symbol,SYMBOL_DIGITS); // ���������� ������ ����� ������� � ����
         m_point=SymbolInfoDouble(m_symbol,SYMBOL_POINT);         // �������� ������           
         //--- ������������ ����� ������ � ������� �� ���
         m_objname="CTrailingStop_"+m_typename+"_"+symbol;        // ��� ������
         m_caption=symbol+" "+m_typename+" Trailing";             // ������� �� ������
         //--- ���������� ��������� ��������� �������
         m_request.symbol=m_symbol;                               // ���������� ��������� ��������� �������, ��������� �������
         m_request.action=TRADE_ACTION_SLTP;                      // ���������� ��������� ��������� �������, ��������� ���� ��������� ��������
         //--- ������� ������
            if(m_button){ 
               ObjectCreate(0,m_objname,OBJ_BUTTON,0,0,0);                 // ��������
               ObjectSetInteger(0,m_objname,OBJPROP_XDISTANCE,m_button_x); // ��������� ���������� �
               ObjectSetInteger(0,m_objname,OBJPROP_YDISTANCE,m_button_y); // ��������� ���������� Y
               ObjectSetInteger(0,m_objname,OBJPROP_BGCOLOR,m_bgcolor);    // ��������� ����� ����
               ObjectSetInteger(0,m_objname,OBJPROP_COLOR,m_txtcolor);     // ��������� ����� �������
               ObjectSetInteger(0,m_objname,OBJPROP_XSIZE,120);            // ��������� ������
               ObjectSetInteger(0,m_objname,OBJPROP_YSIZE,15);             // ��������� ������
               ObjectSetInteger(0,m_objname,OBJPROP_FONTSIZE,7);           // ��������� ������� ������
               ObjectSetString(0,m_objname,OBJPROP_TEXT,m_caption);        // ��������� ������� 
               ObjectSetInteger(0,m_objname,OBJPROP_STATE,false);          // ��������� ��������� ������, �� ��������� ���������, ������
               ObjectSetInteger(0,m_objname,OBJPROP_SELECTABLE,false);     // ������������ �� ������ �������� � ���������� ������, ������ ��������
               ChartRedraw();                                              // ���������� ����������� ������� 
            }
         //--- ��������� ��������� �������� �����          
         m_onoff=false;                                                    // ��������� �������� ����� - �������/��������, �� ��������� ��������            
      };
      //--- ������ �������
      bool StartTimer(){
         return(EventSetTimer(1));
      };
      //--- ��������� �������
      void StopTimer(){
         EventKillTimer();
      };
      //--- ��������� �������� �����
      void On(){
         m_onoff=true; 
            // ���� ������������ ������, ��� ����������� � ������� ���������
            if(m_button){ 
               if(!ObjectGetInteger(0,m_objname,OBJPROP_STATE)){
                  ObjectSetInteger(0,m_objname,OBJPROP_STATE,true);
               }
            }
      }
      //--- ���������� �������� �����
      void Off(){ 
         m_onoff=false;
            // ���� ������������ ������, ��� ����������� � ������� ���������
            if(m_button){ 
               if(ObjectGetInteger(0,m_objname,OBJPROP_STATE)){
                  ObjectSetInteger(0,m_objname,OBJPROP_STATE,false);
               }
            }
      }   
      //--- �������� ����� ���������� ������� �������� �������   
      bool DoStoploss(){
            //--- ���� �������� ���� ��������
            if(!m_onoff){
               return(true);
            } 
         datetime tm[1];
            //--- � �������� ������ �������� ����� ���������� ����
            if(!m_eachtick){ 
               //--- ���� �� ������� ����������� �����, ��������� ������ ������, ������ ���������� �� ��������� ����, 
               if(CopyTime(m_symbol,m_timeframe,0,1,tm)==-1){
                  return(false); 
               }
               //--- ���� ����� ���� ����� ������� ���������� ���������� ������ - ��������� ������ ������
               if(tm[0]==m_lasttime){ 
                  return(true);
               }
            }               
            //--- �������� �������� ����������
            if(!Refresh()){ 
               return(false);
            }    
         double sl;                          
            //--- � ����������� �� ������ ������������� ����������� ��������� ��������� ��������
            switch (Trend()){ 
               //--- ����� �����
               case 1: 
                  //--- ��������� �������, ���� �� ������� ��������, ������ ������� ����������
                  if(PositionSelect(m_symbol)){ 
                     //--- ���� ������� buy
                     if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY){ 
                        //--- �������� �������� �������� ��� ������� buy
                        sl=BuyStoploss(); 
                        //--- ���������� ���������� ������� ��������� �������� ��� ������� buy
                        double minimal=SymbolInfoDouble(m_symbol,SYMBOL_BID)-m_point*SymbolInfoInteger(m_symbol,SYMBOL_TRADE_STOPS_LEVEL); 
                        //--- ������������ ��������
                        sl=NormalizeDouble(sl,m_digits); 
                        //--- ������������ ��������
                        minimal=NormalizeDouble(minimal,m_digits); 
                        //--- ���� �� ���������� �� ���������� ������� ���������� ���������� ��������, �� ����� ���������� �� ��������� ��������� �������
                        sl=MathMin(sl,minimal); 
                        //--- �������� �������� �������
                        double possl=PositionGetDouble(POSITION_SL); 
                        //--- ������������ ��������
                        possl=NormalizeDouble(possl,m_digits); 
                           //--- ���� ����� �������� �������� ����, ��� ������� �������� ��������, ����� ��������� ������� ����������� �������� �� ����� �������
                           if(sl>possl){ 
                              //--- ���������� ��������� �������
                              m_request.sl=sl; 
                              //--- ���������� ��������� �������
                              m_request.tp=PositionGetDouble(POSITION_TP); 
                              //--- ������
                              OrderSend(m_request,m_result); 
                                 //--- �������� ���������� ���������� �������
                                 if(m_result.retcode!=TRADE_RETCODE_DONE){ 
                                    //--- ����� � ������ ��������� �� ������ 
                                    printf("�� ������� ����������� �������� ������� %s, ������: %I64u",m_symbol,m_result.retcode); 
                                    //--- �� ������� ����������� ��������, ��������� ����������
                                    return(false); 
                                 }
                           }
                     }
                  }
               break;
               //--- ����� ����
               case -1: 
                  if(PositionSelect(m_symbol)){
                     if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL){
                        sl=SellStoploss();
                        //--- ������������ �����, ��������� sell ����������� �� ���� Ask
                        sl+=(SymbolInfoDouble(m_symbol,SYMBOL_ASK)-SymbolInfoDouble(m_symbol,SYMBOL_BID)); 
                        double minimal=SymbolInfoDouble(m_symbol,SYMBOL_ASK)+m_point*SymbolInfoInteger(m_symbol,SYMBOL_TRADE_STOPS_LEVEL);
                        sl=NormalizeDouble(sl,m_digits);
                        minimal=NormalizeDouble(minimal,m_digits);
                        sl=MathMax(sl,minimal);
                        double possl=PositionGetDouble(POSITION_SL);
                        possl=NormalizeDouble(possl,m_digits);
                           if(sl<possl || possl==0){
                              m_request.sl=sl;
                              m_request.tp=PositionGetDouble(POSITION_TP);
                              OrderSend(m_request,m_result);
                                 if(m_result.retcode!=TRADE_RETCODE_DONE){
                                    printf("�� ������� ����������� �������� ������� %s, ������: %I64u",m_symbol,m_result.retcode);
                                    return(false);
                                 }
                           }
                     }
                  }
               break;
            }
         //--- ���������� ����� ���������� ���������� ������
         m_lasttime=tm[0]; 
         return(true);
      }
      //--- ����� ������������ �������/������� ������
      void EventHandle(const int id,const long & lparam,const double& dparam,const string& sparam){
         //--- ���� ������� � �������
         if(id==CHARTEVENT_OBJECT_CLICK && sparam==m_objname){ 
            //--- �������� ��������� ������
            if(ObjectGetInteger(0,m_objname,OBJPROP_STATE)){ 
               On();  // ���������
            }
            else{
               Off(); // ����������
            }
         }
      }
      //--- ����� ���������������
      void Deinit(){
         StopTimer();                     // ��������� �������
         IndicatorRelease(m_handle);      // ������������ ������ ����������
            if(m_button){
               ObjectDelete(0,m_objname); // �������� ������
               ChartRedraw(); 
            }
      }
      //--- ����� ��� ��������� �������� ����������
      virtual bool Refresh(){
         return(false);
      }
      //--- ����� ��������� ���������� ����������
      virtual void SetParameters(){
      };
      //--- ����� ����������� ������ ������������� �����������
      virtual int Trend(){ 
         return(0);
      };
      //--- ����� ��������� �������� �������� ��� buy
      virtual double BuyStoploss(){
         return(0);
      };   
      //--- ����� ��������� �������� �������� ��� sell      
      virtual double SellStoploss(){
         return(0);
      };   
};

class CParabolicStop: public CTrailingStop {
   protected:
      double pricebuf[1]; // �������� ����
      double indbuf[1];   // �������� ����������
   public:  
      void  CParabolicStop(){
         m_typename="SAR"; // ��������� ����� ���� �������� �����
      };
      //--- ����� ��������� ���������� � �������� ����������
      bool SetParameters(double sarstep=0.02,double sarmaximum=0.2){
         //--- �������� ����������
         m_handle=iSAR(m_symbol,m_timeframe,sarstep,sarmaximum); 
            //--- ���� �� ������� ��������� ���������, ����� ���������� false
            if(m_handle==-1){
               return(false); 
            }
            if(m_indicator){
               //--- ������������� ���������� � �������
               ChartIndicatorAdd(0,0,m_handle); 
            }         
         return(true);
      }
      //--- ����� ��������� �������� ����������
      bool Refresh(){
            //--- ���� �� ������� ����������� �������� � ������, ������������ false
            if(CopyBuffer(m_handle,0,m_shift,1,indbuf)==-1){
               return(false); 
            } 
            //--- ���� �� ������� ����������� �������� � ������, ������������ false
            if(CopyClose(m_symbol,m_timeframe,m_shift,1,pricebuf)==-1){
               return(false); 
            }  
         return(true);                   
      }
      //--- ����� ����������� ������
      int Trend(){
            //--- ���� ���� ����� ����������, ����� �����
            if(pricebuf[0]>indbuf[0]){ 
               return(1);
            }
            //--- ���� ���� ����� ����������, ����� ����
            if(pricebuf[0]<indbuf[0]){ 
               return(-1);
            }            
         return(0);
      } 
      //--- ����� ����������� ������ �������� ��� buy
      virtual double BuyStoploss(){
         return(indbuf[0]);
      };   
      //--- ����� ����������� ������ �������� ��� sell
      virtual double SellStoploss(){
         return(indbuf[0]);
      };            
};  
      


class CNRTRStop : public CTrailingStop {
   protected:
   double sup[1]; // �������� ������ ���������
   double res[1]; // �������� ������ �������������  
   public:  
      void  CNRTRStop(){
         m_typename="NRTR"; // ��������� ����� ���� �������� �����
      };
      //--- ����� ��������� ���������� � �������� ����������
      bool SetParameters(int period,double k){
         m_handle=iCustom(m_symbol,m_timeframe,"NRTR",period,k); // �������� ����������
            //--- ���� �� ������� ��������� ���������, ����� ���������� false
            if(m_handle==-1){ 
               return(false); 
            }
            if(m_indicator){  
               //--- ������������� ���������� � �������
               ChartIndicatorAdd(0,0,m_handle); 
            }
         return(true);
      }
      //--- ����� ��������� �������� ����������
      bool Refresh(){
            //--- ���� �� ������� ����������� �������� � ������, ������������ false
            if(CopyBuffer(m_handle,0,m_shift,1,sup)==-1){
               return(false); 
            }      
            //--- ���� �� ������� ����������� �������� � ������, ������������ false
            if(CopyBuffer(m_handle,1,m_shift,1,res)==-1){
               return(false); 
            }              
         return(true);
      }
      //--- ����� ����������� ������
      int Trend(){
            //--- ���� ����� ���������, ������ ����� �����
            if(sup[0]!=0){ 
               return(1);
            }
            //--- ���� ����� �������������, ������ ����� ����
            if(res[0]!=0){ 
               return(-1);
            }            
         return(0);
      }

      //--- ����� ����������� ������ �������� ��� buy
      double BuyStoploss(){
         return(sup[0]);
      }; 
      //--- ����� ����������� ������ �������� ��� sell
      double SellStoploss(){
         return(res[0]);
      };       
};  
  



