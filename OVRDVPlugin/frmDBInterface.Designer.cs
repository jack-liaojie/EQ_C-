namespace OVRDVPlugin
{
    partial class frmDBInterface
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
            this.panel1 = new System.Windows.Forms.Panel();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.btnConnect = new DevComponents.DotNetBar.ButtonX();
            this.cmbDatabase = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.label4 = new System.Windows.Forms.Label();
            this.txtPassword = new System.Windows.Forms.TextBox();
            this.密码 = new System.Windows.Forms.Label();
            this.txtUser = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.txtServer = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.panel2 = new System.Windows.Forms.Panel();
            this.label5 = new System.Windows.Forms.Label();
            this.dgvOuterMatchList = new System.Windows.Forms.DataGridView();
            this.panel3 = new System.Windows.Forms.Panel();
            this.lineNumbers_For_RichTextBox1 = new LineNumbers.LineNumbers_For_RichTextBox();
            this.TxtMsg = new System.Windows.Forms.RichTextBox();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.btnShowDetailResult = new DevComponents.DotNetBar.ButtonX();
            this.btnImportDetailResult = new DevComponents.DotNetBar.ButtonX();
            this.MatchResult = new System.Windows.Forms.GroupBox();
            this.btnShowMatchResult = new DevComponents.DotNetBar.ButtonX();
            this.btnImprotMatchResult = new DevComponents.DotNetBar.ButtonX();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.btnShowActionCode = new DevComponents.DotNetBar.ButtonX();
            this.btnImportActionList = new DevComponents.DotNetBar.ButtonX();
            this.dgvImportInfo = new System.Windows.Forms.DataGridView();
            this.panel4 = new System.Windows.Forms.Panel();
            this.label6 = new System.Windows.Forms.Label();
            this.dgvMatchList = new System.Windows.Forms.DataGridView();
            this.lbOutMatchInfo = new System.Windows.Forms.Label();
            this.txtOuterMatchCode = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.txtInnerMatchID = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.cmbRoundNo = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.panel1.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.panel2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvOuterMatchList)).BeginInit();
            this.panel3.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.MatchResult.SuspendLayout();
            this.groupBox2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvImportInfo)).BeginInit();
            this.panel4.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchList)).BeginInit();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.groupBox1);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(1156, 66);
            this.panel1.TabIndex = 0;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.btnConnect);
            this.groupBox1.Controls.Add(this.cmbDatabase);
            this.groupBox1.Controls.Add(this.label4);
            this.groupBox1.Controls.Add(this.txtPassword);
            this.groupBox1.Controls.Add(this.密码);
            this.groupBox1.Controls.Add(this.txtUser);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.txtServer);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Location = new System.Drawing.Point(3, 3);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(1065, 56);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "DBSetting";
            // 
            // btnConnect
            // 
            this.btnConnect.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnConnect.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnConnect.Cursor = System.Windows.Forms.Cursors.Default;
            this.btnConnect.Location = new System.Drawing.Point(930, 20);
            this.btnConnect.Name = "btnConnect";
            this.btnConnect.Size = new System.Drawing.Size(99, 22);
            this.btnConnect.TabIndex = 19;
            this.btnConnect.Text = "Connect";
            this.btnConnect.Click += new System.EventHandler(this.btnConnect_Click);
            // 
            // cmbDatabase
            // 
            this.cmbDatabase.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbDatabase.ItemHeight = 15;
            this.cmbDatabase.Location = new System.Drawing.Point(680, 20);
            this.cmbDatabase.Name = "cmbDatabase";
            this.cmbDatabase.Size = new System.Drawing.Size(141, 21);
            this.cmbDatabase.Style = DevComponents.DotNetBar.eDotNetBarStyle.Office2003;
            this.cmbDatabase.TabIndex = 18;
            this.cmbDatabase.WatermarkEnabled = false;
            this.cmbDatabase.DropDown += new System.EventHandler(this.cmbDatabase_DropDown);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(624, 24);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(53, 12);
            this.label4.TabIndex = 13;
            this.label4.Text = "DataBase";
            // 
            // txtPassword
            // 
            this.txtPassword.Location = new System.Drawing.Point(468, 20);
            this.txtPassword.Name = "txtPassword";
            this.txtPassword.Size = new System.Drawing.Size(141, 21);
            this.txtPassword.TabIndex = 17;
            // 
            // 密码
            // 
            this.密码.AutoSize = true;
            this.密码.Location = new System.Drawing.Point(413, 24);
            this.密码.Name = "密码";
            this.密码.Size = new System.Drawing.Size(53, 12);
            this.密码.TabIndex = 14;
            this.密码.Text = "Password";
            // 
            // txtUser
            // 
            this.txtUser.Location = new System.Drawing.Point(256, 20);
            this.txtUser.Name = "txtUser";
            this.txtUser.Size = new System.Drawing.Size(141, 21);
            this.txtUser.TabIndex = 16;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(218, 24);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(29, 12);
            this.label2.TabIndex = 12;
            this.label2.Text = "User";
            // 
            // txtServer
            // 
            this.txtServer.Location = new System.Drawing.Point(56, 20);
            this.txtServer.Name = "txtServer";
            this.txtServer.Size = new System.Drawing.Size(141, 21);
            this.txtServer.TabIndex = 15;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(0, 24);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(53, 12);
            this.label1.TabIndex = 11;
            this.label1.Text = "DBServer";
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.label5);
            this.panel2.Controls.Add(this.dgvOuterMatchList);
            this.panel2.Location = new System.Drawing.Point(0, 71);
            this.panel2.Margin = new System.Windows.Forms.Padding(3, 30, 3, 80);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(444, 231);
            this.panel2.TabIndex = 1;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(12, 9);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(89, 12);
            this.label5.TabIndex = 5;
            this.label5.Text = "OuterMatchList";
            // 
            // dgvOuterMatchList
            // 
            this.dgvOuterMatchList.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvOuterMatchList.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.dgvOuterMatchList.Location = new System.Drawing.Point(0, 27);
            this.dgvOuterMatchList.Margin = new System.Windows.Forms.Padding(3, 30, 3, 3);
            this.dgvOuterMatchList.MultiSelect = false;
            this.dgvOuterMatchList.Name = "dgvOuterMatchList";
            this.dgvOuterMatchList.RowTemplate.Height = 23;
            this.dgvOuterMatchList.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvOuterMatchList.Size = new System.Drawing.Size(444, 204);
            this.dgvOuterMatchList.TabIndex = 2;
            this.dgvOuterMatchList.SelectionChanged += new System.EventHandler(this.dgvOuterMatchList_SelectionChanged);
            // 
            // panel3
            // 
            this.panel3.Controls.Add(this.lineNumbers_For_RichTextBox1);
            this.panel3.Controls.Add(this.TxtMsg);
            this.panel3.Controls.Add(this.groupBox3);
            this.panel3.Controls.Add(this.MatchResult);
            this.panel3.Controls.Add(this.groupBox2);
            this.panel3.Controls.Add(this.dgvImportInfo);
            this.panel3.Location = new System.Drawing.Point(0, 308);
            this.panel3.Margin = new System.Windows.Forms.Padding(3, 3, 40, 3);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(1156, 310);
            this.panel3.TabIndex = 2;
            // 
            // lineNumbers_For_RichTextBox1
            // 
            this.lineNumbers_For_RichTextBox1._SeeThroughMode_ = false;
            this.lineNumbers_For_RichTextBox1.AutoSizing = true;
            this.lineNumbers_For_RichTextBox1.BackgroundGradient_AlphaColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.lineNumbers_For_RichTextBox1.BackgroundGradient_BetaColor = System.Drawing.Color.LightSteelBlue;
            this.lineNumbers_For_RichTextBox1.BackgroundGradient_Direction = System.Drawing.Drawing2D.LinearGradientMode.Horizontal;
            this.lineNumbers_For_RichTextBox1.BorderLines_Color = System.Drawing.Color.SlateGray;
            this.lineNumbers_For_RichTextBox1.BorderLines_Style = System.Drawing.Drawing2D.DashStyle.Dot;
            this.lineNumbers_For_RichTextBox1.BorderLines_Thickness = 1F;
            this.lineNumbers_For_RichTextBox1.DockSide = LineNumbers.LineNumbers_For_RichTextBox.LineNumberDockSide.Left;
            this.lineNumbers_For_RichTextBox1.GridLines_Color = System.Drawing.Color.SlateGray;
            this.lineNumbers_For_RichTextBox1.GridLines_Style = System.Drawing.Drawing2D.DashStyle.Dot;
            this.lineNumbers_For_RichTextBox1.GridLines_Thickness = 1F;
            this.lineNumbers_For_RichTextBox1.LineNrs_Alignment = System.Drawing.ContentAlignment.TopRight;
            this.lineNumbers_For_RichTextBox1.LineNrs_AntiAlias = true;
            this.lineNumbers_For_RichTextBox1.LineNrs_AsHexadecimal = false;
            this.lineNumbers_For_RichTextBox1.LineNrs_ClippedByItemRectangle = true;
            this.lineNumbers_For_RichTextBox1.LineNrs_LeadingZeroes = true;
            this.lineNumbers_For_RichTextBox1.LineNrs_Offset = new System.Drawing.Size(0, 0);
            this.lineNumbers_For_RichTextBox1.Location = new System.Drawing.Point(764, 3);
            this.lineNumbers_For_RichTextBox1.Margin = new System.Windows.Forms.Padding(0);
            this.lineNumbers_For_RichTextBox1.MarginLines_Color = System.Drawing.Color.SlateGray;
            this.lineNumbers_For_RichTextBox1.MarginLines_Side = LineNumbers.LineNumbers_For_RichTextBox.LineNumberDockSide.Right;
            this.lineNumbers_For_RichTextBox1.MarginLines_Style = System.Drawing.Drawing2D.DashStyle.Solid;
            this.lineNumbers_For_RichTextBox1.MarginLines_Thickness = 1F;
            this.lineNumbers_For_RichTextBox1.Name = "lineNumbers_For_RichTextBox1";
            this.lineNumbers_For_RichTextBox1.Padding = new System.Windows.Forms.Padding(0, 0, 2, 0);
            this.lineNumbers_For_RichTextBox1.ParentRichTextBox = this.TxtMsg;
            this.lineNumbers_For_RichTextBox1.Show_BackgroundGradient = true;
            this.lineNumbers_For_RichTextBox1.Show_BorderLines = true;
            this.lineNumbers_For_RichTextBox1.Show_GridLines = true;
            this.lineNumbers_For_RichTextBox1.Show_LineNrs = true;
            this.lineNumbers_For_RichTextBox1.Show_MarginLines = true;
            this.lineNumbers_For_RichTextBox1.Size = new System.Drawing.Size(21, 298);
            this.lineNumbers_For_RichTextBox1.TabIndex = 18;
            // 
            // TxtMsg
            // 
            this.TxtMsg.Location = new System.Drawing.Point(786, 3);
            this.TxtMsg.Name = "TxtMsg";
            this.TxtMsg.Size = new System.Drawing.Size(367, 298);
            this.TxtMsg.TabIndex = 17;
            this.TxtMsg.Text = "";
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.btnShowDetailResult);
            this.groupBox3.Controls.Add(this.btnImportDetailResult);
            this.groupBox3.Location = new System.Drawing.Point(533, 246);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(232, 55);
            this.groupBox3.TabIndex = 16;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "DetailResult";
            // 
            // btnShowDetailResult
            // 
            this.btnShowDetailResult.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnShowDetailResult.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnShowDetailResult.Cursor = System.Windows.Forms.Cursors.Default;
            this.btnShowDetailResult.Location = new System.Drawing.Point(3, 20);
            this.btnShowDetailResult.Name = "btnShowDetailResult";
            this.btnShowDetailResult.Size = new System.Drawing.Size(107, 28);
            this.btnShowDetailResult.TabIndex = 13;
            this.btnShowDetailResult.Text = "Show DetailResult";
            this.btnShowDetailResult.Click += new System.EventHandler(this.btnShowDetailResult_Click);
            // 
            // btnImportDetailResult
            // 
            this.btnImportDetailResult.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnImportDetailResult.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnImportDetailResult.Cursor = System.Windows.Forms.Cursors.Default;
            this.btnImportDetailResult.Location = new System.Drawing.Point(120, 20);
            this.btnImportDetailResult.Name = "btnImportDetailResult";
            this.btnImportDetailResult.Size = new System.Drawing.Size(107, 28);
            this.btnImportDetailResult.TabIndex = 12;
            this.btnImportDetailResult.Text = "Import DetailResult";
            this.btnImportDetailResult.Click += new System.EventHandler(this.btnImportDetailResult_Click);
            // 
            // MatchResult
            // 
            this.MatchResult.Controls.Add(this.btnShowMatchResult);
            this.MatchResult.Controls.Add(this.btnImprotMatchResult);
            this.MatchResult.Location = new System.Drawing.Point(263, 246);
            this.MatchResult.Name = "MatchResult";
            this.MatchResult.Size = new System.Drawing.Size(232, 55);
            this.MatchResult.TabIndex = 15;
            this.MatchResult.TabStop = false;
            this.MatchResult.Text = "MatchResult";
            // 
            // btnShowMatchResult
            // 
            this.btnShowMatchResult.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnShowMatchResult.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnShowMatchResult.Cursor = System.Windows.Forms.Cursors.Default;
            this.btnShowMatchResult.Location = new System.Drawing.Point(3, 20);
            this.btnShowMatchResult.Name = "btnShowMatchResult";
            this.btnShowMatchResult.Size = new System.Drawing.Size(107, 28);
            this.btnShowMatchResult.TabIndex = 15;
            this.btnShowMatchResult.Text = "Show MatchResult";
            this.btnShowMatchResult.Click += new System.EventHandler(this.btnShowMatchResult_Click);
            // 
            // btnImprotMatchResult
            // 
            this.btnImprotMatchResult.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnImprotMatchResult.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnImprotMatchResult.Cursor = System.Windows.Forms.Cursors.Default;
            this.btnImprotMatchResult.Location = new System.Drawing.Point(119, 20);
            this.btnImprotMatchResult.Name = "btnImprotMatchResult";
            this.btnImprotMatchResult.Size = new System.Drawing.Size(107, 28);
            this.btnImprotMatchResult.TabIndex = 14;
            this.btnImprotMatchResult.Text = "Import MatchResult";
            this.btnImprotMatchResult.Click += new System.EventHandler(this.btnImprotMatchResult_Click);
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.btnShowActionCode);
            this.groupBox2.Controls.Add(this.btnImportActionList);
            this.groupBox2.Location = new System.Drawing.Point(3, 246);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(232, 55);
            this.groupBox2.TabIndex = 14;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "ActionCode";
            // 
            // btnShowActionCode
            // 
            this.btnShowActionCode.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnShowActionCode.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnShowActionCode.Cursor = System.Windows.Forms.Cursors.Default;
            this.btnShowActionCode.Location = new System.Drawing.Point(3, 20);
            this.btnShowActionCode.Name = "btnShowActionCode";
            this.btnShowActionCode.Size = new System.Drawing.Size(107, 28);
            this.btnShowActionCode.TabIndex = 14;
            this.btnShowActionCode.Text = "Show ActionCode";
            this.btnShowActionCode.Click += new System.EventHandler(this.btnShowActionCode_Click);
            // 
            // btnImportActionList
            // 
            this.btnImportActionList.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnImportActionList.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnImportActionList.Cursor = System.Windows.Forms.Cursors.Default;
            this.btnImportActionList.Location = new System.Drawing.Point(117, 20);
            this.btnImportActionList.Name = "btnImportActionList";
            this.btnImportActionList.Size = new System.Drawing.Size(107, 28);
            this.btnImportActionList.TabIndex = 13;
            this.btnImportActionList.Text = "Import ActionCode";
            this.btnImportActionList.Click += new System.EventHandler(this.btnImportActionList_Click);
            // 
            // dgvImportInfo
            // 
            this.dgvImportInfo.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvImportInfo.Location = new System.Drawing.Point(0, 0);
            this.dgvImportInfo.Name = "dgvImportInfo";
            this.dgvImportInfo.RowTemplate.Height = 23;
            this.dgvImportInfo.Size = new System.Drawing.Size(765, 240);
            this.dgvImportInfo.TabIndex = 0;
            // 
            // panel4
            // 
            this.panel4.Controls.Add(this.label6);
            this.panel4.Controls.Add(this.dgvMatchList);
            this.panel4.Location = new System.Drawing.Point(599, 71);
            this.panel4.Margin = new System.Windows.Forms.Padding(3, 50, 3, 80);
            this.panel4.Name = "panel4";
            this.panel4.Size = new System.Drawing.Size(469, 229);
            this.panel4.TabIndex = 3;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(14, 9);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(89, 12);
            this.label6.TabIndex = 5;
            this.label6.Text = "InnerMatchList";
            // 
            // dgvMatchList
            // 
            this.dgvMatchList.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchList.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.dgvMatchList.Location = new System.Drawing.Point(0, 25);
            this.dgvMatchList.MultiSelect = false;
            this.dgvMatchList.Name = "dgvMatchList";
            this.dgvMatchList.RowTemplate.Height = 23;
            this.dgvMatchList.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvMatchList.Size = new System.Drawing.Size(469, 204);
            this.dgvMatchList.TabIndex = 0;
            this.dgvMatchList.SelectionChanged += new System.EventHandler(this.dgvMatchList_SelectionChanged);
            // 
            // lbOutMatchInfo
            // 
            this.lbOutMatchInfo.AutoSize = true;
            this.lbOutMatchInfo.Location = new System.Drawing.Point(450, 78);
            this.lbOutMatchInfo.Name = "lbOutMatchInfo";
            this.lbOutMatchInfo.Size = new System.Drawing.Size(89, 12);
            this.lbOutMatchInfo.TabIndex = 4;
            this.lbOutMatchInfo.Text = "OuterMatchCode";
            // 
            // txtOuterMatchCode
            // 
            this.txtOuterMatchCode.Location = new System.Drawing.Point(452, 107);
            this.txtOuterMatchCode.Name = "txtOuterMatchCode";
            this.txtOuterMatchCode.ReadOnly = true;
            this.txtOuterMatchCode.Size = new System.Drawing.Size(141, 21);
            this.txtOuterMatchCode.TabIndex = 5;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(450, 152);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(77, 12);
            this.label3.TabIndex = 4;
            this.label3.Text = "InnerMatchID";
            // 
            // txtInnerMatchID
            // 
            this.txtInnerMatchID.Location = new System.Drawing.Point(452, 181);
            this.txtInnerMatchID.Name = "txtInnerMatchID";
            this.txtInnerMatchID.ReadOnly = true;
            this.txtInnerMatchID.Size = new System.Drawing.Size(141, 21);
            this.txtInnerMatchID.TabIndex = 5;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(450, 238);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(47, 12);
            this.label7.TabIndex = 6;
            this.label7.Text = "RoundNo";
            // 
            // cmbRoundNo
            // 
            this.cmbRoundNo.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbRoundNo.ItemHeight = 15;
            this.cmbRoundNo.Location = new System.Drawing.Point(452, 263);
            this.cmbRoundNo.Name = "cmbRoundNo";
            this.cmbRoundNo.Size = new System.Drawing.Size(141, 21);
            this.cmbRoundNo.Style = DevComponents.DotNetBar.eDotNetBarStyle.Office2003;
            this.cmbRoundNo.TabIndex = 19;
            this.cmbRoundNo.WatermarkEnabled = false;
            this.cmbRoundNo.SelectionChangeCommitted += new System.EventHandler(this.cmbRoundNo_SelectionChangeCommitted);
            // 
            // frmDBInterface
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1156, 621);
            this.Controls.Add(this.cmbRoundNo);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.txtInnerMatchID);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.txtOuterMatchCode);
            this.Controls.Add(this.lbOutMatchInfo);
            this.Controls.Add(this.panel4);
            this.Controls.Add(this.panel3);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "frmDBInterface";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "DBInterface";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.frmDBInterface_FormClosing);
            this.Load += new System.EventHandler(this.frmDBInterface_Load);
            this.panel1.ResumeLayout(false);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvOuterMatchList)).EndInit();
            this.panel3.ResumeLayout(false);
            this.groupBox3.ResumeLayout(false);
            this.MatchResult.ResumeLayout(false);
            this.groupBox2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvImportInfo)).EndInit();
            this.panel4.ResumeLayout(false);
            this.panel4.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchList)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.DataGridView dgvImportInfo;
        private System.Windows.Forms.Panel panel4;
        private System.Windows.Forms.DataGridView dgvMatchList;
        private System.Windows.Forms.Label lbOutMatchInfo;
        private System.Windows.Forms.TextBox txtOuterMatchCode;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtInnerMatchID;
        private System.Windows.Forms.GroupBox groupBox1;
        private DevComponents.DotNetBar.ButtonX btnConnect;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbDatabase;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox txtPassword;
        private System.Windows.Forms.Label 密码;
        private System.Windows.Forms.TextBox txtUser;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtServer;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.DataGridView dgvOuterMatchList;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.GroupBox groupBox3;
        private DevComponents.DotNetBar.ButtonX btnShowDetailResult;
        private DevComponents.DotNetBar.ButtonX btnImportDetailResult;
        private System.Windows.Forms.GroupBox MatchResult;
        private DevComponents.DotNetBar.ButtonX btnShowMatchResult;
        private DevComponents.DotNetBar.ButtonX btnImprotMatchResult;
        private System.Windows.Forms.GroupBox groupBox2;
        private DevComponents.DotNetBar.ButtonX btnShowActionCode;
        private DevComponents.DotNetBar.ButtonX btnImportActionList;
        private System.Windows.Forms.RichTextBox TxtMsg;
        private System.Windows.Forms.Label label7;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbRoundNo;
        private LineNumbers.LineNumbers_For_RichTextBox lineNumbers_For_RichTextBox1;
    }
}