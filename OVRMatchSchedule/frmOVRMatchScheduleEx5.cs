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
        private void dgv_Schedule_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right && this.dgv_Scheduled.SelectedRows.Count > 0)
            {
                this.dgv_Scheduled.ContextMenuStrip = MatchConfigcontextMenu;
            }
        }

        private void MenuSetRaceNumber_Click(object sender, EventArgs e)
        {
            string strSectionName = OVRMatchScheduleModule.GetSectionName();
            RaceNumberSettingForm frmRaceNumberSetting = new RaceNumberSettingForm(strSectionName);
            frmRaceNumberSetting.DatabaseConnection = this.m_matchScheduleModule.DatabaseConnection;
            frmRaceNumberSetting.ShowDialog();

            if (frmRaceNumberSetting.DialogResult != DialogResult.OK || this.dgv_Scheduled.SelectedRows.Count < 1)
                return;

            DataGridViewSelectedRowCollection l_Rows = this.dgv_Scheduled.SelectedRows;
            int[] arSelIndex = new int[l_Rows.Count];
            int i = 0;
            foreach (DataGridViewRow r in l_Rows)
            {
                arSelIndex[i++] = r.Index;
            }
            Array.Sort(arSelIndex);

            List<OVRDataChanged> changedList = new List<OVRDataChanged>();

            if (!frmRaceNumberSetting.m_bChkSortByTime)
            {
                int iRowIdx = 0;
                foreach (int iSelIndex in arSelIndex)
                {
                    try
                    {
                        string strOldData = "";
                        if (dgv_Scheduled.Rows[iSelIndex].Cells["R.Num"].Value != null)
                            strOldData = dgv_Scheduled.Rows[iSelIndex].Cells["R.Num"].Value.ToString();
                        string strNewData = "";

                        string strPreFix = frmRaceNumberSetting.PreFix;
                        int iCode = frmRaceNumberSetting.StartNumber;
                        if (iCode > -1)
                        {
                            iCode += iRowIdx * frmRaceNumberSetting.Step;
                            strNewData = iCode.ToString();
                        }
                        int iLength = frmRaceNumberSetting.CodeLength;
                        if (iLength > 0)
                            strNewData = strPreFix + strNewData.PadLeft(iLength, '0');
                        else
                            strNewData = "";

                        iRowIdx++;

                        if (strNewData == strOldData)
                            continue;

                        string strRaceNumber = strNewData;

                        dgv_Scheduled.Rows[iSelIndex].Cells["R.Num"].Value = strRaceNumber;

                        string strMatchID = this.dgv_Scheduled.Rows[iSelIndex].Cells["F_MatchID"].Value.ToString();
                        UpdateRaceNumber(strMatchID, strRaceNumber);

                        int iMatchID = Convert.ToInt32(strMatchID);
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                    }
                    catch (Exception ex)
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                    }
                }
            }
            else
            {
                string strMatchIDList = "";
                foreach (int iSelIndex in arSelIndex)
                {
                    string strMatchID = dgv_Scheduled.Rows[iSelIndex].Cells["F_MatchID"].Value.ToString();
                    strMatchIDList += strMatchID;
                    strMatchIDList += ",";

                    int iMatchID = Convert.ToInt32(strMatchID);
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                }
                if (strMatchIDList.Length != 0)
                {
                    strMatchIDList = strMatchIDList.Substring(0, strMatchIDList.Length - 1);

                    try
                    {
                        string strPreFix = frmRaceNumberSetting.PreFix;
                        int nStartNumber = frmRaceNumberSetting.StartNumber;
                        int nStep = frmRaceNumberSetting.Step;
                        int nLength = frmRaceNumberSetting.CodeLength;

                        if (this.SetRaceNumByTime(strMatchIDList, strPreFix, nStartNumber, nStep, nLength))
                        {
                            this.Update_ScheduledGrid();
                        }
                    }
                    catch (Exception ex)
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                    }
                }
            }

            if (changedList.Count > 0)
                m_matchScheduleModule.DataChangedNotify(changedList);
        }

        private void MenuSetMatchCode_Click(object sender, EventArgs e)
        {
            string strSectionName = OVRMatchScheduleModule.GetSectionName();
            MatchCodeSettingForm frmMatchCodeSetting = new MatchCodeSettingForm(strSectionName);
            frmMatchCodeSetting.DatabaseConnection = this.m_matchScheduleModule.DatabaseConnection;
            frmMatchCodeSetting.ShowDialog();

            if (frmMatchCodeSetting.DialogResult != DialogResult.OK || this.dgv_Scheduled.SelectedRows.Count < 1)
                return;

            DataGridViewSelectedRowCollection l_Rows = this.dgv_Scheduled.SelectedRows;
            int[] arSelIndex = new int[l_Rows.Count];
            int i = 0;
            foreach (DataGridViewRow r in l_Rows)
            {
                arSelIndex[i++] = r.Index;
            }
            Array.Sort(arSelIndex);

            List<OVRDataChanged> changedList = new List<OVRDataChanged>();

            if (!frmMatchCodeSetting.m_bChkSortByTime)
            {
                int iRowIdx = 0;
                foreach (int iSelIndex in arSelIndex)
                {
                    try
                    {
                        string strOldData = "";
                        if (dgv_Scheduled.Rows[iSelIndex].Cells["M.Code"].Value != null)
                            strOldData = dgv_Scheduled.Rows[iSelIndex].Cells["M.Code"].Value.ToString();
                        string strNewData = "";

                        string strPreFix = frmMatchCodeSetting.PreFix;
                        int iCode = frmMatchCodeSetting.StartNumber;
                        if (iCode > -1)
                        {
                            iCode += iRowIdx * frmMatchCodeSetting.Step;
                            strNewData = iCode.ToString();
                        }
                        int iLength = frmMatchCodeSetting.CodeLength;
                        if (iLength > 0)
                            strNewData = strPreFix + strNewData.PadLeft(iLength, '0');
                        else
                            strNewData = "";

                        iRowIdx++;

                        if (strNewData == strOldData)
                            continue;

                        string strMatchCode = strNewData;

                        dgv_Scheduled.Rows[iSelIndex].Cells["M.Code"].Value = strMatchCode;

                        string strMatchID = this.dgv_Scheduled.Rows[iSelIndex].Cells["F_MatchID"].Value.ToString();
                        UpdateMatchCode(strMatchID, strMatchCode);

                        int iMatchID = Convert.ToInt32(strMatchID);
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                    }
                    catch (Exception ex)
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                    }
                }
            }
            else
            {
                string strMatchIDList = "";
                foreach (int iSelIndex in arSelIndex)
                {
                    string strMatchID = dgv_Scheduled.Rows[iSelIndex].Cells["F_MatchID"].Value.ToString();
                    strMatchIDList += strMatchID;
                    strMatchIDList += ",";

                    int iMatchID = Convert.ToInt32(strMatchID);
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                }
                if (strMatchIDList.Length != 0)
                {
                    strMatchIDList = strMatchIDList.Substring(0, strMatchIDList.Length - 1);

                    try
                    {
                        string strPreFix = frmMatchCodeSetting.PreFix;
                        int nStartNumber = frmMatchCodeSetting.StartNumber;
                        int nStep = frmMatchCodeSetting.Step;
                        int nLength = frmMatchCodeSetting.CodeLength;

                        if (this.SetMatchCodeByTime(strMatchIDList, strPreFix, nStartNumber, nStep, nLength))
                        {
                            this.Update_ScheduledGrid();
                        }
                    }
                    catch (Exception ex)
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                    }
                }
            }

            if (changedList.Count > 0)
                m_matchScheduleModule.DataChangedNotify(changedList);

        }

        private void MenuSetMatchDate_Click(object sender, EventArgs e)
        {
            string strSectionName = OVRMatchScheduleModule.GetSectionName();
            MatchDateSettingForm frmMatchDateSetting = new MatchDateSettingForm(strSectionName);
            frmMatchDateSetting.DatabaseConnection = this.m_matchScheduleModule.DatabaseConnection;
            frmMatchDateSetting.m_strDisciplineID = m_strDisciplineID;
            frmMatchDateSetting.m_strLanguageCode = m_strActiveLanguageCode;
            frmMatchDateSetting.ShowDialog();

            if (frmMatchDateSetting.DialogResult != DialogResult.OK || this.dgv_Scheduled.SelectedRows.Count < 1)
                return;

            List<OVRDataChanged> changedList = new List<OVRDataChanged>();

            DataGridViewSelectedRowCollection l_Rows = this.dgv_Scheduled.SelectedRows;
            foreach (DataGridViewRow r in l_Rows)
            {
                try
                {
                    string strOldData = "";
                    if (dgv_Scheduled.Rows[r.Index].Cells["Date"].Value != null)
                        strOldData = dgv_Scheduled.Rows[r.Index].Cells["Date"].Value.ToString();
                    string strNewData = frmMatchDateSetting.m_strDate;

                    if (strNewData == strOldData)
                        continue;

                    string strDate = strNewData;
                    string strOldSessionID = dgv_Scheduled.Rows[r.Index].Cells["F_SessionID"].Value.ToString();

                    dgv_Scheduled.Rows[r.Index].Cells["Date"].Value = strDate;

                    dgv_Scheduled.Rows[r.Index].Cells["Session"].Value = DBNull.Value;
                    dgv_Scheduled.Rows[r.Index].Cells["F_SessionID"].Value = DBNull.Value;

                    string strMatchID = this.dgv_Scheduled.Rows[r.Index].Cells["F_MatchID"].Value.ToString();
                    UpdateMatchDate(strMatchID, strDate);
                    UpdateMatchSession(strMatchID, "");

                    int iMatchID = Convert.ToInt32(strMatchID);
                    int iOldSessionID = -1;
                    if (strOldSessionID.Length != 0)
                        iOldSessionID = Convert.ToInt32(strOldSessionID);

                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchDate, -1, -1, -1, iMatchID, iMatchID, null));
                    if (strOldSessionID.Length != 0)
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionReset, -1, -1, -1, iMatchID, iOldSessionID, null));
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }

            if (changedList.Count > 0)
                m_matchScheduleModule.DataChangedNotify(changedList);
        }

        private void MenuSetMatchSession_Click(object sender, EventArgs e)
        {
            string strSectionName = OVRMatchScheduleModule.GetSectionName();
            MatchSessionSettingForm frmMatchSessionSetting = new MatchSessionSettingForm(strSectionName);
            frmMatchSessionSetting.DatabaseConnection = this.m_matchScheduleModule.DatabaseConnection;
            frmMatchSessionSetting.m_strDisciplineID = m_strDisciplineID;
            frmMatchSessionSetting.m_strLanguageCode = m_strActiveLanguageCode;
            frmMatchSessionSetting.ShowDialog();

            if (frmMatchSessionSetting.DialogResult != DialogResult.OK || this.dgv_Scheduled.SelectedRows.Count < 1)
                return;

            List<OVRDataChanged> changedList = new List<OVRDataChanged>();

            DataGridViewSelectedRowCollection l_Rows = this.dgv_Scheduled.SelectedRows;
            foreach (DataGridViewRow r in l_Rows)
            {
                try
                {
                    string strOldData = "";
                    if (dgv_Scheduled.Rows[r.Index].Cells["F_SessionID"].Value != null)
                        strOldData = dgv_Scheduled.Rows[r.Index].Cells["F_SessionID"].Value.ToString();
                    string strNewData = frmMatchSessionSetting.m_strSessionID;

                    if (strNewData == strOldData)
                        continue;

                    string strDate = frmMatchSessionSetting.m_strDate;
                    string strSessionID = strNewData;
                    string strSession = frmMatchSessionSetting.m_strSession;

                    dgv_Scheduled.Rows[r.Index].Cells["Date"].Value = strDate;
                    if (strSessionID.Length == 0)
                    {
                        dgv_Scheduled.Rows[r.Index].Cells["F_SessionID"].Value = DBNull.Value;
                    }
                    else
                    {
                        dgv_Scheduled.Rows[r.Index].Cells["F_SessionID"].Value = strSessionID;
                    }
                    dgv_Scheduled.Rows[r.Index].Cells["Session"].Value = strSession;

                    string strMatchID = this.dgv_Scheduled.Rows[r.Index].Cells["F_MatchID"].Value.ToString();
                    UpdateMatchDate(strMatchID, strDate);
                    UpdateMatchSession(strMatchID, strSessionID);

                    int iMatchID = Convert.ToInt32(strMatchID);
                    int iOldSessionID = -1;
                    if (strOldData.Length != 0)
                        iOldSessionID = Convert.ToInt32(strOldData);
                    int iNewSessionID = -1;
                    if (strNewData.Length != 0)
                        iNewSessionID = Convert.ToInt32(strNewData);

                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchDate, -1, -1, -1, iMatchID, iMatchID, null));
                    if (strOldData.Length != 0)
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionReset, -1, -1, -1, iMatchID, iOldSessionID, null));
                    if (strNewData.Length != 0)
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionSet, -1, -1, -1, iMatchID, iNewSessionID, null));
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }

            if (changedList.Count > 0)
                m_matchScheduleModule.DataChangedNotify(changedList);
        }

        private void MenuSetMatchStartTime_Click(object sender, EventArgs e)
        {
            string strSectionName = OVRMatchScheduleModule.GetSectionName();
            MatchStartTimeSettingForm frmMatchStartTimeSetting = new MatchStartTimeSettingForm(strSectionName);
            frmMatchStartTimeSetting.DatabaseConnection = this.m_matchScheduleModule.DatabaseConnection;
            frmMatchStartTimeSetting.ShowDialog();

            if (frmMatchStartTimeSetting.DialogResult != DialogResult.OK || this.dgv_Scheduled.SelectedRows.Count < 1)
                return;

            DataGridViewSelectedRowCollection l_Rows = this.dgv_Scheduled.SelectedRows;
            int[] arSelIndex = new int[l_Rows.Count];
            int i = 0;
            foreach (DataGridViewRow r in l_Rows)
            {
                arSelIndex[i++] = r.Index;
            }
            Array.Sort(arSelIndex);

            List<OVRDataChanged> changedList = new List<OVRDataChanged>();

            int iRowIdx = 0;
            foreach (int iSelIndex in arSelIndex)
            {
                try
                {
                    if (!frmMatchStartTimeSetting.m_bChkAdvanceTime
                        &&!frmMatchStartTimeSetting.m_bChkDelayTime)
                    {
                        string strOldStartTime = "";
                        if (dgv_Scheduled.Rows[iSelIndex].Cells["StartTime"].Value != null)
                            strOldStartTime = dgv_Scheduled.Rows[iSelIndex].Cells["StartTime"].Value.ToString();
                        string strOldEndTime = "";
                        if (dgv_Scheduled.Rows[iSelIndex].Cells["EndTime"].Value != null)
                            strOldEndTime = dgv_Scheduled.Rows[iSelIndex].Cells["EndTime"].Value.ToString();
                        string strNewStartTime = "";
                        string strNewEndTime = "";

                        string strStartTime = frmMatchStartTimeSetting.m_strStartTime;
                        string strSpendTime = frmMatchStartTimeSetting.m_strSpendTime;
                        string strSpanTime = frmMatchStartTimeSetting.m_strSpanTime;

                        if (strStartTime.Length == 0
                            && strSpendTime.Length == 0
                            && strSpanTime.Length == 0)
                        {
                            strNewStartTime = "";
                            strNewEndTime = "";
                        }
                        else
                        {
                            if (strStartTime.Length == 0)
                                strStartTime = "00:00:00";
                            if (strSpendTime.Length == 0)
                                strSpendTime = "00:00:00";
                            if (strSpanTime.Length == 0)
                                strSpanTime = "00:00:00";
                            DateTime tStartTime = DateTime.Parse(strStartTime);
                            TimeSpan tsSpend = TimeSpan.Parse(strSpendTime);
                            TimeSpan tsSpan = TimeSpan.Parse(strSpanTime);
                            for (int n = 0; n < iRowIdx; n++)
                            {
                                tStartTime += tsSpend;
                                tStartTime += tsSpan;
                            }
                            DateTime tEndTime = tStartTime + tsSpend;
                            strNewStartTime = tStartTime.ToString("HH:mm");
                            strNewEndTime = tEndTime.ToString("HH:mm");
                            if (strSpendTime == "00:00:00")
                                strNewEndTime = "";
                        }
                        iRowIdx++;

                        if (strNewStartTime == strOldStartTime
                            && strNewEndTime == strOldEndTime)
                            continue;

                        dgv_Scheduled.Rows[iSelIndex].Cells["StartTime"].Value = strNewStartTime;
                        dgv_Scheduled.Rows[iSelIndex].Cells["EndTime"].Value = strNewEndTime;

                        string strMatchID = this.dgv_Scheduled.Rows[iSelIndex].Cells["F_MatchID"].Value.ToString();
                        UpdateMatchStartTime(strMatchID, strNewStartTime);
                        UpdateMatchEndTime(strMatchID, strNewEndTime);

                        int iMatchID = Convert.ToInt32(strMatchID);
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                    }
                    else if (frmMatchStartTimeSetting.m_bChkAdvanceTime)
                    {
                        string strAdvanceTime = frmMatchStartTimeSetting.m_strAdvanceTime;
                        if (strAdvanceTime.Length == 0)
                            continue;

                        string strOldStartTime = "";
                        if (dgv_Scheduled.Rows[iSelIndex].Cells["StartTime"].Value != null)
                            strOldStartTime = dgv_Scheduled.Rows[iSelIndex].Cells["StartTime"].Value.ToString();
                        string strOldEndTime = "";
                        if (dgv_Scheduled.Rows[iSelIndex].Cells["EndTime"].Value != null)
                            strOldEndTime = dgv_Scheduled.Rows[iSelIndex].Cells["EndTime"].Value.ToString();
                        if (strOldStartTime.Length == 0)
                            strOldStartTime = "00:00:00";
                        if (strOldEndTime.Length == 0)
                            strOldEndTime = "00:00:00";

                        DateTime tOldStartTime = DateTime.Parse(strOldStartTime);
                        DateTime tOldEndTime = DateTime.Parse(strOldEndTime);
                        TimeSpan ts = TimeSpan.Parse(strAdvanceTime);
                        tOldStartTime -= ts;
                        tOldEndTime -= ts;
                        string strNewStartTime = tOldStartTime.ToString("HH:mm");
                        string strNewEndTime = tOldEndTime.ToString("HH:mm");
                        if (strOldEndTime == "00:00:00")
                            strNewEndTime = "";

                        dgv_Scheduled.Rows[iSelIndex].Cells["StartTime"].Value = strNewStartTime;
                        dgv_Scheduled.Rows[iSelIndex].Cells["EndTime"].Value = strNewEndTime;

                        string strMatchID = this.dgv_Scheduled.Rows[iSelIndex].Cells["F_MatchID"].Value.ToString();
                        UpdateMatchStartTime(strMatchID, strNewStartTime);
                        UpdateMatchEndTime(strMatchID, strNewEndTime);

                        int iMatchID = Convert.ToInt32(strMatchID);
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                    }
                    else if (frmMatchStartTimeSetting.m_bChkDelayTime)
                    {
                        string strDelayTime = frmMatchStartTimeSetting.m_strDelayTime;
                        if (strDelayTime.Length == 0)
                            continue;

                        string strOldStartTime = "";
                        if (dgv_Scheduled.Rows[iSelIndex].Cells["StartTime"].Value != null)
                            strOldStartTime = dgv_Scheduled.Rows[iSelIndex].Cells["StartTime"].Value.ToString();
                        string strOldEndTime = "";
                        if (dgv_Scheduled.Rows[iSelIndex].Cells["EndTime"].Value != null)
                            strOldEndTime = dgv_Scheduled.Rows[iSelIndex].Cells["EndTime"].Value.ToString();
                        if (strOldStartTime.Length == 0)
                            strOldStartTime = "00:00:00";
                        if (strOldEndTime.Length == 0)
                            strOldEndTime = "00:00:00";

                        DateTime tOldStartTime = DateTime.Parse(strOldStartTime);
                        DateTime tOldEndTime = DateTime.Parse(strOldEndTime);
                        TimeSpan ts = TimeSpan.Parse(strDelayTime);
                        tOldStartTime += ts;
                        tOldEndTime += ts;
                        string strNewStartTime = tOldStartTime.ToString("HH:mm");
                        string strNewEndTime = tOldEndTime.ToString("HH:mm");
                        if (strOldEndTime == "00:00:00")
                            strNewEndTime = "";

                        dgv_Scheduled.Rows[iSelIndex].Cells["StartTime"].Value = strNewStartTime;
                        dgv_Scheduled.Rows[iSelIndex].Cells["EndTime"].Value = strNewEndTime;

                        string strMatchID = this.dgv_Scheduled.Rows[iSelIndex].Cells["F_MatchID"].Value.ToString();
                        UpdateMatchStartTime(strMatchID, strNewStartTime);
                        UpdateMatchEndTime(strMatchID, strNewEndTime);

                        int iMatchID = Convert.ToInt32(strMatchID);
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                    }
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }

            if (changedList.Count > 0)
                m_matchScheduleModule.DataChangedNotify(changedList);
        }

        private void MenuSetMatchEndTime_Click(object sender, EventArgs e)
        {
            string strSectionName = OVRMatchScheduleModule.GetSectionName();
            MatchEndTimeSettingForm frmMatchEndTimeSetting = new MatchEndTimeSettingForm(strSectionName);
            frmMatchEndTimeSetting.DatabaseConnection = this.m_matchScheduleModule.DatabaseConnection;
            frmMatchEndTimeSetting.ShowDialog();

            if (frmMatchEndTimeSetting.DialogResult != DialogResult.OK || this.dgv_Scheduled.SelectedRows.Count < 1)
                return;

            DataGridViewSelectedRowCollection l_Rows = this.dgv_Scheduled.SelectedRows;
            int[] arSelIndex = new int[l_Rows.Count];
            int i = 0;
            foreach (DataGridViewRow r in l_Rows)
            {
                arSelIndex[i++] = r.Index;
            }
            Array.Sort(arSelIndex);

            List<OVRDataChanged> changedList = new List<OVRDataChanged>();

            int iRowIdx = 0;
            foreach (int iSelIndex in arSelIndex)
            {
                try
                {
                    string strOldEndTime = "";
                    if (dgv_Scheduled.Rows[iSelIndex].Cells["EndTime"].Value != null)
                        strOldEndTime = dgv_Scheduled.Rows[iSelIndex].Cells["EndTime"].Value.ToString();
                    string strNewEndTime = "";

                    string strEndTime = frmMatchEndTimeSetting.m_strEndTime;
                    string strSpanTime = frmMatchEndTimeSetting.m_strSpanTime;

                    if (strEndTime.Length == 0
                        && strSpanTime.Length == 0)
                    {
                        strNewEndTime = "";
                    }
                    else
                    {
                        if (strEndTime.Length == 0)
                            strEndTime = "00:00:00";
                        if (strSpanTime.Length == 0)
                            strSpanTime = "00:00:00";
                        DateTime tEndTime = DateTime.Parse(strEndTime);
                        TimeSpan tsSpan = TimeSpan.Parse(strSpanTime);
                        for (int n = 0; n < iRowIdx; n++)
                        {
                            tEndTime += tsSpan;
                        }
                        strNewEndTime = tEndTime.ToString("HH:mm");
                    }
                    iRowIdx++;

                    if (strNewEndTime == strOldEndTime)
                        continue;

                    dgv_Scheduled.Rows[iSelIndex].Cells["EndTime"].Value = strNewEndTime;

                    string strMatchID = this.dgv_Scheduled.Rows[iSelIndex].Cells["F_MatchID"].Value.ToString();
                    UpdateMatchEndTime(strMatchID, strNewEndTime);

                    int iMatchID = Convert.ToInt32(strMatchID);
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }

            if (changedList.Count > 0)
                m_matchScheduleModule.DataChangedNotify(changedList);
        }

        private void MenuSetMatchVenue_Click(object sender, EventArgs e)
        {
            string strSectionName = OVRMatchScheduleModule.GetSectionName();
            MatchVenueSettingForm frmMatchVenueSetting = new MatchVenueSettingForm(strSectionName);
            frmMatchVenueSetting.DatabaseConnection = this.m_matchScheduleModule.DatabaseConnection;
            frmMatchVenueSetting.m_strDisciplineID = m_strDisciplineID;
            frmMatchVenueSetting.m_strLanguageCode = m_strActiveLanguageCode;
            frmMatchVenueSetting.ShowDialog();

            if (frmMatchVenueSetting.DialogResult != DialogResult.OK || this.dgv_Scheduled.SelectedRows.Count < 1)
                return;

            List<OVRDataChanged> changedList = new List<OVRDataChanged>();

            DataGridViewSelectedRowCollection l_Rows = this.dgv_Scheduled.SelectedRows;
            foreach (DataGridViewRow r in l_Rows)
            {
                try
                {
                    string strOldData = "";
                    if (dgv_Scheduled.Rows[r.Index].Cells["F_VenueID"].Value != null)
                        strOldData = dgv_Scheduled.Rows[r.Index].Cells["F_VenueID"].Value.ToString();
                    string strNewData = frmMatchVenueSetting.m_strVenueID;

                    if (strNewData == strOldData)
                        continue;

                    string strVenueID = strNewData;
                    string strVenue = frmMatchVenueSetting.m_strVenue;
                    string strOldCourtID = dgv_Scheduled.Rows[r.Index].Cells["F_CourtID"].Value.ToString();

                    if (strVenueID.Length == 0)
                    {
                        dgv_Scheduled.Rows[r.Index].Cells["F_VenueID"].Value = DBNull.Value;
                        dgv_Scheduled.Rows[r.Index].Cells["Venue"].Value = DBNull.Value;
                    }
                    else
                    {
                        dgv_Scheduled.Rows[r.Index].Cells["F_VenueID"].Value = strVenueID;
                        dgv_Scheduled.Rows[r.Index].Cells["Venue"].Value = strVenue;
                    }

                    dgv_Scheduled.Rows[r.Index].Cells["Court"].Value = DBNull.Value;
                    dgv_Scheduled.Rows[r.Index].Cells["F_CourtID"].Value = DBNull.Value;

                    string strMatchID = this.dgv_Scheduled.Rows[r.Index].Cells["F_MatchID"].Value.ToString();
                    UpdateMatchVenue(strMatchID, strVenueID);
                    UpdateMatchCourt(strMatchID, "");

                    int iMatchID = Convert.ToInt32(strMatchID);
                    int iOldCourtID = -1;
                    if (strOldCourtID.Length != 0)
                        iOldCourtID = Convert.ToInt32(strOldCourtID);

                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iOldCourtID, null));
                    if (strOldCourtID.Length != 0)
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtReset, -1, -1, -1, iMatchID, iOldCourtID, null));
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }

            if (changedList.Count > 0)
                m_matchScheduleModule.DataChangedNotify(changedList);
        }

        private void MenuSetMatchCourt_Click(object sender, EventArgs e)
        {
            string strSectionName = OVRMatchScheduleModule.GetSectionName();
            MatchCourtSettingForm frmMatchCourtSetting = new MatchCourtSettingForm(strSectionName);
            frmMatchCourtSetting.DatabaseConnection = this.m_matchScheduleModule.DatabaseConnection;
            frmMatchCourtSetting.m_strDisciplineID = m_strDisciplineID;
            frmMatchCourtSetting.m_strLanguageCode = m_strActiveLanguageCode;
            frmMatchCourtSetting.ShowDialog();

            if (frmMatchCourtSetting.DialogResult != DialogResult.OK || this.dgv_Scheduled.SelectedRows.Count < 1)
                return;

            List<OVRDataChanged> changedList = new List<OVRDataChanged>();

            DataGridViewSelectedRowCollection l_Rows = this.dgv_Scheduled.SelectedRows;
            foreach (DataGridViewRow r in l_Rows)
            {
                try
                {
                    string strOldData = "";
                    if (dgv_Scheduled.Rows[r.Index].Cells["F_CourtID"].Value != null)
                        strOldData = dgv_Scheduled.Rows[r.Index].Cells["F_CourtID"].Value.ToString();
                    string strNewData = frmMatchCourtSetting.m_strCourtID;

                    if (strNewData == strOldData)
                        continue;

                    string strVenueID = frmMatchCourtSetting.m_strVenueID;
                    string strCourtID = strNewData;
                    string strVenue = frmMatchCourtSetting.m_strVenue;
                    string strCourt = frmMatchCourtSetting.m_strCourt;

                    if (strVenueID.Length == 0)
                    {
                        dgv_Scheduled.Rows[r.Index].Cells["F_VenueID"].Value = DBNull.Value;
                        dgv_Scheduled.Rows[r.Index].Cells["Venue"].Value = DBNull.Value;
                    }
                    else
                    {
                        dgv_Scheduled.Rows[r.Index].Cells["F_VenueID"].Value = strVenueID;
                        dgv_Scheduled.Rows[r.Index].Cells["Venue"].Value = strVenue;
                    }
                    if (strCourtID.Length == 0)
                    {
                        dgv_Scheduled.Rows[r.Index].Cells["F_CourtID"].Value = DBNull.Value;
                        dgv_Scheduled.Rows[r.Index].Cells["Court"].Value = DBNull.Value;
                    }
                    else
                    {
                        dgv_Scheduled.Rows[r.Index].Cells["F_CourtID"].Value = strCourtID;
                        dgv_Scheduled.Rows[r.Index].Cells["Court"].Value = strCourt;
                    }

                    string strMatchID = this.dgv_Scheduled.Rows[r.Index].Cells["F_MatchID"].Value.ToString();
                    UpdateMatchVenue(strMatchID, strVenueID);
                    UpdateMatchCourt(strMatchID, strCourtID);

                    int iMatchID = Convert.ToInt32(strMatchID);
                    int iOldCourtID = -1;
                    if (strOldData.Length != 0)
                        iOldCourtID = Convert.ToInt32(strOldData);
                    int iNewCourtID = -1;
                    if (strNewData.Length != 0)
                        iNewCourtID = Convert.ToInt32(strNewData);

                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iOldCourtID, null));
                    if (strOldData.Length != 0)
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtReset, -1, -1, -1, iMatchID, iOldCourtID, null));
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtSet, -1, -1, -1, iMatchID, iNewCourtID, null));
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }

            if (changedList.Count > 0)
                m_matchScheduleModule.DataChangedNotify(changedList);
        }


        private void MenuSetMatchOIS_Click(object sender, EventArgs e)
        {
            string strSectionName = OVRMatchScheduleModule.GetSectionName();
            OrderInSessionSettingForm frmOrderInSessionSetting = new OrderInSessionSettingForm(strSectionName);
            frmOrderInSessionSetting.DatabaseConnection = this.m_matchScheduleModule.DatabaseConnection;
            frmOrderInSessionSetting.ShowDialog();

            if (frmOrderInSessionSetting.DialogResult != DialogResult.OK || this.dgv_Scheduled.SelectedRows.Count < 1)
                return;

            DataGridViewSelectedRowCollection l_Rows = this.dgv_Scheduled.SelectedRows;
            int[] arSelIndex = new int[l_Rows.Count];
            int i = 0;
            foreach (DataGridViewRow r in l_Rows)
            {
                arSelIndex[i++] = r.Index;
            }
            Array.Sort(arSelIndex);

            List<OVRDataChanged> changedList = new List<OVRDataChanged>();

            int iRowIdx = 0;
            foreach (int iSelIndex in arSelIndex)
            {
                try
                {
                    string strOldData = "";
                    if (dgv_Scheduled.Rows[iSelIndex].Cells["O.I.S"].Value != null)
                        strOldData = dgv_Scheduled.Rows[iSelIndex].Cells["O.I.S"].Value.ToString();
                    string strNewData = "";

                    int iCode = frmOrderInSessionSetting.StartNumber;
                    if (iCode > -1)
                    {
                        iCode += iRowIdx * frmOrderInSessionSetting.Step;
                        strNewData = iCode.ToString();
                    }
                    int iLength = frmOrderInSessionSetting.CodeLength;
                    if (iLength < 1)
                        strNewData = "";

                    iRowIdx++;

                    if (strNewData == strOldData)
                        continue;

                    string strOrderInSession = strNewData;

                    dgv_Scheduled.Rows[iSelIndex].Cells["O.I.S"].Value = strOrderInSession;

                    string strMatchID = this.dgv_Scheduled.Rows[iSelIndex].Cells["F_MatchID"].Value.ToString();
                    this.UpdateMatchOrderInSession(strMatchID, strOrderInSession);

                    int iMatchID = Convert.ToInt32(strMatchID);
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchOrderInSession, -1, -1, -1, iMatchID, iMatchID, null));
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }

            if (changedList.Count > 0)
                m_matchScheduleModule.DataChangedNotify(changedList);
        }

        private void MenuSetMatchOIR_Click(object sender, EventArgs e)
        {
            string strSectionName = OVRMatchScheduleModule.GetSectionName();
            OrderInRoundSettingForm frmOrderInRoundSetting = new OrderInRoundSettingForm(strSectionName);
            frmOrderInRoundSetting.DatabaseConnection = this.m_matchScheduleModule.DatabaseConnection;
            frmOrderInRoundSetting.ShowDialog();

            if (frmOrderInRoundSetting.DialogResult != DialogResult.OK || this.dgv_Scheduled.SelectedRows.Count < 1)
                return;

            DataGridViewSelectedRowCollection l_Rows = this.dgv_Scheduled.SelectedRows;
            int[] arSelIndex = new int[l_Rows.Count];
            int i = 0;
            foreach (DataGridViewRow r in l_Rows)
            {
                arSelIndex[i++] = r.Index;
            }
            Array.Sort(arSelIndex);

            List<OVRDataChanged> changedList = new List<OVRDataChanged>();

            int iRowIdx = 0;
            foreach (int iSelIndex in arSelIndex)
            {
                try
                {
                    string strOldData = "";
                    if (dgv_Scheduled.Rows[iSelIndex].Cells["O.I.R"].Value != null)
                        strOldData = dgv_Scheduled.Rows[iSelIndex].Cells["O.I.R"].Value.ToString();
                    string strNewData = "";

                    int iCode = frmOrderInRoundSetting.StartNumber;
                    if (iCode > -1)
                    {
                        iCode += iRowIdx * frmOrderInRoundSetting.Step;
                        strNewData = iCode.ToString();
                    }
                    int iLength = frmOrderInRoundSetting.CodeLength;
                    if (iLength < 1)
                        strNewData = "";

                    iRowIdx++;

                    if (strNewData == strOldData)
                        continue;

                    string strOrderInRound = strNewData;

                    dgv_Scheduled.Rows[iSelIndex].Cells["O.I.R"].Value = strOrderInRound;

                    string strMatchID = this.dgv_Scheduled.Rows[iSelIndex].Cells["F_MatchID"].Value.ToString();
                    this.UpdateMatchOrderInRound(strMatchID, strOrderInRound);

                    int iMatchID = Convert.ToInt32(strMatchID);
                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchOrderInRound, -1, -1, -1, iMatchID, iMatchID, null));
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }
    }
}