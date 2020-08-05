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
    public partial class MatchCodeSettingForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        private string m_strPreFix;
        public string PreFix
        {
            get { return m_strPreFix; }
            set { m_strPreFix = value; }
        }

        private int m_iStartNumber;
        public int StartNumber
        {
            get { return m_iStartNumber; }
            set { m_iStartNumber = value; }
        }

        private int m_iStep;
        public int Step
        {
            get { return m_iStep; }
            set { m_iStep = value; }
        }

        private int m_iCodeLength;
        public int CodeLength
        {
            get { return m_iCodeLength; }
            set { m_iCodeLength = value; }
        }

        public bool m_bChkSortByTime = false;

        public MatchCodeSettingForm(string strName)
        {
            InitializeComponent();
            this.Name = strName;
            Localization();
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCodeForm");
            labX_PreFix.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCodeForm_labXPreFix");
            labX_StartNumber.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCodeForm_labXStartNumber");
            labX_Step.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCodeForm_labXStep");
            labX_CodeLength.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCodeForm_labXCodeLength");
            chkX_SortByTime.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCodeForm_chkXSortByTime");
            btnX_OK.Tooltip = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCodeForm_btnXOK");
            btnX_Cancel.Tooltip = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCodeForm_btnXCancel");
        }

        private void MatchCodeSettingForm_Load(object sender, EventArgs e)
        {
            PreFix = "";
            StartNumber = 1;
            Step = 1;
            CodeLength = GetCodeLength();

            txPreFix.Text = PreFix;
            txStartNumber.Text = Convert.ToString(StartNumber);
            txStep.Text = Convert.ToString(Step);
            txCodeLength.Text = Convert.ToString(CodeLength);
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            PreFix = txPreFix.Text;

            if (txStartNumber.Text.Length != 0)
            {
                try
                {
                    StartNumber = Convert.ToInt32(txStartNumber.Text);
                }
                catch (System.Exception ex)
                {
                    string strMsgBox = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCodeForm_NumberMsgBox");
                    if (strMsgBox.Length == 0)
                        strMsgBox = ex.Message.ToString();
                    DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox);
                    return;
                }
            }
            else
            {
                StartNumber = -1;
            }

            if (txStep.Text.Length != 0)
            {
                try
                {
                    Step = Convert.ToInt32(txStep.Text);
                }
                catch (System.Exception ex)
                {
                    string strMsgBox = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCodeForm_NumberMsgBox");
                    if (strMsgBox.Length == 0)
                        strMsgBox = ex.Message.ToString();
                    DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox);
                    return;
                }
            }
            else
            {
                Step = -1;
            }

            if (txCodeLength.Text.Length != 0)
            {
                try
                {
                    CodeLength = Convert.ToInt32(txCodeLength.Text);
                }
                catch (System.Exception ex)
                {
                    string strMsgBox = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCodeForm_NumberMsgBox");
                    if (strMsgBox.Length == 0)
                        strMsgBox = ex.Message.ToString();
                    DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox);
                    return;
                }
            }
            else
            {
                CodeLength = -1;
            }

            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        private int GetCodeLength()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            SqlDataReader dr = null;
            try
            {
                string strItemName = "MatchCodeLength";

                string strSQL;
                strSQL = String.Format("SELECT ItemValue FROM TC_Discipline_Config WHERE ItemName = '{0}'", strItemName);

                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                dr = cmd.ExecuteReader();

                int iLength = 0;
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iLength = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "ItemValue");
                    }
                    dr.Close();
                }
                return iLength;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                if (dr != null)
                {
                    dr.Close();
                }
                return 0;
            }
        }

        private void chkX_SortByTime_CheckedChanged(object sender, EventArgs e)
        {
            if (this.chkX_SortByTime.Checked)
            {
                m_bChkSortByTime = true;
            }
            else
            {
                m_bChkSortByTime = false;
            }
        }
    }
}