namespace OVRDVPlugin
{
    partial class FixedDiveInfoForm
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
            this.btnCancle = new DevComponents.DotNetBar.ButtonX();
            this.btnOK = new DevComponents.DotNetBar.ButtonX();
            this.dgvAvailableDiveSplits = new System.Windows.Forms.DataGridView();
            this.dgvFixedDiveSplits = new System.Windows.Forms.DataGridView();
            this.btnAddOneFixedDiveSplit = new DevComponents.DotNetBar.ButtonX();
            this.btnDelOneFixedDiveSplit = new DevComponents.DotNetBar.ButtonX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvAvailableDiveSplits)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvFixedDiveSplits)).BeginInit();
            this.SuspendLayout();
            // 
            // btnCancle
            // 
            this.btnCancle.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancle.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnCancle.Location = new System.Drawing.Point(609, 384);
            this.btnCancle.Name = "btnCancle";
            this.btnCancle.Size = new System.Drawing.Size(50, 30);
            this.btnCancle.TabIndex = 18;
            this.btnCancle.Text = "Cancle";
            this.btnCancle.Click += new System.EventHandler(this.btnCancle_Click);
            // 
            // btnOK
            // 
            this.btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOK.Location = new System.Drawing.Point(548, 384);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(50, 30);
            this.btnOK.TabIndex = 17;
            this.btnOK.Text = "OK";
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // dgvAvailableDiveSplits
            // 
            this.dgvAvailableDiveSplits.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvAvailableDiveSplits.Location = new System.Drawing.Point(12, 12);
            this.dgvAvailableDiveSplits.Name = "dgvAvailableDiveSplits";
            this.dgvAvailableDiveSplits.RowTemplate.Height = 23;
            this.dgvAvailableDiveSplits.Size = new System.Drawing.Size(222, 367);
            this.dgvAvailableDiveSplits.TabIndex = 19;
            // 
            // dgvFixedDiveSplits
            // 
            this.dgvFixedDiveSplits.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvFixedDiveSplits.Location = new System.Drawing.Point(318, 12);
            this.dgvFixedDiveSplits.Name = "dgvFixedDiveSplits";
            this.dgvFixedDiveSplits.RowTemplate.Height = 23;
            this.dgvFixedDiveSplits.Size = new System.Drawing.Size(345, 366);
            this.dgvFixedDiveSplits.TabIndex = 20;
            this.dgvFixedDiveSplits.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvFixedDiveSplits_CellValueChanged);
            // 
            // btnAddOneFixedDiveSplit
            // 
            this.btnAddOneFixedDiveSplit.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAddOneFixedDiveSplit.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnAddOneFixedDiveSplit.Location = new System.Drawing.Point(240, 93);
            this.btnAddOneFixedDiveSplit.Name = "btnAddOneFixedDiveSplit";
            this.btnAddOneFixedDiveSplit.Size = new System.Drawing.Size(72, 30);
            this.btnAddOneFixedDiveSplit.TabIndex = 21;
            this.btnAddOneFixedDiveSplit.Text = ">>";
            this.btnAddOneFixedDiveSplit.Click += new System.EventHandler(this.btnAddOneFixedDiveSplit_Click);
            // 
            // btnDelOneFixedDiveSplit
            // 
            this.btnDelOneFixedDiveSplit.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDelOneFixedDiveSplit.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnDelOneFixedDiveSplit.Location = new System.Drawing.Point(240, 176);
            this.btnDelOneFixedDiveSplit.Name = "btnDelOneFixedDiveSplit";
            this.btnDelOneFixedDiveSplit.Size = new System.Drawing.Size(72, 30);
            this.btnDelOneFixedDiveSplit.TabIndex = 22;
            this.btnDelOneFixedDiveSplit.Text = "<<";
            this.btnDelOneFixedDiveSplit.Click += new System.EventHandler(this.btnDelOneFixedDiveSplit_Click);
            // 
            // FixedDiveInfoForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(675, 422);
            this.Controls.Add(this.btnDelOneFixedDiveSplit);
            this.Controls.Add(this.btnAddOneFixedDiveSplit);
            this.Controls.Add(this.dgvFixedDiveSplits);
            this.Controls.Add(this.dgvAvailableDiveSplits);
            this.Controls.Add(this.btnCancle);
            this.Controls.Add(this.btnOK);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "FixedDiveInfoForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmFixedDiveInfo";
            ((System.ComponentModel.ISupportInitialize)(this.dgvAvailableDiveSplits)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvFixedDiveSplits)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnCancle;
        private DevComponents.DotNetBar.ButtonX btnOK;
        private System.Windows.Forms.DataGridView dgvAvailableDiveSplits;
        private System.Windows.Forms.DataGridView dgvFixedDiveSplits;
        private DevComponents.DotNetBar.ButtonX btnAddOneFixedDiveSplit;
        private DevComponents.DotNetBar.ButtonX btnDelOneFixedDiveSplit;
    }
}