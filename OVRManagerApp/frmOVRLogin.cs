using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Xml;
using Sunny.UI;

using DevComponents.DotNetBar;

using AutoSports.OVRCommon;

namespace AutoSports.OVRManagerApp
{
    public class OVRLoginForm :UIForm
    {
        public OVRLoginForm()
        {
            InitializeComponent();
            this.xmlDocCfgFile = new XmlDocument();
            this.sqlConnection = new System.Data.SqlClient.SqlConnection();
            this.daUser = new SqlDataAdapter();
            this.daRole = new SqlDataAdapter();
            this.dtUserTable = new System.Data.DataTable("UserTable");
            this.dtRoleTable = new System.Data.DataTable("RoleTable");
            this.dtLanguageTable = new System.Data.DataTable("LanguageTable");
            this.dtLanguageTable.Columns.Add(new DataColumn("F_Description", typeof(string)));
            this.dtLanguageTable.Columns.Add(new DataColumn("F_CulName", typeof(string)));
            this.dtLanguageTable.Columns.Add(new DataColumn("F_FileName", typeof(string)));

            this.strSectionName = "OVRLogin";
            ComboBoxSetup();
        }

        private XmlDocument xmlDocCfgFile;
        private string strSectionName;

        private string strUserPassword;
        private int iRoleID;
        private System.Data.SqlClient.SqlDataAdapter daUser;
        private System.Data.SqlClient.SqlDataAdapter daRole;
        private System.Data.SqlClient.SqlConnection sqlConnection;
        private System.Data.DataTable dtUserTable;
        private System.Data.DataTable dtRoleTable;
        private System.Data.DataTable dtLanguageTable;
        private UIButton btnDbSetting;
        private UIButton btnLogin;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbUser;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbRole;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbLanguage;
        private UITextBox txPwd;
        private UILabel lbServerName;
        private UILabel lbDbName;
        private UILabel lbServer;
        private UILabel lbUser;
        private UILabel lbRole;
        private UILabel lbPwd;
        private UILabel lbDb;
        private UILabel lbSelLang;
        private UILabel lbDiscCode;
        private UITextBox txRptPrtPath;
        private UILabel lbRptPrtPath;
        private UIButton btnBrowse;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbDiscList;
        private PanelEx panelEx1;
        private PanelEx panelEx3;
        private PanelEx panelEx2;

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
            this.panelEx1 = new PanelEx();
            this.panelEx3 = new PanelEx();
            this.btnLogin = new Sunny.UI.UIButton();
            this.lbUser = new Sunny.UI.UILabel();
            this.txPwd = new Sunny.UI.UITextBox();
            this.lbRole = new Sunny.UI.UILabel();
            this.lbPwd = new Sunny.UI.UILabel();
            this.cmbUser = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.cmbRole = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.panelEx2 = new PanelEx();
            this.btnBrowse = new Sunny.UI.UIButton();
            this.cmbLanguage = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbDiscCode = new Sunny.UI.UILabel();
            this.txRptPrtPath = new Sunny.UI.UITextBox();
            this.btnDbSetting = new Sunny.UI.UIButton();
            this.cmbDiscList = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbDbName = new Sunny.UI.UILabel();
            this.lbSelLang = new Sunny.UI.UILabel();
            this.lbRptPrtPath = new Sunny.UI.UILabel();
            this.lbDb = new Sunny.UI.UILabel();
            this.lbServerName = new Sunny.UI.UILabel();
            this.lbServer = new Sunny.UI.UILabel();
            this.panelEx1.SuspendLayout();
            this.panelEx3.SuspendLayout();
            this.panelEx2.SuspendLayout();
            this.SuspendLayout();
            // 
            // panelEx1
            // 
            this.panelEx1.Controls.Add(this.panelEx3);
            this.panelEx1.Controls.Add(this.panelEx2);
            this.panelEx1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelEx1.Location = new System.Drawing.Point(0, 35);
            this.panelEx1.Margin = new System.Windows.Forms.Padding(4);
            this.panelEx1.Name = "panelEx1";
            this.panelEx1.Size = new System.Drawing.Size(577, 365);
            this.panelEx1.Style.Alignment = System.Drawing.StringAlignment.Center;
            this.panelEx1.Style.GradientAngle = 90;
            this.panelEx1.TabIndex = 1;
            this.panelEx1.Click += new System.EventHandler(this.panelEx1_Click);
            // 
            // panelEx3
            // 
            this.panelEx3.Controls.Add(this.btnLogin);
            this.panelEx3.Controls.Add(this.lbUser);
            this.panelEx3.Controls.Add(this.txPwd);
            this.panelEx3.Controls.Add(this.lbRole);
            this.panelEx3.Controls.Add(this.lbPwd);
            this.panelEx3.Controls.Add(this.cmbUser);
            this.panelEx3.Controls.Add(this.cmbRole);
            this.panelEx3.Location = new System.Drawing.Point(4, 226);
            this.panelEx3.Margin = new System.Windows.Forms.Padding(4);
            this.panelEx3.Name = "panelEx3";
            this.panelEx3.Size = new System.Drawing.Size(568, 100);
            this.panelEx3.Style.Alignment = System.Drawing.StringAlignment.Center;
            this.panelEx3.Style.Border = DevComponents.DotNetBar.eBorderType.SingleLine;
            this.panelEx3.Style.CornerType = DevComponents.DotNetBar.eCornerType.Rounded;
            this.panelEx3.Style.GradientAngle = 90;
            this.panelEx3.TabIndex = 8;
            // 
            // btnLogin
            // 
            this.btnLogin.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnLogin.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnLogin.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.btnLogin.Location = new System.Drawing.Point(423, 49);
            this.btnLogin.Margin = new System.Windows.Forms.Padding(4);
            this.btnLogin.Name = "btnLogin";
            this.btnLogin.Size = new System.Drawing.Size(135, 38);
            this.btnLogin.Style = Sunny.UI.UIStyle.Custom;
            this.btnLogin.TabIndex = 7;
            this.btnLogin.Text = "Login";
            this.btnLogin.Click += new System.EventHandler(this.btnLogin_Click);
            // 
            // lbUser
            // 
            this.lbUser.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbUser.Location = new System.Drawing.Point(0, 12);
            this.lbUser.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbUser.Name = "lbUser";
            this.lbUser.Size = new System.Drawing.Size(86, 21);
            this.lbUser.Style = Sunny.UI.UIStyle.Custom;
            this.lbUser.TabIndex = 0;
            this.lbUser.Text = "User:";
            this.lbUser.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // txPwd
            // 
            this.txPwd.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txPwd.FillColor = System.Drawing.Color.White;
            this.txPwd.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.txPwd.Location = new System.Drawing.Point(423, 12);
            this.txPwd.Margin = new System.Windows.Forms.Padding(4);
            this.txPwd.Maximum = 2147483647D;
            this.txPwd.MaxLength = 100;
            this.txPwd.Minimum = -2147483648D;
            this.txPwd.Name = "txPwd";
            this.txPwd.Padding = new System.Windows.Forms.Padding(5);
            this.txPwd.PasswordChar = '*';
            this.txPwd.Size = new System.Drawing.Size(135, 29);
            this.txPwd.Style = Sunny.UI.UIStyle.Custom;
            this.txPwd.TabIndex = 4;
            // 
            // lbRole
            // 
            this.lbRole.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbRole.Location = new System.Drawing.Point(7, 58);
            this.lbRole.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbRole.Name = "lbRole";
            this.lbRole.Size = new System.Drawing.Size(79, 31);
            this.lbRole.Style = Sunny.UI.UIStyle.Custom;
            this.lbRole.TabIndex = 0;
            this.lbRole.Text = "Role:";
            this.lbRole.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbPwd
            // 
            this.lbPwd.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbPwd.Location = new System.Drawing.Point(319, 16);
            this.lbPwd.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbPwd.Name = "lbPwd";
            this.lbPwd.Size = new System.Drawing.Size(96, 21);
            this.lbPwd.Style = Sunny.UI.UIStyle.Custom;
            this.lbPwd.TabIndex = 0;
            this.lbPwd.Text = "Password:";
            this.lbPwd.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // cmbUser
            // 
            this.cmbUser.DisplayMember = "Text";
            this.cmbUser.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbUser.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbUser.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cmbUser.FocusHighlightColor = System.Drawing.Color.White;
            this.cmbUser.ItemHeight = 23;
            this.cmbUser.Location = new System.Drawing.Point(87, 12);
            this.cmbUser.Margin = new System.Windows.Forms.Padding(4);
            this.cmbUser.Name = "cmbUser";
            this.cmbUser.Size = new System.Drawing.Size(223, 29);
            this.cmbUser.Style = DevComponents.DotNetBar.eDotNetBarStyle.Office2003;
            this.cmbUser.TabIndex = 2;
            this.cmbUser.WatermarkEnabled = false;
            this.cmbUser.SelectionChangeCommitted += new System.EventHandler(this.cmbUser_SelectionChangeCommitted);
            // 
            // cmbRole
            // 
            this.cmbRole.DisplayMember = "Text";
            this.cmbRole.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbRole.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbRole.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cmbRole.FocusHighlightColor = System.Drawing.Color.SkyBlue;
            this.cmbRole.ItemHeight = 23;
            this.cmbRole.Location = new System.Drawing.Point(87, 60);
            this.cmbRole.Margin = new System.Windows.Forms.Padding(4);
            this.cmbRole.Name = "cmbRole";
            this.cmbRole.Size = new System.Drawing.Size(223, 29);
            this.cmbRole.Style = DevComponents.DotNetBar.eDotNetBarStyle.Office2003;
            this.cmbRole.TabIndex = 3;
            this.cmbRole.WatermarkEnabled = false;
            this.cmbRole.SelectionChangeCommitted += new System.EventHandler(this.cmbRole_SelectionChangeCommitted);
            // 
            // panelEx2
            // 
            this.panelEx2.Controls.Add(this.btnBrowse);
            this.panelEx2.Controls.Add(this.cmbLanguage);
            this.panelEx2.Controls.Add(this.lbDiscCode);
            this.panelEx2.Controls.Add(this.txRptPrtPath);
            this.panelEx2.Controls.Add(this.btnDbSetting);
            this.panelEx2.Controls.Add(this.cmbDiscList);
            this.panelEx2.Controls.Add(this.lbDbName);
            this.panelEx2.Controls.Add(this.lbSelLang);
            this.panelEx2.Controls.Add(this.lbRptPrtPath);
            this.panelEx2.Controls.Add(this.lbDb);
            this.panelEx2.Controls.Add(this.lbServerName);
            this.panelEx2.Controls.Add(this.lbServer);
            this.panelEx2.Location = new System.Drawing.Point(4, 9);
            this.panelEx2.Margin = new System.Windows.Forms.Padding(4);
            this.panelEx2.Name = "panelEx2";
            this.panelEx2.Size = new System.Drawing.Size(568, 204);
            this.panelEx2.Style.Alignment = System.Drawing.StringAlignment.Center;
            this.panelEx2.Style.Border = DevComponents.DotNetBar.eBorderType.SingleLine;
            this.panelEx2.Style.CornerType = DevComponents.DotNetBar.eCornerType.Rounded;
            this.panelEx2.Style.GradientAngle = 90;
            this.panelEx2.TabIndex = 7;
            // 
            // btnBrowse
            // 
            this.btnBrowse.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnBrowse.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnBrowse.Font = new System.Drawing.Font("Tahoma", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnBrowse.Location = new System.Drawing.Point(523, 124);
            this.btnBrowse.Margin = new System.Windows.Forms.Padding(4);
            this.btnBrowse.Name = "btnBrowse";
            this.btnBrowse.Size = new System.Drawing.Size(35, 26);
            this.btnBrowse.Style = Sunny.UI.UIStyle.Custom;
            this.btnBrowse.TabIndex = 4;
            this.btnBrowse.Text = "...";
            this.btnBrowse.Click += new System.EventHandler(this.btnBrouse_Click);
            // 
            // cmbLanguage
            // 
            this.cmbLanguage.DisplayMember = "Text";
            this.cmbLanguage.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbLanguage.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbLanguage.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cmbLanguage.FormattingEnabled = true;
            this.cmbLanguage.ItemHeight = 23;
            this.cmbLanguage.Location = new System.Drawing.Point(87, 162);
            this.cmbLanguage.Margin = new System.Windows.Forms.Padding(4);
            this.cmbLanguage.Name = "cmbLanguage";
            this.cmbLanguage.Size = new System.Drawing.Size(223, 29);
            this.cmbLanguage.Style = DevComponents.DotNetBar.eDotNetBarStyle.Office2003;
            this.cmbLanguage.TabIndex = 5;
            this.cmbLanguage.SelectionChangeCommitted += new System.EventHandler(this.cmbLanguage_SelectionChangeCommitted);
            // 
            // lbDiscCode
            // 
            this.lbDiscCode.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbDiscCode.Location = new System.Drawing.Point(319, 161);
            this.lbDiscCode.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbDiscCode.Name = "lbDiscCode";
            this.lbDiscCode.Size = new System.Drawing.Size(96, 29);
            this.lbDiscCode.Style = Sunny.UI.UIStyle.Custom;
            this.lbDiscCode.TabIndex = 0;
            this.lbDiscCode.Text = "Disc Code:";
            this.lbDiscCode.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // txRptPrtPath
            // 
            this.txRptPrtPath.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txRptPrtPath.FillColor = System.Drawing.Color.White;
            this.txRptPrtPath.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.txRptPrtPath.Location = new System.Drawing.Point(87, 124);
            this.txRptPrtPath.Margin = new System.Windows.Forms.Padding(4);
            this.txRptPrtPath.Maximum = 2147483647D;
            this.txRptPrtPath.Minimum = -2147483648D;
            this.txRptPrtPath.Name = "txRptPrtPath";
            this.txRptPrtPath.Padding = new System.Windows.Forms.Padding(5);
            this.txRptPrtPath.Size = new System.Drawing.Size(428, 29);
            this.txRptPrtPath.Style = Sunny.UI.UIStyle.Custom;
            this.txRptPrtPath.TabIndex = 3;
            // 
            // btnDbSetting
            // 
            this.btnDbSetting.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDbSetting.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnDbSetting.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnDbSetting.Location = new System.Drawing.Point(423, 12);
            this.btnDbSetting.Margin = new System.Windows.Forms.Padding(4);
            this.btnDbSetting.Name = "btnDbSetting";
            this.btnDbSetting.Size = new System.Drawing.Size(135, 68);
            this.btnDbSetting.Style = Sunny.UI.UIStyle.Custom;
            this.btnDbSetting.TabIndex = 1;
            this.btnDbSetting.Text = "DB Setting";
            this.btnDbSetting.Click += new System.EventHandler(this.btnDbSetting_Click);
            // 
            // cmbDiscList
            // 
            this.cmbDiscList.DisplayMember = "Text";
            this.cmbDiscList.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbDiscList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbDiscList.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cmbDiscList.FocusHighlightColor = System.Drawing.Color.SkyBlue;
            this.cmbDiscList.Font = new System.Drawing.Font("ËÎÌå", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.cmbDiscList.ItemHeight = 15;
            this.cmbDiscList.Location = new System.Drawing.Point(423, 162);
            this.cmbDiscList.Margin = new System.Windows.Forms.Padding(4);
            this.cmbDiscList.Name = "cmbDiscList";
            this.cmbDiscList.Size = new System.Drawing.Size(133, 21);
            this.cmbDiscList.Style = DevComponents.DotNetBar.eDotNetBarStyle.Office2003;
            this.cmbDiscList.TabIndex = 6;
            this.cmbDiscList.WatermarkEnabled = false;
            // 
            // lbDbName
            // 
            this.lbDbName.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.lbDbName.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbDbName.Location = new System.Drawing.Point(87, 51);
            this.lbDbName.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbDbName.Name = "lbDbName";
            this.lbDbName.Size = new System.Drawing.Size(328, 29);
            this.lbDbName.Style = Sunny.UI.UIStyle.Custom;
            this.lbDbName.TabIndex = 2;
            this.lbDbName.Text = "Database Name";
            this.lbDbName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbSelLang
            // 
            this.lbSelLang.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbSelLang.Location = new System.Drawing.Point(0, 164);
            this.lbSelLang.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbSelLang.Name = "lbSelLang";
            this.lbSelLang.Size = new System.Drawing.Size(86, 28);
            this.lbSelLang.Style = Sunny.UI.UIStyle.Custom;
            this.lbSelLang.TabIndex = 0;
            this.lbSelLang.Text = "Language:";
            this.lbSelLang.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbRptPrtPath
            // 
            this.lbRptPrtPath.AutoSize = true;
            this.lbRptPrtPath.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbRptPrtPath.Location = new System.Drawing.Point(7, 101);
            this.lbRptPrtPath.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbRptPrtPath.Name = "lbRptPrtPath";
            this.lbRptPrtPath.Size = new System.Drawing.Size(204, 21);
            this.lbRptPrtPath.Style = Sunny.UI.UIStyle.Custom;
            this.lbRptPrtPath.TabIndex = 0;
            this.lbRptPrtPath.Text = "Report(.pdf) Generate To:";
            this.lbRptPrtPath.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbDb
            // 
            this.lbDb.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbDb.Location = new System.Drawing.Point(0, 51);
            this.lbDb.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbDb.Name = "lbDb";
            this.lbDb.Size = new System.Drawing.Size(86, 22);
            this.lbDb.Style = Sunny.UI.UIStyle.Custom;
            this.lbDb.TabIndex = 0;
            this.lbDb.Text = "Database:";
            this.lbDb.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbServerName
            // 
            this.lbServerName.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.lbServerName.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbServerName.Location = new System.Drawing.Point(87, 12);
            this.lbServerName.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbServerName.Name = "lbServerName";
            this.lbServerName.Size = new System.Drawing.Size(328, 29);
            this.lbServerName.Style = Sunny.UI.UIStyle.Custom;
            this.lbServerName.TabIndex = 2;
            this.lbServerName.Text = "Server Name";
            this.lbServerName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbServer
            // 
            this.lbServer.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbServer.Location = new System.Drawing.Point(0, 12);
            this.lbServer.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbServer.Name = "lbServer";
            this.lbServer.Size = new System.Drawing.Size(86, 22);
            this.lbServer.Style = Sunny.UI.UIStyle.Custom;
            this.lbServer.TabIndex = 0;
            this.lbServer.Text = "Server:";
            this.lbServer.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // OVRLoginForm
            // 
            this.AcceptButton = this.btnLogin;
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(577, 400);
            this.Controls.Add(this.panelEx1);
            this.Margin = new System.Windows.Forms.Padding(4);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRLoginForm";
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "LOGIN";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.OVRLogin_FormClosing);
            this.Load += new System.EventHandler(this.OVRLogin_Load);
            this.panelEx1.ResumeLayout(false);
            this.panelEx3.ResumeLayout(false);
            this.panelEx2.ResumeLayout(false);
            this.panelEx2.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        public System.Data.SqlClient.SqlConnection SqlCon
        {
            get { return sqlConnection; }
        }

        public int RoleID
        {
            get { return iRoleID; }
        }

        public string DiscCode
        {
            get { return cmbDiscList.Text; }
        }

        private void ComboBoxSetup()
        {
            SqlCommand cmdSelect = new SqlCommand("Proc_GetOperatorsInfo", sqlConnection);
            cmdSelect.CommandType = CommandType.StoredProcedure;
            cmdSelect.UpdatedRowSource = UpdateRowSource.None;
            daUser.SelectCommand = cmdSelect;

            SqlCommand cmdSelRole = new SqlCommand("Proc_GetOperatorRoles", sqlConnection);
            cmdSelRole.CommandType = CommandType.StoredProcedure;
            cmdSelRole.Parameters.Add(new SqlParameter("@PersonID", 0));
            cmdSelRole.UpdatedRowSource = UpdateRowSource.None;
            daRole.SelectCommand = cmdSelRole;
        }

        private void UpdateUserList()
        {
            dtUserTable.Clear();
            daUser.Fill(dtUserTable);

            cmbUser.DataSource = dtUserTable;
            cmbUser.DisplayMember = "F_PersonLongName";
            cmbUser.ValueMember = "F_PersonID";

            DataRow[] drSelRows = dtUserTable.Select(String.Format("F_PersonID = {0}", cmbUser.SelectedValue));
            if (drSelRows.Length > 0)
            {
                strUserPassword = drSelRows[0]["F_PassWord"].ToString();
            }
        }

        private void UpdateRoleList()
        {
            dtRoleTable.Clear();
            daRole.SelectCommand.Parameters["@PersonID"].Value = cmbUser.SelectedValue;
            daRole.Fill(dtRoleTable);

            cmbRole.DataSource = dtRoleTable;
            cmbRole.DisplayMember = "F_LongRoleName";
            cmbRole.ValueMember = "F_RoleID";

            iRoleID = Convert.ToInt32(cmbRole.SelectedValue);
        }

        private void UpdateDisciplineList(string strItemSel)
        {
            string strPath = System.IO.Path.GetDirectoryName(Application.ExecutablePath) + "\\Plugin";
            string[] files = Directory.GetFiles(strPath, "*.dll");
            foreach (string file in files)
            {
                try
                {
                    //System.Reflection.Assembly asmPlugin = System.Reflection.Assembly.LoadFile(file);
                    System.Reflection.Assembly asmPlugin = System.Reflection.Assembly.LoadFrom(file);
                    Type[] types = asmPlugin.GetTypes();
                    foreach (Type type in types)
                    {
                        if (type.IsSubclassOf(typeof(OVRPluginBase)))
                        {
                            string strDiscCode = Path.GetFileNameWithoutExtension(file);
                            int iIndex = cmbDiscList.Items.Add(strDiscCode);
                            if (strItemSel.ToUpper() == strDiscCode.ToUpper())
                                cmbDiscList.SelectedIndex = iIndex;

                            break;
                        }
                    }
                }
                catch (System.Exception ex)
                {
                    UIMessageDialog.ShowMessageDialog(ex.Message,"Information",false,this.Style);
                }
            }
        }

        private void LoadSystemSettings()
        {
            string strAppDir = Path.GetDirectoryName(Application.ExecutablePath);

            string strDiscCode = ConfigurationManager.GetUserSettingString("DiscCode").Trim();
            string strPrtPath = ConfigurationManager.GetUserSettingString("PrtPath").Trim();
            string strCurCul = ConfigurationManager.GetUserSettingString("CultureName").Trim();
            string strConnectionString = ConfigurationManager.GetUserSettingString("ConnectionString").Trim();
            // Decrypt Password
            strConnectionString = PasswordProcessing(strConnectionString, true);

            if ("1" == ConfigurationManager.GetUserSettingString("DCEnable").Trim() ||
                (strDiscCode != null && strDiscCode.Length > 0) )
            {
                this.cmbDiscList.Enabled = true;
            }
            else
                this.cmbDiscList.Enabled = false;

            // Get the Language File
            string strLangFilePath = strAppDir + "\\Localization\\";
            string strDefCul = System.Globalization.CultureInfo.CurrentCulture.Name;
            string strDefLangFile = null;
            string strCurLangFile = null;

            DataRow drDef = dtLanguageTable.NewRow();
            drDef["F_Description"] = "Default";
            drDef["F_CulName"] = "Default";
            dtLanguageTable.Rows.Add(drDef);

            string[] files = Directory.GetFiles(strLangFilePath, "*.xml");
            foreach (string file in files)
            {
                System.Xml.XmlReader xmlReader = System.Xml.XmlReader.Create(file);
                xmlReader.ReadToDescendant("Localization");

                DataRow dr = dtLanguageTable.NewRow();
                dr["F_Description"] = xmlReader["description"];
                dr["F_CulName"] = xmlReader["cultureName"];
                dr["F_FileName"] = Path.GetFileName(file);
                dtLanguageTable.Rows.Add(dr);

                if (xmlReader["cultureName"] == strDefCul)
                    strDefLangFile = dr["F_FileName"].ToString();

                if (xmlReader["cultureName"] == strCurCul)
                {
                    strCurLangFile = dr["F_FileName"].ToString();
                }
            }

            if (strDefLangFile == null)
            {
                if (dtLanguageTable.Rows.Count > 1)
                    drDef["F_FileName"] = dtLanguageTable.Rows[1]["F_FileName"];
                else
                    drDef["F_FileName"] = "";
            }

            if (strCurLangFile == null)
            {
                strCurCul = "Default";
                strCurLangFile = drDef["F_FileName"].ToString();
            }

            cmbLanguage.DataSource = dtLanguageTable;
            cmbLanguage.DisplayMember = "F_Description";
            cmbLanguage.ValueMember = "F_CulName";
            cmbLanguage.SelectedValue = strCurCul;

            string strLangFile = strLangFilePath + strCurLangFile;

            if (!LocalizationRecourceManager.LoadLocalResource(strLangFile))
                UIMessageDialog.ShowMessageDialog("Failed to Load Language Resource!", "OVR System Error", false,this.Style);

            this.sqlConnection.ConnectionString = strConnectionString;
            this.lbServerName.Text = this.sqlConnection.DataSource;
            this.lbDbName.Text = this.sqlConnection.Database;
            this.txRptPrtPath.Text = strPrtPath;

            UpdateDisciplineList(strDiscCode);

            Localization();
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "TitleLogin");
            this.lbServer.Text = LocalizationRecourceManager.GetString(strSectionName, "Server");
            this.lbDb.Text = LocalizationRecourceManager.GetString(strSectionName, "DataBase");
            this.lbUser.Text = LocalizationRecourceManager.GetString(strSectionName, "User");
            this.lbSelLang.Text = LocalizationRecourceManager.GetString(strSectionName, "Language");
            this.lbRole.Text = LocalizationRecourceManager.GetString(strSectionName, "Role");
            this.lbPwd.Text = LocalizationRecourceManager.GetString(strSectionName, "Password");
            this.lbDiscCode.Text = LocalizationRecourceManager.GetString(strSectionName, "DiscCode");
            this.lbRptPrtPath.Text = LocalizationRecourceManager.GetString(strSectionName, "PrintDir");
            this.btnDbSetting.Text = LocalizationRecourceManager.GetString(strSectionName, "DbSetting");
            this.btnLogin.Text = LocalizationRecourceManager.GetString(strSectionName, "Login");
        }

        private bool TestConnection()
        {
            try
            {
                if (this.sqlConnection.ConnectionString == null || 
                    this.sqlConnection.ConnectionString.Trim() == "")
                {
                    this.ActiveControl = this.btnDbSetting;
                    return false;
                }

                UpdateUserList();
                UpdateRoleList();
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                string strMsg = "";
                for (int i = 0; i < ex.Errors.Count; i++)
                {
                    string strTemp = String.Format("Index #{0}\nErrorNumber: {1}\nMessage: {2}\nLineNumber: {3}\n",
                                                   i, ex.Errors[i].Number, ex.Errors[i].Message, ex.Errors[i].LineNumber);
                    strTemp += "Source: " + ex.Errors[i].Source + "\n" + "Procedure: " + ex.Errors[i].Procedure + "\n";

                    strMsg += strTemp;
                }
                string strCaption = LocalizationRecourceManager.GetString(strSectionName, "DBConnectingError");
                UIMessageDialog.ShowMessageDialog(strMsg, strCaption, false,this.Style);
                this.ActiveControl = this.btnDbSetting;
                return false;
            }
            this.ActiveControl = this.txPwd;
            return true;
        }

        private bool UserValidate()
        {
            try
            {
                if (OVRSimpleEncryption.Decrypt(strUserPassword) == txPwd.Text)
                {
                    return true;
                }
            }
            catch (System.Exception ex)
            {
            }
            return true;
        }

        private bool LicenseValidate()
        {
            string strDateStart = "2011-04-12 00:00";
            string strDateEnd = "2111-10-01 00:00";
            DateTime dtDateStart = Convert.ToDateTime(strDateStart);
            DateTime dtDateEnd = Convert.ToDateTime(strDateEnd);
            DateTime dtDateNow = DateTime.Now;   

            try
            {
                if (DateTime.Compare(dtDateNow, dtDateStart) > 0 && DateTime.Compare(dtDateEnd, dtDateNow) > 0)
                {
                    return true;
                }
            }
            catch (System.Exception ex)
            {
            }
            return false;
        }

        private string PasswordProcessing(string strConnectionString, bool bEncrypt)
        {
            string strNewConnectionString = null;
            string strPassword = null, strTemp = null;

            int iSta, iEnd;
            iSta = strConnectionString.IndexOf("Password=", 0, StringComparison.OrdinalIgnoreCase);
            if (iSta >= 0)
            {
                iSta += 9;
                iEnd = strConnectionString.IndexOf(';', iSta);
                if (iEnd < iSta)
                    strPassword = strConnectionString.Substring(iSta, strConnectionString.Length - iSta).Trim();
                else
                    strPassword = strConnectionString.Substring(iSta, iEnd - iSta).Trim();

                try
                {
                    if (bEncrypt)
                        strTemp = OVRSimpleEncryption.Encrypt(strPassword);
                    else
                        strTemp = OVRSimpleEncryption.Decrypt(strPassword);
                }
                catch (System.Exception ex)
                {
                }

                strNewConnectionString = strConnectionString.Replace("Password=" + strPassword, "Password=" + strTemp);
            }
            return strNewConnectionString;
        }

        private void OVRLogin_Load(object sender, EventArgs e)
        {
            LoadSystemSettings();
            bool bConnection = TestConnection();
            this.cmbUser.Enabled = bConnection;
            this.cmbRole.Enabled = bConnection;
            this.txPwd.Enabled = bConnection;
            this.btnLogin.Enabled = bConnection;
        }

        private void OVRLogin_FormClosing(object sender, FormClosingEventArgs e)
        {
            ConfigurationManager.SetUserSettingString("CultureName", cmbLanguage.SelectedValue.ToString());
            ConfigurationManager.SetUserSettingString("DiscCode", cmbDiscList.Text);
            ConfigurationManager.SetUserSettingString("PrtPath", txRptPrtPath.Text);

            // Encrypt Password
            string strEncryptConnectionString = PasswordProcessing(sqlConnection.ConnectionString, false);
            ConfigurationManager.SetUserSettingString("ConnectionString", strEncryptConnectionString);
        }

        private void btnDbSetting_Click(object sender, EventArgs e)
        {

            OVRDBSettingForm dialog = new OVRDBSettingForm();
            dialog.ConnectionString = sqlConnection.ConnectionString;
            DialogResult dlgRes = dialog.ShowDialog();

            if (dlgRes == DialogResult.OK)
            {
                sqlConnection.ConnectionString = dialog.ConnectionString;
                lbServerName.Text = sqlConnection.DataSource;
                lbDbName.Text = sqlConnection.Database;
                bool bConnection = TestConnection();
                this.cmbUser.Enabled = bConnection;
                this.cmbRole.Enabled = bConnection;
                this.txPwd.Enabled = bConnection;
                this.btnLogin.Enabled = bConnection;
            }
        }

        private void btnBrouse_Click(object sender, EventArgs e)
        {
            using (FolderBrowserDialog dlg = new FolderBrowserDialog())
            {
                if (dlg.ShowDialog(this) == DialogResult.OK)
                    txRptPrtPath.Text = dlg.SelectedPath;
            }
        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            if (!btnLogin.Enabled)
                return;

            if (cmbDiscList.SelectedIndex == -1)
            {
                UIMessageDialog.ShowMessageDialog(LocalizationRecourceManager.GetString(strSectionName, "DiscCodeNullException"),"Information",false,this.Style);
                return;
            }

            if (UserValidate() && LicenseValidate())
            {
                this.DialogResult = DialogResult.OK;
                Close();
            }
            else
            {
                UIMessageDialog.ShowMessageDialog(LocalizationRecourceManager.GetString(strSectionName, "PwdIncorrect"), "Information", false, this.Style);
            }
        }

        private void cmbUser_SelectionChangeCommitted(object sender, EventArgs e)
        {
            UpdateRoleList();

            DataRow[] drSelRows = dtUserTable.Select(String.Format("F_PersonID = {0}", cmbUser.SelectedValue));
            if (drSelRows.Length > 0)
            {
                strUserPassword = drSelRows[0]["F_PassWord"].ToString();
            }
        }

        private void cmbRole_SelectionChangeCommitted(object sender, EventArgs e)
        {
            iRoleID = Convert.ToInt32(cmbRole.SelectedValue);
        }

        private void cmbLanguage_SelectionChangeCommitted(object sender, EventArgs e)
        {
            string strPath = Path.GetDirectoryName(Application.ExecutablePath) + "\\Localization\\";
            string strFilterExp = String.Format("F_CulName = '{0}'", cmbLanguage.SelectedValue.ToString());
            DataRow[] drSel = dtLanguageTable.Select(strFilterExp);
            if (drSel.Length < 0) return;

            LocalizationRecourceManager.LoadLocalResource(strPath + drSel[0]["F_FileName"].ToString());

            Localization();
        }

        private void panelEx1_Click(object sender, EventArgs e)
        {

        }

    }
}