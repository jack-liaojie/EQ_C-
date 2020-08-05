using System;
using System.Collections.Generic;
using System.Text;

using System.Windows.Forms;
using System.Data.SqlClient;
using System.Collections;
using System.Data;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
namespace AutoSports.OVRARPlugin
{
    public class OVRARManageDB
    {

        public OVRARManageDB()
        {
            m_strDisciplineID = "";
            m_strSportID = "";
        }
        public String m_strDisciplineID;
        public String m_strSportID;

        // Init Data
        public bool InitGame()
        {
            m_strSportID = GetActiveSportID().ToString();
            m_strDisciplineID = GetDisplnID(GVAR.g_strDisplnCode).ToString();

            return true;
        }

        #region 公共
        // Database Exchange
        public int GetActiveSportID()
        {
            String strSQL = "SELECT F_SportID, F_SportCode FROM TS_Sport WHERE F_Active=1";

            return (int)GVAR.g_adoDataBase.ExecuteScalar(strSQL);
        }
        public int GetDisplnID(String strDisplnCode)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                String strSQL = "SELECT F_DisciplineID, F_DisciplineCode FROM TS_Discipline WHERE F_DisciplineCode='";
                strSQL += strDisplnCode + "'";
                Object obj = GVAR.g_adoDataBase.ExecuteScalar(strSQL);
                if (obj == null)
                {
                    MessageBoxEx.Show(LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "DataBase_AR_NOT_Exist"), "");
                    return -1;
                }
                else
                {
                    return (int)obj;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return -1;
            }
        }
        public string GetCurActivedLanguageCode()
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            string strSQLDes;
            strSQLDes = "SELECT F_LanguageCode FROM TC_Language WHERE F_Active = 1";
            SqlCommand cmd = new SqlCommand(strSQLDes, GVAR.g_adoDataBase.DBConnect);

            string strLanguage = "";
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                strLanguage = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_LanguageCode");
            }
            dr.Close();
            return strLanguage;
        }
        public DataTable GetMatchInfo(int nMatchID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_GetMatchInfo", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, GetCurActivedLanguageCode()));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dt;
        }
        public bool AutoProgressMatch(int nMatchID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AutoProgressMatch", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();
                return true;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }
        public bool UpdateMatchStatus(int nMatchID, int nMatchStatusID)
        {
            Int32 nChangeStatusResult = 0;

            nChangeStatusResult = OVRDataBaseUtils.ChangeMatchStatus(
                nMatchID, nMatchStatusID,
                GVAR.g_adoDataBase.DBConnect, GVAR.g_ARPlugin);

            if (nChangeStatusResult == 1)
                return true;
            else
                return false;
        }

        #endregion

        #region 记录
        public DataTable GetRecordList(int nMatchID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_GetRecordList", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, GetCurActivedLanguageCode()));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
                da.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dt;
        }

        public bool UpdateRecord(int nMatchID, int nCompetitionPosition, string strSubEventCode, string strRecordValue, int RecordTypeID, int isEquals)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_UpdateRecord", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionPosition", DataRowVersion.Current, nCompetitionPosition));
                if (strSubEventCode.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@SubEventCode", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@SubEventCode", DataRowVersion.Current, strSubEventCode));
                else
                    cmd.Parameters.Add(new SqlParameter("@SubEventCode", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@SubEventCode", DataRowVersion.Current, DBNull.Value));
                if (strRecordValue.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@RecordValue", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@RecordValue", DataRowVersion.Current, strRecordValue));
                else
                    cmd.Parameters.Add(new SqlParameter("@RecordValue", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@RecordValue", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@RecordTypeID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RecordTypeID", DataRowVersion.Current, RecordTypeID));
                cmd.Parameters.Add(new SqlParameter("@IsEqual", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@IsEqual", DataRowVersion.Current, isEquals));
                SqlParameter cmdParameterResult = new SqlParameter("@Return", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        public int DeleteMatchRecord(string strRecordID, string strRecordValue)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_DeleteRecord", con);
                cmd.CommandType = CommandType.StoredProcedure;
                //cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                //cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionPosition", DataRowVersion.Current, nCompetitionPosition));
                if (strRecordID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@RecordID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RecordID", DataRowVersion.Current, strRecordID));
                else
                    cmd.Parameters.Add(new SqlParameter("@RecordID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RecordID", DataRowVersion.Current, DBNull.Value));
                if (strRecordID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@RecordValue", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RecordValue", DataRowVersion.Current, strRecordValue));
                else
                    cmd.Parameters.Add(new SqlParameter("@RecordValue", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RecordValue", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Return", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                return (Int32)cmdParameterResult.Value;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return -1;
            }
        }
        #endregion

        #region 淘汰赛
        public bool UpdateMatchSettings(int nMatchID, int nEndCount, int nArrowCount, int nIsSetPoints,
            int nWinPoints, int nDistince, int nMatchRuleID, int nMatchStatusID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_UpdateMatchSetting", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@EndCount", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EndCount", DataRowVersion.Current, nEndCount));
                cmd.Parameters.Add(new SqlParameter("@ArrowCount", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@ArrowCount", DataRowVersion.Current, nArrowCount));
                cmd.Parameters.Add(new SqlParameter("@IsSetPoints", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@IsSetPoints", DataRowVersion.Current, nIsSetPoints));
                cmd.Parameters.Add(new SqlParameter("@WinPoints", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@WinPoints", DataRowVersion.Current, nWinPoints));
                cmd.Parameters.Add(new SqlParameter("@Distince", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Distince", DataRowVersion.Current, nDistince));
                cmd.Parameters.Add(new SqlParameter("@CompetitionRuleID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionRuleID", DataRowVersion.Current, nMatchRuleID));
                cmd.Parameters.Add(new SqlParameter("@MatchStatusID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchStatusID", DataRowVersion.Current, nMatchStatusID));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        public bool UpdateMatchResult(int nMatchID, int nCompetitionPosition, string str10Num, string strXsNum, string strTotal, string strPoint, string strRank, string strDisplayPosition, string strIRMCode, string strTarget)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_UpdateMatchResult", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionPosition", DataRowVersion.Current, nCompetitionPosition));
                if (strDisplayPosition.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@DisplayPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisplayPosition", DataRowVersion.Current, strDisplayPosition));
                else
                    cmd.Parameters.Add(new SqlParameter("@DisplayPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisplayPosition", DataRowVersion.Current, DBNull.Value));
                if (!string.IsNullOrEmpty(str10Num))
                    cmd.Parameters.Add(new SqlParameter("@10s", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@10s", DataRowVersion.Current, str10Num));
                else
                    cmd.Parameters.Add(new SqlParameter("@10s", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@10s", DataRowVersion.Current, DBNull.Value));
                if (!string.IsNullOrEmpty(strXsNum))
                    cmd.Parameters.Add(new SqlParameter("@Xs", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@Xs", DataRowVersion.Current, strXsNum));
                else
                    cmd.Parameters.Add(new SqlParameter("@Xs", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@Xs", DataRowVersion.Current, DBNull.Value));
                if (!string.IsNullOrEmpty(strTotal))
                    cmd.Parameters.Add(new SqlParameter("@Total", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@Total", DataRowVersion.Current, strTotal));
                else
                    cmd.Parameters.Add(new SqlParameter("@Total", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@Total", DataRowVersion.Current, DBNull.Value));
                if (!string.IsNullOrEmpty(strPoint))
                    cmd.Parameters.Add(new SqlParameter("@Point", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Point", DataRowVersion.Current, strPoint));
                else
                    cmd.Parameters.Add(new SqlParameter("@Point", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Point", DataRowVersion.Current, DBNull.Value));
                if (!string.IsNullOrEmpty(strRank))
                    cmd.Parameters.Add(new SqlParameter("@Rank", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Rank", DataRowVersion.Current, strRank));
                else
                    cmd.Parameters.Add(new SqlParameter("@Rank", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Rank", DataRowVersion.Current, DBNull.Value));
                if (!string.IsNullOrEmpty(strIRMCode))
                    cmd.Parameters.Add(new SqlParameter("@IRMCode", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@IRMCode", DataRowVersion.Current, strIRMCode));
                else
                    cmd.Parameters.Add(new SqlParameter("@IRMCode", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@IRMCode", DataRowVersion.Current, DBNull.Value));
                if (!string.IsNullOrEmpty(strTarget))
                    cmd.Parameters.Add(new SqlParameter("@Target", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Target", DataRowVersion.Current, strTarget));
                else
                    cmd.Parameters.Add(new SqlParameter("@Target", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Target", DataRowVersion.Current, DBNull.Value));

                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        public bool UpdatePhaseResult(int nMatchID, int nCompetitionPosition, string strPhaseResult, string strPhaseBehind, string strPhaseRank, string strPhaseDisplayPosition)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_UpdatePhaseResult", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionPosition", DataRowVersion.Current, nCompetitionPosition));
                if (strPhaseResult.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@PhaseResult", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@PhaseResult", DataRowVersion.Current, strPhaseResult));
                else
                    cmd.Parameters.Add(new SqlParameter("@PhaseResult", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@PhaseResult", DataRowVersion.Current, DBNull.Value));
                if (strPhaseBehind.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@PhaseBehind", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@PhaseBehind", DataRowVersion.Current, strPhaseBehind));
                else
                    cmd.Parameters.Add(new SqlParameter("@PhaseBehind", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@PhaseBehind", DataRowVersion.Current, DBNull.Value));
                if (strPhaseRank.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@PhaseRank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@PhaseRank", DataRowVersion.Current, strPhaseRank));
                else
                    cmd.Parameters.Add(new SqlParameter("@PhaseRank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@PhaseRank", DataRowVersion.Current, DBNull.Value));
                if (strPhaseDisplayPosition.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@PhaseDisplayPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@PhaseDisplayPosition", DataRowVersion.Current, strPhaseDisplayPosition));
                else
                    cmd.Parameters.Add(new SqlParameter("@PhaseDisplayPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@PhaseDisplayPosition", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Return", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        #endregion

        #region 排位赛

        public DataTable GetQualificationPlayerList(int nMatchID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_GetQualificationPlayerList", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, GetCurActivedLanguageCode()));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dt;
        }

        public bool UpdateQualificationMatchResult(int nMatchID, AR_Archer player, int Auto)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_UpdateQualificationMatchResult", con);
                cmd.CommandType = CommandType.StoredProcedure;
                #region Add Parameters
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionPosition", DataRowVersion.Current, player.CompetitionPosition));
                cmd.Parameters.Add(new SqlParameter("@DisplayPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisplayPosition", DataRowVersion.Current, player.DisplayPosition));
                if (player.TotalLongA.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@LongDistinceA", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@LongDistinceA", DataRowVersion.Current, player.TotalLongA));
                else
                    cmd.Parameters.Add(new SqlParameter("@LongDistinceA", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@LongDistinceA", DataRowVersion.Current, DBNull.Value));

                if (player.TotalLongB.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@LongDistinceB", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@LongDistinceB", DataRowVersion.Current, player.TotalLongB));
                else
                    cmd.Parameters.Add(new SqlParameter("@LongDistinceB", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@LongDistinceB", DataRowVersion.Current, DBNull.Value));

                if (player.TotalShortA.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@ShortDistinceA", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@ShortDistinceA", DataRowVersion.Current, player.TotalShortA));
                else
                    cmd.Parameters.Add(new SqlParameter("@ShortDistinceA", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@ShortDistinceA", DataRowVersion.Current, DBNull.Value));
                if (player.TotalShortB.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@ShortDistinceB", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@ShortDistinceB", DataRowVersion.Current, player.TotalShortB));
                else
                    cmd.Parameters.Add(new SqlParameter("@ShortDistinceB", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@ShortDistinceB", DataRowVersion.Current, DBNull.Value));
                if (player.Num10S.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@10s", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@10s", DataRowVersion.Current, player.Num10S));
                else
                    cmd.Parameters.Add(new SqlParameter("@10s", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@10s", DataRowVersion.Current, DBNull.Value));
                if (player.NumXS.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Xs", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Xs", DataRowVersion.Current, player.NumXS));
                else
                    cmd.Parameters.Add(new SqlParameter("@Xs", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Xs", DataRowVersion.Current, DBNull.Value));
                if (player.Total.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Total", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Total", DataRowVersion.Current, player.Total));
                else
                    cmd.Parameters.Add(new SqlParameter("@Total", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Total", DataRowVersion.Current, DBNull.Value));
                if (player.QRank.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Rank", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Rank", DataRowVersion.Current, player.QRank));
                else
                    cmd.Parameters.Add(new SqlParameter("@Rank", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Rank", DataRowVersion.Current, DBNull.Value));
                if (player.IRM.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@IRMCode", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@IRMCode", DataRowVersion.Current, player.IRM));
                else
                    cmd.Parameters.Add(new SqlParameter("@IRMCode", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@IRMCode", DataRowVersion.Current, DBNull.Value));
                if (player.Target.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Target", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Target", DataRowVersion.Current, player.Target));
                else
                    cmd.Parameters.Add(new SqlParameter("@Target", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Target", DataRowVersion.Current, DBNull.Value));
                if (player.ShootOff.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@ShootOff", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@ShootOff", DataRowVersion.Current, player.ShootOff));
                else
                    cmd.Parameters.Add(new SqlParameter("@ShootOff", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@ShootOff", DataRowVersion.Current, DBNull.Value));

                cmd.Parameters.Add(new SqlParameter("@Auto", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Auto", DataRowVersion.Current, Auto));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);

                cmd.Parameters.Add(cmdParameterResult);
                #endregion

                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        public bool UpdateQualificationPhaseResult(int nMatchID, AR_Archer player)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_UpdateQualificationPhaseResult", con);
                cmd.CommandType = CommandType.StoredProcedure;
                #region Add Parameters
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@RegisterID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RegisterID", DataRowVersion.Current, player.RegisterID));
                cmd.Parameters.Add(new SqlParameter("@DisplayPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisplayPosition", DataRowVersion.Current, player.DisplayPosition));
                if (player.TotalLongA.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@LongDistinceA", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@LongDistinceA", DataRowVersion.Current, player.TotalLongA));
                else
                    cmd.Parameters.Add(new SqlParameter("@LongDistinceA", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@LongDistinceA", DataRowVersion.Current, DBNull.Value));

                if (player.TotalLongB.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@LongDistinceB", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@LongDistinceB", DataRowVersion.Current, player.TotalLongB));
                else
                    cmd.Parameters.Add(new SqlParameter("@LongDistinceB", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@LongDistinceB", DataRowVersion.Current, DBNull.Value));

                if (player.TotalShortA.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@ShortDistinceA", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@ShortDistinceA", DataRowVersion.Current, player.TotalShortA));
                else
                    cmd.Parameters.Add(new SqlParameter("@ShortDistinceA", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@ShortDistinceA", DataRowVersion.Current, DBNull.Value));
                if (player.TotalShortB.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@ShortDistinceB", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@ShortDistinceB", DataRowVersion.Current, player.TotalShortB));
                else
                    cmd.Parameters.Add(new SqlParameter("@ShortDistinceB", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@ShortDistinceB", DataRowVersion.Current, DBNull.Value));
                if (player.Total.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Total", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Total", DataRowVersion.Current, player.Total));
                else
                    cmd.Parameters.Add(new SqlParameter("@Total", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Total", DataRowVersion.Current, DBNull.Value));
                if (player.QRank.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Rank", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Rank", DataRowVersion.Current, player.QRank));
                else
                    cmd.Parameters.Add(new SqlParameter("@Rank", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Rank", DataRowVersion.Current, DBNull.Value));
                if (player.IRM.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@IRMCode", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@IRMCode", DataRowVersion.Current, player.IRM));
                else
                    cmd.Parameters.Add(new SqlParameter("@IRMCode", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@IRMCode", DataRowVersion.Current, DBNull.Value));

                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);

                cmd.Parameters.Add(cmdParameterResult);
                #endregion

                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        public int GetMatch10AndXNumbers(int nMatchID, int nEndDistince, int nCompetitionPosition, int nType)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();


                SqlCommand cmd = new SqlCommand("Proc_AR_GetPlayer10OrXNumber", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@EndDistince", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EndDistince", DataRowVersion.Current, nEndDistince));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetationPosition", DataRowVersion.Current, nCompetitionPosition));
                cmd.Parameters.Add(new SqlParameter("@Type", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@EndIndex", DataRowVersion.Current, nType));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, GetCurActivedLanguageCode()));

                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                return (Int32)cmdParameterResult.Value;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return 0;
            }
        }

        public bool UpdateMatchEndsDistinceRanking(int nMatchID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_CalcEndDistinceRanking", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));

                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        #endregion

        #region 箭、局

        public bool UpdatePlayerArrow(int nMatchID, int nCompetitionPosition, int nMathcSplitID, string nArrowIdx, string nRing, int Auto)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_UpdatePlayerArrow", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionPosition", DataRowVersion.Current, nCompetitionPosition));
                cmd.Parameters.Add(new SqlParameter("@MathcSplitID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MathcSplitID", DataRowVersion.Current, nMathcSplitID));
                cmd.Parameters.Add(new SqlParameter("@ArrowIndex", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@ArrowIndex", DataRowVersion.Current, nArrowIdx));
                cmd.Parameters.Add(new SqlParameter("@Ring", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Ring", DataRowVersion.Current, nRing));
                cmd.Parameters.Add(new SqlParameter("@Auto", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Auto", DataRowVersion.Current, Auto));

                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        public bool UpdatePlayerEnd(int nMatchID, int nCompetitionPosition, int nMathcSplitID, string nEndIdx, string nRing, string nSore, string n10Num, string nXNum, int Auto)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_UpdatePlayerEnd", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionPosition", DataRowVersion.Current, nCompetitionPosition));
                cmd.Parameters.Add(new SqlParameter("@MathcSplitID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MathcSplitID", DataRowVersion.Current, nMathcSplitID));
                cmd.Parameters.Add(new SqlParameter("@EndIndex", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@EndIndex", DataRowVersion.Current, nEndIdx));
                cmd.Parameters.Add(new SqlParameter("@Ring", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Ring", DataRowVersion.Current, nRing));
                cmd.Parameters.Add(new SqlParameter("@Score", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Score", DataRowVersion.Current, nSore));
                cmd.Parameters.Add(new SqlParameter("@10Num", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@10Num", DataRowVersion.Current, n10Num));
                cmd.Parameters.Add(new SqlParameter("@Xnum", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Xnum", DataRowVersion.Current, nXNum));
                cmd.Parameters.Add(new SqlParameter("@Auto", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Auto", DataRowVersion.Current, Auto));


                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        public DataTable GetPlayerEnds(int nMatchID, int nEndDistince, int nCompetitionPosition, string nEndIndex)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_GetPlayerEnds", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@EndDistince", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EndDistince", DataRowVersion.Current, nEndDistince));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetationPosition", DataRowVersion.Current, nCompetitionPosition));
                cmd.Parameters.Add(new SqlParameter("@EndIndex", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@EndIndex", DataRowVersion.Current, nEndIndex));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, GetCurActivedLanguageCode()));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dt;
        }

        public DataTable GetPlayerArrows(int nMatchID, int nSplitID, int nCompetitionPosition, string nArrowIndex)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_GetPlayerArrows", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@FatherSplitID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@FatherSplitID", DataRowVersion.Current, nSplitID));
                cmd.Parameters.Add(new SqlParameter("@CompetationPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetationPosition", DataRowVersion.Current, nCompetitionPosition));
                cmd.Parameters.Add(new SqlParameter("@ArrowIndex", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@ArrowIndex", DataRowVersion.Current, nArrowIndex));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, GetCurActivedLanguageCode()));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dt;
        }

        public DataTable GetCompetitionPlayers(int nMatchID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_GetPlayerList", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, GetCurActivedLanguageCode()));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dt;
        }

        public DataTable GetCompetitionTeamMembers(int nMatchID, int nRegisterID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_GetTeamMembers", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@RegisterID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RegisterID", DataRowVersion.Current, nRegisterID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, GetCurActivedLanguageCode()));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dt;
        }

        #endregion

        #region 加赛 - 箭、局

        public bool UpdatePlayerShootArrow(int nMatchID, int nCompetitionPosition, int nMathcSplitID, string nArrowIdx, string nRing, int Auto)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_UpdatePlayerShootOffArrows", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionPosition", DataRowVersion.Current, nCompetitionPosition));
                cmd.Parameters.Add(new SqlParameter("@MathcSplitID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MathcSplitID", DataRowVersion.Current, nMathcSplitID));
                cmd.Parameters.Add(new SqlParameter("@ArrowIndex", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@ArrowIndex", DataRowVersion.Current, nArrowIdx));
                cmd.Parameters.Add(new SqlParameter("@Ring", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Ring", DataRowVersion.Current, nRing));
                cmd.Parameters.Add(new SqlParameter("@Auto", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Auto", DataRowVersion.Current, Auto));

                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        public bool UpdatePlayerShootEnd(int nMatchID, int nCompetitionPosition, int nMathcSplitID, string nEndIdx, string nRing, string nSore, string n10Num, string nXNum, string strComment, int Auto)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_UpdatePlayerShootOffEnds", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionPosition", DataRowVersion.Current, nCompetitionPosition));
                cmd.Parameters.Add(new SqlParameter("@MathcSplitID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MathcSplitID", DataRowVersion.Current, nMathcSplitID));
                cmd.Parameters.Add(new SqlParameter("@EndIndex", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@EndIndex", DataRowVersion.Current, nEndIdx));
                cmd.Parameters.Add(new SqlParameter("@Ring", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Ring", DataRowVersion.Current, nRing));
                cmd.Parameters.Add(new SqlParameter("@Score", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Score", DataRowVersion.Current, nSore));
                cmd.Parameters.Add(new SqlParameter("@10Num", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@10Num", DataRowVersion.Current, n10Num));
                cmd.Parameters.Add(new SqlParameter("@Xnum", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Xnum", DataRowVersion.Current, nXNum));
                cmd.Parameters.Add(new SqlParameter("@Comment", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Comment", DataRowVersion.Current, strComment));
                cmd.Parameters.Add(new SqlParameter("@Auto", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Auto", DataRowVersion.Current, Auto));


                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        public DataTable GetPlayerShootEnds(int nMatchID, int nEndDistince, int nCompetitionPosition, string nEndIndex)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_GetPlayerShootOffEnds", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetationPosition", DataRowVersion.Current, nCompetitionPosition));
                cmd.Parameters.Add(new SqlParameter("@EndIndex", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@EndIndex", DataRowVersion.Current, nEndIndex));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, GetCurActivedLanguageCode()));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dt;
        }

        public DataTable GetPlayerShootArrows(int nMatchID, int nSplitID, int nCompetitionPosition, string nArrowIndex)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_GetPlayerShootOffArrows", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@FatherSplitID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@FatherSplitID", DataRowVersion.Current, nSplitID));
                cmd.Parameters.Add(new SqlParameter("@CompetationPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetationPosition", DataRowVersion.Current, nCompetitionPosition));
                cmd.Parameters.Add(new SqlParameter("@ArrowIndex", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@ArrowIndex", DataRowVersion.Current, nArrowIndex));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, GetCurActivedLanguageCode()));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dt;
        }

        #endregion

        #region 规则
        public int CreateMatchSplits(int nMatchID, int nEndCount, int nArrowCount, int nDistince, int nCreateType)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_CreateMatchSplits", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@EndCount", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EndCount", DataRowVersion.Current, nEndCount));
                cmd.Parameters.Add(new SqlParameter("@ArrowCount", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@ArrowCount", DataRowVersion.Current, nArrowCount));
                cmd.Parameters.Add(new SqlParameter("@Distince", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Distince", DataRowVersion.Current, nDistince));
                cmd.Parameters.Add(new SqlParameter("@CreateType", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CreateType", DataRowVersion.Current, nCreateType));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null)
                    return (Int32)cmdParameterResult.Value;
                else
                    return 0;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return -1;
            }
        }
        public int AddMatchSplits(int nMatchID, int nEndCount, int nArrowCount, int nDistince, int nCreateType)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_AddMatchSplits", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@EndCount", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EndCount", DataRowVersion.Current, nEndCount));
                cmd.Parameters.Add(new SqlParameter("@ArrowCount", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@ArrowCount", DataRowVersion.Current, nArrowCount));
                cmd.Parameters.Add(new SqlParameter("@Distince", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Distince", DataRowVersion.Current, nDistince));
                cmd.Parameters.Add(new SqlParameter("@CreateType", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CreateType", DataRowVersion.Current, nCreateType));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null)
                    return (Int32)cmdParameterResult.Value;
                else
                    return 0;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return -1;
            }
        }
        public bool UpdateMatchInfo(int nMatchID, string strEndCount, string strArrowCount, string strMatchStatusID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_UpdateMatchInfo", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@EndCount", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@EndCount", DataRowVersion.Current, strEndCount));
                cmd.Parameters.Add(new SqlParameter("@ArrowCount", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@ArrowCount", DataRowVersion.Current, strArrowCount));
                cmd.Parameters.Add(new SqlParameter("@MatchStatusID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchStatusID", DataRowVersion.Current, strMatchStatusID));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }
        public int ApplySelRule(int iMatchID, int iMatchRuleID, int IsCreateSplits)
        {
            Int32 iOperateResult = 0;
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_AR_ApplyNewMatchRule";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionRuleID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchRuleID);

                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@CreateSplits", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, IsCreateSplits);

                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);


                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return iOperateResult;
        }
        public int HasMatchSplits(int nMatchID, int nEndCount, int nArrowCount, int nDistince)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_GetIsCreateMatchSplits", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@EndCount", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EndCount", DataRowVersion.Current, nEndCount));
                cmd.Parameters.Add(new SqlParameter("@ArrowCount", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@ArrowCount", DataRowVersion.Current, nArrowCount));
                cmd.Parameters.Add(new SqlParameter("@Distince", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Distince", DataRowVersion.Current, nDistince));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null)
                    return (Int32)cmdParameterResult.Value;
                else
                    return -2;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return -2;
            }
        }
        #endregion

        #region 接口
        public string InterfaceGetRegisterInfo(string nDisciplineCode)
        {
            string data = string.Empty;
            System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
            if (con.State != ConnectionState.Open)
                con.Open();
            try
            {

                SqlCommand cmd = new SqlCommand("Proc_AR_Interface_GetRegisterList", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineCode", SqlDbType.NVarChar, 10, ParameterDirection.Input,
                    true, 0, 0, "@DisciplineCode", DataRowVersion.Current, nDisciplineCode));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input,
                    true, 0, 0, "@LanguageCode", DataRowVersion.Current, GetCurActivedLanguageCode()));

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    if (!string.IsNullOrEmpty(data))
                        data += ";";
                    string temp = string.Empty;
                    for (int i = 0; i < dr.FieldCount; i++)
                    {
                        if (!string.IsNullOrEmpty(temp))
                            temp += ",";
                        temp += dr[i];
                    }
                    data += temp;
                }
                dr.Close();

            }
            catch (Exception ex)
            {
                con.Close();
                //DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            con.Close();
            return data;
        }
        public string InterfaceGetScheduleInfo(string nDisciplineCode)
        {
            string data = string.Empty;
            System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
            if (con.State != ConnectionState.Open)
                con.Open();
            try
            {

                SqlCommand cmd = new SqlCommand("Proc_AR_Interface_GetScheduleInfo", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineCode", SqlDbType.NVarChar, 10, ParameterDirection.Input,
                    true, 0, 0, "@DisciplineCode", DataRowVersion.Current, nDisciplineCode));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input,
                    true, 0, 0, "@LanguageCode", DataRowVersion.Current, GetCurActivedLanguageCode()));

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    if (!string.IsNullOrEmpty(data))
                        data += ";";
                    string temp = string.Empty;
                    for (int i = 0; i < dr.FieldCount; i++)
                    {
                        if (!string.IsNullOrEmpty(temp))
                            temp += ",";
                        temp += dr[i];
                    }
                    data += temp;
                }
                dr.Close();

            }
            catch (Exception ex)
            {
                con.Close();
                //DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            con.Close();
            return data;
        }
        public string InterfaceGetMatchStartList(int nPhaseID)
        {
            string data = string.Empty;
            System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
            if (con.State != ConnectionState.Open)
                con.Open();
            try
            {

                SqlCommand cmd = new SqlCommand("Proc_AR_Interface_GetMatchStartList", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@PhaseID", SqlDbType.Int, 4, ParameterDirection.Input,
                    true, 0, 0, "@PhaseID", DataRowVersion.Current, nPhaseID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input,
                    true, 0, 0, "@LanguageCode", DataRowVersion.Current, GetCurActivedLanguageCode()));

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    if (!string.IsNullOrEmpty(data))
                        data += ";";
                    string temp = string.Empty;
                    for (int i = 0; i < dr.FieldCount; i++)
                    {
                        if (!string.IsNullOrEmpty(temp))
                            temp += ",";
                        temp += dr[i];
                    }
                    data += temp;
                }
                dr.Close();

            }
            catch (Exception ex)
            {
                con.Close();
                //DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            con.Close();
            return data;
        }
        public bool InterfaceUpdatePlayerArrow(int nMatchID, int nRegisterID, 
                    string nEndIdx, string nArrowIdx, string nRing)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_Interface_UpdatePlayerArrow", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@RegisterID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RegisterID", DataRowVersion.Current, nRegisterID));
                cmd.Parameters.Add(new SqlParameter("@EndIndex", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EndIndex", DataRowVersion.Current, nEndIdx));
                cmd.Parameters.Add(new SqlParameter("@ArrowIndex", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@ArrowIndex", DataRowVersion.Current, nArrowIdx));
                cmd.Parameters.Add(new SqlParameter("@Ring", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Ring", DataRowVersion.Current, nRing)); 

                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                //DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }
        public bool InterfaceUpdatePlayerShootOffArrow(int nMatchID, int nRegisterID,
                    string nEndIdx, string nArrowIdx, string nRing,string nDistance)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_AR_Interface_UpdatePlayerShootOffArrow", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@RegisterID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RegisterID", DataRowVersion.Current, nRegisterID));
                cmd.Parameters.Add(new SqlParameter("@EndIndex", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@EndIndex", DataRowVersion.Current, nEndIdx));
                cmd.Parameters.Add(new SqlParameter("@ArrowIndex", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@ArrowIndex", DataRowVersion.Current, nArrowIdx));
                cmd.Parameters.Add(new SqlParameter("@Ring", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Ring", DataRowVersion.Current, nRing));
                cmd.Parameters.Add(new SqlParameter("@Distance", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Distance", DataRowVersion.Current, nDistance));

                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                //DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        #endregion

    }
}
