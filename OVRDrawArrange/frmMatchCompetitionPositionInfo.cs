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
    public partial class MatchCompetitionPositionInfo : UIForm
    {
        public ArrayList m_aryMatchCompetitor = new ArrayList();
        public int m_iCurAryIndex;

        public OVRDrawArrangeForm m_ParentFrm;
        UpdatePosGridDelegate dgUpdatePosGridSel;

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

        private bool m_bEditCompetitionPosition = false;
        private string m_strSectionName = "OVRDrawArrange";
        private DataTable m_tbCompetitors = new DataTable();
        private DataTable m_tbPhases_Start = new DataTable();
        private DataTable m_tbPhases_Source = new DataTable();
        private DataTable m_tbPhases_SourceForMatch = new DataTable();
        private DataTable m_tbPhases_SourceForHistoryMatch = new DataTable();

        private DataTable m_tbSourceMatch = new DataTable();
        private DataTable m_tbHistoryMatch = new DataTable();
        
        public MatchCompetitionPositionInfo()
        {
            InitializeComponent();
            Localization();
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmMatchCompetitionPositionInfo");
            this.lbLanguage.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbLanguage");
            this.lbMatchName.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMatchName");
            this.lbPositionDes1.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPositionDes1");
            this.lbPositionDes2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPositionDes2");
            this.lbCompetitorName.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbCompetitorName");
            this.LbPositionSourceDes.Text = LocalizationRecourceManager.GetString(m_strSectionName, "LbPositionSourceDes");
            this.lbStartPhase.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbStartPhase");
            this.lbPhasePosition.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPhasePosition");

            this.RadioFromPhasePosition.Text = LocalizationRecourceManager.GetString(m_strSectionName, "RadioFromPhasePosition");
            this.RadioFromPhaseRank.Text = LocalizationRecourceManager.GetString(m_strSectionName, "RadioFromPhaseRank");
            this.RadioFromMatchRank.Text = LocalizationRecourceManager.GetString(m_strSectionName, "RadioFromMatchRank");
            this.RadioFromMatchHistory.Text = LocalizationRecourceManager.GetString(m_strSectionName, "RadioFromMatchHistory");

            this.lblSourcePhase.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSourcePhase");
            this.lbPhaseRank.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPhaseRank");
            this.lblSourcePhaseforMatch.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSourcePhaseforMatch");
            this.lbSourceMatch.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSourceMatch");
            this.lbMatchRank.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMatchRank");
            this.lbSourcePhaseforHistoryMatch.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSourcePhaseforHistoryMatch");
            this.lbHistoryMatch.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbHistoryMatch");
            this.lbHistoryMatchRank.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbHistoryMatchRank");
            this.lbHistoryLevel.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbHistoryLevel");

            this.lbSourceProgress.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbSourceProgress");
            this.lbProgress.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbProgress"); 
        }

        private void MatchCompetitionPositionInfo_Load(object sender, EventArgs e)
        {
            InitForm();

            dgUpdatePosGridSel = m_ParentFrm.UpdatePosGridSel;
        }

        private void MatchCompetitionPositionInfo_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (m_bEditCompetitionPosition)
                this.DialogResult = DialogResult.OK;
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            EditCompetitionPosition();
            this.Close();
        }

        private void btnCancle_Click(object sender, EventArgs e)
        {
           this.Close();
        }

        private void RadioFromPhasePosition_CheckedChanged(object sender, EventArgs e)
        {
            m_iPositionSourceType = 1;
            IntiSourceControls(m_iPositionSourceType);
        }

        private void RadioFromPhaseRank_CheckedChanged(object sender, EventArgs e)
        {
            m_iPositionSourceType = 2;
            IntiSourceControls(m_iPositionSourceType);
        }

        private void RadioFromMatchRank_CheckedChanged(object sender, EventArgs e)
        {
            m_iPositionSourceType = 3;
            IntiSourceControls(m_iPositionSourceType);
        }

        private void RadioFromMatchHistory_CheckedChanged(object sender, EventArgs e)
        {
            m_iPositionSourceType = 4;
            IntiSourceControls(m_iPositionSourceType);
        }

        private void CmbSourcePhaseForMatch_SelectedIndexChanged(object sender, EventArgs e)
        {
            //CmbHistoryMatch.DataSource = null;
            //CmbHistoryMatch.Items.Clear();
            //CmbHistoryMatch.SelectedIndex = -1;
            //IntiMatchCmb(ConvertStrToInt(CmbSourcePhaseForMatch.SelectedValue.ToString()), 0, m_strLanguageCode, m_DatabaseConnection, 3);
        }

        private void CmbSourcePhaseforHistoryMatch_SelectedIndexChanged(object sender, EventArgs e)
        {
            //IntiMatchCmb(ConvertStrToInt(CmbSourcePhaseforHistoryMatch.SelectedValue.ToString()), 0, m_strLanguageCode, m_DatabaseConnection, 4);
        }

        private void btnPRE_Click(object sender, EventArgs e)
        {
            if (!EditCompetitionPosition())
            {
                return;
            }
            if (null != dgUpdatePosGridSel)
            {
                dgUpdatePosGridSel(false);
            }
            m_iCurAryIndex = m_iCurAryIndex -1;

            SAxMatchInfo stTempMatchInfo;
            stTempMatchInfo = (SAxMatchInfo)m_aryMatchCompetitor[m_iCurAryIndex];

            m_iMatchID = stTempMatchInfo.iMatchID;
            m_iCompetitionPosition = stTempMatchInfo.iCompetitorPosition;
            InitForm();
        }

        private void btnNEXT_Click(object sender, EventArgs e)
        {
            if( !EditCompetitionPosition())
            {
                return;
            }
            if (null != dgUpdatePosGridSel)
            {
                dgUpdatePosGridSel(true);
            }
            m_iCurAryIndex = m_iCurAryIndex +1;

            SAxMatchInfo stTempMatchInfo;
            stTempMatchInfo = (SAxMatchInfo)m_aryMatchCompetitor[m_iCurAryIndex];

            m_iMatchID = stTempMatchInfo.iMatchID;
            m_iCompetitionPosition = stTempMatchInfo.iCompetitorPosition;
            InitForm();
        }

        private void InitForm()
        {
            IntiCompetitorCmb(CmbCompetitor, m_iMatchID, m_iCompetitionPosition, m_strLanguageCode, m_DatabaseConnection);
            InitPhaseCombBox(m_iMatchID, m_strLanguageCode);
            IntiMatchCmb(0, m_iMatchID, m_strLanguageCode, m_DatabaseConnection);

            InitCompetitionPositionById(m_iMatchID, m_iCompetitionPosition, m_strLanguageCode);
            TextMatchName.Enabled = false;

            CmbLanguage.Enabled = false;
            ComboBoxItem item = new ComboBoxItem();
            item.Text = m_strLanguageCode;
            CmbLanguage.Items.Add(item);
            CmbLanguage.SelectedValue = m_strLanguageCode;
            //default to check the radio button
            //modified by zj091209
            if (RadioFromPhasePosition.Checked == false && RadioFromPhaseRank.Checked == false && RadioFromMatchRank.Checked == false && RadioFromMatchHistory.Checked == false)
            {
                m_iPositionSourceType = 0;
                IntiSourceControls(m_iPositionSourceType);
            }
            //end

            //Enable the next or previous btn
            //Add by Liyan  20091209
            if (m_iCurAryIndex == 0)
            {
                btnPRE.Enabled = false;
                btnNEXT.Enabled = true;
            }
            else if (m_iCurAryIndex == m_aryMatchCompetitor.Count - 1)
            {
                btnPRE.Enabled = true;
                btnNEXT.Enabled = false;
            }
            else
            {
                btnPRE.Enabled = true;
                btnNEXT.Enabled = true;
            }
        }

        private void IntiCompetitorCmb(UIComboBox CmbCompetitor, Int32 iMatchID, Int32 iCompetitionPosition, String strLanguageCode, SqlConnection DataBaseConnection)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetMatchCompetitorsList";
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

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@Position", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                              "@SelEventID", SqlDbType.Int, 4,
                              ParameterDirection.Input, true, 0, 0, "",
                              DataRowVersion.Current, m_iSelPhaseTreeEventID);
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameter7 = new SqlParameter(
                            "@SelPhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iSelPhaseTreePhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter7);

                SqlParameter cmdParameter8 = new SqlParameter(
                            "@SelMatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iSelPhaseTreeMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter8);

                SqlParameter cmdParameter9 = new SqlParameter(
                            "@SelNodeType", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iSelPhaseTreeNodeType);
                oneSqlCommand.Parameters.Add(cmdParameter9);

                if (DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    DatabaseConnection.Open();
                }

                m_tbCompetitors.Clear();
                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                m_tbCompetitors.Load(sdr);
                sdr.Close();

                CmbCompetitor.DisplayMember = "F_LongName";
                CmbCompetitor.ValueMember = "F_RegisterID";
                CmbCompetitor.DataSource = m_tbCompetitors;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
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

                SqlDataReader sdr2 = oneSqlCommand.ExecuteReader();
                m_tbHistoryMatch.Clear();
                m_tbHistoryMatch.Load(sdr2);
                CmbHistoryMatch.DisplayMember = "F_MatchLongName";
                CmbHistoryMatch.ValueMember = "F_MatchID";
                CmbHistoryMatch.DataSource = m_tbHistoryMatch;

                sdr1.Close();
                sdr2.Close();
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

                SqlDataReader sdr2 = oneSqlCommand.ExecuteReader();
                m_tbPhases_Source.Clear();
                m_tbPhases_Source.Load(sdr2);
                CmbSourcePhase.DisplayMember = "F_LongName";
                CmbSourcePhase.ValueMember = "F_ID";
                CmbSourcePhase.DataSource = m_tbPhases_Source;

                SqlDataReader sdr3 = oneSqlCommand.ExecuteReader();
                m_tbPhases_SourceForMatch.Clear();
                m_tbPhases_SourceForMatch.Load(sdr3);
                CmbSourcePhaseForMatch.DisplayMember = "F_LongName";
                CmbSourcePhaseForMatch.ValueMember = "F_ID";
                CmbSourcePhaseForMatch.DataSource = m_tbPhases_SourceForMatch;

                SqlDataReader sdr4 = oneSqlCommand.ExecuteReader();
                m_tbPhases_SourceForHistoryMatch.Clear();
                m_tbPhases_SourceForHistoryMatch.Load(sdr4);
                CmbSourcePhaseforHistoryMatch.DisplayMember = "F_LongName";
                CmbSourcePhaseforHistoryMatch.ValueMember = "F_ID";
                CmbSourcePhaseforHistoryMatch.DataSource = m_tbPhases_SourceForHistoryMatch;
     
                sdr1.Close();
                sdr2.Close();
                sdr3.Close();
                sdr4.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void InitCompetitionPositionById(Int32 iMatchID, Int32 iCompetitionPosition, String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetCompetitionPositionInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionPosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    if (sdr.Read())
                    {
                        TextMatchName.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_MatchLongName");
                        TextPositionDes1.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_CompetitionPositionDes1");
                        TextPositionDes2.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_CompetitionPositionDes2");
                        TextPositionSourceDes.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_CompetitorSourceDes");

                        CmbCompetitor.SelectedValue = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_RegisterID");

                        CmbStartPhase.SelectedValue = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_StartPhaseID");
                        TextPhasePosition.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_StartPhasePosition");

                        CmbSourcePhase.SelectedValue = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_SourcePhaseID");
                        TextPhaseRank.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_SourcePhaseRank");

                        CmbSourcePhaseForMatch.SelectedValue = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_SourcePhaseID");
                        CmbSourceMatch.SelectedValue = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_SourceMatchID");
                        TextMatchRank.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_SourceMatchRank");

                        CmbSourcePhaseforHistoryMatch.SelectedValue = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_SourcePhaseID");
                        CmbHistoryMatch.SelectedValue = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_HistoryMatchID");
                        TextHistoryMatchRank.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_HistoryMatchRank");
                        TextHistoryLevel.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_HistoryLevel");

                        TextSourceProgress.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_SouceProgressDes");
                        TextProgress.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_ProgressDes");

                        m_iPositionSourceType = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "PositionSourceType");
                        //IntiSourceControls(m_iPositionSourceType);
                        switch (m_iPositionSourceType)
                        {
                            case 1:
                                RadioFromPhasePosition.Checked = true;
                                break;
                            case 2:
                                RadioFromPhaseRank.Checked = true;
                                break;
                            case 3:
                                RadioFromMatchRank.Checked = true;
                                break;
                            case 4:
                                RadioFromMatchHistory.Checked = true;
                                break;
                            case 0:
                                RadioFromPhasePosition.Checked = false;
                                RadioFromPhaseRank.Checked = false;
                                RadioFromMatchRank.Checked = false;
                                RadioFromMatchHistory.Checked = false;
                                break;
                        }
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

        private void IntiSourceControls(int iSourceType)
        {
            switch (iSourceType)
            {
                case 1:
                    CmbStartPhase.Enabled = true;
                    TextPhasePosition.Enabled = true;

                    CmbSourcePhase.Enabled = false;
                    TextPhaseRank.Enabled = false;

                    CmbSourcePhaseForMatch.Enabled = false;
                    CmbSourceMatch.Enabled = false;
                    TextMatchRank.Enabled = false;

                    CmbSourcePhaseforHistoryMatch.Enabled = false;
                    CmbHistoryMatch.Enabled = false;
                    TextHistoryMatchRank.Enabled = false;
                    TextHistoryLevel.Enabled = false;
                    break;
                case 2:
                    CmbStartPhase.Enabled = false;
                    TextPhasePosition.Enabled = false;

                    CmbSourcePhase.Enabled = true;
                    TextPhaseRank.Enabled = true;

                    CmbSourcePhaseForMatch.Enabled = false;
                    CmbSourceMatch.Enabled = false;
                    TextMatchRank.Enabled = false;

                    CmbSourcePhaseforHistoryMatch.Enabled = false;
                    CmbHistoryMatch.Enabled = false;
                    TextHistoryMatchRank.Enabled = false;
                    TextHistoryLevel.Enabled = false;
                    break;
                case 3:
                    CmbStartPhase.Enabled = false;
                    TextPhasePosition.Enabled = false;

                    CmbSourcePhase.Enabled = false;
                    TextPhaseRank.Enabled = false;

                    CmbSourcePhaseForMatch.Enabled = true;
                    CmbSourceMatch.Enabled = true;
                    TextMatchRank.Enabled = true;

                    CmbSourcePhaseforHistoryMatch.Enabled = false;
                    CmbHistoryMatch.Enabled = false;
                    TextHistoryMatchRank.Enabled = false;
                    TextHistoryLevel.Enabled = false;
                    break;
                case 4:
                    CmbStartPhase.Enabled = false;
                    TextPhasePosition.Enabled = false;

                    CmbSourcePhase.Enabled = false;
                    TextPhaseRank.Enabled = false;

                    CmbSourcePhaseForMatch.Enabled = false;
                    CmbSourceMatch.Enabled = false;
                    TextMatchRank.Enabled = false;

                    CmbSourcePhaseforHistoryMatch.Enabled = true;
                    CmbHistoryMatch.Enabled = true;
                    TextHistoryMatchRank.Enabled = true;
                    TextHistoryLevel.Enabled = true;
                    break;
                default:
                    CmbStartPhase.Enabled = false;
                    TextPhasePosition.Enabled = false;

                    CmbSourcePhase.Enabled = false;
                    TextPhaseRank.Enabled = false;

                    CmbSourcePhaseForMatch.Enabled = false;
                    CmbSourceMatch.Enabled = false;
                    TextMatchRank.Enabled = false;

                    CmbSourcePhaseforHistoryMatch.Enabled = false;
                    CmbHistoryMatch.Enabled = false;
                    TextHistoryMatchRank.Enabled = false;
                    TextHistoryLevel.Enabled = false;
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
                else if (iSourceType == 4)
                {
                    SqlDataReader sdr2 = oneSqlCommand.ExecuteReader();
                    m_tbHistoryMatch.Clear();
                    m_tbHistoryMatch.Load(sdr2);
                    CmbHistoryMatch.DisplayMember = "F_MatchLongName";
                    CmbHistoryMatch.ValueMember = "F_MatchID";
                    CmbHistoryMatch.DataSource = m_tbHistoryMatch;
                    sdr2.Close();
                }


            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private bool EditCompetitionPosition()
        {
            bool bResult = false;
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "proc_EditCompetitionPosition";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter0);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionPosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@CompetitionPositionDes1", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, ConvertStrToInt(TextPositionDes1.Text));
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@CompetitionPositionDes2", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, ConvertStrToInt(TextPositionDes2.Text));
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, ConvertStrToInt(CmbCompetitor.SelectedValue.ToString()));
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                             "@PositionSourceDes", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextPositionSourceDes.Text);
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameter7 = new SqlParameter(
                             "@StartPhaseID", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, ConvertStrToInt(CmbStartPhase.SelectedValue.ToString()));
                oneSqlCommand.Parameters.Add(cmdParameter7);

                SqlParameter cmdParameter8 = new SqlParameter(
                            "@StartPhasePosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, ConvertStrToInt(TextPhasePosition.Text));
                oneSqlCommand.Parameters.Add(cmdParameter8);

                SqlParameter cmdParameter9 = new SqlParameter(
                             "@SourcePhaseID", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, ConvertStrToInt(CmbSourcePhase.SelectedValue.ToString()));
                oneSqlCommand.Parameters.Add(cmdParameter9);

                SqlParameter cmdParameter10 = new SqlParameter(
                            "@PhaseRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, ConvertStrToInt(TextPhaseRank.Text));
                oneSqlCommand.Parameters.Add(cmdParameter10);
                
                SqlParameter cmdParameter11 = new SqlParameter(
                             "@SourceMatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, ConvertStrToInt(CmbSourceMatch.SelectedValue.ToString()));
                oneSqlCommand.Parameters.Add(cmdParameter11);

                SqlParameter cmdParameter12 = new SqlParameter(
                             "@MatchRank", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, ConvertStrToInt(TextMatchRank.Text));
                oneSqlCommand.Parameters.Add(cmdParameter12);

                SqlParameter cmdParameter13 = new SqlParameter(
                             "@HistoryMatchID", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, ConvertStrToInt(CmbHistoryMatch.SelectedValue.ToString()));
                oneSqlCommand.Parameters.Add(cmdParameter13);

                SqlParameter cmdParameter14 = new SqlParameter(
                             "@HistoryMatchRank", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, ConvertStrToInt(TextHistoryMatchRank.Text));
                oneSqlCommand.Parameters.Add(cmdParameter14);

                SqlParameter cmdParameter15 = new SqlParameter(
                             "@HistoryLevel", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, ConvertStrToInt(TextHistoryLevel.Text));
                oneSqlCommand.Parameters.Add(cmdParameter15);

                SqlParameter cmdParameter16 = new SqlParameter(
                             "@languageCode", SqlDbType.Char, 3,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, m_strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter16);

                SqlParameter cmdParameter17 = new SqlParameter(
                             "@PositionSourceType", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, m_iPositionSourceType);
                oneSqlCommand.Parameters.Add(cmdParameter17);

                SqlParameter cmdParameter18 = new SqlParameter(
                           "@SouceProgressDes", SqlDbType.NVarChar, 100,
                           ParameterDirection.Input, true, 0, 0, "",
                           DataRowVersion.Current, TextSourceProgress.Text.ToString());
                oneSqlCommand.Parameters.Add(cmdParameter18);

                SqlParameter cmdParameter19 = new SqlParameter(
                           "@ProgressDes", SqlDbType.NVarChar, 100,
                           ParameterDirection.Input, true, 0, 0, "",
                           DataRowVersion.Current, TextProgress.Text.ToString());
                oneSqlCommand.Parameters.Add(cmdParameter19);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    switch (iOperateResult)
                    {
                        case 0:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgEditCompetitionPosition1"));
                            bResult = false;
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgEditCompetitionPosition2"));
                            bResult = false;
                            break;
                        default://其余的需要为修改成功!
                            if (m_Module != null)
                                m_Module.DataChangedNotify(OVRDataChangedType.emMatchCompetitor, -1, -1, -1, m_iMatchID, m_iCompetitionPosition, null);

                            m_bEditCompetitionPosition = true;
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

        private void MatchCompetitionPositionInfo_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Right)
            {
                if(btnNEXT.Enabled)
                {
                    btnNEXT_Click(null, null);
                }
            }
            else if(e.KeyCode == Keys.Left)
            {
                if(btnPRE.Enabled)
                {
                    btnPRE_Click(null, null);
                }
            }
        }

    }
}