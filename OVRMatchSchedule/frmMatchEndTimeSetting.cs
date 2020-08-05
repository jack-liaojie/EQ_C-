using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Diagnostics;
using AutoSports.OVRCommon;
using DevComponents.DotNetBar;
using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    public partial class MatchEndTimeSettingForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public MatchEndTimeSettingForm(string strName)
        {
            InitializeComponent();
            this.Name = strName;
            Localization();
        }
        public string m_strEndTime = "";
        public string m_strSpanTime = "";

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchEndTimeForm");
            labX_EndTime.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchEndTimeForm_labXEndTime");
            labX_SpanTime.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchEndTimeForm_labXSpanTime");
            btnX_OK.Tooltip = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchEndTimeForm_btnXOK");
            btnX_Cancel.Tooltip = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchEndTimeForm_btnXCancel");
        }

        private void dti_EndTime_TextChanged(object sender, EventArgs e)
        {
            string strTime = dti_EndTime.Value.ToString("HH:mm:ss");

            if (strTime.Length == 0)
                return;

            m_strEndTime = strTime;
        }

        private void dti_SpanTime_TextChanged(object sender, EventArgs e)
        {
            string strTime = dti_SpanTime.Value.ToString("HH:mm:ss");

            if (strTime.Length == 0)
                return;

            m_strSpanTime = strTime;
        }

        private void btnX_OK_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void btnX_Cancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
