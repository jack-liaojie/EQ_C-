using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using DevComponents.DotNetBar;

using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    public partial class SetMatchesRuleForm : UIForm
    {
        private int m_iNodeType;
        public int NodeType
        {
            get { return this.m_iNodeType; }
            set { this.m_iNodeType = value; }
        }

        private int m_iDisciplineID;
        public int DisciplineID
        {
            get { return this.m_iDisciplineID; }
            set { this.m_iDisciplineID = value; }
        }

        private int m_iEventID;
        public int EventID
        {
            get { return this.m_iEventID; }
            set { this.m_iEventID = value; }
        }

        private int m_iPhaseID;
        public int PhaseID
        {
            get { return this.m_iPhaseID; }
            set { this.m_iPhaseID = value; }
        }

        private int m_iMatchID;
        public int MatchID
        {
            get { return this.m_iMatchID; }
            set { this.m_iMatchID = value; }
        }

        private string m_strLanguageCode;
        public string LanguageCode
        {
            get { return this.m_strLanguageCode; }
            set { this.m_strLanguageCode = value; }
        }

        private SqlConnection m_DatabaseConnection;
        public SqlConnection DatabaseConnection
        {
            get { return this.m_DatabaseConnection; }
            set { this.m_DatabaseConnection = value; }
        }

        private string m_strSectionName = "OVRDrawArrange";
        private DataTable m_tbCompetitionRule = new DataTable();

        public SetMatchesRuleForm()
        {
            InitializeComponent();
        }

        protected override void OnShown(EventArgs e)
        {
            base.OnShown(e);

            Localization();
            IntiCompetitionRuleCmb(m_iDisciplineID, m_strLanguageCode, m_DatabaseConnection);
            InitMatchById(m_iNodeType, m_iEventID, m_iPhaseID, m_iMatchID);


        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            if (UpdateMatchesCompetitionRule(m_iNodeType, m_iEventID, m_iPhaseID, m_iMatchID, m_DatabaseConnection))
            {
                this.DialogResult = DialogResult.OK;
            }
        }

        private void btnCancle_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
        }

        private void IntiCompetitionRuleCmb(Int32 iDisciplineID, String strLanguageCode, SqlConnection DataBaseConnection)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DatabaseConnection;
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

                if (DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    DatabaseConnection.Open();
                }

                m_tbCompetitionRule.Clear();
                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                m_tbCompetitionRule.Load(sdr);
                sdr.Close();

                CmbCompetitionRule.DisplayMember = "F_CompetitionLongName";
                CmbCompetitionRule.ValueMember = "F_CompetitionRuleID";
                CmbCompetitionRule.DataSource = m_tbCompetitionRule;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private bool UpdateMatchesCompetitionRule(Int32 iNodeType, Int32 iEventID, Int32 iPhaseID, Int32 iMatchID, SqlConnection DataBaseConnection)
        {
            bool bResult = false;
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_UpdateMatchesCompetitionRule";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@NodeType", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iNodeType);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iEventID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@CompetitionRuleID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, ConvertStrToInt(CmbCompetitionRule.SelectedValue.ToString()));
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    switch (iOperateResult)
                    {
                        case 0:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdateMatchesCompetitionRule1"));
                            bResult = false;
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdateMatchesCompetitionRule2"));
                            bResult = false;
                            break;
                        case -2:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdateMatchesCompetitionRule3"));
                            bResult = false;
                            break;
                        default://其余的需要为修改成功!
                            bResult = true;
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }

        private void InitMatchById(Int32 iNodeType, Int32 iEventID, Int32 iPhaseID, Int32 iMatchID)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetMatchCompetitionRuleInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;


                SqlParameter cmdParameter1 = new SqlParameter(
                            "@NodeType", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iNodeType);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iEventID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    if (sdr.Read())
                    {
                        CmbCompetitionRule.SelectedValue = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_CompetitionRuleID");
                    }
                }
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
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

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmSetMatchesRule");
            this.lbCompetitionRule.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbCompetitionRule");
        }
    }
}