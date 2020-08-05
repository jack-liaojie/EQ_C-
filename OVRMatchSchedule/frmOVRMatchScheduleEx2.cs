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
using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    public partial class OVRMatchScheduleForm
    {
        private void dgv_Scheduled_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            for (int nColIndex = 0; nColIndex < this.dgv_Scheduled.Columns.Count; nColIndex++)
            {
                try
                {
                    m_dtOldScheduled.Rows[0][nColIndex] = this.dgv_Scheduled.Rows[e.RowIndex].Cells[nColIndex].Value;
                }
                catch
                {
                    m_dtOldScheduled.Rows[0][nColIndex] = DBNull.Value;
                }
            }

            if (dgv_Scheduled.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn)
            {
                if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("Date") == 0)
                {
                    InitDgvDateCombBox(ref dgv_Scheduled, e.RowIndex, e.ColumnIndex);
                }
                else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("Session") == 0)
                {
                    InitDgvSessionCombBox(ref dgv_Scheduled, e.RowIndex, e.ColumnIndex);
                }
                else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("Round") == 0)
                {
                    InitDgvRoundCombBox(ref dgv_Scheduled, e.RowIndex, e.ColumnIndex);
                }
                else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("Status") == 0)
                {
                    InitDgvStatusCombBox(ref dgv_Scheduled, e.RowIndex, e.ColumnIndex);
                }
                else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("Venue") == 0)
                {
                    InitDgvVenueCombBox(ref dgv_Scheduled, e.RowIndex, e.ColumnIndex);
                }
                else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("Court") == 0)
                {
                    InitDgvCourtCombBox(ref dgv_Scheduled, e.RowIndex, e.ColumnIndex);
                }
            }
        }

        private void InitDgvDateCombBox(ref UIDataGridView GridCtrl, Int32 iRowIndex, Int32 iColumnIndex)
        {
            System.Data.DataTable dt = GetDateItemTable();
            (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dt, 1, 0);
        }

        private void InitDgvSessionCombBox(ref UIDataGridView GridCtrl, Int32 iRowIndex, Int32 iColumnIndex)
        {
            string strDate = this.dgv_Scheduled.Rows[iRowIndex].Cells["Date"].Value.ToString();
            System.Data.DataTable dt = GetSessionItemTable(strDate);
            (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dt, 1, 0);
        }

        private void InitDgvRoundCombBox(ref UIDataGridView GridCtrl, Int32 iRowIndex, Int32 iColumnIndex)
        {
            string strEventID = this.dgv_Scheduled.Rows[iRowIndex].Cells["F_EventID"].Value.ToString(); ;
            System.Data.DataTable dt = GetRoundItemTable(strEventID);
            (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dt, 1, 0);
        }

        private void InitDgvStatusCombBox(ref UIDataGridView GridCtrl, Int32 iRowIndex, Int32 iColumnIndex)
        {
            System.Data.DataTable dt = GetStatusItemTable();
            (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dt, 1, 0);
        }

        private void InitDgvVenueCombBox(ref UIDataGridView GridCtrl, Int32 iRowIndex, Int32 iColumnIndex)
        {
            System.Data.DataTable dt = GetVenueItemTable();
            (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dt, 1, 0);
        }

        private void InitDgvCourtCombBox(ref UIDataGridView GridCtrl, Int32 iRowIndex, Int32 iColumnIndex)
        {
            string strVenueID = this.dgv_Scheduled.Rows[iRowIndex].Cells["F_VenueID"].Value.ToString(); ;
            System.Data.DataTable dt = GetCourtItemTable(strVenueID);
            (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dt, 1, 0);
        }

        private void dgv_Scheduled_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("Date") == 0)
            {
                string strOldData = m_dtOldScheduled.Rows[0]["Date"].ToString();
                
                string strNewData = "";
                if (dgv_Scheduled.Rows[e.RowIndex].Cells["Date"].Value != null)
                {
                    strNewData = dgv_Scheduled.Rows[e.RowIndex].Cells["Date"].Value.ToString();
                    try
                    {
                        DateTime dtTemp = Convert.ToDateTime(strNewData);
                    }
                    catch
                    {
                        dgv_Scheduled.Rows[e.RowIndex].Cells["Date"].Value = strOldData;
                        return;
                    }
                }

                if (strNewData == strOldData)
                    return;

                string strOldSessionID = dgv_Scheduled.Rows[e.RowIndex].Cells["F_SessionID"].Value.ToString();

                dgv_Scheduled.Rows[e.RowIndex].Cells["Session"].Value = DBNull.Value;
                dgv_Scheduled.Rows[e.RowIndex].Cells["F_SessionID"].Value = DBNull.Value;

                string strMatchID = dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchID"].Value.ToString();

                this.UpdateMatchDate(strMatchID, strNewData);
                this.UpdateMatchSession(strMatchID, "");

                int iMatchID = Convert.ToInt32(strMatchID);
                int iOldSessionID = -1;
                if (strOldSessionID.Length != 0)
                    iOldSessionID = Convert.ToInt32(strOldSessionID);

                List<OVRDataChanged> changedList = new List<OVRDataChanged>();
                changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchDate, -1, -1, -1, iMatchID, iMatchID, null));
                if (strOldSessionID.Length != 0)
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionReset, -1, -1, -1, iMatchID, iOldSessionID, null));

                m_matchScheduleModule.DataChangedNotify(changedList);

                return;
            }
            else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("Session") == 0)
            {
                string strOldData = m_dtOldScheduled.Rows[0]["F_SessionID"].ToString();

                DGVCustomComboBoxCell boxCell = dgv_Scheduled.Rows[e.RowIndex].Cells[e.ColumnIndex] as DGVCustomComboBoxCell;
                Int32 iKey = 0;
                iKey = Convert.ToInt32(boxCell.Tag);

                string strNewData = "";
                if (iKey == -1)
                    strNewData = "";
                else if (iKey == 0)
                    strNewData = strOldData;
                else
                    strNewData = iKey.ToString();

                if (strNewData == strOldData)
                    return;

                if (strNewData.Length == 0)
                    dgv_Scheduled.Rows[e.RowIndex].Cells["F_SessionID"].Value = DBNull.Value;
                else
                    dgv_Scheduled.Rows[e.RowIndex].Cells["F_SessionID"].Value = strNewData;

                string strMatchID = "";
                strMatchID = dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchID"].Value.ToString();

                this.UpdateMatchSession(strMatchID, strNewData);

                int iMatchID = Convert.ToInt32(strMatchID);
                int iOldSessionID = -1;
                if (strOldData.Length != 0)
                    iOldSessionID = Convert.ToInt32(strOldData);
                int iNewSessionID = -1;
                if (strNewData.Length != 0)
                    iNewSessionID = Convert.ToInt32(strNewData);

                List<OVRDataChanged> changedList = new List<OVRDataChanged>();
                if (strOldData.Length != 0)
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionReset, -1, -1, -1, iMatchID, iOldSessionID, null));
                if (strNewData.Length != 0)
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionSet, -1, -1, -1, iMatchID, iNewSessionID, null));
                
                m_matchScheduleModule.DataChangedNotify(changedList);
              
                return;
            }
            else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("R.Num") == 0)
            {
                string strOldData = m_dtOldScheduled.Rows[0]["R.Num"].ToString();
                string strNewData = "";
                if (dgv_Scheduled.Rows[e.RowIndex].Cells["R.Num"].Value != null)
                {
                    strNewData = dgv_Scheduled.Rows[e.RowIndex].Cells["R.Num"].Value.ToString();
                }

                if (strNewData == strOldData)
                    return;

                string strMatchID = "";
                strMatchID = dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchID"].Value.ToString();

                this.UpdateRaceNumber(strMatchID, strNewData);

                int iMatchID = Convert.ToInt32(strMatchID);
                m_matchScheduleModule.DataChangedNotify(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null);

                return;
            }
            else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("M.Code") == 0)
            {
                string strOldData = m_dtOldScheduled.Rows[0]["M.Code"].ToString();
                string strNewData = "";
                if (dgv_Scheduled.Rows[e.RowIndex].Cells["M.Code"].Value != null)
                {
                    strNewData = dgv_Scheduled.Rows[e.RowIndex].Cells["M.Code"].Value.ToString();
                }

                if (strNewData == strOldData)
                    return;

                string strMatchID = "";
                strMatchID = dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchID"].Value.ToString();

                this.UpdateMatchCode(strMatchID, strNewData);

                int iMatchID = Convert.ToInt32(strMatchID);
                m_matchScheduleModule.DataChangedNotify(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null);

                return;
            }
            else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("StartTime") == 0)
            {
                string strOldData = m_dtOldScheduled.Rows[0]["StartTime"].ToString();
                string strNewData = "";
                if (dgv_Scheduled.Rows[e.RowIndex].Cells["StartTime"].Value != null)
                {
                    strNewData = dgv_Scheduled.Rows[e.RowIndex].Cells["StartTime"].Value.ToString();
                    try
                    {
                        DateTime dtTemp = Convert.ToDateTime(strNewData);
                    }
                    catch
                    {
                        dgv_Scheduled.Rows[e.RowIndex].Cells["StartTime"].Value = strOldData;
                        return;
                    }
                }

                if (strNewData == strOldData)
                    return;

                string strMatchID = "";
                strMatchID = dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchID"].Value.ToString();

                this.UpdateMatchStartTime(strMatchID, strNewData);

                int iMatchID = Convert.ToInt32(strMatchID);
                m_matchScheduleModule.DataChangedNotify(OVRDataChangedType.emMatchDate, -1, -1, -1, iMatchID, iMatchID, null);

                return;
            }
            else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("EndTime") == 0)
            {
                string strOldData = m_dtOldScheduled.Rows[0]["EndTime"].ToString();
                string strNewData = "";
                if (dgv_Scheduled.Rows[e.RowIndex].Cells["EndTime"].Value != null)
                {
                    strNewData = dgv_Scheduled.Rows[e.RowIndex].Cells["EndTime"].Value.ToString();
                    try
                    {
                        DateTime dtTemp = Convert.ToDateTime(strNewData);
                    }
                    catch
                    {
                        dgv_Scheduled.Rows[e.RowIndex].Cells["EndTime"].Value = strOldData;
                        return;
                    }
                }

                if (strNewData == strOldData)
                    return;

                string strMatchID = "";
                strMatchID = dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchID"].Value.ToString();

                this.UpdateMatchEndTime(strMatchID, strNewData);

                int iMatchID = Convert.ToInt32(strMatchID);
                m_matchScheduleModule.DataChangedNotify(OVRDataChangedType.emMatchDate, -1, -1, -1, iMatchID, iMatchID, null);

                return;
            }
            else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("Round") == 0)
            {
                string strOldData = m_dtOldScheduled.Rows[0]["F_RoundID"].ToString();
                DGVCustomComboBoxCell boxCell = dgv_Scheduled.Rows[e.RowIndex].Cells[e.ColumnIndex] as DGVCustomComboBoxCell;
                Int32 iKey = 0;
                iKey = Convert.ToInt32(boxCell.Tag);

                string strNewData = "";
                if (iKey == -1)
                    strNewData = "";
                else if (iKey == 0)
                    strNewData = strOldData;
                else
                    strNewData = iKey.ToString();

                if (strNewData == strOldData)
                    return;

                if (strNewData.Length == 0)
                    this.dgv_Scheduled.Rows[e.RowIndex].Cells["F_RoundID"].Value = DBNull.Value;
                else
                    this.dgv_Scheduled.Rows[e.RowIndex].Cells["F_RoundID"].Value = strNewData;

                string strMatchID = "";
                strMatchID = dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchID"].Value.ToString();

                this.UpdateMatchRound(strMatchID, strNewData);

                int iMatchID = Convert.ToInt32(strMatchID);
                m_matchScheduleModule.DataChangedNotify(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null);

                return;
            }
            else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("Status") == 0)
            {
                string strOldData = m_dtOldScheduled.Rows[0]["F_MatchStatusID"].ToString();
                DGVCustomComboBoxCell boxCell = dgv_Scheduled.Rows[e.RowIndex].Cells[e.ColumnIndex] as DGVCustomComboBoxCell;
                Int32 iKey = 0;
                iKey = Convert.ToInt32(boxCell.Tag);

                string strNewData = "";
                if (iKey == -1)
                    strNewData = "";
                else if (iKey == 0)
                    strNewData = strOldData;
                else
                    strNewData = iKey.ToString();

                if (strNewData == strOldData)
                    return;

                if (strNewData.Length == 0)
                    this.dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchStatusID"].Value = DBNull.Value;
                else
                    this.dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchStatusID"].Value = strNewData;

                string strMatchID = "";
                strMatchID = dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchID"].Value.ToString();

                if (!this.UpdateMatchStatus(strMatchID, strNewData))
                {
                    this.dgv_Scheduled.Rows[e.RowIndex].Cells["Status"].Value = m_dtOldScheduled.Rows[0]["Status"].ToString();
                    if (strOldData.Length == 0)
                        this.dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchStatusID"].Value = DBNull.Value;
                    else
                        this.dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchStatusID"].Value = strOldData;
                }

                //int iMatchID = Convert.ToInt32(strMatchID);
                //m_matchScheduleModule.DataChangedNotify(OVRDataChangedType.emMatchStatus, -1, -1, -1, iMatchID, iMatchID, null);

                return;
            }
            else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("Venue") == 0)
            {
                string strOldData = m_dtOldScheduled.Rows[0]["F_VenueID"].ToString();
                DGVCustomComboBoxCell boxCell = dgv_Scheduled.Rows[e.RowIndex].Cells[e.ColumnIndex] as DGVCustomComboBoxCell;
                Int32 iKey = 0;
                iKey = Convert.ToInt32(boxCell.Tag);

                string strNewData = "";
                if (iKey == -1)
                    strNewData = "";
                else if (iKey == 0)
                    strNewData = strOldData;
                else
                    strNewData = iKey.ToString();

                if (strNewData == strOldData)
                    return;

                if (strNewData.Length == 0)
                    this.dgv_Scheduled.Rows[e.RowIndex].Cells["F_VenueID"].Value = DBNull.Value;
                else
                    this.dgv_Scheduled.Rows[e.RowIndex].Cells["F_VenueID"].Value = strNewData;

                string strOldCourtID = dgv_Scheduled.Rows[e.RowIndex].Cells["F_CourtID"].Value.ToString();
                dgv_Scheduled.Rows[e.RowIndex].Cells["Court"].Value = DBNull.Value;
                dgv_Scheduled.Rows[e.RowIndex].Cells["F_CourtID"].Value = DBNull.Value;

                string strMatchID = dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchID"].Value.ToString();

                this.UpdateMatchVenue(strMatchID, strNewData);
                this.UpdateMatchCourt(strMatchID, "");

                int iMatchID = Convert.ToInt32(strMatchID);
                int iOldCourtID = -1;
                if (strOldCourtID.Length != 0)
                    iOldCourtID = Convert.ToInt32(strOldCourtID);

                List<OVRDataChanged> changedList = new List<OVRDataChanged>();
                changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                if (strOldCourtID.Length != 0)
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtReset, -1, -1, -1, iMatchID, iOldCourtID, null));

                m_matchScheduleModule.DataChangedNotify(changedList);

                return;
            }
            else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("Court") == 0)
            {
                string strOldData = m_dtOldScheduled.Rows[0]["F_CourtID"].ToString();
                DGVCustomComboBoxCell boxCell = dgv_Scheduled.Rows[e.RowIndex].Cells[e.ColumnIndex] as DGVCustomComboBoxCell;
                Int32 iKey = 0;
                iKey = Convert.ToInt32(boxCell.Tag);

                string strNewData = "";
                if (iKey == -1)
                    strNewData = "";
                else if (iKey == 0)
                    strNewData = strOldData;
                else
                    strNewData = iKey.ToString();

                if (strNewData == strOldData)
                    return;

                if (strNewData.Length == 0)
                    this.dgv_Scheduled.Rows[e.RowIndex].Cells["F_CourtID"].Value = DBNull.Value;
                else
                    this.dgv_Scheduled.Rows[e.RowIndex].Cells["F_CourtID"].Value = strNewData;

                string strMatchID = "";
                strMatchID = dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchID"].Value.ToString();

                this.UpdateMatchCourt(strMatchID, strNewData);

                int iMatchID = Convert.ToInt32(strMatchID);
                int iOldCourtID = -1;
                if (strOldData.Length != 0)
                    iOldCourtID = Convert.ToInt32(strOldData);
                int iNewCourtID = -1;
                if (strNewData.Length != 0)
                    iNewCourtID = Convert.ToInt32(strNewData);

                List<OVRDataChanged> changedList = new List<OVRDataChanged>();
                if (strOldData.Length != 0)
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtReset, -1, -1, -1, iMatchID, iOldCourtID, null));
                if (strNewData.Length != 0)
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtSet, -1, -1, -1, iMatchID, iNewCourtID, null));

                m_matchScheduleModule.DataChangedNotify(changedList);

                return;
            }
            else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("O.I.S") == 0)
            {
                string strOldData = m_dtOldScheduled.Rows[0]["O.I.S"].ToString();
                string strNewData = "";
                if (dgv_Scheduled.Rows[e.RowIndex].Cells["O.I.S"].Value != null)
                {
                    strNewData = dgv_Scheduled.Rows[e.RowIndex].Cells["O.I.S"].Value.ToString();

                    bool bIsInt = true;
                    for (int i = 0; i < strNewData.Length; i++)
                    {
                        if (!Char.IsNumber(strNewData, i))
                            bIsInt = false;
                    }
                    if (!bIsInt)
                    {
                        dgv_Scheduled.Rows[e.RowIndex].Cells["O.I.S"].Value = strOldData;
                        return;
                    }
                }

                if (strNewData == strOldData)
                    return;

                string strMatchID = "";
                strMatchID = dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchID"].Value.ToString();

                this.UpdateMatchOrderInSession(strMatchID, strNewData);

                int iMatchID = Convert.ToInt32(strMatchID);
                m_matchScheduleModule.DataChangedNotify(OVRDataChangedType.emMatchOrderInSession, -1, -1, -1, iMatchID, iMatchID, null);

                return;
            }
            else if (dgv_Scheduled.Columns[e.ColumnIndex].Name.CompareTo("O.I.R") == 0)
            {
                string strOldData = m_dtOldScheduled.Rows[0]["O.I.R"].ToString();
                string strNewData = "";
                if (dgv_Scheduled.Rows[e.RowIndex].Cells["O.I.R"].Value != null)
                {
                    strNewData = dgv_Scheduled.Rows[e.RowIndex].Cells["O.I.R"].Value.ToString();

                    bool bIsInt = true;
                    for (int i = 0; i < strNewData.Length; i++)
                    {
                        if (!Char.IsNumber(strNewData, i))
                            bIsInt = false;
                    }
                    if (!bIsInt)
                    {
                        dgv_Scheduled.Rows[e.RowIndex].Cells["O.I.R"].Value = strOldData;
                        return;
                    }
                }

                if (strNewData == strOldData)
                    return;

                string strMatchID = "";
                strMatchID = dgv_Scheduled.Rows[e.RowIndex].Cells["F_MatchID"].Value.ToString();

                this.UpdateMatchOrderInRound(strMatchID, strNewData);

                int iMatchID = Convert.ToInt32(strMatchID);
                m_matchScheduleModule.DataChangedNotify(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null);

                return;
            }
        }
    }
}