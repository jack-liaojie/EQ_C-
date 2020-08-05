using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    partial class SetMatchesRuleForm
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
            this.btnCancle = new DevComponents.DotNetBar.ButtonX();
            this.btnOK = new DevComponents.DotNetBar.ButtonX();
            this.lbCompetitionRule = new Sunny.UI.UILabel();
            this.CmbCompetitionRule = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.SuspendLayout();
            // 
            // btnCancle
            // 
            this.btnCancle.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancle.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnCancle.Image = global::Newauto.OVRDrawArrange.Properties.Resources.cancel_24;
            this.btnCancle.Location = new System.Drawing.Point(223, 43);
            this.btnCancle.Name = "btnCancle";
            this.btnCancle.Size = new System.Drawing.Size(50, 30);
            this.btnCancle.TabIndex = 21;
            this.btnCancle.Click += new System.EventHandler(this.btnCancle_Click);
            // 
            // btnOK
            // 
            this.btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOK.Image = global::Newauto.OVRDrawArrange.Properties.Resources.ok_24;
            this.btnOK.Location = new System.Drawing.Point(163, 43);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(50, 30);
            this.btnOK.TabIndex = 20;
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // lbCompetitionRule
            // 
            this.lbCompetitionRule.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbCompetitionRule.Location = new System.Drawing.Point(3, 98);
            this.lbCompetitionRule.Name = "lbCompetitionRule";
            this.lbCompetitionRule.Size = new System.Drawing.Size(110, 21);
            this.lbCompetitionRule.TabIndex = 33;
            this.lbCompetitionRule.Text = "Competition Rule:";
            this.lbCompetitionRule.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // CmbCompetitionRule
            // 
            this.CmbCompetitionRule.DisplayMember = "Text";
            this.CmbCompetitionRule.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.CmbCompetitionRule.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.CmbCompetitionRule.FormattingEnabled = true;
            this.CmbCompetitionRule.ItemHeight = 23;
            this.CmbCompetitionRule.Location = new System.Drawing.Point(116, 35);
            this.CmbCompetitionRule.Name = "CmbCompetitionRule";
            this.CmbCompetitionRule.Size = new System.Drawing.Size(157, 29);
            this.CmbCompetitionRule.TabIndex = 32;
            // 
            // SetMatchesRuleForm
            // 
            this.ClientSize = new System.Drawing.Size(352, 145);
            this.Controls.Add(this.lbCompetitionRule);
            this.Controls.Add(this.CmbCompetitionRule);
            this.Controls.Add(this.btnCancle);
            this.Controls.Add(this.btnOK);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "SetMatchesRuleForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "frmSetMatchesRule";
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnCancle;
        private DevComponents.DotNetBar.ButtonX btnOK;
        private UILabel lbCompetitionRule;
        private DevComponents.DotNetBar.Controls.ComboBoxEx CmbCompetitionRule;
    }
}