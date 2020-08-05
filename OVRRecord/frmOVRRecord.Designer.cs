using Sunny.UI;

namespace AutoSports.OVRRecord
{
    partial class OVRRecordForm
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
            this.components = new System.ComponentModel.Container();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle5 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle7 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle8 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle9 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle10 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle11 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle12 = new System.Windows.Forms.DataGridViewCellStyle();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.lb_EventList = new Sunny.UI.UILabel();
            this.dgv_Events = new Sunny.UI.UIDataGridView();
            this.splitContainer2 = new System.Windows.Forms.SplitContainer();
            this.btn_ImportRecord = new Sunny.UI.UIButton();
            this.btn_DelRecord = new Sunny.UI.UIButton();
            this.btn_ExportRecord = new Sunny.UI.UIButton();
            this.btn_AddRecord = new Sunny.UI.UIButton();
            this.dgvEventRecords = new Sunny.UI.UIDataGridView();
            this.SetRecordRegisterMenuStrip = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.MenuSetRegister = new System.Windows.Forms.ToolStripMenuItem();
            this.lb_RecordsList = new Sunny.UI.UILabel();
            this.splitContainer3 = new System.Windows.Forms.SplitContainer();
            this.btnRecordValueDel = new Sunny.UI.UISymbolButton();
            this.btnRecordValueNew = new Sunny.UI.UISymbolButton();
            this.dgvRecordValue = new Sunny.UI.UIDataGridView();
            this.lb_RecordValues = new Sunny.UI.UILabel();
            this.dgvRecordMember = new Sunny.UI.UIDataGridView();
            this.lb_RecordMember = new Sunny.UI.UILabel();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Events)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer2)).BeginInit();
            this.splitContainer2.Panel1.SuspendLayout();
            this.splitContainer2.Panel2.SuspendLayout();
            this.splitContainer2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvEventRecords)).BeginInit();
            this.SetRecordRegisterMenuStrip.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer3)).BeginInit();
            this.splitContainer3.Panel1.SuspendLayout();
            this.splitContainer3.Panel2.SuspendLayout();
            this.splitContainer3.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvRecordValue)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvRecordMember)).BeginInit();
            this.SuspendLayout();
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(0, 0);
            this.splitContainer1.Name = "splitContainer1";
            this.splitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.lb_EventList);
            this.splitContainer1.Panel1.Controls.Add(this.dgv_Events);
            this.splitContainer1.Panel1.Padding = new System.Windows.Forms.Padding(150, 0, 0, 0);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.splitContainer2);
            this.splitContainer1.Size = new System.Drawing.Size(745, 447);
            this.splitContainer1.SplitterDistance = 133;
            this.splitContainer1.TabIndex = 0;
            // 
            // lb_EventList
            // 
            this.lb_EventList.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lb_EventList.Location = new System.Drawing.Point(3, 12);
            this.lb_EventList.Name = "lb_EventList";
            this.lb_EventList.Size = new System.Drawing.Size(88, 23);
            this.lb_EventList.Style = Sunny.UI.UIStyle.Custom;
            this.lb_EventList.TabIndex = 6;
            this.lb_EventList.Text = "Events List:";
            this.lb_EventList.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // dgv_Events
            // 
            this.dgv_Events.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgv_Events.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgv_Events.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgv_Events.BackgroundColor = System.Drawing.Color.White;
            this.dgv_Events.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgv_Events.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgv_Events.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgv_Events.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_Events.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgv_Events.EnableHeadersVisualStyles = false;
            this.dgv_Events.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgv_Events.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgv_Events.Location = new System.Drawing.Point(150, 0);
            this.dgv_Events.Name = "dgv_Events";
            this.dgv_Events.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgv_Events.RowHeadersVisible = false;
            dataGridViewCellStyle3.BackColor = System.Drawing.Color.White;
            this.dgv_Events.RowsDefaultCellStyle = dataGridViewCellStyle3;
            this.dgv_Events.RowTemplate.Height = 29;
            this.dgv_Events.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgv_Events.SelectedIndex = -1;
            this.dgv_Events.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgv_Events.Size = new System.Drawing.Size(595, 133);
            this.dgv_Events.Style = Sunny.UI.UIStyle.Custom;
            this.dgv_Events.TabIndex = 0;
            this.dgv_Events.TagString = null;
            this.dgv_Events.SelectionChanged += new System.EventHandler(this.dgv_Events_SelectionChanged);
            // 
            // splitContainer2
            // 
            this.splitContainer2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer2.Location = new System.Drawing.Point(0, 0);
            this.splitContainer2.Name = "splitContainer2";
            this.splitContainer2.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainer2.Panel1
            // 
            this.splitContainer2.Panel1.Controls.Add(this.btn_ImportRecord);
            this.splitContainer2.Panel1.Controls.Add(this.btn_DelRecord);
            this.splitContainer2.Panel1.Controls.Add(this.btn_ExportRecord);
            this.splitContainer2.Panel1.Controls.Add(this.btn_AddRecord);
            this.splitContainer2.Panel1.Controls.Add(this.dgvEventRecords);
            this.splitContainer2.Panel1.Controls.Add(this.lb_RecordsList);
            this.splitContainer2.Panel1.Padding = new System.Windows.Forms.Padding(0, 40, 0, 0);
            // 
            // splitContainer2.Panel2
            // 
            this.splitContainer2.Panel2.Controls.Add(this.splitContainer3);
            this.splitContainer2.Size = new System.Drawing.Size(745, 310);
            this.splitContainer2.SplitterDistance = 155;
            this.splitContainer2.TabIndex = 10;
            // 
            // btn_ImportRecord
            // 
            this.btn_ImportRecord.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_ImportRecord.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btn_ImportRecord.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btn_ImportRecord.ForeColor = System.Drawing.SystemColors.ControlText;
            this.btn_ImportRecord.ForeDisableColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(255)))));
            this.btn_ImportRecord.Location = new System.Drawing.Point(599, 10);
            this.btn_ImportRecord.Name = "btn_ImportRecord";
            this.btn_ImportRecord.Size = new System.Drawing.Size(133, 23);
            this.btn_ImportRecord.Style = Sunny.UI.UIStyle.Custom;
            this.btn_ImportRecord.TabIndex = 8;
            this.btn_ImportRecord.Text = "Import Record";
            this.btn_ImportRecord.Click += new System.EventHandler(this.btn_ImportRecord_Click);
            // 
            // btn_DelRecord
            // 
            this.btn_DelRecord.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_DelRecord.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btn_DelRecord.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btn_DelRecord.ForeDisableColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(255)))));
            this.btn_DelRecord.Location = new System.Drawing.Point(289, 10);
            this.btn_DelRecord.Name = "btn_DelRecord";
            this.btn_DelRecord.Size = new System.Drawing.Size(133, 23);
            this.btn_DelRecord.Style = Sunny.UI.UIStyle.Custom;
            this.btn_DelRecord.TabIndex = 7;
            this.btn_DelRecord.Text = "Delete Record";
            this.btn_DelRecord.Click += new System.EventHandler(this.btn_DelRecord_Click);
            // 
            // btn_ExportRecord
            // 
            this.btn_ExportRecord.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_ExportRecord.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btn_ExportRecord.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btn_ExportRecord.ForeColor = System.Drawing.SystemColors.ControlText;
            this.btn_ExportRecord.ForeDisableColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(255)))));
            this.btn_ExportRecord.Location = new System.Drawing.Point(444, 10);
            this.btn_ExportRecord.Name = "btn_ExportRecord";
            this.btn_ExportRecord.Size = new System.Drawing.Size(133, 23);
            this.btn_ExportRecord.Style = Sunny.UI.UIStyle.Custom;
            this.btn_ExportRecord.TabIndex = 9;
            this.btn_ExportRecord.Text = "Export Record";
            this.btn_ExportRecord.Click += new System.EventHandler(this.btn_ExportRecord_Click);
            // 
            // btn_AddRecord
            // 
            this.btn_AddRecord.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_AddRecord.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btn_AddRecord.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btn_AddRecord.ForeDisableColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(255)))));
            this.btn_AddRecord.Location = new System.Drawing.Point(134, 10);
            this.btn_AddRecord.Name = "btn_AddRecord";
            this.btn_AddRecord.Size = new System.Drawing.Size(133, 23);
            this.btn_AddRecord.Style = Sunny.UI.UIStyle.Custom;
            this.btn_AddRecord.TabIndex = 6;
            this.btn_AddRecord.Text = "Add Record";
            this.btn_AddRecord.Click += new System.EventHandler(this.btn_AddRecord_Click);
            // 
            // dgvEventRecords
            // 
            this.dgvEventRecords.AllowUserToAddRows = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvEventRecords.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvEventRecords.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvEventRecords.BackgroundColor = System.Drawing.Color.White;
            this.dgvEventRecords.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvEventRecords.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle5.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle5.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle5.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle5.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle5.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle5.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle5.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvEventRecords.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle5;
            this.dgvEventRecords.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvEventRecords.ContextMenuStrip = this.SetRecordRegisterMenuStrip;
            this.dgvEventRecords.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvEventRecords.EnableHeadersVisualStyles = false;
            this.dgvEventRecords.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvEventRecords.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvEventRecords.Location = new System.Drawing.Point(0, 40);
            this.dgvEventRecords.Name = "dgvEventRecords";
            this.dgvEventRecords.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvEventRecords.RowHeadersVisible = false;
            dataGridViewCellStyle6.BackColor = System.Drawing.Color.White;
            this.dgvEventRecords.RowsDefaultCellStyle = dataGridViewCellStyle6;
            this.dgvEventRecords.RowTemplate.Height = 29;
            this.dgvEventRecords.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvEventRecords.SelectedIndex = -1;
            this.dgvEventRecords.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvEventRecords.Size = new System.Drawing.Size(745, 115);
            this.dgvEventRecords.Style = Sunny.UI.UIStyle.Custom;
            this.dgvEventRecords.TabIndex = 1;
            this.dgvEventRecords.TagString = null;
            this.dgvEventRecords.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvEventRecords_CellBeginEdit);
            this.dgvEventRecords.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvEventRecords_CellContentClick);
            this.dgvEventRecords.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvEventRecords_CellValueChanged);
            this.dgvEventRecords.SelectionChanged += new System.EventHandler(this.dgvEventRecords_SelectionChanged);
            // 
            // SetRecordRegisterMenuStrip
            // 
            this.SetRecordRegisterMenuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.MenuSetRegister});
            this.SetRecordRegisterMenuStrip.Name = "contextMenuStrip1";
            this.SetRecordRegisterMenuStrip.Size = new System.Drawing.Size(147, 26);
            // 
            // MenuSetRegister
            // 
            this.MenuSetRegister.Name = "MenuSetRegister";
            this.MenuSetRegister.Size = new System.Drawing.Size(146, 22);
            this.MenuSetRegister.Text = "Set Register";
            this.MenuSetRegister.Click += new System.EventHandler(this.MenuSetRegister_Click);
            // 
            // lb_RecordsList
            // 
            this.lb_RecordsList.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lb_RecordsList.Location = new System.Drawing.Point(3, 10);
            this.lb_RecordsList.Name = "lb_RecordsList";
            this.lb_RecordsList.Size = new System.Drawing.Size(88, 23);
            this.lb_RecordsList.Style = Sunny.UI.UIStyle.Custom;
            this.lb_RecordsList.TabIndex = 5;
            this.lb_RecordsList.Text = "Record List:";
            this.lb_RecordsList.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // splitContainer3
            // 
            this.splitContainer3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer3.Location = new System.Drawing.Point(0, 0);
            this.splitContainer3.Name = "splitContainer3";
            // 
            // splitContainer3.Panel1
            // 
            this.splitContainer3.Panel1.Controls.Add(this.btnRecordValueDel);
            this.splitContainer3.Panel1.Controls.Add(this.btnRecordValueNew);
            this.splitContainer3.Panel1.Controls.Add(this.dgvRecordValue);
            this.splitContainer3.Panel1.Controls.Add(this.lb_RecordValues);
            this.splitContainer3.Panel1.Padding = new System.Windows.Forms.Padding(0, 30, 0, 0);
            // 
            // splitContainer3.Panel2
            // 
            this.splitContainer3.Panel2.Controls.Add(this.dgvRecordMember);
            this.splitContainer3.Panel2.Controls.Add(this.lb_RecordMember);
            this.splitContainer3.Panel2.Padding = new System.Windows.Forms.Padding(0, 30, 0, 0);
            this.splitContainer3.Size = new System.Drawing.Size(745, 151);
            this.splitContainer3.SplitterDistance = 248;
            this.splitContainer3.TabIndex = 0;
            // 
            // btnRecordValueDel
            // 
            this.btnRecordValueDel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRecordValueDel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnRecordValueDel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnRecordValueDel.Location = new System.Drawing.Point(198, 4);
            this.btnRecordValueDel.Name = "btnRecordValueDel";
            this.btnRecordValueDel.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnRecordValueDel.Size = new System.Drawing.Size(20, 20);
            this.btnRecordValueDel.Symbol = 61544;
            this.btnRecordValueDel.TabIndex = 9;
            this.btnRecordValueDel.Click += new System.EventHandler(this.btnRecordValueDel_Click);
            // 
            // btnRecordValueNew
            // 
            this.btnRecordValueNew.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRecordValueNew.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnRecordValueNew.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnRecordValueNew.Location = new System.Drawing.Point(168, 4);
            this.btnRecordValueNew.Name = "btnRecordValueNew";
            this.btnRecordValueNew.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnRecordValueNew.Size = new System.Drawing.Size(20, 20);
            this.btnRecordValueNew.Symbol = 61543;
            this.btnRecordValueNew.TabIndex = 8;
            this.btnRecordValueNew.Click += new System.EventHandler(this.btnRecordValueNew_Click);
            // 
            // dgvRecordValue
            // 
            this.dgvRecordValue.AllowUserToAddRows = false;
            dataGridViewCellStyle7.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvRecordValue.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle7;
            this.dgvRecordValue.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvRecordValue.BackgroundColor = System.Drawing.Color.White;
            this.dgvRecordValue.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvRecordValue.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle8.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle8.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle8.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle8.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle8.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle8.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle8.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvRecordValue.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle8;
            this.dgvRecordValue.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvRecordValue.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvRecordValue.EnableHeadersVisualStyles = false;
            this.dgvRecordValue.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvRecordValue.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvRecordValue.Location = new System.Drawing.Point(0, 30);
            this.dgvRecordValue.Name = "dgvRecordValue";
            this.dgvRecordValue.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvRecordValue.RowHeadersVisible = false;
            dataGridViewCellStyle9.BackColor = System.Drawing.Color.White;
            this.dgvRecordValue.RowsDefaultCellStyle = dataGridViewCellStyle9;
            this.dgvRecordValue.RowTemplate.Height = 29;
            this.dgvRecordValue.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvRecordValue.SelectedIndex = -1;
            this.dgvRecordValue.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvRecordValue.Size = new System.Drawing.Size(248, 121);
            this.dgvRecordValue.Style = Sunny.UI.UIStyle.Custom;
            this.dgvRecordValue.TabIndex = 7;
            this.dgvRecordValue.TagString = null;
            this.dgvRecordValue.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvRecordValue_CellEndEdit);
            // 
            // lb_RecordValues
            // 
            this.lb_RecordValues.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lb_RecordValues.Location = new System.Drawing.Point(3, 3);
            this.lb_RecordValues.Name = "lb_RecordValues";
            this.lb_RecordValues.Size = new System.Drawing.Size(122, 23);
            this.lb_RecordValues.Style = Sunny.UI.UIStyle.Custom;
            this.lb_RecordValues.TabIndex = 6;
            this.lb_RecordValues.Text = "Record Values:";
            this.lb_RecordValues.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // dgvRecordMember
            // 
            this.dgvRecordMember.AllowUserToAddRows = false;
            dataGridViewCellStyle10.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvRecordMember.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle10;
            this.dgvRecordMember.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvRecordMember.BackgroundColor = System.Drawing.Color.White;
            this.dgvRecordMember.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvRecordMember.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle11.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle11.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle11.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle11.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle11.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle11.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle11.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvRecordMember.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle11;
            this.dgvRecordMember.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvRecordMember.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvRecordMember.EnableHeadersVisualStyles = false;
            this.dgvRecordMember.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvRecordMember.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvRecordMember.Location = new System.Drawing.Point(0, 30);
            this.dgvRecordMember.Name = "dgvRecordMember";
            this.dgvRecordMember.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvRecordMember.RowHeadersVisible = false;
            dataGridViewCellStyle12.BackColor = System.Drawing.Color.White;
            this.dgvRecordMember.RowsDefaultCellStyle = dataGridViewCellStyle12;
            this.dgvRecordMember.RowTemplate.Height = 29;
            this.dgvRecordMember.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvRecordMember.SelectedIndex = -1;
            this.dgvRecordMember.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvRecordMember.Size = new System.Drawing.Size(493, 121);
            this.dgvRecordMember.Style = Sunny.UI.UIStyle.Custom;
            this.dgvRecordMember.TabIndex = 7;
            this.dgvRecordMember.TagString = null;
            // 
            // lb_RecordMember
            // 
            this.lb_RecordMember.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lb_RecordMember.Location = new System.Drawing.Point(3, 3);
            this.lb_RecordMember.Name = "lb_RecordMember";
            this.lb_RecordMember.Size = new System.Drawing.Size(117, 23);
            this.lb_RecordMember.Style = Sunny.UI.UIStyle.Custom;
            this.lb_RecordMember.TabIndex = 6;
            this.lb_RecordMember.Text = "Record Member:";
            this.lb_RecordMember.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // OVRRecordForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(745, 447);
            this.Controls.Add(this.splitContainer1);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRRecordForm";
            this.Text = "OVRRecordForm";
            this.Load += new System.EventHandler(this.OVRRecordForm_Load);
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Events)).EndInit();
            this.splitContainer2.Panel1.ResumeLayout(false);
            this.splitContainer2.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer2)).EndInit();
            this.splitContainer2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvEventRecords)).EndInit();
            this.SetRecordRegisterMenuStrip.ResumeLayout(false);
            this.splitContainer3.Panel1.ResumeLayout(false);
            this.splitContainer3.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer3)).EndInit();
            this.splitContainer3.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvRecordValue)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvRecordMember)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.SplitContainer splitContainer1;
        private UILabel lb_EventList;
        private UIDataGridView dgv_Events;
        private UIButton btn_DelRecord;
        private UIButton btn_ImportRecord;
        private UIButton btn_ExportRecord;
        private UIButton btn_AddRecord;
        private UILabel lb_RecordsList;
        private UIDataGridView dgvEventRecords;
        private System.Windows.Forms.SplitContainer splitContainer2;
        private System.Windows.Forms.SplitContainer splitContainer3;
        private UIDataGridView dgvRecordValue;
        private UILabel lb_RecordValues;
        private UIDataGridView dgvRecordMember;
        private UILabel lb_RecordMember;
        private UISymbolButton btnRecordValueDel;
        private UISymbolButton btnRecordValueNew;
        private System.Windows.Forms.ContextMenuStrip SetRecordRegisterMenuStrip;
        private System.Windows.Forms.ToolStripMenuItem MenuSetRegister;
    }
}