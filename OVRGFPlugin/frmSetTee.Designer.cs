namespace AutoSports.OVRGFPlugin
{
    partial class frmSetTee
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
            this.lb_StartTime = new System.Windows.Forms.Label();
            this.tb_Tees = new System.Windows.Forms.TextBox();
            this.lb_SpanTime = new System.Windows.Forms.Label();
            this.lb_StartTee = new System.Windows.Forms.Label();
            this.btnx_OKSetTee = new DevComponents.DotNetBar.ButtonX();
            this.dti_SpanTime = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.dti_StartTime = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.btnx_Cancel = new DevComponents.DotNetBar.ButtonX();
            this.tb_Start = new System.Windows.Forms.TextBox();
            this.lb_StartGroup = new System.Windows.Forms.Label();
            this.tb_Finish = new System.Windows.Forms.TextBox();
            this.lb_FinishGroup = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.dti_SpanTime)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dti_StartTime)).BeginInit();
            this.SuspendLayout();
            // 
            // lb_StartTime
            // 
            this.lb_StartTime.AutoSize = true;
            this.lb_StartTime.Location = new System.Drawing.Point(12, 74);
            this.lb_StartTime.Name = "lb_StartTime";
            this.lb_StartTime.Size = new System.Drawing.Size(71, 12);
            this.lb_StartTime.TabIndex = 2;
            this.lb_StartTime.Text = "Start Time:";
            // 
            // tb_Tees
            // 
            this.tb_Tees.Location = new System.Drawing.Point(158, 36);
            this.tb_Tees.MaxLength = 2;
            this.tb_Tees.Name = "tb_Tees";
            this.tb_Tees.Size = new System.Drawing.Size(67, 21);
            this.tb_Tees.TabIndex = 5;
            this.tb_Tees.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tb_Tees_KeyPress);
            // 
            // lb_SpanTime
            // 
            this.lb_SpanTime.AutoSize = true;
            this.lb_SpanTime.Location = new System.Drawing.Point(12, 105);
            this.lb_SpanTime.Name = "lb_SpanTime";
            this.lb_SpanTime.Size = new System.Drawing.Size(125, 12);
            this.lb_SpanTime.TabIndex = 3;
            this.lb_SpanTime.Text = "Time Between Groups:";
            // 
            // lb_StartTee
            // 
            this.lb_StartTee.AutoSize = true;
            this.lb_StartTee.Location = new System.Drawing.Point(12, 45);
            this.lb_StartTee.Name = "lb_StartTee";
            this.lb_StartTee.Size = new System.Drawing.Size(89, 12);
            this.lb_StartTee.TabIndex = 1;
            this.lb_StartTee.Text = "Starting Tees:";
            // 
            // btnx_OKSetTee
            // 
            this.btnx_OKSetTee.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_OKSetTee.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_OKSetTee.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.ok_24;
            this.btnx_OKSetTee.Location = new System.Drawing.Point(100, 135);
            this.btnx_OKSetTee.Name = "btnx_OKSetTee";
            this.btnx_OKSetTee.Size = new System.Drawing.Size(50, 30);
            this.btnx_OKSetTee.TabIndex = 8;
            this.btnx_OKSetTee.Click += new System.EventHandler(this.btnx_OKSetTee_Click);
            // 
            // dti_SpanTime
            // 
            // 
            // 
            // 
            this.dti_SpanTime.BackgroundStyle.Class = "DateTimeInputBackground";
            this.dti_SpanTime.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_SpanTime.ButtonDropDown.Enabled = false;
            this.dti_SpanTime.ButtonDropDown.Shortcut = DevComponents.DotNetBar.eShortcut.AltDown;
            this.dti_SpanTime.CustomFormat = "HH:mm";
            this.dti_SpanTime.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.dti_SpanTime.Location = new System.Drawing.Point(158, 96);
            // 
            // 
            // 
            this.dti_SpanTime.MonthCalendar.AnnuallyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_SpanTime.MonthCalendar.BackgroundStyle.BackColor = System.Drawing.SystemColors.Window;
            this.dti_SpanTime.MonthCalendar.BackgroundStyle.Class = "";
            this.dti_SpanTime.MonthCalendar.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_SpanTime.MonthCalendar.ClearButtonVisible = true;
            // 
            // 
            // 
            this.dti_SpanTime.MonthCalendar.CommandsBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground2;
            this.dti_SpanTime.MonthCalendar.CommandsBackgroundStyle.BackColorGradientAngle = 90;
            this.dti_SpanTime.MonthCalendar.CommandsBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.dti_SpanTime.MonthCalendar.CommandsBackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.dti_SpanTime.MonthCalendar.CommandsBackgroundStyle.BorderTopColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarDockedBorder;
            this.dti_SpanTime.MonthCalendar.CommandsBackgroundStyle.BorderTopWidth = 1;
            this.dti_SpanTime.MonthCalendar.CommandsBackgroundStyle.Class = "";
            this.dti_SpanTime.MonthCalendar.CommandsBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_SpanTime.MonthCalendar.DisplayMonth = new System.DateTime(2009, 11, 1, 0, 0, 0, 0);
            this.dti_SpanTime.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.dti_SpanTime.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_SpanTime.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.dti_SpanTime.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.dti_SpanTime.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.dti_SpanTime.MonthCalendar.NavigationBackgroundStyle.Class = "";
            this.dti_SpanTime.MonthCalendar.NavigationBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_SpanTime.MonthCalendar.TodayButtonVisible = true;
            this.dti_SpanTime.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.dti_SpanTime.Name = "dti_SpanTime";
            this.dti_SpanTime.ShowUpDown = true;
            this.dti_SpanTime.Size = new System.Drawing.Size(67, 21);
            this.dti_SpanTime.TabIndex = 11;
            this.dti_SpanTime.TextChanged += new System.EventHandler(this.dti_SpanTime_TextChanged);
            // 
            // dti_StartTime
            // 
            // 
            // 
            // 
            this.dti_StartTime.BackgroundStyle.Class = "DateTimeInputBackground";
            this.dti_StartTime.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_StartTime.ButtonDropDown.Enabled = false;
            this.dti_StartTime.ButtonDropDown.Shortcut = DevComponents.DotNetBar.eShortcut.AltDown;
            this.dti_StartTime.CustomFormat = "HH:mm";
            this.dti_StartTime.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.dti_StartTime.Location = new System.Drawing.Point(158, 65);
            // 
            // 
            // 
            this.dti_StartTime.MonthCalendar.AnnuallyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_StartTime.MonthCalendar.BackgroundStyle.BackColor = System.Drawing.SystemColors.Window;
            this.dti_StartTime.MonthCalendar.BackgroundStyle.Class = "";
            this.dti_StartTime.MonthCalendar.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
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
            this.dti_StartTime.MonthCalendar.CommandsBackgroundStyle.Class = "";
            this.dti_StartTime.MonthCalendar.CommandsBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_StartTime.MonthCalendar.DisplayMonth = new System.DateTime(2009, 11, 1, 0, 0, 0, 0);
            this.dti_StartTime.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.dti_StartTime.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_StartTime.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.dti_StartTime.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.dti_StartTime.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.dti_StartTime.MonthCalendar.NavigationBackgroundStyle.Class = "";
            this.dti_StartTime.MonthCalendar.NavigationBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_StartTime.MonthCalendar.TodayButtonVisible = true;
            this.dti_StartTime.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.dti_StartTime.Name = "dti_StartTime";
            this.dti_StartTime.ShowUpDown = true;
            this.dti_StartTime.Size = new System.Drawing.Size(67, 21);
            this.dti_StartTime.TabIndex = 10;
            this.dti_StartTime.TextChanged += new System.EventHandler(this.dti_StartTime_TextChanged);
            // 
            // btnx_Cancel
            // 
            this.btnx_Cancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Cancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Cancel.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.cancel_24;
            this.btnx_Cancel.Location = new System.Drawing.Point(170, 135);
            this.btnx_Cancel.Name = "btnx_Cancel";
            this.btnx_Cancel.Size = new System.Drawing.Size(50, 30);
            this.btnx_Cancel.TabIndex = 8;
            this.btnx_Cancel.Click += new System.EventHandler(this.btnx_Cancel_Click);
            // 
            // tb_Start
            // 
            this.tb_Start.Location = new System.Drawing.Point(92, 7);
            this.tb_Start.MaxLength = 2;
            this.tb_Start.Name = "tb_Start";
            this.tb_Start.Size = new System.Drawing.Size(30, 21);
            this.tb_Start.TabIndex = 13;
            this.tb_Start.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tb_Start_KeyPress);
            // 
            // lb_StartGroup
            // 
            this.lb_StartGroup.AutoSize = true;
            this.lb_StartGroup.Location = new System.Drawing.Point(13, 16);
            this.lb_StartGroup.Name = "lb_StartGroup";
            this.lb_StartGroup.Size = new System.Drawing.Size(77, 12);
            this.lb_StartGroup.TabIndex = 12;
            this.lb_StartGroup.Text = "Start Group:";
            // 
            // tb_Finish
            // 
            this.tb_Finish.Location = new System.Drawing.Point(205, 7);
            this.tb_Finish.MaxLength = 2;
            this.tb_Finish.Name = "tb_Finish";
            this.tb_Finish.Size = new System.Drawing.Size(30, 21);
            this.tb_Finish.TabIndex = 15;
            this.tb_Finish.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tb_Finish_KeyPress);
            // 
            // lb_FinishGroup
            // 
            this.lb_FinishGroup.AutoSize = true;
            this.lb_FinishGroup.Location = new System.Drawing.Point(122, 16);
            this.lb_FinishGroup.Name = "lb_FinishGroup";
            this.lb_FinishGroup.Size = new System.Drawing.Size(83, 12);
            this.lb_FinishGroup.TabIndex = 14;
            this.lb_FinishGroup.Text = "Finish Group:";
            // 
            // frmSetTee
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.ClientSize = new System.Drawing.Size(256, 169);
            this.Controls.Add(this.tb_Finish);
            this.Controls.Add(this.lb_FinishGroup);
            this.Controls.Add(this.tb_Start);
            this.Controls.Add(this.lb_StartGroup);
            this.Controls.Add(this.dti_SpanTime);
            this.Controls.Add(this.dti_StartTime);
            this.Controls.Add(this.btnx_Cancel);
            this.Controls.Add(this.btnx_OKSetTee);
            this.Controls.Add(this.tb_Tees);
            this.Controls.Add(this.lb_StartTee);
            this.Controls.Add(this.lb_SpanTime);
            this.Controls.Add(this.lb_StartTime);
            this.DoubleBuffered = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmSetTee";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmSetTee";
            this.Load += new System.EventHandler(this.frmSetTee_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dti_SpanTime)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dti_StartTime)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lb_StartTime;
        private System.Windows.Forms.TextBox tb_Tees;
        private System.Windows.Forms.Label lb_SpanTime;
        private System.Windows.Forms.Label lb_StartTee;
        private DevComponents.DotNetBar.ButtonX btnx_OKSetTee;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dti_SpanTime;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dti_StartTime;
        private DevComponents.DotNetBar.ButtonX btnx_Cancel;
        private System.Windows.Forms.TextBox tb_Start;
        private System.Windows.Forms.Label lb_StartGroup;
        private System.Windows.Forms.TextBox tb_Finish;
        private System.Windows.Forms.Label lb_FinishGroup;
    }
}