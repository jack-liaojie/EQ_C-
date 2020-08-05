namespace AutoSports.OVRSEPlugin
{
    partial class frmTeamPlayers
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
            this.dgvMatchPlayers = new System.Windows.Forms.DataGridView();
            this.lbMatchPlayers = new DevComponents.DotNetBar.LabelX();
            this.lbTeamPlayers = new DevComponents.DotNetBar.LabelX();
            this.btnDel = new DevComponents.DotNetBar.ButtonX();
            this.btnAdd = new DevComponents.DotNetBar.ButtonX();
            this.cmb_Uniform = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbUniform = new DevComponents.DotNetBar.LabelX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvTeamPlayers)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchPlayers)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvTeamPlayers
            // 
            this.dgvTeamPlayers.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvTeamPlayers.Location = new System.Drawing.Point(3, 30);
            this.dgvTeamPlayers.Name = "dgvTeamPlayers";
            this.dgvTeamPlayers.RowTemplate.Height = 23;
            this.dgvTeamPlayers.Size = new System.Drawing.Size(222, 363);
            this.dgvTeamPlayers.TabIndex = 20;
            // 
            // dgvMatchPlayers
            // 
            this.dgvMatchPlayers.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchPlayers.Location = new System.Drawing.Point(288, 30);
            this.dgvMatchPlayers.Name = "dgvMatchPlayers";
            this.dgvMatchPlayers.RowTemplate.Height = 23;
            this.dgvMatchPlayers.Size = new System.Drawing.Size(448, 324);
            this.dgvMatchPlayers.TabIndex = 19;
            this.dgvMatchPlayers.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchPlayers_CellValueChanged);
            this.dgvMatchPlayers.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvMatchPlayers_CellBeginEdit);
            // 
            // lbMatchPlayers
            // 
            this.lbMatchPlayers.AutoSize = true;
            this.lbMatchPlayers.Location = new System.Drawing.Point(289, 8);
            this.lbMatchPlayers.Name = "lbMatchPlayers";
            this.lbMatchPlayers.Size = new System.Drawing.Size(87, 16);
            this.lbMatchPlayers.TabIndex = 23;
            this.lbMatchPlayers.Text = "Match Players";
            // 
            // lbTeamPlayers
            // 
            this.lbTeamPlayers.AutoSize = true;
            this.lbTeamPlayers.Location = new System.Drawing.Point(3, 8);
            this.lbTeamPlayers.Name = "lbTeamPlayers";
            this.lbTeamPlayers.Size = new System.Drawing.Size(112, 16);
            this.lbTeamPlayers.TabIndex = 24;
            this.lbTeamPlayers.Text = "Available Players";
            // 
            // btnDel
            // 
            this.btnDel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnDel.Image = global::AutoSports.OVRSEPlugin.Properties.Resources.left_24;
            this.btnDel.Location = new System.Drawing.Point(231, 228);
            this.btnDel.Name = "btnDel";
            this.btnDel.Size = new System.Drawing.Size(50, 30);
            this.btnDel.TabIndex = 21;
            this.btnDel.Click += new System.EventHandler(this.btnDel_Click);
            // 
            // btnAdd
            // 
            this.btnAdd.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAdd.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnAdd.Image = global::AutoSports.OVRSEPlugin.Properties.Resources.right_24;
            this.btnAdd.Location = new System.Drawing.Point(231, 149);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(50, 30);
            this.btnAdd.TabIndex = 22;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // cmb_Uniform
            // 
            this.cmb_Uniform.DisplayMember = "Text";
            this.cmb_Uniform.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmb_Uniform.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmb_Uniform.FormattingEnabled = true;
            this.cmb_Uniform.ItemHeight = 15;
            this.cmb_Uniform.Location = new System.Drawing.Point(350, 372);
            this.cmb_Uniform.Name = "cmb_Uniform";
            this.cmb_Uniform.Size = new System.Drawing.Size(138, 21);
            this.cmb_Uniform.TabIndex = 25;
            this.cmb_Uniform.SelectionChangeCommitted += new System.EventHandler(this.cmb_Uniform_SelectionChangeCommitted);
            // 
            // lbUniform
            // 
            this.lbUniform.Location = new System.Drawing.Point(288, 377);
            this.lbUniform.Name = "lbUniform";
            this.lbUniform.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.lbUniform.Size = new System.Drawing.Size(56, 16);
            this.lbUniform.TabIndex = 26;
            this.lbUniform.Text = "Uniform:";
            // 
            // frmTeamPlayers
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(741, 405);
            this.Controls.Add(this.lbUniform);
            this.Controls.Add(this.cmb_Uniform);
            this.Controls.Add(this.dgvTeamPlayers);
            this.Controls.Add(this.dgvMatchPlayers);
            this.Controls.Add(this.lbMatchPlayers);
            this.Controls.Add(this.lbTeamPlayers);
            this.Controls.Add(this.btnDel);
            this.Controls.Add(this.btnAdd);
            this.Name = "frmTeamPlayers";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmTeamPlayers";
            this.Load += new System.EventHandler(this.frmTeamPlayers_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvTeamPlayers)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchPlayers)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvTeamPlayers;
        private System.Windows.Forms.DataGridView dgvMatchPlayers;
        private DevComponents.DotNetBar.LabelX lbMatchPlayers;
        private DevComponents.DotNetBar.LabelX lbTeamPlayers;
        private DevComponents.DotNetBar.ButtonX btnDel;
        private DevComponents.DotNetBar.ButtonX btnAdd;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmb_Uniform;
        private DevComponents.DotNetBar.LabelX lbUniform;
    }
}