using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRGeneralData
{
    public partial class OVREventRecordsForm : UIForm
    {
        private bool m_bUpdatingUI;
        private int m_nEventID;
        private int m_nCurRecordID;
        private SqlConnection m_dbConnection;

        public OVREventRecordsForm(int nEventID, SqlConnection dbConnection)
        {
            m_nEventID = nEventID;
            m_dbConnection = dbConnection;

            InitializeComponent();
            OVRDataBaseUtils.SetDataGridViewStyle(dgvEventRecords);
            OVRDataBaseUtils.SetDataGridViewStyle(dgvRecordValue);
            OVRDataBaseUtils.SetDataGridViewStyle(dgvRecordMember);

            Localization();
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, this.Name);

            btnRecordNew.Tooltip = LocalizationRecourceManager.GetString(this.Name, btnRecordNew.Name);
            btnRecordDel.Tooltip = LocalizationRecourceManager.GetString(this.Name, btnRecordDel.Name);
            btnRecordValueDel.Tooltip = LocalizationRecourceManager.GetString(this.Name, btnRecordValueDel.Name);
            btnRecordValueNew.Tooltip = LocalizationRecourceManager.GetString(this.Name, btnRecordValueNew.Name);

            lbEventRecords.Text = LocalizationRecourceManager.GetString(this.Name, lbEventRecords.Name);
            lbRecordMember.Text = LocalizationRecourceManager.GetString(this.Name, lbRecordMember.Name);
            lbRecordValue.Text = LocalizationRecourceManager.GetString(this.Name, lbRecordValue.Name);
        }

        private void frmEventRecords_Load(object sender, EventArgs e)
        {
            ShowEventRecordToGrid();
        }

        private void ShowEventRecordToGrid()
        {
            m_bUpdatingUI = true;
            int iFirstDisplayedScrollingRowIndex = dgvEventRecords.FirstDisplayedScrollingRowIndex;
            int iFirstDisplayedScrollingColumnIndex = dgvEventRecords.FirstDisplayedScrollingColumnIndex;
            if (iFirstDisplayedScrollingRowIndex < 0) iFirstDisplayedScrollingRowIndex = 0;
            if (iFirstDisplayedScrollingColumnIndex < 0) iFirstDisplayedScrollingColumnIndex = 0;

            SqlDataReader dbReader = GetEventRecords(m_nEventID, m_dbConnection);
            if (dbReader == null)
                return;

            List<OVRCheckBoxColumn> lstChkColumns = new List<OVRCheckBoxColumn>();
            for (int j = 0; j < dbReader.FieldCount; j++)
            {
                if ("F_Active" == dbReader.GetName(j) || "F_Equalled" == dbReader.GetName(j) || "F_IsNewCreated" == dbReader.GetName(j))
                {
                    lstChkColumns.Add(new OVRCheckBoxColumn(j, 1, 0));
                }
            }

            List<int> lstCmbColumns = new List<int>();
            for (int j = 0; j < dbReader.FieldCount; j++)
            {
                if ("F_RecordType" == dbReader.GetName(j))
                {
                    lstCmbColumns.Add(j);
                }
            }

            OVRDataBaseUtils.FillDataGridView(dgvEventRecords, dbReader, lstCmbColumns, lstChkColumns);
            //OVRDataBaseUtils.FillDataGridViewWithCmb(dgvEventRecords, dbReader, "F_Equalled");

            dbReader.Close();

            // Edit Enable
            foreach (DataGridViewColumn Col in dgvEventRecords.Columns)
            {
                if (Col.Name == "F_EventID" || Col.Name == "F_RecordID")
                {
                    Col.Visible = false;
                }
                else
                    Col.ReadOnly = false;
            }

            // Edit Enable
            foreach (DataGridViewColumn Col in dgvEventRecords.Columns)
            {
                if (Col.Name == "F_Active" || Col.Name == "F_RecordType" || Col.Name == "F_Equalled" || Col.Name == "F_IsNewCreated"
                    || Col.Name == "F_RecordDate" || Col.Name == "F_Order" || Col.Name == "F_Location" || Col.Name == "F_RecordSport"
                    || Col.Name == "F_RecordComment" || Col.Name == "F_RecordValue")
                {
                    Col.ReadOnly = false;
                }
            }


            if (iFirstDisplayedScrollingRowIndex < dgvEventRecords.Rows.Count)
                dgvEventRecords.FirstDisplayedScrollingRowIndex = iFirstDisplayedScrollingRowIndex;
            if (dgvEventRecords.FirstDisplayedScrollingColumnIndex < iFirstDisplayedScrollingColumnIndex &&
                iFirstDisplayedScrollingColumnIndex < dgvEventRecords.Columns.Count)
                dgvEventRecords.FirstDisplayedScrollingColumnIndex = iFirstDisplayedScrollingColumnIndex;

            m_bUpdatingUI = false;
        }

        private void ShowRecordValuesToGrid(int nRecordID)
        {
            m_bUpdatingUI = true;
            int iFirstDisplayedScrollingRowIndex = dgvRecordValue.FirstDisplayedScrollingRowIndex;
            int iFirstDisplayedScrollingColumnIndex = dgvRecordValue.FirstDisplayedScrollingColumnIndex;
            if (iFirstDisplayedScrollingRowIndex < 0) iFirstDisplayedScrollingRowIndex = 0;
            if (iFirstDisplayedScrollingColumnIndex < 0) iFirstDisplayedScrollingColumnIndex = 0;

            SqlDataReader dbReader = GetRecordValues(nRecordID, m_dbConnection);
            if (dbReader == null)
                return;

            OVRDataBaseUtils.FillDataGridView(dgvRecordValue, dbReader, null, null);
            dbReader.Close();

            // Edit Enable
            foreach (DataGridViewColumn Col in dgvRecordValue.Columns)
            {
                if (Col.Name != "F_RecordID" && Col.Name != "F_ValueNum")
                {
                    Col.ReadOnly = false;
                }
            }

            if (iFirstDisplayedScrollingRowIndex < dgvRecordValue.Rows.Count)
                dgvRecordValue.FirstDisplayedScrollingRowIndex = iFirstDisplayedScrollingRowIndex;
            if (dgvRecordValue.FirstDisplayedScrollingColumnIndex < iFirstDisplayedScrollingColumnIndex &&
                iFirstDisplayedScrollingColumnIndex < dgvEventRecords.Columns.Count)
                dgvRecordValue.FirstDisplayedScrollingColumnIndex = iFirstDisplayedScrollingColumnIndex;

            m_bUpdatingUI = false;
        }

        private void ShowRecordMembersToGrid(int nRecordID)
        {
            m_bUpdatingUI = true;
            int iFirstDisplayedScrollingRowIndex = dgvRecordMember.FirstDisplayedScrollingRowIndex;
            int iFirstDisplayedScrollingColumnIndex = dgvRecordMember.FirstDisplayedScrollingColumnIndex;
            if (iFirstDisplayedScrollingRowIndex < 0) iFirstDisplayedScrollingRowIndex = 0;
            if (iFirstDisplayedScrollingColumnIndex < 0) iFirstDisplayedScrollingColumnIndex = 0;

            SqlDataReader dbReader = GetRecordMember(nRecordID, m_dbConnection);
            if (dbReader == null)
                return;

            OVRDataBaseUtils.FillDataGridView(dgvRecordMember, dbReader, null, null);
            dbReader.Close();

            if (iFirstDisplayedScrollingRowIndex < dgvRecordMember.Rows.Count)
                dgvRecordMember.FirstDisplayedScrollingRowIndex = iFirstDisplayedScrollingRowIndex;
            if (dgvEventRecords.FirstDisplayedScrollingColumnIndex < iFirstDisplayedScrollingColumnIndex &&
                iFirstDisplayedScrollingColumnIndex < dgvRecordMember.Columns.Count)
                dgvRecordMember.FirstDisplayedScrollingColumnIndex = iFirstDisplayedScrollingColumnIndex;

            m_bUpdatingUI = false;
        }

        private void btnRecordNew_Click(object sender, EventArgs e)
        {
            AddEventRecord(m_nEventID, m_dbConnection);

            ShowEventRecordToGrid();
        }

        private void btnRecordDel_Click(object sender, EventArgs e)
        {
            foreach (DataGridViewRow row in dgvEventRecords.SelectedRows)
            {
                String strReocrdID = Obj2Str(row.Cells["F_RecordID"].Value);
                int nRecordID = Str2Int(strReocrdID);

                DelEventRecord(m_nEventID, nRecordID, m_dbConnection);
            }

            ShowEventRecordToGrid();
            dgvRecordMember.RowCount = 0;
            dgvRecordValue.RowCount = 0;
        }

        private void btnRecordValueNew_Click(object sender, EventArgs e)
        {
            AddRecordValue(m_nCurRecordID, m_dbConnection);
            ShowRecordValuesToGrid(m_nCurRecordID);
        }

        private void btnRecordValueDel_Click(object sender, EventArgs e)
        {
            int nRecordID = -1;
            foreach (DataGridViewRow row in dgvRecordValue.SelectedRows)
            {
                String strValueNum = Obj2Str(row.Cells["F_ValueNum"].Value);
                String strReocrdID = Obj2Str(row.Cells["F_RecordID"].Value);
                nRecordID = Str2Int(strReocrdID);
                int nValueNum = Str2Int(strValueNum);

                DelRecordValues(nRecordID, nValueNum, m_dbConnection);
            }

            ShowRecordValuesToGrid(nRecordID);
        }

        private void dgvEventRecords_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            int nRow = e.RowIndex;
            int nCol = e.ColumnIndex;

            if (nRow < 0 && nCol < 0)
                return;

            if (dgvEventRecords.Columns[nCol].Name == "F_Active")
            {
                return;
            }

            DataGridViewRow row = dgvEventRecords.Rows[nRow];
            String strColName = dgvEventRecords.Columns[nCol].Name;
            
            String strColValue = Obj2Str(row.Cells[nCol].Value);
            String strEventID = Obj2Str(row.Cells["F_EventID"].Value);
            String strReocrdID = Obj2Str(row.Cells["F_RecordID"].Value);


            int nEventID = Str2Int(strEventID);
            int nRecordID = Str2Int(strReocrdID);

            if (strColName == "F_RecordType")
            {
                strColName = "F_RecordTypeID";

                DGVCustomComboBoxCell CurCell1 = dgvEventRecords.Rows[nRow].Cells[nCol] as DGVCustomComboBoxCell;
                strColValue = Convert.ToString(CurCell1.Tag);
            }
        
            ModifyEventRecord(nEventID, nRecordID, m_dbConnection, strColName, strColValue); 
           
        }

        private void dgvEventRecords_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            int nRow = e.RowIndex;
            int nCol = e.ColumnIndex;

            if (nRow < 0 && nCol < 0)
                return;

            if (dgvEventRecords.Columns[nCol].Name == "F_RecordType")
            {
                FillRecordType();
            }
            else if ( dgvEventRecords.Columns[nCol].Name == "F_RegisterCode" || dgvEventRecords.Columns[nCol].Name == "F_LongName"
                     || dgvEventRecords.Columns[nCol].Name == "F_NOC")
            {
                e.Cancel = true;
            }
        }


        private void dgvEventRecords_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            int nRow = e.RowIndex;
            int nCol = e.ColumnIndex;

            if (nRow < 0 && nCol < 0)
                return;

            if (dgvEventRecords.Columns[nCol].Name == "F_Active" || dgvEventRecords.Columns[nCol].Name == "F_Equalled" || dgvEventRecords.Columns[nCol].Name == "F_IsNewCreated")
            {
                bool bChecked = (bool)dgvEventRecords.Rows[e.RowIndex].Cells[e.ColumnIndex].EditedFormattedValue;
                String strColValue = bChecked ? "1" : "0";
                DataGridViewRow row = dgvEventRecords.Rows[nRow];
                String strColName = dgvEventRecords.Columns[nCol].Name;
                String strEventID = Obj2Str(row.Cells["F_EventID"].Value);
                String strReocrdID = Obj2Str(row.Cells["F_RecordID"].Value);


                int nEventID = Str2Int(strEventID);
                int nRecordID = Str2Int(strReocrdID);

                ModifyEventRecord(nEventID, nRecordID, m_dbConnection, strColName, strColValue);
            }
           
        }


        private void dgvRecordValue_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            int nRow = e.RowIndex;
            int nCol = e.ColumnIndex;

            if (nRow < 0 && nCol < 0)
                return;

            DataGridViewRow row = dgvRecordValue.Rows[nRow];
            String strColName = dgvRecordValue.Columns[nCol].Name;
            String strColVale = Obj2Str(row.Cells[nCol].Value);
            String strValueNum = Obj2Str(row.Cells["F_ValueNum"].Value);
            String strReocrdID = Obj2Str(row.Cells["F_RecordID"].Value);

            int nValueNum = Str2Int(strValueNum);
            int nRecordID = Str2Int(strReocrdID);

            ModifyRecordValues(nRecordID, nValueNum, m_dbConnection, strColName, strColVale);
        }

        // Database access
        public SqlDataReader GetEventRecords(int nEventID, SqlConnection dbConnection)
        {
            if (dbConnection.State == ConnectionState.Closed)
            {
                dbConnection.Open();
            }

            SqlCommand cmd = new SqlCommand("Proc_GetEventRecords", dbConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            SqlParameter cmdParameter1 = new SqlParameter(
                        "@EventID", SqlDbType.Int, 0,
                         ParameterDirection.Input, false, 0, 0, "@EventID",
                        DataRowVersion.Current, nEventID);

            SqlParameter cmdParameter2 = new SqlParameter(
                         "@LanguageCode", SqlDbType.Char, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, GetCurActivedLanguageCode(dbConnection));

            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);

            SqlDataReader dbReader = null;
            try
            {
                dbReader = cmd.ExecuteReader();
            }
            catch (SqlException ex)
            {
                MessageBoxEx.Show(ex.Message.ToString());
            }

            return dbReader;
        }

        public SqlDataReader GetRecordMember(int nRecordID, SqlConnection dbConnection)
        {
            if (dbConnection.State == ConnectionState.Closed)
            {
                dbConnection.Open();
            }

            SqlCommand cmd = new SqlCommand("Proc_GetRegisterMembers", dbConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            SqlParameter cmdParameter1 = new SqlParameter(
                        "@RecordID", SqlDbType.Int, 0,
                         ParameterDirection.Input, false, 0, 0, "@RecordID",
                        DataRowVersion.Current, nRecordID);

            SqlParameter cmdParameter2 = new SqlParameter(
                         "@LanguageCode", SqlDbType.Char, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, GetCurActivedLanguageCode(dbConnection));

            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);

            SqlDataReader dbReader = null;
            try
            {
                dbReader = cmd.ExecuteReader();
            }
            catch (SqlException ex)
            {
                MessageBoxEx.Show(ex.Message.ToString());
            }

            return dbReader;
        }

        public SqlDataReader GetRecordValues(int nRecordID, SqlConnection dbConnection)
        {
            if (dbConnection.State == ConnectionState.Closed)
            {
                dbConnection.Open();
            }

            String strFmt = @"SELECT F_ValueNum, F_ValueType, F_IntValue1 , F_IntValue2, F_CharValue1, F_CharValue2, F_RecordID
                            FROM TS_Record_Values WHERE F_RecordID = {0:D} ORDER BY F_ValueNum";

            String strSQL = String.Format(strFmt, nRecordID);

            SqlCommand dbCommand = new SqlCommand(strSQL, dbConnection);
            SqlDataReader dbReader = null;
            try
            {
                dbReader = dbCommand.ExecuteReader();
            }
            catch (SqlException ex)
            {
                MessageBoxEx.Show(ex.Message.ToString());
            }

            return dbReader;
        }

        public int AddEventRecord(int nEventID, SqlConnection dbConnection)
        {
            if (dbConnection.State == ConnectionState.Closed)
            {
                dbConnection.Open();
            }

            SqlCommand dbCommand = new SqlCommand("proc_AddEventRecord", dbConnection);
            dbCommand.CommandType = CommandType.StoredProcedure;
            dbCommand.Parameters.AddWithValue("@EventID", nEventID);
            dbCommand.Parameters.AddWithValue("@Result", DBNull.Value);
            dbCommand.Parameters["@Result"].Size = 4;
            dbCommand.Parameters["@Result"].SqlDbType = SqlDbType.Int;
            dbCommand.Parameters["@Result"].Direction = ParameterDirection.Output;

            int nRet = -1;
            try
            {
                dbCommand.ExecuteNonQuery();
                nRet = (int)dbCommand.Parameters["@Result"].Value;
            }
            catch (SqlException ex)
            {
                MessageBoxEx.Show(ex.Message.ToString());
            }

            return nRet;
        }

        public int AddRecordMember(int nRecordID, SqlConnection dbConnection)
        {
            if (dbConnection.State == ConnectionState.Closed)
            {
                dbConnection.Open();
            }

            SqlCommand dbCommand = new SqlCommand("proc_AddRecordMember", dbConnection);
            dbCommand.CommandType = CommandType.StoredProcedure;
            dbCommand.Parameters.AddWithValue("@RecordID", nRecordID);
            dbCommand.Parameters.AddWithValue("@Result", DBNull.Value);
            dbCommand.Parameters["@Result"].Size = 4;
            dbCommand.Parameters["@Result"].SqlDbType = SqlDbType.Int;
            dbCommand.Parameters["@Result"].Direction = ParameterDirection.Output;

            int nRet = -1;
            try
            {
                dbCommand.ExecuteNonQuery();
                nRet = (int)dbCommand.Parameters["@Result"].Value;
            }
            catch (SqlException ex)
            {
                MessageBoxEx.Show(ex.Message.ToString());
            }

            return nRet;
        }

        public int AddRecordValue(int nRecordID, SqlConnection dbConnection)
        {
            if (dbConnection.State == ConnectionState.Closed)
            {
                dbConnection.Open();
            }

            SqlCommand dbCommand = new SqlCommand("proc_AddRecordValue", dbConnection);
            dbCommand.CommandType = CommandType.StoredProcedure;
            dbCommand.Parameters.AddWithValue("@RecordID", nRecordID);
            dbCommand.Parameters.AddWithValue("@Result", DBNull.Value);
            dbCommand.Parameters["@Result"].Size = 4;
            dbCommand.Parameters["@Result"].SqlDbType = SqlDbType.Int;
            dbCommand.Parameters["@Result"].Direction = ParameterDirection.Output;

            int nRet = -1;
            try
            {
                dbCommand.ExecuteNonQuery();
                nRet = (int)dbCommand.Parameters["@Result"].Value;
            }
            catch (SqlException ex)
            {
                MessageBoxEx.Show(ex.Message.ToString());
            }

            return nRet;
        }

        public int DelEventRecord(int nEventID, int nRecordID, SqlConnection dbConnection)
        {
            if (dbConnection.State == ConnectionState.Closed)
            {
                dbConnection.Open();
            }

            SqlCommand dbCommand = new SqlCommand();
            dbCommand.Connection = dbConnection;
            String strFmt, strSQL;
            int nRet = -1;
            try
            {
                // Delete RecordValues
                strFmt = @"DELETE FROM TS_Record_Values WHERE F_RecordID={0:D}";
                strSQL = String.Format(strFmt, nRecordID);
                dbCommand.CommandText = strSQL;
                nRet = dbCommand.ExecuteNonQuery();

                // Delete RecordMembers
                strFmt = @"DELETE FROM TS_Record_Member WHERE F_RecordID={0:D}";
                strSQL = String.Format(strFmt, nRecordID);
                dbCommand.CommandText = strSQL;
                nRet = dbCommand.ExecuteNonQuery();

                // Delete EventRecord
                strFmt = @"DELETE FROM TS_Event_Record WHERE F_EventID = {0:D} AND F_RecordID = {1:D}";
                strSQL = String.Format(strFmt, nEventID, nRecordID);
                dbCommand.CommandText = strSQL;
                nRet = dbCommand.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                MessageBoxEx.Show(ex.Message.ToString());
            }

            return nRet;
        }

        public int DelRecordMember(int nRecordID, int nMemberNum, SqlConnection dbConnection)
        {
            if (dbConnection.State == ConnectionState.Closed)
            {
                dbConnection.Open();
            }

            String strFmt = @"DELETE FROM TS_Record_Member WHERE F_MemberNum = {0:D} AND F_RecordID = {1:D}";

            String strSQL = String.Format(strFmt, nMemberNum, nRecordID);

            SqlCommand dbCommand = new SqlCommand(strSQL, dbConnection);
            int nRet = -1;
            try
            {
                nRet = dbCommand.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                MessageBoxEx.Show(ex.Message.ToString());
            }

            return nRet;
        }

        public int DelRecordValues(int nRecordID, int nValueNum, SqlConnection dbConnection)
        {
            if (dbConnection.State == ConnectionState.Closed)
            {
                dbConnection.Open();
            }

            String strFmt = @"DELETE FROM TS_Record_Values WHERE F_ValueNum = {0:D} AND F_RecordID = {1:D}";

            String strSQL = String.Format(strFmt, nValueNum, nRecordID);

            SqlCommand dbCommand = new SqlCommand(strSQL, dbConnection);
            int nRet = -1;
            try
            {
                nRet = dbCommand.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                MessageBoxEx.Show(ex.Message.ToString());
            }

            return nRet;
        }

        public int ModifyEventRecord(int nEventID, int nRecordID, SqlConnection dbConnection, String strField, String strFieldValue)
        {
            if (dbConnection.State == ConnectionState.Closed)
            {
                dbConnection.Open();
            }

            String strFmt = @"UPDATE TS_Event_Record SET 
                            {0} = '{1}'
                            WHERE F_RecordID = {2:D} AND F_EventID = {3:D}";

            String strSQL = String.Format(strFmt, strField, strFieldValue, nRecordID, nEventID);

            SqlCommand dbCommand = new SqlCommand(strSQL, dbConnection);
            int nRet = -1;
            try
            {
                nRet = dbCommand.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                MessageBoxEx.Show(ex.Message.ToString());
            }

            return nRet;
        }

        public int ModifyRecordValues(int nRecordID, int nValueNum, SqlConnection dbConnection, String strField, String strFieldValue)
        {
            if (dbConnection.State == ConnectionState.Closed)
            {
                dbConnection.Open();
            }

            String strFmt = @"UPDATE TS_Record_Values SET 
                            {0} = '{1}'
                            WHERE F_RecordID = {2:D} AND F_ValueNum = {3:D}";

            String strSQL = String.Format(strFmt, strField, strFieldValue, nRecordID, nValueNum);

            SqlCommand dbCommand = new SqlCommand(strSQL, dbConnection);
            int nRet = -1;
            try
            {
                nRet = dbCommand.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                MessageBoxEx.Show(ex.Message.ToString());
            }
            return nRet;
        }


        public string GetCurActivedLanguageCode(SqlConnection dbConnection)
        {
            if (dbConnection.State == System.Data.ConnectionState.Closed)
            {
                dbConnection.Open();
            }

            string strSQLDes;
            strSQLDes = "SELECT F_LanguageCode FROM TC_Language WHERE F_Active = 1";
            SqlCommand cmd = new SqlCommand(strSQLDes, dbConnection);

            string strLanguage = "";
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                strLanguage = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_LanguageCode");
            }
            dr.Close();
            return strLanguage;
        }

        // Common tools
        public int Str2Int(Object strObj)
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

        public String Obj2Str(Object Value)
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

        private void MenuSetRegister_Click(object sender, EventArgs e)
        {
            RegisterSelForm registerSelForm = new RegisterSelForm(m_nEventID, GetCurActivedLanguageCode(m_dbConnection), m_dbConnection);

            registerSelForm.ShowDialog();

            if (registerSelForm.DialogResult == DialogResult.OK)
            {
                Int32 iRegisterID = registerSelForm.m_SelRegisterID;


                DataGridViewRow row = new DataGridViewRow();

                if (dgvEventRecords.SelectedRows.Count > 0)
                {
                    try
                    {
                        SqlCommand oneSqlCommand = new SqlCommand();
                        oneSqlCommand.Connection = m_dbConnection;
                        oneSqlCommand.CommandText = "proc_SetRecordRegister";
                        oneSqlCommand.CommandType = CommandType.StoredProcedure;

                        SqlParameter cmdParameter1 = new SqlParameter("@RecordID", SqlDbType.Int);
                        SqlParameter cmdParameter2 = new SqlParameter("@RegisterID", SqlDbType.Int);
                        SqlParameter cmdParameter3 = new SqlParameter(
                                 "@Result", SqlDbType.Int, 4,
                                 ParameterDirection.Output, false, 0, 0, "@Result",
                                 DataRowVersion.Default, DBNull.Value);

                        oneSqlCommand.Parameters.Add(cmdParameter1);
                        oneSqlCommand.Parameters.Add(cmdParameter2);
                        oneSqlCommand.Parameters.Add(cmdParameter3);

                        Int32 iRecordIDIdx = dgvEventRecords.Columns["F_RecordID"].Index;

                        row = dgvEventRecords.SelectedRows[0];
                        Int32 iRowIdx = row.Index;

                        string strRecordID = dgvEventRecords.Rows[iRowIdx].Cells[iRecordIDIdx].Value.ToString();

                        cmdParameter1.Value = Convert.ToInt32(strRecordID);
                        cmdParameter2.Value = iRegisterID;

                        if (m_dbConnection.State == System.Data.ConnectionState.Closed)
                        {
                            m_dbConnection.Open();
                        }

                        oneSqlCommand.ExecuteNonQuery();


                    }
                    catch (System.Exception ee)
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(ee.Message);
                    }
                }

                this.ShowEventRecordToGrid();

            }
        }

        private void FillRecordType()
        {
            if (m_dbConnection.State == System.Data.ConnectionState.Closed)
            {
                m_dbConnection.Open();
            }

            try
            {
                #region DML Command Setup for Record Type

                string strSQL = "SELECT F_RecordTypeCode AS F_Name, F_RecordTypeID AS F_Key FROM TC_RecordType ";
                SqlCommand RecordCmd = new SqlCommand(strSQL, m_dbConnection);

                SqlDataReader dr = RecordCmd.ExecuteReader();

                DataTable table = new DataTable();
                table.Columns.Add("F_Name", typeof(string));
                table.Columns.Add("F_Key", typeof(int));
                table.Load(dr);

                (dgvEventRecords.Columns["F_RecordType"] as DGVCustomComboBoxColumn).FillComboBoxItems(table, "F_Name", "F_Key");
                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void dgvEventRecords_SelectionChanged(object sender, EventArgs e)
        {
            if (m_bUpdatingUI)
                return;

            DataGridViewRow row = new DataGridViewRow();

            if (dgvEventRecords.SelectedRows.Count > 0)
            {
                row = dgvEventRecords.SelectedRows[0];
                Int32 nRow = row.Index;
                if (nRow >= 0 && nRow < dgvEventRecords.RowCount)
                {
                    String strReocrdID = Obj2Str(dgvEventRecords.Rows[nRow].Cells["F_RecordID"].Value);
                    m_nCurRecordID = Str2Int(strReocrdID);

                    ShowRecordValuesToGrid(m_nCurRecordID);
                    ShowRecordMembersToGrid(m_nCurRecordID);
                }
            }
        }

     
    }

}
