using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    partial class OVREQMatchMF
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
            this.dgvMatchMF = new Sunny.UI.UIDataGridView();
            this.btnx_MF = new Sunny.UI.UIButton();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchMF)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvMatchMF
            // 
            this.dgvMatchMF.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvMatchMF.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvMatchMF.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvMatchMF.BackgroundColor = System.Drawing.Color.White;
            this.dgvMatchMF.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvMatchMF.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvMatchMF.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvMatchMF.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvMatchMF.DefaultCellStyle = dataGridViewCellStyle3;
            this.dgvMatchMF.EnableHeadersVisualStyles = false;
            this.dgvMatchMF.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvMatchMF.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMatchMF.Location = new System.Drawing.Point(10, 35);
            this.dgvMatchMF.Name = "dgvMatchMF";
            this.dgvMatchMF.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMatchMF.RowHeadersVisible = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.White;
            this.dgvMatchMF.RowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvMatchMF.RowTemplate.Height = 29;
            this.dgvMatchMF.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvMatchMF.SelectedIndex = -1;
            this.dgvMatchMF.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvMatchMF.Size = new System.Drawing.Size(678, 317);
            this.dgvMatchMF.TabIndex = 17;
            this.dgvMatchMF.TagString = null;
            this.dgvMatchMF.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvMatchMF_CellBeginEdit);
            this.dgvMatchMF.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchMF_CellValueChanged);
            // 
            // btnx_MF
            // 
            this.btnx_MF.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_MF.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnx_MF.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnx_MF.Location = new System.Drawing.Point(588, 358);
            this.btnx_MF.Name = "btnx_MF";
            this.btnx_MF.Size = new System.Drawing.Size(100, 25);
            this.btnx_MF.TabIndex = 18;
            this.btnx_MF.Text = "MF";
            this.btnx_MF.Click += new System.EventHandler(this.btnx_MF_Click);
            // 
            // OVREQMatchMF
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(702, 405);
            this.Controls.Add(this.btnx_MF);
            this.Controls.Add(this.dgvMatchMF);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVREQMatchMF";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Match MF";
            this.Load += new System.EventHandler(this.OVREQMatchMF_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchMF)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private UIDataGridView dgvMatchMF;
        private UIButton btnx_MF;
    }
}