using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

namespace AutoSports.OVRSHPlugin
{
    public partial class DataSourceForm : DevComponents.DotNetBar.Office2007Form
    {
        public string m_strIP = "224.0.0.1";
        public string m_strPort = "5100";
        public string m_strPath = "z:";

        public DataSourceForm()
        {
            InitializeComponent();
            val2UI();
        }

        private void val2UI()
        {
            textBoxTcpServer.Text = m_strIP;
            textBoxTcpPort.Text = m_strPort;
            textBoxPath.Text = m_strPath;
        }
        private void BtnConnectTcp_Click(object sender, EventArgs e)
        {
            m_strIP = textBoxTcpServer.Text;
            m_strPort = textBoxTcpPort.Text;
            m_strPath = textBoxPath.Text;
            this.Close();
        }

        private void btnDisconnecttcp_Click(object sender, EventArgs e)
        {
            
        }

        private void buttonPath_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog dlg = new FolderBrowserDialog();
            if (dlg.ShowDialog() == DialogResult.OK)
            {
                textBoxPath.Text = dlg.SelectedPath;
            }
        }

    }
}
