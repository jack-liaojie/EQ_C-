using Sunny.UI;

namespace AutoSports.OVRRegister
{
    partial class OVRRegisterForm
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
            DevComponents.DotNetBar.TabControl tabCtrlRegister;
            Sunny.UI.UIPanel panelEx9;
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle5 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle7 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle8 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle9 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle10 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle11 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle12 = new System.Windows.Forms.DataGridViewCellStyle();
            Sunny.UI.UIPanel panelEx8;
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle13 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle14 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle15 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle16 = new System.Windows.Forms.DataGridViewCellStyle();
            Sunny.UI.UIPanel panelEx3;
            Sunny.UI.UIPanel panelEx2;
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.Splitter splitter1;
            Sunny.UI.UIPanel panelEx1;
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(OVRRegisterForm));
            this.tabPanelInscription = new DevComponents.DotNetBar.TabControlPanel();
            this.splitter5 = new System.Windows.Forms.Splitter();
            this.panelRegister = new Sunny.UI.UIPanel();
            this.dgvPlayer = new Sunny.UI.UIDataGridView();
            this.btnDelAll = new Sunny.UI.UIButton();
            this.lbRegister = new Sunny.UI.UILabel();
            this.btnDel = new Sunny.UI.UIButton();
            this.panelAvailable = new Sunny.UI.UIPanel();
            this.cmbRegTypeFliter = new Sunny.UI.UIComboBox();
            this.cmbAthleteFliter = new Sunny.UI.UIComboBox();
            this.lbRegTypeFliter = new Sunny.UI.UILabel();
            this.dgvAvailable = new Sunny.UI.UIDataGridView();
            this.lbAvailable = new Sunny.UI.UILabel();
            this.btnAddAll = new Sunny.UI.UIButton();
            this.btnAdd = new Sunny.UI.UIButton();
            this.splitter4 = new System.Windows.Forms.Splitter();
            this.panelLeft = new Sunny.UI.UIPanel();
            this.btn_Register = new Sunny.UI.UIButton();
            this.btnAllInscribe = new Sunny.UI.UIButton();
            this.btnRefresh = new Sunny.UI.UISymbolButton();
            this.dgvFederation = new Sunny.UI.UIDataGridView();
            this.cmbEvent = new Sunny.UI.UIComboBox();
            this.lbEvent = new Sunny.UI.UILabel();
            this.gbInscriptionType = new Sunny.UI.UIGroupBox();
            this.radioRegister = new Sunny.UI.UIRadioButton();
            this.radioEvent = new Sunny.UI.UIRadioButton();
            this.tabInscription = new DevComponents.DotNetBar.TabItem(this.components);
            this.tabPanelRegisterInfo = new DevComponents.DotNetBar.TabControlPanel();
            this.dgv_Athlete = new Sunny.UI.UIDataGridView();
            this.cmbFliter = new Sunny.UI.UIComboBox();
            this.btn_EditRegister = new Sunny.UI.UISymbolButton();
            this.btn_DelRegister = new Sunny.UI.UISymbolButton();
            this.lbFliter = new Sunny.UI.UILabel();
            this.cmbGroup = new Sunny.UI.UIComboBox();
            this.adv_RegisterTree = new DevComponents.AdvTree.AdvTree();
            this.cmd_Register = new DevComponents.DotNetBar.ContextMenuBar();
            this.bm_AllMenu = new DevComponents.DotNetBar.ButtonItem();
            this.bm_AddTeam = new DevComponents.DotNetBar.ButtonItem();
            this.bm_AddPair = new DevComponents.DotNetBar.ButtonItem();
            this.bm_AddAthlete = new DevComponents.DotNetBar.ButtonItem();
            this.bm_AddNonAthlete = new DevComponents.DotNetBar.ButtonItem();
            this.bm_AddHorse = new DevComponents.DotNetBar.ButtonItem();
            this.bm_DelTeam = new DevComponents.DotNetBar.ButtonItem();
            this.bm_DelPair = new DevComponents.DotNetBar.ButtonItem();
            this.bm_EditItem = new DevComponents.DotNetBar.ButtonItem();
            this.bm_EditFederation = new DevComponents.DotNetBar.ButtonItem();
            this.TreeimageList = new System.Windows.Forms.ImageList(this.components);
            this.nodeConnector1 = new DevComponents.AdvTree.NodeConnector();
            this.elementStyle1 = new DevComponents.DotNetBar.ElementStyle();
            this.btn_Update = new Sunny.UI.UIImageButton();
            this.btn_Delegation = new Sunny.UI.UIButton();
            this.lbGroup = new Sunny.UI.UILabel();
            this.tabRegister = new DevComponents.DotNetBar.TabItem(this.components);
            this.EditMembercontextMenu = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.MenuEditMember = new System.Windows.Forms.ToolStripMenuItem();
            this.RegistercontextMenu = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.MenuEdit = new System.Windows.Forms.ToolStripMenuItem();
            this.MenuAdd = new System.Windows.Forms.ToolStripMenuItem();
            this.MenuDelete = new System.Windows.Forms.ToolStripMenuItem();
            this.HorseInscription = new System.Windows.Forms.ToolStripMenuItem();
            tabCtrlRegister = new DevComponents.DotNetBar.TabControl();
            panelEx9 = new Sunny.UI.UIPanel();
            panelEx8 = new Sunny.UI.UIPanel();
            panelEx3 = new Sunny.UI.UIPanel();
            panelEx2 = new Sunny.UI.UIPanel();
            splitter1 = new System.Windows.Forms.Splitter();
            panelEx1 = new Sunny.UI.UIPanel();
            ((System.ComponentModel.ISupportInitialize)(tabCtrlRegister)).BeginInit();
            tabCtrlRegister.SuspendLayout();
            this.tabPanelInscription.SuspendLayout();
            panelEx9.SuspendLayout();
            this.panelRegister.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPlayer)).BeginInit();
            this.panelAvailable.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvAvailable)).BeginInit();
            this.panelLeft.SuspendLayout();
            panelEx8.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvFederation)).BeginInit();
            panelEx3.SuspendLayout();
            this.gbInscriptionType.SuspendLayout();
            this.tabPanelRegisterInfo.SuspendLayout();
            panelEx2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Athlete)).BeginInit();
            panelEx1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.adv_RegisterTree)).BeginInit();
            this.adv_RegisterTree.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.cmd_Register)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.btn_Update)).BeginInit();
            this.EditMembercontextMenu.SuspendLayout();
            this.RegistercontextMenu.SuspendLayout();
            this.SuspendLayout();
            // 
            // tabCtrlRegister
            // 
            tabCtrlRegister.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            tabCtrlRegister.CanReorderTabs = false;
            tabCtrlRegister.ColorScheme.TabBackground = System.Drawing.Color.FromArgb(((int)(((byte)(231)))), ((int)(((byte)(238)))), ((int)(((byte)(247)))));
            tabCtrlRegister.ColorScheme.TabBackground2 = System.Drawing.Color.FromArgb(((int)(((byte)(210)))), ((int)(((byte)(224)))), ((int)(((byte)(240)))));
            tabCtrlRegister.ColorScheme.TabItemBackgroundColorBlend.AddRange(new DevComponents.DotNetBar.BackgroundColorBlend[] {
            new DevComponents.DotNetBar.BackgroundColorBlend(System.Drawing.Color.FromArgb(((int)(((byte)(215)))), ((int)(((byte)(230)))), ((int)(((byte)(249))))), 0F),
            new DevComponents.DotNetBar.BackgroundColorBlend(System.Drawing.Color.FromArgb(((int)(((byte)(199)))), ((int)(((byte)(220)))), ((int)(((byte)(248))))), 0.45F),
            new DevComponents.DotNetBar.BackgroundColorBlend(System.Drawing.Color.FromArgb(((int)(((byte)(179)))), ((int)(((byte)(208)))), ((int)(((byte)(245))))), 0.45F),
            new DevComponents.DotNetBar.BackgroundColorBlend(System.Drawing.Color.FromArgb(((int)(((byte)(215)))), ((int)(((byte)(229)))), ((int)(((byte)(247))))), 1F)});
            tabCtrlRegister.ColorScheme.TabItemHotBackgroundColorBlend.AddRange(new DevComponents.DotNetBar.BackgroundColorBlend[] {
            new DevComponents.DotNetBar.BackgroundColorBlend(System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(253)))), ((int)(((byte)(235))))), 0F),
            new DevComponents.DotNetBar.BackgroundColorBlend(System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(236)))), ((int)(((byte)(168))))), 0.45F),
            new DevComponents.DotNetBar.BackgroundColorBlend(System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(218)))), ((int)(((byte)(89))))), 0.45F),
            new DevComponents.DotNetBar.BackgroundColorBlend(System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(230)))), ((int)(((byte)(141))))), 1F)});
            tabCtrlRegister.ColorScheme.TabItemSelectedBackgroundColorBlend.AddRange(new DevComponents.DotNetBar.BackgroundColorBlend[] {
            new DevComponents.DotNetBar.BackgroundColorBlend(System.Drawing.Color.White, 0F),
            new DevComponents.DotNetBar.BackgroundColorBlend(System.Drawing.Color.FromArgb(((int)(((byte)(253)))), ((int)(((byte)(253)))), ((int)(((byte)(254))))), 0.45F),
            new DevComponents.DotNetBar.BackgroundColorBlend(System.Drawing.Color.FromArgb(((int)(((byte)(253)))), ((int)(((byte)(253)))), ((int)(((byte)(254))))), 0.45F),
            new DevComponents.DotNetBar.BackgroundColorBlend(System.Drawing.Color.FromArgb(((int)(((byte)(253)))), ((int)(((byte)(253)))), ((int)(((byte)(254))))), 1F)});
            tabCtrlRegister.ColorScheme.TabPanelBackground = System.Drawing.Color.FromArgb(((int)(((byte)(199)))), ((int)(((byte)(216)))), ((int)(((byte)(237)))));
            tabCtrlRegister.ColorScheme.TabPanelBackground2 = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            tabCtrlRegister.Controls.Add(this.tabPanelRegisterInfo);
            tabCtrlRegister.Controls.Add(this.tabPanelInscription);
            tabCtrlRegister.Dock = System.Windows.Forms.DockStyle.Fill;
            tabCtrlRegister.FixedTabSize = new System.Drawing.Size(120, 0);
            tabCtrlRegister.Location = new System.Drawing.Point(0, 0);
            tabCtrlRegister.Name = "tabCtrlRegister";
            tabCtrlRegister.SelectedTabFont = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Bold);
            tabCtrlRegister.SelectedTabIndex = 0;
            tabCtrlRegister.Size = new System.Drawing.Size(1336, 628);
            tabCtrlRegister.Style = DevComponents.DotNetBar.eTabStripStyle.Office2007Dock;
            tabCtrlRegister.TabIndex = 0;
            tabCtrlRegister.TabLayoutType = DevComponents.DotNetBar.eTabLayoutType.FixedWithNavigationBox;
            tabCtrlRegister.Tabs.Add(this.tabRegister);
            tabCtrlRegister.Tabs.Add(this.tabInscription);
            tabCtrlRegister.Text = "tabControl1";
            // 
            // tabPanelInscription
            // 
            this.tabPanelInscription.Controls.Add(panelEx9);
            this.tabPanelInscription.Controls.Add(this.splitter4);
            this.tabPanelInscription.Controls.Add(this.panelLeft);
            this.tabPanelInscription.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tabPanelInscription.Location = new System.Drawing.Point(0, 33);
            this.tabPanelInscription.Name = "tabPanelInscription";
            this.tabPanelInscription.Padding = new System.Windows.Forms.Padding(1);
            this.tabPanelInscription.Size = new System.Drawing.Size(1336, 595);
            this.tabPanelInscription.Style.BackColor1.Color = System.Drawing.Color.FromArgb(((int)(((byte)(199)))), ((int)(((byte)(216)))), ((int)(((byte)(237)))));
            this.tabPanelInscription.Style.BackColor2.Color = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.tabPanelInscription.Style.Border = DevComponents.DotNetBar.eBorderType.SingleLine;
            this.tabPanelInscription.Style.BorderColor.Color = System.Drawing.Color.FromArgb(((int)(((byte)(146)))), ((int)(((byte)(165)))), ((int)(((byte)(199)))));
            this.tabPanelInscription.Style.BorderSide = ((DevComponents.DotNetBar.eBorderSide)(((DevComponents.DotNetBar.eBorderSide.Left | DevComponents.DotNetBar.eBorderSide.Right) 
            | DevComponents.DotNetBar.eBorderSide.Bottom)));
            this.tabPanelInscription.Style.GradientAngle = 90;
            this.tabPanelInscription.TabIndex = 2;
            this.tabPanelInscription.TabItem = this.tabInscription;
            // 
            // panelEx9
            // 
            panelEx9.Controls.Add(this.splitter5);
            panelEx9.Controls.Add(this.panelRegister);
            panelEx9.Controls.Add(this.panelAvailable);
            panelEx9.Dock = System.Windows.Forms.DockStyle.Fill;
            panelEx9.Font = new System.Drawing.Font("微软雅黑", 12F);
            panelEx9.Location = new System.Drawing.Point(415, 1);
            panelEx9.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            panelEx9.Name = "panelEx9";
            panelEx9.Padding = new System.Windows.Forms.Padding(2, 0, 2, 0);
            panelEx9.Size = new System.Drawing.Size(920, 593);
            panelEx9.TabIndex = 6;
            panelEx9.Text = null;
            // 
            // splitter5
            // 
            this.splitter5.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(199)))), ((int)(((byte)(216)))), ((int)(((byte)(237)))));
            this.splitter5.Dock = System.Windows.Forms.DockStyle.Top;
            this.splitter5.Location = new System.Drawing.Point(2, 265);
            this.splitter5.Name = "splitter5";
            this.splitter5.Size = new System.Drawing.Size(916, 2);
            this.splitter5.TabIndex = 8;
            this.splitter5.TabStop = false;
            // 
            // panelRegister
            // 
            this.panelRegister.Controls.Add(this.dgvPlayer);
            this.panelRegister.Controls.Add(this.btnDelAll);
            this.panelRegister.Controls.Add(this.lbRegister);
            this.panelRegister.Controls.Add(this.btnDel);
            this.panelRegister.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelRegister.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.panelRegister.Location = new System.Drawing.Point(2, 265);
            this.panelRegister.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.panelRegister.Name = "panelRegister";
            this.panelRegister.Padding = new System.Windows.Forms.Padding(2, 35, 2, 2);
            this.panelRegister.Size = new System.Drawing.Size(916, 328);
            this.panelRegister.TabIndex = 4;
            this.panelRegister.Text = "panelEx3";
            // 
            // dgvPlayer
            // 
            this.dgvPlayer.AllowUserToAddRows = false;
            dataGridViewCellStyle5.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvPlayer.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle5;
            this.dgvPlayer.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvPlayer.BackgroundColor = System.Drawing.Color.White;
            this.dgvPlayer.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvPlayer.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle6.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle6.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle6.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle6.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle6.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle6.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle6.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvPlayer.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle6;
            this.dgvPlayer.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle7.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle7.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle7.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle7.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle7.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle7.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle7.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvPlayer.DefaultCellStyle = dataGridViewCellStyle7;
            this.dgvPlayer.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvPlayer.EnableHeadersVisualStyles = false;
            this.dgvPlayer.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvPlayer.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvPlayer.Location = new System.Drawing.Point(2, 35);
            this.dgvPlayer.MultiSelect = false;
            this.dgvPlayer.Name = "dgvPlayer";
            this.dgvPlayer.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvPlayer.RowHeadersVisible = false;
            dataGridViewCellStyle8.BackColor = System.Drawing.Color.White;
            this.dgvPlayer.RowsDefaultCellStyle = dataGridViewCellStyle8;
            this.dgvPlayer.RowTemplate.Height = 29;
            this.dgvPlayer.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvPlayer.SelectedIndex = -1;
            this.dgvPlayer.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvPlayer.Size = new System.Drawing.Size(912, 291);
            this.dgvPlayer.TabIndex = 2;
            this.dgvPlayer.TagString = null;
            this.dgvPlayer.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvPlayer_CellBeginEdit);
            this.dgvPlayer.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvPlayer_CellContentClick);
            this.dgvPlayer.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvPlayer_CellValueChanged);
            this.dgvPlayer.MouseDown += new System.Windows.Forms.MouseEventHandler(this.dgvPlayer_MouseDown);
            // 
            // btnDelAll
            // 
            this.btnDelAll.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDelAll.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnDelAll.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnDelAll.Location = new System.Drawing.Point(691, 3);
            this.btnDelAll.Name = "btnDelAll";
            this.btnDelAll.Size = new System.Drawing.Size(104, 30);
            this.btnDelAll.TabIndex = 6;
            this.btnDelAll.Text = "取消全部报项";
            this.btnDelAll.Click += new System.EventHandler(this.btnDelAll_Click);
            // 
            // lbRegister
            // 
            this.lbRegister.AutoSize = true;
            this.lbRegister.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbRegister.Location = new System.Drawing.Point(7, 8);
            this.lbRegister.Name = "lbRegister";
            this.lbRegister.Size = new System.Drawing.Size(90, 21);
            this.lbRegister.Style = Sunny.UI.UIStyle.Custom;
            this.lbRegister.TabIndex = 0;
            this.lbRegister.Text = "报项人员：";
            this.lbRegister.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // btnDel
            // 
            this.btnDel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnDel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnDel.Location = new System.Drawing.Point(581, 3);
            this.btnDel.Name = "btnDel";
            this.btnDel.Size = new System.Drawing.Size(104, 30);
            this.btnDel.TabIndex = 6;
            this.btnDel.Text = "取消报项";
            this.btnDel.Click += new System.EventHandler(this.btnDel_Click);
            // 
            // panelAvailable
            // 
            this.panelAvailable.Controls.Add(this.cmbRegTypeFliter);
            this.panelAvailable.Controls.Add(this.cmbAthleteFliter);
            this.panelAvailable.Controls.Add(this.lbRegTypeFliter);
            this.panelAvailable.Controls.Add(this.dgvAvailable);
            this.panelAvailable.Controls.Add(this.lbAvailable);
            this.panelAvailable.Controls.Add(this.btnAddAll);
            this.panelAvailable.Controls.Add(this.btnAdd);
            this.panelAvailable.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelAvailable.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.panelAvailable.Location = new System.Drawing.Point(2, 0);
            this.panelAvailable.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.panelAvailable.Name = "panelAvailable";
            this.panelAvailable.Padding = new System.Windows.Forms.Padding(2, 35, 2, 2);
            this.panelAvailable.Size = new System.Drawing.Size(916, 265);
            this.panelAvailable.TabIndex = 1;
            this.panelAvailable.Text = null;
            // 
            // cmbRegTypeFliter
            // 
            this.cmbRegTypeFliter.FillColor = System.Drawing.Color.White;
            this.cmbRegTypeFliter.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cmbRegTypeFliter.FormattingEnabled = true;
            this.cmbRegTypeFliter.Location = new System.Drawing.Point(394, 5);
            this.cmbRegTypeFliter.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cmbRegTypeFliter.MinimumSize = new System.Drawing.Size(63, 0);
            this.cmbRegTypeFliter.Name = "cmbRegTypeFliter";
            this.cmbRegTypeFliter.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cmbRegTypeFliter.Size = new System.Drawing.Size(140, 29);
            this.cmbRegTypeFliter.TabIndex = 8;
            this.cmbRegTypeFliter.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            this.cmbRegTypeFliter.Visible = false;
            this.cmbRegTypeFliter.SelectedValueChanged += new System.EventHandler(this.cmbRegTypeFliter_SelectionChangeCommitted);
            // 
            // cmbAthleteFliter
            // 
            this.cmbAthleteFliter.FillColor = System.Drawing.Color.White;
            this.cmbAthleteFliter.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cmbAthleteFliter.FormattingEnabled = true;
            this.cmbAthleteFliter.Location = new System.Drawing.Point(237, 5);
            this.cmbAthleteFliter.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cmbAthleteFliter.MinimumSize = new System.Drawing.Size(63, 0);
            this.cmbAthleteFliter.Name = "cmbAthleteFliter";
            this.cmbAthleteFliter.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cmbAthleteFliter.Size = new System.Drawing.Size(140, 29);
            this.cmbAthleteFliter.TabIndex = 8;
            this.cmbAthleteFliter.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            this.cmbAthleteFliter.Visible = false;
            this.cmbAthleteFliter.SelectedValueChanged += new System.EventHandler(this.cmbAthleteFilter_SelectionChangeCommitted);
            // 
            // lbRegTypeFliter
            // 
            this.lbRegTypeFliter.AutoSize = true;
            this.lbRegTypeFliter.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbRegTypeFliter.Location = new System.Drawing.Point(144, 9);
            this.lbRegTypeFliter.Name = "lbRegTypeFliter";
            this.lbRegTypeFliter.Size = new System.Drawing.Size(52, 21);
            this.lbRegTypeFliter.Style = Sunny.UI.UIStyle.Custom;
            this.lbRegTypeFliter.TabIndex = 7;
            this.lbRegTypeFliter.Text = "Fliter:";
            this.lbRegTypeFliter.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.lbRegTypeFliter.Visible = false;
            // 
            // dgvAvailable
            // 
            this.dgvAvailable.AllowUserToAddRows = false;
            dataGridViewCellStyle9.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvAvailable.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle9;
            this.dgvAvailable.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvAvailable.BackgroundColor = System.Drawing.Color.White;
            this.dgvAvailable.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvAvailable.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle10.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle10.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle10.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle10.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle10.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle10.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle10.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvAvailable.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle10;
            this.dgvAvailable.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle11.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle11.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle11.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle11.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle11.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle11.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle11.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvAvailable.DefaultCellStyle = dataGridViewCellStyle11;
            this.dgvAvailable.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvAvailable.EnableHeadersVisualStyles = false;
            this.dgvAvailable.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvAvailable.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvAvailable.Location = new System.Drawing.Point(2, 35);
            this.dgvAvailable.MultiSelect = false;
            this.dgvAvailable.Name = "dgvAvailable";
            this.dgvAvailable.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvAvailable.RowHeadersVisible = false;
            dataGridViewCellStyle12.BackColor = System.Drawing.Color.White;
            this.dgvAvailable.RowsDefaultCellStyle = dataGridViewCellStyle12;
            this.dgvAvailable.RowTemplate.Height = 29;
            this.dgvAvailable.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvAvailable.SelectedIndex = -1;
            this.dgvAvailable.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvAvailable.Size = new System.Drawing.Size(912, 228);
            this.dgvAvailable.TabIndex = 2;
            this.dgvAvailable.TagString = null;
            this.dgvAvailable.CellDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvAvailable_CellDoubleClick);
            this.dgvAvailable.SelectionChanged += new System.EventHandler(this.dgvAvailable_SelectionChanged);
            this.dgvAvailable.MouseDown += new System.Windows.Forms.MouseEventHandler(this.dgvAvailable_MouseDown);
            // 
            // lbAvailable
            // 
            this.lbAvailable.AutoSize = true;
            this.lbAvailable.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbAvailable.Location = new System.Drawing.Point(6, 9);
            this.lbAvailable.Name = "lbAvailable";
            this.lbAvailable.Size = new System.Drawing.Size(106, 21);
            this.lbAvailable.Style = Sunny.UI.UIStyle.Custom;
            this.lbAvailable.TabIndex = 0;
            this.lbAvailable.Text = "未报项人员：";
            this.lbAvailable.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // btnAddAll
            // 
            this.btnAddAll.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAddAll.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnAddAll.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnAddAll.Location = new System.Drawing.Point(691, 4);
            this.btnAddAll.Name = "btnAddAll";
            this.btnAddAll.Size = new System.Drawing.Size(104, 30);
            this.btnAddAll.TabIndex = 6;
            this.btnAddAll.Text = "全部报项";
            this.btnAddAll.Click += new System.EventHandler(this.btnAddAll_Click);
            // 
            // btnAdd
            // 
            this.btnAdd.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAdd.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnAdd.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnAdd.Location = new System.Drawing.Point(581, 4);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(104, 30);
            this.btnAdd.TabIndex = 6;
            this.btnAdd.Text = "报项";
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // splitter4
            // 
            this.splitter4.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(199)))), ((int)(((byte)(216)))), ((int)(((byte)(237)))));
            this.splitter4.Location = new System.Drawing.Point(413, 1);
            this.splitter4.Name = "splitter4";
            this.splitter4.Size = new System.Drawing.Size(2, 593);
            this.splitter4.TabIndex = 3;
            this.splitter4.TabStop = false;
            // 
            // panelLeft
            // 
            this.panelLeft.Controls.Add(this.btn_Register);
            this.panelLeft.Controls.Add(this.btnAllInscribe);
            this.panelLeft.Controls.Add(this.btnRefresh);
            this.panelLeft.Controls.Add(panelEx8);
            this.panelLeft.Controls.Add(panelEx3);
            this.panelLeft.Controls.Add(this.gbInscriptionType);
            this.panelLeft.Dock = System.Windows.Forms.DockStyle.Left;
            this.panelLeft.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.panelLeft.Location = new System.Drawing.Point(1, 1);
            this.panelLeft.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.panelLeft.Name = "panelLeft";
            this.panelLeft.Padding = new System.Windows.Forms.Padding(2, 80, 2, 5);
            this.panelLeft.Size = new System.Drawing.Size(412, 593);
            this.panelLeft.TabIndex = 1;
            this.panelLeft.Text = null;
            // 
            // btn_Register
            // 
            this.btn_Register.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_Register.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btn_Register.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btn_Register.Location = new System.Drawing.Point(151, 5);
            this.btn_Register.Name = "btn_Register";
            this.btn_Register.Size = new System.Drawing.Size(76, 30);
            this.btn_Register.TabIndex = 8;
            this.btn_Register.Text = "Register";
            this.btn_Register.Click += new System.EventHandler(this.btn_Register_Click);
            // 
            // btnAllInscribe
            // 
            this.btnAllInscribe.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAllInscribe.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnAllInscribe.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnAllInscribe.Location = new System.Drawing.Point(61, 5);
            this.btnAllInscribe.Name = "btnAllInscribe";
            this.btnAllInscribe.Size = new System.Drawing.Size(82, 30);
            this.btnAllInscribe.TabIndex = 7;
            this.btnAllInscribe.Text = "全报项";
            this.btnAllInscribe.Click += new System.EventHandler(this.btnAllInscribe_Click);
            // 
            // btnRefresh
            // 
            this.btnRefresh.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRefresh.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnRefresh.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnRefresh.Location = new System.Drawing.Point(6, 4);
            this.btnRefresh.Name = "btnRefresh";
            this.btnRefresh.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnRefresh.Size = new System.Drawing.Size(50, 30);
            this.btnRefresh.Symbol = 61473;
            this.btnRefresh.TabIndex = 6;
            this.btnRefresh.Click += new System.EventHandler(this.btnRefresh_Click);
            // 
            // panelEx8
            // 
            panelEx8.Controls.Add(this.dgvFederation);
            panelEx8.Dock = System.Windows.Forms.DockStyle.Bottom;
            panelEx8.Font = new System.Drawing.Font("微软雅黑", 12F);
            panelEx8.Location = new System.Drawing.Point(2, 272);
            panelEx8.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            panelEx8.Name = "panelEx8";
            panelEx8.Size = new System.Drawing.Size(408, 316);
            panelEx8.TabIndex = 5;
            panelEx8.Text = null;
            // 
            // dgvFederation
            // 
            this.dgvFederation.AllowUserToAddRows = false;
            dataGridViewCellStyle13.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvFederation.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle13;
            this.dgvFederation.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvFederation.BackgroundColor = System.Drawing.Color.White;
            this.dgvFederation.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvFederation.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle14.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle14.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle14.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle14.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle14.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle14.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle14.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvFederation.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle14;
            this.dgvFederation.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle15.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle15.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle15.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle15.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle15.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle15.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle15.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvFederation.DefaultCellStyle = dataGridViewCellStyle15;
            this.dgvFederation.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvFederation.EnableHeadersVisualStyles = false;
            this.dgvFederation.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvFederation.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvFederation.Location = new System.Drawing.Point(0, 0);
            this.dgvFederation.MultiSelect = false;
            this.dgvFederation.Name = "dgvFederation";
            this.dgvFederation.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvFederation.RowHeadersVisible = false;
            dataGridViewCellStyle16.BackColor = System.Drawing.Color.White;
            this.dgvFederation.RowsDefaultCellStyle = dataGridViewCellStyle16;
            this.dgvFederation.RowTemplate.Height = 29;
            this.dgvFederation.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvFederation.SelectedIndex = -1;
            this.dgvFederation.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvFederation.Size = new System.Drawing.Size(408, 316);
            this.dgvFederation.TabIndex = 4;
            this.dgvFederation.TagString = null;
            this.dgvFederation.SelectionChanged += new System.EventHandler(this.dgvFederation_SelectionChanged);
            // 
            // panelEx3
            // 
            panelEx3.Controls.Add(this.cmbEvent);
            panelEx3.Controls.Add(this.lbEvent);
            panelEx3.Dock = System.Windows.Forms.DockStyle.Top;
            panelEx3.Font = new System.Drawing.Font("微软雅黑", 12F);
            panelEx3.Location = new System.Drawing.Point(2, 80);
            panelEx3.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            panelEx3.Name = "panelEx3";
            panelEx3.Padding = new System.Windows.Forms.Padding(70, 3, 0, 3);
            panelEx3.Size = new System.Drawing.Size(408, 60);
            panelEx3.TabIndex = 5;
            panelEx3.Text = null;
            // 
            // cmbEvent
            // 
            this.cmbEvent.DisplayMember = "Text";
            this.cmbEvent.FillColor = System.Drawing.Color.White;
            this.cmbEvent.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cmbEvent.FormattingEnabled = true;
            this.cmbEvent.ItemHeight = 23;
            this.cmbEvent.Location = new System.Drawing.Point(52, 10);
            this.cmbEvent.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cmbEvent.MinimumSize = new System.Drawing.Size(63, 0);
            this.cmbEvent.Name = "cmbEvent";
            this.cmbEvent.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cmbEvent.Size = new System.Drawing.Size(340, 29);
            this.cmbEvent.TabIndex = 2;
            this.cmbEvent.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            this.cmbEvent.SelectedValueChanged += new System.EventHandler(this.cmbEvent_SelectionChangeCommitted);
            // 
            // lbEvent
            // 
            this.lbEvent.AutoSize = true;
            this.lbEvent.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbEvent.Location = new System.Drawing.Point(5, 13);
            this.lbEvent.Name = "lbEvent";
            this.lbEvent.Size = new System.Drawing.Size(58, 21);
            this.lbEvent.Style = Sunny.UI.UIStyle.Custom;
            this.lbEvent.TabIndex = 1;
            this.lbEvent.Text = "项目：";
            this.lbEvent.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // gbInscriptionType
            // 
            this.gbInscriptionType.Controls.Add(this.radioRegister);
            this.gbInscriptionType.Controls.Add(this.radioEvent);
            this.gbInscriptionType.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.gbInscriptionType.Location = new System.Drawing.Point(2, 40);
            this.gbInscriptionType.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.gbInscriptionType.Name = "gbInscriptionType";
            this.gbInscriptionType.Padding = new System.Windows.Forms.Padding(0, 32, 0, 0);
            this.gbInscriptionType.Size = new System.Drawing.Size(392, 30);
            this.gbInscriptionType.TabIndex = 4;
            this.gbInscriptionType.TabStop = false;
            this.gbInscriptionType.Text = "报项选择";
            // 
            // radioRegister
            // 
            this.radioRegister.Cursor = System.Windows.Forms.Cursors.Hand;
            this.radioRegister.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.radioRegister.Location = new System.Drawing.Point(256, 10);
            this.radioRegister.Name = "radioRegister";
            this.radioRegister.Padding = new System.Windows.Forms.Padding(22, 0, 0, 0);
            this.radioRegister.Size = new System.Drawing.Size(108, 25);
            this.radioRegister.TabIndex = 1;
            this.radioRegister.Text = "按人员报项";
            this.radioRegister.Click += new System.EventHandler(this.radioRegister_Click);
            // 
            // radioEvent
            // 
            this.radioEvent.Checked = true;
            this.radioEvent.Cursor = System.Windows.Forms.Cursors.Hand;
            this.radioEvent.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.radioEvent.Location = new System.Drawing.Point(117, 10);
            this.radioEvent.Name = "radioEvent";
            this.radioEvent.Padding = new System.Windows.Forms.Padding(22, 0, 0, 0);
            this.radioEvent.Size = new System.Drawing.Size(108, 25);
            this.radioEvent.TabIndex = 0;
            this.radioEvent.Text = "按项目报项";
            this.radioEvent.Click += new System.EventHandler(this.radioEvent_Click);
            // 
            // tabInscription
            // 
            this.tabInscription.AttachedControl = this.tabPanelInscription;
            this.tabInscription.Name = "tabInscription";
            this.tabInscription.Text = "Inscription";
            this.tabInscription.Click += new System.EventHandler(this.tabInscription_Click);
            // 
            // tabPanelRegisterInfo
            // 
            this.tabPanelRegisterInfo.Controls.Add(panelEx2);
            this.tabPanelRegisterInfo.Controls.Add(splitter1);
            this.tabPanelRegisterInfo.Controls.Add(panelEx1);
            this.tabPanelRegisterInfo.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tabPanelRegisterInfo.Location = new System.Drawing.Point(0, 33);
            this.tabPanelRegisterInfo.Name = "tabPanelRegisterInfo";
            this.tabPanelRegisterInfo.Padding = new System.Windows.Forms.Padding(1);
            this.tabPanelRegisterInfo.Size = new System.Drawing.Size(1336, 595);
            this.tabPanelRegisterInfo.Style.BackColor1.Color = System.Drawing.Color.FromArgb(((int)(((byte)(199)))), ((int)(((byte)(216)))), ((int)(((byte)(237)))));
            this.tabPanelRegisterInfo.Style.BackColor2.Color = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.tabPanelRegisterInfo.Style.Border = DevComponents.DotNetBar.eBorderType.SingleLine;
            this.tabPanelRegisterInfo.Style.BorderColor.Color = System.Drawing.Color.FromArgb(((int)(((byte)(146)))), ((int)(((byte)(165)))), ((int)(((byte)(199)))));
            this.tabPanelRegisterInfo.Style.BorderSide = ((DevComponents.DotNetBar.eBorderSide)(((DevComponents.DotNetBar.eBorderSide.Left | DevComponents.DotNetBar.eBorderSide.Right) 
            | DevComponents.DotNetBar.eBorderSide.Bottom)));
            this.tabPanelRegisterInfo.Style.GradientAngle = 90;
            this.tabPanelRegisterInfo.TabIndex = 1;
            this.tabPanelRegisterInfo.TabItem = this.tabRegister;
            // 
            // panelEx2
            // 
            panelEx2.Controls.Add(this.dgv_Athlete);
            panelEx2.Controls.Add(this.cmbFliter);
            panelEx2.Controls.Add(this.btn_EditRegister);
            panelEx2.Controls.Add(this.btn_DelRegister);
            panelEx2.Controls.Add(this.lbFliter);
            panelEx2.Dock = System.Windows.Forms.DockStyle.Fill;
            panelEx2.Font = new System.Drawing.Font("微软雅黑", 12F);
            panelEx2.Location = new System.Drawing.Point(494, 1);
            panelEx2.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            panelEx2.Name = "panelEx2";
            panelEx2.Padding = new System.Windows.Forms.Padding(2, 35, 2, 2);
            panelEx2.Size = new System.Drawing.Size(841, 593);
            panelEx2.TabIndex = 7;
            panelEx2.Text = "panelEx1";
            // 
            // dgv_Athlete
            // 
            this.dgv_Athlete.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgv_Athlete.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgv_Athlete.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgv_Athlete.BackgroundColor = System.Drawing.Color.White;
            this.dgv_Athlete.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgv_Athlete.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgv_Athlete.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgv_Athlete.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgv_Athlete.DefaultCellStyle = dataGridViewCellStyle3;
            this.dgv_Athlete.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgv_Athlete.EnableHeadersVisualStyles = false;
            this.dgv_Athlete.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgv_Athlete.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgv_Athlete.Location = new System.Drawing.Point(2, 35);
            this.dgv_Athlete.MultiSelect = false;
            this.dgv_Athlete.Name = "dgv_Athlete";
            this.dgv_Athlete.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgv_Athlete.RowHeadersVisible = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.White;
            this.dgv_Athlete.RowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgv_Athlete.RowTemplate.Height = 29;
            this.dgv_Athlete.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgv_Athlete.SelectedIndex = -1;
            this.dgv_Athlete.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgv_Athlete.Size = new System.Drawing.Size(837, 556);
            this.dgv_Athlete.TabIndex = 3;
            this.dgv_Athlete.TagString = null;
            this.dgv_Athlete.CellDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_Athlete_CellDoubleClick);
            this.dgv_Athlete.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_Athlete_CellValueChanged);
            this.dgv_Athlete.MouseDown += new System.Windows.Forms.MouseEventHandler(this.dgv_Athlete_MouseDown);
            // 
            // cmbFliter
            // 
            this.cmbFliter.DisplayMember = "Text";
            this.cmbFliter.FillColor = System.Drawing.Color.White;
            this.cmbFliter.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cmbFliter.FormattingEnabled = true;
            this.cmbFliter.ItemHeight = 23;
            this.cmbFliter.Location = new System.Drawing.Point(100, 9);
            this.cmbFliter.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cmbFliter.MinimumSize = new System.Drawing.Size(63, 0);
            this.cmbFliter.Name = "cmbFliter";
            this.cmbFliter.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cmbFliter.Size = new System.Drawing.Size(181, 29);
            this.cmbFliter.TabIndex = 3;
            this.cmbFliter.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            this.cmbFliter.SelectedValueChanged += new System.EventHandler(this.cmbFliter_SelectionChangeCommitted);
            // 
            // btn_EditRegister
            // 
            this.btn_EditRegister.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_EditRegister.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btn_EditRegister.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btn_EditRegister.Location = new System.Drawing.Point(288, 9);
            this.btn_EditRegister.Name = "btn_EditRegister";
            this.btn_EditRegister.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btn_EditRegister.Size = new System.Drawing.Size(50, 30);
            this.btn_EditRegister.Symbol = 61508;
            this.btn_EditRegister.TabIndex = 1;
            this.btn_EditRegister.TabStop = false;
            this.btn_EditRegister.Click += new System.EventHandler(this.btn_EditRegister_Click);
            // 
            // btn_DelRegister
            // 
            this.btn_DelRegister.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_DelRegister.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btn_DelRegister.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btn_DelRegister.Location = new System.Drawing.Point(342, 9);
            this.btn_DelRegister.Name = "btn_DelRegister";
            this.btn_DelRegister.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btn_DelRegister.Size = new System.Drawing.Size(50, 30);
            this.btn_DelRegister.Symbol = 61544;
            this.btn_DelRegister.TabIndex = 2;
            this.btn_DelRegister.TabStop = false;
            this.btn_DelRegister.Click += new System.EventHandler(this.btn_DelRegister_Click);
            // 
            // lbFliter
            // 
            this.lbFliter.AutoSize = true;
            this.lbFliter.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbFliter.Location = new System.Drawing.Point(17, 9);
            this.lbFliter.Name = "lbFliter";
            this.lbFliter.Size = new System.Drawing.Size(48, 21);
            this.lbFliter.Style = Sunny.UI.UIStyle.Custom;
            this.lbFliter.TabIndex = 0;
            this.lbFliter.Text = "Fliter";
            this.lbFliter.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // splitter1
            // 
            splitter1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(199)))), ((int)(((byte)(216)))), ((int)(((byte)(237)))));
            splitter1.Location = new System.Drawing.Point(492, 1);
            splitter1.Name = "splitter1";
            splitter1.Size = new System.Drawing.Size(2, 593);
            splitter1.TabIndex = 6;
            splitter1.TabStop = false;
            // 
            // panelEx1
            // 
            panelEx1.Controls.Add(this.cmbGroup);
            panelEx1.Controls.Add(this.adv_RegisterTree);
            panelEx1.Controls.Add(this.btn_Update);
            panelEx1.Controls.Add(this.btn_Delegation);
            panelEx1.Controls.Add(this.lbGroup);
            panelEx1.Dock = System.Windows.Forms.DockStyle.Left;
            panelEx1.Font = new System.Drawing.Font("微软雅黑", 12F);
            panelEx1.Location = new System.Drawing.Point(1, 1);
            panelEx1.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            panelEx1.Name = "panelEx1";
            panelEx1.Padding = new System.Windows.Forms.Padding(2, 35, 2, 2);
            panelEx1.Size = new System.Drawing.Size(491, 593);
            panelEx1.TabIndex = 5;
            panelEx1.Text = "panelEx1";
            // 
            // cmbGroup
            // 
            this.cmbGroup.DisplayMember = "Text";
            this.cmbGroup.FillColor = System.Drawing.Color.White;
            this.cmbGroup.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cmbGroup.FormattingEnabled = true;
            this.cmbGroup.ItemHeight = 23;
            this.cmbGroup.Location = new System.Drawing.Point(320, 5);
            this.cmbGroup.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cmbGroup.MinimumSize = new System.Drawing.Size(63, 0);
            this.cmbGroup.Name = "cmbGroup";
            this.cmbGroup.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cmbGroup.Size = new System.Drawing.Size(151, 29);
            this.cmbGroup.TabIndex = 3;
            this.cmbGroup.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            this.cmbGroup.SelectedValueChanged += new System.EventHandler(this.cmbGroup_SelectionChangeCommitted);
            // 
            // adv_RegisterTree
            // 
            this.adv_RegisterTree.AccessibleRole = System.Windows.Forms.AccessibleRole.Outline;
            this.adv_RegisterTree.AllowDrop = true;
            this.adv_RegisterTree.BackColor = System.Drawing.SystemColors.Window;
            // 
            // 
            // 
            this.adv_RegisterTree.BackgroundStyle.Class = "TreeBorderKey";
            this.adv_RegisterTree.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.adv_RegisterTree.Controls.Add(this.cmd_Register);
            this.adv_RegisterTree.Dock = System.Windows.Forms.DockStyle.Fill;
            this.adv_RegisterTree.DragDropEnabled = false;
            this.adv_RegisterTree.ImageList = this.TreeimageList;
            this.adv_RegisterTree.Location = new System.Drawing.Point(2, 35);
            this.adv_RegisterTree.Name = "adv_RegisterTree";
            this.adv_RegisterTree.NodesConnector = this.nodeConnector1;
            this.adv_RegisterTree.NodeStyle = this.elementStyle1;
            this.adv_RegisterTree.PathSeparator = ";";
            this.adv_RegisterTree.Size = new System.Drawing.Size(487, 556);
            this.adv_RegisterTree.Styles.Add(this.elementStyle1);
            this.adv_RegisterTree.TabIndex = 2;
            this.adv_RegisterTree.Text = "advTree1";
            this.adv_RegisterTree.AfterNodeSelect += new DevComponents.AdvTree.AdvTreeNodeEventHandler(this.adv_RegisterTree_AfterNodeSelect);
            this.adv_RegisterTree.MouseDown += new System.Windows.Forms.MouseEventHandler(this.adv_RegisterTree_MouseDown);
            // 
            // cmd_Register
            // 
            this.cmd_Register.DockSide = DevComponents.DotNetBar.eDockSide.Document;
            this.cmd_Register.Items.AddRange(new DevComponents.DotNetBar.BaseItem[] {
            this.bm_AllMenu});
            this.cmd_Register.Location = new System.Drawing.Point(65, 101);
            this.cmd_Register.Name = "cmd_Register";
            this.cmd_Register.Size = new System.Drawing.Size(75, 25);
            this.cmd_Register.Stretch = true;
            this.cmd_Register.Style = DevComponents.DotNetBar.eDotNetBarStyle.Office2003;
            this.cmd_Register.TabIndex = 0;
            this.cmd_Register.TabStop = false;
            this.cmd_Register.WrapItemsDock = true;
            // 
            // bm_AllMenu
            // 
            this.bm_AllMenu.AutoExpandOnClick = true;
            this.bm_AllMenu.Name = "bm_AllMenu";
            this.bm_AllMenu.PopupAnimation = DevComponents.DotNetBar.ePopupAnimation.SystemDefault;
            this.bm_AllMenu.SubItems.AddRange(new DevComponents.DotNetBar.BaseItem[] {
            this.bm_AddTeam,
            this.bm_AddPair,
            this.bm_AddAthlete,
            this.bm_AddNonAthlete,
            this.bm_AddHorse,
            this.bm_DelTeam,
            this.bm_DelPair,
            this.bm_EditItem,
            this.bm_EditFederation});
            // 
            // bm_AddTeam
            // 
            this.bm_AddTeam.BeginGroup = true;
            this.bm_AddTeam.Name = "bm_AddTeam";
            this.bm_AddTeam.PopupAnimation = DevComponents.DotNetBar.ePopupAnimation.SystemDefault;
            this.bm_AddTeam.Text = "AddTeam";
            this.bm_AddTeam.Click += new System.EventHandler(this.bm_AddTeam_Click);
            // 
            // bm_AddPair
            // 
            this.bm_AddPair.Name = "bm_AddPair";
            this.bm_AddPair.PopupAnimation = DevComponents.DotNetBar.ePopupAnimation.SystemDefault;
            this.bm_AddPair.Text = "AddPair";
            this.bm_AddPair.Click += new System.EventHandler(this.bm_AddPair_Click);
            // 
            // bm_AddAthlete
            // 
            this.bm_AddAthlete.Name = "bm_AddAthlete";
            this.bm_AddAthlete.PopupAnimation = DevComponents.DotNetBar.ePopupAnimation.SystemDefault;
            this.bm_AddAthlete.Text = "AddAthlete";
            this.bm_AddAthlete.Click += new System.EventHandler(this.bm_AddAthlete_Click);
            // 
            // bm_AddNonAthlete
            // 
            this.bm_AddNonAthlete.Name = "bm_AddNonAthlete";
            this.bm_AddNonAthlete.PopupAnimation = DevComponents.DotNetBar.ePopupAnimation.SystemDefault;
            this.bm_AddNonAthlete.Text = "AddNonAthlete";
            this.bm_AddNonAthlete.Click += new System.EventHandler(this.bm_AddNonAthlete_Click);
            // 
            // bm_AddHorse
            // 
            this.bm_AddHorse.Name = "bm_AddHorse";
            this.bm_AddHorse.PopupAnimation = DevComponents.DotNetBar.ePopupAnimation.SystemDefault;
            this.bm_AddHorse.Text = "AddHorse";
            this.bm_AddHorse.Click += new System.EventHandler(this.bm_AddHorse_Click);
            // 
            // bm_DelTeam
            // 
            this.bm_DelTeam.BeginGroup = true;
            this.bm_DelTeam.Name = "bm_DelTeam";
            this.bm_DelTeam.PopupAnimation = DevComponents.DotNetBar.ePopupAnimation.SystemDefault;
            this.bm_DelTeam.Text = "DelTeam";
            this.bm_DelTeam.Click += new System.EventHandler(this.bm_DelTeam_Click);
            // 
            // bm_DelPair
            // 
            this.bm_DelPair.Name = "bm_DelPair";
            this.bm_DelPair.PopupAnimation = DevComponents.DotNetBar.ePopupAnimation.SystemDefault;
            this.bm_DelPair.Text = "DelPair";
            this.bm_DelPair.Click += new System.EventHandler(this.bm_DelPair_Click);
            // 
            // bm_EditItem
            // 
            this.bm_EditItem.BeginGroup = true;
            this.bm_EditItem.Name = "bm_EditItem";
            this.bm_EditItem.PopupAnimation = DevComponents.DotNetBar.ePopupAnimation.SystemDefault;
            this.bm_EditItem.Text = "EditItem";
            this.bm_EditItem.Click += new System.EventHandler(this.bm_EditItem_Click);
            // 
            // bm_EditFederation
            // 
            this.bm_EditFederation.Name = "bm_EditFederation";
            this.bm_EditFederation.PopupAnimation = DevComponents.DotNetBar.ePopupAnimation.SystemDefault;
            this.bm_EditFederation.Text = "EditFederation";
            this.bm_EditFederation.Click += new System.EventHandler(this.bm_EditFederation_Click);
            // 
            // TreeimageList
            // 
            this.TreeimageList.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("TreeimageList.ImageStream")));
            this.TreeimageList.TransparentColor = System.Drawing.Color.Transparent;
            this.TreeimageList.Images.SetKeyName(0, "Fedaration.ico");
            this.TreeimageList.Images.SetKeyName(1, "PairM.ico");
            this.TreeimageList.Images.SetKeyName(2, "PairW.ico");
            this.TreeimageList.Images.SetKeyName(3, "PairMix.ico");
            this.TreeimageList.Images.SetKeyName(4, "TeamM.ico");
            this.TreeimageList.Images.SetKeyName(5, "TeamW.ico");
            this.TreeimageList.Images.SetKeyName(6, "TeamMix.ico");
            this.TreeimageList.Images.SetKeyName(7, "Discipline.ico");
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
            // btn_Update
            // 
            this.btn_Update.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_Update.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btn_Update.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btn_Update.Image = global::AutoSports.OVRRegister.Properties.Resources.Update_24;
            this.btn_Update.Location = new System.Drawing.Point(6, 5);
            this.btn_Update.Name = "btn_Update";
            this.btn_Update.Size = new System.Drawing.Size(28, 29);
            this.btn_Update.TabIndex = 0;
            this.btn_Update.TabStop = false;
            this.btn_Update.Text = null;
            this.btn_Update.Click += new System.EventHandler(this.btn_Update_Click);
            // 
            // btn_Delegation
            // 
            this.btn_Delegation.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_Delegation.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btn_Delegation.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btn_Delegation.Location = new System.Drawing.Point(53, 5);
            this.btn_Delegation.Name = "btn_Delegation";
            this.btn_Delegation.Size = new System.Drawing.Size(133, 29);
            this.btn_Delegation.TabIndex = 1;
            this.btn_Delegation.Text = "Edit Delegation";
            this.btn_Delegation.Click += new System.EventHandler(this.btn_Delegation_Click);
            // 
            // lbGroup
            // 
            this.lbGroup.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbGroup.Location = new System.Drawing.Point(205, 5);
            this.lbGroup.Name = "lbGroup";
            this.lbGroup.Size = new System.Drawing.Size(96, 29);
            this.lbGroup.Style = Sunny.UI.UIStyle.Custom;
            this.lbGroup.TabIndex = 0;
            this.lbGroup.Text = "Grouping";
            this.lbGroup.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // tabRegister
            // 
            this.tabRegister.AttachedControl = this.tabPanelRegisterInfo;
            this.tabRegister.Name = "tabRegister";
            this.tabRegister.Text = "Register Info";
            this.tabRegister.Click += new System.EventHandler(this.tabRegister_Click);
            // 
            // EditMembercontextMenu
            // 
            this.EditMembercontextMenu.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.MenuEditMember});
            this.EditMembercontextMenu.Name = "EditMembercontextMenu";
            this.EditMembercontextMenu.Size = new System.Drawing.Size(153, 26);
            // 
            // MenuEditMember
            // 
            this.MenuEditMember.Name = "MenuEditMember";
            this.MenuEditMember.Size = new System.Drawing.Size(152, 22);
            this.MenuEditMember.Text = "Edit Member";
            this.MenuEditMember.Click += new System.EventHandler(this.MenuEditMember_Click);
            // 
            // RegistercontextMenu
            // 
            this.RegistercontextMenu.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.MenuEdit,
            this.MenuAdd,
            this.MenuDelete,
            this.HorseInscription});
            this.RegistercontextMenu.Name = "RegistercontextMenu";
            this.RegistercontextMenu.Size = new System.Drawing.Size(173, 92);
            // 
            // MenuEdit
            // 
            this.MenuEdit.Name = "MenuEdit";
            this.MenuEdit.Size = new System.Drawing.Size(172, 22);
            this.MenuEdit.Text = "Edit";
            this.MenuEdit.Click += new System.EventHandler(this.MenuEdit_Click);
            // 
            // MenuAdd
            // 
            this.MenuAdd.Name = "MenuAdd";
            this.MenuAdd.Size = new System.Drawing.Size(172, 22);
            this.MenuAdd.Text = "Add";
            this.MenuAdd.Click += new System.EventHandler(this.MenuAdd_Click);
            // 
            // MenuDelete
            // 
            this.MenuDelete.Name = "MenuDelete";
            this.MenuDelete.Size = new System.Drawing.Size(172, 22);
            this.MenuDelete.Text = "Delete";
            this.MenuDelete.Click += new System.EventHandler(this.MenuDelete_Click);
            // 
            // HorseInscription
            // 
            this.HorseInscription.Name = "HorseInscription";
            this.HorseInscription.Size = new System.Drawing.Size(172, 22);
            this.HorseInscription.Text = "HorseInscription";
            this.HorseInscription.Click += new System.EventHandler(this.HorseInscription_Click);
            // 
            // OVRRegisterForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1336, 628);
            this.Controls.Add(tabCtrlRegister);
            this.Name = "OVRRegisterForm";
            this.Load += new System.EventHandler(this.OVRRegisterForm_Load);
            ((System.ComponentModel.ISupportInitialize)(tabCtrlRegister)).EndInit();
            tabCtrlRegister.ResumeLayout(false);
            this.tabPanelInscription.ResumeLayout(false);
            panelEx9.ResumeLayout(false);
            this.panelRegister.ResumeLayout(false);
            this.panelRegister.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPlayer)).EndInit();
            this.panelAvailable.ResumeLayout(false);
            this.panelAvailable.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvAvailable)).EndInit();
            this.panelLeft.ResumeLayout(false);
            panelEx8.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvFederation)).EndInit();
            panelEx3.ResumeLayout(false);
            panelEx3.PerformLayout();
            this.gbInscriptionType.ResumeLayout(false);
            this.tabPanelRegisterInfo.ResumeLayout(false);
            panelEx2.ResumeLayout(false);
            panelEx2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Athlete)).EndInit();
            panelEx1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.adv_RegisterTree)).EndInit();
            this.adv_RegisterTree.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.cmd_Register)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.btn_Update)).EndInit();
            this.EditMembercontextMenu.ResumeLayout(false);
            this.RegistercontextMenu.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.TabControlPanel tabPanelRegisterInfo;
        private DevComponents.DotNetBar.TabItem tabRegister;
        private DevComponents.AdvTree.AdvTree adv_RegisterTree;
        private DevComponents.DotNetBar.ContextMenuBar cmd_Register;
        private DevComponents.DotNetBar.ButtonItem bm_AllMenu;
        private DevComponents.DotNetBar.ButtonItem bm_AddTeam;
        private DevComponents.DotNetBar.ButtonItem bm_AddPair;
        private DevComponents.DotNetBar.ButtonItem bm_AddAthlete;
        private DevComponents.DotNetBar.ButtonItem bm_AddNonAthlete;
        private DevComponents.DotNetBar.ButtonItem bm_DelTeam;
        private DevComponents.DotNetBar.ButtonItem bm_DelPair;
        private DevComponents.DotNetBar.ButtonItem bm_EditItem;
        private DevComponents.DotNetBar.ButtonItem bm_EditFederation;
        private DevComponents.AdvTree.NodeConnector nodeConnector1;
        private UIImageButton btn_Update;
        private UIButton btn_Delegation;
        private UIDataGridView dgv_Athlete;
        private UIComboBox cmbFliter;
        private UISymbolButton btn_EditRegister;
        private UISymbolButton btn_DelRegister;
        private UILabel lbFliter;
        private DevComponents.DotNetBar.TabControlPanel tabPanelInscription;
        private DevComponents.DotNetBar.TabItem tabInscription;
        private UIPanel panelLeft;
        private UIButton btnAllInscribe;
        private UISymbolButton btnRefresh;
        private UIDataGridView dgvFederation;
        private UIComboBox cmbEvent;
        private UILabel lbEvent;
        private UIGroupBox gbInscriptionType;
        private UIRadioButton radioRegister;
        private UIRadioButton radioEvent;
        private System.Windows.Forms.Splitter splitter4;
        private System.Windows.Forms.Splitter splitter5;
        private UIPanel panelRegister;
        private UIDataGridView dgvPlayer;
        private UIButton btnDelAll;
        private UILabel lbRegister;
        private UIButton btnDel;
        private UIPanel panelAvailable;
        private UIComboBox cmbRegTypeFliter;
        private UIComboBox cmbAthleteFliter;
        private UILabel lbRegTypeFliter;
        private UIDataGridView dgvAvailable;
        private UILabel lbAvailable;
        private UIButton btnAddAll;
        private UIButton btnAdd;
        private System.Windows.Forms.ContextMenuStrip EditMembercontextMenu;
        private System.Windows.Forms.ToolStripMenuItem MenuEditMember;
        private System.Windows.Forms.ContextMenuStrip RegistercontextMenu;
        private System.Windows.Forms.ToolStripMenuItem MenuAdd;
        private System.Windows.Forms.ToolStripMenuItem MenuDelete;
        private System.Windows.Forms.ToolStripMenuItem MenuEdit;
        private System.Windows.Forms.ImageList TreeimageList;
        private DevComponents.DotNetBar.ElementStyle elementStyle1;
        private UIButton btn_Register;
        private UILabel lbGroup;
        private UIComboBox cmbGroup;
        private DevComponents.DotNetBar.ButtonItem bm_AddHorse;
        private System.Windows.Forms.ToolStripMenuItem HorseInscription;
    }
}

