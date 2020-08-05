namespace AutoSports.OVRARPlugin
{
    partial class frmQualificationEnds
    {
        /// <summary> 
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region 组件设计器生成的代码

        /// <summary> 
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.MenuStrip_IRM = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.toolStripMenuItem_DNS = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem_DSQ = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem_DNF = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem_OK = new System.Windows.Forms.ToolStripMenuItem();
            this.dgv_PlayerA = new System.Windows.Forms.DataGridView();
            this.gp_PlayerA = new DevComponents.DotNetBar.Controls.GroupPanel();
            this.labX_Distince = new DevComponents.DotNetBar.LabelX();
            this.labX_AXs = new DevComponents.DotNetBar.LabelX();
            this.labX_A10s = new DevComponents.DotNetBar.LabelX();
            this.labelX2 = new DevComponents.DotNetBar.LabelX();
            this.labX_IRMA = new DevComponents.DotNetBar.LabelX();
            this.labX_TotalA = new DevComponents.DotNetBar.LabelX();
            this.labX_NOCA = new DevComponents.DotNetBar.LabelX();
            this.labX_BibA = new DevComponents.DotNetBar.LabelX();
            this.labX_All = new DevComponents.DotNetBar.LabelX();
            this.labX_WinB = new DevComponents.DotNetBar.LabelX();
            this.cbX_Auto = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.Menu_X = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.toolStripMenuItem_X = new System.Windows.Forms.ToolStripMenuItem();
            this.nullToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.btnX_Update = new DevComponents.DotNetBar.ButtonX();
            this.btnX_Return = new DevComponents.DotNetBar.ButtonX();
            this.toolStripMenuItem_M = new System.Windows.Forms.ToolStripMenuItem();
            this.MenuStrip_IRM.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_PlayerA)).BeginInit();
            this.gp_PlayerA.SuspendLayout();
            this.Menu_X.SuspendLayout();
            this.SuspendLayout();
            // 
            // MenuStrip_IRM
            // 
            this.MenuStrip_IRM.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem_DNS,
            this.toolStripMenuItem_DSQ,
            this.toolStripMenuItem_DNF,
            this.toolStripMenuItem_OK});
            this.MenuStrip_IRM.Name = "MenuStrip_Status";
            this.MenuStrip_IRM.Size = new System.Drawing.Size(103, 92);
            // 
            // toolStripMenuItem_DNS
            // 
            this.toolStripMenuItem_DNS.Name = "toolStripMenuItem_DNS";
            this.toolStripMenuItem_DNS.Size = new System.Drawing.Size(102, 22);
            this.toolStripMenuItem_DNS.Text = "DNS";
            this.toolStripMenuItem_DNS.Click += new System.EventHandler(this.toolStripMenuItem_DNS_Click);
            // 
            // toolStripMenuItem_DSQ
            // 
            this.toolStripMenuItem_DSQ.Name = "toolStripMenuItem_DSQ";
            this.toolStripMenuItem_DSQ.Size = new System.Drawing.Size(102, 22);
            this.toolStripMenuItem_DSQ.Text = "DSQ";
            this.toolStripMenuItem_DSQ.Click += new System.EventHandler(this.toolStripMenuItem_DSQ_Click);
            // 
            // toolStripMenuItem_DNF
            // 
            this.toolStripMenuItem_DNF.Name = "toolStripMenuItem_DNF";
            this.toolStripMenuItem_DNF.Size = new System.Drawing.Size(102, 22);
            this.toolStripMenuItem_DNF.Text = "DNF";
            this.toolStripMenuItem_DNF.Click += new System.EventHandler(this.toolStripMenuItem_DNF_Click);
            // 
            // toolStripMenuItem_OK
            // 
            this.toolStripMenuItem_OK.Name = "toolStripMenuItem_OK";
            this.toolStripMenuItem_OK.Size = new System.Drawing.Size(102, 22);
            this.toolStripMenuItem_OK.Text = "OK";
            this.toolStripMenuItem_OK.Click += new System.EventHandler(this.toolStripMenuItem_OK_Click);
            // 
            // dgv_PlayerA
            // 
            this.dgv_PlayerA.AllowUserToAddRows = false;
            this.dgv_PlayerA.AllowUserToDeleteRows = false;
            this.dgv_PlayerA.AllowUserToResizeRows = false;
            this.dgv_PlayerA.BackgroundColor = System.Drawing.SystemColors.Window;
            this.dgv_PlayerA.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_PlayerA.Location = new System.Drawing.Point(18, 61);
            this.dgv_PlayerA.Name = "dgv_PlayerA";
            this.dgv_PlayerA.RowHeadersVisible = false;
            this.dgv_PlayerA.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            this.dgv_PlayerA.RowTemplate.Height = 23;
            this.dgv_PlayerA.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.CellSelect;
            this.dgv_PlayerA.ShowEditingIcon = false;
            this.dgv_PlayerA.Size = new System.Drawing.Size(554, 214);
            this.dgv_PlayerA.TabIndex = 1;
            this.dgv_PlayerA.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_PlayerA_CellEndEdit);
            this.dgv_PlayerA.CellMouseDown += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgv_PlayerA_CellMouseDown);
            this.dgv_PlayerA.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgv_PlayerA_CellValidating);
            this.dgv_PlayerA.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_PlayerA_CellValueChanged);
            // 
            // gp_PlayerA
            // 
            this.gp_PlayerA.CanvasColor = System.Drawing.SystemColors.Control;
            this.gp_PlayerA.ColorSchemeStyle = DevComponents.DotNetBar.eDotNetBarStyle.Office2007;
            this.gp_PlayerA.Controls.Add(this.labX_Distince);
            this.gp_PlayerA.Controls.Add(this.labX_AXs);
            this.gp_PlayerA.Controls.Add(this.labX_A10s);
            this.gp_PlayerA.Controls.Add(this.labelX2);
            this.gp_PlayerA.Controls.Add(this.labX_IRMA);
            this.gp_PlayerA.Controls.Add(this.labX_TotalA);
            this.gp_PlayerA.Controls.Add(this.labX_NOCA);
            this.gp_PlayerA.Controls.Add(this.labX_BibA);
            this.gp_PlayerA.Controls.Add(this.dgv_PlayerA);
            this.gp_PlayerA.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.gp_PlayerA.Location = new System.Drawing.Point(12, 51);
            this.gp_PlayerA.Name = "gp_PlayerA";
            this.gp_PlayerA.Size = new System.Drawing.Size(620, 348);
            // 
            // 
            // 
            this.gp_PlayerA.Style.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.gp_PlayerA.Style.BackColorGradientAngle = 90;
            this.gp_PlayerA.Style.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.gp_PlayerA.Style.BorderBottom = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.gp_PlayerA.Style.BorderBottomWidth = 1;
            this.gp_PlayerA.Style.BorderColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBorder;
            this.gp_PlayerA.Style.BorderLeft = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.gp_PlayerA.Style.BorderLeftWidth = 1;
            this.gp_PlayerA.Style.BorderRight = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.gp_PlayerA.Style.BorderRightWidth = 1;
            this.gp_PlayerA.Style.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.gp_PlayerA.Style.BorderTopWidth = 1;
            this.gp_PlayerA.Style.Class = "";
            this.gp_PlayerA.Style.CornerDiameter = 4;
            this.gp_PlayerA.Style.CornerType = DevComponents.DotNetBar.eCornerType.Rounded;
            this.gp_PlayerA.Style.TextColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelText;
            this.gp_PlayerA.Style.TextLineAlignment = DevComponents.DotNetBar.eStyleTextAlignment.Near;
            // 
            // 
            // 
            this.gp_PlayerA.StyleMouseDown.Class = "";
            this.gp_PlayerA.StyleMouseDown.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            // 
            // 
            // 
            this.gp_PlayerA.StyleMouseOver.Class = "";
            this.gp_PlayerA.StyleMouseOver.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.gp_PlayerA.TabIndex = 4;
            this.gp_PlayerA.Text = "PlayerA";
            this.gp_PlayerA.TitleImagePosition = DevComponents.DotNetBar.eTitleImagePosition.Center;
            // 
            // labX_Distince
            // 
            this.labX_Distince.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labX_Distince.BackgroundStyle.Class = "";
            this.labX_Distince.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_Distince.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labX_Distince.Location = new System.Drawing.Point(372, 13);
            this.labX_Distince.Name = "labX_Distince";
            this.labX_Distince.Size = new System.Drawing.Size(46, 33);
            this.labX_Distince.TabIndex = 21;
            this.labX_Distince.Text = "90m";
            // 
            // labX_AXs
            // 
            this.labX_AXs.BackColor = System.Drawing.Color.White;
            // 
            // 
            // 
            this.labX_AXs.BackgroundStyle.BorderBottom = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_AXs.BackgroundStyle.BorderLeft = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_AXs.BackgroundStyle.BorderRight = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_AXs.BackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_AXs.BackgroundStyle.Class = "";
            this.labX_AXs.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_AXs.Location = new System.Drawing.Point(294, 291);
            this.labX_AXs.Name = "labX_AXs";
            this.labX_AXs.PaddingRight = 2;
            this.labX_AXs.Size = new System.Drawing.Size(56, 22);
            this.labX_AXs.TabIndex = 19;
            this.labX_AXs.TextAlignment = System.Drawing.StringAlignment.Far;
            this.labX_AXs.TextChanged += new System.EventHandler(this.labX_A_TextChanged);
            // 
            // labX_A10s
            // 
            this.labX_A10s.BackColor = System.Drawing.Color.White;
            // 
            // 
            // 
            this.labX_A10s.BackgroundStyle.BorderBottom = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_A10s.BackgroundStyle.BorderLeft = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_A10s.BackgroundStyle.BorderRight = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_A10s.BackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_A10s.BackgroundStyle.Class = "";
            this.labX_A10s.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_A10s.Location = new System.Drawing.Point(232, 291);
            this.labX_A10s.Name = "labX_A10s";
            this.labX_A10s.PaddingRight = 2;
            this.labX_A10s.Size = new System.Drawing.Size(56, 22);
            this.labX_A10s.TabIndex = 18;
            this.labX_A10s.TextAlignment = System.Drawing.StringAlignment.Far;
            this.labX_A10s.TextChanged += new System.EventHandler(this.labX_A_TextChanged);
            // 
            // labelX2
            // 
            this.labelX2.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labelX2.BackgroundStyle.Class = "";
            this.labelX2.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labelX2.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labelX2.Location = new System.Drawing.Point(18, 291);
            this.labelX2.Name = "labelX2";
            this.labelX2.Size = new System.Drawing.Size(209, 22);
            this.labelX2.TabIndex = 17;
            this.labelX2.Text = "Totals 10\'s and X\'s：";
            this.labelX2.TextAlignment = System.Drawing.StringAlignment.Far;
            // 
            // labX_IRMA
            // 
            this.labX_IRMA.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labX_IRMA.BackgroundStyle.Class = "";
            this.labX_IRMA.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_IRMA.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labX_IRMA.Location = new System.Drawing.Point(179, 17);
            this.labX_IRMA.Name = "labX_IRMA";
            this.labX_IRMA.PaddingRight = 3;
            this.labX_IRMA.Size = new System.Drawing.Size(132, 13);
            this.labX_IRMA.TabIndex = 16;
            this.labX_IRMA.TextAlignment = System.Drawing.StringAlignment.Far;
            // 
            // labX_TotalA
            // 
            this.labX_TotalA.BackColor = System.Drawing.Color.White;
            // 
            // 
            // 
            this.labX_TotalA.BackgroundStyle.Class = "";
            this.labX_TotalA.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_TotalA.ForeColor = System.Drawing.Color.Blue;
            this.labX_TotalA.Location = new System.Drawing.Point(457, 15);
            this.labX_TotalA.Name = "labX_TotalA";
            this.labX_TotalA.Size = new System.Drawing.Size(70, 33);
            this.labX_TotalA.TabIndex = 14;
            this.labX_TotalA.Text = "Total";
            this.labX_TotalA.TextAlignment = System.Drawing.StringAlignment.Center;
            this.labX_TotalA.TextChanged += new System.EventHandler(this.labX_A_TextChanged);
            this.labX_TotalA.MouseDown += new System.Windows.Forms.MouseEventHandler(this.labX_WinA_MouseDown);
            // 
            // labX_NOCA
            // 
            this.labX_NOCA.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labX_NOCA.BackgroundStyle.Class = "";
            this.labX_NOCA.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_NOCA.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labX_NOCA.Location = new System.Drawing.Point(107, 24);
            this.labX_NOCA.Name = "labX_NOCA";
            this.labX_NOCA.Size = new System.Drawing.Size(149, 22);
            this.labX_NOCA.TabIndex = 13;
            this.labX_NOCA.Text = "NOC ";
            // 
            // labX_BibA
            // 
            this.labX_BibA.BackColor = System.Drawing.Color.White;
            // 
            // 
            // 
            this.labX_BibA.BackgroundStyle.Class = "";
            this.labX_BibA.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_BibA.Location = new System.Drawing.Point(34, 13);
            this.labX_BibA.Name = "labX_BibA";
            this.labX_BibA.PaddingLeft = 5;
            this.labX_BibA.Size = new System.Drawing.Size(50, 33);
            this.labX_BibA.TabIndex = 12;
            this.labX_BibA.Text = "Bib";
            // 
            // labX_All
            // 
            this.labX_All.BackColor = System.Drawing.Color.White;
            // 
            // 
            // 
            this.labX_All.BackgroundStyle.Class = "";
            this.labX_All.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_All.ForeColor = System.Drawing.Color.Blue;
            this.labX_All.Location = new System.Drawing.Point(276, 12);
            this.labX_All.Name = "labX_All";
            this.labX_All.Size = new System.Drawing.Size(71, 33);
            this.labX_All.TabIndex = 22;
            this.labX_All.Text = "Total";
            this.labX_All.TextAlignment = System.Drawing.StringAlignment.Center;
            // 
            // labX_WinB
            // 
            this.labX_WinB.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labX_WinB.BackgroundStyle.Class = "";
            this.labX_WinB.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_WinB.Font = new System.Drawing.Font("Arial", 16F);
            this.labX_WinB.Location = new System.Drawing.Point(802, 99);
            this.labX_WinB.Name = "labX_WinB";
            this.labX_WinB.Size = new System.Drawing.Size(106, 36);
            this.labX_WinB.TabIndex = 3;
            this.labX_WinB.TextAlignment = System.Drawing.StringAlignment.Center;
            // 
            // cbX_Auto
            // 
            // 
            // 
            // 
            this.cbX_Auto.BackgroundStyle.Class = "";
            this.cbX_Auto.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.cbX_Auto.Checked = true;
            this.cbX_Auto.CheckState = System.Windows.Forms.CheckState.Checked;
            this.cbX_Auto.CheckValue = "Y";
            this.cbX_Auto.Location = new System.Drawing.Point(465, 20);
            this.cbX_Auto.Name = "cbX_Auto";
            this.cbX_Auto.Size = new System.Drawing.Size(172, 25);
            this.cbX_Auto.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.cbX_Auto.TabIndex = 15;
            this.cbX_Auto.Text = "Auto Update Score";
            this.cbX_Auto.CheckedChanged += new System.EventHandler(this.cbX_Auto_CheckedChanged);
            // 
            // Menu_X
            // 
            this.Menu_X.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem_M,
            this.toolStripMenuItem_X,
            this.nullToolStripMenuItem});
            this.Menu_X.Name = "MenuStrip_Status";
            this.Menu_X.Size = new System.Drawing.Size(100, 70);
            // 
            // toolStripMenuItem_M
            // 
            this.toolStripMenuItem_M.Name = "toolStripMenuItem_M";
            this.toolStripMenuItem_M.Size = new System.Drawing.Size(99, 22);
            this.toolStripMenuItem_M.Text = "M";
            this.toolStripMenuItem_M.Click += new System.EventHandler(this.toolStripMenuItem_M_Click);
            // 
            // toolStripMenuItem_X
            // 
            this.toolStripMenuItem_X.Name = "toolStripMenuItem_X";
            this.toolStripMenuItem_X.Size = new System.Drawing.Size(99, 22);
            this.toolStripMenuItem_X.Text = "X";
            this.toolStripMenuItem_X.Click += new System.EventHandler(this.toolStripMenuItem_X_Click);
            // 
            // nullToolStripMenuItem
            // 
            this.nullToolStripMenuItem.Name = "nullToolStripMenuItem";
            this.nullToolStripMenuItem.Size = new System.Drawing.Size(99, 22);
            this.nullToolStripMenuItem.Text = "Null";
            this.nullToolStripMenuItem.Click += new System.EventHandler(this.nullToolStripMenuItem_Click);
            // 
            // btnX_Update
            // 
            this.btnX_Update.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Update.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_Update.Location = new System.Drawing.Point(175, 405);
            this.btnX_Update.Name = "btnX_Update";
            this.btnX_Update.Size = new System.Drawing.Size(130, 35);
            this.btnX_Update.TabIndex = 23;
            this.btnX_Update.Text = "Save and Return";
            this.btnX_Update.Click += new System.EventHandler(this.btnX_Update_Click);
            // 
            // btnX_Return
            // 
            this.btnX_Return.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Return.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_Return.Location = new System.Drawing.Point(395, 405);
            this.btnX_Return.Name = "btnX_Return";
            this.btnX_Return.Size = new System.Drawing.Size(130, 35);
            this.btnX_Return.TabIndex = 24;
            this.btnX_Return.Text = "Cancel and Return";
            this.btnX_Return.Click += new System.EventHandler(this.btnX_Return_Click);
            // 
            // frmQualificationEnds
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(644, 528);
            this.Controls.Add(this.btnX_Return);
            this.Controls.Add(this.btnX_Update);
            this.Controls.Add(this.labX_All);
            this.Controls.Add(this.labX_WinB);
            this.Controls.Add(this.gp_PlayerA);
            this.Controls.Add(this.cbX_Auto);
            this.DoubleBuffered = true;
            this.MinimumSize = new System.Drawing.Size(660, 515);
            this.Name = "frmQualificationEnds";
            this.Text = "Ends Edit";
            this.Load += new System.EventHandler(this.frmQualificationEnds_Load);
            this.MenuStrip_IRM.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_PlayerA)).EndInit();
            this.gp_PlayerA.ResumeLayout(false);
            this.Menu_X.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ContextMenuStrip MenuStrip_IRM;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_DNS;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_DSQ;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_DNF;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_OK;
        private System.Windows.Forms.DataGridView dgv_PlayerA;
        private DevComponents.DotNetBar.Controls.GroupPanel gp_PlayerA;
        private DevComponents.DotNetBar.LabelX labX_BibA;
        private DevComponents.DotNetBar.LabelX labX_TotalA;
        private DevComponents.DotNetBar.LabelX labX_NOCA;
        private DevComponents.DotNetBar.LabelX labX_WinB;
        private DevComponents.DotNetBar.Controls.CheckBoxX cbX_Auto;
        private DevComponents.DotNetBar.LabelX labX_IRMA;
        private System.Windows.Forms.ContextMenuStrip Menu_X;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_X;
        private System.Windows.Forms.ToolStripMenuItem nullToolStripMenuItem;
        private DevComponents.DotNetBar.LabelX labelX2;
        private DevComponents.DotNetBar.LabelX labX_A10s;
        private DevComponents.DotNetBar.LabelX labX_AXs;
        private DevComponents.DotNetBar.LabelX labX_Distince;
        private DevComponents.DotNetBar.LabelX labX_All;
        private DevComponents.DotNetBar.ButtonX btnX_Update;
        private DevComponents.DotNetBar.ButtonX btnX_Return;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_M;
    }
}
