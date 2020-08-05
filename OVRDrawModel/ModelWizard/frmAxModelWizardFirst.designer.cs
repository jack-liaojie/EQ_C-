using Sunny.UI;

namespace AutoSports.OVRDrawModel
{
    partial class AxModelWizardFirstForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.cbType = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbPic = new UILabel();
            this.SuspendLayout();
            // 
            // cbType
            // 
            this.cbType.DisplayMember = "Text";
            this.cbType.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbType.FormattingEnabled = true;
            this.cbType.ItemHeight = 15;
            this.cbType.Location = new System.Drawing.Point(8, 8);
            this.cbType.Name = "cbType";
            this.cbType.Size = new System.Drawing.Size(364, 21);
            this.cbType.TabIndex = 0;
            this.cbType.SelectedIndexChanged += new System.EventHandler(this.cbType_SelectedIndexChanged);
            // 
            // lbPic
            // 
            this.lbPic.Image = global::AutoSports.OVRDrawModel.Properties.Resources.KnockOut;
            this.lbPic.Location = new System.Drawing.Point(8, 44);
            this.lbPic.Name = "lbPic";
            this.lbPic.Size = new System.Drawing.Size(364, 175);
            this.lbPic.TabIndex = 1;
            this.lbPic.Text = "Pic";
            // 
            // AxModelWizardFirstForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(380, 232);
            this.Controls.Add(this.lbPic);
            this.Controls.Add(this.cbType);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "AxModelWizardFirstForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "ModelWizardFirstForm";
            this.Load += new System.EventHandler(this.AxModelWizardFirstForm_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.Controls.ComboBoxEx cbType;
        private UILabel lbPic;
    }
}