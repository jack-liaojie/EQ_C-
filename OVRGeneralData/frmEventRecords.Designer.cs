using Sunny.UI;

namespace AutoSports.OVRGeneralData
{
    partial class OVREventRecordsForm
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
            this.components = new System.ComponentModel.Container();
            this.dgvEventRecords = new UIDataGridView();
            this.SetRecordRegisterMenuStrip = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.MenuSetRegister = new System.Windows.Forms.ToolStripMenuItem();
            this.btnRecordNew = new DevComponents.DotNetBar.ButtonX();
            this.btnRecordDel = new DevComponents.DotNetBar.ButtonX();
            this.dgvRecordValue = new UIDataGridView();
            this.dgvRecordMember = new UIDataGridView();
            this.btnRecordValueDel = new DevComponents.DotNetBar.ButtonX();
            this.btnRecordValueNew = new DevComponents.DotNetBar.ButtonX();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.lbEventRecords = new UILabel();
            this.splitContainer2 = new System.Windows.Forms.SplitContainer();
            this.lbRecordValue = new UILabel();
            this.lbRecordMember = new UILabel();
            ((System.ComponentModel.ISupportInitialize)(this.dgvEventRecords)).BeginInit();
            this.SetRecordRegisterMenuStrip.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvRecordValue)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvRecordMember)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer2)).BeginInit();
            this.splitContainer2.Panel1.SuspendLayout();
            this.splitContainer2.Panel2.SuspendLayout();
            this.splitContainer2.SuspendLayout();
            this.SuspendLayout();
            // 
            // dgvEventRecords
            // 
            this.dgvEventRecords.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.dgvEventRecords.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvEventRecords.ContextMenuStrip = this.SetRecordRegisterMenuStrip;
            this.dgvEventRecords.Location = new System.Drawing.Point(3, 32);
            this.dgvEventRecords.MultiSelect = false;
            this.dgvEventRecords.Name = "dgvEventRecords";
            this.dgvEventRecords.RowTemplate.Height = 23;
            this.dgvEventRecords.Size = new System.Drawing.Size(705, 157);
            this.dgvEventRecords.TabIndex = 0;
            this.dgvEventRecords.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvEventRecords_CellBeginEdit);
            this.dgvEventRecords.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvEventRecords_CellContentClick);
            this.dgvEventRecords.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvEventRecords_CellValueChanged);
            this.dgvEventRecords.SelectionChanged += new System.EventHandler(this.dgvEventRecords_SelectionChanged);
            // 
            // SetRecordRegisterMenuStrip
            // 
            this.SetRecordRegisterMenuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.MenuSetRegister});
            this.SetRecordRegisterMenuStrip.Name = "contextMenuStrip1";
            this.SetRecordRegisterMenuStrip.Size = new System.Drawing.Size(143, 26);
            // 
            // MenuSetRegister
            // 
            this.MenuSetRegister.Name = "MenuSetRegister";
            this.MenuSetRegister.Size = new System.Drawing.Size(152, 22);
            this.MenuSetRegister.Text = "Set Register";
            this.MenuSetRegister.Click += new System.EventHandler(this.MenuSetRegister_Click);
            // 
            // btnRecordNew
            // 
            this.btnRecordNew.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRecordNew.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnRecordNew.Image = global::AutoSports.OVRGeneralData.Properties.Resources.add_16;
            this.btnRecordNew.Location = new System.Drawing.Point(7, 6);
            this.btnRecordNew.Name = "btnRecordNew";
            this.btnRecordNew.Size = new System.Drawing.Size(20, 20);
            this.btnRecordNew.TabIndex = 4;
            this.btnRecordNew.Click += new System.EventHandler(this.btnRecordNew_Click);
            // 
            // btnRecordDel
            // 
            this.btnRecordDel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRecordDel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnRecordDel.Image = global::AutoSports.OVRGeneralData.Properties.Resources.remove_16;
            this.btnRecordDel.Location = new System.Drawing.Point(37, 6);
            this.btnRecordDel.Name = "btnRecordDel";
            this.btnRecordDel.Size = new System.Drawing.Size(20, 20);
            this.btnRecordDel.TabIndex = 6;
            this.btnRecordDel.Click += new System.EventHandler(this.btnRecordDel_Click);
            // 
            // dgvRecordValue
            // 
            this.dgvRecordValue.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.dgvRecordValue.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvRecordValue.Location = new System.Drawing.Point(3, 36);
            this.dgvRecordValue.Name = "dgvRecordValue";
            this.dgvRecordValue.RowTemplate.Height = 23;
            this.dgvRecordValue.Size = new System.Drawing.Size(328, 143);
            this.dgvRecordValue.TabIndex = 0;
            this.dgvRecordValue.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvRecordValue_CellEndEdit);
            // 
            // dgvRecordMember
            // 
            this.dgvRecordMember.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.dgvRecordMember.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvRecordMember.Location = new System.Drawing.Point(3, 36);
            this.dgvRecordMember.Name = "dgvRecordMember";
            this.dgvRecordMember.RowTemplate.Height = 23;
            this.dgvRecordMember.Size = new System.Drawing.Size(367, 143);
            this.dgvRecordMember.TabIndex = 0;
            // 
            // btnRecordValueDel
            // 
            this.btnRecordValueDel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRecordValueDel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnRecordValueDel.Image = global::AutoSports.OVRGeneralData.Properties.Resources.remove_16;
            this.btnRecordValueDel.Location = new System.Drawing.Point(37, 10);
            this.btnRecordValueDel.Name = "btnRecordValueDel";
            this.btnRecordValueDel.Size = new System.Drawing.Size(20, 20);
            this.btnRecordValueDel.TabIndex = 6;
            this.btnRecordValueDel.Click += new System.EventHandler(this.btnRecordValueDel_Click);
            // 
            // btnRecordValueNew
            // 
            this.btnRecordValueNew.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRecordValueNew.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnRecordValueNew.Image = global::AutoSports.OVRGeneralData.Properties.Resources.add_16;
            this.btnRecordValueNew.Location = new System.Drawing.Point(7, 10);
            this.btnRecordValueNew.Name = "btnRecordValueNew";
            this.btnRecordValueNew.Size = new System.Drawing.Size(20, 20);
            this.btnRecordValueNew.TabIndex = 4;
            this.btnRecordValueNew.Click += new System.EventHandler(this.btnRecordValueNew_Click);
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(0, 0);
            this.splitContainer1.Name = "splitContainer1";
            this.splitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.lbEventRecords);
            this.splitContainer1.Panel1.Controls.Add(this.dgvEventRecords);
            this.splitContainer1.Panel1.Controls.Add(this.btnRecordDel);
            this.splitContainer1.Panel1.Controls.Add(this.btnRecordNew);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.splitContainer2);
            this.splitContainer1.Size = new System.Drawing.Size(711, 387);
            this.splitContainer1.SplitterDistance = 192;
            this.splitContainer1.TabIndex = 7;
            // 
            // lbEventRecords
            // 
            this.lbEventRecords.Location = new System.Drawing.Point(74, 6);
            this.lbEventRecords.Name = "lbEventRecords";
            this.lbEventRecords.Size = new System.Drawing.Size(135, 23);
            this.lbEventRecords.TabIndex = 7;
            this.lbEventRecords.Text = "EventRecords:";
            // 
            // splitContainer2
            // 
            this.splitContainer2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer2.Location = new System.Drawing.Point(0, 0);
            this.splitContainer2.Name = "splitContainer2";
            // 
            // splitContainer2.Panel1
            // 
            this.splitContainer2.Panel1.Controls.Add(this.dgvRecordValue);
            this.splitContainer2.Panel1.Controls.Add(this.lbRecordValue);
            this.splitContainer2.Panel1.Controls.Add(this.btnRecordValueDel);
            this.splitContainer2.Panel1.Controls.Add(this.btnRecordValueNew);
            // 
            // splitContainer2.Panel2
            // 
            this.splitContainer2.Panel2.Controls.Add(this.lbRecordMember);
            this.splitContainer2.Panel2.Controls.Add(this.dgvRecordMember);
            this.splitContainer2.Size = new System.Drawing.Size(711, 191);
            this.splitContainer2.SplitterDistance = 334;
            this.splitContainer2.TabIndex = 0;
            // 
            // lbRecordValue
            // 
            this.lbRecordValue.Location = new System.Drawing.Point(74, 10);
            this.lbRecordValue.Name = "lbRecordValue";
            this.lbRecordValue.Size = new System.Drawing.Size(175, 23);
            this.lbRecordValue.TabIndex = 7;
            this.lbRecordValue.Text = "RecordValues:";
            // 
            // lbRecordMember
            // 
            this.lbRecordMember.Location = new System.Drawing.Point(77, 7);
            this.lbRecordMember.Name = "lbRecordMember";
            this.lbRecordMember.Size = new System.Drawing.Size(157, 23);
            this.lbRecordMember.TabIndex = 7;
            this.lbRecordMember.Text = "RecordMember:";
            // 
            // OVREventRecordsForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(711, 387);
            this.Controls.Add(this.splitContainer1);
            this.DoubleBuffered = true;
            this.Name = "OVREventRecordsForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmEventRecords";
            this.Load += new System.EventHandler(this.frmEventRecords_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvEventRecords)).EndInit();
            this.SetRecordRegisterMenuStrip.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvRecordValue)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvRecordMember)).EndInit();
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            this.splitContainer2.Panel1.ResumeLayout(false);
            this.splitContainer2.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer2)).EndInit();
            this.splitContainer2.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private UIDataGridView dgvEventRecords;
        private DevComponents.DotNetBar.ButtonX btnRecordNew;
        private DevComponents.DotNetBar.ButtonX btnRecordDel;
        private UIDataGridView dgvRecordValue;
        private UIDataGridView dgvRecordMember;
        private DevComponents.DotNetBar.ButtonX btnRecordValueDel;
        private DevComponents.DotNetBar.ButtonX btnRecordValueNew;
        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.SplitContainer splitContainer2;
        private UILabel lbEventRecords;
        private UILabel lbRecordMember;
        private UILabel lbRecordValue;
        private System.Windows.Forms.ContextMenuStrip SetRecordRegisterMenuStrip;
        private System.Windows.Forms.ToolStripMenuItem MenuSetRegister;
    }
}