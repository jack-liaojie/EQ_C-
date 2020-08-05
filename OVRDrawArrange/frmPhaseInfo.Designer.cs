using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    partial class PhaseInfoForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        #region Windows Form Designer generated code

        private void InitializeComponent()
        {
            this.btnOK = new DevComponents.DotNetBar.ButtonX();
            this.btnCancle = new DevComponents.DotNetBar.ButtonX();
            this.lbPhaseCode = new Sunny.UI.UILabel();
            this.TextCode = new Sunny.UI.UITextBox();
            this.TextOrder = new Sunny.UI.UITextBox();
            this.lbPhaseOrder = new Sunny.UI.UILabel();
            this.TextLongName = new Sunny.UI.UITextBox();
            this.lbPhaseLongName = new Sunny.UI.UILabel();
            this.TextShortName = new Sunny.UI.UITextBox();
            this.lbPhaseShortName = new Sunny.UI.UILabel();
            this.TextComment = new Sunny.UI.UITextBox();
            this.lbPhaseComment = new Sunny.UI.UILabel();
            this.CmbLanguage = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbLanguage = new Sunny.UI.UILabel();
            this.DateStart = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.DateEnd = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.lbStartDate = new Sunny.UI.UILabel();
            this.lbEndDate = new Sunny.UI.UILabel();
            this.textIsPool = new Sunny.UI.UITextBox();
            this.lbPhaseIsPool = new Sunny.UI.UILabel();
            this.textHasPools = new Sunny.UI.UITextBox();
            this.lbPhaseHasPools = new Sunny.UI.UILabel();
            this.lbPhaseStatus = new Sunny.UI.UILabel();
            this.CmbStatus = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            ((System.ComponentModel.ISupportInitialize)(this.DateStart)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.DateEnd)).BeginInit();
            this.SuspendLayout();
            // 
            // btnOK
            // 
            this.btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOK.Image = global::Newauto.OVRDrawArrange.Properties.Resources.ok_24;
            this.btnOK.Location = new System.Drawing.Point(382, 144);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(50, 30);
            this.btnOK.TabIndex = 0;
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // btnCancle
            // 
            this.btnCancle.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancle.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnCancle.Image = global::Newauto.OVRDrawArrange.Properties.Resources.cancel_24;
            this.btnCancle.Location = new System.Drawing.Point(457, 144);
            this.btnCancle.Name = "btnCancle";
            this.btnCancle.Size = new System.Drawing.Size(50, 30);
            this.btnCancle.TabIndex = 1;
            this.btnCancle.Click += new System.EventHandler(this.btnCancle_Click);
            // 
            // lbPhaseCode
            // 
            this.lbPhaseCode.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbPhaseCode.Location = new System.Drawing.Point(6, 35);
            this.lbPhaseCode.Name = "lbPhaseCode";
            this.lbPhaseCode.Size = new System.Drawing.Size(76, 21);
            this.lbPhaseCode.TabIndex = 2;
            this.lbPhaseCode.Text = "PhaseCode:";
            this.lbPhaseCode.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // TextCode
            // 
            this.TextCode.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextCode.FillColor = System.Drawing.Color.White;
            this.TextCode.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextCode.Location = new System.Drawing.Point(88, 35);
            this.TextCode.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextCode.Maximum = 2147483647D;
            this.TextCode.Minimum = -2147483648D;
            this.TextCode.Name = "TextCode";
            this.TextCode.Padding = new System.Windows.Forms.Padding(5);
            this.TextCode.Size = new System.Drawing.Size(160, 29);
            this.TextCode.TabIndex = 3;
            // 
            // TextOrder
            // 
            this.TextOrder.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextOrder.FillColor = System.Drawing.Color.White;
            this.TextOrder.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextOrder.Location = new System.Drawing.Point(88, 86);
            this.TextOrder.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextOrder.Maximum = 2147483647D;
            this.TextOrder.Minimum = -2147483648D;
            this.TextOrder.Name = "TextOrder";
            this.TextOrder.Padding = new System.Windows.Forms.Padding(5);
            this.TextOrder.Size = new System.Drawing.Size(160, 29);
            this.TextOrder.TabIndex = 5;
            // 
            // lbPhaseOrder
            // 
            this.lbPhaseOrder.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbPhaseOrder.Location = new System.Drawing.Point(6, 89);
            this.lbPhaseOrder.Name = "lbPhaseOrder";
            this.lbPhaseOrder.Size = new System.Drawing.Size(76, 21);
            this.lbPhaseOrder.TabIndex = 4;
            this.lbPhaseOrder.Text = "Order:";
            this.lbPhaseOrder.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // TextLongName
            // 
            this.TextLongName.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextLongName.FillColor = System.Drawing.Color.White;
            this.TextLongName.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextLongName.Location = new System.Drawing.Point(0, 35);
            this.TextLongName.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextLongName.Maximum = 2147483647D;
            this.TextLongName.Minimum = -2147483648D;
            this.TextLongName.Name = "TextLongName";
            this.TextLongName.Padding = new System.Windows.Forms.Padding(5);
            this.TextLongName.Size = new System.Drawing.Size(160, 29);
            this.TextLongName.TabIndex = 7;
            // 
            // lbPhaseLongName
            // 
            this.lbPhaseLongName.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbPhaseLongName.Location = new System.Drawing.Point(267, 35);
            this.lbPhaseLongName.Name = "lbPhaseLongName";
            this.lbPhaseLongName.Size = new System.Drawing.Size(76, 21);
            this.lbPhaseLongName.TabIndex = 6;
            this.lbPhaseLongName.Text = "Long Name:";
            this.lbPhaseLongName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // TextShortName
            // 
            this.TextShortName.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextShortName.FillColor = System.Drawing.Color.White;
            this.TextShortName.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextShortName.Location = new System.Drawing.Point(349, 59);
            this.TextShortName.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextShortName.Maximum = 2147483647D;
            this.TextShortName.Minimum = -2147483648D;
            this.TextShortName.Name = "TextShortName";
            this.TextShortName.Padding = new System.Windows.Forms.Padding(5);
            this.TextShortName.Size = new System.Drawing.Size(160, 29);
            this.TextShortName.TabIndex = 9;
            // 
            // lbPhaseShortName
            // 
            this.lbPhaseShortName.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbPhaseShortName.Location = new System.Drawing.Point(267, 59);
            this.lbPhaseShortName.Name = "lbPhaseShortName";
            this.lbPhaseShortName.Size = new System.Drawing.Size(76, 21);
            this.lbPhaseShortName.TabIndex = 8;
            this.lbPhaseShortName.Text = "Short Name:";
            this.lbPhaseShortName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // TextComment
            // 
            this.TextComment.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextComment.FillColor = System.Drawing.Color.White;
            this.TextComment.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextComment.Location = new System.Drawing.Point(349, 86);
            this.TextComment.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextComment.Maximum = 2147483647D;
            this.TextComment.Minimum = -2147483648D;
            this.TextComment.Name = "TextComment";
            this.TextComment.Padding = new System.Windows.Forms.Padding(5);
            this.TextComment.Size = new System.Drawing.Size(160, 29);
            this.TextComment.TabIndex = 11;
            // 
            // lbPhaseComment
            // 
            this.lbPhaseComment.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbPhaseComment.Location = new System.Drawing.Point(267, 89);
            this.lbPhaseComment.Name = "lbPhaseComment";
            this.lbPhaseComment.Size = new System.Drawing.Size(76, 21);
            this.lbPhaseComment.TabIndex = 10;
            this.lbPhaseComment.Text = "Comment:";
            this.lbPhaseComment.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // CmbLanguage
            // 
            this.CmbLanguage.DisplayMember = "Text";
            this.CmbLanguage.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.CmbLanguage.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.CmbLanguage.FormattingEnabled = true;
            this.CmbLanguage.ItemHeight = 23;
            this.CmbLanguage.Location = new System.Drawing.Point(349, 35);
            this.CmbLanguage.Name = "CmbLanguage";
            this.CmbLanguage.Size = new System.Drawing.Size(160, 29);
            this.CmbLanguage.TabIndex = 12;
            // 
            // lbLanguage
            // 
            this.lbLanguage.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbLanguage.Location = new System.Drawing.Point(267, 35);
            this.lbLanguage.Name = "lbLanguage";
            this.lbLanguage.Size = new System.Drawing.Size(76, 21);
            this.lbLanguage.TabIndex = 13;
            this.lbLanguage.Text = "Language:";
            this.lbLanguage.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // DateStart
            // 
            // 
            // 
            // 
            this.DateStart.BackgroundStyle.Class = "DateTimeInputBackground";
            this.DateStart.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.DateStart.ButtonDropDown.Shortcut = DevComponents.DotNetBar.eShortcut.AltDown;
            this.DateStart.ButtonDropDown.Visible = true;
            this.DateStart.CustomFormat = "yyyy-MM-dd HH:mm";
            this.DateStart.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.DateStart.Location = new System.Drawing.Point(88, 35);
            // 
            // 
            // 
            this.DateStart.MonthCalendar.AnnuallyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.DateStart.MonthCalendar.BackgroundStyle.BackColor = System.Drawing.SystemColors.Window;
            this.DateStart.MonthCalendar.BackgroundStyle.Class = "";
            this.DateStart.MonthCalendar.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.DateStart.MonthCalendar.ClearButtonVisible = true;
            // 
            // 
            // 
            this.DateStart.MonthCalendar.CommandsBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground2;
            this.DateStart.MonthCalendar.CommandsBackgroundStyle.BackColorGradientAngle = 90;
            this.DateStart.MonthCalendar.CommandsBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.DateStart.MonthCalendar.CommandsBackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.DateStart.MonthCalendar.CommandsBackgroundStyle.BorderTopColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarDockedBorder;
            this.DateStart.MonthCalendar.CommandsBackgroundStyle.BorderTopWidth = 1;
            this.DateStart.MonthCalendar.CommandsBackgroundStyle.Class = "";
            this.DateStart.MonthCalendar.CommandsBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.DateStart.MonthCalendar.DisplayMonth = new System.DateTime(2009, 8, 1, 0, 0, 0, 0);
            this.DateStart.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.DateStart.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.DateStart.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.DateStart.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.DateStart.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.DateStart.MonthCalendar.NavigationBackgroundStyle.Class = "";
            this.DateStart.MonthCalendar.NavigationBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.DateStart.MonthCalendar.TodayButtonVisible = true;
            this.DateStart.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.DateStart.Name = "DateStart";
            this.DateStart.Size = new System.Drawing.Size(160, 29);
            this.DateStart.TabIndex = 14;
            // 
            // DateEnd
            // 
            // 
            // 
            // 
            this.DateEnd.BackgroundStyle.Class = "DateTimeInputBackground";
            this.DateEnd.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.DateEnd.ButtonDropDown.Shortcut = DevComponents.DotNetBar.eShortcut.AltDown;
            this.DateEnd.ButtonDropDown.Visible = true;
            this.DateEnd.CustomFormat = "yyyy-MM-dd HH:mm";
            this.DateEnd.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.DateEnd.Location = new System.Drawing.Point(88, 61);
            // 
            // 
            // 
            this.DateEnd.MonthCalendar.AnnuallyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.DateEnd.MonthCalendar.BackgroundStyle.BackColor = System.Drawing.SystemColors.Window;
            this.DateEnd.MonthCalendar.BackgroundStyle.Class = "";
            this.DateEnd.MonthCalendar.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.DateEnd.MonthCalendar.ClearButtonVisible = true;
            // 
            // 
            // 
            this.DateEnd.MonthCalendar.CommandsBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground2;
            this.DateEnd.MonthCalendar.CommandsBackgroundStyle.BackColorGradientAngle = 90;
            this.DateEnd.MonthCalendar.CommandsBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.DateEnd.MonthCalendar.CommandsBackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.DateEnd.MonthCalendar.CommandsBackgroundStyle.BorderTopColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarDockedBorder;
            this.DateEnd.MonthCalendar.CommandsBackgroundStyle.BorderTopWidth = 1;
            this.DateEnd.MonthCalendar.CommandsBackgroundStyle.Class = "";
            this.DateEnd.MonthCalendar.CommandsBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.DateEnd.MonthCalendar.DisplayMonth = new System.DateTime(2009, 8, 1, 0, 0, 0, 0);
            this.DateEnd.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.DateEnd.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.DateEnd.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.DateEnd.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.DateEnd.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.DateEnd.MonthCalendar.NavigationBackgroundStyle.Class = "";
            this.DateEnd.MonthCalendar.NavigationBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.DateEnd.MonthCalendar.TodayButtonVisible = true;
            this.DateEnd.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.DateEnd.Name = "DateEnd";
            this.DateEnd.Size = new System.Drawing.Size(160, 29);
            this.DateEnd.TabIndex = 15;
            // 
            // lbStartDate
            // 
            this.lbStartDate.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbStartDate.Location = new System.Drawing.Point(6, 35);
            this.lbStartDate.Name = "lbStartDate";
            this.lbStartDate.Size = new System.Drawing.Size(76, 21);
            this.lbStartDate.TabIndex = 16;
            this.lbStartDate.Text = "Start Date:";
            this.lbStartDate.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbEndDate
            // 
            this.lbEndDate.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbEndDate.Location = new System.Drawing.Point(6, 61);
            this.lbEndDate.Name = "lbEndDate";
            this.lbEndDate.Size = new System.Drawing.Size(76, 21);
            this.lbEndDate.TabIndex = 17;
            this.lbEndDate.Text = "End Date:";
            this.lbEndDate.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // textIsPool
            // 
            this.textIsPool.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.textIsPool.FillColor = System.Drawing.Color.White;
            this.textIsPool.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.textIsPool.Location = new System.Drawing.Point(88, 116);
            this.textIsPool.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.textIsPool.Maximum = 2147483647D;
            this.textIsPool.Minimum = -2147483648D;
            this.textIsPool.Name = "textIsPool";
            this.textIsPool.Padding = new System.Windows.Forms.Padding(5);
            this.textIsPool.Size = new System.Drawing.Size(160, 29);
            this.textIsPool.TabIndex = 19;
            // 
            // lbPhaseIsPool
            // 
            this.lbPhaseIsPool.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbPhaseIsPool.Location = new System.Drawing.Point(6, 116);
            this.lbPhaseIsPool.Name = "lbPhaseIsPool";
            this.lbPhaseIsPool.Size = new System.Drawing.Size(76, 21);
            this.lbPhaseIsPool.TabIndex = 18;
            this.lbPhaseIsPool.Text = "Is Pool:";
            this.lbPhaseIsPool.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // textHasPools
            // 
            this.textHasPools.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.textHasPools.FillColor = System.Drawing.Color.White;
            this.textHasPools.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.textHasPools.Location = new System.Drawing.Point(88, 145);
            this.textHasPools.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.textHasPools.Maximum = 2147483647D;
            this.textHasPools.Minimum = -2147483648D;
            this.textHasPools.Name = "textHasPools";
            this.textHasPools.Padding = new System.Windows.Forms.Padding(5);
            this.textHasPools.Size = new System.Drawing.Size(160, 29);
            this.textHasPools.TabIndex = 21;
            // 
            // lbPhaseHasPools
            // 
            this.lbPhaseHasPools.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbPhaseHasPools.Location = new System.Drawing.Point(6, 148);
            this.lbPhaseHasPools.Name = "lbPhaseHasPools";
            this.lbPhaseHasPools.Size = new System.Drawing.Size(76, 21);
            this.lbPhaseHasPools.TabIndex = 20;
            this.lbPhaseHasPools.Text = "Has Pools:";
            this.lbPhaseHasPools.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbPhaseStatus
            // 
            this.lbPhaseStatus.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbPhaseStatus.Location = new System.Drawing.Point(249, 116);
            this.lbPhaseStatus.Name = "lbPhaseStatus";
            this.lbPhaseStatus.Size = new System.Drawing.Size(94, 21);
            this.lbPhaseStatus.TabIndex = 23;
            this.lbPhaseStatus.Text = "Status:";
            this.lbPhaseStatus.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // CmbStatus
            // 
            this.CmbStatus.DisplayMember = "Text";
            this.CmbStatus.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.CmbStatus.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.CmbStatus.FormattingEnabled = true;
            this.CmbStatus.ItemHeight = 23;
            this.CmbStatus.Location = new System.Drawing.Point(349, 113);
            this.CmbStatus.Name = "CmbStatus";
            this.CmbStatus.Size = new System.Drawing.Size(160, 29);
            this.CmbStatus.TabIndex = 22;
            // 
            // PhaseInfoForm
            // 
            this.ClientSize = new System.Drawing.Size(577, 310);
            this.Controls.Add(this.lbPhaseStatus);
            this.Controls.Add(this.CmbStatus);
            this.Controls.Add(this.textHasPools);
            this.Controls.Add(this.lbPhaseHasPools);
            this.Controls.Add(this.textIsPool);
            this.Controls.Add(this.lbPhaseIsPool);
            this.Controls.Add(this.lbEndDate);
            this.Controls.Add(this.lbStartDate);
            this.Controls.Add(this.DateEnd);
            this.Controls.Add(this.DateStart);
            this.Controls.Add(this.lbLanguage);
            this.Controls.Add(this.CmbLanguage);
            this.Controls.Add(this.TextComment);
            this.Controls.Add(this.lbPhaseComment);
            this.Controls.Add(this.TextShortName);
            this.Controls.Add(this.lbPhaseShortName);
            this.Controls.Add(this.TextLongName);
            this.Controls.Add(this.lbPhaseLongName);
            this.Controls.Add(this.TextOrder);
            this.Controls.Add(this.lbPhaseOrder);
            this.Controls.Add(this.TextCode);
            this.Controls.Add(this.lbPhaseCode);
            this.Controls.Add(this.btnCancle);
            this.Controls.Add(this.btnOK);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "PhaseInfoForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Phase Information Form";
            this.Load += new System.EventHandler(this.PhaseInfoForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.DateStart)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.DateEnd)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnOK;
        private DevComponents.DotNetBar.ButtonX btnCancle;
        private UILabel lbPhaseCode;
        private UITextBox TextCode;
        private UITextBox TextOrder;
        private UILabel lbPhaseOrder;
        private UITextBox TextLongName;
        private UILabel lbPhaseLongName;
        private UITextBox TextShortName;
        private UILabel lbPhaseShortName;
        private UITextBox TextComment;
        private UILabel lbPhaseComment;
        private DevComponents.DotNetBar.Controls.ComboBoxEx CmbLanguage;
        private UILabel lbLanguage;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput DateStart;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput DateEnd;
        private UILabel lbStartDate;
        private UILabel lbEndDate;
        private UITextBox textIsPool;
        private UILabel lbPhaseIsPool;
        private UITextBox textHasPools;
        private UILabel lbPhaseHasPools;
        private UILabel lbPhaseStatus;
        private DevComponents.DotNetBar.Controls.ComboBoxEx CmbStatus;
    }
}