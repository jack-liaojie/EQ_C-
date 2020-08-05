using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using AutoSports.OVRCommon;
using System.Windows.Forms;

namespace AutoSports.OVRWPPlugin
{
    public class OVRWPPlugin : OVRPluginBase
    {

        public frmOVRWPDataEntry m_frmWPPlugin = null;
        static string m_strSectionName = "OVRWPPlugin";

        public OVRWPPlugin()
        {
            base.m_strName = GVAR.g_strDisplnName;
            base.m_strDiscCode = GVAR.g_strDisplnCode;

            m_frmWPPlugin = new frmOVRWPDataEntry();
            m_frmWPPlugin.TopLevel = false;
            m_frmWPPlugin.Dock = DockStyle.Fill;
            m_frmWPPlugin.FormBorderStyle = FormBorderStyle.None;
        }
        public string GetSectionName()
        {
            return m_strSectionName;
        }
        public override bool Initialize(System.Data.SqlClient.SqlConnection con)
        {
            GVAR.g_WPPlugin = this;
            GVAR.g_ManageDB = new OVRWPManagerDB();
            GVAR.g_sqlConn = con;

            if (GVAR.g_sqlConn.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_sqlConn.Open();
            }
            return true;
        }

        public override System.Windows.Forms.Control GetModuleUI
        {
            get { return m_frmWPPlugin as System.Windows.Forms.Control; }
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            m_frmWPPlugin.OnMgrEvent(sender, e);
        }
    }
}
