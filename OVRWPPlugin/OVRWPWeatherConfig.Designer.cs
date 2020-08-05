namespace AutoSports.OVRWPPlugin
{
    partial class OVRWPWeatherConfig
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
            this.textAirtemp = new System.Windows.Forms.TextBox();
            this.textHumidity = new System.Windows.Forms.TextBox();
            this.cmbDescription = new System.Windows.Forms.ComboBox();
            this.cmbWindDirection = new System.Windows.Forms.ComboBox();
            this.textWindSpeed = new System.Windows.Forms.TextBox();
            this.btnOK = new DevComponents.DotNetBar.ButtonX();
            this.btnCancel = new DevComponents.DotNetBar.ButtonX();
            this.lbAirtemp = new DevComponents.DotNetBar.LabelX();
            this.lbHumidity = new DevComponents.DotNetBar.LabelX();
            this.lbWeatherConditionDes = new DevComponents.DotNetBar.LabelX();
            this.lbWindSpeed = new DevComponents.DotNetBar.LabelX();
            this.lbWindDirection = new DevComponents.DotNetBar.LabelX();
            this.labelX1 = new DevComponents.DotNetBar.LabelX();
            this.labelX2 = new DevComponents.DotNetBar.LabelX();
            this.lbUnit = new DevComponents.DotNetBar.LabelX();
            this.lbWatertemp = new DevComponents.DotNetBar.LabelX();
            this.textWaterTemp = new System.Windows.Forms.TextBox();
            this.labelX4 = new DevComponents.DotNetBar.LabelX();
            this.SuspendLayout();
            // 
            // textAirtemp
            // 
            this.textAirtemp.Location = new System.Drawing.Point(131, 66);
            this.textAirtemp.Name = "textAirtemp";
            this.textAirtemp.Size = new System.Drawing.Size(62, 21);
            this.textAirtemp.TabIndex = 1;
            this.textAirtemp.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.textAirtemp_KeyDown);
            // 
            // textHumidity
            // 
            this.textHumidity.Location = new System.Drawing.Point(131, 128);
            this.textHumidity.Name = "textHumidity";
            this.textHumidity.Size = new System.Drawing.Size(62, 21);
            this.textHumidity.TabIndex = 7;
            this.textHumidity.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.textHumidity_KeyDown);
            // 
            // cmbDescription
            // 
            this.cmbDescription.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbDescription.FormattingEnabled = true;
            this.cmbDescription.Location = new System.Drawing.Point(9, 28);
            this.cmbDescription.Name = "cmbDescription";
            this.cmbDescription.Size = new System.Drawing.Size(211, 20);
            this.cmbDescription.TabIndex = 10;
            this.cmbDescription.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.cmbDescription_KeyDown);
            // 
            // cmbWindDirection
            // 
            this.cmbWindDirection.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbWindDirection.FormattingEnabled = true;
            this.cmbWindDirection.Location = new System.Drawing.Point(113, 214);
            this.cmbWindDirection.Name = "cmbWindDirection";
            this.cmbWindDirection.Size = new System.Drawing.Size(109, 20);
            this.cmbWindDirection.TabIndex = 12;
            this.cmbWindDirection.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.cmbWindDirection_KeyDown);
            // 
            // textWindSpeed
            // 
            this.textWindSpeed.Location = new System.Drawing.Point(131, 170);
            this.textWindSpeed.Name = "textWindSpeed";
            this.textWindSpeed.Size = new System.Drawing.Size(62, 21);
            this.textWindSpeed.TabIndex = 8;
            this.textWindSpeed.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.textWindSpeed_KeyDown);
            // 
            // btnOK
            // 
            this.btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOK.Location = new System.Drawing.Point(39, 258);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(62, 23);
            this.btnOK.TabIndex = 13;
            this.btnOK.Text = "OK";
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // btnCancel
            // 
            this.btnCancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnCancel.Location = new System.Drawing.Point(147, 258);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(62, 23);
            this.btnCancel.TabIndex = 13;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // lbAirtemp
            // 
            this.lbAirtemp.Location = new System.Drawing.Point(10, 69);
            this.lbAirtemp.Name = "lbAirtemp";
            this.lbAirtemp.Size = new System.Drawing.Size(115, 18);
            this.lbAirtemp.TabIndex = 14;
            this.lbAirtemp.Text = "Air Temperature";
            // 
            // lbHumidity
            // 
            this.lbHumidity.Location = new System.Drawing.Point(10, 131);
            this.lbHumidity.Name = "lbHumidity";
            this.lbHumidity.Size = new System.Drawing.Size(75, 18);
            this.lbHumidity.TabIndex = 14;
            this.lbHumidity.Text = "Humidity";
            // 
            // lbWeatherConditionDes
            // 
            this.lbWeatherConditionDes.Location = new System.Drawing.Point(10, 2);
            this.lbWeatherConditionDes.Name = "lbWeatherConditionDes";
            this.lbWeatherConditionDes.Size = new System.Drawing.Size(128, 18);
            this.lbWeatherConditionDes.TabIndex = 14;
            this.lbWeatherConditionDes.Text = "Weather Condition";
            // 
            // lbWindSpeed
            // 
            this.lbWindSpeed.Location = new System.Drawing.Point(10, 173);
            this.lbWindSpeed.Name = "lbWindSpeed";
            this.lbWindSpeed.Size = new System.Drawing.Size(75, 18);
            this.lbWindSpeed.TabIndex = 14;
            this.lbWindSpeed.Text = "Wind Speed";
            // 
            // lbWindDirection
            // 
            this.lbWindDirection.Location = new System.Drawing.Point(10, 216);
            this.lbWindDirection.Name = "lbWindDirection";
            this.lbWindDirection.Size = new System.Drawing.Size(98, 18);
            this.lbWindDirection.TabIndex = 14;
            this.lbWindDirection.Text = "Wind Direction";
            // 
            // labelX1
            // 
            this.labelX1.Location = new System.Drawing.Point(199, 131);
            this.labelX1.Name = "labelX1";
            this.labelX1.Size = new System.Drawing.Size(10, 18);
            this.labelX1.TabIndex = 14;
            this.labelX1.Text = "%";
            // 
            // labelX2
            // 
            this.labelX2.Location = new System.Drawing.Point(196, 69);
            this.labelX2.Name = "labelX2";
            this.labelX2.Size = new System.Drawing.Size(20, 18);
            this.labelX2.TabIndex = 14;
            this.labelX2.Text = "℃";
            // 
            // lbUnit
            // 
            this.lbUnit.Location = new System.Drawing.Point(198, 173);
            this.lbUnit.Name = "lbUnit";
            this.lbUnit.Size = new System.Drawing.Size(48, 18);
            this.lbUnit.TabIndex = 14;
            this.lbUnit.Text = "km/h";
            // 
            // lbWatertemp
            // 
            this.lbWatertemp.Location = new System.Drawing.Point(10, 99);
            this.lbWatertemp.Name = "lbWatertemp";
            this.lbWatertemp.Size = new System.Drawing.Size(115, 18);
            this.lbWatertemp.TabIndex = 15;
            this.lbWatertemp.Text = "Water Temperature";
            // 
            // textWaterTemp
            // 
            this.textWaterTemp.Location = new System.Drawing.Point(131, 97);
            this.textWaterTemp.Name = "textWaterTemp";
            this.textWaterTemp.Size = new System.Drawing.Size(62, 21);
            this.textWaterTemp.TabIndex = 1;
            this.textWaterTemp.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.textWatertemp_KeyDown);
            // 
            // labelX4
            // 
            this.labelX4.Location = new System.Drawing.Point(196, 101);
            this.labelX4.Name = "labelX4";
            this.labelX4.Size = new System.Drawing.Size(20, 18);
            this.labelX4.TabIndex = 14;
            this.labelX4.Text = "℃";
            // 
            // OVROWWeatherConfig
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(246, 294);
            this.Controls.Add(this.lbWatertemp);
            this.Controls.Add(this.cmbWindDirection);
            this.Controls.Add(this.lbWeatherConditionDes);
            this.Controls.Add(this.lbWindDirection);
            this.Controls.Add(this.lbWindSpeed);
            this.Controls.Add(this.lbUnit);
            this.Controls.Add(this.labelX4);
            this.Controls.Add(this.labelX2);
            this.Controls.Add(this.labelX1);
            this.Controls.Add(this.lbHumidity);
            this.Controls.Add(this.lbAirtemp);
            this.Controls.Add(this.textWindSpeed);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.cmbDescription);
            this.Controls.Add(this.textHumidity);
            this.Controls.Add(this.textWaterTemp);
            this.Controls.Add(this.textAirtemp);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVROWWeatherConfig";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Weather Setting";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textAirtemp;
        private System.Windows.Forms.TextBox textHumidity;
        private System.Windows.Forms.ComboBox cmbDescription;
        private System.Windows.Forms.ComboBox cmbWindDirection;
        private System.Windows.Forms.TextBox textWindSpeed;
        private DevComponents.DotNetBar.ButtonX btnOK;
        private DevComponents.DotNetBar.ButtonX btnCancel;
        private DevComponents.DotNetBar.LabelX lbAirtemp;
        private DevComponents.DotNetBar.LabelX lbHumidity;
        private DevComponents.DotNetBar.LabelX lbWeatherConditionDes;
        private DevComponents.DotNetBar.LabelX lbWindSpeed;
        private DevComponents.DotNetBar.LabelX lbWindDirection;
        private DevComponents.DotNetBar.LabelX labelX1;
        private DevComponents.DotNetBar.LabelX labelX2;
        private DevComponents.DotNetBar.LabelX lbUnit;
        private DevComponents.DotNetBar.LabelX lbWatertemp;
        public System.Windows.Forms.TextBox textWaterTemp;
        private DevComponents.DotNetBar.LabelX labelX4;
    }
}