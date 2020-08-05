using Sunny.UI;

namespace AutoSports.OVRCommon
{
    public partial class BatchReportsPrintingForm
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
            this.panelEx2 = new UIPanel();
            this.panelEx4 = new UIPanel();
            this.chbGenerateDoc = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.lbDisVersion = new System.Windows.Forms.Label();
            this.tbDisVersion = new UITextBox();
            this.chbTest = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.chbCorrected = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.lbVersion = new System.Windows.Forms.Label();
            this.lbRptType = new System.Windows.Forms.Label();
            this.lbRscCode = new System.Windows.Forms.Label();
            this.tbVersion = new UITextBox();
            this.tbRptType = new UITextBox();
            this.tbRscCode = new UITextBox();
            this.panelEx3 = new UIPanel();
            this.panel2 = new System.Windows.Forms.Panel();
            this.splitContainerTpl = new System.Windows.Forms.SplitContainer();
            this.dgvReportsTpl = new UIDataGridView();
            this._TplName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._TplID = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._TplFullName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._TplType = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._TplRscQuery = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._TplVersion = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dgvReportsParam = new UIDataGridView();
            this._Parameters = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._ParamType = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._ParamValue = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._ParamTypeName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.panel1 = new System.Windows.Forms.Panel();
            this.cbNoteType = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbNodeType = new System.Windows.Forms.Label();
            this.btnBatchPrintToPdf = new DevComponents.DotNetBar.ButtonX();
            this.dataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn2 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn3 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn4 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn5 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn6 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn7 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn8 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn9 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn10 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.panelEx2.SuspendLayout();
            this.panelEx4.SuspendLayout();
            this.panelEx3.SuspendLayout();
            this.panel2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainerTpl)).BeginInit();
            this.splitContainerTpl.Panel1.SuspendLayout();
            this.splitContainerTpl.Panel2.SuspendLayout();
            this.splitContainerTpl.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvReportsTpl)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvReportsParam)).BeginInit();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // panelEx2
            // 
            this.panelEx2.Controls.Add(this.panelEx4);
            this.panelEx2.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panelEx2.Location = new System.Drawing.Point(2, 352);
            this.panelEx2.Name = "panelEx2";
            this.panelEx2.Padding = new System.Windows.Forms.Padding(0, 5, 0, 0);
            this.panelEx2.Size = new System.Drawing.Size(326, 89);
            this.panelEx2.TabIndex = 8;
            // 
            // panelEx4
            // 
            this.panelEx4.Controls.Add(this.chbGenerateDoc);
            this.panelEx4.Controls.Add(this.lbDisVersion);
            this.panelEx4.Controls.Add(this.tbDisVersion);
            this.panelEx4.Controls.Add(this.chbTest);
            this.panelEx4.Controls.Add(this.chbCorrected);
            this.panelEx4.Controls.Add(this.lbVersion);
            this.panelEx4.Controls.Add(this.lbRptType);
            this.panelEx4.Controls.Add(this.lbRscCode);
            this.panelEx4.Controls.Add(this.tbVersion);
            this.panelEx4.Controls.Add(this.tbRptType);
            this.panelEx4.Controls.Add(this.tbRscCode);
            this.panelEx4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelEx4.Location = new System.Drawing.Point(0, 5);
            this.panelEx4.Name = "panelEx4";
            this.panelEx4.Size = new System.Drawing.Size(326, 84);
            this.panelEx4.TabIndex = 8;
            // 
            // chbGenerateDoc
            // 
            this.chbGenerateDoc.AutoSize = true;
            // 
            // 
            // 
            this.chbGenerateDoc.BackgroundStyle.Class = "";
            this.chbGenerateDoc.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.chbGenerateDoc.Location = new System.Drawing.Point(201, 57);
            this.chbGenerateDoc.Name = "chbGenerateDoc";
            this.chbGenerateDoc.Size = new System.Drawing.Size(51, 16);
            this.chbGenerateDoc.TabIndex = 11;
            this.chbGenerateDoc.Text = "Docx";
            // 
            // lbDisVersion
            // 
            this.lbDisVersion.Location = new System.Drawing.Point(20, 62);
            this.lbDisVersion.Name = "lbDisVersion";
            this.lbDisVersion.Size = new System.Drawing.Size(119, 12);
            this.lbDisVersion.TabIndex = 10;
            this.lbDisVersion.Text = "Distrubuted VerSion";
            this.lbDisVersion.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // tbDisVersion
            // 
            // 
            // 
            // 
            this.tbDisVersion.Location = new System.Drawing.Point(142, 57);
            this.tbDisVersion.MaxLength = 10;
            this.tbDisVersion.Name = "tbDisVersion";
            this.tbDisVersion.Size = new System.Drawing.Size(50, 21);
            this.tbDisVersion.TabIndex = 9;
            // 
            // chbTest
            // 
            this.chbTest.AutoSize = true;
            // 
            // 
            // 
            this.chbTest.BackgroundStyle.Class = "";
            this.chbTest.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.chbTest.Location = new System.Drawing.Point(201, 31);
            this.chbTest.Name = "chbTest";
            this.chbTest.Size = new System.Drawing.Size(51, 16);
            this.chbTest.TabIndex = 8;
            this.chbTest.Text = "Test";
            this.chbTest.CheckedChanged += new System.EventHandler(this.chbTest_CheckedChanged);
            // 
            // chbCorrected
            // 
            this.chbCorrected.AutoSize = true;
            // 
            // 
            // 
            this.chbCorrected.BackgroundStyle.Class = "";
            this.chbCorrected.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.chbCorrected.Location = new System.Drawing.Point(201, 8);
            this.chbCorrected.Name = "chbCorrected";
            this.chbCorrected.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.chbCorrected.Size = new System.Drawing.Size(82, 16);
            this.chbCorrected.TabIndex = 8;
            this.chbCorrected.Text = "Corrected";
            this.chbCorrected.CheckedChanged += new System.EventHandler(this.chbCorrect_CheckedChanged);
            // 
            // lbVersion
            // 
            this.lbVersion.Location = new System.Drawing.Point(89, 36);
            this.lbVersion.Name = "lbVersion";
            this.lbVersion.Size = new System.Drawing.Size(50, 12);
            this.lbVersion.TabIndex = 7;
            this.lbVersion.Text = "VerSion";
            this.lbVersion.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbRptType
            // 
            this.lbRptType.Location = new System.Drawing.Point(3, 35);
            this.lbRptType.Name = "lbRptType";
            this.lbRptType.Size = new System.Drawing.Size(30, 12);
            this.lbRptType.TabIndex = 7;
            this.lbRptType.Text = "Type";
            // 
            // lbRscCode
            // 
            this.lbRscCode.Location = new System.Drawing.Point(3, 9);
            this.lbRscCode.Name = "lbRscCode";
            this.lbRscCode.Size = new System.Drawing.Size(30, 12);
            this.lbRscCode.TabIndex = 7;
            this.lbRscCode.Text = "RSC";
            // 
            // tbVersion
            // 
            // 
            // 
            // 
            this.tbVersion.Location = new System.Drawing.Point(142, 31);
            this.tbVersion.MaxLength = 10;
            this.tbVersion.Name = "tbVersion";
            this.tbVersion.Size = new System.Drawing.Size(50, 21);
            this.tbVersion.TabIndex = 7;
            // 
            // tbRptType
            // 
            // 
            // 
            // 
            this.tbRptType.Location = new System.Drawing.Point(35, 31);
            this.tbRptType.MaxLength = 20;
            this.tbRptType.Name = "tbRptType";
            this.tbRptType.Size = new System.Drawing.Size(50, 21);
            this.tbRptType.TabIndex = 6;
            // 
            // tbRscCode
            // 
            // 
            // 
            // 
            this.tbRscCode.Location = new System.Drawing.Point(35, 5);
            this.tbRscCode.Name = "tbRscCode";
            this.tbRscCode.Size = new System.Drawing.Size(157, 21);
            this.tbRscCode.TabIndex = 5;
            // 
            // panelEx3
            // 
            this.panelEx3.Controls.Add(this.panel2);
            this.panelEx3.Controls.Add(this.panel1);
            this.panelEx3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelEx3.Location = new System.Drawing.Point(2, 2);
            this.panelEx3.Name = "panelEx3";
            this.panelEx3.Padding = new System.Windows.Forms.Padding(5);
            this.panelEx3.Size = new System.Drawing.Size(326, 350);
            this.panelEx3.TabIndex = 8;
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.splitContainerTpl);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel2.Location = new System.Drawing.Point(5, 5);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(316, 305);
            this.panel2.TabIndex = 6;
            // 
            // splitContainerTpl
            // 
            this.splitContainerTpl.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainerTpl.Location = new System.Drawing.Point(0, 0);
            this.splitContainerTpl.Name = "splitContainerTpl";
            this.splitContainerTpl.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainerTpl.Panel1
            // 
            this.splitContainerTpl.Panel1.Controls.Add(this.dgvReportsTpl);
            // 
            // splitContainerTpl.Panel2
            // 
            this.splitContainerTpl.Panel2.Controls.Add(this.dgvReportsParam);
            this.splitContainerTpl.Size = new System.Drawing.Size(316, 305);
            this.splitContainerTpl.SplitterDistance = 153;
            this.splitContainerTpl.TabIndex = 5;
            // 
            // dgvReportsTpl
            // 
            this.dgvReportsTpl.AllowUserToAddRows = false;
            this.dgvReportsTpl.AllowUserToDeleteRows = false;
            this.dgvReportsTpl.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvReportsTpl.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvReportsTpl.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this._TplName,
            this._TplID,
            this._TplFullName,
            this._TplType,
            this._TplRscQuery,
            this._TplVersion});
            this.dgvReportsTpl.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvReportsTpl.Location = new System.Drawing.Point(0, 0);
            this.dgvReportsTpl.MultiSelect = false;
            this.dgvReportsTpl.Name = "dgvReportsTpl";
            this.dgvReportsTpl.RowHeadersVisible = false;
            this.dgvReportsTpl.RowTemplate.Height = 23;
            this.dgvReportsTpl.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvReportsTpl.Size = new System.Drawing.Size(316, 153);
            this.dgvReportsTpl.TabIndex = 1;
            this.dgvReportsTpl.SelectionChanged += new System.EventHandler(this.dgvReportsTpl_SelectionChanged);
            // 
            // _TplName
            // 
            this._TplName.DataPropertyName = "F_TplName";
            this._TplName.HeaderText = "Reports List";
            this._TplName.Name = "_TplName";
            this._TplName.ReadOnly = true;
            // 
            // _TplID
            // 
            this._TplID.DataPropertyName = "F_TplID";
            this._TplID.HeaderText = "TplID";
            this._TplID.Name = "_TplID";
            this._TplID.Visible = false;
            // 
            // _TplFullName
            // 
            this._TplFullName.DataPropertyName = "F_TplFullName";
            this._TplFullName.HeaderText = "TplFullName";
            this._TplFullName.Name = "_TplFullName";
            this._TplFullName.Visible = false;
            // 
            // _TplType
            // 
            this._TplType.DataPropertyName = "F_TplType";
            this._TplType.HeaderText = "Template Type";
            this._TplType.Name = "_TplType";
            this._TplType.Visible = false;
            // 
            // _TplRscQuery
            // 
            this._TplRscQuery.DataPropertyName = "F_TplRscQueryString";
            this._TplRscQuery.HeaderText = "RSC Query String";
            this._TplRscQuery.Name = "_TplRscQuery";
            this._TplRscQuery.Visible = false;
            // 
            // _TplVersion
            // 
            this._TplVersion.DataPropertyName = "F_TplVersion";
            this._TplVersion.HeaderText = "TplVersion";
            this._TplVersion.Name = "_TplVersion";
            this._TplVersion.Visible = false;
            // 
            // dgvReportsParam
            // 
            this.dgvReportsParam.AllowUserToAddRows = false;
            this.dgvReportsParam.AllowUserToDeleteRows = false;
            this.dgvReportsParam.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvReportsParam.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvReportsParam.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this._Parameters,
            this._ParamType,
            this._ParamValue,
            this._ParamTypeName});
            this.dgvReportsParam.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvReportsParam.Location = new System.Drawing.Point(0, 0);
            this.dgvReportsParam.MultiSelect = false;
            this.dgvReportsParam.Name = "dgvReportsParam";
            this.dgvReportsParam.RowHeadersVisible = false;
            this.dgvReportsParam.RowTemplate.Height = 23;
            this.dgvReportsParam.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvReportsParam.Size = new System.Drawing.Size(316, 148);
            this.dgvReportsParam.TabIndex = 2;
            this.dgvReportsParam.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvReportsParam_CellEndEdit);
            this.dgvReportsParam.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgvReportsParam_CellValidating);
            // 
            // _Parameters
            // 
            this._Parameters.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells;
            this._Parameters.DataPropertyName = "F_ParamAlias";
            this._Parameters.HeaderText = "Parameters";
            this._Parameters.MaxInputLength = 100;
            this._Parameters.Name = "_Parameters";
            this._Parameters.ReadOnly = true;
            this._Parameters.Width = 90;
            // 
            // _ParamType
            // 
            this._ParamType.DataPropertyName = "F_ParamType";
            this._ParamType.HeaderText = "Type";
            this._ParamType.MaxInputLength = 100;
            this._ParamType.Name = "_ParamType";
            this._ParamType.ReadOnly = true;
            this._ParamType.Visible = false;
            // 
            // _ParamValue
            // 
            this._ParamValue.DataPropertyName = "F_ParamValue";
            this._ParamValue.HeaderText = "Value";
            this._ParamValue.Name = "_ParamValue";
            // 
            // _ParamTypeName
            // 
            this._ParamTypeName.DataPropertyName = "F_ParamTypeName";
            this._ParamTypeName.HeaderText = "ParamTypeName";
            this._ParamTypeName.Name = "_ParamTypeName";
            this._ParamTypeName.Visible = false;
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.cbNoteType);
            this.panel1.Controls.Add(this.lbNodeType);
            this.panel1.Controls.Add(this.btnBatchPrintToPdf);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel1.Location = new System.Drawing.Point(5, 310);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(316, 35);
            this.panel1.TabIndex = 6;
            // 
            // cbNoteType
            // 
            this.cbNoteType.DisplayMember = "Text";
            this.cbNoteType.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbNoteType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbNoteType.FormattingEnabled = true;
            this.cbNoteType.ItemHeight = 15;
            this.cbNoteType.Location = new System.Drawing.Point(66, 7);
            this.cbNoteType.Name = "cbNoteType";
            this.cbNoteType.Size = new System.Drawing.Size(115, 21);
            this.cbNoteType.TabIndex = 46;
            // 
            // lbNodeType
            // 
            this.lbNodeType.Location = new System.Drawing.Point(3, 12);
            this.lbNodeType.Name = "lbNodeType";
            this.lbNodeType.Size = new System.Drawing.Size(60, 12);
            this.lbNodeType.TabIndex = 8;
            this.lbNodeType.Text = "NodeType";
            // 
            // btnBatchPrintToPdf
            // 
            this.btnBatchPrintToPdf.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnBatchPrintToPdf.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnBatchPrintToPdf.Location = new System.Drawing.Point(206, 2);
            this.btnBatchPrintToPdf.Name = "btnBatchPrintToPdf";
            this.btnBatchPrintToPdf.Size = new System.Drawing.Size(100, 30);
            this.btnBatchPrintToPdf.TabIndex = 5;
            this.btnBatchPrintToPdf.Text = "Batch Generate";
            this.btnBatchPrintToPdf.Tooltip = "Alt + G";
            this.btnBatchPrintToPdf.Click += new System.EventHandler(this.btnBatchPrintToPdf_Click);
            // 
            // dataGridViewTextBoxColumn1
            // 
            this.dataGridViewTextBoxColumn1.DataPropertyName = "F_TplName";
            this.dataGridViewTextBoxColumn1.HeaderText = "Reports List";
            this.dataGridViewTextBoxColumn1.Name = "dataGridViewTextBoxColumn1";
            this.dataGridViewTextBoxColumn1.ReadOnly = true;
            this.dataGridViewTextBoxColumn1.Width = 401;
            // 
            // dataGridViewTextBoxColumn2
            // 
            this.dataGridViewTextBoxColumn2.DataPropertyName = "F_ParamName";
            this.dataGridViewTextBoxColumn2.HeaderText = "Parameters";
            this.dataGridViewTextBoxColumn2.MaxInputLength = 100;
            this.dataGridViewTextBoxColumn2.Name = "dataGridViewTextBoxColumn2";
            this.dataGridViewTextBoxColumn2.ReadOnly = true;
            this.dataGridViewTextBoxColumn2.Visible = false;
            this.dataGridViewTextBoxColumn2.Width = 134;
            // 
            // dataGridViewTextBoxColumn3
            // 
            this.dataGridViewTextBoxColumn3.DataPropertyName = "F_ParamType";
            this.dataGridViewTextBoxColumn3.HeaderText = "Type";
            this.dataGridViewTextBoxColumn3.MaxInputLength = 100;
            this.dataGridViewTextBoxColumn3.Name = "dataGridViewTextBoxColumn3";
            this.dataGridViewTextBoxColumn3.ReadOnly = true;
            this.dataGridViewTextBoxColumn3.Visible = false;
            this.dataGridViewTextBoxColumn3.Width = 133;
            // 
            // dataGridViewTextBoxColumn4
            // 
            this.dataGridViewTextBoxColumn4.DataPropertyName = "F_ParamValue";
            this.dataGridViewTextBoxColumn4.HeaderText = "Value";
            this.dataGridViewTextBoxColumn4.Name = "dataGridViewTextBoxColumn4";
            this.dataGridViewTextBoxColumn4.Visible = false;
            this.dataGridViewTextBoxColumn4.Width = 134;
            // 
            // dataGridViewTextBoxColumn5
            // 
            this.dataGridViewTextBoxColumn5.DataPropertyName = "F_TplRscQueryString";
            this.dataGridViewTextBoxColumn5.HeaderText = "RSC Query String";
            this.dataGridViewTextBoxColumn5.Name = "dataGridViewTextBoxColumn5";
            this.dataGridViewTextBoxColumn5.Visible = false;
            // 
            // dataGridViewTextBoxColumn6
            // 
            this.dataGridViewTextBoxColumn6.DataPropertyName = "F_TplVersion";
            this.dataGridViewTextBoxColumn6.HeaderText = "TplVersion";
            this.dataGridViewTextBoxColumn6.Name = "dataGridViewTextBoxColumn6";
            this.dataGridViewTextBoxColumn6.Visible = false;
            // 
            // dataGridViewTextBoxColumn7
            // 
            this.dataGridViewTextBoxColumn7.DataPropertyName = "F_ParamAlias";
            this.dataGridViewTextBoxColumn7.HeaderText = "Parameters";
            this.dataGridViewTextBoxColumn7.MaxInputLength = 100;
            this.dataGridViewTextBoxColumn7.Name = "dataGridViewTextBoxColumn7";
            this.dataGridViewTextBoxColumn7.ReadOnly = true;
            this.dataGridViewTextBoxColumn7.Width = 133;
            // 
            // dataGridViewTextBoxColumn8
            // 
            this.dataGridViewTextBoxColumn8.DataPropertyName = "F_ParamType";
            this.dataGridViewTextBoxColumn8.HeaderText = "Type";
            this.dataGridViewTextBoxColumn8.MaxInputLength = 100;
            this.dataGridViewTextBoxColumn8.Name = "dataGridViewTextBoxColumn8";
            this.dataGridViewTextBoxColumn8.ReadOnly = true;
            this.dataGridViewTextBoxColumn8.Visible = false;
            // 
            // dataGridViewTextBoxColumn9
            // 
            this.dataGridViewTextBoxColumn9.DataPropertyName = "F_ParamValue";
            this.dataGridViewTextBoxColumn9.HeaderText = "Value";
            this.dataGridViewTextBoxColumn9.Name = "dataGridViewTextBoxColumn9";
            this.dataGridViewTextBoxColumn9.Width = 132;
            // 
            // dataGridViewTextBoxColumn10
            // 
            this.dataGridViewTextBoxColumn10.DataPropertyName = "F_ParamTypeName";
            this.dataGridViewTextBoxColumn10.HeaderText = "ParamTypeName";
            this.dataGridViewTextBoxColumn10.Name = "dataGridViewTextBoxColumn10";
            this.dataGridViewTextBoxColumn10.Visible = false;
            // 
            // BatchReportsPrintingForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(330, 443);
            this.Controls.Add(this.panelEx3);
            this.Controls.Add(this.panelEx2);
            this.MaximizeBox = false;
            this.MaximumSize = new System.Drawing.Size(400, 599);
            this.MinimizeBox = false;
            this.MinimumSize = new System.Drawing.Size(300, 299);
            this.Name = "BatchReportsPrintingForm";
            this.Padding = new System.Windows.Forms.Padding(2);
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Reports Printing";
            this.Deactivate += new System.EventHandler(this.OVRReportPrintingForm_Deactivate);
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.OVRReportPrintingForm_FormClosing);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.OVRReportPrintingForm_FormClosed);
            this.Load += new System.EventHandler(this.OVRReportPrintingForm_Load);
            this.VisibleChanged += new System.EventHandler(this.OVRReportPrintingForm_VisibleChanged);
            this.panelEx2.ResumeLayout(false);
            this.panelEx4.ResumeLayout(false);
            this.panelEx4.PerformLayout();
            this.panelEx3.ResumeLayout(false);
            this.panel2.ResumeLayout(false);
            this.splitContainerTpl.Panel1.ResumeLayout(false);
            this.splitContainerTpl.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainerTpl)).EndInit();
            this.splitContainerTpl.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvReportsTpl)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvReportsParam)).EndInit();
            this.panel1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private UIDataGridView dgvReportsTpl;
        private UIDataGridView dgvReportsParam;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn2;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn3;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn4;
        private System.Windows.Forms.Label lbVersion;
        private System.Windows.Forms.Label lbRptType;
        private System.Windows.Forms.Label lbRscCode;
        private UITextBox tbRptType;
        private UITextBox tbRscCode;
        private UITextBox tbVersion;
        private System.Windows.Forms.DataGridViewTextBoxColumn _TplName;
        private System.Windows.Forms.DataGridViewTextBoxColumn _TplID;
        private System.Windows.Forms.DataGridViewTextBoxColumn _TplFullName;
        private System.Windows.Forms.DataGridViewTextBoxColumn _TplType;
        private System.Windows.Forms.DataGridViewTextBoxColumn _TplRscQuery;
        private System.Windows.Forms.DataGridViewTextBoxColumn _TplVersion;
        private System.Windows.Forms.SplitContainer splitContainerTpl;
        private DevComponents.DotNetBar.Controls.CheckBoxX chbCorrected;
        private DevComponents.DotNetBar.Controls.CheckBoxX chbTest;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn5;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn6;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn7;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn8;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn9;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn10;
        private System.Windows.Forms.DataGridViewTextBoxColumn _Parameters;
        private System.Windows.Forms.DataGridViewTextBoxColumn _ParamType;
        private System.Windows.Forms.DataGridViewTextBoxColumn _ParamValue;
        private System.Windows.Forms.DataGridViewTextBoxColumn _ParamTypeName;
        private System.Windows.Forms.Label lbDisVersion;
        private UITextBox tbDisVersion;
        private DevComponents.DotNetBar.Controls.CheckBoxX chbGenerateDoc;
        private UIPanel panelEx2;
        private UIPanel panelEx4;
        private UIPanel panelEx3;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Panel panel1;
        private DevComponents.DotNetBar.ButtonX btnBatchPrintToPdf;
        private System.Windows.Forms.Label lbNodeType;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbNoteType;

    }
}