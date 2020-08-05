using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
	partial class frmOVREQIPadMark
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            this.MenuStrip_SendMatchInfo = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.toolStripMenuItem_SendMatchInfo = new System.Windows.Forms.ToolStripMenuItem();
            this.dgvJudgeStatus = new Sunny.UI.UIDataGridView();
            this._msg = new UIListBox();
            this.lb_CurrentRider = new Sunny.UI.UILabel();
            this.btnRegisterBack = new Sunny.UI.UISymbolButton();
            this.btnRegisterNext = new Sunny.UI.UISymbolButton();
            this.btnMovementBack = new Sunny.UI.UISymbolButton();
            this.btnMovementNext = new Sunny.UI.UISymbolButton();
            this.lb_CurrentMovement = new Sunny.UI.UILabel();
            this.chkX_ScoreListAuto = new UICheckBox();
            this.radio_Work = new System.Windows.Forms.RadioButton();
            this.radio_Break = new System.Windows.Forms.RadioButton();
            this.panel_Status = new Sunny.UI.UIPanel();
            this.panel_Rider = new Sunny.UI.UIPanel();
            this.label2 = new Sunny.UI.UILabel();
            this.panel_Movement = new Sunny.UI.UIPanel();
            this.chkX_ScoreMonitor = new UICheckBox();
            this.label1 = new Sunny.UI.UILabel();
            this.MenuStrip_SendMatchInfo.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvJudgeStatus)).BeginInit();
            this.panel_Status.SuspendLayout();
            this.panel_Rider.SuspendLayout();
            this.panel_Movement.SuspendLayout();
            this.SuspendLayout();
            // 
            // MenuStrip_SendMatchInfo
            // 
            this.MenuStrip_SendMatchInfo.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem_SendMatchInfo});
            this.MenuStrip_SendMatchInfo.Name = "MenuStrip_AllStatus";
            this.MenuStrip_SendMatchInfo.Size = new System.Drawing.Size(173, 26);
            // 
            // toolStripMenuItem_SendMatchInfo
            // 
            this.toolStripMenuItem_SendMatchInfo.Name = "toolStripMenuItem_SendMatchInfo";
            this.toolStripMenuItem_SendMatchInfo.Size = new System.Drawing.Size(172, 22);
            this.toolStripMenuItem_SendMatchInfo.Text = "Send Match Info";
            this.toolStripMenuItem_SendMatchInfo.Click += new System.EventHandler(this.toolStripMenuItem_SendMatchInfo_Click);
            // 
            // dgvJudgeStatus
            // 
            this.dgvJudgeStatus.AllowUserToAddRows = false;
            this.dgvJudgeStatus.AllowUserToDeleteRows = false;
            this.dgvJudgeStatus.AllowUserToResizeColumns = false;
            this.dgvJudgeStatus.AllowUserToResizeRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(235)))), ((int)(((byte)(243)))), ((int)(((byte)(255)))));
            this.dgvJudgeStatus.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dgvJudgeStatus.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgvJudgeStatus.BackgroundColor = System.Drawing.Color.White;
            this.dgvJudgeStatus.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.dgvJudgeStatus.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dgvJudgeStatus.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("微软雅黑", 12F);
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvJudgeStatus.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvJudgeStatus.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvJudgeStatus.ColumnHeadersVisible = false;
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            dataGridViewCellStyle3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(200)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(48)))), ((int)(((byte)(48)))), ((int)(((byte)(48)))));
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvJudgeStatus.DefaultCellStyle = dataGridViewCellStyle3;
            this.dgvJudgeStatus.EnableHeadersVisualStyles = false;
            this.dgvJudgeStatus.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.dgvJudgeStatus.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvJudgeStatus.Location = new System.Drawing.Point(7, 164);
            this.dgvJudgeStatus.Margin = new System.Windows.Forms.Padding(4);
            this.dgvJudgeStatus.Name = "dgvJudgeStatus";
            this.dgvJudgeStatus.ReadOnly = true;
            this.dgvJudgeStatus.RectColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(160)))), ((int)(((byte)(255)))));
            this.dgvJudgeStatus.RowHeadersVisible = false;
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.White;
            this.dgvJudgeStatus.RowsDefaultCellStyle = dataGridViewCellStyle4;
            this.dgvJudgeStatus.RowTemplate.Height = 29;
            this.dgvJudgeStatus.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvJudgeStatus.SelectedIndex = -1;
            this.dgvJudgeStatus.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvJudgeStatus.ShowRect = false;
            this.dgvJudgeStatus.Size = new System.Drawing.Size(384, 143);
            this.dgvJudgeStatus.TabIndex = 5;
            this.dgvJudgeStatus.TagString = null;
            this.dgvJudgeStatus.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvJudgeStatus_CellContentClick);
            this.dgvJudgeStatus.CellMouseDown += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgvJudgeStatus_CellMouseDown);
            // 
            // _msg
            // 
            this._msg.Dock = System.Windows.Forms.DockStyle.Bottom;
            this._msg.ItemHeight = 21;
            this._msg.Location = new System.Drawing.Point(0, 452);
            this._msg.Margin = new System.Windows.Forms.Padding(4);
            this._msg.Name = "_msg";
            this._msg.Size = new System.Drawing.Size(395, 277);
            this._msg.TabIndex = 6;
            // 
            // lb_CurrentRider
            // 
            this.lb_CurrentRider.AutoSize = true;
            this.lb_CurrentRider.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            this.lb_CurrentRider.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lb_CurrentRider.Location = new System.Drawing.Point(87, 7);
            this.lb_CurrentRider.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lb_CurrentRider.Name = "lb_CurrentRider";
            this.lb_CurrentRider.Size = new System.Drawing.Size(53, 16);
            this.lb_CurrentRider.TabIndex = 7;
            this.lb_CurrentRider.Text = "Rider";
            this.lb_CurrentRider.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // btnRegisterBack
            // 
            this.btnRegisterBack.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRegisterBack.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnRegisterBack.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnRegisterBack.Location = new System.Drawing.Point(24, 27);
            this.btnRegisterBack.Margin = new System.Windows.Forms.Padding(4);
            this.btnRegisterBack.Name = "btnRegisterBack";
            this.btnRegisterBack.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnRegisterBack.Size = new System.Drawing.Size(80, 25);
            this.btnRegisterBack.Symbol = 61513;
            this.btnRegisterBack.TabIndex = 9;
            this.btnRegisterBack.Visible = false;
            this.btnRegisterBack.Click += new System.EventHandler(this.btnRegisterBack_Click);
            // 
            // btnRegisterNext
            // 
            this.btnRegisterNext.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnRegisterNext.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnRegisterNext.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnRegisterNext.Location = new System.Drawing.Point(255, 27);
            this.btnRegisterNext.Margin = new System.Windows.Forms.Padding(4);
            this.btnRegisterNext.Name = "btnRegisterNext";
            this.btnRegisterNext.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnRegisterNext.Size = new System.Drawing.Size(80, 25);
            this.btnRegisterNext.Symbol = 61520;
            this.btnRegisterNext.TabIndex = 8;
            this.btnRegisterNext.Visible = false;
            this.btnRegisterNext.Click += new System.EventHandler(this.btnRegisterNext_Click);
            // 
            // btnMovementBack
            // 
            this.btnMovementBack.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnMovementBack.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnMovementBack.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnMovementBack.Location = new System.Drawing.Point(27, 25);
            this.btnMovementBack.Margin = new System.Windows.Forms.Padding(4);
            this.btnMovementBack.Name = "btnMovementBack";
            this.btnMovementBack.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnMovementBack.Size = new System.Drawing.Size(80, 25);
            this.btnMovementBack.Symbol = 61514;
            this.btnMovementBack.TabIndex = 12;
            this.btnMovementBack.Click += new System.EventHandler(this.btnMovementBack_Click);
            // 
            // btnMovementNext
            // 
            this.btnMovementNext.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnMovementNext.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnMovementNext.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.btnMovementNext.Location = new System.Drawing.Point(258, 25);
            this.btnMovementNext.Margin = new System.Windows.Forms.Padding(4);
            this.btnMovementNext.Name = "btnMovementNext";
            this.btnMovementNext.Padding = new System.Windows.Forms.Padding(28, 0, 0, 0);
            this.btnMovementNext.Size = new System.Drawing.Size(80, 25);
            this.btnMovementNext.Symbol = 61518;
            this.btnMovementNext.TabIndex = 11;
            this.btnMovementNext.Click += new System.EventHandler(this.btnMovementNext_Click);
            // 
            // lb_CurrentMovement
            // 
            this.lb_CurrentMovement.AutoSize = true;
            this.lb_CurrentMovement.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            this.lb_CurrentMovement.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lb_CurrentMovement.Location = new System.Drawing.Point(119, 101);
            this.lb_CurrentMovement.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lb_CurrentMovement.Name = "lb_CurrentMovement";
            this.lb_CurrentMovement.Size = new System.Drawing.Size(80, 16);
            this.lb_CurrentMovement.TabIndex = 10;
            this.lb_CurrentMovement.Text = "Movement";
            this.lb_CurrentMovement.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // chkX_ScoreListAuto
            // 
            this.chkX_ScoreListAuto.AutoSize = true;
            this.chkX_ScoreListAuto.Location = new System.Drawing.Point(141, 27);
            this.chkX_ScoreListAuto.Margin = new System.Windows.Forms.Padding(4);
            this.chkX_ScoreListAuto.Name = "chkX_ScoreListAuto";
            this.chkX_ScoreListAuto.Size = new System.Drawing.Size(66, 25);
            this.chkX_ScoreListAuto.TabIndex = 13;
            this.chkX_ScoreListAuto.Text = "Auto";
            this.chkX_ScoreListAuto.Visible = false;
            // 
            // radio_Work
            // 
            this.radio_Work.AutoSize = true;
            this.radio_Work.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            this.radio_Work.Checked = true;
            this.radio_Work.Location = new System.Drawing.Point(38, 16);
            this.radio_Work.Margin = new System.Windows.Forms.Padding(4);
            this.radio_Work.Name = "radio_Work";
            this.radio_Work.Size = new System.Drawing.Size(69, 25);
            this.radio_Work.TabIndex = 14;
            this.radio_Work.TabStop = true;
            this.radio_Work.Text = "Work";
            this.radio_Work.UseVisualStyleBackColor = false;
            this.radio_Work.CheckedChanged += new System.EventHandler(this.radio_Work_CheckedChanged);
            // 
            // radio_Break
            // 
            this.radio_Break.AutoSize = true;
            this.radio_Break.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            this.radio_Break.Location = new System.Drawing.Point(194, 16);
            this.radio_Break.Margin = new System.Windows.Forms.Padding(4);
            this.radio_Break.Name = "radio_Break";
            this.radio_Break.Size = new System.Drawing.Size(71, 25);
            this.radio_Break.TabIndex = 15;
            this.radio_Break.TabStop = true;
            this.radio_Break.Text = "Break";
            this.radio_Break.UseVisualStyleBackColor = false;
            // 
            // panel_Status
            // 
            this.panel_Status.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(255)))), ((int)(((byte)(192)))));
            this.panel_Status.Controls.Add(this.radio_Work);
            this.panel_Status.Controls.Add(this.radio_Break);
            this.panel_Status.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.panel_Status.Location = new System.Drawing.Point(40, 11);
            this.panel_Status.Margin = new System.Windows.Forms.Padding(4);
            this.panel_Status.Name = "panel_Status";
            this.panel_Status.Size = new System.Drawing.Size(322, 65);
            this.panel_Status.TabIndex = 16;
            this.panel_Status.Text = null;
            // 
            // panel_Rider
            // 
            this.panel_Rider.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(224)))), ((int)(((byte)(224)))));
            this.panel_Rider.Controls.Add(this.label2);
            this.panel_Rider.Controls.Add(this.btnRegisterBack);
            this.panel_Rider.Controls.Add(this.lb_CurrentRider);
            this.panel_Rider.Controls.Add(this.btnRegisterNext);
            this.panel_Rider.Controls.Add(this.chkX_ScoreListAuto);
            this.panel_Rider.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.panel_Rider.Location = new System.Drawing.Point(7, 100);
            this.panel_Rider.Margin = new System.Windows.Forms.Padding(4);
            this.panel_Rider.Name = "panel_Rider";
            this.panel_Rider.Size = new System.Drawing.Size(384, 56);
            this.panel_Rider.TabIndex = 17;
            this.panel_Rider.Text = null;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            this.label2.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label2.Location = new System.Drawing.Point(7, 7);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(62, 16);
            this.label2.TabIndex = 8;
            this.label2.Text = "Rider:";
            this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // panel_Movement
            // 
            this.panel_Movement.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(224)))), ((int)(((byte)(224)))));
            this.panel_Movement.Controls.Add(this.chkX_ScoreMonitor);
            this.panel_Movement.Controls.Add(this.btnMovementBack);
            this.panel_Movement.Controls.Add(this.label1);
            this.panel_Movement.Controls.Add(this.lb_CurrentMovement);
            this.panel_Movement.Controls.Add(this.btnMovementNext);
            this.panel_Movement.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.panel_Movement.Location = new System.Drawing.Point(4, 315);
            this.panel_Movement.Margin = new System.Windows.Forms.Padding(4);
            this.panel_Movement.Name = "panel_Movement";
            this.panel_Movement.Size = new System.Drawing.Size(387, 128);
            this.panel_Movement.TabIndex = 18;
            this.panel_Movement.Text = null;
            // 
            // chkX_ScoreMonitor
            // 
            this.chkX_ScoreMonitor.AutoSize = true;
            this.chkX_ScoreMonitor.Location = new System.Drawing.Point(131, 53);
            this.chkX_ScoreMonitor.Margin = new System.Windows.Forms.Padding(4);
            this.chkX_ScoreMonitor.Name = "chkX_ScoreMonitor";
            this.chkX_ScoreMonitor.Size = new System.Drawing.Size(91, 25);
            this.chkX_ScoreMonitor.TabIndex = 14;
            this.chkX_ScoreMonitor.Text = "Monitor";
            this.chkX_ScoreMonitor.Visible = false;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            this.label1.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label1.Location = new System.Drawing.Point(20, 101);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(89, 16);
            this.label1.TabIndex = 11;
            this.label1.Text = "Movement:";
            this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // frmOVREQIPadMark
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.ClientSize = new System.Drawing.Size(395, 729);
            this.ControlBox = false;
            this.Controls.Add(this.dgvJudgeStatus);
            this.Controls.Add(this._msg);
            this.Controls.Add(this.panel_Status);
            this.Controls.Add(this.panel_Rider);
            this.Controls.Add(this.panel_Movement);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Margin = new System.Windows.Forms.Padding(4);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmOVREQIPadMark";
            this.Text = "frmOVREQIPadMark";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.frmOVREQIPadMark_FormClosing);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.frmOVREQIPadMark_FormClosed);
            this.Load += new System.EventHandler(this.frmOVREQIPadMark_Load);
            this.MenuStrip_SendMatchInfo.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvJudgeStatus)).EndInit();
            this.panel_Status.ResumeLayout(false);
            this.panel_Status.PerformLayout();
            this.panel_Rider.ResumeLayout(false);
            this.panel_Rider.PerformLayout();
            this.panel_Movement.ResumeLayout(false);
            this.panel_Movement.PerformLayout();
            this.ResumeLayout(false);

		}

		#endregion

        private System.Windows.Forms.ContextMenuStrip MenuStrip_SendMatchInfo;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem_SendMatchInfo;
        private UIDataGridView dgvJudgeStatus;
        private UIListBox _msg;
        private UILabel lb_CurrentRider;
        private UISymbolButton btnRegisterBack;
        private UISymbolButton btnRegisterNext;
        private UISymbolButton btnMovementBack;
        private UISymbolButton btnMovementNext;
        private UILabel lb_CurrentMovement;
        private UICheckBox chkX_ScoreListAuto;
        private System.Windows.Forms.RadioButton radio_Work;
        private System.Windows.Forms.RadioButton radio_Break;
        private UIPanel panel_Status;
        private UIPanel panel_Rider;
        private UILabel label2;
        private UIPanel panel_Movement;
        private UILabel label1;
        private UICheckBox chkX_ScoreMonitor;

	}
}

