namespace OVRRUPlugin
{
    partial class SplitStatusWnd
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
            this.btnAvailable = new DevComponents.DotNetBar.ButtonX();
            this.btnRunning = new DevComponents.DotNetBar.ButtonX();
            this.btnOfficial = new DevComponents.DotNetBar.ButtonX();
            this.SuspendLayout();
            // 
            // btnAvailable
            // 
            this.btnAvailable.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAvailable.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnAvailable.Font = new System.Drawing.Font("SimSun", 15F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnAvailable.Location = new System.Drawing.Point(27, 22);
            this.btnAvailable.Name = "btnAvailable";
            this.btnAvailable.Size = new System.Drawing.Size(107, 37);
            this.btnAvailable.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnAvailable.TabIndex = 0;
            this.btnAvailable.Tag = "10";
            this.btnAvailable.Text = "Available";
            this.btnAvailable.Click += new System.EventHandler(this.btnSplitStatus_Click);
            // 
            // btnRunning
            // 
            this.btnRunning.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRunning.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnRunning.Font = new System.Drawing.Font("SimSun", 15F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnRunning.Location = new System.Drawing.Point(27, 87);
            this.btnRunning.Name = "btnRunning";
            this.btnRunning.Size = new System.Drawing.Size(107, 37);
            this.btnRunning.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnRunning.TabIndex = 1;
            this.btnRunning.Tag = "50";
            this.btnRunning.Text = "Running";
            this.btnRunning.Click += new System.EventHandler(this.btnSplitStatus_Click);
            // 
            // btnOfficial
            // 
            this.btnOfficial.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOfficial.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOfficial.Font = new System.Drawing.Font("SimSun", 15F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnOfficial.Location = new System.Drawing.Point(27, 153);
            this.btnOfficial.Name = "btnOfficial";
            this.btnOfficial.Size = new System.Drawing.Size(107, 37);
            this.btnOfficial.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnOfficial.TabIndex = 2;
            this.btnOfficial.Tag = "110";
            this.btnOfficial.Text = "Official";
            this.btnOfficial.Click += new System.EventHandler(this.btnSplitStatus_Click);
            // 
            // SplitStatusWnd
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(172, 217);
            this.Controls.Add(this.btnOfficial);
            this.Controls.Add(this.btnRunning);
            this.Controls.Add(this.btnAvailable);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "SplitStatusWnd";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "SplitStatusWnd";
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnAvailable;
        private DevComponents.DotNetBar.ButtonX btnRunning;
        private DevComponents.DotNetBar.ButtonX btnOfficial;
    }
}