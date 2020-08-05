using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing;

namespace AutoSports.OVRBDPlugin
{
    public partial class frmStateMonitor : Form
    {
        public frmStateMonitor()
        {
            InitializeComponent();
        }

        public void AddInfoToHeartMonitor( string strInfo, bool bNormal = true)
        {
            if ( richTBHeart.Lines.Length > 120 )
            {
                richTBHeart.Clear();
            }
            richTBHeart.AppendText("\n");
            if ( bNormal )
            {
                richTBHeart.SelectionColor = Color.Black;
            }
            else
            {
                richTBHeart.SelectionColor = Color.Red;
            }

            strInfo = DateTime.Now.ToString("T") + ": " + strInfo;

            richTBHeart.AppendText(strInfo);

            richTBHeart.SelectionStart = richTBHeart.MaxLength;
            richTBHeart.SelectionLength = 0;
            richTBHeart.ScrollToCaret();

        }

        public void AddInfoToFileMonitor(string strInfo, bool bNormal = true)
        {
            if (richTBFile.Lines.Length > 120)
            {
                richTBFile.Clear();
            }
            richTBFile.AppendText("\n");
            if (bNormal)
            {
                richTBFile.SelectionColor = Color.Black;
            }
            else
            {
                richTBFile.SelectionColor = Color.Red;
            }

            richTBFile.AppendText(strInfo);

            richTBFile.SelectionStart = richTBHeart.MaxLength;
            richTBFile.SelectionLength = 0;
            richTBFile.ScrollToCaret();
        }

        private void StateFrmClosing(object sender, FormClosingEventArgs e)
        {
            e.Cancel = true;
            this.Visible = false;
        }

        private void btnClearLeft_Click(object sender, EventArgs e)
        {
            richTBHeart.Clear();
        }

        private void btnClearRight_Click(object sender, EventArgs e)
        {
            richTBFile.Clear();
        }
    }
}
