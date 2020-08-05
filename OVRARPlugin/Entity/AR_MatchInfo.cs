using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoSports.OVRARPlugin
{


    public class AR_MatchInfo
    {

        private string m_strEventName = "";
        private string m_strPhaseName = "";
        private string m_strMatchName = "";
        private int m_nCurMatchID = -1;
        private int m_nCurPhaseID = -1;
        private int m_nCurEventID = -1;
        private string m_strEventCode = "";
        private string m_strPhaseCode = "";
        private string m_strMatchCode = "";
        private string m_strSexCode = "";
        private int m_nEndCount = 0;
        private int m_nArrowCount = 0;
        private int m_nIsSetPoints = 0;
        private int m_nWinPoints = 0;
        private int m_nMatchStatusID = -1;
        private int m_iCurMatchRuleID = -1;
        private int m_iDisciplineID = -1;
        private int m_nDistinceID = 1;
        private int m_nPlayerA = -1;
        private int m_nPlayerB = -1;
        private string m_strTargetA = string.Empty;
        private string m_strTargetB = string.Empty;

        public int MatchID
        {
            get { return m_nCurMatchID; }
            set { m_nCurMatchID = value; }

        }

        public int PhaseID
        {
            get { return m_nCurPhaseID; }
            set { m_nCurPhaseID = value; }

        }
        public int EventID
        {
            get { return m_nCurEventID; }
            set { m_nCurEventID = value; }

        }
        public string EventCode
        {
            get { return m_strEventCode; }
            set { m_strEventCode = value; }
        }

        public string EventName
        {
            get { return m_strEventName; }
            set { m_strEventName = value; }
        }

        public string PhaseCode
        {
            get { return m_strPhaseCode; }
            set { m_strPhaseCode = value; }
        }
        public string PhaseName
        {
            get { return m_strPhaseName; }
            set { m_strPhaseName = value; }
        }
        public string MatchCode
        {
            get { return m_strMatchCode; }
            set { m_strMatchCode = value; }
        }
        public string MatchName
        {
            get { return m_strMatchName; }
            set { m_strMatchName = value; }
        }

        public string SexCode
        {
            get { return m_strSexCode; }
            set { m_strSexCode = value; }
        }

        public int EndCount
        {
            get { return m_nEndCount; }
            set { m_nEndCount = value; }
        }

        public int ArrowCount
        {
            get { return m_nArrowCount; }
            set { m_nArrowCount = value; }

        }
        public int IsSetPoints
        {
            get { return m_nIsSetPoints; }
            set { m_nIsSetPoints = value; }
        }

        public int WinPoints
        {
            get { return m_nWinPoints; }
            set { m_nWinPoints = value; }
        }
        public int MatchStatusID
        {
            get { return m_iCurMatchRuleID; }
            set { m_iCurMatchRuleID = value; }
        }
        public int CurMatchRuleID
        {
            get { return m_nMatchStatusID; }
            set { m_nMatchStatusID = value; }
        }

        public int DisciplineID
        {
            get { return m_iDisciplineID; }
            set { m_iDisciplineID = value; }
        }
        public int Distince
        {
            get { return m_nDistinceID; }
            set { m_nDistinceID = value; }
        }
        public int PlayerA
        {
            get { return m_nPlayerA; }
            set { m_nPlayerA = value; }
        }
        public int PlayerB
        {
            get { return m_nPlayerB; }
            set { m_nPlayerB = value; }
        }
        public string TargetA
        {
            get { return m_strTargetA; }
            set { m_strTargetA = value; }
        }
        public string TargetB
        {
            get { return m_strTargetB; }
            set { m_strTargetB = value; }
        }

        public string GetDisplayName()
        {
            string strInfo = "";
            strInfo += m_strEventName;
            strInfo += "\n";
            strInfo += m_strPhaseName;
            strInfo += "  ";
            strInfo += m_strMatchName;
            return strInfo;

        }
    }
}
