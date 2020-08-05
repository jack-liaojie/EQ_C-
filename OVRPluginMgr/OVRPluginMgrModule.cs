using System;
using System.Collections.Generic;
using System.Text;
using Sunny.UI;

using AutoSports.OVRCommon;

namespace AutoSports.OVRPluginMgr
{
    public class OVRPluginMgrModule : OVRModuleBase
    {
        private OVRPluginMgrForm m_fmPluginMgr;

        public OVRPluginMgrModule()
        {
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            m_fmPluginMgr = new OVRPluginMgrForm("OVRPluginMgrForm");
            m_fmPluginMgr.TopLevel = false;
            m_fmPluginMgr.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            m_fmPluginMgr.PluginMgrModule = this;
        }

        public override UIPage GetModuleUI
        {
            get { return m_fmPluginMgr as UIPage; }
        }

        public override bool Initialize(System.Data.SqlClient.SqlConnection con)
        {
            return base.Initialize(con);
        }

        public override bool UnInitialize()
        {
            if (m_fmPluginMgr != null)
            {
                return m_fmPluginMgr.UnInitialize();
            }
            else
                return true;
        }

        protected override void OnMainFrameEvent(object sender, OVRFrame2ModuleEventArgs e)
        {
            m_fmPluginMgr.OnMainFrameEvent(sender, e);
        }
    }
}
