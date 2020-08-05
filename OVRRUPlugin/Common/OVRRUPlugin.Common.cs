using System;
using System.Collections.Generic;
using System.Collections;
using System.Windows.Forms;

namespace OVRRUPlugin.Common
{
    public class GVAR
    {
        public const int RESULT_TYPE_WIN = 1;
        public const int RESULT_TYPE_LOSE = 2;
        public const int RESULT_TYPE_TIE = 3;

        public const int RANK_TYPE_1ST = 1;
        public const int RANK_TYPE_2ND = 2;
        public const int RANK_TYPE_TIE = 0;

        public const int STATUS_SCHEDULE = 30;
        public const int STATUS_STARTLIST = 40;
        public const int STATUS_RUNNING = 50;
        public const int STATUS_SUSPEND = 60;
        public const int STATUS_UNOFFICIAL = 100;
        public const int STATUS_OFFICIAL = 110;
        public const int STATUS_REVISION = 120;
        public const int STATUS_CANCELED = 130;

        public const int GRID_ROWHEIGHT = 30;
        public const int GRID_HEADHEIGHT = 25;

        public const int Score_Try = 5;
        public const int Score_PenaltyGoal = 3;
        public const int Score_ConversionGoal = 2;
        public const int Score_DropGoal = 3;

        public const String g_strDisplnCode = "RU";
        public const String g_strDisplnName = "Rugby";
        public const String g_strLang = "ENG";

        public static OVRRUPlugin g_RUPlugin;
        public static OVRRUDataBase g_adoDataBase;
        public static OVRRUManageDB g_ManageDB;
        public static int g_matchID;

        public static int g_sessionNumber;
        public static int g_matchDay;

        public static int g_firstHalfTime=7;
        public static int g_secondHalfTime=7;
        public static int g_extraTime=5;
        public static int g_period=1;
        public static bool g_hasExtraTime=false;

        public static bool g_matchCanDraw;
        
        public const String m_strSectionName = "OVRRUPlugin";

        public static int Str2Int(Object strObj)
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

        public static double Str2Double(Object strObj)
        {
            if (strObj == null) return 0.0;
            try
            {
                return Convert.ToDouble(strObj);
            }
            catch 
            {
            }
            return 0.0;
        }

        public static double GetTotalIn5Data(double[] score)
        {
            double rtnResult = 0.0;
            try
            {

                for (int i = 0; i < score.Length; i++)
                {
                    for (int j = i + 1; j < score.Length; j++)
                    {
                        if (score[j] < score[i])
                        {
                            double temp = score[j];
                            score[j] = score[i];
                            score[i] = temp;
                        }
                    }
                }

                for (int i = 1; i < score.Length - 1; i++)
                {
                    rtnResult += score[i];
                }

            }
            catch
            {

            }

            return rtnResult;
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
    }

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

    public enum MyPopUpWindowType
    {
        OnCourt,
        OnBench
    }
    /// <summary>
    /// 转化帮助器

    /// </summary>
    public static class ConvertHelper
    {
        #region ToString
        /// <summary>
        /// 转化为字符串(为空值时返回空值)
        /// </summary>
        /// <param name="value">对象值</param>
        /// <returns>字符串</returns>
        public static string ToString(object value)
        {
            string result = null;

            if (value != null && !Convert.IsDBNull(value))
                result = value.ToString();

            return result;
        }

        /// <summary>
        /// 转化为字符串
        /// </summary>
        /// <param name="value">对象值</param>
        /// <param name="defaultValue">默认值</param>
        /// <returns>字符串</returns>
        public static string ToString(object value, string defaultValue)
        {
            string result = ToString(value);

            if (result == null)
                result = defaultValue;

            return result;
        }

        /// <summary>
        /// 转化为字符串(为空值时抛出异常)
        /// </summary>
        /// <param name="value">对象值</param>
        /// <returns>字符串</returns>
        public static string ToStringNullThrowError(object value)
        {
            string result = ToString(value);

            if (result == null)
                throw new ArgumentNullException("value", "不能为空值");

            return result;
        }

        /// <summary>
        /// 转化为字符串(为空值时返回空串)
        /// </summary>
        /// <param name="value">对象值</param>
        /// <returns>字符串</returns>
        public static string ToStringNullReturnEmpty(object value)
        {
            string result = ToString(value);

            if (result == null) result = string.Empty;
            return result;
        }
        #endregion ToString

        #region ToInt
        /// <summary>
        /// 转化为数值

        /// </summary>
        /// <param name="value">对象值</param>
        /// <param name="throwConvertError">转化出错时是否抛出异常</param>
        /// <returns>数值</returns>
        public static int? ToInt(object value, bool throwConvertError)
        {
            int? result = null;
            int temp;
            if (value != null && !Convert.IsDBNull(value))
                if (!int.TryParse(value.ToString(), out temp))
                {
                    if (throwConvertError)
                        throw new Exception("无法把对象[" + value.ToString() + "]转化为数值");
                }
                else
                    result = temp;

            return result;
        }

        /// <summary>
        /// 转化为数值(转化失败时返回默认值)
        /// </summary>
        /// <param name="value">对象值</param>
        /// <param name="defaultValue">默认值</param>
        /// <returns>数值</returns>
        public static int ToInt(object value, int defaultValue)
        {
            int result;
            int? temp = ToInt(value, false);
            result = temp.HasValue ? temp.Value : defaultValue;

            return result; 
        }

        /// <summary>
        /// 转化为数值(为空值时抛出异常)
        /// </summary>
        /// <param name="value">对象值</param>
        /// <returns>数值</returns>
        public static int ToIntNullThrowError(object value)
        {
            int? result = ToInt(value, false);

            if (!result.HasValue)
                throw new ArgumentNullException("value", "不能为空值,或无法转化为数值");

            return result.Value;
        }

        #endregion ToInt

        #region ToBoolean
        /// <summary>
        /// 转化为布尔值

        /// </summary>
        /// <param name="value">对象值</param>
        /// <param name="throwConvertError">转化出错时是否抛出异常</param>
        /// <returns>布尔值</returns>
        public static bool? ToBoolean(object value, bool throwConvertError)
        {
            bool? result = null;
            bool temp;
            if (value != null && !Convert.IsDBNull(value))
                if (!bool.TryParse(value.ToString(), out temp))
                {
                    if (throwConvertError)
                        throw new Exception("无法把对象[" + value.ToString() + "]转化为布尔值");
                }
                else
                    result = temp;

            return result;
        }

        /// <summary>
        /// 转化为布尔值(转化失败时返回默认值)
        /// </summary>
        /// <param name="value">对象值</param>
        /// <param name="defaultValue">默认值</param>
        /// <returns>布尔值</returns>
        public static bool ToBooleanReturnDefault(object value, bool defaultValue)
        {
            bool result;
            bool? temp = ToBoolean(value, false);
            result = temp.HasValue ? temp.Value : defaultValue;

            return result;
        }
        #endregion ToBoolean

        #region 转化类型
        /// <summary>
        /// 转化类型
        /// </summary>
        /// <typeparam name="Toutput">要输出的类型</typeparam>
        /// <param name="value">值</param>
        /// <param name="defaultValue">默认值</param>
        /// <returns>转化结果值</returns>
        public static Toutput ChangeTypeReturnDefault<Toutput>(object value, Toutput defaultValue)
        {
            Toutput result = defaultValue;
            try
            {
                if (value != null && !Convert.IsDBNull(value))
                    result = (Toutput)Convert.ChangeType(value, typeof(Toutput));
            }
            catch { }

            return result;
        }

        /// <summary>
        /// 转化类型
        /// </summary>
        /// <typeparam name="Toutput">要输出的类型</typeparam>
        /// <param name="value">值</param>
        /// <returns>转化结果值</returns>
        public static Toutput ChangeType<Toutput>(object value)
        {
            Toutput result;
            if (value != null && !Convert.IsDBNull(value))
            {
                try
                {
                    result = (Toutput)Convert.ChangeType(value, typeof(Toutput));
                }
                catch
                {
                    try
                    {
                        result = (Toutput)value;
                    }
                    catch
                    {
                        result = default(Toutput);
                    }
                }
            }
            else
                result = default(Toutput);

            return result;
        }

        /// <summary>
        /// 转化类型
        /// </summary>
        /// <typeparam name="Toutput">要输出的类型</typeparam>
        /// <param name="value">值</param>
        /// <param name="output">转化结果值</param>
        /// <returns>是否成功</returns>
        public static bool ChangeType<Toutput>(object value, out Toutput output)
        {
            bool result = false;

            output = default(Toutput);

            if (value != null && !Convert.IsDBNull(value))
            {
                try
                {
                    output = (Toutput)Convert.ChangeType(value, typeof(Toutput));
                    result = true;
                }
                catch { }
            }

            return result;
        }

        /// <summary>
        /// 转化类型
        /// </summary>
        /// <typeparam name="Tsource">源类型</typeparam>
        /// <typeparam name="Ttarget">目标类型</typeparam>
        /// <param name="source">源</param>
        /// <param name="throwConvertError">转化出错时是否抛出异常</param>
        /// <returns>目标类型的范型列表</returns>
        public static List<Ttarget> ChangeType<Tsource, Ttarget>(List<Tsource> source, bool throwConvertError)
        {
            List<Ttarget> result = new List<Ttarget>();

            if (source != null)
            {
                Ttarget targetOne;
                int i = 0;
                foreach (Tsource sourceOne in source)
                {
                    if (ChangeType<Ttarget>(sourceOne, out targetOne))
                        result.Add(targetOne);
                    else
                    {
                        if (throwConvertError)
                            throw new Exception(string.Format("第{0}个元素无法把对象转化为{1}", i, typeof(Ttarget).FullName));
                    }
                    i++;
                }
            }

            return result;

        }

        /// <summary>
        /// 转化类型
        /// </summary>
        /// <typeparam name="Tsource">源类型</typeparam>
        /// <typeparam name="Ttarget">目标类型</typeparam>
        /// <param name="source">源</param>
        /// <returns>目标类型的范型列表</returns>
        public static List<Ttarget> ChangeType<Tsource, Ttarget>(List<Tsource> source)
        {
            return ChangeType<Tsource, Ttarget>(source, false);
        }
        #endregion 转化类型

        #region 转化列表
        /// <summary>
        /// 转化列表
        /// </summary>
        /// <param name="keys">要存入列表的字符串</param>
        /// <returns>列表</returns>
        public static List<string> ConvertList(params string[] keys)
        {
            List<string> result = new List<string>();
            if (keys != null)
            {
                foreach (string key in keys)
                {
                    if (key != null)
                        result.Add(key);
                }
            }
            return result;
        }

        /// <summary>
        /// 转化列表
        /// </summary>
        /// <param name="upper">是否转化大写</param>
        /// <param name="keys">要存入列表的字符串</param>
        /// <returns>列表</returns>
        public static List<string> ConvertList(bool upper, params string[] keys)
        {
            List<string> result = new List<string>();
            if (keys != null)
            {
                foreach (string key in keys)
                {
                    if (key != null)
                        result.Add(upper ? key.ToUpper() : key.ToLower());
                }
            }
            return result;
        }
        #endregion 转化列表
    }

    public enum MatchStatus : int
    {
        Available = 10,
        Configured = 20,
        Scheduled = 30,
        StartList = 40,
        Running = 50,
        Suspend = 60,
        Unofficial = 100,
        Official = 110,
        Revision = 120,
        Canceled = 130,
    }
}
