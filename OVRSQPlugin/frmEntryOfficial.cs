using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows;
using System.Windows.Forms;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

using DevComponents.DotNetBar;

namespace AutoSports.OVRSQPlugin
{
    public partial class frmEntryOfficial : Office2007Form
    {
        Int32 m_iMatchID;
        Int32 m_iMatchType;
        Int32 m_iMatchSplitID;

        public frmEntryOfficial(Int32 iMatchID, Int32 iMatchType)
        {
            InitializeComponent();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvEventOfficials);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchOfficial);

            m_iMatchID = iMatchID;
            m_iMatchType = iMatchType;
            m_iMatchSplitID = -1;
        }

        private void frmEntryOfficial_Load(object sender, EventArgs e)
        {
            Localization();
            ResetEventOfficials();
            ResetMatchOfficials();

            if (m_iMatchType == 3)
            {
                cmb_SubMatch.Enabled = true;
                SQCommon.g_ManageDB.GetRegusList(m_iMatchID, cmb_SubMatch);

                if (m_iMatchSplitID == -1)
                {
                    btnAdd.Enabled = false;
                    btnDel.Enabled = false;
                }
                else
                {
                    btnAdd.Enabled = true;
                    btnDel.Enabled = true;
                }
            }
            else
            {
                cmb_SubMatch.Enabled = false;
                cmb_SubMatch.Text = "";
            }
        }

        private void Localization()
        {
            String strSectionName = SQCommon.m_strSectionName;
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmEntryOfficial");
            lbEventOfficial.Text = LocalizationRecourceManager.GetString(strSectionName, "lbAvailableOfficials");
            lbMatchOfficials.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMatchOfficials");
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            for (Int32 i = 0; i < dgvEventOfficials.SelectedRows.Count; i++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvEventOfficials.SelectedRows[i];
                Int32 iRowIdx = row.Index;

                Int32 iRegisterID = GetFieldValue(dgvEventOfficials, iRowIdx, "F_RegisterID");

                AddMatchOfficials(m_iMatchID, iRegisterID, m_iMatchSplitID);
            }

            ResetEventOfficials();
            ResetMatchOfficials();
        }

        private void btnDel_Click(object sender, EventArgs e)
        {
            for (Int32 i = 0; i < dgvMatchOfficial.SelectedRows.Count; i++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvMatchOfficial.SelectedRows[i];
                Int32 iRowIdx = row.Index;

                Int32 iRegisterID = GetFieldValue(dgvMatchOfficial, iRowIdx, "F_RegisterID");
                DelMatchOfficials(m_iMatchID, iRegisterID, m_iMatchSplitID);
            }

            ResetEventOfficials();
            ResetMatchOfficials();
        }

        private void dgvMatchOfficial_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            String strColumnName = dgvMatchOfficial.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvMatchOfficial.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                Int32 iRegisterID = GetFieldValue(dgvMatchOfficial, iRowIndex, "F_RegisterID");

                Int32 iInputValue = 0;
                Int32 iInputKey = 0;
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    iInputKey = Convert.ToInt32(CurCell1.Tag);
                }
                else
                {
                    iInputValue = Convert.ToInt32(CurCell.Value);
                }

                if (strColumnName.CompareTo("Function") == 0)
                {
                    SQCommon.g_ManageDB.UpdateMatchOfficialFunction(m_iMatchID, iRegisterID, m_iMatchSplitID, iInputKey);
                }

                ResetMatchOfficials();
                dgvMatchOfficial.Rows[iRowIndex].Selected = true;
            }
        }

        private void dgvMatchOfficial_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvMatchOfficial.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex < 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                if (dgvMatchOfficial.Columns[iColumnIndex].Name.CompareTo("Function") == 0)
                {
                    SQCommon.g_ManageDB.InitFunctionCombBox(ref dgvMatchOfficial, iColumnIndex, m_iMatchID);
                }
            }
        }

        private void ResetEventOfficials()
        {
            SQCommon.g_ManageDB.GetEventReferee(m_iMatchID, m_iMatchSplitID, dgvEventOfficials);
        }

        private void ResetMatchOfficials()
        {
            SQCommon.g_ManageDB.GetMatchReferee(m_iMatchID, m_iMatchSplitID, dgvMatchOfficial);
            SetGridStyle(dgvMatchOfficial);
        }

        private void AddMatchOfficials(Int32 nMatchID, Int32 nRegisterID, Int32 nMatchSplitID)
        {
            SQCommon.g_ManageDB.AddMatchOfficial(nMatchID, nRegisterID, nMatchSplitID);
        }

        private void DelMatchOfficials(Int32 nMatchID, Int32 nRegisterID, Int32 nMatchSplitID)
        {
            SQCommon.g_ManageDB.DelMatchOfficial(nMatchID, nRegisterID, nMatchSplitID);
        }

        private void cmb_SubMatch_SelectionChangeCommitted(object sender, EventArgs e)
        {
            m_iMatchSplitID = -1;
            int nSelIdx = -1;

            if (cmb_SubMatch.SelectedItem == null)
                return;

            nSelIdx = cmb_SubMatch.SelectedIndex;
            m_iMatchSplitID = Convert.ToInt32(cmb_SubMatch.SelectedValue);

            if (m_iMatchSplitID == -1)
            {
                btnAdd.Enabled = false;
                btnDel.Enabled = false;
            }
            else
            {
                btnAdd.Enabled = true;
                btnDel.Enabled = true;
            }

            ResetEventOfficials();
            ResetMatchOfficials();
        }

        private void SetGridStyle(DataGridView dgv)
        {
            dgv.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;

            if (dgv == dgvMatchOfficial)
            {
                if (dgvMatchOfficial.Columns["Function"] != null)
                {
                    dgvMatchOfficial.Columns["Function"].ReadOnly = false;
                }
            }
        }

        private Int32 GetFieldValue(DataGridView dgv, Int32 iRowIndex, String strFiledName)
        {
            Int32 iReturnValue = 0;
            if (dgv.Columns[strFiledName] == null || dgv.Rows[iRowIndex].Cells[strFiledName].Value.ToString() == "")
            {
                iReturnValue = 0;
            }
            else
            {
                iReturnValue = Convert.ToInt32(dgv.Rows[iRowIndex].Cells[strFiledName].Value);
            }
            return iReturnValue;
        }

        private String GetFieldStringValue(DataGridView dgv, Int32 iRowIndex, String strFiledName)
        {
            String iReturnValue = "";
            if (dgv.Columns[strFiledName] == null || dgv.Rows[iRowIndex].Cells[strFiledName].Value.ToString() == "")
            {
                iReturnValue = "";
            }
            else
            {
                iReturnValue = Convert.ToString(dgv.Rows[iRowIndex].Cells[strFiledName].Value);
            }
            return iReturnValue;
        }
    }
}
