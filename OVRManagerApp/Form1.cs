using Sunny.UI;
using System;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlClient;

using AutoSports.OVRCommon;


namespace AutoSports.OVRManagerApp
{
    public partial class Form1 : UIPage
    {
        public string _ConnectionString = "";

        public string ConnectionString
        {
            get { return _ConnectionString; }

            set
            {
                _ConnectionString = value;

                int iSta, iEnd;
                iSta = _ConnectionString.IndexOf("Data Source=", 0, StringComparison.OrdinalIgnoreCase);
                if (iSta >= 0)
                {
                    iSta += 12;
                    iEnd = _ConnectionString.IndexOf(';', iSta);
                    if (iEnd < iSta)
                        tbServer.Text = _ConnectionString.Substring(iSta, _ConnectionString.Length - iSta).Trim();
                    else
                        tbServer.Text = _ConnectionString.Substring(iSta, iEnd - iSta).Trim();
                }

                iSta = _ConnectionString.IndexOf("User ID=", 0, StringComparison.OrdinalIgnoreCase);
                if (iSta >= 0)
                {
                    iSta += 8;
                    iEnd = _ConnectionString.IndexOf(';', iSta);
                    if (iEnd < iSta)
                        tbUserID.Text = _ConnectionString.Substring(iSta, _ConnectionString.Length - iSta).Trim();
                    else
                        tbUserID.Text = _ConnectionString.Substring(iSta, iEnd - iSta).Trim();
                }

                iSta = _ConnectionString.IndexOf("Password=", 0, StringComparison.OrdinalIgnoreCase);
                if (iSta >= 0)
                {
                    iSta += 9;
                    iEnd = _ConnectionString.IndexOf(';', iSta);
                    if (iEnd < iSta)
                        tbPassword.Text = _ConnectionString.Substring(iSta, _ConnectionString.Length - iSta).Trim();
                    else
                        tbPassword.Text = _ConnectionString.Substring(iSta, iEnd - iSta).Trim();

                    try
                    {
                        tbPassword.Text = OVRSimpleEncryption.Decrypt(tbPassword.Text);
                    }
                    catch (System.Exception ex)
                    {
                    }
                }

                iSta = _ConnectionString.IndexOf("Initial Catalog=", 0, StringComparison.OrdinalIgnoreCase);
                if (iSta >= 0)
                {
                    iSta += 16;
                    iEnd = _ConnectionString.IndexOf(';', iSta);
                    if (iEnd < iSta)
                        cmbDatabase.Text = _ConnectionString.Substring(iSta, _ConnectionString.Length - iSta).Trim();
                    else
                        cmbDatabase.Text = _ConnectionString.Substring(iSta, iEnd - iSta).Trim();
                }

                iSta = _ConnectionString.IndexOf("Persist Security Info=True", 0, StringComparison.OrdinalIgnoreCase);
                cbSavePwd.Checked = iSta >= 0 ? true : false;
            }
        }

        public Form1()
        {
            InitializeComponent();

            
        }

        private bool TestConnection()
        {
            string strPassword = tbPassword.Text;
            try
            {
                //strPassword = OVRSimpleEncryption.Encrypt(tbPassword.Text);
            }
            catch (System.Exception ex)
            {
                UIMessageDialog.ShowMessageDialog(LocalizationRecourceManager.GetString("OVRLogin", "PwdIncorrect"),"Information",false,this.Style);

                return false;
            }

            _ConnectionString = String.Format(@"Data Source={0};User ID={1};Password={2};Initial Catalog={3};Persist Security Info={4};MultipleActiveResultSets=true;"
                                            , tbServer.Text, tbUserID.Text, strPassword, cmbDatabase.Text, cbSavePwd.Checked.ToString());

            using (SqlConnection sqlCon = new SqlConnection(_ConnectionString))
            {
                try
                {
                    sqlCon.Open();
                    sqlCon.Close();
                }
                catch (SqlException ex)
                {
                    string strMsg = "";
                    for (int i = 0; i < ex.Errors.Count; i++)
                    {
                        string strTemp = String.Format("Index #{0}\nErrorNumber: {1}\nMessage: {2}\nLineNumber: {3}\n",
                                                       i, ex.Errors[i].Number, ex.Errors[i].Message, ex.Errors[i].LineNumber);
                        strTemp += "Source: " + ex.Errors[i].Source + "\n" + "Procedure: " + ex.Errors[i].Procedure + "\n";

                        strMsg += strTemp;
                    }
                    string strCaption = LocalizationRecourceManager.GetString("OVRLogin", "DBConnectingError");
                    UIMessageDialog.ShowMessageDialog(strMsg, strCaption,  false, this.Style);
                    return false;
                }
            }

            return true;
        }

        private void OVRDBSettingForm_Load(object sender, EventArgs e)
        {
            string strSectionName = "OVRLogin";
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "DBSetting");
            this.lbServer.Text = LocalizationRecourceManager.GetString(strSectionName, "Server");
            this.lbUserID.Text = LocalizationRecourceManager.GetString(strSectionName, "User");
            this.lbPassword.Text = LocalizationRecourceManager.GetString(strSectionName, "Password");
            this.lbDatabase.Text = LocalizationRecourceManager.GetString(strSectionName, "DataBase");
            this.cbSavePwd.Text = LocalizationRecourceManager.GetString(strSectionName, "SavePwd");
            this.btnTest.Text = LocalizationRecourceManager.GetString(strSectionName, "Test");
            this.btnOK.Text = LocalizationRecourceManager.GetString(strSectionName, "OK");
            this.btnCancel.Text = LocalizationRecourceManager.GetString(strSectionName, "Cancel");
        }

        private void cmbDatabase_DropDown(object sender, EventArgs e)
        {
            string strPassword = tbPassword.Text;
            try
            {
                // strPassword = OVRSimpleEncryption.Encrypt(tbPassword.Text);
            }
            catch (System.Exception ex)
            {
                UIMessageDialog.ShowMessageDialog(LocalizationRecourceManager.GetString("OVRLogin", "PwdIncorrect"),"Information",false,this.Style);

                return;
            }

            _ConnectionString = String.Format(@"Data Source={0};User ID={1};Password={2};Persist Security Info={3}"
                                            , tbServer.Text, tbUserID.Text, strPassword, cbSavePwd.Checked.ToString());

            using (SqlConnection sqlCon = new SqlConnection(_ConnectionString))
            {
                try
                {
                    sqlCon.Open();

                    DataTable table = sqlCon.GetSchema("Databases");

                    cmbDatabase.DisplayMember = "database_name";
                    cmbDatabase.ValueMember = "database_name";
                    cmbDatabase.DataSource = table;

                    sqlCon.Close();
                }
                catch (SqlException ex)
                {
                    string strMsg = "";
                    for (int i = 0; i < ex.Errors.Count; i++)
                    {
                        string strTemp = String.Format("Index #{0}\nErrorNumber: {1}\nMessage: {2}\nLineNumber: {3}\n",
                                                       i, ex.Errors[i].Number, ex.Errors[i].Message, ex.Errors[i].LineNumber);
                        strTemp += "Source: " + ex.Errors[i].Source + "\n" + "Procedure: " + ex.Errors[i].Procedure + "\n";

                        strMsg += strTemp;
                    }
                    string strCaption = LocalizationRecourceManager.GetString("OVRLogin", "DBConnectingError");
                    UIMessageDialog.ShowMessageDialog(strMsg, strCaption, false, this.Style);
                    return;
                }
            }
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            if (TestConnection())
            {
                DialogResult = DialogResult.OK;
                Close();
            }
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            DialogResult = DialogResult.Cancel;
            Close();
        }

        private void btnTest_Click(object sender, EventArgs e)
        {
            if (TestConnection())
            {
                string strText = LocalizationRecourceManager.GetString("OVRLogin", "TestSucceed");
                UIMessageDialog.ShowMessageDialog(strText, "Information", false, this.Style);
            }
        }

    }
}
