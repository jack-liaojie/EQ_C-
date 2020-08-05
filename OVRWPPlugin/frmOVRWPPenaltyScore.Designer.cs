namespace AutoSports.OVRWPPlugin
{
    partial class frmOVRWPPenaltyScore
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
            this.lbHomeName = new System.Windows.Forms.Label();
            this.lbHGK = new System.Windows.Forms.Label();
            this.lbScore = new System.Windows.Forms.Label();
            this.lbHGKName = new System.Windows.Forms.Label();
            this.lbVisitName = new System.Windows.Forms.Label();
            this.lbVGK = new System.Windows.Forms.Label();
            this.lbVGKName = new System.Windows.Forms.Label();
            this.dgvHomePenalty = new System.Windows.Forms.DataGridView();
            this.btnSetPlayer = new DevComponents.DotNetBar.ButtonX();
            this.dgvVisitPenalty = new System.Windows.Forms.DataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.dgvHomePenalty)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvVisitPenalty)).BeginInit();
            this.SuspendLayout();
            // 
            // lbHomeName
            // 
            this.lbHomeName.Location = new System.Drawing.Point(51, 65);
            this.lbHomeName.Name = "lbHomeName";
            this.lbHomeName.Size = new System.Drawing.Size(112, 23);
            this.lbHomeName.TabIndex = 10;
            this.lbHomeName.Text = "HomeDes";
            this.lbHomeName.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbHGK
            // 
            this.lbHGK.Location = new System.Drawing.Point(10, 102);
            this.lbHGK.Name = "lbHGK";
            this.lbHGK.Size = new System.Drawing.Size(77, 23);
            this.lbHGK.TabIndex = 10;
            this.lbHGK.Text = "GoalKeeper";
            this.lbHGK.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbScore
            // 
            this.lbScore.Font = new System.Drawing.Font("SimSun", 10F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lbScore.ForeColor = System.Drawing.Color.Red;
            this.lbScore.Location = new System.Drawing.Point(251, 65);
            this.lbScore.Name = "lbScore";
            this.lbScore.Size = new System.Drawing.Size(112, 23);
            this.lbScore.TabIndex = 10;
            this.lbScore.Text = "Score";
            this.lbScore.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lbHGKName
            // 
            this.lbHGKName.Location = new System.Drawing.Point(93, 102);
            this.lbHGKName.Name = "lbHGKName";
            this.lbHGKName.Size = new System.Drawing.Size(112, 23);
            this.lbHGKName.TabIndex = 10;
            this.lbHGKName.Text = "HGKName";
            this.lbHGKName.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lbVisitName
            // 
            this.lbVisitName.Location = new System.Drawing.Point(434, 65);
            this.lbVisitName.Name = "lbVisitName";
            this.lbVisitName.Size = new System.Drawing.Size(112, 23);
            this.lbVisitName.TabIndex = 10;
            this.lbVisitName.Text = "VisitDes";
            this.lbVisitName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbVGK
            // 
            this.lbVGK.Location = new System.Drawing.Point(394, 102);
            this.lbVGK.Name = "lbVGK";
            this.lbVGK.Size = new System.Drawing.Size(77, 23);
            this.lbVGK.TabIndex = 10;
            this.lbVGK.Text = "GoalKeeper";
            this.lbVGK.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbVGKName
            // 
            this.lbVGKName.Location = new System.Drawing.Point(477, 102);
            this.lbVGKName.Name = "lbVGKName";
            this.lbVGKName.Size = new System.Drawing.Size(112, 23);
            this.lbVGKName.TabIndex = 10;
            this.lbVGKName.Text = "VGKName";
            this.lbVGKName.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // dgvHomePenalty
            // 
            this.dgvHomePenalty.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvHomePenalty.Location = new System.Drawing.Point(12, 138);
            this.dgvHomePenalty.Name = "dgvHomePenalty";
            this.dgvHomePenalty.RowTemplate.Height = 23;
            this.dgvHomePenalty.Size = new System.Drawing.Size(263, 189);
            this.dgvHomePenalty.TabIndex = 11;
            this.dgvHomePenalty.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvHomePenalty_CellBeginEdit);
            this.dgvHomePenalty.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvHomePenalty_CellValueChanged);
            // 
            // btnSetPlayer
            // 
            this.btnSetPlayer.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnSetPlayer.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnSetPlayer.Location = new System.Drawing.Point(12, 12);
            this.btnSetPlayer.Name = "btnSetPlayer";
            this.btnSetPlayer.Size = new System.Drawing.Size(79, 31);
            this.btnSetPlayer.TabIndex = 12;
            this.btnSetPlayer.Text = "ChosePlayer";
            this.btnSetPlayer.Click += new System.EventHandler(this.btnChosePlayer_Click);
            // 
            // dgvVisitPenalty
            // 
            this.dgvVisitPenalty.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvVisitPenalty.Location = new System.Drawing.Point(377, 138);
            this.dgvVisitPenalty.Name = "dgvVisitPenalty";
            this.dgvVisitPenalty.RowTemplate.Height = 23;
            this.dgvVisitPenalty.Size = new System.Drawing.Size(263, 189);
            this.dgvVisitPenalty.TabIndex = 11;
            this.dgvVisitPenalty.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvVisitPenalty_CellBeginEdit);
            this.dgvVisitPenalty.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvVisitPenalty_CellValueChanged);
            // 
            // frmOVRWPPenaltyScore
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(652, 349);
            this.Controls.Add(this.btnSetPlayer);
            this.Controls.Add(this.dgvVisitPenalty);
            this.Controls.Add(this.dgvHomePenalty);
            this.Controls.Add(this.lbVGKName);
            this.Controls.Add(this.lbVGK);
            this.Controls.Add(this.lbHGKName);
            this.Controls.Add(this.lbHGK);
            this.Controls.Add(this.lbScore);
            this.Controls.Add(this.lbVisitName);
            this.Controls.Add(this.lbHomeName);
            this.DoubleBuffered = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmOVRWPPenaltyScore";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "PenaltyScore";
            this.Load += new System.EventHandler(this.frmOVRWPPenaltyScore_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvHomePenalty)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvVisitPenalty)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label lbHomeName;
        private System.Windows.Forms.Label lbHGK;
        private System.Windows.Forms.Label lbScore;
        private System.Windows.Forms.Label lbHGKName;
        private System.Windows.Forms.Label lbVisitName;
        private System.Windows.Forms.Label lbVGK;
        private System.Windows.Forms.Label lbVGKName;
        private System.Windows.Forms.DataGridView dgvHomePenalty;
        private DevComponents.DotNetBar.ButtonX btnSetPlayer;
        private System.Windows.Forms.DataGridView dgvVisitPenalty;
    }
}