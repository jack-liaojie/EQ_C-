using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

namespace OVRDVPlugin
{
    public partial class frmMatchCompetitionRule : DevComponents.DotNetBar.Office2007Form
    {
        public Int32 m_iCurMatchID;
        public Int32 m_iSportID;
        public Int32 m_iDisciplineID;
        public String m_strLanguageCode = "ENG";
        public Int32 m_iCurMatchRuleID;

        private DataTable m_tbRules = new DataTable();

        public frmMatchCompetitionRule()
        {
            InitializeComponent();
        }

        private void frmMatchCompetitionRule_Load(object sender, EventArgs e)
        {
            InitMatchInfo();
            InitCmbRules();
            cmbCompetitionRules.SelectedValue = m_iCurMatchRuleID;
        }

        private void InitMatchInfo()
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetMatchInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iCurMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguageCode);

                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    if (sdr.Read())
                    {
                        lb_MatchDes.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "MatchDes");
                        m_iDisciplineID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_DisciplineID");
                        m_iCurMatchRuleID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_CompetitionRuleID");
                    }
                }
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void InitCmbRules()
        {
            SqlConnection theDataBaseCon;
            theDataBaseCon = DVCommon.g_DataBaseCon;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = theDataBaseCon;
                oneSqlCommand.CommandText = "Proc_DV_GetCompetitionRules";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iDisciplineID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguageCode);

                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (theDataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    theDataBaseCon.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                m_tbRules.Clear();
                m_tbRules.Load(sdr);

                cmbCompetitionRules.DisplayMember = "F_CompetitionLongName";
                cmbCompetitionRules.ValueMember = "F_CompetitionRuleID";
                cmbCompetitionRules.DataSource = m_tbRules;

                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void btnx_ApplySelRule_Click(object sender, EventArgs e)
        {
            string strMessage = LocalizationRecourceManager.GetString(DVCommon.g_strSectionName, "MsgApplySelRule1");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMessage, DVCommon.g_strSectionName, MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
            {
                return;
            }

            Int32 iMatchRuleID;
            if (cmbCompetitionRules.SelectedIndex == -1)
            {
                return;
            }
            iMatchRuleID = ConvertStrToInt(cmbCompetitionRules.SelectedValue.ToString());

            int iResult = DVCommon.g_DVDBManager.ApplySelRule(m_iCurMatchID, iMatchRuleID);
            switch (iResult)
            {
                case 1:
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(DVCommon.g_strSectionName, "MsgApplySelRule2"), DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                    //DataEntryChangeMatchRuleHandler.Invoke();
                    break;
                case -1:
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(DVCommon.g_strSectionName, "MsgApplySelRule3"), DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                    break;
                case -2:
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(DVCommon.g_strSectionName, "MsgApplySelRule4"), DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                    break;
                default:
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(DVCommon.g_strSectionName, "MsgApplySelRule5"), DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                    break;
            }
            InitMatchInfo();
            cmbCompetitionRules.SelectedValue = m_iCurMatchRuleID;

            DVCommon.g_DVDBManager.ExcuteJudgePoint_CreateMatchSplits(m_iCurMatchID, 1);

        }

        private Int32 ConvertStrToInt(String strValue)
        {
            Int32 iReturnValue = 0;
            if (strValue == "")
            {
                iReturnValue = 0;
            }
            else
            {
                iReturnValue = Convert.ToInt32(strValue);
            }
            return iReturnValue;
        }

        private void btnDelMatchResult_Click(object sender, EventArgs e)
        {
            string strMessage = "You are going to delete this match's all Result Info, Are you sure to do this?";
            string strCaption = "Dive List";
            MessageBoxButtons buttons = MessageBoxButtons.YesNo;
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMessage, strCaption, buttons, MessageBoxIcon.Question) == DialogResult.No)
            {
                return;
            }


            Int32 iResult = DVCommon.g_DVDBManager.ExcuteDV_DeleteAllMatchResultInfo(m_iCurMatchID);
            switch (iResult)
            {
                case 0:
                    DevComponents.DotNetBar.MessageBoxEx.Show("Delete this match's all Result Info Failed!", "", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    break;
                case 1:
                    DevComponents.DotNetBar.MessageBoxEx.Show("Delete this match's all Result Info Succeeded!", "", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    break;
                case -1:
                    DevComponents.DotNetBar.MessageBoxEx.Show("Delete this match's all Result Info Failed! Invalidate Parameters!", "", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    break;
                case -2:
                    DevComponents.DotNetBar.MessageBoxEx.Show("Delete this match's all Result Info Failed! This Match's Status doesn't allow you to do this Operate!", "", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    break;
                default:
                    break;
            }

        }


    }
}
