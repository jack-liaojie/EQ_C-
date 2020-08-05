namespace AutoSports.OVRManagerApp
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.lbDatabase = new Sunny.UI.UILabel();
            this.lbPassword = new Sunny.UI.UILabel();
            this.lbUserID = new Sunny.UI.UILabel();
            this.lbServer = new Sunny.UI.UILabel();
            this.cbSavePwd = new Sunny.UI.UICheckBox();
            this.cmbDatabase = new Sunny.UI.UIComboBox();
            this.tbUserID = new Sunny.UI.UITextBox();
            this.tbPassword = new Sunny.UI.UITextBox();
            this.tbServer = new Sunny.UI.UITextBox();
            this.btnCancel = new Sunny.UI.UIButton();
            this.btnOK = new Sunny.UI.UIButton();
            this.btnTest = new Sunny.UI.UIButton();
            this.SuspendLayout();
            // 
            // lbDatabase
            // 
            this.lbDatabase.AutoSize = true;
            this.lbDatabase.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbDatabase.Location = new System.Drawing.Point(12, 157);
            this.lbDatabase.Name = "lbDatabase";
            this.lbDatabase.Size = new System.Drawing.Size(42, 21);
            this.lbDatabase.TabIndex = 31;
            this.lbDatabase.Text = "数据";
            this.lbDatabase.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbPassword
            // 
            this.lbPassword.AutoSize = true;
            this.lbPassword.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbPassword.Location = new System.Drawing.Point(12, 92);
            this.lbPassword.Name = "lbPassword";
            this.lbPassword.Size = new System.Drawing.Size(42, 21);
            this.lbPassword.TabIndex = 30;
            this.lbPassword.Text = "密码";
            this.lbPassword.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbUserID
            // 
            this.lbUserID.AutoSize = true;
            this.lbUserID.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbUserID.Location = new System.Drawing.Point(12, 56);
            this.lbUserID.Name = "lbUserID";
            this.lbUserID.Size = new System.Drawing.Size(42, 21);
            this.lbUserID.TabIndex = 29;
            this.lbUserID.Text = "用户";
            this.lbUserID.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbServer
            // 
            this.lbServer.AutoSize = true;
            this.lbServer.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbServer.Location = new System.Drawing.Point(12, 20);
            this.lbServer.Name = "lbServer";
            this.lbServer.Size = new System.Drawing.Size(42, 21);
            this.lbServer.TabIndex = 28;
            this.lbServer.Text = "服务";
            this.lbServer.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // cbSavePwd
            // 
            this.cbSavePwd.Cursor = System.Windows.Forms.Cursors.Hand;
            this.cbSavePwd.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cbSavePwd.Location = new System.Drawing.Point(102, 119);
            this.cbSavePwd.Name = "cbSavePwd";
            this.cbSavePwd.Padding = new System.Windows.Forms.Padding(22, 0, 0, 0);
            this.cbSavePwd.Size = new System.Drawing.Size(248, 29);
            this.cbSavePwd.TabIndex = 27;
            this.cbSavePwd.Text = "记住密码";
            // 
            // cmbDatabase
            // 
            this.cmbDatabase.FillColor = System.Drawing.Color.White;
            this.cmbDatabase.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cmbDatabase.Location = new System.Drawing.Point(101, 150);
            this.cmbDatabase.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cmbDatabase.MinimumSize = new System.Drawing.Size(63, 0);
            this.cmbDatabase.Name = "cmbDatabase";
            this.cmbDatabase.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cmbDatabase.Size = new System.Drawing.Size(249, 29);
            this.cmbDatabase.TabIndex = 26;
            this.cmbDatabase.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            this.cmbDatabase.Click += new System.EventHandler(this.cmbDatabase_DropDown);
            // 
            // tbUserID
            // 
            this.tbUserID.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbUserID.FillColor = System.Drawing.Color.White;
            this.tbUserID.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbUserID.Location = new System.Drawing.Point(102, 53);
            this.tbUserID.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.tbUserID.Maximum = 2147483647D;
            this.tbUserID.Minimum = -2147483648D;
            this.tbUserID.Name = "tbUserID";
            this.tbUserID.Padding = new System.Windows.Forms.Padding(5);
            this.tbUserID.Size = new System.Drawing.Size(248, 29);
            this.tbUserID.TabIndex = 24;
            // 
            // tbPassword
            // 
            this.tbPassword.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbPassword.FillColor = System.Drawing.Color.White;
            this.tbPassword.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbPassword.Location = new System.Drawing.Point(102, 86);
            this.tbPassword.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.tbPassword.Maximum = 2147483647D;
            this.tbPassword.Minimum = -2147483648D;
            this.tbPassword.Name = "tbPassword";
            this.tbPassword.Padding = new System.Windows.Forms.Padding(5);
            this.tbPassword.Size = new System.Drawing.Size(248, 29);
            this.tbPassword.TabIndex = 25;
            // 
            // tbServer
            // 
            this.tbServer.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbServer.FillColor = System.Drawing.Color.White;
            this.tbServer.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbServer.Location = new System.Drawing.Point(102, 20);
            this.tbServer.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.tbServer.Maximum = 2147483647D;
            this.tbServer.Minimum = -2147483648D;
            this.tbServer.Name = "tbServer";
            this.tbServer.Padding = new System.Windows.Forms.Padding(5);
            this.tbServer.Size = new System.Drawing.Size(248, 29);
            this.tbServer.TabIndex = 23;
            // 
            // btnCancel
            // 
            this.btnCancel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnCancel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnCancel.Location = new System.Drawing.Point(252, 182);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(100, 35);
            this.btnCancel.TabIndex = 22;
            this.btnCancel.Text = "取消";
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnOK
            // 
            this.btnOK.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnOK.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnOK.Location = new System.Drawing.Point(128, 182);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(100, 35);
            this.btnOK.TabIndex = 21;
            this.btnOK.Text = "确定";
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // btnTest
            // 
            this.btnTest.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnTest.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnTest.Location = new System.Drawing.Point(6, 182);
            this.btnTest.Name = "btnTest";
            this.btnTest.Size = new System.Drawing.Size(100, 35);
            this.btnTest.TabIndex = 20;
            this.btnTest.Text = "测试";
            this.btnTest.Click += new System.EventHandler(this.btnTest_Click);
            // 
            // Form1
            // 
            this.ClientSize = new System.Drawing.Size(366, 236);
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
            this.Name = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }
        #endregion

        private Sunny.UI.UILabel lbDatabase;
        private Sunny.UI.UILabel lbPassword;
        private Sunny.UI.UILabel lbUserID;
        private Sunny.UI.UILabel lbServer;
        private Sunny.UI.UICheckBox cbSavePwd;
        private Sunny.UI.UIComboBox cmbDatabase;
        private Sunny.UI.UITextBox tbUserID;
        private Sunny.UI.UITextBox tbPassword;
        private Sunny.UI.UITextBox tbServer;
        private Sunny.UI.UIButton btnCancel;
        private Sunny.UI.UIButton btnOK;
        private Sunny.UI.UIButton btnTest;
    }
}