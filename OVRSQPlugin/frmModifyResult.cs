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
    public partial class frmModifyResult : Office2007Form
    {
        Int32 m_iMatchID;
        Int32 m_iMatchSplitID;

        public frmModifyResult(Int32 nMatchID, Int32 nMatchSpitID)
        {
            InitializeComponent();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchResult);
            m_iMatchID = nMatchID;
            m_iMatchSplitID = nMatchSpitID;
        }

        private void frmModifyResult_Load(object sender, EventArgs e)
        {
            Localization();
            ResetMatchResult();
        }

        private void Localization()
        {
            String strSectionName = SQCommon.m_strSectionName;
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmModifyResult");
        }

        private void ResetMatchResult()
        {
            SQCommon.g_ManageDB.GetMatchResult(m_iMatchID, m_iMatchSplitID, dgvMatchResult);
            SetGridStyle(dgvMatchResult);
        }

        private void SetGridStyle(DataGridView dgv)
        {
            dgv.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;

            if (dgv == dgvMatchResult)
            {
                if (dgvMatchResult.Columns["MatchResult"] != null)
                {
                    dgvMatchResult.Columns["MatchResult"].ReadOnly = false;
                }
                if (dgvMatchResult.Columns["IRM"] != null)
                {
                    dgvMatchResult.Columns["IRM"].ReadOnly = false;
                }
                if (dgvMatchResult.Columns["MatchPoint"] != null)
                {
                    dgvMatchResult.Columns["MatchPoint"].ReadOnly = false;
                }
            }
        }

        private void dgvMatchResult_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            String strColumnName = dgvMatchResult.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvMatchResult.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                Int32 iPosition = GetFieldValue(dgvMatchResult, iRowIndex, "F_CompetitionPosition");

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
                        ResetMatchResult();
                        return;
                    }
                }

                if (strColumnName.CompareTo("MatchResult") == 0)
                {
                    SQCommon.g_ManageDB.UpdateMatchResult(m_iMatchID, m_iMatchSplitID, iPosition, iInputKey);
                }
                else if (strColumnName.CompareTo("IRM") == 0)
                {
                    SQCommon.g_ManageDB.UpdateMatchIRM(m_iMatchID, m_iMatchSplitID, iPosition, iInputKey);
                }
                else if (strColumnName.CompareTo("MatchPoint") == 0)
                {
                    SQCommon.g_ManageDB.UpdateMatchScore(m_iMatchID, m_iMatchSplitID, iPosition, iInputValue);
                }

                ResetMatchResult();
                dgvMatchResult.Rows[iRowIndex].Selected = true;
            }
        }

        private void dgvMatchResult_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvMatchResult.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex < 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                Int32 iPosition = GetFieldValue(dgvMatchResult, iRowIndex, "F_CompetitionPosition");

                if (dgvMatchResult.Columns[iColumnIndex].Name.CompareTo("MatchResult") == 0)
                {
                    SQCommon.g_ManageDB.InitMatchResultCombBox(ref dgvMatchResult, iColumnIndex, m_iMatchID, m_iMatchSplitID, iPosition);
                }
                else if (dgvMatchResult.Columns[iColumnIndex].Name.CompareTo("IRM") == 0)
                {
                    SQCommon.g_ManageDB.InitIRMCombBox(ref dgvMatchResult, iColumnIndex, m_iMatchID);
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
    }
}
