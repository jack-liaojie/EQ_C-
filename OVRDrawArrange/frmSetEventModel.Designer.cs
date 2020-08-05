using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    partial class SetEventModelForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        #region Windows Form Designer generated code


        private void InitializeComponent()
        {
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            this.btnCancle = new DevComponents.DotNetBar.ButtonX();
            this.btnOK = new DevComponents.DotNetBar.ButtonX();
            this.RadioByParameter = new System.Windows.Forms.RadioButton();
            this.RadioFromModel = new System.Windows.Forms.RadioButton();
            this.lbModelList = new Sunny.UI.UILabel();
            this.dgvModels = new Sunny.UI.UIDataGridView();
            this.btnDelEventModel = new DevComponents.DotNetBar.ButtonX();
            this.btnExportEventModel = new DevComponents.DotNetBar.ButtonX();
            this.btnImportEventModel = new DevComponents.DotNetBar.ButtonX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvModels)).BeginInit();
            this.SuspendLayout();
            // 
            // btnCancle
            // 
            this.btnCancle.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancle.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnCancle.Image = global::Newauto.OVRDrawArrange.Properties.Resources.cancel_24;
            this.btnCancle.Location = new System.Drawing.Point(550, 45);
            this.btnCancle.Name = "btnCancle";
            this.btnCancle.Size = new System.Drawing.Size(50, 30);
            this.btnCancle.TabIndex = 3;
            this.btnCancle.Click += new System.EventHandler(this.btnCancle_Click);
            // 
            // btnOK
            // 
            this.btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOK.Image = global::Newauto.OVRDrawArrange.Properties.Resources.ok_24;
            this.btnOK.Location = new System.Drawing.Point(480, 45);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(50, 30);
            this.btnOK.TabIndex = 2;
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // RadioByParameter
            // 
            this.RadioByParameter.AutoSize = true;
            this.RadioByParameter.Location = new System.Drawing.Point(329, 48);
            this.RadioByParameter.Name = "RadioByParameter";
            this.RadioByParameter.Size = new System.Drawing.Size(140, 25);
            this.RadioByParameter.TabIndex = 4;
            this.RadioByParameter.TabStop = true;
            this.RadioByParameter.Text = "参数化创建模型";
            this.RadioByParameter.UseVisualStyleBackColor = true;
            this.RadioByParameter.CheckedChanged += new System.EventHandler(this.RadioByParameter_CheckedChanged);
            // 
            // RadioFromModel
            // 
            this.RadioFromModel.AutoSize = true;
            this.RadioFromModel.Location = new System.Drawing.Point(3, 48);
            this.RadioFromModel.Name = "RadioFromModel";
            this.RadioFromModel.Size = new System.Drawing.Size(140, 25);
            this.RadioFromModel.TabIndex = 5;
            this.RadioFromModel.TabStop = true;
            this.RadioFromModel.Text = "使用自定义模型";
            this.RadioFromModel.UseVisualStyleBackColor = true;
            this.RadioFromModel.CheckedChanged += new System.EventHandler(this.RadioFromModel_CheckedChanged);
            // 
            // lbModelList
            // 
            this.lbModelList.AutoSize = true;
            this.lbModelList.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbModelList.Location = new System.Drawing.Point(3, 85);
            this.lbModelList.Name = "lbModelList";
            this.lbModelList.Size = new System.Drawing.Size(93, 21);
            this.lbModelList.TabIndex = 40;
            this.lbModelList.Text = "Model List:";
            this.lbModelList.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // dgvModels
            // 
            this.dgvModels.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvModels.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvModels.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvModels.BackgroundColor = System.Drawing.Color.White;
            this.dgvModels.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvModels.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvModels.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvModels.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvModels.DefaultCellStyle = dataGridViewCellStyle3;
            this.dgvModels.EnableHeadersVisualStyles = false;
            this.dgvModels.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvModels.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvModels.Location = new System.Drawing.Point(2, 109);
            this.dgvModels.Name = "dgvModels";
            this.dgvModels.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvModels.RowHeadersVisible = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.White;
            this.dgvModels.RowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvModels.RowTemplate.Height = 29;
            this.dgvModels.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvModels.SelectedIndex = -1;
            this.dgvModels.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvModels.Size = new System.Drawing.Size(602, 224);
            this.dgvModels.TabIndex = 39;
            this.dgvModels.TagString = null;
            // 
            // btnDelEventModel
            // 
            this.btnDelEventModel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDelEventModel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnDelEventModel.Image = global::Newauto.OVRDrawArrange.Properties.Resources.remove_24;
            this.btnDelEventModel.Location = new System.Drawing.Point(250, 45);
            this.btnDelEventModel.Name = "btnDelEventModel";
            this.btnDelEventModel.Size = new System.Drawing.Size(50, 30);
            this.btnDelEventModel.TabIndex = 43;
            this.btnDelEventModel.Click += new System.EventHandler(this.btnDelEventModel_Click);
            // 
            // btnExportEventModel
            // 
            this.btnExportEventModel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnExportEventModel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnExportEventModel.Image = global::Newauto.OVRDrawArrange.Properties.Resources.Export_24;
            this.btnExportEventModel.Location = new System.Drawing.Point(195, 45);
            this.btnExportEventModel.Name = "btnExportEventModel";
            this.btnExportEventModel.Size = new System.Drawing.Size(50, 30);
            this.btnExportEventModel.TabIndex = 42;
            this.btnExportEventModel.Click += new System.EventHandler(this.btnExportEventModel_Click);
            // 
            // btnImportEventModel
            // 
            this.btnImportEventModel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnImportEventModel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnImportEventModel.Image = global::Newauto.OVRDrawArrange.Properties.Resources.Load_24;
            this.btnImportEventModel.Location = new System.Drawing.Point(140, 45);
            this.btnImportEventModel.Name = "btnImportEventModel";
            this.btnImportEventModel.Size = new System.Drawing.Size(50, 30);
            this.btnImportEventModel.TabIndex = 41;
            this.btnImportEventModel.Click += new System.EventHandler(this.btnImportEventModel_Click);
            // 
            // SetEventModelForm
            // 
            this.ClientSize = new System.Drawing.Size(607, 336);
            this.Controls.Add(this.btnDelEventModel);
            this.Controls.Add(this.btnExportEventModel);
            this.Controls.Add(this.btnImportEventModel);
            this.Controls.Add(this.lbModelList);
            this.Controls.Add(this.dgvModels);
            this.Controls.Add(this.RadioFromModel);
            this.Controls.Add(this.RadioByParameter);
            this.Controls.Add(this.btnCancle);
            this.Controls.Add(this.btnOK);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "SetEventModelForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "frmSetEventModel";
            ((System.ComponentModel.ISupportInitialize)(this.dgvModels)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnCancle;
        private DevComponents.DotNetBar.ButtonX btnOK;
        private System.Windows.Forms.RadioButton RadioByParameter;
        private System.Windows.Forms.RadioButton RadioFromModel;
        private UILabel lbModelList;
        private UIDataGridView dgvModels;
        private DevComponents.DotNetBar.ButtonX btnExportEventModel;
        private DevComponents.DotNetBar.ButtonX btnImportEventModel;
        private DevComponents.DotNetBar.ButtonX btnDelEventModel;
    }
}