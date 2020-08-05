using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using AutoSports.OVRCommon;
using DevComponents.DotNetBar;

namespace AutoSports.OVRBDPlugin
{
    public partial class SelfCheckErrorFrm : Office2007Form
    {
        public SelfCheckErrorFrm()
        {
            InitializeComponent();
            string lang = BDCommon.g_ManageDB.GetActiveLanguageCode();
            if ( string.IsNullOrEmpty(lang) || lang == "ENG" )
            {
                cmbLang.SelectedIndex = 0;
            }
            else
            {
                cmbLang.SelectedIndex = 1;
            }
            
            OVRDataBaseUtils.SetDataGridViewStyle(dgvToCheckErr);
            OVRDataBaseUtils.SetDataGridViewStyle(dgvCheckResult);
            dgvToCheckErr.Columns.Add("CheckItem", "CheckItem");
            dgvToCheckErr.Columns.Add("Status", "Status");
        }

        private DataTable m_orgItems;
        private void btnAddCheck_Click(object sender, EventArgs e)
        {
            if ( listToCheckItems.SelectedItems.Count == 0 )
            {
                return;
            }
            int[] removeIndexs = new int[listToCheckItems.SelectedItems.Count];
            listToCheckItems.SelectedIndices.CopyTo(removeIndexs, 0);

            for (int i = 0; i < listToCheckItems.SelectedItems.Count; i++)
            {
                string strItem = (string)listToCheckItems.SelectedItems[i];
                dgvToCheckErr.Rows.Add(strItem, "Not Checked");
            }
            Array.Sort(removeIndexs);
            for (int i = removeIndexs.Length - 1; i >= 0; i-- )
            {
                listToCheckItems.Items.RemoveAt(removeIndexs[i]);
            }
        }

        private void btnRemoveCheck_Click(object sender, EventArgs e)
        {
            if ( dgvToCheckErr.SelectedRows.Count == 0 )
            {
                return;
            }
            int[] removeIndexs = new int[dgvToCheckErr.SelectedRows.Count];
            for (int i = 0; i < dgvToCheckErr.SelectedRows.Count; i++)
            {
                DataGridViewRow dgvr = dgvToCheckErr.SelectedRows[i];
                string strItem = (string)dgvr.Cells[0].Value;
                listToCheckItems.Items.Add(strItem);
                removeIndexs[i] = dgvr.Index;
            }
            Array.Sort(removeIndexs);
            for (int i = removeIndexs.Length - 1; i >= 0; i--)
            {
                dgvToCheckErr.Rows.RemoveAt(removeIndexs[i]);
            }
        }

        private void selfCheckLoaded(object sender, EventArgs e)
        {
            m_orgItems = BDCommon.g_ManageDB.GetToCheckErrorItems();
            for (int i = 0; i < m_orgItems.Rows.Count; i++ )
            {
                DataRow dr = m_orgItems.Rows[i];
                listToCheckItems.Items.Add(dr[0]);
            }
            
        }

        private void btnStartCheck_Click(object sender, EventArgs e)
        {
            if ( dgvToCheckErr.Rows.Count == 0 )
            {
                MessageBoxEx.Show("Please select items which you want to check.");
                return;
            }
            foreach ( DataGridViewRow dgvr in dgvToCheckErr.Rows )
            {
                dgvr.Cells[1].Value = "Not Checked";
            }
            string lang = cmbLang.SelectedIndex == 0 ? "ENG" : "CHN";
            dgvToCheckErr.ClearSelection();
            for ( int i = 0; i < dgvToCheckErr.Rows.Count; i++ )
            {
                string strItem = dgvToCheckErr.Rows[i].Cells[0].Value.ToString();
                string status = dgvToCheckErr.Rows[i].Cells[1].Value.ToString();
                dgvToCheckErr.Rows[i].Selected = true;
                dgvToCheckErr.CurrentCell = dgvToCheckErr.Rows[i].Cells[0];
    
                DataTable dtRes = BDCommon.g_ManageDB.GetSelfCheckError(strItem, lang);
                if ( dtRes != null )
                {
                    dgvToCheckErr.Rows[i].Cells[1].Value = "Checked Error";
                    OVRDataBaseUtils.FillDataGridView(dgvCheckResult, dtRes);
                    dgvToCheckErr.ClearSelection();
                    dgvCheckResult.ClearSelection();
                    MessageBoxEx.Show("Find an error!If you want to continue,fix it first.");
                    return;
                }
                else
                {
                    dgvToCheckErr.Rows[i].Cells[1].Value = "Checked Succeed";
                }
                System.Windows.Forms.Application.DoEvents();
                System.Threading.Thread.Sleep(50);
                dgvToCheckErr.ClearSelection();
            }

            dgvCheckResult.Rows.Clear();
            MessageBoxEx.Show("All check succeed!");
        }

        private void dgvToCheckErr_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            if (e.ColumnIndex == 1 && e.Value != null)
            {
                switch (e.Value.ToString())
                {
                    case "Not Checked":
                        e.CellStyle.SelectionForeColor = Color.Blue;
                        e.CellStyle.ForeColor = Color.Blue;
                        break;
                    case "Checked Error":
                        e.CellStyle.SelectionForeColor = Color.Red;
                        e.CellStyle.ForeColor = Color.Red;
                        break;
                    case "Checked Succeed":
                        e.CellStyle.SelectionForeColor = Color.Green;
                        e.CellStyle.ForeColor = Color.Green;
                        break;
                }
            }
        }

        private void btnContinueCheck_Click(object sender, EventArgs e)
        {
            if (dgvToCheckErr.Rows.Count == 0)
            {
                MessageBoxEx.Show("Please select items which you want to check.");
                return;
            }
            string lang = cmbLang.SelectedIndex == 0 ? "ENG" : "CHN";
            dgvToCheckErr.ClearSelection();
            for (int i = 0; i < dgvToCheckErr.Rows.Count; i++)
            {
                string strItem = dgvToCheckErr.Rows[i].Cells[0].Value.ToString();
                string status = dgvToCheckErr.Rows[i].Cells[1].Value.ToString();
                dgvToCheckErr.Rows[i].Selected = true;
                dgvToCheckErr.CurrentCell = dgvToCheckErr.Rows[i].Cells[0];
                if (status == "Checked Succeed")
                {
                    continue;
                }
                DataTable dtRes = BDCommon.g_ManageDB.GetSelfCheckError(strItem, lang);
                if (dtRes != null)
                {
                    dgvToCheckErr.Rows[i].Cells[1].Value = "Checked Error";
                    OVRDataBaseUtils.FillDataGridView(dgvCheckResult, dtRes);
                    dgvToCheckErr.ClearSelection();
                    dgvCheckResult.ClearSelection();
                    MessageBoxEx.Show("Find an error!If you want to continue,fix it first.");
                    return;
                }
                else
                {
                    dgvToCheckErr.Rows[i].Cells[1].Value = "Checked Succeed";
                }
                System.Windows.Forms.Application.DoEvents();
                System.Threading.Thread.Sleep(50);
                dgvToCheckErr.ClearSelection();
            }

            dgvCheckResult.Rows.Clear();

            MessageBoxEx.Show("All check succeed!");
        }

        private void SelfCheckErrorFrm_FormClosing(object sender, FormClosingEventArgs e)
        {
            e.Cancel = true;
            this.Visible = false;
        }
    }
}
