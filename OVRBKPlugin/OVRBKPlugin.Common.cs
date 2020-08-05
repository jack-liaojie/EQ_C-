using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using System.Data.SqlClient;
using System.Threading;

namespace AutoSports.OVRBKPlugin
{
    public class GVAR
    {
        public static String g_strDisplnCode = "BK";
        public static String g_strDisplnName = "篮球";

        public const int STATUS_SCHEDULE = 30;
        public const int STATUS_ON_COURT = 40; //Start list
        public const int STATUS_RUNNING = 50;
        public const int STATUS_SUSPEND = 60;
        public const int STATUS_UNOFFICIAL = 100;
        public const int STATUS_FINISHED = 110;
        public const int STATUS_REVISION = 120;
        public const int STATUS_CANCELED = 130;

        public const int PERIOD_1ST = 1;
        public const int PERIOD_2ND = 2;
        public const int PERIOD_3RD = 3;
        public const int PERIOD_4TH = 4;
        public const int PERIOD_EXTRA1 = 5;
        public const int PERIOD_EXTRA2 = 6;
        public const int PERIOD_EXTRA3 = 7;
        public const int PERIOD_EXTRA4 = 8;

        public const int RESULT_TYPE_WIN = 1;
        public const int RESULT_TYPE_LOSE = 2;
        public const int RESULT_TYPE_TIE = 3;

        public const int RANK_TYPE_1ST = 1;
        public const int RANK_TYPE_2ND = 2;
        public const int RANK_TYPE_TIE = 0;

        public const string MATCH_TIME = "480";  //以秒为单位，8分钟
        public const string EXTRA_TIME = "180";  //以秒为单位，3分钟
        public const string PSO_TIME = "0";  //以秒为单位，3分钟

        public const int MATCH_COMMON = 1;
        public const int MATCH_PENALTY = 2;

        public const int MAXSETNUM = 8; //1-4为正常Set，5-8为Extra Set

        public static OVRBKPlugin g_BKPlugin;
        public static SqlConnection g_sqlConn;
        public static OVRBKManagerDB g_ManageDB;
        public static Object g_messageSignal = new Object();
        public static Queue<string> g_messagesQueue = new Queue<string>();

        public static Double GetFieldValue2Double(ref SqlDataReader sdr, Int32 iIndex)
        {
            double dValue = 0.0;
            if (!(sdr[iIndex] is DBNull))
            {
                dValue = Convert.ToDouble(Convert.ToString(sdr[iIndex]));
            }
            return dValue;
        }

        public static Double GetFieldValue2Double(ref SqlDataReader sdr, String strFieldName)
        {
            double dValue = 0.0;
            if (!(sdr[strFieldName] is DBNull))
            {
                dValue = Convert.ToDouble(Convert.ToString(sdr[strFieldName]));
            }
            return dValue;
        }

        public static Int32 Str2Int(Object strObj)
        {
            if (strObj == null) return 0;

            if (strObj.ToString().Length == 0) return 0;

            try
            {
                return Convert.ToInt32(strObj);
            }
            catch (System.Exception errorFmt)
            {
                MessageBox.Show(errorFmt.ToString());
            }
            return 0;
        }

        public static void ConvetTime2String(string strFormatTime, ref string strTime)
        {
            int iIndex = strFormatTime.IndexOf(':');
            if (iIndex < 0)
                return;

            string strMin = strFormatTime.Substring(0, iIndex);
            string strSec = strFormatTime.Substring(iIndex + 1);

            int iMin = 0;
            int iSec = 0;
            if (strMin.Length == 0)
            {
                iMin = 0;
            }
            else
            {
                try
                {
                    iMin = GVAR.Str2Int(strMin) * 60;
                }
                catch (System.Exception e)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                }
            }

            try
            {
                iSec = GVAR.Str2Int(strSec);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            strTime = (iSec + iMin).ToString();
        }

        public static string FormatTime(string strTime)
        {
            string strFmtTime = "";

            if (strTime.Length == 0)
                return strFmtTime;

            int iMatchTime = GVAR.Str2Int(strTime);
            int iMin = iMatchTime / 60;
            int iSec = iMatchTime % 60;
            strFmtTime = iMin.ToString() + ":" + iSec.ToString();

            strFmtTime = "00:"+ strFmtTime;  //格式为00：00：00
            return strFmtTime;
        }
        public static string TranslateINT32toTime(int nTimeInSec)
        {
            int intMin, intSec;
            string strTime = string.Empty;
            string strTemp = string.Empty;
            if (nTimeInSec < 0)
            {
                return strTime;
            }
            intMin = nTimeInSec / 60;
            intSec = nTimeInSec % 60;

            if (intMin != 0)
            {
                strTime = String.Format("{0}:", intMin);
            }
            else
            {
                strTime = "0:";
            }

            if (intSec != 0)
            {
                if (intSec / 10 != 0)
                {
                    strTemp = String.Format("{0}", intSec);

                    strTime += strTemp;
                }
                else
                {
                    strTemp = String.Format("0{0}", intSec);

                    strTime += strTemp;
                }
            }
            else
            {
                strTime += "00";
            }
            return strTime;
        }
        public static int TranslateTimetoINT32(String strTime)
        {
            if (strTime.Length == 0)
            {
                return 0;
            }
            strTime = strTime.Trim();
            string[] split = strTime.Split(':');
            return Convert.ToInt32(split[0]) * 60 + Convert.ToInt32(split[1]);
        }
        public static AutoResetEvent g_SerialEvent = new AutoResetEvent(false);
        public static DialogResult ExceptMsgShow(String strMsg)
        {
            return MessageBoxEx.Show(GVAR.g_BKPlugin.GetModuleUI, strMsg, "", MessageBoxButtons.OK, MessageBoxIcon.Error, MessageBoxDefaultButton.Button1, true);
        }
    }
}
