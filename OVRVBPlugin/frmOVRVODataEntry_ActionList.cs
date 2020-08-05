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
using System.Xml;

namespace AutoSports.OVRVBPlugin
{
	public class DataGridViewActionList : DataGridView
	{
		//为了实现按Delete删除Action,但因为dgvActionList的CurrentSelect永远为null,不可能调用DeleteRow函数
		//利用了此损招,如果发现按键为Delete,直接调用自身Delete函数来实现,挺损的方法
		protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
		{
			DataGridViewRow deleteRow = new DataGridViewRow();

			switch (keyData)
			{
				case Keys.Delete:
					deleteRow.Tag = null;
					OnUserDeletingRow(new DataGridViewRowCancelEventArgs(deleteRow));
					return true;

				case Keys.Left:
				case Keys.Right:
				case Keys.Up:
				case Keys.Down:
					deleteRow.Tag = keyData;
					OnUserDeletingRow( new DataGridViewRowCancelEventArgs(deleteRow) );
					return true;

				default:
					return base.ProcessCmdKey(ref msg, keyData);

			}
		}

		protected override void SetSelectedCellCore(int columnIndex, int rowIndex, bool selected)
		{
			//为了让控件实现无法选中,所以这样做,也是损招
			//base.SetSelectedCellCore(columnIndex, rowIndex, selected);
		}
	}

	public partial class frmOVRVODataEntry
	{
		private DataTable _lastActionList;		//当前在列表框中的数据,为了实现快速刷新,

		private int _curSelRow;					//当前选中的Row			-1为未选中
		private int _curSelActionNum;			//当前选中的ActionNum	-1为未选中
		private bool _curSelIsTeamA;			//当前选中的为TeamA的内容
		
		
		private bool dgvActionListInit()
		{
			m_gridFont_Err = new Font(new FontFamily("Arial"), 10, FontStyle.Bold | FontStyle.Strikeout);

			m_clrDgvActionFore = new Color[11] 
			{	
				//不同动作的不同颜色取值, 值的定义在存储过程里
				Color.FromArgb(255, 255, 255),		// 0 无动作时,正常应该用不到,以下的,都是通过数据库直接索引的
				Color.FromArgb( 20,  63, 163),		// 1 未得失分			
				Color.FromArgb( 56, 146,  68),		// 2 得分 189,13,44
				Color.FromArgb( 56, 146,  68),		// 3 失分
				Color.FromArgb( 29, 121, 141),		// 4 队员上场
				Color.FromArgb( 29, 121, 101),		// 5 队员下场
				Color.FromArgb(120,  63, 163),		// 6 自由人上场

				Color.FromArgb(120,  63, 123),		// 7 自由人下场

				Color.FromArgb( 30, 239, 248),		// 8 出错的			以上的,都是通过数据库直接索引的
				Color.Silver,						// 9 被选中的

				Color.FromArgb(194, 217, 247),		// 10 分割线
			};

			//初始化列表框
			dgvActionList.ReadOnly = true;
			dgvActionList.RowHeadersVisible = false;
			Font gridFont = new Font(new FontFamily("Arial"), 10, FontStyle.Bold );
			dgvActionList.Font = gridFont;

			dgvActionList.SelectionMode = DataGridViewSelectionMode.CellSelect;
			dgvActionList.MultiSelect = false;
			dgvActionList.AllowUserToResizeRows = false;
			dgvActionList.AllowUserToOrderColumns = false;
			dgvActionList.AllowUserToResizeColumns = false;
			dgvActionList.AllowDrop = true;
			dgvActionList.AllowUserToAddRows = false;
			dgvActionList.AllowUserToDeleteRows = false;
			dgvActionList.ColumnHeadersVisible = false;
			dgvActionList.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.None;
			dgvActionList.AdvancedCellBorderStyle.All = DataGridViewAdvancedCellBorderStyle.None;
			dgvActionList.ScrollBars = ScrollBars.Vertical;

			//奇偶行颜色,分别设置
			dgvActionList.AlternatingRowsDefaultCellStyle.BackColor = m_clrDgvActionFore[ActClr_Null];
			dgvActionList.AlternatingRowsDefaultCellStyle.SelectionForeColor = Color.Black;
			dgvActionList.AlternatingRowsDefaultCellStyle.SelectionBackColor = m_clrDgvActionFore[ActClr_Null];

			//奇偶行颜色,分别设置
			dgvActionList.DefaultCellStyle.BackColor = m_clrDgvActionFore[ActClr_Null];
			dgvActionList.DefaultCellStyle.SelectionForeColor = Color.Black;
			dgvActionList.DefaultCellStyle.SelectionBackColor = m_clrDgvActionFore[ActClr_Null];

			dgvActionList.Rows.Clear();
			dgvActionList.Columns.Clear();

			dgvActionList.Columns.Add("CodeA", "CodeA");
			dgvActionList.Columns.Add("BibA", "BibA");
			dgvActionList.Columns.Add("NameA", "NameA");
			dgvActionList.Columns.Add("ScoreAcdA", "ScoreAcdA");
			dgvActionList.Columns.Add("Rally", "Rally");
			dgvActionList.Columns.Add("ScoreAcdB", "ScoreAcdB");
			dgvActionList.Columns.Add("CodeB", "CodeB");
			dgvActionList.Columns.Add("BibB", "BibB");
			dgvActionList.Columns.Add("NameB", "NameB");

			dgvActionList.Columns["CodeA"].Width = 80;
			dgvActionList.Columns["BibA"].Width = 25;
			dgvActionList.Columns["NameA"].Width = 120;
			dgvActionList.Columns["ScoreAcdA"].Width = 45;
			dgvActionList.Columns["Rally"].Width = 25;
			dgvActionList.Columns["ScoreAcdB"].Width = 45;
			dgvActionList.Columns["CodeB"].Width = 80;
			dgvActionList.Columns["BibB"].Width = 25;
			dgvActionList.Columns["NameB"].Width = 120;

			dgvActionList.Columns["Rally"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
			dgvActionList.Columns["BibA"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
			dgvActionList.Columns["BibB"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;

			dgvActionList.Columns["ScoreAcdA"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
			dgvActionList.Columns["ScoreAcdB"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;

			//Clear history data.
			_lastActionList = null;

			_curSelRow = -1;
			_curSelActionNum = -1;
			_curSelIsTeamA = true;
			
			return true;
		}

		public bool statInfoReferesh()
		{
			//此函数功能是刷新界面中所有技术统计类控件
			//在切换比赛，切换Tab，有动作删除，添加时都会调用

			//获取新数据,这个数据包含3个表
			DataSet dataAction = Common.dbActionListGetList( Common.g_nMatchID, GetStatCurSet() );
			DataTable tblActionList = dataAction != null && dataAction.Tables.Count > 0 ? dataAction.Tables[0] : null;
			DataTable tblPositionA  = dataAction != null && dataAction.Tables.Count > 1 ? dataAction.Tables[1] : null;
			DataTable tblPositionB  = dataAction != null && dataAction.Tables.Count > 2 ? dataAction.Tables[2] : null;

			bool bRet = true;

			//主界面上的ActionList
			bRet &= dgvActionListRefresh(tblActionList);
	
			//技术统计界面的东东
			if (_tabMain.SelectedTab == _tabHeaderTeamA)
			{
				bRet &= btnStatEntryPlayersOnCourtRefresh(tblPositionA);
			}
			else
			if (_tabMain.SelectedTab == _tabHeaderTeamB)
			{
				bRet &= btnStatEntryPlayersOnCourtRefresh(tblPositionB);
			}

			btnStatEntryCancel_Click(btnStatEntryCancel, new EventArgs()); //点击取消按钮，把STAT按钮状态恢复

			return bRet;
		}

		private bool dgvActionListSetCurSelMarkColor(int selRow, bool selTeamA, int actionNum, bool selMark)
		{
			if (selRow >= dgvActionList.RowCount || actionNum <= 0 )
			{
				return false;
			}

			object objTag = dgvActionList[selTeamA ? "CodeA" : "CodeB", selRow].Tag;
			if (objTag == null || Common.Str2Int(objTag) != actionNum )
			{
				return false;
			}

			dgvActionList[selTeamA ? "CodeA" : "CodeB", selRow].Style.BackColor = selMark ? m_clrDgvActionBackSelection : m_clrDgvActionBack;
			dgvActionList[selTeamA ? "BibA" : "BibB", selRow].Style.BackColor = selMark ? m_clrDgvActionBackSelection : m_clrDgvActionBack;
			dgvActionList[selTeamA ? "NameA" : "NameB", selRow].Style.BackColor = selMark ? m_clrDgvActionBackSelection : m_clrDgvActionBack;

			return true;
		}

		private bool dgvActionListRefresh(DataTable tblActionList)
		{
			//错误检测
			if (tblActionList == null)
			{
				Debug.Assert(false);
				return false;
			}

			//如果记录集为空,特殊处理
			//直接清空列表,清空记录
			if (tblActionList.Rows.Count == 0)
			{
				_lastActionList = null;

				_curSelRow = -1;
				_curSelActionNum = -1;
				_curSelIsTeamA = true;
				
				dgvActionList.Rows.Clear();
				return true;
			}

			//开始刷新
			dgvActionList.SuspendLayout();

			//填入数据
			int nCurRowInList = 0;
			int nCurRowInData = 0;
			while( nCurRowInData < tblActionList.Rows.Count )
			{
				if ( _lastActionList != null && _lastActionList.Rows.Count >= nCurRowInData + 1 && 
					 Common.isEqualDataRow(_lastActionList.Rows[nCurRowInData], tblActionList.Rows[nCurRowInData], tblActionList.Columns.Count)
				   )
				{
					//把新记录每一行与Last记录每一行进行对应,同时位移列表的坐标
					//如果是Rally最后一行,占2行，否则占一行
					if (tblActionList.Rows[nCurRowInData]["F_IsLastRowInRally"] != DBNull.Value)
					{
						nCurRowInList += 2;
					}
					else
					{
						nCurRowInList += 1;
					}

					nCurRowInData++;
					continue;
				}
				else
				{
					//跳出While
					break;
				}
			}

			//发现一行不一致的,或者多出来,将列表中此行及以下全都删去，重新添加
			while (dgvActionList.Rows.Count > nCurRowInList)
			{
				dgvActionList.Rows.RemoveAt(dgvActionList.Rows.Count - 1);
			}

			//从对比后的最后一行,到数据源最后一行,加入到列表
			for (int cycRowData = nCurRowInData; cycRowData < tblActionList.Rows.Count; cycRowData++)
			{
				int cycRowList = dgvActionList.Rows.Add();
				
				dgvActionList.Rows[cycRowList].Tag = cycRowData;
				dgvActionList.Rows[cycRowList].Height = 17;

				try
				{
					dgvActionList["CodeA", cycRowList].Value = tblActionList.Rows[cycRowData]["F_ActionCode_A"].ToString();
					dgvActionList["CodeB", cycRowList].Value = tblActionList.Rows[cycRowData]["F_ActionCode_B"].ToString();
					dgvActionList["BibA", cycRowList].Value = tblActionList.Rows[cycRowData]["F_Bib_A"].ToString();
					dgvActionList["BibB", cycRowList].Value = tblActionList.Rows[cycRowData]["F_Bib_B"].ToString();
					dgvActionList["NameA", cycRowList].Value = tblActionList.Rows[cycRowData]["F_ShortName_A"].ToString();
					dgvActionList["NameB", cycRowList].Value = tblActionList.Rows[cycRowData]["F_ShortName_B"].ToString();

					//Code.Tag 放ActionNumberID
					if (tblActionList.Rows[cycRowData]["F_ActionNumID_A"].ToString() != "")
					{
						dgvActionList["CodeA", cycRowList].Tag = Common.Str2Int(tblActionList.Rows[cycRowData]["F_ActionNumID_A"]);
					}

					if (tblActionList.Rows[cycRowData]["F_ActionNumID_B"].ToString() != "")
					{
						dgvActionList["CodeB", cycRowList].Tag = Common.Str2Int(tblActionList.Rows[cycRowData]["F_ActionNumID_B"]);
					}

					//根据F_ActionKindID的值,设置双方Action的背景色
					int nActionKindID_A = Common.Str2Int(tblActionList.Rows[cycRowData]["F_ActionKindID_A"]);
					int nActionKindID_B = Common.Str2Int(tblActionList.Rows[cycRowData]["F_ActionKindID_B"]);

					if (nActionKindID_A >= 0 && nActionKindID_A <= 8)
					{
						dgvActionList["CodeA", cycRowList].Style.ForeColor = m_clrDgvActionFore[nActionKindID_A];
						dgvActionList["BibA", cycRowList].Style.ForeColor = m_clrDgvActionFore[nActionKindID_A];
						dgvActionList["NameA", cycRowList].Style.ForeColor = m_clrDgvActionFore[nActionKindID_A];
						dgvActionList["CodeA", cycRowList].Style.BackColor = m_clrDgvActionFore[ActClr_Null];

						dgvActionList["Rally", cycRowList].Style.BackColor = m_clrDgvActionFore[ActClr_Split];
					}

					if (nActionKindID_B >= 0 && nActionKindID_B <= 8)
					{
						dgvActionList["CodeB", cycRowList].Style.ForeColor = m_clrDgvActionFore[nActionKindID_B];
						dgvActionList["BibB", cycRowList].Style.ForeColor = m_clrDgvActionFore[nActionKindID_B];
						dgvActionList["NameB", cycRowList].Style.ForeColor = m_clrDgvActionFore[nActionKindID_B];

						dgvActionList["Rally", cycRowList].Style.BackColor = m_clrDgvActionFore[ActClr_Split];
					}

					if (tblActionList.Rows[cycRowData]["F_ActionIsError_A"] != DBNull.Value)
					{
						dgvActionList["BibA", cycRowList].Style.Font = m_gridFont_Err;
						dgvActionList["BibA", cycRowList].Style.Font = m_gridFont_Err;
						dgvActionList["CodeA", cycRowList].Style.Font = m_gridFont_Err;
						dgvActionList["BibA", cycRowList].Style.Font = m_gridFont_Err;
						dgvActionList["NameA", cycRowList].Style.Font = m_gridFont_Err;
					}

					if (tblActionList.Rows[cycRowData]["F_ActionIsError_B"] != DBNull.Value)
					{
						dgvActionList["BibB", cycRowList].Style.Font = m_gridFont_Err;
						dgvActionList["CodeB", cycRowList].Style.Font = m_gridFont_Err;
						dgvActionList["BibB", cycRowList].Style.Font = m_gridFont_Err;
						dgvActionList["NameB", cycRowList].Style.Font = m_gridFont_Err;
					}

					//添加Rally信息, 包括下面的横线,是否为红色等
					if (tblActionList.Rows[cycRowData]["F_IsLastRowInRally"] != DBNull.Value)
					{
						//双方计算比分不同,变红色
						if (tblActionList.Rows[cycRowData]["F_ScoreAbEquel"].ToString() == "0")
						{
							dgvActionList["Rally", cycRowList].Style.BackColor = m_clrDgvActionScoreInCorrect;
							dgvActionList["ScoreAcdA", cycRowList].Style.BackColor = m_clrDgvActionScoreInCorrect;
							dgvActionList["ScoreAcdB", cycRowList].Style.BackColor = m_clrDgvActionScoreInCorrect;

							dgvActionList["ScoreAcdA", cycRowList].Value = tblActionList.Rows[cycRowData]["F_ScoreAccord_A"].ToString();
							dgvActionList["ScoreAcdB", cycRowList].Value = tblActionList.Rows[cycRowData]["F_ScoreAccord_B"].ToString();
						}
						else
						if (tblActionList.Rows[cycRowData]["F_ScoreAbEquel"].ToString() == "1")
						{
							if (tblActionList.Rows[cycRowData]["F_RallyEffect"].ToString() == "1")
							{
								dgvActionList["ScoreAcdA", cycRowList].Style.BackColor = m_clrDgvActionScoreWin;
								dgvActionList["ScoreAcdB", cycRowList].Style.BackColor = m_clrDgvActionScoreLost;

								dgvActionList["ScoreAcdA", cycRowList].Value = tblActionList.Rows[cycRowData]["F_ScoreAccord_A"].ToString();

							}
							else
							if (tblActionList.Rows[cycRowData]["F_RallyEffect"].ToString() == "2")
							{
								dgvActionList["ScoreAcdA", cycRowList].Style.BackColor = m_clrDgvActionScoreLost;
								dgvActionList["ScoreAcdB", cycRowList].Style.BackColor = m_clrDgvActionScoreWin;
								dgvActionList["ScoreAcdB", cycRowList].Value = tblActionList.Rows[cycRowData]["F_ScoreAccord_B"].ToString();
							}
							else
							{
								dgvActionList["ScoreAcdA", cycRowList].Style.BackColor = m_clrDgvActionScoreInCorrect;
								dgvActionList["ScoreAcdB", cycRowList].Style.BackColor = m_clrDgvActionScoreInCorrect;

								dgvActionList["ScoreAcdA", cycRowList].Value = tblActionList.Rows[cycRowData]["F_ScoreAccord_A"].ToString();
								dgvActionList["ScoreAcdB", cycRowList].Value = tblActionList.Rows[cycRowData]["F_ScoreAccord_B"].ToString();
							}
						}
						else
						if (tblActionList.Rows[cycRowData]["F_RallyNum"].ToString() == "0")
						{

						}

						dgvActionList["Rally", cycRowList].Value = tblActionList.Rows[cycRowData]["F_RallyNum"].ToString();

						//添加分割线
						cycRowList = dgvActionList.Rows.Add();
						dgvActionList.Rows[cycRowList].Tag = null;
						dgvActionList.Rows[cycRowList].Height = 1;

						for (int nCol = 0; nCol < dgvActionList.Columns.Count; nCol++)
						{
							dgvActionList[nCol, cycRowList].Style.BackColor = m_clrDgvActionFore[ActClr_Split];
						}
					}
				}
				catch (Exception e)
				{
					MessageBox.Show(e.ToString());
					dgvActionList.Rows.Clear();
					dgvActionList.ResumeLayout();
					return false;
				}
			}

			//清空所有选中信息
			for (int nRow = 0; nRow < dgvActionList.RowCount; nRow++)
			{
				//don't mention split.
				if (dgvActionList.Rows[nRow].Height <= 3)
				{
					continue;
				}

				if (dgvActionList["CodeA", nRow].Style.BackColor != m_clrDgvActionBack)
				{
					dgvActionList["CodeA", nRow].Style.BackColor = m_clrDgvActionBack;
					dgvActionList["BibA", nRow].Style.BackColor = m_clrDgvActionBack;
					dgvActionList["NameA", nRow].Style.BackColor = m_clrDgvActionBack;
				}

				if (dgvActionList["CodeB", nRow].Style.BackColor != m_clrDgvActionBack)
				{
					dgvActionList["CodeB", nRow].Style.BackColor = m_clrDgvActionBack;
					dgvActionList["BibB", nRow].Style.BackColor = m_clrDgvActionBack;
					dgvActionList["NameB", nRow].Style.BackColor = m_clrDgvActionBack;
				}
			}

			//恢复以前选择
			if (dgvActionList.RowCount > 0 && _curSelRow >= 0) //以前有选择,那就尝试恢复之前选择,
			{
				bool bSelected = false;

				if (!bSelected && dgvActionListSetCurSelMarkColor(_curSelRow, _curSelIsTeamA, _curSelActionNum, true))
				{
					//以前的行没变,直接恢复
					bSelected = true;
				}

				if (!bSelected)
				{
					//尝试寻找之前的动作
					for (int nRow = 0; nRow < dgvActionList.Rows.Count; nRow++)
					{
						if (dgvActionList[_curSelIsTeamA ? "CodeA" : "CodeB", nRow].Tag != null &&
							Common.Str2Int(dgvActionList[_curSelIsTeamA ? "CodeA" : "CodeB", nRow].Tag) == _curSelActionNum)
						{
							if (dgvActionListSetCurSelMarkColor(nRow, _curSelIsTeamA, _curSelActionNum, true))
							{
								_curSelRow = nRow;
								bSelected = true;
							}

							break;
						}
					}
				}

				if (!bSelected)
				{
					//尝试选相同队的那行位置下有条目的行,因为那行内容估计是删除了
					for (int nRow = _curSelRow; nRow >= 0 && nRow < dgvActionList.RowCount; nRow++)
					{
						if (dgvActionList[_curSelIsTeamA ? "CodeA" : "CodeB", nRow].Tag != null)
						{
							int newActionNum = Common.Str2Int(dgvActionList[_curSelIsTeamA ? "CodeA" : "CodeB", nRow].Tag);
							if (dgvActionListSetCurSelMarkColor(nRow, _curSelIsTeamA, newActionNum, true))
							{
								_curSelRow = nRow;
								_curSelActionNum = newActionNum;
								bSelected = true;
							}

							break;
						}
					}
				}

				if (!bSelected)
				{
					//尝试选相同队的那行位置上有条目的行,因为那行内容估计是删除了
					for (int nRow = _curSelRow - 1; nRow >= 0 && nRow < dgvActionList.RowCount; nRow--)
					{
						if (dgvActionList[_curSelIsTeamA ? "CodeA" : "CodeB", nRow].Tag != null)
						{
							int newActionNum = Common.Str2Int(dgvActionList[_curSelIsTeamA ? "CodeA" : "CodeB", nRow].Tag);
							if (dgvActionListSetCurSelMarkColor(nRow, _curSelIsTeamA, newActionNum, true))
							{
								_curSelRow = nRow;
								_curSelActionNum = newActionNum;
								bSelected = true;
							}

							break;
						}
					}
				}

				//应该是没有内容了,放弃选择
				if (!bSelected)
				{
					_curSelRow = -1;
					_curSelIsTeamA = true;
					_curSelActionNum = 0;
				}
			}


			//控制显示位置
			if (dgvActionList.RowCount > 0)
			{
				if (_tabMain.SelectedTab == _tabHeaderTeamA) //在TeamA标签下,显示出TeamA最后一行
				{
					//寻找最后一行的有内容TeamA,并显示出来
					for (int nRow = dgvActionList.Rows.Count - 1; nRow >= 0; nRow--)
					{
						if (dgvActionList["CodeA", nRow].Tag != null)
						{
							nRow -= 15;	//最后一行上面显示10行
							nRow = System.Math.Max(0, nRow);
							dgvActionList.FirstDisplayedScrollingRowIndex = nRow;
							break;
						}
					}
				}
				else if (_tabMain.SelectedTab == _tabHeaderTeamB) //在TeamB标签下,显示出TeamB最后一行
				{
					//寻找最后一行的有内容TeamB,并显示出来
					for (int nRow = dgvActionList.Rows.Count - 1; nRow >= 0; nRow--)
					{
						if (dgvActionList["CodeB", nRow].Tag != null)
						{
							nRow -= 15;	//最后一行上面显示10行
							nRow = System.Math.Max(0, nRow);
							dgvActionList.FirstDisplayedScrollingRowIndex = nRow;
							break;
						}
					}
				}
				else if (_curSelRow >= 0) //Double, Score页, 插入,显示选中行
				{
					int nFirstDisplayRow = _curSelRow - 15;
					nFirstDisplayRow = System.Math.Max(0, nFirstDisplayRow);
					dgvActionList.FirstDisplayedScrollingRowIndex = nFirstDisplayRow;
				}
				else //Common页,非插入,显示最后
				{
					dgvActionList.FirstDisplayedScrollingRowIndex = dgvActionList.RowCount - 1;
				}
			}

			dgvActionList.ResumeLayout();

			_lastActionList = tblActionList;

			return true;
		}


		//设置背景色

		private Color m_clrDgvActionBack = Color.FromArgb(255, 255, 255);
		private Color m_clrDgvActionBackSelection = Color.FromArgb(255, 255, 0);

		private Color m_clrDgvActionScoreWin = Color.FromArgb(120, 255, 120);
		private Color m_clrDgvActionScoreLost = Color.White;

//		private Color m_clrDgvActionScoreCorrect = Color.FromArgb(120, 255, 120);
		private Color m_clrDgvActionScoreInCorrect = Color.FromArgb(255, 100, 80);


		//方便索引各种颜色用的,顺序不可改变,应该对应了数据库中ID标识
		private const Int32 ActClr_Null = 0;
		private const Int32 ActClr_Normal = 1;
		private const Int32 ActClr_ScoreGet = 2;
		private const Int32 ActClr_ScoreLost = 3;
		private const Int32 ActClr_PlayerIn = 4;
		private const Int32 ActClr_PlayerOut = 5;
		private const Int32 ActClr_LibIn = 6;
		private const Int32 ActClr_LibOut = 7;
		private const Int32 ActClr_Error = 8;
		private const Int32 ActClr_Selection = 9;
		private const Int32 ActClr_Split = 10;

		private Color[] m_clrDgvActionFore;
		private Font m_gridFont_Err;
	}
}
