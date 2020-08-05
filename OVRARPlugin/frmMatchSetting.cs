using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Collections;
using DevComponents.DotNetBar;
using DevComponents.DotNetBar.Controls;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

namespace AutoSports.OVRARPlugin
{
    public partial class MatchSettingFrom : Office2007Form
    {
        public AR_MatchInfo CurMatchInfo = new AR_MatchInfo();

        private DataTable m_tbCompetitionRule = new DataTable();

        public MatchSettingFrom()
        {
            InitializeComponent();
            Localization();
        }
        private void Localization()
        {
            String strSectionName = GVAR.g_ARPlugin.GetSectionName();
            this.TitleText = LocalizationRecourceManager.GetString(strSectionName, "OVRARPlugin_MatchSettingForm_titleText");
            this.labX_EndCount.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRARPlugin_MatchSettingForm_labX_EndCount");
            this.labX_ArrowCount.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRARPlugin_MatchSettingForm_labX_ArrowCount");
            this.btnX_OK.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRARPlugin_MatchSettingForm_btnX_OK");
            this.btnX_Cancel.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRARPlugin_MatchSettingForm_btnX_Cancel");
        }
        private void MatchSettingFrom_Load(object sender, EventArgs e)
        {
            if (CurMatchInfo.MatchID > 0)
            {
                this.txtX_EndCount.Text = CurMatchInfo.EndCount == 0 ? "" : CurMatchInfo.EndCount.ToString();
                this.txtX_ArrowCount.Text = CurMatchInfo.ArrowCount == 0 ? "" : CurMatchInfo.ArrowCount.ToString();
                if (CurMatchInfo.IsSetPoints == 1)
                    cbX_IsSetPoints.Checked = false;
                else
                    cbX_IsSetPoints.Checked = true;
                this.txtX_WinPoints.Text = CurMatchInfo.WinPoints == 0 ? "" : CurMatchInfo.WinPoints.ToString();
                InitComboBoxDistince();
                InitComboBoxContext(GVAR.g_ManageDB.GetDisplnID(GVAR.g_strDisplnCode), GVAR.g_strLang);
                for (int i = 0; i < cbbX_ComRule.Items.Count; i++)
                {
                    if (((DataRowView)cbbX_ComRule.Items[i])["F_CompetitionRuleID"].ToString() == CurMatchInfo.CurMatchRuleID.ToString())
                    {
                        cbbX_ComRule.SelectedIndex = i;
                    }
                }

            }
        }

        private void InitComboBoxDistince()
        {
            cbX_Distince.Items.Clear();
            cbX_Distince.Items.Add(new ComboBoxItem("", "1"));
            cbX_Distince.Items.Add(new ComboBoxItem("", "2"));
            cbX_Distince.Items.Add(new ComboBoxItem("", "3"));
            cbX_Distince.Items.Add(new ComboBoxItem("", "4"));
            cbX_Distince.SelectedIndex = 0;
            for (int i = 0; i < cbX_Distince.Items.Count; i++)
            {
                if (((ComboBoxItem)cbX_Distince.Items[i]).ToString() == CurMatchInfo.Distince.ToString())
                {
                    cbX_Distince.SelectedIndex = i;
                }
            }
        }
        private void btnX_OK_Click(object sender, EventArgs e)
        {
            CurMatchInfo.EndCount = ARFunctions.ConvertToIntFromString(this.txtX_EndCount.Text);
            CurMatchInfo.ArrowCount = ARFunctions.ConvertToIntFromString(this.txtX_ArrowCount.Text);
            CurMatchInfo.IsSetPoints = cbX_IsSetPoints.Checked ? 0 : 1;
            CurMatchInfo.WinPoints = ARFunctions.ConvertToIntFromString(this.txtX_WinPoints.Text);
            CurMatchInfo.Distince = ARFunctions.ConvertToIntFromObject(((ComboBoxItem)cbX_Distince.SelectedItem).ToString());
            CurMatchInfo.CurMatchRuleID = ARFunctions.ConvertToIntFromObject(cbbX_ComRule.SelectedValue);
            bool bReturn = GVAR.g_ManageDB.UpdateMatchSettings(CurMatchInfo.MatchID, CurMatchInfo.EndCount, CurMatchInfo.ArrowCount,CurMatchInfo.IsSetPoints,
                CurMatchInfo.WinPoints,CurMatchInfo.Distince,CurMatchInfo.CurMatchRuleID,-1);
            if(bReturn)
            this.DialogResult = DialogResult.OK;
            else 
            this.DialogResult = DialogResult.No;
            this.Close();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        private void InitComboBoxContext(Int32 iDisciplineID, String strLanguageCode)
        {
            try
            {
                System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();

                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_GetCompetitionRuleList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iDisciplineID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
                {
                    GVAR.g_adoDataBase.DBConnect.Open();
                }

                m_tbCompetitionRule.Clear();
                oneSqlCommand.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = oneSqlCommand;

                m_tbCompetitionRule.Clear();
                da.Fill(m_tbCompetitionRule);

                cbbX_ComRule.DisplayMember = "F_CompetitionLongName";
                cbbX_ComRule.ValueMember = "F_CompetitionRuleID";
                cbbX_ComRule.DataSource = m_tbCompetitionRule;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void btxX_Add_Click(object sender, EventArgs e)
        {
            int nEndCount = ARFunctions.ConvertToIntFromString(this.txtX_SEnds.Text);
            int nArrowCount = ARFunctions.ConvertToIntFromString(this.txtX_SArrows.Text);
            if (nEndCount > 0 && nArrowCount > 0)
            {
                int nReturn = GVAR.g_ManageDB.AddMatchSplits(CurMatchInfo.MatchID, nEndCount, nArrowCount, 1, 2);
                if (nReturn == 1)
                    this.DialogResult = DialogResult.Yes;
                else
                    this.DialogResult = DialogResult.No;
                this.Close();
            }
        }
    }
}
