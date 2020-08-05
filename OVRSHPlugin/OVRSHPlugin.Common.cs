using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace AutoSports.OVRSHPlugin
{
    public class SHCommon
    {
        public const String g_strDisplnCode = "SH";
        public const String g_strDisplnName = "Shooting";
        public const String g_strSectionName = "OVRSHPlugin";

        public static SqlConnection g_DataBaseCon;
        public static OVRSHPlugin g_SHPlugin;

        public static Int32 Str2Int(Object strObj)
        {
            if (strObj == null) return 0;

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

        public static Double Str2Double(Object strObj)
        {
            if (strObj == null) return 0.0;

            try
            {
                return Convert.ToDouble(strObj);
            }
            catch (System.Exception errorFmt)
            {
                MessageBox.Show(errorFmt.ToString());
            }
            return 0.0;
        }
    }
}
