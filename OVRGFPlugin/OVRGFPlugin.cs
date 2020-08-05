using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AutoSports.OVRCommon;
using System.Windows.Forms;

namespace AutoSports.OVRGFPlugin
{
    public class OVRGFPlugin : OVRPluginBase
    {
        private frmOVRGFDataEntry m_frmGFPlugin = null;

        public OVRGFPlugin()
        {

            base.m_strName = GFCommon.g_strSectionName;
            base.m_strDiscCode = GFCommon.g_strDisplnCode;

            m_frmGFPlugin = new frmOVRGFDataEntry();
            m_frmGFPlugin.TopLevel = false;
            m_frmGFPlugin.Dock = DockStyle.Fill;
            m_frmGFPlugin.FormBorderStyle = FormBorderStyle.None;
        }

        public string GetSectionName()
        {
            return GFCommon.g_strSectionName;
        }

        public override Boolean Initialize(System.Data.SqlClient.SqlConnection con)
        {
            GFCommon.g_GFPlugin = this;
            GFCommon.g_DataBaseCon = con;
            GFCommon.g_strConnectionString = con.ConnectionString;

            if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
            {
                GFCommon.g_DataBaseCon.Open();
            }

            return true;
        }

        public override System.Windows.Forms.Control GetModuleUI
        {
            get { return m_frmGFPlugin as System.Windows.Forms.Control; }
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            switch (e.Type)
            {
                case OVRMgr2PluginEventType.emMatchSelected:
                    {
                        if (m_frmGFPlugin != null)
                        {
                            m_frmGFPlugin.OnMsgFlushSelMatch(0, GFCommon.Str2Int(e.Args.ToString()));
                        }
                        break;
                    }
                case OVRMgr2PluginEventType.emRptContextQuery:
                    {
                        m_frmGFPlugin.QueryReportContext(e.Args as OVRReportContextQueryArgs);
                        break;
                    }
            }
        }
    }
}