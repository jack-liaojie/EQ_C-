using Sunny.UI;

namespace AutoSports.OVRDrawModel
{
    partial class AxDrawModelEditForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;


        #region Windows Form Designer generated code

        private void InitializeComponent()
        {
            this.lbTitle = new UILabel();
            this.lbType = new UILabel();
            this.lbNumber = new UILabel();
            this.lbRank = new UILabel();
            this.tbTitle = new UITextBox();
            this.cbType = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.cbNumber = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.cbRank = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.chbBracket = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.chbBegol = new DevComponents.DotNetBar.Controls.CheckBoxX();
            this.btnOk = new DevComponents.DotNetBar.ButtonX();
            this.btnCancel = new DevComponents.DotNetBar.ButtonX();
            this.SuspendLayout();
            // 
            // lbTitle
            // 
            this.lbTitle.AutoSize = true;
            this.lbTitle.BackColor = System.Drawing.Color.Transparent;
            this.lbTitle.Location = new System.Drawing.Point(6, 8);
            this.lbTitle.Name = "lbTitle";
            this.lbTitle.Size = new System.Drawing.Size(44, 16);
            this.lbTitle.TabIndex = 5;
            this.lbTitle.Text = "Title:";
            // 
            // lbType
            // 
            this.lbType.AutoSize = true;
            this.lbType.BackColor = System.Drawing.Color.Transparent;
            this.lbType.Location = new System.Drawing.Point(6, 40);
            this.lbType.Name = "lbType";
            this.lbType.Size = new System.Drawing.Size(37, 16);
            this.lbType.TabIndex = 5;
            this.lbType.Text = "Type:";
            // 
            // lbNumber
            // 
            this.lbNumber.AutoSize = true;
            this.lbNumber.BackColor = System.Drawing.Color.Transparent;
            this.lbNumber.Location = new System.Drawing.Point(6, 76);
            this.lbNumber.Name = "lbNumber";
            this.lbNumber.Size = new System.Drawing.Size(50, 16);
            this.lbNumber.TabIndex = 5;
            this.lbNumber.Text = "Number:";
            // 
            // lbRank
            // 
            this.lbRank.AutoSize = true;
            this.lbRank.BackColor = System.Drawing.Color.Transparent;
            this.lbRank.Location = new System.Drawing.Point(6, 107);
            this.lbRank.Name = "lbRank";
            this.lbRank.Size = new System.Drawing.Size(37, 16);
            this.lbRank.TabIndex = 5;
            this.lbRank.Text = "Rank:";
            // 
            // tbTitle
            // 
            // 
            // 
            // 
            this.tbTitle.Location = new System.Drawing.Point(57, 6);
            this.tbTitle.Name = "tbTitle";
            this.tbTitle.Size = new System.Drawing.Size(186, 21);
            this.tbTitle.TabIndex = 6;
            // 
            // cbType
            // 
            this.cbType.DisplayMember = "Text";
            this.cbType.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbType.FormattingEnabled = true;
            this.cbType.ItemHeight = 15;
            this.cbType.Location = new System.Drawing.Point(57, 38);
            this.cbType.Name = "cbType";
            this.cbType.Size = new System.Drawing.Size(186, 21);
            this.cbType.TabIndex = 7;
            this.cbType.SelectedIndexChanged += new System.EventHandler(this.cbType_SelectedIndexChanged);
            // 
            // cbNumber
            // 
            this.cbNumber.DisplayMember = "Text";
            this.cbNumber.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbNumber.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbNumber.FormattingEnabled = true;
            this.cbNumber.ItemHeight = 15;
            this.cbNumber.Location = new System.Drawing.Point(57, 74);
            this.cbNumber.Name = "cbNumber";
            this.cbNumber.Size = new System.Drawing.Size(186, 21);
            this.cbNumber.TabIndex = 7;
            // 
            // cbRank
            // 
            this.cbRank.DisplayMember = "Text";
            this.cbRank.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbRank.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbRank.FormattingEnabled = true;
            this.cbRank.ItemHeight = 15;
            this.cbRank.Location = new System.Drawing.Point(57, 105);
            this.cbRank.Name = "cbRank";
            this.cbRank.Size = new System.Drawing.Size(186, 21);
            this.cbRank.TabIndex = 7;
            // 
            // chbBracket
            // 
            this.chbBracket.AutoSize = true;
            this.chbBracket.Location = new System.Drawing.Point(54, 132);
            this.chbBracket.Name = "chbBracket";
            this.chbBracket.Size = new System.Drawing.Size(70, 16);
            this.chbBracket.TabIndex = 8;
            this.chbBracket.Text = "Bracket";
            this.chbBracket.Visible = false;
            // 
            // chbBegol
            // 
            this.chbBegol.AutoSize = true;
            this.chbBegol.Location = new System.Drawing.Point(138, 132);
            this.chbBegol.Name = "chbBegol";
            this.chbBegol.Size = new System.Drawing.Size(76, 16);
            this.chbBegol.TabIndex = 8;
            this.chbBegol.Text = "UseBegol";
            // 
            // btnOk
            // 
            this.btnOk.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOk.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOk.Image = global::AutoSports.OVRDrawModel.Properties.Resources.ok_24;
            this.btnOk.Location = new System.Drawing.Point(56, 161);
            this.btnOk.Name = "btnOk";
            this.btnOk.Size = new System.Drawing.Size(50, 30);
            this.btnOk.TabIndex = 9;
            this.btnOk.Click += new System.EventHandler(this.btnOk_Click);
            // 
            // btnCancel
            // 
            this.btnCancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnCancel.Image = global::AutoSports.OVRDrawModel.Properties.Resources.cancel_24;
            this.btnCancel.Location = new System.Drawing.Point(135, 162);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(50, 30);
            this.btnCancel.TabIndex = 9;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // AxDrawModelEditForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(246, 196);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOk);
            this.Controls.Add(this.chbBegol);
            this.Controls.Add(this.chbBracket);
            this.Controls.Add(this.cbRank);
            this.Controls.Add(this.cbNumber);
            this.Controls.Add(this.cbType);
            this.Controls.Add(this.tbTitle);
            this.Controls.Add(this.lbRank);
            this.Controls.Add(this.lbNumber);
            this.Controls.Add(this.lbType);
            this.Controls.Add(this.lbTitle);
            
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "AxDrawModelEditForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "DrawModelProSet";
            this.Load += new System.EventHandler(this.AxDrawModelEditForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private UILabel lbTitle;
        private UILabel lbType;
        private UILabel lbNumber;
        private UILabel lbRank;
        private UITextBox tbTitle;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbType;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbNumber;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbRank;
        private DevComponents.DotNetBar.Controls.CheckBoxX chbBracket;
        private DevComponents.DotNetBar.Controls.CheckBoxX chbBegol;
        private DevComponents.DotNetBar.ButtonX btnOk;
        private DevComponents.DotNetBar.ButtonX btnCancel;
    }
}