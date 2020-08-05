using System;
using System.Collections.Generic;
using System.Text;

using System.Windows.Forms;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

namespace AutoSports.OVRSEPlugin
{
    public class OVRSEPlugin : OVRPluginBase
    {
        private frmOVRSEDataEntry m_frmSEPlugin = null;
        static string m_strSectionName = "OVRSTPlugin";

        public OVRSEPlugin()
        {
            base.m_strName = SECommon.g_strDisplnName;
            base.m_strDiscCode = SECommon.g_strDisplnCode;

            m_frmSEPlugin = new frmOVRSEDataEntry();
            m_frmSEPlugin.TopLevel = false;
            m_frmSEPlugin.Dock = DockStyle.Fill;
            m_frmSEPlugin.FormBorderStyle = FormBorderStyle.None;
        }

        public string GetSectionName()
        {
            return m_strSectionName;
        }

        public override Boolean Initialize(System.Data.SqlClient.SqlConnection con)
        {
            SECommon.g_SEPlugin = this;
            SECommon.g_ManageDB = new OVRSEManageDB();
            SECommon.g_adoDataBase = new OVRSEDataBase();
            SECommon.g_adoDataBase.DBConnect = con;
            SECommon.g_adoDataBase.strConnection = con.ConnectionString;

            if (SECommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SECommon.g_adoDataBase.DBConnect.Open();
            }

            return true;
        }

        public override System.Windows.Forms.Control GetModuleUI
        {
            get { return m_frmSEPlugin as System.Windows.Forms.Control; }
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            switch (e.Type)
            {
            case OVRMgr2PluginEventType.emMatchSelected:
                {
                    if (m_frmSEPlugin != null)
                    {
                        m_frmSEPlugin.OnMsgFlushSelMatch(0, SECommon.Str2Int(e.Args.ToString()));
                    }
                    break;
                }
            case OVRMgr2PluginEventType.emRptContextQuery:
                {
                    m_frmSEPlugin.QueryReportContext(e.Args as OVRReportContextQueryArgs);
                    break;
                }
            }
        }
    }
}
