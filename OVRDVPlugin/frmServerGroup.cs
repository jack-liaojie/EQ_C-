using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using OVRDVPlugin.View;

namespace OVRDVPlugin
{
    public partial class frmServerGroup : Form
    {
        public frmServerGroup()
        {
            InitializeComponent();
        }

        private int m_matchID;

        public frmServerGroup(int matchID)
        {
            InitializeComponent();

            m_matchID = matchID;
        }

        private void frmServerGroup_Load(object sender, EventArgs e)
        {
            wpfServerGroupHost.Child = new ServerGroupView(m_matchID);
        }
    }
}
