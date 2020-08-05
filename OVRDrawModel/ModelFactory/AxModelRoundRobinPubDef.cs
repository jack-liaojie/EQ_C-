using System;
using System.Collections.Generic;
using System.Text;

// ���ڱ��˶��㷨���ɵı���,Ҳһ��
// 1vs0 ��ʾ��������һ���Ӵ˳��ֿ�

//,stRrGroup (��һ��) �м�������
//<AryRrRounds>
//	 �� ,stRrRound (��һ��) 1-x
//	 ��   <AryRrMatchs>
//	 ��		�� ,stRrMatch(һ������ 1vs4) 1-1	
//	 ��		�� ,stRrMatch(һ������ 2vs3) 1-2
//	 ��		
//	 �� ,stRrRound (�ڶ���) 2-x
//	 ��   <AryRrMatchs>
//	 ��		�� ,stRrMatch(һ������ 1vs4) 2-1	
//	 ��		�� ,stRrMatch(һ������ 2vs3) 2-2
//	 ��		
//	 �� ,stRrRound (������) 3-x
//	    <AryRrMatchs>
//	 		�� ,stRrMatch(һ������ 1vs4) 3-1	
//	 		�� ,stRrMatch(һ������ 2vs3) 3-2
//	 		

namespace AutoSports.OVRDrawModel
{
    //һ����������
    public class stRrMatch
    {
        public Byte m_byPlayerL;	//Player��ʶ,��Group��m_byPlayerCnt�����, Ϊ0��ʾ�ֿ�
        public Byte m_byPlayerR;	

	    public stRrMatch()
        {
            m_byPlayerL = 0;
            m_byPlayerR = 0;
        }
    }

    //һ��С��ѭ���е�һ��
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

    //һ��С��,һ��С������б�������������
    public class stRrGroup
    {
        public Byte m_byPlayerCnt;	//�������˶�Ա����
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
