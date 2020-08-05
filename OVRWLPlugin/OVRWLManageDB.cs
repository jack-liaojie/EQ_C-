using System;
using System.Collections.Generic;
using System.Text;

using System.Windows.Forms;
using System.Data.SqlClient;
using System.Collections;
using System.Data;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
namespace AutoSports.OVRWLPlugin
{
    public class OVRWLManageDB
    {
        public OVRWLManageDB()
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
            m_strDisciplineID = GetDisplnID(GVWL.g_strDisplnCode).ToString();

            return true;
        }

        // Database Exchange
        public int GetActiveSportID()
        {
            String strSQL = "SELECT F_SportID, F_SportCode FROM TS_Sport WHERE F_Active=1";

            return (int)GVWL.g_adoDataBase.ExecuteScalar(strSQL);
        }

        public int GetDisplnID(String strDisplnCode)
        {
            if (GVWL.g_adoDataBase.DBConnect.State == ConnectionState.Closed)
            {
                GVWL.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                String strSQL = "SELECT F_DisciplineID, F_DisciplineCode FROM TS_Discipline WHERE F_DisciplineCode='";
                strSQL += strDisplnCode + "'";
                Object obj = GVWL.g_adoDataBase.ExecuteScalar(strSQL);
                if (obj == null)
                {
                    MessageBoxEx.Show(LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "DataBase_WL_NOT_Exist"), "");
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
            if (GVWL.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVWL.g_adoDataBase.DBConnect.Open();
            }

            string strSQLDes;
            strSQLDes = "SELECT F_LanguageCode FROM TC_Language WHERE F_Active = 1";
            SqlCommand cmd = new SqlCommand(strSQLDes, GVWL.g_adoDataBase.DBConnect);

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
                System.Data.SqlClient.SqlConnection con = GVWL.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_WL_GetMatchInfo", con);
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

        public DataTable GetRecordList(int nMatchID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVWL.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_WL_GetRecordList", con);
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

        public DataTable GetMatchPlayerList(int nMatchID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVWL.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_WL_GetMatchPlayerList", con);
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

        public DataTable GetEventPlayerList(int nMatchID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVWL.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_WL_GetEventPlayerList", con);
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

        public bool UpdatePlayerLightOrder(int nMatchID, int nCompetitionPosition, string strLightOrder)
        {
            if (GVWL.g_adoDataBase.DBConnect.State == ConnectionState.Closed)
            {
                GVWL.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                String strFmt = @"UPDATE TS_Match_Result SET F_CompetitionPositionDes2 ={0} 
                                WHERE F_MatchID = {1} AND F_RegisterID ={2}";

                if (strLightOrder.Length == 0)
                    strFmt = @"UPDATE TS_Match_Result SET F_CompetitionPositionDes2 =NULL 
                                WHERE F_MatchID = {1} AND F_RegisterID ={2}";

                String strSQL = String.Format(strFmt, strLightOrder, nMatchID, nCompetitionPosition);

                return GVWL.g_adoDataBase.ExecuteUpdateSQL(strSQL);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }
        }

        public bool UpdatePlayerStatus(int nMatchID, int nCompetitionPosition, string strStatus)
        {
            if (GVWL.g_adoDataBase.DBConnect.State == ConnectionState.Closed)
            {
                GVWL.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                String strFmt = @"UPDATE TS_Match_Result SET F_RealScore ={0} 
                                WHERE F_MatchID = {1} AND F_RegisterID ={2}";

                if (strStatus.Length == 0)
                    strFmt = @"UPDATE TS_Match_Result SET F_RealScore =NULL 
                                WHERE F_MatchID = {1} AND F_RegisterID ={2}";

                String strSQL = String.Format(strFmt, strStatus, nMatchID, nCompetitionPosition);

                return GVWL.g_adoDataBase.ExecuteUpdateSQL(strSQL);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }
        }

        public bool UpdateMatchStatus(int nMatchID, int nMatchStatusID)
        {
            Int32 nChangeStatusResult = 0;

            nChangeStatusResult = OVRDataBaseUtils.ChangeMatchStatus(
                nMatchID, nMatchStatusID,
                GVWL.g_adoDataBase.DBConnect, GVWL.g_WLPlugin);

            if (nChangeStatusResult == 1)
                return true;
            else
                return false;
        }

        public bool AutoProgressMatch(int nMatchID)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = GVWL.g_adoDataBase.DBConnect;
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

        public bool UpdateMatchResult(int nMatchID, int nCompetitionPosition,
            string str1stAttempt, string str1stRes, string str2ndAttempt, string str2ndRes, string str3rdAttempt, string str3rdRes,
            string strResult, string strRank, string strDisplayPosition, string strIRMCode)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = GVWL.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_WL_UpdateMatchResult", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionPosition", DataRowVersion.Current, nCompetitionPosition));

                if (str1stAttempt.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@1stAttempt", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@1stAttempt", DataRowVersion.Current, str1stAttempt));
                else
                    cmd.Parameters.Add(new SqlParameter("@1stAttempt", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@1stAttempt", DataRowVersion.Current, DBNull.Value));
                if (str1stRes.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@1stRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@1stRes", DataRowVersion.Current, str1stRes));
                else
                    cmd.Parameters.Add(new SqlParameter("@1stRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@1stRes", DataRowVersion.Current, DBNull.Value));
                if (str2ndAttempt.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@2ndAttempt", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@2ndAttempt", DataRowVersion.Current, str2ndAttempt));
                else
                    cmd.Parameters.Add(new SqlParameter("@2ndAttempt", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@2ndAttempt", DataRowVersion.Current, DBNull.Value));
                if (str2ndRes.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@2ndRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@2ndRes", DataRowVersion.Current, str2ndRes));
                else
                    cmd.Parameters.Add(new SqlParameter("@2ndRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@2ndRes", DataRowVersion.Current, DBNull.Value));
                if (str3rdAttempt.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@3rdAttempt", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@3rdAttempt", DataRowVersion.Current, str3rdAttempt));
                else
                    cmd.Parameters.Add(new SqlParameter("@3rdAttempt", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@3rdAttempt", DataRowVersion.Current, DBNull.Value));
                if (str3rdRes.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@3rdRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@3rdRes", DataRowVersion.Current, str3rdRes));
                else
                    cmd.Parameters.Add(new SqlParameter("@3rdRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@3rdRes", DataRowVersion.Current, DBNull.Value));
                if (strResult.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Result", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Result", DataRowVersion.Current, strResult));
                else
                    cmd.Parameters.Add(new SqlParameter("@Result", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Result", DataRowVersion.Current, DBNull.Value));
                if (strRank.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Rank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Rank", DataRowVersion.Current, strRank));
                else
                    cmd.Parameters.Add(new SqlParameter("@Rank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Rank", DataRowVersion.Current, DBNull.Value));
                if (strDisplayPosition.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@DisplayPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisplayPosition", DataRowVersion.Current, strDisplayPosition));
                else
                    cmd.Parameters.Add(new SqlParameter("@DisplayPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisplayPosition", DataRowVersion.Current, DBNull.Value));
                if (strIRMCode.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@IRMCode", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@IRMCode", DataRowVersion.Current, strIRMCode));
                else
                    cmd.Parameters.Add(new SqlParameter("@IRMCode", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@IRMCode", DataRowVersion.Current, DBNull.Value));

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

        public bool UpdatePhaseResult(int nMatchID, int nCompetitionPosition, string strSnatchResult, string strCleanJerkResult, string strTotalResult, string strTotalRank, string strTotalDisplayPosition, string strTotalIRMCode)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = GVWL.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_WL_UpdatePhaseResult", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionPosition", DataRowVersion.Current, nCompetitionPosition));
                if (strSnatchResult.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@SnatchResult", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@SnatchResult", DataRowVersion.Current, strSnatchResult));
                else
                    cmd.Parameters.Add(new SqlParameter("@SnatchResult", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@SnatchResult", DataRowVersion.Current, DBNull.Value));
                if (strCleanJerkResult.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@CleanJerkResult", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerkResult", DataRowVersion.Current, strCleanJerkResult));
                else
                    cmd.Parameters.Add(new SqlParameter("@CleanJerkResult", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerkResult", DataRowVersion.Current, DBNull.Value));
                if (strTotalResult.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@TotalResult", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@TotalResult", DataRowVersion.Current, strTotalResult));
                else
                    cmd.Parameters.Add(new SqlParameter("@TotalResult", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@TotalResult", DataRowVersion.Current, DBNull.Value));
                if (strTotalRank.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@TotalRank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@TotalRank", DataRowVersion.Current, strTotalRank));
                else
                    cmd.Parameters.Add(new SqlParameter("@TotalRank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@TotalRank", DataRowVersion.Current, DBNull.Value));
                if (strTotalDisplayPosition.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@TotalDisplayPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@TotalDisplayPosition", DataRowVersion.Current, strTotalDisplayPosition));
                else
                    cmd.Parameters.Add(new SqlParameter("@TotalDisplayPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@TotalDisplayPosition", DataRowVersion.Current, DBNull.Value));
                if (strTotalIRMCode.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@TotalIRMCode", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@TotalIRMCode", DataRowVersion.Current, strTotalIRMCode));
                else
                    cmd.Parameters.Add(new SqlParameter("@TotalIRMCode", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@TotalIRMCode", DataRowVersion.Current, DBNull.Value));
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

        public bool UpdateEventResult(int nMatchID, int nRegisterID, string strSnatchResult, string strSnatchRank, string strCleanJerkResult, string strCleanJerkRank, string strTotalResult, string strTotalRank, string strTotalDisplayPosition, string strTotalIRMCode)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = GVWL.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_WL_UpdateEventResult", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@RegisterID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RegisterID", DataRowVersion.Current, nRegisterID));
                if (strSnatchResult.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@SnatchResult", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@SnatchResult", DataRowVersion.Current, strSnatchResult));
                else
                    cmd.Parameters.Add(new SqlParameter("@SnatchResult", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@SnatchResult", DataRowVersion.Current, DBNull.Value));
                if (strSnatchRank.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@SnatchRank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SnatchRank", DataRowVersion.Current, strSnatchRank));
                else
                    cmd.Parameters.Add(new SqlParameter("@SnatchRank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SnatchRank", DataRowVersion.Current, DBNull.Value));
                if (strCleanJerkResult.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@CleanJerkResult", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerkResult", DataRowVersion.Current, strCleanJerkResult));
                else
                    cmd.Parameters.Add(new SqlParameter("@CleanJerkResult", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerkResult", DataRowVersion.Current, DBNull.Value));
                if (strCleanJerkRank.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@CleanJerkRank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CleanJerkRank", DataRowVersion.Current, strCleanJerkRank));
                else
                    cmd.Parameters.Add(new SqlParameter("@CleanJerkRank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CleanJerkRank", DataRowVersion.Current, DBNull.Value));
                if (strTotalResult.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@TotalResult", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@TotalResult", DataRowVersion.Current, strTotalResult));
                else
                    cmd.Parameters.Add(new SqlParameter("@TotalResult", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@TotalResult", DataRowVersion.Current, DBNull.Value));
                if (strTotalRank.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@TotalRank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@TotalRank", DataRowVersion.Current, strTotalRank));
                else
                    cmd.Parameters.Add(new SqlParameter("@TotalRank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@TotalRank", DataRowVersion.Current, DBNull.Value));
                if (strTotalDisplayPosition.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@TotalDisplayPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@TotalDisplayPosition", DataRowVersion.Current, strTotalDisplayPosition));
                else
                    cmd.Parameters.Add(new SqlParameter("@TotalDisplayPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@TotalDisplayPosition", DataRowVersion.Current, DBNull.Value));
                if (strTotalIRMCode.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@TotalIRMCode", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@TotalIRMCode", DataRowVersion.Current, strTotalIRMCode));
                else
                    cmd.Parameters.Add(new SqlParameter("@TotalIRMCode", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@TotalIRMCode", DataRowVersion.Current, DBNull.Value));
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

        public bool UpdatePlayerFinishOrder(int nMatchID, int nRegisterID, string strFinishOrder)
        {
            if (GVWL.g_adoDataBase.DBConnect.State == ConnectionState.Closed)
            {
                GVWL.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                String strFmt = @"UPDATE TS_Event_Result SET F_EventPointsIntDes1 ={0} 
                                WHERE F_EventID = (SELECT E.F_EventID FROM TS_Match AS M 
                                LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
                                LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
                                WHERE F_MatchID = {1}) AND F_RegisterID ={2}";

                if (strFinishOrder.Length == 0)
                    strFmt = @"UPDATE TS_Event_Result SET F_EventPointsIntDes1 =NULL 
                                WHERE F_EventID = (SELECT E.F_EventID FROM TS_Match AS M 
                                LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
                                LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
                                WHERE F_MatchID = {1}) AND F_RegisterID ={2}";

                String strSQL = String.Format(strFmt, strFinishOrder, nMatchID, nRegisterID);

                return GVWL.g_adoDataBase.ExecuteUpdateSQL(strSQL);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }
        }

        public bool UpdateRecord(int nMatchID, int nCompetitionPosition, string strSubEventCode, string strRecordValue, int RecordTypeID, int isEquals)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = GVWL.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_WL_UpdateRecord", con);
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

        public bool UpdatePlayerBodyWeight(int nMatchID, int RegisterID, string bodyweight,string SnatchAtt,string CleanJAtt)
        {
            if (GVWL.g_adoDataBase.DBConnect.State == ConnectionState.Closed)
            {
                GVWL.g_adoDataBase.DBConnect.Open();
            }
            try
            { 
                SqlCommand cmd = new SqlCommand("Proc_WL_UpdatePhaseWeight", GVWL.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionPosition", DataRowVersion.Current, RegisterID));
                if (bodyweight.Length !=0)
                    cmd.Parameters.Add(new SqlParameter("@Weight", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Weight", DataRowVersion.Current, bodyweight));
                else
                    cmd.Parameters.Add(new SqlParameter("@Weight", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Weight", DataRowVersion.Current, DBNull.Value));

                cmd.Parameters.Add(new SqlParameter("@SAtt1", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@SAtt1", DataRowVersion.Current, SnatchAtt));
                cmd.Parameters.Add(new SqlParameter("@CJAtt1", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CJAtt1", DataRowVersion.Current, CleanJAtt));
                SqlParameter cmdParameterResult = new SqlParameter("@Return", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }
        }
        
        public DataTable GetRecords(int nMatchID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVWL.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_WL_GetRecords", con);
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
        
        public bool UpdateMatchWeighinTime(int nMatchID, string nStrTime)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = GVWL.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();
                SqlCommand cmd = new SqlCommand("Proc_WL_UpdateMatchWeighinTime", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@Time", SqlDbType.VarChar, 100, ParameterDirection.Input, true, 0, 0, "@Time", DataRowVersion.Current, nStrTime));
                SqlParameter cmdParameterResult = new SqlParameter("@Return", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;
                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }
        }
        
        public string GetMatchWeighinTime(int nMatchID)
        {
            if (GVWL.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVWL.g_adoDataBase.DBConnect.Open();
            }

            System.Data.SqlClient.SqlConnection con = GVWL.g_adoDataBase.DBConnect;
            if (con.State != ConnectionState.Open)
                con.Open();

            SqlCommand cmd = new SqlCommand("Proc_WL_GetMatchWeighinTime", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));

            string strTime = "";
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                strTime = OVRDataBaseUtils.GetFieldValue2String(ref dr, "WeighinTime");
            }
            dr.Close();
            return strTime;
        }

        public DataTable GetPlayerRecords(int nMatchID, int nCompetitionPosition)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVWL.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_WL_GetPlayerRecords", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionPosition", DataRowVersion.Current, nCompetitionPosition));
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

        public bool DeleteMatchRecord(string strRecordID)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = GVWL.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_WL_DeleteMatchRecord", con);
                cmd.CommandType = CommandType.StoredProcedure;
                //cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                //cmd.Parameters.Add(new SqlParameter("@CompetitionPosition", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CompetitionPosition", DataRowVersion.Current, nCompetitionPosition));
                if (strRecordID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@RecordID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RecordID", DataRowVersion.Current, strRecordID));
                else
                    cmd.Parameters.Add(new SqlParameter("@RecordID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RecordID", DataRowVersion.Current, DBNull.Value));
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


        public bool InterfaceUpdatePlayerResult(int nLotNum, string Bodyweight
            , string Snatch_1Att, string Snatch_1Res, string Snatch_2Att, string Snatch_2Res, string Snatch_3Att, string Snatch_3Res, string Snatch_Res, string Snatch_Rank
            , string CleanJerk_1Att, string CleanJerk_1Res, string CleanJerk_2Att, string CleanJerk_2Res, string CleanJerk_3Att, string CleanJerk_3Res, string CleanJerk_Res, string CleanJerk_Rank
            , string TotalRes, string TotalRank)
        {
            if (GVWL.g_adoDataBase.DBConnect.State == ConnectionState.Closed)
            {
                GVWL.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                SqlCommand cmd = new SqlCommand("Proc_WL_Interface_UpdateResults", GVWL.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                #region 参数
                cmd.Parameters.Add(new SqlParameter("@LotNum", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@LotNum", DataRowVersion.Current, nLotNum)); 
                if (Bodyweight.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Bodyweight", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Bodyweight", DataRowVersion.Current, Bodyweight));
                else
                    cmd.Parameters.Add(new SqlParameter("@Bodyweight", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Bodyweight", DataRowVersion.Current, DBNull.Value));
                
                if (Snatch_1Att.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Snatch_1Att", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Snatch_1Att", DataRowVersion.Current, Snatch_1Att));
                else
                    cmd.Parameters.Add(new SqlParameter("@Snatch_1Att", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Snatch_1Att", DataRowVersion.Current, DBNull.Value));
                if (Snatch_1Res.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Snatch_1AttRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Snatch_1AttRes", DataRowVersion.Current, Snatch_1Res));
                else
                    cmd.Parameters.Add(new SqlParameter("@Snatch_1AttRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Snatch_1AttRes", DataRowVersion.Current, DBNull.Value));

                if (Snatch_2Att.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Snatch_2Att", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Snatch_2Att", DataRowVersion.Current, Snatch_2Att));
                else
                    cmd.Parameters.Add(new SqlParameter("@Snatch_2Att", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Snatch_2Att", DataRowVersion.Current, DBNull.Value));
                if (Snatch_2Res.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Snatch_2AttRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Snatch_2AttRes", DataRowVersion.Current, Snatch_2Res));
                else
                    cmd.Parameters.Add(new SqlParameter("@Snatch_2AttRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Snatch_2AttRes", DataRowVersion.Current, DBNull.Value));

                if (Snatch_3Att.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Snatch_3Att", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Snatch_3Att", DataRowVersion.Current, Snatch_3Att));
                else
                    cmd.Parameters.Add(new SqlParameter("@Snatch_3Att", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Snatch_3Att", DataRowVersion.Current, DBNull.Value));
                if (Snatch_3Res.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Snatch_3AttRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Snatch_3AttRes", DataRowVersion.Current, Snatch_3Res));
                else
                    cmd.Parameters.Add(new SqlParameter("@Snatch_3AttRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Snatch_3AttRes", DataRowVersion.Current, DBNull.Value));

                if (Snatch_Res.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Snatch_Res", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Snatch_Res", DataRowVersion.Current, Snatch_Res));
                else
                    cmd.Parameters.Add(new SqlParameter("@Snatch_Res", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@Snatch_Res", DataRowVersion.Current, DBNull.Value));
                if (Snatch_Rank.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Snatch_Rank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Snatch_Rank", DataRowVersion.Current, Snatch_Rank));
                else
                    cmd.Parameters.Add(new SqlParameter("@Snatch_Rank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Snatch_Rank", DataRowVersion.Current, DBNull.Value)); 

                if (CleanJerk_1Att.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_1Att", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerk_1Att", DataRowVersion.Current, CleanJerk_1Att));
                else
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_1Att", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerk_1Att", DataRowVersion.Current, DBNull.Value));
                if (CleanJerk_1Res.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_1AttRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerk_1AttRes", DataRowVersion.Current, CleanJerk_1Res));
                else
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_1AttRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerk_1AttRes", DataRowVersion.Current, DBNull.Value));

                if (CleanJerk_2Att.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_2Att", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerk_2Att", DataRowVersion.Current, CleanJerk_2Att));
                else
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_2Att", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerk_2Att", DataRowVersion.Current, DBNull.Value));
                if (CleanJerk_2Res.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_2AttRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerk_2AttRes", DataRowVersion.Current, CleanJerk_2Res));
                else
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_2AttRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerk_2AttRes", DataRowVersion.Current, DBNull.Value));

                if (CleanJerk_3Att.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_3Att", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerk_3Att", DataRowVersion.Current, CleanJerk_3Att));
                else
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_3Att", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerk_3Att", DataRowVersion.Current, DBNull.Value));
                if (CleanJerk_3Res.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_3AttRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerk_3AttRes", DataRowVersion.Current, CleanJerk_3Res));
                else
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_3AttRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerk_3AttRes", DataRowVersion.Current, DBNull.Value));

                if (CleanJerk_Res.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_Res", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerk_Res", DataRowVersion.Current, CleanJerk_Res));
                else
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_Res", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@CleanJerk_Res", DataRowVersion.Current, DBNull.Value));
                if (CleanJerk_Rank.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_Rank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CleanJerk_Rank", DataRowVersion.Current, CleanJerk_Rank));
                else
                    cmd.Parameters.Add(new SqlParameter("@CleanJerk_Rank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CleanJerk_Rank", DataRowVersion.Current, DBNull.Value));
                
                if (TotalRes.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@TotalRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@TotalRes", DataRowVersion.Current, TotalRes));
                else
                    cmd.Parameters.Add(new SqlParameter("@TotalRes", SqlDbType.VarChar, 10, ParameterDirection.Input, true, 0, 0, "@TotalRes", DataRowVersion.Current, DBNull.Value));
                if (TotalRank.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@TotalRank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@TotalRank", DataRowVersion.Current, TotalRank));
                else
                    cmd.Parameters.Add(new SqlParameter("@TotalRank", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@TotalRank", DataRowVersion.Current, DBNull.Value));
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
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }
        }

        internal void UpdateEventResult(int m_nCurMatchID, int p, string strSnatchResult, string strCJResult, string strTotalResult, string strEventRank, string p_2, string strTotalIRM)
        {
            throw new NotImplementedException();
        }
    }
}
