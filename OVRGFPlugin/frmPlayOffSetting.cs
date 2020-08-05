using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

namespace AutoSports.OVRGFPlugin
{
    public partial class frmPlayOffSetting : DevComponents.DotNetBar.Office2007Form
    {
        public Int32 m_iCurMatchID;
        public string m_strHoleSec = "";

        public frmPlayOffSetting()
        {
            InitializeComponent();
        }

        private void Localization()
        {
        }

        private void frmPlayOffSetting_Load(object sender, EventArgs e)
        {
            Localization();

            Init_Grid();
        }

        private void Init_Grid()
        {
            DataGridView dgv = this.dgvHoleList;
            dgv.Columns.Clear();
            DataGridViewColumn col = null;
            string strHoleSec = m_strHoleSec;
            int nHoleCount = 18;

             for (int n = 1; n <= nHoleCount; n++)
            {
                col = new DataGridViewTextBoxColumn();
                col.ReadOnly = false;
                col.HeaderText = n.ToString();
                col.Name = n.ToString();
                col.Frozen = false;
                col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
                col.SortMode = DataGridViewColumnSortMode.Programmatic;
                col.Resizable = DataGridViewTriState.False;
                col.Width = 20;
                col.ValueType = typeof(string);
                dgv.Columns.Add(col);
             }

            dgv.Rows.Clear();

            DataGridViewRow row = new DataGridViewRow();
            row.CreateCells(dgv);
            row.Selected = false;
            if (nHoleCount > 0)
                dgv.Rows.Add(row);

            string strFieldName = "";
            string strFieldValue = "";
             for (int n = 1; n <= nHoleCount; n++)
            {
                strFieldName = n.ToString();

                if (strHoleSec.Length >= (2 * (n - 1) + 2))
                    strFieldValue = strHoleSec.Substring(2 * (n - 1), 2);
                else if (strHoleSec.Length == (2 * (n - 1) + 1))
                    strFieldValue = strHoleSec.Substring(2 * (n - 1), 1);
                else
                    strFieldValue = "";
                if (strFieldValue == "00")
                    strFieldValue = "";
                if (strFieldValue.Length == 2)
                    strFieldValue = int.Parse(strFieldValue).ToString();

                 row.Cells[strFieldName].Value = strFieldValue;
            }
        }

        private void btnx_OK_Click(object sender, EventArgs e)
        {
            DataGridView dgv = this.dgvHoleList;
            int nHoleCount = 18;

            string strHoleSec = "";
            for (int n = 1; n <= nHoleCount; n++)
            {
                int nColIdx = n - 1;
                Object obValue = dgv.Rows[0].Cells[nColIdx].Value;
                if (obValue == null)
                {
                    strHoleSec += "00";
                }
                else
                {
                    if (obValue.ToString().Length == 0)
                        strHoleSec += "00";
                    else
                    {
                        strHoleSec += string.Format("{0:D2}", int.Parse(obValue.ToString()));
                    }
                }
            }

            m_strHoleSec = strHoleSec;

            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void btnx_Cancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void dgvHoleList_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (e.FormattedValue != null)
            {//HoleSec
                string strText = e.FormattedValue.ToString();
                int nOut = 0;
                if (e.FormattedValue.ToString().Length != 0 &&
                    !int.TryParse(e.FormattedValue.ToString(), out nOut))
                    e.Cancel = true;
                if (nOut < 0 || nOut > 99)
                    e.Cancel = true;
            }
        }
    }
}
