using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    partial class MatchDateSettingForm
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
            this.labX_Date = new Sunny.UI.UILabel();
            this.cbEx_Date = new Sunny.UI.UIComboBox();
            this.btnX_OK = new Sunny.UI.UISymbolButton();
            this.btnX_Cancel = new Sunny.UI.UISymbolButton();
            this.SuspendLayout();
            // 
            // labX_Date
            // 
            this.labX_Date.AutoSize = true;
            this.labX_Date.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.labX_Date.Location = new System.Drawing.Point(2, 45);
            this.labX_Date.Name = "labX_Date";
            this.labX_Date.Size = new System.Drawing.Size(50, 21);
            this.labX_Date.Style = Sunny.UI.UIStyle.Custom;
            this.labX_Date.TabIndex = 0;
            this.labX_Date.Text = "Date:";
            this.labX_Date.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // cbEx_Date
            // 
            this.cbEx_Date.DisplayMember = "Text";
            this.cbEx_Date.FillColor = System.Drawing.Color.White;
            this.cbEx_Date.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cbEx_Date.FormattingEnabled = true;
            this.cbEx_Date.ItemHeight = 23;
            this.cbEx_Date.Location = new System.Drawing.Point(68, 41);
            this.cbEx_Date.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cbEx_Date.MinimumSize = new System.Drawing.Size(63, 0);
            this.cbEx_Date.Name = "cbEx_Date";
            this.cbEx_Date.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cbEx_Date.Size = new System.Drawing.Size(170, 29);
            this.cbEx_Date.Style = Sunny.UI.UIStyle.Custom;
            this.cbEx_Date.TabIndex = 1;
            this.cbEx_Date.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            this.cbEx_Date.SelectedValueChanged += new System.EventHandler(this.cbEx_Date_SelectionChangeCommitted);
            // 
            // btnX_OK
            // 
            this.btnX_OK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_OK.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnX_OK.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnX_OK.Location = new System.Drawing.Point(129, 90);
            this.btnX_OK.Name = "btnX_OK";
            this.btnX_OK.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnX_OK.Size = new System.Drawing.Size(50, 30);
            this.btnX_OK.Style = Sunny.UI.UIStyle.Custom;
            this.btnX_OK.TabIndex = 2;
            this.btnX_OK.Click += new System.EventHandler(this.btnX_OK_Click);
            // 
            // btnX_Cancel
            // 
            this.btnX_Cancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Cancel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnX_Cancel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnX_Cancel.Location = new System.Drawing.Point(185, 90);
            this.btnX_Cancel.Name = "btnX_Cancel";
            this.btnX_Cancel.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnX_Cancel.Size = new System.Drawing.Size(50, 30);
            this.btnX_Cancel.Style = Sunny.UI.UIStyle.Custom;
            this.btnX_Cancel.Symbol = 61453;
            this.btnX_Cancel.TabIndex = 3;
            this.btnX_Cancel.Click += new System.EventHandler(this.btnX_Cancel_Click);
            // 
            // MatchDateSettingForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(253, 131);
            this.Controls.Add(this.btnX_Cancel);
            this.Controls.Add(this.btnX_OK);
            this.Controls.Add(this.cbEx_Date);
            this.Controls.Add(this.labX_Date);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "MatchDateSettingForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "MatchDateSetting";
            this.Load += new System.EventHandler(this.MatchDateSettingForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private UILabel labX_Date;
        private UIComboBox cbEx_Date;
        private UISymbolButton btnX_OK;
        private UISymbolButton btnX_Cancel;
    }
}