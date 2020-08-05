 using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using System.Drawing;

namespace AutoSports.OVRSQPlugin
{
    public class SQCommon
    {
        public const Int32 MATCH_TYPE_SINGLE = 1;
        public const Int32 MATCH_TYPE_TEAM = 3;

        public const String MATCH_TYPENAME_SINGLE = "Single";
        public const String MATCH_TYPENAME_TEAM = "Team";

        public const Int32 PAR_TYPE_SCORE = 1;
        public const Int32 SOS_TYPE_SCORE = 2;

        public const Int32 RESULT_TYPE_WIN = 1;
        public const Int32 RESULT_TYPE_LOSE = 2;
        public const Int32 RESULT_TYPE_TIE = 3;

        public const Int32 RANK_TYPE_1ST = 1;
        public const Int32 RANK_TYPE_2ND = 2;
        public const Int32 RANK_TYPE_TIE = 0;

        public const Int32 NONE_POINT = 0;
        public const Int32 A_GAMEPOINT = 1;
        public const Int32 B_GAMEPOINT = 2;
        public const Int32 A_MATCHPOINT = 3;
        public const Int32 B_MATCHPOINT = 4;

        public const Int32 STATUS_SCHEDULE = 30;
        public const Int32 STATUS_STARTLIST = 40;
        public const Int32 STATUS_RUNNING = 50;
        public const Int32 STATUS_SUSPEND = 60;
        public const Int32 STATUS_UNOFFICIAL = 100;
        public const Int32 STATUS_FINISHED = 110;
        public const Int32 STATUS_REVISION = 120;
        public const Int32 STATUS_CANCELED = 130;

        public const String PLAYER_STATUS_RET = "RET";
        public const String PLAYER_STATUS_WD = "WD";
        public const String PLAYER_STATUS_DSQ = "DSQ";
        public const String PLAYER_STATUS_WO = "WO";

        public static Color COLOR_SCORE_BK = System.Drawing.Color.FromArgb(220, 220, 220);
        public static Color COLOR_SCORE_FG = System.Drawing.Color.FromArgb(255, 0, 0);
        public static Color OVR_CLIENT_3DFACE = System.Drawing.Color.FromArgb(184, 207, 233);
        public static Color OVR_CTRL_3DFACE = System.Drawing.Color.FromArgb(212, 228, 242);

        public static Color OVR_GRID_ODD_ROW_COLOR = System.Drawing.Color.FromArgb(230, 239, 248);
        public static Color OVR_GRID_EVEN_ROW_COLOR = System.Drawing.Color.FromArgb(202, 221, 238);

        public static Color OVR_GRID_ATHLETE_COLUMN_COLOR = System.Drawing.Color.DarkGray;

        public const String g_strDisplnCode = "SQ";
        public const String g_strDisplnName = "Squash";
        public const String g_strLang = "CHN";
        public const String g_strExSchduleFileName = "Schedule";
        public const String g_strExAthleteFileName = "AthleteList";
        public const String g_strImPortMatchInfoMode = "MatchInfo_*.xml";
        public const String g_strImPortActionMode = "ScoreList_*.xml";
        public const String g_strImPortMatchResult = "MatchResult_*_Order*.xml";
        public const String g_strParsedFolderName = "ParsedXml";

        public const String m_strSectionName = "OVRSQPlugin";

        public static Boolean g_bUseSetsRule = false;
        public static Boolean g_bUseSplitsRule = false;
        public static OVRSQPlugin g_SQPlugin;
        public static OVRSQDataBase g_adoDataBase;
        public static OVRSQManageDB g_ManageDB;

        //Action Code
        public static string strAction_addScore = "+1";

        public static Int32 Str2Int(Object strObj)
        {
            if (strObj == null) return 0;

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

        public static String Key2Val(Dictionary<String, String> Dicts, String Key)
        {
            try
            {
                return Dicts[Key];
            }
            catch (System.Exception e)
            {
                MessageBox.Show(e.ToString());
                return null;
            }
        }
    }

    public class STableRecordSet
    {
        public ArrayList m_straFieldNames;
        public ArrayList m_str2aRecords;

        public Int32 GetRecordCount()
        {
            return m_str2aRecords.Count;
        }

        public Int32 GetFieldCount()
        {
            return m_straFieldNames.Count;
        }

        public String GetFieldName(Int32 nFieldIdx)
        {
            return (String)m_straFieldNames[nFieldIdx];
        }

        public Int32 GetFieldIdx(String strFieldName)
        {
            return m_straFieldNames.IndexOf(strFieldName);
        }

        public String GetFieldValue(Int32 nRowIdx, String strFieldName)
        {
            Int32 nColIdx = GetFieldIdx(strFieldName);
            if (nColIdx < 0) return "";

            return (String)((ArrayList)m_str2aRecords[nRowIdx])[nColIdx];
        }

        public String GetFieldValue(Int32 nRowIdx, Int32 nColIdx)
        {
            return (String)((ArrayList)m_str2aRecords[nRowIdx])[nColIdx];
        }
    }
}
