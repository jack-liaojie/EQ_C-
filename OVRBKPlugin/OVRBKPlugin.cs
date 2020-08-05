using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using AutoSports.OVRCommon;
using System.Windows.Forms;

namespace AutoSports.OVRBKPlugin
{
    public class OVRBKPlugin : OVRPluginBase
    {

        private frmOVRBKDataEntry m_frmBKPlugin = null;
        static string m_strSectionName = "OVRBKPlugin";

        public OVRBKPlugin()
        {
            base.m_strName = GVAR.g_strDisplnName;
            base.m_strDiscCode = GVAR.g_strDisplnCode;

            m_frmBKPlugin = new frmOVRBKDataEntry();
            m_frmBKPlugin.TopLevel = false;
            m_frmBKPlugin.Dock = DockStyle.Fill;
            m_frmBKPlugin.FormBorderStyle = FormBorderStyle.None;
        }
        public string GetSectionName()
        {
            return m_strSectionName;
        }
        public override bool Initialize(System.Data.SqlClient.SqlConnection con)
        {
            GVAR.g_BKPlugin = this;
            GVAR.g_ManageDB = new OVRBKManagerDB();
            GVAR.g_sqlConn = con;

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            return true;
        }

        public override System.Windows.Forms.Control GetModuleUI
        {
            get { return m_frmBKPlugin as System.Windows.Forms.Control; }
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            m_frmBKPlugin.OnMgrEvent(sender, e);
        }
    }
}
