using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using DevComponents.DotNetBar.Controls;
using AutoSports.OVRCommon;
using System.IO;
using System.IO.Ports;
using System.Threading;
using System.Xml;

namespace AutoSports.OVRBKPlugin
{
    public enum EOperatetype
    {
        emUnKnow = -1,   //未知
        emPoint = 0,     //只加分
        emStat = 1,      //只技术统计
        emMixed = 2,     //技术统计改比分
    }

    public partial class frmOVRBKDataEntry : DevComponents.DotNetBar.Office2007Form
    {
        private string m_strSectionName;
        private EOperatetype m_emOperateType;

        public List<SPlayerInfo> m_lstHomeActive = new List<SPlayerInfo>();
        public List<SPlayerInfo> m_lstVisitActive = new List<SPlayerInfo>();
        public OVRBKMatchInfo m_CCurMatch = new OVRBKMatchInfo();

        public List<OVRBKActionInfo> m_lstAction = new List<OVRBKActionInfo>();
        public OVRBKActionInfo m_CCurAction = new OVRBKActionInfo();

        public frmOVRBKDataEntry()
        {
            InitializeComponent();

            m_CCurMatch.Init();

            m_emOperateType = EOperatetype.emMixed;

            m_strSectionName = "OVRBKPlugin";
        }

        private void frmOVRBKDataEntry_Load(object sender, EventArgs e)
        {
            Localization();
            InitUI();

            EnableMatchBtn(false);
            EnalbeMatchCtrl(false);
            EnableScoreBtn(false);
            EnableSetPointsTextBox();

            InitStatusBtn();
            InitOperateType();
        }

        private void Localization()
        {
            this.lbHome.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbHome");
            this.lbVisit.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbVisit");
            this.lbSet1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSet1");
            this.lbSet2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSet2");
            this.lbSet3.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSet3");
            this.lbSet4.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSet4");

            this.btnStartPeriod.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStartPeriod");
            this.btnEndPeriod.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnEndPeriod");

            this.btnOfficial.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnOfficial");
            this.btnTeamInfo.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnTeamInfo");
            this.btnImportStat.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnImportStat");
            this.btnExit.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnExit");
            this.btnMatchResult.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnMatchResult");
            this.btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStart");

            this.btnx_Schedule.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_Schedule");
            this.btnx_StartList.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_StartList");
            this.btnx_Running.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_Running");
            this.btnx_Suspend.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_Suspend");
            this.btnx_Unofficial.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_Unofficial");
            this.btnx_Finished.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_Finished");
            this.btnx_Revision.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_Revision");
            this.btnx_Canceled.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_Canceled");

            this.btnx_Score.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_Score");
            this.btnx_Statistic.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_Statistic");
            this.btnx_Result.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_Result");

            this.gbMatchScore.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbMatchScore");
            this.gbMatchStatistic.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbMatchStatistic");
            this.gbHome.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbHome");
            this.gbVisit.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbVisit");

            this.btnX_2PointsMade.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_2PointsMade");
            this.btnX_2PointsMissed.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_2PointsMissed");
            this.btnX_3PointsMade.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_3PointsMade");
            this.btnX_3PointsMissed.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_3PointsMissed");
            this.btnX_FreeThrowMade.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_FreeThrowMade");
            this.btnX_FreeThrowMissed.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_FreeThrowMissed");
            this.btnX_OffensiveRebound.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_OffensiveRebound");
            this.btnX_DefensiveRebound.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_DefensiveRebound");
            this.btnX_Assist.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_Assist");
            this.btnX_Turnover.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_Turnover");
            this.btnX_Steal.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_Steal");
            this.btnX_BlockedShot.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_BlockedShot");
            this.btnX_OffensiveFoul.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_OffensiveFoul");
            this.btnX_DefensiveFoul.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnx_DefensiveFoul");
        }

        public void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            switch (e.Type)
            {
                case OVRMgr2PluginEventType.emMatchSelected:
                    {
                        if (e.Args != null)
                            OnMatchSelected(e.Args.ToString());
                        break;
                    }
                case OVRMgr2PluginEventType.emRptContextQuery:
                    {
                        OnQueryReportContext(e.Args as OVRReportContextQueryArgs);
                        break;
                    }
            }
        }

        private void OnMatchSelected(string strMatchID)
        {
            if (GVAR.g_BKPlugin == null)
                return;

            if (m_CCurMatch.MatchID != null)
            {
                if (m_CCurMatch.MatchID.Length != 0)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "mbExit"));
                    return;
                }
            }

            if (strMatchID == m_CCurMatch.MatchID) return;

            GVAR.g_ManageDB.GetActiveSportInfo();

            m_CCurMatch.MatchID = strMatchID.ToString();

            // Update Report Context
            GVAR.g_BKPlugin.SetReportContext("MatchID", strMatchID);

            // Load Match Data
            GVAR.g_ManageDB.GetMatchInfo(strMatchID, ref m_CCurMatch);

            //////////////////////////////////////////
            //判断当前比赛类型：正常比赛，点球赛
            if (m_CCurMatch.MatchStatus == GVAR.STATUS_SCHEDULE)
            {
                if (m_CCurMatch.MatchType == GVAR.MATCH_COMMON)
                {
                    m_CCurMatch.Period = GVAR.PERIOD_1ST;
                    GVAR.g_ManageDB.InitMatchSplit(ref m_CCurMatch, 4);
                    GVAR.g_ManageDB.UpdateMatchPeriod(ref m_CCurMatch);

                    //初始化时间
                    m_CCurMatch.InitTime();
                }

                m_CCurMatch.m_CHomeTeam.TeamPoint = 0;
                m_CCurMatch.m_CVisitTeam.TeamPoint = 0;
                GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);

                GVAR.g_ManageDB.UpdateMatchResult(Convert.ToInt32(m_CCurMatch.MatchID), 1, -1);
                GVAR.g_ManageDB.UpdateMatchResult(Convert.ToInt32(m_CCurMatch.MatchID), 2, -1);
                GVAR.g_ManageDB.UpdateMatchIRM(Convert.ToInt32(m_CCurMatch.MatchID), 1, -1);
                GVAR.g_ManageDB.UpdateMatchIRM(Convert.ToInt32(m_CCurMatch.MatchID), 2, -1);
                if (m_CCurMatch.m_CHomeTeam.TeamID.ToString().Length == 0 || m_CCurMatch.m_CVisitTeam.TeamID.ToString().Length == 0)
                {

                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "Msg_Register"));
                    m_CCurMatch.Init();
                    return;
                }
            }

            if (m_CCurMatch.MatchStatus > GVAR.STATUS_SCHEDULE)
            {
                GVAR.g_ManageDB.GetTeamDetailInfo(strMatchID, ref m_CCurMatch.m_CHomeTeam);
                GVAR.g_ManageDB.GetTeamDetailInfo(strMatchID, ref m_CCurMatch.m_CVisitTeam);
            }

            EnableMatchBtn(true);
            UpdateMatchStatus();
            InitMatchInfo();
            UpdateMatchStatus();
            EnableSetPointsTextBox();
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);
            GVAR.g_ManageDB.GetMatchActionList(iMatchID, iSplitID, ref m_lstAction);
            UpdateActionList(ref m_lstAction, -1);
        }

        private void OnQueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;

            switch (args.Name)
            {
                case "MatchID":
                    {
                        if (m_CCurMatch.MatchID == null || m_CCurMatch.MatchID.Length == 0)
                            return;

                        if (GVAR.Str2Int(m_CCurMatch.MatchID) > 0)
                        {
                            args.Value = m_CCurMatch.MatchID;
                            args.Handled = true;
                        }
                        break;
                    }
            }
        }

        private void btnOfficial_Click(object sender, EventArgs e)
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            frmOVRBKOfficialEntry OfficialForm = new frmOVRBKOfficialEntry(iMatchID);
            OfficialForm.ShowDialog();

            GVAR.g_BKPlugin.DataChangedNotify(OVRDataChangedType.emMatchOfficials, -1, -1, -1, iMatchID, iMatchID, null);
        }

        private void btnTeamInfo_Click(object sender, EventArgs e)
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iHomeRegID = m_CCurMatch.m_CHomeTeam.TeamID;
            int iVisitRegID = m_CCurMatch.m_CVisitTeam.TeamID;
            string strHomeName = m_CCurMatch.m_CHomeTeam.TeamName;
            string strVisitName = m_CCurMatch.m_CVisitTeam.TeamName;

            frmOVRBKTeamMemberEntry MatchMemberForm = new frmOVRBKTeamMemberEntry(iMatchID, iHomeRegID, iVisitRegID, strHomeName, strVisitName);
            MatchMemberForm.ShowDialog();

            if (m_CCurMatch.MatchStatus <= GVAR.STATUS_ON_COURT)
            {
                GVAR.g_ManageDB.InitActiveMember(m_CCurMatch.MatchID, 1, m_CCurMatch.MatchTime);
                GVAR.g_ManageDB.InitActiveMember(m_CCurMatch.MatchID, 2, m_CCurMatch.MatchTime);
            }
            ResetPlayerList(1, ref dgvHomeList);
            ResetPlayerList(2, ref dgvVisitList);

            InitPlayerAcitve(1, ref m_lstHomeActive);
            InitPlayerAcitve(2, ref m_lstVisitActive);

            GVAR.g_BKPlugin.DataChangedNotify(OVRDataChangedType.emMatchCompetitorMember, -1, -1, -1, iMatchID, iMatchID, null);
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            if (m_CCurMatch.MatchID == null || m_CCurMatch.MatchID.Length == 0)
            {
                return;
            }

            if (DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "mbExitMatch"), "", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                if (m_CCurMatch.bRunTime)
                {
                    m_CCurMatch.bRunTime = false;
                    btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStart");
                    timer1.Enabled = false;
                }
                EnableMatchBtn(false);
                EnalbeMatchCtrl(false);
                EnableScoreBtn(false);

                GVAR.g_ManageDB.UpdateMatchTime(m_CCurMatch.MatchID, m_CCurMatch.MatchTime);

                m_CCurMatch.Init();
                m_lstHomeActive.Clear();
                m_lstVisitActive.Clear();

                InitMatchInfo();
                InitStatusBtn();

                m_lstAction.Clear();
                UpdateActionList(ref m_lstAction, -1);
           }
        }

        private void btnx_OperateType_Click(object sender, EventArgs e)
        {
            if (sender == btnx_Score)
            {
                m_emOperateType = EOperatetype.emPoint;
            }
            else if (sender == btnx_Statistic)
            {
                m_emOperateType = EOperatetype.emStat;
            }
            else if (sender == btnx_Result)
            {
                m_emOperateType = EOperatetype.emMixed;
            }

            InitOperateType();
        }

        private void btnx_Status_Click(object sender, EventArgs e)
        {
            if (sender == btnx_StartList)
            {
                m_CCurMatch.MatchStatus = GVAR.STATUS_ON_COURT;
            }
            else if (sender == btnx_Running)
            {
                m_CCurMatch.MatchStatus = GVAR.STATUS_RUNNING;
            }
            else if (sender == btnx_Suspend)
            {
                m_CCurMatch.MatchStatus = GVAR.STATUS_SUSPEND;
            }
            else if (sender == btnx_Unofficial)
            {
                m_CCurMatch.MatchStatus = GVAR.STATUS_UNOFFICIAL;
            }
            else if (sender == btnx_Finished)
            {
                m_CCurMatch.MatchStatus = GVAR.STATUS_FINISHED;
            }
            else if (sender == btnx_Revision)
            {
                m_CCurMatch.MatchStatus = GVAR.STATUS_REVISION;
            }
            else if (sender == btnx_Canceled)
            {
                m_CCurMatch.MatchStatus = GVAR.STATUS_CANCELED;
            }

            int iResult = OVRDataBaseUtils.ChangeMatchStatus(GVAR.Str2Int(m_CCurMatch.MatchID), m_CCurMatch.MatchStatus, GVAR.g_sqlConn, GVAR.g_BKPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btn_ScoreAdd(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period == 0)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "Msg_period"));
                return;
            }

            int iResult = 0;
            if (sender == btnHPt_Add)
            {
                iResult = m_CCurMatch.ChangePoint(1, true, 1);
            }
            else if (sender == btnVPt_Add)
            {
                iResult = m_CCurMatch.ChangePoint(2, true, 1);
            }
            else if (sender == btnHPt_Sub)
            {
                iResult = m_CCurMatch.ChangePoint(1, false, 1);
            }
            else if (sender == btnVPt_Sub)
            {
                iResult = m_CCurMatch.ChangePoint(2, false, 1);
            }

            if (iResult == 1)
            {
                GVAR.g_ManageDB.UpdateTeamSetPt(m_CCurMatch.Period, ref m_CCurMatch);
                GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);
            }

            UpdateUIForTeamScore();
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iEventID = GVAR.g_ManageDB.GetEventID(m_CCurMatch.MatchID);
            GVAR.g_BKPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, iEventID, -1, iMatchID, iMatchID, null);
        }

        private void lbPeriod_TextChanged(object sender, EventArgs e)
        {
            lbSet1.ForeColor = System.Drawing.Color.Black;
            lbSet2.ForeColor = System.Drawing.Color.Black;
            lbSet3.ForeColor = System.Drawing.Color.Black;
            lbSet4.ForeColor = System.Drawing.Color.Black;
            lbExa1.ForeColor = System.Drawing.Color.Black;
            lbExa2.ForeColor = System.Drawing.Color.Black;
            lbExa3.ForeColor = System.Drawing.Color.Black;
            lbExa4.ForeColor = System.Drawing.Color.Black;
            switch (m_CCurMatch.Period)
            {
                case GVAR.PERIOD_1ST:
                    lbSet1.ForeColor = System.Drawing.Color.Red;
                    break;
                case GVAR.PERIOD_2ND:
                    lbSet2.ForeColor = System.Drawing.Color.Red;
                    break;
                case GVAR.PERIOD_3RD:
                    lbSet3.ForeColor = System.Drawing.Color.Red;
                    break;
                case GVAR.PERIOD_4TH:
                    lbSet4.ForeColor = System.Drawing.Color.Red;
                    break;
                case GVAR.PERIOD_EXTRA1:
                    lbExa1.ForeColor = System.Drawing.Color.Red;
                    break;
                case GVAR.PERIOD_EXTRA2:
                    lbExa2.ForeColor = System.Drawing.Color.Red;
                    break;
                case GVAR.PERIOD_EXTRA3:
                    lbExa3.ForeColor = System.Drawing.Color.Red;
                    break;
                case GVAR.PERIOD_EXTRA4:
                    lbExa4.ForeColor = System.Drawing.Color.Red;
                    break;
                default:
                    break;
            }
        }
        private void btnEndPeriod_Click(object sender, EventArgs e)
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);
            GVAR.g_ManageDB.UpdateMatchSplitStatus(iMatchID, iMatchSplitID, GVAR.STATUS_FINISHED);
            btnEndPeriod.Enabled = false;
            btnStartPeriod.Enabled = false;
            UpdateNextBtnEnabled();
            if (m_CCurMatch.bRunTime)
            {
                m_CCurMatch.bRunTime = false;
                timer1.Enabled = false;
                btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStart");
            }
            m_CCurMatch.MatchTime = "0";
            MatchTime.Text = GVAR.TranslateINT32toTime(0);

            GVAR.g_BKPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, iMatchID, iMatchID, null);
        }

        private void btnStartPeriod_Click(object sender, EventArgs e)
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);
            GVAR.g_ManageDB.UpdateMatchSplitStatus(iMatchID, iMatchSplitID, GVAR.STATUS_RUNNING);
            btnEndPeriod.Enabled = true;
            btnStartPeriod.Enabled = false;

            if (m_CCurMatch.m_CHomeTeam.GetScore(m_CCurMatch.Period).Length == 0)
            {
                m_CCurMatch.m_CHomeTeam.SetScore("0", m_CCurMatch.Period);
            }
            if (m_CCurMatch.m_CVisitTeam.GetScore(m_CCurMatch.Period).Length == 0)
            {
                m_CCurMatch.m_CVisitTeam.SetScore("0", m_CCurMatch.Period);
            }
            GVAR.g_ManageDB.UpdateTeamSetPt(m_CCurMatch.Period, ref m_CCurMatch);
            UpdateUIForTeamScore();


            GVAR.g_BKPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, iMatchID, iMatchID, null);
        }
        private void btnNext_Click(object sender, EventArgs e)
        {
            OnBtnChangePeriod(true);
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);
            GVAR.g_ManageDB.GetMatchActionList(iMatchID, iSplitID, ref m_lstAction);
            UpdateActionList(ref m_lstAction, -1);
        }

        private void btnPrevious_Click(object sender, EventArgs e)
        {
            OnBtnChangePeriod(false);
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);
            GVAR.g_ManageDB.GetMatchActionList(iMatchID, iSplitID, ref m_lstAction);
            UpdateActionList(ref m_lstAction, -1);
        }
        private int GetSetScore(bool iHomeTeam, int iSet)
        {//iSet = 1,2,3,4,5;
            string strSetScore = string.Empty;
            if (iHomeTeam)
            {
                strSetScore= m_CCurMatch.m_CHomeTeam.GetScore(iSet);
            }
            else
            {
                strSetScore = m_CCurMatch.m_CVisitTeam.GetScore(iSet);
            }
            if (strSetScore.Trim().Length == 0)
            {
                strSetScore = "0";
            }
            return int.Parse(strSetScore);
        }
        private int SumPeriodsGoals(bool iHomeTeam,int iSetCount)
        {
            int iSum = 0;
            int i =GVAR.PERIOD_1ST;
            while(i<=iSetCount)
            {
                iSum+=GetSetScore(iHomeTeam,i);
                i++;
            };
            return iSum;
        }
        private void UpdatePreviousBtnEnabled()
        {
            if (m_CCurMatch.Period == GVAR.PERIOD_1ST)
            {
                btnPrevious.Enabled = false;
            }
            else
            {
                btnPrevious.Enabled = true;
            }
        }
        private void UpdateNextBtnEnabled()
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);
            int iSplitStatus = GVAR.g_ManageDB.GetSplitStatusID(iMatchID, iMatchSplitID);
            if (iSplitStatus == GVAR.STATUS_FINISHED)
            {
                if (m_CCurMatch.Period == GVAR.PERIOD_EXTRA4)
                {
                    btnNext.Enabled = false;
                    return;
                }
                btnNext.Enabled = true;
            }
            else
            {
                btnNext.Enabled = false;
            }
        }
        private void UpdatePeriodBtnEnabled()
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);
            int iSplitStatus = GVAR.g_ManageDB.GetSplitStatusID(iMatchID, iMatchSplitID);
            if (iSplitStatus == GVAR.STATUS_RUNNING)
            {
                btnStartPeriod.Enabled = false;
                btnEndPeriod.Enabled = true;
            }
            else if (iSplitStatus == GVAR.STATUS_FINISHED)
            {
                btnStartPeriod.Enabled = false;
                btnEndPeriod.Enabled = false;
            }
            else
            {
                btnStartPeriod.Enabled = true;
                btnEndPeriod.Enabled = false;
            }
        }
        private void OnBtnChangePeriod(bool bAdd)
        {
            m_CCurMatch.ChangePeriod(bAdd);
            UpdatePreviousBtnEnabled();
            UpdateNextBtnEnabled();
            UpdatePeriodBtnEnabled();

            ChangePeriod();
            UpdateUIForTeamScore();
            if (m_CCurMatch.bRunTime)
            {
                m_CCurMatch.bRunTime = false;
                btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStart");
                timer1.Enabled = false;
            }
            m_CCurMatch.InitTime();
            int iMatchTime = m_CCurMatch.MatchTime.Trim().Length == 0 ? 0 : int.Parse(m_CCurMatch.MatchTime.Trim());
            MatchTime.Text = GVAR.TranslateINT32toTime(iMatchTime);

            EnableSetPointsTextBox();
        }

        #region Code  for MatchTime
        private void btnStart_Click(object sender, EventArgs e)
        {
            if (!m_CCurMatch.bRunTime)
            {
                m_CCurMatch.bRunTime = true;
                btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStop");

                timer1.Enabled = true;//是否执行System.Timers.Timer.Elapsed事件； 

                if (m_CCurMatch.MatchTime.Length == 0)
                {
                    m_CCurMatch.InitTime();
                }
            }
            else
            {
                m_CCurMatch.bRunTime = false;
                btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStart");

                timer1.Enabled = false;
            }
        }

        private void UpdateMatchTime(object sender, EventArgs e)
        {
            int iTime = GVAR.Str2Int(m_CCurMatch.MatchTime);
            iTime = Math.Max(0, iTime - 1);
            m_CCurMatch.MatchTime = iTime.ToString();

            if (iTime == 0)
            {
                timer1.Enabled = false;
                btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStart");
                m_CCurMatch.bRunTime = false;
            }

            MatchTime.Text = GVAR.TranslateINT32toTime(iTime);
        }

        #endregion

        private void dgvHomeList_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            SetPlayerActive(e, ref dgvHomeList, ref m_lstHomeActive, 1);
        }

        private void dgvVisitList_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            SetPlayerActive(e, ref dgvVisitList, ref m_lstVisitActive, 2);
        }

        #region DML For Add Action

        /// <summary>
        /// 人员选择
        /// </summary>
        private void btnHActive_Click(object sender, EventArgs e)
        {
            btnActiveClick(sender, 1, m_lstHomeActive);
        }

        private void btnVActive_Click(object sender, EventArgs e)
        {
            btnActiveClick(sender, 2, m_lstVisitActive);
        }

        private void btnActiveClick(object sender, int iTeampos, List<SPlayerInfo> lstPlayer)
        {
            int iEventID = GVAR.g_ManageDB.GetEventID(m_CCurMatch.MatchID);
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);

            //当动作的运动员为空时，取消该动作，重新开始            ButtonX btn = (ButtonX)sender;
            int iShirtNumber = GVAR.Str2Int(btn.Text);
            if (iShirtNumber == 0)
            {
                m_CCurAction.Init();
                return;
            }

            int iPlayerIndex = GetPlayerIndexByShirtNo(lstPlayer, iShirtNumber);
            SPlayerInfo tmpPlayer = new SPlayerInfo();
            if (iPlayerIndex == -1)
            {
                m_CCurAction.Init();
                return;
            }
            tmpPlayer = lstPlayer.ElementAt(iPlayerIndex);

            if (m_CCurAction.IsNewAction())
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);

            }
            m_CCurAction.TeamPos = iTeampos;
            if (iTeampos == 1)
            {
                m_CCurAction.TeamID = m_CCurMatch.m_CHomeTeam.TeamID;
                m_CCurAction.TeamName = m_CCurMatch.m_CHomeTeam.TeamName;
            }
            else if (iTeampos == 2)
            {
                m_CCurAction.TeamID = m_CCurMatch.m_CVisitTeam.TeamID;
                m_CCurAction.TeamName = m_CCurMatch.m_CVisitTeam.TeamName;
            }
            m_CCurAction.ActionTime = GVAR.FormatTime(m_CCurMatch.MatchTime);
            m_CCurAction.RegisterID = tmpPlayer.iRegisterID;
            m_CCurAction.ShirtNo = iShirtNumber;
            m_CCurAction.PlayerName = tmpPlayer.strRegisterName;

            UpdateUIActionInfo();
            if (m_CCurAction.IsActionComplete())
            {
                ActionDriveToAddPoints(iEventID, iMatchID);
                AddAction();
                GVAR.g_ManageDB.GetMatchActionList(iMatchID, iSplitID, ref m_lstAction);
                UpdateActionList(ref m_lstAction, -1);
                m_CCurAction.Init();
                UpdateUIActionInfo();
            }
        }
       #endregion
 
        private void btnMatchResult_Click(object sender, EventArgs e)
        {
            frmMatchResultEntry MatchResultEntry = new frmMatchResultEntry(GVAR.Str2Int(m_CCurMatch.MatchID));
            MatchResultEntry.ShowDialog();
        }

        private void textBoxX_Possession_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == 8 || Char.IsDigit(e.KeyChar) || e.KeyChar == 13)
            {
                if (e.KeyChar == 13)
                {
                    btnStatus.Focus();
                    e.Handled = true;
                }
            }
            else
            {
                e.Handled = true;
            }
        }
       
        private void textBoxX_FocusLeave(object sender, EventArgs e)
        {
        }
        private String CheckInput(String str)
        {
            if (str.Trim().Length == 0)
                return "0";
            int nResult = 0;
            if (int.TryParse(str, out nResult))
            {
                return nResult.ToString();
            }
            else
            {
                return "0";
            }
        }
        private String CheckInputTime(String strTime)
        {
            strTime = strTime.Trim();
            if (strTime.Length == 0)
            {
                return "0:00";
            }

            int nSec = 0;
            string[] split = strTime.Split(':');
            int iSplitCount = split.Length;
            if (iSplitCount == 1)
            {
                String strNumber = System.Text.RegularExpressions.Regex.Replace(split[0], @"[^\d]*", "");
                nSec = Convert.ToInt32(strNumber) * 60;
            }
            else
            {
                for (int i = 0; i < split.Length; i++)
                {
                    split[i] = split[i].Trim();
                    String strNumber = System.Text.RegularExpressions.Regex.Replace(split[i], @"[^\d]*", "");

                    nSec = nSec * 60 + Convert.ToInt32(strNumber);
                }
            }
            return GVAR.TranslateINT32toTime(nSec);
        }
        private void tbTime_KeyPress(object sender, KeyPressEventArgs e)
        {
            TextBoxX tbTime = (TextBoxX)sender;
            if (e.KeyChar == 8 || Char.IsDigit(e.KeyChar) || e.KeyChar == 13)
            {
                if (e.KeyChar == 13)
                {
                    btnStatus.Focus();
                    e.Handled = true;
                    return;
                }
                if (tbTime.Text.Replace(":", "").Length >= 5 && e.KeyChar != 8)
                {
                    e.Handled = true;
                    return;
                }

                if (e.KeyChar == 8)
                {
                    String strText = tbTime.Text.Trim();
                    if (tbTime.SelectionStart == 0)
                    {
                        e.Handled = true;
                        return;
                    }
                    //000:00,00:00,0:00
                    if (strText.Length == 6)
                    {
                        if (tbTime.SelectionStart == 4)
                        {
                            tbTime.SelectionStart = 6;
                        }
                        else
                        {
                            int iafter = strText.Length - tbTime.SelectionStart;
                            strText = strText.Remove(tbTime.SelectionStart - 1, 1).Replace(":", "");
                            strText = strText.Insert(strText.Length - 2, ":");
                            tbTime.Text = strText;
                            tbTime.SelectionStart = strText.Length - iafter;
                        }
                        e.Handled = true;
                        return;
                    }
                    else if (strText.Length == 5)
                    {
                        if (tbTime.SelectionStart == 3)
                        {
                            tbTime.SelectionStart = 5;
                        }
                        else
                        {
                            int iafter = strText.Length - tbTime.SelectionStart;
                            strText = strText.Remove(tbTime.SelectionStart - 1, 1).Replace(":", "");
                            strText = strText.Insert(strText.Length - 2, ":");
                            tbTime.Text = strText;
                            tbTime.SelectionStart = strText.Length - iafter;
                        }
                        e.Handled = true;
                        return;
                    }
                    else if (strText.Length == 4)
                    {
                        if (tbTime.SelectionStart == 2)
                        {
                            tbTime.SelectionStart = 4;
                        }
                        else
                        {
                            int iafter = strText.Length - tbTime.SelectionStart;
                            strText = strText.Remove(tbTime.SelectionStart - 1, 1).Replace(":", "");
                            strText = strText.Insert(strText.Length - 2, ":");

                            if (strText.Length - iafter == 0)
                            {
                                strText = strText.Replace(":", "");
                                tbTime.Text = strText;
                                tbTime.SelectionStart = 0;
                            }
                            else
                            {
                                strText = strText.Replace(":", "");
                                tbTime.Text = strText;
                                tbTime.SelectionStart = strText.Length - iafter - 1;
                            }
                        }
                        e.Handled = true;
                        return;
                    }
                    return;
                }

                if (Char.IsDigit(e.KeyChar))
                {//00,0:00,00:00
                    String strText = tbTime.Text.Trim();
                    if (strText.Length == 2)
                    {
                        int iafter = strText.Length - tbTime.SelectionStart;
                        string strTemp = String.Empty + e.KeyChar;
                        if (tbTime.SelectionStart >= strText.Length)
                        {
                            strText = strText + e.KeyChar;
                        }
                        else
                        {
                            strText = strText.Insert(tbTime.SelectionStart, strTemp);
                        }
                        strText = strText.Insert(strText.Length - 2, ":");
                        tbTime.Text = strText;
                        tbTime.SelectionStart = strText.Length - iafter;

                        e.Handled = true;
                        return;
                    }
                    else if (strText.Length == 4)
                    {//0:00
                        int iafter = strText.Length - tbTime.SelectionStart;
                        string strTemp = String.Empty + e.KeyChar;
                        if (tbTime.SelectionStart >= strText.Length)
                        {
                            strText = strText + e.KeyChar;
                        }
                        else
                        {
                            strText = strText.Insert(tbTime.SelectionStart, strTemp);
                        }
                        strText = strText.Replace(":", "");
                        strText = strText.Insert(strText.Length - 2, ":");
                        tbTime.Text = strText;
                        tbTime.SelectionStart = strText.Length - iafter;
                        e.Handled = true;
                        return;
                    }
                    else if (strText.Length == 5)
                    {
                        int iafter = strText.Length - tbTime.SelectionStart;
                        string strTemp = String.Empty + e.KeyChar;
                        if (tbTime.SelectionStart >= strText.Length)
                        {
                            strText = strText + e.KeyChar;
                        }
                        else
                        {
                            strText = strText.Insert(tbTime.SelectionStart, strTemp);
                        }
                        strText = strText.Replace(":", "");
                        strText = strText.Insert(strText.Length - 2, ":");
                        tbTime.Text = strText;
                        tbTime.SelectionStart = strText.Length - iafter;
                        e.Handled = true;
                        return;
                    }
                }
            }
            else
            {
                e.Handled = true;
            }
        }

        private void tbTime_Leave(object sender, EventArgs e)
        {
            TextBoxX tb = (TextBoxX)sender;
            tb.Text = CheckInputTime(tb.Text);
        }

        private void MatchTime_Leave(object sender, EventArgs e)
        {
            MatchTime.Text = CheckInputTime(MatchTime.Text);
            m_CCurMatch.MatchTime = GVAR.TranslateTimetoINT32(MatchTime.Text).ToString();
            if (m_CCurMatch.bRunTime)
            {
                timer1.Enabled = true;
            }
        }

        private void MatchTime_Enter(object sender, EventArgs e)
        {
            if (m_CCurMatch.bRunTime)
            {
                timer1.Enabled = false;
            }
        }

        private delegate void delegate_SetTime(String strValue);
        private void SetTime(String strValue)
        {
            if (MatchTime.InvokeRequired)
            {
                this.Invoke(new delegate_SetTime(SetTime), strValue);
                return;
            }
            MatchTime.Text = strValue;
        }

        private void txtBox_HPt_Set1_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_1ST)
                 return;
 
            if (txtBox_HPt_Set1.Text == "")
                txtBox_HPt_Set1.Text = "0";

            int iSetPts = int.Parse(txtBox_HPt_Set1.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 1, iSetPts);

            Common_Set_TextChanged(iResult);
        }

        private void txtBox_HPt_Set2_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_2ND)
                return;

            if (txtBox_HPt_Set2.Text == "")
                txtBox_HPt_Set2.Text = "0";

            int iSetPts = int.Parse(txtBox_HPt_Set2.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 1, iSetPts);

            Common_Set_TextChanged(iResult);
        }

        private void txtBox_HPt_Set3_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_3RD)
                return;

            if (txtBox_HPt_Set3.Text == "")
                txtBox_HPt_Set3.Text = "0";

            int iSetPts = int.Parse(txtBox_HPt_Set3.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 1, iSetPts);

            Common_Set_TextChanged(iResult);
        }

        private void txtBox_HPt_Set4_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_4TH)
                return;

            if (txtBox_HPt_Set4.Text == "")
                txtBox_HPt_Set4.Text = "0";

            int iSetPts = int.Parse(txtBox_HPt_Set4.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 1, iSetPts);

            Common_Set_TextChanged(iResult);
        }

        private void txtBox_HPt_Exa1_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_EXTRA1)
                return;

            if (txtBox_HPt_Exa1.Text == "")
                txtBox_HPt_Exa1.Text = "0";

            int iSetPts = int.Parse(txtBox_HPt_Exa1.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 1, iSetPts);

            Common_Set_TextChanged(iResult);
        }
        private void txtBox_HPt_Exa2_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_EXTRA2)
                return;

            if (txtBox_HPt_Exa2.Text == "")
                txtBox_HPt_Exa2.Text = "0";

            int iSetPts = int.Parse(txtBox_HPt_Exa2.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 1, iSetPts);

            Common_Set_TextChanged(iResult);
        }
        private void txtBox_HPt_Exa3_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_EXTRA3)
                return;

            if (txtBox_HPt_Exa3.Text == "")
                txtBox_HPt_Exa3.Text = "0";

            int iSetPts = int.Parse(txtBox_HPt_Exa3.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 1, iSetPts);

            Common_Set_TextChanged(iResult);
        }
        private void txtBox_HPt_Exa4_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_EXTRA4)
                return;

            if (txtBox_HPt_Exa4.Text == "")
                txtBox_HPt_Exa4.Text = "0";

            int iSetPts = int.Parse(txtBox_HPt_Exa4.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 1, iSetPts);

            Common_Set_TextChanged(iResult);
        }

        private void txtBox_VPt_Set1_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_1ST)
                return;

            if (txtBox_VPt_Set1.Text == "")
                txtBox_VPt_Set1.Text = "0";

            int iSetPts = int.Parse(txtBox_VPt_Set1.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 2, iSetPts);

            Common_Set_TextChanged(iResult);
        }

        private void txtBox_VPt_Set2_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_2ND)
                return;

            if (txtBox_VPt_Set2.Text == "")
                txtBox_VPt_Set2.Text = "0";

            int iSetPts = int.Parse(txtBox_VPt_Set2.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 2, iSetPts);

            Common_Set_TextChanged(iResult);
        }
        private void txtBox_VPt_Set3_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_3RD)
                return;

            if (txtBox_VPt_Set3.Text == "")
                txtBox_VPt_Set3.Text = "0";

            int iSetPts = int.Parse(txtBox_VPt_Set3.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 2, iSetPts);

            Common_Set_TextChanged(iResult);
        }
        private void txtBox_VPt_Set4_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_4TH)
                return;

            if (txtBox_VPt_Set4.Text == "")
                txtBox_VPt_Set4.Text = "0";

            int iSetPts = int.Parse(txtBox_VPt_Set4.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 2, iSetPts);

            Common_Set_TextChanged(iResult);
        }

        private void txtBox_VPt_Exa1_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_EXTRA1)
                return;

            if (txtBox_VPt_Exa1.Text == "")
                txtBox_VPt_Exa1.Text = "0";

            int iSetPts = int.Parse(txtBox_VPt_Exa1.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 2, iSetPts);

            Common_Set_TextChanged(iResult);
        }
        private void txtBox_VPt_Exa2_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_EXTRA2)
                return;

            if (txtBox_VPt_Exa2.Text == "")
                txtBox_VPt_Exa2.Text = "0";

            int iSetPts = int.Parse(txtBox_VPt_Exa2.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 2, iSetPts);

            Common_Set_TextChanged(iResult);
        }
        private void txtBox_VPt_Exa3_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_EXTRA3)
                return;

            if (txtBox_VPt_Exa3.Text == "")
                txtBox_VPt_Exa3.Text = "0";

            int iSetPts = int.Parse(txtBox_VPt_Exa3.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 2, iSetPts);

            Common_Set_TextChanged(iResult);
        }
        private void txtBox_VPt_Exa4_TextChanged(object sender, EventArgs e)
        {
            if (m_CCurMatch.Period != GVAR.PERIOD_EXTRA4)
                return;

            if (txtBox_VPt_Exa4.Text == "")
                txtBox_VPt_Exa4.Text = "0";

            int iSetPts = int.Parse(txtBox_VPt_Exa4.Text);

            int iResult = m_CCurMatch.EditSetPoint(m_CCurMatch.Period, 2, iSetPts);

            Common_Set_TextChanged(iResult);
        }

        private void Common_Set_TextChanged(int iResult)
        {
            if (iResult == 1)
            {
                GVAR.g_ManageDB.UpdateTeamSetPt(m_CCurMatch.Period, ref m_CCurMatch);
                GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);
            }

            UpdateUIForTeamScore();
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iEventID = GVAR.g_ManageDB.GetEventID(m_CCurMatch.MatchID);
            GVAR.g_BKPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, iEventID, -1, iMatchID, iMatchID, null);
        }

        private void txtBox_HPt_Set_KeyPress(object sender, KeyPressEventArgs e)
        {
            if((e.KeyChar<48 || e.KeyChar>57) && (int)(e.KeyChar) != 8)
            {
                e.Handled = true;//true表示把这次按键给取消掉
            }
        }
        private void txtBox_VPt_Set_KeyPress(object sender, KeyPressEventArgs e)
        {
            if ((e.KeyChar < 48 || e.KeyChar > 57) && (int)(e.KeyChar) != 8)
            {
                e.Handled = true;//true表示把这次按键给取消掉
            }
        }

        private void btnX_Assists_Click(object sender, EventArgs e)
        {
            btnPlayerActionClick(sender, EActionType.emAssist);
        }

        private void btnX_2PointsMade_Click(object sender, EventArgs e)
        {
            btnPlayerActionClick(sender, EActionType.em2PointsMade);
        }

        private void btnX_2PointsMiss_Click(object sender, EventArgs e)
        {
            btnPlayerActionClick(sender, EActionType.em2PointsMissed);
        }

        private void btnX_3PointsMade_Click(object sender, EventArgs e)
        {
            btnPlayerActionClick(sender, EActionType.em3PointsMade);
        }

        private void btnX_3PointsMiss_Click(object sender, EventArgs e)
        {
            btnPlayerActionClick(sender, EActionType.em3PointsMissed);
        }

        private void btnX_OffensiveRebounds_Click(object sender, EventArgs e)
        {
            btnPlayerActionClick(sender, EActionType.emOffensiveRebound);
        }

        private void btnX_DefensiveRebound_Click(object sender, EventArgs e)
        {
            btnPlayerActionClick(sender, EActionType.emDefensiveRebound);
        }

        private void btnX_FreeThrowMade_Click(object sender, EventArgs e)
        {
            btnPlayerActionClick(sender, EActionType.emFreeThrowMade);
        }

        private void btnX_FreeThrowMiss_Click(object sender, EventArgs e)
        {
            btnPlayerActionClick(sender, EActionType.emFreeThrowMissed);
        }

        private void btnX_Steal_Click(object sender, EventArgs e)
        {
            btnPlayerActionClick(sender, EActionType.emSteal);
        }

        private void btnX_BlockedShot_Click(object sender, EventArgs e)
        {
            btnPlayerActionClick(sender, EActionType.emBlockedShot);
        }

        private void btnX_Turnover_Click(object sender, EventArgs e)
        {
            btnPlayerActionClick(sender, EActionType.emTurnover);
        }

        private void btnX_OffensiveFoul_Click(object sender, EventArgs e)
        {
            btnPlayerActionClick(sender, EActionType.emOffensiveFoul);
        }

        private void btnX_DefensiveFoul_Click(object sender, EventArgs e)
        {
            btnPlayerActionClick(sender, EActionType.emDefensiveFoul);
        }

        private void btnPlayerActionClick(object sender, EActionType emEActionType)
        {
            int iEventID = GVAR.g_ManageDB.GetEventID(m_CCurMatch.MatchID);
            int iMatchID = int.Parse(m_CCurMatch.MatchID);
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);

            ButtonX btn = (ButtonX)sender;

            if (m_CCurAction.IsNewAction())
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            m_CCurAction.ActionType = emEActionType;
            m_CCurAction.ActionTime = GVAR.FormatTime(m_CCurMatch.MatchTime);
            m_CCurAction.GetActionCode();
            m_CCurAction.ActionDes = btn.Text.ToString();

            UpdateUIActionInfo();

            if (m_CCurAction.IsActionComplete())
            {
                ActionDriveToAddPoints(iEventID, iMatchID);
                AddAction();
                GVAR.g_ManageDB.GetMatchActionList(iMatchID, iSplitID, ref m_lstAction);
                UpdateActionList(ref m_lstAction, -1);
                m_CCurAction.Init();
                UpdateUIActionInfo();
            }
        }

        private void ActionDriveToAddPoints(int iEventID, int iMatchID)
        {
            if (m_CCurAction.ActionType == EActionType.em2PointsMade
                || m_CCurAction.ActionType == EActionType.em3PointsMade
                || m_CCurAction.ActionType == EActionType.emFreeThrowMade)
            {
                int iResult = 0;
                switch (m_CCurAction.ActionType)
                {
                    case EActionType.em2PointsMade:
                        iResult = m_CCurMatch.ChangePoint(m_CCurAction.TeamPos, true, 2);
                        break;
                    case EActionType.em3PointsMade:
                        iResult = m_CCurMatch.ChangePoint(m_CCurAction.TeamPos, true, 3);
                        break;
                    case EActionType.emFreeThrowMade:
                        iResult = m_CCurMatch.ChangePoint(m_CCurAction.TeamPos, true, 1);
                        break;
                }
                if (iResult == 1)
                {
                    GVAR.g_ManageDB.UpdateTeamSetPt(m_CCurMatch.Period, ref m_CCurMatch);
                    GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);
                }

                UpdateUIForTeamScore();
                GVAR.g_BKPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, iEventID, -1, iMatchID, iMatchID, null);
            }
        }

        private void dgvAction_CellMouseDown(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.ColumnIndex == -1)
                this.dgvAction.ContextMenuStrip = MenuStrip_ActionList;
        }

        private void toolStripMenuItem_ActionList_Delete_Click(object sender, EventArgs e)
        {
            DataGridViewSelectedRowCollection l_Rows = this.dgvAction.SelectedRows;
            if (l_Rows.Count == 0)
                return;

            int[] arSelIndex = new int[l_Rows.Count];
            int i = 0;
            foreach (DataGridViewRow r in l_Rows)
            {
                arSelIndex[i++] = r.Index;
            }
            Array.Sort(arSelIndex);

            foreach (int n in arSelIndex)
            {
                ActionDriveToSubPoints(n);
                DeleteAction(m_lstAction[n]);
            }

            int iEventID = GVAR.g_ManageDB.GetEventID(m_CCurMatch.MatchID);
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);
            GVAR.g_ManageDB.GetMatchActionList(iMatchID, iSplitID, ref m_lstAction);
            UpdateActionList(ref m_lstAction, -1);
            GVAR.g_BKPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, iEventID, -1, iMatchID, iMatchID, null);
        }

        private void ActionDriveToSubPoints(int n)
        {
            if (m_lstAction[n].ActionType == EActionType.em2PointsMade
                || m_lstAction[n].ActionType == EActionType.em3PointsMade
                || m_lstAction[n].ActionType == EActionType.emFreeThrowMade)
            {
                int iResult = 0;
                switch (m_lstAction[n].ActionType)
                {
                    case EActionType.em2PointsMade:
                        iResult = m_CCurMatch.ChangePoint(m_lstAction[n].TeamPos, false, 2);
                        break;
                    case EActionType.em3PointsMade:
                        iResult = m_CCurMatch.ChangePoint(m_lstAction[n].TeamPos, false, 3);
                        break;
                    case EActionType.emFreeThrowMade:
                        iResult = m_CCurMatch.ChangePoint(m_lstAction[n].TeamPos, false, 1);
                        break;
                }
                if (iResult == 1)
                {
                    GVAR.g_ManageDB.UpdateTeamSetPt(m_CCurMatch.Period, ref m_CCurMatch);
                    GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);
                }
                UpdateUIForTeamScore();
            }
        }

        private void btnX_HomeTeam_Click(object sender, EventArgs e)
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);

            if (m_CCurAction.IsNewAction())
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            m_CCurAction.TeamPos = 1;
            m_CCurAction.TeamID = m_CCurMatch.m_CHomeTeam.TeamID;
            m_CCurAction.TeamName = m_CCurMatch.m_CHomeTeam.TeamName;

            m_CCurAction.ActionTime = GVAR.FormatTime(m_CCurMatch.MatchTime);
            m_CCurAction.RegisterID = m_CCurMatch.m_CHomeTeam.TeamID;
            m_CCurAction.ShirtNo = 0;
            m_CCurAction.PlayerName = m_CCurMatch.m_CHomeTeam.TeamName;

            UpdateUIActionInfo();
            if (m_CCurAction.IsActionComplete())
            {
                AddAction();
                GVAR.g_ManageDB.GetMatchActionList(iMatchID, iSplitID, ref m_lstAction);
                UpdateActionList(ref m_lstAction, -1);
                m_CCurAction.Init();
                UpdateUIActionInfo();
            }
        }

        private void btnX_VisitTeam_Click(object sender, EventArgs e)
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);

            if (m_CCurAction.IsNewAction())
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            m_CCurAction.TeamPos = 2;
            m_CCurAction.TeamID = m_CCurMatch.m_CVisitTeam.TeamID;
            m_CCurAction.TeamName = m_CCurMatch.m_CVisitTeam.TeamName;

            m_CCurAction.ActionTime = GVAR.FormatTime(m_CCurMatch.MatchTime);
            m_CCurAction.RegisterID = m_CCurMatch.m_CVisitTeam.TeamID;
            m_CCurAction.ShirtNo = 0;
            m_CCurAction.PlayerName = m_CCurMatch.m_CVisitTeam.TeamName;

            UpdateUIActionInfo();
            if (m_CCurAction.IsActionComplete())
            {
                AddAction();
                GVAR.g_ManageDB.GetMatchActionList(iMatchID, iSplitID, ref m_lstAction);
                UpdateActionList(ref m_lstAction, -1);
                m_CCurAction.Init();
                UpdateUIActionInfo();
            }
        }

        private void btnX_ImportStatData_Click(object sender, EventArgs e)
        {
            if (m_CCurMatch.MatchID == "" || m_CCurMatch.MatchID == "0")
                return;

            OpenFileDialog openFileDialog = new OpenFileDialog();
            openFileDialog.Filter = "xml(*.xml)|*.xml|xml文件(*.xml)|*.xml";

            if (openFileDialog.ShowDialog() == DialogResult.OK)
            {
                this.Cursor = Cursors.WaitCursor;
                string strXmlFileName = openFileDialog.FileName;

                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.Load(strXmlFileName);

                if (xmlDoc.DocumentElement.Name == "xml")
                {
                    GVAR.g_ManageDB.DeleteAllMatchAction(int.Parse(m_CCurMatch.MatchID));

                    GVAR.g_ManageDB.CheckMatchStat(int.Parse(m_CCurMatch.MatchID));

                    Rs_DataXmlDoc(xmlDoc);

                    this.Cursor = Cursors.Default;
                    return;
                }
                this.Cursor = Cursors.Default;
            }
        }

        private void Rs_DataXmlDoc(XmlDocument xmlDoc)
        {
            XmlElement xmlElement;
            XmlNode xmlNode;

            string strSel = "/xml";
            xmlNode = xmlDoc.SelectSingleNode(strSel);

            foreach (XmlNode oneNode in xmlNode.ChildNodes)
            {
                xmlElement = (XmlElement)oneNode;
                string strChildNodeName = xmlElement.Name;
                if (strChildNodeName != "rs:data")
                    continue;

                foreach (XmlNode oneRowNode in oneNode.ChildNodes)
                {
                    xmlElement = (XmlElement)oneRowNode;
                    string strActionId = GetAttributeValue(xmlElement, "ActionId");
                    string strTeamPos = GetAttributeValue(xmlElement, "HorV");//1-H;2-V
                    string strTime = GetAttributeValue(xmlElement, "Time");
                    string strNumber = GetAttributeValue(xmlElement, "Number");
                    string strActionNo = GetAttributeValue(xmlElement, "ActionNo");

                    OVRBKActionInfo oNewOVRBKActionInfo = new OVRBKActionInfo();

                    oNewOVRBKActionInfo.AcitonID = -1;
                    oNewOVRBKActionInfo.MatchID = int.Parse(m_CCurMatch.MatchID);
                    oNewOVRBKActionInfo.MatchSplitID = 1;
                    oNewOVRBKActionInfo.ActionTime = strTime;
                    oNewOVRBKActionInfo.TeamPos = int.Parse(strTeamPos);
                    if (strNumber == "" || strNumber == "队")
                    {
                        oNewOVRBKActionInfo.ShirtNo = 0;
                        oNewOVRBKActionInfo.RegisterID = -1;
                    }
                    else
                    {
                        oNewOVRBKActionInfo.ShirtNo = int.Parse(strNumber);
                        string strRegisterID = GetRegisterIDByTeamShirtNo(strTeamPos, strNumber);
                        if (strRegisterID == "")
                            strRegisterID = "-1";
                        oNewOVRBKActionInfo.RegisterID = int.Parse(strRegisterID);
                    }
                    oNewOVRBKActionInfo.ActionType = GetActionTypeByActionNo(strActionNo);
                    oNewOVRBKActionInfo.ActionCode = GetActionCodeByActionNo(strActionNo);
                    if (oNewOVRBKActionInfo.ActionType == EActionType.emSubstituteIn||
                        oNewOVRBKActionInfo.ActionType == EActionType.emSubstituteOut)
                        continue;

                    GVAR.g_ManageDB.AddMatchAction(oNewOVRBKActionInfo);
                }
            }
        }

        private string GetRegisterIDByTeamShirtNo(string strTeamPos, string strShirtNo)
        {
            DataGridView dg = null;
            if(strTeamPos == "1")
                dg = this.dgvHomeList;
            else if(strTeamPos == "2")
                dg = this.dgvVisitList;
            else
                return "";

            for (int nRow = 0; nRow < dg.Rows.Count; nRow++)
            {
                if (dg.Rows[nRow].Cells["ShirtNo"].Value.ToString() == strShirtNo)
                    return dg.Rows[nRow].Cells["F_RegisterID"].Value.ToString();
            }

            return "";
        }

        private EActionType GetActionTypeByActionNo(string strActionNo)
        {
            if (strActionNo == "1" /*2分中*/||
                strActionNo == "14"/*补篮中*/||
                strActionNo == "16"/*扣篮*/)
                return EActionType.em2PointsMade;
            if (strActionNo == "3"/*2分投*/||
                strActionNo == "15"/*补篮未中*/||
                strActionNo == "17"/*扣篮未中*/)
                return EActionType.em2PointsMissed;
            if (strActionNo == "2")
                return EActionType.em3PointsMade;
            if (strActionNo == "4")
                return EActionType.em3PointsMissed;
            if (strActionNo == "10")
                return EActionType.emFreeThrowMade;
            if (strActionNo == "11")
                return EActionType.emFreeThrowMissed;
            if (strActionNo == "5")
                return EActionType.emOffensiveRebound;
            if (strActionNo == "50")
                return EActionType.emDefensiveRebound;
            if (strActionNo == "6")
                return EActionType.emAssist;
            if (strActionNo == "20")
                return EActionType.emTurnover;
            if (strActionNo == "19")
                return EActionType.emSteal;
            if (strActionNo == "18")
                return EActionType.emBlockedShot;
            if (strActionNo == "7")
                return EActionType.emOffensiveFoul;
            if (strActionNo == "9")
                return EActionType.emDefensiveFoul;
            if (strActionNo == "21")
                return EActionType.emSubstituteIn;
            if (strActionNo == "22")
                return EActionType.emSubstituteOut;

            return EActionType.emUnKnow;
        }

        private string GetActionCodeByActionNo(string strActionNo)
        {
            EActionType tempEActionType = GetActionTypeByActionNo(strActionNo);
            return ((int)tempEActionType).ToString();
        }
    }
}
