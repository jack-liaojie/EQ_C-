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

namespace AutoSports.OVRWPPlugin
{
    public partial class frmOVRWPPenaltyPlayer : DevComponents.DotNetBar.Office2007Form
    {
        private int m_iMatchID;
        private int m_iMatchSplitID;
        private int m_iHomeRegisterID;
        private int m_iVisitRegisterID;
        private string m_strHomeName;
        private string m_strVisitName;

        public frmOVRWPPenaltyPlayer(int iMatchID, int iMatchSplitID, int iHRegID, int iVRegID, string strHName, string strVName)
        {
            InitializeComponent();

            m_iMatchID = iMatchID;
            m_iMatchSplitID = iMatchSplitID;
            m_iHomeRegisterID = iHRegID;
            m_iVisitRegisterID = iVRegID;
            m_strHomeName = strHName;
            m_strVisitName = strVName;
        }

        private void frmOVRWPPenaltyPlayer_Load(object sender, EventArgs e)
        {
            Localization();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvAvailable_Home);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvAvailable_Visit);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMember_Home);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMember_Visit);

            ResetHomeGrid();
            ResetVisitGrid();
        }

        private void btnAdd_Home_Click(object sender, EventArgs e)
        {
            AddMember(1, ref dgvAvailable_Home);
            ResetHomeGrid();
        }

        private void btnRemove_Home_Click(object sender, EventArgs e)
        {
            RemoveMember(1, ref dgvMember_Home);
            ResetHomeGrid();
        }

        private void dgvMember_Home_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            int iRowIdx = e.RowIndex;
            int iColIdx = e.ColumnIndex;
            if (iRowIdx >= dgvMember_Home.RowCount || iRowIdx < 0 || iColIdx < 0)
                return;

            if (dgvMember_Home.Columns[iColIdx].Name.CompareTo("Position") == 0)
            {
                UpdateMemberPosition(1, ref dgvMember_Home, e);
            }

            //GVAR.g_ManageDB.ResetMemberGrid(m_iMatchID, m_iHomeRegisterID, 1, ref dgvMember_Home, ref m_iHomeStartup);
        }       

        private void dgvMember_Home_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvMember_Home.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex >= 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                if (dgvMember_Home.Columns[iColumnIndex].Name.CompareTo("Position") == 0)
                {
                    GVAR.g_ManageDB.InitPositionCombBox(ref dgvMember_Home, iColumnIndex);
                }
            }
        }

        private void btnAdd_Visit_Click(object sender, EventArgs e)
        {
            AddMember(2, ref dgvAvailable_Visit);
            ResetVisitGrid();
        }

        private void btnRemove_Visit_Click(object sender, EventArgs e)
        {
            RemoveMember(2, ref dgvMember_Visit);
            ResetVisitGrid();
        }

        private void dgvMember_Visit_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            int iRowIdx = e.RowIndex;
            int iColIdx = e.ColumnIndex;
            if (iRowIdx >= dgvMember_Visit.RowCount || iRowIdx < 0 || iColIdx < 0)
                return;

           if(dgvMember_Visit.Columns[iColIdx].Name.CompareTo("Position") == 0)
            {
                UpdateMemberPosition(2, ref dgvMember_Visit, e);
            }
            //GVAR.g_ManageDB.ResetMemberGrid(m_iMatchID, m_iVisitRegisterID, 2, ref dgvMember_Visit, ref m_iVisitStartup);
        }

        private void dgvMember_Visit_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvMember_Visit.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex >= 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                if(dgvMember_Visit.Columns[iColumnIndex].Name.CompareTo("Position") == 0)
                {
                    GVAR.g_ManageDB.InitPositionCombBox(ref dgvMember_Visit, iColumnIndex);
                }
            }
        }

        private void Localization()
        {
            string strSectionName = GVAR.g_WPPlugin.GetSectionName();

            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmTeamMember");
            lbAvailable_Home.Text = LocalizationRecourceManager.GetString(strSectionName, "lbAvailable_Home");
            lbAvailable_Visit.Text = LocalizationRecourceManager.GetString(strSectionName, "lbAvailable_Visit");
            lbMember_Home.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMember_Home");
            lbMember_Visit.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMember_Visit");
            gbHomeTeam.Text = m_strHomeName;
            gbVisitTeam.Text = m_strVisitName;
        }

        private void ResetHomeGrid()
        {
            GVAR.g_ManageDB.ResetPenaltyAvailableGrid(m_iMatchID, m_iMatchSplitID, 1, ref dgvAvailable_Home);
            GVAR.g_ManageDB.ResetPenaltyMemberGrid(m_iMatchID, m_iMatchSplitID, 1, ref dgvMember_Home);
        }

        private void ResetVisitGrid()
        {
            GVAR.g_ManageDB.ResetPenaltyAvailableGrid(m_iMatchID, m_iMatchSplitID, 2, ref dgvAvailable_Visit);
            GVAR.g_ManageDB.ResetPenaltyMemberGrid(m_iMatchID, m_iMatchSplitID, 2, ref dgvMember_Visit);
        }

        private void AddMember(int iTeamPos, ref DataGridView dgv)
        {
            int iColIdx = dgv.Columns["F_MemberID"].Index;
            int iFuncColIdx = dgv.Columns["F_FunctionID"].Index;
            int iShirtNumberIdex = dgv.Columns["ShirtNumber"].Index;

            for (int i = 0; i < dgv.SelectedRows.Count; i++)
            {
                int iRowIdx = dgv.SelectedRows[i].Index;

                if (dgv.Rows[iRowIdx].ReadOnly == true)
                {
                    continue;
                }
                string strMemberID = dgv.Rows[iRowIdx].Cells[iColIdx].Value.ToString();
                string strFunctionID = dgv.Rows[iRowIdx].Cells[iFuncColIdx].Value.ToString();
                string strShirtNumber = dgv.Rows[iRowIdx].Cells[iShirtNumberIdex].Value.ToString();

                int iMemberID = GVAR.Str2Int(strMemberID);
                int iFunctionID = 0;
                int iShirtNumber = 0;
                if (strFunctionID.Length == 0)
                {
                    iFunctionID = -1;
                }
                else
                {
                    iFunctionID = GVAR.Str2Int(strFunctionID);
                }

                if(strShirtNumber.Length == 0)
                {
                    iShirtNumber = -1;
                }
                else 
                {
                    iShirtNumber = GVAR.Str2Int(strShirtNumber);
                }
                GVAR.g_ManageDB.AddMatchSplitMember(m_iMatchID, m_iMatchSplitID, iMemberID, iTeamPos, iFunctionID, iShirtNumber);
            }
        }

        private void RemoveMember(int iTeamPos, ref DataGridView dgv)
        {
            int iColIdx = dgv.Columns["F_MemberID"].Index;

            for (int i = 0; i < dgv.SelectedRows.Count; i++)
            {
                int iRowIdx = dgv.SelectedRows[i].Index;

                string strMemberID = dgv.Rows[iRowIdx].Cells[iColIdx].Value.ToString();
                int iMemberID = GVAR.Str2Int(strMemberID);

                GVAR.g_ManageDB.RemoveMatchSplitMember(m_iMatchID, m_iMatchSplitID, iMemberID, iTeamPos);
            }
        }

        private void UpdateMemberPosition(int iTeamPos, ref DataGridView dgv, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex < 0 || e.RowIndex < 0)
                return;

            int iColumnIndex = e.ColumnIndex;
            int iRowIndex = e.RowIndex;
            String strColumnName = dgv.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgv.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                int iPositionID = 0;
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    iPositionID = GVAR.Str2Int(CurCell1.Tag);
                }
                else
                {
                    return;
                }
                int iMemberID = GVAR.Str2Int(dgv.Rows[iRowIndex].Cells["F_MemberID"].Value);
                GVAR.g_ManageDB.UpdateMatchSplitMembePosition(m_iMatchID, m_iMatchSplitID, iMemberID, iTeamPos, iPositionID);
            }
        }
    }
}
