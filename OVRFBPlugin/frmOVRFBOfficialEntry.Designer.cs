namespace AutoSports.OVRFBPlugin
{
    partial class frmOVRFBOfficialEntry
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmOVRFBOfficialEntry));
            this.btnRemove = new DevComponents.DotNetBar.ButtonX();
            this.btnAdd = new DevComponents.DotNetBar.ButtonX();
            this.dgvMatchOfficial = new System.Windows.Forms.DataGridView();
            this.lbMatchOfficial = new DevComponents.DotNetBar.LabelX();
            this.dgvAvailOfficial = new System.Windows.Forms.DataGridView();
            this.lbAvailOfficial = new DevComponents.DotNetBar.LabelX();
            this.cmbPeriod = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbMatchMode = new DevComponents.DotNetBar.LabelX();
            this.tbAttendance = new DevComponents.DotNetBar.Controls.TextBoxX();
            this.lbAttendance = new DevComponents.DotNetBar.LabelX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchOfficial)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvAvailOfficial)).BeginInit();
            this.SuspendLayout();
            // 
            // btnRemove
            // 
            this.btnRemove.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRemove.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnRemove.Image = ((System.Drawing.Image)(resources.GetObject("btnRemove.Image")));
            this.btnRemove.Location = new System.Drawing.Point(252, 261);
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
            this.btnAdd.Location = new System.Drawing.Point(252, 177);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(55, 34);
            this.btnAdd.TabIndex = 8;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // dgvMatchOfficial
            // 
            this.dgvMatchOfficial.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchOfficial.Location = new System.Drawing.Point(313, 84);
            this.dgvMatchOfficial.Name = "dgvMatchOfficial";
            this.dgvMatchOfficial.RowTemplate.Height = 23;
            this.dgvMatchOfficial.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvMatchOfficial.Size = new System.Drawing.Size(325, 319);
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
            this.lbMatchOfficial.FocusCuesEnabled = true;
            this.lbMatchOfficial.Location = new System.Drawing.Point(313, 53);
            this.lbMatchOfficial.Name = "lbMatchOfficial";
            this.lbMatchOfficial.Size = new System.Drawing.Size(161, 25);
            this.lbMatchOfficial.TabIndex = 3;
            this.lbMatchOfficial.Text = "Match Officials";
            // 
            // dgvAvailOfficial
            // 
            this.dgvAvailOfficial.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvAvailOfficial.Location = new System.Drawing.Point(12, 82);
            this.dgvAvailOfficial.Name = "dgvAvailOfficial";
            this.dgvAvailOfficial.RowTemplate.Height = 23;
            this.dgvAvailOfficial.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvAvailOfficial.Size = new System.Drawing.Size(234, 319);
            this.dgvAvailOfficial.TabIndex = 5;
            // 
            // lbAvailOfficial
            // 
            // 
            // 
            // 
            this.lbAvailOfficial.BackgroundStyle.Class = "";
            this.lbAvailOfficial.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbAvailOfficial.Location = new System.Drawing.Point(12, 53);
            this.lbAvailOfficial.Name = "lbAvailOfficial";
            this.lbAvailOfficial.Size = new System.Drawing.Size(161, 25);
            this.lbAvailOfficial.TabIndex = 4;
            this.lbAvailOfficial.Text = "Available Official";
            // 
            // cmbPeriod
            // 
            this.cmbPeriod.DisplayMember = "Text";
            this.cmbPeriod.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbPeriod.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbPeriod.FormattingEnabled = true;
            this.cmbPeriod.ItemHeight = 15;
            this.cmbPeriod.Location = new System.Drawing.Point(125, 12);
            this.cmbPeriod.Name = "cmbPeriod";
            this.cmbPeriod.Size = new System.Drawing.Size(121, 21);
            this.cmbPeriod.TabIndex = 9;
            this.cmbPeriod.SelectedIndexChanged += new System.EventHandler(this.cmbPeriod_SelectedIndexChanged);
            // 
            // lbMatchMode
            // 
            // 
            // 
            // 
            this.lbMatchMode.BackgroundStyle.Class = "";
            this.lbMatchMode.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbMatchMode.Location = new System.Drawing.Point(12, 8);
            this.lbMatchMode.Name = "lbMatchMode";
            this.lbMatchMode.Size = new System.Drawing.Size(106, 25);
            this.lbMatchMode.TabIndex = 4;
            this.lbMatchMode.Text = "Match Mode";
            // 
            // tbAttendance
            // 
            // 
            // 
            // 
            this.tbAttendance.Border.Class = "TextBoxBorder";
            this.tbAttendance.Border.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.tbAttendance.Location = new System.Drawing.Point(433, 13);
            this.tbAttendance.Name = "tbAttendance";
            this.tbAttendance.Size = new System.Drawing.Size(98, 20);
            this.tbAttendance.TabIndex = 43;
            this.tbAttendance.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tbAttendance_KeyPress);
            this.tbAttendance.Leave += new System.EventHandler(this.tbAttendance_Leave);
            // 
            // lbAttendance
            // 
            // 
            // 
            // 
            this.lbAttendance.BackgroundStyle.Class = "";
            this.lbAttendance.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbAttendance.Location = new System.Drawing.Point(321, 8);
            this.lbAttendance.Name = "lbAttendance";
            this.lbAttendance.Size = new System.Drawing.Size(106, 25);
            this.lbAttendance.TabIndex = 4;
            this.lbAttendance.Text = "Attendance";
            // 
            // frmOVRFBOfficialEntry
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(646, 408);
            this.Controls.Add(this.tbAttendance);
            this.Controls.Add(this.cmbPeriod);
            this.Controls.Add(this.btnRemove);
            this.Controls.Add(this.btnAdd);
            this.Controls.Add(this.dgvMatchOfficial);
            this.Controls.Add(this.lbMatchOfficial);
            this.Controls.Add(this.dgvAvailOfficial);
            this.Controls.Add(this.lbAttendance);
            this.Controls.Add(this.lbMatchMode);
            this.Controls.Add(this.lbAvailOfficial);
            this.DoubleBuffered = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmOVRFBOfficialEntry";
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
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbPeriod;
        private DevComponents.DotNetBar.LabelX lbMatchMode;
        private DevComponents.DotNetBar.Controls.TextBoxX tbAttendance;
        private DevComponents.DotNetBar.LabelX lbAttendance;
    }
}