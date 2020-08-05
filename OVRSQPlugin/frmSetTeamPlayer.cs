using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Xml;
using System.Collections;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using System.Text.RegularExpressions;

namespace AutoSports.OVRSQPlugin
{
    public partial class frmSetTeamPlayer : Office2007Form
    {
        public Int32 m_iMatchID;

        public frmSetTeamPlayer(Int32 iMatchID)
        {
            InitializeComponent();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvTeamPlayers);
            m_iMatchID = iMatchID;
        }

        private void frmSetTeamPlayer_Load(object sender, EventArgs e)
        {
            Localization();
            ResetTeamSplitPlayers();
        }

        private void Localization()
        {
            String strSectionName = SQCommon.m_strSectionName;
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmSetTeamPlayers");
        }

        private void ResetTeamSplitPlayers()
        {
            SQCommon.g_ManageDB.GetTeamSplitPlayer(m_iMatchID, this.dgvTeamPlayers);
            SetGridStyle(dgvTeamPlayers);
        }

        private void dgvTeamPlayers_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            String strColumnName = dgvTeamPlayers.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvTeamPlayers.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                Int32 iMatchSplitID = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_MatchSplitID");
                Int32 iPosA = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_HomePosition");
                Int32 iPosB = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_AwayPosition");

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

                if (strColumnName.CompareTo("HomeName") == 0)
                {
                    SQCommon.g_ManageDB.UpdateTeamSplitMember(m_iMatchID, iMatchSplitID, iInputKey, iPosA);
                }
                else if (strColumnName.CompareTo("AwayName") == 0)
                {
                    SQCommon.g_ManageDB.UpdateTeamSplitMember(m_iMatchID, iMatchSplitID, iInputKey, iPosB);
                }

                ResetTeamSplitPlayers();
                dgvTeamPlayers.Rows[iRowIndex].Selected = true;
            }
        }

        private void dgvTeamPlayers_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvTeamPlayers.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex < 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                Int32 iHomeID = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_HomeID");
                Int32 iAwayID = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_AwayID");
                Int32 iPosA = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_HomePosition");
                Int32 iPosB = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_AwayPosition");

                if (dgvTeamPlayers.Columns[iColumnIndex].Name.CompareTo("HomeName") == 0)
                {
                    SQCommon.g_ManageDB.InitHomeNamesCombBox(ref dgvTeamPlayers, iColumnIndex, m_iMatchID, iHomeID, iPosA);
                }
                else if (dgvTeamPlayers.Columns[iColumnIndex].Name.CompareTo("AwayName") == 0)
                {
                    SQCommon.g_ManageDB.InitHomeNamesCombBox(ref dgvTeamPlayers, iColumnIndex, m_iMatchID, iAwayID, iPosB);
                }
            }
        }

        private void SetGridStyle(DataGridView dgv)
        {
            dgv.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;

            if (dgv == dgvTeamPlayers)
            {
                if (dgvTeamPlayers.Columns["HomeName"] != null)
                {
                    dgvTeamPlayers.Columns["HomeName"].ReadOnly = false;
                }
                if (dgvTeamPlayers.Columns["AwayName"] != null)
                {
                    dgvTeamPlayers.Columns["AwayName"].ReadOnly = false;
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
