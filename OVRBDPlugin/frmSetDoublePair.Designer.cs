namespace AutoSports.OVRBDPlugin
{
    partial class frmSetDoublePair
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
            this.lbPreviewPairName = new System.Windows.Forms.Label();
            this.BtnOk = new DevComponents.DotNetBar.ButtonX();
            this.lstbx_TeamMembers = new System.Windows.Forms.DataGridView();
            this.btnClearDouble = new DevComponents.DotNetBar.ButtonX();
            ((System.ComponentModel.ISupportInitialize)(this.lstbx_TeamMembers)).BeginInit();
            this.SuspendLayout();
            // 
            // lbPreviewPairName
            // 
            this.lbPreviewPairName.AutoSize = true;
            this.lbPreviewPairName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lbPreviewPairName.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lbPreviewPairName.Location = new System.Drawing.Point(10, 161);
            this.lbPreviewPairName.Name = "lbPreviewPairName";
            this.lbPreviewPairName.Padding = new System.Windows.Forms.Padding(2);
            this.lbPreviewPairName.Size = new System.Drawing.Size(6, 18);
            this.lbPreviewPairName.TabIndex = 1;
            // 
            // BtnOk
            // 
            this.BtnOk.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.BtnOk.Location = new System.Drawing.Point(351, 194);
            this.BtnOk.Name = "BtnOk";
            this.BtnOk.Size = new System.Drawing.Size(77, 30);
            this.BtnOk.TabIndex = 2;
            this.BtnOk.Text = "OK";
            this.BtnOk.Click += new System.EventHandler(this.BtnOk_Click);
            // 
            // lstbx_TeamMembers
            // 
            this.lstbx_TeamMembers.AllowUserToAddRows = false;
            this.lstbx_TeamMembers.AllowUserToDeleteRows = false;
            this.lstbx_TeamMembers.AllowUserToResizeRows = false;
            this.lstbx_TeamMembers.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.lstbx_TeamMembers.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.lstbx_TeamMembers.Location = new System.Drawing.Point(2, 5);
            this.lstbx_TeamMembers.Name = "lstbx_TeamMembers";
            this.lstbx_TeamMembers.ReadOnly = true;
            this.lstbx_TeamMembers.RowHeadersVisible = false;
            this.lstbx_TeamMembers.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            this.lstbx_TeamMembers.RowTemplate.Height = 23;
            this.lstbx_TeamMembers.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.lstbx_TeamMembers.Size = new System.Drawing.Size(429, 150);
            this.lstbx_TeamMembers.TabIndex = 3;
            this.lstbx_TeamMembers.SelectionChanged += new System.EventHandler(this.dgGridSelectChanged);
            // 
            // btnClearDouble
            // 
            this.btnClearDouble.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnClearDouble.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnClearDouble.Location = new System.Drawing.Point(259, 194);
            this.btnClearDouble.Name = "btnClearDouble";
            this.btnClearDouble.Size = new System.Drawing.Size(77, 30);
            this.btnClearDouble.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnClearDouble.TabIndex = 4;
            this.btnClearDouble.Text = "Clear";
            this.btnClearDouble.Click += new System.EventHandler(this.btnClearDouble_Click);
            // 
            // frmSetDoublePair
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(433, 228);
            this.Controls.Add(this.btnClearDouble);
            this.Controls.Add(this.lstbx_TeamMembers);
            this.Controls.Add(this.BtnOk);
            this.Controls.Add(this.lbPreviewPairName);
            this.DoubleBuffered = true;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmSetDoublePair";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "frmSetDoublePair";
            ((System.ComponentModel.ISupportInitialize)(this.lstbx_TeamMembers)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lbPreviewPairName;
        private DevComponents.DotNetBar.ButtonX BtnOk;
        private System.Windows.Forms.DataGridView lstbx_TeamMembers;
        private DevComponents.DotNetBar.ButtonX btnClearDouble;
    }
}