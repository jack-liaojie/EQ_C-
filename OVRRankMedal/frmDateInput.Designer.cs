using Sunny.UI;

namespace AutoSports.OVRRankMedal
{
    partial class frmDateInput
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
            this.lbDate = new Sunny.UI.UILabel();
            this.btnCancle = new Sunny.UI.UIButton();
            this.btnOk = new Sunny.UI.UIButton();
            this.dtInputDate = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            ((System.ComponentModel.ISupportInitialize)(this.dtInputDate)).BeginInit();
            this.SuspendLayout();
            // 
            // lbDate
            // 
            this.lbDate.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbDate.Location = new System.Drawing.Point(18, 48);
            this.lbDate.Name = "lbDate";
            this.lbDate.Size = new System.Drawing.Size(114, 20);
            this.lbDate.TabIndex = 64;
            this.lbDate.Text = "Input Date:";
            this.lbDate.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // btnCancle
            // 
            this.btnCancle.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancle.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnCancle.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnCancle.Location = new System.Drawing.Point(175, 87);
            this.btnCancle.Name = "btnCancle";
            this.btnCancle.Size = new System.Drawing.Size(82, 29);
            this.btnCancle.TabIndex = 63;
            this.btnCancle.Text = "Cancle";
            this.btnCancle.Click += new System.EventHandler(this.btnCancle_Click);
            // 
            // btnOk
            // 
            this.btnOk.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOk.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnOk.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnOk.Location = new System.Drawing.Point(85, 87);
            this.btnOk.Name = "btnOk";
            this.btnOk.Size = new System.Drawing.Size(82, 29);
            this.btnOk.TabIndex = 62;
            this.btnOk.Text = "OK";
            this.btnOk.Click += new System.EventHandler(this.btnOk_Click);
            // 
            // dtInputDate
            // 
            // 
            // 
            // 
            this.dtInputDate.BackgroundStyle.Class = "DateTimeInputBackground";
            this.dtInputDate.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtInputDate.ButtonDropDown.Shortcut = DevComponents.DotNetBar.eShortcut.AltDown;
            this.dtInputDate.ButtonDropDown.Visible = true;
            this.dtInputDate.CustomFormat = "yyyy-MM-dd HH:mm";
            this.dtInputDate.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.dtInputDate.Location = new System.Drawing.Point(140, 45);
            // 
            // 
            // 
            this.dtInputDate.MonthCalendar.AnnuallyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dtInputDate.MonthCalendar.BackgroundStyle.BackColor = System.Drawing.SystemColors.Window;
            this.dtInputDate.MonthCalendar.BackgroundStyle.Class = "";
            this.dtInputDate.MonthCalendar.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtInputDate.MonthCalendar.ClearButtonVisible = true;
            // 
            // 
            // 
            this.dtInputDate.MonthCalendar.CommandsBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground2;
            this.dtInputDate.MonthCalendar.CommandsBackgroundStyle.BackColorGradientAngle = 90;
            this.dtInputDate.MonthCalendar.CommandsBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.dtInputDate.MonthCalendar.CommandsBackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.dtInputDate.MonthCalendar.CommandsBackgroundStyle.BorderTopColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarDockedBorder;
            this.dtInputDate.MonthCalendar.CommandsBackgroundStyle.BorderTopWidth = 1;
            this.dtInputDate.MonthCalendar.CommandsBackgroundStyle.Class = "";
            this.dtInputDate.MonthCalendar.CommandsBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtInputDate.MonthCalendar.DisplayMonth = new System.DateTime(2009, 8, 1, 0, 0, 0, 0);
            this.dtInputDate.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.dtInputDate.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dtInputDate.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.dtInputDate.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.dtInputDate.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.dtInputDate.MonthCalendar.NavigationBackgroundStyle.Class = "";
            this.dtInputDate.MonthCalendar.NavigationBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtInputDate.MonthCalendar.TodayButtonVisible = true;
            this.dtInputDate.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.dtInputDate.Name = "dtInputDate";
            this.dtInputDate.Size = new System.Drawing.Size(170, 29);
            this.dtInputDate.TabIndex = 65;
            // 
            // frmDateInput
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(320, 140);
            this.Controls.Add(this.dtInputDate);
            this.Controls.Add(this.lbDate);
            this.Controls.Add(this.btnCancle);
            this.Controls.Add(this.btnOk);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmDateInput";
            this.Text = "Date Input";
            ((System.ComponentModel.ISupportInitialize)(this.dtInputDate)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private UILabel lbDate;
        private UIButton btnCancle;
        private UIButton btnOk;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dtInputDate;
    }
}