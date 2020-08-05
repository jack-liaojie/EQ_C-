using System;
using System.IO;
using System.Reflection;
using System.Windows.Forms;
using AutoSports.OVRCommon;
using DevComponents.DotNetBar;

namespace AutoSports.OVRBDPlugin
{
    public class OVRBDPlugin : OVRPluginBase
    {
        private frmOVRBDDataEntry m_frmBDPlugin = null;
        static string m_strSectionName = "OVRBDPlugin";
        public OVRBDPlugin()
        {
            base.m_strName = BDCommon.g_strDisplnName;

            // Get the wanted discipline code from the current dll file name
            Assembly curAssembly = Assembly.GetExecutingAssembly();
            string strDiscCode = Path.GetFileNameWithoutExtension(curAssembly.ManifestModule.Name);
            if (strDiscCode == "BD" || strDiscCode == "TT")
                BDCommon.g_strDisplnCode = strDiscCode;


            base.m_strDiscCode = BDCommon.g_strDisplnCode;
            BDCommon.g_errorLog = new OVRErrorLog(BDCommon.g_strDisplnCode);
            BDCommon.g_errorLog.Initialize();

            m_frmBDPlugin = new frmOVRBDDataEntry();
            m_frmBDPlugin.TopLevel = false;
            m_frmBDPlugin.Dock = DockStyle.Fill;
            m_frmBDPlugin.FormBorderStyle = FormBorderStyle.None;
        }

        ~OVRBDPlugin()
        {
            if ( BDCommon.g_vTcpServer != null )
            {
                BDCommon.g_vTcpServer.CloseServer();
            }
            
        }

        public string GetSectionName()
        {
            return m_strSectionName;
        }

        public override Boolean Initialize(System.Data.SqlClient.SqlConnection con)
        {
            BDCommon.g_BDPlugin = this;
            BDCommon.g_ManageDB = new OVRBDManageDB();
            BDCommon.g_adoDataBase = new OVRBDDataBase();
            try
            {
                BDCommon.g_vTcpServer = new TcpServerSimple(21000, 0xFFFFFFFF);
                if( !BDCommon.g_vTcpServer.StartServer() )
                {
                    MessageBoxEx.Show(BDCommon.g_vTcpServer.LastErrorMsg);
                    return false;
                }
            }
            catch (System.Exception ex)
            {
                MessageBoxEx.Show(ex.Message);
                return false;
            }

            BDCommon.g_adoDataBase.DBConnect = con;
            BDCommon.g_adoDataBase.strConnection = con.ConnectionString;

            if (BDCommon.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                BDCommon.g_adoDataBase.DBConnect.Open();
            }

            return true;
        }

        public override System.Windows.Forms.Control GetModuleUI
        {
            get { return m_frmBDPlugin as System.Windows.Forms.Control; }
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            switch (e.Type)
            {
                case OVRMgr2PluginEventType.emMatchSelected:
                    {
                        if (m_frmBDPlugin != null)
                        {
                            m_frmBDPlugin.OnMsgFlushSelMatch(0, BDCommon.Str2Int(e.Args.ToString()));
                        }
                        break;
                    }
                case OVRMgr2PluginEventType.emRptContextQuery:
                    {
                        m_frmBDPlugin.QueryReportContext(e.Args as OVRReportContextQueryArgs);
                        break;
                    }
            }
        }
    }
}
