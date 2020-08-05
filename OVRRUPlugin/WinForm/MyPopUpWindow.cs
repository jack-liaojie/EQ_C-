using System;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using OVRRUPlugin.Common;

namespace OVRRUPlugin
{
    public partial class MyPopUpWindow : Form
    {
        public MyPopUpWindow()
        {
            InitializeComponent();
        }

        /// <summary>
        /// 根据消息类型显示消息内容
        /// </summary>
        /// <param name="messageType">
        /// 1--表示运动员在场上，2---表示运动员在场下
        /// </param>
        public MyPopUpWindow(MyPopUpWindowType messageType)
        {
            InitializeComponent();

            if (messageType ==MyPopUpWindowType.OnCourt)
            {
                lblMessage.Text = "该运动员已经在场上";
            }
            else if(messageType==MyPopUpWindowType.OnBench)
            {
                lblMessage.Text = "该运动员已经在场下";
            }

        }

        public const Int32 AW_HOR_POSITIVE = 0x00000001; // 从左到右打开窗口
        public const Int32 AW_HOR_NEGATIVE = 0x00000002; // 从右到左打开窗口
        public const Int32 AW_VER_POSITIVE = 0x00000004; // 从上到下打开窗口
        public const Int32 AW_VER_NEGATIVE = 0x00000008; // 从下到上打开窗口
        public const Int32 AW_CENTER = 0x00000010; //若使用了AW_HIDE标志，则使窗口向内重叠；若未使用AW_HIDE标志，则使窗口向外扩展。
        public const Int32 AW_HIDE = 0x00010000; //隐藏窗口，缺省则显示窗口。
        public const Int32 AW_ACTIVATE = 0x00020000; //激活窗口。在使用了AW_HIDE标志后不要使用这个标志。
        public const Int32 AW_SLIDE = 0x00040000; //使用滑动类型。缺省则为滚动动画类型。当使用AW_CENTER标志时，这个标志就被忽略。
        public const Int32 AW_BLEND = 0x00080000; //使用淡出效果。只有当hWnd为顶层窗口的时候才可以使用此标志。
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern bool AnimateWindow(
          IntPtr hwnd, // handle to window
          int dwTime, // duration of animation
          int dwFlags // animation type
          );

        private void MyPopUpWindow_Load(object sender, EventArgs e)
        {
            MyPopUpWindow.AnimateWindow(this.Handle, 300, MyPopUpWindow.AW_BLEND);
        }

        private void MyPopUpWindow_FormClosing(object sender, FormClosingEventArgs e)
        {
            MyPopUpWindow.AnimateWindow(this.Handle, 300, MyPopUpWindow.AW_SLIDE | MyPopUpWindow.AW_HIDE | MyPopUpWindow.AW_BLEND);
        }

        

    }
}
