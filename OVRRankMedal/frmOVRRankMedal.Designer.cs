using Sunny.UI;

namespace AutoSports.OVRRankMedal
{
    partial class OVRRankMedalForm
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
            Sunny.UI.UIPanel panelEx1;
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(OVRRankMedalForm));
            Sunny.UI.UIPanel panelEx2;
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            this.tvPhaseTree = new DevComponents.AdvTree.AdvTree();
            this.PhaseTreeContextMenu = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.MenuEditEventStatus = new System.Windows.Forms.ToolStripMenuItem();
            this.DisImageList = new System.Windows.Forms.ImageList(this.components);
            this.nodeConnector1 = new DevComponents.AdvTree.NodeConnector();
            this.elementStyle1 = new DevComponents.DotNetBar.ElementStyle();
            this.btnRefresh = new Sunny.UI.UISymbolButton();
            this.btnExportResult = new Sunny.UI.UISymbolButton();
            this.btnSendEventResult = new Sunny.UI.UIButton();
            this.menuRowEdit = new DevComponents.DotNetBar.ContextMenuBar();
            this.topItem = new DevComponents.DotNetBar.ButtonItem();
            this.cmdAddResult = new DevComponents.DotNetBar.ButtonItem();
            this.cmdDelResult = new DevComponents.DotNetBar.ButtonItem();
            this.cmdExportResult = new DevComponents.DotNetBar.ButtonItem();
            this.btnEventDateSetting = new DevComponents.DotNetBar.ButtonItem();
            this.btnMedalDateSetting = new DevComponents.DotNetBar.ButtonItem();
            this.dgridResult = new Sunny.UI.UIDataGridView();
            this.lbResult = new Sunny.UI.UILabel();
            this.btnGroupResult = new Sunny.UI.UIButton();
            this.btnEventResult = new Sunny.UI.UIButton();
            this.btnGroupPoints = new Sunny.UI.UIButton();
            this.saveResultDlg = new System.Windows.Forms.SaveFileDialog();
            this.splitter1 = new System.Windows.Forms.Splitter();
            panelEx1 = new Sunny.UI.UIPanel();
            panelEx2 = new Sunny.UI.UIPanel();
            panelEx1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.tvPhaseTree)).BeginInit();
            this.PhaseTreeContextMenu.SuspendLayout();
            panelEx2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.menuRowEdit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgridResult)).BeginInit();
            this.SuspendLayout();
            // 
            // panelEx1
            // 
            panelEx1.Controls.Add(this.tvPhaseTree);
            panelEx1.Controls.Add(this.btnRefresh);
            panelEx1.Controls.Add(this.btnExportResult);
            panelEx1.Dock = System.Windows.Forms.DockStyle.Left;
            panelEx1.Font = new System.Drawing.Font("微软雅黑", 12F);
            panelEx1.Location = new System.Drawing.Point(0, 0);
            panelEx1.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            panelEx1.Name = "panelEx1";
            panelEx1.Padding = new System.Windows.Forms.Padding(2, 35, 2, 2);
            panelEx1.Size = new System.Drawing.Size(243, 628);
            panelEx1.Style = Sunny.UI.UIStyle.Custom;
            panelEx1.TabIndex = 15;
            panelEx1.Text = null;
            // 
            // tvPhaseTree
            // 
            this.tvPhaseTree.AccessibleRole = System.Windows.Forms.AccessibleRole.Outline;
            this.tvPhaseTree.AllowDrop = true;
            this.tvPhaseTree.BackColor = System.Drawing.SystemColors.Window;
            // 
            // 
            // 
            this.tvPhaseTree.BackgroundStyle.Class = "TreeBorderKey";
            this.tvPhaseTree.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.tvPhaseTree.ContextMenuStrip = this.PhaseTreeContextMenu;
            this.tvPhaseTree.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tvPhaseTree.DragDropEnabled = false;
            this.tvPhaseTree.ImageList = this.DisImageList;
            this.tvPhaseTree.Location = new System.Drawing.Point(2, 35);
            this.tvPhaseTree.Name = "tvPhaseTree";
            this.tvPhaseTree.NodesConnector = this.nodeConnector1;
            this.tvPhaseTree.NodeStyle = this.elementStyle1;
            this.tvPhaseTree.PathSeparator = ";";
            this.tvPhaseTree.Size = new System.Drawing.Size(239, 591);
            this.tvPhaseTree.Styles.Add(this.elementStyle1);
            this.tvPhaseTree.TabIndex = 10;
            this.tvPhaseTree.Text = "tvPhaseTree";
            this.tvPhaseTree.AfterNodeSelect += new DevComponents.AdvTree.AdvTreeNodeEventHandler(this.tvPhaseTree_AfterNodeSelect);
            this.tvPhaseTree.MouseDown += new System.Windows.Forms.MouseEventHandler(this.tvPhaseTree_MouseDown);
            // 
            // PhaseTreeContextMenu
            // 
            this.PhaseTreeContextMenu.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.MenuEditEventStatus});
            this.PhaseTreeContextMenu.Name = "PhaseTreeContextMenu";
            this.PhaseTreeContextMenu.Size = new System.Drawing.Size(173, 26);
            // 
            // MenuEditEventStatus
            // 
            this.MenuEditEventStatus.Name = "MenuEditEventStatus";
            this.MenuEditEventStatus.Size = new System.Drawing.Size(172, 22);
            this.MenuEditEventStatus.Text = "Edit Event Status";
            this.MenuEditEventStatus.Click += new System.EventHandler(this.MenuEditEventStatus_Click);
            // 
            // DisImageList
            // 
            this.DisImageList.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("DisImageList.ImageStream")));
            this.DisImageList.TransparentColor = System.Drawing.Color.Transparent;
            this.DisImageList.Images.SetKeyName(0, "Sport.ico");
            this.DisImageList.Images.SetKeyName(1, "Discipline.ico");
            this.DisImageList.Images.SetKeyName(2, "Event.ico");
            this.DisImageList.Images.SetKeyName(3, "Phase.ico");
            this.DisImageList.Images.SetKeyName(4, "Match.ico");
            // 
            // nodeConnector1
            // 
            this.nodeConnector1.LineColor = System.Drawing.SystemColors.ControlText;
            // 
            // elementStyle1
            // 
            this.elementStyle1.Class = "";
            this.elementStyle1.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.elementStyle1.Name = "elementStyle1";
            this.elementStyle1.TextColor = System.Drawing.SystemColors.ControlText;
            // 
            // btnRefresh
            // 
            this.btnRefresh.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRefresh.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnRefresh.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnRefresh.Location = new System.Drawing.Point(46, 4);
            this.btnRefresh.Name = "btnRefresh";
            this.btnRefresh.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnRefresh.Size = new System.Drawing.Size(50, 30);
            this.btnRefresh.Style = Sunny.UI.UIStyle.Custom;
            this.btnRefresh.Symbol = 61473;
            this.btnRefresh.TabIndex = 11;
            this.btnRefresh.Click += new System.EventHandler(this.btnRefresh_Click);
            // 
            // btnExportResult
            // 
            this.btnExportResult.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnExportResult.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnExportResult.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnExportResult.Location = new System.Drawing.Point(115, 4);
            this.btnExportResult.Name = "btnExportResult";
            this.btnExportResult.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnExportResult.Size = new System.Drawing.Size(50, 30);
            this.btnExportResult.Style = Sunny.UI.UIStyle.Custom;
            this.btnExportResult.Symbol = 61639;
            this.btnExportResult.TabIndex = 11;
            this.btnExportResult.Click += new System.EventHandler(this.btnExportResult_Click);
            // 
            // panelEx2
            // 
            panelEx2.Controls.Add(this.btnSendEventResult);
            panelEx2.Controls.Add(this.menuRowEdit);
            panelEx2.Controls.Add(this.lbResult);
            panelEx2.Controls.Add(this.dgridResult);
            panelEx2.Controls.Add(this.btnGroupResult);
            panelEx2.Controls.Add(this.btnEventResult);
            panelEx2.Controls.Add(this.btnGroupPoints);
            panelEx2.Dock = System.Windows.Forms.DockStyle.Fill;
            panelEx2.Font = new System.Drawing.Font("微软雅黑", 12F);
            panelEx2.Location = new System.Drawing.Point(243, 0);
            panelEx2.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            panelEx2.Name = "panelEx2";
            panelEx2.Padding = new System.Windows.Forms.Padding(2, 35, 2, 2);
            panelEx2.Size = new System.Drawing.Size(888, 628);
            panelEx2.Style = Sunny.UI.UIStyle.Custom;
            panelEx2.TabIndex = 15;
            panelEx2.Text = null;
            // 
            // btnSendEventResult
            // 
            this.btnSendEventResult.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnSendEventResult.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnSendEventResult.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnSendEventResult.Location = new System.Drawing.Point(675, 2);
            this.btnSendEventResult.Name = "btnSendEventResult";
            this.btnSendEventResult.Size = new System.Drawing.Size(142, 30);
            this.btnSendEventResult.Style = Sunny.UI.UIStyle.Custom;
            this.btnSendEventResult.TabIndex = 15;
            this.btnSendEventResult.Text = "Send Event Result";
            this.btnSendEventResult.Click += new System.EventHandler(this.btnSendEventResult_Click);
            // 
            // menuRowEdit
            // 
            this.menuRowEdit.SetContextMenuEx(this.menuRowEdit, this.topItem);
            this.menuRowEdit.DockSide = DevComponents.DotNetBar.eDockSide.Document;
            this.menuRowEdit.Items.AddRange(new DevComponents.DotNetBar.BaseItem[] {
            this.topItem});
            this.menuRowEdit.Location = new System.Drawing.Point(166, 77);
            this.menuRowEdit.Name = "menuRowEdit";
            this.menuRowEdit.Size = new System.Drawing.Size(125, 25);
            this.menuRowEdit.Stretch = true;
            this.menuRowEdit.Style = DevComponents.DotNetBar.eDotNetBarStyle.Office2003;
            this.menuRowEdit.TabIndex = 14;
            this.menuRowEdit.TabStop = false;
            this.menuRowEdit.Text = "menuRowEdit";
            this.menuRowEdit.WrapItemsDock = true;
            // 
            // topItem
            // 
            this.topItem.AutoExpandOnClick = true;
            this.topItem.Name = "topItem";
            this.topItem.SubItems.AddRange(new DevComponents.DotNetBar.BaseItem[] {
            this.cmdAddResult,
            this.cmdDelResult,
            this.cmdExportResult,
            this.btnEventDateSetting,
            this.btnMedalDateSetting});
            this.topItem.PopupOpen += new DevComponents.DotNetBar.DotNetBarManager.PopupOpenEventHandler(this.topItem_PopupOpen);
            // 
            // cmdAddResult
            // 
            this.cmdAddResult.Name = "cmdAddResult";
            this.cmdAddResult.Text = "AddResult";
            this.cmdAddResult.Click += new System.EventHandler(this.cmdAddResult_Click);
            // 
            // cmdDelResult
            // 
            this.cmdDelResult.Name = "cmdDelResult";
            this.cmdDelResult.Text = "DeleteResult";
            this.cmdDelResult.Click += new System.EventHandler(this.cmdDelResult_Click);
            // 
            // cmdExportResult
            // 
            this.cmdExportResult.BeginGroup = true;
            this.cmdExportResult.Name = "cmdExportResult";
            this.cmdExportResult.Text = "ExportHistoryResult";
            this.cmdExportResult.Click += new System.EventHandler(this.cmdExportResult_Click);
            // 
            // btnEventDateSetting
            // 
            this.btnEventDateSetting.BeginGroup = true;
            this.btnEventDateSetting.Name = "btnEventDateSetting";
            this.btnEventDateSetting.Text = "EventDate Setting";
            this.btnEventDateSetting.Click += new System.EventHandler(this.btnEventDateSetting_Click);
            // 
            // btnMedalDateSetting
            // 
            this.btnMedalDateSetting.Name = "btnMedalDateSetting";
            this.btnMedalDateSetting.Text = "MedalDate Setting";
            this.btnMedalDateSetting.Click += new System.EventHandler(this.btnMedalDateSetting_Click);
            // 
            // dgridResult
            // 
            this.dgridResult.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgridResult.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgridResult.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgridResult.BackgroundColor = System.Drawing.Color.White;
            this.dgridResult.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgridResult.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgridResult.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgridResult.ColumnHeadersHeight = 32;
            this.dgridResult.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            this.menuRowEdit.SetContextMenuEx(this.dgridResult, this.topItem);
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgridResult.DefaultCellStyle = dataGridViewCellStyle3;
            this.dgridResult.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgridResult.EnableHeadersVisualStyles = false;
            this.dgridResult.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgridResult.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgridResult.Location = new System.Drawing.Point(2, 35);
            this.dgridResult.Name = "dgridResult";
            this.dgridResult.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgridResult.RowHeadersVisible = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.White;
            this.dgridResult.RowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgridResult.RowTemplate.Height = 29;
            this.dgridResult.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgridResult.SelectedIndex = -1;
            this.dgridResult.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgridResult.Size = new System.Drawing.Size(884, 591);
            this.dgridResult.Style = Sunny.UI.UIStyle.Custom;
            this.dgridResult.TabIndex = 13;
            this.dgridResult.TagString = null;
            this.dgridResult.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgridResult_CellBeginEdit);
            this.dgridResult.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgridResult_CellValueChanged);
            this.dgridResult.SelectionChanged += new System.EventHandler(this.dgridResult_SelectionChanged);
            // 
            // lbResult
            // 
            this.lbResult.AutoSize = true;
            this.lbResult.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbResult.Location = new System.Drawing.Point(5, 11);
            this.lbResult.Name = "lbResult";
            this.lbResult.Size = new System.Drawing.Size(105, 21);
            this.lbResult.Style = Sunny.UI.UIStyle.Custom;
            this.lbResult.TabIndex = 12;
            this.lbResult.Text = "Result/Rank:";
            this.lbResult.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // btnGroupResult
            // 
            this.btnGroupResult.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnGroupResult.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnGroupResult.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnGroupResult.Location = new System.Drawing.Point(339, 2);
            this.btnGroupResult.Name = "btnGroupResult";
            this.btnGroupResult.Size = new System.Drawing.Size(142, 30);
            this.btnGroupResult.Style = Sunny.UI.UIStyle.Custom;
            this.btnGroupResult.TabIndex = 11;
            this.btnGroupResult.Text = "GroupResult";
            this.btnGroupResult.Click += new System.EventHandler(this.btnGroupResult_Click);
            // 
            // btnEventResult
            // 
            this.btnEventResult.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnEventResult.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnEventResult.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnEventResult.Location = new System.Drawing.Point(171, 2);
            this.btnEventResult.Name = "btnEventResult";
            this.btnEventResult.Size = new System.Drawing.Size(142, 30);
            this.btnEventResult.Style = Sunny.UI.UIStyle.Custom;
            this.btnEventResult.TabIndex = 11;
            this.btnEventResult.Text = "Cal Event Result";
            this.btnEventResult.Click += new System.EventHandler(this.btnEventResult_Click);
            // 
            // btnGroupPoints
            // 
            this.btnGroupPoints.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnGroupPoints.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnGroupPoints.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnGroupPoints.Location = new System.Drawing.Point(507, 2);
            this.btnGroupPoints.Name = "btnGroupPoints";
            this.btnGroupPoints.Size = new System.Drawing.Size(142, 30);
            this.btnGroupPoints.Style = Sunny.UI.UIStyle.Custom;
            this.btnGroupPoints.TabIndex = 11;
            this.btnGroupPoints.Text = "GroupPoints";
            this.btnGroupPoints.Click += new System.EventHandler(this.btnGroupPoints_Click);
            // 
            // saveResultDlg
            // 
            this.saveResultDlg.DefaultExt = "txt";
            this.saveResultDlg.Filter = "TextFile(*.txt)|*.txt|AllFiles(*.*)|*.*";
            // 
            // splitter1
            // 
            this.splitter1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(199)))), ((int)(((byte)(216)))), ((int)(((byte)(237)))));
            this.splitter1.Location = new System.Drawing.Point(243, 0);
            this.splitter1.Name = "splitter1";
            this.splitter1.Size = new System.Drawing.Size(2, 628);
            this.splitter1.TabIndex = 16;
            this.splitter1.TabStop = false;
            // 
            // OVRRankMedalForm
            // 
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.ClientSize = new System.Drawing.Size(1131, 628);
            this.Controls.Add(this.splitter1);
            this.Controls.Add(panelEx2);
            this.Controls.Add(panelEx1);
            this.Name = "OVRRankMedalForm";
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "COVRRankMedalDlg";
            this.Load += new System.EventHandler(this.FrmOVRRankMedal_Load);
            panelEx1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.tvPhaseTree)).EndInit();
            this.PhaseTreeContextMenu.ResumeLayout(false);
            panelEx2.ResumeLayout(false);
            panelEx2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.menuRowEdit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgridResult)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private UISymbolButton btnRefresh;
        private UISymbolButton btnExportResult;
        private UILabel lbResult;
        private UIButton btnEventResult;
        private UIButton btnGroupResult;
        private UIButton btnGroupPoints;
        private DevComponents.AdvTree.AdvTree tvPhaseTree;
        private DevComponents.AdvTree.NodeConnector nodeConnector1;
        private DevComponents.DotNetBar.ElementStyle elementStyle1;
        private DevComponents.DotNetBar.ContextMenuBar menuRowEdit;
        private DevComponents.DotNetBar.ButtonItem topItem;
        private DevComponents.DotNetBar.ButtonItem cmdAddResult;
        private DevComponents.DotNetBar.ButtonItem cmdDelResult;
        private DevComponents.DotNetBar.ButtonItem cmdExportResult;
        private System.Windows.Forms.ImageList DisImageList;
        private UIDataGridView dgridResult;
        private System.Windows.Forms.SaveFileDialog saveResultDlg;
        private System.Windows.Forms.Splitter splitter1;
        private System.Windows.Forms.ContextMenuStrip PhaseTreeContextMenu;
        private System.Windows.Forms.ToolStripMenuItem MenuEditEventStatus;
        private UIButton btnSendEventResult;
        private DevComponents.DotNetBar.ButtonItem btnEventDateSetting;
        private DevComponents.DotNetBar.ButtonItem btnMedalDateSetting;
    }
}