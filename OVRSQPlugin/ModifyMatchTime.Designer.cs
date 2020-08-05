namespace AutoSports.OVRSQPlugin
{
    partial class ModifyMatchTime
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
            this.dgvMatchTime = new System.Windows.Forms.DataGridView();
            this.lb_Regu = new DevComponents.DotNetBar.LabelX();
            this.cmb_Time_Regus = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchTime)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvMatchTime
            // 
            this.dgvMatchTime.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchTime.Location = new System.Drawing.Point(-1, 30);
            this.dgvMatchTime.Name = "dgvMatchTime";
            this.dgvMatchTime.RowTemplate.Height = 23;
            this.dgvMatchTime.Size = new System.Drawing.Size(478, 85);
            this.dgvMatchTime.TabIndex = 1;
            this.dgvMatchTime.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchTime_CellValueChanged);
            // 
            // lb_Regu
            // 
            this.lb_Regu.Location = new System.Drawing.Point(307, 1);
            this.lb_Regu.Name = "lb_Regu";
            this.lb_Regu.Size = new System.Drawing.Size(43, 23);
            this.lb_Regu.TabIndex = 2;
            this.lb_Regu.Text = "Regu";
            // 
            // cmb_Time_Regus
            // 
            this.cmb_Time_Regus.DisplayMember = "Text";
            this.cmb_Time_Regus.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmb_Time_Regus.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmb_Time_Regus.FormattingEnabled = true;
            this.cmb_Time_Regus.ItemHeight = 15;
            this.cmb_Time_Regus.Location = new System.Drawing.Point(356, 2);
            this.cmb_Time_Regus.Name = "cmb_Time_Regus";
            this.cmb_Time_Regus.Size = new System.Drawing.Size(121, 21);
            this.cmb_Time_Regus.TabIndex = 3;
            this.cmb_Time_Regus.SelectionChangeCommitted += new System.EventHandler(this.cmb_Time_Regus_SelectionChangeCommitted);
            // 
            // ModifyMatchTime
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(479, 113);
            this.Controls.Add(this.cmb_Time_Regus);
            this.Controls.Add(this.lb_Regu);
            this.Controls.Add(this.dgvMatchTime);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "ModifyMatchTime";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "ModifyMatchTime";
            this.Load += new System.EventHandler(this.ModifyMatchTime_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchTime)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvMatchTime;
        private DevComponents.DotNetBar.LabelX lb_Regu;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmb_Time_Regus;

    }
}