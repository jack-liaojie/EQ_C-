namespace AutoSports.OVRGFPlugin
{
    partial class frmPlayOffSetting
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
            this.dgvHoleList = new System.Windows.Forms.DataGridView();
            this.btnx_OK = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Cancel = new DevComponents.DotNetBar.ButtonX();
            this.label1 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.dgvHoleList)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvHoleList
            // 
            this.dgvHoleList.AllowUserToAddRows = false;
            this.dgvHoleList.AllowUserToDeleteRows = false;
            this.dgvHoleList.AllowUserToResizeColumns = false;
            this.dgvHoleList.AllowUserToResizeRows = false;
            this.dgvHoleList.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvHoleList.EnableHeadersVisualStyles = false;
            this.dgvHoleList.Location = new System.Drawing.Point(7, 58);
            this.dgvHoleList.MultiSelect = false;
            this.dgvHoleList.Name = "dgvHoleList";
            this.dgvHoleList.RowHeadersVisible = false;
            this.dgvHoleList.RowTemplate.Height = 23;
            this.dgvHoleList.ShowEditingIcon = false;
            this.dgvHoleList.Size = new System.Drawing.Size(375, 53);
            this.dgvHoleList.TabIndex = 2;
            this.dgvHoleList.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgvHoleList_CellValidating);
            // 
            // btnx_OK
            // 
            this.btnx_OK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_OK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_OK.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.ok_24;
            this.btnx_OK.Location = new System.Drawing.Point(96, 129);
            this.btnx_OK.Name = "btnx_OK";
            this.btnx_OK.Size = new System.Drawing.Size(63, 30);
            this.btnx_OK.TabIndex = 9;
            this.btnx_OK.Click += new System.EventHandler(this.btnx_OK_Click);
            // 
            // btnx_Cancel
            // 
            this.btnx_Cancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Cancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Cancel.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.cancel_24;
            this.btnx_Cancel.Location = new System.Drawing.Point(215, 129);
            this.btnx_Cancel.Name = "btnx_Cancel";
            this.btnx_Cancel.Size = new System.Drawing.Size(63, 30);
            this.btnx_Cancel.TabIndex = 10;
            this.btnx_Cancel.Click += new System.EventHandler(this.btnx_Cancel_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(7, 43);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(65, 12);
            this.label1.TabIndex = 11;
            this.label1.Text = "Play Hole:";
            // 
            // frmPlayOffSetting
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.ClientSize = new System.Drawing.Size(387, 164);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btnx_Cancel);
            this.Controls.Add(this.btnx_OK);
            this.Controls.Add(this.dgvHoleList);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmPlayOffSetting";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmPlayOffSetting";
            this.Load += new System.EventHandler(this.frmPlayOffSetting_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvHoleList)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvHoleList;
        private DevComponents.DotNetBar.ButtonX btnx_OK;
        private DevComponents.DotNetBar.ButtonX btnx_Cancel;
        private System.Windows.Forms.Label label1;
    }
}