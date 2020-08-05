using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using System.Data.SqlClient;
using System.Data;
using System.Windows.Forms;

namespace AutoSports.OVRBKPlugin
{
    public class OVRBKManagerDB
    {
        private string m_strActiveSportID;
        private string m_strActiveDisciplineID;
        private string m_strActiveLanguage;

        public OVRBKManagerDB()
        {
            m_strActiveSportID = "";
            m_strActiveDisciplineID = "";
            m_strActiveLanguage = "";
        }
        public int GetEventID(string strMatchID)
        {
            int iResult = -1;

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DM Operation For Get EventID

                string strFmt = @"
                                  select b.F_EventID from TS_Match as a inner join TS_Phase as b on a.F_PhaseID=b.F_PhaseID 
                                  where a.F_MatchID={0}
                                ";
                string strSQL = String.Format(strFmt, strMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iResult = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, 0);
                    }
                }

                dr.Close();
                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            return iResult;
        }
        public void GetActiveSportInfo()
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            int iSportID = 0;
            int iDisciplineID = 0;
            OVRDataBaseUtils.GetActiveInfo(GVAR.g_sqlConn, out iSportID, out iDisciplineID, out m_strActiveLanguage);

            m_strActiveSportID = string.Format("{0:D}", iSportID);
            m_strActiveDisciplineID = string.Format("{0:D}", iDisciplineID);
        }

        public void UpdateMatchTime(string strMatchID, string strMatchTime)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchTime
                string strSQL;

                if (strMatchTime.Length == 0)
                {
                    strSQL = string.Format("UPDATE TS_Match SET F_SpendTime = 0 WHERE F_MatchID = {0}", strMatchID);
                }
                else
                {
                    strSQL = string.Format("UPDATE TS_Match SET F_SpendTime = {0}  WHERE F_MatchID = {1}", strMatchTime, strMatchID);
                }
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void GetMatchInfo(string strMatchID, ref OVRBKMatchInfo CCurMatch)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for GetMatchInfo

                SqlCommand cmd = new SqlCommand("Proc_BK_GetMatchDescription", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, GVAR.Str2Int(strMatchID));

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strActiveLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader sdr = cmd.ExecuteReader();
                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        CCurMatch.MatchID = strMatchID;
                        string str = sdr[0].ToString();
                        CCurMatch.SportDes = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_SportDes");
                        CCurMatch.PhaseDes = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_MatchDes");
                        CCurMatch.DateDes = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_DateDes");
                        CCurMatch.VenueDes = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_VenueDes");
                        CCurMatch.MatchStatus = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_MatchStatusID");
                        CCurMatch.Period = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_MatchComment1");
                        CCurMatch.MatchTime = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_SpendTime");
                        int iPoolMatch = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_IsPoolMatch");
                        CCurMatch.bPoolMatch = iPoolMatch == 1 ? true : false;

                        CCurMatch.m_CHomeTeam.TeamID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_HomeID");
                        CCurMatch.m_CHomeTeam.TeamName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_HomeName");
                        CCurMatch.m_CHomeTeam.TeamPoint = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_HomeScore");
                        CCurMatch.m_CHomeTeam.TeamPosition = 1;


                        CCurMatch.m_CVisitTeam.TeamID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_AwayID");
                        CCurMatch.m_CVisitTeam.TeamName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_AwayName");
                        CCurMatch.m_CVisitTeam.TeamPoint = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_AwayScore");
                        CCurMatch.m_CVisitTeam.TeamPosition = 2;

                        CCurMatch.MatchCode = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_MatchCode");
                        if (CCurMatch.MatchCode == "51")
                        {
                            CCurMatch.MatchType = GVAR.MATCH_PENALTY;
                        }
                        else
                        {
                            CCurMatch.MatchType = GVAR.MATCH_COMMON;
                        }

                        if (CCurMatch.MatchTime.Length == 0)
                        {
                            CCurMatch.InitTime();
                        }
                    }
                }
                sdr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

        }

        public void GetTeamDetailInfo(string strMatchID, ref OVRBKTeamInfo CTeam)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for GetTeamDetailInfo

                SqlCommand cmd = new SqlCommand("Proc_BK_GetTeamDetailInfo", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, GVAR.Str2Int(strMatchID));

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@TeamID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@TeamID",
                            DataRowVersion.Current, GVAR.Str2Int(CTeam.TeamID));

                SqlParameter cmdParameter3 = new SqlParameter(
                           "@TeamPos", SqlDbType.Int, 4,
                           ParameterDirection.Input, false, 0, 0, "@TeamPos",
                           DataRowVersion.Current, CTeam.TeamPosition);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                SqlDataReader sdr = cmd.ExecuteReader();
                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        string strPts = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PtsSet1");
                        CTeam.SetScore(strPts, GVAR.PERIOD_1ST);
                        strPts = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PtsSet2");
                        CTeam.SetScore(strPts, GVAR.PERIOD_2ND);
                        strPts = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PtsSet3");
                        CTeam.SetScore(strPts, GVAR.PERIOD_3RD);
                        strPts = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PtsSet4");
                        CTeam.SetScore(strPts, GVAR.PERIOD_4TH);

                        strPts = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PtsExtra1");
                        CTeam.SetScore(strPts, GVAR.PERIOD_EXTRA1);
                        strPts = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PtsExtra2");
                        CTeam.SetScore(strPts, GVAR.PERIOD_EXTRA2);
                        strPts = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PtsExtra3");
                        CTeam.SetScore(strPts, GVAR.PERIOD_EXTRA3);
                        strPts = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PtsExtra4");
                        CTeam.SetScore(strPts, GVAR.PERIOD_EXTRA4);
                    }
                }
                sdr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public int UpdateTeamSetPt(int iPeriod, ref OVRBKMatchInfo tmpMatch)
        {
            int iResult = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {
                int iSet = iPeriod;
                int iHSetPt = GVAR.Str2Int(tmpMatch.m_CHomeTeam.GetScore(iSet));
                int iVSetPt = GVAR.Str2Int(tmpMatch.m_CVisitTeam.GetScore(iSet));

                #region DML Command Setup for UpdateTeamSetPoint

                SqlCommand cmd = new SqlCommand("Proc_BK_UpdateMatchSetPoint", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, GVAR.Str2Int(tmpMatch.MatchID));

                SqlParameter cmdParameter2 = new SqlParameter(
                              "@SplitOrder", SqlDbType.Int, 4,
                               ParameterDirection.Input, false, 0, 0, "@SplitOrder",
                               DataRowVersion.Current, tmpMatch.Period);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@HTeamPos", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@HTeamPos",
                            DataRowVersion.Current, tmpMatch.m_CHomeTeam.TeamPosition);

                SqlParameter cmdParameter4 = new SqlParameter(
                           "@VTeamPos", SqlDbType.Int, 4,
                           ParameterDirection.Input, false, 0, 0, "@VTeamPos",
                           DataRowVersion.Current, tmpMatch.m_CVisitTeam.TeamPosition);

                SqlParameter cmdParameter5 = new SqlParameter(
                          "@HSetPt", SqlDbType.Int, 4,
                          ParameterDirection.Input, false, 0, 0, "@HSetPt",
                          DataRowVersion.Current, iHSetPt);

                SqlParameter cmdParameter6 = new SqlParameter(
                           "@VSetPt", SqlDbType.Int, 4,
                           ParameterDirection.Input, false, 0, 0, "@VSetPt",
                           DataRowVersion.Current, iVSetPt);

                SqlParameter cmdParameter7 = new SqlParameter(
                          "@HSetResult", SqlDbType.Int, 4,
                          ParameterDirection.Input, false, 0, 0, "@HSetResult",
                          DataRowVersion.Current, tmpMatch.m_CHomeTeam.GetResult(iSet));

                SqlParameter cmdParameter8 = new SqlParameter(
                           "@VSetResult", SqlDbType.Int, 4,
                           ParameterDirection.Input, false, 0, 0, "@VSetResult",
                           DataRowVersion.Current, tmpMatch.m_CVisitTeam.GetResult(iSet));

                SqlParameter cmdParameter9 = new SqlParameter(
                           "@HSetRank", SqlDbType.Int, 4,
                           ParameterDirection.Input, false, 0, 0, "@HSetRank",
                           DataRowVersion.Current, tmpMatch.m_CHomeTeam.GetRank(iSet));

                SqlParameter cmdParameter10 = new SqlParameter(
                           "@VSetRank", SqlDbType.Int, 4,
                           ParameterDirection.Input, false, 0, 0, "@VSetRank",
                           DataRowVersion.Current, tmpMatch.m_CVisitTeam.GetRank(iSet));

                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameter6);
                cmd.Parameters.Add(cmdParameter7);
                cmd.Parameters.Add(cmdParameter8);
                cmd.Parameters.Add(cmdParameter9);
                cmd.Parameters.Add(cmdParameter10);
                cmd.Parameters.Add(cmdParameterResult);

                cmd.ExecuteNonQuery();
                iResult = (int)cmdParameterResult.Value;


                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            return iResult;
        }

        public void UpdateTeamTotPt(ref OVRBKMatchInfo tmpMatch)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DM Operation For UpdateTeamScore

                string strFmt = @"UPDATE TS_Match_Result SET F_Points = {2}
                                WHERE F_MatchID = {0} AND F_CompetitionPosition = {1}";

                string strSQL = String.Format(strFmt, tmpMatch.MatchID, tmpMatch.m_CHomeTeam.TeamPosition, tmpMatch.m_CHomeTeam.TeamPoint);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();

                strSQL = String.Format(strFmt, tmpMatch.MatchID, tmpMatch.m_CVisitTeam.TeamPosition, tmpMatch.m_CVisitTeam.TeamPoint);
                cmd.CommandText = strSQL;
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public Int32 InitMatchSplit(ref OVRBKMatchInfo tmpMatch, int iSetCount)
        {
            int nRetValue = 0;

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DM Operation For CreateMatchSplit
                SqlCommand cmd = new SqlCommand("Proc_BK_CreateMatchSplits_1_Level", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@MatchType", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@Level_1_SplitNum", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@CreateType", SqlDbType.Int); //@CreateType = 1 : Create Delete Old and Create New Splits
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter1.Value = tmpMatch.MatchID;
                cmdParameter2.Value = tmpMatch.MatchType;
                cmdParameter3.Value = iSetCount;
                cmdParameter4.Value = 1;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                cmd.ExecuteNonQuery();
                nRetValue = (int)cmdParameterResult.Value;
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            return nRetValue;
        }

        public bool IsExistMatchSplit(ref OVRBKMatchInfo tmpMatch, int iSplitCode)
        {
            bool bResult = false;

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DM Operation For Check SplitMatch is Exist

                string strFmt = @"SELECT F_MatchSplitID FROM TS_Match_Split_Info
                                WHERE F_MatchID = {0} AND F_MatchSplitCode = '{1}'";

                string strSQL = String.Format(strFmt, tmpMatch.MatchID, iSplitCode);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows)
                {
                    bResult = true;
                }

                dr.Close();
                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            return bResult;
        }
        public int AddSplitMatch(ref OVRBKMatchInfo tmpMatch, string strMatchSplitCode)
        {
            int nRetValue = 0;

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DM Operation For AddMatchSplit
                SqlCommand cmd = new SqlCommand("Proc_BK_AddMatchSplit", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@FatherMatchSplitID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@MatchSplitCode", SqlDbType.NVarChar, 20);
                SqlParameter cmdParameter4 = new SqlParameter("@MatchType", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter1.Value = tmpMatch.MatchID;
                cmdParameter2.Value = 0;
                cmdParameter3.Value = strMatchSplitCode;
                cmdParameter4.Value = 0;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                cmd.ExecuteNonQuery();
                /* -- @Result=0; 	创建MatchSplit失败，标示没有做任何操作！

                -- @Result=1; 	创建MatchSplit成功，返回MatchSplitID！

                -- @Result=-1; 	创建MatchSplit失败， @MatchID无效
                -- @Result=-2; 	创建MatchSplits失败，@FatherMatchSplitID无效
                -- @Result=-3;  创建MatchSplits失败，@MatchSplitOrder无效 */
                nRetValue = (int)cmdParameterResult.Value;
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            return nRetValue;
        }
        public void UpdateMatchSplitStatus(int iMatchID, int iSplitID, int SplitStatusID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DM Operation For UpdateTeamScore

                string strFmt = @"UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID ={2}  WHERE F_MatchID = {0} AND F_MatchSplitID = {1}";

                string strSQL = String.Format(strFmt, iMatchID, iSplitID, SplitStatusID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void UpdateMatchPeriod(ref OVRBKMatchInfo tmpMatch)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Update the Match Innings

                SqlCommand cmd = new SqlCommand("Proc_BK_UpdateMatchPeriod", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, tmpMatch.MatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Period", SqlDbType.NVarChar, 50,
                              ParameterDirection.Input, false, 0, 0, "@Period",
                              DataRowVersion.Current, tmpMatch.Period.ToString());

                SqlParameter cmdParameterResult = new SqlParameter(
                         "@Result", SqlDbType.Int, 0,
                         ParameterDirection.Output, false, 0, 0, "@Result",
                         DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void AddMatchOfficial(int iMatchID, int iRegisterID, int iFunctionID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Add MatchOfficial

                SqlCommand cmd = new SqlCommand("Proc_BK_AddMatchOfficial", GVAR.g_sqlConn);
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
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Remove MatchOfficial

                SqlCommand cmd = new SqlCommand("Proc_BK_RemoveMatchOfficial", GVAR.g_sqlConn);
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

        public void InitFunctionCombBox(ref DataGridView dgv, int iColumnIndex, string strFunType)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Fill Function combo

                SqlCommand cmd = new SqlCommand("Proc_BK_GetFunctions", GVAR.g_sqlConn);
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
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchOfficial Function

                SqlCommand cmd = new SqlCommand("Proc_BK_UpdateMatchOfficialFunction", GVAR.g_sqlConn);
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

        public void ResetAvailableOfficial(int iMatchID, DataGridView dgv)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleOfficial
                SqlCommand cmd = new SqlCommand("Proc_BK_GetAvailableOfficial", GVAR.g_sqlConn);
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
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchOfficial
                SqlCommand cmd = new SqlCommand("Proc_BK_GetMatchOfficial", GVAR.g_sqlConn);
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

        public void InitPositionCombBox(ref DataGridView dgv, int iColumnIndex)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Fill Function combo

                SqlCommand cmd = new SqlCommand("Proc_BK_GetPosition", GVAR.g_sqlConn);
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

        public void InitIRMCombBox(ref DataGridView dgv, int iColumnIndex, int nMatchID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get IRM
                SqlCommand cmd = new SqlCommand("Proc_BK_GetIRMList", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = nMatchID;
                cmdParameter1.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                (dgv.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdateMatchUniform(int iMatchID, int iTeamPos, int iUniformID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Update TeamMatchUniform
                string strSQL;
                strSQL = string.Format("UPDATE TS_Match_Result SET F_UniformID2 = {0} WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}", iUniformID, iMatchID, iTeamPos);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

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
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleTeamMember
                SqlCommand cmd = new SqlCommand("Proc_BK_GetTeamAvailable", GVAR.g_sqlConn);
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
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchMember
                SqlCommand cmd = new SqlCommand("Proc_BK_GetMatchMember", GVAR.g_sqlConn);
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

        public void AddMatchMember(int iMatchID, int iMemberID, int iTeamPos, int iFunctionID, int iPositionID, int iShirtNumber)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Add MatchMember

                SqlCommand cmd = new SqlCommand("Proc_BK_AddMatchMember", GVAR.g_sqlConn);
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
        public void RemoveMatchMember(int iMatchID, int iMemberID, int iTeamPos)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Remove MatchMember

                SqlCommand cmd = new SqlCommand("Proc_BK_RemoveMatchMember", GVAR.g_sqlConn);
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
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchMember Function

                SqlCommand cmd = new SqlCommand("Proc_BK_UpdateMatchMemberFunction", GVAR.g_sqlConn);
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
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchMember Function

                SqlCommand cmd = new SqlCommand("Proc_BK_UpdateMatchMemberPosition", GVAR.g_sqlConn);
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
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
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
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
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
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
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
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void GetMatchUniform(int iMatchID, int iTeamPos, ref int iUniformID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get TeamUniform
                string strSQL;
                strSQL = string.Format("SELECT F_UniformID2 FROM TS_Match_Result WHERE F_MatchID = {0} AND F_CompetitionPosition = {1}", iMatchID, iTeamPos);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

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

        public void GetTeamUniform(int iTeamID, ref DataTable dtUniform)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get TeamUniform

                SqlCommand cmd = new SqlCommand("Proc_BK_GetUniform", GVAR.g_sqlConn);
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

        public void UpdatePlayerOrder(string strMatchID, int iPlayerID, int iBatOrder)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Update BatOrder
                string strSQL;

                if (iBatOrder == 0)
                {
                    strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Order = NULL WHERE F_MatchID = {0} AND F_RegisterID = {1}", strMatchID, iPlayerID);

                }
                else
                {
                    strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Order = {0} WHERE F_MatchID = {1} AND F_RegisterID = {2}", iBatOrder, strMatchID, iPlayerID);

                }
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
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

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Update BatOrder
                string strSQL;
                strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Startup = {0} WHERE F_MatchID = {1} AND F_RegisterID = {2}", iActive, iMatchID, GVAR.Str2Int(strPlayerID));
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();

                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void ResetTeamMeber(string strMatchID, int iTeamPosition, ref DataGridView dgvGrid)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for GetTeamDetailInfo

                SqlCommand cmd = new SqlCommand("Proc_BK_GetTeamMembers", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, GVAR.Str2Int(strMatchID));

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
                OVRDataBaseUtils.FillDataGridView(dgvGrid, sdr, null, null);
                dgvGrid.Columns["F_RegisterID"].Visible = false;
                dgvGrid.Columns["F_Active"].Visible = false;
                sdr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void InitActiveMember(string strMatchID, int iTeampos, string strStartTime)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for InitActiveMember

                string strSQL;
                strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Active =  F_StartUp WHERE F_MatchID = {0} AND F_CompetitionPosition = {1}", GVAR.Str2Int(strMatchID), iTeampos);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();

                strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Comment = '{0}' WHERE F_MatchID = {1} AND F_CompetitionPosition = {2} AND F_Active = 1", strStartTime, GVAR.Str2Int(strMatchID), iTeampos);
                cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void GetActiveMember(OVRBKMatchInfo tmpMatch, int iTeampos, ref OVRBKTeamInfo tmpTeam, ref List<SPlayerInfo> lstActive)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for InitActiveMember

                SqlCommand cmd = new SqlCommand("Proc_BK_GetActiveMember", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter1.Value = GVAR.Str2Int(tmpMatch.MatchID);
                cmdParameter2.Value = iTeampos;
                cmdParameter3.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                SqlDataReader sdr = cmd.ExecuteReader();

                lstActive.Clear();
                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        SPlayerInfo tmpPlayer = new SPlayerInfo();
                        tmpPlayer.Init();

                        tmpPlayer.iRegisterID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_RegisterID");
                        tmpPlayer.iShirtNumber = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_ShirtNumber");
                        tmpPlayer.strRegisterName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_RegisterName");
                        string strTime = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_Comment");
                        if (strTime.Length == 0)
                        {
                            tmpPlayer.iStartTime = GVAR.Str2Int(tmpMatch.MatchTime);
                        }
                        else
                        {
                            tmpPlayer.iStartTime = GVAR.Str2Int(strTime);
                        }

                        lstActive.Add(tmpPlayer);
                    }
                }
                sdr.Close();

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public string GetPlayerStat(string strMatchID, int iMatchSplitID, int iPlayerID, int iTeamPos, string strStatCode)
        {
            string strStatValue = "";
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {
                #region DM Operation For GetPlayerStatValue
                string strSQL = string.Format(@"SELECT F_StatisticValue FROM TS_Match_Statistic  AS A LEFT JOIN TD_Statistic AS B 
                                                 ON A.F_StatisticID = B.F_StatisticID
                                                 WHERE A.F_MatchID = {0} AND A.F_MatchSplitID = {1} AND A.F_RegisterID = {2} AND A.F_CompetitionPosition = {3} AND B.F_StatisticCode = '{4}'", strMatchID, iMatchSplitID, iPlayerID, iTeamPos, strStatCode);

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
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

        public int GetMaxValidSplitCode(int iMatchID)
        {
            int iSplitCode = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {
                #region DML Command Setup for Get LatestSplit

                string strSQL;
                strSQL = string.Format(@"select  MAX(CONVERT(INT,F_MatchSplitCode)) FROM TS_Match_Split_Info WHERE F_MatchID ={0} AND F_MatchSplitStatusID IS NOT NULL", iMatchID);

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                object obj = cmd.ExecuteScalar();
                if (obj != null)
                {
                    if (obj.ToString().Length != 0)
                    {
                        iSplitCode = (int)obj;
                    }
                }
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return iSplitCode;
        }
        public int GetSplitCount(int iMatchID)
        {
            int iSplitCount = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {
                #region DML Command Setup for Get LatestSplit

                string strSQL;
                strSQL = string.Format(@"select COUNT(*) FROM TS_Match_Split_Info WHERE F_MatchID ={0}", iMatchID);

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                object obj = cmd.ExecuteScalar();
                if (obj != null)
                {
                    iSplitCount = (int)obj;
                }
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return iSplitCount;
        }
        public int GetValideSplitCount(int iMatchID)
        {
            int iSplitCount = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {
                #region DML Command Setup for Get LatestSplit

                string strSQL;
                strSQL = string.Format(@"select COUNT(*) FROM TS_Match_Split_Info WHERE F_MatchID ={0} AND F_MatchSplitStatusID IS NOT NULL", iMatchID);

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                object obj = cmd.ExecuteScalar();
                if (obj != null)
                {
                    iSplitCount = (int)obj;
                }
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return iSplitCount;
        }

        public int GetSplitStatusID(int iMatchID, int iSplitID)
        {
            int iSplitStatusID = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {
                #region DML Command Setup for Get LatestSplit

                string strSQL;
                strSQL = string.Format(@"select F_MatchSplitStatusID FROM TS_Match_Split_Info WHERE F_MatchID ={0} AND F_MatchSplitID ={1}", iMatchID, iSplitID);

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iSplitStatusID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MatchSplitStatusID");
                    }
                }
                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return iSplitStatusID;
        }

        public int GetMatchSplitID(int iMatchID, int iMatchSplitCode)
        {
            int iSplitID = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchSplitID

                string strSQL;

                strSQL = string.Format(@"SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = {0} AND F_MatchSplitCode = '{1}' ", iMatchID, iMatchSplitCode.ToString());

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iSplitID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MatchSplitID");
                    }
                }
                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return iSplitID;
        }

        public string GetPeriodName(int iMatchID, int iMatchSplitID)
        {
            string strPriodName = "";
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchSplitName

                string strSQL;

                strSQL = string.Format(@"SELECT F_MatchSplitLongName FROM TS_Match_Split_Des  
                                          WHERE F_MatchID = {0} AND F_MatchSplitID = {1}  AND F_LanguageCode = '{2}'", iMatchID, iMatchSplitID, m_strActiveLanguage);

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        strPriodName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_MatchSplitLongName");
                    }
                }
                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return strPriodName;
        }
        public string GetPeriodName(int iMatchID, string strMatchSplitCode)
        {
            string strPriodName = "";
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchSplitName

                string strSQL;

                strSQL = string.Format(@"SELECT F_MatchSplitLongName FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Des AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID 
                                          WHERE A.F_MatchID = {0} AND A.F_MatchSplitCode = '{1}'  AND B.F_LanguageCode = '{2}'", iMatchID, strMatchSplitCode, m_strActiveLanguage);

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        strPriodName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_MatchSplitLongName");
                    }
                }
                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return strPriodName;
        }

        public int GetSplitScore(string strMatchID, int iMatchSplitID, int iTeamPos)
        {
            int iSplitScore = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Fill Function combo

                string strSQL = string.Format(@"SELECT F_Points FROM TS_Match_Split_Result WHERE F_MatchID = {0} AND F_MatchSplitID = {1} AND F_CompetitionPosition = {2}", strMatchID, iMatchSplitID, iTeamPos);
                #endregion

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iSplitScore = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, 0);
                    }
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return iSplitScore;
        }

        public void UpdateSplitPoint(string strMatchID, int iMatchSplitID, int iTeamPos, int iPoint)
        {

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DM Operation For UpdateTeamScore

                string strFmt = @"UPDATE TS_Match_Split_Result SET F_Points = {2}
                                WHERE F_MatchID = {0} AND F_CompetitionPosition = {1} AND F_MatchSplitID = {3}";

                string strSQL = String.Format(strFmt, strMatchID, iTeamPos, iPoint, iMatchSplitID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public bool ExitsMatchResult(int nMatchID)
        {
            bool bResult = false;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            int iHomeRank = 0;
            int iVisitRank = 0;
            try
            {
                #region DML Command Setup for Get TeamUniform
                string strSQL;
                strSQL = string.Format("SELECT F_ResultID FROM TS_Match_Result WHERE F_MatchID = {0} AND F_CompetitionPosition = 1", nMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iHomeRank = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, 0);
                    }
                }
                dr.Close();

                strSQL = string.Format("SELECT F_ResultID FROM TS_Match_Result WHERE F_MatchID = {0} AND F_CompetitionPosition = 2", nMatchID);
                cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iVisitRank = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, 0);
                    }
                }
                dr.Close();
                #endregion

                if (iHomeRank != 0 && iVisitRank != 0)
                {
                    bResult = true;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return bResult;
        }

        public void GetMatchResult(int iMatchID, ref DataGridView dgv)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchResult
                SqlCommand cmd = new SqlCommand("Proc_BK_GetMatchResult", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgv, dr, "MatchResult", "IRM");

                dgv.Columns["F_CompetitionPosition"].Visible = false;
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void InitMatchResultCombBox(ref DataGridView dgv, int iColumnIndex, int nMatchID, int nPosition)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_BK_GetMatchResultList", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@Position", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = nMatchID;
                cmdParameter1.Value = nPosition;
                cmdParameter2.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                (dgv.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void UpdateMatchResult(int nMatchID, int nPosition, int nResultID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            Int32 nRank;
            String strFmt, strSQL;

            if (nResultID == GVAR.RESULT_TYPE_TIE)
            {
                nRank = GVAR.RANK_TYPE_TIE;
            }
            else
            {
                nRank = nResultID;
            }

            try
            {
                #region DML Command Setup for Update MatchPoint when f_point is null

                strFmt = @"UPDATE TS_Match_Result SET F_Points = 0 
                            WHERE F_MatchID = {0} AND F_CompetitionPosition = {1} AND F_Points IS NULL";

                strSQL = String.Format(strFmt, nMatchID, nPosition);

                SqlCommand cmdPoints = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmdPoints.ExecuteNonQuery();
                #endregion

                #region DML Command Setup for Update MatchResult

                strFmt = @"UPDATE TS_Match_Result SET F_ResultID = (CASE WHEN {0} = -1 THEN NULL ELSE {0} END),
                        F_Rank = (CASE WHEN {1} = -1 THEN NULL ELSE {1} END) WHERE F_MatchID = {2} AND F_CompetitionPosition = {3}";

                strSQL = String.Format(strFmt, nResultID, nRank, nMatchID, nPosition);

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdateMatchIRM(int nMatchID, int nPosition, int nIRMID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            String strFmt, strSQL;

            try
            {
                #region DML Command Setup for Update MatchResult
                strFmt = @"UPDATE TS_Match_Result SET F_IRMID = (CASE WHEN {0} = -1 THEN NULL ELSE {0} END)
                            WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}";

                strSQL = String.Format(strFmt, nIRMID, nMatchID, nPosition);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

        }

        public int GetPhaseID(int iMatchID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            int iPhaseID = 0;
            try
            {
                #region DML Command Setup for GetPhaseID

                string strSQL;
                strSQL = string.Format("SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = {0}", iMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iPhaseID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_PhaseID");
                    }
                }
                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            return iPhaseID;
        }

        public void AutoGroupRank(Int32 iMatchID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for AutoGroupRank
                SqlCommand cmd = new SqlCommand("Proc_BK_CreateGroupResultByMatchID", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);

                cmdParameter1.Value = iMatchID;

                cmd.Parameters.Add(cmdParameter1);
                #endregion

                cmd.ExecuteNonQuery();

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdatePlayerActive(int iMatchID, int iRegisterID, int iActive, string strStartTime)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for InitActiveMember

                string strSQL;
                if (strStartTime.Length == 0)
                {
                    strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Active =  {0}, F_Comment = NULL WHERE F_MatchID = {1} AND F_RegisterID = {2}", iActive, iMatchID, iRegisterID);
                }
                else
                {
                    strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Active =  {0}, F_Comment = {1} WHERE F_MatchID = {2} AND F_RegisterID = {3}", iActive, strStartTime, iMatchID, iRegisterID);
                }
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public int CheckMatchStat(Int32 iMatchID)
        {
            int nRetValue = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Add Out Info

                SqlCommand cmd = new SqlCommand("Proc_BK_CheckMatchStat", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                //SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                //cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                //cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                #endregion

                cmd.ExecuteNonQuery();
                //nRetValue = (int)cmdParameterResult.Value;
                nRetValue = 1;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return nRetValue;
        }

        public int AddMatchAction(OVRBKActionInfo tmpAction)
        {
            int nRetValue = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Add Out Info

                SqlCommand cmd = new SqlCommand("Proc_BK_AddMatchAction", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MatchSplitID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@ActionCode", SqlDbType.NVarChar, 20);
                SqlParameter cmdParameter5 = new SqlParameter("@ActionTime", SqlDbType.DateTime);
                SqlParameter cmdParameter6 = new SqlParameter("@ActionType", SqlDbType.Int);
                SqlParameter cmdParameter7 = new SqlParameter("@ActionDes", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter8 = new SqlParameter("@ActionID", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = tmpAction.MatchID;
                cmdParameter1.Value = tmpAction.MatchSplitID;
                cmdParameter2.Value = tmpAction.TeamPos;
                cmdParameter3.Value = tmpAction.RegisterID;
                cmdParameter4.Value = tmpAction.ActionCode;
                if (tmpAction.ActionTime.Length == 0)
                {
                    cmdParameter5.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter5.Value = tmpAction.ActionTime;
                }
                cmdParameter6.Value = tmpAction.ActionType;
                cmdParameter7.Value = tmpAction.ActionDes;
                cmdParameter8.Value = tmpAction.AcitonID;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameter6);
                cmd.Parameters.Add(cmdParameter7);
                cmd.Parameters.Add(cmdParameter8);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                #endregion

                cmd.ExecuteNonQuery();
                nRetValue = (int)cmdParameterResult.Value;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return nRetValue;
        }

        public int DeleteMatchAction(OVRBKActionInfo tmpAction)
        {
            int nRetValue = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Delete Action


                SqlCommand cmd = new SqlCommand("proc_BK_DeleteAction", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@ActionID", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = GVAR.Str2Int(tmpAction.AcitonID);
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameterResult);

                cmd.ExecuteNonQuery();
                nRetValue = (int)cmdParameterResult.Value;
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return nRetValue;
        }

        public void GetMatchActionList(int nMatchID, int nMatchSplitID, ref List<OVRBKActionInfo> lstAction)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchActionList

                SqlCommand cmd = new SqlCommand("Proc_BK_GetMatchActionList", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MatchSplitID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = nMatchID;
                cmdParameter1.Value = nMatchSplitID;
                cmdParameter2.Value = m_strActiveLanguage;
 
                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);

                SqlDataReader dr = cmd.ExecuteReader();

                lstAction.Clear();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        OVRBKActionInfo tmpAction = new OVRBKActionInfo();
                        tmpAction.AcitonID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ActionNumberID");
                        tmpAction.MatchID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MatchID");
                        tmpAction.MatchSplitID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MatchSplitID");
                        tmpAction.TeamPos = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_CompetitionPosition");
                        tmpAction.RegisterID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_RegisterID");
                        tmpAction.ShirtNo = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ShirtNumber");
                        tmpAction.PlayerName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_LongName");
                        tmpAction.ActionTime = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionHappenTime");

                        tmpAction.ActionType = (EActionType)OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ActionCode");
                        tmpAction.ActionDes = OVRDataBaseUtils.GetFieldValue2String(ref dr, "ActionDes");
                        tmpAction.GetActionCode();
                        lstAction.Add(tmpAction);
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

        public void UpdateMember(int iMatchID, int iTeamPos, int iShirtBib, string strStartingLineup, string strPlayingStatus)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Update BatOrder
                string strSQL;
                strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Startup = {0}, F_Active = {1} 
                WHERE F_MatchID = {2} AND F_CompetitionPosition = {3} AND F_ShirtNumber = {4}", 
                int.Parse(strStartingLineup), int.Parse(strPlayingStatus), iMatchID, iTeamPos, iShirtBib);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();

                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public bool CheckMatchStated(int iMatchID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            SqlCommand cmd = null;
            cmd = new SqlCommand("Proc_BK_CheckMatchStat", GVAR.g_sqlConn);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter = null;
            cmdParameter = new SqlParameter(
                         "@MatchID", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@MatchID",
                         DataRowVersion.Current, iMatchID);
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

        public int DeleteAllMatchAction(Int32 iMatchID)
        {
            int nRetValue = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Add Out Info

                SqlCommand cmd = new SqlCommand("Proc_BK_DeleteAllMatchAction", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                //SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                //cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                //cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                #endregion

                cmd.ExecuteNonQuery();
                //nRetValue = (int)cmdParameterResult.Value;
                nRetValue = 1;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return nRetValue;
        }

    }
}
