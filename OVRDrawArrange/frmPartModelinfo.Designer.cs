using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    partial class PartModelInfoForm
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
            this.btnDelPartModel = new DevComponents.DotNetBar.ButtonX();
            this.lbModelList = new Sunny.UI.UILabel();
            this.dgvModels = new Sunny.UI.UIDataGridView();
            this.btnSavePartModel = new DevComponents.DotNetBar.ButtonX();
            this.TextModelComment = new Sunny.UI.UITextBox();
            this.lbModelComment = new Sunny.UI.UILabel();
            this.TextModelName = new Sunny.UI.UITextBox();
            this.lbModelName = new Sunny.UI.UILabel();
            this.btnRefresh = new DevComponents.DotNetBar.ButtonX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvModels)).BeginInit();
            this.SuspendLayout();
            // 
            // btnDelPartModel
            // 
            this.btnDelPartModel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDelPartModel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnDelPartModel.Image = global::Newauto.OVRDrawArrange.Properties.Resources.remove_24;
            this.btnDelPartModel.Location = new System.Drawing.Point(334, 71);
            this.btnDelPartModel.Name = "btnDelPartModel";
            this.btnDelPartModel.Size = new System.Drawing.Size(50, 30);
            this.btnDelPartModel.TabIndex = 42;
            this.btnDelPartModel.Click += new System.EventHandler(this.btnDelPartModel_Click);
            // 
            // lbModelList
            // 
            this.lbModelList.AutoSize = true;
            this.lbModelList.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbModelList.Location = new System.Drawing.Point(12, 82);
            this.lbModelList.Name = "lbModelList";
            this.lbModelList.Size = new System.Drawing.Size(93, 21);
            this.lbModelList.TabIndex = 46;
            this.lbModelList.Text = "Model List:";
            this.lbModelList.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
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
            this.dgvModels.Location = new System.Drawing.Point(12, 106);
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
            this.dgvModels.Size = new System.Drawing.Size(372, 210);
            this.dgvModels.TabIndex = 45;
            this.dgvModels.TagString = null;
            this.dgvModels.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvModels_CellValueChanged);
            this.dgvModels.SelectionChanged += new System.EventHandler(this.dgvModels_SelectionChanged);
            this.dgvModels.DoubleClick += new System.EventHandler(this.dgvModels_DoubleClick);
            // 
            // btnSavePartModel
            // 
            this.btnSavePartModel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnSavePartModel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnSavePartModel.Image = global::Newauto.OVRDrawArrange.Properties.Resources.Save_24;
            this.btnSavePartModel.Location = new System.Drawing.Point(278, 71);
            this.btnSavePartModel.Name = "btnSavePartModel";
            this.btnSavePartModel.Size = new System.Drawing.Size(50, 30);
            this.btnSavePartModel.TabIndex = 41;
            this.btnSavePartModel.Click += new System.EventHandler(this.btnSavePartModel_Click);
            // 
            // TextModelComment
            // 
            this.TextModelComment.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextModelComment.FillColor = System.Drawing.Color.White;
            this.TextModelComment.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextModelComment.Location = new System.Drawing.Point(94, 39);
            this.TextModelComment.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextModelComment.Maximum = 2147483647D;
            this.TextModelComment.Minimum = -2147483648D;
            this.TextModelComment.Name = "TextModelComment";
            this.TextModelComment.Padding = new System.Windows.Forms.Padding(5);
            this.TextModelComment.Size = new System.Drawing.Size(290, 29);
            this.TextModelComment.TabIndex = 40;
            // 
            // lbModelComment
            // 
            this.lbModelComment.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbModelComment.Location = new System.Drawing.Point(12, 39);
            this.lbModelComment.Name = "lbModelComment";
            this.lbModelComment.Size = new System.Drawing.Size(76, 21);
            this.lbModelComment.TabIndex = 44;
            this.lbModelComment.Text = "Comment:";
            this.lbModelComment.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // TextModelName
            // 
            this.TextModelName.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextModelName.FillColor = System.Drawing.Color.White;
            this.TextModelName.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.TextModelName.Location = new System.Drawing.Point(94, 35);
            this.TextModelName.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextModelName.Maximum = 2147483647D;
            this.TextModelName.Minimum = -2147483648D;
            this.TextModelName.Name = "TextModelName";
            this.TextModelName.Padding = new System.Windows.Forms.Padding(5);
            this.TextModelName.Size = new System.Drawing.Size(290, 29);
            this.TextModelName.TabIndex = 39;
            // 
            // lbModelName
            // 
            this.lbModelName.Font = new System.Drawing.Font("Î¢ÈíÑÅºÚ", 12F);
            this.lbModelName.Location = new System.Drawing.Point(12, 35);
            this.lbModelName.Name = "lbModelName";
            this.lbModelName.Size = new System.Drawing.Size(76, 21);
            this.lbModelName.TabIndex = 43;
            this.lbModelName.Text = "Model Name:";
            this.lbModelName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // btnRefresh
            // 
            this.btnRefresh.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRefresh.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnRefresh.Image = global::Newauto.OVRDrawArrange.Properties.Resources.Update_24;
            this.btnRefresh.Location = new System.Drawing.Point(222, 71);
            this.btnRefresh.Name = "btnRefresh";
            this.btnRefresh.Size = new System.Drawing.Size(50, 30);
            this.btnRefresh.TabIndex = 47;
            this.btnRefresh.Click += new System.EventHandler(this.btnRefresh_Click);
            // 
            // PartModelInfoForm
            // 
            this.ClientSize = new System.Drawing.Size(394, 324);
            this.Controls.Add(this.btnRefresh);
            this.Controls.Add(this.btnDelPartModel);
            this.Controls.Add(this.lbModelList);
            this.Controls.Add(this.dgvModels);
            this.Controls.Add(this.btnSavePartModel);
            this.Controls.Add(this.TextModelComment);
            this.Controls.Add(this.lbModelComment);
            this.Controls.Add(this.TextModelName);
            this.Controls.Add(this.lbModelName);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "PartModelInfoForm";
            this.Text = "frmPartModel";
            ((System.ComponentModel.ISupportInitialize)(this.dgvModels)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnDelPartModel;
        private UILabel lbModelList;
        private UIDataGridView dgvModels;
        private DevComponents.DotNetBar.ButtonX btnSavePartModel;
        private UITextBox TextModelComment;
        private UILabel lbModelComment;
        private UITextBox TextModelName;
        private UILabel lbModelName;
        private DevComponents.DotNetBar.ButtonX btnRefresh;
    }
}