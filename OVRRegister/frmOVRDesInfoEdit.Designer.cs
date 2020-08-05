using Sunny.UI;

namespace AutoSports.OVRRegister
{
    partial class OVRDesInfoEditForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

          private void InitializeComponent()
        {
            this.lbCode = new Sunny.UI.UILabel();
            this.lbLanguage = new Sunny.UI.UILabel();
            this.lbLongName = new Sunny.UI.UILabel();
            this.lbShortName = new Sunny.UI.UILabel();
            this.lbComment = new Sunny.UI.UILabel();
            this.txCode = new Sunny.UI.UITextBox();
            this.txLongName = new Sunny.UI.UITextBox();
            this.txShortName = new Sunny.UI.UITextBox();
            this.txComment = new Sunny.UI.UITextBox();
            this.btnOK = new Sunny.UI.UISymbolButton();
            this.btnCancel = new Sunny.UI.UISymbolButton();
            this.cmbLanguage = new Sunny.UI.UIComboBox();
            this.labelX1 = new Sunny.UI.UILabel();
            this.labelX2 = new Sunny.UI.UILabel();
            this.lbType = new Sunny.UI.UILabel();
            this.txType = new Sunny.UI.UITextBox();
            this.SuspendLayout();
            // 
            // lbCode
            // 
            this.lbCode.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbCode.Location = new System.Drawing.Point(6, 38);
            this.lbCode.Name = "lbCode";
            this.lbCode.Size = new System.Drawing.Size(75, 21);
            this.lbCode.Style = Sunny.UI.UIStyle.Custom;
            this.lbCode.TabIndex = 0;
            this.lbCode.Text = "Code";
            this.lbCode.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbLanguage
            // 
            this.lbLanguage.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbLanguage.Location = new System.Drawing.Point(6, 38);
            this.lbLanguage.Name = "lbLanguage";
            this.lbLanguage.Size = new System.Drawing.Size(121, 20);
            this.lbLanguage.Style = Sunny.UI.UIStyle.Custom;
            this.lbLanguage.TabIndex = 0;
            this.lbLanguage.Text = "Language";
            this.lbLanguage.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbLongName
            // 
            this.lbLongName.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbLongName.Location = new System.Drawing.Point(6, 70);
            this.lbLongName.Name = "lbLongName";
            this.lbLongName.Size = new System.Drawing.Size(121, 21);
            this.lbLongName.Style = Sunny.UI.UIStyle.Custom;
            this.lbLongName.TabIndex = 0;
            this.lbLongName.Text = "LongName";
            this.lbLongName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbShortName
            // 
            this.lbShortName.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbShortName.Location = new System.Drawing.Point(6, 103);
            this.lbShortName.Name = "lbShortName";
            this.lbShortName.Size = new System.Drawing.Size(121, 21);
            this.lbShortName.Style = Sunny.UI.UIStyle.Custom;
            this.lbShortName.TabIndex = 0;
            this.lbShortName.Text = "ShortName";
            this.lbShortName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbComment
            // 
            this.lbComment.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbComment.Location = new System.Drawing.Point(6, 136);
            this.lbComment.Name = "lbComment";
            this.lbComment.Size = new System.Drawing.Size(121, 21);
            this.lbComment.Style = Sunny.UI.UIStyle.Custom;
            this.lbComment.TabIndex = 0;
            this.lbComment.Text = "Comment";
            this.lbComment.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // txCode
            // 
            this.txCode.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txCode.FillColor = System.Drawing.Color.White;
            this.txCode.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txCode.Location = new System.Drawing.Point(110, 38);
            this.txCode.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txCode.Maximum = 2147483647D;
            this.txCode.Minimum = -2147483648D;
            this.txCode.Name = "txCode";
            this.txCode.Padding = new System.Windows.Forms.Padding(5);
            this.txCode.Size = new System.Drawing.Size(200, 29);
            this.txCode.Style = Sunny.UI.UIStyle.Custom;
            this.txCode.TabIndex = 0;
            // 
            // txLongName
            // 
            this.txLongName.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txLongName.FillColor = System.Drawing.Color.White;
            this.txLongName.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txLongName.Location = new System.Drawing.Point(111, 71);
            this.txLongName.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txLongName.Maximum = 2147483647D;
            this.txLongName.Minimum = -2147483648D;
            this.txLongName.Name = "txLongName";
            this.txLongName.Padding = new System.Windows.Forms.Padding(5);
            this.txLongName.Size = new System.Drawing.Size(199, 29);
            this.txLongName.Style = Sunny.UI.UIStyle.Custom;
            this.txLongName.TabIndex = 2;
            // 
            // txShortName
            // 
            this.txShortName.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txShortName.FillColor = System.Drawing.Color.White;
            this.txShortName.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txShortName.Location = new System.Drawing.Point(111, 104);
            this.txShortName.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txShortName.Maximum = 2147483647D;
            this.txShortName.Minimum = -2147483648D;
            this.txShortName.Name = "txShortName";
            this.txShortName.Padding = new System.Windows.Forms.Padding(5);
            this.txShortName.Size = new System.Drawing.Size(199, 29);
            this.txShortName.Style = Sunny.UI.UIStyle.Custom;
            this.txShortName.TabIndex = 3;
            // 
            // txComment
            // 
            this.txComment.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txComment.FillColor = System.Drawing.Color.White;
            this.txComment.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txComment.Location = new System.Drawing.Point(111, 137);
            this.txComment.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txComment.Maximum = 2147483647D;
            this.txComment.Minimum = -2147483648D;
            this.txComment.Name = "txComment";
            this.txComment.Padding = new System.Windows.Forms.Padding(5);
            this.txComment.Size = new System.Drawing.Size(199, 29);
            this.txComment.Style = Sunny.UI.UIStyle.Custom;
            this.txComment.TabIndex = 4;
            // 
            // btnOK
            // 
            this.btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOK.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnOK.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnOK.Location = new System.Drawing.Point(74, 207);
            this.btnOK.Name = "btnOK";
            this.btnOK.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnOK.Size = new System.Drawing.Size(50, 30);
            this.btnOK.Style = Sunny.UI.UIStyle.Custom;
            this.btnOK.TabIndex = 2;
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // btnCancel
            // 
            this.btnCancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnCancel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnCancel.Location = new System.Drawing.Point(190, 207);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnCancel.Size = new System.Drawing.Size(50, 30);
            this.btnCancel.Style = Sunny.UI.UIStyle.Custom;
            this.btnCancel.Symbol = 61453;
            this.btnCancel.TabIndex = 2;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // cmbLanguage
            // 
            this.cmbLanguage.FillColor = System.Drawing.Color.White;
            this.cmbLanguage.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.cmbLanguage.FormattingEnabled = true;
            this.cmbLanguage.Location = new System.Drawing.Point(111, 38);
            this.cmbLanguage.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cmbLanguage.MinimumSize = new System.Drawing.Size(63, 0);
            this.cmbLanguage.Name = "cmbLanguage";
            this.cmbLanguage.Padding = new System.Windows.Forms.Padding(0, 0, 30, 0);
            this.cmbLanguage.Size = new System.Drawing.Size(199, 29);
            this.cmbLanguage.Style = Sunny.UI.UIStyle.Custom;
            this.cmbLanguage.TabIndex = 1;
            this.cmbLanguage.TextAlignment = System.Drawing.ContentAlignment.MiddleLeft;
            this.cmbLanguage.SelectedValueChanged += new System.EventHandler(this.cmbLanguage_SelectionChangeCommitted);
            // 
            // labelX1
            // 
            this.labelX1.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.labelX1.ForeColor = System.Drawing.Color.Red;
            this.labelX1.Location = new System.Drawing.Point(316, 109);
            this.labelX1.Name = "labelX1";
            this.labelX1.Size = new System.Drawing.Size(10, 21);
            this.labelX1.Style = Sunny.UI.UIStyle.Custom;
            this.labelX1.TabIndex = 5;
            this.labelX1.Text = "*";
            this.labelX1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // labelX2
            // 
            this.labelX2.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.labelX2.ForeColor = System.Drawing.Color.Red;
            this.labelX2.Location = new System.Drawing.Point(316, 81);
            this.labelX2.Name = "labelX2";
            this.labelX2.Size = new System.Drawing.Size(10, 21);
            this.labelX2.Style = Sunny.UI.UIStyle.Custom;
            this.labelX2.TabIndex = 5;
            this.labelX2.Text = "*";
            this.labelX2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbType
            // 
            this.lbType.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbType.Location = new System.Drawing.Point(3, 169);
            this.lbType.Name = "lbType";
            this.lbType.Size = new System.Drawing.Size(121, 21);
            this.lbType.Style = Sunny.UI.UIStyle.Custom;
            this.lbType.TabIndex = 0;
            this.lbType.Text = "Type";
            this.lbType.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // txType
            // 
            this.txType.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txType.FillColor = System.Drawing.Color.White;
            this.txType.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txType.Location = new System.Drawing.Point(110, 170);
            this.txType.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txType.Maximum = 2147483647D;
            this.txType.Minimum = -2147483648D;
            this.txType.Name = "txType";
            this.txType.Padding = new System.Windows.Forms.Padding(5);
            this.txType.Size = new System.Drawing.Size(199, 29);
            this.txType.Style = Sunny.UI.UIStyle.Custom;
            this.txType.TabIndex = 4;
            // 
            // OVRDesInfoEditForm
            // 
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(315, 249);
            this.Controls.Add(this.labelX2);
            this.Controls.Add(this.labelX1);
            this.Controls.Add(this.cmbLanguage);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.txType);
            this.Controls.Add(this.txComment);
            this.Controls.Add(this.txShortName);
            this.Controls.Add(this.txLongName);
            this.Controls.Add(this.lbType);
            this.Controls.Add(this.txCode);
            this.Controls.Add(this.lbComment);
            this.Controls.Add(this.lbShortName);
            this.Controls.Add(this.lbLongName);
            this.Controls.Add(this.lbLanguage);
            this.Controls.Add(this.lbCode);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRDesInfoEditForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "Info";
            this.Load += new System.EventHandler(this.frmOVRDesInfoEdit_Load);
            this.ResumeLayout(false);

        }

        private UILabel lbCode;
        private UILabel lbLanguage;
        private UILabel lbLongName;
        private UILabel lbShortName;
        private UILabel lbComment;
        private UITextBox txCode;
        private UITextBox txLongName;
        private UITextBox txShortName;
        private UITextBox txComment;
        private UISymbolButton btnOK;
        private UISymbolButton btnCancel;
        private UIComboBox cmbLanguage;
        private UILabel labelX1;
        private UILabel labelX2;
        private UILabel lbType;
        private UITextBox txType;
    }
}