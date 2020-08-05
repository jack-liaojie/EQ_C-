using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    partial class MatchEndTimeSettingForm
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
            this.labX_EndTime = new UILabel();
            this.dti_EndTime = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.labX_SpanTime = new UILabel();
            this.dti_SpanTime = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            ((System.ComponentModel.ISupportInitialize)(this.dti_EndTime)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dti_SpanTime)).BeginInit();
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
            // labX_EndTime
            // 
            this.labX_EndTime.AutoSize = true;
            this.labX_EndTime.Location = new System.Drawing.Point(2, 12);
            this.labX_EndTime.Name = "labX_EndTime";
            this.labX_EndTime.Size = new System.Drawing.Size(62, 16);
            this.labX_EndTime.TabIndex = 6;
            this.labX_EndTime.Text = "End Time:";
            // 
            // dti_EndTime
            // 
            // 
            // 
            // 
            this.dti_EndTime.BackgroundStyle.Class = "DateTimeInputBackground";
            this.dti_EndTime.ButtonDropDown.Enabled = false;
            this.dti_EndTime.ButtonDropDown.Shortcut = DevComponents.DotNetBar.eShortcut.AltDown;
            this.dti_EndTime.CustomFormat = "HH:mm";
            this.dti_EndTime.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.dti_EndTime.Location = new System.Drawing.Point(88, 10);
            // 
            // 
            // 
            this.dti_EndTime.MonthCalendar.AnnuallyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_EndTime.MonthCalendar.BackgroundStyle.BackColor = System.Drawing.SystemColors.Window;
            this.dti_EndTime.MonthCalendar.ClearButtonVisible = true;
            // 
            // 
            // 
            this.dti_EndTime.MonthCalendar.CommandsBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground2;
            this.dti_EndTime.MonthCalendar.CommandsBackgroundStyle.BackColorGradientAngle = 90;
            this.dti_EndTime.MonthCalendar.CommandsBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.dti_EndTime.MonthCalendar.CommandsBackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.dti_EndTime.MonthCalendar.CommandsBackgroundStyle.BorderTopColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarDockedBorder;
            this.dti_EndTime.MonthCalendar.CommandsBackgroundStyle.BorderTopWidth = 1;
            this.dti_EndTime.MonthCalendar.DisplayMonth = new System.DateTime(2009, 11, 1, 0, 0, 0, 0);
            this.dti_EndTime.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.dti_EndTime.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_EndTime.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.dti_EndTime.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.dti_EndTime.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.dti_EndTime.MonthCalendar.TodayButtonVisible = true;
            this.dti_EndTime.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.dti_EndTime.Name = "dti_EndTime";
            this.dti_EndTime.ShowUpDown = true;
            this.dti_EndTime.Size = new System.Drawing.Size(131, 21);
            this.dti_EndTime.TabIndex = 7;
            this.dti_EndTime.TextChanged += new System.EventHandler(this.dti_EndTime_TextChanged);
            // 
            // labX_SpanTime
            // 
            this.labX_SpanTime.AutoSize = true;
            this.labX_SpanTime.Location = new System.Drawing.Point(2, 66);
            this.labX_SpanTime.Name = "labX_SpanTime";
            this.labX_SpanTime.Size = new System.Drawing.Size(68, 16);
            this.labX_SpanTime.TabIndex = 8;
            this.labX_SpanTime.Text = "Span Time:";
            // 
            // dti_SpanTime
            // 
            // 
            // 
            // 
            this.dti_SpanTime.BackgroundStyle.Class = "DateTimeInputBackground";
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
            this.dti_SpanTime.MonthCalendar.DisplayMonth = new System.DateTime(2009, 11, 1, 0, 0, 0, 0);
            this.dti_SpanTime.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.dti_SpanTime.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dti_SpanTime.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.dti_SpanTime.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.dti_SpanTime.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.dti_SpanTime.MonthCalendar.TodayButtonVisible = true;
            this.dti_SpanTime.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.dti_SpanTime.Name = "dti_SpanTime";
            this.dti_SpanTime.ShowUpDown = true;
            this.dti_SpanTime.Size = new System.Drawing.Size(131, 21);
            this.dti_SpanTime.TabIndex = 9;
            this.dti_SpanTime.TextChanged += new System.EventHandler(this.dti_SpanTime_TextChanged);
            // 
            // MatchEndTimeSettingForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(242, 189);
            this.Controls.Add(this.dti_SpanTime);
            this.Controls.Add(this.labX_SpanTime);
            this.Controls.Add(this.dti_EndTime);
            this.Controls.Add(this.labX_EndTime);
            this.Controls.Add(this.btnX_Cancel);
            this.Controls.Add(this.btnX_OK);
            
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "MatchEndTimeSettingForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "MatchEndTimeSetting";
            ((System.ComponentModel.ISupportInitialize)(this.dti_EndTime)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dti_SpanTime)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnX_Cancel;
        private DevComponents.DotNetBar.ButtonX btnX_OK;
        private UILabel labX_EndTime;
        private UILabel labX_SpanTime;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dti_EndTime;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dti_SpanTime;
    }
}