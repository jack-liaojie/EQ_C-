using System.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Diagnostics;
using System.Data.SqlClient;
using System.Windows.Forms;
using AutoSports.OVRCommon;


namespace AutoSports.OVRVBPlugin
{
    public class Common
    {
		public const Int32 STATUS_NOUSED = 0;
		public const Int32 STATUS_AVAILABLE = 10;
		public const Int32 STATUS_CONFIGURED = 20;
		public const Int32 STATUS_SCHEDULE = 30;
		public const Int32 STATUS_STARTLIST = 40;
		public const Int32 STATUS_RUNNING = 50;
		public const Int32 STATUS_SUSPEND = 60;
		public const Int32 STATUS_UNOFFICIAL = 100;
		public const Int32 STATUS_OFFICIAL = 110;
		public const Int32 STATUS_REVISION = 120;
		public const Int32 STATUS_CANCELED = 130;

		public static bool g_isVB;
		public static String g_strDisplnName;
		public static String g_strSectionName;
		public static String g_strLanguage;

        public static SqlConnection g_DataBaseCon;
        public static OVRVOPlugin g_Plugin;
		public static GameGeneralBall g_Game;

		public static Int32 m_nWndMode = 0;
		public static Int32 g_nDiscID = 0;
		public static Int32 g_nEventID = 0;
		public static Int32 g_nMatchID = 0;
		public static Int32 g_nTeamRegIDA = 0;
		public static Int32 g_nTeamRegIDB = 0;
		public static String g_strNocA;
		public static String g_strNocB;

		public static Int32 Str2Int(Object strObj)
		{
			return Str2Int(strObj, false);
		}
        public static Int32 Str2Int(Object strObj, bool bShowErrMsg)
        {
            if (strObj == null) return 0;

            try
            {
                return Convert.ToInt32(strObj);
            }
            catch (System.Exception errorFmt)
            {
				if (bShowErrMsg)
				{
					MessageBox.Show(errorFmt.ToString());
				}
            }
            return 0;
        }


		public static bool NotifyMatchStatus()
		{
			Common.g_Plugin.DataChangedNotify(OVRDataChangedType.emMatchStatus, -1, -1, -1, Common.g_nMatchID, Common.g_nMatchID, null);
			return true;
		}

		public static bool NotifyMatchResult()
		{
			//OVR_NOTIFY
			Common.g_Plugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, Common.g_nMatchID, Common.g_nMatchID, null);

			//OVR_DATA include matchScore
			Common.g_Plugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, Common.g_nMatchID, Common.g_nMatchID, dbMatchScoreInXml());

			return true;
		}

		public static DataTable dbGetMatchInfo(Int32 nMatchID, String strLangCode)
		{
			if (nMatchID <= 0 || strLangCode.Length == 0)
			{
				Debug.Assert(false);
				return null;
			}

			String strSql = String.Format("SELECT * FROM func_VB_RPG_MatchInfo('{0}', '{1}')", nMatchID, strLangCode);
			return dbGetTableRecord(strSql);
		}

		public static DataTable dbGetMatchStartList(bool bIsTeamA, int setNum)
		{
			if (Common.g_nMatchID <= 0 || Common.g_strLanguage.Length == 0)
			{
				Debug.Assert(false);
				return null;
			}

			String strSql = String.Format("exec proc_VB_PRG_MatchStartList {0}, {1}, '{2}', {3}", Common.g_nMatchID, bIsTeamA ? 1 : 2, Common.g_strLanguage, setNum);
			return dbGetTableRecord(strSql);
		}
		
		// 0: Failed
		// 1: Ok and created.
		// 2: Ok and the match has been already created.
		public static int dbInitMatch(Int32 nMatchID, Int32 nSetCount, bool bDelBeforeCreate)
		{
			if (nMatchID <= 0 || nSetCount <= 0 || nSetCount % 2 == 0 || nSetCount >= GameGeneralBall.MAX_SET)
			{
				Debug.Assert(false);
				return 0;
			}

			SqlCommand dbCmd = new SqlCommand("proc_VB_PRG_MatchCreate", g_DataBaseCon);
			dbCmd.CommandType = CommandType.StoredProcedure;
			dbCmd.Parameters.AddWithValue("@MatchID", nMatchID);
			dbCmd.Parameters.AddWithValue("@SetCount", nSetCount);
			dbCmd.Parameters.AddWithValue("@DeleteBeforeCreate", bDelBeforeCreate);
			dbCmd.Parameters.AddWithValue("@Result", DBNull.Value);
			dbCmd.Parameters["@Result"].Size = 4;
			dbCmd.Parameters["@Result"].SqlDbType = SqlDbType.Int;
			dbCmd.Parameters["@Result"].Direction = ParameterDirection.Output;

			if ( !dbExecuteNonQuery(ref dbCmd) )
			{
				return 0;
			}

			Int32 nRet = (int)dbCmd.Parameters["@Result"].Value;

			return nRet;
		}
		public static bool dbGetMatch2GameObj(Int32 nMatchID, ref GameGeneralBall gameObj)
		{
			if (nMatchID <= 0)
			{
				Debug.Assert(false);
				return false;
			}

			DataTable tbl = dbGetMatchInfo(nMatchID, g_strLanguage);
			if (tbl == null || tbl.Rows.Count < 1)
			{
				return false;
			}


			//开始读取记录			
			//先初始化Game
			gameObj.SetRuleModel(Common.g_isVB ? EGbGameType.emGameVolleyBall : EGbGameType.emGameBeachVolleyBall); 
			
			int nServe = Common.Str2Int(tbl.Rows[0]["F_Serve"]);
			int nCurSet = Common.Str2Int(tbl.Rows[0]["F_CurSet"]);
			if (nCurSet < 1 || nCurSet > GameGeneralBall.MAX_SET)
			{
				nCurSet = 1;
			}
			
			for(int nCycSet=1; nCycSet<=5; nCycSet++)
			{
				Int32 nSetTime = Common.Str2Int(tbl.Rows[0]["F_SetTime" + nCycSet.ToString() ]);
				Int32 nSetScoreA = Common.Str2Int(tbl.Rows[0]["F_PtsA"  + nCycSet.ToString() ]);
				Int32 nSetScoreB = Common.Str2Int(tbl.Rows[0]["F_PtsB"  + nCycSet.ToString() ]);
				if (nSetTime < 0 || nSetScoreA < 0 || nSetScoreB < 0)
				{
					Debug.Assert(false);
				}
				else
				{
					gameObj.SetScore(nSetScoreA, false, nCycSet);
					gameObj.SetScore(nSetScoreB, true, nCycSet);
					gameObj.SetTimeSet((nSetTime).ToString(), nCycSet);
				}
			}

			gameObj.SetServeTeamB(nServe == 1);
			gameObj.SetCurSet(nCurSet);

			string matchTime = tbl.Rows[0]["F_MatchTime"].ToString();
			gameObj.SetTimeMatch(matchTime);

			return true;
		}
		public static bool dbGameObj2Db(Int32 nMatchID, GameGeneralBall gameObj)
		{
			if (nMatchID <= 0)
			{
				Debug.Assert(false);
				return false;
			}

			StringBuilder strWin = new StringBuilder();
			StringBuilder strTime = new StringBuilder();
			StringBuilder strPoint = new StringBuilder();
			StringBuilder strScoreIntA = new StringBuilder();
			StringBuilder strScoreIntB = new StringBuilder();
			StringBuilder strScoreStrA = new StringBuilder();
			StringBuilder strScoreStrB = new StringBuilder();

			//先往字符串里装入总的信息
			Int32 nWin = 0;
			EGbTeam eTeam = gameObj.GetWinMatch();
			if (eTeam == EGbTeam.emTeamA)
				nWin = 1;
			else
				if (eTeam == EGbTeam.emTeamB)
					nWin = 2;
				else
					nWin = 0;

			strWin.Append(nWin);
			strTime.Append(gameObj.GetTimeMatch() / 1000 / 60);

			//获取Point信息
			{
				SGbPointInfo ePoint = gameObj.GetPointInfo();


				if (ePoint.m_ePoint == EGbPointInfo.emPointSet)
					strPoint.Append("1,");
				else if (ePoint.m_ePoint == EGbPointInfo.emPointGame || ePoint.m_ePoint == EGbPointInfo.emPointMatch )
					strPoint.Append("2,");
				else
					strPoint.Append("0,");

				if (ePoint.m_eTeam == EGbTeam.emTeamA)
					strPoint.Append("1,");
				else if (ePoint.m_eTeam == EGbTeam.emTeamB)
					strPoint.Append("2,");
				else
					strPoint.Append("0,");

				strPoint.Append(ePoint.m_byCount.ToString());
				strPoint.Append(",");
			}

			strScoreIntA.Append(gameObj.GetScoreMatch(false));
			strScoreIntB.Append(gameObj.GetScoreMatch(true));
			strScoreStrA.Append(gameObj.GetScoreMatchStr(false));
			strScoreStrB.Append(gameObj.GetScoreMatchStr(true));
			strWin.Append(',');
			strTime.Append(',');
			strScoreIntA.Append(',');
			strScoreIntB.Append(',');
			strScoreStrA.Append(',');
			strScoreStrB.Append(',');

			//再循环装入每局信息
			for (int nCycSet = 1; nCycSet < GameGeneralBall.MAX_SET; nCycSet++)
			{
				Int32 nSetWin = 0;
				EGbTeam eSetTeam = gameObj.GetWinSet(nCycSet);
				if (eSetTeam == EGbTeam.emTeamA)
					nSetWin = 1;
				else
					if (eSetTeam == EGbTeam.emTeamB)
						nSetWin = 2;
					else
						nSetWin = 0;

				strWin.Append(nSetWin);
				strTime.Append(gameObj.GetTimeSet(nCycSet) / 1000 / 60);
				strScoreIntA.Append(gameObj.GetScoreSet(false, nCycSet));
				strScoreIntB.Append(gameObj.GetScoreSet(true, nCycSet));
				strScoreStrA.Append(gameObj.GetScoreSetStr(false, nCycSet));
				strScoreStrB.Append(gameObj.GetScoreSetStr(true, nCycSet));
				strWin.Append(',');
				strTime.Append(',');
				strScoreIntA.Append(',');
				strScoreIntB.Append(',');
				strScoreStrA.Append(',');
				strScoreStrB.Append(',');
			}

			SqlCommand dbCmd = new SqlCommand("proc_VB_PRG_MatchSetScore", g_DataBaseCon);
			dbCmd.CommandType = CommandType.StoredProcedure;

			dbCmd.Parameters.AddWithValue("@MatchID", nMatchID);
			dbCmd.Parameters.AddWithValue("@SetCount", 5);
			dbCmd.Parameters.AddWithValue("@CurSet", gameObj.GetCurSet());
			dbCmd.Parameters.AddWithValue("@ServeTeamB", gameObj.IsServeTeamB() ? 1 : 0);
			dbCmd.Parameters.AddWithValue("@PointInfo", strPoint.ToString());
			dbCmd.Parameters.AddWithValue("@SetWinList", strWin.ToString());
			dbCmd.Parameters.AddWithValue("@SetTimeList", strTime.ToString());
			dbCmd.Parameters.AddWithValue("@SetScoreListA", strScoreIntA.ToString());
			dbCmd.Parameters.AddWithValue("@SetScoreListB", strScoreIntB.ToString());
			dbCmd.Parameters.AddWithValue("@SetScoreListStrA", strScoreStrA.ToString());
			dbCmd.Parameters.AddWithValue("@SetScoreListStrB", strScoreStrB.ToString());
			dbCmd.Parameters.AddWithValue("@Result", DBNull.Value);
			dbCmd.Parameters["@Result"].Size = 4;
			dbCmd.Parameters["@Result"].SqlDbType = SqlDbType.Int;
			dbCmd.Parameters["@Result"].Direction = ParameterDirection.Output;

			if (!dbExecuteNonQuery(ref dbCmd))
			{
				MessageBox.Show("proc_VB_PRG_MatchSetScore exec failed!");
				return false;
			}

			if ( (int)dbCmd.Parameters["@Result"].Value <= 0 )
			{
				MessageBox.Show("proc_VB_PRG_MatchSetScore return failed!");
				return false;
			}

			return true;
		}

		//公共使用的,获取记录集

		public static Int32 dbExecuteNonQuery(String strSql)
		{
			if (strSql == null || strSql.Length == 0)
			{
				Debug.Assert(false);
				return -1;
			}

			SqlCommand dbCmd = new SqlCommand(strSql, g_DataBaseCon);
			dbCmd.CommandType = CommandType.Text;

			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
				Common.g_DataBaseCon.Open();

			int nRet = -1;
			try
			{
				nRet = dbCmd.ExecuteNonQuery();				
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.ToString());
				return -2;
			}

	//		if (Common.g_DataBaseCon.State != ConnectionState.Closed)
	//			Common.g_DataBaseCon.Close();


			return nRet;
		}
		public static bool dbExecuteNonQuery(ref SqlCommand dbCmd)
		{
			if (dbCmd == null)
			{
				Debug.Assert(false);
				return false;
			}

			try
			{
				if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
					Common.g_DataBaseCon.Open();

				dbCmd.Connection = g_DataBaseCon;
				dbCmd.ExecuteNonQuery();

		//		Common.g_DataBaseCon.Close();
			}
			catch (Exception e)
			{
				MessageBox.Show(e.ToString());
				return false;
			}

			return true;
		}

		public static DataSet dbGetDataSet(ref SqlCommand dbCmd)
		{
			if (dbCmd == null)
			{
				Debug.Assert(false);
				return null;
			}

			DataSet dataSet;
			try
			{
				SqlDataAdapter sqlAdp = new SqlDataAdapter(dbCmd);
				dataSet = new DataSet();
				sqlAdp.Fill(dataSet);
			}
			catch (Exception e)
			{
				MessageBox.Show(e.ToString());
				return null;
			}

			return dataSet;
		}
	
		public static DataTable dbGetTableRecord(String strSql)
		{
			if (strSql == null || strSql.Length == 0)
			{
				Debug.Assert(false);
				return null;
			}

			DataSet dataSet;
			try
			{
				SqlDataAdapter sqlAdp = new SqlDataAdapter(strSql, Common.g_DataBaseCon);
				dataSet = new DataSet();
				sqlAdp.Fill(dataSet);
			}
			catch (Exception e)
			{
				MessageBox.Show(e.ToString());
				return null;
			}

	//		if (Common.g_DataBaseCon.State != ConnectionState.Closed)
	//		{
	//			Common.g_DataBaseCon.Close();
	//		}

			if (dataSet.Tables.Count < 1)
			{
				return null;
			}

			return dataSet.Tables[0];
		}

		public static DataTable dbGetTableRecord(ref SqlCommand dbCmd)
		{
			DataSet dataSet = dbGetDataSet(ref dbCmd);

			if ( dataSet == null || dataSet.Tables.Count < 1)
			{
				return null;
			}

			return dataSet.Tables[0];
		}

		public static object dbGetValue(String strSql)
		{
 			DataTable tbl = dbGetTableRecord(strSql);

			if (tbl == null || tbl.Rows.Count == 0 || tbl.Columns.Count == 0)
				return null;
			else
				return tbl.Rows[0][0];
		}

		//计算小组赛积分,排名
		public static bool dbCalGroupResult(Int32 nMatchID)
		{
			if ( nMatchID <= 0 )
			{
				Debug.Assert(false);
				return false;
			}

			SqlCommand dbCmd = new SqlCommand("Proc_VB_PRG_CalculateGroupResult", g_DataBaseCon);
			dbCmd.CommandType = CommandType.StoredProcedure;
			dbCmd.Parameters.AddWithValue("@MatchID", nMatchID);
			dbCmd.Parameters.AddWithValue("@Result", DBNull.Value);
			dbCmd.Parameters["@Result"].Size = 4;
			dbCmd.Parameters["@Result"].SqlDbType = SqlDbType.Int;
			dbCmd.Parameters["@Result"].Direction = ParameterDirection.Output;

			if( !dbExecuteNonQuery(ref dbCmd))
			{
				MessageBox.Show("执行计算小组排名的存储过程失败!");
				return false;
			}

			int nRet = (int)dbCmd.Parameters["@Result"].Value;
			if (nRet < 0)
			{
				MessageBox.Show("执行计算小组排名的存储过程返回失败!");
				return false;
			}

			return true;
		}

		//Statistics 队技术统计项目 RegisterID = -1 
		public static bool dbActionListAdd(Int32 nMatchID, Int32 nCurSet, String strStatCode, Int32 nRegisterID, Int32 nBeforeActionID, bool bIsTeamB)
		{
			if (nMatchID <= 0 || nCurSet < 1 || nCurSet > GameGeneralBall.MAX_SET || nRegisterID < -1 || nRegisterID == 0 || strStatCode.Length < 1 || nBeforeActionID < 0)
			{
				Debug.Assert(false);
				return false;
			}

			Int32 nCompetitionPos = bIsTeamB ? 2 : 1;

			SqlCommand dbCmd = new SqlCommand("proc_VB_PRG_StatActionAdd", g_DataBaseCon);
			dbCmd.CommandType = CommandType.StoredProcedure;
			dbCmd.Parameters.AddWithValue("@MatchID", nMatchID);
			dbCmd.Parameters.AddWithValue("@CurSet", nCurSet);
			dbCmd.Parameters.AddWithValue("@CompetitionPos", nCompetitionPos);
			dbCmd.Parameters.AddWithValue("@RegisterID", nRegisterID);
			dbCmd.Parameters.AddWithValue("@BeforeActionID", nBeforeActionID);
			dbCmd.Parameters.AddWithValue("@ActionCode", strStatCode);
			dbCmd.Parameters.AddWithValue("@Result", DBNull.Value);

			dbCmd.Parameters["@Result"].Size = 4;
			dbCmd.Parameters["@Result"].SqlDbType = SqlDbType.Int;
			dbCmd.Parameters["@Result"].Direction = ParameterDirection.Output;

			if (!dbExecuteNonQuery(ref dbCmd))
			{
				MessageBox.Show("proc_VB_PRG_StatActionAdd exec Failed!");
				return false;
			}

			if ((int)dbCmd.Parameters["@Result"].Value <= 0)
			{
				//MessageBox.Show("proc_VB_PRG_StatActionAdd return Failed!");
				return false;
			}

			return true;
		} 
		public static bool dbActionListDelete(Int32 nActionID)
		{
			if (nActionID <= 0 )
			{
				Debug.Assert(false);
				return false;
			}

			String strSql = @"Delete From TS_Match_ActionList where F_ActionNumberID = " + nActionID.ToString();

			int nRet = dbExecuteNonQuery(strSql);
			return (nRet >= 1);
		}
		public static DataSet dbActionListGetList(Int32 nMatchID, Int32 nCurSet)
		{
			if (nMatchID <= 0 || nCurSet < 1 || nCurSet > GameGeneralBall.MAX_SET )
			{
				Debug.Assert(false);
				return null;
			}

			SqlCommand dbCmd = new SqlCommand("proc_VB_PRG_StatActionGetList", g_DataBaseCon);
			dbCmd.CommandType = CommandType.StoredProcedure;
			dbCmd.Parameters.AddWithValue("@MatchID", nMatchID);
			dbCmd.Parameters.AddWithValue("@CurSet", nCurSet);
			dbCmd.Parameters.AddWithValue("@LangCode", g_strLanguage);

			DataSet dataSet = dbGetDataSet(ref dbCmd);
			if (dataSet == null || dataSet.Tables.Count < 3)
			{
				return null;
			}

			return dataSet;
		}

		public static bool isEqualDataRow(DataRow row1, DataRow row2, int columnCount)
		{
			if ( (row1 == null) && (row2 != null))
			{
				return false;
			}

			if ((row1 != null) && (row2 == null))
			{
				return false;
			}

			if ((row1 == null) && (row2 == null))
			{
				return true;
			}

			for (int nCol = 0; nCol < columnCount; nCol++)
			{
				if (row1[nCol].ToString() != row2[nCol].ToString())
				{
					return false;
				}
			}

			return true;
		}

		public static DataTable dbMatchScoreWinLose()
		{
			if (g_nMatchID <= 0)
			{
				Debug.Assert(false);
				return null;
			}

			string strSql = string.Format("SELECT * FROM dbo.func_VB_MatchScoreWinLose({0})", g_nMatchID.ToString());
			return dbGetTableRecord(strSql);
		}

		//从数据库获取比赛状态ID
		public static Int32 dbGetMatchStatusID()
		{
			String strSql = "SELECT F_matchstatusID FROM TS_Match WHERE F_MatchID = " + Common.g_nMatchID;
			object objMatchStatusID = dbGetValue(strSql);

			if (objMatchStatusID == null)
				return 0;
			else
				return Common.Str2Int(objMatchStatusID);
		}

		//从数据库获取技术统计推算的比分
		public static object dbGetScoreFromStat(bool bTeamA)
		{
			String strSql = String.Format("select dbo.func_VB_ScoreByStat({0}, {1}, {2}, {2})", g_nMatchID, g_Game.GetCurSet(), bTeamA ? 1 : 2);
			return dbGetValue(strSql);
		}

		//IRM
		public static DataTable dbIRMGetList()
		{
			return dbGetTableRecord(@"Select * from func_VB_GetIRMList()");
		}
		
		//设置IRM值,0代表NULL
		public static bool dbIRMSet(Int32 nMatchID, Int32 nIRMID, bool bTeamA)
		{
			String strSQL = String.Format(@"
				UPDATE TS_Match_Result SET F_IRMID = {0} 
				WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}",
				nIRMID == 0 ? "null" : nIRMID.ToString(),
				nMatchID.ToString(),
				bTeamA ? 1 : 2);

			int nRet = dbExecuteNonQuery(strSQL);

			return (nRet == 1);
		}

		public static bool dbSpectatorSet(String strValue)
		{
			if (Common.g_nMatchID <= 0)
			{
				return false;
			}

			String strSql = String.Format("UPDATE TS_Match SET F_MatchComment2='{0}' WHERE F_MatchID={1}", strValue, Common.g_nMatchID);
			return (dbExecuteNonQuery(strSql) == 1);
		}

		public static String dbSpectatorGet()
		{
			if (Common.g_nMatchID <= 0)
			{
				return "";
			}

			DataTable tbl = dbGetTableRecord("SELECT F_MatchComment2 FROM TS_Match WHERE F_MatchID =" + Common.g_nMatchID);
			if (tbl == null || tbl.Rows.Count < 1 || tbl.Columns.Count < 1)
				return "";

			return tbl.Rows[0][0].ToString();
		}

		public static String dbMatchTimeEndGet()
		{
			if (Common.g_nMatchID <= 0)
			{
				return "";
			}

			DataTable tbl = dbGetTableRecord("SELECT dbo.func_VB_FormatedDateTime(F_EndTime, 3) FROM TS_Match WHERE F_MatchID = " + Common.g_nMatchID);
			if (tbl == null || tbl.Rows.Count < 1 || tbl.Columns.Count < 1)
				return "";

			return tbl.Rows[0][0].ToString();
		}

		public static bool dbMatchTimeEndSet(String strValue)
		{
			if (Common.g_nMatchID <= 0)
			{
				return false;
			}

			String strSql = String.Format("UPDATE TS_Match SET F_EndTime='{0}' WHERE F_MatchID={1}", strValue, Common.g_nMatchID);
			return (dbExecuteNonQuery(strSql) == 1);
		}

		public static bool dbSettingSubtitutionTimeOutCount(bool bTimeout, bool bTeamA, bool bAdd, int curSet)
		{
			if (Common.g_nMatchID <= 0 || curSet <= 0)
			{
				return false;
			}

			string strSql = String.Format(@"
				UPDATE TS_Match_Split_Result 
				SET {0} = 
				CASE 
					WHEN '{1}' = '+' AND {0} < 9 THEN {0} + 1
					WHEN '{1}' = '-' AND {0} > 0 THEN {0} - 1 
					ELSE {0}
				END	
				WHERE F_MatchID = {2} AND F_MatchSplitID = {3} AND F_CompetitionPosition = {4}",
				bTimeout ? "F_TimeoutCount" : "F_SubtitutionCount",	// 0
				bAdd ? "+" : "-",	// 1
				Common.g_nMatchID,	// 2
				curSet,				// 3
				bTeamA ? 1 : 2		// 4
				);

			return (dbExecuteNonQuery(strSql) == 1);
		}

		public static DataTable dbSetInfo(int curSet)
		{
			if (curSet <= 0)
			{
				Debug.Assert(false);
				return null;
			}

			string strSql = string.Format(@"Select * from func_VB_RPG_MatchSetInfo({0}, {1})", Common.g_nMatchID, curSet);
			return dbGetTableRecord(strSql);
		}

		public static DataTable dbPlugInSetting()
		{
			string strSql = ("SELECT (SELECT dbo.func_VB_ActivedDisciplineCode() ) AS F_DiscCode, (SELECT dbo.func_VB_ActivedLanguageCode()) AS F_LanguageCode ");
			DataTable tbl = dbGetTableRecord(strSql);
			if (tbl == null || tbl.Rows.Count < 1 || tbl.Columns.Count < 2)
			{
				return null;
			}

			return tbl;
		}

		//此程序从数据库刷新的最新时间

		public static string m_TimeDbModify; //2013-06-18 12:59:32 123


		//获取此场比赛在数据库中最新修改时间，如果获取失败，则返回1900-01-01 00:00:00
		public static string dbMatchModifyTimeGet()
		{
			//SELECT CAST(F_MatchComment3 AS DATETIME) FROM TS_Match WHERE F_matchID = {0}
			String strSql = String.Format("SELECT F_MatchComment3 FROM TS_Match WHERE F_matchID = {0}", Common.g_nMatchID);
			DataTable tbl = dbGetTableRecord(strSql);
			
			if (tbl == null || tbl.Rows.Count == 0 || tbl.Columns.Count == 0 || tbl.Rows[0][0].ToString() == "" )
				return new DateTime(1900, 1, 1, 0, 0, 0).ToString("yyyy-MM-dd hh:mm:ss fff");

			string strTime = tbl.Rows[0][0].ToString();

			return DateTime.Parse(strTime).ToString("yyyy-MM-dd hh:mm:ss fff");
		}


		//对此场进行操作后，在TS_Match,F_MatchComment2中记录下当前系统时间，

		//这样其他客户端可利用比较时间的方法，轮询此时间判断自己是否需要更新

		//同时，把自己的时间同步为数据库时间，自己避免再次刷新
		public static bool dbMatchModifyTimeSet()
		{
			String strSql = String.Format("UPDATE TS_Match SET F_MatchComment3 = CONVERT(NVARCHAR(100), GETDATE(), 21) WHERE F_MatchID = {0}", g_nMatchID);

			bool bRet = (Common.dbExecuteNonQuery(strSql) == 1);

			if (bRet)
				m_TimeDbModify = Common.dbMatchModifyTimeGet();

			return bRet;
		}

		public static string dbMatchScoreInXml()
		{
			DataTable tbl = dbGetTableRecord(string.Format("SELECT * FROM dbo.func_VB_RPG_MatchScoreInXml({0})", g_nMatchID));
			if (tbl == null || tbl.Rows.Count < 1 || tbl.Columns.Count < 1)
				return "";

			return tbl.Rows[0][0].ToString();
		}

		/*
		public static string ConfigurGet(string strKey, string strDefValue = "")
		{
			Configuration config = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
			string[] strAryKey = config.AppSettings.Settings.AllKeys;

			int nIndex = Array.FindIndex(strAryKey, element => element == strKey);
			if (nIndex >= 0)
				return config.AppSettings.Settings[strKey].Value;
			else
			{
				ConfigurSet(strKey, strDefValue);
				return strDefValue;
			}
		}

		public static bool ConfigurSet(string strKey, string strValue)
		{
			Configuration config = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
			string[] strAryKey = config.AppSettings.Settings.AllKeys;

			int nIndex = Array.FindIndex(strAryKey, element => element == strKey);
			if (nIndex >= 0)
				config.AppSettings.Settings[strKey].Value = strValue;
			else
				config.AppSettings.Settings.Add(strKey, strValue);

			config.AppSettings.SectionInformation.ForceSave = true;
			config.Save(ConfigurationSaveMode.Full);

			return true;
		}
		 */

    }
}
