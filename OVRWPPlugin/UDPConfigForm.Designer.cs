namespace AutoSports.OVRWPPlugin
{
    partial class UDPConfigForm
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
            this.lb_UDP = new DevComponents.DotNetBar.LabelX();
            this.UDP_Port = new DevComponents.DotNetBar.Controls.TextBoxX();
            this.SuspendLayout();
            // 
            // btn_OK
            // 
            this.btn_OK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_OK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btn_OK.Location = new System.Drawing.Point(24, 53);
            this.btn_OK.Name = "btn_OK";
            this.btn_OK.Size = new System.Drawing.Size(61, 23);
            this.btn_OK.TabIndex = 0;
            this.btn_OK.Text = "OK";
            this.btn_OK.Click += new System.EventHandler(this.btn_OK_Click);
            // 
            // btn_Cancel
            // 
            this.btn_Cancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_Cancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btn_Cancel.Location = new System.Drawing.Point(105, 53);
            this.btn_Cancel.Name = "btn_Cancel";
            this.btn_Cancel.Size = new System.Drawing.Size(60, 23);
            this.btn_Cancel.TabIndex = 0;
            this.btn_Cancel.Text = "Cancel";
            this.btn_Cancel.Click += new System.EventHandler(this.btn_Cancel_Click);
            // 
            // lb_UDP
            // 
            // 
            // 
            // 
            this.lb_UDP.BackgroundStyle.Class = "";
            this.lb_UDP.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lb_UDP.Location = new System.Drawing.Point(12, 16);
            this.lb_UDP.Name = "lb_UDP";
            this.lb_UDP.Size = new System.Drawing.Size(62, 23);
            this.lb_UDP.TabIndex = 1;
            this.lb_UDP.Text = "Port:";
            this.lb_UDP.TextAlignment = System.Drawing.StringAlignment.Far;
            // 
            // UDP_Port
            // 
            // 
            // 
            // 
            this.UDP_Port.Border.Class = "TextBoxBorder";
            this.UDP_Port.Border.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.UDP_Port.Location = new System.Drawing.Point(80, 16);
            this.UDP_Port.Name = "UDP_Port";
            this.UDP_Port.Size = new System.Drawing.Size(71, 21);
            this.UDP_Port.TabIndex = 41;
            this.UDP_Port.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.UDP_Port_KeyPress);
            // 
            // UDPConfigForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(177, 88);
            this.Controls.Add(this.UDP_Port);
            this.Controls.Add(this.lb_UDP);
            this.Controls.Add(this.btn_Cancel);
            this.Controls.Add(this.btn_OK);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "UDPConfigForm";
            this.ShowInTaskbar = false;
            this.Text = "SerialConfigForm";
            this.Load += new System.EventHandler(this.SerialConfigForm_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btn_OK;
        private DevComponents.DotNetBar.ButtonX btn_Cancel;
        private DevComponents.DotNetBar.LabelX lb_UDP;
        public DevComponents.DotNetBar.Controls.TextBoxX UDP_Port;


    }
}