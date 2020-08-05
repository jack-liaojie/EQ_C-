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
    public partial class EditSessionForm : UIForm
    {
        public System.Data.SqlClient.SqlConnection m_sqlCon = new SqlConnection();
        public string m_strDisciplineID = "";
        public string m_strLanguageCode = "";
        private System.Data.DataTable m_dtOldSession;
        public string m_strDate = "";
        public OVRModuleBase module = null;

        public EditSessionForm()
        {
            InitializeComponent();
        }

        private void EditSessionForm_Load(object sender, EventArgs e)
        {
            Localization();
            Init_DateCombox();
            Init_SessionGrid();
            Update_SessionGrid();
        }

        private void Init_DateCombox()
        {
            Reset_DateComBox();
        }
        private void Reset_DateComBox()
        {
            System.Data.DataTable dt = GetDateTable();

            cbEx_Date.DataSource = dt;
            cbEx_Date.ValueMember = "F_ID";
            cbEx_Date.DisplayMember = "F_Info";

            AdjustComboBoxDropDownListWidth(cbEx_Date, dt);
        }

        private void AdjustComboBoxDropDownListWidth(object comboBox, DataTable dt)
        {
            Graphics g = null;
            Font font = null;
            try
            {
                ComboBox senderComboBox = null;
                if (comboBox is ComboBox)
                    senderComboBox = (ComboBox)comboBox;
                else if (comboBox is ToolStripComboBox)
                    senderComboBox = ((ToolStripComboBox)comboBox).ComboBox;
                else
                    return;

                int width = senderComboBox.Width;
                g = senderComboBox.CreateGraphics();
                font = senderComboBox.Font;

                //checks if a scrollbar will be displayed.
                //If yes, then get its width to adjust the size of the drop down list.
                int vertScrollBarWidth =
                    (senderComboBox.Items.Count > senderComboBox.MaxDropDownItems)
                    ? SystemInformation.VerticalScrollBarWidth : 0;

                int newWidth;
                for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
                {
                    if (dt.Rows[nRow]["F_Info"] != null)
                    {
                        string strInfo = dt.Rows[nRow]["F_Info"].ToString();
                        newWidth = (int)g.MeasureString(strInfo.Trim(), font).Width + 10 + vertScrollBarWidth;
                        if (width < newWidth)
                            width = newWidth;   //set the width of the drop down list to the width of the largest item.
                    }
                }
                senderComboBox.DropDownWidth = width;
            }
            catch
            { }
            finally
            {
                if (g != null)
                    g.Dispose();
            }
        }

        private void cbEx_Date_SelectionChangeCommitted(object sender, EventArgs e)
        {
            string strDate = "";
            strDate = cbEx_Date.Text.ToString();
            if (strDate == "All")
                strDate = "";
          
            m_strDate = strDate;
            this.Update_SessionGrid();
        }

        private void btnX_Add_Click(object sender, EventArgs e)
        {
            string strDate = "";
            strDate = cbEx_Date.Text.ToString();
            if (strDate == "All")
                strDate = "";
            if (strDate.Length == 0)
                return;
            m_strDate = strDate;
           
            if (!this.AddSession(m_strDate))
            {
                string strSectionName = OVRMatchScheduleModule.GetSectionName();
                string strText = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_SessionFrom_AddFailed");
                DevComponents.DotNetBar.MessageBoxEx.Show(strText, null, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            this.Update_SessionGrid();
        }

        private void btnX_Del_Click(object sender, EventArgs e)
        {
            if (DevComponents.DotNetBar.MessageBoxEx.Show(
                  LocalizationRecourceManager.GetString(OVRMatchScheduleModule.GetSectionName(),
                      "OVRMatchSchedule_SessionFrom_DelTip"),
                      "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            DataGridViewSelectedRowCollection l_Rows = this.dgv_Session.SelectedRows;
            foreach (DataGridViewRow r in l_Rows)
            {
                int nRow = r.Index;
                if (!this.DelSession(this.dgv_Session.Rows[nRow].Cells["F_SessionID"].Value.ToString()))
                {
                    string strSectionName = OVRMatchScheduleModule.GetSectionName();
                    string strText = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_SessionFrom_DelFailed");
                    DevComponents.DotNetBar.MessageBoxEx.Show(strText, null, MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
            }
            this.Update_SessionGrid();
        }

        private void Localization()
        {
            string strSectionName = OVRMatchScheduleModule.GetSectionName();
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_SessionFrom_txtTitle");
            this.btnX_Add.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_SessionFrom_btnXAdd");
            this.btnX_Del.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_SessionFrom_btnXDel");
        }

        private System.Data.DataTable GetDateTable()
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            dtRet.Rows.Add("All", "All");

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

                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    string strID = dt.Rows[r]["F_DisciplineDateID"].ToString();
                    string strInfo = dt.Rows[r]["Date"].ToString();

                    dtRet.Rows.Add(strID, strInfo);
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dtRet;
        }

        private System.Data.DataTable GetSessionTable(string strDate)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = m_sqlCon;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetSessions", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                if (strDate.Length == 0)
                    cmd.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@DateTime", DataRowVersion.Current, DBNull.Value));
                else
                    cmd.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@DateTime", DataRowVersion.Current, strDate));
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

        private System.Data.DataTable GetTypeItemTable()
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            dtRet.Rows.Add("-1", "");

            try
            {
                System.Data.SqlClient.SqlConnection con = m_sqlCon;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetSessionTypes", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strLanguageCode));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);

                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    string strID = dt.Rows[r]["F_SessionTypeID"].ToString();
                    string strInfo = dt.Rows[r]["F_SessionTypeLongName"].ToString();

                    dtRet.Rows.Add(strID, strInfo);
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dtRet;
        }


        private void Init_SessionGrid()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgv_Session);
        }

        private void Update_SessionGrid()
        {
            System.Data.DataTable dt = GetSessionTable(m_strDate);

            m_dtOldSession = new DataTable();
            for (int nColIndex = 0; nColIndex < dt.Columns.Count; nColIndex++)
            {
                m_dtOldSession.Columns.Add(dt.Columns[nColIndex].ColumnName, dt.Columns[nColIndex].DataType);
            }
            m_dtOldSession.Rows.Add();

            this.dgv_Session.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.DisplayedCells;
            OVRDataBaseUtils.FillDataGridViewWithCmb(this.dgv_Session, dt, "Type");

            if (this.dgv_Session.Columns["F_DisciplineID"] != null)
                this.dgv_Session.Columns["F_DisciplineID"].Visible = false;
            if (this.dgv_Session.Columns["F_SessionID"] != null)
                this.dgv_Session.Columns["F_SessionID"].Visible = false;
            if (this.dgv_Session.Columns["F_SessionTypeID"] != null)
                this.dgv_Session.Columns["F_SessionTypeID"].Visible = false;

            if (this.dgv_Session.Columns["Number"] != null)
                this.dgv_Session.Columns["Number"].ReadOnly = false;
            if (this.dgv_Session.Columns["StartTime"] != null)
                this.dgv_Session.Columns["StartTime"].ReadOnly = false;
            if (this.dgv_Session.Columns["EndTime"] != null)
                this.dgv_Session.Columns["EndTime"].ReadOnly = false;
            if (this.dgv_Session.Columns["Type"] != null)
                this.dgv_Session.Columns["Type"].ReadOnly = false;
        }

        bool AddSession(string strDate)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_sqlCon;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_AddSession", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                cmd.Parameters.Add(new SqlParameter("@SessionDate", SqlDbType.Char, 10, ParameterDirection.Input, true, 0, 0, "@SessionDate", DataRowVersion.Current, strDate));
                cmd.Parameters.Add(new SqlParameter("@SessionNumber", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SessionNumber", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@SessionTime", SqlDbType.Char, 10, ParameterDirection.Input, true, 0, 0, "@SessionTime", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@SessionEndTime", SqlDbType.Char, 10, ParameterDirection.Input, true, 0, 0, "@SessionEndTime", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@SeesionTypeID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SeesionTypeID", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                {
                    if (module != null)
                    {
                        int iDisciplineID = Convert.ToInt32(m_strDisciplineID);
                        int iSessionID = Convert.ToInt32(cmdParameterResult.Value);
                        module.DataChangedNotify(OVRDataChangedType.emSessionAdd, iDisciplineID, -1, -1, -1, iSessionID, null);
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

        bool UpdateSession(string strSessionID, string strDate, string strNumber, string strTypeID, string strTime, string strEndTime)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_sqlCon;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_EditSession", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@SessionID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SessionID", DataRowVersion.Current, strSessionID));
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                if (strDate.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@SessionDate", SqlDbType.Char, 10, ParameterDirection.Input, true, 0, 0, "@SessionDate", DataRowVersion.Current, strDate));
                else
                    cmd.Parameters.Add(new SqlParameter("@SessionDate", SqlDbType.Char, 10, ParameterDirection.Input, true, 0, 0, "@SessionDate", DataRowVersion.Current, DBNull.Value));
                if (strNumber.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@SessionNumber", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SessionNumber", DataRowVersion.Current, strNumber));
                else
                    cmd.Parameters.Add(new SqlParameter("@SessionNumber", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SessionNumber", DataRowVersion.Current, DBNull.Value));
                if (strTime.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@SessionTime", SqlDbType.Char, 10, ParameterDirection.Input, true, 0, 0, "@SessionTime", DataRowVersion.Current, strTime));
                else
                    cmd.Parameters.Add(new SqlParameter("@SessionTime", SqlDbType.Char, 10, ParameterDirection.Input, true, 0, 0, "@SessionTime", DataRowVersion.Current, DBNull.Value));
                if (strEndTime.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@SessionEndTime", SqlDbType.Char, 10, ParameterDirection.Input, true, 0, 0, "@SessionEndTime", DataRowVersion.Current, strEndTime));
                else
                    cmd.Parameters.Add(new SqlParameter("@SessionEndTime", SqlDbType.Char, 10, ParameterDirection.Input, true, 0, 0, "@SessionEndTime", DataRowVersion.Current, DBNull.Value));
                if (strTypeID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@SeesionTypeID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SeesionTypeID", DataRowVersion.Current, strTypeID));
                else
                    cmd.Parameters.Add(new SqlParameter("@SeesionTypeID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SeesionTypeID", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                {
                    if (module != null)
                    {
                        int iDisciplineID = Convert.ToInt32(m_strDisciplineID);
                        int iSessionID = Convert.ToInt32(strSessionID);
                        module.DataChangedNotify(OVRDataChangedType.emSessionInfo, iDisciplineID, -1, -1, -1, iSessionID, null);
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

        bool DelSession(string strSessionID)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_sqlCon;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_DelSession", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@SessionID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SessionID", DataRowVersion.Current, strSessionID));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                {
                    if (module != null)
                    {
                        int iDisciplineID = Convert.ToInt32(m_strDisciplineID);
                        int iSessionID = Convert.ToInt32(strSessionID);
                        module.DataChangedNotify(OVRDataChangedType.emSessionDel, iDisciplineID, -1, -1, -1, iSessionID, null);
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
    }
}
