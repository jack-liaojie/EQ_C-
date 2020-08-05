namespace AutoSports.OVRSQPlugin
{
    partial class frmEntryOfficial
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
            this.dgvEventOfficials = new System.Windows.Forms.DataGridView();
            this.dgvMatchOfficial = new System.Windows.Forms.DataGridView();
            this.lbMatchOfficials = new DevComponents.DotNetBar.LabelX();
            this.lbEventOfficial = new DevComponents.DotNetBar.LabelX();
            this.btnDel = new DevComponents.DotNetBar.ButtonX();
            this.btnAdd = new DevComponents.DotNetBar.ButtonX();
            this.lbSubMatch = new DevComponents.DotNetBar.LabelX();
            this.cmb_SubMatch = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            ((System.ComponentModel.ISupportInitialize)(this.dgvEventOfficials)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchOfficial)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvEventOfficials
            // 
            this.dgvEventOfficials.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvEventOfficials.Location = new System.Drawing.Point(7, 34);
            this.dgvEventOfficials.Name = "dgvEventOfficials";
            this.dgvEventOfficials.RowTemplate.Height = 23;
            this.dgvEventOfficials.Size = new System.Drawing.Size(239, 284);
            this.dgvEventOfficials.TabIndex = 7;
            // 
            // dgvMatchOfficial
            // 
            this.dgvMatchOfficial.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchOfficial.Location = new System.Drawing.Point(325, 34);
            this.dgvMatchOfficial.Name = "dgvMatchOfficial";
            this.dgvMatchOfficial.RowTemplate.Height = 23;
            this.dgvMatchOfficial.Size = new System.Drawing.Size(371, 280);
            this.dgvMatchOfficial.TabIndex = 6;
            this.dgvMatchOfficial.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchOfficial_CellValueChanged);
            this.dgvMatchOfficial.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvMatchOfficial_CellBeginEdit);
            // 
            // lbMatchOfficials
            // 
            this.lbMatchOfficials.AutoSize = true;
            this.lbMatchOfficials.Location = new System.Drawing.Point(325, 9);
            this.lbMatchOfficials.Name = "lbMatchOfficials";
            this.lbMatchOfficials.Size = new System.Drawing.Size(99, 16);
            this.lbMatchOfficials.TabIndex = 10;
            this.lbMatchOfficials.Text = "Match Officials";
            // 
            // lbEventOfficial
            // 
            this.lbEventOfficial.AutoSize = true;
            this.lbEventOfficial.Location = new System.Drawing.Point(7, 9);
            this.lbEventOfficial.Name = "lbEventOfficial";
            this.lbEventOfficial.Size = new System.Drawing.Size(124, 16);
            this.lbEventOfficial.TabIndex = 11;
            this.lbEventOfficial.Text = "Available Officials";
            // 
            // btnDel
            // 
            this.btnDel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnDel.Image = global::AutoSports.OVRSQPlugin.Properties.Resources.left_24;
            this.btnDel.Location = new System.Drawing.Point(258, 195);
            this.btnDel.Name = "btnDel";
            this.btnDel.Size = new System.Drawing.Size(50, 30);
            this.btnDel.TabIndex = 8;
            this.btnDel.Click += new System.EventHandler(this.btnDel_Click);
            // 
            // btnAdd
            // 
            this.btnAdd.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAdd.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnAdd.Image = global::AutoSports.OVRSQPlugin.Properties.Resources.right_24;
            this.btnAdd.Location = new System.Drawing.Point(258, 116);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(50, 30);
            this.btnAdd.TabIndex = 9;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // lbSubMatch
            // 
            this.lbSubMatch.Location = new System.Drawing.Point(504, 9);
            this.lbSubMatch.Name = "lbSubMatch";
            this.lbSubMatch.Size = new System.Drawing.Size(63, 23);
            this.lbSubMatch.TabIndex = 21;
            this.lbSubMatch.Text = "SubMatch:";
            // 
            // cmb_SubMatch
            // 
            this.cmb_SubMatch.DisplayMember = "Text";
            this.cmb_SubMatch.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmb_SubMatch.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmb_SubMatch.FormattingEnabled = true;
            this.cmb_SubMatch.ItemHeight = 15;
            this.cmb_SubMatch.Location = new System.Drawing.Point(573, 9);
            this.cmb_SubMatch.Name = "cmb_SubMatch";
            this.cmb_SubMatch.Size = new System.Drawing.Size(121, 21);
            this.cmb_SubMatch.TabIndex = 20;
            this.cmb_SubMatch.SelectionChangeCommitted += new System.EventHandler(this.cmb_SubMatch_SelectionChangeCommitted);
            // 
            // frmEntryOfficial
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(700, 331);
            this.Controls.Add(this.lbSubMatch);
            this.Controls.Add(this.cmb_SubMatch);
            this.Controls.Add(this.dgvEventOfficials);
            this.Controls.Add(this.dgvMatchOfficial);
            this.Controls.Add(this.lbMatchOfficials);
            this.Controls.Add(this.lbEventOfficial);
            this.Controls.Add(this.btnDel);
            this.Controls.Add(this.btnAdd);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmEntryOfficial";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmEntryOfficial";
            this.Load += new System.EventHandler(this.frmEntryOfficial_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvEventOfficials)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchOfficial)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvEventOfficials;
        private System.Windows.Forms.DataGridView dgvMatchOfficial;
        private DevComponents.DotNetBar.LabelX lbMatchOfficials;
        private DevComponents.DotNetBar.LabelX lbEventOfficial;
        private DevComponents.DotNetBar.ButtonX btnDel;
        private DevComponents.DotNetBar.ButtonX btnAdd;
        private DevComponents.DotNetBar.LabelX lbSubMatch;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmb_SubMatch;
    }
}