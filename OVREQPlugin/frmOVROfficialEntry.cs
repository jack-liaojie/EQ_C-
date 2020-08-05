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
using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    public partial class frmOVROfficialEntry : UIForm
    {
        #region Property
        private String m_strLanguageCode = "ENG";
        public String LanguageCode
        {
            get { return m_strLanguageCode; }
            set { m_strLanguageCode = value; }
        }

        private Int32 m_iDisciplineID;
        public Int32 DisciplineID
        {
            get { return m_iDisciplineID; }
            set { m_iDisciplineID = value; }
        }

        private int m_iMatchID;
        #endregion

        #region Constructor
        public frmOVROfficialEntry(int iMatchID)
        {
            InitializeComponent();
            Localization();
            m_iMatchID = iMatchID;
        }

        private void Localization()
        {
            String strSectionName = GVAR.g_strSectionName;
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmEntryOfficial");
            lbAvailOfficial.Text = LocalizationRecourceManager.GetString(strSectionName, "lbAvailableOfficial");
            lbMatchOfficial.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMatchOfficial");
        }
        #endregion

        #region FormLoad
        private void frmOfficialEntry_Load(object sender, EventArgs e)
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvAvailOfficial);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchOfficial);
            ResetAvailableOfficial();
            ResetMatchOfficial();
        }
        #endregion

        #region MatchOfficial DGV
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
                if (dgvMatchOfficial.Columns[iColumnIndex].Name.CompareTo("Position") == 0)
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
            String strColumnName = dgvMatchOfficial.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvMatchOfficial.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                int iRegisterID = GVAR.Str2Int(dgvMatchOfficial.Rows[iRowIndex].Cells["F_RegisterID"].Value);
                int iFunctionID = 0;
                int iPositionID = 0;
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    if (strColumnName.CompareTo("Function") == 0)
                    {
                        iFunctionID = GVAR.Str2Int(CurCell1.Tag);
                        UpdateOfficialFunction(m_iMatchID, iRegisterID, iFunctionID);
                    }
                    else
                    {
                        iPositionID = GVAR.Str2Int(CurCell1.Tag);
                        UpdateOfficialPosition(m_iMatchID, iRegisterID, iPositionID);
                    }
                }
                else
                {
                    return;
                }
            }
            ResetMatchOfficial();
        }

        private void ResetMatchOfficial()
        {
            ResetMatchOfficial(m_iMatchID, dgvMatchOfficial);
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
                SqlCommand cmd = new SqlCommand("Proc_EQ_GetMatchOfficial", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = iMatchID;
                cmdParameter1.Value = m_strLanguageCode;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgv, dr, "Function", "Position");

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
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Remove MatchOfficial

                SqlCommand cmd = new SqlCommand("Proc_EQ_RemoveMatchOfficial", GVAR.g_adoDataBase.DBConnect);
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

        private void ResetAvailableOfficial()
        {
            ResetAvailableOfficial(m_iMatchID, dgvAvailOfficial);
        }

        public void ResetAvailableOfficial(int iMatchID, DataGridView dgv)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleOfficial
                SqlCommand cmd = new SqlCommand("Proc_EQ_GetAvailableOfficial", GVAR.g_adoDataBase.DBConnect);
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
                    dgv.Columns["Function"].Visible = false;
                }
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

                SqlCommand cmd = new SqlCommand("Proc_EQ_UpdateMatchOfficialFunction", GVAR.g_adoDataBase.DBConnect);
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
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Update MatchOfficial Position

                SqlCommand cmd = new SqlCommand("Proc_EQ_UpdateMatchOfficialPosition", GVAR.g_adoDataBase.DBConnect);
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

        public void InitFunctionCombBox(ref UIDataGridView dgv, int iColumnIndex, string strFunType)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Fill Function combo

                SqlCommand cmd = new SqlCommand("Proc_EQ_GetFunctions", GVAR.g_adoDataBase.DBConnect);
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

        public void InitPositionCombBox(ref UIDataGridView dgv, int iColumnIndex)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            try
            {
                #region DML Command Setup for Fill Position combo

                SqlCommand cmd = new SqlCommand("Proc_EQ_GetPositions", GVAR.g_adoDataBase.DBConnect);
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
                table.Columns.Add("F_PositionCode", typeof(string));
                table.Columns.Add("F_PositionID", typeof(int));
                table.Rows.Add("", "-1");
                table.Load(dr);

                (dgv.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(table, "F_PositionCode", "F_PositionID");
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

                SqlCommand cmd = new SqlCommand("Proc_EQ_AddMatchOfficial", GVAR.g_adoDataBase.DBConnect);
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
        #endregion

        #region ButtonClick
        private void btnAdd_Click(object sender, EventArgs e)
        {
            int iColIdx = dgvAvailOfficial.Columns["F_RegisterID"].Index;
            int iFuncColIdx = dgvAvailOfficial.Columns["F_FunctionID"].Index;

            for (int i = 0; i < dgvAvailOfficial.SelectedRows.Count; i++)
            {
                int iRowIdx = dgvAvailOfficial.SelectedRows[i].Index;

                string strRegisterID = dgvAvailOfficial.Rows[iRowIdx].Cells[iColIdx].Value.ToString();
                string strFunctionID = dgvAvailOfficial.Rows[iRowIdx].Cells[iFuncColIdx].Value.ToString();

                int iRegisterID = GVAR.Str2Int(strRegisterID);
                int iFunctionID = 0;
                if (strFunctionID.Length == 0)
                {
                    iFunctionID = -1;
                }
                else
                {
                    iFunctionID = GVAR.Str2Int(strFunctionID);
                }
                AddMatchOfficial(m_iMatchID, iRegisterID, iFunctionID);
            }
            ResetAvailableOfficial();
            ResetMatchOfficial();
        }

        private void btnRemove_Click(object sender, EventArgs e)
        {
            int iColIdx = dgvMatchOfficial.Columns["F_RegisterID"].Index;

            for (int i = 0; i < dgvMatchOfficial.SelectedRows.Count; i++)
            {
                int iRowIdx = dgvMatchOfficial.SelectedRows[i].Index;

                string strRegisterID = dgvMatchOfficial.Rows[iRowIdx].Cells[iColIdx].Value.ToString();

                int iRegisterID = GVAR.Str2Int(strRegisterID);
                RemoveMatchOfficial(m_iMatchID, iRegisterID);
            }
            ResetAvailableOfficial();
            ResetMatchOfficial();
        }
        #endregion
    }
}
