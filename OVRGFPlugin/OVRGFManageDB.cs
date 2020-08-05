using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Collections;
using System.Data;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using System.Text.RegularExpressions;

using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Xml;
using System.Threading;

namespace AutoSports.OVRGFPlugin
{
    public class OVRGFManageDB
    {
        private Int32 m_iSportID;
        private Int32 m_iDisciplineID;
        public String m_strLanguage;

        private DataTable m_tbRules = new DataTable();

        public OVRGFManageDB()
        {
            m_iSportID = -1;
            m_iDisciplineID = -1;
            m_strLanguage = "";
        }

        public void GetActiveSportInfo()
        {
            if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                GFCommon.g_DataBaseCon.Open();
            }

            OVRDataBaseUtils.GetActiveInfo(GFCommon.g_DataBaseCon, out m_iSportID, out m_iDisciplineID, out m_strLanguage);
            m_iDisciplineID = GetDisplnID(GFCommon.g_strDisplnCode);
        }

        public Int32 GetDisplnID(String strDisplnCode)
        {
            if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                GFCommon.g_DataBaseCon.Open();
            }

            Int32 iDisciplineID = 0;
            try
            {
                #region DML Command Setup for GetDisciplineID

                String strSQL;
                strSQL = String.Format("SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode= '{0}'", strDisplnCode);
                SqlCommand cmd = new SqlCommand(strSQL, GFCommon.g_DataBaseCon);
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

        public Int32 GetCurTeamMatchID(Int32 nMatchID)
        {
            Int32 nTeamID = -1;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_GetCurTeamMatchID";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;

                    if (iOperateResult <= 0)
                    {
                        nTeamID = -1;
                    }
                    else
                    {
                        nTeamID = iOperateResult;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return nTeamID;
        }

        public void GetMatchDes(Int32 nMatchID, out String strMatchDes, out String strDateDes, out Int32 nStatusID)
        {
            strMatchDes = "";
            strDateDes = "";
            nStatusID = 0;

            if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                GFCommon.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for GetMatchDescription
                SqlCommand cmd = new SqlCommand("Proc_GF_GetMatchDescription", GFCommon.g_DataBaseCon);
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
                if (dr.HasRows && dr.Read())
                {
                    strMatchDes = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_MatchDes");
                    strDateDes = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DateDes");
                    nStatusID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MatchStatusID");
                }

                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public Boolean IsMatchCreateSplit(Int32 nMatchID)
        {
            Boolean bResult = false;

            if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                GFCommon.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for GetMatchSplitID

                String strSQL;
                strSQL = String.Format("SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = {0}", nMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, GFCommon.g_DataBaseCon);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
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

        public void GetMatchHolePar(Int32 nMatchID, ref System.Data.DataTable dt)
        {
            dt.Clear();

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_GetMatchHolePar";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                oneSqlCommand.Parameters.Add(cmdParameter1);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                dt.Load(sdr);
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void FillGridViewHolePar(Int32 nMatchID, DataGridView dgvGrid)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_GetMatchHoleInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                oneSqlCommand.Parameters.Add(cmdParameter1);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                DataTable dr = new DataTable();
                dr.Load(sdr);
                sdr.Close();

                FillDataGridViewHolePar(dgvGrid, dr);
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public System.Data.DataTable GetMatchResult(Int32 nMatchID)
        {
            System.Data.DataTable dt = new DataTable();

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_GetMatchResult";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguage);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                DataTable dr = new DataTable();
                dr.Load(sdr);
                dt = dr;
                sdr.Close();
            }
            catch (Exception ex)
            {
                //DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return dt;
        }

        public System.Data.DataTable FillGridViewPlayer(Int32 nMatchID, DataGridView dgvGrid)
        {
            System.Data.DataTable dt = new DataTable();

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_GetMatchResult";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguage);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                DataTable dr = new DataTable();
                dr.Load(sdr);
                dt = dr;
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            FillDataGridViewPlayer(dgvGrid, dt, null, null);

            for (Int32 i = 0; i < dgvGrid.Columns.Count; i++)
            {
                if (dgvGrid.Columns[i] != null)
                {
                    String strFileName = dgvGrid.Columns[i].Name;

                    if (strFileName == "F_CompetitionPosition")
                    {
                        dgvGrid.Columns[i].ReadOnly = true;
                        dgvGrid.Columns[i].Visible = false;
                    }
                    else if (strFileName == "Order")
                    {
                        dgvGrid.Columns[i].ReadOnly = true;
                    }
                    else if (strFileName == "NOC")
                    {
                        dgvGrid.Columns[i].ReadOnly = true;
                    }
                    else if (strFileName == "Name")
                    {
                        dgvGrid.Columns[i].ReadOnly = true;
                    }
                    else if (strFileName == "Round Rank")
                    {
                        dgvGrid.Columns[i].ReadOnly = true;
                    }
                    else if (strFileName == "Total")
                    {
                        dgvGrid.Columns[i].ReadOnly = true;
                    }
                    else if (strFileName == "OUT")
                    {
                        dgvGrid.Columns[i].ReadOnly = true;
                    }
                    else if (strFileName == "IN")
                    {
                        dgvGrid.Columns[i].ReadOnly = true;
                    }
                    else if (strFileName == "Pos")
                    {
                        dgvGrid.Columns[i].ReadOnly = false;
                    }
                    else
                    {
                        dgvGrid.Columns[i].ReadOnly = false;
                    }
                }
            }

            dgvGrid.ClearSelection();
            dgvGrid.RowHeadersVisible = false;//不显示序号列

            return dt;
        }

        public System.Data.DataTable GetTeamResult(Int32 nMatchID)
        {
            System.Data.DataTable dt = new DataTable();

            SqlConnection SqlConnection = new SqlConnection(GFCommon.g_DataBaseCon.ConnectionString);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = SqlConnection;
                oneSqlCommand.CommandText = "Proc_GF_GetTeamResult";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguage);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                DataTable dr = new DataTable();
                dr.Load(sdr);
                dt = dr;
                sdr.Close();
            }
            catch (Exception ex)
            {
                //DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }
            return dt;
        }

        public System.Data.DataTable FillGridViewTeam(Int32 nMatchID, DataGridView dgvGrid)
        {
            System.Data.DataTable dt = new DataTable();
            SqlConnection SqlConnection = new SqlConnection(GFCommon.g_DataBaseCon.ConnectionString);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = SqlConnection;
                oneSqlCommand.CommandText = "Proc_GF_GetTeamResult";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguage);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                DataTable dr = new DataTable();
                dr.Load(sdr);
                dt = dr;
                sdr.Close();

                FillDataGridViewTeam(dgvGrid, dr);

                for (Int32 i = 0; i < dgvGrid.Columns.Count; i++)
                {
                    if (dgvGrid.Columns[i] != null)
                    {
                        String strFileName = dgvGrid.Columns[i].Name;

                        if (strFileName == "F_TeamID")
                        {
                            dgvGrid.Columns[i].ReadOnly = true;
                            dgvGrid.Columns[i].Visible = false;
                        }
                        else if (strFileName == "Pos")
                        {
                            dgvGrid.Columns[i].ReadOnly = false;
                        }
                    }
                }
                dgvGrid.ClearSelection();
                dgvGrid.RowHeadersVisible = false;//不显示序号列
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }

            return dt;
        }

        public void UpdatePlayerRank(Int32 nMatchID, DataGridView dgvGrid)
        {
            SqlConnection SqlConnection = new SqlConnection(GFCommon.g_DataBaseCon.ConnectionString);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = SqlConnection;
                oneSqlCommand.CommandText = "Proc_GF_GetMatchRank";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguage);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                DataTable dr = new DataTable();
                dr.Load(sdr);
                sdr.Close();

                UpdateGridViewPlayerRank(dgvGrid, dr);
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }
        }

        //Course Rule

        public Int32 GetMatchRuleID(Int32 nMatchID)
        {
            if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                GFCommon.g_DataBaseCon.Open();
            }

            Int32 iRuleID = -1;

            try
            {
                #region DML Command Setup for GetCompetitionRuleID

                String strSQL;
                strSQL = String.Format("SELECT F_CompetitionRuleID FROM TS_Match WHERE F_MatchID = {0}", nMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, GFCommon.g_DataBaseCon);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    iRuleID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_CompetitionRuleID");
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            return iRuleID;
        }

        public void InitCourseInfo(DataGridView dgvGrid)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_GetCompetitionRules";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iDisciplineID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguage);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                DataTable dr = new DataTable();
                dr.Load(sdr);
                sdr.Close();

                OVRDataBaseUtils.FillDataGridView(dgvGrid, dr, null, null);

                for (Int32 i = 0; i < dgvGrid.Columns.Count; i++)
                {
                    if (dgvGrid.Columns[i] != null)
                    {
                        dgvGrid.Columns[i].ReadOnly = false;
                    }
                }

                dgvGrid.RowHeadersVisible = false;//不显示序号列

                dgvGrid.Columns["F_CompetitionRuleID"].ReadOnly = true;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void IntiCourseDetail(Int32 nRuleID, DataGridView dgvGrid)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_GetMatchCompetitionRuleDetail";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@CompetitionRuleID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nRuleID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                DataTable dr = new DataTable();
                dr.Load(sdr);
                sdr.Close();

                OVRDataBaseUtils.FillDataGridView(dgvGrid, dr, null, null);

                for (Int32 i = 0; i < dgvGrid.Columns.Count; i++)
                {
                    if (dgvGrid.Columns[i] != null)
                    {
                        dgvGrid.Columns[i].ReadOnly = false;
                    }
                }

                dgvGrid.RowHeadersVisible = false;//不显示序号列
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void InitCmbRules(ComboBox cmbRule)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_GetCompetitionRules";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iDisciplineID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguage);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                DataTable tbRules = new DataTable();
                tbRules.Clear();
                tbRules.Load(sdr);
                sdr.Close();

                cmbRule.DisplayMember = "F_CompetitionLongName";
                cmbRule.ValueMember = "F_CompetitionRuleID";
                cmbRule.DataSource = tbRules;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public Boolean DeleteCourse(Int32 nRuleID)
        {
            Boolean bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_DelCompetitionRule";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@CompetitionRuleID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nRuleID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;

                    switch (iOperateResult)
                    {
                        case 0:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgDelRule1"));
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgDelRule2"));
                            break;
                        case -2:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgDelRule3"));
                            break;
                        default://其余的为删除成功！

                            bResult = true;
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }

        public Boolean CreateCourse(Int32 nHoleNumber)
        {
            Boolean bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_AddCompetitionRule";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iDisciplineID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@Hole", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nHoleNumber);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;

                    if (iOperateResult > 0)
                    {
                        bResult = true;
                    }
                    else
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgAddRule1"));
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }

        public void UpdateCourseDes(Int32 nRuleID, String strPropertyName, String strPropertyValue)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_UpdateMatchRuleDes";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@CompetitionRuleID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nRuleID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguage);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@PropertyName", SqlDbType.NVarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strPropertyName);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@PropertyValue", SqlDbType.NVarChar, 100,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strPropertyValue);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void UpdateCourseDetail(Int32 nRuleID, String strRuleXML)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "proc_GF_UpdateCompetitionRuleXML";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@CompetitionRuleID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nRuleID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameterXML = new SqlParameter(
                            "@RuleXML", SqlDbType.NVarChar, 9000000,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strRuleXML);
                oneSqlCommand.Parameters.Add(cmdParameterXML);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public Boolean ApplayCourse(Int32 nMatchID, Int32 nRuleID)
        {
            Boolean bResult = false;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_ApplyNewMatchRule";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionRuleID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nRuleID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;

                    switch (iOperateResult)
                    {
                        case 1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgApplySelRule2"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                            bResult = true;
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgApplySelRule3"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        case -2:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgApplySelRule4"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgApplySelRule5"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }

        //比赛进程
        public Boolean UpdatePlayerHoleNum(Int32 nMatchID, Int32 nCompetitionID, Int32 nHole, Int32 nHoleNum, int nDoRank)
        {
            SqlConnection SqlConnection = new SqlConnection(GFCommon.g_DataBaseCon.ConnectionString);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            Boolean bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = SqlConnection;
                oneSqlCommand.CommandText = "Proc_GF_UpdatePlayerHoleNum";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nCompetitionID);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@Hole", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nHole);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@HoleNum", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nHoleNum);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@DoRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nDoRank);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);
                oneSqlCommand.Parameters.Add(cmdParameter4);
                oneSqlCommand.Parameters.Add(cmdParameter5);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;

                    if (iOperateResult > 0)
                    {
                        bResult = true;
                    }
                    else
                    {
                        //DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgUpdateHole1"));
                    }
                }
            }
            catch (Exception ex)
            {
                //DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }

            return bResult;
        }

        public Boolean UpdateMatchResult(Int32 nMatchID, Int32 nIsDetail)
        {
            SqlConnection SqlConnection = new SqlConnection(GFCommon.g_DataBaseCon.ConnectionString);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            Boolean bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = SqlConnection;
                oneSqlCommand.CommandText = "Proc_GF_UpdateMatchResult";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@IsDetail", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nIsDetail);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;

                    if (iOperateResult > 0)
                    {
                        bResult = true;
                    }
                    else
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgUpdateMatchResult"));
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }

            return bResult;
        }

        public Boolean UpdateTeamResult(Int32 nMatchID, Int32 nIsDetail)
        {
            SqlConnection SqlConnection = new SqlConnection(GFCommon.g_DataBaseCon.ConnectionString);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            Boolean bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = SqlConnection;
                oneSqlCommand.CommandText = "Proc_GF_UpdateTeamResult";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@IsDetail", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nIsDetail);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;

                    if (iOperateResult > 0)
                    {
                        bResult = true;
                    }
                    else
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgUpdateTeamResult"));
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }

            return bResult;
        }

        public void UpdatePlayerMatchGroup(Int32 nMatchID, Int32 nCompetitionID, Int32 nValue)
        {
            if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                GFCommon.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchGroup

                String strSQL;
                strSQL = String.Format("UPDATE TS_Match_Result SET F_CompetitionPositionDes2 = '{0}' WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}", nValue, nMatchID, nCompetitionID);
                SqlCommand cmd = new SqlCommand(strSQL, GFCommon.g_DataBaseCon);
                SqlDataReader dr = cmd.ExecuteReader();
                dr.Close();

                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdatePlayerMatchSides(Int32 nMatchID, Int32 nCompetitionID, Int32 nValue)
        {
            if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                GFCommon.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchSides

                String strSQL;
                strSQL = String.Format("UPDATE TS_Match_Result SET F_FinishTimeNumDes = {0} WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}", nValue, nMatchID, nCompetitionID);
                SqlCommand cmd = new SqlCommand(strSQL, GFCommon.g_DataBaseCon);
                SqlDataReader dr = cmd.ExecuteReader();
                dr.Close();

                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdatePlayerMatchTee(Int32 nMatchID, Int32 nCompetitionID, Int32 nValue)
        {
            if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                GFCommon.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for UpdateMatchTee

                String strSQL;
                strSQL = String.Format("UPDATE TS_Match_Result SET F_StartTimeNumDes = {0} WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}", nValue, nMatchID, nCompetitionID);
                SqlCommand cmd = new SqlCommand(strSQL, GFCommon.g_DataBaseCon);
                SqlDataReader dr = cmd.ExecuteReader();
                dr.Close();

                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void UpdatePlayerMatchPos(Int32 nMatchID, Int32 nCompetitionID, string strValue)
        {
            if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                GFCommon.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for UpdateMatchPos

                String strSQL;
                strSQL = String.Format("UPDATE TS_Match_Result SET F_DisplayPosition = {0} WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}", strValue, nMatchID, nCompetitionID);
                SqlCommand cmd = new SqlCommand(strSQL, GFCommon.g_DataBaseCon);
                SqlDataReader dr = cmd.ExecuteReader();
                dr.Close();

                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public bool UpdateTeamDisPos(Int32 nMatchID, Int32 nTeamID, Int32 nValue)
        {
            SqlConnection SqlConnection = new SqlConnection(GFCommon.g_DataBaseCon.ConnectionString);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            Boolean bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = SqlConnection;
                oneSqlCommand.CommandText = "Proc_GF_UpdateTeamDisPos";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@TeamID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nTeamID);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@DisPos", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nValue);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;

                    if (iOperateResult > 0)
                    {
                        bResult = true;
                    }
                    else
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show("Error...UpdateTeamMatchPos");
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }

            return bResult;
        }

        public void UpdatePlayerMatchTime(Int32 nMatchID, Int32 nCompetitionID, String strValue)
        {
            if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                GFCommon.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for UpdateMatchTime

                String strSQL;
                strSQL = String.Format("UPDATE TS_Match_Result SET F_StartTimeCharDes = '{0}' WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}", strValue, nMatchID, nCompetitionID);
                SqlCommand cmd = new SqlCommand(strSQL, GFCommon.g_DataBaseCon);
                SqlDataReader dr = cmd.ExecuteReader();
                dr.Close();

                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        //Greate Group
        public Boolean CreateMatchGroup(Int32 nMatchID, Int32 nSides)
        {
            Boolean bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_CreateMatchGroup";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@Sides", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nSides);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;

                    switch (iOperateResult)
                    {
                        case 1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgGreateGroup2"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                            bResult = true;
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgGreateGroup3"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        case -2:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgGreateGroup4"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        case -3:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgGreateGroup5"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgGreateGroup6"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }

        public Boolean SetMatchTee(Int32 nMatchID, int nStart, int nFinish, int nTee, string strStartTime, string strSpanTime)
        {
            Boolean bResult = false;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_SetMatchTee";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@Start", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nStart);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@Finish", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nFinish);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@Tee", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nTee);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@StartTime", SqlDbType.NVarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strStartTime);

                SqlParameter cmdParameter6 = new SqlParameter(
                            "@SpanTime", SqlDbType.NVarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strSpanTime);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);
                oneSqlCommand.Parameters.Add(cmdParameter4);
                oneSqlCommand.Parameters.Add(cmdParameter5);
                oneSqlCommand.Parameters.Add(cmdParameter6);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;

                    switch (iOperateResult)
                    {
                        case 1:
                            //DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgSetTee2"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                            bResult = true;
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgSetTee3"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        case -2:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgSetTee4"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgSetTee6"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }

        public void FillGroupInfo(Int32 nMatchID, Int32 nGroup, out Int32 nTee, out string strStartTime)
        {
            nTee = 0;
            strStartTime = "";

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_GetMatchGroupInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@Group", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nGroup);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                SqlDataReader dr = oneSqlCommand.ExecuteReader();
                if (dr.HasRows && dr.Read())
                {
                    nTee = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "Tee");
                    strStartTime = OVRDataBaseUtils.GetFieldValue2String(ref dr, "StartTime");
                }

                dr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public Boolean UpdateMatchGroup(Int32 nMatchID, Int32 nGroup, Int32 nTee, string strStartTime)
        {
            Boolean bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_UpdateMatchGroupInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@Group", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nGroup);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@Tee", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nTee);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@StartTime", SqlDbType.NVarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strStartTime);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);
                oneSqlCommand.Parameters.Add(cmdParameter4);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;

                    switch (iOperateResult)
                    {
                        case 1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgModifyGroup3"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                            bResult = true;
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgModifyGroup4"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        case -2:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgModifyGroup5"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgModifyGroup6"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }

        public Boolean IsMatchPositionNull(Int32 nMatchID)
        {
            Boolean bResult = true;
            if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                GFCommon.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Get Match Position

                String strSQL;
                strSQL = String.Format("SELECT * FROM TS_Match_Result WHERE F_MatchID = {0}", nMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, GFCommon.g_DataBaseCon);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    bResult = false;
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

        public Boolean IsMatchGroupNull(Int32 nMatchID)
        {
            Boolean bResult = false;
            if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                GFCommon.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Get Match Group

                String strSQL;
                strSQL = String.Format("SELECT * FROM TS_Match_Result WHERE F_MatchID = {0} AND (F_CompetitionPositionDes2 IS NULL OR F_FinishTimeNumDes IS NULL)", nMatchID);
                SqlCommand cmd = new SqlCommand(strSQL, GFCommon.g_DataBaseCon);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
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

        public Boolean InitialMatchPlayer(Int32 nMatchID)
        {
            Boolean bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_AutoDrawMatchPosition";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;

                    switch (iOperateResult)
                    {
                        case 1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgAutoDraw4"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                            bResult = true;
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgAutoDraw5"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }

        public string GetPlayerIRM(Int32 nMatchID, Int32 nCompetitionPosition)
        {
            if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                GFCommon.g_DataBaseCon.Open();
            }

            string strIRM = "";
            try
            {
                #region DML Command Setup for GetIRM

                String strSQL;
                strSQL = String.Format("SELECT B.F_IRMCODE FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = {0} AND A.F_CompetitionPosition = {1}", nMatchID, nCompetitionPosition);
                SqlCommand cmd = new SqlCommand(strSQL, GFCommon.g_DataBaseCon);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    strIRM = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_IRMCODE");
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            return strIRM;
        }

        public Boolean UpdatePlayerIRM(Int32 nMatchID, Int32 nCompetitionID, string strIRM)
        {
            Boolean bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_UpdatePlayerIRM";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nCompetitionID);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@IRM", SqlDbType.NVarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strIRM);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;

                    if (iOperateResult > 0)
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

        public Boolean CalculateEventResult(Int32 nMatchID)
        {
            Boolean bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_CalEventResult";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    Int32 iOperateResult = (Int32)cmdParameterResult.Value;

                    if (iOperateResult > 0)
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

        //TCP数据相关
        public Int32 GetTcpMatchID(String strSexCode, String strEventCode, String strRound)
        {
            SqlConnection SqlConnection = new SqlConnection(GFCommon.g_DataBaseCon.ConnectionString);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            Int32 iMatchID = 0;
            Int32 nRound = 0;
            nRound = GFCommon.ConvertStrToInt(strRound);

            try
            {
                #region DML Command Setup for GetDisciplineID

                String strSQL;
                strSQL = String.Format(@"SELECT F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
                LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
                WHERE P.F_Order = {0} AND E.F_EventCode = '{1}' AND S.F_GenderCode = '{2}'", nRound, strEventCode, strSexCode);

                SqlCommand cmd = new SqlCommand(strSQL, SqlConnection);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    iMatchID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_MatchID");
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }

            return iMatchID;
        }

        public Int32 GetTcpCompetitionID(Int32 nMatchID, String strRegisterCode)
        {
            SqlConnection SqlConnection = new SqlConnection(GFCommon.g_DataBaseCon.ConnectionString);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }

            Int32 iCompetitionID = 0;
            try
            {
                #region DML Command Setup for GetDisciplineID

                String strSQL;

                strSQL = String.Format(@"SELECT MR.F_CompetitionPosition FROM TS_Match_Result AS MR LEFT JOIN TR_Register AS R
                                         ON MR.F_RegisterID = R.F_RegisterID WHERE MR.F_MatchID = {0} AND R.F_RegisterCode = '{1}'", nMatchID, strRegisterCode);

                SqlCommand cmd = new SqlCommand(strSQL, SqlConnection);
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    iCompetitionID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_CompetitionPosition");
                }

                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }

            return iCompetitionID;
        }

        //填写DataGridView

        public static void FillDataGridViewHolePar(DataGridView dgv, DataTable dt)
        {
            if (dgv == null || dt == null) return;
            if (dt.Columns.Count < 1 || dt.Rows.Count < 1) return;

            try
            {
                // Reset Columns
                dgv.Columns.Clear();
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    DataGridViewColumn col = null;

                    col = new DataGridViewTextBoxColumn();
                    col.ReadOnly = true;

                    if (col != null)
                    {
                        string strValue = dt.Rows[0][i].ToString();
                        col.HeaderText = strValue;
                        col.Name = strValue;
                        col.Frozen = false;
                        col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
                        col.Resizable = DataGridViewTriState.False;
                        col.Width = 25;
                        dgv.Columns.Add(col);
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public static void FillDataGridViewPlayer(DataGridView dgv, DataTable dt, List<int> cmbColumns = null, List<OVRCheckBoxColumn> chkColumns = null)
        {
            if (dgv == null || dt == null) return;
            if (dt.Columns.Count < 1) return;

            bool bResetColumns = false;
            if (dt.Columns.Count != dgv.Columns.Count)
            {
                bResetColumns = true;
            }
            else
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    if (dgv.Columns[i].HeaderText != dt.Columns[i].ColumnName)
                    {
                        bResetColumns = true;
                        break;
                    }
                }
            }

            try
            {
                // Reset Columns
                if (bResetColumns)
                {
                    dgv.Columns.Clear();
                    for (int i = 0; i < dt.Columns.Count; i++)
                    {
                        DataGridViewColumn col = null;
                        bool bTextBoxCol = true;
                        if (cmbColumns != null)
                        {
                            for (int j = 0; j < cmbColumns.Count; j++)
                            {
                                if (i == cmbColumns[j])
                                {
                                    col = new DGVCustomComboBoxColumn();
                                    bTextBoxCol = false;
                                    break;
                                }
                            }
                        }
                        if (chkColumns != null)
                        {
                            for (int j = 0; j < chkColumns.Count; j++)
                            {
                                if (i == chkColumns[j].columnIndex)
                                {
                                    col = new DataGridViewCheckBoxColumn();
                                    (col as DataGridViewCheckBoxColumn).TrueValue = chkColumns[j].trueValue.ToString();
                                    (col as DataGridViewCheckBoxColumn).FalseValue = chkColumns[j].falseValue.ToString();
                                    bTextBoxCol = false;
                                    break;
                                }
                            }
                        }
                        if (bTextBoxCol)
                        {
                            col = new DataGridViewTextBoxColumn();
                            col.ReadOnly = true;
                        }
                        if (col != null)
                        {
                            col.HeaderText = dt.Columns[i].ColumnName;
                            col.Name = dt.Columns[i].ColumnName;
                            col.Frozen = false;
                            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
                            col.Resizable = DataGridViewTriState.False;
                            col.SortMode = DataGridViewColumnSortMode.NotSortable;

                            if (dt.Columns[i].ColumnName == "Order")
                            {
                                col.Width = 40;
                            }
                            else if (dt.Columns[i].ColumnName == "NOC")
                            {
                                col.Width = 40;
                            }
                            else if (dt.Columns[i].ColumnName == "Name")
                            {
                                col.Width = 150;
                            }
                            else if (dt.Columns[i].ColumnName == "Group")
                            {
                                col.Width = 40;
                            }
                            else if (dt.Columns[i].ColumnName == "Sides")
                            {
                                col.Width = 40;
                            }
                            else if (dt.Columns[i].ColumnName == "Tee")
                            {
                                col.Width = 40;
                            }
                            else if (dt.Columns[i].ColumnName == "Time")
                            {
                                col.Width = 50;
                            }
                            else if (dt.Columns[i].ColumnName == "Round Rank")
                            {
                                col.Width = 100;
                            }
                            else if (dt.Columns[i].ColumnName == "Total")
                            {
                                col.Width = 100;
                            }
                            else
                            {
                                col.Width = 25;
                            }

                            dgv.Columns.Add(col);
                        }
                    }
                }

                List<string> listColumn = new List<string>(dt.Columns.Count);
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    listColumn.Add(dt.Columns[i].ColumnName);
                }

                // Fill DataGridView
                dgv.Rows.Clear();
                int iRowNum = 0;
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    DataGridViewRow dr = new DataGridViewRow();
                    dr.CreateCells(dgv);
                    dr.Selected = false;
                    for (int i = 0; i < dt.Columns.Count; i++)
                    {
                        string strValue = dt.Rows[j][i].ToString();
                        dr.Cells[i].Value = strValue;

                        if (strValue.Length > listColumn[i].Length)
                            listColumn[i] = strValue;
                    }

                    if (dgv.RowHeadersVisible)
                    {
                        iRowNum++;
                        dr.HeaderCell.Value = iRowNum.ToString();
                    }

                    dgv.Rows.Add(dr);
                }

                if (dgv.RowHeadersVisible)
                {
                    dgv.TopLeftHeaderCell.Value = String.Format("RC: {0}", iRowNum);
                    System.Drawing.SizeF sf = dgv.CreateGraphics().MeasureString(dgv.TopLeftHeaderCell.Value.ToString(), dgv.Font);
                    dgv.RowHeadersWidth = System.Convert.ToInt32(sf.Width + 10f);
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public static void UpdateGridViewPlayerRank(DataGridView dgv, DataTable dt)
        {
            try
            {
                Int32 nRowCount = dgv.Rows.Count;

                if (dt.Rows.Count != nRowCount)
                    return;

                // Update DataGridView
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    string strName = dt.Rows[j]["Name"].ToString();
                    string strRoundRank = dt.Rows[j]["Round Rank"].ToString();
                    string strTotalRank = dt.Rows[j]["Total"].ToString();
                    string strPos = dt.Rows[j]["Pos"].ToString();

                    dgv.Rows[j].Cells["Name"].Value = strName;
                    dgv.Rows[j].Cells["Round Rank"].Value = strRoundRank;
                    dgv.Rows[j].Cells["Total"].Value = strTotalRank;
                    dgv.Rows[j].Cells["Pos"].Value = strPos;
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public void FillDataGridViewTeam(DataGridView dgv, DataTable dt)
        {
            if (dgv == null || dt == null) return;
            if (dt.Columns.Count < 1) return;

            bool bResetColumns = false;
            if (dt.Columns.Count != dgv.Columns.Count)
            {
                bResetColumns = true;
            }
            else
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    if (dgv.Columns[i].HeaderText != dt.Columns[i].ColumnName)
                    {
                        bResetColumns = true;
                        break;
                    }
                }
            }

            try
            {
                // Reset Columns
                if (bResetColumns)
                {
                    dgv.Columns.Clear();
                    for (int i = 0; i < dt.Columns.Count; i++)
                    {
                        DataGridViewColumn col = null;
                        bool bTextBoxCol = true;

                        if (bTextBoxCol)
                        {
                            col = new DataGridViewTextBoxColumn();
                            col.ReadOnly = true;
                        }
                        if (col != null)
                        {
                            col.HeaderText = dt.Columns[i].ColumnName;
                            col.Name = dt.Columns[i].ColumnName;
                            col.Frozen = false;
                            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
                            col.Resizable = DataGridViewTriState.False;
                            col.SortMode = DataGridViewColumnSortMode.NotSortable;

                            if (dt.Columns[i].ColumnName == "NOC")
                            {
                                col.Width = 40;
                            }
                            else if (dt.Columns[i].ColumnName == "Name")
                            {
                                col.Width = 150;
                            }
                            else if (dt.Columns[i].ColumnName == "Total")
                            {
                                col.Width = 100;
                            }
                            else
                            {
                                col.Width = 60;
                            }

                            dgv.Columns.Add(col);
                        }
                    }
                }

                List<string> listColumn = new List<string>(dt.Columns.Count);
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    listColumn.Add(dt.Columns[i].ColumnName);
                }

                // Fill DataGridView
                dgv.Rows.Clear();
                int iRowNum = 0;
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    DataGridViewRow dr = new DataGridViewRow();
                    dr.CreateCells(dgv);
                    dr.Selected = false;
                    for (int i = 0; i < dt.Columns.Count; i++)
                    {
                        string strValue = dt.Rows[j][i].ToString();
                        dr.Cells[i].Value = strValue;

                        if (strValue.Length > listColumn[i].Length)
                            listColumn[i] = strValue;
                    }

                    if (dgv.RowHeadersVisible)
                    {
                        iRowNum++;
                        dr.HeaderCell.Value = iRowNum.ToString();
                    }

                    dgv.Rows.Add(dr);
                }

                if (dgv.RowHeadersVisible)
                {
                    dgv.TopLeftHeaderCell.Value = String.Format("RC: {0}", iRowNum);
                    System.Drawing.SizeF sf = dgv.CreateGraphics().MeasureString(dgv.TopLeftHeaderCell.Value.ToString(), dgv.Font);
                    dgv.RowHeadersWidth = System.Convert.ToInt32(sf.Width + 10f);
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public Boolean GetMatchPlayOffInfo(Int32 nMatchID, Int32 nPlayOffPos, out String strHoleSec)
        {
            Boolean bResult = false;
            strHoleSec = "";

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_GetMatchPlayOffInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);
                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PlayOffRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPlayOffPos);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                SqlDataReader dr = oneSqlCommand.ExecuteReader();
                if (dr.HasRows && dr.Read())
                {
                    strHoleSec = OVRDataBaseUtils.GetFieldValue2String(ref dr, "HoleSec");
                }

                dr.Close();
                bResult = true;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }

        public Boolean SetMatchPlayOffInfo(Int32 nMatchID, Int32 nPlayOffRank, String strHoleSec)
        {
            Boolean bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_SetMatchPlayOffInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);
                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PlayOffRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPlayOffRank);
                SqlParameter cmdParameter3 = new SqlParameter(
                            "@HoleSec", SqlDbType.Char, 36,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strHoleSec);


                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    bResult = true;
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }

        public System.Data.DataTable FillGridViewPlayOff(Int32 nMatchID, Int32 nPlayOffRank, DataGridView dgvGrid)
        {
            System.Data.DataTable dt = new DataTable();
            SqlConnection SqlConnection = new SqlConnection(GFCommon.g_DataBaseCon.ConnectionString);

            if (SqlConnection.State == System.Data.ConnectionState.Closed)
            {
                SqlConnection.Open();
            }
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = SqlConnection;
                oneSqlCommand.CommandText = "Proc_GF_GetMatchPlayOffList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);
                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PlayOffRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPlayOffRank);
                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguage);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                DataTable dr = new DataTable();
                dr.Load(sdr);
                dt = dr;
                sdr.Close();

                OVRDataBaseUtils.FillDataGridView(dgvGrid, dr, null, null);

                for (Int32 i = 0; i < dgvGrid.Columns.Count; i++)
                {
                    if (dgvGrid.Columns[i] != null)
                    {
                        String strFileName = dgvGrid.Columns[i].Name;

                        if (strFileName == "RegisterID")
                        {
                            dgvGrid.Columns[i].ReadOnly = true;
                            dgvGrid.Columns[i].Visible = false;
                        }

                        if (strFileName == "1" || strFileName == "2" || strFileName == "3" ||
                            strFileName == "4" || strFileName == "5" || strFileName == "6" ||
                            strFileName == "7" || strFileName == "8" || strFileName == "9" ||
                            strFileName == "10" || strFileName == "11" || strFileName == "12" ||
                            strFileName == "13" || strFileName == "14" || strFileName == "15" ||
                            strFileName == "16" || strFileName == "17" || strFileName == "18")
                        {
                            dgvGrid.Columns[i].ReadOnly = false;
                        }
                    }
                }
                dgvGrid.ClearSelection();
                dgvGrid.RowHeadersVisible = false;//不显示序号列
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            if (SqlConnection != null)
            {
                SqlConnection.Close();
            }
            return dt;
        }

        public Boolean SetMatchPlayOffPlayer(Int32 nMatchID, Int32 nPlayOffRank, Int32 nRegisterID, String strHoleSec)
        {
            Boolean bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_SetMatchPlayOffPlayer";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);
                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PlayOffRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPlayOffRank);
                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nRegisterID);
                SqlParameter cmdParameter4 = new SqlParameter(
                            "@HoleSec", SqlDbType.Char, 36,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strHoleSec);


                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    bResult = true;
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }
    }
}
