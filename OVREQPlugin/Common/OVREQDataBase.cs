using System;
using System.Data.SqlClient;
using System.Collections;
using System.Windows.Forms;
using System.Data;

namespace AutoSports.OVREQPlugin
{
    //数据库操作类
    public class OVREQDataBase
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

        private void OpenDataBase()
        {
            if (m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                m_dbConnect.Open();
            }
        }

        public bool ExecuteSQL(String strSQL, STableRecordSet RecordSets)
        {
            OpenDataBase();

            if (RecordSets == null) return false;

            RecordSets.m_straFieldNames = new ArrayList();

            SqlCommand dbCmd = m_dbConnect.CreateCommand();

            dbCmd.CommandText = strSQL;

            SqlDataReader dbReader = dbCmd.ExecuteReader();

            //////////////////////////////////////////////////////////////////////////
            // Init data to SqlDataReader
            // Get Field names
            int nFieldCount = dbReader.FieldCount;
            for (int i = 0; i < nFieldCount; i++)
            {
                RecordSets.m_straFieldNames.Add(dbReader.GetName(i));
            }

            RecordSets.m_str2aRecords = new ArrayList();
            // Get Records
            while (dbReader.Read())
            {
                ArrayList aryRecord = new ArrayList(nFieldCount);

                for (int i = 0; i < nFieldCount; i++)
                {
                    String strFieldValue = dbReader[i].ToString();
                    aryRecord.Add(strFieldValue);
                }

                RecordSets.m_str2aRecords.Add(aryRecord);
            }
            dbReader.Close();

            return true;
        }

        public bool ExecuteUpdateSQL(String strUpdateSQL)
        {
            OpenDataBase();

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
            OpenDataBase();

            SqlCommand dbCmd = m_dbConnect.CreateCommand();

            dbCmd.CommandText = strSQL;

            return dbCmd.ExecuteScalar();
        }

        public int ExecuteProcNoQuery(String strProcName, params SqlParameter[] aryProcParams)
        {
            OpenDataBase();

            SqlCommand dbCmd = m_dbConnect.CreateCommand();
            dbCmd.CommandText = strProcName;
            dbCmd.CommandType = CommandType.StoredProcedure;

            dbCmd.Parameters.AddRange(aryProcParams); // Past the params           

            return dbCmd.ExecuteNonQuery();
        }

        public bool ExecuteProc(String strProcName, STableRecordSet RecordSets, params SqlParameter[] aryProcParams)
        {
            OpenDataBase();

            SqlCommand dbCmd = m_dbConnect.CreateCommand();
            dbCmd.CommandText = strProcName;
            dbCmd.CommandType = CommandType.StoredProcedure;

            if (aryProcParams != null)
            {
                dbCmd.Parameters.AddRange(aryProcParams); // Past the params
            }

            SqlDataReader dbReader = dbCmd.ExecuteReader();
            if (dbReader == null) return false;

            //////////////////////////////////////////////////////////////////////////
            // Init data to SqlDataReader
            // Get Field names            

            RecordSets.m_straFieldNames = new ArrayList();
            int nFieldCount = dbReader.FieldCount;
            for (int i = 0; i < nFieldCount; i++)
            {
                RecordSets.m_straFieldNames.Add(dbReader.GetName(i));
            }

            RecordSets.m_str2aRecords = new ArrayList();
            // Get Records
            while (dbReader.Read())
            {
                ArrayList aryRecord = new ArrayList(nFieldCount);

                for (int i = 0; i < nFieldCount; i++)
                {
                    aryRecord.Add(dbReader[i].ToString());
                }

                RecordSets.m_str2aRecords.Add(aryRecord);
            }
            dbReader.Close();

            return true;
        }

        public bool ExecuteProc(String strProcName, ref System.Data.DataTable table, params SqlParameter[] aryProcParams)
        {
            OpenDataBase();
            SqlCommand dbCmd = m_dbConnect.CreateCommand();
            dbCmd.CommandText = strProcName;
            dbCmd.CommandType = CommandType.StoredProcedure;

            if (aryProcParams != null)
            {
                dbCmd.Parameters.AddRange(aryProcParams); // Past the params
            }

            SqlDataReader dbReader = dbCmd.ExecuteReader();
            if (dbReader == null) return false;

            table.Load(dbReader);

            dbReader.Close();

            return true;
        }

        public void FillComb(String strProcName, string displayMember, string valueMember, System.Windows.Forms.ComboBox cmb, params SqlParameter[] aryProcParams)
        {
            System.Data.DataTable table = new System.Data.DataTable();

            if (ExecuteProc(strProcName, ref table, aryProcParams) == true)
            {
                cmb.DisplayMember = displayMember;
                cmb.ValueMember = valueMember;
                cmb.DataSource = table;
            }
        }
    }
}


