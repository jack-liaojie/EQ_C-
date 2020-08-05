using System;
using System.Windows.Input;
using System.Windows;
using System.Windows.Media;
using System.Windows.Controls;
using OVRDVPlugin.ViewModel;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Windows.Data;
using System.Windows.Controls.Primitives;

namespace OVRDVPlugin.View
{
    /// <summary>
    /// Interaction logic for MatchJudgeView.xaml
    /// </summary>
    public partial class MatchJudgeView : UserControl
    {
        public MatchJudgeView()
        {
            InitializeComponent();
        }
        private ObservableCollection<JudgeInfo> m_unSelJudge;
        private ObservableCollection<JudgeInfo> m_selJudge;

        private ObservableCollection<ServerGroup> m_serverGroup;

        private int m_serverGroupID = -1;

        private int m_matchID;
        public MatchJudgeView(int matchID)
        {

            InitializeComponent();
            m_matchID = matchID;
            this.Loaded += this.UserControl_Loaded;

            if (cmbServerGroup.SelectedValue != null)
            {
                m_serverGroupID = Convert.ToInt32(cmbServerGroup.SelectedValue);
            }
        }

        private void UserControl_Loaded(object sender, System.Windows.RoutedEventArgs e)
        {
            JudgeInfo.g_functions = DatabaseOperation.GetJudgeFunctions(m_matchID);
            JudgeInfo.g_positions = DatabaseOperation.GetJudgePositions(m_matchID);

            m_serverGroup = DatabaseOperation.GetServerGroups_All(m_matchID);
            m_selJudge = DatabaseOperation.GetMatchOfficials(m_matchID, m_serverGroupID);
            m_unSelJudge = DatabaseOperation.GetAvailableOfficial(m_matchID);
            grdSelJudge.ItemsSource = m_selJudge;
            grdUnSelJudge.ItemsSource = m_unSelJudge;
            FilterUnSelJudges();

            cmbServerGroup.ItemsSource = m_serverGroup;
        }

        private void ComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            ComboBox cmb = (sender as ComboBox);
            int functionID = (int)cmb.SelectedValue;

            JudgeFunction func = (cmb.ItemsSource as ObservableCollection<JudgeFunction>)[cmb.SelectedIndex];
            string newFunctionName = func.Function.Substring(func.Function.IndexOf('|') + 1);
            DataGridRow row = (DataGridRow)AthleticsCommon.VisualTreeSearchUp(cmb, typeof(DataGridRow));

            if (row != null)
            {
                JudgeInfo judge = row.DataContext as JudgeInfo;
                if (DatabaseOperation.UpdateJudgeFunction(m_matchID, judge.ServantNum, functionID))
                {
                    judge.Function = newFunctionName;
                }
                else
                {
                    AthleticsCommon.ShowLastErrorBox();
                }
            }
            grdSelJudge.CancelEdit();
        }

        private void ComboBox_PositionChanged(object sender, SelectionChangedEventArgs e)
        {
            ComboBox cmb = (sender as ComboBox);
            int positionID = (int)cmb.SelectedValue;

            JudgePosition pos = (cmb.ItemsSource as ObservableCollection<JudgePosition>)[cmb.SelectedIndex];
            string newPosName = pos.Position;
            DataGridRow row = (DataGridRow)AthleticsCommon.VisualTreeSearchUp(cmb, typeof(DataGridRow));

            if (row != null)
            {
                JudgeInfo judge = row.DataContext as JudgeInfo;
                if (DatabaseOperation.UpdateJudgePosition(m_matchID, judge.ServantNum, positionID))
                {
                    judge.Position = newPosName;
                }
                else
                {
                    AthleticsCommon.ShowLastErrorBox();
                }
            }
            grdSelJudge.CancelEdit();
        }

        private void btnRemove_Click(object sender, RoutedEventArgs e)
        {
            if (grdSelJudge.SelectedIndex < 0)
            {
                AthleticsCommon.MsgBox("Please select a judge which you want to remove.");
                return;
            }

            JudgeInfo pos = grdSelJudge.SelectedItem as JudgeInfo;
            if (DatabaseOperation.UpdateMatchOfficial(m_matchID, pos.ServantNum, -1))
            {
                pos.Name = "";
                pos.NOC = "";
                m_unSelJudge = DatabaseOperation.GetAvailableOfficial(m_matchID);
                grdUnSelJudge.ItemsSource = m_unSelJudge;
                FilterUnSelJudges();
            }
            else
            {
                AthleticsCommon.ShowLastErrorBox();
                return;
            }

        }

        private void btnUpdate_Click(object sender, RoutedEventArgs e)
        {
            UpdateJudge();
        }

        private bool UpdateJudge()
        {
            if (grdUnSelJudge.SelectedIndex < 0)
            {
                AthleticsCommon.MsgBox("Please select a judge in left list!");
                return false;
            }
            if (grdSelJudge.SelectedIndex < 0)
            {
                AthleticsCommon.MsgBox("Please select a position in right list!");
                return false;
            }

            JudgeInfo judge = grdUnSelJudge.SelectedItem as JudgeInfo;
            JudgeInfo pos = grdSelJudge.SelectedItem as JudgeInfo;
            if (DatabaseOperation.UpdateMatchOfficial(m_matchID, pos.ServantNum, judge.RegisterID))
            {
                m_unSelJudge = DatabaseOperation.GetAvailableOfficial(m_matchID);
                grdUnSelJudge.ItemsSource = m_unSelJudge;
                FilterUnSelJudges();
                m_selJudge = DatabaseOperation.GetMatchOfficials(m_matchID, m_serverGroupID);
                grdSelJudge.ItemsSource = m_selJudge;
            }
            else
            {
                AthleticsCommon.ShowLastErrorBox();
                return false;
            }
            return true;
        }

        private void btnNewPosition_Click(object sender, RoutedEventArgs e)
        {
            JudgeInfo judge = grdUnSelJudge.SelectedItem as JudgeInfo;
            JudgeInfo pos = grdSelJudge.SelectedItem as JudgeInfo;
            if (DatabaseOperation.AddMatchOfficial(m_matchID, m_serverGroupID))
            {
                m_selJudge = DatabaseOperation.GetMatchOfficials(m_matchID, m_serverGroupID);
                grdSelJudge.ItemsSource = m_selJudge;
            }
            else
            {
                AthleticsCommon.ShowLastErrorBox();
            }
        }

        private void FilterUnSelJudges()
        {
            string strFilter = tbFilter.Text;
            ICollectionView view = CollectionViewSource.GetDefaultView(m_unSelJudge);
            if (view != null)
            {
                view.Filter = (param) =>
                {
                    JudgeInfo judge = param as JudgeInfo;
                    if (strFilter.Trim() == "")
                    {
                        return true;
                    }
                    string orgName = judge.Name.ToLower();
                    if (orgName.IndexOf(strFilter.ToLower()) >= 0)
                    {
                        return true;
                    }
                    return false;
                };
            }
        }

        private void TextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            FilterUnSelJudges();
        }

        private void TextBox_PreviewKeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Down)
            {
                e.Handled = true;
                TextBox tb = sender as TextBox;

                DataGridRow dgr = (DataGridRow)grdUnSelJudge.ItemContainerGenerator.ContainerFromIndex(0);
                if (dgr == null)
                {
                    return;
                }
                grdUnSelJudge.SelectedIndex = 0;
                grdUnSelJudge.Focus();
                DataGridCellsPresenter presenter = AthleticsCommon.GetVisualChild<DataGridCellsPresenter>(dgr);

                DataGridCell cell = (DataGridCell)presenter.ItemContainerGenerator.ContainerFromIndex(1);
                if (cell != null)
                {
                    cell.Focus();
                }


                //dgr.Focus();

            }
        }

        private void grdUnSelJudge_PreviewKeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Up)
            {
                if (grdUnSelJudge.SelectedIndex <= 0)
                {
                    tbFilter.SelectAll();
                    tbFilter.Focus();
                }
            }
            if (e.Key == Key.Enter)
            {
                int orgIndex = grdSelJudge.SelectedIndex;
                if (UpdateJudge())
                {

                    if (orgIndex < grdSelJudge.Items.Count - 1)
                    {
                        grdSelJudge.SelectedIndex = orgIndex + 1;
                    }
                    tbFilter.Focus();
                    tbFilter.SelectAll();
                }
                else
                {
                    e.Handled = true;
                }
            }

        }

        private void btnDelPos_Click(object sender, RoutedEventArgs e)
        {
            if (AthleticsCommon.MsgBox("Are you sure to delete selected judge position?", System.Windows.Forms.MessageBoxButtons.OKCancel, System.Windows.Forms.MessageBoxIcon.Warning) == System.Windows.Forms.DialogResult.Cancel)
            {
                return;
            }
            if (grdSelJudge.SelectedIndex < 0)
            {
                AthleticsCommon.MsgBox("Please select a judge which you want to remove.");
                return;
            }
            JudgeInfo pos = grdSelJudge.SelectedItem as JudgeInfo;
            if (DatabaseOperation.DelMatchOfficial(m_matchID, pos.ServantNum))
            {
                m_selJudge.RemoveAt(grdSelJudge.SelectedIndex);
                m_unSelJudge = DatabaseOperation.GetAvailableOfficial(m_matchID);
                grdUnSelJudge.ItemsSource = m_unSelJudge;
                FilterUnSelJudges();
            }
            else
            {
                AthleticsCommon.ShowLastErrorBox();
            }
        }

        private void btnDelAll_Click(object sender, RoutedEventArgs e)
        {
            if (AthleticsCommon.MsgBox("Are you sure to delete all judge positions?", System.Windows.Forms.MessageBoxButtons.OKCancel, System.Windows.Forms.MessageBoxIcon.Warning) == System.Windows.Forms.DialogResult.Cancel)
            {
                return;
            }
            if (DatabaseOperation.ClearOfficialPosition(m_matchID, m_serverGroupID))
            {
                m_unSelJudge = DatabaseOperation.GetAvailableOfficial(m_matchID);
                grdUnSelJudge.ItemsSource = m_unSelJudge;
                FilterUnSelJudges();
                m_selJudge.Clear();
            }
            else
            {
                AthleticsCommon.ShowLastErrorBox();
            }
        }

        private void btnGroup_Click(object sender, RoutedEventArgs e)
        {
            frmServerGroup frmServerGroupdlg = new frmServerGroup(m_matchID);
            frmServerGroupdlg.ShowDialog();

            m_serverGroup = DatabaseOperation.GetServerGroups_All(m_matchID);
            cmbServerGroup.ItemsSource = m_serverGroup;
        }

        private void cmbServerGroup_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

            if (cmbServerGroup.SelectedValue != null)
            {
                m_serverGroupID = Convert.ToInt32(cmbServerGroup.SelectedValue);
            }

            m_selJudge = DatabaseOperation.GetMatchOfficials(m_matchID, m_serverGroupID);
            grdSelJudge.ItemsSource = m_selJudge;

        }

        private void btnGenerate_Click(object sender, RoutedEventArgs e)
        {
            if (DatabaseOperation.InitOfficialPosition(m_matchID, m_serverGroupID))
            {
                m_selJudge = DatabaseOperation.GetMatchOfficials(m_matchID, m_serverGroupID);
                grdSelJudge.ItemsSource = m_selJudge;
            }
        }
    }

    public class JudgeFunction : BaseViewModel
    {

        private string m_function;
        public string Function
        {
            get { return m_function; }
            set
            {
                if (value != m_function)
                {
                    m_function = value;
                    NotifyPropertyChanged("Function");
                }
            }
        }

        private string m_functioinCode;
        public string FunctionCode
        {
            get { return m_functioinCode; }
            set
            {
                if (value != m_functioinCode)
                {
                    m_functioinCode = value;
                    NotifyPropertyChanged("FunctionCode");
                }
            }
        }

        private int m_functionID;
        public int FunctionID
        {
            get { return m_functionID; }
            set
            {
                if (value != m_functionID)
                {
                    m_functionID = value;
                    NotifyPropertyChanged("FunctionID");
                }
            }
        }
    }
    /// <summary>
    /// 添加裁判组类
    /// </summary>
    public class ServerGroup : BaseViewModel
    {
        string m_groupLongName;
        public string GroupLongName
        {
            get { return m_groupLongName; }
            set
            {
                if (value != m_groupLongName)
                {
                    m_groupLongName = value;
                    NotifyPropertyChanged("GroupLongName");
                }
            }
        }

        string m_groupShortName;
        public string GroupShortName
        {
            get { return m_groupShortName; }
            set
            {
                if (value != m_groupShortName)
                {
                    m_groupShortName = value;
                    NotifyPropertyChanged("GroupShortName");
                }
            }
        }

        string m_groupCode;
        public string GroupCode
        {
            get { return m_groupCode; }
            set
            {
                if (value != m_groupCode)
                {
                    m_groupCode = value;
                    NotifyPropertyChanged("GroupCode");
                }
            }
        }

        int m_order;
        public int Order
        {
            get { return m_order; }
            set
            {
                if (value != m_order)
                {
                    m_order = value;
                    NotifyPropertyChanged("Order");
                }
            }
        }

        int m_groupID;
        public int GroupID
        {
            get { return m_groupID; }
            set
            {
                if (m_groupID != value)
                {
                    m_groupID = value;
                    NotifyPropertyChanged("GroupID");
                }
            }
        }
    }

    public class JudgePosition : BaseViewModel
    {
        private int m_positionID;
        public int PositionID
        {
            get { return m_positionID; }
            set
            {
                if (value != m_positionID)
                {
                    m_positionID = value;
                    NotifyPropertyChanged("PositionID");
                }
            }
        }

        private string m_potion;
        public string Position
        {
            get { return m_potion; }
            set
            {
                if (value != m_potion)
                {
                    m_potion = value;
                    NotifyPropertyChanged("Position");
                }
            }
        }


    }

    public class JudgeInfo : BaseViewModel
    {
        public static ObservableCollection<JudgeFunction> g_functions;
        public ObservableCollection<JudgeFunction> Functions
        {
            get { return g_functions; }
            set
            {
                g_functions = value;
            }
        }

        public static ObservableCollection<JudgePosition> g_positions;
        public ObservableCollection<JudgePosition> Positions
        {
            get { return g_positions; }
            set
            {
                g_positions = value;
            }
        }

        public static ObservableCollection<ServerGroup> g_serverGroups;
        public ObservableCollection<ServerGroup> ServerGroups
        {
            get { return g_serverGroups; }
            set
            {
                g_serverGroups = value;
            }
        }

        private int m_registerID;
        public int RegisterID
        {
            get { return m_registerID; }
            set
            {
                if (value != m_registerID)
                {
                    m_registerID = value;
                    NotifyPropertyChanged("RegisterID");
                }
            }
        }

        private string m_noc;
        public string NOC
        {
            get { return m_noc; }
            set
            {
                if (value != m_noc)
                {
                    m_noc = value;
                    NotifyPropertyChanged("NOC");
                }
            }
        }

        private string m_name;
        public string Name
        {
            get { return m_name; }
            set
            {
                if (value != m_name)
                {
                    m_name = value;
                    NotifyPropertyChanged("Name");
                }
            }
        }

        private string m_function;
        public string Function
        {
            get { return m_function; }
            set
            {
                if (value != m_function)
                {
                    m_function = value;
                    NotifyPropertyChanged("Function");
                }
            }
        }

        private int m_functionID;
        public int FunctionID
        {
            get { return m_functionID; }
            set
            {
                if (value != m_functionID)
                {
                    m_functionID = value;
                    NotifyPropertyChanged("FunctionID");
                }
            }
        }

        private string m_position;
        public string Position
        {
            get { return m_position; }
            set
            {
                if (value != m_position)
                {
                    m_position = value;
                    NotifyPropertyChanged("Position");
                }
            }
        }

        private int m_positionID;
        public int PositionID
        {
            get { return m_positionID; }
            set
            {
                if (value != m_positionID)
                {
                    m_positionID = value;
                    NotifyPropertyChanged("PositionID");
                }
            }
        }

        private int m_groupID;
        public int GroupID
        {
            get { return m_groupID; }
            set
            {
                if (value != m_groupID)
                {
                    m_groupID = value;
                    NotifyPropertyChanged("GroupID");
                }
            }
        }

        private string m_group;
        public string Group
        {
            get { return m_group; }
            set
            {
                if (value != m_group)
                {
                    m_group = value;
                    NotifyPropertyChanged("Group");
                }
            }
        }


        private int m_servantNum;
        public int ServantNum
        {
            get { return m_servantNum; }
            set
            {
                if (value != m_servantNum)
                {
                    m_servantNum = value;
                    NotifyPropertyChanged("ServantNum");
                }
            }
        }

    }
}
