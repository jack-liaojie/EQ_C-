namespace OVRDVPlugin
{
    partial class frmMatchJudge
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
            this.wpfJudgeHost = new System.Windows.Forms.Integration.ElementHost();
            this.SuspendLayout();
            // 
            // wpfJudgeHost
            // 
            this.wpfJudgeHost.Location = new System.Drawing.Point(0, 0);
            this.wpfJudgeHost.Name = "wpfJudgeHost";
            this.wpfJudgeHost.Size = new System.Drawing.Size(934, 482);
            this.wpfJudgeHost.TabIndex = 0;
            this.wpfJudgeHost.Text = "elementHost1";
            this.wpfJudgeHost.Child = null;
            // 
            // frmMatchJudge
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(934, 482);
            this.Controls.Add(this.wpfJudgeHost);
            this.DoubleBuffered = true;
            this.MaximizeBox = false;
            this.MaximumSize = new System.Drawing.Size(950, 520);
            this.MinimizeBox = false;
            this.MinimumSize = new System.Drawing.Size(950, 520);
            this.Name = "frmMatchJudge";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmMatchJudge";
            this.Load += new System.EventHandler(this.frmMatchJudge_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Integration.ElementHost wpfJudgeHost;
    }
}