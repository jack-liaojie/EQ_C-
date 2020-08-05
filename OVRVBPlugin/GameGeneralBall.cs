using System;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.Collections.Generic;
using System.Runtime.Serialization.Formatters.Binary;

//计分类

namespace AutoSports.OVRVBPlugin
{

	public enum Edefine
	{
		CURRENT = 0,		  //当前局,当前场

		MAX_SET = 7,		  //最大局数

		MAX_MATCH = 5,	  //最大盘数

		MAX_SCORE = 99, //最大比分

	}

    //快速设定比赛规则时使用
    public enum EGbGameType
    {
        emGameVolleyBall = 0,		        //排球
        emGameBeachVolleyBall,	    //沙滩排球
        emGamePingPongBall,		    //乒乓球

        emGamePingPongBallTeam,	//乒乓球 团体
        emGameBadminton,		        //羽毛球

        emGameBadmintonTeam,	    //羽毛球 团体
    };

    public enum EGbTeam
    {
        emTeamNone = 0,       //双方都不存在
        emTeamA,
        emTeamB,
        emTeamBoth,		//双方都存在

    };

    //局点,场点,盘点信息
	public enum EGbPointInfo
    {
        emPointNone = 0,		//无任何信息

        emPointSet,				//SetPoint 局
        emPointMatch,			//MatchPoint 场

        emPointGame,			//GamePoint 盘

    };

    //在一次加分操作时,对大比分产生的影响

	public enum EGbWinGrade
    {
        emGradeFail = 0,   //加分失败,未加分

        emGradeNone,		//未产生影响	
        emGradeSet,			//赢一局
        emGradeMatch,		//赢一场

        emGradeGame,		//赢整场比赛

    };

	public enum EGbChangServeType // 更换发球方式，顺序不能变
    {
        emServeTwoBalls = 0,    //打两球一换

        emServeOneBall,		    //打一球一换	在加长赛中使用

        emServeWinOne,		    //赢球同时得到球权
    };

	public class SGbPointInfo
	{
		public Int32 m_byCount;		//该信息是第几次

		public EGbTeam m_eTeam;
		public EGbPointInfo m_ePoint;

		public String GetCountStr()
		{
			String strCount;
			switch (m_byCount)
			{
				case 0:
				case 1: strCount = "";			break; //1st
				case 2: strCount = "2nd";	break;
				case 3: strCount = "3rd";	break;
				default:
					strCount = String.Format("{0:D}th", m_byCount);
					break;
			}

			return strCount;
		}

		public String GetTeamStr()
		{
			String strTeam = "";
			switch (m_eTeam)
			{
				case EGbTeam.emTeamNone:	strTeam = "";					break;
				case EGbTeam.emTeamA:			strTeam = "TeamA";		break;
				case EGbTeam.emTeamB:			strTeam = "TeamB";		break;
				case EGbTeam.emTeamBoth:		strTeam = "TeamBoth";	break;
				default: Debug.Assert(false);	break;
			}

			return strTeam;
		}

		public String GetPointStr()
		{
			String strPoint = "";
			switch (m_ePoint)
			{
				case EGbPointInfo.emPointNone:	strPoint = "";					break;
				case EGbPointInfo.emPointSet:		strPoint = "SetPoint";		break;
				case EGbPointInfo.emPointMatch:	strPoint = "MatchPoint"; break;
				case EGbPointInfo.emPointGame:	strPoint = "GamePoint"; break;
				default: Debug.Assert(false); break;
			}

			return strPoint;
		}

		public String GetDesc()
		{
			String strDesc;
			strDesc = String.Format("{0} {1} {2}", GetCountStr(), GetPointStr(), GetTeamStr() );
			return strDesc;
		}

		public SGbPointInfo Clone()
		{
			SGbPointInfo obj = new SGbPointInfo();
			obj.m_byCount = m_byCount;
			obj.m_eTeam = m_eTeam;
			obj.m_ePoint = m_ePoint;
			return obj;
		}
	};

	public class SGbRuleMatch 
	{
		public Int32[] m_bySocreToWin = new Int32[GameGeneralBall.MAX_SET];		//到多少分赢,且双方分差大于1,
		public Int32[] m_byScoreMax = new Int32[GameGeneralBall.MAX_SET];		//最大分数,就是先到此分数的一方,绝对赢 默认99,且比分不允许超过此值


		public Int32 m_bySetNum;								//比赛有几局
		public bool  m_bCanFullMatch;
		public EGbChangServeType m_eServe;				//换发球方式

		public EGbChangServeType m_eServeExtend;	//在延长赛时的换发方式

		public void CleanAll()
		{
			for (int nCyc=0; nCyc<GameGeneralBall.MAX_SET; nCyc++)
			{
				m_bySocreToWin[nCyc] = 10;
				m_byScoreMax[nCyc] = 15;
			}

			m_bySetNum = 3;
			m_bCanFullMatch = false;
			m_eServe = EGbChangServeType.emServeTwoBalls;
			m_eServeExtend = EGbChangServeType.emServeWinOne;		
		}

		public void Valid()
		{
			for (int nCyc=0; nCyc<GameGeneralBall.MAX_SET; nCyc++)
			{
				m_byScoreMax[nCyc] = Math.Max(m_byScoreMax[nCyc], 1 );
				m_byScoreMax[nCyc] = Math.Min( m_byScoreMax[nCyc], GameGeneralBall.MAX_SCORE );

				m_bySocreToWin[nCyc] = Math.Max( m_bySocreToWin[nCyc], (Int32)1 );
				m_bySocreToWin[nCyc] = Math.Min( m_bySocreToWin[nCyc], m_byScoreMax[nCyc] );	//获胜比分小于等于最大比分

			}
		
			if ( m_bySetNum < 1 || m_bySetNum > GameGeneralBall.MAX_SET )
			{
				m_bySetNum = 1;
			}

			if ( m_bySetNum % 2 == 0 )
			{
				m_bySetNum ++;
				m_bySetNum = Math.Min(m_bySetNum, GameGeneralBall.MAX_SET);
			}

			if ( m_eServe < EGbChangServeType.emServeTwoBalls || m_eServe > EGbChangServeType.emServeWinOne )
			{
				Debug.Assert(false);
				m_eServe = EGbChangServeType.emServeTwoBalls;
			}

			if ( m_eServeExtend < EGbChangServeType.emServeTwoBalls || m_eServeExtend > EGbChangServeType.emServeWinOne )
			{
				Debug.Assert(false);
				m_eServeExtend = EGbChangServeType.emServeTwoBalls;
			}
		}

		public SGbRuleMatch()
		{
			CleanAll();
		}

		public SGbRuleMatch Clone()
		{
			SGbRuleMatch obj = new SGbRuleMatch();
			obj.m_bySocreToWin = (Int32[])m_bySocreToWin.Clone();
			obj.m_byScoreMax = (Int32[])m_byScoreMax.Clone();
			obj.m_bySetNum = m_bySetNum;
			obj.m_bCanFullMatch = m_bCanFullMatch;
			obj.m_eServe = m_eServe;
			obj.m_eServeExtend = m_eServeExtend;
			return obj;
		}

		/*
		void operater = (SGbRuleMatch ob)
		{
			for (int nCyc=0; nCyc<MAX_SET; nCyc++)
			{
				m_bySocreToWin[nCyc] = ob.m_bySocreToWin[nCyc];
				m_byScoreMax[nCyc] = ob.m_byScoreMax[nCyc];
			}	

			m_bySetNum = ob.m_bySetNum;
			m_bCanFullMatch= ob.m_bCanFullMatch;
			m_eServe = ob.m_eServe;
			m_eServeExtend = ob.m_eServeExtend;
		}
		 */
	};

	public class SGbRuleGame 
	{
		public Int32 m_byMatchNum;		//比赛有几盘

		public bool  m_bCanFullGame;	//在已经分出胜利的情况下,还可继续打满全场
		public SGbRuleMatch[] m_ruleMatch = new SGbRuleMatch[GameGeneralBall.MAX_MATCH];

		public void CleanAll()
		{
			m_byMatchNum = 3;
			m_bCanFullGame = false;

			for (int nCyc=0; nCyc<GameGeneralBall.MAX_MATCH; nCyc++)
			{
				m_ruleMatch[nCyc] = new SGbRuleMatch();
				m_ruleMatch[nCyc].CleanAll();
			}
		}

		public void Valid()
		{
			for (int nCyc = 0; nCyc < GameGeneralBall.MAX_MATCH; nCyc++)
			{
				m_ruleMatch[nCyc].Valid();
			}

			if (m_byMatchNum < 1 || m_byMatchNum > GameGeneralBall.MAX_MATCH)
			{
				m_byMatchNum = 1;
			}

			if ( m_byMatchNum % 2 == 0 )
			{
				m_byMatchNum ++;
				m_byMatchNum = Math.Min(m_byMatchNum, GameGeneralBall.MAX_MATCH);
			}
		}

		public SGbRuleGame()
		{
			CleanAll();
		}

		public SGbRuleGame Clone()
		{
			SGbRuleGame obj = new SGbRuleGame();
			obj.m_byMatchNum = m_byMatchNum;
			obj.m_bCanFullGame = m_bCanFullGame;

			for (int nCyc = 0; nCyc < GameGeneralBall.MAX_MATCH; nCyc++)
			{
				obj.m_ruleMatch[nCyc] = m_ruleMatch[nCyc].Clone();
			}

			return obj;
		}
		/*
		void operator = (const SGbRuleGame& ob)
		{
			for (int nCyc=0; nCyc<MAX_MATCH; nCyc++)
			{
				m_ruleMatch[nCyc] = ob.m_ruleMatch[nCyc];
			}	

			m_byMatchNum = ob.m_byMatchNum;
			m_bCanFullGame = ob.m_bCanFullGame;
		}
		*/

		public static EGbChangServeType GetServeTypeByName(String strServerName)
		{
			// 暂时用这种方式，应该改为双方从数据中心读取

			if( strServerName == "两分一换" )
			{
				return EGbChangServeType.emServeTwoBalls;
			}
			else if( strServerName == "一分一换" )
			{
				return EGbChangServeType.emServeOneBall;
			}
			else if(strServerName == "得分得球权" )
			{
				return EGbChangServeType.emServeWinOne;
			}

			Debug.Assert(false);
			return EGbChangServeType.emServeTwoBalls;
		}
	};

	public class SGbByteInfo
	{
		public Int32 m_byStart;	//should be '['
		public Int32[] m_byCurSet = new Int32[GameGeneralBall.MAX_MATCH];
		public Int32 m_byCurMatch;
		public bool m_bServeTeamB;

		public Int32[,] m_bySetScoreA = new Int32[GameGeneralBall.MAX_MATCH, GameGeneralBall.MAX_SET];
		public Int32[,] m_bySetScoreB = new Int32[GameGeneralBall.MAX_MATCH, GameGeneralBall.MAX_SET];

		public Int32 m_byPointSetCountA;
		public Int32 m_byPointSetCountB;
		public Int32 m_byPointMatchCountA;
		public Int32 m_byPointMatchCountB;
		public Int32 m_byPointGameCountA;
		public Int32 m_byPointGameCountB;

		public UInt32[,] m_dwTime = new UInt32[GameGeneralBall.MAX_MATCH, GameGeneralBall.MAX_SET];

		public SGbRuleGame m_ruleGame;

		public Int32 m_byEnd; //should be ']'

		public SGbByteInfo()
		{
			m_byStart = (Int32)'[';
			m_byEnd = (Int32)']';

			m_byCurMatch = 0;
			m_bServeTeamB =	false;

			m_byPointSetCountA = 0;
			m_byPointSetCountB = 0;
			m_byPointMatchCountA = 0;
			m_byPointMatchCountA = 0;
			m_byPointGameCountA = 0;
			m_byPointGameCountB = 0;
		
			for (int nMatch=0; nMatch<GameGeneralBall.MAX_MATCH; nMatch++)
			{
				m_byCurSet[nMatch] = 0;

				for (int nSet = 0; nSet < GameGeneralBall.MAX_SET; nSet++)
				{
					m_dwTime[nMatch,nSet] = 0;
					m_bySetScoreA[nMatch,nSet] = 0;
					m_bySetScoreB[nMatch,nSet] = 0;
				}
			}
		}
	};

    public class GameGeneralBall
    {
		public const Int32 CURRENT = 0;           //当前局,当前场
		public const Int32 MAX_SET = 7;			//最大局数
		public const Int32 MAX_MATCH = 5;	    //最大盘数
		public const Int32 MAX_SCORE = 99;	    //最大比分

		protected Int32[] m_byCurSet = new Int32[MAX_MATCH];	// 当前局 0 ~ MAX-1, 当前局的标识,每盘分别记录
		protected Int32 m_byCurMatch;										// 当前盘 0 ~ MAX-1
		protected bool m_bServeTeamB;

		//每局中小分
		protected Int32[,] m_bySetScoreA = new Int32[MAX_MATCH,MAX_SET];
		protected Int32[,] m_bySetScoreB = new Int32[MAX_MATCH,MAX_SET];

		//供统计当前局中的 局,盘,赛点次数使用
		protected Int32 m_byPointSetCountA;
		protected Int32 m_byPointSetCountB;
		protected Int32 m_byPointMatchCountA;
		protected Int32 m_byPointMatchCountB;
		protected Int32 m_byPointGameCountA;
		protected Int32 m_byPointGameCountB;

		//比赛规则
		[NonSerialized]
		protected SGbRuleGame m_ruleGame = new SGbRuleGame(); 

		//时钟
		protected bool m_bTimeIsRun;
		protected UInt32 m_dwTimeStart;
		protected UInt32[,] m_dwTimeSet = new UInt32[MAX_MATCH,MAX_SET];
		protected UInt32[] m_dwTimeMatch = new UInt32[MAX_MATCH];		//每场比赛时间,在走表时,依靠自动计时,由每局比赛时间相加。
																		//未走表时,返回设定的正常比赛时间
		public GameGeneralBall()
		{
			CleanAll();
		}

		public GameGeneralBall Clone()
		{
			GameGeneralBall obj = new GameGeneralBall();
			obj.m_byCurSet = (Int32[])m_byCurSet.Clone();
			obj.m_byCurMatch = m_byCurMatch;
			obj.m_bServeTeamB = m_bServeTeamB;
			obj.m_bySetScoreA = (Int32[,])m_bySetScoreA.Clone();
			obj.m_bySetScoreB = (Int32[,])m_bySetScoreB.Clone();

			obj.m_byPointSetCountA = m_byPointSetCountA;
			obj.m_byPointSetCountB = m_byPointSetCountB;
			obj.m_byPointMatchCountA = m_byPointMatchCountA;
			obj.m_byPointMatchCountB = m_byPointMatchCountB;
			obj.m_byPointGameCountA = m_byPointGameCountA;
			obj.m_byPointGameCountB = m_byPointGameCountB;
			obj.m_byPointGameCountB = m_byPointGameCountB;

			obj.m_bTimeIsRun = m_bTimeIsRun;
			obj.m_dwTimeStart = m_dwTimeStart;
			obj.m_dwTimeSet = (UInt32[,])m_dwTimeSet.Clone();
			obj.m_dwTimeMatch = (UInt32[])m_dwTimeMatch.Clone();

			obj.m_ruleGame = m_ruleGame.Clone();
			return obj;
		}

		public void CleanAll(bool bExceptRule=true)
		{
			m_byCurMatch = 0;
			m_bServeTeamB = false;

			for (int nMatch=0; nMatch<MAX_MATCH; nMatch++)
			{
				m_byCurSet[nMatch] = 0;
				m_dwTimeMatch[nMatch] = 0;

				for (int nSet=0; nSet<MAX_SET; nSet++)
				{
					m_dwTimeSet[nMatch,nSet] = 0;
					m_bySetScoreA[nMatch,nSet] = 0;
					m_bySetScoreB[nMatch,nSet] = 0;
				}
			}

			ClearPointCount();

			m_bTimeIsRun = false;
			m_dwTimeStart = 0;

			if ( !bExceptRule )
				m_ruleGame.CleanAll();
		}

		public bool IsValidMatchIndex(Int32 byMatch)
		{
			if ( byMatch > MAX_MATCH )
			{
				Debug.Assert(false);
				return false;	
			}

			if ( byMatch > m_ruleGame.m_byMatchNum )
			{
				return false;
			}

			return true;
		}

		public bool IsValidSetIndex(Int32 bySet, Int32 byMatch=CURRENT)
		{
			if ( bySet > MAX_SET )
			{
				Debug.Assert(false);
				return false;
			}

			if ( !IsValidMatchIndex(byMatch) )
			{
				return false;
			}

			if ( bySet > GetRuleMatch(byMatch).m_bySetNum )
			{
				return false;
			}

			return true;
		}

		public void Valid()
		{
			m_ruleGame.Valid();
			return;
		}

		private void CalculateTime()
		{
			if ( !m_bTimeIsRun )
			{
				return;
			}
			
			UInt32 dwTimeNow = (uint)System.Environment.TickCount;
			UInt32 dwAdd = dwTimeNow - m_dwTimeStart;
			m_dwTimeSet[ GetCurMatch()-1, GetCurSet()-1 ] += dwAdd;
			m_dwTimeStart = dwTimeNow;

			_calculateMatchTime();
		}

		private void _calculateMatchTime()
		{
			//Calculate matchTime
			UInt32 dwTimeTotal = 0;
			int currentMatch = GetCurMatch();
			for (int iSet = 0; iSet < GetCurSet(); iSet++)
			{
				UInt32 dwTimeSet = m_dwTimeSet[currentMatch - 1, iSet];
				dwTimeTotal += dwTimeSet;
			}

			m_dwTimeMatch[currentMatch - 1] = dwTimeTotal;
		}

		public static String TimeIntToStr(UInt32 dwTime, bool bNeedSec)
		{
			int iSec = (int)dwTime / 1000;
			int iMin = iSec / 60;	
			int iHor = iMin / 60;

			iSec %= 60;
			iMin %= 60;
			iHor %= 100;

			String strTime;
			if ( bNeedSec )
			{
				if ( iHor > 0 )
					strTime = String.Format("{0}:{1:D2}:{2:D2}", iHor, iMin, iSec);
				else
					strTime = String.Format("{0}:{1:D2}", iMin, iSec);
			}
			else
			{
				if ( iHor > 0 )
					strTime = String.Format("{0}:{1:D2}", iHor, iMin);
				else
					strTime = String.Format("0:{0:D2}", iMin);
			}

			return strTime;
		}

		public static UInt32 TimeStrToInt(String strTime)
		{
			// To do, 判断秒

			int iIndex = strTime.IndexOf(':');
			int iHor = 0;
			int iMin = 0;

			if ( iIndex > 0 )
			{
				iHor = Common.Str2Int( strTime.Substring(0, iIndex) );
				iMin = Common.Str2Int( strTime.Substring(strTime.Length - iIndex - 1 ));
			}
			else
			{
				iMin = Common.Str2Int( strTime );
			}	

			iMin += iHor * 60;
			UInt32 dwTime = (uint)(iMin * 60 * 1000);

			return dwTime;
		}

		public void ClearPointCount()
		{
			m_byPointSetCountA = 0;
			m_byPointSetCountB = 0;
			m_byPointMatchCountA = 0;
			m_byPointMatchCountB = 0;
			m_byPointGameCountA = 0;
			m_byPointGameCountB = 0;
		}
		public void CalculatePointCount(bool bAddPoint=true)
		{
			SGbPointInfo pointInfo = GetPointInfo();

			if ( pointInfo.m_ePoint	== EGbPointInfo.emPointGame )
			{
				if ( pointInfo.m_eTeam == EGbTeam.emTeamA || pointInfo.m_eTeam == EGbTeam.emTeamBoth )
				{
					if ( bAddPoint && m_byPointGameCountA < 99 )		
						m_byPointGameCountA ++;
					else if ( !bAddPoint && m_byPointGameCountA > 1 )
						m_byPointGameCountA --;
				}
				if ( pointInfo.m_eTeam == EGbTeam.emTeamB || pointInfo.m_eTeam == EGbTeam.emTeamBoth )
				{
					if ( bAddPoint && m_byPointGameCountB < 99 )
						m_byPointGameCountB ++;
					else if ( !bAddPoint && m_byPointGameCountB > 1 )
						m_byPointGameCountB --;
				}
			}
			else
			if ( pointInfo.m_ePoint	== EGbPointInfo.emPointMatch )
			{
				if ( pointInfo.m_eTeam == EGbTeam.emTeamA || pointInfo.m_eTeam == EGbTeam.emTeamBoth )
				{
					if ( bAddPoint && m_byPointMatchCountA < 99 )		
						m_byPointMatchCountA ++;
					else if ( !bAddPoint && m_byPointMatchCountA > 1 )
						m_byPointMatchCountA --;
				}

				if ( pointInfo.m_eTeam == EGbTeam.emTeamB || pointInfo.m_eTeam == EGbTeam.emTeamBoth )
				{
					if ( bAddPoint && m_byPointMatchCountB < 99 )
						m_byPointMatchCountB ++;
					else if ( !bAddPoint && m_byPointMatchCountB > 1 )
						m_byPointMatchCountB --;
				}
			}
			else
			if ( pointInfo.m_ePoint	== EGbPointInfo.emPointSet )
			{
				if ( pointInfo.m_eTeam == EGbTeam.emTeamA || pointInfo.m_eTeam == EGbTeam.emTeamBoth )
				{
					if ( bAddPoint && m_byPointSetCountA < 99 )
						m_byPointSetCountA ++;
					else if ( !bAddPoint && m_byPointSetCountA > 1 )
						m_byPointSetCountA --;
				}

				if ( pointInfo.m_eTeam == EGbTeam.emTeamB || pointInfo.m_eTeam == EGbTeam.emTeamBoth )
				{
					if ( bAddPoint && m_byPointSetCountB < 99 )
						m_byPointSetCountB ++;
					else if ( !bAddPoint && m_byPointSetCountB > 1 )
						m_byPointSetCountB --;
				}
			}
		}

		public Int32 GetCurSet(Int32 byMatch=CURRENT)
		{
			if ( !IsValidMatchIndex(byMatch) )
			{
				byMatch = GetCurMatch();
			}

			if ( byMatch == CURRENT )
			{
				byMatch = GetCurMatch();
			}

			return m_byCurSet[(int)byMatch-1] + (Int32)1;
		}

		public bool SetCurSet(Int32 byCurSet=CURRENT)
		{
			CalculateTime();

			if ( byCurSet < 1 || byCurSet > MAX_SET )
			{
				Debug.Assert(false);
				return false;
			}

			if ( byCurSet > GetRuleMatch().m_bySetNum )
			{
				return false;
			}

			Int32 byOldCurSet = GetCurSet(CURRENT);

			if (byCurSet <= byOldCurSet)
			{
				m_byCurSet[GetCurMatch() - 1] = byCurSet - 1;
				ClearPointCount();

				return true;
			}
			else
			{
				bool bModified = false; //改变了一局也算成功
				for (int nCycCur = byOldCurSet+1; nCycCur <= byCurSet; nCycCur++) //一局一局的跳
				{
					//已经有胜方,且规则不允许胜利后继续比赛
					if (GetWinMatch() != EGbTeam.emTeamNone && !GetRuleMatch().m_bCanFullMatch)
					{
						return bModified;
					}

					if (GetWinSet() != EGbTeam.emTeamNone)
					{
						m_byCurSet[GetCurMatch() - 1] = nCycCur - 1;
						bModified = true;
					}
				}

				//如果有改动,就清除点信息
				if (bModified)
				{
					ClearPointCount();
				}

				return bModified;
			}

				
	
			//当前场已经分出胜负时,是否允许进入下一局,根据规则设定
			if ( !GetRuleMatch().m_bCanFullMatch && GetWinMatch() != EGbTeam.emTeamNone )
			{
				if ( byCurSet > GetScoreSet(false) + GetScoreSet(true) )
				{
					m_byCurSet[ GetCurMatch()-1 ] = byOldCurSet - 1;
					return false;
				}
			}
	
			ClearPointCount();

			return true;
		}

		public Int32 GetSetCount(Int32 byMatch=CURRENT)
		{
			if ( !IsValidMatchIndex(byMatch) )
			{
				return 0;
			}
	
			return GetRuleMatch(byMatch).m_bySetNum;
		}

		public Int32 GetCurMatch()
		{
			Debug.Assert( IsValidMatchIndex( m_byCurMatch+1 ) );
			return m_byCurMatch + 1;
		}

		public Int32 GetMatchCount()
		{
			Int32 byMatchNum = GetRuleGame().m_byMatchNum;
			Debug.Assert( byMatchNum <= MAX_MATCH );

			return byMatchNum;
		}

		public bool SetCurMatch(Int32 byCurMatch)
		{
			CalculateTime();

			if ( byCurMatch < 1 || byCurMatch > MAX_MATCH )
			{
				Debug.Assert(false);
				return false;
			}

			if ( byCurMatch > GetRuleGame().m_byMatchNum )
			{
				return false;
			}

			Int32 byOldCurMatch = m_byCurMatch;
			m_byCurMatch = byCurMatch - 1;

			//全场已经分出胜负时,是否允许进入下一局,根据规则设定
			if ( !GetRuleGame().m_bCanFullGame && GetWinGame() != EGbTeam.emTeamNone )
			{
				if ( byCurMatch > GetScoreGame(false) + GetScoreGame(true) )
				{
					m_byCurMatch = byOldCurMatch;
					return false;
				}
			}

			ClearPointCount();

			return true;
		}

		public bool IsServeTeamB()
		{
			return m_bServeTeamB;
		}

		public void SetServeTeamB(bool bServeTeamB)
		{
			m_bServeTeamB = bServeTeamB;
		}

		public EGbWinGrade SetScoreAR(bool bTeamB, bool bAdd, bool bCalPointCount=true)
		{
			//先创建一个内容完全和自己的完全相同镜像类
			//记录下镜像类当前局,盘的输赢类型,之后对镜像类执行当前的操作, 之后判断WinSet
			//加分前无,加分后赢,说明这一分产生了EGbWinGrade
			//加分前赢, 如果是同一方,说明这方已经赢了,不应该允许加分

			//加分前无,加分后无,可以顺利加分
	
			//对于减分,目前只要分数>0,我们就允许减分


			GameGeneralBall obTemp = this.Clone(); //创建镜像

			EGbTeam eTeamOpr = bTeamB ? EGbTeam.emTeamB : EGbTeam.emTeamA;
			EGbTeam winOldSet = obTemp.GetWinSet();
			EGbTeam winOldMatch = obTemp.GetWinMatch();
			EGbTeam winOldGame = obTemp.GetWinGame();	

			if (bAdd)
			{
				//这个Set已经有人胜利了,就不允许再加分了
				if (winOldSet == EGbTeam.emTeamA || winOldSet == EGbTeam.emTeamB)
				{
					return EGbWinGrade.emGradeFail;
				}
		
				//把实际比分加1
				SetScore( GetScoreSet(bTeamB) + 1, bTeamB );

				EGbTeam winNewSet   = GetWinSet();
				EGbTeam winNewMatch = GetWinMatch();
				EGbTeam winNewGame  = GetWinGame();	

				//加分后,局还是没赢
				if ( winNewSet != eTeamOpr )
				{
					//判断发球权

					{
						EGbChangServeType eServeType = EGbChangServeType.emServeTwoBalls;

						//正常阶段和延长阶段用的换发规则不一样

						if ( Math.Max(GetScoreSet(false), GetScoreSet(true)) < GetRuleMatch().m_bySocreToWin[GetCurSet()-1] )
							eServeType = GetRuleMatch().m_eServe;
						else
							eServeType = GetRuleMatch().m_eServeExtend;

						if (eServeType == EGbChangServeType.emServeTwoBalls)
						{
						if ( ( GetScoreSet(false) + GetScoreSet(true) ) % 2 == 0 )
								SetServeTeamB( !IsServeTeamB() );
						}
						else
						if (eServeType == EGbChangServeType.emServeWinOne)
						{
							SetServeTeamB(bTeamB);
						}
						else
						if (eServeType == EGbChangServeType.emServeOneBall)
						{
							SetServeTeamB( !IsServeTeamB() );
						}
						else
						{
							Debug.Assert(false);
						}
					}

					if ( bCalPointCount)
						CalculatePointCount();

					return EGbWinGrade.emGradeNone;
				}
				else
				if ( winNewGame == eTeamOpr && winOldGame != eTeamOpr )
				{
					//ClearPointCount();
					return EGbWinGrade.emGradeGame;
				}
				else
				if ( winNewMatch == eTeamOpr && winOldMatch != eTeamOpr )
				{
					//ClearPointCount();
					return EGbWinGrade.emGradeMatch;
				}
				else
				if ( winNewSet == eTeamOpr && winOldSet != eTeamOpr )
				{
					//ClearPointCount();
					return EGbWinGrade.emGradeSet;
				}
				else
				{
					Debug.Assert(false);
					return EGbWinGrade.emGradeFail;
				}			
			}
			else //Reduce
			{
				//0分时不能再减
				Int32 byScoreCurSet = GetScoreSet(bTeamB);
				if ( byScoreCurSet == 0 )
				{
					return EGbWinGrade.emGradeFail;
				}

				//对方胜利的情况下,不许减分,这是为了避免出现不合理的比分
				if (GetWinSet() == (bTeamB ? EGbTeam.emTeamA : EGbTeam.emTeamB))
				{
					return EGbWinGrade.emGradeFail;
				}

				EGbChangServeType eServeType = EGbChangServeType.emServeTwoBalls;

				//正常阶段和延长阶段用的换发规则不一样

				if ( Math.Max(GetScoreSet(false), GetScoreSet(true) ) < GetRuleMatch().m_bySocreToWin[GetCurSet()-1] )
					eServeType = GetRuleMatch().m_eServe;
				else
					eServeType = GetRuleMatch().m_eServeExtend;


				//执行减分操作
				CalculatePointCount(false);
				SetScore(byScoreCurSet - 1, bTeamB);

				//判断球权
				{
					if (eServeType == EGbChangServeType.emServeTwoBalls)
					{
						if ( ( GetScoreSet(false) + GetScoreSet(true) ) % 2 == 0 )
							SetServeTeamB( !IsServeTeamB() );
					}
					else
					if (eServeType == EGbChangServeType.emServeWinOne)
					{
						//SetServeTeamB(!bTeamB);
					}
					else
					if (eServeType == EGbChangServeType.emServeOneBall)
					{
						SetServeTeamB( !IsServeTeamB() );
					}
					else
					{
						Debug.Assert(false);
					}
				}

				return EGbWinGrade.emGradeNone;
			}
		}

		public bool SetScore(Int32 byScore, bool bTeamB, Int32 bySet=CURRENT, Int32 byMatch=CURRENT)
		{
			if ( byScore > MAX_SCORE )
			{
				//Debug.Assert(false);
				byScore = MAX_SCORE;
			}

			if ( !IsValidMatchIndex(byMatch) || !IsValidSetIndex(bySet) )
			{
				return false;
			}

			if ( byMatch == CURRENT )
				byMatch = GetCurMatch();
	
			if ( bySet == CURRENT )
				bySet = GetCurSet(byMatch);

			//比分不许大于规则设定的最高分
			if ( byScore > GetRuleMatch(byMatch).m_byScoreMax[bySet-1] )
			{
				return false;
			}

			if ( bTeamB )
				m_bySetScoreB[byMatch-1,bySet-1] = byScore;
			else
				m_bySetScoreA[byMatch-1,bySet-1] = byScore;

			return true;
		}

		public SGbPointInfo GetPointInfo()
		{
			//先创建2个内容完全和自己的完全相同镜像类,为AB方

			//对镜像A TeamA加分, 镜像B TeamB加分

			//根据加分后输赢判断,得到拥有的Point

			SGbPointInfo pointInfo = new SGbPointInfo() ;

			GameGeneralBall obTempA = this.Clone();
			GameGeneralBall obTempB = this.Clone();

			//减分比分时不进行Point计算,避免死循环

			EGbWinGrade winTeamA = obTempA.SetScoreAR(false, true, false);
			EGbWinGrade winTeamB = obTempB.SetScoreAR(true,  true, false);

			// Game
			if (winTeamA == EGbWinGrade.emGradeGame && winTeamB == EGbWinGrade.emGradeGame)
			{
				pointInfo.m_eTeam = EGbTeam.emTeamBoth;
				pointInfo.m_ePoint = EGbPointInfo.emPointGame;
				pointInfo.m_byCount = 1; //下一球肯定决胜负,所以这个Point只可能有一次

			}
			else
			if (winTeamA == EGbWinGrade.emGradeGame)
			{
				pointInfo.m_eTeam = EGbTeam.emTeamA;
				pointInfo.m_ePoint = EGbPointInfo.emPointGame;
				pointInfo.m_byCount = m_byPointGameCountA;
			}
			else
			if (winTeamB == EGbWinGrade.emGradeGame)
			{
				pointInfo.m_eTeam = EGbTeam.emTeamB;
				pointInfo.m_ePoint = EGbPointInfo.emPointGame;
				pointInfo.m_byCount = m_byPointGameCountB;
			}
			else //Match
			if (winTeamA == EGbWinGrade.emGradeMatch && winTeamB == EGbWinGrade.emGradeMatch)
			{
				pointInfo.m_eTeam = EGbTeam.emTeamBoth;
				pointInfo.m_ePoint = EGbPointInfo.emPointMatch;
				pointInfo.m_byCount = 1; //下一球肯定决胜负,所以这个Point只可能有一次

			}
			else
			if (winTeamA == EGbWinGrade.emGradeMatch)
			{
				pointInfo.m_eTeam = EGbTeam.emTeamA;
				pointInfo.m_ePoint = EGbPointInfo.emPointMatch;
				pointInfo.m_byCount = m_byPointMatchCountA;
			}
			else
			if (winTeamB == EGbWinGrade.emGradeMatch)
			{
				pointInfo.m_eTeam = EGbTeam.emTeamB;
				pointInfo.m_ePoint = EGbPointInfo.emPointMatch;
				pointInfo.m_byCount = m_byPointMatchCountB;
			}
			else
			if (winTeamA == EGbWinGrade.emGradeSet && winTeamB == EGbWinGrade.emGradeSet)
			{
				pointInfo.m_eTeam = EGbTeam.emTeamBoth;
				pointInfo.m_ePoint = EGbPointInfo.emPointSet;
				pointInfo.m_byCount = 1; //下一球肯定决胜负,所以这个Point只可能有一次

			}
			else
			if (winTeamA == EGbWinGrade.emGradeSet)
			{
				pointInfo.m_eTeam = EGbTeam.emTeamA;
				pointInfo.m_ePoint = EGbPointInfo.emPointSet;
				pointInfo.m_byCount = m_byPointSetCountA;
			}
			else
			if (winTeamB == EGbWinGrade.emGradeSet)
			{
				pointInfo.m_eTeam = EGbTeam.emTeamB;
				pointInfo.m_ePoint = EGbPointInfo.emPointSet;
				pointInfo.m_byCount = m_byPointSetCountB;
			}
			else
			{
				pointInfo.m_eTeam = EGbTeam.emTeamNone;
				pointInfo.m_ePoint = EGbPointInfo.emPointNone;
				pointInfo.m_byCount = 0;
			}
	
			return pointInfo;
		}

		public Int32 GetScoreGame(bool bTeamB)
		{
			bool bRetValid;
			return GetScoreGame(bTeamB, out bRetValid);
		}
		public Int32 GetScoreGame(bool bTeamB, out bool bRetValid)
		{
			Int32 byScore = 0;
			bRetValid = false;

			for ( int nMatch=1; nMatch<=GetCurMatch(); nMatch++)
			{
				if (GetWinMatch(nMatch) == (bTeamB ? EGbTeam.emTeamB : EGbTeam.emTeamA))
				{
					byScore ++;
				}
			}

			bRetValid = true;
			return byScore;
		}

		public Int32 GetScoreMatch(bool bTeamB, Int32 byMatch=CURRENT)
		{
			bool bRetValid;
			return GetScoreMatch(bTeamB, byMatch, out bRetValid);
		}
		public Int32 GetScoreMatch(bool bTeamB, Int32 byMatch, out bool bRetValid)
		{
			bRetValid = false;

			if ( !IsValidMatchIndex(byMatch) )
			{
				return 0;
			}

			if ( byMatch > GetCurMatch() )
			{
				return 0;
			}

			Int32 byScore = 0;

			for (int nSet=1; nSet<=GetCurSet(byMatch); nSet++)
			{
				if (GetWinSet(nSet, byMatch) == (bTeamB ? EGbTeam.emTeamB : EGbTeam.emTeamA))
				{
					byScore ++;
				}
			}

			bRetValid = true;
			return byScore;
		}

		public Int32 GetScoreSet(bool bTeamB, Int32 bySet=CURRENT, Int32 byMatch=CURRENT)
		{
			bool bRetValid;
			return GetScoreSet(bTeamB, bySet, byMatch, out bRetValid);
		}
		public Int32 GetScoreSet(bool bTeamB, Int32 bySet, Int32 byMatch, out bool bRetValid)
		{
			bRetValid = false;

			if ( !IsValidMatchIndex(byMatch) || !IsValidSetIndex(bySet, byMatch) )
			{
				return 0;
			}

			if ( byMatch == CURRENT )
				byMatch = GetCurMatch();

			if ( bySet == CURRENT )
				bySet = GetCurSet(byMatch);

			//还没进行的比赛

			if ( byMatch > GetCurMatch() || bySet > GetCurSet(byMatch) )
			{
				//return 0;
				//为了能获取当前局后的比分,bRetValid还是false
				if (bTeamB)
					return m_bySetScoreB[byMatch - 1, bySet - 1];
				else
					return m_bySetScoreA[byMatch - 1, bySet - 1];
			}
	
			bRetValid = true;

			if ( bTeamB )
				return m_bySetScoreB[byMatch-1,bySet-1];
			else
				return m_bySetScoreA[byMatch-1,bySet-1];
		}

		public EGbTeam GetWinSet(Int32 bySet=CURRENT, Int32 byMatch=CURRENT)
		{
			if ( !IsValidMatchIndex(byMatch) || !IsValidSetIndex(bySet, byMatch) )
			{
				return EGbTeam.emTeamNone;
			}

			if ( byMatch == CURRENT )
				byMatch = GetCurMatch();

			if ( bySet == CURRENT )
				bySet = GetCurSet(byMatch);

			Int32 byScoreA = GetScoreSet(false, bySet, byMatch);
			Int32 byScoreB = GetScoreSet(true,  bySet, byMatch);
			Int32 byScoreMax = GetRuleMatch(byMatch).m_byScoreMax[bySet-1];
			Int32 byScoreWin = GetRuleMatch(byMatch).m_bySocreToWin[bySet-1];

			//有一方达到最高分,那肯定就是胜利,或者领先另一方1分以上,并超过获胜分
			if ( ( byScoreA > byScoreB + 1 && byScoreA >= byScoreWin ) || ( byScoreA >= byScoreMax && byScoreA > byScoreB ) )
			{
				//Debug.Assert(byScoreA > byScoreB);
				return EGbTeam.emTeamA;
			}
			else
			if ( ( byScoreB > byScoreA + 1 && byScoreB >= byScoreWin ) || ( byScoreB >= byScoreMax && byScoreB > byScoreA ) )
			{
				//Debug.Assert(byScoreB > byScoreA);
				return EGbTeam.emTeamB;
			}
			else
			{
				return EGbTeam.emTeamNone;
			}
		}

		public EGbTeam GetWinMatch()
		{
			return GetWinMatch(CURRENT);
		}
		public EGbTeam GetWinMatch(Int32 byMatch)
		{
			if ( !IsValidMatchIndex(byMatch) )
			{
				return EGbTeam.emTeamNone;
			}

			if ( byMatch == CURRENT )
				byMatch = GetCurMatch();

			Int32 byMatchA = GetScoreMatch(false, byMatch);
			Int32 byMatchB = GetScoreMatch(true,  byMatch);
			Int32 bySetNum = GetRuleMatch(byMatch).m_bySetNum;

			if ( byMatchA > byMatchB && byMatchA > bySetNum / 2 )
			{
				return EGbTeam.emTeamA;
			}
			else
			if ( byMatchB > byMatchA && byMatchB > bySetNum / 2 )
			{
				return EGbTeam.emTeamB;
			}

			return EGbTeam.emTeamNone;
		}

		public EGbTeam GetWinGame()
		{
			Int32 byGameA = GetScoreGame(false);
			Int32 byGameB = GetScoreGame(true);
			Int32 byMatchNum = GetRuleGame().m_byMatchNum;

			if ( byGameA > byGameB && byGameA > byMatchNum / 2 )
			{
				return EGbTeam.emTeamA;
			}
			else
			if ( byGameB > byGameA && byGameB > byMatchNum / 2 )
			{
				return EGbTeam.emTeamB;
			}

			return EGbTeam.emTeamNone;
		}

		public SGbRuleGame GetRuleGame()
		{
			return m_ruleGame;
		}

		//此处修改了,有可能会返回null
		public SGbRuleMatch GetRuleMatch(Int32 byMatch=CURRENT)
		{
			if ( byMatch > MAX_MATCH )
			{
				Debug.Assert(false);
				return null;
			}

			if ( byMatch == 0 )
				byMatch = m_byCurMatch + 1;

			//这里不再检测了,随时可以设置规则,无论目前是否使用了此规则
			return m_ruleGame.m_ruleMatch[byMatch-1];
		}

		public void SetRuleGame(SGbRuleGame ruleGame)
		{
			ruleGame.Valid();
			m_ruleGame = ruleGame;

			Valid();
		}

		public bool SetRuleModel(EGbGameType eGameType)
		{
			if (eGameType < EGbGameType.emGameVolleyBall || eGameType > EGbGameType.emGameBadmintonTeam)
			{
				Debug.Assert(false);
				return false;
			}

			m_ruleGame.CleanAll();

			if (eGameType == EGbGameType.emGameVolleyBall)
			{
				m_ruleGame.m_byMatchNum = 1;

				SGbRuleMatch ruleMatch = m_ruleGame.m_ruleMatch[0];
		
				ruleMatch.m_bySetNum = 5;
				ruleMatch.m_eServe = EGbChangServeType.emServeWinOne;
				ruleMatch.m_eServeExtend = EGbChangServeType.emServeWinOne;

				for(int nSet=0; nSet<ruleMatch.m_bySetNum-1; nSet++ )
				{
					ruleMatch.m_bySocreToWin[nSet] = 25;
					ruleMatch.m_byScoreMax[nSet] = MAX_SCORE;
				}

				//最后一局15个球
				ruleMatch.m_bySocreToWin[ruleMatch.m_bySetNum-1] = 15;
				ruleMatch.m_byScoreMax[ruleMatch.m_bySetNum-1] = MAX_SCORE;
			}
			else
			if (eGameType == EGbGameType.emGameBeachVolleyBall)
			{
				m_ruleGame.m_byMatchNum = 1;

				SGbRuleMatch ruleMatch = m_ruleGame.m_ruleMatch[0];

				ruleMatch.m_bySetNum = 3;
				ruleMatch.m_eServe = EGbChangServeType.emServeWinOne;
				ruleMatch.m_eServeExtend = EGbChangServeType.emServeWinOne;

				for(int nSet=0; nSet<ruleMatch.m_bySetNum-1; nSet++ )
				{
					ruleMatch.m_bySocreToWin[nSet] = 21;
					ruleMatch.m_byScoreMax[nSet] = MAX_SCORE;
				}

				//最后一局15个球
				ruleMatch.m_bySocreToWin[ruleMatch.m_bySetNum-1] = 15;
				ruleMatch.m_byScoreMax[ruleMatch.m_bySetNum-1] = MAX_SCORE;
			}
			else
			if (eGameType == EGbGameType.emGamePingPongBall)
			{
				m_ruleGame.m_byMatchNum = 1;

				SGbRuleMatch ruleMatch = m_ruleGame.m_ruleMatch[0];

				ruleMatch.m_bySetNum = 7;
				ruleMatch.m_eServe = EGbChangServeType.emServeTwoBalls;
				ruleMatch.m_eServeExtend = EGbChangServeType.emServeOneBall;

				for(int nSet=0; nSet<ruleMatch.m_bySetNum-1; nSet++ )
				{
					ruleMatch.m_bySocreToWin[nSet] = 11;
					ruleMatch.m_byScoreMax[nSet] = MAX_SCORE;
				}
			}
			else
			if (eGameType == EGbGameType.emGamePingPongBallTeam)
			{
				m_ruleGame.m_byMatchNum = 5;

				for(int nMatch=0; nMatch<m_ruleGame.m_byMatchNum; nMatch++)
				{
					SGbRuleMatch ruleMatch = m_ruleGame.m_ruleMatch[nMatch];

					ruleMatch.m_bySetNum = 5;
					ruleMatch.m_eServe = EGbChangServeType.emServeTwoBalls;
					ruleMatch.m_eServeExtend = EGbChangServeType.emServeOneBall;

					for(int nSet=0; nSet<ruleMatch.m_bySetNum-1; nSet++ )
					{
						ruleMatch.m_bySocreToWin[nSet] = 11;
						ruleMatch.m_byScoreMax[nSet] = MAX_SCORE;
					}
				}
			}
			else
			if (eGameType == EGbGameType.emGameBadminton)
			{
				m_ruleGame.m_byMatchNum = 1;

				SGbRuleMatch ruleMatch = m_ruleGame.m_ruleMatch[0];

				ruleMatch.m_bySetNum = 3;
				ruleMatch.m_eServe = EGbChangServeType.emServeWinOne;
				ruleMatch.m_eServeExtend = EGbChangServeType.emServeWinOne;

				for(int nSet=0; nSet<ruleMatch.m_bySetNum-1; nSet++ )
				{
					ruleMatch.m_bySocreToWin[nSet] = 21;
					ruleMatch.m_byScoreMax[nSet] = 30;
				}
			}
			else
			if (eGameType == EGbGameType.emGameBadmintonTeam)
			{
				m_ruleGame.m_byMatchNum = 5;

				for(int nMatch=0; nMatch<m_ruleGame.m_byMatchNum; nMatch++)
				{
					SGbRuleMatch ruleMatch = m_ruleGame.m_ruleMatch[nMatch];

					ruleMatch.m_bySetNum = 3;
					ruleMatch.m_eServe = EGbChangServeType.emServeWinOne;
					ruleMatch.m_eServeExtend = EGbChangServeType.emServeWinOne;

					for(int nSet=0; nSet<ruleMatch.m_bySetNum-1; nSet++ )
					{
						ruleMatch.m_bySocreToWin[nSet] = 21;
						ruleMatch.m_byScoreMax[nSet] = 30;
					}
				}
			}

			Valid();

			return true;
		}

		public SGbByteInfo GetByteInfo()
		{
			CalculateTime();

			SGbByteInfo netInfo = new SGbByteInfo();

			netInfo.m_ruleGame = m_ruleGame.Clone();
			netInfo.m_byCurMatch = m_byCurMatch;
			netInfo.m_bServeTeamB = m_bServeTeamB;

			netInfo.m_byPointSetCountA = m_byPointSetCountA;
			netInfo.m_byPointSetCountB = m_byPointSetCountB;
			netInfo.m_byPointMatchCountA = m_byPointMatchCountA;
			netInfo.m_byPointMatchCountB = m_byPointMatchCountB;
			netInfo.m_byPointGameCountA = m_byPointGameCountA;
			netInfo.m_byPointGameCountB = m_byPointGameCountB;

			for (int nMatch=0; nMatch<MAX_MATCH; nMatch++)
			{
				netInfo.m_byCurSet[nMatch] = m_byCurSet[nMatch];

				for (int nSet=0; nSet<MAX_SET; nSet++)
				{
					netInfo.m_dwTime[nMatch,nSet] = m_dwTimeSet[nMatch,nSet];
					netInfo.m_bySetScoreA[nMatch,nSet] = m_bySetScoreA[nMatch,nSet];
					netInfo.m_bySetScoreB[nMatch,nSet] = m_bySetScoreB[nMatch,nSet];
				}
			}

			return netInfo;
		}

		public bool SetByteInfo(SGbByteInfo byteInfo)
		{
			if ( byteInfo == null || byteInfo.m_byStart != '[' || byteInfo.m_byEnd != ']' )
			{
				Debug.Assert(false);
				return false;
			}
	
			SetTimeRun(false);

			m_ruleGame = byteInfo.m_ruleGame;
			m_byCurMatch = byteInfo.m_byCurMatch;
			m_bServeTeamB = byteInfo.m_bServeTeamB;

			m_byPointSetCountA = byteInfo.m_byPointSetCountA;
			m_byPointSetCountB = byteInfo.m_byPointSetCountB;
			m_byPointMatchCountA = byteInfo.m_byPointMatchCountA;
			m_byPointMatchCountB = byteInfo.m_byPointMatchCountB;
			m_byPointGameCountA = byteInfo.m_byPointGameCountA;
			m_byPointGameCountB = byteInfo.m_byPointGameCountB;

			for (int nMatch=0; nMatch<MAX_MATCH; nMatch++)
			{
				m_byCurSet[nMatch] = byteInfo.m_byCurSet[nMatch];

				for (int nSet=0; nSet<MAX_SET; nSet++)
				{
					m_dwTimeSet[nMatch,nSet] = byteInfo.m_dwTime[nMatch,nSet];
					m_bySetScoreA[nMatch,nSet] = byteInfo.m_bySetScoreA[nMatch,nSet];
					m_bySetScoreB[nMatch,nSet] = byteInfo.m_bySetScoreB[nMatch,nSet];
				}
			}

			return true;
		}

		public String GetScoreGameStr(bool bTeamB)
		{
			bool bRetValid;
			Int32 byScore = GetScoreGame(bTeamB, out bRetValid);
	
			if ( !bRetValid )
				return "";
			
			return byScore.ToString();
		}

		public String GetScoreMatchStr(bool bTeamB, Int32 byMatch=CURRENT)
		{
			bool bRetValid;
			Int32 byScore = GetScoreMatch(bTeamB, byMatch, out bRetValid);

			if ( !bRetValid )
				return "";

			return byScore.ToString();
		}

		public String GetScoreSetStr(bool bTeamB, Int32 bySet=CURRENT, Int32 byMatch=CURRENT)
		{
			bool bRetValid;
			Int32 byScore = GetScoreSet(bTeamB, bySet, byMatch, out bRetValid);

			if ( !bRetValid )
				return "";
		
			return byScore.ToString();
		}

		//时钟操作
		public bool IsTimeRun()
		{
			return m_bTimeIsRun;
		}

		public void SetTimeRun(bool bTimeIsRun)
		{
			if (bTimeIsRun)
			{
				if (!m_bTimeIsRun)
				{
					m_bTimeIsRun = true;
					m_dwTimeStart = (uint)System.Environment.TickCount;
				}
			}
			else
			{
				CalculateTime();
				m_dwTimeStart = 0;
				m_bTimeIsRun = false;
			}
		}

		public UInt32 GetTimeGame()
		{
			Boolean bRetValid = new Boolean();
			return GetTimeGame(bRetValid);
		}
		public UInt32 GetTimeGame(Boolean bRetValid)
		{
			CalculateTime();

			bRetValid = true;

			UInt32 dwTimeTotal = 0;
			for ( int nMatch=1; nMatch<=m_byCurMatch; nMatch++ )
			{
				UInt32 dwCurMatchTime = GetTimeMatch(nMatch);
				dwTimeTotal += dwCurMatchTime;
			}

			return dwTimeTotal;
		}

		public UInt32 GetTimeMatch(Int32 byMatch=CURRENT)
		{
			bool bRetValid;
			return GetTimeMatch(byMatch, out bRetValid);
		}
		public UInt32 GetTimeMatch(Int32 byMatch, out bool bRetValid)
		{
			bRetValid = false;

			if ( !IsValidMatchIndex(byMatch) )
			{
				return 0;
			}

			if ( byMatch == CURRENT )
				byMatch = GetCurMatch();

			CalculateTime();
			bRetValid = true;

			//直接使用设定的时间
			return m_dwTimeMatch[byMatch - 1];
		}

		public UInt32 GetTimeSet(Int32 bySet=CURRENT, Int32 byMatch=CURRENT)
		{
			bool bRetValid;
			return GetTimeSet(bySet, byMatch, out bRetValid);
		}
		public UInt32 GetTimeSet(Int32 bySet, Int32 byMatch, out bool bRetValid)
		{
			bRetValid = false;

			if ( !IsValidMatchIndex(byMatch) || !IsValidSetIndex(bySet) )
			{
				return 0;
			}

			if ( byMatch == CURRENT )
				byMatch = GetCurMatch();

			if ( bySet == CURRENT )
				bySet = GetCurSet(byMatch);

			CalculateTime();
	
			if ( byMatch > GetCurMatch() || bySet > GetCurSet(byMatch) )
			{
				//return 0;
				//为了能获取当前局后的时间,bRetValid还是false
				return m_dwTimeSet[byMatch - 1, bySet - 1];
			}

			bRetValid = true;
			return m_dwTimeSet[byMatch-1,bySet-1];
		}

		public bool SetTimeSet(String strTime, Int32 bySet = CURRENT, Int32 byMatch = CURRENT)
		{
			if ( !IsValidMatchIndex(byMatch) || !IsValidSetIndex(bySet) )
			{
				return false;
			}

			if ( byMatch == CURRENT )
				byMatch = GetCurMatch();

			if ( bySet == CURRENT )
				bySet = GetCurSet();

			UInt32 dwTime = TimeStrToInt(strTime);

			m_dwTimeSet[byMatch-1,bySet-1] = dwTime;

			if ( m_bTimeIsRun && GetCurMatch() == byMatch && GetCurSet() == bySet )
			{
				//如果更改当前局的时间,并且再走时中,则从新开始计时
				m_dwTimeStart = (uint)System.Environment.TickCount;	
			}

			_calculateMatchTime();

			return true;
		}
		
		public bool SetTimeMatch(String strTime, Int32 byMatch=CURRENT)
		{
			if (!IsValidMatchIndex(byMatch) )
			{
				return false;
			}

			if (byMatch == CURRENT)
				byMatch = GetCurMatch();

			UInt32 dwTime = TimeStrToInt(strTime);
			m_dwTimeMatch[byMatch - 1] = dwTime;

			return true;
		}

		public String GetTimeSetStr(Int32 bySet=CURRENT, Int32 byMatch=CURRENT)
		{
			return GetTimeSetStr(bySet, byMatch, false);
		}
		public String GetTimeSetStr(Int32 bySet, Int32 byMatch, bool bNeedSec)
		{
			bool bRetValid;
			UInt32 dwTime = GetTimeSet(bySet, byMatch, out bRetValid);

			if ( !bRetValid )
				return "";

			return TimeIntToStr(dwTime, bNeedSec);
		}

		public String GetTimeMatchStr(Int32 byMatch=CURRENT)
		{
			return GetTimeMatchStr(byMatch, false);
		}
		public String GetTimeMatchStr(Int32 byMatch, bool bNeedSec)
		{
			bool bRetValid;
			UInt32 dwTime = GetTimeMatch(byMatch, out bRetValid);

			if ( !bRetValid )
				return "";
	
			return TimeIntToStr(dwTime, bNeedSec);
		}

		public String GetTimeGameStr(bool bNeedSec=false)
		{
			Boolean bRetValid = new Boolean();
			UInt32 dwTime = GetTimeGame(bRetValid);

			if ( !bRetValid )
				return "";

			return TimeIntToStr(dwTime, bNeedSec);
		}
    }
}
