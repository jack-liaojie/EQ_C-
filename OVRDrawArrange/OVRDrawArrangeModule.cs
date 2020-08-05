using System;
using System.Collections.Generic;
using System.Text;

using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    public class OVRDrawArrangeModule : OVRModuleBase
    {
        private OVRDrawArrangeForm m_fmDrawArrange;

        public OVRDrawArrangeModule()
        {
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            m_fmDrawArrange = new OVRDrawArrangeForm("OVRDrawArrangeFrom");
            m_fmDrawArrange.TopLevel = false;
            m_fmDrawArrange.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            m_fmDrawArrange.DrawArrangeModule = this;
        }

        public override UIPage GetModuleUI
        {
            get { return m_fmDrawArrange as UIPage; }
        }

        public override bool Initialize(System.Data.SqlClient.SqlConnection con)
        {
            return base.Initialize(con);
        }

        public override bool UnInitialize()
        {
            return true;
        }

        protected override void OnMainFrameEvent(object sender, OVRFrame2ModuleEventArgs e)
        {
            m_fmDrawArrange.OnMainFrameEvent(sender, e);
        }
    }
}
