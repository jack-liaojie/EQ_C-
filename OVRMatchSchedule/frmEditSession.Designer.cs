using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    partial class EditSessionForm
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
            this.btnX_Add = new DevComponents.DotNetBar.ButtonX();
            this.btnX_Del = new DevComponents.DotNetBar.ButtonX();
            this.dgv_Session = new UIDataGridView();
            this.cbEx_Date = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Session)).BeginInit();
            this.SuspendLayout();
            // 
            // btnX_Add
            // 
            this.btnX_Add.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Add.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_Add.Image = global::Newauto.OVRMatchSchedule.Properties.Resources.add_16;
            this.btnX_Add.Location = new System.Drawing.Point(160, 300);
            this.btnX_Add.Name = "btnX_Add";
            this.btnX_Add.Size = new System.Drawing.Size(20, 20);
            this.btnX_Add.TabIndex = 1;
            this.btnX_Add.Click += new System.EventHandler(this.btnX_Add_Click);
            // 
            // btnX_Del
            // 
            this.btnX_Del.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnX_Del.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnX_Del.Image = global::Newauto.OVRMatchSchedule.Properties.Resources.remove_16;
            this.btnX_Del.Location = new System.Drawing.Point(200, 300);
            this.btnX_Del.Name = "btnX_Del";
            this.btnX_Del.Size = new System.Drawing.Size(20, 20);
            this.btnX_Del.TabIndex = 2;
            this.btnX_Del.Click += new System.EventHandler(this.btnX_Del_Click);
            // 
            // dgv_Session
            // 
            this.dgv_Session.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_Session.Location = new System.Drawing.Point(1, 5);
            this.dgv_Session.Name = "dgv_Session";
            this.dgv_Session.RowTemplate.Height = 23;
            this.dgv_Session.Size = new System.Drawing.Size(470, 290);
            this.dgv_Session.TabIndex = 5;
            this.dgv_Session.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgv_Session_CellBeginEdit);
            this.dgv_Session.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_Session_CellEndEdit);
            // 
            // cbEx_Date
            // 
            this.cbEx_Date.DisplayMember = "Text";
            this.cbEx_Date.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbEx_Date.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbEx_Date.FormattingEnabled = true;
            this.cbEx_Date.ItemHeight = 15;
            this.cbEx_Date.Location = new System.Drawing.Point(1, 300);
            this.cbEx_Date.Name = "cbEx_Date";
            this.cbEx_Date.Size = new System.Drawing.Size(130, 21);
            this.cbEx_Date.TabIndex = 46;
            this.cbEx_Date.SelectionChangeCommitted += new System.EventHandler(this.cbEx_Date_SelectionChangeCommitted);
            // 
            // EditSessionForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(474, 328);
            this.Controls.Add(this.cbEx_Date);
            this.Controls.Add(this.dgv_Session);
            this.Controls.Add(this.btnX_Add);
            this.Controls.Add(this.btnX_Del);
            
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "EditSessionForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Load += new System.EventHandler(this.EditSessionForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Session)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnX_Add;
        private DevComponents.DotNetBar.ButtonX btnX_Del;
        private UIDataGridView dgv_Session;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbEx_Date;
    }
}