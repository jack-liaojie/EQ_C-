namespace OVRDVPlugin
{
    partial class frmServerGroup
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
            this.wpfServerGroupHost = new System.Windows.Forms.Integration.ElementHost();
            this.SuspendLayout();
            // 
            // wpfServerGroupHost
            // 
            this.wpfServerGroupHost.Location = new System.Drawing.Point(2, 2);
            this.wpfServerGroupHost.Name = "wpfServerGroupHost";
            this.wpfServerGroupHost.Size = new System.Drawing.Size(500, 330);
            this.wpfServerGroupHost.TabIndex = 0;
            this.wpfServerGroupHost.Text = "elementHost1";
            this.wpfServerGroupHost.Child = null;
            // 
            // frmServerGroup
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(507, 335);
            this.Controls.Add(this.wpfServerGroupHost);
            this.MaximizeBox = false;
            this.MaximumSize = new System.Drawing.Size(523, 373);
            this.MinimizeBox = false;
            this.MinimumSize = new System.Drawing.Size(523, 373);
            this.Name = "frmServerGroup";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmServerGroup";
            this.Load += new System.EventHandler(this.frmServerGroup_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Integration.ElementHost wpfServerGroupHost;
    }
}