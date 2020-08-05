using System;
using System.Data.SqlClient;
using System.Collections;
using System.Windows.Forms;
using System.Data;

namespace AutoSports.OVRWLPlugin
{
    public class OVRWLDataBase
    {
        private SqlConnection m_dbConnect;
        public SqlConnection DBConnect
        {
            get
            {
                return m_dbConnect;
            }
            set
            {
                m_dbConnect = value;
            }
        }

        public bool ExecuteUpdateSQL(String strUpdateSQL)
        {
            SqlCommand dbCmd = m_dbConnect.CreateCommand();
            dbCmd.CommandText = strUpdateSQL;

            int nResult = -1;
            try
            {
                nResult = dbCmd.ExecuteNonQuery();
            }
            catch (System.Exception e)
            {
                MessageBox.Show(e.Message.ToString());
            }

            return nResult > 0 ? true : false;
        }

        public object ExecuteScalar(String strSQL)
        {
            SqlCommand dbCmd = m_dbConnect.CreateCommand();

            dbCmd.CommandText = strSQL;

            return dbCmd.ExecuteScalar();
        }

        public int ExecuteProcNoQuery(String strProcName, params SqlParameter[] aryProcParams)
        {
            SqlCommand dbCmd = m_dbConnect.CreateCommand();
            dbCmd.CommandText = strProcName;
            dbCmd.CommandType = CommandType.StoredProcedure;

            dbCmd.Parameters.AddRange(aryProcParams); // Past the params           

            return dbCmd.ExecuteNonQuery();
        }
    }
}


