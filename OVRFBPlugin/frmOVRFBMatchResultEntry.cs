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



namespace AutoSports.OVRFBPlugin
{
    public partial class frmMatchResultEntry : Office2007Form
    {
        int m_iMatchID;
        string m_strWinByDes;
        int m_iWinBy;
        int m_iDiff;

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
            String strSectionName = GVAR.g_FBPlugin.GetSectionName(); ;
            //this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmMatchResultEntry");
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

        private void frmMatchResultEntry_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (MessageBoxEx.Show("If the result is valid and you accept it, press yes button,the result will not be recalculated when the match status become official.If you press no button,the result will be recalculated when match status become official! ","",MessageBoxButtons.YesNo,MessageBoxIcon.Warning,MessageBoxDefaultButton.Button2)== DialogResult.Yes)
            {

                Int32 iInputKey1 = 0;
                Int32 iInputKey2 = 0;
                DataGridViewCell CurCell1 = dgvMatchResult.Rows[0].Cells[1];
                DataGridViewCell CurCell2 = dgvMatchResult.Rows[1].Cells[1];
                if (CurCell1 != null)
                {

                    if (CurCell1 is DGVCustomComboBoxCell)
                    {
                        DGVCustomComboBoxCell CurCell1tmp = CurCell1 as DGVCustomComboBoxCell;
                        iInputKey1 = Convert.ToInt32(CurCell1tmp.Tag);
                    }
                }
                if (CurCell2 != null)
                {

                    if (CurCell2 is DGVCustomComboBoxCell)
                    {
                        DGVCustomComboBoxCell CurCell2tmp = CurCell2 as DGVCustomComboBoxCell;
                        iInputKey2 = Convert.ToInt32(CurCell2tmp.Tag);
                    }
                }
                if ((iInputKey1 == 1 && iInputKey2 == 2) || (iInputKey1 == 2 && iInputKey2 == 1) || (iInputKey1 == 3 && iInputKey2 == 3))
                {
                    this.DialogResult = DialogResult.Yes;
                    return;
                }
                else
                {
                    this.DialogResult = DialogResult.No;
                    return;
                }
               
            }
            else
            {
                this.DialogResult = DialogResult.No;
                return;
            }
        }
    }
}
