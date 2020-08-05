namespace AutoSports.OVRWRPlugin
{
    partial class frmOVRWRMatchJudgeConfig
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
            this.components = new System.ComponentModel.Container();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            this.lbTitle = new System.Windows.Forms.Label();
            this.buttonOrderDown = new System.Windows.Forms.Button();
            this.buttonOrderUp = new System.Windows.Forms.Button();
            this.ButtonEdit = new System.Windows.Forms.Button();
            this.buttonDelete = new System.Windows.Forms.Button();
            this.textJudgeFunction = new System.Windows.Forms.TextBox();
            this.textJudgeName = new System.Windows.Forms.TextBox();
            this.buttonAdd = new System.Windows.Forms.Button();
            this.listBoxJudgeName = new System.Windows.Forms.ListBox();
            this.listBoxJudgeFunction = new System.Windows.Forms.ListBox();
            this.lbJudgeFunction = new System.Windows.Forms.Label();
            this.lbJudgeName = new System.Windows.Forms.Label();
            this.ctMenuSMatchJudgeManage = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.addToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.delteToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.changeJudgeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.changeFunctionToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.dataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn2 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn3 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn4 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn5 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn6 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn7 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.panel1 = new System.Windows.Forms.Panel();
            this.gvMatchJudges = new System.Windows.Forms.DataGridView();
            this.ctMenuSMatchJudgeManage.SuspendLayout();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.gvMatchJudges)).BeginInit();
            this.SuspendLayout();
            // 
            // lbTitle
            // 
            this.lbTitle.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.lbTitle.Font = new System.Drawing.Font("Arial", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbTitle.Location = new System.Drawing.Point(0, 5);
            this.lbTitle.Name = "lbTitle";
            this.lbTitle.Size = new System.Drawing.Size(594, 22);
            this.lbTitle.TabIndex = 0;
            this.lbTitle.Text = "Title";
            this.lbTitle.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // buttonOrderDown
            // 
            this.buttonOrderDown.Image = global::AutoSports.OVRWRPlugin.Properties.Resources.Down_24;
            this.buttonOrderDown.Location = new System.Drawing.Point(539, 394);
            this.buttonOrderDown.Name = "buttonOrderDown";
            this.buttonOrderDown.Size = new System.Drawing.Size(48, 42);
            this.buttonOrderDown.TabIndex = 22;
            this.buttonOrderDown.UseVisualStyleBackColor = true;
            this.buttonOrderDown.Click += new System.EventHandler(this.buttonOrderDown_Click);
            // 
            // buttonOrderUp
            // 
            this.buttonOrderUp.Image = global::AutoSports.OVRWRPlugin.Properties.Resources.Up_334;
            this.buttonOrderUp.Location = new System.Drawing.Point(539, 346);
            this.buttonOrderUp.Name = "buttonOrderUp";
            this.buttonOrderUp.Size = new System.Drawing.Size(48, 42);
            this.buttonOrderUp.TabIndex = 21;
            this.buttonOrderUp.UseVisualStyleBackColor = true;
            this.buttonOrderUp.Click += new System.EventHandler(this.buttonOrderUp_Click);
            // 
            // ButtonEdit
            // 
            this.ButtonEdit.Image = global::AutoSports.OVRWRPlugin.Properties.Resources.edit_24;
            this.ButtonEdit.Location = new System.Drawing.Point(539, 281);
            this.ButtonEdit.Name = "ButtonEdit";
            this.ButtonEdit.Size = new System.Drawing.Size(48, 42);
            this.ButtonEdit.TabIndex = 19;
            this.ButtonEdit.UseVisualStyleBackColor = true;
            this.ButtonEdit.Click += new System.EventHandler(this.ButtonEdit_Click);
            // 
            // buttonDelete
            // 
            this.buttonDelete.Image = global::AutoSports.OVRWRPlugin.Properties.Resources.remove_24;
            this.buttonDelete.Location = new System.Drawing.Point(539, 233);
            this.buttonDelete.Name = "buttonDelete";
            this.buttonDelete.Size = new System.Drawing.Size(48, 42);
            this.buttonDelete.TabIndex = 21;
            this.buttonDelete.UseVisualStyleBackColor = true;
            this.buttonDelete.Click += new System.EventHandler(this.buttonDelete_Click);
            // 
            // textJudgeFunction
            // 
            this.textJudgeFunction.Location = new System.Drawing.Point(274, 49);
            this.textJudgeFunction.Name = "textJudgeFunction";
            this.textJudgeFunction.Size = new System.Drawing.Size(256, 21);
            this.textJudgeFunction.TabIndex = 18;
            this.textJudgeFunction.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.textJudgeFunction_KeyPress);
            this.textJudgeFunction.KeyUp += new System.Windows.Forms.KeyEventHandler(this.textJudgeFunction_KeyUp);
            // 
            // textJudgeName
            // 
            this.textJudgeName.Location = new System.Drawing.Point(12, 49);
            this.textJudgeName.Name = "textJudgeName";
            this.textJudgeName.Size = new System.Drawing.Size(256, 21);
            this.textJudgeName.TabIndex = 17;
            this.textJudgeName.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.textJudgeName_KeyPress);
            this.textJudgeName.KeyUp += new System.Windows.Forms.KeyEventHandler(this.textJudgeName_KeyUp);
            // 
            // buttonAdd
            // 
            this.buttonAdd.Image = global::AutoSports.OVRWRPlugin.Properties.Resources.add_24;
            this.buttonAdd.Location = new System.Drawing.Point(539, 185);
            this.buttonAdd.Name = "buttonAdd";
            this.buttonAdd.Size = new System.Drawing.Size(48, 42);
            this.buttonAdd.TabIndex = 20;
            this.buttonAdd.UseVisualStyleBackColor = true;
            this.buttonAdd.Click += new System.EventHandler(this.buttonAdd_Click);
            // 
            // listBoxJudgeName
            // 
            this.listBoxJudgeName.FormattingEnabled = true;
            this.listBoxJudgeName.ItemHeight = 12;
            this.listBoxJudgeName.Location = new System.Drawing.Point(12, 70);
            this.listBoxJudgeName.Name = "listBoxJudgeName";
            this.listBoxJudgeName.Size = new System.Drawing.Size(256, 160);
            this.listBoxJudgeName.TabIndex = 16;
            this.listBoxJudgeName.Click += new System.EventHandler(this.listBoxJudgeName_Click);
            this.listBoxJudgeName.DoubleClick += new System.EventHandler(this.listBoxJudgeName_DoubleClick);
            // 
            // listBoxJudgeFunction
            // 
            this.listBoxJudgeFunction.FormattingEnabled = true;
            this.listBoxJudgeFunction.ItemHeight = 12;
            this.listBoxJudgeFunction.Location = new System.Drawing.Point(274, 70);
            this.listBoxJudgeFunction.Name = "listBoxJudgeFunction";
            this.listBoxJudgeFunction.Size = new System.Drawing.Size(256, 160);
            this.listBoxJudgeFunction.TabIndex = 15;
            this.listBoxJudgeFunction.Click += new System.EventHandler(this.listBoxJudgeFunction_Click);
            this.listBoxJudgeFunction.DoubleClick += new System.EventHandler(this.listBoxJudgeFunction_DoubleClick);
            // 
            // lbJudgeFunction
            // 
            this.lbJudgeFunction.AutoSize = true;
            this.lbJudgeFunction.Font = new System.Drawing.Font("Arial", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbJudgeFunction.Location = new System.Drawing.Point(271, 30);
            this.lbJudgeFunction.Name = "lbJudgeFunction";
            this.lbJudgeFunction.Size = new System.Drawing.Size(67, 16);
            this.lbJudgeFunction.TabIndex = 14;
            this.lbJudgeFunction.Text = "Function:";
            // 
            // lbJudgeName
            // 
            this.lbJudgeName.AutoSize = true;
            this.lbJudgeName.Font = new System.Drawing.Font("Arial", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbJudgeName.Location = new System.Drawing.Point(9, 30);
            this.lbJudgeName.Name = "lbJudgeName";
            this.lbJudgeName.Size = new System.Drawing.Size(48, 16);
            this.lbJudgeName.TabIndex = 13;
            this.lbJudgeName.Text = "Name:";
            // 
            // ctMenuSMatchJudgeManage
            // 
            this.ctMenuSMatchJudgeManage.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.addToolStripMenuItem,
            this.delteToolStripMenuItem,
            this.changeJudgeToolStripMenuItem,
            this.changeFunctionToolStripMenuItem});
            this.ctMenuSMatchJudgeManage.Name = "contextMenuStrip1";
            this.ctMenuSMatchJudgeManage.Size = new System.Drawing.Size(161, 92);
            // 
            // addToolStripMenuItem
            // 
            this.addToolStripMenuItem.Name = "addToolStripMenuItem";
            this.addToolStripMenuItem.Size = new System.Drawing.Size(160, 22);
            this.addToolStripMenuItem.Text = "&Add";
            this.addToolStripMenuItem.Click += new System.EventHandler(this.addToolStripMenuItem_Click);
            // 
            // delteToolStripMenuItem
            // 
            this.delteToolStripMenuItem.Name = "delteToolStripMenuItem";
            this.delteToolStripMenuItem.Size = new System.Drawing.Size(160, 22);
            this.delteToolStripMenuItem.Text = "&Delete";
            // 
            // changeJudgeToolStripMenuItem
            // 
            this.changeJudgeToolStripMenuItem.Name = "changeJudgeToolStripMenuItem";
            this.changeJudgeToolStripMenuItem.Size = new System.Drawing.Size(160, 22);
            this.changeJudgeToolStripMenuItem.Text = "&Change Judge";
            this.changeJudgeToolStripMenuItem.Click += new System.EventHandler(this.changeJudgeToolStripMenuItem_Click);
            // 
            // changeFunctionToolStripMenuItem
            // 
            this.changeFunctionToolStripMenuItem.Name = "changeFunctionToolStripMenuItem";
            this.changeFunctionToolStripMenuItem.Size = new System.Drawing.Size(160, 22);
            this.changeFunctionToolStripMenuItem.Text = "Change &Function";
            this.changeFunctionToolStripMenuItem.Click += new System.EventHandler(this.changeFunctionToolStripMenuItem_Click);
            // 
            // dataGridViewTextBoxColumn1
            // 
            this.dataGridViewTextBoxColumn1.DataPropertyName = "Order";
            this.dataGridViewTextBoxColumn1.HeaderText = "Name";
            this.dataGridViewTextBoxColumn1.Name = "dataGridViewTextBoxColumn1";
            this.dataGridViewTextBoxColumn1.Width = 250;
            // 
            // dataGridViewTextBoxColumn2
            // 
            this.dataGridViewTextBoxColumn2.DataPropertyName = "Name";
            this.dataGridViewTextBoxColumn2.HeaderText = "Function";
            this.dataGridViewTextBoxColumn2.Name = "dataGridViewTextBoxColumn2";
            this.dataGridViewTextBoxColumn2.ReadOnly = true;
            this.dataGridViewTextBoxColumn2.Width = 200;
            // 
            // dataGridViewTextBoxColumn3
            // 
            this.dataGridViewTextBoxColumn3.DataPropertyName = "Function";
            this.dataGridViewTextBoxColumn3.HeaderText = "Function";
            this.dataGridViewTextBoxColumn3.Name = "dataGridViewTextBoxColumn3";
            this.dataGridViewTextBoxColumn3.ReadOnly = true;
            this.dataGridViewTextBoxColumn3.Width = 200;
            // 
            // dataGridViewTextBoxColumn4
            // 
            this.dataGridViewTextBoxColumn4.DataPropertyName = "ServantNum";
            this.dataGridViewTextBoxColumn4.HeaderText = "ServantNum";
            this.dataGridViewTextBoxColumn4.Name = "dataGridViewTextBoxColumn4";
            this.dataGridViewTextBoxColumn4.Visible = false;
            // 
            // dataGridViewTextBoxColumn5
            // 
            this.dataGridViewTextBoxColumn5.DataPropertyName = "RegisterID";
            this.dataGridViewTextBoxColumn5.HeaderText = "RegisterID";
            this.dataGridViewTextBoxColumn5.Name = "dataGridViewTextBoxColumn5";
            this.dataGridViewTextBoxColumn5.Visible = false;
            // 
            // dataGridViewTextBoxColumn6
            // 
            this.dataGridViewTextBoxColumn6.DataPropertyName = "NameWithNOC";
            this.dataGridViewTextBoxColumn6.HeaderText = "NameWithNOC";
            this.dataGridViewTextBoxColumn6.Name = "dataGridViewTextBoxColumn6";
            this.dataGridViewTextBoxColumn6.Visible = false;
            // 
            // dataGridViewTextBoxColumn7
            // 
            this.dataGridViewTextBoxColumn7.DataPropertyName = "FunctionID";
            this.dataGridViewTextBoxColumn7.HeaderText = "FunctionID";
            this.dataGridViewTextBoxColumn7.Name = "dataGridViewTextBoxColumn7";
            this.dataGridViewTextBoxColumn7.Visible = false;
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.gvMatchJudges);
            this.panel1.Location = new System.Drawing.Point(12, 236);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(521, 200);
            this.panel1.TabIndex = 23;
            // 
            // gvMatchJudges
            // 
            this.gvMatchJudges.AllowUserToAddRows = false;
            this.gvMatchJudges.AllowUserToDeleteRows = false;
            this.gvMatchJudges.AllowUserToResizeColumns = false;
            this.gvMatchJudges.AllowUserToResizeRows = false;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.gvMatchJudges.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle1;
            this.gvMatchJudges.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle2.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.gvMatchJudges.DefaultCellStyle = dataGridViewCellStyle2;
            this.gvMatchJudges.Dock = System.Windows.Forms.DockStyle.Fill;
            this.gvMatchJudges.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter;
            this.gvMatchJudges.Location = new System.Drawing.Point(0, 0);
            this.gvMatchJudges.MultiSelect = false;
            this.gvMatchJudges.Name = "gvMatchJudges";
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle3.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.gvMatchJudges.RowHeadersDefaultCellStyle = dataGridViewCellStyle3;
            this.gvMatchJudges.RowHeadersVisible = false;
            this.gvMatchJudges.RowTemplate.Height = 23;
            this.gvMatchJudges.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.gvMatchJudges.Size = new System.Drawing.Size(521, 200);
            this.gvMatchJudges.TabIndex = 15;
            this.gvMatchJudges.CellDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.gvMatchJudges_CellDoubleClick);
            // 
            // frmOVRJUMatchJudgeConfig
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(594, 441);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.buttonOrderDown);
            this.Controls.Add(this.buttonOrderUp);
            this.Controls.Add(this.buttonAdd);
            this.Controls.Add(this.ButtonEdit);
            this.Controls.Add(this.textJudgeFunction);
            this.Controls.Add(this.buttonDelete);
            this.Controls.Add(this.textJudgeName);
            this.Controls.Add(this.lbTitle);
            this.Controls.Add(this.listBoxJudgeFunction);
            this.Controls.Add(this.listBoxJudgeName);
            this.Controls.Add(this.lbJudgeName);
            this.Controls.Add(this.lbJudgeFunction);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmOVRJUMatchJudgeConfig";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Referee and Judges";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.frmOVRWRMatchJudgeConfig_FormClosed);
            this.ctMenuSMatchJudgeManage.ResumeLayout(false);
            this.panel1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.gvMatchJudges)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

		private System.Windows.Forms.Label lbTitle;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn1;
		private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn2;
        private System.Windows.Forms.Button ButtonEdit;
        private System.Windows.Forms.TextBox textJudgeFunction;
        private System.Windows.Forms.TextBox textJudgeName;
        private System.Windows.Forms.ListBox listBoxJudgeName;
        private System.Windows.Forms.ListBox listBoxJudgeFunction;
        private System.Windows.Forms.Label lbJudgeFunction;
        private System.Windows.Forms.Label lbJudgeName;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn3;
        private System.Windows.Forms.ContextMenuStrip ctMenuSMatchJudgeManage;
        private System.Windows.Forms.ToolStripMenuItem addToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem delteToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem changeJudgeToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem changeFunctionToolStripMenuItem;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn4;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn5;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn6;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn7;
        private System.Windows.Forms.Button buttonDelete;
		private System.Windows.Forms.Button buttonAdd;
        private System.Windows.Forms.Button buttonOrderDown;
        private System.Windows.Forms.Button buttonOrderUp;
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.DataGridView gvMatchJudges;
    }
}