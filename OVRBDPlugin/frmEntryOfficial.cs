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
using System.Collections;
using DevComponents.DotNetBar;
using System.Windows.Controls;

namespace AutoSports.OVRBDPlugin
{
    public partial class frmEntryOfficial : Office2007Form
    {
        Int32 m_iMatchID;
        bool m_bIsTeam;
        ArrayList m_teamSplitIDs;
        public frmEntryOfficial(Int32 iMatchID, bool bIsTeam, ArrayList teamSplitIDs)
        {
            InitializeComponent();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvEventOfficials);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchOfficial);

            m_bIsTeam = bIsTeam;
            m_iMatchID = iMatchID;

            m_teamSplitIDs = teamSplitIDs;
        }

        //private void 
        private void InitMatches()
        {
            if (m_bIsTeam)
            {
                for (int i = 0; i < m_teamSplitIDs.Count; i++  )
                {
                    cmbMatches.Items.Add(string.Format("Match{0}", i + 1));
                }
              
                btnDel.Enabled = false;
                btnAdd.Enabled = false;
            }
            else
            {
                cmbMatches.Enabled = false;

                ResetMatchOfficials();
            }
            //cmbMatches.
        }

        private void frmEntryOfficial_Load(object sender, EventArgs e)
        {
            Localization();
            ResetEventOfficials();
           // ResetMatchOfficials();
            InitMatches();
        }

        private void Localization()
        {
            String strSectionName = BDCommon.m_strSectionName;
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmEntryOfficial");
            lbEventOfficial.Text = LocalizationRecourceManager.GetString(strSectionName, "lbAvailableOfficials");
            lbMatchOfficials.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMatchOfficials");
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            int maxUmpire = 3;//东南亚运动会由2修改为3
            if ( BDCommon.g_strDisplnCode == "TT")
            {
                maxUmpire = 3;
            }
            if (dgvEventOfficials.SelectedRows.Count + dgvMatchOfficial.RowCount > maxUmpire )
            {
                System.Windows.Forms.MessageBox.Show( string.Format("The count of Umpires can not greater than {0}! ", maxUmpire) );
                return;
            }
            for (Int32 i = 0; i < dgvEventOfficials.SelectedRows.Count; i++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvEventOfficials.SelectedRows[i];
                Int32 iRowIdx = row.Index;

                Int32 iRegisterID = GetFieldValue(dgvEventOfficials, iRowIdx, "F_RegisterID");
                Int32 iFunctionID = GetFieldValue(dgvEventOfficials, iRowIdx, "F_FunctionID");

                iFunctionID = iFunctionID == 0 ? -1 : iFunctionID;

                if ( !m_bIsTeam )
                {
                    AddMatchOfficials(m_iMatchID, -1, iRegisterID, iFunctionID);
                }
                else
                {
                    if ( cmbMatches.SelectedIndex >= 0 )
                    {
                        AddMatchOfficials(m_iMatchID, (int)m_teamSplitIDs[cmbMatches.SelectedIndex], iRegisterID, iFunctionID);
                    }
                    
                }
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
                if ( m_bIsTeam )
                {
                    if (cmbMatches.SelectedIndex >= 0)
                    {
                        DelMatchOfficials(m_iMatchID, (int)m_teamSplitIDs[cmbMatches.SelectedIndex], iRegisterID);
                    }
                }
                else
                {
                    DelMatchOfficials(m_iMatchID, -1, iRegisterID);
                }
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
                    if ( !m_bIsTeam )
                    {

                        BDCommon.g_ManageDB.UpdateMatchOfficialFunction(m_iMatchID, -1,iRegisterID, iInputKey);
                    }
                    else
                    {
                        if ( cmbMatches.SelectedIndex >= 0 )
                        {
                            BDCommon.g_ManageDB.UpdateMatchOfficialFunction(m_iMatchID, (int)m_teamSplitIDs[cmbMatches.SelectedIndex], iRegisterID, iInputKey);
                        }
                    }
                }

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
                    BDCommon.g_ManageDB.InitFunctionCombBox(ref dgvMatchOfficial, iColumnIndex, m_iMatchID);
                }
            }
        }

        private void ResetEventOfficials()
        {
            if ( !m_bIsTeam)
            {
                BDCommon.g_ManageDB.GetEventReferee(m_iMatchID, -1, dgvEventOfficials);
            }
            else
            {
                if ( cmbMatches.SelectedIndex >= 0)
                {
                    BDCommon.g_ManageDB.GetEventReferee(m_iMatchID, (int)m_teamSplitIDs[cmbMatches.SelectedIndex], dgvEventOfficials);
                }
            }
        }

        private void ResetMatchOfficials()
        {
            if ( m_bIsTeam )
            {
                if (cmbMatches.SelectedIndex >= 0)
                {
                    BDCommon.g_ManageDB.GetMatchRefereeToGridCtrl(m_iMatchID, (int)m_teamSplitIDs[cmbMatches.SelectedIndex], dgvMatchOfficial);
                }
            }
            else
            {
                BDCommon.g_ManageDB.GetMatchRefereeToGridCtrl(m_iMatchID, -1, dgvMatchOfficial);
            }
            SetGridStyle(dgvMatchOfficial);
        }

        private void AddMatchOfficials(Int32 nMatchID, Int32 nMatchSplitID, Int32 nRegisterID, Int32 nFunctionID)
        {
            BDCommon.g_ManageDB.AddMatchOfficial(nMatchID, nMatchSplitID, nRegisterID, nFunctionID);
        }

        private void DelMatchOfficials(Int32 nMatchID, Int32 nMatchSplitID, Int32 nRegisterID)
        {
            BDCommon.g_ManageDB.DelMatchOfficial(nMatchID,nMatchSplitID, nRegisterID);
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

        private void officalMatchesSelectChanged(object sender, EventArgs e)
        {
            if ( m_bIsTeam )
            {
                if ( cmbMatches.SelectedIndex < 0 )
                {
                    btnDel.Enabled = false;
                    btnAdd.Enabled = false;
                }
                else
                {
                    btnDel.Enabled = true;
                    btnAdd.Enabled = true;
                    ResetEventOfficials();
                    ResetMatchOfficials();
                }
            }
        }

        private void tbSearchOfficialChanged(object sender, EventArgs e)
        {
            lbSearchResult.Items.Clear();
            if (dgvEventOfficials.Rows.Count == 0 )
            {
                lbSearchResult.Visible = false;
                return;
            }
            string searchKeyWord = tbKeyWord.Text.Trim();
            if ( searchKeyWord != "")
            {
                lbSearchResult.Visible = true;
            }
            else
            {
                lbSearchResult.Visible = false;
                return;
            }
            foreach( DataGridViewRow row in dgvEventOfficials.Rows)
            {
                string strName = row.Cells["LongName"].Value.ToString();
                if ( strName.ToUpper().IndexOf(searchKeyWord.ToUpper()) != -1 )
                {
                    lbSearchResult.Items.Add(strName);
                }
            }
        }

        private void preKeyDown(object sender, PreviewKeyDownEventArgs e)
        {
            if ( e.KeyCode == Keys.Down)
            {
                if (lbSearchResult.Items.Count != 0)
                {
                    lbSearchResult.Focus();
                    lbSearchResult.SelectedIndex = 0;
                }
            }
            
        }

        private void lbSearchKeyDown(object sender, KeyEventArgs e)
        {
            if ( e.KeyCode == Keys.Return)
            {
                if (lbSearchResult.SelectedIndex < 0)
                {
                    return;
                }
                
                string selName = lbSearchResult.SelectedItem.ToString();
                foreach (DataGridViewRow row in dgvEventOfficials.Rows)
                {
                    string strName = row.Cells["LongName"].Value.ToString();
                    if ( strName == selName)
                    {
                        row.Selected = true;
                       
                    }
                    else
                    {
                        row.Selected = false;
                    }
                }
                lbSearchResult.Visible = false;
                btnAdd_Click(null, null);
                tbKeyWord.Focus();
                tbKeyWord.SelectAll();
            }
            
        }

        private void lbSearchMouseDown(object sender, MouseEventArgs e)
        {
            lbSearchResult.Visible = false;
        }
   
    }
}
