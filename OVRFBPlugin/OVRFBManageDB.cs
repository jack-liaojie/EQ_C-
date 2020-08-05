using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using System.Data.SqlClient;
using System.Data;
using System.Windows.Forms;

namespace AutoSports.OVRFBPlugin
{
    public class OVRFBManagerDB
    {
        private string m_strActiveSportID;
        private string m_strActiveDisciplineID;
        public string m_strActiveLanguage;

        public OVRFBManagerDB()
        {
            m_strActiveSportID = "";
            m_strActiveDisciplineID = "";
            m_strActiveLanguage = "";
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

        public void UpdateMatchTime(int iMatchID, string strMatchTime)
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
                    strSQL = string.Format("UPDATE TS_Match SET F_SpendTime = 0 WHERE F_MatchID = {0}", iMatchID);
                }
                else
                {
                    strSQL = string.Format("UPDATE TS_Match SET F_SpendTime = {0}  WHERE F_MatchID = {1}", strMatchTime, iMatchID);
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
        public void GetMatchInfo(int iMatchID, ref OVRFBMatchInfo CCurMatch)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for GetMatchInfo

                SqlCommand cmd = new SqlCommand("Proc_FB_GetMatchDescription", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, iMatchID);

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
                        CCurMatch.MatchID = iMatchID.ToString();
                        string str = sdr[0].ToString();
                        CCurMatch.SportDes = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_EventDes");
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

                        if (CCurMatch.MatchTime.Length == 0 || CCurMatch.MatchStatus <= GVAR.STATUS_ON_COURT)
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

        public void GetTeamDetailInfo(int iMatchID, ref OVRFBTeamInfo CTeam)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for GetTeamDetailInfo

                SqlCommand cmd = new SqlCommand("Proc_FB_GetTeamDetailInfo", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, iMatchID);

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
                        CTeam.SetScore(strPts, GVAR.PERIOD_1stHalf);

                        strPts = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PtsSet2");
                        CTeam.SetScore(strPts, GVAR.PERIOD_2ndHalf);

                        strPts = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PtsExtra1");
                        CTeam.SetScore(strPts, GVAR.PERIOD_1stExtraHalf);

                        strPts = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PtsExtra2");
                        CTeam.SetScore(strPts, GVAR.PERIOD_2ndExtraHalf);

                        strPts = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PtsPSO");
                        CTeam.SetScore(strPts, GVAR.PERIOD_PenaltyShoot);
                    }
                }
                sdr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public int GetCurActiveGKID(OVRFBMatchInfo tmpMatch, int iTeamPos)
        {
            int iResult = -1;

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DM Operation For Check SplitMatch is Exist

                string strFmt = @"SELECT F_RegisterID FROM TS_Match_Member AS A LEFT JOIN TD_Position AS B 
                                 ON A.F_PositionID = B.F_PositionID
                                WHERE F_MatchID = {0} AND B.F_Positioncode = '{1}' AND A.F_Active = 1 AND A.F_CompetitionPosition = {2}";

                string strSQL = String.Format(strFmt, tmpMatch.MatchID, "GK", iTeamPos);
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

        public int GetEventID(int iMatchID)
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
                string strSQL = String.Format(strFmt, iMatchID);
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

        public int UpdateTeamSetPt(ref OVRFBMatchInfo tmpMatch, int iPeriod)
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

                SqlCommand cmd = new SqlCommand("Proc_FB_UpdateMatchSetPoint", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, GVAR.Str2Int(tmpMatch.MatchID));

                SqlParameter cmdParameter2 = new SqlParameter(
                              "@SplitOrder", SqlDbType.Int, 4,
                               ParameterDirection.Input, false, 0, 0, "@SplitOrder",
                               DataRowVersion.Current, iPeriod);

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

        public void UpdateTeamTotPt(ref OVRFBMatchInfo tmpMatch)
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

        public Int32 InitMatchSplit(ref OVRFBMatchInfo tmpMatch, int iSetCount)
        {
            int nRetValue = 0;

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DM Operation For CreateMatchSplit
                SqlCommand cmd = new SqlCommand("Proc_FB_CreateMatchSplits_1_Level", GVAR.g_sqlConn);
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

        public bool IsExistMatchSplit(ref OVRFBMatchInfo tmpMatch, int iSplitCode)
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
        
        public int AddSplitMatch(ref OVRFBMatchInfo tmpMatch, string strMatchSplitCode)
        {
            int nRetValue = 0;

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DM Operation For AddMatchSplit
                SqlCommand cmd = new SqlCommand("proc_FB_AddMatchSplit", GVAR.g_sqlConn);
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

        public void UpdateMatchPeriod(ref OVRFBMatchInfo tmpMatch)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Update the Match Innings

                SqlCommand cmd = new SqlCommand("Proc_FB_UpdateMatchPeriod", GVAR.g_sqlConn);
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

                SqlCommand cmd = new SqlCommand("Proc_FB_AddMatchOfficial", GVAR.g_sqlConn);
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

                SqlCommand cmd = new SqlCommand("Proc_FB_RemoveMatchOfficial", GVAR.g_sqlConn);
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

                SqlCommand cmd = new SqlCommand("Proc_FB_GetFunctions", GVAR.g_sqlConn);
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

                SqlCommand cmd = new SqlCommand("Proc_FB_UpdateMatchOfficialFunction", GVAR.g_sqlConn);
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
                SqlCommand cmd = new SqlCommand("Proc_FB_GetAvailableOfficial", GVAR.g_sqlConn);
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
                SqlCommand cmd = new SqlCommand("Proc_FB_GetMatchOfficial", GVAR.g_sqlConn);
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

                SqlCommand cmd = new SqlCommand("Proc_FB_GetPosition", GVAR.g_sqlConn);
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
                SqlCommand cmd = new SqlCommand("Proc_FB_GetIRMList", GVAR.g_sqlConn);
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
        public void UpdateMatchPeriodsSet(int iMatchID, int iPeriodID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Update TeamMatchUniform
                string strSQL;
                strSQL = string.Format("UPDATE TS_Match SET F_MatchComment5 = {0} WHERE F_MatchID = {1} ", iPeriodID, iMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }


        public void UpdateMatchAttendance(int iMatchID, string strAttendance)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Update TeamMatchUniform
                string strSQL;
                strSQL = string.Format("UPDATE TS_Match SET F_MatchComment2 = {0} WHERE F_MatchID = {1} ", strAttendance, iMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdateMatchGKUniform(int iMatchID, int iTeamPos, int iUniformID)
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
                strSQL = string.Format("UPDATE TS_Match_Result SET F_UniformID = {0} WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}", iUniformID, iMatchID, iTeamPos);
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
                SqlCommand cmd = new SqlCommand("Proc_FB_GetTeamAvailable", GVAR.g_sqlConn);
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

                    //for (int i = 0; i < dgv.RowCount; i++)
                    //{
                    //    int iDSQ = GVAR.Str2Int(dgv.Rows[i].Cells["Status"].Value);
                    //    if (iDSQ == 1)
                    //    {
                    //        dgv.Rows[i].ReadOnly = true;
                    //        dgv.Rows[i].DefaultCellStyle.BackColor = System.Drawing.Color.DarkGray;
                    //    }
                    //}
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
                SqlCommand cmd = new SqlCommand("Proc_FB_GetMatchMember", GVAR.g_sqlConn);
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
                    dgv.Columns["F_IRMID"].Visible = false;
                    dgv.Columns["Order"].ReadOnly = false;
                    dgv.Columns["Order"].Visible = false;
                    dgv.Columns["ShirtNumber"].ReadOnly = false;
                    dgv.Columns["Status"].ReadOnly = false;

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
        public void AddMatchMember(int iMatchID, int iMemberID, int iTeamPos, int iFunctionID,int iPositionID, int iShirtNumber)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Add MatchMember

                SqlCommand cmd = new SqlCommand("Proc_FB_AddMatchMember", GVAR.g_sqlConn);
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
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Remove MatchMember

                SqlCommand cmd = new SqlCommand("Proc_FB_RemoveMatchMember", GVAR.g_sqlConn);
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

                SqlCommand cmd = new SqlCommand("Proc_FB_UpdateMatchMemberFunction", GVAR.g_sqlConn);
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

                SqlCommand cmd = new SqlCommand("Proc_FB_UpdateMatchMemberPosition", GVAR.g_sqlConn);
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

        public void UpdateMemberStatus(int imatchID, int CompetitionPos, int iRegisterID, int iIRMID)
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
                    strSQL = String.Format("UPDATE TS_Match_Member SET F_IRMID = NULL WHERE F_MatchID = {0} AND F_CompetitionPosition = {1} AND F_RegisterID = {2}", imatchID, CompetitionPos, iRegisterID);
                }
                else
                {
                    strSQL = String.Format("UPDATE TS_Match_Member SET F_IRMID = {3} WHERE F_MatchID={0} AND F_CompetitionPosition = {1} AND F_RegisterID = {2}", imatchID, CompetitionPos, iRegisterID, iIRMID);
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
        public void GetMatchPeriodSetting(int iMatchID, ref int iPeriodID)
        {
           
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get TeamUniform
                string strSQL;
                strSQL = string.Format("select F_MatchComment5 from Ts_match WHERE F_MatchID = {0}", iMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                iPeriodID = 0;
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iPeriodID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, 0);
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
                strSQL = string.Format("SELECT F_UniformID FROM TS_Match_Result WHERE F_MatchID = {0} AND F_CompetitionPosition = {1}", iMatchID, iTeamPos);
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
        public void GetMatchGKUniform(int iMatchID, int iTeamPos, ref int iUniformID)
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
        public void GetGKUniform(ref DataTable dtUniform)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get TeamUniform

                SqlCommand cmd = new SqlCommand("Proc_FB_GetGKUniform", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter1.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter1);
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
        public void GetTeamUniform(int iTeamID, ref DataTable dtUniform)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get TeamUniform

                SqlCommand cmd = new SqlCommand("Proc_FB_GetUniform", GVAR.g_sqlConn);
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
                    strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Order = NULL WHERE F_MatchID = {0} AND F_RegisterID = {1}", iMatchID, iPlayerID);

                }
                else
                {
                    strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Order = {0} WHERE F_MatchID = {1} AND F_RegisterID = {2}", iBatOrder, iMatchID, iPlayerID);

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

        public void ResetTeamMeber(int iMatchID, int iTeamPosition, ref DataGridView dgvGrid)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for GetTeamDetailInfo

                SqlCommand cmd = new SqlCommand("Proc_FB_GetTeamMembers", GVAR.g_sqlConn);
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
                GVAR.g_FBPlugin.m_frmFBPlugin.FillDataGridView(dgvGrid, sdr);
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
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for SetActiveMember

                string strSQL;
                strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Active = NULL WHERE F_MatchID = {0} AND F_CompetitionPosition = {1}", iMatchID, iTeampos);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();


                strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Active =  F_StartUp WHERE F_MatchID = {0} AND F_CompetitionPosition = {1}", iMatchID, iTeampos);
                cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
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
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for SetTeamMemberInitTime

                string strSQL;
                strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Comment = '{0}' WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}", strStartTime, iMatchID, iTeampos);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
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
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {
                #region DM Operation For GetPlayerStatValue
                string strSQL = string.Format(@"SELECT F_StatisticValue FROM TS_Match_Statistic  AS A LEFT JOIN TD_Statistic AS B 
                                                 ON A.F_StatisticID = B.F_StatisticID
                                                 WHERE A.F_MatchID = {0} AND A.F_MatchSplitID = {1} AND A.F_RegisterID = {2} AND A.F_CompetitionPosition = {3} AND B.F_StatisticCode = '{4}'", iMatchID, iMatchSplitID, iPlayerID, iTeamPos, strStatCode);

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
        public int GetTeamMemberCount(int iMatchID, int iTeamPos)
        {
            int iInCount = 11;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {
                string strSQL;
                strSQL = string.Format(@"SELECT  F_Service FROM TS_Match_Result WHERE F_MatchID = {0} AND F_CompetitionPosition = {1}", iMatchID, iTeamPos);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iInCount = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_Service");
                        if (iInCount == 0)
                            iInCount = 11;
                    }
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return iInCount;
        }

        public void SetTeamMemberCount(int iMatchID, int iTeamPos,int iInCount)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {
                string strSQL;
                strSQL = string.Format(@"UPDATE  TS_Match_Result SET F_Service = {2} WHERE F_MatchID = {0} AND F_CompetitionPosition = {1}", iMatchID, iTeamPos, iInCount);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public string GetAddTime(int iMatchID, int iMatchSplitID)
        {
            string strTime = "0";
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {
                string strSQL;
                strSQL = string.Format(@"select F_Memo from TS_Match_Split_Info WHERE F_MatchID ={0} AND F_MatchSplitID ={1}", iMatchID, iMatchSplitID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        strTime = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Memo");
                    }
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return strTime;
        }
        public void UpdateAddTime(int iMatchID, int iMatchSplitID, String strTime)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {
                string strSQL;
                strSQL = string.Format(@"Update TS_Match_Split_Info SET F_Memo = {2} WHERE F_MatchID ={0} AND F_MatchSplitID ={1}", iMatchID, iMatchSplitID, strTime);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void UpdatePlayerStat(int iMatchID, int iMatchSplitID, int iPlayerID, int iTeamPos, string strStatCode, string strStatValue)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DM Operation For UpdatePlayerStat

                SqlCommand cmd = new SqlCommand("Proc_FB_UpdatePlayerStat", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                    "@MatchID", SqlDbType.Int, 4,
                    ParameterDirection.Input, false, 0, 0, "@MatchID",
                    DataRowVersion.Current, iMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                    "@MatchSplitID", SqlDbType.Int, 4,
                    ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                    DataRowVersion.Current, iMatchSplitID);

                SqlParameter cmdParameter3 = new SqlParameter(
                    "@RegisterID", SqlDbType.Int, 4,
                    ParameterDirection.Input, false, 0, 0, "@RegisterID",
                    DataRowVersion.Current, iPlayerID);

                SqlParameter cmdParameter4 = new SqlParameter(
                    "@TeamPos", SqlDbType.Int, 4,
                    ParameterDirection.Input, false, 0, 0, "@TeamPos",
                    DataRowVersion.Current, iTeamPos);

                SqlParameter cmdParameter5 = new SqlParameter(
                    "@StatCode", SqlDbType.NVarChar, 20,
                    ParameterDirection.Input, false, 0, 0, "@StatCode",
                    DataRowVersion.Current, strStatCode);

                SqlParameter cmdParameter6 = new SqlParameter(
                    "@StatValue", SqlDbType.NVarChar, 50,
                    ParameterDirection.Input, false, 0, 0, "@StatValue",
                    DataRowVersion.Current, strStatValue);

                SqlParameter cmdParameterResult = new SqlParameter(
                         "@Result", SqlDbType.Int, 0,
                         ParameterDirection.Output, false, 0, 0, "@Result",
                         DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameter6);
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

        public bool ISAllSplitsEnd(int iMatchID)
        {
            bool bEnd = false;
            int iCount = 1;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {
                #region DML Command Setup for Get LatestSplit

                string strSQL;
                strSQL = string.Format(@"select count(1) AS IsNotFinishCount  FROM TS_Match_Split_Info WHERE F_MatchID ={0} AND (F_MatchSplitStatusID <> {1} OR F_MatchSplitStatusID IS NULL ) ", iMatchID, GVAR.STATUS_FINISHED);

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iCount = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "IsNotFinishCount");
                        if (iCount == 0)
                        {
                            bEnd = true;
                        }
                    }
                }
                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return bEnd;
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
                    if (obj.ToString().Length !=0)
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
        public int GetMatchSplitID(int iMatchID, int iMatchSplit)
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

                strSQL = string.Format(@"SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = {0} AND F_MatchSplitCode = '{1}' ", iMatchID, iMatchSplit.ToString());

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

        public string GetMatchAttendance(int iMatchID)
        {

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get TeamUniform
                string strSQL;
                strSQL = string.Format("select F_MatchComment2 from Ts_match WHERE F_MatchID = {0}", iMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                object obj = cmd.ExecuteScalar();
                if (obj !=null)
                {
                   return obj.ToString();
                }
                else
                {
                    return "";
                }
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return "";
        }
        public int GetMatchPeriod(int iMatchID, int iMatchSplitID)
        {
            int iSplitCode = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchSplitID

                string strSQL;

                strSQL = string.Format(@"SELECT F_MatchSplitCode FROM TS_Match_Split_Info WHERE F_MatchID = {0} AND F_MatchSplitID = '{1}' ", iMatchID, iMatchSplitID);

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iSplitCode = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MatchSplitCode");
                    }
                }
                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return iSplitCode;
        }
        public void UpdatePlayerPlayTime(int iMatchID, int iTeamPos, int iRegisterID, string strPlayTimeStatCode)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DM Operation For UpdatePlayerStat

                SqlCommand cmd = new SqlCommand("Proc_FB_UpdatePlayerPlayTime", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                    "@MatchID", SqlDbType.Int, 4,
                    ParameterDirection.Input, false, 0, 0, "@MatchID",
                    DataRowVersion.Current, iMatchID);
                SqlParameter cmdParameter2 = new SqlParameter(
                  "@TeamPos", SqlDbType.Int, 4,
                  ParameterDirection.Input, false, 0, 0, "@TeamPos",
                  DataRowVersion.Current, iTeamPos);

                SqlParameter cmdParameter3 = new SqlParameter(
                    "@RegisterID", SqlDbType.Int, 4,
                    ParameterDirection.Input, false, 0, 0, "@RegisterID",
                    DataRowVersion.Current, iRegisterID);

                SqlParameter cmdParameter4 = new SqlParameter(
                    "@TimeCode", SqlDbType.NVarChar, 20,
                    ParameterDirection.Input, false, 0, 0, "@TimeCode",
                    DataRowVersion.Current, strPlayTimeStatCode);

                SqlParameter cmdParameterResult = new SqlParameter(
                         "@Result", SqlDbType.Int, 0,
                         ParameterDirection.Output, false, 0, 0, "@Result",
                         DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
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

        public string GetCardCode(int iActionID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {

                string strSQL;
                strSQL = string.Format(@"SELECT ISNULL(F_ScoreDes,'') FROM TS_Match_ActionList WHERE F_ActionNumberID = {0}", iActionID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                return (string)cmd.ExecuteScalar();
            }
            catch (System.Exception e)
            {
                
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return "";
            }
        }

        public int GetMissMatchState(int iActionID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {

                string strSQL;
                strSQL = string.Format(@"SELECT ISNULL(F_ActionDetail6,0) FROM TS_Match_ActionList WHERE F_ActionNumberID = {0}", iActionID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                return (int)cmd.ExecuteScalar();
            }
            catch (System.Exception e)
            {

                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return 0;
            }
        }
         public void UpdateCardCode(int iActionID, string strCode)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {

                string strSQL;
                if (strCode == "")
                {
                    strSQL = string.Format(@"Update TS_Match_ActionList SET F_ScoreDes =NULL WHERE F_ActionNumberID = {0}", iActionID);
                } 
                else
                {
                    strSQL = string.Format(@"Update TS_Match_ActionList SET F_ScoreDes ='{0}' WHERE F_ActionNumberID = {1}", strCode, iActionID);
                }
                
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

         public void UpdateMissMatchState(int iActionID, int iState)
         {
             if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
             {
                 GVAR.g_sqlConn.Open();
             }
             try
             {

                 string strSQL;
                 if (iState == 0)
                 {
                     strSQL = string.Format(@"Update TS_Match_ActionList SET F_ActionDetail6 =NULL WHERE F_ActionNumberID = {0}", iActionID);
                 }
                 else
                 {
                     strSQL = string.Format(@"Update TS_Match_ActionList SET F_ActionDetail6 ={0} WHERE F_ActionNumberID = {1}", iState, iActionID);
                 }

                 SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                 cmd.ExecuteNonQuery();
             }
             catch (System.Exception e)
             {
                 DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
             }
         }
        public void UpdateActionTime(int iActionID, string strActionTime)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {

                string strSQL;
                string strTime = DateTime.Now.ToString("yyyy-MM-dd ") + strActionTime;
                strSQL = string.Format(@"Update TS_Match_ActionList SET F_ActionHappenTime = CONVERT(Datetime ,'{0}',120) WHERE F_ActionNumberID = {1}", strTime, iActionID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public int AddMatchAction(OVRFBActionInfo tmpAction)
        {
            int nRetValue = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Add Out Info

                SqlCommand cmd = new SqlCommand("Proc_FB_AddMatchAction", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MatchSplitID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@ActionCode", SqlDbType.NVarChar, 20);
                SqlParameter cmdParameter5 = new SqlParameter("@ActionHappenTime", SqlDbType.DateTime);
                SqlParameter cmdParameter6 = new SqlParameter("@ActionType", SqlDbType.Int);
                SqlParameter cmdParameter7 = new SqlParameter("@ActionXML", SqlDbType.NVarChar, 9000000);
                SqlParameter cmdParameter8 = new SqlParameter("@ActionKey", SqlDbType.Int);
                SqlParameter cmdParameter9 = new SqlParameter("@ActionDes", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter10 = new SqlParameter("@ActionDetail1", SqlDbType.Int);
                SqlParameter cmdParameter11 = new SqlParameter("@ActionDetail2", SqlDbType.Int);
                SqlParameter cmdParameter12 = new SqlParameter("@ActionDetail3", SqlDbType.Int);
                SqlParameter cmdParameter13 = new SqlParameter("@ActionID", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = tmpAction.MatchID;
                cmdParameter1.Value = tmpAction.MatchSplitID;
                cmdParameter2.Value = tmpAction.RegisterID;
                cmdParameter3.Value = tmpAction.TeamPos;
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
                cmdParameter7.Value = tmpAction.ActionXml;
                cmdParameter8.Value = GVAR.Str2Int(tmpAction.ActionDetail);
                cmdParameter9.Value = tmpAction.ActionDes;
                cmdParameter10.Value = GVAR.Str2Int(tmpAction.ActionDetail1);
                cmdParameter11.Value = GVAR.Str2Int(tmpAction.ActionDetail2);
                cmdParameter12.Value = GVAR.Str2Int(tmpAction.ActionDetail3);
                cmdParameter13.Value = tmpAction.AcitonID;
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
                cmd.Parameters.Add(cmdParameter9);
                cmd.Parameters.Add(cmdParameter10);
                cmd.Parameters.Add(cmdParameter11);
                cmd.Parameters.Add(cmdParameter12);
                cmd.Parameters.Add(cmdParameter13);
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

        public int UpdatePlayerStat(OVRFBActionInfo tmpAction)
        {
            int nRetValue = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Add Out Info

                SqlCommand cmd = new SqlCommand("Proc_FB_UpdateStatByXml", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@ActionXML", SqlDbType.NVarChar, 9000000);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameter1.Value = tmpAction.MatchID;
                cmdParameter3.Value = tmpAction.TeamPos;
                cmdParameter4.Value = tmpAction.ActionXml;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
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

        public void GetMatchActionList(int iMatchID, ref List<OVRFBActionInfo> lstAction)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchActionList


                SqlCommand cmd = new SqlCommand("Proc_FB_GetMatchActionList", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);

                SqlDataReader dr = cmd.ExecuteReader();

                lstAction.Clear();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        OVRFBActionInfo tmpAction = new OVRFBActionInfo();
                        tmpAction.AcitonID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ActionNumberID");
                        tmpAction.MatchID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MatchID");
                        tmpAction.MatchSplitID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MatchSplitID");
                        tmpAction.TeamPos = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_CompetitionPosition");
                        tmpAction.RegisterID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_RegisterID");
                        tmpAction.RegName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_LongName");
                        tmpAction.ShirtNo = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ShirtNumber");
                        tmpAction.ActionTime = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionHappenTime");
                       // if (tmpAction.ActionTime.Length > 0)
                       // {
                            //tmpAction.ActionTime = tmpAction.ActionTime.Substring(3, 5);
                       // }

                        tmpAction.ActionType = (EActionType)OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ActionDetail1");
                        tmpAction.ActionDetail = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionDetail2");
                        tmpAction.ActionDes = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionHappenTimeSpan");
                        tmpAction.ActionXml = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionXmlComment");
                        tmpAction.ActionDetail1 = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionDetail3");
                        tmpAction.ActionDetail2 = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionDetail4");
                        tmpAction.ActionDetail3 = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionDetail5");
                        tmpAction.ActionDetail4 = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ScoreDes");
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

        public void GetMatchAction(int iMatchID, int iActionID, ref OVRFBActionInfo tmpAction)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchActionList

                string strSQL = string.Format(@"SELECT A.F_ActionNumberID,A.F_MatchID,A.F_MatchSplitID,A.F_RegisterID, A.F_CompetitionPosition,
                                                  CAST(A.F_ActionHappenTime AS Time(0)) AS F_ActionHappenTime, A.F_ActionHappenTimeSpan, A.F_ActionDetail1, A.F_ActionDetail2,  
                                                  A.F_ActionDetail3, A.F_ActionDetail4, A.F_ActionDetail5, A.F_ActionXMLComment, A.F_ActionOrder,
                                                  B.F_LongName, C.F_ShirtNumber
                                                FROM TS_Match_ActionList AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = '{0}'
                                                      LEFT JOIN TS_Match_Member AS C ON A.F_RegisterID = C.F_RegisterID AND A.F_MatchID = C.F_MatchID
                                                   WHERE A.F_MatchID = {1} AND A.F_ActionNumberID = {2} ORDER BY A.F_ActionOrder", m_strActiveLanguage, iMatchID, iActionID);

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows)
                {
                    while (dr.Read())
                    {

                        tmpAction.AcitonID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ActionNumberID");
                        tmpAction.MatchID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MatchID");
                        tmpAction.MatchSplitID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MatchSplitID");
                        tmpAction.TeamPos = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_CompetitionPosition");
                        tmpAction.RegisterID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_RegisterID");
                        tmpAction.RegName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_LongName");
                        tmpAction.ShirtNo = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ShirtNumber");
                        tmpAction.ActionTime = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionHappenTime");
                        if (tmpAction.ActionTime.Length > 0)
                        {
                            tmpAction.ActionTime = tmpAction.ActionTime.Substring(3, 5);
                        }

                        tmpAction.ActionType = (EActionType)OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ActionDetail1");
                        tmpAction.ActionDetail = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionDetail2");
                        tmpAction.ActionDes = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionHappenTimeSpan");
                        tmpAction.ActionXml = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionXmlComment");
                        tmpAction.ActionDetail1 = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionDetail3");
                        tmpAction.ActionDetail2 = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionDetail4");
                        tmpAction.ActionDetail3 = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ActionDetail5");

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
        public int DeleteMatchAction(OVRFBActionInfo tmpAction)
        {
            int nRetValue = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Delete Action


                SqlCommand cmd = new SqlCommand("Proc_FB_DeleteAction", GVAR.g_sqlConn);
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

        public int RemovePlayerStat(OVRFBActionInfo tmpAction)
        {
            int nRetValue = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Add Out Info

                SqlCommand cmd = new SqlCommand("Proc_FB_RemoveStatByXml", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@ActionXML", SqlDbType.NVarChar, 9000000);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter1.Value = tmpAction.MatchID;
                cmdParameter2.Value = tmpAction.TeamPos;
                cmdParameter3.Value = tmpAction.ActionXml;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
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

        public void ResetPenaltyAvailableGrid(int iMatchID, int iMatchSplitID, int iTeamPos, ref DataGridView dgv)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleTeamMember
                SqlCommand cmd = new SqlCommand("Proc_FB_GetMatchSplitAvailable", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@MatchSplitID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);

                cmdParameter1.Value = iMatchID;
                cmdParameter4.Value = iMatchSplitID;
                cmdParameter2.Value = m_strActiveLanguage;
                cmdParameter3.Value = iTeamPos;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgv, dr, null, null);

                if (dgv.RowCount >= 0)
                {
                    dgv.Columns["F_MemberID"].Visible = false;
                    dgv.Columns["F_FunctionID"].Visible = false;
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void ResetPenaltyMemberGrid(int iMatchID, int iMatchSplitID, int iTeamPos, ref DataGridView dgv)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchMember
                SqlCommand cmd = new SqlCommand("Proc_FB_GetMatchSplitMember", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@MatchSplitID", SqlDbType.Int);

                cmdParameter1.Value = iMatchID;
                cmdParameter2.Value = m_strActiveLanguage;
                cmdParameter3.Value = iTeamPos;
                cmdParameter4.Value = iMatchSplitID;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();

                int iSelRowIndex = -1;
                if (dgv.Rows.Count > 0 && dgv.SelectedRows.Count != 0)
                {
                    iSelRowIndex = dgv.SelectedRows[0].Index;
                }

                OVRDataBaseUtils.FillDataGridViewWithCmb(dgv, dr, "Position");
                dr.Close();

                if (dgv.RowCount > 0)
                {
                    dgv.Columns["F_MemberID"].Visible = false;
                    dgv.Columns["Order"].ReadOnly = false;

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

        public void GetMatchPeriodTime(int iMatchID,out int Period1,out int Period2,out int Period3,out int Period4)
        {
            Period1 = 45;
            Period2 = 90;
            Period3 = 105;
            Period4 = 120;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Add MatchMember

                SqlCommand cmd = new SqlCommand("Proc_FB_GetEventPeriodTime", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@Period1", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@Period2", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@Period3", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@Period4", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Direction = ParameterDirection.Output;
                cmdParameter2.Direction = ParameterDirection.Output;
                cmdParameter3.Direction = ParameterDirection.Output;
                cmdParameter4.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                cmd.ExecuteNonQuery();
                Period1 = (int)cmdParameter1.Value;
                Period2 = (int)cmdParameter2.Value;
                Period3 = (int)cmdParameter3.Value;
                Period4 = (int)cmdParameter4.Value;
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void AddMatchSplitMember(int iMatchID, int iMatchSplitID, int iMemberID, int iTeamPos, int iFunctionID, int iShirtNumber)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Add MatchMember

                SqlCommand cmd = new SqlCommand("Proc_FB_AddMatchSplitMember", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter5 = new SqlParameter("@MatchSplitID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MemberID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@FunctionID", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@ShirtNumber", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = iMemberID;
                cmdParameter2.Value = iTeamPos;
                cmdParameter3.Value = iFunctionID;
                cmdParameter4.Value = iShirtNumber;
                cmdParameter5.Value = iMatchSplitID;
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

        public void RemoveMatchSplitMember(int iMatchID, int iMatchSplitID, int iMemberID, int iTeamPos)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Remove MatchMember

                SqlCommand cmd = new SqlCommand("Proc_FB_RemoveMatchSplitMember", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@MatchSplitID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MemberID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = iMemberID;
                cmdParameter2.Value = iTeamPos;
                cmdParameter3.Value = iMatchSplitID;
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

        public bool UpdateMatchSplitMemberOrder(int iMatchID, int iMatchSplitID, int iMemberID, int iTeamPos, string strOrder)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                string strSQL;
                if (strOrder.Length == 0)
                {
                    strSQL = String.Format("UPDATE TS_Match_Split_Member SET F_Order = NULL WHERE F_MatchID = {0} AND F_MatchSplitID = {1} AND F_RegisterID = {2} ",  iMatchID, iMatchSplitID, iMemberID);
                }
                else
                {
                    int iOrder = GVAR.Str2Int(strOrder);
                    strSQL = String.Format("UPDATE TS_Match_Split_Member SET F_Order = '{0}' WHERE F_MatchID = {1} AND F_MatchSplitID = {2} AND F_RegisterID = {3} ", strOrder, iMatchID, iMatchSplitID, iMemberID);
                }
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }
        }

        public void UpdateMatchSplitMembePosition(int iMatchID, int iMatchSplitID, int iMemberID, int iTeamPos, int iPositionID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchMember Function

                SqlCommand cmd = new SqlCommand("Proc_FB_UpdateMatchSplitMemberPosition", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@MatchSplitID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MemberID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@PositionID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = iMemberID;
                cmdParameter2.Value = iPositionID;
                cmdParameter3.Value = iTeamPos;
                cmdParameter4.Value = iMatchSplitID;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
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

        public void GetPenaltyGKInfo(int iMatchID, int iTeamPos, int iMatchSplitID, ref string strGKName, ref int iGKID)
        {

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get GKName
                string strSQL;
                strSQL = string.Format(@"SELECT B.F_LongName + CAST (A.F_ShirtNumber AS NVARCHAR(10)), A.F_RegisterID FROM TS_Match_Split_Member AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID  AND B.F_LanguageCode = '{0}'
                                        LEFT JOIN TD_Position AS C ON A.F_PositionID = C.F_PositionID 
                                        WHERE A.F_MatchID = {1} AND A.F_CompetitionPosition = {2}  AND A.F_MatchSplitID = {3}
                                         AND C.F_PositionCode = '{4}'", m_strActiveLanguage, iMatchID, iTeamPos, iMatchSplitID, "GK");
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        strGKName = OVRDataBaseUtils.GetFieldValue2String(ref dr, 0);
                        iGKID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, 1);
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

        public void FillPenaltyDataGridView(ref DataGridView dgv, int iMatchID, int iMatchSplitID, int iTeamPos)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchMember
                SqlCommand cmd = new SqlCommand("Proc_FB_GetPenalytPlayer", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@MatchSplitID", SqlDbType.Int);

                cmdParameter1.Value = iMatchID;
                cmdParameter2.Value = m_strActiveLanguage;
                cmdParameter3.Value = iTeamPos;
                cmdParameter4.Value = iMatchSplitID;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();

                OVRDataBaseUtils.FillDataGridViewWithCmb(dgv, dr, "ResultDes");
                dr.Close();

                if (dgv.RowCount > 0)
                {
                    dgv.Columns["F_RegisterID"].Visible = false;
                    dgv.Columns["F_ActionID"].Visible = false;

                    for (int i = 0; i < dgv.Columns.Count; i++)
                    {
                        dgv.Columns[i].SortMode = DataGridViewColumnSortMode.NotSortable;
                    }
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

        }

        public void InitPenaltyResultCmb(ref DataGridView dgv, int iColumnIndex)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Fill PenaltyResult combo

                string strSQL = "(SELECT 1 AS Result, 'Goal' AS Des) UNION (SELECT 2 AS Result, 'Block' AS Des) UNION (SELECT 3 AS Result, 'Crossbar' AS Des) UNION (SELECT 4 AS Result, 'Missed' AS Des)";
                #endregion

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                SqlDataReader dr = cmd.ExecuteReader();
                DataTable table = new DataTable();
                table.Columns.Add("Des", typeof(string));
                table.Columns.Add("Result", typeof(int));
                table.Load(dr);

                (dgv.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(table, "Des", "Result");
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public int GetSplitScore(int iMatchID, int iMatchSplitID, int iTeamPos)
        {
            int iSplitScore = 0;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Fill Function combo

                string strSQL = string.Format(@"SELECT F_Points FROM TS_Match_Split_Result WHERE F_MatchID = {0} AND F_MatchSplitID = {1} AND F_CompetitionPosition = {2}", iMatchID, iMatchSplitID, iTeamPos);
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

        public void UpdateSplitPoint(int iMatchID, int iMatchSplitID, int iTeamPos, int iPoint)
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

                string strSQL = String.Format(strFmt, iMatchID, iTeamPos, iPoint, iMatchSplitID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
       
        #region Set MatchResult
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
                SqlCommand cmd = new SqlCommand("Proc_FB_GetCurrentMatchResult", GVAR.g_sqlConn);
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
                SqlCommand cmd = new SqlCommand("Proc_FB_GetMatchResultList", GVAR.g_sqlConn);
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

        public void AutoGroupRank(Int32 iPhaseID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for AutoGroupRank
                SqlCommand cmd = new SqlCommand("Proc_FB_CreateGroupResult", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@PhaseID", SqlDbType.Int);

                cmdParameter1.Value = iPhaseID;

                cmd.Parameters.Add(cmdParameter1);
                #endregion

                cmd.ExecuteNonQuery();

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        #endregion

        public int GetPlayerShirtNoByID(int iMatchID, int iRegisterID)
        {
            int iShirtNumber = -1;
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DM Operation For UpdateTeamScore

                string strFmt = @"SELECT F_ShirtNumber FROM TS_Match_Member
                                WHERE F_MatchID = {0} AND F_RegisterID = {1}";

                string strSQL = String.Format(strFmt, iMatchID, iRegisterID);
                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_sqlConn);
                SqlDataReader dr = cmd.ExecuteReader();
                if(dr.HasRows)
                {
                    while(dr.Read())
                    {
                        iShirtNumber = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ShirtNumber");
                    }
                }
                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return iShirtNumber;
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

        public void GetMatchInfo_Export(int iMatchID, ref DataTable dt)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchInfo

                SqlCommand cmd = new SqlCommand("Proc_TVG_FB_GetMatchInfo", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar);
                

                cmdParameter1.Value = iMatchID;
                cmdParameter2.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dt.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void GetHost_VS_Guest_Export(int iMatchID, ref DataTable dt)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchInfo

                SqlCommand cmd = new SqlCommand("Proc_TVG_FB_GetMatch_VS", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar);
                

                cmdParameter1.Value = iMatchID;
                cmdParameter2.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dt.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void GetScheduleAndResults_Export(int iMatchID, ref DataTable dt)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchInfo

                SqlCommand cmd = new SqlCommand("Proc_TVG_FB_ScheduleAndResults", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);

                cmdParameter1.Value = iMatchID;

                cmd.Parameters.Add(cmdParameter1);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dt.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void GetGroupComposition_Export(int iMatchID, ref DataTable dt)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchInfo

                SqlCommand cmd = new SqlCommand("Proc_TVG_FB_GroupComposition", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);

                cmdParameter1.Value = iMatchID;

                cmd.Parameters.Add(cmdParameter1);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dt.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void GetGroupRanking_Export(int iMatchID, ref DataTable dt)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchInfo

                SqlCommand cmd = new SqlCommand("Proc_TVG_FB_GroupRanking", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);

                cmdParameter1.Value = iMatchID;

                cmd.Parameters.Add(cmdParameter1);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dt.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void GetTeamPlayedMatchs_Export(int iMatchID,int iPos, ref DataTable dt)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchInfo

                SqlCommand cmd = new SqlCommand("Proc_TVG_FB_TeamPlayedMatchs", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@Pos", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar);
                

                cmdParameter1.Value = iMatchID;
                cmdParameter2.Value = iPos;
                cmdParameter3.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dt.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void GetCoach_Export(int iMatchID,int iPos, ref DataTable dt)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchInfo

                SqlCommand cmd = new SqlCommand("Proc_TVG_FB_Coach", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@TeamPos", SqlDbType.Int);
                cmdParameter1.Value = iMatchID;
                 cmdParameter2.Value = iPos;
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dt.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void GetMatchReferees_Export(int iMatchID, ref DataTable dt)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchInfo

                SqlCommand cmd = new SqlCommand("Proc_TVG_FB_MatchReferees", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);

                cmdParameter1.Value = iMatchID;

                cmd.Parameters.Add(cmdParameter1);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dt.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void GetTournament_Chart_Export(int iMatchID,int iRound, ref DataTable dt)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchInfo

                SqlCommand cmd = new SqlCommand("Proc_TVG_FB_Tournament_Chart", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@Round", SqlDbType.Int);

                cmdParameter1.Value = iMatchID;
                cmdParameter2.Value = iRound;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dt.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
             
        }
        public void GetMedalList_Export(int iMatchID, ref DataTable dt)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchInfo

                SqlCommand cmd = new SqlCommand("Proc_TVG_FB_MedalList", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);

                cmdParameter1.Value = iMatchID;

                cmd.Parameters.Add(cmdParameter1);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dt.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void GetTeamList_Export(int iMatchID, int iPos, ref DataTable dt)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchInfo

                SqlCommand cmd = new SqlCommand("Proc_TVG_FB_TeamList", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@TeamPos", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar);
                cmdParameter1.Value = iMatchID;
                 cmdParameter2.Value = iPos;
                 cmdParameter3.Value = m_strActiveLanguage;
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dt.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public void GetMatchStatistics_Export(int iMatchID, ref DataTable dt)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchInfo

                SqlCommand cmd = new SqlCommand("Proc_TVG_FB_MatchStatistics", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar);
                

                cmdParameter1.Value = iMatchID;
                cmdParameter2.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dt.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void GetWeatherCondition_Export(int iMatchID, ref DataTable dt)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchInfo

                SqlCommand cmd = new SqlCommand("Proc_TVG_FB_Weather", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar);
                

                cmdParameter1.Value = iMatchID;
                cmdParameter2.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                dt.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        
        public void UpdateWeatherDataToDB(int MatchID, string AirTemp, string WaterTemp, string Humidity, int WeatherTypeID, string WindSpeed, String WindDirectionID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            try
            {
                SqlCommand cmd = new SqlCommand("Proc_FB_UpdateMatchWeather", GVAR.g_sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter paramMatchID = new SqlParameter("@MatchID", MatchID);
                SqlParameter paramAirTemp = new SqlParameter("@AirTemp", AirTemp);
                SqlParameter paramWaterTemp = new SqlParameter("@WaterTemp", WaterTemp);
                SqlParameter paramHumidity = new SqlParameter("@Humidity", Humidity);
                SqlParameter paramWeatherTypeID = new SqlParameter("@WeatherTypeID", WeatherTypeID);
                SqlParameter paramWindSpeed = new SqlParameter("@WindSpeed", WindSpeed);
                SqlParameter paramWindDirectionID = new SqlParameter("@WindDirectionID", WindDirectionID);
                SqlParameter paramResult = new SqlParameter("@Result", DBNull.Value);

                cmd.Parameters.Add(paramMatchID);
                cmd.Parameters.Add(paramAirTemp);
                cmd.Parameters.Add(paramWaterTemp);
                cmd.Parameters.Add(paramHumidity);
                cmd.Parameters.Add(paramWeatherTypeID);
                cmd.Parameters.Add(paramWindSpeed);
                cmd.Parameters.Add(paramWindDirectionID);
                cmd.Parameters.Add(paramResult);
                cmd.ExecuteNonQuery();

            }
            catch (Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        public DataTable GetWeatherWindDirection()
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            DataTable dt = new DataTable();

            try
            {
                SqlCommand sqlCommand = new SqlCommand();
                sqlCommand.Connection = GVAR.g_sqlConn;
                sqlCommand.CommandText = "Proc_FB_ListWindDirection";
                sqlCommand.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter();
                sqlDataAdapter.SelectCommand = sqlCommand;
                sqlDataAdapter.Fill(dt);
                return dt;
            }
            catch (Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return dt;
        }
        public DataTable GetWeatherDescription()
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            DataTable dt = new DataTable();
            try
            {
                SqlCommand sqlCommand = new SqlCommand();
                sqlCommand.Connection = GVAR.g_sqlConn;
                sqlCommand.CommandText = "Proc_FB_ListWeatherType";
                sqlCommand.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter();
                sqlDataAdapter.SelectCommand = sqlCommand;
                sqlDataAdapter.Fill(dt);
                return dt;
            }
            catch (Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return dt;
        }

        public DataTable GetWeatherControlData(int MatchID)
        {
            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            DataTable dt = new DataTable();
            try
            {

                SqlCommand sqlCommand = new SqlCommand();
                sqlCommand.Connection = GVAR.g_sqlConn;
                sqlCommand.CommandText = "Proc_FB_GetMatchWeather";
                sqlCommand.CommandType = CommandType.StoredProcedure;
                sqlCommand.Parameters.AddWithValue("@MatchID", MatchID);
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter();
                sqlDataAdapter.SelectCommand = sqlCommand;
                sqlDataAdapter.Fill(dt);
                return dt;
            }
            catch (Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return dt;
        }
    }
}
