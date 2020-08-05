namespace AutoSports.OVRBDPlugin
{
    partial class frmImportTempData
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
            this.dgvTempSetData = new System.Windows.Forms.DataGridView();
            this.btnViewFile = new DevComponents.DotNetBar.ButtonX();
            this.btnImport = new DevComponents.DotNetBar.ButtonX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvTempSetData)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvTempSetData
            // 
            this.dgvTempSetData.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.DisplayedCells;
            this.dgvTempSetData.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvTempSetData.Location = new System.Drawing.Point(0, 48);
            this.dgvTempSetData.MultiSelect = false;
            this.dgvTempSetData.Name = "dgvTempSetData";
            this.dgvTempSetData.RowTemplate.Height = 23;
            this.dgvTempSetData.Size = new System.Drawing.Size(387, 174);
            this.dgvTempSetData.TabIndex = 2;
            // 
            // btnViewFile
            // 
            this.btnViewFile.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnViewFile.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnViewFile.Location = new System.Drawing.Point(0, 7);
            this.btnViewFile.Name = "btnViewFile";
            this.btnViewFile.Size = new System.Drawing.Size(87, 35);
            this.btnViewFile.TabIndex = 4;
            this.btnViewFile.Text = "View File";
            this.btnViewFile.Click += new System.EventHandler(this.btnViewFile_Click);
            // 
            // btnImport
            // 
            this.btnImport.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnImport.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnImport.Location = new System.Drawing.Point(300, 7);
            this.btnImport.Name = "btnImport";
            this.btnImport.Size = new System.Drawing.Size(87, 35);
            this.btnImport.TabIndex = 4;
            this.btnImport.Text = "Import";
            this.btnImport.Click += new System.EventHandler(this.btnImport_Click);
            // 
            // frmImportTempData
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.ClientSize = new System.Drawing.Size(389, 222);
            this.Controls.Add(this.btnImport);
            this.Controls.Add(this.btnViewFile);
            this.Controls.Add(this.dgvTempSetData);
            this.DoubleBuffered = true;
            this.Name = "frmImportTempData";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmImportTempData";
            this.Load += new System.EventHandler(this.frmImportTempData_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvTempSetData)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvTempSetData;
        private DevComponents.DotNetBar.ButtonX btnViewFile;
        private DevComponents.DotNetBar.ButtonX btnImport;
    }
}