using System;
using System.IO;
using System.Data;
using System.Text;
using System.Drawing;
using System.Collections;
using System.Windows.Forms;
using AutoSports.OVRCommon;
using System.Configuration;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace AutoSports.OVRWLPlugin
{
    public class GVWL
    {
        public const String g_strDisplnCode = "WL";
        public const String g_strDisplnName = "举重";
        public static String g_strLang = "CHN";
        public static Int32 g_DisciplineID = 1;
        public static Int32 g_SportID = 0;

        public static OVRWLPlugin g_WLPlugin;
        public static OVRWLDataBase g_adoDataBase;
        public static OVRWLManageDB g_ManageDB;
    }

    public class StringFunctions
    {
        public bool IsNumber(String strNumber)
        {
            Regex objNotNumberPattern = new Regex("[^0-9.-]");
            Regex objTwoDotPattern = new Regex("[0-9]*[.][0-9]*[.][0-9]*");
            String strValidRealPattern = "^([-]|[.]|[-.]|[0-9])[0-9]*[.]*[0-9]+$";
            String strValidIntegerPattern = "^([-]|[0-9])[0-9]*$";
            Regex objNumberPattern = new Regex("(" + strValidRealPattern + ")|(" + strValidIntegerPattern + ")");

            return !objNotNumberPattern.IsMatch(strNumber) &&
            !objTwoDotPattern.IsMatch(strNumber) &&
            objNumberPattern.IsMatch(strNumber);
        }

        public static bool IsNumeric(string value)
        {
            string strRegex = @"^\d*[.]?\d*$";
            Regex numericRegex = new Regex(strRegex);
            return numericRegex.IsMatch(value);
        }
        public static bool IsInt(string value)
        {
            return Regex.IsMatch(value, @"^\d*$");
        }
        // Common tools
        public static int Str2Int(Object strObj)
        {
            if (strObj == null) return 0;
            try
            {
                return Convert.ToInt32(strObj);
            }
            catch (System.Exception errorFmt)
            {
            }
            return 0;
        }

        public static String Obj2Str(Object Value)
        {
            if (Value == null)
                return "";
            try
            {
                return Value.ToString();
            }
            catch (System.Exception errorFmt)
            {
            }

            return "";
        }

    }

    public class DTHelpFunctions
    {
        public static string GetStringByFieldAndRowIndex(DataTable dt, int nRow, string strFieldName)
        {
            string strFieldValue = string.Empty;
            if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                strFieldValue = dt.Rows[nRow][strFieldName].ToString();
            return strFieldValue;
        }

        public static float GetFlotByFieldAndRowIndex(DataTable dt, int nRow, string strFieldName)
        {
            float fFieldValue = 0;
            string strFieldValue = string.Empty;
            if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                strFieldValue = dt.Rows[nRow][strFieldName].ToString();
            if (strFieldValue.Length > 0)
                fFieldValue = float.Parse(strFieldValue);
            return fFieldValue;
        }

        public static string GetStringByFieldAndFieldValue(DataTable dt, string FieldName, string FieldValue, string strFieldName)
        {
            string strFieldValue = string.Empty;
            foreach (DataRow dr in dt.Rows)
            {
                if (dr[strFieldName] != DBNull.Value && dr[FieldName] != DBNull.Value)
                {
                    if (dr[FieldName].ToString() == FieldValue)
                        strFieldValue = dr[strFieldName].ToString();
                }
            }
            return strFieldValue;
        }
        public static string GetStringByFieldAndLotNo(DataTable dt, string LotNo, string strFieldName)
        {
            return GetStringByFieldAndFieldValue(dt, "LotNo", LotNo, strFieldName);
        }

        public static DataRow GetDataRowByFieldAndFieldValue(DataTable dt, string FieldName, string FieldValue)
        {
            DataRow dtRow = null;
            foreach (DataRow dr in dt.Rows)
            {
                if (dr[FieldName] != DBNull.Value)
                {
                    if (dr[FieldName].ToString() == FieldValue)
                        dtRow = dr;
                }
            }
            return dtRow;
        }
        public static DataRow GetDataRowByFieldAndLotNo(DataTable dt, string LotNo)
        {
            return GetDataRowByFieldAndFieldValue(dt, "LotNo", LotNo);
        }

        public static string GetStringByDataRowAndFieldName(DataRow dr, string strFieldName)
        {
            string strFieldValue = string.Empty;

            if (dr[strFieldName] != DBNull.Value)
                strFieldValue = dr[strFieldName].ToString();


            return strFieldValue;
        }
    }

}
