using System;
using System.Collections.Generic;
using System.Text;
using Sunny.UI;
using AutoSports.OVRCommon;

namespace AutoSports.OVRGeneralData
{
    public class OVRGenDataModule : OVRModuleBase
    {
        public OVRGeneralDataForm m_fmGenData;

        public OVRGenDataModule()
        {
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            m_fmGenData = new OVRGeneralDataForm("OVRGeneralDataFrom");
            m_fmGenData.TopLevel = false;
            m_fmGenData.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            m_fmGenData.GenDataModule = this;
        }

        public override UIPage GetModuleUI
        {
            //get { return m_fmGenData as System.Windows.Forms.Control; }
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
