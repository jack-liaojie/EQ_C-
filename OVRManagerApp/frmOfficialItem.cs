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

namespace AutoSports.OVRManagerApp
{
    public partial class OVROfficialItemForm : UIForm
    {
        private bool m_bAdd;   //标示操作是Add，还是Edit
        public int m_iNewsID;
        public int m_iDisciplineID;

        private DataTable m_tbOCType = new DataTable();
        private DataTable m_tbReportTitle = new DataTable();

        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public OVROfficialItemForm(bool bAdd, int iNewsID, SqlConnection dbConnection)
        {
            DatabaseConnection = dbConnection;
            m_bAdd = bAdd;
            m_iNewsID = iNewsID;
            InitializeComponent();
        }

        private void OfficialItemForm_Load(object sender, EventArgs e)
        {
            Localization();
            InitCmbReportTitle();
            InitCmbOCType();
            if (!m_bAdd)
            {
                GetCommunicationContext();
            }
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            int iResult;
            if (m_bAdd)
            {
                iResult = AddOfficialCommunication();

                if(iResult > 0)
                {
                    m_iNewsID = iResult;
                }
            }
            else
            {
                iResult = EditOfficialCommunication();
            }

            string strPromotion;
            string strSectionName = "OfficialCommunication";
            if(iResult <= 0)
            {
                strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                UIMessageDialog.ShowMessageDialog(strPromotion, "Information", false, this.Style);

                this.DialogResult = DialogResult.Cancel;
            }
            else
            {
                this.DialogResult = DialogResult.OK;
            }
            this.Close();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void Localization()
        {
            string strSectionName = "OfficialCommunication";
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmOfficialItem");
            this.lbItem.Text = LocalizationRecourceManager.GetString(strSectionName, "lbItem");
            this.lbSubTitle.Text = LocalizationRecourceManager.GetString(strSectionName, "lbSubTitle");
            this.lbHeading.Text = LocalizationRecourceManager.GetString(strSectionName, "lbHeading");
            this.lbText.Text = LocalizationRecourceManager.GetString(strSectionName, "lbText");
            this.lbIssuedBy.Text = LocalizationRecourceManager.GetString(strSectionName, "lbIssuedBy");
            this.lbType_OC.Text = LocalizationRecourceManager.GetString(strSectionName, "lbType_OC");
            this.lbDate_OC.Text = LocalizationRecourceManager.GetString(strSectionName, "lbDate_OC");
            this.lbNote.Text = LocalizationRecourceManager.GetString(strSectionName, "lbNote");
        }


        private void InitCmbReportTitle()
        {
            m_tbOCType.Clear();
            if (DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("proc_Get_CommunicationReportTiles", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataReader dr = cmd.ExecuteReader();
                m_tbReportTitle.Load(dr);
                dr.Close();

                cmbReportTitle.DisplayMember = "F_TypeDes";
                cmbReportTitle.ValueMember = "F_Type";
                cmbReportTitle.DataSource = m_tbReportTitle;

            }
            catch (System.Exception e)
            {
                UIMessageDialog.ShowMessageDialog(e.Message, "Information", false, this.Style);
            }
        }

        private void InitCmbOCType()
        {
            m_tbOCType.Clear();
            if (DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("proc_Get_CommunicationType", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataReader dr = cmd.ExecuteReader();
                m_tbOCType.Load(dr);
                dr.Close();

                cmbOCType.DisplayMember = "F_TypeDes";
                cmbOCType.ValueMember = "F_Type";
                cmbOCType.DataSource = m_tbOCType;

            }
            catch (System.Exception e)
            {
                UIMessageDialog.ShowMessageDialog(e.Message, "Information", false, this.Style);
            }
        }

        private void GetCommunicationContext()
        {
            if (m_iNewsID <= 0)
                return;
            if (DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }
            try
            {
                SqlCommand cmd = new SqlCommand("Proc_GetOfficialCommunication", DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@NewsID", SqlDbType.Int);
                cmdParameter1.Value = m_iNewsID;
                cmd.Parameters.Add(cmdParameter1);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        textItem.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_NewsItem");
                        textSubTitle.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_SubTitle");
                        textHeading.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Heading");
                        textText.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Text");
                        textIssuedBy.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Issued_by");
                        cmbOCType.SelectedValue = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Type");
                        dtOCDate.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Date");
                        textNote.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Note");
                        cmbReportTitle.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ReportTitle");
                        txtSummary.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Summary");
                        txtDetails.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Details");

                    }
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                UIMessageDialog.ShowMessageDialog(e.Message, "Information", false, this.Style);
            }
           
        }

        private int AddOfficialCommunication()
        {
            if (DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup forAdd OfficialCommunication

                SqlCommand cmd = new SqlCommand("proc_Add_OfficialCommunication", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineiD", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@DisciplineiD",
                            DataRowVersion.Current, m_iDisciplineID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@bAddNew", SqlDbType.Bit, 1,
                             ParameterDirection.Input, false, 0, 0, "@bAddNew",
                            DataRowVersion.Current, 1);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@NewsID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@NewsID",
                            DataRowVersion.Current, DBNull.Value);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@NewsItem", SqlDbType.NVarChar, 20,
                             ParameterDirection.Input, false, 0, 0, "@NewsItem",
                             DataRowVersion.Current, textItem.Text);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@SubTitle", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, false, 0, 0, "@SubTitle",
                            DataRowVersion.Current, textSubTitle.Text);

                SqlParameter cmdParameter6 = new SqlParameter(
                            "@Heading", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, false, 0, 0, "@Heading",
                            DataRowVersion.Current, textHeading.Text);

                SqlParameter cmdParameter7 = new SqlParameter(
                            "@Text", SqlDbType.NVarChar, 1000,
                             ParameterDirection.Input, false, 0, 0, "@Text",
                            DataRowVersion.Current, textText.Text);

                SqlParameter cmdParameter8 = new SqlParameter(
                            "@Issuedby", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, false, 0, 0, "@Issuedby",
                            DataRowVersion.Current, textIssuedBy.Text);

                SqlParameter cmdParameter9 = new SqlParameter(
                            "@Type", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@Type",
                            DataRowVersion.Current, cmbOCType.SelectedValue);


                SqlParameter cmdParameter10 = new SqlParameter("@Date", SqlDbType.DateTime);
                cmdParameter10.Direction = ParameterDirection.Input;
                if (dtOCDate.Text == "")
                {
                    cmdParameter10.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter10.Value = dtOCDate.Text;
                }
               

                SqlParameter cmdParameter11 = new SqlParameter(
                            "@Note", SqlDbType.NVarChar, 1000,
                             ParameterDirection.Input, false, 0, 0, "@Note",
                            DataRowVersion.Current, textNote.Text);


                SqlParameter cmdParameter12 = new SqlParameter(
                            "@ReportTitle", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, false, 0, 0, "@ReportTitle",
                            DataRowVersion.Current, cmbReportTitle.Text);


                SqlParameter cmdParameter13 = new SqlParameter(
                            "@Summary", SqlDbType.NVarChar, 1000,
                             ParameterDirection.Input, false, 0, 0, "@Summary",
                            DataRowVersion.Current, txtSummary.Text);

                SqlParameter cmdParameter14 = new SqlParameter(
                            "@Details", SqlDbType.NVarChar, 1000,
                             ParameterDirection.Input, false, 0, 0, "@Details",
                            DataRowVersion.Current, txtDetails.Text);


                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameter6);
                cmd.Parameters.Add(cmdParameter7);
                cmd.Parameters.Add(cmdParameter8);
                cmd.Parameters.Add(cmdParameter9);
                cmd.Parameters.Add(cmdParameter10);
                cmd.Parameters.Add(cmdParameter11);
                cmd.Parameters.Add(cmdParameter12);
                cmd.Parameters.Add(cmdParameter13);
                cmd.Parameters.Add(cmdParameter14);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;

                return nRetValue;

            }
            catch (System.Exception e)
            {
                UIMessageDialog.ShowMessageDialog(e.Message, "Information", false, this.Style);
                return -1;
            }
           
        }
       
        private int EditOfficialCommunication()
        {
            if (DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Edit OfficialCommunication

                SqlCommand cmd = new SqlCommand("proc_Add_OfficialCommunication", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineiD", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@DisciplineiD",
                            DataRowVersion.Current, m_iDisciplineID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@bAddNew", SqlDbType.Bit, 1,
                             ParameterDirection.Input, false, 0, 0, "@bAddNew",
                            DataRowVersion.Current, 0);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@NewsID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@NewsID",
                            DataRowVersion.Current, m_iNewsID);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@NewsItem", SqlDbType.NVarChar, 20,
                             ParameterDirection.Input, false, 0, 0, "@NewsItem",
                             DataRowVersion.Current, textItem.Text);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@SubTitle", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, false, 0, 0, "@SubTitle",
                            DataRowVersion.Current, textSubTitle.Text);

                SqlParameter cmdParameter6 = new SqlParameter(
                            "@Heading", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, false, 0, 0, "@Heading",
                            DataRowVersion.Current, textHeading.Text);

                SqlParameter cmdParameter7 = new SqlParameter(
                            "@Text", SqlDbType.NVarChar, 1000,
                             ParameterDirection.Input, false, 0, 0, "@Text",
                            DataRowVersion.Current, textText.Text);

                SqlParameter cmdParameter8 = new SqlParameter(
                            "@Issuedby", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, false, 0, 0, "@Issuedby",
                            DataRowVersion.Current, textIssuedBy.Text);

                SqlParameter cmdParameter9 = new SqlParameter(
                            "@Type", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@Type",
                            DataRowVersion.Current, cmbOCType.SelectedValue);

                SqlParameter cmdParameter10 = new SqlParameter("@Date", SqlDbType.DateTime);
                cmdParameter10.Direction = ParameterDirection.Input;
                if (dtOCDate.Text == "")
                {
                    cmdParameter10.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter10.Value = dtOCDate.Text;
                }

                SqlParameter cmdParameter11 = new SqlParameter(
                            "@Note", SqlDbType.NVarChar, 200,
                             ParameterDirection.Input, false, 0, 0, "@Note",
                            DataRowVersion.Current, textNote.Text);

                SqlParameter cmdParameter12 = new SqlParameter(
                            "@ReportTitle", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, false, 0, 0, "@ReportTitle",
                            DataRowVersion.Current, cmbReportTitle.Text);

                SqlParameter cmdParameter13 = new SqlParameter(
                            "@Summary", SqlDbType.NVarChar, 1000,
                             ParameterDirection.Input, false, 0, 0, "@Summary",
                            DataRowVersion.Current, txtSummary.Text);

                SqlParameter cmdParameter14 = new SqlParameter(
                            "@Details", SqlDbType.NVarChar, 1000,
                             ParameterDirection.Input, false, 0, 0, "@Details",
                            DataRowVersion.Current, txtDetails.Text);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameter6);
                cmd.Parameters.Add(cmdParameter7);
                cmd.Parameters.Add(cmdParameter8);
                cmd.Parameters.Add(cmdParameter9);
                cmd.Parameters.Add(cmdParameter10);
                cmd.Parameters.Add(cmdParameter11);
                cmd.Parameters.Add(cmdParameter12);
                cmd.Parameters.Add(cmdParameter13);
                cmd.Parameters.Add(cmdParameter14);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;

                return nRetValue;

            }
            catch (System.Exception e)
            {
                UIMessageDialog.ShowMessageDialog(e.Message, "Information", false, this.Style);
                return -1;
            }

        }


    }
}