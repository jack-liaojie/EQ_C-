using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    partial class EditDateForm
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
            this.dgv_Date = new UIDataGridView();
            this.dateTimeInput1 = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.btnX_Add = new DevComponents.DotNetBar.ButtonX();
            this.btnX_Del = new DevComponents.DotNetBar.ButtonX();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Date)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dateTimeInput1)).BeginInit();
            this.SuspendLayout();
            // 
            // dgv_Date
            // 
            this.dgv_Date.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_Date.Location = new System.Drawing.Point(1, 5);
            this.dgv_Date.Name = "dgv_Date";
            this.dgv_Date.RowTemplate.Height = 23;
            this.dgv_Date.Size = new System.Drawing.Size(470, 290);
            this.dgv_Date.TabIndex = 5;
            this.dgv_Date.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgv_Date_CellBeginEdit);
            this.dgv_Date.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_Date_CellEndEdit);
            // 
            // dateTimeInput1
            // 
            // 
            // 
            // 
            this.dateTimeInput1.BackgroundStyle.Class = "DateTimeInputBackground";
            this.dateTimeInput1.ButtonDropDown.Shortcut = DevComponents.DotNetBar.eShortcut.AltDown;
            this.dateTimeInput1.ButtonDropDown.Visible = true;
            this.dateTimeInput1.Location = new System.Drawing.Point(1, 300);
            // 
            // 
            // 
            this.dateTimeInput1.MonthCalendar.AnnuallyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dateTimeInput1.MonthCalendar.BackgroundStyle.BackColor = System.Drawing.SystemColors.Window;
            this.dateTimeInput1.MonthCalendar.ClearButtonVisible = true;
            // 
            // 
            // 
            this.dateTimeInput1.MonthCalendar.CommandsBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground2;
            this.dateTimeInput1.MonthCalendar.CommandsBackgroundStyle.BackColorGradientAngle = 90;
            this.dateTimeInput1.MonthCalendar.CommandsBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.dateTimeInput1.MonthCalendar.CommandsBackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.dateTimeInput1.MonthCalendar.CommandsBackgroundStyle.BorderTopColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarDockedBorder;
            this.dateTimeInput1.MonthCalendar.CommandsBackgroundStyle.BorderTopWidth = 1;
            this.dateTimeInput1.MonthCalendar.DisplayMonth = new System.DateTime(2009, 11, 1, 0, 0, 0, 0);
            this.dateTimeInput1.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.dateTimeInput1.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dateTimeInput1.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.dateTimeInput1.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.dateTimeInput1.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.dateTimeInput1.MonthCalendar.TodayButtonVisible = true;
            this.dateTimeInput1.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.dateTimeInput1.Name = "dateTimeInput1";
            this.dateTimeInput1.Size = new System.Drawing.Size(130, 21);
            this.dateTimeInput1.TabIndex = 6;
            // 
            // btnX_Add
            // 
            this.btnX_Add.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Add.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_Add.Image = global::Newauto.OVRMatchSchedule.Properties.Resources.add_16;
            this.btnX_Add.Location = new System.Drawing.Point(160, 300);
            this.btnX_Add.Name = "btnX_Add";
            this.btnX_Add.Size = new System.Drawing.Size(20, 20);
            this.btnX_Add.TabIndex = 1;
            this.btnX_Add.Click += new System.EventHandler(this.btnX_Add_Click);
            // 
            // btnX_Del
            // 
            this.btnX_Del.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Del.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_Del.Image = global::Newauto.OVRMatchSchedule.Properties.Resources.remove_16;
            this.btnX_Del.Location = new System.Drawing.Point(200, 300);
            this.btnX_Del.Name = "btnX_Del";
            this.btnX_Del.Size = new System.Drawing.Size(20, 20);
            this.btnX_Del.TabIndex = 2;
            this.btnX_Del.Click += new System.EventHandler(this.btnX_Del_Click);
            // 
            // EditDateForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(474, 328);
            this.Controls.Add(this.dateTimeInput1);
            this.Controls.Add(this.dgv_Date);
            this.Controls.Add(this.btnX_Add);
            this.Controls.Add(this.btnX_Del);
            
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "EditDateForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Load += new System.EventHandler(this.EditDateForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Date)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dateTimeInput1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnX_Add;
        private DevComponents.DotNetBar.ButtonX btnX_Del;
        private UIDataGridView dgv_Date;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dateTimeInput1;
    }
}