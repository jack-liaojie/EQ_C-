using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    partial class SetPartModelForm
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
            this.btnLoadModel = new DevComponents.DotNetBar.ButtonX();
            this.lbModelList = new UILabel();
            this.dgvModels = new UIDataGridView();
            this.btnCancle = new DevComponents.DotNetBar.ButtonX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvModels)).BeginInit();
            this.SuspendLayout();
            // 
            // btnLoadModel
            // 
            this.btnLoadModel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnLoadModel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnLoadModel.Image = global::Newauto.OVRDrawArrange.Properties.Resources.ok_24;
            this.btnLoadModel.Location = new System.Drawing.Point(255, 241);
            this.btnLoadModel.Name = "btnLoadModel";
            this.btnLoadModel.Size = new System.Drawing.Size(50, 30);
            this.btnLoadModel.TabIndex = 50;
            this.btnLoadModel.Click += new System.EventHandler(this.btnLoadModel_Click);
            // 
            // lbModelList
            // 
            this.lbModelList.AutoSize = true;
            this.lbModelList.Location = new System.Drawing.Point(3, 6);
            this.lbModelList.Name = "lbModelList";
            this.lbModelList.Size = new System.Drawing.Size(75, 16);
            this.lbModelList.TabIndex = 49;
            this.lbModelList.Text = "Model List:";
            // 
            // dgvModels
            // 
            this.dgvModels.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvModels.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvModels.Location = new System.Drawing.Point(3, 25);
            this.dgvModels.MultiSelect = false;
            this.dgvModels.Name = "dgvModels";
            this.dgvModels.RowTemplate.Height = 23;
            this.dgvModels.Size = new System.Drawing.Size(372, 210);
            this.dgvModels.TabIndex = 48;
            // 
            // btnCancle
            // 
            this.btnCancle.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancle.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnCancle.Image = global::Newauto.OVRDrawArrange.Properties.Resources.cancel_24;
            this.btnCancle.Location = new System.Drawing.Point(325, 241);
            this.btnCancle.Name = "btnCancle";
            this.btnCancle.Size = new System.Drawing.Size(50, 30);
            this.btnCancle.TabIndex = 51;
            this.btnCancle.Click += new System.EventHandler(this.btnCancle_Click);
            // 
            // SetPartModelForm
            // 
            this.ClientSize = new System.Drawing.Size(380, 276);
            this.Controls.Add(this.btnCancle);
            this.Controls.Add(this.btnLoadModel);
            this.Controls.Add(this.lbModelList);
            this.Controls.Add(this.dgvModels);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "SetPartModelForm";
            this.Text = "frmSetPartModel";
            ((System.ComponentModel.ISupportInitialize)(this.dgvModels)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnLoadModel;
        private UILabel lbModelList;
        private UIDataGridView dgvModels;
        private DevComponents.DotNetBar.ButtonX btnCancle;
    }
}