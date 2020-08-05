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
using System.IO;

namespace AutoSports.OVRBDPlugin
{
    public partial class frmImportTempData : Office2007Form
    {
        private int m_iMatchID = -1;
        public frmImportTempData(int matchID)
        {
            m_iMatchID = matchID;
            InitializeComponent();
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvTempSetData);
            dgvTempSetData.MultiSelect = false;
        }

        private void frmImportTempData_Load(object sender, EventArgs e)
        {
            DataTable dt = new DataTable("Sets");
            dt.Columns.Add("FileName", typeof(string));
            dt.Columns.Add("Set", typeof(string));
            string strMatchID = m_iMatchID.ToString();
            strMatchID = strMatchID.PadLeft(5, '0');
            string[] strFiles = Directory.GetFiles( BDCommon.GetTempMatchDir(), string.Format("9?{0}_Result.xml", strMatchID ));
            foreach ( string strFilePath in strFiles )
            {
                string strName = Path.GetFileName(strFilePath);
                DataRow drNew = dt.NewRow();
                drNew["FileName"] = strName;
                drNew["Set"] = strName.Substring(1, 1);
                dt.Rows.Add(drNew);
            }
            OVRDataBaseUtils.FillDataGridView(dgvTempSetData, dt);
        }

        private void btnViewFile_Click(object sender, EventArgs e)
        {
            if ( dgvTempSetData.SelectedRows.Count <= 0 )
            {
                MessageBoxEx.Show("Please select a set first.");
                return;
            }
            DataGridViewRow dgvr = dgvTempSetData.SelectedRows[0];
            string strFileName = dgvr.Cells["FileName"].Value.ToString();
            BDCommon.ShellOpenFile(Path.Combine(BDCommon.GetTempMatchDir(), strFileName));
        }

        private void btnImport_Click(object sender, EventArgs e)
        {
            if (dgvTempSetData.SelectedRows.Count <= 0)
            {
                MessageBoxEx.Show("Please select a set first.");
                return;
            }
            DataGridViewRow dgvr = dgvTempSetData.SelectedRows[0];
            string strFileName = dgvr.Cells["FileName"].Value.ToString();
            int setOrder = Convert.ToInt32( dgvr.Cells["Set"].Value);
            string strPath = Path.Combine(BDCommon.GetTempMatchDir(), strFileName);
            string strXml = File.ReadAllText(strPath, System.Text.Encoding.Default);
            int startPos = strXml.IndexOf("<MatchInfo");
            if ( startPos == -1 )
            {
                MessageBoxEx.Show("Invalid file format.");
                return;
            }
            strXml = strXml.Substring(startPos);
            int res = BDCommon.g_ManageDB.ImportTempMatchData(m_iMatchID, setOrder, strXml);
            if ( res == -1 )
            {
                MessageBoxEx.Show("Set split id can not be found.");
                return;
            }
            else if (res == -2)
            {
                MessageBoxEx.Show("Can not import because of official status");
                return;
            }
            else if (res == -3)
            {
                MessageBoxEx.Show("The match is not a team match.");
                return;
            }
            else if ( res == 0 )
            {
                MessageBoxEx.Show("Imported failed");
                return;
            }
            MessageBoxEx.Show("Import succeed.");
        }
    }
}
