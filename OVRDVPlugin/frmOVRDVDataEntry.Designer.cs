namespace OVRDVPlugin
{
    partial class frmOVRDVDataEntry
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
            this.panelTop = new System.Windows.Forms.Panel();
            this.btnDBInterface = new DevComponents.DotNetBar.ButtonX();
            this.btnTsInterface = new System.Windows.Forms.Button();
            this.panel1 = new System.Windows.Forms.Panel();
            this.btnx_Config = new DevComponents.DotNetBar.ButtonX();
            this.btnx_DiveList = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Judges = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Status = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Schedule = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_StartList = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Running = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Suspend = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Unofficial = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Finished = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Revision = new DevComponents.DotNetBar.ButtonItem();
            this.btnx_Canceled = new DevComponents.DotNetBar.ButtonItem();
            this.panelRoundStatusBtn = new System.Windows.Forms.Panel();
            this.panelRoundBtn = new System.Windows.Forms.Panel();
            this.btnx_Exit = new DevComponents.DotNetBar.ButtonX();
            this.lb_Date = new System.Windows.Forms.Label();
            this.lb_DateDes = new System.Windows.Forms.Label();
            this.lb_MatchDes = new System.Windows.Forms.Label();
            this.lb_EventDes = new System.Windows.Forms.Label();
            this.lb_Match = new System.Windows.Forms.Label();
            this.lb_Event = new System.Windows.Forms.Label();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.dgvMatchSplitResult = new System.Windows.Forms.DataGridView();
            this.SplitResultContentMenu = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.MenuOK = new System.Windows.Forms.ToolStripMenuItem();
            this.MenuDNS = new System.Windows.Forms.ToolStripMenuItem();
            this.MenuDNF = new System.Windows.Forms.ToolStripMenuItem();
            this.MenuDSQ = new System.Windows.Forms.ToolStripMenuItem();
            this.dgvMatchResult = new System.Windows.Forms.DataGridView();
            this.panelRight = new System.Windows.Forms.Panel();
            this.btnOutPut2TS = new DevComponents.DotNetBar.ButtonX();
            this.panelLeft = new System.Windows.Forms.Panel();
            this.btn_SetCurDiver = new DevComponents.DotNetBar.ButtonX();
            this.panelTop.SuspendLayout();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchSplitResult)).BeginInit();
            this.SplitResultContentMenu.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchResult)).BeginInit();
            this.panelRight.SuspendLayout();
            this.panelLeft.SuspendLayout();
            this.SuspendLayout();
            // 
            // panelTop
            // 
            this.panelTop.Controls.Add(this.btnTsInterface);
            this.panelTop.Controls.Add(this.panel1);
            this.panelTop.Controls.Add(this.panelRoundStatusBtn);
            this.panelTop.Controls.Add(this.panelRoundBtn);
            this.panelTop.Controls.Add(this.btnx_Exit);
            this.panelTop.Controls.Add(this.lb_Date);
            this.panelTop.Controls.Add(this.lb_DateDes);
            this.panelTop.Controls.Add(this.lb_MatchDes);
            this.panelTop.Controls.Add(this.lb_EventDes);
            this.panelTop.Controls.Add(this.lb_Match);
            this.panelTop.Controls.Add(this.lb_Event);
            this.panelTop.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelTop.Location = new System.Drawing.Point(0, 0);
            this.panelTop.Name = "panelTop";
            this.panelTop.Size = new System.Drawing.Size(967, 127);
            this.panelTop.TabIndex = 0;
            // 
            // btnDBInterface
            // 
            this.btnDBInterface.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDBInterface.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnDBInterface.Location = new System.Drawing.Point(12, 50);
            this.btnDBInterface.Name = "btnDBInterface";
            this.btnDBInterface.Size = new System.Drawing.Size(115, 25);
            this.btnDBInterface.TabIndex = 63;
            this.btnDBInterface.Text = "DBInterface";
            this.btnDBInterface.Click += new System.EventHandler(this.btnDBInterface_Click);
            // 
            // btnTsInterface
            // 
            this.btnTsInterface.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.btnTsInterface.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(119)))), ((int)(((byte)(147)))), ((int)(((byte)(185)))));
            this.btnTsInterface.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(224)))), ((int)(((byte)(192)))));
            this.btnTsInterface.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Lime;
            this.btnTsInterface.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnTsInterface.Location = new System.Drawing.Point(12, 36);
            this.btnTsInterface.Name = "btnTsInterface";
            this.btnTsInterface.Size = new System.Drawing.Size(101, 26);
            this.btnTsInterface.TabIndex = 63;
            this.btnTsInterface.Text = "TSInterface";
            this.btnTsInterface.UseVisualStyleBackColor = false;
            this.btnTsInterface.Click += new System.EventHandler(this.btnx_OpenTSInterface);
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.btnx_Config);
            this.panel1.Controls.Add(this.btnx_DiveList);
            this.panel1.Controls.Add(this.btnx_Judges);
            this.panel1.Controls.Add(this.btnx_Status);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Right;
            this.panel1.Location = new System.Drawing.Point(860, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(107, 127);
            this.panel1.TabIndex = 62;
            // 
            // btnx_Config
            // 
            this.btnx_Config.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Config.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Config.Location = new System.Drawing.Point(3, 5);
            this.btnx_Config.Name = "btnx_Config";
            this.btnx_Config.Size = new System.Drawing.Size(101, 25);
            this.btnx_Config.TabIndex = 55;
            this.btnx_Config.Text = "Match Config";
            this.btnx_Config.Click += new System.EventHandler(this.btnx_Config_Click);
            // 
            // btnx_DiveList
            // 
            this.btnx_DiveList.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_DiveList.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_DiveList.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnx_DiveList.Location = new System.Drawing.Point(3, 68);
            this.btnx_DiveList.Name = "btnx_DiveList";
            this.btnx_DiveList.Size = new System.Drawing.Size(101, 25);
            this.btnx_DiveList.TabIndex = 61;
            this.btnx_DiveList.Text = "Dive List";
            this.btnx_DiveList.Click += new System.EventHandler(this.btnx_DiveList_Click);
            // 
            // btnx_Judges
            // 
            this.btnx_Judges.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Judges.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Judges.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnx_Judges.Location = new System.Drawing.Point(3, 36);
            this.btnx_Judges.Name = "btnx_Judges";
            this.btnx_Judges.Size = new System.Drawing.Size(101, 25);
            this.btnx_Judges.TabIndex = 56;
            this.btnx_Judges.Text = "Match Official";
            this.btnx_Judges.Click += new System.EventHandler(this.btnx_Judges_Click);
            // 
            // btnx_Status
            // 
            this.btnx_Status.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Status.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Status.Location = new System.Drawing.Point(3, 100);
            this.btnx_Status.Name = "btnx_Status";
            this.btnx_Status.Size = new System.Drawing.Size(101, 25);
            this.btnx_Status.SubItems.AddRange(new DevComponents.DotNetBar.BaseItem[] {
            this.btnx_Schedule,
            this.btnx_StartList,
            this.btnx_Running,
            this.btnx_Suspend,
            this.btnx_Unofficial,
            this.btnx_Finished,
            this.btnx_Revision,
            this.btnx_Canceled});
            this.btnx_Status.TabIndex = 57;
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
            // panelRoundStatusBtn
            // 
            this.panelRoundStatusBtn.Location = new System.Drawing.Point(12, 95);
            this.panelRoundStatusBtn.Name = "panelRoundStatusBtn";
            this.panelRoundStatusBtn.Size = new System.Drawing.Size(842, 25);
            this.panelRoundStatusBtn.TabIndex = 60;
            // 
            // panelRoundBtn
            // 
            this.panelRoundBtn.Location = new System.Drawing.Point(12, 68);
            this.panelRoundBtn.Name = "panelRoundBtn";
            this.panelRoundBtn.Size = new System.Drawing.Size(842, 25);
            this.panelRoundBtn.TabIndex = 58;
            // 
            // btnx_Exit
            // 
            this.btnx_Exit.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Exit.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Exit.Location = new System.Drawing.Point(12, 7);
            this.btnx_Exit.Name = "btnx_Exit";
            this.btnx_Exit.Size = new System.Drawing.Size(101, 25);
            this.btnx_Exit.TabIndex = 54;
            this.btnx_Exit.Text = "Exit";
            this.btnx_Exit.Click += new System.EventHandler(this.btnx_Exit_Click);
            // 
            // lb_Date
            // 
            this.lb_Date.AutoSize = true;
            this.lb_Date.Location = new System.Drawing.Point(600, 12);
            this.lb_Date.Name = "lb_Date";
            this.lb_Date.Size = new System.Drawing.Size(35, 12);
            this.lb_Date.TabIndex = 51;
            this.lb_Date.Text = "Date:";
            // 
            // lb_DateDes
            // 
            this.lb_DateDes.AutoSize = true;
            this.lb_DateDes.Font = new System.Drawing.Font("Arial", 11F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_DateDes.Location = new System.Drawing.Point(646, 10);
            this.lb_DateDes.Name = "lb_DateDes";
            this.lb_DateDes.Size = new System.Drawing.Size(41, 18);
            this.lb_DateDes.TabIndex = 50;
            this.lb_DateDes.Text = "Date";
            // 
            // lb_MatchDes
            // 
            this.lb_MatchDes.AutoSize = true;
            this.lb_MatchDes.Font = new System.Drawing.Font("Arial", 11F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_MatchDes.Location = new System.Drawing.Point(210, 34);
            this.lb_MatchDes.Name = "lb_MatchDes";
            this.lb_MatchDes.Size = new System.Drawing.Size(79, 18);
            this.lb_MatchDes.TabIndex = 49;
            this.lb_MatchDes.Text = "MatchDes";
            // 
            // lb_EventDes
            // 
            this.lb_EventDes.AutoSize = true;
            this.lb_EventDes.Font = new System.Drawing.Font("Arial", 11F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_EventDes.Location = new System.Drawing.Point(211, 10);
            this.lb_EventDes.Name = "lb_EventDes";
            this.lb_EventDes.Size = new System.Drawing.Size(78, 18);
            this.lb_EventDes.TabIndex = 48;
            this.lb_EventDes.Text = "EventDes";
            // 
            // lb_Match
            // 
            this.lb_Match.AutoSize = true;
            this.lb_Match.Location = new System.Drawing.Point(139, 36);
            this.lb_Match.Name = "lb_Match";
            this.lb_Match.Size = new System.Drawing.Size(65, 12);
            this.lb_Match.TabIndex = 47;
            this.lb_Match.Text = "MatchName:";
            // 
            // lb_Event
            // 
            this.lb_Event.AutoSize = true;
            this.lb_Event.Location = new System.Drawing.Point(139, 12);
            this.lb_Event.Name = "lb_Event";
            this.lb_Event.Size = new System.Drawing.Size(65, 12);
            this.lb_Event.TabIndex = 46;
            this.lb_Event.Text = "EventName:";
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(0, 127);
            this.splitContainer1.Name = "splitContainer1";
            this.splitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.dgvMatchSplitResult);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.dgvMatchResult);
            this.splitContainer1.Panel2.Controls.Add(this.panelRight);
            this.splitContainer1.Panel2.Controls.Add(this.panelLeft);
            this.splitContainer1.Size = new System.Drawing.Size(967, 320);
            this.splitContainer1.SplitterDistance = 196;
            this.splitContainer1.TabIndex = 1;
            // 
            // dgvMatchSplitResult
            // 
            this.dgvMatchSplitResult.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchSplitResult.ContextMenuStrip = this.SplitResultContentMenu;
            this.dgvMatchSplitResult.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvMatchSplitResult.Location = new System.Drawing.Point(0, 0);
            this.dgvMatchSplitResult.MultiSelect = false;
            this.dgvMatchSplitResult.Name = "dgvMatchSplitResult";
            this.dgvMatchSplitResult.RowTemplate.Height = 23;
            this.dgvMatchSplitResult.Size = new System.Drawing.Size(967, 196);
            this.dgvMatchSplitResult.TabIndex = 0;
            this.dgvMatchSplitResult.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchSplitResult_CellValueChanged);
            // 
            // SplitResultContentMenu
            // 
            this.SplitResultContentMenu.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.MenuOK,
            this.MenuDNS,
            this.MenuDNF,
            this.MenuDSQ});
            this.SplitResultContentMenu.Name = "contextMenuStrip1";
            this.SplitResultContentMenu.Size = new System.Drawing.Size(96, 92);
            this.SplitResultContentMenu.Text = "DSQ";
            // 
            // MenuOK
            // 
            this.MenuOK.Name = "MenuOK";
            this.MenuOK.Size = new System.Drawing.Size(95, 22);
            this.MenuOK.Text = "OK";
            this.MenuOK.Click += new System.EventHandler(this.MenuOK_Click);
            // 
            // MenuDNS
            // 
            this.MenuDNS.Name = "MenuDNS";
            this.MenuDNS.Size = new System.Drawing.Size(95, 22);
            this.MenuDNS.Text = "DNS";
            this.MenuDNS.Click += new System.EventHandler(this.MenuDNS_Click);
            // 
            // MenuDNF
            // 
            this.MenuDNF.Name = "MenuDNF";
            this.MenuDNF.Size = new System.Drawing.Size(95, 22);
            this.MenuDNF.Text = "DNF";
            this.MenuDNF.Click += new System.EventHandler(this.MenuDNF_Click);
            // 
            // MenuDSQ
            // 
            this.MenuDSQ.Name = "MenuDSQ";
            this.MenuDSQ.Size = new System.Drawing.Size(95, 22);
            this.MenuDSQ.Text = "DSQ";
            this.MenuDSQ.Click += new System.EventHandler(this.MenuDSQ_Click);
            // 
            // dgvMatchResult
            // 
            this.dgvMatchResult.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvMatchResult.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchResult.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvMatchResult.Location = new System.Drawing.Point(161, 0);
            this.dgvMatchResult.MultiSelect = false;
            this.dgvMatchResult.Name = "dgvMatchResult";
            this.dgvMatchResult.RowTemplate.Height = 23;
            this.dgvMatchResult.Size = new System.Drawing.Size(645, 120);
            this.dgvMatchResult.TabIndex = 2;
            this.dgvMatchResult.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchResult_CellValueChanged);
            // 
            // panelRight
            // 
            this.panelRight.Controls.Add(this.btnOutPut2TS);
            this.panelRight.Dock = System.Windows.Forms.DockStyle.Right;
            this.panelRight.Location = new System.Drawing.Point(806, 0);
            this.panelRight.Name = "panelRight";
            this.panelRight.Size = new System.Drawing.Size(161, 120);
            this.panelRight.TabIndex = 1;
            // 
            // btnOutPut2TS
            // 
            this.btnOutPut2TS.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOutPut2TS.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOutPut2TS.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnOutPut2TS.Location = new System.Drawing.Point(17, 14);
            this.btnOutPut2TS.Name = "btnOutPut2TS";
            this.btnOutPut2TS.Size = new System.Drawing.Size(115, 25);
            this.btnOutPut2TS.TabIndex = 63;
            this.btnOutPut2TS.Text = "Output to TS";
            this.btnOutPut2TS.Click += new System.EventHandler(this.btnOutPut2TS_Click);
            // 
            // panelLeft
            // 
            this.panelLeft.Controls.Add(this.btnDBInterface);
            this.panelLeft.Controls.Add(this.btn_SetCurDiver);
            this.panelLeft.Dock = System.Windows.Forms.DockStyle.Left;
            this.panelLeft.Location = new System.Drawing.Point(0, 0);
            this.panelLeft.Name = "panelLeft";
            this.panelLeft.Size = new System.Drawing.Size(161, 120);
            this.panelLeft.TabIndex = 0;
            // 
            // btn_SetCurDiver
            // 
            this.btn_SetCurDiver.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_SetCurDiver.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btn_SetCurDiver.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btn_SetCurDiver.Location = new System.Drawing.Point(12, 3);
            this.btn_SetCurDiver.Name = "btn_SetCurDiver";
            this.btn_SetCurDiver.Size = new System.Drawing.Size(115, 25);
            this.btn_SetCurDiver.TabIndex = 62;
            this.btn_SetCurDiver.Text = "Set Current Diver";
            this.btn_SetCurDiver.Click += new System.EventHandler(this.btn_SetCurDiver_Click);
            // 
            // frmOVRDVDataEntry
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(967, 447);
            this.Controls.Add(this.splitContainer1);
            this.Controls.Add(this.panelTop);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "frmOVRDVDataEntry";
            this.Text = "frmOVRDVDataEntry";
            this.panelTop.ResumeLayout(false);
            this.panelTop.PerformLayout();
            this.panel1.ResumeLayout(false);
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchSplitResult)).EndInit();
            this.SplitResultContentMenu.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchResult)).EndInit();
            this.panelRight.ResumeLayout(false);
            this.panelLeft.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panelTop;
        private DevComponents.DotNetBar.ButtonX btnx_Status;
        private DevComponents.DotNetBar.ButtonItem btnx_Schedule;
        private DevComponents.DotNetBar.ButtonItem btnx_StartList;
        private DevComponents.DotNetBar.ButtonItem btnx_Running;
        private DevComponents.DotNetBar.ButtonItem btnx_Suspend;
        private DevComponents.DotNetBar.ButtonItem btnx_Unofficial;
        private DevComponents.DotNetBar.ButtonItem btnx_Finished;
        private DevComponents.DotNetBar.ButtonItem btnx_Revision;
        private DevComponents.DotNetBar.ButtonItem btnx_Canceled;
        private DevComponents.DotNetBar.ButtonX btnx_Exit;
        private DevComponents.DotNetBar.ButtonX btnx_Judges;
        private DevComponents.DotNetBar.ButtonX btnx_Config;
        private System.Windows.Forms.Label lb_Date;
        private System.Windows.Forms.Label lb_DateDes;
        private System.Windows.Forms.Label lb_MatchDes;
        private System.Windows.Forms.Label lb_Match;
        private System.Windows.Forms.Label lb_Event;
        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.Label lb_EventDes;
        private System.Windows.Forms.Panel panelRoundStatusBtn;
        private System.Windows.Forms.Panel panelRoundBtn;
        private System.Windows.Forms.DataGridView dgvMatchSplitResult;
        private System.Windows.Forms.DataGridView dgvMatchResult;
        private System.Windows.Forms.Panel panelRight;
        private System.Windows.Forms.Panel panelLeft;
        private DevComponents.DotNetBar.ButtonX btnx_DiveList;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.ContextMenuStrip SplitResultContentMenu;
        private System.Windows.Forms.ToolStripMenuItem MenuOK;
        private System.Windows.Forms.ToolStripMenuItem MenuDNS;
        private System.Windows.Forms.ToolStripMenuItem MenuDNF;
        private System.Windows.Forms.ToolStripMenuItem MenuDSQ;
        private System.Windows.Forms.Button btnTsInterface;
        private DevComponents.DotNetBar.ButtonX btn_SetCurDiver;
        private DevComponents.DotNetBar.ButtonX btnOutPut2TS;
        private DevComponents.DotNetBar.ButtonX btnDBInterface;
    }
}