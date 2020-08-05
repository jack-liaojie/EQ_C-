using Sunny.UI;

namespace AutoSports.OVRPluginMgr
{
    partial class OVRPluginMgrForm
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

        #region Component Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            Sunny.UI.UIPanel panelTitle;
            Sunny.UI.UIPanel panelClient;
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            this.lbMatchList = new DevComponents.DotNetBar.LabelX();
            this.dgvMatchList = new Sunny.UI.UIDataGridView();
            this.panelFilter = new Sunny.UI.UIPanel();
            this.btnUpdate = new DevComponents.DotNetBar.ButtonX();
            this.cmbFilterCourt = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbFilterCourt = new Sunny.UI.UILabel();
            this.cmbFilterVenue = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbFilterVenue = new Sunny.UI.UILabel();
            this.cmbFilterDate = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbFilterDate = new Sunny.UI.UILabel();
            this.cmbFilterPhase = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbFilterPhase = new Sunny.UI.UILabel();
            this.cmbFilterEvent = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbFilterEvent = new Sunny.UI.UILabel();
            this.panelMatchList = new Sunny.UI.UIPanel();
            this.spliterMatchList = new DevComponents.DotNetBar.ExpandableSplitter();
            this.panelPluginMgr = new Sunny.UI.UIPanel();
            panelTitle = new Sunny.UI.UIPanel();
            panelClient = new Sunny.UI.UIPanel();
            panelTitle.SuspendLayout();
            panelClient.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchList)).BeginInit();
            this.panelFilter.SuspendLayout();
            this.panelMatchList.SuspendLayout();
            this.SuspendLayout();
            // 
            // panelTitle
            // 
            panelTitle.Controls.Add(this.lbMatchList);
            panelTitle.Dock = System.Windows.Forms.DockStyle.Top;
            panelTitle.Font = new System.Drawing.Font("微软雅黑", 12F);
            panelTitle.Location = new System.Drawing.Point(2, 2);
            panelTitle.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            panelTitle.Name = "panelTitle";
            panelTitle.Padding = new System.Windows.Forms.Padding(2);
            panelTitle.Size = new System.Drawing.Size(332, 20);
            panelTitle.TabIndex = 0;
            panelTitle.Text = null;
            // 
            // lbMatchList
            // 
            this.lbMatchList.AutoSize = true;
            // 
            // 
            // 
            this.lbMatchList.BackgroundStyle.Class = "";
            this.lbMatchList.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbMatchList.Dock = System.Windows.Forms.DockStyle.Top;
            this.lbMatchList.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lbMatchList.Location = new System.Drawing.Point(2, 2);
            this.lbMatchList.Name = "lbMatchList";
            this.lbMatchList.Size = new System.Drawing.Size(70, 16);
            this.lbMatchList.TabIndex = 0;
            this.lbMatchList.Text = "Match List";
            // 
            // panelClient
            // 
            panelClient.Controls.Add(this.dgvMatchList);
            panelClient.Controls.Add(this.panelFilter);
            panelClient.Dock = System.Windows.Forms.DockStyle.Fill;
            panelClient.Font = new System.Drawing.Font("微软雅黑", 12F);
            panelClient.Location = new System.Drawing.Point(2, 22);
            panelClient.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            panelClient.Name = "panelClient";
            panelClient.Padding = new System.Windows.Forms.Padding(2);
            panelClient.Size = new System.Drawing.Size(332, 648);
            panelClient.TabIndex = 1;
            panelClient.Text = null;
            // 
            // dgvMatchList
            // 
            this.dgvMatchList.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvMatchList.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvMatchList.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvMatchList.BackgroundColor = System.Drawing.Color.White;
            this.dgvMatchList.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvMatchList.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvMatchList.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvMatchList.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvMatchList.DefaultCellStyle = dataGridViewCellStyle3;
            this.dgvMatchList.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvMatchList.EnableHeadersVisualStyles = false;
            this.dgvMatchList.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvMatchList.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMatchList.Location = new System.Drawing.Point(2, 177);
            this.dgvMatchList.MultiSelect = false;
            this.dgvMatchList.Name = "dgvMatchList";
            this.dgvMatchList.ReadOnly = true;
            this.dgvMatchList.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMatchList.RowHeadersVisible = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.White;
            this.dgvMatchList.RowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvMatchList.RowTemplate.Height = 29;
            this.dgvMatchList.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvMatchList.SelectedIndex = -1;
            this.dgvMatchList.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvMatchList.Size = new System.Drawing.Size(328, 469);
            this.dgvMatchList.TabIndex = 1;
            this.dgvMatchList.TagString = null;
            this.dgvMatchList.CellMouseDoubleClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgvMatchList_CellMouseDoubleClick);
            this.dgvMatchList.CellPainting += new System.Windows.Forms.DataGridViewCellPaintingEventHandler(this.dgvMatchList_CellPainting);
            // 
            // panelFilter
            // 
            this.panelFilter.Controls.Add(this.btnUpdate);
            this.panelFilter.Controls.Add(this.cmbFilterCourt);
            this.panelFilter.Controls.Add(this.lbFilterCourt);
            this.panelFilter.Controls.Add(this.cmbFilterVenue);
            this.panelFilter.Controls.Add(this.lbFilterVenue);
            this.panelFilter.Controls.Add(this.cmbFilterDate);
            this.panelFilter.Controls.Add(this.lbFilterDate);
            this.panelFilter.Controls.Add(this.cmbFilterPhase);
            this.panelFilter.Controls.Add(this.lbFilterPhase);
            this.panelFilter.Controls.Add(this.cmbFilterEvent);
            this.panelFilter.Controls.Add(this.lbFilterEvent);
            this.panelFilter.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelFilter.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.panelFilter.Location = new System.Drawing.Point(2, 2);
            this.panelFilter.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.panelFilter.Name = "panelFilter";
            this.panelFilter.Size = new System.Drawing.Size(328, 175);
            this.panelFilter.TabIndex = 0;
            this.panelFilter.Text = null;
            this.panelFilter.Resize += new System.EventHandler(this.panelFilter_Resize);
            // 
            // btnUpdate
            // 
            this.btnUpdate.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnUpdate.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnUpdate.Image = global::AutoSports.OVRPluginMgr.Properties.Resources.Update_24;
            this.btnUpdate.Location = new System.Drawing.Point(6, 4);
            this.btnUpdate.Name = "btnUpdate";
            this.btnUpdate.Size = new System.Drawing.Size(50, 30);
            this.btnUpdate.TabIndex = 2;
            this.btnUpdate.Click += new System.EventHandler(this.btnUpdate_Click);
            // 
            // cmbFilterCourt
            // 
            this.cmbFilterCourt.DisplayMember = "Text";
            this.cmbFilterCourt.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbFilterCourt.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cmbFilterCourt.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.cmbFilterCourt.FormattingEnabled = true;
            this.cmbFilterCourt.ItemHeight = 20;
            this.cmbFilterCourt.Location = new System.Drawing.Point(70, 142);
            this.cmbFilterCourt.Name = "cmbFilterCourt";
            this.cmbFilterCourt.Size = new System.Drawing.Size(220, 26);
            this.cmbFilterCourt.TabIndex = 1;
            this.cmbFilterCourt.SelectionChangeCommitted += new System.EventHandler(this.cmbFilterCourt_SelectionChangeCommitted);
            // 
            // lbFilterCourt
            // 
            this.lbFilterCourt.AutoSize = true;
            this.lbFilterCourt.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbFilterCourt.Location = new System.Drawing.Point(6, 147);
            this.lbFilterCourt.Name = "lbFilterCourt";
            this.lbFilterCourt.Size = new System.Drawing.Size(53, 21);
            this.lbFilterCourt.TabIndex = 0;
            this.lbFilterCourt.Text = "Court";
            this.lbFilterCourt.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.lbFilterCourt.UseMnemonic = false;
            // 
            // cmbFilterVenue
            // 
            this.cmbFilterVenue.DisplayMember = "Text";
            this.cmbFilterVenue.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbFilterVenue.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cmbFilterVenue.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.cmbFilterVenue.FormattingEnabled = true;
            this.cmbFilterVenue.ItemHeight = 20;
            this.cmbFilterVenue.Location = new System.Drawing.Point(70, 115);
            this.cmbFilterVenue.Name = "cmbFilterVenue";
            this.cmbFilterVenue.Size = new System.Drawing.Size(220, 26);
            this.cmbFilterVenue.TabIndex = 1;
            this.cmbFilterVenue.SelectionChangeCommitted += new System.EventHandler(this.cmbFilterVenue_SelectionChangeCommitted);
            // 
            // lbFilterVenue
            // 
            this.lbFilterVenue.AutoSize = true;
            this.lbFilterVenue.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbFilterVenue.Location = new System.Drawing.Point(0, 120);
            this.lbFilterVenue.Name = "lbFilterVenue";
            this.lbFilterVenue.Size = new System.Drawing.Size(59, 21);
            this.lbFilterVenue.TabIndex = 0;
            this.lbFilterVenue.Text = "Venue";
            this.lbFilterVenue.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.lbFilterVenue.UseMnemonic = false;
            // 
            // cmbFilterDate
            // 
            this.cmbFilterDate.DisplayMember = "Text";
            this.cmbFilterDate.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbFilterDate.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cmbFilterDate.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.cmbFilterDate.FormattingEnabled = true;
            this.cmbFilterDate.ItemHeight = 20;
            this.cmbFilterDate.Location = new System.Drawing.Point(70, 34);
            this.cmbFilterDate.Name = "cmbFilterDate";
            this.cmbFilterDate.Size = new System.Drawing.Size(220, 26);
            this.cmbFilterDate.TabIndex = 1;
            this.cmbFilterDate.SelectionChangeCommitted += new System.EventHandler(this.cmbFilterDate_SelectionChangeCommitted);
            // 
            // lbFilterDate
            // 
            this.lbFilterDate.AutoSize = true;
            this.lbFilterDate.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbFilterDate.Location = new System.Drawing.Point(13, 39);
            this.lbFilterDate.Name = "lbFilterDate";
            this.lbFilterDate.Size = new System.Drawing.Size(46, 21);
            this.lbFilterDate.TabIndex = 0;
            this.lbFilterDate.Text = "Date";
            this.lbFilterDate.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.lbFilterDate.UseMnemonic = false;
            // 
            // cmbFilterPhase
            // 
            this.cmbFilterPhase.DisplayMember = "Text";
            this.cmbFilterPhase.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbFilterPhase.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cmbFilterPhase.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.cmbFilterPhase.FormattingEnabled = true;
            this.cmbFilterPhase.ItemHeight = 20;
            this.cmbFilterPhase.Location = new System.Drawing.Point(70, 88);
            this.cmbFilterPhase.Name = "cmbFilterPhase";
            this.cmbFilterPhase.Size = new System.Drawing.Size(220, 26);
            this.cmbFilterPhase.TabIndex = 1;
            this.cmbFilterPhase.SelectionChangeCommitted += new System.EventHandler(this.cmbFilterPhase_SelectionChangeCommitted);
            // 
            // lbFilterPhase
            // 
            this.lbFilterPhase.AutoSize = true;
            this.lbFilterPhase.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbFilterPhase.Location = new System.Drawing.Point(4, 93);
            this.lbFilterPhase.Name = "lbFilterPhase";
            this.lbFilterPhase.Size = new System.Drawing.Size(55, 21);
            this.lbFilterPhase.TabIndex = 0;
            this.lbFilterPhase.Text = "Phase";
            this.lbFilterPhase.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.lbFilterPhase.UseMnemonic = false;
            // 
            // cmbFilterEvent
            // 
            this.cmbFilterEvent.DisplayMember = "Text";
            this.cmbFilterEvent.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbFilterEvent.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cmbFilterEvent.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.cmbFilterEvent.FormattingEnabled = true;
            this.cmbFilterEvent.ItemHeight = 20;
            this.cmbFilterEvent.Location = new System.Drawing.Point(70, 61);
            this.cmbFilterEvent.Name = "cmbFilterEvent";
            this.cmbFilterEvent.Size = new System.Drawing.Size(220, 26);
            this.cmbFilterEvent.TabIndex = 1;
            this.cmbFilterEvent.SelectionChangeCommitted += new System.EventHandler(this.cmbFilterEvent_SelectionChangeCommitted);
            // 
            // lbFilterEvent
            // 
            this.lbFilterEvent.AutoSize = true;
            this.lbFilterEvent.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbFilterEvent.Location = new System.Drawing.Point(7, 66);
            this.lbFilterEvent.Name = "lbFilterEvent";
            this.lbFilterEvent.Size = new System.Drawing.Size(52, 21);
            this.lbFilterEvent.TabIndex = 0;
            this.lbFilterEvent.Text = "Event";
            this.lbFilterEvent.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.lbFilterEvent.UseMnemonic = false;
            // 
            // panelMatchList
            // 
            this.panelMatchList.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.panelMatchList.Controls.Add(panelClient);
            this.panelMatchList.Controls.Add(panelTitle);
            this.panelMatchList.Dock = System.Windows.Forms.DockStyle.Left;
            this.panelMatchList.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.panelMatchList.Location = new System.Drawing.Point(3, 3);
            this.panelMatchList.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.panelMatchList.Name = "panelMatchList";
            this.panelMatchList.Padding = new System.Windows.Forms.Padding(2);
            this.panelMatchList.Size = new System.Drawing.Size(336, 672);
            this.panelMatchList.TabIndex = 0;
            this.panelMatchList.Text = null;
            // 
            // spliterMatchList
            // 
            this.spliterMatchList.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(118)))), ((int)(((byte)(153)))), ((int)(((byte)(199)))));
            this.spliterMatchList.BackColor2 = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.spliterMatchList.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.None;
            this.spliterMatchList.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.None;
            this.spliterMatchList.ExpandableControl = this.panelMatchList;
            this.spliterMatchList.ExpandFillColor = System.Drawing.Color.FromArgb(((int)(((byte)(101)))), ((int)(((byte)(147)))), ((int)(((byte)(207)))));
            this.spliterMatchList.ExpandFillColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBorder;
            this.spliterMatchList.ExpandLineColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.spliterMatchList.ExpandLineColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.ItemText;
            this.spliterMatchList.GripDarkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.spliterMatchList.GripDarkColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.ItemText;
            this.spliterMatchList.GripLightColor = System.Drawing.Color.FromArgb(((int)(((byte)(227)))), ((int)(((byte)(239)))), ((int)(((byte)(255)))));
            this.spliterMatchList.GripLightColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.spliterMatchList.HotBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(252)))), ((int)(((byte)(151)))), ((int)(((byte)(61)))));
            this.spliterMatchList.HotBackColor2 = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(184)))), ((int)(((byte)(94)))));
            this.spliterMatchList.HotBackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.ItemPressedBackground2;
            this.spliterMatchList.HotBackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.ItemPressedBackground;
            this.spliterMatchList.HotExpandFillColor = System.Drawing.Color.FromArgb(((int)(((byte)(101)))), ((int)(((byte)(147)))), ((int)(((byte)(207)))));
            this.spliterMatchList.HotExpandFillColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBorder;
            this.spliterMatchList.HotExpandLineColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.spliterMatchList.HotExpandLineColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.ItemText;
            this.spliterMatchList.HotGripDarkColor = System.Drawing.Color.FromArgb(((int)(((byte)(101)))), ((int)(((byte)(147)))), ((int)(((byte)(207)))));
            this.spliterMatchList.HotGripDarkColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBorder;
            this.spliterMatchList.HotGripLightColor = System.Drawing.Color.FromArgb(((int)(((byte)(227)))), ((int)(((byte)(239)))), ((int)(((byte)(255)))));
            this.spliterMatchList.HotGripLightColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.spliterMatchList.Location = new System.Drawing.Point(339, 3);
            this.spliterMatchList.Name = "spliterMatchList";
            this.spliterMatchList.Size = new System.Drawing.Size(6, 672);
            this.spliterMatchList.Style = DevComponents.DotNetBar.eSplitterStyle.Office2007;
            this.spliterMatchList.TabIndex = 4;
            this.spliterMatchList.TabStop = false;
            // 
            // panelPluginMgr
            // 
            this.panelPluginMgr.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.panelPluginMgr.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelPluginMgr.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.panelPluginMgr.Location = new System.Drawing.Point(345, 3);
            this.panelPluginMgr.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.panelPluginMgr.Name = "panelPluginMgr";
            this.panelPluginMgr.Size = new System.Drawing.Size(614, 672);
            this.panelPluginMgr.TabIndex = 5;
            this.panelPluginMgr.Text = null;
            // 
            // OVRPluginMgrForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(962, 678);
            this.Controls.Add(this.panelPluginMgr);
            this.Controls.Add(this.spliterMatchList);
            this.Controls.Add(this.panelMatchList);
            this.Name = "OVRPluginMgrForm";
            this.Padding = new System.Windows.Forms.Padding(3);
            this.Load += new System.EventHandler(this.OVRPluginMgrForm_Load);
            panelTitle.ResumeLayout(false);
            panelTitle.PerformLayout();
            panelClient.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchList)).EndInit();
            this.panelFilter.ResumeLayout(false);
            this.panelFilter.PerformLayout();
            this.panelMatchList.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private UIPanel panelMatchList;
        private DevComponents.DotNetBar.ExpandableSplitter spliterMatchList;
        private DevComponents.DotNetBar.LabelX lbMatchList;
        private UIPanel panelPluginMgr;
        private UIDataGridView dgvMatchList;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbFilterEvent;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbFilterVenue;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbFilterDate;
        private UIPanel panelFilter;
        private DevComponents.DotNetBar.ButtonX btnUpdate;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbFilterCourt;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbFilterPhase;
        private UILabel lbFilterEvent;
        private UILabel lbFilterVenue;
        private UILabel lbFilterDate;
        private UILabel lbFilterCourt;
        private UILabel lbFilterPhase;
    }
}
