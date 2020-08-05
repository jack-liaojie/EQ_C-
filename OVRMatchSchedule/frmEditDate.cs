using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Collections;

using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    public partial class EditDateForm : UIForm
    {
        public System.Data.SqlClient.SqlConnection m_sqlCon = new SqlConnection();
        public string m_strDisciplineID = "";
        public string m_strLanguageCode = "";
        public OVRModuleBase module = null;
        private System.Data.DataTable m_dtOldDate;

        public EditDateForm()
        {
            InitializeComponent();
        }

        private void EditDateForm_Load(object sender, EventArgs e)
        {
            Localization();
            Init_DateGrid();
            Update_DateGrid();
        }

        private void btnX_Add_Click(object sender, EventArgs e)
        {
            string strDate = dateTimeInput1.Value.ToString("yyyy-MM-dd");
            if (strDate == "0001-01-01")
                strDate = "";

            if (strDate.Length == 0)
                return;

            int nReturn = this.AddDate(strDate);
            if (nReturn == 0)
            {
                string strSectionName = OVRMatchScheduleModule.GetSectionName();
                string strText = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_DateFrom_AddFailed");
                DevComponents.DotNetBar.MessageBoxEx.Show(strText, null, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            else if (nReturn == -1)
            {
                string strSectionName = OVRMatchScheduleModule.GetSectionName();
                string strText = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_DateFrom_AddFailed_F1");
                DevComponents.DotNetBar.MessageBoxEx.Show(strText, null, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            this.Update_DateGrid();
        }

        private void btnX_Del_Click(object sender, EventArgs e)
        {
            if (DevComponents.DotNetBar.MessageBoxEx.Show(
                  LocalizationRecourceManager.GetString(OVRMatchScheduleModule.GetSectionName(),
                      "OVRMatchSchedule_DateFrom_DelTip"),
                      "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            DataGridViewSelectedRowCollection l_Rows = this.dgv_Date.SelectedRows;
            foreach (DataGridViewRow r in l_Rows)
            {
                int nRow = r.Index;
                int nReturn = this.DelDate(this.dgv_Date.Rows[nRow].Cells["F_DisciplineDateID"].Value.ToString());
                if (nReturn == 0)
                {
                    string strSectionName = OVRMatchScheduleModule.GetSectionName();
                    string strText = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_DateFrom_DelFailed");
                    DevComponents.DotNetBar.MessageBoxEx.Show(strText, null, MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                else if (nReturn == -2)
                {
                    string strSectionName = OVRMatchScheduleModule.GetSectionName();
                    string strText = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_DateFrom_DelFailed_F2");
                    DevComponents.DotNetBar.MessageBoxEx.Show(strText, null, MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
            }
            this.Update_DateGrid();
        }

        private void Localization()
        {
            string strSectionName = OVRMatchScheduleModule.GetSectionName();
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_DateFrom_txtTitle");
            this.btnX_Add.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_DateFrom_btnXAdd");
            this.btnX_Del.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_DateFrom_btnXDel");
        }


        private System.Data.DataTable GetDateTable()
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = m_sqlCon;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetDisciplineDates", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strLanguageCode));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            
            return dt;
        }


        private void Init_DateGrid()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgv_Date);
        }

        private void Update_DateGrid()
        {
            System.Data.DataTable dt = GetDateTable();

            m_dtOldDate = new DataTable();
            for (int nColIndex = 0; nColIndex < dt.Columns.Count; nColIndex++)
            {
                m_dtOldDate.Columns.Add(dt.Columns[nColIndex].ColumnName, dt.Columns[nColIndex].DataType);
            }
            m_dtOldDate.Rows.Add();

            this.dgv_Date.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.DisplayedCells;
            OVRDataBaseUtils.FillDataGridViewWithCmb(this.dgv_Date, dt, 0);

            if (this.dgv_Date.Columns["F_DisciplineDateID"] != null)
                this.dgv_Date.Columns["F_DisciplineDateID"].Visible = false;

            if (this.dgv_Date.Columns["Order"] != null)
                this.dgv_Date.Columns["Order"].ReadOnly = false;
            if (this.dgv_Date.Columns["Date"] != null)
                this.dgv_Date.Columns["Date"].ReadOnly = true;
            if (this.dgv_Date.Columns["Long Description"] != null)
                this.dgv_Date.Columns["Long Description"].ReadOnly = false;
            if (this.dgv_Date.Columns["Short Description"] != null)
                this.dgv_Date.Columns["Short Description"].ReadOnly = false;
            if (this.dgv_Date.Columns["Comment"] != null)
                this.dgv_Date.Columns["Comment"].ReadOnly = false;
        }

        int AddDate(string strDate)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_sqlCon;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_AddDisciplineDate", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                cmd.Parameters.Add(new SqlParameter("@DateOrder", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DateOrder", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@Date", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@Date", DataRowVersion.Current, strDate));
                cmd.Parameters.Add(new SqlParameter("@DateLongDescription", SqlDbType.NVarChar, 100, ParameterDirection.Input, true, 0, 0, "@DateLongDescription", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@DateShortDescription", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@DateShortDescription", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@DateComment", SqlDbType.NVarChar, 100, ParameterDirection.Input, true, 0, 0, "@DateComment", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strLanguageCode));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                {
                    if (module != null)
                    {
                        int iDisciplineID = Convert.ToInt32(m_strDisciplineID);
                        int iDateID = Convert.ToInt32(cmdParameterResult.Value);
                        module.DataChangedNotify(OVRDataChangedType.emDateAdd, iDisciplineID, -1, -1, -1, iDateID, null);
                    }
                }
                return int.Parse(cmdParameterResult.Value.ToString());
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return 0;
            }
        }

        bool UpdateDate(string strDateID, string strOrder, string strDate, string strLongName, string strShortName, string strComment)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_sqlCon;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_EditDisciplineDate", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineDateID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineDateID", DataRowVersion.Current, strDateID));
                if (strOrder.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@DateOrder", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DateOrder", DataRowVersion.Current, strOrder));
                else
                    cmd.Parameters.Add(new SqlParameter("@DateOrder", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DateOrder", DataRowVersion.Current, DBNull.Value));
                if (strDate.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Date", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@Date", DataRowVersion.Current, strDate));
                else
                    cmd.Parameters.Add(new SqlParameter("@Date", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@Date", DataRowVersion.Current, DBNull.Value));
                if (strLongName.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@DateLongDescription", SqlDbType.NVarChar, 100, ParameterDirection.Input, true, 0, 0, "@DateLongDescription", DataRowVersion.Current, strLongName));
                else
                    cmd.Parameters.Add(new SqlParameter("@DateLongDescription", SqlDbType.NVarChar, 100, ParameterDirection.Input, true, 0, 0, "@DateLongDescription", DataRowVersion.Current, DBNull.Value));
                if (strShortName.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@DateShortDescription", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@DateShortDescription", DataRowVersion.Current, strShortName));
                else
                    cmd.Parameters.Add(new SqlParameter("@DateShortDescription", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@DateShortDescription", DataRowVersion.Current, DBNull.Value));
                if (strComment.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@DateComment", SqlDbType.NVarChar, 100, ParameterDirection.Input, true, 0, 0, "@DateComment", DataRowVersion.Current, strComment));
                else
                    cmd.Parameters.Add(new SqlParameter("@DateComment", SqlDbType.NVarChar, 100, ParameterDirection.Input, true, 0, 0, "@DateComment", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strLanguageCode));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                {
                    if (module != null)
                    {
                        int iDisciplineID = Convert.ToInt32(m_strDisciplineID);
                        int iDateID = Convert.ToInt32(strDateID);
                        module.DataChangedNotify(OVRDataChangedType.emDateInfo, iDisciplineID, -1, -1, -1, iDateID, null);
                    }
                    return true;
                }
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        int DelDate(string strDateID)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_sqlCon;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_DelDisciplineDate", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineDateID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineDateID", DataRowVersion.Current, strDateID));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                {
                    if (module != null)
                    {
                        int iDisciplineID = Convert.ToInt32(m_strDisciplineID);
                        int iDateID = Convert.ToInt32(strDateID);
                        module.DataChangedNotify(OVRDataChangedType.emDateDel, iDisciplineID, -1, -1, -1, iDateID, null);
                    }
                }
                return int.Parse(cmdParameterResult.Value.ToString());
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return 0;
            }
        }
    }
}
