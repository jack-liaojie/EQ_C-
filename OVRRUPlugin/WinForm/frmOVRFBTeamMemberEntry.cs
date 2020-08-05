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
using OVRRUPlugin.Common;

namespace OVRRUPlugin
{
    public partial class frmOVRFBTeamMemberEntry : Office2007Form
    {
        private int m_iMatchID;
        private int m_iHomeRegisterID;
        private int m_iVisitRegisterID;
        private int m_iHomeUniformID;
        private int m_iVisitUniformID;
        private int m_ruleID;

        private string m_strHomeName;
        private string m_strVisitName;

        private DataTable dt_Uniform_home = new DataTable();
        private DataTable dt_Uniform_Visit = new DataTable();

        private DataTable dt_CompetitionRule = new DataTable();

        private int m_iHomeStartup = 0;
        private int m_iVisitStartup = 0;

        public frmOVRFBTeamMemberEntry(int iMatchID, int iHRegID, int iVRegID, string strHName, string strVName)
        {
            InitializeComponent();

            m_iMatchID = iMatchID;
            m_iHomeRegisterID = iHRegID;
            m_iVisitRegisterID = iVRegID;
            m_strHomeName = strHName;
            m_strVisitName = strVName;
        }

        private void frmTeamMemberEntry_Load(object sender, EventArgs e)
        {
            Localization();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvAvailable_Home);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvAvailable_Visit);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMember_Home);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMember_Visit);

            ResetHomeGrid();
            ResetVisitGrid();
            InitUniformCmb();
            InitPeriodCmb();
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

            if (dgvMember_Home.Columns[iColIdx].Name.CompareTo("Function") == 0)
            {
                UpdateMemberFunction(1, ref dgvMember_Home, e);
            }
            else if (dgvMember_Home.Columns[iColIdx].Name.CompareTo("ShirtNumber") == 0)
            {
                UpdateMemberShirtNumber(1, ref dgvMember_Home, e);
            }
            else if (dgvMember_Home.Columns[iColIdx].Name.CompareTo("Position") == 0)
            {
                UpdateMemberPosition(1, ref dgvMember_Home, e);
            }
            //else if (dgvMember_Home.Columns[iColIdx].Name.CompareTo("Order") == 0)
            //{
            //    UpdateMemberOrder(1, ref dgvMember_Home, e);
            //}
            //else if (dgvMember_Home.Columns[iColIdx].Name.CompareTo("DSQ") == 0)
            //{
            //    UpdateMemberDSQ(1, ref dgvMember_Home, e);
            //}

            //GVAR.g_ManageDB.ResetMemberGrid(m_iMatchID, m_iHomeRegisterID, 1, ref dgvMember_Home, ref m_iHomeStartup);
        }

        private void dgvMember_Home_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvMember_Home.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex >= 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                if (dgvMember_Home.Columns[iColumnIndex].Name.CompareTo("Function") == 0)
                {
                    GVAR.g_ManageDB.InitFunctionCombBox(ref dgvMember_Home, iColumnIndex, "A");
                }
                else if (dgvMember_Home.Columns[iColumnIndex].Name.CompareTo("Position") == 0)
                {
                    GVAR.g_ManageDB.InitPositionCombBox(ref dgvMember_Home, iColumnIndex);
                }
                //else if (dgvMember_Home.Columns[iColumnIndex].Name.CompareTo("DSQ") == 0)
                //{
                //    GVAR.g_ManageDB.InitIRMCombBox(ref dgvMember_Home, iColumnIndex, m_iMatchID);
                //}
            }
        }

        private void dgvMember_Home_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            UpdateMemberStartup(1, ref dgvMember_Home, e);
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

            if (dgvMember_Visit.Columns[iColIdx].Name.CompareTo("Function") == 0)
            {
                UpdateMemberFunction(2, ref dgvMember_Visit, e);
            }
            else if (dgvMember_Visit.Columns[iColIdx].Name.CompareTo("ShirtNumber") == 0)
            {
                UpdateMemberShirtNumber(2, ref dgvMember_Visit, e);
            }
            else if (dgvMember_Visit.Columns[iColIdx].Name.CompareTo("Position") == 0)
            {
                UpdateMemberPosition(2, ref dgvMember_Visit, e);
            }
            //else if (dgvMember_Visit.Columns[iColIdx].Name.CompareTo("Order") == 0)
            //{
            //    UpdateMemberOrder(2, ref dgvMember_Visit, e);
            //}
            //else if (dgvMember_Visit.Columns[iColIdx].Name.CompareTo("DSQ") == 0)
            //{
            //    UpdateMemberDSQ(2, ref dgvMember_Visit, e);
            //}

            //GVAR.g_ManageDB.ResetMemberGrid(m_iMatchID, m_iVisitRegisterID, 2, ref dgvMember_Visit, ref m_iVisitStartup);
        }

        private void dgvMember_Visit_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvMember_Visit.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex >= 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                if (dgvMember_Visit.Columns[iColumnIndex].Name.CompareTo("Function") == 0)
                {
                    GVAR.g_ManageDB.InitFunctionCombBox(ref dgvMember_Visit, iColumnIndex, "A");
                }
                else if (dgvMember_Visit.Columns[iColumnIndex].Name.CompareTo("Position") == 0)
                {
                    GVAR.g_ManageDB.InitPositionCombBox(ref dgvMember_Visit, iColumnIndex);
                }
                //else if (dgvMember_Visit.Columns[iColumnIndex].Name.CompareTo("DSQ") == 0)
                //{
                //    GVAR.g_ManageDB.InitIRMCombBox(ref dgvMember_Visit, iColumnIndex, m_iMatchID);
                //}
            }
        }

        private void dgvMember_Visit_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            UpdateMemberStartup(2, ref dgvMember_Visit, e);
        }

        private void cmbUniform_Home_SelectionChangeCommitted(object sender, EventArgs e)
        {
            m_iHomeUniformID = GVAR.Str2Int(cmbUniform_Home.SelectedValue);

            GVAR.g_ManageDB.UpdateMatchUniform(m_iMatchID, 1, m_iHomeUniformID);
        }

        private void cmbUniform_Visit_SelectionChangeCommitted(object sender, EventArgs e)
        {
            m_iVisitUniformID = GVAR.Str2Int(cmbUniform_Visit.SelectedValue);

            GVAR.g_ManageDB.UpdateMatchUniform(m_iMatchID, 2, m_iVisitUniformID);
        }

        private void cmbPeriod_SelectionChangeCommitted(object sender, EventArgs e)
        {
            m_ruleID = GVAR.Str2Int(cmbPeriod.SelectedValue);

            GVAR.g_ManageDB.SetMatchCompetitioinRule(m_iMatchID,m_ruleID);
            GVAR.g_ManageDB.GetMatchCompetitionRuleInfo(m_iMatchID);
        }

        private void Localization()
        {
            gbHomeTeam.Text = m_strHomeName;
            gbVisitTeam.Text = m_strVisitName;
        }

        private void ResetHomeGrid()
        {
            GVAR.g_ManageDB.ResetAvailableGrid(m_iMatchID, m_iHomeRegisterID, 1, ref dgvAvailable_Home);
            GVAR.g_ManageDB.ResetMemberGrid(m_iMatchID, m_iHomeRegisterID, 1, ref dgvMember_Home, ref m_iHomeStartup);
        }

        private void ResetVisitGrid()
        {
            GVAR.g_ManageDB.ResetAvailableGrid(m_iMatchID, m_iVisitRegisterID, 2, ref dgvAvailable_Visit);
            GVAR.g_ManageDB.ResetMemberGrid(m_iMatchID, m_iVisitRegisterID, 2, ref dgvMember_Visit, ref m_iVisitStartup);
        }

        private void AddMember(int iTeamPos, ref DataGridView dgv)
        {
            int iColIdx = dgv.Columns["F_MemberID"].Index;
            int iFuncColIdx = dgv.Columns["F_FunctionID"].Index;
            int iShirtNumberIdex = dgv.Columns["ShirtNumber"].Index;
            int iPosColIdx = dgv.Columns["F_PositionID"].Index;

            for (int i = 0; i < dgv.SelectedRows.Count; i++)
            {
                int iRowIdx = dgv.SelectedRows[i].Index;

                if (dgv.Rows[iRowIdx].ReadOnly == true)
                {
                    continue;
                }
                string strMemberID = dgv.Rows[iRowIdx].Cells[iColIdx].Value.ToString();
                string strFunctionID = dgv.Rows[iRowIdx].Cells[iFuncColIdx].Value.ToString();
                string strPositionID = dgv.Rows[iRowIdx].Cells[iPosColIdx].Value.ToString();
                string strShirtNumber = dgv.Rows[iRowIdx].Cells[iShirtNumberIdex].Value.ToString();

                int iMemberID = GVAR.Str2Int(strMemberID);
                int iFunctionID = 0;
                int iPostionID = 0;
                int iShirtNumber = 0;
                if (strFunctionID.Length == 0)
                {
                    iFunctionID = -1;
                }
                else
                {
                    iFunctionID = GVAR.Str2Int(strFunctionID);
                }

                if (strPositionID.Length == 0)
                {
                    iPostionID = -1;
                }
                else
                {
                    iPostionID = GVAR.Str2Int(strPositionID);
                }
                if (strShirtNumber.Length == 0)
                {
                    iShirtNumber = -1;
                }
                else
                {
                    iShirtNumber = GVAR.Str2Int(strShirtNumber);
                }
                GVAR.g_ManageDB.AddMatchMember(m_iMatchID, iMemberID, iTeamPos, iFunctionID, iPostionID, iShirtNumber);
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

                GVAR.g_ManageDB.RemoveMatchMember(m_iMatchID, iMemberID, iTeamPos);
            }
        }

        private void UpdateMemberFunction(int iTeamPos, ref DataGridView dgv, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex < 0 || e.RowIndex < 0)
                return;

            int iColumnIndex = e.ColumnIndex;
            int iRowIndex = e.RowIndex;
            String strColumnName = dgv.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgv.Rows[iRowIndex].Cells[iColumnIndex];

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

                int iMemberID = GVAR.Str2Int(dgv.Rows[iRowIndex].Cells["F_MemberID"].Value);
                GVAR.g_ManageDB.UpdateMatchMemberFunction(m_iMatchID, iMemberID, iTeamPos, iFunctionID);
            }
        }

        private void UpdateMemberShirtNumber(int iTeamPos, ref DataGridView dgv, DataGridViewCellEventArgs e)
        {
            int iColumnIndex = e.ColumnIndex;
            int iRowIndex = e.RowIndex;

            DataGridViewCell CurCell = dgv.Rows[iRowIndex].Cells[iColumnIndex];

            string strShirtNumber = "";
            if (CurCell.Value != null)
            {
                strShirtNumber = CurCell.Value.ToString();
            }
            int iMemberID = GVAR.Str2Int(dgv.Rows[iRowIndex].Cells["F_MemberID"].Value);

            GVAR.g_ManageDB.UpdateMatchMemberShirtNumber(m_iMatchID, iMemberID, iTeamPos, strShirtNumber);
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
                GVAR.g_ManageDB.UpdateMatchMembePosition(m_iMatchID, iMemberID, iTeamPos, iPositionID);
            }
        }

        private void InitPeriodCmb()
        {
            GVAR.g_ManageDB.GetMatchCompetitioinRule(m_iMatchID, ref m_ruleID);

            GVAR.g_ManageDB.GetCompetitionRule(ref dt_CompetitionRule);

            cmbPeriod.DataSource = dt_CompetitionRule;
            cmbPeriod.DisplayMember = "CompetitionLongName";
            cmbPeriod.ValueMember = "CompetitionRuleID";
            
            cmbPeriod.SelectedValue = m_ruleID;
        }

        private void InitUniformCmb()
        {
            GVAR.g_ManageDB.GetMatchUniform(m_iMatchID, 1, ref m_iHomeUniformID);
            GVAR.g_ManageDB.GetMatchUniform(m_iMatchID, 2, ref m_iVisitUniformID);

            GVAR.g_ManageDB.GetTeamUniform(m_iHomeRegisterID, ref dt_Uniform_home);

            cmbUniform_Home.DisplayMember = "UniformName";
            cmbUniform_Home.ValueMember = "UniformID";
            cmbUniform_Home.DataSource = dt_Uniform_home;
            if (m_iHomeUniformID == 0)
            {
                cmbUniform_Home.SelectedIndex = -1;
            }
            else
            {
                cmbUniform_Home.SelectedValue = m_iHomeUniformID;
            }


            GVAR.g_ManageDB.GetTeamUniform(m_iVisitRegisterID, ref dt_Uniform_Visit);

            cmbUniform_Visit.DisplayMember = "UniformName";
            cmbUniform_Visit.ValueMember = "UniformID";
            cmbUniform_Visit.DataSource = dt_Uniform_Visit;
            if (m_iVisitUniformID == 0)
            {
                cmbUniform_Visit.SelectedIndex = -1;
            }
            else
            {
                cmbUniform_Visit.SelectedValue = m_iVisitUniformID;
            }

        }

        private void UpdateMemberStartup(int iTeampos, ref DataGridView dgv, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= dgv.RowCount || e.RowIndex < 0)
                return;
            if (e.ColumnIndex != dgv.Columns["Startup"].Index)
                return;


            string strRegisterID = dgv.Rows[e.RowIndex].Cells["F_MemberID"].Value.ToString();

            if (GVAR.Str2Int(dgv.Rows[e.RowIndex].Cells[e.ColumnIndex].Value) == 1)
            {
                GVAR.g_ManageDB.UpdateMemberStartup(m_iMatchID, iTeampos, strRegisterID, false);
            }
            else
            {
                if ((iTeampos == 1 && m_iHomeStartup < 11) || (iTeampos == 2 && m_iVisitStartup < 11))
                {
                    GVAR.g_ManageDB.UpdateMemberStartup(m_iMatchID, iTeampos, strRegisterID, true);
                }
            }

            if (iTeampos == 1)
            {
                GVAR.g_ManageDB.ResetMemberGrid(m_iMatchID, m_iHomeRegisterID, 1, ref dgvMember_Home, ref m_iHomeStartup);
            }
            else if (iTeampos == 2)
            {
                GVAR.g_ManageDB.ResetMemberGrid(m_iMatchID, m_iVisitRegisterID, 2, ref dgvMember_Visit, ref m_iVisitStartup);
            }
        }

        private void cmbUniform_Home_SelectedIndexChanged(object sender, EventArgs e)
        {

        }


    }
}
