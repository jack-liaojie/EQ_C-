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
    public partial class EditRoundForm : UIForm
    {
        public System.Data.SqlClient.SqlConnection m_sqlCon = new SqlConnection();
        public string m_strDisciplineID = "";
        public string m_strLanguageCode = "";
        private System.Data.DataTable m_dtOldRound;
        public string m_strEventID = "";

        public EditRoundForm()
        {
            InitializeComponent();
        }

        private void EditRoundForm_Load(object sender, EventArgs e)
        {
            Localization();
            Init_EventCombox();
            Init_RoundGrid();
            Update_RoundGrid();
        }

        private void Init_EventCombox()
        {
            Reset_EventComBox();
        }
        private void Reset_EventComBox()
        {
            System.Data.DataTable dt = GetEventTable();

            cbEx_Event.DataSource = dt;
            cbEx_Event.ValueMember = "F_ID";
            cbEx_Event.DisplayMember = "F_Info";

            AdjustComboBoxDropDownListWidth(cbEx_Event, dt);
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


        private void comboBoxEx1_SelectionChangeCommitted(object sender, EventArgs e)
        {
            string strEventID = cbEx_Event.SelectedValue.ToString();
            if (strEventID == "All")
                strEventID = "";
            m_strEventID = strEventID;
            this.Update_RoundGrid();
        }

        private void btnX_Add_Click(object sender, EventArgs e)
        {
            string strEventID = cbEx_Event.SelectedValue.ToString();
            if (strEventID == "All")
                strEventID = "";
            if (strEventID.Length == 0)
                return;

            m_strEventID = strEventID;
            if( !this.AddRound(m_strEventID) )
            {
                string strSectionName = OVRMatchScheduleModule.GetSectionName();
                string strText = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_RoundFrom_AddFailed");
                DevComponents.DotNetBar.MessageBoxEx.Show(strText, null, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            this.Update_RoundGrid();
        }

        private void btnX_Del_Click(object sender, EventArgs e)
        {
            if (DevComponents.DotNetBar.MessageBoxEx.Show(
                  LocalizationRecourceManager.GetString(OVRMatchScheduleModule.GetSectionName(),
                      "OVRMatchSchedule_RoundFrom_DelTip"),
                      "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            DataGridViewSelectedRowCollection l_Rows = this.dgv_Round.SelectedRows;
            foreach (DataGridViewRow r in l_Rows)
            {
                int nRow = r.Index;
                if( !this.DelRound(this.dgv_Round.Rows[nRow].Cells["F_RoundID"].Value.ToString()) )
                {
                    string strSectionName = OVRMatchScheduleModule.GetSectionName();
                    string strText = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_RoundFrom_DelFailed");
                    DevComponents.DotNetBar.MessageBoxEx.Show(strText, null, MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
            }
            this.Update_RoundGrid();
        }

        private void Localization()
        {
            string strSectionName = OVRMatchScheduleModule.GetSectionName();
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_RoundFrom_txtTitle");
            this.btnX_Add.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_RoundFrom_btnXAdd");
            this.btnX_Del.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchSchedule_RoundFrom_btnXDel");
        }

        private System.Data.DataTable GetEventTable()
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

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetEvents", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strLanguageCode));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);

                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    string strID = dt.Rows[r]["F_EventID"].ToString();
                    string strInfo = dt.Rows[r]["F_EventLongName"].ToString();

                    dtRet.Rows.Add(strID, strInfo);
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dtRet;
        }

        private System.Data.DataTable GetRoundTable(string strEventID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = m_sqlCon;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetRounds", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                if (strEventID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EventID", DataRowVersion.Current, strEventID));
                else
                    cmd.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EventID", DataRowVersion.Current, DBNull.Value));
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


        private void Init_RoundGrid()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgv_Round);
        }

        private void Update_RoundGrid()
        {
            System.Data.DataTable dt = GetRoundTable(m_strEventID);

            m_dtOldRound = new DataTable();
            for (int nColIndex = 0; nColIndex < dt.Columns.Count; nColIndex++)
            {
                m_dtOldRound.Columns.Add(dt.Columns[nColIndex].ColumnName, dt.Columns[nColIndex].DataType);
            }
            m_dtOldRound.Rows.Add();

            this.dgv_Round.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.DisplayedCells;
            OVRDataBaseUtils.FillDataGridViewWithCmb(this.dgv_Round, dt, 0);

            if (this.dgv_Round.Columns["F_EventID"] != null)
                this.dgv_Round.Columns["F_EventID"].Visible = false;
            if (this.dgv_Round.Columns["F_RoundID"] != null)
                this.dgv_Round.Columns["F_RoundID"].Visible = false;

            if (this.dgv_Round.Columns["Order"] != null)
                this.dgv_Round.Columns["Order"].ReadOnly = false;
            if (this.dgv_Round.Columns["Code"] != null)
                this.dgv_Round.Columns["Code"].ReadOnly = false;
            if (this.dgv_Round.Columns["LongName"] != null)
                this.dgv_Round.Columns["LongName"].ReadOnly = false;
            if (this.dgv_Round.Columns["ShortName"] != null)
                this.dgv_Round.Columns["ShortName"].ReadOnly = false;
            if (this.dgv_Round.Columns["Comment"] != null)
                this.dgv_Round.Columns["Comment"].ReadOnly = false;
        }

        bool AddRound(string strEventID)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_sqlCon;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_AddRound", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EventID", DataRowVersion.Current, strEventID));
                cmd.Parameters.Add(new SqlParameter("@Order", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Order", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@RoundCode", SqlDbType.NVarChar, 20, ParameterDirection.Input, true, 0, 0, "@RoundCode", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@Comment", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@Comment", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@languageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@languageCode", DataRowVersion.Current, m_strLanguageCode));
                cmd.Parameters.Add(new SqlParameter("@RoundLongName", SqlDbType.NVarChar, 100, ParameterDirection.Input, true, 0, 0, "@RoundLongName", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@RoundShortName", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@RoundShortName", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        bool UpdateRound(string strRoundID, string strEventID, string strOrder, string strCode, string strComment, string strLongName, string strShortName)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_sqlCon;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_EditRound", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@RoundID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RoundID", DataRowVersion.Current, strRoundID));
                cmd.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EventID", DataRowVersion.Current, strEventID));
                if (strOrder.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Order", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Order", DataRowVersion.Current, strOrder));
                else
                    cmd.Parameters.Add(new SqlParameter("@Order", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Order", DataRowVersion.Current, DBNull.Value));


                if (strCode.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@RoundCode", SqlDbType.NVarChar, 100, ParameterDirection.Input, true, 0, 0, "@RoundCode", DataRowVersion.Current, strCode));
                else
                    cmd.Parameters.Add(new SqlParameter("@RoundCode", SqlDbType.NVarChar, 100, ParameterDirection.Input, true, 0, 0, "@RoundCode", DataRowVersion.Current, DBNull.Value));

                if (strComment.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Comment", SqlDbType.NVarChar, 100, ParameterDirection.Input, true, 0, 0, "@Comment", DataRowVersion.Current, strComment));
                else
                    cmd.Parameters.Add(new SqlParameter("@Comment", SqlDbType.NVarChar, 100, ParameterDirection.Input, true, 0, 0, "@Comment", DataRowVersion.Current, DBNull.Value));

                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strLanguageCode));
                if (strLongName.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@RoundLongName", SqlDbType.NVarChar, 100, ParameterDirection.Input, true, 0, 0, "@RoundLongName", DataRowVersion.Current, strLongName));
                else
                    cmd.Parameters.Add(new SqlParameter("@RoundLongName", SqlDbType.NVarChar, 100, ParameterDirection.Input, true, 0, 0, "@RoundLongName", DataRowVersion.Current, DBNull.Value));
                if (strShortName.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@RoundShortName", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@RoundShortName", DataRowVersion.Current, strShortName));
                else
                    cmd.Parameters.Add(new SqlParameter("@RoundShortName", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@RoundShortName", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }
        }

        bool DelRound(string strRoundID)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_sqlCon;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_DelRound", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@RoundID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RoundID", DataRowVersion.Current, strRoundID));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
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
