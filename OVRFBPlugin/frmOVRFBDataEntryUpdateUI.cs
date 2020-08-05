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

namespace AutoSports.OVRFBPlugin
{
    public partial class frmOVRFBDataEntry
    {
        private void InitUI()
        {           
            OVRDataBaseUtils.SetDataGridViewStyle(dgvHomeList);
            OVRDataBaseUtils.SetDataGridViewStyle(dgvVisitList);

            InitMatchInfo();
        }
       
        private void EnableMatchBtn(bool bEnable)   //根据是否进入比赛来决定按钮是否可用        {
            btnxExPathSel.Enabled = bEnable;
            btn_Export.Enabled = bEnable;
            btnExit.Enabled = bEnable;
            btnStatus.Enabled = bEnable;
        }

        private void EnalbeMatchCtrl(Boolean bEnabled)   //根据比赛状态，使控件是否可用
        {
            btnWeatherSet.Enabled = bEnabled;
            btnOfficial.Enabled = bEnabled;
            btnTeamInfo.Enabled = bEnabled;
        }

        private void EnableScoreBtn(bool bEnabled)
        {
            btnHPt_Add.Enabled = bEnabled; 
            btnHPt_Sub.Enabled = bEnabled;
            btnVPt_Add.Enabled = bEnabled;
            btnVPt_Sub.Enabled = bEnabled;
            btnOperatType.Enabled = bEnabled;
            btnMatchResult.Enabled = bEnabled;
            btnStart.Enabled = bEnabled;
            tbAddTime.Enabled = bEnabled;

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
            MatchTime.Enabled = bEnabled;

           
            gbAttempt.Enabled = bEnabled;
            gbResult.Enabled = bEnabled;
            gbCards.Enabled = bEnabled;
            gbSubstitutions.Enabled = bEnabled;
            gbFouls.Enabled = bEnabled;
            gbTeamPlay.Enabled = bEnabled;
            gbBallPossesion.Enabled = bEnabled;

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
        private void EnablePenaltyPeriod(bool bEnabled)
        {
            if (!bEnabled)
            {
                gbFouls.Enabled = false;
                gbTeamPlay.Enabled = false;
                gbBallPossesion.Enabled = false;
                gbAttempt.Enabled = false;
                gbResult.Enabled = false;
                gbSubstitutions.Enabled = false;
                gbCards.Enabled = false;
                btnStart.Enabled = false;
                MatchTime.Enabled = false;
            }
            else
            {
                if (m_CCurMatch.Period == GVAR.PERIOD_PenaltyShoot)
                {
                    gbFouls.Enabled = false;
                    gbTeamPlay.Enabled = false;
                    gbBallPossesion.Enabled = false;

                    btnGoal.Enabled = true;
                    btnMissed.Enabled = true;
                    btnBlock.Enabled = true;
                    btnCrossbar.Enabled = true;
                    btnOwnGoal.Enabled = false;

                    btnShot.Enabled = false;
                    btnFreeKick.Enabled = false;
                    btnPenalty.Enabled = true;
                    btnStart.Enabled = false;
                    MatchTime.Enabled = false;
                }
                else
                {
                    gbFouls.Enabled = true;
                    gbTeamPlay.Enabled = true;
                    gbBallPossesion.Enabled = true;

                    btnGoal.Enabled = true;
                    btnMissed.Enabled = true;
                    btnBlock.Enabled = true;
                    btnCrossbar.Enabled = true;
                    btnOwnGoal.Enabled = true;

                    btnShot.Enabled = true;
                    btnFreeKick.Enabled = true;
                    btnPenalty.Enabled = true;
                    btnStart.Enabled = true;
                    MatchTime.Enabled = true;
                }
            }
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
            int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.Period);

            string strTemp = GVAR.g_ManageDB.GetPlayerStat(m_MatchID, iMatchSplitID, m_CCurMatch.m_CHomeTeam.TeamID, 1, GVAR.strStat_PNO_Team);
            homePossTime.Text = CheckInput(strTemp);

            strTemp = GVAR.g_ManageDB.GetPlayerStat(m_MatchID, iMatchSplitID, m_CCurMatch.m_CVisitTeam.TeamID, 2, GVAR.strStat_PNO_Team);
            visitPossTime.Text = CheckInput(strTemp);

            strTemp = GVAR.g_ManageDB.GetAddTime(m_MatchID, iMatchSplitID);
            tbAddTime.Text = CheckInput(strTemp);

        }
        private void InitMatchInfo()
        {
            int iPeriod = 0;
            GVAR.g_ManageDB.GetMatchPeriodSetting(m_MatchID, ref iPeriod);
            GVAR.g_MatchPeriodSet = iPeriod;
            lb_EventDes.Text = m_CCurMatch.SportDes;
            lb_MatchDes.Text = m_CCurMatch.PhaseDes;
            lb_VenueDes.Text = m_CCurMatch.VenueDes;
            lb_DateDes.Text = m_CCurMatch.DateDes;


            lbHomeDes.Text = m_CCurMatch.m_CHomeTeam.TeamName;
            lbHomeTeam.Text = m_CCurMatch.m_CHomeTeam.TeamName;          

            lbVisitDes.Text = m_CCurMatch.m_CVisitTeam.TeamName;
            lbVisitTeam.Text = m_CCurMatch.m_CVisitTeam.TeamName;
          
            m_bUIChange = false;
            int imatchTime = m_CCurMatch.MatchTime.Trim().Length == 0 ? 0 : int.Parse(m_CCurMatch.MatchTime.Trim());
            MatchTime.Text = GVAR.TranslateINT32toTime(imatchTime);
            m_bUIChange = true;

            lbPeriod.Text = GVAR.g_ManageDB.GetPeriodName(m_MatchID, m_CCurMatch.Period.ToString());
            int iValidSplitCode = GVAR.g_ManageDB.GetMaxValidSplitCode(m_MatchID);

            if (GVAR.g_MatchPeriodSet==0)
            {
                BtnExtraVisible(false);
                BtnPSOVisible(false);
            }
            else if (GVAR.g_MatchPeriodSet ==1)
            {
                BtnExtraVisible(false);

                if (m_CCurMatch.Period == GVAR.PERIOD_PenaltyShoot || iValidSplitCode == GVAR.PERIOD_PenaltyShoot)
                {
                    BtnPSOVisible(true);
                }
                else
                {
                    BtnPSOVisible(false);
                }
            }
            else if (GVAR.g_MatchPeriodSet ==2)
            {
                if (m_CCurMatch.Period >= GVAR.PERIOD_1stExtraHalf || iValidSplitCode >= GVAR.PERIOD_1stExtraHalf)
                {
                    BtnExtraVisible(true);
                }
                else
                {
                    BtnExtraVisible(false);
                }

                if (m_CCurMatch.Period == GVAR.PERIOD_PenaltyShoot || iValidSplitCode >= GVAR.PERIOD_PenaltyShoot)
                {
                    BtnPSOVisible(true);
                }
                else
                {
                    BtnPSOVisible(false);
                }
            }

            lbHomeDes.Text = m_CCurMatch.m_CHomeTeam.TeamName;
            lbHomeTeam.Text = m_CCurMatch.m_CHomeTeam.TeamName;
            lbVisitDes.Text = m_CCurMatch.m_CVisitTeam.TeamName;
            lbVisitTeam.Text = m_CCurMatch.m_CVisitTeam.TeamName;

            InitTeamInfo();
        }

        private void InitTeamInfo()
        {
            UpdateUIForTeamScore();

            ResetPlayerList(1, ref dgvHomeList);
            ResetPlayerList(2, ref dgvVisitList);
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
                        dgv.Columns[i].Width = System.Convert.ToInt32(sf.Width+5f);
                    }
                    if (dgv.Columns[i].HeaderText == "Name")
                    {
                        dgv.Columns[i].Width = System.Convert.ToInt32(sf.Width+108f);
                    }
                    if (dgv.Columns[i].HeaderText == "Position")
                    {
                        dgv.Columns[i].Width = System.Convert.ToInt32(sf.Width+5f);
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
                        //if (dt.GetName(i)=="Time")
                        //{
                        //    string strTime = dt[i].ToString();
                        //    if (strTime.Length == 0)
                        //    {
                        //        dr.Cells[i].Value = GVAR.Str2Int(GVAR.g_FBPlugin.m_frmFBPlugin.m_CCurMatch.MatchTime);
                        //    }
                        //}
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

            lbHPt_Set1.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_1stHalf);
            lbHPt_Set2.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_2ndHalf);
            lbHPt_Exa1.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_1stExtraHalf);
            lbHPt_Exa2.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_2ndExtraHalf);
            lbHPt_PSO.Text = m_CCurMatch.m_CHomeTeam.GetScore(GVAR.PERIOD_PenaltyShoot);

            lbVPt_Set1.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_1stHalf);
            lbVPt_Set2.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_2ndHalf);
            lbVPt_Exa1.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_1stExtraHalf);
            lbVPt_Exa2.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_2ndExtraHalf);
            lbVPt_PSO.Text = m_CCurMatch.m_CVisitTeam.GetScore(GVAR.PERIOD_PenaltyShoot);
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
                        btnx_Suspend.Enabled = true;
                        btnx_Unofficial.Enabled = true;
                        btnx_Running.Checked = true;
                        btnStatus.Text = btnx_Running.Text;
                        btnStatus.ForeColor = System.Drawing.Color.Red;

                        int iMatchSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.Period);
                        int iSplitStatus = GVAR.g_ManageDB.GetSplitStatusID(m_MatchID, iMatchSplitID);
                        if (iSplitStatus != GVAR.STATUS_RUNNING && iSplitStatus != GVAR.STATUS_FINISHED && m_CCurMatch.Period == GVAR.PERIOD_1stHalf)
                        {
                            btnStartPeriod_Click(null, null);
                        }
                        break;
                    }
                case GVAR.STATUS_SUSPEND:
                    {
                        EnalbeMatchCtrl(true);
                        EnableScoreBtn(false);
                        EnablePenaltyPeriod(false);
                        btnx_Running.Enabled = true;
                        btnx_Suspend.Checked = true;
                        btnStatus.Text = btnx_Suspend.Text;
                        btnStatus.ForeColor = System.Drawing.Color.Red;
                        if (m_CCurMatch.bRunTime)
                        {
                            btnStart_Click(null, null);
                        }
                        GVAR.g_ManageDB.UpdateMatchTime(m_MatchID, m_CCurMatch.MatchTime);
                        break;
                    }
                case GVAR.STATUS_UNOFFICIAL:
                    {
                        EnalbeMatchCtrl(true);
                        EnableScoreBtn(true);
                        EnablePenaltyPeriod(true);
                        btnx_Finished.Enabled = true;
                        btnx_Unofficial.Checked = true;
                        btnStatus.Text = btnx_Unofficial.Text;
                        btnStatus.ForeColor = System.Drawing.Color.LimeGreen;
                        if (m_bAutoSendMessage)
                        {
                            UpdateMatchResult();
                            GVAR.g_ManageDB.UpdateMatchTime(m_MatchID, m_CCurMatch.MatchTime);
                            GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);
                        }
                        break;
                    }
                case GVAR.STATUS_FINISHED:
                    {
                        EnalbeMatchCtrl(false);
                        EnableScoreBtn(false);
                        EnablePenaltyPeriod(false);
                        btnx_Revision.Enabled = true;
                        btnx_Finished.Checked = true;
                        btnStatus.Text = btnx_Finished.Text;
                        btnStatus.ForeColor = System.Drawing.Color.LimeGreen;

                        GVAR.g_ManageDB.UpdateMatchTime(m_MatchID, m_CCurMatch.MatchTime);
                        if (m_bAutoSendMessage)
                        {
                            if (b_calculateRank)
                            {
                                 UpdateMatchResult();
                                b_calculateRank = false;
                            }
                            GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);
                            OVRDataBaseUtils.AutoProgressMatch(m_MatchID, GVAR.g_sqlConn, GVAR.g_FBPlugin);//自动晋级
                            int iPhaseID = GVAR.g_ManageDB.GetPhaseID(m_MatchID);
                            GVAR.g_ManageDB.AutoGroupRank(iPhaseID); 
                            GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);
                        }
                        break;
                    }
                case GVAR.STATUS_REVISION:
                    {
                        EnalbeMatchCtrl(true);
                        EnableScoreBtn(true);
                        EnablePenaltyPeriod(true);

                        btnx_Finished.Enabled = true;
                        btnx_Revision.Checked = true;
                        btnStatus.Text = btnx_Revision.Text;
                        btnStatus.ForeColor = System.Drawing.Color.LimeGreen;

                        GVAR.g_ManageDB.UpdateMatchTime(m_MatchID, m_CCurMatch.MatchTime);
                        break;
                    }
                case GVAR.STATUS_CANCELED:
                    {
                        EnalbeMatchCtrl(false);
                        EnableScoreBtn(false);
                        EnablePenaltyPeriod(false);

                        btnx_Canceled.Checked = true;
                        btnStatus.Text = btnx_Canceled.Text;
                        btnStatus.ForeColor = System.Drawing.SystemColors.ControlText;

                        GVAR.g_ManageDB.UpdateMatchTime(m_MatchID, m_CCurMatch.MatchTime);
                        break;
                    }
                default:
                    return;
            }
        }

        private void UpdateMatchResult()
        {

            int iPSO_HScore = 0;
            int iPSO_VScore = 0;
            int iTot_HScore = 0;
            int iTot_VScore = 0;

            int iPenaltySplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, GVAR.PERIOD_PenaltyShoot);
            if (iPenaltySplitID > 0)
            {
                iPSO_HScore = GVAR.g_ManageDB.GetSplitScore(m_MatchID, iPenaltySplitID, 1);
                iPSO_VScore = GVAR.g_ManageDB.GetSplitScore(m_MatchID, iPenaltySplitID, 2);
            }

            iTot_HScore = m_CCurMatch.m_CHomeTeam.TeamPoint + iPSO_HScore;
            iTot_VScore = m_CCurMatch.m_CVisitTeam.TeamPoint + iPSO_VScore;
            if (iTot_HScore > iTot_VScore)
            {
                GVAR.g_ManageDB.UpdateMatchResult(m_MatchID, m_CCurMatch.m_CHomeTeam.TeamPosition, GVAR.RESULT_TYPE_WIN);
                GVAR.g_ManageDB.UpdateMatchResult(m_MatchID, m_CCurMatch.m_CVisitTeam.TeamPosition, GVAR.RESULT_TYPE_LOSE);

            }
            else if (iTot_HScore < iTot_VScore)
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

        public void ChangePeriod()
        {
            if (m_CCurMatch.Period == GVAR.PERIOD_1stExtraHalf)
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

                if (!GVAR.g_ManageDB.IsExistMatchSplit(ref m_CCurMatch, GVAR.PERIOD_1stExtraHalf))
                {
                    GVAR.g_ManageDB.AddSplitMatch(ref m_CCurMatch, GVAR.PERIOD_1stExtraHalf.ToString());
                    GVAR.g_ManageDB.AddSplitMatch(ref m_CCurMatch, GVAR.PERIOD_2ndExtraHalf.ToString());
                }
            }

            if (m_CCurMatch.Period == GVAR.PERIOD_PenaltyShoot)
            {
                if (lbPSO.Visible == false)
                {
                    lbPSO.Visible = true;
                    lbHPt_PSO.Visible = true;
                    lbVPt_PSO.Visible = true;
                }
                if (!GVAR.g_ManageDB.IsExistMatchSplit(ref m_CCurMatch, GVAR.PERIOD_PenaltyShoot))
                {
                    GVAR.g_ManageDB.AddSplitMatch(ref m_CCurMatch, GVAR.PERIOD_PenaltyShoot.ToString());
                }
            }

            GVAR.g_ManageDB.UpdateMatchPeriod(ref m_CCurMatch);
            //if (m_CCurMatch.Period != GVAR.PERIOD_PenaltyShoot)
            {
                GVAR.g_ManageDB.UpdateTeamSetPt(ref m_CCurMatch, m_CCurMatch.Period);
            }
            lbPeriod.Text = GVAR.g_ManageDB.GetPeriodName(GVAR.Str2Int(m_CCurMatch.MatchID), m_CCurMatch.Period.ToString());
        }

        private void ResetPlayerList(int iTeampos, ref DataGridView dgv)
        {
            GVAR.g_ManageDB.ResetTeamMeber(m_MatchID, iTeampos, ref dgv);

            for (int i = 0; i < dgv.RowCount; i++)
            {
                if (dgv.Rows[i].Cells["F_Active"].Value.ToString() == "1")
                {
                    dgv.Rows[i].DefaultCellStyle.BackColor = System.Drawing.Color.Yellow;
                }
            }
        }

        private void SetPlayerPlayTime(int iSelRegisterID,int iTeampos)
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
            for (int i = 0; i < dgv.Rows.Count; i++)
            {
                if (GVAR.Str2Int(dgv.Rows[i].Cells["F_RegisterID"].Value) == iSelRegisterID)
                {
                    if (dgv.Rows[i].Cells["F_Active"].Value.ToString() != "1")
                    {
                        return;
                    }
                    GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iSelRegisterID, 1, "0");
                    UpdatePlayerPlayeTime(iTeampos, iSelRegisterID);
                }
            }
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

            for (int i = 0; i < dgv.Rows.Count; i++)
            {
                if (GVAR.Str2Int(dgv.Rows[i].Cells["F_RegisterID"].Value) == iSelRegisterID)
                {
                    if (dgv.Rows[i].Cells["F_Active"].Value.ToString() != "1")
                    {
                        return false;
                    }

                    GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iSelRegisterID, 0, "0");
                    UpdatePlayerPlayeTime(iTeampos, iSelRegisterID);
                    ResetPlayerList(iTeampos, ref dgv);
                    return true;
                }
            }
            return false;
        }

        public void UpdatePlayerPlayeTime(int iTeamPos, int iRegisterID)
        {
            GVAR.g_ManageDB.UpdatePlayerPlayTime(m_MatchID, iTeamPos, iRegisterID, GVAR.strStat_PTime_Player);
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

            GVAR.g_ManageDB.UpdatePlayerActive(m_MatchID, iPlayerID, 1, m_CCurMatch.MatchTime);
            UpdatePlayerPlayeTime(iTeamPos, iPlayerID);

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

        public int GetPlayerIndexByShirtNo(List<SPlayerInfo> lstPlayer, int iShirtNo)
        {
            int iIndex = -1;
            for (int i = 0; i < lstPlayer.Count; i++)
            {
                SPlayerInfo  tmpPlayer = lstPlayer.ElementAt(i);
                if (tmpPlayer.iShirtNumber == iShirtNo)
                {
                    iIndex = i;
                    break;
                }
            }
            return iIndex;
        }

        public int GetPlayerIndexByRegisterID(List<SPlayerInfo> lstPlayer, int iRegisterID)
        {
            int iIndex = -1;
            for (int i = 0; i < lstPlayer.Count; i++)
            {
                SPlayerInfo tmpPlayer = lstPlayer.ElementAt(i);
                if (tmpPlayer.iRegisterID == iRegisterID)
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

            iResult = GVAR.g_ManageDB.UpdatePlayerStat(m_CCurAction);
            if (iResult <= 0)
                return false;
            
            if (m_emOperateType == EOperatetype.emMixed && m_CCurAction.ActionType == EActionType.emShot)
            {
                if (m_CCurAction.ActionDetail2 == "1")
                {
                    if (m_CCurAction.TeamPos == 1)
                    {
                        iResult = m_CCurMatch.ChangePoint(1, true, 1, m_CCurMatch.Period);
                    }
                    else if (m_CCurAction.TeamPos == 2)
                    {
                        iResult = m_CCurMatch.ChangePoint(2, true, 1, m_CCurMatch.Period);
                    }

                    if (iResult == 1)
                    {
                        GVAR.g_ManageDB.UpdateTeamSetPt(ref m_CCurMatch, m_CCurMatch.Period);
                        GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);
                        // 添加Info的MatchResult
                        GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);
                    }
                }
                else if(m_CCurAction.ActionDetail2 == "4" && m_CCurAction.ActionDetail1 == "0")
                {
                    if (m_CCurAction.TeamPos == 1)
                    {
                        iResult = m_CCurMatch.ChangePoint(2, true, 1, m_CCurMatch.Period);
                    }
                    else if (m_CCurAction.TeamPos == 2)
                    {
                        iResult = m_CCurMatch.ChangePoint(1, true, 1, m_CCurMatch.Period);
                    }

                    if (iResult == 1)
                    {
                        GVAR.g_ManageDB.UpdateTeamSetPt(ref m_CCurMatch, m_CCurMatch.Period);
                        GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);
                        // 添加Info的MatchResult
                        GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);
                    }
                }

                UpdateUIForTeamScore();
               
            }
            // 添加Info的MatchStatistics
            GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, m_MatchID, m_MatchID, null);
            return true;
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
        public bool DeleteAction()
        {
             string strPromotion = "";

            //下场反操作 先判断人数是否已经满足要求，如果已达到最大人数，不能撤销
             if (m_CCurAction.ActionDetail1 == "0" && m_CCurAction.ActionDetail3 == "13")
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

            if (m_CCurAction.ActionDetail1 == "0" && (m_CCurAction.ActionDetail3 == "6" || m_CCurAction.ActionDetail3 == "7"))
            {
                if (m_CCurAction.TeamPos == 1)
                {
                    m_iInCount_Home ++;
                    GVAR.g_ManageDB.SetTeamMemberCount(m_MatchID, 1, m_iInCount_Home);
                }
                else if (m_CCurAction.TeamPos == 2)
                {
                    m_iInCount_Visit++;
                    GVAR.g_ManageDB.SetTeamMemberCount(m_MatchID, 2, m_iInCount_Visit);
                }
            }

            iResult = GVAR.g_ManageDB.RemovePlayerStat(m_CCurAction);
            if (iResult <= 0)
                return false;
            int iPeriod = GVAR.g_ManageDB.GetMatchPeriod(m_MatchID, m_CCurAction.MatchSplitID);
            if (m_emOperateType == EOperatetype.emMixed && m_CCurAction.ActionType == EActionType.emShot)
            {
                if(m_CCurAction.ActionDetail2 == "1")
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
                    GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);
                }
                else if(m_CCurAction.ActionDetail2 == "4" && m_CCurAction.ActionDetail1 == "0")
                {
                    if (m_CCurAction.TeamPos == 1)
                    {
                        iResult = m_CCurMatch.ChangePoint(2, false, 1, iPeriod);
                    }
                    else if (m_CCurAction.TeamPos == 2)
                    {
                        iResult = m_CCurMatch.ChangePoint(1, false, 1, iPeriod);
                    }

                    if (iResult == 1)
                    {
                        GVAR.g_ManageDB.UpdateTeamSetPt(ref m_CCurMatch, m_CCurMatch.Period);
                        GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);
                    }

                    UpdateUIForTeamScore();
                    GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_MatchID, m_MatchID, null);
                }
            }
            
            if (m_CCurAction.ActionDetail1 == "0" && (m_CCurAction.ActionDetail3 == "12"))   //上场反操作            {
                if (m_CCurAction.TeamPos == 1)
                {
                    SetPlayerUnActive(m_CCurAction.RegisterID, 1);
                }
                else
                {
                    SetPlayerUnActive(m_CCurAction.RegisterID, 2);
                }
            }
            else if (m_CCurAction.ActionDetail1 == "0" && m_CCurAction.ActionDetail3 == "13")   //下场反操作
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
                lbADetail2.Text = m_CCurAction.ActionDetailDes2;
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
                col.SortMode =  DataGridViewColumnSortMode.NotSortable;
                col.ReadOnly = true;
                dgvAction.Columns.Add(col);
            }
            dgvAction.Columns[0].Visible = false;
        }
        private void UpdateAddTime(string strTime)
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(iMatchID, m_CCurMatch.Period);
            GVAR.g_ManageDB.UpdateAddTime(iMatchID, iSplitID, strTime);
            GVAR.g_FBPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, iMatchID, iMatchID, null);
        }
        private void UpdateTeamStatic(int iTeampos, string strActionDetail3, string strStatValue)
        {
            int iSplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, m_CCurMatch.Period);
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
        public string GetPeriodCode(int iMatchID, int iMatchSplitID)
        {
            int iPeriod = GVAR.g_ManageDB.GetMatchPeriod(iMatchID, iMatchSplitID);
            switch (iPeriod)
            {
                case GVAR.PERIOD_1stHalf: return "HT";
                case GVAR.PERIOD_2ndHalf: return "FT";
                case GVAR.PERIOD_1stExtraHalf: return "ET1";
                case GVAR.PERIOD_2ndExtraHalf: return "ET2";
                case GVAR.PERIOD_PenaltyShoot: return "PSO";
            }
            return string.Empty;
        }
        public void UpdateActionList(ref List<OVRFBActionInfo> lstAction, int iListIndex)
        {
            if (dgvAction.Columns.Count <= 0)
            {
                InitActionGridHeader();
            }

            string[] listColumn = new string[dgvAction.Columns.Count];
            //加入列头描述
            for (int i = 0; i < listColumn.Length; i++)
            {
                listColumn[i] = dgvAction.Columns[i].HeaderText;
            }
            

            if (iListIndex < 0)    //全部更新
            {
               dgvAction.Rows.Clear();
                for (int i = 0; i < lstAction.Count; i++)
                {
                    OVRFBActionInfo tmpAction = lstAction.ElementAt(i);
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
           
            //////////////////////////////////
            ////设置列宽
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

            /////////////////////////////
            //设置光标
            if (dgvAction.Rows.Count > 0)
            {
                int iIndex = dgvAction.Rows.Count - 1;
                dgvAction.FirstDisplayedScrollingRowIndex = iIndex;
                dgvAction.Rows[iIndex].Selected = true;
            }
        }
    }
}
