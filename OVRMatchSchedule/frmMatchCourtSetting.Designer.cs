using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    partial class MatchCourtSettingForm
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
            this.btnX_Cancel = new DevComponents.DotNetBar.ButtonX();
            this.btnX_OK = new DevComponents.DotNetBar.ButtonX();
            this.labX_Venue = new UILabel();
            this.labX_Court = new UILabel();
            this.cbEx_Venue = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.cbEx_Court = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.SuspendLayout();
            // 
            // btnX_Cancel
            // 
            this.btnX_Cancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Cancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_Cancel.Image = global::Newauto.OVRMatchSchedule.Properties.Resources.cancel_24;
            this.btnX_Cancel.Location = new System.Drawing.Point(188, 70);
            this.btnX_Cancel.Name = "btnX_Cancel";
            this.btnX_Cancel.Size = new System.Drawing.Size(50, 30);
            this.btnX_Cancel.TabIndex = 5;
            this.btnX_Cancel.Click += new System.EventHandler(this.btnX_Cancel_Click);
            // 
            // btnX_OK
            // 
            this.btnX_OK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_OK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_OK.Image = global::Newauto.OVRMatchSchedule.Properties.Resources.ok_24;
            this.btnX_OK.Location = new System.Drawing.Point(130, 70);
            this.btnX_OK.Name = "btnX_OK";
            this.btnX_OK.Size = new System.Drawing.Size(50, 30);
            this.btnX_OK.TabIndex = 4;
            this.btnX_OK.Click += new System.EventHandler(this.btnX_OK_Click);
            // 
            // labX_Venue
            // 
            this.labX_Venue.AutoSize = true;
            this.labX_Venue.Location = new System.Drawing.Point(4, 12);
            this.labX_Venue.Name = "labX_Venue";
            this.labX_Venue.Size = new System.Drawing.Size(44, 16);
            this.labX_Venue.TabIndex = 6;
            this.labX_Venue.Text = "Venue:";
            // 
            // labX_Court
            // 
            this.labX_Court.AutoSize = true;
            this.labX_Court.Location = new System.Drawing.Point(4, 37);
            this.labX_Court.Name = "labX_Court";
            this.labX_Court.Size = new System.Drawing.Size(44, 16);
            this.labX_Court.TabIndex = 7;
            this.labX_Court.Text = "Court:";
            // 
            // cbEx_Venue
            // 
            this.cbEx_Venue.DisplayMember = "Text";
            this.cbEx_Venue.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbEx_Venue.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbEx_Venue.FormattingEnabled = true;
            this.cbEx_Venue.ItemHeight = 15;
            this.cbEx_Venue.Location = new System.Drawing.Point(68, 10);
            this.cbEx_Venue.Name = "cbEx_Venue";
            this.cbEx_Venue.Size = new System.Drawing.Size(170, 21);
            this.cbEx_Venue.TabIndex = 8;
            this.cbEx_Venue.SelectionChangeCommitted += new System.EventHandler(this.cbEx_Venue_SelectionChangeCommitted);
            // 
            // cbEx_Court
            // 
            this.cbEx_Court.DisplayMember = "Text";
            this.cbEx_Court.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbEx_Court.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbEx_Court.FormattingEnabled = true;
            this.cbEx_Court.ItemHeight = 15;
            this.cbEx_Court.Location = new System.Drawing.Point(68, 35);
            this.cbEx_Court.Name = "cbEx_Court";
            this.cbEx_Court.Size = new System.Drawing.Size(170, 21);
            this.cbEx_Court.TabIndex = 9;
            this.cbEx_Court.SelectionChangeCommitted += new System.EventHandler(this.cbEx_Court_SelectionChangeCommitted);
            // 
            // MatchCourtSettingForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(242, 103);
            this.Controls.Add(this.cbEx_Court);
            this.Controls.Add(this.cbEx_Venue);
            this.Controls.Add(this.labX_Court);
            this.Controls.Add(this.labX_Venue);
            this.Controls.Add(this.btnX_Cancel);
            this.Controls.Add(this.btnX_OK);
            
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "MatchCourtSettingForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "MatchCourtSetting";
            this.Load += new System.EventHandler(this.MatchCourtSettingForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnX_Cancel;
        private DevComponents.DotNetBar.ButtonX btnX_OK;
        private UILabel labX_Venue;
        private UILabel labX_Court;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbEx_Venue;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbEx_Court;

    }
}