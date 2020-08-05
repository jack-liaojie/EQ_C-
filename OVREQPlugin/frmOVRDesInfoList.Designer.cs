using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    partial class OVRDesInfoListForm
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
            this.lbLanguage = new Sunny.UI.UILabel();
            this.cmbLanguage = new Sunny.UI.UIComboBox();
            this.dgvInfo = new Sunny.UI.UIDataGridView();
            this.btnDel = new Sunny.UI.UISymbolButton();
            this.btnEdit = new Sunny.UI.UISymbolButton();
            this.btnAdd = new Sunny.UI.UISymbolButton();
            ((System.ComponentModel.ISupportInitialize)(this.dgvInfo)).BeginInit();
            this.SuspendLayout();
            // 
            // lbLanguage
            // 
            this.lbLanguage.AutoSize = true;
            this.lbLanguage.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbLanguage.Location = new System.Drawing.Point(4, 279);
            this.lbLanguage.Name = "lbLanguage";
            this.lbLanguage.Size = new System.Drawing.Size(85, 21);
            this.lbLanguage.Style = Sunny.UI.UIStyle.Custom;
            this.lbLanguage.TabIndex = 0;
            this.lbLanguage.Text = "Language";
            this.lbLanguage.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // cmbLanguage
            // 
            this.cmbLanguage.FillColor = System.Drawing.Color.White;
            this.cmbLanguage.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cmbLanguage.FormattingEnabled = true;
            this.cmbLanguage.Location = new System.Drawing.Point(117, 275);
            this.cmbLanguage.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cmbLanguage.MinimumSize = new System.Drawing.Size(63, 0);
            this.cmbLanguage.Name = "cmbLanguage";
            this.cmbLanguage.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cmbLanguage.Size = new System.Drawing.Size(119, 29);
            this.cmbLanguage.Style = Sunny.UI.UIStyle.Custom;
            this.cmbLanguage.TabIndex = 1;
            this.cmbLanguage.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            this.cmbLanguage.SelectedValueChanged += new System.EventHandler(this.cmbLanguage_SelectionChangeCommitted);
            // 
            // dgvInfo
            // 
            this.dgvInfo.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvInfo.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvInfo.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvInfo.BackgroundColor = System.Drawing.Color.White;
            this.dgvInfo.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvInfo.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvInfo.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvInfo.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvInfo.Dock = System.Windows.Forms.DockStyle.Top;
            this.dgvInfo.EnableHeadersVisualStyles = false;
            this.dgvInfo.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvInfo.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvInfo.Location = new System.Drawing.Point(2, 2);
            this.dgvInfo.MultiSelect = false;
            this.dgvInfo.Name = "dgvInfo";
            this.dgvInfo.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvInfo.RowHeadersVisible = false;
            dataGridViewCellStyle3.BackColor = System.Drawing.Color.White;
            this.dgvInfo.RowsDefaultCellStyle = dataGridViewCellStyle3;
            this.dgvInfo.RowTemplate.Height = 29;
            this.dgvInfo.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvInfo.SelectedIndex = -1;
            this.dgvInfo.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvInfo.Size = new System.Drawing.Size(672, 266);
            this.dgvInfo.Style = Sunny.UI.UIStyle.Custom;
            this.dgvInfo.TabIndex = 0;
            this.dgvInfo.TagString = null;
            // 
            // btnDel
            // 
            this.btnDel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnDel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnDel.Location = new System.Drawing.Point(321, 279);
            this.btnDel.Name = "btnDel";
            this.btnDel.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnDel.Size = new System.Drawing.Size(29, 20);
            this.btnDel.Style = Sunny.UI.UIStyle.Custom;
            this.btnDel.Symbol = 61508;
            this.btnDel.TabIndex = 3;
            this.btnDel.Click += new System.EventHandler(this.btnDel_Click);
            // 
            // btnEdit
            // 
            this.btnEdit.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnEdit.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnEdit.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnEdit.Location = new System.Drawing.Point(378, 279);
            this.btnEdit.Name = "btnEdit";
            this.btnEdit.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnEdit.Size = new System.Drawing.Size(29, 20);
            this.btnEdit.Style = Sunny.UI.UIStyle.Custom;
            this.btnEdit.Symbol = 61544;
            this.btnEdit.TabIndex = 3;
            this.btnEdit.Click += new System.EventHandler(this.btnEdit_Click);
            // 
            // btnAdd
            // 
            this.btnAdd.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAdd.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnAdd.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnAdd.Location = new System.Drawing.Point(264, 279);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnAdd.Size = new System.Drawing.Size(29, 20);
            this.btnAdd.Style = Sunny.UI.UIStyle.Custom;
            this.btnAdd.Symbol = 61543;
            this.btnAdd.TabIndex = 3;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // OVRDesInfoListForm
            // 
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(676, 316);
            this.Controls.Add(this.dgvInfo);
            this.Controls.Add(this.btnEdit);
            this.Controls.Add(this.btnDel);
            this.Controls.Add(this.btnAdd);
            this.Controls.Add(this.cmbLanguage);
            this.Controls.Add(this.lbLanguage);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRDesInfoListForm";
            this.Padding = new System.Windows.Forms.Padding(2, 2, 2, 30);
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "EditInfo";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.OVRDesInfoListForm_FormClosed);
            this.Load += new System.EventHandler(this.OVRDesInfoListForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvInfo)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private UILabel lbLanguage;
        private UIComboBox cmbLanguage;
        private UISymbolButton btnAdd;
        private UISymbolButton btnDel;
        private UISymbolButton btnEdit;
        private UIDataGridView dgvInfo;
    }
}