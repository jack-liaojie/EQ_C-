using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using System.Data.SqlClient;

namespace AutoSports.OVRFBPlugin
{
    public class GVAR
    {
        public static String g_strDisplnCode = "FB";
        public static String g_strDisplnName = "足球";

        public static int g_MatchPeriodSet = 0;
        public const int STATUS_SCHEDULE = 30;
        public const int STATUS_ON_COURT = 40; //Start list
        public const int STATUS_RUNNING = 50; // 比赛进行
        public const int STATUS_SUSPEND = 60;
        public const int STATUS_UNOFFICIAL = 100;
        public const int STATUS_FINISHED = 110; // 比赛完成
        public const int STATUS_REVISION = 120; 
        public const int STATUS_CANCELED = 130;

        public const int PERIOD_1stHalf = 1;
        public const int PERIOD_2ndHalf = 2;
        public const int PERIOD_1stExtraHalf = 3;
        public const int PERIOD_2ndExtraHalf = 4;
        public const int PERIOD_PenaltyShoot = 51;

        public const int RESULT_TYPE_WIN = 1;
        public const int RESULT_TYPE_LOSE = 2;
        public const int RESULT_TYPE_TIE = 3;

        public const int RANK_TYPE_1ST = 1;
        public const int RANK_TYPE_2ND = 2;
        public const int RANK_TYPE_TIE = 0;

        public static string MATCH_PERIOD1 = "2700";  //以秒为单位，45分钟
        public static string MATCH_PERIOD2 = "5400";  //以秒为单位，90分钟
        public static string MATCH_PERIOD3 = "6300";  //以秒为单位，105分钟
        public static string MATCH_PERIOD4 = "7200";  //以秒为单位，120分钟


        public const int MATCH_COMMON = 1;
        public const int MATCH_PENALTY = 2;

        public const int MAXSETNUM = 5; //1-2为正常Set，3-4为Extra Set,5 PSO

        //Player Stat Code
        public static string strStat_PTime_Player = "Player_TimePlayed";
        public static string strStat_PNO_Team = "Team_PNO";

        public static string strStat_ShotNoGoal_Player = "Player_ShotNoGoal";          //无效射门 
        public static string strStat_Goal_Player = "Player_Goal";                     //进球
        public static string strStat_ShotOnGoal_Player = "Player_ShotOnGoal";       //有效射门
        public static string strStat_GA_Player = "Player_GoalAgainst";              //失球，针对守门员
        public static string strStat_PSNoGoal_Player = "Player_PShotNoGoal";  //点球射门
        public static string strStat_PG_Player = "Player_PGoal";            //点球进球
        public static string strStat_PSOnGoal_Player = "Player_PShotOnGoal";
        public static string strStat_FCNoGoal_Player = "Player_FCShotNoGoal";          //任意球射门
        public static string strStat_FCOnGoal_Player = "Player_FCShotOnGoal";          //任意球射门
        public static string strStat_FCG_Player = "Player_FCGoal";          //任意球进球
        public static string strStat_YCard_Player = "Player_YCard";                  //黄牌
        public static string strStat_2YCard_Player = "Player_2YCard";                 //2nd黄牌
        public static string strStat_RCard_Player = "Player_RCard";                  //红牌
        public static string strStat_FC_Player = "Player_FC";                     //犯规
        public static string strStat_FS_Player = "Player_FS";                     //被侵犯
        public static string strStat_CK_Team = "Team_CornerClick";              //角球
        public static string strStat_OF_Team = "Team_Offiside";                 //越位
        public static string strStat_OG_Player = "Player_OwnGoal";                //乌龙球

        //Action Code
        public static string strAction_NoGoalShot = "ShotNoGoal";
        public static string strAction_OnGoalShot = "ShotOnGoal";
        public static string strAction_Goal = "Goal";
        public static string strAction_OwnGoal = "OwnGoal";
        public static string strAction_POnGoalShot = "PShotOnGoal";
        public static string strAction_PNoGoalShot = "PShotNoGoal";
        public static string strAction_PGoal = "PenaltyGoal";
        public static string strAction_FCOnGoalShot = "FCShotOnGoal";
        public static string strAction_FCNoGoalShot = "FCShotNoGoal";
        public static string strAction_FCGoal = "FCGoal";
        public static string strAction_YCard = "YCard";
        public static string strAction_2YCard = "2YCard";
        public static string strAction_RCard = "RCard";
        public static string strAction_CornerClick = "CornerClick";
        public static string strAction_Offiside = "Offiside";
        public static string strAction_FC = "FoulCommitted";
        public static string strAction_FS = "FoulSuffered";
        public static string strAction_In = "In";
        public static string strAction_Out = "Out";

        public static OVRFBPlugin g_FBPlugin;
        public static SqlConnection g_sqlConn;
        public static OVRFBManagerDB g_ManageDB;

        //Action 关联
        public static Dictionary<string, string> m_dicAction = new Dictionary<string, string>
        {
            {"11", strAction_Goal},
            {"12", strAction_OnGoalShot},
            {"13", strAction_OnGoalShot},
            {"14", strAction_NoGoalShot},
            {"21", strAction_PGoal},
            {"22", strAction_POnGoalShot},
            {"23", strAction_POnGoalShot},
            {"24", strAction_PNoGoalShot},
            {"31", strAction_FCGoal},
            {"32", strAction_FCOnGoalShot},
            {"33", strAction_FCOnGoalShot},
            {"34", strAction_FCNoGoalShot},
            {"04", strAction_OwnGoal},
            {"05", strAction_YCard},
            {"06", strAction_2YCard},
            {"07", strAction_RCard},
            {"08", strAction_CornerClick},
            {"09", strAction_Offiside},
            {"010", strAction_FC},
            {"011", strAction_FS},
            {"012", strAction_In},
            {"013", strAction_Out}
        };

        //与 Statistic 关联
        public static Dictionary<string, string> m_dicPlayerStat = new Dictionary<string, string>
        {
            {"11", strStat_Goal_Player},
            {"12", strStat_ShotOnGoal_Player},
            {"13", strStat_ShotOnGoal_Player},
            {"14", strStat_ShotNoGoal_Player},
            {"21", strStat_PG_Player},
            {"22", strStat_PSOnGoal_Player},
            {"23", strStat_PSOnGoal_Player},
            {"24", strStat_PSNoGoal_Player},
            {"31", strStat_FCG_Player},
            {"32", strStat_FCOnGoal_Player},
            {"33", strStat_FCOnGoal_Player},
            {"34", strStat_FCNoGoal_Player},
            {"04", strStat_OG_Player},
            {"05", strStat_YCard_Player},
            {"06", strStat_2YCard_Player},
            {"07", strStat_RCard_Player},
            {"08", strStat_CK_Team},
            {"09", strStat_OF_Team},
            {"010", strStat_FC_Player},
            {"011", strStat_FS_Player},
            {"014", strStat_PNO_Team}
        };

        //与守门员技术统计关联
        public static Dictionary<string, string> m_dicGKStat = new Dictionary<string, string>
        {
            {"11",  strStat_GA_Player},
            {"21",  strStat_GA_Player},
            {"31",  strStat_GA_Player},
            {"04",  strStat_GA_Player},
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

            string[] strSplitTime = strFormatTime.Split(':');

            int iHour = 0;
            int iMin = 0;
            int iSec = 0;
            iHour = GVAR.Str2Int(strSplitTime[0]) * 3600;
            iMin = GVAR.Str2Int(strSplitTime[1]) * 60;
            iSec = GVAR.Str2Int(strSplitTime[2]);
            strTime = (iHour + iSec + iMin).ToString();
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
        //x0:00
        public static string TranslateINT32toTime(long nTimeInSec)
        {
           
            long intMin, intSec;
            string strTime = string.Empty;
            string strTemp = string.Empty;
            if (nTimeInSec <0)
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
            if (strTime.Length ==0)
            {
                return 0;
            }
            strTime = strTime.Trim();
            string[] split = strTime.Split(':');
            return Convert.ToInt32(split[0])*60+Convert.ToInt32(split[1]);
        }
    }
}
