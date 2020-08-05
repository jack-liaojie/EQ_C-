namespace AutoSports.OVRWPPlugin
{
    partial class ModeSelectDlg
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
            this.lbModeDesc = new DevComponents.DotNetBar.LabelX();
            this.btnOK = new DevComponents.DotNetBar.ButtonX();
            this.btnCancel = new DevComponents.DotNetBar.ButtonX();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.lb_MultipleMode = new DevComponents.DotNetBar.LabelX();
            this.rd_SingleMode = new System.Windows.Forms.RadioButton();
            this.rd_Admin = new System.Windows.Forms.RadioButton();
            this.rd_Monitor = new System.Windows.Forms.RadioButton();
            this.rd_Substitute = new System.Windows.Forms.RadioButton();
            this.rd_WhiteStat = new System.Windows.Forms.RadioButton();
            this.rd_BlueStat = new System.Windows.Forms.RadioButton();
            this.rd_DoubleStat = new System.Windows.Forms.RadioButton();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // lbModeDesc
            // 
            // 
            // 
            // 
            this.lbModeDesc.BackgroundStyle.Class = "";
            this.lbModeDesc.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbModeDesc.Font = new System.Drawing.Font("SimSun", 10F);
            this.lbModeDesc.ForeColor = System.Drawing.Color.Red;
            this.lbModeDesc.Location = new System.Drawing.Point(12, 13);
            this.lbModeDesc.Name = "lbModeDesc";
            this.lbModeDesc.Size = new System.Drawing.Size(317, 109);
            this.lbModeDesc.TabIndex = 1;
            this.lbModeDesc.TextLineAlignment = System.Drawing.StringAlignment.Near;
            this.lbModeDesc.WordWrap = true;
            // 
            // btnOK
            // 
            this.btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOK.Location = new System.Drawing.Point(64, 297);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(64, 25);
            this.btnOK.TabIndex = 2;
            this.btnOK.Text = "OK";
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // btnCancel
            // 
            this.btnCancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnCancel.Location = new System.Drawing.Point(206, 297);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(64, 25);
            this.btnCancel.TabIndex = 2;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // pictureBox1
            // 
            this.pictureBox1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pictureBox1.Location = new System.Drawing.Point(12, 162);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(307, 1);
            this.pictureBox1.TabIndex = 4;
            this.pictureBox1.TabStop = false;
            // 
            // lb_MultipleMode
            // 
            // 
            // 
            // 
            this.lb_MultipleMode.BackgroundStyle.Class = "";
            this.lb_MultipleMode.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lb_MultipleMode.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lb_MultipleMode.Location = new System.Drawing.Point(12, 143);
            this.lb_MultipleMode.Name = "lb_MultipleMode";
            this.lb_MultipleMode.Size = new System.Drawing.Size(317, 18);
            this.lb_MultipleMode.TabIndex = 5;
            this.lb_MultipleMode.Text = "Multiple Machines Mode";
            // 
            // rd_SingleMode
            // 
            this.rd_SingleMode.AutoSize = true;
            this.rd_SingleMode.Location = new System.Drawing.Point(33, 124);
            this.rd_SingleMode.Name = "rd_SingleMode";
            this.rd_SingleMode.Size = new System.Drawing.Size(128, 17);
            this.rd_SingleMode.TabIndex = 6;
            this.rd_SingleMode.TabStop = true;
            this.rd_SingleMode.Text = "Single Machine Mode";
            this.rd_SingleMode.UseVisualStyleBackColor = true;
            this.rd_SingleMode.CheckedChanged += new System.EventHandler(this.Mode_CheckedChanged);
            // 
            // rd_Admin
            // 
            this.rd_Admin.AutoSize = true;
            this.rd_Admin.Location = new System.Drawing.Point(218, 191);
            this.rd_Admin.Name = "rd_Admin";
            this.rd_Admin.Size = new System.Drawing.Size(85, 17);
            this.rd_Admin.TabIndex = 6;
            this.rd_Admin.TabStop = true;
            this.rd_Admin.Text = "Administrator";
            this.rd_Admin.UseVisualStyleBackColor = true;
            this.rd_Admin.CheckedChanged += new System.EventHandler(this.Mode_CheckedChanged);
            // 
            // rd_Monitor
            // 
            this.rd_Monitor.AutoSize = true;
            this.rd_Monitor.Location = new System.Drawing.Point(33, 168);
            this.rd_Monitor.Name = "rd_Monitor";
            this.rd_Monitor.Size = new System.Drawing.Size(60, 17);
            this.rd_Monitor.TabIndex = 6;
            this.rd_Monitor.TabStop = true;
            this.rd_Monitor.Text = "Monitor";
            this.rd_Monitor.UseVisualStyleBackColor = true;
            this.rd_Monitor.CheckedChanged += new System.EventHandler(this.Mode_CheckedChanged);
            // 
            // rd_Substitute
            // 
            this.rd_Substitute.AutoSize = true;
            this.rd_Substitute.Location = new System.Drawing.Point(33, 191);
            this.rd_Substitute.Name = "rd_Substitute";
            this.rd_Substitute.Size = new System.Drawing.Size(80, 17);
            this.rd_Substitute.TabIndex = 6;
            this.rd_Substitute.TabStop = true;
            this.rd_Substitute.Text = "Substitution";
            this.rd_Substitute.UseVisualStyleBackColor = true;
            this.rd_Substitute.CheckedChanged += new System.EventHandler(this.Mode_CheckedChanged);
            // 
            // rd_WhiteStat
            // 
            this.rd_WhiteStat.AutoSize = true;
            this.rd_WhiteStat.Location = new System.Drawing.Point(33, 214);
            this.rd_WhiteStat.Name = "rd_WhiteStat";
            this.rd_WhiteStat.Size = new System.Drawing.Size(128, 17);
            this.rd_WhiteStat.TabIndex = 6;
            this.rd_WhiteStat.TabStop = true;
            this.rd_WhiteStat.Text = "White Team Statistics";
            this.rd_WhiteStat.UseVisualStyleBackColor = true;
            this.rd_WhiteStat.CheckedChanged += new System.EventHandler(this.Mode_CheckedChanged);
            // 
            // rd_BlueStat
            // 
            this.rd_BlueStat.AutoSize = true;
            this.rd_BlueStat.Location = new System.Drawing.Point(33, 237);
            this.rd_BlueStat.Name = "rd_BlueStat";
            this.rd_BlueStat.Size = new System.Drawing.Size(121, 17);
            this.rd_BlueStat.TabIndex = 6;
            this.rd_BlueStat.TabStop = true;
            this.rd_BlueStat.Text = "Blue Team Statistics";
            this.rd_BlueStat.UseVisualStyleBackColor = true;
            this.rd_BlueStat.CheckedChanged += new System.EventHandler(this.Mode_CheckedChanged);
            // 
            // rd_DoubleStat
            // 
            this.rd_DoubleStat.AutoSize = true;
            this.rd_DoubleStat.Location = new System.Drawing.Point(33, 260);
            this.rd_DoubleStat.Name = "rd_DoubleStat";
            this.rd_DoubleStat.Size = new System.Drawing.Size(139, 17);
            this.rd_DoubleStat.TabIndex = 6;
            this.rd_DoubleStat.TabStop = true;
            this.rd_DoubleStat.Text = "Double Teams Statistics";
            this.rd_DoubleStat.UseVisualStyleBackColor = true;
            this.rd_DoubleStat.CheckedChanged += new System.EventHandler(this.Mode_CheckedChanged);
            // 
            // ModeSelectDlg
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(388, 361);
            this.ControlBox = false;
            this.Controls.Add(this.rd_Monitor);
            this.Controls.Add(this.rd_DoubleStat);
            this.Controls.Add(this.rd_BlueStat);
            this.Controls.Add(this.rd_WhiteStat);
            this.Controls.Add(this.rd_Substitute);
            this.Controls.Add(this.rd_Admin);
            this.Controls.Add(this.rd_SingleMode);
            this.Controls.Add(this.pictureBox1);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.lbModeDesc);
            this.Controls.Add(this.lb_MultipleMode);
            this.DoubleBuffered = true;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Name = "ModeSelectDlg";
            this.ShowInTaskbar = false;
            this.Text = "ModeSelectDlg";
            this.Load += new System.EventHandler(this.ModeSelectDlg_Load);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevComponents.DotNetBar.LabelX lbModeDesc;
        private DevComponents.DotNetBar.ButtonX btnOK;
        private DevComponents.DotNetBar.ButtonX btnCancel;
        private System.Windows.Forms.PictureBox pictureBox1;
        private DevComponents.DotNetBar.LabelX lb_MultipleMode;
        private System.Windows.Forms.RadioButton rd_SingleMode;
        private System.Windows.Forms.RadioButton rd_Admin;
        private System.Windows.Forms.RadioButton rd_Monitor;
        private System.Windows.Forms.RadioButton rd_Substitute;
        private System.Windows.Forms.RadioButton rd_WhiteStat;
        private System.Windows.Forms.RadioButton rd_BlueStat;
        private System.Windows.Forms.RadioButton rd_DoubleStat;
    }
}