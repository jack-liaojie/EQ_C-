using Sunny.UI;

namespace AutoSports.OVRManagerApp
{
    partial class OVROfficialItemForm
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
            this.lbItem = new Sunny.UI.UILabel();
            this.lbHeading = new Sunny.UI.UILabel();
            this.lbSubTitle = new Sunny.UI.UILabel();
            this.lbText = new Sunny.UI.UILabel();
            this.textItem = new Sunny.UI.UITextBox();
            this.textText = new Sunny.UI.UITextBox();
            this.textSubTitle = new Sunny.UI.UITextBox();
            this.textHeading = new Sunny.UI.UITextBox();
            this.lbIssuedBy = new Sunny.UI.UILabel();
            this.textIssuedBy = new Sunny.UI.UITextBox();
            this.lbDate_OC = new Sunny.UI.UILabel();
            this.cmbOCType = new Sunny.UI.UIComboBox();
            this.lbType_OC = new Sunny.UI.UILabel();
            this.dtOCDate = new DevComponents.Editors.DateTimeAdv.DateTimeInput();
            this.btnCancel = new Sunny.UI.UISymbolButton();
            this.btnOK = new Sunny.UI.UISymbolButton();
            this.lbNote = new Sunny.UI.UILabel();
            this.textNote = new Sunny.UI.UITextBox();
            this.txtSummary = new Sunny.UI.UITextBox();
            this.lbSummary = new Sunny.UI.UILabel();
            this.txtDetails = new Sunny.UI.UITextBox();
            this.lbDetails = new Sunny.UI.UILabel();
            this.cmbReportTitle = new Sunny.UI.UIComboBox();
            this.lbReportTitle = new Sunny.UI.UILabel();
            ((System.ComponentModel.ISupportInitialize)(this.dtOCDate)).BeginInit();
            this.SuspendLayout();
            // 
            // lbItem
            // 
            this.lbItem.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbItem.Location = new System.Drawing.Point(6, 95);
            this.lbItem.Name = "lbItem";
            this.lbItem.Size = new System.Drawing.Size(110, 19);
            this.lbItem.TabIndex = 0;
            this.lbItem.Text = "Item:";
            this.lbItem.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbHeading
            // 
            this.lbHeading.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbHeading.Location = new System.Drawing.Point(6, 201);
            this.lbHeading.Name = "lbHeading";
            this.lbHeading.Size = new System.Drawing.Size(110, 19);
            this.lbHeading.TabIndex = 0;
            this.lbHeading.Text = "Heading:";
            this.lbHeading.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbSubTitle
            // 
            this.lbSubTitle.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbSubTitle.Location = new System.Drawing.Point(6, 148);
            this.lbSubTitle.Name = "lbSubTitle";
            this.lbSubTitle.Size = new System.Drawing.Size(110, 19);
            this.lbSubTitle.TabIndex = 0;
            this.lbSubTitle.Text = "SubTitle:";
            this.lbSubTitle.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbText
            // 
            this.lbText.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbText.Location = new System.Drawing.Point(6, 254);
            this.lbText.Name = "lbText";
            this.lbText.Size = new System.Drawing.Size(110, 19);
            this.lbText.TabIndex = 0;
            this.lbText.Text = "Issue:";
            this.lbText.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // textItem
            // 
            this.textItem.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.textItem.FillColor = System.Drawing.Color.White;
            this.textItem.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.textItem.Location = new System.Drawing.Point(158, 88);
            this.textItem.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.textItem.Maximum = 2147483647D;
            this.textItem.MaxLength = 3;
            this.textItem.Minimum = -2147483648D;
            this.textItem.Name = "textItem";
            this.textItem.Padding = new System.Windows.Forms.Padding(5);
            this.textItem.Size = new System.Drawing.Size(529, 29);
            this.textItem.TabIndex = 1;
            // 
            // textText
            // 
            this.textText.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.textText.FillColor = System.Drawing.Color.White;
            this.textText.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.textText.Location = new System.Drawing.Point(158, 226);
            this.textText.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.textText.Maximum = 2147483647D;
            this.textText.Minimum = -2147483648D;
            this.textText.Multiline = true;
            this.textText.Name = "textText";
            this.textText.Padding = new System.Windows.Forms.Padding(5);
            this.textText.Size = new System.Drawing.Size(529, 69);
            this.textText.TabIndex = 4;
            // 
            // textSubTitle
            // 
            this.textSubTitle.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.textSubTitle.FillColor = System.Drawing.Color.White;
            this.textSubTitle.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.textSubTitle.Location = new System.Drawing.Point(158, 134);
            this.textSubTitle.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.textSubTitle.Maximum = 2147483647D;
            this.textSubTitle.Minimum = -2147483648D;
            this.textSubTitle.Name = "textSubTitle";
            this.textSubTitle.Padding = new System.Windows.Forms.Padding(5);
            this.textSubTitle.Size = new System.Drawing.Size(529, 29);
            this.textSubTitle.TabIndex = 2;
            // 
            // textHeading
            // 
            this.textHeading.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.textHeading.FillColor = System.Drawing.Color.White;
            this.textHeading.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.textHeading.Location = new System.Drawing.Point(158, 180);
            this.textHeading.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.textHeading.Maximum = 2147483647D;
            this.textHeading.Minimum = -2147483648D;
            this.textHeading.Name = "textHeading";
            this.textHeading.Padding = new System.Windows.Forms.Padding(5);
            this.textHeading.Size = new System.Drawing.Size(529, 29);
            this.textHeading.TabIndex = 3;
            // 
            // lbIssuedBy
            // 
            this.lbIssuedBy.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbIssuedBy.Location = new System.Drawing.Point(6, 413);
            this.lbIssuedBy.Name = "lbIssuedBy";
            this.lbIssuedBy.Size = new System.Drawing.Size(110, 19);
            this.lbIssuedBy.TabIndex = 0;
            this.lbIssuedBy.Text = "Issued_By:";
            this.lbIssuedBy.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // textIssuedBy
            // 
            this.textIssuedBy.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.textIssuedBy.FillColor = System.Drawing.Color.White;
            this.textIssuedBy.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.textIssuedBy.Location = new System.Drawing.Point(157, 530);
            this.textIssuedBy.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.textIssuedBy.Maximum = 2147483647D;
            this.textIssuedBy.Minimum = -2147483648D;
            this.textIssuedBy.Name = "textIssuedBy";
            this.textIssuedBy.Padding = new System.Windows.Forms.Padding(5);
            this.textIssuedBy.Size = new System.Drawing.Size(530, 29);
            this.textIssuedBy.TabIndex = 5;
            // 
            // lbDate_OC
            // 
            this.lbDate_OC.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbDate_OC.Location = new System.Drawing.Point(6, 519);
            this.lbDate_OC.Name = "lbDate_OC";
            this.lbDate_OC.Size = new System.Drawing.Size(110, 19);
            this.lbDate_OC.TabIndex = 0;
            this.lbDate_OC.Text = "Date:";
            this.lbDate_OC.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // cmbOCType
            // 
            this.cmbOCType.DisplayMember = "Text";
            this.cmbOCType.FillColor = System.Drawing.Color.White;
            this.cmbOCType.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cmbOCType.FormattingEnabled = true;
            this.cmbOCType.ItemHeight = 23;
            this.cmbOCType.Location = new System.Drawing.Point(157, 398);
            this.cmbOCType.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cmbOCType.MinimumSize = new System.Drawing.Size(63, 0);
            this.cmbOCType.Name = "cmbOCType";
            this.cmbOCType.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cmbOCType.Size = new System.Drawing.Size(530, 29);
            this.cmbOCType.TabIndex = 6;
            this.cmbOCType.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbType_OC
            // 
            this.lbType_OC.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbType_OC.Location = new System.Drawing.Point(6, 466);
            this.lbType_OC.Name = "lbType_OC";
            this.lbType_OC.Size = new System.Drawing.Size(110, 19);
            this.lbType_OC.TabIndex = 0;
            this.lbType_OC.Text = "Type:";
            this.lbType_OC.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // dtOCDate
            // 
            // 
            // 
            // 
            this.dtOCDate.BackgroundStyle.Class = "DateTimeInputBackground";
            this.dtOCDate.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtOCDate.ButtonDropDown.Shortcut = DevComponents.DotNetBar.eShortcut.AltDown;
            this.dtOCDate.ButtonDropDown.Visible = true;
            this.dtOCDate.CustomFormat = "yyyy-MM-dd HH:mm";
            this.dtOCDate.Format = DevComponents.Editors.eDateTimePickerFormat.Custom;
            this.dtOCDate.Location = new System.Drawing.Point(160, 400);
            // 
            // 
            // 
            this.dtOCDate.MonthCalendar.AnnuallyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dtOCDate.MonthCalendar.BackgroundStyle.BackColor = System.Drawing.SystemColors.Window;
            this.dtOCDate.MonthCalendar.BackgroundStyle.Class = "";
            this.dtOCDate.MonthCalendar.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtOCDate.MonthCalendar.ClearButtonVisible = true;
            // 
            // 
            // 
            this.dtOCDate.MonthCalendar.CommandsBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground2;
            this.dtOCDate.MonthCalendar.CommandsBackgroundStyle.BackColorGradientAngle = 90;
            this.dtOCDate.MonthCalendar.CommandsBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.dtOCDate.MonthCalendar.CommandsBackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.dtOCDate.MonthCalendar.CommandsBackgroundStyle.BorderTopColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarDockedBorder;
            this.dtOCDate.MonthCalendar.CommandsBackgroundStyle.BorderTopWidth = 1;
            this.dtOCDate.MonthCalendar.CommandsBackgroundStyle.Class = "";
            this.dtOCDate.MonthCalendar.CommandsBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtOCDate.MonthCalendar.DisplayMonth = new System.DateTime(2010, 1, 1, 0, 0, 0, 0);
            this.dtOCDate.MonthCalendar.MarkedDates = new System.DateTime[0];
            this.dtOCDate.MonthCalendar.MonthlyMarkedDates = new System.DateTime[0];
            // 
            // 
            // 
            this.dtOCDate.MonthCalendar.NavigationBackgroundStyle.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.dtOCDate.MonthCalendar.NavigationBackgroundStyle.BackColorGradientAngle = 90;
            this.dtOCDate.MonthCalendar.NavigationBackgroundStyle.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.dtOCDate.MonthCalendar.NavigationBackgroundStyle.Class = "";
            this.dtOCDate.MonthCalendar.NavigationBackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.dtOCDate.MonthCalendar.TodayButtonVisible = true;
            this.dtOCDate.MonthCalendar.WeeklyMarkedDays = new System.DayOfWeek[0];
            this.dtOCDate.Name = "dtOCDate";
            this.dtOCDate.Size = new System.Drawing.Size(529, 29);
            this.dtOCDate.TabIndex = 7;
            // 
            // btnCancel
            // 
            this.btnCancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnCancel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnCancel.Location = new System.Drawing.Point(635, 666);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnCancel.Size = new System.Drawing.Size(50, 30);
            this.btnCancel.Symbol = 61453;
            this.btnCancel.TabIndex = 25;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnOK
            // 
            this.btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOK.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnOK.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnOK.Location = new System.Drawing.Point(545, 666);
            this.btnOK.Name = "btnOK";
            this.btnOK.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnOK.Size = new System.Drawing.Size(50, 30);
            this.btnOK.TabIndex = 24;
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // lbNote
            // 
            this.lbNote.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbNote.Location = new System.Drawing.Point(6, 572);
            this.lbNote.Name = "lbNote";
            this.lbNote.Size = new System.Drawing.Size(110, 19);
            this.lbNote.TabIndex = 0;
            this.lbNote.Text = "Note:";
            this.lbNote.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // textNote
            // 
            this.textNote.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.textNote.FillColor = System.Drawing.Color.White;
            this.textNote.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.textNote.Location = new System.Drawing.Point(158, 576);
            this.textNote.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.textNote.Maximum = 2147483647D;
            this.textNote.Minimum = -2147483648D;
            this.textNote.Multiline = true;
            this.textNote.Name = "textNote";
            this.textNote.Padding = new System.Windows.Forms.Padding(5);
            this.textNote.Size = new System.Drawing.Size(529, 69);
            this.textNote.TabIndex = 8;
            // 
            // txtSummary
            // 
            this.txtSummary.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txtSummary.FillColor = System.Drawing.Color.White;
            this.txtSummary.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txtSummary.Location = new System.Drawing.Point(158, 312);
            this.txtSummary.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txtSummary.Maximum = 2147483647D;
            this.txtSummary.Minimum = -2147483648D;
            this.txtSummary.Multiline = true;
            this.txtSummary.Name = "txtSummary";
            this.txtSummary.Padding = new System.Windows.Forms.Padding(5);
            this.txtSummary.Size = new System.Drawing.Size(529, 69);
            this.txtSummary.TabIndex = 27;
            // 
            // lbSummary
            // 
            this.lbSummary.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbSummary.Location = new System.Drawing.Point(6, 307);
            this.lbSummary.Name = "lbSummary";
            this.lbSummary.Size = new System.Drawing.Size(110, 19);
            this.lbSummary.TabIndex = 26;
            this.lbSummary.Text = "Summary:";
            this.lbSummary.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // txtDetails
            // 
            this.txtDetails.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txtDetails.FillColor = System.Drawing.Color.White;
            this.txtDetails.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txtDetails.Location = new System.Drawing.Point(158, 444);
            this.txtDetails.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txtDetails.Maximum = 2147483647D;
            this.txtDetails.Minimum = -2147483648D;
            this.txtDetails.Multiline = true;
            this.txtDetails.Name = "txtDetails";
            this.txtDetails.Padding = new System.Windows.Forms.Padding(5);
            this.txtDetails.Size = new System.Drawing.Size(529, 69);
            this.txtDetails.TabIndex = 29;
            // 
            // lbDetails
            // 
            this.lbDetails.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbDetails.Location = new System.Drawing.Point(6, 360);
            this.lbDetails.Name = "lbDetails";
            this.lbDetails.Size = new System.Drawing.Size(110, 19);
            this.lbDetails.TabIndex = 28;
            this.lbDetails.Text = "Details:";
            this.lbDetails.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // cmbReportTitle
            // 
            this.cmbReportTitle.DisplayMember = "Text";
            this.cmbReportTitle.FillColor = System.Drawing.Color.White;
            this.cmbReportTitle.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cmbReportTitle.FormattingEnabled = true;
            this.cmbReportTitle.ItemHeight = 23;
            this.cmbReportTitle.Location = new System.Drawing.Point(158, 42);
            this.cmbReportTitle.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cmbReportTitle.MinimumSize = new System.Drawing.Size(63, 0);
            this.cmbReportTitle.Name = "cmbReportTitle";
            this.cmbReportTitle.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cmbReportTitle.Size = new System.Drawing.Size(529, 29);
            this.cmbReportTitle.TabIndex = 31;
            this.cmbReportTitle.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbReportTitle
            // 
            this.lbReportTitle.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbReportTitle.Location = new System.Drawing.Point(6, 42);
            this.lbReportTitle.Name = "lbReportTitle";
            this.lbReportTitle.Size = new System.Drawing.Size(110, 19);
            this.lbReportTitle.TabIndex = 30;
            this.lbReportTitle.Text = "Report Title:";
            this.lbReportTitle.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // OVROfficialItemForm
            // 
            this.AcceptButton = this.btnOK;
            this.CancelButton = this.btnCancel;
            this.ClientSize = new System.Drawing.Size(711, 711);
            this.Controls.Add(this.cmbReportTitle);
            this.Controls.Add(this.lbReportTitle);
            this.Controls.Add(this.txtDetails);
            this.Controls.Add(this.lbDetails);
            this.Controls.Add(this.txtSummary);
            this.Controls.Add(this.lbSummary);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.dtOCDate);
            this.Controls.Add(this.cmbOCType);
            this.Controls.Add(this.textNote);
            this.Controls.Add(this.textText);
            this.Controls.Add(this.textHeading);
            this.Controls.Add(this.textIssuedBy);
            this.Controls.Add(this.textSubTitle);
            this.Controls.Add(this.textItem);
            this.Controls.Add(this.lbType_OC);
            this.Controls.Add(this.lbDate_OC);
            this.Controls.Add(this.lbNote);
            this.Controls.Add(this.lbIssuedBy);
            this.Controls.Add(this.lbText);
            this.Controls.Add(this.lbSubTitle);
            this.Controls.Add(this.lbHeading);
            this.Controls.Add(this.lbItem);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVROfficialItemForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "Official Communication Item";
            this.Load += new System.EventHandler(this.OfficialItemForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dtOCDate)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private UILabel lbItem;
        private UILabel lbHeading;
        private UILabel lbSubTitle;
        private UILabel lbText;
        private UITextBox textItem;
        private UITextBox textText;
        private UITextBox textSubTitle;
        private UITextBox textHeading;
        private UILabel lbIssuedBy;
        private UITextBox textIssuedBy;
        private UILabel lbDate_OC;
        private UIComboBox cmbOCType;
        private UILabel lbType_OC;
        private DevComponents.Editors.DateTimeAdv.DateTimeInput dtOCDate;
        private UISymbolButton btnCancel;
        private UISymbolButton btnOK;
        private UILabel lbNote;
        private UITextBox textNote;
        private UITextBox txtSummary;
        private UILabel lbSummary;
        private UITextBox txtDetails;
        private UILabel lbDetails;
        private UIComboBox cmbReportTitle;
        private UILabel lbReportTitle;
    }
}