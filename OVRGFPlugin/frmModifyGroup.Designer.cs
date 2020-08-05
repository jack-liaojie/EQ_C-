namespace AutoSports.OVRGFPlugin
{
    partial class frmModifyGroup
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
            this.btnx_Cancel = new DevComponents.DotNetBar.ButtonX();
            this.btnx_OK = new DevComponents.DotNetBar.ButtonX();
            this.dti_StartTime = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.tb_Tees = new System.Windows.Forms.TextBox();
            this.tb_Group = new System.Windows.Forms.TextBox();
            this.lb_StartTee = new System.Windows.Forms.Label();
            this.lb_StartTime = new System.Windows.Forms.Label();
            this.lb_Group = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.dti_StartTime)).BeginInit();
            this.SuspendLayout();
            // 
            // btnx_Cancel
            // 
            this.btnx_Cancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Cancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Cancel.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.cancel_24;
            this.btnx_Cancel.Location = new System.Drawing.Point(175, 106);
            this.btnx_Cancel.Name = "btnx_Cancel";
            this.btnx_Cancel.Size = new System.Drawing.Size(50, 30);
            this.btnx_Cancel.TabIndex = 12;
            this.btnx_Cancel.Click += new System.EventHandler(this.btnx_Cancel_Click);
            // 
            // btnx_OK
            // 
            this.btnx_OK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_OK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_OK.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.ok_24;
            this.btnx_OK.Location = new System.Drawing.Point(103, 106);
            this.btnx_OK.Name = "btnx_OK";
            this.btnx_OK.Size = new System.Drawing.Size(50, 30);
            this.btnx_OK.TabIndex = 11;
            this.btnx_OK.Click += new System.EventHandler(this.btnx_OK_Click);
            // 
            // dti_StartTime
            // 
            // 
            // 
            // 
            this.dti_StartTime.BackgroundStyle.Class = "DateTimeInputBackground";
            this.dti_StartTime.ButtonDropDown.Enabled = false;
            this.dti_StartTime.ButtonDropDown.Shortcut = DevComponents.DotNetBar.eShortcut.AltDown;
            this.dti_StartTime.CustomFormat = "HH:mm";
            this.dti_StartTime.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.dti_StartTime.Location = new System.Drawing.Point(154, 64);
            // 
            // 
            // 
            this.dti_StartTime.MonthCalendar.AnnuallyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_StartTime.MonthCalendar.BackgroundStyle.BackColor = System.Drawing.SystemColors.Window;
            this.dti_StartTime.MonthCalendar.ClearButtonVisible = true;
            // 
            // 
            // 
            this.dti_StartTime.MonthCalendar.CommandsBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground2;
            this.dti_StartTime.MonthCalendar.CommandsBackgroundStyle.BackColorGradientAngle = 90;
            this.dti_StartTime.MonthCalendar.CommandsBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.dti_StartTime.MonthCalendar.CommandsBackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.dti_StartTime.MonthCalendar.CommandsBackgroundStyle.BorderTopColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarDockedBorder;
            this.dti_StartTime.MonthCalendar.CommandsBackgroundStyle.BorderTopWidth = 1;
            this.dti_StartTime.MonthCalendar.DisplayMonth = new System.DateTime(2009, 11, 1, 0, 0, 0, 0);
            this.dti_StartTime.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.dti_StartTime.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_StartTime.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.dti_StartTime.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.dti_StartTime.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.dti_StartTime.MonthCalendar.TodayButtonVisible = true;
            this.dti_StartTime.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.dti_StartTime.Name = "dti_StartTime";
            this.dti_StartTime.ShowUpDown = true;
            this.dti_StartTime.Size = new System.Drawing.Size(67, 21);
            this.dti_StartTime.TabIndex = 18;
            // 
            // tb_Tees
            // 
            this.tb_Tees.Location = new System.Drawing.Point(154, 35);
            this.tb_Tees.MaxLength = 2;
            this.tb_Tees.Name = "tb_Tees";
            this.tb_Tees.Size = new System.Drawing.Size(67, 21);
            this.tb_Tees.TabIndex = 17;
            this.tb_Tees.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tb_Tees_KeyPress);
            // 
            // tb_Group
            // 
            this.tb_Group.Location = new System.Drawing.Point(154, 7);
            this.tb_Group.MaxLength = 1;
            this.tb_Group.Name = "tb_Group";
            this.tb_Group.ReadOnly = true;
            this.tb_Group.Size = new System.Drawing.Size(67, 21);
            this.tb_Group.TabIndex = 16;
            // 
            // lb_StartTee
            // 
            this.lb_StartTee.AutoSize = true;
            this.lb_StartTee.Location = new System.Drawing.Point(8, 44);
            this.lb_StartTee.Name = "lb_StartTee";
            this.lb_StartTee.Size = new System.Drawing.Size(89, 12);
            this.lb_StartTee.TabIndex = 14;
            this.lb_StartTee.Text = "Starting Tees:";
            // 
            // lb_StartTime
            // 
            this.lb_StartTime.AutoSize = true;
            this.lb_StartTime.Location = new System.Drawing.Point(8, 73);
            this.lb_StartTime.Name = "lb_StartTime";
            this.lb_StartTime.Size = new System.Drawing.Size(71, 12);
            this.lb_StartTime.TabIndex = 15;
            this.lb_StartTime.Text = "Start Time:";
            // 
            // lb_Group
            // 
            this.lb_Group.AutoSize = true;
            this.lb_Group.Location = new System.Drawing.Point(8, 16);
            this.lb_Group.Name = "lb_Group";
            this.lb_Group.Size = new System.Drawing.Size(41, 12);
            this.lb_Group.TabIndex = 13;
            this.lb_Group.Text = "Group:";
            // 
            // frmModifyGroup
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.ClientSize = new System.Drawing.Size(232, 146);
            this.Controls.Add(this.dti_StartTime);
            this.Controls.Add(this.tb_Tees);
            this.Controls.Add(this.tb_Group);
            this.Controls.Add(this.lb_StartTee);
            this.Controls.Add(this.lb_StartTime);
            this.Controls.Add(this.lb_Group);
            this.Controls.Add(this.btnx_Cancel);
            this.Controls.Add(this.btnx_OK);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmModifyGroup";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "frmModifyGroup";
            this.Load += new System.EventHandler(this.frmModifyGroup_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dti_StartTime)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnx_Cancel;
        private DevComponents.DotNetBar.ButtonX btnx_OK;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dti_StartTime;
        private System.Windows.Forms.TextBox tb_Tees;
        private System.Windows.Forms.TextBox tb_Group;
        private System.Windows.Forms.Label lb_StartTee;
        private System.Windows.Forms.Label lb_StartTime;
        private System.Windows.Forms.Label lb_Group;

    }
}