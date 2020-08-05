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
    public partial class frmSetEventStatus : UIForm
    {
        private int m_iEventID;
        public int EventID
        {
            get { return this.m_iEventID; }
            set { this.m_iEventID = value; }
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

        private DataTable m_tbStatus = new DataTable();

        public frmSetEventStatus()
        {
            InitializeComponent();
            Localization();
        }

        private void Localization()
        {
            this.btnOk.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnOK");
            this.btnCancel.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnCancle");
            this.lbEventLongName.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbEventLongName");
            this.lbEventShortName.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbEventShortName");
            this.lbEventStatus.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbEventStatus");
        }

        private void frmfrmSetEventStatus_Load(object sender, EventArgs e)
        {
            IntiStatusCmb(m_strLanguageCode);
            InitEventById(m_iEventID, m_strLanguageCode);
        }

        private void InitEventById(Int32 iEventID, String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetEventByID";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iEventID);
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
                        TextLongName.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_EventLongName");
                        TextShortName.Text = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_EventShortName");
                        CmbStatus.SelectedValue = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_EventStatusID");
                    }
                }
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private bool SetEventStatus()
        {
            bool bResult = false;
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "proc_SetEventStatus";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iEventID);
                oneSqlCommand.Parameters.Add(cmdParameter0);

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@StatusID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, ConvertStrToInt(CmbStatus.SelectedValue.ToString()));
                oneSqlCommand.Parameters.Add(cmdParameter1);


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
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgSetEventStatus1"));
                            bResult = false;
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgSetEventStatus2"));
                            bResult = false;
                            break;
                        case -2:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgSetEventStatus3"));
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

        private void btnOk_Click(object sender, EventArgs e)
        {
            if (SetEventStatus())
            {
                this.DialogResult = DialogResult.OK;
                Close();
            }
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            Close();
        }

        private void IntiStatusCmb(String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetEventStatusList";
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
                UIMessageDialog.ShowMessageDialog(ex.Message,"",false,this.Style);
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
