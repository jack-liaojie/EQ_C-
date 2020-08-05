using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using DevComponents.DotNetBar.Controls;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    public partial class OVREQEditTimeForm : UIForm
    {
        #region Property
        private string m_strStartTime = "";
        public string StartTime
        {
            get { return m_strStartTime; }
            set { m_strStartTime = value; }
        }
        private string m_strSpanTime = "";
        public string SpanTime
        {
            get { return m_strSpanTime; }
            set { m_strSpanTime = value; }
        }
        #endregion

        #region Constructor
        public OVREQEditTimeForm()
        {
            InitializeComponent();
            //m_strStartTime = "";
            //m_strSpanTime = "";
            Localization();
        }

        private void Localization()
        {
            String strSectionName = GVAR.g_EQPlugin.GetSectionName();
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "OVREQEditTime");
            labX_StartTime.Text = LocalizationRecourceManager.GetString(strSectionName, "labXStartTime");
            labX_SpanTime.Text = LocalizationRecourceManager.GetString(strSectionName, "labXSpanTime");
            btnX_OK.Text = LocalizationRecourceManager.GetString(strSectionName, "btnXOK");
            btnX_Cancel.Text = LocalizationRecourceManager.GetString(strSectionName, "btnXCancel");
        }
        #endregion

        #region FormLoad
        private void OVREQEditTimeFrom_Load(object sender, EventArgs e)
        {
           // 显示当前的starttime和breaktime
            DateTime dtOut;
            DateTime.TryParse(m_strSpanTime, out dtOut);
            dti_SpanTime.Value = dtOut;
            ////如果m_strSpanTime不为空
            //if（)
            //{
            //    string[] time= m_strSpanTime.Split(':');
            //    dti_SpanTime.Value = new DateTime(1, 1, 1, Convert.ToInt16(time[0]), Convert.ToInt16(time[1]), Convert.ToInt16(time[2]));
            //}
        }
        #endregion

        #region ButtonClick
        private void btnOK_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }
        #endregion

        #region Time
        private void dti_StartTime_TextChanged(object sender, EventArgs e)
        {
            string strTime = dti_StartTime.Value.ToString("HH:mm:ss");

            if (strTime.Length == 0)
                return;

            m_strStartTime = strTime;
        }

        private void dti_SpanTime_TextChanged(object sender, EventArgs e)
        {
            string strTime = dti_SpanTime.Value.ToString("HH:mm:ss");

            if (strTime.Length == 0)
                return;

            m_strSpanTime = strTime;
        }
        #endregion
    }
}
