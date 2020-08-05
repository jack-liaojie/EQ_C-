using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using DevComponents.DotNetBar.Controls;
using System.Xml;
using System.Collections;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using System.Text.RegularExpressions;
namespace AutoSports.OVRARPlugin
{
    public partial class UCElimination : UserControl
    {
        public int m_nCurMatchID = -1;
        public AR_MatchInfo CurMatchInfo = new AR_MatchInfo();
        private List<AR_Archer> Players = null;
        private bool IsAutoUpTotal = true;
        private bool IsAutoUpPoint = true;
        private bool IsAutoUpWinner = false;
        public ARDataEntryUpdatedMatchInfo UpdatedUserControlsHandler;
        public ARDataEntryUpdatedMatchInfo UpdatedMainFormMatchInfo;

        private DataTable dt_Records = null;

        public UCElimination(int nMatchID)
        {
            InitializeComponent();

            m_nCurMatchID = nMatchID;
            this.UpdatedUserControlsHandler = new ARDataEntryUpdatedMatchInfo(SettingControlsStatus);
            try
            {
                ARUdpService.ReceivedData = new ReceiveDataEventHandler(UpdateRecData);
            }
            catch { }
        }

        private void UCElimination_Load(object sender, EventArgs e)
        {
            #region Schedule状态根据比赛规则生成Match表
            if ((CurMatchInfo.CurMatchRuleID > 0) && (CurMatchInfo.MatchStatusID > 0 && CurMatchInfo.MatchStatusID <= 40))
            {
                if (GVAR.g_ManageDB.HasMatchSplits(m_nCurMatchID, CurMatchInfo.EndCount, CurMatchInfo.ArrowCount, CurMatchInfo.Distince) != 0)
                {
                    int nReturn = GVAR.g_ManageDB.ApplySelRule(m_nCurMatchID, CurMatchInfo.CurMatchRuleID, 1);
                    if (nReturn == 1)
                    {
                        this.CurMatchInfo = AREntityOperation.GetCurMatchInfo(m_nCurMatchID);
                        UpdatedMainFormMatchInfo.Invoke(this.CurMatchInfo);
                    }
                }

            }
            if ((CurMatchInfo.CurMatchRuleID <= 0) && (CurMatchInfo.MatchStatusID > 0 && CurMatchInfo.MatchStatusID <= 40))
            {
                if (GVAR.g_ManageDB.HasMatchSplits(m_nCurMatchID, CurMatchInfo.EndCount, CurMatchInfo.ArrowCount, CurMatchInfo.Distince) != 0)
                {
                    int nRetrun = GVAR.g_ManageDB.CreateMatchSplits(m_nCurMatchID, CurMatchInfo.EndCount, CurMatchInfo.ArrowCount, CurMatchInfo.Distince, 1);
                    //if(nRetrun ==1)
                }
            }
            #endregion

            dt_Records = GVAR.g_ManageDB.GetRecordList(m_nCurMatchID);

            this.InitDataGridView(dgv_PlayerA);
            this.InitDataGridView(dgv_PlayerB);

            Players = AREntityOperation.GetCompetitionPlayersInfo(m_nCurMatchID);

            if (Players.Count > 1)
            {
                if (Players[0].ShootEnds.Count > 0)
                {
                    this.dgv_ShootA.Visible = true;
                    this.InitShootDataGridView(dgv_ShootA, Players[0].ShootEnds[0].Arrows.Count);
                }
                if (Players[1].ShootEnds.Count > 0)
                {
                    this.dgv_ShootB.Visible = true;
                    this.InitShootDataGridView(dgv_ShootB, Players[1].ShootEnds[0].Arrows.Count);
                }
                InitPlayerInfo();
            }
            this.InitComboBox(this.cb_Winner);

            if (CurMatchInfo.IsSetPoints == 0)
            {
                dgv_PlayerA.Columns["SetPoints"].Visible = false;
                dgv_PlayerB.Columns["SetPoints"].Visible = false;
            }
            SettingControlsStatus(CurMatchInfo);
            ARUdpService.CurMatchInfo = CurMatchInfo;
            Localization();
        }

        #region A编辑
        private void dgv_PlayerA_CellMouseDown(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.ColumnIndex > 0 && e.RowIndex >= 0)
            {
                if (dgv_PlayerA.Columns[e.ColumnIndex].Name.Contains("Arrow") &&
                    (CurMatchInfo.MatchStatusID > 40 && CurMatchInfo.MatchStatusID < 100))
                {
                    this.Menu_X.Tag = dgv_PlayerA[e.ColumnIndex, e.RowIndex];
                    this.dgv_PlayerA.ContextMenuStrip = this.Menu_X;
                }
                else
                    this.dgv_PlayerA.ContextMenuStrip = null;
            }
        }
        private void dgv_PlayerA_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (!dgv_PlayerA.Columns[e.ColumnIndex].ReadOnly && e.FormattedValue != null && e.ColumnIndex > 0)
            {
                if (e.FormattedValue.ToString() == "")
                    return;
                string strInput = e.FormattedValue.ToString();
                if (dgv_PlayerA.Columns[e.ColumnIndex].Name.Contains("Arrow") && strInput.ToLower() == "m")
                    strInput = "0";
                else if (dgv_PlayerA.Columns[e.ColumnIndex].Name.Contains("Arrow") && strInput.ToLower() == "x")
                    strInput = "10";
                int attOut = 0;
                if (!int.TryParse(strInput, out attOut))
                {
                    e.Cancel = true;
                }
            }

        }
        private void dgv_PlayerA_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex > 0)
            {
                AR_End rowEnd = new AR_End();
                bool bReturn = false;
                if (dgv_PlayerA.Rows[e.RowIndex].Cells[e.ColumnIndex].OwningColumn.Name.Contains("Arrow"))
                {
                    EditArrowsInfo(dgv_PlayerA[e.ColumnIndex, e.RowIndex]);
                }

                rowEnd = (AR_End)dgv_PlayerA.Rows[e.RowIndex].Tag;
                rowEnd.R10Num = ARFunctions.ConvertToStringFromObject(dgv_PlayerA.Rows[e.RowIndex].Cells["10s"].Value);
                rowEnd.Xnum = ARFunctions.ConvertToStringFromObject(dgv_PlayerA.Rows[e.RowIndex].Cells["Xs"].Value);
                rowEnd.Total = ARFunctions.ConvertToStringFromObject(dgv_PlayerA.Rows[e.RowIndex].Cells["Total"].Value);
                if (CurMatchInfo.IsSetPoints == 1 && dgv_PlayerA.Rows[e.RowIndex].Cells[e.ColumnIndex].OwningColumn.Name != "SetPoints")
                {
                    this.SetEndPoints(e.RowIndex);
                }
                else if (dgv_PlayerA.Rows[e.RowIndex].Cells[e.ColumnIndex].OwningColumn.Name == "SetPoints")
                {
                    if (ARFunctions.ConvertToStringFromObject(dgv_PlayerA.Rows[e.RowIndex].Cells["SetPoints"].Value) == "2")
                        dgv_PlayerB.Rows[e.RowIndex].Cells["SetPoints"].Value = "0";
                    else if (ARFunctions.ConvertToStringFromObject(dgv_PlayerA.Rows[e.RowIndex].Cells["SetPoints"].Value) == "1")
                        dgv_PlayerB.Rows[e.RowIndex].Cells["SetPoints"].Value = "1";
                    else if (ARFunctions.ConvertToStringFromObject(dgv_PlayerA.Rows[e.RowIndex].Cells["SetPoints"].Value) == "0")
                        dgv_PlayerB.Rows[e.RowIndex].Cells["SetPoints"].Value = "2";
                }
                else { labX_TotalA.Text = this.GetPlayerTotalScore(dgv_PlayerA); }
                rowEnd.Point = ARFunctions.ConvertToStringFromObject(dgv_PlayerA.Rows[e.RowIndex].Cells["SetPoints"].Value);
                bReturn = GVAR.g_ManageDB.UpdatePlayerEnd(m_nCurMatchID, rowEnd.CompetitionPosition, rowEnd.SplitID, rowEnd.EndIndex, rowEnd.Total,
                                rowEnd.Point, rowEnd.R10Num, rowEnd.Xnum, 1);
                if (bReturn)
                {
                    dgv_PlayerA.Rows[e.RowIndex].Tag = rowEnd;
                    GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                }
                if (GetIsFinishedMatch(dgv_PlayerA) && GetIsFinishedMatch(dgv_PlayerB))
                {
                    if (ARFunctions.CompareTotalString(labX_TotalA.Text, labX_TotalB.Text) == 1)
                    {
                        cb_Winner.SelectedIndex = 1;
                    }
                    if (ARFunctions.CompareTotalString(labX_TotalA.Text, labX_TotalB.Text) == -1)
                    {
                        cb_Winner.SelectedIndex = 2;
                    }
                }
                DataExchangeRecord(dgv_PlayerA, labX_RecordA);
            }
        }
        private void dgv_PlayerA_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            SetDataGirdViewCellValueChanged(dgv_PlayerA[e.ColumnIndex, e.RowIndex]);
        }
        private void labX_A_TextChanged(object sender, EventArgs e)
        {
            LabelX labA = (LabelX)sender;
            AR_Archer player = (AR_Archer)dgv_PlayerA.Tag;
            if (labA == labX_A10s)
            {
                string Num10A = labX_A10s.Text;
                player.Num10S = Num10A;
            }
            if (labA == labX_AXs)
            {
                string NumXA = labX_AXs.Text;
                player.NumXS = NumXA;
            }
            if (labA == labX_TotalA)
            {
                string Total = labX_TotalA.Text;
                if (CurMatchInfo.IsSetPoints == 1)
                    player.Result = Total;
                else
                    player.Total = Total;
            }

            dgv_PlayerA.Tag = player;
            UpdateRank();
        }

        #endregion

        #region B编辑
        private void dgv_PlayerB_CellMouseDown(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.ColumnIndex > 0 && e.RowIndex >= 0)
            {
                if (dgv_PlayerB.Columns[e.ColumnIndex].Name.Contains("Arrow") &&
                    (CurMatchInfo.MatchStatusID > 40 && CurMatchInfo.MatchStatusID < 100))
                {
                    this.Menu_X.Tag = dgv_PlayerB[e.ColumnIndex, e.RowIndex];
                    this.dgv_PlayerB.ContextMenuStrip = this.Menu_X;
                }
                else
                    this.dgv_PlayerB.ContextMenuStrip = null;
            }
        }
        private void dgv_PlayerB_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (!dgv_PlayerB.Columns[e.ColumnIndex].ReadOnly && e.FormattedValue != null)
            {
                if (e.FormattedValue.ToString() == "")
                    return;
                string strInput = e.FormattedValue.ToString();
                if (dgv_PlayerB.Columns[e.ColumnIndex].Name.Contains("Arrow") && strInput.ToLower() == "m")
                    strInput = "0";
                else if (dgv_PlayerB.Columns[e.ColumnIndex].Name.Contains("Arrow") && strInput.ToLower() == "x")
                    strInput = "10";
                int attOut = 0;
                if (!int.TryParse(strInput, out attOut))
                {
                    e.Cancel = true;
                }
            }
        }
        private void dgv_PlayerB_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex > 0)
            {
                AR_End rowEnd = new AR_End();
                bool bReturn = false;
                if (dgv_PlayerB.Rows[e.RowIndex].Cells[e.ColumnIndex].OwningColumn.Name.Contains("Arrow"))
                {
                    EditArrowsInfo(dgv_PlayerB[e.ColumnIndex, e.RowIndex]);
                }

                rowEnd = (AR_End)dgv_PlayerB.Rows[e.RowIndex].Tag;
                rowEnd.R10Num = ARFunctions.ConvertToStringFromObject(dgv_PlayerB.Rows[e.RowIndex].Cells["10s"].Value);
                rowEnd.Xnum = ARFunctions.ConvertToStringFromObject(dgv_PlayerB.Rows[e.RowIndex].Cells["Xs"].Value);
                rowEnd.Total = ARFunctions.ConvertToStringFromObject(dgv_PlayerB.Rows[e.RowIndex].Cells["Total"].Value);
                if (CurMatchInfo.IsSetPoints == 1 && dgv_PlayerB.Rows[e.RowIndex].Cells[e.ColumnIndex].OwningColumn.Name != "SetPoints")
                {
                    this.SetEndPoints(e.RowIndex);
                }
                else if (dgv_PlayerB.Rows[e.RowIndex].Cells[e.ColumnIndex].OwningColumn.Name == "SetPoints")
                {
                    if (ARFunctions.ConvertToStringFromObject(dgv_PlayerB.Rows[e.RowIndex].Cells["SetPoints"].Value) == "2")
                        dgv_PlayerA.Rows[e.RowIndex].Cells["SetPoints"].Value = "0";
                    else if (ARFunctions.ConvertToStringFromObject(dgv_PlayerB.Rows[e.RowIndex].Cells["SetPoints"].Value) == "1")
                        dgv_PlayerA.Rows[e.RowIndex].Cells["SetPoints"].Value = "1";
                    else if (ARFunctions.ConvertToStringFromObject(dgv_PlayerB.Rows[e.RowIndex].Cells["SetPoints"].Value) == "0")
                        dgv_PlayerA.Rows[e.RowIndex].Cells["SetPoints"].Value = "2";
                }
                else { labX_TotalB.Text = this.GetPlayerTotalScore(dgv_PlayerB); }
                rowEnd.Point = ARFunctions.ConvertToStringFromObject(dgv_PlayerB.Rows[e.RowIndex].Cells["SetPoints"].Value);
                bReturn = GVAR.g_ManageDB.UpdatePlayerEnd(m_nCurMatchID, rowEnd.CompetitionPosition, rowEnd.SplitID, rowEnd.EndIndex, rowEnd.Total,
                                rowEnd.Point, rowEnd.R10Num, rowEnd.Xnum, 1);
                if (bReturn)
                {
                    dgv_PlayerB.Rows[e.RowIndex].Tag = rowEnd;
                    GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                }
                if (GetIsFinishedMatch(dgv_PlayerA) && GetIsFinishedMatch(dgv_PlayerB))
                {
                    if (ARFunctions.CompareTotalString(labX_TotalA.Text, labX_TotalB.Text) == 1)
                    {
                        cb_Winner.SelectedIndex = 1;
                    }
                    if (ARFunctions.CompareTotalString(labX_TotalA.Text, labX_TotalB.Text) == -1)
                    {
                        cb_Winner.SelectedIndex = 2;
                    }
                }
                DataExchangeRecord(dgv_PlayerB, labX_RecordB);
            }
        }
        private void dgv_PlayerB_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            SetDataGirdViewCellValueChanged(dgv_PlayerB[e.ColumnIndex, e.RowIndex]);
        }
        private void labX_B_TextChanged(object sender, EventArgs e)
        {
            LabelX labB = (LabelX)sender;
            AR_Archer player = (AR_Archer)dgv_PlayerB.Tag;
            if (labB == labX_B10s)
            {
                string Num10B = labX_B10s.Text;
                player.Num10S = Num10B;
            }
            if (labB == labX_BXs)
            {
                string NumXB = labX_BXs.Text;
                player.NumXS = NumXB;
            }
            if (labB == labX_TotalB)
            {
                string Total = labX_TotalB.Text;
                if (CurMatchInfo.IsSetPoints == 1)
                    player.Result = Total;
                else
                    player.Total = Total;
            }

            dgv_PlayerB.Tag = player;
            UpdateRank();
        }
        #endregion

        #region 运动员异常状态设置
        private void labX_WinA_MouseDown(object sender, MouseEventArgs e)
        {
            MenuStrip_IRM.Visible = true;
            MenuStrip_IRM.Tag = dgv_PlayerA;
            this.labX_IRMA.ContextMenuStrip = MenuStrip_IRM;
            MenuStrip_IRM.Show((Control)labX_TotalA, new Point());

        }
        private void labX_WinB_MouseDown(object sender, MouseEventArgs e)
        {
            MenuStrip_IRM.Visible = true;
            MenuStrip_IRM.Tag = dgv_PlayerB;
            this.labX_IRMB.ContextMenuStrip = MenuStrip_IRM;
            MenuStrip_IRM.Show((Control)labX_TotalB, new Point());
        }
        private void toolStripMenuItem_DNS_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Common("DNS");
        }
        private void toolStripMenuItem_DSQ_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Common("DSQ");
        }
        private void toolStripMenuItem_DNF_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Common("DNF");
        }
        private void toolStripMenuItem_OK_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Common("");
        }
        private void toolStripMenuItem_Common(string IRM)
        {

            DataGridView dgv = (DataGridView)MenuStrip_IRM.Tag;
            AR_Archer player = (AR_Archer)dgv.Tag;
            player.IRM = IRM;
            player.Total = IRM.Length != 0 ? "" : this.GetPlayerTotalScore(dgv);
            player.Result = IRM.Length != 0 ? "" : this.GetPlayerTotalPoint(dgv);
            player.QRank = IRM.Length != 0 ? "" : player.QRank;

            bool bReturn = GVAR.g_ManageDB.UpdateMatchResult(m_nCurMatchID, player.CompetitionPosition,
                            player.Num10S, player.NumXS, player.Total, player.Result, player.QRank, player.DisplayPosition.ToString(), player.IRM, player.Target);
            if (bReturn)
            {
                dgv.Tag = player;
                if (dgv.Name == "dgv_PlayerA")
                    labX_IRMA.Text = IRM;
                else
                    labX_IRMB.Text = IRM;
                GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }

        }
        #endregion

        #region 设置比赛胜者
        private void cb_Winner_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cb_Winner.SelectedIndex != -1)
            {
                AR_Archer winner = null;
                if (cb_Winner.SelectedIndex > 0)
                    winner = (AR_Archer)((ComboBoxItem)cb_Winner.Items[cb_Winner.SelectedIndex]).Tag;
                SetMatchResult(winner);
            }
        }

        public void SetMatchResult(AR_Archer Winner)
        {
            AR_Archer playerA = (AR_Archer)dgv_PlayerA.Tag;
            AR_Archer playerB = (AR_Archer)dgv_PlayerB.Tag;
            if (Winner != null)
            {
                if (playerA.CompetitionPosition == Winner.CompetitionPosition)
                {
                    playerA.QRank = "1";
                    playerB.QRank = "2";
                }
                else if (playerB.CompetitionPosition == Winner.CompetitionPosition)
                {
                    playerA.QRank = "2";
                    playerB.QRank = "1";
                }
            }
            else
            {
                playerA.QRank = "";
                playerB.QRank = "";
            }
            playerA.Total = GetPlayerTotalScore(dgv_PlayerA);
            playerA.Result = GetPlayerTotalPoint(dgv_PlayerA);
            playerB.Total = GetPlayerTotalScore(dgv_PlayerB);
            playerB.Result = GetPlayerTotalPoint(dgv_PlayerB);
            this.Players.Clear();
            this.Players.Add(playerA);
            this.Players.Add(playerB);
            foreach (AR_Archer player in this.Players)
            {
                bool bReturn = GVAR.g_ManageDB.UpdateMatchResult(m_nCurMatchID, player.CompetitionPosition,
                    player.Num10S, player.NumXS, player.Total, player.Result, player.QRank, player.DisplayPosition.ToString(), player.IRM, player.Target);
                if (bReturn)
                    GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }

            dgv_PlayerA.Tag = playerA;
            dgv_PlayerB.Tag = playerB;
            labX_TotalA.Text = CurMatchInfo.IsSetPoints == 1 ? playerA.Result : playerA.Total;
            labX_TotalB.Text = CurMatchInfo.IsSetPoints == 1 ? playerB.Result : playerB.Total;
            SetWinnerTextInfo(Winner);
        }

        private void SetWinnerTextInfo(AR_Archer Winner)
        {
            if (Winner != null)
            {
                if (Winner.CompetitionPosition == 1)
                {
                    labX_WinA.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCElimination_labX_Winner");
                    labX_WinB.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCElimination_labX_Loser");
                    labX_WinA.ForeColor = System.Drawing.Color.Red;
                    labX_WinB.ForeColor = System.Drawing.Color.Blue;
                }
                else
                {
                    labX_WinB.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCElimination_labX_Winner");
                    labX_WinA.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCElimination_labX_Loser");
                    labX_WinB.ForeColor = System.Drawing.Color.Red;
                    labX_WinA.ForeColor = System.Drawing.Color.Blue;
                }
            }
            else
            {
                labX_WinB.Text = "";
                labX_WinA.Text = "";
                labX_WinA.ForeColor = System.Drawing.Color.Blue;
                labX_WinB.ForeColor = System.Drawing.Color.Blue;
            }
        }

        private AR_Archer GetWinner()
        {
            AR_Archer winner = new AR_Archer();
            AR_Archer pA = (AR_Archer)dgv_PlayerA.Tag;
            AR_Archer pB = (AR_Archer)dgv_PlayerB.Tag;


            return winner;
        }
        #endregion

        #region 设置局点、红心
        private void SetEndPoints(int rowIndex)
        {
            DataGridViewRow rowA = dgv_PlayerA.Rows[rowIndex];
            DataGridViewRow rowB = dgv_PlayerB.Rows[rowIndex];

            if ((GetIsFinishedEnd(rowA) && GetIsFinishedEnd(rowB)) || IsAutoUpPoint)
            {
                if (ARFunctions.ConvertToStringFromObject(rowA.Cells["Total"].Value) != ""
                    && ARFunctions.ConvertToStringFromObject(rowB.Cells["Total"].Value) != "")
                {
                    if (GetPlayerEndScore(rowA) > GetPlayerEndScore(rowB))
                    {
                        rowA.Cells["SetPoints"].Value = 2;
                        rowB.Cells["SetPoints"].Value = 0;
                    }
                    else if (GetPlayerEndScore(rowA) == GetPlayerEndScore(rowB)
                        && (GetPlayerEndScore(rowA) != 0 && GetPlayerEndScore(rowB) != 0))
                    {
                        rowA.Cells["SetPoints"].Value = 1;
                        rowB.Cells["SetPoints"].Value = 1;
                    }
                    else if (GetPlayerEndScore(rowA) < GetPlayerEndScore(rowB))
                    {
                        rowA.Cells["SetPoints"].Value = 0;
                        rowB.Cells["SetPoints"].Value = 2;
                    }
                }
                else
                {
                    rowA.Cells["SetPoints"].Value = "";
                    rowB.Cells["SetPoints"].Value = "";
                }
            }
            else
            {
                rowA.Cells["SetPoints"].Value = "";
                rowB.Cells["SetPoints"].Value = "";
            }
        }
        private void SetEnd10AndXNumbers(DataGridViewRow row)
        {
            int Num10 = 0;
            int NumX = 0;

            foreach (DataGridViewCell cell in row.Cells)
            {
                if (cell.OwningColumn.Name.Contains("Arrow") && cell.Value != null)
                {
                    if (cell.Value.ToString().ToUpper() == "X" || cell.Value.ToString() == "10")
                    {
                        Num10++;
                        if (cell.Value.ToString().ToUpper() == "X")
                            NumX++;
                    }
                }
            }
            row.Cells["10s"].Value = Num10 == 0 ? "" : Num10.ToString();
            row.Cells["Xs"].Value = NumX == 0 ? "" : NumX.ToString();
        }
        private void toolStripMenuItem_M_Click(object sender, EventArgs e)
        {
            DataGridViewCell cell = (DataGridViewCell)((ContextMenuStrip)((ToolStripMenuItem)sender).Owner).Tag;
            cell.Value = "M";
            EditArrowsInfo(cell);
            AutoUpdateEndResult(cell);
        }
        private void toolStripMenuItem_X_Click(object sender, EventArgs e)
        {
            DataGridViewCell cell = (DataGridViewCell)((ContextMenuStrip)((ToolStripMenuItem)sender).Owner).Tag;
            cell.Value = "X";
            EditArrowsInfo(cell);
            AutoUpdateEndResult(cell);
        }
        private void nullToolStripMenuItem_Click(object sender, EventArgs e)
        {
            DataGridViewCell cell = (DataGridViewCell)((ContextMenuStrip)((ToolStripMenuItem)sender).Owner).Tag;
            cell.Value = "";
            EditArrowsInfo(cell);
            if (IsAutoUpTotal) //自动更新每局总环数开关
                SetPlayerEndTotal(cell.OwningRow);
            AutoUpdateEndResult(cell);
        }

        private void AutoUpdateEndResult(DataGridViewCell cell)
        {
            AR_End rowEnd = (AR_End)cell.OwningRow.Tag;
            bool bReturn = false;

            if (!cell.OwningRow.DataGridView.Name.ToLower().Contains("shoot"))
            {
                if (CurMatchInfo.IsSetPoints == 1 && cell.OwningColumn.Name != "SetPoints")
                {
                    this.SetEndPoints(cell.RowIndex);
                }
                else { labX_TotalA.Text = this.GetPlayerTotalScore(cell.OwningRow.DataGridView); }
                rowEnd.R10Num = ARFunctions.ConvertToStringFromObject(cell.OwningRow.Cells["10s"].Value);
                rowEnd.Xnum = ARFunctions.ConvertToStringFromObject(cell.OwningRow.Cells["Xs"].Value);
                rowEnd.Point = ARFunctions.ConvertToStringFromObject(cell.OwningRow.Cells["SetPoints"].Value);
                rowEnd.Total = ARFunctions.ConvertToStringFromObject(cell.OwningRow.Cells["Total"].Value);
                bReturn = GVAR.g_ManageDB.UpdatePlayerEnd(m_nCurMatchID, rowEnd.CompetitionPosition, rowEnd.SplitID, rowEnd.EndIndex, rowEnd.Total,
                                rowEnd.Point, rowEnd.R10Num, rowEnd.Xnum, 1);
            }
            else
            {
                rowEnd.Total = ARFunctions.ConvertToStringFromObject(cell.OwningRow.Cells["Total"].Value);
                rowEnd.EndComment = ARFunctions.ConvertToStringFromObject(cell.OwningRow.Cells["Closest"].Value);
                bReturn = GVAR.g_ManageDB.UpdatePlayerShootEnd(m_nCurMatchID, rowEnd.CompetitionPosition, rowEnd.SplitID, rowEnd.EndIndex, rowEnd.Total,
                                rowEnd.Point, rowEnd.R10Num, rowEnd.Xnum,rowEnd.EndComment, 1);
                if (bReturn)
                { 
                    AR_End rEndA = (AR_End)dgv_ShootA.Rows[cell.RowIndex].Tag;
                    AR_End rEndB = (AR_End)dgv_ShootB.Rows[cell.RowIndex].Tag;
                    if (rEndA.Total != "" && rEndB.Total != "")
                    {
                        if (ARFunctions.ConvertToIntFromString(rEndA.Total) > ARFunctions.ConvertToIntFromString(rEndB.Total))
                            cb_Winner.SelectedIndex = 1;
                        else if (ARFunctions.ConvertToIntFromString(rEndA.Total) < ARFunctions.ConvertToIntFromString(rEndB.Total))
                            cb_Winner.SelectedIndex = 2;
                        else cb_Winner.SelectedIndex = 0;
                    }
                }
            }
            if (bReturn)
            {
                cell.OwningRow.Tag = rowEnd;
                GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }
            if (GetIsFinishedMatch(dgv_PlayerA) && GetIsFinishedMatch(dgv_PlayerB))
            {
                if (ARFunctions.CompareTotalString(labX_TotalA.Text, labX_TotalB.Text) == 1)
                {
                    cb_Winner.SelectedIndex = 1;
                }
                if (ARFunctions.CompareTotalString(labX_TotalA.Text, labX_TotalB.Text) == -1)
                {
                    cb_Winner.SelectedIndex = 2;
                }
            }
            DataExchangeRecord(dgv_PlayerA, labX_RecordA);
        }
        #endregion

        #region 获得各种分数
        private int GetPlayerEndScore(DataGridViewRow row)
        {

            int rowTotal = 0;
            rowTotal = ARFunctions.ConvertToIntFromObject(row.Cells["Total"].Value);
            return rowTotal;
        }
        private string GetPlayerTotalScore(DataGridView dgv)
        {
            string PlayerPoint = string.Empty;
            if (dgv.Rows.Count > 0)
            {
                int total = 0;
                foreach (DataGridViewRow row in dgv.Rows)
                {
                    int rowTotal = ARFunctions.ConvertToIntFromObject(row.Cells["Total"].Value);

                    total += rowTotal;
                }
                PlayerPoint = total.ToString(); //== 0 ? "" : total.ToString();
            }
            return PlayerPoint;
        }
        private string GetPlayerTotalPoint(DataGridView dgv)
        {
            string PlayerPoint = string.Empty;
            if (dgv.Rows.Count > 0)
            {
                int point = 0;
                foreach (DataGridViewRow row in dgv.Rows)
                {
                    int rowPoint = ARFunctions.ConvertToIntFromObject(row.Cells["SetPoints"].Value);

                    point += rowPoint;
                }
                if (dgv_ShootA.Rows.Count > 0 && dgv_ShootB.Rows.Count > 0)
                {
                    if (ARFunctions.ConvertToIntFromObject(dgv_ShootA.Rows[0].Cells["Total"].Value) > 0
                        && ARFunctions.ConvertToIntFromObject(dgv_ShootB.Rows[0].Cells["Total"].Value) > 0)
                    {
                        int _soTotalA = Convert.ToInt32(dgv_ShootA.Rows[0].Cells["Total"].Value);
                        int _soTotalB = Convert.ToInt32(dgv_ShootB.Rows[0].Cells["Total"].Value);
                        if (_soTotalA > _soTotalB && dgv.Name == "dgv_PlayerA")
                            point += 1;
                        else if (_soTotalA < _soTotalB && dgv.Name == "dgv_PlayerB")
                            point += 1;
                        else if (_soTotalA == _soTotalB && dgv.Name == "dgv_PlayerA"
                                && ARFunctions.ConvertToStringFromObject(dgv_ShootA.Rows[0].Cells["Closest"].Value) == "*")
                            point += 1;
                        else if (_soTotalA == _soTotalB && dgv.Name == "dgv_PlayerB"
                                && ARFunctions.ConvertToStringFromObject(dgv_ShootB.Rows[0].Cells["Closest"].Value) == "*")
                            point += 1;
                    }
                }
                PlayerPoint = point.ToString(); //== 0 ? "" : point.ToString();

            }
            return PlayerPoint;
        }
        private string GetPlayerTotalByColumns(DataGridViewColumn col)
        {
            string PlayerPoint = string.Empty;
            if (col.DataGridView.Rows.Count > 0)
            {
                int total = 0;
                foreach (DataGridViewRow row in col.DataGridView.Rows)
                {
                    int rowTotal = ARFunctions.ConvertToIntFromObject(row.Cells[col.Name].Value);

                    total += rowTotal;
                }
                PlayerPoint = total.ToString(); //== 0 ? "" : total.ToString();
            }
            return PlayerPoint;
        }
        private bool GetIsFinishedEnd(DataGridViewRow row)
        {
            bool isFinished = true;
            foreach (DataGridViewCell cell in row.Cells)
            {
                if (cell.OwningColumn.Name.Contains("Arrow") && (cell.Value == null || cell.Value.Equals((object)"")))
                {
                    isFinished = false;
                }
            }
            return isFinished;
        }
        private bool GetIsFinishedMatch(DataGridView dgv)
        {
            bool isFinished = true;
            if (CurMatchInfo.IsSetPoints == 0)
            {
                foreach (DataGridViewRow row in dgv.Rows)
                {
                    if (row.Cells["Total"].Value == null || ARFunctions.ConvertToStringFromObject(row.Cells["Total"].Value) == "")
                    {
                        isFinished = false;
                    }
                }
            }
            else if (CurMatchInfo.IsSetPoints == 1)
            {
                if (ARFunctions.ConvertToIntFromString(labX_TotalA.Text) < CurMatchInfo.WinPoints && ARFunctions.ConvertToIntFromString(labX_TotalB.Text) < CurMatchInfo.WinPoints)
                    isFinished = false;
            }
            return isFinished;
        }
        #endregion

        #region Init

        private void Localization()
        {
            this.labX_MatchInfo.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_OVRARDataEntryForm_labX_MatchInfo");
            this.cb_AutoSetWinner.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCElimination_labX_AutoUpdateWinner");
            this.cbX_Auto.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCElimination_labX_AutoUpdateScore");
            this.cbX_AutoPoint.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCElimination_labX_AutoUpdatePoint");

            this.labelX2.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCElimination_labX_Totals");
            this.labelX5.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCElimination_labX_Totals");

        }
        private void InitPlayerInfo()
        {
            try
            {
                //初始化运il动员 A
                dgv_PlayerA.Tag = Players[0];
                dgv_PlayerB.Tag = Players[1];

                gp_PlayerA.Text = Players[0].Name;
                this.labX_BibA.Text = (Players[0].Bib == "" ? "" : Players[0].Bib + "/") + Players[0].Target;
                this.labX_NOCA.Text = Players[0].Noc;
                this.labX_A10s.Text = Players[0].Num10S;
                this.labX_AXs.Text = Players[0].NumXS;
                this.labX_IRMA.Text = Players[0].IRM;
                this.UpdateDataGridView(dgv_PlayerA);


                if (Players[0].Members.Count > 0)
                {
                    string members = string.Empty;
                    foreach (AR_Archer ar in Players[0].Members)
                    {
                        members += ar.Name + "  -   " + ar.Total;
                        members += "\n";
                    }
                    labX_ATeam.Text = members;
                }
                //初始化运动员 B
                gp_PlayerB.Text = Players[1].Name;
                this.labX_BibB.Text = (Players[1].Bib == "" ? "" : Players[1].Bib + "/") + Players[1].Target;
                this.labX_NOCB.Text = Players[1].Noc;
                this.labX_B10s.Text = Players[1].Num10S;
                this.labX_BXs.Text = Players[1].NumXS;
                labX_IRMB.Text = Players[1].IRM;
                this.UpdateDataGridView(dgv_PlayerB);


                if (Players[1].Members.Count > 0)
                {
                    string members = string.Empty;
                    foreach (AR_Archer ar in Players[1].Members)
                    {
                        members += ar.Name + "  -   " + ar.Total;
                        members += "\n";
                    }
                    labX_BTeam.Text = members;
                }

                if (CurMatchInfo.IsSetPoints == 1)
                {
                    this.labX_TotalA.Text = Players[0].Result;
                    this.labX_TotalB.Text = Players[1].Result;
                }
                else
                {
                    this.labX_TotalA.Text = Players[0].Total;
                    this.labX_TotalB.Text = Players[1].Total;
                }
                dgv_ShootA.Tag = Players[0];
                dgv_ShootB.Tag = Players[1];
                UpdateShootDataGridView(dgv_ShootA);
                UpdateShootDataGridView(dgv_ShootB);

            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void InitDataGridView(DataGridView dgv)
        {
            dgv.Columns.Clear();
            DataGridViewColumn col = null;

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Ends";
            col.Name = "Ends";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 50;
            dgv.Columns.Add(col);

            for (int n = 1; n <= CurMatchInfo.ArrowCount; n++)
            {
                col = new DataGridViewTextBoxColumn();
                col.ReadOnly = true;

                col.HeaderText = n.ToString();
                col.Name = "Arrow" + n.ToString();
                col.ReadOnly = false;
                col.Frozen = true;
                col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
                col.SortMode = DataGridViewColumnSortMode.Programmatic;
                col.Resizable = DataGridViewTriState.False;
                col.Width = 30;
                dgv.Columns.Add(col);
            }
            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "10s";
            col.Name = "10s";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 40;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "Xs";
            col.Name = "Xs";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 40;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "Total";
            col.Name = "Total";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.ColumnHeader;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 40;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "Points";
            col.Name = "SetPoints";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.ColumnHeader;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 45;
            dgv.Columns.Add(col);

        }

        private void UpdateDataGridView(DataGridView dgv)
        {
            dgv.Rows.Clear();
            AR_Archer player = (AR_Archer)dgv.Tag;
            if (player.Ends.Count > 0)
            {
                for (int nRow = 0; nRow < CurMatchInfo.EndCount; nRow++)
                {
                    DataGridViewRow row = new DataGridViewRow();
                    row.CreateCells(dgv);
                    row.Selected = false;

                    AR_End theEnd = player.Ends[nRow];
                    row.Cells[0].Value = "End " + (nRow + 1).ToString();
                    int ColIndex = 1;
                    for (int nCol = 0; nCol < CurMatchInfo.ArrowCount; nCol++)
                    {
                        row.Cells[nCol + 1].Value = theEnd.Arrows[nCol].Ring;
                        row.Cells[nCol + 1].Tag = theEnd.Arrows[nCol];
                        ColIndex++;
                    }
                    row.Cells[ColIndex].Value = theEnd.R10Num;
                    ColIndex++;
                    row.Cells[ColIndex].Value = theEnd.Xnum;
                    ColIndex++;
                    row.Cells[ColIndex].Value = theEnd.Total;
                    ColIndex++;
                    row.Cells[ColIndex].Value = theEnd.Point;
                    ColIndex++;
                    dgv.Rows.Add(row);
                    row.Tag = theEnd;
                }
            }
            dgv.Tag = player;
        }

        private void InitComboBox(ComboBox cb)
        {
            cb.Items.Clear();

            ComboBoxItem item = new ComboBoxItem();
            item.Text = "You can select Winner";
            cb.Items.Add(item);

            List<AR_Archer> archers = new List<AR_Archer>();

            archers = AREntityOperation.GetCompetitionPlayers(m_nCurMatchID);
            if (archers.Count > 0)
            {
                foreach (AR_Archer ar in archers)
                {
                    ComboBoxItem itemA = new ComboBoxItem();
                    itemA.Text = ar.Name;
                    itemA.Tag = ar;
                    cb.Items.Add(itemA);
                    if (ar.QRank == "1")
                        cb.SelectedItem = itemA;
                }
            }
        }

        private void InitShootDataGridView(DataGridView dgv, int arrows)
        {
            dgv.Columns.Clear();
            DataGridViewColumn col = null;

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "SHOOT";
            col.Name = "SHOOT-OFF";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 70;
            dgv.Columns.Add(col);

            for (int n = 1; n <= arrows; n++)
            {
                col = new DataGridViewTextBoxColumn();
                col.ReadOnly = true;

                col.HeaderText = n.ToString();
                col.Name = "Arrow" + n.ToString();
                col.ReadOnly = false;
                col.Frozen = true;
                col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
                col.SortMode = DataGridViewColumnSortMode.Programmatic;
                col.Resizable = DataGridViewTriState.False;
                col.Width = 30;
                dgv.Columns.Add(col);
            }

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Total";
            col.Name = "Total";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.ColumnHeader;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 40;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Closest";
            col.Name = "Closest";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.ColumnHeader;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 40;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "10s";
            col.Name = "10s";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Xs";
            col.Name = "Xs";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);


        }

        private void UpdateShootDataGridView(DataGridView dgv)
        {
            dgv.Rows.Clear();
            AR_Archer player = (AR_Archer)dgv.Tag;
            if (player.ShootEnds.Count > 0)
            {
                for (int nRow = 0; nRow < player.ShootEnds.Count; nRow++)
                {
                    DataGridViewRow row = new DataGridViewRow();
                    row.CreateCells(dgv);
                    row.Selected = false;

                    AR_End theEnd = player.ShootEnds[nRow];
                    row.Cells[0].Value = "SHOOT-OFF";
                    int ColIndex = 1;
                    for (int nCol = 0; nCol < theEnd.Arrows.Count; nCol++)
                    {
                        row.Cells[nCol + 1].Value = theEnd.Arrows[nCol].Ring;
                        row.Cells[nCol + 1].Tag = theEnd.Arrows[nCol];
                        ColIndex++;
                    }
                    //row.Cells[ColIndex].Value = theEnd.R10Num;
                    //ColIndex++;
                    //row.Cells[ColIndex].Value = theEnd.Xnum;
                    //ColIndex++;
                    row.Cells[ColIndex].Value = theEnd.Total;
                    ColIndex++;
                    row.Cells[ColIndex].Value = theEnd.EndComment;
                    ColIndex++;
                    dgv.Rows.Add(row);
                    row.Tag = theEnd;
                }
            }
            dgv.Tag = player;
        }

        private void UpdateRecData()
        {
            this.Invoke(new ReceiveDataEventHandler(UpdateRecDataEventHandler), new object[] { });
            GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void UpdateRecDataEventHandler()
        {
            Players = AREntityOperation.GetCompetitionPlayersInfo(m_nCurMatchID);

            if (Players.Count > 1)
            {
                if (Players[0].ShootEnds.Count > 0)
                {
                    this.dgv_ShootA.Visible = true;
                    this.InitShootDataGridView(dgv_ShootA, Players[0].ShootEnds[0].Arrows.Count);
                }
                if (Players[1].ShootEnds.Count > 0)
                {
                    this.dgv_ShootB.Visible = true;
                    this.InitShootDataGridView(dgv_ShootB, Players[1].ShootEnds[0].Arrows.Count);
                }
                InitPlayerInfo();
            }
            this.InitComboBox(this.cb_Winner);

            SettingControlsStatus(CurMatchInfo);
        }
        #endregion

        #region Ex1
        private void SetDataGirdViewCellValueChanged(DataGridViewCell cell)
        {
            string colName = cell.OwningColumn.Name;
            if (colName == "Total")
            {
                if (CurMatchInfo.IsSetPoints == 0)
                {
                    labX_TotalA.Text = this.GetPlayerTotalScore(dgv_PlayerA);
                    labX_TotalB.Text = this.GetPlayerTotalScore(dgv_PlayerB);
                }

            }
            if (colName == "SetPoints")
            {
                if (CurMatchInfo.IsSetPoints == 1)
                {
                    labX_TotalA.Text = this.GetPlayerTotalPoint(dgv_PlayerA);
                    labX_TotalB.Text = this.GetPlayerTotalPoint(dgv_PlayerB);
                }

                AR_End rowEndA = (AR_End)dgv_PlayerA.Rows[cell.RowIndex].Tag;
                rowEndA.Point = ARFunctions.ConvertToStringFromObject(dgv_PlayerA.Rows[cell.RowIndex].Cells["SetPoints"].Value);
                GVAR.g_ManageDB.UpdatePlayerEnd(m_nCurMatchID, rowEndA.CompetitionPosition, rowEndA.SplitID, rowEndA.EndIndex, rowEndA.Total,
                                rowEndA.Point, rowEndA.R10Num, rowEndA.Xnum, 1);
                dgv_PlayerA.Rows[cell.RowIndex].Tag = rowEndA;
                AR_End rowEndB = (AR_End)dgv_PlayerB.Rows[cell.RowIndex].Tag;
                rowEndB.Point = ARFunctions.ConvertToStringFromObject(dgv_PlayerB.Rows[cell.RowIndex].Cells["SetPoints"].Value);
                GVAR.g_ManageDB.UpdatePlayerEnd(m_nCurMatchID, rowEndB.CompetitionPosition, rowEndB.SplitID, rowEndB.EndIndex, rowEndB.Total,
                                rowEndB.Point, rowEndB.R10Num, rowEndB.Xnum, 1);
                dgv_PlayerB.Rows[cell.RowIndex].Tag = rowEndB;

                GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }
            if (colName == "10s" || colName == "Xs")
            {
                labX_A10s.Text = GetPlayerTotalByColumns(dgv_PlayerA.Columns["10s"]);
                labX_B10s.Text = GetPlayerTotalByColumns(dgv_PlayerB.Columns["10s"]);
                labX_AXs.Text = GetPlayerTotalByColumns(dgv_PlayerA.Columns["Xs"]);
                labX_BXs.Text = GetPlayerTotalByColumns(dgv_PlayerB.Columns["Xs"]);

            }
        }

        private void EditArrowsInfo(DataGridViewCell cell)
        {
            bool bReturn = false;
            AR_Arrow arrow = (AR_Arrow)cell.Tag;
            arrow.Ring = ARFunctions.ConvertToStringFromObject(cell.Value);
            bReturn = GVAR.g_ManageDB.UpdatePlayerArrow(m_nCurMatchID, arrow.CompetitionPosition, arrow.FatherSplitID, arrow.ArrowIndex, arrow.Ring, 1);
            if (bReturn)
            {
                cell.Tag = arrow;
                AR_End rowEnd = (AR_End)cell.OwningRow.Tag;
                int curArrowIndex = rowEnd.Arrows.FindIndex(delegate(AR_Arrow aa) { return aa.ArrowIndex == arrow.ArrowIndex; });
                rowEnd.Arrows[curArrowIndex] = arrow;
                SetEnd10AndXNumbers(cell.OwningRow);
                if (IsAutoUpTotal) //自动更新每局总环数开关
                    SetPlayerEndTotal(cell.OwningRow);
                if (CurMatchInfo.IsSetPoints == 1)
                    this.SetEndPoints(cell.RowIndex);

                GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);

            }
        }

        private void SetPlayerEndTotal(DataGridViewRow row)
        {
            int rowTotal = 0;
            bool hasArrow = false;
            foreach (DataGridViewCell cell in row.Cells)
            {
                int curArrow = 0;
                if (cell.OwningColumn.Name.Contains("Arrow"))
                {
                    if (cell.Value == null)
                        cell.Value = "";
                    if (cell.Value.ToString().ToUpper() == "M")
                    {
                        curArrow = 0;
                        hasArrow = true;
                    }
                    else if (cell.Value.ToString().ToUpper() == "X")
                    {
                        curArrow = 10;
                        hasArrow = true;
                    }
                    else if (cell.Value != "")
                    {
                        curArrow = ARFunctions.ConvertToIntFromObject(cell.Value);
                        hasArrow = true;
                    }
                    rowTotal += curArrow;
                }
            }

            row.Cells["Total"].Value = hasArrow ? rowTotal.ToString() : "";
        }
        #endregion

        #region Ex2

        private void cbX_Auto_CheckedChanged(object sender, EventArgs e)
        {
            IsAutoUpTotal = cbX_Auto.Checked;
        }

        private void cbX_AutoPoint_CheckedChanged(object sender, EventArgs e)
        {
            IsAutoUpPoint = cbX_AutoPoint.Checked;
        }

        private void cb_AutoSetWinner_CheckedChanged(object sender, EventArgs e)
        {
            IsAutoUpWinner = cb_AutoSetWinner.Checked;
        }

        private void txtX_BibA_Leave(object sender, EventArgs e)
        {
            string strTarget = txtX_BibA.Text;
            if (!string.IsNullOrEmpty(strTarget))
            {
                AR_Archer player = (AR_Archer)dgv_PlayerA.Tag;
                player.Target = strTarget;
                bool bReturn = GVAR.g_ManageDB.UpdateMatchResult(m_nCurMatchID, player.CompetitionPosition, player.Num10S, player.NumXS,
                    player.Total, player.Result, player.QRank, player.DisplayPosition.ToString(), player.IRM, player.Target);
                if (bReturn)
                {
                    labX_BibA.Text = (player.Bib == "" ? "" : player.Bib + "/") + player.Target;
                    dgv_PlayerA.Tag = player;
                    txtX_BibA.Visible = false;
                    GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                }
            }
        }

        private void txtX_BibB_Leave(object sender, EventArgs e)
        {
            string strTarget = txtX_BibB.Text;
            if (!string.IsNullOrEmpty(strTarget))
            {
                AR_Archer player = (AR_Archer)dgv_PlayerB.Tag;
                player.Target = strTarget;
                bool bReturn = GVAR.g_ManageDB.UpdateMatchResult(m_nCurMatchID, player.CompetitionPosition, player.Num10S, player.NumXS,
                    player.Total, player.Result, player.QRank, player.DisplayPosition.ToString(), player.IRM, player.Target);
                if (bReturn)
                {
                    labX_BibB.Text = (player.Bib == "" ? "" : player.Bib + "/") + player.Target;
                    dgv_PlayerB.Tag = player;
                    txtX_BibB.Visible = false;
                    GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                }
            }
        }

        private void labX_BibA_Click(object sender, EventArgs e)
        {
            if (CurMatchInfo.MatchStatusID > 40 && CurMatchInfo.MatchStatusID < 100)
            {
                txtX_BibA.Visible = true;
                txtX_BibA.Focus();
                txtX_BibA.Text = ((AR_Archer)dgv_PlayerA.Tag).Target;
            }
        }

        private void labX_BibB_Click(object sender, EventArgs e)
        {
            if (CurMatchInfo.MatchStatusID > 40 && CurMatchInfo.MatchStatusID < 100)
            {
                txtX_BibB.Visible = true;
                txtX_BibB.Focus();
                txtX_BibB.Text = ((AR_Archer)dgv_PlayerB.Tag).Target;
            }
        }
        private void SettingControlsStatus(AR_MatchInfo matchInfo)
        {
            this.CurMatchInfo = matchInfo;
            if (CurMatchInfo.MatchStatusID <= 40 || CurMatchInfo.MatchStatusID >= 100)
            {
                foreach (DataGridViewColumn col in dgv_PlayerA.Columns)
                {
                    col.ReadOnly = true; ;
                }
                foreach (DataGridViewColumn col in dgv_PlayerB.Columns)
                {
                    col.ReadOnly = true; ;
                }
                cb_Winner.Enabled = false;
                cbX_Auto.Enabled = false;
                cbX_AutoPoint.Enabled = false;
                cb_AutoSetWinner.Enabled = false;
                txtX_BibA.Enabled = false;
                txtX_BibB.Enabled = false;
                txtX_BibB.Visible = false;
                txtX_BibB.Visible = false;
            }
            else
            {
                foreach (DataGridViewColumn col in dgv_PlayerA.Columns)
                {
                    if (col.Name.Contains("End"))
                        col.ReadOnly = true;
                    else col.ReadOnly = false; ;
                }
                foreach (DataGridViewColumn col in dgv_PlayerB.Columns)
                {
                    if (col.Name.Contains("End"))
                        col.ReadOnly = true;
                    else col.ReadOnly = false; ;
                }
                cb_Winner.Enabled = true;
                cbX_Auto.Enabled = true;
                cbX_AutoPoint.Enabled = true;
                cb_AutoSetWinner.Enabled = true;
                txtX_BibA.Enabled = true;
                txtX_BibB.Enabled = true;
            }
        }
        #endregion

        #region 排名
        private static int ArchersCompare(AR_Archer objEx1, AR_Archer objEx2)
        {
            if (objEx1 == objEx2)
                return 0;
            if (objEx1.Total != objEx2.Total)
            {
                int total1 = ARFunctions.ConvertToIntFromString(objEx1.Total);
                int total2 = ARFunctions.ConvertToIntFromString(objEx2.Total);
                if (total1 < total2)
                    return 1;
                else return -1;
            }
            else
            {
                if (objEx1.Num10S != objEx2.Num10S)
                {
                    int num10s_1 = ARFunctions.ConvertToIntFromString(objEx1.Num10S);
                    int num10s_2 = ARFunctions.ConvertToIntFromString(objEx2.Num10S);
                    if (num10s_1 < num10s_2)
                        return 1;
                    else return -1;
                }
                else
                {
                    if (objEx1.NumXS != objEx2.NumXS)
                    {
                        int numXs_1 = ARFunctions.ConvertToIntFromString(objEx1.NumXS);
                        int numXs_2 = ARFunctions.ConvertToIntFromString(objEx2.NumXS);
                        if (numXs_1 < numXs_2)
                            return 1;
                        else return -1;
                    }

                    else
                    {
                        objEx1.IRM = "T";
                        objEx2.IRM = "T";
                        return 0;
                    }
                }
            }
        }

        private static int ArchersComparePoint(AR_Archer objEx1, AR_Archer objEx2)
        {
            if (objEx1 == objEx2)
                return 0;
            if (objEx1.Result != objEx2.Result)
            {
                int total1 = ARFunctions.ConvertToIntFromString(objEx1.Result);
                int total2 = ARFunctions.ConvertToIntFromString(objEx2.Result);
                if (total1 < total2)
                    return 1;
                else return -1;
            }
            else
            {
                if (objEx1.Num10S != objEx2.Num10S)
                {
                    int num10s_1 = ARFunctions.ConvertToIntFromString(objEx1.Num10S);
                    int num10s_2 = ARFunctions.ConvertToIntFromString(objEx2.Num10S);
                    if (num10s_1 < num10s_2)
                        return 1;
                    else return -1;
                }
                else
                {
                    if (objEx1.NumXS != objEx2.NumXS)
                    {
                        int numXs_1 = ARFunctions.ConvertToIntFromString(objEx1.NumXS);
                        int numXs_2 = ARFunctions.ConvertToIntFromString(objEx2.NumXS);
                        if (numXs_1 < numXs_2)
                            return 1;
                        else return -1;
                    }

                    else
                    {
                        objEx1.IRM = "T";
                        objEx2.IRM = "T";
                        return 0;
                    }
                }
            }
        }

        public void ComputeResult(List<AR_Archer> archers)
        {
            int nDisplayPosition = 1;
            int nRank = 1;

            foreach (AR_Archer obj in archers)
            {
                if (obj.IRM.Length != 0 || obj.Total.Length == 0)
                {
                    obj.QRank = "";
                }
                else if (obj.Total.Length > 0)
                {
                    obj.QRank = nRank.ToString();
                    nRank++;
                }
                else
                {
                    if (nDisplayPosition != 1)
                        obj.QRank = nRank.ToString();
                }

                obj.DisplayPosition = nDisplayPosition;
                nDisplayPosition++;
            }
        }

        public void UpdateRank()
        {
            List<AR_Archer> Archers = new List<AR_Archer>();
            AR_Archer playerA = (AR_Archer)dgv_PlayerA.Tag;
            AR_Archer playerB = (AR_Archer)dgv_PlayerB.Tag;

            Archers.Add(playerA);
            Archers.Add(playerB);
            if (IsAutoUpWinner)
            {
                if (CurMatchInfo.IsSetPoints == 1)
                {
                    int pointA = ARFunctions.ConvertToIntFromString(labX_TotalA.Text);
                    int pointB = ARFunctions.ConvertToIntFromString(labX_TotalB.Text);
                    if (pointA >= CurMatchInfo.WinPoints || pointB >= CurMatchInfo.WinPoints)
                    {
                        this.Players.Sort(ArchersComparePoint);
                        ComputeResult(this.Players);

                    }
                }
                else if (GetIsFinishedMatch(dgv_PlayerA) && GetIsFinishedMatch(dgv_PlayerB))
                {
                    this.Players.Sort(ArchersCompare);
                    ComputeResult(this.Players);
                }
            }
            AR_Archer winner = null;
            foreach (AR_Archer player in Archers)
            {
                bool bReturn = GVAR.g_ManageDB.UpdateMatchResult(m_nCurMatchID, player.CompetitionPosition, player.Num10S,
                    player.NumXS, player.Total, player.Result, player.QRank, player.DisplayPosition.ToString(), player.IRM, player.Target);
                if (bReturn && player.QRank == "1")
                {
                    winner = player;
                    GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                }
            }

            dgv_PlayerA.Tag = Archers.Find(delegate(AR_Archer aa) { return aa.CompetitionPosition == playerA.CompetitionPosition; });
            dgv_PlayerB.Tag = Archers.Find(delegate(AR_Archer aa) { return aa.CompetitionPosition == playerB.CompetitionPosition; });
            SetWinnerTextInfo(winner);
        }
        #endregion

        #region 加赛
        private void dgv_ShootA_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex > 0)
            {
                AR_End rowEnd = new AR_End();
                bool bReturn = false;
                if (dgv_ShootA.Rows[e.RowIndex].Cells[e.ColumnIndex].OwningColumn.Name.Contains("Arrow"))
                {
                    DataGridViewCell cell = dgv_ShootA.Rows[e.RowIndex].Cells[e.ColumnIndex];
                    AR_Arrow arrow = (AR_Arrow)cell.Tag;
                    arrow.Ring = ARFunctions.ConvertToStringFromObject(cell.Value);
                    SetPlayerEndTotal(cell.OwningRow);
                    bReturn = GVAR.g_ManageDB.UpdatePlayerShootArrow(m_nCurMatchID, arrow.CompetitionPosition, arrow.FatherSplitID, arrow.ArrowIndex, arrow.Ring, 1);
                    if (bReturn)
                    {
                        cell.Tag = arrow;
                        rowEnd = (AR_End)cell.OwningRow.Tag;
                        int curArrowIndex = rowEnd.Arrows.FindIndex(delegate(AR_Arrow aa) { return aa.ArrowIndex == arrow.ArrowIndex; });
                        rowEnd.Arrows[curArrowIndex] = arrow;
                        GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                    }
                }

                rowEnd = (AR_End)dgv_ShootA.Rows[e.RowIndex].Tag;
                rowEnd.Total = ARFunctions.ConvertToStringFromObject(dgv_ShootA.Rows[e.RowIndex].Cells["Total"].Value);

                bReturn = GVAR.g_ManageDB.UpdatePlayerShootEnd(m_nCurMatchID, rowEnd.CompetitionPosition, rowEnd.SplitID, rowEnd.EndIndex, rowEnd.Total,
                                rowEnd.Point, rowEnd.R10Num, rowEnd.Xnum, rowEnd.EndComment, 0);
                if (bReturn)
                {
                    dgv_ShootA.Rows[e.RowIndex].Tag = rowEnd;
                    AR_End rEnd = (AR_End)dgv_ShootB.Rows[e.RowIndex].Tag;
                    if (rEnd.Total != "" && rowEnd.Total != "")
                    {
                        if (ARFunctions.ConvertToIntFromString(rowEnd.Total) > ARFunctions.ConvertToIntFromString(rEnd.Total))
                            cb_Winner.SelectedIndex = 1;
                        else if (ARFunctions.ConvertToIntFromString(rowEnd.Total) < ARFunctions.ConvertToIntFromString(rEnd.Total))
                            cb_Winner.SelectedIndex = 2;
                        else cb_Winner.SelectedIndex = 0;

                    }
                    GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                }
            }
        }
        private void dgv_ShootA_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (!dgv_ShootA.Columns[e.ColumnIndex].ReadOnly && e.FormattedValue != null && e.ColumnIndex > 0)
            {
                if (e.FormattedValue.ToString() == "")
                    return;
                //判断输入三次所要重量的正确性                
                string strInput = e.FormattedValue.ToString();
                if (dgv_ShootA.Columns[e.ColumnIndex].Name.Contains("Arrow") && strInput.ToLower() == "m")
                    strInput = "0";
                else if (dgv_ShootA.Columns[e.ColumnIndex].Name.Contains("Arrow") && strInput.ToLower() == "x")
                    strInput = "10";
                int attOut = 0;
                if (!int.TryParse(strInput, out attOut))
                {
                    e.Cancel = true;
                }
            }
        }
        private void dgv_ShootA_CellMouseDown(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.ColumnIndex > 0 && e.RowIndex >= 0)
            {
                if (dgv_ShootA.Columns[e.ColumnIndex].Name.Contains("Arrow") &&
                    (CurMatchInfo.MatchStatusID > 40 && CurMatchInfo.MatchStatusID < 100))
                {
                    this.Menu_X.Tag = dgv_ShootA[e.ColumnIndex, e.RowIndex];
                    this.dgv_ShootA.ContextMenuStrip = this.Menu_X;

                }
                else if (dgv_ShootA.Columns[e.ColumnIndex].Name.Contains("Closest") &&
                    (CurMatchInfo.MatchStatusID > 40 && CurMatchInfo.MatchStatusID < 100))
                {
                    this.Menu_Closest.Tag = dgv_ShootA[e.ColumnIndex, e.RowIndex];
                    this.dgv_ShootA.ContextMenuStrip = this.Menu_Closest;
                }
                else
                    this.dgv_ShootA.ContextMenuStrip = null;
            }

        }

        private void dgv_ShootB_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex > 0)
            {
                AR_End rowEnd = new AR_End();
                bool bReturn = false;
                if (dgv_ShootB.Rows[e.RowIndex].Cells[e.ColumnIndex].OwningColumn.Name.Contains("Arrow"))
                {
                    DataGridViewCell cell = dgv_ShootB.Rows[e.RowIndex].Cells[e.ColumnIndex];
                    AR_Arrow arrow = (AR_Arrow)cell.Tag;
                    arrow.Ring = ARFunctions.ConvertToStringFromObject(cell.Value);
                    SetPlayerEndTotal(cell.OwningRow);
                    bReturn = GVAR.g_ManageDB.UpdatePlayerShootArrow(m_nCurMatchID, arrow.CompetitionPosition, arrow.FatherSplitID, arrow.ArrowIndex, arrow.Ring, 1);
                    if (bReturn)
                    {
                        cell.Tag = arrow;
                        rowEnd = (AR_End)cell.OwningRow.Tag;
                        int curArrowIndex = rowEnd.Arrows.FindIndex(delegate(AR_Arrow aa) { return aa.ArrowIndex == arrow.ArrowIndex; });
                        rowEnd.Arrows[curArrowIndex] = arrow;
                        GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                    }
                }

                rowEnd = (AR_End)dgv_ShootB.Rows[e.RowIndex].Tag;
                rowEnd.Total = ARFunctions.ConvertToStringFromObject(dgv_ShootB.Rows[e.RowIndex].Cells["Total"].Value);

                bReturn = GVAR.g_ManageDB.UpdatePlayerShootEnd(m_nCurMatchID, rowEnd.CompetitionPosition, rowEnd.SplitID, rowEnd.EndIndex, rowEnd.Total,
                                rowEnd.Point, rowEnd.R10Num, rowEnd.Xnum, rowEnd.EndComment, 0);
                if (bReturn)
                {
                    dgv_ShootB.Rows[e.RowIndex].Tag = rowEnd;
                    AR_End rEnd = (AR_End)dgv_ShootA.Rows[e.RowIndex].Tag;
                    if (rEnd.Total != "" && rowEnd.Total != "")
                    {
                        if (ARFunctions.ConvertToIntFromString(rowEnd.Total) > ARFunctions.ConvertToIntFromString(rEnd.Total))
                            cb_Winner.SelectedIndex = 2;
                        else if (ARFunctions.ConvertToIntFromString(rowEnd.Total) < ARFunctions.ConvertToIntFromString(rEnd.Total))
                            cb_Winner.SelectedIndex = 1;
                        else cb_Winner.SelectedIndex = 0;
                    }
                    GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                }
            }
        }
        private void dgv_ShootB_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (!dgv_ShootB.Columns[e.ColumnIndex].ReadOnly && e.FormattedValue != null && e.ColumnIndex > 0)
            {
                if (e.FormattedValue.ToString() == "")
                    return;
                //判断输入三次所要重量的正确性                
                string strInput = e.FormattedValue.ToString();
                if (dgv_ShootB.Columns[e.ColumnIndex].Name.Contains("Arrow") && strInput.ToLower() == "m")
                    strInput = "0";
                else if (dgv_ShootB.Columns[e.ColumnIndex].Name.Contains("Arrow") && strInput.ToLower() == "x")
                    strInput = "10";
                int attOut = 0;
                if (!int.TryParse(strInput, out attOut))
                {
                    e.Cancel = true;
                }
            }
        }
        private void dgv_ShootB_CellMouseDown(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.ColumnIndex > 0 && e.RowIndex >= 0)
            {
                if (dgv_ShootB.Columns[e.ColumnIndex].Name.Contains("Arrow") &&
                    (CurMatchInfo.MatchStatusID > 40 && CurMatchInfo.MatchStatusID < 100))
                {
                    this.Menu_X.Tag = dgv_ShootB[e.ColumnIndex, e.RowIndex];
                    this.dgv_ShootB.ContextMenuStrip = this.Menu_X;

                }
                else if (dgv_ShootB.Columns[e.ColumnIndex].Name.Contains("Closest") &&
                    (CurMatchInfo.MatchStatusID > 40 && CurMatchInfo.MatchStatusID < 100))
                {
                    this.Menu_Closest.Tag = dgv_ShootB[e.ColumnIndex, e.RowIndex];
                    this.dgv_ShootB.ContextMenuStrip = this.Menu_Closest;
                }
                else
                    this.dgv_ShootB.ContextMenuStrip = null;
            }

        }

        private void toolStripMenuItem1_Click(object sender, EventArgs e)
        {
            DataGridViewCell cell = (DataGridViewCell)Menu_Closest.Tag;
            if (cell.OwningRow.DataGridView.Name == "dgv_ShootA")
            {
                dgv_ShootA[cell.ColumnIndex, dgv_ShootA.RowCount - 1].Value = "*";
                dgv_ShootB[cell.ColumnIndex, dgv_ShootB.RowCount - 1].Value = "";
                cb_Winner.SelectedIndex = 1;
            }
            else
            {
                dgv_ShootA[cell.ColumnIndex, dgv_ShootA.RowCount - 1].Value = "";
                dgv_ShootB[cell.ColumnIndex, dgv_ShootB.RowCount - 1].Value = "*";
                cb_Winner.SelectedIndex = 2;
            }
            AR_End rowEndA = (AR_End)dgv_ShootA.Rows[dgv_ShootA.RowCount - 1].Tag;
            rowEndA.EndComment = ARFunctions.ConvertToStringFromObject(dgv_ShootA.Rows[dgv_ShootA.RowCount - 1].Cells["Closest"].Value);

            bool bReturn1 = GVAR.g_ManageDB.UpdatePlayerShootEnd(m_nCurMatchID, rowEndA.CompetitionPosition, rowEndA.SplitID, rowEndA.EndIndex, rowEndA.Total,
                            rowEndA.Point, rowEndA.R10Num, rowEndA.Xnum, rowEndA.EndComment, 0);
            AR_End rowEndB = (AR_End)dgv_ShootB.Rows[dgv_ShootA.RowCount - 1].Tag;
            rowEndB.EndComment = ARFunctions.ConvertToStringFromObject(dgv_ShootB.Rows[dgv_ShootB.RowCount - 1].Cells["Closest"].Value);

            bool bReturn2 = GVAR.g_ManageDB.UpdatePlayerShootEnd(m_nCurMatchID, rowEndB.CompetitionPosition, rowEndB.SplitID, rowEndB.EndIndex, rowEndB.Total,
                            rowEndB.Point, rowEndB.R10Num, rowEndB.Xnum, rowEndB.EndComment, 0);
            if (bReturn1 && bReturn2)
            {
                dgv_ShootA.Rows[dgv_ShootA.RowCount - 1].Tag = rowEndA;
                dgv_ShootB.Rows[dgv_ShootA.RowCount - 1].Tag = rowEndB;
                GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }
        }
        private void nullToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            DataGridViewCell cell = (DataGridViewCell)Menu_Closest.Tag;
            dgv_ShootA[cell.ColumnIndex, dgv_ShootA.RowCount - 1].Value = "";
            dgv_ShootB[cell.ColumnIndex, dgv_ShootB.RowCount - 1].Value = "";
            cb_Winner.SelectedIndex = 0;
            AR_End rowEndA = (AR_End)dgv_ShootA.Rows[dgv_ShootA.RowCount - 1].Tag;
            rowEndA.EndComment = ARFunctions.ConvertToStringFromObject(dgv_ShootA.Rows[dgv_ShootA.RowCount - 1].Cells["Closest"].Value);

            bool bReturn1 = GVAR.g_ManageDB.UpdatePlayerShootEnd(m_nCurMatchID, rowEndA.CompetitionPosition, rowEndA.SplitID, rowEndA.EndIndex, rowEndA.Total,
                            rowEndA.Point, rowEndA.R10Num, rowEndA.Xnum, rowEndA.EndComment, 0);
            AR_End rowEndB = (AR_End)dgv_ShootB.Rows[dgv_ShootA.RowCount - 1].Tag;
            rowEndB.EndComment = ARFunctions.ConvertToStringFromObject(dgv_ShootB.Rows[dgv_ShootB.RowCount - 1].Cells["Closest"].Value);

            bool bReturn2 = GVAR.g_ManageDB.UpdatePlayerShootEnd(m_nCurMatchID, rowEndB.CompetitionPosition, rowEndB.SplitID, rowEndB.EndIndex, rowEndB.Total,
                            rowEndB.Point, rowEndB.R10Num, rowEndB.Xnum, rowEndB.EndComment, 0);
            if (bReturn1 && bReturn2)
            {
                dgv_ShootA.Rows[dgv_ShootA.RowCount - 1].Tag = rowEndA;
                dgv_ShootB.Rows[dgv_ShootA.RowCount - 1].Tag = rowEndB;
                GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }
        }
        #endregion

        #region 纪录

        private int DataExchangeRecord(DataGridView dgv, LabelX labX)
        {
            System.Data.DataTable dt = this.dt_Records;
            AR_Archer player = (AR_Archer)dgv.Tag;
            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                if (!string.IsNullOrEmpty(player.Total))
                {
                    //总成绩
                    int nOldRecord = 9999;
                    string strOldRecord = "";
                    string subCode = "10";
                    if (dt.Rows[nRow]["GroupRecord"] != DBNull.Value)
                        strOldRecord = dt.Rows[nRow]["GroupRecord"].ToString();
                    if (strOldRecord.Length != 0)
                        nOldRecord = int.Parse(strOldRecord);

                    int RecordTypeID = 0;
                    if (dt.Rows[nRow]["RecordTypeID"] != DBNull.Value)
                        RecordTypeID = int.Parse(dt.Rows[nRow]["RecordTypeID"].ToString());
                    string RecordTypeCode = string.Empty;
                    if (dt.Rows[nRow]["Record"] != DBNull.Value)
                        RecordTypeCode = dt.Rows[nRow]["Record"].ToString();

                    if (Convert.ToInt32(player.Total) >= nOldRecord && nOldRecord != 9999)
                    {
                        //更新数据库
                        int nRecordRegisterID = 0;
                        if (dt.Rows[nRow]["GroupRegisterID"] != DBNull.Value)
                            nRecordRegisterID = int.Parse(dt.Rows[nRow]["GroupRegisterID"].ToString());
                        int isEquals = int.Equals(Convert.ToInt32(player.Total), nOldRecord) ? 1 : 0;
                        if ((player.RegisterID != nRecordRegisterID && isEquals != 0) || isEquals == 0)
                        {
                            bool bReturn = GVAR.g_ManageDB.UpdateRecord(m_nCurMatchID, player.CompetitionPosition,
                                subCode, player.Total, RecordTypeID, isEquals);

                            if (bReturn)
                                GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                        }
                        if (isEquals == 0 || player.RegisterID == nRecordRegisterID)
                            labX.Text = RecordTypeCode;
                        else
                            labX.Text = "E" + RecordTypeCode;
                    }
                    else if (Convert.ToInt32(player.Total) < nOldRecord && nOldRecord != 9999)
                    {
                        int nRecordRegisterID = 0;
                        if (dt.Rows[nRow]["GroupRegisterID"] != DBNull.Value)
                            nRecordRegisterID = int.Parse(dt.Rows[nRow]["GroupRegisterID"].ToString());
                        string nRecordID = string.Empty;
                        if (dt.Rows[nRow]["GroupRecordID"] != DBNull.Value)
                            nRecordID = dt.Rows[nRow]["GroupRecordID"].ToString();
                        labX.Text = "";
                        if (player.RegisterID == nRecordRegisterID)
                        {
                            int nReturn = GVAR.g_ManageDB.DeleteMatchRecord(nRecordID, player.Total.ToString());
                        }
                    }
                }
            }
            this.dt_Records = GVAR.g_ManageDB.GetRecordList(m_nCurMatchID);
            return 1;
        }
        #endregion

    }
}
