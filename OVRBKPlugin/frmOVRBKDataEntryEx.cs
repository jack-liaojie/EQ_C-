using System;
using System.Windows.Forms;
using System.Xml;
using System.Text;
using System.Collections.Generic;
using AutoSports.OVRCommon;

namespace AutoSports.OVRBKPlugin
{
    public partial class frmOVRBKDataEntry
    {
        private TcpClientEx m_obTcpClientEx = new TcpClientEx(1);
        private StatOperation m_obStatOperation = new StatOperation();

        public delegate void Delegate_UpdateUI_ForTcp_MatchInfo(string strTeamType);
        void Func_UpdateUI_ForTcp_MatchInfo(string strTeamType)
        {
            if (this.InvokeRequired)
            {
                Delegate_UpdateUI_ForTcp_MatchInfo dg = null;
                dg = new Delegate_UpdateUI_ForTcp_MatchInfo(Func_UpdateUI_ForTcp_MatchInfo);
                this.Invoke(dg, strTeamType);
            }
            else
            {
                if (int.Parse(strTeamType) == 1)
                {
                    ResetPlayerList(int.Parse(strTeamType), ref dgvHomeList);
                    InitPlayerAcitve(int.Parse(strTeamType), ref m_lstHomeActive);
                }
                else
                {
                    ResetPlayerList(int.Parse(strTeamType), ref dgvVisitList);
                    InitPlayerAcitve(int.Parse(strTeamType), ref m_lstVisitActive);
                }
            }
        }

        public delegate void Delegate_UpdateUI_ForTcp_CurPeroid();
        void Func_UpdateUI_ForTcp_CurPeroid()
        {
            if (this.InvokeRequired)
            {
                Delegate_UpdateUI_ForTcp_CurPeroid dg = null;
                dg = new Delegate_UpdateUI_ForTcp_CurPeroid(Func_UpdateUI_ForTcp_CurPeroid);
                this.Invoke(dg);
            }
            else
            {
                UpdatePreviousBtnEnabled();
                UpdateNextBtnEnabled();
                UpdatePeriodBtnEnabled();
                ChangePeriod();
                EnableSetPointsTextBox();
            }
        }

        public delegate void Delegate_UpdateUI_ForTcp_MatchPoints();
        void Func_UpdateUI_ForTcp_MatchPoints()
        {
            if (this.InvokeRequired)
            {
                Delegate_UpdateUI_ForTcp_MatchPoints dg = null;
                dg = new Delegate_UpdateUI_ForTcp_MatchPoints(Func_UpdateUI_ForTcp_MatchPoints);
                this.Invoke(dg);
            }
            else
            {
                UpdateUIForTeamScore();
            }
        }

        private void chkX_Connect_CheckedChanged(object sender, EventArgs e)
        {
            if (chkX_Connect.Checked)
            {
                string strIP = ipAddressInput.Value;
                if (ipAddressInput.Value == null || strIP.Length < 1)
                {
                    chkX_Connect.CheckState = CheckState.Unchecked;
                    return;
                }
                int nPort = 10008;
                if (txtBoxX_Port.Text.Length < 1)
                {
                    chkX_Connect.CheckState = CheckState.Unchecked;
                    return;
                }
                nPort = int.Parse(txtBoxX_Port.Text);

                Cursor.Current = Cursors.WaitCursor;

                if (m_obTcpClientEx.Connect(strIP, UInt16.Parse(nPort.ToString()), 10000))
                {
                    ConfigurationManager.SetPluginSettingString("BK", "TCP_IP", strIP);
                    ConfigurationManager.SetPluginSettingString("BK", "TCP_Port", nPort.ToString());

                    m_obStatOperation.MatchID = m_CCurMatch.MatchID;

                    m_obTcpClientEx.OnReceiveData += ReceiveData;
                    m_obTcpClientEx.OnConnectionChanged += ConnectionChanged;
                }
                else
                {
                    m_obTcpClientEx.Disconnect();
                    chkX_Connect.CheckState = CheckState.Unchecked;
                }
                Cursor.Current = Cursors.Arrow;
            }
            else
            {
                m_obTcpClientEx.Disconnect();
                m_obTcpClientEx.OnReceiveData -= ReceiveData;
                m_obTcpClientEx.OnConnectionChanged -= ConnectionChanged;
            }
        }

        public void ConnectionChanged(object sender, bool bIsConnected)
        {
            if (bIsConnected)
            {
            }
            else
            {
                m_obTcpClientEx.Disconnect();
                m_obTcpClientEx.OnReceiveData -= ReceiveData;
                m_obTcpClientEx.OnConnectionChanged -= ConnectionChanged;
                chkX_Connect.CheckState = CheckState.Unchecked;
            }
        }

        public void ReceiveData(object sender, byte[] btBuffer)
        {
            Byte[] btDecompressBuffer = Compressor.Decompress(btBuffer);

            XmlDocument xmlDoc = new XmlDocument();

            string strXml = Encoding.GetEncoding("utf-8").GetString(btDecompressBuffer);
            xmlDoc.LoadXml(strXml);

            if (xmlDoc.DocumentElement.Name == "MatchInfo")
            {
                MatchInfoXmlDoc(xmlDoc);
                return;
            }

            if (xmlDoc.DocumentElement.Name == "MatchPoints")
            {
                MatchPointsXmlDoc(xmlDoc);
                return;
            }

            if (xmlDoc.DocumentElement.Name == "StatData")
            {
                StatDataXmlDoc(xmlDoc);
                return;
            }
        }

        private void MatchInfoXmlDoc(XmlDocument xmlDoc)
        {
            XmlNodeList xmlNodeLst;
            XmlElement xmlElement;

            string strSel = "/MatchInfo/Team";
            xmlNodeLst = xmlDoc.SelectNodes(strSel);

            XmlNodeList xmlPlayerList = null;
            foreach (XmlNode oneTeamNode in xmlNodeLst)
            {
                xmlElement = (XmlElement)oneTeamNode;

                string strTeamType = GetAttributeValue(xmlElement, "TeamType");
                xmlPlayerList = oneTeamNode.SelectNodes("Player");
                foreach (XmlNode onePlayerNode in xmlPlayerList)
                {
                    xmlElement = (XmlElement)onePlayerNode;
                    string strPlayerNo = GetAttributeValue(xmlElement, "PlayerNo");
                    string strStartingLineup = GetAttributeValue(xmlElement, "StartingLineup");
                    string strPlayingStatus = GetAttributeValue(xmlElement, "PlayingStatus");

                    UpdatePlayer(strTeamType, strPlayerNo, strStartingLineup, strPlayingStatus); 
                }

                Func_UpdateUI_ForTcp_MatchInfo(strTeamType);
            }
        }

        private void MatchPointsXmlDoc(XmlDocument xmlDoc)
        {
            XmlNodeList xmlNodeLst;
            XmlElement xmlElement;

            string strSel = "/MatchPoints/Match";
            xmlNodeLst = xmlDoc.SelectNodes(strSel);

            XmlNodeList xmlPeroidList = null;
            foreach (XmlNode oneMatchNode in xmlNodeLst)
            {
                xmlElement = (XmlElement)oneMatchNode;

                string strHomePoints = GetAttributeValue(xmlElement, "HomePoints");
                string strAwayPoints = GetAttributeValue(xmlElement, "AwayPoints");

                UpdateMatchPoints(strHomePoints, strAwayPoints);

                xmlPeroidList = oneMatchNode.SelectNodes("Period");
                foreach (XmlNode onePeroidNode in xmlPeroidList)
                {
                    xmlElement = (XmlElement)onePeroidNode;
                    string strPeriodType = GetAttributeValue(xmlElement, "Type");

                    string strIsCurPeriod = GetAttributeValue(xmlElement, "IsCurPeriod");
                    UpdateCurPeriod(strPeriodType, strIsCurPeriod);

                    strHomePoints = GetAttributeValue(xmlElement, "HomePoints");
                    strAwayPoints = GetAttributeValue(xmlElement, "AwayPoints");

                    UpdatePeriodPoints(strPeriodType, strHomePoints, strAwayPoints);
                }

                Func_UpdateUI_ForTcp_CurPeroid();

                Func_UpdateUI_ForTcp_MatchPoints();

                int iMatchID = GVAR.Str2Int(m_CCurMatch.MatchID);
                int iEventID = GVAR.g_ManageDB.GetEventID(m_CCurMatch.MatchID);
                GVAR.g_BKPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, iEventID, -1, iMatchID, iMatchID, null);
            }
        }

        private void StatDataXmlDoc(XmlDocument xmlDoc)
        {
            XmlNodeList xmlNodeLst;
            XmlElement xmlElement;

            string strSel = "/StatData/Team";
            xmlNodeLst = xmlDoc.SelectNodes(strSel);

            XmlNodeList xmlStatList = null;
            XmlNodeList xmlPeriodList = null;
            List<Statistics> lstStat = new List<Statistics>();
            foreach (XmlNode oneTeamNode in xmlNodeLst)
            {
                xmlElement = (XmlElement)oneTeamNode;

                string strTeamType = GetAttributeValue(xmlElement, "TeamType");

                xmlStatList = oneTeamNode.SelectNodes("Match/Stat");
                foreach (XmlNode oneStatNode in xmlStatList)
                {
                    xmlElement = (XmlElement)oneStatNode;
                    Statistics newStatistics = new Statistics();
                    newStatistics.StatType = int.Parse(GetAttributeValue(xmlElement, "StatType"));
                    newStatistics.StatValue = GetAttributeValue(xmlElement, "StatValue");
                    lstStat.Add(newStatistics);
                }
                UpdateTeamMatchStat(strTeamType, lstStat);
                lstStat.Clear();

                xmlPeriodList = oneTeamNode.SelectNodes("Period");
                foreach (XmlNode onePeriodNode in xmlPeriodList)
                {
                    xmlElement = (XmlElement)onePeriodNode;

                    string strPeriodType = GetAttributeValue(xmlElement, "PeriodType");

                    xmlStatList = onePeriodNode.SelectNodes("Stat");
                    foreach (XmlNode oneStatNode in xmlStatList)
                    {
                        xmlElement = (XmlElement)oneStatNode;
                        Statistics newStatistics = new Statistics();
                        newStatistics.StatType = int.Parse(GetAttributeValue(xmlElement, "StatType"));
                        newStatistics.StatValue = GetAttributeValue(xmlElement, "StatValue");
                        lstStat.Add(newStatistics);
                    }
                    UpdateTeamPeriodStat(strTeamType, strPeriodType, lstStat);
                    lstStat.Clear();
                }

                XmlNodeList xmlPlayerList = oneTeamNode.SelectNodes("Player");
                foreach (XmlNode onePlayerNode in xmlPlayerList)
                {
                    xmlElement = (XmlElement)onePlayerNode;

                    string strPlayerNo = GetAttributeValue(xmlElement, "PlayerNo");

                    xmlStatList = oneTeamNode.SelectNodes("Match/Stat");
                    foreach (XmlNode oneStatNode in xmlStatList)
                    {
                        xmlElement = (XmlElement)oneStatNode;
                        Statistics newStatistics = new Statistics();
                        newStatistics.StatType = int.Parse(GetAttributeValue(xmlElement, "StatType"));
                        newStatistics.StatValue = GetAttributeValue(xmlElement, "StatValue");
                        lstStat.Add(newStatistics);
                    }
                    UpdatePlayerMatchStat(strTeamType, strPlayerNo, lstStat);
                    lstStat.Clear();

                    xmlPeriodList = onePlayerNode.SelectNodes("Period");
                    foreach (XmlNode onePeriodNode in xmlPeriodList)
                    {
                        xmlElement = (XmlElement)onePeriodNode;

                        string strPeriodType = GetAttributeValue(xmlElement, "PeriodType");

                        xmlStatList = onePeriodNode.SelectNodes("Stat");
                        foreach (XmlNode oneStatNode in xmlStatList)
                        {
                            xmlElement = (XmlElement)oneStatNode;
                            Statistics newStatistics = new Statistics();
                            newStatistics.StatType = int.Parse(GetAttributeValue(xmlElement, "StatType"));
                            newStatistics.StatValue = GetAttributeValue(xmlElement, "StatValue");
                            lstStat.Add(newStatistics);
                        }
                        UpdatePlayerPeriodStat(strTeamType, strPlayerNo, strPeriodType, lstStat);
                        lstStat.Clear();
                    }
                }
            }
        }

        private string GetAttributeValue(XmlElement xe, string strAttribute)
        {
            if (xe == null)
                return null;

            string strvalue = null;
            if (xe.GetAttribute(strAttribute).ToString().Length != 0)
            {
                strvalue = xe.GetAttribute(strAttribute).ToString();
            }

            return strvalue;
        }

        private void UpdatePlayer(string strTeamType, string strShirtBib, string strStartingLineup, string strPlayingStatus)
        {
            GVAR.g_ManageDB.UpdateMember(int.Parse(m_CCurMatch.MatchID), int.Parse(strTeamType), int.Parse(strShirtBib),
                strStartingLineup, strPlayingStatus);
        }

        private void UpdateMatchPoints(string strHomePoints, string strAwayPoints)
        {
        }

        private void UpdateCurPeriod(string strPeriodType, string strIsCurPeriod)
        {
            if (strIsCurPeriod == "1")
                m_CCurMatch.SetCurPeriod(int.Parse(strPeriodType));
        }

        private void UpdatePeriodPoints(string strPeroidType, string strHomePoints, string strAwayPoints)
        {
            int iResult = 0;
            iResult = m_CCurMatch.EditSetPoint(int.Parse(strPeroidType), 1, int.Parse(strHomePoints));
            if (iResult == 0)
                return;
            iResult = m_CCurMatch.EditSetPoint(int.Parse(strPeroidType), 2, int.Parse(strAwayPoints));
            if (iResult == 0)
                return;
            if (iResult == 1)
            {
                GVAR.g_ManageDB.UpdateTeamSetPt(int.Parse(strPeroidType), ref m_CCurMatch);
                GVAR.g_ManageDB.UpdateTeamTotPt(ref m_CCurMatch);
            }
        }

        private void UpdateTeamMatchStat(string strTeamType, List<Statistics> lstStat)
        {
        }

        private void UpdateTeamPeriodStat(string strTeamType, string strPeriodType, List<Statistics> lstStat)
        {
            if (m_CCurMatch == null)
                return;

            string strTeamID = strTeamType == "1" ?
                m_CCurMatch.m_CHomeTeam.TeamID.ToString() : m_CCurMatch.m_CVisitTeam.TeamID.ToString();
            m_obStatOperation.PutTeamStatDataToDatabase(strPeriodType, strTeamID, lstStat);
        }

        private void UpdatePlayerMatchStat(string strTeamType, string strShirtBib, List<Statistics> lstStat)
        {
        }

        private void UpdatePlayerPeriodStat(string strTeamType, string strShirtBib, string strPeriodType, List<Statistics> lstStat)
        {
            if (m_CCurMatch == null)
                return;

            string strTeamID = strTeamType == "1" ?
                m_CCurMatch.m_CHomeTeam.TeamID.ToString() : m_CCurMatch.m_CVisitTeam.TeamID.ToString();
            m_obStatOperation.PutPlayerStatDataToDatabase(strPeriodType, strTeamID, strShirtBib, lstStat);
        }
    }
}