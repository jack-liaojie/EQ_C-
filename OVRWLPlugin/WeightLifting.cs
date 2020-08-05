using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoSports.OVRWLPlugin
{
    public class WeightLifting
    {
        #region private variable
        private int m_nRowIdx = -1;
        private string m_strComPos = "";
        private string m_strRegisterID = "";
        private string m_strBib = "";
        private string m_strGroup = "";
        private string m_strName = "";
        private string m_strNoc = "";
        private string m_strLightOrder = "";
        private string m_str1stAttempt = "";
        private string m_str2ndAttempt = "";
        private string m_str3rdAttempt = "";
        private string m_str1stRes = "";
        private string m_str2ndRes = "";
        private string m_str3rdRes = "";
        private int m_nAttemptIdx = -1;
        private string m_strAttempt = "";
        private string m_strResult = "";
        private string m_strBodyWeight = "";
        private string m_strIRM = "";
        private string m_strStatus = "";
        private string m_strFinishOrder = "";
        private string m_strRecord = "";

        private string m_strSnatchResult = "";
        private string m_strSnatchIRM = "";
        private string m_strCleanJerkResult = "";
        private string m_strCleanJerkIRM = "";
        private string m_strTotalResult = "";
        private string m_strTotalIRM = "";
        private string m_strTotalRank = "";

        private string m_strRank = "";
        private string m_strDisplayPosition = "";
        #endregion

        public int RowIndex
        {
            get { return m_nRowIdx; }
            set { m_nRowIdx = value; }
        }
        public string CompetitionPosition
        {
            get { return m_strComPos; }
            set { m_strComPos = value; }
        }
        public string RegisterID
        {
            get { return m_strRegisterID; }
            set { m_strRegisterID = value; }
        }
        public string LightOrder
        {
            get { return m_strLightOrder; }
            set { m_strLightOrder = value; }
        }
        public string Bib
        {
            get { return m_strBib; }
            set { m_strBib = value; }
        }
        public string Group
        {
            get { return m_strGroup; }
            set { m_strGroup = value; }
        }
        public string Name
        {
            get { return m_strName; }
            set { m_strName = value; }
        }
        public string Noc
        {
            get { return m_strNoc; }
            set { m_strNoc = value; }
        }
        public string FirstAttempt
        {
            get { return m_str1stAttempt; }
            set { m_str1stAttempt = value; }
        }
        public string SecondAttempt
        {
            get { return m_str2ndAttempt; }
            set { m_str2ndAttempt = value; }
        }
        public string ThirdAttempt
        {
            get { return m_str3rdAttempt; }
            set { m_str3rdAttempt = value; }
        }
        public string FirstAttemptResult
        {
            get { return m_str1stRes; }
            set { m_str1stRes = value; }
        }
        public string SecondAttemptResult
        {
            get { return m_str2ndRes; }
            set { m_str2ndRes = value; }
        }
        public string ThirdAttemptResult
        {
            get { return m_str3rdRes; }
            set { m_str3rdRes = value; }
        }
        public string Attempt
        {
            get { return m_strAttempt; }
            set { m_strAttempt = value; }
        }
        public string AttemptResult
        {
            get { return m_strResult; }
            set { m_strResult = value; }
        }
        public int AttemptTimes
        {
            get { return m_nAttemptIdx; }
            set { m_nAttemptIdx = value; }
        }
        public string BodyWeight
        {
            get { return m_strBodyWeight; }
            set { m_strBodyWeight = value; }
        }
        public string IRM
        {
            get { return m_strIRM; }
            set { m_strIRM = value; }
        }
        public string Status
        {
            get { return m_strStatus; }
            set { m_strStatus = value; }
        }
        public string FinishedOrder
        {
            get { return m_strFinishOrder; }
            set { m_strFinishOrder = value; }
        }
        public string Record
        {
            get { return m_strRecord; }
            set { m_strRecord = value; }
        }
        public string SnatchResult
        {
            get { return m_strSnatchResult; }
            set { m_strSnatchResult = value; }
        }
        public string SnatchIRM
        {
            get { return m_strSnatchIRM; }
            set { m_strSnatchIRM = value; }
        }
        public string CleanJerkResult
        {
            get { return m_strCleanJerkResult; }
            set { m_strCleanJerkResult = value; }
        }
        public string CleanJerkIRM
        {
            get { return m_strCleanJerkIRM; }
            set { m_strCleanJerkIRM = value; }
        }
        public string TotalResult
        {
            get { return m_strTotalResult; }
            set { m_strTotalResult = value; }
        }
        public string TotalIRM
        {
            get { return m_strTotalIRM; }
            set { m_strTotalIRM = value; }
        }
        public string TotalRank
        {
            get { return m_strTotalRank; }
            set { m_strTotalRank = value; }
        }
        public string Rank
        {
            get { return m_strRank; }
            set { m_strRank = value; }
        }
        public string DisplayPosition
        {
            get { return m_strDisplayPosition; }
            set { m_strDisplayPosition = value; }
        }
    }
}
