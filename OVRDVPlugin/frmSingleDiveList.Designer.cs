namespace OVRDVPlugin
{
    partial class SingleDiveListForm
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
            this.dgvSingleDiveList = new System.Windows.Forms.DataGridView();
            this.btnCancle = new DevComponents.DotNetBar.ButtonX();
            this.btnOK = new DevComponents.DotNetBar.ButtonX();
            this.lb_RegisterDes = new System.Windows.Forms.Label();
            this.lb_FixedDifficultyValue = new System.Windows.Forms.Label();
            this.lb_FixedSplits = new System.Windows.Forms.Label();
            this.lb_FixedDifficulty = new System.Windows.Forms.Label();
            this.lb_FixedRound = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.dgvSingleDiveList)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvSingleDiveList
            // 
            this.dgvSingleDiveList.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvSingleDiveList.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvSingleDiveList.Location = new System.Drawing.Point(7, 81);
            this.dgvSingleDiveList.Name = "dgvSingleDiveList";
            this.dgvSingleDiveList.RowTemplate.Height = 23;
            this.dgvSingleDiveList.Size = new System.Drawing.Size(767, 101);
            this.dgvSingleDiveList.TabIndex = 0;
            this.dgvSingleDiveList.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvSingleDiveList_CellValueChanged);
            // 
            // btnCancle
            // 
            this.btnCancle.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancle.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnCancle.Location = new System.Drawing.Point(692, 188);
            this.btnCancle.Name = "btnCancle";
            this.btnCancle.Size = new System.Drawing.Size(50, 30);
            this.btnCancle.TabIndex = 16;
            this.btnCancle.Text = "Cancle";
            this.btnCancle.Click += new System.EventHandler(this.btnCancle_Click);
            // 
            // btnOK
            // 
            this.btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOK.Location = new System.Drawing.Point(631, 188);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(50, 30);
            this.btnOK.TabIndex = 15;
            this.btnOK.Text = "OK";
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // lb_RegisterDes
            // 
            this.lb_RegisterDes.AutoSize = true;
            this.lb_RegisterDes.Font = new System.Drawing.Font("Arial", 11F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_RegisterDes.Location = new System.Drawing.Point(4, 14);
            this.lb_RegisterDes.Name = "lb_RegisterDes";
            this.lb_RegisterDes.Size = new System.Drawing.Size(97, 18);
            this.lb_RegisterDes.TabIndex = 49;
            this.lb_RegisterDes.Text = "RegisterDes";
            // 
            // lb_FixedDifficultyValue
            // 
            this.lb_FixedDifficultyValue.AutoSize = true;
            this.lb_FixedDifficultyValue.Font = new System.Drawing.Font("Arial", 11F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_FixedDifficultyValue.Location = new System.Drawing.Point(670, 42);
            this.lb_FixedDifficultyValue.Name = "lb_FixedDifficultyValue";
            this.lb_FixedDifficultyValue.Size = new System.Drawing.Size(0, 18);
            this.lb_FixedDifficultyValue.TabIndex = 55;
            // 
            // lb_FixedSplits
            // 
            this.lb_FixedSplits.AutoSize = true;
            this.lb_FixedSplits.Font = new System.Drawing.Font("Arial", 11F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_FixedSplits.Location = new System.Drawing.Point(301, 42);
            this.lb_FixedSplits.Name = "lb_FixedSplits";
            this.lb_FixedSplits.Size = new System.Drawing.Size(0, 18);
            this.lb_FixedSplits.TabIndex = 54;
            // 
            // lb_FixedDifficulty
            // 
            this.lb_FixedDifficulty.AutoSize = true;
            this.lb_FixedDifficulty.Location = new System.Drawing.Point(491, 46);
            this.lb_FixedDifficulty.Name = "lb_FixedDifficulty";
            this.lb_FixedDifficulty.Size = new System.Drawing.Size(173, 12);
            this.lb_FixedDifficulty.TabIndex = 53;
            this.lb_FixedDifficulty.Text = "Fixed Dive Difficulty Value:";
            // 
            // lb_FixedRound
            // 
            this.lb_FixedRound.AutoSize = true;
            this.lb_FixedRound.Location = new System.Drawing.Point(122, 46);
            this.lb_FixedRound.Name = "lb_FixedRound";
            this.lb_FixedRound.Size = new System.Drawing.Size(173, 12);
            this.lb_FixedRound.TabIndex = 52;
            this.lb_FixedRound.Text = "Fixed Dive Difficulty Round:";
            // 
            // SingleDiveListForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(774, 219);
            this.Controls.Add(this.lb_FixedDifficultyValue);
            this.Controls.Add(this.lb_FixedSplits);
            this.Controls.Add(this.lb_FixedDifficulty);
            this.Controls.Add(this.lb_FixedRound);
            this.Controls.Add(this.lb_RegisterDes);
            this.Controls.Add(this.btnCancle);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.dgvSingleDiveList);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "SingleDiveListForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Single Player Dive List";
            ((System.ComponentModel.ISupportInitialize)(this.dgvSingleDiveList)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvSingleDiveList;
        private DevComponents.DotNetBar.ButtonX btnCancle;
        private DevComponents.DotNetBar.ButtonX btnOK;
        private System.Windows.Forms.Label lb_RegisterDes;
        private System.Windows.Forms.Label lb_FixedDifficultyValue;
        private System.Windows.Forms.Label lb_FixedSplits;
        private System.Windows.Forms.Label lb_FixedDifficulty;
        private System.Windows.Forms.Label lb_FixedRound;
    }
}