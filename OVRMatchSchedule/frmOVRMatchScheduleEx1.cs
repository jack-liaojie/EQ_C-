using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Collections;

using AutoSports.OVRCommon;

namespace AutoSports.OVRMatchSchedule
{
    public partial class OVRMatchScheduleForm
    {
        private System.Data.DataTable GetInitUnScheduledDataTable()
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetUnScheduledMatches", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@TypeID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@TypeID", DataRowVersion.Current, "-1"));
                cmd.Parameters.Add(new SqlParameter("@Type", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Type", DataRowVersion.Current, "-3"));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
                cmd.Parameters.Add(new SqlParameter("@SessionID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SessionID", DataRowVersion.Current, "-1"));
                cmd.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.Char, 50, ParameterDirection.Input, true, 0, 0, "@DateTime", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@VenueID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@VenueID", DataRowVersion.Current, "-1"));
                cmd.Parameters.Add(new SqlParameter("@CourtID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CourtID", DataRowVersion.Current, "-1"));
                cmd.Parameters.Add(new SqlParameter("@RoundID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RoundID", DataRowVersion.Current, "-1"));
                cmd.Parameters.Add(new SqlParameter("@StatusID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@StatusID", DataRowVersion.Current, "-1"));
                cmd.Parameters.Add(new SqlParameter("@IsCheckedStatus", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@IsCheckedStatus", DataRowVersion.Current, m_IsChecked));
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

        private System.Data.DataTable GetUnScheduledDataTable()
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetUnScheduledMatches", con);
                cmd.CommandType = CommandType.StoredProcedure;

                string strTypeID = "";
                if (m_strTreeType == "-2")
                    strTypeID = m_strDisciplineID;
                else if (m_strTreeType == "-1")
                    strTypeID = m_strTreeEventID;
                else if (m_strTreeType == "0")
                    strTypeID = m_strTreePhaseID;
                else if (m_strTreeType == "1")
                    strTypeID = m_strTreeMatchID;

                if (strTypeID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@TypeID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@TypeID", DataRowVersion.Current, strTypeID));
                else
                    cmd.Parameters.Add(new SqlParameter("@TypeID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@TypeID", DataRowVersion.Current, DBNull.Value));
                if (m_strTreeType.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Type", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Type", DataRowVersion.Current, m_strTreeType));
                else
                    cmd.Parameters.Add(new SqlParameter("@Type", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Type", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
                if (m_strSessionID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@SessionID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SessionID", DataRowVersion.Current, m_strSessionID));
                else
                    cmd.Parameters.Add(new SqlParameter("@SessionID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SessionID", DataRowVersion.Current, DBNull.Value));
                if (m_strDate.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.Char, 50, ParameterDirection.Input, true, 0, 0, "@DateTime", DataRowVersion.Current, m_strDate));
                else
                    cmd.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.Char, 50, ParameterDirection.Input, true, 0, 0, "@DateTime", DataRowVersion.Current, DBNull.Value));
                if (m_strVenueID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@VenueID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@VenueID", DataRowVersion.Current, m_strVenueID));
                else
                    cmd.Parameters.Add(new SqlParameter("@VenueID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@VenueID", DataRowVersion.Current, DBNull.Value));
                if (m_strCourtID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@CourtID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CourtID", DataRowVersion.Current, m_strCourtID));
                else
                    cmd.Parameters.Add(new SqlParameter("@CourtID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CourtID", DataRowVersion.Current, DBNull.Value));
                if (m_strRoundID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@RoundID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RoundID", DataRowVersion.Current, m_strRoundID));
                else
                    cmd.Parameters.Add(new SqlParameter("@RoundID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RoundID", DataRowVersion.Current, DBNull.Value));
                if (m_strStatusID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@StatusID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@StatusID", DataRowVersion.Current, m_strStatusID));
                else
                    cmd.Parameters.Add(new SqlParameter("@StatusID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@StatusID", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@IsCheckedStatus", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@IsCheckedStatus", DataRowVersion.Current, m_IsChecked));
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

        private System.Data.DataTable GetInitScheduledDataTable()
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetScheduledMatches", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, "-1"));
                cmd.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EventID", DataRowVersion.Current, "-1"));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
                cmd.Parameters.Add(new SqlParameter("@SessionID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SessionID", DataRowVersion.Current, "-1"));
                cmd.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.Char, 50, ParameterDirection.Input, true, 0, 0, "@DateTime", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@VenueID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@VenueID", DataRowVersion.Current, "-1"));
                cmd.Parameters.Add(new SqlParameter("@CourtID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CourtID", DataRowVersion.Current, "-1"));
                cmd.Parameters.Add(new SqlParameter("@RoundID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RoundID", DataRowVersion.Current, "-1"));
                cmd.Parameters.Add(new SqlParameter("@StatusID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@StatusID", DataRowVersion.Current, "-1"));
                cmd.Parameters.Add(new SqlParameter("@IsCheckedStatus", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@IsCheckedStatus", DataRowVersion.Current, m_IsChecked));
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

        private System.Data.DataTable GetScheduledDataTable()
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetScheduledMatches", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                if (m_strEventID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EventID", DataRowVersion.Current, m_strEventID));
                else
                    cmd.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EventID", DataRowVersion.Current, DBNull.Value));
                if (m_strPhaseID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@PhaseID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@PhaseID", DataRowVersion.Current, m_strPhaseID));
                else
                    cmd.Parameters.Add(new SqlParameter("@PhaseID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@PhaseID", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
                if (m_strSessionID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@SessionID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SessionID", DataRowVersion.Current, m_strSessionID));
                else
                    cmd.Parameters.Add(new SqlParameter("@SessionID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SessionID", DataRowVersion.Current, DBNull.Value));
                if (m_strDate.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.Char, 50, ParameterDirection.Input, true, 0, 0, "@DateTime", DataRowVersion.Current, m_strDate));
                else
                    cmd.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.Char, 50, ParameterDirection.Input, true, 0, 0, "@DateTime", DataRowVersion.Current, DBNull.Value));
                if (m_strVenueID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@VenueID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@VenueID", DataRowVersion.Current, m_strVenueID));
                else
                    cmd.Parameters.Add(new SqlParameter("@VenueID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@VenueID", DataRowVersion.Current, DBNull.Value));
                if (m_strCourtID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@CourtID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CourtID", DataRowVersion.Current, m_strCourtID));
                else
                    cmd.Parameters.Add(new SqlParameter("@CourtID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CourtID", DataRowVersion.Current, DBNull.Value));
                if (m_strRoundID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@RoundID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RoundID", DataRowVersion.Current, m_strRoundID));
                else
                    cmd.Parameters.Add(new SqlParameter("@RoundID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RoundID", DataRowVersion.Current, DBNull.Value));
                if (m_strStatusID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@StatusID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@StatusID", DataRowVersion.Current, m_strStatusID));
                else
                    cmd.Parameters.Add(new SqlParameter("@StatusID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@StatusID", DataRowVersion.Current, DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@IsCheckedStatus", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@IsCheckedStatus", DataRowVersion.Current, m_IsChecked));
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


        private System.Data.DataTable GetDateTable()
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            dtRet.Rows.Add("-1", "Invalid");
            
            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetDisciplineDates", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
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
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            dtRet.Rows.Add("-1", "Invalid");

            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetSessions", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                if (strDate.Length == 0)
                    cmd.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@DateTime", DataRowVersion.Current, DBNull.Value));
                else
                    cmd.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@DateTime", DataRowVersion.Current, strDate));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);

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

        private System.Data.DataTable GetVenueTable()
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            dtRet.Rows.Add("-1", "Invalid");

            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetVenues", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
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

        private System.Data.DataTable GetCourtTable(string strVenueID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            dtRet.Rows.Add("-1", "Invalid");

            try
            {
                if (strVenueID.Length != 0)
                {
                    System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                    if (con.State != ConnectionState.Open)
                        con.Open();

                    SqlCommand cmd = new SqlCommand("Proc_Schedule_GetCourts", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
                    cmd.Parameters.Add(new SqlParameter("@VenueID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@VenueID", DataRowVersion.Current, strVenueID));
                    cmd.UpdatedRowSource = UpdateRowSource.None;
                    da.SelectCommand = cmd;

                    dt.Clear();
                    da.Fill(dt);
                }

                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    string strID = dt.Rows[r]["F_CourtID"].ToString();
                    string strInfo = dt.Rows[r]["F_CourtShortName"].ToString();

                    dtRet.Rows.Add(strID, strInfo);
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dtRet;
        }

        private System.Data.DataTable GetEventTable()
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            dtRet.Rows.Add("-1", "Invalid");

            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetEvents", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
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

        private System.Data.DataTable GetPhaseTable(string strEventID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            dtRet.Rows.Add("-1", "Invalid");

            try
            {
                if (strEventID.Length != 0)
                {
                    System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                    if (con.State != ConnectionState.Open)
                        con.Open();

                    SqlCommand cmd = new SqlCommand("Proc_Schedule_GetPhases", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                    cmd.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EventID", DataRowVersion.Current, strEventID));
                    cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
                    cmd.UpdatedRowSource = UpdateRowSource.None;
                    da.SelectCommand = cmd;

                    dt.Clear();
                    da.Fill(dt);
                }

                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    string strID = dt.Rows[r]["F_PhaseID"].ToString();
                    string strInfo = "";
                    //if (dt.Rows[r]["Order"].ToString().Length != 0)
                    //    strInfo += "R." + dt.Rows[r]["Order"].ToString() + " ";
                    if (dt.Rows[r]["LongName"].ToString().Length != 0)
                        strInfo += dt.Rows[r]["LongName"].ToString();

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
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            dtRet.Rows.Add("-1", "Invalid");

            try
            {
                if (strEventID.Length != 0)
                {
                    System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                    if (con.State != ConnectionState.Open)
                        con.Open();

                    SqlCommand cmd = new SqlCommand("Proc_Schedule_GetRounds", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                    cmd.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EventID", DataRowVersion.Current, strEventID));
                    cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
                    cmd.UpdatedRowSource = UpdateRowSource.None;
                    da.SelectCommand = cmd;

                    dt.Clear();
                    da.Fill(dt);
                }

                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    string strID = dt.Rows[r]["F_RoundID"].ToString();
                    string strInfo = "";
                    if (dt.Rows[r]["Order"].ToString().Length != 0)
                        strInfo += "R." + dt.Rows[r]["Order"].ToString() + " ";
                    if (dt.Rows[r]["LongName"].ToString().Length != 0)
                        strInfo += dt.Rows[r]["LongName"].ToString();

                    dtRet.Rows.Add(strID, strInfo);
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return dtRet;
        }

        private System.Data.DataTable GetStatusTable()
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            dtRet.Rows.Add("-1", "Invalid");

            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetStatus", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);

                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    string strID = dt.Rows[r]["F_StatusID"].ToString();
                    string strInfo = dt.Rows[r]["F_StatusLongName"].ToString();

                    dtRet.Rows.Add(strID, strInfo);
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dtRet;
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
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetDisciplineDates", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
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
                    System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                    if (con.State != ConnectionState.Open)
                        con.Open();

                    SqlCommand cmd = new SqlCommand("Proc_Schedule_GetSessions", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                    if (strDate.Length == 0)
                        cmd.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@DateTime", DataRowVersion.Current, DBNull.Value));
                    else
                        cmd.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.NVarChar, 50, ParameterDirection.Input, true, 0, 0, "@DateTime", DataRowVersion.Current, strDate));
                    cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
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

        private System.Data.DataTable GetRoundItemTable(string strEventID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            dtRet.Rows.Add("-1", "");

            try
            {
                if (strEventID.Length != 0)
                {
                    System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                    if (con.State != ConnectionState.Open)
                        con.Open();

                    SqlCommand cmd = new SqlCommand("Proc_Schedule_GetRounds", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                    if (strEventID.Length != 0)
                        cmd.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EventID", DataRowVersion.Current, strEventID));
                    else
                        cmd.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@EventID", DataRowVersion.Current, DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
                    cmd.UpdatedRowSource = UpdateRowSource.None;
                    da.SelectCommand = cmd;

                    dt.Clear();
                    da.Fill(dt);
                }

                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    string strID = dt.Rows[r]["F_RoundID"].ToString();
                    string strInfo = "";
                    if (dt.Rows[r]["Order"].ToString().Length != 0)
                        strInfo += "R." + dt.Rows[r]["Order"].ToString() + " ";
                    if (dt.Rows[r]["LongName"].ToString().Length != 0)
                        strInfo += dt.Rows[r]["LongName"].ToString();

                    dtRet.Rows.Add(strID, strInfo);
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return dtRet;
        }

        private System.Data.DataTable GetStatusItemTable()
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();
            System.Data.DataTable dtRet = new DataTable();
            dtRet.Columns.Add("F_ID");
            dtRet.Columns.Add("F_Info");
            //dtRet.Rows.Add("-1", "");

            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetStatus", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);

                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    string strID = dt.Rows[r]["F_StatusID"].ToString();
                    string strInfo = dt.Rows[r]["F_StatusLongName"].ToString();

                    dtRet.Rows.Add(strID, strInfo);
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dtRet;
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
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_GetVenues", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@DisciplineID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@DisciplineID", DataRowVersion.Current, m_strDisciplineID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
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
                    System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                    if (con.State != ConnectionState.Open)
                        con.Open();

                    SqlCommand cmd = new SqlCommand("Proc_Schedule_GetCourts", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strActiveLanguageCode));
                    cmd.Parameters.Add(new SqlParameter("@VenueID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@VenueID", DataRowVersion.Current, strVenueID));
                    cmd.UpdatedRowSource = UpdateRowSource.None;
                    da.SelectCommand = cmd;

                    dt.Clear();
                    da.Fill(dt);
                }

                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    string strID = dt.Rows[r]["F_CourtID"].ToString();
                    string strInfo = dt.Rows[r]["F_CourtShortName"].ToString();

                    dtRet.Rows.Add(strID, strInfo);
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return dtRet;
        }


        bool UpdateUnScheduledMatch(string strMatchID)
        {
            if (strMatchID.Length == 0)
                return false;

            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_UpdateMatchStatus", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, strMatchID));
                cmd.Parameters.Add(new SqlParameter("@StatusID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@StatusID", DataRowVersion.Current, 10));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }

            return true;
        }

        bool UpdateScheduledMatch(string strMatchID)
        {
            if (strMatchID.Length == 0)
                return false;

            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_UpdateMatchStatus", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, strMatchID));
                cmd.Parameters.Add(new SqlParameter("@StatusID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@StatusID", DataRowVersion.Current, 30));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }

            return true;
        }


        bool UpdateMatchDate(string strMatchID, string strDate)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_UpdateMatchDate", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, strMatchID));
                if (strDate.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Date", SqlDbType.DateTime, 50, ParameterDirection.Input, true, 0, 0, "@Date", DataRowVersion.Current, strDate));
                else
                    cmd.Parameters.Add(new SqlParameter("@Date", SqlDbType.DateTime, 50, ParameterDirection.Input, true, 0, 0, "@Date", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }

            return true;
        }

        bool UpdateMatchSession(string strMatchID, string strSessionID)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_UpdateMatchSession", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, strMatchID));
                if (strSessionID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@SessionID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SessionID", DataRowVersion.Current, strSessionID));
                else
                    cmd.Parameters.Add(new SqlParameter("@SessionID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@SessionID", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }

            return true;
        }

        bool UpdateMatchStartTime(string strMatchID, string strTime)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_UpdateMatchStartTime", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, strMatchID));
                if (strTime.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Time", SqlDbType.DateTime, 50, ParameterDirection.Input, true, 0, 0, "@Time", DataRowVersion.Current, strTime));
                else
                    cmd.Parameters.Add(new SqlParameter("@Time", SqlDbType.DateTime, 50, ParameterDirection.Input, true, 0, 0, "@Time", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }

            return true;
        }

        bool UpdateMatchEndTime(string strMatchID, string strTime)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_UpdateMatchEndTime", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, strMatchID));
                if (strTime.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@Time", SqlDbType.DateTime, 50, ParameterDirection.Input, true, 0, 0, "@Time", DataRowVersion.Current, strTime));
                else
                    cmd.Parameters.Add(new SqlParameter("@Time", SqlDbType.DateTime, 50, ParameterDirection.Input, true, 0, 0, "@Time", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }

            return true;
        }


        bool UpdateMatchOrderInSession(string strMatchID, string strOrderInSession)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_UpdateMatchOrderInSession", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, strMatchID));
                if (strOrderInSession.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@OrderInSession", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@OrderInSession", DataRowVersion.Current, strOrderInSession));
                else
                    cmd.Parameters.Add(new SqlParameter("@OrderInSession", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@OrderInSession", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }

            return true;
        }

        bool UpdateRaceNumber(string strMatchID, string strRaceNumber)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_UpdateRaceNum", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, strMatchID));
                if (strRaceNumber.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@RaceNum", SqlDbType.NVarChar, 20, ParameterDirection.Input, true, 0, 0, "@RaceNum", DataRowVersion.Current, strRaceNumber));
                else
                    cmd.Parameters.Add(new SqlParameter("@RaceNum", SqlDbType.NVarChar, 20, ParameterDirection.Input, true, 0, 0, "@RaceNum", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }

            return true;
        }

        bool UpdateMatchCode(string strMatchID, string strMatchCode)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_UpdateMatchCode", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, strMatchID));
                if (strMatchCode.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@MatchCode", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@MatchCode", DataRowVersion.Current, strMatchCode));
                else
                    cmd.Parameters.Add(new SqlParameter("@MatchCode", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@MatchCode", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }

            return true;
        }

        bool UpdateMatchStatus(string strMatchID, string strMatchStatusID)
        {
            int nMatchID = -1;
            int nMatchStatusID = -1;

            if (!int.TryParse(strMatchID, out nMatchID) || !int.TryParse(strMatchStatusID, out nMatchStatusID))
                return false;

            Int32 nChangeStatusResult = 0;

            nChangeStatusResult = OVRDataBaseUtils.ChangeMatchStatus(
                int.Parse(strMatchID), int.Parse(strMatchStatusID),
                m_matchScheduleModule.DatabaseConnection, m_matchScheduleModule);

            if (nChangeStatusResult == 1)
                return true;
            else
                return false;
        }

        bool AutoProgressMatch(string strMatchID)
        {
            return OVRDataBaseUtils.AutoProgressMatch(int.Parse(strMatchID),
                m_matchScheduleModule.DatabaseConnection, m_matchScheduleModule);
        }

        bool UpdateMatchVenue(string strMatchID, string strVenueID)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_UpdateMatchVenue", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, strMatchID));
                if (strVenueID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@VenueID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@VenueID", DataRowVersion.Current, strVenueID));
                else
                    cmd.Parameters.Add(new SqlParameter("@VenueID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@VenueID", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }

            return true;
        }

        bool UpdateMatchCourt(string strMatchID, string strCourtID)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_UpdateMatchCourt", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, strMatchID));
                if (strCourtID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@CourtID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CourtID", DataRowVersion.Current, strCourtID));
                else
                    cmd.Parameters.Add(new SqlParameter("@CourtID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@CourtID", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }

            return true;
        }

        bool UpdateMatchRound(string strMatchID, string strRoundID)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_UpdateMatchRound", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, strMatchID));
                if (strRoundID.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@RoundID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RoundID", DataRowVersion.Current, strRoundID));
                else
                    cmd.Parameters.Add(new SqlParameter("@RoundID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RoundID", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }

            return true;
        }

        bool UpdateMatchOrderInRound(string strMatchID, string strOrderInRound)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_UpdateMatchOrderInRound", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, strMatchID));
                if (strOrderInRound.Length != 0)
                    cmd.Parameters.Add(new SqlParameter("@OrderInRound", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@OrderInRound", DataRowVersion.Current, strOrderInRound));
                else
                    cmd.Parameters.Add(new SqlParameter("@OrderInRound", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@OrderInRound", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                return false;
            }

            return true;
        }

        bool SetRaceNumByTime( string strMatchIDList, string strPreFix, int nStartNum, int nStep, int nLength)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_SetRaceNumByTime", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchIDList", SqlDbType.NVarChar, 100000, ParameterDirection.Input, true, 0, 0, "@MatchIDList", DataRowVersion.Current, strMatchIDList));
                cmd.Parameters.Add(new SqlParameter("@PreFix", SqlDbType.NVarChar, 10, ParameterDirection.Input, true, 0, 0, "@PreFix", DataRowVersion.Current, strPreFix));
                cmd.Parameters.Add(new SqlParameter("@StartNum", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@StartNum", DataRowVersion.Current, nStartNum));
                cmd.Parameters.Add(new SqlParameter("@Step", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Step", DataRowVersion.Current, nStep));
                cmd.Parameters.Add(new SqlParameter("@Length", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Length", DataRowVersion.Current, nLength));

                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value == 1)
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

        bool SetMatchCodeByTime(string strMatchIDList, string strPreFix, int nStartNum, int nStep, int nLength)
        {
            try
            {
                System.Data.SqlClient.SqlConnection con = m_matchScheduleModule.DatabaseConnection;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_Schedule_SetMatchCodeByTime", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchIDList", SqlDbType.NVarChar, 100000, ParameterDirection.Input, true, 0, 0, "@MatchIDList", DataRowVersion.Current, strMatchIDList));
                cmd.Parameters.Add(new SqlParameter("@PreFix", SqlDbType.NVarChar, 10, ParameterDirection.Input, true, 0, 0, "@PreFix", DataRowVersion.Current, strPreFix));
                cmd.Parameters.Add(new SqlParameter("@StartNum", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@StartNum", DataRowVersion.Current, nStartNum));
                cmd.Parameters.Add(new SqlParameter("@Step", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Step", DataRowVersion.Current, nStep));
                cmd.Parameters.Add(new SqlParameter("@Length", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@Length", DataRowVersion.Current, nLength));

                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.None;

                cmd.ExecuteNonQuery();

                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value == 1)
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