using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Windows.Forms;
using AutoSports.OVRCommon;
using System.Text.RegularExpressions;
using System.Data;
using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    //全局变量和工具
    public class GVAR
    {
        public const String g_strDisplnCode = "EQ";
        public const String g_strDisplnName = "Equestrian";
        public const String g_strSectionName = "OVREQPlugin";

        public static OVREQDataBase g_adoDataBase;
        public static OVREQPlugin g_EQPlugin;
        public static OVREQDBManager g_EQDBManager;

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

        //盛装舞步打分状态
        public const Int32 SCORE_STATUS_NOTSTARTED = 0;
        public const Int32 SCORE_STATUS_STARTED = 1;
        public const Int32 SCORE_STATUS_FINISHED = 2;

        #region 静态工具函数
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
                MessageBox.Show(errorFmt.ToString());
            }
            return 0;
        }

        public static Decimal Str2Decimal(Object strObj)
        {
            if (strObj == null) return 0;
            if (strObj.ToString().Length == 0) return 0;

            try
            {
                return Convert.ToDecimal(strObj); 
            }
            catch (System.Exception errorFmt)
            {
                MessageBox.Show(errorFmt.ToString());
            }
            return 0;
        }

        public static float Str2float(Object strObj)
        {
            if (strObj == null) return 0.0f;
            if (strObj.ToString().Length == 0) return 0.0f;

            try
            {
                return Convert.ToSingle(strObj);
            }
            catch (System.Exception errorFmt)
            {
                MessageBox.Show(errorFmt.ToString());
            }
            return 0;
        }

        public static double Str2Double(Object strObj)
        {
            if (strObj == null) return 0.0;
            if (strObj.ToString().Length == 0) return 0.0;

            try
            {
                return Convert.ToDouble(strObj);
            }
            catch (System.Exception errorFmt)
            {
                MessageBox.Show(errorFmt.ToString());
            }
            return 0;
        }

        public static Decimal StrTime2Decimal(Object strObj)
        {
            if (strObj == null) return 0;
            if (strObj.ToString().Length == 0) return 0;

            try
            {
                string[] sArray = strObj.ToString().Split(new string[] { "'" }, StringSplitOptions.RemoveEmptyEntries);
                return GVAR.Str2Decimal(sArray[0]) * 60 + GVAR.Str2Decimal(sArray[1]);
            }
            catch (System.Exception errorFmt)
            {
                MessageBox.Show(errorFmt.ToString());
            }
            return 0;
        }

        public static string StrTime2SpanTime(Object strObj)
        {
            if (strObj == null) return "00:00:00";
            if (strObj.ToString().Length == 0) return "00:00:00";

            try
            {
                string[] sArray = strObj.ToString().Split(new string[] { "'" }, StringSplitOptions.RemoveEmptyEntries);
                return "00:"+sArray[0]+":"+sArray[1];
            }
            catch (System.Exception errorFmt)
            {
                MessageBox.Show(errorFmt.ToString());
            }
            return "00:00:00";
        }

        public static string Float2StrTime(Object strObj)
        {
            string strTime = "";
            if (strObj == null) return "";
            if (strObj.ToString().Length == 0) return "";

            try
            {
                TimeSpan ts = TimeSpan.FromSeconds(Str2Int(strObj.ToString()));
                strTime = ts.Minutes.ToString() + "'"
                    + ts.Seconds.ToString() + "''";
            }
            catch (System.Exception errorFmt)
            {
                MessageBox.Show(errorFmt.ToString());
            }
            return strTime;
        }

        public static String Key2Val(Dictionary<String, String> Dicts, String Key)
        {
            try
            {
                return Dicts[Key];
            }
            catch
            {
                return null;
            }
        }

        public static string GetAppRootDir()
        {
            string curExePath = System.AppDomain.CurrentDomain.BaseDirectory;
            return System.IO.Path.GetDirectoryName(curExePath);
        }

        public static void MsgBox(string strInfo)
        {
            MsgBox(strInfo, MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        public static void MsgBox(string strInfo, string strTitle)
        {
            MsgBox(strInfo, strTitle, MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        public static void MsgBox(string strInfo, MessageBoxIcon msgIcon)
        {
            MsgBox(strInfo, MessageBoxButtons.OK, msgIcon);
        }

        public static DialogResult MsgBox(string strInfo, MessageBoxButtons msgBtn, MessageBoxIcon msgIcon)
        {
            return DevComponents.DotNetBar.MessageBoxEx.Show(strInfo, "Athletics", msgBtn, msgIcon);
        }

        public static void MsgBox(string strInfo, string strTitle, MessageBoxIcon msgIcon)
        {
            MsgBox(strInfo, strTitle, MessageBoxButtons.OK, msgIcon);
        }

        public static DialogResult MsgBox(string strInfo, string title, MessageBoxButtons msgBtn, MessageBoxIcon msgIcon)
        {
            return DevComponents.DotNetBar.MessageBoxEx.Show(strInfo, title, msgBtn, msgIcon, MessageBoxDefaultButton.Button2);
        }

        public static Int32 GetFieldValueFromDGV(DataGridView dgv, Int32 iRowIndex, String strFiledName)
        {
            Int32 iReturnValue = 0;
            if (dgv.Columns[strFiledName] == null || dgv.Rows[iRowIndex].Cells[strFiledName].Value.ToString() == "")
            {
                iReturnValue = 0;
            }
            else
            {
                iReturnValue = Convert.ToInt32(dgv.Rows[iRowIndex].Cells[strFiledName].Value);
            }
            return iReturnValue;
        }

        /// <summary>
        /// 执行DataTable中的查询返回新的DataTable
        /// </summary>
        /// <param name="dt">源数据DataTable</param>
        /// <param name="condition">查询条件</param>
        /// <returns></returns>
        public static DataTable GetNewDataTable(DataTable dt, string condition)
        {
            DataTable newdt = new DataTable();
            newdt = dt.Clone();
            DataRow[] dr = dt.Select(condition);
            for (int i = 0; i < dr.Length; i++)
            {
                newdt.ImportRow((DataRow)dr[i]);
            }
            return newdt;//返回的查询结果
        }

        public static void FillCombox(UIComboBox cmb, SqlDataReader dr, int nValueIdx, int nKeyIdx, String strLanguageCode)
        {
            cmb.Items.Clear();

            if (nValueIdx > dr.FieldCount || nValueIdx < 0
                || nKeyIdx > dr.FieldCount || nKeyIdx < 0)
                return;

            int nSelItemIdx = -1;
            int nItemIdx = 0;
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    cmb.Items.Add(new OVRCustomComboBoxItem(dr[nKeyIdx].ToString(), dr[nValueIdx].ToString()));

                    if (dr[nKeyIdx].ToString().CompareTo(strLanguageCode) == 0)
                    {
                        nSelItemIdx = nItemIdx;
                    }
                    nItemIdx++;
                }
                cmb.DisplayMember = "Tag";
                cmb.ValueMember = "Value";
                cmb.SelectedIndex = nSelItemIdx;
            }
        }
        #endregion
    }

    //表记录集
    public class STableRecordSet
    {
        public ArrayList m_straFieldNames;
        public ArrayList m_str2aRecords;

        public int GetRecordCount()
        {
            return m_str2aRecords.Count;
        }
        public int GetFieldCount()
        {
            return m_straFieldNames.Count;
        }

        public String GetFieldName(int nFieldIdx)
        {
            return (String)m_straFieldNames[nFieldIdx];
        }

        public int GetFieldIdx(String strFieldName)
        {
            return m_straFieldNames.IndexOf(strFieldName);
        }

        public String GetFieldValue(int nRowIdx, String strFieldName)
        {
            int nColIdx = GetFieldIdx(strFieldName);
            if (nColIdx < 0) return "";
            return (String)((ArrayList)m_str2aRecords[nRowIdx])[nColIdx];
        }

        public String GetFieldValue(int nRowIdx, int nColIdx)
        {
            return (String)((ArrayList)m_str2aRecords[nRowIdx])[nColIdx];
        }
    }

    //正则工具
    public class RegexDao
    {
        private RegexDao() { }

        private static RegexDao instance = null;
        /// <summary>
        /// 静态实例化单体模式
        /// 保证应用程序操作某一全局对象，让其保持一致而产生的对象
        /// </summary>
        /// <returns></returns>
        public static RegexDao GetInstance()
        {
            if (RegexDao.instance == null)
            {
                RegexDao.instance = new RegexDao();
            }
            return RegexDao.instance;
        }

        /// <summary>
        /// 判断输入的字符串只包含汉字
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static bool IsChineseCh(string input)
        {
            return IsMatch(@"^[\u4e00-\u9fa5]+$", input);
        }

        /// <summary>
        /// 匹配3位或4位区号的电话号码，其中区号可以用小括号括起来，
        /// 也可以不用，区号与本地号间可以用连字号或空格间隔，
        /// 也可以没有间隔
        /// \(0\d{2}\)[- ]?\d{8}|0\d{2}[- ]?\d{8}|\(0\d{3}\)[- ]?\d{7}|0\d{3}[- ]?\d{7}
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static bool IsPhone(string input)
        {
            string pattern = "^\\(0\\d{2}\\)[- ]?\\d{8}$|^0\\d{2}[- ]?\\d{8}$|^\\(0\\d{3}\\)[- ]?\\d{7}$|^0\\d{3}[- ]?\\d{7}$";
            return IsMatch(pattern, input);
        }

        /// <summary>
        /// 判断输入的字符串是否是一个合法的手机号
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static bool IsMobilePhone(string input)
        {
            return IsMatch(@"^13\\d{9}$", input);
        }

        /// <summary>
        /// 判断输入的字符串只包含数字
        /// 可以匹配整数和浮点数
        /// ^-?\d+$|^(-?\d+)(\.\d+)?$
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static bool IsNumber(string input)
        {
            string pattern = "^-?\\d+$|^(-?\\d+)(\\.\\d+)?$";
            return IsMatch(pattern, input);
        }

        /// <summary>
        /// 匹配非负整数
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static bool IsNotNagtive(string input)
        {
            return IsMatch(@"^\d+$", input);
        }
        /// <summary>
        /// 匹配正整数
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static bool IsUint(string input)
        {
            return IsMatch(@"^[0-9]*[1-9][0-9]*$", input);
        }

        /// <summary>
        /// 判断输入的字符串字包含英文字母
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static bool IsEnglisCh(string input)
        {
            return IsMatch(@"^[A-Za-z]+$", input);
        }


        /// <summary>
        /// 判断输入的字符串是否是一个合法的Email地址
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static bool IsEmail(string input)
        {
            string pattern = @"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$";
            return IsMatch(pattern, input);
        }


        /// <summary>
        /// 判断输入的字符串是否只包含数字和英文字母
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static bool IsNumAndEnCh(string input)
        {
            return IsMatch(@"^[A-Za-z0-9]+$", input);
        }


        /// <summary>
        /// 判断输入的字符串是否是一个超链接
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static bool IsURL(string input)
        {
            string pattern = @"^[a-zA-Z]+://(\w+(-\w+)*)(\.(\w+(-\w+)*))*(\?\S*)?$";
            return IsMatch(pattern, input);
        }


        /// <summary>
        /// 判断输入的字符串是否是表示一个IP地址
        /// </summary>
        /// <param name="input">被比较的字符串</param>
        /// <returns>是IP地址则为True</returns>
        public static bool IsIPv4(string input)
        {
            string[] IPs = input.Split(new char[]{'.'});
                        
            for (int i = 0; i < IPs.Length; i++)
            {
                if (!IsMatch(@"^\d+$",IPs[i]))
                {
                    return false;
                }
                if (Convert.ToUInt16(IPs[i]) > 255)
                {
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// 判断输入的字符串是否是合法的IPV6 地址
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static bool IsIPV6(string input)
        {
            string pattern = "";
            string temp = input;
            string[] strs = temp.Split(new char[] { ':' });
            if (strs.Length > 8)
            {
                return false;
            }
            int count = RegexDao.GetStringCount(input, "::");
            if (count > 1)
            {
                return false;
            }
            else if (count == 0)
            {
                pattern = @"^([\da-f]{1,4}:){7}[\da-f]{1,4}$";
                return IsMatch(pattern, input);
            }
            else
            {
                pattern = @"^([\da-f]{1,4}:){0,5}::([\da-f]{1,4}:){0,5}[\da-f]{1,4}$";
                return IsMatch(pattern, input);
            }
        }

        #region 正则的通用方法
        /// <summary>
        /// 计算字符串的字符长度，一个汉字字符将被计算为两个字符
        /// </summary>
        /// <param name="input">需要计算的字符串</param>
        /// <returns>返回字符串的长度</returns>
        public static int GetCount(string input)
        {
            return Regex.Replace(input, @"[\u4e00-\u9fa5/g]", "aa").Length;
        }

        /// <summary>
        /// 调用Regex中IsMatch函数实现一般的正则表达式匹配
        /// </summary>
        /// <param name="pattern">要匹配的正则表达式模式。</param>
        /// <param name="input">要搜索匹配项的字符串</param>
        /// <returns>如果正则表达式找到匹配项，则为 true；否则，为 false。</returns>
        public static bool IsMatch(string pattern, string input)
        {
            if (input == null || input == "") return false;
            Regex regex = new Regex(pattern);
            return regex.IsMatch(input);
        }

        /// <summary>
        /// 从输入字符串中的第一个字符开始，用替换字符串替换指定的正则表达式模式的所有匹配项。
        /// </summary>
        /// <param name="pattern">模式字符串</param>
        /// <param name="input">输入字符串</param>
        /// <param name="replacement">用于替换的字符串</param>
        /// <returns>返回被替换后的结果</returns>
        public static string Replace(string pattern, string input, string replacement)
        {
            Regex regex = new Regex(pattern);
            return regex.Replace(input, replacement);
        }

        /// <summary>
        /// 在由正则表达式模式定义的位置拆分输入字符串。
        /// </summary>
        /// <param name="pattern">模式字符串</param>
        /// <param name="input">输入字符串</param>
        /// <returns></returns>
        public static string[] Split(string pattern, string input)
        {
            Regex regex = new Regex(pattern);
            return regex.Split(input);
        }

        /* *******************************************************************
         * 1、通过“:”来分割字符串看得到的字符串数组长度是否小于等于8
         * 2、判断输入的IPV6字符串中是否有“::”。
         * 3、如果没有“::”采用 ^([\da-f]{1,4}:){7}[\da-f]{1,4}$ 来判断
         * 4、如果有“::” ，判断"::"是否止出现一次
         * 5、如果出现一次以上 返回false
         * 6、^([\da-f]{1,4}:){0,5}::([\da-f]{1,4}:){0,5}[\da-f]{1,4}$
         * ******************************************************************/
        /// <summary>
        /// 判断字符串compare 在 input字符串中出现的次数
        /// </summary>
        /// <param name="input">源字符串</param>
        /// <param name="compare">用于比较的字符串</param>
        /// <returns>字符串compare 在 input字符串中出现的次数</returns>
        private static int GetStringCount(string input, string compare)
        {
            int index = input.IndexOf(compare);
            if (index != -1)
            {
                return 1 + GetStringCount(input.Substring(index + compare.Length), compare);
            }
            else
            {
                return 0;
            }

        }

        #endregion
    }
}
