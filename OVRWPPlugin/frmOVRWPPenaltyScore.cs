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

namespace AutoSports.OVRWPPlugin
{
    public partial class frmOVRWPPenaltyScore : DevComponents.DotNetBar.Office2007Form
    {
        OVRWPMatchInfo m_CCurMatch = new OVRWPMatchInfo();
        int m_iMatchPenaltySplitID;
        int m_MatchID = -1;
        OVRWPActionInfo m_CurAction = new OVRWPActionInfo();
        int m_iHomePScore;
        int m_iVisitPScore;
        int m_iHomeGKID;
        int m_iVisitGKID;

        public frmOVRWPPenaltyScore(ref OVRWPMatchInfo cMatchInfo)
        {
            InitializeComponent();
            m_CCurMatch = cMatchInfo;
            m_CurAction.Init();
            m_MatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            m_iMatchPenaltySplitID = GVAR.g_ManageDB.GetMatchSplitID(m_MatchID, GVAR.PERIOD_PSO);
            if (m_iMatchPenaltySplitID <= 0)
            {
                m_iMatchPenaltySplitID = GVAR.g_ManageDB.AddSplitMatch(ref m_CCurMatch, GVAR.PERIOD_PSO.ToString());
            }
            else
            {
                m_iHomePScore = GVAR.g_ManageDB.GetSplitScore(m_MatchID, m_iMatchPenaltySplitID, 1);
                m_iVisitPScore = GVAR.g_ManageDB.GetSplitScore(m_MatchID, m_iMatchPenaltySplitID, 2);
            }
        }

        private void frmOVRWPPenaltyScore_Load(object sender, EventArgs e)
        {
            Localization();
            lbHomeName.Text = m_CCurMatch.m_CHomeTeam.TeamName;
            lbVisitName.Text = m_CCurMatch.m_CVisitTeam.TeamName;

            lbHGKName.Text = "";
            lbVGKName.Text = "";

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvHomePenalty);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvVisitPenalty);
            FillPlayerUI();
        }

        private void Localization()
        {
            string strSectionName = GVAR.g_WPPlugin.GetSectionName();

            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmPenalytScore");
            this.btnSetPlayer.Text = LocalizationRecourceManager.GetString(strSectionName, "btnSetPlayer");
            this.lbHGK.Text = LocalizationRecourceManager.GetString(strSectionName, "lbGK");
            this.lbVGK.Text = LocalizationRecourceManager.GetString(strSectionName, "lbGK");
        }
        private void btnChosePlayer_Click(object sender, EventArgs e)
        {
            int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
            int iHomeRegID = m_CCurMatch.m_CHomeTeam.TeamID;
            int iVisitRegID = m_CCurMatch.m_CVisitTeam.TeamID;
            string strHomeName = m_CCurMatch.m_CHomeTeam.TeamName;
            string strVisitName = m_CCurMatch.m_CVisitTeam.TeamName;

            frmOVRWPPenaltyPlayer PenaltyMemberForm = new frmOVRWPPenaltyPlayer(iMatchID, m_iMatchPenaltySplitID, iHomeRegID, iVisitRegID, strHomeName, strVisitName);
            PenaltyMemberForm.ShowDialog();

            FillPlayerUI();
        }

     

        private void dgvHomePenalty_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvHomePenalty.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex >= 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                if (dgvHomePenalty.Columns[iColumnIndex].Name.CompareTo("ResultDes") == 0)
                {
                    GVAR.g_ManageDB.InitPenaltyResultCmb(ref dgvHomePenalty, iColumnIndex);
                }
            }
        }

        private void dgvHomePenalty_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            int iRowIdx = e.RowIndex;
            int iColIdx = e.ColumnIndex;
            if (iRowIdx >= dgvHomePenalty.RowCount || iRowIdx < 0 || iColIdx < 0)
                return;

            m_CurAction.AcitonID = GVAR.Str2Int(dgvHomePenalty.Rows[iRowIdx].Cells["F_ActionID"].Value.ToString());
            if (dgvHomePenalty.Columns[iColIdx].Name.CompareTo("ResultDes") == 0)
            {
                 DataGridViewCell CurCell = dgvHomePenalty.Rows[iRowIdx].Cells[iColIdx];
                 if (CurCell != null)
                 {
                     int iResultID = 0;
                     if (CurCell is DGVCustomComboBoxCell)
                     {
                         DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                         iResultID = GVAR.Str2Int(CurCell1.Tag);
                     }
                     else
                     {
                         return;
                     }

                     if (m_CurAction.AcitonID < 0)
                     {
                         AddPenaltyAction(ref dgvHomePenalty, 1, iRowIdx, iColIdx, iResultID);
                     }
                     else
                     {
                         GVAR.g_ManageDB.GetMatchAction(m_MatchID, m_CurAction.AcitonID, ref m_CurAction);
                         EditPenaltyAction(ref dgvHomePenalty, 1, iRowIdx, iColIdx, iResultID);
                     }
                     ResetHomePenaltyDataGridView();

                 }
                
            }
        }

        private void dgvVisitPenalty_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            int iRowIdx = e.RowIndex;
            int iColIdx = e.ColumnIndex;
            if (iRowIdx >= dgvVisitPenalty.RowCount || iRowIdx < 0 || iColIdx < 0)
                return;

            m_CurAction.Init();
            m_CurAction.AcitonID = GVAR.Str2Int(dgvVisitPenalty.Rows[iRowIdx].Cells["F_ActionID"].Value.ToString());
            if (dgvVisitPenalty.Columns[iColIdx].Name.CompareTo("ResultDes") == 0)
            {
                DataGridViewCell CurCell = dgvVisitPenalty.Rows[iRowIdx].Cells[iColIdx];
                if (CurCell != null)
                {
                    int iResultID = 0;
                    if (CurCell is DGVCustomComboBoxCell)
                    {
                        DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                        iResultID = GVAR.Str2Int(CurCell1.Tag);
                    }
                    else
                    {
                        return;
                    }

                    if (m_CurAction.AcitonID < 0)
                    {
                        AddPenaltyAction(ref dgvVisitPenalty, 2, iRowIdx, iColIdx, iResultID);
                    }
                    else
                    {
                        GVAR.g_ManageDB.GetMatchAction(m_MatchID, m_CurAction.AcitonID, ref m_CurAction);
                        EditPenaltyAction(ref dgvVisitPenalty, 2, iRowIdx, iColIdx, iResultID);
                    }
                    ResetVisitPenaltyDataGridView();
                }

            }
        }

        private void dgvVisitPenalty_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvVisitPenalty.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex >= 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                if (dgvVisitPenalty.Columns[iColumnIndex].Name.CompareTo("ResultDes") == 0)
                {
                    GVAR.g_ManageDB.InitPenaltyResultCmb(ref dgvVisitPenalty, iColumnIndex);
                }
            }
        }

        private void AddPenaltyAction(ref DataGridView dgv, int iTeamPos, int iRwoIdx, int iColIndex, int iResultID)
        {
            int iRegisterID = GVAR.Str2Int(dgv.Rows[iRwoIdx].Cells["F_RegisterID"].Value.ToString());
            string strRegName = dgv.Rows[iRwoIdx].Cells["Name"].Value.ToString();
            int iShirtNumber = GVAR.Str2Int(dgv.Rows[iRwoIdx].Cells["CapNo"].Value.ToString());
            int iShotResult = iResultID;

            m_CurAction.InitAction(m_CCurMatch, m_iMatchPenaltySplitID);

            m_CurAction.TeamPos = iTeamPos;
            m_CurAction.RegisterID = iRegisterID;
            m_CurAction.RegName = strRegName;
            m_CurAction.ActionTime = "";

            m_CurAction.ActionDes = iShirtNumber.ToString();
            m_CurAction.ActionType = EActionType.emShot;
            m_CurAction.ActionDetail1 = "5";
            m_CurAction.ActionDetail2 = iShotResult.ToString();

            m_CurAction.GetActionCode();
            if (m_CurAction.IsActionComplete())
            {
                int iOPGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, (2 - m_CurAction.TeamPos + 1));
                m_CurAction.CreateActionXml(m_CCurMatch, iOPGKID);
                AddAction();
                m_CurAction.Init();
            }
           
        }

        private bool AddAction()
        {
            int iResult = GVAR.g_ManageDB.AddMatchAction(m_CurAction);
            if (iResult <= 0)
            {
                return false;
            }
            else
            {
                m_CurAction.AcitonID = iResult;
            }

            iResult = GVAR.g_ManageDB.UpdatePlayerStat(m_CurAction);
            if (iResult <= 0)
                return false;

            if ( m_CurAction.ActionDetail2 == "1")
            {
                if (m_CurAction.TeamPos == 1)
                {
                    m_CCurMatch.m_CHomeTeam.TeamPoint += 1;
                    m_iHomePScore += 1;
                }
                else if (m_CurAction.TeamPos == 2)
                {
                    m_CCurMatch.m_CVisitTeam.TeamPoint += 1;
                    m_iVisitPScore += 1;
                }

                GVAR.g_ManageDB.UpdateSplitPoint(m_MatchID, m_iMatchPenaltySplitID, 1, m_iHomePScore);
                GVAR.g_ManageDB.UpdateSplitPoint(m_MatchID, m_iMatchPenaltySplitID, 2, m_iVisitPScore);
                GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);
            }
            UpdateScoreUI();
            return true;
        }

        private void EditPenaltyAction(ref DataGridView dgv, int iTeamPos, int iRwoIdx, int iColIndex, int iResultID)
        {
            //////////////////////////////////////
            //先删除，后增加
            OVRWPActionInfo tmpAction = new OVRWPActionInfo();
            tmpAction = m_CurAction;
            DeleteAction(m_CurAction);


            int iRegisterID = GVAR.Str2Int(dgv.Rows[iRwoIdx].Cells["F_RegisterID"].Value.ToString());
            string strRegName = dgv.Rows[iRwoIdx].Cells["Name"].Value.ToString();
            int iShirtNumber = GVAR.Str2Int(dgv.Rows[iRwoIdx].Cells["CapNo"].Value.ToString());
            int iShotResult = iResultID;

           // m_CurAction.InitAction(m_CCurMatch, m_iMatchPenaltySplitID);

            m_CurAction.TeamPos = iTeamPos;
            m_CurAction.RegisterID = iRegisterID;
            m_CurAction.RegName = strRegName;
            m_CurAction.ActionTime = "";

            m_CurAction.ActionDes = iShirtNumber.ToString();
            m_CurAction.ActionType = EActionType.emShot;
            m_CurAction.ActionDetail1 = "5";
            m_CurAction.ActionDetail2 = iShotResult.ToString();

            m_CurAction.GetActionCode();

            if (m_CurAction.IsActionComplete())
            {
                int iOPGKID = GVAR.g_ManageDB.GetCurActiveGKID(m_CCurMatch, (2 - m_CurAction.TeamPos + 1));
                m_CurAction.CreateActionXml(m_CCurMatch, iOPGKID);
                AddAction();
                m_CurAction.Init();
            }

        }

        private bool DeleteAction(OVRWPActionInfo tmpAction)
        {
            int iResult = GVAR.g_ManageDB.DeleteMatchAction(tmpAction);
            if (iResult <= 0)
            {
                return false;
            }

            iResult = GVAR.g_ManageDB.RemovePlayerStat(tmpAction);
            if (iResult <= 0)
                return false;

            if (tmpAction.ActionDetail2 == "1")
            {
                if (tmpAction.TeamPos == 1)
                {
                    if (m_iHomePScore != 0)
                    {
                        m_CCurMatch.m_CHomeTeam.TeamPoint = Math.Max(m_CCurMatch.m_CHomeTeam.TeamPoint -1, 0);
                        m_iHomePScore = Math.Max(m_iHomePScore -1, 0);
                    }
                  
                }
                else if (tmpAction.TeamPos == 2)
                {
                    if (m_iVisitPScore != 0)
                    {
                        m_CCurMatch.m_CVisitTeam.TeamPoint = Math.Max(m_CCurMatch.m_CVisitTeam.TeamPoint - 1, 0);
                        m_iVisitPScore = Math.Max(m_iVisitPScore - 1, 0);
                    }
                }

                if (iResult == 1)
                {
                    GVAR.g_ManageDB.UpdateSplitPoint(m_MatchID, m_iMatchPenaltySplitID, 1, m_iHomePScore);
                    GVAR.g_ManageDB.UpdateSplitPoint(m_MatchID, m_iMatchPenaltySplitID, 2, m_iVisitPScore);
                    GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);
                }

                UpdateScoreUI();
            }

            return true;

        }
        private void FillPlayerUI()
        {
            UpdateScoreUI();

            string strHGKName = "";
            string strVGKName = "";
            GVAR.g_ManageDB.GetPenaltyGKInfo(GVAR.Str2Int(m_CCurMatch.MatchID), 1, m_iMatchPenaltySplitID, ref strHGKName, ref m_iHomeGKID);
            GVAR.g_ManageDB.GetPenaltyGKInfo(GVAR.Str2Int(m_CCurMatch.MatchID), 2, m_iMatchPenaltySplitID, ref strVGKName, ref m_iVisitGKID);

            lbHGKName.Text = strHGKName;
            lbVGKName.Text = strVGKName;

            ResetHomePenaltyDataGridView();
            ResetVisitPenaltyDataGridView();
        }

        private void UpdateScoreUI()
        {
            lbScore.Text = m_iHomePScore.ToString() + " - " + m_iVisitPScore.ToString();
        }

        private void ResetHomePenaltyDataGridView()
        {
            GVAR.g_ManageDB.FillPenaltyDataGridView(ref dgvHomePenalty, GVAR.Str2Int(m_CCurMatch.MatchID), m_iMatchPenaltySplitID, 1);
        }
        private void ResetVisitPenaltyDataGridView()
        {
            GVAR.g_ManageDB.FillPenaltyDataGridView(ref dgvVisitPenalty, GVAR.Str2Int(m_CCurMatch.MatchID), m_iMatchPenaltySplitID, 2);
        }
    }
}
