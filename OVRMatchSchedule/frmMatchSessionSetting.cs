using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Diagnostics;
using AutoSports.OVRCommon;
using DevComponents.DotNetBar;
using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    public partial class MatchSessionSettingForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }
        public string m_strDisciplineID = "";
        public string m_strLanguageCode = "";
        public string m_strDate = "";
        public string m_strSession = "";
        public string m_strSessionID = "";

        public MatchSessionSettingForm(string strName)
        {
            InitializeComponent();
            this.Name = strName;
            Localization();
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchSessionForm");
            labX_Date.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchSessionForm_labXDate");
            labX_Session.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchSessionForm_labXSession");
        }

        private void MatchSessionSettingForm_Load(object sender, EventArgs e)
        {
            Init_DateCombox();
            Init_SessionComBox("");
        }

        private void Init_DateCombox()
        {
            System.Data.DataTable dt = GetDateItemTable();
            this.cbEx_Date.DataSource = dt;
            cbEx_Date.ValueMember = "F_ID";
            cbEx_Date.DisplayMember = "F_Info";

            AdjustComboBoxDropDownListWidth(cbEx_Date, dt);
        }
        private System.Data.DataTable GetDateItemTable()
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            dtRet.Rows.Add("-1", "");

            try
            {
                System.Data.SqlClient.SqlConnection con = sqlConnection;
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

        private void Init_SessionComBox(string strDate)
        {
            System.Data.DataTable dt = GetSessionItemTable(strDate);

            cbEx_Session.DataSource = dt;
            cbEx_Session.ValueMember = "F_ID";
            cbEx_Session.DisplayMember = "F_Info";

            AdjustComboBoxDropDownListWidth(cbEx_Session, dt);
        }
        private System.Data.DataTable GetSessionItemTable(string strDate)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            dtRet.Rows.Add("-1", "");

            try
            {
                if (strDate.Length != 0)
                {
                    System.Data.SqlClient.SqlConnection con = sqlConnection;
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

                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    string strID = dt.Rows[r]["F_SessionID"].ToString();
                    string strInfo = "";
                    strInfo += "S." + dt.Rows[r]["Number"].ToString();
                    if (!Convert.IsDBNull(dt.Rows[r]["StartTime"]))
                        strInfo += " " + Convert.ToDateTime(dt.Rows[r]["StartTime"]).ToString("HH:mm");

                    dtRet.Rows.Add(strID, strInfo);
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dtRet;
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

            m_strDate = strDate;
            this.Init_SessionComBox(strDate);
        }

        private void cbEx_Session_SelectionChangeCommitted(object sender, EventArgs e)
        {
            string strData = "";
            strData = cbEx_Session.SelectedValue.ToString();
            if (strData == "-1")
                strData = "";

            m_strSessionID = strData;
            m_strSession = cbEx_Session.Text.ToString();
        }

        private void btnX_OK_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void btnX_Cancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
