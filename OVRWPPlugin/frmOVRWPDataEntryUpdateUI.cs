using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using System.Threading;

namespace AutoSports.OVRWPPlugin
{
    public partial class frmOVRWPDataEntry
    {
        private void InitUI()
        {           
            SetDataGridViewStyle(dgvHomeList,1);
            SetDataGridViewStyle(dgvVisitList,2);

            InitMatchInfo();
        }
        private void SetDataGridViewStyle(DataGridView dgv,int iTeamPos)
        {
            if (dgv == null) return;
            if (iTeamPos == 1)
            {
                dgv.BackgroundColor = Color.White;
                dgv.GridColor = System.Drawing.Color.FromArgb(208, 215, 229);
                dgv.DefaultCellStyle.BackColor = Color.White;
                dgv.AlternatingRowsDefaultCellStyle.BackColor = Color.White;
            }
            else
            {
                dgv.BackgroundColor = Color.SkyBlue;
                dgv.GridColor = System.Drawing.Color.FromArgb(208, 215, 229);
                dgv.DefaultCellStyle.BackColor =  Color.SkyBlue;
                dgv.AlternatingRowsDefaultCellStyle.BackColor = Color.SkyBlue;
            }
            dgv.BorderStyle = BorderStyle.Fixed3D;
            dgv.CellBorderStyle = DataGridViewCellBorderStyle.Single;
            dgv.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgv.RowHeadersVisible = false;
            dgv.ColumnHeadersHeight = 25;
            dgv.RowHeadersWidthSizeMode = DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            dgv.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            dgv.AllowUserToAddRows = false;
            dgv.AllowUserToDeleteRows = false;
            dgv.AllowUserToOrderColumns = false;
            dgv.AllowUserToResizeRows = false;
        }
        private void EnableMatchBtn(bool bEnable)   //根据是否进入比赛来决定按钮是否可用        {
            if (!bEnable)
            {
                btn_start_receive.Enabled = false;
                btn_stop_receive.Enabled = false;
            }
          
            //btnxExPathSel.Enabled = bEnable;
            //btn_Export.Enabled = bEnable;
            btnExit.Enabled = bEnable;
            btnStatus.Enabled = bEnable;
            if (Modetype.emMul_BlueStat == m_emMode
                || Modetype.emMul_WhiteStat == m_emMode
                || Modetype.emMul_DoubleTeamStat == m_emMode
                || Modetype.emMul_Monitor == m_emMode
                || Modetype.emMul_Substitute == m_emMode)
            {
                btnStatus.Enabled = false;
            }
        }
        private void TS_InterfaceEnable(bool bEnable)
        {
            //if (bEnable)
            //{
            //    if (!btn_start_receive.Enabled && btn_stop_receive.Enabled)
            //    {
            //        comboBox_ConnectionType.Enabled = false;
            //        btn_ReceiceSetting.Enabled = false;
            //    }
            //    else if (btn_start_receive.Enabled && !btn_stop_receive.Enabled)
            //    {
            //        comboBox_ConnectionType.Enabled = true;
            //        btn_ReceiceSetting.Enabled = true;
            //    }
            //    else 
            //    {
            //        comboBox_ConnectionType.Enabled = true;
            //        btn_ReceiceSetting.Enabled = true;
            //        btn_start_receive.Enabled = false;
            //        btn_stop_receive.Enabled = false;
            //    }
            //}
            //else
            //{
            //    comboBox_ConnectionType.Enabled = false;
            //    btn_ReceiceSetting.Enabled = false;
            //    //Label_SelectedPort.Text = String.Empty;
            //    btn_start_receive.Enabled = false;
            //    btn_stop_receive.Enabled = false;
            //}
        }
        private void EnalbeMatchCtrl(bool bEnabled)   //根据比赛状态，使控件是否可用        {
            btnWeatherSet.Enabled = bEnabled;
            btnOfficial.Enabled = bEnabled;
            btnTeamInfo.Enabled = bEnabled;
        }
        private void EnablePenaltyPeriod(bool bEnabled)
        {
            if (!bEnabled)
            {
                gbHome.Enabled = false;
                gbVisit.Enabled = false;
                gbAttempt.Enabled = false;
                gbResult.Enabled = false;
                gbStatistic.Enabled = false;
                EnablebtnStart(false);
                EnableMatchTime(false);
                btnClearAction.Enabled = false;
            }
            else
            {
                if (m_CCurMatch.CurPeriod == GVAR.PERIOD_PSO)
                {
                    btnActionShot.Enabled =false;
                    btnCentreShot.Enabled =false;
                    btnXShot.Enabled =false;
                    btn5mShot.Enabled =false;
                    btnCounterShot.Enabled =false;
                    btnFreeThrow.Enabled = false;
                    btnPSShot.Enabled = true;

                    btnGoal.Enabled = true;
                    btnSaved.Enabled = true;
                    btnMissed.Enabled = true;
                    btnPost.Enabled = true;
                    btnBlockShot.Enabled = true;
                    btnBlockShot.Enabled = false;

                    btnIn.Enabled = true;
                    btnOut.Enabled = true;
                    btnAssist.Enabled = false;
                    btnSteal.Enabled = false;
                    btnBlock.Enabled = false;
                    btnTimeOut.Enabled = false;
                    btnCornerThrow.Enabled = false;
                    btn20C.Enabled = false;
                    btn20F.Enabled = false;
                    btnEXS.Enabled = false;
                    btnEXN.Enabled = false;
                    btnSpinWon.Enabled = false;
                    btnSpinLost.Enabled = false;
                    btnPenalty.Enabled = false;
                    btnTournOver.Enabled = false;

                    EnablebtnStart(false);
                    EnableMatchTime(false);
                }
                else
                {

                    btnActionShot.Enabled = true;
                    btnCentreShot.Enabled = true;
                    btnXShot.Enabled = true;
                    btn5mShot.Enabled = true;
                    btnCounterShot.Enabled = true;
                    btnFreeThrow.Enabled = true;
                    btnPSShot.Enabled = true;

                    btnGoal.Enabled = true;
                    btnSaved.Enabled = true;
                    btnMissed.Enabled = true;
                    btnPost.Enabled = true;
                    btnBlockShot.Enabled = true;
                    btnBlockShot.Enabled = true;

                    btnIn.Enabled = true;
                    btnOut.Enabled = true;
                    btnAssist.Enabled = true;
                    btnSteal.Enabled = true;
                    btnBlock.Enabled = true;
                    btnTimeOut.Enabled = true;
                    btnCornerThrow.Enabled = true;
                    btn20C.Enabled = true;
                    btn20F.Enabled = true;
                    btnEXS.Enabled = true;
                    btnEXN.Enabled = true;
                    btnSpinWon.Enabled = true;
                    btnSpinLost.Enabled = true;
                    btnPenalty.Enabled = true;
                    btnTournOver.Enabled = true;
                    if (m_bParse)
                    {
                        EnableMatchTime(false);
                        EnablebtnStart(false);
                    }
                    else
                    {
                        EnablebtnStart(true);
                        EnableMatchTime(true);
                    }
                }
            }
        }
        private void EnablebtnStart(bool bEnabled)
        {
            btnStart.Enabled = bEnabled;
            if (Modetype.emMul_Monitor== m_emMode
                )
            {
                btnStart.Enabled = false;
            }
        }
        private void EnableMatchTime(bool bEnabled)
        {
            MatchTime.Enabled = bEnabled;
            if (Modetype.emMul_Monitor == m_emMode
                )
            {
                MatchTime.Enabled = false;
            }
        }
        private void EnableScoreBtn(bool bEnabled)
        {
            btnHPt_Add.Enabled = bEnabled; 
            btnHPt_Sub.Enabled = bEnabled;
            btnVPt_Add.Enabled = bEnabled;
            btnVPt_Sub.Enabled = bEnabled;
            btnOperatType.Enabled = bEnabled;
            btnMatchResult.Enabled = bEnabled;
            EnablebtnStart(bEnabled);

            if (!bEnabled)
            {
                btnNext.Enabled = bEnabled;
            }
            else
            {
                UpdateNextBtnStat();
            }

            if (!bEnabled)
            {
                 btnPrevious.Enabled = bEnabled;
            }
            else
            {
                UpdatePreviousBtnStat();
            }
            lbPeriod.Enabled = bEnabled;
            EnableMatchTime(bEnabled);

            btnClearAction.Enabled = bEnabled;
            gbAttempt.Enabled = bEnabled;
            gbResult.Enabled = bEnabled;
            gbStatistic.Enabled = bEnabled;
            gbHome.Enabled = bEnabled;
            gbVisit.Enabled = bEnabled;

            btnHActive_1.Enabled=bEnabled;
            btnHActive_2.Enabled=bEnabled;
            btnHActive_3.Enabled=bEnabled;
            btnHActive_4.Enabled=bEnabled;
            btnHActive_5.Enabled=bEnabled;
            btnHActive_6.Enabled=bEnabled;
            btnHActive_7.Enabled=bEnabled;
            btnHActive_8.Enabled = bEnabled;
            btnHActive_9.Enabled = bEnabled;
            btnHActive_10.Enabled = bEnabled;
            btnHActive_11.Enabled = bEnabled;
            btnHActive_12.Enabled = bEnabled;
            btnHActive_13.Enabled = bEnabled;

            btnVActive_1.Enabled = bEnabled;
            btnVActive_2.Enabled = bEnabled;
            btnVActive_3.Enabled = bEnabled;
            btnVActive_4.Enabled = bEnabled;
            btnVActive_5.Enabled = bEnabled;
            btnVActive_6.Enabled = bEnabled;
            btnVActive_7.Enabled = bEnabled;
            btnVActive_8.Enabled = bEnabled;
            btnVActive_9.Enabled = bEnabled;
            btnVActive_10.Enabled = bEnabled;
            btnVActive_11.Enabled = bEnabled;
            btnVActive_12.Enabled = bEnabled;
            btnVActive_13.Enabled = bEnabled;

            dgvHomeList.Enabled = bEnabled;
            dgvVisitList.Enabled = bEnabled;

            if (!bEnabled)
            {
                btnStartPeriod.Enabled = bEnabled;
                btnEndPeriod.Enabled = bEnabled;
            }
            else
            {
                UpdatePeriodBtnStat();
            }
            if (bEnabled)
            {
                UpdatePossStat();
            }
        }
        private void ClearSerialThead()
        {
            if (m_ParseThread != null)
            {
                if (m_ParseThread.IsAlive)
                {
                    m_bParse = false;

                    GVAR.g_SerialEvent.Set();

                }
                int iCount = 0;
                while (m_ParseThread.IsAlive && iCount < 10)
                {
                    iCount++;
                    Thread.Sleep(1000);
                }
                m_ParseThread = null;
            }
            if (m_Serial != null)
            {
                if (m_Serial.m_SerialPort.IsOpen)
                {
                    m_Serial.CloseSerial();
                }
            }
        }
       
        private void ClearUDPThead()
        {
            if (m_ParseUDPThread != null)
            {
                if (m_ParseUDPThread.IsAlive)
                {
                    m_bParse = false;
                    m_UDP.Close();
                    m_UDP = null;
                }
                m_ParseUDPThread = null;
            }
        }
        private void ClearReceiveThreads()
        {
            ClearSerialThead();
            ClearUDPThead();
        }
        private void BtnExtraVisible(bool bVisible)
        {
            lbExa1.Visible = bVisible;
            lbExa2.Visible = bVisible;
            lbHPt_Exa1.Visible = bVisible;
            lbHPt_Exa2.Visible = bVisible;
            lbVPt_Exa1.Visible = bVisible;
            lbVPt_Exa2.Visible = bVisible;
        }
        private void BtnPSOVisible(bool bVisible)
        {
            lbPSO.Visible = bVisible;
            lbHPt_PSO.Visible = bVisible;
            lbVPt_PSO.Visible = bVisible;
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
        private void GetPossStat()
        {
            int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.CurPeriod);

            string strTemp = GVAR.g_ManageDB.GetPlayerStat(m_MatchID, iMatchSplitID, m_CCurMatch.m_CHomeTeam.TeamID, 1, GVAR.strStat_PTime_Team);
            homePossTime.Text = GVAR.TranslateINT32toTime(strTemp.Trim().Length==0?0:int.Parse(strTemp));

            strTemp = GVAR.g_ManageDB.GetPlayerStat(m_MatchID, iMatchSplitID, m_CCurMatch.m_CVisitTeam.TeamID, 2, GVAR.strStat_PTime_Team);
            visitPossTime.Text = GVAR.TranslateINT32toTime(strTemp.Trim().Length == 0 ? 0 : int.Parse(strTemp));

            strTemp = GVAR.g_ManageDB.GetPlayerStat(m_MatchID, iMatchSplitID, m_CCurMatch.m_CHomeTeam.TeamID, 1, GVAR.strStat_PNO_Team);
            homepossInput.Text = CheckInput(strTemp);

            strTemp = GVAR.g_ManageDB.GetPlayerStat(m_MatchID, iMatchSplitID, m_CCurMatch.m_CVisitTeam.TeamID, 2, GVAR.strStat_PNO_Team);
            visitpossInput.Text = CheckInput(strTemp);
        }
         private void AutoInitMatchInfo()
        {
            if (!m_bAutoSendMessage || (m_emMode == Modetype.emSingleMachine))
            {
                lb_EventDes.Text = m_CCurMatch.SportDes;
                lb_MatchDes.Text = m_CCurMatch.PhaseDes;
                lb_VenueDes.Text = m_CCurMatch.VenueDes;
                lb_DateDes.Text = m_CCurMatch.DateDes;
                lbHomeDes.Text = m_CCurMatch.m_CHomeTeam.TeamName;
                lbVisitDes.Text = m_CCurMatch.m_CVisitTeam.TeamName;

                lbHomeTeamTag.Text = m_CCurMatch.m_CHomeTeam.TeamName;
                lbVisitTeamTag.Text = m_CCurMatch.m_CVisitTeam.TeamName;
                int imatchTime = m_CCurMatch.MatchTime.Trim().Length == 0 ? 0 : int.Parse(m_CCurMatch.MatchTime.Trim());
                MatchTime.Text = GVAR.TranslateINT32toTime(imatchTime);
            }
            if (m_bPeriod)
            {
                lbPeriod.Text = GVAR.g_ManageDB.GetPeriodName(GVAR.Str2Int(m_CCurMatch.MatchID), m_CCurMatch.CurPeriod.ToString());
                int iCurValidSplit = GVAR.g_ManageDB.GetMaxValidSplitCode(GVAR.Str2Int(m_CCurMatch.MatchID));
                if (m_CCurMatch.CurPeriod >= GVAR.PERIOD_EXTRA1 || iCurValidSplit >= GVAR.PERIOD_EXTRA1)
                {
                    BtnExtraVisible(true);
                }
                else
                {
                    BtnExtraVisible(false);
                }

                if (m_CCurMatch.CurPeriod == GVAR.PERIOD_PSO || iCurValidSplit == GVAR.PERIOD_PSO)
                {
                    btnPenaltyScore.Enabled = true;
                    BtnPSOVisible(true);
                }
                else
                {
                    btnPenaltyScore.Enabled = false;
                    BtnPSOVisible(false);
                }
            }

            if (m_bPoint || m_bPeriod)
             {
                  UpdateUIForTeamScore();
             }
            
             if (m_emMode == Modetype.emMul_Admin
                 ||m_emMode == Modetype.emMul_Monitor)
             {
                  ResetPlayerList(1, ref dgvHomeList);
                  ResetPlayerList(2, ref dgvVisitList);
             }
             if (m_emMode == Modetype.emMul_WhiteStat)
             {
                ResetPlayerList(1, ref dgvHomeList);
             }
             if (m_emMode == Modetype.emMul_BlueStat)
             {
                 ResetPlayerList(2, ref dgvVisitList);
             }
            if (m_emMode== Modetype.emMul_DoubleTeamStat)
            {
                ResetPlayerList(1, ref dgvHomeList);
                ResetPlayerList(2, ref dgvVisitList);
            }
            if (m_emMode == Modetype.emMul_Substitute)
             {
                 //ResetPlayerList(1, ref dgvHomeList);
                 //ResetPlayerList(2, ref dgvVisitList);
             }
        }
        private void InitMatchInfo()
        {
            lb_EventDes.Text = m_CCurMatch.SportDes;
            lb_MatchDes.Text = m_CCurMatch.PhaseDes;
            lb_VenueDes.Text = m_CCurMatch.VenueDes;
            lb_DateDes.Text = m_CCurMatch.DateDes;
            lbHomeDes.Text = m_CCurMatch.m_CHomeTeam.TeamName;
            lbVisitDes.Text = m_CCurMatch.m_CVisitTeam.TeamName;
            lbHomeTeamTag.Text = m_CCurMatch.m_CHomeTeam.TeamName;
            lbVisitTeamTag.Text = m_CCurMatch.m_CVisitTeam.TeamName;
            int imatchTime = m_CCurMatch.MatchTime.Trim().Length == 0 ? 0 : int.Parse(m_CCurMatch.MatchTime.Trim());
            MatchTime.Text = GVAR.TranslateINT32toTime(imatchTime);

            lbPeriod.Text = GVAR.g_ManageDB.GetPeriodName(GVAR.Str2Int(m_CCurMatch.MatchID), m_CCurMatch.CurPeriod.ToString());
            int iCurValidSplit = GVAR.g_ManageDB.GetMaxValidSplitCode(GVAR.Str2Int(m_CCurMatch.MatchID));
            if (m_CCurMatch.CurPeriod >= GVAR.PERIOD_EXTRA1 || iCurValidSplit >= GVAR.PERIOD_EXTRA1)
            {
                BtnExtraVisible(true);
            }
            else
            {
                BtnExtraVisible(false);
            }

            if (m_CCurMatch.CurPeriod == GVAR.PERIOD_PSO || iCurValidSplit == GVAR.PERIOD_PSO)
            {
                btnPenaltyScore.Enabled = true;
                BtnPSOVisible(true);
            }
            else
            {
                btnPenaltyScore.Enabled = false;
                BtnPSOVisible(false);
            }
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
                btnHActive_6.Text = string.Empty;
                btnHActive_7.Text = string.Empty;
                btnHActive_8.Text = string.Empty;
                btnHActive_9.Text = string.Empty;
                btnHActive_10.Text = string.Empty;
                btnHActive_11.Text = string.Empty;
                btnHActive_12.Text = string.Empty;
                btnHActive_13.Text = string.Empty;
            }
            else if (iTeampos == 2)
            {
                btnVActive_1.Text = string.Empty;
                btnVActive_2.Text = string.Empty;
                btnVActive_3.Text = string.Empty;
                btnVActive_4.Text = string.Empty;
                btnVActive_5.Text = string.Empty;
                btnVActive_6.Text = string.Empty;
                btnVActive_7.Text = string.Empty;
                btnVActive_8.Text = string.Empty;
                btnVActive_9.Text = string.Empty;
                btnVActive_10.Text=string.Empty;
                btnVActive_11.Text = string.Empty;
                btnVActive_12.Text = string.Empty;
                btnVActive_13.Text = string.Empty;
            }
        }
       
        private void InitTeamInfo()
        {
            UpdateUIForTeamScore();
            ResetPlayerList(1, ref dgvHomeList);
            ResetPlayerList(2, ref dgvVisitList);
        }

        private void UpdateUIForTeamScore()
        {
            if (m_CCurMatch.m_CHomeTeam.TeamPoint == -1||m_CCurMatch.MatchStatus<GVAR.STATUS_RUNNING)
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

            lbHPt_Set1.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_1ST);
            lbHPt_Set2.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_2ND);
            lbHPt_Set3.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_3RD);
            lbHPt_Set4.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_4TH);
            lbHPt_Exa1.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_EXTRA1);
            lbHPt_Exa2.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_EXTRA2);
            lbHPt_PSO.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_PSO);

            lbVPt_Set1.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_1ST);
            lbVPt_Set2.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_2ND);
            lbVPt_Set3.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_3RD);
            lbVPt_Set4.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_4TH);
            lbVPt_Exa1.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_EXTRA1);
            lbVPt_Exa2.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_EXTRA2);
            lbVPt_PSO.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_PSO);
        }

        private void UpdateMatchStatus()
        {
            InitStatusBtn();
            switch (m_CCurMatch.MatchStatus)
            {
                case GVAR.STATUS_SCHEDULE:
                    {
                        EnalbeMatchCtrl(true);
                        EnableScoreBtn(false);
                        EnablePenaltyPeriod(false);
                        TS_InterfaceEnable(true);
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
                        EnablePenaltyPeriod(false);
                        TS_InterfaceEnable(true);
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
                        EnablePenaltyPeriod(true);
                        TS_InterfaceEnable(true);
                        btnx_Suspend.Enabled = true;
                        btnx_Unofficial.Enabled = true;
                        btnx_Running.Checked = true;
                        btnStatus.Text = btnx_Running.Text;
                        btnStatus.ForeColor = System.Drawing.Color.Red;

                        int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.CurPeriod);
                        int iSplitStatus = GVAR.g_ManageDB.GetSplitStatusID(m_MatchID, iMatchSplitID);
                        if (iSplitStatus != GVAR.STATUS_RUNNING && iSplitStatus != GVAR.STATUS_FINISHED && m_CCurMatch.CurPeriod == GVAR.PERIOD_1ST)
                        {
                            btnStartPeriod_Click(null, null);
                            //btnStart_Click(null, null);
                        }
                        break;
                    }
                case GVAR.STATUS_SUSPEND:
                    {
                        EnalbeMatchCtrl(true);
                        EnableScoreBtn(false);
                        EnablePenaltyPeriod(false);
                        ClearReceiveThreads();
                        TS_InterfaceEnable(false);
                        btnx_Running.Enabled = true;
                        btnx_Suspend.Checked = true;
                        btnStatus.Text = btnx_Suspend.Text;
                        btnStatus.ForeColor = System.Drawing.Color.Red;
                        if (m_CCurMatch.bRunTime)
                        {
                            if (!m_bParse)
                            {
                                btnStart_Click(null, null);
                            }
                        }
                        UpdateMatchTime();
                        break;
                    }
                case GVAR.STATUS_UNOFFICIAL:
                    {
                        EnalbeMatchCtrl(true);
                        EnableScoreBtn(true);
                        EnablePenaltyPeriod(true);
                        TS_InterfaceEnable(true);
                        btnx_Finished.Enabled = true;
                        btnx_Unofficial.Checked = true;
                        btnStatus.Text = btnx_Unofficial.Text;
                        btnStatus.ForeColor = System.Drawing.Color.LimeGreen;
                        if (m_bAutoSendMessage)
                        {
                            UpdateMatchResult();
                            UpdateMatchTime();

                            GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);

                            //OVRDataBaseUtils.AutoProgressMatch(m_MatchID, GVAR.g_sqlConn, GVAR.g_WPPlugin);//自动晋级

                            //int iPhaseID = GVAR.g_ManageDB.GetPhaseID(m_MatchID);
                            //GVAR.g_ManageDB.AutoGroupRank(iPhaseID);
                            //GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);
                        }
                        break;
                    }
                case GVAR.STATUS_FINISHED:
                    {
                        EnalbeMatchCtrl(false);
                        EnableScoreBtn(false);
                        EnablePenaltyPeriod(false);
                        ClearReceiveThreads();
                        TS_InterfaceEnable(false);
                        btnx_Revision.Enabled = true;
                        btnx_Finished.Checked = true;
                        btnStatus.Text = btnx_Finished.Text;
                        btnStatus.ForeColor = System.Drawing.Color.LimeGreen;
                        UpdateMatchTime();
                        if (m_bAutoSendMessage)
                        {
                            if (b_calculateRank)
                            {
                                UpdateMatchResult();
                                b_calculateRank = false;
                            }
                            GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);
                            OVRDataBaseUtils.AutoProgressMatch(m_MatchID, GVAR.g_sqlConn, GVAR.g_WPPlugin);//自动晋级
                            int iPhaseID = GVAR.g_ManageDB.GetPhaseID(m_MatchID);
                            GVAR.g_ManageDB.AutoGroupRank(iPhaseID);       // 自动小组排名
                            GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);
                        }
                        break;
                    }
                case GVAR.STATUS_REVISION:
                    {
                        EnalbeMatchCtrl(true);
                        EnableScoreBtn(true);
                        EnablePenaltyPeriod(true);
                        TS_InterfaceEnable(true);
                        btnx_Finished.Enabled = true;
                        btnx_Revision.Checked = true;
                        btnStatus.Text = btnx_Revision.Text;
                        btnStatus.ForeColor = System.Drawing.Color.LimeGreen;

                        UpdateMatchTime();
                        break;
                    }
                case GVAR.STATUS_CANCELED:
                    {
                        EnalbeMatchCtrl(false);
                        EnableScoreBtn(false);
                        EnablePenaltyPeriod(false);
                        TS_InterfaceEnable(false);
                        btnx_Canceled.Checked = true;
                        btnStatus.Text = btnx_Canceled.Text;
                        btnStatus.ForeColor = System.Drawing.SystemColors.ControlText;

                        UpdateMatchTime();
                        break;
                    }
                default:
                    return;
            }
        }

        private void UpdateMatchResult()
        {
            if (m_CCurMatch.m_CHomeTeam.TeamPoint > m_CCurMatch.m_CVisitTeam.TeamPoint)
            {
                GVAR.g_ManageDB.UpdateMatchResult(m_MatchID, m_CCurMatch.m_CHomeTeam.TeamPosition, GVAR.RESULT_TYPE_WIN);
                GVAR.g_ManageDB.UpdateMatchResult(m_MatchID, m_CCurMatch.m_CVisitTeam.TeamPosition, GVAR.RESULT_TYPE_LOSE);

            }
            else if (m_CCurMatch.m_CHomeTeam.TeamPoint < m_CCurMatch.m_CVisitTeam.TeamPoint)
            {
                GVAR.g_ManageDB.UpdateMatchResult(m_MatchID, m_CCurMatch.m_CHomeTeam.TeamPosition, GVAR.RESULT_TYPE_LOSE);
                GVAR.g_ManageDB.UpdateMatchResult(m_MatchID, m_CCurMatch.m_CVisitTeam.TeamPosition, GVAR.RESULT_TYPE_WIN);

            }
            else
            {
                GVAR.g_ManageDB.UpdateMatchResult(m_MatchID, m_CCurMatch.m_CHomeTeam.TeamPosition, GVAR.RESULT_TYPE_TIE);
                GVAR.g_ManageDB.UpdateMatchResult(m_MatchID, m_CCurMatch.m_CVisitTeam.TeamPosition, GVAR.RESULT_TYPE_TIE);
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
                btnHActive_6.Text = "";
                btnHActive_7.Text = "";

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
                        case 5:
                            btnHActive_6.Text = iShirtNumber.ToString();
                            break;
                        case 6:
                            btnHActive_7.Text = iShirtNumber.ToString();
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
                btnVActive_6.Text = "";
                btnVActive_7.Text = "";

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
                        case 5:
                            btnVActive_6.Text = iShirtNumber.ToString();
                            break;
                        case 6:
                            btnVActive_7.Text = iShirtNumber.ToString();
                            break;
                        default:
                            break;
                    }

                }
            }
        }

        public void ChangePeriod()
        {
            if (m_CCurMatch.CurPeriod == GVAR.PERIOD_EXTRA1)
            {
                if (lbExa1.Visible == false)
                {
                    lbExa1.Visible = true;
                    lbExa2.Visible = true;
                    lbHPt_Exa1.Visible = true;
                    lbHPt_Exa2.Visible = true;
                    lbVPt_Exa1.Visible = true;
                    lbVPt_Exa2.Visible = true;
                }

                if (!GVAR.g_ManageDB.IsExistMatchSplit(ref m_CCurMatch, GVAR.PERIOD_EXTRA1))
                {
                    GVAR.g_ManageDB.AddSplitMatch(ref m_CCurMatch, GVAR.PERIOD_EXTRA1.ToString());
                    GVAR.g_ManageDB.AddSplitMatch(ref m_CCurMatch, GVAR.PERIOD_EXTRA2.ToString());
                }
            }

            if (m_CCurMatch.CurPeriod == GVAR.PERIOD_PSO)
            {
                if (lbPSO.Visible == false)
                {
                    lbPSO.Visible = true;
                    lbHPt_PSO.Visible = true;
                    lbVPt_PSO.Visible = true;
                }
                if (!GVAR.g_ManageDB.IsExistMatchSplit(ref m_CCurMatch, GVAR.PERIOD_PSO))
                {
                    GVAR.g_ManageDB.AddSplitMatch(ref m_CCurMatch, GVAR.PERIOD_PSO.ToString());
                }
            }
           

            GVAR.g_ManageDB.UpdateMatchPeriod(ref m_CCurMatch);
            GVAR.g_ManageDB.UpdateTeamSetPt(ref m_CCurMatch,m_CCurMatch.CurPeriod);
            lbPeriod.Text = GVAR.g_ManageDB.GetPeriodName(GVAR.Str2Int(m_CCurMatch.MatchID), m_CCurMatch.CurPeriod.ToString());
        }

        private void ResetPlayerList(int iTeampos, ref DataGridView dgv)
        {
            GVAR.g_ManageDB.ResetTeamMeber(m_MatchID, iTeampos, ref dgv);

            for (int i = 0; i < dgv.RowCount; i++)
            {
                if (dgv.Rows[i].Cells["F_Active"].Value.ToString() == "1")
                {
                    if (dgv.Rows[i].Cells["Position"].Value.ToString() != "GK")
                        dgv.Rows[i].DefaultCellStyle.BackColor = System.Drawing.Color.FromArgb(224, 224, 0);
                    else
                        dgv.Rows[i].DefaultCellStyle.BackColor = System.Drawing.Color.Red;
                }
            }
            ClearAllBtnBibNumer(iTeampos);
            InitBibBtn(iTeampos);
        }
        private void InitBibBtn(int iTeamPos)
        {
            DataGridView dgv;
            if (iTeamPos==1)
            {
                dgv = dgvHomeList;
            }
            else
            {
                dgv = dgvVisitList;
            }
            for (int i = 0; i < dgv.RowCount; i++)
            {
                 String strBib =  dgv.Rows[i].Cells["Bib"].Value.ToString();
                 String strActive = dgv.Rows[i].Cells["F_Active"].Value.ToString();
                 String strPosition = dgv.Rows[i].Cells["Position"].Value.ToString();
                 switch (strBib)
                {
                    case "1":
                        if (iTeamPos == 1)
                        {
                            btnHActive_1.Text = "1";
                            btnHActive_1.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red: Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        else
                        {
                            btnVActive_1.Text = "1";
                            btnVActive_1.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        break;
                    case "2":
                        if (iTeamPos == 1)
                        {
                            btnHActive_2.Text = "2";
                            btnHActive_2.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        else
                        {
                            btnVActive_2.Text = "2";
                            btnVActive_2.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                          
                        break;
                    case "3":
                        if (iTeamPos == 1)
                        {
                            btnHActive_3.Text = "3";
                            btnHActive_3.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;

                        }
                        else
                        {
                            btnVActive_3.Text = "3";
                            btnVActive_3.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        break;
                    case "4":
                        if (iTeamPos == 1)
                        {
                            btnHActive_4.Text = "4";
                            btnHActive_4.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        else
                        { 
                            btnVActive_4.Text = "4";
                            btnVActive_4.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        break;
                    case "5":
                        if (iTeamPos == 1)
                        {
                            btnHActive_5.Text = "5";
                            btnHActive_5.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        else
                        {
                            btnVActive_5.Text = "5";
                            btnVActive_5.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        break;
                    case "6":
                        if (iTeamPos == 1)
                        {
                            btnHActive_6.Text = "6";
                            btnHActive_6.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        else
                        {
                            btnVActive_6.Text = "6";
                            btnVActive_6.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        break;
                    case "7":
                        if (iTeamPos == 1)
                        {
                            btnHActive_7.Text = "7";
                            btnHActive_7.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        else
                        {
                            btnVActive_7.Text = "7";
                            btnVActive_7.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        break;
                    case "8":
                        if (iTeamPos == 1)
                        {
                            btnHActive_8.Text = "8";
                            btnHActive_8.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        else
                        {
                            btnVActive_8.Text = "8";
                            btnVActive_8.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        break;
                    case "9":
                        if (iTeamPos == 1)
                        {
                            btnHActive_9.Text = "9";
                            btnHActive_9.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        else
                        {
                            btnVActive_9.Text = "9";
                            btnVActive_9.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        break;
                    case "10":
                        if (iTeamPos == 1)
                        {
                            btnHActive_10.Text = "10";
                            btnHActive_10.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        else
                        {
                            btnVActive_10.Text = "10";
                            btnVActive_10.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        break;
                    case "11":
                        if (iTeamPos == 1)
                        {
                            btnHActive_11.Text = "11";
                            btnHActive_11.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        else
                        {
                            btnVActive_11.Text = "11";
                            btnVActive_11.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        break;
                    case "12":
                        if (iTeamPos == 1)
                        {
                            btnHActive_12.Text = "12";
                            btnHActive_12.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        else
                        {
                            btnVActive_12.Text = "12";
                            btnVActive_12.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        break;
                    case "13":
                        if (iTeamPos == 1)
                        {
                            btnHActive_13.Text = "13";
                            btnHActive_13.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        else
                        {
                            btnVActive_13.Text = "13";
                            btnVActive_13.ForeColor = strActive == "1" ? (strPosition == "GK" ? Color.Red : Color.Yellow) : System.Drawing.SystemColors.ControlText;
                        }
                        break;
                }
            }
        }
        public int GetActiveCount(int iTeamPos)
        {
            int iCount = 0;
            if (iTeamPos == 1)
            {
                for (int i = 0; i < dgvHomeList.Rows.Count; i++)
                {
                    if (dgvHomeList.Rows[i].Cells["F_Active"].Value.ToString() == "1")
                        iCount++;
                }
            }
            else if (iTeamPos == 2)
            {
                for (int i = 0; i < dgvVisitList.Rows.Count; i++)
                {
                    if (dgvVisitList.Rows[i].Cells["F_Active"].Value.ToString() == "1")
                        iCount++;
                }
            }
            return iCount;
        }
        public bool SetPlayerActive(int iPlayerID, int iTeamPos)
        {
            if (iTeamPos == 1 && GetActiveCount(1) >= m_iInCount_Home)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("The athletes on field has reach at the max number,you can not add athlete to field any more!");
                return false;
            }
            else if (iTeamPos == 2 && GetActiveCount(2) >= m_iInCount_Visit)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("The athletes on field has reach at the max number,you can not add athlete to field any more!");
                return false;
            }
            UpdateActionTimeFromSplitStatus();
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.CurPeriod);
            int iSplitStatus = GVAR.g_ManageDB.GetSplitStatusID(m_MatchID, iSplitID);
            if (iSplitStatus != GVAR.STATUS_RUNNING)
            {
                if (iSplitStatus == GVAR.STATUS_FINISHED)
                {
                    GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iPlayerID, 1, "0");
                }
                else
                {
                    if (m_CCurMatch.CurPeriod == GVAR.PERIOD_1ST
                 || m_CCurMatch.CurPeriod == GVAR.PERIOD_2ND
                 || m_CCurMatch.CurPeriod == GVAR.PERIOD_3RD
                 || m_CCurMatch.CurPeriod == GVAR.PERIOD_4TH)
                    {
                        GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iPlayerID, 1, "480");
                    }
                    else if (m_CCurMatch.CurPeriod == GVAR.PERIOD_EXTRA1
                        || m_CCurMatch.CurPeriod == GVAR.PERIOD_EXTRA2)
                    {
                        GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iPlayerID, 1, "180");
                    }
                    else if (m_CCurMatch.CurPeriod == GVAR.PERIOD_PSO)
                    {
                        GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iPlayerID, 1, "0");
                    }
                }
            }
            else 
            {
                if (m_CCurMatch.CurPeriod == GVAR.PERIOD_PSO)
                {
                    GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iPlayerID, 1, "0");
                }
                else
                {
                    GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iPlayerID, 1, m_CCurMatch.MatchTime);
                }
                
            }
            UpdatePlayerPlayeTime(iTeamPos, iPlayerID, 0);

            if (iTeamPos == 1)
            {
                ResetPlayerList(iTeamPos, ref dgvHomeList);
            }
            else
            {
                ResetPlayerList(iTeamPos, ref dgvVisitList);
            }
            return true;
        }
        private bool SetPlayerUnActive(int iSelRegisterID, int iTeampos)
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
                        return false;
                    }

                    int iEndTime = GVAR.Str2Int(m_CCurMatch.MatchTime);
                    int iStartTime = GVAR.Str2Int(dgv.Rows[i].Cells["Time"].Value.ToString());
                    iPlayerPlayTime = Math.Abs(iEndTime - iStartTime);
                    UpdateActionTimeFromSplitStatus();
                    int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.CurPeriod);
                    int iSplitStatus =  GVAR.g_ManageDB.GetSplitStatusID(m_MatchID, iSplitID);
                    if (iSplitStatus != GVAR.STATUS_RUNNING)
                    {
                        if (iSplitStatus == GVAR.STATUS_FINISHED)
                        {
                            GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iSelRegisterID, 0, "0");
                        }
                        else
                        {
                            if (m_CCurMatch.CurPeriod == GVAR.PERIOD_1ST
                         || m_CCurMatch.CurPeriod == GVAR.PERIOD_2ND
                         || m_CCurMatch.CurPeriod == GVAR.PERIOD_3RD
                         || m_CCurMatch.CurPeriod == GVAR.PERIOD_4TH)
                            {
                                GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iSelRegisterID, 0, "480");
                            }
                            else if (m_CCurMatch.CurPeriod == GVAR.PERIOD_EXTRA1
                                || m_CCurMatch.CurPeriod == GVAR.PERIOD_EXTRA2)
                            {
                                GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iSelRegisterID, 0, "180");
                            }
                            else if (m_CCurMatch.CurPeriod == GVAR.PERIOD_PSO)
                            {
                                GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iSelRegisterID, 0, "0");
                            }
                        }     
                    }
                    else
                    {
                        if (m_CCurMatch.CurPeriod == GVAR.PERIOD_PSO)
                        {
                            UpdatePlayerPlayeTime(iTeampos, iSelRegisterID, 0);
                            GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iSelRegisterID, 0, "0");
                        }
                        else
                        {
                            UpdatePlayerPlayeTime(iTeampos, iSelRegisterID, iPlayerPlayTime);
                            GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iSelRegisterID, 0, m_CCurMatch.MatchTime);
                        }
                    }
                    UpdatePlayerPlayeTime(iTeampos, iSelRegisterID, 0);
                    ResetPlayerList(iTeampos, ref dgv);
                    return true;
                }
            }
            return false;
        }
        public void UpdateActionTimeFromSplitStatus()
        {
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.CurPeriod);
            int iSplitStatus = GVAR.g_ManageDB.GetSplitStatusID(m_MatchID, iSplitID);
            if (iSplitStatus != GVAR.STATUS_RUNNING)
            {
                //UpdatePlayerPlayeTime(iTeampos, iSelRegisterID, 0);
                if (iSplitStatus == GVAR.STATUS_FINISHED)
                {
                    m_CCurAction.ActionTime = GVAR.FormatTime("0");
                }
                else
                {
                    if (m_CCurMatch.CurPeriod == GVAR.PERIOD_1ST
                        || m_CCurMatch.CurPeriod == GVAR.PERIOD_2ND
                        || m_CCurMatch.CurPeriod == GVAR.PERIOD_3RD
                        || m_CCurMatch.CurPeriod == GVAR.PERIOD_4TH)
                    {
                        m_CCurAction.ActionTime = GVAR.FormatTime("480");
                    }
                    else if (m_CCurMatch.CurPeriod == GVAR.PERIOD_EXTRA1
                        || m_CCurMatch.CurPeriod == GVAR.PERIOD_EXTRA2)
                    {
                        m_CCurAction.ActionTime = GVAR.FormatTime("180");
                    }
                    else if (m_CCurMatch.CurPeriod == GVAR.PERIOD_PSO)
                    {
                        m_CCurAction.ActionTime = GVAR.FormatTime("0");
                    }

                }
            }
        }
        public void UpdatePlayerPlayeTime(int iTeamPos, int iRegisterID, int iPlayTime)
        {
            //int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.CurPeriod);
            //string strTotPlayTime = GVAR.g_ManageDB.GetPlayerStat(m_MatchID, iMatchSplitID, iRegisterID, iTeamPos, GVAR.strStat_PTime_Player);
            //int iTotPlayTime = GVAR.Str2Int(strTotPlayTime);

            //iTotPlayTime = iTotPlayTime + iPlayTime;
            //GVAR.g_ManageDB.UpdatePlayerStat(m_MatchID, iMatchSplitID, iRegisterID, iTeamPos, GVAR.strStat_PTime_Player, iTotPlayTime.ToString());

            GVAR.g_ManageDB.UpdatePlayerPlayTime(m_MatchID, iTeamPos, iRegisterID, GVAR.strStat_PTime_Player);
        }
        private void UpdateTeamStatic(int iTeampos, string strActionDetail3, string strStatValue)  //strActionDetail3: 其他动作
        {
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.CurPeriod);
            int TeamPos = 0, RegisterID = 0;
            if (iTeampos == 1)
            {
                TeamPos = iTeampos;
                RegisterID = m_CCurMatch.m_CHomeTeam.TeamID;
            }
            else if (iTeampos == 2)
            {
                TeamPos = iTeampos;
                RegisterID = m_CCurMatch.m_CVisitTeam.TeamID;
            }
            string ActionKey = "0" + strActionDetail3;

            if (GVAR.m_dicPlayerStat.ContainsKey(ActionKey))
            {
                string strStatCode = GVAR.m_dicPlayerStat[ActionKey];
                GVAR.g_ManageDB.UpdatePlayerStat(m_MatchID, iSplitID, RegisterID, TeamPos, strStatCode, strStatValue);
                NotifyMatchStatistics();
            }
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

            iResult = GVAR.g_ManageDB.UpdatePlayerStat(m_CCurAction);
            if (iResult <= 0)
                return false;
            if(Modetype.emMul_Admin==m_emMode || Modetype.emMul_Substitute == m_emMode ||Modetype.emSingleMachine == m_emMode)
            {

                if (m_emOperateType == EOperatetype.emMixed && m_CCurAction.ActionDetail2 == "1")
                {
                    if (m_CCurAction.TeamPos == 1)
                    {
                        iResult = m_CCurMatch.ChangePoint(1, true, 1, m_CCurMatch.CurPeriod);
                    }
                    else if (m_CCurAction.TeamPos == 2)
                    {
                        iResult = m_CCurMatch.ChangePoint(2, true, 1, m_CCurMatch.CurPeriod);
                    }

                    if (iResult == 1)
                    {
                        GVAR.g_ManageDB.UpdateTeamSetPt(ref m_CCurMatch,m_CCurMatch.CurPeriod);
                        GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);
                    }

                    UpdateUIForTeamScore();

                    if (Modetype.emSingleMachine != m_emMode)
                    {
                        m_strPointTag = System.Environment.TickCount.ToString();
                        GVAR.g_ManageDB.UpdateMatchPointTagString(m_MatchID, m_strPointTag);
                    }
                }
             }
            return true;
        }

        public bool DeleteAction()
        {
            string strPromotion = "";

            //下场反操作 先判断人数是否已经满足要求，如果已达到最大人数，不能撤销
            if (m_CCurAction.ActionKey == "023")
            {
                if (m_CCurAction.TeamPos == 1)
                {
                    if (GetActiveCount(1) >= m_iInCount_Home)
                    {
                        strPromotion = LocalizationRecourceManager.GetString(m_strSectionName, "Msg_ErrorPlayerIn");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    }
                }
                else if (m_CCurAction.TeamPos == 2)
                {
                    if (GetActiveCount(2) >= m_iInCount_Visit)
                    {
                        strPromotion = LocalizationRecourceManager.GetString(m_strSectionName, "Msg_ErrorPlayerIn");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    }
                }
            }
            int iResult = GVAR.g_ManageDB.DeleteMatchAction(m_CCurAction);
            if (iResult <= 0)
            {
                return false;
            }

            iResult = GVAR.g_ManageDB.RemovePlayerStat(m_CCurAction);
            if (iResult <= 0)
                return false;
            int iPeriod = GVAR.g_ManageDB.GetMatchPeriod(m_MatchID, m_CCurAction.MatchSplitID);
            if (Modetype.emMul_Admin == m_emMode || Modetype.emMul_Substitute == m_emMode || Modetype.emSingleMachine == m_emMode)
            {
                if (m_emOperateType == EOperatetype.emMixed && m_CCurAction.ActionDetail2 == "1")
                {
                    if (m_CCurAction.TeamPos == 1)
                    {
                        iResult = m_CCurMatch.ChangePoint(1, false, 1, iPeriod);
                    }
                    else if (m_CCurAction.TeamPos == 2)
                    {
                        iResult = m_CCurMatch.ChangePoint(2, false, 1, iPeriod);
                    }

                    if (iResult == 1)
                    {
                        GVAR.g_ManageDB.UpdateTeamSetPt(ref m_CCurMatch, iPeriod);
                        GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);
                    }

                    UpdateUIForTeamScore();
                    GVAR.g_WPPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);

                     if (Modetype.emSingleMachine != m_emMode)
                    {
                        m_strPointTag = System.Environment.TickCount.ToString();
                        GVAR.g_ManageDB.UpdateMatchPointTagString(m_MatchID, m_strPointTag);
                    }
                }
            }

            if (m_CCurAction.ActionKey == "022")   //上场反操作
            {
                if (m_CCurAction.TeamPos == 1)
                {
                    SetPlayerUnActive(m_CCurAction.RegisterID, 1);
                }
                else
                {
                    SetPlayerUnActive(m_CCurAction.RegisterID, 2);
                }
            }
            else if (m_CCurAction.ActionKey == "023")   //下场反操作
            {
                if (m_CCurAction.TeamPos == 1)
                {
                    SetPlayerActive(m_CCurAction.RegisterID, 1);
                }
                else if (m_CCurAction.TeamPos == 2)
                {
                    SetPlayerActive(m_CCurAction.RegisterID, 2);
                }
            }

            return true;
        }


        public void UpdateUIActionInfo()
        {
            lbAPlayerName.Text = m_CCurAction.RegName;

            if (m_CCurAction.ActionDetail1 != "0")
            {
                lbADetail1.Text = m_CCurAction.ActionDetailDes1;
                lbADetail2.Text = m_CCurAction.ActionDetailDes2;
            }
            else if (m_CCurAction.ActionDetail1 == "0")
            {
                lbADetail1.Text = m_CCurAction.ActionDetailDes3;
                lbADetail2.Text = "";
            }
            else
            {
                lbADetail1.Text = "";
                lbADetail2.Text = "";
            }            
        }

        public void InitActionGridHeader()
        {
            dgvAction.Columns.Clear();

            string[] strField = new string[7];
            strField[0] = "F_ActionNumberID";
            strField[1] = "Period";
            strField[2] = "ActionTime";
            strField[3] = "Team";
            strField[4] = "Bib";
            strField[5] = "RegisterName";
            strField[6] = "ActionDes";

            for (int i = 0; i < strField.Length; i++)
            {
                DataGridViewColumn col = new DataGridViewTextBoxColumn();
                col.HeaderText = strField[i];
                col.Name = strField[i];
                col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
                col.SortMode = DataGridViewColumnSortMode.NotSortable;
                col.ReadOnly = true;
                dgvAction.Columns.Add(col);
            }
            dgvAction.Columns[0].Visible = false;
        }
        public string GetPeriodCode(int iMatchID, int iMatchSplitID)
        {
            int iPeriod = GVAR.g_ManageDB.GetMatchPeriod(iMatchID, iMatchSplitID);
            switch (iPeriod)
            {
                case GVAR.PERIOD_1ST: return "Q1";
                case GVAR.PERIOD_2ND: return "Q2";
                case GVAR.PERIOD_3RD: return "Q3";
                case GVAR.PERIOD_4TH: return "Q4";
                case GVAR.PERIOD_EXTRA1: return "ET1";
                case GVAR.PERIOD_EXTRA2: return "ET2";
                case GVAR.PERIOD_PSO: return "PSO";
            }
            return string.Empty;
        }
        public void FillDataGridView(DataGridView dgv, SqlDataReader dt)
        {
            if (dgv == null || dt == null) return;
            if (dt.FieldCount < 1) return;

            bool bResetColumns = false;
            if (dt.FieldCount != dgv.Columns.Count)
            {
                bResetColumns = true;
            }
            else
            {
                for (int i = 0; i < dt.FieldCount; i++)
                {
                    if (dgv.Columns[i].HeaderText != dt.GetName(i))
                    {
                        bResetColumns = true;
                        break;
                    }
                }
            }

            try
            {
                // Reset Columns
                if (bResetColumns)
                {
                    dgv.Columns.Clear();
                    for (int i = 0; i < dt.FieldCount; i++)
                    {
                        DataGridViewColumn col = null;
                        bool bTextBoxCol = true;

                        if (bTextBoxCol)
                        {
                            col = new DataGridViewTextBoxColumn();
                            col.ReadOnly = true;
                        }

                        if (col != null)
                        {
                            col.HeaderText = dt.GetName(i);
                            col.Name = dt.GetName(i);


                            col.Frozen = false;
                            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
                            col.SortMode = DataGridViewColumnSortMode.NotSortable;
                            col.Resizable = DataGridViewTriState.False;
                            dgv.Columns.Add(col);
                        }
                    }
                }

                for (int i = 0; i < dgv.Columns.Count; i++)
                {
                    System.Drawing.SizeF sf = dgv.CreateGraphics().MeasureString(dgv.Columns[i].HeaderText, dgv.Font);
                    if (dgv.Columns[i].HeaderText == "Bib")
                    {
                        dgv.Columns[i].Width = System.Convert.ToInt32(sf.Width + 5f);
                    }
                    if (dgv.Columns[i].HeaderText == "Name")
                    {
                        dgv.Columns[i].Width = System.Convert.ToInt32(sf.Width + 108f);
                    }
                    if (dgv.Columns[i].HeaderText == "Position")
                    {
                        dgv.Columns[i].Width = System.Convert.ToInt32(sf.Width + 5f);
                    }
                }
                // Fill DataGridView
                dgv.Rows.Clear();
                int iRowNum = 0;
                while (dt.Read())
                {
                    DataGridViewRow dr = new DataGridViewRow();
                    dr.CreateCells(dgv);
                    dr.Selected = false;

                    for (int i = 0; i < dt.FieldCount; i++)
                    {
                        dr.Cells[i].Value = dt[i].ToString();
                    }
                    iRowNum++;
                    dr.HeaderCell.Value = iRowNum.ToString();

                    dgv.Rows.Add(dr);
                }

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
                return;
            }
        }
        public void UpdateActionList(ref List<OVRWPActionInfo> lstAction, int iListIndex,bool bClear)
        {
            if ( Modetype.emMul_Admin ==m_emMode
                || Modetype.emMul_Monitor == m_emMode
                || Modetype.emSingleMachine == m_emMode)
            {
                GVAR.g_ManageDB.GetMatchActionList(m_MatchID, ref m_lstAction,5);
            }
            else if (Modetype.emMul_WhiteStat == m_emMode)
            {
                GVAR.g_ManageDB.GetMatchActionList(m_MatchID, ref m_lstAction, 1);
            }
            else if (Modetype.emMul_BlueStat == m_emMode)
            {
                GVAR.g_ManageDB.GetMatchActionList(m_MatchID, ref m_lstAction, 2);
            }
            else if (Modetype.emMul_DoubleTeamStat == m_emMode)
            {
                GVAR.g_ManageDB.GetMatchActionList(m_MatchID, ref m_lstAction, 3);
            }
            else if (Modetype.emMul_Substitute == m_emMode)
            {
                GVAR.g_ManageDB.GetMatchActionList(m_MatchID, ref m_lstAction, 4);
            }
            if (bClear)
            {
                m_lstAction.Clear();
            }
            
            if (dgvAction.Columns.Count <= 0)
            {
                InitActionGridHeader();
            }

            string[] listColumn = new string[dgvAction.Columns.Count];
            //加入列头描述
            for (int i = 0; i< listColumn.Length; i++)
            {
                listColumn[i] = dgvAction.Columns[i].HeaderText;
            }
            

            if (iListIndex < 0)    //全部更新
            {
                dgvAction.Rows.Clear();
                for (int i = 0; i < lstAction.Count; i++)
                {
                    OVRWPActionInfo tmpAction = lstAction.ElementAt(i);
                    DataGridViewRow dr = new DataGridViewRow();
                    dr.CreateCells(dgvAction);
                    dr.Selected = false;
                    dr.Cells[0].Value = tmpAction.AcitonID;
                    dr.Cells[1].Value = GetPeriodCode(tmpAction.MatchID, tmpAction.MatchSplitID);
                    dr.Cells[2].Value = tmpAction.ActionTime;

                    if (tmpAction.TeamPos == 1)
                    {
                        dr.Cells[3].Value = m_CCurMatch.m_CHomeTeam.TeamName;
                    }
                    else if (tmpAction.TeamPos == 2)
                    {
                        dr.Cells[3].Value = m_CCurMatch.m_CVisitTeam.TeamName;
                    }
                    dr.Cells[4].Value = tmpAction.ShirtNo;
                    dr.Cells[5].Value = tmpAction.RegName;
                    dr.Cells[6].Value = tmpAction.ActionDes;

                    dgvAction.Rows.Add(dr);
                }
            }
           
            ////////////////////////////////
            //设置列宽
            for (int i = 0; i < listColumn.Length; i++)
            {
                System.Drawing.SizeF sf = dgvAction.CreateGraphics().MeasureString(listColumn[i], dgvAction.Font);
                if (listColumn[i] == "RegisterName" || listColumn[i] == "ActionDes")
                {
                    dgvAction.Columns[i].Width = System.Convert.ToInt32(sf.Width + 25f);
                }
                else
                {
                    dgvAction.Columns[i].Width = System.Convert.ToInt32(sf.Width + 15f);
                }
            }

            ///////////////////////////
            //焦点在最后一行
            if (dgvAction.Rows.Count > 0)
            {
                int iIndex = dgvAction.Rows.Count - 1;
                dgvAction.FirstDisplayedScrollingRowIndex = iIndex;
                dgvAction.Rows[iIndex].Selected = true;
            }
        }
    }
}
