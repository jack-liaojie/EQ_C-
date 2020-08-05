using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    partial class EditRoundForm
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
            this.btnX_Add = new DevComponents.DotNetBar.ButtonX();
            this.btnX_Del = new DevComponents.DotNetBar.ButtonX();
            this.cbEx_Event = new DevComponents.DotNetBar.Controls.ComboBoxEx();
            this.dgv_Round = new UIDataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Round)).BeginInit();
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
            this.btnX_Add.TabIndex = 6;
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
            this.btnX_Del.TabIndex = 7;
            this.btnX_Del.Click += new System.EventHandler(this.btnX_Del_Click);
            // 
            // cbEx_Event
            // 
            this.cbEx_Event.DisplayMember = "Text";
            this.cbEx_Event.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.cbEx_Event.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbEx_Event.DropDownWidth = 260;
            this.cbEx_Event.Font = new System.Drawing.Font("SimSun", 9F);
            this.cbEx_Event.FormattingEnabled = true;
            this.cbEx_Event.ItemHeight = 15;
            this.cbEx_Event.Location = new System.Drawing.Point(1, 300);
            this.cbEx_Event.Name = "cbEx_Event";
            this.cbEx_Event.Size = new System.Drawing.Size(130, 21);
            this.cbEx_Event.TabIndex = 11;
            this.cbEx_Event.SelectionChangeCommitted += new System.EventHandler(this.comboBoxEx1_SelectionChangeCommitted);
            // 
            // dgv_Round
            // 
            this.dgv_Round.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_Round.Location = new System.Drawing.Point(1, 5);
            this.dgv_Round.Name = "dgv_Round";
            this.dgv_Round.RowTemplate.Height = 23;
            this.dgv_Round.Size = new System.Drawing.Size(470, 290);
            this.dgv_Round.TabIndex = 12;
            this.dgv_Round.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dgv_Round_CellBeginEdit);
            this.dgv_Round.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgv_Round_CellEndEdit);
            // 
            // EditRoundForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(474, 328);
            this.Controls.Add(this.dgv_Round);
            this.Controls.Add(this.cbEx_Event);
            this.Controls.Add(this.btnX_Add);
            this.Controls.Add(this.btnX_Del);
            
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "EditRoundForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Load += new System.EventHandler(this.EditRoundForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgv_Round)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.ButtonX btnX_Add;
        private DevComponents.DotNetBar.ButtonX btnX_Del;
        private DevComponents.DotNetBar.Controls.ComboBoxEx cbEx_Event;
        private UIDataGridView dgv_Round;
    }
}