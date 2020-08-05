using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using System.Diagnostics;


namespace AutoSports.OVRVBPlugin
{
    public partial class frmOVRVODataEntry : DevComponents.DotNetBar.Office2007Form
    {
		private System.Windows.Forms.Timer m_timerDbRefresh;

        public frmOVRVODataEntry()
        {
			InitializeComponent();
        }

		private void frmOVRVODataEntry_Load(object sender, EventArgs e)
		{
			//For something, we don't display in BV
			btnStatEntryPlayer_Pos3.Visible = Common.g_isVB;
			btnStatEntryPlayer_Pos4.Visible = Common.g_isVB;
			btnStatEntryPlayer_Pos5.Visible = Common.g_isVB;
			btnStatEntryPlayer_Pos6.Visible = Common.g_isVB;
			btnStatEntryPlayer_Pos7.Visible = Common.g_isVB;
			btnStatEntryPlayer_Pos8.Visible = Common.g_isVB;
			btnStatEntryPlayerIn.Visible = Common.g_isVB;
			btnStatEntryPlayerChange.Visible = Common.g_isVB;
			_btnSubAAdd.Visible = Common.g_isVB;
			_btnSubBAdd.Visible = Common.g_isVB;
			_btnSubAReduce.Visible = Common.g_isVB;
			_btnSubBReduce.Visible = Common.g_isVB;
			_labSubitiutionA.Visible = Common.g_isVB;
			_labSubitiutionB.Visible = Common.g_isVB;
			_labSubSmallA.Visible = Common.g_isVB;
			_labSubSmallB.Visible = Common.g_isVB;
			_labSubA.Visible = Common.g_isVB;
			_labSubB.Visible = Common.g_isVB;

			btnStatEntryPlayer_Pos1.Text = "";
			btnStatEntryPlayer_Pos2.Text = "";
			btnStatEntryPlayer_Pos3.Text = "";
			btnStatEntryPlayer_Pos4.Text = "";
			btnStatEntryPlayer_Pos5.Text = "";
			btnStatEntryPlayer_Pos6.Text = "";
			btnStatEntryPlayer_Pos7.Text = "";
			btnStatEntryPlayer_Pos8.Text = "";

			OVRDataBaseUtils.SetDataGridViewStyle(dgvMatchScore);
			OVRDataBaseUtils.SetDataGridViewStyle(dgvStatItem);
			OVRDataBaseUtils.SetDataGridViewStyle(dgvActionList);
			OVRDataBaseUtils.SetDataGridViewStyle(dgvPlayerListA);
			OVRDataBaseUtils.SetDataGridViewStyle(dgvPlayerListB);
			OVRDataBaseUtils.SetDataGridViewStyle(dgvStatEntryPlayerAll);

			_splitMain.SplitterDistance = 175;

			dgvStatItemInit();
			dgvMatchScoreInit();
			dgvActionListInit();
			dgvPlayerList_Init(true);
			dgvPlayerList_Init(false);

			dgvStatEntryPlayersAllInit();

			this.Enabled = false;

			m_timerDbRefresh = new System.Windows.Forms.Timer();
			m_timerDbRefresh.Interval = 1000;
			m_timerDbRefresh.Tick += this.timerDbRefresh_Tick;

			cPropertyGridClass pGridClass = new cPropertyGridClass();
			propertyGridSetup.SelectedObject = pGridClass;
		}

		//从数据库刷新界面
		//未从新刷新队员等信息,所以只能用于中途刷新
		private bool scoreInfoRefresh()
		{
			//获取比分
			GameGeneralBall gameObj = new GameGeneralBall();
			if (Common.dbGetMatch2GameObj(Common.g_nMatchID, ref gameObj))
			{
				//将比分对象覆盖当前的
				Common.g_Game = gameObj;

				//刷新比分
				dgvMatchScoreRefresh();
			}
			else
			{
				Debug.Assert(false);
			}

			return true;
		}

		protected override bool ProcessDialogKey(Keys keyData)
		{
			/*
			switch (keyData)
			{

				case Keys.D1:
					dgvPlayerList.CurrentCell = dgvPlayerList[0, 0];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(0, 0));
					break;

				case Keys.D2:
					dgvPlayerList.CurrentCell = dgvPlayerList[1, 0];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(0, 0));
					break;

				case Keys.D3:
					dgvPlayerList.CurrentCell = dgvPlayerList[2, 0];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(2, 0));
					break;

				case Keys.D4:
					dgvPlayerList.CurrentCell = dgvPlayerList[3, 0];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(3, 0));
					break;

				case Keys.D5:
					dgvPlayerList.CurrentCell = dgvPlayerList[4, 0];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(4, 0));
					break;

				case Keys.D6:
					dgvPlayerList.CurrentCell = dgvPlayerList[5, 0];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(5, 0));
					break;

				case Keys.D7:
					dgvPlayerList.CurrentCell = dgvPlayerList[6, 0];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(6, 0));
					break;

				case Keys.D8:
					dgvPlayerList.CurrentCell = dgvPlayerList[7, 0];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(7, 0));
					break;

				case Keys.D9:
					dgvPlayerList.CurrentCell = dgvPlayerList[8, 0];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(8, 0));
					break;

				case Keys.D0:
					dgvPlayerList.CurrentCell = dgvPlayerList[9, 0];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(9, 0));
					break;

				case Keys.OemMinus:
					dgvPlayerList.CurrentCell = dgvPlayerList[10, 0];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(10, 0));
					break;

				case Keys.Oemplus:
					dgvPlayerList.CurrentCell = dgvPlayerList[11, 0];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(11, 0));
					break;


				case Keys.Q:		
					dgvPlayerList.CurrentCell = dgvPlayerList[0,1];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(0,1) );
					break;

				case Keys.W:
					dgvPlayerList.CurrentCell = dgvPlayerList[1,1];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(1,1) );
					break;

				case Keys.E:
					dgvPlayerList.CurrentCell = dgvPlayerList[2,1];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(2,1) );
					break;

				case Keys.R:
					dgvPlayerList.CurrentCell = dgvPlayerList[3, 1];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(3, 1));
					break;

				case Keys.T:
					dgvPlayerList.CurrentCell = dgvPlayerList[4, 1];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(4, 1));
					break;

				case Keys.Y:
					dgvPlayerList.CurrentCell = dgvPlayerList[5, 1];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(5, 1));
					break;

				case Keys.U:
					dgvPlayerList.CurrentCell = dgvPlayerList[6, 1];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(6, 1));
					break;

				case Keys.I:
					dgvPlayerList.CurrentCell = dgvPlayerList[7, 1];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(7, 1));
					break;

				case Keys.O:
					dgvPlayerList.CurrentCell = dgvPlayerList[8, 1];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(8, 1));
					break;

				case Keys.P:
					dgvPlayerList.CurrentCell = dgvPlayerList[9, 1];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(9, 1));
					break;

				case Keys.OemOpenBrackets:
					dgvPlayerList.CurrentCell = dgvPlayerList[10, 1];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(10, 1));
					break;

				case Keys.Oem6:
					dgvPlayerList.CurrentCell = dgvPlayerList[11, 1];
					dgvPlayerList_CellClick(dgvPlayerList, new DataGridViewCellEventArgs(11, 1));
					break;

				default:
					break;
			}
			 */

			//如果正在编辑比分,时间,则不作为快捷键输入


		//	if (dgvMatchScore.IsCurrentCellInEditMode)
			{
				return base.ProcessDialogKey(keyData);
			}

			//MessageBox.Show(keyData.ToString());
			//return true;
		}
		
        public void OnMatchChanged(Int32 iWndMode)
        {
			dgvStatItemRefersh();

			btnsStatAutoRefresh.Checked = true;
			btnsStatSet1.Checked = false;
			btnsStatSet2.Checked = false;
			btnsStatSet3.Checked = false;
			btnsStatSet4.Checked = false;
			btnsStatSet5.Checked = false;
			btnStatWorkType.Text = "Auto refresh";
			btnStatWorkType.ForeColor = Color.Blue;

			DataTable tbl = Common.dbGetMatchInfo(Common.g_nMatchID, Common.g_strLanguage);
			if (tbl != null)
			{
				//比分模块中的NOC
				dgvMatchScore[0, 1].Value = tbl.Rows[0]["F_TeamANameL"].ToString();
				dgvMatchScore[0, 2].Value = tbl.Rows[0]["F_TeamBNameL"].ToString();

				labNocA.Text = tbl.Rows[0]["F_TeamANameL"].ToString();
				labNocB.Text = tbl.Rows[0]["F_TeamBNameL"].ToString();

				_tabHeaderTeamA.Text = "STAT-" + tbl.Rows[0]["F_TeamANameL"].ToString();
				_tabHeaderTeamB.Text = "STAT-" + tbl.Rows[0]["F_TeamBNameL"].ToString();
				labMatchInfo.Text = "PlugIn:" + (Common.g_isVB ? "VB" : "BV") +
									tbl.Rows[0]["F_MatchDesc"];									

				//比分模块中的IRM
//				dgvMatchScore[1, 1].Value = tbl.Rows[0]["F_IRMCodeA"].ToString();
//				dgvMatchScore[1, 2].Value = tbl.Rows[0]["F_IRMCodeB"].ToString();
			}
			else
			{
				dgvMatchScore[0, 1].Value = "";
				dgvMatchScore[0, 2].Value = "";
			}

			btnMainRefresh_Click(null, null);
			btnMainSendMessage_Click(null, null);

			this.Enabled = true;
			m_timerDbRefresh.Enabled = true;

            return;
        }

		private bool dgvStatItemInit()
		{
			//初始化列表框
			dgvStatItem.ReadOnly = true;
			dgvStatItem.RowHeadersVisible = false;
			dgvStatItem.SelectionMode = DataGridViewSelectionMode.CellSelect;

			FontFamily fontFamily = new FontFamily("Arial");
			FontStyle fontStyle = new FontStyle();
			Font gridFont = new Font(fontFamily, 10, fontStyle);
			dgvStatItem.Font = gridFont;

			dgvStatItem.MultiSelect = false;
			dgvStatItem.AllowUserToResizeRows = false;
			dgvStatItem.AllowUserToOrderColumns = false;
			dgvStatItem.AllowUserToResizeColumns = false;
			dgvStatItem.AllowDrop = false;
			dgvStatItem.AllowUserToAddRows = false;
			dgvStatItem.AllowUserToDeleteRows = false;
			dgvStatItem.ColumnHeadersVisible = false;

			dgvStatItem.Rows.Clear();
			dgvStatItem.Columns.Clear();

			dgvStatItem.Columns.Add("1", "1");
			dgvStatItem.Columns.Add("2", "2");
			dgvStatItem.Columns.Add("3", "3");

			dgvStatItem.Columns[0].Width = 75;
			dgvStatItem.Columns[1].Width = 75;
			dgvStatItem.Columns[2].Width = 75;

			return true;
		}

		private bool dgvStatItemRefersh()
        {
			dgvStatItem.Rows.Clear();

			//获取数据
			String strSql = String.Format("select * from TD_ActionType where F_DisciplineID = {0} order by F_Order", Common.g_nDiscID);
			DataTable dataTbl = Common.dbGetTableRecord(strSql);
			if (dataTbl == null)
			{
				return false;
			}

			//填入数据
			for (int nRow = 0; nRow < dataTbl.Rows.Count; nRow++) //每行三个
			{
				Int32 nDgvRow = nRow/3;
				Int32 nDgvCol = nRow%3;

				if (nDgvCol == 0)
				{
					dgvStatItem.Rows.Add();
					dgvStatItem.Rows[nDgvRow].Height = 18;
				}

				dgvStatItem[nDgvCol, nDgvRow].Tag =   dataTbl.Rows[nRow]["F_ActionCode"].ToString();	
				dgvStatItem[nDgvCol, nDgvRow].Value = dataTbl.Rows[nRow]["F_ActionCode"].ToString();	
			}

			return true;
        }

		/// <summary>
		/// 控制当前界面是否允许操作
		/// </summary>
		/// <param name="bRunning">是否在Running状态</param>
		/// <param name="bStartlist">是否在Startlist状态</param>
		/// <param name="bStat">是否在Stat状态</param>
		public void SetMatchOperateEnable(bool bRunning, bool bStartlist, bool bStat)
		{
			bool bScore = bRunning && !bStat;
			bStat = (bRunning || bStartlist) && bStat;

			if (_tabMain.SelectedTab == _tabHeaderScore)
			{
				_tabWork.Enabled = bScore;
			}
			else
			{
				_tabWork.Enabled = bStat;
			}

			dgvMatchScore.Enabled = bScore;
			btnScoreAddA.Enabled = bScore;
			btnScoreAddB.Enabled = bScore;
			btnScoreReduceA.Enabled = bScore;
			btnScoreReduceB.Enabled = bScore;

			_btnTimeAAdd.Enabled = bScore;
			_btnTimeBAdd.Enabled = bScore;
			_btnTimeAReduce.Enabled = bScore;
			_btnTimeBReduce.Enabled = bScore;
			_btnSubAAdd.Enabled = bScore;
			_btnSubBAdd.Enabled = bScore;
			_btnSubAReduce.Enabled = bScore;
			_btnSubBReduce.Enabled = bScore;
			_chkScoreExchangeLR.Enabled = bScore;

			_chkScoreFromStat.Enabled = bStat;
			dgvStatItem.Enabled = bStat;
			dgvPlayerListA.Enabled = bStat;
			dgvPlayerListB.Enabled = bStat;
		}

        public void QueryReportContext(OVRReportContextQueryArgs args)
        {
			if (args == null)
			{
				return;
			}

            switch (args.Name)
            {
                case "MatchID":
                    {
                        //args.Value = m_nCurMatchID.ToString();
                        args.Handled = true;
                    }
                    break;
                default:
                    break;
            }
        }

		private void BtnScoreAddReduce_Click(object sender, EventArgs e)
		{
			bool exchangeAB = _chkScoreExchangeLR.Checked;

			if (sender == btnScoreAddA)
			{
				Common.g_Game.SetScoreAR(exchangeAB ? true : false, true);
			}
			else
			if (sender == btnScoreAddB)
			{
				Common.g_Game.SetScoreAR(exchangeAB ? false : true, true);
			}
			else
			if (sender == btnScoreReduceA)
			{
				Common.g_Game.SetScoreAR(exchangeAB ? true : false, false);
			}
			else
			if (sender == btnScoreReduceB)
			{
				Common.g_Game.SetScoreAR(exchangeAB ? false : true, false);
			}
			else
			{
				Debug.Assert(false);
				return;
			}

			Common.dbGameObj2Db(Common.g_nMatchID, Common.g_Game);
			RefreshAll();

			Common.NotifyMatchResult();
			Common.dbMatchModifyTimeSet();
		}

		private void dgvStatItem_CellClick(object sender, DataGridViewCellEventArgs e)
		{
			if ( dgvStatItem.CurrentCell == null || dgvStatItem.CurrentCell.Tag == null)
			{
				Debug.Assert(false);
				return;
			}

			String strStatCode = dgvStatItem.CurrentCell.Tag.ToString();
			String strStat = dgvStatItem.CurrentCell.Value.ToString();
			
			//如果队员已选,就添加STAT
			if (labStatTeam.Tag == null || labStatPlayer.Tag == null || strStatCode.Length <= 0)
			{
				return;
			}
				
			int nCurSet = GetStatCurSet();
			bool bIsTeamA = (bool)labStatTeam.Tag;
			int nRegisterID = Common.Str2Int(labStatPlayer.Tag);

			Debug.Assert(nRegisterID > 0);

			//判断是插入还是添加,如果是插入,就处理一下nBeforeActionID
			int nBeforeActionID = 0;
			if (btnStatInsert.Tag != null && _curSelActionNum > 0 )
			{
				if (bIsTeamA != _curSelIsTeamA)
				{
					MessageBox.Show("只能插入被选中队伍的技术统计!");
					return;
				}

				nBeforeActionID = _curSelActionNum;
			}

			if (strStat == "OPP_ERR" || strStat == "TEM_FLT")
				Common.dbActionListAdd(Common.g_nMatchID, nCurSet, strStatCode, -1, nBeforeActionID, !bIsTeamA);
			else
				Common.dbActionListAdd(Common.g_nMatchID, nCurSet, strStatCode, nRegisterID, nBeforeActionID, !bIsTeamA);

			labStatPlayer.Text = "";
			labStatPlayer.Tag = null;
			labStatTeam.Text = "";
			labStatTeam.Tag = null;
			dgvStatItem.CurrentCell = null;

			OnStatChanged(!bIsTeamA);
		}

		private void btnEditTeam_Click(object sender, EventArgs e)
		{
			frmTeamMemberEntry dlg = new frmTeamMemberEntry(Common.g_nMatchID, Common.g_strLanguage);
			dlg.ShowDialog();
			
			RefreshAll();
		}

		//主界面上的人员列表
		private void dgvPlayerList_Init(bool bTeamA)
		{
			DataGridView dgvPlayerList = bTeamA ? dgvPlayerListA : dgvPlayerListB;

			dgvPlayerList.ReadOnly = true;
			dgvPlayerList.RowHeadersVisible = false;
			dgvPlayerList.SelectionMode = DataGridViewSelectionMode.CellSelect;

			FontFamily fontFamily = new FontFamily("Arial");
			FontStyle fontStyle = new FontStyle();
			fontStyle = FontStyle.Bold;
			Font gridFont = new Font(fontFamily, 12, fontStyle);
			dgvPlayerList.Font = gridFont;

			dgvPlayerList.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
			dgvPlayerList.MultiSelect = false;
			dgvPlayerList.AllowUserToResizeRows = false;
			dgvPlayerList.AllowUserToOrderColumns = false;
			dgvPlayerList.AllowUserToResizeColumns = false;
			dgvPlayerList.AllowDrop = false;
			dgvPlayerList.AllowUserToAddRows = false;
			dgvPlayerList.AllowUserToDeleteRows = false;
			dgvPlayerList.ColumnHeadersVisible = false;

			dgvPlayerList.Rows.Clear();
			dgvPlayerList.Columns.Clear();
		}

		private bool dgvPlayerList_Refresh(bool bTeamA)
		{
			DataGridView dgvPlayerList = bTeamA ? dgvPlayerListA : dgvPlayerListB;

			dgvPlayerList.Rows.Clear();
			dgvPlayerList.Columns.Clear();

			//2行7列

			int nColumns = 7;

			for (int nCol = 0; nCol < nColumns; nCol++)
			{
				dgvPlayerList.Columns.Add(nCol.ToString(), nCol.ToString());
				dgvPlayerList.Columns[nCol].Width = 32;
			}

			dgvPlayerList.Rows.Add();
			dgvPlayerList.Rows.Add();
			dgvPlayerList.Rows[0].Height = 25;
			dgvPlayerList.Rows[1].Height = 25;

			//Fill Data
			DataTable tblPlayer = Common.dbGetMatchStartList(bTeamA, GetStatCurSet());
			if (tblPlayer == null)
			{
				Debug.Assert(false);
				return false;
			}

			for (int nCol = 0; nCol < nColumns; nCol++)
			{
				if (tblPlayer.Rows.Count > nCol) //插第一行

				{
					dgvPlayerList[nCol, 0].Tag = tblPlayer.Rows[nCol];
					dgvPlayerList[nCol, 0].Value = tblPlayer.Rows[nCol]["F_ShirtNumber"].ToString();
					dgvPlayerList[nCol, 0].ToolTipText = tblPlayer.Rows[nCol]["F_NameS"].ToString();
				}

				if (tblPlayer.Rows.Count > nCol + nColumns) //插第二行
				{
					dgvPlayerList[nCol, 1].Tag = tblPlayer.Rows[nCol + nColumns];
					dgvPlayerList[nCol, 1].Value = tblPlayer.Rows[nCol + nColumns]["F_ShirtNumber"].ToString();
					dgvPlayerList[nCol, 1].ToolTipText = tblPlayer.Rows[nCol + nColumns]["F_NameS"].ToString();
				}
			}

			dgvPlayerList.CurrentCell = null;

			return true;
		}

		/// <summary>
		/// 点击队员完成后,把队员AB方放入labStatTeam.Tag, 把队员RegID放入labStatPlayer.Tag
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void dgvPlayerList_CellClick(object sender, DataGridViewCellEventArgs e)
		{
			if (((DataGridView)sender).CurrentCell == null)
			{
				Debug.Assert(false);
				return;
			}

			DataRow cellCur = (DataRow)((DataGridView)sender).CurrentCell.Tag;
			if (cellCur == null)
				return;

			Int32 nRegID = Common.Str2Int(cellCur["F_RegisterID"]);
			String strName = cellCur["F_NameS"].ToString();
			String strBib = cellCur["F_ShirtNumber"].ToString();
			if (nRegID <= 0)
				return;

			bool bIsTeamA = ( sender == dgvPlayerListA ) ? true : false;

			labStatTeam.Tag = bIsTeamA;
			labStatTeam.Text = bIsTeamA ? Common.g_strNocA : Common.g_strNocB;
			labStatPlayer.Text = strBib + " " + strName;
			labStatPlayer.Tag = nRegID;

			if (bIsTeamA)
				dgvPlayerListB.CurrentCell = null;
			else
				dgvPlayerListA.CurrentCell = null;
		}

		private void btnx_MatchStatus_Click(object sender, EventArgs e)
		{
			int nStatusID = 0;

			if (sender == btnx_Schedule)
			{
				nStatusID = Common.STATUS_SCHEDULE;
			}
			else if (sender == btnx_StartList)
			{
				nStatusID = Common.STATUS_STARTLIST;
			}
			else if (sender == btnx_Running)
			{
				nStatusID = Common.STATUS_RUNNING;
			}
			else if (sender == btnx_Suspend)
			{
				nStatusID = Common.STATUS_SUSPEND;
			}
			else if (sender == btnx_Unofficial)
			{
				nStatusID = Common.STATUS_UNOFFICIAL;
			}
			else if (sender == btnx_Official)
			{
				nStatusID = Common.STATUS_OFFICIAL;
			}
			else if (sender == btnx_Revision)
			{
				nStatusID = Common.STATUS_REVISION;
			}
			else if (sender == btnx_Canceled)
			{
				nStatusID = Common.STATUS_CANCELED;
			}
			else
			{
				return;
			}

			Int32 nResult = OVRDataBaseUtils.ChangeMatchStatus(
				Common.g_nMatchID, nStatusID, Common.g_DataBaseCon, Common.g_Plugin);

			//晋级比赛
			if (sender == btnx_Official)
			{
				//淘汰赛晋级	
				OVRDataBaseUtils.AutoProgressMatch(Common.g_nMatchID, Common.g_DataBaseCon, Common.g_Plugin);

				//小组赛计分计算				
				Common.dbCalGroupResult(Common.g_nMatchID);
			}

			Common.dbMatchModifyTimeSet();
			RefreshAll();
		}

		private void UpdateMatchStatus()
		{
			btnx_Schedule.Checked = false;
			btnx_StartList.Checked = false;
			btnx_Running.Checked = false;
			btnx_Suspend.Checked = false;
			btnx_Unofficial.Checked = false;
			btnx_Official.Checked = false;
			btnx_Revision.Checked = false;
			btnx_Canceled.Checked = false;

			btnx_Schedule.Enabled = false;
			btnx_StartList.Enabled = false;
			btnx_Running.Enabled = false;
			btnx_Suspend.Enabled = false;
			btnx_Unofficial.Enabled = false;
			btnx_Official.Enabled = false;
			btnx_Revision.Enabled = false;

			int nStautusID = Common.dbGetMatchStatusID();

			switch (nStautusID)
			{
				case Common.STATUS_SCHEDULE:
					{
						btnx_StartList.Enabled = true;
						btnx_Revision.Enabled = true;
						btnx_Schedule.Checked = true;
						btnx_MatchStatus.Text = btnx_Schedule.Text;
						btnx_MatchStatus.ForeColor = System.Drawing.SystemColors.ControlText;
						break;
					}
				case Common.STATUS_STARTLIST:
					{
						btnx_Running.Enabled = true;
						btnx_StartList.Checked = true;
						btnx_MatchStatus.Text = btnx_StartList.Text;
						btnx_MatchStatus.ForeColor = System.Drawing.SystemColors.ControlText;
						break;
					}
				case Common.STATUS_RUNNING:
					{
						btnx_Suspend.Enabled = true;
						btnx_Unofficial.Enabled = true;
						btnx_Running.Checked = true;
						btnx_MatchStatus.Text = btnx_Running.Text;
						btnx_MatchStatus.ForeColor = System.Drawing.Color.Red;
						break;
					}
				case Common.STATUS_SUSPEND:
					{
						btnx_Running.Enabled = true;
						btnx_Suspend.Checked = true;
						btnx_MatchStatus.Text = btnx_Suspend.Text;
						btnx_MatchStatus.ForeColor = System.Drawing.Color.Red;
						break;
					}
				case Common.STATUS_UNOFFICIAL:
					{
						btnx_Official.Enabled = true;
						btnx_Revision.Enabled = true;
						btnx_Unofficial.Checked = true;
						btnx_MatchStatus.Text = btnx_Unofficial.Text;
						btnx_MatchStatus.ForeColor = System.Drawing.Color.LimeGreen;
						break;
					}
				case Common.STATUS_OFFICIAL:
					{
						btnx_Revision.Enabled = true;
						btnx_Official.Checked = true;
						btnx_MatchStatus.Text = btnx_Official.Text;
						btnx_MatchStatus.ForeColor = System.Drawing.Color.LimeGreen;
						break;
					}
				case Common.STATUS_REVISION:
					{
						btnx_Official.Enabled = true;
						btnx_Revision.Checked = true;
						btnx_MatchStatus.Text = btnx_Revision.Text;
						btnx_MatchStatus.ForeColor = System.Drawing.Color.LimeGreen;
						break;
					}
				case Common.STATUS_CANCELED:
					{
						btnx_Schedule.Enabled = true;
						btnx_Canceled.Checked = true;
						btnx_MatchStatus.Text = btnx_Canceled.Text;
						btnx_MatchStatus.ForeColor = System.Drawing.SystemColors.ControlText;
						break;
					}
			}
		}

		private void btnEditOfficial_Click(object sender, EventArgs e)
		{
			frmOfficialEntry dlg = new frmOfficialEntry(Common.g_nMatchID, Common.g_nDiscID, Common.g_strSectionName, Common.g_strLanguage);
			dlg.ShowDialog();
		}

		private void BtnStatInsert_Click(object sender, EventArgs e)
		{
			if (btnStatInsert.Tag == null)
			{
				btnStatInsert.BackColor = Color.Red;
				btnStatInsert.Tag = new object();
			}
			else
			{
				btnStatInsert.BackColor = Color.FromArgb(194, 217, 247);
				btnStatInsert.Tag = null;
			}
		}

		private void buttonExit_Click(object sender, EventArgs e)
		{
			m_timerDbRefresh.Enabled = false;
			this.Enabled = false;

			dgvStatItemInit();
			dgvMatchScoreInit();
			dgvActionListInit();
			dgvPlayerList_Init(true);
			dgvPlayerList_Init(false);
		}

		//Should be in ActionList
		private void dgvActionList_CellClick(object sender, DataGridViewCellEventArgs e)
		{
			//新的选中是否合法
			int nNewCol = e.ColumnIndex;
			int nNewRow = e.RowIndex;

			if (nNewCol < 0 || nNewCol >= dgvActionList.Columns.Count ||
				nNewRow < 0 || nNewRow >= dgvActionList.Rows.Count)
			{
				return;
			}

			dgvActionList.SuspendLayout();



			//去掉之前选择的颜色,如果有的话
			if (_curSelRow >= 0)
			{
				dgvActionListSetCurSelMarkColor(_curSelRow, _curSelIsTeamA, _curSelActionNum, false);
				
				//恢复成空值
				_curSelRow = -1;
				_curSelActionNum = 0;
				_curSelIsTeamA = true;
			}

			//开始设置新的选中
			if (nNewCol >= 0 && nNewCol <= 2) //点中的是TeamA内容
			{
				if (dgvActionList["CodeA", nNewRow].Tag != null) //点中的是Stat,不是空
				{
					int newActionNum = Common.Str2Int(dgvActionList["CodeA", nNewRow].Tag);

					if (dgvActionListSetCurSelMarkColor(nNewRow, true, newActionNum, true))
					{
						_curSelRow = nNewRow;
						_curSelIsTeamA = true;
						_curSelActionNum = newActionNum;
					}
				}
			}

			if (nNewCol >= 6 && nNewCol <= 8)
			{
				if (dgvActionList["CodeB", nNewRow].Tag != null) //点中的是Stat,不是空
				{
					int newActionNum = Common.Str2Int(dgvActionList["CodeB", nNewRow].Tag);

					if (dgvActionListSetCurSelMarkColor(nNewRow, false, newActionNum, true))
					{
						_curSelRow = nNewRow;
						_curSelIsTeamA = false;
						_curSelActionNum = newActionNum;
					}
				}
			}

			dgvActionList.ResumeLayout();

			int nRowFirstDisplayed = dgvActionList.FirstDisplayedScrollingRowIndex;
			int nRowDisplayed = dgvActionList.GetCellCount(DataGridViewElementStates.Displayed) / dgvActionList.Columns.GetColumnCount(DataGridViewElementStates.Displayed);
			int nRowLastDisplayed = nRowFirstDisplayed + nRowDisplayed;

			if (nNewRow < nRowFirstDisplayed)
				dgvActionList.FirstDisplayedScrollingRowIndex = nNewRow;

			if (nNewRow >= nRowLastDisplayed)
				dgvActionList.FirstDisplayedScrollingRowIndex = nNewRow - nRowDisplayed + 2;

			if (_curSelRow >= 0)
			{
				Debug.Assert(_curSelRow < dgvActionList.RowCount);
				Debug.Assert(Common.Str2Int(dgvActionList[_curSelIsTeamA ? "CodeA" : "CodeB", _curSelRow].Tag) == _curSelActionNum);
			}
		}

		private void dgvActionList_UserDeletingRow(object sender, DataGridViewRowCancelEventArgs e)
		{
			//此事件已经被特殊处理,不光是处理删除,还处理上下左右移动
			if (_curSelRow < 0)
			{
				return;
			}

			if (e == null || e.Row == null)
			{
				Debug.Assert(false);
				return;
			}

			//先获取当前选中行列
			if (_curSelRow < 0 || _curSelRow >= dgvActionList.Rows.Count || dgvActionList.Rows[_curSelRow].Tag == null)
			{
				Debug.Assert(false);
				return;
			}

			//判断是否为上下左右移动
			if (e.Row.Tag != null)
			{
				Keys pressKey = (Keys)e.Row.Tag;

				//想往左移动 当前在右边 左边有内容
				if (pressKey == Keys.Left && !_curSelIsTeamA && dgvActionList["CodeA", _curSelRow].Tag != null)
				{
					DataGridViewCellEventArgs ePos = new DataGridViewCellEventArgs(0, _curSelRow); //0:左边的CodaA, 6:右边的CodeB
					dgvActionList_CellClick(dgvActionList, ePos); //借用此函数实现选中
				}

				//想往右移动 当前在左边 右边有内容
				if (pressKey == Keys.Right && _curSelIsTeamA && dgvActionList["CodeB", _curSelRow].Tag != null)
				{
					DataGridViewCellEventArgs ePos = new DataGridViewCellEventArgs(6, _curSelRow);
					dgvActionList_CellClick(dgvActionList, ePos); //借用此函数实现选中
				}

				//想往上移动,就往上查找,直到找到有效位置,未找到就不移动
				if (pressKey == Keys.Up)
				{
					for (int nUpRow = _curSelRow - 1; nUpRow >= 0; nUpRow--)
					{
						Object objTag = dgvActionList[_curSelIsTeamA ? "CodeA" : "CodeB", nUpRow].Tag;
						if (objTag != null)
						{
							DataGridViewCellEventArgs ePos = new DataGridViewCellEventArgs(_curSelIsTeamA ? 0 : 6, nUpRow);
							dgvActionList_CellClick(dgvActionList, ePos);
							break;
						}
					}
				}

				//想往下移动,就往下查找,直到找到有效位置,未找到就不移动
				if (pressKey == Keys.Down)
				{
					for (int nDownRow = _curSelRow + 1; nDownRow < dgvActionList.Rows.Count; nDownRow++)
					{
						Object objTag = dgvActionList[_curSelIsTeamA ? "CodeA" : "CodeB", nDownRow].Tag;
						if (objTag != null)
						{
							DataGridViewCellEventArgs ePos = new DataGridViewCellEventArgs(_curSelIsTeamA ? 0 : 6, nDownRow);
							dgvActionList_CellClick(dgvActionList, ePos);
							break;
						}
					}
				}
			}
			else //删除
			{
				btnStatDelete_Click(dgvActionList, null);
			}
		}


		//int _nScore = 0;
		//bool _bDirPlus = true;

		//轮询数据库刷新用的
		private void timerDbRefresh_Tick(object sender, EventArgs e)
		{
			//避免在执行期间，时钟多重启动
			m_timerDbRefresh.Enabled = false;


			// Auto add Score for test.
			/*
			//////
			int nScore = Common.g_Game.GetScoreSet(false);
			Debug.Assert(nScore == _nScore);

			if (_bDirPlus && nScore == 25) _bDirPlus = false;
			if (!_bDirPlus && nScore == 0) _bDirPlus = true;

			if (_bDirPlus)
			{
				BtnScoreAddReduce_Click(btnScoreAddA, null);
				_nScore++;
			}
			else
			{
				BtnScoreAddReduce_Click(btnScoreReduceA, null);
				_nScore--;
			}

			Debug.Assert(Common.g_Game.GetScoreSet(false) == _nScore);
			////////
			*/
			
			string timeDbModify = Common.dbMatchModifyTimeGet();
			if (Common.m_TimeDbModify != timeDbModify)
			{
				Common.m_TimeDbModify = timeDbModify;

			
				UpdateMatchStatus();

				bool bRunning = (btnx_Running.Checked || btnx_Revision.Checked);
				bool bStartlist = btnx_StartList.Checked;
				bool bStat = _tabMain.SelectedTab == _tabHeaderStatDouble || _tabMain.SelectedTab == _tabHeaderTeamA || _tabMain.SelectedTab == _tabHeaderTeamB;
				SetMatchOperateEnable(bRunning, bStartlist, bStat);

				scoreInfoRefresh();
				timeoutSubtitutionRefresh();
				propertyGridSetup.Refresh();

				//做STAT的按钮们都没有点，全部刷新，如果点中过某些STAT，则只刷新列表

				if (btnStatEntryTemErr.Enabled == true)
				{
					statInfoReferesh();
				}
				else
				{
					DataSet dataAction = Common.dbActionListGetList(Common.g_nMatchID, GetStatCurSet());
					DataTable tblActionList = dataAction != null && dataAction.Tables.Count > 0 ? dataAction.Tables[0] : null;
					dgvActionListRefresh(tblActionList);
				}
			}
			
			m_timerDbRefresh.Enabled = true;
		}

		private void btnMainSendMessage_Click(object sender, EventArgs e)
		{
			Common.NotifyMatchResult();
			Common.NotifyMatchStatus();

			//2013-02-24	好像没啥用，先不发了
			//Common.g_Plugin.DataChangedNotify(OVRDataChangedType.emSplitCompetitorMember, -1, -1, -1, Common.g_nMatchID, Common.g_nMatchID, null);
			//Common.g_Plugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, Common.g_nMatchID, Common.g_nMatchID, null);
		}

		private void btnMainRefresh_Click(object sender, EventArgs e)
		{
			RefreshAll();
		}

		private void RefreshAll()
		{
			UpdateMatchStatus();

			bool bRunning = (btnx_Running.Checked || btnx_Revision.Checked);
			bool bStartlist = btnx_StartList.Checked;
			bool bStat = _tabMain.SelectedTab == _tabHeaderStatDouble || _tabMain.SelectedTab == _tabHeaderTeamA || _tabMain.SelectedTab == _tabHeaderTeamB;
			SetMatchOperateEnable(bRunning, bStartlist, bStat);

			dgvPlayerList_Refresh(true);
			dgvPlayerList_Refresh(false);
			scoreInfoRefresh();
			timeoutSubtitutionRefresh();

			statInfoReferesh();

			propertyGridSetup.Refresh();

			//TeamAB in tab score
			bool exchangeAB = _chkScoreExchangeLR.Checked;
			string strTeamNameA = labNocA.Text;
			string strTeamNameB = labNocB.Text;
			_labTeamA.Text = exchangeAB ? strTeamNameB : strTeamNameA;
			_labTeamB.Text = exchangeAB ? strTeamNameA : strTeamNameB;
		}

		private void btnStatDelete_Click(object sender, EventArgs e)
		{
			if (_curSelRow < 0)
			{
				return;
			}

			//删除确认
			if (DevComponents.DotNetBar.MessageBoxEx.Show("是否删除?", "", MessageBoxButtons.YesNo) != DialogResult.Yes)
			{
				return;
			}

			//删除记录
			Common.dbActionListDelete(_curSelActionNum);

			OnStatChanged();
		}

		private void _chkScoreFromStat_CheckedChanged(object sender, EventArgs e)
		{
			if (_chkScoreFromStat.Checked)
			{
				CalScoreFromStat(false);	
				CalScoreFromStat(true);
				
				//Send score message.
				Common.g_Plugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, Common.g_nMatchID, Common.g_nMatchID, null);

				//刷新自己的比分
				scoreInfoRefresh(); 
			}
		}

		private void propertyGridSetup_Click(object sender, EventArgs e)
		{
			//propertyGridSetup.
		}

		public bool timeoutSubtitutionRefresh()
		{
			DataTable dt = Common.dbSetInfo(Common.g_Game.GetCurSet());
			if (dt == null)
			{
				Debug.Assert(false);
				return false;
			}

			_labSubA.Text = Common.Str2Int(dt.Rows[0]["F_SubtitutionA"].ToString()).ToString();
			_labSubB.Text = Common.Str2Int(dt.Rows[0]["F_SubtitutionB"].ToString()).ToString();
		  	_labTimeA.Text = Common.Str2Int(dt.Rows[0]["F_TimeoutCountA"].ToString()).ToString(); //确保为数字
			_labTimeB.Text = Common.Str2Int(dt.Rows[0]["F_TimeoutCountB"].ToString()).ToString();

			return true;
		}

		//For timeout Subtitution
		private void _btnTimeSub_Click(object sender, EventArgs e)
		{
			int curSet = Common.g_Game.GetCurSet();
			bool exchangeAB = _chkScoreExchangeLR.Checked;

			bool bResult = false;
			if (sender == _btnTimeAAdd)
				bResult = Common.dbSettingSubtitutionTimeOutCount(true,  exchangeAB ? false : true, true,  curSet);
			else if (sender == _btnTimeAReduce)
				bResult = Common.dbSettingSubtitutionTimeOutCount(true,  exchangeAB ? false : true, false, curSet);
			else if (sender == _btnTimeBAdd)
				bResult = Common.dbSettingSubtitutionTimeOutCount(true,  exchangeAB ? true : false, true,  curSet);
			else if (sender == _btnTimeBReduce)
				bResult = Common.dbSettingSubtitutionTimeOutCount(true,  exchangeAB ? true : false, false, curSet);
			else if (sender == _btnSubAAdd)
				bResult = Common.dbSettingSubtitutionTimeOutCount(false, exchangeAB ? false : true, true,  curSet);
			else if (sender == _btnSubAReduce)
				bResult = Common.dbSettingSubtitutionTimeOutCount(false, exchangeAB ? false : true, false, curSet);
			else if (sender == _btnSubBAdd)
				bResult = Common.dbSettingSubtitutionTimeOutCount(false, exchangeAB ? true : false, true,  curSet);
			else if (sender == _btnSubBReduce)
				bResult = Common.dbSettingSubtitutionTimeOutCount(false, exchangeAB ? true : false, false, curSet);
			else
			{
				Debug.Assert(false);
				return;
			}

			if (!bResult)
			{
				MessageBox.Show("修改失败!");
			}

			Common.dbMatchModifyTimeSet();
			Common.NotifyMatchResult();

			RefreshAll();
		}

		private void btns_PreviewKeyDown(object sender, PreviewKeyDownEventArgs e)
		{
			//为了禁止利用Enter点击加减分按钮
			//为了避免Enter的点击,碰上的话,先转换为普通点击
			if (e.KeyCode == Keys.Enter)
			{
				e.IsInputKey = true;
			}
		}

		private void frmOVRVODataEntry_KeyDown(object sender, KeyEventArgs e)
		{
			//整个窗体屏蔽 Space bar.
			if ( e.KeyCode == Keys.Space)
			{
				e.Handled = true;
				return;
			}

			//对于按钮类,屏蔽Enter
			if (e.KeyCode == Keys.Enter)
			{
				if (btnScoreAddA.Focused || btnScoreAddB.Focused)
				{
					e.Handled = true;
					return;
				}
			}
		}

		private void _chkScoreExchangeLR_CheckedChanged(object sender, EventArgs e)
		{
			RefreshAll();
		}

		private void btnScoreDetail_Click(object sender, EventArgs e)
		{
			frmScoreDetail dlg = new frmScoreDetail(labNocA.Text, labNocB.Text);
			dlg.ShowDialog();
		}
	}
}


