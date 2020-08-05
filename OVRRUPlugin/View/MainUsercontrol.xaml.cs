using System;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.ComponentModel;
using OVRRUPlugin.Common;
using System.Windows.Controls;
using AutoSports.OVRCommon;
using OVRRUPlugin.ViewModel;
using CDV.Windows.Threading;
using System.Collections.ObjectModel;
using System.Windows.Threading;

namespace OVRRUPlugin.View
{
    /// <summary>
    /// Interaction logic for MainUsercontrol.xaml
    /// </summary>
    public partial class MainUsercontrol : System.Windows.Controls.UserControl, INotifyPropertyChanged
    {
        #region Private Fields

        private int m_curMatchID = 1;

        private int m_curMatchStatus = 30;

        private string m_nocHome;
        private string m_nocAway;

        private string m_matchDate;
        private string m_matchEvent;

        private MatchScoreInfo m_homeTeamScore;
        private MatchScoreInfo m_awayTeamScore;

        private CountTimer m_countTimer;//时钟变量
        private string m_currentTime = "00:00";
        private TimeSpan m_timeSpanCurrent;
        private delegate void UpdateStatus(Boolean isRunning);

        private ObservableCollection<MatchMemberAndAction> m_homeMemberOnCourt;
        private ObservableCollection<MatchMemberAndAction> m_homeMemberOnBench;
        private ObservableCollection<MatchMemberAndAction> m_awayMemberOnCourt;
        private ObservableCollection<MatchMemberAndAction> m_awayMemberOnBench;

        private string m_selectedPlayerName;
        private string m_selectedActionName;
        private string m_selectedActionCode;
        private MatchMemberAndAction m_matchMemberAndAction;

        private int m_curMatchSplitID = -1;
        private int m_MatchStatus_Split1 = 10;
        private int m_MatchStatus_Split2 = 10;
        private int m_MatchStatus_Split3 = 10;

        #endregion

        #region Public Property

        public int CurMatchStatus
        {
            get
            {
                return m_curMatchStatus;
            }
            set
            {
                if (value != m_curMatchStatus)
                {
                    m_curMatchStatus = value;
                    NotifyPropertyChanged("CurMatchStatus");
                }
            }
        }

        public string NOCHome
        {
            get { return m_nocHome; }
            set
            {
                if (value != m_nocHome)
                {
                    m_nocHome = value;
                    NotifyPropertyChanged("NOCHome");
                }
            }
        }

        public string NOCAway
        {
            get { return m_nocAway; }
            set
            {
                if (value != m_nocAway)
                {
                    m_nocAway = value;
                    NotifyPropertyChanged("NOCAway");
                }
            }
        }

        public string MatchEvent
        {
            get { return m_matchEvent; }
            set
            {
                if (value != m_matchEvent)
                {
                    m_matchEvent = value;
                    NotifyPropertyChanged("MatchEvent");
                }
            }
        }

        public string MatchDate
        {
            get { return m_matchDate; }
            set
            {
                if (value != m_matchDate)
                {
                    m_matchDate = value;
                    NotifyPropertyChanged("MatchDate");
                }
            }
        }

        public MatchScoreInfo HomeTeamScore
        {
            get { return m_homeTeamScore; }
            set
            {
                if (value != m_homeTeamScore)
                {
                    m_homeTeamScore = value;
                    NotifyPropertyChanged("HomeTeamScore");
                }
            }
        }

        public MatchScoreInfo AwayTeamScore
        {
            get { return m_awayTeamScore; }
            set
            {
                if (value != m_awayTeamScore)
                {
                    m_awayTeamScore = value;
                    NotifyPropertyChanged("AwayTeamScore");
                }
            }
        }

        public string CurrentTime
        {
            get { return m_currentTime; }
            set
            {
                if (value != m_currentTime)
                {
                    m_currentTime = value;
                    NotifyPropertyChanged("CurrentTime");
                }
            }
        }

        public string SelectedPlayerName
        {
            get { return m_selectedPlayerName; }
            set
            {
                if (value != m_selectedPlayerName)
                {
                    m_selectedPlayerName = value;
                    NotifyPropertyChanged("SelectedPlayerName");
                }
            }
        }

        public string SelectedActionName
        {
            get { return m_selectedActionName; }
            set
            {
                if (m_selectedActionName != value)
                {
                    m_selectedActionName = value;
                    NotifyPropertyChanged("SelectedActionName");
                }
            }
        }

        #endregion

        #region constructor

        public MainUsercontrol()
        {
            InitializeComponent();

            //m_nocAway = m_nocHome = "CHN";
            this.DataContext = this;

            m_countTimer = new CountTimer(TimeSpan.FromMinutes(0), this.CountTimerCurrentCallback, CountMode.Count, 1000);
            m_countTimer.StatusChanged += this.CountTimerOnStatusChanged;

            CourtPlayers_Home.SelectedChanged += new RoutedEventHandler(CourtPlayers_Home_SelectedChanged);
            CourtPlayers_Away.SelectedChanged += new RoutedEventHandler(CourtPlayers_Away_SelectedChanged);
            BenchPlayers_Away.SelectedChanged += new RoutedEventHandler(BenchPlayers_Away_SelectedChanged);
            BenchPlayers_Home.SelectedChanged += new RoutedEventHandler(BenchPlayers_Home_SelectedChanged);
        }

        #endregion

        #region Match Status
        /// <summary>
        /// status Button
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnStatus_Click(object sender, RoutedEventArgs e)
        {
            OpenStatusWindow();
        }

        private void OpenStatusWindow()
        {
            DoubleAnimation animation = new DoubleAnimation();
            animation.From = 0.0;
            animation.To = 1.0;
            animation.Duration = TimeSpan.FromMilliseconds(400);
            animation.FillBehavior = FillBehavior.HoldEnd;
            statusTrans.BeginAnimation(ScaleTransform.ScaleXProperty, animation);
            statusTrans.BeginAnimation(ScaleTransform.ScaleYProperty, animation);
        }

        private void CloseStatusWindow()
        {
            DoubleAnimation animation = new DoubleAnimation();
            animation.From = 1.0;
            animation.To = 0.0;
            animation.Duration = TimeSpan.FromMilliseconds(400);
            animation.FillBehavior = FillBehavior.HoldEnd;
            statusTrans.BeginAnimation(ScaleTransform.ScaleXProperty, animation);
            statusTrans.BeginAnimation(ScaleTransform.ScaleYProperty, animation);
        }

        private void btnClickStatusWnd(object sender, RoutedEventArgs e)
        {
            CloseStatusWindow();
        }

        private void BtnStatus_Click(object sender, RoutedEventArgs e)
        {
            System.Windows.Controls.Button btn = sender as System.Windows.Controls.Button;
            int newStatus = Convert.ToInt32(btn.Tag);
            if (newStatus == m_curMatchStatus)
            {
                return;
            }

            if (m_curMatchStatus != (int)MatchStatus.Scheduled && newStatus == (int)MatchStatus.StartList)
            {
                if (System.Windows.Forms.DialogResult.Cancel == GVAR.MsgBox("Are you confirm to change status to \"STARTLIST\"? To do this,all the match data will be cleared!",
                                "Warning", System.Windows.Forms.MessageBoxButtons.OKCancel, System.Windows.Forms.MessageBoxIcon.Warning))
                {
                    return;
                }
            }

            if (newStatus == (int)MatchStatus.Unofficial || newStatus == (int)MatchStatus.Official)
            {
                if (m_homeTeamScore.ScoreTotal > m_awayTeamScore.ScoreTotal)
                {
                    m_homeTeamScore.ResultID = GVAR.RESULT_TYPE_WIN;
                    m_homeTeamScore.RankID = GVAR.RANK_TYPE_1ST;
                    m_awayTeamScore.ResultID = GVAR.RESULT_TYPE_LOSE;
                    m_awayTeamScore.RankID = GVAR.RANK_TYPE_2ND;
                }
                else if (m_homeTeamScore.ScoreTotal == m_awayTeamScore.ScoreTotal)
                {
                    m_homeTeamScore.ResultID = GVAR.RESULT_TYPE_TIE;
                    m_homeTeamScore.RankID = GVAR.RANK_TYPE_TIE;
                    m_awayTeamScore.ResultID = GVAR.RESULT_TYPE_TIE;
                    m_awayTeamScore.RankID = GVAR.RANK_TYPE_TIE;
                }
                else if (m_homeTeamScore.ScoreTotal < m_awayTeamScore.ScoreTotal)
                {
                    m_homeTeamScore.ResultID = GVAR.RESULT_TYPE_LOSE;
                    m_homeTeamScore.RankID = GVAR.RANK_TYPE_2ND;
                    m_awayTeamScore.ResultID = GVAR.RESULT_TYPE_WIN;
                    m_awayTeamScore.RankID = GVAR.RANK_TYPE_1ST;
                }

                GVAR.g_ManageDB.UpdateMatchRank(m_curMatchID, m_homeTeamScore.RankID, m_homeTeamScore.ResultID, 1);
                GVAR.g_ManageDB.UpdateMatchRank(m_curMatchID, m_awayTeamScore.RankID, m_awayTeamScore.ResultID, 2);
            }

            if (OVRDataBaseUtils.ChangeMatchStatus(m_curMatchID, newStatus, GVAR.g_adoDataBase.DBConnect, GVAR.g_RUPlugin) != 1)
            {
                Log.WriteLog("RU_Error", "调用OVRDataBaseUtils.ChangeMatchStatus改变状态失败！");
                GVAR.MsgBox("Change match status failed!");
                return;
            }
            else
            {
                if (newStatus == (int)MatchStatus.Unofficial || newStatus == (int)MatchStatus.Official)
                {
                    GVAR.g_ManageDB.AutoProgressMatch(m_curMatchID);
                }

                GVAR.g_RUPlugin.DataChangedNotify(AutoSports.OVRCommon.OVRDataChangedType.emMatchStatus, -1, -1, -1, GVAR.g_matchID, GVAR.g_matchID, null);
            }

            CurMatchStatus = newStatus;
            GVAR.g_RUPlugin.UpdateMatchList();
            CloseStatusWindow();
        }

        #endregion

        #region Load Match Data

        public void LoadMatchData(int matchID)
        {
            m_curMatchID = matchID;

            //往ts_match_split_info 与 ts_match_split_result表里插入数据
            GVAR.g_ManageDB.CreateMatchSplit(matchID, 1, 0, 3);

            //初始化界面--比赛阶段和日期
            MatchEvent = GVAR.g_ManageDB.GetDataEntryTitle(matchID);
            MatchDate = GVAR.g_ManageDB.GetDataEntryDateAndVenue(matchID);

            //初始化比分和队名
            HomeTeamScore = GVAR.g_ManageDB.GetMatchScoreInfo(matchID, 1);
            AwayTeamScore = GVAR.g_ManageDB.GetMatchScoreInfo(matchID, 2);

            NOCAway = AwayTeamScore.NOC;
            NOCHome = HomeTeamScore.NOC;
            

            //初始化选中的Player和Action
            InitialMemberAndActioin();

            //初始化阶段
            InitialPeriod(matchID);

            //初始化对阵双方players
            InitialAwayMemnberDataGrid(matchID);
            InitialHomeMemnberDataGrid(matchID);

            //初始化Action DataGrid
            InitialActionDataGrid(matchID);

            //GetMatchTime(matchID);
            txtLastAction.Text = "";
            txtLastName.Text = "";

            //获取状态
            CurMatchStatus = GVAR.g_ManageDB.GetMatchStatus(matchID);

            //获取每节状态
            SetSplitStatusButtonContent(1, GVAR.g_ManageDB.GetSplitStatusID(matchID, 1));
            SetSplitStatusButtonContent(2, GVAR.g_ManageDB.GetSplitStatusID(matchID, 2));
            SetSplitStatusButtonContent(3, GVAR.g_ManageDB.GetSplitStatusID(matchID, 3));
        }

        private void InitialActionDataGrid(int matchID)
        {
            grdAction.ItemsSource = GVAR.g_ManageDB.GetMatchAction(matchID);
        }

        /// <summary>
        /// 获取开始时间
        /// </summary>
        /// <param name="matchID"></param>
        private void GetMatchTime(int matchID)
        {
            GVAR.g_ManageDB.GetMatchCompetitionRuleInfo(matchID);
            //InitialMatchDownTime();
        }

        /// <summary>
        /// 初始化比赛Period
        /// </summary>
        /// <param name="matchID"></param>
        private void InitialPeriod(int matchID)
        {
            GVAR.g_ManageDB.GetMatchCompetitionRuleInfo(matchID);
            GVAR.g_period = 1;
            SetPeriodBackground();
        }

        private void InitialHomeMemnberDataGrid(int matchID)
        {
            m_homeMemberOnCourt = GVAR.g_ManageDB.GetMemberAndAction(matchID, 1, 1);
            m_homeMemberOnBench = GVAR.g_ManageDB.GetMemberAndAction(matchID, 1, 0);

            CourtPlayers_Home.grdCourtPlayers.ItemsSource = m_homeMemberOnCourt;
            BenchPlayers_Home.grdCourtPlayers.ItemsSource = m_homeMemberOnBench;
        }

        private void InitialAwayMemnberDataGrid(int matchID)
        {
            m_awayMemberOnCourt = GVAR.g_ManageDB.GetMemberAndAction(matchID, 2, 1);
            m_awayMemberOnBench = GVAR.g_ManageDB.GetMemberAndAction(matchID, 2, 0);

            CourtPlayers_Away.grdCourtPlayers.ItemsSource = m_awayMemberOnCourt;
            BenchPlayers_Away.grdCourtPlayers.ItemsSource = m_awayMemberOnBench;
        }

        private void InitialMemberAndActioin()
        {
            m_matchMemberAndAction = null;
            SelectedPlayerName = "";
            SelectedActionName = "";
            m_selectedActionCode = "";

            BenchPlayers_Away.grdCourtPlayers.SelectedIndex = -1;
            CourtPlayers_Away.grdCourtPlayers.SelectedIndex = -1;
            BenchPlayers_Home.grdCourtPlayers.SelectedIndex = -1;
            CourtPlayers_Home.grdCourtPlayers.SelectedIndex = -1;

        }

        public void DoEvents()
        {
            DispatcherFrame frame = new DispatcherFrame();
            Dispatcher.CurrentDispatcher.BeginInvoke(DispatcherPriority.Background,
                new DispatcherOperationCallback(delegate(object f)
                {
                    ((DispatcherFrame)f).Continue = false;

                    return null;
                }
                    ), frame);
            Dispatcher.PushFrame(frame);
        }

        #endregion

        #region INotifyPropertyChanged Members

        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(String info)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(info));
            }
        }

        #endregion

        #region Matchtime

        private void CountTimerCurrentCallback(TimeSpan current)
        {
            m_timeSpanCurrent = current;
            CurrentTime = current.ToString(@"mm\:ss");
        }

        private void CountControlButtonOnClick(object sender, RoutedEventArgs e)
        {
            if (m_countTimer.IsRunning)
            {
                m_countTimer.Stop();
            }
            else
            {
                m_countTimer.Start();
            }
        }

        private void CountTimerOnStatusChanged(Object sender, CountTimerStatusChangedEventArgs e)
        {
            this.CountControlButton.Dispatcher.Invoke(new UpdateStatus((isRunning) =>
            {
                if (isRunning)
                {
                    this.CountControlButton.Content = "Stop";
                    this.CountControlButton.Foreground = Brushes.Red;
                }
                else
                {
                    this.CountControlButton.Content = "Start";
                    this.CountControlButton.Foreground = Brushes.Black;
                }
            }), e.IsRunning);
        }

        private void CountControlButtonClick(object sender, RoutedEventArgs e)
        {
            if (m_countTimer.IsRunning)
            {
                m_countTimer.Stop();
            }
            else
            {
                m_countTimer.Start();
            }
        }

        private void CountInCreaseMinute_Click(object sender, RoutedEventArgs e)
        {
            m_countTimer.IncreaseMinute();
        }

        private void CountDeCreaseMinute_Click(object sender, RoutedEventArgs e)
        {
            m_countTimer.DecreaseMinute();
        }

        private void CountInCreaseSecond_Click(object sender, RoutedEventArgs e)
        {
            m_countTimer.IncreaseSecond();
        }

        private void CountDecreaseSecond_Click(object sender, RoutedEventArgs e)
        {
            m_countTimer.DecreaseSecond();
        }

        private void CountControlEndButton_Click(object sender, RoutedEventArgs e)
        {
            TimeSpan tempTimeSpan;
            tempTimeSpan = TimeSpan.FromMinutes(0);

            if (m_countTimer.IsRunning)
                m_countTimer.Stop();

            m_countTimer.Change(tempTimeSpan);
        }

        #endregion

        #region Team Member Info
        private void btnTeamInfo_Click(object sender, RoutedEventArgs e)
        {
            SetTeamMemberStartUp();

            if (MessageBox.Show("您确认需要改变场上运动员吗", "请注意", MessageBoxButton.OKCancel) == MessageBoxResult.OK)
            {
                GVAR.g_ManageDB.SetActiveMember(m_curMatchID, 1);
                GVAR.g_ManageDB.SetActiveMember(m_curMatchID, 2);

                //初始化对阵双方players
                InitialAwayMemnberDataGrid(m_curMatchID);
                InitialHomeMemnberDataGrid(m_curMatchID);

                //初始化选中的Player和Action
                InitialMemberAndActioin();
            }

        }

        private void SetTeamMemberStartUp()
        {
            int iMatchID = GVAR.Str2Int(m_curMatchID);
            int iHomeRegID = GVAR.Str2Int(m_homeTeamScore.RegisterID);
            int iVisitRegID = GVAR.Str2Int(m_awayTeamScore.RegisterID);
            string strHomeName = m_homeTeamScore.TeamName;
            string strVisitName = m_awayTeamScore.TeamName;

            frmOVRFBTeamMemberEntry MatchMemberForm = new frmOVRFBTeamMemberEntry(iMatchID, iHomeRegID, iVisitRegID, strHomeName, strVisitName);
            MatchMemberForm.ShowDialog();

            //InitialMatchDownTime();
        }

        #endregion

        #region Config

        private void btnConfig_Click(object sender, RoutedEventArgs e)
        {
            SetTeamMemberStartUp();
        }

        #endregion

        #region Exit current Match
        private void btnExitMatch_Click(object sender, RoutedEventArgs e)
        {
            GVAR.g_matchID = m_curMatchID = -1;
            this.IsEnabled = false;

            GVAR.g_firstHalfTime = 7;
            GVAR.g_secondHalfTime = 7;
            GVAR.g_extraTime = 5;
            GVAR.g_hasExtraTime = false;
            GVAR.g_period = 0;
        }
        #endregion

        #region Period Button

        private void btnPrePeriod_Click(object sender, RoutedEventArgs e)
        {
            if (m_countTimer.IsRunning)
            {
                return;
            }

            if (GVAR.g_period > 1)
            {
                GVAR.g_period -= 1;
            }
            SetPeriodBackground();
            //InitialMatchDownTime();
        }

        private void btnNextPeriod_Click(object sender, RoutedEventArgs e)
        {
            if (m_countTimer.IsRunning)
            {
                return;
            }

            if (GVAR.g_period < 3)
            {
                if (GVAR.g_hasExtraTime)
                {
                    GVAR.g_period += 1;
                }
                else
                {
                    if (GVAR.g_period < 2)
                    {
                        GVAR.g_period += 1;
                    }
                }
            }

            SetPeriodBackground();
            //InitialMatchDownTime();
        }

        private void SetPeriodBackground()
        {
            if (GVAR.g_period == 1)
            {
                lbl1st.Background = Brushes.Yellow;
                lbl2nd.Background = lblsample.Background;
                lblext.Background = lblsample.Background;

                txtRound.Text = "1st Half";
            }
            else if (GVAR.g_period == 2)
            {
                lbl1st.Background = lblsample.Background;
                lbl2nd.Background = Brushes.Yellow;
                lblext.Background = lblsample.Background;

                txtRound.Text = "2nd Half";
            }
            else if (GVAR.g_period == 3)
            {
                lbl1st.Background = lblsample.Background;
                lbl2nd.Background = lblsample.Background;
                lblext.Background = Brushes.Yellow;

                txtRound.Text = "Extra Time";
            }


        }

        #endregion

        #region Score Button

        private void HomeScoreButton_Click(object sender, RoutedEventArgs e)
        {
            Button btn = sender as Button;
            int score = GVAR.Str2Int(btn.Tag.ToString());

            SetHomeScore(score);
        }

        private void SetHomeScore(int score)
        {
            if (GVAR.g_period == 1)
            {
                HomeTeamScore.ScoreFirst += score;
            }
            else if (GVAR.g_period == 2)
            {
                HomeTeamScore.ScoreSecond += score;
            }
            else if (GVAR.g_period == 3)
            {
                HomeTeamScore.ScoreExt += score;
            }
            HomeTeamScore.ScoreTotal = HomeTeamScore.ScoreFirst + HomeTeamScore.ScoreSecond + HomeTeamScore.ScoreExt;

            if (score == 5) HomeTeamScore.TryNum += 1;

            GVAR.g_ManageDB.UpdateMatchScore(m_curMatchID, 1, m_homeTeamScore.ScoreFirst, m_homeTeamScore.ScoreSecond, m_homeTeamScore.ScoreExt, m_homeTeamScore.ScoreTotal,m_homeTeamScore.TryNum);

            GVAR.g_RUPlugin.DataChangedNotify(AutoSports.OVRCommon.OVRDataChangedType.emMatchResult, -1, -1, -1, GVAR.g_matchID, GVAR.g_matchID, null);

        }

        private void AwayScoreButton_Click(object sender, RoutedEventArgs e)
        {
            Button btn = sender as Button;
            int score = GVAR.Str2Int(btn.Tag.ToString());

            SetAwayScore(score);
        }

        private void SetAwayScore(int score)
        {
            if (GVAR.g_period == 1)
            {
                AwayTeamScore.ScoreFirst += score;
            }
            else if (GVAR.g_period == 2)
            {
                AwayTeamScore.ScoreSecond += score;
            }
            else if (GVAR.g_period == 3)
            {
                AwayTeamScore.ScoreExt += score;
            }

            AwayTeamScore.ScoreTotal = AwayTeamScore.ScoreFirst + AwayTeamScore.ScoreSecond + AwayTeamScore.ScoreExt;
            if (score == 5) AwayTeamScore.TryNum += 1;

            GVAR.g_ManageDB.UpdateMatchScore(m_curMatchID, 2, m_awayTeamScore.ScoreFirst, m_awayTeamScore.ScoreSecond, m_awayTeamScore.ScoreExt, m_awayTeamScore.ScoreTotal,m_awayTeamScore.TryNum);

            GVAR.g_RUPlugin.DataChangedNotify(AutoSports.OVRCommon.OVRDataChangedType.emMatchResult, -1, -1, -1, GVAR.g_matchID, GVAR.g_matchID, null);
        }

        #endregion

        #region Player Selected Changed Event

        void BenchPlayers_Home_SelectedChanged(object sender, RoutedEventArgs e)
        {
            if (BenchPlayers_Home.grdCourtPlayers.SelectedIndex >= 0)
            {
                BenchPlayers_Away.grdCourtPlayers.SelectedIndex = -1;
                CourtPlayers_Away.grdCourtPlayers.SelectedIndex = -1;
                CourtPlayers_Home.grdCourtPlayers.SelectedIndex = -1;

                m_matchMemberAndAction = BenchPlayers_Home.grdCourtPlayers.SelectedItem as MatchMemberAndAction;
                SelectedPlayerName = m_matchMemberAndAction.Number.ToString() + "-" + m_matchMemberAndAction.Name;

                AddAction();
            }
        }

        void BenchPlayers_Away_SelectedChanged(object sender, RoutedEventArgs e)
        {
            if (BenchPlayers_Away.grdCourtPlayers.SelectedIndex >= 0)
            {
                BenchPlayers_Home.grdCourtPlayers.SelectedIndex = -1;
                CourtPlayers_Away.grdCourtPlayers.SelectedIndex = -1;
                CourtPlayers_Home.grdCourtPlayers.SelectedIndex = -1;

                m_matchMemberAndAction = BenchPlayers_Away.grdCourtPlayers.SelectedItem as MatchMemberAndAction;
                SelectedPlayerName = m_matchMemberAndAction.Number.ToString() + "-" + m_matchMemberAndAction.Name;

                AddAction();
            }
        }

        void CourtPlayers_Away_SelectedChanged(object sender, RoutedEventArgs e)
        {
            if (CourtPlayers_Away.grdCourtPlayers.SelectedIndex >= 0)
            {
                BenchPlayers_Away.grdCourtPlayers.SelectedIndex = -1;
                BenchPlayers_Home.grdCourtPlayers.SelectedIndex = -1;
                CourtPlayers_Home.grdCourtPlayers.SelectedIndex = -1;

                m_matchMemberAndAction = CourtPlayers_Away.grdCourtPlayers.SelectedItem as MatchMemberAndAction;
                SelectedPlayerName = m_matchMemberAndAction.Number.ToString() + "-" + m_matchMemberAndAction.Name;

                AddAction();
            }
        }

        void CourtPlayers_Home_SelectedChanged(object sender, RoutedEventArgs e)
        {
            if (CourtPlayers_Home.grdCourtPlayers.SelectedIndex >= 0)
            {
                BenchPlayers_Away.grdCourtPlayers.SelectedIndex = -1;
                CourtPlayers_Away.grdCourtPlayers.SelectedIndex = -1;
                BenchPlayers_Home.grdCourtPlayers.SelectedIndex = -1;

                m_matchMemberAndAction = CourtPlayers_Home.grdCourtPlayers.SelectedItem as MatchMemberAndAction;
                SelectedPlayerName = m_matchMemberAndAction.Number.ToString() + "-" + m_matchMemberAndAction.Name;

                AddAction();
            }
        }
        #endregion

        #region Action Button Event

        private void ButtonAction_Click(object sender, RoutedEventArgs e)
        {
            Button btnAction = sender as Button;

            #region Show ActioName
            if (btnAction.Content is TextBlock)
            {
                TextBlock tb = btnAction.Content as TextBlock;
                System.Windows.Documents.Run runFirst = tb.Inlines.FirstInline as System.Windows.Documents.Run;
                System.Windows.Documents.Run runSecond = tb.Inlines.LastInline as System.Windows.Documents.Run;
                SelectedActionName = runFirst.Text + " " + runSecond.Text;
            }
            else
            {
                SelectedActionName = btnAction.Content.ToString();
            }

            #endregion

            #region Ready to Action

            m_selectedActionCode = btnAction.Tag.ToString();

            if (m_selectedActionCode == "Reset")
            {
                InitialMemberAndActioin();

                return;
            }

            AddAction();

            #endregion

        }

        public void AddAction()
        {
            if (m_matchMemberAndAction == null || String.IsNullOrWhiteSpace(m_selectedActionCode))
            {
                return;
            }

            #region 根据ActionCode和Active(是否在场)进行判断操作是否有效
            switch (m_selectedActionCode)
            {
                case "In":
                    if (!m_matchMemberAndAction.Active)
                    {
                        GVAR.g_ManageDB.UpdateActiveInMember(m_curMatchID, m_matchMemberAndAction.ComPos, m_matchMemberAndAction.RegisterID, 1);
                    }
                    else
                    {
                        PopUpWindow(MyPopUpWindowType.OnCourt);
                        InitialMemberAndActioin();
                        return;
                    }
                    break;
                case "Try":
                    if (m_matchMemberAndAction.Active)
                    {
                        AddScoreByCompos(m_matchMemberAndAction.ComPos, GVAR.Score_Try);
                    }
                    else
                    {
                        PopUpWindow(MyPopUpWindowType.OnBench);
                        InitialMemberAndActioin();
                        return;
                    }
                    break;
                case "PT":
                    if (m_matchMemberAndAction.Active)
                    {
                        AddScoreByCompos(m_matchMemberAndAction.ComPos, GVAR.Score_Try);
                    }
                    else
                    {
                        PopUpWindow(MyPopUpWindowType.OnBench);
                        InitialMemberAndActioin();
                        return;
                    }
                    break;
                case "CG":
                    if (m_matchMemberAndAction.Active)
                    {
                        AddScoreByCompos(m_matchMemberAndAction.ComPos, GVAR.Score_ConversionGoal);
                    }
                    else
                    {
                        PopUpWindow(MyPopUpWindowType.OnBench);
                        InitialMemberAndActioin();
                        return;
                    }
                    break;
                case "CM":
                    if (!m_matchMemberAndAction.Active)
                    {
                        PopUpWindow(MyPopUpWindowType.OnBench);
                        InitialMemberAndActioin();
                        return;
                    }
                    break;
                case "PG":
                    if (m_matchMemberAndAction.Active)
                    {

                        AddScoreByCompos(m_matchMemberAndAction.ComPos, GVAR.Score_PenaltyGoal);
                    }
                    else
                    {
                        PopUpWindow(MyPopUpWindowType.OnBench);
                        InitialMemberAndActioin();
                        return;
                    }
                    break;
                case "PM":
                    if (!m_matchMemberAndAction.Active)
                    {
                        PopUpWindow(MyPopUpWindowType.OnBench);
                        InitialMemberAndActioin();
                        return;
                    }
                    break;
                case "DG":
                    if (m_matchMemberAndAction.Active)
                    {
                        AddScoreByCompos(m_matchMemberAndAction.ComPos, GVAR.Score_DropGoal);
                    }
                    else
                    {
                        PopUpWindow(MyPopUpWindowType.OnBench);
                        InitialMemberAndActioin();
                        return;
                    }
                    break;
                case "DM":
                    if (!m_matchMemberAndAction.Active)
                    {
                        PopUpWindow(MyPopUpWindowType.OnBench);
                        InitialMemberAndActioin();
                        return;
                    }
                    break;
                case "Out":
                    if (m_matchMemberAndAction.Active)
                    {
                        GVAR.g_ManageDB.UpdateActiveInMember(m_curMatchID, m_matchMemberAndAction.ComPos, m_matchMemberAndAction.RegisterID, 0);
                    }
                    else
                    {
                        PopUpWindow(MyPopUpWindowType.OnBench);
                        InitialMemberAndActioin();
                        return;
                    }
                    break;
                case "YCard":
                    break;
                case "2YCard":
                    break;
                case "RCard":
                    if (m_matchMemberAndAction.Active)
                    {
                        GVAR.g_ManageDB.UpdateActiveInMember(m_curMatchID, m_matchMemberAndAction.ComPos, m_matchMemberAndAction.RegisterID, 0);
                    }
                    break;
                default:
                    break;
            }
            #endregion

            MatchAction matchAction = new MatchAction
            {
                MatchID = m_curMatchID,
                MatchSplitID = GVAR.g_period,
                RegisterID = m_matchMemberAndAction.RegisterID,
                ComPos = m_matchMemberAndAction.ComPos,
                MatchTime = GetActionTime(true),
                ScoreHome = m_homeTeamScore.ScoreTotal,
                ScoreAway = m_awayTeamScore.ScoreTotal,
                ActionTypeCode = m_selectedActionCode
            };

            GVAR.g_ManageDB.AddMatchAction(matchAction);

            txtLastName.Text = m_selectedPlayerName;
            txtLastAction.Text = m_selectedActionName;

            InitialAwayMemnberDataGrid(m_curMatchID);
            InitialHomeMemnberDataGrid(m_curMatchID);
            InitialActionDataGrid(m_curMatchID);

            InitialMemberAndActioin();
        }

        private static void PopUpWindow(MyPopUpWindowType messageType)
        {
            MyPopUpWindow myPopupwindow = new MyPopUpWindow(messageType);
            int LocationX = System.Windows.Forms.Screen.PrimaryScreen.WorkingArea.Width - myPopupwindow.Width;
            int LocationY = System.Windows.Forms.Screen.PrimaryScreen.WorkingArea.Height - myPopupwindow.Height;
            System.Drawing.Point p = new System.Drawing.Point(LocationX, LocationY);
            myPopupwindow.PointToScreen(p);
            myPopupwindow.Location = p;
            myPopupwindow.Show();
            System.Threading.Thread.Sleep(200);
            myPopupwindow.Close();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="b">
        /// true 正计时 faLse 倒计时
        /// </param>
        /// <returns></returns>
        private string GetActionTime(bool b)
        {
            if (b)
                return m_timeSpanCurrent.ToString(@"hh\:mm\:ss");

            TimeSpan tsTotal;
            if (GVAR.g_period == 1)
            {
                tsTotal = TimeSpan.FromMinutes(GVAR.g_firstHalfTime);
            }
            else if (GVAR.g_period == 2)
            {
                tsTotal = TimeSpan.FromMinutes(GVAR.g_secondHalfTime);
            }
            else if (GVAR.g_period == 3)
            {
                tsTotal = TimeSpan.FromMinutes(GVAR.g_extraTime);
            }
            else
            {
                tsTotal = TimeSpan.FromMinutes(GVAR.g_firstHalfTime);
            }

            return TimeSpan.FromSeconds((tsTotal.TotalSeconds - GVAR.Str2Int(m_timeSpanCurrent.TotalSeconds - 0.5))).ToString(@"hh\:mm\:ss");
        }

        public void AddScoreByCompos(int compos, int score)
        {
            if (compos == 1)
                SetHomeScore(score);
            else if (compos == 2)
                SetAwayScore(score);
        }

        private void MenuItem_Click(object sender, RoutedEventArgs e)
        {
            MenuItem menuItem = sender as MenuItem;
            if (grdAction.SelectedIndex < 0)
                return;

            MatchAction ma = grdAction.SelectedItem as MatchAction;

            if (menuItem.Tag.ToString() == "update")
            {
                UpdateMatchAction updateMatchAction = new UpdateMatchAction(ma.ActionNumberID);
                updateMatchAction.ShowDialog();
            }
            else if (menuItem.Tag.ToString() == "del")
            {
                if (System.Windows.Forms.DialogResult.OK == GVAR.MsgBox("Are you confirm to delete the current  action? ",
                                "Warning", System.Windows.Forms.MessageBoxButtons.OKCancel, System.Windows.Forms.MessageBoxIcon.Warning))
                {
                    GVAR.g_ManageDB.DeleteMatchAction(ma.ActionNumberID);
                }
            }

            InitialActionDataGrid(m_curMatchID);
        }

        #endregion

        #region Add Officials

        private void btnAddOfficials_Click(object sender, RoutedEventArgs e)
        {
            int iMatchID = GVAR.Str2Int(m_curMatchID);
            frmOVRWPOfficialEntry OfficialForm = new frmOVRWPOfficialEntry(iMatchID);
            OfficialForm.ShowDialog();
        }

        #endregion

        #region SplitStatus Button Event

        private void MenuItem_Click_1_Available(object sender, RoutedEventArgs e)
        {
            StatusMenuEvent(1,MatchStatus.Available);
        }
        private void MenuItem_Click_1_Running(object sender, RoutedEventArgs e)
        {
            StatusMenuEvent(1, MatchStatus.Running);
        }
        private void MenuItem_Click_1_Official(object sender, RoutedEventArgs e)
        {
            StatusMenuEvent(1, MatchStatus.Official);
        }

        private void MenuItem_Click_2_Available(object sender, RoutedEventArgs e)
        {
            StatusMenuEvent(2, MatchStatus.Available);
        }
        private void MenuItem_Click_2_Running(object sender, RoutedEventArgs e)
        {
            StatusMenuEvent(2, MatchStatus.Running);
        }
        private void MenuItem_Click_2_Official(object sender, RoutedEventArgs e)
        {
            StatusMenuEvent(2, MatchStatus.Official);
        }

        private void MenuItem_Click_3_Available(object sender, RoutedEventArgs e)
        {
            StatusMenuEvent(3, MatchStatus.Available);
        }
        private void MenuItem_Click_3_Running(object sender, RoutedEventArgs e)
        {
            StatusMenuEvent(3, MatchStatus.Running);
        }
        private void MenuItem_Click_3_Official(object sender, RoutedEventArgs e)
        {
            StatusMenuEvent(3, MatchStatus.Official);
        }

        private void StatusMenuEvent(int iMatchSplitID, MatchStatus matchStatus)
        {
            GVAR.g_ManageDB.UpdateSplitStatusID(m_curMatchID, iMatchSplitID, (int)matchStatus);
            SetSplitStatusButtonContent(iMatchSplitID, (int)matchStatus);
        }

        private void SetSplitStatusButtonContent(int matchSplitID, int splitStatusID)
        {
            if (matchSplitID == 1)
            {
                m_MatchStatus_Split1 = splitStatusID;

                if (splitStatusID == (int)MatchStatus.Available)
                {
                    Split1.Content = "AB";
                }
                else if (splitStatusID == (int)MatchStatus.Running)
                {
                    Split1.Content = "RU";
                }
                else if (splitStatusID == (int)MatchStatus.Official)
                {
                    Split1.Content = "OF";
                }
            }
            else if (matchSplitID == 2)
            {
                m_MatchStatus_Split2 = splitStatusID;

                if (splitStatusID == (int)MatchStatus.Available)
                {
                    Split2.Content = "AB";
                }
                else if (splitStatusID == (int)MatchStatus.Running)
                {
                    Split2.Content = "RU";
                }
                else if (splitStatusID == (int)MatchStatus.Official)
                {
                    Split2.Content = "OF";
                }
            }
            else if (matchSplitID == 3)
            {
                m_MatchStatus_Split3 = splitStatusID;

                if (splitStatusID == (int)MatchStatus.Available)
                {
                    Split3.Content = "AB";
                }
                else if (splitStatusID == (int)MatchStatus.Running)
                {
                    Split3.Content = "RU";
                }
                else if (splitStatusID == (int)MatchStatus.Official)
                {
                    Split3.Content = "OF";
                }
            }

        }

        #endregion

    }

    public class StatusChangedResult
    {
        public StatusChangedResult(bool bAllowChange, bool bNotify = false, string strReason = "")
        {
            AllowChange = bAllowChange;
            NotifyUser = bNotify;
            Reason = strReason;
        }

        public bool AllowChange; //是否改变状态
        public bool NotifyUser;//是否将原因通知给用户
        public string Reason; //状态改变的原因
    }

}
