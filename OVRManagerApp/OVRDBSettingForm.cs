using System;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlClient;

using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRManagerApp
{
    public partial class OVRDBSettingForm : UIForm
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

        public OVRDBSettingForm()
        {
            InitializeComponent();
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
            }
            base.Dispose(disposing);
        }

        public void InitializeComponent()
        {
            this.btnTest = new Sunny.UI.UIButton();
            this.btnOK = new Sunny.UI.UIButton();
            this.btnCancel = new Sunny.UI.UIButton();
            this.tbServer = new Sunny.UI.UITextBox();
            this.tbUserID = new Sunny.UI.UITextBox();
            this.tbPassword = new Sunny.UI.UITextBox();
            this.cmbDatabase = new Sunny.UI.UIComboBox();
            this.cbSavePwd = new Sunny.UI.UICheckBox();
            this.lbServer = new Sunny.UI.UILabel();
            this.lbUserID = new Sunny.UI.UILabel();
            this.lbPassword = new Sunny.UI.UILabel();
            this.lbDatabase = new Sunny.UI.UILabel();
            this.SuspendLayout();
            // 
            // btnTest
            // 
            this.btnTest.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnTest.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnTest.Location = new System.Drawing.Point(23, 226);
            this.btnTest.Name = "btnTest";
            this.btnTest.Size = new System.Drawing.Size(100, 35);
            this.btnTest.Style = Sunny.UI.UIStyle.Custom;
            this.btnTest.TabIndex = 9;
            this.btnTest.Text = "测试";
            this.btnTest.Click += new System.EventHandler(this.btnTest_Click);
            // 
            // btnOK
            // 
            this.btnOK.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnOK.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnOK.Location = new System.Drawing.Point(145, 226);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(100, 35);
            this.btnOK.Style = Sunny.UI.UIStyle.Custom;
            this.btnOK.TabIndex = 10;
            this.btnOK.Text = "确定";
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // btnCancel
            // 
            this.btnCancel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnCancel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnCancel.Location = new System.Drawing.Point(269, 226);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(100, 35);
            this.btnCancel.Style = Sunny.UI.UIStyle.Custom;
            this.btnCancel.TabIndex = 11;
            this.btnCancel.Text = "取消";
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // tbServer
            // 
            this.tbServer.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbServer.FillColor = System.Drawing.Color.White;
            this.tbServer.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbServer.Location = new System.Drawing.Point(121, 53);
            this.tbServer.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.tbServer.Maximum = 2147483647D;
            this.tbServer.Minimum = -2147483648D;
            this.tbServer.Name = "tbServer";
            this.tbServer.Padding = new System.Windows.Forms.Padding(5);
            this.tbServer.Size = new System.Drawing.Size(248, 29);
            this.tbServer.Style = Sunny.UI.UIStyle.Custom;
            this.tbServer.TabIndex = 12;
            // 
            // tbUserID
            // 
            this.tbUserID.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbUserID.FillColor = System.Drawing.Color.White;
            this.tbUserID.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbUserID.Location = new System.Drawing.Point(121, 87);
            this.tbUserID.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.tbUserID.Maximum = 2147483647D;
            this.tbUserID.Minimum = -2147483648D;
            this.tbUserID.Name = "tbUserID";
            this.tbUserID.Padding = new System.Windows.Forms.Padding(5);
            this.tbUserID.Size = new System.Drawing.Size(248, 29);
            this.tbUserID.Style = Sunny.UI.UIStyle.Custom;
            this.tbUserID.TabIndex = 13;
            // 
            // tbPassword
            // 
            this.tbPassword.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbPassword.FillColor = System.Drawing.Color.White;
            this.tbPassword.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbPassword.Location = new System.Drawing.Point(121, 121);
            this.tbPassword.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.tbPassword.Maximum = 2147483647D;
            this.tbPassword.Minimum = -2147483648D;
            this.tbPassword.Name = "tbPassword";
            this.tbPassword.Padding = new System.Windows.Forms.Padding(5);
            this.tbPassword.Size = new System.Drawing.Size(248, 29);
            this.tbPassword.Style = Sunny.UI.UIStyle.Custom;
            this.tbPassword.TabIndex = 13;
            // 
            // cmbDatabase
            // 
            this.cmbDatabase.FillColor = System.Drawing.Color.White;
            this.cmbDatabase.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cmbDatabase.Location = new System.Drawing.Point(120, 189);
            this.cmbDatabase.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cmbDatabase.MinimumSize = new System.Drawing.Size(63, 0);
            this.cmbDatabase.Name = "cmbDatabase";
            this.cmbDatabase.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cmbDatabase.Size = new System.Drawing.Size(249, 29);
            this.cmbDatabase.Style = Sunny.UI.UIStyle.Custom;
            this.cmbDatabase.TabIndex = 14;
            this.cmbDatabase.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // cbSavePwd
            // 
            this.cbSavePwd.Cursor = System.Windows.Forms.Cursors.Hand;
            this.cbSavePwd.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cbSavePwd.Location = new System.Drawing.Point(121, 155);
            this.cbSavePwd.Name = "cbSavePwd";
            this.cbSavePwd.Padding = new System.Windows.Forms.Padding(22, 0, 0, 0);
            this.cbSavePwd.Size = new System.Drawing.Size(248, 29);
            this.cbSavePwd.Style = Sunny.UI.UIStyle.Custom;
            this.cbSavePwd.TabIndex = 15;
            this.cbSavePwd.Text = "记住密码";
            // 
            // lbServer
            // 
            this.lbServer.AutoSize = true;
            this.lbServer.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbServer.Location = new System.Drawing.Point(31, 53);
            this.lbServer.Name = "lbServer";
            this.lbServer.Size = new System.Drawing.Size(42, 21);
            this.lbServer.Style = Sunny.UI.UIStyle.Custom;
            this.lbServer.TabIndex = 16;
            this.lbServer.Text = "服务";
            this.lbServer.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbUserID
            // 
            this.lbUserID.AutoSize = true;
            this.lbUserID.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbUserID.Location = new System.Drawing.Point(31, 92);
            this.lbUserID.Name = "lbUserID";
            this.lbUserID.Size = new System.Drawing.Size(42, 21);
            this.lbUserID.Style = Sunny.UI.UIStyle.Custom;
            this.lbUserID.TabIndex = 17;
            this.lbUserID.Text = "用户";
            this.lbUserID.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbPassword
            // 
            this.lbPassword.AutoSize = true;
            this.lbPassword.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbPassword.Location = new System.Drawing.Point(31, 131);
            this.lbPassword.Name = "lbPassword";
            this.lbPassword.Size = new System.Drawing.Size(42, 21);
            this.lbPassword.Style = Sunny.UI.UIStyle.Custom;
            this.lbPassword.TabIndex = 18;
            this.lbPassword.Text = "密码";
            this.lbPassword.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbDatabase
            // 
            this.lbDatabase.AutoSize = true;
            this.lbDatabase.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbDatabase.Location = new System.Drawing.Point(31, 189);
            this.lbDatabase.Name = "lbDatabase";
            this.lbDatabase.Size = new System.Drawing.Size(42, 21);
            this.lbDatabase.Style = Sunny.UI.UIStyle.Custom;
            this.lbDatabase.TabIndex = 19;
            this.lbDatabase.Text = "数据";
            this.lbDatabase.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // OVRDBSettingForm
            // 
            this.ClientSize = new System.Drawing.Size(398, 288);
            this.ControlBox = false;
            this.Controls.Add(this.lbDatabase);
            this.Controls.Add(this.lbPassword);
            this.Controls.Add(this.lbUserID);
            this.Controls.Add(this.lbServer);
            this.Controls.Add(this.cbSavePwd);
            this.Controls.Add(this.cmbDatabase);
            this.Controls.Add(this.tbUserID);
            this.Controls.Add(this.tbPassword);
            this.Controls.Add(this.tbServer);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.btnTest);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRDBSettingForm";
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "DBSetting";
            this.Load += new System.EventHandler(this.OVRDBSettingForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        public bool TestConnection()
        {
            string strPassword = tbPassword.Text;
            try
            {
                //strPassword = OVRSimpleEncryption.Encrypt(tbPassword.Text);
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString("OVRLogin", "PwdIncorrect"));

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
                    UIMessageDialog.ShowMessageDialog(strMsg, "Information", false, this.Style);
                    return false;
                }
            }

            return true;
        }

        public void OVRDBSettingForm_Load(object sender, EventArgs e)
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

        public void cmbDatabase_DropDown(object sender, EventArgs e)
        {
            string strPassword = tbPassword.Text;
            try
            {
                // strPassword = OVRSimpleEncryption.Encrypt(tbPassword.Text);
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString("OVRLogin", "PwdIncorrect"));

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
                    DevComponents.DotNetBar.MessageBoxEx.Show(strMsg, strCaption, MessageBoxButtons.OK);
                    return;
                }
            }
        }

        public void btnOK_Click(object sender, EventArgs e)
        {
            if (TestConnection())
            {
                DialogResult = DialogResult.OK;
                Close();
            }
        }

        public void btnCancel_Click(object sender, EventArgs e)
        {
            DialogResult = DialogResult.Cancel;
            Close();
        }

        public void btnTest_Click(object sender, EventArgs e)
        {
            if (TestConnection())
            {
                string strText = LocalizationRecourceManager.GetString("OVRLogin", "TestSucceed");
                DevComponents.DotNetBar.MessageBoxEx.Show(strText, null, MessageBoxButtons.OK);
            }
        }

    }
}