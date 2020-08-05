namespace AutoSports.OVRBDPlugin
{
    partial class frmSetTeamPlayer
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
            this.dgvTeamPlayers = new System.Windows.Forms.DataGridView();
            this.dgvPosition = new System.Windows.Forms.DataGridView();
            this.btnAutoSetPlayer = new DevComponents.DotNetBar.ButtonX();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.btnFillTeamOG = new DevComponents.DotNetBar.ButtonX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvTeamPlayers)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPosition)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvTeamPlayers
            // 
            this.dgvTeamPlayers.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.dgvTeamPlayers.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.DisplayedCells;
            this.dgvTeamPlayers.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvTeamPlayers.Location = new System.Drawing.Point(4, 1);
            this.dgvTeamPlayers.MultiSelect = false;
            this.dgvTeamPlayers.Name = "dgvTeamPlayers";
            this.dgvTeamPlayers.RowTemplate.Height = 23;
            this.dgvTeamPlayers.Size = new System.Drawing.Size(598, 189);
            this.dgvTeamPlayers.TabIndex = 0;
            this.dgvTeamPlayers.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvTeamPlayers_CellBeginEdit);
            this.dgvTeamPlayers.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvTeamPlayers_CellValueChanged);
            // 
            // dgvPosition
            // 
            this.dgvPosition.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.DisplayedCells;
            this.dgvPosition.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvPosition.Location = new System.Drawing.Point(4, 196);
            this.dgvPosition.MultiSelect = false;
            this.dgvPosition.Name = "dgvPosition";
            this.dgvPosition.RowTemplate.Height = 23;
            this.dgvPosition.Size = new System.Drawing.Size(420, 183);
            this.dgvPosition.TabIndex = 0;
            this.dgvPosition.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvPositionCell_beginEdit);
            this.dgvPosition.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvPosition_CellValueChanged);
            // 
            // btnAutoSetPlayer
            // 
            this.btnAutoSetPlayer.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAutoSetPlayer.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnAutoSetPlayer.Location = new System.Drawing.Point(433, 232);
            this.btnAutoSetPlayer.Name = "btnAutoSetPlayer";
            this.btnAutoSetPlayer.Size = new System.Drawing.Size(159, 55);
            this.btnAutoSetPlayer.TabIndex = 2;
            this.btnAutoSetPlayer.Text = "Auto Fill Players(For national game only)";
            this.btnAutoSetPlayer.Visible = false;
            this.btnAutoSetPlayer.Click += new System.EventHandler(this.btnAutoSetPlayer_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(456, 208);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(119, 12);
            this.label1.TabIndex = 3;
            this.label1.Text = "A-X,B-Y,C-Z,A-Y,B-X";
            this.label1.Visible = false;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(440, 299);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(155, 12);
            this.label2.TabIndex = 3;
            this.label2.Text = "A-1,B-2,C-5 | X-1,Y-2,Z-4";
            // 
            // btnFillTeamOG
            // 
            this.btnFillTeamOG.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnFillTeamOG.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnFillTeamOG.Location = new System.Drawing.Point(433, 322);
            this.btnFillTeamOG.Name = "btnFillTeamOG";
            this.btnFillTeamOG.Size = new System.Drawing.Size(162, 55);
            this.btnFillTeamOG.TabIndex = 2;
            this.btnFillTeamOG.Text = "Auto Fill Players(Olympic Games)";
            this.btnFillTeamOG.Click += new System.EventHandler(this.btnAutoSetPlayerOG_Click);
            // 
            // frmSetTeamPlayer
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(604, 391);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btnFillTeamOG);
            this.Controls.Add(this.btnAutoSetPlayer);
            this.Controls.Add(this.dgvPosition);
            this.Controls.Add(this.dgvTeamPlayers);
            this.DoubleBuffered = true;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmSetTeamPlayer";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmSetTeamPlayer";
            this.Load += new System.EventHandler(this.frmSetTeamPlayer_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvTeamPlayers)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPosition)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvTeamPlayers;
        private System.Windows.Forms.DataGridView dgvPosition;
        private DevComponents.DotNetBar.ButtonX btnAutoSetPlayer;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private DevComponents.DotNetBar.ButtonX btnFillTeamOG;
    }
}