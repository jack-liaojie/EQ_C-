using Sunny.UI;

namespace AutoSports.OVRRegister
{
    partial class MemberEditForm
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle5 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MemberEditForm));
            this.dgvAllRegister = new Sunny.UI.UIDataGridView();
            this.cmbSex = new Sunny.UI.UIComboBox();
            this.lbSex = new Sunny.UI.UILabel();
            this.dgvMember = new Sunny.UI.UIDataGridView();
            this.btnAdd = new Sunny.UI.UISymbolButton();
            this.btnRemove = new Sunny.UI.UISymbolButton();
            this.lbTeamName = new Sunny.UI.UILabel();
            this.cmbGroup = new Sunny.UI.UIComboBox();
            this.lbGroup = new Sunny.UI.UILabel();
            ((System.ComponentModel.ISupportInitialize)(this.dgvAllRegister)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMember)).BeginInit();
            this.cmbGroup.SuspendLayout();
            this.SuspendLayout();
            // 
            // dgvAllRegister
            // 
            this.dgvAllRegister.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvAllRegister.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvAllRegister.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvAllRegister.BackgroundColor = System.Drawing.Color.White;
            this.dgvAllRegister.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvAllRegister.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvAllRegister.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvAllRegister.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvAllRegister.EnableHeadersVisualStyles = false;
            this.dgvAllRegister.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvAllRegister.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvAllRegister.Location = new System.Drawing.Point(2, 68);
            this.dgvAllRegister.Name = "dgvAllRegister";
            this.dgvAllRegister.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvAllRegister.RowHeadersVisible = false;
            dataGridViewCellStyle3.BackColor = System.Drawing.Color.White;
            this.dgvAllRegister.RowsDefaultCellStyle = dataGridViewCellStyle3;
            this.dgvAllRegister.RowTemplate.Height = 29;
            this.dgvAllRegister.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvAllRegister.SelectedIndex = -1;
            this.dgvAllRegister.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvAllRegister.Size = new System.Drawing.Size(340, 397);
            this.dgvAllRegister.Style = Sunny.UI.UIStyle.Custom;
            this.dgvAllRegister.TabIndex = 0;
            this.dgvAllRegister.TagString = null;
            // 
            // cmbSex
            // 
            this.cmbSex.DisplayMember = "Text";
            this.cmbSex.FillColor = System.Drawing.Color.White;
            this.cmbSex.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cmbSex.FormattingEnabled = true;
            this.cmbSex.ItemHeight = 15;
            this.cmbSex.Location = new System.Drawing.Point(0, 0);
            this.cmbSex.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cmbSex.MinimumSize = new System.Drawing.Size(63, 0);
            this.cmbSex.Name = "cmbSex";
            this.cmbSex.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cmbSex.Size = new System.Drawing.Size(229, 29);
            this.cmbSex.Style = Sunny.UI.UIStyle.Custom;
            this.cmbSex.TabIndex = 1;
            this.cmbSex.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            this.cmbSex.SelectedValueChanged += new System.EventHandler(this.cmbSex_SelectionChangeCommitted);
            // 
            // lbSex
            // 
            this.lbSex.AutoSize = true;
            this.lbSex.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbSex.Location = new System.Drawing.Point(2, 35);
            this.lbSex.Name = "lbSex";
            this.lbSex.Size = new System.Drawing.Size(42, 21);
            this.lbSex.Style = Sunny.UI.UIStyle.Custom;
            this.lbSex.TabIndex = 0;
            this.lbSex.Text = "性别";
            this.lbSex.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // dgvMember
            // 
            this.dgvMember.AllowUserToAddRows = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvMember.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvMember.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvMember.BackgroundColor = System.Drawing.Color.White;
            this.dgvMember.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvMember.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle5.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle5.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle5.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle5.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle5.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle5.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle5.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvMember.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle5;
            this.dgvMember.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMember.EnableHeadersVisualStyles = false;
            this.dgvMember.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvMember.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMember.Location = new System.Drawing.Point(401, 35);
            this.dgvMember.Name = "dgvMember";
            this.dgvMember.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvMember.RowHeadersVisible = false;
            dataGridViewCellStyle6.BackColor = System.Drawing.Color.White;
            this.dgvMember.RowsDefaultCellStyle = dataGridViewCellStyle6;
            this.dgvMember.RowTemplate.Height = 29;
            this.dgvMember.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvMember.SelectedIndex = -1;
            this.dgvMember.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvMember.Size = new System.Drawing.Size(379, 435);
            this.dgvMember.Style = Sunny.UI.UIStyle.Custom;
            this.dgvMember.TabIndex = 0;
            this.dgvMember.TagString = null;
            this.dgvMember.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvMember_CellBeginEdit);
            this.dgvMember.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMember_CellValueChanged);
            // 
            // btnAdd
            // 
            this.btnAdd.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAdd.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnAdd.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnAdd.Location = new System.Drawing.Point(345, 154);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnAdd.Size = new System.Drawing.Size(50, 30);
            this.btnAdd.Style = Sunny.UI.UIStyle.Custom;
            this.btnAdd.Symbol = 61609;
            this.btnAdd.TabIndex = 3;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // btnRemove
            // 
            this.btnRemove.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRemove.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnRemove.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnRemove.Location = new System.Drawing.Point(345, 202);
            this.btnRemove.Name = "btnRemove";
            this.btnRemove.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnRemove.Size = new System.Drawing.Size(50, 30);
            this.btnRemove.Style = Sunny.UI.UIStyle.Custom;
            this.btnRemove.Symbol = 61608;
            this.btnRemove.TabIndex = 3;
            this.btnRemove.Click += new System.EventHandler(this.btnRemove_Click);
            // 
            // lbTeamName
            // 
            this.lbTeamName.AutoSize = true;
            this.lbTeamName.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbTeamName.Location = new System.Drawing.Point(3, 35);
            this.lbTeamName.Name = "lbTeamName";
            this.lbTeamName.Size = new System.Drawing.Size(103, 21);
            this.lbTeamName.Style = Sunny.UI.UIStyle.Custom;
            this.lbTeamName.TabIndex = 4;
            this.lbTeamName.Text = "Team Name";
            this.lbTeamName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // cmbGroup
            // 
            this.cmbGroup.Controls.Add(this.cmbSex);
            this.cmbGroup.DisplayMember = "Text";
            this.cmbGroup.FillColor = System.Drawing.Color.White;
            this.cmbGroup.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cmbGroup.FormattingEnabled = true;
            this.cmbGroup.ItemHeight = 21;
            this.cmbGroup.Location = new System.Drawing.Point(113, 35);
            this.cmbGroup.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cmbGroup.MinimumSize = new System.Drawing.Size(63, 0);
            this.cmbGroup.Name = "cmbGroup";
            this.cmbGroup.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cmbGroup.Size = new System.Drawing.Size(229, 29);
            this.cmbGroup.Style = Sunny.UI.UIStyle.Custom;
            this.cmbGroup.TabIndex = 6;
            this.cmbGroup.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            this.cmbGroup.SelectedValueChanged += new System.EventHandler(this.cmbGroup_SelectionChangeCommitted);
            // 
            // lbGroup
            // 
            this.lbGroup.AutoSize = true;
            this.lbGroup.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbGroup.Location = new System.Drawing.Point(3, 35);
            this.lbGroup.Name = "lbGroup";
            this.lbGroup.Size = new System.Drawing.Size(58, 21);
            this.lbGroup.Style = Sunny.UI.UIStyle.Custom;
            this.lbGroup.TabIndex = 5;
            this.lbGroup.Text = "代表团";
            this.lbGroup.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // MemberEditForm
            // 
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(781, 466);
            this.Controls.Add(this.cmbGroup);
            this.Controls.Add(this.lbGroup);
            this.Controls.Add(this.dgvMember);
            this.Controls.Add(this.dgvAllRegister);
            this.Controls.Add(this.lbTeamName);
            this.Controls.Add(this.lbSex);
            this.Controls.Add(this.btnRemove);
            this.Controls.Add(this.btnAdd);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "MemberEditForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "Edit Member";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.MemberEditForm_FormClosed);
            this.Load += new System.EventHandler(this.frmMemberEdit_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvAllRegister)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMember)).EndInit();
            this.cmbGroup.ResumeLayout(false);
            this.cmbGroup.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private UILabel lbSex;
        private UIDataGridView dgvAllRegister;
        private UIComboBox cmbSex;
        private UIDataGridView dgvMember;
        private UISymbolButton btnAdd;
        private UISymbolButton btnRemove;
        private UILabel lbTeamName;
        private UILabel lbGroup;
        private UIComboBox cmbGroup;
    }
}