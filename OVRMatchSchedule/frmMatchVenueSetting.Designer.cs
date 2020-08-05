using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    partial class MatchVenueSettingForm
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
            this.btnX_Cancel = new Sunny.UI.UISymbolButton();
            this.btnX_OK = new Sunny.UI.UISymbolButton();
            this.labX_Venue = new Sunny.UI.UILabel();
            this.cbEx_Venue = new Sunny.UI.UIComboBox();
            this.SuspendLayout();
            // 
            // btnX_Cancel
            // 
            this.btnX_Cancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Cancel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnX_Cancel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnX_Cancel.Location = new System.Drawing.Point(188, 75);
            this.btnX_Cancel.Name = "btnX_Cancel";
            this.btnX_Cancel.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnX_Cancel.Size = new System.Drawing.Size(50, 30);
            this.btnX_Cancel.Style = Sunny.UI.UIStyle.Custom;
            this.btnX_Cancel.Symbol = 61453;
            this.btnX_Cancel.TabIndex = 5;
            this.btnX_Cancel.Click += new System.EventHandler(this.btnX_Cancel_Click);
            // 
            // btnX_OK
            // 
            this.btnX_OK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_OK.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnX_OK.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnX_OK.Location = new System.Drawing.Point(132, 75);
            this.btnX_OK.Name = "btnX_OK";
            this.btnX_OK.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnX_OK.Size = new System.Drawing.Size(50, 30);
            this.btnX_OK.Style = Sunny.UI.UIStyle.Custom;
            this.btnX_OK.TabIndex = 4;
            this.btnX_OK.Click += new System.EventHandler(this.btnX_OK_Click);
            // 
            // labX_Venue
            // 
            this.labX_Venue.AutoSize = true;
            this.labX_Venue.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.labX_Venue.Location = new System.Drawing.Point(2, 40);
            this.labX_Venue.Name = "labX_Venue";
            this.labX_Venue.Size = new System.Drawing.Size(63, 21);
            this.labX_Venue.Style = Sunny.UI.UIStyle.Custom;
            this.labX_Venue.TabIndex = 6;
            this.labX_Venue.Text = "Venue:";
            this.labX_Venue.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // cbEx_Venue
            // 
            this.cbEx_Venue.DisplayMember = "Text";
            this.cbEx_Venue.FillColor = System.Drawing.Color.White;
            this.cbEx_Venue.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cbEx_Venue.FormattingEnabled = true;
            this.cbEx_Venue.ItemHeight = 23;
            this.cbEx_Venue.Location = new System.Drawing.Point(68, 40);
            this.cbEx_Venue.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cbEx_Venue.MinimumSize = new System.Drawing.Size(63, 0);
            this.cbEx_Venue.Name = "cbEx_Venue";
            this.cbEx_Venue.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cbEx_Venue.Size = new System.Drawing.Size(170, 29);
            this.cbEx_Venue.Style = Sunny.UI.UIStyle.Custom;
            this.cbEx_Venue.TabIndex = 7;
            this.cbEx_Venue.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            this.cbEx_Venue.SelectedValueChanged += new System.EventHandler(this.cbEx_Venue_SelectionChangeCommitted);
            // 
            // MatchVenueSettingForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(247, 115);
            this.Controls.Add(this.cbEx_Venue);
            this.Controls.Add(this.labX_Venue);
            this.Controls.Add(this.btnX_Cancel);
            this.Controls.Add(this.btnX_OK);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "MatchVenueSettingForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "MatchVenueSetting";
            this.Load += new System.EventHandler(this.MatchVenueSettingForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private UISymbolButton btnX_Cancel;
        private UISymbolButton btnX_OK;
        private UILabel labX_Venue;
        private UIComboBox cbEx_Venue;
    }
}