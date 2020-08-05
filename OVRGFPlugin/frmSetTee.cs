using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

namespace AutoSports.OVRGFPlugin
{
    public partial class frmSetTee : DevComponents.DotNetBar.Office2007Form
    {
        public Int32 m_iCurMatchID;
        public Int32 m_iStart;
        public Int32 m_iFinish;
        public Int32 m_iTee;
        public string m_strStartTime = "";
        public string m_strSpanTime = "";

        public frmSetTee()
        {
            InitializeComponent();
        }

        private void Localization()
        {
            this.lb_StartGroup.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbStartGroup");
            this.lb_FinishGroup.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbFinishGroup");
            this.lb_StartTee.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbStartTee");
            this.lb_StartTime.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbStartTime");
            this.lb_SpanTime.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbSpanTime");
        }

        private void frmSetTee_Load(object sender, EventArgs e)
        {
            Localization();

            dti_StartTime.Text = m_strStartTime;
        }

        private void tb_Start_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar != 8 && !Char.IsDigit(e.KeyChar) && e.KeyChar != 13)
            {
                e.Handled = true;
            }
        }

        private void tb_Finish_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar != 8 && !Char.IsDigit(e.KeyChar) && e.KeyChar != 13)
            {
                e.Handled = true;
            }
        }

        private void tb_Tees_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar != 8 && !Char.IsDigit(e.KeyChar) && e.KeyChar != 13)
            {
                e.Handled = true;
            }
        }

        private void dti_StartTime_TextChanged(object sender, EventArgs e)
        {
            string strTime = dti_StartTime.Value.ToString("HH:mm");

            if (strTime.Length == 0)
                return;

            m_strStartTime = strTime;
        }

        private void dti_SpanTime_TextChanged(object sender, EventArgs e)
        {
            string strTime = dti_SpanTime.Value.ToString("HH:mm");

            if (strTime.Length == 0)
                return;

            m_strSpanTime = strTime;
        }

        private void btnx_OKSetTee_Click(object sender, EventArgs e)
        {
            m_iStart = GFCommon.ConvertStrToInt(tb_Start.Text);
            m_iFinish = GFCommon.ConvertStrToInt(tb_Finish.Text);
            m_iTee = GFCommon.ConvertStrToInt(tb_Tees.Text);

            bool bResult = GFCommon.g_ManageDB.SetMatchTee(m_iCurMatchID, m_iStart, m_iFinish, m_iTee, m_strStartTime, m_strSpanTime);

            if (bResult)
            {
                this.DialogResult = DialogResult.OK;
            }
            
            this.Close();
        }

        private void btnx_Cancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
