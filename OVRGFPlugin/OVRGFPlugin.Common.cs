using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace AutoSports.OVRGFPlugin
{
    public class GFCommon
    {
        public const String g_strDisplnCode = "GF";
        public const String g_strDisplnName = "Golf";
        public const String g_strSectionName = "OVRGFPlugin";

        public static SqlConnection g_DataBaseCon;
        public static OVRGFPlugin   g_GFPlugin;
        public static String        g_strConnectionString;
        public static OVRGFManageDB g_ManageDB = new OVRGFManageDB();

        public const Int32 STATUS_NOUSED = 0;
        public const Int32 STATUS_AVAILABLE = 10;
        public const Int32 STATUS_CONFIGURED = 20;
        public const Int32 STATUS_SCHEDULE = 30;
        public const Int32 STATUS_STARTLIST = 40;
        public const Int32 STATUS_RUNNING = 50;
        public const Int32 STATUS_SUSPEND = 60;
        public const Int32 STATUS_UNOFFICIAL = 100;
        public const Int32 STATUS_OFFICIAL = 110;
        public const Int32 STATUS_REVISION = 120;
        public const Int32 STATUS_CANCELED = 130;

        public const String PLAYER_STATUS_DQ = "DQ";
        public const String PLAYER_STATUS_RTD = "RTD";
        public const String PLAYER_STATUS_WD = "WD";
        public const String PLAYER_STATUS_OK = "OK";

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

        public static Int32 ConvertStrToInt(String strValue)
        {
            Int32 iReturnValue = 0;
            if (strValue == "")
            {
                iReturnValue = 0;
            }
            else
            {
                iReturnValue = Convert.ToInt32(strValue);
            }
            return iReturnValue;
        }

        public static String ConvertIntToStr(Int32 nValue)
        {
            String strReturnVaule = "";

            if (nValue != 0)
            {
                strReturnVaule = Convert.ToString(nValue);
            }

            return strReturnVaule;
        }

        public static String GetFieldValue(DataGridView dgv, Int32 iRowIndex, String strFiledName)
        {
            String strReturnValue = "";
            if (dgv.Rows[iRowIndex].Cells[strFiledName] == null || dgv.Columns[strFiledName] == null)
            {
                strReturnValue = "";
            }
            else
            {
                strReturnValue = Convert.ToString(dgv.Rows[iRowIndex].Cells[strFiledName].Value);
            }

            return strReturnValue;
        }

        public static String GetFieldValue(DataGridView dgv, Int32 iRowIndex, Int32 iColIndex)
        {
            String strReturnValue = "";
            String strFiledName = dgv.Columns[iColIndex].Name;

            if (dgv.Rows[iRowIndex].Cells[strFiledName] == null || dgv.Columns[strFiledName] == null)
            {
                strReturnValue = "";
            }
            else
            {
                strReturnValue = Convert.ToString(dgv.Rows[iRowIndex].Cells[strFiledName].Value);
            }

            return strReturnValue;
        }
    }
}
