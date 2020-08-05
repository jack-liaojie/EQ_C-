using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoSports.OVRBKPlugin
{
 
     public enum EActionType
    {
        emUnKnow = -1,   //未知
        em2PointsMade = 1021,
        em2PointsMissed = 1022,
        em3PointsMade = 1031,
        em3PointsMissed = 1032,
        emFreeThrowMade = 1041,
        emFreeThrowMissed = 1042,
        emOffensiveRebound = 1051,
        emDefensiveRebound = 1052,
        emAssist = 1060,
        emTurnover = 1070,
        emSteal = 1080,
        emBlockedShot = 1090,
        emOffensiveFoul = 1101,
        emDefensiveFoul = 1102,
        emSubstituteIn = 1601,
        emSubstituteOut = 1602, 
    }

    public class OVRBKActionInfo
    {
        private int m_iActionID;
        public int AcitonID
        {
            get { return m_iActionID; }
            set { m_iActionID = value; }
        }

        private int m_iTeamPos;
        public int TeamPos
        {
            get { return m_iTeamPos; }
            set { m_iTeamPos = value; }
        }

        private int m_iMatchID;
        public int MatchID
        {
            get { return m_iMatchID; }
            set { m_iMatchID = value; }
        }

        private int m_iMatchSplitID;
        public int MatchSplitID
        {
            get { return m_iMatchSplitID; }
            set { m_iMatchSplitID = value; }
        }

        private int m_iTeamID;
        public int TeamID
        {
            get { return m_iTeamID; }
            set { m_iTeamID = value; }
        }

        private int m_iRegisterID;
        public int RegisterID
        {
            get { return m_iRegisterID; }
            set { m_iRegisterID = value; }
        }

        private int m_iShirtNo;
        public int ShirtNo
        {
            get { return m_iShirtNo; }
            set { m_iShirtNo = value; }
        }

        private string m_strTeamName;
        public string TeamName
        {
            get { return m_strTeamName; }
            set { m_strTeamName = value; }
        }

        private string m_strPlayerName;
        public string PlayerName
        {
            get { return m_strPlayerName; }
            set { m_strPlayerName = value; }
        }

        private string m_strActionCode;
        public string ActionCode
        {
            get { return m_strActionCode; }
            set { m_strActionCode = value; }
        }

        private string m_strActionTime;
        public string ActionTime
        {
            get { return m_strActionTime; }
            set { m_strActionTime = value; }
        }

        private bool m_bActionComplete;
        public bool ActionComplete
        {
            get { return m_bActionComplete; }
            set { m_bActionComplete = value; }
        }

        private EActionType m_emActionType;
        public EActionType ActionType
        {
            get { return m_emActionType; }
            set { m_emActionType = value; }
        }

        private string m_strActionDes;
        public string ActionDes
        {
            get { return m_strActionDes; }
            set { m_strActionDes = value; }
        }

        public OVRBKActionInfo()
        {
            Init();
        }

        public void Init()
        {
            m_iActionID = -1;
            m_iMatchID = -1;
            m_iMatchSplitID = -1;
            m_iRegisterID = -1;
            m_iShirtNo = -1;
            m_iTeamPos = -1;
            m_strTeamName = "";
            m_strPlayerName = "";
            m_strActionCode = "";
            m_bActionComplete = false;

            m_emActionType = EActionType.emUnKnow;
            m_strActionDes = "";
        }

        public void InitAction(OVRBKMatchInfo tmpMatch, int iMatchSplitID)
        {
            m_iMatchID = GVAR.Str2Int(tmpMatch.MatchID);
            m_iMatchSplitID = iMatchSplitID;
        }

        public bool IsActionComplete()    //判断此Action是否结束
        {
            if (m_strActionCode != null && m_strActionCode.Length != 0 && m_iRegisterID != -1 && m_iMatchID != -1)
            {
                m_bActionComplete = true;
            }
            return m_bActionComplete;
        }

        public bool IsNewAction()     //判断此Action是否是新的        {
            if (m_iMatchID == -1 && m_iMatchSplitID == -1)
                return true;
            else
                return false;
        }

        public void GetActionCode()
        {
            m_strActionCode = ((int)m_emActionType).ToString();
        }
    }
}
