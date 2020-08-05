using System;
using System.IO;
namespace OVRDVPlugin.TSInterface
{
    public enum TransmitStatus
    {
        None,
        StartList,
        Score,
        RankList
    }
    public class DivingProcess
    {
        public DivingProcess()
        {
            m_matchInfo = new TSMatchInfo();
        }
        private int m_iMatchID = -1;
        private TransmitStatus m_status = TransmitStatus.None;
        private TSMatchInfo m_matchInfo;

        public int MatchID
        {
            get { return m_iMatchID; }
            set { m_iMatchID = value; }
        }

        public event Action<TransmitStatus, TSMatchInfo> RecvData;
        public event Action<bool, string> TransimitAction;
        public event Action<string, bool> OnUpdateDBResult;

        public void ProcessData(string strData)
        {
            if (strData.Length < 6)
            {
                return;
            }

            string type = strData.Substring(4, 2);
            string type3 = strData.Substring(4, 3);
            switch (type)
            {
                case "E1":
                    m_status = TransmitStatus.StartList;
                    m_matchInfo = new TSMatchInfo();
                    if (TransimitAction != null)
                    {
                        TransimitAction(true, strData);
                    }
                    break;
                case "E2":
                    m_status = TransmitStatus.Score;
                    m_matchInfo.ReInitJudgeScore();
                    break;
                case "E0":
                    m_status = TransmitStatus.RankList;
                    m_matchInfo.ReInitRankInfo();
                    break;
                case "GS":
                    if (m_status == TransmitStatus.StartList)
                    {
                        m_matchInfo.StartInfo.RoundNumber = GetFieldData(strData);
                    }
                    break;
                case "GN":
                    if (m_status == TransmitStatus.StartList)
                    {
                        m_matchInfo.StartInfo.BibNumber = GetFieldData(strData);
                    }
                    break;
                case "GO":
                    if (m_status == TransmitStatus.StartList)
                    {
                        String strStartNumber = GetFieldData(strData);
                        m_matchInfo.StartInfo.StartNumber = GetFieldData(strData);
                        DVCommon.g_DVDBManager.ExcuteDV_TS_UpdateMatchSplitCurrentDiver(m_iMatchID, m_matchInfo.StartInfo.RoundNumber, strStartNumber);
                        if (RecvData != null)
                        {
                            RecvData(m_status, m_matchInfo);
                        }
                    }
                    break;
                case "GD":
                    if (m_status == TransmitStatus.StartList)
                    {
                        m_matchInfo.StartInfo.DiveCode = GetFieldData(strData);
                    }
                    break;
                case "GC":
                    if (m_status == TransmitStatus.StartList)
                    {
                        m_matchInfo.StartInfo.Difficulty = GetFieldData(strData);
                    }
                    break;
                case "GH":
                    if (m_status == TransmitStatus.StartList)
                    {
                        m_matchInfo.StartInfo.Height = GetFieldData(strData);
                    }
                    break;
                case "SC":
                    if (m_status == TransmitStatus.StartList)
                    {
                        m_matchInfo.StartInfo.Points = GetFieldData(strData);
                    }
                    else if (m_status == TransmitStatus.Score)
                    {
                        string strValue = GetFieldData(strData);
                        m_matchInfo.ScoreInfo.AddValue("To.All", strValue);
                    }
                    break;
                case "PR":
                    if (m_status == TransmitStatus.StartList)
                    {
                        m_matchInfo.StartInfo.Rank = GetFieldData13(strData);
                    }
                    else if (m_status == TransmitStatus.Score)
                    {
                        string strValue = GetFieldData13(strData);
                        m_matchInfo.ScoreInfo.AddValue("Rank", strValue);
                        if (RecvData != null)
                        {
                            RecvData(m_status, m_matchInfo);
                        }
                    }
                    break;
                case "GL":
                    if (m_status == TransmitStatus.RankList)
                    {
                        m_matchInfo.StartInfo.PlayerName = GetFieldData(strData);
                    }
                    break;
                case "GY":
                    if (m_status == TransmitStatus.RankList)
                    {
                        m_matchInfo.StartInfo.NOC = GetFieldData(strData);
                    }
                    break;
                case "S1":
                case "S2":
                case "S3":
                case "S4":
                case "S5":
                case "S6":
                case "S7":
                case "S8":
                case "S9":
                case "S10":
                case "S11":
                case "ST":
                case "GP":
                    if (m_status == TransmitStatus.Score)
                    {
                        string strValue = "";
                        if (type3.Substring(2, 1) != "\x02")
                        {
                            type = type3;
                            strValue = GetFieldData15(strData);
                        }
                        else
                        {
                            strValue = GetFieldData13(strData);
                        }

                        if (type == "ST")
                        {
                            type = "Total";
                            strValue = GetFieldData(strData);
                        }
                        else if (type == "GP")
                        {
                            type = "Penalty";
                            strValue = GetFieldData(strData);
                            if (strValue == "")
                            {
                                strValue = "0";
                            }
                        }

                        m_matchInfo.ScoreInfo.AddValue(type, strValue);

                        if (type.StartsWith("S") || type == "Penalty")
                        {
                            UpdateToDatabase(type, strValue);
                        }
                    }
                    break;
                case "LY":
                case "LS":
                case "LP":
                case "LL":
                    if (m_status == TransmitStatus.RankList)
                    {
                        string strCode = GetPlayerCode(strData);
                        string strValue = GetFieldData(strData);
                        if (type == "LY")
                        {
                            type = "NOC";
                        }
                        else if (type == "LS")
                        {
                            type = "Rank";
                        }
                        else if (type == "LP")
                        {
                            type = "Points";
                        }
                        else if (type == "LL")
                        {
                            type = "Name";
                        }
                        m_matchInfo.RankInfo.AddValue(strCode, type, strValue);
                    }
                    break;
                case "G0":
                    if (RecvData != null)
                    {
                        RecvData(m_status, m_matchInfo);
                    }
                    if (type3 == "G02")
                    {
                        if (TransimitAction != null)
                        {
                            TransimitAction(false, strData);
                        }
                    }
                    break;
            }
        }

        private string GetFieldData(string strData, int startPos = 12)
        {
            char endMark = '\x04';
            int endPos = strData.LastIndexOf(endMark);
            if (endPos == -1)
            {
                return "";
            }
            return strData.Substring(startPos, endPos - startPos).Trim();
        }

        private string GetFieldData13(string strData)
        {
            return GetFieldData(strData, 13);
        }

        private string GetFieldData15(string strData)
        {
            return GetFieldData(strData, 15);
        }

        private string GetPlayerCode(string strData)
        {
            return strData.Substring(8, 4);
        }

        private void UpdateToDatabase(string judgeCode, string judgePoint)
        {
            int roundID = -1;
            int registerNum = -1;
            if (m_matchInfo.StartInfo.RoundNumber != null && m_matchInfo.StartInfo.RoundNumber != "")
            {
                roundID = Convert.ToInt32(m_matchInfo.StartInfo.RoundNumber);
            }
            if (m_matchInfo.StartInfo.StartNumber != null && m_matchInfo.StartInfo.StartNumber != "")
            {
                registerNum = Convert.ToInt32(m_matchInfo.StartInfo.StartNumber);
            }
            judgeCode = judgeCode.TrimStart('S');
            string strError = DVCommon.g_DVDBManager.ExcuteDV_TS_UpdatePlayerPoint(m_iMatchID, roundID, registerNum, judgeCode, judgePoint, 1);
            //zjy 导入成绩后计算单节的排名
            DVCommon.g_DVDBManager.ExcuteDV_CalcuateMatchSplitRank(m_iMatchID, roundID);

            if (OnUpdateDBResult != null)
            {
                string strInfo = "";
                bool bSucceed = false;
                if (strError == null)
                {
                    bSucceed = true;
                    strInfo = string.Format("Score Imported Succeed:\r\n{0}|{1}|{2}|{3}|{4}", m_iMatchID, roundID, registerNum, judgeCode, judgePoint);
                }
                else
                {
                    bSucceed = false;
                    strInfo = string.Format("Score Imported Failed:\r\n{0}|{1}|{2}|{3}|{4}\r\nError Info:{5}", m_iMatchID, roundID, registerNum, judgeCode, judgePoint, strError);
                }
                OnUpdateDBResult(strInfo, bSucceed);
            }
        }
    }
}
