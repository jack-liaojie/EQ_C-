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
    public partial class frmTeamPlayers : Office2007Form
    {
        Int32 m_iMatchID;
        Int32 m_iMatchType;
        Int32 m_iPos;

        public frmTeamPlayers(Int32 iMatchID, Int32 iMatchType, Int32 iPos)
        {
            InitializeComponent();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvTeamPlayers);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchPlayers);

            m_iMatchID = iMatchID;
            m_iMatchType = iMatchType;
            m_iPos = iPos;
        }

        private void frmTeamPlayers_Load(object sender, EventArgs e)
        {
            Localization();
            ResetTeamPlayers();
            ResetMatchPlayers();
            ResetTeamUniform();
        }

        private void Localization()
        {
            String strSectionName = SECommon.m_strSectionName;
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmSetTeamPlayers");
            lbTeamPlayers.Text = LocalizationRecourceManager.GetString(strSectionName, "lbAvailablePlayers");
            lbMatchPlayers.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMatchPlayers");
            lbUniform.Text = LocalizationRecourceManager.GetString(strSectionName, "lbUniform");
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            for (Int32 i = 0; i < dgvTeamPlayers.SelectedRows.Count; i++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvTeamPlayers.SelectedRows[i];
                Int32 iRowIdx = row.Index;

                Int32 iRegisterID = GetFieldValue(dgvTeamPlayers, iRowIdx, "F_RegisterID");
                Int32 iFunctionID = GetFieldValue(dgvTeamPlayers, iRowIdx, "F_FunctionID");
                string order = dgvTeamPlayers.Rows[iRowIdx].Cells["Order"].Value.ToString();
                int iOrder = -1;
                try
                {
                    iOrder = Convert.ToInt32(order);
                }
                catch (System.Exception ex)
                {
                    iOrder = -1;
                }
                Int32 iBib = GetFieldValue(dgvTeamPlayers, iRowIdx, "Bib");

                iFunctionID = iFunctionID == 0 ? -1 : iFunctionID;

                AddMatchPlayers(iRegisterID, iFunctionID, iBib, iOrder);
            }

            ResetTeamPlayers();
            ResetMatchPlayers();
        }

        private void btnDel_Click(object sender, EventArgs e)
        {
            for (Int32 i = 0; i < dgvMatchPlayers.SelectedRows.Count; i++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvMatchPlayers.SelectedRows[i];
                Int32 iRowIdx = row.Index;

                Int32 iRegisterID = GetFieldValue(dgvMatchPlayers, iRowIdx, "F_RegisterID");
                DelMatchPlayers(iRegisterID);
            }

            ResetTeamPlayers();
            ResetMatchPlayers();
        }

        private void cmb_Uniform_SelectionChangeCommitted(object sender, EventArgs e)
        {
            Int32 nUniformID = -1;
            Int32 nSelIdx = -1;

            if (cmb_Uniform.SelectedItem == null)
                return;

            nSelIdx = cmb_Uniform.SelectedIndex;
            nUniformID = Convert.ToInt32(cmb_Uniform.SelectedValue);

            SECommon.g_ManageDB.UpdateTeamUniform(m_iMatchID, m_iPos, nUniformID);
        }

        private void dgvMatchPlayers_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            String strColumnName = dgvMatchPlayers.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvMatchPlayers.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                Int32 iRegisterID = GetFieldValue(dgvMatchPlayers, iRowIndex, "F_RegisterID");

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

                if (strColumnName.CompareTo("Position") == 0)
                {
                    SECommon.g_ManageDB.UpdateMatchPlayerPosition(m_iMatchID, m_iPos, iRegisterID, iInputKey);
                }
                if (strColumnName.CompareTo("Function") == 0)
                {
                    SECommon.g_ManageDB.UpdateMatchPlayerFunction(m_iMatchID, m_iPos, iRegisterID, iInputKey);
                }
                if (strColumnName.CompareTo("StartUp") == 0)
                {
                    SECommon.g_ManageDB.UpdateMatchPlayerStartUp(m_iMatchID, m_iPos, iRegisterID, iInputKey);
                }
                if (strColumnName.CompareTo("Regu") == 0)
                {
                    SECommon.g_ManageDB.UpdateMatchPlayerRegu(m_iMatchID, m_iPos, iRegisterID, iInputKey);
                }

                ResetMatchPlayers();
                dgvMatchPlayers.Rows[iRowIndex].Selected = true;
            }
        }

        private void dgvMatchPlayers_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvMatchPlayers.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex < 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;
                Int32 iRegisterID = GetFieldValue(dgvMatchPlayers, iRowIndex, "F_RegisterID");

                if (dgvMatchPlayers.Columns[iColumnIndex].Name.CompareTo("Position") == 0)
                {
                    SECommon.g_ManageDB.InitPositionCombBox(ref dgvMatchPlayers, iColumnIndex, m_iMatchID);
                }
                if (dgvMatchPlayers.Columns[iColumnIndex].Name.CompareTo("Function") == 0)
                {
                    SECommon.g_ManageDB.InitFunctionCombBox(ref dgvMatchPlayers, iColumnIndex, m_iMatchID, "A");
                }
                if (dgvMatchPlayers.Columns[iColumnIndex].Name.CompareTo("StartUp") == 0)
                {
                    SECommon.g_ManageDB.InitStartUpCombBox(ref dgvMatchPlayers, iColumnIndex, m_iMatchID, m_iPos);
                }
                if (dgvMatchPlayers.Columns[iColumnIndex].Name.CompareTo("Regu") == 0)
                {
                    SECommon.g_ManageDB.InitReguCombBox(ref dgvMatchPlayers, iColumnIndex, m_iMatchID, m_iPos);
                }
            }
        }

        private void ResetTeamPlayers()
        {
            SECommon.g_ManageDB.GetTeamPlayers(m_iMatchID, m_iPos, dgvTeamPlayers);
        }

        private void ResetMatchPlayers()
        {
            SECommon.g_ManageDB.GetMatchPlayers(m_iMatchID, m_iMatchType, m_iPos, dgvMatchPlayers);
            SetGridStyle(dgvMatchPlayers);
        }

        private void ResetTeamUniform()
        {
            SECommon.g_ManageDB.GetTeamUniform(m_iMatchID, m_iPos, cmb_Uniform);
        }

        private void AddMatchPlayers(Int32 nRegisterID, Int32 nFunctionID, Int32 nBib, Int32 Order)
        {
            SECommon.g_ManageDB.AddMatchPlayer(m_iMatchID, m_iPos, nRegisterID, nFunctionID, nBib, Order);
        }

        private void DelMatchPlayers(Int32 nRegisterID)
        {
            SECommon.g_ManageDB.DelMatchPlayer(m_iMatchID, m_iPos, nRegisterID);
        }

        private void SetGridStyle(DataGridView dgv)
        {
            dgv.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;

            if (dgv == dgvMatchPlayers)
            {
                if (dgvMatchPlayers.Columns["Function"] != null)
                {
                    dgvMatchPlayers.Columns["Function"].ReadOnly = false;
                }
                if (dgvMatchPlayers.Columns["Position"] != null)
                {
                    dgvMatchPlayers.Columns["Position"].ReadOnly = false;
                }
                if (dgvMatchPlayers.Columns["StartUp"] != null)
                {
                    dgvMatchPlayers.Columns["StartUp"].ReadOnly = false;
                }
                if (dgvMatchPlayers.Columns["Regu"] != null)
                {
                    dgvMatchPlayers.Columns["Regu"].ReadOnly = false;
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
