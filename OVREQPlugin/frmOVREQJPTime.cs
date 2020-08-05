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
    public partial class OVREQJPTimeForm : UIForm
    {
        #region Field
        private string m_strPauseTime = "";
        private string m_strCorrectTime = "";
        private string m_strFinalTime = "";
        private decimal m_fFinalTime = 0;
        public decimal FinalTime
        {
            get { return m_fFinalTime; }
            set { m_fFinalTime = value; }
        }
        private string m_strCurrentTime = "";
        private decimal m_fCurrentTime = 0;
        private int MatchConfigID;
        #endregion

        #region Constructor
        public OVREQJPTimeForm(int m_iCurMatchConfigID,string strTime)
        {
            InitializeComponent();
            m_strCurrentTime = strTime;
            txt_FinalTime.Text = strTime;
            MatchConfigID = m_iCurMatchConfigID;
            if (MatchConfigID == 7)
            {
                m_fFinalTime = GVAR.StrTime2Decimal(strTime);
                m_fCurrentTime = GVAR.StrTime2Decimal(strTime);
            }
            else
            {
                m_fFinalTime = GVAR.Str2Decimal(strTime);
                m_fCurrentTime = GVAR.Str2Decimal(strTime);
            }

            Localization();
        }

        private void Localization()
        {
            String strSectionName = GVAR.g_EQPlugin.GetSectionName();
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "OVREQJPTime");
            labX_PauseTime.Text = LocalizationRecourceManager.GetString(strSectionName, "labXPauseTime");
            labX_CorrectTime.Text = LocalizationRecourceManager.GetString(strSectionName, "labXCorrectTime");
            labX_FinalTime.Text = LocalizationRecourceManager.GetString(strSectionName, "labXFinalTime");
            btnX_OK.Text = LocalizationRecourceManager.GetString(strSectionName, "btnXOK");
            btnX_Cancel.Text = LocalizationRecourceManager.GetString(strSectionName, "btnXCancel");
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

        #region Time Calc
        private void txt_PauseTime_Validating(object sender, CancelEventArgs e)
        {
            //如果是越野时间验证
            if (MatchConfigID == 7)
            {
                string pattern = @"^\d{1,2}'\d{2}''$";
                TextBox tb = (TextBox)sender;
                if (tb.Text.ToString().Length != 0 && 
                    !RegexDao.IsMatch(pattern, tb.Text.ToString()))
                    e.Cancel = true;
            }
            //如果是场地障碍时间验证
            else
            {
                string pattern = @"^\d{1,3}\.?\d{0,3}$";
                TextBox tb = (TextBox)sender;
                if (tb.Text.ToString().Length != 0 && 
                    !RegexDao.IsMatch(pattern, tb.Text.ToString()))
                    e.Cancel = true;
            }
        }

        private void txt_CorrectTime_Validating(object sender, CancelEventArgs e)
        {
            //如果是越野时间验证
            if (MatchConfigID == 7)
            {
                string pattern = @"^\d{1,2}'\d{2}''$";
                TextBox tb = (TextBox)sender;
                if (tb.Text.ToString().Length != 0 &&
                    !RegexDao.IsMatch(pattern, tb.Text.ToString()))
                    e.Cancel = true;
            }
            //如果是场地障碍时间验证
            else
            {
                string pattern = @"^\d{1,3}\.?\d{0,3}$";
                TextBox tb = (TextBox)sender;
                if (tb.Text.ToString().Length != 0 &&
                    !RegexDao.IsMatch(pattern, tb.Text.ToString()))
                    e.Cancel = true;
            }
        }

        private void txt_PauseTime_Validated(object sender, EventArgs e)
        {
            calcFinalTime();
        }

        private void txt_CorrectTime_Validated(object sender, EventArgs e)
        {
            calcFinalTime();
        }

        private void calcFinalTime()
        {
            if (MatchConfigID == 7)
            {
                m_fFinalTime = m_fCurrentTime - GVAR.StrTime2Decimal(txt_PauseTime.Text) + GVAR.StrTime2Decimal(txt_CorrectTime.Text);
                m_strFinalTime = GVAR.Float2StrTime(m_fFinalTime);
                txt_FinalTime.Text = m_strFinalTime;
            }
            else
            {
                m_fFinalTime = m_fCurrentTime - GVAR.Str2Decimal(txt_PauseTime.Text) + GVAR.Str2Decimal(txt_CorrectTime.Text);
                m_strFinalTime = m_fFinalTime.ToString();
                txt_FinalTime.Text = m_strFinalTime;
            }
        }
        #endregion
    }
}
