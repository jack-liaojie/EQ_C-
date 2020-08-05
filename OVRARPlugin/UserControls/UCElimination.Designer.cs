using AutoSports.OVRCommon;
namespace AutoSports.OVRARPlugin
{
    partial class UCElimination
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
            this.labX_MatchInfo = new DevComponents.DotNetBar.LabelX();
            this.gp_PlayerA = new DevComponents.DotNetBar.Controls.GroupPanel();
            this.txtX_BibA = new DevComponents.DotNetBar.Controls.TextBoxX();
            this.labX_AXs = new DevComponents.DotNetBar.LabelX();
            this.labX_A10s = new DevComponents.DotNetBar.LabelX();
            this.labelX2 = new DevComponents.DotNetBar.LabelX();
            this.labX_IRMA = new DevComponents.DotNetBar.LabelX();
            this.labX_TotalA = new DevComponents.DotNetBar.LabelX();
            this.labX_NOCA = new DevComponents.DotNetBar.LabelX();
            this.labX_BibA = new DevComponents.DotNetBar.LabelX();
            this.labX_WinA = new DevComponents.DotNetBar.LabelX();
            this.gp_PlayerB = new DevComponents.DotNetBar.Controls.GroupPanel();
            this.txtX_BibB = new DevComponents.DotNetBar.Controls.TextBoxX();
            this.labX_BXs = new DevComponents.DotNetBar.LabelX();
            this.labX_B10s = new DevComponents.DotNetBar.LabelX();
            this.labelX5 = new DevComponents.DotNetBar.LabelX();
            this.labX_IRMB = new DevComponents.DotNetBar.LabelX();
            this.labX_TotalB = new DevComponents.DotNetBar.LabelX();
            this.labX_NOCB = new DevComponents.DotNetBar.LabelX();
            this.labX_BibB = new DevComponents.DotNetBar.LabelX();
            this.dgv_PlayerB = new System.Windows.Forms.DataGridView();
            this.labX_WinB = new DevComponents.DotNetBar.LabelX();
            this.cb_Winner = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.labelX1 = new DevComponents.DotNetBar.LabelX();
            this.cbX_Auto = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.cbX_AutoPoint = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.cb_AutoSetWinner = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.Menu_X = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.toolStripMenuItem_M = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem_X = new System.Windows.Forms.ToolStripMenuItem();
            this.nullToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.labX_ATeam = new DevComponents.DotNetBar.LabelX();
            this.labX_BTeam = new DevComponents.DotNetBar.LabelX();
            this.dgv_ShootA = new System.Windows.Forms.DataGridView();
            this.dgv_ShootB = new System.Windows.Forms.DataGridView();
            this.Menu_Closest = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.nullToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.labX_RecordA = new DevComponents.DotNetBar.LabelX();
            this.labX_RecordB = new DevComponents.DotNetBar.LabelX();
            this.MenuStrip_IRM.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_PlayerA)).BeginInit();
            this.gp_PlayerA.SuspendLayout();
            this.gp_PlayerB.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_PlayerB)).BeginInit();
            this.Menu_X.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_ShootA)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_ShootB)).BeginInit();
            this.Menu_Closest.SuspendLayout();
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
            this.dgv_PlayerA.Location = new System.Drawing.Point(3, 61);
            this.dgv_PlayerA.Name = "dgv_PlayerA";
            this.dgv_PlayerA.RowHeadersVisible = false;
            this.dgv_PlayerA.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            this.dgv_PlayerA.RowTemplate.Height = 23;
            this.dgv_PlayerA.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.CellSelect;
            this.dgv_PlayerA.ShowEditingIcon = false;
            this.dgv_PlayerA.Size = new System.Drawing.Size(400, 171);
            this.dgv_PlayerA.TabIndex = 1;
            this.dgv_PlayerA.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_PlayerA_CellEndEdit);
            this.dgv_PlayerA.CellMouseDown += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgv_PlayerA_CellMouseDown);
            this.dgv_PlayerA.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgv_PlayerA_CellValidating);
            this.dgv_PlayerA.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_PlayerA_CellValueChanged);
            // 
            // labX_MatchInfo
            // 
            // 
            // 
            // 
            this.labX_MatchInfo.BackgroundStyle.Class = "";
            this.labX_MatchInfo.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_MatchInfo.Font = new System.Drawing.Font("Arial", 16F);
            this.labX_MatchInfo.Location = new System.Drawing.Point(436, 253);
            this.labX_MatchInfo.Name = "labX_MatchInfo";
            this.labX_MatchInfo.Size = new System.Drawing.Size(60, 60);
            this.labX_MatchInfo.TabIndex = 3;
            this.labX_MatchInfo.Text = "VS";
            this.labX_MatchInfo.TextAlignment = System.Drawing.StringAlignment.Center;
            // 
            // gp_PlayerA
            // 
            this.gp_PlayerA.CanvasColor = System.Drawing.SystemColors.Control;
            this.gp_PlayerA.ColorSchemeStyle = DevComponents.DotNetBar.eDotNetBarStyle.Office2007;
            this.gp_PlayerA.Controls.Add(this.labX_RecordA);
            this.gp_PlayerA.Controls.Add(this.txtX_BibA);
            this.gp_PlayerA.Controls.Add(this.labX_AXs);
            this.gp_PlayerA.Controls.Add(this.labX_A10s);
            this.gp_PlayerA.Controls.Add(this.labelX2);
            this.gp_PlayerA.Controls.Add(this.labX_IRMA);
            this.gp_PlayerA.Controls.Add(this.labX_TotalA);
            this.gp_PlayerA.Controls.Add(this.labX_NOCA);
            this.gp_PlayerA.Controls.Add(this.labX_BibA);
            this.gp_PlayerA.Controls.Add(this.dgv_PlayerA);
            this.gp_PlayerA.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.gp_PlayerA.Location = new System.Drawing.Point(20, 111);
            this.gp_PlayerA.Name = "gp_PlayerA";
            this.gp_PlayerA.Size = new System.Drawing.Size(410, 289);
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
            // txtX_BibA
            // 
            // 
            // 
            // 
            this.txtX_BibA.Border.Class = "";
            this.txtX_BibA.Border.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.txtX_BibA.Font = new System.Drawing.Font("宋体", 15F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.txtX_BibA.Location = new System.Drawing.Point(18, 14);
            this.txtX_BibA.Name = "txtX_BibA";
            this.txtX_BibA.Size = new System.Drawing.Size(50, 23);
            this.txtX_BibA.TabIndex = 20;
            this.txtX_BibA.Visible = false;
            this.txtX_BibA.Leave += new System.EventHandler(this.txtX_BibA_Leave);
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
            this.labX_AXs.Location = new System.Drawing.Point(282, 239);
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
            this.labX_A10s.Location = new System.Drawing.Point(220, 238);
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
            this.labelX2.Location = new System.Drawing.Point(5, 238);
            this.labelX2.Name = "labelX2";
            this.labelX2.Size = new System.Drawing.Size(209, 22);
            this.labelX2.TabIndex = 17;
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
            this.labX_TotalA.Location = new System.Drawing.Point(317, 13);
            this.labX_TotalA.Name = "labX_TotalA";
            this.labX_TotalA.Size = new System.Drawing.Size(50, 33);
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
            this.labX_NOCA.Location = new System.Drawing.Point(80, 24);
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
            this.labX_BibA.Location = new System.Drawing.Point(18, 13);
            this.labX_BibA.Name = "labX_BibA";
            this.labX_BibA.PaddingLeft = 5;
            this.labX_BibA.Size = new System.Drawing.Size(50, 33);
            this.labX_BibA.TabIndex = 12;
            this.labX_BibA.Text = "Bib";
            this.labX_BibA.Click += new System.EventHandler(this.labX_BibA_Click);
            // 
            // labX_WinA
            // 
            this.labX_WinA.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labX_WinA.BackgroundStyle.Class = "";
            this.labX_WinA.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_WinA.Font = new System.Drawing.Font("Arial", 16F);
            this.labX_WinA.Location = new System.Drawing.Point(317, 73);
            this.labX_WinA.Name = "labX_WinA";
            this.labX_WinA.Size = new System.Drawing.Size(109, 32);
            this.labX_WinA.TabIndex = 3;
            this.labX_WinA.TextAlignment = System.Drawing.StringAlignment.Center;
            // 
            // gp_PlayerB
            // 
            this.gp_PlayerB.CanvasColor = System.Drawing.SystemColors.Control;
            this.gp_PlayerB.ColorSchemeStyle = DevComponents.DotNetBar.eDotNetBarStyle.Office2007;
            this.gp_PlayerB.Controls.Add(this.labX_RecordB);
            this.gp_PlayerB.Controls.Add(this.txtX_BibB);
            this.gp_PlayerB.Controls.Add(this.labX_BXs);
            this.gp_PlayerB.Controls.Add(this.labX_B10s);
            this.gp_PlayerB.Controls.Add(this.labelX5);
            this.gp_PlayerB.Controls.Add(this.labX_IRMB);
            this.gp_PlayerB.Controls.Add(this.labX_TotalB);
            this.gp_PlayerB.Controls.Add(this.labX_NOCB);
            this.gp_PlayerB.Controls.Add(this.labX_BibB);
            this.gp_PlayerB.Controls.Add(this.dgv_PlayerB);
            this.gp_PlayerB.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.gp_PlayerB.Location = new System.Drawing.Point(502, 111);
            this.gp_PlayerB.Name = "gp_PlayerB";
            this.gp_PlayerB.Size = new System.Drawing.Size(410, 289);
            // 
            // 
            // 
            this.gp_PlayerB.Style.BackColor2SchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground2;
            this.gp_PlayerB.Style.BackColorGradientAngle = 90;
            this.gp_PlayerB.Style.BackColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBackground;
            this.gp_PlayerB.Style.BorderBottom = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.gp_PlayerB.Style.BorderBottomWidth = 1;
            this.gp_PlayerB.Style.BorderColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBorder;
            this.gp_PlayerB.Style.BorderLeft = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.gp_PlayerB.Style.BorderLeftWidth = 1;
            this.gp_PlayerB.Style.BorderRight = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.gp_PlayerB.Style.BorderRightWidth = 1;
            this.gp_PlayerB.Style.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.gp_PlayerB.Style.BorderTopWidth = 1;
            this.gp_PlayerB.Style.Class = "";
            this.gp_PlayerB.Style.CornerDiameter = 4;
            this.gp_PlayerB.Style.CornerType = DevComponents.DotNetBar.eCornerType.Rounded;
            this.gp_PlayerB.Style.TextColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelText;
            this.gp_PlayerB.Style.TextLineAlignment = DevComponents.DotNetBar.eStyleTextAlignment.Near;
            // 
            // 
            // 
            this.gp_PlayerB.StyleMouseDown.Class = "";
            this.gp_PlayerB.StyleMouseDown.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            // 
            // 
            // 
            this.gp_PlayerB.StyleMouseOver.Class = "";
            this.gp_PlayerB.StyleMouseOver.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.gp_PlayerB.TabIndex = 5;
            this.gp_PlayerB.Text = "PlayerB";
            this.gp_PlayerB.TitleImagePosition = DevComponents.DotNetBar.eTitleImagePosition.Center;
            // 
            // txtX_BibB
            // 
            // 
            // 
            // 
            this.txtX_BibB.Border.Class = "";
            this.txtX_BibB.Border.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.txtX_BibB.Font = new System.Drawing.Font("宋体", 15F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.txtX_BibB.Location = new System.Drawing.Point(18, 13);
            this.txtX_BibB.Name = "txtX_BibB";
            this.txtX_BibB.Size = new System.Drawing.Size(50, 23);
            this.txtX_BibB.TabIndex = 23;
            this.txtX_BibB.Visible = false;
            this.txtX_BibB.Leave += new System.EventHandler(this.txtX_BibB_Leave);
            // 
            // labX_BXs
            // 
            this.labX_BXs.BackColor = System.Drawing.Color.White;
            // 
            // 
            // 
            this.labX_BXs.BackgroundStyle.BorderBottom = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_BXs.BackgroundStyle.BorderLeft = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_BXs.BackgroundStyle.BorderRight = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_BXs.BackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_BXs.BackgroundStyle.Class = "";
            this.labX_BXs.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_BXs.Location = new System.Drawing.Point(280, 240);
            this.labX_BXs.Name = "labX_BXs";
            this.labX_BXs.PaddingRight = 2;
            this.labX_BXs.Size = new System.Drawing.Size(56, 22);
            this.labX_BXs.TabIndex = 22;
            this.labX_BXs.TextAlignment = System.Drawing.StringAlignment.Far;
            this.labX_BXs.TextChanged += new System.EventHandler(this.labX_B_TextChanged);
            // 
            // labX_B10s
            // 
            this.labX_B10s.BackColor = System.Drawing.Color.White;
            // 
            // 
            // 
            this.labX_B10s.BackgroundStyle.BorderBottom = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_B10s.BackgroundStyle.BorderLeft = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_B10s.BackgroundStyle.BorderRight = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_B10s.BackgroundStyle.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.labX_B10s.BackgroundStyle.Class = "";
            this.labX_B10s.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_B10s.Location = new System.Drawing.Point(218, 239);
            this.labX_B10s.Name = "labX_B10s";
            this.labX_B10s.PaddingRight = 2;
            this.labX_B10s.Size = new System.Drawing.Size(56, 22);
            this.labX_B10s.TabIndex = 21;
            this.labX_B10s.TextAlignment = System.Drawing.StringAlignment.Far;
            this.labX_B10s.TextChanged += new System.EventHandler(this.labX_B_TextChanged);
            // 
            // labelX5
            // 
            this.labelX5.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labelX5.BackgroundStyle.Class = "";
            this.labelX5.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labelX5.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labelX5.Location = new System.Drawing.Point(3, 239);
            this.labelX5.Name = "labelX5";
            this.labelX5.Size = new System.Drawing.Size(209, 22);
            this.labelX5.TabIndex = 20;
            this.labelX5.TextAlignment = System.Drawing.StringAlignment.Far;
            // 
            // labX_IRMB
            // 
            this.labX_IRMB.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labX_IRMB.BackgroundStyle.Class = "";
            this.labX_IRMB.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_IRMB.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labX_IRMB.Location = new System.Drawing.Point(186, 17);
            this.labX_IRMB.Name = "labX_IRMB";
            this.labX_IRMB.PaddingRight = 3;
            this.labX_IRMB.Size = new System.Drawing.Size(132, 13);
            this.labX_IRMB.TabIndex = 19;
            this.labX_IRMB.TextAlignment = System.Drawing.StringAlignment.Far;
            // 
            // labX_TotalB
            // 
            this.labX_TotalB.BackColor = System.Drawing.Color.White;
            // 
            // 
            // 
            this.labX_TotalB.BackgroundStyle.Class = "";
            this.labX_TotalB.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_TotalB.ForeColor = System.Drawing.Color.Blue;
            this.labX_TotalB.Location = new System.Drawing.Point(324, 13);
            this.labX_TotalB.Name = "labX_TotalB";
            this.labX_TotalB.Size = new System.Drawing.Size(50, 33);
            this.labX_TotalB.TabIndex = 17;
            this.labX_TotalB.Text = "Total";
            this.labX_TotalB.TextAlignment = System.Drawing.StringAlignment.Center;
            this.labX_TotalB.TextChanged += new System.EventHandler(this.labX_B_TextChanged);
            this.labX_TotalB.MouseDown += new System.Windows.Forms.MouseEventHandler(this.labX_WinB_MouseDown);
            // 
            // labX_NOCB
            // 
            this.labX_NOCB.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labX_NOCB.BackgroundStyle.Class = "";
            this.labX_NOCB.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_NOCB.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labX_NOCB.Location = new System.Drawing.Point(80, 24);
            this.labX_NOCB.Name = "labX_NOCB";
            this.labX_NOCB.Size = new System.Drawing.Size(160, 22);
            this.labX_NOCB.TabIndex = 16;
            this.labX_NOCB.Text = "NOC ";
            // 
            // labX_BibB
            // 
            this.labX_BibB.BackColor = System.Drawing.Color.White;
            // 
            // 
            // 
            this.labX_BibB.BackgroundStyle.Class = "";
            this.labX_BibB.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_BibB.Location = new System.Drawing.Point(18, 13);
            this.labX_BibB.Name = "labX_BibB";
            this.labX_BibB.PaddingLeft = 5;
            this.labX_BibB.Size = new System.Drawing.Size(50, 33);
            this.labX_BibB.TabIndex = 15;
            this.labX_BibB.Text = "Bib";
            this.labX_BibB.Click += new System.EventHandler(this.labX_BibB_Click);
            // 
            // dgv_PlayerB
            // 
            this.dgv_PlayerB.AllowUserToAddRows = false;
            this.dgv_PlayerB.AllowUserToDeleteRows = false;
            this.dgv_PlayerB.AllowUserToResizeRows = false;
            this.dgv_PlayerB.BackgroundColor = System.Drawing.SystemColors.Window;
            this.dgv_PlayerB.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_PlayerB.Location = new System.Drawing.Point(3, 61);
            this.dgv_PlayerB.Name = "dgv_PlayerB";
            this.dgv_PlayerB.RowHeadersVisible = false;
            this.dgv_PlayerB.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            this.dgv_PlayerB.RowTemplate.Height = 23;
            this.dgv_PlayerB.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.CellSelect;
            this.dgv_PlayerB.ShowEditingIcon = false;
            this.dgv_PlayerB.Size = new System.Drawing.Size(400, 171);
            this.dgv_PlayerB.TabIndex = 1;
            this.dgv_PlayerB.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_PlayerB_CellEndEdit);
            this.dgv_PlayerB.CellMouseDown += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgv_PlayerB_CellMouseDown);
            this.dgv_PlayerB.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgv_PlayerB_CellValidating);
            this.dgv_PlayerB.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_PlayerB_CellValueChanged);
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
            this.labX_WinB.Location = new System.Drawing.Point(802, 69);
            this.labX_WinB.Name = "labX_WinB";
            this.labX_WinB.Size = new System.Drawing.Size(106, 36);
            this.labX_WinB.TabIndex = 3;
            this.labX_WinB.TextAlignment = System.Drawing.StringAlignment.Center;
            // 
            // cb_Winner
            // 
            this.cb_Winner.DisplayMember = "Text";
            this.cb_Winner.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cb_Winner.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.cb_Winner.FormattingEnabled = true;
            this.cb_Winner.ItemHeight = 20;
            this.cb_Winner.Location = new System.Drawing.Point(122, 31);
            this.cb_Winner.Name = "cb_Winner";
            this.cb_Winner.Size = new System.Drawing.Size(311, 26);
            this.cb_Winner.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.cb_Winner.TabIndex = 6;
            this.cb_Winner.SelectedIndexChanged += new System.EventHandler(this.cb_Winner_SelectedIndexChanged);
            // 
            // labelX1
            // 
            this.labelX1.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labelX1.BackgroundStyle.Class = "";
            this.labelX1.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labelX1.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labelX1.Location = new System.Drawing.Point(29, 31);
            this.labelX1.Name = "labelX1";
            this.labelX1.Size = new System.Drawing.Size(87, 26);
            this.labelX1.TabIndex = 14;
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
            this.cbX_Auto.Location = new System.Drawing.Point(502, 32);
            this.cbX_Auto.Name = "cbX_Auto";
            this.cbX_Auto.Size = new System.Drawing.Size(172, 25);
            this.cbX_Auto.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.cbX_Auto.TabIndex = 15;
            this.cbX_Auto.CheckedChanged += new System.EventHandler(this.cbX_Auto_CheckedChanged);
            // 
            // cbX_AutoPoint
            // 
            // 
            // 
            // 
            this.cbX_AutoPoint.BackgroundStyle.Class = "";
            this.cbX_AutoPoint.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.cbX_AutoPoint.Checked = true;
            this.cbX_AutoPoint.CheckState = System.Windows.Forms.CheckState.Checked;
            this.cbX_AutoPoint.CheckValue = "Y";
            this.cbX_AutoPoint.Location = new System.Drawing.Point(502, 78);
            this.cbX_AutoPoint.Name = "cbX_AutoPoint";
            this.cbX_AutoPoint.Size = new System.Drawing.Size(172, 25);
            this.cbX_AutoPoint.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.cbX_AutoPoint.TabIndex = 16;
            this.cbX_AutoPoint.CheckedChanged += new System.EventHandler(this.cbX_AutoPoint_CheckedChanged);
            // 
            // cb_AutoSetWinner
            // 
            // 
            // 
            // 
            this.cb_AutoSetWinner.BackgroundStyle.Class = "";
            this.cb_AutoSetWinner.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.cb_AutoSetWinner.Location = new System.Drawing.Point(122, 78);
            this.cb_AutoSetWinner.Name = "cb_AutoSetWinner";
            this.cb_AutoSetWinner.Size = new System.Drawing.Size(139, 25);
            this.cb_AutoSetWinner.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.cb_AutoSetWinner.TabIndex = 17;
            this.cb_AutoSetWinner.CheckedChanged += new System.EventHandler(this.cb_AutoSetWinner_CheckedChanged);
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
            // labX_ATeam
            // 
            this.labX_ATeam.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labX_ATeam.BackgroundStyle.Class = "";
            this.labX_ATeam.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_ATeam.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labX_ATeam.Location = new System.Drawing.Point(26, 406);
            this.labX_ATeam.Name = "labX_ATeam";
            this.labX_ATeam.Size = new System.Drawing.Size(400, 77);
            this.labX_ATeam.TabIndex = 18;
            // 
            // labX_BTeam
            // 
            this.labX_BTeam.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labX_BTeam.BackgroundStyle.Class = "";
            this.labX_BTeam.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_BTeam.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labX_BTeam.Location = new System.Drawing.Point(508, 406);
            this.labX_BTeam.Name = "labX_BTeam";
            this.labX_BTeam.Size = new System.Drawing.Size(400, 77);
            this.labX_BTeam.TabIndex = 21;
            // 
            // dgv_ShootA
            // 
            this.dgv_ShootA.AllowUserToAddRows = false;
            this.dgv_ShootA.AllowUserToDeleteRows = false;
            this.dgv_ShootA.AllowUserToResizeRows = false;
            this.dgv_ShootA.BackgroundColor = System.Drawing.SystemColors.Window;
            this.dgv_ShootA.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_ShootA.Location = new System.Drawing.Point(26, 489);
            this.dgv_ShootA.Name = "dgv_ShootA";
            this.dgv_ShootA.RowHeadersVisible = false;
            this.dgv_ShootA.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            this.dgv_ShootA.RowTemplate.Height = 23;
            this.dgv_ShootA.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.CellSelect;
            this.dgv_ShootA.ShowEditingIcon = false;
            this.dgv_ShootA.Size = new System.Drawing.Size(400, 93);
            this.dgv_ShootA.TabIndex = 22;
            this.dgv_ShootA.Visible = false;
            this.dgv_ShootA.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_ShootA_CellEndEdit);
            this.dgv_ShootA.CellMouseDown += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgv_ShootA_CellMouseDown);
            this.dgv_ShootA.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgv_ShootA_CellValidating);
            // 
            // dgv_ShootB
            // 
            this.dgv_ShootB.AllowUserToAddRows = false;
            this.dgv_ShootB.AllowUserToDeleteRows = false;
            this.dgv_ShootB.AllowUserToResizeRows = false;
            this.dgv_ShootB.BackgroundColor = System.Drawing.SystemColors.Window;
            this.dgv_ShootB.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_ShootB.Location = new System.Drawing.Point(508, 489);
            this.dgv_ShootB.Name = "dgv_ShootB";
            this.dgv_ShootB.RowHeadersVisible = false;
            this.dgv_ShootB.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            this.dgv_ShootB.RowTemplate.Height = 23;
            this.dgv_ShootB.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.CellSelect;
            this.dgv_ShootB.ShowEditingIcon = false;
            this.dgv_ShootB.Size = new System.Drawing.Size(400, 93);
            this.dgv_ShootB.TabIndex = 23;
            this.dgv_ShootB.Visible = false;
            this.dgv_ShootB.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_ShootB_CellEndEdit);
            this.dgv_ShootB.CellMouseDown += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgv_ShootB_CellMouseDown);
            this.dgv_ShootB.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgv_ShootB_CellValidating);
            // 
            // Menu_Closest
            // 
            this.Menu_Closest.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem1,
            this.nullToolStripMenuItem1});
            this.Menu_Closest.Name = "MenuStrip_Status";
            this.Menu_Closest.Size = new System.Drawing.Size(100, 48);
            // 
            // toolStripMenuItem1
            // 
            this.toolStripMenuItem1.Name = "toolStripMenuItem1";
            this.toolStripMenuItem1.Size = new System.Drawing.Size(99, 22);
            this.toolStripMenuItem1.Text = "*";
            this.toolStripMenuItem1.Click += new System.EventHandler(this.toolStripMenuItem1_Click);
            // 
            // nullToolStripMenuItem1
            // 
            this.nullToolStripMenuItem1.Name = "nullToolStripMenuItem1";
            this.nullToolStripMenuItem1.Size = new System.Drawing.Size(99, 22);
            this.nullToolStripMenuItem1.Text = "Null";
            this.nullToolStripMenuItem1.Click += new System.EventHandler(this.nullToolStripMenuItem1_Click);
            // 
            // labX_RecordA
            // 
            this.labX_RecordA.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labX_RecordA.BackgroundStyle.Class = "";
            this.labX_RecordA.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_RecordA.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labX_RecordA.Location = new System.Drawing.Point(368, 14);
            this.labX_RecordA.Name = "labX_RecordA";
            this.labX_RecordA.Size = new System.Drawing.Size(33, 32);
            this.labX_RecordA.TabIndex = 21;
            this.labX_RecordA.TextAlignment = System.Drawing.StringAlignment.Far;
            // 
            // labX_RecordB
            // 
            this.labX_RecordB.BackColor = System.Drawing.Color.Transparent;
            // 
            // 
            // 
            this.labX_RecordB.BackgroundStyle.Class = "";
            this.labX_RecordB.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labX_RecordB.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.labX_RecordB.Location = new System.Drawing.Point(374, 14);
            this.labX_RecordB.Name = "labX_RecordB";
            this.labX_RecordB.Size = new System.Drawing.Size(33, 32);
            this.labX_RecordB.TabIndex = 24;
            this.labX_RecordB.TextAlignment = System.Drawing.StringAlignment.Far;
            // 
            // UCElimination
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoScroll = true;
            this.AutoSize = true;
            this.Controls.Add(this.dgv_ShootB);
            this.Controls.Add(this.dgv_ShootA);
            this.Controls.Add(this.cbX_AutoPoint);
            this.Controls.Add(this.cbX_Auto);
            this.Controls.Add(this.labX_BTeam);
            this.Controls.Add(this.cb_AutoSetWinner);
            this.Controls.Add(this.labX_MatchInfo);
            this.Controls.Add(this.labX_ATeam);
            this.Controls.Add(this.labelX1);
            this.Controls.Add(this.cb_Winner);
            this.Controls.Add(this.gp_PlayerB);
            this.Controls.Add(this.gp_PlayerA);
            this.Controls.Add(this.labX_WinA);
            this.Controls.Add(this.labX_WinB);
            this.DoubleBuffered = true;
            this.Name = "UCElimination";
            this.Size = new System.Drawing.Size(950, 600);
            this.Load += new System.EventHandler(this.UCElimination_Load);
            this.MenuStrip_IRM.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_PlayerA)).EndInit();
            this.gp_PlayerA.ResumeLayout(false);
            this.gp_PlayerB.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_PlayerB)).EndInit();
            this.Menu_X.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_ShootA)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_ShootB)).EndInit();
            this.Menu_Closest.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ContextMenuStrip MenuStrip_IRM;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_DNS;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_DSQ;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_DNF;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_OK;
        private System.Windows.Forms.DataGridView dgv_PlayerA;
        private DevComponents.DotNetBar.LabelX labX_MatchInfo;
        private DevComponents.DotNetBar.Controls.GroupPanel gp_PlayerA;
        private DevComponents.DotNetBar.Controls.GroupPanel gp_PlayerB;
        private System.Windows.Forms.DataGridView dgv_PlayerB;
        private DevComponents.DotNetBar.LabelX labX_BibA;
        private DevComponents.DotNetBar.LabelX labX_TotalA;
        private DevComponents.DotNetBar.LabelX labX_NOCA;
        private DevComponents.DotNetBar.LabelX labX_NOCB;
        private DevComponents.DotNetBar.LabelX labX_TotalB;
        private DevComponents.DotNetBar.LabelX labX_BibB;
        private DevComponents.DotNetBar.LabelX labX_WinA;
        private DevComponents.DotNetBar.LabelX labX_WinB;
        private DevComponents.DotNetBar.LabelX labelX1;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cb_Winner;
        private DevComponents.DotNetBar.Controls.CheckBoxX cbX_Auto;
        private DevComponents.DotNetBar.Controls.CheckBoxX cbX_AutoPoint;
        private DevComponents.DotNetBar.LabelX labX_IRMA;
        private DevComponents.DotNetBar.LabelX labX_IRMB;
        private DevComponents.DotNetBar.Controls.CheckBoxX cb_AutoSetWinner;
        private System.Windows.Forms.ContextMenuStrip Menu_X;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_X;
        private System.Windows.Forms.ToolStripMenuItem nullToolStripMenuItem;
        private DevComponents.DotNetBar.LabelX labelX2;
        private DevComponents.DotNetBar.LabelX labX_A10s;
        private DevComponents.DotNetBar.LabelX labX_AXs;
        private DevComponents.DotNetBar.LabelX labX_BXs;
        private DevComponents.DotNetBar.LabelX labX_B10s;
        private DevComponents.DotNetBar.LabelX labelX5;
        private DevComponents.DotNetBar.LabelX labX_ATeam;
        private DevComponents.DotNetBar.LabelX labX_BTeam;
        private DevComponents.DotNetBar.Controls.TextBoxX txtX_BibA;
        private DevComponents.DotNetBar.Controls.TextBoxX txtX_BibB;
        private System.Windows.Forms.DataGridView dgv_ShootA;
        private System.Windows.Forms.DataGridView dgv_ShootB;
        private System.Windows.Forms.ContextMenuStrip Menu_Closest;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem nullToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_M;
        private DevComponents.DotNetBar.LabelX labX_RecordA;
        private DevComponents.DotNetBar.LabelX labX_RecordB;
    }
}
