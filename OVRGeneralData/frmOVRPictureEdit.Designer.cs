using Sunny.UI;

namespace AutoSports.OVRGeneralData
{
    partial class OVRPictureEditForm
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            this.dgvPicture = new Sunny.UI.UIDataGridView();
            this.pictureBox = new System.Windows.Forms.PictureBox();
            this.btnImport = new DevComponents.DotNetBar.ButtonX();
            this.btnExport = new DevComponents.DotNetBar.ButtonX();
            this.btnNewPic = new DevComponents.DotNetBar.ButtonX();
            this.btnDeletePic = new DevComponents.DotNetBar.ButtonX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPicture)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvPicture
            // 
            this.dgvPicture.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvPicture.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvPicture.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvPicture.BackgroundColor = System.Drawing.Color.White;
            this.dgvPicture.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvPicture.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvPicture.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvPicture.ColumnHeadersHeight = 32;
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvPicture.DefaultCellStyle = dataGridViewCellStyle3;
            this.dgvPicture.EnableHeadersVisualStyles = false;
            this.dgvPicture.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvPicture.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvPicture.Location = new System.Drawing.Point(3, 70);
            this.dgvPicture.MultiSelect = false;
            this.dgvPicture.Name = "dgvPicture";
            this.dgvPicture.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvPicture.RowHeadersVisible = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.White;
            this.dgvPicture.RowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvPicture.RowTemplate.Height = 29;
            this.dgvPicture.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvPicture.SelectedIndex = -1;
            this.dgvPicture.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvPicture.Size = new System.Drawing.Size(323, 350);
            this.dgvPicture.TabIndex = 0;
            this.dgvPicture.TagString = null;
            this.dgvPicture.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvPicture_CellValueChanged);
            this.dgvPicture.SelectionChanged += new System.EventHandler(this.dgvPicture_SelectionChanged);
            // 
            // pictureBox
            // 
            this.pictureBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pictureBox.ErrorImage = null;
            this.pictureBox.InitialImage = null;
            this.pictureBox.Location = new System.Drawing.Point(332, 70);
            this.pictureBox.Name = "pictureBox";
            this.pictureBox.Size = new System.Drawing.Size(341, 350);
            this.pictureBox.TabIndex = 2;
            this.pictureBox.TabStop = false;
            // 
            // btnImport
            // 
            this.btnImport.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnImport.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnImport.Image = global::AutoSports.OVRGeneralData.Properties.Resources.edit_24;
            this.btnImport.Location = new System.Drawing.Point(72, 35);
            this.btnImport.Name = "btnImport";
            this.btnImport.Size = new System.Drawing.Size(50, 30);
            this.btnImport.TabIndex = 3;
            this.btnImport.Click += new System.EventHandler(this.btnImport_Click);
            // 
            // btnExport
            // 
            this.btnExport.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnExport.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnExport.Image = global::AutoSports.OVRGeneralData.Properties.Resources.Save_24;
            this.btnExport.Location = new System.Drawing.Point(206, 35);
            this.btnExport.Name = "btnExport";
            this.btnExport.Size = new System.Drawing.Size(50, 30);
            this.btnExport.TabIndex = 3;
            this.btnExport.Click += new System.EventHandler(this.btnExport_Click);
            // 
            // btnNewPic
            // 
            this.btnNewPic.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnNewPic.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnNewPic.Image = global::AutoSports.OVRGeneralData.Properties.Resources.add_24;
            this.btnNewPic.Location = new System.Drawing.Point(5, 35);
            this.btnNewPic.Name = "btnNewPic";
            this.btnNewPic.Size = new System.Drawing.Size(50, 30);
            this.btnNewPic.TabIndex = 3;
            this.btnNewPic.Click += new System.EventHandler(this.btnNewPic_Click);
            // 
            // btnDeletePic
            // 
            this.btnDeletePic.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDeletePic.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnDeletePic.Image = global::AutoSports.OVRGeneralData.Properties.Resources.remove_24;
            this.btnDeletePic.Location = new System.Drawing.Point(139, 35);
            this.btnDeletePic.Name = "btnDeletePic";
            this.btnDeletePic.Size = new System.Drawing.Size(50, 30);
            this.btnDeletePic.TabIndex = 3;
            this.btnDeletePic.Click += new System.EventHandler(this.btnDeletePic_Click);
            // 
            // OVRPictureEditForm
            // 
            this.ClientSize = new System.Drawing.Size(676, 423);
            this.Controls.Add(this.btnDeletePic);
            this.Controls.Add(this.btnNewPic);
            this.Controls.Add(this.btnExport);
            this.Controls.Add(this.btnImport);
            this.Controls.Add(this.pictureBox);
            this.Controls.Add(this.dgvPicture);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRPictureEditForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "PictureEdit";
            this.Load += new System.EventHandler(this.frmOVRPictureEdit_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvPicture)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private UIDataGridView dgvPicture;
        private System.Windows.Forms.PictureBox pictureBox;
        private DevComponents.DotNetBar.ButtonX btnImport;
        private DevComponents.DotNetBar.ButtonX btnExport;
        private DevComponents.DotNetBar.ButtonX btnNewPic;
        private DevComponents.DotNetBar.ButtonX btnDeletePic;
    }
}