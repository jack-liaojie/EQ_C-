namespace AutoSports.OVRFBPlugin
{
    partial class CardAttributeForm
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
            this.cbCode = new System.Windows.Forms.ComboBox();
            this.chkMissMatch1 = new System.Windows.Forms.CheckBox();
            this.chkMissMatch2 = new System.Windows.Forms.CheckBox();
            this.SuspendLayout();
            // 
            // cbCode
            // 
            this.cbCode.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbCode.FormattingEnabled = true;
            this.cbCode.Location = new System.Drawing.Point(2, 1);
            this.cbCode.Name = "cbCode";
            this.cbCode.Size = new System.Drawing.Size(121, 21);
            this.cbCode.TabIndex = 0;
            // 
            // chkMissMatch1
            // 
            this.chkMissMatch1.AutoSize = true;
            this.chkMissMatch1.Location = new System.Drawing.Point(12, 28);
            this.chkMissMatch1.Name = "chkMissMatch1";
            this.chkMissMatch1.Size = new System.Drawing.Size(80, 17);
            this.chkMissMatch1.TabIndex = 1;
            this.chkMissMatch1.Text = "checkBox1";
            this.chkMissMatch1.UseVisualStyleBackColor = true;
            this.chkMissMatch1.CheckedChanged += new System.EventHandler(this.chkMissMatch1_CheckedChanged);
            // 
            // chkMissMatch2
            // 
            this.chkMissMatch2.AutoSize = true;
            this.chkMissMatch2.Location = new System.Drawing.Point(12, 51);
            this.chkMissMatch2.Name = "chkMissMatch2";
            this.chkMissMatch2.Size = new System.Drawing.Size(80, 17);
            this.chkMissMatch2.TabIndex = 1;
            this.chkMissMatch2.Text = "checkBox1";
            this.chkMissMatch2.UseVisualStyleBackColor = true;
            this.chkMissMatch2.CheckedChanged += new System.EventHandler(this.chkMissMatch2_CheckedChanged);
            // 
            // CardAttributeForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(197, 75);
            this.Controls.Add(this.chkMissMatch2);
            this.Controls.Add(this.chkMissMatch1);
            this.Controls.Add(this.cbCode);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "CardAttributeForm";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "CardAttributeForm";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        public System.Windows.Forms.ComboBox cbCode;
        public System.Windows.Forms.CheckBox chkMissMatch1;
        public System.Windows.Forms.CheckBox chkMissMatch2;

    }
}