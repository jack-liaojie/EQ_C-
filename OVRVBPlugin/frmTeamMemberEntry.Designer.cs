﻿namespace AutoSports.OVRVBPlugin
{
	partial class frmTeamMemberEntry
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
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmTeamMemberEntry));
            this.gbHomeTeam = new System.Windows.Forms.GroupBox();
            this.lbUniform_Home = new DevComponents.DotNetBar.LabelX();
            this.cmbUniform_Home = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.btnRemove_Home = new DevComponents.DotNetBar.ButtonX();
            this.btnAdd_Home = new DevComponents.DotNetBar.ButtonX();
            this.dgvMember_Home = new System.Windows.Forms.DataGridView();
            this.lbMember_Home = new DevComponents.DotNetBar.LabelX();
            this.dgvAvailable_Home = new System.Windows.Forms.DataGridView();
            this.lbAvailable_Home = new DevComponents.DotNetBar.LabelX();
            this.gbVisitTeam = new System.Windows.Forms.GroupBox();
            this.lbUniform_Visit = new DevComponents.DotNetBar.LabelX();
            this.lbAvailable_Visit = new DevComponents.DotNetBar.LabelX();
            this.cmbUniform_Visit = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.btnRemove_Visit = new DevComponents.DotNetBar.ButtonX();
            this.btnAdd_Visit = new DevComponents.DotNetBar.ButtonX();
            this.dgvAvailable_Visit = new System.Windows.Forms.DataGridView();
            this.dgvMember_Visit = new System.Windows.Forms.DataGridView();
            this.lbMember_Visit = new DevComponents.DotNetBar.LabelX();
            this.gbHomeTeam.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMember_Home)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvAvailable_Home)).BeginInit();
            this.gbVisitTeam.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvAvailable_Visit)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMember_Visit)).BeginInit();
            this.SuspendLayout();
            // 
            // gbHomeTeam
            // 
            this.gbHomeTeam.Controls.Add(this.lbUniform_Home);
            this.gbHomeTeam.Controls.Add(this.cmbUniform_Home);
            this.gbHomeTeam.Controls.Add(this.btnRemove_Home);
            this.gbHomeTeam.Controls.Add(this.btnAdd_Home);
            this.gbHomeTeam.Controls.Add(this.dgvMember_Home);
            this.gbHomeTeam.Controls.Add(this.lbMember_Home);
            this.gbHomeTeam.Controls.Add(this.dgvAvailable_Home);
            this.gbHomeTeam.Controls.Add(this.lbAvailable_Home);
            this.gbHomeTeam.Location = new System.Drawing.Point(12, 12);
            this.gbHomeTeam.Name = "gbHomeTeam";
            this.gbHomeTeam.Size = new System.Drawing.Size(836, 320);
            this.gbHomeTeam.TabIndex = 5;
            this.gbHomeTeam.TabStop = false;
            this.gbHomeTeam.Text = "Home Team";
            // 
            // lbUniform_Home
            // 
            this.lbUniform_Home.Location = new System.Drawing.Point(465, 13);
            this.lbUniform_Home.Name = "lbUniform_Home";
            this.lbUniform_Home.Size = new System.Drawing.Size(52, 23);
            this.lbUniform_Home.TabIndex = 10;
            this.lbUniform_Home.Text = "Uniform";
            this.lbUniform_Home.TextAlignment = System.Drawing.StringAlignment.Far;
            // 
            // cmbUniform_Home
            // 
            this.cmbUniform_Home.DisplayMember = "Text";
            this.cmbUniform_Home.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbUniform_Home.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbUniform_Home.FormattingEnabled = true;
            this.cmbUniform_Home.ItemHeight = 15;
            this.cmbUniform_Home.Location = new System.Drawing.Point(523, 15);
            this.cmbUniform_Home.Name = "cmbUniform_Home";
            this.cmbUniform_Home.Size = new System.Drawing.Size(121, 21);
            this.cmbUniform_Home.TabIndex = 9;
            this.cmbUniform_Home.SelectionChangeCommitted += new System.EventHandler(this.cmbUniform_Home_SelectionChangeCommitted);
            // 
            // btnRemove_Home
            // 
            this.btnRemove_Home.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRemove_Home.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnRemove_Home.Image = ((System.Drawing.Image)(resources.GetObject("btnRemove_Home.Image")));
            this.btnRemove_Home.Location = new System.Drawing.Point(269, 154);
            this.btnRemove_Home.Name = "btnRemove_Home";
            this.btnRemove_Home.Size = new System.Drawing.Size(67, 32);
            this.btnRemove_Home.TabIndex = 7;
            this.btnRemove_Home.Click += new System.EventHandler(this.btnRemove_Home_Click);
            // 
            // btnAdd_Home
            // 
            this.btnAdd_Home.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAdd_Home.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnAdd_Home.Image = ((System.Drawing.Image)(resources.GetObject("btnAdd_Home.Image")));
            this.btnAdd_Home.Location = new System.Drawing.Point(269, 85);
            this.btnAdd_Home.Name = "btnAdd_Home";
            this.btnAdd_Home.Size = new System.Drawing.Size(67, 32);
            this.btnAdd_Home.TabIndex = 8;
            this.btnAdd_Home.Click += new System.EventHandler(this.btnAdd_Home_Click);
            // 
            // dgvMember_Home
            // 
            this.dgvMember_Home.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMember_Home.Location = new System.Drawing.Point(351, 39);
            this.dgvMember_Home.Name = "dgvMember_Home";
            this.dgvMember_Home.RowTemplate.Height = 23;
            this.dgvMember_Home.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvMember_Home.Size = new System.Drawing.Size(476, 267);
            this.dgvMember_Home.TabIndex = 6;
            this.dgvMember_Home.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvMember_Home_CellBeginEdit);
            this.dgvMember_Home.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMember_Home_CellContentClick);
            this.dgvMember_Home.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMember_Home_CellValueChanged);
            // 
            // lbMember_Home
            // 
            this.lbMember_Home.Location = new System.Drawing.Point(351, 16);
            this.lbMember_Home.Name = "lbMember_Home";
            this.lbMember_Home.Size = new System.Drawing.Size(108, 20);
            this.lbMember_Home.TabIndex = 3;
            this.lbMember_Home.Text = "Match Member";
            // 
            // dgvAvailable_Home
            // 
            this.dgvAvailable_Home.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvAvailable_Home.Location = new System.Drawing.Point(5, 39);
            this.dgvAvailable_Home.Name = "dgvAvailable_Home";
            this.dgvAvailable_Home.RowTemplate.Height = 23;
            this.dgvAvailable_Home.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvAvailable_Home.Size = new System.Drawing.Size(253, 267);
            this.dgvAvailable_Home.TabIndex = 5;
            // 
            // lbAvailable_Home
            // 
            this.lbAvailable_Home.Location = new System.Drawing.Point(9, 16);
            this.lbAvailable_Home.Name = "lbAvailable_Home";
            this.lbAvailable_Home.Size = new System.Drawing.Size(111, 20);
            this.lbAvailable_Home.TabIndex = 4;
            this.lbAvailable_Home.Text = "Home Available";
            // 
            // gbVisitTeam
            // 
            this.gbVisitTeam.Controls.Add(this.lbUniform_Visit);
            this.gbVisitTeam.Controls.Add(this.lbAvailable_Visit);
            this.gbVisitTeam.Controls.Add(this.cmbUniform_Visit);
            this.gbVisitTeam.Controls.Add(this.btnRemove_Visit);
            this.gbVisitTeam.Controls.Add(this.btnAdd_Visit);
            this.gbVisitTeam.Controls.Add(this.dgvAvailable_Visit);
            this.gbVisitTeam.Controls.Add(this.dgvMember_Visit);
            this.gbVisitTeam.Controls.Add(this.lbMember_Visit);
            this.gbVisitTeam.Location = new System.Drawing.Point(12, 350);
            this.gbVisitTeam.Name = "gbVisitTeam";
            this.gbVisitTeam.Size = new System.Drawing.Size(836, 315);
            this.gbVisitTeam.TabIndex = 6;
            this.gbVisitTeam.TabStop = false;
            this.gbVisitTeam.Text = "Visit Team";
            // 
            // lbUniform_Visit
            // 
            this.lbUniform_Visit.Location = new System.Drawing.Point(465, 12);
            this.lbUniform_Visit.Name = "lbUniform_Visit";
            this.lbUniform_Visit.Size = new System.Drawing.Size(52, 23);
            this.lbUniform_Visit.TabIndex = 10;
            this.lbUniform_Visit.Text = "Uniform";
            this.lbUniform_Visit.TextAlignment = System.Drawing.StringAlignment.Far;
            // 
            // lbAvailable_Visit
            // 
            this.lbAvailable_Visit.Location = new System.Drawing.Point(16, 16);
            this.lbAvailable_Visit.Name = "lbAvailable_Visit";
            this.lbAvailable_Visit.Size = new System.Drawing.Size(111, 20);
            this.lbAvailable_Visit.TabIndex = 2;
            this.lbAvailable_Visit.Text = "Home Available";
            // 
            // cmbUniform_Visit
            // 
            this.cmbUniform_Visit.DisplayMember = "Text";
            this.cmbUniform_Visit.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbUniform_Visit.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbUniform_Visit.FormattingEnabled = true;
            this.cmbUniform_Visit.ItemHeight = 15;
            this.cmbUniform_Visit.Location = new System.Drawing.Point(523, 14);
            this.cmbUniform_Visit.Name = "cmbUniform_Visit";
            this.cmbUniform_Visit.Size = new System.Drawing.Size(121, 21);
            this.cmbUniform_Visit.TabIndex = 9;
            this.cmbUniform_Visit.SelectionChangeCommitted += new System.EventHandler(this.cmbUniform_Visit_SelectionChangeCommitted);
            // 
            // btnRemove_Visit
            // 
            this.btnRemove_Visit.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRemove_Visit.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnRemove_Visit.Image = ((System.Drawing.Image)(resources.GetObject("btnRemove_Visit.Image")));
            this.btnRemove_Visit.Location = new System.Drawing.Point(275, 178);
            this.btnRemove_Visit.Name = "btnRemove_Visit";
            this.btnRemove_Visit.Size = new System.Drawing.Size(67, 32);
            this.btnRemove_Visit.TabIndex = 2;
            this.btnRemove_Visit.Click += new System.EventHandler(this.btnRemove_Visit_Click);
            // 
            // btnAdd_Visit
            // 
            this.btnAdd_Visit.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAdd_Visit.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnAdd_Visit.Image = ((System.Drawing.Image)(resources.GetObject("btnAdd_Visit.Image")));
            this.btnAdd_Visit.Location = new System.Drawing.Point(275, 109);
            this.btnAdd_Visit.Name = "btnAdd_Visit";
            this.btnAdd_Visit.Size = new System.Drawing.Size(67, 32);
            this.btnAdd_Visit.TabIndex = 2;
            this.btnAdd_Visit.Click += new System.EventHandler(this.btnAdd_Visit_Click);
            // 
            // dgvAvailable_Visit
            // 
            this.dgvAvailable_Visit.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvAvailable_Visit.Location = new System.Drawing.Point(6, 41);
            this.dgvAvailable_Visit.Name = "dgvAvailable_Visit";
            this.dgvAvailable_Visit.RowTemplate.Height = 23;
            this.dgvAvailable_Visit.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvAvailable_Visit.Size = new System.Drawing.Size(253, 267);
            this.dgvAvailable_Visit.TabIndex = 1;
            // 
            // dgvMember_Visit
            // 
            this.dgvMember_Visit.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMember_Visit.Location = new System.Drawing.Point(351, 41);
            this.dgvMember_Visit.Name = "dgvMember_Visit";
            this.dgvMember_Visit.RowTemplate.Height = 23;
            this.dgvMember_Visit.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvMember_Visit.Size = new System.Drawing.Size(476, 267);
            this.dgvMember_Visit.TabIndex = 1;
            this.dgvMember_Visit.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvMember_Visit_CellBeginEdit);
            this.dgvMember_Visit.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMember_Visit_CellContentClick);
            this.dgvMember_Visit.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMember_Visit_CellValueChanged);
            // 
            // lbMember_Visit
            // 
            this.lbMember_Visit.Location = new System.Drawing.Point(351, 15);
            this.lbMember_Visit.Name = "lbMember_Visit";
            this.lbMember_Visit.Size = new System.Drawing.Size(108, 20);
            this.lbMember_Visit.TabIndex = 0;
            this.lbMember_Visit.Text = "Match Member";
            // 
            // frmOVRWPTeamMemberEntry
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(851, 669);
            this.Controls.Add(this.gbVisitTeam);
            this.Controls.Add(this.gbHomeTeam);
            this.DoubleBuffered = true;
            this.Name = "frmOVRWPTeamMemberEntry";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "TeamMemberEntry";
            this.Load += new System.EventHandler(this.frmTeamMemberEntry_Load);
            this.gbHomeTeam.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMember_Home)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvAvailable_Home)).EndInit();
            this.gbVisitTeam.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvAvailable_Visit)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMember_Visit)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox gbHomeTeam;
        private DevComponents.DotNetBar.LabelX lbUniform_Home;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbUniform_Home;
        private DevComponents.DotNetBar.ButtonX btnRemove_Home;
        private DevComponents.DotNetBar.ButtonX btnAdd_Home;
        private System.Windows.Forms.DataGridView dgvMember_Home;
        private DevComponents.DotNetBar.LabelX lbMember_Home;
        private System.Windows.Forms.DataGridView dgvAvailable_Home;
        private DevComponents.DotNetBar.LabelX lbAvailable_Home;
        private System.Windows.Forms.GroupBox gbVisitTeam;
        private DevComponents.DotNetBar.LabelX lbUniform_Visit;
        private DevComponents.DotNetBar.LabelX lbAvailable_Visit;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbUniform_Visit;
        private DevComponents.DotNetBar.ButtonX btnRemove_Visit;
        private DevComponents.DotNetBar.ButtonX btnAdd_Visit;
        private System.Windows.Forms.DataGridView dgvAvailable_Visit;
        private System.Windows.Forms.DataGridView dgvMember_Visit;
        private DevComponents.DotNetBar.LabelX lbMember_Visit;
    }
  
}