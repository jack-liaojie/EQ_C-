using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using System.Threading;

namespace AutoSports.OVRBKPlugin
{
    public partial class frmOVRBKDataEntry
    {
        private void InitUI()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(dgvHomeList);
            OVRDataBaseUtils.SetDataGridViewStyle(dgvVisitList);

            InitMatchInfo();
        }

        private void EnableMatchBtn(bool bEnable)   //根据是否进入比赛来决定按钮是否可用
        {
            btnImportStat.Enabled = bEnable;
            btnExit.Enabled = bEnable;
            btnStatus.Enabled = bEnable;
        }

        private void EnalbeMatchCtrl(Boolean bEnabled)   //根据比赛状态，使控件是否可用
        {
            btnOfficial.Enabled = bEnabled;
            btnTeamInfo.Enabled = bEnabled;
        }

        private void EnableScoreBtn(bool bEnabled)
        {
            btnHPt_Add.Enabled = bEnabled;
            btnHPt_Sub.Enabled = bEnabled;
            btnVPt_Add.Enabled = bEnabled;
            btnVPt_Sub.Enabled = bEnabled;

            txtBox_HPt_Set1.Enabled = bEnabled;
            txtBox_HPt_Set2.Enabled = bEnabled;
            txtBox_HPt_Set3.Enabled = bEnabled;
            txtBox_HPt_Set4.Enabled = bEnabled;
            txtBox_HPt_Exa1.Enabled = bEnabled;
            txtBox_HPt_Exa2.Enabled = bEnabled;
            txtBox_HPt_Exa3.Enabled = bEnabled;
            txtBox_HPt_Exa4.Enabled = bEnabled;

            txtBox_VPt_Set1.Enabled = bEnabled;
            txtBox_VPt_Set2.Enabled = bEnabled;
            txtBox_VPt_Set3.Enabled = bEnabled;
            txtBox_VPt_Set4.Enabled = bEnabled;
            txtBox_VPt_Exa1.Enabled = bEnabled;
            txtBox_VPt_Exa2.Enabled = bEnabled;
            txtBox_VPt_Exa3.Enabled = bEnabled;
            txtBox_VPt_Exa4.Enabled = bEnabled;

            btnOperatType.Enabled = bEnabled;
            btnMatchResult.Enabled = bEnabled;
            btnStart.Enabled = bEnabled;

            if (!bEnabled)
            {
                btnNext.Enabled = bEnabled;
            }
            else
            {
                UpdateNextBtnEnabled();
            }

            if (!bEnabled)
            {
                btnPrevious.Enabled = bEnabled;
            }
            else
            {
                UpdatePreviousBtnEnabled();
            }
            lbPeriod.Enabled = bEnabled;
            MatchTime.Enabled = bEnabled;

            gbVisit.Enabled = bEnabled;
            gbHome.Enabled = bEnabled;
            dgvAction.Enabled = bEnabled;

            btnHActive_1.Enabled = bEnabled;
            btnHActive_2.Enabled = bEnabled;
            btnHActive_3.Enabled = bEnabled;
            btnHActive_4.Enabled = bEnabled;
            btnHActive_5.Enabled = bEnabled;

            btnVActive_1.Enabled = bEnabled;
            btnVActive_2.Enabled = bEnabled;
            btnVActive_3.Enabled = bEnabled;
            btnVActive_4.Enabled = bEnabled;
            btnVActive_5.Enabled = bEnabled;

            dgvHomeList.Enabled = bEnabled;
            dgvVisitList.Enabled = bEnabled;
            dgvAction.Enabled = bEnabled;

            if (!bEnabled)
            {
                btnStartPeriod.Enabled = bEnabled;
                btnEndPeriod.Enabled = bEnabled;
            }
            else
            {
                UpdatePeriodBtnEnabled();
            }

            btnX_2PointsMade.Enabled = bEnabled;
            btnX_2PointsMissed.Enabled = bEnabled;
            btnX_3PointsMade.Enabled = bEnabled;
            btnX_3PointsMissed.Enabled = bEnabled;
            btnX_FreeThrowMade.Enabled = bEnabled;
            btnX_FreeThrowMissed.Enabled = bEnabled;
            btnX_OffensiveRebound.Enabled = bEnabled;
            btnX_DefensiveRebound.Enabled = bEnabled;
            btnX_Assist.Enabled = bEnabled;
            btnX_Turnover.Enabled = bEnabled;
            btnX_Steal.Enabled = bEnabled;
            btnX_BlockedShot.Enabled = bEnabled;
            btnX_OffensiveFoul.Enabled = bEnabled;
            btnX_DefensiveFoul.Enabled = bEnabled;
        }

        private void BtnExtraVisible()
        {
            int iCurValidSplit = GVAR.g_ManageDB.GetMaxValidSplitCode(GVAR.Str2Int(m_CCurMatch.MatchID));
            lbExa1.Visible = false;
            txtBox_HPt_Exa1.Visible = false;
            txtBox_VPt_Exa1.Visible = false;
            lbExa2.Visible = false;
            txtBox_HPt_Exa2.Visible = false;
            txtBox_VPt_Exa2.Visible = false;
            lbExa3.Visible = false;
            txtBox_HPt_Exa3.Visible = false;
            txtBox_VPt_Exa3.Visible = false;
            lbExa4.Visible = false;
            txtBox_HPt_Exa4.Visible = false;
            txtBox_VPt_Exa4.Visible = false;

            if (m_CCurMatch.Period >= GVAR.PERIOD_EXTRA1 || iCurValidSplit >= GVAR.PERIOD_EXTRA1)
            {
                lbExa1.Visible = true;
                txtBox_HPt_Exa1.Visible = true;
                txtBox_VPt_Exa1.Visible = true;
            }
            if (m_CCurMatch.Period >= GVAR.PERIOD_EXTRA2 || iCurValidSplit >= GVAR.PERIOD_EXTRA2)
            {
                lbExa2.Visible = true;
                txtBox_HPt_Exa2.Visible = true;
                txtBox_VPt_Exa2.Visible = true;
            }
            if (m_CCurMatch.Period >= GVAR.PERIOD_EXTRA3 || iCurValidSplit >= GVAR.PERIOD_EXTRA3)
            {
                lbExa3.Visible = true;
                txtBox_HPt_Exa3.Visible = true;
                txtBox_VPt_Exa3.Visible = true;
            }
            if (m_CCurMatch.Period >= GVAR.PERIOD_EXTRA4 || iCurValidSplit >= GVAR.PERIOD_EXTRA4)
            {
                lbExa4.Visible = true;
                txtBox_HPt_Exa4.Visible = true;
                txtBox_VPt_Exa4.Visible = true;
            }
        }

        private void InitStatusBtn()
        {
            btnStatus.Text = "";

            btnx_Schedule.Checked = false;
            btnx_StartList.Checked = false;
            btnx_Running.Checked = false;
            btnx_Suspend.Checked = false;
            btnx_Unofficial.Checked = false;
            btnx_Finished.Checked = false;
            btnx_Revision.Checked = false;
            btnx_Canceled.Checked = false;

            btnx_Schedule.Enabled = false;
            btnx_StartList.Enabled = false;
            btnx_Running.Enabled = false;
            btnx_Suspend.Enabled = false;
            btnx_Unofficial.Enabled = false;
            btnx_Finished.Enabled = false;
            btnx_Revision.Enabled = false;
            btnx_Canceled.Enabled = false;
        }

        private void InitOperateType()
        {
            btnOperatType.Text = "";
            btnx_Score.Checked = false;
            btnx_Result.Checked = false;
            btnx_Statistic.Checked = false;

            btnx_Score.Enabled = true;
            btnx_Statistic.Enabled = true;
            btnx_Result.Enabled = true;

            switch (m_emOperateType)
            {
                case EOperatetype.emPoint:
                    btnOperatType.Text = btnx_Score.Text;
                    btnx_Score.Checked = true;
                    break;
                case EOperatetype.emStat:
                    btnOperatType.Text = btnx_Statistic.Text;
                    btnx_Statistic.Checked = true;
                    break;
                case EOperatetype.emMixed:
                    btnOperatType.Text = btnx_Result.Text;
                    btnx_Result.Checked = true;
                    break;
                default:
                    break;
            }
        }

        private void InitMatchInfo()
        {
            lb_EventDes.Text = m_CCurMatch.SportDes;
            lb_MatchDes.Text = m_CCurMatch.PhaseDes;
            lb_VenueDes.Text = m_CCurMatch.VenueDes;
            lb_DateDes.Text = m_CCurMatch.DateDes;

            lbHomeDes.Text = m_CCurMatch.m_CHomeTeam.TeamName;
            btnX_HomeTeam.Text = m_CCurMatch.m_CHomeTeam.TeamName;

            lbVisitDes.Text = m_CCurMatch.m_CVisitTeam.TeamName;
            btnX_VisitTeam.Text = m_CCurMatch.m_CVisitTeam.TeamName;

            int imatchTime = m_CCurMatch.MatchTime.Trim().Length == 0 ? 0 : int.Parse(m_CCurMatch.MatchTime.Trim());
            MatchTime.Text = GVAR.TranslateINT32toTime(imatchTime);

            lbPeriod.Text = GVAR.g_ManageDB.GetPeriodName(GVAR.Str2Int(m_CCurMatch.MatchID), m_CCurMatch.Period.ToString());
            BtnExtraVisible();

            lbHomeDes.Text = m_CCurMatch.m_CHomeTeam.TeamName;
            btnX_HomeTeam.Text = m_CCurMatch.m_CHomeTeam.TeamName;
            lbVisitDes.Text = m_CCurMatch.m_CVisitTeam.TeamName;
            btnX_VisitTeam.Text = m_CCurMatch.m_CVisitTeam.TeamName;

            InitTeamInfo();
        }

        private void ClearAllBtnBibNumer(int iTeampos)
        {
            if (iTeampos == 1)
            {
                btnHActive_1.Text = string.Empty;
                btnHActive_2.Text = string.Empty;
                btnHActive_3.Text = string.Empty;
                btnHActive_4.Text = string.Empty;
                btnHActive_5.Text = string.Empty;
            }
            else if (iTeampos == 2)
            {
                btnVActive_1.Text = string.Empty;
                btnVActive_2.Text = string.Empty;
                btnVActive_3.Text = string.Empty;
                btnVActive_4.Text = string.Empty;
                btnVActive_5.Text = string.Empty;
            }
        }

        private void InitTeamInfo()
        {
            UpdateUIForTeamScore();

            ResetPlayerList(1, ref dgvHomeList);
            ResetPlayerList(2, ref dgvVisitList);
            InitPlayerAcitve(1, ref m_lstHomeActive);
            InitPlayerAcitve(2, ref m_lstVisitActive);
        }

        private void UpdateUIForTeamScore()
        {
            if (m_CCurMatch.m_CHomeTeam.TeamPoint == -1 || m_CCurMatch.MatchStatus < GVAR.STATUS_RUNNING)
            {
                lbHPt_Tot.Text = "";
            }
            else
            {
                lbHPt_Tot.Text = m_CCurMatch.m_CHomeTeam.TeamPoint.ToString();
            }

            if (m_CCurMatch.m_CVisitTeam.TeamPoint == -1 || m_CCurMatch.MatchStatus < GVAR.STATUS_RUNNING)
            {
                lbVPt_Tot.Text = "";
            }
            else
            {
                lbVPt_Tot.Text = m_CCurMatch.m_CVisitTeam.TeamPoint.ToString();
            }

            txtBox_HPt_Set1.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_1ST);
            txtBox_HPt_Set2.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_2ND);
            txtBox_HPt_Set3.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_3RD);
            txtBox_HPt_Set4.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_4TH);
            txtBox_HPt_Exa1.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_EXTRA1);
            txtBox_HPt_Exa2.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_EXTRA2);
            txtBox_HPt_Exa3.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_EXTRA3);
            txtBox_HPt_Exa4.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_EXTRA4);

            txtBox_VPt_Set1.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_1ST);
            txtBox_VPt_Set2.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_2ND);
            txtBox_VPt_Set3.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_3RD);
            txtBox_VPt_Set4.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_4TH);
            txtBox_VPt_Exa1.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_EXTRA1);
            txtBox_VPt_Exa2.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_EXTRA2);
            txtBox_VPt_Exa3.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_EXTRA3);
            txtBox_VPt_Exa4.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_EXTRA4);
        }

        private void UpdateMatchStatus()
        {
            InitStatusBtn();

            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            switch (m_CCurMatch.MatchStatus)
            {
                case GVAR.STATUS_SCHEDULE:
                    {
                        EnalbeMatchCtrl(true);
                        EnableScoreBtn(false);
                        btnx_StartList.Enabled = true;
                        btnx_Schedule.Checked = true;
                        btnStatus.Text = btnx_Schedule.Text;
                        btnStatus.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case GVAR.STATUS_ON_COURT:
                    {
                        EnalbeMatchCtrl(true);
                        EnableScoreBtn(false);
                        btnx_Running.Enabled = true;
                        btnx_StartList.Checked = true;
                        btnStatus.Text = btnx_StartList.Text;
                        btnStatus.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case GVAR.STATUS_RUNNING:
                    {
                        EnalbeMatchCtrl(true);
                        EnableScoreBtn(true);
                        btnx_Suspend.Enabled = true;
                        btnx_Unofficial.Enabled = true;
                        btnx_Running.Checked = true;
                        btnStatus.Text = btnx_Running.Text;
                        btnStatus.ForeColor = System.Drawing.Color.Red;

                        GVAR.g_ManageDB.CheckMatchStat(int.Parse(m_CCurMatch.MatchID));

                        break;
                    }
                case GVAR.STATUS_SUSPEND:
                    {
                        EnalbeMatchCtrl(true);
                        EnableScoreBtn(false);
                        btnx_Running.Enabled = true;
                        btnx_Suspend.Checked = true;
                        btnStatus.Text = btnx_Suspend.Text;
                        btnStatus.ForeColor = System.Drawing.Color.Red;
                        break;
                    }
                case GVAR.STATUS_UNOFFICIAL:
                    {
                        EnalbeMatchCtrl(true);
                        EnableScoreBtn(true);
                        btnx_Finished.Enabled = true;
                        btnx_Unofficial.Checked = true;
                        btnStatus.Text = btnx_Unofficial.Text;
                        btnStatus.ForeColor = System.Drawing.Color.LimeGreen;

                        UpdateMatchResult();

                        int iEventID = GVAR.g_ManageDB.GetEventID(m_CCurMatch.MatchID);
                        GVAR.g_BKPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, iEventID, -1, iMatchID, iMatchID, null);

                        OVRDataBaseUtils.AutoProgressMatch(iMatchID, GVAR.g_sqlConn, GVAR.g_BKPlugin);//自动晋级

                        //GVAR.g_ManageDB.AutoGroupRank(iMatchID);       // 自动小组排名
                        int iPhaseID = GVAR.g_ManageDB.GetPhaseID(iMatchID);
                        GVAR.g_BKPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);

                        break;
                    }
                case GVAR.STATUS_FINISHED:
                    {
                        EnalbeMatchCtrl(false);
                        EnableScoreBtn(false);

                        btnx_Revision.Enabled = true;
                        btnx_Finished.Checked = true;
                        btnStatus.Text = btnx_Finished.Text;
                        btnStatus.ForeColor = System.Drawing.Color.LimeGreen;

                        int iEventID = GVAR.g_ManageDB.GetEventID(m_CCurMatch.MatchID);
                        GVAR.g_BKPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, iEventID, -1, iMatchID, iMatchID, null);

                        OVRDataBaseUtils.AutoProgressMatch(iMatchID, GVAR.g_sqlConn, GVAR.g_BKPlugin);//自动晋级

                        GVAR.g_ManageDB.AutoGroupRank(iMatchID);       // 自动小组排名
                        int iPhaseID = GVAR.g_ManageDB.GetPhaseID(iMatchID);
                        GVAR.g_BKPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);
                        break;
                    }
                case GVAR.STATUS_REVISION:
                    {
                        EnalbeMatchCtrl(true);
                        EnableScoreBtn(true);

                        btnx_Finished.Enabled = true;
                        btnx_Revision.Checked = true;
                        btnStatus.Text = btnx_Revision.Text;
                        btnStatus.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case GVAR.STATUS_CANCELED:
                    {
                        EnalbeMatchCtrl(false);
                        EnableScoreBtn(false);

                        btnx_Canceled.Checked = true;
                        btnStatus.Text = btnx_Canceled.Text;
                        btnStatus.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                default:
                    return;
            }
        }

        private void UpdateMatchResult()
        {
            int iMatchID = Convert.ToInt32(m_CCurMatch.MatchID);

            if (GVAR.g_ManageDB.ExitsMatchResult(iMatchID))
                return;
            if (m_CCurMatch.m_CHomeTeam.TeamPoint > m_CCurMatch.m_CVisitTeam.TeamPoint)
            {
                GVAR.g_ManageDB.UpdateMatchResult(iMatchID, m_CCurMatch.m_CHomeTeam.TeamPosition, GVAR.RESULT_TYPE_WIN);
                GVAR.g_ManageDB.UpdateMatchResult(iMatchID, m_CCurMatch.m_CVisitTeam.TeamPosition, GVAR.RESULT_TYPE_LOSE);
            }
            else if (m_CCurMatch.m_CHomeTeam.TeamPoint < m_CCurMatch.m_CVisitTeam.TeamPoint)
            {
                GVAR.g_ManageDB.UpdateMatchResult(iMatchID, m_CCurMatch.m_CHomeTeam.TeamPosition, GVAR.RESULT_TYPE_LOSE);
                GVAR.g_ManageDB.UpdateMatchResult(iMatchID, m_CCurMatch.m_CVisitTeam.TeamPosition, GVAR.RESULT_TYPE_WIN);
            }
            else
            {
                GVAR.g_ManageDB.UpdateMatchResult(iMatchID, m_CCurMatch.m_CHomeTeam.TeamPosition, GVAR.RESULT_TYPE_TIE);
                GVAR.g_ManageDB.UpdateMatchResult(iMatchID, m_CCurMatch.m_CVisitTeam.TeamPosition, GVAR.RESULT_TYPE_TIE);
            }
        }

        private void UpdateUIForActivPlayer(int iTeampos, List<SPlayerInfo> lstActive)
        {
            if (iTeampos == 1)
            {
                btnHActive_1.Text = "";
                btnHActive_2.Text = "";
                btnHActive_3.Text = "";
                btnHActive_4.Text = "";
                btnHActive_5.Text = "";

                for (int i = 0; i < lstActive.Count; i++)
                {
                    SPlayerInfo tmpPlayer = lstActive.ElementAt(i);
                    int iShirtNumber = tmpPlayer.iShirtNumber;

                    switch (i)
                    {
                        case 0:
                            btnHActive_1.Text = iShirtNumber.ToString();
                            break;
                        case 1:
                            btnHActive_2.Text = iShirtNumber.ToString();
                            break;
                        case 2:
                            btnHActive_3.Text = iShirtNumber.ToString();
                            break;
                        case 3:
                            btnHActive_4.Text = iShirtNumber.ToString();
                            break;
                        case 4:
                            btnHActive_5.Text = iShirtNumber.ToString();
                            break;
                        default:
                            break;
                    }
                }
            }
            else if (iTeampos == 2)
            {
                btnVActive_1.Text = "";
                btnVActive_2.Text = "";
                btnVActive_3.Text = "";
                btnVActive_4.Text = "";
                btnVActive_5.Text = "";

                for (int i = 0; i < lstActive.Count; i++)
                {
                    SPlayerInfo tmpPlayer = lstActive.ElementAt(i);
                    int iShirtNumber = tmpPlayer.iShirtNumber;

                    switch (i)
                    {
                        case 0:
                            btnVActive_1.Text = iShirtNumber.ToString();
                            break;
                        case 1:
                            btnVActive_2.Text = iShirtNumber.ToString();
                            break;
                        case 2:
                            btnVActive_3.Text = iShirtNumber.ToString();
                            break;
                        case 3:
                            btnVActive_4.Text = iShirtNumber.ToString();
                            break;
                        case 4:
                            btnVActive_5.Text = iShirtNumber.ToString();
                            break;
                        default:
                            break;
                    }
                }
            }
        }

        public void ChangePeriod()
        {
            if (m_CCurMatch.Period == GVAR.PERIOD_EXTRA1)
            {
                if (lbExa1.Visible == false)
                {
                    lbExa1.Visible = true;
                    txtBox_HPt_Exa1.Visible = true;
                    txtBox_VPt_Exa1.Visible = true;
                }

                if (!GVAR.g_ManageDB.IsExistMatchSplit(ref m_CCurMatch, GVAR.PERIOD_EXTRA1))
                {
                    GVAR.g_ManageDB.AddSplitMatch(ref m_CCurMatch, GVAR.PERIOD_EXTRA1.ToString());
                }
            }
            if (m_CCurMatch.Period == GVAR.PERIOD_EXTRA2)
            {
                if (lbExa2.Visible == false)
                {
                    lbExa2.Visible = true;
                    txtBox_HPt_Exa2.Visible = true;
                    txtBox_VPt_Exa2.Visible = true;
                }

                if (!GVAR.g_ManageDB.IsExistMatchSplit(ref m_CCurMatch, GVAR.PERIOD_EXTRA2))
                {
                    GVAR.g_ManageDB.AddSplitMatch(ref m_CCurMatch, GVAR.PERIOD_EXTRA2.ToString());
                }
            }
            if (m_CCurMatch.Period == GVAR.PERIOD_EXTRA3)
            {
                if (lbExa3.Visible == false)
                {
                    lbExa3.Visible = true;
                    txtBox_HPt_Exa3.Visible = true;
                    txtBox_VPt_Exa3.Visible = true;
                }

                if (!GVAR.g_ManageDB.IsExistMatchSplit(ref m_CCurMatch, GVAR.PERIOD_EXTRA3))
                {
                    GVAR.g_ManageDB.AddSplitMatch(ref m_CCurMatch, GVAR.PERIOD_EXTRA3.ToString());
                }
            }
            if (m_CCurMatch.Period == GVAR.PERIOD_EXTRA4)
            {
                if (lbExa4.Visible == false)
                {
                    lbExa4.Visible = true;
                    txtBox_HPt_Exa4.Visible = true;
                    txtBox_VPt_Exa4.Visible = true;
                }

                if (!GVAR.g_ManageDB.IsExistMatchSplit(ref m_CCurMatch, GVAR.PERIOD_EXTRA4))
                {
                    GVAR.g_ManageDB.AddSplitMatch(ref m_CCurMatch, GVAR.PERIOD_EXTRA4.ToString());
                }
            }

            GVAR.g_ManageDB.UpdateMatchPeriod(ref m_CCurMatch);
            GVAR.g_ManageDB.UpdateTeamSetPt(m_CCurMatch.Period, ref m_CCurMatch);
            lbPeriod.Text = GVAR.g_ManageDB.GetPeriodName(GVAR.Str2Int(m_CCurMatch.MatchID), m_CCurMatch.Period.ToString());
        }

        private void ResetPlayerList(int iTeampos, ref DataGridView dgv)
        {
            GVAR.g_ManageDB.ResetTeamMeber(m_CCurMatch.MatchID, iTeampos, ref dgv);

            for (int i = 0; i < dgv.RowCount; i++)
            {
                if (dgv.Rows[i].Cells["F_Active"].Value.ToString() == "1")
                {
                    dgv.Rows[i].DefaultCellStyle.BackColor = System.Drawing.Color.Yellow;
                }
            }
            ClearAllBtnBibNumer(iTeampos);
        }

        private void InitPlayerAcitve(int iTeampos, ref List<SPlayerInfo> lstActive)
        {
            if (iTeampos == 1)
            {
                GVAR.g_ManageDB.GetActiveMember(m_CCurMatch, iTeampos, ref m_CCurMatch.m_CHomeTeam, ref lstActive);
            }
            else
            {
                GVAR.g_ManageDB.GetActiveMember(m_CCurMatch, iTeampos, ref m_CCurMatch.m_CVisitTeam, ref lstActive);
            }
            UpdateUIForActivPlayer(iTeampos, lstActive);
        }

        public void SetPlayerActive(DataGridViewCellMouseEventArgs e, ref DataGridView dgv, ref List<SPlayerInfo> lstActive, int iTeamPos)
        {
            int iSelRowIndex = e.RowIndex;

            if (iSelRowIndex < 0 || iSelRowIndex > dgv.RowCount)
                return;

            int iMatchID = int.Parse(m_CCurMatch.MatchID);
            int iPlayerID = GVAR.Str2Int(dgv.Rows[iSelRowIndex].Cells["F_RegisterID"].Value);

            if (dgv.Rows[iSelRowIndex].Cells["F_Active"].Value.ToString() == "1")
            {
                GVAR.g_ManageDB.UpdatePlayerActive(iMatchID, iPlayerID, 0, "");
            }
            else
            {
                if (lstActive.Count >= 5)
                    return;
                GVAR.g_ManageDB.UpdatePlayerActive(iMatchID, iPlayerID, 1, "");
            }

            if (iTeamPos == 1)
            {
                ResetPlayerList(iTeamPos, ref dgvHomeList);
                InitPlayerAcitve(iTeamPos, ref lstActive);
            }
            else
            {
                ResetPlayerList(iTeamPos, ref dgvVisitList);
                InitPlayerAcitve(iTeamPos, ref lstActive);
            }
        }

        public int GetPlayerIndexByShirtNo(List<SPlayerInfo> lstPlayer, int iShirtNo)
        {
            int iIndex = -1;
            for (int i = 0; i < lstPlayer.Count; i++)
            {
                SPlayerInfo tmpPlayer = lstPlayer.ElementAt(i);
                if (tmpPlayer.iShirtNumber == iShirtNo)
                {
                    iIndex = i;
                    break;
                }
            }
            return iIndex;
        }

        public bool AddAction()
        {
            int iResult = GVAR.g_ManageDB.AddMatchAction(m_CCurAction);
            if (iResult <= 0)
            {
                return false;
            }
            else
            {
                m_CCurAction.AcitonID = iResult;
            }
            return true;
        }

        public bool DeleteAction(OVRBKActionInfo obOVRBKActionInfo)
        {
            int iResult = GVAR.g_ManageDB.DeleteMatchAction(obOVRBKActionInfo);
            if (iResult <= 0)
            {
                return false;
            }

            return true;
        }

        public void UpdateUIActionInfo()
        {
            lbTeamName.Text = m_CCurAction.TeamName;
            lbShirtNo.Text = m_CCurAction.ShirtNo.ToString();
            lbPlayerName.Text = m_CCurAction.PlayerName;
            lbActionName.Text = m_CCurAction.ActionDes;
        }

        public void InitActionGridHeader()
        {
            dgvAction.Columns.Clear();

            string[] strField = new string[5];
            strField[0] = "Period";
            strField[1] = "Time";
            strField[2] = "TeamName";
            strField[3] = "PlayerName";
            strField[4] = "ActionDes";

            dgvAction.Columns.Clear();
            for (int i = 0; i < 5; i++)
            {
                DataGridViewColumn col = new DataGridViewTextBoxColumn();
                col.HeaderText = strField[i];
                col.Name = strField[i];
                col.AutoSizeMode = DataGridViewAutoSizeColumnMode.NotSet;
                col.SortMode = DataGridViewColumnSortMode.Automatic;
                dgvAction.Columns.Add(col);
            }
        }

        public void UpdateActionList(ref List<OVRBKActionInfo> lstAction, int iListIndex)
        {
            string[] listColumn = new string[5];

            if (dgvAction.Columns.Count <= 0)
            {
                InitActionGridHeader();
            }

            //加入列头描述
            for (int i = 0; i < 5; i++)
            {
                listColumn[i] = dgvAction.Columns[i].HeaderText;
            }

            if (iListIndex < 0)    //全部更新
            {
                dgvAction.Rows.Clear();
                for (int i = 0; i < lstAction.Count; i++)
                {
                    OVRBKActionInfo tmpAction = lstAction.ElementAt(i);
                    DataGridViewRow dr = new DataGridViewRow();
                    dr.CreateCells(dgvAction);
                    dr.Selected = false;

                    dr.Cells[0].Value = GVAR.g_ManageDB.GetPeriodName(tmpAction.MatchID, tmpAction.MatchSplitID);
                    dr.Cells[1].Value = tmpAction.ActionTime;

                    if (tmpAction.TeamPos == 1)
                    {
                        dr.Cells[2].Value = m_CCurMatch.m_CHomeTeam.TeamName;
                    }
                    else if (tmpAction.TeamPos == 2)
                    {
                        dr.Cells[2].Value = m_CCurMatch.m_CVisitTeam.TeamName;
                    }
                    dr.Cells[3].Value = tmpAction.PlayerName;
                    dr.Cells[4].Value = tmpAction.ActionDes;

                    //////////////////////////////////
                    //比较列的长度
                    for (int j = 0; j < 5; j++)
                    {
                        string strValue = "";
                        if (dr.Cells[j].Value != null)
                        {
                            strValue = dr.Cells[j].Value.ToString();
                        }

                        if (strValue.Length > listColumn[j].Length)
                            listColumn[j] = strValue;
                    }

                    dgvAction.Rows.Add(dr);
                }
            }

            ////////////////////////////////
            //设置列宽
            for (int i = 0; i < 5; i++)
            {
                System.Drawing.SizeF sf = dgvAction.CreateGraphics().MeasureString(listColumn[i], dgvAction.Font);
                dgvAction.Columns[i].Width = System.Convert.ToInt32(sf.Width + 25f);
            }

            ///////////////////////////
            //焦点在最后一行

            if (dgvAction.Rows.Count > 0)
            {
                dgvAction.Rows[dgvAction.Rows.Count - 1].Selected = true;
                dgvAction.FirstDisplayedScrollingRowIndex = dgvAction.Rows.Count - 1;
            }
        }

        private void EnableSetPointsTextBox()
        {
            txtBox_HPt_Set1.Enabled = false;
            txtBox_HPt_Set2.Enabled = false;
            txtBox_HPt_Set3.Enabled = false;
            txtBox_HPt_Set4.Enabled = false;
            txtBox_HPt_Exa1.Enabled = false;
            txtBox_HPt_Exa2.Enabled = false;
            txtBox_HPt_Exa3.Enabled = false;
            txtBox_HPt_Exa4.Enabled = false;

            txtBox_VPt_Set1.Enabled = false;
            txtBox_VPt_Set2.Enabled = false;
            txtBox_VPt_Set3.Enabled = false;
            txtBox_VPt_Set4.Enabled = false;
            txtBox_VPt_Exa1.Enabled = false;
            txtBox_VPt_Exa2.Enabled = false;
            txtBox_VPt_Exa3.Enabled = false;
            txtBox_VPt_Exa4.Enabled = false;
            switch (m_CCurMatch.Period)
            {
                case 0:
                    {
                    }
                    break;
                case 1:
                    {
                        txtBox_HPt_Set1.Enabled = true;
                        txtBox_VPt_Set1.Enabled = true;
                    }
                    break;
                case 2:
                    {
                        txtBox_HPt_Set2.Enabled = true;
                        txtBox_VPt_Set2.Enabled = true;
                    }
                    break;
                case 3:
                    {
                        txtBox_HPt_Set3.Enabled = true;
                        txtBox_VPt_Set3.Enabled = true;
                    }
                    break;
                case 4:
                    {
                        txtBox_HPt_Set4.Enabled = true;
                        txtBox_VPt_Set4.Enabled = true;
                    }
                    break;
                case 5:
                    {
                        txtBox_HPt_Exa1.Enabled = true;
                        txtBox_VPt_Exa1.Enabled = true;
                    }
                    break;
                case 6:
                    {
                        txtBox_HPt_Exa2.Enabled = true;
                        txtBox_VPt_Exa2.Enabled = true;
                    }
                    break;
                case 7:
                    {
                        txtBox_HPt_Exa3.Enabled = true;
                        txtBox_VPt_Exa3.Enabled = true;
                    }
                    break;
                case 8:
                    {
                        txtBox_HPt_Exa4.Enabled = true;
                        txtBox_VPt_Exa4.Enabled = true;
                    }
                    break;
                default:
                    break;
            }
        }
    }
}
