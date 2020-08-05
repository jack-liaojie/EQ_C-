using Sunny.UI;

namespace AutoSports.OVRGeneralData
{
    partial class OVRVenueListForm
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            this.dgvVenueList = new Sunny.UI.UIDataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.dgvVenueList)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvVenueList
            // 
            this.dgvVenueList.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvVenueList.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvVenueList.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvVenueList.BackgroundColor = System.Drawing.Color.White;
            this.dgvVenueList.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvVenueList.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvVenueList.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvVenueList.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvVenueList.ColumnHeadersVisible = false;
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvVenueList.DefaultCellStyle = dataGridViewCellStyle3;
            this.dgvVenueList.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvVenueList.EnableHeadersVisualStyles = false;
            this.dgvVenueList.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvVenueList.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvVenueList.Location = new System.Drawing.Point(2, 35);
            this.dgvVenueList.MultiSelect = false;
            this.dgvVenueList.Name = "dgvVenueList";
            this.dgvVenueList.ReadOnly = true;
            this.dgvVenueList.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvVenueList.RowHeadersVisible = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.White;
            this.dgvVenueList.RowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvVenueList.RowTemplate.Height = 29;
            this.dgvVenueList.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvVenueList.SelectedIndex = -1;
            this.dgvVenueList.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvVenueList.Size = new System.Drawing.Size(320, 161);
            this.dgvVenueList.TabIndex = 0;
            this.dgvVenueList.TagString = null;
            // 
            // OVRVenueListForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(324, 198);
            this.Controls.Add(this.dgvVenueList);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRVenueListForm";
            this.Padding = new System.Windows.Forms.Padding(2, 35, 2, 2);
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.OVRVenueListForm_FormClosed);
            this.Load += new System.EventHandler(this.OVRVenueListForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvVenueList)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private UIDataGridView dgvVenueList;
    }
}