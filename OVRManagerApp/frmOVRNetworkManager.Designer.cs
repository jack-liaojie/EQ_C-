using Sunny.UI;

namespace AutoSports.OVRManagerApp
{
    partial class OVRNetworkManagerForm
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            this.btnConnect = new DevComponents.DotNetBar.Controls.GroupPanel();
            this.tbServerIP = new DevComponents.Editors.IpAddressInput();
            this.btnConnectServer = new Sunny.UI.UIButton();
            this.pbConnectedStatus = new System.Windows.Forms.PictureBox();
            this.tbServerPort = new Sunny.UI.UITextBox();
            this.lbServerPort = new Sunny.UI.UILabel();
            this.lbServerIP = new Sunny.UI.UILabel();
            this.gpServer = new DevComponents.DotNetBar.Controls.GroupPanel();
            this.btnStartListen = new Sunny.UI.UIButton();
            this.pbListenStatus = new System.Windows.Forms.PictureBox();
            this.tbListenPort = new Sunny.UI.UITextBox();
            this.dgvServerClients = new Sunny.UI.UIDataGridView();
            this.lbListenPort = new Sunny.UI.UILabel();
            this.btnConnect.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.tbServerIP)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbConnectedStatus)).BeginInit();
            this.gpServer.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pbListenStatus)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvServerClients)).BeginInit();
            this.SuspendLayout();
            // 
            // btnConnect
            // 
            this.btnConnect.CanvasColor = System.Drawing.SystemColors.Control;
            this.btnConnect.ColorSchemeStyle = DevComponents.DotNetBar.eDotNetBarStyle.Office2007;
            this.btnConnect.Controls.Add(this.tbServerIP);
            this.btnConnect.Controls.Add(this.btnConnectServer);
            this.btnConnect.Controls.Add(this.pbConnectedStatus);
            this.btnConnect.Controls.Add(this.tbServerPort);
            this.btnConnect.Controls.Add(this.lbServerPort);
            this.btnConnect.Controls.Add(this.lbServerIP);
            this.btnConnect.DrawTitleBox = false;
            this.btnConnect.Enabled = false;
            this.btnConnect.Location = new System.Drawing.Point(1, 1);
            this.btnConnect.Margin = new System.Windows.Forms.Padding(4);
            this.btnConnect.Name = "btnConnect";
            this.btnConnect.Size = new System.Drawing.Size(447, 102);
            // 
            // 
            // 
            this.btnConnect.Style.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(199)))), ((int)(((byte)(216)))), ((int)(((byte)(237)))));
            this.btnConnect.Style.BackColor2 = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.btnConnect.Style.BackColorGradientAngle = 90;
            this.btnConnect.Style.BorderBottom = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.btnConnect.Style.BorderBottomWidth = 1;
            this.btnConnect.Style.BorderColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBorder;
            this.btnConnect.Style.BorderLeft = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.btnConnect.Style.BorderLeftWidth = 1;
            this.btnConnect.Style.BorderRight = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.btnConnect.Style.BorderRightWidth = 1;
            this.btnConnect.Style.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.btnConnect.Style.BorderTopWidth = 1;
            this.btnConnect.Style.Class = "";
            this.btnConnect.Style.CornerDiameter = 4;
            this.btnConnect.Style.CornerType = DevComponents.DotNetBar.eCornerType.Rounded;
            this.btnConnect.Style.TextColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelText;
            // 
            // 
            // 
            this.btnConnect.StyleMouseDown.Class = "";
            this.btnConnect.StyleMouseDown.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            // 
            // 
            // 
            this.btnConnect.StyleMouseOver.Class = "";
            this.btnConnect.StyleMouseOver.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.btnConnect.TabIndex = 0;
            this.btnConnect.Text = "Client";
            // 
            // tbServerIP
            // 
            this.tbServerIP.AllowEmptyState = false;
            this.tbServerIP.AutoOverwrite = true;
            this.tbServerIP.AutoResolveFreeTextEntries = false;
            // 
            // 
            // 
            this.tbServerIP.BackgroundStyle.Class = "DateTimeInputBackground";
            this.tbServerIP.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.tbServerIP.ButtonFreeText.Shortcut = DevComponents.DotNetBar.eShortcut.F2;
            this.tbServerIP.Location = new System.Drawing.Point(128, 0);
            this.tbServerIP.Margin = new System.Windows.Forms.Padding(4);
            this.tbServerIP.Name = "tbServerIP";
            this.tbServerIP.Size = new System.Drawing.Size(228, 29);
            this.tbServerIP.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.tbServerIP.TabIndex = 15;
            this.tbServerIP.TextChanged += new System.EventHandler(this.tbServerIP_TextChanged);
            // 
            // btnConnectServer
            // 
            this.btnConnectServer.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnConnectServer.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnConnectServer.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnConnectServer.Location = new System.Drawing.Point(215, 38);
            this.btnConnectServer.Margin = new System.Windows.Forms.Padding(4);
            this.btnConnectServer.Name = "btnConnectServer";
            this.btnConnectServer.Size = new System.Drawing.Size(141, 32);
            this.btnConnectServer.TabIndex = 14;
            this.btnConnectServer.Click += new System.EventHandler(this.btnConnectServer_Click);
            // 
            // pbConnectedStatus
            // 
            this.pbConnectedStatus.Image = global::AutoSports.OVRManagerApp.Properties.Resources.DisConnected;
            this.pbConnectedStatus.Location = new System.Drawing.Point(364, 1);
            this.pbConnectedStatus.Margin = new System.Windows.Forms.Padding(4);
            this.pbConnectedStatus.Name = "pbConnectedStatus";
            this.pbConnectedStatus.Size = new System.Drawing.Size(68, 62);
            this.pbConnectedStatus.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pbConnectedStatus.TabIndex = 13;
            this.pbConnectedStatus.TabStop = false;
            // 
            // tbServerPort
            // 
            this.tbServerPort.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbServerPort.FillColor = System.Drawing.Color.White;
            this.tbServerPort.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.tbServerPort.Location = new System.Drawing.Point(128, 38);
            this.tbServerPort.Margin = new System.Windows.Forms.Padding(4);
            this.tbServerPort.Maximum = 2147483647D;
            this.tbServerPort.Minimum = -2147483648D;
            this.tbServerPort.Name = "tbServerPort";
            this.tbServerPort.Padding = new System.Windows.Forms.Padding(5);
            this.tbServerPort.Size = new System.Drawing.Size(77, 26);
            this.tbServerPort.TabIndex = 11;
            this.tbServerPort.TextChanged += new System.EventHandler(this.tbServerPort_TextChanged);
            // 
            // lbServerPort
            // 
            this.lbServerPort.BackColor = System.Drawing.Color.Transparent;
            this.lbServerPort.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbServerPort.Location = new System.Drawing.Point(0, 39);
            this.lbServerPort.Margin = new System.Windows.Forms.Padding(4);
            this.lbServerPort.Name = "lbServerPort";
            this.lbServerPort.Size = new System.Drawing.Size(120, 22);
            this.lbServerPort.TabIndex = 10;
            this.lbServerPort.Text = "Port:";
            this.lbServerPort.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbServerIP
            // 
            this.lbServerIP.BackColor = System.Drawing.Color.Transparent;
            this.lbServerIP.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbServerIP.Location = new System.Drawing.Point(0, 5);
            this.lbServerIP.Margin = new System.Windows.Forms.Padding(4);
            this.lbServerIP.Name = "lbServerIP";
            this.lbServerIP.Size = new System.Drawing.Size(120, 22);
            this.lbServerIP.TabIndex = 5;
            this.lbServerIP.Text = "Server IP:";
            this.lbServerIP.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // gpServer
            // 
            this.gpServer.CanvasColor = System.Drawing.SystemColors.Control;
            this.gpServer.ColorSchemeStyle = DevComponents.DotNetBar.eDotNetBarStyle.Office2007;
            this.gpServer.Controls.Add(this.btnStartListen);
            this.gpServer.Controls.Add(this.pbListenStatus);
            this.gpServer.Controls.Add(this.tbListenPort);
            this.gpServer.Controls.Add(this.dgvServerClients);
            this.gpServer.Controls.Add(this.lbListenPort);
            this.gpServer.DrawTitleBox = false;
            this.gpServer.Enabled = false;
            this.gpServer.Location = new System.Drawing.Point(1, 110);
            this.gpServer.Margin = new System.Windows.Forms.Padding(4);
            this.gpServer.Name = "gpServer";
            this.gpServer.Size = new System.Drawing.Size(447, 280);
            // 
            // 
            // 
            this.gpServer.Style.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(199)))), ((int)(((byte)(216)))), ((int)(((byte)(237)))));
            this.gpServer.Style.BackColor2 = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.gpServer.Style.BackColorGradientAngle = 90;
            this.gpServer.Style.BorderBottom = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.gpServer.Style.BorderBottomWidth = 1;
            this.gpServer.Style.BorderColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelBorder;
            this.gpServer.Style.BorderLeft = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.gpServer.Style.BorderLeftWidth = 1;
            this.gpServer.Style.BorderRight = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.gpServer.Style.BorderRightWidth = 1;
            this.gpServer.Style.BorderTop = DevComponents.DotNetBar.eStyleBorderType.Solid;
            this.gpServer.Style.BorderTopWidth = 1;
            this.gpServer.Style.Class = "";
            this.gpServer.Style.CornerDiameter = 4;
            this.gpServer.Style.CornerType = DevComponents.DotNetBar.eCornerType.Rounded;
            this.gpServer.Style.TextColorSchemePart = DevComponents.DotNetBar.eColorSchemePart.PanelText;
            // 
            // 
            // 
            this.gpServer.StyleMouseDown.Class = "";
            this.gpServer.StyleMouseDown.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            // 
            // 
            // 
            this.gpServer.StyleMouseOver.Class = "";
            this.gpServer.StyleMouseOver.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.gpServer.TabIndex = 0;
            this.gpServer.Text = "Server";
            // 
            // btnStartListen
            // 
            this.btnStartListen.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnStartListen.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnStartListen.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnStartListen.Location = new System.Drawing.Point(215, 12);
            this.btnStartListen.Margin = new System.Windows.Forms.Padding(4);
            this.btnStartListen.Name = "btnStartListen";
            this.btnStartListen.Size = new System.Drawing.Size(141, 32);
            this.btnStartListen.TabIndex = 15;
            this.btnStartListen.Click += new System.EventHandler(this.btnStartListen_Click);
            // 
            // pbListenStatus
            // 
            this.pbListenStatus.Image = global::AutoSports.OVRManagerApp.Properties.Resources.Connected;
            this.pbListenStatus.Location = new System.Drawing.Point(364, 0);
            this.pbListenStatus.Margin = new System.Windows.Forms.Padding(4);
            this.pbListenStatus.Name = "pbListenStatus";
            this.pbListenStatus.Size = new System.Drawing.Size(68, 62);
            this.pbListenStatus.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pbListenStatus.TabIndex = 14;
            this.pbListenStatus.TabStop = false;
            // 
            // tbListenPort
            // 
            this.tbListenPort.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbListenPort.FillColor = System.Drawing.Color.White;
            this.tbListenPort.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.tbListenPort.Location = new System.Drawing.Point(128, 14);
            this.tbListenPort.Margin = new System.Windows.Forms.Padding(4);
            this.tbListenPort.Maximum = 2147483647D;
            this.tbListenPort.Minimum = -2147483648D;
            this.tbListenPort.Name = "tbListenPort";
            this.tbListenPort.Padding = new System.Windows.Forms.Padding(5);
            this.tbListenPort.Size = new System.Drawing.Size(77, 26);
            this.tbListenPort.TabIndex = 14;
            this.tbListenPort.TextChanged += new System.EventHandler(this.tbListenPort_TextChanged);
            // 
            // dgvServerClients
            // 
            this.dgvServerClients.AllowUserToAddRows = false;
            this.dgvServerClients.AllowUserToDeleteRows = false;
            this.dgvServerClients.AllowUserToOrderColumns = true;
            this.dgvServerClients.AllowUserToResizeRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvServerClients.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvServerClients.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvServerClients.BackgroundColor = System.Drawing.Color.White;
            this.dgvServerClients.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvServerClients.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvServerClients.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvServerClients.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvServerClients.DefaultCellStyle = dataGridViewCellStyle3;
            this.dgvServerClients.EnableHeadersVisualStyles = false;
            this.dgvServerClients.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvServerClients.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvServerClients.Location = new System.Drawing.Point(3, 72);
            this.dgvServerClients.Margin = new System.Windows.Forms.Padding(4);
            this.dgvServerClients.MultiSelect = false;
            this.dgvServerClients.Name = "dgvServerClients";
            this.dgvServerClients.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvServerClients.RowHeadersVisible = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.White;
            this.dgvServerClients.RowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvServerClients.RowTemplate.Height = 29;
            this.dgvServerClients.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvServerClients.SelectedIndex = -1;
            this.dgvServerClients.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvServerClients.ShowCellErrors = false;
            this.dgvServerClients.ShowCellToolTips = false;
            this.dgvServerClients.ShowEditingIcon = false;
            this.dgvServerClients.ShowRowErrors = false;
            this.dgvServerClients.Size = new System.Drawing.Size(429, 176);
            this.dgvServerClients.TabIndex = 9;
            this.dgvServerClients.TagString = null;
            // 
            // lbListenPort
            // 
            this.lbListenPort.BackColor = System.Drawing.Color.Transparent;
            this.lbListenPort.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbListenPort.Location = new System.Drawing.Point(0, 19);
            this.lbListenPort.Margin = new System.Windows.Forms.Padding(4);
            this.lbListenPort.Name = "lbListenPort";
            this.lbListenPort.Size = new System.Drawing.Size(120, 22);
            this.lbListenPort.TabIndex = 5;
            this.lbListenPort.Text = "Listen Port:";
            this.lbListenPort.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // OVRNetworkManagerForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(464, 411);
            this.Controls.Add(this.gpServer);
            this.Controls.Add(this.btnConnect);
            this.Margin = new System.Windows.Forms.Padding(4);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRNetworkManagerForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Network Manager";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.OVRReportPrintingForm_FormClosing);
            this.Load += new System.EventHandler(this.OVRNetworkManagerForm_Load);
            this.btnConnect.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.tbServerIP)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbConnectedStatus)).EndInit();
            this.gpServer.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pbListenStatus)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvServerClients)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.Controls.GroupPanel btnConnect;
        private UILabel lbServerIP;
        private DevComponents.DotNetBar.Controls.GroupPanel gpServer;
        private UILabel lbListenPort;
        private UIDataGridView dgvServerClients;
        private UILabel lbServerPort;
        private UITextBox tbServerPort;
        private System.Windows.Forms.PictureBox pbConnectedStatus;
        private System.Windows.Forms.PictureBox pbListenStatus;
        private UITextBox tbListenPort;
        private UIButton btnConnectServer;
        private UIButton btnStartListen;
        private DevComponents.Editors.IpAddressInput tbServerIP;
    }
}