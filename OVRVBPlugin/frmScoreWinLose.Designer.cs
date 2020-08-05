namespace AutoSports.OVRVBPlugin
{
	partial class frmScoreDetail
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
			System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
			System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
			System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
			this._dgvWinLose = new System.Windows.Forms.DataGridView();
			this.label2 = new System.Windows.Forms.Label();
			this._btnOK = new DevComponents.DotNetBar.ButtonX();
			this._btnCancel = new DevComponents.DotNetBar.ButtonX();
			((System.ComponentModel.ISupportInitialize)(this._dgvWinLose)).BeginInit();
			this.SuspendLayout();
			// 
			// _dgvWinLose
			// 
			this._dgvWinLose.AllowUserToAddRows = false;
			this._dgvWinLose.AllowUserToDeleteRows = false;
			this._dgvWinLose.AllowUserToResizeColumns = false;
			dataGridViewCellStyle1.SelectionBackColor = System.Drawing.Color.MidnightBlue;
			this._dgvWinLose.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
			this._dgvWinLose.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.DisplayedCells;
			dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
			dataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control;
			dataGridViewCellStyle2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
			dataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText;
			dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
			dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
			dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
			this._dgvWinLose.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
			this._dgvWinLose.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
			dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
			dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window;
			dataGridViewCellStyle3.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
			dataGridViewCellStyle3.ForeColor = System.Drawing.SystemColors.ControlText;
			dataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight;
			dataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
			dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
			this._dgvWinLose.DefaultCellStyle = dataGridViewCellStyle3;
			this._dgvWinLose.Location = new System.Drawing.Point(12, 21);
			this._dgvWinLose.Name = "_dgvWinLose";
			dataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
			dataGridViewCellStyle4.BackColor = System.Drawing.SystemColors.Control;
			dataGridViewCellStyle4.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
			dataGridViewCellStyle4.ForeColor = System.Drawing.SystemColors.WindowText;
			dataGridViewCellStyle4.SelectionBackColor = System.Drawing.SystemColors.Highlight;
			dataGridViewCellStyle4.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
			dataGridViewCellStyle4.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
			this._dgvWinLose.RowHeadersDefaultCellStyle = dataGridViewCellStyle4;
			this._dgvWinLose.RowHeadersWidth = 25;
			this._dgvWinLose.RowTemplate.Height = 23;
			this._dgvWinLose.ScrollBars = System.Windows.Forms.ScrollBars.None;
			this._dgvWinLose.Size = new System.Drawing.Size(605, 91);
			this._dgvWinLose.TabIndex = 43;
			this._dgvWinLose.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this._dgvWinLose_CellEndEdit);
			// 
			// label2
			// 
			this.label2.AutoSize = true;
			this.label2.Location = new System.Drawing.Point(11, 5);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(57, 13);
			this.label2.TabIndex = 45;
			this.label2.Text = "Win && lose";
			// 
			// _btnOK
			// 
			this._btnOK.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
			this._btnOK.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
			this._btnOK.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this._btnOK.Location = new System.Drawing.Point(645, 410);
			this._btnOK.Name = "_btnOK";
			this._btnOK.Size = new System.Drawing.Size(103, 33);
			this._btnOK.TabIndex = 48;
			this._btnOK.Text = "OK";
			this._btnOK.Click += new System.EventHandler(this._btnOK_Click);
			// 
			// _btnCancel
			// 
			this._btnCancel.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
			this._btnCancel.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
			this._btnCancel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this._btnCancel.Location = new System.Drawing.Point(766, 410);
			this._btnCancel.Name = "_btnCancel";
			this._btnCancel.Size = new System.Drawing.Size(103, 33);
			this._btnCancel.TabIndex = 49;
			this._btnCancel.Text = "Cancel";
			this._btnCancel.Click += new System.EventHandler(this._btnCancel_Click);
			// 
			// frmScoreDetail
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(881, 455);
			this.Controls.Add(this._btnCancel);
			this.Controls.Add(this._btnOK);
			this.Controls.Add(this.label2);
			this.Controls.Add(this._dgvWinLose);
			this.Name = "frmScoreDetail";
			this.Text = "Score detail";
			this.Load += new System.EventHandler(this.frmScoreDetail_Load);
			((System.ComponentModel.ISupportInitialize)(this._dgvWinLose)).EndInit();
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion

		private System.Windows.Forms.DataGridView _dgvWinLose;
		private System.Windows.Forms.Label label2;
		private DevComponents.DotNetBar.ButtonX _btnOK;
		private DevComponents.DotNetBar.ButtonX _btnCancel;
	}
}