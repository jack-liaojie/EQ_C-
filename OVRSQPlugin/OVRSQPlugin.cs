using System;
using System.Collections.Generic;
using System.Text;

using System.Windows.Forms;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

namespace AutoSports.OVRSQPlugin
{
    public class OVRSQPlugin : OVRPluginBase
    {
        private frmOVRSQDataEntry m_frmSQPlugin = null;
        static string m_strSectionName = "OVRSQPlugin";

        public OVRSQPlugin()
        {
            base.m_strName = SQCommon.g_strDisplnName;
            base.m_strDiscCode = SQCommon.g_strDisplnCode;

            m_frmSQPlugin = new frmOVRSQDataEntry();
            m_frmSQPlugin.TopLevel = false;
            m_frmSQPlugin.Dock = DockStyle.Fill;
            m_frmSQPlugin.FormBorderStyle = FormBorderStyle.None;
        }

        public string GetSectionName()
        {
            return m_strSectionName;
        }

        public override Boolean Initialize(System.Data.SqlClient.SqlConnection con)
        {
            SQCommon.g_SQPlugin = this;
            SQCommon.g_ManageDB = new OVRSQManageDB();
            SQCommon.g_adoDataBase = new OVRSQDataBase();
            SQCommon.g_adoDataBase.DBConnect = con;
            SQCommon.g_adoDataBase.strConnection = con.ConnectionString;

            if (SQCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                SQCommon.g_adoDataBase.DBConnect.Open();
            }

            return true;
        }

        public override System.Windows.Forms.Control GetModuleUI
        {
            get { return m_frmSQPlugin as System.Windows.Forms.Control; }
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            switch (e.Type)
            {
            case OVRMgr2PluginEventType.emMatchSelected:
                {
                    if (m_frmSQPlugin != null)
                    {
                        m_frmSQPlugin.OnMsgFlushSelMatch(0, SQCommon.Str2Int(e.Args.ToString()));
                    }
                    break;
                }
            case OVRMgr2PluginEventType.emRptContextQuery:
                {
                    m_frmSQPlugin.QueryReportContext(e.Args as OVRReportContextQueryArgs);
                    break;
                }
            }
        }
    }
}
