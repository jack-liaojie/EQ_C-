namespace AutoSports.OVRSEPlugin
{
    partial class scoreFrame
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            this.dgViewScore = new DevComponents.DotNetBar.Controls.DataGridViewX();
            this.btnAddMatchID = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.tbInputMatchID = new System.Windows.Forms.TextBox();
            this.lsbMatchID = new System.Windows.Forms.ListBox();
            this.btnRemoveMatchID = new System.Windows.Forms.Button();
            this.lbMatchID = new System.Windows.Forms.Label();
            this.btnRereshScore = new System.Windows.Forms.Button();
            this.lbMatchCourt = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.lbMatchRSC = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.lbMatchTime = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.lbMatchScore = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.lb878s = new System.Windows.Forms.Label();
            this.lbPlayerBasdf = new System.Windows.Forms.Label();
            this.lbPlayerA = new System.Windows.Forms.Label();
            this.lbPlayerB = new System.Windows.Forms.Label();
            this.btnGetCurrentMatch = new System.Windows.Forms.Button();
            this.chkAutoRefresh = new System.Windows.Forms.CheckBox();
            ((System.ComponentModel.ISupportInitialize)(this.dgViewScore)).BeginInit();
            this.SuspendLayout();
            // 
            // dgViewScore
            // 
            this.dgViewScore.AllowUserToAddRows = false;
            this.dgViewScore.AllowUserToDeleteRows = false;
            this.dgViewScore.AllowUserToResizeColumns = false;
            this.dgViewScore.AllowUserToResizeRows = false;
            this.dgViewScore.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle1.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("Microsoft YaHei", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.Color.Black;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgViewScore.DefaultCellStyle = dataGridViewCellStyle1;
            this.dgViewScore.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(208)))), ((int)(((byte)(215)))), ((int)(((byte)(229)))));
            this.dgViewScore.Location = new System.Drawing.Point(70, 64);
            this.dgViewScore.MultiSelect = false;
            this.dgViewScore.Name = "dgViewScore";
            this.dgViewScore.ReadOnly = true;
            this.dgViewScore.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            this.dgViewScore.RowTemplate.Height = 23;
            this.dgViewScore.Size = new System.Drawing.Size(669, 160);
            this.dgViewScore.TabIndex = 4;
            // 
            // btnAddMatchID
            // 
            this.btnAddMatchID.Location = new System.Drawing.Point(69, 7);
            this.btnAddMatchID.Name = "btnAddMatchID";
            this.btnAddMatchID.Size = new System.Drawing.Size(54, 30);
            this.btnAddMatchID.TabIndex = 5;
            this.btnAddMatchID.Text = "Add";
            this.btnAddMatchID.UseVisualStyleBackColor = true;
            this.btnAddMatchID.Click += new System.EventHandler(this.btnAddMatch_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft YaHei", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label1.Location = new System.Drawing.Point(555, 4);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(64, 17);
            this.label1.TabIndex = 6;
            this.label1.Text = "Match ID:";
            // 
            // tbInputMatchID
            // 
            this.tbInputMatchID.Font = new System.Drawing.Font("SimSun", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.tbInputMatchID.Location = new System.Drawing.Point(6, 9);
            this.tbInputMatchID.MaxLength = 8;
            this.tbInputMatchID.Name = "tbInputMatchID";
            this.tbInputMatchID.Size = new System.Drawing.Size(58, 26);
            this.tbInputMatchID.TabIndex = 7;
            // 
            // lsbMatchID
            // 
            this.lsbMatchID.Font = new System.Drawing.Font("Microsoft YaHei", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lsbMatchID.FormattingEnabled = true;
            this.lsbMatchID.ItemHeight = 20;
            this.lsbMatchID.Location = new System.Drawing.Point(5, 40);
            this.lsbMatchID.Name = "lsbMatchID";
            this.lsbMatchID.Size = new System.Drawing.Size(59, 184);
            this.lsbMatchID.TabIndex = 8;
            this.lsbMatchID.MouseClick += new System.Windows.Forms.MouseEventHandler(this.mouseClickViewScore);
            // 
            // btnRemoveMatchID
            // 
            this.btnRemoveMatchID.Location = new System.Drawing.Point(133, 7);
            this.btnRemoveMatchID.Name = "btnRemoveMatchID";
            this.btnRemoveMatchID.Size = new System.Drawing.Size(54, 30);
            this.btnRemoveMatchID.TabIndex = 9;
            this.btnRemoveMatchID.Text = "Remove";
            this.btnRemoveMatchID.UseVisualStyleBackColor = true;
            this.btnRemoveMatchID.Click += new System.EventHandler(this.btnRemoveMatchID_Click);
            // 
            // lbMatchID
            // 
            this.lbMatchID.AutoSize = true;
            this.lbMatchID.Font = new System.Drawing.Font("Microsoft YaHei", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lbMatchID.ForeColor = System.Drawing.Color.Blue;
            this.lbMatchID.Location = new System.Drawing.Point(628, 4);
            this.lbMatchID.Name = "lbMatchID";
            this.lbMatchID.Size = new System.Drawing.Size(40, 17);
            this.lbMatchID.TabIndex = 10;
            this.lbMatchID.Text = "XXXX";
            // 
            // btnRereshScore
            // 
            this.btnRereshScore.Location = new System.Drawing.Point(680, 7);
            this.btnRereshScore.Name = "btnRereshScore";
            this.btnRereshScore.Size = new System.Drawing.Size(59, 34);
            this.btnRereshScore.TabIndex = 11;
            this.btnRereshScore.Text = "Refresh";
            this.btnRereshScore.UseVisualStyleBackColor = true;
            this.btnRereshScore.Click += new System.EventHandler(this.btnRereshScore_Click);
            // 
            // lbMatchCourt
            // 
            this.lbMatchCourt.AutoSize = true;
            this.lbMatchCourt.Font = new System.Drawing.Font("Microsoft YaHei", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lbMatchCourt.ForeColor = System.Drawing.Color.Blue;
            this.lbMatchCourt.Location = new System.Drawing.Point(306, 4);
            this.lbMatchCourt.Name = "lbMatchCourt";
            this.lbMatchCourt.Size = new System.Drawing.Size(32, 17);
            this.lbMatchCourt.TabIndex = 15;
            this.lbMatchCourt.Text = "XXX";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft YaHei", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label3.Location = new System.Drawing.Point(255, 4);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(43, 17);
            this.label3.TabIndex = 14;
            this.label3.Text = "Court:";
            // 
            // lbMatchRSC
            // 
            this.lbMatchRSC.AutoSize = true;
            this.lbMatchRSC.Font = new System.Drawing.Font("Microsoft YaHei", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lbMatchRSC.ForeColor = System.Drawing.Color.Blue;
            this.lbMatchRSC.Location = new System.Drawing.Point(472, 4);
            this.lbMatchRSC.Name = "lbMatchRSC";
            this.lbMatchRSC.Size = new System.Drawing.Size(80, 17);
            this.lbMatchRSC.TabIndex = 17;
            this.lbMatchRSC.Text = "XXXXXXXXX";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft YaHei", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label4.Location = new System.Drawing.Point(430, 4);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(34, 17);
            this.label4.TabIndex = 16;
            this.label4.Text = "RSC:";
            // 
            // lbMatchTime
            // 
            this.lbMatchTime.AutoSize = true;
            this.lbMatchTime.Font = new System.Drawing.Font("Microsoft YaHei", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lbMatchTime.ForeColor = System.Drawing.Color.Blue;
            this.lbMatchTime.Location = new System.Drawing.Point(325, 24);
            this.lbMatchTime.Name = "lbMatchTime";
            this.lbMatchTime.Size = new System.Drawing.Size(140, 17);
            this.lbMatchTime.TabIndex = 19;
            this.lbMatchTime.Text = "XXXX-XX-XX XX:XX:XX";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft YaHei", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label5.Location = new System.Drawing.Point(253, 24);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(66, 17);
            this.label5.TabIndex = 18;
            this.label5.Text = "StartTime:";
            // 
            // lbMatchScore
            // 
            this.lbMatchScore.AutoSize = true;
            this.lbMatchScore.Font = new System.Drawing.Font("Microsoft YaHei", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lbMatchScore.ForeColor = System.Drawing.Color.Blue;
            this.lbMatchScore.Location = new System.Drawing.Point(575, 21);
            this.lbMatchScore.Name = "lbMatchScore";
            this.lbMatchScore.Size = new System.Drawing.Size(81, 20);
            this.lbMatchScore.TabIndex = 21;
            this.lbMatchScore.Text = "XXXXXXXX";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft YaHei", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label6.ForeColor = System.Drawing.Color.Black;
            this.label6.Location = new System.Drawing.Point(473, 21);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(96, 20);
            this.label6.TabIndex = 20;
            this.label6.Text = "Match Score:";
            // 
            // lb878s
            // 
            this.lb878s.AutoSize = true;
            this.lb878s.Font = new System.Drawing.Font("Microsoft YaHei", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lb878s.Location = new System.Drawing.Point(70, 44);
            this.lb878s.Name = "lb878s";
            this.lb878s.Size = new System.Drawing.Size(54, 17);
            this.lb878s.TabIndex = 22;
            this.lb878s.Text = "PlayerA:";
            // 
            // lbPlayerBasdf
            // 
            this.lbPlayerBasdf.AutoSize = true;
            this.lbPlayerBasdf.Font = new System.Drawing.Font("Microsoft YaHei", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lbPlayerBasdf.Location = new System.Drawing.Point(338, 44);
            this.lbPlayerBasdf.Name = "lbPlayerBasdf";
            this.lbPlayerBasdf.Size = new System.Drawing.Size(54, 17);
            this.lbPlayerBasdf.TabIndex = 23;
            this.lbPlayerBasdf.Text = "PlayerB:";
            // 
            // lbPlayerA
            // 
            this.lbPlayerA.AutoSize = true;
            this.lbPlayerA.Font = new System.Drawing.Font("Microsoft YaHei", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lbPlayerA.ForeColor = System.Drawing.Color.Blue;
            this.lbPlayerA.Location = new System.Drawing.Point(130, 44);
            this.lbPlayerA.Name = "lbPlayerA";
            this.lbPlayerA.Size = new System.Drawing.Size(54, 17);
            this.lbPlayerA.TabIndex = 24;
            this.lbPlayerA.Text = "PlayerA:";
            // 
            // lbPlayerB
            // 
            this.lbPlayerB.AutoSize = true;
            this.lbPlayerB.Font = new System.Drawing.Font("Microsoft YaHei", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lbPlayerB.ForeColor = System.Drawing.Color.Blue;
            this.lbPlayerB.Location = new System.Drawing.Point(398, 44);
            this.lbPlayerB.Name = "lbPlayerB";
            this.lbPlayerB.Size = new System.Drawing.Size(54, 17);
            this.lbPlayerB.TabIndex = 25;
            this.lbPlayerB.Text = "PlayerB:";
            // 
            // btnGetCurrentMatch
            // 
            this.btnGetCurrentMatch.Location = new System.Drawing.Point(190, 7);
            this.btnGetCurrentMatch.Name = "btnGetCurrentMatch";
            this.btnGetCurrentMatch.Size = new System.Drawing.Size(57, 30);
            this.btnGetCurrentMatch.TabIndex = 26;
            this.btnGetCurrentMatch.Text = "Current";
            this.btnGetCurrentMatch.UseVisualStyleBackColor = true;
            this.btnGetCurrentMatch.Click += new System.EventHandler(this.btnGetCurrentMatch_Click);
            // 
            // chkAutoRefresh
            // 
            this.chkAutoRefresh.AutoSize = true;
            this.chkAutoRefresh.Location = new System.Drawing.Point(680, 46);
            this.chkAutoRefresh.Name = "chkAutoRefresh";
            this.chkAutoRefresh.Size = new System.Drawing.Size(48, 16);
            this.chkAutoRefresh.TabIndex = 27;
            this.chkAutoRefresh.Text = "Auto";
            this.chkAutoRefresh.UseVisualStyleBackColor = true;
            this.chkAutoRefresh.Click += new System.EventHandler(this.chkRefreshClicked);
            // 
            // scoreFrame
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(746, 228);
            this.Controls.Add(this.chkAutoRefresh);
            this.Controls.Add(this.btnGetCurrentMatch);
            this.Controls.Add(this.lbPlayerB);
            this.Controls.Add(this.lbPlayerA);
            this.Controls.Add(this.lbPlayerBasdf);
            this.Controls.Add(this.lb878s);
            this.Controls.Add(this.lbMatchScore);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.lbMatchTime);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.lbMatchRSC);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.lbMatchCourt);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.btnRereshScore);
            this.Controls.Add(this.lbMatchID);
            this.Controls.Add(this.btnRemoveMatchID);
            this.Controls.Add(this.lsbMatchID);
            this.Controls.Add(this.tbInputMatchID);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btnAddMatchID);
            this.Controls.Add(this.dgViewScore);
            this.ForeColor = System.Drawing.Color.Black;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "scoreFrame";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "scoreFrame";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.formClosing);
            ((System.ComponentModel.ISupportInitialize)(this.dgViewScore)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevComponents.DotNetBar.Controls.DataGridViewX dgViewScore;
        private System.Windows.Forms.Button btnAddMatchID;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox tbInputMatchID;
        private System.Windows.Forms.ListBox lsbMatchID;
        private System.Windows.Forms.Button btnRemoveMatchID;
        private System.Windows.Forms.Label lbMatchID;
        private System.Windows.Forms.Button btnRereshScore;
        private System.Windows.Forms.Label lbMatchCourt;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label lbMatchRSC;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label lbMatchTime;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label lbMatchScore;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label lb878s;
        private System.Windows.Forms.Label lbPlayerBasdf;
        private System.Windows.Forms.Label lbPlayerA;
        private System.Windows.Forms.Label lbPlayerB;
        private System.Windows.Forms.Button btnGetCurrentMatch;
        private System.Windows.Forms.CheckBox chkAutoRefresh;

    }
}