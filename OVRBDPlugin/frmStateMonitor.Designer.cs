namespace AutoSports.OVRBDPlugin
{
    partial class frmStateMonitor
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
            this.richTBHeart = new System.Windows.Forms.RichTextBox();
            this.richTBFile = new System.Windows.Forms.RichTextBox();
            this.labelX1 = new DevComponents.DotNetBar.LabelX();
            this.labelX2 = new DevComponents.DotNetBar.LabelX();
            this.btnClearLeft = new DevComponents.DotNetBar.ButtonX();
            this.btnClearRight = new DevComponents.DotNetBar.ButtonX();
            this.SuspendLayout();
            // 
            // richTBHeart
            // 
            this.richTBHeart.BackColor = System.Drawing.Color.White;
            this.richTBHeart.Location = new System.Drawing.Point(8, 43);
            this.richTBHeart.Name = "richTBHeart";
            this.richTBHeart.ReadOnly = true;
            this.richTBHeart.Size = new System.Drawing.Size(312, 387);
            this.richTBHeart.TabIndex = 0;
            this.richTBHeart.Text = "";
            // 
            // richTBFile
            // 
            this.richTBFile.BackColor = System.Drawing.Color.White;
            this.richTBFile.Location = new System.Drawing.Point(335, 43);
            this.richTBFile.Name = "richTBFile";
            this.richTBFile.ReadOnly = true;
            this.richTBFile.Size = new System.Drawing.Size(326, 387);
            this.richTBFile.TabIndex = 2;
            this.richTBFile.Text = "";
            // 
            // labelX1
            // 
            // 
            // 
            // 
            this.labelX1.BackgroundStyle.Class = "";
            this.labelX1.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labelX1.Location = new System.Drawing.Point(12, 14);
            this.labelX1.Name = "labelX1";
            this.labelX1.Size = new System.Drawing.Size(192, 23);
            this.labelX1.TabIndex = 3;
            this.labelX1.Text = "HeartBeat and Error Monitor";
            // 
            // labelX2
            // 
            // 
            // 
            // 
            this.labelX2.BackgroundStyle.Class = "";
            this.labelX2.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labelX2.Location = new System.Drawing.Point(335, 13);
            this.labelX2.Name = "labelX2";
            this.labelX2.Size = new System.Drawing.Size(208, 23);
            this.labelX2.TabIndex = 4;
            this.labelX2.Text = "File Monitor";
            // 
            // btnClearLeft
            // 
            this.btnClearLeft.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnClearLeft.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnClearLeft.Location = new System.Drawing.Point(271, 14);
            this.btnClearLeft.Name = "btnClearLeft";
            this.btnClearLeft.Size = new System.Drawing.Size(50, 23);
            this.btnClearLeft.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnClearLeft.TabIndex = 5;
            this.btnClearLeft.Text = "Clear";
            this.btnClearLeft.Click += new System.EventHandler(this.btnClearLeft_Click);
            // 
            // btnClearRight
            // 
            this.btnClearRight.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnClearRight.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnClearRight.Location = new System.Drawing.Point(611, 13);
            this.btnClearRight.Name = "btnClearRight";
            this.btnClearRight.Size = new System.Drawing.Size(50, 23);
            this.btnClearRight.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnClearRight.TabIndex = 6;
            this.btnClearRight.Text = "Clear";
            this.btnClearRight.Click += new System.EventHandler(this.btnClearRight_Click);
            // 
            // frmStateMonitor
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(673, 446);
            this.Controls.Add(this.btnClearRight);
            this.Controls.Add(this.btnClearLeft);
            this.Controls.Add(this.labelX2);
            this.Controls.Add(this.labelX1);
            this.Controls.Add(this.richTBFile);
            this.Controls.Add(this.richTBHeart);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.Name = "frmStateMonitor";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "frmStateMonitor";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.StateFrmClosing);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.RichTextBox richTBHeart;
        private System.Windows.Forms.RichTextBox richTBFile;
        private DevComponents.DotNetBar.LabelX labelX1;
        private DevComponents.DotNetBar.LabelX labelX2;
        private DevComponents.DotNetBar.ButtonX btnClearLeft;
        private DevComponents.DotNetBar.ButtonX btnClearRight;
    }
}