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

namespace AutoSports.OVRSQPlugin
{
    public class OVRSQManageDB
    {
        private Int32 m_iSportID;
        private Int32 m_iDisciplineID;
        private String m_strLanguage;

        public OVRSQManageDB()
        {
            m_iSportID = -1;
            m_iDisciplineID = -1;
            m_strLanguage = "ENG";
        }

        // Init Data
        public bool InitGame()
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            OVRDataBaseUtils.GetActiveInfo(SQCommon.g_adoDataBase.m_dbConnect, out m_iSportID, out m_iDisciplineID, out m_strLanguage);
            m_iDisciplineID = GetDisplnID(SQCommon.g_strDisplnCode);
            return true;
        }

        // Database Exchange
        public Int32 GetDisplnID(String strDisplnCode)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            Int32 iDisciplineID = 0;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strSQL;
                strSQL = String.Format("SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode= '{0}'", strDisplnCode);
                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.DBConnect);
                SqlDataReader dr = cmd.ExecuteReader();

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

            return iDisciplineID;
        }

        public Int32 GetPhaseID(int iMatchID)
        {
            SqlConnection sqlConnection = new SqlConnection(SQCommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            Int32 iPhaseID = 0;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strSQL;
                strSQL = String.Format("SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = {0}", iMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                SqlDataReader dr = cmd.ExecuteReader();

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
            }

            if (sqlConnection != null)
            {
                sqlConnection.Close();
            }

            return iPhaseID;
        }

        public bool GetMatchRuleID(Int32 nMatchID)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            Boolean bSetRule = false;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strFmt = @"SELECT b.F_CompetitionRuleID
                FROM TS_Match AS a LEFT JOIN TD_CompetitionRule AS b 
                ON a.F_CompetitionRuleID = b.F_CompetitionRuleID WHERE a.F_MatchID = {0:D} AND b.F_DisciplineID = {1:D}";

                String strSQL = String.Format(strFmt, nMatchID, GetDisplnID(SQCommon.g_strDisplnCode));
                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.DBConnect);
                SqlDataReader dr = cmd.ExecuteReader();

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

            return bSetRule;
        }

        public bool GetMatchRule(Int32 nMatchID, out Int32 nMatchType, out Int32 nServerType, out Int32 nSetCount, out Int32 nSplitCount, out Int32 nMaxScore, out Int32 nAdvantage, out Boolean bSetRule, out Boolean bSplitRule)
        {
            nMatchType = -1;
            nServerType = -1;
            nSetCount = -1;
            nSplitCount = -1;
            nMaxScore = 0;
            nAdvantage = 0;
            bSetRule = false;
            bSplitRule = false;

            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            Boolean bMatchRule = false;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strFmt = @"SELECT b.F_Type, b.F_Set, b.F_Game, b.F_GamePoint, b.F_ServerType, b.F_Advantage, b.F_SetRule, b.F_SplitRule
                						FROM TS_Match AS a LEFT JOIN TD_CompetitionType_SQ AS b 
                						ON a.F_CompetitionRuleID = b.F_CompetitionRuleID WHERE a.F_MatchID={0:D}";

                String strSQL = String.Format(strFmt, nMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.DBConnect);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    nMatchType = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_Type");
                    nServerType = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ServerType");
                    nSetCount = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_Game");
                    nSplitCount = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_Set");
                    nMaxScore = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_GamePoint");
                    nAdvantage = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_Advantage");

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
            String strSQL = String.Format(strFmt, nRegID, m_strLanguage);
            STableRecordSet stRecords;

            try
            {
                if (!SQCommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;

                if (stRecords.GetRecordCount() != 1)
                    return false;

                strName = stRecords.GetFieldValue(0, "F_LongName");
                strNOC = stRecords.GetFieldValue(0, "F_DelegationCode");
            }
            catch (System.Exception errorSQL)
            {
                MessageBoxEx.Show(errorSQL.ToString());
                return false;
            }

            return true;
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
                if (!SQCommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;

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

        public Int32 CreateMatchSplit(Int32 nMatchID, Int32 nMatchType, Int32 nSetsCount, Int32 nTeamSplitCount)
        {
            String strStoreProcName;

            ArrayList paramCollection = new ArrayList();
            if (nMatchType == SQCommon.MATCH_TYPE_TEAM)
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
                SQCommon.g_adoDataBase.ExecuteProcNoQuery(strStoreProcName, ref aryParams);
                nRetValue = (Int32)aryParams[aryParams.Length - 1].Value;
            }
            catch (System.Exception errorProc)
            {
                MessageBoxEx.Show(errorProc.ToString());
                return -1;
            }

            return nRetValue;
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

            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_GetMatchDescription", SQCommon.g_adoDataBase.m_dbConnect);
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

            return bResult;
        }

        public Int32 GetMatchStatus(Int32 nMatchID)
        {
            SqlConnection sqlConnection = new SqlConnection(SQCommon.g_adoDataBase.m_strConnection);

            Int32 iStatusID = -1;
            try
            {
                #region DML Command Setup for GetPhaseID

                if (sqlConnection.State == System.Data.ConnectionState.Closed)
                {
                    sqlConnection.Open();
                }

                String strSQL;
                strSQL = String.Format("SELECT F_MatchStatusID FROM TS_Match WHERE F_MatchID = {0}", nMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
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
            }

            if (sqlConnection != null)
            {
                sqlConnection.Close();
            }

            return iStatusID;
        }

        public void GetMatchResult(Int32 nMatchID, Int32 nMatchSplitID, DataGridView GridCtrl)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SQ_GetMatchResult", SQCommon.g_adoDataBase.m_dbConnect);
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
            }
        }

        public void InitMatchResultCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 nMatchID, Int32 nMatchSplitID, Int32 nPosition)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SQ_GetMatchResultList", SQCommon.g_adoDataBase.m_dbConnect);
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
            }
        }

        public void InitIRMCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 nMatchID)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SQ_GetIRMList", SQCommon.g_adoDataBase.m_dbConnect);
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
            }
        }

        public void UpdateMatchResult(Int32 nMatchID, Int32 nMatchSplitID, Int32 nPosition, Int32 nResultID)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update BatOrder
                Int32 nRank;
                String strFmt, strSQL;

                nRank = nResultID == SQCommon.RESULT_TYPE_WIN ? SQCommon.RANK_TYPE_1ST : SQCommon.RANK_TYPE_2ND;

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

                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.m_dbConnect);
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
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
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

                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.m_dbConnect);
                cmd.ExecuteNonQuery();

                #endregion

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public bool GetMatchSplitCount(Int32 nMatchID, Int32 pnMatchType, ref Int32 pnSetsCount, ref Int32 pnTeamSplitCount)// Get Match and it's split info, including the count and type
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            Boolean bResult = false;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strSQL, strFmt;

                if (pnMatchType == SQCommon.MATCH_TYPE_SINGLE)
                {
                    strFmt = @"SELECT Count(F_MatchSplitID) as F_SetsCount, 0 as F_TeamSplitCount 
				               FROM TS_Match_Split_Info WHERE F_FatherMatchSplitID = 0 and F_MatchID = {0:D}";
                    strSQL = String.Format(strFmt, nMatchID);

                }
                else if (pnMatchType == SQCommon.MATCH_TYPE_TEAM)
                {
                    strFmt = @"SELECT 
							(SELECT COUNT(*) FROM TS_Match_Split_Info WHERE F_MatchID = {0:D} and F_FatherMatchSplitID=1) as F_SetsCount, 
							Count(F_MatchSplitID) as F_TeamSplitCount 
							FROM TS_Match_Split_Info WHERE F_FatherMatchSplitID = 0 and F_MatchID = {0:D}";
                    strSQL = String.Format(strFmt, nMatchID);
                }
                else return false;

                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.DBConnect);
                SqlDataReader dr = cmd.ExecuteReader();

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

            return bResult;
        }

        public String GetStatusName(Int32 nStatusID)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            String strStatus = String.Empty;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strSQL;
                strSQL = String.Format("SELECT F_StatusLongName FROM TC_Status_Des WHERE F_StatusID = {0:D} AND F_LanguageCode='{1}'", nStatusID, m_strLanguage);
                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.DBConnect);
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
            }

            return strStatus;
        }

        public bool SetMatchResult(Int32 nMatchID, Int32 nCompetitionPos, Int32 nPoints, Int32 nRank, Int32 nResult)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"UPDATE TS_Match_Result SET F_Points = {0:D}, F_PointsCharDes1 = {0:D}, F_Rank = {1:D}, F_ResultID = {2:D} 
						WHERE F_MatchID = {3:D} AND F_CompetitionPosition = {4:D}";
                String strSQL = String.Format(strFmt, nPoints, nRank, nResult, nMatchID, nCompetitionPos);

                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.m_dbConnect);
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
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"UPDATE TS_Match_Result SET F_Points = {0:D}, F_PointsCharDes1 = {0:D}, F_Rank = NULL, F_ResultID = NULL 
						WHERE F_MatchID = {1:D} AND F_CompetitionPosition = {2:D}";
                String strSQL = String.Format(strFmt, nPoints, nMatchID, nCompetitionPos);

                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.m_dbConnect);
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
                if (!SQCommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;
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
                if (!SQCommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;
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
                if (!SQCommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;
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
                if (!SQCommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;

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

        public void GetMatchTime(Int32 nMatchID, Int32 nMatchSplitID, DataGridView GridCtrl)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SQ_GetMatchTime", SQCommon.g_adoDataBase.m_dbConnect);
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

                GridCtrl.Columns["F_Game1ID"].Visible = false;
                GridCtrl.Columns["F_Game2ID"].Visible = false;
                GridCtrl.Columns["F_Game3ID"].Visible = false;
                GridCtrl.Columns["F_Game4ID"].Visible = false;
                GridCtrl.Columns["F_Game5ID"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public bool UpdateMatchTime(Int32 nMatchID, Int32 nSplitID, String strValue)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SQ_UpdateMatchTime", SQCommon.g_adoDataBase.m_dbConnect);
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

        public bool SetSplitPoints(Int32 nMatchID, Int32 nMatchSplitID, Int32 nCompetitionPos, Int32 nPoints, Int32 nResult, Int32 nRank, bool bFinish)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt;
                String strSQL;

                if (bFinish)
                {
                    strFmt = @"Update TS_Match_Split_Result SET F_Points = {0:D}, F_ResultID = {1:0}, F_Rank = {2:0}
		                WHERE F_MatchID={3:D} AND F_MatchSplitID={4:D} AND F_CompetitionPosition={5:D}";

                    strSQL = String.Format(strFmt, nPoints, nResult, nRank, nMatchID, nMatchSplitID, nCompetitionPos);
                }
                else
                {
                    strFmt = @"Update TS_Match_Split_Result SET F_Points = {0:D}, F_ResultID = NULL, F_Rank = NULL
		                WHERE F_MatchID={1:D} AND F_MatchSplitID={2:D} AND F_CompetitionPosition={3:D}";

                    strSQL = String.Format(strFmt, nPoints, nMatchID, nMatchSplitID, nCompetitionPos);
                }

                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.m_dbConnect);
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
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                Int32 nService = bService ? 1 : 0;
                String strFmt = @"Update TS_Match_Split_Result SET F_Service = {0:D} 
						WHERE F_MatchID={1:D} AND F_MatchSplitID={2:D} AND F_CompetitionPosition={3:D}";

                String strSQL = String.Format(strFmt, nService, nMatchID, nMatchSplitID, nCompetitionPos);

                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.m_dbConnect);
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
            SqlConnection sqlConnection = new SqlConnection(SQCommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SQ_UpdateMatchRankSets", sqlConnection);
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
            SqlConnection sqlConnection = new SqlConnection(SQCommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SQ_CreateGroupResult", sqlConnection);
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

        public bool UpdateTeamSplitMember(Int32 nMatchID, Int32 nMatchSplitID, Int32 nRegisterID, Int32 nPosition)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SQ_UpdateTeamSplitMember", SQCommon.g_adoDataBase.m_dbConnect);
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

        public void GetTeamSplitPlayer(Int32 nMatchID, DataGridView dgvPlayers)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SQ_GetTeamPlayersFromMatch", SQCommon.g_adoDataBase.m_dbConnect);
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

                OVRDataBaseUtils.FillDataGridViewWithCmb(dgvPlayers, dt, "HomeName", "AwayName");

                dgvPlayers.Columns["F_MatchSplitID"].Visible = false;
                dgvPlayers.Columns["F_HomeID"].Visible = false;
                dgvPlayers.Columns["F_AwayID"].Visible = false;
                dgvPlayers.Columns["F_HomePosition"].Visible = false;
                dgvPlayers.Columns["F_AwayPosition"].Visible = false;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void InitHomeNamesCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 iMatchID, Int32 iRegisterID, Int32 iPosition)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_SQ_GetTeamPlayersNotInUse", SQCommon.g_adoDataBase.m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, iMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, false, 0, 0, "@RegisterID",
                            DataRowVersion.Current, iRegisterID);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@Position", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Position",
                             DataRowVersion.Current, iPosition);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@LanguageCode", SqlDbType.NVarChar, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        //Referee
        public void GetEventReferee(Int32 nMatchID, Int32 nMatchSplitID, DataGridView GridCtrl)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get GetEventReferee
                SqlCommand cmd = new SqlCommand("Proc_SQ_GetEventReferee", SQCommon.g_adoDataBase.m_dbConnect);
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

                SqlDataReader dr = cmd.ExecuteReader();
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
        }

        public void GetMatchReferee(Int32 nMatchID, Int32 nMatchSplitID, DataGridView GridCtrl)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get GetMatchReferee
                SqlCommand cmd = new SqlCommand("Proc_SQ_GetMatchReferee", SQCommon.g_adoDataBase.m_dbConnect);
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
            }
        }

        public void InitFunctionCombBox(ref DataGridView GridCtrl, Int32 iColumnIndex, Int32 nMatchID)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for GetFunction
                SqlCommand cmd = new SqlCommand("Proc_SQ_GetFunction", SQCommon.g_adoDataBase.m_dbConnect);
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
            }
        }

        public bool UpdateMatchOfficialFunction(Int32 nMatchID, Int32 nRegisterID, Int32 nMatchSplitID, Int32 nFunctionID)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchOfficialFunction

                SqlCommand cmd = new SqlCommand("Proc_SQ_UpdateMatchOfficialFunction", SQCommon.g_adoDataBase.m_dbConnect);
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

        public void AddMatchOfficial(Int32 nMatchID, Int32 nRegisterID, Int32 nMatchSplitID)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("Proc_SQ_AddMatchOfficial", SQCommon.g_adoDataBase.DBConnect);
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

        public void DelMatchOfficial(Int32 nMatchID, Int32 nRegisterID, Int32 nMatchSplitID)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for DelMatchOfficial

                SqlCommand cmd = new SqlCommand("Proc_SQ_DelMatchOfficial", SQCommon.g_adoDataBase.DBConnect);
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

        //技术统计

        public Int32 GetActionID(String strActionName)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            int iActionID = 0;
            try
            {
                #region DML Command Setup for GetPhaseID

                String strFmt = @"SELECT F_ActionTypeID FROM TD_ActionType WHERE F_DisciplineID = {0:D} AND F_ActionCode = '{1}'";
                String strSQL = String.Format(strFmt, GetDisplnID(SQCommon.g_strDisplnCode), strActionName);

                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.m_dbConnect);
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
            }

            return iActionID;
        }

        public bool AddActionList(Int32 nPosition, Int32 nMatchID, Int32 nSplitID, Int32 nRegisterID, Int32 nActionID, Int32 nScore, Int32 nPointType)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("proc_SQ_AddAction", SQCommon.g_adoDataBase.DBConnect);
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
            }

            return bResult;
        }

        public bool DelActionList(Int32 nPosition, Int32 nMatchID, Int32 nSplitID, Int32 nRegisterID, Int32 nActionID)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            bool bResult = false;

            try
            {
                #region DML Command Setup for UpdateMatchStatus

                SqlCommand cmd = new SqlCommand("proc_SQ_DelAction", SQCommon.g_adoDataBase.DBConnect);
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

        public bool UpdateAllSplitStatus(Int32 nMatchID)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"Update TS_Match_Split_Info SET F_MatchSplitStatusID = NULL WHERE F_MatchID={0:D}";
                String strSQL = String.Format(strFmt, nMatchID);

                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.m_dbConnect);
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
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchResult
                String strFmt = @"Update TS_Match_Split_Info SET F_MatchSplitStatusID = {0:D} WHERE F_MatchID={1:D} AND F_MatchSplitID={2:D}";
                String strSQL = String.Format(strFmt, nSplitStatus, nMatchID, nSplitID);

                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.m_dbConnect);
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

        public void GetRegusList(Int32 nMatchID, ComboBox cmbRegus)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get Regus List
                SqlCommand cmd = new SqlCommand("Proc_SQ_GetRegusList", SQCommon.g_adoDataBase.m_dbConnect);
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
            }
        }

        public bool UpdateMatchScore(Int32 nMatchID, Int32 nMatchSplitID, Int32 nPosition, Int32 nPoints)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
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

                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.m_dbConnect);
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

        public bool GetContestResult(Int32 nMatchID, out String strHomeSet, out String strAwaySet)
        {
            strHomeSet = "";
            strAwaySet = "";

            String strFmt = @"SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = {0:D} ORDER BY F_CompetitionPositionDes1, F_CompetitionPosition";
            String strSQL = String.Format(strFmt, nMatchID);
            STableRecordSet stRecords;

            try
            {
                if (!SQCommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;

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

        public bool GetTeamSplitResult(Int32 nMatchID, Int32 nTeamSplitID, out String strGameTotalA, out String strGameTotalB)
        {
            strGameTotalA = "";
            strGameTotalB = "";

            String strFmt = @"SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID
            AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition WHERE MSR.F_MatchID = {0:D} AND MSR.F_MatchSplitID = {1:D} ORDER BY MR.F_CompetitionPositionDes1, MR.F_CompetitionPosition";
            
            String strSQL = String.Format(strFmt, nMatchID, nTeamSplitID);
            STableRecordSet stRecords;

            try
            {
                if (!SQCommon.g_adoDataBase.ExecuteSQL(strSQL, out stRecords)) return false;

                if (stRecords.GetRecordCount() != 2)
                    return false;

                strGameTotalA = stRecords.GetFieldValue(0, "F_Points");
                strGameTotalB = stRecords.GetFieldValue(1, "F_Points");
            }
            catch (System.Exception errorSQL)
            {
                MessageBoxEx.Show(errorSQL.ToString());
                return false;
            }

            return true;
        }

        //导入导出信息

        public bool GetDisciplineDateList(ComboBox cmbDateList)
        {
            if (SQCommon.g_adoDataBase.m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get Regus List

                String strFmt = "SELECT LEFT(CONVERT (NVARCHAR(100), F_Date, 120), 10) AS F_Date, F_DisciplineDateID FROM TS_DisciplineDate WHERE F_DisciplineID = {0:D} ORDER BY F_DateOrder";
                String strSQL = String.Format(strFmt, m_iDisciplineID);

                SqlCommand cmd = new SqlCommand(strSQL, SQCommon.g_adoDataBase.m_dbConnect);

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
                return false;
            }

            return true;
        }

        public void ExportAthleteXml(String strFilePath)
        {
            if (SQCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                String strOutPut;
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = SQCommon.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_SQ_CreateXML_AthleteList";
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
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(SQCommon.m_strSectionName, "msgExportFile"));
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void ExportScheduleXml(String strFilePath, Int32 nDateID)
        {
            if (SQCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                String strOutPut;
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = SQCommon.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_SQ_CreateXML_Schedule";
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
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(SQCommon.m_strSectionName, "msgExportFile"));
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public bool ImportMatchInfoXml(String strInputXML, out Int32 nMatchID, out Int32 nStatusID)
        {
            SqlConnection sqlConnection = new SqlConnection(SQCommon.g_adoDataBase.m_strConnection);

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
                oneSqlCommand.CommandText = "proc_SQ_ImportMatchInfoXML";
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
                oneSqlCommand.ExecuteNonQuery();

                Int32 res = Convert.ToInt32(cmdParameterResult.Value);
                if ( res > 0 )
                {
                    nMatchID = res;
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
            SqlConnection sqlConnection = new SqlConnection(SQCommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            nMatchID = 0;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = sqlConnection;
                oneSqlCommand.CommandText = "proc_SQ_ImportActionListXML";
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

                oneSqlCommand.ExecuteNonQuery();
                Int32 res = Convert.ToInt32(cmdParameterResult.Value);

                if ( res > 0 )
                {
                    nMatchID = res;
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

        public bool ImportMatchResultXML(String strInputXML, Int32 nOrder, out Int32 nMatchID)
        {
            SqlConnection sqlConnection = new SqlConnection(SQCommon.g_adoDataBase.m_strConnection);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            nMatchID = 0;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = sqlConnection;
                oneSqlCommand.CommandText = "proc_SQ_ImportMatchResultXML";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchResultXML", SqlDbType.NVarChar, 9000000,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strInputXML);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@Order", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nOrder);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);
                oneSqlCommand.ExecuteNonQuery();

                int res = Convert.ToInt32(cmdParameterResult.Value);
                if ( res > 0 )
                {
                    nMatchID = res;
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
    }
}
