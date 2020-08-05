using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AutoSports.OVRCommon;
using System.Data.SqlClient;
using System.Data;
using System.Windows.Forms;

namespace OVRDVPlugin
{
    public class OVRDVDBManager
    {
        private string m_strActiveSportID;
        private string m_strActiveDisciplineID;
        private string m_strActiveLanguage;

        public OVRDVDBManager()
        {
            m_strActiveSportID = "";
            m_strActiveDisciplineID = "";
            m_strActiveLanguage = "";
        }

        public void GetActiveSportInfo()
        {
            if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                DVCommon.g_DataBaseCon.Open();
            }

            int iSportID = 0;
            int iDisciplineID = 0;
            OVRDataBaseUtils.GetActiveInfo(DVCommon.g_DataBaseCon, out iSportID, out iDisciplineID, out m_strActiveLanguage);

            m_strActiveSportID = string.Format("{0:D}", iSportID);
            m_strActiveDisciplineID = string.Format("{0:D}", iDisciplineID);
        }

        public bool IsMatchConfiged(Int32 iMatchID)
        {
            bool bResult = false;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_IsMatchConfiged";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;
                    if (1 == iOperateResult)
                    {
                        bResult = true;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return bResult;
        }

        public bool IsMatchHasOfficial(int iMatchID)
        {
            bool bResult = false;

            try
            {
                #region DML Command Setup for GetDataEntryType

                string strSQL = string.Format("SELECT * FROM TS_Match_Servant WHERE F_MatchID = '{0}'", iMatchID);

                SqlCommand cmd = new SqlCommand(strSQL, DVCommon.g_DataBaseCon);

                SqlDataReader sdr = cmd.ExecuteReader();
                if (sdr.HasRows)
                {
                    bResult = true;
                }
                sdr.Close();
                #endregion
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return bResult;
        }

        public string GetDataEntryType(int iMatchID)
        {
            string strDataEntryType = "";
            if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                DVCommon.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for GetDataEntryType

                string strSQL = string.Format("SELECT F_MatchComment1 FROM TS_Match WHERE F_MatchID = '{0}'", iMatchID);

                SqlCommand cmd = new SqlCommand(strSQL, DVCommon.g_DataBaseCon);

                SqlDataReader sdr = cmd.ExecuteReader();
                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        strDataEntryType = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_MatchComment1");
                    }
                }
                sdr.Close();
                #endregion
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return strDataEntryType;
        }

        public void GetMatchInfo(int iMatchID, ref String strEventName, ref String strMatchName, ref String strDateDes, ref String strVenueDes, ref int iDisciplineID, ref int iStatusID, ref int iMatchRuleID)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetMatchInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strActiveLanguage);

                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    if (sdr.Read())
                    {
                        strEventName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "EventDes");
                        strMatchName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "MatchDes");
                        strDateDes = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "DateDes");
                        strVenueDes = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "VenueDes");
                        iDisciplineID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_DisciplineID");
                        iStatusID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_MatchStatusID");
                        iMatchRuleID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_CompetitionRuleID");
                    }
                }
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void GetMatchFixedDiveInfo(int iMatchID, ref String strFixedSplitsName, ref String strFixedDifficultyValue)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetMatchFixedDiveInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strActiveLanguage);

                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    if (sdr.Read())
                    {
                        strFixedSplitsName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "FixedSplitsName");
                        strFixedDifficultyValue = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "FixDifficultyValue");
                    }
                }
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void GetMatchCompetitionRuleInfo(int iMatchID, ref int iMatchRoundCount)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetMatchCompetitionRuleInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strActiveLanguage);

                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    if (sdr.Read())
                    {
                        iMatchRoundCount = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "SplitCount");
                    }
                }
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void GetMatchSplitStatus(int iMatchID, Int32 iMatchRoundCount, ref Int32[] arraySplitStatus)
        {
            arraySplitStatus = new Int32[iMatchRoundCount];
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetMatchSplitStatus";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strActiveLanguage);

                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    Int32 i = 0;

                    while (sdr.Read())
                    {
                        if (i < iMatchRoundCount)
                        {
                            arraySplitStatus[i] = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_MatchSplitStatusID");
                        }
                        i++;

                    }
                }
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }


        public void GetMatchResult(int iMatchID, int iMatchSplitID, ref DataGridView dgv)
        {
            if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                DVCommon.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchResult
                SqlCommand cmd = new SqlCommand("Proc_TE_GetMatchResult", DVCommon.g_DataBaseCon);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@MatchSplitID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = iMatchID;
                cmdParameter2.Value = iMatchSplitID;
                cmdParameter1.Value = m_strActiveLanguage;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter2);
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

        public void InitMatchResultList(int iMatchID, ref DataGridView dgv)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetMatchResult";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strActiveLanguage);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }


                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridView(dgv, sdr);
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void InitMatchSplitResultList(int iMatchID, int iMatchSplitID, ref DataGridView dgv)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetMatchSplitResult";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter3 = new SqlParameter(
                          "@MatchSplitID", SqlDbType.Int, 4,
                          ParameterDirection.Input, true, 0, 0, "",
                          DataRowVersion.Current, iMatchSplitID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter2 = new SqlParameter(
                        "@LanguageCode", SqlDbType.Char, 3,
                        ParameterDirection.Input, true, 0, 0, "",
                        DataRowVersion.Current, m_strActiveLanguage);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridView(dgv, sdr);
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void InitMatchRusultListWithFinalResult(int iMatchID, ref DataGridView dgv)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_TE_GetMatchResults";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strActiveLanguage);

                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }


                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridViewWithCmb(dgv, sdr, "");
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void InitIRMCombBox(ref DataGridView dgv, int iColumnIndex, int nMatchID)
        {
            if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                DVCommon.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for Get IRM
                SqlCommand cmd = new SqlCommand("Proc_TE_GetIRMList", DVCommon.g_DataBaseCon);
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

        public void InitMatchResultCombBox(ref DataGridView dgv, int iColumnIndex, int nMatchID, int nPosition, int iMatchsplitID)
        {
            if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                DVCommon.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_TE_GetMatchResultList", DVCommon.g_DataBaseCon);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@MatchSplitID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@Position", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = nMatchID;
                cmdParameter1.Value = nPosition;
                cmdParameter2.Value = m_strActiveLanguage;
                cmdParameter3.Value = iMatchsplitID;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter3);
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
        
        public void UpdateMatchIRM(int nMatchID, int iMatchSplitID, int nPosition, int nIRMID)
        {
            if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                DVCommon.g_DataBaseCon.Open();
            }

            String strFmt, strSQL;

            try
            {
                #region DML Command Setup for Update MatchResult

                if (iMatchSplitID == -1)
                {

                    strFmt = @"UPDATE TS_Match_Result SET F_IRMID = (CASE WHEN {0} = -1 THEN NULL ELSE {0} END)
                                WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}";

                    strSQL = String.Format(strFmt, nIRMID, nMatchID, nPosition);
                }
                else
                {
                    strFmt = @"UPDATE TS_Match_Split_Result SET F_IRMID = (CASE WHEN {0} = -1 THEN NULL ELSE {0} END)
                                WHERE F_MatchID = {1} AND F_CompetitionPosition = {2} AND F_MatchSplitID = {3}";

                    strSQL = String.Format(strFmt, nIRMID, nMatchID, nPosition, iMatchSplitID);
                }
                SqlCommand cmd = new SqlCommand(strSQL, DVCommon.g_DataBaseCon);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

        }

        public void GetMatchTypeByRule(int iMatchID, out int iFullMatch, out int iSubMathCount)
        {
            iFullMatch = 0;
            iSubMathCount = 0;
            if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                DVCommon.g_DataBaseCon.Open();
            }
            try
            {
                #region DML Command Setup for Get AvailbleMember

                SqlCommand cmd = new SqlCommand("Proc_TE_GetMatchTypeByRule", DVCommon.g_DataBaseCon);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@SubMatchCount", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@IsFullMatch", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Direction = ParameterDirection.Output;
                cmdParameter2.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                if (cmd.ExecuteNonQuery() != 0)
                {
                    iSubMathCount = (Int32)cmdParameter1.Value;
                    iFullMatch = (Int32)cmdParameter2.Value;
                }
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);

            }
        }

        public void GetCurSubMatch(int iMatchID, out int iCurSubMatch, out int iCurMatchStauts)
        {
            iCurSubMatch = 1;
            iCurMatchStauts = 0;

            if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                DVCommon.g_DataBaseCon.Open();
            }
            try
            {
                #region DML Command Setup for Get CurSubMatch

                string strSQL = string.Format("SELECT TOP 1 F_MatchSplitCode, F_MatchSplitStatusID FROM TS_Match_Split_Info WHERE F_MatchID = {0} AND F_MatchSplitType = 3 AND F_MatchSplitStatusID IN(50,110) ORDER BY CASE WHEN F_MatchSplitStatusID = 50 THEN 2 ELSE 1 END DESC, CAST( F_MatchSplitCode AS INT) DESC", iMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, DVCommon.g_DataBaseCon);

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iCurSubMatch = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, 0);
                        iCurMatchStauts = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, 1);
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

        public bool UpdateSubMatchStatus(Int32 iMatchID, Int32 iSubMatchCode, Int32 iMatchStautsID)
        {
            bool bResult = false;
            try
            {
                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }

                #region DML Command Setup for Update SubMatchStatus
                String strSQL = string.Format(@"UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = {0} WHERE F_MatchID = {1} AND F_MatchSplitCode = {2} AND F_MatchSplitType = 3",
                                        iMatchStautsID, iMatchID, iSubMatchCode);

                SqlCommand cmd = new SqlCommand(strSQL, DVCommon.g_DataBaseCon);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return bResult;
        }

        public bool UpdateSubMatchStatusForID(Int32 iMatchID, Int32 iMatchSplitID, Int32 iMatchStautsID)
        {
            bool bResult = false;
            try
            {
                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }

                #region DML Command Setup for Update SubMatchStatus
                String strSQL = string.Format(@"UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = {0} WHERE F_MatchID = {1} AND F_MatchSplitID = {2} AND F_MatchSplitType = 3",
                                        iMatchStautsID, iMatchID, iMatchSplitID);

                SqlCommand cmd = new SqlCommand(strSQL, DVCommon.g_DataBaseCon);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return bResult;
        }

        public int UpdateSubMatchStatus(int iMatchID, int iSubMatchCode)
        {
            int iStauts = 0;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_TE_UpdateSubMatchStatus";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                           "@SubMatchCode", SqlDbType.Int, 4,
                           ParameterDirection.Input, true, 0, 0, "",
                           DataRowVersion.Current, iSubMatchCode);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                          "@SubMatchStatus", SqlDbType.Int, 4,
                          ParameterDirection.Output, true, 0, 0, "",
                          DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iStauts = (Int32)cmdParameter3.Value;
                }

            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return iStauts;
        }

        public void InitMatchDiveList(Int32 iMatchID, ref DataGridView dgv)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetMatchDiveList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strActiveLanguage);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }


                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridView(dgv, sdr);
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void GetMatchDiveList(Int32 iMatchID, ref SqlDataReader sdr)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetMatchDiveList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strActiveLanguage);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }

                sdr = oneSqlCommand.ExecuteReader();

                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void InitMatchAvailableDiveSplits(Int32 iMatchID, ref DataGridView dgv)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetMatchAllDiveSplit";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strActiveLanguage);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }


                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridView(dgv, sdr);
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

        }

        public void InitMatchFixedDiveSplits(Int32 iMatchID, ref DataGridView dgv)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetMatchFixedDiveSplit";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strActiveLanguage);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }


                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridView(dgv, sdr);
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
 ;
        }

        public void InitPreviousMatchList(Int32 iMatchID, ref DataGridView dgv)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetPreviousMatchList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strActiveLanguage);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }


                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridView(dgv, sdr);
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

        }

        public bool CreateMatchDiveList(Int32 iMatchID)
        {
            if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                DVCommon.g_DataBaseCon.Open();
            }

            bool bResult = false;

            try
            {
                SqlCommand cmd = new SqlCommand("proc_DV_CreateMatchDiveList", DVCommon.g_DataBaseCon);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, iMatchID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);


                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                cmd.ExecuteNonQuery();
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;


                switch (nRetValue)
                {
                    case 1:
                        //DevComponents.DotNetBar.MessageBoxEx.Show("Create Dive list Success!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                        bResult = true;
                        break;
                    case -1:
                        DevComponents.DotNetBar.MessageBoxEx.Show("Create Dive list Failed! Invalid pramaters!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                        bResult = false;
                        break;
                    case -2:
                        DevComponents.DotNetBar.MessageBoxEx.Show("Create Dive list Failed! This match status does not allow you do this operate!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                        bResult = false;
                        break;
                    case -3:
                        DevComponents.DotNetBar.MessageBoxEx.Show("Create Dive list Failed! The Dive list has existed, you must clean dive list first!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                        bResult = false;
                        break;
                    case -4:
                        DevComponents.DotNetBar.MessageBoxEx.Show("Create Dive list Failed! You must set this match competition rule first!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                        bResult = false;
                        break;
                    default:
                        DevComponents.DotNetBar.MessageBoxEx.Show("Create Dive list Failed!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                        bResult = false;
                        break;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            return bResult;
        }

        public bool CleanMatchDiveList(Int32 iMatchID)
        {
            if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                DVCommon.g_DataBaseCon.Open();
            }

            bool bResult = false;

            try
            {
                SqlCommand cmd = new SqlCommand("proc_DV_CleanMatchDiveList", DVCommon.g_DataBaseCon);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, iMatchID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);


                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                cmd.ExecuteNonQuery();
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;

                switch (nRetValue)
                {
                    case 1:
                        //DevComponents.DotNetBar.MessageBoxEx.Show("Clean Dive list Success!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                        bResult = true;
                        break;
                    case -1:
                        DevComponents.DotNetBar.MessageBoxEx.Show("Clean Dive list Failed! Invalid pramaters!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                        bResult = false;
                        break;
                    case -2:
                        DevComponents.DotNetBar.MessageBoxEx.Show("Clean Dive list Failed! This match status does not allow you do this operate!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                        bResult = false;
                        break;
                    default:
                        DevComponents.DotNetBar.MessageBoxEx.Show("Clean Dive list Failed!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                        bResult = false;
                        break;
                }

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            return bResult;
        }

        public void IntiSingleDiveList(Int32 iMatchID, Int32 iCurCompetitionPosition, ref DataGridView dgv)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetSingleDiveList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionPosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iCurCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strActiveLanguage);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }


                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridView(dgv, sdr);
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public bool UpdateOneDive(Int32 iMatchID, Int32 iCurCompetitionPosition, Int32 iRoundID, String strDiveCode)
        {
            if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                DVCommon.g_DataBaseCon.Open();
            }

            bool bResult = false;

            try
            {
                SqlCommand cmd = new SqlCommand("proc_DV_UpdateOneDive", DVCommon.g_DataBaseCon);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, iMatchID);
               
                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionPosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iCurCompetitionPosition);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RoundID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iRoundID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@DiveCode", SqlDbType.VarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strDiveCode);

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
            }

            return bResult;
        }

        public bool UpdateOneDiveMixedDifficultyValue(Int32 iMatchID, Int32 iCurCompetitionPosition, Int32 iRoundID, String strDifficultyValue)
        {
            if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                DVCommon.g_DataBaseCon.Open();
            }

            bool bResult = false;

            try
            {
                SqlCommand cmd = new SqlCommand("proc_DV_UpdateOneDiveMixedDifficultyValue", DVCommon.g_DataBaseCon);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@MatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MatchID",
                             DataRowVersion.Current, iMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionPosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iCurCompetitionPosition);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RoundID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iRoundID);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@MixedDifficulty", SqlDbType.VarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strDifficultyValue);

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
            }

            return bResult;
        }

        public void ExcuteDV_GetMatchSplitResult_Columns(Int32 iMatchID, Int32 iMatchSplitID, String strLanguageCode, ref DataTable dataTableColumns)
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetMatchSplitResult_Columns";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@MatchSplitID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchSplitID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@LanguageCode", SqlDbType.Char, 3,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter3);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                SqlDataAdapter adapter = new SqlDataAdapter(oneSqlCommand);
                adapter.Fill(dataTableColumns);

                adapter.Dispose();
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public void ExcuteDV_GetMatchSplitCurrentStatus(Int32 iMatchID, Int32 iMatchSplitID, ref DataTable dataTableCurrentStatus)
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetMatchSplitCurrentStatus";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@MatchSplitID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchSplitID);
                oneSqlCommand.Parameters.Add(cmdParameter2);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                SqlDataAdapter adapter = new SqlDataAdapter(oneSqlCommand);
                adapter.Fill(dataTableCurrentStatus);

                adapter.Dispose();
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public void ExcuteDV_GetMatchSplitResultStatus(Int32 iMatchID, Int32 iMatchSplitID, String strLanguageCode, ref DataTable dataTablePointsStatus)
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetMatchSplitResultStatus";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@MatchSplitID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchSplitID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@LanguageCode", SqlDbType.Char, 3,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter3);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                SqlDataAdapter adapter = new SqlDataAdapter(oneSqlCommand);
                adapter.Fill(dataTablePointsStatus);

                adapter.Dispose();
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public void ExcuteDV_UpdateMatchRank(Int32 iMatchID, Int32 iCompetitionPosition, Int32 iRank)
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_UpdateMatchRank";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@CompetitionPosition", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@Rank", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iRank);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter4);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public void ExcuteDV_UpdateSplitRank(Int32 iMatchID, Int32 iCompetitionPosition, Int32 iRoundID, Int32 iRank)
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_UpdateSplitRank";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@CompetitionPosition", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@RoundID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iRoundID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                "@Rank", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iRank);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter5);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public void ExcuteDV_CalcuateMatchSplitRank(Int32 iMatchID, Int32 iMatchSplitID)
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "proc_DV_CalcuateMatchSplitRank";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@MatchSplitID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchSplitID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter3);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                    switch (iResult)
                    {
                        case 1:
                            //DevComponents.DotNetBar.MessageBoxEx.Show("Calculate Dive Rank Success!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show("Calculate Dive Rank Failed! This match status does not allow you do this operate!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show("Calculate Dive Rank Failed!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                    }
                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public void ExcuteDV_CalcuateMatchRank(Int32 iMatchID)
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_CalcuateMatchRank";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter2);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                    switch (iResult)
                    {
                        case 1:
                            //DevComponents.DotNetBar.MessageBoxEx.Show("Calculate Match Rank Success!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show("Calculate Match Rank Failed! This match status does not allow you do this operate!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show("Calculate Match Rank Failed!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                    }

                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public int ApplySelRule(int iMatchID, int iMatchRuleID)
        {
            Int32 iOperateResult = 0;
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_ApplyNewMatchRule";
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

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

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

        public Int32 UpdateMatchSplitStatus(Int32 iMatchID, Int32 iRoundID, Int32 iStatusID)
        {
            Int32 iResult = 0;
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_UpdateMatchSplitStatus";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@RoundID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iRoundID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@StatusID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iStatusID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter4);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;
                    switch (iResult)
                    {
                        case 1:
                            //DevComponents.DotNetBar.MessageBoxEx.Show("Change MatchSplit's Status Success!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show("Change MatchSplit's Status Failed! Invalid Parameters!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        case -2:
                            DevComponents.DotNetBar.MessageBoxEx.Show("Change MatchSplit's Status Failed! This match status does not allow you do this operate!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        case -3:
                            DevComponents.DotNetBar.MessageBoxEx.Show("Change MatchSplit's Status Failed! Only One MatchSplit can set running!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        case -4:
                            DevComponents.DotNetBar.MessageBoxEx.Show("Change MatchSplit's Status Failed! you must official previous MatchSplit first!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show("Calculate Match Rank Failed!", DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                    }

                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            return iResult;
        }

        public Int32 UpdateMatchIRM(Int32 iMatchID, Int32 iCompetitionPosition, String strIRMCode)
        {
            Int32 iResult = 0;
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_UpdateMatchIRM";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@CompetitionPosition", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@IRMCode", SqlDbType.VarChar, 100,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, strIRMCode);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter4);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;
                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            return iResult;
        }

        public Int32 ExcuteDV_UpdateMatchSplitCurrentDiver(Int32 iMatchID, Int32 iRoundID, Int32 iCompetitionPosition)
        {
            Int32 iResult = 0;
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_UpdateMatchSplitCurrentDiver";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@RoundID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iRoundID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@CompetitionPosition", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter4);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            return iResult;
        }

        public Int32 ExcuteDV_DeleteAllMatchResultInfo(Int32 iMatchID)
        {
            Int32 iResult = 0;
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_DeleteAllMatchResultInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter2);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            return iResult;
        }

        #region JudgePoint 相关存储过程调用

        public void ExcuteJudgePoint_CreateMatchSplits(Int32 iMatchID, Int32 iCreateType)
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_JudgePoint_CreateMatchSplits";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@CreateType", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iCreateType);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter3);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;
                }

                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public Int32 ExcuteJudgePoint_UpdatePlayerPoint(Int32 iMatchID, Int32 iMatchSplitID, Int32 iRegisterID, String strJudgeGroupCode, String strJudgeCode, String strPointCode, String strPointTypeCode, String strPoint, Int32 iPointsStatusID, Int32 iIsAutoCalcuate)
        {
            Int32 iResult;
            iResult = 0;
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_JudgePoint_UpdatePlayerPoint";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@MatchSplitID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchSplitID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@RegisterID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iRegisterID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                "@JudgeGroupCode", SqlDbType.VarChar, 100,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, strJudgeGroupCode);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                "@JudgeCode", SqlDbType.VarChar, 100,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, strJudgeCode);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                "@PointCode", SqlDbType.VarChar, 100,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, strPointCode);
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameter7 = new SqlParameter(
                "@PointTypeCode", SqlDbType.VarChar, 100,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, strPointTypeCode);
                oneSqlCommand.Parameters.Add(cmdParameter7);

                SqlParameter cmdParameter8 = new SqlParameter(
                "@Point", SqlDbType.VarChar, 50,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, strPoint);
                oneSqlCommand.Parameters.Add(cmdParameter8);

                SqlParameter cmdParameter9 = new SqlParameter(
                "@PointsStatusID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iPointsStatusID);
                oneSqlCommand.Parameters.Add(cmdParameter9);

                SqlParameter cmdParameter10 = new SqlParameter(
                "@IsAutoCalcuate", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iIsAutoCalcuate);
                oneSqlCommand.Parameters.Add(cmdParameter10);

                SqlParameter cmdParameter11 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter11);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;
                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            return iResult;
        }

        #endregion

        #region Dive List 相关操作

        public void ExcuteDV_DelOneFixedDiveSplit(Int32 iMatchID, Int32 iMatchSplitID)
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_DelOneFixedDiveSplit";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@MatchSplitID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchSplitID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter3);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public void ExcuteDV_AddOneFixedDiveSplit(Int32 iMatchID, Int32 iMatchSplitID)
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_AddOneFixedDiveSplit";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@MatchSplitID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchSplitID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter3);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public void ExcuteDV_UpdateOneFixedDiveSplitDifficultyValue(Int32 iMatchID, Int32 iMatchSplitID, String strDifficultyValue)
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_UpdateOneFixedDiveSplitDifficultyValue";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@MatchSplitID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchSplitID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@DifficultyValue", SqlDbType.VarChar, 50,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, strDifficultyValue);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter4);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public Int32 ExcuteDV_UpdateFixDiveDofD(Int32 iMatchID)
        {
            Int32 iResult = 0;

            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_UpdateFixDiveDofD";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter2);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            return iResult;
        }

        public Int32 ExcuteDV_UpdateDofDByHeight(Int32 iMatchID)
        {
            Int32 iResult = 0;
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_UpdateDofDByHeight";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter2);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            return iResult;
        }

        public Int32 ExcuteDV_CopyDiveListFromPrevious(Int32 iMatchID, Int32 iPreviousMatchID)
        {
            Int32 iResult = 0;
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_CopyDiveListFromPrevious";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@PreviousMatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iPreviousMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter3);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            return iResult;
        }

        public Int32 ExcuteDV_ImportOneDiveList(Int32 iMatchID, String strDiveListDes)
        {
            Int32 iResult = 0;
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_ImportOneDiveList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@DiveListDes", SqlDbType.VarChar, 2000,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, strDiveListDes);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter3);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            return iResult;
        }

        #endregion

        #region 计时计分导入相关操作
        /// <summary>
        /// 计时计分导入更新分数
        /// </summary>
        /// <param name="iMatchID"></param>
        /// <param name="iRoundIndex"></param>
        /// <param name="iRegisterIndex"></param>
        /// <param name="strJudgeNum"></param>
        /// <param name="strPoint"></param>
        /// <param name="iPointsStatusID"></param>
        /// <returns>成功返回NULL，错误返回原因</returns>
        public string ExcuteDV_TS_UpdatePlayerPoint(Int32 iMatchID, Int32 iRoundIndex, Int32 iRegisterIndex, String strJudgeNum, String strPoint, Int32 iPointsStatusID)
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_TS_UpdatePlayerPoint";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@RoundIndex", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iRoundIndex);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@RegisterIndex", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iRegisterIndex);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                "@JudgeNum", SqlDbType.VarChar, 100,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, strJudgeNum);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                "@Point", SqlDbType.VarChar, 50,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, strPoint);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                "@PointsStatusID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iPointsStatusID);
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameter7 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter7);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                }
                oneSqlCommand.Dispose();
                return null;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        public Int32 ExcuteDV_TS_UpdateMatchSplitCurrentDiver(Int32 iMatchID, String strRoundID, String strCompetitionPosition)
        {
            Int32 iRoundID = DVCommon.Str2Int(strRoundID);
            Int32 iCompetitionPosition = DVCommon.Str2Int(strCompetitionPosition);
            
            Int32 iResult = 0;
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_TS_UpdateMatchSplitCurrentDiver";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                "@MatchID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                "@RoundID", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iRoundID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                "@CompetitionPosition", SqlDbType.Int, 4,
                ParameterDirection.Input, true, 0, 0, "",
                DataRowVersion.Current, iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                "@Result", SqlDbType.Int, 4,
                ParameterDirection.Output, true, 0, 0, "",
                DataRowVersion.Current, null);
                oneSqlCommand.Parameters.Add(cmdParameter4);


                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iResult = (Int32)oneSqlCommand.Parameters["@Result"].Value;

                }
                oneSqlCommand.Dispose();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            return iResult;
        }

        #endregion

        #region 外部数据库接口
        public void GetInnerMatchList(ref DataGridView dgv)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DBTS_DV_GetInnerMatchList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strActiveLanguage);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }


                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridView(dgv, sdr);
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public int UpdateActionCode(string strMatchID, string strRoundNo, string strOrderNo, string strActionCode, string strActionDiff, string strDiveHeight)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DBTS_DV_UpdateMatchActionCode";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@RoundNo", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strRoundNo);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@OrderNo", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strOrderNo);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@ActionCode", SqlDbType.NVarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strActionCode);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@ActionDif", SqlDbType.NVarChar, 20,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strActionDiff);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                           "@DiveHeight", SqlDbType.NVarChar, 20,
                           ParameterDirection.Input, true, 0, 0, "",
                           DataRowVersion.Current, strDiveHeight);
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameterResult = new SqlParameter(
                           "@Result", SqlDbType.Int, 4,
                           ParameterDirection.Output, true, 0, 0, "",
                           DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }

                oneSqlCommand.ExecuteNonQuery();
                int nRetValue = (int)oneSqlCommand.Parameters["@Result"].Value;

                return nRetValue;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return 0;
        }

        public int  UpdateMatchResult(string strMatchID, string strOrderNo, string strEventPoint, string strEventPlace, string strQualified,string strIRM)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DBTS_DV_UpdateMatchResult";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@OrderNo", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strOrderNo);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@EventPoint", SqlDbType.NVarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strEventPoint);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@EventPlace", SqlDbType.NVarChar, 20,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strEventPlace);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                     "@EventQualified", SqlDbType.NVarChar, 20,
                     ParameterDirection.Input, true, 0, 0, "",
                     DataRowVersion.Current, strQualified);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                   "@IRM", SqlDbType.NVarChar, 20,
                   ParameterDirection.Input, true, 0, 0, "",
                   DataRowVersion.Current, strIRM);
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameter7 = new SqlParameter(
                     "@LanguageCode", SqlDbType.NVarChar, 20,
                     ParameterDirection.Input, true, 0, 0, "",
                     DataRowVersion.Current, m_strActiveLanguage);
                oneSqlCommand.Parameters.Add(cmdParameter7);

                SqlParameter cmdParameterResult = new SqlParameter(
                           "@Result", SqlDbType.Int, 4,
                           ParameterDirection.Output, true, 0, 0, "",
                           DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }

                oneSqlCommand.ExecuteNonQuery();
                int nRetValue = (int)oneSqlCommand.Parameters["@Result"].Value;

                return nRetValue;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return 0;
        }

        public int UpdateDetailMatchResult(string strMatchID,string strRoundNo, string strOrderNo, string strDivePoint, string strDiveRank, string strEventPoint, string strEventRank, string strMatchTypeID)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DVCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_DBTS_DV_UpdateDetailMatchResult";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@RoundNo", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strRoundNo);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@OrderNo", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strOrderNo);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@DivePoint", SqlDbType.NVarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strDivePoint);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@DiveRank", SqlDbType.NVarChar, 20,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strDiveRank);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                             "@MatchSplitTypeID", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, strMatchTypeID);
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameter7= new SqlParameter(
                        "@EventPoint", SqlDbType.NVarChar, 20,
                        ParameterDirection.Input, true, 0, 0, "",
                        DataRowVersion.Current, strEventPoint);
                oneSqlCommand.Parameters.Add(cmdParameter7);

                SqlParameter cmdParameter8 = new SqlParameter(
                       "@EventRank", SqlDbType.NVarChar, 20,
                       ParameterDirection.Input, true, 0, 0, "",
                       DataRowVersion.Current, strEventRank);
                oneSqlCommand.Parameters.Add(cmdParameter8);

                SqlParameter cmdParameterResult = new SqlParameter(
                           "@Result", SqlDbType.Int, 4,
                           ParameterDirection.Output, true, 0, 0, "",
                           DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    DVCommon.g_DataBaseCon.Open();
                }

                oneSqlCommand.ExecuteNonQuery();
                int nRetValue = (int)oneSqlCommand.Parameters["@Result"].Value;

                return nRetValue;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return 0;
        }

        public void GetRoundNo(string strMatchID, ComboBox cmbRoundNo )
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DBTS_DV_GetRoundNo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                SqlParameter cmdParameter1 = new SqlParameter(
                          "@MatchID", SqlDbType.Int, 4,
                          ParameterDirection.Input, true, 0, 0, "",
                          DataRowVersion.Current, strMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                DataTable tbRoundNo = new DataTable();
                tbRoundNo.Clear();
                tbRoundNo.Load(sdr);

                tbRoundNo.Rows.Add("All","0");

                cmbRoundNo.DisplayMember = "Splitcode";
                cmbRoundNo.ValueMember = "Value";
                cmbRoundNo.DataSource = tbRoundNo;

                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void CalEventResult(int iMatchID)
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_CalEventResult";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                SqlParameter cmdParameter1 = new SqlParameter(
                          "@MatchID", SqlDbType.Int, 4,
                          ParameterDirection.Input, true, 0, 0, "",
                          DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                oneSqlCommand.ExecuteNonQuery();               
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }
        #endregion

    }
}
