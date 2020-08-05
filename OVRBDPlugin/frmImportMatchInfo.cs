using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using AutoSports.OVRCommon;

namespace AutoSports.OVRBDPlugin
{
    public partial class frmImportMatchInfo : Form
    {
        public frmImportMatchInfo(string strImportDir, XmlTypeEnum xmlType)
        {
            InitializeComponent();
            OVRDataBaseUtils.SetDataGridViewStyle(dgMatchInfo);
            importDir_ = strImportDir;
            xmlType_ = xmlType;
            if( xmlType_ == XmlTypeEnum.XmlTypeMatchInfo )
            {
                btnImportAllAction.Visible = false;
                this.Text = "Import Match Result";
            }
            else
            {
                this.Text = "Import Match Action";
            }
        }

        private XmlTypeEnum xmlType_;
        private string importDir_;
        public string GetMatchCodeXml()
        {
            string[] allXmlFiles = Directory.GetFiles(importDir_, "*.xml");
            if ( allXmlFiles == null || allXmlFiles.Length == 0 )
            {
                return "";
            }
            bool bAdded = false;
            //List<string> codeCollection = new List<string>();
            string xml = "<AllCode>\r\n";
            string temp = "";
            if ( xmlType_ == XmlTypeEnum.XmlTypeMatchInfo )
            {
                foreach (string file in allXmlFiles)
                {
                    temp = Path.GetFileName(file);
                    if (temp.IndexOf("Result") != -1)
                    {
                        xml += string.Format("<Match MatchCode=\"{0}\" />\r\n", temp.Substring(0, 9));
                        bAdded = true;
                    }
                }
            }
            else
            {
                foreach (string file in allXmlFiles)
                {
                    temp = Path.GetFileName(file);
                    if (temp.IndexOf("Score") != -1)
                    {
                        xml += string.Format("<Match MatchCode=\"{0}\" />\r\n", temp.Substring(0, 9));
                        bAdded = true;
                    }
                }
            }
            xml += "</AllCode>";
            if ( !bAdded )
            {
                return "";
            }
            return xml;
        }

        private void btnRefreshMatch_Click(object sender, EventArgs e)
        {
            int res = RefreshUI();
            if ( res == -1 )
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("Match code not found!");
            }
            else if ( res == -2 )
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("MatchCode is not exist in database!");
            }
        }

        private void btnImportMatch_Click(object sender, EventArgs e)
        {
            if ( dgMatchInfo.SelectedRows.Count == 0 )
            {
                return;
            }
          //  TSDataExchangeTT_Service.SetDiffQueueToDiff();
            string strType = xmlType_ == XmlTypeEnum.XmlTypeMatchInfo ? "Result" : "Score";
            TSDataExchangeTT_Service service = (BDCommon.g_BDPlugin.GetModuleUI as frmOVRBDDataEntry).TTExchangeService;
            foreach (DataGridViewRow row in dgMatchInfo.SelectedRows)
            {
                string fileName = Path.Combine(importDir_, string.Format("{0}_{1}.xml", row.Cells[0].Value.ToString(), strType));
                service.AddExtraTask(fileName,false);
            }
            foreach ( DataGridViewRow row in dgMatchInfo.SelectedRows )
            {
                dgMatchInfo.Rows.Remove(row);
            }
        }

        private int RefreshUI()
        {
            string strXml = GetMatchCodeXml();
            if ( strXml == "" )
            {
                return -1;
            }
            DataTable dt = BDCommon.g_ManageDB.GetMatchInfoFromRscXml(strXml);
            if (dt == null)
            {
                return -2;
            }
            OVRDataBaseUtils.FillDataGridView(dgMatchInfo, dt);
            return 1;
        }

        private void frmImportMatchInfoLoaded(object sender, EventArgs e)
        {
            RefreshUI();
        }

        private void btnImportAllAction_Click(object sender, EventArgs e)
        {
            if (dgMatchInfo.SelectedRows.Count == 0)
            {
                return;
            }
            string strType = xmlType_ == XmlTypeEnum.XmlTypeMatchInfo ? "Result" : "Score";
            TSDataExchangeTT_Service service = (BDCommon.g_BDPlugin.GetModuleUI as frmOVRBDDataEntry).TTExchangeService;
           // TSDataExchangeTT_Service.SetDiffQueueToDiff();
            foreach (DataGridViewRow row in dgMatchInfo.SelectedRows)
            {
                string fileName = Path.Combine(importDir_, string.Format("{0}_{1}.xml", row.Cells[0].Value.ToString(), strType));
                
                service.AddExtraTask(fileName, true);
            }
            foreach (DataGridViewRow row in dgMatchInfo.SelectedRows)
            {
                dgMatchInfo.Rows.Remove(row);
            }
        }

        private void btnOpenXml_Click(object sender, EventArgs e)
        {
            if ( dgMatchInfo.SelectedRows.Count != 1)
            {
                MessageBox.Show("You can only select one row!");
                return;
            }
            string strType = xmlType_ == XmlTypeEnum.XmlTypeMatchInfo ? "Result" : "Score";
            string fileName = Path.Combine(importDir_, string.Format("{0}_{1}.xml", dgMatchInfo.SelectedRows[0].Cells[0].Value.ToString(), strType));
            BDCommon.OpenWithNotepad(fileName);
        }
    }
}
