using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Collections;
using DevComponents.DotNetBar;
using DevComponents.DotNetBar.Controls;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    public partial class CompetitionSourceSetFrom : UIForm
    {
        private int m_iMatchID;
        public int MatchID
        {
            get { return this.m_iMatchID; }
            set { this.m_iMatchID = value; }
        }

        private int m_iCompetitionPosition;
        public int CompetitionPosition
        {
            get { return this.m_iCompetitionPosition; }
            set { this.m_iCompetitionPosition = value; }
        }

        private string m_strLanguageCode;
        public string LanguageCode
        {
            get { return this.m_strLanguageCode; }
            set { this.m_strLanguageCode = value; }
        }


        private Int32 m_iSelPhaseTreeEventID = -1;
        public Int32 iSelPhaseTreeEventID
        {
            set { this.m_iSelPhaseTreeEventID = value; }
        }

        private Int32 m_iSelPhaseTreePhaseID = -1;
        public Int32 iSelPhaseTreePhaseID
        {
            set { this.m_iSelPhaseTreePhaseID = value; }
        }

        private Int32 m_iSelPhaseTreeMatchID = -1;
        public Int32 iSelPhaseTreeMatchID
        {
            set { this.m_iSelPhaseTreeMatchID = value; }
        }

        private Int32 m_iSelPhaseTreeNodeType = -4;
        public Int32 iSelPhaseTreeNodeType
        {
            set { this.m_iSelPhaseTreeNodeType = value; }
        }


        private int m_iOperateType;//0表示未知，1表示Add Competition Position，2表示Edit Competition Position，其余不处理
        public int OperateType
        {
            get { return this.m_iOperateType; }
            set { this.m_iOperateType = value; }
        }

        private SqlConnection m_DatabaseConnection;
        public SqlConnection DatabaseConnection
        {
            get { return this.m_DatabaseConnection; }
            set { this.m_DatabaseConnection = value; }
        }

        private OVRModuleBase m_Module = null;
        public OVRModuleBase Module
        {
            get { return this.m_Module; }
            set { this.m_Module = value; }
        }

        private Int32 m_iPositionSourceType;//0表示未知，1表示PhasePosition，2表示PhaseRank，3表示MatchRank，4表示MatchHistory
        public int PositionSourceType
        {
            get { return this.m_iPositionSourceType; }
        }

        private Int32 m_iStartPhaseID;
        public int StartPhaseID
        {
            set { m_iStartPhaseID = value; }
            get { return this.m_iStartPhaseID; }
        }

        private Int32 m_iSourcePhaseID;
        public int SourcePhaseID
        {
            set { m_iSourcePhaseID = value; }
            get { return this.m_iSourcePhaseID; }
        }
        private Int32 m_iSourceMatchID;
        public int SourceMatchID
        {
            set { m_iSourceMatchID = value; }
            get { return this.m_iSourceMatchID; }
        }

        private Int32 m_iInputValue;
        public int InputValue
        {
            set { m_iInputValue = value; }
            get { return this.m_iInputValue; }
        }
        private Int32 m_iStep;
        public int Step
        {
            set { m_iStep = value; }
            get { return this.m_iStep; }
        }

        private string m_strSectionName = "OVRDrawArrange";
        private DataTable m_tbCompetitors = new DataTable();
        private DataTable m_tbPhases_Start = new DataTable();
        private DataTable m_tbPhases_Source = new DataTable();
        private DataTable m_tbPhases_SourceForMatch = new DataTable();
        private DataTable m_tbSourceMatch = new DataTable();

        public CompetitionSourceSetFrom()
        {
            InitializeComponent();
            Localization();

        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmMatchCompetitionSourceSet");

            this.RadioFromPhasePosition.Text = LocalizationRecourceManager.GetString(m_strSectionName, "RadioFromPhasePosition");
            this.RadioFromPhaseRank.Text = LocalizationRecourceManager.GetString(m_strSectionName, "RadioFromPhaseRank");
            this.RadioFromMatchRank.Text = LocalizationRecourceManager.GetString(m_strSectionName, "RadioFromMatchRank");

            this.lbStartPhase.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbStartPhase");
            this.lblSourcePhase.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSourcePhase");
            this.lbPhaseRank.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbStartPhaseRank");
            this.lblSourcePhaseforMatch.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSourcePhaseforMatch");
            this.lbSourceMatch.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSourceMatch");
            this.lbMatchRank.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbStartMatchRank");
            this.lbStartPos.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbStartPos");
            this.lbPositionStep.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbStep");
            this.lbPhaseStep.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbStep");
            this.lbMatchStep.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbStep");

        }

        private void CompetitionSourceSetFrom_Load(object sender, EventArgs e)
        {
            InitForm();
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            if (m_iPositionSourceType == 1)
            {
                m_iStartPhaseID = ConvertStrToInt(CmbStartPhase.SelectedValue.ToString());
                m_iStep = ConvertStrToInt(txtPositionStep.Text.ToString());
                m_iInputValue = ConvertStrToInt(TextPhasePosition.Text.ToString());
            }
            else if (m_iPositionSourceType == 2)
            {
                m_iSourcePhaseID = ConvertStrToInt(CmbSourcePhase.SelectedValue.ToString());
                m_iStep = ConvertStrToInt(txtPhaseStep.Text.ToString());
                m_iInputValue = ConvertStrToInt(TextPhaseRank.Text.ToString());
            }
            else if (m_iPositionSourceType == 3)
            {
                m_iSourcePhaseID = ConvertStrToInt(CmbSourcePhaseForMatch.SelectedValue.ToString());
                m_iSourceMatchID = ConvertStrToInt(CmbSourceMatch.SelectedValue.ToString());
                m_iStep = ConvertStrToInt(txtMatchStep.Text.ToString());
                m_iInputValue = ConvertStrToInt(TxtMatchRank.Text.ToString());
            }
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void btnCancle_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        private void RadioFromPhasePosition_Click(object sender, EventArgs e)
        {
            m_iPositionSourceType = 1;
            IntiSourceControls(m_iPositionSourceType);
        }

        private void RadioFromPhaseRank_Click(object sender, EventArgs e)
        {
            m_iPositionSourceType = 2;
            IntiSourceControls(m_iPositionSourceType);
        }

        private void RadioFromMatchRank_Click(object sender, EventArgs e)
        {
            m_iPositionSourceType = 3;
            IntiSourceControls(m_iPositionSourceType);
        }

        private void InitForm()
        {
            InitPhaseCombBox(m_iMatchID, m_strLanguageCode);
            IntiMatchCmb(0, m_iMatchID, m_strLanguageCode, m_DatabaseConnection);

            //default to check the radio button
            //modified by zj091209
            if (RadioFromPhasePosition.Checked == false && RadioFromPhaseRank.Checked == false && RadioFromMatchRank.Checked == false)
            {
                m_iPositionSourceType = 0;
                IntiSourceControls(m_iPositionSourceType);
            }
            //end
        }

        private void IntiMatchCmb(Int32 iPhaseID, Int32 iMatchID, String strLanguageCode, SqlConnection DataBaseConnection)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetMatchistByPhaseID";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                if (DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    DatabaseConnection.Open();
                }

                SqlDataReader sdr1 = oneSqlCommand.ExecuteReader();
                m_tbSourceMatch.Clear();
                m_tbSourceMatch.Load(sdr1);
                CmbSourceMatch.DisplayMember = "F_MatchLongName";
                CmbSourceMatch.ValueMember = "F_MatchID";
                CmbSourceMatch.DataSource = m_tbSourceMatch;
                CmbSourceMatch.SelectedIndex = -1;

                sdr1.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void InitPhaseCombBox(Int32 iMatchID, String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetMatchSourcePhases";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                if (DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    DatabaseConnection.Open();
                }

                SqlDataReader sdr1 = oneSqlCommand.ExecuteReader();
                m_tbPhases_Start.Clear();
                m_tbPhases_Start.Load(sdr1);
                CmbStartPhase.DisplayMember = "F_LongName";
                CmbStartPhase.ValueMember = "F_ID";
                CmbStartPhase.DataSource = m_tbPhases_Start;
                CmbStartPhase.SelectedIndex = -1;

                SqlDataReader sdr2 = oneSqlCommand.ExecuteReader();
                m_tbPhases_Source.Clear();
                m_tbPhases_Source.Load(sdr2);
                CmbSourcePhase.DisplayMember = "F_LongName";
                CmbSourcePhase.ValueMember = "F_ID";
                CmbSourcePhase.DataSource = m_tbPhases_Source;
                CmbSourcePhase.SelectedIndex = -1;

                SqlDataReader sdr3 = oneSqlCommand.ExecuteReader();
                m_tbPhases_SourceForMatch.Clear();
                m_tbPhases_SourceForMatch.Load(sdr3);
                CmbSourcePhaseForMatch.DisplayMember = "F_LongName";
                CmbSourcePhaseForMatch.ValueMember = "F_ID";
                CmbSourcePhaseForMatch.DataSource = m_tbPhases_SourceForMatch;
                CmbSourcePhaseForMatch.SelectedIndex = -1;

                sdr1.Close();
                sdr2.Close();
                sdr3.Close();
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

        private void IntiSourceControls(int iSourceType)
        {
            switch (iSourceType)
            {
                case 1:
                    CmbStartPhase.Enabled = true;
                    TextPhasePosition.Enabled = true;
                    txtPositionStep.Enabled = true;

                    CmbSourcePhase.Enabled = false;
                    TextPhaseRank.Enabled = false;
                    txtPhaseStep.Enabled = false;

                    CmbSourcePhaseForMatch.Enabled = false;
                    CmbSourceMatch.Enabled = false;
                    TxtMatchRank.Enabled = false;
                    txtMatchStep.Enabled = false;
                    break;
                case 2:
                    CmbStartPhase.Enabled = false;
                    TextPhasePosition.Enabled = false;
                    txtPositionStep.Enabled = false;

                    CmbSourcePhase.Enabled = true;
                    TextPhaseRank.Enabled = true;
                    txtPhaseStep.Enabled = true;

                    CmbSourcePhaseForMatch.Enabled = false;
                    CmbSourceMatch.Enabled = false;
                    TxtMatchRank.Enabled = false;
                    txtMatchStep.Enabled = false;
                    break;
                case 3:
                    CmbStartPhase.Enabled = false;
                    TextPhasePosition.Enabled = false;
                    txtPositionStep.Enabled = false;

                    CmbSourcePhase.Enabled = false;
                    TextPhaseRank.Enabled = false;
                    txtPhaseStep.Enabled = false;

                    CmbSourcePhaseForMatch.Enabled = true;
                    CmbSourceMatch.Enabled = true;
                    TxtMatchRank.Enabled = true;
                    txtMatchStep.Enabled = true;
                    break;
                default:
                    CmbStartPhase.Enabled = false;
                    TextPhasePosition.Enabled = false;
                    txtPositionStep.Enabled = false;

                    CmbSourcePhase.Enabled = false;
                    TextPhaseRank.Enabled = false;
                    txtPhaseStep.Enabled = false;

                    CmbSourcePhaseForMatch.Enabled = false;
                    CmbSourceMatch.Enabled = false;
                    TxtMatchRank.Enabled = false;
                    txtMatchStep.Enabled = false;
                    break;
            }
        }

        private void IntiMatchCmb(Int32 iPhaseID, Int32 iMatchID, String strLanguageCode, SqlConnection DataBaseConnection, Int32 iSourceType)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetMatchistByPhaseID";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                if (DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    DatabaseConnection.Open();
                }
                if (iSourceType == 3)
                {
                    SqlDataReader sdr1 = oneSqlCommand.ExecuteReader();
                    m_tbSourceMatch.Clear();
                    m_tbSourceMatch.Load(sdr1);
                    CmbSourceMatch.DisplayMember = "F_MatchLongName";
                    CmbSourceMatch.ValueMember = "F_MatchID";
                    CmbSourceMatch.DataSource = m_tbSourceMatch;
                    sdr1.Close();
                }
              
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }
    }
}