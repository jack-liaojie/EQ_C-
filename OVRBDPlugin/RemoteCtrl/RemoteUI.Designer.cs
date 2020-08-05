namespace RomoteControl
{
    partial class RemoteUI
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
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.chkControlSwitch = new System.Windows.Forms.CheckBox();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // pictureBox1
            // 
            this.pictureBox1.Location = new System.Drawing.Point(0, 22);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(819, 486);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
            this.pictureBox1.TabIndex = 0;
            this.pictureBox1.TabStop = false;
            this.pictureBox1.MouseClick += new System.Windows.Forms.MouseEventHandler(this.OnMouseClick);
            this.pictureBox1.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.OnMouseDbClicked);
            this.pictureBox1.MouseDown += new System.Windows.Forms.MouseEventHandler(this.OnMouseDown);
            this.pictureBox1.MouseEnter += new System.EventHandler(this.OnMouseEnter);
            this.pictureBox1.MouseLeave += new System.EventHandler(this.OnMouseLeave);
            this.pictureBox1.MouseMove += new System.Windows.Forms.MouseEventHandler(this.OnMouseMove);
            this.pictureBox1.MouseUp += new System.Windows.Forms.MouseEventHandler(this.OnMouseUp);
            this.pictureBox1.PreviewKeyDown += new System.Windows.Forms.PreviewKeyDownEventHandler(this.OnKeyDown);
            // 
            // chkControlSwitch
            // 
            this.chkControlSwitch.AutoSize = true;
            this.chkControlSwitch.BackColor = System.Drawing.Color.Transparent;
            this.chkControlSwitch.Location = new System.Drawing.Point(87, 3);
            this.chkControlSwitch.Name = "chkControlSwitch";
            this.chkControlSwitch.Size = new System.Drawing.Size(78, 16);
            this.chkControlSwitch.TabIndex = 1;
            this.chkControlSwitch.Text = " 开启控制";
            this.chkControlSwitch.UseVisualStyleBackColor = false;
            // 
            // RemoteUI
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(819, 504);
            this.Controls.Add(this.chkControlSwitch);
            this.Controls.Add(this.pictureBox1);
            this.KeyPreview = true;
            this.Name = "RemoteUI";
            this.Text = "RemoteUI";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.remoteUIClosing);
            this.Load += new System.EventHandler(this.OnFrameLoaded);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.OnFrameKeyDown);
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(this.OnFrameKeyUp);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.CheckBox chkControlSwitch;
    }
}