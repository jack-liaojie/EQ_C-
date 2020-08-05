using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using AutoSports.OVRCommon;

namespace AutoSports.OVRSHPlugin
{
    public class OVRSHPlugin : OVRPluginBase
    {
        private frmOVRSHDataEntry m_frmSHDataEntry = null;
        static string m_strSectionName = "OVRSHPlugin";

        public OVRSHPlugin()
        {
            base.m_strName = SHCommon.g_strSectionName;
            base.m_strDiscCode = SHCommon.g_strDisplnCode;

            m_frmSHDataEntry = new frmOVRSHDataEntry();
            m_frmSHDataEntry.TopLevel = false;
            m_frmSHDataEntry.Dock = DockStyle.Fill;
            m_frmSHDataEntry.FormBorderStyle = FormBorderStyle.None;
        }

        public string GetSectionName()
        {
            return m_strSectionName;
        }

        public override Boolean Initialize(System.Data.SqlClient.SqlConnection con)
        {
            SHCommon.g_SHPlugin = this;
            SHCommon.g_DataBaseCon = con;
            if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                SHCommon.g_DataBaseCon.Open();
            }

            if (m_frmSHDataEntry != null)
                m_frmSHDataEntry.Plugin = this;

            return true;
        }

        public override System.Windows.Forms.Control GetModuleUI
        {
            get { return m_frmSHDataEntry as System.Windows.Forms.Control; }
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            switch (e.Type)
            {
                case OVRMgr2PluginEventType.emMatchSelected:
                    {
                        if (m_frmSHDataEntry != null)
                        {
                            m_frmSHDataEntry.OnMsgFlushSelMatch(0, int.Parse(e.Args.ToString()));
                        }
                        break;
                    }
                case OVRMgr2PluginEventType.emRptContextQuery:
                    {
                        m_frmSHDataEntry.QueryReportContext(e.Args as OVRReportContextQueryArgs);
                        break;
                    }
            }
        }


    }
}
