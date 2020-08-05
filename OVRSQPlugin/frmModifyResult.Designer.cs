namespace AutoSports.OVRSQPlugin
{
    partial class frmModifyResult
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
            this.dgvMatchResult = new System.Windows.Forms.DataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchResult)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvMatchResult
            // 
            this.dgvMatchResult.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchResult.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvMatchResult.Location = new System.Drawing.Point(0, 0);
            this.dgvMatchResult.Name = "dgvMatchResult";
            this.dgvMatchResult.RowTemplate.Height = 23;
            this.dgvMatchResult.Size = new System.Drawing.Size(387, 126);
            this.dgvMatchResult.TabIndex = 0;
            this.dgvMatchResult.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchResult_CellValueChanged);
            this.dgvMatchResult.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvMatchResult_CellBeginEdit);
            // 
            // frmModifyResult
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(387, 126);
            this.Controls.Add(this.dgvMatchResult);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmModifyResult";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmModifyResult";
            this.Load += new System.EventHandler(this.frmModifyResult_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchResult)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvMatchResult;
    }
}