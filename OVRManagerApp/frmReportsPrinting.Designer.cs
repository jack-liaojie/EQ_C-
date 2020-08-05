using Sunny.UI;

namespace AutoSports.OVRManagerApp
{
    partial class OVRReportPrintingForm
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
            this.dgvReportsTpl = new Sunny.UI.UIDataGridView();
            this._TplName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._TplID = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._TplFullName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._TplType = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._TplRscQuery = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._TplVersion = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dgvReportsParam = new Sunny.UI.UIDataGridView();
            this._Parameters = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._ParamType = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._ParamValue = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this._ParamTypeName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.btnPreview = new Sunny.UI.UIButton();
            this.btnPrintToPdf = new Sunny.UI.UIButton();
            this.panelEx4 = new Sunny.UI.UIPanel();
            this.tbRptType = new Sunny.UI.UITextBox();
            this.chbGenerateDoc = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.lbDisVersion = new System.Windows.Forms.Label();
            this.tbDisVersion = new Sunny.UI.UITextBox();
            this.chbTest = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.chbCorrected = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.lbRptType = new System.Windows.Forms.Label();
            this.lbRscCode = new System.Windows.Forms.Label();
            this.tbVersion = new Sunny.UI.UITextBox();
            this.tbRscCode = new Sunny.UI.UITextBox();
            this.lbVersion = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.dgvReportsTpl)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvReportsParam)).BeginInit();
            this.panelEx4.SuspendLayout();
            this.SuspendLayout();
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
            // dgvReportsTpl
            // 
            this.dgvReportsTpl.AllowUserToAddRows = false;
            this.dgvReportsTpl.AllowUserToDeleteRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvReportsTpl.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvReportsTpl.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvReportsTpl.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.AllCells;
            this.dgvReportsTpl.BackgroundColor = System.Drawing.Color.White;
            this.dgvReportsTpl.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvReportsTpl.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvReportsTpl.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvReportsTpl.ColumnHeadersHeight = 32;
            this.dgvReportsTpl.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            this.dgvReportsTpl.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this._TplName,
            this._TplID,
            this._TplFullName,
            this._TplType,
            this._TplRscQuery,
            this._TplVersion});
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvReportsTpl.DefaultCellStyle = dataGridViewCellStyle3;
            this.dgvReportsTpl.EnableHeadersVisualStyles = false;
            this.dgvReportsTpl.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvReportsTpl.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvReportsTpl.Location = new System.Drawing.Point(4, 36);
            this.dgvReportsTpl.Margin = new System.Windows.Forms.Padding(4);
            this.dgvReportsTpl.MultiSelect = false;
            this.dgvReportsTpl.Name = "dgvReportsTpl";
            this.dgvReportsTpl.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvReportsTpl.RowHeadersVisible = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.White;
            this.dgvReportsTpl.RowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvReportsTpl.RowTemplate.Height = 29;
            this.dgvReportsTpl.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvReportsTpl.SelectedIndex = -1;
            this.dgvReportsTpl.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvReportsTpl.Size = new System.Drawing.Size(518, 215);
            this.dgvReportsTpl.TabIndex = 10;
            this.dgvReportsTpl.TagString = null;
            // 
            // _TplName
            // 
            this._TplName.DataPropertyName = "F_TplName";
            this._TplName.HeaderText = "Reports List";
            this._TplName.Name = "_TplName";
            this._TplName.ReadOnly = true;
            this._TplName.Width = 122;
            // 
            // _TplID
            // 
            this._TplID.DataPropertyName = "F_TplID";
            this._TplID.HeaderText = "TplID";
            this._TplID.Name = "_TplID";
            this._TplID.Visible = false;
            this._TplID.Width = 74;
            // 
            // _TplFullName
            // 
            this._TplFullName.DataPropertyName = "F_TplFullName";
            this._TplFullName.HeaderText = "TplFullName";
            this._TplFullName.Name = "_TplFullName";
            this._TplFullName.Visible = false;
            this._TplFullName.Width = 130;
            // 
            // _TplType
            // 
            this._TplType.DataPropertyName = "F_TplType";
            this._TplType.HeaderText = "Template Type";
            this._TplType.Name = "_TplType";
            this._TplType.Visible = false;
            this._TplType.Width = 146;
            // 
            // _TplRscQuery
            // 
            this._TplRscQuery.DataPropertyName = "F_TplRscQueryString";
            this._TplRscQuery.HeaderText = "RSC Query String";
            this._TplRscQuery.Name = "_TplRscQuery";
            this._TplRscQuery.Visible = false;
            this._TplRscQuery.Width = 165;
            // 
            // _TplVersion
            // 
            this._TplVersion.DataPropertyName = "F_TplVersion";
            this._TplVersion.HeaderText = "TplVersion";
            this._TplVersion.Name = "_TplVersion";
            this._TplVersion.Visible = false;
            this._TplVersion.Width = 114;
            // 
            // dgvReportsParam
            // 
            this.dgvReportsParam.AllowUserToAddRows = false;
            this.dgvReportsParam.AllowUserToDeleteRows = false;
            dataGridViewCellStyle5.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvReportsParam.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle5;
            this.dgvReportsParam.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvReportsParam.BackgroundColor = System.Drawing.Color.White;
            this.dgvReportsParam.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvReportsParam.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle6.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle6.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle6.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle6.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle6.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle6.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle6.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvReportsParam.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle6;
            this.dgvReportsParam.ColumnHeadersHeight = 32;
            this.dgvReportsParam.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            this.dgvReportsParam.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this._Parameters,
            this._ParamType,
            this._ParamValue,
            this._ParamTypeName});
            dataGridViewCellStyle7.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle7.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle7.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle7.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle7.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle7.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle7.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvReportsParam.DefaultCellStyle = dataGridViewCellStyle7;
            this.dgvReportsParam.EnableHeadersVisualStyles = false;
            this.dgvReportsParam.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvReportsParam.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvReportsParam.Location = new System.Drawing.Point(4, 257);
            this.dgvReportsParam.Margin = new System.Windows.Forms.Padding(4);
            this.dgvReportsParam.MultiSelect = false;
            this.dgvReportsParam.Name = "dgvReportsParam";
            this.dgvReportsParam.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvReportsParam.RowHeadersVisible = false;
            dataGridViewCellStyle8.BackColor = System.Drawing.Color.White;
            this.dgvReportsParam.RowsDefaultCellStyle = dataGridViewCellStyle8;
            this.dgvReportsParam.RowTemplate.Height = 29;
            this.dgvReportsParam.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvReportsParam.SelectedIndex = -1;
            this.dgvReportsParam.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvReportsParam.Size = new System.Drawing.Size(518, 215);
            this.dgvReportsParam.TabIndex = 11;
            this.dgvReportsParam.TagString = null;
            // 
            // _Parameters
            // 
            this._Parameters.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells;
            this._Parameters.DataPropertyName = "F_ParamAlias";
            this._Parameters.HeaderText = "Parameters";
            this._Parameters.MaxInputLength = 100;
            this._Parameters.Name = "_Parameters";
            this._Parameters.ReadOnly = true;
            this._Parameters.Width = 120;
            // 
            // _ParamType
            // 
            this._ParamType.DataPropertyName = "F_ParamType";
            this._ParamType.HeaderText = "Type";
            this._ParamType.MaxInputLength = 100;
            this._ParamType.Name = "_ParamType";
            this._ParamType.ReadOnly = true;
            this._ParamType.Visible = false;
            this._ParamType.Width = 70;
            // 
            // _ParamValue
            // 
            this._ParamValue.DataPropertyName = "F_ParamValue";
            this._ParamValue.HeaderText = "Value";
            this._ParamValue.Name = "_ParamValue";
            this._ParamValue.Width = 77;
            // 
            // _ParamTypeName
            // 
            this._ParamTypeName.DataPropertyName = "F_ParamTypeName";
            this._ParamTypeName.HeaderText = "ParamTypeName";
            this._ParamTypeName.Name = "_ParamTypeName";
            this._ParamTypeName.Visible = false;
            this._ParamTypeName.Width = 165;
            // 
            // btnPreview
            // 
            this.btnPreview.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnPreview.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnPreview.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnPreview.Location = new System.Drawing.Point(77, 488);
            this.btnPreview.Margin = new System.Windows.Forms.Padding(4);
            this.btnPreview.Name = "btnPreview";
            this.btnPreview.Size = new System.Drawing.Size(133, 38);
            this.btnPreview.TabIndex = 13;
            this.btnPreview.Text = "Preview";
            // 
            // btnPrintToPdf
            // 
            this.btnPrintToPdf.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnPrintToPdf.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnPrintToPdf.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnPrintToPdf.Location = new System.Drawing.Point(301, 488);
            this.btnPrintToPdf.Margin = new System.Windows.Forms.Padding(4);
            this.btnPrintToPdf.Name = "btnPrintToPdf";
            this.btnPrintToPdf.Size = new System.Drawing.Size(133, 38);
            this.btnPrintToPdf.TabIndex = 12;
            this.btnPrintToPdf.Text = "Generate";
            // 
            // panelEx4
            // 
            this.panelEx4.Controls.Add(this.tbRptType);
            this.panelEx4.Controls.Add(this.chbGenerateDoc);
            this.panelEx4.Controls.Add(this.lbDisVersion);
            this.panelEx4.Controls.Add(this.tbDisVersion);
            this.panelEx4.Controls.Add(this.chbTest);
            this.panelEx4.Controls.Add(this.chbCorrected);
            this.panelEx4.Controls.Add(this.lbRptType);
            this.panelEx4.Controls.Add(this.lbRscCode);
            this.panelEx4.Controls.Add(this.tbVersion);
            this.panelEx4.Controls.Add(this.tbRscCode);
            this.panelEx4.Controls.Add(this.lbVersion);
            this.panelEx4.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panelEx4.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.panelEx4.Location = new System.Drawing.Point(3, 535);
            this.panelEx4.Margin = new System.Windows.Forms.Padding(4);
            this.panelEx4.Name = "panelEx4";
            this.panelEx4.Size = new System.Drawing.Size(521, 131);
            this.panelEx4.TabIndex = 14;
            this.panelEx4.Text = null;
            // 
            // tbRptType
            // 
            this.tbRptType.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbRptType.FillColor = System.Drawing.Color.White;
            this.tbRptType.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbRptType.Location = new System.Drawing.Point(47, 39);
            this.tbRptType.Margin = new System.Windows.Forms.Padding(4);
            this.tbRptType.Maximum = 2147483647D;
            this.tbRptType.MaxLength = 20;
            this.tbRptType.Minimum = -2147483648D;
            this.tbRptType.Name = "tbRptType";
            this.tbRptType.Padding = new System.Windows.Forms.Padding(5);
            this.tbRptType.Size = new System.Drawing.Size(67, 29);
            this.tbRptType.TabIndex = 6;
            // 
            // chbGenerateDoc
            // 
            this.chbGenerateDoc.AutoSize = true;
            // 
            // 
            // 
            this.chbGenerateDoc.BackgroundStyle.Class = "";
            this.chbGenerateDoc.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.chbGenerateDoc.Location = new System.Drawing.Point(268, 71);
            this.chbGenerateDoc.Margin = new System.Windows.Forms.Padding(4);
            this.chbGenerateDoc.Name = "chbGenerateDoc";
            this.chbGenerateDoc.Size = new System.Drawing.Size(67, 26);
            this.chbGenerateDoc.TabIndex = 11;
            this.chbGenerateDoc.Text = "Docx";
            // 
            // lbDisVersion
            // 
            this.lbDisVersion.Location = new System.Drawing.Point(27, 87);
            this.lbDisVersion.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbDisVersion.Name = "lbDisVersion";
            this.lbDisVersion.Size = new System.Drawing.Size(159, 28);
            this.lbDisVersion.TabIndex = 10;
            this.lbDisVersion.Text = "Distrubuted VerSion";
            this.lbDisVersion.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // tbDisVersion
            // 
            this.tbDisVersion.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbDisVersion.FillColor = System.Drawing.Color.White;
            this.tbDisVersion.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbDisVersion.Location = new System.Drawing.Point(189, 86);
            this.tbDisVersion.Margin = new System.Windows.Forms.Padding(4);
            this.tbDisVersion.Maximum = 2147483647D;
            this.tbDisVersion.MaxLength = 10;
            this.tbDisVersion.Minimum = -2147483648D;
            this.tbDisVersion.Name = "tbDisVersion";
            this.tbDisVersion.Padding = new System.Windows.Forms.Padding(5);
            this.tbDisVersion.Size = new System.Drawing.Size(67, 29);
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
            this.chbTest.Location = new System.Drawing.Point(268, 39);
            this.chbTest.Margin = new System.Windows.Forms.Padding(4);
            this.chbTest.Name = "chbTest";
            this.chbTest.Size = new System.Drawing.Size(60, 26);
            this.chbTest.TabIndex = 8;
            this.chbTest.Text = "Test";
            // 
            // chbCorrected
            // 
            this.chbCorrected.AutoSize = true;
            // 
            // 
            // 
            this.chbCorrected.BackgroundStyle.Class = "";
            this.chbCorrected.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.chbCorrected.Location = new System.Drawing.Point(268, 10);
            this.chbCorrected.Margin = new System.Windows.Forms.Padding(4);
            this.chbCorrected.Name = "chbCorrected";
            this.chbCorrected.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.chbCorrected.Size = new System.Drawing.Size(106, 26);
            this.chbCorrected.TabIndex = 8;
            this.chbCorrected.Text = "Corrected";
            // 
            // lbRptType
            // 
            this.lbRptType.Location = new System.Drawing.Point(4, 39);
            this.lbRptType.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbRptType.Name = "lbRptType";
            this.lbRptType.Size = new System.Drawing.Size(67, 43);
            this.lbRptType.TabIndex = 7;
            this.lbRptType.Text = "Type";
            // 
            // lbRscCode
            // 
            this.lbRscCode.Location = new System.Drawing.Point(4, 6);
            this.lbRscCode.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbRscCode.Name = "lbRscCode";
            this.lbRscCode.Size = new System.Drawing.Size(40, 29);
            this.lbRscCode.TabIndex = 7;
            this.lbRscCode.Text = "RSC";
            // 
            // tbVersion
            // 
            this.tbVersion.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbVersion.FillColor = System.Drawing.Color.White;
            this.tbVersion.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbVersion.Location = new System.Drawing.Point(189, 46);
            this.tbVersion.Margin = new System.Windows.Forms.Padding(4);
            this.tbVersion.Maximum = 2147483647D;
            this.tbVersion.MaxLength = 10;
            this.tbVersion.Minimum = -2147483648D;
            this.tbVersion.Name = "tbVersion";
            this.tbVersion.Padding = new System.Windows.Forms.Padding(5);
            this.tbVersion.Size = new System.Drawing.Size(67, 29);
            this.tbVersion.TabIndex = 7;
            // 
            // tbRscCode
            // 
            this.tbRscCode.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbRscCode.FillColor = System.Drawing.Color.White;
            this.tbRscCode.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbRscCode.Location = new System.Drawing.Point(47, 6);
            this.tbRscCode.Margin = new System.Windows.Forms.Padding(4);
            this.tbRscCode.Maximum = 2147483647D;
            this.tbRscCode.Minimum = -2147483648D;
            this.tbRscCode.Name = "tbRscCode";
            this.tbRscCode.Padding = new System.Windows.Forms.Padding(5);
            this.tbRscCode.Size = new System.Drawing.Size(209, 29);
            this.tbRscCode.TabIndex = 5;
            // 
            // lbVersion
            // 
            this.lbVersion.Location = new System.Drawing.Point(96, 30);
            this.lbVersion.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbVersion.Name = "lbVersion";
            this.lbVersion.Size = new System.Drawing.Size(90, 48);
            this.lbVersion.TabIndex = 7;
            this.lbVersion.Text = "VerSion";
            this.lbVersion.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // OVRReportPrintingForm
            // 
            this.AllowDrop = true;
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(527, 668);
            this.Controls.Add(this.panelEx4);
            this.Controls.Add(this.btnPreview);
            this.Controls.Add(this.btnPrintToPdf);
            this.Controls.Add(this.dgvReportsParam);
            this.Controls.Add(this.dgvReportsTpl);
            this.Name = "OVRReportPrintingForm";
            this.Padding = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Reports Printing";
            this.Deactivate += new System.EventHandler(this.OVRReportPrintingForm_Deactivate);
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.OVRReportPrintingForm_FormClosing);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.OVRReportPrintingForm_FormClosed);
            this.VisibleChanged += new System.EventHandler(this.OVRReportPrintingForm_VisibleChanged);
            ((System.ComponentModel.ISupportInitialize)(this.dgvReportsTpl)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvReportsParam)).EndInit();
            this.panelEx4.ResumeLayout(false);
            this.panelEx4.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn2;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn3;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn4;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn5;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn6;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn7;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn8;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn9;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn10;
        private UIDataGridView dgvReportsTpl;
        private UIDataGridView dgvReportsParam;
        private UIButton btnPreview;
        private UIButton btnPrintToPdf;
        private UIPanel panelEx4;
        private UITextBox tbRptType;
        private DevComponents.DotNetBar.Controls.CheckBoxX chbGenerateDoc;
        private System.Windows.Forms.Label lbDisVersion;
        private UITextBox tbDisVersion;
        private DevComponents.DotNetBar.Controls.CheckBoxX chbTest;
        private DevComponents.DotNetBar.Controls.CheckBoxX chbCorrected;
        private System.Windows.Forms.Label lbRptType;
        private System.Windows.Forms.Label lbRscCode;
        private UITextBox tbVersion;
        private UITextBox tbRscCode;
        private System.Windows.Forms.Label lbVersion;
        private System.Windows.Forms.DataGridViewTextBoxColumn _TplName;
        private System.Windows.Forms.DataGridViewTextBoxColumn _TplID;
        private System.Windows.Forms.DataGridViewTextBoxColumn _TplFullName;
        private System.Windows.Forms.DataGridViewTextBoxColumn _TplType;
        private System.Windows.Forms.DataGridViewTextBoxColumn _TplRscQuery;
        private System.Windows.Forms.DataGridViewTextBoxColumn _TplVersion;
        private System.Windows.Forms.DataGridViewTextBoxColumn _Parameters;
        private System.Windows.Forms.DataGridViewTextBoxColumn _ParamType;
        private System.Windows.Forms.DataGridViewTextBoxColumn _ParamValue;
        private System.Windows.Forms.DataGridViewTextBoxColumn _ParamTypeName;
    }
}