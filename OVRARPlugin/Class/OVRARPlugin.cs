using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

namespace AutoSports.OVRARPlugin
{
    public class OVRARPlugin : OVRPluginBase
    {
        private OVRARDataEntryForm m_frmARPlugin = null;
        public static string m_strSectionName = "OVRARPlugin";

        public OVRARPlugin()
        {
            base.m_strName = GVAR.g_strDisplnName;
            base.m_strDiscCode = GVAR.g_strDisplnCode;

            
            m_frmARPlugin = new OVRARDataEntryForm();
            m_frmARPlugin.TopLevel = false;
            m_frmARPlugin.Dock = DockStyle.Fill;
            //m_frmARPlugin.WindowState = FormWindowState.Maximized;
            m_frmARPlugin.FormBorderStyle = FormBorderStyle.None;
        }
        public string GetSectionName()
        {
            return m_strSectionName;
        }
        public override bool Initialize(System.Data.SqlClient.SqlConnection con)
        {
            GVAR.g_ARPlugin = this;
            GVAR.g_ManageDB = new OVRARManageDB();
            GVAR.g_adoDataBase = new OVRARDataBase();
            GVAR.g_adoDataBase.DBConnect = con;

            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            return true;
        }

        public override System.Windows.Forms.Control GetModuleUI
        {
            get { return m_frmARPlugin as System.Windows.Forms.Control; }
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            switch (e.Type)
            {
                case OVRMgr2PluginEventType.emMatchSelected:
                    {
                        if (m_frmARPlugin != null)
                        {
                            if (e.Args.ToString().Length != 0)
                                m_frmARPlugin.OnMsgFlushSelMatch(0, int.Parse(e.Args.ToString()));
                        }
                        break;
                    }
                case OVRMgr2PluginEventType.emRptContextQuery:
                    {
                        if (m_frmARPlugin != null)
                        {
                            m_frmARPlugin.QueryReportContext(e.Args as OVRReportContextQueryArgs);
                        }
                        break;
                    }

            }
        }
    }
}
