using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRGeneralData
{
    public partial class RegisterSelForm : UIForm
    {
        public Int32 m_SelRegisterID;
        private Int32 m_nEventID;
        private string m_strLanguageCode;
        private SqlConnection m_DatabaseConnection;
        private bool m_bUpdatingUI;

        public RegisterSelForm(Int32 iEventID, string strLanguageCode, SqlConnection dbConnection)
        {
            m_nEventID = iEventID;
            m_strLanguageCode = strLanguageCode;
            m_DatabaseConnection = dbConnection;

            InitializeComponent();
            OVRDataBaseUtils.SetDataGridViewStyle(dgvRegister);
            Localization();
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, this.Name);
        }

        private void frmEventRecords_Load(object sender, EventArgs e)
        {
            UpdateRegisterGrid();
        }

        private void UpdateGridView(DataGridView dgv, SqlDataReader sdr)
        {
            m_bUpdatingUI = true;
            Int32 iCurSel = -1;
            if (dgv.SelectedRows.Count != 0)
                iCurSel = dgv.SelectedRows[0].Index;

            OVRDataBaseUtils.FillDataGridView(dgv, sdr, null, null);

            if (dgv.Columns["ID"] != null)
                dgv.Columns["ID"].Visible = false;

            while (iCurSel >= dgv.Rows.Count)
                iCurSel--;

            if (iCurSel != -1)
            {
                dgv.Rows[iCurSel].Selected = true;
                dgv.FirstDisplayedScrollingRowIndex = iCurSel;
            }
            m_bUpdatingUI = false;
        }

        private void UpdateRegisterGrid()
        {
            if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_DatabaseConnection.Open();
            }

            try
            {

                SqlCommand cmd = new SqlCommand("Proc_GetRegisters", m_DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@EventID",
                            DataRowVersion.Current, m_nEventID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@LanguageCode", SqlDbType.Char, 3,
                             ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                             DataRowVersion.Current, m_strLanguageCode);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);

                SqlDataReader dr = cmd.ExecuteReader();
                UpdateGridView(dgvRegister, dr);
                dr.Close();

            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void btnOk_Click(object sender, EventArgs e)
        {
            Int32 iColIdxID = dgvRegister.Columns["F_RegisterID"].Index;
            if (dgvRegister.SelectedRows.Count == 0)
                return;

            m_SelRegisterID = Convert.ToInt32(dgvRegister.SelectedRows[0].Cells[iColIdxID].Value);
            this.DialogResult = DialogResult.OK;
        }

        private void btnCancle_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
        }
    }

}
