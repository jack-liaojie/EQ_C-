using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.IO;

namespace OVRDVPlugin
{
    public class DVCommon
    {
        [DllImport("shell32.dll", CharSet = CharSet.Unicode)]
        public static extern IntPtr ShellExecute(IntPtr hwnd, string lpOperation, string lpFile, IntPtr lpParameters, IntPtr lpDirectory, UInt32 nShowCmd);

        public static void OpenWithNotepad(string strFilePath)
        {
            ShellExecute(IntPtr.Zero, "edit", strFilePath, IntPtr.Zero, IntPtr.Zero, 1);
        }

        public static string GetAppRootDir()
        {
            string curExePath = System.AppDomain.CurrentDomain.BaseDirectory;
            return System.IO.Path.GetDirectoryName(curExePath);
        }
        public static void OpenFolderInExplorer(string folderPath)
        {
            if (!Directory.Exists(folderPath))
            {
                return;
            }

            ShellExecute(IntPtr.Zero, "explore", folderPath, IntPtr.Zero, IntPtr.Zero, 1);
        }
        public const String g_strDisplnCode = "DV";
        public const String g_strDisplnName = "Tennis";
        public const String g_strSectionName = "OVRDVPlugin";

        public static SqlConnection g_DataBaseCon;
        public static OVRDVPlugin g_DVPlugin;
        public static OVRDVDBManager g_DVDBManager;

        public const Int32 STATUS_NOUSED = 0;
        public const Int32 STATUS_AVAILABLE = 10;
        public const Int32 STATUS_CONFIGURED = 20;
        public const Int32 STATUS_SCHEDULE = 30;
        public const Int32 STATUS_STARTLIST = 40;
        public const Int32 STATUS_RUNNING = 50;
        public const Int32 STATUS_SUSPEND = 60;
        public const Int32 STATUS_UNOFFICIAL = 100;
        public const Int32 STATUS_FINISHED = 110;
        public const Int32 STATUS_REVISION = 120;
        public const Int32 STATUS_CANCELED = 130;

        public static Int32 Str2Int(Object strObj)
        {
            if (strObj == null) return 0;
            if (strObj.ToString().Length == 0) return 0;

            try
            {
                return Convert.ToInt32(strObj);
            }
            catch (System.Exception errorFmt)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(errorFmt.ToString());
            }
            return 0;
        }
    }
}
