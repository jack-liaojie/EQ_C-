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
    public partial class MatchCourtSettingForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }
        public string m_strDisciplineID = "";
        public string m_strLanguageCode = "";
        public string m_strVenueID = "";
        public string m_strVenue = "";
        public string m_strCourtID = "";
        public string m_strCourt = "";

        public MatchCourtSettingForm(string strName)
        {
            InitializeComponent();
            this.Name = strName;
            Localization();
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCourtForm");
            labX_Venue.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCourtForm_labXVenue");
            labX_Court.Text = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCourtForm_labXCourt");
            btnX_OK.Tooltip = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCourtForm_btnXOK");
            btnX_Cancel.Tooltip = LocalizationRecourceManager.GetString(this.Name, "OVRMatchSchedule_MatchCourtForm_btnXCancel");
        }

        private void MatchCourtSettingForm_Load(object sender, EventArgs e)
        {
            Init_VenueCombox();
            Init_CourtCombox("");
        }

        private void Init_VenueCombox()
        {
            System.Data.DataTable dt = GetVenueItemTable();
            this.cbEx_Venue.DataSource = dt;
            cbEx_Venue.ValueMember = "F_ID";
            cbEx_Venue.DisplayMember = "F_Info";

            AdjustComboBoxDropDownListWidth(cbEx_Venue, dt);
        }

        private System.Data.DataTable GetVenueItemTable()
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

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetVenues", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strLanguageCode));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);

                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    string strID = dt.Rows[r]["F_VenueID"].ToString();
                    string strInfo = dt.Rows[r]["F_VenueLongName"].ToString();

                    dtRet.Rows.Add(strID, strInfo);
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dtRet;
        }

        private void Init_CourtCombox(string strVenueID)
        {
            System.Data.DataTable dt = GetCourtItemTable(strVenueID);
            this.cbEx_Court.DataSource = dt;
            cbEx_Court.ValueMember = "F_ID";
            cbEx_Court.DisplayMember = "F_Info";

            AdjustComboBoxDropDownListWidth(cbEx_Court, dt);
        }

        private System.Data.DataTable GetCourtItemTable(string strVenueID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            dtRet.Rows.Add("-1", "");

            try
            {
                if (strVenueID.Length != 0)
                {
                    System.Data.SqlClient.SqlConnection con = sqlConnection;
                    if (con.State != ConnectionState.Open)
                        con.Open();

                    SqlCommand cmd = new SqlCommand("Proc_Schedule_GetCourts", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strLanguageCode));
                    cmd.Parameters.Add(new SqlParameter("@VenueID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@VenueID", DataRowVersion.Current, strVenueID));
                    cmd.UpdatedRowSource = UpdateRowSource.None;
                    da.SelectCommand = cmd;

                    dt.Clear();
                    da.Fill(dt);
                }

                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    string strID = dt.Rows[r]["F_CourtID"].ToString();
                    string strInfo = dt.Rows[r]["F_CourtLongName"].ToString();

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

        private void cbEx_Venue_SelectionChangeCommitted(object sender, EventArgs e)
        {
            string strData = "";
            strData = cbEx_Venue.SelectedValue.ToString();
            if (strData == "-1")
                strData = "";

            m_strVenueID = strData;
            m_strVenue = cbEx_Venue.Text.ToString();
            this.Init_CourtCombox(strData);
        }

        private void cbEx_Court_SelectionChangeCommitted(object sender, EventArgs e)
        {
            string strData = "";
            strData = cbEx_Court.SelectedValue.ToString();
            if (strData == "-1")
                strData = "";

            m_strCourtID = strData;
            m_strCourt = cbEx_Court.Text.ToString();
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
