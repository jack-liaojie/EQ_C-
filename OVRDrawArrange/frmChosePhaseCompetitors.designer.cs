using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    partial class frmChosePhaseCompetitors
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle5 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
            this.dgvEventCompetitors = new Sunny.UI.UIDataGridView();
            this.dgvPhaseCompetitors = new Sunny.UI.UIDataGridView();
            this.btnAdd = new Sunny.UI.UISymbolButton();
            this.btnDel = new Sunny.UI.UISymbolButton();
            this.lbEventPlayers = new Sunny.UI.UILabel();
            this.lbPhasePlayers = new Sunny.UI.UILabel();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.splitContainer3 = new System.Windows.Forms.SplitContainer();
            this.splitContainer2 = new System.Windows.Forms.SplitContainer();
            this.splitContainer4 = new System.Windows.Forms.SplitContainer();
            ((System.ComponentModel.ISupportInitialize)(this.dgvEventCompetitors)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPhaseCompetitors)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer3)).BeginInit();
            this.splitContainer3.Panel1.SuspendLayout();
            this.splitContainer3.Panel2.SuspendLayout();
            this.splitContainer3.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer2)).BeginInit();
            this.splitContainer2.Panel1.SuspendLayout();
            this.splitContainer2.Panel2.SuspendLayout();
            this.splitContainer2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer4)).BeginInit();
            this.splitContainer4.Panel1.SuspendLayout();
            this.splitContainer4.Panel2.SuspendLayout();
            this.splitContainer4.SuspendLayout();
            this.SuspendLayout();
            // 
            // dgvEventCompetitors
            // 
            this.dgvEventCompetitors.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvEventCompetitors.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvEventCompetitors.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvEventCompetitors.BackgroundColor = System.Drawing.Color.White;
            this.dgvEventCompetitors.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvEventCompetitors.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvEventCompetitors.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvEventCompetitors.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvEventCompetitors.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvEventCompetitors.EnableHeadersVisualStyles = false;
            this.dgvEventCompetitors.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvEventCompetitors.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvEventCompetitors.Location = new System.Drawing.Point(0, 0);
            this.dgvEventCompetitors.Name = "dgvEventCompetitors";
            this.dgvEventCompetitors.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvEventCompetitors.RowHeadersVisible = false;
            dataGridViewCellStyle3.BackColor = System.Drawing.Color.White;
            this.dgvEventCompetitors.RowsDefaultCellStyle = dataGridViewCellStyle3;
            this.dgvEventCompetitors.RowTemplate.Height = 29;
            this.dgvEventCompetitors.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvEventCompetitors.SelectedIndex = -1;
            this.dgvEventCompetitors.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvEventCompetitors.Size = new System.Drawing.Size(432, 409);
            this.dgvEventCompetitors.Style = Sunny.UI.UIStyle.Custom;
            this.dgvEventCompetitors.TabIndex = 0;
            this.dgvEventCompetitors.TagString = null;
            // 
            // dgvPhaseCompetitors
            // 
            this.dgvPhaseCompetitors.AllowUserToAddRows = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvPhaseCompetitors.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvPhaseCompetitors.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvPhaseCompetitors.BackgroundColor = System.Drawing.Color.White;
            this.dgvPhaseCompetitors.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvPhaseCompetitors.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle5.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle5.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle5.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle5.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle5.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle5.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle5.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvPhaseCompetitors.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle5;
            this.dgvPhaseCompetitors.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvPhaseCompetitors.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvPhaseCompetitors.EnableHeadersVisualStyles = false;
            this.dgvPhaseCompetitors.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvPhaseCompetitors.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvPhaseCompetitors.Location = new System.Drawing.Point(0, 0);
            this.dgvPhaseCompetitors.Name = "dgvPhaseCompetitors";
            this.dgvPhaseCompetitors.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvPhaseCompetitors.RowHeadersVisible = false;
            dataGridViewCellStyle6.BackColor = System.Drawing.Color.White;
            this.dgvPhaseCompetitors.RowsDefaultCellStyle = dataGridViewCellStyle6;
            this.dgvPhaseCompetitors.RowTemplate.Height = 29;
            this.dgvPhaseCompetitors.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvPhaseCompetitors.SelectedIndex = -1;
            this.dgvPhaseCompetitors.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvPhaseCompetitors.Size = new System.Drawing.Size(442, 409);
            this.dgvPhaseCompetitors.Style = Sunny.UI.UIStyle.Custom;
            this.dgvPhaseCompetitors.TabIndex = 0;
            this.dgvPhaseCompetitors.TagString = null;
            // 
            // btnAdd
            // 
            this.btnAdd.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAdd.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnAdd.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnAdd.Location = new System.Drawing.Point(4, 187);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnAdd.Size = new System.Drawing.Size(50, 30);
            this.btnAdd.Style = Sunny.UI.UIStyle.Custom;
            this.btnAdd.Symbol = 61609;
            this.btnAdd.TabIndex = 3;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // btnDel
            // 
            this.btnDel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnDel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnDel.Location = new System.Drawing.Point(4, 246);
            this.btnDel.Name = "btnDel";
            this.btnDel.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnDel.Size = new System.Drawing.Size(50, 30);
            this.btnDel.Style = Sunny.UI.UIStyle.Custom;
            this.btnDel.Symbol = 61608;
            this.btnDel.TabIndex = 3;
            this.btnDel.Click += new System.EventHandler(this.btnDel_Click);
            // 
            // lbEventPlayers
            // 
            this.lbEventPlayers.AutoSize = true;
            this.lbEventPlayers.Dock = System.Windows.Forms.DockStyle.Top;
            this.lbEventPlayers.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbEventPlayers.Location = new System.Drawing.Point(0, 0);
            this.lbEventPlayers.Name = "lbEventPlayers";
            this.lbEventPlayers.Size = new System.Drawing.Size(136, 21);
            this.lbEventPlayers.Style = Sunny.UI.UIStyle.Custom;
            this.lbEventPlayers.TabIndex = 5;
            this.lbEventPlayers.Text = "Available Players";
            this.lbEventPlayers.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbPhasePlayers
            // 
            this.lbPhasePlayers.AutoSize = true;
            this.lbPhasePlayers.Dock = System.Windows.Forms.DockStyle.Top;
            this.lbPhasePlayers.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbPhasePlayers.Location = new System.Drawing.Point(0, 0);
            this.lbPhasePlayers.Name = "lbPhasePlayers";
            this.lbPhasePlayers.Size = new System.Drawing.Size(102, 21);
            this.lbPhasePlayers.Style = Sunny.UI.UIStyle.Custom;
            this.lbPhasePlayers.TabIndex = 5;
            this.lbPhasePlayers.Text = "Exist Players";
            this.lbPhasePlayers.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(0, 35);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.splitContainer3);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.splitContainer2);
            this.splitContainer1.Size = new System.Drawing.Size(936, 438);
            this.splitContainer1.SplitterDistance = 432;
            this.splitContainer1.TabIndex = 6;
            // 
            // splitContainer3
            // 
            this.splitContainer3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer3.Location = new System.Drawing.Point(0, 0);
            this.splitContainer3.Name = "splitContainer3";
            this.splitContainer3.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainer3.Panel1
            // 
            this.splitContainer3.Panel1.Controls.Add(this.lbEventPlayers);
            // 
            // splitContainer3.Panel2
            // 
            this.splitContainer3.Panel2.Controls.Add(this.dgvEventCompetitors);
            this.splitContainer3.Size = new System.Drawing.Size(432, 438);
            this.splitContainer3.SplitterDistance = 25;
            this.splitContainer3.TabIndex = 6;
            // 
            // splitContainer2
            // 
            this.splitContainer2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer2.Location = new System.Drawing.Point(0, 0);
            this.splitContainer2.Name = "splitContainer2";
            // 
            // splitContainer2.Panel1
            // 
            this.splitContainer2.Panel1.Controls.Add(this.btnAdd);
            this.splitContainer2.Panel1.Controls.Add(this.btnDel);
            // 
            // splitContainer2.Panel2
            // 
            this.splitContainer2.Panel2.Controls.Add(this.splitContainer4);
            this.splitContainer2.Size = new System.Drawing.Size(500, 438);
            this.splitContainer2.SplitterDistance = 54;
            this.splitContainer2.TabIndex = 0;
            // 
            // splitContainer4
            // 
            this.splitContainer4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer4.Location = new System.Drawing.Point(0, 0);
            this.splitContainer4.Name = "splitContainer4";
            this.splitContainer4.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainer4.Panel1
            // 
            this.splitContainer4.Panel1.Controls.Add(this.lbPhasePlayers);
            // 
            // splitContainer4.Panel2
            // 
            this.splitContainer4.Panel2.Controls.Add(this.dgvPhaseCompetitors);
            this.splitContainer4.Size = new System.Drawing.Size(442, 438);
            this.splitContainer4.SplitterDistance = 25;
            this.splitContainer4.TabIndex = 6;
            // 
            // frmChosePhaseCompetitors
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(936, 473);
            this.Controls.Add(this.splitContainer1);
            this.Name = "frmChosePhaseCompetitors";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "Choose Phase Competitors";
            this.Load += new System.EventHandler(this.frmChosePhaseCompetitors_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvEventCompetitors)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPhaseCompetitors)).EndInit();
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            this.splitContainer3.Panel1.ResumeLayout(false);
            this.splitContainer3.Panel1.PerformLayout();
            this.splitContainer3.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer3)).EndInit();
            this.splitContainer3.ResumeLayout(false);
            this.splitContainer2.Panel1.ResumeLayout(false);
            this.splitContainer2.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer2)).EndInit();
            this.splitContainer2.ResumeLayout(false);
            this.splitContainer4.Panel1.ResumeLayout(false);
            this.splitContainer4.Panel1.PerformLayout();
            this.splitContainer4.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer4)).EndInit();
            this.splitContainer4.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private UIDataGridView dgvEventCompetitors;
        private UIDataGridView dgvPhaseCompetitors;
        private UISymbolButton btnAdd;
        private UISymbolButton btnDel;
        private UILabel lbEventPlayers;
        private UILabel lbPhasePlayers;
        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.SplitContainer splitContainer2;
        private System.Windows.Forms.SplitContainer splitContainer3;
        private System.Windows.Forms.SplitContainer splitContainer4;
    }
}