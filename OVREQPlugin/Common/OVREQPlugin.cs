using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using AutoSports.OVRCommon;
using System.Windows.Forms;

namespace AutoSports.OVREQPlugin
{
    public class OVREQPlugin : OVRPluginBase
    {
        public frmOVREQDataEntry m_frmEQPlugin = null;
        static string m_strSectionName = "OVREQPlugin";

        public OVREQPlugin()
        {
            base.m_strName = GVAR.g_strSectionName;
            base.m_strDiscCode = GVAR.g_strDisplnCode;

            m_frmEQPlugin = new frmOVREQDataEntry();
            m_frmEQPlugin.TopLevel = false;
            m_frmEQPlugin.Dock = DockStyle.Fill;
            m_frmEQPlugin.FormBorderStyle = FormBorderStyle.None;
        }

        public string GetSectionName()
        {
            return m_strSectionName;
        }

        public override Boolean Initialize(System.Data.SqlClient.SqlConnection con)
        {
            GVAR.g_EQPlugin = this;
            GVAR.g_adoDataBase = new OVREQDataBase();
            GVAR.g_adoDataBase.DBConnect = con;
            GVAR.g_EQDBManager = new OVREQDBManager();

            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            return true;
        }

        public override System.Windows.Forms.Control GetModuleUI
        {
            get { return m_frmEQPlugin as System.Windows.Forms.Control; }
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            switch (e.Type)
            {
                case OVRMgr2PluginEventType.emMatchSelected:
                    {
                        if (m_frmEQPlugin != null)
                        {
                            m_frmEQPlugin.OnMsgFlushSelMatch(0, GVAR.Str2Int(e.Args.ToString()));
                            SetReportContext("MatchID", e.Args.ToString());
                        }
                        break;
                    }
                case OVRMgr2PluginEventType.emRptContextQuery:
                    {
                        m_frmEQPlugin.QueryReportContext(e.Args as OVRReportContextQueryArgs);
                        break;
                    }
            }
        }
    }
}
