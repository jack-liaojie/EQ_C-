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
using DevComponents.DotNetBar;
using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    public partial class OVRMatchScheduleForm : UIPage
    {
        private OVRMatchScheduleModule m_matchScheduleModule;

        public OVRMatchScheduleModule MatchScheduleModule
        {
            set { m_matchScheduleModule = value; }
        }

        private System.Data.DataTable m_dtOldScheduled;

        private string m_strLastSelPhaseTreeNodeKey;

        private string m_strActiveLanguageCode = "CHN";
        private int    m_iActiveSportID = 0;
        private int    m_iActiveDisciplineID = 0;

        private string m_strDisciplineID = "-1";
        private string m_strTreeEventID = "";
        private string m_strTreePhaseID = "";
        private string m_strTreeMatchID = "";
        private string m_strTreeType = "";
        private string m_strDateID = "";
        private string m_strDate = "";
        private string m_strSessionID = "";
        private string m_strVenueID = "";
        private string m_strCourtID = "";
        private string m_strEventID = "";
        private string m_strPhaseID = "";
        private string m_strRoundID = "";
        private string m_strStatusID = "30";
        private int m_IsChecked = 0;
        private string m_strStartTime = "";
        private string m_strSpendTime = "";
        private string m_strSpanTime = "";


        public OVRMatchScheduleForm(string strName)
        {
            InitializeComponent();

            this.Name = strName;
        }

        public void OnMainFrameEvent(object sender, OVRFrame2ModuleEventArgs e)
        {
            switch (e.Type)
            {
                case OVRFrame2ModuleEventType.emLoadData:
                    {
                        LoadData();
                        break;
                    }
                case OVRFrame2ModuleEventType.emUpdateData:
                    {
                        UpdateData(e.Args as OVRDataChangedFlags);
                        break;
                    }
                case OVRFrame2ModuleEventType.emRptContextQuery:
                    {
                        QueryReportContext(e.Args as OVRReportContextQueryArgs);
                        break;
                    }
            }
        }

        private void QueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;

            switch (args.Name)
            {
                case "SportID":
                    {
                        if (advTree.Visible && advTree.SelectedNode != null)
                        {
                            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)advTree.SelectedNode.Tag;
                            args.Value = oneSNodeInfo.iSportID.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "DisciplineID":
                    {
                        if (advTree.Visible && advTree.SelectedNode != null)
                        {
                            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)advTree.SelectedNode.Tag;
                            args.Value = oneSNodeInfo.iDisciplineID.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "EventID":
                    {
                        if (advTree.Visible && advTree.SelectedNode != null)
                        {
                            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)advTree.SelectedNode.Tag;
                            args.Value = oneSNodeInfo.iEventID.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "PhaseID":
                    {
                        if (advTree.Visible && advTree.SelectedNode != null)
                        {
                            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)advTree.SelectedNode.Tag;
                            args.Value = oneSNodeInfo.iPhaseID.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "MatchID":
                    {
                        if (dgv_Scheduled.Visible && dgv_Scheduled.SelectedRows.Count > 0)
                        {
                            args.Value = dgv_Scheduled.SelectedRows[0].Cells["F_MatchID"].Value.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "RoundID":
                    {
                        if (cbEx_Round.Visible)
                        {
                            args.Value = cbEx_Round.SelectedValue.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "SessionID":
                    {
                        if (cbEx_Session.Visible)
                        {
                            args.Value = cbEx_Session.SelectedValue.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "DateID":
                    {
                        if (cbEx_Date.Visible)
                        {
                            args.Value = cbEx_Date.SelectedValue.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
            }
        }

        private void LoadData()
        {
            this.Init_ActiveInfo();
            this.RefreshPhaseTree();

            this.Update_DateComBox();
            this.Update_SessionComBox();
            this.Update_VenueComBox();
            this.Update_CourtComBox();
            this.Update_EventComBox();
            this.Update_PhaseComBox();
            this.Update_RoundComBox();
            this.Update_StatusComBox();

            //this.Update_UnScheduledGrid(); // RefreshPhaseTree() Will Trigger a calling of this function
            this.Update_ScheduledGrid();
        }

        private void UpdateData(OVRDataChangedFlags flags)
        {
            if (flags == null || !flags.HasSignal)
                return;

            if (IsUpdateAllData(flags))
            {
                LoadData();
                return;
            }

            bool bIsUpdateMatchGrid = IsUpdateMatchGrid(flags);

            if (IsUpdateTree(flags))
            {
                RefreshPhaseTree(); // RefreshPhaseTree() Will Trigger a calling of this function
            }
            else if (bIsUpdateMatchGrid)
            {
                Update_UnScheduledGrid();
            }

            if (bIsUpdateMatchGrid)
            {
                Update_ScheduledGrid();
            }

            if (flags.IsSignaled(OVRDataChangedType.emEventAdd) ||
                flags.IsSignaled(OVRDataChangedType.emEventDel) ||
                flags.IsSignaled(OVRDataChangedType.emEventInfo))
            {
                Update_EventComBox();
            }

            if (flags.IsSignaled(OVRDataChangedType.emVenueAdd) ||
                flags.IsSignaled(OVRDataChangedType.emVenueDel) ||
                flags.IsSignaled(OVRDataChangedType.emVenueInfo))
            {
                Update_VenueComBox();
            }

            if (flags.IsSignaled(OVRDataChangedType.emCourtAdd) ||
                flags.IsSignaled(OVRDataChangedType.emCourtDel) ||
                flags.IsSignaled(OVRDataChangedType.emCourtInfo))
            {
                Update_CourtComBox();
            }
        }

        private void OVRMatchScheduleFrom_Load(object sender, EventArgs e)
        {
            this.Localization();
            this.Init_ActiveInfo();

            this.Update_DateComBox();
            this.Update_SessionComBox();
            this.Update_VenueComBox();
            this.Update_CourtComBox();
            this.Update_EventComBox();
            this.Update_PhaseComBox();
            this.Update_RoundComBox();
            this.Update_StatusComBox();

            this.Init_UnScheduledGrid();
            this.Init_ScheduledGrid();

            this.RefreshPhaseTree();
        }

        private bool IsUpdateAllData(OVRDataChangedFlags flags)
        {
            if (flags == null) return false;

            if (flags.IsSignaled(OVRDataChangedType.emLangActive))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emSportActive))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emDisciplineActive))
                return true;

            return false;
        }

        private bool IsUpdateTree(OVRDataChangedFlags flags)
        {
            if (flags == null) return false;

            if (flags.IsSignaled(OVRDataChangedType.emSportInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emDisciplineInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventAdd))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventDel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventModel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emPhaseAdd))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emPhaseDel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emPhaseModel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emPhaseInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchAdd))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchDel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchInfo))
                return true;

            return false;
        }

        private bool IsUpdateMatchGrid(OVRDataChangedFlags flags)
        {
            if (m_matchScheduleModule == null) return false;

            if (flags.IsSignaled(OVRDataChangedType.emEventInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventAdd))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventDel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventModel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emPhaseAdd))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emPhaseDel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emPhaseModel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emPhaseProgress))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchAdd))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchDel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchModel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchCompetitor))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchStatus))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchDate))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchSessionSet))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchSessionReset))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchCourtSet))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchCourtReset))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchResult))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchProgress))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emRegisterModify))
                return true;

            return false;
        }

        private void Localization()
        {
            string strSectionName = OVRMatchScheduleModule.GetSectionName();
            this.tabItem_Schedule.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_tabItemSchedule");
            this.btnX_Add.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_btnXAdd");
            this.btnX_AddAll.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_btnXAddAll");
            this.btnX_Date.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_btnXDate");
            this.btnX_Session.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_btnXSession");
            this.btnX_Round.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_btnXRound");
            this.btnX_Remove.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_btnXRemove");
            this.btnX_RemoveAll.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_btnXRemoveAll");
            //this.btnX_SearchMatches.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_btnXSearchMatches");
            this.labX_Date.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_labXDate");
            this.labX_Session.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_labXSession");
            this.labX_Venue.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_labXVenue");
            this.labX_Court.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_labXCourt");
            this.labX_Event.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_labXEvent");
            this.labX_Phase.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_labXPhase");
            this.labX_Round.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_labXRound");
            this.chkX_Status.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_chkXStatus");
            this.chkX_Time.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_chkXTime");
            this.labX_StartTime.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_labXStartTime");
            this.labX_SpendTime.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_labXSpendTime");
            this.labX_SpanTime.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_labXSpanTime");

            this.MenuSetRaceNumber.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_menuSetRaceNumber");
            this.MenuSetMatchCode.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_menuSetMatchCode");
            this.MenuSetMatchDate.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_menuSetMatchDate");
            this.MenuSetMatchSession.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_menuSetMatchSession");
            this.MenuSetMatchStartTime.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_menuSetMatchStartTime");
            this.MenuSetMatchEndTime.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_menuSetMatchEndTime");
            this.MenuSetMatchVenue.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_menuSetMatchVenue");
            this.MenuSetMatchCourt.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_menuSetMatchCourt");
            this.MenuSetMatchOIS.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_menuSetMatchOIS");
            this.MenuSetMatchOIR.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRMatchScheduleFrom_menuSetMatchOIR");
        }

        private void Init_ActiveInfo()
        {
            OVRDataBaseUtils.GetActiveInfo(m_matchScheduleModule.DatabaseConnection, out m_iActiveSportID, out m_iActiveDisciplineID, out m_strActiveLanguageCode);
        }

        private void Update_DateComBox()
        {
            System.Data.DataTable dt = this.GetDateTable();

            cbEx_Date.DataSource = dt;
            cbEx_Date.ValueMember = "F_ID";
            cbEx_Date.DisplayMember = "F_Info";

            bool bExist = false;
            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                if (dt.Rows[nRow]["F_ID"].ToString() == m_strDateID)
                {
                    bExist = true;
                    break;
                }
            }
            if (bExist)
            {
                cbEx_Date.SelectedValue = m_strDateID;
            }
            else
            {
                cbEx_Date.SelectedValue = "-1";
                m_strDateID = "";
            }

            AdjustComboBoxDropDownListWidth(cbEx_Date, dt);
        }

        private void Update_SessionComBox()
        {
            string strID = "";
            strID = cbEx_Date.SelectedValue.ToString();

            if (strID == "-1")
            {
                m_strDateID = "";
                m_strDate = "";
            }
            else
            {
                m_strDateID = strID;
                m_strDate = cbEx_Date.Text.ToString();
            }

            if (m_strDate.Length == 0)
            {
                System.Data.DataTable dt = new DataTable();
                dt.Columns.Add("F_ID");
                dt.Columns.Add("F_Info");

                dt.Rows.Add("-1", "Invalid");

                cbEx_Session.DataSource = dt;
                cbEx_Session.ValueMember = "F_ID";
                cbEx_Session.DisplayMember = "F_Info";

                cbEx_Session.SelectedValue = "-1";
                m_strSessionID = "";

                AdjustComboBoxDropDownListWidth(cbEx_Session, dt);
            }
            else
            {
                System.Data.DataTable dt = this.GetSessionTable(m_strDate);

                cbEx_Session.DataSource = dt;
                cbEx_Session.ValueMember = "F_ID";
                cbEx_Session.DisplayMember = "F_Info";

                bool bExist = false;
                for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
                {
                    if (dt.Rows[nRow]["F_ID"].ToString() == m_strSessionID)
                    {
                        bExist = true;
                        break;
                    }
                }
                if (bExist)
                {
                    cbEx_Session.SelectedValue = m_strSessionID;
                }
                else
                {
                    cbEx_Session.SelectedValue = "-1";
                    m_strSessionID = "";
                }

                AdjustComboBoxDropDownListWidth(cbEx_Session, dt);
            }
        }

        private void Update_VenueComBox()
        {
            System.Data.DataTable dt = this.GetVenueTable();

            cbEx_Venue.DataSource = dt;
            cbEx_Venue.ValueMember = "F_ID";
            cbEx_Venue.DisplayMember = "F_Info";

            bool bExist = false;
            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                if (dt.Rows[nRow]["F_ID"].ToString() == m_strVenueID)
                {
                    bExist = true;
                    break;
                }
            }
            if (bExist)
            {
                cbEx_Venue.SelectedValue = m_strVenueID;
            }
            else
            {
                cbEx_Venue.SelectedValue = "-1";
                m_strVenueID = "";
            }

            AdjustComboBoxDropDownListWidth(cbEx_Venue, dt);
        }

        private void Update_CourtComBox()
        {
            string strID = "";
            strID = cbEx_Venue.SelectedValue.ToString();

            if (strID == "-1")
            {
                m_strVenueID = "";
                m_strCourtID = "";
            }
            else
            {
                m_strVenueID = strID;
            }

            if (m_strVenueID.Length == 0)
            {
                System.Data.DataTable dt = new DataTable();
                dt.Columns.Add("F_ID");
                dt.Columns.Add("F_Info");

                dt.Rows.Add("-1", "Invalid");

                cbEx_Court.DataSource = dt;
                cbEx_Court.ValueMember = "F_ID";
                cbEx_Court.DisplayMember = "F_Info";

                cbEx_Court.SelectedValue = "-1";
                m_strCourtID = "";
            
                AdjustComboBoxDropDownListWidth(cbEx_Court, dt);
            }
            else
            {
                System.Data.DataTable dt = this.GetCourtTable(m_strVenueID);

                cbEx_Court.DataSource = dt;
                cbEx_Court.ValueMember = "F_ID";
                cbEx_Court.DisplayMember = "F_Info";

                bool bExist = false;
                for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
                {
                    if (dt.Rows[nRow]["F_ID"].ToString() == m_strCourtID)
                    {
                        bExist = true;
                        break;
                    }
                }
                if (bExist)
                {
                    cbEx_Court.SelectedValue = m_strVenueID;
                }
                else
                {
                    cbEx_Court.SelectedValue = "-1";
                    m_strCourtID = "";
                }

                AdjustComboBoxDropDownListWidth(cbEx_Court, dt);
            }
        }

        private void Update_EventComBox()
        {
            System.Data.DataTable dt = this.GetEventTable();

            cbEx_Event.DataSource = dt;
            cbEx_Event.ValueMember = "F_ID";
            cbEx_Event.DisplayMember = "F_Info";

            bool bExist = false;
            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                if (dt.Rows[nRow]["F_ID"].ToString() == m_strEventID)
                {
                    bExist = true;
                    break;
                }
            }
            if (bExist)
            {
                cbEx_Event.SelectedValue = m_strEventID;
            }
            else
            {
                cbEx_Event.SelectedValue = "-1";
                m_strEventID = "";
            }

            AdjustComboBoxDropDownListWidth(cbEx_Event, dt);
        }

        private void Update_PhaseComBox()
        {
            string strID = "";
            strID = cbEx_Event.SelectedValue.ToString();

            if (strID == "-1")
            {
                m_strEventID = "";
                m_strPhaseID = "";
            }
            else
            {
                m_strEventID = strID;
            }

            if (m_strEventID.Length == 0)
            {
                System.Data.DataTable dt = new DataTable();
                dt.Columns.Add("F_ID");
                dt.Columns.Add("F_Info");

                dt.Rows.Add("-1", "Invalid");

                cbEx_Phase.DataSource = dt;
                cbEx_Phase.ValueMember = "F_ID";
                cbEx_Phase.DisplayMember = "F_Info";

                cbEx_Phase.SelectedValue = "-1";
                m_strPhaseID = "";

                AdjustComboBoxDropDownListWidth(cbEx_Phase, dt);
            }
            else
            {
                System.Data.DataTable dt = this.GetPhaseTable(m_strEventID);

                cbEx_Phase.DataSource = dt;
                cbEx_Phase.ValueMember = "F_ID";
                cbEx_Phase.DisplayMember = "F_Info";

                bool bExist = false;
                for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
                {
                    if (dt.Rows[nRow]["F_ID"].ToString() == m_strPhaseID)
                    {
                        bExist = true;
                        break;
                    }
                }
                if (bExist)
                {
                    cbEx_Phase.SelectedValue = m_strPhaseID;
                }
                else
                {
                    cbEx_Phase.SelectedValue = "-1";
                    m_strPhaseID = "";
                }

                AdjustComboBoxDropDownListWidth(cbEx_Phase, dt);
            }
        }

        private void Update_RoundComBox()
        {
            string strID = "";
            strID = cbEx_Event.SelectedValue.ToString();

            if (strID == "-1")
            {
                m_strEventID = "";
                m_strRoundID = "";
            }
            else
            {
                m_strEventID = strID;
            }

            if (m_strEventID.Length == 0)
            {
                System.Data.DataTable dt = new DataTable();
                dt.Columns.Add("F_ID");
                dt.Columns.Add("F_Info");

                dt.Rows.Add("-1", "Invalid");

                cbEx_Round.DataSource = dt;
                cbEx_Round.ValueMember = "F_ID";
                cbEx_Round.DisplayMember = "F_Info";

                cbEx_Round.SelectedValue = "-1";
                m_strRoundID = "";

                AdjustComboBoxDropDownListWidth(cbEx_Round, dt);
            }
            else
            {
                System.Data.DataTable dt = this.GetRoundTable(m_strEventID);

                cbEx_Round.DataSource = dt;
                cbEx_Round.ValueMember = "F_ID";
                cbEx_Round.DisplayMember = "F_Info";

                bool bExist = false;
                for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
                {
                    if (dt.Rows[nRow]["F_ID"].ToString() == m_strRoundID)
                    {
                        bExist = true;
                        break;
                    }
                }
                if (bExist)
                {
                    cbEx_Round.SelectedValue = m_strRoundID;
                }
                else
                {
                    cbEx_Round.SelectedValue = "-1";
                    m_strRoundID = "";
                }

                AdjustComboBoxDropDownListWidth(cbEx_Round, dt);
            }
        }

        private void Update_StatusComBox()
        {
            System.Data.DataTable dt = this.GetStatusTable();

            cbEx_Status.DataSource = dt;
            cbEx_Status.ValueMember = "F_ID";
            cbEx_Status.DisplayMember = "F_Info";

            bool bExist = false;
            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                if (dt.Rows[nRow]["F_ID"].ToString() == m_strStatusID)
                {
                    bExist = true;
                    break;
                }
            }
            if (bExist)
            {
                cbEx_Status.SelectedValue = m_strStatusID;
            }
            else
            {
                cbEx_Status.SelectedValue = "-1";
                m_strStatusID = "";
            }

            AdjustComboBoxDropDownListWidth(cbEx_Status, dt);
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


        private void btnX_Update_Click(object sender, EventArgs e)
        {
            LoadData();
        }

        private void advTree_AfterNodeSelect(object sender, DevComponents.AdvTree.AdvTreeNodeEventArgs e)
        {
            DevComponents.AdvTree.Node SelNode = e.Node;
            if (SelNode != null)
            {
                SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
                switch (oneSNodeInfo.iNodeType)
                {
                    case -3://Sport
                        break;
                    case -2://Discipline
                    case -1://Event
                    case 0://Phase
                    case 1://Match
                        {
                            string strOldDisciplineID = m_strDisciplineID;
                            m_strLastSelPhaseTreeNodeKey = oneSNodeInfo.strNodeKey;
                            m_strDisciplineID = oneSNodeInfo.iDisciplineID.ToString();
                            m_strTreeEventID = oneSNodeInfo.iEventID.ToString();
                            m_strTreePhaseID = oneSNodeInfo.iPhaseID.ToString();
                            m_strTreeMatchID = oneSNodeInfo.iMatchID.ToString();
                            m_strTreeType = oneSNodeInfo.iNodeType.ToString();

                            this.Update_UnScheduledGrid();

                            if (strOldDisciplineID != m_strDisciplineID)
                            {
                                this.Update_DateComBox();
                                this.Update_SessionComBox();
                                this.Update_VenueComBox();
                                this.Update_CourtComBox();
                                this.Update_EventComBox();
                                this.Update_PhaseComBox();
                                this.Update_RoundComBox();
                                this.Update_StatusComBox();

                                this.Update_ScheduledGrid();
                            }
                        }
                        break;
                    default://其余的不需要处理!
                        break;
                }
                // Update Report Context
                m_matchScheduleModule.SetReportContext("SportID", oneSNodeInfo.iSportID.ToString());
                m_matchScheduleModule.SetReportContext("DisciplineID", oneSNodeInfo.iDisciplineID.ToString());
                m_matchScheduleModule.SetReportContext("EventID", oneSNodeInfo.iEventID.ToString());
                m_matchScheduleModule.SetReportContext("PhaseID", oneSNodeInfo.iPhaseID.ToString());
            }
            else
            {
                // Update Report Context
                m_matchScheduleModule.SetReportContext("SportID", "-1");
                m_matchScheduleModule.SetReportContext("DisciplineID", "-1");
                m_matchScheduleModule.SetReportContext("EventID", "-1");
                m_matchScheduleModule.SetReportContext("PhaseID", "-1");
            }
        }

        private void btnX_Add_Click(object sender, EventArgs e)
        {
            if (m_strDate.Length == 0 && 
                m_strSessionID.Length == 0 && 
                m_strVenueID.Length == 0 &&
                m_strCourtID.Length == 0 &&
                m_strRoundID.Length == 0 &&
                m_strStatusID.Length == 0)
                return;

            List<OVRDataChanged> changedList = new List<OVRDataChanged>();

            DataGridViewSelectedRowCollection l_Rows = this.dgv_UnScheduled.SelectedRows;
            foreach (DataGridViewRow r in l_Rows)
            {
                try
                {
                    string strMatchID = this.dgv_UnScheduled.Rows[r.Index].Cells["F_MatchID"].Value.ToString();
                    int iMatchID = Convert.ToInt32(strMatchID);
                    bool bMatchInfoChanged = false;
                    DataGridViewCell cell;

                    #region  Set Changed Notify List

                    // 1. Check if Date Changed
                    cell = this.dgv_UnScheduled.Rows[r.Index].Cells["Date"];
                    if (m_strDate.Length != 0 && cell != null && cell.Value.ToString() != m_strDate)
                    {
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchDate, -1, -1, -1, iMatchID, iMatchID, null));

                        cell = this.dgv_UnScheduled.Rows[r.Index].Cells["F_SessionID"];
                        if (m_strSessionID.Length == 0 && cell != null && cell.Value.ToString().Length != 0)
                        {
                            int iOldSessionID = Convert.ToInt32(cell.Value);
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionReset, -1, -1, -1, iMatchID, iOldSessionID, null));
                        }
                    }

                    // 2. Check if Session Changed
                    cell = this.dgv_UnScheduled.Rows[r.Index].Cells["F_SessionID"];
                    if (m_strSessionID.Length != 0 && cell != null && cell.Value.ToString() != m_strSessionID)
                    {
                        if (cell.Value.ToString().Length != 0)
                        {
                            int iOldSessionID = Convert.ToInt32(cell.Value);
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionReset, -1, -1, -1, iMatchID, iOldSessionID, null));
                        }
                        int iNewSessionID = Convert.ToInt32(m_strSessionID);
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionSet, -1, -1, -1, iMatchID, iNewSessionID, null));
                    }

                    // 3. Check if Venue Changed
                    cell = this.dgv_UnScheduled.Rows[r.Index].Cells["F_VenueID"];
                    if (m_strVenueID.Length != 0 && cell != null && cell.Value.ToString() != m_strVenueID)
                    {
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                        bMatchInfoChanged = true;

                        cell = this.dgv_UnScheduled.Rows[r.Index].Cells["F_CourtID"];
                        if (m_strCourtID.Length == 0 && cell != null && cell.Value.ToString().Length != 0)
                        {
                            int iOldCourtID = Convert.ToInt32(cell.Value);
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtReset, -1, -1, -1, iMatchID, iOldCourtID, null));
                        }
                    }

                    // 4. Check if Court Changed
                    cell = this.dgv_UnScheduled.Rows[r.Index].Cells["F_CourtID"];
                    if (m_strCourtID.Length != 0 && cell != null && cell.Value.ToString() != m_strCourtID)
                    {
                        if (cell.Value.ToString().Length != 0)
                        {
                            int iOldCourtID = Convert.ToInt32(cell.Value);
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtReset, -1, -1, -1, iMatchID, iOldCourtID, null));
                        }
                        int iNewCourtID = Convert.ToInt32(m_strCourtID);
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtSet, -1, -1, -1, iMatchID, iNewCourtID, null));
                    }

                    // 5. Check if Round Changed
                    cell = this.dgv_UnScheduled.Rows[r.Index].Cells["F_CourtID"];
                    if (!bMatchInfoChanged && m_strRoundID.Length != 0 && cell != null && cell.Value.ToString() != m_strRoundID)
                    {
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                    }

                    /*
                    // 6. Check if Status Changed
                    cell = this.dgv_UnScheduled.Rows[r.Index].Cells["F_MatchStatusID"];
                    if (m_strStatusID.Length != 0 && cell != null && cell.Value.ToString() != m_strStatusID)
                    {
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchStatus, -1, -1, -1, iMatchID, iMatchID, null));
                    }
                    */
                    #endregion

                    this.AddMatchInfo(strMatchID);
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }

            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();

            if (changedList.Count > 0)
                m_matchScheduleModule.DataChangedNotify(changedList);
        }

        private void btnX_AddAll_Click(object sender, EventArgs e)
        {
            if (m_strDate.Length == 0 &&
                m_strSessionID.Length == 0 &&
                m_strVenueID.Length == 0 &&
                m_strCourtID.Length == 0 &&
                m_strRoundID.Length == 0 &&
                m_strStatusID.Length == 0)
                return;

            List<OVRDataChanged> changedList = new List<OVRDataChanged>();

            DataGridViewRowCollection l_Rows = this.dgv_UnScheduled.Rows;
            foreach (DataGridViewRow r in l_Rows)
            {
                try
                {
                    string strMatchID = this.dgv_UnScheduled.Rows[r.Index].Cells["F_MatchID"].Value.ToString();

                    #region  Set Changed Notify List

                    int iMatchID = Convert.ToInt32(strMatchID);
                    bool bMatchInfoChanged = false;
                    DataGridViewCell cell;

                    // 1. Check if Date Changed
                    cell = this.dgv_UnScheduled.Rows[r.Index].Cells["Date"];
                    if (m_strDate.Length != 0 && cell != null && cell.Value.ToString() != m_strDate)
                    {
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchDate, -1, -1, -1, iMatchID, iMatchID, null));

                        cell = this.dgv_UnScheduled.Rows[r.Index].Cells["F_SessionID"];
                        if (m_strSessionID.Length == 0 && cell != null && cell.Value.ToString().Length != 0)
                        {
                            int iOldSessionID = Convert.ToInt32(cell.Value);
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionReset, -1, -1, -1, iMatchID, iOldSessionID, null));
                        }
                    }

                    // 2. Check if Session Changed
                    cell = this.dgv_UnScheduled.Rows[r.Index].Cells["F_SessionID"];
                    if (m_strSessionID.Length != 0 && cell != null && cell.Value.ToString() != m_strSessionID)
                    {
                        if (cell.Value.ToString().Length != 0)
                        {
                            int iOldSessionID = Convert.ToInt32(cell.Value);
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionReset, -1, -1, -1, iMatchID, iOldSessionID, null));
                        }
                        int iNewSessionID = Convert.ToInt32(m_strSessionID);
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionSet, -1, -1, -1, iMatchID, iNewSessionID, null));
                    }

                    // 3. Check if Venue Changed
                    cell = this.dgv_UnScheduled.Rows[r.Index].Cells["F_VenueID"];
                    if (m_strVenueID.Length != 0 && cell != null && cell.Value.ToString() != m_strVenueID)
                    {
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                        bMatchInfoChanged = true;

                        cell = this.dgv_UnScheduled.Rows[r.Index].Cells["F_CourtID"];
                        if (m_strCourtID.Length == 0 && cell != null && cell.Value.ToString().Length != 0)
                        {
                            int iOldCourtID = Convert.ToInt32(cell.Value);
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtReset, -1, -1, -1, iMatchID, iOldCourtID, null));
                        }
                    }

                    // 4. Check if Court Changed
                    cell = this.dgv_UnScheduled.Rows[r.Index].Cells["F_CourtID"];
                    if (m_strCourtID.Length != 0 && cell != null && cell.Value.ToString() != m_strCourtID)
                    {
                        if (cell.Value.ToString().Length != 0)
                        {
                            int iOldCourtID = Convert.ToInt32(cell.Value);
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtReset, -1, -1, -1, iMatchID, iOldCourtID, null));
                        }
                        int iNewCourtID = Convert.ToInt32(m_strCourtID);
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtSet, -1, -1, -1, iMatchID, iNewCourtID, null));
                    }

                    // 5. Check if Round Changed
                    cell = this.dgv_UnScheduled.Rows[r.Index].Cells["F_CourtID"];
                    if (!bMatchInfoChanged && m_strRoundID.Length != 0 && cell != null && cell.Value.ToString() != m_strRoundID)
                    {
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                    }

                    /*
                    // 6. Check if Status Changed
                    cell = this.dgv_UnScheduled.Rows[r.Index].Cells["F_MatchStatusID"];
                    if (m_strStatusID.Length != 0 && cell != null && cell.Value.ToString() != m_strStatusID)
                    {
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchStatus, -1, -1, -1, iMatchID, iMatchID, null));
                    }
                     */

                    #endregion

                    this.AddMatchInfo(strMatchID);
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }

            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();

            if (changedList.Count > 0)
                m_matchScheduleModule.DataChangedNotify(changedList);
        }

        private void AddMatchInfo(string strMatchID)
        {
            string strDate = m_strDate;
            string strSessionID = m_strSessionID;
            string strVenueID = m_strVenueID;
            string strCourtID = m_strCourtID;
            string strRoundID = m_strRoundID;
            string strStatusID = m_strStatusID;

            if (strDate.Length != 0)
            {
                this.UpdateMatchDate(strMatchID, strDate);
                this.UpdateMatchSession(strMatchID, "");
            }

            if (strSessionID.Length != 0)
                this.UpdateMatchSession(strMatchID, strSessionID);

            if (strVenueID.Length != 0)
            {
                this.UpdateMatchVenue(strMatchID, strVenueID);
                this.UpdateMatchCourt(strMatchID, "");
            }

            if (strCourtID.Length != 0)
                this.UpdateMatchCourt(strMatchID, strCourtID);

            if (strRoundID.Length != 0)
                this.UpdateMatchRound(strMatchID, strRoundID);

            if (strStatusID.Length != 0)
                this.UpdateMatchStatus(strMatchID, strStatusID);
        }

        private void RemoveMatchInfo(string strMatchID)
        {
            string strDate = m_strDate;
            string strSessionID = m_strSessionID;
            string strVenueID = m_strVenueID;
            string strCourtID = m_strCourtID;
            string strRoundID = m_strRoundID;
            string strStatusID = m_strStatusID;

            if (strDate.Length != 0)
            {
                this.UpdateMatchDate(strMatchID, "");
                this.UpdateMatchSession(strMatchID, "");
            }

            if (strSessionID.Length != 0)
                this.UpdateMatchSession(strMatchID, "");

            if (strVenueID.Length != 0)
            {
                this.UpdateMatchVenue(strMatchID, "");
                this.UpdateMatchCourt(strMatchID, "");
            }

            if (strCourtID.Length != 0)
                this.UpdateMatchCourt(strMatchID, "");

            if (strRoundID.Length != 0)
                this.UpdateMatchRound(strMatchID, "");

            if (strStatusID.Length != 0)
                this.UpdateMatchStatus(strMatchID, "10");
        }

        private void btnX_Date_Click(object sender, EventArgs e)
        {
            if (this.m_strDisciplineID == "-1")
            {
                string strError = LocalizationRecourceManager.GetString("MainFrame", "DisciplineID_Error");
                DevComponents.DotNetBar.MessageBoxEx.Show(strError, null, MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            EditDateForm esForm = new EditDateForm();
            esForm.m_sqlCon = this.m_matchScheduleModule.DatabaseConnection;
            esForm.m_strDisciplineID = this.m_strDisciplineID;
            esForm.m_strLanguageCode = this.m_strActiveLanguageCode;
            esForm.module = m_matchScheduleModule;
            esForm.ShowDialog();

            this.Update_DateComBox();

            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();
        }

        private void btnX_Session_Click(object sender, EventArgs e)
        {
            if (this.m_strDisciplineID == "-1")
            {
                string strError = LocalizationRecourceManager.GetString("MainFrame", "DisciplineID_Error");
                DevComponents.DotNetBar.MessageBoxEx.Show(strError, null, MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            EditSessionForm esForm = new EditSessionForm();
            esForm.m_sqlCon = this.m_matchScheduleModule.DatabaseConnection;
            esForm.m_strDisciplineID = this.m_strDisciplineID;
            esForm.m_strLanguageCode = this.m_strActiveLanguageCode;
            esForm.module = m_matchScheduleModule;
            esForm.ShowDialog();

            this.Update_SessionComBox();

            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();
        }

        private void btnX_Round_Click(object sender, EventArgs e)
        {
            if (this.m_strDisciplineID == "-1")
            {
                string strError = LocalizationRecourceManager.GetString("MainFrame", "DisciplineID_Error");
                DevComponents.DotNetBar.MessageBoxEx.Show(strError, null, MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            EditRoundForm erForm = new EditRoundForm();
            erForm.m_sqlCon = this.m_matchScheduleModule.DatabaseConnection;
            erForm.m_strDisciplineID = this.m_strDisciplineID;
            erForm.m_strLanguageCode = this.m_strActiveLanguageCode;
            erForm.ShowDialog();

            this.Update_RoundComBox();

            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();
        }

        private void btnX_Remove_Click(object sender, EventArgs e)
        {
            if (m_strDate.Length == 0 &&
                m_strSessionID.Length == 0 &&
                m_strVenueID.Length == 0 &&
                m_strCourtID.Length == 0 &&
                m_strRoundID.Length == 0 &&
                m_strStatusID.Length == 0)
                return;

            List<OVRDataChanged> changedList = new List<OVRDataChanged>();

            DataGridViewSelectedRowCollection l_Rows = this.dgv_Scheduled.SelectedRows;
            foreach (DataGridViewRow r in l_Rows)
            {
                try
                {
                    string strMatchID = this.dgv_Scheduled.Rows[r.Index].Cells["F_MatchID"].Value.ToString();

                    #region  Set Changed Notify List

                    int iMatchID = Convert.ToInt32(strMatchID);
                    bool bMatchInfoChanged = false;
                    DataGridViewCell cell;

                    // 1. Check if Date Changed
                    if (m_strDate.Length != 0)
                    {
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchDate, -1, -1, -1, iMatchID, iMatchID, null));

                        cell = this.dgv_Scheduled.Rows[r.Index].Cells["F_SessionID"];
                        if (m_strSessionID.Length == 0 && cell.Value.ToString().Length != 0)
                        {
                            int iOldSessionID = Convert.ToInt32(cell.Value);
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionReset, -1, -1, -1, iMatchID, iOldSessionID, null));
                        }
                    }

                    // 2. Check if Session Changed
                    if (m_strSessionID.Length != 0)
                    {
                        int iOldSessionID = Convert.ToInt32(this.dgv_Scheduled.Rows[r.Index].Cells["F_SessionID"].Value);
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionReset, -1, -1, -1, iMatchID, iOldSessionID, null));
                    }

                    // 3. Check if Venue Changed
                    if (m_strVenueID.Length != 0)
                    {
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                        bMatchInfoChanged = true;

                        cell = this.dgv_Scheduled.Rows[r.Index].Cells["F_CourtID"];
                        if (m_strCourtID.Length == 0 && cell.Value.ToString().Length != 0)
                        {
                            int iOldCourtID = Convert.ToInt32(cell.Value);
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtReset, -1, -1, -1, iMatchID, iOldCourtID, null));
                        }
                    }

                    // 4. Check if Court Changed
                    if (m_strCourtID.Length != 0)
                    {
                        int iOldCourtID = Convert.ToInt32(this.dgv_Scheduled.Rows[r.Index].Cells["F_CourtID"].Value);
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtReset, -1, -1, -1, iMatchID, iOldCourtID, null));
                    }

                    // 5. Check if Round Changed
                    if (!bMatchInfoChanged && m_strRoundID.Length != 0)
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
/*
                    // 6. Check if Status Changed
                    if (m_strStatusID.Length != 0)
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchStatus, -1, -1, -1, iMatchID, iMatchID, null));
*/
                    #endregion

                    this.RemoveMatchInfo(strMatchID);
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();

            if (changedList.Count > 0)
                m_matchScheduleModule.DataChangedNotify(changedList);
        }

        private void btnX_RemoveAll_Click(object sender, EventArgs e)
        {
            if (m_strDate.Length == 0 &&
                m_strSessionID.Length == 0 &&
                m_strVenueID.Length == 0 &&
                m_strCourtID.Length == 0 &&
                m_strRoundID.Length == 0 &&
                m_strStatusID.Length == 0)
                return;

            List<OVRDataChanged> changedList = new List<OVRDataChanged>();

            DataGridViewRowCollection l_Rows = this.dgv_Scheduled.Rows;
            foreach (DataGridViewRow r in l_Rows)
            {
                try
                {
                    string strMatchID = this.dgv_Scheduled.Rows[r.Index].Cells["F_MatchID"].Value.ToString();

                    #region  Set Changed Notify List

                    int iMatchID = Convert.ToInt32(strMatchID);
                    bool bMatchInfoChanged = false;
                    DataGridViewCell cell;

                    // 1. Check if Date Changed
                    if (m_strDate.Length != 0)
                    {
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchDate, -1, -1, -1, iMatchID, iMatchID, null));

                        cell = this.dgv_Scheduled.Rows[r.Index].Cells["F_SessionID"];
                        if (m_strSessionID.Length == 0 && cell.Value.ToString().Length != 0)
                        {
                            int iOldSessionID = Convert.ToInt32(cell.Value);
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionReset, -1, -1, -1, iMatchID, iOldSessionID, null));
                        }
                    }

                    // 2. Check if Session Changed
                    if (m_strSessionID.Length != 0)
                    {
                        int iOldSessionID = Convert.ToInt32(this.dgv_Scheduled.Rows[r.Index].Cells["F_SessionID"].Value);
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchSessionReset, -1, -1, -1, iMatchID, iOldSessionID, null));
                    }

                    // 3. Check if Venue Changed
                    if (m_strVenueID.Length != 0)
                    {
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
                        bMatchInfoChanged = true;

                        cell = this.dgv_Scheduled.Rows[r.Index].Cells["F_CourtID"];
                        if (m_strCourtID.Length == 0 && cell.Value.ToString().Length != 0)
                        {
                            int iOldCourtID = Convert.ToInt32(cell.Value);
                            changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtReset, -1, -1, -1, iMatchID, iOldCourtID, null));
                        }
                    }

                    // 4. Check if Court Changed
                    if (m_strCourtID.Length != 0)
                    {
                        int iOldCourtID = Convert.ToInt32(this.dgv_Scheduled.Rows[r.Index].Cells["F_CourtID"].Value);
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCourtReset, -1, -1, -1, iMatchID, iOldCourtID, null));
                    }

                    // 5. Check if Round Changed
                    if (!bMatchInfoChanged && m_strRoundID.Length != 0)
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null));
/*
                    // 6. Check if Status Changed
                    if (m_strStatusID.Length != 0)
                        changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchStatus, -1, -1, -1, iMatchID, iMatchID, null));
*/
                    #endregion

                    this.RemoveMatchInfo(strMatchID);
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();

            if (changedList.Count > 0)
                m_matchScheduleModule.DataChangedNotify(changedList);
        }

        private void cbEx_Date_SelectionChangeCommitted(object sender, EventArgs e)
        {
            string strID = "";
            strID = cbEx_Date.SelectedValue.ToString();

            // Update Report Context - DateID
            m_matchScheduleModule.SetReportContext("DateID", strID);

            if (strID == "-1")
            {
                m_strDateID = "";
                m_strDate = "";
            }
            else
            {
                m_strDateID = strID;
                m_strDate = cbEx_Date.Text.ToString();
            }

            this.Update_SessionComBox();

            // Update Report Context - SessionID
            m_matchScheduleModule.SetReportContext("SessionID", m_strSessionID == "" ? "-1" : m_strSessionID);

            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();
        }

        private void cbEx_Session_SelectionChangeCommitted(object sender, EventArgs e)
        {
            string strID = "";
            strID = cbEx_Session.SelectedValue.ToString();

            // Update Report Context
            m_matchScheduleModule.SetReportContext("SessionID", strID);

            if (strID == "-1")
                m_strSessionID = "";
            else
                m_strSessionID = strID;

            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();
        }

        private void cbEx_Venue_SelectionChangeCommitted(object sender, EventArgs e)
        {
            string strID = "";
            strID = cbEx_Venue.SelectedValue.ToString();

            if (strID == "-1")
            {
                m_strVenueID = "";
                m_strCourtID = "";
            }
            else
            {
                m_strVenueID = strID;
            }

            this.Update_CourtComBox();

            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();
        }

        private void cbEx_Court_SelectionChangeCommitted(object sender, EventArgs e)
        {
            string strID = "";
            strID = cbEx_Court.SelectedValue.ToString();

            if (strID == "-1")
                m_strCourtID = "";
            else
                m_strCourtID = strID;

            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();
        }

        private void cbEx_Event_SelectionChangeCommitted(object sender, EventArgs e)
        {
            string strID = "";
            strID = cbEx_Event.SelectedValue.ToString();

            if (strID == "-1")
            {
                m_strEventID = "";
                m_strRoundID = "";
            }
            else
            {
                m_strEventID = strID;
            }

            this.Update_PhaseComBox();
            this.Update_RoundComBox();
            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();
        }

        private void cbEx_Phase_SelectionChangeCommitted(object sender, EventArgs e)
        {
            string strID = "";
            strID = cbEx_Phase.SelectedValue.ToString();

            // Update Report Context
            m_matchScheduleModule.SetReportContext("PhaseID", strID);

            if (strID == "-1")
                m_strPhaseID = "";
            else
                m_strPhaseID = strID;

            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();
        }

        private void cbEx_Round_SelectionChangeCommitted(object sender, EventArgs e)
        {
            string strID = "";
            strID = cbEx_Round.SelectedValue.ToString();

            // Update Report Context
            m_matchScheduleModule.SetReportContext("RoundID", strID);

            if (strID == "-1")
                m_strRoundID = "";
            else
                m_strRoundID = strID;

            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();
        }

        private void cbEx_Status_SelectionChangeCommitted(object sender, EventArgs e)
        {
            string strID = "";
            strID = cbEx_Status.SelectedValue.ToString();

            if (strID == "-1")
                m_strStatusID = "";
            else
                m_strStatusID = strID;

            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();
        }

        private void btnX_SearchMatches_Click(object sender, EventArgs e)
        {
            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();
        }

        private void tabCtrlPanel_Schedule_Resize(object sender, EventArgs e)
        {
            tabCtrlPanel_Schedule.SuspendLayout();
            panelMatch.Height = tabCtrlPanel_Schedule.Height * 2 / 5;
            tabCtrlPanel_Schedule.ResumeLayout();
        }

        private void chkX_Time_CheckedChanged(object sender, EventArgs e)
        {
            if (chkX_Time.Checked)
            {
                dti_StartTime.Enabled = true;
                dti_SpendTime.Enabled = true;
                dti_SpanTime.Enabled = true;

                this.dgv_Scheduled.MultiSelect = false;
            }
            else
            {
                dti_StartTime.Enabled = false;
                dti_SpendTime.Enabled = false;
                dti_SpanTime.Enabled = false;
                this.dgv_Scheduled.MultiSelect = true;
            }
        }

        private void dti_StartTime_TextChanged(object sender, EventArgs e)
        {
            string strTime = dti_StartTime.Value.ToString("HH:mm:ss");

            if (strTime.Length == 0)
                return;

            m_strStartTime = strTime;
        }

        private void dti_SpendTime_TextChanged(object sender, EventArgs e)
        {
            string strTime = dti_SpendTime.Value.ToString("HH:mm:ss");

            if (strTime.Length == 0)
                return;

            m_strSpendTime = strTime;
        }

        private void dti_SpanTime_TextChanged(object sender, EventArgs e)
        {
            string strTime = dti_SpanTime.Value.ToString("HH:mm:ss");

            if (strTime.Length == 0)
                return;

            m_strSpanTime = strTime;
        }

        private void dgv_Scheduled_SelectionChanged(object sender, EventArgs e)
        {
            if (dgv_Scheduled.SelectedRows.Count == 0)
            {
                m_matchScheduleModule.SetReportContext("MatchID", "-1");
                return;
            }

            if (this.dgv_Scheduled.SelectedRows.Count == 1)
            {
                string strMatchID = dgv_Scheduled.SelectedRows[0].Cells["F_MatchID"].Value.ToString();
                m_matchScheduleModule.SetReportContext("MatchID", strMatchID);
            }


            if (chkX_Time.Checked)
            {
                if (m_strStartTime.Length == 0)
                    m_strStartTime = "00:00:00";
                if (m_strSpendTime.Length == 0)
                    m_strSpendTime = "00:00:00";
                if (m_strSpanTime.Length == 0)
                    m_strSpanTime = "00:00:00";
                DateTime dtStartTime = DateTime.Parse(m_strStartTime);
                TimeSpan tsSpendTime = TimeSpan.Parse(m_strSpendTime);
                TimeSpan tsSpanTime = TimeSpan.Parse(m_strSpanTime);
                string strNewStartTime = dtStartTime.ToString("HH:mm");
                DateTime dtEndTime = dtStartTime + tsSpendTime;
                string strNewEndTime = dtEndTime.ToString("HH:mm");
                if (m_strSpendTime == "00:00:00")
                    strNewEndTime = "";

                DataGridViewSelectedRowCollection l_Rows = this.dgv_Scheduled.SelectedRows;
                if (this.dgv_Scheduled.SelectedRows.Count == 1)
                {
                    this.dgv_Scheduled.SelectedRows[0].Cells["StartTime"].Value = strNewStartTime;
                    this.dgv_Scheduled.SelectedRows[0].Cells["EndTime"].Value = strNewEndTime;
                    string strMatchID = this.dgv_Scheduled.SelectedRows[0].Cells["F_MatchID"].Value.ToString();
                    UpdateMatchStartTime(strMatchID, strNewStartTime);
                    UpdateMatchEndTime(strMatchID, strNewEndTime);
                }

                dtStartTime += tsSpendTime;
                dtStartTime += tsSpanTime;
                m_strStartTime = dtStartTime.ToString("HH:mm:ss");
                dti_StartTime.Text = m_strStartTime;
            }
        }

        private void chkX_Status_CheckedChanged(object sender, EventArgs e)
        {
            if (chkX_Status.Checked)
            {
                m_IsChecked = 1;
                this.cbEx_Status.Enabled = true;
            }
            else
            {
                m_IsChecked = 0;
                m_strStatusID = "30";
                this.cbEx_Status.SelectedValue = m_strStatusID;
                this.cbEx_Status.Enabled = false;
            }
            this.Update_UnScheduledGrid();
            this.Update_ScheduledGrid();
        }

        private void MenuBatchPrinting_Click(object sender, EventArgs e)
        {
            AutoSports.OVRCommon.BatchReportsPrintingForm frmBatchReportsPrintting = new AutoSports.OVRCommon.BatchReportsPrintingForm();
            frmBatchReportsPrintting.DBConnection = this.m_matchScheduleModule.DatabaseConnection;
            frmBatchReportsPrintting.Initialize();

            List<AutoSports.OVRCommon.OVRScheduleNodeInfo> lstScheduleNodeInfos = new List<AutoSports.OVRCommon.OVRScheduleNodeInfo>();
            List<DevComponents.AdvTree.Node> lstNodeChildren = new List<DevComponents.AdvTree.Node>();

            DevComponents.AdvTree.Node SelNode = this.advTree.SelectedNodes[0];

            GetNodeChildren(SelNode, ref lstNodeChildren);
            if (lstNodeChildren.Count>0)
            {
                foreach (DevComponents.AdvTree.Node TempNode in lstNodeChildren)
                {
                    SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)TempNode.Tag;
                    lstScheduleNodeInfos.Add(new AutoSports.OVRCommon.OVRScheduleNodeInfo((AutoSports.OVRCommon.emScheduleNodeType)oneSNodeInfo.iNodeType, m_iActiveSportID, m_iActiveDisciplineID, oneSNodeInfo.iEventID, oneSNodeInfo.iPhaseID, oneSNodeInfo.iMatchID));
                }
            }

            frmBatchReportsPrintting.m_lstBatchReportParamters = lstScheduleNodeInfos;
            frmBatchReportsPrintting.ShowDialog();
        }

        private void GetNodeChildren(DevComponents.AdvTree.Node SelNode, ref List<DevComponents.AdvTree.Node> lstNodeChildren)
        {
            lstNodeChildren.Add(SelNode);

            if (SelNode.HasChildNodes)
            {
                foreach (DevComponents.AdvTree.Node TempNode in SelNode.Nodes)
                {
                    GetNodeChildren(TempNode, ref lstNodeChildren);
                }
            }

        }
    }
}