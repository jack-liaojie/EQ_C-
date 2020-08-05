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

namespace OVRDVPlugin
{
    public partial class FixedDiveInfoForm : Office2007Form
    {
        public Int32 m_iCurMatchID;
        public Int32 m_iSportID;
        public Int32 m_iDisciplineID;
        public String m_strLanguageCode = "ENG";

        public FixedDiveInfoForm()
        {
            InitializeComponent();
            CustomSetDgvList(ref this.dgvAvailableDiveSplits);
            CustomSetDgvList(ref this.dgvFixedDiveSplits);
        }

        private void CustomSetDgvList(ref DataGridView theDgvlist)
        {
            OVRDataBaseUtils.SetDataGridViewStyle(theDgvlist);

            FontFamily fontFamily = new FontFamily("Arial");
            FontStyle fontStyle = new FontStyle();
            Font gridFont = new Font(fontFamily, 13, fontStyle);
            theDgvlist.Font = gridFont;
        }


        protected override void OnShown(EventArgs e)
        {
            base.OnShown(e);
            IntiMatchAvailableDiveSplitDgvList();
            IntiMatchFixedDiveSplitDgvList();
        }

        private void IntiMatchAvailableDiveSplitDgvList()
        {
            DVCommon.g_DVDBManager.InitMatchAvailableDiveSplits(m_iCurMatchID, ref this.dgvAvailableDiveSplits);

            if (dgvAvailableDiveSplits.Columns["F_MatchID"] != null)
            {
                dgvAvailableDiveSplits.Columns["F_MatchID"].Visible = false;
            }

            if (dgvAvailableDiveSplits.Columns["F_MatchSplitID"] != null)
            {
                dgvAvailableDiveSplits.Columns["F_MatchSplitID"].Visible = false;
            }

            if (dgvAvailableDiveSplits.Columns["F_MatchSplitCode"] != null)
            {
                dgvAvailableDiveSplits.Columns["F_MatchSplitCode"].Visible = false;
            }

        }

        private void IntiMatchFixedDiveSplitDgvList()
        {
            DVCommon.g_DVDBManager.InitMatchFixedDiveSplits(m_iCurMatchID, ref this.dgvFixedDiveSplits);

            if (dgvFixedDiveSplits.Columns["F_MatchID"] != null)
            {
                dgvFixedDiveSplits.Columns["F_MatchID"].Visible = false;
            }

            if (dgvFixedDiveSplits.Columns["F_MatchSplitID"] != null)
            {
                dgvFixedDiveSplits.Columns["F_MatchSplitID"].Visible = false;
            }

            if (dgvFixedDiveSplits.Columns["F_MatchSplitCode"] != null)
            {
                dgvFixedDiveSplits.Columns["F_MatchSplitCode"].Visible = false;
            }

            if (dgvFixedDiveSplits.Columns["Fixed Difficluty Value"] != null)
            {
                dgvFixedDiveSplits.Columns["Fixed Difficluty Value"].ReadOnly = false;
            }
        }

        private void btnAddOneFixedDiveSplit_Click(object sender, EventArgs e)
        {
            for (Int32 i = 0; i < this.dgvAvailableDiveSplits.SelectedRows.Count; i++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvAvailableDiveSplits.SelectedRows[i];
                Int32 iRowIdx = row.Index;

                string strValue = dgvAvailableDiveSplits.Rows[iRowIdx].Cells["F_MatchSplitID"].Value.ToString();
                Int32 iMatchSplitID = Convert.ToInt32(strValue);

                DVCommon.g_DVDBManager.ExcuteDV_AddOneFixedDiveSplit(m_iCurMatchID, iMatchSplitID);
            }

            IntiMatchAvailableDiveSplitDgvList();
            IntiMatchFixedDiveSplitDgvList();
        }

        private void btnDelOneFixedDiveSplit_Click(object sender, EventArgs e)
        {
            for (Int32 i = 0; i < this.dgvFixedDiveSplits.SelectedRows.Count; i++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvFixedDiveSplits.SelectedRows[i];
                Int32 iRowIdx = row.Index;

                string strValue = dgvFixedDiveSplits.Rows[iRowIdx].Cells["F_MatchSplitID"].Value.ToString();
                Int32 iMatchSplitID = Convert.ToInt32(strValue);

                DVCommon.g_DVDBManager.ExcuteDV_DelOneFixedDiveSplit(m_iCurMatchID, iMatchSplitID);
            }

            IntiMatchAvailableDiveSplitDgvList();
            IntiMatchFixedDiveSplitDgvList();
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
        }

        private void btnCancle_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
        }

        private void dgvFixedDiveSplits_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {

            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;
            
            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;

            String strColumnName = dgvFixedDiveSplits.Columns[iColumnIndex].Name;

            DataGridViewCell CurCell = dgvFixedDiveSplits.Rows[iRowIndex].Cells[iColumnIndex];
            if (CurCell != null)
            {
                String strInputString = "";

                string strMatchSplitID = dgvFixedDiveSplits.Rows[iRowIndex].Cells["F_MatchSplitID"].Value.ToString();
                Int32 iMatchSplitID = Convert.ToInt32(strMatchSplitID);

                if (CurCell.Value != null)
                {
                    strInputString = CurCell.Value.ToString();
                }
                else
                {
                    strInputString = "";
                }

                if (strColumnName.CompareTo("Fixed Difficluty Value") == 0)
                {
                    DVCommon.g_DVDBManager.ExcuteDV_UpdateOneFixedDiveSplitDifficultyValue(m_iCurMatchID, iMatchSplitID, strInputString);
                }               
            }

            IntiMatchFixedDiveSplitDgvList();

        }
    }
}
