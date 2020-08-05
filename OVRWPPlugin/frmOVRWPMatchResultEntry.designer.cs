namespace AutoSports.OVRWPPlugin
{
    partial class frmMatchResultEntry
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
            this.dgvMatchResult.Location = new System.Drawing.Point(0, 12);
            this.dgvMatchResult.Name = "dgvMatchResult";
            this.dgvMatchResult.RowTemplate.Height = 23;
            this.dgvMatchResult.Size = new System.Drawing.Size(370, 123);
            this.dgvMatchResult.TabIndex = 0;
            this.dgvMatchResult.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvMatchResult_CellBeginEdit);
            this.dgvMatchResult.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchResult_CellValueChanged);
            // 
            // frmMatchResultEntry
            // 
            this.AutoSize = true;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(373, 147);
            this.Controls.Add(this.dgvMatchResult);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmMatchResultEntry";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "MatchResultEntry";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.frmMatchResultEntry_FormClosing);
            this.Load += new System.EventHandler(this.frmMatchResultEntry_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchResult)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvMatchResult;
    }
}