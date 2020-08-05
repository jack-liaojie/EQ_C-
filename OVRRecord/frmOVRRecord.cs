using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using System.Data.SqlClient;
using System.Data.OleDb;
using Sunny.UI;

namespace AutoSports.OVRRecord
{
    public partial class OVRRecordForm : UIPage
    {
        private bool m_bUpdatingUI;

        private OVRRecordModule m_RecordModule;
        public OVRRecordModule RecordMdodule
        {
            set { m_RecordModule = value; }
        }

        private int m_iActiveSport = -1;
        private int m_iActiveDiscipline = -1;
        private string m_strActiveLanguage = "CHN";
        string strSectionName = "OVRRecord";

        public OVRRecordForm()
        {
            InitializeComponent();

            OVRDataBaseUtils.SetDataGridViewStyle(dgv_Events);
            OVRDataBaseUtils.SetDataGridViewStyle(dgvEventRecords);
            OVRDataBaseUtils.SetDataGridViewStyle(dgvRecordValue);
            OVRDataBaseUtils.SetDataGridViewStyle(dgvRecordMember);
        }

        public void OnMainFrameEvent(object sender, OVRFrame2ModuleEventArgs e)
        {
            switch (e.Type)
            {
                case OVRFrame2ModuleEventType.emLoadData:
                    {
                        LoadData();
                        break;
                    }
                case OVRFrame2ModuleEventType.emUpdateData:
                    {
                        UpdateData(e.Args as OVRDataChangedFlags);
                        break;
                    }
                case OVRFrame2ModuleEventType.emRptContextQuery:
                    {
                        QueryReportContext(e.Args as OVRReportContextQueryArgs);
                        break;
                    }
            }
        }

        private void LoadData()
        {
            OVRDataBaseUtils.GetActiveInfo(m_RecordModule.DatabaseConnection, out m_iActiveSport, out m_iActiveDiscipline, out m_strActiveLanguage);
            ShowEventToGrid();
            ShowEventRecordToGrid();
            ShowRecordValuesToGrid(GetCurSelEventRecordID());
            ShowRecordMembersToGrid(GetCurSelEventRecordID());
        }

        private void OVRRecordForm_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        private void dgv_Events_SelectionChanged(object sender, EventArgs e)
        {
            if (m_bUpdatingUI)
                return;
            ShowEventRecordToGrid();
            ShowRecordValuesToGrid(GetCurSelEventRecordID());
            ShowRecordMembersToGrid(GetCurSelEventRecordID());
        }

        private void dgvEventRecords_SelectionChanged(object sender, EventArgs e)
        {
            if (m_bUpdatingUI)
                return;
            ShowRecordValuesToGrid(GetCurSelEventRecordID());
            ShowRecordMembersToGrid(GetCurSelEventRecordID());
        }

        private void UpdateData(OVRDataChangedFlags flags)
        {
            if (flags == null || !flags.HasSignal)
                return;

            if (IsUpdateAllData(flags))
            {
                LoadData();
                return;
            }

        }

        private bool IsUpdateAllData(OVRDataChangedFlags flags)
        {
            if (m_RecordModule == null) return false;

            if (flags.IsSignaled(OVRDataChangedType.emLangActive))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emSportActive))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emSportInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emDisciplineActive))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emDisciplineInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventAdd))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventDel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventStatus))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventModel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emPhaseAdd))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emPhaseDel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emPhaseModel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emPhaseInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emPhaseStatus))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchAdd))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchDel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchStatus))
                return true;

            return false;
        }

        private void QueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;

            switch (args.Name)
            {
                case "DisciplineID":
                    args.Value = m_iActiveDiscipline.ToString();
                    args.Handled = true;
                    break;
                case "EventID":
                    {
                        break;
                    }
            }
        }

        private void btn_ExportRecord_Click(object sender, EventArgs e)
        {
            string saveFileName = "";
            SaveFileDialog saveDialog = new SaveFileDialog();
            saveDialog.DefaultExt = "xls";
            saveDialog.Filter = "Excel文件|*.xls";
            saveDialog.FileName = "Record";
            saveDialog.ShowDialog();
            saveFileName = saveDialog.FileName;
            if (saveFileName.IndexOf(":") < 0) return; //被点了取消

            Microsoft.Office.Interop.Excel.Application xlApp = new Microsoft.Office.Interop.Excel.Application();
            object missing = System.Reflection.Missing.Value;

            if (xlApp == null)
            {
                MessageBox.Show("无法创建Excel对象，可能您的机子未安装Excel");
                return;
            }
            Microsoft.Office.Interop.Excel.Workbooks workbooks = xlApp.Workbooks;
            Microsoft.Office.Interop.Excel.Workbook workbook = workbooks.Add(Microsoft.Office.Interop.Excel.XlWBATemplate.xlWBATWorksheet);
            Microsoft.Office.Interop.Excel.Worksheet worksheet = (Microsoft.Office.Interop.Excel.Worksheet)workbook.Worksheets[1];//取得sheet1


            System.Data.DataTable dt = new System.Data.DataTable();
            ExportAllRecord(ref dt);

            //写入列名
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                worksheet.Cells[1, i + 1] = dt.Columns[i].ColumnName;
            }
            //写入数值
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    worksheet.Cells[i + 2, j + 1] = dt.Rows[i][j].ToString();
                }
            }
            worksheet.SaveAs(saveFileName, 56, missing, missing, missing, missing, missing, missing, missing);
            workbook.Close(missing, missing, missing);
            xlApp.Quit();

            DevComponents.DotNetBar.MessageBoxEx.Show("文件已导出！");
        }

        private void btn_ImportRecord_Click(object sender, EventArgs e)
        {
            OpenFileDialog ofd = new OpenFileDialog();
            ofd.Filter = "Excel文件|*.xls";
            DialogResult dr = ofd.ShowDialog();
            string strFilePath = ofd.FileName;

            if (strFilePath.Length == 0)
                return;

            System.Data.DataTable dt = new System.Data.DataTable();

            string conn = @"Provider=Microsoft.Jet.OLEDB.4.0;Data Source= " + strFilePath + ";Extended Properties=Excel 8.0;";
            string sql = "select * from [Sheet1$]";
            OleDbCommand cmd = new OleDbCommand(sql, new OleDbConnection(conn));
            OleDbDataAdapter ada = new OleDbDataAdapter(cmd);
            try
            {
                ada.Fill(dt);
                DeleteAllRecord();
                InitTempTable();
                ImportRecord(dt);
                UpdateRecord2DB();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        private void ExportAllRecord(ref System.Data.DataTable dt)
        {
            if (m_RecordModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RecordModule.DatabaseConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_Record_ExportRecord", m_RecordModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strActiveLanguage);
                cmd.Parameters.Add(cmdParameter1);

                SqlDataReader dr = cmd.ExecuteReader();
                dt.Load(dr);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private bool DeleteAllRecord()
        {
            bool bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand("Proc_Record_DeleteRecordInfo", m_RecordModule.DatabaseConnection);
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameterResult = new SqlParameter(
                                                 "@Result", SqlDbType.Int, 4,
                                                 ParameterDirection.Output, true, 0, 0, "",
                                                 DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_RecordModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_RecordModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    int iOperateResult = (Int32)cmdParameterResult.Value;
                    switch (iOperateResult)
                    {
                        case 1://纪录信息清空成功！
                            bResult = true;
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show("纪录信息清空出错！");
                            bResult = false;
                            break;
                    }
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return bResult;
        }

        private bool ImportRecord(System.Data.DataTable dt)
        {
            bool bResult = false;

            SqlCommand oneSqlCommand = new SqlCommand("Proc_Record_Insert2TempTable", m_RecordModule.DatabaseConnection);
            oneSqlCommand.CommandType = CommandType.StoredProcedure;

            for (int i = 0; i < dt.Rows.Count; i++)
            {

                try
                {
                    oneSqlCommand.Parameters.Clear();
                    for (int j = 0; j < dt.Columns.Count; j++)
                    {
                        string strParameterName = string.Format("Field{0}", j + 1);

                        SqlParameter cmdParameter1 = new SqlParameter(
                                     strParameterName, SqlDbType.NVarChar, 200,
                                     ParameterDirection.Input, true, 0, 0, strParameterName,
                                     DataRowVersion.Current, dt.Rows[i][j].ToString());
                        oneSqlCommand.Parameters.Add(cmdParameter1);
                    }


                    SqlParameter cmdParameterResult = new SqlParameter(
                                               "@Result", SqlDbType.Int, 4,
                                               ParameterDirection.Output, true, 0, 0, "",
                                               DataRowVersion.Current, 0);

                    oneSqlCommand.Parameters.Add(cmdParameterResult);

                    if (m_RecordModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                    {
                        m_RecordModule.DatabaseConnection.Open();
                    }

                    if (oneSqlCommand.ExecuteNonQuery() != 0)
                    {
                        int iOperateResult = (Int32)cmdParameterResult.Value;
                        switch (iOperateResult)
                        {
                            case 1://导入成功成功！
                                bResult = true;
                                break;
                            default:
                                DevComponents.DotNetBar.MessageBoxEx.Show("纪录信息导入临时表出错！");
                                bResult = false;
                                break;
                        }
                    }
                }
                catch (System.Exception e)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                }
            }
            return bResult;
        }

        private bool InitTempTable()
        {
            bool bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand("Proc_Record_IntiTempRecordTable", m_RecordModule.DatabaseConnection);
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameterResult = new SqlParameter(
                                                 "@Result", SqlDbType.Int, 4,
                                                 ParameterDirection.Output, true, 0, 0, "",
                                                 DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_RecordModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_RecordModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    int iOperateResult = (Int32)cmdParameterResult.Value;
                    switch (iOperateResult)
                    {
                        case 1://导入成功成功！
                            bResult = true;
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show("纪录信息临时表创建出错！");
                            bResult = false;
                            break;
                    }
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return bResult;
        }

        private bool UpdateRecord2DB()
        {
            bool bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand("Proc_Record_UpdateRecord2DB", m_RecordModule.DatabaseConnection);
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameterResult = new SqlParameter(
                                                 "@Result", SqlDbType.Int, 4,
                                                 ParameterDirection.Output, true, 0, 0, "",
                                                 DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_RecordModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_RecordModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    int iOperateResult = (Int32)cmdParameterResult.Value;
                    switch (iOperateResult)
                    {
                        case 1://导入成功成功！
                            bResult = true;
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show("纪录信息更新到数据库中出错！");
                            bResult = false;
                            break;
                    }
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return bResult;
        }

        private int GetCurSelEventID()
        {
            Int32 iColIdxID = dgv_Events.Columns["ID"].Index;
            if (dgv_Events.SelectedRows.Count == 0)
                return -1;

            return Convert.ToInt32(dgv_Events.SelectedRows[0].Cells[iColIdxID].Value);
        }

        private int GetCurSelEventRecordID()
        {
            Int32 iColIdxID = dgvEventRecords.Columns["F_RecordID"].Index;
            if (dgvEventRecords.SelectedRows.Count == 0)
                return -1;

            return Convert.ToInt32(dgvEventRecords.SelectedRows[0].Cells[iColIdxID].Value);
        }

        private void ShowEventToGrid()
        {
            if (m_RecordModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RecordModule.DatabaseConnection.Open();
            }

            #region DML Command Setup for daEvent

            SqlCommand cmd = new SqlCommand("Proc_GetDisciplineEvents", m_RecordModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            SqlParameter cmdParameter1 = new SqlParameter(
                        "@DisciplineID", SqlDbType.Int, 0,
                         ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                        DataRowVersion.Current, m_iActiveDiscipline);

            SqlParameter cmdParameter2 = new SqlParameter(
                         "@LanguageCode", SqlDbType.Char, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, m_strActiveLanguage);

            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);
            #endregion

            SqlDataReader dr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(dr);
            dr.Close();

            OVRDataBaseUtils.FillDataGridView(dgv_Events, dt);

        }
        
        private void ShowEventRecordToGrid()
        {
            m_bUpdatingUI = true;
            int iFirstDisplayedScrollingRowIndex = dgvEventRecords.FirstDisplayedScrollingRowIndex;
            int iFirstDisplayedScrollingColumnIndex = dgvEventRecords.FirstDisplayedScrollingColumnIndex;
            if (iFirstDisplayedScrollingRowIndex < 0) iFirstDisplayedScrollingRowIndex = 0;
            if (iFirstDisplayedScrollingColumnIndex < 0) iFirstDisplayedScrollingColumnIndex = 0;

            SqlDataReader dbReader = GetEventRecords(GetCurSelEventID(), m_RecordModule.DatabaseConnection);
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

            SqlDataReader dbReader = GetRecordValues(nRecordID, m_RecordModule.DatabaseConnection);
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

            SqlDataReader dbReader = GetRecordMember(nRecordID, m_RecordModule.DatabaseConnection);
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
                         DataRowVersion.Current, m_strActiveLanguage);

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
                         DataRowVersion.Current, m_strActiveLanguage);

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


        private void btn_AddRecord_Click(object sender, EventArgs e)
        {
            AddEventRecord(GetCurSelEventID(), m_RecordModule.DatabaseConnection);

            ShowEventRecordToGrid();
        }

        private void btn_DelRecord_Click(object sender, EventArgs e)
        {
            foreach (DataGridViewRow row in dgvEventRecords.SelectedRows)
            {
                String strReocrdID = Obj2Str(row.Cells["F_RecordID"].Value);
                int nRecordID = Str2Int(strReocrdID);

                DelEventRecord(GetCurSelEventID(), nRecordID, m_RecordModule.DatabaseConnection);
            }

            ShowEventRecordToGrid();
            dgvRecordMember.RowCount = 0;
            dgvRecordValue.RowCount = 0;
        }

        private void btnRecordValueNew_Click(object sender, EventArgs e)
        {
            AddRecordValue(GetCurSelEventRecordID(), m_RecordModule.DatabaseConnection);
            ShowRecordValuesToGrid(GetCurSelEventRecordID());
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

                DelRecordValues(nRecordID, nValueNum, m_RecordModule.DatabaseConnection);
            }

            ShowRecordValuesToGrid(nRecordID);
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

        private void FillRecordType()
        {
            if (m_RecordModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RecordModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for Record Type

                string strSQL = "SELECT F_RecordTypeCode AS F_Name, F_RecordTypeID AS F_Key FROM TC_RecordType ";
                SqlCommand RecordCmd = new SqlCommand(strSQL, m_RecordModule.DatabaseConnection);

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
            else if (dgvEventRecords.Columns[nCol].Name == "F_RegisterCode" || dgvEventRecords.Columns[nCol].Name == "F_LongName"
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

                ModifyEventRecord(nEventID, nRecordID, m_RecordModule.DatabaseConnection, strColName, strColValue);
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

            ModifyRecordValues(nRecordID, nValueNum, m_RecordModule.DatabaseConnection, strColName, strColVale);
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
            RegisterSelForm registerSelForm = new RegisterSelForm(GetCurSelEventID(), m_strActiveLanguage, m_RecordModule.DatabaseConnection);

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
                        oneSqlCommand.Connection = m_RecordModule.DatabaseConnection;
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

                        if (m_RecordModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                        {
                            m_RecordModule.DatabaseConnection.Open();
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

            ModifyEventRecord(nEventID, nRecordID, m_RecordModule.DatabaseConnection, strColName, strColValue); 
        }
    }
}
