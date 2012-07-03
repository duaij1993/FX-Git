//|-----------------------------------------------------------------------------------------|
//|                                                                             PlusDiv.mqh |
//|                                                            Copyright � 2012, Dennis Lee |
//| Assert History                                                                          |
//| 1.00    Created PlusDiv for divergence functions.                                       |
//|-----------------------------------------------------------------------------------------|
#property   copyright "Copyright � 2012, Dennis Lee"
#include    <stdlib.mqh>

//|-----------------------------------------------------------------------------------------|
//|                           E X T E R N A L   V A R I A B L E S                           |
//|-----------------------------------------------------------------------------------------|
extern bool   DivShowIndicatorTrendLines = true;
extern bool   DivShowPriceTrendLines = true;

//|-----------------------------------------------------------------------------------------|
//|                           I N T E R N A L   V A R I A B L E S                           |
//|-----------------------------------------------------------------------------------------|
#define  arrowsDisplacement 0.0001
string   DivName="PlusDiv";
string   DivVer="1.00";
string   DivWinName;

//|-----------------------------------------------------------------------------------------|
//|                             I N I T I A L I Z A T I O N                                 |
//|-----------------------------------------------------------------------------------------|
void DivInit(string win)
{
   DivWinName=win;
   return(0);
}

//|-----------------------------------------------------------------------------------------|
//|                               M A I N   P R O C E D U R E                               |
//|-----------------------------------------------------------------------------------------|
void DivCatchBullishDivergence(double& buf[], double x[], double y[], double lo[], int shift)
{
   if( !DivIsIndicatorTrough(x, shift) ) return;
   int currentTrough = shift;
   int lastTrough = DivGetIndicatorLastTrough(x, y, shift);
//----   
   if( x[currentTrough] > x[lastTrough] && lo[currentTrough] < lo[lastTrough] )
   {
      buf[currentTrough] = x[currentTrough] - arrowsDisplacement;
   //----
      if( DivShowPriceTrendLines )
         DivDrawPriceTrendLine( Time[currentTrough], Time[lastTrough], 
                               lo[currentTrough], lo[lastTrough], 
                               Green, STYLE_SOLID );
   //----
      if( DivShowIndicatorTrendLines )
         DivDrawIndicatorTrendLine( DivWinName,
                                   Time[currentTrough], Time[lastTrough], 
                                   x[currentTrough], x[lastTrough], 
                                   Green, STYLE_SOLID );
   }
//----   
   if( x[currentTrough] < x[lastTrough] && lo[currentTrough] > lo[lastTrough] )
   {
      buf[currentTrough] = x[currentTrough] - arrowsDisplacement;
   //----
      if( DivShowPriceTrendLines )
         DivDrawPriceTrendLine( Time[currentTrough], Time[lastTrough], 
                               lo[currentTrough], lo[lastTrough], 
                               Green, STYLE_DOT );
   //----
      if( DivShowIndicatorTrendLines )
         DivDrawIndicatorTrendLine( DivWinName,
                                   Time[currentTrough], Time[lastTrough], 
                                   x[currentTrough], x[lastTrough], 
                                   Green, STYLE_DOT );
   }      
}
void DivCatchBearishDivergence(double& buf[], double x[], double y[], double hi[], int shift)
{
   if( !DivIsIndicatorPeak(x, shift) ) return;
   int currentPeak = shift;
   int lastPeak = DivGetIndicatorLastPeak(x, y, shift);
//----   
   if( x[currentPeak] < x[lastPeak] && hi[currentPeak] > hi[lastPeak] )
   {
      buf[currentPeak] = x[currentPeak] + arrowsDisplacement;
   //----
      if( DivShowPriceTrendLines )
         DivDrawPriceTrendLine( Time[currentPeak], Time[lastPeak], 
                               hi[currentPeak], hi[lastPeak], 
                               Red, STYLE_SOLID );
   //----
      if( DivShowIndicatorTrendLines )
         DivDrawIndicatorTrendLine( DivWinName,
                                   Time[currentPeak], Time[lastPeak], 
                                   x[currentPeak], x[lastPeak], 
                                   Red, STYLE_SOLID );
   }
   if( x[currentPeak] > x[lastPeak] && hi[currentPeak] < hi[lastPeak] )
   {
      buf[currentPeak] = x[currentPeak] + arrowsDisplacement;
   //----
      if( DivShowPriceTrendLines )
         DivDrawPriceTrendLine( Time[currentPeak], Time[lastPeak], 
                               hi[currentPeak], hi[lastPeak], 
                               Red, STYLE_DOT );
   //----
      if( DivShowIndicatorTrendLines )
         DivDrawIndicatorTrendLine( DivWinName,
                                   Time[currentPeak], Time[lastPeak], 
                                   x[currentPeak], x[lastPeak], 
                                   Red, STYLE_DOT );
   }   
}

//|-----------------------------------------------------------------------------------------|
//|                           I N T E R N A L   F U N C T I O N S                           |
//|-----------------------------------------------------------------------------------------|
bool DivIsIndicatorPeak(double x[], int shift)
{
   if(x[shift] >= x[shift+1] && x[shift] > x[shift+2] && 
      x[shift] > x[shift-1])
      return(true);
   else 
      return(false);
}
bool DivIsIndicatorTrough(double x[], int shift)
{
   if(x[shift] <= x[shift+1] && x[shift] < x[shift+2] && 
      x[shift] < x[shift-1])
      return(true);
   else 
      return(false);
}
int DivGetIndicatorLastPeak(double x[], double y[], int shift)
{
   for(int i = shift + 5; i < Bars; i++)
   {
      if(y[i] >= y[i+1] && y[i] >= y[i+2] &&
         y[i] >= y[i-1] && y[i] >= y[i-2])
      {
         for(int j = i; j < Bars; j++)
         {
            if(x[j] >= x[j+1] && x[j] > x[j+2] &&
               x[j] >= x[j-1] && x[j] > x[j-2])
               return(j);
         }
      }
   }
   return(-1);
}
int DivGetIndicatorLastTrough(double x[], double y[], int shift)
{
   for(int i = shift + 5; i < Bars; i++)
   {
      if(y[i] <= y[i+1] && y[i] <= y[i+2] &&
         y[i] <= y[i-1] && y[i] <= y[i-2])
      {
         for (int j = i; j < Bars; j++)
         {
            if(x[j] <= x[j+1] && x[j] < x[j+2] &&
               x[j] <= x[j-1] && x[j] < x[j-2])
               return(j);
         }
      }
   }
   return(-1);
}

//|-----------------------------------------------------------------------------------------|
//|                              C R E A T E   O B J E C T S                                |
//|-----------------------------------------------------------------------------------------|
void DivDrawPriceTrendLine(datetime x1, datetime x2, double y1, double y2, color lineColor, double style)
  {
   string label = DivName+"_"+DivVer+"_Main_"+DoubleToStr(x1, 0);
   ObjectDelete(label);
   ObjectCreate(label, OBJ_TREND, 0, x1, y1, x2, y2, 0, 0);
   ObjectSet(label, OBJPROP_RAY, 0);
   ObjectSet(label, OBJPROP_COLOR, lineColor);
   ObjectSet(label, OBJPROP_STYLE, style);
  }

void DivDrawIndicatorTrendLine(string win, datetime x1, datetime x2, double y1, double y2, color lineColor, double style)
{
   int indicatorWindow = WindowFind(win);
   if(indicatorWindow < 0) return;
   string label = DivName+"_"+DivVer+"_Sub_"+DoubleToStr(x1, 0);
   ObjectDelete(label);
   ObjectCreate(label, OBJ_TREND, indicatorWindow, x1, y1, x2, y2, 0, 0);
   ObjectSet(label, OBJPROP_RAY, 0);
   ObjectSet(label, OBJPROP_COLOR, lineColor);
   ObjectSet(label, OBJPROP_STYLE, style);
}
//|-----------------------------------------------------------------------------------------|
//|                             D E I N I T I A L I Z A T I O N                             |
//|-----------------------------------------------------------------------------------------|
void DivDeInit()
{
   for(int i = ObjectsTotal() - 1; i >= 0; i--)
   {
      string label = ObjectName(i);
      if( StringSubstr(label, 0, 12) != StringConcatenate(DivName,"_",DivVer) )
         continue;
      ObjectDelete(label);   
   }
   return(0);
}

//|-----------------------------------------------------------------------------------------|
//|                                     C O M M E N T                                       |
//|-----------------------------------------------------------------------------------------|
string DivComment(string cmt="")
{
   string strtmp = cmt+"  -->"+DivName+"_"+DivVer+"<--";

                         
   strtmp = strtmp+"\n";
   return(strtmp);
}

//|-----------------------------------------------------------------------------------------|
//|                       E N D   O F   E X P E R T   A D V I S O R                         |
//|-----------------------------------------------------------------------------------------|

