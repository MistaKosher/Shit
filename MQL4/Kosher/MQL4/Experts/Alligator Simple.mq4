//+------------------------------------------------------------------+
//|                                        Alligator Simple v1.1.mq4 |
//|                                               Nikolay Khrushchev |
//|                                         N.A.Khrushchev@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Nikolay Khrushchev"
#property link      "N.A.Khrushchev@gmail.com"
extern string qqqqqqqqq    = " ��������� ��������";
extern bool   Market_Exec  = false;
extern double Currency     = 1;
extern bool   EveryTick    = true;
extern int    TF           = 30;
extern double Lot          = 0.1;
extern double Prof         = 75;
extern double Loss         = 25;
extern double magic        = 2512201020;
extern string eeeeeeeee    = " ��������� �����";
extern bool   TrallEn      = true;
extern double TrallSt      = 30;
extern double TrallPp      = 10;
extern string wwwwwwwww    = " ��������� ���������";
extern double ChelPr       = 13;
extern double ChelSh       = 8;
extern double TeethPr      = 8;
extern double TeethSh      = 5;
extern double LipsPr       = 5;
extern double LipsSh       = 3;
extern int    MAmethod     = 2;
extern int    MAprice      = 4;
extern string sarase       = " MAprice 0,1,4,5,6";

int Ticket, TimeN;
bool TickeT, Work = true;
double TrallClosePrice,Pp;

//896896896869869869869869689686986986986986968869869869869689689686986986986986986968968986
void start()
   {
   Comment("Nikolay Khrushchev","\n","N.A.Khrushchev@gmail.com");
   if (TF*60 != Time[0]-Time[1]) return;
   if (EveryTick==false)
      {
      if(TimeN == Time[0]) return;
      TimeN = Time[0];
      }
   if (Work==false)
      {
      return;
      }
   for (int i=OrdersTotal()-1; i>=0; i--)   // ��������� �������� �������
      {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true) // ���� ���������
         {
         if (OrderMagicNumber()==magic)  // ��������� �������
            {
            if (TrallEn==true) Tralling(OrderTicket());
            return;
            }   
         }
      }
   double JAW = iAlligator(NULL, 0, ChelPr, ChelSh, TeethPr, TeethSh, LipsPr, LipsSh, MAmethod, MAprice, MODE_GATORJAW, 1);
   double TEETH = iAlligator(NULL, 0, ChelPr, ChelSh, TeethPr, TeethSh, LipsPr, LipsSh, MAmethod, MAprice, MODE_GATORTEETH, 1);
   double LIPS = iAlligator(NULL, 0, ChelPr, ChelSh, TeethPr, TeethSh, LipsPr, LipsSh, MAmethod, MAprice, MODE_GATORLIPS, 1);
   if(LIPS>TEETH && TEETH>JAW) OrderSendBuy();
   if(LIPS<TEETH && TEETH<JAW) OrderSendSell();
   return;
   }
//896896896869869869869869689686986986986986968869869869869689689686986986986986986968968986
void CloseOrders(int Nomber)
   {
   if(OrderSelect(Nomber,SELECT_BY_TICKET,MODE_TRADES)==true) // ���� ���������
      {
      if(OrderType()==OP_BUY)
        {
        while(true)
           {
           Ticket=OrderClose(OrderTicket(),OrderLots(),Bid,30,Black);
           if (Ticket > 0)                        
              {
              return;                             
              }
           if (Fun_Error(GetLastError())==1)      
              {
              continue;                           
              }
           }
        }
     if (OrderType()==OP_SELL)
        {
        while(true)
           {
           Ticket=OrderClose(OrderTicket(),OrderLots(),Ask,30,Black);
           if (Ticket > 0)                        
              {
              return;                            
              }
           if (Fun_Error(GetLastError())==1)      
              {
              continue;                           
              }
           }
        }
     }
   return;
   }
//896896896869869869869869689686986986986986968869869869869689689686986986986986986968968986
void OrderSendBuy()
   {
   double SL=Ask-Loss*Pp;
   double TP=Ask+Prof*Pp;
   if (Market_Exec) { SL=0; TP=0; }
   while(true)
      {
      TrallClosePrice= Ask-Loss*Pp;
      Ticket=OrderSend(Symbol(),OP_BUY,Lot,Ask,3,SL,TP,NULL,magic,0,Blue);  
      if (Ticket > 0) { Print ("������ ����� Buy ",Ticket); break; }
      if (Fun_Error(GetLastError())==1) { continue; }
      return;                               
      }
   if (Market_Exec)
      {
      SL=Ask-Loss*Pp;
      TP=Ask+Prof*Pp;
      while(true)
         {
         if(!OrderSelect(Ticket,SELECT_BY_TICKET,MODE_TRADES)) break;
         TickeT=OrderModify(Ticket,OrderOpenPrice(),SL,0,0,Black);
         if (Ticket==true) { Print ("������� ���������� ���� ����",OrderTicket()); break; }
         if (Fun_Error(GetLastError())==1) { continue; }
         break;                                
         }
      while(true)
         {
         if(!OrderSelect(Ticket,SELECT_BY_TICKET,MODE_TRADES)) break;
         TickeT=OrderModify(Ticket,OrderOpenPrice(),OrderStopLoss(),TP,0,Black);
         if (Ticket==true) { Print ("������� ���������� ���� ������",OrderTicket()); break; }
         if (Fun_Error(GetLastError())==1) { continue; }
         break;                                
         }
      }
   return;
   }
//+------------------------------------------------------------------+
void OrderSendSell()
   {
   double SL=Bid+Loss*Pp;
   double TP=Bid-Prof*Pp;
   if (Market_Exec) { SL=0; TP=0; }
   while(true)
      {
      TrallClosePrice= Bid+Loss*Pp;
      Ticket=OrderSend(Symbol(),OP_SELL,Lot,Bid,3,SL,TP,NULL,magic,0,Red);
      if (Ticket > 0) { Print ("������ ����� Sell ",Ticket); break; }
      if (Fun_Error(GetLastError())==1) { continue; }
      return;                                
      }
   if (Market_Exec)
      {
      SL=Bid+Loss*Pp;
      TP=Bid-Prof*Pp;
      while(true)
         {
         if(!OrderSelect(Ticket,SELECT_BY_TICKET,MODE_TRADES)) break;
         TickeT=OrderModify(Ticket,OrderOpenPrice(),SL,0,0,Black);
         if (Ticket==true) { Print ("������� ���������� ���� ����",OrderTicket()); break; }
         if (Fun_Error(GetLastError())==1) { continue; }
         break;                                
         }
      while(true)
         {
         if(!OrderSelect(Ticket,SELECT_BY_TICKET,MODE_TRADES)) break;
         TickeT=OrderModify(Ticket,OrderOpenPrice(),OrderStopLoss(),TP,0,Black);
         if (Ticket==true) { Print ("������� ���������� ���� ������",OrderTicket()); break; }
         if (Fun_Error(GetLastError())==1) { continue; }
         break;                                
         }
      }   
   return;
   }
//+------------------------------------------------------------------+
void Tralling(int Nomber)
   {
   if(OrderSelect(Nomber,SELECT_BY_TICKET,MODE_TRADES)==true)
      {
      if (OrderProfit()/OrderLots()/10/Currency >= TrallSt)
         {
         if (OrderType()==OP_BUY)
            {
            if (Ask>OrderOpenPrice())
               {
               if (Ask-TrallPp*Pp > TrallClosePrice) TrallClosePrice=Ask-TrallPp*Pp;
               if (Ask<=TrallClosePrice) CloseOrders(OrderTicket());
               }
            }
         if (OrderType()==OP_SELL)
            {
            if (Bid<OrderOpenPrice())
               {
               if (Bid+TrallPp*Pp < TrallClosePrice) TrallClosePrice=Bid+TrallPp*Pp;
               if (Bid>=TrallClosePrice) CloseOrders(OrderTicket());
               }
            }
         }
      }
   return;
   }
//896896896869869869869869689686986986986986968869869869869689689686986986986986986968968986
//896896896869869869869869689686986986986986968869869869869689689686986986986986986968968986
//896896896869869869869869689686986986986986968869869869869689689686986986986986986968968986
//896896896869869869869869689686986986986986968869869869869689689686986986986986986968968986
//896896896869869869869869689686986986986986968869869869869689689686986986986986986968968986
//896896896869869869869869689686986986986986968869869869869689689686986986986986986968968986
//896896896869869869869869689686986986986986968869869869869689689686986986986986986968968986
int Fun_Error(int Error)                        // �-�� ������� ������
  {
   switch(Error)
     {                                          // ����������� ������            
      case  4: Alert("�������� ������ �����. ������� ��� ���..");
         Sleep(3000);                           // ������� �������
         return(1);                             // ����� �� �������
      case 135:Alert("���� ����������. ������� ��� ���..");
         RefreshRates();                        // ������� ������
         return(1);                             // ����� �� �������
      case 136:Alert("��� ���. ��� ����� ���..");
         while(RefreshRates()==false)           // �� ������ ����
            Sleep(1);                           // �������� � �����
         return(1);                             // ����� �� �������
      case 137:Alert("������ �����. ������� ��� ���..");
         Sleep(3000);                           // ������� �������
         return(1);                             // ����� �� �������
      case 138:Alert ("������ ���");
         Sleep(3000);
         RefreshRates();
         return(1);
      case 146:Alert("���������� �������� ������. ������� ���..");
         Sleep(500);                            // ������� �������
         return(1);                             // ����� �� �������
         // ����������� ������
      case  2: Alert("����� ������.");
         return(0);                             // ����� �� �������
      case  5: Alert("������ ������ ���������.");
         Work=false;                            // ������ �� ��������
         return(0);                             // ����� �� �������
      case 64: Alert("���� ������������.");
         Work=false;                            // ������ �� ��������
         return(0);                             // ����� �� �������
      case 133:Alert("�������� ���������.");
         return(0);                             // ����� �� �������
      case 134:Alert("������������ ����� ��� ���������� ��������.");
         return(0);                             // ����� �� �������
      default: Alert("�������� ������ ",Error); // ������ ��������   
         return(0);                             // ����� �� �������
     }
  }
void init()
   {
   if (Point==0.0001 || Point==0.00001) Pp=0.0001;
   if (Point==0.01 || Point==0.001) Pp=0.01;
   return;
   }
void deinit()
   {
   return;
   }

