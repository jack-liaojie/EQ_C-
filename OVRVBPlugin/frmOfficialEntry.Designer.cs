namespace AutoSports.OVRVBPlugin
{
	partial class frmOfficialEntry
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
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmOfficialEntry));
			this.btnRemove = new DevComponents.DotNetBar.ButtonX();
			this.btnAdd = new DevComponents.DotNetBar.ButtonX();
			this.dgvMatchScoreOfficial = new System.Windows.Forms.DataGridView();
			this.lbMatchOfficial = new DevComponents.DotNetBar.LabelX();
			this.dgvAvailOfficial = new System.Windows.Forms.DataGridView();
			this.lbAvailOfficial = new DevComponents.DotNetBar.LabelX();
			((System.ComponentModel.ISupportInitialize)(this.dgvMatchScoreOfficial)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.dgvAvailOfficial)).BeginInit();
			this.SuspendLayout();
			// 
			// btnRemove
			// 
			this.btnRemove.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
			this.btnRemove.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
			this.btnRemove.Image = ((System.Drawing.Image)(resources.GetObject("btnRemove.Image")));
			this.btnRemove.Location = new System.Drawing.Point(355, 191);
			this.btnRemove.Name = "btnRemove";
			this.btnRemove.Size = new System.Drawing.Size(55, 34);
			this.btnRemove.TabIndex = 7;
			this.btnRemove.Click += new System.EventHandler(this.btnRemove_Click);
			// 
			// btnAdd
			// 
			this.btnAdd.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
			this.btnAdd.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
			this.btnAdd.Image = ((System.Drawing.Image)(resources.GetObject("btnAdd.Image")));
			this.btnAdd.Location = new System.Drawing.Point(355, 107);
			this.btnAdd.Name = "btnAdd";
			this.btnAdd.Size = new System.Drawing.Size(55, 34);
			this.btnAdd.TabIndex = 8;
			this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
			// 
			// dgvMatchScoreOfficial
			// 
			this.dgvMatchScoreOfficial.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
			this.dgvMatchScoreOfficial.Location = new System.Drawing.Point(452, 52);
			this.dgvMatchScoreOfficial.Name = "dgvMatchScoreOfficial";
			this.dgvMatchScoreOfficial.RowTemplate.Height = 23;
			this.dgvMatchScoreOfficial.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
			this.dgvMatchScoreOfficial.Size = new System.Drawing.Size(315, 494);
			this.dgvMatchScoreOfficial.TabIndex = 6;
			this.dgvMatchScoreOfficial.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvMatchScoreOfficial_CellBeginEdit);
			this.dgvMatchScoreOfficial.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchScoreOfficial_CellValueChanged);
			// 
			// lbMatchOfficial
			// 
			// 
			// 
			// 
			this.lbMatchOfficial.BackgroundStyle.Class = "";
			this.lbMatchOfficial.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
			this.lbMatchOfficial.Location = new System.Drawing.Point(461, 23);
			this.lbMatchOfficial.Name = "lbMatchOfficial";
			this.lbMatchOfficial.Size = new System.Drawing.Size(161, 25);
			this.lbMatchOfficial.TabIndex = 3;
			this.lbMatchOfficial.Text = "Match Offiicial";
			// 
			// dgvAvailOfficial
			// 
			this.dgvAvailOfficial.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
			this.dgvAvailOfficial.Location = new System.Drawing.Point(12, 52);
			this.dgvAvailOfficial.Name = "dgvAvailOfficial";
			this.dgvAvailOfficial.RowTemplate.Height = 23;
			this.dgvAvailOfficial.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
			this.dgvAvailOfficial.Size = new System.Drawing.Size(302, 494);
			this.dgvAvailOfficial.TabIndex = 5;
			// 
			// lbAvailOfficial
			// 
			// 
			// 
			// 
			this.lbAvailOfficial.BackgroundStyle.Class = "";
			this.lbAvailOfficial.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
			this.lbAvailOfficial.Location = new System.Drawing.Point(12, 23);
			this.lbAvailOfficial.Name = "lbAvailOfficial";
			this.lbAvailOfficial.Size = new System.Drawing.Size(161, 25);
			this.lbAvailOfficial.TabIndex = 4;
			this.lbAvailOfficial.Text = "Available Offiicial";
			// 
			// frmOfficialEntry
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
			this.ClientSize = new System.Drawing.Size(795, 569);
			this.Controls.Add(this.btnRemove);
			this.Controls.Add(this.btnAdd);
			this.Controls.Add(this.dgvMatchScoreOfficial);
			this.Controls.Add(this.lbMatchOfficial);
			this.Controls.Add(this.dgvAvailOfficial);
			this.Controls.Add(this.lbAvailOfficial);
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "frmOfficialEntry";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "OfficialEntry";
			this.Load += new System.EventHandler(this.frmOfficialEntry_Load);
			((System.ComponentModel.ISupportInitialize)(this.dgvMatchScoreOfficial)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.dgvAvailOfficial)).EndInit();
			this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnRemove;
        private DevComponents.DotNetBar.ButtonX btnAdd;
        private System.Windows.Forms.DataGridView dgvMatchScoreOfficial;
        private DevComponents.DotNetBar.LabelX lbMatchOfficial;
        private System.Windows.Forms.DataGridView dgvAvailOfficial;
        private DevComponents.DotNetBar.LabelX lbAvailOfficial;
    }
}