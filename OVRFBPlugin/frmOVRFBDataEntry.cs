using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Collections;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using DevComponents.DotNetBar.Controls;
using AutoSports.OVRCommon;
namespace AutoSports.OVRFBPlugin
{
    public enum EOperatetype
    {
        emUnKnow = -1,   //未知
        emPoint = 0,     //只加分
        emStat = 1,     //只技术统计
        emMixed = 2,     //技术统计改比分
    }

    public partial class frmOVRFBDataEntry : Office2007Form
    {
        private string m_strSectionName = "OVRFBPlugin";
        private bool m_bUIChange;
        private EOperatetype m_emOperateType;
        private bool m_bAutoSendMessage = true;
        public OVRFBMatchInfo m_CCurMatch = new OVRFBMatchInfo();
        public int m_MatchID = -1;
        public List<OVRFBActionInfo> m_lstAction = new List<OVRFBActionInfo>();
        public OVRFBActionInfo m_CCurAction = new OVRFBActionInfo();
        public int m_iActiveTeamPos = 0;
        public int m_iInCount_Home;
        public int m_iInCount_Visit;
        public long m_dwCurSecCount;
        public long m_dwSumSec;	 //比赛累计秒数
        public string m_strActionTime = string.Empty;
        public bool bIsChanged = false;
        public DataGridViewTextBoxEditingControl cellEditingControl = null;
        public bool b_calculateRank = false;
        public frmOVRFBDataEntry()
        {
            InitializeComponent();

            m_CCurMatch.Init();
            m_emOperateType = EOperatetype.emMixed;
        }

        private void frmOVRFBDataEntry_Load(object sender, EventArgs e)
        {
            Localization();
            InitUI();

            EnableMatchBtn(false);
            EnalbeMatchCtrl(false);
            EnableScoreBtn(false);
            EnablePenaltyPeriod(false);
            InitStatusBtn();
            InitOperateType();
            tbExportPath.Text = "C:\\";

        }
        private void Localization()
        {
            this.lbHome.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbHome");
            this.lbVisit.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbVisit");
            this.lbSet1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSet1");
            this.lbSet2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSet2");
            this.lbExa1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbExa1");
            this.lbExa2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbExa2");

            this.btnStartPeriod.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStartPeriod");
            this.btnEndPeriod.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnEndPeriod");

            this.btnOfficial.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnOfficial");
            this.btnTeamInfo.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnTeamInfo");
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
            this.btn_Export.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btn_Export");
            this.btnWeatherSet.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnWeatherSet");
            this.btnCorner.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnCorner");
            this.btnOffside.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnOffside");

            this.btnShot.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnShot");
            this.btnFreeKick.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnFreeKick");
            this.btnPenalty.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnPenalty");

            this.btnGoal.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnGoal");
            this.btnMissed.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnMissed");
            this.btnCrossbar.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnCrossbar");
            this.btnBlock.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnBlock");
            this.btnOwnGoal.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnOwnGoal");

            this.btnYCard.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnYCard");
            this.btn2YCard.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btn2YCard");
            this.btnRCard.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnRCard");

            this.btnOut.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnOut");
            this.btnIn.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnIn");

            this.btnFoulS.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnFoulS");
            this.btnFoulC.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnFoulC");

            this.lbHomePossTime.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbHomePossTime");
            this.lbVisitPossTime.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbVisitPossTime");

            this.gbAttempt.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbAttempt");
            this.gbResult.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbResult");
            this.gbCards.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbCards");
            this.gbSubstitutions.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbSubstitutions");
            this.gbFouls.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbFouls");
            this.gbTeamPlay.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbTeamPlay");
            this.gbBallPossesion.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbBallPossesion");
            this.gbMatchScore.Text = LocalizationRecourceManager.GetString(m_strSectionName, "gbMatchScore");
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
        private void GetPeriodTime(int iMatchID)
        {  
            int Period1,  Period2,Period3,Period4;
            GVAR.g_ManageDB.GetMatchPeriodTime(m_MatchID, out Period1,out Period2,out Period3,out Period4);
            GVAR.MATCH_PERIOD1 = (Period1 * 60).ToString();
            GVAR.MATCH_PERIOD2 = (Period2 * 60).ToString();
            GVAR.MATCH_PERIOD3 = (Period3 * 60).ToString();
            GVAR.MATCH_PERIOD4 = (Period4 * 60).ToString();
        }
        private void OnMatchSelected(string strMatchID)
        {
            if (GVAR.g_FBPlugin == null)
                return;
            if (strMatchID == m_CCurMatch.MatchID)
                return;
            if (m_CCurMatch.MatchID.Trim().Length != 0)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "mbExit"));
                return;
            }
           
            GVAR.g_ManageDB.GetActiveSportInfo();

            m_CCurMatch.MatchID = strMatchID.ToString();
            m_MatchID = GVAR.Str2Int(strMatchID);

            GetPeriodTime(m_MatchID);

            // Update Report Context
            GVAR.g_FBPlugin.SetReportContext("MatchID", strMatchID);

            // Load Match Data
            GVAR.g_ManageDB.GetMatchInfo(m_MatchID, ref m_CCurMatch);

            if (m_CCurMatch.MatchStatus >= GVAR.STATUS_RUNNING && m_CCurMatch.MatchStatus <= GVAR.STATUS_UNOFFICIAL)
            {
                string strtemp = LocalizationRecourceManager.GetString(m_strSectionName, "MatchStatusWarning");
                if (MessageBox.Show(strtemp, "", MessageBoxButtons.YesNo, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button2) == DialogResult.No)
                {
                    m_CCurMatch.Init();
                    return;
                }
            }
            //////////////////////////////////////////
            if (m_CCurMatch.MatchStatus == GVAR.STATUS_SCHEDULE || m_CCurMatch.MatchStatus == GVAR.STATUS_ON_COURT)
            {
                if (m_CCurMatch.MatchType == GVAR.MATCH_COMMON)
                {
                    m_CCurMatch.Period = GVAR.PERIOD_1stHalf;
                    GVAR.g_ManageDB.InitMatchSplit(ref m_CCurMatch, 2);
                    GVAR.g_ManageDB.UpdateMatchPeriod(ref m_CCurMatch);

                    //m_CCurMatch.m_CHomeTeam.SetScore("0", GVAR.PERIOD_1stHalf);
                    //m_CCurMatch.m_CVisitTeam.SetScore("0", GVAR.PERIOD_1stHalf);
                    //GVAR.g_ManageDB.UpdateTeamSetPt(ref m_CCurMatch);
                    //if (m_CCurMatch.MatchStauts == GVAR.STATUS_RUNNING || m_CCurMatch.MatchStauts == GVAR.STATUS_UNOFFICIAL || m_CCurMatch.MatchStauts == GVAR.STATUS_REVISION)
                    //{
                    //    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "Msg_MatchStatus"));
                    //    m_CCurMatch.Init();

                    //    return;
                    //}
                }
                else if (m_CCurMatch.MatchType == GVAR.MATCH_PENALTY)
                {
                    m_CCurMatch.Period = GVAR.PERIOD_PenaltyShoot;
                    GVAR.g_ManageDB.InitMatchSplit(ref m_CCurMatch, 1);
                    GVAR.g_ManageDB.UpdateMatchPeriod(ref m_CCurMatch);

                    //m_CCurMatch.m_CHomeTeam.SetScore("0", GVAR.PERIOD_PenaltyShoot);
                    //m_CCurMatch.m_CVisitTeam.SetScore("0", GVAR.PERIOD_PenaltyShoot);
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

                GVAR.g_ManageDB.SetTeamMemberCount(GVAR.Str2Int(strMatchID), 1,20);
                GVAR.g_ManageDB.SetTeamMemberCount(GVAR.Str2Int(strMatchID), 2,20);
                SetTeamInitTime();
            }

            if (m_CCurMatch.MatchStatus > GVAR.STATUS_SCHEDULE)
            {

                GVAR.g_ManageDB.GetTeamDetailInfo(m_MatchID, ref m_CCurMatch.m_CHomeTeam);
                GVAR.g_ManageDB.GetTeamDetailInfo(m_MatchID, ref m_CCurMatch.m_CVisitTeam);
                GVAR.g_ManageDB.GetMatchActionList(m_MatchID, ref m_lstAction);
            }
            m_iInCount_Home = GVAR.g_ManageDB.GetTeamMemberCount(GVAR.Str2Int(strMatchID), 1);
            m_iInCount_Visit = GVAR.g_ManageDB.GetTeamMemberCount(GVAR.Str2Int(strMatchID), 2);
            EnableMatchBtn(true);
            InitMatchInfo();
            m_bAutoSendMessage = false;
            UpdateMatchStatus();
            m_bAutoSendMessage = true;
            UpdateActionList(ref m_lstAction, -1);
            GetPossStat();
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
            frmOVRFBOfficialEntry OfficialForm = new frmOVRFBOfficialEntry(iMatchID);
            OfficialForm.ShowDialog();

            GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchOfficials, -1, -1, -1, iMatchID, iMatchID, null);
        }
        public void SetTeamInitTime()
        {
            GVAR.g_ManageDB.SetActiveMember(m_MatchID,1);
            GVAR.g_ManageDB.SetActiveMember(m_MatchID,2);
            GVAR.g_ManageDB.SetTeamMemberInitTime(m_MatchID, 1, "0");
            GVAR.g_ManageDB.SetTeamMemberInitTime(m_MatchID, 2, "0");
        }
        private void btnTeamInfo_Click(object sender, EventArgs e)
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iHomeRegID = m_CCurMatch.m_CHomeTeam.TeamID;
            int iVisitRegID = m_CCurMatch.m_CVisitTeam.TeamID;
            string strHomeName = m_CCurMatch.m_CHomeTeam.TeamName;
            string strVisitName = m_CCurMatch.m_CVisitTeam.TeamName;

            frmOVRFBTeamMemberEntry MatchMemberForm = new frmOVRFBTeamMemberEntry(iMatchID, iHomeRegID, iVisitRegID, strHomeName, strVisitName);
            MatchMemberForm.ShowDialog();

            int iPeriodID = 0;
            GVAR.g_ManageDB.GetMatchPeriodSetting(iMatchID, ref iPeriodID);
            GVAR.g_MatchPeriodSet = iPeriodID;
            if (m_CCurMatch.MatchStatus <= GVAR.STATUS_ON_COURT)
            {
                SetTeamInitTime();
            }
            ResetPlayerList(1, ref dgvHomeList);
            ResetPlayerList(2, ref dgvVisitList);
            GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchCompetitorMember, -1, -1, -1, iMatchID, iMatchID, null);
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
                    timerSplit.Enabled = false;
                }
                EnableMatchBtn(false);
                EnalbeMatchCtrl(false);
                EnableScoreBtn(false);
                EnablePenaltyPeriod(false);

                GVAR.g_ManageDB.UpdateMatchTime(m_MatchID, m_CCurMatch.MatchTime);

                m_CCurMatch.Init();
                m_CCurAction.Init();
                UpdateUIActionInfo();
                InitMatchInfo();
                InitStatusBtn();
                dgvHomeList.Rows.Clear();
                dgvVisitList.Rows.Clear();
                m_lstAction.Clear();
                UpdateActionList(ref m_lstAction, -1);
            }
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
            int iResult = OVRDataBaseUtils.ChangeMatchStatus(GVAR.Str2Int(m_CCurMatch.MatchID), m_CCurMatch.MatchStatus, GVAR.g_sqlConn, GVAR.g_FBPlugin);
            GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatus, -1, -1, -1, m_MatchID, m_MatchID, null);
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
                iResult = m_CCurMatch.ChangePoint(1, true, 1, m_CCurMatch.Period);
            }
            else if (sender == btnVPt_Add)
            {
                iResult = m_CCurMatch.ChangePoint(2, true, 1, m_CCurMatch.Period);
            }
            else if (sender == btnHPt_Sub)
            {
                iResult = m_CCurMatch.ChangePoint(1, false, 1, m_CCurMatch.Period);
            }
            else if (sender == btnVPt_Sub)
            {
                iResult = m_CCurMatch.ChangePoint(2, false, 1, m_CCurMatch.Period);
            }

            if (iResult == 1)
            {
                GVAR.g_ManageDB.UpdateTeamSetPt(ref m_CCurMatch,m_CCurMatch.Period);
                GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);
            }

            UpdateUIForTeamScore();
            GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);
        }

        private void lbPeriod_TextChanged(object sender, EventArgs e)
        {
            lbSet1.ForeColor = System.Drawing.Color.Black;
            lbSet2.ForeColor = System.Drawing.Color.Black;
            lbExa1.ForeColor = System.Drawing.Color.Black;
            lbExa2.ForeColor = System.Drawing.Color.Black;
            lbPSO.ForeColor = System.Drawing.Color.Black;
            switch (m_CCurMatch.Period)
            {
                case GVAR.PERIOD_1stHalf:
                    lbSet1.ForeColor = System.Drawing.Color.Red;
                    break;
                case GVAR.PERIOD_2ndHalf:
                    lbSet2.ForeColor = System.Drawing.Color.Red;
                    break;
                case GVAR.PERIOD_1stExtraHalf:
                    lbExa1.ForeColor = System.Drawing.Color.Red;
                    break;
                case GVAR.PERIOD_2ndExtraHalf:
                    lbExa2.ForeColor = System.Drawing.Color.Red;
                    break;
                case GVAR.PERIOD_PenaltyShoot:
                    lbPSO.ForeColor = System.Drawing.Color.Red;
                    break;
                default:
                    break;
            }
        }

        private void btnNext_Click(object sender, EventArgs e)
        {
            OnBtnChangePeriod(true);
        }

        private void btnPrevious_Click(object sender, EventArgs e)
        {
            OnBtnChangePeriod(false);
        }
        private void UpdatePreviousBtnStat()
        {
            if (m_CCurMatch.Period == GVAR.PERIOD_1stHalf)
            {
                btnPrevious.Enabled = false;
            }
            else
            {
                btnPrevious.Enabled = true;
            }
        }
        private int GetSetScore(bool iHomeTeam, int iSet)
        {
            string strSetScore = string.Empty;
            if (iHomeTeam)
            {
                strSetScore = m_CCurMatch.m_CHomeTeam.GetScore(iSet);
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
        private int SumPeriodsGoals(bool iHomeTeam, int iSetCount)
        {
            int iSum = 0;
            int i = GVAR.PERIOD_1stHalf;
            while (i <= iSetCount)
            {
                iSum += GetSetScore(iHomeTeam, i);
                i++;
            };
            return iSum;
        }
        private void UpdateNextBtnStat()
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);
            int iSplitStatus = GVAR.g_ManageDB.GetSplitStatusID(iMatchID, iMatchSplitID);
            if (iSplitStatus == GVAR.STATUS_FINISHED)
            {
                if (m_CCurMatch.Period == GVAR.PERIOD_PenaltyShoot)
                {
                    btnNext.Enabled = false;
                    return;
                }

                if (m_CCurMatch.bPoolMatch)
                {
                    if (m_CCurMatch.Period == GVAR.PERIOD_2ndHalf)
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

                if (m_CCurMatch.Period == GVAR.PERIOD_2ndHalf)
                {
                    if (SumPeriodsGoals(true, 2) != SumPeriodsGoals(false, 2))
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
                else if (m_CCurMatch.Period == GVAR.PERIOD_2ndExtraHalf)
                {
                    if (SumPeriodsGoals(true, 4) != SumPeriodsGoals(false, 4))
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
            int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);
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
            if (m_CCurMatch.Period == GVAR.PERIOD_PenaltyShoot)
            {
                lbHomePossTime.Enabled = false;
                lbVisitPossTime.Enabled = false;
                homePossTime.Enabled = false;
                visitPossTime.Enabled = false;
                tbAddTime.Enabled = false;
            }
            else
            {
                lbHomePossTime.Enabled = true;
                lbVisitPossTime.Enabled = true;
                homePossTime.Enabled = true;
                visitPossTime.Enabled = true;
                tbAddTime.Enabled = true;
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
                timerSplit.Enabled = false;
            }
            m_CCurMatch.InitTime();
            int iMatchTime = m_CCurMatch.MatchTime.Trim().Length == 0 ? 0 : int.Parse(m_CCurMatch.MatchTime.Trim());
            MatchTime.Text = GVAR.TranslateINT32toTime(iMatchTime);
        }

        private void btnStart_Click(object sender, EventArgs e)
        {
            if (!m_CCurMatch.bRunTime)
            {
                m_CCurMatch.bRunTime = true;
                btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStop");

                timerSplit.Enabled = true;
                if (m_CCurMatch.MatchTime.Length == 0)
                {
                    m_CCurMatch.InitTime();
                }
                m_dwCurSecCount = System.Environment.TickCount / 1000;
                m_dwSumSec = GVAR.Str2Int(m_CCurMatch.MatchTime);
            }
            else
            {
                m_CCurMatch.bRunTime = false;
                btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStart");
                timerSplit.Enabled = false;
                m_dwSumSec += System.Environment.TickCount / 1000 - m_dwCurSecCount;
                m_CCurMatch.MatchTime = m_dwSumSec.ToString();
            }
        }


        private void UpdateMatchTime(object sender, EventArgs e)
        {
            long dwSecSpan;
            dwSecSpan = System.Environment.TickCount / 1000 - m_dwCurSecCount + m_dwSumSec;
            m_CCurMatch.MatchTime = dwSecSpan.ToString();
            m_bUIChange = false;
            MatchTime.Text = GVAR.TranslateINT32toTime(dwSecSpan);
            m_bUIChange = true;
        }


        private void btnOut_Click(object sender, EventArgs e)
        {
             btnPlayerOtherActionClick(sender, "13");
        }

        private bool UpdateOutPlayer()
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
                if (m_CCurAction.ActionCode == GVAR.strAction_2YCard || m_CCurAction.ActionCode == GVAR.strAction_RCard)   //当比赛中有人两张黄牌或者一张红牌，该对的场上人数减一
                {
                    m_iInCount_Home--;
                    GVAR.g_ManageDB.SetTeamMemberCount(m_MatchID, m_CCurAction.TeamPos, m_iInCount_Home);
                }
                NotifyMatchStatistics();
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
                if (m_CCurAction.ActionCode == GVAR.strAction_2YCard || m_CCurAction.ActionCode == GVAR.strAction_RCard)   //当比赛中有人两张黄牌或者一张红牌，该对的场上人数减一
                {
                    m_iInCount_Visit--;
                    GVAR.g_ManageDB.SetTeamMemberCount(m_MatchID, m_CCurAction.TeamPos, m_iInCount_Visit);
                }
                NotifyMatchStatistics();
                return true;
            }
            return false;
        }

        private void btnIn_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "12");
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
                NotifyMatchStatistics();
                return true;

            }
            else if (m_iActiveTeamPos == 2)
            {
                if (dgvVisitList.SelectedRows.Count <= 0)
                    return false;

                iSelIndex = dgvVisitList.SelectedRows[0].Index;
                iRegisterID = GVAR.Str2Int(dgvVisitList.Rows[iSelIndex].Cells["F_RegisterID"].Value);
                strPosCode = dgvVisitList.Rows[iSelIndex].Cells["Position"].Value.ToString();
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
                NotifyMatchStatistics();
                return true;
            }
            return false;
        }

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

            ResetPlayerList(iTeamPos, ref dgv);
            NotifyMatchStatistics();
        }
       
        #region DML For Add Action 
        
        /// <summary>
        /// 人员选择
        /// </summary>
        /// 
        private void dgvHomeList_Click(object sender, EventArgs e)
        {
            m_iActiveTeamPos = 1;         
            btnActiveClick(ref dgvHomeList,1);
        }

        private void dgvVisitList_Click(object sender, EventArgs e)
        {
            m_iActiveTeamPos = 2;

            btnActiveClick(ref dgvVisitList, 2);
        }        

        private void btnActiveClick(ref DataGridView dgv, int iTeampos)
        {
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.Period);

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
            m_CCurAction.ActionTime = GetActionTime();
            m_CCurAction.RegisterID = iRegisterID;
            m_CCurAction.RegName =  dgv.Rows[iSelIndex].Cells["Name"].Value.ToString();
            m_CCurAction.Active = GVAR.Str2Int(dgv.Rows[iSelIndex].Cells["F_Active"].Value.ToString());
            m_CCurAction.ShirtNo = dgv.Rows[iSelIndex].Cells["Bib"].Value.ToString();

            if (m_CCurAction.ActionDetail2.Length != 0||(m_CCurAction.ActionDetail1.Length != 0&&m_CCurAction.ActionDetail1 !="0"))//射门动作和结果
            {
                if (m_CCurAction.Active != 1)
                {
                    m_CCurAction.ClearActionInfo();
                }
            }

            if (m_CCurAction.ActionDetail3.Length != 0)
            {
                 if ((m_CCurAction.ActionDetail3 == "12" && m_CCurAction.Active != 0)
                     ||(m_CCurAction.ActionDetail3 == "13" && m_CCurAction.Active != 1)
                     ||(m_CCurAction.ActionDetail3 !="5"&&m_CCurAction.ActionDetail3!="6"&&m_CCurAction.ActionDetail3!="7"&& m_CCurAction.Active != 1))
                 {
                     m_CCurAction.ClearActionInfo();
                 }
            }
         
            UpdateUIActionInfo();
            if (m_CCurAction.IsActionComplete())
            {
                if (m_CCurAction.ActionKey == "05")
                {
                    if (FindYellowCard(m_CCurAction.RegisterID))
                    {
                        MessageBox.Show(LocalizationRecourceManager.GetString(m_strSectionName, "YCardWarn"));
                        m_CCurAction.Init();
                        UpdateUIActionInfo();
                        return;
                    }
                }
                if (m_CCurAction.ActionKey == "06")
                {
                    if (!FindYellowCard(m_CCurAction.RegisterID))
                    {
                        MessageBox.Show(LocalizationRecourceManager.GetString(m_strSectionName, "Y2CardWarn"));
                        m_CCurAction.Init();
                        UpdateUIActionInfo();
                        return;
                    }
                }
                //if (m_CCurAction.ActionKey == "08" || m_CCurAction.ActionKey == "09")
                //{
                //    if (m_CCurAction.TeamPos == 1)
                //    {
                //    m_CCurAction.RegisterID = m_CCurMatch.m_CHomeTeam.TeamID;
                //    m_CCurAction.RegName = m_CCurMatch.m_CHomeTeam.TeamName;
                //    m_CCurAction.ShirtNo = string.Empty;
                //    }
                //    else if (m_CCurAction.TeamPos == 2)
                //    {
                //    m_CCurAction.RegisterID = m_CCurMatch.m_CVisitTeam.TeamID;
                //    m_CCurAction.RegName = m_CCurMatch.m_CVisitTeam.TeamName;
                //    m_CCurAction.ShirtNo = string.Empty;
                //    }
                //}
                if (m_CCurAction.ActionKey == "013")
                {
                    if (!UpdateOutPlayer())
                    {
                        m_CCurAction.Init();
                        UpdateUIActionInfo();
                        return;
                    }
                }
                
                if (m_CCurAction.ActionKey == "012")
                {
                    if (!UpdateInPlayer())
                    {
                        m_CCurAction.Init();
                        UpdateUIActionInfo();
                        return;
                    }
                }

                int iOPGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, (3-m_CCurAction.TeamPos));
                if (m_CCurAction.ActionCode == "OwnGoal")
                {
                    iOPGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, m_CCurAction.TeamPos);
                }
                m_CCurAction.CreateActionXml(m_CCurMatch, iOPGKID);
                AddAction();

                if (m_CCurAction.ActionKey == "06" || m_CCurAction.ActionKey == "07")
                {
                    m_CCurAction.AcitonID = -1;
                   btnPlayerOtherActionClick(btnOut,"13");
                }

                GVAR.g_ManageDB.GetMatchActionList(m_MatchID, ref m_lstAction);
                UpdateActionList(ref m_lstAction, - 1);

                if (m_CCurAction.ActionKey == "013")
                {
                    SetPlayerUnActive(m_CCurAction.RegisterID, m_CCurAction.TeamPos);

                }

                string strActionDetail3 = m_CCurAction.ActionDetail3;
                m_CCurAction.Init();
                UpdateUIActionInfo();
                NotifyMatchStatistics();

                if (strActionDetail3 == "10")
                {
                    btnPlayerOtherActionClick(btnFoulS, "11");
                }
                if (strActionDetail3 == "11")
                {
                    btnPlayerOtherActionClick(btnFoulC, "10");
                }
            }
        }

       
        /// <summary>
        /// 射门类型处理
        /// </summary>
        /// 
        private void btnShot_Click(object sender, EventArgs e)
        {
            btnShotClick(sender, "1");
        }

        private void btnFreeKick_Click(object sender, EventArgs e)
        {
            btnShotClick(sender, "3");
        }

        private void btnPenalty_Click_1(object sender, EventArgs e)
        {
            btnShotClick(sender, "2");
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
        private void btnShotClick(object sender, string strActionDetail1)   //sendr:按钮类型， strActionDetail1：射门类型        {
         
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.Period);

            ButtonX btn = (ButtonX)sender;

            if (m_CCurAction.IsNewAction())   //判断是否为新的Action
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            if (m_CCurAction.ActionDetail3.Length != 0 || (m_CCurAction.ActionKey == "4" && m_CCurAction.ActionDetail1 =="0"))   //判读此Action是否记录了之前别的动作，与射门和进球无关的，则此Action不成功，需要重做           {

               m_CCurAction.Init();
               m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            m_CCurAction.ActionType = EActionType.emShot;
            m_CCurAction.ActionTime = GetActionTime();
            m_CCurAction.ActionDetail1 = strActionDetail1;
            m_CCurAction.GetActionCode();
            m_CCurAction.ActionDetailDes1 = btn.Text;

            if (!IsPlayerAction(1))
            {
                m_CCurAction.ClearPlayerInfo();
            }
            UpdateUIActionInfo();
            if (m_CCurAction.IsActionComplete())
            {
                int iOPGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, (2 - m_CCurAction.TeamPos + 1));
                m_CCurAction.CreateActionXml(m_CCurMatch, iOPGKID);
                AddAction();

                GVAR.g_ManageDB.GetMatchActionList(m_MatchID, ref m_lstAction);
                UpdateActionList(ref m_lstAction, - 1);
                m_CCurAction.Init();
                UpdateUIActionInfo();
                GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);
                NotifyMatchStatistics();
            }
        }

        #region 射门结果处理

        private void btnGoal_Click(object sender, EventArgs e)
        {
            btnGoalClick(sender, "1");
        }

        private void btnMissed_Click(object sender, EventArgs e)
        {
            btnGoalClick(sender, "4");
        }

        private void btnBlock_Click(object sender, EventArgs e)
        {
            btnGoalClick(sender, "2");
        }

        private void btnCrossbar_Click(object sender, EventArgs e)
        {
            btnGoalClick(sender, "3");
        }

        private void btnGoalClick(object sender, string strActionDetail2)  //strActionDetail2: 射门结果
        {
            int iSplitOrder = m_CCurMatch.Period;
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.Period);

            ButtonX btn = (ButtonX)sender;

            if (m_CCurAction.IsNewAction())
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            if (m_CCurAction.ActionDetail3.Length != 0 || (m_CCurAction.ActionDetail2 == "4" && m_CCurAction.ActionDetail1 == "0"))   //判读此Action是否记录了之前别的动作，与射门和进球无关的，则此Action不成功，需要重做            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            m_CCurAction.ActionType = EActionType.emShot;
            m_CCurAction.ActionTime = GetActionTime();
            m_CCurAction.ActionDetail2 = strActionDetail2;
            m_CCurAction.GetActionCode();
            m_CCurAction.ActionDetailDes2 = btn.Text;

            if (!IsPlayerAction(1))
            {
                m_CCurAction.ClearPlayerInfo();
            }
            UpdateUIActionInfo();
            if (m_CCurAction.IsActionComplete())
            {
                int iOPGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, (3 - m_CCurAction.TeamPos));
                m_CCurAction.CreateActionXml(m_CCurMatch, iOPGKID);
                AddAction();

                GVAR.g_ManageDB.GetMatchActionList(m_MatchID, ref m_lstAction);
                UpdateActionList(ref m_lstAction,  - 1);
                m_CCurAction.Init();
                UpdateUIActionInfo();
                GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);
                NotifyMatchStatistics();
            }
        }

        /// <summary>
        /// 乌龙球
        /// </summary>
        private void btnOwnGoal_Click(object sender, EventArgs e)
        {
            int iSplitOrder = m_CCurMatch.Period;
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.Period);

            ButtonX btn = (ButtonX)sender;

            if (m_CCurAction.IsNewAction())
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            if (m_CCurAction.ActionDetail3.Length != 0 || (m_CCurAction.ActionDetail1.Length != 0 && m_CCurAction.ActionDetail1 != "0"))   //判读此Action是否记录了之前别的动作，与射门和进球无关的，则此Action不成功，需要重做            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            m_CCurAction.ActionType = EActionType.emShot;
            m_CCurAction.ActionTime = GetActionTime();
            m_CCurAction.ActionDetail1 = "0";
            m_CCurAction.ActionDetail2 = "4";
            m_CCurAction.GetActionCode();
            m_CCurAction.ActionDetailDes2 = btn.Text;
            if (!IsPlayerAction(1))
            {
                m_CCurAction.ClearPlayerInfo();
            }
            UpdateUIActionInfo();
            if (m_CCurAction.IsActionComplete())
            {
                int iGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, m_CCurAction.TeamPos);
                m_CCurAction.CreateActionXml(m_CCurMatch, iGKID);
                AddAction();

                GVAR.g_ManageDB.GetMatchActionList(m_MatchID, ref m_lstAction);
                UpdateActionList(ref m_lstAction, -1);
                m_CCurAction.Init();
                UpdateUIActionInfo();
                GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);
                NotifyMatchStatistics();
            }
        }

        #endregion

        private void btnYCard_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "5");
        }

        private void btn2YCard_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "6");
        }

        private void btnRCard_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "7");
        }

        /// <summary>
        /// 被犯规
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnFoulS_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "11");
        }

        /// <summary>
        /// 主动犯规
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnFoulC_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "10");
        }
        //private void btnTeamActionClick(object sender, string strActionDetail3)  //strActionDetail3: 其他动作
        //{
        //    int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.Period);

        //    ButtonX btn = (ButtonX)sender;

        //    if (m_CCurAction.IsNewAction())
        //    {
        //        m_CCurAction.Init();
        //        m_CCurAction.InitAction(m_CCurMatch, iSplitID);
        //    }

        //    if ((m_CCurAction.ActionDetail1.Length != 0 && m_CCurAction.ActionDetail1 != "0") || m_CCurAction.ActionDetail2.Length != 0)   //判读此Action是否记录了之前别的动作，与射门和进球有关的，则此Action不成功，需要重做
        //    {
        //        m_CCurAction.Init();
        //        m_CCurAction.InitAction(m_CCurMatch, iSplitID);
        //    }
        //    m_CCurAction.ActionType = EActionType.emTStat;
        //    m_CCurAction.ActionTime = GetActionTime();
        //    m_CCurAction.ActionDetail1 = "0";
        //    m_CCurAction.ActionDetail3 = strActionDetail3;
        //    m_CCurAction.GetActionCode();
        //    m_CCurAction.ActionDetailDes3 = btn.Text;

        //    UpdateUIActionInfo();
        //    if (m_CCurAction.IsActionComplete())
        //    {
        //        if (m_CCurAction.TeamPos == 1)
        //        {
        //            m_CCurAction.RegisterID = m_CCurMatch.m_CHomeTeam.TeamID;
        //            m_CCurAction.RegName = m_CCurMatch.m_CHomeTeam.TeamName;
        //            m_CCurAction.ShirtNo = string.Empty;
        //        }
        //        else if (m_CCurAction.TeamPos == 2)
        //        {
        //            m_CCurAction.RegisterID = m_CCurMatch.m_CVisitTeam.TeamID;
        //            m_CCurAction.RegName = m_CCurMatch.m_CVisitTeam.TeamName;
        //            m_CCurAction.ShirtNo = string.Empty;
        //        }
        //        int iOPGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, (3 - m_CCurAction.TeamPos));
        //        m_CCurAction.CreateActionXml(m_CCurMatch, iOPGKID);
        //        AddAction();

        //        GVAR.g_ManageDB.GetMatchActionList(m_MatchID, ref m_lstAction);
        //        UpdateActionList(ref m_lstAction, -1);
        //        m_CCurAction.Init();
        //        UpdateUIActionInfo();
        //        NotifyMatchStatistics();
        //    }
        //}
        private void btnPlayerOtherActionClick(object sender, string strActionDetail3)  //其他动作
        {
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.Period);

            ButtonX btn = (ButtonX)sender;

            if (m_CCurAction.IsNewAction())
            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            if ( (m_CCurAction.ActionDetail1.Length != 0  && m_CCurAction.ActionDetail1 != "0") || m_CCurAction.ActionDetail2.Length != 0)   //判读此Action是否记录了之前别的动作，与射门和进球有关的，则此Action不成功，需要重做            {
                m_CCurAction.Init();
                m_CCurAction.InitAction(m_CCurMatch, iSplitID);
            }

            m_CCurAction.ActionType = EActionType.emPStat;
            m_CCurAction.ActionTime = GetActionTime();
            m_CCurAction.ActionDetail1 = "0";
            m_CCurAction.ActionDetail3 = strActionDetail3;
            m_CCurAction.GetActionCode();
            m_CCurAction.ActionDetailDes3 = btn.Text;

            if (strActionDetail3 == "12")
            {
                if (!IsPlayerAction(0))
                {
                    m_CCurAction.ClearPlayerInfo();
                }
            }

            if (strActionDetail3 == "13")
            {
                if (!IsPlayerAction(1))
                {
                    m_CCurAction.ClearPlayerInfo();
                }
            }

            UpdateUIActionInfo();
            if (m_CCurAction.IsActionComplete())
            {
                if (strActionDetail3 == "5")
                {
                    if (FindYellowCard(m_CCurAction.RegisterID))
                    {
                        MessageBox.Show(LocalizationRecourceManager.GetString(m_strSectionName, "YCardWarn"));
                        m_CCurAction.Init();
                        UpdateUIActionInfo();
                        return;
                    }
                }
                if (strActionDetail3 == "6")
                {
                    if (!FindYellowCard(m_CCurAction.RegisterID))
                    {
                        MessageBox.Show(LocalizationRecourceManager.GetString(m_strSectionName, "Y2CardWarn"));
                        m_CCurAction.Init();
                        UpdateUIActionInfo();
                        return;
                    }
                }

                if (m_CCurAction.ActionKey == "013")
                {
                    if (!UpdateOutPlayer())
                    {
                        m_CCurAction.Init();
                        UpdateUIActionInfo();
                        return;
                    }
                }

                if (m_CCurAction.ActionKey == "012")
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
                if (m_CCurAction.ActionKey == "06" || m_CCurAction.ActionKey == "07")
                {
                    m_CCurAction.AcitonID = -1;
                    btnPlayerOtherActionClick(btnOut, "13");
                }
                GVAR.g_ManageDB.GetMatchActionList(m_MatchID, ref m_lstAction);
                UpdateActionList(ref m_lstAction, - 1);
                if (m_CCurAction.ActionKey == "013")
                {
                    SetPlayerUnActive(m_CCurAction.RegisterID, m_CCurAction.TeamPos);

                }
                m_CCurAction.Init();
                UpdateUIActionInfo();
                NotifyMatchStatistics();

                if (strActionDetail3 == "10")
                {
                    btnPlayerOtherActionClick(btnFoulS, "11");
                }
                if (strActionDetail3 == "11")
                {
                    btnPlayerOtherActionClick(btnFoulC, "10");
                }
            }
        }

        private bool FindYellowCard(int iRegisterID)
        {
            for (int i = 0; i < m_lstAction.Count;i++ )
            {
                if (m_lstAction[i].ActionDetail1 == "0" && m_lstAction[i].ActionDetail3 == "5" && m_lstAction[i].RegisterID == iRegisterID)
                {
                    return true;
                }
            }
            return false;
        }
        private void btnCorner_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "8");
            //btnTeamActionClick(sender, "8");
        }

        private void btnOffside_Click(object sender, EventArgs e)
        {
            btnPlayerOtherActionClick(sender, "9");
            //btnTeamActionClick(sender, "9");
        }       

        
       #endregion
        public String GetActionTime()
        {
            return GVAR.FormatTime((m_CCurMatch.GetBasicPeriodsTime()+Convert.ToInt32(m_CCurMatch.MatchTime)).ToString()) ;
        }
        private void dgvAction_KeyDown(object sender, KeyEventArgs e)    //Delete键特殊处理        {
            if (m_CCurMatch.MatchStatus == GVAR.STATUS_FINISHED || m_CCurMatch.MatchStatus == GVAR.STATUS_SUSPEND)
            {
                e.Handled = true;
                return;
            }
            if (e.KeyCode == Keys.Delete)
            {

                if (dgvAction.SelectedRows.Count <= 0)
                    return;

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
                    GVAR.g_ManageDB.GetMatchActionList(m_MatchID, ref m_lstAction);
                    UpdateActionList(ref m_lstAction, -1);
                    m_CCurAction.Init();
                    UpdateUIActionInfo();
                    NotifyMatchStatistics();
                }
            }
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
            GVAR.g_ManageDB.UpdateTeamSetPt(ref m_CCurMatch, m_CCurMatch.Period);
            UpdateUIForTeamScore();
            if (!m_CCurMatch.bRunTime && m_CCurMatch.Period != GVAR.PERIOD_PenaltyShoot)
            {
                btnStart_Click(null, null);
            }
            GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, iMatchID, iMatchID, null);

            UpdatePeriodBtnStat();
        }

        private void btnEndPeriod_Click(object sender, EventArgs e)
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);
            GVAR.g_ManageDB.UpdateMatchSplitStatus(iMatchID, iMatchSplitID, GVAR.STATUS_FINISHED);
            btnEndPeriod.Enabled = false;
            btnStartPeriod.Enabled = false;
            UpdateNextBtnStat();
            if (m_CCurMatch.bRunTime)
            {
                m_CCurMatch.bRunTime = false;
                timerSplit.Enabled = false;
                btnStart.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnStart");
            }
            btnAllTeamPlayersOut_Click(1);
            btnAllTeamPlayersOut_Click(2);
            m_CCurMatch.MatchTime = "0";
            MatchTime.Text = GVAR.TranslateINT32toTime(0);
            GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, iMatchID, iMatchID, null);
        }

        private void MatchTime_Enter(object sender, EventArgs e)
        {
            if (m_CCurMatch.bRunTime)
            {
                timerSplit.Enabled = false;
                m_dwSumSec += System.Environment.TickCount / 1000 - m_dwCurSecCount;
                m_CCurMatch.MatchTime = m_dwSumSec.ToString();
            }
        }
        private void MatchTime_Leave(object sender, EventArgs e)
        {
            MatchTime.Text = CheckInputTime(MatchTime.Text);
            m_CCurMatch.MatchTime = GVAR.TranslateTimetoINT32(MatchTime.Text).ToString();
            m_dwCurSecCount = System.Environment.TickCount / 1000;
            m_dwSumSec = GVAR.Str2Int(m_CCurMatch.MatchTime);
            if (m_CCurMatch.bRunTime)
            {
                timerSplit.Enabled = true;
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
        private void MatchTime_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                e.Handled = true;
            }
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
        private void NotifyMatchStatistics()
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, iMatchID, iMatchID, null);
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
        private void textBoxX_FocusLeave(object sender, EventArgs e)
        {
            TextBoxX tb = (TextBoxX)sender;
            tb.Text = CheckInput(tb.Text);
            if (sender == homePossTime)
            {
                UpdateTeamStatic(1, "14", tb.Text);
            }
            else if (sender == visitPossTime)
            {
                UpdateTeamStatic(2, "14", tb.Text);
            }
        }
        private void AddTime_FocusLeave(object sender, EventArgs e)
        {
            TextBoxX tb = (TextBoxX)sender;
            tb.Text = CheckInput(tb.Text);
            UpdateAddTime(tb.Text);
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

        private void btnxExPathSel_Click(object sender, EventArgs e)
        {
            if (folderSelDlg.ShowDialog() == DialogResult.OK)
            {
                if (folderSelDlg.SelectedPath[(folderSelDlg.SelectedPath.Length - 1)] != '\\')
                {
                    tbExportPath.Text = folderSelDlg.SelectedPath+"\\";
                }
                else
                {
                     tbExportPath.Text = folderSelDlg.SelectedPath;
                }
            }
        }

        private void btnExport_Click(object sender, EventArgs e)
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            DataTable dt = new DataTable("UD_MatchInfo");
            GVAR.g_ManageDB.GetMatchInfo_Export(iMatchID, ref dt);
            ExportTable(ref dt);

             dt.Clear();
             dt.Columns.Clear();
            dt.TableName = "Host_VS_Guest";
            GVAR.g_ManageDB.GetHost_VS_Guest_Export(iMatchID, ref dt);
            ExportTable(ref dt);


            dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "UD_ScheduleAndResults";
            GVAR.g_ManageDB.GetScheduleAndResults_Export(iMatchID, ref dt);
            ExportTable(ref dt);

            dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "UD_GroupComposition";
            GVAR.g_ManageDB.GetGroupComposition_Export(iMatchID, ref dt);
            ExportTable(ref dt);

            dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "UD_GroupRanking";
            GVAR.g_ManageDB.GetGroupRanking_Export(iMatchID, ref dt);
            ExportTable(ref dt);

            dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "UD_HostPlayedMatchs";
            GVAR.g_ManageDB.GetTeamPlayedMatchs_Export(iMatchID,1, ref dt);
            ExportTable(ref dt);

            dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "UD_GuestPlayedMatchs";
            GVAR.g_ManageDB.GetTeamPlayedMatchs_Export(iMatchID, 2, ref dt);
            ExportTable(ref dt);

            dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "UD_HostCoach";
            GVAR.g_ManageDB.GetCoach_Export(iMatchID,1, ref dt);
            ExportTable(ref dt);

            dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "UD_GuestCoach";
            GVAR.g_ManageDB.GetCoach_Export(iMatchID, 2, ref dt);
            ExportTable(ref dt);

            dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "UD_Referees";
            GVAR.g_ManageDB.GetMatchReferees_Export(iMatchID, ref dt);
            ExportTable(ref dt);

            dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "UD_8to4Tournament";
            GVAR.g_ManageDB.GetTournament_Chart_Export(iMatchID,4, ref dt);
            ExportTable(ref dt);

            dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "UD_4to2Tournament";
            GVAR.g_ManageDB.GetTournament_Chart_Export(iMatchID, 2, ref dt);
            ExportTable(ref dt);

            dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "UD_MedalList";
            GVAR.g_ManageDB.GetMedalList_Export(iMatchID, ref dt);
            ExportTable(ref dt);

              dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "HostTeam";
            GVAR.g_ManageDB.GetTeamList_Export(iMatchID, 1,ref dt);
            ExportTable(ref dt);

            dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "GuestTeam";
            GVAR.g_ManageDB.GetTeamList_Export(iMatchID,2, ref dt);
            ExportTable(ref dt);

            dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "MatchStatistics";
            GVAR.g_ManageDB.GetMatchStatistics_Export(iMatchID, ref dt);
            ExportTable(ref dt);

            dt.Clear();
            dt.Columns.Clear();
            dt.TableName = "UD_Weather";
            GVAR.g_ManageDB.GetWeatherCondition_Export(iMatchID, ref dt);
            ExportTable(ref dt);
            
        }
        private void ExportTable(ref DataTable dt)
        {
            string strExportFile = tbExportPath.Text + dt.TableName + ".csv";
            File.Delete(strExportFile);
            if (dt.Columns.Count<=0)
            {
                return;
            }
             string strHeader = string.Empty;
            for (int i = 0 ; i <dt.Columns.Count;i++)
            {
                strHeader += dt.Columns[i].ColumnName;
                if (i !=dt.Columns.Count-1)
                {
                    strHeader += ";";
                }
            }
            File.AppendAllText(strExportFile, strHeader,Encoding.Unicode);
            File.AppendAllText(strExportFile, "\r\n", Encoding.Unicode);

            for (int j = 0; j < dt.Rows.Count;j++ )
            {
                string strRow = string.Empty;
                for (int k = 0; k < dt.Columns.Count; k++)
                {
                    strRow += dt.Rows[j][k];
                    if (k != dt.Columns.Count-1)
                    {
                        strRow += ";";
                    }	
                }
                File.AppendAllText(strExportFile, strRow, Encoding.Unicode);
                File.AppendAllText(strExportFile, "\r\n", Encoding.Unicode);
            }
        }

        private void btnWeatherSet_Click(object sender, EventArgs e)
        {
            OVRFBWeatherConfig OVRWeatherConfigForm = new OVRFBWeatherConfig();
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            OVRWeatherConfigForm.MatchID = iMatchID;
            OVRWeatherConfigForm.textWaterTemp.Enabled = false;

            OVRWeatherConfigForm.ShowDialog();
            if (OVRWeatherConfigForm.DialogResult == DialogResult.OK)
            {
                GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchWeather, -1, -1, -1, iMatchID, iMatchID, null);
            }
        }
        private void dgvAction_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.RowIndex >= 0 && dgvAction.Columns[e.ColumnIndex].HeaderText == "ActionTime" && m_CCurMatch.MatchStatus != GVAR.STATUS_SUSPEND && m_CCurMatch.MatchStatus != GVAR.STATUS_FINISHED)
            {
                if (dgvAction.SelectedRows.Count <= 0)
                    return;

                if (dgvAction.SelectedRows[0].Index >= 0)
                {
                    int iActionID = GVAR.Str2Int(dgvAction.SelectedRows[0].Cells["F_ActionNumberID"].Value.ToString());

                    int iSplitID = GetMatchActionFromActionID(iActionID).MatchSplitID;
                    if (GVAR.g_ManageDB.GetMatchPeriod(m_MatchID, iSplitID) == GVAR.PERIOD_PenaltyShoot)
                    {
                        return;
                    }
                }
                dgvAction[e.ColumnIndex, e.RowIndex].ReadOnly = false;
                m_strActionTime = dgvAction[e.ColumnIndex, e.RowIndex].Value.ToString();
            }
            else
            {
                //dgvAction[e.ColumnIndex, e.RowIndex].ReadOnly = true;
                dgvAction.Columns[e.ColumnIndex].ReadOnly = true;
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
                return;
            }
            int iActionID = GVAR.Str2Int(dgvAction.Rows[e.RowIndex].Cells["F_ActionNumberID"].Value.ToString());

            GVAR.g_ManageDB.UpdateActionTime(iActionID, GVAR.FormatTime(GVAR.TranslateTimetoINT32(cell.Value.ToString()).ToString()));


            OVRFBActionInfo CurAction = GetMatchActionFromActionID(iActionID);
            if (CurAction.ActionKey == "012"
                || CurAction.ActionKey == "013")
            {
                GVAR.g_ManageDB.UpdatePlayerPlayTime(m_MatchID, CurAction.TeamPos, CurAction.RegisterID, GVAR.strStat_PTime_Player);
            }

            GVAR.g_ManageDB.GetMatchActionList(m_MatchID, ref m_lstAction);
                          
            //UpdateActionList(ref m_lstAction, -1);
            m_CCurAction.Init();
            UpdateUIActionInfo();
            NotifyMatchStatistics();
        }
        private OVRFBActionInfo GetMatchActionFromActionID(int iActionID)
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
        private void dgvAction_CellLeave(object sender, DataGridViewCellEventArgs e)
        {
            if (dgvAction.Columns[e.ColumnIndex].HeaderText == "ActionTime")
            {
                dgvAction.Columns[e.ColumnIndex].ReadOnly = true;
            }
        }
        private void AppExit()
        {
            if (m_CCurMatch.MatchID == null || m_CCurMatch.MatchID.Length == 0)
                return;

            GVAR.g_ManageDB.UpdateMatchTime(m_MatchID, m_CCurMatch.MatchTime);
        }

        private void dgvAction_CellMouseClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.RowIndex >= 0 && e.Button== MouseButtons.Right && m_CCurMatch.MatchStatus != GVAR.STATUS_SUSPEND && m_CCurMatch.MatchStatus != GVAR.STATUS_FINISHED)
            {
                if (dgvAction.SelectedRows.Count <= 0)
                    return;

                if (dgvAction.SelectedRows[0].Index >= 0)
                {
                    int iActionID = GVAR.Str2Int(dgvAction.SelectedRows[0].Cells["F_ActionNumberID"].Value.ToString());

                    string strActionCode = GetMatchActionFromActionID(iActionID).ActionCode;
                    if (strActionCode == "YCard" )
                    {  
                        ContextMenu ctMenu = new ContextMenu();
                        string strMemuText = LocalizationRecourceManager.GetString(m_strSectionName, "YellowItem");
                        MenuItem mi = new MenuItem(strMemuText, YellowCardHandler);
                        mi.Tag = iActionID;
                        ctMenu.MenuItems.Add(mi) ;   
                        ctMenu.Show(dgvAction, dgvAction.PointToClient(Control.MousePosition));
                    }
                    else if(strActionCode == "2YCard" || strActionCode == "RCard")
                    {
                        ContextMenu ctMenu = new ContextMenu();
                        string strMemuText = LocalizationRecourceManager.GetString(m_strSectionName, "RedItem");
                        MenuItem mi = new MenuItem(strMemuText, RedCardHandler);
                        mi.Tag = iActionID;
                        ctMenu.MenuItems.Add(mi) ;
                        ctMenu.Show(dgvAction, dgvAction.PointToClient(Control.MousePosition));
                    }
                    else
                    {
                        return;
                    }
                }
            }
        }

        public void YellowCardHandler(Object sender, EventArgs e)
        {
            MenuItem mi = sender as MenuItem;
            string strCode =  GVAR.g_ManageDB.GetCardCode((int)mi.Tag);
            string strCdAtr = LocalizationRecourceManager.GetString(m_strSectionName, "CardAttribute");
            CardAttributeForm caForm = new CardAttributeForm(CardType.eYellow,strCode);
            caForm.chkMissMatch1.Visible = false;
            caForm.chkMissMatch2.Visible = false;
            caForm.Text = strCdAtr;
            caForm.ShowDialog();
            GVAR.g_ManageDB.UpdateCardCode((int)mi.Tag, caForm.cbCode.SelectedValue.ToString());
        }
        public void RedCardHandler(Object sender, EventArgs e)
        {
            MenuItem mi = sender as MenuItem;
            string strCode = GVAR.g_ManageDB.GetCardCode((int)mi.Tag);
            int iState = GVAR.g_ManageDB.GetMissMatchState((int)mi.Tag);
            
            string strCdAtr = LocalizationRecourceManager.GetString(m_strSectionName, "CardAttribute");
            CardAttributeForm caForm = new CardAttributeForm(CardType.eRed, strCode);
            caForm.chkMissMatch1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "chkMissMatch1");
            caForm.chkMissMatch2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "chkMissMatch2");
            caForm.Text = strCdAtr;
            caForm.SetCheckState(iState);
            caForm.ShowDialog();
            int r = caForm.GetCheckState();
            GVAR.g_ManageDB.UpdateMissMatchState((int)mi.Tag, r);
            GVAR.g_ManageDB.UpdateCardCode((int)mi.Tag, caForm.cbCode.SelectedValue.ToString());

        }
    }
}
