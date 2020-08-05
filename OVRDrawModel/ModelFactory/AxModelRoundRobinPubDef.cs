using System;
using System.Collections.Generic;
using System.Text;

// 对于贝克尔算法生成的比赛,也一样
// 1vs0 表示这个组里第一个队此场轮空

//,stRrGroup (第一组) 有几个对象
//<AryRrRounds>
//	 ┣ ,stRrRound (第一轮) 1-x
//	 ┃   <AryRrMatchs>
//	 ┃		┣ ,stRrMatch(一场比赛 1vs4) 1-1	
//	 ┃		┗ ,stRrMatch(一场比赛 2vs3) 1-2
//	 ┃		
//	 ┣ ,stRrRound (第二轮) 2-x
//	 ┃   <AryRrMatchs>
//	 ┃		┣ ,stRrMatch(一场比赛 1vs4) 2-1	
//	 ┃		┗ ,stRrMatch(一场比赛 2vs3) 2-2
//	 ┃		
//	 ┗ ,stRrRound (第三轮) 3-x
//	    <AryRrMatchs>
//	 		┣ ,stRrMatch(一场比赛 1vs4) 3-1	
//	 		┗ ,stRrMatch(一场比赛 2vs3) 3-2
//	 		

namespace AutoSports.OVRDrawModel
{
    //一场比赛对象
    public class stRrMatch
    {
        public Byte m_byPlayerL;	//Player标识,是Group中m_byPlayerCnt的序号, 为0表示轮空
        public Byte m_byPlayerR;	

	    public stRrMatch()
        {
            m_byPlayerL = 0;
            m_byPlayerR = 0;
        }
    }

    //一个小组循环中的一轮
    public class stRrRound
    {
        public List<stRrMatch> m_aryAllMatch;

        public stRrRound()
        {
            m_aryAllMatch = new List<stRrMatch>();
        }

        public void RemoveAll()
        {
            m_aryAllMatch.Clear();
        }

        public Int32 GetMatchCount()
        {
            return m_aryAllMatch.Count;
        }

        public Int32 AddMatchObj(stRrMatch rrMatch)
        {
            m_aryAllMatch.Add(rrMatch);
            return m_aryAllMatch.Count;
        }

        public stRrMatch GetMatchObj(int nIndex)
        {
            if (nIndex < 0 || nIndex >= GetMatchCount())
            {
                return null;
            }

            return m_aryAllMatch[nIndex];
        }
    }

    //一个小组,一个小组的所有比赛都在这组里
    public class stRrGroup
    {
        public Byte m_byPlayerCnt;	//该组中运动员人数
        public List<stRrRound> m_aryAllRound;

        public stRrGroup()
        {
            m_byPlayerCnt = 0;
            m_aryAllRound = new List<stRrRound>();
        }

        public void RemoveAll()
        {
            m_byPlayerCnt = 0;
            m_aryAllRound.Clear();
        }

        public Int32 GetRoundCount()
        {
            return m_aryAllRound.Count;
        }

        public Int32 AddRoundObj(stRrRound rrRound)
        {
            m_aryAllRound.Add(rrRound);
            return m_aryAllRound.Count;
        }

        public stRrRound GetRoundObj(int nIndex)
        {
            stRrRound rrRound = new stRrRound();
            if(nIndex >= 0 && nIndex < m_aryAllRound.Count)
            {
                return m_aryAllRound[nIndex];
            }

            return rrRound;
        }

        public Byte GetPlayerCnt() 
        {
            return m_byPlayerCnt;
        }

        public void SetPlayerCnt(Byte byPlayerCnt)
        {
            m_byPlayerCnt = byPlayerCnt;
        }
    }
}
