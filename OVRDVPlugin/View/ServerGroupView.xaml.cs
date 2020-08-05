using System;
using System.Windows.Input;
using System.Windows;
using System.Windows.Media;
using System.Windows.Controls;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Windows.Data;
using System.Windows.Controls.Primitives;

namespace OVRDVPlugin.View
{
    /// <summary>
    /// Interaction logic for ServerGroupView.xaml
    /// </summary>
    public partial class ServerGroupView : UserControl
    {
        private int m_matchID;

        private ObservableCollection<ServerGroup> m_serverGroup;

        public ServerGroupView()
        {
            InitializeComponent();
        }

        

        public ServerGroupView(int matchID)
        {
            InitializeComponent();
            m_matchID = matchID;
            this.Loaded += this.UserControl_Loaded;
        }

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            m_serverGroup = DatabaseOperation.GetServerGroups(m_matchID);
            grdServerGrid.ItemsSource = m_serverGroup;

        }

        private void btnAddGroup_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtGroupLongname.Text) || string.IsNullOrWhiteSpace(txtGroupShortname.Text))
            {
                AthleticsCommon.MsgBox("LongName and ShortName could not be null");
                return;
            }
            else
            {
                DatabaseOperation.AddServerGroup(m_matchID, txtGroupLongname.Text, txtGroupShortname.Text);

                m_serverGroup = DatabaseOperation.GetServerGroups(m_matchID);
                grdServerGrid.ItemsSource = m_serverGroup;
            }
        }

        private void btnRemoveGroup_Click(object sender, RoutedEventArgs e)
        {
            if (AthleticsCommon.MsgBox("Are you sure to delete selected ServerGroup?", System.Windows.Forms.MessageBoxButtons.OKCancel, System.Windows.Forms.MessageBoxIcon.Warning) == System.Windows.Forms.DialogResult.Cancel)
            {
                return;
            }

            if (grdServerGrid.SelectedIndex < 0)
            {
                AthleticsCommon.MsgBox("Please select a ServerGroup which you want to remove.");
                return;
            }

            try
            {
                ServerGroup serverGroup = grdServerGrid.SelectedItem as ServerGroup;
                DatabaseOperation.DeleteServerGroup(m_matchID, serverGroup.Order);

                m_serverGroup = DatabaseOperation.GetServerGroups(m_matchID);
                grdServerGrid.ItemsSource = m_serverGroup;
            }
            catch
            {

            }        
        }

        private void btnUpdateGroup_Click(object sender, RoutedEventArgs e)
        {
            if (grdServerGrid.SelectedIndex < 0)
            {
                return;
            }

            try
            {
                if (string.IsNullOrWhiteSpace(txtGroupLongname.Text) || string.IsNullOrWhiteSpace(txtGroupShortname.Text))
                {
                    AthleticsCommon.MsgBox("LongName and ShortName could not be null");
                    return;
                }
                else
                {
                    ServerGroup serverGroup = grdServerGrid.SelectedItem as ServerGroup;
                    DatabaseOperation.UpdateServerGroup(m_matchID,serverGroup.Order,txtGroupLongname.Text, txtGroupShortname.Text);

                    m_serverGroup = DatabaseOperation.GetServerGroups(m_matchID);
                    grdServerGrid.ItemsSource = m_serverGroup;

                    txtGroupShortname.Text = "";
                    txtGroupLongname.Text = "";
                }
            }
            catch
            {

            }
        }

        private void grdServerGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (grdServerGrid.SelectedIndex < 0)
            { 
                return;
            }

            try
            {
                ServerGroup serverGroup = grdServerGrid.SelectedItem as ServerGroup;
                txtGroupLongname.Text = serverGroup.GroupLongName;
                txtGroupShortname.Text = serverGroup.GroupShortName;
            }
            catch
            {

            }
        }

    }

    
}
