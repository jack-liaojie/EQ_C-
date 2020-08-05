namespace AutoSports.OVRWLPlugin
{
    partial class OVRWLSetting
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
            this.lbEvent = new DevComponents.DotNetBar.LabelX();
            this.btnX_Browse = new DevComponents.DotNetBar.ButtonX();
            this.txtFolder = new System.Windows.Forms.TextBox();
            this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.btnXSave = new DevComponents.DotNetBar.ButtonX();
            this.SuspendLayout();
            // 
            // lbEvent
            // 
            // 
            // 
            // 
            this.lbEvent.BackgroundStyle.Class = "";
            this.lbEvent.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbEvent.Location = new System.Drawing.Point(12, 12);
            this.lbEvent.Name = "lbEvent";
            this.lbEvent.Size = new System.Drawing.Size(178, 20);
            this.lbEvent.TabIndex = 7;
            this.lbEvent.Text = "TimingScoring Share Path：";
            // 
            // btnX_Browse
            // 
            this.btnX_Browse.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Browse.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnX_Browse.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_Browse.Location = new System.Drawing.Point(278, 38);
            this.btnX_Browse.Name = "btnX_Browse";
            this.btnX_Browse.Size = new System.Drawing.Size(49, 21);
            this.btnX_Browse.TabIndex = 22;
            this.btnX_Browse.Text = "....";
            this.btnX_Browse.TextAlignment = DevComponents.DotNetBar.eButtonTextAlignment.Left;
            this.btnX_Browse.Click += new System.EventHandler(this.btnX_Browse_Click);
            // 
            // txtFolder
            // 
            this.txtFolder.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtFolder.Location = new System.Drawing.Point(12, 38);
            this.txtFolder.Name = "txtFolder";
            this.txtFolder.Size = new System.Drawing.Size(260, 21);
            this.txtFolder.TabIndex = 23;
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // btnXSave
            // 
            this.btnXSave.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnXSave.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnXSave.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnXSave.Location = new System.Drawing.Point(209, 66);
            this.btnXSave.Name = "btnXSave";
            this.btnXSave.Size = new System.Drawing.Size(63, 21);
            this.btnXSave.TabIndex = 24;
            this.btnXSave.Text = "Save";
            this.btnXSave.Click += new System.EventHandler(this.btnXSave_Click);
            // 
            // OVRWLSetting
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(199)))), ((int)(((byte)(216)))), ((int)(((byte)(237)))));
            this.ClientSize = new System.Drawing.Size(339, 99);
            this.Controls.Add(this.btnXSave);
            this.Controls.Add(this.txtFolder);
            this.Controls.Add(this.btnX_Browse);
            this.Controls.Add(this.lbEvent);
            this.DoubleBuffered = true;
            this.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Fixed3D;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRWLSetting";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "WL - TimingScoring Share Path Setting";
            this.TitleText = "WL - TimingScoring Share Path Setting";
            this.Load += new System.EventHandler(this.OVRWLAutoDrawForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevComponents.DotNetBar.LabelX lbEvent;
        private DevComponents.DotNetBar.ButtonX btnX_Browse;
        private System.Windows.Forms.TextBox txtFolder;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private DevComponents.DotNetBar.ButtonX btnXSave;

    }
}