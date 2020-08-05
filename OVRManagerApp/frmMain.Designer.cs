using Sunny.UI;
using System.Windows.Forms;

namespace AutoSports.OVRManagerApp
{
    partial class frmMain
    {
        private System.ComponentModel.IContainer components = null;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }


        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.Windows.Forms.TreeNode treeNode1 = new System.Windows.Forms.TreeNode("综合数据");
            System.Windows.Forms.TreeNode treeNode2 = new System.Windows.Forms.TreeNode("报名报项");
            System.Windows.Forms.TreeNode treeNode3 = new System.Windows.Forms.TreeNode("抽签编排");
            System.Windows.Forms.TreeNode treeNode4 = new System.Windows.Forms.TreeNode("竞赛日程");
            System.Windows.Forms.TreeNode treeNode5 = new System.Windows.Forms.TreeNode("比赛成绩");
            System.Windows.Forms.TreeNode treeNode6 = new System.Windows.Forms.TreeNode("报表打印");
            System.Windows.Forms.TreeNode treeNode7 = new System.Windows.Forms.TreeNode("颁奖排名");
            System.Windows.Forms.TreeNode treeNode8 = new System.Windows.Forms.TreeNode("数据备份");
            System.Windows.Forms.TreeNode treeNode9 = new System.Windows.Forms.TreeNode("官方公告");
            System.Windows.Forms.TreeNode treeNode10 = new System.Windows.Forms.TreeNode("网络连接");
            System.Windows.Forms.TreeNode treeNode11 = new System.Windows.Forms.TreeNode("纪录公告");
            System.Windows.Forms.TreeNode treeNode12 = new System.Windows.Forms.TreeNode("窗体主题");
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmMain));
            this.uiAvatar = new Sunny.UI.UIAvatar();
            this.StyleManager = new Sunny.UI.UIStyleManager(this.components);
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.Header.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // Footer
            // 
            this.Footer.Font = new System.Drawing.Font("华文琥珀", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.Footer.ForeColor = System.Drawing.Color.DarkSlateGray;
            this.Footer.Location = new System.Drawing.Point(250, 729);
            this.Footer.Size = new System.Drawing.Size(1050, 56);
            this.Footer.Style = Sunny.UI.UIStyle.Custom;
            this.Footer.Text = "中科芯控数据技术有限公司";
            this.Footer.TextAlignment = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // Aside
            // 
            this.Aside.Size = new System.Drawing.Size(250, 640);
            // 
            // Header
            // 
            this.Header.Controls.Add(this.pictureBox1);
            this.Header.Controls.Add(this.uiAvatar);
            treeNode1.Name = "节点0";
            treeNode1.Text = "综合数据";
            treeNode2.Name = "节点0";
            treeNode2.Text = "报名报项";
            treeNode3.Name = "节点1";
            treeNode3.Text = "抽签编排";
            treeNode4.Name = "节点2";
            treeNode4.Text = "竞赛日程";
            treeNode5.Name = "节点0";
            treeNode5.Text = "比赛成绩";
            treeNode6.Name = "节点0";
            treeNode6.Text = "报表打印";
            treeNode7.Name = "节点1";
            treeNode7.Text = "颁奖排名";
            treeNode8.Name = "节点2";
            treeNode8.Text = "数据备份";
            treeNode9.Name = "节点3";
            treeNode9.Text = "官方公告";
            treeNode10.Name = "节点4";
            treeNode10.Text = "网络连接";
            treeNode11.Name = "节点5";
            treeNode11.Text = "纪录公告";
            treeNode12.Name = "节点0";
            treeNode12.Text = "窗体主题";
            this.Header.Nodes.AddRange(new System.Windows.Forms.TreeNode[] {
            treeNode1,
            treeNode2,
            treeNode3,
            treeNode4,
            treeNode5,
            treeNode6,
            treeNode7,
            treeNode8,
            treeNode9,
            treeNode10,
            treeNode11,
            treeNode12});
            this.Header.Size = new System.Drawing.Size(1300, 110);
            this.Header.MenuItemClick += new Sunny.UI.UINavBar.OnMenuItemClick(this.Header_MenuItemClick);
            // 
            // uiAvatar
            // 
            this.uiAvatar.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.uiAvatar.Font = new System.Drawing.Font("微软雅黑", 12F);
            this.uiAvatar.Location = new System.Drawing.Point(1195, 24);
            this.uiAvatar.Name = "uiAvatar";
            this.uiAvatar.Size = new System.Drawing.Size(66, 70);
            this.uiAvatar.TabIndex = 6;
            this.uiAvatar.Text = "uiAvatar1";
            // 
            // pictureBox1
            // 
            this.pictureBox1.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("pictureBox1.BackgroundImage")));
            this.pictureBox1.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.pictureBox1.Cursor = System.Windows.Forms.Cursors.Hand;
            this.pictureBox1.Dock = System.Windows.Forms.DockStyle.Left;
            this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
            this.pictureBox1.Location = new System.Drawing.Point(0, 0);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(250, 110);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pictureBox1.TabIndex = 7;
            this.pictureBox1.TabStop = false;
            // 
            // frmMain
            // 
            this.ClientSize = new System.Drawing.Size(1300, 785);
            this.Name = "frmMain";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Header.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);

        }


        private UIAvatar uiAvatar;
        private UIStyleManager StyleManager;
        private PictureBox pictureBox1;
    }
}