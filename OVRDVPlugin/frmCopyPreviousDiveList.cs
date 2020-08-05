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
    public partial class CopyPreviousDiveListForm : Office2007Form
    {
        public Int32 m_iCurMatchID;
        public Int32 m_iSportID;
        public Int32 m_iDisciplineID;
        public Int32 m_iCurCompetitionPosition;
        public String m_strLanguageCode = "ENG";
        public Int32 m_iSelectedMatchID;

        public CopyPreviousDiveListForm()
        {
            InitializeComponent();
            CustomSetDgvList(ref this.dgvPreviousMatchList);
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
            IntiPreviousMatchDgvList();
        }

        private void IntiPreviousMatchDgvList()
        {
            DVCommon.g_DVDBManager.InitPreviousMatchList(m_iCurMatchID, ref this.dgvPreviousMatchList);

            if (dgvPreviousMatchList.Columns["F_MatchID"] != null)
            {
                dgvPreviousMatchList.Columns["F_MatchID"].Visible = false;
            }
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            if (dgvPreviousMatchList.SelectedRows.Count > 0)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvPreviousMatchList.SelectedRows[0];
                Int32 iRowIdx = row.Index;

                string strValue = dgvPreviousMatchList.Rows[iRowIdx].Cells["F_MatchID"].Value.ToString();
                m_iSelectedMatchID = Convert.ToInt32(strValue);
                this.DialogResult = DialogResult.OK;
            }
            else
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("You Must Select one previous Match First!", "Dive List", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

        }

        private void btnCancle_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
        }
    }
}
