using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    partial class OVREQEditTimeForm
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
            this.btnX_OK = new Sunny.UI.UIButton();
            this.btnX_Cancel = new Sunny.UI.UIButton();
            this.dti_SpanTime = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.labX_SpanTime = new Sunny.UI.UILabel();
            this.dti_StartTime = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.labX_StartTime = new Sunny.UI.UILabel();
            ((System.ComponentModel.ISupportInitialize)(this.dti_SpanTime)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dti_StartTime)).BeginInit();
            this.SuspendLayout();
            // 
            // btnX_OK
            // 
            this.btnX_OK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_OK.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnX_OK.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnX_OK.Location = new System.Drawing.Point(66, 108);
            this.btnX_OK.Name = "btnX_OK";
            this.btnX_OK.Size = new System.Drawing.Size(55, 23);
            this.btnX_OK.TabIndex = 1;
            this.btnX_OK.Text = "OK";
            this.btnX_OK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // btnX_Cancel
            // 
            this.btnX_Cancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Cancel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnX_Cancel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnX_Cancel.Location = new System.Drawing.Point(160, 108);
            this.btnX_Cancel.Name = "btnX_Cancel";
            this.btnX_Cancel.Size = new System.Drawing.Size(55, 23);
            this.btnX_Cancel.TabIndex = 2;
            this.btnX_Cancel.Text = "Cancel";
            this.btnX_Cancel.Click += new System.EventHandler(this.btnCancel_Click);
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
            this.dti_SpanTime.CustomFormat = "HH:mm:ss";
            this.dti_SpanTime.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.dti_SpanTime.Location = new System.Drawing.Point(104, 36);
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
            this.dti_SpanTime.TabIndex = 13;
            this.dti_SpanTime.TextChanged += new System.EventHandler(this.dti_SpanTime_TextChanged);
            // 
            // labX_SpanTime
            // 
            this.labX_SpanTime.AutoSize = true;
            this.labX_SpanTime.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.labX_SpanTime.Location = new System.Drawing.Point(6, 73);
            this.labX_SpanTime.Name = "labX_SpanTime";
            this.labX_SpanTime.Size = new System.Drawing.Size(94, 21);
            this.labX_SpanTime.TabIndex = 12;
            this.labX_SpanTime.Text = "Span Time:";
            this.labX_SpanTime.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
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
            this.dti_StartTime.CustomFormat = "HH:mm:ss";
            this.dti_StartTime.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.dti_StartTime.Location = new System.Drawing.Point(104, 70);
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
            this.dti_StartTime.TabIndex = 11;
            this.dti_StartTime.TextChanged += new System.EventHandler(this.dti_StartTime_TextChanged);
            // 
            // labX_StartTime
            // 
            this.labX_StartTime.AutoSize = true;
            this.labX_StartTime.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.labX_StartTime.Location = new System.Drawing.Point(8, 42);
            this.labX_StartTime.Name = "labX_StartTime";
            this.labX_StartTime.Size = new System.Drawing.Size(92, 21);
            this.labX_StartTime.TabIndex = 10;
            this.labX_StartTime.Text = "Start Time:";
            this.labX_StartTime.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // OVREQEditTimeForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(255, 141);
            this.Controls.Add(this.dti_SpanTime);
            this.Controls.Add(this.labX_SpanTime);
            this.Controls.Add(this.dti_StartTime);
            this.Controls.Add(this.labX_StartTime);
            this.Controls.Add(this.btnX_Cancel);
            this.Controls.Add(this.btnX_OK);
            this.Name = "OVREQEditTimeForm";
            this.Load += new System.EventHandler(this.OVREQEditTimeFrom_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dti_SpanTime)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dti_StartTime)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private UIButton btnX_OK;
        private UIButton btnX_Cancel;
        public DevComponents.Editors.DateTimeAdv.DateTimeInput dti_SpanTime;
        public UILabel labX_SpanTime;
        public DevComponents.Editors.DateTimeAdv.DateTimeInput dti_StartTime;
        public UILabel labX_StartTime;
    }
}