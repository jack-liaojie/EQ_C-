using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoSports.OVRWPPlugin
{
    #region DML Setup for Player Object
    public struct SPlayerInfo
    {
        public int iRegisterID;
        public int iShirtNumber;
        public string strRegisterName;
        public int iStartTime;   //以秒为单位的时间数

        public int iEndTime;     //以秒为单位的时间数


        public void Init()
        {
            iRegisterID = -1;
            iShirtNumber = -1;
            iStartTime = -1;
            iEndTime = -1;
            strRegisterName = "";
        }
    }
    #endregion

    #region DML Setup for Team Object
    public class OVRWPTeamInfo
    {
        private string m_strTeamName;
        public string TeamName
        {
            get { return m_strTeamName; }
            set { m_strTeamName = value; }
        }

        private int m_iTeamID;
        public int TeamID
        {
            get { return m_iTeamID; }
            set { m_iTeamID = value; }
        }

        private int m_iTeamPosition;
        public int TeamPosition
        {
            get { return m_iTeamPosition; }
            set { m_iTeamPosition = value; }
        }

        private int m_iTeamPoints;
        public int TeamPoint
        {
            get { return m_iTeamPoints; }
            set { m_iTeamPoints = value; }
        }

        private string[] SetPoints = new string[GVAR.MAXSETNUM];
        private int[] iRank = new int[GVAR.MAXSETNUM];
        private int[] iResult = new int[GVAR.MAXSETNUM];

        public OVRWPTeamInfo()
        {
            Init();
        }

        public void Init()
        {
            m_strTeamName = "";
            m_iTeamID = -1;
            m_iTeamPosition = -1;
            m_iTeamPoints = -1;

            InitScore();
            InitResult();
        }

        public void InitScore()
        {
            for (int i = 0; i < GVAR.MAXSETNUM; i++)
            {
                SetPoints[i] = "";
            }
        }

        public void InitResult()
        {
            for (int i = 0; i < GVAR.MAXSETNUM; i++)
            {
                iRank[i] = GVAR.RANK_TYPE_TIE;
                iResult[i] = GVAR.RESULT_TYPE_TIE;
            }
        }
        public string GetScore(int iSet)
        {
            if (iSet == GVAR.PERIOD_PSO)
            {
                iSet = GVAR.MAXSETNUM;
            }
            if (iSet < 0 ||iSet > GVAR.MAXSETNUM)
            {
                return "";
            }
            else
            {
                return SetPoints[iSet - 1];
            }
        }

        public void SetScore(string strScore, int iSet)
        {
            if (iSet == GVAR.PERIOD_PSO)
            {
                iSet = GVAR.MAXSETNUM;
            }
            if (iSet > 0 && iSet <= GVAR.MAXSETNUM)
            {
                SetPoints[iSet - 1] = strScore;
            }
        }

        public int GetRank(int iSet)
        {
            if (iSet == GVAR.PERIOD_PSO)
            {
                iSet = GVAR.MAXSETNUM;
            }
            if (iSet < 0 || iSet > GVAR.MAXSETNUM)
            {
                return -1;
            }
            else
            {
                return iRank[iSet - 1];
            }
        }

        public void SetRank(int iSet, int iTempRank)
        {
            if (iSet == GVAR.PERIOD_PSO)
            {
                iSet = GVAR.MAXSETNUM;
            }
            if (iSet > 0 && iSet <= GVAR.MAXSETNUM)
            {
                iRank[iSet - 1] = iTempRank;
            }
        }

        public int GetResult(int iSet)
        {
            if (iSet == GVAR.PERIOD_PSO)
            {
                iSet = GVAR.MAXSETNUM;
            }
            if (iSet < 0 || iSet > GVAR.MAXSETNUM)
            {
                return -1;
            }
            else
            {
                return iResult[iSet - 1];
            }
        }

        public void SetResult(int iSet, int iTempResult)
        {
            if (iSet == GVAR.PERIOD_PSO)
            {
                iSet = GVAR.MAXSETNUM;
            }
            if (iSet > 0 && iSet <= GVAR.MAXSETNUM)
            {
                iResult[iSet - 1] = iTempResult;
            }
        }
    }
    #endregion


    #region DML  Setup for Match Object
    public class OVRWPMatchInfo
    {
        private string m_strMatchID;
        public string MatchID
        {
            get { return m_strMatchID; }
            set { m_strMatchID = value; }
        }

        private string m_strMatchCode;
        public string MatchCode
        {
            get { return m_strMatchCode; }
            set { m_strMatchCode = value; }
        }

        private int m_iMatchType;
        public int MatchType
        {
            get { return m_iMatchType; }
            set { m_iMatchType = value; }
        }
        private string m_strSportDes;
        public string SportDes
        {
            get { return m_strSportDes; }
            set { m_strSportDes = value; }
        }

        private string m_strVenueDes;
        public string VenueDes
        {
            get { return m_strVenueDes; }
            set { m_strVenueDes = value; }
        }

        private string m_strPhaseDes;
        public string PhaseDes
        {
            get { return m_strPhaseDes; }
            set { m_strPhaseDes = value; }
        }

        private string m_strDateDes;
        public string DateDes
        {
            get { return m_strDateDes; }
            set { m_strDateDes = value; }
        }
        private int m_iMatchStauts;
        public int MatchStatus
        {
            get { return m_iMatchStauts; }
            set { m_iMatchStauts = value; }
        }

        private int m_iPeriod;
        public int CurPeriod
        {
            get { return m_iPeriod; }
            set { m_iPeriod = value; }
        }

        private string m_strMatchTime;
        public string MatchTime
        {
            get { return m_strMatchTime; }
            set { m_strMatchTime = value; }
        }

        private bool m_bRunTime;
        public bool bRunTime
        {
            get { return m_bRunTime; }
            set { m_bRunTime = value; }
        }

        private bool m_bIsPoolMatch;
        public bool bPoolMatch
        {
            get { return m_bIsPoolMatch; }
            set { m_bIsPoolMatch = value; }
        }
        public OVRWPTeamInfo m_CHomeTeam = new OVRWPTeamInfo();
        public OVRWPTeamInfo m_CVisitTeam = new OVRWPTeamInfo();

        public OVRWPMatchInfo()
        {
            Init();
        }

        public void Init()
        {
            m_strMatchID = "";
            m_strMatchCode = "";
            m_strSportDes = "";
            m_strVenueDes = "";
            m_strPhaseDes = "";
            m_strDateDes = "";
            m_iMatchStauts = 0;
            m_iPeriod = 0;
            m_bRunTime = false;
            m_bIsPoolMatch = false;

            m_CHomeTeam.Init();
            m_CVisitTeam.Init();
            InitTime();
        }

        public void InitTime()
        {
            if (m_iPeriod < GVAR.PERIOD_EXTRA1 && m_iPeriod > 0)
            {
                m_strMatchTime = GVAR.MATCH_TIME;
            }
            else if (m_iPeriod >= GVAR.PERIOD_EXTRA1 && m_iPeriod <= GVAR.PERIOD_EXTRA2)
            {
                m_strMatchTime = GVAR.EXTRA_TIME;
            }
            else if (m_iPeriod == GVAR.PERIOD_PSO)
            {
                m_strMatchTime = GVAR.PSO_TIME;
            }
            else 
            {
                m_strMatchTime = "";
            }
        }

        public int ChangePoint(int iTeamPos, bool bAdd, int iPoint,int iPeriod)
        {
            int iResult = 0;
            if (iPeriod <= 0)
                return iResult;
            if (m_CHomeTeam.GetScore(iPeriod).Length == 0)
            {
                m_CHomeTeam.SetScore("0", iPeriod);
            }
            if (m_CVisitTeam.GetScore(iPeriod).Length == 0)
            {
                m_CVisitTeam.SetScore("0", iPeriod);
            }


            OVRWPTeamInfo  tmpTeam = new OVRWPTeamInfo();
             int iSetPt;
            if(iTeamPos == 1)
            {
                tmpTeam = m_CHomeTeam;
            }
            else if(iTeamPos == 2)
            {
                tmpTeam = m_CVisitTeam;
            }

            if (bAdd)
            {
                iSetPt = GVAR.Str2Int(tmpTeam.GetScore(iPeriod)) + 1;
            }
            else
            {
                iSetPt = Math.Max(GVAR.Str2Int(tmpTeam.GetScore(iPeriod)) - 1, 0);
            }
            tmpTeam.SetScore(iSetPt.ToString(), iPeriod);

            //计算总分
            int iHomePt = 0;
            int iVisitPt = 0;
            for (int i = 1; i <= GVAR.MAXSETNUM; i++)
            {
                iHomePt += GVAR.Str2Int(m_CHomeTeam.GetScore(i));
                iVisitPt += GVAR.Str2Int(m_CVisitTeam.GetScore(i));             
            }
            m_CHomeTeam.TeamPoint = iHomePt;
            m_CVisitTeam.TeamPoint = iVisitPt;
            iResult = 1;
            return iResult;
        }

        public int ChangePeriod(bool bAdd)
        {
            if (bAdd)
            {
                if (m_iPeriod == GVAR.PERIOD_EXTRA2)
                {
                    m_iPeriod = GVAR.PERIOD_PSO;
                    //if (m_CHomeTeam.GetScore(m_iPeriod).Length == 0)
                    //{
                    //    m_CHomeTeam.SetScore("0", m_iPeriod);
                    //}
                    //if (m_CVisitTeam.GetScore(m_iPeriod).Length == 0)
                    //{
                    //    m_CVisitTeam.SetScore("0", m_iPeriod);
                    //}
                    return 1;
                }
                 m_iPeriod = m_iPeriod + 1;
            }
            else
            {
                if (m_iPeriod == 1)
                    return 0;

                if (m_iPeriod == GVAR.PERIOD_PSO)
                {
                    m_iPeriod = GVAR.PERIOD_EXTRA2;

                }
                else
                {
                    m_iPeriod = m_iPeriod - 1;
                }
            }

            //if (m_CHomeTeam.GetScore(m_iPeriod).Length == 0)
            //{
            //    m_CHomeTeam.SetScore("0", m_iPeriod);
            //}
            //if (m_CVisitTeam.GetScore(m_iPeriod).Length == 0)
            //{
            //    m_CVisitTeam.SetScore("0", m_iPeriod);
            //}
            return 1;
        }
    }
#endregion
}
