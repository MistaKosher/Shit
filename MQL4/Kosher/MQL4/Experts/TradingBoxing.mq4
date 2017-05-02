//+------------------------------------------------------------------+
//|                                                TradingBoxing.mq4 |
//|                                                          PozitiF |
//|                                              mail: alex-w-@bk.ru |
//+------------------------------------------------------------------+
#property copyright "PozitiF"
#property link      "mail: alex-w-@bk.ru"

//------------------- ������� ��������� ��������� -------------------+
extern int     StopLoss          = 0;
extern int     TakeProfit        = 0;
extern double  DisplayStartLots  = 0.01;                                                           // � ������ ���� �������� ����������, ����� ����� � ���� ������
extern double  DisplayStepLot    = 0.01; 
extern int     MagicNumber       = 0;
extern bool    UseSound          = true;           // ������������ �������� ������                                                          // � ����� ����� �������� �������� ����� � ���� ������
//------------------ ���������� ���������� ��������� ----------------+
int     Slippage          = 0;                     // ����������� ���������� ���������� ���� ��� �������� ������� (������� �� ������� ��� �������).
string  NameFileSound     = "news.wav";            // ������������ ��������� �����
int     NumberOfTry       = 3;                     // ���������� ������� ��������� ��������.

int DeviationX=20, DeviationY=5;                   // �������� ������� +-px ��� ��� �������� ���������� ���������� ������ �� ������ ������

string   arrIdTl[3][9]={"HeaderDelete", "DeleteAll", "DeleteBuy", "DeleteSell", "DeleteBuyStop", "DeleteSellStop", "DeleteBuyLimit", "DeleteSellLimit", "HL_1",
                        "HeaderClose", "CloseAll", "CloseBuy", "CloseSell", "CloseBuyProfit", "CloseSellProfit", "CloseBuyLoss", "CloseSellLoss", "HL_2",
                        "HeaderOpen", "HL_3", "OpenBuy", "OpenSell", "HL_3.1", "HL_3.2", "NULL", "NULL", "NULL"};
string   arrTxTl[3][9]={"Delete Orders", "ALL", "Buy", "Sell", "Stop", "Stop", "Limit", "Limit", "�����������������������",
                        "Close Orders", "ALL", "Buy", "Sell", "Profit", "Profit", "Loss", "Loss", "�����������������������",
                        "Open Order", "�����������������������", "Buy", "Sell", "�����������������������", "� � � � � � � � � � � �", "NULL", "NULL", "NULL"};
string   arrFtTl[3][9]={"Times", "Georgia", "Georgia", "Georgia", "Georgia", "Georgia", "Georgia", "Georgia", "Terminal",
                        "Times", "Georgia", "Georgia", "Georgia", "Georgia", "Georgia", "Georgia", "Georgia", "Terminal",
                        "Times", "Terminal", "Georgia", "Georgia", "Terminal", "Terminal", "NULL", "NULL", "NULL"};
int      arrFsTl[3][9]={12, 10, 10, 10, 10, 10, 10, 10, 10,
                        12, 10, 10, 10, 10, 10, 10, 10, 10,
                        12, 10, 10, 10, 10, 10, , , };
color    arrClTl[3][9]={Black, Blue, Blue, Blue, Blue, Blue, Blue, Blue, Silver,
                        Black, Blue, Blue, Blue, Blue, Blue, Blue, Blue, Silver,
                        Black, Silver, Black, Black, Silver, Silver, , , , };
int      arrTl_X[3][9]={15, 60, 87, 28, 84, 23, 85, 24, 13,
                        20, 60, 87, 28, 83, 22, 86, 25, 13,
                        31, 13, 80, 22, 13, 13, , ,};
int      arrTl_Y[3][9]={28, 52, 70, 70, 90, 90, 110, 110, 45,
                        143, 167, 185, 185, 205, 205, 225, 225, 160,
                        258, 272, 280, 280, 294, 395, , ,};
int      arrBdTl[3][9]={1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1};
int      arrRtTl[3][9]={0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0};

//--------------- ����������� ������� ------------------

string   arrIdWs[3][5]={"CursorDelete","NULL","NULL","NULL","NULL",   "CursorClose","NULL","NULL","NULL","NULL",   "CursorBuy","CursorSell","PrevPageLots","NextPageLots","CursorList"};
string   arrFtWs[3][5]={"Wingdings","NULL","NULL","NULL","NULL",   "Wingdings","NULL","NULL","NULL","NULL",   "Wingdings","Wingdings","Wingdings","Wingdings","Wingdings"};
int      arrNmWs[3][5]={164, , , , ,   164, , , , ,   164, 164, 215, 216, 164};
int      arrWs_X[3][5]={110, , , , ,
                        110, , , , ,
                        110, 50, 95, 32, 63};
int      arrWs_Y[3][5]={30, , , , ,
                        145, , , , ,
                        280, 280, 403, 403, 403};
int      arrFsWs[3][5]={12, , , , ,   12, , , , ,   12, 12, 12, 12, 12};
color    arrClWs[3][5]={Blue, , , , ,   Blue, , , , ,   Blue, Blue, Green, Green, Blue};
int      arrBdWs[3][5]={1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1};
int      arrRtWs[3][5]={0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,};

//----------------------- ����� ��� ������ -----------------------
string   FrId[3][1]={"FrameDelete", "FrameClose", "FrameOpen"};
int      Fr_X[3][1]={5,5,5};
int      Fr_Y[3][1]={20,135,250};
int      FrWh[3][1]={25,25,25};
int      FrHt[3][1]={9,9,14};
int      FrTy[3][1]={1,1,1};
color    FrCl[3][1]={Black,Black,Black};
int      FrBd[3][1]={1,1,1};
//---------------------- ������� ��� -----------------------------
string   BgId[3][1]={"NULL","NULL","NULL"};
int      Bg_X[3][1]={0,0,0};
int      Bg_Y[3][1]={0,0,0};
int      BgWh[3][1]={0,0,0};
int      BgHt[3][1]={0,0,0};
int      BgTy[3][1]={2,2,2};
color    BgCl[3][1]={Black, Black, Black};
//--------------------- ������������ ����� -----------------------
string   VlId[3][1]={"VL_1", "VL_2", "NULL"};
string   VlTx[3][1]={"�","�","NULL"};                                   //--- ��� ������������ ����� �� ������ Terminal
int      Vl_X[3][1]={70,70,0};
int      Vl_Y[3][1]={75,188,0};
int      VlBd[3][1]={1,1,0};                                            //--- ���� �������� ����� (� ���� ���� ���������)
int      VlHt[3][1]={4, 4, 0};                                        //--- ������ ����� �������� (1 ������ 12 px)
color    VlCl[3][1]={Silver, Silver, CLR_NONE};


//------------- ���� ----------------
//--- ����� �����, ����������� ����� OpenOrder, �������� (��������) � ��������� �������, ������������� �����������.
double   arrLots[10];                                                   // ������ ����������� �����������, ��� �������� �������� ID � ��� �� ������� ����� TextLabel.
int      arrLotsX[10]={84,84,84,84,84,24,24,24,24,24};
int      arrLotsY[10]={300,320,340,360,380,300,320,340,360,380};

color    LtCl=Blue;
string   LtFt="Times";
int      LtFs=12;
int      LtBd=1;

//---------------- ����������� ���������� ��� ��������� -------------
string   arrCursorId[]={"CursorDelete", "CursorClose", "CursorBuy", "CursorSell", "CursorList"};      //--- ID �������� (����������� �����) ����������� ������� ���������� �����������.
string   arrBoxDelete[]={"DeleteAll", "DeleteBuy", "DeleteSell", "DeleteBuyStop", "DeleteSellStop", "DeleteBuyLimit", "DeleteSellLimit"};      // �������� �� ������� ���������� ���������� ������, �������� ��������� � ������� �������, ����� �������� ���������� �� ������� !
string   arrBoxClose[]={"CloseAll", "CloseBuy", "CloseSell", "CloseBuyProfit", "CloseSellProfit", "CloseBuyLoss", "CloseSellLoss"};
string   arrBoxList[]={"PrevPageLots","NextPageLots"};
int      arrCursorPos_X[5];                                                                           // ����������� ��������������� ������������ ��������, ��� ������������ ���������.
int      arrCursorPos_Y[5];
bool     arrShowBox[3]={true, true, true};                                                            // ����� ����� ���������� �� �������
int      arrHightBox[3][1]={200, 200, 200};                                                           // ������ ������� �����, ���������� ����� ����������� �������� ���� ��� ������


//--------------------- ������������ ���������� ---------------------+
#include      <stdlib.mqh>                                                 // ����������� ���������� ��4

//+------------------------------------------------------------------+
//| #############--- expert initialization function ---############# |
//+------------------------------------------------------------------+
int init()
{
//----
   FillArrLots(arrLots, DisplayStartLots, DisplayStepLot, "+");
   SetLabelLots(arrLots, arrLotsX, arrLotsY, LtFt, LtFs, LtCl, LtBd);
   start();
//----
   return(0);
}
//+------------------------------------------------------------------+
//| ###########--- expert deinitialization function ---############# |
//+------------------------------------------------------------------+
int deinit()
{
//----
   ObjectsDeleteAll();
//----
   return(0);
}
//+------------------------------------------------------------------+
//| ##############---  expert start function ---#################### |
//+------------------------------------------------------------------+
int start()
{
//----------------- Variable Initialization -------------------------+
   static int posX, posY, point=-1;
   int i, objId=-1;
   static bool Checked;
   string id="NULL";
   double lot;
//----
   
   //--- ������������ ��� �������� ���������� ������� � ��������� �����, ��� ������ �������.
   Checked=false;
   //--- �������������� ��������� ������.
   DisplayBox(arrShowBox);
   
   
   while(!IsStopped()&&IsExpertEnabled()){
      RefreshRates();
      
      //------------------ ���� ��������� ���������� ������� ����� --------------------
      //----- ��������� ������ ������������ ����� �������� ����������, ������ ���� ��� --------
      if(!Checked){
         for(i=0; i<ArraySize(arrCursorPos_X); i++){
            if(ObjectFind(arrCursorId[i])>=0){
               arrCursorPos_X[i]=ObjectGet(arrCursorId[i], OBJPROP_XDISTANCE);             // X - ����������
               arrCursorPos_Y[i]=ObjectGet(arrCursorId[i], OBJPROP_YDISTANCE);             // Y - ����������
            }
         }
         Checked=true;
      }
      //-------- ��������� �� ���������� �� �������������� ������ ���� ������� (����������� �����) ---------
      //--- ���� ���������� �� �������� � ���������� "ID"- id ������� ������� ������� ��� �������������� ------
      //-------------- ��� �� ��������� ���������� posX � posY ������������ ���� ��� ��������� ������ ---------------
      if(Checked){
         for(i=0; i<ArraySize(arrCursorPos_X); i++){
            if(ObjectFind(arrCursorId[i])>=0){
               if((arrCursorPos_X[i] != ObjectGet(arrCursorId[i], OBJPROP_XDISTANCE)) || (arrCursorPos_Y[i] != ObjectGet(arrCursorId[i], OBJPROP_YDISTANCE))){
                  posX=ObjectGet(arrCursorId[i], OBJPROP_XDISTANCE);
                  posY=ObjectGet(arrCursorId[i], OBJPROP_YDISTANCE);
                  point=i;
                  Redraw();                 // ������������ �����.
               }
               else{
                  if(point==i){
                     id=arrCursorId[point];
                     point=-1;
                  }
               }
            }
         }
      }
      //--- ������� ����� ���� ������ �������, � ���������� ������ � ����������� �������.
      if(posX>0||posY>0 && id != "NULL"){
         if(id=="CursorDelete"){
            objId=ObjectSearch(arrBoxDelete ,posX, posY, DeviationX, DeviationY);
            if(objId>=0){
               switch(objId){
                  case 0: Print("#Delete Orders, All"); DeleteOrders(); break;
                  case 1: Print("#Delete Orders, Buy"); DeleteOrders("", OP_BUYSTOP); DeleteOrders("", OP_BUYLIMIT); break;
                  case 2: Print("#Delete Orders, Sell"); DeleteOrders("", OP_SELLSTOP); DeleteOrders("", OP_SELLLIMIT); break;
                  case 3: Print("#Delete Orders, BuyStop"); DeleteOrders("", OP_BUYSTOP); break;
                  case 4: Print("#Delete Orders, SellStop"); DeleteOrders("", OP_SELLSTOP); break;
                  case 5: Print("#Delete Orders, BuyLimit"); DeleteOrders("", OP_BUYLIMIT); break;
                  case 6: Print("#Delete Orders, SellLimit"); DeleteOrders("", OP_SELLLIMIT); break;
               }
               objId=-1;
               posX=0;
               posY=0;
            }
         }
         if(id=="CursorClose"){
            objId=ObjectSearch(arrBoxClose, posX, posY, DeviationX, DeviationY);
            if(objId>=0){
               switch(objId){
                  case 0: Print("#Close Orders, All"); CloseOrders(); break;
                  case 1: Print("#Close Orders, Buy"); CloseOrders("", OP_BUY); break;
                  case 2: Print("#Close Orders, Sell"); CloseOrders("", OP_SELL); break;
                  case 3: Print("#Close Orders, Buy Profit"); CloseOrders("", OP_BUY, 1); break;
                  case 4: Print("#Close Orders, Sell Profit"); CloseOrders("", OP_SELL, 1); break;
                  case 5: Print("#Close Orders, Buy Loss"); CloseOrders("", OP_BUY, 0); break;
                  case 6: Print("#Close Orders, Sell Loss"); CloseOrders("", OP_SELL, 0); break;
               }
               objId=-1;
               posX=0;
               posY=0;
            }
         }
         if(id=="CursorBuy"){
            lot=GetLot(posX, posY, arrLots, DeviationX, DeviationY);
            if(lot>0){
               Print("#Open Order, Buy: "+DoubleToStr(lot, 2));
               OpenOrder("", OP_BUY, lot, StopLoss, TakeProfit, MagicNumber);
            }
            posX=0;
            posY=0;
         }
         if(id=="CursorSell"){
            lot=GetLot(posX, posY, arrLots, DeviationX, DeviationY);
            if(lot>0){
               Print("#Open Order, Sell: "+DoubleToStr(lot, 2));
               OpenOrder("", OP_SELL, lot, StopLoss, TakeProfit, MagicNumber);
            }
            posX=0;
            posY=0;
         }
         if(id=="CursorList"){
            objId=ObjectSearch(arrBoxList, posX, posY, DeviationX, DeviationY);
            if(objId>=0){
               if(objId==0){ 
                  ClearDisplayLots(arrLots);
                  FillArrLots(arrLots, DisplayStartLots, DisplayStepLot, "-");
                  SetLabelLots(arrLots, arrLotsX, arrLotsY, LtFt, LtFs, LtCl, LtBd);
               }
               if(objId==1){ 
                  ClearDisplayLots(arrLots);
                  FillArrLots(arrLots, DisplayStartLots, DisplayStepLot, "+");
                  SetLabelLots(arrLots, arrLotsX, arrLotsY, LtFt, LtFs, LtCl, LtBd);
               }
               objId=-1;
               posX=0;
               posY=0;
            }
         }
         id="NULL";
      }
   //------------------------------------------------------------------
   WindowRedraw();
   Sleep(50); 
   }
//----
   return(0);
}
//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ������� ��������� ������ ������, ��������� �� 10 ���, �������    |
//| ��������� ����� ��� (�������� 0.01) � ����������, �����������    |
//| �������� (0.01, 0.02, �.�.�) ��� ��������� (0.09, 0.08, 0.07)    |
//| ��� ����, 0 ������ ������� ������ ����� ���������� ���.          |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   arr   - ������ �� ������ ������ ����� ���������.               |
//|   start - � ������ ���� �������� ��������� ������ ������������   |
//|           ������ ��� ������ ���������� �������.                  |
//|   kl    - ���� + ��������� �������� � �������, - ���������.      |  
//+------------------------------------------------------------------+
void FillArrLots(double& arr[], double start=0.01, double step=0.01, string kl="+"){
//---   
   double minLot, maxLot, stepLot, max, min, res;
//---   
   minLot=MarketInfo(Symbol(), MODE_MINLOT);
   maxLot=MarketInfo(Symbol(), MODE_MAXLOT);
   stepLot=MarketInfo(Symbol(), MODE_LOTSTEP);
   
   start=MathMax(minLot, start);
   step=MathMax(stepLot, step);
   
   start=NormalizeDouble(start, 2);
   step =NormalizeDouble(step, 2);
   
   if(arr[0]==0){
      res=start;
      for(int x=0; x<10; x++){
         arr[x]=NormalizeDouble(res, 2);
         res+=step;
      }
   }
   else{
      max=arr[9];
      min=arr[0];
      max+=step;
      min-=step;
      for(int i=0; i<10; i++){
         if(kl=="+"){
            if(max<maxLot){
               arr[i]=NormalizeDouble(max, 2);
               max+=step;
            }
         }
         if(kl=="-"){
            if(min>minLot){
               arr[9-i]=NormalizeDouble(min, 2);
               min-=step;
            }
         }
      }
   }
   //ArraySort(arr);
}
//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ������� ���������� ��� ���������� ������� ���� bool.             |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   arr1 - ������ ������ ��� ���������                             |
//|   arr2 - ������ ������                                           |
//+------------------------------------------------------------------+
bool ComparingArray(bool& arr1[], bool& arr2[]){
   if(ArraySize(arr1)!=ArraySize(arr2))return(false);
   for(int i=0; i<ArraySize(arr1); i++) if(arr1[i]!=arr2[i])return(false);
 return(true);
}
//+------------------------------------------------------------------+
//| �������� ����� ��������.                                         |
//+------------------------------------------------------------------+
void Redraw(){
   for(int b=0; b<ArrayRange(arrShowBox, 0); b++){
      for(int ws=0; ws<ArrayRange(arrIdWs, 1); ws++){
         //--- ������ ����������� �����.
         if(arrIdWs[b][ws]!="NULL")SetWingdings(arrIdWs[b][ws], arrNmWs[b][ws], arrWs_X[b][ws], arrWs_Y[b][ws], arrClWs[b][ws], arrBdWs[b][ws], arrFtWs[b][ws], arrFsWs[b][ws], 0, arrRtWs[b][ws]);
      }
   }
}
//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ������� ��������� ����� �����, � ����.                           |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   lots- ������ ������� �����                                     |
//|   pos_x - ������ � ������������, X                               |
//|   pos_y - ������ � ������������, Y                               |
//|   ft    - �����                                                  |
//|   fs    - ������ ������                                          |
//|   cl    - ����                                                   |
//|   bd    - �������� � ����                                        |
//+------------------------------------------------------------------+
void SetLabelLots(double& lots[], int& pos_x[], int& pos_y[], string ft, int fs, color cl, int bd){
//---
   string stLot;
//---   
   for(int i=0; i<ArraySize(lots); i++){
      stLot=DoubleToStr(lots[i], 2);
      SetLabelText(stLot, stLot, pos_x[i], pos_y[i], cl, bd, ft, fs);
   }
}
//+------------------------------------------------------------------+
//| ������� ����������� ��������� ������, ���������� �� ����������.  |
//| int 1-�������� ������ ����, 2-������... -1 ���                   | 
//| vw true-�������� ����, false ������ ����                         |                  
//+------------------------------------------------------------------+
void DisplayBox(bool& arr[]){

   for(int b=0; b<ArraySize(arr); b++){
      if(arr[b]){
         for(int tx=0; tx<ArrayRange(arrIdTl,1); tx++) if(arrIdTl[b][tx]!="NULL")SetLabelText(arrIdTl[b][tx], arrTxTl[b][tx], arrTl_X[b][tx], arrTl_Y[b][tx], arrClTl[b][tx], arrBdTl[b][tx], arrFtTl[b][tx], arrFsTl[b][tx], 0, arrRtTl[b][tx]);
         for(int ws=0; ws<ArrayRange(arrIdWs,1); ws++) if(arrIdWs[b][ws]!="NULL")SetWingdings(arrIdWs[b][ws], arrNmWs[b][ws], arrWs_X[b][ws], arrWs_Y[b][ws], arrClWs[b][ws], arrBdWs[b][ws], arrFtWs[b][ws], arrFsWs[b][ws], 0, arrRtWs[b][ws]);
         for(int vl=0; vl<ArrayRange(VlId,1); vl++)if(VlId[b][vl]!="NULL")SetVerticalLine(VlId[b][vl], Vl_X[b][vl], Vl_Y[b][vl], VlTx[b][vl], VlHt[b][vl], VlBd[b][vl], VlCl[b][vl]);
         for(int fr=0; fr<ArrayRange(FrId,1); fr++)if(FrId[b][fr]!="NULL")CreateFrame(FrId[b][fr], FrTy[b][fr], Fr_X[b][fr], Fr_Y[b][fr], FrWh[b][fr], FrHt[b][fr], FrCl[b][fr], FrBd[b][fr]);
      }
      else{
         for(int dx=0; dx<ArrayRange(arrIdTl,1); dx++)if(ObjectFind(arrIdTl[b][dx])>=0)SetLabelText(arrIdTl[b][dx]);
         for(int ds=0; ds<ArrayRange(arrIdWs,1); ds++)if(ObjectFind(arrIdWs[b][ds])>=0)SetWingdings(arrIdWs[b][ds]);
         for(int dl=0; dl<ArrayRange(VlId,1); dl++)if(ObjectFind(VlId[b][dl])>=0)SetVerticalLine(VlId[b][vl]);
         for(int dr=0; dr<ArrayRange(FrId,1); dr++)if(ObjectFind(FrId[b][dr])>=0)CreateFrame(FrId[b][dr]);
      }
   }
}
//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ������ ������������ ����� ������� Terminal.                      |
//| ���� ���������� X-Y �� �������� �� ������� �����.                |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   id       - ID                                                  |  
//|   x        - ���������� � ��������, �� �����������               |
//|   y        - ���������� � �������� �� ���������                  |
//|   tx       - ����� (��� ����� �� ������ Terminal)                |
//|   bd       - ����� ����� � (� �������� 1, ������ = 12 px)        |
//|   corner   - ���� ��������                                       |
//|   cl       - ����                                                |
//+------------------------------------------------------------------+
void SetVerticalLine(string id="", int x=0, int y=0, string tx="", int length=0, int bd=0, color cl=CLR_NONE){
   for(int i=0; i<length; i++){
      if(x>0 && y>0)SetLabelText(id+"_:"+i, tx, x, y+(i*12), cl, bd, "Terminal", 10);
      else if(ObjectFind(id+"_:"+i)>=0)ObjectDelete(id+"_:"+i);
   }
}
//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ������ ����������� ������� (��� ����)                            |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   id       - ID                                                  |
//|   ty       - ��� ����(�� 0 �� 3)                                 |
//|   x        - ���������� � ��������, �� �����������               |
//|   y        - ���������� � �������� �� ���������                  |
//|   width    - ������ �������� �������� (1 ������ 5 px � ������)   |
//|   height   - ������ �������� �������� (1 ������ 12 px � ������)  |
//|   cl       - ����                                                |
//|   bd       - �������� � ����                                     |
//+------------------------------------------------------------------+
void CreateBackground(string id="", int ty=0, int x=0, int y=0, int width=0, int height=0, color cl=Black, int bd=0){
// ����� 12 = 12-�������� � ������ (������� ������), � 5 �������� � ������ (������)
//---
string line, type[]={"�","�","�","�"};
//---
   for(int tb=0; tb<width; tb++)line=StringConcatenate(line, type[ty]);
   for(int vl=0; vl<height; vl++)SetLabelText(id+"bc"+vl, line, x-3, y+(vl*12), cl, bd, "Terminal", 12);
}
//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ������ ������� (�����)                                           |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   id       - ID                                                  |
//|   ty       - ��� ����� (�� 0 �� 3)                               |
//|   x        - ���������� � ��������, �� �����������               |
//|   y        - ���������� � �������� �� ���������                  |
//|   width    - ������ �������� �������� (1 ������ 5 px � ������)   |
//|   height   - ������ �������� �������� (1 ������ 12 px � ������)  |
//|   cl       - ����                                                |
//|   bd       - �������� � ����                                     |
//+------------------------------------------------------------------+   
void CreateFrame(string id="", int ty=0, int x=0, int y=0, int width=0, int height=0, color cl=Gold, int bd=0){
// ����� 12 = 12-�������� � ������ (������� ������), � 5 �������� � ������ (������)
//---
string top_ab, bot_cd;
//---
string arrA[]={"�", "�", "�", "�"};    // ����� ������� ����
string arrB[]={"�", "�", "�", "�"};    // ������ ������� ����
string arrC[]={"�", "�", "�", "�"};    // ������ ������ ����
string arrD[]={"�", "�", "�", "�"};    // ����� ������ ����
string arrH[]={"�", "�", "�", "�"};    // �������������� �����
string arrV[]={"�", "�", "�", "�"};    // ������������ �����
//---
   top_ab=arrA[ty];
   bot_cd=arrD[ty];
   for(int tb=0; tb<width-1; tb++){
      top_ab=StringConcatenate(top_ab, arrH[ty]);
      bot_cd=StringConcatenate(bot_cd, arrH[ty]);
   }
   top_ab=StringConcatenate(top_ab, arrB[ty]);
   bot_cd=StringConcatenate(bot_cd, arrC[ty]);
   
   if(x!=0&&y!=0){
      SetLabelText(id+"_ab", top_ab, x, y, cl, bd, "Terminal", 12);
      SetLabelText(id+"_cd", bot_cd, x, y+height*12, cl, bd, "Terminal", 12);
   }else{
      if(ObjectFind(id+"_ab")>=0)ObjectDelete(id+"_ab");
      if(ObjectFind(id+"_cd")>=0)ObjectDelete(id+"_cd");
   }
   for(int vl=0; vl<height-1; vl++){
      if(x!=0&&y!=0){
         SetLabelText(id+"_bc:"+vl, arrV[ty], x, y+12+(vl*12), cl, bd, "Terminal", 12);
         SetLabelText(id+"_da:"+vl, arrV[ty], x+width*5, y+12+(vl*12), cl, bd, "Terminal", 12);
      }else{
         if(ObjectFind(id+"_bc:"+vl)>=0)ObjectDelete(id+"_bc:"+vl);
         if(ObjectFind(id+"_da:"+vl)>=0)ObjectDelete(id+"_da:"+vl);
      }
   }
}
//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ������ ��������� �����                                          |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   id  - ������������� ����� (���������� ���)                     |
//|   tx  - ����� �����                                              |
//|   x   - ���������� � ��������, �� �����������                    |
//|   y   - ���������� � �������� �� ���������                       |
//|   cl  - ����                                                     |
//|   bd  - Binding, ���� �������� ������� 0-3                       |
//|   ft  - �����                                                    |
//|   sz  - ������ ������                                            |
//|   wd  - ����� ���� � ������� ��������� �����                     |
//|   rt  - �������� ������� � ��������                              |
//+------------------------------------------------------------------+
void SetLabelText(string id, string tx="NULL", int x=0, int y=0, color cl=Black, int bd=0, string ft="Georgia", int sz=12, int wd=0, int rt=0){
   //--- ���� ����� ��� ���� �� �� �������� ���������� �� ������� ---
   if(tx!="NULL"){
      if(ObjectFind(id)<0)ObjectCreate(id, OBJ_LABEL, wd, 0, 0);
      ObjectSetText(id, tx, sz, ft, cl);
      ObjectSet(id, OBJPROP_CORNER, bd);
      ObjectSet(id, OBJPROP_XDISTANCE, x);
      ObjectSet(id, OBJPROP_YDISTANCE, y);
      ObjectSet(id,OBJPROP_ANGLE,rt);
   }else{
      if(tx=="NULL"&&ObjectFind(id)>=0)ObjectDelete(id);
   }
}

//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ������ ����������� ����� �� ������ Wingdings 2, 3.              |
//| ���� ����� ������� =0 �� ����� ���������.                        |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   id  - ������������� ����� (���������� ���)                     |
//|   nm  - ����� ������� �� ������ Wingdings (��� 0- �������)       |
//|   x   - ���������� � ��������, �� �����������                    |
//|   y   - ���������� � �������� �� ���������                       |
//|   cl  - ����                                                     |
//|   bd  - Binding, ���� �������� ������� 0-3                       |
//|   ft  - �����                                                    |
//|   sz  - ������ ������                                            |
//|   wd  - ����� ���� � ������� ��������� �����                     |
//|   rt  - �������� ������� � ��������                              |
//+------------------------------------------------------------------+
void SetWingdings(string id, int nm=0, int x=0, int y=0, color cl=Black, int bd=0, string ft="Wingdings", int sz=12, int wd=0, int rt=0){
   if(x!=0&&y!=0){
      if(ObjectFind(id)<0)ObjectCreate(id,OBJ_LABEL,wd,0,0,0,0);
      ObjectSetText(id, CharToStr(nm), sz, ft, cl);
      ObjectSet(id, OBJPROP_CORNER, bd);
      ObjectSet(id, OBJPROP_XDISTANCE, x);
      ObjectSet(id, OBJPROP_YDISTANCE, y);
      ObjectSet(id,OBJPROP_ANGLE,rt);
   }else{
      if(ObjectFind(id)>=0)ObjectDelete(id);
   }
}
//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ������� ���������� ������ ����.                                  |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   posX     - ������� ������� �� �����������                      |
//|   posY     - ������� ������� �� ���������                        |
//|   masLot   - ������ ������� �����                                |
//|   devX     - ����������� �������� ������� �� �����������         |
//|   devY     - ����������� �������� ������� �� ���������           |
//+------------------------------------------------------------------+
double GetLot(int posX, int posY, double& masLot[], int devX, int devY){
//---   
   string stLot;
   int x, y, numId=-1;
//----
   for(int i=0; i<ArraySize(masLot); i++){
      stLot=DoubleToStr(masLot[i], 2);
      if(ObjectFind(stLot)>=0){
         x=ObjectGet(stLot, OBJPROP_XDISTANCE);
         y=ObjectGet(stLot, OBJPROP_YDISTANCE);
         if(((posX>=x && posX <= x+devX) || (posX<=x && posX>=x-devX))&&((posY>=y && posY<=y+devY) || (posY<=y && posY>=y-devY))){
            if(numId<0) numId=i;
            else{
               Print("#Error, ObjectSearch(): ������� 2 �������. ���������� ��� ���, ��� ��������� ����������� ��������.");
               numId=-1;
               break;
            }
         }
      }
   }
return(masLot[numId]);
}
//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ������� ����� �� ����� � ������.                                 |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   lots - ������ � ��������� ����� ������� ������������ �� ������ |
//+------------------------------------------------------------------+
void ClearDisplayLots(double& lots[]){
//---
   string stLot;
//---
   for(int i=0; i<ArraySize(lots); i++){
      stLot=DoubleToStr(lots[i], 2);
      if(ObjectFind(stLot)>=0)ObjectDelete(stLot);
   }
}
//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ���������� ��������� �������� �������� ��������.                 |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   op - ��������� �������� (OP_BUY .... �.�.�)                    |
//+------------------------------------------------------------------+
string GetOperation(int op){
//---
   string stOp=NULL;
//---
   switch(op){
      case 0: stOp="Buy"; break;
      case 1: stOp="Sell"; break;
      case 2: stOp="BuyLimit"; break;
      case 3: stOp="SellLimit"; break;
      case 4: stOp="BuyStop"; break;
      case 5: stOp="SellStop"; break;
      default: Print("#Error, GetOperation(): �������� ������, ��� �������� �� ��������."); break;
   }
  return(stOp);
}
//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ������� �������� ������������, �� ���������� ���������� �������  |
//| � ������ ��� �������� �� ������� ������, ������� ����������     |
//| ������ ���������� �������.                                       |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   arrObj   - ������ ��� �������� ��� ������ ��������.           |
//|   posX     - ���������� ������� �� �����������                   |
//|   posY     - ���������� ������� �� ���������                     |
//|   devX     - ����������� �������� �� �����������                 |
//|   devY     - ����������� �������� �� ���������                   |
//+------------------------------------------------------------------+
int ObjectSearch(string& arrObj[], int posX, int posY, int devX, int devY){
   int numId=-1, x, y;   
   for(int i=0; i<ArraySize(arrObj); i++){
      if(ObjectFind(arrObj[i])>=0){
         x=ObjectGet(arrObj[i], OBJPROP_XDISTANCE);
         y=ObjectGet(arrObj[i], OBJPROP_YDISTANCE);
         if(((posX>=x && posX <= x+devX) || (posX<=x && posX>=x-devX))&&((posY>=y && posY<=y+devY) || (posY<=y && posY>=y-devY))){
            if(numId<0) numId=i;
            else{
               Print("#Error, ObjectSearch(): ������� 2 �������. ���������� ��� ���, ��� ��������� ����������� ��������.");
               numId=-1;
               break;
            }
         }
      }
   }
return(numId);
}
//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ��������� ���� �����, ��� ������ �������.                        |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   sy - Symbol ���("" - ������� ������, "all"- ����� ������)      |
//|   op - ��� ������ OP_BUY, OP_SELL (-1) ����� ���                 |
//|   pr - (1)-������ ���������, (0)-���������, (-1) ���.            |
//|   tk - ����� ������ (0 ���� ����� ��� ������,(-1) ��� ������)    |
//|   mn - Magic ��� (-1) ����� �����                                |
//|   cl - ���� ��������� �������� ������                            |
//+------------------------------------------------------------------+
void CloseOrders(string sy="", int op=-1, int pr=-1, int tk=-1, int mn=-1, color cl=CLR_NONE){
//---
   int orCx, err, orType;
   double clPr, prBid, prAsk;
//---
   if(sy=="")sy=Symbol();
   if(tk>0||tk==0)orCx=1;
   else orCx=OrdersTotal();
   
   for(int i=orCx; i>0; i--){
      //--------------- ������� ������� ���������� �������� ��� ������� ----------
      for(int cx=0; cx<NumberOfTry; cx++){
         if(tk>0 && tk!=0){
            //--- ���� ������� �����
            if(!OrderSelect(tk, SELECT_BY_TICKET, MODE_TRADES)){
               err = GetLastError();
               Print("Error(",err,") CloseOrders() -> OrderSelect(): ",ErrorDescription(err));
               continue;
            }
         }
         //-------------- ���� ������ ��� ���������� �� ���� ������� ---------
         if(tk<0){
            if(!OrderSelect(i-1, SELECT_BY_POS, MODE_TRADES)){
               err = GetLastError();
               Print("Error(",err,"), CloseOrders() -> OrderSelect() ",ErrorDescription(err));
               continue;
            }
         }
         orType=OrderType();
         if((orType==OP_BUY)||(orType==OP_SELL)){
            if((sy==OrderSymbol()||sy=="all")&&(mn==OrderMagicNumber()||mn<0)){
               if((op<0)||(op==orType)){
                  if(((pr>0)&&(OrderProfit()>0))||((pr==0)&&(OrderProfit()<0))||(pr<0)){
            
                     prBid=MarketInfo(OrderSymbol(), MODE_BID);
                     prAsk=MarketInfo(OrderSymbol(), MODE_ASK);
            
                     if(OrderType()==OP_BUY)clPr=prBid;
                     if(OrderType()==OP_SELL)clPr=prAsk;
         
                     if(OrderClose(OrderTicket(), OrderLots(), clPr, 0, cl)){
                        if (UseSound) PlaySound(NameFileSound);
                        break;
                     }
                     else err=GetLastError();
                     Print("Error(",err,") CloseOrders() -> OrderClose(): ",ErrorDescription(err),", try ",cx);
      
                     if(err==1||err==2||err==3||err==5) break;                      // 1-��� ������, �� ��������� ����������, 2-����� ������, 3-������������ ���������, 5-������ ������ ����������� ���������
                     if(err==64||err==65||err==133||err==139) break;                // 64-���� ������������, 65-������������ ����� �����, 133-�������� ���������, 139-����� ������������ � ��� ��������������,
                     if(err==4||err==131||err==132) Sleep(1000*60);                 // 4-�������� ������ �����, 131-������������ �����, 132-����� ������
                     if(err==141) Sleep(1000*10);                                   // 141-������� ����� ��������
                     if(err==146) while (IsTradeContextBusy()) Sleep(1000*10);      // 146-���������� �������� ������
                     if(err==135) Sleep(500);                                       // 135-���� ����������
                  }
               }
            }
         }
      }
   }
}
//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ������� ���������� �����(�).                                     |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   sy - Symbol ���("" - ������� ������, "all"- ����� ������)      |
//|   op - ��� ������ OP_BUYSTOP, OP_SELLLIMIT �.�.� (-1) ����� ���  |
//|   tk - ����� ������ (��� 0 ���� ����� ��� ������,(-1) ��� ������)|
//|   mn - Magic ��� (-1) ����� �����                                |
//|   cl - ���� ��������� �������� ������                            |
//+------------------------------------------------------------------+
void DeleteOrders(string sy="", int op=-1, int tk=-1, int mn=-1, color cl=CLR_NONE){
//---
   int orCx, orType, err;
//---
   if(sy=="")sy=Symbol();
   if(tk>0||tk==0)orCx=1;
   else orCx=OrdersTotal();
//---
   for(int i=orCx; i>0; i--){
      //--------------- ������� ������� ���������� �������� ��� ������� ----------
      for(int cx=0; cx<NumberOfTry; cx++){
         if(tk>0 && tk!=0){
            //--- ���� ������� �����
            if(!OrderSelect(tk, SELECT_BY_TICKET, MODE_TRADES)){
               err = GetLastError();
               Print("Error(",err,") DeleteOrders() -> OrderSelect(): ",ErrorDescription(err));
               continue;
            }
         }
         //-------------- ���� ������ ��� ���������� �� ���� ������� ---------
         if(tk<0){
            if(!OrderSelect(i-1, SELECT_BY_POS, MODE_TRADES)){
               err = GetLastError();
               Print("Error(",err,"), DeleteOrders() -> OrderSelect() ",ErrorDescription(err));
               continue;
            }
         }
         orType=OrderType();
         if((orType==OP_BUYSTOP)||(orType==OP_SELLSTOP)||(orType==OP_BUYLIMIT)||(orType==OP_SELLLIMIT)){
            if((sy==OrderSymbol()||sy=="all")&&(mn==OrderMagicNumber()||mn<0)){
               if((op<0)||(op==orType)){
                  if(OrderDelete(OrderTicket(), cl)){
                     if (UseSound) PlaySound(NameFileSound);
                     break;
                  }
                  else err=GetLastError();
                  Print("Error(",err,") DeleteOrders() -> OrderDelete(): ",ErrorDescription(err),", try ",cx);
      
                  if(err==1||err==2||err==3||err==5) break;                      // 1-��� ������, �� ��������� ����������, 2-����� ������, 3-������������ ���������, 5-������ ������ ����������� ���������
                  if(err==64||err==65||err==133||err==139) break;                // 64-���� ������������, 65-������������ ����� �����, 133-�������� ���������, 139-����� ������������ � ��� ��������������,
                  if(err==4||err==132) Sleep(1000*60);                           // 4-�������� ������ �����, 132-����� ������
                  if(err==141) Sleep(1000*10);                                   // 141-������� ����� ��������
                  if(err==146) while (IsTradeContextBusy()) Sleep(1000*10);      // 146-���������� �������� ������
               }
            }
         }
      }
   }
}
//+------------------------------------------------------------------+
//|  �����: Pozitif        mail: alex-w-@bk.ru                       |
//+------------------------------------------------------------------+
//| ��������� ����� �� �������� ���� � ���������� �����.             |
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   sy - Symbol (��� "" - ������� ������)                          |
//|   op - ��������                                                  |
//|   lt - ���                                                       |
//|   sl - ������� ���� � �������                                    |
//|   tp - ������� ���� � �������                                    |
//|   mn - MagicNumber                                               |
//|   cl - ���� ������������ ���������.                              |
//+------------------------------------------------------------------+
int OpenOrder(string sy, int op, double lt, double sl=0, double tp=0, int mn=0, color cl=CLR_NONE){
//---
   int dg, ticket, err, orTotal, minLevel;
   double prAsk, prBid, opPr, pt;
   string comment;
//----
   if (sy=="")sy=Symbol();
   
   comment=StringConcatenate(Day(),".",Month(),Year()," ",Hour(),":",Minute(),":",Seconds());
   lt=MathMax(lt, MarketInfo(Symbol(), MODE_MINLOT));
   lt=MathMin(lt, MarketInfo(Symbol(), MODE_MAXLOT));
   NormalizeDouble(lt, 2);
   
   orTotal=OrdersTotal();
   pt=MarketInfo(sy, MODE_POINT);
   dg=MarketInfo(sy, MODE_DIGITS);
   minLevel=MarketInfo(sy, MODE_STOPLEVEL);
   
   for (int i=0; i<NumberOfTry; i++)
   {
      while(!IsTradeAllowed()) Sleep(5000);
      RefreshRates();
      
      prAsk=MarketInfo(sy, MODE_ASK);
      prBid=MarketInfo(sy, MODE_BID);
      
      if((sl<minLevel)&&(sl!=0))sl=minLevel;
      if((tp<minLevel)&&(tp!=0))tp=minLevel;
      
      if(op==OP_BUY){
         opPr=prAsk;
         if(sl>0)sl=prBid-sl*pt;
         if(tp>0)tp=prBid+tp*pt;
      }
      if(op==OP_SELL){
         opPr=prBid;
         if(sl>0)sl=prAsk+sl*pt;
         if(tp>0)tp=prAsk-tp*pt;
      }
      opPr=NormalizeDouble(opPr, dg);
      ticket=OrderSend(sy, op, lt, opPr, Slippage, sl, tp, comment, mn, 0, cl);
      
      if(ticket>0){
         if(UseSound)PlaySound(NameFileSound);
         break;
      }
      else{
         err=GetLastError();
         if (prAsk==0 && prBid==0)Print("��������� � ������ ����� ������� �������: "+sy);
         Print("Error(",err,"), OpenOrder(): ",ErrorDescription(err),", try: ",i);
         
         if (err==2||err==64||err==65||err==133) break;
         if (err==4||err==131||err==132) Sleep(1000*300); break;
         if (err==128||err==142||err==143){
            Sleep(1000*40);
            if (OrdersTotal()>orTotal){
               if (UseSound)PlaySound(NameFileSound);
               break;
            }
         }
         if (err==140||err==148||err==4110||err==4111) break;
         if (err==141) Sleep(1000*10);
         if (err==145) Sleep(1000*10);
         if (err==146) while(IsTradeContextBusy()) Sleep(1000*10);
         if (err==135||err==138) Sleep(1000*5);
      }
   }
  return (ticket);
}
//+------------------------------------------------------------------+

