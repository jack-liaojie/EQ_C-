using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using AutoSports.OVRCommon;
using System.Windows.Forms;

namespace OVRDVPlugin
{
    public class OVRDVPlugin: OVRPluginBase
    {
        private frmOVRDVDataEntry m_frmDVPlugin = null;
        static string m_strSectionName = "OVRDVPlugin";

        public OVRDVPlugin()
        {
            base.m_strName = DVCommon.g_strSectionName;
            base.m_strDiscCode = DVCommon.g_strDisplnCode;

            m_frmDVPlugin = new frmOVRDVDataEntry();
            m_frmDVPlugin.TopLevel = false;
            m_frmDVPlugin.Dock = DockStyle.Fill;
            m_frmDVPlugin.FormBorderStyle = FormBorderStyle.None;
        }

        public string GetSectionName()
        {
            return m_strSectionName;
        }

        public override Boolean Initialize(System.Data.SqlClient.SqlConnection con)
        {
            DVCommon.g_DVPlugin = this;
            DVCommon.g_DataBaseCon = con;
            DVCommon.g_DVDBManager = new OVRDVDBManager();

            if (DVCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                DVCommon.g_DataBaseCon.Open();
            }
            return true;
        }

        public override System.Windows.Forms.Control GetModuleUI
        {
            get { return m_frmDVPlugin as System.Windows.Forms.Control; }
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            switch (e.Type)
            {
                case OVRMgr2PluginEventType.emMatchSelected:
                    {
                        if (m_frmDVPlugin != null)
                        {
                            m_frmDVPlugin.OnMsgFlushSelMatch(0, DVCommon.Str2Int(e.Args.ToString()));
                            SetReportContext("MatchID", e.Args.ToString());
                        }
                        break;
                    }
                case OVRMgr2PluginEventType.emRptContextQuery:
                    {
                        m_frmDVPlugin.QueryReportContext(e.Args as OVRReportContextQueryArgs);
                        break;
                    }
            }
        }
    }
}
