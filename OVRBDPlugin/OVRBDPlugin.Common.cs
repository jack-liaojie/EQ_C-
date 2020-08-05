using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;
using System.Windows.Forms;

namespace AutoSports.OVRBDPlugin
{
    //SexType不能随便改动，要和数据库一致
    public enum SexType : int
    {
        All = 0,
        Men = 1,
        Women = 2,
        Mixed = 3,
    }

    //局数量类型，用于输入时间界面的局显示
    public enum GameCountType : int
    {
        GameCountThird = 3,
        GameCountFive = 5,
        GameCountSeven = 7,
    }

    public enum GetByeMatchType : int
    {
        GetByeTypeNotSend = 1,
        GetByeTypeAll = 2
    }

    public enum ScoreType : int
    {
        MatchScore = 1,
        SetScore = 2,
        GameScore = 3
    }

    public enum WinnerType : int
    {
        WinA = 1,
        WinB = 2
    }

    public class BDCommon
    {
        [DllImport("shell32.dll", CharSet = CharSet.Unicode)]
        public static extern IntPtr ShellExecute(IntPtr hwnd, string lpOperation, string lpFile, IntPtr lpParameters, IntPtr lpDirectory, UInt32 nShowCmd);
        public const Int32 MATCH_TYPE_SINGLE = 1;
        public const Int32 MATCH_TYPE_DOULBE = 2;        
        public const Int32 MATCH_TYPE_TEAM = 3;

        public const String MATCH_TYPENAME_SINGLE = "Single";
        public const String MATCH_TYPENAME_Double = "Double";
        public const String MATCH_TYPENAME_TEAM = "Team";

        public const Int32 PAR_TYPE_SCORE = 1;
        public const Int32 SOS_TYPE_SCORE = 2;

        public const Int32 RESULT_TYPE_WIN = 1;
        public const Int32 RESULT_TYPE_LOSE = 2;
        public const Int32 RESULT_TYPE_TIE = 3;

        public const Int32 RANK_TYPE_1ST = 1;
        public const Int32 RANK_TYPE_2ND = 2;
        public const Int32 RANK_TYPE_TIE = 0;

        public const Int32 NONE_POINT = 0;
        public const Int32 A_GAMEPOINT = 1;
        public const Int32 B_GAMEPOINT = 2;
        public const Int32 A_MATCHPOINT = 3;
        public const Int32 B_MATCHPOINT = 4;
        public const Int32 STATUS_SCHEDULE = 30;
        public const Int32 STATUS_STARTLIST = 40;
        public const Int32 STATUS_RUNNING = 50;
        public const Int32 STATUS_SUSPEND = 60;
        public const Int32 STATUS_UNOFFICIAL = 100;
        public const Int32 STATUS_FINISHED = 110;
        public const Int32 STATUS_REVISION = 120;
        public const Int32 STATUS_CANCELED = 130;

        public const String PLAYER_STATUS_RET = "RET";
        public const String PLAYER_STATUS_WD = "WD";
        public const String PLAYER_STATUS_DBD = "DBD";
        public const String PLAYER_STATUS_WO = "WO";

        public static Color COLOR_SCORE_BK = System.Drawing.Color.FromArgb(220, 220, 220);
        public static Color COLOR_SCORE_FG = System.Drawing.Color.FromArgb(255, 0, 0);
        public static Color OVR_CLIENT_3DFACE = System.Drawing.Color.FromArgb(184, 207, 233);
        public static Color OVR_CTRL_3DFACE = System.Drawing.Color.FromArgb(212, 228, 242);

        public static Color OVR_GRID_ODD_ROW_COLOR = System.Drawing.Color.FromArgb(230, 239, 248);
        public static Color OVR_GRID_EVEN_ROW_COLOR = System.Drawing.Color.FromArgb(202, 221, 238);

        public static Color OVR_GRID_ATHLETE_COLUMN_COLOR = System.Drawing.Color.DarkGray;

        public static String g_strDisplnCode = "BD";
        public const String g_strDisplnName = "Badminton";
        public const String g_strLang = "CHN";
        public const String g_strExSchduleFileName = "Schedule";
        public const String g_strExAthleteFileName = "AthleteList";
        public const String g_strImPortMatchInfoMode = "MatchInfo_*.xml";
        public const String g_strImPortActionMode = "ScoreList_*.xml";
        public const String g_strParsedFolderName = "ParsedXml";
        public const uint MSG_FLAG_CONTROL = 0xFFFF0020;
        public const uint MSG_FLAG_CTRL_RES = 0xFFFF0040;   
        public const uint MSG_FLAG_MSG = 0xFFFF0080;
        public const uint MSG_FLAG_HEART = 0xFFFF0010;
        public const uint MSG_FLAG_TRANS_DATA = 0xFFFF0100;
        public const uint MSG_FLAG_SEND_SET = 0xFFFF0200;
        public const int UDP_CTRL_PORT = 10500;


        public const String m_strSectionName = "OVRBDPlugin";
        public const String HEART_FILE_NAME = "TT_HEART.XML";

        public static OVRBDPlugin g_BDPlugin;
        public static OVRBDDataBase g_adoDataBase;
        public static OVRBDManageDB g_ManageDB;
        public static TcpServerSimple g_vTcpServer;
        public static OVRErrorLog g_errorLog;


        //Action Code
        public static string strAction_addScore = "+1";

        public static Int32 Str2Int(Object strObj)
        {
            if (strObj == null) return 0;

            try
            {
                return Convert.ToInt32(strObj);
            }
            catch
            {                
            }
            return 0;
        }

        public static string GetTempMatchDir()
        {
            string curExePath = System.AppDomain.CurrentDomain.BaseDirectory;
            string strRoot = System.IO.Path.GetDirectoryName(curExePath);
            string strDir = Path.Combine(strRoot, "TempMatchData");
            if ( !Directory.Exists(strDir))
            {
                Directory.CreateDirectory(strDir);
            }
            return strDir;
        }

        public static String Key2Val(Dictionary<String, String> Dicts, String Key)
        {
            try
            {
                return Dicts[Key];
            }
            catch (System.Exception e)
            {
                MessageBox.Show(e.ToString());
                return null;
            }
        }

        public static string ToHexString(byte[] bytes)
        {
            char[] c = new char[bytes.Length * 2];

            byte b;

            for (int bx = 0, cx = 0; bx < bytes.Length; ++bx, ++cx)
            {
                b = ((byte)(bytes[bx] >> 4));
                c[cx] = (char)(b > 9 ? b + 0x37 + 0x20 : b + 0x30);

                b = ((byte)(bytes[bx] & 0x0F));
                c[++cx] = (char)(b > 9 ? b + 0x37 + 0x20 : b + 0x30);
            }

            return new string(c);
        }

        public static void Writelog(string strDiscrib, string strReason = "")
        {
            BDCommon.g_errorLog.Writelog(strDiscrib, strReason);
        }

        public static string GetPluginVersionStr()
        {
            string curDllPath = Assembly.GetExecutingAssembly().Location;
            DateTime lastWrTime = File.GetLastWriteTime(curDllPath);
            string lastTimeString = lastWrTime.ToString("u");
            lastTimeString = lastTimeString.TrimEnd('Z');
            byte[] bytContent = File.ReadAllBytes(curDllPath);

            HashAlgorithm alg = HashAlgorithm.Create("MD5");
            byte[] val = alg.ComputeHash(bytContent);
            string md5Str = ToHexString(val);
            return string.Format("Plugin version date:{0}  MD5:{1}", lastTimeString, md5Str);
        }

        public static void ForceCopyFile( string sourcePath, string desPath)
        {
            bool bSucceed = false;
            for (int i = 0; i < 100; i++ )
            {
                try
                {
                    File.Copy(sourcePath, desPath, true);
                    bSucceed = true;
                }
                catch (Exception e)
                {
                    System.Diagnostics.Trace.WriteLine(string.Format("copy {0} exception!{1}", sourcePath, e.Message));
                    if (Marshal.GetHRForException(e) == -2147024864 )
                    {
                        continue;
                    }
                    else
                    {
                        BDCommon.g_errorLog.Writelog(string.Format("ForceCopyFile失败", e.Message));
                    }
                }
            }
            if ( !bSucceed)
            {
                BDCommon.g_errorLog.Writelog(string.Format("ForeCopyFile尝试拷贝{0}失败次数达到100次", sourcePath));
            }
        }

        public static void ShellOpenFile(string strFilePath)
        {
            ShellExecute(IntPtr.Zero, "open", strFilePath, IntPtr.Zero, IntPtr.Zero, 1);
        }

        public static void OpenWithNotepad(string strFilePath)
        {
            ShellExecute(IntPtr.Zero, "edit", strFilePath, IntPtr.Zero, IntPtr.Zero, 1);
        }
    }

    public class IOExceptionEx : System.IO.IOException
    {
        public UInt32 ErrorCode
        {
            get { return (UInt32)base.HResult; }
        }
    }

    public class STableRecordSet
    {
        public ArrayList m_straFieldNames;
        public ArrayList m_str2aRecords;

        public Int32 GetRecordCount()
        {
            return m_str2aRecords.Count;
        }

        public Int32 GetFieldCount()
        {
            return m_straFieldNames.Count;
        }

        public String GetFieldName(Int32 nFieldIdx)
        {
            return (String)m_straFieldNames[nFieldIdx];
        }

        public Int32 GetFieldIdx(String strFieldName)
        {
            return m_straFieldNames.IndexOf(strFieldName);
        }

        public String GetFieldValue(Int32 nRowIdx, String strFieldName)
        {
            Int32 nColIdx = GetFieldIdx(strFieldName);
            if (nColIdx < 0) return "";

            return (String)((ArrayList)m_str2aRecords[nRowIdx])[nColIdx];
        }

        public String GetFieldValue(Int32 nRowIdx, Int32 nColIdx)
        {
            return (String)((ArrayList)m_str2aRecords[nRowIdx])[nColIdx];
        }
    }
    public class OVRErrorLog
    {
        private string m_strDiscCode;
        private string m_strLogFilePath;
        private bool bInit = false;
        private const bool FLAG_WRITE_LOG = true;
        public OVRErrorLog(string strDiscCode)
        {
            m_strDiscCode = strDiscCode;
        }
        public void Initialize()
        {
            if (!FLAG_WRITE_LOG)
            {
                return;
            }
            if (CreateLogDir())
            {
                bInit = true;
            }
            else
            {
                bInit = false;
            }
        }


        public void Writelog(string errDiscribe, string errReason = "")
        {
            if (!FLAG_WRITE_LOG || !bInit)
            {
                return;
            }
            try
            {

                string strDateTime = DateTime.Now.ToString("u");
                strDateTime = strDateTime.TrimEnd('Z');
                string strMsg = "";
                if (errReason == "")
                {
                    strMsg = string.Format("{0} 日志信息：{1}", strDateTime, errDiscribe);
                }
                else
                {
                    strMsg = string.Format("{0} 日志信息：{1}|原因：{2}", strDateTime, errDiscribe, errReason);
                }
                StreamWriter sWriter = new StreamWriter(File.Open(m_strLogFilePath, FileMode.OpenOrCreate));
                sWriter.BaseStream.Seek(0, SeekOrigin.End);
                sWriter.WriteLine(strMsg);
                sWriter.Close();
            }
            catch 
            {

            }

        }
        private bool CreateLogDir()
        {
            try
            {
                if (!Directory.Exists(@"C:\OVRErrorLog"))
                {
                    Directory.CreateDirectory(@"C:\OVRErrorLog");
                }

                m_strLogFilePath = string.Format(@"C:\OVRErrorLog\{0}_Err.log", m_strDiscCode);
                return true;
            }
            catch
            {
                return false;
            }

        }
    }

    public class INIClass
    {
        public string inipath;
        [DllImport("kernel32")]
        private static extern long WritePrivateProfileString(string section, string key, string val, string filePath);
        [DllImport("kernel32")]
        private static extern int GetPrivateProfileString(string section, string key, string def, StringBuilder retVal, int size, string filePath);
        /// <summary> 
        /// 构造方法 
        /// </summary> 
        /// <param name="INIPath">文件路径</param> 
        public INIClass(string INIPath)
        {
            inipath = INIPath;
        }
        /// <summary> 
        /// 写入INI文件 
        /// </summary> 
        /// <param name="Section">项目名称(如 [TypeName] )</param> 
        /// <param name="Key">键</param> 
        /// <param name="Value">值</param> 
        public void IniWriteValue(string Section, string Key, string Value)
        {
            WritePrivateProfileString(Section, Key, Value, this.inipath);
        }
        /// <summary> 
        /// 读出INI文件 
        /// </summary> 
        /// <param name="Section">项目名称(如 [TypeName] )</param> 
        /// <param name="Key">键</param> 
        public string IniReadValue(string Section, string Key)
        {
            StringBuilder temp = new StringBuilder(500);
            int i = GetPrivateProfileString(Section, Key, "", temp, 500, this.inipath);
            return temp.ToString();
        }
        /// <summary> 
        /// 验证文件是否存在 
        /// </summary> 
        /// <returns>布尔值</returns> 
        public bool ExistINIFile()
        {
            return File.Exists(inipath);
        }


    }
}
