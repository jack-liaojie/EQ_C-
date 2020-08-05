using System;
using System.Collections.Generic;
using System.Text;

using System.Windows.Forms;
using System.Data.SqlClient;
using System.Collections;
using System.Data;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using System.IO;

namespace AutoSports.OVRSEPlugin
{
    public class OVRSEManageDB
    {
        private Int32 m_iSportID;
        private Int32 m_iDisciplineID;
        private String m_strLanguage;

        public OVRSEManageDB()
        {
            m_iSportID = -1;
            m_iDisciplineID = -1;
            m_strLanguage = "ENG";
        }

        // Init Data
        public bool InitGame()
        {
            if (SECommon.g_adoDataBase.DBConnect.State == ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }

            OVRDataBaseUtils.GetActiveInfo(SECommon.g_adoDataBase.m_dbConnect, out m_iSportID, out m_iDisciplineID, out m_strLanguage);
            m_iDisciplineID = GetDisplnID(SECommon.g_strDisplnCode);
            return true;
        }

        // Database Exchange
        public Int32 GetDisplnID(String strDisplnCode)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            Int32 iDisciplineID = 0;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strSQL;
                strSQL = String.Format("SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode= '{0}'", strDisplnCode);
                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.DBConnect);
                dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    iDisciplineID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_DisciplineID");
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }

            return iDisciplineID;
        }

        public Int32 GetPhaseID(int iMatchID)
        {
            SqlConnection sqlConnection = new SqlConnection(SECommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            Int32 iPhaseID = 0;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for GetPhaseID

                string strSQL;
                strSQL = String.Format("SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = {0}", iMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                dr = cmd.ExecuteReader();

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
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }

            if (sqlConnection != null)
            {
                sqlConnection.Close();
            }

            return iPhaseID;
        }

        public bool GetMatchRuleID(Int32 nMatchID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            Boolean bSetRule = false;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strFmt = @"SELECT b.F_CompetitionRuleID
                FROM TS_Match AS a LEFT JOIN TD_CompetitionRule AS b 
                ON a.F_CompetitionRuleID = b.F_CompetitionRuleID WHERE a.F_MatchID = {0:D} AND b.F_DisciplineID = {1:D}";

                String strSQL = String.Format(strFmt, nMatchID, GetDisplnID(SECommon.g_strDisplnCode));
                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.DBConnect);
                dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    bSetRule = true;
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
            return bSetRule;
        }

        public bool GetMatchRule(Int32 nMatchID, out Int32 nMatchType, out Int32 nTeamSplitCount, out Int32 nSetCount, out Int32 nScore, out Int32 nMaxScore, out Int32 nAdvantage, out Int32 nTieScore, out Int32 nTieMaxScore, out Boolean bSetRule, out Boolean bSplitRule)
        {
            nMatchType = -1;
            nTeamSplitCount = -1;
            nSetCount = -1;
            nScore = -1;
            nMaxScore = 0;
            nAdvantage = 0;
            nTieScore = 0;
            nTieMaxScore = 0;
            bSetRule = false;
            bSplitRule = false;

            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            Boolean bMatchRule = false;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strFmt = @"SELECT b.F_Type, b.F_Set, b.F_Game, b.F_GamePoint, b.F_MaxPoint, b.F_Advantage, b.F_TieGamePoint, b.F_TieGameMaxPoint, b.F_SetRule, b.F_SplitRule
                						FROM TS_Match AS a LEFT JOIN TD_CompetitionType_SE AS b 
                						ON a.F_CompetitionRuleID = b.F_CompetitionRuleID WHERE a.F_MatchID = {0:D}";

                String strSQL = String.Format(strFmt, nMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.DBConnect);
                dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    nMatchType = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_Type");
                    nTeamSplitCount = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_Set");
                    nSetCount = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_Game");
                    nScore = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_GamePoint");
                    nMaxScore = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MaxPoint");
                    nAdvantage = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_Advantage");
                    nTieScore = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_TieGamePoint");
                    nTieMaxScore = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_TieGameMaxPoint");

                    Int32 nSetRule = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_SetRule");
                    Int32 nSplitRule = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_SplitRule");

                    bSetRule = nSetCount == 0 ? false : true;
                    bSplitRule = nSplitRule == 0 ? false : true;

                    bMatchRule = true;
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
            return bMatchRule;
        }

        public bool GetMatchMember(Int32 nMatchID, out Int32 nRegAID, out Int32 nRegBID)
        {
            nRegAID = 0;
            nRegBID = 0;

            String strFmt = @"SELECT F_RegisterID, F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = {0:D} ORDER BY F_CompetitionPositionDes1, F_CompetitionPosition";
            String strSQL = String.Format(strFmt, nMatchID);
            STableRecordSet stRecords;

            try
            {
                if (!SECommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;

                if (stRecords.GetRecordCount() != 2)
                    return false;

                nRegAID = stRecords.GetFieldValue(0, "F_RegisterID") == String.Empty ? 0 : Convert.ToInt32(stRecords.GetFieldValue(0, "F_RegisterID"));
                nRegBID = stRecords.GetFieldValue(1, "F_RegisterID") == String.Empty ? 0 : Convert.ToInt32(stRecords.GetFieldValue(1, "F_RegisterID"));
            }
            catch (System.Exception errorSQL)
            {
                MessageBoxEx.Show(errorSQL.ToString());
                return false;
            }

            return true;
        }

        public bool GetHoopMatchMember(Int32 nMatchID, out Int32 nRegAID)
        {
            nRegAID = 0;

            String strFmt = @"SELECT F_RegisterID, F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = {0:D} ORDER BY F_CompetitionPositionDes1, F_CompetitionPosition";
            String strSQL = String.Format(strFmt, nMatchID);
            STableRecordSet stRecords;

            try
            {
                if (!SECommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;

                if (stRecords.GetRecordCount() != 1)
                    return false;

                nRegAID = stRecords.GetFieldValue(0, "F_RegisterID") == String.Empty ? 0 : Convert.ToInt32(stRecords.GetFieldValue(0, "F_RegisterID"));
            }
            catch (System.Exception errorSQL)
            {
                MessageBoxEx.Show(errorSQL.ToString());
                return false;
            }

            return true;
        }

        public Int32 CreateHoopMatchSplit(Int32 nMatchID, Int32 nMatchType, Int32 nSetsCount, Int32 nTeamSplitCount)
        {
            String strStoreProcName;

            ArrayList paramCollection = new ArrayList();

            strStoreProcName = "proc_CreateHoopMatchSplits_1_Level";

            paramCollection.Add(new SqlParameter("@MatchID", nMatchID));
            paramCollection.Add(new SqlParameter("@MatchType", nMatchType));
            paramCollection.Add(new SqlParameter("@Level_1_SplitNum", nSetsCount));

            paramCollection.Add(new SqlParameter("@CreateType", 1)); // @CreateType = 1 : Create Delete Old and Create New Splits
            paramCollection.Add(new SqlParameter("@Result", -1));
            ((SqlParameter)paramCollection[4]).Direction = ParameterDirection.Output;

            SqlParameter[] aryParams = new SqlParameter[paramCollection.Count];
            paramCollection.CopyTo(aryParams, 0);

            Int32 nRetValue = 0;

            try
            {
                SECommon.g_adoDataBase.ExecuteProcNoQuery(strStoreProcName, ref aryParams);
                nRetValue = (Int32)aryParams[aryParams.Length - 1].Value;
            }
            catch (System.Exception errorProc)
            {
                MessageBoxEx.Show(errorProc.ToString());
                return -1;
            }

            return nRetValue;
        }

        public Int32 CreateMatchSplit(Int32 nMatchID, Int32 nMatchType, Int32 nSetsCount, Int32 nTeamSplitCount)
        {
            String strStoreProcName;

            ArrayList paramCollection = new ArrayList();
            if (nMatchType == SECommon.MATCH_TYPE_TEAM)
            {
                strStoreProcName = "proc_CreateMatchSplits_2_Level";

                paramCollection.Add(new SqlParameter("@MatchID", nMatchID));
                paramCollection.Add(new SqlParameter("@MatchType", nMatchType));
                paramCollection.Add(new SqlParameter("@Level_1_SplitNum", nTeamSplitCount));
                paramCollection.Add(new SqlParameter("@Level_2_SplitNum", nSetsCount));

                paramCollection.Add(new SqlParameter("@CreateType", 1)); // @CreateType = 1 : Create Delete Old and Create New Splits
                paramCollection.Add(new SqlParameter("@Result", -1));
                ((SqlParameter)paramCollection[5]).Direction = ParameterDirection.Output;
            }
            else
            {
                strStoreProcName = "proc_CreateMatchSplits_1_Level";

                paramCollection.Add(new SqlParameter("@MatchID", nMatchID));
                paramCollection.Add(new SqlParameter("@MatchType", nMatchType));
                paramCollection.Add(new SqlParameter("@Level_1_SplitNum", nSetsCount));

                paramCollection.Add(new SqlParameter("@CreateType", 1)); // @CreateType = 1 : Create Delete Old and Create New Splits
                paramCollection.Add(new SqlParameter("@Result", -1));
                ((SqlParameter)paramCollection[4]).Direction = ParameterDirection.Output;
            }

            SqlParameter[] aryParams = new SqlParameter[paramCollection.Count];
            paramCollection.CopyTo(aryParams, 0);

            Int32 nRetValue = 0;

            try
            {
                SECommon.g_adoDataBase.ExecuteProcNoQuery(strStoreProcName, ref aryParams);
                nRetValue = (Int32)aryParams[aryParams.Length - 1].Value;
            }
            catch (System.Exception errorProc)
            {
                MessageBoxEx.Show(errorProc.ToString());
                return -1;
            }

            return nRetValue;
        }

        public bool GetHoopMatchSplitCount(Int32 nMatchID, Int32 pnMatchType, ref Int32 pnSetsCount, ref Int32 pnTeamSplitCount)// Get Match and it's split info, including the count and type
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            Boolean bResult = false;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strSQL, strFmt;

                if (pnMatchType == SECommon.MATCH_TYPE_HOOP)
                {
                    strFmt = @"SELECT Count(F_MatchSplitID) as F_SetsCount, 0 as F_TeamSplitCount 
                				FROM TS_Match_Split_Info WHERE F_FatherMatchSplitID=0 and F_MatchID={0:D}";

                    strSQL = String.Format(strFmt, nMatchID);
                }
                else return false;

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.DBConnect);
                dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    pnSetsCount = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_SetsCount");
                    pnTeamSplitCount = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_TeamSplitCount");

                    if (pnSetsCount > 0)
                    {
                        bResult = true;
                    }
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }

            return bResult;
        }


        public void UpdateHoopPlayers(Int32 nMatchID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update BatOrder
                String strFmt, strSQL;

                strFmt = @"Proc_SE_UpdateHoopPlayers";

                strSQL = String.Format(strFmt, nMatchID);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = nMatchID;
                cmd.ExecuteNonQuery();

                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void GetHoopMatchResult(Int32 nMatchID, Int32 nMatchType, DataGridView GridCtrl)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetHoopMatchResult", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchType", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchType",
                             DataRowVersion.Current, nMatchType);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridView(GridCtrl, dt);

                GridCtrl.Columns["F_RegisterID"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public bool UpdateHoopMatchResult(Int32 nMatchID, String strAction, Int32 nRegisterID, Int32 nValue)
        {
            SqlConnection sqlConnection = new SqlConnection(SECommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_UpdateHoopMatchResult", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Action", SqlDbType.NVarChar, 50,
                             ParameterDirection.Input, false, 0, 0, "@Action",
                             DataRowVersion.Current, strAction);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@RegisterID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@RegisterID",
                             DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@Score", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Score",
                             DataRowVersion.Current, nValue);

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
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
                {
                    bResult = true;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            if (sqlConnection != null)
            {
                sqlConnection.Close();
            }

            return bResult;
        }

        public bool CreateHoopPhaseResult(Int32 nMatchID)
        {
            SqlConnection sqlConnection = new SqlConnection(SECommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_CreateHoopPhaseResult", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                cmd.Parameters.Add(cmdParameter1);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                bResult = true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            if (sqlConnection != null)
            {
                sqlConnection.Close();
            }

            return bResult;
        }

        public bool GetHoopMatchDes(Int32 nMatchID, out String strHomeName, out String strPhaseDes, out String strDateDes, out String strVeuneDes)
        {
            strHomeName = "";
            strPhaseDes = "";
            strDateDes = "";
            strVeuneDes = "";

            Boolean bResult = false;

            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetHoopMatchDescription", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                dr = cmd.ExecuteReader();
                if (dr.HasRows && dr.Read())
                {
                    strPhaseDes = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_MatchDes");
                    strDateDes = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DateDes");
                    strVeuneDes = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_VenueDes");
                    strHomeName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_HomeName");

                    bResult = true;
                }

                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                bResult = false;
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
            return bResult;
        }

        public bool GetOneMatchDes(Int32 nMatchID, out Int32 nHomeID, out Int32 nAwayID, out String strHomeName, out String strAwayName,
                                    out Int32 nMatchStatus, out String strSportDes, out String strPhaseDes,
                                    out String strDateDes, out String strVeuneDes, out String strHomeSet, out String strAwaySet, out Int32 nRegAPos, out Int32 nRegBPos)
        {
            nHomeID = -1;
            nAwayID = -1;
            strHomeName = "";
            strAwayName = "";
            nMatchStatus = -1;
            strSportDes = "";
            strPhaseDes = "";
            strDateDes = "";
            strVeuneDes = "";
            strHomeSet = "";
            strAwaySet = "";
            nRegAPos = -1;
            nRegBPos = -1;

            Boolean bResult = false;

            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_GetMatchDescription", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                dr = cmd.ExecuteReader();
                if (dr.HasRows && dr.Read())
                {
                    strSportDes = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_SportDes");
                    strPhaseDes = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_MatchDes");
                    strDateDes = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DateDes");
                    strVeuneDes = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_VenueDes");
                    strHomeName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_HomeName");
                    strAwayName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_AwayName");
                    nHomeID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_HomeID");
                    nAwayID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_AwayID");
                    nMatchStatus = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MatchStatusID");
                    strHomeSet = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_HomeScore");
                    strAwaySet = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_AwayScore");
                    nRegAPos = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_HomePos");
                    nRegBPos = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_AwayPos");

                    bResult = true;
                }

                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                bResult = false;
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
            return bResult;
        }

        public bool GetContestResult(Int32 nMatchID, out String strHomeSet, out String strAwaySet)
        {
            strHomeSet = "";
            strAwaySet = "";

            String strFmt = @"SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = {0:D} ORDER BY F_CompetitionPositionDes1, F_CompetitionPosition";
            String strSQL = String.Format(strFmt, nMatchID);
            STableRecordSet stRecords;

            try
            {
                if (!SECommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;

                if (stRecords.GetRecordCount() != 2)
                    return false;

                strHomeSet = stRecords.GetFieldValue(0, "F_Points");
                strAwaySet = stRecords.GetFieldValue(1, "F_Points");
            }
            catch (System.Exception errorSQL)
            {
                MessageBoxEx.Show(errorSQL.ToString());
                return false;
            }

            return true;
        }

        public Int32 GetMatchStatus(Int32 nMatchID)
        {
            SqlConnection sqlConnection = new SqlConnection(SECommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            Int32 iStatusID = -1;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strSQL;
                strSQL = String.Format("SELECT F_MatchStatusID FROM TS_Match WHERE F_MatchID = {0}", nMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    iStatusID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MatchStatusID");
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }

            if (sqlConnection != null)
            {
                sqlConnection.Close();
            }

            return iStatusID;
        }

        public void GetMatchResult(Int32 nMatchID, Int32 nMatchSplitID, DataGridView GridCtrl)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetMatchResult", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchSplitID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                             DataRowVersion.Current, nMatchSplitID);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridViewWithCmb(GridCtrl, dt, "MatchResult", "IRM");

                GridCtrl.Columns["F_CompetitionPosition"].Visible = false;
                GridCtrl.Columns["F_Game1ID"].Visible = false;
                GridCtrl.Columns["F_Game2ID"].Visible = false;
                GridCtrl.Columns["F_Game3ID"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public void InitMatchResultCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 nMatchID, Int32 nMatchSplitID, Int32 nPosition)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetMatchResultList", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchSplitID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                             DataRowVersion.Current, nMatchSplitID);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@Position", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Position",
                             DataRowVersion.Current, nPosition);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                #endregion

                dr = cmd.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public void InitIRMCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 nMatchID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetIRMList", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                dr = cmd.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public void UpdateMatchResult(Int32 nMatchID, Int32 nMatchSplitID, Int32 nPosition, Int32 nResultID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update BatOrder
                Int32 nRank;
                String strFmt, strSQL;

                nRank = nResultID == SECommon.RESULT_TYPE_WIN ? SECommon.RANK_TYPE_1ST : SECommon.RANK_TYPE_2ND;

                if (nMatchSplitID == -1)
                {
                    strFmt = @"UPDATE TS_Match_Result SET F_ResultID = (CASE WHEN {0:D} = -1 THEN NULL ELSE {0:D} END),
                               F_Rank = (CASE WHEN {1:D} = -1 THEN NULL ELSE {1:D} END) WHERE F_MatchID = {2:D} AND F_CompetitionPosition = {3:D}";

                    strSQL = String.Format(strFmt, nResultID, nRank, nMatchID, nPosition);
                }
                else
                {
                    strFmt = @"UPDATE TS_Match_Split_Result SET F_ResultID = (CASE WHEN {0:D} = -1 THEN NULL ELSE {0:D} END),
                               F_Rank = (CASE WHEN {1:D} = -1 THEN NULL ELSE {1:D} END) WHERE F_MatchID = {2:D} AND F_CompetitionPosition = {3:D} AND F_MatchSplitID = {4:D}";

                    strSQL = String.Format(strFmt, nResultID, nRank, nMatchID, nPosition, nMatchSplitID);
                }

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();

                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdateMatchIRM(Int32 nMatchID, Int32 nMatchSplitID, Int32 nPosition, Int32 nIRMID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update BatOrder
                String strFmt, strSQL;

                if (nMatchSplitID == -1)
                {
                    strFmt = @"UPDATE TS_Match_Result SET F_IRMID = (CASE WHEN {0:D} = -1 THEN NULL ELSE {0:D} END)
                               WHERE F_MatchID = {1:D} AND F_CompetitionPosition = {2:D}";

                    strSQL = String.Format(strFmt, nIRMID, nMatchID, nPosition);
                }
                else
                {
                    strFmt = @"UPDATE TS_Match_Split_Result SET F_IRMID = (CASE WHEN {0:D} = -1 THEN NULL ELSE {0:D} END)
                               WHERE F_MatchID = {1:D} AND F_CompetitionPosition = {2:D} AND F_MatchSplitID = {3:D}";

                    strSQL = String.Format(strFmt, nIRMID, nMatchID, nPosition, nMatchSplitID);
                }

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();

                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public bool UpdateMatchScore(Int32 nMatchID, Int32 nMatchSplitID, Int32 nPosition, Int32 nPoints)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt, strSQL;

                if (nMatchSplitID == -1)
                {
                    strFmt = @"UPDATE TS_Match_Result SET F_Points = {0:D}, F_PointsCharDes1 = {0:D} WHERE F_MatchID = {1:D} AND F_CompetitionPosition = {2:D}";
                    strSQL = String.Format(strFmt, nPoints, nMatchID, nPosition);
                }
                else
                {
                    strFmt = @"UPDATE TS_Match_Split_Result SET F_Points = {0:D} WHERE F_MatchID = {1:D} AND F_CompetitionPosition = {2:D} AND F_MatchSplitID = {3:D}";
                    strSQL = String.Format(strFmt, nPoints, nMatchID, nPosition, nMatchSplitID);
                }

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }

            return true;
        }

        public bool GetMatchSplitCount(Int32 nMatchID, Int32 pnMatchType, ref Int32 pnSetsCount, ref Int32 pnTeamSplitCount)// Get Match and it's split info, including the count and type
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            Boolean bResult = false;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strSQL, strFmt;

                if (pnMatchType == SECommon.MATCH_TYPE_REGU || pnMatchType == SECommon.MATCH_TYPE_DOUBLE)
                {
                    strFmt = @"SELECT Count(F_MatchSplitID) as F_SetsCount, 0 as F_TeamSplitCount 
                				FROM TS_Match_Split_Info WHERE F_FatherMatchSplitID=0 and F_MatchID={0:D}";

                    strSQL = String.Format(strFmt, nMatchID);
                }
                else if (pnMatchType == SECommon.MATCH_TYPE_TEAM)
                {
                    strFmt = @"SELECT 
    							(SELECT COUNT(*) FROM TS_Match_Split_Info WHERE F_MatchID={0:D} and F_FatherMatchSplitID=1) as F_SetsCount, 
    							Count(F_MatchSplitID) as F_TeamSplitCount 
    							FROM TS_Match_Split_Info WHERE F_FatherMatchSplitID=0 and F_MatchID={0:D}";

                    strSQL = String.Format(strFmt, nMatchID);
                }
                else return false;

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.DBConnect);
                dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    pnSetsCount = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_SetsCount");
                    pnTeamSplitCount = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_TeamSplitCount");

                    if (pnSetsCount > 0)
                    {
                        bResult = true;
                    }
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }

            return bResult;
        }

        public String GetStatusName(Int32 nStatusID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            String strStatus = String.Empty;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strSQL;
                strSQL = String.Format("SELECT F_StatusLongName FROM TC_Status_Des WHERE F_StatusID = {0:D} AND F_LanguageCode='{1}'", nStatusID, m_strLanguage);
                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.DBConnect);
                dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    strStatus = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_StatusLongName");
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }

            return strStatus;
        }

        public bool SetMatchResult(Int32 nMatchID, Int32 nCompetitionPos, Int32 nPoints, Int32 nRank, Int32 nResult)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"UPDATE TS_Match_Result SET F_Points = {0:D}, F_PointsCharDes1 = {0:D}, F_Rank = {1:D}, F_ResultID = {2:D} 
                						WHERE F_MatchID = {3:D} AND F_CompetitionPosition = {4:D}";
                String strSQL = String.Format(strFmt, nPoints, nRank, nResult, nMatchID, nCompetitionPos);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }

            return true;
        }

        public bool SetMatchResultWithNull(Int32 nMatchID, Int32 nCompetitionPos, Int32 nPoints)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"UPDATE TS_Match_Result SET F_Points = {0:D}, F_PointsCharDes1 = {0:D}, F_Rank = NULL, F_ResultID = NULL 
                						WHERE F_MatchID = {1:D} AND F_CompetitionPosition = {2:D}";
                String strSQL = String.Format(strFmt, nPoints, nMatchID, nCompetitionPos);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }

            return true;
        }

        public bool GetSubSplitInfo(Int32 nMatchID, Int32 nFatherSplitID, out STableRecordSet stRecords)
        {
            stRecords = null;
            String strFmt = @"SELECT * FROM TS_Match_Split_Info WHERE F_MatchID = {0:D} AND F_FatherMatchSplitID = {1:D} ORDER BY F_Order";
            String strSQL = String.Format(strFmt, nMatchID, nFatherSplitID);

            try
            {
                if (!SECommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;
            }
            catch (System.Exception errorSQL)
            {
                MessageBoxEx.Show(errorSQL.ToString());
                return false;
            }

            return true;
        }

        public bool GetSplitInfo(Int32 nMatchID, Int32 nMatchSplitID, out STableRecordSet stRecords)
        {
            stRecords = null;
            String strFmt = @"SELECT * FROM TS_Match_Split_Info WHERE F_MatchID = {0:D} AND F_MatchSplitID = {1:D}";
            String strSQL = String.Format(strFmt, nMatchID, nMatchSplitID);

            try
            {
                if (!SECommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;
            }
            catch (System.Exception errorSQL)
            {
                MessageBoxEx.Show(errorSQL.ToString());
                return false;
            }

            return true;
        }

        public bool GetSplitStatus(Int32 nMatchID, Int32 nMatchSplitID, out STableRecordSet stRecords)
        {
            stRecords = null;
            String strFmt = @"SELECT a.F_MatchSplitStatusID, b.F_StatusLongName, a.F_MatchID, a.F_MatchSplitID 
						FROM TS_Match_Split_Info AS a, TC_Status_Des AS b 
						WHERE a.F_MatchSplitStatusID = b.F_StatusID AND a.F_MatchID = {0:D} AND a.F_MatchSplitID = {1:D} AND b.F_LanguageCode = '{2}'";
            String strSQL = String.Format(strFmt, nMatchID, nMatchSplitID, m_strLanguage);

            try
            {
                if (!SECommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;
            }
            catch (System.Exception errorSQL)
            {
                MessageBoxEx.Show(errorSQL.ToString());
                return false;
            }

            return true;
        }

        public bool GetSplitResult(Int32 nMatchID, Int32 nMatchSplitID, out STableRecordSet stRecords)
        {
            stRecords = null;
            String strFmt = @"SELECT * FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition WHERE A.F_MatchID = {0:D}
                              AND A.F_MatchSplitID = {1:D} ORDER BY B.F_CompetitionPositionDes1, A.F_CompetitionPosition";
            String strSQL = String.Format(strFmt, nMatchID, nMatchSplitID);

            try
            {
                if (!SECommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;

                if (stRecords.GetRecordCount() != 2)
                    return false;
            }
            catch (System.Exception errorSQL)
            {
                MessageBoxEx.Show(errorSQL.ToString());
                return false;
            }

            return true;
        }

        public void GetMatchTime(Int32 nMatchID, Int32 nMatchType, DataGridView GridCtrl)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetMatchTime", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@MatchType", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@MatchType",
                            DataRowVersion.Current, nMatchType);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridView(GridCtrl, dt, null, null);

                GridCtrl.Columns["Match1ID"].Visible = false;
                GridCtrl.Columns["Match2ID"].Visible = false;
                GridCtrl.Columns["Match3ID"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public bool UpdateMatchTime(Int32 nMatchID, Int32 nSplitID, String strValue)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_UpdateMatchTime", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@MatchSplitID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                            DataRowVersion.Current, nSplitID);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@SpendTime", SqlDbType.NVarChar, 10,
                            ParameterDirection.Input, false, 0, 0, "@SpendTime",
                            DataRowVersion.Current, strValue);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);


                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
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

        public bool SetSplitPoints(Int32 nMatchID, Int32 nMatchSplitID, Int32 nCompetitionPos, Int32 nPoints)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"Update TS_Match_Split_Result SET F_Points = {0:D} 
            		                WHERE F_MatchID={1:D} AND F_MatchSplitID={2:D} AND F_CompetitionPosition={3:D}";

                String strSQL = String.Format(strFmt, nPoints, nMatchID, nMatchSplitID, nCompetitionPos);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }

            return true;
        }

        public bool SetSplitService(Int32 nMatchID, Int32 nMatchSplitID, Int32 nCompetitionPos, bool bService)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                Int32 nService = bService ? 1 : 0;
                String strFmt = @"Update TS_Match_Split_Result SET F_Service = {0:D} 
                						WHERE F_MatchID={1:D} AND F_MatchSplitID={2:D} AND F_CompetitionPosition={3:D}";

                String strSQL = String.Format(strFmt, nService, nMatchID, nMatchSplitID, nCompetitionPos);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }

            return true;
        }

        public bool SetSplitResult(Int32 nMatchID, Int32 nMatchSplitID, Int32 nCompetitionPos, Int32 nPoints, Int32 nRank, Int32 nResult)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"Update TS_Match_Split_Result SET F_Points = {0:D}, F_Rank = {1:D}, F_ResultID = {2:D} 
						WHERE F_MatchID={3:D} AND F_MatchSplitID={4:D} AND F_CompetitionPosition={5:D}";

                String strSQL = String.Format(strFmt, nPoints, nRank, nResult, nMatchID, nMatchSplitID, nCompetitionPos);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }

            return true;
        }

        public bool UpdateMatchRankSets(Int32 nMatchID)
        {
            SqlConnection sqlConnection = new SqlConnection(SECommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_UpdateMatchRankSets", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
                {
                    bResult = true;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            if (sqlConnection != null)
            {
                sqlConnection.Close();
            }

            return bResult;
        }

        public bool CreateGroupResult(Int32 nMatchID)
        {
            SqlConnection sqlConnection = new SqlConnection(SECommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_CreateGroupResult", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                //SqlParameter cmdParameterResult = new SqlParameter(
                //            "@Result", SqlDbType.Int, 0,
                //            ParameterDirection.Output, false, 0, 0, "@Result",
                //            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                //cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                bResult = true;
                //Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                //if (nRetValue > 0)
                //{
                //    bResult = true;
                //}
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            if (sqlConnection != null)
            {
                sqlConnection.Close();
            }

            return bResult;
        }

        //Team Use
        public void GetTeamUniform(Int32 nMatchID, Int32 nPos, ComboBox cmbUniform)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            Int32 nUniformID = 0;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strFmt = "SELECT F_UniformID FROM TS_Match_Result WHERE F_MatchID = {0:D} AND F_CompetitionPositionDes1 = {1:D}";
                String strSQL = String.Format(strFmt, nMatchID, nPos);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    nUniformID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_UniformID");
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }

            try
            {
                #region DML Command Setup for Get Regus List
                SqlCommand cmd = new SqlCommand("Proc_SE_GetTeamUniformList", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                DataTable m_dtUniform = null;
                m_dtUniform = new DataTable();
                m_dtUniform.Clear();

                dr = cmd.ExecuteReader();
                m_dtUniform.Load(dr);
                dr.Close();

                cmbUniform.DisplayMember = "F_Uniform";
                cmbUniform.ValueMember = "F_UniformID";
                cmbUniform.DataSource = m_dtUniform;

                if (nUniformID < 1)
                {
                    cmbUniform.SelectedIndex = -1;
                }
                else
                {
                    cmbUniform.SelectedValue = nUniformID;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public void UpdateTeamUniform(Int32 nMatchID, Int32 nPos, Int32 nUniformID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update BatOrder

                String strFmt = @"UPDATE TS_Match_Result SET F_UniformID = {0:D} WHERE F_MatchID = {1:D} AND F_CompetitionPositionDes1 = {2:D}";
                String strSQL = String.Format(strFmt, nUniformID, nMatchID, nPos);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();

                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void GetRegusList(Int32 nMatchID, ComboBox cmbRegus)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get Regus List
                SqlCommand cmd = new SqlCommand("Proc_SE_GetRegusList", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                cmd.Parameters.Add(cmdParameter1);
                #endregion

                DataTable m_dtRegu = null;
                m_dtRegu = new DataTable();
                m_dtRegu.Clear();

                dr = cmd.ExecuteReader();
                m_dtRegu.Load(dr);
                dr.Close();

                cmbRegus.DisplayMember = "F_Regu";
                cmbRegus.ValueMember = "F_SplitID";
                cmbRegus.DataSource = m_dtRegu;
                cmbRegus.SelectedIndex = 0;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public void ResetMatchSplitOfficials(Int32 nMatchID, Int32 nSplitID, DataGridView GridCtrl)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetMatchSplitReferee", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchSplitID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                             DataRowVersion.Current, nSplitID);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridView(GridCtrl, dt, null, null);
                GridCtrl.Columns["F_RegisterID"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        //Referee
        public void GetEventReferee(Int32 nMatchID, Int32 nMatchType, Int32 nMatchSplitID, DataGridView GridCtrl)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetEventReferee", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchType", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchType",
                             DataRowVersion.Current, nMatchType);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@MatchSplitID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                             DataRowVersion.Current, nMatchSplitID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                #endregion

                dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridView(GridCtrl, dt, null, null);
                GridCtrl.Columns["F_RegisterID"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public void GetMatchReferee(Int32 nMatchID, Int32 nMatchType, Int32 nMatchSplitID, DataGridView GridCtrl)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetMatchReferee", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchType", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchType",
                             DataRowVersion.Current, nMatchType);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@MatchSplitID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                             DataRowVersion.Current, nMatchSplitID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                #endregion

                dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridViewWithCmb(GridCtrl, dt, "Function");
                GridCtrl.Columns["F_RegisterID"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public void InitFunctionCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 nMatchID, String strFunctionType)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetFunction", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@FunctionType", SqlDbType.NVarChar, 1,
                             ParameterDirection.Input, false, 0, 0, "@FunctionType",
                             DataRowVersion.Current, strFunctionType);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                dr = cmd.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public bool UpdateMatchOfficialFunction(Int32 nMatchID, Int32 nMatchSplitID, Int32 nRegisterID, Int32 nFunctionID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_UpdateMatchOfficialFunction", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchSplitID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                             DataRowVersion.Current, nMatchSplitID);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@FunctionID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@FunctionID",
                            DataRowVersion.Current, nFunctionID);

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
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
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

        public bool UpdateMatchOfficialOrder(Int32 nMatchID, Int32 nMatchSplitID, Int32 nRegisterID, Int32 nOrder)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_UpdateMatchOfficialOrder", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchSplitID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                             DataRowVersion.Current, nMatchSplitID);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@Order", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@Order",
                            DataRowVersion.Current, nOrder);

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
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
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

        public void AddMatchOfficial(Int32 nMatchID, Int32 nMatchSplitID, Int32 nRegisterID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_AddMatchOfficial", SECommon.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@MatchSplitID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                            DataRowVersion.Current, nMatchSplitID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void DelMatchOfficial(Int32 nMatchID, Int32 nMatchSplitID, Int32 nRegisterID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_DelMatchOfficial", SECommon.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@MatchSplitID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                            DataRowVersion.Current, nMatchSplitID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public bool UpdateAllSplitStatus(Int32 nMatchID, Int32 nTeamSplitID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"Update TS_Match_Split_Info SET F_MatchSplitStatusID = NULL WHERE F_MatchID={0:D} AND F_FatherMatchSplitID = {1:D}";
                String strSQL = String.Format(strFmt, nMatchID, nTeamSplitID);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }

            return true;
        }

        public bool UpdateSplitStatus(Int32 nMatchID, Int32 nSplitID, Int32 nSplitStatus)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"Update TS_Match_Split_Info SET F_MatchSplitStatusID = {0:D} WHERE F_MatchID={1:D} AND F_MatchSplitID={2:D}";
                String strSQL = String.Format(strFmt, nSplitStatus, nMatchID, nSplitID);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }

            return true;
        }

        public bool UpdateSplitStatusUnofficial(Int32 nMatchID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"Update TS_Match_Split_Info SET F_MatchSplitStatusID = 100 WHERE F_MatchID={0:D} AND F_MatchSplitStatusID = 50";
                String strSQL = String.Format(strFmt, nMatchID);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }

            return true;
        }

        public bool UpdateTeamSplitStatus(Int32 nMatchID, Int32 nTeamSplitID, Int32 nStatusID)
        {
            UpdateSplitStatusUnofficial(nMatchID);

            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"Update TS_Match_Split_Info SET F_MatchSplitStatusID = 100 WHERE F_MatchID={0:D} AND F_MatchSplitStatusID = 50";
                String strSQL = String.Format(strFmt, nMatchID);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"Update TS_Match_Split_Info SET F_MatchSplitStatusID = {0:D} WHERE F_MatchID={1:D} AND F_MatchSplitID = {2:D}";
                String strSQL = String.Format(strFmt, nStatusID, nMatchID, nTeamSplitID);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }

            return true;
        }

        //Teams Players
        public void GetTeamPlayers(Int32 nMatchID, Int32 nPos, DataGridView GridCtrl)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetTeamPlayers", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridView(GridCtrl, dt, null, null);

                GridCtrl.Columns["F_RegisterID"].Visible = false;
                GridCtrl.Columns["F_FunctionID"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public void GetMatchPlayers(Int32 nMatchID, Int32 nMatchType, Int32 nPos, DataGridView GridCtrl)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetMatchPlayers", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchType", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchType",
                             DataRowVersion.Current, nMatchType);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                #endregion

                dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridViewWithCmb(GridCtrl, dt, "Function", "Position", "StartUp", "Regu");

                GridCtrl.Columns["F_RegisterID"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public void AddMatchPlayer(Int32 nMatchID, Int32 nPos, Int32 nRegisterID, Int32 nFunctionID, Int32 nBib, Int32 order)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_AddMatchPlayer", SECommon.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@FunctionID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@FunctionID",
                            DataRowVersion.Current, nFunctionID);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@Bib", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@Bib",
                            DataRowVersion.Current, nBib);
                SqlParameter cmdParameter6 = new SqlParameter(
                            "@Order", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@Order",
                            DataRowVersion.Current, order);

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
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void DelMatchPlayer(Int32 nMatchID, Int32 nPos, Int32 nRegisterID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_DelMatchPlayer", SECommon.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void InitPositionCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 nMatchID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetPlayerPosition", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                dr = cmd.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public void InitPlayPositionCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 nMatchID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetPlayerPlayPosition", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                dr = cmd.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public bool UpdateMatchPlayerPosition(Int32 nMatchID, Int32 nPos, Int32 nRegisterID, Int32 nPositionID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_UpdateMatchPlayerPosition", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@PositionID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@PositionID",
                            DataRowVersion.Current, nPositionID);

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
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
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

        public bool UpdateMatchPlayerPlayPosition(Int32 nMatchID, Int32 nMatchType, Int32 nMatchSplitID, Int32 nPos, Int32 nRegisterID, String strPlayPosition)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_UpdateMatchPlayerPlayPosition", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchType", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchType",
                             DataRowVersion.Current, nMatchType);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@MatchSplitID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                             DataRowVersion.Current, nMatchSplitID);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter6 = new SqlParameter(
                            "@PlayPosition", SqlDbType.NVarChar, 10,
                            ParameterDirection.Input, false, 0, 0, "@PlayPosition",
                            DataRowVersion.Current, strPlayPosition);

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
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
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

        public bool UpdateMatchPlayerFunction(Int32 nMatchID, Int32 nPos, Int32 nRegisterID, Int32 nFunctionID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_UpdateMatchPlayerFunction", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@FunctionID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@FunctionID",
                            DataRowVersion.Current, nFunctionID);

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
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
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

        public bool UpdateMatchPlayerStartUp(Int32 nMatchID, Int32 nPos, Int32 nRegisterID, Int32 nStartUpID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_UpdateMatchPlayerStartUp", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@StartUpID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@StartUpID",
                            DataRowVersion.Current, nStartUpID);

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
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
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

        //两队上场队员信息
        public void GetMatchPlayersList(Int32 nMatchID, Int32 nMatchType, Int32 nPos, Int32 nMatchSplitID, DataGridView GridCtrl)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetMatchPlayersOrderByActive", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchType", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchType",
                             DataRowVersion.Current, nMatchType);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@MatchSplitID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                             DataRowVersion.Current, nMatchSplitID);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                #endregion

                dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridViewWithCmb(GridCtrl, dt, "PlayPos", "Active");

                GridCtrl.Columns["F_RegisterID"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public void GetGameActionList(Int32 nMatchID, Int32 nSetID, Int32 nPos, DataGridView GridCtrl)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetTeamGameActiveList", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchSplitID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                             DataRowVersion.Current, nSetID);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                #endregion

                dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridView(GridCtrl, dt, null, null);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public bool GetUndoStatus(Int32 nMatchID, Int32 nSplitID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strFmt = @"SELECT F_ActionNumberID FROM TS_Match_ActionList WHERE F_MatchID = {0:D} AND F_MatchSplitID > {1:D}";
                String strSQL = String.Format(strFmt, nMatchID, nSplitID);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.DBConnect);
                dr = cmd.ExecuteReader();

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
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }

            return bResult;
        }

        public void InitActiveCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetActiveStatus", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                #endregion

                dr = cmd.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public void InitStartUpCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 nMatchID, Int32 nPos)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetStartUpStatus", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@Pos", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@Pos",
                            DataRowVersion.Current, nPos);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                dr = cmd.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public bool UpdateMatchPlayerActive(Int32 nMatchID, Int32 nMatchType, Int32 nMatchSplitID, Int32 nPos, Int32 nRegisterID, Int32 nActiveID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_UpdateMatchPlayerActive", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchType", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchType",
                             DataRowVersion.Current, nMatchType);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@MatchSplitID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                             DataRowVersion.Current, nMatchSplitID);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter6 = new SqlParameter(
                            "@ActiveID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@ActiveID",
                            DataRowVersion.Current, nActiveID);

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
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
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

        public void InitReguCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 nMatchID, Int32 nPos)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetAvailableRegusList", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@Pos", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@Pos",
                            DataRowVersion.Current, nPos);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                dr = cmd.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public bool UpdateMatchPlayerRegu(Int32 nMatchID, Int32 nPos, Int32 nRegisterID, Int32 nReguID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_UpdateMatchPlayerRegu", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@ReguID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@ReguID",
                            DataRowVersion.Current, nReguID);

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
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
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

        //技术统计

        public Int32 GetActionID(String strActionName)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            Int32 iActionID = -1;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strFmt = @"SELECT F_ActionTypeID FROM TD_ActionType WHERE F_DisciplineID = {0:D} AND F_ActionCode = '{1}'";
                String strSQL = String.Format(strFmt, m_iDisciplineID, strActionName);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.DBConnect);
                dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    iActionID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ActionTypeID");
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }

            return iActionID;
        }

        public Int32 GetStatisticID(String strStatisticName)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            Int32 iStatisticID = -1;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strFmt = @"SELECT F_StatisticID FROM TD_Statistic WHERE F_DisciplineID = {0:D} AND F_StatisticCode = '{1}'";
                String strSQL = String.Format(strFmt, m_iDisciplineID, strStatisticName);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.DBConnect);
                dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    iStatisticID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_StatisticID");
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }

            return iStatisticID;
        }

        public Boolean GetPlayerCardStatu(Int32 nMatchID, Int32 nRegisterID, Int32 nPos, Int32 nStatisticID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_GetPlayerRedCard", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@StatisticID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@StatisticID",
                            DataRowVersion.Current, nStatisticID);

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
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue == 1)
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

        public bool UpdatPlayerYellowCard(Int32 nMatchID, Int32 nRegisterID, Int32 nPos, Int32 nStatisticID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SE_UpdatePlayerYellowCard", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPos);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@StatisticID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@StatisticID",
                            DataRowVersion.Current, nStatisticID);

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
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
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

        public Boolean AddActionList(Int32 nPosition, Int32 nMatchID, Int32 nSplitID, Int32 nRegisterID, Int32 nActionID, Int32 nScoreA, Int32 nScoreB, Int32 nPointType)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("proc_SE_AddAction", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPosition);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@MatchSplitID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                             DataRowVersion.Current, nSplitID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter5 = new SqlParameter(
                             "@ActionTypeID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@ActionTypeID",
                             DataRowVersion.Current, nActionID);

                SqlParameter cmdParameter6 = new SqlParameter(
                            "@ScoreA", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@ScoreA",
                            DataRowVersion.Current, nScoreA);

                SqlParameter cmdParameter7 = new SqlParameter(
                            "@ScoreB", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@ScoreB",
                            DataRowVersion.Current, nScoreB);

                SqlParameter cmdParameter8 = new SqlParameter(
                            "@PointType", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@PointType",
                            DataRowVersion.Current, nPointType);

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
                cmd.Parameters.Add(cmdParameter7);
                cmd.Parameters.Add(cmdParameter8);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
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

        public bool DeleteAcitonList(Int32 nMatchID, Int32 nSplitID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("proc_SE_DelAction", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@DisciplineID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                             DataRowVersion.Current, m_iDisciplineID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@MatchSplitID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                            DataRowVersion.Current, nSplitID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
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

        public void GetGameLastActive(Int32 nMatchID, Int32 nMatchSplitID, out Int32 nPosition, out Int32 nSub)
        {
            nPosition = 0;
            nSub = 0;

            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SE_GetGameLastActive", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@MatchSplitID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                            DataRowVersion.Current, nMatchSplitID);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                dr = cmd.ExecuteReader();
                if (dr.HasRows && dr.Read())
                {
                    nPosition = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "Position");
                    nSub = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "Sub");
                }

                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public bool AddStatisticInfo(Int32 nPosition, Int32 nMatchID, Int32 nSplitID, Int32 nRegisterID, Int32 nStatisticID)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("proc_SE_AddStatistic", SECommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@Pos", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Pos",
                             DataRowVersion.Current, nPosition);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@MatchSplitID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@MatchSplitID",
                            DataRowVersion.Current, nSplitID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@StatisticID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@StatisticID",
                            DataRowVersion.Current, nStatisticID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                if (nRetValue > 0)
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

        //导入导出信息

        public bool GetDisciplineDateList(ComboBox cmbDateList)
        {
            if (SECommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for Get Regus List

                String strFmt = "SELECT LEFT(CONVERT (NVARCHAR(100), F_Date, 120), 10) AS F_Date, F_DisciplineDateID FROM TS_DisciplineDate WHERE F_DisciplineID = {0:D} ORDER BY F_DateOrder";
                String strSQL = String.Format(strFmt, m_iDisciplineID);

                SqlCommand cmd = new SqlCommand(strSQL, SECommon.g_adoDataBase.m_dbConnect);

                #endregion

                DataTable m_dtDate = null;
                m_dtDate = new DataTable();
                m_dtDate.Clear();

                dr = cmd.ExecuteReader();
                m_dtDate.Load(dr);
                dr.Close();

                cmbDateList.DisplayMember = "F_Date";
                cmbDateList.ValueMember = "F_DisciplineDateID";
                cmbDateList.DataSource = m_dtDate;
                cmbDateList.SelectedIndex = -1;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }

            return true;
        }

        public void ExportAthleteXml(String strFilePath)
        {
            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                String strOutPut;
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = SECommon.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_SE_CreateXML_AthleteList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iDisciplineID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@OutputXML", SqlDbType.NVarChar, 9000000,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    strOutPut = Convert.ToString(cmdParameterResult.Value);
                    if (File.Exists(strFilePath))
                    {
                        File.Delete(strFilePath);
                    }

                    StreamWriter OneStreamWriter = File.CreateText(strFilePath);
                    OneStreamWriter.WriteLine(strOutPut);
                    OneStreamWriter.Close();
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(SECommon.m_strSectionName, "msgExportFile"));
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void ExportScheduleXml(String strFilePath, Int32 nDateID)
        {
            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                String strOutPut;
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = SECommon.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_SE_CreateXML_Schedule";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iDisciplineID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@DateID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nDateID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@OutputXML", SqlDbType.NVarChar, 9000000,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    strOutPut = Convert.ToString(cmdParameterResult.Value);
                    if (File.Exists(strFilePath))
                    {
                        File.Delete(strFilePath);
                    }

                    StreamWriter OneStreamWriter = File.CreateText(strFilePath);
                    OneStreamWriter.WriteLine(strOutPut);
                    OneStreamWriter.Close();
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(SECommon.m_strSectionName, "msgExportFile"));
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void ExportHoopScheduleXml(String strFilePath, Int32 nDateID)
        {
            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                String strOutPut;
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = SECommon.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_SE_CreateXML_HoopSchedule";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iDisciplineID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@DateID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nDateID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@OutputXML", SqlDbType.NVarChar, 9000000,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    strOutPut = Convert.ToString(cmdParameterResult.Value);
                    if (File.Exists(strFilePath))
                    {
                        File.Delete(strFilePath);
                    }

                    StreamWriter OneStreamWriter = File.CreateText(strFilePath);
                    OneStreamWriter.WriteLine(strOutPut);
                    OneStreamWriter.Close();
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(SECommon.m_strSectionName, "msgExportFile"));
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void ExportHoopCompListXml(String strFilePath)
        {
            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                String strOutPut;
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = SECommon.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_SE_CreateXML_HoopCompList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iDisciplineID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@OutputXML", SqlDbType.NVarChar, 9000000,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    strOutPut = Convert.ToString(cmdParameterResult.Value);
                    if (File.Exists(strFilePath))
                    {
                        File.Delete(strFilePath);
                    }

                    StreamWriter OneStreamWriter = File.CreateText(strFilePath);
                    OneStreamWriter.WriteLine(strOutPut);
                    OneStreamWriter.Close();
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(SECommon.m_strSectionName, "msgExportFile"));
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void ExportTeamXml(String strFilePath)
        {
            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                String strOutPut;
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = SECommon.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_SE_CreateXML_TeamList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iDisciplineID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@OutputXML", SqlDbType.NVarChar, 9000000,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    strOutPut = Convert.ToString(cmdParameterResult.Value);
                    if (File.Exists(strFilePath))
                    {
                        File.Delete(strFilePath);
                    }

                    StreamWriter OneStreamWriter = File.CreateText(strFilePath);
                    OneStreamWriter.WriteLine(strOutPut);
                    OneStreamWriter.Close();
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(SECommon.m_strSectionName, "msgExportFile"));
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public bool ImportMatchInfoXml(String strInputXML, out Int32 nMatchID, out Int32 nStatusID)
        {
            SqlConnection sqlConnection = new SqlConnection(SECommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            nMatchID = 0;
            nStatusID = 0;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = sqlConnection;
                oneSqlCommand.CommandText = "proc_SE_ImportMatchInfoXML";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@ActionXML", SqlDbType.NVarChar, 9000000,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strInputXML);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@StatusID", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    nMatchID = Convert.ToInt32(cmdParameterResult.Value);
                    nStatusID = Convert.ToInt32(cmdParameter2.Value);
                }
            }
            catch (Exception ex)
            {
            }

            if (sqlConnection != null)
            {
                sqlConnection.Close();
            }

            if (nMatchID == 0)
                return false;
            else
                return true;
        }

        public bool ImportActionListXml(String strInputXML, out Int32 nMatchID)
        {
            SqlConnection sqlConnection = new SqlConnection(SECommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            nMatchID = 0;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = sqlConnection;
                oneSqlCommand.CommandText = "proc_SE_ImportActionListXML";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@ActionXML", SqlDbType.NVarChar, 9000000,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strInputXML);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    nMatchID = Convert.ToInt32(cmdParameterResult.Value);
                }
            }
            catch (Exception ex)
            {
            }

            if (sqlConnection != null)
            {
                sqlConnection.Close();
            }

            if (nMatchID == 0)
                return false;
            else
                return true;
        }

        public bool ImportStatisticXml(String strInputXML, out Int32 nMatchID)
        {
            SqlConnection sqlConnection = new SqlConnection(SECommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            nMatchID = 0;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = sqlConnection;
                oneSqlCommand.CommandText = "proc_SE_ImportStatisticXML";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@ActionXML", SqlDbType.NVarChar, 9000000,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strInputXML);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    nMatchID = Convert.ToInt32(cmdParameterResult.Value);
                }
            }
            catch (Exception ex)
            {
            }

            if (sqlConnection != null)
            {
                sqlConnection.Close();
            }

            if (nMatchID == 0)
                return false;
            else
                return true;
        }

        public bool ImportHoopMatchInfoXml(String strInputXML, out Int32 nMatchID, out Int32 nStatusID)
        {
            SqlConnection sqlConnection = new SqlConnection(SECommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            nMatchID = 0;
            nStatusID = 0;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = sqlConnection;
                oneSqlCommand.CommandText = "proc_SE_ImportHoopMatchInfoXML";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@ActionXML", SqlDbType.NVarChar, 9000000,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strInputXML);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@StatusID", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    nMatchID = Convert.ToInt32(cmdParameterResult.Value);
                    nStatusID = Convert.ToInt32(cmdParameter2.Value);
                }
            }
            catch (Exception ex)
            {
            }

            if (sqlConnection != null)
            {
                sqlConnection.Close();
            }

            if (nMatchID == 0)
                return false;
            else
                return true;
        }

        public bool SetInitGameScore(int matchID, int splitID)
        {

            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = SECommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_SE_SetInitGamePoint";
            sqlCmd.CommandType = CommandType.StoredProcedure;

            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = splitID;
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception ex)
            {
                return false;
            }
        }

        public string ClearMatchResult(int matchID)
        {
            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = SECommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_SE_TEST_ClearMatchResult";
            sqlCmd.CommandType = CommandType.StoredProcedure;

            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.ExecuteNonQuery();
                return null;
            }
            catch (System.Exception ex)
            {
                return ex.Message;
            }
        }

        public string ClearMatchResultHoop(int matchID)
        {
            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = SECommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_SE_TEST_HoopClearMatchResult";
            sqlCmd.CommandType = CommandType.StoredProcedure;

            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.ExecuteNonQuery();
                return null;
            }
            catch (System.Exception ex)
            {
                return ex.Message;
            }
        }


        public DataTable GetViewScore(int nMatchID)
        {
            SqlConnection SqlConnection = new SqlConnection(SECommon.g_adoDataBase.m_strConnection);


            if (SqlConnection.State != System.Data.ConnectionState.Open)
            {
                SqlConnection.Open();
            }
            SqlDataReader reader = null;
            try
            {
                SqlCommand oneSqlCommand = SqlConnection.CreateCommand();
                oneSqlCommand.CommandText = string.Format("Proc_SE_GetMatchViewResult", SECommon.g_strDisplnCode);
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                oneSqlCommand.Parameters.Add("@MatchID", SqlDbType.Int).Value = nMatchID;
                SqlParameter param = oneSqlCommand.Parameters.Add("@Result", SqlDbType.Int);
                param.Direction = ParameterDirection.Output;

                reader = oneSqlCommand.ExecuteReader();
                if (Convert.ToInt32(param.Value) == -1)
                {
                    return null;
                }
                DataTable dt = new DataTable();
                dt.Load(reader);
                return dt;
            }
            catch (Exception ex)
            {
                return null;
            }
            finally
            {
                if (reader != null)
                {
                    reader.Close();
                }
                if (SqlConnection != null)
                {
                    SqlConnection.Close();
                }
            }

        }

        public List<string> GetAllRunningMatchID()
        {
            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = SECommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "SELECT F_MatchID FROM TS_Match WHERE F_MatchStatusID = 50 ORDER BY F_CourtID";
            SqlDataReader reader = null;
            try
            {
                List<string> red = new List<string>();
                reader = sqlCmd.ExecuteReader();
                while (reader.Read())
                {
                    red.Add(reader.GetInt32(0).ToString());
                }
                if (red.Count == 0)
                {
                    return null;
                }
                return red;

            }
            catch (System.Exception e)
            {
                return null;
            }
            finally
            {
                if (reader != null)
                {
                    reader.Close();
                }
            }
        }

        public string GetMatchCourtName(int matchID)
        {
            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = SECommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = string.Format("SELECT B.F_CourtShortName FROM TS_Match AS A LEFT JOIN TC_Court_Des AS B ON B.F_CourtID = A.F_CourtID AND B.F_LanguageCode = 'ENG' WHERE A.F_MatchID = {0}", matchID);
            SqlDataReader rd = null;
            try
            {
                rd = sqlCmd.ExecuteReader();
                if (rd.Read())
                {
                    return rd.GetString(0);
                }
                return "";
            }
            catch (System.Exception e)
            {
                return "";
            }
            finally
            {
                if (rd != null)
                {
                    rd.Close();
                }
            }
        }

        public string GetRscStringFromMatchID(int matchID)
        {
            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = SECommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Fun_SE_GetMatchRscCode";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
            SqlParameter param = sqlCmd.Parameters.Add("@returnString", SqlDbType.NVarChar, 100);
            param.Direction = ParameterDirection.ReturnValue;
            try
            {
                sqlCmd.ExecuteScalar();
                if (param.Value.GetType().Name == "DBNull")
                {
                    return "";
                }
                return param.Value.ToString();
            }
            catch (System.Exception e)
            {
                return "";
            }
        }

        public string GetMatchScoreString(int matchID)
        {
            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = SECommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Fun_SE_GetMatchResultDes";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
            sqlCmd.Parameters.Add("@Type", SqlDbType.Int).Value = 4;
            sqlCmd.Parameters.Add("@WinnerFirst", SqlDbType.Int).Value = 0;
            SqlParameter param = sqlCmd.Parameters.Add("@returnString", SqlDbType.NVarChar, 100);
            param.Direction = ParameterDirection.ReturnValue;
            try
            {
                sqlCmd.ExecuteScalar();
                if (param.Value.GetType().Name == "DBNull")
                {
                    return "";
                }
                return param.Value.ToString();
            }
            catch (System.Exception e)
            {
                return "";
            }
        }

        public int GetMatchIDFromRSC(string matchRsc)
        {
            if (matchRsc.Length != 9)
            {
                return -2;
            }
            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = SECommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Fun_BDTT_GetMatchIDFromRsc";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.Add("@MatchRsc", SqlDbType.NVarChar).Value = matchRsc;
            SqlParameter param = sqlCmd.Parameters.Add("@returnInt", SqlDbType.Int);
            param.Direction = ParameterDirection.ReturnValue;
            try
            {
                sqlCmd.ExecuteScalar();
                if (param.Value.GetType().Name == "DBNull")
                {
                    return -3;
                }
                return Convert.ToInt32(param.Value);
            }
            catch (System.Exception e)
            {
                return -1;
            }
        }


        public string GetMatchRuleName(int matchID)
        {
            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = SECommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "SELECT F_CompetitionLongName FROM TS_Match AS A"
                            + " LEFT JOIN TD_CompetitionRule_Des AS B ON B.F_CompetitionRuleID = A.F_CompetitionRuleID AND B.F_LanguageCode = \'ENG\'"
                            + string.Format(" WHERE A.F_MatchID = {0}", matchID);
            try
            {
                object ret = sqlCmd.ExecuteScalar();
                if (ret == null)
                {
                    return "NONE";
                }
                else
                {
                    return (string)ret;
                }
            }
            catch (System.Exception e)
            {
                return "Exception";
            }
        }
    }
}
