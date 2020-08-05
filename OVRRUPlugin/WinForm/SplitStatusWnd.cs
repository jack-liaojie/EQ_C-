using System;
using DevComponents.DotNetBar;

namespace OVRRUPlugin
{
    public partial class SplitStatusWnd : Office2007Form
    {

        private  int m_SplitStatusID;
        public int SpliltStatusID
        {
            get { return m_SplitStatusID; }
            set { m_SplitStatusID = value; }
        }

        private int m_MatchSplitID;
        public int MatchSplitID
        {
            get { return m_MatchSplitID; }
            set { m_MatchSplitID = value; }
        }

        public SplitStatusWnd(int splitStatusID)
        {
            InitializeComponent();

            m_SplitStatusID = splitStatusID;

            if (Convert.ToInt32(btnRunning.Tag) == m_SplitStatusID)
            {
                btnRunning.Enabled = false;
                btnAvailable.Enabled = true;
                btnOfficial.Enabled = true;
            }
            else if(Convert.ToInt32(btnOfficial.Tag) == m_SplitStatusID)
            {
                btnOfficial.Enabled = false;
                btnAvailable.Enabled = true;
                btnRunning.Enabled = true;
            }
            else
            {
                btnAvailable.Enabled = false;
                btnRunning.Enabled = true;
                btnOfficial.Enabled = true;
            }

        }

        private void btnSplitStatus_Click(object sender, EventArgs e)
        {
            ButtonX btn=sender as ButtonX;
            m_SplitStatusID = Convert.ToInt32(btn.Tag);
            this.Close();
        }
    }
}
