using System;
using System.Collections.Generic;
using System.Text;

using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRRegister
{
    public class OVRRegisterModule : OVRModuleBase
    {
        private OVRRegisterForm m_fmGenData;

        public OVRRegisterModule()
        {
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            m_fmGenData = new OVRRegisterForm("OVRRegisterForm");
            m_fmGenData.TopLevel = false;
            m_fmGenData.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            m_fmGenData.RegisterModule = this;
        }

        public override UIPage GetModuleUI
        {
            get { return m_fmGenData as UIPage; }
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
            m_fmGenData.OnMainFrameEvent(sender, e);
        }
    }
}
