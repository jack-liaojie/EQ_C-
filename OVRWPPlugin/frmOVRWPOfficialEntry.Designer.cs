namespace AutoSports.OVRWPPlugin
{
    partial class frmOVRWPOfficialEntry
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmOVRWPOfficialEntry));
            this.btnRemove = new DevComponents.DotNetBar.ButtonX();
            this.btnAdd = new DevComponents.DotNetBar.ButtonX();
            this.dgvMatchOfficial = new System.Windows.Forms.DataGridView();
            this.lbMatchOfficial = new DevComponents.DotNetBar.LabelX();
            this.dgvAvailOfficial = new System.Windows.Forms.DataGridView();
            this.lbAvailOfficial = new DevComponents.DotNetBar.LabelX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchOfficial)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvAvailOfficial)).BeginInit();
            this.SuspendLayout();
            // 
            // btnRemove
            // 
            this.btnRemove.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRemove.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnRemove.Image = ((System.Drawing.Image)(resources.GetObject("btnRemove.Image")));
            this.btnRemove.Location = new System.Drawing.Point(313, 179);
            this.btnRemove.Name = "btnRemove";
            this.btnRemove.Size = new System.Drawing.Size(55, 31);
            this.btnRemove.TabIndex = 7;
            this.btnRemove.Click += new System.EventHandler(this.btnRemove_Click);
            // 
            // btnAdd
            // 
            this.btnAdd.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAdd.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnAdd.Image = ((System.Drawing.Image)(resources.GetObject("btnAdd.Image")));
            this.btnAdd.Location = new System.Drawing.Point(313, 103);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(55, 31);
            this.btnAdd.TabIndex = 8;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // dgvMatchOfficial
            // 
            this.dgvMatchOfficial.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchOfficial.Location = new System.Drawing.Point(374, 50);
            this.dgvMatchOfficial.Name = "dgvMatchOfficial";
            this.dgvMatchOfficial.RowTemplate.Height = 23;
            this.dgvMatchOfficial.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvMatchOfficial.Size = new System.Drawing.Size(282, 294);
            this.dgvMatchOfficial.TabIndex = 6;
            this.dgvMatchOfficial.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvMatchOfficial_CellBeginEdit);
            this.dgvMatchOfficial.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchOfficial_CellValueChanged);
            // 
            // lbMatchOfficial
            // 
            // 
            // 
            // 
            this.lbMatchOfficial.BackgroundStyle.Class = "";
            this.lbMatchOfficial.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbMatchOfficial.Location = new System.Drawing.Point(327, 21);
            this.lbMatchOfficial.Name = "lbMatchOfficial";
            this.lbMatchOfficial.Size = new System.Drawing.Size(161, 23);
            this.lbMatchOfficial.TabIndex = 3;
            this.lbMatchOfficial.Text = "Match Offiicial";
            // 
            // dgvAvailOfficial
            // 
            this.dgvAvailOfficial.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvAvailOfficial.Location = new System.Drawing.Point(12, 48);
            this.dgvAvailOfficial.Name = "dgvAvailOfficial";
            this.dgvAvailOfficial.RowTemplate.Height = 23;
            this.dgvAvailOfficial.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvAvailOfficial.Size = new System.Drawing.Size(295, 294);
            this.dgvAvailOfficial.TabIndex = 5;
            // 
            // lbAvailOfficial
            // 
            // 
            // 
            // 
            this.lbAvailOfficial.BackgroundStyle.Class = "";
            this.lbAvailOfficial.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbAvailOfficial.Location = new System.Drawing.Point(12, 21);
            this.lbAvailOfficial.Name = "lbAvailOfficial";
            this.lbAvailOfficial.Size = new System.Drawing.Size(161, 23);
            this.lbAvailOfficial.TabIndex = 4;
            this.lbAvailOfficial.Text = "Available Offiicial";
            // 
            // frmOVRWPOfficialEntry
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(668, 358);
            this.Controls.Add(this.btnRemove);
            this.Controls.Add(this.btnAdd);
            this.Controls.Add(this.dgvMatchOfficial);
            this.Controls.Add(this.lbMatchOfficial);
            this.Controls.Add(this.dgvAvailOfficial);
            this.Controls.Add(this.lbAvailOfficial);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmOVRWPOfficialEntry";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "OfficialEntry";
            this.Load += new System.EventHandler(this.frmOfficialEntry_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchOfficial)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvAvailOfficial)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnRemove;
        private DevComponents.DotNetBar.ButtonX btnAdd;
        private System.Windows.Forms.DataGridView dgvMatchOfficial;
        private DevComponents.DotNetBar.LabelX lbMatchOfficial;
        private System.Windows.Forms.DataGridView dgvAvailOfficial;
        private DevComponents.DotNetBar.LabelX lbAvailOfficial;
    }
}