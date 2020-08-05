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

namespace AutoSports.OVRWPPlugin
{
    public class GVAR
    {
        public static String g_strDisplnCode = "WP";
        public static String g_strDisplnName = "水球";

        public static String m_TempstrStatisticTag = string.Empty;
        public static String m_TempstrStatusTag = string.Empty;
        public static String m_TempstrPeriodTag = string.Empty;
        public static String m_TempstrStaffTag = string.Empty;
        public static String m_TempstrPointTag = string.Empty;

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
        public const int PERIOD_PSO = 51;

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

        public const int MAXSETNUM = 7; //1-4为正常Set，5-6为Extra Set,7PSO

        //Player Stat Code
        public static string strStat_PTime_Player = "Player_TimePlayed";
        public static string strStat_PTime_Team = "Team_PossTime";
        public static string strStat_PNO_Team = "Team_PossNumber";

        public static string strStat_ASM_Player = "Player_ASM";   //Action Shot Missed
        public static string strStat_ASG_Player = "Player_ASG";  //Action Shot Goal
        public static string strStat_ASG_GK = "GK_ASG";          //Acton Shot Goal ---GK
        public static string strStat_ASS_GK = "GK_ASS";  //Action Shot Goal Saved---GK
        public static string strStat_CSM_Player = "Player_CSM";
        public static string strStat_CSG_Player = "Player_CSG";
        public static string strStat_CSG_GK = "GK_CSG";
        public static string strStat_CSS_GK = "GK_CSS";
        public static string strStat_ESM_Player = "Player_XSM";
        public static string strStat_ESG_Player = "Player_XSG";
        public static string strStat_ESG_GK = "GK_XSG";
        public static string strStat_ESS_GK = "GK_XSS";
        public static string strStat_5SM_Player = "Player_5SM";
        public static string strStat_5SG_Player = "Player_5SG";
        public static string strStat_5SG_GK = "GK_5SG";
        public static string strStat_5SS_GK = "GK_5SS";
        public static string strStat_PSM_Player = "Player_PSM";
        public static string strStat_PSG_Player = "Player_PSG";
        public static string strStat_PSG_GK = "GK_PSG";
        public static string strStat_PSS_GK = "GK_PSS";
        public static string strStat_CAM_Player = "Player_CAM";
        public static string strStat_CAG_Player = "Player_CAG";
        public static string strStat_CAG_GK = "GK_CAG";
        public static string strStat_CAS_GK = "GK_CAS";
        public static string strStat_FTM_Player = "Player_FTM";
        public static string strStat_FTG_Player = "Player_FTG";
        public static string strStat_FTG_GK = "GK_FTG";
        public static string strStat_FTS_GK = "GK_FTS";

        public static string strStat_Assist_Player = "Player_Assist";
        public static string strStat_Steals_Player = "Player_Steals";
        public static string strStat_TurnOver_Player = "Player_TurnOver";
        public static string strStat_Block_Player = "Player_Block";
        public static string strStat_SpinIn_Player = "Player_SpinIn";
        public static string strStat_SpinOut_Player = "Player_SpinOut";
        public static string strStat_Penalty_Player = "Penalty";
        public static string strStat_20C_Player = "Player_20C";
        public static string strStat_20F_Player = "Player_20F";
        public static string strStat_EXS_Player = "Player_EXS";
        public static string strStat_EXF_Player = "Player_EXF";
        public static string strStat_TimeOut_Team = "Team_TimeOut";
        public static string strStat_ConerThrow_Team = "Team_ConerThrow";


        //Action Code
        public static string strAction_ActionShot = "ActionShot";
        public static string strAction_CentreShot = "CentreShot";
        public static string strAction_ExtraShot = "ExtraShot";
        public static string strAction_5mShot = "5mShot";
        public static string strAction_PSShot = "PenaltyShot";
        public static string strAction_CAShot = "CAShot";
        public static string strAction_FTShot = "FreeThrowShot";

        public static string strAction_ActionShot_Goal = "ActionShot_Goal";
        public static string strAction_CentreShot_Goal = "CentreShot_Goal";
        public static string strAction_ExtraShot_Goal = "ExtraShot_Goal";
        public static string strAction_5mShot_Goal = "5mShot_Goal";
        public static string strAction_PSShot_Goal = "PenaltyShot_Goal";
        public static string strAction_CAShot_Goal = "CAShot_Goal";
        public static string strAction_FTShot_Goal = "FreeThrowShot_Goal";

        public static string strAction_Assist = "Assist";
        public static string strAction_Steals = "Steals";
        public static string strAction_SpinIn = "Spin_In";
        public static string strAction_SpinOut = "Spin_Out";
        public static string strAction_TurnOver = "TurnOver";
        public static string strAction_Block = "Block";
        public static string strAction_Penalty = "Penalty";
        public static string strAction_20C = "20C";
        public static string strAction_20F = "20F";
        public static string strAction_EXS = "EX_S";
        public static string strAction_EXF = "EX_F";
        public static string strAction_TimeOut = "TimeOut";
        public static string strAction_ConerThrow = "ConerThrow";
        public static string strAction_In = "In";
        public static string strAction_Out = "Out";


        public static OVRWPPlugin g_WPPlugin;
        public static SqlConnection g_sqlConn;
        public static OVRWPManagerDB g_ManageDB;
        public static Object g_messageSignal = new Object();
        public static Queue<string> g_messagesQueue = new Queue<string>();

         //Action 关联
        public static Dictionary<string, string> m_dicAction = new Dictionary<string, string>
        {
            {"11", strAction_ActionShot_Goal},//goal
            {"12", strAction_ActionShot},//saved
            {"13", strAction_ActionShot},//missed
            {"14", strAction_ActionShot},//post
            {"15", strAction_ActionShot},//block
            {"21", strAction_CentreShot_Goal},
            {"22", strAction_CentreShot},
            {"23", strAction_CentreShot},
            {"24", strAction_CentreShot},
            {"25", strAction_CentreShot},
            {"31", strAction_ExtraShot_Goal},
            {"32", strAction_ExtraShot},
            {"33", strAction_ExtraShot},
            {"34", strAction_ExtraShot},
            {"35", strAction_ExtraShot},
            {"41", strAction_5mShot_Goal},
            {"42", strAction_5mShot},
            {"43", strAction_5mShot},
            {"44", strAction_5mShot},
            {"45", strAction_5mShot},
            {"51", strAction_PSShot_Goal},
            {"52", strAction_PSShot},
            {"53", strAction_PSShot},
            {"54", strAction_PSShot},
            {"55", strAction_PSShot},
            {"61", strAction_CAShot_Goal},
            {"62", strAction_CAShot},
            {"63", strAction_CAShot},
            {"64", strAction_CAShot},
            {"65", strAction_CAShot},
            {"71", strAction_FTShot_Goal},
            {"72", strAction_FTShot},
            {"73", strAction_FTShot},
            {"74", strAction_FTShot},
            {"75", strAction_FTShot},
            {"07",  strAction_Assist},
            {"08",  strAction_Steals},
            {"09",  strAction_TurnOver},
            {"010", strAction_Block},
            {"011", strAction_SpinIn},
            {"012", strAction_SpinOut},
            {"013", strAction_20C},
            {"014", strAction_20F},
            {"015", strAction_Penalty},
            {"016", strAction_EXS},
            {"017", strAction_EXF},
            {"018", strAction_TimeOut},
            {"019", strAction_ConerThrow},
            {"022", strAction_In},
            {"023", strAction_Out},
        };

        //与 Statistic 关联
        public static Dictionary<string, string> m_dicPlayerStat = new Dictionary<string, string>
        {
            {"11", strStat_ASG_Player},
            {"12", strStat_ASM_Player},
            {"13", strStat_ASM_Player},
            {"14", strStat_ASM_Player},
            {"15", strStat_ASM_Player},
            {"21", strStat_CSG_Player},
            {"22", strStat_CSM_Player},
            {"23", strStat_CSM_Player},
            {"24", strStat_CSM_Player},
            {"25", strStat_CSM_Player},
            {"31", strStat_ESG_Player},
            {"32", strStat_ESM_Player},
            {"33", strStat_ESM_Player},
            {"34", strStat_ESM_Player},
            {"35", strStat_ESM_Player},
            {"41", strStat_5SG_Player},
            {"42", strStat_5SM_Player},
            {"43", strStat_5SM_Player},
            {"44", strStat_5SM_Player},
            {"45", strStat_5SM_Player},
            {"51", strStat_PSG_Player},
            {"52", strStat_PSM_Player},
            {"53", strStat_PSM_Player},
            {"54", strStat_PSM_Player},
            {"55", strStat_PSM_Player},
            {"61", strStat_CAG_Player},
            {"62", strStat_CAM_Player},
            {"63", strStat_CAM_Player},
            {"64", strStat_CAM_Player},
            {"65", strStat_CAM_Player},
            {"71", strStat_FTG_Player},
            {"72", strStat_FTM_Player},
            {"73", strStat_FTM_Player},
            {"74", strStat_FTM_Player},
            {"75", strStat_FTM_Player},
            {"07", strStat_Assist_Player},
            {"08", strStat_Steals_Player},
            {"09", strStat_TurnOver_Player},
            {"010", strStat_Block_Player},
            {"011", strStat_SpinIn_Player},
            {"012", strStat_SpinOut_Player},
            {"013", strStat_20C_Player},
            {"014", strStat_20F_Player},
            {"015", strStat_Penalty_Player},
            {"016", strStat_EXS_Player},
            {"017", strStat_EXF_Player},
            {"018", strStat_TimeOut_Team},
            {"019", strStat_ConerThrow_Team},
            {"020",strStat_PTime_Team},
            {"021",strStat_PNO_Team},
        };

        //与守门员技术统计关联

        public static Dictionary<string, string> m_dicGKStat = new Dictionary<string, string>
        {
            {"11",  strStat_ASG_GK},
            {"12",  strStat_ASS_GK},
            {"21",  strStat_CSG_GK},
            {"22",  strStat_CSS_GK},
            {"31",  strStat_ESG_GK},
            {"32",  strStat_ESS_GK},
            {"41",  strStat_5SG_GK},
            {"42",  strStat_5SS_GK},
            {"51",  strStat_PSG_GK},
            {"52",  strStat_PSS_GK},
            {"61",  strStat_CAG_GK},
            {"62",  strStat_CAS_GK},  
            {"71",  strStat_FTG_GK},
            {"72",  strStat_FTS_GK},    
        };

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
            int iHour_Min = iMatchTime / 60;
            int iHour = iHour_Min / 60;
            int iMin = iHour_Min % 60;
            int iSec = iMatchTime % 60;
            //格式为00：00：00
            strFmtTime = iHour.ToString() + ":" + iMin.ToString() + ":" + iSec.ToString();
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
            return MessageBoxEx.Show(GVAR.g_WPPlugin.GetModuleUI, strMsg, "", MessageBoxButtons.OK, MessageBoxIcon.Error, MessageBoxDefaultButton.Button1, true);
        }
    }
}
