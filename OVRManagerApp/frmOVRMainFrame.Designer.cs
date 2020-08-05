namespace AutoSports.OVRManagerApp
{
    partial class OVRMainFrameForm
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(OVRMainFrameForm));
            this.panelModuleForm = new System.Windows.Forms.Panel();
            this.sideBarGameMgr = new DevComponents.DotNetBar.SideBar();
            this.sbItemGameMgr = new DevComponents.DotNetBar.SideBarPanelItem();
            this.btnItemGenData = new DevComponents.DotNetBar.ButtonItem();
            this.btnItemRegister = new DevComponents.DotNetBar.ButtonItem();
            this.btnItemDrawArrange = new DevComponents.DotNetBar.ButtonItem();
            this.btnItemSchedule = new DevComponents.DotNetBar.ButtonItem();
            this.btnItemMatchData = new DevComponents.DotNetBar.ButtonItem();
            this.btnItemMedal = new DevComponents.DotNetBar.ButtonItem();
            this.btnItemRecord = new DevComponents.DotNetBar.ButtonItem();
            this.btnItemReports = new DevComponents.DotNetBar.ButtonItem();
            this.btnItemNetwork = new DevComponents.DotNetBar.ButtonItem();
            this.btnItemBackup = new DevComponents.DotNetBar.ButtonItem();
            this.btnItemCommunicate = new DevComponents.DotNetBar.ButtonItem();
            this.spliterGameMgr = new DevComponents.DotNetBar.ExpandableSplitter();
            this.SuspendLayout();
            // 
            // panelModuleForm
            // 
            this.panelModuleForm.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.panelModuleForm.ForeColor = System.Drawing.SystemColors.ControlText;
            this.panelModuleForm.Location = new System.Drawing.Point(232, 67);
            this.panelModuleForm.Name = "panelModuleForm";
            this.panelModuleForm.Padding = new System.Windows.Forms.Padding(10, 3, 3, 3);
            this.panelModuleForm.Size = new System.Drawing.Size(336, 301);
            this.panelModuleForm.TabIndex = 0;
            // 
            // sideBarGameMgr
            // 
            this.sideBarGameMgr.AccessibleRole = System.Windows.Forms.AccessibleRole.ToolBar;
            this.sideBarGameMgr.BackColor = System.Drawing.SystemColors.Control;
            this.sideBarGameMgr.BorderStyle = DevComponents.DotNetBar.eBorderType.None;
            this.sideBarGameMgr.Dock = System.Windows.Forms.DockStyle.Left;
            this.sideBarGameMgr.ExpandedPanel = this.sbItemGameMgr;
            this.sideBarGameMgr.Location = new System.Drawing.Point(0, 0);
            this.sideBarGameMgr.MaximumSize = new System.Drawing.Size(120, 0);
            this.sideBarGameMgr.Name = "sideBarGameMgr";
            this.sideBarGameMgr.Panels.AddRange(new DevComponents.DotNetBar.BaseItem[] {
            this.sbItemGameMgr});
            this.sideBarGameMgr.Size = new System.Drawing.Size(120, 787);
            this.sideBarGameMgr.Style = DevComponents.DotNetBar.eDotNetBarStyle.Office2010;
            this.sideBarGameMgr.TabIndex = 1;
            this.sideBarGameMgr.Text = "sideBar";
            // 
            // sbItemGameMgr
            // 
            this.sbItemGameMgr.BackgroundStyle.BackColor1.Color = System.Drawing.Color.FromArgb(((int)(((byte)(74)))), ((int)(((byte)(122)))), ((int)(((byte)(201)))));
            this.sbItemGameMgr.BackgroundStyle.BackColor2.Color = System.Drawing.Color.FromArgb(((int)(((byte)(74)))), ((int)(((byte)(122)))), ((int)(((byte)(201)))));
            this.sbItemGameMgr.FontBold = true;
            this.sbItemGameMgr.ItemImageSize = DevComponents.DotNetBar.eBarImageSize.Large;
            this.sbItemGameMgr.Name = "sbItemGameMgr";
            this.sbItemGameMgr.SubItems.AddRange(new DevComponents.DotNetBar.BaseItem[] {
            this.btnItemGenData,
            this.btnItemRegister,
            this.btnItemDrawArrange,
            this.btnItemSchedule,
            this.btnItemMatchData,
            this.btnItemMedal,
            this.btnItemRecord,
            this.btnItemReports,
            this.btnItemNetwork,
            this.btnItemBackup,
            this.btnItemCommunicate});
            this.sbItemGameMgr.Text = "Game Manager";
            // 
            // btnItemGenData
            // 
            this.btnItemGenData.ButtonStyle = DevComponents.DotNetBar.eButtonStyle.ImageAndText;
            this.btnItemGenData.ColorTable = DevComponents.DotNetBar.eButtonColor.Blue;
            this.btnItemGenData.FontBold = true;
            this.btnItemGenData.ForeColor = System.Drawing.Color.White;
            this.btnItemGenData.Icon = ((System.Drawing.Icon)(resources.GetObject("btnItemGenData.Icon")));
            this.btnItemGenData.ImagePaddingVertical = 12;
            this.btnItemGenData.ImagePosition = DevComponents.DotNetBar.eImagePosition.Top;
            this.btnItemGenData.Name = "btnItemGenData";
            this.btnItemGenData.PopupSide = DevComponents.DotNetBar.ePopupSide.Left;
            this.btnItemGenData.Text = "General Data";
            this.btnItemGenData.Click += new System.EventHandler(this.OnGeneralDataClick);
            // 
            // btnItemRegister
            // 
            this.btnItemRegister.ButtonStyle = DevComponents.DotNetBar.eButtonStyle.ImageAndText;
            this.btnItemRegister.ColorTable = DevComponents.DotNetBar.eButtonColor.Blue;
            this.btnItemRegister.FontBold = true;
            this.btnItemRegister.ForeColor = System.Drawing.Color.White;
            this.btnItemRegister.Icon = ((System.Drawing.Icon)(resources.GetObject("btnItemRegister.Icon")));
            this.btnItemRegister.ImagePaddingVertical = 12;
            this.btnItemRegister.ImagePosition = DevComponents.DotNetBar.eImagePosition.Top;
            this.btnItemRegister.Name = "btnItemRegister";
            this.btnItemRegister.Text = "Register";
            this.btnItemRegister.Click += new System.EventHandler(this.OnRegisterClick);
            // 
            // btnItemDrawArrange
            // 
            this.btnItemDrawArrange.ButtonStyle = DevComponents.DotNetBar.eButtonStyle.ImageAndText;
            this.btnItemDrawArrange.ColorTable = DevComponents.DotNetBar.eButtonColor.Blue;
            this.btnItemDrawArrange.FontBold = true;
            this.btnItemDrawArrange.ForeColor = System.Drawing.Color.White;
            this.btnItemDrawArrange.Icon = ((System.Drawing.Icon)(resources.GetObject("btnItemDrawArrange.Icon")));
            this.btnItemDrawArrange.ImagePaddingVertical = 12;
            this.btnItemDrawArrange.ImagePosition = DevComponents.DotNetBar.eImagePosition.Top;
            this.btnItemDrawArrange.Name = "btnItemDrawArrange";
            this.btnItemDrawArrange.Text = "Draw Arrange";
            this.btnItemDrawArrange.Click += new System.EventHandler(this.OnDrawArrangeClick);
            // 
            // btnItemSchedule
            // 
            this.btnItemSchedule.ButtonStyle = DevComponents.DotNetBar.eButtonStyle.ImageAndText;
            this.btnItemSchedule.ColorTable = DevComponents.DotNetBar.eButtonColor.Blue;
            this.btnItemSchedule.FontBold = true;
            this.btnItemSchedule.ForeColor = System.Drawing.Color.White;
            this.btnItemSchedule.Icon = ((System.Drawing.Icon)(resources.GetObject("btnItemSchedule.Icon")));
            this.btnItemSchedule.ImagePaddingVertical = 12;
            this.btnItemSchedule.ImagePosition = DevComponents.DotNetBar.eImagePosition.Top;
            this.btnItemSchedule.Name = "btnItemSchedule";
            this.btnItemSchedule.Text = "Schedule";
            this.btnItemSchedule.Click += new System.EventHandler(this.OnMatchScheduleClick);
            // 
            // btnItemMatchData
            // 
            this.btnItemMatchData.ButtonStyle = DevComponents.DotNetBar.eButtonStyle.ImageAndText;
            this.btnItemMatchData.ColorTable = DevComponents.DotNetBar.eButtonColor.Blue;
            this.btnItemMatchData.FontBold = true;
            this.btnItemMatchData.ForeColor = System.Drawing.Color.White;
            this.btnItemMatchData.Icon = ((System.Drawing.Icon)(resources.GetObject("btnItemMatchData.Icon")));
            this.btnItemMatchData.ImagePaddingVertical = 12;
            this.btnItemMatchData.ImagePosition = DevComponents.DotNetBar.eImagePosition.Top;
            this.btnItemMatchData.Name = "btnItemMatchData";
            this.btnItemMatchData.Text = "Match Data";
            this.btnItemMatchData.Click += new System.EventHandler(this.OnPluginManagerClick);
            // 
            // btnItemMedal
            // 
            this.btnItemMedal.ButtonStyle = DevComponents.DotNetBar.eButtonStyle.ImageAndText;
            this.btnItemMedal.ColorTable = DevComponents.DotNetBar.eButtonColor.Blue;
            this.btnItemMedal.FontBold = true;
            this.btnItemMedal.ForeColor = System.Drawing.Color.White;
            this.btnItemMedal.Icon = ((System.Drawing.Icon)(resources.GetObject("btnItemMedal.Icon")));
            this.btnItemMedal.ImagePaddingVertical = 12;
            this.btnItemMedal.ImagePosition = DevComponents.DotNetBar.eImagePosition.Top;
            this.btnItemMedal.Name = "btnItemMedal";
            this.btnItemMedal.Text = "Medal";
            this.btnItemMedal.Click += new System.EventHandler(this.OnRankMedalClick);
            // 
            // btnItemRecord
            // 
            this.btnItemRecord.ButtonStyle = DevComponents.DotNetBar.eButtonStyle.ImageAndText;
            this.btnItemRecord.ColorTable = DevComponents.DotNetBar.eButtonColor.Blue;
            this.btnItemRecord.FontBold = true;
            this.btnItemRecord.ForeColor = System.Drawing.Color.White;
            this.btnItemRecord.Icon = ((System.Drawing.Icon)(resources.GetObject("btnItemRecord.Icon")));
            this.btnItemRecord.ImagePosition = DevComponents.DotNetBar.eImagePosition.Top;
            this.btnItemRecord.Name = "btnItemRecord";
            this.btnItemRecord.Text = "Record";
            this.btnItemRecord.Click += new System.EventHandler(this.OnRecordClick);
            // 
            // btnItemReports
            // 
            this.btnItemReports.ButtonStyle = DevComponents.DotNetBar.eButtonStyle.ImageAndText;
            this.btnItemReports.ColorTable = DevComponents.DotNetBar.eButtonColor.Blue;
            this.btnItemReports.FontBold = true;
            this.btnItemReports.ForeColor = System.Drawing.Color.White;
            this.btnItemReports.Icon = ((System.Drawing.Icon)(resources.GetObject("btnItemReports.Icon")));
            this.btnItemReports.ImagePaddingVertical = 12;
            this.btnItemReports.ImagePosition = DevComponents.DotNetBar.eImagePosition.Top;
            this.btnItemReports.Name = "btnItemReports";
            this.btnItemReports.Text = "Reports";
            this.btnItemReports.Click += new System.EventHandler(this.OnReportsClick);
            // 
            // btnItemNetwork
            // 
            this.btnItemNetwork.ButtonStyle = DevComponents.DotNetBar.eButtonStyle.ImageAndText;
            this.btnItemNetwork.ColorTable = DevComponents.DotNetBar.eButtonColor.Blue;
            this.btnItemNetwork.FontBold = true;
            this.btnItemNetwork.ForeColor = System.Drawing.Color.White;
            this.btnItemNetwork.Icon = ((System.Drawing.Icon)(resources.GetObject("btnItemNetwork.Icon")));
            this.btnItemNetwork.ImagePosition = DevComponents.DotNetBar.eImagePosition.Top;
            this.btnItemNetwork.Name = "btnItemNetwork";
            this.btnItemNetwork.Text = "Network";
            this.btnItemNetwork.Click += new System.EventHandler(this.OnNetworkClick);
            // 
            // btnItemBackup
            // 
            this.btnItemBackup.ButtonStyle = DevComponents.DotNetBar.eButtonStyle.ImageAndText;
            this.btnItemBackup.ColorTable = DevComponents.DotNetBar.eButtonColor.Blue;
            this.btnItemBackup.FontBold = true;
            this.btnItemBackup.ForeColor = System.Drawing.Color.White;
            this.btnItemBackup.Icon = ((System.Drawing.Icon)(resources.GetObject("btnItemBackup.Icon")));
            this.btnItemBackup.ImagePaddingVertical = 12;
            this.btnItemBackup.ImagePosition = DevComponents.DotNetBar.eImagePosition.Top;
            this.btnItemBackup.Name = "btnItemBackup";
            this.btnItemBackup.Text = "Database Backup";
            this.btnItemBackup.Click += new System.EventHandler(this.OnDatabaseBackupClick);
            // 
            // btnItemCommunicate
            // 
            this.btnItemCommunicate.ButtonStyle = DevComponents.DotNetBar.eButtonStyle.ImageAndText;
            this.btnItemCommunicate.ColorTable = DevComponents.DotNetBar.eButtonColor.Blue;
            this.btnItemCommunicate.FontBold = true;
            this.btnItemCommunicate.ForeColor = System.Drawing.Color.White;
            this.btnItemCommunicate.Icon = ((System.Drawing.Icon)(resources.GetObject("btnItemCommunicate.Icon")));
            this.btnItemCommunicate.ImagePosition = DevComponents.DotNetBar.eImagePosition.Top;
            this.btnItemCommunicate.Name = "btnItemCommunicate";
            this.btnItemCommunicate.Text = "Communication";
            this.btnItemCommunicate.Click += new System.EventHandler(this.OnCommunicationClick);
            // 
            // spliterGameMgr
            // 
            this.spliterGameMgr.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(227)))), ((int)(((byte)(239)))), ((int)(((byte)(255)))));
            this.spliterGameMgr.BackColor2 = System.Drawing.Color.FromArgb(((int)(((byte)(101)))), ((int)(((byte)(147)))), ((int)(((byte)(207)))));
            this.spliterGameMgr.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBorder;
            this.spliterGameMgr.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.spliterGameMgr.ExpandableControl = this.sideBarGameMgr;
            this.spliterGameMgr.ExpandFillColor = System.Drawing.Color.FromArgb(((int)(((byte)(101)))), ((int)(((byte)(147)))), ((int)(((byte)(207)))));
            this.spliterGameMgr.ExpandFillColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBorder;
            this.spliterGameMgr.ExpandLineColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.spliterGameMgr.ExpandLineColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.None;
            this.spliterGameMgr.GripDarkColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.spliterGameMgr.GripDarkColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.None;
            this.spliterGameMgr.GripLightColor = System.Drawing.Color.FromArgb(((int)(((byte)(227)))), ((int)(((byte)(239)))), ((int)(((byte)(255)))));
            this.spliterGameMgr.GripLightColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.spliterGameMgr.HotBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(252)))), ((int)(((byte)(151)))), ((int)(((byte)(61)))));
            this.spliterGameMgr.HotBackColor2 = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(184)))), ((int)(((byte)(94)))));
            this.spliterGameMgr.HotBackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.ItemPressedBackground2;
            this.spliterGameMgr.HotBackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.ItemPressedBackground;
            this.spliterGameMgr.HotExpandFillColor = System.Drawing.Color.FromArgb(((int)(((byte)(101)))), ((int)(((byte)(147)))), ((int)(((byte)(207)))));
            this.spliterGameMgr.HotExpandFillColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBorder;
            this.spliterGameMgr.HotExpandLineColor = System.Drawing.Color.Black;
            this.spliterGameMgr.HotExpandLineColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.None;
            this.spliterGameMgr.HotGripDarkColor = System.Drawing.Color.FromArgb(((int)(((byte)(101)))), ((int)(((byte)(147)))), ((int)(((byte)(207)))));
            this.spliterGameMgr.HotGripDarkColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBorder;
            this.spliterGameMgr.HotGripLightColor = System.Drawing.Color.FromArgb(((int)(((byte)(227)))), ((int)(((byte)(239)))), ((int)(((byte)(255)))));
            this.spliterGameMgr.HotGripLightColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.BarBackground;
            this.spliterGameMgr.Location = new System.Drawing.Point(120, 0);
            this.spliterGameMgr.MinExtra = 120;
            this.spliterGameMgr.MinSize = 120;
            this.spliterGameMgr.Name = "spliterGameMgr";
            this.spliterGameMgr.Size = new System.Drawing.Size(10, 787);
            this.spliterGameMgr.Style = DevComponents.DotNetBar.eSplitterStyle.Office2007;
            this.spliterGameMgr.TabIndex = 2;
            this.spliterGameMgr.TabStop = false;
            // 
            // OVRMainFrameForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(230)))), ((int)(((byte)(230)))), ((int)(((byte)(230)))));
            this.ClientSize = new System.Drawing.Size(610, 787);
            this.Controls.Add(this.spliterGameMgr);
            this.Controls.Add(this.sideBarGameMgr);
            this.Controls.Add(this.panelModuleForm);
            this.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "OVRMainFrameForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "AutoSports OVR";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.OnMainFrameFormClosing);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.OnMainFrameFormClosed);
            this.Load += new System.EventHandler(this.OnMainFrameLoad);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panelModuleForm;
        private DevComponents.DotNetBar.SideBar sideBarGameMgr;
        private DevComponents.DotNetBar.SideBarPanelItem sbItemGameMgr;
        private DevComponents.DotNetBar.ButtonItem btnItemGenData;
        private DevComponents.DotNetBar.ExpandableSplitter spliterGameMgr;
        private DevComponents.DotNetBar.ButtonItem btnItemDrawArrange;
        private DevComponents.DotNetBar.ButtonItem btnItemSchedule;
        private DevComponents.DotNetBar.ButtonItem btnItemMatchData;
        private DevComponents.DotNetBar.ButtonItem btnItemReports;
        private DevComponents.DotNetBar.ButtonItem btnItemMedal;
        private DevComponents.DotNetBar.ButtonItem btnItemBackup;
        private DevComponents.DotNetBar.ButtonItem btnItemRegister;
        private DevComponents.DotNetBar.ButtonItem btnItemCommunicate;
        private DevComponents.DotNetBar.ButtonItem btnItemNetwork;
        private DevComponents.DotNetBar.ButtonItem btnItemRecord;
    }
}

