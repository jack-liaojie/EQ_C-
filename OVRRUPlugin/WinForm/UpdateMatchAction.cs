using System;
using System.Windows.Forms;
using OVRRUPlugin.View;

namespace OVRRUPlugin
{
    public partial class UpdateMatchAction : Form
    {
        public UpdateMatchAction()
        {
            InitializeComponent();
        }

        private int actionNumberID;

        public UpdateMatchAction(int actionNumberID)
        {
            InitializeComponent();
            this.actionNumberID = actionNumberID;
        }

        private void UpdateMatchAction_Load(object sender, EventArgs e)
        {
            MatchActionUpdate matchAction = new MatchActionUpdate(actionNumberID);
            wpfHost.Child = matchAction;

            matchAction.ClosewindowEvent += new MatchActionUpdate.CloseFatherWindowDelegate(CloseWindow);
            //matchAction
        }

        void CloseWindow()
        {
            this.Close();
        }

    }
}
