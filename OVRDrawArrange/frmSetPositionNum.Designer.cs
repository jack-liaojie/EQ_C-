using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    partial class frmSetPositionNum
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
            this.tbPosNum = new Sunny.UI.UITextBox();
            this.lbPosNum = new Sunny.UI.UILabel();
            this.btnCancel = new Sunny.UI.UISymbolButton();
            this.btnOk = new Sunny.UI.UISymbolButton();
            this.SuspendLayout();
            // 
            // tbPosNum
            // 
            this.tbPosNum.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.tbPosNum.FillColor = System.Drawing.Color.White;
            this.tbPosNum.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.tbPosNum.Location = new System.Drawing.Point(123, 57);
            this.tbPosNum.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.tbPosNum.Maximum = 2147483647D;
            this.tbPosNum.Minimum = -2147483648D;
            this.tbPosNum.Name = "tbPosNum";
            this.tbPosNum.Padding = new System.Windows.Forms.Padding(5);
            this.tbPosNum.Size = new System.Drawing.Size(115, 29);
            this.tbPosNum.Style = Sunny.UI.UIStyle.Custom;
            this.tbPosNum.TabIndex = 8;
            this.tbPosNum.KeyDown += new System.Windows.Forms.KeyEventHandler(this.tbPosNum_KeyDown);
            // 
            // lbPosNum
            // 
            this.lbPosNum.AutoSize = true;
            this.lbPosNum.BackColor = System.Drawing.Color.Transparent;
            this.lbPosNum.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbPosNum.Location = new System.Drawing.Point(3, 57);
            this.lbPosNum.Name = "lbPosNum";
            this.lbPosNum.Size = new System.Drawing.Size(113, 21);
            this.lbPosNum.Style = Sunny.UI.UIStyle.Custom;
            this.lbPosNum.TabIndex = 7;
            this.lbPosNum.Text = "PositionNum:";
            this.lbPosNum.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // btnCancel
            // 
            this.btnCancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnCancel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnCancel.Location = new System.Drawing.Point(128, 101);
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
            this.btnOk.Location = new System.Drawing.Point(63, 101);
            this.btnOk.Name = "btnOk";
            this.btnOk.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnOk.Size = new System.Drawing.Size(50, 30);
            this.btnOk.Style = Sunny.UI.UIStyle.Custom;
            this.btnOk.TabIndex = 10;
            this.btnOk.Click += new System.EventHandler(this.btnOk_Click);
            // 
            // frmSetPositionNum
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(243, 149);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOk);
            this.Controls.Add(this.tbPosNum);
            this.Controls.Add(this.lbPosNum);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmSetPositionNum";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "SetPositionNum";
            this.Load += new System.EventHandler(this.frmSetPositionNum_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private UITextBox tbPosNum;
        private UILabel lbPosNum;
        private UISymbolButton btnCancel;
        private UISymbolButton btnOk;
    }
}