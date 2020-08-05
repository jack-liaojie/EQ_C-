using System;
using System.Data.SqlClient;
using System.Data;
using OVRRUPlugin.Common;
using System.Collections;
using OVRRUPlugin.ViewModel;
using System.Windows.Forms;
using AutoSports.OVRCommon;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace OVRRUPlugin
{
    public class OVRRUManageDB
    {
        #region Fields

        private string m_strActiveDisciplineID;
        private string m_strActiveLanguage;

        #endregion

        #region constructor

        public OVRRUManageDB()
        {
            m_strActiveDisciplineID = "";
            m_strActiveLanguage = "";
        }

        #endregion

        #region DataEntry

        public string GetDataEntryTitle(int matchID)
        {
            string result = "";
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paramTitle = new SqlParameter("@Title", DBNull.Value);
                paramTitle.Size = 200;
                paramTitle.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_RU_GetDataEntryTitle", paramMatchID, paramTitle);
                result = paramTitle.Value.ToString();
            }
            catch (Exception ex)
            {
                Log.WriteLog("RU_Error", ex.Message);
            }
            return result;
        }

        public string GetDataEntryDateAndVenue(int matchID)
        {
            string result = "";
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paramTitle = new SqlParameter("@Title", DBNull.Value);
                paramTitle.Size = 200;
                paramTitle.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_RU_GetDataEntryDateAndVenue", paramMatchID, paramTitle);
                result = paramTitle.Value.ToString();
            }
            catch (Exception ex)
            {
                Log.WriteLog("RU_Error", ex.Message);
            }
            return result;
        }

        public bool IsHaveData(int matchID)
        {
            bool rtnResult = false;
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paraResultID = new SqlParameter("@ResultID", DbType.Int32);
                paraResultID.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_RU_MatchsHasData", paramMatchID, paraResultID);
                if (int.Parse(paraResultID.Value.ToString()) > 0)
                {
                    rtnResult = true;
                }
            }
            catch (Exception w)
            {
                string str = w.Message.ToString();
            }
            return rtnResult;
        }

        public int CreateMatchSplit(Int32 nMatchID, Int32 nMatchType, Int32 nGamesCount, Int32 nTeamSplitCount)
        {
            int result = 0;
            ArrayList paramCollection = new ArrayList();
            string strStoreProcName = "proc_CreateMatchSplits_2_Level";

            paramCollection.Add(new SqlParameter("@MatchID", nMatchID));
            paramCollection.Add(new SqlParameter("@MatchType", nMatchType));
            paramCollection.Add(new SqlParameter("@Level_1_SplitNum", nTeamSplitCount));
            paramCollection.Add(new SqlParameter("@Level_2_SplitNum", nGamesCount));

            paramCollection.Add(new SqlParameter("@CreateType", 2)); // @CreateType = 1 : Create Delete Old and Create New Splits
            paramCollection.Add(new SqlParameter("@Result", -1));
            ((SqlParameter)paramCollection[5]).Direction = ParameterDirection.Output;
            SqlParameter[] aryParams = new SqlParameter[paramCollection.Count];

            paramCollection.CopyTo(aryParams, 0);

            try
            {
                GVAR.g_adoDataBase.ExecuteProcNoQuery(strStoreProcName, aryParams);

                result = (Int32)aryParams[aryParams.Length - 1].Value;
            }
            catch
            {

                return -1;
            }

            return result;
        }

        public MatchScoreInfo GetMatchScoreInfo(int matchID, int comPos)
        {
            MatchScoreInfo matchScoreInfo = new MatchScoreInfo();
            STableRecordSet tb = new STableRecordSet();
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paramCompos= new SqlParameter("@Compos", comPos);
                GVAR.g_adoDataBase.ExecuteProc("Proc_RU_GetMatchScoreInfo", tb, paramMatchID, paramCompos);

                matchScoreInfo.NOC = tb.GetFieldValue(0, "NOC");
                matchScoreInfo.ScoreFirst = GVAR.Str2Int(tb.GetFieldValue(0, "FirstPoints"));
                matchScoreInfo.ScoreSecond = GVAR.Str2Int(tb.GetFieldValue(0, "SecondPoints"));
                matchScoreInfo.ScoreExt = GVAR.Str2Int(tb.GetFieldValue(0, "ExtPoints"));
                matchScoreInfo.ScoreTotal = GVAR.Str2Int(tb.GetFieldValue(0, "TotalPoints"));
                matchScoreInfo.RegisterID = GVAR.Str2Int(tb.GetFieldValue(0, "RegisterID"));
                matchScoreInfo.TeamName = tb.GetFieldValue(0, "TeamName");
                
                matchScoreInfo.TeamLongName = tb.GetFieldValue(0, "TeamLongName");

                matchScoreInfo.TryNum = GVAR.Str2Int(tb.GetFieldValue(0, "TryNum"));
            }
            catch (Exception ex)
            {
                Log.WriteLog("RU_Error", ex.Message);
                return null;
            }

            return matchScoreInfo;
        }

        public void GetMatchCompetitionRuleInfo(int matchID)
        {
            STableRecordSet tb = new STableRecordSet();
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                GVAR.g_adoDataBase.ExecuteProc("Proc_RU_GetCompetitionRuleInfo", tb, paramMatchID);
                GVAR.g_firstHalfTime = GVAR.Str2Int(tb.GetFieldValue(0, "FistHalf"));
                GVAR.g_secondHalfTime = GVAR.Str2Int(tb.GetFieldValue(0, "SecondHalf"));
                GVAR.g_extraTime = GVAR.Str2Int(tb.GetFieldValue(0, "ExtraTime"));
                GVAR.g_hasExtraTime = GVAR.Str2Int(tb.GetFieldValue(0, "HasExt")) == 0 ? false : true;
            }
            catch (Exception ex)
            {
                Log.WriteLog("RU_Error", ex.Message);
            }
        }

        public int GetMatchStatus(int matchID)
        {
            string strSql="";
            strSql = string.Format("select F_MatchStatusID from TS_Match where F_MatchID={0}", matchID);
            return GVAR.Str2Int(GVAR.g_adoDataBase.ExecuteScalar(strSql));
        }

        #endregion

        #region Set TeamMember

        public void InitFunctionCombBox(ref DataGridView dgv, int iColumnIndex, string strFunType)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Fill Function combo

                SqlCommand cmd = new SqlCommand("Proc_RU_GetFunctions", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter2 = new SqlParameter("@CategoryCode", SqlDbType.NVarChar, 20);

                cmdParameter0.Value = GVAR.Str2Int(m_strActiveDisciplineID);
                cmdParameter1.Value = m_strActiveLanguage;
                cmdParameter2.Value = strFunType;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                DataTable table = new DataTable();
                table.Columns.Add("F_FunctionLongName", typeof(string));
                table.Columns.Add("F_FunctionID", typeof(int));
                table.Rows.Add("", "-1");
                table.Load(dr);

                (dgv.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(table, "F_FunctionLongName", "F_FunctionID");
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdateOfficialFunction(int iMatchID, int iRegisterID, int iFunctionID)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchOfficial Function

                SqlCommand cmd = new SqlCommand("Proc_RU_UpdateMatchOfficialFunction", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@FunctionID", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = iRegisterID;
                cmdParameter2.Value = iFunctionID;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameterResult.Value;
                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void InitPositionCombBox(ref DataGridView dgv, int iColumnIndex)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Fill Function combo

                SqlCommand cmd = new SqlCommand("Proc_RU_GetPosition", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = GVAR.Str2Int(m_strActiveDisciplineID);
                cmdParameter1.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                DataTable table = new DataTable();
                table.Columns.Add("F_PositionLongName", typeof(string));
                table.Columns.Add("F_PositionID", typeof(int));
                table.Rows.Add("", "-1");
                table.Load(dr);

                (dgv.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(table, "F_PositionLongName", "F_PositionID");
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdateMatchUniform(int iMatchID, int iTeamPos, int iUniformID)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update TeamMatchUniform
                string strSQL;
                strSQL = string.Format("UPDATE TS_Match_Result SET F_UniformID = {0} WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}", iUniformID, iMatchID, iTeamPos);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_adoDataBase.DBConnect);

                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void ResetAvailableGrid(int iMatchID, int iTeamID, int iTeamPos, ref DataGridView dgv)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleTeamMember
                SqlCommand cmd = new SqlCommand("Proc_RU_GetTeamAvailable", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);

                cmdParameter0.Value = iTeamID;
                cmdParameter1.Value = iMatchID;
                cmdParameter2.Value = m_strActiveLanguage;
                cmdParameter3.Value = iTeamPos;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgv, dr, null, null);

                if (dgv.RowCount >= 0)
                {
                    dgv.Columns["F_MemberID"].Visible = false;
                    dgv.Columns["F_FunctionID"].Visible = false;
                    dgv.Columns["F_PositionID"].Visible = false;

                    for (int i = 0; i < dgv.RowCount; i++)
                    {
                        int iDSQ = GVAR.Str2Int(dgv.Rows[i].Cells["DSQ"].Value);
                        if (iDSQ == 1)
                        {
                            dgv.Rows[i].ReadOnly = true;
                            dgv.Rows[i].DefaultCellStyle.BackColor = System.Drawing.Color.DarkGray;
                        }
                    }
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void ResetMemberGrid(int iMatchID, int iTeamID, int iTeamPos, ref DataGridView dgv, ref int iStartupNumber)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchMember
                SqlCommand cmd = new SqlCommand("Proc_RU_GetMatchMember", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);

                cmdParameter1.Value = iMatchID;
                cmdParameter2.Value = m_strActiveLanguage;
                cmdParameter3.Value = iTeamPos;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();

                int iSelRowIndex = -1;
                if (dgv.Rows.Count > 0 && dgv.SelectedRows.Count != 0)
                {
                    iSelRowIndex = dgv.SelectedRows[0].Index;
                }
                List<int> lstCmbColumns = new List<int>();
                lstCmbColumns.Add(3);
                lstCmbColumns.Add(4);
                lstCmbColumns.Add(5);

                List<OVRCheckBoxColumn> lstChkColumns = new List<OVRCheckBoxColumn>();
                lstChkColumns.Add(new OVRCheckBoxColumn(0, 1, 0));
                OVRDataBaseUtils.FillDataGridView(dgv, dr, lstCmbColumns, lstChkColumns);

                dr.Close();

                if (dgv.RowCount > 0)
                {
                    dgv.Columns["F_MemberID"].Visible = false;
                    dgv.Columns["F_StartupNum"].Visible = false;
                    dgv.Columns["Order"].ReadOnly = false;
                    dgv.Columns["ShirtNumber"].ReadOnly = false;
                    dgv.Columns["DSQ"].ReadOnly = false;

                    iStartupNumber = GVAR.Str2Int(dgv.Rows[0].Cells["F_StartupNum"].Value);

                    dgv.ClearSelection();
                    if (iSelRowIndex > 0 && iSelRowIndex < dgv.Rows.Count)
                    {
                        dgv.Rows[iSelRowIndex].Selected = true;
                    }
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        /// <summary>
        /// 将球员加入首发名单（StartList）

        /// </summary>
        /// <param name="iMatchID"></param>
        /// <param name="iMemberID"></param>
        /// <param name="iTeamPos"></param>
        /// <param name="iFunctionID"></param>
        /// <param name="iShirtNumber"></param>
        public void AddMatchMember(int iMatchID, int iMemberID, int iTeamPos, int iFunctionID, int iPositionID, int iShirtNumber)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Add MatchMember

                SqlCommand cmd = new SqlCommand("Proc_RU_AddMatchMember", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MemberID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@FunctionID", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@PositionID", SqlDbType.Int);
                SqlParameter cmdParameter5 = new SqlParameter("@ShirtNumber", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = iMemberID;
                cmdParameter2.Value = iTeamPos;
                cmdParameter3.Value = iFunctionID;
                cmdParameter4.Value = iPositionID;
                cmdParameter5.Value = iShirtNumber;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameterResult.Value;
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        /// <summary>
        /// 将球员从首发名单删除（StartList）

        /// </summary>
        /// <param name="iMatchID"></param>
        /// <param name="iMemberID"></param>
        /// <param name="iTeamPos"></param>
        public void RemoveMatchMember(int iMatchID, int iMemberID, int iTeamPos)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Remove MatchMember

                SqlCommand cmd = new SqlCommand("Proc_RU_RemoveMatchMember", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MemberID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = iMemberID;
                cmdParameter2.Value = iTeamPos;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameterResult.Value;
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdateMatchMemberFunction(int iMatchID, int iMemberID, int iTeamPos, int iFunctionID)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchMember Function

                SqlCommand cmd = new SqlCommand("Proc_RU_UpdateMatchMemberFunction", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MemberID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@FunctionID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = iMemberID;
                cmdParameter2.Value = iFunctionID;
                cmdParameter3.Value = iTeamPos;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameterResult.Value;
                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdateMatchMembePosition(int iMatchID, int iMemberID, int iTeamPos, int iPositionID)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchMember Function

                SqlCommand cmd = new SqlCommand("Proc_RU_UpdateMatchMemberPosition", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MemberID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@PositionID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = iMemberID;
                cmdParameter2.Value = iPositionID;
                cmdParameter3.Value = iTeamPos;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameterResult.Value;
                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdateMatchMemberShirtNumber(int iMatchID, int iMemberID, int iTeamPos, string strShirtNumber)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchMember ShirtNumber
                string strSQL;
                if (strShirtNumber.Length == 0)
                {
                    strSQL = String.Format("UPDATE TS_Match_Member SET F_ShirtNumber = NULL WHERE F_RegisterID = {0} AND F_CompetitionPosition = {1}  AND F_MatchID = {2}", iMemberID, iTeamPos, iMatchID);
                }
                else
                {
                    strSQL = String.Format("UPDATE TS_Match_Member SET F_ShirtNumber = '{0}' WHERE F_RegisterID = {1} AND F_CompetitionPosition = {2}  AND F_MatchID = {3}", strShirtNumber, iMemberID, iTeamPos, iMatchID);
                }
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_adoDataBase.DBConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdateMemberDSQ(int iRegisterID, int iMemberID, int iIRMID)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchMember IRM
                string strSQL;
                if (iIRMID == -1)
                {
                    strSQL = String.Format("UPDATE TR_Register_Member SET F_Comment = NULL WHERE F_RegisterID = {0} AND F_MemberRegisterID = {1}", iRegisterID, iMemberID);
                }
                else
                {
                    strSQL = String.Format("UPDATE TR_Register_Member SET F_Comment = '{0}' WHERE F_RegisterID = {1} AND F_MemberRegisterID = {2}", iIRMID, iRegisterID, iMemberID);
                }
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_adoDataBase.DBConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void GetTeamUniform(int iTeamID, ref DataTable dtUniform)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get TeamUniform

                SqlCommand cmd = new SqlCommand("Proc_RU_GetUniform", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@TeamID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter1.Value = iTeamID;
                cmdParameter2.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dtUniform.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdatePlayerOrder(int iMatchID, int iPlayerID, int iBatOrder)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update BatOrder
                string strSQL;

                if (iBatOrder == 0)
                {
                    strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Order = NULL WHERE F_MatchID = {0} AND F_RegisterID = {1}", iMatchID, iPlayerID);

                }
                else
                {
                    strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Order = {0} WHERE F_MatchID = {1} AND F_RegisterID = {2}", iBatOrder, iMatchID, iPlayerID);

                }
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_adoDataBase.DBConnect);
                cmd.ExecuteNonQuery();

                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

        }

        public void UpdateMemberStartup(int iMatchID, int iTeamPos, string strPlayerID, bool bStartup)
        {
            int iActive = bStartup ? 1 : 0;

            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update BatOrder
                string strSQL;
                strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Startup = {0} WHERE F_MatchID = {1} AND F_RegisterID = {2}", iActive, iMatchID, GVAR.Str2Int(strPlayerID));
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_adoDataBase.DBConnect);
                cmd.ExecuteNonQuery();

                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void ResetTeamMeber(int iMatchID, int iTeamPosition, ref DataGridView dgvGrid)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for GetTeamDetailInfo

                SqlCommand cmd = new SqlCommand("Proc_RU_GetTeamMembers", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, iMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@TeamPos", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@TeamPos",
                            DataRowVersion.Current, iTeamPosition);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strActiveLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                SqlDataReader sdr = cmd.ExecuteReader();
                GVAR.g_RUPlugin.FillDataGridView(dgvGrid, sdr);
                dgvGrid.Columns["F_RegisterID"].Visible = false;
                dgvGrid.Columns["F_Active"].Visible = false;
                dgvGrid.Columns["Time"].Visible = false;
                sdr.Close();

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void SetActiveMember(int iMatchID, int iTeampos)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for SetActiveMember

                string strSQL;
                strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Active = NULL WHERE F_MatchID = {0} AND F_CompetitionPosition = {1}", iMatchID, iTeampos);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_adoDataBase.DBConnect);
                cmd.ExecuteNonQuery();


                strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Active =  F_StartUp WHERE F_MatchID = {0} AND F_CompetitionPosition = {1}", iMatchID, iTeampos);
                cmd = new SqlCommand(strSQL, GVAR.g_adoDataBase.DBConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void SetTeamMemberInitTime(int iMatchID, int iTeampos, string strStartTime)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for SetTeamMemberInitTime

                string strSQL;
                strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Comment = '{0}' WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}", strStartTime, iMatchID, iTeampos);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_adoDataBase.DBConnect);
                cmd = new SqlCommand(strSQL, GVAR.g_adoDataBase.DBConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public string GetPlayerStat(int iMatchID, int iMatchSplitID, int iPlayerID, int iTeamPos, string strStatCode)
        {
            string strStatValue = "";
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                #region DM Operation For GetPlayerStatValue
                string strSQL = string.Format(@"SELECT F_StatisticValue FROM TS_Match_Statistic  AS A LEFT JOIN TD_Statistic AS B 
                                                 ON A.F_StatisticID = B.F_StatisticID
                                                 WHERE A.F_MatchID = {0} AND A.F_MatchSplitID = {1} AND A.F_RegisterID = {2} AND A.F_CompetitionPosition = {3} AND B.F_StatisticCode = '{4}'", iMatchID, iMatchSplitID, iPlayerID, iTeamPos, strStatCode);

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_adoDataBase.DBConnect);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        strStatValue = OVRDataBaseUtils.GetFieldValue2String(ref dr, 0);
                    }
                }
                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return strStatValue;
        }

        public void GetMatchUniform(int iMatchID, int iTeamPos, ref int iUniformID)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get TeamUniform
                string strSQL;
                strSQL = string.Format("SELECT F_UniformID FROM TS_Match_Result WHERE F_MatchID = {0} AND F_CompetitionPosition = {1}", iMatchID, iTeamPos);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_adoDataBase.DBConnect);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iUniformID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, 0);
                    }
                }
                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void GetMatchCompetitioinRule(int matchID, ref int ruleID)
        {
            try
            {
                #region DML Command Setup for SetActiveMember

                string strSQL;
                strSQL = string.Format(@"select 
		isnull(F_CompetitionRuleID,1)
	from TS_Match where F_MatchID={0}",matchID);

                ruleID = GVAR.Str2Int(GVAR.g_adoDataBase.ExecuteScalar(strSQL));

                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void SetMatchCompetitioinRule(int matchID,int ruleID)
        {
            try
            {
                #region DML Command Setup for SetActiveMember

                string strSQL;
                strSQL = string.Format(@"update TS_Match set F_CompetitionRuleID={0} where F_MatchID={1}", ruleID,matchID);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);

                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void GetCompetitionRule(ref DataTable dtCompetitionRule)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get TeamUniform

                SqlCommand cmd = new SqlCommand("Proc_RU_CompetitionRule", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dtCompetitionRule.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        #endregion

        #region Update Match Score

        public void UpdateMatchScore(int matchID, int matchSplitID, int scoreFirst, int scoreSecond, int scoreExt, int scoreTotal,int tryNum)
        {
            SqlParameter[] parameters = new SqlParameter[7];
            parameters[0] = new SqlParameter("@MatchID", matchID);
            parameters[1] = new SqlParameter("@ComPos", matchSplitID);;
            parameters[2] = new SqlParameter("@ScoreFirst", scoreFirst);
            parameters[3] = new SqlParameter("@ScoreSecond", scoreSecond);
            parameters[4] = new SqlParameter("@ScoreExt", scoreExt);
            parameters[5] = new SqlParameter("@ScoreTotal", scoreTotal);
            parameters[6] = new SqlParameter("@TryNum", tryNum);
            GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_RU_UpdateMatchScore", parameters);
        }

        #endregion

        #region Update Match Rank

        public void UpdateMatchRank(int mathchID, int rankId, int resultId, int compos)
        {
            string strSQL ;
            strSQL = string.Format("update TS_Match_Result set F_Rank={0},F_ResultID={1} where F_MatchID={2} and F_CompetitionPosition={3}", rankId, resultId, mathchID, compos);
            GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);
        }

        public bool AutoProgressMatch(int nMatchID)
        {
            return OVRDataBaseUtils.AutoProgressMatch(nMatchID, GVAR.g_adoDataBase.DBConnect, GVAR.g_RUPlugin);
        }

        #endregion

        #region Initial Member and Action DataGrid

        public ObservableCollection<MatchMemberAndAction> GetMemberAndAction(int matchID, int compos, int active)
        {
            STableRecordSet tb = new STableRecordSet();
            ObservableCollection<MatchMemberAndAction> memberAndActions = new ObservableCollection<MatchMemberAndAction>();

            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paramCompos = new SqlParameter("@Compos", compos);
                SqlParameter paramActive = new SqlParameter("@Active", active);
                GVAR.g_adoDataBase.ExecuteProc("Proc_RU_GetMemberAndAction", tb, paramMatchID, paramCompos, paramActive);
                int rowCount = tb.GetRecordCount();
                if (rowCount <= 0) return null;

                for (int rowIndex = 0; rowIndex < rowCount; rowIndex++)
                {
                    int number = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "Number"));
                    string name = tb.GetFieldValue(rowIndex, "Name");
                    int registerId = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "RegisterID"));
                    int iTRY = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "Try"));
                    int CG = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "ConversionGoal"));
                    int CM = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "ConversionMiss"));
                    int DG = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "DropGoal"));
                    int DM = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "DropMiss"));
                    int PG = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "PenaltyGoal"));
                    int PM = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "PenaltyMiss"));
                    int YC = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "YellowCard"));
                    int RC = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "RedCard"));
                    int comPos = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "ComPos"));
                    bool onCourt = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "Active"))==0?false:true;

                    MatchMemberAndAction temp = new MatchMemberAndAction { ConversionGoal = CG, ConversionMiss = CM, DropGoal = DG, DropMiss = DM, Name = name, Number = number, RegisterID = registerId, TRY = iTRY, PenaltyGoal = PG, PenaltyMiss = PM, RedCard = RC, YellowCard = YC ,ComPos=comPos,Active=onCourt};

                    memberAndActions.Add(temp);
                }                
            }
            catch (Exception ex)
            {
                Log.WriteLog("RU_Error", ex.Message);
                return null;
            }

            return memberAndActions;
        }

        #endregion

        #region Action Add Update Delete Get

        public void AddMatchAction(MatchAction matchAction)
        {
            SqlParameter[] parameters=new SqlParameter[9];
            parameters[0] = new SqlParameter("@MatchID", matchAction.MatchID);
            parameters[1] = new SqlParameter("@MatchSplitID", matchAction.MatchSplitID);
            parameters[2] = new SqlParameter("@TimeStr", matchAction.MatchTime);
            parameters[3] = new SqlParameter("@ComPos", matchAction.ComPos);
            parameters[4] = new SqlParameter("@RegisterID", matchAction.RegisterID);
            parameters[5] = new SqlParameter("@ScoreHome", matchAction.ScoreHome);
            parameters[6] = new SqlParameter("@ScoreAway", matchAction.ScoreAway);
            parameters[7] = new SqlParameter("@ActionTypeCode", matchAction.ActionTypeCode);
            parameters[8] = new SqlParameter("@ActionTypeID", -1);

            GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_RU_AddMatchAction", parameters);				
        }

        public void UpdateActiveInMember(int matchID, int compos, int registerID, int active)
        {
            string strSQL;
            strSQL = string.Format(@"update TS_Match_Member set F_Active={0} where F_MatchID={1} and F_CompetitionPosition={2} and F_RegisterID={3}", active,matchID,compos,registerID);

            GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);
        }

        public ObservableCollection<MatchAction> GetMatchAction(int matchID)
        {
            STableRecordSet tb = new STableRecordSet();
            ObservableCollection<MatchAction> matchActions = new ObservableCollection<MatchAction>();

            SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
            GVAR.g_adoDataBase.ExecuteProc("Proc_RU_GetMatchAction", tb, paramMatchID);
            int rowCount = tb.GetRecordCount();
            if (rowCount <= 0) return null;

            try
            {
                for (int rowIndex = 0; rowIndex < rowCount; rowIndex++)
                {
                    int actionnumberID = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "ActionNumberID"));
                    int matchSplitID = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "MatchSplitID"));
                    int compos = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "Compos"));
                    int scorehome = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "ScoreHome"));
                    int scoreaway = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "ScoreAway"));
                    int actionID = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "ActionID"));
                    int shirtnumber = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "ShirtNumber"));
                    int registerID = GVAR.Str2Int(tb.GetFieldValue(rowIndex, "RegisterID"));

                    string actionname = tb.GetFieldValue(rowIndex, "ActionName");
                    string actiontime = tb.GetFieldValue(rowIndex, "ActionTime");
                    string name = tb.GetFieldValue(rowIndex, "Name");
                    string noc = tb.GetFieldValue(rowIndex, "Noc");
                    string nocAndShirtNumber_home = tb.GetFieldValue(rowIndex, "NocAndShirtNumber_Home");
                    string nocAndShirtNumber_away = tb.GetFieldValue(rowIndex, "NocAndShirtNumber_Away");

                    MatchAction ma = new MatchAction
                    {
                        ActionNumberID=actionnumberID,
                        MatchID = matchID,
                        MatchSplitID = matchSplitID,
                        Period=matchSplitID,
                        ComPos = compos,
                        ScoreHome = scorehome,
                        ScoreAway = scoreaway,
                        ActionTypeID = actionID,
                        ShirtNumber = shirtnumber,
                        RegisterID = registerID,

                        ActionTypeName = actionname,
                        MatchTime = actiontime,
                        Noc = noc,
                        NocAndShirtNumber_Home = nocAndShirtNumber_home,
                        NocAndShirtNumber_Away = nocAndShirtNumber_away
                    };

                    matchActions.Add(ma);
                }
            }
            catch
            {
                return null;
            }

            return matchActions;
        }

        public MatchAction GetSingleMatchActioin(int matchID, int actionNumberID)
        {
            MatchAction matchAction = new MatchAction();
            STableRecordSet tb = new STableRecordSet();

            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paramActioNumberID = new SqlParameter("@ActionNumberID", actionNumberID);
                GVAR.g_adoDataBase.ExecuteProc("Proc_RU_GetMatchAction", tb, paramMatchID, paramActioNumberID);

                matchAction.ActionTypeID = GVAR.Str2Int(tb.GetFieldValue(0, "ActionID"));
                matchAction.ActionTypeName = tb.GetFieldValue(0, "ActionName");
                matchAction.Period = GVAR.Str2Int(tb.GetFieldValue(0, "MatchSplitID"));
                matchAction.MatchTime = tb.GetFieldValue(0, "ActionTime");
                matchAction.Noc = tb.GetFieldValue(0, "Noc");
                matchAction.ShirtNumber = GVAR.Str2Int(tb.GetFieldValue(0, "ShirtNumber"));
                matchAction.RegisterID = GVAR.Str2Int(tb.GetFieldValue(0, "RegisterID"));
                matchAction.ScoreHome = GVAR.Str2Int(tb.GetFieldValue(0, "ScoreHome"));
                matchAction.ScoreAway = GVAR.Str2Int(tb.GetFieldValue(0, "ScoreAway"));
                matchAction.ComPos = GVAR.Str2Int(tb.GetFieldValue(0, "Compos"));
                matchAction.ActionTypeID = GVAR.Str2Int(tb.GetFieldValue(0, "ActionID"));
            }
   
            catch (Exception ex)
            {
                Log.WriteLog("RU_Error", ex.Message);
                return null;
            }


            return matchAction;
        }

        public void GetAllActionType(ref DataTable dtActionType)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get TeamUniform

                SqlCommand cmd = new SqlCommand("Proc_RU_GetAllActionType", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dtActionType.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void GetAllMatchMember(int matchID,int compos,ref DataTable dtMatchMember)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get TeamUniform

                SqlCommand cmd = new SqlCommand("Proc_RU_GetAllMatchMemberByCompos", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                cmd.Parameters.Add("@Compos", SqlDbType.Int).Value = compos;
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dtMatchMember.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public bool UpdateMatchAction(MatchAction matchAction)
        {
            SqlParameter[] parameters = new SqlParameter[7];
            parameters[0] = new SqlParameter("@ActionNumberID", matchAction.ActionNumberID);
            parameters[1] = new SqlParameter("@Period", matchAction.Period);
            parameters[2] = new SqlParameter("@Time", matchAction.MatchTime);
            parameters[3] = new SqlParameter("@ActionTypeID", matchAction.ActionTypeID);
            parameters[4] = new SqlParameter("@ShirtNumber", matchAction.ShirtNumber);
            parameters[5] = new SqlParameter("@ScoreHome", matchAction.ScoreHome);
            parameters[6] = new SqlParameter("@ScoreAway", matchAction.ScoreAway);

            GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_RU_UpdateMatchAction", parameters);

            return true;
        }

        public bool DeleteMatchAction(int actionNumberID)
        {
            string strSql;
            strSql = String.Format("delete from TS_Match_ActionList where F_ActionNumberID={0}", actionNumberID);

            return GVAR.g_adoDataBase.ExecuteUpdateSQL(strSql);            
        }

        #endregion

        #region Add Officials

        public void ResetAvailableOfficial(int iMatchID, DataGridView dgv)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleOfficial
                SqlCommand cmd = new SqlCommand("Proc_RU_GetAvailableOfficial", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = GVAR.Str2Int(m_strActiveDisciplineID);
                cmdParameter1.Value = iMatchID;
                cmdParameter2.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgv, dr, null, null);

                if (dgv.RowCount >= 0)
                {
                    dgv.Columns["F_RegisterID"].Visible = false;
                    dgv.Columns["F_FunctionID"].Visible = false;
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void ResetMatchOfficial(int iMatchID, DataGridView dgv)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchOfficial
                SqlCommand cmd = new SqlCommand("Proc_RU_GetMatchOfficial", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgv, dr, "Function");

                if (dgv.RowCount >= 0)
                {
                    dgv.Columns["F_RegisterID"].Visible = false;
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void AddMatchOfficial(int iMatchID, int iRegisterID, int iFunctionID)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Add MatchOfficial

                SqlCommand cmd = new SqlCommand("Proc_RU_AddMatchOfficial", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@FunctionID", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = iRegisterID;
                cmdParameter2.Value = iFunctionID;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameterResult.Value;
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void RemoveMatchOfficial(int iMatchID, int iRegisterID)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Remove MatchOfficial

                SqlCommand cmd = new SqlCommand("Proc_RU_RemoveMatchOfficial", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = iRegisterID;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameterResult.Value;
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        //public void InitFunctionCombBox(ref DataGridView dgv, int iColumnIndex, string strFunType)
        //{
        //    if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
        //    {
        //        GVAR.g_adoDataBase.DBConnect.Open();
        //    }

        //    try
        //    {
        //        #region DML Command Setup for Fill Function combo

        //        SqlCommand cmd = new SqlCommand("Proc_RU_GetFunctions", GVAR.g_adoDataBase.DBConnect);
        //        cmd.CommandType = CommandType.StoredProcedure;
        //        SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
        //        SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
        //        SqlParameter cmdParameter2 = new SqlParameter("@CategoryCode", SqlDbType.NVarChar, 20);

        //        cmdParameter0.Value = GVAR.Str2Int(m_strActiveDisciplineID);
        //        cmdParameter1.Value = m_strActiveLanguage;
        //        cmdParameter2.Value = strFunType;

        //        cmd.Parameters.Add(cmdParameter0);
        //        cmd.Parameters.Add(cmdParameter1);
        //        cmd.Parameters.Add(cmdParameter2);
        //        SqlDataReader dr = cmd.ExecuteReader();
        //        #endregion

        //        DataTable table = new DataTable();
        //        table.Columns.Add("F_FunctionLongName", typeof(string));
        //        table.Columns.Add("F_FunctionID", typeof(int));
        //        table.Rows.Add("", "-1");
        //        table.Load(dr);

        //        (dgv.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(table, "F_FunctionLongName", "F_FunctionID");
        //        dr.Close();
        //    }
        //    catch (System.Exception e)
        //    {
        //        DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
        //    }
        //}

        #endregion 

        #region SplitStatus

        public int GetSplitStatusID(int iMatchID, int iMatchSplitID)
        {
            int iStatValue = 10;
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                #region DM Operation For GetPlayerStatValue
                string strSQL = string.Format(@"select case when isnull(F_MatchSplitStatusID,10)<10 then 10 else F_MatchSplitStatusID end AS F_MatchSplitStatus from TS_Match_Split_Info where F_MatchID={0} and F_MatchSplitID={1}", iMatchID, iMatchSplitID);

                iStatValue = GVAR.Str2Int(GVAR.g_adoDataBase.ExecuteScalar(strSQL).ToString());

                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            return iStatValue;
        }
        //

        public void UpdateSplitStatusID(int iMatchID, int iMatchSplitID, int iStatusID)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                #region DM Operation For GetPlayerStatValue
                string strSQL = string.Format(@"update TS_Match_Split_Info set F_MatchSplitStatusID={0} where F_MatchID={1} and F_MatchSplitID={2}", iStatusID, iMatchID, iMatchSplitID);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }


        }

        #endregion

    }
}