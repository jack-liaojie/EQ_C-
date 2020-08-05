using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    partial class frmModelInfo
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
            this.TextModelComment = new Sunny.UI.UITextBox();
            this.lbModelComment = new Sunny.UI.UILabel();
            this.TextModelName = new Sunny.UI.UITextBox();
            this.lbModelName = new Sunny.UI.UILabel();
            this.dgvModels = new Sunny.UI.UIDataGridView();
            this.lbModelList = new Sunny.UI.UILabel();
            this.btnDelEventModel = new DevComponents.DotNetBar.ButtonX();
            this.btnSaveEventModel = new DevComponents.DotNetBar.ButtonX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvModels)).BeginInit();
            this.SuspendLayout();
            // 
            // TextModelComment
            // 
            this.TextModelComment.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextModelComment.FillColor = System.Drawing.Color.White;
            this.TextModelComment.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextModelComment.Location = new System.Drawing.Point(103, 37);
            this.TextModelComment.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextModelComment.Maximum = 2147483647D;
            this.TextModelComment.Minimum = -2147483648D;
            this.TextModelComment.Name = "TextModelComment";
            this.TextModelComment.Padding = new System.Windows.Forms.Padding(5);
            this.TextModelComment.Size = new System.Drawing.Size(342, 29);
            this.TextModelComment.TabIndex = 2;
            // 
            // lbModelComment
            // 
            this.lbModelComment.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbModelComment.Location = new System.Drawing.Point(2, 37);
            this.lbModelComment.Name = "lbModelComment";
            this.lbModelComment.Size = new System.Drawing.Size(125, 21);
            this.lbModelComment.TabIndex = 32;
            this.lbModelComment.Text = "Comment:";
            this.lbModelComment.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // TextModelName
            // 
            this.TextModelName.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextModelName.FillColor = System.Drawing.Color.White;
            this.TextModelName.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextModelName.Location = new System.Drawing.Point(103, 35);
            this.TextModelName.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextModelName.Maximum = 2147483647D;
            this.TextModelName.Minimum = -2147483648D;
            this.TextModelName.Name = "TextModelName";
            this.TextModelName.Padding = new System.Windows.Forms.Padding(5);
            this.TextModelName.Size = new System.Drawing.Size(342, 29);
            this.TextModelName.TabIndex = 1;
            // 
            // lbModelName
            // 
            this.lbModelName.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbModelName.Location = new System.Drawing.Point(2, 35);
            this.lbModelName.Name = "lbModelName";
            this.lbModelName.Size = new System.Drawing.Size(76, 21);
            this.lbModelName.TabIndex = 30;
            this.lbModelName.Text = "Model Name:";
            this.lbModelName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // dgvModels
            // 
            this.dgvModels.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvModels.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvModels.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvModels.BackgroundColor = System.Drawing.Color.White;
            this.dgvModels.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvModels.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvModels.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvModels.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvModels.DefaultCellStyle = dataGridViewCellStyle3;
            this.dgvModels.EnableHeadersVisualStyles = false;
            this.dgvModels.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.dgvModels.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvModels.Location = new System.Drawing.Point(2, 117);
            this.dgvModels.MultiSelect = false;
            this.dgvModels.Name = "dgvModels";
            this.dgvModels.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvModels.RowHeadersVisible = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.White;
            this.dgvModels.RowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvModels.RowTemplate.Height = 29;
            this.dgvModels.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvModels.SelectedIndex = -1;
            this.dgvModels.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvModels.Size = new System.Drawing.Size(443, 236);
            this.dgvModels.TabIndex = 37;
            this.dgvModels.TagString = null;
            this.dgvModels.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvModels_CellValueChanged);
            this.dgvModels.SelectionChanged += new System.EventHandler(this.dgvModels_SelectionChanged);
            this.dgvModels.DoubleClick += new System.EventHandler(this.dgvModels_DoubleClick);
            // 
            // lbModelList
            // 
            this.lbModelList.AutoSize = true;
            this.lbModelList.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbModelList.Location = new System.Drawing.Point(3, 81);
            this.lbModelList.Name = "lbModelList";
            this.lbModelList.Size = new System.Drawing.Size(93, 21);
            this.lbModelList.TabIndex = 38;
            this.lbModelList.Text = "Model List:";
            this.lbModelList.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // btnDelEventModel
            // 
            this.btnDelEventModel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDelEventModel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnDelEventModel.Image = global::Newauto.OVRDrawArrange.Properties.Resources.remove_24;
            this.btnDelEventModel.Location = new System.Drawing.Point(324, 82);
            this.btnDelEventModel.Name = "btnDelEventModel";
            this.btnDelEventModel.Size = new System.Drawing.Size(50, 30);
            this.btnDelEventModel.TabIndex = 4;
            this.btnDelEventModel.Click += new System.EventHandler(this.btnDelEventModel_Click);
            // 
            // btnSaveEventModel
            // 
            this.btnSaveEventModel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnSaveEventModel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnSaveEventModel.Image = global::Newauto.OVRDrawArrange.Properties.Resources.Save_24;
            this.btnSaveEventModel.Location = new System.Drawing.Point(268, 81);
            this.btnSaveEventModel.Name = "btnSaveEventModel";
            this.btnSaveEventModel.Size = new System.Drawing.Size(50, 30);
            this.btnSaveEventModel.TabIndex = 3;
            this.btnSaveEventModel.Click += new System.EventHandler(this.btnSaveEventModel_Click);
            // 
            // frmModelInfo
            // 
            this.ClientSize = new System.Drawing.Size(447, 354);
            this.Controls.Add(this.btnDelEventModel);
            this.Controls.Add(this.lbModelList);
            this.Controls.Add(this.dgvModels);
            this.Controls.Add(this.btnSaveEventModel);
            this.Controls.Add(this.TextModelComment);
            this.Controls.Add(this.lbModelComment);
            this.Controls.Add(this.TextModelName);
            this.Controls.Add(this.lbModelName);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmModelInfo";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "frmModelInfo";
            ((System.ComponentModel.ISupportInitialize)(this.dgvModels)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private UITextBox TextModelComment;
        private UILabel lbModelComment;
        private UITextBox TextModelName;
        private UILabel lbModelName;
        private DevComponents.DotNetBar.ButtonX btnSaveEventModel;
        private UIDataGridView dgvModels;
        private UILabel lbModelList;
        private DevComponents.DotNetBar.ButtonX btnDelEventModel;
    }
}