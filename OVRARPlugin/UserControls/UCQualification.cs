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
    public partial class UCQualification : UserControl
    {
        public int m_nCurMatchID = -1;
        public int m_nCurDistince = 1;
        public AR_MatchInfo CurMatchInfo = new AR_MatchInfo();
        public ARDataEntryUpdatedMatchInfo UpdatedUserControlsHandler;
        public ARDataEntryUpdatedMatchInfo UpdatedMainFormMatchInfo;

        private DataTable dt_Records = null;

        public UCQualification(int nMatchID)
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

        private void UCQualification_Load(object sender, EventArgs e)
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

            this.dgv_List.Columns.Clear();
            this.dgv_List.Rows.Clear();

            this.InitDataGridView();
            this.UpdateDataGridView();

            SettingControlsStatus(CurMatchInfo);
        }

        #region 靶位表编辑
        private void dgv_List_CellMouseDown(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (dgv_List.Columns[e.ColumnIndex].Name == "IRM" &&
                (CurMatchInfo.MatchStatusID > 40 && CurMatchInfo.MatchStatusID < 100))
                this.dgv_List.ContextMenuStrip = MenuStrip_IRM;
            else if (dgv_List.Columns[e.ColumnIndex].Name.ToLower().Contains("distince")
                && e.ColumnIndex >= 0 && e.RowIndex >= 0 &&
                (CurMatchInfo.MatchStatusID > 40 && CurMatchInfo.MatchStatusID < 100))
            {
                this.MenuStrip_Ends.Tag = dgv_List[e.ColumnIndex, e.RowIndex];
                this.dgv_List.ContextMenuStrip = this.MenuStrip_Ends;
            }
            else if (dgv_List.Columns[e.ColumnIndex].Name.ToLower().Contains("rank")
                && e.ColumnIndex >= 0 && e.RowIndex >= 0 &&
                (CurMatchInfo.MatchStatusID > 40 && CurMatchInfo.MatchStatusID < 100))
            {
                this.MenuStrip_ShootOff.Tag =  dgv_List.Rows[e.RowIndex].Tag;
                this.dgv_List.ContextMenuStrip = this.MenuStrip_ShootOff;

            }
            else
                this.dgv_List.ContextMenuStrip = null;
        }
        private void dgv_List_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (!dgv_List.Columns[e.ColumnIndex].ReadOnly && e.FormattedValue != null && e.ColumnIndex > 0 && dgv_List.Columns[e.ColumnIndex].Name != "Target")
            {
                if (e.FormattedValue.ToString() == "")
                    return;
                //判断输入三次所要重量的正确性
                int attOut = 0;
                if (!int.TryParse(e.FormattedValue.ToString(), out attOut))
                {
                    e.Cancel = true;
                }
            }
        }
        private void dgv_List_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            string strColumnName = dgv_List.Rows[e.RowIndex].Cells[e.ColumnIndex].OwningColumn.Name;
            AR_Archer currentPlayer = (AR_Archer)dgv_List.Rows[e.RowIndex].Tag;

            #region 编辑靶位、成绩
            switch (strColumnName)
            {
                case "Target":
                    currentPlayer.Target = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[e.RowIndex].Cells[strColumnName].Value);
                    break;
                case "LongDistinceA":
                    currentPlayer.TotalLongA = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[e.RowIndex].Cells[strColumnName].Value);
                    break;
                case "LongDistinceB":
                    currentPlayer.TotalLongB = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[e.RowIndex].Cells[strColumnName].Value);
                    break;
                case "ShortDistinceA":
                    currentPlayer.TotalShortA = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[e.RowIndex].Cells[strColumnName].Value);
                    break;
                case "ShortDistinceB":
                    currentPlayer.TotalShortB = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[e.RowIndex].Cells[strColumnName].Value);
                    break;
                case "Total":
                    currentPlayer.Total = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[e.RowIndex].Cells[strColumnName].Value);
                    break;
            }
            currentPlayer.Num10S = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[e.RowIndex].Cells["10s"].Value);
            currentPlayer.NumXS = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[e.RowIndex].Cells["Xs"].Value);
            if (strColumnName != "Total") currentPlayer.Total = currentPlayer.GetTatalRings();
            #endregion

            bool bReturn = GVAR.g_ManageDB.UpdateQualificationMatchResult(m_nCurMatchID, currentPlayer, 1);

            if (bReturn)
            {
                dgv_List.Rows[e.RowIndex].Tag = currentPlayer;
                dgv_List.Rows[e.RowIndex].Cells["Total"].Value = currentPlayer.Total;
                this.UpdateRank();
                GVAR.g_ManageDB.UpdateMatchEndsDistinceRanking(m_nCurMatchID);
                //破纪录
                if (dgv_List.Columns[e.ColumnIndex].Name.ToLower().Contains("distince") || dgv_List.Columns[e.ColumnIndex].Name.ToLower().Contains("total"))
                    DataExchangeRecord(dgv_List[e.ColumnIndex, e.RowIndex]);
                GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }
        }
        private void dgv_List_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            //破纪录
            if (dgv_List.Columns[e.ColumnIndex].Name.ToLower().Contains("distince") || dgv_List.Columns[e.ColumnIndex].Name.ToLower().Contains("total"))
                DataExchangeRecord(dgv_List[e.ColumnIndex, e.RowIndex]);
        }
        #endregion

        #region 运动员异常状态设置
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
            DataGridViewRow drow = dgv_List.SelectedRows[0];
            bool bUpdate = false;

            AR_Archer player = (AR_Archer)dgv_List.Rows[drow.Index].Tag;
            player.IRM = IRM;

            player.Total = IRM.Length != 0 ? "" : player.GetTatalRings();
            bool bReturn = GVAR.g_ManageDB.UpdateQualificationMatchResult(m_nCurMatchID, player, 0);
            if (bReturn)
            {
                bUpdate = true;
                dgv_List.Rows[drow.Index].Cells["Rank"].Value = "";
                dgv_List.Rows[drow.Index].Cells["Total"].Value = player.Total;
                dgv_List.Rows[drow.Index].Cells["IRM"].Value = IRM;
                dgv_List.Rows[drow.Index].Tag = player;
            }

            if (bUpdate)
            {
                this.UpdateRank();
                GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }
        }

        private void toolStripMenuItem_Show_Click(object sender, EventArgs e)
        {
            DataGridViewCell cell = (DataGridViewCell)this.MenuStrip_Ends.Tag;
            AR_Archer player = (AR_Archer)cell.OwningRow.Tag; ;
            frmQualificationEnds EndsForm = new frmQualificationEnds(m_nCurMatchID, m_nCurDistince, player);
            EndsForm.m_nCurMatchID = this.m_nCurMatchID;
            EndsForm.m_nCurDistince = (int)cell.OwningColumn.Tag;
            EndsForm.CurMatchInfo = this.CurMatchInfo;
            EndsForm.ShowDialog();
            if (EndsForm.DialogResult == DialogResult.OK)
            {
                cell.Value = EndsForm.nTotal;
                cell.OwningRow.Cells["10s"].Value = EndsForm.nTotal10s;
                cell.OwningRow.Cells["Xs"].Value = EndsForm.nTotalXs;
                this.dgv_List_CellEndEdit(cell, new DataGridViewCellEventArgs(cell.ColumnIndex, cell.RowIndex));
            }
        }

        private void toolStripMenuItem_ShootOff(object sender, EventArgs e)
        {
            ToolStripMenuItem tsmi = sender as ToolStripMenuItem; 
            bool bUpdate = false;

            AR_Archer player = (AR_Archer)MenuStrip_ShootOff.Tag;
            player.ShootOff = tsmi.Tag.ToString();
             
            bool bReturn = GVAR.g_ManageDB.UpdateQualificationMatchResult(m_nCurMatchID, player, 0);
            if (bReturn)
            {
                bUpdate = true;
                dgv_List.Rows[player.RowIndex].Cells["F_ShootOff"].Value = tsmi.Tag.ToString();
                dgv_List.Rows[player.RowIndex].Tag = player;
            }

            if (bUpdate)
            {
                this.UpdateRank();
                GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }
        }
        #endregion

        #region Init

        private void UpdateRecData()
        {
            this.Invoke(new ReceiveDataEventHandler(UpdateRecDataEventHandler), new object[] { });
            GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void UpdateRecDataEventHandler()
        {
            //UpdateDataGridView();
            InterfaceUpdateDataGridView();
            SettingControlsStatus(CurMatchInfo);
        }

        private void InitDataGridView()
        {
            DataGridView dgv = this.dgv_List;
            dgv.Columns.Clear();
            DataGridViewColumn col = null;

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "F_CompetitionPosition";
            col.Name = "F_CompetitionPosition";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCQualification_columnHeader_Target");
            col.Name = "Target";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.DefaultCellStyle.Font = new Font("Black", 12);
            col.DefaultCellStyle.ForeColor = Color.Blue;
            col.Width = 50;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCQualification_columnHeader_Name");
            col.Name = "Name";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.True;
            col.DefaultCellStyle.Font = new Font("Black", 12);
            col.Width = 200;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCQualification_columnHeader_Noc");
            col.Name = "NOC";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.DefaultCellStyle.Font = new Font("Black", 12);
            col.Width = 80;
            dgv.Columns.Add(col);


            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "70m";
            if (CurMatchInfo.Distince > 2 & CurMatchInfo.SexCode == "1")
                col.HeaderText = "90m";
            col.Name = "LongDistinceA";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.DefaultCellStyle.Font = new Font("Black", 12);
            col.Width = 60;
            col.Tag = 1;
            dgv.Columns.Add(col);


            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "70m";
            if (CurMatchInfo.Distince > 2 & CurMatchInfo.SexCode == "2")
                col.HeaderText = "60m";
            col.Name = "LongDistinceB";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.DefaultCellStyle.Font = new Font("Black", 12);
            col.Width = 60;
            col.Tag = 2;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "70m";
            if (CurMatchInfo.Distince > 2)
                col.HeaderText = "50m";
            col.Name = "ShortDistinceA";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.DefaultCellStyle.Font = new Font("Black", 12);
            col.Width = 60;
            col.Tag = 3;
            dgv.Columns.Add(col);


            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "70m";
            if (CurMatchInfo.Distince > 2)
                col.HeaderText = "30m";
            col.Name = "ShortDistinceB";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.DefaultCellStyle.Font = new Font("Black", 12);
            col.Width = 60;
            col.Tag = 4;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "10s";
            col.Name = "10s";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.DefaultCellStyle.Font = new Font("Black", 12);
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
            col.DefaultCellStyle.Font = new Font("Black", 12);
            col.Width = 40;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCQualification_columnHeader_Result");
            col.Name = "Total";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.DefaultCellStyle.Font = new Font("Black", 12);
            col.Width = 70;
            col.Tag = 0;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCQualification_columnHeader_Rank");
            col.Name = "Rank";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            col.DefaultCellStyle.Font = new Font("Black", 12);
            col.Width = 50;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "IRM";
            col.Name = "IRM";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.DefaultCellStyle.Font = new Font("Black", 12);
            col.Width = 50;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCQualification_columnHeader_Records");
            col.Name = "F_Records";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.DefaultCellStyle.Font = new Font("Black", 12);
            col.Width = 70;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_UCQualification_columnHeader_Comment");
            col.Name = "F_Comment";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.DefaultCellStyle.Font = new Font("Black", 12);
            col.DefaultCellStyle.ForeColor = Color.Red;
            col.Width = 50;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "F_RegisterID";
            col.Name = "F_RegisterID";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "F_ShootOff";
            col.Name = "F_ShootOff";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

        }

        private void UpdateDataGridView()
        {
            DataGridView dgv = this.dgv_List;
            System.Data.DataTable dt = GVAR.g_ManageDB.GetQualificationPlayerList(m_nCurMatchID);

            List<AR_Archer> players = new List<AR_Archer>();

            dgv.Rows.Clear();
            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row.CreateCells(dgv);
                row.Selected = false;

                int nCol = 0;
                string strFieldName = "";
                object obj = null;
                AR_Archer player = new AR_Archer();

                strFieldName = "F_CompetitionPosition";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.CompetitionPosition = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "Target";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.Target = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Name";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.Name = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "NOC";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.Noc = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "LongDistinceA";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.TotalLongA = ARFunctions.ConvertToStringFromObject(obj);


                strFieldName = "LongDistinceB";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.TotalLongB = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "ShortDistinceA";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.TotalShortA = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "ShortDistinceB";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.TotalShortB = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "10s";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.Num10S = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Xs";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.NumXS = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Total";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.Total = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Rank";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.QRank = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "IRM";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.IRM = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_Records";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.Records = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_Comment";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.Comment = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_RegisterID";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.RegisterID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_ShootOff";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[nCol].Value = obj.ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                player.ShootOff = ARFunctions.ConvertToStringFromObject(obj);

                #region
                //for (int n = 1; n <= m_nEndCount; n++)
                //{
                //    strFieldName = "End " + n.ToString();
                //    if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                //        row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                //    else
                //        row.Cells[nCol].Value = "";
                //    nCol++;
                //}

                //for (int n = 1; n <= m_nEndCount * m_nArrowCount; n++)
                //{
                //    strFieldName = n.ToString();
                //    if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                //        row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                //    else
                //        row.Cells[nCol].Value = "";
                //    nCol++;
                //}
                #endregion
                dgv.Rows.Add(row);
                player.RowIndex = row.Index;
                row.Tag = player;
                players.Add(player);
            }

            dgv_List.Tag = players;
        }

        private void InterfaceUpdateDataGridView()
        {
            DataGridView dgv = this.dgv_List;
            System.Data.DataTable dt = GVAR.g_ManageDB.GetQualificationPlayerList(m_nCurMatchID);

            List<AR_Archer> players = new List<AR_Archer>();

            for (int nRow = 0; nRow < dgv.Rows.Count; nRow++)
            {
                DataGridViewRow row = dgv.Rows[nRow];

                AR_Archer player = (AR_Archer)row.Tag;

                string strFieldName = "";
                object obj = null;

                strFieldName = "LongDistinceA";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[strFieldName].Value = obj.ToString();
                else
                    row.Cells[strFieldName].Value = "";
                player.TotalLongA = ARFunctions.ConvertToStringFromObject(obj);


                strFieldName = "LongDistinceB";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[strFieldName].Value = obj.ToString();
                else
                    row.Cells[strFieldName].Value = "";
                player.TotalLongB = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "ShortDistinceA";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[strFieldName].Value = obj.ToString();
                else
                    row.Cells[strFieldName].Value = "";
                player.TotalShortA = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "ShortDistinceB";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[strFieldName].Value = obj.ToString();
                else
                    row.Cells[strFieldName].Value = "";
                player.TotalShortB = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "10s";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[strFieldName].Value = obj.ToString();
                else
                    row.Cells[strFieldName].Value = "";
                player.Num10S = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Xs";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[strFieldName].Value = obj.ToString();
                else
                    row.Cells[strFieldName].Value = "";
                player.NumXS = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Total";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[strFieldName].Value = obj.ToString();
                else
                    row.Cells[strFieldName].Value = "";
                player.Total = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Rank";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[strFieldName].Value = obj.ToString();
                else
                    row.Cells[strFieldName].Value = "";
                player.QRank = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "IRM";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[strFieldName].Value = obj.ToString();
                else
                    row.Cells[strFieldName].Value = "";
                player.IRM = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_Records";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[strFieldName].Value = obj.ToString();
                else
                    row.Cells[strFieldName].Value = "";
                player.Records = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_Comment";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[strFieldName].Value = obj.ToString();
                else
                    row.Cells[strFieldName].Value = "";
                player.Comment = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_ShootOff";
                obj = dt.Rows[nRow][strFieldName];
                if (obj != DBNull.Value)
                    row.Cells[strFieldName].Value = obj.ToString();
                else
                    row.Cells[strFieldName].Value = "";
                player.ShootOff = ARFunctions.ConvertToStringFromObject(obj);

                row.Tag = player;
                players.Add(player);
            }

            dgv_List.Tag = players;
        }

        private AR_Archer GetCurrentPlayerFromDataGrid(int RowIndex)
        {
            AR_Archer player = new AR_Archer();
            try
            {
                if (dgv_List.Rows[RowIndex].Cells["F_CompetitionPosition"].Value != null)
                    player.CompetitionPosition = Convert.ToInt32(dgv_List.Rows[RowIndex].Cells["F_CompetitionPosition"].Value);
                if (dgv_List.Rows[RowIndex].Cells["Target"].Value != null)
                    player.Target = dgv_List.Rows[RowIndex].Cells["Target"].Value.ToString();
                if (dgv_List.Rows[RowIndex].Cells["Name"].Value != null)
                    player.Name = dgv_List.Rows[RowIndex].Cells["Name"].Value.ToString();
                if (dgv_List.Rows[RowIndex].Cells["NOC"].Value != null)
                    player.Name = dgv_List.Rows[RowIndex].Cells["NOC"].Value.ToString();
                if (dgv_List.Rows[RowIndex].Cells["LongDistinceA"].Value != null)
                    player.TotalLongA = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[RowIndex].Cells["LongDistinceA"].Value);
                if (dgv_List.Rows[RowIndex].Cells["LongDistinceB"].Value != null)
                    player.TotalLongB = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[RowIndex].Cells["LongDistinceB"].Value);
                if (dgv_List.Rows[RowIndex].Cells["ShortDistinceA"].Value != null)
                    player.TotalShortA = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[RowIndex].Cells["ShortDistinceA"].Value);
                if (dgv_List.Rows[RowIndex].Cells["ShortDistinceB"].Value != null)
                    player.TotalShortB = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[RowIndex].Cells["ShortDistinceB"].Value);
                if (dgv_List.Rows[RowIndex].Cells["10s"].Value != null)
                    player.Num10S = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[RowIndex].Cells["10s"].Value);
                if (dgv_List.Rows[RowIndex].Cells["Xs"].Value != null)
                    player.NumXS = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[RowIndex].Cells["Xs"].Value);
                if (dgv_List.Rows[RowIndex].Cells["Rank"].Value != null)
                    player.QRank = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[RowIndex].Cells["Rank"].Value);
                if (dgv_List.Rows[RowIndex].Cells["Total"].Value != null)
                    player.Total = ARFunctions.ConvertToStringFromObject(dgv_List.Rows[RowIndex].Cells["Total"].Value);
                if (dgv_List.Rows[RowIndex].Cells["IRM"].Value != null)
                    player.IRM = dgv_List.Rows[RowIndex].Cells["IRM"].Value.ToString();
                player.MatchID = m_nCurMatchID;

                return player;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return player;
            }
        }
        #endregion

        #region Ex2
        public class ComparerEx : IComparer
        {
            public ComparerEx() { }

            int IComparer.Compare(object obj1, object obj2)
            {
                AR_Archer objEx1 = (AR_Archer)obj1;
                AR_Archer objEx2 = (AR_Archer)obj2;

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
                            if (objEx1.ShootOff != objEx2.ShootOff)
                            {
                                int numSO_1 = ARFunctions.ConvertToIntFromString(objEx1.ShootOff);
                                int numSO_2 = ARFunctions.ConvertToIntFromString(objEx2.ShootOff);
                                if (numSO_1 < numSO_2)
                                    return 1;
                                else return -1;
                            }
                            else return 0;
                        }

                    }
                }
            }

            public static IComparer Sort()
            { return (IComparer)new ComparerEx(); }
        }

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
                        if (objEx1.ShootOff != objEx2.ShootOff)
                        {
                            int numSO_1 = ARFunctions.ConvertToIntFromString(objEx1.ShootOff);
                            int numSO_2 = ARFunctions.ConvertToIntFromString(objEx2.ShootOff);
                            if (numSO_1 < numSO_2)
                                return 1;
                            else return -1;
                        }
                        else return 0;
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

        public int GetArrowCode(string strArrow)
        {
            int nArrow = -1;
            if (strArrow.Length > 0)
            {
                if (strArrow.Length == 1)
                    nArrow = int.Parse(strArrow);
                else if (strArrow.Length == 2)
                {
                    if (strArrow == "10")
                        nArrow = 10;
                    else if (strArrow.Substring(1, 1) == "*")
                        nArrow = 100 + int.Parse(strArrow.Substring(0, 1));//?*
                    else if (strArrow.Substring(1, 1) == "x" || strArrow.Substring(1, 1) == "X")
                        nArrow = 200 + int.Parse(strArrow.Substring(0, 1));//?x ro ?X
                }
                else if (strArrow.Length == 3)
                    nArrow = 210;//10x or 10X
            }
            return nArrow;
        }

        public void UpdateRank()
        {
            List<AR_Archer> archers = new List<AR_Archer>();

            foreach (DataGridViewRow row in this.dgv_List.Rows)
            {
                AR_Archer ArcherEx = (AR_Archer)row.Tag;
                archers.Add(ArcherEx);
            }
            archers.Sort(ArchersCompare);
            ComputeResult(archers);

            foreach (AR_Archer player in archers)
            {
                //bool bTempReturn = GVAR.g_ManageDB.UpdateMatchResult(m_nCurMatchID, AA.RegisterID,
                //    -1, -1, "-1", "-1", "-1", AA.QRank.ToString(), AA.DisplayPosition.ToString(), "-1");
                bool bTempReturn = GVAR.g_ManageDB.UpdateQualificationMatchResult(m_nCurMatchID, player, 0);
                if (bTempReturn)
                {
                    this.dgv_List.Rows[player.RowIndex].Cells["Rank"].Value = player.QRank;
                    GVAR.g_ManageDB.UpdateQualificationPhaseResult(m_nCurMatchID, player);
                    GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                }
            }
        }

        private void SettingControlsStatus(AR_MatchInfo curMatchInfo)
        {
            this.CurMatchInfo = curMatchInfo;
            if (CurMatchInfo.MatchStatusID <= 40 || CurMatchInfo.MatchStatusID >= 100)
            {
                foreach (DataGridViewColumn col in dgv_List.Columns)
                {
                    col.ReadOnly = true; ;
                }
            }
            else
            {
                foreach (DataGridViewColumn col in dgv_List.Columns)
                {
                    switch (col.Name)
                    {
                        case "Target":
                            col.ReadOnly = false;
                            break;
                        case "LongDistinceA":
                            col.ReadOnly = false;
                            break;
                        case "LongDistinceB":
                            col.ReadOnly = false;
                            break;
                        case "ShortDistinceA":
                            col.ReadOnly = false;
                            break;
                        case "ShortDistinceB":
                            col.ReadOnly = false;
                            break;
                        case "10s":
                            col.ReadOnly = false;
                            break;
                        case "Xs":
                            col.ReadOnly = false;
                            break;
                        case "Total":
                            col.ReadOnly = false;
                            break;
                        default: col.ReadOnly = true;
                            break;

                    }
                }
            }
        }

        private int DataExchangeRecord(DataGridViewCell cell)
        {
            System.Data.DataTable dt = this.dt_Records;
            AR_Archer player = (AR_Archer)cell.OwningRow.Tag;
            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                if (cell.Value != null)
                {
                    if (cell.Value.ToString() == "")
                        return -1;
                    //总成绩
                    int nOldRecord = 9999;
                    string strOldRecord = "";
                    int nRecordRegisterID = 0;
                    string nRecordID = string.Empty;

                    string subcode = cell.OwningColumn.Tag.ToString();

                    #region 各种记录
                    switch (subcode)
                    {
                        case "0":
                            if (dt.Rows[nRow]["TotalRecord"] != DBNull.Value)
                                strOldRecord = dt.Rows[nRow]["TotalRecord"].ToString();
                            if (strOldRecord.Length != 0)
                                nOldRecord = int.Parse(strOldRecord);
                            if (dt.Rows[nRow]["TotalRegisterID"] != DBNull.Value)
                                nRecordRegisterID = int.Parse(dt.Rows[nRow]["TotalRegisterID"].ToString());
                            if (dt.Rows[nRow]["TotalRecordID"] != DBNull.Value)
                                nRecordID = dt.Rows[nRow]["TotalRecordID"].ToString();
                            break;
                        case "1":
                            if (dt.Rows[nRow]["LongReocrdA"] != DBNull.Value)
                                strOldRecord = dt.Rows[nRow]["LongReocrdA"].ToString();
                            if (strOldRecord.Length != 0)
                                nOldRecord = int.Parse(strOldRecord);
                            if (dt.Rows[nRow]["LongARegisterID"] != DBNull.Value)
                                nRecordRegisterID = int.Parse(dt.Rows[nRow]["LongARegisterID"].ToString());
                            if (dt.Rows[nRow]["LongAReocrdID"] != DBNull.Value)
                                nRecordID = dt.Rows[nRow]["LongAReocrdID"].ToString();
                            break;
                        case "2":
                            if (dt.Rows[nRow]["LongReocrdB"] != DBNull.Value)
                                strOldRecord = dt.Rows[nRow]["LongReocrdB"].ToString();
                            if (strOldRecord.Length != 0)
                                nOldRecord = int.Parse(strOldRecord);
                            if (dt.Rows[nRow]["LongBRegisterID"] != DBNull.Value)
                                nRecordRegisterID = int.Parse(dt.Rows[nRow]["LongBRegisterID"].ToString());
                            if (dt.Rows[nRow]["LongBReocrdID"] != DBNull.Value)
                                nRecordID = dt.Rows[nRow]["LongBReocrdID"].ToString();
                            break;
                        case "3":
                            if (dt.Rows[nRow]["ShortReocrdA"] != DBNull.Value)
                                strOldRecord = dt.Rows[nRow]["ShortReocrdA"].ToString();
                            if (strOldRecord.Length != 0)
                                nOldRecord = int.Parse(strOldRecord);
                            if (dt.Rows[nRow]["ShortARegisterID"] != DBNull.Value)
                                nRecordRegisterID = int.Parse(dt.Rows[nRow]["ShortARegisterID"].ToString());
                            if (dt.Rows[nRow]["ShortAReocrdID"] != DBNull.Value)
                                nRecordID = dt.Rows[nRow]["ShortAReocrdID"].ToString();
                            break;
                        case "4":
                            if (dt.Rows[nRow]["ShortReocrdB"] != DBNull.Value)
                                strOldRecord = dt.Rows[nRow]["ShortReocrdB"].ToString();
                            if (strOldRecord.Length != 0)
                                nOldRecord = int.Parse(strOldRecord);
                            if (dt.Rows[nRow]["ShortBRegisterID"] != DBNull.Value)
                                nRecordRegisterID = int.Parse(dt.Rows[nRow]["ShortBRegisterID"].ToString());
                            if (dt.Rows[nRow]["ShortBReocrdID"] != DBNull.Value)
                                nRecordID = dt.Rows[nRow]["ShortBReocrdID"].ToString();
                            break;
                    }
                    #endregion

                    int RecordTypeID = 0;
                    if (dt.Rows[nRow]["RecordTypeID"] != DBNull.Value)
                        RecordTypeID = int.Parse(dt.Rows[nRow]["RecordTypeID"].ToString());
                    string RecordTypeCode = string.Empty;
                    if (dt.Rows[nRow]["Record"] != DBNull.Value)
                        RecordTypeCode = dt.Rows[nRow]["Record"].ToString();

                    if (Convert.ToInt32(cell.Value) >= nOldRecord && nOldRecord != 9999)
                    {
                        //更新数据库
                        int isEquals = int.Equals(Convert.ToInt32(cell.Value), nOldRecord) ? 1 : 0;
                        if ((player.RegisterID != nRecordRegisterID && isEquals != 0) || isEquals == 0)
                        {
                            bool bReturn = GVAR.g_ManageDB.UpdateRecord(m_nCurMatchID, player.CompetitionPosition,
                               subcode, cell.Value.ToString(), RecordTypeID, isEquals);
                            if (bReturn)
                                GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                        }
                        if (isEquals == 0 || player.RegisterID == nRecordRegisterID)
                            dgv_List.Rows[cell.RowIndex].Cells["F_Records"].Value = RecordTypeCode;
                        else
                            dgv_List.Rows[cell.RowIndex].Cells["F_Records"].Value = "E" + RecordTypeCode;
                    }
                    else if (Convert.ToInt32(cell.Value) < nOldRecord && nOldRecord != 9999)
                    {
                        dgv_List.Rows[cell.RowIndex].Cells["F_Records"].Value = "";
                        if (player.RegisterID == nRecordRegisterID)
                        {
                            int nReturn = GVAR.g_ManageDB.DeleteMatchRecord(nRecordID, cell.Value.ToString());
                            if (nReturn > 1)
                            {
                                dgv_List.Rows[cell.RowIndex].Cells["F_Records"].Value = RecordTypeCode;
                            }
                            else if (nReturn == 1)
                            {
                                dgv_List.Rows[cell.RowIndex].Cells["F_Records"].Value = "E" + RecordTypeCode;
                            }
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
