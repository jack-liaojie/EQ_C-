using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    partial class frmOVREQDataEntry
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
            this.btnx_Exit = new Sunny.UI.UIButton();
            this.btnx_Judges = new Sunny.UI.UIButton();
            this.g_MatchInfo = new System.Windows.Forms.GroupBox();
            this.asServiceControl1 = new AsServiceControlLib.AsServiceControl();
            this.chkX_ShowAll = new System.Windows.Forms.CheckBox();
            this.chkX_AutoSCB = new System.Windows.Forms.CheckBox();
            this.g_NetServer = new System.Windows.Forms.GroupBox();
            this.labX_ListenPort = new DevComponents.DotNetBar.LabelX();
            this.chkX_Listen = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.txtBoxX_ListenPort = new DevComponents.DotNetBar.Controls.TextBoxX();
            this.g_NetClient = new System.Windows.Forms.GroupBox();
            this.labX_ConnectPort = new DevComponents.DotNetBar.LabelX();
            this.chkX_Connect = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.txtBoxX_ConnectPort = new DevComponents.DotNetBar.Controls.TextBoxX();
            this.labX_IP = new DevComponents.DotNetBar.LabelX();
            this.ipAddressInput = new DevComponents.Editors.IpAddressInput();
            this.btnx_ClearData = new Sunny.UI.UIButton();
            this.btnx_TeamResult = new Sunny.UI.UIButton();
            this.lb_DateDes = new System.Windows.Forms.Label();
            this.lb_Date = new System.Windows.Forms.Label();
            this.btnx_Refresh = new Sunny.UI.UIButton();
            this.lb_MatchDes = new System.Windows.Forms.Label();
            this.lb_EventDes = new System.Windows.Forms.Label();
            this.btnx_Status = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Schedule = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_StartList = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Running = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Suspend = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Unofficial = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Finished = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Revision = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Canceled = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Config = new Sunny.UI.UIButton();
            this.lb_Event = new System.Windows.Forms.Label();
            this.lb_Match = new System.Windows.Forms.Label();
            this.g_MatchScore = new System.Windows.Forms.GroupBox();
            this.dgvMatchResults = new Sunny.UI.UIDataGridView();
            this.g_MatchScoreDetail = new System.Windows.Forms.GroupBox();
            this.dgvMatchPenType = new Sunny.UI.UIDataGridView();
            this.dgvMatchResultDetails = new Sunny.UI.UIDataGridView();
            this.MenuStrip_StartTime = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.toolStripMenuItem_EditStartTime = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem_EditBreakTime = new System.Windows.Forms.ToolStripMenuItem();
            this.MenuStrip_Status1 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.toolStripMenuItem_Status_NotStarted = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem_Status_Started = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem_Status_Finished = new System.Windows.Forms.ToolStripMenuItem();
            this.MenuStrip_JPTime = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.toolStripMenuItem_JPTime_Modify = new System.Windows.Forms.ToolStripMenuItem();
            this.MenuStrip_Status2 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.toolStripMenuItem_Status_NotValidated = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem_Status_Validated = new System.Windows.Forms.ToolStripMenuItem();
            this.g_MatchInfo.SuspendLayout();
            this.g_NetServer.SuspendLayout();
            this.g_NetClient.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.ipAddressInput)).BeginInit();
            this.g_MatchScore.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchResults)).BeginInit();
            this.g_MatchScoreDetail.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchPenType)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchResultDetails)).BeginInit();
            this.MenuStrip_StartTime.SuspendLayout();
            this.MenuStrip_Status1.SuspendLayout();
            this.MenuStrip_JPTime.SuspendLayout();
            this.MenuStrip_Status2.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnx_Exit
            // 
            this.btnx_Exit.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Exit.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnx_Exit.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnx_Exit.Location = new System.Drawing.Point(595, 53);
            this.btnx_Exit.Name = "btnx_Exit";
            this.btnx_Exit.Size = new System.Drawing.Size(100, 25);
            this.btnx_Exit.TabIndex = 0;
            this.btnx_Exit.Text = "Exit";
            this.btnx_Exit.Click += new System.EventHandler(this.btnx_Exit_Click);
            // 
            // btnx_Judges
            // 
            this.btnx_Judges.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Judges.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnx_Judges.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnx_Judges.Location = new System.Drawing.Point(486, 53);
            this.btnx_Judges.Name = "btnx_Judges";
            this.btnx_Judges.Size = new System.Drawing.Size(100, 25);
            this.btnx_Judges.TabIndex = 1;
            this.btnx_Judges.Text = "Judges";
            this.btnx_Judges.Click += new System.EventHandler(this.btnx_Judges_Click);
            // 
            // g_MatchInfo
            // 
            this.g_MatchInfo.Controls.Add(this.asServiceControl1);
            this.g_MatchInfo.Controls.Add(this.chkX_ShowAll);
            this.g_MatchInfo.Controls.Add(this.chkX_AutoSCB);
            this.g_MatchInfo.Controls.Add(this.g_NetServer);
            this.g_MatchInfo.Controls.Add(this.g_NetClient);
            this.g_MatchInfo.Controls.Add(this.btnx_ClearData);
            this.g_MatchInfo.Controls.Add(this.btnx_TeamResult);
            this.g_MatchInfo.Controls.Add(this.lb_DateDes);
            this.g_MatchInfo.Controls.Add(this.lb_Date);
            this.g_MatchInfo.Controls.Add(this.btnx_Refresh);
            this.g_MatchInfo.Controls.Add(this.lb_MatchDes);
            this.g_MatchInfo.Controls.Add(this.lb_EventDes);
            this.g_MatchInfo.Controls.Add(this.btnx_Status);
            this.g_MatchInfo.Controls.Add(this.btnx_Config);
            this.g_MatchInfo.Controls.Add(this.lb_Event);
            this.g_MatchInfo.Controls.Add(this.lb_Match);
            this.g_MatchInfo.Controls.Add(this.btnx_Exit);
            this.g_MatchInfo.Controls.Add(this.btnx_Judges);
            this.g_MatchInfo.Dock = System.Windows.Forms.DockStyle.Top;
            this.g_MatchInfo.Font = new System.Drawing.Font("宋体", 9F);
            this.g_MatchInfo.Location = new System.Drawing.Point(0, 0);
            this.g_MatchInfo.Name = "g_MatchInfo";
            this.g_MatchInfo.Size = new System.Drawing.Size(1415, 114);
            this.g_MatchInfo.TabIndex = 2;
            this.g_MatchInfo.TabStop = false;
            this.g_MatchInfo.Text = "MatchInfo";
            // 
            // asServiceControl1
            // 
            this.asServiceControl1.Location = new System.Drawing.Point(1165, 40);
            this.asServiceControl1.Margin = new System.Windows.Forms.Padding(0);
            this.asServiceControl1.Name = "asServiceControl1";
            this.asServiceControl1.Size = new System.Drawing.Size(164, 28);
            this.asServiceControl1.TabIndex = 59;
            this.asServiceControl1.Visible = false;
            // 
            // chkX_ShowAll
            // 
            this.chkX_ShowAll.AutoSize = true;
            this.chkX_ShowAll.Location = new System.Drawing.Point(1046, 40);
            this.chkX_ShowAll.Name = "chkX_ShowAll";
            this.chkX_ShowAll.Size = new System.Drawing.Size(66, 16);
            this.chkX_ShowAll.TabIndex = 58;
            this.chkX_ShowAll.Text = "ShowAll";
            this.chkX_ShowAll.UseVisualStyleBackColor = true;
            this.chkX_ShowAll.CheckedChanged += new System.EventHandler(this.chkX_ShowAll_CheckedChanged);
            // 
            // chkX_AutoSCB
            // 
            this.chkX_AutoSCB.AutoSize = true;
            this.chkX_AutoSCB.Location = new System.Drawing.Point(1046, 63);
            this.chkX_AutoSCB.Name = "chkX_AutoSCB";
            this.chkX_AutoSCB.Size = new System.Drawing.Size(66, 16);
            this.chkX_AutoSCB.TabIndex = 57;
            this.chkX_AutoSCB.Text = "AutoSCB";
            this.chkX_AutoSCB.UseVisualStyleBackColor = true;
            this.chkX_AutoSCB.CheckedChanged += new System.EventHandler(this.chkX_AutoSCB_CheckedChanged);
            // 
            // g_NetServer
            // 
            this.g_NetServer.Controls.Add(this.labX_ListenPort);
            this.g_NetServer.Controls.Add(this.chkX_Listen);
            this.g_NetServer.Controls.Add(this.txtBoxX_ListenPort);
            this.g_NetServer.Location = new System.Drawing.Point(706, 14);
            this.g_NetServer.Name = "g_NetServer";
            this.g_NetServer.Size = new System.Drawing.Size(104, 65);
            this.g_NetServer.TabIndex = 56;
            this.g_NetServer.TabStop = false;
            this.g_NetServer.Text = "Server";
            // 
            // labX_ListenPort
            // 
            // 
            // 
            // 
            this.labX_ListenPort.BackgroundStyle.Class = "";
            this.labX_ListenPort.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_ListenPort.Location = new System.Drawing.Point(6, 21);
            this.labX_ListenPort.Name = "labX_ListenPort";
            this.labX_ListenPort.Size = new System.Drawing.Size(36, 21);
            this.labX_ListenPort.TabIndex = 54;
            this.labX_ListenPort.Text = "Port";
            // 
            // chkX_Listen
            // 
            // 
            // 
            // 
            this.chkX_Listen.BackgroundStyle.Class = "";
            this.chkX_Listen.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.chkX_Listen.Location = new System.Drawing.Point(6, 43);
            this.chkX_Listen.Name = "chkX_Listen";
            this.chkX_Listen.Size = new System.Drawing.Size(69, 21);
            this.chkX_Listen.TabIndex = 50;
            this.chkX_Listen.Text = "Listen";
            this.chkX_Listen.CheckedChanged += new System.EventHandler(this.chkX_Listen_CheckedChanged);
            // 
            // txtBoxX_ListenPort
            // 
            // 
            // 
            // 
            this.txtBoxX_ListenPort.Border.Class = "TextBoxBorder";
            this.txtBoxX_ListenPort.Border.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.txtBoxX_ListenPort.Location = new System.Drawing.Point(43, 21);
            this.txtBoxX_ListenPort.Name = "txtBoxX_ListenPort";
            this.txtBoxX_ListenPort.Size = new System.Drawing.Size(50, 21);
            this.txtBoxX_ListenPort.TabIndex = 52;
            // 
            // g_NetClient
            // 
            this.g_NetClient.Controls.Add(this.labX_ConnectPort);
            this.g_NetClient.Controls.Add(this.chkX_Connect);
            this.g_NetClient.Controls.Add(this.txtBoxX_ConnectPort);
            this.g_NetClient.Controls.Add(this.labX_IP);
            this.g_NetClient.Controls.Add(this.ipAddressInput);
            this.g_NetClient.Location = new System.Drawing.Point(816, 14);
            this.g_NetClient.Name = "g_NetClient";
            this.g_NetClient.Size = new System.Drawing.Size(180, 65);
            this.g_NetClient.TabIndex = 55;
            this.g_NetClient.TabStop = false;
            this.g_NetClient.Text = "Client";
            // 
            // labX_ConnectPort
            // 
            // 
            // 
            // 
            this.labX_ConnectPort.BackgroundStyle.Class = "";
            this.labX_ConnectPort.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_ConnectPort.Location = new System.Drawing.Point(5, 43);
            this.labX_ConnectPort.Name = "labX_ConnectPort";
            this.labX_ConnectPort.Size = new System.Drawing.Size(36, 21);
            this.labX_ConnectPort.TabIndex = 54;
            this.labX_ConnectPort.Text = "Port";
            // 
            // chkX_Connect
            // 
            // 
            // 
            // 
            this.chkX_Connect.BackgroundStyle.Class = "";
            this.chkX_Connect.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.chkX_Connect.Location = new System.Drawing.Point(98, 43);
            this.chkX_Connect.Name = "chkX_Connect";
            this.chkX_Connect.Size = new System.Drawing.Size(69, 21);
            this.chkX_Connect.TabIndex = 50;
            this.chkX_Connect.Text = "Connect";
            this.chkX_Connect.CheckedChanged += new System.EventHandler(this.chkX_Connect_CheckedChanged);
            // 
            // txtBoxX_ConnectPort
            // 
            // 
            // 
            // 
            this.txtBoxX_ConnectPort.Border.Class = "TextBoxBorder";
            this.txtBoxX_ConnectPort.Border.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.txtBoxX_ConnectPort.Location = new System.Drawing.Point(42, 43);
            this.txtBoxX_ConnectPort.Name = "txtBoxX_ConnectPort";
            this.txtBoxX_ConnectPort.Size = new System.Drawing.Size(50, 21);
            this.txtBoxX_ConnectPort.TabIndex = 52;
            // 
            // labX_IP
            // 
            // 
            // 
            // 
            this.labX_IP.BackgroundStyle.Class = "";
            this.labX_IP.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_IP.Location = new System.Drawing.Point(4, 15);
            this.labX_IP.Name = "labX_IP";
            this.labX_IP.Size = new System.Drawing.Size(39, 21);
            this.labX_IP.TabIndex = 53;
            this.labX_IP.Text = "IP";
            // 
            // ipAddressInput
            // 
            this.ipAddressInput.AutoOverwrite = true;
            // 
            // 
            // 
            this.ipAddressInput.BackgroundStyle.Class = "DateTimeInputBackground";
            this.ipAddressInput.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.ipAddressInput.ButtonFreeText.Shortcut = DevComponents.DotNetBar.eShortcut.F2;
            this.ipAddressInput.ButtonFreeText.Visible = true;
            this.ipAddressInput.Location = new System.Drawing.Point(42, 18);
            this.ipAddressInput.Name = "ipAddressInput";
            this.ipAddressInput.Size = new System.Drawing.Size(130, 21);
            this.ipAddressInput.TabIndex = 51;
            // 
            // btnx_ClearData
            // 
            this.btnx_ClearData.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_ClearData.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnx_ClearData.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnx_ClearData.Location = new System.Drawing.Point(1046, 14);
            this.btnx_ClearData.Name = "btnx_ClearData";
            this.btnx_ClearData.Size = new System.Drawing.Size(66, 19);
            this.btnx_ClearData.TabIndex = 49;
            this.btnx_ClearData.Text = "Clear Data";
            this.btnx_ClearData.Click += new System.EventHandler(this.btnx_ClearData_Click);
            // 
            // btnx_TeamResult
            // 
            this.btnx_TeamResult.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_TeamResult.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnx_TeamResult.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnx_TeamResult.Location = new System.Drawing.Point(340, 21);
            this.btnx_TeamResult.Name = "btnx_TeamResult";
            this.btnx_TeamResult.Size = new System.Drawing.Size(100, 25);
            this.btnx_TeamResult.TabIndex = 1;
            this.btnx_TeamResult.Text = "Team Result";
            this.btnx_TeamResult.Visible = false;
            this.btnx_TeamResult.Click += new System.EventHandler(this.btnx_Team_Click);
            // 
            // lb_DateDes
            // 
            this.lb_DateDes.AutoSize = true;
            this.lb_DateDes.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lb_DateDes.Location = new System.Drawing.Point(54, 44);
            this.lb_DateDes.Name = "lb_DateDes";
            this.lb_DateDes.Size = new System.Drawing.Size(54, 12);
            this.lb_DateDes.TabIndex = 48;
            this.lb_DateDes.Text = "DateDes";
            // 
            // lb_Date
            // 
            this.lb_Date.AutoSize = true;
            this.lb_Date.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lb_Date.Location = new System.Drawing.Point(17, 44);
            this.lb_Date.Name = "lb_Date";
            this.lb_Date.Size = new System.Drawing.Size(35, 12);
            this.lb_Date.TabIndex = 47;
            this.lb_Date.Text = "Date:";
            // 
            // btnx_Refresh
            // 
            this.btnx_Refresh.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Refresh.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnx_Refresh.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnx_Refresh.Location = new System.Drawing.Point(340, 56);
            this.btnx_Refresh.Name = "btnx_Refresh";
            this.btnx_Refresh.Size = new System.Drawing.Size(100, 23);
            this.btnx_Refresh.TabIndex = 50;
            this.btnx_Refresh.Text = "Refresh";
            this.btnx_Refresh.Click += new System.EventHandler(this.btnx_Refresh_Click);
            // 
            // lb_MatchDes
            // 
            this.lb_MatchDes.AutoSize = true;
            this.lb_MatchDes.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lb_MatchDes.Location = new System.Drawing.Point(54, 67);
            this.lb_MatchDes.Name = "lb_MatchDes";
            this.lb_MatchDes.Size = new System.Drawing.Size(61, 12);
            this.lb_MatchDes.TabIndex = 46;
            this.lb_MatchDes.Text = "MatchDes";
            // 
            // lb_EventDes
            // 
            this.lb_EventDes.AutoSize = true;
            this.lb_EventDes.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lb_EventDes.Location = new System.Drawing.Point(54, 21);
            this.lb_EventDes.Name = "lb_EventDes";
            this.lb_EventDes.Size = new System.Drawing.Size(61, 12);
            this.lb_EventDes.TabIndex = 44;
            this.lb_EventDes.Text = "EventDes";
            // 
            // btnx_Status
            // 
            this.btnx_Status.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Status.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Status.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnx_Status.Location = new System.Drawing.Point(595, 21);
            this.btnx_Status.Name = "btnx_Status";
            this.btnx_Status.Size = new System.Drawing.Size(100, 25);
            this.btnx_Status.SubItems.AddRange(new DevComponents.DotNetBar.BaseItem[] {
            this.btnx_Schedule,
            this.btnx_StartList,
            this.btnx_Running,
            this.btnx_Suspend,
            this.btnx_Unofficial,
            this.btnx_Finished,
            this.btnx_Revision,
            this.btnx_Canceled});
            this.btnx_Status.TabIndex = 43;
            this.btnx_Status.Text = "Match Status";
            // 
            // btnx_Schedule
            // 
            this.btnx_Schedule.Name = "btnx_Schedule";
            this.btnx_Schedule.Text = "Schedule";
            this.btnx_Schedule.Click += new System.EventHandler(this.btnx_Schedule_Click);
            // 
            // btnx_StartList
            // 
            this.btnx_StartList.Name = "btnx_StartList";
            this.btnx_StartList.Text = "StartList";
            this.btnx_StartList.Click += new System.EventHandler(this.btnx_StartList_Click);
            // 
            // btnx_Running
            // 
            this.btnx_Running.Name = "btnx_Running";
            this.btnx_Running.Text = "Running";
            this.btnx_Running.Click += new System.EventHandler(this.btnx_Running_Click);
            // 
            // btnx_Suspend
            // 
            this.btnx_Suspend.Name = "btnx_Suspend";
            this.btnx_Suspend.Text = "Suspend";
            this.btnx_Suspend.Click += new System.EventHandler(this.btnx_Suspend_Click);
            // 
            // btnx_Unofficial
            // 
            this.btnx_Unofficial.Name = "btnx_Unofficial";
            this.btnx_Unofficial.Text = "Unofficial";
            this.btnx_Unofficial.Click += new System.EventHandler(this.btnx_Unofficial_Click);
            // 
            // btnx_Finished
            // 
            this.btnx_Finished.Name = "btnx_Finished";
            this.btnx_Finished.Text = "Offical";
            this.btnx_Finished.Click += new System.EventHandler(this.btnx_Finished_Click);
            // 
            // btnx_Revision
            // 
            this.btnx_Revision.Name = "btnx_Revision";
            this.btnx_Revision.Text = "Revision";
            this.btnx_Revision.Click += new System.EventHandler(this.btnx_Revision_Click);
            // 
            // btnx_Canceled
            // 
            this.btnx_Canceled.Name = "btnx_Canceled";
            this.btnx_Canceled.Text = "Canceled";
            this.btnx_Canceled.Click += new System.EventHandler(this.btnx_Canceled_Click);
            // 
            // btnx_Config
            // 
            this.btnx_Config.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Config.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnx_Config.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnx_Config.Location = new System.Drawing.Point(486, 21);
            this.btnx_Config.Name = "btnx_Config";
            this.btnx_Config.Size = new System.Drawing.Size(100, 25);
            this.btnx_Config.TabIndex = 5;
            this.btnx_Config.Text = "Match Config";
            this.btnx_Config.Click += new System.EventHandler(this.btnx_Config_Click);
            // 
            // lb_Event
            // 
            this.lb_Event.AutoSize = true;
            this.lb_Event.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lb_Event.Location = new System.Drawing.Point(17, 21);
            this.lb_Event.Name = "lb_Event";
            this.lb_Event.Size = new System.Drawing.Size(41, 12);
            this.lb_Event.TabIndex = 4;
            this.lb_Event.Text = "Event:";
            // 
            // lb_Match
            // 
            this.lb_Match.AutoSize = true;
            this.lb_Match.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lb_Match.Location = new System.Drawing.Point(17, 67);
            this.lb_Match.Name = "lb_Match";
            this.lb_Match.Size = new System.Drawing.Size(41, 12);
            this.lb_Match.TabIndex = 3;
            this.lb_Match.Text = "Match:";
            // 
            // g_MatchScore
            // 
            this.g_MatchScore.Controls.Add(this.dgvMatchResults);
            this.g_MatchScore.Dock = System.Windows.Forms.DockStyle.Fill;
            this.g_MatchScore.Font = new System.Drawing.Font("宋体", 9F);
            this.g_MatchScore.Location = new System.Drawing.Point(0, 114);
            this.g_MatchScore.Name = "g_MatchScore";
            this.g_MatchScore.Size = new System.Drawing.Size(1415, 511);
            this.g_MatchScore.TabIndex = 3;
            this.g_MatchScore.TabStop = false;
            this.g_MatchScore.Text = "MatchScore";
            // 
            // dgvMatchResults
            // 
            this.dgvMatchResults.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvMatchResults.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvMatchResults.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvMatchResults.BackgroundColor = System.Drawing.Color.White;
            this.dgvMatchResults.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvMatchResults.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvMatchResults.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvMatchResults.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchResults.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvMatchResults.EnableHeadersVisualStyles = false;
            this.dgvMatchResults.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvMatchResults.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMatchResults.Location = new System.Drawing.Point(3, 17);
            this.dgvMatchResults.Name = "dgvMatchResults";
            this.dgvMatchResults.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMatchResults.RowHeadersVisible = false;
            dataGridViewCellStyle3.BackColor = System.Drawing.Color.White;
            this.dgvMatchResults.RowsDefaultCellStyle = dataGridViewCellStyle3;
            this.dgvMatchResults.RowTemplate.Height = 29;
            this.dgvMatchResults.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvMatchResults.SelectedIndex = -1;
            this.dgvMatchResults.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvMatchResults.Size = new System.Drawing.Size(1409, 491);
            this.dgvMatchResults.Style = Sunny.UI.UIStyle.Custom;
            this.dgvMatchResults.TabIndex = 0;
            this.dgvMatchResults.TagString = null;
            this.dgvMatchResults.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvMatchResults_CellBeginEdit);
            this.dgvMatchResults.CellMouseDown += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgvMatchResults_CellMouseDown);
            this.dgvMatchResults.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgvMatchResults_CellValidating);
            this.dgvMatchResults.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchResults_CellValueChanged);
            this.dgvMatchResults.SelectionChanged += new System.EventHandler(this.dgvMatchResults_SelectionChanged);
            // 
            // g_MatchScoreDetail
            // 
            this.g_MatchScoreDetail.Controls.Add(this.dgvMatchPenType);
            this.g_MatchScoreDetail.Controls.Add(this.dgvMatchResultDetails);
            this.g_MatchScoreDetail.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.g_MatchScoreDetail.Font = new System.Drawing.Font("宋体", 9F);
            this.g_MatchScoreDetail.Location = new System.Drawing.Point(0, 625);
            this.g_MatchScoreDetail.Name = "g_MatchScoreDetail";
            this.g_MatchScoreDetail.Size = new System.Drawing.Size(1415, 179);
            this.g_MatchScoreDetail.TabIndex = 4;
            this.g_MatchScoreDetail.TabStop = false;
            this.g_MatchScoreDetail.Text = "MatchScoreDetail";
            // 
            // dgvMatchPenType
            // 
            this.dgvMatchPenType.AllowUserToAddRows = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvMatchPenType.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvMatchPenType.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvMatchPenType.BackgroundColor = System.Drawing.Color.White;
            this.dgvMatchPenType.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvMatchPenType.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle5.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle5.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle5.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle5.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle5.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle5.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle5.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvMatchPenType.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle5;
            this.dgvMatchPenType.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchPenType.EnableHeadersVisualStyles = false;
            this.dgvMatchPenType.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvMatchPenType.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMatchPenType.Location = new System.Drawing.Point(880, 20);
            this.dgvMatchPenType.Name = "dgvMatchPenType";
            this.dgvMatchPenType.ReadOnly = true;
            this.dgvMatchPenType.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMatchPenType.RowHeadersVisible = false;
            dataGridViewCellStyle6.BackColor = System.Drawing.Color.White;
            this.dgvMatchPenType.RowsDefaultCellStyle = dataGridViewCellStyle6;
            this.dgvMatchPenType.RowTemplate.Height = 29;
            this.dgvMatchPenType.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvMatchPenType.SelectedIndex = -1;
            this.dgvMatchPenType.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvMatchPenType.Size = new System.Drawing.Size(223, 151);
            this.dgvMatchPenType.Style = Sunny.UI.UIStyle.Custom;
            this.dgvMatchPenType.TabIndex = 1;
            this.dgvMatchPenType.TagString = null;
            // 
            // dgvMatchResultDetails
            // 
            this.dgvMatchResultDetails.AllowUserToAddRows = false;
            dataGridViewCellStyle7.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvMatchResultDetails.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle7;
            this.dgvMatchResultDetails.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvMatchResultDetails.BackgroundColor = System.Drawing.Color.White;
            this.dgvMatchResultDetails.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvMatchResultDetails.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle8.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle8.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle8.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle8.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle8.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle8.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle8.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvMatchResultDetails.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle8;
            this.dgvMatchResultDetails.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchResultDetails.EnableHeadersVisualStyles = false;
            this.dgvMatchResultDetails.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvMatchResultDetails.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMatchResultDetails.Location = new System.Drawing.Point(12, 20);
            this.dgvMatchResultDetails.Name = "dgvMatchResultDetails";
            this.dgvMatchResultDetails.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMatchResultDetails.RowHeadersVisible = false;
            dataGridViewCellStyle9.BackColor = System.Drawing.Color.White;
            this.dgvMatchResultDetails.RowsDefaultCellStyle = dataGridViewCellStyle9;
            this.dgvMatchResultDetails.RowTemplate.Height = 29;
            this.dgvMatchResultDetails.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvMatchResultDetails.SelectedIndex = -1;
            this.dgvMatchResultDetails.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvMatchResultDetails.Size = new System.Drawing.Size(850, 151);
            this.dgvMatchResultDetails.Style = Sunny.UI.UIStyle.Custom;
            this.dgvMatchResultDetails.TabIndex = 0;
            this.dgvMatchResultDetails.TagString = null;
            this.dgvMatchResultDetails.CellMouseDown += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgvMatchResultDetails_CellMouseDown);
            this.dgvMatchResultDetails.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgvMatchResultDetails_CellValidating);
            this.dgvMatchResultDetails.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchResultDetails_CellValueChanged);
            // 
            // MenuStrip_StartTime
            // 
            this.MenuStrip_StartTime.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem_EditStartTime,
            this.toolStripMenuItem_EditBreakTime});
            this.MenuStrip_StartTime.Name = "MenuStrip_AllStatus";
            this.MenuStrip_StartTime.Size = new System.Drawing.Size(169, 48);
            // 
            // toolStripMenuItem_EditStartTime
            // 
            this.toolStripMenuItem_EditStartTime.Name = "toolStripMenuItem_EditStartTime";
            this.toolStripMenuItem_EditStartTime.Size = new System.Drawing.Size(168, 22);
            this.toolStripMenuItem_EditStartTime.Text = "Edit Start Time";
            this.toolStripMenuItem_EditStartTime.Click += new System.EventHandler(this.toolStripMenuItem_EditStartTime_Click);
            // 
            // toolStripMenuItem_EditBreakTime
            // 
            this.toolStripMenuItem_EditBreakTime.Name = "toolStripMenuItem_EditBreakTime";
            this.toolStripMenuItem_EditBreakTime.Size = new System.Drawing.Size(168, 22);
            this.toolStripMenuItem_EditBreakTime.Text = "Edit Break Time";
            this.toolStripMenuItem_EditBreakTime.Click += new System.EventHandler(this.toolStripMenuItem_EditBreakTime_Click);
            // 
            // MenuStrip_Status1
            // 
            this.MenuStrip_Status1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem_Status_NotStarted,
            this.toolStripMenuItem_Status_Started,
            this.toolStripMenuItem_Status_Finished});
            this.MenuStrip_Status1.Name = "MenuStrip_SelStatus";
            this.MenuStrip_Status1.Size = new System.Drawing.Size(145, 70);
            // 
            // toolStripMenuItem_Status_NotStarted
            // 
            this.toolStripMenuItem_Status_NotStarted.Name = "toolStripMenuItem_Status_NotStarted";
            this.toolStripMenuItem_Status_NotStarted.Size = new System.Drawing.Size(144, 22);
            this.toolStripMenuItem_Status_NotStarted.Text = "Not Started";
            this.toolStripMenuItem_Status_NotStarted.Click += new System.EventHandler(this.toolStripMenuItem_Status_NotStarted_Click);
            // 
            // toolStripMenuItem_Status_Started
            // 
            this.toolStripMenuItem_Status_Started.Name = "toolStripMenuItem_Status_Started";
            this.toolStripMenuItem_Status_Started.Size = new System.Drawing.Size(144, 22);
            this.toolStripMenuItem_Status_Started.Text = "Started";
            this.toolStripMenuItem_Status_Started.Click += new System.EventHandler(this.toolStripMenuItem_Status_Started_Click);
            // 
            // toolStripMenuItem_Status_Finished
            // 
            this.toolStripMenuItem_Status_Finished.Name = "toolStripMenuItem_Status_Finished";
            this.toolStripMenuItem_Status_Finished.Size = new System.Drawing.Size(144, 22);
            this.toolStripMenuItem_Status_Finished.Text = "Finished";
            this.toolStripMenuItem_Status_Finished.Click += new System.EventHandler(this.toolStripMenuItem_Status_Finished_Click);
            // 
            // MenuStrip_JPTime
            // 
            this.MenuStrip_JPTime.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem_JPTime_Modify});
            this.MenuStrip_JPTime.Name = "MenuStrip_AllStatus";
            this.MenuStrip_JPTime.Size = new System.Drawing.Size(150, 26);
            // 
            // toolStripMenuItem_JPTime_Modify
            // 
            this.toolStripMenuItem_JPTime_Modify.Name = "toolStripMenuItem_JPTime_Modify";
            this.toolStripMenuItem_JPTime_Modify.Size = new System.Drawing.Size(149, 22);
            this.toolStripMenuItem_JPTime_Modify.Text = "Modify Time";
            this.toolStripMenuItem_JPTime_Modify.Click += new System.EventHandler(this.toolStripMenuItem_JPTime_Modify_Click);
            // 
            // MenuStrip_Status2
            // 
            this.MenuStrip_Status2.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem_Status_NotValidated,
            this.toolStripMenuItem_Status_Validated});
            this.MenuStrip_Status2.Name = "MenuStrip_SelStatus";
            this.MenuStrip_Status2.Size = new System.Drawing.Size(158, 48);
            // 
            // toolStripMenuItem_Status_NotValidated
            // 
            this.toolStripMenuItem_Status_NotValidated.Name = "toolStripMenuItem_Status_NotValidated";
            this.toolStripMenuItem_Status_NotValidated.Size = new System.Drawing.Size(157, 22);
            this.toolStripMenuItem_Status_NotValidated.Text = "Not Validated";
            this.toolStripMenuItem_Status_NotValidated.Click += new System.EventHandler(this.toolStripMenuItem_Status_NotValidated_Click);
            // 
            // toolStripMenuItem_Status_Validated
            // 
            this.toolStripMenuItem_Status_Validated.Name = "toolStripMenuItem_Status_Validated";
            this.toolStripMenuItem_Status_Validated.Size = new System.Drawing.Size(157, 22);
            this.toolStripMenuItem_Status_Validated.Text = "Validated";
            this.toolStripMenuItem_Status_Validated.Click += new System.EventHandler(this.toolStripMenuItem_Status_Validated_Click);
            // 
            // frmOVREQDataEntry
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1415, 804);
            this.Controls.Add(this.g_MatchScore);
            this.Controls.Add(this.g_MatchInfo);
            this.Controls.Add(this.g_MatchScoreDetail);
            this.Name = "frmOVREQDataEntry";
            this.Text = "frmOVREQDataEntry";
            this.Load += new System.EventHandler(this.frmOVREQDataEntry_Load);
            this.g_MatchInfo.ResumeLayout(false);
            this.g_MatchInfo.PerformLayout();
            this.g_NetServer.ResumeLayout(false);
            this.g_NetClient.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.ipAddressInput)).EndInit();
            this.g_MatchScore.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchResults)).EndInit();
            this.g_MatchScoreDetail.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchPenType)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchResultDetails)).EndInit();
            this.MenuStrip_StartTime.ResumeLayout(false);
            this.MenuStrip_Status1.ResumeLayout(false);
            this.MenuStrip_JPTime.ResumeLayout(false);
            this.MenuStrip_Status2.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private UIButton btnx_Exit;
        private UIButton btnx_Judges;
        private System.Windows.Forms.GroupBox g_MatchInfo;
        private System.Windows.Forms.GroupBox g_MatchScore;
        private System.Windows.Forms.GroupBox g_MatchScoreDetail;
        private UIDataGridView dgvMatchResults;
        private UIDataGridView dgvMatchResultDetails;
        private System.Windows.Forms.Label lb_Event;
        private System.Windows.Forms.Label lb_Match;
        private UIButton btnx_Config;
        private DevComponents.DotNetBar.ButtonX btnx_Status;
        private DevComponents.DotNetBar.ButtonItem btnx_Schedule;
        private DevComponents.DotNetBar.ButtonItem btnx_StartList;
        private DevComponents.DotNetBar.ButtonItem btnx_Running;
        private DevComponents.DotNetBar.ButtonItem btnx_Suspend;
        private DevComponents.DotNetBar.ButtonItem btnx_Unofficial;
        private DevComponents.DotNetBar.ButtonItem btnx_Finished;
        private DevComponents.DotNetBar.ButtonItem btnx_Revision;
        private DevComponents.DotNetBar.ButtonItem btnx_Canceled;
        private System.Windows.Forms.Label lb_EventDes;
        private System.Windows.Forms.Label lb_MatchDes;
        private System.Windows.Forms.Label lb_Date;
        private System.Windows.Forms.Label lb_DateDes;
        private UIButton btnx_TeamResult;
        private UIButton btnx_ClearData;
        private System.Windows.Forms.ContextMenuStrip MenuStrip_StartTime;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_EditStartTime;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_EditBreakTime;
        private System.Windows.Forms.GroupBox g_NetClient;
        private DevComponents.DotNetBar.LabelX labX_ConnectPort;
        private DevComponents.DotNetBar.Controls.CheckBoxX chkX_Connect;
        private DevComponents.DotNetBar.Controls.TextBoxX txtBoxX_ConnectPort;
        private DevComponents.DotNetBar.LabelX labX_IP;
        private DevComponents.Editors.IpAddressInput ipAddressInput;
        private System.Windows.Forms.GroupBox g_NetServer;
        private DevComponents.DotNetBar.LabelX labX_ListenPort;
        private DevComponents.DotNetBar.Controls.CheckBoxX chkX_Listen;
        private DevComponents.DotNetBar.Controls.TextBoxX txtBoxX_ListenPort;
        private System.Windows.Forms.ContextMenuStrip MenuStrip_Status1;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_Status_NotStarted;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_Status_Started;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_Status_Finished;
        private System.Windows.Forms.CheckBox chkX_AutoSCB;
        private System.Windows.Forms.ContextMenuStrip MenuStrip_JPTime;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_JPTime_Modify;
        private UIDataGridView dgvMatchPenType;
        private System.Windows.Forms.ContextMenuStrip MenuStrip_Status2;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_Status_NotValidated;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_Status_Validated;
        private System.Windows.Forms.CheckBox chkX_ShowAll;
        private UIButton btnx_Refresh;
        public AsServiceControlLib.AsServiceControl asServiceControl1;
    }
}