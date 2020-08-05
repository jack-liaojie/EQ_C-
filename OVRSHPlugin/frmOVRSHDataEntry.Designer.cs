namespace AutoSports.OVRSHPlugin
{
    partial class frmOVRSHDataEntry
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
            this.dgv_List = new System.Windows.Forms.DataGridView();
            this.CMenuTime = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.setStartTimeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.btnX_StatusSetting = new DevComponents.DotNetBar.ButtonX();
            this.buttonItem_Scheduled = new DevComponents.DotNetBar.ButtonItem();
            this.buttonItem_StartList = new DevComponents.DotNetBar.ButtonItem();
            this.buttonItem_Running = new DevComponents.DotNetBar.ButtonItem();
            this.buttonItem_Suspend = new DevComponents.DotNetBar.ButtonItem();
            this.buttonItem_Unofficial = new DevComponents.DotNetBar.ButtonItem();
            this.buttonItem_Finished = new DevComponents.DotNetBar.ButtonItem();
            this.buttonItem_Revision = new DevComponents.DotNetBar.ButtonItem();
            this.buttonItem_Canceled = new DevComponents.DotNetBar.ButtonItem();
            this.label_EventName = new System.Windows.Forms.Label();
            this.label_PhaseName = new System.Windows.Forms.Label();
            this.textFp = new System.Windows.Forms.TextBox();
            this.labelPF = new System.Windows.Forms.Label();
            this.textSeries = new System.Windows.Forms.TextBox();
            this.labelSeries = new System.Windows.Forms.Label();
            this.labelInx = new System.Windows.Forms.Label();
            this.textInx = new System.Windows.Forms.TextBox();
            this.btnUpdate = new System.Windows.Forms.Button();
            this.labelScore = new System.Windows.Forms.Label();
            this.textScore = new System.Windows.Forms.TextBox();
            this.labelRelay = new System.Windows.Forms.Label();
            this.textRelay = new System.Windows.Forms.TextBox();
            this.backgroundWorker_udp = new System.ComponentModel.BackgroundWorker();
            this.btnImportCSV = new DevComponents.DotNetBar.ButtonX();
            this.label_Path = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_List)).BeginInit();
            this.CMenuTime.SuspendLayout();
            this.SuspendLayout();
            // 
            // dgv_List
            // 
            this.dgv_List.AllowUserToAddRows = false;
            this.dgv_List.AllowUserToDeleteRows = false;
            this.dgv_List.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.dgv_List.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_List.ContextMenuStrip = this.CMenuTime;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.YellowGreen;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.Color.Yellow;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgv_List.DefaultCellStyle = dataGridViewCellStyle1;
            this.dgv_List.Location = new System.Drawing.Point(0, 110);
            this.dgv_List.Name = "dgv_List";
            this.dgv_List.Size = new System.Drawing.Size(875, 470);
            this.dgv_List.TabIndex = 0;
            this.dgv_List.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.CellClick);
            this.dgv_List.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.CellEndEdit);
            // 
            // CMenuTime
            // 
            this.CMenuTime.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.setStartTimeToolStripMenuItem});
            this.CMenuTime.Name = "CMenuTime";
            this.CMenuTime.Size = new System.Drawing.Size(143, 26);
            // 
            // setStartTimeToolStripMenuItem
            // 
            this.setStartTimeToolStripMenuItem.Name = "setStartTimeToolStripMenuItem";
            this.setStartTimeToolStripMenuItem.Size = new System.Drawing.Size(142, 22);
            this.setStartTimeToolStripMenuItem.Text = "Set Start Time";
            this.setStartTimeToolStripMenuItem.Click += new System.EventHandler(this.setStartTimeToolStripMenuItem_Click);
            // 
            // btnX_StatusSetting
            // 
            this.btnX_StatusSetting.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_StatusSetting.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_StatusSetting.ImagePosition = DevComponents.DotNetBar.eImagePosition.Right;
            this.btnX_StatusSetting.Location = new System.Drawing.Point(3, 59);
            this.btnX_StatusSetting.Name = "btnX_StatusSetting";
            this.btnX_StatusSetting.Size = new System.Drawing.Size(110, 28);
            this.btnX_StatusSetting.SubItems.AddRange(new DevComponents.DotNetBar.BaseItem[] {
            this.buttonItem_Scheduled,
            this.buttonItem_StartList,
            this.buttonItem_Running,
            this.buttonItem_Suspend,
            this.buttonItem_Unofficial,
            this.buttonItem_Finished,
            this.buttonItem_Revision,
            this.buttonItem_Canceled});
            this.btnX_StatusSetting.TabIndex = 6;
            this.btnX_StatusSetting.Text = "Status Setting";
            // 
            // buttonItem_Scheduled
            // 
            this.buttonItem_Scheduled.GlobalItem = false;
            this.buttonItem_Scheduled.Name = "buttonItem_Scheduled";
            this.buttonItem_Scheduled.Text = "Scheduled";
            this.buttonItem_Scheduled.Click += new System.EventHandler(this.buttonItem_Scheduled_Click);
            // 
            // buttonItem_StartList
            // 
            this.buttonItem_StartList.GlobalItem = false;
            this.buttonItem_StartList.Name = "buttonItem_StartList";
            this.buttonItem_StartList.Text = "StartList";
            this.buttonItem_StartList.Click += new System.EventHandler(this.buttonItem_StartList_Click);
            // 
            // buttonItem_Running
            // 
            this.buttonItem_Running.GlobalItem = false;
            this.buttonItem_Running.Name = "buttonItem_Running";
            this.buttonItem_Running.Text = "Running";
            this.buttonItem_Running.Click += new System.EventHandler(this.buttonItem_Running_Click);
            // 
            // buttonItem_Suspend
            // 
            this.buttonItem_Suspend.GlobalItem = false;
            this.buttonItem_Suspend.Name = "buttonItem_Suspend";
            this.buttonItem_Suspend.Text = "Suspend";
            this.buttonItem_Suspend.Click += new System.EventHandler(this.buttonItem_Suspend_Click);
            // 
            // buttonItem_Unofficial
            // 
            this.buttonItem_Unofficial.GlobalItem = false;
            this.buttonItem_Unofficial.Name = "buttonItem_Unofficial";
            this.buttonItem_Unofficial.Text = "Unofficial";
            this.buttonItem_Unofficial.Click += new System.EventHandler(this.buttonItem_Unofficial_Click);
            // 
            // buttonItem_Finished
            // 
            this.buttonItem_Finished.GlobalItem = false;
            this.buttonItem_Finished.Name = "buttonItem_Finished";
            this.buttonItem_Finished.Text = "Finished";
            this.buttonItem_Finished.Click += new System.EventHandler(this.buttonItem_Finished_Click);
            // 
            // buttonItem_Revision
            // 
            this.buttonItem_Revision.GlobalItem = false;
            this.buttonItem_Revision.Name = "buttonItem_Revision";
            this.buttonItem_Revision.Text = "Revision";
            this.buttonItem_Revision.Click += new System.EventHandler(this.buttonItem_Revision_Click);
            // 
            // buttonItem_Canceled
            // 
            this.buttonItem_Canceled.GlobalItem = false;
            this.buttonItem_Canceled.Name = "buttonItem_Canceled";
            this.buttonItem_Canceled.Text = "Canceled";
            this.buttonItem_Canceled.Click += new System.EventHandler(this.buttonItem_Canceled_Click);
            // 
            // label_EventName
            // 
            this.label_EventName.AutoSize = true;
            this.label_EventName.Font = new System.Drawing.Font("Microsoft Sans Serif", 12.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label_EventName.Location = new System.Drawing.Point(311, 5);
            this.label_EventName.Name = "label_EventName";
            this.label_EventName.Size = new System.Drawing.Size(104, 20);
            this.label_EventName.TabIndex = 8;
            this.label_EventName.Text = "EventName";
            this.label_EventName.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // label_PhaseName
            // 
            this.label_PhaseName.AutoSize = true;
            this.label_PhaseName.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label_PhaseName.Location = new System.Drawing.Point(311, 31);
            this.label_PhaseName.Name = "label_PhaseName";
            this.label_PhaseName.Size = new System.Drawing.Size(94, 17);
            this.label_PhaseName.TabIndex = 9;
            this.label_PhaseName.Text = "PhaseName";
            this.label_PhaseName.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // textFp
            // 
            this.textFp.Location = new System.Drawing.Point(326, 64);
            this.textFp.Name = "textFp";
            this.textFp.Size = new System.Drawing.Size(58, 20);
            this.textFp.TabIndex = 10;
            this.textFp.TextChanged += new System.EventHandler(this.textFp_TextChanged);
            this.textFp.GotFocus += new System.EventHandler(this.textFP_GotFocus);
            this.textFp.MouseUp += new System.Windows.Forms.MouseEventHandler(this.textFP_MouseUp);
            // 
            // labelPF
            // 
            this.labelPF.AutoSize = true;
            this.labelPF.Location = new System.Drawing.Point(296, 66);
            this.labelPF.Name = "labelPF";
            this.labelPF.Size = new System.Drawing.Size(23, 13);
            this.labelPF.TabIndex = 11;
            this.labelPF.Text = "FP:";
            // 
            // textSeries
            // 
            this.textSeries.Location = new System.Drawing.Point(456, 64);
            this.textSeries.Name = "textSeries";
            this.textSeries.Size = new System.Drawing.Size(66, 20);
            this.textSeries.TabIndex = 11;
            this.textSeries.TextChanged += new System.EventHandler(this.textSeries_TextChanged);
            this.textSeries.GotFocus += new System.EventHandler(this.textSeries_GotFocus);
            this.textSeries.MouseUp += new System.Windows.Forms.MouseEventHandler(this.textSeries_MouseUp);
            // 
            // labelSeries
            // 
            this.labelSeries.AutoSize = true;
            this.labelSeries.Location = new System.Drawing.Point(410, 67);
            this.labelSeries.Name = "labelSeries";
            this.labelSeries.Size = new System.Drawing.Size(39, 13);
            this.labelSeries.TabIndex = 13;
            this.labelSeries.Text = "Series:";
            // 
            // labelInx
            // 
            this.labelInx.AutoSize = true;
            this.labelInx.Location = new System.Drawing.Point(659, 66);
            this.labelInx.Name = "labelInx";
            this.labelInx.Size = new System.Drawing.Size(15, 13);
            this.labelInx.TabIndex = 14;
            this.labelInx.Text = "x:";
            // 
            // textInx
            // 
            this.textInx.Location = new System.Drawing.Point(680, 62);
            this.textInx.Name = "textInx";
            this.textInx.Size = new System.Drawing.Size(66, 20);
            this.textInx.TabIndex = 13;
            this.textInx.GotFocus += new System.EventHandler(this.textInx_GotFocus);
            this.textInx.MouseUp += new System.Windows.Forms.MouseEventHandler(this.textInx_MouseUp);
            // 
            // btnUpdate
            // 
            this.btnUpdate.Location = new System.Drawing.Point(773, 60);
            this.btnUpdate.Name = "btnUpdate";
            this.btnUpdate.Size = new System.Drawing.Size(94, 27);
            this.btnUpdate.TabIndex = 14;
            this.btnUpdate.Text = "Update";
            this.btnUpdate.UseVisualStyleBackColor = true;
            this.btnUpdate.Click += new System.EventHandler(this.btnUpdate_Click);
            // 
            // labelScore
            // 
            this.labelScore.AutoSize = true;
            this.labelScore.Location = new System.Drawing.Point(541, 66);
            this.labelScore.Name = "labelScore";
            this.labelScore.Size = new System.Drawing.Size(38, 13);
            this.labelScore.TabIndex = 17;
            this.labelScore.Text = "Score:";
            // 
            // textScore
            // 
            this.textScore.Location = new System.Drawing.Point(585, 63);
            this.textScore.Name = "textScore";
            this.textScore.Size = new System.Drawing.Size(66, 20);
            this.textScore.TabIndex = 12;
            this.textScore.GotFocus += new System.EventHandler(this.textScore_GotFocus);
            this.textScore.MouseUp += new System.Windows.Forms.MouseEventHandler(this.textScore_MouseUp);
            // 
            // labelRelay
            // 
            this.labelRelay.AutoSize = true;
            this.labelRelay.Location = new System.Drawing.Point(198, 67);
            this.labelRelay.Name = "labelRelay";
            this.labelRelay.Size = new System.Drawing.Size(37, 13);
            this.labelRelay.TabIndex = 18;
            this.labelRelay.Text = "Relay:";
            // 
            // textRelay
            // 
            this.textRelay.Location = new System.Drawing.Point(241, 64);
            this.textRelay.Name = "textRelay";
            this.textRelay.Size = new System.Drawing.Size(35, 20);
            this.textRelay.TabIndex = 19;
            this.textRelay.Text = "1";
            // 
            // backgroundWorker_udp
            // 
            this.backgroundWorker_udp.DoWork += new System.ComponentModel.DoWorkEventHandler(this.backgroundWorker_udp_DoWork);
            // 
            // btnImportCSV
            // 
            this.btnImportCSV.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnImportCSV.Location = new System.Drawing.Point(3, 5);
            this.btnImportCSV.Name = "btnImportCSV";
            this.btnImportCSV.Size = new System.Drawing.Size(151, 27);
            this.btnImportCSV.TabIndex = 7;
            this.btnImportCSV.Text = "Select ODF file path...";
            this.btnImportCSV.Click += new System.EventHandler(this.btnImportCSV_Click);
            // 
            // label_Path
            // 
            this.label_Path.AutoSize = true;
            this.label_Path.Location = new System.Drawing.Point(160, 10);
            this.label_Path.Name = "label_Path";
            this.label_Path.Size = new System.Drawing.Size(0, 13);
            this.label_Path.TabIndex = 20;
            // 
            // frmOVRSHDataEntry
            // 
            this.AcceptButton = this.btnUpdate;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.ClientSize = new System.Drawing.Size(879, 572);
            this.Controls.Add(this.label_Path);
            this.Controls.Add(this.textRelay);
            this.Controls.Add(this.labelRelay);
            this.Controls.Add(this.btnUpdate);
            this.Controls.Add(this.textScore);
            this.Controls.Add(this.labelScore);
            this.Controls.Add(this.label_PhaseName);
            this.Controls.Add(this.textInx);
            this.Controls.Add(this.labelInx);
            this.Controls.Add(this.labelSeries);
            this.Controls.Add(this.textSeries);
            this.Controls.Add(this.labelPF);
            this.Controls.Add(this.textFp);
            this.Controls.Add(this.label_EventName);
            this.Controls.Add(this.btnImportCSV);
            this.Controls.Add(this.btnX_StatusSetting);
            this.Controls.Add(this.dgv_List);
            this.Name = "frmOVRSHDataEntry";
            this.Text = "frmOVRSHDataEntry";
            ((System.ComponentModel.ISupportInitialize)(this.dgv_List)).EndInit();
            this.CMenuTime.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dgv_List;
        private DevComponents.DotNetBar.ButtonX btnX_StatusSetting;
        private DevComponents.DotNetBar.ButtonItem buttonItem_Scheduled;
        private DevComponents.DotNetBar.ButtonItem buttonItem_StartList;
        private DevComponents.DotNetBar.ButtonItem buttonItem_Running;
        private DevComponents.DotNetBar.ButtonItem buttonItem_Suspend;
        private DevComponents.DotNetBar.ButtonItem buttonItem_Unofficial;
        private DevComponents.DotNetBar.ButtonItem buttonItem_Finished;
        private DevComponents.DotNetBar.ButtonItem buttonItem_Revision;
        private DevComponents.DotNetBar.ButtonItem buttonItem_Canceled;
        private System.Windows.Forms.Label label_EventName;
        private System.Windows.Forms.Label label_PhaseName;
        private System.Windows.Forms.ContextMenuStrip CMenuTime;
        private System.Windows.Forms.ToolStripMenuItem setStartTimeToolStripMenuItem;
        private System.Windows.Forms.TextBox textFp;
        private System.Windows.Forms.Label labelPF;
        private System.Windows.Forms.TextBox textSeries;
        private System.Windows.Forms.Label labelSeries;
        private System.Windows.Forms.Label labelInx;
        private System.Windows.Forms.TextBox textInx;
        private System.Windows.Forms.Button btnUpdate;
        private System.Windows.Forms.Label labelScore;
        private System.Windows.Forms.TextBox textScore;
        private System.Windows.Forms.Label labelRelay;
        private System.Windows.Forms.TextBox textRelay;
        private System.ComponentModel.BackgroundWorker backgroundWorker_udp;
        private DevComponents.DotNetBar.ButtonX btnImportCSV;
        private System.Windows.Forms.Label label_Path;
    }
}

