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

namespace AutoSports.OVRARPlugin
{
    public partial class frmOVROfficialEntry : DevComponents.DotNetBar.Office2007Form
    {
        public String m_strLanguageCode = "ENG";
        public Int32 m_iDisciplineID;
        private int m_iMatchID;

        public frmOVROfficialEntry(int iMatchID)
        {
            InitializeComponent();

            m_iMatchID = iMatchID;
        }

        private void frmOfficialEntry_Load(object sender, EventArgs e)
        {
            Localization();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvAvailOfficial);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchOfficial);

            ResetAvailableOfficial();
            ResetMatchOfficial();
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            if (m_iMatchID > 0)
            {
                int iColIdx = dgvAvailOfficial.Columns["F_RegisterID"].Index;
                int iFuncColIdx = dgvAvailOfficial.Columns["F_FunctionID"].Index;
                int iPosiColIdx = dgvAvailOfficial.Columns["F_PositionID"].Index;

                for (int i = 0; i < dgvAvailOfficial.SelectedRows.Count; i++)
                {
                    int iRowIdx = dgvAvailOfficial.SelectedRows[i].Index;

                    string strRegisterID = dgvAvailOfficial.Rows[iRowIdx].Cells[iColIdx].Value.ToString();
                    string strFunctionID = dgvAvailOfficial.Rows[iRowIdx].Cells[iFuncColIdx].Value.ToString();
                    string strPositionID = dgvAvailOfficial.Rows[iRowIdx].Cells[iPosiColIdx].Value.ToString();

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
                    AddMatchOfficial(m_iMatchID, iRegisterID, iFunctionID);
                }
                ResetAvailableOfficial();
                ResetMatchOfficial();
            }
        }

        private void btnRemove_Click(object sender, EventArgs e)
        {
            if (m_iMatchID > 0)
            {
                int iColIdx = dgvMatchOfficial.Columns["F_RegisterID"].Index;

                for (int i = 0; i < dgvMatchOfficial.SelectedRows.Count; i++)
                {
                    int iRowIdx = dgvMatchOfficial.SelectedRows[i].Index;

                    string strRegisterID = dgvMatchOfficial.Rows[iRowIdx].Cells[iColIdx].Value.ToString();

                    int iRegisterID = Str2Int(strRegisterID);
                    RemoveMatchOfficial(m_iMatchID, iRegisterID);
                }
                ResetAvailableOfficial();
                ResetMatchOfficial();
            }
        }

        private void dgvMatchOfficial_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvMatchOfficial.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex >= 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                if (dgvMatchOfficial.Columns[iColumnIndex].Name.CompareTo("Function") == 0)
                {
                    InitFunctionCombBox(ref dgvMatchOfficial, iColumnIndex, "S");
                }
                else if (dgvMatchOfficial.Columns[iColumnIndex].Name.CompareTo("Position") == 0)
                {
                    InitPositionCombBox(ref dgvMatchOfficial, iColumnIndex);
                }
            }
        }

        private void dgvMatchOfficial_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex < 0 || e.RowIndex < 0)
                return;

            int iColumnIndex = e.ColumnIndex;
            int iRowIndex = e.RowIndex;
            //String strColumnName = dgvMatchOfficial.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvMatchOfficial.Rows[iRowIndex].Cells[iColumnIndex];
            if (CurCell != null)
            {
                if (CurCell is DGVCustomComboBoxCell)
                {
                    int iRegisterID = Str2Int(dgvMatchOfficial.Rows[iRowIndex].Cells["F_RegisterID"].Value);
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    switch (dgvMatchOfficial.Columns[iColumnIndex].Name)
                    {
                        case "Function":
                            int iFunctionID = 0;
                            iFunctionID = Str2Int(CurCell.Tag);
                            UpdateOfficialFunction(m_iMatchID, iRegisterID, iFunctionID);
                            break;
                        case "Position":
                            int iPositionID = 0;
                            iPositionID = Str2Int(CurCell.Tag);
                            UpdateOfficialPosition(m_iMatchID, iRegisterID, iPositionID);
                            break;
                    }
                }
            }
            ResetMatchOfficial();
        }

        private void Localization()
        {
            String strSectionName = "OVRWLPlugin";
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRWLPlugin_OVRWLDataEntryForm_frmEntryOfficial");
            lbAvailOfficial.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRWLPlugin_OVRWLDataEntryForm_labX_AvailableOfficial");
            lbMatchOfficial.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRWLPlugin_OVRWLDataEntryForm_labX_MatchOfficial");
        }

        private void ResetAvailableOfficial()
        {
            ResetAvailableOfficial(m_iMatchID, dgvAvailOfficial);
        }

        private void ResetMatchOfficial()
        {
            ResetMatchOfficial(m_iMatchID, dgvMatchOfficial);
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
            System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
            if (con.State != ConnectionState.Open)
                con.Open();

            try
            {
                #region DML Command Setup for Update MatchOfficial Function

                SqlCommand cmd = new SqlCommand("Proc_WL_UpdateMatchOfficialFunction", con);
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

        public void UpdateOfficialPosition(int iMatchID, int iRegisterID, int iPositionID)
        {
            System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
            if (con.State != ConnectionState.Open)
                con.Open();

            try
            {
                #region DML Command Setup for Update MatchOfficial Function

                SqlCommand cmd = new SqlCommand("Proc_WL_UpdateMatchOfficialPosition", con);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@PositionID", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = iRegisterID;
                cmdParameter2.Value = iPositionID;
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
            System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
            if (con.State != ConnectionState.Open)
                con.Open();

            try
            {
                #region DML Command Setup for Get MatchOfficial
                SqlCommand cmd = new SqlCommand("Proc_AR_GetMatchOfficial", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = m_strLanguageCode;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgv, dr, new string[] { "Function", "Position" });

                if (dgv.RowCount >= 0)
                {
                    dgv.Columns["F_RegisterID"].Visible = false;
                    dgv.Columns["Group"].Visible = false;
                    dgv.Columns["Position"].Visible = false;
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
            System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
            if (con.State != ConnectionState.Open)
                con.Open();

            try
            {
                #region DML Command Setup for Remove MatchOfficial

                SqlCommand cmd = new SqlCommand("Proc_AR_RemoveMatchOfficial", con);
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
            System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
            if (con.State != ConnectionState.Open)
                con.Open();

            try
            {
                #region DML Command Setup for Fill Function combo

                SqlCommand cmd = new SqlCommand("Proc_WP_GetFunctions", con);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter2 = new SqlParameter("@CategoryCode", SqlDbType.NVarChar, 20);

                cmdParameter0.Value = m_iDisciplineID;
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

        public void InitPositionCombBox(ref DataGridView dgv, int iColumnIndex)
        {
            System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
            if (con.State != ConnectionState.Open)
                con.Open();

            try
            {
                #region DML Command Setup for Fill Position combo

                SqlCommand cmd = new SqlCommand("Proc_GetPosition", con);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = m_iDisciplineID;
                cmdParameter1.Value = m_strLanguageCode;

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

        public void ResetAvailableOfficial(int iMatchID, DataGridView dgv)
        {
            System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
            if (con.State != ConnectionState.Open)
                con.Open();

            try
            {
                #region DML Command Setup for Get AvailbleOfficial
                SqlCommand cmd = new SqlCommand("Proc_AR_GetAvailableOfficial", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = m_iDisciplineID;
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
                    dgv.Columns["F_OfficialGroupID"].Visible = false;
                    dgv.Columns["F_PositionID"].Visible = false;
                    dgv.Columns["Group"].Visible = false;
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
            System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
            if (con.State != ConnectionState.Open)
                con.Open();

            try
            {
                #region DML Command Setup for Add MatchOfficial

                SqlCommand cmd = new SqlCommand("Proc_AR_AddMatchOfficial", con);
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
