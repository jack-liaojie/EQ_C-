
using System.Windows.Forms;
using AutoSports.OVRCommon;

namespace AutoSports.OVRWRPlugin
{
    public class OVRWRPlugin : OVRPluginBase
    {
        private OVRWRDataEntryForm m_frmWRPlugin = null;

        public OVRWRPlugin()
        {
            base.m_strName = GVAR.g_strDisplnName;
            base.m_strDiscCode = GVAR.g_strDisplnCode;

            m_frmWRPlugin = new OVRWRDataEntryForm();
            m_frmWRPlugin.TopLevel = false;
            m_frmWRPlugin.Dock = DockStyle.Fill;
            m_frmWRPlugin.FormBorderStyle = FormBorderStyle.None;
        }

        public override bool Initialize(System.Data.SqlClient.SqlConnection con)
        {
            GVAR.g_WRPlugin = this;
            GVAR.g_ManageDB = new OVRWRManageDB();
            GVAR.g_adoDataBase = new OVRWRDataBase();
            GVAR.g_adoDataBase.DBConnect = con;

            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            return true;
        }

        public override System.Windows.Forms.Control GetModuleUI
        {
            get { return m_frmWRPlugin as System.Windows.Forms.Control; }
        }

        protected override void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e)
        {
            switch (e.Type)
            {
                case OVRMgr2PluginEventType.emMatchSelected:
                    {
                        if (m_frmWRPlugin != null)
                        {
                            m_frmWRPlugin.OnMsgFlushSelMatch(0, GVAR.Str2Int(e.Args.ToString()));
                            SetReportContext("MatchID", e.Args.ToString());
                        }
                        break;
                    }
                case OVRMgr2PluginEventType.emRptContextQuery:
                    {
                        QueryReportContext(e.Args as OVRReportContextQueryArgs);
                        break;
                    }
            }
        }

        private void QueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;
            switch (args.Name)
            {
                case "MatchID":
                    {
                        if (GVAR.g_matchID > 0)
                        {
                            args.Value = GVAR.g_matchID.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                default:
                    break;
            }
        }
    }
}
