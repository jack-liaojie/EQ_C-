using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using DevComponents.DotNetBar.Controls;

namespace AutoSports.OVRCommon
{
    public class OVRCheckBoxColumn
    {
        public OVRCheckBoxColumn(int index, object trueV, object falseV)
        {
            columnIndex = index;
            trueValue = trueV;
            falseValue = falseV;
        }

        public int columnIndex;
        public object trueValue;
        public object falseValue;
    }

    public static class OVRDataBaseUtils
    {
        public static String GetFieldValue2String(ref SqlDataReader sdr, String strFieldName)
        {
            String strValue = "";
            if (!(sdr[strFieldName] is DBNull))
            {
                strValue = Convert.ToString(sdr[strFieldName]);
            }
            return strValue;
        }

        public static String GetFieldValue2String(ref SqlDataReader sdr, Int32 iIndex)
        {
            String strValue = "";
            if (!(sdr[iIndex] is DBNull))
            {
                strValue = Convert.ToString(sdr[iIndex]);
            }
            return strValue;
        }

        public static Int32 GetFieldValue2Int32(ref SqlDataReader sdr, String strFieldName)
        {
            Int32 strValue = 0;
            if (!(sdr[strFieldName] is DBNull))
            {
                strValue = Convert.ToInt32(Convert.ToString(sdr[strFieldName]));
            }
            return strValue;
        }

        public static Int32 GetFieldValue2Int32(ref SqlDataReader sdr, Int32 iIndex)
        {
            Int32 strValue = 0;
            if (!(sdr[iIndex] is DBNull))
            {
                strValue = Convert.ToInt32(Convert.ToString(sdr[iIndex]));
            }
            return strValue;
        }

        public static void SetDataGridViewStyle(DataGridView dgv)
        {
            if (dgv == null) return;
            dgv.AlternatingRowsDefaultCellStyle.BackColor = System.Drawing.Color.FromArgb(202, 221, 238);
            dgv.DefaultCellStyle.BackColor = System.Drawing.Color.FromArgb(230, 239, 248);
            dgv.BackgroundColor = System.Drawing.Color.FromArgb(212, 228, 242);
            dgv.GridColor = System.Drawing.Color.FromArgb(208, 215, 229);
            dgv.BorderStyle = BorderStyle.Fixed3D;
            dgv.CellBorderStyle = DataGridViewCellBorderStyle.Single;
            dgv.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgv.RowHeadersVisible = false;
            dgv.ColumnHeadersHeight = 25;
            dgv.RowHeadersWidthSizeMode = DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            dgv.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            dgv.AllowUserToAddRows = false;
            dgv.AllowUserToDeleteRows = false;
            dgv.AllowUserToOrderColumns = false;
            dgv.AllowUserToResizeRows = false;

            dgv.Sorted += new System.EventHandler(dgvTable_Sorted);
            dgv.SortCompare += new System.Windows.Forms.DataGridViewSortCompareEventHandler(dgvTable_SortCompare);
        }

        private static void dgvTable_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex != -1 || e.ColumnIndex < 0)
                return;

            // This method served for multi-column sort. (Unfinished)
        }

        private static void dgvTable_SortCompare(object sender, DataGridViewSortCompareEventArgs e)
        {
            try
            {
                string strItem1 = e.CellValue1.ToString();
                string strItem2 = e.CellValue2.ToString();

                if (strItem1.Length < 1 || strItem2.Length < 1)
                    return;

                if (!Char.IsDigit(strItem1, 0) && strItem1[0] != '+' && strItem1[0] != '-')
                    return;
                if (!Char.IsDigit(strItem2, 0) && strItem2[0] != '+' && strItem2[0] != '-')
                    return;

                bool bPoint = false;
                for (int i = 1; i < strItem1.Length; i++ )
                {
                    if (strItem1[i] == '.' && !bPoint)
                        bPoint = true;
                    else if (!Char.IsDigit(strItem1, i) )
                        return;
                }

                bPoint = false;
                for (int i = 1; i < strItem2.Length; i++)
                {
                    if (strItem2[i] == '.' && !bPoint)
                        bPoint = true;
                    else if (!Char.IsDigit(strItem2, i))
                        return;
                }

                float fItem1 = System.Convert.ToSingle(e.CellValue1);
                float fItem2 = System.Convert.ToSingle(e.CellValue2);

                if (fItem1 - fItem2 == 0.0f)
                    e.SortResult = 0;
                else
                    e.SortResult = (fItem1 - fItem2) > 0.0f ? 1 : -1;

                e.Handled = true;
            }
            catch (System.Exception)
            {
                return;
            }
        }

        private static void dgvTable_Sorted(object sender, EventArgs e)
        {
            if (sender is DataGridView)
            {
                DataGridView dgv = sender as DataGridView;
                if (dgv.RowHeadersVisible)
                {
                    int iRowNum = 1;
                    for (int i = 0; i < dgv.Rows.Count; i++)
                    {
                        dgv.Rows[i].HeaderCell.Value = iRowNum.ToString();
                        iRowNum++;
                    }
                }
            }
        }

        public static void FillDataGridViewWithCmb(DataGridView dgv, SqlDataReader sdr, params string[] comboBoxColumns)
        {
            if (dgv == null || sdr == null) return;

            if (comboBoxColumns.Length < 1)
            {
                FillDataGridView(dgv, sdr, null, null);
                return;
            }

            List<int> lstColumns = new List<int>();
            for (int i = 0; i < comboBoxColumns.Length; i++)
            {
                for (int j = 0; j < sdr.FieldCount; j++)
                {
                    if (comboBoxColumns[i] == sdr.GetName(j))
                    {
                        lstColumns.Add(j);
                    }
                }
            }
            FillDataGridView(dgv, sdr, lstColumns, null);
        }

        public static void FillDataGridViewWithCmb(DataGridView dgv, DataTable dt, params string[] comboBoxColumns)
        {
            if (dgv == null || dt == null) return;

            if (comboBoxColumns.Length < 1)
            {
                FillDataGridView(dgv, dt, null, null);
                return;
            }

            List<int> lstColumns = new List<int>();
            for (int i = 0; i < comboBoxColumns.Length; i++)
            {
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (comboBoxColumns[i] == dt.Columns[j].ColumnName)
                    {
                        lstColumns.Add(j);
                    }
                }
            }
            FillDataGridView(dgv, dt, lstColumns, null);
        }

        public static void FillDataGridViewWithCmb(DataGridView dgv, SqlDataReader sdr, params int[] comboBoxColumns)
        {
            if (dgv == null || sdr == null) return;

            if (comboBoxColumns.Length < 1)
            {
                FillDataGridView(dgv, sdr, null, null);
                return;
            }

            List<int> lstColumns = new List<int>();
            for (int i = 0; i < comboBoxColumns.Length; i++)
            {
                lstColumns.Add(comboBoxColumns[i]);
            }

            FillDataGridView(dgv, sdr, lstColumns, null);
        }

        public static void FillDataGridViewWithCmb(DataGridView dgv, DataTable dt, params int[] comboBoxColumns)
        {
            if (dgv == null || dt == null) return;

            if (comboBoxColumns.Length < 1)
            {
                FillDataGridView(dgv, dt, null, null);
                return;
            }

            List<int> lstColumns = new List<int>();
            for (int i = 0; i < comboBoxColumns.Length; i++)
            {
                lstColumns.Add(comboBoxColumns[i]);
            }
            FillDataGridView(dgv, dt, lstColumns, null);
        }

        public static void FillDataGridViewWithChk(DataGridView dgv, SqlDataReader sdr, int index, object trueValue, object falseValue)
        {
            if (dgv == null || sdr == null) return;

            if (sdr.FieldCount <= index)
            {
                FillDataGridView(dgv, sdr, null, null);
                return;
            }

            List<OVRCheckBoxColumn> lstColumns = new List<OVRCheckBoxColumn>();
            lstColumns.Add(new OVRCheckBoxColumn(index, trueValue, falseValue));
            FillDataGridView(dgv, sdr, null, lstColumns);
        }

        public static void FillDataGridViewWithChk(DataGridView dgv, DataTable dt, int index, object trueValue, object falseValue)
        {
            if (dgv == null || dt == null) return;

            if (dt.Columns.Count <= index)
            {
                FillDataGridView(dgv, dt, null, null);
                return;
            }

            List<OVRCheckBoxColumn> lstColumns = new List<OVRCheckBoxColumn>();
            lstColumns.Add(new OVRCheckBoxColumn(index, trueValue, falseValue));
            FillDataGridView(dgv, dt, null, lstColumns);
        }

        public static void FillDataGridView(DataGridView dgv, SqlDataReader sdr, List<int> cmbColumns = null, List<OVRCheckBoxColumn> chkColumns = null )
        {
            if (dgv == null || sdr == null) return;
            if (sdr.FieldCount < 1) return;

            bool bResetColumns = false;
            if (sdr.FieldCount != dgv.Columns.Count)
            {
                bResetColumns = true;
            }
            else
            {
                for (int i = 0; i < sdr.FieldCount; i++)
                {
                    if (dgv.Columns[i].HeaderText != sdr.GetName(i))
                    {
                        bResetColumns = true;
                        break;
                    }
                }
            }

            try
            {
                // Reset Columns
                if (bResetColumns)
                {
                    dgv.Columns.Clear();
                    for (int i = 0; i < sdr.FieldCount; i++)
                    {
                        DataGridViewColumn col = null;
                        bool bTextBoxCol = true;
                        if (cmbColumns != null)
                        {
                            for (int j = 0; j < cmbColumns.Count; j++)
                            {
                                if (i == cmbColumns[j])
                                {
                                    col = new DGVCustomComboBoxColumn();
                                    bTextBoxCol = false;
                                    break;
                                }
                            }
                        }
                        if (chkColumns != null)
                        {
                            for (int j = 0; j < chkColumns.Count; j++)
                            {
                                if (i == chkColumns[j].columnIndex)
                                {
                                    col = new DataGridViewCheckBoxColumn();
                                    (col as DataGridViewCheckBoxColumn).TrueValue = chkColumns[j].trueValue.ToString();
                                    (col as DataGridViewCheckBoxColumn).FalseValue = chkColumns[j].falseValue.ToString();
                                    bTextBoxCol = false;
                                    break;
                                }
                            }
                        }
                        if (bTextBoxCol)
                        {
                            col = new DataGridViewTextBoxColumn();
                            col.ReadOnly = true;
                        }
                        if (col != null)
                        {
                            col.HeaderText = sdr.GetName(i);
                            col.Name = sdr.GetName(i);
                            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.NotSet;
                            col.SortMode = DataGridViewColumnSortMode.Automatic;
                            dgv.Columns.Add(col);
                        }
                    }
                }

                List<string> listColumn = new List<string>(sdr.FieldCount);
                for (int i = 0; i < sdr.FieldCount; i++ )
                {
                    listColumn.Add(sdr.GetName(i));
                }

                // Fill DataGridView
                dgv.Rows.Clear();
                int iRowNum = 0;
                while (sdr.Read())
                {
                    DataGridViewRow dr = new DataGridViewRow();
                    dr.CreateCells(dgv);
                    dr.Selected = false;
                    for (int i = 0; i < sdr.FieldCount; i++)
                    {
                        string strValue = sdr[i].ToString();
                        dr.Cells[i].Value = strValue;

                        if (strValue.Length > listColumn[i].Length)
                            listColumn[i] = strValue;
                    }
                    if (dgv.RowHeadersVisible)
                    {
                        iRowNum++;
                        dr.HeaderCell.Value = iRowNum.ToString();
                    }
                    dgv.Rows.Add(dr);
                }
                if (dgv.RowHeadersVisible)
                {
                    dgv.TopLeftHeaderCell.Value = String.Format("RC: {0}", iRowNum);
                    System.Drawing.SizeF sf = dgv.CreateGraphics().MeasureString(dgv.TopLeftHeaderCell.Value.ToString(), dgv.Font);
                    dgv.RowHeadersWidth = System.Convert.ToInt32(sf.Width + 10f);
                }

                // Calculate Column Length
                for (int i = 0; i < sdr.FieldCount; i++ )
                {
                    System.Drawing.SizeF sf = dgv.CreateGraphics().MeasureString(listColumn[i], dgv.Font);
                    dgv.Columns[i].Width = System.Convert.ToInt32(sf.Width + 25f);
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public static void FillDataGridView(DataGridView dgv, DataTable dt, List<int> cmbColumns = null, List<OVRCheckBoxColumn> chkColumns = null)
        {
            if (dgv == null || dt == null) return;
            if (dt.Columns.Count < 1) return;

            bool bResetColumns = false;
            if (dt.Columns.Count != dgv.Columns.Count)
            {
                bResetColumns = true;
            }
            else
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    if (dgv.Columns[i].HeaderText != dt.Columns[i].ColumnName)
                    {
                        bResetColumns = true;
                        break;
                    }
                }
            }

            try
            {
                // Reset Columns
                if (bResetColumns)
                {
                    dgv.Columns.Clear();
                    for (int i = 0; i < dt.Columns.Count; i++)
                    {
                        DataGridViewColumn col = null;
                        bool bTextBoxCol = true;
                        if (cmbColumns != null)
                        {
                            for (int j = 0; j < cmbColumns.Count; j++)
                            {
                                if (i == cmbColumns[j])
                                {
                                    col = new DGVCustomComboBoxColumn();
                                    bTextBoxCol = false;
                                    break;
                                }
                            }
                        }
                        if (chkColumns != null)
                        {
                            for (int j = 0; j < chkColumns.Count; j++)
                            {
                                if (i == chkColumns[j].columnIndex)
                                {
                                    col = new DataGridViewCheckBoxColumn();
                                    (col as DataGridViewCheckBoxColumn).TrueValue = chkColumns[j].trueValue.ToString();
                                    (col as DataGridViewCheckBoxColumn).FalseValue = chkColumns[j].falseValue.ToString();
                                    bTextBoxCol = false;
                                    break;
                                }
                            }
                        }
                        if (bTextBoxCol)
                        {
                            col = new DataGridViewTextBoxColumn();
                            col.ReadOnly = true;
                        }
                        if (col != null)
                        {
                            col.HeaderText = dt.Columns[i].ColumnName;
                            col.Name = dt.Columns[i].ColumnName;
                            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.NotSet;
                            col.SortMode = DataGridViewColumnSortMode.Automatic;
                            dgv.Columns.Add(col);
                        }
                    }
                }

                List<string> listColumn = new List<string>(dt.Columns.Count);
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    listColumn.Add(dt.Columns[i].ColumnName);
                }

                // Fill DataGridView
                dgv.Rows.Clear();
                int iRowNum = 0;
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    DataGridViewRow dr = new DataGridViewRow();
                    dr.CreateCells(dgv);
                    dr.Selected = false;
                    for (int i = 0; i < dt.Columns.Count; i++)
                    {
                        string strValue = dt.Rows[j][i].ToString();
                        dr.Cells[i].Value = strValue;

                        if (strValue.Length > listColumn[i].Length)
                            listColumn[i] = strValue;
                    }
                    if (dgv.RowHeadersVisible)
                    {
                        iRowNum++;
                        dr.HeaderCell.Value = iRowNum.ToString();
                    }
                    dgv.Rows.Add(dr);
                }
                if (dgv.RowHeadersVisible)
                {
                    dgv.TopLeftHeaderCell.Value = String.Format("RC: {0}", iRowNum);
                    System.Drawing.SizeF sf = dgv.CreateGraphics().MeasureString(dgv.TopLeftHeaderCell.Value.ToString(), dgv.Font);
                    dgv.RowHeadersWidth = System.Convert.ToInt32(sf.Width + 10f);
                }

                // Calculate Column Length
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    System.Drawing.SizeF sf = dgv.CreateGraphics().MeasureString(listColumn[i], dgv.Font);
                    dgv.Columns[i].Width = System.Convert.ToInt32(sf.Width + 25f);
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public static void GetRoleModules(SqlConnection DataBaseConnection, int iRoleID, out List<int> aryModuleID)
        {
            aryModuleID = new List<int>();

            String strSql = String.Format("SELECT F_ModuleID FROM TO_Role_Module WHERE F_RoleID = {0:D}", iRoleID);
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DataBaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        aryModuleID.Add((int)OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_ModuleID"));
                    }
                }
                sdr.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        public static void GetActiveInfo(SqlConnection DataBaseConnection, out Int32 iActiveSportID, out Int32 iActiveDisciplineID, out string strLanuageCode)
        {
            iActiveSportID = 0;
            iActiveDisciplineID = 0;
            strLanuageCode = "CHN";

            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DataBaseConnection;
                oneSqlCommand.CommandText = "Proc_GetActiveInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@SportID", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter4);


                if (DataBaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    DataBaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameter4.Value;
                    if (iOperateResult == 1)
                    {
                        iActiveSportID = Convert.ToInt32(cmdParameter1.Value);
                        iActiveDisciplineID = Convert.ToInt32(cmdParameter2.Value);
                        strLanuageCode = Convert.ToString(cmdParameter3.Value);
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        public static void GetReportUploadType(SqlConnection DataBaseConnection, Int32 iDisciplineID, String strReportType, out String strUploadReportType, out string strLanuageCode)
        {
            strUploadReportType = "4";
            strLanuageCode = "CHI";

            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DataBaseConnection;
                oneSqlCommand.CommandText = "Proc_GetReportUploadType";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iDisciplineID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@ReportType", SqlDbType.NVarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strReportType);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@UploadReportType", SqlDbType.NVarChar, 50,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter4);


                if (DataBaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    DataBaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    strUploadReportType = Convert.ToString(cmdParameter3.Value);
                    strLanuageCode = Convert.ToString(cmdParameter4.Value);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        public static void InitLanguageCombBox(ComboBoxEx Cmblanguage, SqlConnection DataBaseConnection)
        {
            String strSql = "SELECT F_LanguageCode FROM TC_Language";
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DataBaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        Cmblanguage.Items.Add(OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_LanguageCode"));
                    }
                }
                sdr.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        public static bool BackupDB(SqlConnection DataBaseConnection)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DataBaseConnection;
                oneSqlCommand.CommandText = "Proc_BackupDatabase";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
                return false;
            }

            return true;
        }

        /// <summary>
        /// 修改比赛的状态，同时保证Phase和Event处于恰当的状态下，并通过调用函数的模块发送通知消息。


        /// </summary>
        /// <param name="iMatchID">比赛的ID。</param>
        /// <param name="iMatchStatusID">要设置的比赛状态的ID。</param>
        /// <param name="DataBaseConnection">数据库连接对像。</param>
        /// <param name="Module">函数调用模块，直接将OVRModuleBase或OVRPluginBase及其派生对象传入即可。</param>
        /// <returns>
        /// 返回 0 表示修改失败。


        /// 返回 1 表示修改成功。


        /// 返回 -1 表示输入参数无效，修改失败。


        /// </returns>
        public static Int32 ChangeMatchStatus(Int32 iMatchID, Int32 iMatchStatusID, SqlConnection DataBaseConnection, object Module)
        {
            Int32 iResult = 0;

            if (DataBaseConnection.State == System.Data.ConnectionState.Closed)
            {
                DataBaseConnection.Open();
            }

            SqlCommand cmd = new SqlCommand("Proc_ChangeMatchStatus", DataBaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter1 = new SqlParameter(
                        "@MatchID", SqlDbType.Int, 4,
                        ParameterDirection.Input, true, 0, 0, "",
                        DataRowVersion.Current, iMatchID);
            cmd.Parameters.Add(cmdParameter1);

            SqlParameter cmdParameter2 = new SqlParameter(
                        "@StatusID", SqlDbType.Int, 4,
                        ParameterDirection.Input, true, 0, 0, "",
                        DataRowVersion.Current, iMatchStatusID);
            cmd.Parameters.Add(cmdParameter2);

            SqlParameter parResult = new SqlParameter(
                        "@Result", SqlDbType.Int, 4,
                         ParameterDirection.Output, true, 0, 0, "",
                         DataRowVersion.Current, DBNull.Value);
            cmd.Parameters.Add(parResult);

            try
            {
                List<OVRDataChanged> changedList = new List<OVRDataChanged>();

                SqlDataReader sdr = cmd.ExecuteReader();
                if (sdr.HasRows)
                {
                    sdr.Read();
                    iResult = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "Result");
                }
                sdr.NextResult();
                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        int iType = 0;
                        int iEventID = 0;
                        int iPhaseID = 0;
                        int iCurMatchID = 0;
                        iType = GetFieldValue2Int32(ref sdr, "F_Type");
                        iEventID = GetFieldValue2Int32(ref sdr, "F_EventID");
                        iPhaseID = GetFieldValue2Int32(ref sdr, "F_PhaseID");
                        iCurMatchID = GetFieldValue2Int32(ref sdr, "F_MatchID");

                        switch (iType)
                        {
                        case -1:    // Event
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emEventStatus, -1, iEventID, -1, -1, iEventID, null));
                        	break;
                        case 0:     // Phase
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emPhaseStatus, -1, -1, iPhaseID, -1, iPhaseID, null));
                        	break;
                        case 1:     // Match
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchStatus, -1, -1, -1, iCurMatchID, iCurMatchID, null));
                            break;
                        }
                    }
                }
                sdr.Close();

                if (changedList.Count > 0 && Module != null)
                {
                    if (Module is OVRModuleBase)
                    {
                        (Module as OVRModuleBase).DataChangedNotify(changedList);
                    }
                    else if (Module is OVRPluginBase)
                    {
                        (Module as OVRPluginBase).DataChangedNotify(changedList);
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return iResult;
        }

        /// <summary>
        /// 修改Phase的状态，同时保证Event处于恰当的状态下，并通过调用函数的模块发送通知消息。


        /// </summary>
        /// <param name="iPhaseID">比赛阶段的ID</param>
        /// <param name="iPhaseStatusID">要设置的比赛阶段状态的ID。</param>
        /// <param name="DataBaseConnection">数据库连接对像。</param>
        /// <param name="Module">函数调用模块，直接将OVRModuleBase或OVRPluginBase及其派生对象传入即可。</param>
        /// <returns>
        /// 返回 0 表示修改比赛阶段状态失败！
        /// 返回 1 表示修改比赛阶段状态成功！
        /// 返回 -1 表示修改比赛阶段状态失败，数据参数无效
        /// 返回 -2 表示修改比赛阶段状态失败，该阶段的子阶段或者子比赛的状态不允许该阶段进行此状态修改！
        /// </returns>
        public static Int32 ChangePhaseStatus(Int32 iPhaseID, Int32 iPhaseStatusID, SqlConnection DataBaseConnection, object Module)
        {
            Int32 iResult = 0;

            if (DataBaseConnection.State == System.Data.ConnectionState.Closed)
            {
                DataBaseConnection.Open();
            }

            SqlCommand cmd = new SqlCommand("Proc_ChangePhaseStatus", DataBaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter1 = new SqlParameter(
                        "@PhaseID", SqlDbType.Int, 4,
                        ParameterDirection.Input, true, 0, 0, "",
                        DataRowVersion.Current, iPhaseID);
            cmd.Parameters.Add(cmdParameter1);

            SqlParameter cmdParameter2 = new SqlParameter(
                        "@StatusID", SqlDbType.Int, 4,
                        ParameterDirection.Input, true, 0, 0, "",
                        DataRowVersion.Current, iPhaseStatusID);
            cmd.Parameters.Add(cmdParameter2);

            SqlParameter parResult = new SqlParameter(
                        "@Result", SqlDbType.Int, 4,
                         ParameterDirection.Output, true, 0, 0, "",
                         DataRowVersion.Current, DBNull.Value);
            cmd.Parameters.Add(parResult);

            try
            {
                List<OVRDataChanged> changedList = new List<OVRDataChanged>();

                SqlDataReader sdr = cmd.ExecuteReader();
                if (sdr.HasRows)
                {
                    sdr.Read();
                    iResult = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "Result");
                }
                sdr.NextResult();
                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        int iType = 0;
                        int iEventID = 0;
                        int iCurPhaseID = 0;
                        iType = GetFieldValue2Int32(ref sdr, "F_Type");
                        iEventID = GetFieldValue2Int32(ref sdr, "F_EventID");
                        iCurPhaseID = GetFieldValue2Int32(ref sdr, "F_PhaseID");

                        switch (iType)
                        {
                            case -1:    // Event
                                changedList.Add(new OVRDataChanged(OVRDataChangedType.emEventStatus, -1, iEventID, -1, -1, iEventID, null));
                                break;
                            case 0:     // Phase
                                changedList.Add(new OVRDataChanged(OVRDataChangedType.emPhaseStatus, -1, -1, iCurPhaseID, -1, iCurPhaseID, null));
                                break;
                        }
                    }
                }
                sdr.Close();

                if (changedList.Count > 0 && Module != null)
                {
                    if (Module is OVRModuleBase)
                    {
                        (Module as OVRModuleBase).DataChangedNotify(changedList);
                    }
                    else if (Module is OVRPluginBase)
                    {
                        (Module as OVRPluginBase).DataChangedNotify(changedList);
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return iResult;
        }

        /// <summary>
        /// 比赛阶段自动晋级，并通过调用函数的模块发送通知消息。


        /// </summary>
        /// <param name="iPhaseID">比赛阶段的ID</param>
        /// <param name="DataBaseConnection">数据库连接对像。</param>
        /// <param name="Module">函数调用模块，直接将OVRModuleBase或OVRPluginBase及其派生对象传入即可。</param>
        /// <returns>
        /// 返回 true 表示晋级成功。


        /// 返回 false 表示晋级失败。


        /// </returns>
        public static bool AutoProgressPhase(Int32 iPhaseID, SqlConnection DataBaseConnection, object Module)
        {
            bool bResult = false;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DataBaseConnection;
                oneSqlCommand.CommandText = "Proc_AutoProgress";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                if (DataBaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    DataBaseConnection.Open();
                }

                List<OVRDataChanged> changedList = new List<OVRDataChanged>();

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emPhaseProgress, -1, -1, iPhaseID, -1, iPhaseID, null));
                    while (sdr.Read())
                    {
                        int iType = 0;
                        int iMatchID = 0;
                        iType = GetFieldValue2Int32(ref sdr, "F_Type");
                        iMatchID = GetFieldValue2Int32(ref sdr, "F_MatchID");

                        switch (iType)
                        {
                            case 1:    // Match
                                changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCompetitor, -1, -1, -1, iMatchID, iMatchID, null));
                                break;
                        }
                    }
                    bResult = true;
                }
                sdr.Close();

                if (changedList.Count > 0 && Module != null)
                {
                    if (Module is OVRModuleBase)
                    {
                        (Module as OVRModuleBase).DataChangedNotify(changedList);
                    }
                    else if (Module is OVRPluginBase)
                    {
                        (Module as OVRPluginBase).DataChangedNotify(changedList);
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }

        /// <summary>
        /// 比赛自动晋级，并通过调用函数的模块发送通知消息。


        /// </summary>
        /// <param name="iMatchID">比赛的ID</param>
        /// <param name="DataBaseConnection">数据库连接对像。</param>
        /// <param name="Module">函数调用模块，直接将OVRModuleBase或OVRPluginBase及其派生对象传入即可。</param>
        /// <returns>
        /// 返回 true 表示晋级成功。


        /// 返回 false 表示晋级失败。


        /// </returns>
        public static bool AutoProgressMatch(Int32 iMatchID, SqlConnection DataBaseConnection, object Module)
        {
            bool bResult = false;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DataBaseConnection;
                oneSqlCommand.CommandText = "Proc_AutoProgressMatch";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                if (DataBaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    DataBaseConnection.Open();
                }

                List<OVRDataChanged> changedList = new List<OVRDataChanged>();

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchProgress, -1, -1, -1, iMatchID, iMatchID, null));
                    while (sdr.Read())
                    {
                        int iType = 0;
                        int icurMatchID = 0;
                        iType = GetFieldValue2Int32(ref sdr, "F_Type");
                        icurMatchID = GetFieldValue2Int32(ref sdr, "F_MatchID");

                        switch (iType)
                        {
                            case 1:    // Match
                                changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCompetitor, -1, -1, -1, icurMatchID, icurMatchID, null));
                                break;
                        }
                    }
                    bResult = true;
                }
                sdr.Close();

                if (changedList.Count > 0 && Module != null)
                {
                    if (Module is OVRModuleBase)
                    {
                        (Module as OVRModuleBase).DataChangedNotify(changedList);
                    }
                    else if (Module is OVRPluginBase)
                    {
                        (Module as OVRPluginBase).DataChangedNotify(changedList);
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }

        /// <summary>
        /// 比赛阶段轮空晋级，并通过调用函数的模块发送通知消息。


        /// </summary>
        /// <param name="iPhaseID">比赛阶段的ID</param>
        /// <param name="DataBaseConnection">数据库连接对像。</param>
        /// <param name="Module">函数调用模块，直接将OVRModuleBase或OVRPluginBase及其派生对象传入即可。</param>
        /// <returns>
        /// 返回 true 表示晋级成功。


        /// 返回 false 表示晋级失败。


        /// </returns>
        public static bool AutoProgressByePhase(Int32 iPhaseID, SqlConnection DataBaseConnection, object Module)
        {
            bool bResult = false;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DataBaseConnection;
                oneSqlCommand.CommandText = "Proc_ProgressByes";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                if (DataBaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    DataBaseConnection.Open();
                }

                List<OVRDataChanged> changedList = new List<OVRDataChanged>();

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emPhaseProgress, -1, -1, iPhaseID, -1, iPhaseID, null));
                    while (sdr.Read())
                    {
                        int iType = 0;
                        int iMatchID = 0;
                        iType = GetFieldValue2Int32(ref sdr, "F_Type");
                        iMatchID = GetFieldValue2Int32(ref sdr, "F_MatchID");

                        switch (iType)
                        {
                            case 1:    // Match
                                changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCompetitor, -1, -1, -1, iMatchID, iMatchID, null));
                                break;
                            case 2:    // Match
                                changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchResult, -1, -1, -1, iMatchID, iMatchID, null));
                                changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchStatus, -1, -1, -1, iMatchID, iMatchID, null));
                                break;
                        }
                    }
                    bResult = true;
                }
                sdr.Close();

                if (changedList.Count > 0 && Module != null)
                {
                    if (Module is OVRModuleBase)
                    {
                        (Module as OVRModuleBase).DataChangedNotify(changedList);
                    }
                    else if (Module is OVRPluginBase)
                    {
                        (Module as OVRPluginBase).DataChangedNotify(changedList);
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }

        /// <summary>
        /// 比赛轮空晋级，并通过调用函数的模块发送通知消息。


        /// </summary>
        /// <param name="iMatchID">比赛的ID</param>
        /// <param name="DataBaseConnection">数据库连接对像。</param>
        /// <param name="Module">函数调用模块，直接将OVRModuleBase或OVRPluginBase及其派生对象传入即可。</param>
        /// <returns>
        /// 返回 true 表示晋级成功。


        /// 返回 false 表示晋级失败。


        /// </returns>
        public static bool AutoProgressByeMatch(Int32 iMatchID, SqlConnection DataBaseConnection, object Module)
        {
            bool bResult = false;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = DataBaseConnection;
                oneSqlCommand.CommandText = "Proc_ProgressMatchBye";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                if (DataBaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    DataBaseConnection.Open();
                }

                List<OVRDataChanged> changedList = new List<OVRDataChanged>();

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchProgress, -1, -1, -1, iMatchID, iMatchID, null));
                    while (sdr.Read())
                    {
                        int iType = 0;
                        int iCurMatchID = 0;
                        iType = GetFieldValue2Int32(ref sdr, "F_Type");
                        iCurMatchID = GetFieldValue2Int32(ref sdr, "F_MatchID");

                        switch (iType)
                        {
                            case 1:    // Match
                                changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCompetitor, -1, -1, -1, iCurMatchID, iCurMatchID, null));
                                break;
                            case 2:    // Match
                                changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchResult, -1, -1, -1, iCurMatchID, iCurMatchID, null));
                                changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchStatus, -1, -1, -1, iCurMatchID, iCurMatchID, null));
                                break;
                        }
                    }
                    bResult = true;
                }
                sdr.Close();

                if (changedList.Count > 0 && Module != null)
                {
                    if (Module is OVRModuleBase)
                    {
                        (Module as OVRModuleBase).DataChangedNotify(changedList);
                    }
                    else if (Module is OVRPluginBase)
                    {
                        (Module as OVRPluginBase).DataChangedNotify(changedList);
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }
    }
}