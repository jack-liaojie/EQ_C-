using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using AutoSports.OVRCommon;
namespace AutoSports.OVRFBPlugin
{
    public class OVRFBPlugin : OVRPluginBase
    {

        public frmOVRFBDataEntry m_frmFBPlugin = null;
        static string m_strSectionName = "OVRFBPlugin";

        public OVRFBPlugin()
        {
            base.m_strName = GVAR.g_strDisplnName;
            base.m_strDiscCode = GVAR.g_strDisplnCode;

            m_frmFBPlugin = new frmOVRFBDataEntry();
            m_frmFBPlugin.TopLevel = false;
            m_frmFBPlugin.Dock = DockStyle.Fill;
            m_frmFBPlugin.FormBorderStyle = FormBorderStyle.None;
        }
        public string GetSectionName()
        {
            return m_strSectionName;
        }
        public override bool Initialize(System.Data.SqlClient.SqlConnection con)
        {
            GVAR.g_FBPlugin = this;
            GVAR.g_ManageDB = new OVRFBManagerDB();
            GVAR.g_sqlConn = con;

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            return true;
        }

        public override System.Windows.Forms.Control GetModuleUI
        {
            get { return m_frmFBPlugin as System.Windows.Forms.Control; }
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            m_frmFBPlugin.OnMgrEvent(sender, e);
        }
    }
}
