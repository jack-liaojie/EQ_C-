using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    partial class frmSetEventStatus
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        #region Windows Form Designer generated code


        private void InitializeComponent()
        {
            this.btnCancel = new DevComponents.DotNetBar.ButtonX();
            this.btnOk = new DevComponents.DotNetBar.ButtonX();
            this.lbEventStatus = new Sunny.UI.UILabel();
            this.CmbStatus = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.TextShortName = new Sunny.UI.UITextBox();
            this.lbEventShortName = new Sunny.UI.UILabel();
            this.TextLongName = new Sunny.UI.UITextBox();
            this.lbEventLongName = new Sunny.UI.UILabel();
            this.SuspendLayout();
            // 
            // btnCancel
            // 
            this.btnCancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnCancel.Image = global::Newauto.OVRDrawArrange.Properties.Resources.cancel_24;
            this.btnCancel.Location = new System.Drawing.Point(200, 130);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(50, 30);
            this.btnCancel.TabIndex = 11;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnOk
            // 
            this.btnOk.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOk.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOk.Image = global::Newauto.OVRDrawArrange.Properties.Resources.ok_24;
            this.btnOk.Location = new System.Drawing.Point(150, 130);
            this.btnOk.Name = "btnOk";
            this.btnOk.Size = new System.Drawing.Size(50, 30);
            this.btnOk.TabIndex = 10;
            this.btnOk.Click += new System.EventHandler(this.btnOk_Click);
            // 
            // lbEventStatus
            // 
            this.lbEventStatus.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbEventStatus.Location = new System.Drawing.Point(11, 85);
            this.lbEventStatus.Name = "lbEventStatus";
            this.lbEventStatus.Size = new System.Drawing.Size(91, 21);
            this.lbEventStatus.Style = Sunny.UI.UIStyle.Custom;
            this.lbEventStatus.TabIndex = 44;
            this.lbEventStatus.Text = "Status:";
            this.lbEventStatus.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // CmbStatus
            // 
            this.CmbStatus.DisplayMember = "Text";
            this.CmbStatus.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.CmbStatus.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.CmbStatus.FormattingEnabled = true;
            this.CmbStatus.ItemHeight = 23;
            this.CmbStatus.Location = new System.Drawing.Point(100, 80);
            this.CmbStatus.Name = "CmbStatus";
            this.CmbStatus.Size = new System.Drawing.Size(142, 29);
            this.CmbStatus.TabIndex = 43;
            // 
            // TextShortName
            // 
            this.TextShortName.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextShortName.Enabled = false;
            this.TextShortName.FillColor = System.Drawing.Color.White;
            this.TextShortName.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.TextShortName.Location = new System.Drawing.Point(100, 43);
            this.TextShortName.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextShortName.Maximum = 2147483647D;
            this.TextShortName.Minimum = -2147483648D;
            this.TextShortName.Name = "TextShortName";
            this.TextShortName.Padding = new System.Windows.Forms.Padding(5);
            this.TextShortName.Size = new System.Drawing.Size(142, 29);
            this.TextShortName.Style = Sunny.UI.UIStyle.Custom;
            this.TextShortName.TabIndex = 46;
            // 
            // lbEventShortName
            // 
            this.lbEventShortName.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbEventShortName.Location = new System.Drawing.Point(11, 46);
            this.lbEventShortName.Name = "lbEventShortName";
            this.lbEventShortName.Size = new System.Drawing.Size(76, 21);
            this.lbEventShortName.Style = Sunny.UI.UIStyle.Custom;
            this.lbEventShortName.TabIndex = 48;
            this.lbEventShortName.Text = "Short Name:";
            this.lbEventShortName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // TextLongName
            // 
            this.TextLongName.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextLongName.Enabled = false;
            this.TextLongName.FillColor = System.Drawing.Color.White;
            this.TextLongName.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.TextLongName.Location = new System.Drawing.Point(100, 43);
            this.TextLongName.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.TextLongName.Maximum = 2147483647D;
            this.TextLongName.Minimum = -2147483648D;
            this.TextLongName.Name = "TextLongName";
            this.TextLongName.Padding = new System.Windows.Forms.Padding(5);
            this.TextLongName.Size = new System.Drawing.Size(142, 29);
            this.TextLongName.Style = Sunny.UI.UIStyle.Custom;
            this.TextLongName.TabIndex = 45;
            // 
            // lbEventLongName
            // 
            this.lbEventLongName.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbEventLongName.Location = new System.Drawing.Point(10, 46);
            this.lbEventLongName.Name = "lbEventLongName";
            this.lbEventLongName.Size = new System.Drawing.Size(76, 21);
            this.lbEventLongName.Style = Sunny.UI.UIStyle.Custom;
            this.lbEventLongName.TabIndex = 47;
            this.lbEventLongName.Text = "Long Name:";
            this.lbEventLongName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // frmSetEventStatus
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(280, 173);
            this.Controls.Add(this.TextShortName);
            this.Controls.Add(this.lbEventShortName);
            this.Controls.Add(this.TextLongName);
            this.Controls.Add(this.lbEventLongName);
            this.Controls.Add(this.lbEventStatus);
            this.Controls.Add(this.CmbStatus);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOk);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmSetEventStatus";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "SetEventStatus";
            this.Load += new System.EventHandler(this.frmfrmSetEventStatus_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnCancel;
        private DevComponents.DotNetBar.ButtonX btnOk;
        private UILabel lbEventStatus;
        private DevComponents.DotNetBar.Controls.ComboBoxEx CmbStatus;
        private UITextBox TextShortName;
        private UILabel lbEventShortName;
        private UITextBox TextLongName;
        private UILabel lbEventLongName;
    }
}