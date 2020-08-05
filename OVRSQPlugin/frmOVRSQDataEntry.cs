using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Xml;
using System.Collections;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using System.Text.RegularExpressions;
using System.Threading;

namespace AutoSports.OVRSQPlugin
{
    public delegate void SetTextBoxMsg(String strMsg);

    public partial class frmOVRSQDataEntry : Office2007Form
    {
        public frmOVRSQDataEntry()
        {
            InitializeComponent();
        }

        private void frmOVRSQDataEntry_Load(object sender, EventArgs e)
        {
            EnableMatchCtrlBtn(false);
            EnableMatchAll(false, true);
            EnableExportImport(false);

            Localization();
            SQCommon.g_ManageDB.InitGame();

            if (m_nCurMatchID > 0)
            {
                StartMatch();
            }
        }

        private void Localization()
        {
            gb_MatchInfo.Text = LocalizationRecourceManager.GetString(strSectionName, "gbMatchInfo");
            gb_MatchResult.Text = LocalizationRecourceManager.GetString(strSectionName, "gbMatchScore");
            lb_Sport.Text = LocalizationRecourceManager.GetString(strSectionName, "lbSportName");
            lb_Phase.Text = LocalizationRecourceManager.GetString(strSectionName, "lbPhaseName");
            lb_Date.Text = LocalizationRecourceManager.GetString(strSectionName, "lbDate");
            lb_Venue.Text = LocalizationRecourceManager.GetString(strSectionName, "lbVenue");
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
            btnx_Match1.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxMatch1");
            btnx_Match2.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxMatch2");
            btnx_Match3.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxMatch3");
            btnx_Match4.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxMatch4");
            btnx_Match5.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxMatch5");
            rad_ServerA.Text = LocalizationRecourceManager.GetString(strSectionName, "radServerA");
            rad_ServerB.Text = LocalizationRecourceManager.GetString(strSectionName, "radServerB");
            btnx_SubMatch_Result.Text = LocalizationRecourceManager.GetString(strSectionName, "SubMatchResult");
            btnx_Game_Result.Text = LocalizationRecourceManager.GetString(strSectionName, "GameResult");
            rad_Game1.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame1");
            rad_Game2.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame2");
            rad_Game3.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame3");
            rad_Game4.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame4");
            rad_Game5.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame5");
            gb_ImportResult.Text = LocalizationRecourceManager.GetString(strSectionName, "gbExportImport");
            lb_SelectDate.Text = LocalizationRecourceManager.GetString(strSectionName, "lbSelectDate");
            lb_ExportPath.Text = LocalizationRecourceManager.GetString(strSectionName, "lbExportPath");
            btnxExAthlete.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxExportAthlete");
            btnxExSchedule.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxExportSchedule");
            lb_ImportPath.Text = LocalizationRecourceManager.GetString(strSectionName, "lbImportPath");
            btnxImportMatchInfo.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxImportMatchInfo");
            btnxImportAction.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxImportAction");
            chkAutoImport.Text = LocalizationRecourceManager.GetString(strSectionName, "chkAutoImport");
            chkOuterData.Text = LocalizationRecourceManager.GetString(strSectionName, "chkExternalData");
            lb_ImportFile.Text = LocalizationRecourceManager.GetString(strSectionName, "lbImportFile");
            btnxImportMatchResult.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxImportResult");
        }

        public void OnMsgFlushSelMatch(Int32 nWndMode, Int32 nMatchID)
        {
            // Is Running 
            if (m_bIsRunning)
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbRunningMatch"));
                return;
            }

            // Not valid MatchID
            if (nMatchID <= 0)
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbChooseMatch"));
                return;
            }

            m_nCurMatchID = nMatchID;
            m_nWndMode = nWndMode;
            m_nCurStatusID = SQCommon.g_ManageDB.GetMatchStatus(m_nCurMatchID);
            Int32 nRegAID, nRegBID;
            SQCommon.g_ManageDB.GetMatchMember(m_nCurMatchID, out nRegAID, out nRegBID);

            // Not valid Status
            if (m_nCurStatusID == SQCommon.STATUS_RUNNING || m_nCurStatusID == SQCommon.STATUS_REVISION)
            {
                String strStauts = SQCommon.g_ManageDB.GetStatusName(m_nCurStatusID);
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbMatchStatus") + strStauts);
                return;
            }
            // Not valid player
            if (nRegAID <= 0 || nRegBID <= 0)
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbConfigMatchUp"));
                return;
            }

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
                InitVariant();
                m_nCurMatchID = -1;
                m_bIsRunning = false;

                EnableMatchCtrlBtn(false);
                EnableMatchAll(false, true);
                EnableAutoData(true);
            }
        }

        private void btnx_Modify_Result_Click(object sender, EventArgs e)
        {
            frmModifyResult frmMatchResult = new frmModifyResult(m_nCurMatchID, -1);
            frmMatchResult.ShowDialog();

            String strHomeSet, strAwaySet;

            if (SQCommon.g_ManageDB.GetContestResult(m_nCurMatchID, out strHomeSet, out strAwaySet))
            {
                lb_Home_Score.Text = strHomeSet.Equals("") ? "0" : strHomeSet;
                lb_Away_Score.Text = strAwaySet.Equals("") ? "0" : strAwaySet;

                if (m_nCurStatusID == SQCommon.STATUS_RUNNING || m_nCurStatusID == SQCommon.STATUS_REVISION)
                {
                    UpdateSetsResult(true);
                }
            }

            SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void btnx_StartList_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = SQCommon.STATUS_STARTLIST;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SQCommon.g_adoDataBase.m_dbConnect, SQCommon.g_SQPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Running_Click(object sender, EventArgs e)
        {
            // Auto Select 1st Split or 1st Set
            if (m_nCurMatchType == SQCommon.MATCH_TYPE_TEAM)
            {
                btnx_Match1.Checked = true;
                m_nCurSplitOffset = 0;
                if ( !ChangeTeamSplit(0) )
                    return;
            }
            else if (m_nCurMatchType == SQCommon.MATCH_TYPE_SINGLE)
            {
                rad_Game1.Checked = true;
                m_nCurSplitOffset = 0;
                m_nCurSetOffset = 0;
            }

            m_nCurStatusID = SQCommon.STATUS_RUNNING;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SQCommon.g_adoDataBase.m_dbConnect, SQCommon.g_SQPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Suspend_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = SQCommon.STATUS_SUSPEND;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SQCommon.g_adoDataBase.m_dbConnect, SQCommon.g_SQPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Unofficial_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = SQCommon.STATUS_UNOFFICIAL;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SQCommon.g_adoDataBase.m_dbConnect, SQCommon.g_SQPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Finished_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = SQCommon.STATUS_FINISHED;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SQCommon.g_adoDataBase.m_dbConnect, SQCommon.g_SQPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Revision_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = SQCommon.STATUS_REVISION;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SQCommon.g_adoDataBase.m_dbConnect, SQCommon.g_SQPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Canceled_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = SQCommon.STATUS_CANCELED;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SQCommon.g_adoDataBase.m_dbConnect, SQCommon.g_SQPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void rad_ServerA_CheckedChanged(object sender, EventArgs e)
        {
            RadioButton rbtn = (RadioButton)sender;
            if (!rbtn.Checked) return;

            m_bBService = false;
            m_bAService = true;            
            UpdateService(false);

            if (m_nServerType == SQCommon.SOS_TYPE_SCORE)
            {
                EnableASetAddSubBtn(true);
                EnableBSetAddSubBtn(false);
            }
        }

        private void rad_ServerB_CheckedChanged(object sender, EventArgs e)
        {
            RadioButton rbtn = (RadioButton)sender;
            if (!rbtn.Checked) return;

            m_bAService = false;
            m_bBService = true;
            UpdateService(false);

            if (m_nServerType == SQCommon.SOS_TYPE_SCORE)
            {
                EnableASetAddSubBtn(false);
                EnableBSetAddSubBtn(true);
            }
        }

        private void OnRbtnSetRange(object sender, EventArgs e)
        {
            // Get Offset and checked RadioButton
            RadioButton rbtn = (RadioButton)sender;
            if (!rbtn.Checked) return;
            String rbtnName = rbtn.Name;
            char chEndNum = rbtnName[rbtnName.Length - 1];
            Int32 nOffset = Convert.ToInt32(chEndNum.ToString()) - 1;
            if (nOffset < 0 || nOffset > m_naSetIDs.Count) return;

            m_rbtnCurChkedSet = rbtn;
            m_nCurSetOffset = nOffset;

            m_nCurSetID = (Int32)m_naSetIDs[nOffset];
            if (m_nCurMatchType != SQCommon.MATCH_TYPE_TEAM)
            {
                InitPlayerInfo();
                UpdateSetsResult(true);
            }

            UpdateService(true);
            UpdateSplitStatus(SQCommon.STATUS_RUNNING);
        }

        private void btnx_Official_Click(object sender, EventArgs e)
        {
            frmEntryOfficial frmOfficial = new frmEntryOfficial(m_nCurMatchID, m_nCurMatchType);
            frmOfficial.ShowDialog();
            SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emMatchOfficials, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void btnx_Team_Click(object sender, EventArgs e)
        {
            if (m_nCurMatchType != SQCommon.MATCH_TYPE_TEAM)
                return;

            frmSetTeamPlayer frmTeamPlayer = new frmSetTeamPlayer(m_nCurMatchID);
            frmTeamPlayer.ShowDialog();

            SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emSplitCompetitor, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void btnx_Home_Add_Click(object sender, EventArgs e)
        {
            Int32 nHomeTScore = Convert.ToInt32(lb_Home_Score.Text);
            Int32 nAwayTScore = Convert.ToInt32(lb_Away_Score.Text);

            if ((m_nCurMatchType == SQCommon.MATCH_TYPE_TEAM && SQCommon.g_bUseSplitsRule)
                || (m_nCurMatchType == SQCommon.MATCH_TYPE_SINGLE && SQCommon.g_bUseSetsRule))
            {
                if (ovrRule.IsMatchScoreFinished(nHomeTScore, nAwayTScore)) return;
            }

            Int32 nNewHomeScore = nHomeTScore + 1; // Add Score
            if (ovrRule.UpdateMatchResultToDB(nNewHomeScore, nAwayTScore, m_nRegAPos, m_nRegBPos))
            {
                lb_Home_Score.Text = nNewHomeScore.ToString();
                MatchScoreToSetsTotal();
            }
        }

        private void btnx_Home_Sub_Click(object sender, EventArgs e)
        {
            Int32 nHomeTScore = Convert.ToInt32(lb_Home_Score.Text);
            Int32 nAwayTScore = Convert.ToInt32(lb_Away_Score.Text);

            if (nHomeTScore <= 0)
                return;

            Int32 nNewHomeScore = nHomeTScore - 1; // Sub Score
            if (ovrRule.UpdateMatchResultToDB(nNewHomeScore, nAwayTScore, m_nRegAPos, m_nRegBPos))
            {
                lb_Home_Score.Text = nNewHomeScore.ToString();
                MatchScoreToSetsTotal();
            }
        }

        private void btnx_Away_Add_Click(object sender, EventArgs e)
        {
            Int32 nHomeTScore = Convert.ToInt32(lb_Home_Score.Text);
            Int32 nAwayTScore = Convert.ToInt32(lb_Away_Score.Text);

            if ((m_nCurMatchType == SQCommon.MATCH_TYPE_TEAM && SQCommon.g_bUseSplitsRule)
                || (m_nCurMatchType == SQCommon.MATCH_TYPE_SINGLE && SQCommon.g_bUseSetsRule))
            {
                if (ovrRule.IsMatchScoreFinished(nHomeTScore, nAwayTScore)) return;
            }

            Int32 nNewAwayScore = nAwayTScore + 1; // Add Score
            if (ovrRule.UpdateMatchResultToDB(nHomeTScore, nNewAwayScore, m_nRegAPos, m_nRegBPos))
            {
                lb_Away_Score.Text = nNewAwayScore.ToString();
                MatchScoreToSetsTotal();
            }
        }

        private void btnx_Away_Sub_Click(object sender, EventArgs e)
        {
            Int32 nHomeTScore = Convert.ToInt32(lb_Home_Score.Text);
            Int32 nAwayTScore = Convert.ToInt32(lb_Away_Score.Text);

            if (nAwayTScore <= 0)
                return;

            Int32 nNewAwayScore = nAwayTScore - 1; // Sub Score
            if (ovrRule.UpdateMatchResultToDB(nHomeTScore, nNewAwayScore, m_nRegAPos, m_nRegBPos))
            {
                lb_Away_Score.Text = nNewAwayScore.ToString();
                MatchScoreToSetsTotal();
            }
        }

        private void btnx_A_ADD_Click(object sender, EventArgs e)
        {
            // Get Current selected Set Edit 
            Int32 nOffset = m_nCurSetOffset;
            if (nOffset < 0 || nOffset > m_naSetIDs.Count) return;

            Label plbSetA = (Label)ReflectVar(GetType(), "lb_A_Game" + (nOffset + 1).ToString());
            Label plbSetB = (Label)ReflectVar(GetType(), "lb_B_Game" + (nOffset + 1).ToString());

            if (plbSetA == null || plbSetB == null) return;

            Int32 nResultA = 0;
            Int32 nResultB = 0;
            try
            {
                nResultA = plbSetA.Text == String.Empty ? 0 : Convert.ToInt32(plbSetA.Text);
                nResultB = plbSetB.Text == String.Empty ? 0 : Convert.ToInt32(plbSetB.Text);
            }
            catch (System.Exception eFmt)
            {
                MessageBox.Show(eFmt.ToString());
            }

            // If Result is Finished then not Add any more
            if (ovrRule.IsSetScoreFinished(nResultA, nResultB)) return;

            // Write to DB, if failure then recover
            plbSetA.Text = (nResultA + 1).ToString();
            if (!UpdateSetsResult(false, nResultA + 1, nResultB))
            {
                plbSetA.Text = nResultA.ToString();
                return;
            }

            //统计得分历程

            AddActionList(m_nRegAPos, m_nRegIDA, nResultA + 1, nResultB, nResultA + 1);
            EnableGameDetail(true, false);

            if (ovrRule.IsSetScoreFinished(nResultA + 1, nResultB))
            {
                UpdateSplitStatus(SQCommon.STATUS_FINISHED);

                rad_ServerA.Checked = false;
                rad_ServerB.Checked = false;
                m_bAService = false;
                m_bBService = false;
                UpdateService(false);
            }
            else
            {
                // Change the Service status
                rad_ServerA.Checked = true;
            }
        }

        private void btnx_A_SUB_Click(object sender, EventArgs e)
        {
            // Get Current selected Set Edit 
            Int32 nOffset = m_nCurSetOffset;
            if (nOffset < 0 || nOffset > m_naSetIDs.Count) return;

            Label pEditSetA = (Label)ReflectVar(GetType(), "lb_A_Game" + (nOffset + 1).ToString());
            Label pEditSetB = (Label)ReflectVar(GetType(), "lb_B_Game" + (nOffset + 1).ToString());
            if (pEditSetA == null || pEditSetB == null) return;

            Int32 nResultA = 0;
            Int32 nResultB = 0;
            try
            {
                nResultA = pEditSetA.Text == String.Empty ? 0 : Convert.ToInt32(pEditSetA.Text);
                nResultB = pEditSetB.Text == String.Empty ? 0 : Convert.ToInt32(pEditSetB.Text);
            }
            catch (System.Exception eFmt)
            {
                MessageBox.Show(eFmt.ToString());
            }

            if (nResultA < 1)
                return;

            // Adjust Current Set result
            pEditSetA.Text = (nResultA - 1).ToString();

            // Write to DB
            if (!UpdateSetsResult(false, nResultA - 1, nResultB))
            {
                pEditSetA.Text = nResultA.ToString();
            }

            //删除得分历程
            DelActionList(m_nRegAPos, m_nRegIDA);

            EnableGameDetail(true, false);
            UpdateSplitStatus(SQCommon.STATUS_RUNNING);
        }

        private void btnx_B_ADD_Click(object sender, EventArgs e)
        {
            // Get Current selected Set Edit 
            Int32 nOffset = m_nCurSetOffset;
            if (nOffset < 0 || nOffset > m_naSetIDs.Count) return;

            Label pEditSetA = (Label)ReflectVar(GetType(), "lb_A_Game" + (nOffset + 1).ToString());
            Label pEditSetB = (Label)ReflectVar(GetType(), "lb_B_Game" + (nOffset + 1).ToString());

            if (pEditSetA == null || pEditSetB == null) return;

            Int32 nResultA = 0;
            Int32 nResultB = 0;
            try
            {
                nResultA = pEditSetA.Text == String.Empty ? 0 : Convert.ToInt32(pEditSetA.Text);
                nResultB = pEditSetB.Text == String.Empty ? 0 : Convert.ToInt32(pEditSetB.Text);
            }
            catch (System.Exception eFmt)
            {
                MessageBox.Show(eFmt.ToString());
            }
            // If Result is Finished then not Add any more
            if (ovrRule.IsSetScoreFinished(nResultA, nResultB)) return;

            // Write to DB, if failure then recover
            pEditSetB.Text = (nResultB + 1).ToString();
            if (!UpdateSetsResult(false, nResultA, nResultB + 1))
            {
                pEditSetB.Text = nResultB.ToString();
                return;
            }

            //统计得分历程

            AddActionList(m_nRegBPos, m_nRegIDB, nResultA, nResultB + 1, nResultB + 1);
            EnableGameDetail(true, false);

            if (ovrRule.IsSetScoreFinished(nResultA, nResultB + 1))
            {
                UpdateSplitStatus(SQCommon.STATUS_FINISHED);

                rad_ServerA.Checked = false;
                rad_ServerB.Checked = false;
                m_bAService = false;
                m_bBService = false;
                UpdateService(false);
            }
            else
            {
                // Change the Service status
                rad_ServerB.Checked = true;
            }
        }

        private void btnx_B_SUB_Click(object sender, EventArgs e)
        {
            // Get Current selected Set Edit 
            Int32 nOffset = m_nCurSetOffset;
            if (nOffset < 0 || nOffset > m_naSetIDs.Count) return;

            Label pEditSetA = (Label)ReflectVar(GetType(), "lb_A_Game" + (nOffset + 1).ToString());
            Label pEditSetB = (Label)ReflectVar(GetType(), "lb_B_Game" + (nOffset + 1).ToString());
            if (pEditSetA == null || pEditSetB == null) return;

            Int32 nResultA = 0;
            Int32 nResultB = 0;
            try
            {
                nResultA = pEditSetA.Text == String.Empty ? 0 : Convert.ToInt32(pEditSetA.Text);
                nResultB = pEditSetB.Text == String.Empty ? 0 : Convert.ToInt32(pEditSetB.Text);
            }
            catch (System.Exception eFmt)
            {
                MessageBox.Show(eFmt.ToString());
            }

            if (nResultB < 1)
                return;

            // Adjust Current Set result
            pEditSetB.Text = (nResultB - 1).ToString();

            // Write to DB
            if (!UpdateSetsResult(false, nResultA, nResultB - 1))
            {
                pEditSetB.Text = nResultB.ToString();
            }

            //删除得分历程
            DelActionList(m_nRegBPos, m_nRegIDB);

            EnableGameDetail(true, false);
            UpdateSplitStatus(SQCommon.STATUS_RUNNING);
        }

        private void OnBtnSplitClick(object sender, EventArgs e)
        {
            // Get Offset and checked RadioButton
            DevComponents.DotNetBar.ButtonX rbtn = (DevComponents.DotNetBar.ButtonX)sender;
            String rbtnName = rbtn.Name;
            char chEndNum = rbtnName[rbtnName.Length - 1];
            Int32 nOffset = Convert.ToInt32(chEndNum.ToString()) - 1;
            if (nOffset < 0 || nOffset > m_naSetIDs.Count) return;

            m_rbtnCurChkedSplit = rbtn;
            m_nCurSplitOffset = nOffset;

            ChangeTeamSplit(nOffset);
        }

        private void btnx_ModifyTime_Click(object sender, EventArgs e)
        {
            ModifyMatchTime frmModifyTime = new ModifyMatchTime(m_nCurMatchID, m_nCurMatchType);
            frmModifyTime.ShowDialog();

            SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void btnx_SubMatch_Result_Click(object sender, EventArgs e)
        {
            if (m_nCurSplitOffset < 0)
                return;

            frmModifyResult frmMatchResult = new frmModifyResult(m_nCurMatchID, m_nCurTeamSplitID);
            frmMatchResult.ShowDialog();

            String strGameTotalA, strGameTotalB;

            if (SQCommon.g_ManageDB.GetTeamSplitResult(m_nCurMatchID, m_nCurTeamSplitID, out strGameTotalA, out strGameTotalB))
            {
                lb_A_GameTotal.Text = strGameTotalA.Equals("") ? "0" : strGameTotalA;
                lb_B_GameTotal.Text = strGameTotalB.Equals("") ? "0" : strGameTotalB;

                UpdateSetTotalResult();
                EnableMatchCtrlBtn(true);
            }

            SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void btnx_Game_Result_Click(object sender, EventArgs e)
        {
            if (m_nCurSetOffset < 0)
                return;

            frmModifyResult frmMatchResult = new frmModifyResult(m_nCurMatchID, m_nCurSetID);
            frmMatchResult.ShowDialog();

            GetSetsTotalWriteToDB();
            EnableGamesRbtn(true, false);
            EnableGameDetail(true, false);
            SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        //导出路径选择
        private void btnxExPathSel_Click(object sender, EventArgs e)
        {
            if (folderSelDlg.ShowDialog() == DialogResult.OK)
            {
                if (!Directory.Exists(folderSelDlg.SelectedPath))
                {
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgExportPath"));
                    return;
                }

                tbExportPath.Text = folderSelDlg.SelectedPath;
            }
        }

        private void btnxExAthlete_Click(object sender, EventArgs e)
        {
            ExportAthleteXml();
        }

        private void btnxExSchedule_Click(object sender, EventArgs e)
        {
            ExportScheduleXml();
        }

        private void btnxImPathSel_Click(object sender, EventArgs e)
        {
            if (folderSelDlg.ShowDialog() == DialogResult.OK)
            {
                if (!Directory.Exists(folderSelDlg.SelectedPath))
                {
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgImportPath"));
                    return;
                }

                tbImportPath.Text = folderSelDlg.SelectedPath;
                filewatcher.Path = tbImportPath.Text;
            }
        }

        private void chkOuterData_CheckedChanged(object sender, EventArgs e)
        {
            if (chkOuterData.Checked == true)
            {
                EnableExportImport(true);
                InitDateList();
            }
            else
            {
                EnableExportImport(false);
            }
        }

        private void chkAutoImport_CheckedChanged(object sender, EventArgs e)
        {
            if (chkAutoImport.Checked == true)
            {
                if (!Directory.Exists(tbImportPath.Text))
                {
                    chkAutoImport.Checked = false;
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgImportPath"));
                    return;
                }

                CreateFileSystermWatcher();
                m_strFileImportPath = tbImportPath.Text;
            }
            else
            {
                filewatcher.EnableRaisingEvents = false;
                timerNetPath.Stop();
            }
        }

        private void timerNetPath_Tick(object sender, EventArgs e)
        {
            if (!Directory.Exists(tbImportPath.Text))
            {
                bNetConnected = false;
            }
            else
            {
                if (!bNetConnected)
                {
                    if( CreateFileSystermWatcher())
                    {
                        bNetConnected = true;
                    }
                }
            }
        }

        private void btnxImFileSel_Click(object sender, EventArgs e)
        {
            fileSelDlg.Filter = "(*.xml)|*.xml";

            if (fileSelDlg.ShowDialog() == DialogResult.OK)
            {
                if (!File.Exists(fileSelDlg.FileName))
                {
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgImportFile"));
                    return;
                }

                tbImFilePath.Text = fileSelDlg.FileName;
            }
        }

        private void btnxImMatchInfo_Click(object sender, EventArgs e)
        {
            String strImportFile = tbImFilePath.Text;

            if (!File.Exists(strImportFile))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgImportFile"));
                return;
            }

            String strFileName = GetFileName(strImportFile);

            if (strFileName != "MatchInfo")
            {
                return;
            }

            String strDesFile = "";

            if (MoveXmlToSpecFolder(strImportFile, ref strDesFile))
            {
                ImportMatchInfo(strDesFile);
            }
        }

        private void btnxImAction_Click(object sender, EventArgs e)
        {
            String strImportFile = tbImFilePath.Text;

            if (!File.Exists(strImportFile))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgImportFile"));
                return;
            }

            String strFileName = GetFileName(strImportFile);

            if (strFileName != "ScoreList")
            {
                return;
            }

            String strDesFile = "";

            if (MoveXmlToSpecFolder(strImportFile, ref strDesFile))
            {
                ImportActionList(strDesFile);
            }
        }

        private void btnxImportMatchResult_Click(object sender, EventArgs e)
        {
            String strImportFile = tbImFilePath.Text;

            if (!File.Exists(strImportFile))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgImportFile"));
                return;
            }

            String strFileName = GetFileName(strImportFile);

            if (strFileName != "MatchResult")
            {
                return;
            }

            String strDesFile = "";

            if (MoveXmlToSpecFolder(strImportFile, ref strDesFile))
            {
                ImportMatchResult(strDesFile);
            }
        }
    }
}
