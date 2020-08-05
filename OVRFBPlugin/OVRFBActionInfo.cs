using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoSports.OVRFBPlugin
{
 
     public enum EActionType
    {
        emUnKnow = -1,   //未知
        emShot = 0,     //射门
        emPStat = 1,     //队员action
        emTStat = 2,     //队伍action
    }

    public class OVRFBActionInfo
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
        private int m_iRegisterID;
        public int RegisterID
        {
            get { return m_iRegisterID; }
            set { m_iRegisterID = value; }
        }

        private string m_iShirtNo;
        public string ShirtNo
        {
            get { return m_iShirtNo; }
            set { m_iShirtNo = value; }
        }

        private string m_strName;
        public string RegName
        {
            get { return m_strName; }
            set { m_strName = value; }
        }

        private int m_iActive;
        public int Active
        {
            get { return m_iActive; }
            set { m_iActive = value; }
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
        private string m_strActionDetail;
        public string ActionDetail
        {
            get { return m_strActionDetail; }
            set { m_strActionDetail = value; }
        }

        private string m_strActionDetail1;
        public string ActionDetail1
        {
            get { return m_strActionDetail1; }
            set { m_strActionDetail1 = value; }
        }

        private string m_strActionDetail2;
        public string ActionDetail2
        {
            get { return m_strActionDetail2; }
            set { m_strActionDetail2 = value; }
        }

        private string m_strActionDetail3;
        public string ActionDetail3
        {
            get { return m_strActionDetail3; }
            set { m_strActionDetail3 = value; }
        }

        private string m_strActionDetail4;
        public string ActionDetail4
        {
            get { return m_strActionDetail4; }
            set { m_strActionDetail4 = value; }
        }

        private string m_strActionDetailDes1;
        public string ActionDetailDes1
        {
            get { return m_strActionDetailDes1; }
            set { m_strActionDetailDes1 = value; }
        }

        private string m_strActionDetailDes2;
        public string ActionDetailDes2
        {
            get { return m_strActionDetailDes2; }
            set { m_strActionDetailDes2 = value; }
        }

        private string m_strActionDetailDes3;
        public string ActionDetailDes3
        {
            get { return m_strActionDetailDes3; }
            set { m_strActionDetailDes3 = value; }
        }


        private string m_strActionKey;
        public string ActionKey
        {
            get { return m_strActionKey; }
            set { m_strActionKey = value; }
        }

        private string m_strActionXml;
        public string ActionXml
        {
            get { return m_strActionXml; }
            set { m_strActionXml = value; }
        }

        public OVRFBActionInfo()
        {
            Init();
        }
        public void ClearPlayerInfo()
        {
            m_iRegisterID = -1;
            m_iShirtNo = string.Empty;
            m_iTeamPos = -1;
            m_strName = "";
            m_iActive = -1;
            m_bActionComplete = false;
            m_strActionDes = string.Empty;
        }
        public void ClearActionInfo()
        {
            m_iActionID = -1;
            m_strActionCode = "";
            m_strActionKey = "";
            m_strActionXml = "";
            m_bActionComplete = false;
            m_emActionType = EActionType.emUnKnow;

            m_strActionDetail = "";
            m_strActionDetail1 = "";
            m_strActionDetail2 = "";
            m_strActionDetail3 = "";
            m_strActionDetail4 = "";
            m_strActionDes = "";
            m_strActionDetailDes1 = "";
            m_strActionDetailDes2 = "";
            m_strActionDetailDes3 = "";
        }
        public void Init()
        {
            m_iActionID = -1;
            m_iMatchID = -1;
            m_iMatchSplitID = -1;
            m_strActionKey = "";
            m_iRegisterID = -1;
            m_iActive = -1;
            m_iShirtNo = string.Empty;
            m_iTeamPos = -1;
            m_strName = "";
            m_strActionCode = "";
            m_strActionXml = "";
            m_bActionComplete = false;

            m_emActionType = EActionType.emUnKnow;

            m_strActionDetail = "";    //ActionDetai1 + ActionDetail2 或者ActionDetail1 + ActionDetail3
            m_strActionDetail1 = "";   //射门类型  0:Other Action, 1: Shot，2:PenaltyShot，3: Free Click Shot
            m_strActionDetail2 = "";   //射门结果  1:Goal, 2:Block(OnGoal), 3:Crossbar(OnGoal), 4:NoGoal;
            m_strActionDetail3 = "";   //其他动作  4: Own Goal, 5:Yellow Card,  6:2nd Yellow Card, 7:Red Card, 8:ConerClick, 9:Offside, 
                                       //10: Foul Committed, 11:Foul Suffered, 
            m_strActionDetail4 = "";
            m_strActionDes = "";         //动作描述 ActionDetailDes1 + ActionDetailDes2 或者ActionDetail3
            m_strActionDetailDes1 = "";  //射门类型
            m_strActionDetailDes2 = "";  //射门结果
            m_strActionDetailDes3 = "";  //其他动作
        }

        public void InitAction(OVRFBMatchInfo tmpMatch, int iMatchSplitID)
        {
            m_iMatchID = GVAR.Str2Int(tmpMatch.MatchID);
            m_iMatchSplitID = iMatchSplitID;
        }

        public bool IsActionComplete()    //判断此Action是否结束
        {
            if (m_strActionCode != null && m_strActionCode.Length != 0 && m_iRegisterID != -1 && m_iMatchID != -1 && (m_iTeamPos == 1 || m_iTeamPos==2))
            {
                m_bActionComplete = true;
            }
            return m_bActionComplete;
        }

        public bool IsNewAction()     //判断此Action是否是新的

        {
            if (m_iMatchID == -1 && m_iMatchSplitID == -1)
                return true;
            else
                return false;
        }


        public void GetActionCode()    //根据ActionDetail1，ActionDetail2，ActionDetail3得到此ActionCode
        {
            ActionKey = "";
            if (m_emActionType == EActionType.emShot)
            {
                ActionKey = m_strActionDetail1 + m_strActionDetail2;
            }
            else
            {
                ActionKey = m_strActionDetail1 + m_strActionDetail3;
            }

            if (GVAR.m_dicAction.ContainsKey(ActionKey))
            {
                m_strActionCode = GVAR.m_dicAction[ActionKey];
            }
        }

        public string GetPlayerStatCode()   //根据ActionDetail1，ActionDetail2，ActionDetail3得到此Action对应的运动员或队伍的技术统计

        {
            string strPlayerStatCode = "";

            if (GVAR.m_dicPlayerStat.ContainsKey(m_strActionDetail))
            {
                strPlayerStatCode = GVAR.m_dicPlayerStat[m_strActionDetail];
            }

            return strPlayerStatCode;
        }

        //根据ActionDetail1，ActionDetail3得到此Action对应的守门员的技术统计，只有在射门的Action下才会有对方守门员的技术统计

        public string GetGKStatCode()
        {
            string strGKStatCode = "";

            if (m_emActionType == EActionType.emShot)
            {
                if (GVAR.m_dicGKStat.ContainsKey(m_strActionDetail))
                {
                    strGKStatCode = GVAR.m_dicGKStat[m_strActionDetail];
                }
            }
            return strGKStatCode;
        }

        public void CreateActionXml(OVRFBMatchInfo tmpMatch, int iGKID)
        {
            if (!m_bActionComplete)
                return;

            if (m_emActionType == EActionType.emShot)
            {
                m_strActionDes = m_strActionDetailDes1 + m_strActionDetailDes2;
                m_strActionDetail = m_strActionDetail1 + m_strActionDetail2;

                CreateShotXml(iGKID);
            }
            else if (m_emActionType == EActionType.emPStat || m_emActionType == EActionType.emTStat)
            {
                m_strActionDes = m_strActionDetailDes3;
                m_strActionDetail = m_strActionDetail1 + m_strActionDetail3;

                CreateStatXml();
            }
        }


        public void CreateShotXml(int iGKID)
        {
            string strPlayerStatCode = GetPlayerStatCode();
            string strGKStatCode = GetGKStatCode();


            string strKey = m_strActionDetail1 + m_strActionDetail2;

            string strtmp;
            StringBuilder strHeader = new StringBuilder();
            strHeader.AppendLine("<root>");
            if (m_strActionDetail2 == "1")  //进球，比分加1， 否则，比分不改变
            {
                strHeader.AppendLine(String.Format("<Team Position =\"{0}\" bAdd=\"1\"/>", m_iTeamPos.ToString()));
            }
            else if (m_strActionDetail2 == "4" && m_strActionDetail1 == "0") // 乌龙球
            {
                strHeader.AppendLine(String.Format("<Team Position =\"{0}\" bAdd=\"1\"/>", (2 -m_iTeamPos +1).ToString()));
            }

            strHeader.AppendLine(String.Format("<Player ID =\"{0}\" StatCode =\"{1}\"  bAdd=\"1\" MatchSplitID =\"{2}\"/>", m_iRegisterID.ToString(), strPlayerStatCode, m_iMatchSplitID));
            if (strGKStatCode.Length != 0)
            {
                strHeader.AppendLine(String.Format("<GK ID =\"{0}\" StatCode =\"{1}\"  bAdd=\"1\" MatchSplitID =\"{2}\"/>", iGKID.ToString(), strGKStatCode, m_iMatchSplitID));
            }
            strHeader.AppendLine("</root>");

            m_strActionXml = strHeader.ToString();
        }

        public void CreateStatXml()
        {
            string strPlayerStatCode = GetPlayerStatCode();
            //string strtemp = string.Format("<Player ID = \"{0}\" StatCode = \"{1}\" bAdd = \"1\"/>", m_iRegisterID.ToString(), strPlayerStatCode);
            string strtemp = "<Player ID = \"" + m_iRegisterID.ToString() + "\" StatCode = \"" + strPlayerStatCode + "\" bAdd = \"1\"" + " MatchSplitID =\"" + m_iMatchSplitID.ToString() + "\"/>";

            m_strActionXml = "<root>";
            m_strActionXml += strtemp;
            m_strActionXml += "</root>";
        }
    }

}
