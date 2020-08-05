using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;

namespace AutoSports.OVRBKPlugin
{
    public class StatOperation
    {
        public string MatchID;
        public string RoundNo = "0";
        public string MatchNo = "0";
        public bool m_bIsCheckMatchStated = false;

        public bool CheckMatchStated()
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            if (m_bIsCheckMatchStated)
                return true;

            SqlCommand cmd = null;
            cmd = new SqlCommand("Proc_BK_CheckMatchStat", GVAR.g_sqlConn);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter = null;
            cmdParameter = new SqlParameter(
                         "@MatchID", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@MatchID",
                         DataRowVersion.Current, GVAR.Str2Int(MatchID));
            cmd.Parameters.Add(cmdParameter);

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }

            m_bIsCheckMatchStated = true;

            return true;
        }

        public bool PutTeamStatDataToDatabase(string strPeriodType, string strTeamID, List<Statistics> lstStat)
        {
            CheckMatchStated();

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            SqlCommand cmd = null;
            cmd = new SqlCommand("Proc_BK_ImportTeamPeriodStat", GVAR.g_sqlConn);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter = null;

            cmdParameter = new SqlParameter(
                         "@MatchID", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@MatchID",
                         DataRowVersion.Current, GVAR.Str2Int(MatchID));
            cmd.Parameters.Add(cmdParameter);
            cmdParameter = new SqlParameter(
                         "@RoundNo", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@RoundNo",
                         DataRowVersion.Current, GVAR.Str2Int(RoundNo));
            cmd.Parameters.Add(cmdParameter);
            cmdParameter = new SqlParameter(
                         "@MatchNo", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@MatchNo",
                         DataRowVersion.Current, GVAR.Str2Int(MatchNo));
            cmd.Parameters.Add(cmdParameter);
            cmdParameter = new SqlParameter(
                         "@PeriodType", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@PeriodType",
                         DataRowVersion.Current, GVAR.Str2Int(strPeriodType));
            cmd.Parameters.Add(cmdParameter);
            cmdParameter = new SqlParameter(
                         "@TeamID", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@TeamID",
                         DataRowVersion.Current, GVAR.Str2Int(strTeamID));
            cmd.Parameters.Add(cmdParameter);

            MakeStatisticsSqlParameter(lstStat, ref cmd);

            cmdParameter = new SqlParameter(
                         "@Remark", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@Remark",
                         DataRowVersion.Current, DBNull.Value);
            cmd.Parameters.Add(cmdParameter);

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return true;
        }

        public bool PutPlayerStatDataToDatabase(string strPeriodType, string strTeamID, string strPlayerNo, List<Statistics> lstStat)
        {
            CheckMatchStated();

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            SqlCommand cmd = null;
            cmd = new SqlCommand("Proc_BK_ImportPlayerPeriodStat", GVAR.g_sqlConn);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter = null;

            cmdParameter = new SqlParameter(
                         "@MatchID", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@MatchID",
                         DataRowVersion.Current, GVAR.Str2Int(MatchID));
            cmd.Parameters.Add(cmdParameter);
            cmdParameter = new SqlParameter(
                         "@RoundNo", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@RoundNo",
                         DataRowVersion.Current, GVAR.Str2Int(RoundNo));
            cmd.Parameters.Add(cmdParameter);
            cmdParameter = new SqlParameter(
                         "@MatchNo", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@MatchNo",
                         DataRowVersion.Current, GVAR.Str2Int(MatchNo));
            cmd.Parameters.Add(cmdParameter);
            cmdParameter = new SqlParameter(
                         "@PeriodType", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@PeriodType",
                         DataRowVersion.Current, GVAR.Str2Int(strPeriodType));
            cmd.Parameters.Add(cmdParameter);
            cmdParameter = new SqlParameter(
                         "@TeamID", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@TeamID",
                         DataRowVersion.Current, GVAR.Str2Int(strTeamID));
            cmd.Parameters.Add(cmdParameter);
            cmdParameter = new SqlParameter(
                         "@PlayerNo", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@PlayerNo",
                         DataRowVersion.Current, GVAR.Str2Int(strPlayerNo));
            cmd.Parameters.Add(cmdParameter);

            MakeStatisticsSqlParameter(lstStat, ref cmd);

            cmdParameter = new SqlParameter(
                         "@Remark", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@Remark",
                         DataRowVersion.Current, DBNull.Value);
            cmd.Parameters.Add(cmdParameter);

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return true;
        }

        /*
2011	FGM	Field Goals Made	NULL	F_TotalShoots	ENG
2012	FGA	Field Goals Attempt	NULL	F_TotalThrows	ENG
2021	2PTSM	2 Points Made	NULL	F_2PointsShoots	ENG
2022	2PTSA	2 Points Attempt	NULL	F_2PointsThrows	ENG
2031	3PTSM	3 Points Made	NULL	F_3PointsShoots	ENG
2032	3PTSA	3 Points Attempt	NULL	F_3PointsThrows	ENG
2041	FM	Free Made	NULL	F_FreeShoots	ENG
2042	FA	Free Attempt	NULL	F_FreeThrows	ENG
2500	PTS	Points	NULL	F_Points	ENG
2050	TR	Rebounds	NULL	F_Rebounds	ENG
2051	OR	Offensive Rebounds	NULL	F_OffensiveRebounds	ENG
2052	DR	DefensiveRebounds	NULL	F_DefensiveRebounds	ENG
2060	AS	Assists	NULL	F_Assists	ENG
2070	TO	Turnovers	NULL	F_Turnovers	ENG
2080	ST	Steals	NULL	F_Steals	ENG
2090	BS	Blocked Shots	NULL	F_BlockedShots	ENG
2101	OF	Offensive Fouls	NULL	F_OffensiveFouls	ENG
2102	DF	Defensive Fouls	NULL	F_DefensiveFouls	ENG
2100	TF	Fouls	NULL	F_Fouls	ENG
2110	MIN	Minutes Played	NULL	F_MinutesPlayed	ENG
NULL	NULL	NULL	NULL	NULL	NULL
         */
        public void MakeStatisticsSqlParameter(List<Statistics> lstStat, ref SqlCommand cmd)
        {
            SqlParameter cmdParameter = null;
            int nIndex = 1;
            foreach (Statistics oneStatistics in lstStat)
            {
                if (oneStatistics.StatValue == null || oneStatistics.StatValue == string.Empty)
                    oneStatistics.StatValue = "0";

                String sParameterName = "";
                switch (nIndex)
                {
                    case 1:
                        sParameterName = "@FGM";
                        break;
                    case 2:
                        sParameterName = "@FGA";
                        break;
                    case 3:
                        sParameterName = "@2PTSM";
                        break;
                    case 4:
                        sParameterName = "@2PTSA";
                        break;
                    case 5:
                        sParameterName = "@3PTSM";
                        break;
                    case 6:
                        sParameterName = "@3PTSA";
                        break;
                    case 7:
                        sParameterName = "@FM";
                        break;
                    case 8:
                        sParameterName = "@FA";
                        break;
                    case 9:
                        sParameterName = "@PTS";
                        break;
                    case 10:
                        sParameterName = "@TR";
                        break;
                    case 11:
                        sParameterName = "@OR";
                        break;
                    case 12:
                        sParameterName = "@DR";
                        break;
                    case 13:
                        sParameterName = "@AS";
                        break;
                    case 14:
                        sParameterName = "@TO";
                        break;
                    case 15:
                        sParameterName = "@ST";
                        break;
                    case 16:
                        sParameterName = "@BS";
                        break;
                    case 17:
                        sParameterName = "@OF";
                        break;
                    case 18:
                        sParameterName = "@DF";
                        break;
                    case 19:
                        sParameterName = "@TF";
                        break;
                    case 20:
                        sParameterName = "@MIN";
                        break;
                    default:
                        break;
                }
                cmdParameter = new SqlParameter(
                             sParameterName, SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, sParameterName,
                             DataRowVersion.Current, GVAR.Str2Int(oneStatistics.StatValue));
                cmd.Parameters.Add(cmdParameter);

                nIndex++;
            }

            return;
        }
    }
}
