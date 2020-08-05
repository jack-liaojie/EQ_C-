using System.Windows.Controls;
using OVRRUPlugin.ViewModel;
using OVRRUPlugin.Common;
using System.Data;
using System.Text.RegularExpressions;
using System;

namespace OVRRUPlugin.View
{
    /// <summary>
    /// Interaction logic for MatchActionUpdate.xaml
    /// </summary>
    public partial class MatchActionUpdate : UserControl
    {
        #region Private Fields

        private int m_actionNumberID;

        #endregion

        #region Public Fields

        public delegate void CloseFatherWindowDelegate();
        public event CloseFatherWindowDelegate ClosewindowEvent;

        #endregion

        public MatchActionUpdate()
        {
            InitializeComponent();
        }

        public MatchActionUpdate(int actionNumberID)
        {
            InitializeComponent();
            m_actionNumberID = actionNumberID;

            InitialUserControl(actionNumberID);
        }

        private void InitialUserControl(int actionNumberID)
        {
            MatchAction matchActoin = GVAR.g_ManageDB.GetSingleMatchActioin(GVAR.g_matchID, actionNumberID);
            if (matchActoin == null)
                return;

            InitialComboBox_Period(matchActoin.Period);
            InitialComboBox_Action();
            InitialComboBox_ShirtNumber(matchActoin.ComPos);

            txtTime.Text = matchActoin.MatchTime;
            txtNoc.Text = matchActoin.Noc;
            txtScorehome.Text = matchActoin.ScoreHome.ToString();
            txtScoreaway.Text = matchActoin.ScoreAway.ToString();

            cbShirtNumber.SelectedValue = matchActoin.ShirtNumber;
            cbAction.SelectedValue = matchActoin.ActionTypeID;
        }

        private void InitialComboBox_Action()
        {
            DataTable dt = new DataTable();
            GVAR.g_ManageDB.GetAllActionType(ref dt);
            if (dt.Rows.Count <= 0) return;

            cbAction.ItemsSource = dt.DefaultView;
            cbAction.DisplayMemberPath = "Name";
            cbAction.SelectedValuePath = "ID";
        }

        private void InitialComboBox_ShirtNumber(int compos)
        {
            DataTable dt = new DataTable();
            GVAR.g_ManageDB.GetAllMatchMember(GVAR.g_matchID, compos, ref dt);
            if (dt.Rows.Count <= 0) return;

            cbShirtNumber.ItemsSource = dt.DefaultView;
            cbShirtNumber.SelectedValuePath = "ID";
            cbShirtNumber.DisplayMemberPath = "Name";

        }

        private void InitialComboBox_Period(int period)
        {
            cbPeriod.ItemsSource = GetDataTableForComboBox_Period().DefaultView;
            cbPeriod.DisplayMemberPath = "Name";
            cbPeriod.SelectedValuePath = "ID";

            cbPeriod.SelectedValue = period;
        }

        private DataTable GetDataTableForComboBox_Period()
        {
            DataTable dt = new DataTable();

            DataColumn column = new DataColumn();
            column.DataType = System.Type.GetType("System.Int32");
            column.ColumnName = "ID";
            dt.Columns.Add(column);

            column = new DataColumn();
            column.ColumnName = "Name";
            column.DataType = System.Type.GetType("System.String");
            dt.Columns.Add(column);

            DataRow row;
            row = dt.NewRow();
            row["ID"] = 1;
            row["Name"] = "Half 1";
            dt.Rows.Add(row);

            row = dt.NewRow();
            row["ID"] = 2;
            row["Name"] = "Half 2";
            dt.Rows.Add(row);

            row = dt.NewRow();
            row["ID"] = 3;
            row["Name"] = "Ext";
            dt.Rows.Add(row);

            return dt;
        }

        private void ButtonOK_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtScoreaway.Text) || string.IsNullOrWhiteSpace(txtScorehome.Text) || string.IsNullOrWhiteSpace(txtTime.Text))
            {
                GVAR.MsgBox("Can not have empty field!");
                return;
            }

            string regRule = @"^\d{2}:\d{2}$";
            Regex regex = new Regex(regRule);
            Match m = regex.Match(txtTime.Text);
            if (!m.Success)
            {
                GVAR.MsgBox("time pattern is error. must be 05:34");
                return;
            }

            try
            {
                MatchAction matchAction = new MatchAction();
                matchAction.ActionNumberID = m_actionNumberID;
                matchAction.ActionTypeID = int.Parse(cbAction.SelectedValue.ToString());
                matchAction.Period = int.Parse(cbPeriod.SelectedValue.ToString());
                matchAction.MatchTime = txtTime.Text;
                matchAction.ScoreHome = int.Parse(txtScorehome.Text);
                matchAction.ScoreAway = int.Parse(txtScoreaway.Text);
                matchAction.ShirtNumber = int.Parse(cbShirtNumber.SelectedValue.ToString());

                GVAR.g_ManageDB.UpdateMatchAction(matchAction);
            }
            catch
            {

            }
            finally
            {
                ClosewindowEvent();
            }
        }

        private void ButtonCancel_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            ClosewindowEvent();
        }


    }
}
