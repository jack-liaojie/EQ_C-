namespace AutoSports.OVRSEPlugin
{
    partial class frmEntryOfficial
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
            this.dgvEventOfficials = new System.Windows.Forms.DataGridView();
            this.dgvMatchOfficial = new System.Windows.Forms.DataGridView();
            this.lbMatchOfficials = new DevComponents.DotNetBar.LabelX();
            this.lbEventOfficial = new DevComponents.DotNetBar.LabelX();
            this.btnDel = new DevComponents.DotNetBar.ButtonX();
            this.btnAdd = new DevComponents.DotNetBar.ButtonX();
            this.cmb_Regus = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.lbRegu = new DevComponents.DotNetBar.LabelX();
            this.labelX1 = new DevComponents.DotNetBar.LabelX();
            this.lbSearchResult = new System.Windows.Forms.ListBox();
            this.tbKeyWord = new DevComponents.DotNetBar.Controls.TextBoxX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvEventOfficials)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchOfficial)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvEventOfficials
            // 
            this.dgvEventOfficials.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvEventOfficials.Location = new System.Drawing.Point(5, 62);
            this.dgvEventOfficials.Name = "dgvEventOfficials";
            this.dgvEventOfficials.RowTemplate.Height = 23;
            this.dgvEventOfficials.Size = new System.Drawing.Size(239, 271);
            this.dgvEventOfficials.TabIndex = 13;
            // 
            // dgvMatchOfficial
            // 
            this.dgvMatchOfficial.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvMatchOfficial.Location = new System.Drawing.Point(309, 36);
            this.dgvMatchOfficial.Name = "dgvMatchOfficial";
            this.dgvMatchOfficial.RowTemplate.Height = 23;
            this.dgvMatchOfficial.Size = new System.Drawing.Size(454, 297);
            this.dgvMatchOfficial.TabIndex = 12;
            this.dgvMatchOfficial.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgvMatchOfficial_CellBeginEdit);
            this.dgvMatchOfficial.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchOfficial_CellValueChanged);
            // 
            // lbMatchOfficials
            // 
            this.lbMatchOfficials.AutoSize = true;
            // 
            // 
            // 
            this.lbMatchOfficials.BackgroundStyle.Class = "";
            this.lbMatchOfficials.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbMatchOfficials.Location = new System.Drawing.Point(309, 12);
            this.lbMatchOfficials.Name = "lbMatchOfficials";
            this.lbMatchOfficials.Size = new System.Drawing.Size(99, 16);
            this.lbMatchOfficials.TabIndex = 16;
            this.lbMatchOfficials.Text = "Match Officials";
            // 
            // lbEventOfficial
            // 
            this.lbEventOfficial.AutoSize = true;
            // 
            // 
            // 
            this.lbEventOfficial.BackgroundStyle.Class = "";
            this.lbEventOfficial.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbEventOfficial.Location = new System.Drawing.Point(5, 40);
            this.lbEventOfficial.Name = "lbEventOfficial";
            this.lbEventOfficial.Size = new System.Drawing.Size(124, 16);
            this.lbEventOfficial.TabIndex = 17;
            this.lbEventOfficial.Text = "Available Officials";
            // 
            // btnDel
            // 
            this.btnDel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnDel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnDel.Image = global::AutoSports.OVRSEPlugin.Properties.Resources.left_24;
            this.btnDel.Location = new System.Drawing.Point(251, 198);
            this.btnDel.Name = "btnDel";
            this.btnDel.Size = new System.Drawing.Size(50, 30);
            this.btnDel.TabIndex = 14;
            this.btnDel.Click += new System.EventHandler(this.btnDel_Click);
            // 
            // btnAdd
            // 
            this.btnAdd.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnAdd.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnAdd.Image = global::AutoSports.OVRSEPlugin.Properties.Resources.right_24;
            this.btnAdd.Location = new System.Drawing.Point(251, 119);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(50, 30);
            this.btnAdd.TabIndex = 15;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // cmb_Regus
            // 
            this.cmb_Regus.DisplayMember = "Text";
            this.cmb_Regus.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cmb_Regus.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmb_Regus.FormattingEnabled = true;
            this.cmb_Regus.ItemHeight = 15;
            this.cmb_Regus.Location = new System.Drawing.Point(639, 9);
            this.cmb_Regus.Name = "cmb_Regus";
            this.cmb_Regus.Size = new System.Drawing.Size(121, 21);
            this.cmb_Regus.TabIndex = 18;
            this.cmb_Regus.SelectionChangeCommitted += new System.EventHandler(this.cmb_Regus_SelectionChangeCommitted);
            // 
            // lbRegu
            // 
            // 
            // 
            // 
            this.lbRegu.BackgroundStyle.Class = "";
            this.lbRegu.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.lbRegu.Location = new System.Drawing.Point(594, 9);
            this.lbRegu.Name = "lbRegu";
            this.lbRegu.Size = new System.Drawing.Size(39, 23);
            this.lbRegu.TabIndex = 19;
            this.lbRegu.Text = "Regu:";
            // 
            // labelX1
            // 
            // 
            // 
            // 
            this.labelX1.BackgroundStyle.Class = "";
            this.labelX1.BackgroundStyle.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.labelX1.Location = new System.Drawing.Point(5, 13);
            this.labelX1.Name = "labelX1";
            this.labelX1.Size = new System.Drawing.Size(52, 23);
            this.labelX1.TabIndex = 22;
            this.labelX1.Text = "Search:";
            // 
            // lbSearchResult
            // 
            this.lbSearchResult.FormattingEnabled = true;
            this.lbSearchResult.ItemHeight = 12;
            this.lbSearchResult.Location = new System.Drawing.Point(58, 35);
            this.lbSearchResult.Name = "lbSearchResult";
            this.lbSearchResult.Size = new System.Drawing.Size(186, 88);
            this.lbSearchResult.TabIndex = 21;
            this.lbSearchResult.Visible = false;
            this.lbSearchResult.KeyDown += new System.Windows.Forms.KeyEventHandler(this.lbSearchResult_KeyDown);
            this.lbSearchResult.MouseDown += new System.Windows.Forms.MouseEventHandler(this.lbSearchResult_MouseDown);
            // 
            // tbKeyWord
            // 
            // 
            // 
            // 
            this.tbKeyWord.Border.Class = "TextBoxBorder";
            this.tbKeyWord.Border.CornerType = DevComponents.DotNetBar.eCornerType.Square;
            this.tbKeyWord.Location = new System.Drawing.Point(58, 13);
            this.tbKeyWord.Name = "tbKeyWord";
            this.tbKeyWord.Size = new System.Drawing.Size(186, 21);
            this.tbKeyWord.TabIndex = 20;
            this.tbKeyWord.TextChanged += new System.EventHandler(this.tbKeyWord_TextChanged);
            this.tbKeyWord.PreviewKeyDown += new System.Windows.Forms.PreviewKeyDownEventHandler(this.tbKeyWord_PreviewKeyDown);
            // 
            // frmEntryOfficial
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(213)))), ((int)(((byte)(229)))), ((int)(((byte)(244)))));
            this.ClientSize = new System.Drawing.Size(766, 345);
            this.Controls.Add(this.labelX1);
            this.Controls.Add(this.lbSearchResult);
            this.Controls.Add(this.tbKeyWord);
            this.Controls.Add(this.lbRegu);
            this.Controls.Add(this.cmb_Regus);
            this.Controls.Add(this.dgvEventOfficials);
            this.Controls.Add(this.dgvMatchOfficial);
            this.Controls.Add(this.lbMatchOfficials);
            this.Controls.Add(this.lbEventOfficial);
            this.Controls.Add(this.btnDel);
            this.Controls.Add(this.btnAdd);
            this.DoubleBuffered = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmEntryOfficial";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmEntryOfficial";
            this.Load += new System.EventHandler(this.frmEntryOfficial_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvEventOfficials)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvMatchOfficial)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvEventOfficials;
        private System.Windows.Forms.DataGridView dgvMatchOfficial;
        private DevComponents.DotNetBar.LabelX lbMatchOfficials;
        private DevComponents.DotNetBar.LabelX lbEventOfficial;
        private DevComponents.DotNetBar.ButtonX btnDel;
        private DevComponents.DotNetBar.ButtonX btnAdd;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cmb_Regus;
        private DevComponents.DotNetBar.LabelX lbRegu;
        private DevComponents.DotNetBar.LabelX labelX1;
        private System.Windows.Forms.ListBox lbSearchResult;
        private DevComponents.DotNetBar.Controls.TextBoxX tbKeyWord;
    }
}