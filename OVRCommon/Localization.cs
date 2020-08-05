using System;
using System.Collections.Generic;
using System.Text;
using System.Globalization;
using System.Collections;
using System.Xml;


namespace AutoSports.OVRCommon
{
    public static class LocalizationRecourceManager
    {
        private static string m_strLocalResFile;
        private static string m_strCultureName;
        private static bool m_bResourceLoaded = false;
        private static XmlDocument m_xmlDoc = new XmlDocument();

        public static string CultureName
        {
            get { return m_strCultureName; }
        }

#pragma warning disable 0168
        public static bool LoadLocalResource(string strLocalResFile)
        {
            if (m_strLocalResFile == strLocalResFile)
                return true;

            try
            {
                m_xmlDoc.Load(strLocalResFile);
                if (m_xmlDoc.DocumentElement.Name != "Localization")
                {
                    m_bResourceLoaded = false;
                    return false;
                }

                m_strLocalResFile = strLocalResFile;
                m_strCultureName = m_xmlDoc.DocumentElement.Attributes["cultureName"].Value;
                m_bResourceLoaded = true;
            }
            catch (System.Exception ex)
            {
                return false;
            }
            return true;
        }
#pragma warning restore 0168

        public static string GetString(string strSection, string strItem)
        {
            if (!m_bResourceLoaded)
                return "";

            string strValue = null;
            string strSel = "/Localization" + "/" + strSection + "/" + strItem + "/self::*";
            XmlNodeList ndLstMsg = m_xmlDoc.SelectNodes(strSel);
            foreach (XmlNode nd in ndLstMsg)
            {
                strValue = nd.InnerText;
                break;
            }
            return strValue;
        }
    }
}
