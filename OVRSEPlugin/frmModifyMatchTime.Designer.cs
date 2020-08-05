namespace AutoSports.OVRSEPlugin
{
    partial class frmModifyMatchTime
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
            this.dgvMatchTime = new System.Windows.Forms.DataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchTime)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvMatchTime
            // 
            this.dgvMatchTime.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchTime.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvMatchTime.Location = new System.Drawing.Point(0, 0);
            this.dgvMatchTime.Name = "dgvMatchTime";
            this.dgvMatchTime.RowTemplate.Height = 23;
            this.dgvMatchTime.Size = new System.Drawing.Size(406, 79);
            this.dgvMatchTime.TabIndex = 2;
            this.dgvMatchTime.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchTime_CellValueChanged);
            // 
            // frmModifyMatchTime
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(406, 79);
            this.Controls.Add(this.dgvMatchTime);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmModifyMatchTime";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmModifyMatchTime";
            this.Load += new System.EventHandler(this.frmModifyMatchTime_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchTime)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvMatchTime;
    }
}