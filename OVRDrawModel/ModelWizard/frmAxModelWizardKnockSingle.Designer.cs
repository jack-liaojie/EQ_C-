using Sunny.UI;

namespace AutoSports.OVRDrawModel
{
    partial class AxModelWizardKnockSingleForm
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
            this.cbGroupCount = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.cbGroupSize = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.tbStageTitle = new UITextBox();
            this.lbGroupCount = new UILabel();
            this.lbGroupSize = new UILabel();
            this.lbStageTitle = new UILabel();
            this.SuspendLayout();
            // 
            // cbGroupCount
            // 
            this.cbGroupCount.DisplayMember = "Text";
            this.cbGroupCount.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbGroupCount.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbGroupCount.FormattingEnabled = true;
            this.cbGroupCount.ItemHeight = 15;
            this.cbGroupCount.Location = new System.Drawing.Point(166, 132);
            this.cbGroupCount.Name = "cbGroupCount";
            this.cbGroupCount.Size = new System.Drawing.Size(123, 21);
            this.cbGroupCount.TabIndex = 7;
            // 
            // cbGroupSize
            // 
            this.cbGroupSize.DisplayMember = "Text";
            this.cbGroupSize.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbGroupSize.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbGroupSize.FormattingEnabled = true;
            this.cbGroupSize.ItemHeight = 15;
            this.cbGroupSize.Location = new System.Drawing.Point(166, 97);
            this.cbGroupSize.Name = "cbGroupSize";
            this.cbGroupSize.Size = new System.Drawing.Size(123, 21);
            this.cbGroupSize.TabIndex = 8;
            // 
            // tbStageTitle
            // 
            // 
            // 
            // 
            this.tbStageTitle.Location = new System.Drawing.Point(166, 62);
            this.tbStageTitle.Name = "tbStageTitle";
            this.tbStageTitle.Size = new System.Drawing.Size(123, 21);
            this.tbStageTitle.TabIndex = 6;
            // 
            // lbGroupCount
            // 
            this.lbGroupCount.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.lbGroupCount.Location = new System.Drawing.Point(84, 127);
            this.lbGroupCount.Name = "lbGroupCount";
            this.lbGroupCount.Size = new System.Drawing.Size(76, 28);
            this.lbGroupCount.TabIndex = 3;
            this.lbGroupCount.Text = "RankSize:";
            // 
            // lbGroupSize
            // 
            this.lbGroupSize.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.lbGroupSize.Location = new System.Drawing.Point(84, 93);
            this.lbGroupSize.Name = "lbGroupSize";
            this.lbGroupSize.Size = new System.Drawing.Size(76, 28);
            this.lbGroupSize.TabIndex = 4;
            this.lbGroupSize.Text = "MaxSize:";
            // 
            // lbStageTitle
            // 
            this.lbStageTitle.Location = new System.Drawing.Point(84, 59);
            this.lbStageTitle.Name = "lbStageTitle";
            this.lbStageTitle.Size = new System.Drawing.Size(76, 28);
            this.lbStageTitle.TabIndex = 5;
            this.lbStageTitle.Text = "StageTitle:";
            // 
            // AxModelWizardKnockSingleForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(399, 217);
            this.Controls.Add(this.cbGroupCount);
            this.Controls.Add(this.cbGroupSize);
            this.Controls.Add(this.tbStageTitle);
            this.Controls.Add(this.lbGroupCount);
            this.Controls.Add(this.lbGroupSize);
            this.Controls.Add(this.lbStageTitle);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "AxModelWizardKnockSingleForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "AxModelWizardKnockSingleForm";
            this.Load += new System.EventHandler(this.AxModelWizardKnockSingleForm_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.Controls.ComboBoxEx cbGroupCount;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbGroupSize;
        private UITextBox tbStageTitle;
        private UILabel lbGroupCount;
        private UILabel lbGroupSize;
        private UILabel lbStageTitle;
    }
}