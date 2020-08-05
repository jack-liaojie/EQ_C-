using Sunny.UI;

namespace AutoSports.OVRGeneralData
{
    partial class OVRDisciplineVenueEditForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.cmbDiscipline = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbDiscipline = new UILabel();
            this.dgvAllVenues = new UIDataGridView();
            this.dgvDisciplineVenue = new UIDataGridView();
            this.btnRemoveDisVenue = new DevComponents.DotNetBar.ButtonX();
            this.btnAddDisVenue = new DevComponents.DotNetBar.ButtonX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvAllVenues)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvDisciplineVenue)).BeginInit();
            this.SuspendLayout();
            // 
            // cmbDiscipline
            // 
            this.cmbDiscipline.DisplayMember = "Text";
            this.cmbDiscipline.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbDiscipline.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbDiscipline.FormattingEnabled = true;
            this.cmbDiscipline.ItemHeight = 15;
            this.cmbDiscipline.Location = new System.Drawing.Point(485, 3);
            this.cmbDiscipline.Name = "cmbDiscipline";
            this.cmbDiscipline.Size = new System.Drawing.Size(164, 21);
            this.cmbDiscipline.TabIndex = 11;
            this.cmbDiscipline.SelectionChangeCommitted += new System.EventHandler(this.cmbDiscipline_SelectionChangeCommitted);
            // 
            // lbDiscipline
            // 
            this.lbDiscipline.AutoSize = true;
            this.lbDiscipline.Location = new System.Drawing.Point(391, 8);
            this.lbDiscipline.Name = "lbDiscipline";
            this.lbDiscipline.Size = new System.Drawing.Size(75, 16);
            this.lbDiscipline.TabIndex = 10;
            this.lbDiscipline.Text = "Discipline:";
            // 
            // dgvAllVenues
            // 
            this.dgvAllVenues.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvAllVenues.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvAllVenues.Location = new System.Drawing.Point(2, 28);
            this.dgvAllVenues.Name = "dgvAllVenues";
            this.dgvAllVenues.RowTemplate.Height = 23;
            this.dgvAllVenues.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvAllVenues.Size = new System.Drawing.Size(320, 385);
            this.dgvAllVenues.TabIndex = 6;
            // 
            // dgvDisciplineVenue
            // 
            this.dgvDisciplineVenue.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvDisciplineVenue.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvDisciplineVenue.Location = new System.Drawing.Point(382, 30);
            this.dgvDisciplineVenue.Name = "dgvDisciplineVenue";
            this.dgvDisciplineVenue.RowTemplate.Height = 23;
            this.dgvDisciplineVenue.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvDisciplineVenue.Size = new System.Drawing.Size(320, 385);
            this.dgvDisciplineVenue.TabIndex = 6;
            // 
            // btnRemoveDisVenue
            // 
            this.btnRemoveDisVenue.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRemoveDisVenue.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnRemoveDisVenue.Image = global::AutoSports.OVRGeneralData.Properties.Resources.left_24;
            this.btnRemoveDisVenue.Location = new System.Drawing.Point(328, 119);
            this.btnRemoveDisVenue.Name = "btnRemoveDisVenue";
            this.btnRemoveDisVenue.Size = new System.Drawing.Size(50, 30);
            this.btnRemoveDisVenue.TabIndex = 6;
            this.btnRemoveDisVenue.Click += new System.EventHandler(this.btnRemoveDisVenue_Click);
            // 
            // btnAddDisVenue
            // 
            this.btnAddDisVenue.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAddDisVenue.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnAddDisVenue.Image = global::AutoSports.OVRGeneralData.Properties.Resources.right_24;
            this.btnAddDisVenue.Location = new System.Drawing.Point(328, 74);
            this.btnAddDisVenue.Name = "btnAddDisVenue";
            this.btnAddDisVenue.Size = new System.Drawing.Size(50, 30);
            this.btnAddDisVenue.TabIndex = 7;
            this.btnAddDisVenue.Click += new System.EventHandler(this.btnAddDisVenue_Click);
            // 
            // OVRDisciplineVenueEditForm
            // 
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(707, 419);
            this.Controls.Add(this.dgvDisciplineVenue);
            this.Controls.Add(this.dgvAllVenues);
            this.Controls.Add(this.cmbDiscipline);
            this.Controls.Add(this.lbDiscipline);
            this.Controls.Add(this.btnRemoveDisVenue);
            this.Controls.Add(this.btnAddDisVenue);
            
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRDisciplineVenueEditForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "SetDisciplineVenue";
            this.Load += new System.EventHandler(this.DisciplineVenueForm_Load);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.frmOVRDisciplineVenueEdit_FormClosed);
            ((System.ComponentModel.ISupportInitialize)(this.dgvAllVenues)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvDisciplineVenue)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbDiscipline;
        private UILabel lbDiscipline;
        private DevComponents.DotNetBar.ButtonX btnRemoveDisVenue;
        private DevComponents.DotNetBar.ButtonX btnAddDisVenue;
        private UIDataGridView dgvAllVenues;
        private UIDataGridView dgvDisciplineVenue;
    }
}