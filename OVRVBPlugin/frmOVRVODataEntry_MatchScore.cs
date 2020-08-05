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
		private bool dgvMatchScoreInit()
		{
			dgvMatchScore.RowHeadersVisible = false;
			dgvMatchScore.SelectionMode = DataGridViewSelectionMode.CellSelect;

			Font gridFont = new Font(new FontFamily("Arial"), 15, new FontStyle());
			Font gridTimeFont = new Font(new FontFamily("Arial"), 10, new FontStyle());
			Font gridFontSmall = new Font(new FontFamily("Arial"), 9, FontStyle.Bold);

			dgvMatchScore.Font = gridFont;
			dgvMatchScore.ColumnHeadersDefaultCellStyle.Font = new Font(new FontFamily("Arial"), 10, new FontStyle());
			dgvMatchScore.MultiSelect = false;
			dgvMatchScore.AllowUserToResizeColumns = false;
			dgvMatchScore.AllowUserToResizeRows = false;
			dgvMatchScore.AllowUserToOrderColumns = false;
			dgvMatchScore.AllowDrop = false;
			dgvMatchScore.AllowUserToAddRows = false;
			dgvMatchScore.AllowUserToDeleteRows = false;
			dgvMatchScore.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.None;

			dgvMatchScore.Rows.Clear();
			dgvMatchScore.Columns.Clear();

			dgvMatchScore.Columns.Add("NOC", "NOC");
			dgvMatchScore.Columns.Add(new DGVCustomComboBoxColumn() ); //IRM下拉列表
			dgvMatchScore.Columns[1].Name = "IRM";
			dgvMatchScore.Columns[1].HeaderText = "IRM";

			dgvMatchScore.Columns.Add("SRV", "SRV");
			dgvMatchScore.Columns.Add("SET1", "SET1");
			dgvMatchScore.Columns.Add("SET2", "SET2");
			dgvMatchScore.Columns.Add("SET3", "SET3");
			dgvMatchScore.Columns.Add("SET4", Common.g_isVB ? "SET4" : "" );
			dgvMatchScore.Columns.Add("SET5", Common.g_isVB ? "SET5" : "" );
			dgvMatchScore.Columns.Add("TOTAL", "TOTAL");

			dgvMatchScore.Columns[0].Width = 210;
			dgvMatchScore.Columns[1].Width = 75;
			dgvMatchScore.Columns[2].Width = 60;
			dgvMatchScore.Columns[3].Width = 58;	// Score Set1
			dgvMatchScore.Columns[4].Width = dgvMatchScore.Columns[3].Width;
			dgvMatchScore.Columns[5].Width = dgvMatchScore.Columns[3].Width;
			dgvMatchScore.Columns[6].Width = dgvMatchScore.Columns[3].Width;
			dgvMatchScore.Columns[7].Width = dgvMatchScore.Columns[3].Width;
			dgvMatchScore.Columns[8].Width = 90;

			dgvMatchScore.Columns[0].SortMode = DataGridViewColumnSortMode.NotSortable;
			dgvMatchScore.Columns[1].SortMode = DataGridViewColumnSortMode.NotSortable;
			dgvMatchScore.Columns[2].SortMode = DataGridViewColumnSortMode.NotSortable;
			dgvMatchScore.Columns[3].SortMode = DataGridViewColumnSortMode.NotSortable;
			dgvMatchScore.Columns[4].SortMode = DataGridViewColumnSortMode.NotSortable;
			dgvMatchScore.Columns[5].SortMode = DataGridViewColumnSortMode.NotSortable;
			dgvMatchScore.Columns[6].SortMode = DataGridViewColumnSortMode.NotSortable;
			dgvMatchScore.Columns[7].SortMode = DataGridViewColumnSortMode.NotSortable;
			dgvMatchScore.Columns[8].SortMode = DataGridViewColumnSortMode.NotSortable;

			dgvMatchScore.Rows.Add();
			dgvMatchScore.Rows.Add();
			dgvMatchScore.Rows.Add();
			dgvMatchScore.Rows.Add();
			dgvMatchScore.Rows[0].Height = 25;
			dgvMatchScore.Rows[1].Height = 25;
			dgvMatchScore.Rows[2].Height = 25;
			dgvMatchScore.Rows[3].Height = 25;

			dgvMatchScore.Rows[0].ReadOnly = true;
			dgvMatchScore.Columns[0].ReadOnly = true;	//NOC
			
			dgvMatchScore[1, 1].ReadOnly = false;		//IRM
			dgvMatchScore[1, 2].ReadOnly = false;		//IRM
			dgvMatchScore[1, 3].ReadOnly = true;		//IRM

			dgvMatchScore.Columns[2].ReadOnly = true;	//SERVE
			dgvMatchScore.Columns[3].ReadOnly = false;	//Score Set1
			dgvMatchScore.Columns[4].ReadOnly = false;
			dgvMatchScore.Columns[5].ReadOnly = false;
			dgvMatchScore.Columns[6].ReadOnly = false;
			dgvMatchScore.Columns[7].ReadOnly = false;
			dgvMatchScore.Columns[8].ReadOnly = false;	//Score Total

			dgvMatchScore[3, 3].ReadOnly = false;	//
			dgvMatchScore[4, 3].ReadOnly = false;
			dgvMatchScore[5, 3].ReadOnly = false;
			dgvMatchScore[6, 3].ReadOnly = false;
			dgvMatchScore[7, 3].ReadOnly = false;
			dgvMatchScore[8, 3].ReadOnly = false;

			dgvMatchScore[2, 3].Style.Font = gridTimeFont;
			dgvMatchScore[3, 3].Style.Font = gridTimeFont;
			dgvMatchScore[4, 3].Style.Font = gridTimeFont;
			dgvMatchScore[5, 3].Style.Font = gridTimeFont;
			dgvMatchScore[6, 3].Style.Font = gridTimeFont;
			dgvMatchScore[7, 3].Style.Font = gridTimeFont;
			dgvMatchScore[8, 3].Style.Font = gridTimeFont;

			dgvMatchScore[8, 0].Style.Font = gridFontSmall;	//PointInfo
			dgvMatchScore[8, 0].Style.ForeColor = Color.Red;

			dgvMatchScore[1, 1].Style.ForeColor = Color.Red;		//IRM颜色
			dgvMatchScore[1, 2].Style.ForeColor = Color.Red;

			//Init IRM CmbList
			{
				DataTable tblIRM = Common.dbIRMGetList();
				if (tblIRM == null)
				{
					Debug.Assert(false);
					return false;
				}

				(dgvMatchScore.Columns[1] as DGVCustomComboBoxColumn).FillComboBoxItems(tblIRM, 1, 0);
			}

			return true;
		}

		public bool dgvMatchScoreRefresh(GameGeneralBall gameObj = null)
		{
			if (gameObj == null)
			{
				gameObj = Common.g_Game;
			}

			dgvMatchScore[2, 1].Value = gameObj.IsServeTeamB() ? "" : "●";
			dgvMatchScore[2, 2].Value = gameObj.IsServeTeamB() ? "●" : "";

			dgvMatchScore[3, 1].Value = gameObj.GetScoreSetStr(false, 1);
			dgvMatchScore[3, 2].Value = gameObj.GetScoreSetStr(true, 1);
			dgvMatchScore[4, 1].Value = gameObj.GetScoreSetStr(false, 2);
			dgvMatchScore[4, 2].Value = gameObj.GetScoreSetStr(true, 2);
			dgvMatchScore[5, 1].Value = gameObj.GetScoreSetStr(false, 3);
			dgvMatchScore[5, 2].Value = gameObj.GetScoreSetStr(true, 3);
			dgvMatchScore[6, 1].Value = gameObj.GetScoreSetStr(false, 4);
			dgvMatchScore[6, 2].Value = gameObj.GetScoreSetStr(true, 4);
			dgvMatchScore[7, 1].Value = gameObj.GetScoreSetStr(false, 5);
			dgvMatchScore[7, 2].Value = gameObj.GetScoreSetStr(true, 5);
			dgvMatchScore[8, 1].Value = gameObj.GetScoreMatchStr(false);
			dgvMatchScore[8, 2].Value = gameObj.GetScoreMatchStr(true);

			dgvMatchScore[3, 1].Style.ForeColor = gameObj.GetWinSet(1) == EGbTeam.emTeamA ? ClrScr_Win : ClrScr_Nor;
			dgvMatchScore[3, 2].Style.ForeColor = gameObj.GetWinSet(1) == EGbTeam.emTeamB ? ClrScr_Win : ClrScr_Nor;
			dgvMatchScore[4, 1].Style.ForeColor = gameObj.GetWinSet(2) == EGbTeam.emTeamA ? ClrScr_Win : ClrScr_Nor;
			dgvMatchScore[4, 2].Style.ForeColor = gameObj.GetWinSet(2) == EGbTeam.emTeamB ? ClrScr_Win : ClrScr_Nor;
			dgvMatchScore[5, 1].Style.ForeColor = gameObj.GetWinSet(3) == EGbTeam.emTeamA ? ClrScr_Win : ClrScr_Nor;
			dgvMatchScore[5, 2].Style.ForeColor = gameObj.GetWinSet(3) == EGbTeam.emTeamB ? ClrScr_Win : ClrScr_Nor;
			dgvMatchScore[6, 1].Style.ForeColor = gameObj.GetWinSet(4) == EGbTeam.emTeamA ? ClrScr_Win : ClrScr_Nor;
			dgvMatchScore[6, 2].Style.ForeColor = gameObj.GetWinSet(4) == EGbTeam.emTeamB ? ClrScr_Win : ClrScr_Nor;
			dgvMatchScore[7, 1].Style.ForeColor = gameObj.GetWinSet(5) == EGbTeam.emTeamA ? ClrScr_Win : ClrScr_Nor;
			dgvMatchScore[7, 2].Style.ForeColor = gameObj.GetWinSet(5) == EGbTeam.emTeamB ? ClrScr_Win : ClrScr_Nor;
			dgvMatchScore[8, 1].Style.ForeColor = gameObj.GetWinMatch() == EGbTeam.emTeamA ? ClrScr_Win : ClrScr_Nor;
			dgvMatchScore[8, 2].Style.ForeColor = gameObj.GetWinMatch() == EGbTeam.emTeamB ? ClrScr_Win : ClrScr_Nor;

			dgvMatchScore[3, 3].Value = gameObj.GetTimeSetStr(1);
			dgvMatchScore[4, 3].Value = gameObj.GetTimeSetStr(2);
			dgvMatchScore[5, 3].Value = gameObj.GetTimeSetStr(3);
			dgvMatchScore[6, 3].Value = gameObj.GetTimeSetStr(4);
			dgvMatchScore[7, 3].Value = gameObj.GetTimeSetStr(5);
			dgvMatchScore[8, 3].Value = gameObj.GetTimeMatchStr();

			Int32 nCurSet = gameObj.GetCurSet();
			dgvMatchScore[3, 0].Value = (nCurSet == 1) ? "●" : "";
			dgvMatchScore[4, 0].Value = (nCurSet == 2) ? "●" : "";
			dgvMatchScore[5, 0].Value = (nCurSet == 3) ? "●" : "";
			dgvMatchScore[6, 0].Value = (nCurSet == 4) ? "●" : "";
			dgvMatchScore[7, 0].Value = (nCurSet == 5) ? "●" : "";

			DataTable tblMatchInfo = Common.dbGetMatchInfo(Common.g_nMatchID, Common.g_strLanguage);
			if (tblMatchInfo != null)
			{
				dgvMatchScore[1, 1].Value = tblMatchInfo.Rows[0]["F_IRMCodeA"].ToString();
				dgvMatchScore[1, 2].Value = tblMatchInfo.Rows[0]["F_IRMCodeB"].ToString();
			}
			
			dgvMatchScore[8, 0].Value = gameObj.GetPointInfo().GetCountStr() + ' ' + gameObj.GetPointInfo().GetPointStr();

			return true;
		}

		private void dgvMatchScore_CellClick(object sender, DataGridViewCellEventArgs e)
		{
			if (e.RowIndex == 0)  //更换当前局
			{
				if (e.ColumnIndex >= 3 && e.ColumnIndex <= 7)
				{
					Common.g_Game.SetCurSet(e.ColumnIndex - 2);
					Common.dbGameObj2Db(Common.g_nMatchID, Common.g_Game);

					RefreshAll();

					Common.NotifyMatchResult();
					Common.g_Plugin.DataChangedNotify(OVRDataChangedType.emSplitCompetitorMember, -1, -1, -1, Common.g_nMatchID, Common.g_nMatchID, null);
				}
			}
			else
			if (e.RowIndex == 1)	//设球权
			{
				if (e.ColumnIndex == 2)
				{
					Common.g_Game.SetServeTeamB(false);
					Common.dbGameObj2Db(Common.g_nMatchID, Common.g_Game);
					dgvMatchScoreRefresh();

					Common.NotifyMatchResult();
				}
			}
			else
			if (e.RowIndex == 2)	//设球权
			{
				if (e.ColumnIndex == 2)
				{
					Common.g_Game.SetServeTeamB(true);
					Common.dbGameObj2Db(Common.g_nMatchID, Common.g_Game);
					dgvMatchScoreRefresh();

					Common.NotifyMatchResult();
				}
			}
			else
			{
				//Debug.Assert(false);
			}
		}

		private void dgvMatchScore_CellEndEdit(object sender, DataGridViewCellEventArgs e)
		{
			//没有选中的当前单元格,肯定不会
			if( dgvMatchScore.CurrentCell == null )
				return;

			//判断是否编辑的是IRM
			if ( e.RowIndex >= 1 && e.RowIndex <= 2 && e.ColumnIndex == 1 )
			{
				//有可能为空
				Int32 nIRM_ID = Common.Str2Int(dgvMatchScore.CurrentCell.Tag);

				if (!Common.dbIRMSet(Common.g_nMatchID, nIRM_ID, (e.RowIndex == 1)))
				{
					MessageBox.Show("设置IRM信息失败!");
				}

				Common.dbMatchModifyTimeSet();
				Common.NotifyMatchResult();
				return;
			}

			//是否为编辑值
			if( ((DataGridView)sender).CurrentCell.Value != null )
			{
				String strNewValue = ((DataGridView)sender).CurrentCell.Value.ToString();

				//判断是否编辑比分
				if (e.RowIndex >= 1 && e.RowIndex <= 2 && e.ColumnIndex >= 3 && e.ColumnIndex <= 7 )
				{
					Int32 nCurScore = Common.Str2Int(strNewValue);
					nCurScore = Math.Max(nCurScore, 0);
					bool bTeamB = (e.RowIndex == 2);
					Int32 nSet = e.ColumnIndex - 2;
					Int32 ptsSetOppr = Common.g_Game.GetScoreSet(!bTeamB, nSet);
					Int32 scoreWin = Common.g_isVB ? 25 : 21;

					//在第五局如果输入的值大于15分,给予一个提示
					if (Common.g_isVB && nCurScore > 15 && nSet == 5 && nCurScore > ptsSetOppr + 2)
					{
						if (MessageBox.Show("第5局比分一般不会大于15. 是否继续?", "比分提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
							== System.Windows.Forms.DialogResult.Yes)
						{
							Common.g_Game.SetScore(nCurScore, bTeamB, nSet);
						}
					}
					else
					if (!Common.g_isVB && nCurScore > 15 && nSet == 3 && nCurScore > ptsSetOppr + 2)
					{
						if (MessageBox.Show("第3局比分一般不会大于15. 是否继续?", "比分提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
							== System.Windows.Forms.DialogResult.Yes)
						{
							Common.g_Game.SetScore(nCurScore, bTeamB, nSet);
						}
					}
					else
					if (nCurScore > scoreWin && nCurScore > ptsSetOppr + 2)
					{
						if (MessageBox.Show("比分一般不会大于" + scoreWin.ToString() + ". 是否继续?", "比分提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
							== System.Windows.Forms.DialogResult.Yes)
						{
							Common.g_Game.SetScore(nCurScore, bTeamB, nSet);
						}
					}
					else
					{
						Common.g_Game.SetScore(nCurScore, bTeamB, nSet);
					}

					Common.dbGameObj2Db(Common.g_nMatchID, Common.g_Game);
					dgvMatchScoreRefresh();
					Common.NotifyMatchResult();

					return;
				}

				//时间
				if (e.RowIndex == 3 && e.ColumnIndex >= 3 && e.ColumnIndex <= 8)
				{
					int nTime = 0;
					int nIndex = strNewValue.IndexOf(':');

					if (nIndex > 0)
					{
						nTime = Common.Str2Int(strNewValue.Substring(0, nIndex)) * 60;
						nTime += Common.Str2Int(strNewValue.Substring(nIndex+1, strNewValue.Length-nIndex-1));		
					}
					else
					{
						nTime = Common.Str2Int(strNewValue);
					}
					
					if (nTime > 999)
						nTime = 999;

					if (nTime < 0)
						nTime = 0;

					if (e.ColumnIndex - 2 == 6)
					{
						Common.g_Game.SetTimeMatch(nTime.ToString());
					}
					else
					if (e.ColumnIndex - 2 < 6 && e.ColumnIndex - 2 > 0)
					{
						int nSet = e.ColumnIndex - 2;
						Common.g_Game.SetTimeSet(nTime.ToString(), nSet);
					}
					else
					{
						Debug.Assert(false);
					}

					Common.dbGameObj2Db(Common.g_nMatchID, Common.g_Game);
					dgvMatchScoreRefresh();
					Common.NotifyMatchResult();

					return;
				}
			}
		}

		private void dgvMatchScore_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
		{
			Int32 nCurSet = Common.g_Game.GetCurSet();
			Int32 nOperSet = e.ColumnIndex - 2;

			e.Cancel = true;
			//Every Set
			if (nOperSet <= nCurSet )
			{
				e.Cancel = false;
			}
			else
			if (nOperSet == GameGeneralBall.MAX_MATCH + 1 && e.RowIndex == 3) //matchTime
			{
				e.Cancel = false;
			}
		}

		private Color ClrScr_Win = Color.Blue;
		private Color ClrScr_Nor = Color.Black;
	}
}
