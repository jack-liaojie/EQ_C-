namespace AutoSports.OVRBDPlugin
{
    partial class SelfCheckErrorFrm
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
            this.lbPort = new DevComponents.DotNetBar.LabelX();
            this.listToCheckItems = new System.Windows.Forms.ListBox();
            this.btnRemoveCheck = new DevComponents.DotNetBar.ButtonX();
            this.btnAddCheck = new DevComponents.DotNetBar.ButtonX();
            this.dgvToCheckErr = new System.Windows.Forms.DataGridView();
            this.labelX1 = new DevComponents.DotNetBar.LabelX();
            this.dgvCheckResult = new System.Windows.Forms.DataGridView();
            this.labelX2 = new DevComponents.DotNetBar.LabelX();
            this.btnStartCheck = new DevComponents.DotNetBar.ButtonX();
            this.cmbLang = new System.Windows.Forms.ComboBox();
            this.labelX3 = new DevComponents.DotNetBar.LabelX();
            this.btnContinueCheck = new DevComponents.DotNetBar.ButtonX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvToCheckErr)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCheckResult)).BeginInit();
            this.SuspendLayout();
            // 
            // lbPort
            // 
            this.lbPort.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.lbPort.BackgroundStyle.Class = "";
            this.lbPort.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbPort.Location = new System.Drawing.Point(2, 2);
            this.lbPort.Name = "lbPort";
            this.lbPort.Size = new System.Drawing.Size(79, 18);
            this.lbPort.TabIndex = 3;
            this.lbPort.Text = "Check Items";
            // 
            // listToCheckItems
            // 
            this.listToCheckItems.FormattingEnabled = true;
            this.listToCheckItems.ItemHeight = 12;
            this.listToCheckItems.Location = new System.Drawing.Point(3, 21);
            this.listToCheckItems.Name = "listToCheckItems";
            this.listToCheckItems.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended;
            this.listToCheckItems.Size = new System.Drawing.Size(287, 316);
            this.listToCheckItems.TabIndex = 4;
            // 
            // btnRemoveCheck
            // 
            this.btnRemoveCheck.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRemoveCheck.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnRemoveCheck.Image = global::AutoSports.OVRBDPlugin.Properties.Resources.left_24;
            this.btnRemoveCheck.Location = new System.Drawing.Point(305, 194);
            this.btnRemoveCheck.Name = "btnRemoveCheck";
            this.btnRemoveCheck.Size = new System.Drawing.Size(41, 30);
            this.btnRemoveCheck.TabIndex = 10;
            this.btnRemoveCheck.Click += new System.EventHandler(this.btnRemoveCheck_Click);
            // 
            // btnAddCheck
            // 
            this.btnAddCheck.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAddCheck.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnAddCheck.Image = global::AutoSports.OVRBDPlugin.Properties.Resources.right_24;
            this.btnAddCheck.Location = new System.Drawing.Point(305, 124);
            this.btnAddCheck.Name = "btnAddCheck";
            this.btnAddCheck.Size = new System.Drawing.Size(41, 30);
            this.btnAddCheck.TabIndex = 11;
            this.btnAddCheck.Click += new System.EventHandler(this.btnAddCheck_Click);
            // 
            // dgvToCheckErr
            // 
            this.dgvToCheckErr.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvToCheckErr.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvToCheckErr.Location = new System.Drawing.Point(364, 21);
            this.dgvToCheckErr.Name = "dgvToCheckErr";
            this.dgvToCheckErr.ReadOnly = true;
            this.dgvToCheckErr.RowTemplate.Height = 23;
            this.dgvToCheckErr.Size = new System.Drawing.Size(360, 316);
            this.dgvToCheckErr.TabIndex = 12;
            this.dgvToCheckErr.CellFormatting += new System.Windows.Forms.DataGridViewCellFormattingEventHandler(this.dgvToCheckErr_CellFormatting);
            // 
            // labelX1
            // 
            this.labelX1.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labelX1.BackgroundStyle.Class = "";
            this.labelX1.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labelX1.Location = new System.Drawing.Point(364, 0);
            this.labelX1.Name = "labelX1";
            this.labelX1.Size = new System.Drawing.Size(105, 20);
            this.labelX1.TabIndex = 3;
            this.labelX1.Text = "Items to Check";
            // 
            // dgvCheckResult
            // 
            this.dgvCheckResult.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvCheckResult.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvCheckResult.Location = new System.Drawing.Point(3, 369);
            this.dgvCheckResult.Name = "dgvCheckResult";
            this.dgvCheckResult.RowTemplate.Height = 23;
            this.dgvCheckResult.Size = new System.Drawing.Size(721, 202);
            this.dgvCheckResult.TabIndex = 12;
            // 
            // labelX2
            // 
            this.labelX2.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labelX2.BackgroundStyle.Class = "";
            this.labelX2.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labelX2.Location = new System.Drawing.Point(2, 340);
            this.labelX2.Name = "labelX2";
            this.labelX2.Size = new System.Drawing.Size(125, 23);
            this.labelX2.TabIndex = 13;
            this.labelX2.Text = "Check Error Results";
            // 
            // btnStartCheck
            // 
            this.btnStartCheck.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnStartCheck.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnStartCheck.Location = new System.Drawing.Point(528, 339);
            this.btnStartCheck.Name = "btnStartCheck";
            this.btnStartCheck.Size = new System.Drawing.Size(92, 29);
            this.btnStartCheck.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnStartCheck.TabIndex = 14;
            this.btnStartCheck.Text = "Start Check";
            this.btnStartCheck.Click += new System.EventHandler(this.btnStartCheck_Click);
            // 
            // cmbLang
            // 
            this.cmbLang.FormattingEnabled = true;
            this.cmbLang.Items.AddRange(new object[] {
            "English",
            "Chinese"});
            this.cmbLang.Location = new System.Drawing.Point(431, 342);
            this.cmbLang.Name = "cmbLang";
            this.cmbLang.Size = new System.Drawing.Size(91, 20);
            this.cmbLang.TabIndex = 15;
            // 
            // labelX3
            // 
            this.labelX3.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labelX3.BackgroundStyle.Class = "";
            this.labelX3.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labelX3.Location = new System.Drawing.Point(358, 340);
            this.labelX3.Name = "labelX3";
            this.labelX3.Size = new System.Drawing.Size(67, 23);
            this.labelX3.TabIndex = 13;
            this.labelX3.Text = "Language:";
            // 
            // btnContinueCheck
            // 
            this.btnContinueCheck.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnContinueCheck.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnContinueCheck.Location = new System.Drawing.Point(626, 339);
            this.btnContinueCheck.Name = "btnContinueCheck";
            this.btnContinueCheck.Size = new System.Drawing.Size(98, 29);
            this.btnContinueCheck.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnContinueCheck.TabIndex = 14;
            this.btnContinueCheck.Text = "Continue Check";
            this.btnContinueCheck.Click += new System.EventHandler(this.btnContinueCheck_Click);
            // 
            // SelfCheckErrorFrm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(730, 571);
            this.Controls.Add(this.cmbLang);
            this.Controls.Add(this.btnContinueCheck);
            this.Controls.Add(this.btnStartCheck);
            this.Controls.Add(this.labelX3);
            this.Controls.Add(this.labelX2);
            this.Controls.Add(this.dgvCheckResult);
            this.Controls.Add(this.dgvToCheckErr);
            this.Controls.Add(this.btnRemoveCheck);
            this.Controls.Add(this.btnAddCheck);
            this.Controls.Add(this.listToCheckItems);
            this.Controls.Add(this.labelX1);
            this.Controls.Add(this.lbPort);
            this.DoubleBuffered = true;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.Name = "SelfCheckErrorFrm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "SelfCheckErrorFrm";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.SelfCheckErrorFrm_FormClosing);
            this.Load += new System.EventHandler(this.selfCheckLoaded);
            ((System.ComponentModel.ISupportInitialize)(this.dgvToCheckErr)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCheckResult)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.LabelX lbPort;
        private System.Windows.Forms.ListBox listToCheckItems;
        private DevComponents.DotNetBar.ButtonX btnRemoveCheck;
        private DevComponents.DotNetBar.ButtonX btnAddCheck;
        private System.Windows.Forms.DataGridView dgvToCheckErr;
        private DevComponents.DotNetBar.LabelX labelX1;
        private System.Windows.Forms.DataGridView dgvCheckResult;
        private DevComponents.DotNetBar.LabelX labelX2;
        private DevComponents.DotNetBar.ButtonX btnStartCheck;
        private System.Windows.Forms.ComboBox cmbLang;
        private DevComponents.DotNetBar.LabelX labelX3;
        private DevComponents.DotNetBar.ButtonX btnContinueCheck;

    }
}