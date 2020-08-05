using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    partial class frmOVROfficialEntry
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle7 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle8 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle9 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle10 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle11 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle12 = new System.Windows.Forms.DataGridViewCellStyle();
            this.btnRemove = new Sunny.UI.UISymbolButton();
            this.btnAdd = new Sunny.UI.UISymbolButton();
            this.dgvMatchOfficial = new Sunny.UI.UIDataGridView();
            this.lbMatchOfficial = new Sunny.UI.UILabel();
            this.dgvAvailOfficial = new Sunny.UI.UIDataGridView();
            this.lbAvailOfficial = new Sunny.UI.UILabel();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchOfficial)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvAvailOfficial)).BeginInit();
            this.SuspendLayout();
            // 
            // btnRemove
            // 
            this.btnRemove.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRemove.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnRemove.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnRemove.Location = new System.Drawing.Point(224, 209);
            this.btnRemove.Name = "btnRemove";
            this.btnRemove.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnRemove.Size = new System.Drawing.Size(55, 31);
            this.btnRemove.Style = Sunny.UI.UIStyle.Custom;
            this.btnRemove.Symbol = 61608;
            this.btnRemove.TabIndex = 7;
            this.btnRemove.Click += new System.EventHandler(this.btnRemove_Click);
            // 
            // btnAdd
            // 
            this.btnAdd.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAdd.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnAdd.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnAdd.Location = new System.Drawing.Point(224, 132);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnAdd.Size = new System.Drawing.Size(55, 31);
            this.btnAdd.Style = Sunny.UI.UIStyle.Custom;
            this.btnAdd.Symbol = 61609;
            this.btnAdd.TabIndex = 8;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // dgvMatchOfficial
            // 
            this.dgvMatchOfficial.AllowUserToAddRows = false;
            dataGridViewCellStyle7.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvMatchOfficial.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle7;
            this.dgvMatchOfficial.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvMatchOfficial.BackgroundColor = System.Drawing.Color.White;
            this.dgvMatchOfficial.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvMatchOfficial.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle8.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle8.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle8.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle8.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle8.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle8.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle8.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvMatchOfficial.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle8;
            this.dgvMatchOfficial.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchOfficial.EnableHeadersVisualStyles = false;
            this.dgvMatchOfficial.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvMatchOfficial.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMatchOfficial.Location = new System.Drawing.Point(285, 61);
            this.dgvMatchOfficial.Name = "dgvMatchOfficial";
            this.dgvMatchOfficial.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMatchOfficial.RowHeadersVisible = false;
            dataGridViewCellStyle9.BackColor = System.Drawing.Color.White;
            this.dgvMatchOfficial.RowsDefaultCellStyle = dataGridViewCellStyle9;
            this.dgvMatchOfficial.RowTemplate.Height = 29;
            this.dgvMatchOfficial.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvMatchOfficial.SelectedIndex = -1;
            this.dgvMatchOfficial.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvMatchOfficial.Size = new System.Drawing.Size(224, 294);
            this.dgvMatchOfficial.Style = Sunny.UI.UIStyle.Custom;
            this.dgvMatchOfficial.TabIndex = 6;
            this.dgvMatchOfficial.TagString = null;
            this.dgvMatchOfficial.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvMatchOfficial_CellBeginEdit);
            this.dgvMatchOfficial.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchOfficial_CellValueChanged);
            // 
            // lbMatchOfficial
            // 
            this.lbMatchOfficial.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbMatchOfficial.Location = new System.Drawing.Point(281, 35);
            this.lbMatchOfficial.Name = "lbMatchOfficial";
            this.lbMatchOfficial.Size = new System.Drawing.Size(161, 23);
            this.lbMatchOfficial.Style = Sunny.UI.UIStyle.Custom;
            this.lbMatchOfficial.TabIndex = 3;
            this.lbMatchOfficial.Text = "Match Offiicial";
            this.lbMatchOfficial.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // dgvAvailOfficial
            // 
            this.dgvAvailOfficial.AllowUserToAddRows = false;
            dataGridViewCellStyle10.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvAvailOfficial.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle10;
            this.dgvAvailOfficial.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvAvailOfficial.BackgroundColor = System.Drawing.Color.White;
            this.dgvAvailOfficial.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvAvailOfficial.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle11.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle11.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle11.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle11.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle11.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle11.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle11.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvAvailOfficial.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle11;
            this.dgvAvailOfficial.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvAvailOfficial.EnableHeadersVisualStyles = false;
            this.dgvAvailOfficial.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvAvailOfficial.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvAvailOfficial.Location = new System.Drawing.Point(3, 61);
            this.dgvAvailOfficial.Name = "dgvAvailOfficial";
            this.dgvAvailOfficial.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvAvailOfficial.RowHeadersVisible = false;
            dataGridViewCellStyle12.BackColor = System.Drawing.Color.White;
            this.dgvAvailOfficial.RowsDefaultCellStyle = dataGridViewCellStyle12;
            this.dgvAvailOfficial.RowTemplate.Height = 29;
            this.dgvAvailOfficial.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvAvailOfficial.SelectedIndex = -1;
            this.dgvAvailOfficial.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvAvailOfficial.Size = new System.Drawing.Size(215, 294);
            this.dgvAvailOfficial.Style = Sunny.UI.UIStyle.Custom;
            this.dgvAvailOfficial.TabIndex = 5;
            this.dgvAvailOfficial.TagString = null;
            // 
            // lbAvailOfficial
            // 
            this.lbAvailOfficial.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbAvailOfficial.Location = new System.Drawing.Point(12, 35);
            this.lbAvailOfficial.Name = "lbAvailOfficial";
            this.lbAvailOfficial.Size = new System.Drawing.Size(161, 23);
            this.lbAvailOfficial.Style = Sunny.UI.UIStyle.Custom;
            this.lbAvailOfficial.TabIndex = 4;
            this.lbAvailOfficial.Text = "Available Offiicial";
            this.lbAvailOfficial.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // frmOVROfficialEntry
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(514, 361);
            this.Controls.Add(this.btnRemove);
            this.Controls.Add(this.btnAdd);
            this.Controls.Add(this.dgvMatchOfficial);
            this.Controls.Add(this.lbMatchOfficial);
            this.Controls.Add(this.dgvAvailOfficial);
            this.Controls.Add(this.lbAvailOfficial);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmOVROfficialEntry";
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "OfficialEntry";
            this.Load += new System.EventHandler(this.frmOfficialEntry_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchOfficial)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvAvailOfficial)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private UISymbolButton btnRemove;
        private UISymbolButton btnAdd;
        private UIDataGridView dgvMatchOfficial;
        private UILabel lbMatchOfficial;
        private UIDataGridView dgvAvailOfficial;
        private UILabel lbAvailOfficial;
    }
}