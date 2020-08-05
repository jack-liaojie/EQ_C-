using System;
using DevComponents.DotNetBar;
using OVRRUPlugin.View;
using OVRRUPlugin.Common;

namespace OVRRUPlugin
{
    public partial class frmOVRRUDataEntry :Office2007Form
    {
        public frmOVRRUDataEntry()
        {
            InitializeComponent();
        }

        public void OnMsgFlushSelMatch(int nWndMode, int nMatchID)
        {
            if (nMatchID <= 0)
            {
                MessageBoxEx.Show("Please select a match!");
                return;
            }

            if (GVAR.g_matchID == nMatchID)
            {

            }
            else
            {
                if (GVAR.g_matchID >0)
                {
                    MessageBoxEx.Show("please exit the current match");
                    return;
                }

            }

            GVAR.g_matchID = nMatchID;

            MainUsercontrol mainUserControl = null;
            if (wpfHost.Child == null)
            {
                mainUserControl = new MainUsercontrol();
                wpfHost.Child = mainUserControl;
            }
            mainUserControl = wpfHost.Child as MainUsercontrol;
            mainUserControl.IsEnabled = true;
            mainUserControl.LoadMatchData(nMatchID);

        }

        private void wpfHost_ChildChanged(object sender, System.Windows.Forms.Integration.ChildChangedEventArgs e)
        {

        }

        private void frmOVRRUDataEntry_Load(object sender, EventArgs e)
        {
            MainUsercontrol mainUserControl = new MainUsercontrol();
            wpfHost.Child = mainUserControl;
            mainUserControl.IsEnabled = false;
        }
    }
}
