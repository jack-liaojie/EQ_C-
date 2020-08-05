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


namespace AutoSports.OVRARPlugin
{
    public class GVAR
    {
        public const String g_strDisplnCode = "AR";
        public const String g_strDisplnName = "射箭";
        public const String g_strLang = "CHN";
        public const String g_strSectionName = "OVRARPlugin";

        public static OVRARPlugin g_ARPlugin;
        public static OVRARDataBase g_adoDataBase;
        public static OVRARManageDB g_ManageDB;
    }

    public class ARFunctions
    {
        public static int ConvertToIntFromObject(object obj)
        {
            int returnValue = 0;

            if (obj != null)
            {
                string tempStr = obj.ToString();
                if (tempStr.Length != 0)
                    int.TryParse(tempStr, out returnValue);
            }
            return returnValue;
        }

        public static string ConvertToStringFromObject(object obj)
        {
            string returnValue = string.Empty; ;

            if (obj != null)
            {
                returnValue = obj.ToString();
            }
            return returnValue;
        }
        public static int ConvertToIntFromString(string obj)
        {
            int returnValue = 0;

            if (obj != null)
            {
                string tempStr = obj.ToString();
                if (tempStr.Length != 0)
                    int.TryParse(tempStr, out returnValue);
            }
            return returnValue;
        }
        public static int CompareTotalString(string tatalA, string totalB)
        {
            int compareResult = 0;

            int nTotalA = ARFunctions.ConvertToIntFromString(tatalA);
            int nTotalB = ARFunctions.ConvertToIntFromString(totalB);

            if (nTotalA > nTotalB) compareResult = 1;
            else if (nTotalA < nTotalB) compareResult = -1;
            else if (nTotalA == nTotalB) compareResult = 0;

            return compareResult;

        }

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

}
