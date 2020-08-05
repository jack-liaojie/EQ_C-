namespace AutoSports.OVRARPlugin
{
    partial class UCQualification
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            this.MenuStrip_IRM = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.toolStripMenuItem_DNS = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem_DSQ = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem_DNF = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem_OK = new System.Windows.Forms.ToolStripMenuItem();
            this.dgv_List = new System.Windows.Forms.DataGridView();
            this.MenuStrip_Ends = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.toolStripMenuItem_Show = new System.Windows.Forms.ToolStripMenuItem();
            this.MenuStrip_ShootOff = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem2 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem3 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem4 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem6 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem7 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem8 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem9 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem10 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem11 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem12 = new System.Windows.Forms.ToolStripMenuItem();
            this.掷币胜ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.MenuStrip_IRM.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_List)).BeginInit();
            this.MenuStrip_Ends.SuspendLayout();
            this.MenuStrip_ShootOff.SuspendLayout();
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
            // dgv_List
            // 
            this.dgv_List.AllowUserToAddRows = false;
            this.dgv_List.AllowUserToDeleteRows = false;
            this.dgv_List.AllowUserToResizeRows = false;
            this.dgv_List.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.dgv_List.BackgroundColor = System.Drawing.SystemColors.ControlLightLight;
            this.dgv_List.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Sunken;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.CadetBlue;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgv_List.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgv_List.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_List.GridColor = System.Drawing.SystemColors.ActiveCaption;
            this.dgv_List.Location = new System.Drawing.Point(0, 0);
            this.dgv_List.Margin = new System.Windows.Forms.Padding(10, 0, 10, 10);
            this.dgv_List.MultiSelect = false;
            this.dgv_List.Name = "dgv_List";
            this.dgv_List.RowHeadersVisible = false;
            this.dgv_List.RowTemplate.Height = 23;
            this.dgv_List.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgv_List.Size = new System.Drawing.Size(950, 590);
            this.dgv_List.TabIndex = 1;
            this.dgv_List.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_List_CellEndEdit);
            this.dgv_List.CellMouseDown += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgv_List_CellMouseDown);
            this.dgv_List.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgv_List_CellValidating);
            this.dgv_List.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_List_CellValueChanged);
            // 
            // MenuStrip_Ends
            // 
            this.MenuStrip_Ends.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem_Show});
            this.MenuStrip_Ends.Name = "MenuStrip_Status";
            this.MenuStrip_Ends.Size = new System.Drawing.Size(105, 26);
            // 
            // toolStripMenuItem_Show
            // 
            this.toolStripMenuItem_Show.Name = "toolStripMenuItem_Show";
            this.toolStripMenuItem_Show.Size = new System.Drawing.Size(104, 22);
            this.toolStripMenuItem_Show.Text = "Ends";
            this.toolStripMenuItem_Show.Click += new System.EventHandler(this.toolStripMenuItem_Show_Click);
            // 
            // MenuStrip_ShootOff
            // 
            this.MenuStrip_ShootOff.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem1,
            this.掷币胜ToolStripMenuItem,
            this.toolStripMenuItem12,
            this.toolStripMenuItem11,
            this.toolStripMenuItem10,
            this.toolStripMenuItem9,
            this.toolStripMenuItem8,
            this.toolStripMenuItem7,
            this.toolStripMenuItem6,
            this.toolStripMenuItem4,
            this.toolStripMenuItem3,
            this.toolStripMenuItem2});
            this.MenuStrip_ShootOff.Name = "MenuStrip_Status";
            this.MenuStrip_ShootOff.Size = new System.Drawing.Size(153, 290);
            // 
            // toolStripMenuItem1
            // 
            this.toolStripMenuItem1.Name = "toolStripMenuItem1";
            this.toolStripMenuItem1.Size = new System.Drawing.Size(152, 22);
            this.toolStripMenuItem1.Tag = "0";
            this.toolStripMenuItem1.Text = "0";
            this.toolStripMenuItem1.Click += new System.EventHandler(this.toolStripMenuItem_ShootOff);
            // 
            // toolStripMenuItem2
            // 
            this.toolStripMenuItem2.Name = "toolStripMenuItem2";
            this.toolStripMenuItem2.Size = new System.Drawing.Size(152, 22);
            this.toolStripMenuItem2.Tag = "10";
            this.toolStripMenuItem2.Text = "10";
            this.toolStripMenuItem2.Click += new System.EventHandler(this.toolStripMenuItem_ShootOff);
            // 
            // toolStripMenuItem3
            // 
            this.toolStripMenuItem3.Name = "toolStripMenuItem3";
            this.toolStripMenuItem3.Size = new System.Drawing.Size(152, 22);
            this.toolStripMenuItem3.Tag = "9";
            this.toolStripMenuItem3.Text = "9";
            this.toolStripMenuItem3.Click += new System.EventHandler(this.toolStripMenuItem_ShootOff);
            // 
            // toolStripMenuItem4
            // 
            this.toolStripMenuItem4.Name = "toolStripMenuItem4";
            this.toolStripMenuItem4.Size = new System.Drawing.Size(152, 22);
            this.toolStripMenuItem4.Tag = "8";
            this.toolStripMenuItem4.Text = "8";
            this.toolStripMenuItem4.Click += new System.EventHandler(this.toolStripMenuItem_ShootOff);
            // 
            // toolStripMenuItem6
            // 
            this.toolStripMenuItem6.Name = "toolStripMenuItem6";
            this.toolStripMenuItem6.Size = new System.Drawing.Size(152, 22);
            this.toolStripMenuItem6.Tag = "7";
            this.toolStripMenuItem6.Text = "7";
            this.toolStripMenuItem6.Click += new System.EventHandler(this.toolStripMenuItem_ShootOff);
            // 
            // toolStripMenuItem7
            // 
            this.toolStripMenuItem7.Name = "toolStripMenuItem7";
            this.toolStripMenuItem7.Size = new System.Drawing.Size(152, 22);
            this.toolStripMenuItem7.Tag = "6";
            this.toolStripMenuItem7.Text = "6";
            this.toolStripMenuItem7.Click += new System.EventHandler(this.toolStripMenuItem_ShootOff);
            // 
            // toolStripMenuItem8
            // 
            this.toolStripMenuItem8.Name = "toolStripMenuItem8";
            this.toolStripMenuItem8.Size = new System.Drawing.Size(152, 22);
            this.toolStripMenuItem8.Tag = "5";
            this.toolStripMenuItem8.Text = "5";
            this.toolStripMenuItem8.Click += new System.EventHandler(this.toolStripMenuItem_ShootOff);
            // 
            // toolStripMenuItem9
            // 
            this.toolStripMenuItem9.Name = "toolStripMenuItem9";
            this.toolStripMenuItem9.Size = new System.Drawing.Size(152, 22);
            this.toolStripMenuItem9.Tag = "4";
            this.toolStripMenuItem9.Text = "4";
            this.toolStripMenuItem9.Click += new System.EventHandler(this.toolStripMenuItem_ShootOff);
            // 
            // toolStripMenuItem10
            // 
            this.toolStripMenuItem10.Name = "toolStripMenuItem10";
            this.toolStripMenuItem10.Size = new System.Drawing.Size(152, 22);
            this.toolStripMenuItem10.Tag = "3";
            this.toolStripMenuItem10.Text = "3";
            this.toolStripMenuItem10.Click += new System.EventHandler(this.toolStripMenuItem_ShootOff);
            // 
            // toolStripMenuItem11
            // 
            this.toolStripMenuItem11.Name = "toolStripMenuItem11";
            this.toolStripMenuItem11.Size = new System.Drawing.Size(152, 22);
            this.toolStripMenuItem11.Tag = "2";
            this.toolStripMenuItem11.Text = "2";
            this.toolStripMenuItem11.Click += new System.EventHandler(this.toolStripMenuItem_ShootOff);
            // 
            // toolStripMenuItem12
            // 
            this.toolStripMenuItem12.Name = "toolStripMenuItem12";
            this.toolStripMenuItem12.Size = new System.Drawing.Size(152, 22);
            this.toolStripMenuItem12.Tag = "1";
            this.toolStripMenuItem12.Text = "1";
            this.toolStripMenuItem12.Click += new System.EventHandler(this.toolStripMenuItem_ShootOff);
            // 
            // 掷币胜ToolStripMenuItem
            // 
            this.掷币胜ToolStripMenuItem.Name = "掷币胜ToolStripMenuItem";
            this.掷币胜ToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.掷币胜ToolStripMenuItem.Tag = "99";
            this.掷币胜ToolStripMenuItem.Text = "掷币胜";
            this.掷币胜ToolStripMenuItem.Click += new System.EventHandler(this.toolStripMenuItem_ShootOff);
            // 
            // UCQualification
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoScroll = true;
            this.AutoSize = true;
            this.Controls.Add(this.dgv_List);
            this.DoubleBuffered = true;
            this.Margin = new System.Windows.Forms.Padding(0);
            this.Name = "UCQualification";
            this.Size = new System.Drawing.Size(1000, 620);
            this.Load += new System.EventHandler(this.UCQualification_Load);
            this.MenuStrip_IRM.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_List)).EndInit();
            this.MenuStrip_Ends.ResumeLayout(false);
            this.MenuStrip_ShootOff.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ContextMenuStrip MenuStrip_IRM;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_DNS;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_DSQ;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_DNF;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_OK;
        private System.Windows.Forms.DataGridView dgv_List;
        private System.Windows.Forms.ContextMenuStrip MenuStrip_Ends;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_Show;
        private System.Windows.Forms.ContextMenuStrip MenuStrip_ShootOff;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem2;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem3;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem4;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem6;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem7;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem8;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem9;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem10;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem11;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem12;
        private System.Windows.Forms.ToolStripMenuItem 掷币胜ToolStripMenuItem;
    }
}
