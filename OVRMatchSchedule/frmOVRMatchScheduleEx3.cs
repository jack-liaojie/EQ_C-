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
        private void Init_UnScheduledGrid()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgv_UnScheduled);

            System.Data.DataTable dt = GetInitUnScheduledDataTable();

            OVRDataBaseUtils.FillDataGridView(this.dgv_UnScheduled, dt, null, null);

            if (this.dgv_UnScheduled.Columns["F_EventID"] != null)
                this.dgv_UnScheduled.Columns["F_EventID"].Visible = false;
            if (this.dgv_UnScheduled.Columns["F_MatchID"] != null)
                this.dgv_UnScheduled.Columns["F_MatchID"].Visible = false;
            if (this.dgv_UnScheduled.Columns["F_SessionID"] != null)
                this.dgv_UnScheduled.Columns["F_SessionID"].Visible = false;
            if (this.dgv_UnScheduled.Columns["F_VenueID"] != null)
                this.dgv_UnScheduled.Columns["F_VenueID"].Visible = false;
            if (this.dgv_UnScheduled.Columns["F_CourtID"] != null)
                this.dgv_UnScheduled.Columns["F_CourtID"].Visible = false;
            if (this.dgv_UnScheduled.Columns["F_MatchStatusID"] != null)
                this.dgv_UnScheduled.Columns["F_MatchStatusID"].Visible = false;
            if (this.dgv_UnScheduled.Columns["F_RoundID"] != null)
                this.dgv_UnScheduled.Columns["F_RoundID"].Visible = false;

            this.dgv_UnScheduled.ClearSelection();
        }

        private void Init_ScheduledGrid()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgv_Scheduled);

            System.Data.DataTable dt = GetInitScheduledDataTable();

            OVRDataBaseUtils.FillDataGridViewWithCmb(this.dgv_Scheduled, dt, "Date", "Session", "Round", "Status", "Venue", "Court");

            if (this.dgv_Scheduled.Columns["F_EventID"] != null)
                this.dgv_Scheduled.Columns["F_EventID"].Visible = false;
            if (this.dgv_Scheduled.Columns["F_MatchID"] != null)
                this.dgv_Scheduled.Columns["F_MatchID"].Visible = false;
            if (this.dgv_Scheduled.Columns["F_SessionID"] != null)
                this.dgv_Scheduled.Columns["F_SessionID"].Visible = false;
            if (this.dgv_Scheduled.Columns["F_VenueID"] != null)
                this.dgv_Scheduled.Columns["F_VenueID"].Visible = false;
            if (this.dgv_Scheduled.Columns["F_CourtID"] != null)
                this.dgv_Scheduled.Columns["F_CourtID"].Visible = false;
            if (this.dgv_Scheduled.Columns["F_MatchStatusID"] != null)
                this.dgv_Scheduled.Columns["F_MatchStatusID"].Visible = false;
            if (this.dgv_Scheduled.Columns["F_RoundID"] != null)
                this.dgv_Scheduled.Columns["F_RoundID"].Visible = false;

            if (this.dgv_Scheduled.Columns["R.Num"] != null)
                this.dgv_Scheduled.Columns["R.Num"].ReadOnly = false;
            if (this.dgv_Scheduled.Columns["M.Code"] != null)
                this.dgv_Scheduled.Columns["M.Code"].ReadOnly = false;
            if (this.dgv_Scheduled.Columns["StartTime"] != null)
                this.dgv_Scheduled.Columns["StartTime"].ReadOnly = false;
            if (this.dgv_Scheduled.Columns["EndTime"] != null)
                this.dgv_Scheduled.Columns["EndTime"].ReadOnly = false;
            if (this.dgv_Scheduled.Columns["O.I.S"] != null)
                this.dgv_Scheduled.Columns["O.I.S"].ReadOnly = false;
            if (this.dgv_Scheduled.Columns["O.I.R"] != null)
                this.dgv_Scheduled.Columns["O.I.R"].ReadOnly = false;

            this.dgv_Scheduled.ClearSelection();
        }

        private void Update_UnScheduledGrid()
        {
            int iFirstDisplayedScrollingRowIndex = dgv_UnScheduled.FirstDisplayedScrollingRowIndex;
            int iFirstDisplayedScrollingColumnIndex = dgv_UnScheduled.FirstDisplayedScrollingColumnIndex;
            if (iFirstDisplayedScrollingRowIndex < 0) iFirstDisplayedScrollingRowIndex = 0;
            if (iFirstDisplayedScrollingColumnIndex < 0) iFirstDisplayedScrollingColumnIndex = 0;

            System.Data.DataTable dt = GetUnScheduledDataTable();

            OVRDataBaseUtils.FillDataGridView(this.dgv_UnScheduled, dt, null, null);

            if (this.dgv_UnScheduled.Columns["F_EventID"] != null)
                this.dgv_UnScheduled.Columns["F_EventID"].Visible = false;
            if (this.dgv_UnScheduled.Columns["F_MatchID"] != null)
                this.dgv_UnScheduled.Columns["F_MatchID"].Visible = false;
            if (this.dgv_UnScheduled.Columns["F_SessionID"] != null)
                this.dgv_UnScheduled.Columns["F_SessionID"].Visible = false;
            if (this.dgv_UnScheduled.Columns["F_VenueID"] != null)
                this.dgv_UnScheduled.Columns["F_VenueID"].Visible = false;
            if (this.dgv_UnScheduled.Columns["F_CourtID"] != null)
                this.dgv_UnScheduled.Columns["F_CourtID"].Visible = false;
            if (this.dgv_UnScheduled.Columns["F_MatchStatusID"] != null)
                this.dgv_UnScheduled.Columns["F_MatchStatusID"].Visible = false;
            if (this.dgv_UnScheduled.Columns["F_RoundID"] != null)
                this.dgv_UnScheduled.Columns["F_RoundID"].Visible = false;

            this.dgv_UnScheduled.ClearSelection();

            if (iFirstDisplayedScrollingRowIndex < dgv_UnScheduled.Rows.Count)
                dgv_UnScheduled.FirstDisplayedScrollingRowIndex = iFirstDisplayedScrollingRowIndex;
            if (iFirstDisplayedScrollingColumnIndex < dgv_UnScheduled.Columns.Count)
                dgv_UnScheduled.FirstDisplayedScrollingColumnIndex = iFirstDisplayedScrollingColumnIndex;
        }

        private void Update_ScheduledGrid()
        {
            int iFirstDisplayedScrollingRowIndex = dgv_Scheduled.FirstDisplayedScrollingRowIndex;
            int iFirstDisplayedScrollingColumnIndex = dgv_Scheduled.FirstDisplayedScrollingColumnIndex;
            if (iFirstDisplayedScrollingRowIndex < 0) iFirstDisplayedScrollingRowIndex = 0;
            if (iFirstDisplayedScrollingColumnIndex < 0) iFirstDisplayedScrollingColumnIndex = 0;

            System.Data.DataTable dt = GetScheduledDataTable();

            m_dtOldScheduled = new DataTable();
            for (int nColIndex = 0; nColIndex < dt.Columns.Count; nColIndex++)
            {
                m_dtOldScheduled.Columns.Add(dt.Columns[nColIndex].ColumnName, dt.Columns[nColIndex].DataType);
            }
            m_dtOldScheduled.Rows.Add();

            OVRDataBaseUtils.FillDataGridViewWithCmb( this.dgv_Scheduled, dt, "Date","Session","Round","Status","Venue","Court");

            if (this.dgv_Scheduled.Columns["F_EventID"] != null)
                this.dgv_Scheduled.Columns["F_EventID"].Visible = false;
            if (this.dgv_Scheduled.Columns["F_MatchID"] != null)
                this.dgv_Scheduled.Columns["F_MatchID"].Visible = false;
            if (this.dgv_Scheduled.Columns["F_SessionID"] != null)
                this.dgv_Scheduled.Columns["F_SessionID"].Visible = false;
            if (this.dgv_Scheduled.Columns["F_VenueID"] != null)
                this.dgv_Scheduled.Columns["F_VenueID"].Visible = false;
            if (this.dgv_Scheduled.Columns["F_CourtID"] != null)
                this.dgv_Scheduled.Columns["F_CourtID"].Visible = false;
            if (this.dgv_Scheduled.Columns["F_MatchStatusID"] != null)
                this.dgv_Scheduled.Columns["F_MatchStatusID"].Visible = false;
            if (this.dgv_Scheduled.Columns["F_RoundID"] != null)
                this.dgv_Scheduled.Columns["F_RoundID"].Visible = false;

            if (this.dgv_Scheduled.Columns["R.Num"] != null)
                this.dgv_Scheduled.Columns["R.Num"].ReadOnly = false;
            if (this.dgv_Scheduled.Columns["M.Code"] != null)
                this.dgv_Scheduled.Columns["M.Code"].ReadOnly = false;
            if (this.dgv_Scheduled.Columns["StartTime"] != null)
                this.dgv_Scheduled.Columns["StartTime"].ReadOnly = false;
            if (this.dgv_Scheduled.Columns["EndTime"] != null)
                this.dgv_Scheduled.Columns["EndTime"].ReadOnly = false;
            if (this.dgv_Scheduled.Columns["O.I.S"] != null)
                this.dgv_Scheduled.Columns["O.I.S"].ReadOnly = false;
            if (this.dgv_Scheduled.Columns["O.I.R"] != null)
                this.dgv_Scheduled.Columns["O.I.R"].ReadOnly = false;

            this.dgv_Scheduled.ClearSelection();

            if (iFirstDisplayedScrollingRowIndex < dgv_Scheduled.Rows.Count)
                dgv_Scheduled.FirstDisplayedScrollingRowIndex = iFirstDisplayedScrollingRowIndex;
            if (iFirstDisplayedScrollingColumnIndex < dgv_Scheduled.Columns.Count)
                dgv_Scheduled.FirstDisplayedScrollingColumnIndex = iFirstDisplayedScrollingColumnIndex;
        }
    }
}