using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using AutoSports.OVRBDPlugin;
using System.Windows.Forms;

namespace OVRBDWPF
{
    /// <summary>
    /// Interaction logic for ResultsInput.xaml
    /// </summary>
    public partial class ResultsInput : System.Windows.Controls.UserControl
    {
        public ResultsInput()
        {
            InitializeComponent();
            timer.Interval = 5000;
            timer.Tick += new EventHandler(timer_Tick);
        }
        void timer_Tick(object sender, EventArgs e)
        {
            foreach ( InputScoreItem item in warpPanel.Children)
            {
                item.UpdateData();
            }
        }
        Timer timer = new Timer();
        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            //InputScoreItem item = new InputScoreItem();
            //item.UpdateData(61);
            //InputScoreItem item1 = new InputScoreItem();
            //item1.UpdateData(61);
            //InputScoreItem item2 = new InputScoreItem();
            //item2.UpdateData(61);
            //InputScoreItem item3 = new InputScoreItem();
            //item3.UpdateData(61);
            //InputScoreItem item3 = new InputScoreItem();
            //item3.UpdateData(61);
            ////grdScoreContainer.Children.Add(item);
            //warpPanel.Children.Add(item);
            //warpPanel.Children.Add(item1);
            //warpPanel.Children.Add(item2);
            //warpPanel.Children.Add(item3);
            //for( int i = 0; i<9; i++)
            //{
            //    InputScoreItem item = new InputScoreItem();
            //    item.UpdateData(61);
            //    warpPanel.Children.Add(item);
            //}
        }

        private void chkAutoClicked(object sender, RoutedEventArgs e)
        {
            if (chkAutoRefresh.IsChecked == true)
            {
                timer.Start();
            }
            else
            {
                timer.Stop();
            }
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            warpPanel.Children.Clear();
            List<string> matchIDs = BDCommon.g_ManageDB.GetAllRunningMatchID();
            if ( matchIDs == null || matchIDs.Count == 0 )
            {
                return;
            }
            foreach ( string strMatchID in matchIDs)
            {
                InputScoreItem item = new InputScoreItem();
                item.UpdateData(Convert.ToInt32(strMatchID));
                warpPanel.Children.Add(item);
            }
        }
    }
}
