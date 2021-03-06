﻿using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    partial class RaceNumberSettingForm
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
            this.txCodeLength = new UITextBox();
            this.labX_CodeLength = new UILabel();
            this.txStep = new UITextBox();
            this.labX_Step = new UILabel();
            this.txStartNumber = new UITextBox();
            this.labX_StartNumber = new UILabel();
            this.txPreFix = new UITextBox();
            this.labX_PreFix = new UILabel();
            this.btnX_Cancel = new DevComponents.DotNetBar.ButtonX();
            this.btnX_OK = new DevComponents.DotNetBar.ButtonX();
            this.chkX_SortByTime = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.SuspendLayout();
            // 
            // txCodeLength
            // 
            // 
            // 
            // 
            this.txCodeLength.Location = new System.Drawing.Point(103, 85);
            this.txCodeLength.Name = "txCodeLength";
            this.txCodeLength.Size = new System.Drawing.Size(134, 21);
            this.txCodeLength.TabIndex = 13;
            // 
            // labX_CodeLength
            // 
            this.labX_CodeLength.AutoSize = true;
            this.labX_CodeLength.Location = new System.Drawing.Point(2, 87);
            this.labX_CodeLength.Name = "labX_CodeLength";
            this.labX_CodeLength.Size = new System.Drawing.Size(75, 16);
            this.labX_CodeLength.TabIndex = 19;
            this.labX_CodeLength.Text = "CodeLength:";
            // 
            // txStep
            // 
            // 
            // 
            // 
            this.txStep.Location = new System.Drawing.Point(103, 60);
            this.txStep.Name = "txStep";
            this.txStep.Size = new System.Drawing.Size(134, 21);
            this.txStep.TabIndex = 12;
            // 
            // labX_Step
            // 
            this.labX_Step.AutoSize = true;
            this.labX_Step.Location = new System.Drawing.Point(2, 62);
            this.labX_Step.Name = "labX_Step";
            this.labX_Step.Size = new System.Drawing.Size(37, 16);
            this.labX_Step.TabIndex = 18;
            this.labX_Step.Text = "Step:";
            // 
            // txStartNumber
            // 
            // 
            // 
            // 
            this.txStartNumber.Location = new System.Drawing.Point(103, 35);
            this.txStartNumber.Name = "txStartNumber";
            this.txStartNumber.Size = new System.Drawing.Size(134, 21);
            this.txStartNumber.TabIndex = 11;
            // 
            // labX_StartNumber
            // 
            this.labX_StartNumber.AutoSize = true;
            this.labX_StartNumber.Location = new System.Drawing.Point(2, 37);
            this.labX_StartNumber.Name = "labX_StartNumber";
            this.labX_StartNumber.Size = new System.Drawing.Size(81, 16);
            this.labX_StartNumber.TabIndex = 17;
            this.labX_StartNumber.Text = "StartNumber:";
            // 
            // txPreFix
            // 
            // 
            // 
            // 
            this.txPreFix.Location = new System.Drawing.Point(103, 10);
            this.txPreFix.Name = "txPreFix";
            this.txPreFix.Size = new System.Drawing.Size(134, 21);
            this.txPreFix.TabIndex = 10;
            // 
            // labX_PreFix
            // 
            this.labX_PreFix.AutoSize = true;
            this.labX_PreFix.Location = new System.Drawing.Point(2, 12);
            this.labX_PreFix.Name = "labX_PreFix";
            this.labX_PreFix.Size = new System.Drawing.Size(50, 16);
            this.labX_PreFix.TabIndex = 16;
            this.labX_PreFix.Text = "PreFix:";
            // 
            // btnX_Cancel
            // 
            this.btnX_Cancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Cancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_Cancel.Image = global::Newauto.OVRMatchSchedule.Properties.Resources.cancel_24;
            this.btnX_Cancel.Location = new System.Drawing.Point(187, 115);
            this.btnX_Cancel.Name = "btnX_Cancel";
            this.btnX_Cancel.Size = new System.Drawing.Size(50, 30);
            this.btnX_Cancel.TabIndex = 15;
            this.btnX_Cancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnX_OK
            // 
            this.btnX_OK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_OK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_OK.Image = global::Newauto.OVRMatchSchedule.Properties.Resources.ok_24;
            this.btnX_OK.Location = new System.Drawing.Point(131, 115);
            this.btnX_OK.Name = "btnX_OK";
            this.btnX_OK.Size = new System.Drawing.Size(50, 30);
            this.btnX_OK.TabIndex = 14;
            this.btnX_OK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // chkX_SortByTime
            // 
            this.chkX_SortByTime.Location = new System.Drawing.Point(2, 116);
            this.chkX_SortByTime.Name = "chkX_SortByTime";
            this.chkX_SortByTime.Size = new System.Drawing.Size(101, 21);
            this.chkX_SortByTime.TabIndex = 20;
            this.chkX_SortByTime.Text = "Sort By Time";
            this.chkX_SortByTime.CheckedChanged += new System.EventHandler(this.chkX_SortByTime_CheckedChanged);
            // 
            // RaceNumberSettingForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(240, 147);
            this.Controls.Add(this.chkX_SortByTime);
            this.Controls.Add(this.btnX_Cancel);
            this.Controls.Add(this.btnX_OK);
            this.Controls.Add(this.txCodeLength);
            this.Controls.Add(this.labX_CodeLength);
            this.Controls.Add(this.txStep);
            this.Controls.Add(this.labX_Step);
            this.Controls.Add(this.txStartNumber);
            this.Controls.Add(this.labX_StartNumber);
            this.Controls.Add(this.txPreFix);
            this.Controls.Add(this.labX_PreFix);
            
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "RaceNumberSettingForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "RaceNumberSetting";
            this.Load += new System.EventHandler(this.RaceNumberSettingForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnX_Cancel;
        private DevComponents.DotNetBar.ButtonX btnX_OK;
        private UITextBox txCodeLength;
        private UILabel labX_CodeLength;
        private UITextBox txStep;
        private UILabel labX_Step;
        private UITextBox txStartNumber;
        private UILabel labX_StartNumber;
        private UITextBox txPreFix;
        private UILabel labX_PreFix;
        private DevComponents.DotNetBar.Controls.CheckBoxX chkX_SortByTime;

    }
}