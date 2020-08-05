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
    public partial class MatchInfoForm : UIForm
    {
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


        private int m_iOperateType;//0表示未知，1表示添加，2表示修改，其余不处理
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

        private OVRDrawArrangeModule m_Module;
        public OVRDrawArrangeModule Module
        {
            get { return this.m_Module; }
            set { this.m_Module = value; }
        }


        private string m_strSectionName = "OVRDrawArrange";

        private DataTable m_tbStatus = new DataTable();

        public MatchInfoForm()
        {
            InitializeComponent();
            Localization();
        }

        protected override void OnShown(EventArgs e)
        {
            base.OnShown(e);

            TextOrder.Text = "0";
            TextMatchNum.Text = "0";
            TextCompetitorNum.Text = "2";
            TextType.Text = "0";
            textHasMedal.Text = "0";

            IntiStatusCmb(m_strLanguageCode);

            switch (m_iOperateType)
            {
                case 1:
                    CmbLanguage.Enabled = false;
                    CmbStatus.Enabled = false;
                    break;
                case 2:
                    InitMatchById(m_iMatchID, m_strLanguageCode);
                    GetMatchExtraDataFromDB();
                    TextCompetitorNum.Enabled = false;
                    CmbLanguage.Enabled = false;
                    break;
                default:
                    break;
            }

            OVRDataBaseUtils.InitLanguageCombBox(CmbLanguage, m_DatabaseConnection);
            CmbLanguage.SelectedItem = m_strLanguageCode;
        }

        private void InitMatchById(Int32 iMatchID, String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetMatchInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);

                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    if (sdr.Read())
                    {
                        TextCode.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_MatchCode");
                        TextOrder.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_Order");
                        TextMatchNum.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_MatchNum");
                        textHasMedal.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_MatchHasMedal");

                        TextLongName.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_MatchLongName");
                        TextShortName.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_MatchShortName");
                        TextComment.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_MatchComment");
                        TextComment2.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "MatchComment2");

                        TextCompetitorNum.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "MatchCompetitorNum");
                        CmbStatus.SelectedValue = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_MatchStatusID");
                    }
                }
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            switch (m_iOperateType)
            {
                case 1:
                    if (!AddMatch())
                    {

                        return;
                    }
                    break;

                case 2:
                    if (!EditMatch())
                    {
                        return;
                    }
                    break;
                default:
                    break;
            }
            UpdateMatchExtraData();//由于是扩展的方法，因此没有加入到Add Match中，避免存储过程不更新导致失败
            this.DialogResult = DialogResult.OK;
        }

        private void btnCancle_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
        }

        private bool AddMatch()
        {
            bool bResult = false;
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_AddMatch_for_Schedule";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@MatchStatusID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@VenueID", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@CourtID", SqlDbType.NVarChar, 10,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@WeatherID", SqlDbType.NVarChar, 10,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                            "@SessionID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameter7 = new SqlParameter(
                            "@MatchDate", SqlDbType.NVarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter7);

                SqlParameter cmdParameter8 = new SqlParameter(
                            "@StartTime", SqlDbType.NVarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter8);

                SqlParameter cmdParameter9 = new SqlParameter(
                            "@EndTime", SqlDbType.NVarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter9);

                SqlParameter cmdParameter10 = new SqlParameter(
                             "@SpendTime", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameter10);

                SqlParameter cmdParameter11 = new SqlParameter(
                             "@Order", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextOrder.Text);
                oneSqlCommand.Parameters.Add(cmdParameter11);

                SqlParameter cmdParameter12 = new SqlParameter(
                             "@MatchNum", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextMatchNum.Text);
                oneSqlCommand.Parameters.Add(cmdParameter12);

                SqlParameter cmdParameter20 = new SqlParameter(
                            "@Code", SqlDbType.NVarChar, 20,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, TextCode.Text);
                oneSqlCommand.Parameters.Add(cmdParameter20);

                SqlParameter cmdParameter13 = new SqlParameter(
                             "@MatchType", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextType.Text);
                oneSqlCommand.Parameters.Add(cmdParameter13);

                SqlParameter cmdParameter21 = new SqlParameter(
                             "@HasMedal", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, ConvertStrToInt(textHasMedal.Text));
                oneSqlCommand.Parameters.Add(cmdParameter21);

                SqlParameter cmdParameter14 = new SqlParameter(
                             "@CompetitorNum", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextCompetitorNum.Text);
                oneSqlCommand.Parameters.Add(cmdParameter14);

                SqlParameter cmdParameter15 = new SqlParameter(
                             "@MatchInfo", SqlDbType.NVarChar, 50,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter15);

                SqlParameter cmdParameter16 = new SqlParameter(
                             "@languageCode", SqlDbType.Char, 3,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, m_strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter16);

                SqlParameter cmdParameter17 = new SqlParameter(
                             "@MatchLongName", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextLongName.Text);
                oneSqlCommand.Parameters.Add(cmdParameter17);

                SqlParameter cmdParameter18 = new SqlParameter(
                             "@MatchShortName", SqlDbType.NVarChar, 50,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextShortName.Text);
                oneSqlCommand.Parameters.Add(cmdParameter18);

                SqlParameter cmdParameter19 = new SqlParameter(
                             "@MatchComment", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextComment.Text);
                oneSqlCommand.Parameters.Add(cmdParameter19);

                SqlParameter cmdParameter22 = new SqlParameter(
                           "@MatchComment2", SqlDbType.NVarChar, 100,
                           ParameterDirection.Input, true, 0, 0, "",
                           DataRowVersion.Current, TextComment2.Text);
                oneSqlCommand.Parameters.Add(cmdParameter22);

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
                    m_iMatchID = iOperateResult;
                    switch (iOperateResult)
                    {
                        case 0:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgAddMatch1"));
                            bResult = false;
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgAddMatch2"));
                            bResult = false;
                            break;
                        case -2:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgAddMatch3"));
                            bResult = false;
                            break;
                        default://其余的需要为添加成功！
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

        private void UpdateMatchExtraData()
        {
            string strExData1 = txtMatchDateEx1.Text;
            string strExData2 = txtMatchDateEx2.Text;
            if ( strExData1 != "")
            {
                strExData1 = "\'" + strExData1 + "\'";
            }
            else
            {
                strExData1 = "NULL";
            }

            if (strExData2.Trim() != "")
            {
                strExData2 = strExData2.Trim();
                strExData2 = "\'" + strExData2 + "\'";
            }
            else
            {
                strExData2 = "NULL";
            }
            SqlCommand sqlCmd = m_DatabaseConnection.CreateCommand();
            sqlCmd.CommandText = string.Format("UPDATE TS_Match SET F_MatchComment1 = {0}, F_MatchComment2 = {1} WHERE F_MatchID = {2}", strExData1, strExData2, m_iMatchID);
            try
            {
                sqlCmd.ExecuteNonQuery();
            }
            catch (System.Exception ex)
            {
            	DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void GetMatchExtraDataFromDB()
        {
            //2才是修改，1为新增
            if (m_iOperateType != 2 )
            {
                return;
            }
           
            SqlCommand sqlCmd = m_DatabaseConnection.CreateCommand();
            sqlCmd.CommandText = string.Format("SELECT F_MatchComment1, F_MatchComment2 FROM TS_Match WHERE F_MatchID = {0}",  m_iMatchID);
            SqlDataReader sr = null;
            try
            {
                sr = sqlCmd.ExecuteReader();
                if ( sr.Read())
                {
                    txtMatchDateEx1.Text = sr[0] == DBNull.Value?"":(string)sr[0];
                    txtMatchDateEx2.Text = sr[1] == DBNull.Value ? "" : (string)sr[1];
                }
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            finally
            {
                if ( sr != null )
                {
                    sr.Close();
                }
            }
        }


        private bool EditMatch()
        {
            bool bResult = false;

            Int32 iChangeStatusResult = 0;

            iChangeStatusResult = OVRDataBaseUtils.ChangeMatchStatus(m_iMatchID, ConvertStrToInt(CmbStatus.SelectedValue.ToString()), m_DatabaseConnection, m_Module);
            if (iChangeStatusResult != 1)
            {
                switch (iChangeStatusResult)
                {
                    case 1://修改成功!
                        break;
                    case -1:
                        DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgEditMatchStatus2"));
                        break;
                    default://其余的需要为修改失败!
                        DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgEditMatchStatus1"));
                        break;
                }
                return bResult;
            }

            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "proc_EditMatch";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter0);

                SqlParameter cmdParameter7 = new SqlParameter(
                            "@Code", SqlDbType.NVarChar, 20,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, TextCode.Text);
                oneSqlCommand.Parameters.Add(cmdParameter7);

                SqlParameter cmdParameter8 = new SqlParameter(
                            "@Order", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, TextOrder.Text);
                oneSqlCommand.Parameters.Add(cmdParameter8);

                SqlParameter cmdParameter12 = new SqlParameter(
                             "@MatchNum", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextMatchNum.Text);
                oneSqlCommand.Parameters.Add(cmdParameter12);

                SqlParameter cmdParameter13 = new SqlParameter(
                             "@HasMedal", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, ConvertStrToInt(textHasMedal.Text));
                oneSqlCommand.Parameters.Add(cmdParameter13);

                SqlParameter cmdParameter14 = new SqlParameter(
                             "@languageCode", SqlDbType.Char, 3,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, m_strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter14);

                SqlParameter cmdParameter17 = new SqlParameter(
                             "@MatchLongName", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextLongName.Text);
                oneSqlCommand.Parameters.Add(cmdParameter17);

                SqlParameter cmdParameter18 = new SqlParameter(
                             "@MatchShortName", SqlDbType.NVarChar, 50,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextShortName.Text);
                oneSqlCommand.Parameters.Add(cmdParameter18);

                SqlParameter cmdParameter19 = new SqlParameter(
                             "@MatchComment", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextComment.Text);
                oneSqlCommand.Parameters.Add(cmdParameter19);

                SqlParameter cmdParameter20 = new SqlParameter(
                             "@MatchComment2", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextComment2.Text);
                oneSqlCommand.Parameters.Add(cmdParameter20);

                SqlParameter cmdParameter21 = new SqlParameter(
                            "@StatusID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, ConvertStrToInt(CmbStatus.SelectedValue.ToString()));
                oneSqlCommand.Parameters.Add(cmdParameter21);


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
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgEditMatch1"));
                            bResult = false;
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgEditMatch2"));
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
            this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmMatchInfo");
            this.btnOK.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnOK");
            this.btnCancle.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnCancle");
            this.lbMatchCode.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMatchCode");
            this.lbMatchOrder.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMatchOrder");
            this.lbMatchNum.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMatchNum");
            this.lbCompetitorsNum.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbCompetitorsNum");
            this.lbHasMedal.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbHasMedal");
            this.lbMatchType.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMatchType");
            this.lbLanguage.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbLanguage");
            this.lbMatchLongName.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMatchLongName");
            this.lbMatchShortName.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMatchShortName");
            this.lbMatchComment.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMatchComment");
            this.lbMatchComment2.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMatchComment2");
            this.lbMatchStatus.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMatchStatus");
        }

        private void IntiStatusCmb(String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetStatusList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                SqlDataReader sdr1 = oneSqlCommand.ExecuteReader();
                m_tbStatus.Clear();
                m_tbStatus.Load(sdr1);
                CmbStatus.DisplayMember = "F_StatusLongName";
                CmbStatus.ValueMember = "F_StatusID";
                CmbStatus.DataSource = m_tbStatus;
                sdr1.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void txtMatchDateEx1_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar < (int)Keys.D0 || (int)e.KeyChar > (int)Keys.D9)
            {
                if (e.KeyChar == (int)Keys.Back || e.KeyChar == (int)Keys.Right || e.KeyChar == (int)Keys.Left)
                {
                    return;
                }
                e.Handled = true;
            }
        }

    }
}