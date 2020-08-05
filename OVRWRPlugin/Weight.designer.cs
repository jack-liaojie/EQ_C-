namespace AutoSports.OVRWRPlugin
{
    partial class Weight
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
            this.cmbEvent = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.labelX1 = new DevComponents.DotNetBar.LabelX();
            this.dgvWeight = new DevComponents.DotNetBar.Controls.DataGridViewX();
            this.labelX2 = new DevComponents.DotNetBar.LabelX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvWeight)).BeginInit();
            this.SuspendLayout();
            // 
            // cmbEvent
            // 
            this.cmbEvent.DisplayMember = "Text";
            this.cmbEvent.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmbEvent.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbEvent.FormattingEnabled = true;
            this.cmbEvent.ItemHeight = 15;
            this.cmbEvent.Location = new System.Drawing.Point(56, 12);
            this.cmbEvent.Name = "cmbEvent";
            this.cmbEvent.Size = new System.Drawing.Size(208, 21);
            this.cmbEvent.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.cmbEvent.TabIndex = 0;
            //this.cmbEvent.SelectedIndexChanged +=this.cmbEvent_SelectedIndexChanged;
            this.cmbEvent.SelectedIndexChanged += new System.EventHandler(this.cmbEvent_SelectedIndexChanged);
            // 
            // labelX1
            // 
            // 
            // 
            // 
            this.labelX1.BackgroundStyle.Class = "";
            this.labelX1.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labelX1.Location = new System.Drawing.Point(12, 12);
            this.labelX1.Name = "labelX1";
            this.labelX1.Size = new System.Drawing.Size(51, 23);
            this.labelX1.TabIndex = 1;
            this.labelX1.Text = "Event:";
            // 
            // dgvWeight
            // 
            this.dgvWeight.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvWeight.DefaultCellStyle = dataGridViewCellStyle1;
            this.dgvWeight.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(208)))), ((int)(((byte)(215)))), ((int)(((byte)(229)))));
            this.dgvWeight.Location = new System.Drawing.Point(12, 41);
            this.dgvWeight.Name = "dgvWeight";
            this.dgvWeight.RowTemplate.Height = 23;
            this.dgvWeight.Size = new System.Drawing.Size(592, 497);
            this.dgvWeight.TabIndex = 2;
            this.dgvWeight.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvWeight_CellBeginEdit);
            this.dgvWeight.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvWeight_CellEndEdit);
            // 
            // labelX2
            // 
            // 
            // 
            // 
            this.labelX2.BackgroundStyle.Class = "";
            this.labelX2.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labelX2.ForeColor = System.Drawing.Color.Red;
            this.labelX2.Location = new System.Drawing.Point(292, 12);
            this.labelX2.Name = "labelX2";
            this.labelX2.Size = new System.Drawing.Size(226, 23);
            this.labelX2.TabIndex = 3;
            this.labelX2.Text = "最后一栏中(Remark)只能输入：DNA,DNS";
            // 
            // Weight
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(616, 550);
            this.Controls.Add(this.labelX2);
            this.Controls.Add(this.dgvWeight);
            this.Controls.Add(this.labelX1);
            this.Controls.Add(this.cmbEvent);
            this.MaximizeBox = false;
            this.MaximumSize = new System.Drawing.Size(632, 588);
            this.MinimizeBox = false;
            this.MinimumSize = new System.Drawing.Size(632, 588);
            this.Name = "Weight";
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
            this.Text = "Weight";
            ((System.ComponentModel.ISupportInitialize)(this.dgvWeight)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.Controls.ComboBoxEx cmbEvent;
        private DevComponents.DotNetBar.LabelX labelX1;
        private DevComponents.DotNetBar.Controls.DataGridViewX dgvWeight;
        private DevComponents.DotNetBar.LabelX labelX2;
    }
}