namespace AutoSports.OVRARPlugin
{
    partial class frmOVREditEntry
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
            this.dgvRegister = new DevComponents.DotNetBar.Controls.DataGridViewX();
            this.cmbPhase = new System.Windows.Forms.ComboBox();
            this.cmbEvent = new System.Windows.Forms.ComboBox();
            this.lbEvent = new DevComponents.DotNetBar.LabelX();
            this.lbPhase = new DevComponents.DotNetBar.LabelX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvRegister)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvRegister
            // 
            this.dgvRegister.AllowUserToDeleteRows = false;
            this.dgvRegister.BackgroundColor = System.Drawing.Color.WhiteSmoke;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvRegister.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvRegister.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle2.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvRegister.DefaultCellStyle = dataGridViewCellStyle2;
            this.dgvRegister.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(208)))), ((int)(((byte)(215)))), ((int)(((byte)(229)))));
            this.dgvRegister.Location = new System.Drawing.Point(23, 44);
            this.dgvRegister.Name = "dgvRegister";
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle3.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvRegister.RowHeadersDefaultCellStyle = dataGridViewCellStyle3;
            this.dgvRegister.RowHeadersWidth = 20;
            this.dgvRegister.RowTemplate.Height = 23;
            this.dgvRegister.Size = new System.Drawing.Size(947, 516);
            this.dgvRegister.TabIndex = 0;
            this.dgvRegister.CellDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvRegister_CellDoubleClick);
            this.dgvRegister.CellEnter += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvRegister_CellEnter);
            this.dgvRegister.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvRegister_CellValueChanged);
            // 
            // cmbPhase
            // 
            this.cmbPhase.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbPhase.FormattingEnabled = true;
            this.cmbPhase.Location = new System.Drawing.Point(351, 12);
            this.cmbPhase.Name = "cmbPhase";
            this.cmbPhase.Size = new System.Drawing.Size(147, 20);
            this.cmbPhase.TabIndex = 4;
            this.cmbPhase.SelectedIndexChanged += new System.EventHandler(this.cmbPhase_SelectionChangeCommitted);
            // 
            // cmbEvent
            // 
            this.cmbEvent.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbEvent.FormattingEnabled = true;
            this.cmbEvent.Location = new System.Drawing.Point(74, 12);
            this.cmbEvent.Name = "cmbEvent";
            this.cmbEvent.Size = new System.Drawing.Size(147, 20);
            this.cmbEvent.TabIndex = 3;
            this.cmbEvent.SelectionChangeCommitted += new System.EventHandler(this.cmbEvent_SelectionChangeCommitted);
            // 
            // lbEvent
            // 
            // 
            // 
            // 
            this.lbEvent.BackgroundStyle.Class = "";
            this.lbEvent.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbEvent.Location = new System.Drawing.Point(23, 12);
            this.lbEvent.Name = "lbEvent";
            this.lbEvent.Size = new System.Drawing.Size(45, 20);
            this.lbEvent.TabIndex = 7;
            this.lbEvent.Text = "Event:";
            this.lbEvent.TextAlignment = System.Drawing.StringAlignment.Far;
            // 
            // lbPhase
            // 
            // 
            // 
            // 
            this.lbPhase.BackgroundStyle.Class = "";
            this.lbPhase.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbPhase.Location = new System.Drawing.Point(286, 12);
            this.lbPhase.Name = "lbPhase";
            this.lbPhase.Size = new System.Drawing.Size(45, 20);
            this.lbPhase.TabIndex = 24;
            this.lbPhase.Text = "Phase:";
            this.lbPhase.TextAlignment = System.Drawing.StringAlignment.Far;
            // 
            // frmOVREditEntry
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(199)))), ((int)(((byte)(216)))), ((int)(((byte)(237)))));
            this.ClientSize = new System.Drawing.Size(990, 572);
            this.Controls.Add(this.lbPhase);
            this.Controls.Add(this.lbEvent);
            this.Controls.Add(this.cmbPhase);
            this.Controls.Add(this.cmbEvent);
            this.Controls.Add(this.dgvRegister);
            this.DoubleBuffered = true;
            this.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Fixed3D;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmOVREditEntry";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "AR - Edit Back Number";
            this.TitleText = "AR - Edit Back Number";
            this.Load += new System.EventHandler(this.OVRARAutoDrawForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvRegister)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.Controls.DataGridViewX dgvRegister;
        private System.Windows.Forms.ComboBox cmbPhase;
        private System.Windows.Forms.ComboBox cmbEvent;
        private DevComponents.DotNetBar.LabelX lbEvent;
        private DevComponents.DotNetBar.LabelX lbPhase;

    }
}