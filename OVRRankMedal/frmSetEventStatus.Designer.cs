using Sunny.UI;

namespace AutoSports.OVRRankMedal
{
    partial class frmSetEventStatus
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;


        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnCancel = new Sunny.UI.UISymbolButton();
            this.btnOk = new Sunny.UI.UISymbolButton();
            this.lbEventStatus = new Sunny.UI.UILabel();
            this.CmbStatus = new Sunny.UI.UIComboBox();
            this.TextShortName = new Sunny.UI.UITextBox();
            this.lbEventShortName = new Sunny.UI.UILabel();
            this.TextLongName = new Sunny.UI.UITextBox();
            this.lbEventLongName = new Sunny.UI.UILabel();
            this.SuspendLayout();
            // 
            // btnCancel
            // 
            this.btnCancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnCancel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnCancel.Location = new System.Drawing.Point(236, 137);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnCancel.Size = new System.Drawing.Size(50, 30);
            this.btnCancel.Style = Sunny.UI.UIStyle.Custom;
            this.btnCancel.Symbol = 61453;
            this.btnCancel.TabIndex = 11;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnOk
            // 
            this.btnOk.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOk.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnOk.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnOk.Location = new System.Drawing.Point(171, 137);
            this.btnOk.Name = "btnOk";
            this.btnOk.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnOk.Size = new System.Drawing.Size(50, 30);
            this.btnOk.Style = Sunny.UI.UIStyle.Custom;
            this.btnOk.TabIndex = 10;
            this.btnOk.Click += new System.EventHandler(this.btnOk_Click);
            // 
            // lbEventStatus
            // 
            this.lbEventStatus.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbEventStatus.Location = new System.Drawing.Point(20, 107);
            this.lbEventStatus.Name = "lbEventStatus";
            this.lbEventStatus.Size = new System.Drawing.Size(117, 21);
            this.lbEventStatus.Style = Sunny.UI.UIStyle.Custom;
            this.lbEventStatus.TabIndex = 44;
            this.lbEventStatus.Text = "Status:";
            this.lbEventStatus.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // CmbStatus
            // 
            this.CmbStatus.DisplayMember = "Text";
            this.CmbStatus.FillColor = System.Drawing.Color.White;
            this.CmbStatus.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.CmbStatus.FormattingEnabled = true;
            this.CmbStatus.ItemHeight = 23;
            this.CmbStatus.Location = new System.Drawing.Point(144, 99);
            this.CmbStatus.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.CmbStatus.MinimumSize = new System.Drawing.Size(63, 0);
            this.CmbStatus.Name = "CmbStatus";
            this.CmbStatus.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.CmbStatus.Size = new System.Drawing.Size(142, 29);
            this.CmbStatus.Style = Sunny.UI.UIStyle.Custom;
            this.CmbStatus.TabIndex = 43;
            this.CmbStatus.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // TextShortName
            // 
            this.TextShortName.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.TextShortName.Enabled = false;
            this.TextShortName.FillColor = System.Drawing.Color.White;
            this.TextShortName.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.TextShortName.Location = new System.Drawing.Point(144, 67);
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
            this.lbEventShortName.Location = new System.Drawing.Point(20, 71);
            this.lbEventShortName.Name = "lbEventShortName";
            this.lbEventShortName.Size = new System.Drawing.Size(117, 21);
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
            this.TextLongName.Location = new System.Drawing.Point(144, 35);
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
            this.lbEventLongName.Location = new System.Drawing.Point(20, 35);
            this.lbEventLongName.Name = "lbEventLongName";
            this.lbEventLongName.Size = new System.Drawing.Size(117, 21);
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
            this.ClientSize = new System.Drawing.Size(301, 179);
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

        private UISymbolButton btnCancel;
        private UISymbolButton btnOk;
        private UILabel lbEventStatus;
        private UIComboBox CmbStatus;
        private UITextBox TextShortName;
        private UILabel lbEventShortName;
        private UITextBox TextLongName;
        private UILabel lbEventLongName;
    }
}