namespace AutoSports.OVRBDPlugin
{
    partial class InputResults
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
            this.eleWPFInputResults = new System.Windows.Forms.Integration.ElementHost();
            this.SuspendLayout();
            // 
            // eleWPFInputResults
            // 
            this.eleWPFInputResults.Dock = System.Windows.Forms.DockStyle.Fill;
            this.eleWPFInputResults.Location = new System.Drawing.Point(0, 0);
            this.eleWPFInputResults.Name = "eleWPFInputResults";
            this.eleWPFInputResults.Size = new System.Drawing.Size(817, 371);
            this.eleWPFInputResults.TabIndex = 0;
            this.eleWPFInputResults.Text = "elementHost1";
            this.eleWPFInputResults.Child = null;
            // 
            // InputResults
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(817, 371);
            this.Controls.Add(this.eleWPFInputResults);
            this.MinimizeBox = false;
            this.Name = "InputResults";
            this.ShowInTaskbar = false;
            this.Text = "InputResults";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Load += new System.EventHandler(this.frmInputResultsLoaded);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Integration.ElementHost eleWPFInputResults;
    }
}