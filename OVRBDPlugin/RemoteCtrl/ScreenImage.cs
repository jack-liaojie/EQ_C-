using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace RomoteControl
{
    public class ScreenImage
    {
        public static Bitmap TakeScreenPhoto(int nWidth, int nHeight )
        {
            Screen scr = Screen.PrimaryScreen;
            Rectangle rc = scr.Bounds;
            int iWidth = rc.Width;
            int iHeight = rc.Height;
            Bitmap myImage = new Bitmap(iWidth, iHeight);
            Graphics g1 = Graphics.FromImage(myImage);
            g1.CopyFromScreen(new Point(0, 0), new Point(0, 0), new Size(iWidth, iHeight));
            

            CURSORINFO vInfo;
            vInfo.cbSize = Marshal.SizeOf(typeof(CURSORINFO));
            GetCursorInfo(out vInfo);
            Cursor cursor = new Cursor(vInfo.hCursor);
            cursor.Draw(g1, new Rectangle(vInfo.ptScreenPos, cursor.Size));

               Bitmap newImage = new Bitmap(nWidth, nHeight);
            Graphics g2 = Graphics.FromImage(newImage);
            g2.DrawImage(myImage, 0, 0, nWidth, nHeight);
            return newImage;
        }

        public static Bitmap TakeScreenPhoto()
        {
            Screen scr = Screen.PrimaryScreen;
            Rectangle rc = scr.Bounds;
            int iWidth = rc.Width;
            int iHeight = rc.Height;
            Bitmap myImage = new Bitmap(iWidth, iHeight);
            Graphics g1 = Graphics.FromImage(myImage);
            g1.CopyFromScreen(new Point(0, 0), new Point(0, 0), new Size(iWidth, iHeight));
            CURSORINFO vInfo;
            vInfo.cbSize = Marshal.SizeOf(typeof(CURSORINFO));
            GetCursorInfo(out vInfo);
            if ( vInfo.hCursor != IntPtr.Zero)
            {
                Cursor cursor = new Cursor(vInfo.hCursor);
                cursor.Draw(g1, new Rectangle(vInfo.ptScreenPos, cursor.Size));   
            }
            
            return myImage;
        }

        [StructLayout(LayoutKind.Sequential)]
        struct CURSORINFO
        {
            public int cbSize;
            public int flags;
            public IntPtr hCursor;
            public Point ptScreenPos;
        }
        [DllImport("user32.dll")]
        static extern bool GetCursorInfo(out CURSORINFO pci);
        private const int CURSOR_SHOWING = 0x00000001;

    }
}
