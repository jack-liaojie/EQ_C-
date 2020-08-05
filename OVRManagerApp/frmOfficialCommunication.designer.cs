using Sunny.UI;

namespace AutoSports.OVRManagerApp
{
    partial class OVRCommunicationForm
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle5 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle7 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle8 = new System.Windows.Forms.DataGridViewCellStyle();
            this.dgvCommunication = new Sunny.UI.UIDataGridView();
            this.btnPreview = new Sunny.UI.UIButton();
            this.btnPrintToPdf = new Sunny.UI.UIButton();
            this.btnDel = new Sunny.UI.UISymbolButton();
            this.btnEdit = new Sunny.UI.UISymbolButton();
            this.btnAdd = new Sunny.UI.UISymbolButton();
            this.chbTest = new Sunny.UI.UICheckBox();
            this.chbCorrected = new Sunny.UI.UICheckBox();
            this.lbVersion = new System.Windows.Forms.Label();
            this.lbRptType = new System.Windows.Forms.Label();
            this.lbRscCode = new System.Windows.Forms.Label();
            this.tbVersion = new Sunny.UI.UITextBox();
            this.tbRptType = new Sunny.UI.UITextBox();
            this.tbRscCode = new Sunny.UI.UITextBox();
            this.dgvReportForDuty = new Sunny.UI.UIDataGridView();
            this.btnPreviewDuty = new Sunny.UI.UIButton();
            this.btnPrintToPdfDuty = new Sunny.UI.UIButton();
            this.grpOfficialCom = new Sunny.UI.UIGroupBox();
            this.lbDisVersion = new System.Windows.Forms.Label();
            this.tbDisVersion = new Sunny.UI.UITextBox();
            this.grpReportForDuty = new Sunny.UI.UIGroupBox();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCommunication)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvReportForDuty)).BeginInit();
            this.grpOfficialCom.SuspendLayout();
            this.grpReportForDuty.SuspendLayout();
            this.SuspendLayout();
            // 
            // dgvCommunication
            // 
            this.dgvCommunication.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvCommunication.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvCommunication.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvCommunication.BackgroundColor = System.Drawing.Color.White;
            this.dgvCommunication.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvCommunication.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvCommunication.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvCommunication.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvCommunication.DefaultCellStyle = dataGridViewCellStyle3;
            this.dgvCommunication.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.dgvCommunication.EnableHeadersVisualStyles = false;
            this.dgvCommunication.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvCommunication.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvCommunication.Location = new System.Drawing.Point(0, 188);
            this.dgvCommunication.MultiSelect = false;
            this.dgvCommunication.Name = "dgvCommunication";
            this.dgvCommunication.ReadOnly = true;
            this.dgvCommunication.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvCommunication.RowHeadersVisible = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.White;
            this.dgvCommunication.RowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvCommunication.RowTemplate.Height = 29;
            this.dgvCommunication.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvCommunication.SelectedIndex = -1;
            this.dgvCommunication.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvCommunication.Size = new System.Drawing.Size(750, 270);
            this.dgvCommunication.TabIndex = 0;
            this.dgvCommunication.TagString = null;
            this.dgvCommunication.SelectionChanged += new System.EventHandler(this.dgvCommunication_SelectionChanged);
            // 
            // btnPreview
            // 
            this.btnPreview.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnPreview.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnPreview.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnPreview.Location = new System.Drawing.Point(457, 139);
            this.btnPreview.Name = "btnPreview";
            this.btnPreview.Size = new System.Drawing.Size(90, 30);
            this.btnPreview.TabIndex = 4;
            this.btnPreview.Text = "Preview";
            this.btnPreview.Click += new System.EventHandler(this.btnPreview_Click);
            // 
            // btnPrintToPdf
            // 
            this.btnPrintToPdf.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnPrintToPdf.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnPrintToPdf.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnPrintToPdf.Location = new System.Drawing.Point(561, 139);
            this.btnPrintToPdf.Name = "btnPrintToPdf";
            this.btnPrintToPdf.Size = new System.Drawing.Size(90, 30);
            this.btnPrintToPdf.TabIndex = 4;
            this.btnPrintToPdf.Text = "Generate";
            this.btnPrintToPdf.Click += new System.EventHandler(this.btnPrintTpPdf_Click);
            // 
            // btnDel
            // 
            this.btnDel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnDel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnDel.Location = new System.Drawing.Point(218, 139);
            this.btnDel.Name = "btnDel";
            this.btnDel.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnDel.Size = new System.Drawing.Size(50, 30);
            this.btnDel.Symbol = 61544;
            this.btnDel.TabIndex = 3;
            this.btnDel.Click += new System.EventHandler(this.btnDel_Click);
            // 
            // btnEdit
            // 
            this.btnEdit.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnEdit.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnEdit.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnEdit.Location = new System.Drawing.Point(146, 139);
            this.btnEdit.Name = "btnEdit";
            this.btnEdit.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnEdit.Size = new System.Drawing.Size(50, 30);
            this.btnEdit.Symbol = 61508;
            this.btnEdit.TabIndex = 2;
            this.btnEdit.Click += new System.EventHandler(this.btnEdit_Click);
            // 
            // btnAdd
            // 
            this.btnAdd.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAdd.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnAdd.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnAdd.Location = new System.Drawing.Point(74, 139);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnAdd.Size = new System.Drawing.Size(50, 30);
            this.btnAdd.Symbol = 61543;
            this.btnAdd.TabIndex = 1;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // chbTest
            // 
            this.chbTest.Cursor = System.Windows.Forms.Cursors.Hand;
            this.chbTest.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.chbTest.Location = new System.Drawing.Point(536, 89);
            this.chbTest.Name = "chbTest";
            this.chbTest.Padding = new System.Windows.Forms.Padding(22, 0, 0, 0);
            this.chbTest.Size = new System.Drawing.Size(60, 26);
            this.chbTest.TabIndex = 15;
            this.chbTest.Text = "Test";
            this.chbTest.Click += new System.EventHandler(this.chbTest_CheckedChanged);
            // 
            // chbCorrected
            // 
            this.chbCorrected.Cursor = System.Windows.Forms.Cursors.Hand;
            this.chbCorrected.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.chbCorrected.Location = new System.Drawing.Point(536, 54);
            this.chbCorrected.Name = "chbCorrected";
            this.chbCorrected.Padding = new System.Windows.Forms.Padding(22, 0, 0, 0);
            this.chbCorrected.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.chbCorrected.Size = new System.Drawing.Size(106, 26);
            this.chbCorrected.TabIndex = 16;
            this.chbCorrected.Text = "Corrected";
            this.chbCorrected.Click += new System.EventHandler(this.chbCorrect_CheckedChanged);
            // 
            // lbVersion
            // 
            this.lbVersion.Location = new System.Drawing.Point(293, 55);
            this.lbVersion.Name = "lbVersion";
            this.lbVersion.Size = new System.Drawing.Size(85, 25);
            this.lbVersion.TabIndex = 13;
            this.lbVersion.Text = "Version";
            this.lbVersion.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbRptType
            // 
            this.lbRptType.Location = new System.Drawing.Point(14, 92);
            this.lbRptType.Name = "lbRptType";
            this.lbRptType.Size = new System.Drawing.Size(49, 20);
            this.lbRptType.TabIndex = 14;
            this.lbRptType.Text = "Type";
            this.lbRptType.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbRscCode
            // 
            this.lbRscCode.Location = new System.Drawing.Point(14, 55);
            this.lbRscCode.Name = "lbRscCode";
            this.lbRscCode.Size = new System.Drawing.Size(75, 25);
            this.lbRscCode.TabIndex = 11;
            this.lbRscCode.Text = "RSC";
            this.lbRscCode.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // tbVersion
            // 
            this.tbVersion.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbVersion.FillColor = System.Drawing.Color.White;
            this.tbVersion.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbVersion.Location = new System.Drawing.Point(394, 53);
            this.tbVersion.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.tbVersion.Maximum = 2147483647D;
            this.tbVersion.MaxLength = 10;
            this.tbVersion.Minimum = -2147483648D;
            this.tbVersion.Name = "tbVersion";
            this.tbVersion.Padding = new System.Windows.Forms.Padding(5);
            this.tbVersion.Size = new System.Drawing.Size(126, 29);
            this.tbVersion.TabIndex = 12;
            // 
            // tbRptType
            // 
            this.tbRptType.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbRptType.FillColor = System.Drawing.Color.White;
            this.tbRptType.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbRptType.Location = new System.Drawing.Point(96, 88);
            this.tbRptType.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.tbRptType.Maximum = 2147483647D;
            this.tbRptType.MaxLength = 20;
            this.tbRptType.Minimum = -2147483648D;
            this.tbRptType.Name = "tbRptType";
            this.tbRptType.Padding = new System.Windows.Forms.Padding(5);
            this.tbRptType.Size = new System.Drawing.Size(172, 29);
            this.tbRptType.TabIndex = 10;
            // 
            // tbRscCode
            // 
            this.tbRscCode.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbRscCode.FillColor = System.Drawing.Color.White;
            this.tbRscCode.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbRscCode.Location = new System.Drawing.Point(96, 54);
            this.tbRscCode.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.tbRscCode.Maximum = 2147483647D;
            this.tbRscCode.Minimum = -2147483648D;
            this.tbRscCode.Name = "tbRscCode";
            this.tbRscCode.Padding = new System.Windows.Forms.Padding(5);
            this.tbRscCode.Size = new System.Drawing.Size(172, 29);
            this.tbRscCode.TabIndex = 9;
            // 
            // dgvReportForDuty
            // 
            this.dgvReportForDuty.AllowUserToAddRows = false;
            dataGridViewCellStyle5.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvReportForDuty.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle5;
            this.dgvReportForDuty.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvReportForDuty.BackgroundColor = System.Drawing.Color.White;
            this.dgvReportForDuty.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvReportForDuty.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle6.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle6.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle6.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle6.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle6.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle6.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle6.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvReportForDuty.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle6;
            this.dgvReportForDuty.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle7.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle7.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle7.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle7.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle7.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle7.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle7.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvReportForDuty.DefaultCellStyle = dataGridViewCellStyle7;
            this.dgvReportForDuty.EnableHeadersVisualStyles = false;
            this.dgvReportForDuty.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvReportForDuty.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvReportForDuty.Location = new System.Drawing.Point(3, 35);
            this.dgvReportForDuty.MultiSelect = false;
            this.dgvReportForDuty.Name = "dgvReportForDuty";
            this.dgvReportForDuty.ReadOnly = true;
            this.dgvReportForDuty.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvReportForDuty.RowHeadersVisible = false;
            dataGridViewCellStyle8.BackColor = System.Drawing.Color.White;
            this.dgvReportForDuty.RowsDefaultCellStyle = dataGridViewCellStyle8;
            this.dgvReportForDuty.RowTemplate.Height = 29;
            this.dgvReportForDuty.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvReportForDuty.SelectedIndex = -1;
            this.dgvReportForDuty.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvReportForDuty.Size = new System.Drawing.Size(638, 73);
            this.dgvReportForDuty.TabIndex = 0;
            this.dgvReportForDuty.TagString = null;
            // 
            // btnPreviewDuty
            // 
            this.btnPreviewDuty.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnPreviewDuty.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnPreviewDuty.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnPreviewDuty.Location = new System.Drawing.Point(647, 35);
            this.btnPreviewDuty.Name = "btnPreviewDuty";
            this.btnPreviewDuty.Size = new System.Drawing.Size(90, 30);
            this.btnPreviewDuty.TabIndex = 4;
            this.btnPreviewDuty.Text = "Preview";
            this.btnPreviewDuty.Click += new System.EventHandler(this.btnPreviewDuty_Click);
            // 
            // btnPrintToPdfDuty
            // 
            this.btnPrintToPdfDuty.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnPrintToPdfDuty.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnPrintToPdfDuty.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnPrintToPdfDuty.Location = new System.Drawing.Point(647, 71);
            this.btnPrintToPdfDuty.Name = "btnPrintToPdfDuty";
            this.btnPrintToPdfDuty.Size = new System.Drawing.Size(90, 30);
            this.btnPrintToPdfDuty.TabIndex = 4;
            this.btnPrintToPdfDuty.Text = "Generate";
            this.btnPrintToPdfDuty.Click += new System.EventHandler(this.btnPrintTpPdfDuty_Click);
            // 
            // grpOfficialCom
            // 
            this.grpOfficialCom.Controls.Add(this.lbDisVersion);
            this.grpOfficialCom.Controls.Add(this.tbDisVersion);
            this.grpOfficialCom.Controls.Add(this.dgvCommunication);
            this.grpOfficialCom.Controls.Add(this.btnAdd);
            this.grpOfficialCom.Controls.Add(this.btnPrintToPdf);
            this.grpOfficialCom.Controls.Add(this.chbTest);
            this.grpOfficialCom.Controls.Add(this.btnDel);
            this.grpOfficialCom.Controls.Add(this.tbVersion);
            this.grpOfficialCom.Controls.Add(this.tbRptType);
            this.grpOfficialCom.Controls.Add(this.lbRptType);
            this.grpOfficialCom.Controls.Add(this.lbVersion);
            this.grpOfficialCom.Controls.Add(this.lbRscCode);
            this.grpOfficialCom.Controls.Add(this.chbCorrected);
            this.grpOfficialCom.Controls.Add(this.btnEdit);
            this.grpOfficialCom.Controls.Add(this.tbRscCode);
            this.grpOfficialCom.Controls.Add(this.btnPreview);
            this.grpOfficialCom.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.grpOfficialCom.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.grpOfficialCom.Location = new System.Drawing.Point(2, 123);
            this.grpOfficialCom.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.grpOfficialCom.Name = "grpOfficialCom";
            this.grpOfficialCom.Padding = new System.Windows.Forms.Padding(0, 32, 0, 0);
            this.grpOfficialCom.Size = new System.Drawing.Size(750, 458);
            this.grpOfficialCom.TabIndex = 17;
            this.grpOfficialCom.Text = "Official Communication";
            // 
            // lbDisVersion
            // 
            this.lbDisVersion.Location = new System.Drawing.Point(263, 90);
            this.lbDisVersion.Name = "lbDisVersion";
            this.lbDisVersion.Size = new System.Drawing.Size(119, 24);
            this.lbDisVersion.TabIndex = 18;
            this.lbDisVersion.Text = "Distrubuted VerSion";
            this.lbDisVersion.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // tbDisVersion
            // 
            this.tbDisVersion.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbDisVersion.FillColor = System.Drawing.Color.White;
            this.tbDisVersion.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbDisVersion.Location = new System.Drawing.Point(396, 88);
            this.tbDisVersion.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.tbDisVersion.Maximum = 2147483647D;
            this.tbDisVersion.MaxLength = 10;
            this.tbDisVersion.Minimum = -2147483648D;
            this.tbDisVersion.Name = "tbDisVersion";
            this.tbDisVersion.Padding = new System.Windows.Forms.Padding(5);
            this.tbDisVersion.Size = new System.Drawing.Size(126, 29);
            this.tbDisVersion.TabIndex = 17;
            // 
            // grpReportForDuty
            // 
            this.grpReportForDuty.Controls.Add(this.btnPreviewDuty);
            this.grpReportForDuty.Controls.Add(this.btnPrintToPdfDuty);
            this.grpReportForDuty.Controls.Add(this.dgvReportForDuty);
            this.grpReportForDuty.Dock = System.Windows.Forms.DockStyle.Top;
            this.grpReportForDuty.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.grpReportForDuty.Location = new System.Drawing.Point(2, 2);
            this.grpReportForDuty.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.grpReportForDuty.Name = "grpReportForDuty";
            this.grpReportForDuty.Padding = new System.Windows.Forms.Padding(0, 32, 0, 0);
            this.grpReportForDuty.Size = new System.Drawing.Size(750, 116);
            this.grpReportForDuty.TabIndex = 17;
            this.grpReportForDuty.Text = "Report For Duty";
            // 
            // OVRCommunicationForm
            // 
            this.ClientSize = new System.Drawing.Size(754, 583);
            this.Controls.Add(this.grpReportForDuty);
            this.Controls.Add(this.grpOfficialCom);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRCommunicationForm";
            this.Padding = new System.Windows.Forms.Padding(2);
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Communication Printing";
            ((System.ComponentModel.ISupportInitialize)(this.dgvCommunication)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvReportForDuty)).EndInit();
            this.grpOfficialCom.ResumeLayout(false);
            this.grpOfficialCom.PerformLayout();
            this.grpReportForDuty.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private UIDataGridView dgvCommunication;
        private UISymbolButton btnDel;
        private UISymbolButton btnEdit;
        private UISymbolButton btnAdd;
        private UIButton btnPreview;
        private UIButton btnPrintToPdf;
        private UICheckBox chbTest;
        private UICheckBox chbCorrected;
        private System.Windows.Forms.Label lbVersion;
        private System.Windows.Forms.Label lbRptType;
        private System.Windows.Forms.Label lbRscCode;
        private UITextBox tbVersion;
        private UITextBox tbRptType;
        private UITextBox tbRscCode;
        private UIDataGridView dgvReportForDuty;
        private UIButton btnPreviewDuty;
        private UIButton btnPrintToPdfDuty;
        private UIGroupBox grpOfficialCom;
        private UIGroupBox grpReportForDuty;
        private System.Windows.Forms.Label lbDisVersion;
        private UITextBox tbDisVersion;
    }
}