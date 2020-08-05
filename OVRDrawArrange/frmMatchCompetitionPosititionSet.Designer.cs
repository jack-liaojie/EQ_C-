using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    partial class CompetitionPosSetFrom
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnX_Cancel = new DevComponents.DotNetBar.ButtonX();
            this.txStep = new UITextBox();
            this.labX_Step = new UILabel();
            this.txStartNumber = new UITextBox();
            this.labX_StartNumber = new UILabel();
            this.btnX_OK = new DevComponents.DotNetBar.ButtonX();
            this.labX_CodeLength = new UILabel();
            this.txCodeLength = new UITextBox();
            this.SuspendLayout();
            // 
            // btnX_Cancel
            // 
            this.btnX_Cancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Cancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_Cancel.Image = global::Newauto.OVRDrawArrange.Properties.Resources.cancel_24;
            this.btnX_Cancel.Location = new System.Drawing.Point(167, 91);
            this.btnX_Cancel.Name = "btnX_Cancel";
            this.btnX_Cancel.Size = new System.Drawing.Size(50, 30);
            this.btnX_Cancel.TabIndex = 24;
            this.btnX_Cancel.Click += new System.EventHandler(this.btnX_Cancel_Click);
            // 
            // txStep
            // 
            // 
            // 
            // 
            this.txStep.Location = new System.Drawing.Point(83, 39);
            this.txStep.Name = "txStep";
            this.txStep.Size = new System.Drawing.Size(134, 21);
            this.txStep.TabIndex = 21;
            // 
            // labX_Step
            // 
            this.labX_Step.AutoSize = true;
            this.labX_Step.Location = new System.Drawing.Point(2, 39);
            this.labX_Step.Name = "labX_Step";
            this.labX_Step.Size = new System.Drawing.Size(37, 16);
            this.labX_Step.TabIndex = 26;
            this.labX_Step.Text = "Step:";
            // 
            // txStartNumber
            // 
            // 
            // 
            // 
            this.txStartNumber.Location = new System.Drawing.Point(83, 14);
            this.txStartNumber.Name = "txStartNumber";
            this.txStartNumber.Size = new System.Drawing.Size(134, 21);
            this.txStartNumber.TabIndex = 20;
            // 
            // labX_StartNumber
            // 
            this.labX_StartNumber.AutoSize = true;
            this.labX_StartNumber.Location = new System.Drawing.Point(2, 14);
            this.labX_StartNumber.Name = "labX_StartNumber";
            this.labX_StartNumber.Size = new System.Drawing.Size(81, 16);
            this.labX_StartNumber.TabIndex = 25;
            this.labX_StartNumber.Text = "StartNumber:";
            // 
            // btnX_OK
            // 
            this.btnX_OK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_OK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_OK.Image = global::Newauto.OVRDrawArrange.Properties.Resources.ok_24;
            this.btnX_OK.Location = new System.Drawing.Point(112, 91);
            this.btnX_OK.Name = "btnX_OK";
            this.btnX_OK.Size = new System.Drawing.Size(50, 30);
            this.btnX_OK.TabIndex = 23;
            this.btnX_OK.Click += new System.EventHandler(this.btnX_OK_Click);
            // 
            // labX_CodeLength
            // 
            this.labX_CodeLength.AutoSize = true;
            this.labX_CodeLength.Location = new System.Drawing.Point(2, 64);
            this.labX_CodeLength.Name = "labX_CodeLength";
            this.labX_CodeLength.Size = new System.Drawing.Size(75, 16);
            this.labX_CodeLength.TabIndex = 27;
            this.labX_CodeLength.Text = "CodeLength:";
            // 
            // txCodeLength
            // 
            // 
            // 
            // 
            this.txCodeLength.Location = new System.Drawing.Point(83, 64);
            this.txCodeLength.Name = "txCodeLength";
            this.txCodeLength.Size = new System.Drawing.Size(134, 21);
            this.txCodeLength.TabIndex = 22;
            // 
            // CompetitionPosSetFrom
            // 
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(231, 131);
            this.Controls.Add(this.btnX_Cancel);
            this.Controls.Add(this.btnX_OK);
            this.Controls.Add(this.txCodeLength);
            this.Controls.Add(this.labX_CodeLength);
            this.Controls.Add(this.txStep);
            this.Controls.Add(this.labX_Step);
            this.Controls.Add(this.txStartNumber);
            this.Controls.Add(this.labX_StartNumber);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "CompetitionPosSetFrom";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "MatchCompetitionPosititionSet";
            this.Load += new System.EventHandler(this.CompetitionPosSetFrom_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnX_Cancel;
        private DevComponents.DotNetBar.ButtonX btnX_OK;
        private UITextBox txStep;
        private UILabel labX_Step;
        private UITextBox txStartNumber;
        private UILabel labX_StartNumber;
        private UILabel labX_CodeLength;
        private UITextBox txCodeLength;
    }
}