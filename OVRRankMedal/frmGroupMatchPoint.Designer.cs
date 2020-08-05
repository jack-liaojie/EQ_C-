using Sunny.UI;

namespace AutoSports.OVRRankMedal
{
    partial class OVRGroupMatchPointForm
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
            this.lbWinPoints = new Sunny.UI.UILabel();
            this.lbDrawPoints = new Sunny.UI.UILabel();
            this.lbLostPoints = new Sunny.UI.UILabel();
            this.txtWinPoints = new Sunny.UI.UITextBox();
            this.txtDrawPoints = new Sunny.UI.UITextBox();
            this.txtLostPoints = new Sunny.UI.UITextBox();
            this.btnCancel = new DevComponents.DotNetBar.ButtonX();
            this.btnOK = new DevComponents.DotNetBar.ButtonX();
            this.SuspendLayout();
            // 
            // lbWinPoints
            // 
            this.lbWinPoints.AutoSize = true;
            this.lbWinPoints.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbWinPoints.Location = new System.Drawing.Point(8, 53);
            this.lbWinPoints.Name = "lbWinPoints";
            this.lbWinPoints.Size = new System.Drawing.Size(91, 21);
            this.lbWinPoints.TabIndex = 0;
            this.lbWinPoints.Text = "WinPoints:";
            this.lbWinPoints.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbDrawPoints
            // 
            this.lbDrawPoints.AutoSize = true;
            this.lbDrawPoints.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbDrawPoints.Location = new System.Drawing.Point(2, 51);
            this.lbDrawPoints.Name = "lbDrawPoints";
            this.lbDrawPoints.Size = new System.Drawing.Size(101, 21);
            this.lbDrawPoints.TabIndex = 0;
            this.lbDrawPoints.Text = "DrawPoints:";
            this.lbDrawPoints.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbLostPoints
            // 
            this.lbLostPoints.AutoSize = true;
            this.lbLostPoints.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbLostPoints.Location = new System.Drawing.Point(2, 82);
            this.lbLostPoints.Name = "lbLostPoints";
            this.lbLostPoints.Size = new System.Drawing.Size(97, 21);
            this.lbLostPoints.TabIndex = 0;
            this.lbLostPoints.Text = "Lost Points:";
            this.lbLostPoints.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // txtWinPoints
            // 
            this.txtWinPoints.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txtWinPoints.FillColor = System.Drawing.Color.White;
            this.txtWinPoints.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txtWinPoints.Location = new System.Drawing.Point(102, 43);
            this.txtWinPoints.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txtWinPoints.Maximum = 2147483647D;
            this.txtWinPoints.Minimum = -2147483648D;
            this.txtWinPoints.Name = "txtWinPoints";
            this.txtWinPoints.Padding = new System.Windows.Forms.Padding(5);
            this.txtWinPoints.Size = new System.Drawing.Size(197, 29);
            this.txtWinPoints.TabIndex = 1;
            // 
            // txtDrawPoints
            // 
            this.txtDrawPoints.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txtDrawPoints.FillColor = System.Drawing.Color.White;
            this.txtDrawPoints.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txtDrawPoints.Location = new System.Drawing.Point(102, 43);
            this.txtDrawPoints.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txtDrawPoints.Maximum = 2147483647D;
            this.txtDrawPoints.Minimum = -2147483648D;
            this.txtDrawPoints.Name = "txtDrawPoints";
            this.txtDrawPoints.Padding = new System.Windows.Forms.Padding(5);
            this.txtDrawPoints.Size = new System.Drawing.Size(197, 29);
            this.txtDrawPoints.TabIndex = 1;
            // 
            // txtLostPoints
            // 
            this.txtLostPoints.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txtLostPoints.FillColor = System.Drawing.Color.White;
            this.txtLostPoints.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txtLostPoints.Location = new System.Drawing.Point(102, 74);
            this.txtLostPoints.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txtLostPoints.Maximum = 2147483647D;
            this.txtLostPoints.Minimum = -2147483648D;
            this.txtLostPoints.Name = "txtLostPoints";
            this.txtLostPoints.Padding = new System.Windows.Forms.Padding(5);
            this.txtLostPoints.Size = new System.Drawing.Size(197, 29);
            this.txtLostPoints.TabIndex = 1;
            // 
            // btnCancel
            // 
            this.btnCancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnCancel.Image = global::OVRRankMedal.Properties.Resources.cancel_24;
            this.btnCancel.Location = new System.Drawing.Point(200, 120);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(50, 30);
            this.btnCancel.TabIndex = 2;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnOK
            // 
            this.btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOK.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.btnOK.Image = global::OVRRankMedal.Properties.Resources.ok_24;
            this.btnOK.Location = new System.Drawing.Point(120, 120);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(50, 30);
            this.btnOK.TabIndex = 2;
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // OVRGroupMatchPointForm
            // 
            this.ClientSize = new System.Drawing.Size(316, 177);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.txtLostPoints);
            this.Controls.Add(this.txtDrawPoints);
            this.Controls.Add(this.txtWinPoints);
            this.Controls.Add(this.lbLostPoints);
            this.Controls.Add(this.lbDrawPoints);
            this.Controls.Add(this.lbWinPoints);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRGroupMatchPointForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "GroupMatchPoints";
            this.Load += new System.EventHandler(this.FrmGroupMatchPoint_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private UILabel lbWinPoints;
        private UILabel lbDrawPoints;
        private UILabel lbLostPoints;
        private UITextBox txtWinPoints;
        private UITextBox txtDrawPoints;
        private UITextBox txtLostPoints;
        private DevComponents.DotNetBar.ButtonX btnOK;
        private DevComponents.DotNetBar.ButtonX btnCancel;
    }
}