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

namespace AutoSports.OVRSEPlugin
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
                cmb_Regus.Enabled = true;
                SECommon.g_ManageDB.GetRegusList(m_iMatchID, cmb_Regus);

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
                cmb_Regus.Enabled = false;
                lbRegu.Text = "";
            }
        }

        private void Localization()
        {
            String strSectionName = SECommon.m_strSectionName;
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmEntryOfficial");
            lbEventOfficial.Text = LocalizationRecourceManager.GetString(strSectionName, "lbAvailableOfficials");
            lbMatchOfficials.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMatchOfficials");
            lbRegu.Text = LocalizationRecourceManager.GetString(strSectionName, "lbRegu");
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            for (Int32 i = 0; i < dgvEventOfficials.SelectedRows.Count; i++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvEventOfficials.SelectedRows[i];
                Int32 iRowIdx = row.Index;

                Int32 iRegisterID = GetFieldValue(dgvEventOfficials, iRowIdx, "F_RegisterID");

                AddMatchOfficials(m_iMatchID, m_iMatchSplitID, iRegisterID);
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
                DelMatchOfficials(m_iMatchID, m_iMatchSplitID, iRegisterID);
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
                    try
                    {
                        iInputValue = Convert.ToInt32(CurCell.Value);
                    }
                    catch (System.Exception ex)
                    {
                        ResetMatchOfficials();
                        return;
                    }
                }

                if (strColumnName.CompareTo("Function") == 0)
                {
                    SECommon.g_ManageDB.UpdateMatchOfficialFunction(m_iMatchID, m_iMatchSplitID, iRegisterID, iInputKey);
                }
                else if (strColumnName.CompareTo("Order") == 0)
                {
                    SECommon.g_ManageDB.UpdateMatchOfficialOrder(m_iMatchID, m_iMatchSplitID, iRegisterID, iInputValue);
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
                    SECommon.g_ManageDB.InitFunctionCombBox(ref dgvMatchOfficial, iColumnIndex, m_iMatchID, "S");
                }
            }
        }

        private void cmb_Regus_SelectionChangeCommitted(object sender, EventArgs e)
        {
            m_iMatchSplitID = -1;
            int nSelIdx = -1;

            if (cmb_Regus.SelectedItem == null)
                return;

            nSelIdx = cmb_Regus.SelectedIndex;
            m_iMatchSplitID = Convert.ToInt32(cmb_Regus.SelectedValue);

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

        private void ResetEventOfficials()
        {
            SECommon.g_ManageDB.GetEventReferee(m_iMatchID, m_iMatchType, m_iMatchSplitID, dgvEventOfficials);
        }

        private void ResetMatchOfficials()
        {
            SECommon.g_ManageDB.GetMatchReferee(m_iMatchID, m_iMatchType, m_iMatchSplitID, dgvMatchOfficial);
            SetGridStyle(dgvMatchOfficial);
        }

        private void AddMatchOfficials(Int32 nMatchID, Int32 nMatchSplitID, Int32 nRegisterID)
        {
            SECommon.g_ManageDB.AddMatchOfficial(nMatchID, nMatchSplitID, nRegisterID);
        }

        private void DelMatchOfficials(Int32 nMatchID, Int32 nMatchSplitID, Int32 nRegisterID)
        {
            SECommon.g_ManageDB.DelMatchOfficial(nMatchID, nMatchSplitID, nRegisterID);
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
                if (dgvMatchOfficial.Columns["Order"] != null)
                {
                    dgvMatchOfficial.Columns["Order"].ReadOnly = false;
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

        private void lbSearchResult_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Return)
            {
                if (lbSearchResult.SelectedIndex < 0)
                {
                    return;
                }

                string selName = lbSearchResult.SelectedItem.ToString();
                foreach (DataGridViewRow row in dgvEventOfficials.Rows)
                {
                    string strName = row.Cells["LongName"].Value.ToString();
                    if (strName == selName)
                    {
                        row.Selected = true;

                    }
                    else
                    {
                        row.Selected = false;
                    }
                }
                lbSearchResult.Visible = false;
                //团体赛，没有选择submatch时，则不添加
                if (m_iMatchType == 3 && cmb_Regus.SelectedIndex == 0)
                {
                    ;
                }
                else
                {
                    btnAdd_Click(null, null);
                }

                tbKeyWord.Focus();
                tbKeyWord.SelectAll();
            }
        }

        private void lbSearchResult_MouseDown(object sender, MouseEventArgs e)
        {
            lbSearchResult.Visible = false;
        }

        private void tbKeyWord_TextChanged(object sender, EventArgs e)
        {
            lbSearchResult.Items.Clear();
            if (dgvEventOfficials.Rows.Count == 0)
            {
                lbSearchResult.Visible = false;
                return;
            }
            string searchKeyWord = tbKeyWord.Text.Trim();
            if (searchKeyWord != "")
            {
                lbSearchResult.Visible = true;
            }
            else
            {
                lbSearchResult.Visible = false;
                return;
            }
            foreach (DataGridViewRow row in dgvEventOfficials.Rows)
            {
                string strName = row.Cells["LongName"].Value.ToString();
                if (strName.ToUpper().IndexOf(searchKeyWord.ToUpper()) != -1)
                {
                    lbSearchResult.Items.Add(strName);
                }
            }
        }

        private void tbKeyWord_PreviewKeyDown(object sender, PreviewKeyDownEventArgs e)
        {
            if (e.KeyCode == Keys.Down)
            {
                if (lbSearchResult.Items.Count != 0)
                {
                    lbSearchResult.Focus();
                    lbSearchResult.SelectedIndex = 0;
                }
            }
        }
    }
}
