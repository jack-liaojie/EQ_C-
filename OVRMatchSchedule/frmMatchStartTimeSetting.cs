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
    public partial class MatchStartTimeSettingForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public MatchStartTimeSettingForm(string strName)
        {
            InitializeComponent();
            this.Name = strName;
            Localization();
        }
        public string m_strStartTime = "";
        public string m_strSpendTime = "";
        public string m_strSpanTime = "";
        public bool m_bChkAdvanceTime = false;
        public string m_strAdvanceTime = "";
        public bool m_bChkDelayTime = false;
        public string m_strDelayTime = "";

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchStartTimeForm");
            labX_StartTime.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchStartTimeForm_labXStartTime");
            labX_SpendTime.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchStartTimeForm_labXSpendTime");
            labX_SpanTime.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchStartTimeForm_labXSpanTime");
            labX_AdvanceTime.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchStartTimeForm_labXAdvanceTime");
            labX_DelayTime.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchStartTimeForm_labXDelayTime");
            btnX_OK.Tooltip = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchStartTimeForm_btnXOK");
            btnX_Cancel.Tooltip = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchStartTimeForm_btnXCancel");

            this.dti_AdvanceTime.Enabled = false;
            this.dti_DelayTime.Enabled = false;
        }

        private void dti_StartTime_TextChanged(object sender, EventArgs e)
        {
            string strTime = dti_StartTime.Value.ToString("HH:mm:ss");

            if (strTime.Length == 0)
                return;

            m_strStartTime = strTime;
        }

        private void dti_SpendTime_TextChanged(object sender, EventArgs e)
        {
            string strTime = dti_SpendTime.Value.ToString("HH:mm:ss");

            if (strTime.Length == 0)
                return;

            m_strSpendTime = strTime;
        }

        private void dti_SpanTime_TextChanged(object sender, EventArgs e)
        {
            string strTime = dti_SpanTime.Value.ToString("HH:mm:ss");

            if (strTime.Length == 0)
                return;

            m_strSpanTime = strTime;
        }

        private void dti_AdvanceTime_TextChanged(object sender, EventArgs e)
        {
            string strTime = dti_AdvanceTime.Value.ToString("HH:mm:ss");

            if (strTime.Length == 0)
                return;

            m_strAdvanceTime = strTime;
        }

        private void dti_DelayTime_TextChanged(object sender, EventArgs e)
        {
            string strTime = dti_DelayTime.Value.ToString("HH:mm:ss");

            if (strTime.Length == 0)
                return;

            m_strDelayTime = strTime;
        }

        private void chkX_AdvanceTime_CheckedChanged(object sender, EventArgs e)
        {
            if (this.chkX_AdvanceTime.Checked)
            {
                this.dti_StartTime.Text = "";
                this.dti_SpendTime.Text = "";
                this.dti_SpanTime.Text = "";
                this.dti_StartTime.Enabled = false;
                this.dti_SpendTime.Enabled = false;
                this.dti_SpanTime.Enabled = false;
                m_bChkAdvanceTime = true;
                this.dti_AdvanceTime.Enabled = true;

                this.dti_DelayTime.Enabled = false;
                this.chkX_DelayTime.CheckState = CheckState.Unchecked;
                m_bChkDelayTime = false;
                this.chkX_DelayTime.Enabled = false;
            }
            else
            {
                this.dti_StartTime.Enabled = true;
                this.dti_SpendTime.Enabled = true;
                this.dti_SpanTime.Enabled = true;
                m_bChkAdvanceTime = false;
                this.dti_AdvanceTime.Text = "";
                this.dti_AdvanceTime.Enabled = false;

                this.dti_DelayTime.Enabled = false;
                this.chkX_DelayTime.CheckState = CheckState.Unchecked;
                m_bChkDelayTime = false;
                this.chkX_DelayTime.Enabled = true;
            }
        }

        private void chkX_DelayTime_CheckedChanged(object sender, EventArgs e)
        {
            if (this.chkX_DelayTime.Checked)
            {
                this.dti_StartTime.Text = "";
                this.dti_SpendTime.Text = "";
                this.dti_SpanTime.Text = "";
                this.dti_StartTime.Enabled = false;
                this.dti_SpendTime.Enabled = false;
                this.dti_SpanTime.Enabled = false;
                m_bChkDelayTime = true;
                this.dti_DelayTime.Enabled = true;

                this.dti_AdvanceTime.Enabled = false;
                this.chkX_AdvanceTime.CheckState = CheckState.Unchecked;
                m_bChkAdvanceTime = false;
                this.chkX_AdvanceTime.Enabled = false;
            }
            else
            {
                this.dti_StartTime.Enabled = true;
                this.dti_SpendTime.Enabled = true;
                this.dti_SpanTime.Enabled = true;
                m_bChkDelayTime = false;
                this.dti_DelayTime.Text = "";
                this.dti_DelayTime.Enabled = false;

                this.dti_AdvanceTime.Enabled = false;
                this.chkX_AdvanceTime.CheckState = CheckState.Unchecked;
                m_bChkAdvanceTime = false;
                this.chkX_AdvanceTime.Enabled = true;
            }
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
