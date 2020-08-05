using Sunny.UI;

namespace AutoSports.OVRDrawModel
{
    partial class AxModelWizardKnockOutForm
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
            this.radLetter = new System.Windows.Forms.RadioButton();
            this.radNumber = new System.Windows.Forms.RadioButton();
            this.lbNamingMode = new UILabel();
            this.cbGroupQual = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.cbGroupCount = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.cbGroupSize = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.tbGroupName = new UITextBox();
            this.tbStageTitle = new UITextBox();
            this.lbPlayerCountDes = new UILabel();
            this.lbGroupNameDes = new UILabel();
            this.lbGroupQual = new UILabel();
            this.lbGroupCount = new UILabel();
            this.lbGroupName = new UILabel();
            this.lbGroupSize = new UILabel();
            this.lbStageTitle = new UILabel();
            this.SuspendLayout();
            // 
            // radLetter
            // 
            this.radLetter.AutoSize = true;
            this.radLetter.Location = new System.Drawing.Point(276, 98);
            this.radLetter.Name = "radLetter";
            this.radLetter.Size = new System.Drawing.Size(53, 16);
            this.radLetter.TabIndex = 19;
            this.radLetter.TabStop = true;
            this.radLetter.Text = "A,B,C";
            this.radLetter.UseVisualStyleBackColor = true;
            this.radLetter.CheckedChanged += new System.EventHandler(this.radLetter_CheckedChanged);
            // 
            // radNumber
            // 
            this.radNumber.AutoSize = true;
            this.radNumber.Location = new System.Drawing.Point(276, 76);
            this.radNumber.Name = "radNumber";
            this.radNumber.Size = new System.Drawing.Size(53, 16);
            this.radNumber.TabIndex = 20;
            this.radNumber.TabStop = true;
            this.radNumber.Text = "1,2,3";
            this.radNumber.UseVisualStyleBackColor = true;
            this.radNumber.CheckedChanged += new System.EventHandler(this.radNumber_CheckedChanged);
            // 
            // lbNamingMode
            // 
            this.lbNamingMode.AutoSize = true;
            this.lbNamingMode.Location = new System.Drawing.Point(229, 47);
            this.lbNamingMode.Name = "lbNamingMode";
            this.lbNamingMode.Size = new System.Drawing.Size(75, 16);
            this.lbNamingMode.TabIndex = 18;
            this.lbNamingMode.Text = "NamingMode:";
            // 
            // cbGroupQual
            // 
            this.cbGroupQual.DisplayMember = "Text";
            this.cbGroupQual.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbGroupQual.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbGroupQual.FormattingEnabled = true;
            this.cbGroupQual.ItemHeight = 15;
            this.cbGroupQual.Location = new System.Drawing.Point(90, 118);
            this.cbGroupQual.Name = "cbGroupQual";
            this.cbGroupQual.Size = new System.Drawing.Size(123, 21);
            this.cbGroupQual.TabIndex = 15;
            this.cbGroupQual.SelectedIndexChanged += new System.EventHandler(this.cbGroupQual_SelectedIndexChanged);
            // 
            // cbGroupCount
            // 
            this.cbGroupCount.DisplayMember = "Text";
            this.cbGroupCount.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbGroupCount.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbGroupCount.FormattingEnabled = true;
            this.cbGroupCount.ItemHeight = 15;
            this.cbGroupCount.Location = new System.Drawing.Point(90, 83);
            this.cbGroupCount.Name = "cbGroupCount";
            this.cbGroupCount.Size = new System.Drawing.Size(123, 21);
            this.cbGroupCount.TabIndex = 16;
            this.cbGroupCount.SelectedIndexChanged += new System.EventHandler(this.cbGroupCount_SelectedIndexChanged);
            // 
            // cbGroupSize
            // 
            this.cbGroupSize.DisplayMember = "Text";
            this.cbGroupSize.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbGroupSize.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbGroupSize.FormattingEnabled = true;
            this.cbGroupSize.ItemHeight = 15;
            this.cbGroupSize.Location = new System.Drawing.Point(90, 48);
            this.cbGroupSize.Name = "cbGroupSize";
            this.cbGroupSize.Size = new System.Drawing.Size(123, 21);
            this.cbGroupSize.TabIndex = 17;
            this.cbGroupSize.SelectedIndexChanged += new System.EventHandler(this.cbGroupSize_SelectedIndexChanged);
            // 
            // tbGroupName
            // 
            // 
            // 
            // 
            this.tbGroupName.Location = new System.Drawing.Point(310, 13);
            this.tbGroupName.Name = "tbGroupName";
            this.tbGroupName.Size = new System.Drawing.Size(123, 21);
            this.tbGroupName.TabIndex = 14;
            this.tbGroupName.TextChanged += new System.EventHandler(this.tbGroupName_TextChanged);
            // 
            // tbStageTitle
            // 
            // 
            // 
            // 
            this.tbStageTitle.Location = new System.Drawing.Point(90, 13);
            this.tbStageTitle.Name = "tbStageTitle";
            this.tbStageTitle.Size = new System.Drawing.Size(123, 21);
            this.tbStageTitle.TabIndex = 13;
            // 
            // lbPlayerCountDes
            // 
            this.lbPlayerCountDes.AutoSize = true;
            this.lbPlayerCountDes.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.lbPlayerCountDes.Location = new System.Drawing.Point(8, 189);
            this.lbPlayerCountDes.Name = "lbPlayerCountDes";
            this.lbPlayerCountDes.Size = new System.Drawing.Size(93, 16);
            this.lbPlayerCountDes.TabIndex = 8;
            this.lbPlayerCountDes.Text = "PlayerCountDes";
            // 
            // lbGroupNameDes
            // 
            this.lbGroupNameDes.AutoSize = true;
            this.lbGroupNameDes.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.lbGroupNameDes.Location = new System.Drawing.Point(8, 155);
            this.lbGroupNameDes.Name = "lbGroupNameDes";
            this.lbGroupNameDes.Size = new System.Drawing.Size(81, 16);
            this.lbGroupNameDes.TabIndex = 7;
            this.lbGroupNameDes.Text = "GroupNameDes";
            // 
            // lbGroupQual
            // 
            this.lbGroupQual.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.lbGroupQual.Location = new System.Drawing.Point(8, 112);
            this.lbGroupQual.Name = "lbGroupQual";
            this.lbGroupQual.Size = new System.Drawing.Size(76, 28);
            this.lbGroupQual.TabIndex = 6;
            this.lbGroupQual.Text = "GroupQual:";
            // 
            // lbGroupCount
            // 
            this.lbGroupCount.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.lbGroupCount.Location = new System.Drawing.Point(8, 78);
            this.lbGroupCount.Name = "lbGroupCount";
            this.lbGroupCount.Size = new System.Drawing.Size(76, 28);
            this.lbGroupCount.TabIndex = 9;
            this.lbGroupCount.Text = "GroupCount:";
            // 
            // lbGroupName
            // 
            this.lbGroupName.Location = new System.Drawing.Point(229, 10);
            this.lbGroupName.Name = "lbGroupName";
            this.lbGroupName.Size = new System.Drawing.Size(76, 28);
            this.lbGroupName.TabIndex = 12;
            this.lbGroupName.Text = "GroupName:";
            // 
            // lbGroupSize
            // 
            this.lbGroupSize.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.lbGroupSize.Location = new System.Drawing.Point(8, 44);
            this.lbGroupSize.Name = "lbGroupSize";
            this.lbGroupSize.Size = new System.Drawing.Size(76, 28);
            this.lbGroupSize.TabIndex = 11;
            this.lbGroupSize.Text = "GroupSize:";
            // 
            // lbStageTitle
            // 
            this.lbStageTitle.Location = new System.Drawing.Point(8, 10);
            this.lbStageTitle.Name = "lbStageTitle";
            this.lbStageTitle.Size = new System.Drawing.Size(76, 28);
            this.lbStageTitle.TabIndex = 10;
            this.lbStageTitle.Text = "StageTitle:";
            // 
            // AxModelWizardKnockOutForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(445, 212);
            this.Controls.Add(this.radLetter);
            this.Controls.Add(this.radNumber);
            this.Controls.Add(this.lbNamingMode);
            this.Controls.Add(this.cbGroupQual);
            this.Controls.Add(this.cbGroupCount);
            this.Controls.Add(this.cbGroupSize);
            this.Controls.Add(this.tbGroupName);
            this.Controls.Add(this.tbStageTitle);
            this.Controls.Add(this.lbPlayerCountDes);
            this.Controls.Add(this.lbGroupNameDes);
            this.Controls.Add(this.lbGroupQual);
            this.Controls.Add(this.lbGroupCount);
            this.Controls.Add(this.lbGroupName);
            this.Controls.Add(this.lbGroupSize);
            this.Controls.Add(this.lbStageTitle);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "AxModelWizardKnockOutForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "AxModelWizardKnockOutForm";
            this.Load += new System.EventHandler(this.AxModelWizardKnockOutForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.RadioButton radLetter;
        private System.Windows.Forms.RadioButton radNumber;
        private UILabel lbNamingMode;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbGroupQual;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbGroupCount;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbGroupSize;
        private UITextBox tbGroupName;
        private UITextBox tbStageTitle;
        private UILabel lbPlayerCountDes;
        private UILabel lbGroupNameDes;
        private UILabel lbGroupQual;
        private UILabel lbGroupCount;
        private UILabel lbGroupName;
        private UILabel lbGroupSize;
        private UILabel lbStageTitle;
    }
}