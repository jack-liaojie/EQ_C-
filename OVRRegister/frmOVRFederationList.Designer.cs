using Sunny.UI;

namespace AutoSports.OVRRegister
{
    partial class OVRFederationListForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        //protected override void Dispose(bool disposing)
        //{
        //    if (disposing && (components != null))
        //    {
        //        components.Dispose();
        //    }
        //    base.Dispose(disposing);
        //}

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            this.btnUpdate = new Sunny.UI.UISymbolButton();
            this.btnAdd = new Sunny.UI.UISymbolButton();
            this.btnEdit = new Sunny.UI.UISymbolButton();
            this.btnDel = new Sunny.UI.UISymbolButton();
            this.dgvFederation = new Sunny.UI.UIDataGridView();
            this.btnActive = new Sunny.UI.UIButton();
            this.btnNonActive = new Sunny.UI.UIButton();
            ((System.ComponentModel.ISupportInitialize)(this.dgvFederation)).BeginInit();
            this.SuspendLayout();
            // 
            // btnUpdate
            // 
            this.btnUpdate.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnUpdate.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnUpdate.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnUpdate.Location = new System.Drawing.Point(3, 38);
            this.btnUpdate.Name = "btnUpdate";
            this.btnUpdate.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnUpdate.Size = new System.Drawing.Size(76, 30);
            this.btnUpdate.Style = Sunny.UI.UIStyle.Custom;
            this.btnUpdate.Symbol = 61473;
            this.btnUpdate.TabIndex = 0;
            this.btnUpdate.Click += new System.EventHandler(this.btnUpdate_Click);
            // 
            // btnAdd
            // 
            this.btnAdd.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAdd.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnAdd.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnAdd.Location = new System.Drawing.Point(90, 38);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnAdd.Size = new System.Drawing.Size(76, 30);
            this.btnAdd.Style = Sunny.UI.UIStyle.Custom;
            this.btnAdd.Symbol = 61543;
            this.btnAdd.TabIndex = 0;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // btnEdit
            // 
            this.btnEdit.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnEdit.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnEdit.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnEdit.Location = new System.Drawing.Point(177, 38);
            this.btnEdit.Name = "btnEdit";
            this.btnEdit.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnEdit.Size = new System.Drawing.Size(76, 30);
            this.btnEdit.Style = Sunny.UI.UIStyle.Custom;
            this.btnEdit.Symbol = 61508;
            this.btnEdit.TabIndex = 0;
            this.btnEdit.Click += new System.EventHandler(this.btnEdit_Click);
            // 
            // btnDel
            // 
            this.btnDel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnDel.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnDel.Location = new System.Drawing.Point(264, 38);
            this.btnDel.Name = "btnDel";
            this.btnDel.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnDel.Size = new System.Drawing.Size(76, 30);
            this.btnDel.Style = Sunny.UI.UIStyle.Custom;
            this.btnDel.Symbol = 61544;
            this.btnDel.TabIndex = 0;
            this.btnDel.Click += new System.EventHandler(this.btnDel_Click);
            // 
            // dgvFederation
            // 
            this.dgvFederation.AllowUserToAddRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvFederation.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvFederation.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvFederation.BackgroundColor = System.Drawing.Color.White;
            this.dgvFederation.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvFederation.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvFederation.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvFederation.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvFederation.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.dgvFederation.EnableHeadersVisualStyles = false;
            this.dgvFederation.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvFederation.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvFederation.Location = new System.Drawing.Point(2, 74);
            this.dgvFederation.Name = "dgvFederation";
            this.dgvFederation.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvFederation.RowHeadersVisible = false;
            dataGridViewCellStyle3.BackColor = System.Drawing.Color.White;
            this.dgvFederation.RowsDefaultCellStyle = dataGridViewCellStyle3;
            this.dgvFederation.RowTemplate.Height = 29;
            this.dgvFederation.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvFederation.SelectedIndex = -1;
            this.dgvFederation.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvFederation.Size = new System.Drawing.Size(895, 502);
            this.dgvFederation.Style = Sunny.UI.UIStyle.Custom;
            this.dgvFederation.TabIndex = 0;
            this.dgvFederation.TagString = null;
            this.dgvFederation.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvFederation_CellBeginEdit);
            this.dgvFederation.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvFederation_CellValueChanged);
            // 
            // btnActive
            // 
            this.btnActive.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnActive.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnActive.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnActive.Location = new System.Drawing.Point(351, 38);
            this.btnActive.Name = "btnActive";
            this.btnActive.Size = new System.Drawing.Size(76, 30);
            this.btnActive.Style = Sunny.UI.UIStyle.Custom;
            this.btnActive.TabIndex = 0;
            this.btnActive.Text = "批次激活";
            this.btnActive.Click += new System.EventHandler(this.btnActive_Click);
            // 
            // btnNonActive
            // 
            this.btnNonActive.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnNonActive.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnNonActive.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnNonActive.Location = new System.Drawing.Point(446, 38);
            this.btnNonActive.Name = "btnNonActive";
            this.btnNonActive.Size = new System.Drawing.Size(96, 30);
            this.btnNonActive.Style = Sunny.UI.UIStyle.Custom;
            this.btnNonActive.TabIndex = 0;
            this.btnNonActive.Text = "批次不激活";
            this.btnNonActive.Click += new System.EventHandler(this.btnNonActive_Click);
            // 
            // OVRFederationListForm
            // 
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(184)))), ((int)(((byte)(207)))), ((int)(((byte)(233)))));
            this.ClientSize = new System.Drawing.Size(899, 578);
            this.Controls.Add(this.btnNonActive);
            this.Controls.Add(this.btnActive);
            this.Controls.Add(this.btnDel);
            this.Controls.Add(this.btnEdit);
            this.Controls.Add(this.btnAdd);
            this.Controls.Add(this.btnUpdate);
            this.Controls.Add(this.dgvFederation);
            this.Name = "OVRFederationListForm";
            this.Padding = new System.Windows.Forms.Padding(2, 35, 2, 2);
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Style = Sunny.UI.UIStyle.Custom;
            this.Text = "Federation List";
            this.Load += new System.EventHandler(this.OVRFederationListForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvFederation)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private UIDataGridView dgvFederation;
        private UISymbolButton btnEdit;
        private UISymbolButton btnDel;
        private UISymbolButton btnAdd;
        private UISymbolButton btnUpdate;
        private UIButton btnActive;
        private UIButton btnNonActive;
    }
}