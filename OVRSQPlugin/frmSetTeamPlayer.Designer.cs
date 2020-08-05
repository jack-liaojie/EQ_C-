namespace AutoSports.OVRSQPlugin
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
            ((System.ComponentModel.ISupportInitialize)(this.dgvTeamPlayers)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvTeamPlayers
            // 
            this.dgvTeamPlayers.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.DisplayedCells;
            this.dgvTeamPlayers.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvTeamPlayers.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvTeamPlayers.Location = new System.Drawing.Point(0, 0);
            this.dgvTeamPlayers.Name = "dgvTeamPlayers";
            this.dgvTeamPlayers.RowTemplate.Height = 23;
            this.dgvTeamPlayers.Size = new System.Drawing.Size(470, 208);
            this.dgvTeamPlayers.TabIndex = 0;
            this.dgvTeamPlayers.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvTeamPlayers_CellValueChanged);
            this.dgvTeamPlayers.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvTeamPlayers_CellBeginEdit);
            // 
            // frmSetTeamPlayer
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(470, 208);
            this.Controls.Add(this.dgvTeamPlayers);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmSetTeamPlayer";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmSetTeamPlayer";
            this.Load += new System.EventHandler(this.frmSetTeamPlayer_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvTeamPlayers)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvTeamPlayers;
    }
}