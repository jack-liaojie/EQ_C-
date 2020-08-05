namespace OVRDVPlugin
{
    partial class frmMatchCompetitionRule
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
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.btnx_ApplySelRule = new DevComponents.DotNetBar.ButtonX();
            this.cmbCompetitionRules = new System.Windows.Forms.ComboBox();
            this.lb_MatchDes = new System.Windows.Forms.Label();
            this.lb_Match = new System.Windows.Forms.Label();
            this.btnDelMatchResult = new DevComponents.DotNetBar.ButtonX();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.btnDelMatchResult);
            this.groupBox1.Controls.Add(this.btnx_ApplySelRule);
            this.groupBox1.Controls.Add(this.cmbCompetitionRules);
            this.groupBox1.Controls.Add(this.lb_MatchDes);
            this.groupBox1.Controls.Add(this.lb_Match);
            this.groupBox1.Location = new System.Drawing.Point(2, 1);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(785, 96);
            this.groupBox1.TabIndex = 95;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Current Match Rule:";
            // 
            // btnx_ApplySelRule
            // 
            this.btnx_ApplySelRule.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_ApplySelRule.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_ApplySelRule.Location = new System.Drawing.Point(625, 30);
            this.btnx_ApplySelRule.Name = "btnx_ApplySelRule";
            this.btnx_ApplySelRule.Size = new System.Drawing.Size(143, 27);
            this.btnx_ApplySelRule.TabIndex = 93;
            this.btnx_ApplySelRule.Text = "Apply Selected Rule";
            this.btnx_ApplySelRule.Click += new System.EventHandler(this.btnx_ApplySelRule_Click);
            // 
            // cmbCompetitionRules
            // 
            this.cmbCompetitionRules.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbCompetitionRules.FormattingEnabled = true;
            this.cmbCompetitionRules.Location = new System.Drawing.Point(259, 37);
            this.cmbCompetitionRules.Name = "cmbCompetitionRules";
            this.cmbCompetitionRules.Size = new System.Drawing.Size(350, 20);
            this.cmbCompetitionRules.TabIndex = 35;
            // 
            // lb_MatchDes
            // 
            this.lb_MatchDes.AutoSize = true;
            this.lb_MatchDes.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_MatchDes.Location = new System.Drawing.Point(82, 21);
            this.lb_MatchDes.Name = "lb_MatchDes";
            this.lb_MatchDes.Size = new System.Drawing.Size(53, 12);
            this.lb_MatchDes.TabIndex = 34;
            this.lb_MatchDes.Text = "MatchDes";
            // 
            // lb_Match
            // 
            this.lb_Match.AutoSize = true;
            this.lb_Match.Location = new System.Drawing.Point(11, 21);
            this.lb_Match.Name = "lb_Match";
            this.lb_Match.Size = new System.Drawing.Size(65, 12);
            this.lb_Match.TabIndex = 33;
            this.lb_Match.Text = "MatchName:";
            // 
            // btnDelMatchResult
            // 
            this.btnDelMatchResult.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDelMatchResult.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnDelMatchResult.Location = new System.Drawing.Point(625, 63);
            this.btnDelMatchResult.Name = "btnDelMatchResult";
            this.btnDelMatchResult.Size = new System.Drawing.Size(143, 27);
            this.btnDelMatchResult.TabIndex = 94;
            this.btnDelMatchResult.Text = "Delete Match Result Info";
            this.btnDelMatchResult.Click += new System.EventHandler(this.btnDelMatchResult_Click);
            // 
            // frmMatchCompetitionRule
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(791, 101);
            this.Controls.Add(this.groupBox1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmMatchCompetitionRule";
            this.Text = "frmMatchCompetitionRule";
            this.Load += new System.EventHandler(this.frmMatchCompetitionRule_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox1;
        private DevComponents.DotNetBar.ButtonX btnx_ApplySelRule;
        private System.Windows.Forms.ComboBox cmbCompetitionRules;
        private System.Windows.Forms.Label lb_MatchDes;
        private System.Windows.Forms.Label lb_Match;
        private DevComponents.DotNetBar.ButtonX btnDelMatchResult;
    }
}