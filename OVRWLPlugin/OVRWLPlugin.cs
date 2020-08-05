using System;
using System.Collections.Generic;
using System.Text;

using System.Windows.Forms;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

namespace AutoSports.OVRWLPlugin
{
    public class OVRWLPlugin : OVRPluginBase
    {
        private OVRWLDataEntryForm m_frmWLPlugin = null;
        static string m_strSectionName = "OVRWLPlugin";
        public OVRWLPlugin()
        {
            base.m_strName = GVWL.g_strDisplnName;
            base.m_strDiscCode = GVWL.g_strDisplnCode;

            m_frmWLPlugin = new OVRWLDataEntryForm();
            m_frmWLPlugin.TopLevel = false;
            m_frmWLPlugin.Dock = DockStyle.Fill;
            //m_frmWLPlugin.WindowState = FormWindowState.Maximized;
            m_frmWLPlugin.FormBorderStyle = FormBorderStyle.None;
        }
        public string GetSectionName()
        {
            return m_strSectionName;
        }
        public override bool Initialize(System.Data.SqlClient.SqlConnection con)
        {
            GVWL.g_WLPlugin = this;
            GVWL.g_ManageDB = new OVRWLManageDB();
            GVWL.g_adoDataBase = new OVRWLDataBase();
            GVWL.g_adoDataBase.DBConnect = con;

            if (GVWL.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVWL.g_adoDataBase.DBConnect.Open();
            }

            return true;
        }

        public override System.Windows.Forms.Control GetModuleUI
        {
            get { return m_frmWLPlugin as System.Windows.Forms.Control; }
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            switch (e.Type)
            {
                case OVRMgr2PluginEventType.emMatchSelected:
                    {
                        if (m_frmWLPlugin != null)
                        {
                            if (e.Args.ToString().Length != 0)
                                m_frmWLPlugin.OnMsgFlushSelMatch(0, int.Parse(e.Args.ToString()));
                        }
                        break;
                    }
                case OVRMgr2PluginEventType.emRptContextQuery:
                    {
                        if (m_frmWLPlugin != null)
                        {
                            m_frmWLPlugin.QueryReportContext(e.Args as OVRReportContextQueryArgs);
                        }
                        break;
                    }

            }
        }
    }
}
