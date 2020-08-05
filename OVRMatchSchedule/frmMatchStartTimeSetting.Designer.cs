using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    partial class MatchStartTimeSettingForm
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
            this.btnX_OK = new DevComponents.DotNetBar.ButtonX();
            this.labX_StartTime = new Sunny.UI.UILabel();
            this.dti_StartTime = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.labX_SpanTime = new Sunny.UI.UILabel();
            this.dti_SpanTime = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.chkX_DelayTime = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.dti_DelayTime = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.labX_DelayTime = new Sunny.UI.UILabel();
            this.dti_SpendTime = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.labX_SpendTime = new Sunny.UI.UILabel();
            this.dti_AdvanceTime = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.labX_AdvanceTime = new Sunny.UI.UILabel();
            this.chkX_AdvanceTime = new DevComponents.DotNetBar.Controls.CheckBoxX();
            ((System.ComponentModel.ISupportInitialize)(this.dti_StartTime)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dti_SpanTime)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dti_DelayTime)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dti_SpendTime)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dti_AdvanceTime)).BeginInit();
            this.SuspendLayout();
            // 
            // btnX_Cancel
            // 
            this.btnX_Cancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Cancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_Cancel.Image = global::Newauto.OVRMatchSchedule.Properties.Resources.cancel_24;
            this.btnX_Cancel.Location = new System.Drawing.Point(169, 147);
            this.btnX_Cancel.Name = "btnX_Cancel";
            this.btnX_Cancel.Size = new System.Drawing.Size(50, 30);
            this.btnX_Cancel.TabIndex = 5;
            this.btnX_Cancel.Click += new System.EventHandler(this.btnX_Cancel_Click);
            // 
            // btnX_OK
            // 
            this.btnX_OK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_OK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_OK.Image = global::Newauto.OVRMatchSchedule.Properties.Resources.ok_24;
            this.btnX_OK.Location = new System.Drawing.Point(113, 147);
            this.btnX_OK.Name = "btnX_OK";
            this.btnX_OK.Size = new System.Drawing.Size(50, 30);
            this.btnX_OK.TabIndex = 4;
            this.btnX_OK.Click += new System.EventHandler(this.btnX_OK_Click);
            // 
            // labX_StartTime
            // 
            this.labX_StartTime.AutoSize = true;
            this.labX_StartTime.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.labX_StartTime.Location = new System.Drawing.Point(2, 35);
            this.labX_StartTime.Name = "labX_StartTime";
            this.labX_StartTime.Size = new System.Drawing.Size(92, 21);
            this.labX_StartTime.Style = Sunny.UI.UIStyle.Custom;
            this.labX_StartTime.TabIndex = 6;
            this.labX_StartTime.Text = "Start Time:";
            this.labX_StartTime.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
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
            this.dti_StartTime.Location = new System.Drawing.Point(88, 35);
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
            this.dti_StartTime.Size = new System.Drawing.Size(131, 29);
            this.dti_StartTime.TabIndex = 7;
            this.dti_StartTime.TextChanged += new System.EventHandler(this.dti_StartTime_TextChanged);
            // 
            // labX_SpanTime
            // 
            this.labX_SpanTime.AutoSize = true;
            this.labX_SpanTime.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.labX_SpanTime.Location = new System.Drawing.Point(2, 66);
            this.labX_SpanTime.Name = "labX_SpanTime";
            this.labX_SpanTime.Size = new System.Drawing.Size(94, 21);
            this.labX_SpanTime.Style = Sunny.UI.UIStyle.Custom;
            this.labX_SpanTime.TabIndex = 8;
            this.labX_SpanTime.Text = "Span Time:";
            this.labX_SpanTime.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
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
            this.dti_SpanTime.Location = new System.Drawing.Point(88, 64);
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
            this.dti_SpanTime.Size = new System.Drawing.Size(131, 29);
            this.dti_SpanTime.TabIndex = 9;
            this.dti_SpanTime.TextChanged += new System.EventHandler(this.dti_SpanTime_TextChanged);
            // 
            // chkX_DelayTime
            // 
            // 
            // 
            // 
            this.chkX_DelayTime.BackgroundStyle.Class = "";
            this.chkX_DelayTime.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.chkX_DelayTime.Location = new System.Drawing.Point(219, 120);
            this.chkX_DelayTime.Name = "chkX_DelayTime";
            this.chkX_DelayTime.Size = new System.Drawing.Size(19, 20);
            this.chkX_DelayTime.TabIndex = 10;
            this.chkX_DelayTime.CheckedChanged += new System.EventHandler(this.chkX_DelayTime_CheckedChanged);
            // 
            // dti_DelayTime
            // 
            // 
            // 
            // 
            this.dti_DelayTime.BackgroundStyle.Class = "DateTimeInputBackground";
            this.dti_DelayTime.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_DelayTime.ButtonDropDown.Enabled = false;
            this.dti_DelayTime.ButtonDropDown.Shortcut = DevComponents.DotNetBar.eShortcut.AltDown;
            this.dti_DelayTime.CustomFormat = "HH:mm";
            this.dti_DelayTime.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.dti_DelayTime.Location = new System.Drawing.Point(88, 120);
            // 
            // 
            // 
            this.dti_DelayTime.MonthCalendar.AnnuallyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_DelayTime.MonthCalendar.BackgroundStyle.BackColor = System.Drawing.SystemColors.Window;
            this.dti_DelayTime.MonthCalendar.BackgroundStyle.Class = "";
            this.dti_DelayTime.MonthCalendar.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_DelayTime.MonthCalendar.ClearButtonVisible = true;
            // 
            // 
            // 
            this.dti_DelayTime.MonthCalendar.CommandsBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground2;
            this.dti_DelayTime.MonthCalendar.CommandsBackgroundStyle.BackColorGradientAngle = 90;
            this.dti_DelayTime.MonthCalendar.CommandsBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.dti_DelayTime.MonthCalendar.CommandsBackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.dti_DelayTime.MonthCalendar.CommandsBackgroundStyle.BorderTopColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarDockedBorder;
            this.dti_DelayTime.MonthCalendar.CommandsBackgroundStyle.BorderTopWidth = 1;
            this.dti_DelayTime.MonthCalendar.CommandsBackgroundStyle.Class = "";
            this.dti_DelayTime.MonthCalendar.CommandsBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_DelayTime.MonthCalendar.DisplayMonth = new System.DateTime(2009, 11, 1, 0, 0, 0, 0);
            this.dti_DelayTime.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.dti_DelayTime.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_DelayTime.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.dti_DelayTime.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.dti_DelayTime.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.dti_DelayTime.MonthCalendar.NavigationBackgroundStyle.Class = "";
            this.dti_DelayTime.MonthCalendar.NavigationBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_DelayTime.MonthCalendar.TodayButtonVisible = true;
            this.dti_DelayTime.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.dti_DelayTime.Name = "dti_DelayTime";
            this.dti_DelayTime.ShowUpDown = true;
            this.dti_DelayTime.Size = new System.Drawing.Size(131, 29);
            this.dti_DelayTime.TabIndex = 12;
            this.dti_DelayTime.TextChanged += new System.EventHandler(this.dti_DelayTime_TextChanged);
            // 
            // labX_DelayTime
            // 
            this.labX_DelayTime.AutoSize = true;
            this.labX_DelayTime.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.labX_DelayTime.Location = new System.Drawing.Point(2, 122);
            this.labX_DelayTime.Name = "labX_DelayTime";
            this.labX_DelayTime.Size = new System.Drawing.Size(98, 21);
            this.labX_DelayTime.Style = Sunny.UI.UIStyle.Custom;
            this.labX_DelayTime.TabIndex = 11;
            this.labX_DelayTime.Text = "Delay Time:";
            this.labX_DelayTime.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // dti_SpendTime
            // 
            // 
            // 
            // 
            this.dti_SpendTime.BackgroundStyle.Class = "DateTimeInputBackground";
            this.dti_SpendTime.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_SpendTime.ButtonDropDown.Enabled = false;
            this.dti_SpendTime.ButtonDropDown.Shortcut = DevComponents.DotNetBar.eShortcut.AltDown;
            this.dti_SpendTime.CustomFormat = "HH:mm";
            this.dti_SpendTime.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.dti_SpendTime.Location = new System.Drawing.Point(88, 37);
            // 
            // 
            // 
            this.dti_SpendTime.MonthCalendar.AnnuallyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_SpendTime.MonthCalendar.BackgroundStyle.BackColor = System.Drawing.SystemColors.Window;
            this.dti_SpendTime.MonthCalendar.BackgroundStyle.Class = "";
            this.dti_SpendTime.MonthCalendar.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_SpendTime.MonthCalendar.ClearButtonVisible = true;
            // 
            // 
            // 
            this.dti_SpendTime.MonthCalendar.CommandsBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground2;
            this.dti_SpendTime.MonthCalendar.CommandsBackgroundStyle.BackColorGradientAngle = 90;
            this.dti_SpendTime.MonthCalendar.CommandsBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.dti_SpendTime.MonthCalendar.CommandsBackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.dti_SpendTime.MonthCalendar.CommandsBackgroundStyle.BorderTopColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarDockedBorder;
            this.dti_SpendTime.MonthCalendar.CommandsBackgroundStyle.BorderTopWidth = 1;
            this.dti_SpendTime.MonthCalendar.CommandsBackgroundStyle.Class = "";
            this.dti_SpendTime.MonthCalendar.CommandsBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_SpendTime.MonthCalendar.DisplayMonth = new System.DateTime(2009, 11, 1, 0, 0, 0, 0);
            this.dti_SpendTime.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.dti_SpendTime.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_SpendTime.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.dti_SpendTime.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.dti_SpendTime.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.dti_SpendTime.MonthCalendar.NavigationBackgroundStyle.Class = "";
            this.dti_SpendTime.MonthCalendar.NavigationBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_SpendTime.MonthCalendar.TodayButtonVisible = true;
            this.dti_SpendTime.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.dti_SpendTime.Name = "dti_SpendTime";
            this.dti_SpendTime.ShowUpDown = true;
            this.dti_SpendTime.Size = new System.Drawing.Size(131, 29);
            this.dti_SpendTime.TabIndex = 14;
            this.dti_SpendTime.TextChanged += new System.EventHandler(this.dti_SpendTime_TextChanged);
            // 
            // labX_SpendTime
            // 
            this.labX_SpendTime.AutoSize = true;
            this.labX_SpendTime.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.labX_SpendTime.Location = new System.Drawing.Point(2, 39);
            this.labX_SpendTime.Name = "labX_SpendTime";
            this.labX_SpendTime.Size = new System.Drawing.Size(104, 21);
            this.labX_SpendTime.Style = Sunny.UI.UIStyle.Custom;
            this.labX_SpendTime.TabIndex = 13;
            this.labX_SpendTime.Text = "Spend Time:";
            this.labX_SpendTime.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // dti_AdvanceTime
            // 
            // 
            // 
            // 
            this.dti_AdvanceTime.BackgroundStyle.Class = "DateTimeInputBackground";
            this.dti_AdvanceTime.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_AdvanceTime.ButtonDropDown.Enabled = false;
            this.dti_AdvanceTime.ButtonDropDown.Shortcut = DevComponents.DotNetBar.eShortcut.AltDown;
            this.dti_AdvanceTime.CustomFormat = "HH:mm";
            this.dti_AdvanceTime.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.dti_AdvanceTime.Location = new System.Drawing.Point(88, 92);
            // 
            // 
            // 
            this.dti_AdvanceTime.MonthCalendar.AnnuallyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_AdvanceTime.MonthCalendar.BackgroundStyle.BackColor = System.Drawing.SystemColors.Window;
            this.dti_AdvanceTime.MonthCalendar.BackgroundStyle.Class = "";
            this.dti_AdvanceTime.MonthCalendar.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_AdvanceTime.MonthCalendar.ClearButtonVisible = true;
            // 
            // 
            // 
            this.dti_AdvanceTime.MonthCalendar.CommandsBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground2;
            this.dti_AdvanceTime.MonthCalendar.CommandsBackgroundStyle.BackColorGradientAngle = 90;
            this.dti_AdvanceTime.MonthCalendar.CommandsBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.dti_AdvanceTime.MonthCalendar.CommandsBackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.dti_AdvanceTime.MonthCalendar.CommandsBackgroundStyle.BorderTopColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarDockedBorder;
            this.dti_AdvanceTime.MonthCalendar.CommandsBackgroundStyle.BorderTopWidth = 1;
            this.dti_AdvanceTime.MonthCalendar.CommandsBackgroundStyle.Class = "";
            this.dti_AdvanceTime.MonthCalendar.CommandsBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_AdvanceTime.MonthCalendar.DisplayMonth = new System.DateTime(2009, 11, 1, 0, 0, 0, 0);
            this.dti_AdvanceTime.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.dti_AdvanceTime.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_AdvanceTime.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.dti_AdvanceTime.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.dti_AdvanceTime.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.dti_AdvanceTime.MonthCalendar.NavigationBackgroundStyle.Class = "";
            this.dti_AdvanceTime.MonthCalendar.NavigationBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dti_AdvanceTime.MonthCalendar.TodayButtonVisible = true;
            this.dti_AdvanceTime.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.dti_AdvanceTime.Name = "dti_AdvanceTime";
            this.dti_AdvanceTime.ShowUpDown = true;
            this.dti_AdvanceTime.Size = new System.Drawing.Size(131, 29);
            this.dti_AdvanceTime.TabIndex = 17;
            this.dti_AdvanceTime.TextChanged += new System.EventHandler(this.dti_AdvanceTime_TextChanged);
            // 
            // labX_AdvanceTime
            // 
            this.labX_AdvanceTime.AutoSize = true;
            this.labX_AdvanceTime.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.labX_AdvanceTime.Location = new System.Drawing.Point(2, 94);
            this.labX_AdvanceTime.Name = "labX_AdvanceTime";
            this.labX_AdvanceTime.Size = new System.Drawing.Size(121, 21);
            this.labX_AdvanceTime.Style = Sunny.UI.UIStyle.Custom;
            this.labX_AdvanceTime.TabIndex = 16;
            this.labX_AdvanceTime.Text = "Advance Time:";
            this.labX_AdvanceTime.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // chkX_AdvanceTime
            // 
            // 
            // 
            // 
            this.chkX_AdvanceTime.BackgroundStyle.Class = "";
            this.chkX_AdvanceTime.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.chkX_AdvanceTime.Location = new System.Drawing.Point(219, 92);
            this.chkX_AdvanceTime.Name = "chkX_AdvanceTime";
            this.chkX_AdvanceTime.Size = new System.Drawing.Size(19, 20);
            this.chkX_AdvanceTime.TabIndex = 15;
            this.chkX_AdvanceTime.CheckedChanged += new System.EventHandler(this.chkX_AdvanceTime_CheckedChanged);
            // 
            // MatchStartTimeSettingForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(262, 206);
            this.Controls.Add(this.dti_AdvanceTime);
            this.Controls.Add(this.labX_AdvanceTime);
            this.Controls.Add(this.chkX_AdvanceTime);
            this.Controls.Add(this.dti_SpendTime);
            this.Controls.Add(this.labX_SpendTime);
            this.Controls.Add(this.dti_DelayTime);
            this.Controls.Add(this.labX_DelayTime);
            this.Controls.Add(this.chkX_DelayTime);
            this.Controls.Add(this.dti_SpanTime);
            this.Controls.Add(this.labX_SpanTime);
            this.Controls.Add(this.dti_StartTime);
            this.Controls.Add(this.labX_StartTime);
            this.Controls.Add(this.btnX_Cancel);
            this.Controls.Add(this.btnX_OK);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "MatchStartTimeSettingForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "MatchTimeSetting";
            ((System.ComponentModel.ISupportInitialize)(this.dti_StartTime)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dti_SpanTime)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dti_DelayTime)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dti_SpendTime)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dti_AdvanceTime)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnX_Cancel;
        private DevComponents.DotNetBar.ButtonX btnX_OK;
        private UILabel labX_StartTime;
        private UILabel labX_SpanTime;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dti_StartTime;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dti_SpanTime;
        private DevComponents.DotNetBar.Controls.CheckBoxX chkX_DelayTime;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dti_DelayTime;
        private UILabel labX_DelayTime;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dti_SpendTime;
        private UILabel labX_SpendTime;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dti_AdvanceTime;
        private UILabel labX_AdvanceTime;
        private DevComponents.DotNetBar.Controls.CheckBoxX chkX_AdvanceTime;
    }
}