using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;

namespace RomoteControl
{
    public class ProtocolCommon
    {
        public const UInt32 PACKAGE_HEADER = 0xFFFFFFFF;
        public const UInt32 MOUSEEVENTF_MOVE = 0x0001; /* mouse move */
        public const UInt32 MOUSEEVENTF_LEFTDOWN = 0x0002; /* left button down */
        public const UInt32 MOUSEEVENTF_LEFTUP = 0x0004; /* left button up */
        public const UInt32 MOUSEEVENTF_RIGHTDOWN = 0x0008; /* right button down */
        public const UInt32 MOUSEEVENTF_RIGHTUP = 0x0010; /* right button up */
        public const UInt32 MOUSEEVENTF_MIDDLEDOWN = 0x0020; /* middle button down */
        public const UInt32 MOUSEEVENTF_MIDDLEUP = 0x0040; /* middle button up */
        public const UInt32 MOUSEEVENTF_XDOWN = 0x0080; /* x button down */
        public const UInt32 MOUSEEVENTF_XUP = 0x0100; /* x button down */
        public const UInt32 MOUSEEVENTF_WHEEL = 0x0800; /* wheel button rolled */
        public const UInt32 MOUSEEVENTF_ABSOLUTE = 0x8000; /* absolute move */
    }
    public enum PackageType : int
    {
        RequestControl = 0x1,
        MouseMove = 0x02,
        MouseClick = 0x04,
        DeskPicture = 0x08,
        KeybdEventDown = 0x10,
        KeybdEventUp = 0x20
    }
    public enum MouseClickType
    {
        ClickTypeLeftClick = 1,
        ClickTypeLeftDoubleClick =  2,
        ClickTypeRightClick =3,
        ClickTypeRightDoubleClick = 4,
        ClickTypeMouseLeftDown = 5,
        ClickTypeMouseRightDown = 6,
        ClickTypeMouseLeftUp = 7,
        ClickTypeMouseRightUp = 8,
    }
    public class DataProtocol
    {
        public static byte[] MakePackage(byte[] data)
        {
            MemoryStream stream = new MemoryStream();
            BinaryWriter writer = new BinaryWriter(stream);
            writer.Write(ProtocolCommon.PACKAGE_HEADER);
            writer.Write(data.Length);
            writer.Write(data);
            writer.Flush();
            byte[] res = stream.ToArray();
            writer.Close();
            stream.Close();
            return res;
        }

        public static byte[] GetMouseClickPackage( MouseClickType clickType, int x, int y)
        {
            MemoryStream stream = new MemoryStream();
            BinaryWriter writer = new BinaryWriter(stream);
            writer.Write((int)PackageType.MouseClick);
            writer.Write((int)clickType);
            writer.Write(x);
            writer.Write(y);
            writer.Flush();
            byte[] res = stream.ToArray();
            writer.Close();
            stream.Close();
            return res;
        }

        public static byte[] GetPicPackage( Bitmap bitmap)
        {
            MemoryStream stream = new MemoryStream();
            bitmap.Save(stream, ImageFormat.Jpeg);
            byte[] res = stream.ToArray();
            stream.Close();

            stream = new MemoryStream();
            BinaryWriter writer = new BinaryWriter(stream);
            writer.Write((int)PackageType.DeskPicture);
            writer.Write(res.Length);
            writer.Write(res);
            writer.Flush();
            byte[] res2 = stream.ToArray();
            writer.Close();
            stream.Close();
            return res2;
        }

        public static byte[] GetMouseMovePackage(int x, int y)
        {
            MemoryStream stream = new MemoryStream();
            BinaryWriter writer = new BinaryWriter(stream);
            writer.Write((int)PackageType.MouseMove);
            writer.Write(x);
            writer.Write(y);
            writer.Flush();
            byte[] res = stream.ToArray();
            writer.Close();
            stream.Close();
            return res;
        }
        public static byte[] GetKeyBdPackage(byte keyVal, PackageType type)
        {
            MemoryStream stream = new MemoryStream();
            BinaryWriter writer = new BinaryWriter(stream);
            writer.Write((int)type);
            writer.Write(keyVal);
            writer.Flush();
            byte[] res = stream.ToArray();
            writer.Close();
            stream.Close();
            return res;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="frameRate">每秒的帧速</param>
        /// <returns></returns>
        public static byte[] GetRequestControlPackage(int frameRate)
        {
            MemoryStream stream = new MemoryStream();
            BinaryWriter writer = new BinaryWriter(stream);
            writer.Write((int)PackageType.RequestControl);
            writer.Write(frameRate);
            writer.Flush();
            byte[] res = stream.ToArray();
            writer.Close();
            stream.Close();
            return res;
        }

        public static void RecvPackage( byte []data)
        {
            MemoryStream stream = new MemoryStream(data);
            BinaryReader reader = new BinaryReader(stream);
            PackageType pType = (PackageType)reader.ReadInt32();
            switch(pType)
            {
                case PackageType.DeskPicture:
                    break;
                case PackageType.MouseClick:
                    break;
                case PackageType.MouseMove:
                    break;
                case PackageType.RequestControl:
                    break;
                case PackageType.KeybdEventDown:
                    break;
                case PackageType.KeybdEventUp:
                    break;
            }
            reader.Close();
            stream.Close();
        }
    }
}
