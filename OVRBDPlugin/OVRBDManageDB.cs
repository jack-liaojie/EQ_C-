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

namespace AutoSports.OVRBDPlugin
{
    public class OVRBDManageDB
    {
        private Int32 m_iSportID;
        private Int32 m_iDisciplineID;
        private String m_strLanguage;

        public OVRBDManageDB()
        {
            m_iSportID = -1;
            m_iDisciplineID = -1;
            m_strLanguage = "ENG";
        }

        // Init Data
        public bool InitDiscipline()
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            OVRDataBaseUtils.GetActiveInfo(BDCommon.g_adoDataBase.m_dbConnect, out m_iSportID, out m_iDisciplineID, out m_strLanguage);
            m_iDisciplineID = GetDisplnID(BDCommon.g_strDisplnCode);
            return true;
        }

        // Database Exchange
        public Int32 GetDisplnID(String strDisplnCode)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            Int32 iDisciplineID = 0;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for DisciplineID

                String strSql;
                strSql = String.Format("SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode= '{0}'", strDisplnCode);
                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.DBConnect);
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
                BDCommon.Writelog("GetDisplnID()异常", e.Message);
                if (dr != null) dr.Close();
            }

            return iDisciplineID;
        }

        public Int32 GetPhaseID(int iMatchID)
        {
            SqlConnection SqlConnection = new SqlConnection(BDCommon.g_adoDataBase.m_strConnection);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            Int32 iPhaseID = 0;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strSql;
                strSql = String.Format("SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = {0}", iMatchID);
                SqlCommand cmd = new SqlCommand(strSql, SqlConnection);
                dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    iPhaseID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_PhaseID");
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("GetPhaseID()异常", e.Message);
                if (dr != null) dr.Close();
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }

            return iPhaseID;
        }

        public int GetMatchType(int nMatchID)
        {
            String strSQL = @"SELECT F_MatchTypeID, F_MatchStatusID FROM TS_Match WHERE F_MatchID=" + nMatchID.ToString();

            return (int)BDCommon.g_adoDataBase.ExecuteScalar(strSQL);
        }

        public Int32 GetMatchRuleID(Int32 nMatchID)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            Int32 nRuleID = -1;
            SqlDataReader dr = null;
            try
            {
                String strFmt = @"SELECT b.F_CompetitionRuleID
                FROM TS_Match AS a LEFT JOIN TD_CompetitionRule AS b 
                ON a.F_CompetitionRuleID = b.F_CompetitionRuleID WHERE a.F_MatchID = {0:D} AND b.F_DisciplineID = {1:D}";

                String strSql = String.Format(strFmt, nMatchID, GetDisplnID(BDCommon.g_strDisplnCode));
                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.DBConnect);
                dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    nRuleID = dr.GetInt32(0);
                }

                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("GetMatchRuleID()异常", e.Message);
                if (dr != null) dr.Close();
            }

            return nRuleID;
        }

        public int GetSexCodeByMatchID(int iMatchID)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = string.Format(@"SELECT F_SexCode from TS_Event AS A, TS_Phase AS B, TS_Match AS C WHERE C.F_MatchID = {0} AND C.F_PhaseID = B.F_PhaseID AND B.F_EventID = A.F_EventID", iMatchID);
            SqlDataReader dr = null;
            int sexCode = 0;
            try
            {
                dr = sqlCmd.ExecuteReader();
                if (dr.Read())
                {
                    sexCode = dr.GetInt32(0);
                }
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("GetSexCodeByMatchID()异常", e.Message);
                return 0;
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
            return sexCode;
        }

        public bool GetMatchRule(Int32 nMatchID, out Int32 nMatchType, out String strTeamSubMatchTypes, out Int32 nSplitsCount, out Int32 nGamesCount,
            out Int32 nGamePoint, out Int32 nMaxGameScore, out Int32 nAdvantageDiffer,
            out bool bScoredOwnServe, out bool bNeedAllGamesCompleted, out bool bNeedAllSplitsCompleted)
        {
            nMatchType = -1;
            nGamesCount = -1;
            nSplitsCount = -1;
            nGamePoint = -1;
            nMaxGameScore = 0;
            nAdvantageDiffer = 0;
            bScoredOwnServe = false;
            bNeedAllGamesCompleted = false;
            bNeedAllSplitsCompleted = false;
            strTeamSubMatchTypes = "";

            Int32 nMatchRuleID = GetMatchRuleID(nMatchID);
            if (nMatchRuleID <= 0)
                return false;

            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            Boolean bMatchRule = false;
            SqlDataReader dr = null;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strFmt = @"
                                SELECT 
	                                F_CompetitionRuleInfo.value('(/Rule/@F_Type)[1]', 'Int')					AS F_Type,
                                    F_CompetitionRuleInfo.value('(/Rule/@F_TeamSubMatchTypes)[1]', 'Int')        AS F_TeamSubMatchTypes,
	                                F_CompetitionRuleInfo.value('(/Rule/@F_SplitsCount)[1]', 'Int')				AS F_SplitsCount,
	                                F_CompetitionRuleInfo.value('(/Rule/@F_GamesCount)[1]', 'Int')				AS F_GamesCount,
	                                F_CompetitionRuleInfo.value('(/Rule/@F_GamePoint)[1]', 'Int')				AS F_GamePoint,
	                                F_CompetitionRuleInfo.value('(/Rule/@F_AdvantageDiffer)[1]', 'Int')			AS F_AdvantageDiffer,
	                                F_CompetitionRuleInfo.value('(/Rule/@F_MaxGameScore)[1]', 'Int')			AS F_MaxGameScore,
	                                F_CompetitionRuleInfo.value('(/Rule/@F_ScoredOwnServe)[1]', 'Int')		    AS F_ScoredOwnServe,
	                                F_CompetitionRuleInfo.value('(/Rule/@F_NeedAllSplitsCompleted)[1]', 'Int')	AS F_NeedAllSplitsCompleted,
	                                F_CompetitionRuleInfo.value('(/Rule/@F_NeedAllGamesCompleted)[1]', 'Int')	AS F_NeedAllGamesCompleted
                                FROM TD_CompetitionRule
                                WHERE F_CompetitionRuleID = {0:D} AND F_DisciplineID={1:D}";

                String strSql = String.Format(strFmt, nMatchRuleID, m_iDisciplineID);
                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.DBConnect);
                dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    nMatchType = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_Type");
                    strTeamSubMatchTypes = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_TeamSubMatchTypes");
                    nGamesCount = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_GamesCount");
                    nSplitsCount = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_SplitsCount");
                    nGamePoint = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_GamePoint");
                    nMaxGameScore = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MaxGameScore");
                    nAdvantageDiffer = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_AdvantageDiffer");

                    Int32 nScoredOwnServe = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ScoredOwnServe");
                    Int32 nNeedAllGamesCompleted = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_NeedAllGamesCompleted");
                    Int32 nNeedAllSplitsCompleted = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_NeedAllSplitsCompleted");

                    bScoredOwnServe = nScoredOwnServe == 0 ? false : true;
                    bNeedAllGamesCompleted = nNeedAllGamesCompleted == 0 ? false : true;
                    bNeedAllSplitsCompleted = nNeedAllSplitsCompleted == 0 ? false : true;

                    bMatchRule = true;
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("GetMatchRule()异常", e.Message);
                if (dr != null) dr.Close();
            }

            return bMatchRule;
        }

        public bool GetPlayerInfo(Int32 nRegID, out String strName, out String strNOC)
        {
            strName = "";
            strNOC = "";

            String strFmt = @"SELECT B.F_LongName, C.F_DelegationCode FROM TR_Register AS A 
						LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID
                        LEFT JOIN TC_Delegation AS C ON A.F_DelegationID = C.F_DelegationID
                        WHERE A.F_RegisterID = {0:D} AND B.F_LanguageCode='{1}'";
            String strSql = String.Format(strFmt, nRegID, m_strLanguage);
            STableRecordSet stRecords;

            try
            {
                if (!BDCommon.g_adoDataBase.ExecuteSql(strSql, out stRecords)) return false;

                if (stRecords.GetRecordCount() != 1)
                    return false;

                strName = stRecords.GetFieldValue(0, "F_LongName");
                strNOC = stRecords.GetFieldValue(0, "F_DelegationCode");
            }
            catch (System.Exception errorSql)
            {
                MessageBoxEx.Show(errorSql.ToString());
                BDCommon.Writelog("GetPlayerInfo()异常", errorSql.Message);
                return false;
            }

            return true;
        }

        public string GetRegisterName(Int32 nRegID)
        {
            String strFmt = @"SELECT B.F_LongName FROM TR_Register AS A 
						LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID
                        WHERE A.F_RegisterID = {0:D} AND B.F_LanguageCode='{1}'";
            String strSql = String.Format(strFmt, nRegID, m_strLanguage);

            try
            {
                return BDCommon.g_adoDataBase.ExecuteScalar(strSql).ToString();
            }
            catch (System.Exception errorSql)
            {
                MessageBoxEx.Show(errorSql.ToString());
                BDCommon.Writelog("GetRegisterName()异常", errorSql.Message);
                return "";
            }
        }

        public bool GetMatchMember(Int32 nMatchID, out Int32 nRegAID, out Int32 nRegBID)
        {
            nRegAID = 0;
            nRegBID = 0;

            String strFmt = @"SELECT F_RegisterID, F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = {0:D} ORDER BY F_CompetitionPositionDes1, F_CompetitionPosition";
            String strSql = String.Format(strFmt, nMatchID);
            STableRecordSet stRecords;

            try
            {
                if (!BDCommon.g_adoDataBase.ExecuteSql(strSql, out stRecords)) return false;

                if (stRecords.GetRecordCount() != 2)
                    return false;

                nRegAID = stRecords.GetFieldValue(0, "F_RegisterID") == String.Empty ? 0 : Convert.ToInt32(stRecords.GetFieldValue(0, "F_RegisterID"));
                nRegBID = stRecords.GetFieldValue(1, "F_RegisterID") == String.Empty ? 0 : Convert.ToInt32(stRecords.GetFieldValue(1, "F_RegisterID"));
            }
            catch (System.Exception errorSql)
            {
                MessageBoxEx.Show(errorSql.ToString());
                BDCommon.Writelog("GetMatchMember()异常", errorSql.Message);
                return false;
            }

            return true;
        }

        public Int32 CreateMatchSplit(Int32 nMatchID, Int32 nMatchType, Int32 nGamesCount, Int32 nTeamSplitCount)
        {
            String strStoreProcName;

            ArrayList paramCollection = new ArrayList();
            if (nMatchType == BDCommon.MATCH_TYPE_TEAM)
            {
                strStoreProcName = "proc_CreateMatchSplits_2_Level";

                paramCollection.Add(new SqlParameter("@MatchID", nMatchID));
                paramCollection.Add(new SqlParameter("@MatchType", nMatchType));
                paramCollection.Add(new SqlParameter("@Level_1_SplitNum", nTeamSplitCount));
                paramCollection.Add(new SqlParameter("@Level_2_SplitNum", nGamesCount));

                paramCollection.Add(new SqlParameter("@CreateType", 1)); // @CreateType = 1 : Create Delete Old and Create New Splits
                paramCollection.Add(new SqlParameter("@Result", -1));
                ((SqlParameter)paramCollection[5]).Direction = ParameterDirection.Output;
            }
            else
            {
                strStoreProcName = "proc_CreateMatchSplits_1_Level";

                paramCollection.Add(new SqlParameter("@MatchID", nMatchID));
                paramCollection.Add(new SqlParameter("@MatchType", nMatchType));
                paramCollection.Add(new SqlParameter("@Level_1_SplitNum", nGamesCount));

                paramCollection.Add(new SqlParameter("@CreateType", 1)); // @CreateType = 1 : Create Delete Old and Create New Splits
                paramCollection.Add(new SqlParameter("@Result", -1));
                ((SqlParameter)paramCollection[4]).Direction = ParameterDirection.Output;
            }

            SqlParameter[] aryParams = new SqlParameter[paramCollection.Count];
            paramCollection.CopyTo(aryParams, 0);

            Int32 nRetValue = 0;
            try
            {
                BDCommon.g_adoDataBase.ExecuteProcNoQuery(strStoreProcName, ref aryParams);
                nRetValue = (Int32)aryParams[aryParams.Length - 1].Value;
            }
            catch (System.Exception errorProc)
            {
                MessageBoxEx.Show(errorProc.ToString());
                BDCommon.Writelog("CreateMatchSplit()异常", errorProc.Message);
                return -1;
            }

            return nRetValue;
        }

        public Int32 CreateDoublePair(Int32 nRegAID, Int32 nRegBID) // nRegAID and nRegBID must be valid
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
                BDCommon.g_adoDataBase.m_dbConnect.Open();

            try
            {
                SqlCommand cmd = new SqlCommand("[Proc_BDTT_CreateTeamDouble]", BDCommon.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@RegisterIDA", nRegAID);
                cmdParameter1.Size = 4;
                SqlParameter cmdParameter2 = new SqlParameter("@RegisterIDB", nRegBID);
                cmdParameter2.Size = 4;
                SqlParameter cmdParameter3 = new SqlParameter("@LanguageCode", m_strLanguage);
                cmdParameter3.Size = 4;

                SqlParameter cmdParameter4 = new SqlParameter("@DoubleLongName", "");
                cmdParameter4.Size = 50;
                cmdParameter4.Direction = ParameterDirection.Output;

                SqlParameter cmdParameterResult = new SqlParameter("@Result", null);
                cmdParameterResult.Size = 4;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameterResult);

                cmd.ExecuteNonQuery();

                Int32 nRetValue = BDCommon.Str2Int(cmdParameterResult.Value);

                if (nRetValue >= 1)
                {
                    return nRetValue;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("CreateDoublePair()异常", e.Message);
            }

            return -1;
        }

        public Int32 CreateDoublePair(string pairCode, string nRegACode, string nRegBCode) // nRegAID and nRegBID must be valid
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
                BDCommon.g_adoDataBase.m_dbConnect.Open();

            try
            {
                SqlCommand cmd = new SqlCommand("[proc_TT_CreateCrossDouble]", BDCommon.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@CrossPairCode", SqlDbType.NVarChar, 20).Value = pairCode;
                cmd.Parameters.Add("@RegisterCodeA", SqlDbType.NVarChar, 20).Value = nRegACode;
                cmd.Parameters.Add("@RegisterCodeB", SqlDbType.NVarChar, 20).Value = nRegBCode;
                cmd.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 3).Value = "ENG";
                SqlParameter paramOut1 = cmd.Parameters.Add("@DoubleLongName", SqlDbType.NVarChar, 200);
                paramOut1.Direction = ParameterDirection.Output;
                SqlParameter paramOut2 = cmd.Parameters.Add("@Result", SqlDbType.Int);
                paramOut2.Direction = ParameterDirection.Output;

                cmd.ExecuteNonQuery();

                Int32 nRetValue = BDCommon.Str2Int(paramOut2.Value);

                if (nRetValue >= 1)
                {
                    return nRetValue;
                }
                else if (nRetValue == -1)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show("RegCodeA is not exists");
                }
                else if (nRetValue == -2)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show("RegCodeB is not exists");
                }
                else if (nRetValue == -3)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show("More than two RegCodeA are found!");
                }
                else if (nRetValue == -4)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show("More than two RegCodeB are found!");
                }
                else if (nRetValue == -5)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show("Gender is different!");
                }
                else if (nRetValue == -6)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show("Two player are belong to different sport!");
                }

                return nRetValue;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("CreateDoublePair()异常", e.Message);
            }

            return -1;
        }

       

        public bool GetOneMatchDes(Int32 nMatchID, out Int32 nHomeID, out Int32 nAwayID, out String strHomeName, out String strAwayName,
                                    out Int32 nMatchStatus, out String strSportDes, out String strPhaseDes,
                                    out String strDateDes, out String strVeuneDes, out String strHomeScore, out String strAwayScore, out Int32 nRegAPos, out Int32 nRegBPos)
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
            strHomeScore = "";
            strAwayScore = "";
            nRegAPos = -1;
            nRegBPos = -1;
            Boolean bResult = false;

            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_GetMatchDescription", BDCommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = nMatchID;
                cmdParameter1.Value = m_strLanguage;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
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
                    strHomeScore = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_HomeScore");
                    strAwayScore = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_AwayScore");
                    nRegAPos = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_HomePos");
                    nRegBPos = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_AwayPos");

                    bResult = true;
                }

                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("GetOneMatchDes()异常", e.Message);
                bResult = false;
            }

            return bResult;
        }

        public Int32 GetMatchStatus(Int32 nMatchID)
        {
            SqlConnection SqlConnection = new SqlConnection(BDCommon.g_adoDataBase.m_strConnection);

            Int32 iStatusID = -1;
            try
            {
                #region DML Command Setup for GetPhaseID

                if (SqlConnection.State == System.Data.ConnectionState.Closed)
                {
                    SqlConnection.Open();
                }

                String strSql;
                strSql = String.Format("SELECT F_MatchStatusID FROM TS_Match WHERE F_MatchID = {0}", nMatchID);
                SqlCommand cmd = new SqlCommand(strSql, SqlConnection);
                SqlDataReader dr = cmd.ExecuteReader();

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
                BDCommon.Writelog("GetMatchStatus()异常", e.Message);
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }

            return iStatusID;
        }

        public void FillMatchResultToGridCtrl(Int32 nMatchID, Int32 nMatchSplitID, DataGridView GridCtrl)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_BD_GetMatchResult", BDCommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MatchSplitID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = nMatchID;
                cmdParameter1.Value = nMatchSplitID;
                cmdParameter2.Value = m_strLanguage;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridViewWithCmb(GridCtrl, dt, "MatchResult", "IRM");
                GridCtrl.Columns["F_CompetitionPosition"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("FillMatchResultToGridCtrl()异常", e.Message);
            }
        }

        public void InitMatchResultCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 nMatchID, Int32 nMatchSplitID, Int32 nPosition)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_BD_GetMatchResultList", BDCommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MatchSplitID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@Position", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = nMatchID;
                cmdParameter1.Value = nMatchSplitID;
                cmdParameter2.Value = nPosition;
                cmdParameter3.Value = m_strLanguage;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("InitMatchResultCombBox()异常", e.Message);
            }
        }

        public void InitIRMCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 nMatchID)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_BD_GetIRMList", BDCommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = nMatchID;
                cmdParameter1.Value = m_strLanguage;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("InitIRMCombBox()异常", e.Message);
            }
        }

        public void UpdateMatchResult(Int32 nMatchID, Int32 nMatchSplitID, Int32 nPosition, Int32 nResultID)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update BatOrder
                Int32 nRank;
                String strFmt, strSql;

                nRank = nResultID == BDCommon.RESULT_TYPE_WIN ? BDCommon.RANK_TYPE_1ST : BDCommon.RANK_TYPE_2ND;

                if (nMatchSplitID == -1)
                {
                    strFmt = @"UPDATE TS_Match_Result SET F_ResultID = (CASE WHEN {0:D} = -1 THEN NULL ELSE {0:D} END),
                            F_Rank = (CASE WHEN {1:D} = -1 THEN NULL ELSE {1:D} END) WHERE F_MatchID = {2:D} AND F_CompetitionPosition = {3:D}";

                    strSql = String.Format(strFmt, nResultID, nRank, nMatchID, nPosition);
                }
                else
                {
                    strFmt = @"UPDATE TS_Match_Split_Result SET F_ResultID = (CASE WHEN {0:D} = -1 THEN NULL ELSE {0:D} END),
                            F_Rank = (CASE WHEN {1:D} = -1 THEN NULL ELSE {1:D} END) WHERE F_MatchID = {2:D} AND F_CompetitionPosition = {3:D} AND F_MatchSplitID = {4:D}";

                    strSql = String.Format(strFmt, nResultID, nRank, nMatchID, nPosition, nMatchSplitID);
                }

                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();

                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("UpdateMatchResult()异常", e.Message);
            }
        }

        public void UpdateMatchIRM(Int32 nMatchID, Int32 nMatchSplitID, Int32 nPosition, Int32 nIRMID)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update BatOrder
                String strFmt, strSql;

                if (nMatchSplitID == -1)
                {
                    strFmt = @"UPDATE TS_Match_Result SET F_IRMID = (CASE WHEN {0:D} = -1 THEN NULL ELSE {0:D} END)
                            WHERE F_MatchID = {1:D} AND F_CompetitionPosition = {2:D}";

                    strSql = String.Format(strFmt, nIRMID, nMatchID, nPosition);
                }
                else
                {
                    strFmt = @"UPDATE TS_Match_Split_Result SET F_IRMID = (CASE WHEN {0:D} = -1 THEN NULL ELSE {0:D} END)
                            WHERE F_MatchID = {1:D} AND F_CompetitionPosition = {2:D} AND F_MatchSplitID = {3:D}";

                    strSql = String.Format(strFmt, nIRMID, nMatchID, nPosition, nMatchSplitID);
                }

                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();

                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("UpdateMatchIRM()异常", e.Message);
            }
        }

        public bool GetMatchSplitCount(Int32 nMatchID, Int32 pnMatchType, ref Int32 pnGamesCount, ref Int32 pnTeamSplitCount)// Get Match and it's split info, including the count and type
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            Boolean bResult = false;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strSql, strFmt;

                if (pnMatchType == BDCommon.MATCH_TYPE_TEAM)
                {
                    strFmt = @"SELECT 
							(SELECT COUNT(*) FROM TS_Match_Split_Info WHERE F_MatchID = {0:D} and F_FatherMatchSplitID=1) as F_GamesCount, 
							Count(F_MatchSplitID) as F_TeamSplitCount 
							FROM TS_Match_Split_Info WHERE F_FatherMatchSplitID = 0 and F_MatchID = {0:D}";
                    strSql = String.Format(strFmt, nMatchID);
                }
                else
                {
                    strFmt = @"SELECT Count(F_MatchSplitID) as F_GamesCount, 0 as F_TeamSplitCount 
				               FROM TS_Match_Split_Info WHERE F_FatherMatchSplitID = 0 and F_MatchID = {0:D}";
                    strSql = String.Format(strFmt, nMatchID);
                }

                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.DBConnect);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    pnGamesCount = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_GamesCount");
                    pnTeamSplitCount = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_TeamSplitCount");

                    if (pnGamesCount > 0)
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
                BDCommon.Writelog("GetMatchSplitCount()异常", e.Message);
            }

            return bResult;
        }

        public String GetStatusName(Int32 nStatusID)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            String strStatus = String.Empty;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strSql;
                strSql = String.Format("SELECT F_StatusLongName FROM TC_Status_Des WHERE F_StatusID = {0:D} AND F_LanguageCode='{1}'", nStatusID, m_strLanguage);
                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.DBConnect);
                SqlDataReader dr = cmd.ExecuteReader();

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
                BDCommon.Writelog("GetStatusName()异常", e.Message);
            }

            return strStatus;
        }

        public bool SetMatchResults(Int32 nMatchID, Int32 nCompetitionPos, Int32 nPoints, Int32 nRank, Int32 nResult)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"UPDATE TS_Match_Result SET F_Points = {0:D}, F_PointsCharDes1 = {0:D}, F_Rank = {1:D}, F_ResultID = {2:D} 
						WHERE F_MatchID = {3:D} AND F_CompetitionPosition = {4:D}";
                String strSql = String.Format(strFmt, nPoints, nRank, nResult, nMatchID, nCompetitionPos);

                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("SetMatchResults()异常", e.Message);
                return false;
            }

            return true;
        }

        public bool SetMatchPoints(Int32 nMatchID, Int32 nCompetitionPos, Int32 nPoints)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"UPDATE TS_Match_Result SET F_Points = {0:D}, F_PointsCharDes1 = {0:D}, F_Rank = NULL, F_ResultID = NULL 
						WHERE F_MatchID = {1:D} AND F_CompetitionPosition = {2:D}";
                String strSql = String.Format(strFmt, nPoints, nMatchID, nCompetitionPos);

                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("SetMatchPoints()异常", e.Message);
                return false;
            }

            return true;
        }

        public bool GetSubSplitInfo(Int32 nMatchID, Int32 nFatherSplitID, out STableRecordSet stRecords)
        {
            stRecords = null;
            String strFmt = @"SELECT * FROM TS_Match_Split_Info WHERE F_MatchID = {0:D} AND F_FatherMatchSplitID = {1:D} ORDER BY F_Order";
            String strSql = String.Format(strFmt, nMatchID, nFatherSplitID);

            try
            {
                if (!BDCommon.g_adoDataBase.ExecuteSql(strSql, out stRecords)) return false;
            }
            catch (System.Exception errorSql)
            {
                MessageBoxEx.Show(errorSql.ToString());
                BDCommon.Writelog("GetSubSplitInfo()异常", errorSql.Message);
                return false;
            }

            return true;
        }

        public bool GetMatchSplitInfo(Int32 nMatchID, Int32 nMatchSplitID, out STableRecordSet stRecords)
        {
            stRecords = null;
            String strFmt = @"SELECT * FROM TS_Match_Split_Info WHERE F_MatchID = {0:D} AND F_MatchSplitID = {1:D}";
            String strSql = String.Format(strFmt, nMatchID, nMatchSplitID);

            try
            {
                if (!BDCommon.g_adoDataBase.ExecuteSql(strSql, out stRecords)) return false;
            }
            catch (System.Exception errorSql)
            {
                MessageBoxEx.Show(errorSql.ToString());
                BDCommon.Writelog("GetMatchSplitInfo()异常", errorSql.Message);
                return false;
            }

            return true;
        }

        public bool GetMatchSplitStatus(Int32 nMatchID, Int32 nMatchSplitID, out STableRecordSet stRecords)
        {
            stRecords = null;
            String strFmt = @"SELECT a.F_MatchSplitStatusID, b.F_StatusLongName, a.F_MatchID, a.F_MatchSplitID 
						FROM TS_Match_Split_Info AS a, TC_Status_Des AS b 
						WHERE a.F_MatchSplitStatusID = b.F_StatusID AND a.F_MatchID = {0:D} AND a.F_MatchSplitID = {1:D} AND b.F_LanguageCode = '{2}'";
            String strSql = String.Format(strFmt, nMatchID, nMatchSplitID, m_strLanguage);

            try
            {
                if (!BDCommon.g_adoDataBase.ExecuteSql(strSql, out stRecords)) return false;
            }
            catch (System.Exception errorSql)
            {
                MessageBoxEx.Show(errorSql.ToString());
                BDCommon.Writelog("GetMatchSplitStatus()异常", errorSql.Message);
                return false;
            }

            return true;
        }

        public bool GetMatchSplitResult(Int32 nMatchID, Int32 nMatchSplitID, out STableRecordSet stRecords)
        {
            stRecords = null;
            String strFmt = @"SELECT * FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition WHERE A.F_MatchID = {0:D}
                              AND A.F_MatchSplitID = {1:D} ORDER BY B.F_CompetitionPositionDes1, A.F_CompetitionPosition";
            String strSql = String.Format(strFmt, nMatchID, nMatchSplitID);

            try
            {
                if (!BDCommon.g_adoDataBase.ExecuteSql(strSql, out stRecords)) return false;

                if (stRecords.GetRecordCount() != 2)
                    return false;
            }
            catch (System.Exception errorSql)
            {
                MessageBoxEx.Show(errorSql.ToString());
                BDCommon.Writelog("GetMatchSplitResult()异常", errorSql.Message);
                return false;
            }

            return true;
        }

        public void GetMatchTime(Int32 nMatchID, Int32 nMatchSplitID, DataGridView GridCtrl, GameCountType cntType)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_BD_GetMatchTime", BDCommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@FatherMatchSplitID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@FatherMatchSplitID",
                            DataRowVersion.Current, nMatchSplitID);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridView(GridCtrl, dt, null, null);

                try
                {
                    if (cntType != GameCountType.GameCountSeven)
                    {
                        GridCtrl.Columns["Game6"].Visible = false;
                        GridCtrl.Columns["Game7"].Visible = false;
                        if (cntType != GameCountType.GameCountFive)
                        {
                            GridCtrl.Columns["Game4"].Visible = false;
                            GridCtrl.Columns["Game5"].Visible = false;
                        }
                    }
                }
                catch (System.Exception e)
                {
                    BDCommon.Writelog("GetMatchTime内部异常", e.Message);
                }



                GridCtrl.Columns["F_Game1ID"].Visible = false;
                GridCtrl.Columns["F_Game2ID"].Visible = false;
                GridCtrl.Columns["F_Game3ID"].Visible = false;
                GridCtrl.Columns["F_Game4ID"].Visible = false;
                GridCtrl.Columns["F_Game5ID"].Visible = false;
                GridCtrl.Columns["F_Game6ID"].Visible = false;
                GridCtrl.Columns["F_Game7ID"].Visible = false;

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("GetMatchTime()异常", e.Message);
            }
        }

        public bool UpdateMatchTime(Int32 nMatchID, Int32 nSplitID, String strValue)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_BD_UpdateMatchTime", BDCommon.g_adoDataBase.m_dbConnect);
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
                BDCommon.Writelog("UpdateMatchTime()异常", e.Message);
            }

            return bResult;
        }

        public bool SetMatchSplitPointsAndResults(Int32 nMatchID, Int32 nMatchSplitID, Int32 nCompetitionPos, Int32 nPoints, Int32 nResult, Int32 nRank, bool bResultsValid)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt;
                String strSql;

                if (bResultsValid)
                {
                    strFmt = @"Update TS_Match_Split_Result SET F_Points = {0:D}, F_ResultID = {1:0}, F_Rank = {2:0}
		                WHERE F_MatchID={3:D} AND F_MatchSplitID={4:D} AND F_CompetitionPosition={5:D}";

                    strSql = String.Format(strFmt, nPoints, nResult, nRank, nMatchID, nMatchSplitID, nCompetitionPos);
                }
                else
                {
                    strFmt = @"Update TS_Match_Split_Result SET F_Points = {0:D}, F_ResultID = NULL, F_Rank = NULL
		                WHERE F_MatchID={1:D} AND F_MatchSplitID={2:D} AND F_CompetitionPosition={3:D}";

                    strSql = String.Format(strFmt, nPoints, nMatchID, nMatchSplitID, nCompetitionPos);
                }

                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("SetMatchSplitPointsAndResults()异常", e.Message);
                return false;
            }

            return true;
        }

        public bool SetMatchSplitService(Int32 nMatchID, Int32 nMatchSplitID, Int32 nCompetitionPos, bool bService)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                Int32 nService = bService ? 1 : 0;
                SqlCommand cmd = BDCommon.g_adoDataBase.m_dbConnect.CreateCommand();
                cmd.CommandText = "Proc_Report_BDTT_SetMatchSplitServe";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = nMatchID;
                cmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = nMatchSplitID;
                cmd.Parameters.Add("@Position", SqlDbType.Int).Value = nCompetitionPos;
                cmd.Parameters.Add("@Serve", SqlDbType.Int).Value = nService;
                cmd.ExecuteNonQuery();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("SetMatchSplitService()异常", e.Message);
                return false;
            }

            return true;
        }

        public bool UpdateRank(int matchID)
        {
            SqlConnection SqlConnection = new SqlConnection(BDCommon.g_adoDataBase.m_strConnection);
            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }
            SqlCommand cmd = SqlConnection.CreateCommand();
            cmd.CommandText = string.Format("UPDATE TS_Match_Result SET F_Rank = F_ResultID WHERE F_MatchID = {0}", matchID);
            try
            {
                cmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                BDCommon.Writelog("UpdateRank()异常", ex.Message);
                return false;
            }

        }

        public bool UpdateMatchRankSets(Int32 nMatchID)
        {
            SqlConnection SqlConnection = new SqlConnection(BDCommon.g_adoDataBase.m_strConnection);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_BD_UpdateMatchRankSets", SqlConnection);
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
                BDCommon.Writelog("UpdateMatchRankSets()异常", e.Message);
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }

            return bResult;
        }

        public bool CreateGroupResult(Int32 nMatchID)
        {
            //先获取PhaseID
            int phaseID = GetPhaseID(nMatchID);
            if (phaseID == 0)
            {
                return false;
            }

            SqlConnection SqlConnection = new SqlConnection(BDCommon.g_adoDataBase.m_strConnection);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = SqlConnection.CreateCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = string.Format("Proc_{0}_CreateGroupResult", BDCommon.g_strDisplnCode);

                cmd.Parameters.Add("@PhaseID", SqlDbType.Int).Value = phaseID;
                #endregion

                cmd.ExecuteNonQuery();

                bResult = true;
            }
            catch (System.Exception e)
            {
                bResult = false;
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("CreateGroupResult()异常", e.Message);
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }

            return bResult;
        }

        public bool UpdateTeamSplitMember(Int32 nMatchID, Int32 nMatchSplitID, Int32 nRegisterID, Int32 nPosition)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_BD_UpdateTeamSplitMember", BDCommon.g_adoDataBase.m_dbConnect);
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
                           "@Position", SqlDbType.Int, 4,
                           ParameterDirection.Input, false, 0, 0, "@Position",
                           DataRowVersion.Current, nPosition);

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
                BDCommon.Writelog("UpdateTeamSplitMember()异常", e.Message);
            }

            return bResult;
        }

        public void InitTeamSplitsPlayersGrid(Int32 nMatchID, DataGridView dgvPlayers)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_BD_GetTeamMatchSplitsAndPlayers", BDCommon.g_adoDataBase.m_dbConnect);
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

                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridViewWithCmb(dgvPlayers, dt, "Type", "HomeName", "AwayName");

                dgvPlayers.Columns["F_MatchSplitType"].Visible = false;
                dgvPlayers.Columns["F_MatchSplitID"].Visible = false;
                dgvPlayers.Columns["F_HomeID"].Visible = false;
                dgvPlayers.Columns["F_AwayID"].Visible = false;
                dgvPlayers.Columns["F_HomePosition"].Visible = false;
                dgvPlayers.Columns["F_AwayPosition"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("InitTeamSplitsPlayersGrid()异常", e.Message);
            }
        }

        public void InitTeamSplitsPlayersForSend(Int32 nMatchID, DataGridView dgvPlayers)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_BD_GetTeamMatchSplitsAndPlayers", BDCommon.g_adoDataBase.m_dbConnect);
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

                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridView(dgvPlayers, dt);

                dgvPlayers.Columns["F_MatchSplitType"].Visible = false;
                dgvPlayers.Columns["F_MatchSplitID"].Visible = false;
                dgvPlayers.Columns["F_HomeID"].Visible = false;
                dgvPlayers.Columns["F_AwayID"].Visible = false;
                dgvPlayers.Columns["F_HomePosition"].Visible = false;
                dgvPlayers.Columns["F_AwayPosition"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("InitTeamSplitsPlayersGrid()异常", e.Message);
            }
        }

        public void GetDoublePairMember(Int32 iPairRegID, out Int32 iMember1RegID, out Int32 iMember2RegID)
        {
            iMember1RegID = -1;
            iMember2RegID = -1;

            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
                BDCommon.g_adoDataBase.m_dbConnect.Open();

            try
            {
                string strSQL = @"
                                    SELECT TOP(2) F_MemberRegisterID, C.F_LongName FROM TR_Register_Member AS A 
                                    JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
                                    JOIN TR_Register_Des AS C ON F_MemberRegisterID = C.F_RegisterID AND C.F_LanguageCode ='{0}'
                                    WHERE F_RegTypeID = 2 AND A.F_RegisterID ={1:D} ORDER BY F_Order";

                strSQL = string.Format(strSQL, m_strLanguage, iPairRegID);

                SqlCommand cmd = new SqlCommand(strSQL, BDCommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.Text;

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    if (dr.Read())
                        iMember1RegID = dr.GetInt32(0);
                    if (dr.Read())
                        iMember2RegID = dr.GetInt32(0);
                }

                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("GetDoublePairMember()异常", e.Message);
            }
        }

        //subMatchFilter为null时不过滤TeamSubMatchType
        public void InitMatchSplitTypeDes(ref DataGridView GridCtrl, Int32 iColumnIndex, List<int> subMatchFilter = null)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_BD_GetMatchSplitTypeDes", BDCommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);

                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                if (subMatchFilter != null)
                {
                    //从后往前删除
                    for (int i = dt.Rows.Count - 1; i >= 0; i--)
                    {
                        DataRow row = dt.Rows[i];
                        if (!subMatchFilter.Contains(Convert.ToInt32(row[0])))
                        {
                            dt.Rows.RemoveAt(i);
                        }
                    }
                }

                dt.Rows.Add(-1, "NULL");

                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dt, 1, 0);

                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("InitMatchSplitTypeDes()异常", e.Message);
            }
        }

        public void InitTeamMembersListBox(ref DataGridView lstbx, Int32 iMatchID, Int32 iPosition, SexType sexTypeFilter)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_BD_GetTeamPlayers", BDCommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, iMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Position", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Position",
                             DataRowVersion.Current, iPosition);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);

                //根据sexType过滤结果
                if (sexTypeFilter != SexType.All)
                {
                    for (int i = dt.Rows.Count - 1; i >= 0; i--)
                    {
                        DataRow row = dt.Rows[i];
                        if (Convert.ToInt32(row["F_SexCode"]) != (int)sexTypeFilter)
                        {
                            dt.Rows.RemoveAt(i);
                        }
                    }
                }
                DataTable dt2 = new DataTable();
                dt2.Columns.Add("RegisterID");
                dt2.Columns.Add("Name");
                dt2.Columns.Add("SexCode");
                dt2.Columns.Add("SexName");

                //lstbx.DataSource = dt;
                //lstbx.DisplayMember = "F_RegisterName";
                foreach (DataRow row in dt.Rows)
                {
                    int st = Convert.ToInt32(row[2]);
                    string sexName = "";
                    if (st == (int)SexType.Men)
                    {
                        sexName = "Men";
                    }
                    else if (st == (int)SexType.Women)
                    {
                        sexName = "Women";
                    }
                    else
                    {
                        sexName = "Mixed";
                    }
                    dt2.Rows.Add(row[1].ToString(), row[0].ToString(), row[2].ToString(), sexName);
                }

                OVRDataBaseUtils.FillDataGridView(lstbx, dt2);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("InitTeamMembersListBox()异常", e.Message);
            }
        }

        public void InitTeamMembersCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 iMatchID, Int32 iPosition, SexType sexTypeFilter)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_BD_GetTeamPlayers", BDCommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, iMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Position", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Position",
                             DataRowVersion.Current, iPosition);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);

                //根据sexType过滤结果
                if (sexTypeFilter != SexType.All)
                {
                    for (int i = dt.Rows.Count - 1; i >= 0; i--)
                    {
                        DataRow row = dt.Rows[i];
                        if (Convert.ToInt32(row["F_SexCode"]) != (int)sexTypeFilter)
                        {
                            dt.Rows.RemoveAt(i);
                        }
                    }
                }
                dt.Rows.Add("NONE", -1, -1);//Name,RegisterID,SexCode

                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dt, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("InitTeamMembersCombBox()异常", e.Message);
            }
        }

        //Referee
        public void GetEventReferee(Int32 nMatchID, Int32 nMatchSplitID, DataGridView GridCtrl)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_BD_GetEventReferee", BDCommon.g_adoDataBase.m_dbConnect);
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
                cmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = nMatchSplitID;
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridView(GridCtrl, dt, null, null);

                GridCtrl.Columns["F_RegisterID"].Visible = false;
                GridCtrl.Columns["Delegation"].Visible = false;
                GridCtrl.Columns["F_FunctionID"].Visible = false;
                int i = 9;
                i++;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("GetEventReferee()异常", e.Message);
            }
        }

        public void GetMatchRefereeToGridCtrl(Int32 nMatchID, Int32 nMatchSplitID, DataGridView GridCtrl)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_BD_GetMatchReferee", BDCommon.g_adoDataBase.m_dbConnect);
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
                cmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = nMatchSplitID;
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();

                OVRDataBaseUtils.FillDataGridViewWithCmb(GridCtrl, dt, "Function");

                GridCtrl.Columns["F_RegisterID"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("GetMatchRefereeToGridCtrl()异常", e.Message);
            }
        }

        public void InitFunctionCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 nMatchID)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_BD_GetFunction", BDCommon.g_adoDataBase.m_dbConnect);
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

                SqlDataReader dr = cmd.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("InitFunctionCombBox()异常", e.Message);
            }
        }

        public bool UpdateMatchOfficialFunction(Int32 nMatchID, Int32 nMatchSplitID, Int32 nRegisterID, Int32 nFunctionID)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_BD_UpdateMatchOfficialFunction", BDCommon.g_adoDataBase.m_dbConnect);
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
                            "@FunctionID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@FunctionID",
                            DataRowVersion.Current, nFunctionID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);


                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = nMatchSplitID;
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
                BDCommon.Writelog("UpdateMatchOfficialFunction()异常", e.Message);
            }

            return bResult;
        }

        public void AddMatchOfficial(Int32 nMatchID, Int32 nMatchSplitID, Int32 nRegisterID, Int32 nFunctionID)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_BD_AddMatchOfficial", BDCommon.g_adoDataBase.DBConnect);
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
                            "@FunctionID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@FunctionID",
                            DataRowVersion.Current, nFunctionID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = nMatchSplitID;
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
                BDCommon.Writelog("AddMatchOfficial()异常", e.Message);
            }
        }

        public void DelMatchOfficial(Int32 nMatchID, Int32 nMatchSplitID, Int32 nRegisterID)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_BD_DelMatchOfficial", BDCommon.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = nMatchSplitID;
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("DelMatchOfficial()异常", e.Message);
            }
        }

        //技术统计


        public Int32 GetActionID(String strActionName)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            int iActionID = 0;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strFmt = @"SELECT F_ActionTypeID FROM TD_ActionType WHERE F_DisciplineID = {0:D} AND F_ActionCode = '{1}'";
                String strSql = String.Format(strFmt, GetDisplnID(BDCommon.g_strDisplnCode), strActionName);

                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.m_dbConnect);
                SqlDataReader dr = cmd.ExecuteReader();

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
                BDCommon.Writelog("GetActionID()异常", e.Message);
            }

            return iActionID;
        }

        public bool AddActionList(Int32 nPosition, Int32 nMatchID, Int32 nSplitID, Int32 nRegisterID, Int32 nActionID, Int32 nScore, Int32 nPointType)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("proc_BD_AddAction", BDCommon.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@CompetitionPosition", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@CompetitionPosition",
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
                            "@ActionScore", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@ActionScore",
                            DataRowVersion.Current, nScore);

                SqlParameter cmdParameter7 = new SqlParameter(
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
                BDCommon.Writelog("AddActionList()异常", e.Message);
            }

            return bResult;
        }

        public bool DelActionList(Int32 nPosition, Int32 nMatchID, Int32 nSplitID, Int32 nRegisterID, Int32 nActionID, Int32 nDelScore)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("proc_BD_DelAction", BDCommon.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@CompetitionPosition", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@CompetitionPosition",
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
                            "@ActionScore", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@ActionScore",
                            DataRowVersion.Current, nDelScore);

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
                BDCommon.Writelog("DelActionList()异常", e.Message);
            }

            return bResult;
        }

        public bool ClearAllMatchSplitStatus(Int32 nMatchID)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"Update TS_Match_Split_Info SET F_MatchSplitStatusID = NULL WHERE F_MatchID={0:D}";
                String strSql = String.Format(strFmt, nMatchID);

                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("ClearAllMatchSplitStatus()异常", e.Message);
                return false;
            }

            return true;
        }

        public bool SetMatchSplitStatus(Int32 nMatchID, Int32 nMatchSplitID, Int32 nSplitStatus)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BD_SetMatchSplitStatus";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = nMatchID;
            sqlCmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = nMatchSplitID;
            sqlCmd.Parameters.Add("@StatusID", SqlDbType.Int).Value = nSplitStatus;
            SqlParameter param = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
            param.Direction = ParameterDirection.Output;
            try
            {
                sqlCmd.ExecuteNonQuery();
                int res = (int)param.Value;
                if (res == 1)
                {
                    return true;
                }
                MessageBox.Show(string.Format("Proc_BD_SetMatchSplitStatus return error code:{0}", res));
                return false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("SetMatchSplitStatus()异常", e.Message);
                return false;
            }

        }

        public bool SetMatchSplitType(Int32 nMatchID, Int32 nMatchSplitID, Int32 nSplitType)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                //String strFmt = @"Update TS_Match_Split_Info SET F_MatchSplitType = {0:D} WHERE F_MatchID={1:D} AND F_MatchSplitID={2:D}";
                String strSql = String.Format(@"Update TS_Match_Split_Info SET F_MatchSplitType = {0} WHERE F_MatchID={1} AND F_MatchSplitID={2}",
                    nSplitType == -1?"NULL":nSplitType.ToString(), nMatchID, nMatchSplitID);

                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("SetMatchSplitType()异常", e.Message);
                return false;
            }

            return true;
        }

        public bool SetMatchSplitTechOrder(int matchID, int splitID, string techOrderDes)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            techOrderDes = techOrderDes.Replace("\'", "\'\'");
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = String.Format(@"Update TS_Match_Split_Info SET F_MatchSplitCode = '{0}' WHERE F_MatchID={1} AND F_MatchSplitID={2}",
                     techOrderDes, matchID, splitID);

            try
            {
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("SetMatchSplitTechOrder异常", ex.Message);
                return false;
            }
        }

        public void GetRegusList(Int32 nMatchID, ComboBox cmbRegus)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get Regus List
                SqlCommand cmd = new SqlCommand("Proc_BD_GetRegusList", BDCommon.g_adoDataBase.m_dbConnect);
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

                SqlDataReader dr = cmd.ExecuteReader();
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
                BDCommon.Writelog("GetRegusList()异常", e.Message);
            }
        }

        public bool UpdateMatchScore(Int32 nMatchID, Int32 nMatchSplitID, Int32 nPosition, Int32 nPoints)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt, strSql;

                if (nMatchSplitID == -1)
                {
                    //strFmt = @"UPDATE TS_Match_Result SET F_Points = {0:D}, F_PointsCharDes1 = {0:D} WHERE F_MatchID = {1:D} AND F_CompetitionPosition = {2:D}";

                    //strSql = String.Format(strFmt, nPoints, nMatchID, nPosition);
                    strSql = string.Format("UPDATE TS_Match_Result SET F_Points = {0}, F_PointsCharDes1 = {0} WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}",
                        (nPoints < 0 ? (object)"NULL" : (object)nPoints), nMatchID, nPosition);
                }
                else
                {
                    //strFmt = @"UPDATE TS_Match_Split_Result SET F_Points = {0:D} WHERE F_MatchID = {1:D} AND F_CompetitionPosition = {2:D} AND F_MatchSplitID = {3:D}";

                    //strSql = String.Format(strFmt, nPoints, nMatchID, nPosition, nMatchSplitID);
                    strSql = string.Format("UPDATE TS_Match_Split_Result SET F_Points = {0} WHERE F_MatchID = {1} AND F_CompetitionPosition = {2} AND F_MatchSplitID = {3}",
                               (nPoints < 0 ? (object)"NULL" : (object)nPoints), nMatchID, nPosition, nMatchSplitID);
                }

                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("UpdateMatchScore()异常", e.Message);
                return false;
            }

            return true;
        }

        public bool UpdateGameScore(int nMatchID, int nMatchSplitID, int nPosition, int nPoints)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }
            try
            {
                String strSql;
                strSql = string.Format("UPDATE TS_Match_Split_Result SET F_Points = {0} WHERE F_MatchID = {1} AND F_CompetitionPosition = {2} AND F_MatchSplitID = {3}",
                               (nPoints < 0 ? (object)"NULL" : (object)nPoints), nMatchID, nPosition, nMatchSplitID);


                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                BDCommon.Writelog("UpdateGameScore()异常", e.Message);
                return false;
            }

            return true;
        }

        public bool GetMatchScore(Int32 nMatchID, out String strHomeScore, out String strAwayScore)
        {
            strHomeScore = "";
            strAwayScore = "";

            String strFmt = @"SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = {0:D} ORDER BY F_CompetitionPositionDes1, F_CompetitionPosition";
            String strSql = String.Format(strFmt, nMatchID);
            STableRecordSet stRecords;

            try
            {
                if (!BDCommon.g_adoDataBase.ExecuteSql(strSql, out stRecords)) return false;

                if (stRecords.GetRecordCount() != 2)
                    return false;

                strHomeScore = stRecords.GetFieldValue(0, "F_Points");
                strAwayScore = stRecords.GetFieldValue(1, "F_Points");
            }
            catch (System.Exception errorSql)
            {
                MessageBoxEx.Show(errorSql.ToString());
                BDCommon.Writelog("GetMatchScore()异常", errorSql.Message);
                return false;
            }

            return true;
        }

        public bool GetTeamSplitResult(Int32 nMatchID, Int32 nTeamSplitID, out String strGameTotalA, out String strGameTotalB)
        {
            strGameTotalA = "";
            strGameTotalB = "";

            String strFmt = @"SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID
            AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition WHERE MSR.F_MatchID = {0:D} AND MSR.F_MatchSplitID = {1:D} ORDER BY MR.F_CompetitionPositionDes1, MR.F_CompetitionPosition";

            String strSql = String.Format(strFmt, nMatchID, nTeamSplitID);
            STableRecordSet stRecords;

            try
            {
                if (!BDCommon.g_adoDataBase.ExecuteSql(strSql, out stRecords)) return false;

                if (stRecords.GetRecordCount() != 2)
                    return false;

                strGameTotalA = stRecords.GetFieldValue(0, "F_Points");
                strGameTotalB = stRecords.GetFieldValue(1, "F_Points");
            }
            catch (System.Exception errorSql)
            {
                MessageBoxEx.Show(errorSql.ToString());
                BDCommon.Writelog("GetTeamSplitResult()异常", errorSql.Message);
                return false;
            }

            return true;
        }

        //导入导出信息

        public bool GetDisciplineDateList(ComboBox cmbDateList)
        {
            if (BDCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get Regus List

                String strFmt = "SELECT LEFT(CONVERT (NVARCHAR(100), F_Date, 120), 10) AS F_Date, F_DisciplineDateID FROM TS_DisciplineDate WHERE F_DisciplineID = {0:D} ORDER BY F_DateOrder";
                String strSql = String.Format(strFmt, m_iDisciplineID);

                SqlCommand cmd = new SqlCommand(strSql, BDCommon.g_adoDataBase.m_dbConnect);

                #endregion

                DataTable m_dtDate = null;
                m_dtDate = new DataTable();
                m_dtDate.Clear();

                SqlDataReader dr = cmd.ExecuteReader();
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
                BDCommon.Writelog("GetDisciplineDateList()异常", e.Message);
                return false;
            }

            return true;
        }

        public string ExportAthleteXml(String strFilePath)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                String strOutPut;
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = BDCommon.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_BD_CreateXML_AthleteList";
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

                oneSqlCommand.ExecuteNonQuery();
                strOutPut = Convert.ToString(cmdParameterResult.Value);
                return strOutPut;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                BDCommon.Writelog("ExportAthleteXml()异常", ex.Message);
                return null;
            }
        }

        public string ExportScheduleXml(String strFilePath, Int32 nDateID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                String strOutPut;
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = BDCommon.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = string.Format("Proc_{0}_CreateXML_Schedule", BDCommon.g_strDisplnCode);
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

                oneSqlCommand.ExecuteNonQuery();
                strOutPut = Convert.ToString(cmdParameterResult.Value);
                return strOutPut;
            }
            catch (Exception ex)
            {
                BDCommon.Writelog("ExportScheduleXml()异常", ex.Message);
                return null;
            }
        }

        public bool ImportMatchInfoXml(String strInputXML, out Int32 nMatchID)
        {
            SqlConnection SqlConnection = new SqlConnection(BDCommon.g_adoDataBase.m_strConnection);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            nMatchID = 0;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = SqlConnection;
                oneSqlCommand.CommandText = "proc_BD_ImportMatchInfoXML";
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
                BDCommon.Writelog("ImportMatchInfoXml()异常", ex.Message);
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }

            if (nMatchID == 0)
                return false;
            else
                return true;
        }


        public string GetXuNiOutputXml(Int32 nMatchID)
        {
            SqlConnection SqlConnection = new SqlConnection(BDCommon.g_adoDataBase.m_strConnection);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = SqlConnection;
                oneSqlCommand.CommandText = "Proc_TT_XN_GetOutputXml";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                oneSqlCommand.Parameters.Add("@MatchID", SqlDbType.Int).Value = nMatchID;
                oneSqlCommand.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 10).Value = "CHN";

                string strXml = (string)oneSqlCommand.ExecuteScalar();
                return strXml;
            }
            catch (Exception ex)
            {
                BDCommon.Writelog("GetXuNiOutputXml异常", ex.Message);
                return "";
            }
            finally
            {
                if (SqlConnection != null)
                {
                    SqlConnection.Close();
                }
            }
        }

        public string GetDBVersionDate()
        {
            SqlConnection SqlConnection = new SqlConnection(BDCommon.g_adoDataBase.m_strConnection);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }
            SqlCommand sqlCmd = SqlConnection.CreateCommand();
            sqlCmd.CommandText = "SELECT CONVERT( NVARCHAR(30), F_VersionDate, 20) FROM TC_DataBaseVersion WHERE F_VersionID = (SELECT MAX(F_VersionID) FROM TC_DataBaseVersion)";
            SqlDataReader reader = null;
            try
            {
                reader = sqlCmd.ExecuteReader();
                if (reader.Read())
                {
                    string strDate = reader.GetString(0);
                    return strDate;
                }
                return "";
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("GetDBVersionDate()异常", e.Message);
                return "";
            }
            finally
            {
                if (reader != null)
                {
                    reader.Close();
                }
            }
        }

        

        //result为-1代表无轮空的比赛 result为-2所有轮空比赛未发送，-3所有轮空的比赛都已经发送, >0为已经发送了一些场次,-4为函数异常
        public List<int> GetByeMatches(int nMatchID, GetByeMatchType getByeType, out int result)
        {
            SqlConnection SqlConnection = new SqlConnection(BDCommon.g_adoDataBase.m_strConnection);

            List<int> nMatchIDs = new List<int>();

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            try
            {
                SqlCommand oneSqlCommand = SqlConnection.CreateCommand();
                oneSqlCommand.CommandText = "Proc_info_BD_GetByeMatchesIDs";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                oneSqlCommand.Parameters.Add("@MatchID", SqlDbType.Int).Value = nMatchID;
                oneSqlCommand.Parameters.Add("@Type", SqlDbType.Int).Value = (int)getByeType;
                SqlParameter param = oneSqlCommand.Parameters.Add("@Result", SqlDbType.Int);
                param.Direction = ParameterDirection.Output;


                SqlDataReader reader = oneSqlCommand.ExecuteReader();

                while (reader.Read())
                {
                    nMatchIDs.Add(reader.GetInt32(0));
                }
                reader.Close();
                result = (int)param.Value;
            }
            catch (Exception ex)
            {
                result = -4;
                BDCommon.Writelog("GetByeMatches()异常", ex.Message);
                return null;
            }
            finally
            {
                if (SqlConnection != null)
                {
                    SqlConnection.Close();
                }
            }
            if (nMatchIDs.Count == 0)
            {
                return null;
            }
            return nMatchIDs;

        }

        public bool SetByeMatchSentFlag(int nMatchID)
        {
            SqlConnection SqlConnection = new SqlConnection(BDCommon.g_adoDataBase.m_strConnection);
            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }
            SqlCommand sqlCmd = SqlConnection.CreateCommand();
            sqlCmd.CommandText = string.Format("UPDATE TS_Match SET F_MatchComment1 = 'Y' WHERE F_MatchID = {0}", nMatchID);
            try
            {
                sqlCmd.ExecuteNonQuery();
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("SetByeMatchSentFlag()异常", e.Message);
                return false;
            }
            return true;
        }

        public int IsDoubleMatch(int matchID, int matchSplitID = -1)
        {
            //SqlConnection SqlConnection = new SqlConnection(BDCommon.g_adoDataBase.m_strConnection);
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BD_IfMatchDouble";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = matchSplitID;
                SqlParameter param = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                param.Direction = ParameterDirection.Output;
                sqlCmd.ExecuteNonQuery();
                int res = (int)param.Value;
                return res;
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("IsDoubleMatch()异常", ex.Message);
                return -1;
            }
        }

        public bool IsTeamMatch(int matchID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = string.Format("SELECT A.F_PlayerRegTypeID FROM TS_Event AS A LEFT JOIN TS_Phase AS B ON B.F_EventID = A.F_EventID LEFT JOIN TS_Match AS C ON C.F_PhaseID = B.F_PhaseID WHERE F_MatchID = {0}", matchID);
            SqlDataReader dr = null;
            try
            {
                dr = sqlCmd.ExecuteReader();
                if (dr.Read())
                {
                    int type = dr.GetInt32(0);
                    if (type == 3)
                    {
                        return true;
                    }
                    return false;
                }
                else
                {
                    return false;
                }
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("IsTeamMatch异常", ex.Message);
                return false;
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public bool GetDoubleMatchPlayerIDs(int matchID, ref List<int> ids, int matchSplitID = -1)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BD_GetDoublePlayerID4p";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
            sqlCmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = matchSplitID;
            ids.Clear();
            SqlDataReader dr = null;
            try
            {
                dr = sqlCmd.ExecuteReader();
                if (dr.Read())
                {
                    ids.Add(dr.GetInt32(0));
                    ids.Add(dr.GetInt32(1));
                    ids.Add(dr.GetInt32(2));
                    ids.Add(dr.GetInt32(3));
                }
                else
                {
                    return false;
                }
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("GetDoubleMatchPlayerIDs异常", ex.Message);
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

        public bool InitDoubleAcitonList(int matchID, int matchSplitID, int composition, int regA1, int regA2)
        {

            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BD_InitDoubleMatchActionList";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = matchSplitID;
                sqlCmd.Parameters.Add("@Composition", SqlDbType.Int).Value = composition;
                sqlCmd.Parameters.Add("@RegisterIDA1", SqlDbType.Int).Value = regA1;
                sqlCmd.Parameters.Add("@RegisterIDB1", SqlDbType.Int).Value = regA2;
                SqlParameter param = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                param.Direction = ParameterDirection.Output;
                sqlCmd.ExecuteNonQuery();

                if ((int)param.Value == 1)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("InitDoubleAcitonList异常", ex.Message);
                return false;
            }
        }

        public bool AddDoubleActionList(int compostion, int matchID, int matchSplitID, int regA1, int regA2, int regB1, int regB2, int nScore)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BD_AddDoubleActionList";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            try
            {
                sqlCmd.Parameters.Add("@CompetitionPosition", SqlDbType.Int).Value = compostion;
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = matchSplitID;
                sqlCmd.Parameters.Add("@RegisterIDA1", SqlDbType.Int).Value = regA1;
                sqlCmd.Parameters.Add("@RegisterIDA2", SqlDbType.Int).Value = regA2;
                sqlCmd.Parameters.Add("@RegisterIDB1", SqlDbType.Int).Value = regB1;
                sqlCmd.Parameters.Add("@RegisterIDB2", SqlDbType.Int).Value = regB2;
                sqlCmd.Parameters.Add("@ActionScore", SqlDbType.Int).Value = nScore;

                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("AddDoubleActionListt异常", ex.Message);
                return false;
            }
        }

        public int GetDoubleLastActionPos(int matchID, int matchSplitID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = string.Format("SELECT TOP 1 F_CompetitionPosition FROM TS_Match_ActionList WHERE F_MatchID = {0} AND F_MatchSplitID = {1} ORDER BY F_ActionOrder DESC", matchID, matchSplitID);
            SqlDataReader sr = null;
            try
            {
                sr = sqlCmd.ExecuteReader();
                if (sr.Read())
                {
                    return sr.GetInt32(0);
                }
                else
                {
                    return -1;
                }
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("GetDoubleLastActionPos异常", ex.Message);
                return -1;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }

        public bool UpdateAllSplitStatus(int matchID, int status)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BD_UpdateAllSplitStatus";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
            sqlCmd.Parameters.Add("@StatusID", SqlDbType.Int).Value = status;
            try
            {
                sqlCmd.ExecuteNonQuery();
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("UpdateAllSplitStatue异常", ex.Message);
                return false;
            }

            return true;
        }

        public string GetMatchCourtName(int matchID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
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
                BDCommon.Writelog("UpdateAllSplitStatue异常", e.Message);
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

        public bool IsTeamPlayersAllSetted(int matchID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "SELECT COUNT(B.F_MatchID) FROM TS_Match_Split_Info AS A "
                             + "LEFT JOIN TS_Match_Split_Result AS B ON B.F_MatchID = A.F_MatchID AND B.F_MatchSplitID = A.F_MatchSplitID "
                             + string.Format("WHERE A.F_MatchID = {0} AND A.F_FatherMatchSplitID = 0 AND B.F_RegisterID IS NULL", matchID);
            SqlDataReader rd = null;
            int count = 0;
            try
            {
                rd = sqlCmd.ExecuteReader();
                if (rd.Read())
                {
                    count = rd.GetInt32(0);
                }
                if (count != 0)
                {
                    return false;
                }
                return true;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("IsTeamPlayersAllSetted异常", e.Message);
                return false;
            }
            finally
            {
                if (rd != null)
                {
                    rd.Close();
                }
            }
        }

        public bool SetCurrentSplitFlag(int matchID, int matchSplitID, int flag)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BD_SetCurrentSplitIndicator";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
            sqlCmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = matchSplitID;
            sqlCmd.Parameters.Add("@Flag", SqlDbType.Int).Value = flag;
            SqlParameter param = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
            param.Direction = ParameterDirection.Output;
            try
            {
                sqlCmd.ExecuteNonQuery();
                int res = (int)param.Value;
                if (res == 1)
                {
                    return true;
                }
                return false;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog(string.Format("Proc_BD_SetCurrentSplitIndicator异常:{0}", param.Value), e.Message);
                return false;
            }
        }

        public DataTable GetMatchInfoFromRscXml(string xml)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BDTT_GetMatchInfoFromRSC";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.Add("@AllMatchRsc", SqlDbType.NVarChar, 2000 * 100).Value = xml;
            SqlDataReader rd = null;
            try
            {
                rd = sqlCmd.ExecuteReader();
                //while ( rd.Read() )
                //{
                //    MessageBox.Show(rd.GetString(0));
                //}
                DataTable dt = new DataTable();
                dt.Load(rd);
                if (dt.Rows.Count == 0)
                {
                    return null;
                }
                return dt;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("Proc_BDTT_GetMatchInfoFromRSC异常", e.Message);
                return null;
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
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Fun_BDTT_GetMatchRscCode";
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
                BDCommon.Writelog("Proc_BDTT_GetMatchInfoFromRSC异常", e.Message);
                return "";
            }
        }

        public int GetMatchIDFromRSC(string matchRsc)
        {
            if (matchRsc.Length != 9)
            {
                return -2;
            }
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
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
                BDCommon.Writelog("Proc_BDTT_GetMatchInfoFromRSC异常", e.Message);
                return -1;
            }
        }

        public DataTable GetCrossPairInfo()
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_TT_GetCrossPairInfo";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            SqlDataReader rd = null;
            try
            {
                rd = sqlCmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(rd);
                if (dt.Rows.Count == 0)
                {
                    return null;
                }
                return dt;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("GetCrossPairInfo异常", e.Message);
                return null;
            }
            finally
            {
                if (rd != null)
                {
                    rd.Close();
                }
            }
        }

        public bool CrossPairInscription(int pairRegID,int bAdd)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_TT_CrossPairInscription";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.Add("@RegPairID", SqlDbType.Int).Value = pairRegID;
            sqlCmd.Parameters.Add("@BAdd", SqlDbType.Int).Value = bAdd;
            SqlParameter sqlParam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
            sqlParam.Direction = ParameterDirection.Output;
            try
            {
                sqlCmd.ExecuteNonQuery();
                if ( (int)sqlParam.Value == 1 )
                {
                    return true;
                }
                return false;
            }
            catch (System.Exception e)
            {
                MessageBox.Show(e.ToString());
                BDCommon.Writelog("GetCrossPairInfo异常", e.Message);
                return false;
            }
        }
        public string GetMatchRuleName(int matchID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "SELECT F_CompetitionLongName FROM TS_Match AS A"
                            +" LEFT JOIN TD_CompetitionRule_Des AS B ON B.F_CompetitionRuleID = A.F_CompetitionRuleID AND B.F_LanguageCode = \'ENG\'"
                            + string.Format(" WHERE A.F_MatchID = {0}", matchID);
            try
            {
                object ret = sqlCmd.ExecuteScalar();
                if ( ret == null )
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
                MessageBox.Show(e.ToString());
                BDCommon.Writelog("GetMatchRuleName异常", e.Message);
                return "Exception";
            }
        }

        public DataTable GetViewScore(int nMatchID)
        {
            SqlConnection SqlConnection = new SqlConnection(BDCommon.g_adoDataBase.m_strConnection);


            if (SqlConnection.State != System.Data.ConnectionState.Open)
            {
                SqlConnection.Open();
            }
            SqlDataReader reader = null;
            try
            {
                SqlCommand oneSqlCommand = SqlConnection.CreateCommand();
                oneSqlCommand.CommandText = string.Format("Proc_{0}_GetMatchViewResult",BDCommon.g_strDisplnCode);
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
                BDCommon.Writelog("GetViewScore()异常", ex.Message);
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

        public string GetMatchScoreString(int matchID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Fun_Report_BD_GetMatchResultDes";
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
                BDCommon.Writelog("GetMatchScoreString异常", e.Message);
                return "";
            }
        }

        public List<string> GetAllRunningMatchID()
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
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
                MessageBox.Show(e.ToString());
                BDCommon.Writelog("GetAllRunningMatchID异常", e.Message);
                return null;
            }
            finally
            {
                if ( reader != null )
                {
                    reader.Close();
                }
            }
        }

        public DataTable GetTeamSubEventOrder()
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BDTT_GetTeamSubEventOrder";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            SqlDataReader sr = null;
            try
            {
                sr = sqlCmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(sr);
                return dt;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("GetTeamSubEventOrder异常", e.Message);
                return null;
            }
            finally
            {
                if ( sr != null )
                {
                    sr.Close();
                }
            }
        }

        public bool SetTeamSubEventOrder(int eventID, string strInfo)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = string.Format("UPDATE TS_Event SET F_EventInfo = '{0}' WHERE F_EventID = {1}", strInfo, eventID ) ;
        
            try
            {
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("SetTeamSubEventOrder异常", e.Message);
                return false;
            }
        }

        public bool DeleteMatchActionList(int matchID, int order)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BD_DeleteMatchAction";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
            sqlCmd.Parameters.Add("@Order", SqlDbType.Int).Value = order;
            try
            {
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("DeleteMatchActionList异常", e.Message);
                return false;
            }
        }
        public DataTable ReadMatchScore(int matchID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BD_GetMatchScore";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            SqlDataReader sr = null;
            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sr = sqlCmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(sr);
                
                return dt;
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("ReadMatchScore异常", ex.Message);
                return null;
            }
            finally
            {
                if (sr != null )
                {
                    sr.Close();
                }
            }
        }

        public bool InitMatchSplitType(int matchID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BDTT_InitTeamMatchSplitType";
            sqlCmd.CommandType = CommandType.StoredProcedure;
           
            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("InitMatchSplitType异常", ex.Message);
                return false;
            }
        }

        public bool InitTeamMatchMember(int matchID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_TT_InitMatchABC";
            sqlCmd.CommandType = CommandType.StoredProcedure;

            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("InitTeamMatchMember异常", ex.Message);
                return false;
            }
        }

        public bool Test_SetMatchResult(int matchID, ScoreType scoreType, int setOrder, int gameOrder, int scoreA, int scoreB, WinnerType winType)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BDTT_TEST_SetMatchResult";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@Type", SqlDbType.Int).Value = scoreType;
                sqlCmd.Parameters.Add("@SetOrder", SqlDbType.Int).Value = setOrder;
                sqlCmd.Parameters.Add("@GameOrder", SqlDbType.Int).Value = gameOrder;
                sqlCmd.Parameters.Add("@ScoreA", SqlDbType.Int).Value = scoreA;
                sqlCmd.Parameters.Add("@ScoreB", SqlDbType.Int).Value = scoreB;
                sqlCmd.Parameters.Add("@Winner", SqlDbType.Int).Value = winType;
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("Test_SetMatchResult()异常", ex.Message);
                return false;
            }
        }

        public bool ClearMatchScore(int matchID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BDTT_TEST_ClearMatchResult";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("ClearMatchScore()异常", ex.Message);
                return false;
            }
        }

        public DataTable GetDayStatusForTesting()
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.CommandText = "Proc_BDTT_TEST_GetDayStatus";
            SqlDataReader sr = null;
            try
            {
                sr = sqlCmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(sr);
                return dt;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("GetDayStatusForTesting异常", e.Message);
                return null;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }

        public DataTable GetMatchMemberPosition(int matchID, int pos)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.CommandText = "Proc_TT_GetMatchMemberPosition";
            SqlDataReader sr = null;
            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@Pos", SqlDbType.Int).Value = pos;
                sr = sqlCmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(sr);
                return dt;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("GetMatchMemberPosition异常", e.Message);
                return null;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }

        public DataTable GetPositionList()
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.CommandText = "Proc_TT_GetPositionList";
            SqlDataReader sr = null;
            try
            {
                sr = sqlCmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(sr);
                return dt;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("GetPositionList异常", e.Message);
                return null;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }

        public bool UpdateMatchPosition(int matchID, int regID, int posID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.CommandText = "Proc_TT_UpdatePlayerPosition";
            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@RegisterID", SqlDbType.Int).Value = regID;
                sqlCmd.Parameters.Add("@PosID", SqlDbType.Int).Value = posID;
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("UpdateMatchPosition异常", e.Message);
                return false;
            }
        }


        public bool AutoSetMatchMember(int matchID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.CommandText = "Proc_TT_AutoFillPlayersForNationalGame";
            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                SqlParameter sqlParam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                sqlParam.Direction = ParameterDirection.Output;
                sqlCmd.ExecuteNonQuery();
                int res = (int)sqlParam.Value;
                if ( res == 0 )
                {
                    return false;
                }
                return true;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("AutoSetMatchMember异常", e.Message);
                return false;
            }
        }

        public bool AutoSetMatchMemberForOG(int matchID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.CommandText = "Proc_TT_AutoFillPlayersForOlympicGames";
            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                SqlParameter sqlParam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                sqlParam.Direction = ParameterDirection.Output;
                sqlCmd.ExecuteNonQuery();
                int res = (int)sqlParam.Value;
                if (res == 0)
                {   
                    return false;
                }
                return true;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("AutoSetMatchMemberForOG异常", e.Message);
                return false;
            }
        }

        public bool SetDayStatusForTest(int dayID, int statusID )
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.CommandText = "Proc_BDTT_TEST_ChangeDayStatus";
            try
            {
                sqlCmd.Parameters.Add("@DayID", SqlDbType.Int).Value = dayID;
                sqlCmd.Parameters.Add("@Status", SqlDbType.Int).Value = statusID;
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("SetDayStatusForTest异常", e.Message);
                return false;
            }
        }


        public bool SetTeamPlayersForTest(int matchID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.CommandText = "Proc_BDTT_TEST_SetTeamPlayers";
            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("SetTeamPlayersForTest异常", e.Message);
                return false;
            }
        }

        public DataTable GetToCheckErrorItems()
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.CommandText = "Proc_BD_SelfCheckError";
            SqlDataReader sr = null;
            try
            {
                sqlCmd.Parameters.Add("@TypeCode", SqlDbType.NVarChar, 30).Value = "QUERY";
                sqlCmd.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 30).Value = "ENG";
                sr = sqlCmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(sr);
                return dt;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("GetToCheckErrorItems异常", e.Message);
                return null;
            }
            finally
            {
                if ( sr != null )
                {
                    sr.Close();
                }
            }
        }

        public string GetActiveLanguageCode()
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
                sqlCmd.CommandText = "SELECT F_LanguageCode FROM TC_Language WHERE F_Active = 1";
                object obRes = sqlCmd.ExecuteScalar();
                return (string)obRes;
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("GetSelfCheckError异常", ex.Message);
                return null;
            }
        }

        public DataTable GetSelfCheckError(string typeCode, string lang)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.CommandText = "Proc_BD_SelfCheckError";
            SqlDataReader sr = null;
            try
            {
                sqlCmd.Parameters.Add("@TypeCode", SqlDbType.NVarChar, 30).Value = typeCode;
                sqlCmd.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 30).Value = lang;
                sr = sqlCmd.ExecuteReader();
                if ( !sr.HasRows )
                {
                    return null;
                }
                DataTable dt = new DataTable();
                dt.Load(sr);
                
                return dt;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("GetSelfCheckError异常", e.Message);
                return null;
            }
            finally
            {
                if ( sr != null )
                {
                    sr.Close();
                }
            }
        }

        public bool ClearMatchResult(int matchID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.CommandText = "Proc_BDTT_TEST_DeleteMatchResult";
            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("ClearMatchResult异常", e.Message);
                return false;
            }
        }

        public bool SetPhaseCompetitors(int phaseID)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = string.Format("Proc_{0}_SetPhaseCompetitors", BDCommon.g_strDisplnCode) ;
            sqlCmd.CommandType = CommandType.StoredProcedure;

            try
            {
                sqlCmd.Parameters.Add("@PhaseID", SqlDbType.Int).Value = phaseID;
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("SetPhaseCompetitors异常", ex.Message);
                return false;
            }
        }

        public int ImportTempMatchData(int matchID, int setOrder, string strXml)
        {
            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }
            SqlCommand sqlCmd = BDCommon.g_adoDataBase.DBConnect.CreateCommand();
            sqlCmd.CommandText = "Proc_BD_ImportTempMatchXML";
            sqlCmd.CommandType = CommandType.StoredProcedure;

            try
            {
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@SetOrder", SqlDbType.Int).Value = setOrder;
                sqlCmd.Parameters.Add("@MatchInfoXML", SqlDbType.NVarChar).Value = strXml;
                SqlParameter sqlParam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                sqlParam.Direction = ParameterDirection.Output;
                sqlCmd.ExecuteNonQuery();
                int res = (int)sqlParam.Value;
                return res;
            }
            catch (System.Exception ex)
            {
                BDCommon.Writelog("ImportTempMatchDate异常", ex.Message);
                return 0;
            }
        }
    }
}
