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

namespace AutoSports.OVRSEPlugin
{
    public delegate void SetTextBoxMsg(String strMsg);

    public partial class frmOVRSEDataEntry : Office2007Form
    {
        public frmOVRSEDataEntry()
        {
            InitializeComponent();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvTeamA);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvTeamB);

            //Hoop
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvHoopResult);
            this.dgvHoopResult.SelectionMode = DataGridViewSelectionMode.CellSelect;

            m_processer = new QueueDataProcess<string>(this);
            m_processer.StartProcess();
        }

        private void frmOVRSEDataEntry_Load(object sender, EventArgs e)
        {
            //Hoop
            EnableHoopCtrlBtn(false, true);

            EnableMatchCtrlBtn(false);
            EnableMatchAll(false, true);
            EnableExportImport(false);

            Localization();
            SECommon.g_ManageDB.InitGame();

            ovrRule = new OVRSERule(m_nCurMatchID);
            m_nCurMatchType = ovrRule.m_nMatchType;
            m_nCurStatusID = ovrRule.m_nMatchStatusID;

            if (m_nCurMatchID < 1)
                return;

            if (m_nCurMatchType == SECommon.MATCH_TYPE_REGU || m_nCurMatchType == SECommon.MATCH_TYPE_DOUBLE || m_nCurMatchType == SECommon.MATCH_TYPE_TEAM)
            {
                StartMatch();
                tabControlDataEntry.SelectedTabIndex = 0;
                btnClearRes.Enabled = true;
            }
            else if (m_nCurMatchType == SECommon.MATCH_TYPE_HOOP)
            {
                StartHoopMatch();
                tabControlDataEntry.SelectedTabIndex = 1;
                btnClearRes.Enabled = false;
            }
        }

        private void Localization()
        {
            gb_MatchInfo.Text = LocalizationRecourceManager.GetString(strSectionName, "gbMatchInfo");
            gb_MatchResult.Text = LocalizationRecourceManager.GetString(strSectionName, "gbMatchScore");
            lb_Sport.Text = LocalizationRecourceManager.GetString(strSectionName, "lbSportName");
            lb_Phase.Text = LocalizationRecourceManager.GetString(strSectionName, "lbPhaseName");
            lb_Date.Text = LocalizationRecourceManager.GetString(strSectionName, "lbDate");
            lb_TotalScore.Text = LocalizationRecourceManager.GetString(strSectionName, "lbTotalScore");
            lb_GameTotal.Text = LocalizationRecourceManager.GetString(strSectionName, "lbGameTotal");
            btnx_Modify_Result.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxModifyResult");
            btnx_ModifyTime.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxModifyTime");
            btnx_Official.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxOfficialInfo");
            btnx_HomePlayer.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxHomePlayer");
            btnx_VisitorPlayer.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxVisitorPlayer");
            btnx_Exit.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxExitMatch");
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
            rad_Game1.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame1");
            rad_Game2.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame2");
            rad_Game3.Text = LocalizationRecourceManager.GetString(strSectionName, "radGame3");
            rad_ServerA.Text = LocalizationRecourceManager.GetString(strSectionName, "radServerA");
            rad_ServerB.Text = LocalizationRecourceManager.GetString(strSectionName, "radServerB");
            btnx_Undo.Text = LocalizationRecourceManager.GetString(strSectionName, "btnUndo");

            //导入导出
            gb_ImportResult.Text = LocalizationRecourceManager.GetString(strSectionName, "gbExportImport");
            lb_SelectDate.Text = LocalizationRecourceManager.GetString(strSectionName, "lbSelectDate");
            lb_ExportPath.Text = LocalizationRecourceManager.GetString(strSectionName, "lbExportPath");
            btnxExAthlete.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxExportAthlete");
            btnxExTeam.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxExportTeam");
            btnxExSchedule.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxExportSchedule");
            lb_ImportPath.Text = LocalizationRecourceManager.GetString(strSectionName, "lbImportPath");
            btnxImportMatchInfo.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxImportMatchInfo");
            btnxImportAction.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxImportAction");
            btnxImStatistic.Text = LocalizationRecourceManager.GetString(strSectionName, "btnxImportStatistic");
            chkAutoImport.Text = LocalizationRecourceManager.GetString(strSectionName, "chkAutoImport");
            chkOuterData.Text = LocalizationRecourceManager.GetString(strSectionName, "chkExternalData");
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
            m_nCurStatusID = SECommon.g_ManageDB.GetMatchStatus(m_nCurMatchID);
            Int32 nRegAID, nRegBID;

            //2013.11.08判断一下比赛类型，对抗类还是表演赛
            ovrRule = new OVRSERule(m_nCurMatchID);
            m_nCurMatchType = ovrRule.m_nMatchType;
            m_nCurStatusID = ovrRule.m_nMatchStatusID;

            if (m_nCurMatchID < 1)
                return;

            if (m_nCurMatchType == SECommon.MATCH_TYPE_REGU || m_nCurMatchType == SECommon.MATCH_TYPE_DOUBLE || m_nCurMatchType == SECommon.MATCH_TYPE_TEAM)
            {
                // Not valid player
                SECommon.g_ManageDB.GetMatchMember(m_nCurMatchID, out nRegAID, out nRegBID);
                if (nRegAID <= 0 || nRegBID <= 0)
                {
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbConfigMatchUp"));
                    return;
                }

                StartMatch();
                tabControlDataEntry.SelectedTabIndex = 0;
                btnClearRes.Enabled = true;
            }
            else if (m_nCurMatchType == SECommon.MATCH_TYPE_HOOP)
            {
                SECommon.g_ManageDB.GetHoopMatchMember(m_nCurMatchID, out nRegAID);
                if (nRegAID <= 0)
                {
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbConfigMatchUp"));
                    return;
                }

                StartHoopMatch();
                tabControlDataEntry.SelectedTabIndex = 1;
                btnClearRes.Enabled = false;
            }

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

        private void btnx_Official_Click(object sender, EventArgs e)
        {
            frmEntryOfficial frmOfficial = new frmEntryOfficial(m_nCurMatchID, m_nCurMatchType);
            frmOfficial.ShowDialog();
            SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchOfficials, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void btnx_Home_Click(object sender, EventArgs e)
        {
            frmTeamPlayers frmHomePlayer = new frmTeamPlayers(m_nCurMatchID, m_nCurMatchType, 1);
            frmHomePlayer.ShowDialog();
            GetMatchPlayerList();
            SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emSplitCompetitor, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void btnx_VisitorPlayer_Click(object sender, EventArgs e)
        {
            frmTeamPlayers frmVisitorPlayer = new frmTeamPlayers(m_nCurMatchID, m_nCurMatchType, 2);
            frmVisitorPlayer.ShowDialog();
            GetMatchPlayerList();
            SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emSplitCompetitor, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }
        private void DoExit()
        {
            InitVariant();
            m_nCurMatchID = -1;
            m_bIsRunning = false;

            EnableMatchCtrlBtn(false);
            EnableMatchAll(false, true);
            rad_Game1.Checked = false;
            rad_Game2.Checked = false;
            rad_Game3.Checked = false;
            rad_Game4.Checked = false;
            rad_Game5.Checked = false;
            btnClearRes.Enabled = false;
            lbMatchID.Text = "";
            lbCourt.Text = "";
            lbRule.Text = "";
            lbRSC.Text = "";
        }
        private void btnx_Exit_Click(object sender, EventArgs e)
        {
            if (!m_bIsRunning) return;

            if (MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbExitMatch"), "", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                DoExit();
            }
        }

        private void btnx_StartList_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = SECommon.STATUS_STARTLIST;

            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SECommon.g_adoDataBase.m_dbConnect, SECommon.g_SEPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Running_Click(object sender, EventArgs e)
        {
            // Auto Select 1st Split or 1st Set
            if (m_nCurMatchType == SECommon.MATCH_TYPE_TEAM)
            {
                btnx_Match1.Checked = true;
                m_nCurSplitOffset = 0;
                ChangeTeamSplit(0);
            }
            else if (m_nCurMatchType == SECommon.MATCH_TYPE_REGU || m_nCurMatchType == SECommon.MATCH_TYPE_DOUBLE)
            {
                rad_Game1.Checked = true;
                m_nCurSplitOffset = 0;
                m_nCurSetOffset = 0;
            }

            m_nCurStatusID = SECommon.STATUS_RUNNING;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SECommon.g_adoDataBase.m_dbConnect, SECommon.g_SEPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Suspend_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = SECommon.STATUS_SUSPEND;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SECommon.g_adoDataBase.m_dbConnect, SECommon.g_SEPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Unofficial_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = SECommon.STATUS_UNOFFICIAL;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SECommon.g_adoDataBase.m_dbConnect, SECommon.g_SEPlugin);
            if (iResult == 1) UpdateMatchStatus();

            SECommon.g_ManageDB.UpdateSplitStatusUnofficial(m_nCurMatchID);
        }

        private void btnx_Finished_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = SECommon.STATUS_FINISHED;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SECommon.g_adoDataBase.m_dbConnect, SECommon.g_SEPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Revision_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = SECommon.STATUS_REVISION;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SECommon.g_adoDataBase.m_dbConnect, SECommon.g_SEPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void btnx_Canceled_Click(object sender, EventArgs e)
        {
            m_nCurStatusID = SECommon.STATUS_CANCELED;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SECommon.g_adoDataBase.m_dbConnect, SECommon.g_SEPlugin);
            if (iResult == 1) UpdateMatchStatus();
        }

        private void OnRbtnSetRange(object sender, EventArgs e)
        {
            // Get Offset and checked RadioButton
            RadioButton rbtn = (RadioButton)sender;
            if (!rbtn.Checked) return;
            String rbtnName = rbtn.Name;
            char chEndNum = rbtnName[rbtnName.Length - 1];
            Int32 nOffset = Convert.ToInt32(chEndNum.ToString()) - 1;
            if (nOffset < 0 || nOffset >= m_naSetIDs.Count) return;

            m_rbtnCurChkedSet = rbtn;
            m_nCurSetOffset = nOffset;

            m_nCurSetID = (Int32)m_naSetIDs[nOffset];

            SECommon.g_ManageDB.SetInitGameScore(m_nCurMatchID, m_nCurSetID);
            if (m_nCurMatchType != SECommon.MATCH_TYPE_TEAM)
            {
                UpdateSetsResult(true);
            }

            EnableStaticBtn(true, false);
            EnableServiceRbtn(true);
            UpdateSplitStatus(SECommon.STATUS_RUNNING);
        }

        private void OnBtnSplitClick(object sender, EventArgs e)
        {
            // Get Offset and checked RadioButton
            DevComponents.DotNetBar.ButtonX rbtn = (DevComponents.DotNetBar.ButtonX)sender;
            String rbtnName = rbtn.Name;
            char chEndNum = rbtnName[rbtnName.Length - 1];
            Int32 nOffset = Convert.ToInt32(chEndNum.ToString()) - 1;
            if (nOffset < 0 || nOffset >= m_naTeamSplitIDs.Count) return;

            m_rbtnCurChkedSplit = rbtn;
            m_nCurSplitOffset = nOffset;

            ChangeTeamSplit(nOffset);
        }

        private void dgvTeamA_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            String strColumnName = dgvTeamA.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvTeamA.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                Int32 iRegisterID = GetFieldValue(dgvTeamA, iRowIndex, "F_RegisterID");

                String strInputValue = "";
                Int32 iInputKey = 0;
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    iInputKey = Convert.ToInt32(CurCell1.Tag);
                }

                strInputValue = Convert.ToString(CurCell.Value);

                if (strColumnName.CompareTo("PlayPos") == 0)
                {
                    SECommon.g_ManageDB.UpdateMatchPlayerPlayPosition(m_nCurMatchID, m_nCurMatchType, m_nCurTeamSplitID, 1, iRegisterID, strInputValue);
                }
                else if (strColumnName.CompareTo("Active") == 0)
                {
                    SECommon.g_ManageDB.UpdateMatchPlayerActive(m_nCurMatchID, m_nCurMatchType, m_nCurTeamSplitID, 1, iRegisterID, iInputKey);
                }

                SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emSplitCompetitor, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                GetMatchPlayerList();
            }
        }

        private void dgvTeamA_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvTeamA.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex < 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                if (dgvTeamA.Columns[iColumnIndex].Name.CompareTo("PlayPos") == 0)
                {
                    SECommon.g_ManageDB.InitPlayPositionCombBox(ref dgvTeamA, iColumnIndex, m_nCurMatchID);
                }
                if (dgvTeamA.Columns[iColumnIndex].Name.CompareTo("Active") == 0)
                {
                    SECommon.g_ManageDB.InitActiveCombBox(ref dgvTeamA, iColumnIndex);
                }
            }
        }

        private void dgvTeamB_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            String strColumnName = dgvTeamB.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvTeamB.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                Int32 iRegisterID = GetFieldValue(dgvTeamB, iRowIndex, "F_RegisterID");

                String strInputValue = "";
                Int32 iInputKey = 0;
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    iInputKey = Convert.ToInt32(CurCell1.Tag);
                }

                strInputValue = Convert.ToString(CurCell.Value);

                if (strColumnName.CompareTo("PlayPos") == 0)
                {
                    SECommon.g_ManageDB.UpdateMatchPlayerPlayPosition(m_nCurMatchID, m_nCurMatchType, m_nCurTeamSplitID, 2, iRegisterID, strInputValue);
                }
                else if (strColumnName.CompareTo("Active") == 0)
                {
                    SECommon.g_ManageDB.UpdateMatchPlayerActive(m_nCurMatchID, m_nCurMatchType, m_nCurTeamSplitID, 2, iRegisterID, iInputKey);
                }

                SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emSplitCompetitor, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                GetMatchPlayerList();
            }
        }

        private void dgvTeamB_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvTeamB.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex < 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                if (dgvTeamB.Columns[iColumnIndex].Name.CompareTo("PlayPos") == 0)
                {
                    SECommon.g_ManageDB.InitPlayPositionCombBox(ref dgvTeamB, iColumnIndex, m_nCurMatchID);
                }
                if (dgvTeamA.Columns[iColumnIndex].Name.CompareTo("Active") == 0)
                {
                    SECommon.g_ManageDB.InitActiveCombBox(ref dgvTeamB, iColumnIndex);
                }
            }
        }

        private void rad_ServerA_CheckedChanged(object sender, EventArgs e)
        {
            RadioButton rbtn = (RadioButton)sender;
            if (!rbtn.Checked) return;

            m_bAService = true;
            m_bBService = false;
            UpdateService(false);
        }

        private void rad_ServerB_CheckedChanged(object sender, EventArgs e)
        {
            RadioButton rbtn = (RadioButton)sender;
            if (!rbtn.Checked) return;

            m_bAService = false;
            m_bBService = true;
            UpdateService(false);
        }

        private void btnx_A_Add_Click(object sender, EventArgs e)
        {
            m_nCurSetID = (Int32)m_naSetIDs[m_nCurSetOffset];

            if (m_nCurSetID < 0 || !IsSetScoreFinished())
                return;

            Int32 nActionID = SECommon.g_ManageDB.GetActionID(SECommon.strAction_Add);
            AddActionStatisticList(nActionID, 1, m_nCurPlayIDA, true);
        }

        private void btnx_B_Add_Click(object sender, EventArgs e)
        {
            m_nCurSetID = (Int32)m_naSetIDs[m_nCurSetOffset];

            if (m_nCurSetID < 0 || !IsSetScoreFinished())
                return;

            Int32 nActionID = SECommon.g_ManageDB.GetActionID(SECommon.strAction_Add);

            AddActionStatisticList(nActionID, 2, m_nCurPlayIDB, true);
        }

        private void btnx_Undo_Click(object sender, EventArgs e)
        {
            m_nCurSetID = (Int32)m_naSetIDs[m_nCurSetOffset];

            if (m_nCurSetID < 0)
                return;

            DeleteActionList();
        }

        private void btnx_Home_Add_Click(object sender, EventArgs e)
        {
            Int32 nHomeTScore = Convert.ToInt32(lb_Home_Score.Text);
            Int32 nAwayTScore = Convert.ToInt32(lb_Away_Score.Text);

            if ((m_nCurMatchType == SECommon.MATCH_TYPE_TEAM && SECommon.g_bUseSplitsRule)
                || ((m_nCurMatchType == SECommon.MATCH_TYPE_REGU || m_nCurMatchType == SECommon.MATCH_TYPE_DOUBLE) && SECommon.g_bUseSetsRule))
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

            if ((m_nCurMatchType == SECommon.MATCH_TYPE_TEAM && SECommon.g_bUseSplitsRule)
                || ((m_nCurMatchType == SECommon.MATCH_TYPE_REGU || m_nCurMatchType == SECommon.MATCH_TYPE_DOUBLE) && SECommon.g_bUseSetsRule))
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

            Int32 nNewAwayScore = nAwayTScore - 1; // Sub Score
            if (ovrRule.UpdateMatchResultToDB(nHomeTScore, nNewAwayScore, m_nRegAPos, m_nRegBPos))
            {
                lb_Away_Score.Text = nNewAwayScore.ToString();
                MatchScoreToSetsTotal();
            }
        }

        private void btnx_Modify_Result_Click(object sender, EventArgs e)
        {
            frmModifyResult frmMatchResult = new frmModifyResult(m_nCurMatchID, m_nCurMatchType);
            frmMatchResult.ShowDialog();

            String strHomeSet, strAwaySet;

            if (SECommon.g_ManageDB.GetContestResult(m_nCurMatchID, out strHomeSet, out strAwaySet))
            {
                lb_Home_Score.Text = strHomeSet.Equals("") ? "0" : strHomeSet;
                lb_Away_Score.Text = strAwaySet.Equals("") ? "0" : strAwaySet;
                UpdateSetsResult(true);

                if (m_nCurStatusID == SECommon.STATUS_RUNNING || m_nCurStatusID == SECommon.STATUS_REVISION)
                {
                    EnableMatchAll(true, false);
                }
            }

            SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void btnx_ModifyTime_Click(object sender, EventArgs e)
        {
            frmModifyMatchTime frmModifyTime = new frmModifyMatchTime(m_nCurMatchID, m_nCurMatchType);
            frmModifyTime.ShowDialog();

            SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        //导入导出模块
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

        private void btnxExTeam_Click(object sender, EventArgs e)
        {
            ExportTeamXml();
        }

        private void btnxExSchedule_Click(object sender, EventArgs e)
        {
            ExportScheduleXml();
        }

        private void btnx_ExportHoopSchedule_Click(object sender, EventArgs e)
        {
            ExportHoopScheduleXml();
        }

        private void btnxHoopCompList_Click(object sender, EventArgs e)
        {
            ExportHoopCompListXml();
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

        private void btnxManualPathSel_Click(object sender, EventArgs e)
        {
            if (folderSelDlg.ShowDialog() == DialogResult.OK)
            {
                if (!Directory.Exists(folderSelDlg.SelectedPath))
                {
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgImportPath"));
                    return;
                }

                tbManualPath.Text = folderSelDlg.SelectedPath;
            }
        }

        private void btnxImportMatchInfo_Click(object sender, EventArgs e)
        {
            String strImportPath = tbManualPath.Text;
            if (!Directory.Exists(strImportPath))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgImportPath"));
                return;
            }

            foreach (String strImprotFile in Directory.GetFiles(strImportPath, SECommon.g_strImPortMatchInfoMode))
            {
                String strDesFile = "";

                if (CopyXmlToSpecFolder(strImprotFile, ref strDesFile))
                {
                    ImportMatchInfo(strDesFile);
                }
            }
        }

        private void btnxImportAction_Click(object sender, EventArgs e)
        {
            String strImportPath = tbManualPath.Text;
            if (!Directory.Exists(strImportPath))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgImportPath"));
                return;
            }

            foreach (String strImprotFile in Directory.GetFiles(strImportPath, SECommon.g_strImPortActionMode))
            {
                String strDesFile = "";

                if (CopyXmlToSpecFolder(strImprotFile, ref strDesFile))
                {
                    ImportActionList(strImprotFile);
                }
            }
        }

        private void btnxImStatistic_Click(object sender, EventArgs e)
        {
            String strImportPath = tbManualPath.Text;
            if (!Directory.Exists(strImportPath))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgImportPath"));
                return;
            }

            foreach (String strImprotFile in Directory.GetFiles(strImportPath, SECommon.g_strImPortStatisticMode))
            {
                String strDesFile = "";

                if (CopyXmlToSpecFolder(strImprotFile, ref strDesFile))
                {
                    ImportStatisticList(strImprotFile);
                }
            }
        }

        private void btnxImHoopMatchInfo_Click(object sender, EventArgs e)
        {
            String strImportPath = tbManualPath.Text;
            if (!Directory.Exists(strImportPath))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgImportPath"));
                return;
            }

            foreach (String strImprotFile in Directory.GetFiles(strImportPath, "HoopMatchInfo_*.xml"))
            {
                String strDesFile = "";

                if (CopyXmlToSpecFolder(strImprotFile, ref strDesFile))
                {
                    ImportHoopMatchInfo(strDesFile);
                }
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

        private void DoImport()
        {
            String strImportPath = tbManualPath.Text;
            if ( strImportPath == "")
            {
                return;
            }
            if (!Directory.Exists(strImportPath))
            {
                return;
            }
            try
            {
                foreach (String strImprotFile in Directory.GetFiles(strImportPath, "HoopMatchInfo_*.xml"))
                {
                    String strDesFile = "";
                    string newFilePath = "";
                    if (!TryMoveFileToBak(strImprotFile, 4, ref newFilePath))
                    {
                        continue;
                    }

                    if (CopyXmlToSpecFolder(newFilePath, ref strDesFile))
                    {
                        ImportHoopMatchInfo(strDesFile);
                    }
                }

                foreach (String strImprotFile in Directory.GetFiles(strImportPath, "MatchInfo_*.xml"))
                {
                    String strDesFile = "";
                    string newFilePath = "";
                    if (!TryMoveFileToBak(strImprotFile, 4, ref newFilePath))
                    {
                        continue;
                    }

                    if (CopyXmlToSpecFolder(newFilePath, ref strDesFile))
                    {
                        ImportMatchInfo(strDesFile);
                    }
                }

                foreach (String strImprotFile in Directory.GetFiles(strImportPath, "ScoreList_*.xml"))
                {
                    String strDesFile = "";
                    string newFilePath = "";
                    if (!TryMoveFileToBak(strImprotFile, 4, ref newFilePath))
                    {
                        continue;
                    }

                    if (CopyXmlToSpecFolder(newFilePath, ref strDesFile))
                    {
                        ImportActionList(strDesFile);
                    }
                }
            }
            catch (System.Exception ex)
            {
                
            }

            
        }

        private void timerNetPath_Tick(object sender, EventArgs e)
        {
            if (!Directory.Exists(tbImportPath.Text))
            {
                bNetConnected = false;
                MessageBoxEx.Show("The directory is not exists.");
                return;
            }
            else
            {
                //创建移动的子目录
                try
                {
                    string bakPath = Path.Combine(tbImportPath.Text, "BAK");
                    if ( !Directory.Exists(bakPath))
                    {
                        Directory.CreateDirectory(bakPath);
                    }
                }
                catch (System.Exception ex)
                {
                    MessageBoxEx.Show("Create bak dir failed.");
                    return;
                }
                if (!bNetConnected)
                {
                    if (CreateFileSystermWatcher())
                    {
                        bNetConnected = true;
                    }
                }
                else
                {
                    DoImport();
                }
            }
        }


        private void btnx_ClearResult_Click(object sender, EventArgs e)
        {
            if (DialogResult.Cancel == MessageBoxEx.Show("Are you sure to clear match results?", "warning", MessageBoxButtons.OKCancel, MessageBoxIcon.Question))
            {
                return;
            }
            string strErr = SECommon.g_ManageDB.ClearMatchResult(m_nCurMatchID);
            if (strErr != null)
            {
                MessageBoxEx.Show(strErr);
                return;
            }
            else
            {
                m_nCurStatusID = SECommon.STATUS_SCHEDULE;

                List<OVRDataChanged> changedList = new List<OVRDataChanged>();
                changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchStatus, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null));
                SECommon.g_SEPlugin.DataChangedNotify(changedList);
                UpdateMatchStatus(false);

                MessageBoxEx.Show("Clear Succeed!");
                DoExit();
            }
        }
        scoreFrame m_scoreFrame;
        private void btnScoreBoardClick(object sender, EventArgs e)
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
        bool bLeftSearch = true;//用于表示上次查的是RSC还是查的MatchID
        private void btnConvertRsc_Click(object sender, EventArgs e)
        {
            string strRsc = tbRSC.Text.Trim();
            string strMatchID = tbMatchID.Text.Trim();
            if (strRsc == "" && strMatchID == "")
            {
                return;
            }
            if (strRsc != "" && strMatchID != "")
            {
                if (bLeftSearch)
                {
                    tbMatchID.Clear();
                    tbRSC.SelectAll();
                    tbRSC.Focus();
                }
                else
                {
                    tbRSC.Clear();
                    tbMatchID.SelectAll();
                    tbMatchID.Focus();
                }
            }

            if (strRsc == "" && strMatchID != "")
            {
                if (Regex.IsMatch(strMatchID, "[^0-9]"))
                {
                    tbMatchID.SelectAll();
                    tbMatchID.Focus();
                    return;
                }

                string strText = SECommon.g_ManageDB.GetRscStringFromMatchID(Convert.ToInt32(strMatchID));
                tbRSC.Text = strText;
                if (strText == "")
                {

                    tbMatchID.SelectAll();
                    tbMatchID.Focus();
                }
                bLeftSearch = false;
            }

            if (strMatchID == "" && strRsc != "")
            {
                if (strRsc.Length != 9)
                {
                    tbRSC.SelectAll();
                    tbRSC.Focus();
                    return;
                }

                int matchID = SECommon.g_ManageDB.GetMatchIDFromRSC(strRsc);
                if (matchID >= 1)
                {
                    tbMatchID.Text = matchID.ToString();
                }
                else
                {
                    tbRSC.SelectAll();
                    tbRSC.Focus();
                }
                bLeftSearch = true;
            }
        }


    }
}
