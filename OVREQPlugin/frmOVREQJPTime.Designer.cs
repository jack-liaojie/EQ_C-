using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    partial class OVREQJPTimeForm
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
            this.btnX_OK = new Sunny.UI.UIButton();
            this.btnX_Cancel = new Sunny.UI.UIButton();
            this.labX_CorrectTime = new Sunny.UI.UILabel();
            this.labX_PauseTime = new Sunny.UI.UILabel();
            this.txt_PauseTime = new Sunny.UI.UITextBox();
            this.txt_CorrectTime = new Sunny.UI.UITextBox();
            this.labX_FinalTime = new Sunny.UI.UILabel();
            this.txt_FinalTime = new Sunny.UI.UITextBox();
            this.SuspendLayout();
            // 
            // btnX_OK
            // 
            this.btnX_OK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_OK.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnX_OK.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnX_OK.Location = new System.Drawing.Point(51, 162);
            this.btnX_OK.Name = "btnX_OK";
            this.btnX_OK.Size = new System.Drawing.Size(92, 23);
            this.btnX_OK.TabIndex = 1;
            this.btnX_OK.Text = "OK";
            this.btnX_OK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // btnX_Cancel
            // 
            this.btnX_Cancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Cancel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnX_Cancel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnX_Cancel.Location = new System.Drawing.Point(188, 162);
            this.btnX_Cancel.Name = "btnX_Cancel";
            this.btnX_Cancel.Size = new System.Drawing.Size(92, 23);
            this.btnX_Cancel.TabIndex = 2;
            this.btnX_Cancel.Text = "Cancel";
            this.btnX_Cancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // labX_CorrectTime
            // 
            this.labX_CorrectTime.AutoSize = true;
            this.labX_CorrectTime.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.labX_CorrectTime.Location = new System.Drawing.Point(18, 76);
            this.labX_CorrectTime.Name = "labX_CorrectTime";
            this.labX_CorrectTime.Size = new System.Drawing.Size(112, 21);
            this.labX_CorrectTime.TabIndex = 12;
            this.labX_CorrectTime.Text = "Correct Time:";
            this.labX_CorrectTime.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // labX_PauseTime
            // 
            this.labX_PauseTime.AutoSize = true;
            this.labX_PauseTime.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.labX_PauseTime.Location = new System.Drawing.Point(29, 40);
            this.labX_PauseTime.Name = "labX_PauseTime";
            this.labX_PauseTime.Size = new System.Drawing.Size(101, 21);
            this.labX_PauseTime.TabIndex = 10;
            this.labX_PauseTime.Text = "Pause Time:";
            this.labX_PauseTime.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // txt_PauseTime
            // 
            this.txt_PauseTime.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txt_PauseTime.FillColor = System.Drawing.Color.White;
            this.txt_PauseTime.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txt_PauseTime.Location = new System.Drawing.Point(153, 40);
            this.txt_PauseTime.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txt_PauseTime.Maximum = 2147483647D;
            this.txt_PauseTime.Minimum = -2147483648D;
            this.txt_PauseTime.Name = "txt_PauseTime";
            this.txt_PauseTime.Padding = new System.Windows.Forms.Padding(5);
            this.txt_PauseTime.Size = new System.Drawing.Size(127, 29);
            this.txt_PauseTime.TabIndex = 13;
            this.txt_PauseTime.Validating += new System.ComponentModel.CancelEventHandler(this.txt_PauseTime_Validating);
            this.txt_PauseTime.Validated += new System.EventHandler(this.txt_PauseTime_Validated);
            // 
            // txt_CorrectTime
            // 
            this.txt_CorrectTime.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txt_CorrectTime.FillColor = System.Drawing.Color.White;
            this.txt_CorrectTime.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txt_CorrectTime.Location = new System.Drawing.Point(153, 76);
            this.txt_CorrectTime.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txt_CorrectTime.Maximum = 2147483647D;
            this.txt_CorrectTime.Minimum = -2147483648D;
            this.txt_CorrectTime.Name = "txt_CorrectTime";
            this.txt_CorrectTime.Padding = new System.Windows.Forms.Padding(5);
            this.txt_CorrectTime.Size = new System.Drawing.Size(127, 29);
            this.txt_CorrectTime.TabIndex = 14;
            this.txt_CorrectTime.Validating += new System.ComponentModel.CancelEventHandler(this.txt_CorrectTime_Validating);
            this.txt_CorrectTime.Validated += new System.EventHandler(this.txt_CorrectTime_Validated);
            // 
            // labX_FinalTime
            // 
            this.labX_FinalTime.AutoSize = true;
            this.labX_FinalTime.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.labX_FinalTime.Location = new System.Drawing.Point(38, 112);
            this.labX_FinalTime.Name = "labX_FinalTime";
            this.labX_FinalTime.Size = new System.Drawing.Size(92, 21);
            this.labX_FinalTime.TabIndex = 15;
            this.labX_FinalTime.Text = "Final Time:";
            this.labX_FinalTime.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // txt_FinalTime
            // 
            this.txt_FinalTime.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.txt_FinalTime.FillColor = System.Drawing.Color.White;
            this.txt_FinalTime.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.txt_FinalTime.Location = new System.Drawing.Point(153, 112);
            this.txt_FinalTime.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.txt_FinalTime.Maximum = 2147483647D;
            this.txt_FinalTime.Minimum = -2147483648D;
            this.txt_FinalTime.Name = "txt_FinalTime";
            this.txt_FinalTime.Padding = new System.Windows.Forms.Padding(5);
            this.txt_FinalTime.ReadOnly = true;
            this.txt_FinalTime.Size = new System.Drawing.Size(127, 29);
            this.txt_FinalTime.TabIndex = 16;
            // 
            // OVREQJPTimeForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(305, 198);
            this.Controls.Add(this.txt_FinalTime);
            this.Controls.Add(this.labX_FinalTime);
            this.Controls.Add(this.txt_CorrectTime);
            this.Controls.Add(this.labX_CorrectTime);
            this.Controls.Add(this.labX_PauseTime);
            this.Controls.Add(this.btnX_Cancel);
            this.Controls.Add(this.btnX_OK);
            this.Controls.Add(this.txt_PauseTime);
            this.Name = "OVREQJPTimeForm";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private UIButton btnX_OK;
        private UIButton btnX_Cancel;
        public UILabel labX_CorrectTime;
        public UILabel labX_PauseTime;
        private UITextBox txt_PauseTime;
        private UITextBox txt_CorrectTime;
        public UILabel labX_FinalTime;
        private UITextBox txt_FinalTime;
    }
}