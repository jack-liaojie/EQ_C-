using System;
using System.Collections.Generic;
using System.Text;

using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    public class OVRMatchScheduleModule : OVRModuleBase
    {
        private OVRMatchScheduleForm m_fmMatchSchedule;
        static string strSectionName = "OVRMatchSchedule";

        public OVRMatchScheduleModule()
        {
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            m_fmMatchSchedule = new OVRMatchScheduleForm("OVRMatchScheduleFrom");
            m_fmMatchSchedule.TopLevel = false;
            m_fmMatchSchedule.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            m_fmMatchSchedule.MatchScheduleModule = this;
        }

        public override UIPage GetModuleUI
        {
            get { return m_fmMatchSchedule as UIPage; }
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
            m_fmMatchSchedule.OnMainFrameEvent(sender, e);
        }

        static public string GetSectionName()
        {
            return strSectionName;
        }
    }
}
