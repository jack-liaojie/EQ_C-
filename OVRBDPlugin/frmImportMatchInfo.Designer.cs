namespace AutoSports.OVRBDPlugin
{
    partial class frmImportMatchInfo
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            this.dgMatchInfo = new DevComponents.DotNetBar.Controls.DataGridViewX();
            this.btnRefreshMatch = new DevComponents.DotNetBar.ButtonX();
            this.btnImportMatch = new DevComponents.DotNetBar.ButtonX();
            this.btnImportAllAction = new DevComponents.DotNetBar.ButtonX();
            this.btnOpenXml = new DevComponents.DotNetBar.ButtonX();
            ((System.ComponentModel.ISupportInitialize)(this.dgMatchInfo)).BeginInit();
            this.SuspendLayout();
            // 
            // dgMatchInfo
            // 
            this.dgMatchInfo.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgMatchInfo.DefaultCellStyle = dataGridViewCellStyle1;
            this.dgMatchInfo.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(208)))), ((int)(((byte)(215)))), ((int)(((byte)(229)))));
            this.dgMatchInfo.Location = new System.Drawing.Point(2, 45);
            this.dgMatchInfo.Name = "dgMatchInfo";
            this.dgMatchInfo.RowTemplate.Height = 23;
            this.dgMatchInfo.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgMatchInfo.Size = new System.Drawing.Size(732, 369);
            this.dgMatchInfo.TabIndex = 0;
            // 
            // btnRefreshMatch
            // 
            this.btnRefreshMatch.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRefreshMatch.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnRefreshMatch.Location = new System.Drawing.Point(649, 1);
            this.btnRefreshMatch.Name = "btnRefreshMatch";
            this.btnRefreshMatch.Size = new System.Drawing.Size(75, 38);
            this.btnRefreshMatch.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnRefreshMatch.TabIndex = 1;
            this.btnRefreshMatch.Text = "Refesh";
            this.btnRefreshMatch.Click += new System.EventHandler(this.btnRefreshMatch_Click);
            // 
            // btnImportMatch
            // 
            this.btnImportMatch.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnImportMatch.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnImportMatch.Location = new System.Drawing.Point(2, 4);
            this.btnImportMatch.Name = "btnImportMatch";
            this.btnImportMatch.Size = new System.Drawing.Size(90, 35);
            this.btnImportMatch.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnImportMatch.TabIndex = 2;
            this.btnImportMatch.Text = "Import";
            this.btnImportMatch.Click += new System.EventHandler(this.btnImportMatch_Click);
            // 
            // btnImportAllAction
            // 
            this.btnImportAllAction.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnImportAllAction.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnImportAllAction.Location = new System.Drawing.Point(98, 4);
            this.btnImportAllAction.Name = "btnImportAllAction";
            this.btnImportAllAction.Size = new System.Drawing.Size(107, 35);
            this.btnImportAllAction.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnImportAllAction.TabIndex = 3;
            this.btnImportAllAction.Text = "ImportActionAll";
            this.btnImportAllAction.Click += new System.EventHandler(this.btnImportAllAction_Click);
            // 
            // btnOpenXml
            // 
            this.btnOpenXml.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnOpenXml.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnOpenXml.Location = new System.Drawing.Point(551, 1);
            this.btnOpenXml.Name = "btnOpenXml";
            this.btnOpenXml.Size = new System.Drawing.Size(83, 38);
            this.btnOpenXml.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnOpenXml.TabIndex = 4;
            this.btnOpenXml.Text = "View File";
            this.btnOpenXml.Click += new System.EventHandler(this.btnOpenXml_Click);
            // 
            // frmImportMatchInfo
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(736, 420);
            this.Controls.Add(this.btnOpenXml);
            this.Controls.Add(this.btnImportAllAction);
            this.Controls.Add(this.btnImportMatch);
            this.Controls.Add(this.btnRefreshMatch);
            this.Controls.Add(this.dgMatchInfo);
            this.Name = "frmImportMatchInfo";
            this.Text = "frmImportMatchInfo";
            this.Load += new System.EventHandler(this.frmImportMatchInfoLoaded);
            ((System.ComponentModel.ISupportInitialize)(this.dgMatchInfo)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.Controls.DataGridViewX dgMatchInfo;
        private DevComponents.DotNetBar.ButtonX btnRefreshMatch;
        private DevComponents.DotNetBar.ButtonX btnImportMatch;
        private DevComponents.DotNetBar.ButtonX btnImportAllAction;
        private DevComponents.DotNetBar.ButtonX btnOpenXml;
    }
}