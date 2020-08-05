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
	public partial class frmOVRVODataEntry
	{
		private void tabControlHeader_SelectedTabChanged(object sender, SuperTabStripSelectedTabChangedEventArgs e)
		{
			//因为StatA，StatB界面完全一样，只是装载的A,B队不同，所以用1个Panel,
			//如果在tabControlHead中点综合， 那么显示tabControlMain中Main卡片
			//如果在tabControlHead中点TeamA或TeamB，那么显示tabControlMain中Team卡片
			//同时进行卡片内 数据的初始化，通过判断tabControlHead中哪个卡片被选中，就可知道当前选中了啥

			//主要是防止程序启动时自动触发
			if (Common.g_nMatchID <= 0)
			{
				return;
			}

			if (e.NewValue == _tabHeaderStatDouble)
			{
				_tabWork.SelectedTab = _tabWorkStatDouble;
			}
			else
			if (e.NewValue == _tabHeaderTeamA || e.NewValue == _tabHeaderTeamB)
			{
				_tabWork.SelectedTab = _tabWorkStatTeam;
			}
			else
			if (e.NewValue == _tabHeaderScore)
			{
				_tabWork.SelectedTab = _tabWorkScore;
			}

			RefreshAll();
		}

		private bool dgvStatEntryPlayersAllInit()
		{
			DataGridView dgvCur = dgvStatEntryPlayerAll;

			dgvCur.ReadOnly = true;
			dgvCur.RowHeadersVisible = false;
			dgvCur.Font = new Font(new FontFamily("Arial"), 12, FontStyle.Bold);
			dgvCur.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
			dgvCur.MultiSelect = false;
			dgvCur.AllowUserToResizeRows = false;
			dgvCur.AllowUserToOrderColumns = false;
			dgvCur.AllowUserToResizeColumns = false;
			dgvCur.AllowDrop = false;
			dgvCur.AllowUserToAddRows = false;
			dgvCur.AllowUserToDeleteRows = false;
			dgvCur.ColumnHeadersVisible = false;
			dgvCur.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.None;
			dgvCur.AdvancedCellBorderStyle.All = DataGridViewAdvancedCellBorderStyle.None;
			dgvCur.ScrollBars = ScrollBars.None;

			dgvCur.Rows.Clear();
			dgvCur.Columns.Clear();

			dgvCur.Columns.Add("Bib", "Bib");
			dgvCur.Columns.Add("Name", "Name");

			dgvCur.Columns["Bib"].Width = 40;
			dgvCur.Columns["Name"].Width = 170;

			return true;
		}

		//技术统计界面上的人员列表
		private bool dgvStarEntryPlayersAllRefersh(bool bTeamA)
		{
			dgvStatEntryPlayerAll.Rows.Clear();

			//Fill Data
			DataTable tblStartlist = Common.dbGetMatchStartList(bTeamA, GetStatCurSet());
			if (tblStartlist == null)
			{
				Debug.Assert(false);
				return false;
			}

			for (int nRow = 0; nRow < tblStartlist.Rows.Count; nRow++)
			{
				//目前不添加已经在场上的人员
				if (tblStartlist.Rows[nRow]["F_IsOnCourt"].ToString() == "1")
					continue;

				dgvStatEntryPlayerAll.Rows.Add();

				int nDgvRow = dgvStatEntryPlayerAll.Rows.Count - 1;
				dgvStatEntryPlayerAll.Rows[nDgvRow].Height = 30;

				dgvStatEntryPlayerAll.Rows[nDgvRow].Tag = tblStartlist.Rows[nRow]["F_RegisterID"].ToString();
				dgvStatEntryPlayerAll["Bib", nDgvRow].Value = tblStartlist.Rows[nRow]["F_ShirtNumber"].ToString();
				dgvStatEntryPlayerAll["Bib", nDgvRow].Tag = tblStartlist.Rows[nRow]["F_IsLibero"].ToString();		//Bib Tag中放是否为Libero
				dgvStatEntryPlayerAll["Name", nDgvRow].Value = tblStartlist.Rows[nRow]["F_FuncName"].ToString();
			}

			return true;
		}

		//刷新站位按钮上的人 Tag值为队员的RegID
		private bool btnStatEntryPlayersOnCourtRefresh(DataTable tblPosOnCourt)
		{
			if (tblPosOnCourt == null)
			{
				Debug.Assert(false);
				return false;
			}

			//Pos1
			if (tblPosOnCourt.Rows.Count >= 1)
			{
				btnStatEntryPlayer_Pos1.Tag = tblPosOnCourt.Rows[0]["F_RegID"].ToString();
				btnStatEntryPlayer_Pos1.Text = tblPosOnCourt.Rows[0]["F_Bib"].ToString();
			}
			else
			{
				btnStatEntryPlayer_Pos1.Tag = null;
				btnStatEntryPlayer_Pos1.Text = "";
			}

			//Pos2
			if (tblPosOnCourt.Rows.Count >= 2)
			{
				btnStatEntryPlayer_Pos2.Tag = tblPosOnCourt.Rows[1]["F_RegID"].ToString();
				btnStatEntryPlayer_Pos2.Text = tblPosOnCourt.Rows[1]["F_Bib"].ToString();
			}
			else
			{
				btnStatEntryPlayer_Pos2.Tag = null;
				btnStatEntryPlayer_Pos2.Text = "";
			}

			//Pos3
			if (tblPosOnCourt.Rows.Count >= 3)
			{
				btnStatEntryPlayer_Pos3.Tag = tblPosOnCourt.Rows[2]["F_RegID"].ToString();
				btnStatEntryPlayer_Pos3.Text = tblPosOnCourt.Rows[2]["F_Bib"].ToString();
			}
			else
			{
				btnStatEntryPlayer_Pos3.Tag = null;
				btnStatEntryPlayer_Pos3.Text = "";
			}

			//Pos4
			if (tblPosOnCourt.Rows.Count >= 4)
			{
				btnStatEntryPlayer_Pos4.Tag = tblPosOnCourt.Rows[3]["F_RegID"].ToString();
				btnStatEntryPlayer_Pos4.Text = tblPosOnCourt.Rows[3]["F_Bib"].ToString();
			}
			else
			{
				btnStatEntryPlayer_Pos4.Tag = null;
				btnStatEntryPlayer_Pos4.Text = "";
			}

			//Pos5
			if (tblPosOnCourt.Rows.Count >= 5)
			{
				btnStatEntryPlayer_Pos5.Tag = tblPosOnCourt.Rows[4]["F_RegID"].ToString();
				btnStatEntryPlayer_Pos5.Text = tblPosOnCourt.Rows[4]["F_Bib"].ToString();
			}
			else
			{
				btnStatEntryPlayer_Pos5.Tag = null;
				btnStatEntryPlayer_Pos5.Text = "";
			}

			//Pos6
			if (tblPosOnCourt.Rows.Count >= 6)
			{
				btnStatEntryPlayer_Pos6.Tag = tblPosOnCourt.Rows[5]["F_RegID"].ToString();
				btnStatEntryPlayer_Pos6.Text = tblPosOnCourt.Rows[5]["F_Bib"].ToString();
			}
			else
			{
				btnStatEntryPlayer_Pos6.Tag = null;
				btnStatEntryPlayer_Pos6.Text = "";
			}

			//Pos Libero1
			if (tblPosOnCourt.Rows.Count >= 7)
			{
				btnStatEntryPlayer_Pos7.Tag = tblPosOnCourt.Rows[6]["F_RegID"].ToString();
				btnStatEntryPlayer_Pos7.Text = tblPosOnCourt.Rows[6]["F_Bib"].ToString();
			}
			else
			{
				btnStatEntryPlayer_Pos7.Tag = null;
				btnStatEntryPlayer_Pos7.Text = "";
			}

			//Pos Libero2
			if (tblPosOnCourt.Rows.Count >= 8)
			{
				btnStatEntryPlayer_Pos8.Tag = tblPosOnCourt.Rows[7]["F_RegID"].ToString();
				btnStatEntryPlayer_Pos8.Text = tblPosOnCourt.Rows[7]["F_Bib"].ToString();
			}
			else
			{
				btnStatEntryPlayer_Pos8.Tag = null;
				btnStatEntryPlayer_Pos8.Text = "";
			}

			return true;
		}

		private void btnStatEntryPlayer_Click(object sender, EventArgs e)
		{
			btnStatEntryOppErr.Enabled = false;
			btnStatEntryTemErr.Enabled = false;
			btnStatEntryActionTypeSetEnable(false, false);
			btnStatEntryActionResultSetEnable(false, false, false);

			//此位置为空，只能是人员上场
			if (((ButtonX)sender).Tag == null || ((ButtonX)sender).Tag.ToString() == "")
			{
				btnStatEntryPlayerIn.Enabled = true;
				btnStatEntryPlayerChange.Enabled = false;
				btnStatEntryActionTypeSetEnable(false, false);
			}
			else //此位置有人，可为换人，或技术统计，不可能为上场
			{
				btnStatEntryPlayerIn.Enabled = false;
				btnStatEntryPlayerChange.Enabled = true;
				
				btnStatEntryActionTypeSetEnable(true, false);				
			}

			labStatEntryErrMsg.Text = "";
			btnStatEntryPlayerSetEnable(true, false);
			m_btnStatEntryPlayerSelected = (ButtonX)sender;
			((ButtonX)sender).Style = eDotNetBarStyle.Office2003;
		}

		private void btnStatEntryActionType_Click(object sender, EventArgs e)
		{
			//btnStatEntryPlayerOut.Enabled = false;
			btnStatEntryPlayerChange.Enabled = false;

			btnStatEntryActionTypeSetEnable(true, false);
			((ButtonX)sender).Style = eDotNetBarStyle.Office2003;

			if (sender == btnStatEntryActionType_ATK)
				m_strStatEntryActionType = "ATK";
			else
			if (sender == btnStatEntryActionType_BLO)
				m_strStatEntryActionType = "BLO";
			else
			if (sender == btnStatEntryActionType_SRV)
				m_strStatEntryActionType = "SRV";
			else
			if (sender == btnStatEntryActionType_DIG)
				m_strStatEntryActionType = "DIG";
			else
			if (sender == btnStatEntryActionType_SET)
				m_strStatEntryActionType = "SET";
			else
			if (sender == btnStatEntryActionType_RCV)
				m_strStatEntryActionType = "RCV";
		

			((ButtonX)sender).Style = eDotNetBarStyle.Office2003;

			if (sender == btnStatEntryActionType_ATK ||
				sender == btnStatEntryActionType_BLO ||
				sender == btnStatEntryActionType_SRV  ) //得失分类
			{
				btnStatEntryActionResultSetEnable(true, false, false);
			}
			else
			if (sender == btnStatEntryActionType_DIG ||	//非得失分类

				sender == btnStatEntryActionType_SET ||
				sender == btnStatEntryActionType_RCV  )
			{
				btnStatEntryActionResultSetEnable(false, true, false);
			}
		}

		private void btnStatEntryActionResult_Click(object sender, EventArgs e)
		{
			if (m_btnStatEntryPlayerSelected == null || m_btnStatEntryPlayerSelected.Tag == null )
			{
				Debug.Assert(false);
				return;
			}

			bool bIsTeamB = _tabMain.SelectedTab == _tabHeaderTeamB ? true : false;
			int nRegisterID = Common.Str2Int(m_btnStatEntryPlayerSelected.Tag);

			String strStatTypeCode = "";

			if (sender == btnStatEntryResult_SUC)	//得分
			{
				strStatTypeCode = m_strStatEntryActionType + "_" + "SUC";	//目前应该只有ATK,BLO,SRV有
			}
			else 
			if (sender == btnStatEntryResult_EXC)	//好球没得分
			{
				strStatTypeCode = m_strStatEntryActionType + "_" + "EXC";	//目前应该只有DIG,SET,RCV有
			}
			else
			if (sender == btnStatEntryResult_CNT)	//一般
			{
				strStatTypeCode = m_strStatEntryActionType + "_" + "CNT";
			}
			else
			if (sender == btnStatEntryResult_BAD)	//坏球没丢分
			{
				strStatTypeCode = m_strStatEntryActionType + "_" + "BAD";	//目前应该不存在
			}
			else
			if (sender == btnStatEntryResult_FLT)	//丢分
			{
				strStatTypeCode = m_strStatEntryActionType + "_" + "FLT";
			}

			if (!StatEntryAddAction(nRegisterID, strStatTypeCode))
			{
				labStatEntryErrMsg.Text = ("添加技术统计失败!");
			}

			OnStatChanged(bIsTeamB);
		}

		private void btnStatEntryPlayerSetEnable(bool bEnable, bool bActive)
		{
			btnStatEntryPlayer_Pos1.Enabled = bEnable;
			btnStatEntryPlayer_Pos2.Enabled = bEnable;
			btnStatEntryPlayer_Pos3.Enabled = bEnable;
			btnStatEntryPlayer_Pos4.Enabled = bEnable;
			btnStatEntryPlayer_Pos5.Enabled = bEnable;
			btnStatEntryPlayer_Pos6.Enabled = bEnable;
			btnStatEntryPlayer_Pos7.Enabled = bEnable;
			btnStatEntryPlayer_Pos8.Enabled = bEnable;

			btnStatEntryPlayer_Pos1.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryPlayer_Pos2.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryPlayer_Pos3.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryPlayer_Pos4.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryPlayer_Pos5.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryPlayer_Pos6.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryPlayer_Pos7.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryPlayer_Pos8.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
		}

		private void btnStatEntryActionTypeSetEnable(bool bEnable, bool bActive)
		{
			btnStatEntryActionType_ATK.Enabled = bEnable;
			btnStatEntryActionType_BLO.Enabled = bEnable;
			btnStatEntryActionType_SRV.Enabled = bEnable;
			btnStatEntryActionType_DIG.Enabled = bEnable;
			btnStatEntryActionType_SET.Enabled = bEnable;
			btnStatEntryActionType_RCV.Enabled = bEnable;

			btnStatEntryActionType_ATK.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryActionType_BLO.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryActionType_SRV.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryActionType_DIG.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryActionType_SET.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryActionType_RCV.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
		}

		private void btnStatEntryActionResultSetEnable(bool bEffectScoreEnable, bool bNonEffectScoreEnable, bool bActive)
		{
			btnStatEntryResult_SUC.Enabled = bEffectScoreEnable;
			btnStatEntryResult_EXC.Enabled = bNonEffectScoreEnable;
			btnStatEntryResult_FLT.Enabled = bEffectScoreEnable || bNonEffectScoreEnable;
			btnStatEntryResult_BAD.Enabled = false;
			btnStatEntryResult_CNT.Enabled = bEffectScoreEnable || bNonEffectScoreEnable; //对于“一般”，都有效

			btnStatEntryResult_SUC.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryResult_FLT.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryResult_EXC.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryResult_BAD.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
			btnStatEntryResult_CNT.Style = bActive ? eDotNetBarStyle.Office2003 : eDotNetBarStyle.Office2007;
		}

		private void btnStatEntryOppErr_Click(object sender, EventArgs e)
		{
			labStatEntryErrMsg.Text = "";

			int nCurSet = GetStatCurSet();
			bool bIsTeamB = _tabMain.SelectedTab == _tabHeaderTeamB ? true : false;

			Common.dbActionListAdd(Common.g_nMatchID, nCurSet, "OPP_ERR", -1, 0, bIsTeamB);

			OnStatChanged(bIsTeamB);
		}

		private void btnStatEntryTemErr_Click(object sender, EventArgs e)
		{
			labStatEntryErrMsg.Text = "";

			int nCurSet = GetStatCurSet();
			bool bIsTeamB = _tabMain.SelectedTab == _tabHeaderTeamB ? true : false;

			Common.dbActionListAdd(Common.g_nMatchID, nCurSet, "TEM_FLT", -1, 0, bIsTeamB);

			OnStatChanged(bIsTeamB);
		}

		private void btnDeleteLast_Click(object sender, EventArgs e)
		{
			bool bIsTeamB = _tabMain.SelectedTab == _tabHeaderTeamB ? true : false;
			string str4 =  bIsTeamB ? "CodeB" : "CodeA";

			for (int i = dgvActionList.RowCount - 1; i >= 0; i--)
			{
				if ((dgvActionList[str4, i] != null) && (dgvActionList[str4, i].Tag != null))
				{
					if (MessageBox.Show("Delete?", "Delete last action.", MessageBoxButtons.YesNo, MessageBoxIcon.Question) != System.Windows.Forms.DialogResult.Yes)
					{
						return;
					}

					int nActionID = Common.Str2Int(dgvActionList[str4, i].Tag);
					if (nActionID <= 0)
					{
						labStatEntryErrMsg.Text = "获取最后一条技术统计失败，删除最后技术统计失败!";
					}
					else if (!Common.dbActionListDelete(nActionID))
					{
						labStatEntryErrMsg.Text = "执行删除操作失败,删除最后一条技术统计失败!";
					}
					else
					{
						labStatEntryErrMsg.Text = "";

						OnStatChanged(bIsTeamB);
					}

					return;
				}
			}
		}

		private void btnStatEntryCancel_Click(object sender, EventArgs e)
		{
			m_btnStatEntryPlayerSelected = null;
			m_strStatEntryActionType = "";

			dgvStatEntryPlayerAll.ClearSelection();
			dgvStatEntryPlayerAll.Visible = false;

			btnStatEntryPlayerIn.Enabled = true;
			btnStatEntryPlayerChange.Enabled = false;

			btnStatEntryPlayerIn.Style = eDotNetBarStyle.Office2007;
			btnStatEntryPlayerChange.Style = eDotNetBarStyle.Office2007;

			btnStatEntryTemErr.Enabled = true;
			btnStatEntryOppErr.Enabled = true;
			btnStatEntryPlayerSetEnable(true, false);
			btnStatEntryActionTypeSetEnable(false, false);
			btnStatEntryActionTypeSetEnable(false, false);
			btnStatEntryActionResultSetEnable(false, false, false);
		}

		private void btnStatEntryPlayerIn_Click(object sender, EventArgs e)
		{
			btnStatEntryPlayerIn.Style = eDotNetBarStyle.Office2003;

			btnStatEntryPlayerSetEnable(false, false);

			//现需要显示人员列表时,再进行刷新
			dgvStarEntryPlayersAllRefersh( _tabMain.SelectedTab == _tabHeaderTeamA );
			dgvStatEntryPlayerAll.Visible = true;

			btnStatEntryTemErr.Enabled = false;
			btnStatEntryOppErr.Enabled = false;
		}
		
		private void btnStatEntryPlayerChange_Click(object sender, EventArgs e)
		{
			btnStatEntryPlayerChange.Style = eDotNetBarStyle.Office2003;

			//需要显示人员列表时，再进行刷新
			dgvStarEntryPlayersAllRefersh(_tabMain.SelectedTab == _tabHeaderTeamA);
			dgvStatEntryPlayerAll.Visible = true;

			btnStatEntryTemErr.Enabled = false;
			btnStatEntryOppErr.Enabled = false;
		}

		private void dgvStatEntryPlayerAll_Click(object sender, EventArgs e)
		{
			if (  dgvStatEntryPlayerAll.SelectedRows.Count < 1 ||
				 dgvStatEntryPlayerAll.SelectedRows[0].Tag == null ||
				 dgvStatEntryPlayerAll.SelectedRows[0].Cells["Bib"] == null ||
				 dgvStatEntryPlayerAll.SelectedRows[0].Cells["Bib"].Tag == null)
			{
				Debug.Assert(false);
				return;
			}

			int nInRegID = Common.Str2Int(dgvStatEntryPlayerAll.SelectedRows[0].Tag);
			bool nInIsLibero = Common.Str2Int(dgvStatEntryPlayerAll.SelectedRows[0].Cells["Bib"].Tag) == 1;

			if (btnStatEntryPlayerChange.Enabled == true) //换人模式
			{
				if (m_btnStatEntryPlayerSelected == null || m_btnStatEntryPlayerSelected.Tag == null)
				{
					Debug.Assert(false);
					return;
				}

				int nOutRegID = Common.Str2Int(m_btnStatEntryPlayerSelected.Tag);
				bool bOutIsLibero = m_btnStatEntryPlayerSelected == btnStatEntryPlayer_Pos7;

				if (nInIsLibero != bOutIsLibero)
				{
					labStatEntryErrMsg.Text = "上下场队员职务不同一,换人失败!";
					statInfoReferesh();
					return;
				}

				//如果在换人模式，就先下场
				if (!StatEntryAddAction(nOutRegID, bOutIsLibero ? "Lib_OUT" : "Ply_OUT"))
				{
					labStatEntryErrMsg.Text = "在换人时，下场失败!";
					statInfoReferesh();
					return;
				}

				//换人的上场

				if (!StatEntryAddAction(nInRegID, nInIsLibero ? "Lib_IN" : "Ply_IN"))
				{
					labStatEntryErrMsg.Text = "在换人时，上场失败!";
					statInfoReferesh();
					return;
				}

			}
			else //上场模式
			{
				if (!StatEntryAddAction(nInRegID, nInIsLibero ? "Lib_IN" : "Ply_IN"))
				{
					labStatEntryErrMsg.Text = "上场失败!";
					statInfoReferesh();
					return;
				}
			}

			OnStatChanged();
		}

		//根据STAT推算比分，在STAT编辑完成后，调用此函数，
		private bool CalScoreFromStat(bool bTeamA)
		{
			//首先根据当前STAT，推算单方比分，
			//之后和当前分数进行比较，一样，就返回False
			//不一样，就修改比分。并返回True，通知上层刷新
			object objScore = Common.dbGetScoreFromStat(bTeamA);
			if (objScore == null)
			{
				Debug.Assert(false);
				return false;
			}

			int nNewScore = Common.Str2Int(objScore);
			int nOldScore = Common.g_Game.GetScoreSet(!bTeamA);
			if (nNewScore == nOldScore)
			{
				return false;
			}

			Common.g_Game.SetScore(nNewScore, !bTeamA);

			if (nNewScore > nOldScore)	//如果是赢球，需要设球权
			{
				Common.g_Game.SetServeTeamB(!bTeamA);
			}

			Common.dbGameObj2Db(Common.g_nMatchID, Common.g_Game);

			return true;
		}

		private void OnStatChanged(bool? IsTeamBChanged = null)
		{
			// Send stat message.
			Common.g_Plugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, Common.g_nMatchID, Common.g_nMatchID, null);

			//Calculate score
			if (_chkScoreFromStat.Checked)
			{
				bool bScoreChanged = false;
				if (IsTeamBChanged == null || (bool)IsTeamBChanged)
				{
					bScoreChanged |= CalScoreFromStat(false);
				}

				if (IsTeamBChanged == null || !(bool)IsTeamBChanged)
				{
					bScoreChanged |= CalScoreFromStat(true);
				}

				if (bScoreChanged)
				{
					//Send score message.
					Common.g_Plugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, Common.g_nMatchID, Common.g_nMatchID, null);

					//刷新自己的比分
					scoreInfoRefresh();
				}
			}

			//让网络中其他机器刷新
			Common.dbMatchModifyTimeSet();

			//刷新自己界面的STAT
			statInfoReferesh();
		}

		//方便在STAT_TAB中添加技术统计
		private bool StatEntryAddAction(int nRegisterID, String strActionTypeCode)
		{
			int nCurSet = GetStatCurSet();
			bool bIsTeamB = _tabMain.SelectedTab == _tabHeaderTeamB ? true : false;

			bool bRet = Common.dbActionListAdd(Common.g_nMatchID, nCurSet, strActionTypeCode, nRegisterID, 0, bIsTeamB);
			return bRet;
		}

		private Color m_clrStatEntryBtnBack = Color.FromArgb(194, 217, 247); 
		private Color m_clrStatEntryBtnBackSelected = Color.FromArgb(200, 200, 200);

		private ButtonX m_btnStatEntryPlayerSelected;	//当前选中人的那个按钮，因为人员上场时，有可能是空位，所以存BTN指针
		private String m_strStatEntryActionType;			//"ATK", "BLO"
	}
}
