using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using DevComponents.DotNetBar.Controls;
using AutoSports.OVRCommon;
using System.IO;
using System.IO.Ports;
using System.Threading;

namespace AutoSports.OVRWPPlugin
{
    public enum EOperatetype
    {
        emUnKnow = -1,   //未知
        emPoint = 0,     //只加分
        emStat = 1,     //只技术统计
        emMixed = 2,     //技术统计改比分
    }
    public partial class frmOVRWPDataEntry : DevComponents.DotNetBar.Office2007Form
    {
        private string m_strSectionName;
        public bool m_bAutoSendMessage = true;
        private bool m_bIsCloseThreadManuel = false;
        private EOperatetype m_emOperateType;
        public OVRWPMatchInfo m_CCurMatch = new OVRWPMatchInfo();
        public int m_MatchID = -1;

        public List<OVRWPActionInfo> m_lstAction = new List<OVRWPActionInfo>();
        public OVRWPActionInfo m_CCurAction = new OVRWPActionInfo();
        private SerialPortReceiver m_Serial;
        private bool m_bParse = false;
        private Thread m_ParseThread;
        private Thread m_ParseUDPThread;
        public DataGridViewTextBoxEditingControl cellEditingControl = null;
        public string m_strActionTime = string.Empty;
        public int m_iActiveTeamPos = 0;
        public int m_iInCount_Home;
        public int m_iInCount_Visit;
        private ReceiverType m_eReceiverType;
        public Modetype m_emMode;
        private string m_strStatisticTag = string.Empty;
        private string m_strPointTag = string.Empty;
        private string m_strStatusTag = string.Empty;
        private string m_strPeriodTag = string.Empty;
        private string m_strStaffTag = string.Empty;
        private bool m_bStatictis = false;
        private bool m_bStatus = false;
        private bool m_bPeriod = false;
        private bool m_bStaff = false;
        private bool m_bPoint = false;
        private bool b_calculateRank = false;
        public frmOVRWPDataEntry()
        {
            InitializeComponent();

            m_CCurMatch.Init();

            m_emOperateType = EOperatetype.emMixed;

            m_strSectionName = "OVRWPPlugin";
        }

        private void frmOVRWPDataEntry_Load(object sender, EventArgs e)
        {
            Localization();
            InitUI();
            InitConnenctionType();
            EnableMatchBtn(false);
            EnalbeMatchCtrl(false);
            EnableScoreBtn(false);
            EnablePenaltyPeriod(false);
            TS_InterfaceEnable(false);
            InitStatusBtn();
            InitOperateType();
            tbExportPath.Text = "C:\\";
        }

        private void Localization()
        {
            this.lbSet1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSet1");
            this.lbSet2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSet2");
            this.lbSet3.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSet3");
            this.lbSet4.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSet4");
            this.lbExa1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbExa1");
            this.lbExa2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbExa2");

            this.btnStartPeriod.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStartPeriod");
            this.btnEndPeriod.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnEndPeriod");

            this.btnOfficial.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnOfficial");
            this.btnTeamInfo.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnTeamInfo");
            this.btnExit.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnExit");
            this.btnPenaltyScore.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnPenaltyScore");
            this.btnMatchResult.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnMatchResult");
            this.btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStart");
            this.btnWeatherSet.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnWeatherSet");

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

            this.btnTimeOut.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnTimeOut_Home");
            this.btnCornerThrow.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnCornerThrow_Home");
            this.btn_Export.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btn_Export");
            this.btnIn.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnIn");
            this.btnOut.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnOut");
            this.btnActionShot.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnActionShot");
            this.btnCentreShot.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnCentreShot");
            this.btnXShot.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnXShot");
            this.btn5mShot.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btn5mShot");
            this.btnPSShot.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnPSShot");
            this.btnCounterShot.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnCounterShot");
            this.btnFreeThrow.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnFreeThrow");
            this.btnGoal.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnGoal");
            this.btnSaved.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnSaved");
            this.btnMissed.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnMissed");
            this.btnPost.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnPost");
            this.btnBlockShot.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnBlockShot");
            this.btnAssist.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnAssist");
            this.btnTournOver.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnTournOver");
            this.btnSteal.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnSteal");
            this.btnBlock.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnBlock");
            this.btn20C.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btn20C");
            this.btn20F.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btn20F");
            this.btnEXS.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnEXS");
            this.btnEXN.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnEXN");
            this.btnSpinWon.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnSpinWon");
            this.btnSpinLost.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnSpinLost");
            this.btnPenalty.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnPenalty");

            this.hlbPossTime.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPossTime");
            this.vlbPossTime.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPossTime");
            this.hlbPossNum.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPossNum");
            this.vlbPossNum.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPossNum");

            this.btnClearAction.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnClearAction");
            this.gbMatchScore.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbMatchScore");
            this.gbMatchStatistic.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbMatchStatistic");
            this.gbHome.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbHome");
            this.gbAttempt.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbAttempt");
            this.gbResult.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbResult");
            this.gbStatistic.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbStatistic");
            this.gbVisit.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbVisit");

            this.btn_ReceiceSetting.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btn_ReceiceSetting");
            this.btn_start_receive.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btn_start_receive");
            this.btn_stop_receive.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btn_stop_receive");
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
            if (GVAR.g_WPPlugin == null)
                return;
            if (strMatchID == m_CCurMatch.MatchID) 
                return;

            if (m_CCurMatch.MatchID.Trim().Length != 0)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "mbExit"));
                return;
            }

            ModeSelectDlg ModeDlg = new ModeSelectDlg();
            ModeDlg.m_nMatchID = GVAR.Str2Int(strMatchID);
            if (DialogResult.OK != ModeDlg.ShowDialog())
                return;

            m_emMode = ModeDlg.Mode;
            HideContrls(m_emMode);

            GVAR.g_ManageDB.GetActiveSportInfo();

            m_CCurMatch.MatchID = strMatchID.ToString();
            m_MatchID = GVAR.Str2Int(strMatchID);

            // Update Report Context
            GVAR.g_WPPlugin.SetReportContext("MatchID", strMatchID);

            // Load Match Data
            m_bAutoSendMessage = false;
            GVAR.g_ManageDB.GetMatchInfo(m_MatchID, ref m_CCurMatch);
            m_bAutoSendMessage = true;
            //////////////////////////////////////////
            //判断当前比赛类型：正常比赛，点球赛
            if (m_CCurMatch.MatchStatus == GVAR.STATUS_SCHEDULE || m_CCurMatch.MatchStatus == GVAR.STATUS_ON_COURT)
            {
                if (m_CCurMatch.MatchType == GVAR.MATCH_COMMON)
                {
                    m_CCurMatch.CurPeriod = GVAR.PERIOD_1ST;
                    GVAR.g_ManageDB.InitMatchSplit(ref m_CCurMatch, 4);
                    GVAR.g_ManageDB.UpdateMatchPeriod(ref m_CCurMatch);

                    //初始化第一节比分
                    //m_CCurMatch.m_CHomeTeam.SetScore("0", GVAR.PERIOD_1ST);
                    //m_CCurMatch.m_CVisitTeam.SetScore("0", GVAR.PERIOD_1ST);
                    //GVAR.g_ManageDB.UpdateTeamSetPt(ref m_CCurMatch);

                    //初始化时间

                    m_CCurMatch.InitTime();
                }
                else if (m_CCurMatch.MatchType == GVAR.MATCH_PENALTY)
                {
                    m_CCurMatch.CurPeriod = GVAR.PERIOD_PSO;
                    GVAR.g_ManageDB.InitMatchSplit(ref m_CCurMatch, 1);
                    GVAR.g_ManageDB.UpdateMatchPeriod(ref m_CCurMatch);

                    //m_CCurMatch.m_CHomeTeam.SetScore("0", GVAR.PERIOD_PSO);
                    //m_CCurMatch.m_CVisitTeam.SetScore("0", GVAR.PERIOD_PSO);
                    //GVAR.g_ManageDB.UpdateTeamSetPt(ref m_CCurMatch);
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

                GVAR.g_ManageDB.SetTeamMemberCount(GVAR.Str2Int(strMatchID), 1, 13);
                GVAR.g_ManageDB.SetTeamMemberCount(GVAR.Str2Int(strMatchID), 2, 13);
                SetTeamInitTime();
            }

            if (m_CCurMatch.MatchStatus > GVAR.STATUS_SCHEDULE)
            {
                GVAR.g_ManageDB.GetTeamDetailInfo(m_MatchID, ref m_CCurMatch.m_CHomeTeam);
                GVAR.g_ManageDB.GetTeamDetailInfo(m_MatchID, ref m_CCurMatch.m_CVisitTeam);
               
            }
            m_iInCount_Home = GVAR.g_ManageDB.GetTeamMemberCount(GVAR.Str2Int(strMatchID), 1);
            m_iInCount_Visit = GVAR.g_ManageDB.GetTeamMemberCount(GVAR.Str2Int(strMatchID), 2);
            EnableMatchBtn(true);
            m_bAutoSendMessage = false;
            InitMatchInfo();
            UpdateMatchStatus();
            m_bAutoSendMessage = true;
            UpdateActionList(ref m_lstAction, -1,false);
            GetPossStat();

            if (m_emMode != Modetype.emSingleMachine)
            {
                MultipleMachineTimer.Enabled = true;
            }

            OPenUDP(6666);
        }
       
        public void MultipleAutoUpdate()
        {
            GVAR.g_ManageDB.GetMatchInfo(m_MatchID, ref m_CCurMatch);
            if ( m_bPoint||m_bPeriod)
            {
                if (m_CCurMatch.MatchStatus > GVAR.STATUS_SCHEDULE)
                {
                    GVAR.g_ManageDB.GetTeamDetailInfo(m_MatchID, ref m_CCurMatch.m_CHomeTeam);
                    GVAR.g_ManageDB.GetTeamDetailInfo(m_MatchID, ref m_CCurMatch.m_CVisitTeam);
                }
            }
            if (m_bStatictis)
            {
                m_iInCount_Home = GVAR.g_ManageDB.GetTeamMemberCount(m_MatchID, 1);
                m_iInCount_Visit = GVAR.g_ManageDB.GetTeamMemberCount(m_MatchID, 2);
            }
            if (m_bStatus)
            {
                 EnableMatchBtn(true);
            }

            AutoInitMatchInfo();

            if (m_bStatus||m_bPeriod)
            {
                UpdateMatchStatus();
            }

            if (m_bStatictis)
            {
                if (Modetype.emMul_BlueStat == m_emMode
                   || Modetype.emMul_WhiteStat == m_emMode
                   || Modetype.emMul_Substitute == m_emMode)
                {
                    return;
                }
                else
                {
                    UpdateActionList(ref m_lstAction, -1, false);
                }
            }
            //GetPossStat();
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
            frmOVRWPOfficialEntry OfficialForm = new frmOVRWPOfficialEntry(iMatchID);
            OfficialForm.ShowDialog();

            GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emMatchOfficials, -1, -1, -1, iMatchID, iMatchID, null);

            if (Modetype.emSingleMachine != m_emMode)
            {
                m_strStaffTag = System.Environment.TickCount.ToString();
                GVAR.g_ManageDB.UpdateMatchStaffTagString(m_MatchID, m_strStaffTag);
            }
        }

        private void btnTeamInfo_Click(object sender, EventArgs e)
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iHomeRegID = m_CCurMatch.m_CHomeTeam.TeamID;
            int iVisitRegID = m_CCurMatch.m_CVisitTeam.TeamID;
            string strHomeName = m_CCurMatch.m_CHomeTeam.TeamName;
            string strVisitName = m_CCurMatch.m_CVisitTeam.TeamName;

            frmOVRWPTeamMemberEntry MatchMemberForm = new frmOVRWPTeamMemberEntry(iMatchID, iHomeRegID, iVisitRegID, strHomeName, strVisitName);
            MatchMemberForm.ShowDialog();

            if (m_CCurMatch.MatchStatus <= GVAR.STATUS_ON_COURT)
            {
                SetTeamInitTime();
            }
            ResetPlayerList(1, ref dgvHomeList);
            ResetPlayerList(2, ref dgvVisitList);
            GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emMatchCompetitorMember, -1, -1, -1, iMatchID, iMatchID, null);

            if (Modetype.emSingleMachine != m_emMode)
            {
                m_strStaffTag = System.Environment.TickCount.ToString();
                GVAR.g_ManageDB.UpdateMatchStaffTagString(m_MatchID, m_strStaffTag);
            }
        }
        public void SetTeamInitTime()
        {
            GVAR.g_ManageDB.SetActiveMember(m_MatchID, 1);
            GVAR.g_ManageDB.SetActiveMember(m_MatchID, 2);
            GVAR.g_ManageDB.SetTeamMemberInitTime(m_MatchID, 1, GVAR.MATCH_TIME.ToString());
            GVAR.g_ManageDB.SetTeamMemberInitTime(m_MatchID, 2, GVAR.MATCH_TIME.ToString());
        }
        private void btnExit_Click(object sender, EventArgs e)
        {
            if (m_CCurMatch.MatchID == null || m_CCurMatch.MatchID.Length == 0)
            {
                return;
            }

            if (DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "mbExitMatch"), "", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                ClearReceiveThreads();
                if (m_CCurMatch.bRunTime)
                {
                    m_CCurMatch.bRunTime = false;
                    btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStart");
                    timer1.Enabled = false;
                }
                EnableMatchBtn(false);
                EnalbeMatchCtrl(false);
                EnableScoreBtn(false);
                EnablePenaltyPeriod(false);
                TS_InterfaceEnable(false);

                UpdateMatchTime();

                m_CCurMatch.Init();
                m_CCurAction.Init();
                UpdateUIActionInfo();
                InitMatchInfo();
                InitStatusBtn();
                dgvHomeList.Rows.Clear();
                dgvVisitList.Rows.Clear();
                ClearAllBtnBibNumer(1);
                ClearAllBtnBibNumer(2);
                m_lstAction.Clear();
                UpdateActionList(ref m_lstAction, -1, true);
                MultipleMachineTimer.Enabled = false;
                ShowAllContrls();
            }
        }
        public void UpdateMatchTime()
        {
            if (Modetype.emMul_BlueStat != m_emMode
                   && Modetype.emMul_WhiteStat != m_emMode
                   && Modetype.emMul_DoubleTeamStat != m_emMode
                   && Modetype.emMul_Monitor != m_emMode)
            {
                GVAR.g_ManageDB.UpdateMatchTime(m_MatchID, m_CCurMatch.MatchTime);
            }
        }
        public void HideContrls(Modetype emModetype)
        {
            if (emModetype == Modetype.emSingleMachine)
            {

            }
            else if (emModetype == Modetype.emMul_Monitor)
            {
                btnHPt_Add.Visible = false;
                btnHPt_Sub.Visible = false;

                btnVPt_Add.Visible = false;
                btnVPt_Sub.Visible = false;

                gbAttempt.Visible = false;
                gbResult.Visible = false;
                gbStatistic.Visible = false;

                btnClearAction.Visible = false;

                btn_Export.Visible = false;
                btnxExPathSel.Visible = false;
                tbExportPath.Visible = false;

                btnStartPeriod.Visible = false;
                btnEndPeriod.Visible = false;
                btnPrevious.Visible = false;
                btnNext.Visible = false;
                btnStart.Visible = false;

                btnMatchResult.Visible = false;
                btnWeatherSet.Visible = false;
                btnTeamInfo.Visible = false;
                btnOfficial.Visible = false;
            }
            else if (emModetype == Modetype.emMul_Admin)
            {
                
            }
            else if (emModetype == Modetype.emMul_Substitute)
            {
                //btnHPt_Add.Visible = false;
                //btnHPt_Sub.Visible = false;

                //btnVPt_Add.Visible = false;
                //btnVPt_Sub.Visible = false;

                gbAttempt.Visible = false;
                gbResult.Visible = false;

                btnAssist.Visible = false;
                btnSteal.Visible = false;
                btnBlock.Visible = false;
                btnTimeOut.Visible = false;
                btnCornerThrow.Visible = false;

                btn20C.Visible = false;
                btn20F.Visible = false;
                btnEXS.Visible = false;
                btnEXN.Visible = false;
                btnPenalty.Visible = false;
                btnTournOver.Visible = false;
                btnSpinWon.Visible = false;
                btnSpinLost.Visible = false;

                btn_Export.Visible = false;
                btnxExPathSel.Visible = false;
                tbExportPath.Visible = false;
                btnMatchResult.Visible = false;
                btnWeatherSet.Visible = false;
            }
            else if (emModetype == Modetype.emMul_WhiteStat)
            {

                btnHPt_Add.Visible = false;
                btnHPt_Sub.Visible = false;

                btnVPt_Add.Visible = false;
                btnVPt_Sub.Visible = false;

                dgvVisitList.Visible = false;

                btnVActive_1.Visible = false;
                btnVActive_2.Visible = false;
                btnVActive_3.Visible = false;
                btnVActive_4.Visible = false;
                btnVActive_5.Visible = false;
                btnVActive_6.Visible = false;
                btnVActive_7.Visible = false;
                btnVActive_8.Visible = false;
                btnVActive_9.Visible = false;
                btnVActive_10.Visible = false;
                btnVActive_11.Visible = false;
                btnVActive_12.Visible = false;
                btnVActive_13.Visible = false;

                btnStartPeriod.Visible = false;
                btnEndPeriod.Visible = false;

                btnIn.Visible = false;
                btnOut.Visible = false;
               
                btn_Export.Visible = false;
                btnxExPathSel.Visible = false;
                tbExportPath.Visible = false;

                btnMatchResult.Visible = false;
                btnWeatherSet.Visible = false;
                btnTeamInfo.Visible = false;
                btnOfficial.Visible = false;
            }
            else if (emModetype == Modetype.emMul_BlueStat)
            {
                btnHPt_Add.Visible = false;
                btnHPt_Sub.Visible = false;

                btnVPt_Add.Visible = false;
                btnVPt_Sub.Visible = false;

                dgvHomeList.Visible = false;

                btnHActive_1.Visible = false;
                btnHActive_2.Visible = false;
                btnHActive_3.Visible = false;
                btnHActive_4.Visible = false;
                btnHActive_5.Visible = false;
                btnHActive_6.Visible = false;
                btnHActive_7.Visible = false;
                btnHActive_8.Visible = false;
                btnHActive_9.Visible = false;
                btnHActive_10.Visible = false;
                btnHActive_11.Visible = false;
                btnHActive_12.Visible = false;
                btnHActive_13.Visible = false;

                btnStartPeriod.Visible = false;
                btnEndPeriod.Visible = false;

                btnIn.Visible = false;
                btnOut.Visible = false;

                btn_Export.Visible = false;
                btnxExPathSel.Visible = false;
                tbExportPath.Visible = false;

                btnMatchResult.Visible = false;
                btnWeatherSet.Visible = false;
                btnTeamInfo.Visible = false;
                btnOfficial.Visible = false;
            }
            else if (emModetype == Modetype.emMul_DoubleTeamStat)
            {
                btnHPt_Add.Visible = false;
                btnHPt_Sub.Visible = false;

                btnVPt_Add.Visible = false;
                btnVPt_Sub.Visible = false;

                btnStartPeriod.Visible = false;
                btnEndPeriod.Visible = false;

                btnIn.Visible = false;
                btnOut.Visible = false;

                btn_Export.Visible = false;
                btnxExPathSel.Visible = false;
                tbExportPath.Visible = false;

                btnMatchResult.Visible = false;
                btnWeatherSet.Visible = false;
                btnTeamInfo.Visible = false;
                btnOfficial.Visible = false;
            }
        }
        public void ShowAllContrls()
        {
            btnHPt_Add.Visible = true;
            btnHPt_Sub.Visible = true;

            btnVPt_Add.Visible = true;
            btnVPt_Sub.Visible = true;

            dgvHomeList.Visible = true;
            dgvVisitList.Visible = true;

            btnHActive_1.Visible = true;
            btnHActive_2.Visible = true;
            btnHActive_3.Visible = true;
            btnHActive_4.Visible = true;
            btnHActive_5.Visible = true;
            btnHActive_6.Visible = true;
            btnHActive_7.Visible = true;
            btnHActive_8.Visible = true;
            btnHActive_9.Visible = true;
            btnHActive_10.Visible = true;
            btnHActive_11.Visible = true;
            btnHActive_12.Visible = true;
            btnHActive_13.Visible = true;

            btnVActive_1.Visible = true;
            btnVActive_2.Visible = true;
            btnVActive_3.Visible = true;
            btnVActive_4.Visible = true;
            btnVActive_5.Visible = true;
            btnVActive_6.Visible = true;
            btnVActive_7.Visible = true;
            btnVActive_8.Visible = true;
            btnVActive_9.Visible = true;
            btnVActive_10.Visible = true;
            btnVActive_11.Visible = true;
            btnVActive_12.Visible = true;
            btnVActive_13.Visible = true;

            gbAttempt.Visible = true;
            gbResult.Visible = true;
            gbStatistic.Visible = true;

            btnIn.Visible = true;
            btnOut.Visible = true;
            btnAssist.Visible = true;
            btnSteal.Visible = true;
            btnBlock.Visible = true;
            btnTimeOut.Visible = true;
            btnCornerThrow.Visible = true;

            btn20C.Visible = true;
            btn20F.Visible = true;
            btnEXS.Visible = true;
            btnEXN.Visible = true;
            btnPenalty.Visible = true;
            btnTournOver.Visible = true;
            btnSpinWon.Visible = true;
            btnSpinLost.Visible = true;

            btnClearAction.Visible = true;

            //btn_Export.Visible = true;
            //btnxExPathSel.Visible = true;
           // tbExportPath.Visible = true;

            btnStartPeriod.Visible = true;
            btnEndPeriod.Visible = true;
            btnPrevious.Visible = true;
            btnNext.Visible = true;
            btnStart.Visible = true;

            btnMatchResult.Visible = true;
            btnWeatherSet.Visible = true;
            btnTeamInfo.Visible = true;
            btnOfficial.Visible = true;
            btnStatus.Visible = true;
        }
        private void InitConnenctionType()
        {
            DataTable dtType = new DataTable();
            dtType.Columns.Add("Display", System.Type.GetType("System.String"));
            dtType.Columns.Add("Value", System.Type.GetType("System.String"));

            dtType.Rows.Add("UDP", Convert.ToString((int)ReceiverType.UDP));
            dtType.Rows.Add("SerialPort", Convert.ToString((int)ReceiverType.SerialPort));
            comboBox_ConnectionType.DataSource = dtType;
            comboBox_ConnectionType.ValueMember = "Value";
            comboBox_ConnectionType.DisplayMember = "Display";
            comboBox_ConnectionType.SelectedValue = Convert.ToString((int)ReceiverType.UDP);

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
                if (!GVAR.g_ManageDB.ISAllSplitsEnd(m_MatchID))
                {
                    MessageBoxEx.Show("All  periods should be set official  before the match becoming unofficial!");
                    return;
                }
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

            int iResult = OVRDataBaseUtils.ChangeMatchStatus(GVAR.Str2Int(m_CCurMatch.MatchID), m_CCurMatch.MatchStatus, GVAR.g_sqlConn, GVAR.g_WPPlugin);
            GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatus, -1, -1, -1, m_MatchID, m_MatchID, null);
            if (iResult == 1) UpdateMatchStatus();
            if (Modetype.emSingleMachine != m_emMode)
            {
                m_strStatusTag = System.Environment.TickCount.ToString();
                GVAR.g_ManageDB.UpdateMatchStatusTagString(m_MatchID, m_strStatusTag);
            }
        }

        private void btn_ScoreAdd(object sender, EventArgs e)
        {
            if (m_CCurMatch.CurPeriod == 0)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "Msg_period"));
                return;
            }
            if (Modetype.emMul_Admin == m_emMode || Modetype.emMul_Substitute == m_emMode || Modetype.emSingleMachine == m_emMode)
            {
                int iResult = 0;
                if (sender == btnHPt_Add)
                {
                    iResult = m_CCurMatch.ChangePoint(1, true, 1, m_CCurMatch.CurPeriod);
                }
                else if (sender == btnVPt_Add)
                {
                    iResult = m_CCurMatch.ChangePoint(2, true, 1, m_CCurMatch.CurPeriod);
                }
                else if (sender == btnHPt_Sub)
                {
                    iResult = m_CCurMatch.ChangePoint(1, false, 1, m_CCurMatch.CurPeriod);
                }
                else if (sender == btnVPt_Sub)
                {
                    iResult = m_CCurMatch.ChangePoint(2, false, 1, m_CCurMatch.CurPeriod);
                }

                if (iResult == 1)
                {
                    GVAR.g_ManageDB.UpdateTeamSetPt(ref m_CCurMatch, m_CCurMatch.CurPeriod);
                    GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);
                }

                UpdateUIForTeamScore();
                if (Modetype.emSingleMachine != m_emMode)
                {
                    m_strPointTag = System.Environment.TickCount.ToString();
                    GVAR.g_ManageDB.UpdateMatchPointTagString(m_MatchID, m_strPointTag);
                }
            }
            GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);

            if (Modetype.emSingleMachine != m_emMode)
            {
                m_strPeriodTag = System.Environment.TickCount.ToString();
                GVAR.g_ManageDB.UpdateMatchPeriodTagString(m_MatchID, m_strPeriodTag);
            }
        }

        private void lbPeriod_TextChanged(object sender, EventArgs e)
        {
            lbSet1.ForeColor = System.Drawing.Color.Black;
            lbSet2.ForeColor = System.Drawing.Color.Black;
            lbSet3.ForeColor = System.Drawing.Color.Black;
            lbSet4.ForeColor = System.Drawing.Color.Black;
            lbExa1.ForeColor = System.Drawing.Color.Black;
            lbExa2.ForeColor = System.Drawing.Color.Black;
            lbPSO.ForeColor = System.Drawing.Color.Black;
            switch (m_CCurMatch.CurPeriod)
            {
                case GVAR.PERIOD_1ST:
                    lbSet1.ForeColor = System.Drawing.Color.Red;
                    btnPenaltyScore.Enabled = false;
                    break;
                case GVAR.PERIOD_2ND:
                    lbSet2.ForeColor = System.Drawing.Color.Red;
                    btnPenaltyScore.Enabled = false;
                    break;
                case GVAR.PERIOD_3RD:
                    lbSet3.ForeColor = System.Drawing.Color.Red;
                    btnPenaltyScore.Enabled = false;
                    break;
                case GVAR.PERIOD_4TH:
                    lbSet4.ForeColor = System.Drawing.Color.Red;
                    btnPenaltyScore.Enabled = false;
                    break;
                case GVAR.PERIOD_EXTRA1:
                    lbExa1.ForeColor = System.Drawing.Color.Red;
                    btnPenaltyScore.Enabled = false;
                    break;
                case GVAR.PERIOD_EXTRA2:
                    lbExa2.ForeColor = System.Drawing.Color.Red;
                    btnPenaltyScore.Enabled = false;
                    break;
                case GVAR.PERIOD_PSO:
                    lbPSO.ForeColor = System.Drawing.Color.Red;
                    btnPenaltyScore.Enabled = true;
                    break;
                default:
                    break;
            }
        }
        private void btnEndPeriod_Click(object sender, EventArgs e)
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.CurPeriod);
            GVAR.g_ManageDB.UpdateMatchSplitStatus(iMatchID, iMatchSplitID, GVAR.STATUS_FINISHED);
            btnEndPeriod.Enabled = false;
            btnStartPeriod.Enabled = false;
            UpdateNextBtnStat();
            if (m_CCurMatch.bRunTime)
            {
                m_CCurMatch.bRunTime = false;
                timer1.Enabled = false;
                btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStart");
            }
            btnAllTeamPlayersOut_Click(1);
            btnAllTeamPlayersOut_Click(2);
            m_CCurMatch.MatchTime = "0";
            MatchTime.Text = GVAR.TranslateINT32toTime(0);
            GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, iMatchID, iMatchID, null);

            if (Modetype.emSingleMachine != m_emMode)
            {
                m_strPeriodTag = System.Environment.TickCount.ToString();
                GVAR.g_ManageDB.UpdateMatchPeriodTagString(m_MatchID, m_strPeriodTag);
            }
        }

        private void btnStartPeriod_Click(object sender, EventArgs e)
        {
            if (m_CCurMatch.CurPeriod <= GVAR.PERIOD_4TH)
            {
                GVAR.g_ManageDB.SetTeamMemberInitTime(m_MatchID,1,GVAR.MATCH_TIME.ToString());
                GVAR.g_ManageDB.SetTeamMemberInitTime(m_MatchID, 2, GVAR.MATCH_TIME.ToString());
            }
            else if (m_CCurMatch.CurPeriod == GVAR.PERIOD_EXTRA1 || m_CCurMatch.CurPeriod == GVAR.PERIOD_EXTRA2)
            {
                GVAR.g_ManageDB.SetTeamMemberInitTime(m_MatchID, 1, GVAR.EXTRA_TIME.ToString());
                GVAR.g_ManageDB.SetTeamMemberInitTime(m_MatchID, 2, GVAR.EXTRA_TIME.ToString());
            }
            else if (m_CCurMatch.CurPeriod == GVAR.PERIOD_PSO)
            {
                GVAR.g_ManageDB.SetTeamMemberInitTime(m_MatchID, 1, "0");
                GVAR.g_ManageDB.SetTeamMemberInitTime(m_MatchID, 2, "0");
            }
            ResetPlayerList(1, ref dgvHomeList);
            ResetPlayerList(2, ref dgvVisitList);


            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.CurPeriod);
            GVAR.g_ManageDB.UpdateMatchSplitStatus(iMatchID, iMatchSplitID, GVAR.STATUS_RUNNING);
            btnEndPeriod.Enabled = true;
            btnStartPeriod.Enabled = false;

            if (m_CCurMatch.m_CHomeTeam.GetScore(m_CCurMatch.CurPeriod).Length == 0)
            {
                m_CCurMatch.m_CHomeTeam.SetScore("0", m_CCurMatch.CurPeriod);
            }
            if (m_CCurMatch.m_CVisitTeam.GetScore(m_CCurMatch.CurPeriod).Length == 0)
            {
                m_CCurMatch.m_CVisitTeam.SetScore("0", m_CCurMatch.CurPeriod);
            }
            GVAR.g_ManageDB.UpdateTeamSetPt(ref m_CCurMatch,m_CCurMatch.CurPeriod);
            UpdateUIForTeamScore();
            if (!m_CCurMatch.bRunTime && m_CCurMatch.CurPeriod != GVAR.PERIOD_PSO)
            {
                if (!m_bParse)
                {
                    EnablebtnStart(true);
                    EnableMatchTime(true);
                    btnStart_Click(null, null);
                }
                else
                {
                    EnablebtnStart(false);
                    EnableMatchTime(false);
                }
            }

            GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, iMatchID, iMatchID, null);
            if (Modetype.emSingleMachine != m_emMode)
            {
                m_strPeriodTag = System.Environment.TickCount.ToString();
                GVAR.g_ManageDB.UpdateMatchPeriodTagString(m_MatchID, m_strPeriodTag);
            }

            UpdatePeriodBtnStat();

        }
        private void btnNext_Click(object sender, EventArgs e)
        {
            OnBtnChangePeriod(true);
        }

        private void btnPrevious_Click(object sender, EventArgs e)
        {
            OnBtnChangePeriod(false);
        }
        private int GetSetScore(bool iHomeTeam, int iSet)
        {//iSet = 1,2,3,4,5,6;
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
        private void UpdatePreviousBtnStat()
        {
            if (m_CCurMatch.CurPeriod == GVAR.PERIOD_1ST)
            {
                btnPrevious.Enabled = false;
            }
            else
            {
                btnPrevious.Enabled = true;
            }
        }
        private void UpdateNextBtnStat()
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.CurPeriod);
            int iSplitStatus = GVAR.g_ManageDB.GetSplitStatusID(iMatchID, iMatchSplitID);
            if (iSplitStatus == GVAR.STATUS_FINISHED)
            {
                if (m_CCurMatch.CurPeriod == GVAR.PERIOD_PSO)
                {
                    btnNext.Enabled = false;
                    return;
                }

                if(m_CCurMatch.bPoolMatch)
                {
                    if (m_CCurMatch.CurPeriod == GVAR.PERIOD_4TH)
                     {
                          btnNext.Enabled = false;
                          return;
                     }
                    else
                     {
                          btnNext.Enabled = true;
                          return;
                     }
                }

                if (m_CCurMatch.CurPeriod == GVAR.PERIOD_4TH)
                {
                    if (SumPeriodsGoals(true,4)!=SumPeriodsGoals(false,4))
                    {
                        btnNext.Enabled = false;
                        return;
                    }
                    else
                    {        
                        btnNext.Enabled = true;
                        return;
                    }
                }
                else if (m_CCurMatch.CurPeriod == GVAR.PERIOD_EXTRA2)
                {
                     if (SumPeriodsGoals(true,6)!=SumPeriodsGoals(false,6))
                    {
                        btnNext.Enabled = false;
                        return;
                    }
                    else
                    {        
                        btnNext.Enabled = true;
                        return;
                    }
                }
                btnNext.Enabled = true;
            }
            else
            {
                btnNext.Enabled = false;
            }
        }
        private void UpdatePeriodBtnStat()
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.CurPeriod);
            int iSplitStatus = GVAR.g_ManageDB.GetSplitStatusID(iMatchID, iMatchSplitID);
            if (iSplitStatus == GVAR.STATUS_RUNNING)
            {
                btnStartPeriod.Enabled = false;
                btnEndPeriod.Enabled = true;

                btnHPt_Sub.Enabled = true;
                btnHPt_Add.Enabled = true;
                btnVPt_Sub.Enabled = true;
                btnVPt_Add.Enabled = true;
            }
            else if (iSplitStatus == GVAR.STATUS_FINISHED)
            {
                btnStartPeriod.Enabled = false;
                btnEndPeriod.Enabled = false;
                btnHPt_Sub.Enabled = true;
                btnHPt_Add.Enabled = true;
                btnVPt_Sub.Enabled = true;
                btnVPt_Add.Enabled = true;
            }
            else
            {
                btnStartPeriod.Enabled = true;
                btnEndPeriod.Enabled = false;
                btnHPt_Sub.Enabled = false;
                btnHPt_Add.Enabled = false;
                btnVPt_Sub.Enabled = false;
                btnVPt_Add.Enabled = false;
            }
        }
        private void UpdatePossStat()
        {
            if (m_CCurMatch.CurPeriod == GVAR.PERIOD_PSO)
            {
                hlbPossNum.Enabled = false;
                hlbPossTime.Enabled = false;
                vlbPossNum.Enabled = false;
                vlbPossTime.Enabled = false;
                homepossInput.Enabled = false;
                homePossTime.Enabled = false;
                visitpossInput.Enabled = false;
                visitPossTime.Enabled = false;
            }
            else
            {
                hlbPossNum.Enabled = true;
                hlbPossTime.Enabled = true;
                vlbPossNum.Enabled = true;
                vlbPossTime.Enabled = true;
                homepossInput.Enabled = true;
                homePossTime.Enabled = true;
                visitpossInput.Enabled = true;
                visitPossTime.Enabled = true;
            }
        }
        private void OnBtnChangePeriod(bool bAdd)
        {
            m_CCurAction.Init();
            UpdateUIActionInfo();
            m_CCurMatch.ChangePeriod(bAdd);
            UpdatePreviousBtnStat();
            UpdateNextBtnStat();
            UpdatePeriodBtnStat();
            UpdatePossStat();

            ChangePeriod();
            UpdateUIForTeamScore();
            GetPossStat();
            EnablePenaltyPeriod(true);
            if (m_CCurMatch.bRunTime)
            {
                m_CCurMatch.bRunTime = false;
                btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStart");
                timer1.Enabled = false;
            }
            m_CCurMatch.InitTime();
            int iMatchTime = m_CCurMatch.MatchTime.Trim().Length == 0 ? 0 : int.Parse(m_CCurMatch.MatchTime.Trim());
            MatchTime.Text = GVAR.TranslateINT32toTime(iMatchTime);
            if (Modetype.emSingleMachine != m_emMode)
            {
                m_strPeriodTag = System.Environment.TickCount.ToString();
                GVAR.g_ManageDB.UpdateMatchPeriodTagString(m_MatchID, m_strPeriodTag);
            }
        }

        #region Code  for MatchTime
        private void btnStart_Click(object sender, EventArgs e)
        {
            if (!m_CCurMatch.bRunTime)
            {
                m_CCurMatch.bRunTime = true;
                btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStop");

               //是否执行System.Timers.Timer.Elapsed事件； 

                if (m_CCurMatch.MatchTime.Length == 0)
                {
                    m_CCurMatch.InitTime();
                }
                timer1.Enabled = true;
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

        private void btnAllTeamPlayersOut_Click(int iTeamPos)
        {
            DataGridView dgv = new DataGridView();
            if (iTeamPos == 1)
            {
                dgv = dgvHomeList;
            }
            else
            {
                dgv = dgvVisitList;
            }
            for (int i = 0; i < dgv.Rows.Count; i++)
            {
                if (dgv.Rows[i].Cells["F_Active"].Value.ToString() == "1")
                {
                    int iRegisterID = GVAR.Str2Int(dgv.Rows[i].Cells["F_RegisterID"].Value);
                    SetPlayerPlayTime(iRegisterID, iTeamPos);
                }
            }

            GVAR.g_ManageDB.SetTeamMemberInitTime(m_MatchID, iTeamPos, "0");
            ResetPlayerList(iTeamPos, ref dgv);
            NotifyMatchStatistics();
        }
        private void SetPlayerPlayTime(int iSelRegisterID, int iTeampos)
        {
            DataGridView dgv = new DataGridView();
            if (iTeampos == 1)
            {
                dgv = dgvHomeList;
            }
            else
            {
                dgv = dgvVisitList;
            }
            int iPlayerPlayTime = 0;
            
            for (int i = 0; i < dgv.Rows.Count; i++)
            {
                if (GVAR.Str2Int(dgv.Rows[i].Cells["F_RegisterID"].Value) == iSelRegisterID)
                {
                    if (dgv.Rows[i].Cells["F_Active"].Value.ToString() != "1")
                    {
                        return;
                    }
                    int iStartTime = GVAR.Str2Int(dgv.Rows[i].Cells["Time"].Value);
                    iPlayerPlayTime = Math.Abs(iStartTime);

                    if (m_CCurMatch.CurPeriod == GVAR.PERIOD_PSO)
                    {
                        UpdatePlayerPlayeTime(iTeampos, iSelRegisterID, 0);
                    }
                    else
                    {
                        UpdatePlayerPlayeTime(iTeampos, iSelRegisterID, iPlayerPlayTime);
                    }
                    GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iSelRegisterID, 1, "0");
                }
            }
        }

        private void dgvHomeList_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (Modetype.emMul_WhiteStat == m_emMode
                || Modetype.emMul_BlueStat == m_emMode
                || Modetype.emMul_DoubleTeamStat == m_emMode
                || Modetype.emMul_Monitor == m_emMode)
            {
                return;
            }
            if (e.Button == MouseButtons.Left)
            {
                if (e.RowIndex < 0)
                    return;
            
                if (dgvHomeList.SelectedRows.Count <= 0)
                    return;

                int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.CurPeriod);

                int iRegisterID;
                int iSelIndex = dgvHomeList.SelectedRows[0].Index;
                iRegisterID = GVAR.Str2Int(dgvHomeList.Rows[iSelIndex].Cells["F_RegisterID"].Value);

                if (iRegisterID <= 0)
                    return;

                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
          
                m_CCurAction.TeamPos = 1;
                m_CCurAction.ActionTime = GVAR.FormatTime(m_CCurMatch.MatchTime);
                m_CCurAction.RegisterID = iRegisterID;
                m_CCurAction.RegName = dgvHomeList.Rows[iSelIndex].Cells["Name"].Value.ToString();
                m_CCurAction.ShirtNo = dgvHomeList.Rows[iSelIndex].Cells["Bib"].Value.ToString();
                m_CCurAction.ActionType = EActionType.emPStat;
                m_CCurAction.ActionDetail1 = "0";

                if(GVAR.Str2Int(dgvHomeList.Rows[iSelIndex].Cells["F_Active"].Value.ToString())==1)
                {
                    m_CCurAction.ActionDetail3 = "23";//out
                    m_CCurAction.ActionDetailDes3 = btnOut.Text;
                    m_CCurAction.GetActionCode();
                }
                else
                {
                    m_CCurAction.ActionDetail3 = "22";//in
                    m_CCurAction.ActionDetailDes3 = btnIn.Text;
                    m_CCurAction.GetActionCode();
                }
                if (m_CCurAction.IsActionComplete())
                {
                    if (m_CCurAction.ActionDetail3 == "23")
                    {
                        if (!CheckValidOutPlayer())
                        {
                            m_CCurAction.Init();
                            UpdateUIActionInfo();
                            return;
                        }
                    }
                    else if (m_CCurAction.ActionDetail3 == "22")
                    {
                        if (!UpdateInPlayer())
                        {
                            m_CCurAction.Init();
                            UpdateUIActionInfo();
                            return;
                        }
                    }

                    int iOPGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, (3 - m_CCurAction.TeamPos));
                    m_CCurAction.CreateActionXml(m_CCurMatch, iOPGKID);
                    AddAction();

                    UpdateActionList(ref m_lstAction, -1, false);

                    if (m_CCurAction.ActionDetail3 == "23")
                    {
                        SetPlayerUnActive(m_CCurAction.RegisterID, m_CCurAction.TeamPos);

                    }

                    m_CCurAction.Init();
                    UpdateUIActionInfo();
                    NotifyMatchStatistics();

                    if (Modetype.emSingleMachine != m_emMode)
                    {
                        m_strStatisticTag = System.Environment.TickCount.ToString();
                        GVAR.g_ManageDB.UpdateMatchStatisticTagString(m_MatchID, m_strStatisticTag);
                    }
                }
            }
        }

        private void dgvVisitList_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (Modetype.emMul_WhiteStat == m_emMode
               || Modetype.emMul_BlueStat == m_emMode
               || Modetype.emMul_DoubleTeamStat == m_emMode
               || Modetype.emMul_Monitor == m_emMode)
            {
                return;
            }
            if (e.Button == MouseButtons.Left)
            {
                if (e.RowIndex < 0)
                    return;

                if (dgvVisitList.SelectedRows.Count <= 0)
                    return;

                int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.CurPeriod);

                int iRegisterID;
                int iSelIndex = dgvVisitList.SelectedRows[0].Index;
                iRegisterID = GVAR.Str2Int(dgvVisitList.Rows[iSelIndex].Cells["F_RegisterID"].Value);

                if (iRegisterID <= 0)
                    return;

                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);

                m_CCurAction.TeamPos = 2;
                m_CCurAction.ActionTime = GVAR.FormatTime(m_CCurMatch.MatchTime);
                m_CCurAction.RegisterID = iRegisterID;
                m_CCurAction.RegName = dgvVisitList.Rows[iSelIndex].Cells["Name"].Value.ToString();
                m_CCurAction.ShirtNo = dgvVisitList.Rows[iSelIndex].Cells["Bib"].Value.ToString();
                m_CCurAction.ActionType = EActionType.emPStat;
                m_CCurAction.ActionDetail1 = "0";

                if (GVAR.Str2Int(dgvVisitList.Rows[iSelIndex].Cells["F_Active"].Value.ToString()) == 1)
                {
                    m_CCurAction.ActionDetail3 = "23";//out
                    m_CCurAction.ActionDetailDes3 = btnOut.Text;
                    m_CCurAction.GetActionCode();
                }
                else
                {
                    m_CCurAction.ActionDetail3 = "22";//in
                    m_CCurAction.ActionDetailDes3 = btnIn.Text;
                    m_CCurAction.GetActionCode();
                }
                if (m_CCurAction.IsActionComplete())
                {
                    if (m_CCurAction.ActionDetail3 == "23")
                    {
                        if (!CheckValidOutPlayer())
                        {
                            m_CCurAction.Init();
                            UpdateUIActionInfo();
                            return;
                        }
                    }
                    else if (m_CCurAction.ActionDetail3 == "22")
                    {
                        if (!UpdateInPlayer())
                        {
                            m_CCurAction.Init();
                            UpdateUIActionInfo();
                            return;
                        }
                    }

                    int iOPGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, (3 - m_CCurAction.TeamPos));
                    m_CCurAction.CreateActionXml(m_CCurMatch, iOPGKID);
                    AddAction();

                    UpdateActionList(ref m_lstAction, -1, false);
                    if (m_CCurAction.ActionDetail3 == "23")
                    {
                        SetPlayerUnActive(m_CCurAction.RegisterID, m_CCurAction.TeamPos);

                    }

                    m_CCurAction.Init();
                    UpdateUIActionInfo();
                    NotifyMatchStatistics();

                    if (Modetype.emSingleMachine != m_emMode)
                    {
                        m_strStatisticTag = System.Environment.TickCount.ToString();
                        GVAR.g_ManageDB.UpdateMatchStatisticTagString(m_MatchID, m_strStatisticTag);
                    }
                }
            }
        }

        #region DML For Add Action

        /// <summary>
        /// 人员选择
        /// </summary>
        private void btnHActive_Click(object sender, EventArgs e)
        {
            ButtonX btn = (ButtonX)sender;
            string strbib = btn.Text;
            for (int i = 0; i < dgvHomeList.Rows.Count;i++ )
            {
                if (dgvHomeList.Rows[i].Cells["Bib"].Value.ToString() == strbib)
                {
                    dgvHomeList.Rows[i].Selected = true;
                    dgvHomeList_Click(null, null);
                }
            }
        }

        private void btnVActive_Click(object sender, EventArgs e)
        {
            ButtonX btn = (ButtonX)sender;
            string strbib = btn.Text;
            for (int i = 0; i < dgvVisitList.Rows.Count; i++)
            {
                if (dgvVisitList.Rows[i].Cells["Bib"].Value.ToString() == strbib)
                {
                    dgvVisitList.Rows[i].Selected = true;
                    dgvVisitList_Click(null, null);
                }
            }
        }

        private void btnActiveClick(ref DataGridView dgv, int iTeampos)
        {
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.CurPeriod);

            if (dgv.SelectedRows.Count <= 0)
                return;

            int iRegisterID;
            int iSelIndex = dgv.SelectedRows[0].Index;
            iRegisterID = GVAR.Str2Int(dgv.Rows[iSelIndex].Cells["F_RegisterID"].Value);

            if (iRegisterID <= 0)
            {
                m_CCurAction.Init();
                UpdateUIActionInfo();
                return;
            }

            if (m_CCurAction.IsNewAction())
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);

            }
            m_CCurAction.TeamPos = iTeampos;
            m_CCurAction.ActionTime = GVAR.FormatTime(m_CCurMatch.MatchTime);
            m_CCurAction.RegisterID = iRegisterID;
            m_CCurAction.RegName = dgv.Rows[iSelIndex].Cells["Name"].Value.ToString();
            m_CCurAction.Active = GVAR.Str2Int(dgv.Rows[iSelIndex].Cells["F_Active"].Value.ToString());
            m_CCurAction.ShirtNo = dgv.Rows[iSelIndex].Cells["Bib"].Value.ToString();

            if ((m_CCurAction.ActionDetail3 == "18" || m_CCurAction.ActionDetail3 == "19") && m_CCurAction.Active == -1)
            {
                m_CCurAction.ClearActionInfo();
            }

            UpdateUIActionInfo();
            if (m_CCurAction.IsActionComplete())
            {
                if (m_CCurAction.ActionDetail3 == "18" || m_CCurAction.ActionDetail3 == "19")
                {
                    if (m_CCurAction.TeamPos == 1)
                    {
                        m_CCurAction.RegisterID = m_CCurMatch.m_CHomeTeam.TeamID;
                        m_CCurAction.RegName = m_CCurMatch.m_CHomeTeam.TeamName;
                        m_CCurAction.ShirtNo = string.Empty;
                    }
                    else if (m_CCurAction.TeamPos == 2)
                    {
                        m_CCurAction.RegisterID = m_CCurMatch.m_CVisitTeam.TeamID;
                        m_CCurAction.RegName = m_CCurMatch.m_CVisitTeam.TeamName;
                        m_CCurAction.ShirtNo = string.Empty;
                    }
                }

                if (m_CCurAction.ActionDetail3 == "23")
                {
                    if (!CheckValidOutPlayer())
                    {
                        m_CCurAction.Init();
                        UpdateUIActionInfo();
                        return;
                    }
                }
                else if (m_CCurAction.ActionDetail3 == "22")
                {
                    if (!UpdateInPlayer())
                    {
                        m_CCurAction.Init();
                        UpdateUIActionInfo();
                        return;
                    }
                }
                int iOPGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, (3 - m_CCurAction.TeamPos));
                m_CCurAction.CreateActionXml(m_CCurMatch, iOPGKID);
                AddAction();

                UpdateActionList(ref m_lstAction, -1, false);
                if (m_CCurAction.ActionDetail3 == "23")
                {
                    SetPlayerUnActive(m_CCurAction.RegisterID, m_CCurAction.TeamPos);

                }
                string strActionkey = m_CCurAction.ActionKey;
                m_CCurAction.Init();
                UpdateUIActionInfo();
                NotifyMatchStatistics();


                if (Modetype.emMul_Admin == m_emMode
                    || Modetype.emMul_DoubleTeamStat == m_emMode
                    || Modetype.emSingleMachine == m_emMode)
                {
                    if (strActionkey == "15"
                        || strActionkey == "25"
                        || strActionkey == "35"
                        || strActionkey == "45"
                        || strActionkey == "65"
                        || strActionkey == "75")
                    {
                        //btnPlayerOtherActionClick(btnBlock, "10");
                    }
                }

                if (strActionkey == "11"
                       || strActionkey == "21"
                       || strActionkey == "31"
                       || strActionkey == "61")
                {
                    //btnPlayerOtherActionClick(btnAssist, "7");
                }

                if (Modetype.emSingleMachine != m_emMode)
                {
                    m_strStatisticTag = System.Environment.TickCount.ToString();
                    GVAR.g_ManageDB.UpdateMatchStatisticTagString(m_MatchID, m_strStatisticTag);
                }
            }
        }


        /// <summary>
        /// 射门类型处理
        /// </summary>
        private void btnActionShot_Click(object sender, EventArgs e)
        {
            btnShotClick(sender, "1");
        }

        private void btnCentreShot_Click(object sender, EventArgs e)
        {
            btnShotClick(sender, "2");
        }

        private void btnXShot_Click(object sender, EventArgs e)
        {
            btnShotClick(sender, "3");
        }

        private void btn5mShot_Click(object sender, EventArgs e)
        {
            btnShotClick(sender, "4");
        }

        private void btnPSShot_Click(object sender, EventArgs e)
        {
            btnShotClick(sender, "5");
        }

        private void btnCounterShot_Click(object sender, EventArgs e)
        {
            btnShotClick(sender, "6");
        }
        private void btnFreeThrow_Click(object sender, EventArgs e)
        {
            btnShotClick(sender, "7");
        }
        private void btnShotClick(object sender, string strActionDetail1)   //sendr:按钮类型， strActionDetail1：射门类型
        {
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.CurPeriod);

            ButtonX btn = (ButtonX)sender;

            if (m_CCurAction.IsNewAction())   //判断是否为新的Action
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            if (m_CCurAction.ActionDetail3.Length != 0)   //判读此Action是否记录了之前别的动作，与射门和进球无关的，则此Action不成功，需要重做            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            m_CCurAction.ActionType = EActionType.emShot;
            m_CCurAction.ActionTime = GVAR.FormatTime(m_CCurMatch.MatchTime);
            m_CCurAction.ActionDetail1 = strActionDetail1;
            m_CCurAction.GetActionCode();
            m_CCurAction.ActionDetailDes1 = btn.Text;

            UpdateUIActionInfo();
            if (m_CCurAction.IsActionComplete())
            {
                int iOPGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, (2 - m_CCurAction.TeamPos + 1));
                m_CCurAction.CreateActionXml(m_CCurMatch, iOPGKID);
                AddAction();

                UpdateActionList(ref m_lstAction, -1, false);
                string strActionKey = m_CCurAction.ActionKey;
                m_CCurAction.Init();
                UpdateUIActionInfo();
                GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);
                NotifyMatchStatistics();

                if (Modetype.emMul_Admin == m_emMode
                     || Modetype.emMul_DoubleTeamStat == m_emMode
                     || Modetype.emSingleMachine == m_emMode)
                {
                    if (strActionKey == "15"
                        || strActionKey == "25"
                        || strActionKey == "35"
                        || strActionKey == "45"
                        || strActionKey == "65"
                        || strActionKey == "75")
                    {
                        //btnPlayerOtherActionClick(btnBlock, "10");
                    }
                }

                if (strActionKey == "11"
                      || strActionKey == "21"
                      || strActionKey == "31"
                      || strActionKey == "61")
                {
                    //btnPlayerOtherActionClick(btnAssist, "7");
                }

                if (Modetype.emSingleMachine != m_emMode)
                {
                    m_strStatisticTag = System.Environment.TickCount.ToString();
                    GVAR.g_ManageDB.UpdateMatchStatisticTagString(m_MatchID, m_strStatisticTag);
                }
            }
        }

        private void btnGoal_Click(object sender, EventArgs e)
        {
            btnGoalClick(sender, "1");

        }
        private void btnSaved_Click(object sender, EventArgs e)
        {
            btnGoalClick(sender, "2");
        }

        private void btnMissed_Click(object sender, EventArgs e)
        {
            btnGoalClick(sender, "3");
        }

        private void btnPost_Click(object sender, EventArgs e)
        {
            btnGoalClick(sender, "4");
        }
        private void btnBlockShot_Click(object sender, EventArgs e)
        {
            btnGoalClick(sender, "5");
        }
        private void btnGoalClick(object sender, string strActionDetail2)  //strActionDetail2: 射门结果
        {
            int iSplitOrder = m_CCurMatch.CurPeriod;
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.CurPeriod);

            ButtonX btn = (ButtonX)sender;

            if (m_CCurAction.IsNewAction())
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            if (m_CCurAction.ActionDetail3.Length != 0)   //判读此Action是否记录了之前别的动作，与射门和进球无关的，则此Action不成功，需要重做            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            m_CCurAction.ActionType = EActionType.emShot;
            m_CCurAction.ActionTime = GVAR.FormatTime(m_CCurMatch.MatchTime);
            m_CCurAction.ActionDetail2 = strActionDetail2;
            m_CCurAction.GetActionCode();
            m_CCurAction.ActionDetailDes2 = btn.Text;

            UpdateUIActionInfo();
            if (m_CCurAction.IsActionComplete())
            {
                int iOPGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, (3 - m_CCurAction.TeamPos));
                m_CCurAction.CreateActionXml(m_CCurMatch, iOPGKID);
                AddAction();

                UpdateActionList(ref m_lstAction, -1, false);
                string strActionKey = m_CCurAction.ActionKey;
                m_CCurAction.Init();
                UpdateUIActionInfo();
                GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);
                NotifyMatchStatistics();
                if (Modetype.emMul_Admin == m_emMode
                    || Modetype.emMul_DoubleTeamStat == m_emMode
                    || Modetype.emSingleMachine == m_emMode)
                {
                    if (strActionKey == "15"
                        || strActionKey == "25"
                        || strActionKey == "35"
                        || strActionKey == "45"
                        || strActionKey == "65"
                        || strActionKey == "75")
                    {
                       // btnPlayerOtherActionClick(btnBlock, "10");
                    }
                }
                if (strActionKey == "11"
                     || strActionKey == "21"
                     || strActionKey == "31"
                     || strActionKey == "61")
                {
                    //btnPlayerOtherActionClick(btnAssist, "7");
                }
                if (Modetype.emSingleMachine != m_emMode)
                {
                    m_strStatisticTag = System.Environment.TickCount.ToString();
                    GVAR.g_ManageDB.UpdateMatchStatisticTagString(m_MatchID, m_strStatisticTag);
                }

            }
        }
        private bool IsPlayerAction(int iClassify) //0 UnActive 1 Active 2 Both
        {
            switch (iClassify)
            {
                case 0:
                    if (m_CCurAction.Active == 0)
                        return true;
                    else
                        return false;
                case 1:
                    if (m_CCurAction.Active == 1)
                        return true;
                    else
                        return false;
                case 2:
                    if (m_CCurAction.Active != -1)
                        return true;
                    else
                        return false;
            }
            return false;
        }


        /// <summary>
        /// 运动员其他Action
        /// </summary>
        private void btnAssist_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "7");
        }

        private void btnSteal_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "8");
        }

        private void btnTournOver_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "9");
        }

        private void btnBlock_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "10");
        }

        private void btnSpinWon_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "11");
        }

        private void btnSpinLost_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "12");
        }

        private void btn20C_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "13");
        }

        private void btn20F_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "14");
        }

        private void btnPenalty_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "15");
        }

        private void btnEXS_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "16");
        }

        private void btnEXN_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "17");
        }
        private void btnOut_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "23");
        }

        private void btnIn_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "22");
        }
        private void btnPlayerOtherActionClick(object sender, string strActionDetail3)  //其他动作
        {
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.CurPeriod);

            ButtonX btn = (ButtonX)sender;

            if (m_CCurAction.IsNewAction())
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            if ((m_CCurAction.ActionDetail1.Length != 0 && m_CCurAction.ActionDetail1 != "0") || m_CCurAction.ActionDetail2.Length != 0)   //判读此Action是否记录了之前别的动作，与射门和进球有关的，则此Action不成功，需要重做
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            m_CCurAction.ActionType = EActionType.emPStat;
            m_CCurAction.ActionTime = GVAR.FormatTime(m_CCurMatch.MatchTime);
            m_CCurAction.ActionDetail1 = "0";
            m_CCurAction.ActionDetail3 = strActionDetail3;
            m_CCurAction.GetActionCode();
            m_CCurAction.ActionDetailDes3 = btn.Text;

            if (strActionDetail3 == "22" && !IsPlayerAction(0) )
            {
                m_CCurAction.ClearPlayerInfo();
            }

            if (strActionDetail3 == "23" && !IsPlayerAction(1))
            {
               m_CCurAction.ClearPlayerInfo();
            }

            UpdateUIActionInfo();
            if (m_CCurAction.IsActionComplete())
            {
                if (strActionDetail3 == "23")
                {
                    if (!CheckValidOutPlayer())
                    {
                        m_CCurAction.Init();
                        UpdateUIActionInfo();
                        return;
                    }
                }
                else if (strActionDetail3 == "22")
                {
                    if (!UpdateInPlayer())
                    {
                        m_CCurAction.Init();
                        UpdateUIActionInfo();
                        return;
                    }
                }

                int iOPGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, (3 - m_CCurAction.TeamPos));
                m_CCurAction.CreateActionXml(m_CCurMatch, iOPGKID);
                AddAction();

                UpdateActionList(ref m_lstAction, -1, false);
                if (m_CCurAction.ActionDetail3 == "23")
                {
                    SetPlayerUnActive(m_CCurAction.RegisterID, m_CCurAction.TeamPos);

                }
                m_CCurAction.Init();
                UpdateUIActionInfo();
                NotifyMatchStatistics();

                if (Modetype.emSingleMachine != m_emMode)
                {
                    m_strStatisticTag = System.Environment.TickCount.ToString();
                    GVAR.g_ManageDB.UpdateMatchStatisticTagString(m_MatchID, m_strStatisticTag);
                }
            }
        }
        private bool HasGKOnField(int iTeamPos)
        {
            DataGridView dgv = new DataGridView();
            if (iTeamPos == 1)
            {
                dgv = dgvHomeList;
            }
            else
            {
                dgv = dgvVisitList;
            }
            for (int i = 0; i < dgv.Rows.Count; i++)
            {
                if (dgv.Rows[i].Cells["Position"].Value.ToString() == "GK"
                    && dgv.Rows[i].Cells["F_Active"].Value.ToString() == "1")
                {
                    return true;
                }
            }
            return false;
        }
        private bool UpdateInPlayer()
        {
            int iSelIndex;
            int iRegisterID;
            string strPosCode = string.Empty;
            if (m_iActiveTeamPos == 1)
            {
                if (dgvHomeList.SelectedRows.Count <= 0)
                    return false;
                iSelIndex = dgvHomeList.SelectedRows[0].Index;
                iRegisterID = GVAR.Str2Int(dgvHomeList.Rows[iSelIndex].Cells["F_RegisterID"].Value);
                strPosCode = dgvHomeList.Rows[iSelIndex].Cells["Position"].Value.ToString();
                if (dgvHomeList.Rows[iSelIndex].Cells["F_Active"].Value.ToString() == "1")
                    return false;
                if (strPosCode == "GK")
                {
                    if (HasGKOnField(m_iActiveTeamPos))
                    {
                        MessageBoxEx.Show("There is a goalkeeper on field already,you can not make another goalkeeper on field!");
                        return false;
                    }
                }

                
                if (!SetPlayerActive(iRegisterID, 1))
                {
                    return false;
                }
                return true;

            }
            else if (m_iActiveTeamPos == 2)
            {
                if (dgvVisitList.SelectedRows.Count <= 0)
                    return false;

                iSelIndex = dgvVisitList.SelectedRows[0].Index;
                iRegisterID = GVAR.Str2Int(dgvVisitList.Rows[iSelIndex].Cells["F_RegisterID"].Value);
                strPosCode = dgvVisitList.Rows[iSelIndex].Cells["Position"].Value.ToString();
                if (dgvVisitList.Rows[iSelIndex].Cells["F_Active"].Value.ToString() == "1")
                    return false;
                if (strPosCode == "GK")
                {
                    if (HasGKOnField(m_iActiveTeamPos))
                    {
                        MessageBoxEx.Show("There is a goalkeeper on field already,you can not make another goalkeeper on field!");
                        return false;
                    }
                }
                if (!SetPlayerActive(iRegisterID, 2))
                {
                    return false;
                }
                return true;
            }
            return false;
        }
        private bool CheckValidOutPlayer()
        {
            int iSelIndex;
            int iRegisterID;
            if (m_iActiveTeamPos == 1)
            {
                if (dgvHomeList.SelectedRows.Count <= 0)
                    return false;

                iSelIndex = dgvHomeList.SelectedRows[0].Index;
                iRegisterID = GVAR.Str2Int(dgvHomeList.Rows[iSelIndex].Cells["F_RegisterID"].Value);
                if (dgvHomeList.Rows[iSelIndex].Cells["F_Active"].Value.ToString() != "1")
                    return false;

                //if (!SetPlayerUnActive(iRegisterID, 1))
                //{
                //    return false;
                //}
                return true;
            }
            else if (m_iActiveTeamPos == 2)
            {
                if (dgvVisitList.SelectedRows.Count <= 0)
                    return false;

                iSelIndex = dgvVisitList.SelectedRows[0].Index;
                iRegisterID = GVAR.Str2Int(dgvVisitList.Rows[iSelIndex].Cells["F_RegisterID"].Value);
                if (dgvVisitList.Rows[iSelIndex].Cells["F_Active"].Value.ToString() != "1")
                    return false;
                //if (!SetPlayerUnActive(iRegisterID, 2))
                //{
                //    return false;
                //}
                return true;
            }
            return false;
        }
        private void btnTimeOut_Click(object sender, EventArgs e)
        {
            btnTeamActionClick(sender, "18");
        }
        private void btnCornerThrow_Click(object sender, EventArgs e)
        {
            btnTeamActionClick(sender, "19");
        }
        private void btnTeamActionClick(object sender, string strActionDetail3)  //strActionDetail3: 其他动作
        {
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.CurPeriod);

            ButtonX btn = (ButtonX)sender;

            if (m_CCurAction.IsNewAction())
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            if ((m_CCurAction.ActionDetail1.Length != 0 && m_CCurAction.ActionDetail1 != "0") || m_CCurAction.ActionDetail2.Length != 0)   //判读此Action是否记录了之前别的动作，与射门和进球有关的，则此Action不成功，需要重做
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            m_CCurAction.ActionType = EActionType.emTStat;
            m_CCurAction.ActionTime = GVAR.FormatTime(m_CCurMatch.MatchTime);
            m_CCurAction.ActionDetail1 = "0";
            m_CCurAction.ActionDetail3 = strActionDetail3;
            m_CCurAction.GetActionCode();
            m_CCurAction.ActionDetailDes3 = btn.Text;

            UpdateUIActionInfo();
            if (m_CCurAction.IsActionComplete())
            {
                if (m_CCurAction.TeamPos == 1)
                {
                    m_CCurAction.RegisterID = m_CCurMatch.m_CHomeTeam.TeamID;
                    m_CCurAction.RegName = m_CCurMatch.m_CHomeTeam.TeamName;
                    m_CCurAction.ShirtNo = string.Empty;
                }
                else if (m_CCurAction.TeamPos == 2)
                {
                    m_CCurAction.RegisterID = m_CCurMatch.m_CVisitTeam.TeamID;
                    m_CCurAction.RegName = m_CCurMatch.m_CVisitTeam.TeamName;
                    m_CCurAction.ShirtNo = string.Empty;
                }

                int iOPGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, (3 - m_CCurAction.TeamPos));
                m_CCurAction.CreateActionXml(m_CCurMatch, iOPGKID);
                AddAction();

                UpdateActionList(ref m_lstAction, -1, false);
                m_CCurAction.Init();
                UpdateUIActionInfo();
                NotifyMatchStatistics();
                if (Modetype.emSingleMachine != m_emMode)
                {
                    m_strStatisticTag = System.Environment.TickCount.ToString();
                    GVAR.g_ManageDB.UpdateMatchStatisticTagString(m_MatchID, m_strStatisticTag);
                }
            }
        }
        #endregion

        private void dgvAction_KeyDown(object sender, KeyEventArgs e)    //Delete键特殊处理        {
            if (m_CCurMatch.MatchStatus == GVAR.STATUS_FINISHED || m_CCurMatch.MatchStatus == GVAR.STATUS_SUSPEND)
            {
                e.Handled = true;
                return;
            }
            if (Modetype.emMul_Monitor == m_emMode)
            {
                return;
            }

            if (e.KeyCode == Keys.Delete)
            {
                if (dgvAction.SelectedRows.Count <= 0)
                {
                    return;
                }
                if (dgvAction.SelectedRows[0].Index >= 0)
                {
                    if (MessageBoxEx.Show("Are you sure to delete this action?", "", MessageBoxButtons.YesNo, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button2) == DialogResult.No)
                    {
                        e.Handled = true;
                        return;
                    }
                    int iActionID = GVAR.Str2Int(dgvAction.SelectedRows[0].Cells["F_ActionNumberID"].Value.ToString());
                    m_CCurAction = GetMatchActionFromActionID(iActionID);

                    DeleteAction();
                    UpdateActionList(ref m_lstAction, -1, false);
                    m_CCurAction.Init();
                    UpdateUIActionInfo();
                    NotifyMatchStatistics();

                    if (Modetype.emSingleMachine != m_emMode)
                    {
                        m_strStatisticTag = System.Environment.TickCount.ToString();
                        GVAR.g_ManageDB.UpdateMatchStatisticTagString(m_MatchID, m_strStatisticTag);
                    }

                }
            }
        }

        private OVRWPActionInfo GetMatchActionFromActionID(int iActionID)
        {
            for (int i = 0; i < m_lstAction.Count; i++)
            {
                if (m_lstAction.ElementAt(i).AcitonID == iActionID)
                {
                    return m_lstAction.ElementAt(i);
                }
            }
            return null;
        }

        private void btnMatchResult_Click(object sender, EventArgs e)
        {
            frmMatchResultEntry MatchResultEntry = new frmMatchResultEntry(GVAR.Str2Int(m_CCurMatch.MatchID));
            MatchResultEntry.ShowDialog();
            if (MatchResultEntry.DialogResult == DialogResult.No)
            {
                b_calculateRank = true;
            }
            else
            {
                b_calculateRank = false;
            }
        }

        private void btnPenaltyScore_Click(object sender, EventArgs e)
        {
            //frmOVRWPPenaltyScore PenaltyScoreFrm = new frmOVRWPPenaltyScore(ref m_CCurMatch);
            //PenaltyScoreFrm.ShowDialog();

            //UpdateUIForTeamScore();

            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iHomeRegID = m_CCurMatch.m_CHomeTeam.TeamID;
            int iVisitRegID = m_CCurMatch.m_CVisitTeam.TeamID;
            string strHomeName = m_CCurMatch.m_CHomeTeam.TeamName;
            string strVisitName = m_CCurMatch.m_CVisitTeam.TeamName;
            int iMatchPenaltySplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, GVAR.PERIOD_PSO);
            frmOVRWPPenaltyPlayer PenaltyMemberForm = new frmOVRWPPenaltyPlayer(iMatchID, iMatchPenaltySplitID, iHomeRegID, iVisitRegID, strHomeName, strVisitName);
            PenaltyMemberForm.ShowDialog();
        }

        /// <summary>
        /// 水温设定
        /// </summary>
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
            TextBoxX tb = (TextBoxX)sender;
            tb.Text = CheckInput(tb.Text);
            if (sender == homepossInput)
            {
                UpdateTeamStatic(1, "21", tb.Text);
            }
            else if (sender == visitpossInput)
            {
                UpdateTeamStatic(2, "21", tb.Text);
            }
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
            TextBox tbTime = (TextBox)sender;
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
                                tbTime.SelectionStart = strText.Length - iafter;
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

            if (sender == homePossTime)
            {
                UpdateTeamStatic(1, "20", GVAR.TranslateTimetoINT32(tb.Text).ToString());
            }
            else if (sender == visitPossTime)
            {
                UpdateTeamStatic(2, "20", GVAR.TranslateTimetoINT32(tb.Text).ToString());
            }
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
        private void NotifyMatchStatistics()
        {
            GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, m_MatchID, m_MatchID, null);
        }
        public void OPenUDP(int iUDPPort)
        {
            m_eReceiverType = ReceiverType.UDP;
            Label_SelectedPort.Text = iUDPPort.ToString();
            btn_start_receive_Click(null,null);
        }
        private void btn_start_receive_Click(object sender, EventArgs e)
        {
            switch (m_eReceiverType)
            {
                case ReceiverType.UDP:
                    try
                    {
                        if (m_CCurMatch.bRunTime)
                        {
                            btnStart_Click(null, null);
                        }
                        if (m_UDP != null)
                            m_UDP.Close();
                        m_UDP = new System.Net.Sockets.UdpClient(GVAR.Str2Int(Label_SelectedPort.Text));
                        m_UDP.DontFragment = true;
                        m_ParseUDPThread = new Thread(new ThreadStart(ParseUDPThread));
                        m_ParseUDPThread.IsBackground = true;
                        m_bParse = true;
                        m_ParseUDPThread.Start();

                        btn_start_receive.Enabled = false;
                        btn_stop_receive.Enabled = true;
                        comboBox_ConnectionType.Enabled = false;
                        btn_ReceiceSetting.Enabled = false;
                        EnablebtnStart(false);
                        EnableMatchTime(false);
                        return;
                    }
                    catch (Exception ex)
                    {
                        MessageBoxEx.Show(ex.Message);
                        ClearUDPThead();
                        return;
                    }
                    break;
                case ReceiverType.SerialPort:
                    try
                    {
                        if (m_CCurMatch.bRunTime)
                        {
                            btnStart_Click(null, null);
                        }
                        m_Serial.OpenSerial();
                        m_ParseThread = new Thread(new ThreadStart(ParseThread));
                        m_ParseThread.IsBackground = true;
                        m_bParse = true;
                        m_ParseThread.Start();
                        btn_start_receive.Enabled = false;
                        btn_stop_receive.Enabled = true;
                        comboBox_ConnectionType.Enabled = false;
                        btn_ReceiceSetting.Enabled = false;
                        EnablebtnStart(false);
                        EnableMatchTime(false);
                    }
                    catch (Exception)
                    {
                        GVAR.ExceptMsgShow(LocalizationRecourceManager.GetString(GVAR.g_WPPlugin.GetSectionName(), "SerialPortOpen_Error"));
                        ClearSerialThead();
                        return;
                    }
                    break;
                default:
                    break;
            }
        }
        private void btn_stop_receive_Click(object sender, EventArgs e)
        {
            switch (m_eReceiverType)
            {
                case ReceiverType.UDP:
                    m_bIsCloseThreadManuel = true;
                        ClearUDPThead();
                        btn_start_receive.Enabled = true;
                        btn_stop_receive.Enabled = false;
                        comboBox_ConnectionType.Enabled = true;
                        btn_ReceiceSetting.Enabled = true;
                        EnablebtnStart(true);
                        EnableMatchTime(true);
                    break;
                case ReceiverType.SerialPort:
                    try
                    {
                        ClearSerialThead();
                        btn_start_receive.Enabled = true;
                        btn_stop_receive.Enabled = false;
                        comboBox_ConnectionType.Enabled = true;
                        btn_ReceiceSetting.Enabled = true;
                        EnablebtnStart(true);
                        EnableMatchTime(true);
                    }
                    catch (Exception)
                    {

                    }
                    break;
                default:
                    break;
            }
        }

        private void btn_ReceiceSetting_Click(object sender, EventArgs e)
        {
            switch (m_eReceiverType)
            {
                case ReceiverType.UDP:
                    {
                        UDPConfigForm UDPConfig = new UDPConfigForm();
                        UDPConfig.StartPosition = FormStartPosition.Manual;
                        UDPConfig.UDP_Port.Text = "6666";
                        Point pt = btn_ReceiceSetting.PointToScreen(new Point(0, 0));
                        pt.X = pt.X - UDPConfig.Width + btn_ReceiceSetting.Width;
                        pt.Y = pt.Y - UDPConfig.Height;
                        UDPConfig.Location = pt;
                        UDPConfig.ShowDialog();
                        if (UDPConfig.DialogResult == DialogResult.OK)
                        {
                            Label_SelectedPort.Text = UDPConfig.UDP_Port.Text;
                            btn_start_receive.Enabled = true;
                            btn_stop_receive.Enabled = false;
                        }
                    }
                    break;
                case ReceiverType.SerialPort:
                    {
                        SerialConfigForm SerialConfig = new SerialConfigForm();
                        SerialConfig.StartPosition = FormStartPosition.Manual;
                        Point pt = btn_ReceiceSetting.PointToScreen(new Point(0, 0));
                        pt.X = pt.X - SerialConfig.Width + btn_ReceiceSetting.Width;
                        pt.Y = pt.Y - SerialConfig.Height;
                        SerialConfig.Location = pt;
                        SerialConfig.ShowDialog();
                        if (SerialConfig.DialogResult == DialogResult.OK)
                        {
                            m_Serial = new SerialPortReceiver();
                            m_Serial.m_SerialPort.PortName = SerialConfig.comboBox_COM_Port.SelectedItem.ToString();
                            if (m_Serial.m_SerialPort.IsOpen)
                            {
                                GVAR.ExceptMsgShow(LocalizationRecourceManager.GetString(GVAR.g_WPPlugin.GetSectionName(), "SerialPortOpen_Error"));
                                m_Serial = null;
                                return;
                            }
                            m_Serial.m_SerialPort.StopBits = (StopBits)SerialConfig.comboBox_Stopbits.SelectedItem;
                            m_Serial.m_SerialPort.DataBits = (int)SerialConfig.comboBox_Databits.SelectedItem;
                            m_Serial.m_SerialPort.Parity = (Parity)SerialConfig.comboBox_Parity.SelectedItem;
                            m_Serial.m_SerialPort.BaudRate = (int)SerialConfig.comboBox_Baudrate.SelectedItem;
                            Label_SelectedPort.Text = @m_Serial.m_SerialPort.PortName + " ("
                                              + m_Serial.m_SerialPort.BaudRate.ToString() + ','
                                              + m_Serial.m_SerialPort.DataBits.ToString() + ','
                                              + m_Serial.m_SerialPort.StopBits.ToString() + ','
                                              + m_Serial.m_SerialPort.Parity.ToString() + ")";

                            btn_start_receive.Enabled = true;
                            btn_stop_receive.Enabled = false;
                        }
                    }
                    break;
                default:
                    break;
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
        public void ParseThread()
        {
            try
            {
                bool bIsLast = false;
                string message = null;
                int nBufCount = GVAR.g_messagesQueue.Count;
                while (m_bParse || 0 != nBufCount)
                {
                    lock (GVAR.g_messageSignal)
                    {
                        nBufCount = GVAR.g_messagesQueue.Count;
                        if (0 != nBufCount)
                        {
                            message = GVAR.g_messagesQueue.Dequeue();
                            nBufCount = GVAR.g_messagesQueue.Count;
                            if (0 == nBufCount)
                            {
                                bIsLast = true;
                            }
                        }
                        else
                        {
                        }
                    }
                    if (m_bParse && !bIsLast && nBufCount == 0)
                    {
                        GVAR.g_SerialEvent.WaitOne();
                    }

                    lock (GVAR.g_messageSignal)
                    {
                        nBufCount = GVAR.g_messagesQueue.Count;
                    }
                    if (null == message)
                    {
                        continue;
                    }
                    m_CCurMatch.MatchTime = message;
                    SetTime(GVAR.TranslateINT32toTime(int.Parse(message)));
                    if (bIsLast == true)
                    {
                        bIsLast = false;
                    }
                    message = null;

                    lock (GVAR.g_messageSignal)
                    {
                        nBufCount = GVAR.g_messagesQueue.Count;
                    }
                }
            }
            catch (Exception e)
            {
                GVAR.ExceptMsgShow(e.Message);

                m_bParse = false;
                m_ParseThread = null;
                m_Serial.CloseSerial();
                m_Serial = null;
                //btn_start_receive.Enabled = true;
                //btn_stop_receive.Enabled = false;
                MyInvoke mi = new MyInvoke(this.UPdateUI);
                this.BeginInvoke(mi, new object[] { btn_start_receive, false });
                this.BeginInvoke(mi, new object[] { btn_stop_receive, false });
                ClearTextInvoke Ci = new ClearTextInvoke(this.ClearText);
                this.BeginInvoke(Ci, new object[] { Label_SelectedPort });
                System.Threading.Thread.CurrentThread.Abort();
            }
        }

        private void btnWeatherSet_Click(object sender, EventArgs e)
        {
            OVRWPWeatherConfig OVRWeatherConfigForm = new OVRWPWeatherConfig();
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            OVRWeatherConfigForm.MatchID = iMatchID;

            OVRWeatherConfigForm.ShowDialog();
            if (OVRWeatherConfigForm.DialogResult == DialogResult.OK)
            {
                GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emMatchWeather, -1, -1, -1, iMatchID, iMatchID, null);
            }
        }

        private void btnxExPathSel_Click(object sender, EventArgs e)
        {
            if (folderSelDlg.ShowDialog() == DialogResult.OK)
            {
                if (folderSelDlg.SelectedPath[(folderSelDlg.SelectedPath.Length - 1)] != '\\')
                {
                    tbExportPath.Text = folderSelDlg.SelectedPath + "\\";
                }
                else
                {
                    tbExportPath.Text = folderSelDlg.SelectedPath;
                }
            }
        }

        private void btn_Export_Click(object sender, EventArgs e)
        {
            string strLang = "ENG";
            string strResult = string.Empty;
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            strResult = GVAR.g_ManageDB.Get_TS_Athletes_Export(GVAR.g_strDisplnCode, strLang);
            ExportTable("Athletes_" + strLang, strResult);

            strResult = string.Empty;
            strResult= GVAR.g_ManageDB.Get_TS_Teams_Export(GVAR.g_strDisplnCode, strLang);
            ExportTable("Teams_" + strLang, strResult);

            strResult = string.Empty;
            strResult = GVAR.g_ManageDB.Get_TS_Schedule_Export(GVAR.g_strDisplnCode, strLang);
            ExportTable("Schedule_" + strLang, strResult);

            strLang = "CHN";
            strResult = string.Empty;
            strResult = GVAR.g_ManageDB.Get_TS_Athletes_Export(GVAR.g_strDisplnCode, strLang);
            ExportTable("Athletes_" + strLang, strResult);

          
            strResult = string.Empty;
            strResult = GVAR.g_ManageDB.Get_TS_Teams_Export(GVAR.g_strDisplnCode, strLang);
            ExportTable("Teams_" + strLang, strResult);

            strResult = string.Empty;
            strResult = GVAR.g_ManageDB.Get_TS_Schedule_Export(GVAR.g_strDisplnCode, strLang);
            ExportTable("Schedule_" + strLang, strResult);

        }
        private void ExportTable(string strTableName, string strResult)
        {
            string strExportFile = tbExportPath.Text + strTableName + ".xml";
            File.Delete(strExportFile);
            if (strResult.Length == 0)
            {
                return;
            }
            File.AppendAllText(strExportFile, strResult);
        }
        private void AppExit()
        {
            if (m_CCurMatch.MatchID == null || m_CCurMatch.MatchID.Length == 0)
                return;
            UpdateMatchTime();
        }
        private void MatchTime_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                e.Handled = true;
            }
        }
        private void Cell_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                e.Handled = true;
            }
        }
        private void dgvAction_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            cellEditingControl = (DataGridViewTextBoxEditingControl)(e.Control);
            cellEditingControl.KeyDown += new KeyEventHandler(Cell_KeyDown);
            cellEditingControl.KeyPress += new KeyPressEventHandler(tbTime_KeyPress);
        }

        private void dgvAction_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            cellEditingControl.KeyDown -= Cell_KeyDown;
            cellEditingControl.KeyPress -= tbTime_KeyPress;
            DataGridViewCell cell = (DataGridViewCell)(dgvAction[e.ColumnIndex, e.RowIndex]);
            if (cell.Value == null)
            {
                cell.Value = CheckInputTime(string.Empty);
            }
            else
            {
                cell.Value = CheckInputTime(cell.Value.ToString());
            }
            dgvAction.Columns[e.ColumnIndex].ReadOnly = true;
            if (m_strActionTime == cell.Value.ToString())
            {
                MultipleMachineTimer.Enabled = true;
                return;
            }

            int iActionID = GVAR.Str2Int(dgvAction.Rows[e.RowIndex].Cells["F_ActionNumberID"].Value.ToString());

            GVAR.g_ManageDB.UpdateActionTime(iActionID, GVAR.FormatTime(GVAR.TranslateTimetoINT32(cell.Value.ToString()).ToString()));

            OVRWPActionInfo CurAction = GetMatchActionFromActionID(iActionID);
            if (CurAction.ActionKey == "023" || CurAction.ActionKey == "022")
            {
                GVAR.g_ManageDB.UpdatePlayerPlayTime(m_MatchID, CurAction.TeamPos, CurAction.RegisterID, GVAR.strStat_PTime_Player);
            }
            //UpdateActionList(ref m_lstAction, -1);
            m_CCurAction.Init();
            UpdateUIActionInfo();
            NotifyMatchStatistics();
            if (Modetype.emSingleMachine != m_emMode)
            {
                m_strStatisticTag = System.Environment.TickCount.ToString();
                GVAR.g_ManageDB.UpdateMatchStatisticTagString(m_MatchID, m_strStatisticTag);
            }
            MultipleMachineTimer.Enabled = true;
        }

        private void dgvAction_CellLeave(object sender, DataGridViewCellEventArgs e)
        {
            if (dgvAction.Columns[e.ColumnIndex].HeaderText == "ActionTime")
            {
                dgvAction.Columns[e.ColumnIndex].ReadOnly = true;
            }
        }

        private void dgvAction_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (Modetype.emMul_Monitor == m_emMode)
            {
                return;
            }
            if (e.RowIndex>=0 && dgvAction.Columns[e.ColumnIndex].HeaderText == "ActionTime" && m_CCurMatch.MatchStatus != GVAR.STATUS_SUSPEND && m_CCurMatch.MatchStatus != GVAR.STATUS_FINISHED)
            {
                if (dgvAction.SelectedRows.Count <= 0)
                    return;

                if (dgvAction.SelectedRows[0].Index >= 0)
                {
                    int iActionID = GVAR.Str2Int(dgvAction.Rows[e.RowIndex].Cells["F_ActionNumberID"].Value.ToString());
                    int iSplitID = GetMatchActionFromActionID(iActionID).MatchSplitID;
                    if (GVAR.g_ManageDB.GetMatchPeriod(m_MatchID, iSplitID) == GVAR.PERIOD_PSO)
                    {
                        return;
                    }
                }
                dgvAction[e.ColumnIndex, e.RowIndex].ReadOnly = false;
                m_strActionTime = dgvAction[e.ColumnIndex, e.RowIndex].Value.ToString();
                MultipleMachineTimer.Enabled = false;
            }
            else
            {
                dgvAction.Columns[e.ColumnIndex].ReadOnly = true;
            }
        }

        private void dgvHomeList_Click(object sender, EventArgs e)
        {
            m_iActiveTeamPos = 1;
            btnActiveClick(ref dgvHomeList, 1);
        }

        private void dgvVisitList_Click(object sender, EventArgs e)
        {
            m_iActiveTeamPos = 2;
            btnActiveClick(ref dgvVisitList, 2);
        }

        private void btnClearAction_Click(object sender, EventArgs e)
        {
            m_CCurAction.Init();
            UpdateUIActionInfo();
        }

        private void comboBox_ConnectionType_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (comboBox_ConnectionType.SelectedValue.ToString())
            {
                case "0":
                    if (m_eReceiverType == ReceiverType.UDP)
                    {
                        return;
                    }
                    btn_start_receive.Enabled = false;
                    Label_SelectedPort.Text = String.Empty;
                    m_eReceiverType = ReceiverType.UDP;
                    if (m_Serial != null)
                    {
                        if (m_Serial.m_SerialPort.IsOpen)
                        {
                            m_Serial.CloseSerial();
                        }
                        m_Serial = null;
                    }
                   
                    break;
                case "1":
                    if (m_eReceiverType == ReceiverType.SerialPort)
                    {
                        return;
                    }
                    btn_start_receive.Enabled = false;
                    Label_SelectedPort.Text = String.Empty;
                    m_eReceiverType = ReceiverType.SerialPort;
                    if (m_Serial != null)
                    {
                        if (m_Serial.m_SerialPort.IsOpen)
                        {
                            m_Serial.CloseSerial();
                        }
                        m_Serial = null;
                    }
                    break;
            }
        }

        private void MultipleMachineTimer_Tick(object sender, EventArgs e)
        {
            GVAR.g_ManageDB.GetMatchTagStrings(m_MatchID);
            if (m_strStatisticTag != GVAR.m_TempstrStatisticTag)
            {
                 m_bStatictis = true;
                 m_strStatisticTag = GVAR.m_TempstrStatisticTag;
            }
         
            if ( m_strStatusTag != GVAR.m_TempstrStatusTag)
            {
                m_bStatus = true;
                  m_strStatusTag = GVAR.m_TempstrStatusTag;
            }

             if ( m_strPeriodTag != GVAR.m_TempstrPeriodTag)
            {
                m_bPeriod = true;
                  m_strPeriodTag = GVAR.m_TempstrPeriodTag;
            }

             if (m_strStaffTag != GVAR.m_TempstrStaffTag)
            {
                m_bStaff = true;
                 m_strStaffTag = GVAR.m_TempstrStaffTag;
            }

             if (m_strPointTag != GVAR.m_TempstrPointTag)
            {
                  m_bPoint = true;
                 m_strPointTag = GVAR.m_TempstrPointTag;
            }
             if (m_bStatictis || m_bStatus || m_bPeriod || m_bStaff || m_bPoint)
            {
                MultipleAutoUpdate();
            }

             m_bStatictis = m_bStatus = m_bPeriod = m_bStaff = m_bPoint = false;
        }

        private void dgvAction_MouseDown(object sender, MouseEventArgs e)
        {
            if (m_emMode != Modetype.emSingleMachine)
            {
                MultipleMachineTimer.Enabled = false;
            }
        }
        private void dgvAction_MouseUp(object sender, MouseEventArgs e)
        {
            if (m_emMode != Modetype.emSingleMachine)
            {
                MultipleMachineTimer.Enabled = true;
            }
        }
        private void dgvAction_MouseLeave(object sender, EventArgs e)
        {
            if (m_emMode != Modetype.emSingleMachine)
            {
                MultipleMachineTimer.Enabled = true;
            }
        }
       
    }
}
