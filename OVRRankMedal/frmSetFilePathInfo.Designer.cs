using Sunny.UI;

namespace AutoSports.OVRRankMedal
{
    partial class OVRSetFilePathInfoForm
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
            this.lbExportPath = new Sunny.UI.UILabel();
            this.lbExportName = new Sunny.UI.UILabel();
            this.txtExportPath = new Sunny.UI.UITextBox();
            this.txtExportName = new Sunny.UI.UITextBox();
            this.btnSelectPath = new Sunny.UI.UISymbolButton();
            this.btnOK = new Sunny.UI.UISymbolButton();
            this.SuspendLayout();
            // 
            // lbExportPath
            // 
            this.lbExportPath.AutoSize = true;
            this.lbExportPath.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbExportPath.Location = new System.Drawing.Point(3, 43);
            this.lbExportPath.Name = "lbExportPath";
            this.lbExportPath.Size = new System.Drawing.Size(98, 21);
            this.lbExportPath.TabIndex = 0;
            this.lbExportPath.Text = "ExportPath:";
            this.lbExportPath.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lbExportName
            // 
            this.lbExportName.AutoSize = true;
            this.lbExportName.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.lbExportName.Location = new System.Drawing.Point(3, 86);
            this.lbExportName.Name = "lbExportName";
            this.lbExportName.Size = new System.Drawing.Size(109, 21);
            this.lbExportName.TabIndex = 0;
            this.lbExportName.Text = "ExportName:";
            this.lbExportName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // txtExportPath
            // 
            this.txtExportPath.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txtExportPath.FillColor = System.Drawing.Color.White;
            this.txtExportPath.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txtExportPath.Location = new System.Drawing.Point(108, 43);
            this.txtExportPath.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txtExportPath.Maximum = 2147483647D;
            this.txtExportPath.Minimum = -2147483648D;
            this.txtExportPath.Name = "txtExportPath";
            this.txtExportPath.Padding = new System.Windows.Forms.Padding(5);
            this.txtExportPath.Size = new System.Drawing.Size(250, 29);
            this.txtExportPath.TabIndex = 1;
            // 
            // txtExportName
            // 
            this.txtExportName.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txtExportName.FillColor = System.Drawing.Color.White;
            this.txtExportName.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txtExportName.Location = new System.Drawing.Point(110, 78);
            this.txtExportName.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txtExportName.Maximum = 2147483647D;
            this.txtExportName.Minimum = -2147483648D;
            this.txtExportName.Name = "txtExportName";
            this.txtExportName.Padding = new System.Windows.Forms.Padding(5);
            this.txtExportName.Size = new System.Drawing.Size(217, 29);
            this.txtExportName.TabIndex = 1;
            // 
            // btnSelectPath
            // 
            this.btnSelectPath.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnSelectPath.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnSelectPath.Font = new System.Drawing.Font("Tahoma", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnSelectPath.Location = new System.Drawing.Point(365, 43);
            this.btnSelectPath.Name = "btnSelectPath";
            this.btnSelectPath.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnSelectPath.Size = new System.Drawing.Size(40, 21);
            this.btnSelectPath.Symbol = 61761;
            this.btnSelectPath.TabIndex = 2;
            // 
            // btnOK
            // 
            this.btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOK.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnOK.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.btnOK.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnOK.Location = new System.Drawing.Point(355, 77);
            this.btnOK.Name = "btnOK";
            this.btnOK.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnOK.Size = new System.Drawing.Size(50, 30);
            this.btnOK.TabIndex = 2;
            // 
            // OVRSetFilePathInfoForm
            // 
            this.ClientSize = new System.Drawing.Size(417, 117);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.btnSelectPath);
            this.Controls.Add(this.txtExportName);
            this.Controls.Add(this.txtExportPath);
            this.Controls.Add(this.lbExportName);
            this.Controls.Add(this.lbExportPath);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "OVRSetFilePathInfoForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "SelectExportFile";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private UILabel lbExportPath;
        private UILabel lbExportName;
        private UITextBox txtExportPath;
        private UITextBox txtExportName;
        private UISymbolButton btnSelectPath;
        private UISymbolButton btnOK;
    }
}