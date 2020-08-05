namespace AutoSports.OVRSEPlugin
{
    partial class frmModifyResult
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
            this.dgvMatchResult = new System.Windows.Forms.DataGridView();
            this.cmb_Result_Regus = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lb_Result_Regu = new DevComponents.DotNetBar.LabelX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchResult)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvMatchResult
            // 
            this.dgvMatchResult.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchResult.Location = new System.Drawing.Point(0, 36);
            this.dgvMatchResult.Name = "dgvMatchResult";
            this.dgvMatchResult.RowTemplate.Height = 23;
            this.dgvMatchResult.Size = new System.Drawing.Size(574, 135);
            this.dgvMatchResult.TabIndex = 0;
            this.dgvMatchResult.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchResult_CellValueChanged);
            this.dgvMatchResult.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvMatchResult_CellBeginEdit);
            // 
            // cmb_Result_Regus
            // 
            this.cmb_Result_Regus.DisplayMember = "Text";
            this.cmb_Result_Regus.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmb_Result_Regus.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmb_Result_Regus.FormattingEnabled = true;
            this.cmb_Result_Regus.ItemHeight = 15;
            this.cmb_Result_Regus.Location = new System.Drawing.Point(453, 9);
            this.cmb_Result_Regus.Name = "cmb_Result_Regus";
            this.cmb_Result_Regus.Size = new System.Drawing.Size(121, 21);
            this.cmb_Result_Regus.TabIndex = 1;
            this.cmb_Result_Regus.SelectionChangeCommitted += new System.EventHandler(this.cmb_Result_Regus_SelectionChangeCommitted);
            // 
            // lb_Result_Regu
            // 
            this.lb_Result_Regu.Location = new System.Drawing.Point(406, 9);
            this.lb_Result_Regu.Name = "lb_Result_Regu";
            this.lb_Result_Regu.Size = new System.Drawing.Size(41, 23);
            this.lb_Result_Regu.TabIndex = 2;
            this.lb_Result_Regu.Text = "Regu:";
            // 
            // frmModifyResult
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(577, 175);
            this.Controls.Add(this.lb_Result_Regu);
            this.Controls.Add(this.cmb_Result_Regus);
            this.Controls.Add(this.dgvMatchResult);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmModifyResult";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmModifyResult";
            this.Load += new System.EventHandler(this.frmModifyResult_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchResult)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvMatchResult;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmb_Result_Regus;
        private DevComponents.DotNetBar.LabelX lb_Result_Regu;
    }
}