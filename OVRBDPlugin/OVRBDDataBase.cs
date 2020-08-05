using System;
using System.Data.SqlClient;
using System.Collections;
using System.Windows.Forms;
using System.Data;
using AutoSports.OVRCommon;

namespace AutoSports.OVRBDPlugin
{
    public class OVRBDDataBase
    {
        public SqlConnection m_dbConnect;
        public String m_strConnection;

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

        public String strConnection
        {
            get
            {
                return m_strConnection;
            }
            set
            {
                m_strConnection = value;
            }
        }

        public bool ExecuteUpdateSql(String strUpdateSql)
        {
            SqlCommand dbCmd = m_dbConnect.CreateCommand();
            dbCmd.CommandText = strUpdateSql;

            Int32 nResult = -1;
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

        public bool ExecuteSql(String strSql, out STableRecordSet RecordSets)
        {
            RecordSets = new STableRecordSet();
            RecordSets.m_straFieldNames = new ArrayList();

            SqlCommand dbCmd = m_dbConnect.CreateCommand();

            dbCmd.CommandText = strSql;

            SqlDataReader dbReader = dbCmd.ExecuteReader();

            //////////////////////////////////////////////////////////////////////////
            // Init data to SqlDataReader
            // Get Field names
            Int32 nFieldCount = dbReader.FieldCount;
            for (Int32 i = 0; i < nFieldCount; i++)
            {
                RecordSets.m_straFieldNames.Add(dbReader.GetName(i));
            }

            RecordSets.m_str2aRecords = new ArrayList();
            // Get Records
            while (dbReader.Read())
            {
                ArrayList aryRecord = new ArrayList(nFieldCount);

                for (Int32 i = 0; i < nFieldCount; i++)
                {
                    String strFieldValue = dbReader[i].ToString();
                    aryRecord.Add(strFieldValue);
                }

                RecordSets.m_str2aRecords.Add(aryRecord);
            }
            dbReader.Close();

            return true;
        }

        public object ExecuteScalar(String strSql)
        {
            SqlCommand dbCmd = m_dbConnect.CreateCommand();

            dbCmd.CommandText = strSql;

            return dbCmd.ExecuteScalar();
        }

        public Int32 ExecuteProcNoQuery(String strProcName, ref SqlParameter[] aryProcParams)
        {
            SqlCommand dbCmd = m_dbConnect.CreateCommand();
            dbCmd.CommandText = strProcName;
            dbCmd.CommandType = CommandType.StoredProcedure;

            dbCmd.Parameters.AddRange(aryProcParams); // Past the params           

            return dbCmd.ExecuteNonQuery();
        }

        public bool ExecuteProc(String strProcName, ref SqlParameter[] aryProcParams, out STableRecordSet RecordSets)
        {
            SqlCommand dbCmd = m_dbConnect.CreateCommand();
            dbCmd.CommandText = strProcName;
            dbCmd.CommandType = CommandType.StoredProcedure;

            if (aryProcParams != null)
            {
                dbCmd.Parameters.AddRange(aryProcParams); // Past the params
            }

            RecordSets = new STableRecordSet();
            SqlDataReader dbReader = dbCmd.ExecuteReader();
            if (dbReader == null) return false;

            //////////////////////////////////////////////////////////////////////////
            // Init data to SqlDataReader
            // Get Field names            

            RecordSets.m_straFieldNames = new ArrayList();
            Int32 nFieldCount = dbReader.FieldCount;
            for (Int32 i = 0; i < nFieldCount; i++)
            {
                RecordSets.m_straFieldNames.Add(dbReader.GetName(i));
            }

            RecordSets.m_str2aRecords = new ArrayList();
            // Get Records
            while (dbReader.Read())
            {
                ArrayList aryRecord = new ArrayList(nFieldCount);

                for (Int32 i = 0; i < nFieldCount; i++)
                {
                    aryRecord.Add(dbReader[i].ToString());
                }

                RecordSets.m_str2aRecords.Add(aryRecord);
            }
            dbReader.Close();

            return true;
        }

    }
}
