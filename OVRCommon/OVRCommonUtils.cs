using System;
using System.Collections.Generic;
using System.Text;

namespace AutoSports.OVRCommon
{
   public static class OVRCommonUtils
   {
       public static readonly double PI = 3.1415926;
       public static readonly int kByte = 1024;

       public static void SplitPath(string strFullPath, out string strDir, out string strName)
       {
            int i = strFullPath.Length;
            while (i > 0) 
            {
                char ch = strFullPath[i - 1];
                if (ch == '\\' || ch == '/' || ch == ':') 
                    break;
                
                i--;
            }
            strDir = strFullPath.Substring(0, i);
            strName = strFullPath.Substring(i);
       }

       public static int Time_StringToInt32(System.String strTime)
       {
           int iTotalMiliSeconds = 0;
           try
           {
               int iIndex1 = strTime.IndexOf(':', 0);
               int iIndex2 = strTime.IndexOf(':', iIndex1 + 1);
               if (iIndex1 == -1)
               {
                   float fTotalMiliSeconds = System.Convert.ToSingle(strTime) * 1000;
                   iTotalMiliSeconds = System.Convert.ToInt32(fTotalMiliSeconds);
               }
               else if (iIndex2 == -1)
               {
                   float fTotalMiliSeconds = System.Convert.ToSingle(strTime.Substring(iIndex1 + 1, strTime.Length - iIndex1 - 1)) * 1000;
                   iTotalMiliSeconds = System.Convert.ToInt32(fTotalMiliSeconds) + System.Convert.ToInt32(strTime.Substring(0, iIndex1)) * 60000;
               }
               else
               {
                   float fTotalMiliSeconds = System.Convert.ToSingle(strTime.Substring(iIndex2 + 1, strTime.Length - iIndex2 - 1)) * 1000;
                   iTotalMiliSeconds = System.Convert.ToInt32(fTotalMiliSeconds) + System.Convert.ToInt32(strTime.Substring(iIndex1 + 1, iIndex2 - iIndex1 - 1)) * 60000;
                   iTotalMiliSeconds += System.Convert.ToInt32(strTime.Substring(0, iIndex1)) * 3600000;
               }
           }
           catch (System.Exception)
           {
               return -1;
           }

           return iTotalMiliSeconds;
       }

       public static System.String Time_Int32ToString(int iTotalMiliSeconds)
       {
           if (iTotalMiliSeconds <= 0) return "0";

           int iMiliSeconds = iTotalMiliSeconds % 1000;
           int iSeconds = (iTotalMiliSeconds / 1000) % 60;
           int iMinutes = (iTotalMiliSeconds / 60000) % 60;
           int iHours = (iTotalMiliSeconds / 3600000) % 24;

           if (iHours == 0)
           {
               if (iMinutes == 0)
               {
                   return System.String.Format("{0}.{1:000}", iSeconds, iMiliSeconds);
               }
               else
               {
                   return System.String.Format("{0}:{1:00}.{2:000}", iMinutes, iSeconds, iMiliSeconds);
               }
           }

           return System.String.Format("{0}:{1:00}:{2:00}.{3:000}", iHours, iMinutes, iSeconds, iMiliSeconds);
       }

   }  
}
