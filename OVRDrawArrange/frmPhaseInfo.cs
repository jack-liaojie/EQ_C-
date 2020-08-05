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
    public partial class PhaseInfoForm : UIForm
    {
        public Int32 m_iEventID { get; set; }
        public Int32 m_iPhaseID { get; set; }
        public String m_strLanguageCode { get; set; }
        public Int32 m_iOperateType { get; set; }//0表示未知，1表示添加，2表示修改，其余不处理
        public SqlConnection m_DatabaseConnection { get; set; }
        public Int32 m_iFatherPhaseID { get; set; }
        private string m_strSectionName = "OVRDrawArrange";

        private string m_strIniPhaseCode;
        private string m_strIniDateStart;
        private string m_strIniDateEnd;
        private string m_strIniOrder;
        private string m_strIniIsPool;
        private string m_strIniHasPool;
        private string m_strIniLongName;
        private string m_strIniShortName;
        private string m_strIniComment;
        private string m_strIniStatusID;
        private bool m_bIsStatusChanged = false;
        public bool IsStatusChanged
        {
            get { return m_bIsStatusChanged; }
        }
        private bool m_bIsInfoChanged = false;
        public bool IsInfoChanged
        {
            get { return m_bIsInfoChanged; }
        }

        private OVRDrawArrangeModule m_Module;
        public OVRDrawArrangeModule Module
        {
            get { return this.m_Module; }
            set { this.m_Module = value; }
        }

        private DataTable m_tbStatus = new DataTable();

        public PhaseInfoForm()
        {
            InitializeComponent();
            Localization();
        }

        private void PhaseInfoForm_Load(object sender, EventArgs e)
        {
            OVRDataBaseUtils.InitLanguageCombBox(CmbLanguage, m_DatabaseConnection);
            IntiStatusCmb(m_strLanguageCode);
            CmbLanguage.SelectedItem = m_strLanguageCode;

            switch (m_iOperateType)
            {
                case 1:
                    CmbLanguage.Enabled = false;
                    break;
                case 2:
                    InitPhaseById(m_iPhaseID, m_strLanguageCode);
                    CmbLanguage.Enabled = false;
                    break;
                default:
                    break;
            }
        }

        private void InitPhaseById(Int32 iPhaseID, String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetPhaseInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhaseID);
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
                        TextCode.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PhaseCode");
                        DateStart.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_OpenDate");
                        DateEnd.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_CloseDate");
                        TextOrder.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_Order");
                        textIsPool.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PhaseIsPool");
                        textHasPools.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PhaseHasPools");

                        TextLongName.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PhaseLongName");
                        TextShortName.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PhaseShortName");
                        TextComment.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_PhaseComment");

                        CmbStatus.SelectedValue = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_PhaseStatusID");

                        m_strIniPhaseCode = TextCode.Text;
                        m_strIniDateStart = DateStart.Text;
                        m_strIniDateEnd = DateEnd.Text;
                        m_strIniOrder = TextOrder.Text;
                        m_strIniIsPool = textIsPool.Text;
                        m_strIniHasPool = textHasPools.Text;
                        m_strIniLongName = TextLongName.Text;
                        m_strIniShortName = TextShortName.Text;
                        m_strIniComment = TextComment.Text;
                        m_strIniStatusID = CmbStatus.SelectedValue.ToString();

                        m_iEventID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_EventID");
                        m_iPhaseID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_PhaseID");
                        m_iFatherPhaseID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_FatherPhaseID");
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
                    if (!AddPhase()) return;
                    break;

                case 2:
                    if (!EditPhase()) return;
                    break;

                default:
                    break;
            }
            this.DialogResult = DialogResult.OK;
        }

        private void btnCancle_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
        }

        private bool AddPhase()
        {
            bool bResult = false;
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_AddPhase_for_Schedule";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iEventID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@FatherPhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iFatherPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@PhaseCode", SqlDbType.NVarChar, 10,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextCode.Text);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@OpenDate", SqlDbType.NVarChar, 16,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, DateStart.Text);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@CloseDate", SqlDbType.NVarChar, 16,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DateEnd.Text);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                            "@PhaseStatusID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, ConvertStrToInt(CmbStatus.SelectedValue.ToString()));
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameter7 = new SqlParameter(
                            "@PhaseNodeType", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameter7);

                SqlParameter cmdParameter8 = new SqlParameter(
                            "@Order", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, TextOrder.Text);
                oneSqlCommand.Parameters.Add(cmdParameter8);

                SqlParameter cmdParameter9 = new SqlParameter(
                            "@PhaseType", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameter9);

                SqlParameter cmdParameter10 = new SqlParameter(
                             "@PhaseSize", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameter10);

                SqlParameter cmdParameter11 = new SqlParameter(
                             "@PhaseRankSize", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameter11);

                SqlParameter cmdParameter12 = new SqlParameter(
                             "@PhaseIsQual", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameter12);

                SqlParameter cmdParameter13 = new SqlParameter(
                             "@PhaseInfo", SqlDbType.NVarChar, 50,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameter13);

                SqlParameter cmdParameter14 = new SqlParameter(
                             "@languageCode", SqlDbType.Char, 3,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, m_strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter14);

                SqlParameter cmdParameter15 = new SqlParameter(
                             "@PhaseLongName", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextLongName.Text);
                oneSqlCommand.Parameters.Add(cmdParameter15);

                SqlParameter cmdParameter16 = new SqlParameter(
                             "@PhaseShortName", SqlDbType.NVarChar, 50,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextShortName.Text);
                oneSqlCommand.Parameters.Add(cmdParameter16);

                SqlParameter cmdParameter17 = new SqlParameter(
                             "@PhaseComment", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextComment.Text);
                oneSqlCommand.Parameters.Add(cmdParameter17);

                SqlParameter cmdParameter18 = new SqlParameter(
                            "@IsPool", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, textIsPool.Text);
                oneSqlCommand.Parameters.Add(cmdParameter18);

                SqlParameter cmdParameter19 = new SqlParameter(
                            "@HasPools", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, textHasPools.Text);
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
                    m_iPhaseID = iOperateResult;
                    switch (iOperateResult)
                    {
                        case 0:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgAddPhase1"));
                            bResult = false;
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgAddPhase2"));
                            bResult = false;
                            break;
                        case -2:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgAddPhase4"));
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

        private bool EditPhase()
        {
            bool bResult = false;

            Int32 iChangeStatusResult = 0;

            iChangeStatusResult = OVRDataBaseUtils.ChangePhaseStatus(m_iPhaseID, ConvertStrToInt(CmbStatus.SelectedValue.ToString()), m_DatabaseConnection, m_Module);
            if (iChangeStatusResult != 1)
            {
                switch (iChangeStatusResult)
                {
                    case -1:
                        DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgEditPhaseStatus2"));
                        break;
                    case -2:
                        DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgEditPhaseStatus3"));
                        break;
                    default://其余的需要为修改失败!
                        DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgEditPhaseStatus1"));
                        break;
                }
                return bResult;
            }

            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_EditPhase";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter0);

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iEventID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@FatherPhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iFatherPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@PhaseCode", SqlDbType.NVarChar, 10,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextCode.Text);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@OpenDate", SqlDbType.NVarChar, 16,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, DateStart.Text);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@CloseDate", SqlDbType.NVarChar, 16,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DateEnd.Text);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter8 = new SqlParameter(
                            "@Order", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, ConvertStrToInt(TextOrder.Text));
                oneSqlCommand.Parameters.Add(cmdParameter8);

                SqlParameter cmdParameter9 = new SqlParameter(
                            "@IsPool", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, ConvertStrToInt(textIsPool.Text));
                oneSqlCommand.Parameters.Add(cmdParameter9);

                SqlParameter cmdParameter10 = new SqlParameter(
                            "@HasPools", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, ConvertStrToInt(textHasPools.Text));
                oneSqlCommand.Parameters.Add(cmdParameter10);

                SqlParameter cmdParameter11 = new SqlParameter(
                            "@StatusID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, ConvertStrToInt(CmbStatus.SelectedValue.ToString()));
                oneSqlCommand.Parameters.Add(cmdParameter11);

                SqlParameter cmdParameter13 = new SqlParameter(
                             "@PhaseInfo", SqlDbType.NVarChar, 50,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, "");
                oneSqlCommand.Parameters.Add(cmdParameter13);

                SqlParameter cmdParameter14 = new SqlParameter(
                             "@languageCode", SqlDbType.Char, 3,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, m_strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter14);

                SqlParameter cmdParameter15 = new SqlParameter(
                             "@PhaseLongName", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextLongName.Text);
                oneSqlCommand.Parameters.Add(cmdParameter15);

                SqlParameter cmdParameter16 = new SqlParameter(
                             "@PhaseShortName", SqlDbType.NVarChar, 50,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextShortName.Text);
                oneSqlCommand.Parameters.Add(cmdParameter16);

                SqlParameter cmdParameter17 = new SqlParameter(
                             "@PhaseComment", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextComment.Text);
                oneSqlCommand.Parameters.Add(cmdParameter17);

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
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgEditPhase1"));
                            bResult = false;
                            break;
                        case 1://修改成功!
                            if (m_strIniPhaseCode != TextCode.Text || m_strIniDateStart != DateStart.Text ||
                                m_strIniDateEnd != DateEnd.Text || m_strIniOrder != TextOrder.Text ||
                                m_strIniIsPool != textIsPool.Text || m_strIniHasPool != textHasPools.Text ||
                                m_strIniLongName != TextLongName.Text || m_strIniShortName != TextShortName.Text ||
                                m_strIniComment != TextComment.Text)
                                m_bIsInfoChanged = true;

                            if (m_strSectionName != CmbStatus.SelectedValue.ToString())
                                m_bIsStatusChanged = true;
                            bResult = true;
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgEditPhase2"));
                            bResult = false;
                            break;
                        default://其余的需要为修改失败!
                            bResult = false;
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

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmPhaseInfo");
            this.btnOK.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnOK");
            this.btnCancle.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnCancle");
            this.lbPhaseCode.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPhaseCode");
            this.lbStartDate.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbStartDate");
            this.lbEndDate.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbEndDate");
            this.lbPhaseIsPool.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPhaseIsPool");
            this.lbPhaseHasPools.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPhaseHasPools");
            this.lbPhaseOrder.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPhaseOrder");
            this.lbLanguage.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbLanguage");
            this.lbPhaseLongName.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPhaseLongName");
            this.lbPhaseShortName.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPhaseShortName");
            this.lbPhaseComment.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPhaseComment");
            this.lbPhaseStatus.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPhaseStatus");
        }

        private void IntiStatusCmb(String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetPhaseStatusList";
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
    }
}