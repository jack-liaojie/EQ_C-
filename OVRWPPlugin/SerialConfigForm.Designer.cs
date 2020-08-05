namespace AutoSports.OVRWPPlugin
{
    partial class SerialConfigForm
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
            this.btn_OK = new DevComponents.DotNetBar.ButtonX();
            this.btn_Cancel = new DevComponents.DotNetBar.ButtonX();
            this.labelX_SerialPort = new DevComponents.DotNetBar.LabelX();
            this.labelX_Baudrate = new DevComponents.DotNetBar.LabelX();
            this.labelX_Parity = new DevComponents.DotNetBar.LabelX();
            this.labelX_Databits = new DevComponents.DotNetBar.LabelX();
            this.labelX_Stopbits = new DevComponents.DotNetBar.LabelX();
            this.comboBox_COM_Port = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.comboBox_Baudrate = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.comboBox_Parity = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.comboBox_Databits = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.comboBox_Stopbits = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.SuspendLayout();
            // 
            // btn_OK
            // 
            this.btn_OK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_OK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btn_OK.Location = new System.Drawing.Point(32, 161);
            this.btn_OK.Name = "btn_OK";
            this.btn_OK.Size = new System.Drawing.Size(52, 23);
            this.btn_OK.TabIndex = 0;
            this.btn_OK.Text = "OK";
            this.btn_OK.Click += new System.EventHandler(this.btn_OK_Click);
            // 
            // btn_Cancel
            // 
            this.btn_Cancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_Cancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btn_Cancel.Location = new System.Drawing.Point(111, 162);
            this.btn_Cancel.Name = "btn_Cancel";
            this.btn_Cancel.Size = new System.Drawing.Size(52, 23);
            this.btn_Cancel.TabIndex = 0;
            this.btn_Cancel.Text = "Cancel";
            this.btn_Cancel.Click += new System.EventHandler(this.btn_Cancel_Click);
            // 
            // labelX_SerialPort
            // 
            this.labelX_SerialPort.Location = new System.Drawing.Point(9, 1);
            this.labelX_SerialPort.Name = "labelX_SerialPort";
            this.labelX_SerialPort.Size = new System.Drawing.Size(62, 23);
            this.labelX_SerialPort.TabIndex = 1;
            this.labelX_SerialPort.Text = "COM Port:";
            // 
            // labelX_Baudrate
            // 
            this.labelX_Baudrate.Location = new System.Drawing.Point(9, 30);
            this.labelX_Baudrate.Name = "labelX_Baudrate";
            this.labelX_Baudrate.Size = new System.Drawing.Size(62, 23);
            this.labelX_Baudrate.TabIndex = 1;
            this.labelX_Baudrate.Text = "Baudrate:";
            // 
            // labelX_Parity
            // 
            this.labelX_Parity.Location = new System.Drawing.Point(9, 59);
            this.labelX_Parity.Name = "labelX_Parity";
            this.labelX_Parity.Size = new System.Drawing.Size(62, 23);
            this.labelX_Parity.TabIndex = 1;
            this.labelX_Parity.Text = "Parity:";
            // 
            // labelX_Databits
            // 
            this.labelX_Databits.Location = new System.Drawing.Point(9, 88);
            this.labelX_Databits.Name = "labelX_Databits";
            this.labelX_Databits.Size = new System.Drawing.Size(62, 23);
            this.labelX_Databits.TabIndex = 1;
            this.labelX_Databits.Text = "Databits:";
            // 
            // labelX_Stopbits
            // 
            this.labelX_Stopbits.Location = new System.Drawing.Point(9, 117);
            this.labelX_Stopbits.Name = "labelX_Stopbits";
            this.labelX_Stopbits.Size = new System.Drawing.Size(62, 23);
            this.labelX_Stopbits.TabIndex = 1;
            this.labelX_Stopbits.Text = "Stopbits:";
            // 
            // comboBox_COM_Port
            // 
            this.comboBox_COM_Port.DisplayMember = "Text";
            this.comboBox_COM_Port.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.comboBox_COM_Port.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBox_COM_Port.FormattingEnabled = true;
            this.comboBox_COM_Port.ItemHeight = 15;
            this.comboBox_COM_Port.Location = new System.Drawing.Point(96, 3);
            this.comboBox_COM_Port.Name = "comboBox_COM_Port";
            this.comboBox_COM_Port.Size = new System.Drawing.Size(76, 21);
            this.comboBox_COM_Port.Sorted = true;
            this.comboBox_COM_Port.TabIndex = 2;
            // 
            // comboBox_Baudrate
            // 
            this.comboBox_Baudrate.DisplayMember = "Text";
            this.comboBox_Baudrate.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.comboBox_Baudrate.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBox_Baudrate.FormattingEnabled = true;
            this.comboBox_Baudrate.ItemHeight = 15;
            this.comboBox_Baudrate.Location = new System.Drawing.Point(96, 30);
            this.comboBox_Baudrate.Name = "comboBox_Baudrate";
            this.comboBox_Baudrate.Size = new System.Drawing.Size(76, 21);
            this.comboBox_Baudrate.TabIndex = 2;
            // 
            // comboBox_Parity
            // 
            this.comboBox_Parity.DisplayMember = "Text";
            this.comboBox_Parity.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.comboBox_Parity.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBox_Parity.FormattingEnabled = true;
            this.comboBox_Parity.ItemHeight = 15;
            this.comboBox_Parity.Location = new System.Drawing.Point(96, 61);
            this.comboBox_Parity.Name = "comboBox_Parity";
            this.comboBox_Parity.Size = new System.Drawing.Size(76, 21);
            this.comboBox_Parity.TabIndex = 2;
            // 
            // comboBox_Databits
            // 
            this.comboBox_Databits.DisplayMember = "Text";
            this.comboBox_Databits.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.comboBox_Databits.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBox_Databits.FormattingEnabled = true;
            this.comboBox_Databits.ItemHeight = 15;
            this.comboBox_Databits.Location = new System.Drawing.Point(96, 90);
            this.comboBox_Databits.Name = "comboBox_Databits";
            this.comboBox_Databits.Size = new System.Drawing.Size(76, 21);
            this.comboBox_Databits.TabIndex = 2;
            // 
            // comboBox_Stopbits
            // 
            this.comboBox_Stopbits.DisplayMember = "Text";
            this.comboBox_Stopbits.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.comboBox_Stopbits.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBox_Stopbits.FormattingEnabled = true;
            this.comboBox_Stopbits.ItemHeight = 15;
            this.comboBox_Stopbits.Location = new System.Drawing.Point(77, 117);
            this.comboBox_Stopbits.Name = "comboBox_Stopbits";
            this.comboBox_Stopbits.Size = new System.Drawing.Size(95, 21);
            this.comboBox_Stopbits.TabIndex = 2;
            // 
            // SerialConfigForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(177, 193);
            this.Controls.Add(this.comboBox_Stopbits);
            this.Controls.Add(this.comboBox_Databits);
            this.Controls.Add(this.comboBox_Parity);
            this.Controls.Add(this.comboBox_Baudrate);
            this.Controls.Add(this.comboBox_COM_Port);
            this.Controls.Add(this.labelX_Stopbits);
            this.Controls.Add(this.labelX_Databits);
            this.Controls.Add(this.labelX_Parity);
            this.Controls.Add(this.labelX_Baudrate);
            this.Controls.Add(this.labelX_SerialPort);
            this.Controls.Add(this.btn_Cancel);
            this.Controls.Add(this.btn_OK);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "SerialConfigForm";
            this.ShowInTaskbar = false;
            this.Text = "SerialConfigForm";
            this.Load += new System.EventHandler(this.SerialConfigForm_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btn_OK;
        private DevComponents.DotNetBar.ButtonX btn_Cancel;
        private DevComponents.DotNetBar.LabelX labelX_SerialPort;
        private DevComponents.DotNetBar.LabelX labelX_Baudrate;
        private DevComponents.DotNetBar.LabelX labelX_Parity;
        private DevComponents.DotNetBar.LabelX labelX_Databits;
        private DevComponents.DotNetBar.LabelX labelX_Stopbits;


    }
}