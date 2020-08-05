using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Net;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using AutoSports.OVRCommon;
using DevComponents.DotNetBar;

namespace AutoSports.OVRBDPlugin
{
    public delegate void SetTextBoxMsg(String strMsg);

    public partial class frmOVRBDDataEntry : Office2007Form
    {
        private bool m_bIsBD;
        [DllImport("user32.dll")]
        public static extern bool FlashWindow(IntPtr hWnd, bool bInvert);


        public TSDataExchangeTT_Service TTExchangeService
        {
            get
            {
                if (m_exchangeTcp != null)
                {
                    return m_exchangeTcp;
                }
                else if (m_exchangeFile != null)
                {
                    return m_exchangeFile;
                }
                else
                {
                    return null;
                }
            }
        }
        public frmOVRBDDataEntry()
        {
            InitializeComponent();
            try
            {
                if (!Directory.Exists("C:\\DatabaseBackup"))
                {
                    Directory.CreateDirectory("C:\\DatabaseBackup");
                }
            }
            catch
            {

            }
            if (BDCommon.g_strDisplnCode == "BD")
            {
                m_bIsBD = true;// ttTsTab.Visible = false;
            }
            else
            {
                m_bIsBD = false;
                tabConsole.Visible = false;
                //btnSendBye.Visible = false;
                // btnScoreBoard.Visible = false;
            }
            btnSendBye.Visible = true;
            btnScoreBoard.Text = "Score Board";
            OVRDataBaseUtils.SetDataGridViewStyle(dgCrossPair);
            dgCrossPair.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            m_tsTTconfig = new TS_TTConfig();
            m_tsTTconfig.LoadConfig();
            m_stateMonitor = new frmStateMonitor();
            tbServerIP.Value = m_tsTTconfig.CtrlCenterIP;
            tbRemotePort.Text = m_tsTTconfig.CenterPort;
            OVRDataBaseUtils.SetDataGridViewStyle(dgDayStatus);
            OVRDataBaseUtils.SetDataGridViewStyle(dgvSubEventOrder);
        }

        private void frmOVRBDDataEntry_Load(object sender, EventArgs e)
        {
            EnableMatchCtrlBtn(false);
            EnableMatchAll(false, true);
            EnableExportImport(false);

            Localization();
            BDCommon.g_ManageDB.InitDiscipline();

            string strDBVersion = "Database version date:" + BDCommon.g_ManageDB.GetDBVersionDate();

            if (strDBVersion == "")
            {
                lbDBVersion.Text = "Can not get database version.";
            }
            else
            {
                lbDBVersion.Text = strDBVersion;
            }
            string kk = BDCommon.GetPluginVersionStr();
            lbPluginVersion.Text = kk;

            for (int i = 1; i <= 20; i++)
            {
                cmbFrameRate.Items.Add(i);
            }
            cmbFrameRate.SelectedIndex = 4;

            DataTable dt = BDCommon.g_ManageDB.GetTeamSubEventOrder();
            OVRDataBaseUtils.FillDataGridView(dgvSubEventOrder, dt);
        }

        private void Localization()
        {
            gb_MatchInfo.Text = LocalizationRecourceManager.GetString(strSectionName, "gbMatchInfo");
            gb_MatchResult.Text = LocalizationRecourceManager.GetString(strSectionName, "gbMatchScore");
            //lb_Sport.Text = LocalizationRecourceManager.GetString(strSectionName, "lbSportName");
            lb_Phase.Text = LocalizationRecourceManager.GetString(strSectionName, "lbPhaseName");
            lb_Date.Text = LocalizationRecourceManager.GetString(strSectionName, "lbDate");
            // lb_Venue.Text = LocalizationRecourceManager.GetString(strSectionName, "lbVenue");
            lb_TotalScore.Text = LocalizationRecourceManager.GetString(strSectionName, "lbTotalScore");
            lb_Player.Text = LocalizationRecourceManager.GetString(strSectionName, "lbPlayers");
            lb_GameTotal.Text = LocalizationRecourceManager.GetString(strSectionName, "lbGameTotal");
            btnx_Official.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxOfficialInfo");
            btnx_Team.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxTeamInfo");
            btnx_Exit.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxExitMatch");
            btnx_Modify_Result.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxModifyResult");
            btnx_ModifyTime.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxModifyTime");
            btnx_Schedule.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxSchedule");
            btnx_StartList.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxStartList");
            btnx_Running.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxRunning");
            btnx_Suspend.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxSuspend");
            btnx_Unofficial.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxUnofficial");
            btnx_Finished.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxFinished");
            btnx_Revision.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxRevision");
            btnx_Canceled.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxCanceled");
            btnx_Split1.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxMatch1");
            btnx_Split2.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxMatch2");
            btnx_Split3.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxMatch3");
            btnx_Split4.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxMatch4");
            btnx_Split5.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxMatch5");
            rad_ServerA.Text = LocalizationRecourceManager.GetString(strSectionName, "radServerA");
            rad_ServerB.Text = LocalizationRecourceManager.GetString(strSectionName, "radServerB");
            btnx_SubMatch_Result.Text = LocalizationRecourceManager.GetString(strSectionName, "SubMatchResult");
            btnx_Game_Result.Text = LocalizationRecourceManager.GetString(strSectionName, "GameResult");
            rad_Game1.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame1");
            rad_Game2.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame2");
            rad_Game3.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame3");
            rad_Game4.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame4");
            rad_Game5.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame5");
            rad_Game6.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame6");
            rad_Game7.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame7");
            btnScoreBoard.Text = LocalizationRecourceManager.GetString(strSectionName, "btnScoreBoard");
            btnAutoScore.Text = LocalizationRecourceManager.GetString(strSectionName, "btnAutoScore");
            btnDelAction.Text = LocalizationRecourceManager.GetString(strSectionName, "btnDelAction");
            btnOpenMonitor.Text = LocalizationRecourceManager.GetString(strSectionName, "btnOpenMonitor");
            btnOpenConfig.Text = LocalizationRecourceManager.GetString(strSectionName, "btnOpenConfig");
            btnDelMatchRes.Text = LocalizationRecourceManager.GetString(strSectionName, "btnClearResult");
            gb_ImportResult.Text = LocalizationRecourceManager.GetString(strSectionName, "gbExportImport");
            lb_SelectDate.Text = LocalizationRecourceManager.GetString(strSectionName, "lbSelectDate");
            lb_ExportPath.Text = LocalizationRecourceManager.GetString(strSectionName, "lbExportPath");
            btnxExAthlete.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxExportAthlete");
            btnxExSchedule.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxExportSchedule");
            lb_ImportPath.Text = LocalizationRecourceManager.GetString(strSectionName, "lbImportPath");
            btnxImportMatchInfo.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxImportMatchInfo");
            btnxImportAction.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxImportAction");
            chkOuterData.Text = LocalizationRecourceManager.GetString(strSectionName, "chkExternalData");

            //            <lbMatchName>比赛名称：</lbMatchName>
            //<lbRuleName>规则：</lbRuleName>
            //<lbMatchTime>比赛时间：</lbMatchTime>
            //<lbMatchCourt>场地：</lbMatchCourt>
            //<lbMatchID>比赛ID:</lbMatchID>
            //<lbMatchRSC>比赛编码:</lbMatchRSC>
            lb_Phase.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMatchName");
            lbRuleHeader.Text = LocalizationRecourceManager.GetString(strSectionName, "lbRuleName");
            lb_Date.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMatchTime");
            lbMatchDateName.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMatchID");
            lbRSCName.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMatchRSC");
            lbCourtHeader.Text = LocalizationRecourceManager.GetString(strSectionName, "lbMatchCourt");
        }

        public void OnMsgFlushSelMatch(Int32 nWndMode, Int32 nMatchID)
        {
            // Is Running then exist current first
            if (m_bIsRunning)
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbRunningMatch"));
                return;
            }

            // Check valid MatchID
            if (nMatchID <= 0)
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbChooseMatch"));
                return;
            }

            // Check valid MatchRuleID
            if (BDCommon.g_ManageDB.GetMatchRuleID(nMatchID) <= 0)
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbMatchRule"));
                return;
            }

            // Initial settings from match rule
            m_nCurMatchID = nMatchID;
            m_CurMatchRule = new OVRBDRule(m_nCurMatchID);
            m_nCurMatchType = m_CurMatchRule.m_nMatchType;
            m_nCurStatusID = m_CurMatchRule.m_nMatchStatusID;
            m_nGamesCount = m_CurMatchRule.m_nGamesCount;
            m_nTeamSplitCount = m_CurMatchRule.m_nSplitsCount;

            if (m_nCurMatchType == BDCommon.MATCH_TYPE_TEAM)
            {
                btnSendSet.Enabled = true;
                btnImportTempData.Enabled = true;
            }
            else
            {
                btnSendSet.Enabled = false;
                btnImportTempData.Enabled = false;
            }
            // Check valid Status
            if (m_nCurStatusID == BDCommon.STATUS_RUNNING || m_nCurStatusID == BDCommon.STATUS_REVISION)
            {
                //2011-01-14去掉running时进入比赛的限制
                //String strStauts = BDCommon.g_ManageDB.GetStatusName(m_nCurStatusID);
                //MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbMatchStatus") + strStauts);
                //return;
            }

            // Check valid player
            Int32 nRegAID, nRegBID;
            BDCommon.g_ManageDB.GetMatchMember(m_nCurMatchID, out nRegAID, out nRegBID);
            if (nRegAID <= 0 || nRegBID <= 0)
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbConfigMatchUp"));
                return;
            }

            HideNotUsedUICtrl();

            StartMatch();

            return;
        }

        public void QueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;

            switch (args.Name)
            {
                case "MatchID":
                    {
                        args.Value = m_nCurMatchID.ToString();
                        args.Handled = true;
                    }
                    break;
                default:
                    break;
            }
        }

        private void btnx_Exit_Click(object sender, EventArgs e)
        {
            if (!m_bIsRunning) return;

            if (MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbExitMatch"), "", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                InitVariants();
                m_nCurMatchID = -1;
                m_bIsRunning = false;

                EnableMatchCtrlBtn(false);
                EnableMatchAll(false, true);
                EnableAutoData(true);
                lbCourtName.Text = "";
                lbMatchID.Text = "";
                lbMatchRsc.Text = "";
                chkEnableInput.Checked = false;
                chkEnableInput.Enabled = false;
                btnSendSet.Enabled = false;
                btnImportTempData.Enabled = false;
            }
        }

        private void btnx_Set_TeamBracket_Click(object sender, EventArgs e)
        {
            if (m_nCurMatchType != BDCommon.MATCH_TYPE_TEAM)
                return;

            frmSetTeamPlayer frmTeamPlayer = new frmSetTeamPlayer(m_nCurMatchID);
            frmTeamPlayer.m_curMatchRule = this.CurMatchRule;
            frmTeamPlayer.ShowDialog();

            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emSplitCompetitor, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void btnx_Set_MatchOfficials_Click(object sender, EventArgs e)
        {
            frmEntryOfficial frmOfficial = null;
            if (!m_bIsBD)
            {
                frmOfficial = new frmEntryOfficial(m_nCurMatchID, false, m_naTeamSplitIDs);
            }
            else
            {
                frmOfficial = new frmEntryOfficial(m_nCurMatchID, m_bIsTeamMatch, m_naTeamSplitIDs);
            }
            frmOfficial.ShowDialog();
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchOfficials, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void btnx_Modify_MatchTime_Click(object sender, EventArgs e)
        {
            ModifyMatchTime frmModifyTime = new ModifyMatchTime(m_nCurMatchID, m_nCurMatchType, (GameCountType)m_nGamesCount);
            frmModifyTime.ShowDialog();

            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void btnx_Modify_MatchResult_Click(object sender, EventArgs e)
        {
            frmModifyResult frmMatchResult = new frmModifyResult(m_nCurMatchID, -1);
            if (DialogResult.OK == frmMatchResult.ShowDialog())
            {
                if (DevComponents.DotNetBar.MessageBoxEx.Show("Do you want to auto calculate results again?", "Warning", MessageBoxButtons.OKCancel) == DialogResult.Cancel)
                {
                    return;
                }
            }
            else
            {
                return;
            }
            if (chkManual.Checked)
            {
                return;
            }

            String strHomeScore, strAwayScore;

            if (BDCommon.g_ManageDB.GetMatchScore(m_nCurMatchID, out strHomeScore, out strAwayScore))
            {
                lb_Home_Score.Text = strHomeScore.Equals("") ? "0" : strHomeScore;
                lb_Away_Score.Text = strAwayScore.Equals("") ? "0" : strAwayScore;

                if (m_nCurStatusID == BDCommon.STATUS_RUNNING || m_nCurStatusID == BDCommon.STATUS_REVISION)
                {
                    GetAllGamesResultFromDB();
                }
            }

            //  BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress, -1, -1, -1, m_nCurMatchID, -1, null);
            OutputXmlToXuNi(m_nCurMatchID);
        }

        private void btnx_Modify_TeamSplitResult_Click(object sender, EventArgs e)
        {
            if (m_nCurSplitOffset < 0)
                return;

            frmModifyResult frmMatchResult = new frmModifyResult(m_nCurMatchID, m_nCurTeamSplitID);
            if (DialogResult.OK == frmMatchResult.ShowDialog())
            {
                if (DevComponents.DotNetBar.MessageBoxEx.Show("Do you want to auto calculate results again?", "Warning", MessageBoxButtons.OKCancel) == DialogResult.Cancel)
                {
                    return;
                }
            }
            else
            {
                return;
            }
            if (!chkManual.Checked)
            {
                String strGameTotalA, strGameTotalB;
                if (BDCommon.g_ManageDB.GetTeamSplitResult(m_nCurMatchID, m_nCurTeamSplitID, out strGameTotalA, out strGameTotalB))
                {
                    lb_A_GameTotal.Text = strGameTotalA.Equals("") ? "0" : strGameTotalA;
                    lb_B_GameTotal.Text = strGameTotalB.Equals("") ? "0" : strGameTotalB;

                    UIGamesTotal2MatchResultsToDB();
                    EnableMatchCtrlBtn(true);
                }
            }


            //    BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress);
            OutputXmlToXuNi(m_nCurMatchID);
        }

        private void btnx_Modify_GameResult_Click(object sender, EventArgs e)
        {
            if (m_nCurGameOffset < 0)
                return;

            frmModifyResult frmMatchResult = new frmModifyResult(m_nCurMatchID, m_nCurGameID);
            if (DialogResult.OK == frmMatchResult.ShowDialog())
            {
                GetAllGamesResultFromDB();
                if (DevComponents.DotNetBar.MessageBoxEx.Show("Do you want to auto calculate results again?", "Warning", MessageBoxButtons.OKCancel) == DialogResult.Cancel)
                {
                    return;
                }
            }
            else
            {
                GetAllGamesResultFromDB();
                return;
            }
            if (!chkManual.Checked)
            {
                CountGamesTotalToUI();
                UIGamesTotal2MatchResultsToDB();
                EnableGamesRbtnsAndLabels(true, false);
                EnableGameDetail(true, false);
            }

            //   BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress);
            OutputXmlToXuNi(m_nCurMatchID);
        }

        #region Change competition Status operation
        private void btnx_StartList_Click(object sender, EventArgs e)
        {
            if (m_nCurMatchType == BDCommon.MATCH_TYPE_TEAM)
            {
                //先判断团体的人员是否设置好了
                if (!BDCommon.g_ManageDB.IsTeamPlayersAllSetted(m_nCurMatchID))
                {
                    if (DialogResult.Cancel == MessageBox.Show("The team players are not setted.Do you really want to continue?", "OVRBDPlugin", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning))
                    {
                        return;
                    }
                }
            }

            m_nCurStatusID = BDCommon.STATUS_STARTLIST;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, BDCommon.g_adoDataBase.m_dbConnect, BDCommon.g_BDPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Running_Click(object sender, EventArgs e)
        {
            // Auto Select 1st Split or 1st Game
            if (m_nCurMatchType == BDCommon.MATCH_TYPE_TEAM)
            {
                btnx_Split1.Checked = true;
                m_nCurSplitOffset = 0;
                if (!ChangeTeamSplit(0))
                {
                    return;
                }
                if (BDCommon.g_ManageDB.IsDoubleMatch(m_nCurMatchID, 1) == 1)
                {
                    System.Diagnostics.Trace.WriteLine("StartMatch:设置比赛为双打！");
                    m_bIsDoubleMatch = true;
                    List<int> ids = new List<int>();
                    if (BDCommon.g_ManageDB.GetDoubleMatchPlayerIDs(m_nCurMatchID, ref ids, 1))
                    {
                        m_nDoubleRegisterA1 = ids[0];
                        m_nDoubleRegisterA2 = ids[1];
                        m_nDoubleRegisterB1 = ids[2];
                        m_nDoubleRegisterB2 = ids[3];

                    }
                    else
                    {
                        MessageBox.Show("Get double match players' id failed!");
                    }
                }
                else
                {
                    System.Diagnostics.Trace.WriteLine("StartMatch:设置比赛为单打！");
                    m_bIsDoubleMatch = false;
                }
            }
            else
            {
                if (BDCommon.g_ManageDB.IsDoubleMatch(m_nCurMatchID) == 1)
                {
                    System.Diagnostics.Trace.WriteLine("StartMatch:设置比赛为双打！");
                    m_bIsDoubleMatch = true;
                    List<int> ids = new List<int>();
                    if (BDCommon.g_ManageDB.GetDoubleMatchPlayerIDs(m_nCurMatchID, ref ids))
                    {
                        m_nDoubleRegisterA1 = ids[0];
                        m_nDoubleRegisterA2 = ids[1];
                        m_nDoubleRegisterB1 = ids[2];
                        m_nDoubleRegisterB2 = ids[3];

                    }
                    else
                    {
                        MessageBox.Show("Get double match players' id failed!");
                    }
                }
                else
                {
                    System.Diagnostics.Trace.WriteLine("StartMatch:设置比赛为单打！");
                    m_bIsDoubleMatch = false;
                }
                rad_Game1.Checked = true;
                m_nCurSplitOffset = 0;
                m_nCurGameOffset = 0;
            }

            m_nCurStatusID = BDCommon.STATUS_RUNNING;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, BDCommon.g_adoDataBase.m_dbConnect, BDCommon.g_BDPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Suspend_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = BDCommon.STATUS_SUSPEND;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, BDCommon.g_adoDataBase.m_dbConnect, BDCommon.g_BDPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Unofficial_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = BDCommon.STATUS_UNOFFICIAL;

            //检查规则和比分，如果比分不适合结束则给出警告提示
            int scoreA = Convert.ToInt32(lb_Home_Score.Text);
            int scoreB = Convert.ToInt32(lb_Away_Score.Text);
            if (m_CurMatchRule.m_bNeedAllSplitsCompleted)
            {
                if (scoreA + scoreB < m_nTeamSplitCount)
                {
                    if (DialogResult.Cancel == DevComponents.DotNetBar.MessageBoxEx.Show("The game score is not match the rule!Do you really confirm to change status?", "OVRPlugin", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning))
                    {
                        return;
                    }
                }
            }
            else
            {
                int winScore = 0;
                //团队赛则判断split，个人赛判断Game
                if (m_nCurMatchType == 3)
                {
                    winScore = m_nTeamSplitCount / 2 + 1;
                }
                else
                {
                    winScore = m_nGamesCount / 2 + 1;
                }

                if (scoreA != winScore && scoreB != winScore)
                {
                    if (DialogResult.Cancel == DevComponents.DotNetBar.MessageBoxEx.Show("The game score is not match the rule!Do you really confirm to change status?", "OVRPlugin", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning))
                    {
                        return;
                    }
                }
            }
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, BDCommon.g_adoDataBase.m_dbConnect, BDCommon.g_BDPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Finished_Click(object sender, EventArgs e)
        {
            int scoreA = Convert.ToInt32(lb_Home_Score.Text);
            int scoreB = Convert.ToInt32(lb_Away_Score.Text);
            //检查规则和比分，如果比分不适合结束则给出警告提示
            if (m_CurMatchRule.m_bNeedAllSplitsCompleted)
            {
                if (scoreA + scoreB < m_nTeamSplitCount)
                {
                    if (DialogResult.Cancel == DevComponents.DotNetBar.MessageBoxEx.Show("The game score is not match the rule!Do you really confirm to change status?", "OVRPlugin", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning))
                    {
                        return;
                    }
                }
            }
            else
            {
                int winScore = 0;
                //团队赛则判断split，个人赛判断Game
                if (m_nCurMatchType == 3)
                {
                    winScore = m_nTeamSplitCount / 2 + 1;
                }
                else
                {
                    winScore = m_nGamesCount / 2 + 1;
                }
                if (scoreA != winScore && scoreB != winScore)
                {
                    if (DialogResult.Cancel == DevComponents.DotNetBar.MessageBoxEx.Show("The game score is not match the rule!Do you really confirm to change status?", "OVRPlugin", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning))
                    {
                        return;
                    }
                }
            }
            m_nCurStatusID = BDCommon.STATUS_FINISHED;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, BDCommon.g_adoDataBase.m_dbConnect, BDCommon.g_BDPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Revision_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = BDCommon.STATUS_REVISION;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, BDCommon.g_adoDataBase.m_dbConnect, BDCommon.g_BDPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Canceled_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = BDCommon.STATUS_CANCELED;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, BDCommon.g_adoDataBase.m_dbConnect, BDCommon.g_BDPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }
        #endregion

        private void rad_ServerA_CheckedChanged(object sender, EventArgs e)
        {
            RadioButton rbtn = (RadioButton)sender;
            if (!rbtn.Checked) return;

            m_bBService = false;
            m_bAService = true;
            UpdateService(false);

            if (m_nCurGameID > 0)
            {
                if (IsDouble())
                {
                    BDCommon.g_ManageDB.InitDoubleAcitonList(m_nCurMatchID, m_nCurGameID, 1, m_nDoubleRegisterA1, m_nDoubleRegisterB1);
                }
                else
                {
                    BDCommon.g_ManageDB.InitDoubleAcitonList(m_nCurMatchID, m_nCurGameID, 1, m_nRegIDA, m_nRegIDB);
                }
            }
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress, -1, -1, -1, m_nCurMatchID, -1, null);
            OutputXmlToXuNi(m_nCurMatchID);
        }

        private void rad_ServerB_CheckedChanged(object sender, EventArgs e)
        {
            RadioButton rbtn = (RadioButton)sender;
            if (!rbtn.Checked) return;

            m_bAService = false;
            m_bBService = true;
            UpdateService(false);


            if (m_nCurGameID > 0)
            {
                if (IsDouble())
                {
                    BDCommon.g_ManageDB.InitDoubleAcitonList(m_nCurMatchID, m_nCurGameID, 2, m_nDoubleRegisterA1, m_nDoubleRegisterB1);
                }
                else
                {
                    BDCommon.g_ManageDB.InitDoubleAcitonList(m_nCurMatchID, m_nCurGameID, 2, m_nRegIDA, m_nRegIDB);
                }
            }
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress, -1, -1, -1, m_nCurMatchID, -1, null);
            OutputXmlToXuNi(m_nCurMatchID);
        }

        private void rad_AllGames_CheckedChanged(object sender, EventArgs e)
        {
            // Get Offset and checked RadioButton
            RadioButton rbtn = (RadioButton)sender;
            if (!rbtn.Checked) return;
            String rbtnName = rbtn.Name;
            char chEndNum = rbtnName[rbtnName.Length - 1];
            Int32 nOffset = Convert.ToInt32(chEndNum.ToString()) - 1;
            if (nOffset < 0 || nOffset > m_naGameIDs.Count) return;

            // Set Current Game info
            m_rbtnCurChkedGame = rbtn;
            m_nCurGameOffset = nOffset;
            m_nCurGameID = (Int32)m_naGameIDs[nOffset];

            // 
            if (m_nCurMatchType != BDCommon.MATCH_TYPE_TEAM)
            {
                InitPlayerInfo();
                GetAllGamesResultFromDB();
            }
            else
            {
                if (IsDouble())
                {
                    String strEditVarNameA = "lb_A_Game" + (m_nCurGameOffset + 1).ToString();
                    String strEditVarNameB = "lb_B_Game" + (m_nCurGameOffset + 1).ToString();

                    Type dlgType = typeof(frmOVRBDDataEntry);
                    Label editBoxA = (Label)ReflectVar(dlgType, strEditVarNameA);
                    Label editBoxB = (Label)ReflectVar(dlgType, strEditVarNameB);
                    if (editBoxA != null && editBoxB != null)
                    {
                        if (editBoxA.Text == "0" && editBoxB.Text == "0")
                        {
                            rad_ServerA.Enabled = true;
                            rad_ServerB.Enabled = true;
                            rad_ServerA.Checked = false;
                            rad_ServerB.Checked = false;
                        }
                    }
                }

            }
            UpdateService(true);
            UpdateAllMatchSplitStatus(BDCommon.STATUS_RUNNING);

            if (m_nCurGameID > 0)
            {
                if (rad_ServerA.Checked)
                {
                    if (IsDouble())
                    {
                        BDCommon.g_ManageDB.InitDoubleAcitonList(m_nCurMatchID, m_nCurGameID, 1, m_nDoubleRegisterA1, m_nDoubleRegisterB1);
                    }
                    else
                    {
                        BDCommon.g_ManageDB.InitDoubleAcitonList(m_nCurMatchID, m_nCurGameID, 1, m_nRegIDA, m_nRegIDB);
                    }
                }
                if (rad_ServerB.Checked)
                {
                    if (IsDouble())
                    {
                        BDCommon.g_ManageDB.InitDoubleAcitonList(m_nCurMatchID, m_nCurGameID, 2, m_nDoubleRegisterA1, m_nDoubleRegisterB1);
                    }
                    else
                    {
                        BDCommon.g_ManageDB.InitDoubleAcitonList(m_nCurMatchID, m_nCurGameID, 2, m_nRegIDA, m_nRegIDB);
                    }
                }

                BDCommon.g_ManageDB.SetCurrentSplitFlag(m_nCurMatchID, m_nCurGameID, 2);
            }
            //if (IsDouble() && m_nCurGameID > 0)
            //{
            //    if ( rad_ServerA.Checked )
            //    {
            //        BDCommon.g_ManageDB.InitDoubleAcitonList(m_nCurMatchID, m_nCurGameID, 1, m_nDoubleRegisterA1, m_nDoubleRegisterB1);
            //    }
            //    if ( rad_ServerB.Checked)
            //    {
            //        BDCommon.g_ManageDB.InitDoubleAcitonList(m_nCurMatchID, m_nCurGameID, 2, m_nDoubleRegisterA1, m_nDoubleRegisterB1);
            //    }

            //}


            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress, -1, -1, -1, m_nCurMatchID, -1, null);
            OutputXmlToXuNi(m_nCurMatchID);
        }

        private void rad_AllSplits_CheckedChanged(object sender, EventArgs e)
        {
            // Get Offset and checked RadioButton
            DevComponents.DotNetBar.ButtonX rbtn = (DevComponents.DotNetBar.ButtonX)sender;
            String rbtnName = rbtn.Name;
            char chEndNum = rbtnName[rbtnName.Length - 1];
            Int32 nOffset = Convert.ToInt32(chEndNum.ToString()) - 1;
            if (nOffset < 0 || nOffset > m_naTeamSplitIDs.Count) return;

            m_rbtnCurChkedSplit = rbtn;
            m_nCurSplitOffset = nOffset;

            ChangeTeamSplit(nOffset);

            if (BDCommon.g_ManageDB.IsDoubleMatch(m_nCurMatchID, (int)(m_naTeamSplitIDs[m_nCurSplitOffset])) == 1)
            {
                System.Diagnostics.Trace.WriteLine("设置比赛状态为double");
                m_bIsDoubleMatch = true;
                List<int> ids = new List<int>();
                if (BDCommon.g_ManageDB.GetDoubleMatchPlayerIDs(m_nCurMatchID, ref ids, (int)(m_naTeamSplitIDs[m_nCurSplitOffset])))
                {
                    m_nDoubleRegisterA1 = ids[0];
                    m_nDoubleRegisterA2 = ids[1];
                    m_nDoubleRegisterB1 = ids[2];
                    m_nDoubleRegisterB2 = ids[3];
                }
                else
                {
                    MessageBox.Show("Get double match players' id failed!");
                }
            }
            else
            {
                System.Diagnostics.Trace.WriteLine("设置比赛状态为single");
                m_bIsDoubleMatch = false;
            }
            BDCommon.g_ManageDB.SetCurrentSplitFlag(m_nCurMatchID, (int)(m_naTeamSplitIDs[m_nCurSplitOffset]), 2);//设置比赛运行状态
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress, -1, -1, -1, m_nCurMatchID, -1, null);
            OutputXmlToXuNi(m_nCurMatchID);
        }

        #region Change Competition score operation
        private void btnx_Home_Add_Click(object sender, EventArgs e)
        {
            Int32 nHomeTScore = Convert.ToInt32(lb_Home_Score.Text);
            Int32 nAwayTScore = Convert.ToInt32(lb_Away_Score.Text);

            if (m_CurMatchRule.IsMatchScoreFinished(nHomeTScore, nAwayTScore)) return;

            Int32 nNewHomeScore = nHomeTScore + 1; // Add Score
            if (m_CurMatchRule.UpdateMatchResultsToDB(nNewHomeScore, nAwayTScore, m_nRegAPos, m_nRegBPos))
            {
                lb_Home_Score.Text = nNewHomeScore.ToString();
                UI_MatchScoreToGamesTotal();
            }
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress, -1, -1, -1, m_nCurMatchID, -1, null);
            OutputXmlToXuNi(m_nCurMatchID);
        }

        private void btnx_Home_Sub_Click(object sender, EventArgs e)
        {
            Int32 nHomeTScore = Convert.ToInt32(lb_Home_Score.Text);
            Int32 nAwayTScore = Convert.ToInt32(lb_Away_Score.Text);

            if (nHomeTScore <= 0) return;

            Int32 nNewHomeScore = nHomeTScore - 1; // Sub Score
            if (m_CurMatchRule.UpdateMatchResultsToDB(nNewHomeScore, nAwayTScore, m_nRegAPos, m_nRegBPos))
            {
                lb_Home_Score.Text = nNewHomeScore.ToString();
                UI_MatchScoreToGamesTotal();
            }
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress, -1, -1, -1, m_nCurMatchID, -1, null);
            OutputXmlToXuNi(m_nCurMatchID);
        }

        private void btnx_Away_Add_Click(object sender, EventArgs e)
        {
            Int32 nHomeTScore = Convert.ToInt32(lb_Home_Score.Text);
            Int32 nAwayTScore = Convert.ToInt32(lb_Away_Score.Text);

            if (m_CurMatchRule.IsMatchScoreFinished(nHomeTScore, nAwayTScore)) return;

            Int32 nNewAwayScore = nAwayTScore + 1; // Add Score
            if (m_CurMatchRule.UpdateMatchResultsToDB(nHomeTScore, nNewAwayScore, m_nRegAPos, m_nRegBPos))
            {
                lb_Away_Score.Text = nNewAwayScore.ToString();
                UI_MatchScoreToGamesTotal();
            }
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress, -1, -1, -1, m_nCurMatchID, -1, null);
            OutputXmlToXuNi(m_nCurMatchID);
        }

        private void btnx_Away_Sub_Click(object sender, EventArgs e)
        {
            Int32 nHomeTScore = Convert.ToInt32(lb_Home_Score.Text);
            Int32 nAwayTScore = Convert.ToInt32(lb_Away_Score.Text);

            if (nAwayTScore <= 0) return;

            Int32 nNewAwayScore = nAwayTScore - 1; // Sub Score
            if (m_CurMatchRule.UpdateMatchResultsToDB(nHomeTScore, nNewAwayScore, m_nRegAPos, m_nRegBPos))
            {
                lb_Away_Score.Text = nNewAwayScore.ToString();
                UI_MatchScoreToGamesTotal();
            }
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress, -1, -1, -1, m_nCurMatchID, -1, null);
            OutputXmlToXuNi(m_nCurMatchID);
        }

        private void btnx_A_ADD_Click(object sender, EventArgs e)
        {
            // Get Current selected Game Edit 
            Int32 nOffset = m_nCurGameOffset;
            if (nOffset < 0 || nOffset > m_naGameIDs.Count) return;

            Label plbGameA = (Label)ReflectVar(GetType(), "lb_A_Game" + (nOffset + 1).ToString());
            Label plbGameB = (Label)ReflectVar(GetType(), "lb_B_Game" + (nOffset + 1).ToString());
            if (plbGameA == null || plbGameB == null) return;

            Int32 nResultA = BDCommon.Str2Int(plbGameA.Text);
            Int32 nResultB = BDCommon.Str2Int(plbGameB.Text);

            // If Result is Finished then not Add any more
            if (m_CurMatchRule.IsGameScoreFinished(nResultA, nResultB)) return;

            if (!rad_ServerA.Checked && !rad_ServerB.Checked)
            {
                MessageBox.Show("You must select service side first!");
                return;
            }

            // Write to DB, if failure then recover
            if (!SetCurOneGameResultToDB(nResultA + 1, nResultB)) return;
            plbGameA.Text = (nResultA + 1).ToString();

            //统计得分历程


            AddActionList(m_nRegAPos, m_nRegIDA, nResultA + 1, nResultB, nResultA + 1);


            // Update Game status and serve status
            if (m_CurMatchRule.IsGameScoreFinished(nResultA + 1, nResultB))
            {
                UpdateAllMatchSplitStatus(BDCommon.STATUS_FINISHED);

                // Clear serve status
                EnableServiceRbtn(true, true);
                UpdateService(false);
            }
            else
            {
                // Change the Service status
                if (m_CurMatchRule.m_bScoredOwnServe)
                {
                    rad_ServerA.Checked = true;
                }
                else//乒乓球换发规则
                {
                    ServiceType type = ServiceType.TypeServiceNULL;
                    if (rad_ServerA.Checked)
                    {
                        type = ServiceType.TypeServiceA;
                    }
                    else if (rad_ServerB.Checked)
                    {
                        type = ServiceType.TypeServiceB;
                    }
                    ServiceType adviseType = OVRBDRule.GetTableTennisService(type, nResultA + 1, nResultB);
                    if (adviseType == ServiceType.TypeServiceA)
                    {
                        rad_ServerA.Checked = true;
                    }
                    else if (adviseType == ServiceType.TypeServiceB)
                    {
                        rad_ServerB.Checked = true;
                    }
                }
            }

            if (IsDouble())
            {
                if (plbGameA.Text != "0" || plbGameB.Text != "0")
                {
                    rad_ServerA.Enabled = false;
                    rad_ServerB.Enabled = false;
                }
            }
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            OutputXmlToXuNi(m_nCurMatchID);
        }

        private void btnx_A_SUB_Click(object sender, EventArgs e)
        {
            // Get Current selected Game Edit 
            if (IsDouble())
            {
                int pos = BDCommon.g_ManageDB.GetDoubleLastActionPos(m_nCurMatchID, m_nCurGameID);
                if (pos == -1)
                {
                    MessageBox.Show("GetDoubleLastActionPos error!");
                    return;
                }
                if (pos == 2)
                {
                    btnx_B_SUB_Click(null, null);
                    return;
                }
            }
            Int32 nOffset = m_nCurGameOffset;
            if (nOffset < 0 || nOffset > m_naGameIDs.Count) return;

            Label pEditGameA = (Label)ReflectVar(GetType(), "lb_A_Game" + (nOffset + 1).ToString());
            Label pEditGameB = (Label)ReflectVar(GetType(), "lb_B_Game" + (nOffset + 1).ToString());
            if (pEditGameA == null || pEditGameB == null) return;

            Int32 nResultA = BDCommon.Str2Int(pEditGameA.Text);
            Int32 nResultB = BDCommon.Str2Int(pEditGameB.Text);

            if (nResultA < 1) return;

            // Write to DB
            if (!SetCurOneGameResultToDB(nResultA - 1, nResultB)) return;
            pEditGameA.Text = (nResultA - 1).ToString();

            //删除得分历程
            DelActionList(m_nRegAPos, m_nRegIDA, nResultA);

            UpdateAllMatchSplitStatus(BDCommon.STATUS_RUNNING);

            if (IsDouble())
            {
                if ((nResultA - 1) == 0 && nResultB == 0)
                {
                    rad_ServerA.Enabled = true;
                    rad_ServerB.Enabled = true;
                }
            }
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            OutputXmlToXuNi(m_nCurMatchID);
        }



        private bool IsDouble()
        {
            return (m_bIsDoubleMatch && BDCommon.g_strDisplnCode == "BD");
        }

        private void btnx_B_ADD_Click(object sender, EventArgs e)
        {


            // Get Current selected Game Edit 
            Int32 nOffset = m_nCurGameOffset;
            if (nOffset < 0 || nOffset > m_naGameIDs.Count) return;

            Label plbGameA = (Label)ReflectVar(GetType(), "lb_A_Game" + (nOffset + 1).ToString());
            Label plbGameB = (Label)ReflectVar(GetType(), "lb_B_Game" + (nOffset + 1).ToString());
            if (plbGameA == null || plbGameB == null) return;

            Int32 nResultA = BDCommon.Str2Int(plbGameA.Text);
            Int32 nResultB = BDCommon.Str2Int(plbGameB.Text);

            // If Result is Finished then not Add any more
            if (m_CurMatchRule.IsGameScoreFinished(nResultA, nResultB)) return;

            if (!rad_ServerA.Checked && !rad_ServerB.Checked)
            {
                MessageBox.Show("You must select service side first!");
                return;
            }
            // Write to DB, if failure then recover
            if (!SetCurOneGameResultToDB(nResultA, nResultB + 1)) return;
            plbGameB.Text = (nResultB + 1).ToString();

            //统计得分历程
            AddActionList(m_nRegBPos, m_nRegIDB, nResultA, nResultB + 1, nResultB + 1);

            if (m_CurMatchRule.IsGameScoreFinished(nResultA, nResultB + 1))
            {
                UpdateAllMatchSplitStatus(BDCommon.STATUS_FINISHED);

                EnableServiceRbtn(true, true);
                UpdateService(false);
            }
            else
            {
                // Change the Service status
                if (m_CurMatchRule.m_bScoredOwnServe)
                {
                    rad_ServerB.Checked = true;
                }
                else
                {
                    ServiceType type = ServiceType.TypeServiceNULL;
                    if (rad_ServerA.Checked)
                    {
                        type = ServiceType.TypeServiceA;
                    }
                    else if (rad_ServerB.Checked)
                    {
                        type = ServiceType.TypeServiceB;
                    }
                    ServiceType adviseType = OVRBDRule.GetTableTennisService(type, nResultA + 1, nResultB);
                    if (adviseType == ServiceType.TypeServiceA)
                    {
                        rad_ServerA.Checked = true;
                    }
                    else if (adviseType == ServiceType.TypeServiceB)
                    {
                        rad_ServerB.Checked = true;
                    }
                }
            }
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            OutputXmlToXuNi(m_nCurMatchID);
        }

        private void btnx_B_SUB_Click(object sender, EventArgs e)
        {
            if (IsDouble())
            {
                int pos = BDCommon.g_ManageDB.GetDoubleLastActionPos(m_nCurMatchID, m_nCurGameID);
                if (pos == -1)
                {
                    MessageBox.Show("GetDoubleLastActionPos error!");
                    return;
                }
                if (pos == 1)
                {
                    btnx_A_SUB_Click(null, null);
                    return;
                }
            }
            // Get Current selected Game Edit 
            Int32 nOffset = m_nCurGameOffset;
            if (nOffset < 0 || nOffset > m_naGameIDs.Count) return;

            Label plbGameA = (Label)ReflectVar(GetType(), "lb_A_Game" + (nOffset + 1).ToString());
            Label plbGameB = (Label)ReflectVar(GetType(), "lb_B_Game" + (nOffset + 1).ToString());
            if (plbGameA == null || plbGameB == null) return;

            Int32 nResultA = BDCommon.Str2Int(plbGameA.Text);
            Int32 nResultB = BDCommon.Str2Int(plbGameB.Text);

            if (nResultB < 1) return;

            // Write to DB
            if (!SetCurOneGameResultToDB(nResultA, nResultB - 1)) return;
            plbGameB.Text = (nResultB - 1).ToString();

            //删除得分历程
            DelActionList(m_nRegBPos, m_nRegIDB, nResultB);

            UpdateAllMatchSplitStatus(BDCommon.STATUS_RUNNING);

            if (IsDouble())
            {
                if (nResultA == 0 && (nResultB - 1) == 0)
                {
                    rad_ServerA.Enabled = true;
                    rad_ServerB.Enabled = true;
                }
            }
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            OutputXmlToXuNi(m_nCurMatchID);
        }
        #endregion





        private void btnSendBye_Click(object sender, EventArgs e)
        {
            InputResults rslt = new InputResults();
            rslt.ShowDialog();
            return;//暂时用作比分扳的响应
            if (m_nCurMatchID <= 0)
            {
                MessageBox.Show("Current MatchID is less than zero");
                return;
            }
            int result = 0;
            List<int> matches = BDCommon.g_ManageDB.GetByeMatches(m_nCurMatchID, GetByeMatchType.GetByeTypeAll, out result);
            if (result == -1)
            {
                MessageBox.Show("There is no bye match under the same phase!");
                return;
            }
            else if (result == -4)
            {
                MessageBox.Show("GetByeMatches function catched an exception!");
                return;
            }
            else if (result == -3)
            {
                if (DialogResult.Cancel == MessageBox.Show("All bye-matches have been sent,do you want to send them again?", "OVRPlugin", MessageBoxButtons.OKCancel, MessageBoxIcon.Question))
                {
                    return;
                }
            }

            for (int i = 0; i < matches.Count; i++)
            {
                BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatus, -1, -1, -1, matches[i], null, null);
                if (!BDCommon.g_ManageDB.SetByeMatchSentFlag(matches[i]))
                {
                    MessageBox.Show(string.Format("Set bye match sent flag error!MatchID:{0} already send:{1}", matches[i], i));
                    return;
                }
            }

            MessageBox.Show(string.Format("Send succeed!Matches count:{0}", matches.Count));
        }




        private void OnChkManualMouseDown(object sender, MouseEventArgs e)
        {

        }

        private void OnChkManualChanged(object sender, EventArgs e)
        {
            DevComponents.DotNetBar.Controls.CheckBoxX chkBox = sender as DevComponents.DotNetBar.Controls.CheckBoxX;
            if (chkBox.Checked)
            {
                btnx_Split1.Enabled = true;
                btnx_Split2.Enabled = true;
                btnx_Split3.Enabled = true;
                btnx_Split4.Enabled = true;
                btnx_Split5.Enabled = true;
                rad_Game1.Enabled = true;
                rad_Game2.Enabled = true;
                rad_Game3.Enabled = true;
                rad_Game4.Enabled = true;
                rad_Game5.Enabled = true;
                rad_Game6.Enabled = true;
                rad_Game7.Enabled = true;
            }
            else
            {

            }
        }

        private void gb_Server_Enter(object sender, EventArgs e)
        {

        }

        private void chkEnableInputClicked(object sender, EventArgs e)
        {
            if (chkEnableInput.Checked)
            {
                EnableMatchAll(true, false);
            }
            else
            {
                EnableMatchAll(false, false);
            }
        }
        scoreFrame m_scoreFrame;
        private void btnScoreBoard_Click(object sender, EventArgs e)
        {
            if (m_scoreFrame == null)
            {
                m_scoreFrame = new scoreFrame();
                m_scoreFrame.Owner = this;
            }
            m_scoreFrame.Show();
            if (m_nCurMatchID > 0)
            {
                m_scoreFrame.UpdateUI(m_nCurMatchID);
            }

        }

        private void delMatchActionList(object sender, EventArgs e)
        {
            if (m_nCurMatchID < 1)
            {
                MessageBox.Show("没有选择比赛！");
                return;
            }
            DeleteActionFrame frame = new DeleteActionFrame();
            frame.SelSetNo = -1;
            if (m_bIsTeamMatch)
            {

                if (frame.ShowDialog() != DialogResult.OK)
                {
                    return;
                }
            }
            if (DialogResult.Cancel == MessageBox.Show(string.Format("确定要删除比赛{0}的历程吗？", m_nCurMatchID), "提示", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning))
            {
                return;
            }
            if (BDCommon.g_ManageDB.DeleteMatchActionList(m_nCurMatchID, frame.SelSetNo))
            {
                MessageBox.Show("删除成功！");
                return;
            }
            else
            {
                MessageBox.Show("删除失败！");
                return;
            }
        }

        private void lbClientForControl_Click(object sender, EventArgs e)
        {
            int selCount = lbClientForControl.SelectedItems.Count;
            if (selCount == 0)
            {
                lbTransSrc.Text = "";
                lbTransDst.Text = "";
            }
            else if (selCount == 1)
            {
                lbTransDst.Text = "";
                lbTransSrc.Text = "";
                lbTransSrc.Text = lbClientForControl.SelectedItems[0].ToString();
            }
            else
            {
                for (int i = 0; i < selCount; i++)
                {
                    string temp = lbClientForControl.SelectedItems[i].ToString();
                    if (temp != lbTransSrc.Text)
                    {
                        lbTransDst.Text = temp;
                        return;
                    }
                }
            }


        }

        private void btnTransMatchDataClick(object sender, EventArgs e)
        {
            if (lbClientForControl.SelectedItems.Count < 2)
            {
                MessageBox.Show("请选择要传输比赛数据的源地址和目标地址");
                return;
            }
            if (DialogResult.Cancel == MessageBox.Show("Are you confirm to translate data?", "Note", MessageBoxButtons.OKCancel, MessageBoxIcon.Question))
            {
                return;
            }
            string strSrc = (lbTransSrc.Text.Split('('))[0];
            string strDst = (lbTransDst.Text.Split('('))[0];
            byte[] data = new byte[1];//作为服务器消息时，为占位符号
            MemoryStream memStream = new MemoryStream();
            BinaryWriter writer = new BinaryWriter(memStream);
            writer.Write(BDCommon.MSG_FLAG_TRANS_DATA);
            writer.Write(true);//来自服务器
            writer.Write(strSrc);
            writer.Write(strDst);
            writer.Write((int)-1);//matchID，来自服务器的忽略
            writer.Write(data.Length);
            writer.Write(data, 0, data.Length);
            byte[] sendData = memStream.ToArray();
            try
            {
                if (m_udpClient != null)
                {
                    m_udpClient.Send(sendData, sendData.Length, new IPEndPoint(IPAddress.Parse(strSrc), BDCommon.UDP_CTRL_PORT));
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
            writer.Close();
            memStream.Close();
        }

        //将比赛发送至指定计时计分端
        private void btnSendSetClicked(object sender, EventArgs e)
        {
            if (lbClientForControl.SelectedItems.Count < 1)
            {
                MessageBox.Show("请选择要发送比赛的目标地址");
                return;
            }
            string strDesAddr = (string)lbClientForControl.SelectedItem;
            if (m_nCurMatchID <= 0)
            {
                MessageBoxEx.Show("Please select a match first.");
                return;
            }
            btnSendSetFrm frm = new btnSendSetFrm(m_nCurMatchID, strDesAddr);
            if (DialogResult.Cancel == frm.ShowDialog())
            {
                return;
            }
            int matchID = frm.SelMatchID;
            int splitID = frm.SelMatchSplitID;

            MemoryStream memStream = new MemoryStream();
            BinaryWriter writer = new BinaryWriter(memStream);
            writer.Write(BDCommon.MSG_FLAG_SEND_SET);
            writer.Write(matchID);
            writer.Write(splitID);
            byte[] sendData = memStream.ToArray();
            try
            {
                if (m_udpClient != null)
                {
                    m_udpClient.Send(sendData, sendData.Length, new IPEndPoint(IPAddress.Parse(frm.IPAddr), BDCommon.UDP_CTRL_PORT));
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
            writer.Close();
            memStream.Close();
        }

        private void btnImportTempDataClicked(object sender, EventArgs e)
        {
            if (m_nCurMatchID <= 0)
            {
                MessageBoxEx.Show("Please select a match first.");
                return;
            }
            frmImportTempData frmImport = new frmImportTempData(m_nCurMatchID);
            frmImport.ShowDialog();
        }

        private void dgvSubEventOrder_Click(object sender, EventArgs e)
        {
            lstEventOrder.Items.Clear();
            lbSelGender.Text = "";
            if (dgvSubEventOrder.SelectedRows.Count > 0)
            {
                DataGridViewRow dgvr = dgvSubEventOrder.SelectedRows[0];
                string strEvents = dgvr.Cells[1].Value.ToString();
                string gender = dgvr.Cells[2].Value.ToString();
                lbSelGender.Text = gender;
                string[] events = strEvents.Split(',');
                foreach (string s in events)
                {
                    lstEventOrder.Items.Add(s);
                }
            }

        }

        private void btnSubEventUpDown_Click(object sender, EventArgs e)
        {
            ButtonX button = sender as ButtonX;
            if (
                (button.Tag.ToString() == "up" && lstEventOrder.SelectedIndex < 1)
                ||
                (button.Tag.ToString() == "down" && lstEventOrder.SelectedIndex == lstEventOrder.Items.Count - 1)
               )
            {
                return;
            }
            int curIndex = lstEventOrder.SelectedIndex;
            int moveToIndex = (button.Tag.ToString() == "up") ? curIndex - 1 : curIndex + 1;
            string strTemp = (string)lstEventOrder.Items[curIndex];
            lstEventOrder.Items[curIndex] = lstEventOrder.Items[moveToIndex];
            lstEventOrder.Items[moveToIndex] = strTemp;

            string strRes = "";
            foreach (string s in lstEventOrder.Items)
            {
                strRes += s;
                strRes += ",";
            }
            strRes = strRes.TrimEnd(',');
            int eventID = Convert.ToInt32(dgvSubEventOrder.SelectedRows[0].Cells[0].Value);

            if (BDCommon.g_ManageDB.SetTeamSubEventOrder(eventID, strRes))
            {
                DataTable dt = BDCommon.g_ManageDB.GetTeamSubEventOrder();
                OVRDataBaseUtils.FillDataGridView(dgvSubEventOrder, dt);
            }
            //设置选中关系
            dgvSubEventOrder.ClearSelection();
            foreach (DataGridViewRow dgvr in dgvSubEventOrder.Rows)
            {
                if (Convert.ToInt32(dgvr.Cells[0].Value) == eventID)
                {
                    dgvr.Selected = true;
                    break;
                }
            }
            lstEventOrder.SelectedIndex = moveToIndex;
        }

        private bool SetMatchAutoScore(MatchScore matchScore)
        {
            if (!BDCommon.g_ManageDB.Test_SetMatchResult(m_nCurMatchID, ScoreType.MatchScore, 1, 0, matchScore.MatchScoreA, matchScore.MatchScoreB, (WinnerType)matchScore.Winner))
            {
                MessageBoxEx.Show("Set match score failed!");
                return false;
            }
            for (int i = 0; i < matchScore.Count; i++)
            {
                SetScore setScore = matchScore[i];
                if (!BDCommon.g_ManageDB.Test_SetMatchResult(m_nCurMatchID, ScoreType.SetScore, i + 1, 0, setScore.SetScoreA, setScore.SetScoreB, (WinnerType)setScore.Winner))
                {
                    MessageBoxEx.Show("Set set score failed!");
                    return false;
                }
                for (int j = 0; j < setScore.Count; j++)
                {
                    GameScore gs = setScore[j];
                    if (!BDCommon.g_ManageDB.Test_SetMatchResult(m_nCurMatchID, ScoreType.GameScore, i + 1, j + 1, gs.GameScoreA, gs.GameScoreB, (WinnerType)gs.Winner))
                    {
                        MessageBoxEx.Show("Set game score failed!");
                        return false;
                    }
                }
            }
            return true;
        }

        private bool SetMatchAutoScore(SetScore setScore)
        {
            if (!BDCommon.g_ManageDB.Test_SetMatchResult(m_nCurMatchID, ScoreType.SetScore, 1, 0, setScore.SetScoreA, setScore.SetScoreB, (WinnerType)setScore.Winner))
            {
                MessageBoxEx.Show("Set set score failed!");
                return false;
            }
            for (int i = 0; i < setScore.Count; i++)
            {
                GameScore gs = setScore[i];
                if (!BDCommon.g_ManageDB.Test_SetMatchResult(m_nCurMatchID, ScoreType.GameScore, 0, i + 1, gs.GameScoreA, gs.GameScoreB, (WinnerType)gs.Winner))
                {
                    MessageBoxEx.Show("Set game score failed!");
                    return false;
                }
            }
            return true;
        }

        private void btnx_AutoGenerateScore(object sender, EventArgs e)
        {
            if (m_nCurMatchID <= 0)
            {
                MessageBoxEx.Show("Please enter a match first!");
                return;
            }

            if (!BDCommon.g_ManageDB.InitMatchSplitType(m_nCurMatchID))
            {
                MessageBoxEx.Show("Set sub split type failed!");
                return;
            }

            if (!BDCommon.g_ManageDB.SetTeamPlayersForTest(m_nCurMatchID))
            {
                MessageBoxEx.Show("Set Team players failed!");
                return;
            }

            if (!BDCommon.g_ManageDB.ClearMatchScore(m_nCurMatchID))
            {
                MessageBoxEx.Show("Clear old match score failed!");
                return;
            }
            string matchScoreA = "";
            string matchScoreB = "";
            AutoGenerateScore autoGenerate = new AutoGenerateScore(m_bIsTeamMatch, m_CurMatchRule.m_bNeedAllSplitsCompleted, m_nTeamSplitCount, m_nGamesCount, m_CurMatchRule.m_nGamePoint);
            if (m_bIsTeamMatch)
            {
                MatchScore matchScore = autoGenerate.GetRandomScoreTeam();
                if (!SetMatchAutoScore(matchScore))
                {
                    return;
                }
                matchScoreA = matchScore.MatchScoreA.ToString();
                matchScoreB = matchScore.MatchScoreB.ToString();
            }
            else
            {
                SetScore setScore = autoGenerate.GetRandomScoreSet();
                if (!SetMatchAutoScore(setScore))
                {
                    return;
                }
                matchScoreA = setScore.SetScoreA.ToString();
                matchScoreB = setScore.SetScoreB.ToString();
            }

            m_nCurStatusID = BDCommon.STATUS_FINISHED;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, BDCommon.g_adoDataBase.m_dbConnect, BDCommon.g_BDPlugin);
            if (iResult == 1) UpdateMatchStatus();

            lb_Home_Score.Text = matchScoreA;
            lb_Away_Score.Text = matchScoreB;

            MessageBoxEx.Show("Auto set match score succeed!");

            InitVariants();
            m_nCurMatchID = -1;
            m_bIsRunning = false;

            EnableMatchCtrlBtn(false);
            EnableMatchAll(false, true);
            EnableAutoData(true);
            lbCourtName.Text = "";
            lbMatchID.Text = "";
            lbMatchRsc.Text = "";
            chkEnableInput.Checked = false;
            chkEnableInput.Enabled = false;
        }

        private void btnDayStatusRefresh_Click(object sender, EventArgs e)
        {
            DataTable dt = BDCommon.g_ManageDB.GetDayStatusForTesting();
            OVRDataBaseUtils.FillDataGridView(dgDayStatus, dt);
        }

        private void btnDayStatusSet_Click(object sender, EventArgs e)
        {
            if (dgDayStatus.SelectedRows.Count == 0)
            {
                MessageBoxEx.Show("Please select days which you want to change.");
                return;
            }

            if (MessageBoxEx.Show("This is an unrecoverable operation! Are you sure to continue?", "Warnning", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) == DialogResult.Cancel)
            {
                return;
            }
            ButtonX btn = sender as ButtonX;
            int status = Convert.ToInt32(btn.Tag);
            foreach (DataGridViewRow dgvr in dgDayStatus.SelectedRows)
            {
                int dayID = Convert.ToInt32(dgvr.Cells[0].Value);
                if (!BDCommon.g_ManageDB.SetDayStatusForTest(dayID, status))
                {
                    MessageBoxEx.Show("Change status failed!");
                    break;
                }
            }
            btnDayStatusRefresh_Click(null, null);
        }

        private void dgDayStatus_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            if (e.ColumnIndex == 2 && e.Value != null)
            {
                switch (e.Value.ToString())
                {
                    case "Schedule":
                        e.CellStyle.SelectionForeColor = Color.Blue;
                        e.CellStyle.ForeColor = Color.Blue;
                        break;
                    case "Running":
                        e.CellStyle.SelectionForeColor = Color.Red;
                        e.CellStyle.ForeColor = Color.Red;
                        break;
                    case "Official":
                        e.CellStyle.SelectionForeColor = Color.Green;
                        e.CellStyle.ForeColor = Color.Green;
                        break;
                }
            }

        }
        SelfCheckErrorFrm m_checkFrm;
        private void btnSelfCheckErrorClick(object sender, EventArgs e)
        {
            if (m_checkFrm == null)
            {
                m_checkFrm = new SelfCheckErrorFrm();
                m_checkFrm.Owner = this;
            }

            m_checkFrm.Show();
            m_checkFrm.WindowState = FormWindowState.Normal;
            m_checkFrm.Activate();
        }

        private void btnx_delMatchRes(object sender, EventArgs e)
        {
            if (m_nCurMatchID <= 0)
            {
                MessageBoxEx.Show("Please enter a match first.");
                return;
            }
            if (MessageBoxEx.Show("Are you sure to delete match result?", "warning", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) == DialogResult.Cancel)
            {
                return;
            }

            if (BDCommon.g_ManageDB.ClearMatchResult(m_nCurMatchID))
            {
                //清空临时比赛数据
                if (m_bIsTeamMatch)
                {
                    string strMatchID = m_nCurMatchID.ToString();
                    strMatchID = strMatchID.PadLeft(5, '0');
                    string[] strFiles = Directory.GetFiles(BDCommon.GetTempMatchDir(), string.Format("9?{0}_*.xml", strMatchID));
                    foreach (string strFilePath in strFiles)
                    {
                        try
                        {
                            File.Delete(strFilePath);
                        }
                        catch
                        {
                        	
                        }
                    }
                }
                m_nCurStatusID = BDCommon.STATUS_SCHEDULE;

                List<OVRDataChanged> changedList = new List<OVRDataChanged>();
                changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchStatus, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null));
                BDCommon.g_BDPlugin.DataChangedNotify(changedList);
                UpdateMatchStatus(false);
                MessageBoxEx.Show("Clear result succeed.");


                InitVariants();
                m_nCurMatchID = -1;
                m_bIsRunning = false;
                m_nCurStatusID = BDCommon.STATUS_FINISHED;

                EnableMatchCtrlBtn(false);
                EnableMatchAll(false, true);
                EnableAutoData(true);
                lbCourtName.Text = "";
                lbMatchID.Text = "";
                lbMatchRsc.Text = "";
                chkEnableInput.Checked = false;
                chkEnableInput.Enabled = false;
            }
            else
            {
                MessageBoxEx.Show("Clear result failed.");
            }
        }


        private void gb_MatchInfo_Enter(object sender, EventArgs e)
        {

        }





    }
}
