using System;
using OVRDVPlugin.View;

namespace OVRDVPlugin
{
    public partial class frmMatchJudge : DevComponents.DotNetBar.Office2007Form
    {
        private int m_matchID;
        public frmMatchJudge(int matchID)
        {
            InitializeComponent();
            m_matchID = matchID;
        }

        private void frmMatchJudge_Load(object sender, EventArgs e)
        {
            wpfJudgeHost.Child = new MatchJudgeView(m_matchID);
        }
    }
}
