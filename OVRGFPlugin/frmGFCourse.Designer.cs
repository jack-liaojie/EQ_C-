namespace AutoSports.OVRGFPlugin
{
    partial class frmGFCourse
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
            this.dgvCourseDetail = new System.Windows.Forms.DataGridView();
            this.btnx_SaveXML = new DevComponents.DotNetBar.ButtonX();
            this.dgvCourseList = new System.Windows.Forms.DataGridView();
            this.btnx_CreateCourse = new DevComponents.DotNetBar.ButtonX();
            this.btnx_DelCourse = new DevComponents.DotNetBar.ButtonX();
            this.lb_Hole = new System.Windows.Forms.Label();
            this.tb_HoleNum = new System.Windows.Forms.TextBox();
            this.lb_CurRule = new System.Windows.Forms.Label();
            this.cmbCourseList = new System.Windows.Forms.ComboBox();
            this.btnx_ApplyCourse = new DevComponents.DotNetBar.ButtonX();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCourseDetail)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCourseList)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvCourseDetail
            // 
            this.dgvCourseDetail.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvCourseDetail.Location = new System.Drawing.Point(7, 173);
            this.dgvCourseDetail.Name = "dgvCourseDetail";
            this.dgvCourseDetail.RowTemplate.Height = 23;
            this.dgvCourseDetail.Size = new System.Drawing.Size(891, 93);
            this.dgvCourseDetail.TabIndex = 0;
            // 
            // btnx_SaveXML
            // 
            this.btnx_SaveXML.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_SaveXML.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_SaveXML.Location = new System.Drawing.Point(808, 274);
            this.btnx_SaveXML.Name = "btnx_SaveXML";
            this.btnx_SaveXML.Size = new System.Drawing.Size(90, 32);
            this.btnx_SaveXML.TabIndex = 1;
            this.btnx_SaveXML.Text = "Save Course";
            this.btnx_SaveXML.Click += new System.EventHandler(this.btnx_SaveXML_Click);
            // 
            // dgvCourseList
            // 
            this.dgvCourseList.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvCourseList.Location = new System.Drawing.Point(7, 3);
            this.dgvCourseList.Name = "dgvCourseList";
            this.dgvCourseList.RowTemplate.Height = 23;
            this.dgvCourseList.Size = new System.Drawing.Size(574, 153);
            this.dgvCourseList.TabIndex = 2;
            this.dgvCourseList.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvCourseList_CellValueChanged);
            this.dgvCourseList.SelectionChanged += new System.EventHandler(this.dgvCourseList_SelectionChanged);
            // 
            // btnx_CreateCourse
            // 
            this.btnx_CreateCourse.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_CreateCourse.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_CreateCourse.Location = new System.Drawing.Point(587, 41);
            this.btnx_CreateCourse.Name = "btnx_CreateCourse";
            this.btnx_CreateCourse.Size = new System.Drawing.Size(90, 32);
            this.btnx_CreateCourse.TabIndex = 1;
            this.btnx_CreateCourse.Text = "Create Course";
            this.btnx_CreateCourse.Click += new System.EventHandler(this.btnx_CreateCourse_Click);
            // 
            // btnx_DelCourse
            // 
            this.btnx_DelCourse.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_DelCourse.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_DelCourse.Location = new System.Drawing.Point(587, 79);
            this.btnx_DelCourse.Name = "btnx_DelCourse";
            this.btnx_DelCourse.Size = new System.Drawing.Size(90, 32);
            this.btnx_DelCourse.TabIndex = 1;
            this.btnx_DelCourse.Text = "Delete Course";
            this.btnx_DelCourse.Click += new System.EventHandler(this.btnx_DelCourse_Click);
            // 
            // lb_Hole
            // 
            this.lb_Hole.AutoSize = true;
            this.lb_Hole.Location = new System.Drawing.Point(587, 9);
            this.lb_Hole.Name = "lb_Hole";
            this.lb_Hole.Size = new System.Drawing.Size(35, 12);
            this.lb_Hole.TabIndex = 3;
            this.lb_Hole.Text = "Hole:";
            // 
            // tb_HoleNum
            // 
            this.tb_HoleNum.Location = new System.Drawing.Point(628, 4);
            this.tb_HoleNum.MaxLength = 2;
            this.tb_HoleNum.Name = "tb_HoleNum";
            this.tb_HoleNum.Size = new System.Drawing.Size(44, 21);
            this.tb_HoleNum.TabIndex = 4;
            this.tb_HoleNum.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tb_HoleNum_KeyPress);
            // 
            // lb_CurRule
            // 
            this.lb_CurRule.AutoSize = true;
            this.lb_CurRule.Location = new System.Drawing.Point(587, 135);
            this.lb_CurRule.Name = "lb_CurRule";
            this.lb_CurRule.Size = new System.Drawing.Size(95, 12);
            this.lb_CurRule.TabIndex = 3;
            this.lb_CurRule.Text = "Cur Match Rule:";
            // 
            // cmbCourseList
            // 
            this.cmbCourseList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbCourseList.FormattingEnabled = true;
            this.cmbCourseList.Location = new System.Drawing.Point(688, 132);
            this.cmbCourseList.Name = "cmbCourseList";
            this.cmbCourseList.Size = new System.Drawing.Size(106, 20);
            this.cmbCourseList.TabIndex = 5;
            // 
            // btnx_ApplyCourse
            // 
            this.btnx_ApplyCourse.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnx_ApplyCourse.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnx_ApplyCourse.Location = new System.Drawing.Point(808, 124);
            this.btnx_ApplyCourse.Name = "btnx_ApplyCourse";
            this.btnx_ApplyCourse.Size = new System.Drawing.Size(90, 32);
            this.btnx_ApplyCourse.TabIndex = 1;
            this.btnx_ApplyCourse.Text = "Apply Course";
            this.btnx_ApplyCourse.Click += new System.EventHandler(this.btnx_ApplyCourse_Click);
            // 
            // frmGFCourse
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(194)))), ((int)(((byte)(217)))), ((int)(((byte)(247)))));
            this.ClientSize = new System.Drawing.Size(900, 318);
            this.Controls.Add(this.cmbCourseList);
            this.Controls.Add(this.tb_HoleNum);
            this.Controls.Add(this.lb_CurRule);
            this.Controls.Add(this.lb_Hole);
            this.Controls.Add(this.dgvCourseList);
            this.Controls.Add(this.btnx_ApplyCourse);
            this.Controls.Add(this.btnx_DelCourse);
            this.Controls.Add(this.btnx_CreateCourse);
            this.Controls.Add(this.btnx_SaveXML);
            this.Controls.Add(this.dgvCourseDetail);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmGFCourse";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmGFCourse";
            this.Load += new System.EventHandler(this.frmGFCourse_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvCourseDetail)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCourseList)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvCourseDetail;
        private DevComponents.DotNetBar.ButtonX btnx_SaveXML;
        private System.Windows.Forms.DataGridView dgvCourseList;
        private DevComponents.DotNetBar.ButtonX btnx_CreateCourse;
        private DevComponents.DotNetBar.ButtonX btnx_DelCourse;
        private System.Windows.Forms.Label lb_Hole;
        private System.Windows.Forms.TextBox tb_HoleNum;
        private System.Windows.Forms.Label lb_CurRule;
        private System.Windows.Forms.ComboBox cmbCourseList;
        private DevComponents.DotNetBar.ButtonX btnx_ApplyCourse;
    }
}