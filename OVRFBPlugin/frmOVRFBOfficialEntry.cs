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
using DevComponents.DotNetBar.Controls;

namespace AutoSports.OVRFBPlugin
{
    public partial class frmOVRFBOfficialEntry : Office2007Form
    {
         private int m_iMatchID;

        public frmOVRFBOfficialEntry(int iMatchID)
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
            InitPeriodCmb();
            tbAttendance.Text = GVAR.g_ManageDB.GetMatchAttendance(m_iMatchID);
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
                GVAR.g_ManageDB.AddMatchOfficial(m_iMatchID, iRegisterID, iFunctionID);
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
                GVAR.g_ManageDB.RemoveMatchOfficial(m_iMatchID, iRegisterID);
            }
            ResetAvailableOfficial();
            ResetMatchOfficial();
        }

        private void dgvMatchOfficial_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvMatchOfficial.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex >= 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                if (dgvMatchOfficial.Columns[iColumnIndex].Name.CompareTo("Function") == 0)
                {
                    GVAR.g_ManageDB.InitFunctionCombBox(ref dgvMatchOfficial, iColumnIndex, "S");
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
                int iFunctionID = 0;
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    iFunctionID = GVAR.Str2Int(CurCell1.Tag);
                }
                else
                {
                    return;
                }

                int iRegisterID = GVAR.Str2Int(dgvMatchOfficial.Rows[iRowIndex].Cells["F_RegisterID"].Value);
                GVAR.g_ManageDB.UpdateOfficialFunction(m_iMatchID, iRegisterID, iFunctionID);
            }
            ResetMatchOfficial();
        }

        private void Localization()
        {
            String strSectionName = GVAR.g_FBPlugin.GetSectionName();
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmEntryOfficial");
            lbAvailOfficial.Text = LocalizationRecourceManager.GetString(strSectionName, "lbAvailableOfficial");
            lbMatchOfficial.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMatchOfficial");
            lbAttendance.Text = LocalizationRecourceManager.GetString(strSectionName, "lbAttendance");
            lbMatchMode.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMatchMode");
        }

        private void ResetAvailableOfficial()
        {
            GVAR.g_ManageDB.ResetAvailableOfficial(m_iMatchID, dgvAvailOfficial);
        }

        private void ResetMatchOfficial()
        {
            GVAR.g_ManageDB.ResetMatchOfficial(m_iMatchID, dgvMatchOfficial);
        }

        private void InitPeriodCmb()
        {
            int iMatchPeriod = 0;
            GVAR.g_ManageDB.GetMatchPeriodSetting(m_iMatchID, ref iMatchPeriod);
            GVAR.g_MatchPeriodSet = iMatchPeriod;
            cmbPeriod.DisplayMember = "PeriodName";
            cmbPeriod.ValueMember = "PeriodID";
            DataTable dt_Period = new DataTable();
            dt_Period.Columns.Add("PeriodName");
            dt_Period.Columns.Add("PeriodID");
           
            if (GVAR.g_ManageDB.m_strActiveLanguage=="CHN")
            {
                dt_Period.Rows.Add("2节", 0);
                dt_Period.Rows.Add("2节+点球", 1);
                dt_Period.Rows.Add("5节", 2);
            } 
            else
            {
                dt_Period.Rows.Add("2 P", 0);
                dt_Period.Rows.Add("2 P + PSO", 1);
                dt_Period.Rows.Add("5 P", 2);
            }
           
            cmbPeriod.DataSource = dt_Period;
            cmbPeriod.SelectedValue = iMatchPeriod;
        }
        private void cmbPeriod_SelectedIndexChanged(object sender, EventArgs e)
        {
            int m_iPeriod = GVAR.Str2Int(cmbPeriod.SelectedValue);

            GVAR.g_ManageDB.UpdateMatchPeriodsSet(m_iMatchID, m_iPeriod);
            GVAR.g_MatchPeriodSet = m_iPeriod;
        }

        private void tbAttendance_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == 13)
            {
                lbMatchOfficial.Focus();
                e.Handled = true;
            }
            if (e.KeyChar != 8 && e.KeyChar!= '.' &&e.KeyChar!= '-' &&
                !Char.IsDigit(e.KeyChar))
            {
                e.Handled = true;
            }
        }
        protected override void OnClosing(System.ComponentModel.CancelEventArgs e)
        {
            lbMatchOfficial.Focus();
        }
        public void tbAttendance_Leave(object sender, EventArgs e)
        {
            TextBoxX tb = (TextBoxX)sender;

            int nResult = 0;
            if (int.TryParse(tb.Text, out nResult))
            {
                tb.Text = nResult.ToString();
            }
            else
            {
                tb.Text = "";
            }

            GVAR.g_ManageDB.UpdateMatchAttendance(m_iMatchID, tb.Text);
        }
    }
}
