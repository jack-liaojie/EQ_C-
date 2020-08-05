using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Data;
using System.Data.SqlClient;

using AutoSports.OVRCommon;

namespace AutoSports.OVRManagerApp
{
    public class OVRXmlMessagePacker
    {
        private SqlConnection m_sqlCon;
        private SqlCommand m_cmdGetRsc;
        private SqlCommand m_cmdGetFullId;
        private SqlCommand m_cmdGet_Session_Court_ID;
        private List<String> m_lstDataChangedType;
        private XmlDocument m_xmlDoc;
        private string m_strVenue;
        private string m_strHostName;

        public string VenueCode
        {
            set { m_strVenue = value; }
        }
       

        public OVRXmlMessagePacker()
        {
            m_sqlCon = null;
            m_lstDataChangedType = null;
        }

        private string GetDataChangedType(OVRDataChangedType emType)
        {
            int iIndex = System.Convert.ToInt32(emType);
            int iCapacity = System.Convert.ToInt32(OVRDataChangedType.Capacity);

            if (m_lstDataChangedType == null || iIndex < 0 || iIndex >= iCapacity)
                return "Unknown";

            return m_lstDataChangedType[iIndex];
        }

        private bool Can_Get_Session_Court_ID(OVRDataChangedType emType)
        {
            if (emType == OVRDataChangedType.emMatchAdd ||
                emType == OVRDataChangedType.emMatchDel ||
                emType == OVRDataChangedType.emMatchInfo ||
                emType == OVRDataChangedType.emMatchWeather ||
                emType == OVRDataChangedType.emMatchModel ||
                emType == OVRDataChangedType.emMatchStatus ||
                emType == OVRDataChangedType.emMatchDate ||
                emType == OVRDataChangedType.emMatchResult ||
                emType == OVRDataChangedType.emMatchCompetitor ||
                emType == OVRDataChangedType.emMatchSessionSet ||
                emType == OVRDataChangedType.emMatchSessionReset ||
                emType == OVRDataChangedType.emMatchCourtSet ||
                emType == OVRDataChangedType.emMatchCourtReset)
            {
                return true;
            }
            else return false;
        }

        private void Get_Session_Court_ID(int iMatchID, out int iSessionID, out int iCourtID)
        {
            iSessionID = -1;
            iCourtID = -1;
            m_cmdGet_Session_Court_ID.CommandText = String.Format("SELECT F_SessionID, F_CourtID FROM TS_Match WHERE F_MatchID={0}", iMatchID);
            
            if (m_sqlCon.State != System.Data.ConnectionState.Open)
                m_sqlCon.Open();

            SqlDataReader sdr = m_cmdGet_Session_Court_ID.ExecuteReader();

            if (!sdr.HasRows)
            {
                sdr.Close();
                return;
            }

            if (sdr.Read())
            {
                if (!Convert.IsDBNull(sdr[0]))
                    iSessionID = Convert.ToInt32(sdr[0]);

                if (!Convert.IsDBNull(sdr[1]))
                    iCourtID = Convert.ToInt32(sdr[1]);
            }

            sdr.Close();
        }

        public void Initialize(SqlConnection sqlCon, string strVenue)
        {
            this.m_sqlCon = sqlCon;
            this.m_strVenue = strVenue;
            this.m_xmlDoc = new XmlDocument();
            this.m_strHostName = System.Net.Dns.GetHostName();

            this.m_cmdGetRsc = new SqlCommand("proc_GetXMLRSCCode", m_sqlCon);
            this.m_cmdGetRsc.CommandType = CommandType.StoredProcedure;
            this.m_cmdGetRsc.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int));
            this.m_cmdGetRsc.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int));
            this.m_cmdGetRsc.Parameters.Add(new SqlParameter("@PhaseID", SqlDbType.Int));
            this.m_cmdGetRsc.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int));


            this.m_cmdGetFullId = new SqlCommand("proc_GetFullId", m_sqlCon);
            this.m_cmdGetFullId.CommandType = CommandType.StoredProcedure;
            this.m_cmdGetFullId.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int));
            this.m_cmdGetFullId.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int));
            this.m_cmdGetFullId.Parameters.Add(new SqlParameter("@PhaseID", SqlDbType.Int));
            this.m_cmdGetFullId.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int));

            this.m_cmdGet_Session_Court_ID = new SqlCommand();
            this.m_cmdGet_Session_Court_ID.Connection = m_sqlCon;

            // Initialize DataChangedType String
            m_lstDataChangedType = new List<string>();
            int iCapacity = System.Convert.ToInt32(OVRDataChangedType.Capacity);
            for (int i = 0; i < iCapacity; i++)
            {
                string strItemName = ((OVRDataChangedType)i).ToString();
                string strItemValue = strItemName;
                if (strItemName.IndexOf("em", 0) == 0)
                    strItemValue = strItemValue.Substring(2);

                m_lstDataChangedType.Add(strItemValue);
            }
        }

        private string GetXmlHeader(OVRDataChanged changedItem, string strType)
        {
            if (changedItem == null) return null;

            return GetXmlHeader(changedItem.DisciplineID, changedItem.EventID
                                , changedItem.PhaseID, changedItem.MatchID, strType);
        }

        private string GetXmlHeader(int iDisciplineID, int iEventID, int iPhaseID, int iMatchID, string strType)
        {
            if (m_sqlCon == null) return null;

            if (m_sqlCon.State != System.Data.ConnectionState.Open)
                m_sqlCon.Open();

            DateTime dt = DateTime.Now;
            string strRSC = "0000000000";
            string strDiscipline = "00";
            string strGender = "0";
            string strEvent = "000";
            string strPhase = "0";
            string strUnit = "000";
            string strOrigin = m_strHostName;
            string strVenue = m_strVenue;
            string strDate = String.Format("{0}{1:00}{2:00}", dt.Year, dt.Month, dt.Day);
            string strTime = String.Format("{0}{1:00}{2:00}{3:000}", dt.Hour, dt.Minute, dt.Second, dt.Millisecond);

            this.m_cmdGetRsc.Parameters[0].Value = iDisciplineID;
            this.m_cmdGetRsc.Parameters[1].Value = iEventID;
            this.m_cmdGetRsc.Parameters[2].Value = iPhaseID;
            this.m_cmdGetRsc.Parameters[3].Value = iMatchID;

            SqlDataReader sdr = this.m_cmdGetRsc.ExecuteReader();
            if (sdr.FieldCount == 6)
            {
                if (sdr.Read())
                {
                    strRSC = sdr[0].ToString();
                    strDiscipline = sdr[1].ToString();
                    strGender = sdr[2].ToString();
                    strEvent = sdr[3].ToString();
                    strPhase = sdr[4].ToString();
                    strUnit = sdr[5].ToString();
                }
            }
            sdr.Close();


            StringBuilder strHeader = new StringBuilder();
            strHeader.AppendLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?> ");
            strHeader.AppendLine("<Message ");
            strHeader.AppendLine(String.Format("RSC=\"{0}\" Type=\"{1}\" Discipline=\"{2}\" Gender=\"{3}\"", strRSC, strType, strDiscipline, strGender));
            strHeader.AppendLine(String.Format("Event=\"{0}\" Phase=\"{1}\" Unit=\"{2}\" Origin=\"{3}\"", strEvent, strPhase, strUnit, strOrigin));
            strHeader.AppendLine(String.Format("Venue=\"{0}\" Date=\"{1}\" Time=\"{2}\" Category=\"OVR\">", strVenue, strDate, strTime));
            strHeader.AppendLine("</Message>");

            return strHeader.ToString();
        }

        private void AppendDocElement(XmlDocument xmlDoc, OVRDataChanged item)
        {
            this.m_cmdGetFullId.Parameters[0].Value = item.DisciplineID;
            this.m_cmdGetFullId.Parameters[1].Value = item.EventID;
            this.m_cmdGetFullId.Parameters[2].Value = item.PhaseID;
            this.m_cmdGetFullId.Parameters[3].Value = item.MatchID;

            SqlDataReader sdr = this.m_cmdGetFullId.ExecuteReader();
            if (sdr.FieldCount == 4)
            {
                if (sdr.Read())
                {
                    item.DisciplineID = Convert.ToInt32(Convert.ToString(sdr[3]));
                    item.EventID = Convert.ToInt32(Convert.ToString(sdr[2]));
                    item.PhaseID = Convert.ToInt32(Convert.ToString(sdr[1]));
                    item.MatchID = Convert.ToInt32(Convert.ToString(sdr[0]));
                }
            }
            sdr.Close();

            XmlNode node = xmlDoc.CreateNode(XmlNodeType.Element, "Item", null);

            // If Data Changed is about a Match, Set Session ID and Court ID.
            int iSessionID = -1, iCourtID = -1;
            bool bCanGetID = Can_Get_Session_Court_ID(item.Type);
            if (bCanGetID && item.MatchID != -1)
            {
                Get_Session_Court_ID(item.MatchID, out iSessionID, out iCourtID);
            }

            // F_Type
            XmlAttribute attr = xmlDoc.CreateAttribute("NotifyType");
            attr.Value = GetDataChangedType(item.Type);
            node.Attributes.Append(attr);

            // DisciplineID
            attr = xmlDoc.CreateAttribute("DisciplineID");
            attr.Value = item.DisciplineID.ToString();
            node.Attributes.Append(attr);

            // EventID
            attr = xmlDoc.CreateAttribute("EventID");
            attr.Value = item.EventID.ToString();
            node.Attributes.Append(attr);

            // PhaseID
            attr = xmlDoc.CreateAttribute("PhaseID");
            attr.Value = item.PhaseID.ToString();
            node.Attributes.Append(attr);

            // MatchID
            attr = xmlDoc.CreateAttribute("MatchID");
            attr.Value = item.MatchID.ToString();
            node.Attributes.Append(attr);

            // SessionID
            attr = xmlDoc.CreateAttribute("SessionID");
            if (item.Type == OVRDataChangedType.emSessionAdd  ||
                item.Type == OVRDataChangedType.emSessionDel  ||
                item.Type == OVRDataChangedType.emSessionInfo ||
                item.Type == OVRDataChangedType.emMatchSessionSet ||
                item.Type == OVRDataChangedType.emMatchSessionReset)
            {
                attr.Value = item.ID.ToString();
            }
            else if (bCanGetID) 
                attr.Value = iSessionID.ToString();
            else  attr.Value = "-1";
            node.Attributes.Append(attr);

            // CourtID
            attr = xmlDoc.CreateAttribute("CourtID");
            if (item.Type == OVRDataChangedType.emCourtAdd  ||
                item.Type == OVRDataChangedType.emCourtDel  ||
                item.Type == OVRDataChangedType.emCourtInfo ||
                item.Type == OVRDataChangedType.emMatchCourtSet ||
                item.Type == OVRDataChangedType.emMatchCourtReset)
            {
                attr.Value = item.ID.ToString();
            }
            else if (bCanGetID) 
                attr.Value = iCourtID.ToString();
            else attr.Value = "-1";
            node.Attributes.Append(attr);


            // Add to XmlDocument
            xmlDoc.DocumentElement.AppendChild(node);
        }

        public string GetXmlMessage(OVRDataChanged changedItem)
        {
            if (m_sqlCon == null || changedItem == null) return null;

            if (changedItem.Data != null)
            {
                string strHeader = GetXmlHeader(changedItem, "DATA");
                if (strHeader == null) return null;

                string strDataMessage = strHeader.Replace("</Message>", "<Data>" + changedItem.Data + "</Data>" + "</Message>");

                try
                {
                    m_xmlDoc.LoadXml(strDataMessage);
                }
                catch (System.Exception ex)
                {
                    return null;
                }

                return "<!--OVR_DATA-->\n" + m_xmlDoc.InnerXml;                
            }
            else
            {
                string strHeader = GetXmlHeader(changedItem, "NOTIFY");
                if (strHeader == null) return null;

                m_xmlDoc.LoadXml(strHeader);
                AppendDocElement(m_xmlDoc, changedItem);

                return "<!--OVR_NOTIFY-->\n" + m_xmlDoc.InnerXml;
            }

        }

        public string GetRPDSMessage(OVRReportGeneratedArgs oRptArgs)
        {
            if (m_sqlCon == null || oRptArgs == null) return null;

            string strHeader = GetXmlHeader(oRptArgs.DisciplineID, oRptArgs.EventID
                                             , oRptArgs.PhaseID, oRptArgs.MatchID, "RPDS");
            if (strHeader == null) return null;

            string strBody = String.Format("<Report Type=\"{0}\" Version=\"{1}\" FileName=\"{2}\" Comment=\"{3}\" />"
                             , oRptArgs.ReportType, oRptArgs.Version, oRptArgs.FileName, oRptArgs.Comment);
            string strDataMessage = strHeader.Replace("</Message>", strBody + "</Message>");

            try
            {
                m_xmlDoc.LoadXml(strDataMessage);
            }
            catch (System.Exception ex)
            {
                return null;
            }

            return "<!--OVR_NOTIFY-->\n" + m_xmlDoc.InnerXml;
        }
    }
}
