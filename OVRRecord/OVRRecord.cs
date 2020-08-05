using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRRecord
{
    public class OVRRecordModule : OVRModuleBase
    {
        OVRRecordForm m_frmRecord;

        public OVRRecordModule()
        {
            InitializeModule();
        }

        private void InitializeModule()
        {
            m_frmRecord = new OVRRecordForm();
            m_frmRecord.TopLevel = false;
            m_frmRecord.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            m_frmRecord.RecordMdodule = this;

        }

        public override UIPage GetModuleUI
        {
            get { return m_frmRecord as UIPage; }
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
            m_frmRecord.OnMainFrameEvent(sender, e);
        }
    }
}
