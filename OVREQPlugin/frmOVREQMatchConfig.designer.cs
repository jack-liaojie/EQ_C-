using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    partial class OVREQMatchConfig
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
            this.lb_MatchConfig = new Sunny.UI.UILabel();
            this.btnx_MFConfig = new Sunny.UI.UIButton();
            this.dgvMatchConfig = new Sunny.UI.UIDataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchConfig)).BeginInit();
            this.SuspendLayout();
            // 
            // lb_MatchConfig
            // 
            this.lb_MatchConfig.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lb_MatchConfig.Location = new System.Drawing.Point(6, 35);
            this.lb_MatchConfig.Name = "lb_MatchConfig";
            this.lb_MatchConfig.Size = new System.Drawing.Size(197, 41);
            this.lb_MatchConfig.TabIndex = 14;
            this.lb_MatchConfig.Text = "Match Configuration";
            this.lb_MatchConfig.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // btnx_MFConfig
            // 
            this.btnx_MFConfig.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_MFConfig.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnx_MFConfig.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnx_MFConfig.Location = new System.Drawing.Point(10, 164);
            this.btnx_MFConfig.Name = "btnx_MFConfig";
            this.btnx_MFConfig.Size = new System.Drawing.Size(100, 25);
            this.btnx_MFConfig.TabIndex = 15;
            this.btnx_MFConfig.Text = "MF Config";
            this.btnx_MFConfig.Click += new System.EventHandler(this.btnx_MFs_Click);
            // 
            // dgvMatchConfig
            // 
            this.dgvMatchConfig.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvMatchConfig.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvMatchConfig.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvMatchConfig.BackgroundColor = System.Drawing.Color.White;
            this.dgvMatchConfig.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvMatchConfig.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvMatchConfig.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvMatchConfig.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvMatchConfig.DefaultCellStyle = dataGridViewCellStyle3;
            this.dgvMatchConfig.EnableHeadersVisualStyles = false;
            this.dgvMatchConfig.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvMatchConfig.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMatchConfig.Location = new System.Drawing.Point(10, 47);
            this.dgvMatchConfig.Name = "dgvMatchConfig";
            this.dgvMatchConfig.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMatchConfig.RowHeadersVisible = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.White;
            this.dgvMatchConfig.RowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvMatchConfig.RowTemplate.Height = 29;
            this.dgvMatchConfig.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvMatchConfig.SelectedIndex = -1;
            this.dgvMatchConfig.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvMatchConfig.Size = new System.Drawing.Size(778, 102);
            this.dgvMatchConfig.TabIndex = 17;
            this.dgvMatchConfig.TagString = null;
            this.dgvMatchConfig.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgvMatchConfig_CellValidating);
            this.dgvMatchConfig.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchConfig_CellValueChanged);
            // 
            // OVREQMatchConfig
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(791, 212);
            this.Controls.Add(this.dgvMatchConfig);
            this.Controls.Add(this.btnx_MFConfig);
            this.Controls.Add(this.lb_MatchConfig);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVREQMatchConfig";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Match Config";
            this.Load += new System.EventHandler(this.OVREQMatchConfig_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchConfig)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private UILabel lb_MatchConfig;
        private UIButton btnx_MFConfig;
        private UIDataGridView dgvMatchConfig;
    }
}