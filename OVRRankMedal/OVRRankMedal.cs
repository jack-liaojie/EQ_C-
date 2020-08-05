using System;
using System.Collections.Generic;
using System.Text;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRRankMedal
{
    public class OVRRankMedalModule : OVRModuleBase
    {
        OVRRankMedalForm m_frmRankMedal;

        public OVRRankMedalModule()
        {
            InitializeModule();
        }

        private void InitializeModule()
        {
            m_frmRankMedal = new OVRRankMedalForm();
            m_frmRankMedal.TopLevel = false;
            m_frmRankMedal.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            m_frmRankMedal.PropRankMedal = this;
        }

        public override UIPage GetModuleUI
        {
            get { return m_frmRankMedal as UIPage; }
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
            m_frmRankMedal.OnMainFrameEvent(sender, e);
        }
    }
}
