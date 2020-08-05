namespace AutoSports.OVRWPPlugin
{
    partial class frmOVRWPSetStatistic
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
            this.btnHome = new DevComponents.DotNetBar.ButtonX();
            this.btnVisit = new DevComponents.DotNetBar.ButtonX();
            this.dgvPlayerStat = new System.Windows.Forms.DataGridView();
            this.lbTeam = new System.Windows.Forms.Label();
            this.dgvTeamStat = new System.Windows.Forms.DataGridView();
            this.lbPlayerStatistic = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPlayerStat)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvTeamStat)).BeginInit();
            this.SuspendLayout();
            // 
            // btnHome
            // 
            this.btnHome.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnHome.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnHome.Location = new System.Drawing.Point(264, 12);
            this.btnHome.Name = "btnHome";
            this.btnHome.Size = new System.Drawing.Size(147, 31);
            this.btnHome.TabIndex = 9;
            this.btnHome.Text = "Home";
            this.btnHome.Click += new System.EventHandler(this.btnHome_Click);
            // 
            // btnVisit
            // 
            this.btnVisit.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnVisit.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnVisit.Location = new System.Drawing.Point(480, 12);
            this.btnVisit.Name = "btnVisit";
            this.btnVisit.Size = new System.Drawing.Size(147, 31);
            this.btnVisit.TabIndex = 9;
            this.btnVisit.Text = "Visit";
            this.btnVisit.Click += new System.EventHandler(this.btnVisit_Click);
            // 
            // dgvPlayerStat
            // 
            this.dgvPlayerStat.AllowUserToAddRows = false;
            this.dgvPlayerStat.AllowUserToDeleteRows = false;
            this.dgvPlayerStat.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvPlayerStat.Location = new System.Drawing.Point(12, 66);
            this.dgvPlayerStat.MultiSelect = false;
            this.dgvPlayerStat.Name = "dgvPlayerStat";
            this.dgvPlayerStat.RowTemplate.Height = 23;
            this.dgvPlayerStat.Size = new System.Drawing.Size(893, 303);
            this.dgvPlayerStat.TabIndex = 10;
            // 
            // lbTeam
            // 
            this.lbTeam.Location = new System.Drawing.Point(22, 372);
            this.lbTeam.Name = "lbTeam";
            this.lbTeam.Size = new System.Drawing.Size(122, 15);
            this.lbTeam.TabIndex = 11;
            this.lbTeam.Text = "Team Statistic";
            // 
            // dgvTeamStat
            // 
            this.dgvTeamStat.AllowUserToAddRows = false;
            this.dgvTeamStat.AllowUserToDeleteRows = false;
            this.dgvTeamStat.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvTeamStat.Location = new System.Drawing.Point(12, 390);
            this.dgvTeamStat.MultiSelect = false;
            this.dgvTeamStat.Name = "dgvTeamStat";
            this.dgvTeamStat.RowTemplate.Height = 23;
            this.dgvTeamStat.Size = new System.Drawing.Size(893, 116);
            this.dgvTeamStat.TabIndex = 12;
            // 
            // lbPlayerStatistic
            // 
            this.lbPlayerStatistic.Location = new System.Drawing.Point(22, 45);
            this.lbPlayerStatistic.Name = "lbPlayerStatistic";
            this.lbPlayerStatistic.Size = new System.Drawing.Size(122, 15);
            this.lbPlayerStatistic.TabIndex = 11;
            this.lbPlayerStatistic.Text = "Player Statistic";
            // 
            // frmOVRWPSetStatistic
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(917, 518);
            this.Controls.Add(this.dgvTeamStat);
            this.Controls.Add(this.lbPlayerStatistic);
            this.Controls.Add(this.lbTeam);
            this.Controls.Add(this.dgvPlayerStat);
            this.Controls.Add(this.btnVisit);
            this.Controls.Add(this.btnHome);
            this.DoubleBuffered = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmOVRWPSetStatistic";
            this.Text = "SetStatistic";
            this.Load += new System.EventHandler(this.frmOVRWPSetStatistic_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvPlayerStat)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvTeamStat)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnHome;
        private DevComponents.DotNetBar.ButtonX btnVisit;
        private System.Windows.Forms.DataGridView dgvPlayerStat;
        private System.Windows.Forms.Label lbTeam;
        private System.Windows.Forms.DataGridView dgvTeamStat;
        private System.Windows.Forms.Label lbPlayerStatistic;
    }
}