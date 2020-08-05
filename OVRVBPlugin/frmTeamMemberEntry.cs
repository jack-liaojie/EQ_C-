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
using System.Diagnostics;

namespace AutoSports.OVRVBPlugin
{
    public partial class frmTeamMemberEntry : Office2007Form
    {
        private int m_iMatchID;
        private int m_iHomeRegisterID;
        private int m_iVisitRegisterID;
        private int m_iHomeUniformID;
        private int m_iVisitUniformID;
        private string m_strHomeName;
        private string m_strVisitName;

        private DataTable dt_Uniform_home = new DataTable();
        private DataTable dt_Uniform_Visit = new DataTable();

        private int m_iHomeStartup = 0;
        private int m_iVisitStartup = 0;

		public frmTeamMemberEntry(int nMatchID, String strLangCode)
        {
            InitializeComponent();

			if (nMatchID <= 0 || strLangCode.Length == 0)
			{
				Debug.Assert(false);
				return;
			}

			DataTable tbl = Common.dbGetMatchInfo(Common.g_nMatchID, Common.g_strLanguage);
			if (tbl == null || tbl.Rows.Count < 1 || tbl.Columns.Count < 1 )
			{
				return;
			}
			
            m_iMatchID = Common.Str2Int(tbl.Rows[0]["F_MatchID"]);
			m_iHomeRegisterID = Common.Str2Int(tbl.Rows[0]["F_TeamARegID"]);
			m_iVisitRegisterID = Common.Str2Int(tbl.Rows[0]["F_TeamBRegID"]);
			m_strHomeName = tbl.Rows[0]["F_TeamAName"].ToString();
			m_strVisitName = tbl.Rows[0]["F_TeamBName"].ToString();
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
            else if (dgvMember_Home.Columns[iColIdx].Name.CompareTo("Order") == 0)
            {
                UpdateMemberOrder(1, ref dgvMember_Home, e);
            }
            else if (dgvMember_Home.Columns[iColIdx].Name.CompareTo("DSQ") == 0)
            {
                UpdateMemberDSQ(1, ref dgvMember_Home, e);
            }
			else if (dgvMember_Home.Columns[iColIdx].Name.CompareTo("MaxServeSpeed") == 0)
			{
				UpdateMemberSrvSpeed(1, ref dgvMember_Home, e);
			}

            ResetMemberGrid(m_iMatchID, m_iHomeRegisterID, 1, ref dgvMember_Home, ref m_iHomeStartup);
        }       

        private void dgvMember_Home_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvMember_Home.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex < 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                if (dgvMember_Home.Columns[iColumnIndex].Name.CompareTo("Function") == 0)
                {
                    InitFunctionCombBox(ref dgvMember_Home, iColumnIndex, "A");
                }
                else if (dgvMember_Home.Columns[iColumnIndex].Name.CompareTo("Position") == 0)
                {
                    InitPositionCombBox(ref dgvMember_Home, iColumnIndex);
                }
                else if (dgvMember_Home.Columns[iColumnIndex].Name.CompareTo("DSQ") == 0)
                {
                    InitIRMCombBox(ref dgvMember_Home, iColumnIndex, m_iMatchID);
                }
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
            else if(dgvMember_Visit.Columns[iColIdx].Name.CompareTo("Position") == 0)
            {
                UpdateMemberPosition(2, ref dgvMember_Visit, e);
            }
            else if (dgvMember_Visit.Columns[iColIdx].Name.CompareTo("Order") == 0)
            {
                UpdateMemberOrder(2, ref dgvMember_Visit, e);
            }
            else if (dgvMember_Visit.Columns[iColIdx].Name.CompareTo("DSQ") == 0)
            {
                UpdateMemberDSQ(2, ref dgvMember_Visit, e);
            }
			else if (dgvMember_Visit.Columns[iColIdx].Name.CompareTo("MaxServeSpeed") == 0)
			{
				UpdateMemberSrvSpeed(2, ref dgvMember_Visit, e);
			}

            ResetMemberGrid(m_iMatchID, m_iVisitRegisterID, 2, ref dgvMember_Visit, ref m_iVisitStartup);
        }

        private void dgvMember_Visit_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvMember_Visit.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex < 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                if (dgvMember_Visit.Columns[iColumnIndex].Name.CompareTo("Function") == 0)
                {
                    InitFunctionCombBox(ref dgvMember_Visit, iColumnIndex, "A");
                }
                else if(dgvMember_Visit.Columns[iColumnIndex].Name.CompareTo("Position") == 0)
                {
                    InitPositionCombBox(ref dgvMember_Visit, iColumnIndex);
                }
                else if (dgvMember_Visit.Columns[iColumnIndex].Name.CompareTo("DSQ") == 0)
                {
                    InitIRMCombBox(ref dgvMember_Visit, iColumnIndex, m_iMatchID);
                }
            }
        }

        private void dgvMember_Visit_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            UpdateMemberStartup(2, ref dgvMember_Visit, e);
        }

        private void cmbUniform_Home_SelectionChangeCommitted(object sender, EventArgs e)
        {
			m_iHomeUniformID = Common.Str2Int(cmbUniform_Home.SelectedValue);

            UpdateMatchUniform(m_iMatchID, 1, m_iHomeUniformID);
        }

        private void cmbUniform_Visit_SelectionChangeCommitted(object sender, EventArgs e)
        {
			m_iVisitUniformID = Common.Str2Int(cmbUniform_Visit.SelectedValue);

            UpdateMatchUniform(m_iMatchID, 2, m_iVisitUniformID);
        }

        private void Localization()
        {
			string strSectionName = Common.g_strSectionName;

            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmTeamMember");
            lbAvailable_Home.Text = LocalizationRecourceManager.GetString(strSectionName, "lbAvailable_Home");
            lbAvailable_Visit.Text = LocalizationRecourceManager.GetString(strSectionName, "lbAvailable_Visit");
            lbMember_Home.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMember_Home");
            lbMember_Visit.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMember_Visit");
            lbUniform_Home.Text = LocalizationRecourceManager.GetString(strSectionName, "lbUniform_Home");
            lbUniform_Visit.Text = LocalizationRecourceManager.GetString(strSectionName, "lbUniform_Visit");
            gbHomeTeam.Text = m_strHomeName;
            gbVisitTeam.Text = m_strVisitName;
        }

        private void ResetHomeGrid()
        {
            ResetAvailableGrid(m_iMatchID, m_iHomeRegisterID, 1, ref dgvAvailable_Home);
            ResetMemberGrid(m_iMatchID, m_iHomeRegisterID, 1, ref dgvMember_Home, ref m_iHomeStartup);
        }

        private void ResetVisitGrid()
        {
            ResetAvailableGrid(m_iMatchID, m_iVisitRegisterID, 2, ref dgvAvailable_Visit);
            ResetMemberGrid(m_iMatchID, m_iVisitRegisterID, 2, ref dgvMember_Visit, ref m_iVisitStartup);
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

                int iMemberID = Common.Str2Int(strMemberID);
                int iFunctionID = 0;
                int iShirtNumber = 0;
                if (strFunctionID.Length == 0)
                {
                    iFunctionID = -1;
                }
                else
                {
					iFunctionID = Common.Str2Int(strFunctionID);
                }

                if(strShirtNumber.Length == 0)
                {
                    iShirtNumber = -1;
                }
                else 
                {
					iShirtNumber = Common.Str2Int(strShirtNumber);
                }
                AddMatchMember(m_iMatchID, iMemberID, iTeamPos, iFunctionID, iShirtNumber);
            }
        }

        private void RemoveMember(int iTeamPos, ref DataGridView dgv)
        {
            int iColIdx = dgv.Columns["F_MemberID"].Index;

            for (int i = 0; i < dgv.SelectedRows.Count; i++)
            {
                int iRowIdx = dgv.SelectedRows[i].Index;

                string strMemberID = dgv.Rows[iRowIdx].Cells[iColIdx].Value.ToString();
                int iMemberID = Common.Str2Int(strMemberID);

                RemoveMatchMember(m_iMatchID, iMemberID, iTeamPos);
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
                    iFunctionID = Common.Str2Int(CurCell1.Tag);
                }
                else
                {
                    return;
                }

				int iMemberID = Common.Str2Int(dgv.Rows[iRowIndex].Cells["F_MemberID"].Value);
                UpdateMatchMemberFunction(m_iMatchID, iMemberID, iTeamPos, iFunctionID);
            }
        }

        private void UpdateMemberShirtNumber(int iTeamPos, ref DataGridView dgv, DataGridViewCellEventArgs e)
        {
			int iColumnIndex = e.ColumnIndex;
            int iRowIndex = e.RowIndex;

            DataGridViewCell CurCell = dgv.Rows[iRowIndex].Cells[iColumnIndex];

            string strShirtNumber = "";
            if(CurCell.Value != null)
            {
                strShirtNumber = CurCell.Value.ToString();
            }
			int iMemberID = Common.Str2Int(dgv.Rows[iRowIndex].Cells["F_MemberID"].Value);

            UpdateMatchMemberShirtNumber(m_iMatchID, iMemberID, iTeamPos, strShirtNumber);
        }

		private void UpdateMemberSrvSpeed(int iTeamPos, ref DataGridView dgv, DataGridViewCellEventArgs e)
		{
			int iColumnIndex = e.ColumnIndex;
			int iRowIndex = e.RowIndex;

			DataGridViewCell CurCell = dgv.Rows[iRowIndex].Cells[iColumnIndex];

			int? nValue = null;
			if (CurCell.Value != null)
			{
				nValue = Common.Str2Int(CurCell.Value.ToString());
			}

			int iMemberID = Common.Str2Int(dgv.Rows[iRowIndex].Cells["F_MemberID"].Value);

			UpdateMatchMemberSrvSpeed(m_iMatchID, iMemberID, iTeamPos, nValue);
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
					iPositionID = Common.Str2Int(CurCell1.Tag);
                }
                else
                {
                    return;
                }
				int iMemberID = Common.Str2Int(dgv.Rows[iRowIndex].Cells["F_MemberID"].Value);
                UpdateMatchMembePosition(m_iMatchID, iMemberID, iTeamPos, iPositionID);
            }
        }

        private void UpdateMemberOrder(int iTeamPos, ref DataGridView dgv, DataGridViewCellEventArgs e)
        {
            int iColumnIndex = e.ColumnIndex;
            int iRowIndex = e.RowIndex;

            DataGridViewCell CurCell = dgv.Rows[iRowIndex].Cells[iColumnIndex];

            int iBatOrder = 0;
            if (CurCell.Value != null)
            {
				iBatOrder = Common.Str2Int(CurCell.Value);
            }
			int iMemberID = Common.Str2Int(dgv.Rows[iRowIndex].Cells["F_MemberID"].Value);

            UpdatePlayerOrder(m_iMatchID.ToString(), iMemberID, iBatOrder);

        }

        private void UpdateMemberDSQ(int iTeamPos, ref DataGridView dgv, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex < 0 || e.RowIndex < 0)
                return;

            int iColumnIndex = e.ColumnIndex;
            int iRowIndex = e.RowIndex;
            DataGridViewCell CurCell = dgv.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                int iIRMID = 0;
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
					iIRMID = Common.Str2Int(CurCell1.Tag);
                }
                else
                {
                    return;
                }

				int iMemberID = Common.Str2Int(dgv.Rows[iRowIndex].Cells["F_MemberID"].Value);
                int iRegisterID = 0;
                if (iTeamPos == 1)
                {
                    iRegisterID = m_iHomeRegisterID;
                }
                else if (iTeamPos == 2)
                {
                    iRegisterID = m_iVisitRegisterID;
                }
                UpdateMemberDSQ(iRegisterID, iMemberID, iIRMID);
            }
        }
        
        private void InitUniformCmb()
        {
            GetMatchUniform(m_iMatchID, 1, ref m_iHomeUniformID);
            GetMatchUniform(m_iMatchID, 2, ref m_iVisitUniformID);

            GetTeamUniform(m_iHomeRegisterID, ref dt_Uniform_home);
           
            cmbUniform_Home.DisplayMember = "UniformName";
            cmbUniform_Home.ValueMember = "UniformID";
            cmbUniform_Home.DataSource = dt_Uniform_home;
            if(m_iHomeUniformID == 0)
            {
                cmbUniform_Home.SelectedIndex = -1;
            }
            else 
            {
                cmbUniform_Home.SelectedValue = m_iHomeUniformID;
            }


            GetTeamUniform(m_iVisitRegisterID, ref dt_Uniform_Visit);
           
            cmbUniform_Visit.DisplayMember = "UniformName";
            cmbUniform_Visit.ValueMember = "UniformID";
            cmbUniform_Visit.DataSource = dt_Uniform_Visit;
             if(m_iVisitUniformID == 0)
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

			if (Common.Str2Int(dgv.Rows[e.RowIndex].Cells[e.ColumnIndex].Value) == 1)
            {
                UpdateMemberStartup(m_iMatchID, iTeampos, strRegisterID, false);
            }
            else
            {
                if ((iTeampos == 1 && m_iHomeStartup < 7) || (iTeampos == 2 && m_iVisitStartup < 7))
                {
                    UpdateMemberStartup(m_iMatchID, iTeampos, strRegisterID, true);
                }
            }

            if (iTeampos == 1)
            {
                ResetMemberGrid(m_iMatchID, m_iHomeRegisterID, 1, ref dgvMember_Home, ref m_iHomeStartup);
            }
            else if (iTeampos == 2)
            {
                ResetMemberGrid(m_iMatchID, m_iVisitRegisterID, 2, ref dgvMember_Visit, ref m_iVisitStartup);
            }
        }

      
    }
}
