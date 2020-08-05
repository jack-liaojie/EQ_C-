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

/*
	1-10:		Number 1-10
	q-p:		Number 11-20
	Esc:		清空输入				Esc
	A:			Team fault				A
	S:			OPP Err					S
	Z:			Delete last action		Z
	V:			队员商场				V3
	C:			换人					C32		C89 换人,8号下,9号上
	G:			ATK						1G+		1号进攻得分
	H:			BLO						2H-		2号拦网失败
	J:			SRV
	K:			DIG
	L:			SET
	;:			RCV
	+			SUC & EXC
	-			FLT
    ?			显示Help信息
 */
namespace AutoSports.OVRVBPlugin
{
	public partial class frmOVRVODataEntry
	{
		private int GetStatCurSet()
		{
			if (this.btnsStatSet1.Checked)
			{
				return 1;
			}
			if (this.btnsStatSet2.Checked)
			{
				return 2;
			}
			if (this.btnsStatSet3.Checked)
			{
				return 3;
			}
			if (this.btnsStatSet4.Checked)
			{
				return 4;
			}
			if (this.btnsStatSet5.Checked)
			{
				return 5;
			}
			else
			{
				return Common.g_Game.GetCurSet();
			}
		}

		private string GetRegBibFromKeyBoard(string strKey)
		{
			switch (strKey)
			{
				case "1":
					return "1";

				case "2":
					return "2";

				case "3":
					return "3";

				case "4":
					return "4";

				case "5":
					return "5";

				case "6":
					return "6";

				case "7":
					return "7";

				case "8":
					return "8";

				case "9":
					return "9";

				case "0":
					return "10";

				case "q":
				case "Q":
					return "11";

				case "w":
				case "W":
					return "12";

				case "e":
				case "E":
					return "13";

				case "r":
				case "R":
					return "14";

				case "t":
				case "T":
					return "15";

				case "y":
				case "Y":
					return "16";

				case "u":
				case "U":
					return "17";

				case "i":
				case "I":
					return "18";

				case "o":
				case "O":
					return "19";

				case "p":
				case "P":
					return "20";
			}

			return "";
		}

		private int GetRegIdFromBib(string strBib, out bool bIsLibero)
		{	
			DataGridView view = (_tabMain.SelectedTab == _tabHeaderTeamB) ? this.dgvPlayerListB : this.dgvPlayerListA;
			for (int i = 0; i < view.RowCount; i++)
			{
				for (int j = 0; j < view.ColumnCount; j++)
				{
					if (((view[j, i] != null) && (view[j, i].Value != null)) && (view[j, i].Value.ToString() == strBib))
					{
						object tag = view[j, i].Tag;
						if (tag != null)
						{
							bIsLibero = Convert.ToBoolean(((DataRow)tag)["F_IsLibero"]);
							return Common.Str2Int(((DataRow)tag)["F_RegisterID"].ToString());
						}
						bIsLibero = false;
						return 0;
					}
				}
			}

			bIsLibero = false;
			return 0;
		}

		private void textBoxStat_KeyUp(object sender, KeyEventArgs e)
		{
			////Esc: 清空输入框,退出
			////Enter:进行判断
			if (e.KeyCode == Keys.Escape)
			{
				textBoxStat.Text = "";
				return;
			}
			else if (e.KeyCode != Keys.Return)
			{
				return;
			}

			////开始处理
			string strN1 = (textBoxStat.Text.Length >= 1) ? textBoxStat.Text.Substring(0, 1) : "";
			string strN2 = (textBoxStat.Text.Length >= 2) ? textBoxStat.Text.Substring(1, 1) : "";
			string strN3 = (textBoxStat.Text.Length >= 3) ? textBoxStat.Text.Substring(2, 1) : "";
			bool bIsTeamB = _tabMain.SelectedTab == _tabHeaderTeamB;
				strN1 = strN1.ToUpper();
				strN2 = strN2.ToUpper();
				strN3 = strN3.ToUpper();

			
			if (strN1 == "")
			{
				labStatEntryErrMsg.Text = "内容为空,请先输入内容";
				return;
			}

			if (strN1 == "?" || strN1 == "/")
			{
				string strHelp =
@"
Code	Desc.		Example
1-10:	队员号码 1-10
q-p:	队员号码 11-20
Esc:	清空输入
A:	整队失败
S:	对方失误
D:	交换操作队
Z:	删除最后一条技术统计
V:	队员上场	V3:3号上场
C:	换人	C32:换人,3号下,2号上
G:	ATK		1G+:1号进攻得分
H:	BLO		2H-:2号拦网失败
J:	SRV
K:	DIG
L:	SET
;:	RCV
+	SUC & EXC
-	FLT
?	显示帮助信息
";
				MessageBox.Show(strHelp, "Help", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
				textBoxStat.Text = "";
				labStatEntryErrMsg.Text = "";
				return;
			}

			if (strN1 == "D") //换到另一方技术统计
			{
				_tabMain.SelectedTab = bIsTeamB ? _tabHeaderTeamA : _tabHeaderTeamB;
				
				textBoxStat.Text = "";
				labStatEntryErrMsg.Text = "";
				//statInfoReferesh();
				Common.dbMatchModifyTimeSet();
				
				return;
			}
			else if (strN1 == "A") // A:	TEM_FLT
			{
				if (Common.dbActionListAdd(Common.g_nMatchID, GetStatCurSet(), "TEM_FLT", -1, 0, bIsTeamB))
				{
					textBoxStat.Text = "";
					labStatEntryErrMsg.Text = "";

					OnStatChanged(bIsTeamB);
				}
				else
				{
					labStatEntryErrMsg.Text = string.Format("添加{0}方TEM_FLT失败!", bIsTeamB ? "B" : "A");
				}
				
				return;
			}
			else if (strN1 == "S") // S: OPP_ERR
			{
				if (Common.dbActionListAdd(Common.g_nMatchID, GetStatCurSet(), "OPP_ERR", -1, 0, bIsTeamB))
				{
					textBoxStat.Text = "";
					labStatEntryErrMsg.Text = "";

					OnStatChanged(bIsTeamB);
				}
				else
				{
					labStatEntryErrMsg.Text = string.Format("添加{0}方OPP_ERR失败!", bIsTeamB ? "B" : "A");
				}

				return;
			}
			else if (strN1 == "Z") // Z:	删除最后一条
			{
				string str4 = bIsTeamB ? "CodeB" : "CodeA";
				for (int i = dgvActionList.RowCount - 1; i >= 0; i--)
				{
					if ((dgvActionList[str4, i] != null) && (dgvActionList[str4, i].Tag != null))
					{
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
							textBoxStat.Text = "";
							labStatEntryErrMsg.Text = "";

							OnStatChanged(bIsTeamB);
						}

						return;
					}
				}

				labStatEntryErrMsg.Text = "删除最后一条技术统计失败! 未找到可删除的!";
				return;
			}
			else if (strN1 == "V")	//队员上场
			{
				if (strN2 == "")
				{
					labStatEntryErrMsg.Text = "未输入上场队员,无法上场!";
					return;
				}
				
				string bibIdInN2 = GetRegBibFromKeyBoard(strN2);
				if (bibIdInN2 == "")
				{
					labStatEntryErrMsg.Text = "上场队员BIB号输入有误,无法上场!";
					return;
				}
				
				bool isLiberoInN2;
				int nRegIdInN2 = GetRegIdFromBib(bibIdInN2, out isLiberoInN2);
				if (nRegIdInN2 <= 0)
				{
					labStatEntryErrMsg.Text = string.Format("未在{0}方找到BIB号为{1}的上场队员,无法上场!", bIsTeamB ? "B" : "A", bibIdInN2);
					return;
				}

				if (Common.dbActionListAdd(Common.g_nMatchID, GetStatCurSet(), isLiberoInN2 ? "LIB_IN" : "PLY_IN", nRegIdInN2, 0, bIsTeamB))
				{
					textBoxStat.Text = "";
					labStatEntryErrMsg.Text = "";

					OnStatChanged(bIsTeamB);
				}
				else
				{
					labStatEntryErrMsg.Text = "执行人员上场失败，无法上场!";
				}

				return;
			}
			else if (strN1 == "C") //换人
			{
				if (strN2 == "")
				{
					labStatEntryErrMsg.Text = "未输入下场队员,无法换人!";
					return;
				}

				if (strN3 == "")
				{
					labStatEntryErrMsg.Text = "未输入上场队员,无法换人!";
					return;
				}
				
				string strBibOut = GetRegBibFromKeyBoard(strN2);
				if (strBibOut == "")
				{
					labStatEntryErrMsg.Text = "下场队员BIB号输入有误,无法换人!";
					return;
				}

				string regBibIn  = GetRegBibFromKeyBoard(strN3);
				if (regBibIn == "")
				{
					labStatEntryErrMsg.Text = "上场队员BIB号输入有误,无法换人!";
					return;
				}

				bool isLiberoOut;
				int nRegIdOut = GetRegIdFromBib(strBibOut, out isLiberoOut);
				if (nRegIdOut <= 0)
				{
					labStatEntryErrMsg.Text = string.Format("未在{0}方找到BIB号为{1}的下场队员,无法换人!", bIsTeamB ? "B" : "A", strBibOut);
					return;
				}

				bool isLiberoIn;
				int nRegIdIn = GetRegIdFromBib(regBibIn, out isLiberoIn);
				if (nRegIdIn <= 0)
				{
					labStatEntryErrMsg.Text = string.Format("未在{0}方找到BIB号为{1}的上场队员,无法换人!", bIsTeamB ? "B" : "A", regBibIn);
					return;
				}

				if (isLiberoOut != isLiberoIn)
				{
					labStatEntryErrMsg.Text = "上下场人员身份不一致，无法换人!";
					return;
				}

				if (!Common.dbActionListAdd(Common.g_nMatchID, GetStatCurSet(), isLiberoOut ? "LIB_OUT" : "PLY_OUT", nRegIdOut, 0, bIsTeamB))
				{
					labStatEntryErrMsg.Text = "执行人员下场失败，无法换人!";
					return;
				}

				if (Common.dbActionListAdd(Common.g_nMatchID, GetStatCurSet(),  isLiberoIn ? "LIB_IN"  : "PLY_IN",  nRegIdIn,  0, bIsTeamB))
				{
					textBoxStat.Text = "";
					labStatEntryErrMsg.Text = "";

					OnStatChanged(bIsTeamB);
				}
				else
				{
					labStatEntryErrMsg.Text = "执行人员上场失败，无法换人!";
				}

				return;
			}
			
			//剩下的动作,第一位应为队员BIB号
			string strBibInN1 = GetRegBibFromKeyBoard(strN1);
			if (strBibInN1.Length == 0)
			{
				labStatEntryErrMsg.Text = "第一位代码不正确!";
				return;
			}

			bool isLiberoInN1 = false;
			int nRegIdInN1 = GetRegIdFromBib(strBibInN1, out isLiberoInN1);
			if (nRegIdInN1 <= 0)
			{
				labStatEntryErrMsg.Text = string.Format("未在{0}方找到BIB号为{1}的队员,无法添加技术统计!", bIsTeamB ? "B" : "A", strBibInN1);
				return;
			}

			//判断第二位是否为Acton
			if (strN2 == "G" || strN2 == "H" || strN2 == "J" || strN2 == "K" || strN2 == "L" || strN2 == ":" || strN2 == ";")
			{
				string strErrMsg;
				string actionCodeInN2 = _AnalyzeKeyCode_StatAction(strN2, strN3, out strErrMsg);
				if (actionCodeInN2 == null || actionCodeInN2.Length < 1)
				{
					labStatEntryErrMsg.Text = strErrMsg;
					return;
				}

				if (!Common.dbActionListAdd(Common.g_nMatchID, GetStatCurSet(), actionCodeInN2, nRegIdInN1, 0, bIsTeamB))
				{
					labStatEntryErrMsg.Text = string.Format("添加技术统计{0}方{1}号队员{2}动作失败!", bIsTeamB ? "B" : "A", strBibInN1, actionCodeInN2);
				}
				else
				{
					textBoxStat.Text = "";
					labStatEntryErrMsg.Text = "";

					OnStatChanged(bIsTeamB);
				}
			}
			else
			{
				labStatEntryErrMsg.Text = "代码不正确!";
			}
			
			return;
		}

		/// <summary>
		/// Analyze Key code about stat action
		/// H+  : BLO_SUC
		/// null: code is invalid
		/// </summary>
		/// <param name="charSecond"></param>
		/// <param name="charThird"></param>
		/// <returns></returns>
		private string _AnalyzeKeyCode_StatAction(string codeSecond, string codeThird, out string errMsg)
		{
			errMsg = "";
			if (codeSecond == null || codeSecond.Length < 1)
			{
				errMsg = "第二位动作代码不能为空";
				return null;
			}

			//根据第二位Code确定ActionCode的前半部分
			string strActionCode;
			bool bActionGetScore = false;

			switch (codeSecond.ToUpper())
			{
				case "G":	strActionCode = "ATK";	bActionGetScore = true;		break;
				case "H":	strActionCode = "BLO";	bActionGetScore = true;		break;
				case "J":	strActionCode = "SRV";	bActionGetScore = true;		break;
				case "K":	strActionCode = "DIG";	bActionGetScore = false;	break;
				case "L":	strActionCode = "SET";	bActionGetScore = false;	break;
				case ";":
				case ":":	strActionCode = "RCV";	bActionGetScore = false;	break;
				default:	errMsg = "第二位动作代码非技术统计类型";	return null;
			}

			//根据第三位Code确定ActionCode后边部分
			if (codeThird == null || codeThird == "")
			{
				strActionCode = strActionCode + "_CNT";
			}
			else if ((codeThird == "+") || (codeThird == "="))
			{
				strActionCode = strActionCode + (bActionGetScore ? "_SUC" : "_EXC");
			}
			else if ((codeThird == "_") || (codeThird == "-"))
			{
				strActionCode = strActionCode + "_FLT";
			}
			else
			{
				errMsg = "第三位动作结果代码不正确!";
				return null;
			}

			return strActionCode;
		}

		private void btnStatWorkType_Click(object sender, EventArgs e)
		{
			if (sender == btnStatWorkType)
			{
				return;
			}

			btnsStatAutoRefresh.Checked = false;
			btnsStatSet1.Checked = false;
			btnsStatSet2.Checked = false;
			btnsStatSet3.Checked = false;
			btnsStatSet4.Checked = false;
			btnsStatSet5.Checked = false;
			btnStatWorkType.ForeColor = Color.Blue;

			if (sender == btnsStatSet1)
			{
				btnStatWorkType.Text = "Set 1";
				btnsStatSet1.Checked = true;
				btnStatWorkType.ForeColor = Color.Red;
			}
			else if (sender == btnsStatSet2)
			{
				btnStatWorkType.Text = "Set 2";
				btnsStatSet2.Checked = true;
				btnStatWorkType.ForeColor = Color.Red;
			}
			else if (sender == btnsStatSet3)
			{
				btnStatWorkType.Text = "Set 3";
				btnsStatSet3.Checked = true;
				btnStatWorkType.ForeColor = Color.Red;
			}
			else if (sender == btnsStatSet4)
			{
				btnStatWorkType.Text = "Set 4";
				btnsStatSet4.Checked = true;
				btnStatWorkType.ForeColor = Color.Red;
			}
			else if (sender == btnsStatSet5)
			{
				btnStatWorkType.Text = "Set 5";
				btnsStatSet5.Checked = true;
				btnStatWorkType.ForeColor = Color.Red;
			}
			else //if (sender == btnsStatAutoRefresh)
			{
				btnStatWorkType.Text = "Auto refresh";
				btnsStatAutoRefresh.Checked = true;
				btnStatWorkType.ForeColor = Color.Blue;
			}

			statInfoReferesh();
		}
	}
}
