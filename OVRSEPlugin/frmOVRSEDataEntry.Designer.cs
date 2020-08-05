namespace AutoSports.OVRSEPlugin
{
    partial class frmOVRSEDataEntry
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
            System.Windows.Forms.Label lb_B;
            System.Windows.Forms.Label lb_A;
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            this.folderSelDlg = new System.Windows.Forms.FolderBrowserDialog();
            this.timerNetPath = new System.Windows.Forms.Timer(this.components);
            this.tabControlDataEntry = new DevComponents.DotNetBar.TabControl();
            this.tabControlPanel1 = new DevComponents.DotNetBar.TabControlPanel();
            this.gb_ImportResult = new System.Windows.Forms.GroupBox();
            this.btnxImHoopMatchInfo = new DevComponents.DotNetBar.ButtonX();
            this.btnxImStatistic = new DevComponents.DotNetBar.ButtonX();
            this.btnxExTeam = new DevComponents.DotNetBar.ButtonX();
            this.tbImportMsg = new DevComponents.DotNetBar.Controls.TextBoxX();
            this.chkAutoImport = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.chkOuterData = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.btnxHoopCompList = new DevComponents.DotNetBar.ButtonX();
            this.btnx_ExportHoopSchedule = new DevComponents.DotNetBar.ButtonX();
            this.btnxExSchedule = new DevComponents.DotNetBar.ButtonX();
            this.btnxImportAction = new DevComponents.DotNetBar.ButtonX();
            this.btnxImportMatchInfo = new DevComponents.DotNetBar.ButtonX();
            this.btnxExAthlete = new DevComponents.DotNetBar.ButtonX();
            this.btnxManualPathSel = new DevComponents.DotNetBar.ButtonX();
            this.btnxImPathSel = new DevComponents.DotNetBar.ButtonX();
            this.btnxExPathSel = new DevComponents.DotNetBar.ButtonX();
            this.tbManualPath = new DevComponents.DotNetBar.Controls.TextBoxX();
            this.tbImportPath = new DevComponents.DotNetBar.Controls.TextBoxX();
            this.tbExportPath = new DevComponents.DotNetBar.Controls.TextBoxX();
            this.cmbFilterDate = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.label3 = new System.Windows.Forms.Label();
            this.lb_ImportPath = new System.Windows.Forms.Label();
            this.lb_ExportPath = new System.Windows.Forms.Label();
            this.lb_SelectDate = new System.Windows.Forms.Label();
            this.gb_MatchResult = new System.Windows.Forms.GroupBox();
            this.labelX4 = new DevComponents.DotNetBar.LabelX();
            this.labelX3 = new DevComponents.DotNetBar.LabelX();
            this.tbMatchID = new DevComponents.DotNetBar.Controls.TextBoxX();
            this.tbRSC = new DevComponents.DotNetBar.Controls.TextBoxX();
            this.btnConvertRsc = new DevComponents.DotNetBar.ButtonX();
            this.gb_Server = new System.Windows.Forms.GroupBox();
            this.rad_ServerB = new System.Windows.Forms.RadioButton();
            this.rad_ServerA = new System.Windows.Forms.RadioButton();
            this.lb_B_GameTotal = new System.Windows.Forms.Label();
            this.lb_A_GameTotal = new System.Windows.Forms.Label();
            this.lb_GameTotal = new System.Windows.Forms.Label();
            this.lb_A_Game5 = new System.Windows.Forms.Label();
            this.lb_A_Game3 = new System.Windows.Forms.Label();
            this.lb_A_Game4 = new System.Windows.Forms.Label();
            this.lb_A_Game2 = new System.Windows.Forms.Label();
            this.lb_B_Game5 = new System.Windows.Forms.Label();
            this.lb_B_Game3 = new System.Windows.Forms.Label();
            this.lb_B_Game4 = new System.Windows.Forms.Label();
            this.lb_B_Game2 = new System.Windows.Forms.Label();
            this.lb_B_Game1 = new System.Windows.Forms.Label();
            this.lb_A_Game1 = new System.Windows.Forms.Label();
            this.rad_Game5 = new System.Windows.Forms.RadioButton();
            this.rad_Game4 = new System.Windows.Forms.RadioButton();
            this.rad_Game3 = new System.Windows.Forms.RadioButton();
            this.rad_Game2 = new System.Windows.Forms.RadioButton();
            this.rad_Game1 = new System.Windows.Forms.RadioButton();
            this.btnx_Match3 = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Match2 = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Match1 = new DevComponents.DotNetBar.ButtonX();
            this.btnx_B_Add = new DevComponents.DotNetBar.ButtonX();
            this.btnClearRes = new DevComponents.DotNetBar.ButtonX();
            this.btnx_A_Add = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Undo = new DevComponents.DotNetBar.ButtonX();
            this.dgvTeamB = new System.Windows.Forms.DataGridView();
            this.dgvTeamA = new System.Windows.Forms.DataGridView();
            this.gb_MatchInfo = new System.Windows.Forms.GroupBox();
            this.btnx_ModifyTime = new DevComponents.DotNetBar.ButtonX();
            this.btnScoreBoard = new DevComponents.DotNetBar.ButtonX();
            this.btnx_VisitorPlayer = new DevComponents.DotNetBar.ButtonX();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.btnx_Modify_Result = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Away_Sub = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Home_Sub = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Away_Add = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Home_Add = new DevComponents.DotNetBar.ButtonX();
            this.lb_TotalScore = new System.Windows.Forms.Label();
            this.lb_AwayDes = new System.Windows.Forms.Label();
            this.lb_HomeDes = new System.Windows.Forms.Label();
            this.lb_Away_Score = new System.Windows.Forms.Label();
            this.lb_Home_Score = new System.Windows.Forms.Label();
            this.lb_Sport = new System.Windows.Forms.Label();
            this.btnx_HomePlayer = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Exit = new DevComponents.DotNetBar.ButtonX();
            this.lb_DateDes = new System.Windows.Forms.Label();
            this.btnx_Status = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Schedule = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_StartList = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Running = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Suspend = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Unofficial = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Finished = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Revision = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Canceled = new DevComponents.DotNetBar.ButtonItem();
            this.lb_Date = new System.Windows.Forms.Label();
            this.lbRule = new System.Windows.Forms.Label();
            this.lbRSC = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.btnx_Official = new DevComponents.DotNetBar.ButtonX();
            this.lbCourt = new System.Windows.Forms.Label();
            this.lbMatchID = new System.Windows.Forms.Label();
            this.lb_PhaseDes = new System.Windows.Forms.Label();
            this.lb_Phase = new System.Windows.Forms.Label();
            this.lb_SportDes = new System.Windows.Forms.Label();
            this.tabReguDouble = new DevComponents.DotNetBar.TabItem(this.components);
            this.tabControlPanel2 = new DevComponents.DotNetBar.TabControlPanel();
            this.HoopgbMatchResult = new System.Windows.Forms.GroupBox();
            this.dgvHoopResult = new System.Windows.Forms.DataGridView();
            this.gbHoopMatchInfo = new System.Windows.Forms.GroupBox();
            this.label11 = new System.Windows.Forms.Label();
            this.lbHoopVenue = new System.Windows.Forms.Label();
            this.buttonX1 = new DevComponents.DotNetBar.ButtonX();
            this.btnxHoopPlayer = new DevComponents.DotNetBar.ButtonX();
            this.label13 = new System.Windows.Forms.Label();
            this.btnxHoopExit = new DevComponents.DotNetBar.ButtonX();
            this.lbHoopDate = new System.Windows.Forms.Label();
            this.btnxHoopStatus = new DevComponents.DotNetBar.ButtonX();
            this.btnx_HoopSchedule = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_HoopStartList = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_HoopRunning = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_HoopSuspend = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_HoopUnOfficial = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_HoopFinished = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_HoopRevision = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_HoopCanceled = new DevComponents.DotNetBar.ButtonItem();
            this.label15 = new System.Windows.Forms.Label();
            this.btnxHoopOfficial = new DevComponents.DotNetBar.ButtonX();
            this.lbHoopPhaseDes = new System.Windows.Forms.Label();
            this.label17 = new System.Windows.Forms.Label();
            this.lbHoopSportDes = new System.Windows.Forms.Label();
            this.tabHoop = new DevComponents.DotNetBar.TabItem(this.components);
            lb_B = new System.Windows.Forms.Label();
            lb_A = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.tabControlDataEntry)).BeginInit();
            this.tabControlDataEntry.SuspendLayout();
            this.tabControlPanel1.SuspendLayout();
            this.gb_ImportResult.SuspendLayout();
            this.gb_MatchResult.SuspendLayout();
            this.gb_Server.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvTeamB)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvTeamA)).BeginInit();
            this.gb_MatchInfo.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.tabControlPanel2.SuspendLayout();
            this.HoopgbMatchResult.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvHoopResult)).BeginInit();
            this.gbHoopMatchInfo.SuspendLayout();
            this.SuspendLayout();
            // 
            // lb_B
            // 
            lb_B.AutoSize = true;
            lb_B.Location = new System.Drawing.Point(457, 26);
            lb_B.Name = "lb_B";
            lb_B.Size = new System.Drawing.Size(11, 12);
            lb_B.TabIndex = 23;
            lb_B.Text = "B";
            // 
            // lb_A
            // 
            lb_A.AutoSize = true;
            lb_A.Location = new System.Drawing.Point(34, 25);
            lb_A.Name = "lb_A";
            lb_A.Size = new System.Drawing.Size(11, 12);
            lb_A.TabIndex = 21;
            lb_A.Text = "A";
            // 
            // timerNetPath
            // 
            this.timerNetPath.Tick += new System.EventHandler(this.timerNetPath_Tick);
            // 
            // tabControlDataEntry
            // 
            this.tabControlDataEntry.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.tabControlDataEntry.CanReorderTabs = false;
            this.tabControlDataEntry.Controls.Add(this.tabControlPanel1);
            this.tabControlDataEntry.Controls.Add(this.tabControlPanel2);
            this.tabControlDataEntry.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tabControlDataEntry.FixedTabSize = new System.Drawing.Size(120, 0);
            this.tabControlDataEntry.Location = new System.Drawing.Point(0, 0);
            this.tabControlDataEntry.Name = "tabControlDataEntry";
            this.tabControlDataEntry.SelectedTabFont = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold);
            this.tabControlDataEntry.SelectedTabIndex = 0;
            this.tabControlDataEntry.Size = new System.Drawing.Size(853, 750);
            this.tabControlDataEntry.Style = DevComponents.DotNetBar.eTabStripStyle.Office2007Dock;
            this.tabControlDataEntry.TabIndex = 10;
            this.tabControlDataEntry.TabLayoutType = DevComponents.DotNetBar.eTabLayoutType.FixedWithNavigationBox;
            this.tabControlDataEntry.Tabs.Add(this.tabReguDouble);
            this.tabControlDataEntry.Tabs.Add(this.tabHoop);
            this.tabControlDataEntry.Text = "tabControl1";
            // 
            // tabControlPanel1
            // 
            this.tabControlPanel1.Controls.Add(this.gb_ImportResult);
            this.tabControlPanel1.Controls.Add(this.gb_MatchResult);
            this.tabControlPanel1.Controls.Add(this.gb_MatchInfo);
            this.tabControlPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tabControlPanel1.Location = new System.Drawing.Point(0, 23);
            this.tabControlPanel1.Name = "tabControlPanel1";
            this.tabControlPanel1.Padding = new System.Windows.Forms.Padding(1);
            this.tabControlPanel1.Size = new System.Drawing.Size(853, 727);
            this.tabControlPanel1.Style.BackColor1.Color = System.Drawing.Color.FromArgb(((int)(((byte)(253)))), ((int)(((byte)(253)))), ((int)(((byte)(254)))));
            this.tabControlPanel1.Style.BackColor2.Color = System.Drawing.Color.FromArgb(((int)(((byte)(157)))), ((int)(((byte)(188)))), ((int)(((byte)(227)))));
            this.tabControlPanel1.Style.Border = DevComponents.DotNetBar.eBorderType.SingleLine;
            this.tabControlPanel1.Style.BorderColor.Color = System.Drawing.Color.FromArgb(((int)(((byte)(146)))), ((int)(((byte)(165)))), ((int)(((byte)(199)))));
            this.tabControlPanel1.Style.BorderSide = ((DevComponents.DotNetBar.eBorderSide)(((DevComponents.DotNetBar.eBorderSide.Left | DevComponents.DotNetBar.eBorderSide.Right) 
            | DevComponents.DotNetBar.eBorderSide.Bottom)));
            this.tabControlPanel1.Style.GradientAngle = 90;
            this.tabControlPanel1.TabIndex = 1;
            this.tabControlPanel1.TabItem = this.tabReguDouble;
            // 
            // gb_ImportResult
            // 
            this.gb_ImportResult.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.gb_ImportResult.Controls.Add(this.btnxImHoopMatchInfo);
            this.gb_ImportResult.Controls.Add(this.btnxImStatistic);
            this.gb_ImportResult.Controls.Add(this.btnxExTeam);
            this.gb_ImportResult.Controls.Add(this.tbImportMsg);
            this.gb_ImportResult.Controls.Add(this.chkAutoImport);
            this.gb_ImportResult.Controls.Add(this.chkOuterData);
            this.gb_ImportResult.Controls.Add(this.label1);
            this.gb_ImportResult.Controls.Add(this.label2);
            this.gb_ImportResult.Controls.Add(this.btnxHoopCompList);
            this.gb_ImportResult.Controls.Add(this.btnx_ExportHoopSchedule);
            this.gb_ImportResult.Controls.Add(this.btnxExSchedule);
            this.gb_ImportResult.Controls.Add(this.btnxImportAction);
            this.gb_ImportResult.Controls.Add(this.btnxImportMatchInfo);
            this.gb_ImportResult.Controls.Add(this.btnxExAthlete);
            this.gb_ImportResult.Controls.Add(this.btnxManualPathSel);
            this.gb_ImportResult.Controls.Add(this.btnxImPathSel);
            this.gb_ImportResult.Controls.Add(this.btnxExPathSel);
            this.gb_ImportResult.Controls.Add(this.tbManualPath);
            this.gb_ImportResult.Controls.Add(this.tbImportPath);
            this.gb_ImportResult.Controls.Add(this.tbExportPath);
            this.gb_ImportResult.Controls.Add(this.cmbFilterDate);
            this.gb_ImportResult.Controls.Add(this.label3);
            this.gb_ImportResult.Controls.Add(this.lb_ImportPath);
            this.gb_ImportResult.Controls.Add(this.lb_ExportPath);
            this.gb_ImportResult.Controls.Add(this.lb_SelectDate);
            this.gb_ImportResult.Location = new System.Drawing.Point(13, 504);
            this.gb_ImportResult.Name = "gb_ImportResult";
            this.gb_ImportResult.Size = new System.Drawing.Size(826, 207);
            this.gb_ImportResult.TabIndex = 11;
            this.gb_ImportResult.TabStop = false;
            this.gb_ImportResult.Text = "Emport&&Import";
            // 
            // btnxImHoopMatchInfo
            // 
            this.btnxImHoopMatchInfo.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxImHoopMatchInfo.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxImHoopMatchInfo.Location = new System.Drawing.Point(438, 162);
            this.btnxImHoopMatchInfo.Name = "btnxImHoopMatchInfo";
            this.btnxImHoopMatchInfo.Size = new System.Drawing.Size(142, 28);
            this.btnxImHoopMatchInfo.TabIndex = 28;
            this.btnxImHoopMatchInfo.Text = "Import HoopMatchInfo";
            this.btnxImHoopMatchInfo.Click += new System.EventHandler(this.btnxImHoopMatchInfo_Click);
            // 
            // btnxImStatistic
            // 
            this.btnxImStatistic.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxImStatistic.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxImStatistic.Location = new System.Drawing.Point(297, 162);
            this.btnxImStatistic.Name = "btnxImStatistic";
            this.btnxImStatistic.Size = new System.Drawing.Size(108, 28);
            this.btnxImStatistic.TabIndex = 28;
            this.btnxImStatistic.Text = "Import Statistic";
            this.btnxImStatistic.Click += new System.EventHandler(this.btnxImStatistic_Click);
            // 
            // btnxExTeam
            // 
            this.btnxExTeam.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxExTeam.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxExTeam.Location = new System.Drawing.Point(97, 44);
            this.btnxExTeam.Name = "btnxExTeam";
            this.btnxExTeam.Size = new System.Drawing.Size(77, 28);
            this.btnxExTeam.TabIndex = 27;
            this.btnxExTeam.Text = "Export Team";
            this.btnxExTeam.Click += new System.EventHandler(this.btnxExTeam_Click);
            // 
            // tbImportMsg
            // 
            this.tbImportMsg.BackColor = System.Drawing.Color.White;
            // 
            // 
            // 
            this.tbImportMsg.Border.Class = "TextBoxBorder";
            this.tbImportMsg.Border.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.tbImportMsg.Location = new System.Drawing.Point(589, 10);
            this.tbImportMsg.Multiline = true;
            this.tbImportMsg.Name = "tbImportMsg";
            this.tbImportMsg.ReadOnly = true;
            this.tbImportMsg.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.tbImportMsg.Size = new System.Drawing.Size(227, 193);
            this.tbImportMsg.TabIndex = 26;
            this.tbImportMsg.WordWrap = false;
            // 
            // chkAutoImport
            // 
            // 
            // 
            // 
            this.chkAutoImport.BackgroundStyle.Class = "";
            this.chkAutoImport.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.chkAutoImport.Location = new System.Drawing.Point(434, 87);
            this.chkAutoImport.Name = "chkAutoImport";
            this.chkAutoImport.Size = new System.Drawing.Size(117, 23);
            this.chkAutoImport.TabIndex = 25;
            this.chkAutoImport.Text = "Auto Import";
            this.chkAutoImport.CheckedChanged += new System.EventHandler(this.chkAutoImport_CheckedChanged);
            // 
            // chkOuterData
            // 
            // 
            // 
            // 
            this.chkOuterData.BackgroundStyle.Class = "";
            this.chkOuterData.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.chkOuterData.Location = new System.Drawing.Point(484, 47);
            this.chkOuterData.Name = "chkOuterData";
            this.chkOuterData.Size = new System.Drawing.Size(96, 23);
            this.chkOuterData.TabIndex = 25;
            this.chkOuterData.Text = "External Data";
            this.chkOuterData.CheckedChanged += new System.EventHandler(this.chkOuterData_CheckedChanged);
            // 
            // label1
            // 
            this.label1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.label1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label1.Location = new System.Drawing.Point(0, 121);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(583, 2);
            this.label1.TabIndex = 24;
            // 
            // label2
            // 
            this.label2.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.label2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label2.Location = new System.Drawing.Point(0, 79);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(583, 2);
            this.label2.TabIndex = 24;
            // 
            // btnxHoopCompList
            // 
            this.btnxHoopCompList.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxHoopCompList.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxHoopCompList.Location = new System.Drawing.Point(287, 44);
            this.btnxHoopCompList.Name = "btnxHoopCompList";
            this.btnxHoopCompList.Size = new System.Drawing.Size(88, 28);
            this.btnxHoopCompList.TabIndex = 4;
            this.btnxHoopCompList.Text = "Hoop_CompList";
            this.btnxHoopCompList.Click += new System.EventHandler(this.btnxHoopCompList_Click);
            // 
            // btnx_ExportHoopSchedule
            // 
            this.btnx_ExportHoopSchedule.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_ExportHoopSchedule.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_ExportHoopSchedule.Location = new System.Drawing.Point(387, 44);
            this.btnx_ExportHoopSchedule.Name = "btnx_ExportHoopSchedule";
            this.btnx_ExportHoopSchedule.Size = new System.Drawing.Size(88, 28);
            this.btnx_ExportHoopSchedule.TabIndex = 4;
            this.btnx_ExportHoopSchedule.Text = "Hoop_Schedule";
            this.btnx_ExportHoopSchedule.Click += new System.EventHandler(this.btnx_ExportHoopSchedule_Click);
            // 
            // btnxExSchedule
            // 
            this.btnxExSchedule.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxExSchedule.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxExSchedule.Location = new System.Drawing.Point(192, 44);
            this.btnxExSchedule.Name = "btnxExSchedule";
            this.btnxExSchedule.Size = new System.Drawing.Size(89, 28);
            this.btnxExSchedule.TabIndex = 4;
            this.btnxExSchedule.Text = "Export Schedule";
            this.btnxExSchedule.Click += new System.EventHandler(this.btnxExSchedule_Click);
            // 
            // btnxImportAction
            // 
            this.btnxImportAction.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxImportAction.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxImportAction.Location = new System.Drawing.Point(156, 163);
            this.btnxImportAction.Name = "btnxImportAction";
            this.btnxImportAction.Size = new System.Drawing.Size(108, 28);
            this.btnxImportAction.TabIndex = 4;
            this.btnxImportAction.Text = "Import Action";
            this.btnxImportAction.Click += new System.EventHandler(this.btnxImportAction_Click);
            // 
            // btnxImportMatchInfo
            // 
            this.btnxImportMatchInfo.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxImportMatchInfo.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxImportMatchInfo.Location = new System.Drawing.Point(15, 163);
            this.btnxImportMatchInfo.Name = "btnxImportMatchInfo";
            this.btnxImportMatchInfo.Size = new System.Drawing.Size(108, 28);
            this.btnxImportMatchInfo.TabIndex = 4;
            this.btnxImportMatchInfo.Text = "Import MatchInfo";
            this.btnxImportMatchInfo.Click += new System.EventHandler(this.btnxImportMatchInfo_Click);
            // 
            // btnxExAthlete
            // 
            this.btnxExAthlete.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxExAthlete.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxExAthlete.Location = new System.Drawing.Point(8, 44);
            this.btnxExAthlete.Name = "btnxExAthlete";
            this.btnxExAthlete.Size = new System.Drawing.Size(77, 28);
            this.btnxExAthlete.TabIndex = 4;
            this.btnxExAthlete.Text = "Export Athlete";
            this.btnxExAthlete.Click += new System.EventHandler(this.btnxExAthlete_Click);
            // 
            // btnxManualPathSel
            // 
            this.btnxManualPathSel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxManualPathSel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxManualPathSel.Location = new System.Drawing.Point(363, 126);
            this.btnxManualPathSel.Name = "btnxManualPathSel";
            this.btnxManualPathSel.Size = new System.Drawing.Size(37, 32);
            this.btnxManualPathSel.TabIndex = 3;
            this.btnxManualPathSel.Text = "...";
            this.btnxManualPathSel.Click += new System.EventHandler(this.btnxManualPathSel_Click);
            // 
            // btnxImPathSel
            // 
            this.btnxImPathSel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxImPathSel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxImPathSel.Location = new System.Drawing.Point(363, 81);
            this.btnxImPathSel.Name = "btnxImPathSel";
            this.btnxImPathSel.Size = new System.Drawing.Size(37, 32);
            this.btnxImPathSel.TabIndex = 3;
            this.btnxImPathSel.Text = "...";
            this.btnxImPathSel.Click += new System.EventHandler(this.btnxImPathSel_Click);
            // 
            // btnxExPathSel
            // 
            this.btnxExPathSel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxExPathSel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxExPathSel.Location = new System.Drawing.Point(509, 8);
            this.btnxExPathSel.Name = "btnxExPathSel";
            this.btnxExPathSel.Size = new System.Drawing.Size(37, 32);
            this.btnxExPathSel.TabIndex = 3;
            this.btnxExPathSel.Text = "...";
            this.btnxExPathSel.Click += new System.EventHandler(this.btnxExPathSel_Click);
            // 
            // tbManualPath
            // 
            // 
            // 
            // 
            this.tbManualPath.Border.Class = "TextBoxBorder";
            this.tbManualPath.Border.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.tbManualPath.Location = new System.Drawing.Point(93, 131);
            this.tbManualPath.Name = "tbManualPath";
            this.tbManualPath.Size = new System.Drawing.Size(250, 21);
            this.tbManualPath.TabIndex = 2;
            // 
            // tbImportPath
            // 
            // 
            // 
            // 
            this.tbImportPath.Border.Class = "TextBoxBorder";
            this.tbImportPath.Border.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.tbImportPath.Location = new System.Drawing.Point(93, 90);
            this.tbImportPath.Name = "tbImportPath";
            this.tbImportPath.Size = new System.Drawing.Size(250, 21);
            this.tbImportPath.TabIndex = 2;
            // 
            // tbExportPath
            // 
            // 
            // 
            // 
            this.tbExportPath.Border.Class = "TextBoxBorder";
            this.tbExportPath.Border.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.tbExportPath.Location = new System.Drawing.Point(291, 18);
            this.tbExportPath.Name = "tbExportPath";
            this.tbExportPath.Size = new System.Drawing.Size(209, 21);
            this.tbExportPath.TabIndex = 2;
            // 
            // cmbFilterDate
            // 
            this.cmbFilterDate.DisplayMember = "Text";
            this.cmbFilterDate.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbFilterDate.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbFilterDate.FormattingEnabled = true;
            this.cmbFilterDate.ItemHeight = 15;
            this.cmbFilterDate.Location = new System.Drawing.Point(93, 16);
            this.cmbFilterDate.Name = "cmbFilterDate";
            this.cmbFilterDate.Size = new System.Drawing.Size(101, 21);
            this.cmbFilterDate.TabIndex = 1;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(10, 134);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(71, 12);
            this.label3.TabIndex = 0;
            this.label3.Text = "Manual Path";
            // 
            // lb_ImportPath
            // 
            this.lb_ImportPath.AutoSize = true;
            this.lb_ImportPath.Location = new System.Drawing.Point(10, 93);
            this.lb_ImportPath.Name = "lb_ImportPath";
            this.lb_ImportPath.Size = new System.Drawing.Size(71, 12);
            this.lb_ImportPath.TabIndex = 0;
            this.lb_ImportPath.Text = "Import Path";
            // 
            // lb_ExportPath
            // 
            this.lb_ExportPath.AutoSize = true;
            this.lb_ExportPath.Location = new System.Drawing.Point(223, 22);
            this.lb_ExportPath.Name = "lb_ExportPath";
            this.lb_ExportPath.Size = new System.Drawing.Size(71, 12);
            this.lb_ExportPath.TabIndex = 0;
            this.lb_ExportPath.Text = "Export Path";
            // 
            // lb_SelectDate
            // 
            this.lb_SelectDate.AutoSize = true;
            this.lb_SelectDate.Location = new System.Drawing.Point(10, 22);
            this.lb_SelectDate.Name = "lb_SelectDate";
            this.lb_SelectDate.Size = new System.Drawing.Size(83, 12);
            this.lb_SelectDate.TabIndex = 0;
            this.lb_SelectDate.Text = "Selected Date";
            // 
            // gb_MatchResult
            // 
            this.gb_MatchResult.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.gb_MatchResult.Controls.Add(this.labelX4);
            this.gb_MatchResult.Controls.Add(this.labelX3);
            this.gb_MatchResult.Controls.Add(this.tbMatchID);
            this.gb_MatchResult.Controls.Add(this.tbRSC);
            this.gb_MatchResult.Controls.Add(this.btnConvertRsc);
            this.gb_MatchResult.Controls.Add(this.gb_Server);
            this.gb_MatchResult.Controls.Add(this.lb_B_GameTotal);
            this.gb_MatchResult.Controls.Add(this.lb_A_GameTotal);
            this.gb_MatchResult.Controls.Add(this.lb_GameTotal);
            this.gb_MatchResult.Controls.Add(this.lb_A_Game5);
            this.gb_MatchResult.Controls.Add(this.lb_A_Game3);
            this.gb_MatchResult.Controls.Add(this.lb_A_Game4);
            this.gb_MatchResult.Controls.Add(this.lb_A_Game2);
            this.gb_MatchResult.Controls.Add(this.lb_B_Game5);
            this.gb_MatchResult.Controls.Add(this.lb_B_Game3);
            this.gb_MatchResult.Controls.Add(this.lb_B_Game4);
            this.gb_MatchResult.Controls.Add(this.lb_B_Game2);
            this.gb_MatchResult.Controls.Add(this.lb_B_Game1);
            this.gb_MatchResult.Controls.Add(this.lb_A_Game1);
            this.gb_MatchResult.Controls.Add(this.rad_Game5);
            this.gb_MatchResult.Controls.Add(this.rad_Game4);
            this.gb_MatchResult.Controls.Add(this.rad_Game3);
            this.gb_MatchResult.Controls.Add(this.rad_Game2);
            this.gb_MatchResult.Controls.Add(this.rad_Game1);
            this.gb_MatchResult.Controls.Add(this.btnx_Match3);
            this.gb_MatchResult.Controls.Add(this.btnx_Match2);
            this.gb_MatchResult.Controls.Add(this.btnx_Match1);
            this.gb_MatchResult.Controls.Add(this.btnx_B_Add);
            this.gb_MatchResult.Controls.Add(this.btnClearRes);
            this.gb_MatchResult.Controls.Add(this.btnx_A_Add);
            this.gb_MatchResult.Controls.Add(this.btnx_Undo);
            this.gb_MatchResult.Controls.Add(this.dgvTeamB);
            this.gb_MatchResult.Controls.Add(this.dgvTeamA);
            this.gb_MatchResult.Location = new System.Drawing.Point(13, 155);
            this.gb_MatchResult.Name = "gb_MatchResult";
            this.gb_MatchResult.Size = new System.Drawing.Size(826, 348);
            this.gb_MatchResult.TabIndex = 10;
            this.gb_MatchResult.TabStop = false;
            this.gb_MatchResult.Text = "Match Score";
            // 
            // labelX4
            // 
            // 
            // 
            // 
            this.labelX4.BackgroundStyle.Class = "";
            this.labelX4.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labelX4.Location = new System.Drawing.Point(166, 279);
            this.labelX4.Name = "labelX4";
            this.labelX4.Size = new System.Drawing.Size(48, 17);
            this.labelX4.TabIndex = 91;
            this.labelX4.Text = "MatchID";
            // 
            // labelX3
            // 
            // 
            // 
            // 
            this.labelX3.BackgroundStyle.Class = "";
            this.labelX3.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labelX3.Location = new System.Drawing.Point(51, 285);
            this.labelX3.Name = "labelX3";
            this.labelX3.Size = new System.Drawing.Size(34, 11);
            this.labelX3.TabIndex = 90;
            this.labelX3.Text = "RSC";
            // 
            // tbMatchID
            // 
            // 
            // 
            // 
            this.tbMatchID.Border.Class = "TextBoxBorder";
            this.tbMatchID.Border.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.tbMatchID.Location = new System.Drawing.Point(156, 302);
            this.tbMatchID.MaxLength = 6;
            this.tbMatchID.Name = "tbMatchID";
            this.tbMatchID.Size = new System.Drawing.Size(67, 21);
            this.tbMatchID.TabIndex = 89;
            // 
            // tbRSC
            // 
            // 
            // 
            // 
            this.tbRSC.Border.Class = "TextBoxBorder";
            this.tbRSC.Border.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.tbRSC.Location = new System.Drawing.Point(33, 302);
            this.tbRSC.MaxLength = 9;
            this.tbRSC.Name = "tbRSC";
            this.tbRSC.Size = new System.Drawing.Size(75, 21);
            this.tbRSC.TabIndex = 88;
            // 
            // btnConvertRsc
            // 
            this.btnConvertRsc.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnConvertRsc.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnConvertRsc.Location = new System.Drawing.Point(115, 293);
            this.btnConvertRsc.Margin = new System.Windows.Forms.Padding(0);
            this.btnConvertRsc.Name = "btnConvertRsc";
            this.btnConvertRsc.Size = new System.Drawing.Size(32, 43);
            this.btnConvertRsc.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnConvertRsc.TabIndex = 43;
            this.btnConvertRsc.Text = "→ ←";
            this.btnConvertRsc.Click += new System.EventHandler(this.btnConvertRsc_Click);
            // 
            // gb_Server
            // 
            this.gb_Server.Controls.Add(this.rad_ServerB);
            this.gb_Server.Controls.Add(this.rad_ServerA);
            this.gb_Server.Location = new System.Drawing.Point(291, 48);
            this.gb_Server.Name = "gb_Server";
            this.gb_Server.Size = new System.Drawing.Size(81, 87);
            this.gb_Server.TabIndex = 87;
            this.gb_Server.TabStop = false;
            // 
            // rad_ServerB
            // 
            this.rad_ServerB.AutoSize = true;
            this.rad_ServerB.Location = new System.Drawing.Point(6, 61);
            this.rad_ServerB.Name = "rad_ServerB";
            this.rad_ServerB.Size = new System.Drawing.Size(65, 16);
            this.rad_ServerB.TabIndex = 0;
            this.rad_ServerB.TabStop = true;
            this.rad_ServerB.Text = "ServerB";
            this.rad_ServerB.UseVisualStyleBackColor = true;
            this.rad_ServerB.CheckedChanged += new System.EventHandler(this.rad_ServerB_CheckedChanged);
            // 
            // rad_ServerA
            // 
            this.rad_ServerA.AutoSize = true;
            this.rad_ServerA.Location = new System.Drawing.Point(6, 12);
            this.rad_ServerA.Name = "rad_ServerA";
            this.rad_ServerA.Size = new System.Drawing.Size(65, 16);
            this.rad_ServerA.TabIndex = 0;
            this.rad_ServerA.TabStop = true;
            this.rad_ServerA.Text = "ServerA";
            this.rad_ServerA.UseVisualStyleBackColor = true;
            this.rad_ServerA.CheckedChanged += new System.EventHandler(this.rad_ServerA_CheckedChanged);
            // 
            // lb_B_GameTotal
            // 
            this.lb_B_GameTotal.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lb_B_GameTotal.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lb_B_GameTotal.Font = new System.Drawing.Font("Arial", 27.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_B_GameTotal.ForeColor = System.Drawing.Color.Red;
            this.lb_B_GameTotal.Location = new System.Drawing.Point(491, 293);
            this.lb_B_GameTotal.Name = "lb_B_GameTotal";
            this.lb_B_GameTotal.Size = new System.Drawing.Size(43, 46);
            this.lb_B_GameTotal.TabIndex = 78;
            this.lb_B_GameTotal.Text = "0";
            this.lb_B_GameTotal.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_A_GameTotal
            // 
            this.lb_A_GameTotal.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lb_A_GameTotal.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lb_A_GameTotal.Font = new System.Drawing.Font("Arial", 27.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_A_GameTotal.ForeColor = System.Drawing.Color.Red;
            this.lb_A_GameTotal.Location = new System.Drawing.Point(375, 293);
            this.lb_A_GameTotal.Name = "lb_A_GameTotal";
            this.lb_A_GameTotal.Size = new System.Drawing.Size(43, 46);
            this.lb_A_GameTotal.TabIndex = 79;
            this.lb_A_GameTotal.Text = "0";
            this.lb_A_GameTotal.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_GameTotal
            // 
            this.lb_GameTotal.AutoSize = true;
            this.lb_GameTotal.Location = new System.Drawing.Point(419, 311);
            this.lb_GameTotal.Name = "lb_GameTotal";
            this.lb_GameTotal.Size = new System.Drawing.Size(65, 12);
            this.lb_GameTotal.TabIndex = 77;
            this.lb_GameTotal.Text = "Game Total";
            // 
            // lb_A_Game5
            // 
            this.lb_A_Game5.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lb_A_Game5.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lb_A_Game5.Font = new System.Drawing.Font("Arial", 18F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_A_Game5.ForeColor = System.Drawing.Color.Red;
            this.lb_A_Game5.Location = new System.Drawing.Point(375, 244);
            this.lb_A_Game5.Name = "lb_A_Game5";
            this.lb_A_Game5.Size = new System.Drawing.Size(41, 39);
            this.lb_A_Game5.TabIndex = 71;
            this.lb_A_Game5.Text = "0";
            this.lb_A_Game5.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_A_Game3
            // 
            this.lb_A_Game3.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lb_A_Game3.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lb_A_Game3.Font = new System.Drawing.Font("Arial", 18F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_A_Game3.ForeColor = System.Drawing.Color.Red;
            this.lb_A_Game3.Location = new System.Drawing.Point(375, 146);
            this.lb_A_Game3.Name = "lb_A_Game3";
            this.lb_A_Game3.Size = new System.Drawing.Size(41, 39);
            this.lb_A_Game3.TabIndex = 71;
            this.lb_A_Game3.Text = "0";
            this.lb_A_Game3.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_A_Game4
            // 
            this.lb_A_Game4.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lb_A_Game4.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lb_A_Game4.Font = new System.Drawing.Font("Arial", 18F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_A_Game4.ForeColor = System.Drawing.Color.Red;
            this.lb_A_Game4.Location = new System.Drawing.Point(375, 195);
            this.lb_A_Game4.Name = "lb_A_Game4";
            this.lb_A_Game4.Size = new System.Drawing.Size(41, 39);
            this.lb_A_Game4.TabIndex = 72;
            this.lb_A_Game4.Text = "0";
            this.lb_A_Game4.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_A_Game2
            // 
            this.lb_A_Game2.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lb_A_Game2.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lb_A_Game2.Font = new System.Drawing.Font("Arial", 18F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_A_Game2.ForeColor = System.Drawing.Color.Red;
            this.lb_A_Game2.Location = new System.Drawing.Point(375, 97);
            this.lb_A_Game2.Name = "lb_A_Game2";
            this.lb_A_Game2.Size = new System.Drawing.Size(41, 39);
            this.lb_A_Game2.TabIndex = 72;
            this.lb_A_Game2.Text = "0";
            this.lb_A_Game2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_B_Game5
            // 
            this.lb_B_Game5.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lb_B_Game5.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lb_B_Game5.Font = new System.Drawing.Font("Arial", 18F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_B_Game5.ForeColor = System.Drawing.Color.Red;
            this.lb_B_Game5.Location = new System.Drawing.Point(491, 244);
            this.lb_B_Game5.Name = "lb_B_Game5";
            this.lb_B_Game5.Size = new System.Drawing.Size(41, 39);
            this.lb_B_Game5.TabIndex = 73;
            this.lb_B_Game5.Text = "0";
            this.lb_B_Game5.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_B_Game3
            // 
            this.lb_B_Game3.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lb_B_Game3.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lb_B_Game3.Font = new System.Drawing.Font("Arial", 18F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_B_Game3.ForeColor = System.Drawing.Color.Red;
            this.lb_B_Game3.Location = new System.Drawing.Point(491, 146);
            this.lb_B_Game3.Name = "lb_B_Game3";
            this.lb_B_Game3.Size = new System.Drawing.Size(41, 39);
            this.lb_B_Game3.TabIndex = 73;
            this.lb_B_Game3.Text = "0";
            this.lb_B_Game3.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_B_Game4
            // 
            this.lb_B_Game4.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lb_B_Game4.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lb_B_Game4.Font = new System.Drawing.Font("Arial", 18F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_B_Game4.ForeColor = System.Drawing.Color.Red;
            this.lb_B_Game4.Location = new System.Drawing.Point(491, 195);
            this.lb_B_Game4.Name = "lb_B_Game4";
            this.lb_B_Game4.Size = new System.Drawing.Size(41, 39);
            this.lb_B_Game4.TabIndex = 68;
            this.lb_B_Game4.Text = "0";
            this.lb_B_Game4.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_B_Game2
            // 
            this.lb_B_Game2.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lb_B_Game2.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lb_B_Game2.Font = new System.Drawing.Font("Arial", 18F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_B_Game2.ForeColor = System.Drawing.Color.Red;
            this.lb_B_Game2.Location = new System.Drawing.Point(491, 97);
            this.lb_B_Game2.Name = "lb_B_Game2";
            this.lb_B_Game2.Size = new System.Drawing.Size(41, 39);
            this.lb_B_Game2.TabIndex = 68;
            this.lb_B_Game2.Text = "0";
            this.lb_B_Game2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_B_Game1
            // 
            this.lb_B_Game1.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lb_B_Game1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lb_B_Game1.Font = new System.Drawing.Font("Arial", 18F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_B_Game1.ForeColor = System.Drawing.Color.Red;
            this.lb_B_Game1.Location = new System.Drawing.Point(491, 48);
            this.lb_B_Game1.Name = "lb_B_Game1";
            this.lb_B_Game1.Size = new System.Drawing.Size(41, 39);
            this.lb_B_Game1.TabIndex = 69;
            this.lb_B_Game1.Text = "0";
            this.lb_B_Game1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_A_Game1
            // 
            this.lb_A_Game1.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lb_A_Game1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lb_A_Game1.Font = new System.Drawing.Font("Arial", 18F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_A_Game1.ForeColor = System.Drawing.Color.Red;
            this.lb_A_Game1.Location = new System.Drawing.Point(375, 48);
            this.lb_A_Game1.Name = "lb_A_Game1";
            this.lb_A_Game1.Size = new System.Drawing.Size(41, 39);
            this.lb_A_Game1.TabIndex = 70;
            this.lb_A_Game1.Text = "0";
            this.lb_A_Game1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // rad_Game5
            // 
            this.rad_Game5.AutoSize = true;
            this.rad_Game5.Location = new System.Drawing.Point(427, 258);
            this.rad_Game5.Name = "rad_Game5";
            this.rad_Game5.Size = new System.Drawing.Size(53, 16);
            this.rad_Game5.TabIndex = 67;
            this.rad_Game5.Text = "Game5";
            this.rad_Game5.UseVisualStyleBackColor = true;
            this.rad_Game5.CheckedChanged += new System.EventHandler(this.OnRbtnSetRange);
            // 
            // rad_Game4
            // 
            this.rad_Game4.AutoSize = true;
            this.rad_Game4.Location = new System.Drawing.Point(427, 205);
            this.rad_Game4.Name = "rad_Game4";
            this.rad_Game4.Size = new System.Drawing.Size(53, 16);
            this.rad_Game4.TabIndex = 66;
            this.rad_Game4.Text = "Game4";
            this.rad_Game4.UseVisualStyleBackColor = true;
            this.rad_Game4.CheckedChanged += new System.EventHandler(this.OnRbtnSetRange);
            // 
            // rad_Game3
            // 
            this.rad_Game3.AutoSize = true;
            this.rad_Game3.Location = new System.Drawing.Point(427, 158);
            this.rad_Game3.Name = "rad_Game3";
            this.rad_Game3.Size = new System.Drawing.Size(53, 16);
            this.rad_Game3.TabIndex = 67;
            this.rad_Game3.Text = "Game3";
            this.rad_Game3.UseVisualStyleBackColor = true;
            this.rad_Game3.CheckedChanged += new System.EventHandler(this.OnRbtnSetRange);
            // 
            // rad_Game2
            // 
            this.rad_Game2.AutoSize = true;
            this.rad_Game2.Location = new System.Drawing.Point(427, 109);
            this.rad_Game2.Name = "rad_Game2";
            this.rad_Game2.Size = new System.Drawing.Size(53, 16);
            this.rad_Game2.TabIndex = 66;
            this.rad_Game2.Text = "Game2";
            this.rad_Game2.UseVisualStyleBackColor = true;
            this.rad_Game2.CheckedChanged += new System.EventHandler(this.OnRbtnSetRange);
            // 
            // rad_Game1
            // 
            this.rad_Game1.AutoSize = true;
            this.rad_Game1.Location = new System.Drawing.Point(427, 60);
            this.rad_Game1.Name = "rad_Game1";
            this.rad_Game1.Size = new System.Drawing.Size(53, 16);
            this.rad_Game1.TabIndex = 65;
            this.rad_Game1.Text = "Game1";
            this.rad_Game1.UseVisualStyleBackColor = true;
            this.rad_Game1.CheckedChanged += new System.EventHandler(this.OnRbtnSetRange);
            // 
            // btnx_Match3
            // 
            this.btnx_Match3.AccessibleRole = System.Windows.Forms.AccessibleRole.RadioButton;
            this.btnx_Match3.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Match3.Location = new System.Drawing.Point(457, 20);
            this.btnx_Match3.Name = "btnx_Match3";
            this.btnx_Match3.Size = new System.Drawing.Size(75, 25);
            this.btnx_Match3.TabIndex = 64;
            this.btnx_Match3.Text = "Match 3";
            this.btnx_Match3.Click += new System.EventHandler(this.OnBtnSplitClick);
            // 
            // btnx_Match2
            // 
            this.btnx_Match2.AccessibleRole = System.Windows.Forms.AccessibleRole.RadioButton;
            this.btnx_Match2.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Match2.Location = new System.Drawing.Point(376, 20);
            this.btnx_Match2.Name = "btnx_Match2";
            this.btnx_Match2.Size = new System.Drawing.Size(75, 25);
            this.btnx_Match2.TabIndex = 64;
            this.btnx_Match2.Text = "Match 2";
            this.btnx_Match2.Click += new System.EventHandler(this.OnBtnSplitClick);
            // 
            // btnx_Match1
            // 
            this.btnx_Match1.AccessibleRole = System.Windows.Forms.AccessibleRole.RadioButton;
            this.btnx_Match1.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Match1.Location = new System.Drawing.Point(295, 20);
            this.btnx_Match1.Name = "btnx_Match1";
            this.btnx_Match1.Size = new System.Drawing.Size(75, 25);
            this.btnx_Match1.TabIndex = 64;
            this.btnx_Match1.Text = "Match 1";
            this.btnx_Match1.Click += new System.EventHandler(this.OnBtnSplitClick);
            // 
            // btnx_B_Add
            // 
            this.btnx_B_Add.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_B_Add.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_B_Add.Location = new System.Drawing.Point(541, 279);
            this.btnx_B_Add.Name = "btnx_B_Add";
            this.btnx_B_Add.Size = new System.Drawing.Size(75, 63);
            this.btnx_B_Add.TabIndex = 63;
            this.btnx_B_Add.Text = "Ｂ＋１";
            this.btnx_B_Add.Click += new System.EventHandler(this.btnx_B_Add_Click);
            // 
            // btnClearRes
            // 
            this.btnClearRes.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnClearRes.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnClearRes.Location = new System.Drawing.Point(726, 277);
            this.btnClearRes.Name = "btnClearRes";
            this.btnClearRes.Size = new System.Drawing.Size(94, 32);
            this.btnClearRes.TabIndex = 63;
            this.btnClearRes.Text = "Clear Results";
            this.btnClearRes.Click += new System.EventHandler(this.btnx_ClearResult_Click);
            // 
            // btnx_A_Add
            // 
            this.btnx_A_Add.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_A_Add.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_A_Add.Location = new System.Drawing.Point(281, 280);
            this.btnx_A_Add.Name = "btnx_A_Add";
            this.btnx_A_Add.Size = new System.Drawing.Size(81, 63);
            this.btnx_A_Add.TabIndex = 63;
            this.btnx_A_Add.Text = "Ａ＋１";
            this.btnx_A_Add.Click += new System.EventHandler(this.btnx_A_Add_Click);
            // 
            // btnx_Undo
            // 
            this.btnx_Undo.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Undo.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Undo.Location = new System.Drawing.Point(726, 312);
            this.btnx_Undo.Name = "btnx_Undo";
            this.btnx_Undo.Size = new System.Drawing.Size(94, 32);
            this.btnx_Undo.TabIndex = 63;
            this.btnx_Undo.Text = "Undo";
            this.btnx_Undo.Click += new System.EventHandler(this.btnx_Undo_Click);
            // 
            // dgvTeamB
            // 
            this.dgvTeamB.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvTeamB.Location = new System.Drawing.Point(541, 20);
            this.dgvTeamB.MultiSelect = false;
            this.dgvTeamB.Name = "dgvTeamB";
            this.dgvTeamB.RowTemplate.Height = 23;
            this.dgvTeamB.Size = new System.Drawing.Size(279, 253);
            this.dgvTeamB.TabIndex = 62;
            this.dgvTeamB.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvTeamB_CellBeginEdit);
            this.dgvTeamB.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvTeamB_CellValueChanged);
            // 
            // dgvTeamA
            // 
            this.dgvTeamA.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvTeamA.Location = new System.Drawing.Point(6, 20);
            this.dgvTeamA.MultiSelect = false;
            this.dgvTeamA.Name = "dgvTeamA";
            this.dgvTeamA.RowTemplate.Height = 23;
            this.dgvTeamA.Size = new System.Drawing.Size(279, 253);
            this.dgvTeamA.TabIndex = 62;
            this.dgvTeamA.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvTeamA_CellBeginEdit);
            this.dgvTeamA.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvTeamA_CellValueChanged);
            // 
            // gb_MatchInfo
            // 
            this.gb_MatchInfo.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.gb_MatchInfo.Controls.Add(this.btnx_ModifyTime);
            this.gb_MatchInfo.Controls.Add(this.btnScoreBoard);
            this.gb_MatchInfo.Controls.Add(this.btnx_VisitorPlayer);
            this.gb_MatchInfo.Controls.Add(this.groupBox3);
            this.gb_MatchInfo.Controls.Add(this.lb_Sport);
            this.gb_MatchInfo.Controls.Add(this.btnx_HomePlayer);
            this.gb_MatchInfo.Controls.Add(this.btnx_Exit);
            this.gb_MatchInfo.Controls.Add(this.lb_DateDes);
            this.gb_MatchInfo.Controls.Add(this.btnx_Status);
            this.gb_MatchInfo.Controls.Add(this.lb_Date);
            this.gb_MatchInfo.Controls.Add(this.lbRule);
            this.gb_MatchInfo.Controls.Add(this.lbRSC);
            this.gb_MatchInfo.Controls.Add(this.label7);
            this.gb_MatchInfo.Controls.Add(this.label6);
            this.gb_MatchInfo.Controls.Add(this.label5);
            this.gb_MatchInfo.Controls.Add(this.label4);
            this.gb_MatchInfo.Controls.Add(this.btnx_Official);
            this.gb_MatchInfo.Controls.Add(this.lbCourt);
            this.gb_MatchInfo.Controls.Add(this.lbMatchID);
            this.gb_MatchInfo.Controls.Add(this.lb_PhaseDes);
            this.gb_MatchInfo.Controls.Add(this.lb_Phase);
            this.gb_MatchInfo.Controls.Add(this.lb_SportDes);
            this.gb_MatchInfo.Location = new System.Drawing.Point(13, 0);
            this.gb_MatchInfo.Name = "gb_MatchInfo";
            this.gb_MatchInfo.Size = new System.Drawing.Size(826, 154);
            this.gb_MatchInfo.TabIndex = 9;
            this.gb_MatchInfo.TabStop = false;
            this.gb_MatchInfo.Text = "Match Info";
            // 
            // btnx_ModifyTime
            // 
            this.btnx_ModifyTime.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_ModifyTime.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_ModifyTime.Location = new System.Drawing.Point(719, 98);
            this.btnx_ModifyTime.Name = "btnx_ModifyTime";
            this.btnx_ModifyTime.Size = new System.Drawing.Size(100, 25);
            this.btnx_ModifyTime.TabIndex = 88;
            this.btnx_ModifyTime.Text = "Modify Time";
            this.btnx_ModifyTime.Click += new System.EventHandler(this.btnx_ModifyTime_Click);
            // 
            // btnScoreBoard
            // 
            this.btnScoreBoard.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnScoreBoard.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnScoreBoard.Location = new System.Drawing.Point(8, 114);
            this.btnScoreBoard.Name = "btnScoreBoard";
            this.btnScoreBoard.Size = new System.Drawing.Size(100, 25);
            this.btnScoreBoard.TabIndex = 28;
            this.btnScoreBoard.Text = "Scoreboard";
            this.btnScoreBoard.Click += new System.EventHandler(this.btnScoreBoardClick);
            // 
            // btnx_VisitorPlayer
            // 
            this.btnx_VisitorPlayer.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_VisitorPlayer.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_VisitorPlayer.Location = new System.Drawing.Point(8, 83);
            this.btnx_VisitorPlayer.Name = "btnx_VisitorPlayer";
            this.btnx_VisitorPlayer.Size = new System.Drawing.Size(100, 25);
            this.btnx_VisitorPlayer.TabIndex = 28;
            this.btnx_VisitorPlayer.Text = "Visitor Player";
            this.btnx_VisitorPlayer.Click += new System.EventHandler(this.btnx_VisitorPlayer_Click);
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.btnx_Modify_Result);
            this.groupBox3.Controls.Add(this.btnx_Away_Sub);
            this.groupBox3.Controls.Add(this.btnx_Home_Sub);
            this.groupBox3.Controls.Add(this.btnx_Away_Add);
            this.groupBox3.Controls.Add(this.btnx_Home_Add);
            this.groupBox3.Controls.Add(this.lb_TotalScore);
            this.groupBox3.Controls.Add(this.lb_AwayDes);
            this.groupBox3.Controls.Add(this.lb_HomeDes);
            this.groupBox3.Controls.Add(lb_B);
            this.groupBox3.Controls.Add(this.lb_Away_Score);
            this.groupBox3.Controls.Add(this.lb_Home_Score);
            this.groupBox3.Controls.Add(lb_A);
            this.groupBox3.Location = new System.Drawing.Point(139, 62);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(522, 85);
            this.groupBox3.TabIndex = 27;
            this.groupBox3.TabStop = false;
            // 
            // btnx_Modify_Result
            // 
            this.btnx_Modify_Result.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Modify_Result.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Modify_Result.Location = new System.Drawing.Point(218, 47);
            this.btnx_Modify_Result.Name = "btnx_Modify_Result";
            this.btnx_Modify_Result.Size = new System.Drawing.Size(75, 35);
            this.btnx_Modify_Result.TabIndex = 27;
            this.btnx_Modify_Result.Text = "Match Result";
            this.btnx_Modify_Result.Click += new System.EventHandler(this.btnx_Modify_Result_Click);
            // 
            // btnx_Away_Sub
            // 
            this.btnx_Away_Sub.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Away_Sub.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Away_Sub.Location = new System.Drawing.Point(304, 55);
            this.btnx_Away_Sub.Name = "btnx_Away_Sub";
            this.btnx_Away_Sub.Size = new System.Drawing.Size(43, 29);
            this.btnx_Away_Sub.TabIndex = 26;
            this.btnx_Away_Sub.Text = "－１";
            this.btnx_Away_Sub.Click += new System.EventHandler(this.btnx_Away_Sub_Click);
            // 
            // btnx_Home_Sub
            // 
            this.btnx_Home_Sub.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Home_Sub.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Home_Sub.Location = new System.Drawing.Point(163, 54);
            this.btnx_Home_Sub.Name = "btnx_Home_Sub";
            this.btnx_Home_Sub.Size = new System.Drawing.Size(43, 30);
            this.btnx_Home_Sub.TabIndex = 26;
            this.btnx_Home_Sub.Text = "－１";
            this.btnx_Home_Sub.Click += new System.EventHandler(this.btnx_Home_Sub_Click);
            // 
            // btnx_Away_Add
            // 
            this.btnx_Away_Add.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Away_Add.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Away_Add.Location = new System.Drawing.Point(304, 18);
            this.btnx_Away_Add.Name = "btnx_Away_Add";
            this.btnx_Away_Add.Size = new System.Drawing.Size(43, 31);
            this.btnx_Away_Add.TabIndex = 26;
            this.btnx_Away_Add.Text = "＋１";
            this.btnx_Away_Add.Click += new System.EventHandler(this.btnx_Away_Add_Click);
            // 
            // btnx_Home_Add
            // 
            this.btnx_Home_Add.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Home_Add.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Home_Add.Location = new System.Drawing.Point(163, 18);
            this.btnx_Home_Add.Name = "btnx_Home_Add";
            this.btnx_Home_Add.Size = new System.Drawing.Size(43, 31);
            this.btnx_Home_Add.TabIndex = 26;
            this.btnx_Home_Add.Text = "＋１";
            this.btnx_Home_Add.Click += new System.EventHandler(this.btnx_Home_Add_Click);
            // 
            // lb_TotalScore
            // 
            this.lb_TotalScore.AutoSize = true;
            this.lb_TotalScore.Location = new System.Drawing.Point(223, 27);
            this.lb_TotalScore.Name = "lb_TotalScore";
            this.lb_TotalScore.Size = new System.Drawing.Size(65, 12);
            this.lb_TotalScore.TabIndex = 25;
            this.lb_TotalScore.Text = "TotalScore";
            // 
            // lb_AwayDes
            // 
            this.lb_AwayDes.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_AwayDes.Location = new System.Drawing.Point(419, 48);
            this.lb_AwayDes.Name = "lb_AwayDes";
            this.lb_AwayDes.Size = new System.Drawing.Size(97, 19);
            this.lb_AwayDes.TabIndex = 24;
            this.lb_AwayDes.Text = "Away Des";
            this.lb_AwayDes.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_HomeDes
            // 
            this.lb_HomeDes.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_HomeDes.Location = new System.Drawing.Point(6, 48);
            this.lb_HomeDes.Name = "lb_HomeDes";
            this.lb_HomeDes.Size = new System.Drawing.Size(88, 19);
            this.lb_HomeDes.TabIndex = 22;
            this.lb_HomeDes.Text = "Home Des";
            this.lb_HomeDes.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_Away_Score
            // 
            this.lb_Away_Score.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lb_Away_Score.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lb_Away_Score.Font = new System.Drawing.Font("Arial", 38.25F, System.Drawing.FontStyle.Bold);
            this.lb_Away_Score.ForeColor = System.Drawing.Color.Red;
            this.lb_Away_Score.Location = new System.Drawing.Point(356, 22);
            this.lb_Away_Score.Margin = new System.Windows.Forms.Padding(0);
            this.lb_Away_Score.Name = "lb_Away_Score";
            this.lb_Away_Score.Size = new System.Drawing.Size(55, 62);
            this.lb_Away_Score.TabIndex = 21;
            this.lb_Away_Score.Text = "0";
            this.lb_Away_Score.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_Home_Score
            // 
            this.lb_Home_Score.BackColor = System.Drawing.Color.WhiteSmoke;
            this.lb_Home_Score.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lb_Home_Score.Font = new System.Drawing.Font("Arial", 38.25F, System.Drawing.FontStyle.Bold);
            this.lb_Home_Score.ForeColor = System.Drawing.Color.Red;
            this.lb_Home_Score.Location = new System.Drawing.Point(97, 18);
            this.lb_Home_Score.Margin = new System.Windows.Forms.Padding(0);
            this.lb_Home_Score.Name = "lb_Home_Score";
            this.lb_Home_Score.Size = new System.Drawing.Size(55, 62);
            this.lb_Home_Score.TabIndex = 21;
            this.lb_Home_Score.Text = "0";
            this.lb_Home_Score.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lb_Sport
            // 
            this.lb_Sport.AutoSize = true;
            this.lb_Sport.Location = new System.Drawing.Point(136, 13);
            this.lb_Sport.Name = "lb_Sport";
            this.lb_Sport.Size = new System.Drawing.Size(65, 12);
            this.lb_Sport.TabIndex = 21;
            this.lb_Sport.Text = "SportName:";
            // 
            // btnx_HomePlayer
            // 
            this.btnx_HomePlayer.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_HomePlayer.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_HomePlayer.Location = new System.Drawing.Point(8, 47);
            this.btnx_HomePlayer.Name = "btnx_HomePlayer";
            this.btnx_HomePlayer.Size = new System.Drawing.Size(100, 25);
            this.btnx_HomePlayer.TabIndex = 3;
            this.btnx_HomePlayer.Text = "Home Player";
            this.btnx_HomePlayer.Click += new System.EventHandler(this.btnx_Home_Click);
            // 
            // btnx_Exit
            // 
            this.btnx_Exit.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Exit.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Exit.Location = new System.Drawing.Point(719, 14);
            this.btnx_Exit.Name = "btnx_Exit";
            this.btnx_Exit.Size = new System.Drawing.Size(100, 25);
            this.btnx_Exit.TabIndex = 1;
            this.btnx_Exit.Text = "Exit";
            this.btnx_Exit.Click += new System.EventHandler(this.btnx_Exit_Click);
            // 
            // lb_DateDes
            // 
            this.lb_DateDes.AutoSize = true;
            this.lb_DateDes.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_DateDes.ForeColor = System.Drawing.Color.Blue;
            this.lb_DateDes.Location = new System.Drawing.Point(517, 13);
            this.lb_DateDes.Name = "lb_DateDes";
            this.lb_DateDes.Size = new System.Drawing.Size(29, 12);
            this.lb_DateDes.TabIndex = 25;
            this.lb_DateDes.Text = "Date";
            // 
            // btnx_Status
            // 
            this.btnx_Status.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Status.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Status.Location = new System.Drawing.Point(719, 56);
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
            this.btnx_Status.TabIndex = 0;
            // 
            // btnx_Schedule
            // 
            this.btnx_Schedule.Name = "btnx_Schedule";
            this.btnx_Schedule.Text = "Schedule";
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
            this.btnx_Finished.Text = "Finished";
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
            // lb_Date
            // 
            this.lb_Date.AutoSize = true;
            this.lb_Date.Location = new System.Drawing.Point(467, 13);
            this.lb_Date.Name = "lb_Date";
            this.lb_Date.Size = new System.Drawing.Size(35, 12);
            this.lb_Date.TabIndex = 26;
            this.lb_Date.Text = "Date:";
            // 
            // lbRule
            // 
            this.lbRule.AutoSize = true;
            this.lbRule.ForeColor = System.Drawing.Color.Blue;
            this.lbRule.Location = new System.Drawing.Point(432, 52);
            this.lbRule.Name = "lbRule";
            this.lbRule.Size = new System.Drawing.Size(35, 12);
            this.lbRule.TabIndex = 22;
            this.lbRule.Text = "Rule:";
            // 
            // lbRSC
            // 
            this.lbRSC.AutoSize = true;
            this.lbRSC.ForeColor = System.Drawing.Color.Blue;
            this.lbRSC.Location = new System.Drawing.Point(623, 33);
            this.lbRSC.Name = "lbRSC";
            this.lbRSC.Size = new System.Drawing.Size(29, 12);
            this.lbRSC.TabIndex = 22;
            this.lbRSC.Text = "RSC:";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(588, 33);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(29, 12);
            this.label7.TabIndex = 22;
            this.label7.Text = "RSC:";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(391, 52);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(35, 12);
            this.label6.TabIndex = 22;
            this.label6.Text = "Rule:";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(285, 52);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(41, 12);
            this.label5.TabIndex = 22;
            this.label5.Text = "Court:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(136, 52);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(53, 12);
            this.label4.TabIndex = 22;
            this.label4.Text = "MatchID:";
            // 
            // btnx_Official
            // 
            this.btnx_Official.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Official.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Official.Location = new System.Drawing.Point(8, 14);
            this.btnx_Official.Name = "btnx_Official";
            this.btnx_Official.Size = new System.Drawing.Size(100, 25);
            this.btnx_Official.TabIndex = 2;
            this.btnx_Official.Text = "Official Info";
            this.btnx_Official.Click += new System.EventHandler(this.btnx_Official_Click);
            // 
            // lbCourt
            // 
            this.lbCourt.AutoSize = true;
            this.lbCourt.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbCourt.ForeColor = System.Drawing.Color.Blue;
            this.lbCourt.Location = new System.Drawing.Point(332, 52);
            this.lbCourt.Name = "lbCourt";
            this.lbCourt.Size = new System.Drawing.Size(35, 12);
            this.lbCourt.TabIndex = 24;
            this.lbCourt.Text = "Court";
            // 
            // lbMatchID
            // 
            this.lbMatchID.AutoSize = true;
            this.lbMatchID.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbMatchID.ForeColor = System.Drawing.Color.Blue;
            this.lbMatchID.Location = new System.Drawing.Point(207, 52);
            this.lbMatchID.Name = "lbMatchID";
            this.lbMatchID.Size = new System.Drawing.Size(53, 12);
            this.lbMatchID.TabIndex = 24;
            this.lbMatchID.Text = "PhaseDes";
            // 
            // lb_PhaseDes
            // 
            this.lb_PhaseDes.AutoSize = true;
            this.lb_PhaseDes.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_PhaseDes.ForeColor = System.Drawing.Color.Blue;
            this.lb_PhaseDes.Location = new System.Drawing.Point(207, 33);
            this.lb_PhaseDes.Name = "lb_PhaseDes";
            this.lb_PhaseDes.Size = new System.Drawing.Size(53, 12);
            this.lb_PhaseDes.TabIndex = 24;
            this.lb_PhaseDes.Text = "PhaseDes";
            // 
            // lb_Phase
            // 
            this.lb_Phase.AutoSize = true;
            this.lb_Phase.Location = new System.Drawing.Point(136, 33);
            this.lb_Phase.Name = "lb_Phase";
            this.lb_Phase.Size = new System.Drawing.Size(65, 12);
            this.lb_Phase.TabIndex = 22;
            this.lb_Phase.Text = "PhaseName:";
            // 
            // lb_SportDes
            // 
            this.lb_SportDes.AutoSize = true;
            this.lb_SportDes.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_SportDes.ForeColor = System.Drawing.Color.Blue;
            this.lb_SportDes.Location = new System.Drawing.Point(207, 13);
            this.lb_SportDes.Name = "lb_SportDes";
            this.lb_SportDes.Size = new System.Drawing.Size(53, 12);
            this.lb_SportDes.TabIndex = 23;
            this.lb_SportDes.Text = "SportDes";
            // 
            // tabReguDouble
            // 
            this.tabReguDouble.AttachedControl = this.tabControlPanel1;
            this.tabReguDouble.Name = "tabReguDouble";
            this.tabReguDouble.Text = "Regu&Double";
            // 
            // tabControlPanel2
            // 
            this.tabControlPanel2.Controls.Add(this.HoopgbMatchResult);
            this.tabControlPanel2.Controls.Add(this.gbHoopMatchInfo);
            this.tabControlPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tabControlPanel2.Location = new System.Drawing.Point(0, 23);
            this.tabControlPanel2.Name = "tabControlPanel2";
            this.tabControlPanel2.Padding = new System.Windows.Forms.Padding(1);
            this.tabControlPanel2.Size = new System.Drawing.Size(853, 727);
            this.tabControlPanel2.Style.BackColor1.Color = System.Drawing.Color.FromArgb(((int)(((byte)(253)))), ((int)(((byte)(253)))), ((int)(((byte)(254)))));
            this.tabControlPanel2.Style.BackColor2.Color = System.Drawing.Color.FromArgb(((int)(((byte)(157)))), ((int)(((byte)(188)))), ((int)(((byte)(227)))));
            this.tabControlPanel2.Style.Border = DevComponents.DotNetBar.eBorderType.SingleLine;
            this.tabControlPanel2.Style.BorderColor.Color = System.Drawing.Color.FromArgb(((int)(((byte)(146)))), ((int)(((byte)(165)))), ((int)(((byte)(199)))));
            this.tabControlPanel2.Style.BorderSide = ((DevComponents.DotNetBar.eBorderSide)(((DevComponents.DotNetBar.eBorderSide.Left | DevComponents.DotNetBar.eBorderSide.Right) 
            | DevComponents.DotNetBar.eBorderSide.Bottom)));
            this.tabControlPanel2.Style.GradientAngle = 90;
            this.tabControlPanel2.TabIndex = 2;
            this.tabControlPanel2.TabItem = this.tabHoop;
            // 
            // HoopgbMatchResult
            // 
            this.HoopgbMatchResult.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.HoopgbMatchResult.Controls.Add(this.dgvHoopResult);
            this.HoopgbMatchResult.Location = new System.Drawing.Point(12, 102);
            this.HoopgbMatchResult.Name = "HoopgbMatchResult";
            this.HoopgbMatchResult.Size = new System.Drawing.Size(827, 315);
            this.HoopgbMatchResult.TabIndex = 11;
            this.HoopgbMatchResult.TabStop = false;
            this.HoopgbMatchResult.Text = "Match Result";
            // 
            // dgvHoopResult
            // 
            this.dgvHoopResult.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("SimSun", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvHoopResult.DefaultCellStyle = dataGridViewCellStyle1;
            this.dgvHoopResult.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvHoopResult.Location = new System.Drawing.Point(3, 17);
            this.dgvHoopResult.MultiSelect = false;
            this.dgvHoopResult.Name = "dgvHoopResult";
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.Color.LightGreen;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.Color.Red;
            this.dgvHoopResult.RowsDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvHoopResult.RowTemplate.Height = 23;
            this.dgvHoopResult.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.CellSelect;
            this.dgvHoopResult.Size = new System.Drawing.Size(821, 295);
            this.dgvHoopResult.TabIndex = 63;
            this.dgvHoopResult.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvHoopResult_CellValueChanged);
            // 
            // gbHoopMatchInfo
            // 
            this.gbHoopMatchInfo.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.gbHoopMatchInfo.Controls.Add(this.label11);
            this.gbHoopMatchInfo.Controls.Add(this.lbHoopVenue);
            this.gbHoopMatchInfo.Controls.Add(this.buttonX1);
            this.gbHoopMatchInfo.Controls.Add(this.btnxHoopPlayer);
            this.gbHoopMatchInfo.Controls.Add(this.label13);
            this.gbHoopMatchInfo.Controls.Add(this.btnxHoopExit);
            this.gbHoopMatchInfo.Controls.Add(this.lbHoopDate);
            this.gbHoopMatchInfo.Controls.Add(this.btnxHoopStatus);
            this.gbHoopMatchInfo.Controls.Add(this.label15);
            this.gbHoopMatchInfo.Controls.Add(this.btnxHoopOfficial);
            this.gbHoopMatchInfo.Controls.Add(this.lbHoopPhaseDes);
            this.gbHoopMatchInfo.Controls.Add(this.label17);
            this.gbHoopMatchInfo.Controls.Add(this.lbHoopSportDes);
            this.gbHoopMatchInfo.Location = new System.Drawing.Point(13, 1);
            this.gbHoopMatchInfo.Name = "gbHoopMatchInfo";
            this.gbHoopMatchInfo.Size = new System.Drawing.Size(826, 95);
            this.gbHoopMatchInfo.TabIndex = 10;
            this.gbHoopMatchInfo.TabStop = false;
            this.gbHoopMatchInfo.Text = "Match Info";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(136, 14);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(35, 12);
            this.label11.TabIndex = 21;
            this.label11.Text = "Team:";
            // 
            // lbHoopVenue
            // 
            this.lbHoopVenue.AutoSize = true;
            this.lbHoopVenue.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbHoopVenue.Location = new System.Drawing.Point(517, 40);
            this.lbHoopVenue.Name = "lbHoopVenue";
            this.lbHoopVenue.Size = new System.Drawing.Size(35, 12);
            this.lbHoopVenue.TabIndex = 27;
            this.lbHoopVenue.Text = "Venue";
            // 
            // buttonX1
            // 
            this.buttonX1.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.buttonX1.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.buttonX1.Location = new System.Drawing.Point(126, 56);
            this.buttonX1.Name = "buttonX1";
            this.buttonX1.Size = new System.Drawing.Size(100, 33);
            this.buttonX1.TabIndex = 3;
            this.buttonX1.Text = "Clear Result";
            this.buttonX1.Click += new System.EventHandler(this.btnxHoopClear_Click);
            // 
            // btnxHoopPlayer
            // 
            this.btnxHoopPlayer.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxHoopPlayer.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxHoopPlayer.Location = new System.Drawing.Point(8, 56);
            this.btnxHoopPlayer.Name = "btnxHoopPlayer";
            this.btnxHoopPlayer.Size = new System.Drawing.Size(100, 33);
            this.btnxHoopPlayer.TabIndex = 3;
            this.btnxHoopPlayer.Text = "Player";
            this.btnxHoopPlayer.Click += new System.EventHandler(this.btnxHoopPlayer_Click);
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Location = new System.Drawing.Point(467, 40);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(41, 12);
            this.label13.TabIndex = 28;
            this.label13.Text = "Venue:";
            // 
            // btnxHoopExit
            // 
            this.btnxHoopExit.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxHoopExit.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxHoopExit.Location = new System.Drawing.Point(719, 14);
            this.btnxHoopExit.Name = "btnxHoopExit";
            this.btnxHoopExit.Size = new System.Drawing.Size(100, 25);
            this.btnxHoopExit.TabIndex = 1;
            this.btnxHoopExit.Text = "Exit";
            this.btnxHoopExit.Click += new System.EventHandler(this.btnxHoopExit_Click);
            // 
            // lbHoopDate
            // 
            this.lbHoopDate.AutoSize = true;
            this.lbHoopDate.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbHoopDate.Location = new System.Drawing.Point(517, 14);
            this.lbHoopDate.Name = "lbHoopDate";
            this.lbHoopDate.Size = new System.Drawing.Size(29, 12);
            this.lbHoopDate.TabIndex = 25;
            this.lbHoopDate.Text = "Date";
            // 
            // btnxHoopStatus
            // 
            this.btnxHoopStatus.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxHoopStatus.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxHoopStatus.Location = new System.Drawing.Point(719, 56);
            this.btnxHoopStatus.Name = "btnxHoopStatus";
            this.btnxHoopStatus.Size = new System.Drawing.Size(100, 25);
            this.btnxHoopStatus.SubItems.AddRange(new DevComponents.DotNetBar.BaseItem[] {
            this.btnx_HoopSchedule,
            this.btnx_HoopStartList,
            this.btnx_HoopRunning,
            this.btnx_HoopSuspend,
            this.btnx_HoopUnOfficial,
            this.btnx_HoopFinished,
            this.btnx_HoopRevision,
            this.btnx_HoopCanceled});
            this.btnxHoopStatus.TabIndex = 0;
            // 
            // btnx_HoopSchedule
            // 
            this.btnx_HoopSchedule.Name = "btnx_HoopSchedule";
            this.btnx_HoopSchedule.Text = "Schedule";
            // 
            // btnx_HoopStartList
            // 
            this.btnx_HoopStartList.Name = "btnx_HoopStartList";
            this.btnx_HoopStartList.Text = "StartList";
            this.btnx_HoopStartList.Click += new System.EventHandler(this.btnx_HoopStatus_Click);
            // 
            // btnx_HoopRunning
            // 
            this.btnx_HoopRunning.Name = "btnx_HoopRunning";
            this.btnx_HoopRunning.Text = "Running";
            this.btnx_HoopRunning.Click += new System.EventHandler(this.btnx_HoopStatus_Click);
            // 
            // btnx_HoopSuspend
            // 
            this.btnx_HoopSuspend.Name = "btnx_HoopSuspend";
            this.btnx_HoopSuspend.Text = "Suspend";
            this.btnx_HoopSuspend.Click += new System.EventHandler(this.btnx_HoopStatus_Click);
            // 
            // btnx_HoopUnOfficial
            // 
            this.btnx_HoopUnOfficial.Name = "btnx_HoopUnOfficial";
            this.btnx_HoopUnOfficial.Text = "Unofficial";
            this.btnx_HoopUnOfficial.Click += new System.EventHandler(this.btnx_HoopStatus_Click);
            // 
            // btnx_HoopFinished
            // 
            this.btnx_HoopFinished.Name = "btnx_HoopFinished";
            this.btnx_HoopFinished.Text = "Finished";
            this.btnx_HoopFinished.Click += new System.EventHandler(this.btnx_HoopStatus_Click);
            // 
            // btnx_HoopRevision
            // 
            this.btnx_HoopRevision.Name = "btnx_HoopRevision";
            this.btnx_HoopRevision.Text = "Revision";
            this.btnx_HoopRevision.Click += new System.EventHandler(this.btnx_HoopStatus_Click);
            // 
            // btnx_HoopCanceled
            // 
            this.btnx_HoopCanceled.Name = "btnx_HoopCanceled";
            this.btnx_HoopCanceled.Text = "Canceled";
            this.btnx_HoopCanceled.Click += new System.EventHandler(this.btnx_HoopStatus_Click);
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Location = new System.Drawing.Point(467, 14);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(35, 12);
            this.label15.TabIndex = 26;
            this.label15.Text = "Date:";
            // 
            // btnxHoopOfficial
            // 
            this.btnxHoopOfficial.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnxHoopOfficial.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnxHoopOfficial.Location = new System.Drawing.Point(8, 14);
            this.btnxHoopOfficial.Name = "btnxHoopOfficial";
            this.btnxHoopOfficial.Size = new System.Drawing.Size(100, 36);
            this.btnxHoopOfficial.TabIndex = 2;
            this.btnxHoopOfficial.Text = "Official Info";
            this.btnxHoopOfficial.Click += new System.EventHandler(this.btnxHoopOfficial_Click);
            // 
            // lbHoopPhaseDes
            // 
            this.lbHoopPhaseDes.AutoSize = true;
            this.lbHoopPhaseDes.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbHoopPhaseDes.Location = new System.Drawing.Point(207, 40);
            this.lbHoopPhaseDes.Name = "lbHoopPhaseDes";
            this.lbHoopPhaseDes.Size = new System.Drawing.Size(53, 12);
            this.lbHoopPhaseDes.TabIndex = 24;
            this.lbHoopPhaseDes.Text = "PhaseDes";
            // 
            // label17
            // 
            this.label17.AutoSize = true;
            this.label17.Location = new System.Drawing.Point(136, 40);
            this.label17.Name = "label17";
            this.label17.Size = new System.Drawing.Size(65, 12);
            this.label17.TabIndex = 22;
            this.label17.Text = "PhaseName:";
            // 
            // lbHoopSportDes
            // 
            this.lbHoopSportDes.AutoSize = true;
            this.lbHoopSportDes.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbHoopSportDes.Location = new System.Drawing.Point(207, 14);
            this.lbHoopSportDes.Name = "lbHoopSportDes";
            this.lbHoopSportDes.Size = new System.Drawing.Size(53, 12);
            this.lbHoopSportDes.TabIndex = 23;
            this.lbHoopSportDes.Text = "SportDes";
            // 
            // tabHoop
            // 
            this.tabHoop.AttachedControl = this.tabControlPanel2;
            this.tabHoop.Name = "tabHoop";
            this.tabHoop.Text = "Hoop";
            // 
            // frmOVRSEDataEntry
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(853, 750);
            this.Controls.Add(this.tabControlDataEntry);
            this.DoubleBuffered = true;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "frmOVRSEDataEntry";
            this.Text = "frmOVRSEDataEntry";
            this.Load += new System.EventHandler(this.frmOVRSEDataEntry_Load);
            ((System.ComponentModel.ISupportInitialize)(this.tabControlDataEntry)).EndInit();
            this.tabControlDataEntry.ResumeLayout(false);
            this.tabControlPanel1.ResumeLayout(false);
            this.gb_ImportResult.ResumeLayout(false);
            this.gb_ImportResult.PerformLayout();
            this.gb_MatchResult.ResumeLayout(false);
            this.gb_MatchResult.PerformLayout();
            this.gb_Server.ResumeLayout(false);
            this.gb_Server.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvTeamB)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvTeamA)).EndInit();
            this.gb_MatchInfo.ResumeLayout(false);
            this.gb_MatchInfo.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.tabControlPanel2.ResumeLayout(false);
            this.HoopgbMatchResult.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvHoopResult)).EndInit();
            this.gbHoopMatchInfo.ResumeLayout(false);
            this.gbHoopMatchInfo.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.FolderBrowserDialog folderSelDlg;
        private System.Windows.Forms.Timer timerNetPath;
        private DevComponents.DotNetBar.TabControl tabControlDataEntry;
        private DevComponents.DotNetBar.TabControlPanel tabControlPanel1;
        private DevComponents.DotNetBar.TabItem tabReguDouble;
        private System.Windows.Forms.GroupBox gb_ImportResult;
        private DevComponents.DotNetBar.ButtonX btnxImStatistic;
        private DevComponents.DotNetBar.ButtonX btnxExTeam;
        private DevComponents.DotNetBar.Controls.TextBoxX tbImportMsg;
        private DevComponents.DotNetBar.Controls.CheckBoxX chkAutoImport;
        private DevComponents.DotNetBar.Controls.CheckBoxX chkOuterData;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private DevComponents.DotNetBar.ButtonX btnxExSchedule;
        private DevComponents.DotNetBar.ButtonX btnxImportAction;
        private DevComponents.DotNetBar.ButtonX btnxImportMatchInfo;
        private DevComponents.DotNetBar.ButtonX btnxExAthlete;
        private DevComponents.DotNetBar.ButtonX btnxManualPathSel;
        private DevComponents.DotNetBar.ButtonX btnxImPathSel;
        private DevComponents.DotNetBar.ButtonX btnxExPathSel;
        private DevComponents.DotNetBar.Controls.TextBoxX tbManualPath;
        private DevComponents.DotNetBar.Controls.TextBoxX tbImportPath;
        private DevComponents.DotNetBar.Controls.TextBoxX tbExportPath;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbFilterDate;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label lb_ImportPath;
        private System.Windows.Forms.Label lb_ExportPath;
        private System.Windows.Forms.Label lb_SelectDate;
        private System.Windows.Forms.GroupBox gb_MatchResult;
        private System.Windows.Forms.GroupBox gb_Server;
        private System.Windows.Forms.RadioButton rad_ServerB;
        private System.Windows.Forms.RadioButton rad_ServerA;
        private System.Windows.Forms.Label lb_B_GameTotal;
        private System.Windows.Forms.Label lb_A_GameTotal;
        private System.Windows.Forms.Label lb_GameTotal;
        private System.Windows.Forms.Label lb_A_Game5;
        private System.Windows.Forms.Label lb_A_Game3;
        private System.Windows.Forms.Label lb_A_Game4;
        private System.Windows.Forms.Label lb_A_Game2;
        private System.Windows.Forms.Label lb_B_Game5;
        private System.Windows.Forms.Label lb_B_Game3;
        private System.Windows.Forms.Label lb_B_Game4;
        private System.Windows.Forms.Label lb_B_Game2;
        private System.Windows.Forms.Label lb_B_Game1;
        private System.Windows.Forms.Label lb_A_Game1;
        private System.Windows.Forms.RadioButton rad_Game5;
        private System.Windows.Forms.RadioButton rad_Game4;
        private System.Windows.Forms.RadioButton rad_Game3;
        private System.Windows.Forms.RadioButton rad_Game2;
        private System.Windows.Forms.RadioButton rad_Game1;
        private DevComponents.DotNetBar.ButtonX btnx_Match3;
        private DevComponents.DotNetBar.ButtonX btnx_Match2;
        private DevComponents.DotNetBar.ButtonX btnx_Match1;
        private DevComponents.DotNetBar.ButtonX btnx_B_Add;
        private DevComponents.DotNetBar.ButtonX btnx_A_Add;
        private DevComponents.DotNetBar.ButtonX btnx_Undo;
        private System.Windows.Forms.DataGridView dgvTeamB;
        private System.Windows.Forms.DataGridView dgvTeamA;
        private System.Windows.Forms.GroupBox gb_MatchInfo;
        private DevComponents.DotNetBar.ButtonX btnx_ModifyTime;
        private DevComponents.DotNetBar.ButtonX btnx_VisitorPlayer;
        private System.Windows.Forms.GroupBox groupBox3;
        private DevComponents.DotNetBar.ButtonX btnx_Modify_Result;
        private DevComponents.DotNetBar.ButtonX btnx_Away_Sub;
        private DevComponents.DotNetBar.ButtonX btnx_Home_Sub;
        private DevComponents.DotNetBar.ButtonX btnx_Away_Add;
        private DevComponents.DotNetBar.ButtonX btnx_Home_Add;
        private System.Windows.Forms.Label lb_TotalScore;
        private System.Windows.Forms.Label lb_AwayDes;
        private System.Windows.Forms.Label lb_HomeDes;
        private System.Windows.Forms.Label lb_Away_Score;
        private System.Windows.Forms.Label lb_Home_Score;
        private System.Windows.Forms.Label lb_Sport;
        private DevComponents.DotNetBar.ButtonX btnx_HomePlayer;
        private DevComponents.DotNetBar.ButtonX btnx_Exit;
        private System.Windows.Forms.Label lb_DateDes;
        private DevComponents.DotNetBar.ButtonX btnx_Status;
        private DevComponents.DotNetBar.ButtonItem btnx_Schedule;
        private DevComponents.DotNetBar.ButtonItem btnx_StartList;
        private DevComponents.DotNetBar.ButtonItem btnx_Running;
        private DevComponents.DotNetBar.ButtonItem btnx_Suspend;
        private DevComponents.DotNetBar.ButtonItem btnx_Unofficial;
        private DevComponents.DotNetBar.ButtonItem btnx_Finished;
        private DevComponents.DotNetBar.ButtonItem btnx_Revision;
        private DevComponents.DotNetBar.ButtonItem btnx_Canceled;
        private System.Windows.Forms.Label lb_Date;
        private DevComponents.DotNetBar.ButtonX btnx_Official;
        private System.Windows.Forms.Label lb_PhaseDes;
        private System.Windows.Forms.Label lb_Phase;
        private System.Windows.Forms.Label lb_SportDes;
        private DevComponents.DotNetBar.TabControlPanel tabControlPanel2;
        private DevComponents.DotNetBar.TabItem tabHoop;
        private System.Windows.Forms.GroupBox gbHoopMatchInfo;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label lbHoopVenue;
        private DevComponents.DotNetBar.ButtonX btnxHoopPlayer;
        private System.Windows.Forms.Label label13;
        private DevComponents.DotNetBar.ButtonX btnxHoopExit;
        private System.Windows.Forms.Label lbHoopDate;
        private DevComponents.DotNetBar.ButtonX btnxHoopStatus;
        private DevComponents.DotNetBar.ButtonItem btnx_HoopSchedule;
        private DevComponents.DotNetBar.ButtonItem btnx_HoopStartList;
        private DevComponents.DotNetBar.ButtonItem btnx_HoopRunning;
        private DevComponents.DotNetBar.ButtonItem btnx_HoopSuspend;
        private DevComponents.DotNetBar.ButtonItem btnx_HoopUnOfficial;
        private DevComponents.DotNetBar.ButtonItem btnx_HoopFinished;
        private DevComponents.DotNetBar.ButtonItem btnx_HoopRevision;
        private DevComponents.DotNetBar.ButtonItem btnx_HoopCanceled;
        private System.Windows.Forms.Label label15;
        private DevComponents.DotNetBar.ButtonX btnxHoopOfficial;
        private System.Windows.Forms.Label lbHoopPhaseDes;
        private System.Windows.Forms.Label label17;
        private System.Windows.Forms.Label lbHoopSportDes;
        private System.Windows.Forms.GroupBox HoopgbMatchResult;
        private System.Windows.Forms.DataGridView dgvHoopResult;
        private DevComponents.DotNetBar.ButtonX btnx_ExportHoopSchedule;
        private DevComponents.DotNetBar.ButtonX btnxImHoopMatchInfo;
        private DevComponents.DotNetBar.ButtonX btnxHoopCompList;
        private DevComponents.DotNetBar.ButtonX btnClearRes;
        private DevComponents.DotNetBar.ButtonX buttonX1;
        private DevComponents.DotNetBar.ButtonX btnScoreBoard;
        private DevComponents.DotNetBar.ButtonX btnConvertRsc;
        private DevComponents.DotNetBar.Controls.TextBoxX tbRSC;
        private DevComponents.DotNetBar.Controls.TextBoxX tbMatchID;
        private DevComponents.DotNetBar.LabelX labelX3;
        private DevComponents.DotNetBar.LabelX labelX4;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label lbMatchID;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label lbCourt;
        private System.Windows.Forms.Label lbRule;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label lbRSC;

    }
}