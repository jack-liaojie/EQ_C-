using Sunny.UI;

namespace AutoSports.OVRRegister
{
    partial class OVRRegisterDisplayForm
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
            this.cmbFederation = new System.Windows.Forms.ComboBox();
            this.lbFederation = new Sunny.UI.UILabel();
            this.cmbRegType = new System.Windows.Forms.ComboBox();
            this.lbRegType = new Sunny.UI.UILabel();
            this.lbEvent = new Sunny.UI.UILabel();
            this.cmbSex = new System.Windows.Forms.ComboBox();
            this.lbSex = new Sunny.UI.UILabel();
            this.dgvRegister = new Sunny.UI.UIDataGridView();
            this.cmbEvent = new System.Windows.Forms.ComboBox();
            ((System.ComponentModel.ISupportInitialize)(this.dgvRegister)).BeginInit();
            this.SuspendLayout();
            // 
            // cmbFederation
            // 
            this.cmbFederation.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbFederation.FormattingEnabled = true;
            this.cmbFederation.Location = new System.Drawing.Point(695, 35);
            this.cmbFederation.Name = "cmbFederation";
            this.cmbFederation.Size = new System.Drawing.Size(124, 29);
            this.cmbFederation.TabIndex = 0;
            this.cmbFederation.SelectionChangeCommitted += new System.EventHandler(this.cmbFederation_SelectionChangeCommitted);
            // 
            // lbFederation
            // 
            this.lbFederation.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbFederation.Location = new System.Drawing.Point(603, 35);
            this.lbFederation.Name = "lbFederation";
            this.lbFederation.Size = new System.Drawing.Size(87, 20);
            this.lbFederation.Style = Sunny.UI.UIStyle.Custom;
            this.lbFederation.TabIndex = 0;
            this.lbFederation.Text = "Nationality:";
            this.lbFederation.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // cmbRegType
            // 
            this.cmbRegType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbRegType.FormattingEnabled = true;
            this.cmbRegType.Location = new System.Drawing.Point(462, 35);
            this.cmbRegType.Name = "cmbRegType";
            this.cmbRegType.Size = new System.Drawing.Size(124, 29);
            this.cmbRegType.TabIndex = 0;
            this.cmbRegType.SelectionChangeCommitted += new System.EventHandler(this.cmbRegType_SelectionChangeCommitted);
            // 
            // lbRegType
            // 
            this.lbRegType.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbRegType.Location = new System.Drawing.Point(383, 35);
            this.lbRegType.Name = "lbRegType";
            this.lbRegType.Size = new System.Drawing.Size(78, 20);
            this.lbRegType.Style = Sunny.UI.UIStyle.Custom;
            this.lbRegType.TabIndex = 0;
            this.lbRegType.Text = "RegType";
            this.lbRegType.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbEvent
            // 
            this.lbEvent.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbEvent.Location = new System.Drawing.Point(187, 35);
            this.lbEvent.Name = "lbEvent";
            this.lbEvent.Size = new System.Drawing.Size(63, 20);
            this.lbEvent.Style = Sunny.UI.UIStyle.Custom;
            this.lbEvent.TabIndex = 0;
            this.lbEvent.Text = "Event";
            this.lbEvent.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // cmbSex
            // 
            this.cmbSex.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbSex.FormattingEnabled = true;
            this.cmbSex.Location = new System.Drawing.Point(55, 35);
            this.cmbSex.Name = "cmbSex";
            this.cmbSex.Size = new System.Drawing.Size(124, 29);
            this.cmbSex.TabIndex = 0;
            this.cmbSex.SelectionChangeCommitted += new System.EventHandler(this.cmbSex_SelectionChangeCommitted);
            // 
            // lbSex
            // 
            this.lbSex.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbSex.Location = new System.Drawing.Point(5, 35);
            this.lbSex.Name = "lbSex";
            this.lbSex.Size = new System.Drawing.Size(46, 20);
            this.lbSex.Style = Sunny.UI.UIStyle.Custom;
            this.lbSex.TabIndex = 0;
            this.lbSex.Text = "Sex";
            this.lbSex.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // dgvRegister
            // 
            this.dgvRegister.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvRegister.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvRegister.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvRegister.BackgroundColor = System.Drawing.Color.White;
            this.dgvRegister.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvRegister.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvRegister.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvRegister.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvRegister.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvRegister.EnableHeadersVisualStyles = false;
            this.dgvRegister.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvRegister.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvRegister.Location = new System.Drawing.Point(0, 30);
            this.dgvRegister.Name = "dgvRegister";
            this.dgvRegister.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvRegister.RowHeadersVisible = false;
            dataGridViewCellStyle3.BackColor = System.Drawing.Color.White;
            this.dgvRegister.RowsDefaultCellStyle = dataGridViewCellStyle3;
            this.dgvRegister.RowTemplate.Height = 29;
            this.dgvRegister.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvRegister.SelectedIndex = -1;
            this.dgvRegister.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvRegister.Size = new System.Drawing.Size(833, 463);
            this.dgvRegister.Style = Sunny.UI.UIStyle.Custom;
            this.dgvRegister.TabIndex = 0;
            this.dgvRegister.TagString = null;
            this.dgvRegister.CellDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvRegister_CellDoubleClick);
            // 
            // cmbEvent
            // 
            this.cmbEvent.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbEvent.FormattingEnabled = true;
            this.cmbEvent.Location = new System.Drawing.Point(256, 35);
            this.cmbEvent.Name = "cmbEvent";
            this.cmbEvent.Size = new System.Drawing.Size(121, 29);
            this.cmbEvent.TabIndex = 0;
            this.cmbEvent.SelectionChangeCommitted += new System.EventHandler(this.cmbEvent_SelectionChangeCommitted);
            // 
            // OVRRegisterDisplayForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(833, 493);
            this.Controls.Add(this.dgvRegister);
            this.Controls.Add(this.cmbFederation);
            this.Controls.Add(this.lbEvent);
            this.Controls.Add(this.lbFederation);
            this.Controls.Add(this.lbRegType);
            this.Controls.Add(this.cmbSex);
            this.Controls.Add(this.cmbEvent);
            this.Controls.Add(this.cmbRegType);
            this.Controls.Add(this.lbSex);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRRegisterDisplayForm";
            this.Padding = new System.Windows.Forms.Padding(0, 30, 0, 0);
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "RegisterDisplay";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.OVRRegisterDisplayForm_FormClosing);
            this.Load += new System.EventHandler(this.OVRRegisterDisplayForm_VisibleChanged);
            this.VisibleChanged += new System.EventHandler(this.OVRRegisterDisplayForm_VisibleChanged);
            ((System.ComponentModel.ISupportInitialize)(this.dgvRegister)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ComboBox cmbFederation;
        private UILabel lbFederation;
        private System.Windows.Forms.ComboBox cmbRegType;
        private UILabel lbRegType;
        private UILabel lbEvent;
        private System.Windows.Forms.ComboBox cmbSex;
        private UILabel lbSex;
        private UIDataGridView dgvRegister;
        private System.Windows.Forms.ComboBox cmbEvent;
    }
}