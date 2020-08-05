using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using System.Data.SqlClient;
using AutoSports.OVRVBPlugin;

namespace AutoSports.OVRVBPlugin
{
    public partial class frmOfficialEntry : DevComponents.DotNetBar.Office2007Form
    {
		private Int32 m_nMatchID;
		private Int32 m_nDisciplineID;
		private String m_strSectionName;
		private String m_strLanguageCode;

        public frmOfficialEntry(Int32 nMatchID, Int32 nDiscID, String strSectionName, String strLangCode)
        {
            InitializeComponent();

            m_nMatchID = nMatchID;
			m_nDisciplineID = nDiscID;
			m_strLanguageCode = strLangCode;
			m_strSectionName = strSectionName;
        }

        private void frmOfficialEntry_Load(object sender, EventArgs e)
        {
            //Localization();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvAvailOfficial);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchScoreOfficial);

            ResetAvailableOfficial();
            ResetMatchOfficial();
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            int iColIdx = dgvAvailOfficial.Columns["F_RegisterID"].Index;
            int iFuncColIdx = dgvAvailOfficial.Columns["F_FunctionID"].Index;

            for (int i = 0; i < dgvAvailOfficial.SelectedRows.Count; i++)
            {
                int iRowIdx = dgvAvailOfficial.SelectedRows[i].Index;

                string strRegisterID = dgvAvailOfficial.Rows[iRowIdx].Cells[iColIdx].Value.ToString();
                string strFunctionID = dgvAvailOfficial.Rows[iRowIdx].Cells[iFuncColIdx].Value.ToString();

                int iRegisterID = Str2Int(strRegisterID);
                int iFunctionID = 0;
                if (strFunctionID.Length == 0)
                {
                    iFunctionID = -1;
                }
                else
                {
                    iFunctionID = Str2Int(strFunctionID);
                }
                 AddMatchOfficial(m_nMatchID, iRegisterID, iFunctionID);
            }
            ResetAvailableOfficial();
            ResetMatchOfficial();
        }

        private void btnRemove_Click(object sender, EventArgs e)
        {
            int iColIdx = dgvMatchScoreOfficial.Columns["F_RegisterID"].Index;

            for (int i = 0; i < dgvMatchScoreOfficial.SelectedRows.Count; i++)
            {
                int iRowIdx = dgvMatchScoreOfficial.SelectedRows[i].Index;

                string strRegisterID = dgvMatchScoreOfficial.Rows[iRowIdx].Cells[iColIdx].Value.ToString();

                int iRegisterID = Str2Int(strRegisterID);
                RemoveMatchOfficial(m_nMatchID, iRegisterID);
            }
            ResetAvailableOfficial();
            ResetMatchOfficial();
        }

        private void dgvMatchScoreOfficial_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvMatchScoreOfficial.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex >= 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                if (dgvMatchScoreOfficial.Columns[iColumnIndex].Name.CompareTo("Function") == 0)
                {
                     InitFunctionCombBox(ref dgvMatchScoreOfficial, iColumnIndex, "S");
                }
            }
        }

        private void dgvMatchScoreOfficial_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex < 0 || e.RowIndex < 0)
                return;

            int iColumnIndex = e.ColumnIndex;
            int iRowIndex = e.RowIndex;
            String strColumnName = dgvMatchScoreOfficial.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvMatchScoreOfficial.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                int iFunctionID = 0;
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    iFunctionID = Str2Int(CurCell1.Tag);
                }
                else
                {
                    return;
                }

                int iRegisterID = Str2Int(dgvMatchScoreOfficial.Rows[iRowIndex].Cells["F_RegisterID"].Value);
                UpdateOfficialFunction(m_nMatchID, iRegisterID, iFunctionID);
            }
            ResetMatchOfficial();
        }

        private void Localization()
        {
			this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmEntryOfficial");
			lbAvailOfficial.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbAvailableOfficial");
			lbMatchOfficial.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMatchOfficial");
        }

        private void ResetAvailableOfficial()
        {
            ResetAvailableOfficial(m_nMatchID, dgvAvailOfficial);
        }

        private void ResetMatchOfficial()
        {
            ResetMatchOfficial(m_nMatchID, dgvMatchScoreOfficial);
        }

        public static Int32 Str2Int(Object strObj)
        {
            if (strObj == null) return 0;

            if (strObj.ToString().Length == 0) return 0;

            try
            {
                return Convert.ToInt32(strObj);
            }
            catch (System.Exception errorFmt)
            {
                MessageBox.Show(errorFmt.ToString());
            }
            return 0;
        }

        public void UpdateOfficialFunction(int iMatchID, int iRegisterID, int iFunctionID)
        {
            if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                Common.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchOfficial Function

				SqlCommand cmd = new SqlCommand("Proc_VB_EXT_MatchOfficialFunctionUpdate", Common.g_DataBaseCon);
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

        public void ResetMatchOfficial(int iMatchID, DataGridView dgv)
        {
            if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                Common.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for Get MatchOfficial
				SqlCommand cmd = new SqlCommand("Proc_VB_EXT_MatchOfficialGetList", Common.g_DataBaseCon);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = m_strLanguageCode;

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

        public void RemoveMatchOfficial(int iMatchID, int iRegisterID)
        {
            if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                Common.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for Remove MatchOfficial

				SqlCommand cmd = new SqlCommand("Proc_VB_EXT_MatchOfficialRemove", Common.g_DataBaseCon);
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
            if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                Common.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for Fill Function combo

				SqlCommand cmd = new SqlCommand("Proc_VB_EXT_FunctionsGetList", Common.g_DataBaseCon);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter2 = new SqlParameter("@CategoryCode", SqlDbType.NVarChar, 20);

                cmdParameter0.Value = m_nDisciplineID;
                cmdParameter1.Value = m_strLanguageCode;
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

        public void ResetAvailableOfficial(int iMatchID, DataGridView dgv)
        {
            if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                Common.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleOfficial
				SqlCommand cmd = new SqlCommand("Proc_VB_EXT_AvailableOfficialGetList", Common.g_DataBaseCon);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = m_nDisciplineID;
                cmdParameter1.Value = iMatchID;
                cmdParameter2.Value = m_strLanguageCode;

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

        public void AddMatchOfficial(int iMatchID, int iRegisterID, int iFunctionID)
        {
            if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                Common.g_DataBaseCon.Open();
            }

            try
            {
                #region DML Command Setup for Add MatchOfficial

				SqlCommand cmd = new SqlCommand("Proc_VB_EXT_MatchOfficialAdd", Common.g_DataBaseCon);
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
    }
}
