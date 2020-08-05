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
namespace AutoSports.OVRARPlugin
{
    public partial class frmQualificationEnds : Office2007Form
    {
        public int m_nCurMatchID = -1;
        public int m_nCurDistince = -1;
        public AR_MatchInfo CurMatchInfo = new AR_MatchInfo();
        private AR_Archer Player = null;
        private bool IsAutoUpTotal = true;
        public ARDataEntryUpdatedMatchInfo UpdatedUserControlsHandler;
        public ARDataEntryUpdatedMatchInfo UpdatedMainFormMatchInfo;
        public string nTotal = "";
        public string nTotal10s = "";
        public string nTotalXs = "";

        public frmQualificationEnds(int nMatchID, int nDistince, AR_Archer Archer)
        {
            InitializeComponent();

            m_nCurMatchID = nMatchID;
            m_nCurDistince = nDistince;
            Player = Archer;
            this.UpdatedUserControlsHandler = new ARDataEntryUpdatedMatchInfo(SettingControlsStatus);
        }

        private void frmQualificationEnds_Load(object sender, EventArgs e)
        {
            this.InitDataGridView(dgv_PlayerA);

            Player = AREntityOperation.GetCompetitionPlayerInfo(m_nCurMatchID, Player, m_nCurDistince);

            if (Player != null)
            {
                InitPlayerInfo();

            }
            labX_A10s.Text = GetPlayerTotalByColumns(dgv_PlayerA.Columns["10s"]);
            labX_AXs.Text = GetPlayerTotalByColumns(dgv_PlayerA.Columns["Xs"]);
            SettingControlsStatus(CurMatchInfo);

            ARUdpService.ReceivedData += new ReceiveDataEventHandler(UpdateRecData);
        }

        private void UpdateRecData()
        { 
            while (this.IsHandleCreated)
            {
                this.Invoke(new ReceiveDataEventHandler(UpdateRecDataEventHandler), new object[] { });
                return;
            }
        }

        private void UpdateRecDataEventHandler()
        {
            Player = AREntityOperation.GetCompetitionPlayerInfo(m_nCurMatchID, Player, m_nCurDistince);

            if (Player != null)
            {
                dgv_PlayerA.Tag = Player;
                InterfaceUpdateDataGridView(dgv_PlayerA);
                SettingControlsStatus(CurMatchInfo);
            }
        }

        #region A编辑
        private void dgv_PlayerA_CellMouseDown(object sender, DataGridViewCellMouseEventArgs e)
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
        private void dgv_PlayerA_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (!dgv_PlayerA.Columns[e.ColumnIndex].ReadOnly && e.FormattedValue != null && e.ColumnIndex > 0)
            {
                if (e.FormattedValue.ToString() == "")
                    return;
                //判断输入三次所要重量的正确性                
                string strInput = e.FormattedValue.ToString();
                if (dgv_PlayerA.Columns[e.ColumnIndex].Name.Contains("Arrow") && strInput.ToLower() == "x")
                    strInput = "10";
                else if (dgv_PlayerA.Columns[e.ColumnIndex].Name.Contains("Arrow") && strInput.ToLower() == "m")
                    strInput = "0";
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

                labX_TotalA.Text = this.GetPlayerTotalScore(dgv_PlayerA);
                bReturn = GVAR.g_ManageDB.UpdatePlayerEnd(m_nCurMatchID, rowEnd.CompetitionPosition, rowEnd.SplitID, rowEnd.EndIndex, rowEnd.Total,
                                rowEnd.Point, rowEnd.R10Num, rowEnd.Xnum, 0);
                if (bReturn)
                {
                    dgv_PlayerA.Rows[e.RowIndex].Tag = rowEnd;
                    GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                }
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
                //player.Num10S = Num10A;
            }
            if (labA == labX_AXs)
            {
                string NumXA = labX_AXs.Text;
                //player.NumXS = NumXA;
            }
            if (labA == labX_TotalA)
            {
                string Total = labX_TotalA.Text;
                if (m_nCurDistince == 1)
                    player.TotalLongA = Total;
                else if (m_nCurDistince == 2)
                    player.TotalLongB = Total;
                else if (m_nCurDistince == 3)
                    player.TotalShortA = Total;
                else if (m_nCurDistince == 4)
                    player.TotalShortB = Total;
            }

            dgv_PlayerA.Tag = player;
            //UpdateRank();
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
                labX_IRMA.Text = IRM;
                GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }

        }
        #endregion

        #region 设置红心
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
        }
        private void toolStripMenuItem_X_Click(object sender, EventArgs e)
        {
            DataGridViewCell cell = (DataGridViewCell)((ContextMenuStrip)((ToolStripMenuItem)sender).Owner).Tag;
            cell.Value = "X";
            EditArrowsInfo(cell);
        }
        private void nullToolStripMenuItem_Click(object sender, EventArgs e)
        {
            DataGridViewCell cell = (DataGridViewCell)((ContextMenuStrip)((ToolStripMenuItem)sender).Owner).Tag;
            cell.Value = "";
            SetEnd10AndXNumbers(cell.OwningRow);
            if (IsAutoUpTotal) //自动更新每局总环数开关
                SetPlayerEndTotal(cell.OwningRow);
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
        #endregion

        #region Init

        private void InitPlayerInfo()
        {
            try
            {
                //初始化运动员 A
                dgv_PlayerA.Tag = Player;

                gp_PlayerA.Text = Player.Name;
                this.labX_BibA.Text = Player.Target;
                this.labX_NOCA.Text = Player.Noc;
                this.labX_IRMA.Text = Player.IRM;
                this.UpdateDataGridView(dgv_PlayerA);

                this.labX_All.Text = Player.Total;

                switch (m_nCurDistince)
                {
                    case 1:
                        labX_Distince.Text = "70m"; ;
                        labX_TotalA.Text = Player.TotalLongA;
                        break;
                    case 2:
                        labX_Distince.Text = "70m";
                        labX_TotalA.Text = Player.TotalLongB;
                        break;
                    case 3:
                        labX_Distince.Text = "70m";
                        labX_TotalA.Text = Player.TotalShortA;
                        break;
                    case 4:
                        labX_Distince.Text = "70m";
                        labX_TotalA.Text = Player.TotalShortB;
                        break;
                }
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
                col.Width = 40;
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
                    dgv.Rows.Add(row);
                    row.Tag = theEnd;
                }
            }
            dgv.Tag = player;
        }

        private void InterfaceUpdateDataGridView(DataGridView dgv)
        {
            AR_Archer player = (AR_Archer)dgv.Tag;
            if (player.Ends.Count > 0)
            {
                for (int nRow = 1; nRow <= dgv.Rows.Count; nRow++)
                {
                    DataGridViewRow row = dgv.Rows[nRow-1];
                    AR_End theEnd = player.Ends.Find(p=>p.EndIndex == nRow.ToString());
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
                    row.Tag = theEnd;
                }
            }
            dgv.Tag = player;
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
                }

            }
            if (colName == "10s" || colName == "Xs")
            {
                labX_A10s.Text = GetPlayerTotalByColumns(dgv_PlayerA.Columns["10s"]);
                labX_AXs.Text = GetPlayerTotalByColumns(dgv_PlayerA.Columns["Xs"]);

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
                GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }
        }

        private void SetPlayerEndTotal(DataGridViewRow row)
        {
            int rowTotal = 0;
            foreach (DataGridViewCell cell in row.Cells)
            {
                int curArrow = 0;
                if (cell.OwningColumn.Name.Contains("Arrow"))
                {
                    if (cell.Value.ToString().ToUpper() == "X")
                        curArrow = 10;
                    else if (cell.Value.ToString().ToUpper() == "M")
                        curArrow = 0;
                    else curArrow = ARFunctions.ConvertToIntFromObject(cell.Value);
                    rowTotal += curArrow;
                }
            }

            row.Cells["Total"].Value = rowTotal == 0 ? "" : rowTotal.ToString();
        }
        #endregion

        #region Ex2

        private void cbX_Auto_CheckedChanged(object sender, EventArgs e)
        {
            IsAutoUpTotal = cbX_Auto.Checked;
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
                cbX_Auto.Enabled = false;
            }
            else
            {
                foreach (DataGridViewColumn col in dgv_PlayerA.Columns)
                {
                    if (col.Name.Contains("End"))
                        col.ReadOnly = true;
                    col.ReadOnly = false; ;
                }
                cbX_Auto.Enabled = true;
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

            Archers.Add(playerA);
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
        }
        #endregion

        private void btnX_Update_Click(object sender, EventArgs e)
        {
            nTotal = GetPlayerTotalScore(dgv_PlayerA);
            nTotal10s = GVAR.g_ManageDB.GetMatch10AndXNumbers(m_nCurMatchID, -1, Player.CompetitionPosition, 0).ToString();
            nTotalXs = GVAR.g_ManageDB.GetMatch10AndXNumbers(m_nCurMatchID, -1, Player.CompetitionPosition, 1).ToString();
            this.DialogResult = System.Windows.Forms.DialogResult.OK;
            GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void btnX_Return_Click(object sender, EventArgs e)
        {
            nTotal = GetPlayerTotalScore(dgv_PlayerA);
            this.DialogResult = System.Windows.Forms.DialogResult.Cancel;
        }


    }
}
