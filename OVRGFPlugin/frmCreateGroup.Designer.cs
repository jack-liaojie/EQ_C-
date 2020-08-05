namespace AutoSports.OVRGFPlugin
{
    partial class frmCreateGroup
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
            this.tb_Sides = new System.Windows.Forms.TextBox();
            this.lb_Sides = new System.Windows.Forms.Label();
            this.btnx_OKCreateGroup = new DevComponents.DotNetBar.ButtonX();
            this.btnx_Cancel = new DevComponents.DotNetBar.ButtonX();
            this.SuspendLayout();
            // 
            // tb_Sides
            // 
            this.tb_Sides.Location = new System.Drawing.Point(158, 6);
            this.tb_Sides.MaxLength = 1;
            this.tb_Sides.Name = "tb_Sides";
            this.tb_Sides.Size = new System.Drawing.Size(67, 21);
            this.tb_Sides.TabIndex = 4;
            this.tb_Sides.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tb_Sides_KeyPress);
            // 
            // lb_Sides
            // 
            this.lb_Sides.AutoSize = true;
            this.lb_Sides.Location = new System.Drawing.Point(12, 15);
            this.lb_Sides.Name = "lb_Sides";
            this.lb_Sides.Size = new System.Drawing.Size(95, 12);
            this.lb_Sides.TabIndex = 0;
            this.lb_Sides.Text = "Sides By Group:";
            // 
            // btnx_OKCreateGroup
            // 
            this.btnx_OKCreateGroup.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_OKCreateGroup.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_OKCreateGroup.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.ok_24;
            this.btnx_OKCreateGroup.Location = new System.Drawing.Point(104, 46);
            this.btnx_OKCreateGroup.Name = "btnx_OKCreateGroup";
            this.btnx_OKCreateGroup.Size = new System.Drawing.Size(50, 30);
            this.btnx_OKCreateGroup.TabIndex = 8;
            this.btnx_OKCreateGroup.Click += new System.EventHandler(this.btnx_OKCreateGroup_Click);
            // 
            // btnx_Cancel
            // 
            this.btnx_Cancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_Cancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_Cancel.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.cancel_24;
            this.btnx_Cancel.Location = new System.Drawing.Point(174, 46);
            this.btnx_Cancel.Name = "btnx_Cancel";
            this.btnx_Cancel.Size = new System.Drawing.Size(50, 30);
            this.btnx_Cancel.TabIndex = 8;
            this.btnx_Cancel.Click += new System.EventHandler(this.btnx_Cancel_Click);
            // 
            // frmCreateGroup
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.ClientSize = new System.Drawing.Size(232, 87);
            this.Controls.Add(this.btnx_Cancel);
            this.Controls.Add(this.btnx_OKCreateGroup);
            this.Controls.Add(this.tb_Sides);
            this.Controls.Add(this.lb_Sides);
            this.DoubleBuffered = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmCreateGroup";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmCreateGroup";
            this.Load += new System.EventHandler(this.frmCreateGroup_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox tb_Sides;
        private System.Windows.Forms.Label lb_Sides;
        private DevComponents.DotNetBar.ButtonX btnx_OKCreateGroup;
        private DevComponents.DotNetBar.ButtonX btnx_Cancel;
    }
}