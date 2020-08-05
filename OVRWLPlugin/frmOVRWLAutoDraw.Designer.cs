namespace AutoSports.OVRWLPlugin
{
    partial class OVRWLAutoDrawForm
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle5 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
            this.dgvRegister = new DevComponents.DotNetBar.Controls.DataGridViewX();
            this.btnXDraw = new DevComponents.DotNetBar.ButtonX();
            this.cmbFederation = new System.Windows.Forms.ComboBox();
            this.lbEvent = new DevComponents.DotNetBar.LabelX();
            this.lbFederation = new DevComponents.DotNetBar.LabelX();
            this.cmbSex = new System.Windows.Forms.ComboBox();
            this.cmbEvent = new System.Windows.Forms.ComboBox();
            this.lbSex = new DevComponents.DotNetBar.LabelX();
            this.lbRegType = new DevComponents.DotNetBar.LabelX();
            this.cmbRegType = new System.Windows.Forms.ComboBox();
            this.labelX1 = new DevComponents.DotNetBar.LabelX();
            this.btnXLogin = new DevComponents.DotNetBar.ButtonX();
            this.txtPassWord = new System.Windows.Forms.TextBox();
            ((System.ComponentModel.ISupportInitialize)(this.dgvRegister)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvRegister
            // 
            this.dgvRegister.AllowUserToDeleteRows = false;
            this.dgvRegister.BackgroundColor = System.Drawing.Color.WhiteSmoke;
            dataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle4.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle4.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle4.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle4.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle4.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle4.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvRegister.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvRegister.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle5.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle5.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle5.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle5.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle5.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle5.SelectionForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle5.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvRegister.DefaultCellStyle = dataGridViewCellStyle5;
            this.dgvRegister.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(208)))), ((int)(((byte)(215)))), ((int)(((byte)(229)))));
            this.dgvRegister.Location = new System.Drawing.Point(170, 12);
            this.dgvRegister.Name = "dgvRegister";
            dataGridViewCellStyle6.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle6.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle6.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle6.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle6.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle6.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle6.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvRegister.RowHeadersDefaultCellStyle = dataGridViewCellStyle6;
            this.dgvRegister.RowHeadersWidth = 20;
            this.dgvRegister.RowTemplate.Height = 23;
            this.dgvRegister.Size = new System.Drawing.Size(655, 548);
            this.dgvRegister.TabIndex = 0;
            this.dgvRegister.CellEnter += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvRegister_CellEnter);
            this.dgvRegister.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvRegister_CellValueChanged);
            // 
            // btnXDraw
            // 
            this.btnXDraw.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnXDraw.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnXDraw.Enabled = false;
            this.btnXDraw.Image = global::AutoSports.OVRWLPlugin.Properties.Resources.draw;
            this.btnXDraw.Location = new System.Drawing.Point(10, 146);
            this.btnXDraw.Name = "btnXDraw";
            this.btnXDraw.Size = new System.Drawing.Size(147, 148);
            this.btnXDraw.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnXDraw.TabIndex = 1;
            this.btnXDraw.Click += new System.EventHandler(this.btnXDraw_Click);
            // 
            // cmbFederation
            // 
            this.cmbFederation.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbFederation.FormattingEnabled = true;
            this.cmbFederation.Location = new System.Drawing.Point(50, 457);
            this.cmbFederation.Name = "cmbFederation";
            this.cmbFederation.Size = new System.Drawing.Size(110, 20);
            this.cmbFederation.TabIndex = 8;
            this.cmbFederation.Visible = false;
            this.cmbFederation.SelectionChangeCommitted += new System.EventHandler(this.cmbFederation_SelectionChangeCommitted);
            // 
            // lbEvent
            // 
            // 
            // 
            // 
            this.lbEvent.BackgroundStyle.Class = "";
            this.lbEvent.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbEvent.Location = new System.Drawing.Point(2, 90);
            this.lbEvent.Name = "lbEvent";
            this.lbEvent.Size = new System.Drawing.Size(45, 20);
            this.lbEvent.TabIndex = 7;
            this.lbEvent.Text = "Event:";
            this.lbEvent.TextAlignment = System.Drawing.StringAlignment.Far;
            // 
            // lbFederation
            // 
            // 
            // 
            // 
            this.lbFederation.BackgroundStyle.Class = "";
            this.lbFederation.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbFederation.Location = new System.Drawing.Point(2, 437);
            this.lbFederation.Name = "lbFederation";
            this.lbFederation.Size = new System.Drawing.Size(162, 20);
            this.lbFederation.TabIndex = 10;
            this.lbFederation.Text = "Nationality:(just search)";
            this.lbFederation.Visible = false;
            // 
            // cmbSex
            // 
            this.cmbSex.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbSex.FormattingEnabled = true;
            this.cmbSex.Location = new System.Drawing.Point(50, 55);
            this.cmbSex.Name = "cmbSex";
            this.cmbSex.Size = new System.Drawing.Size(110, 20);
            this.cmbSex.TabIndex = 4;
            this.cmbSex.SelectedIndexChanged += new System.EventHandler(this.cmbSex_SelectionChangeCommitted);
            // 
            // cmbEvent
            // 
            this.cmbEvent.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbEvent.FormattingEnabled = true;
            this.cmbEvent.Location = new System.Drawing.Point(50, 90);
            this.cmbEvent.Name = "cmbEvent";
            this.cmbEvent.Size = new System.Drawing.Size(110, 20);
            this.cmbEvent.TabIndex = 3;
            this.cmbEvent.SelectionChangeCommitted += new System.EventHandler(this.cmbEvent_SelectionChangeCommitted);
            // 
            // lbSex
            // 
            // 
            // 
            // 
            this.lbSex.BackgroundStyle.Class = "";
            this.lbSex.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbSex.ForeColor = System.Drawing.Color.Black;
            this.lbSex.Location = new System.Drawing.Point(2, 55);
            this.lbSex.Name = "lbSex";
            this.lbSex.Size = new System.Drawing.Size(45, 20);
            this.lbSex.TabIndex = 5;
            this.lbSex.Text = "Sex:";
            this.lbSex.TextAlignment = System.Drawing.StringAlignment.Far;
            // 
            // lbRegType
            // 
            // 
            // 
            // 
            this.lbRegType.BackgroundStyle.Class = "";
            this.lbRegType.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbRegType.Location = new System.Drawing.Point(2, 492);
            this.lbRegType.Name = "lbRegType";
            this.lbRegType.Size = new System.Drawing.Size(80, 20);
            this.lbRegType.TabIndex = 9;
            this.lbRegType.Text = "RegType:";
            this.lbRegType.Visible = false;
            // 
            // cmbRegType
            // 
            this.cmbRegType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbRegType.FormattingEnabled = true;
            this.cmbRegType.Location = new System.Drawing.Point(50, 512);
            this.cmbRegType.Name = "cmbRegType";
            this.cmbRegType.Size = new System.Drawing.Size(110, 20);
            this.cmbRegType.TabIndex = 6;
            this.cmbRegType.Visible = false;
            this.cmbRegType.SelectionChangeCommitted += new System.EventHandler(this.cmbRegType_SelectionChangeCommitted);
            // 
            // labelX1
            // 
            // 
            // 
            // 
            this.labelX1.BackgroundStyle.Class = "";
            this.labelX1.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labelX1.Font = new System.Drawing.Font("宋体", 11F);
            this.labelX1.ForeColor = System.Drawing.Color.DodgerBlue;
            this.labelX1.Location = new System.Drawing.Point(12, 29);
            this.labelX1.Name = "labelX1";
            this.labelX1.Size = new System.Drawing.Size(147, 20);
            this.labelX1.TabIndex = 11;
            // 
            // btnXLogin
            // 
            this.btnXLogin.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnXLogin.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnXLogin.Location = new System.Drawing.Point(92, 379);
            this.btnXLogin.Name = "btnXLogin";
            this.btnXLogin.Size = new System.Drawing.Size(65, 35);
            this.btnXLogin.TabIndex = 22;
            this.btnXLogin.Text = "Login";
            this.btnXLogin.Click += new System.EventHandler(this.btnXSetAttempt_Click);
            // 
            // txtPassWord
            // 
            this.txtPassWord.Location = new System.Drawing.Point(10, 346);
            this.txtPassWord.Name = "txtPassWord";
            this.txtPassWord.PasswordChar = '*';
            this.txtPassWord.Size = new System.Drawing.Size(147, 21);
            this.txtPassWord.TabIndex = 23;
            // 
            // OVRWLAutoDrawForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(199)))), ((int)(((byte)(216)))), ((int)(((byte)(237)))));
            this.ClientSize = new System.Drawing.Size(837, 572);
            this.Controls.Add(this.txtPassWord);
            this.Controls.Add(this.btnXLogin);
            this.Controls.Add(this.labelX1);
            this.Controls.Add(this.cmbFederation);
            this.Controls.Add(this.lbEvent);
            this.Controls.Add(this.lbFederation);
            this.Controls.Add(this.lbRegType);
            this.Controls.Add(this.cmbSex);
            this.Controls.Add(this.cmbEvent);
            this.Controls.Add(this.cmbRegType);
            this.Controls.Add(this.lbSex);
            this.Controls.Add(this.btnXDraw);
            this.Controls.Add(this.dgvRegister);
            this.DoubleBuffered = true;
            this.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Fixed3D;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRWLAutoDrawForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "WL - Generate Lot Number";
            this.TitleText = "WL - Generate Lot Number";
            this.Load += new System.EventHandler(this.OVRWLAutoDrawForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvRegister)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevComponents.DotNetBar.Controls.DataGridViewX dgvRegister;
        private DevComponents.DotNetBar.ButtonX btnXDraw;
        private System.Windows.Forms.ComboBox cmbFederation;
        private DevComponents.DotNetBar.LabelX lbEvent;
        private DevComponents.DotNetBar.LabelX lbFederation;
        private System.Windows.Forms.ComboBox cmbSex;
        private System.Windows.Forms.ComboBox cmbEvent;
        private DevComponents.DotNetBar.LabelX lbSex;
        private DevComponents.DotNetBar.LabelX lbRegType;
        private System.Windows.Forms.ComboBox cmbRegType;
        private DevComponents.DotNetBar.LabelX labelX1;
        private DevComponents.DotNetBar.ButtonX btnXLogin;
        private System.Windows.Forms.TextBox txtPassWord;

    }
}