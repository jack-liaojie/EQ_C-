using Sunny.UI;

namespace AutoSports.OVRDrawModel
{
    partial class AxModelWizardGroupForm
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
            this.lbStageTitle = new UILabel();
            this.tbStageTitle = new UITextBox();
            this.lbGroupSize = new UILabel();
            this.cbGroupSize = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbGroupCount = new UILabel();
            this.cbGroupCount = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbGroupQual = new UILabel();
            this.cbGroupQual = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbGroupName = new UILabel();
            this.tbGroupName = new UITextBox();
            this.lbNamingMode = new UILabel();
            this.radNumber = new System.Windows.Forms.RadioButton();
            this.radLetter = new System.Windows.Forms.RadioButton();
            this.chbUseBegol = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.lbGroupNameDes = new UILabel();
            this.lbPlayerCountDes = new UILabel();
            this.SuspendLayout();
            // 
            // lbStageTitle
            // 
            this.lbStageTitle.Location = new System.Drawing.Point(3, 4);
            this.lbStageTitle.Name = "lbStageTitle";
            this.lbStageTitle.Size = new System.Drawing.Size(76, 28);
            this.lbStageTitle.TabIndex = 0;
            this.lbStageTitle.Text = "StageTitle:";
            // 
            // tbStageTitle
            // 
            // 
            // 
            // 
            this.tbStageTitle.Location = new System.Drawing.Point(79, 7);
            this.tbStageTitle.Name = "tbStageTitle";
            this.tbStageTitle.Size = new System.Drawing.Size(123, 21);
            this.tbStageTitle.TabIndex = 1;
            // 
            // lbGroupSize
            // 
            this.lbGroupSize.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.lbGroupSize.Location = new System.Drawing.Point(3, 38);
            this.lbGroupSize.Name = "lbGroupSize";
            this.lbGroupSize.Size = new System.Drawing.Size(76, 28);
            this.lbGroupSize.TabIndex = 0;
            this.lbGroupSize.Text = "GroupSize:";
            // 
            // cbGroupSize
            // 
            this.cbGroupSize.DisplayMember = "Text";
            this.cbGroupSize.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbGroupSize.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbGroupSize.FormattingEnabled = true;
            this.cbGroupSize.ItemHeight = 15;
            this.cbGroupSize.Location = new System.Drawing.Point(79, 42);
            this.cbGroupSize.Name = "cbGroupSize";
            this.cbGroupSize.Size = new System.Drawing.Size(123, 21);
            this.cbGroupSize.TabIndex = 2;
            this.cbGroupSize.SelectedIndexChanged += new System.EventHandler(this.cbGroupSize_SelectedIndexChanged);
            // 
            // lbGroupCount
            // 
            this.lbGroupCount.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.lbGroupCount.Location = new System.Drawing.Point(3, 72);
            this.lbGroupCount.Name = "lbGroupCount";
            this.lbGroupCount.Size = new System.Drawing.Size(76, 28);
            this.lbGroupCount.TabIndex = 0;
            this.lbGroupCount.Text = "GroupCount:";
            // 
            // cbGroupCount
            // 
            this.cbGroupCount.DisplayMember = "Text";
            this.cbGroupCount.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbGroupCount.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbGroupCount.FormattingEnabled = true;
            this.cbGroupCount.ItemHeight = 15;
            this.cbGroupCount.Location = new System.Drawing.Point(79, 77);
            this.cbGroupCount.Name = "cbGroupCount";
            this.cbGroupCount.Size = new System.Drawing.Size(123, 21);
            this.cbGroupCount.TabIndex = 2;
            this.cbGroupCount.SelectedIndexChanged += new System.EventHandler(this.cbGroupCount_SelectedIndexChanged);
            // 
            // lbGroupQual
            // 
            this.lbGroupQual.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.lbGroupQual.Location = new System.Drawing.Point(3, 106);
            this.lbGroupQual.Name = "lbGroupQual";
            this.lbGroupQual.Size = new System.Drawing.Size(76, 28);
            this.lbGroupQual.TabIndex = 0;
            this.lbGroupQual.Text = "GroupQual:";
            // 
            // cbGroupQual
            // 
            this.cbGroupQual.DisplayMember = "Text";
            this.cbGroupQual.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbGroupQual.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbGroupQual.FormattingEnabled = true;
            this.cbGroupQual.ItemHeight = 15;
            this.cbGroupQual.Location = new System.Drawing.Point(79, 112);
            this.cbGroupQual.Name = "cbGroupQual";
            this.cbGroupQual.Size = new System.Drawing.Size(123, 21);
            this.cbGroupQual.TabIndex = 2;
            this.cbGroupQual.SelectedIndexChanged += new System.EventHandler(this.cbGroupQual_SelectedIndexChanged);
            // 
            // lbGroupName
            // 
            this.lbGroupName.Location = new System.Drawing.Point(223, 4);
            this.lbGroupName.Name = "lbGroupName";
            this.lbGroupName.Size = new System.Drawing.Size(76, 28);
            this.lbGroupName.TabIndex = 0;
            this.lbGroupName.Text = "GroupName:";
            // 
            // tbGroupName
            // 
            // 
            // 
            // 
            this.tbGroupName.Location = new System.Drawing.Point(304, 7);
            this.tbGroupName.Name = "tbGroupName";
            this.tbGroupName.Size = new System.Drawing.Size(101, 21);
            this.tbGroupName.TabIndex = 1;
            this.tbGroupName.TextChanged += new System.EventHandler(this.tbGroupName_TextChanged);
            // 
            // lbNamingMode
            // 
            this.lbNamingMode.AutoSize = true;
            this.lbNamingMode.Location = new System.Drawing.Point(223, 41);
            this.lbNamingMode.Name = "lbNamingMode";
            this.lbNamingMode.Size = new System.Drawing.Size(75, 16);
            this.lbNamingMode.TabIndex = 3;
            this.lbNamingMode.Text = "NamingMode:";
            // 
            // radNumber
            // 
            this.radNumber.AutoSize = true;
            this.radNumber.Location = new System.Drawing.Point(270, 70);
            this.radNumber.Name = "radNumber";
            this.radNumber.Size = new System.Drawing.Size(53, 16);
            this.radNumber.TabIndex = 4;
            this.radNumber.TabStop = true;
            this.radNumber.Text = "1,2,3";
            this.radNumber.UseVisualStyleBackColor = true;
            this.radNumber.CheckedChanged += new System.EventHandler(this.radNumber_CheckedChanged);
            // 
            // radLetter
            // 
            this.radLetter.AutoSize = true;
            this.radLetter.Location = new System.Drawing.Point(270, 92);
            this.radLetter.Name = "radLetter";
            this.radLetter.Size = new System.Drawing.Size(53, 16);
            this.radLetter.TabIndex = 4;
            this.radLetter.TabStop = true;
            this.radLetter.Text = "A,B,C";
            this.radLetter.UseVisualStyleBackColor = true;
            this.radLetter.CheckedChanged += new System.EventHandler(this.radLetter_CheckedChanged);
            // 
            // chbUseBegol
            // 
            this.chbUseBegol.AutoSize = true;
            this.chbUseBegol.Location = new System.Drawing.Point(223, 114);
            this.chbUseBegol.Name = "chbUseBegol";
            this.chbUseBegol.Size = new System.Drawing.Size(76, 16);
            this.chbUseBegol.TabIndex = 5;
            this.chbUseBegol.Text = "UseBegol";
            // 
            // lbGroupNameDes
            // 
            this.lbGroupNameDes.AutoSize = true;
            this.lbGroupNameDes.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.lbGroupNameDes.Location = new System.Drawing.Point(3, 149);
            this.lbGroupNameDes.Name = "lbGroupNameDes";
            this.lbGroupNameDes.Size = new System.Drawing.Size(81, 16);
            this.lbGroupNameDes.TabIndex = 0;
            this.lbGroupNameDes.Text = "GroupNameDes";
            // 
            // lbPlayerCountDes
            // 
            this.lbPlayerCountDes.AutoSize = true;
            this.lbPlayerCountDes.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.lbPlayerCountDes.Location = new System.Drawing.Point(3, 183);
            this.lbPlayerCountDes.Name = "lbPlayerCountDes";
            this.lbPlayerCountDes.Size = new System.Drawing.Size(93, 16);
            this.lbPlayerCountDes.TabIndex = 0;
            this.lbPlayerCountDes.Text = "PlayerCountDes";
            // 
            // AxModelWizardGroupForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(417, 207);
            this.Controls.Add(this.chbUseBegol);
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
            this.Name = "AxModelWizardGroupForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "ModelWizardGroupForm";
            this.Load += new System.EventHandler(this.AxModelWizardGroupForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private UILabel lbStageTitle;
        private UITextBox tbStageTitle;
        private UILabel lbGroupSize;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbGroupSize;
        private UILabel lbGroupCount;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbGroupCount;
        private UILabel lbGroupQual;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbGroupQual;
        private UILabel lbGroupName;
        private UITextBox tbGroupName;
        private UILabel lbNamingMode;
        private System.Windows.Forms.RadioButton radNumber;
        private System.Windows.Forms.RadioButton radLetter;
        private DevComponents.DotNetBar.Controls.CheckBoxX chbUseBegol;
        private UILabel lbGroupNameDes;
        private UILabel lbPlayerCountDes;
    }
}