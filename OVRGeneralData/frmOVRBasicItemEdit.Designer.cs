using Sunny.UI;

namespace AutoSports.OVRGeneralData
{
    partial class OVRBasicItemEditForm
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
            this.lbLanguage = new UILabel();
            this.cmbLanguage = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.txLongName = new UITextBox();
            this.lbLongName = new UILabel();
            this.txShortName = new UITextBox();
            this.lbShortName = new UILabel();
            this.txRegCode = new UITextBox();
            this.lbRegCode = new UILabel();
            this.dtStartDate = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.lbStartDate = new UILabel();
            this.dtEndDate = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.lbEndDate = new UILabel();
            this.cmbSex = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbSex = new UILabel();
            this.cmbRegType = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbRegType = new UILabel();
            this.txOrder = new UITextBox();
            this.lbOrder = new UILabel();
            this.btnCancel = new DevComponents.DotNetBar.ButtonX();
            this.btnOK = new DevComponents.DotNetBar.ButtonX();
            this.cmbCompetitionType = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbCompetitionType = new UILabel();
            this.lbGroup = new UILabel();
            this.cmbGroup = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbComment = new UILabel();
            this.txComment = new UITextBox();
            ((System.ComponentModel.ISupportInitialize)(this.dtStartDate)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dtEndDate)).BeginInit();
            this.SuspendLayout();
            // 
            // lbLanguage
            // 
            // 
            // 
            // 
            this.lbLanguage.Location = new System.Drawing.Point(2, 12);
            this.lbLanguage.Name = "lbLanguage";
            this.lbLanguage.Size = new System.Drawing.Size(75, 20);
            this.lbLanguage.TabIndex = 2;
            this.lbLanguage.Text = "语言类型：";
            // 
            // cmbLanguage
            // 
            this.cmbLanguage.DisplayMember = "Text";
            this.cmbLanguage.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbLanguage.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbLanguage.FormattingEnabled = true;
            this.cmbLanguage.ItemHeight = 15;
            this.cmbLanguage.Location = new System.Drawing.Point(83, 11);
            this.cmbLanguage.Name = "cmbLanguage";
            this.cmbLanguage.Size = new System.Drawing.Size(186, 21);
            this.cmbLanguage.TabIndex = 3;
            // 
            // txLongName
            // 
            // 
            // 
            // 
            this.txLongName.Location = new System.Drawing.Point(83, 38);
            this.txLongName.MaxLength = 100;
            this.txLongName.Name = "txLongName";
            this.txLongName.Size = new System.Drawing.Size(186, 21);
            this.txLongName.TabIndex = 5;
            // 
            // lbLongName
            // 
            // 
            // 
            // 
            this.lbLongName.Location = new System.Drawing.Point(2, 39);
            this.lbLongName.Name = "lbLongName";
            this.lbLongName.Size = new System.Drawing.Size(75, 20);
            this.lbLongName.TabIndex = 4;
            this.lbLongName.Text = "长名：";
            // 
            // txShortName
            // 
            // 
            // 
            // 
            this.txShortName.Location = new System.Drawing.Point(83, 65);
            this.txShortName.MaxLength = 50;
            this.txShortName.Name = "txShortName";
            this.txShortName.Size = new System.Drawing.Size(186, 21);
            this.txShortName.TabIndex = 7;
            // 
            // lbShortName
            // 
            // 
            // 
            // 
            this.lbShortName.Location = new System.Drawing.Point(2, 66);
            this.lbShortName.Name = "lbShortName";
            this.lbShortName.Size = new System.Drawing.Size(75, 20);
            this.lbShortName.TabIndex = 6;
            this.lbShortName.Text = "短名：";
            // 
            // txRegCode
            // 
            // 
            // 
            // 
            this.txRegCode.Location = new System.Drawing.Point(83, 92);
            this.txRegCode.Name = "txRegCode";
            this.txRegCode.Size = new System.Drawing.Size(186, 21);
            this.txRegCode.TabIndex = 11;
            // 
            // lbRegCode
            // 
            // 
            // 
            // 
            this.lbRegCode.Location = new System.Drawing.Point(2, 93);
            this.lbRegCode.Name = "lbRegCode";
            this.lbRegCode.Size = new System.Drawing.Size(75, 20);
            this.lbRegCode.TabIndex = 10;
            this.lbRegCode.Text = "注册码：";
            // 
            // dtStartDate
            // 
            // 
            // 
            // 
            this.dtStartDate.BackgroundStyle.Class = "DateTimeInputBackground";
            this.dtStartDate.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtStartDate.ButtonDropDown.Shortcut = DevComponents.DotNetBar.eShortcut.AltDown;
            this.dtStartDate.ButtonDropDown.Visible = true;
            this.dtStartDate.CustomFormat = "yyyy-MM-dd HH:mm";
            this.dtStartDate.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.dtStartDate.Location = new System.Drawing.Point(83, 119);
            // 
            // 
            // 
            this.dtStartDate.MonthCalendar.AnnuallyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dtStartDate.MonthCalendar.BackgroundStyle.BackColor = System.Drawing.SystemColors.Window;
            this.dtStartDate.MonthCalendar.BackgroundStyle.Class = "";
            this.dtStartDate.MonthCalendar.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtStartDate.MonthCalendar.ClearButtonVisible = true;
            // 
            // 
            // 
            this.dtStartDate.MonthCalendar.CommandsBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground2;
            this.dtStartDate.MonthCalendar.CommandsBackgroundStyle.BackColorGradientAngle = 90;
            this.dtStartDate.MonthCalendar.CommandsBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.dtStartDate.MonthCalendar.CommandsBackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.dtStartDate.MonthCalendar.CommandsBackgroundStyle.BorderTopColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarDockedBorder;
            this.dtStartDate.MonthCalendar.CommandsBackgroundStyle.BorderTopWidth = 1;
            this.dtStartDate.MonthCalendar.CommandsBackgroundStyle.Class = "";
            this.dtStartDate.MonthCalendar.CommandsBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtStartDate.MonthCalendar.DisplayMonth = new System.DateTime(2009, 8, 1, 0, 0, 0, 0);
            this.dtStartDate.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.dtStartDate.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dtStartDate.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.dtStartDate.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.dtStartDate.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.dtStartDate.MonthCalendar.NavigationBackgroundStyle.Class = "";
            this.dtStartDate.MonthCalendar.NavigationBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtStartDate.MonthCalendar.TodayButtonVisible = true;
            this.dtStartDate.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.dtStartDate.Name = "dtStartDate";
            this.dtStartDate.Size = new System.Drawing.Size(186, 21);
            this.dtStartDate.TabIndex = 13;
            // 
            // lbStartDate
            // 
            // 
            // 
            // 
            this.lbStartDate.Location = new System.Drawing.Point(2, 120);
            this.lbStartDate.Name = "lbStartDate";
            this.lbStartDate.Size = new System.Drawing.Size(75, 20);
            this.lbStartDate.TabIndex = 12;
            this.lbStartDate.Text = "开始日期：";
            // 
            // dtEndDate
            // 
            // 
            // 
            // 
            this.dtEndDate.BackgroundStyle.Class = "DateTimeInputBackground";
            this.dtEndDate.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtEndDate.ButtonDropDown.Shortcut = DevComponents.DotNetBar.eShortcut.AltDown;
            this.dtEndDate.ButtonDropDown.Visible = true;
            this.dtEndDate.CustomFormat = "yyyy-MM-dd HH:mm";
            this.dtEndDate.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.dtEndDate.Location = new System.Drawing.Point(83, 146);
            // 
            // 
            // 
            this.dtEndDate.MonthCalendar.AnnuallyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dtEndDate.MonthCalendar.BackgroundStyle.BackColor = System.Drawing.SystemColors.Window;
            this.dtEndDate.MonthCalendar.BackgroundStyle.Class = "";
            this.dtEndDate.MonthCalendar.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtEndDate.MonthCalendar.ClearButtonVisible = true;
            // 
            // 
            // 
            this.dtEndDate.MonthCalendar.CommandsBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground2;
            this.dtEndDate.MonthCalendar.CommandsBackgroundStyle.BackColorGradientAngle = 90;
            this.dtEndDate.MonthCalendar.CommandsBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.dtEndDate.MonthCalendar.CommandsBackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.dtEndDate.MonthCalendar.CommandsBackgroundStyle.BorderTopColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarDockedBorder;
            this.dtEndDate.MonthCalendar.CommandsBackgroundStyle.BorderTopWidth = 1;
            this.dtEndDate.MonthCalendar.CommandsBackgroundStyle.Class = "";
            this.dtEndDate.MonthCalendar.CommandsBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtEndDate.MonthCalendar.DisplayMonth = new System.DateTime(2009, 8, 1, 0, 0, 0, 0);
            this.dtEndDate.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.dtEndDate.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dtEndDate.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.dtEndDate.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.dtEndDate.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.dtEndDate.MonthCalendar.NavigationBackgroundStyle.Class = "";
            this.dtEndDate.MonthCalendar.NavigationBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtEndDate.MonthCalendar.TodayButtonVisible = true;
            this.dtEndDate.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.dtEndDate.Name = "dtEndDate";
            this.dtEndDate.Size = new System.Drawing.Size(186, 21);
            this.dtEndDate.TabIndex = 15;
            // 
            // lbEndDate
            // 
            // 
            // 
            // 
            this.lbEndDate.Location = new System.Drawing.Point(2, 147);
            this.lbEndDate.Name = "lbEndDate";
            this.lbEndDate.Size = new System.Drawing.Size(75, 20);
            this.lbEndDate.TabIndex = 14;
            this.lbEndDate.Text = "结束日期：";
            // 
            // cmbSex
            // 
            this.cmbSex.DisplayMember = "Text";
            this.cmbSex.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbSex.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbSex.FormattingEnabled = true;
            this.cmbSex.ItemHeight = 15;
            this.cmbSex.Location = new System.Drawing.Point(83, 173);
            this.cmbSex.Name = "cmbSex";
            this.cmbSex.Size = new System.Drawing.Size(186, 21);
            this.cmbSex.TabIndex = 17;
            // 
            // lbSex
            // 
            // 
            // 
            // 
            this.lbSex.Location = new System.Drawing.Point(2, 174);
            this.lbSex.Name = "lbSex";
            this.lbSex.Size = new System.Drawing.Size(75, 20);
            this.lbSex.TabIndex = 16;
            this.lbSex.Text = "性别：";
            // 
            // cmbRegType
            // 
            this.cmbRegType.DisplayMember = "Text";
            this.cmbRegType.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbRegType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbRegType.FormattingEnabled = true;
            this.cmbRegType.ItemHeight = 15;
            this.cmbRegType.Location = new System.Drawing.Point(83, 200);
            this.cmbRegType.Name = "cmbRegType";
            this.cmbRegType.Size = new System.Drawing.Size(186, 21);
            this.cmbRegType.TabIndex = 19;
            // 
            // lbRegType
            // 
            // 
            // 
            // 
            this.lbRegType.Location = new System.Drawing.Point(2, 201);
            this.lbRegType.Name = "lbRegType";
            this.lbRegType.Size = new System.Drawing.Size(75, 20);
            this.lbRegType.TabIndex = 18;
            this.lbRegType.Text = "注册类型：";
            // 
            // txOrder
            // 
            // 
            // 
            // 
            this.txOrder.Location = new System.Drawing.Point(83, 254);
            this.txOrder.Name = "txOrder";
            this.txOrder.Size = new System.Drawing.Size(186, 21);
            this.txOrder.TabIndex = 21;
            this.txOrder.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.txOrder_KeyPress);
            // 
            // lbOrder
            // 
            // 
            // 
            // 
            this.lbOrder.Location = new System.Drawing.Point(2, 255);
            this.lbOrder.Name = "lbOrder";
            this.lbOrder.Size = new System.Drawing.Size(75, 20);
            this.lbOrder.TabIndex = 20;
            this.lbOrder.Text = "序号：";
            // 
            // btnCancel
            // 
            this.btnCancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnCancel.Image = global::AutoSports.OVRGeneralData.Properties.Resources.cancel_24;
            this.btnCancel.Location = new System.Drawing.Point(164, 345);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(50, 30);
            this.btnCancel.TabIndex = 23;
            this.btnCancel.Click += new System.EventHandler(this.OnCancel);
            // 
            // btnOK
            // 
            this.btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOK.Image = global::AutoSports.OVRGeneralData.Properties.Resources.ok_24;
            this.btnOK.Location = new System.Drawing.Point(84, 345);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(50, 30);
            this.btnOK.TabIndex = 22;
            this.btnOK.Click += new System.EventHandler(this.OnOk);
            // 
            // cmbCompetitionType
            // 
            this.cmbCompetitionType.DisplayMember = "Text";
            this.cmbCompetitionType.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbCompetitionType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbCompetitionType.FormattingEnabled = true;
            this.cmbCompetitionType.ItemHeight = 15;
            this.cmbCompetitionType.Location = new System.Drawing.Point(83, 227);
            this.cmbCompetitionType.Name = "cmbCompetitionType";
            this.cmbCompetitionType.Size = new System.Drawing.Size(186, 21);
            this.cmbCompetitionType.TabIndex = 25;
            // 
            // lbCompetitionType
            // 
            // 
            // 
            // 
            this.lbCompetitionType.Location = new System.Drawing.Point(2, 228);
            this.lbCompetitionType.Name = "lbCompetitionType";
            this.lbCompetitionType.Size = new System.Drawing.Size(75, 20);
            this.lbCompetitionType.TabIndex = 24;
            this.lbCompetitionType.Text = "比赛类型：";
            // 
            // lbGroup
            // 
            // 
            // 
            // 
            this.lbGroup.Location = new System.Drawing.Point(2, 312);
            this.lbGroup.Name = "lbGroup";
            this.lbGroup.Size = new System.Drawing.Size(75, 20);
            this.lbGroup.TabIndex = 24;
            this.lbGroup.Text = "分组类型：";
            // 
            // cmbGroup
            // 
            this.cmbGroup.DisplayMember = "Text";
            this.cmbGroup.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbGroup.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbGroup.FormattingEnabled = true;
            this.cmbGroup.ItemHeight = 15;
            this.cmbGroup.Location = new System.Drawing.Point(83, 311);
            this.cmbGroup.Name = "cmbGroup";
            this.cmbGroup.Size = new System.Drawing.Size(186, 21);
            this.cmbGroup.TabIndex = 25;
            this.cmbGroup.SelectionChangeCommitted += new System.EventHandler(this.cmbGroup_SelectionChangeCommitted);
            // 
            // lbComment
            // 
            // 
            // 
            // 
            this.lbComment.Location = new System.Drawing.Point(2, 282);
            this.lbComment.Name = "lbComment";
            this.lbComment.Size = new System.Drawing.Size(75, 20);
            this.lbComment.TabIndex = 20;
            this.lbComment.Text = "备注：";
            // 
            // txComment
            // 
            // 
            // 
            // 
            this.txComment.Enabled = false;
            this.txComment.Location = new System.Drawing.Point(83, 281);
            this.txComment.Name = "txComment";
            this.txComment.Size = new System.Drawing.Size(186, 21);
            this.txComment.TabIndex = 21;
            // 
            // OVRBasicItemEditForm
            // 
            this.ClientSize = new System.Drawing.Size(281, 380);
            this.Controls.Add(this.cmbGroup);
            this.Controls.Add(this.lbGroup);
            this.Controls.Add(this.cmbCompetitionType);
            this.Controls.Add(this.lbCompetitionType);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.txComment);
            this.Controls.Add(this.lbComment);
            this.Controls.Add(this.txOrder);
            this.Controls.Add(this.lbOrder);
            this.Controls.Add(this.cmbRegType);
            this.Controls.Add(this.lbRegType);
            this.Controls.Add(this.cmbSex);
            this.Controls.Add(this.lbSex);
            this.Controls.Add(this.dtEndDate);
            this.Controls.Add(this.lbEndDate);
            this.Controls.Add(this.dtStartDate);
            this.Controls.Add(this.lbStartDate);
            this.Controls.Add(this.txRegCode);
            this.Controls.Add(this.lbRegCode);
            this.Controls.Add(this.txShortName);
            this.Controls.Add(this.lbShortName);
            this.Controls.Add(this.txLongName);
            this.Controls.Add(this.lbLongName);
            this.Controls.Add(this.lbLanguage);
            this.Controls.Add(this.cmbLanguage);
            this.DoubleBuffered = true;
            
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRBasicItemEditForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "详细信息";
            this.Load += new System.EventHandler(this.OnLoad);
            ((System.ComponentModel.ISupportInitialize)(this.dtStartDate)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dtEndDate)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private UILabel lbLanguage;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbLanguage;
        private UITextBox txLongName;
        private UILabel lbLongName;
        private UITextBox txShortName;
        private UILabel lbShortName;
        private UITextBox txRegCode;
        private UILabel lbRegCode;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dtStartDate;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dtEndDate;
        private UILabel lbStartDate;
        private UILabel lbEndDate;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbSex;
        private UILabel lbSex;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbRegType;
        private UILabel lbRegType;
        private UITextBox txOrder;
        private UILabel lbOrder;
        private DevComponents.DotNetBar.ButtonX btnCancel;
        private DevComponents.DotNetBar.ButtonX btnOK;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbCompetitionType;
        private UILabel lbCompetitionType;
        private UILabel lbGroup;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbGroup;
        private UILabel lbComment;
        private UITextBox txComment;

    }
}