using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

using AutoSports.OVRCommon;
using System.Windows.Forms;
using System.Data;

namespace AutoSports.OVRVBPlugin
{
    public class OVRVOPlugin : OVRPluginBase
    {
        private frmOVRVODataEntry m_frmPlugin = null;
  
        public OVRVOPlugin()
        {		
            m_frmPlugin = new frmOVRVODataEntry();
            m_frmPlugin.TopLevel = false;
            m_frmPlugin.Dock = DockStyle.Fill;
            m_frmPlugin.FormBorderStyle = FormBorderStyle.None;

			//为了一个程序同时兼容VB,BV
			//DLL在加载时,通过判断自己的名字,产生对VB或者BV的支持
			Type type = typeof(OVRVOPlugin);
			string strDllPath = type.Assembly.ManifestModule.FullyQualifiedName;
			string strDllName = System.IO.Path.GetFileNameWithoutExtension(strDllPath);


			Common.g_isVB = strDllName != "BV";
			Common.g_strDisplnName = Common.g_isVB ? "Volleyball" : "Beach Volleyball";
			Common.g_strSectionName = Common.g_isVB ? "OVRVBPlugin" : "OVRBVPlugin";

			base.m_strDiscCode = Common.g_isVB ? strDllName : "BV"; //VB,VO都有可能,所以和DLL文件名保持一致
			base.m_strName = Common.g_strSectionName;
        }

        public string GetSectionName()
        {
			return Common.g_strSectionName;
        }

		public override System.Windows.Forms.Control GetModuleUI
		{
			get { return m_frmPlugin as System.Windows.Forms.Control; }
		}

        public override Boolean Initialize(System.Data.SqlClient.SqlConnection con)
        {
            Common.g_Plugin = this;
			Common.g_DataBaseCon = con;

			string strDiscCode = "VO";
			string strLangCode = "ENG";
			DataTable tbl = Common.dbPlugInSetting();
			if (tbl == null)
			{
				MessageBox.Show("Get PlugIn default setting failed, we will use VO,ENG");
			}
			else
			{
				strDiscCode = tbl.Rows[0]["F_DiscCode"].ToString();
				strLangCode = tbl.Rows[0]["F_LanguageCode"].ToString();
			}

			Common.g_strLanguage = strLangCode;

			
			//初始化比赛计分模块
			Common.g_Game = new GameGeneralBall();
			Common.g_Game.SetRuleModel(Common.g_isVB ? EGbGameType.emGameVolleyBall : EGbGameType.emGameBeachVolleyBall);

            return true;
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            switch (e.Type)
            {
				case OVRMgr2PluginEventType.emMatchSelected:	//选择比赛时
                {
					if (m_frmPlugin.Enabled)
					{
						if (MessageBox.Show("直接切换比赛?", "切换比赛", MessageBoxButtons.OKCancel, MessageBoxIcon.Question) != DialogResult.OK)
						{
							return;
						}
					}

					int nMatchID = Common.Str2Int(e.Args.ToString());
					if (nMatchID <= 0)
					{
						Debug.Assert(false);
						return;
					}

					DataTable tblMatch = Common.dbGetMatchInfo(nMatchID, Common.g_strLanguage);
					if (tblMatch == null || tblMatch.Rows.Count < 1 || tblMatch.Columns.Count < 1)
					{
						MessageBox.Show("exec proc_VB_PRG_MatchInfo failed.\n读取新比赛基础数据失败! 未切换比赛!");
						return;
					}

					Int32 nDisciplineID = Common.Str2Int(tblMatch.Rows[0]["F_DisciplineID"]);
					Int32 nEventID = Common.Str2Int(tblMatch.Rows[0]["F_EventID"]);
					Int32 nTeamRegIDA = Common.Str2Int(tblMatch.Rows[0]["F_TeamARegID"]);
					Int32 nTeamRegIDB = Common.Str2Int(tblMatch.Rows[0]["F_TeamBRegID"]);
					String strTeamANoc = tblMatch.Rows[0]["F_TeamANoc"].ToString();
					String strTeamBNoc = tblMatch.Rows[0]["F_TeamBNoc"].ToString();
					String strTeamAName = tblMatch.Rows[0]["F_TeamAName"].ToString();
					String strTeamBName = tblMatch.Rows[0]["F_TeamBName"].ToString();
					String strVenue = tblMatch.Rows[0]["F_VenueDes"].ToString();

					if ( nDisciplineID <=0 || nEventID <= 0 )
					{
						MessageBox.Show("SprotID,nDispID,nEventID不正确! 未切换比赛!");
						return;
					}

					if ( nTeamRegIDA <= 0 || nTeamRegIDB <= 0 )
					{
						MessageBox.Show("该场比赛未指派双方队伍! 未切换比赛!");
						return;
					}

					if (strVenue.Length == 0)
					{
						if (MessageBox.Show("该比赛未指定场馆,是否继续?", "切换比赛", MessageBoxButtons.OKCancel, MessageBoxIcon.Question) != DialogResult.OK)
						{
							return;
						}
					}

					//如果是新建比赛,通过GameObject写入一次库
					int nCretaeMatchResult = Common.dbInitMatch(nMatchID, 5, false);
					if (nCretaeMatchResult == 0)
					{
						MessageBox.Show("exec proc_VB_PRG_MatchCreate failed.\n在数据库中初始化新比赛局信息失败! 未切换比赛!");
						return;
					}
					else if (nCretaeMatchResult == 1)
					{
						GameGeneralBall newGameObj = new GameGeneralBall();
						if (!Common.dbGetMatch2GameObj(nMatchID, ref newGameObj))
						{
							MessageBox.Show("exec proc_VB_PRG_MatchInfo failed.\n读取新比赛比分数据失败! 未切换比赛!");
							//以后改成强行重置选项
							return;
						}

						//再往库中写一次，是为了避免第一次进入比赛后，没有局标示的问题5
						if (!Common.dbGameObj2Db(nMatchID, newGameObj))
						{
							MessageBox.Show("exec proc_VB_PRG_MatchSetScore failed.\n写入新比分数据失败! 未切换比赛!");
							return;
						}
					}

					GameGeneralBall gameObj = new GameGeneralBall();
					if (!Common.dbGetMatch2GameObj(nMatchID, ref gameObj))
					{
						MessageBox.Show("exec proc_VB_PRG_MatchInfo failed.\n读取比赛比分数据失败! 未切换比赛!");
						return;
					}

					//开始切换比赛
					Common.g_Game = gameObj;
					Common.g_nDiscID = nDisciplineID;
					Common.g_nEventID = nEventID;
					Common.g_nMatchID = nMatchID;
					Common.g_nTeamRegIDA = nTeamRegIDA;
					Common.g_nTeamRegIDB = nTeamRegIDB;
					Common.g_strNocA = strTeamANoc;
					Common.g_strNocB = strTeamBNoc;

					SetReportContext("MatchID", Common.g_nMatchID.ToString());
					
					m_frmPlugin.OnMatchChanged(0);
					
                    break;
                }
                case OVRMgr2PluginEventType.emRptContextQuery:
                {
					if (e == null || e.Args == null)
					{
						return;
					}

					OVRReportContextQueryArgs rptQuery = e.Args as OVRReportContextQueryArgs;

					switch (rptQuery.Name)
					{
						case "MatchID":
							{
								rptQuery.Value = Common.g_nMatchID.ToString();
								rptQuery.Handled = true;
							}
							break;

						case "DisciplineID":
							{
								rptQuery.Value = Common.g_nDiscID.ToString();
								rptQuery.Handled = true;
							}
							break;
						default:
							break;
					}

                    break;
                }
            }
        }
    }
}
