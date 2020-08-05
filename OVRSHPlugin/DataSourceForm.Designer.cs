namespace AutoSports.OVRSHPlugin
{
    partial class DataSourceForm
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
            this.textBoxTcpServer = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.textBoxTcpPort = new System.Windows.Forms.TextBox();
            this.BtnConnectTcp = new System.Windows.Forms.Button();
            this.btnDisconnecttcp = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.textBoxPath = new System.Windows.Forms.TextBox();
            this.buttonPath = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // textBoxTcpServer
            // 
            this.textBoxTcpServer.Location = new System.Drawing.Point(83, 26);
            this.textBoxTcpServer.Name = "textBoxTcpServer";
            this.textBoxTcpServer.Size = new System.Drawing.Size(179, 20);
            this.textBoxTcpServer.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 29);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(65, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Multicast IP:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(35, 64);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(29, 13);
            this.label2.TabIndex = 2;
            this.label2.Text = "Port:";
            // 
            // textBoxTcpPort
            // 
            this.textBoxTcpPort.Location = new System.Drawing.Point(83, 61);
            this.textBoxTcpPort.Name = "textBoxTcpPort";
            this.textBoxTcpPort.Size = new System.Drawing.Size(179, 20);
            this.textBoxTcpPort.TabIndex = 3;
            // 
            // BtnConnectTcp
            // 
            this.BtnConnectTcp.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.BtnConnectTcp.Location = new System.Drawing.Point(83, 127);
            this.BtnConnectTcp.Name = "BtnConnectTcp";
            this.BtnConnectTcp.Size = new System.Drawing.Size(84, 28);
            this.BtnConnectTcp.TabIndex = 4;
            this.BtnConnectTcp.Text = "Connect";
            this.BtnConnectTcp.UseVisualStyleBackColor = true;
            this.BtnConnectTcp.Click += new System.EventHandler(this.BtnConnectTcp_Click);
            // 
            // btnDisconnecttcp
            // 
            this.btnDisconnecttcp.Location = new System.Drawing.Point(178, 127);
            this.btnDisconnecttcp.Name = "btnDisconnecttcp";
            this.btnDisconnecttcp.Size = new System.Drawing.Size(84, 28);
            this.btnDisconnecttcp.TabIndex = 5;
            this.btnDisconnecttcp.Text = "Disconnect";
            this.btnDisconnecttcp.UseVisualStyleBackColor = true;
            this.btnDisconnecttcp.Click += new System.EventHandler(this.btnDisconnecttcp_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(35, 102);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(32, 13);
            this.label3.TabIndex = 6;
            this.label3.Text = "Path:";
            // 
            // textBoxPath
            // 
            this.textBoxPath.Location = new System.Drawing.Point(83, 99);
            this.textBoxPath.Name = "textBoxPath";
            this.textBoxPath.Size = new System.Drawing.Size(179, 20);
            this.textBoxPath.TabIndex = 7;
            // 
            // buttonPath
            // 
            this.buttonPath.Location = new System.Drawing.Point(268, 97);
            this.buttonPath.Name = "buttonPath";
            this.buttonPath.Size = new System.Drawing.Size(18, 23);
            this.buttonPath.TabIndex = 8;
            this.buttonPath.Text = ">";
            this.buttonPath.UseVisualStyleBackColor = true;
            this.buttonPath.Click += new System.EventHandler(this.buttonPath_Click);
            // 
            // DataSourceForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(294, 176);
            this.Controls.Add(this.buttonPath);
            this.Controls.Add(this.textBoxPath);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.btnDisconnecttcp);
            this.Controls.Add(this.BtnConnectTcp);
            this.Controls.Add(this.textBoxTcpPort);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.textBoxTcpServer);
            this.Name = "DataSourceForm";
            this.Text = "DataSource Setup";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textBoxTcpServer;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox textBoxTcpPort;
        private System.Windows.Forms.Button BtnConnectTcp;
        private System.Windows.Forms.Button btnDisconnecttcp;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox textBoxPath;
        private System.Windows.Forms.Button buttonPath;

    }
}