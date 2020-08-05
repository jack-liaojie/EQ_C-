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



namespace AutoSports.OVRBKPlugin
{
    public partial class frmMatchResultEntry : Office2007Form
    {
        int m_iMatchID;

        public frmMatchResultEntry(int iMatchID)
        {
            InitializeComponent();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchResult);
            m_iMatchID = iMatchID;
        }

        private void frmMatchResultEntry_Load(object sender, EventArgs e)
        {
            Localization();
            ResetMatchResult();
        }


        private void Localization()
        {
            String strSectionName = GVAR.g_BKPlugin.GetSectionName(); ;
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmMatchResultEntry");
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
                    iInputValue = Convert.ToInt32(CurCell.Value);
                }

                if (strColumnName.CompareTo("MatchResult") == 0)
                {
                    GVAR.g_ManageDB.UpdateMatchResult(m_iMatchID, iPosition, iInputKey);
                }
                else if (strColumnName.CompareTo("IRM") == 0)
                {
                    GVAR.g_ManageDB.UpdateMatchIRM(m_iMatchID, iPosition, iInputKey);
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
                    GVAR.g_ManageDB.InitMatchResultCombBox(ref dgvMatchResult, iColumnIndex, m_iMatchID, iPosition);
                }
                else if (dgvMatchResult.Columns[iColumnIndex].Name.CompareTo("IRM") == 0)
                {
                    GVAR.g_ManageDB.InitIRMCombBox(ref dgvMatchResult, iColumnIndex, m_iMatchID);
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

        private void ResetMatchResult()
        {
            GVAR.g_ManageDB.GetMatchResult(m_iMatchID, ref dgvMatchResult);
        }
    }
}
