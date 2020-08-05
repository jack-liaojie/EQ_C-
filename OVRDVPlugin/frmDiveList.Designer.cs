namespace OVRDVPlugin
{
    partial class DiveListForm
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
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel4 = new System.Windows.Forms.Panel();
            this.dgvMatchDiveList = new System.Windows.Forms.DataGridView();
            this.panel3 = new System.Windows.Forms.Panel();
            this.panel5 = new System.Windows.Forms.Panel();
            this.btnOK = new DevComponents.DotNetBar.ButtonX();
            this.btnCancle = new DevComponents.DotNetBar.ButtonX();
            this.panel2 = new System.Windows.Forms.Panel();
            this.lb_FixedDifficultyValue = new System.Windows.Forms.Label();
            this.lb_FixedSplits = new System.Windows.Forms.Label();
            this.btn_SetFixedDiveInfo = new DevComponents.DotNetBar.ButtonX();
            this.lb_FixedDifficulty = new System.Windows.Forms.Label();
            this.lb_FixedRound = new System.Windows.Forms.Label();
            this.btn_CreateDiveList = new DevComponents.DotNetBar.ButtonX();
            this.btn_CleanDiveList = new DevComponents.DotNetBar.ButtonX();
            this.btnOutputDiveList = new DevComponents.DotNetBar.ButtonX();
            this.btnImportDiveList = new DevComponents.DotNetBar.ButtonX();
            this.saveResultDlg = new System.Windows.Forms.SaveFileDialog();
            this.btnUpdateFixDofD = new DevComponents.DotNetBar.ButtonX();
            this.btnUpdateDofDByHeight = new DevComponents.DotNetBar.ButtonX();
            this.btnCopyFromPrevious = new DevComponents.DotNetBar.ButtonX();
            this.panel1.SuspendLayout();
            this.panel4.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchDiveList)).BeginInit();
            this.panel3.SuspendLayout();
            this.panel5.SuspendLayout();
            this.panel2.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.panel4);
            this.panel1.Controls.Add(this.panel3);
            this.panel1.Controls.Add(this.panel2);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(1121, 593);
            this.panel1.TabIndex = 0;
            // 
            // panel4
            // 
            this.panel4.Controls.Add(this.dgvMatchDiveList);
            this.panel4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel4.Location = new System.Drawing.Point(0, 47);
            this.panel4.Name = "panel4";
            this.panel4.Size = new System.Drawing.Size(1121, 502);
            this.panel4.TabIndex = 27;
            // 
            // dgvMatchDiveList
            // 
            this.dgvMatchDiveList.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchDiveList.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgvMatchDiveList.Location = new System.Drawing.Point(0, 0);
            this.dgvMatchDiveList.MultiSelect = false;
            this.dgvMatchDiveList.Name = "dgvMatchDiveList";
            this.dgvMatchDiveList.RowTemplate.Height = 23;
            this.dgvMatchDiveList.Size = new System.Drawing.Size(1121, 502);
            this.dgvMatchDiveList.TabIndex = 22;
            this.dgvMatchDiveList.CellDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchDiveList_CellDoubleClick);
            // 
            // panel3
            // 
            this.panel3.Controls.Add(this.btnCopyFromPrevious);
            this.panel3.Controls.Add(this.btnUpdateDofDByHeight);
            this.panel3.Controls.Add(this.btnUpdateFixDofD);
            this.panel3.Controls.Add(this.btnImportDiveList);
            this.panel3.Controls.Add(this.btnOutputDiveList);
            this.panel3.Controls.Add(this.panel5);
            this.panel3.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel3.Location = new System.Drawing.Point(0, 549);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(1121, 44);
            this.panel3.TabIndex = 26;
            // 
            // panel5
            // 
            this.panel5.Controls.Add(this.btnOK);
            this.panel5.Controls.Add(this.btnCancle);
            this.panel5.Dock = System.Windows.Forms.DockStyle.Right;
            this.panel5.Location = new System.Drawing.Point(881, 0);
            this.panel5.Name = "panel5";
            this.panel5.Size = new System.Drawing.Size(240, 44);
            this.panel5.TabIndex = 22;
            // 
            // btnOK
            // 
            this.btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOK.Location = new System.Drawing.Point(54, 6);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(86, 30);
            this.btnOK.TabIndex = 20;
            this.btnOK.Text = "OK";
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // btnCancle
            // 
            this.btnCancle.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCancle.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnCancle.Location = new System.Drawing.Point(146, 6);
            this.btnCancle.Name = "btnCancle";
            this.btnCancle.Size = new System.Drawing.Size(86, 30);
            this.btnCancle.TabIndex = 21;
            this.btnCancle.Text = "Cancle";
            this.btnCancle.Click += new System.EventHandler(this.btnCancle_Click);
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.lb_FixedDifficultyValue);
            this.panel2.Controls.Add(this.lb_FixedSplits);
            this.panel2.Controls.Add(this.btn_SetFixedDiveInfo);
            this.panel2.Controls.Add(this.lb_FixedDifficulty);
            this.panel2.Controls.Add(this.lb_FixedRound);
            this.panel2.Controls.Add(this.btn_CreateDiveList);
            this.panel2.Controls.Add(this.btn_CleanDiveList);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel2.Location = new System.Drawing.Point(0, 0);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(1121, 47);
            this.panel2.TabIndex = 25;
            // 
            // lb_FixedDifficultyValue
            // 
            this.lb_FixedDifficultyValue.AutoSize = true;
            this.lb_FixedDifficultyValue.Font = new System.Drawing.Font("Arial", 11F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_FixedDifficultyValue.Location = new System.Drawing.Point(1014, 16);
            this.lb_FixedDifficultyValue.Name = "lb_FixedDifficultyValue";
            this.lb_FixedDifficultyValue.Size = new System.Drawing.Size(0, 18);
            this.lb_FixedDifficultyValue.TabIndex = 51;
            // 
            // lb_FixedSplits
            // 
            this.lb_FixedSplits.AutoSize = true;
            this.lb_FixedSplits.Font = new System.Drawing.Font("Arial", 11F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lb_FixedSplits.Location = new System.Drawing.Point(645, 16);
            this.lb_FixedSplits.Name = "lb_FixedSplits";
            this.lb_FixedSplits.Size = new System.Drawing.Size(0, 18);
            this.lb_FixedSplits.TabIndex = 50;
            // 
            // btn_SetFixedDiveInfo
            // 
            this.btn_SetFixedDiveInfo.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_SetFixedDiveInfo.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btn_SetFixedDiveInfo.Location = new System.Drawing.Point(301, 12);
            this.btn_SetFixedDiveInfo.Name = "btn_SetFixedDiveInfo";
            this.btn_SetFixedDiveInfo.Size = new System.Drawing.Size(146, 30);
            this.btn_SetFixedDiveInfo.TabIndex = 49;
            this.btn_SetFixedDiveInfo.Text = "Fixed Dive Info";
            this.btn_SetFixedDiveInfo.Click += new System.EventHandler(this.btn_SetFixedDiveInfo_Click);
            // 
            // lb_FixedDifficulty
            // 
            this.lb_FixedDifficulty.AutoSize = true;
            this.lb_FixedDifficulty.Location = new System.Drawing.Point(835, 20);
            this.lb_FixedDifficulty.Name = "lb_FixedDifficulty";
            this.lb_FixedDifficulty.Size = new System.Drawing.Size(173, 12);
            this.lb_FixedDifficulty.TabIndex = 48;
            this.lb_FixedDifficulty.Text = "Fixed Dive Difficulty Value:";
            // 
            // lb_FixedRound
            // 
            this.lb_FixedRound.AutoSize = true;
            this.lb_FixedRound.Location = new System.Drawing.Point(466, 20);
            this.lb_FixedRound.Name = "lb_FixedRound";
            this.lb_FixedRound.Size = new System.Drawing.Size(173, 12);
            this.lb_FixedRound.TabIndex = 47;
            this.lb_FixedRound.Text = "Fixed Dive Difficulty Round:";
            // 
            // btn_CreateDiveList
            // 
            this.btn_CreateDiveList.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_CreateDiveList.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btn_CreateDiveList.Location = new System.Drawing.Point(12, 12);
            this.btn_CreateDiveList.Name = "btn_CreateDiveList";
            this.btn_CreateDiveList.Size = new System.Drawing.Size(131, 30);
            this.btn_CreateDiveList.TabIndex = 23;
            this.btn_CreateDiveList.Text = "Create Dive List";
            this.btn_CreateDiveList.Click += new System.EventHandler(this.btn_CreateDiveList_Click);
            // 
            // btn_CleanDiveList
            // 
            this.btn_CleanDiveList.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btn_CleanDiveList.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btn_CleanDiveList.Location = new System.Drawing.Point(149, 12);
            this.btn_CleanDiveList.Name = "btn_CleanDiveList";
            this.btn_CleanDiveList.Size = new System.Drawing.Size(146, 30);
            this.btn_CleanDiveList.TabIndex = 24;
            this.btn_CleanDiveList.Text = "Clean Dive List";
            this.btn_CleanDiveList.Click += new System.EventHandler(this.btn_CleanDiveList_Click);
            // 
            // btnOutputDiveList
            // 
            this.btnOutputDiveList.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOutputDiveList.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOutputDiveList.Location = new System.Drawing.Point(12, 6);
            this.btnOutputDiveList.Name = "btnOutputDiveList";
            this.btnOutputDiveList.Size = new System.Drawing.Size(131, 30);
            this.btnOutputDiveList.TabIndex = 24;
            this.btnOutputDiveList.Text = "Output Dive List";
            this.btnOutputDiveList.Click += new System.EventHandler(this.btnOutputDiveList_Click);
            // 
            // btnImportDiveList
            // 
            this.btnImportDiveList.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnImportDiveList.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnImportDiveList.Location = new System.Drawing.Point(164, 6);
            this.btnImportDiveList.Name = "btnImportDiveList";
            this.btnImportDiveList.Size = new System.Drawing.Size(131, 30);
            this.btnImportDiveList.TabIndex = 25;
            this.btnImportDiveList.Text = "Import Dive List";
            this.btnImportDiveList.Click += new System.EventHandler(this.btnImportDiveList_Click);
            // 
            // saveResultDlg
            // 
            this.saveResultDlg.DefaultExt = "csv";
            this.saveResultDlg.Filter = "CSVFile(*.csv)|*.csv|TextFile(*.txt)|*.txt|AllFiles(*.*)|*.*";
            // 
            // btnUpdateFixDofD
            // 
            this.btnUpdateFixDofD.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnUpdateFixDofD.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnUpdateFixDofD.Location = new System.Drawing.Point(468, 6);
            this.btnUpdateFixDofD.Name = "btnUpdateFixDofD";
            this.btnUpdateFixDofD.Size = new System.Drawing.Size(131, 30);
            this.btnUpdateFixDofD.TabIndex = 26;
            this.btnUpdateFixDofD.Text = "Update Fix DofD";
            this.btnUpdateFixDofD.Click += new System.EventHandler(this.btnUpdateFixDofD_Click);
            // 
            // btnUpdateDofDByHeight
            // 
            this.btnUpdateDofDByHeight.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnUpdateDofDByHeight.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnUpdateDofDByHeight.Location = new System.Drawing.Point(316, 6);
            this.btnUpdateDofDByHeight.Name = "btnUpdateDofDByHeight";
            this.btnUpdateDofDByHeight.Size = new System.Drawing.Size(131, 30);
            this.btnUpdateDofDByHeight.TabIndex = 27;
            this.btnUpdateDofDByHeight.Text = "Update DofD By Height";
            this.btnUpdateDofDByHeight.Click += new System.EventHandler(this.btnUpdateDofDByHeight_Click);
            // 
            // btnCopyFromPrevious
            // 
            this.btnCopyFromPrevious.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnCopyFromPrevious.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnCopyFromPrevious.Location = new System.Drawing.Point(622, 6);
            this.btnCopyFromPrevious.Name = "btnCopyFromPrevious";
            this.btnCopyFromPrevious.Size = new System.Drawing.Size(131, 30);
            this.btnCopyFromPrevious.TabIndex = 28;
            this.btnCopyFromPrevious.Text = "Copy from Previous";
            this.btnCopyFromPrevious.Click += new System.EventHandler(this.btnCopyFromPrevious_Click);
            // 
            // DiveListForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1121, 593);
            this.Controls.Add(this.panel1);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "DiveListForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Match Dive List";
            this.panel1.ResumeLayout(false);
            this.panel4.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchDiveList)).EndInit();
            this.panel3.ResumeLayout(false);
            this.panel5.ResumeLayout(false);
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private DevComponents.DotNetBar.ButtonX btn_CleanDiveList;
        private DevComponents.DotNetBar.ButtonX btn_CreateDiveList;
        private System.Windows.Forms.DataGridView dgvMatchDiveList;
        private DevComponents.DotNetBar.ButtonX btnCancle;
        private DevComponents.DotNetBar.ButtonX btnOK;
        private System.Windows.Forms.Panel panel4;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Panel panel5;
        private System.Windows.Forms.Label lb_FixedDifficulty;
        private System.Windows.Forms.Label lb_FixedRound;
        private DevComponents.DotNetBar.ButtonX btn_SetFixedDiveInfo;
        private System.Windows.Forms.Label lb_FixedDifficultyValue;
        private System.Windows.Forms.Label lb_FixedSplits;
        private DevComponents.DotNetBar.ButtonX btnImportDiveList;
        private DevComponents.DotNetBar.ButtonX btnOutputDiveList;
        private System.Windows.Forms.SaveFileDialog saveResultDlg;
        private DevComponents.DotNetBar.ButtonX btnUpdateDofDByHeight;
        private DevComponents.DotNetBar.ButtonX btnUpdateFixDofD;
        private DevComponents.DotNetBar.ButtonX btnCopyFromPrevious;

    }
}