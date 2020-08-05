using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using System.Xml.Serialization;
using System.IO;
using System.Net.Sockets;
using System.Net;
using System.Threading;
using System.Security.AccessControl;

namespace AutoSports.OVRGFPlugin
{
    public delegate void SetTeamGridView();
    public delegate void DgTcpException();

    public partial class frmOVRGFDataEntry : DevComponents.DotNetBar.Office2007Form
    {
        private System.Timers.Timer m_time = null;//new System.Timers.Timer(3000);

        public frmOVRGFDataEntry()
        {
            InitializeComponent();

            this.DataEntryChangeMatchRuleHandler = new dlDataEntryChangeMatchRule(this.ChangeMatchRule);
        }

        private void Localization()
        {
            this.lb_Sport.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbSportName");
            this.lb_Date.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbDate");
            this.lb_EagleBetter.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbEagleBetter");
            this.lb_Birdie.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbBirdie");
            this.lb_Par.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbPar");
            this.lb_Bogey.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbBogey");
            this.lb_DBgeyWorse.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbDBgeyWorse");
            this.btnx_Schedule.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxSchedule");
            this.btnx_StartList.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxStartList");
            this.btnx_Running.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxRunning");
            this.btnx_Suspend.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxSuspend");
            this.btnx_Unofficial.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxUnofficial");
            this.btnx_Official.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxOfficial");
            this.btnx_Revision.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxRevision");
            this.btnx_Canceled.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxCanceled");
            this.btnx_CreateGroup.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxCreateGroup");
            this.btnx_SetTee.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxSetTee");
            this.btnx_ModifyGroup.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxModifyGroup");
            this.btnx_Course.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxCourse");
            this.btnx_Exit.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxExit");
            this.btnx_Draw.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxDraw");
            this.lb_IP.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbServerIP");
            this.lb_Port.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbServerPort");
            this.btnx_Start.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxStart");

            this.tbIP.Value = "192.168.1.102";
        }

        private void frmOVRGFDataEntry_Load(object sender, EventArgs e)
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvHolePar);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvTeam);
            SetDataGridViewStyle(this.dgvPlayer);

            Localization();
            EnableControlButton(false, true);
            SetTCPInfo();

            m_time = new System.Timers.Timer(3000);
            m_time.Elapsed += new System.Timers.ElapsedEventHandler(TimeElapsed);
            m_time.AutoReset = true;
            m_time.Enabled = true;
        }

        public void OnMsgFlushSelMatch(Int32 iWndMode, Int32 iMatchID)
        {
            // Is Running 
            if (m_bIsRunning)
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "mbRunningMatch"), GFCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            // Not valid MatchID
            if (iMatchID <= 0)
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "mbChooseMatch"));
                return;
            }

            m_iCurMatchID = iMatchID;
            m_iWndMode = iWndMode;
            m_iCurTeamMatchID = GFCommon.g_ManageDB.GetCurTeamMatchID(m_iCurMatchID);

            GFCommon.g_GFPlugin.SetReportContext("MatchID", m_iCurMatchID.ToString());
            m_bIsRunning = true;

            // Intial Basic Info
            EnableControlButton(true, false);
            GFCommon.g_ManageDB.GetActiveSportInfo();

            InitMatchInfo();
            InitMatchResult();
            return;
        }

        public void QueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;

            switch (args.Name)
            {
                case "MatchID":
                    {
                        args.Value = m_iCurMatchID.ToString();
                        args.Handled = true;
                    }
                    break;
                default:
                    break;
            }
        }

        private void btnx_Status_Click(object sender, EventArgs e)
        {
            if (sender == btnx_StartList)
            {
                m_iCurStatusID = GFCommon.STATUS_STARTLIST;
            }
            else if (sender == btnx_Running)
            {
                m_iCurStatusID = GFCommon.STATUS_RUNNING;
            }
            else if (sender == btnx_Suspend)
            {
                m_iCurStatusID = GFCommon.STATUS_SUSPEND;
            }
            else if (sender == btnx_Unofficial)
            {
                m_iCurStatusID = GFCommon.STATUS_UNOFFICIAL;
            }
            else if (sender == btnx_Official)
            {
                m_iCurStatusID = GFCommon.STATUS_OFFICIAL;
            }
            else if (sender == btnx_Revision)
            {
                m_iCurStatusID = GFCommon.STATUS_REVISION;
            }
            else if (sender == btnx_Canceled)
            {
                m_iCurStatusID = GFCommon.STATUS_CANCELED;
            }

            if (sender == btnx_Unofficial)
            {//计算详细成绩排名信息               
                GFCommon.g_ManageDB.UpdateMatchResult(m_iCurMatchID, 1);
                GFCommon.g_ManageDB.UpdateTeamResult(m_iCurMatchID, 1);
            }

            Int32 iResultTeam = OVRDataBaseUtils.ChangeMatchStatus(m_iCurTeamMatchID, m_iCurStatusID, GFCommon.g_DataBaseCon, GFCommon.g_GFPlugin);
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_iCurMatchID, m_iCurStatusID, GFCommon.g_DataBaseCon, GFCommon.g_GFPlugin);

            if (iResult == 1) UpdateMatchStatus();

            if (sender == btnx_Unofficial)
            {//计算小项奖牌信息               
                GFCommon.g_ManageDB.CalculateEventResult(m_iCurMatchID);
            }
        }

        private void btnx_Course_Click(object sender, EventArgs e)
        {
            if (m_iCurMatchID < 1)
                return;

            frmGFCourse frmCourse = new frmGFCourse();
            frmCourse.m_iCurMatchID = m_iCurMatchID;
            frmCourse.DataEntryChangeMatchRuleHandler = this.DataEntryChangeMatchRuleHandler;

            frmCourse.ShowDialog();
        }

        private void btnx_CreateGroup_Click(object sender, EventArgs e)
        {
            if (m_iCurMatchID < 1 || dgvPlayer.RowCount < 1)
                return;

            frmCreateGroup frmCreateGroup = new frmCreateGroup();
            frmCreateGroup.m_iCurMatchID = m_iCurMatchID;
            //frmCreateGroup.m_strStartTime = "07:00";

            frmCreateGroup.ShowDialog();

            if (frmCreateGroup.DialogResult == DialogResult.OK)
            {
                FillGridViewPlayer();
                FillGridViewPlayerColor();
                FillGridViewTeam();
            }
        }

        private void btnx_SetTee_Click(object sender, EventArgs e)
        {
            if (m_iCurMatchID < 1 || dgvPlayer.RowCount < 1)
                return;

            frmSetTee frmSetTee = new frmSetTee();
            frmSetTee.m_iCurMatchID = m_iCurMatchID;
            frmSetTee.m_strStartTime = "07:00";

            frmSetTee.ShowDialog();

            if (frmSetTee.DialogResult == DialogResult.OK)
            {
                FillGridViewPlayer();
                FillGridViewPlayerColor();
                FillGridViewTeam();
            }
        }

        private void btnx_ModifyGroup_Click(object sender, EventArgs e)
        {
            if (m_iCurMatchID < 1 || dgvPlayer.RowCount < 1)
                return;

            if (1 != dgvPlayer.SelectedRows.Count)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgModifyGroup1"));
                return;
            }

            Int32 iRowIdx = dgvPlayer.SelectedRows[0].Index;
            string strGroup = dgvPlayer.Rows[iRowIdx].Cells["Group"].Value.ToString();

            if (strGroup == "")
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgModifyGroup2"));
                return;
            }

            frmModifyGroup frmModifyGroup = new frmModifyGroup();
            frmModifyGroup.m_iCurMatchID = m_iCurMatchID;
            frmModifyGroup.m_iGroup = GFCommon.ConvertStrToInt(strGroup);

            frmModifyGroup.ShowDialog();

            if (frmModifyGroup.DialogResult == DialogResult.OK)
            {
                FillGridViewPlayer();
                FillGridViewPlayerColor();
                FillGridViewTeam();
            }
        }

        private void btnx_Draw_Click(object sender, EventArgs e)
        {
            if (m_iCurMatchID < 1 || dgvPlayer.RowCount < 1)
                return;

            String strMessage = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgAutoDraw1");

            if (IsMatchPositionNull())
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(strMessage);
                return;
            }

            strMessage = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgAutoDraw2");

            if (IsMatchGroupNull())
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(strMessage);
                return;
            }

            strMessage = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgAutoDraw3");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMessage, GFCommon.g_strSectionName, MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
            {
                return;
            }

            if (InitialMatchPlayer())
            {
                FillGridViewPlayer();
                FillGridViewPlayerColor();
                FillGridViewTeam();
            }
        }

        private void btnx_Exit_Click(object sender, EventArgs e)
        {
            if (!m_bIsRunning) return;

            if (MessageBox.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "mbExitMatch"), GFCommon.g_strSectionName, MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                m_bIsRunning = false;
                EnableControlButton(false, true);

                dgvHolePar.Rows.Clear();
                dgvHolePar.Columns.Clear();
                dgvPlayer.Rows.Clear();
                dgvPlayer.Columns.Clear();
                dgvTeam.Rows.Clear();
                dgvTeam.Columns.Clear();

                dgvPlayOffGold.Rows.Clear();
                dgvPlayOffGold.Columns.Clear();
                dgvPlayOffSilver.Rows.Clear();
                dgvPlayOffSilver.Columns.Clear();
                dgvPlayOffBronze.Rows.Clear();
                dgvPlayOffBronze.Columns.Clear();
            }
        }

        private void dgvPlayer_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            string strColumnName = dgvPlayer.Columns[e.ColumnIndex].Name;
            if (strColumnName.CompareTo("Time") == 0 || strColumnName.CompareTo("Group") == 0
                || strColumnName.CompareTo("Sides") == 0 || strColumnName.CompareTo("Tee") == 0)
            {
                if (m_iCurStatusID != GFCommon.STATUS_SCHEDULE)
                {
                    e.Cancel = true;
                }
            }
            else
            {
                if (m_iCurStatusID != GFCommon.STATUS_RUNNING && m_iCurStatusID != GFCommon.STATUS_REVISION)
                {
                    e.Cancel = true;
                }
            }
        }

        private void dgvPlayer_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            Int32 nRowIndex = e.RowIndex;

            if (dgvPlayer.Columns[e.ColumnIndex].Name.CompareTo("Time") == 0)
            {
                string strOldData = m_dtOldPlayer.Rows[nRowIndex]["Time"].ToString();
                string strNewData = "";
                if (dgvPlayer.Rows[e.RowIndex].Cells["Time"].Value != null)
                {
                    strNewData = dgvPlayer.Rows[e.RowIndex].Cells["Time"].Value.ToString();
                    try
                    {
                        DateTime dtTemp = Convert.ToDateTime(strNewData);
                    }
                    catch
                    {
                        dgvPlayer.Rows[e.RowIndex].Cells["Time"].Value = strOldData;
                        return;
                    }
                }

                if (strNewData == strOldData)
                    return;

                Int32 iCompetitionID = -1;
                string strCompetitionID = "";
                strCompetitionID = dgvPlayer.Rows[e.RowIndex].Cells["F_CompetitionPosition"].Value.ToString();
                iCompetitionID = GFCommon.ConvertStrToInt(strCompetitionID);

                GFCommon.g_ManageDB.UpdatePlayerMatchTime(m_iCurMatchID, iCompetitionID, strNewData);

                return;
            }
            else if (dgvPlayer.Columns[e.ColumnIndex].Name.CompareTo("Group") == 0)
            {
                string strOldData = m_dtOldPlayer.Rows[nRowIndex]["Group"].ToString();
                string strNewData = "";
                if (dgvPlayer.Rows[e.RowIndex].Cells["Group"].Value != null)
                {
                    strNewData = dgvPlayer.Rows[e.RowIndex].Cells["Group"].Value.ToString();

                    bool bIsInt = true;
                    for (int i = 0; i < strNewData.Length; i++)
                    {
                        if (!Char.IsNumber(strNewData, i))
                            bIsInt = false;
                    }
                    if (!bIsInt)
                    {
                        dgvPlayer.Rows[e.RowIndex].Cells["Group"].Value = strOldData;
                        return;
                    }
                }

                if (strNewData == strOldData)
                    return;

                Int32 iCompetitionID = -1;
                string strCompetitionID = "";
                strCompetitionID = dgvPlayer.Rows[e.RowIndex].Cells["F_CompetitionPosition"].Value.ToString();
                iCompetitionID = GFCommon.ConvertStrToInt(strCompetitionID);
                Int32 iGroup = GFCommon.ConvertStrToInt(strNewData);

                GFCommon.g_ManageDB.UpdatePlayerMatchGroup(m_iCurMatchID, iCompetitionID, iGroup);

                return;
            }
            else if (dgvPlayer.Columns[e.ColumnIndex].Name.CompareTo("Sides") == 0)
            {
                string strOldData = m_dtOldPlayer.Rows[nRowIndex]["Sides"].ToString();
                string strNewData = "";
                if (dgvPlayer.Rows[e.RowIndex].Cells["Sides"].Value != null)
                {
                    strNewData = dgvPlayer.Rows[e.RowIndex].Cells["Sides"].Value.ToString();

                    bool bIsInt = true;
                    for (int i = 0; i < strNewData.Length; i++)
                    {
                        if (!Char.IsNumber(strNewData, i))
                            bIsInt = false;
                    }
                    if (!bIsInt)
                    {
                        dgvPlayer.Rows[e.RowIndex].Cells["Sides"].Value = strOldData;
                        return;
                    }
                }

                if (strNewData == strOldData)
                    return;

                Int32 iCompetitionID = -1;
                string strCompetitionID = "";
                strCompetitionID = dgvPlayer.Rows[e.RowIndex].Cells["F_CompetitionPosition"].Value.ToString();
                iCompetitionID = GFCommon.ConvertStrToInt(strCompetitionID);
                Int32 iSides = GFCommon.ConvertStrToInt(strNewData);

                GFCommon.g_ManageDB.UpdatePlayerMatchSides(m_iCurMatchID, iCompetitionID, iSides);

                return;
            }
            else if (dgvPlayer.Columns[e.ColumnIndex].Name.CompareTo("Tee") == 0)
            {
                string strOldData = m_dtOldPlayer.Rows[nRowIndex]["Tee"].ToString();
                string strNewData = "";
                if (dgvPlayer.Rows[e.RowIndex].Cells["Tee"].Value != null)
                {
                    strNewData = dgvPlayer.Rows[e.RowIndex].Cells["Tee"].Value.ToString();

                    bool bIsInt = true;
                    for (int i = 0; i < strNewData.Length; i++)
                    {
                        if (!Char.IsNumber(strNewData, i))
                            bIsInt = false;
                    }
                    if (!bIsInt)
                    {
                        dgvPlayer.Rows[e.RowIndex].Cells["Tee"].Value = strOldData;
                        return;
                    }
                }

                if (strNewData == strOldData)
                    return;

                Int32 iCompetitionID = -1;
                string strCompetitionID = "";
                strCompetitionID = dgvPlayer.Rows[e.RowIndex].Cells["F_CompetitionPosition"].Value.ToString();
                iCompetitionID = GFCommon.ConvertStrToInt(strCompetitionID);
                Int32 iTee = GFCommon.ConvertStrToInt(strNewData);

                GFCommon.g_ManageDB.UpdatePlayerMatchTee(m_iCurMatchID, iCompetitionID, iTee);

                return;
            }
            else if (dgvPlayer.Columns[e.ColumnIndex].Name.CompareTo("Pos") == 0)
            {
                string strOldData = m_dtOldPlayer.Rows[nRowIndex]["Pos"].ToString();
                string strNewData = "";
                if (dgvPlayer.Rows[e.RowIndex].Cells["Pos"].Value != null)
                {
                    strNewData = dgvPlayer.Rows[e.RowIndex].Cells["Pos"].Value.ToString();

                    bool bIsInt = true;
                    for (int i = 0; i < strNewData.Length; i++)
                    {
                        if (!Char.IsNumber(strNewData, i))
                            bIsInt = false;
                    }
                    if (!bIsInt)
                    {
                        dgvPlayer.Rows[e.RowIndex].Cells["Pos"].Value = strOldData;
                        return;
                    }
                }

                if (strNewData == strOldData)
                    return;

                Int32 iCompetitionID = -1;
                string strCompetitionID = "";
                strCompetitionID = dgvPlayer.Rows[e.RowIndex].Cells["F_CompetitionPosition"].Value.ToString();
                iCompetitionID = GFCommon.ConvertStrToInt(strCompetitionID);
                string strPos = strNewData;
                //Int32 iTee = GFCommon.ConvertStrToInt(strNewData);

                GFCommon.g_ManageDB.UpdatePlayerMatchPos(m_iCurMatchID, iCompetitionID, strPos);

                return;
            }
            else
            {
                string strColumnName = dgvPlayer.Columns[e.ColumnIndex].Name;
                Int32 iHole = GFCommon.ConvertStrToInt(strColumnName);
                if (iHole < 0 || iHole > m_dtHolePar.Columns.Count)
                    return;

                Int32 nPar = GFCommon.ConvertStrToInt(m_dtHolePar.Rows[0][strColumnName].ToString());

                string strOldData = m_dtOldPlayer.Rows[nRowIndex][strColumnName].ToString();
                string strNewData = "";
                if (dgvPlayer.Rows[e.RowIndex].Cells[strColumnName].Value != null)
                {
                    strNewData = dgvPlayer.Rows[e.RowIndex].Cells[strColumnName].Value.ToString();

                    bool bIsInt = true;
                    for (int i = 0; i < strNewData.Length; i++)
                    {
                        if (!Char.IsNumber(strNewData, i))
                            bIsInt = false;
                    }
                    if (!bIsInt)
                    {
                        dgvPlayer.Rows[e.RowIndex].Cells[strColumnName].Value = strOldData;
                        return;
                    }
                }

                if (strNewData == strOldData)
                    return;

                if (strNewData == "")
                    strNewData = "0";

                m_dtOldPlayer.Rows[nRowIndex][strColumnName] = strNewData;

                Int32 iHoleNumber = GFCommon.ConvertStrToInt(strNewData);
                if (iHoleNumber == 0)
                {
                    dgvPlayer.Rows[e.RowIndex].Cells[strColumnName].Value = "";
                }

                Int32 iCompetitionID = -1;
                string strCompetitionID = "";
                strCompetitionID = dgvPlayer.Rows[e.RowIndex].Cells["F_CompetitionPosition"].Value.ToString();
                iCompetitionID = GFCommon.ConvertStrToInt(strCompetitionID);

                GFCommon.g_ManageDB.UpdatePlayerHoleNum(m_iCurMatchID, iCompetitionID, iHole, iHoleNumber, 1);

                FillHoleColor(e.RowIndex, e.ColumnIndex, iHole, iHoleNumber, strColumnName);
                FillPlayerOUTIN(e.RowIndex);
                FillPlayerRank();
                FillGridViewTeam();

                return;
            }
        }

        private void dgvPlayer_CellMouseDown(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                dgvPlayer.ContextMenu = null;
                dgvPlayer.ContextMenuStrip = null;

                string strColumnName = dgvPlayer.Columns[e.ColumnIndex].Name;

                if (strColumnName == "Name")
                {
                    dgvPlayer.Rows[e.RowIndex].Selected = true;
                    dgvPlayer.ContextMenu = null;
                    dgvPlayer.ContextMenuStrip = contextMenu_IRM;

                    Int32 iCompetitionPosition = -1;
                    string strCompetitionPosition = "";
                    strCompetitionPosition = dgvPlayer.Rows[e.RowIndex].Cells["F_CompetitionPosition"].Value.ToString();
                    iCompetitionPosition = GFCommon.ConvertStrToInt(strCompetitionPosition);

                    m_strOldIRM = GFCommon.g_ManageDB.GetPlayerIRM(m_iCurMatchID, iCompetitionPosition);
                    SetIRM_MenuStrip(m_strOldIRM);

                    m_iCurCompetitionPosition = iCompetitionPosition;
                }
            }
        }

        private void IRM_OK_Click(object sender, EventArgs e)
        {
            UpdatePlayerIRM(GFCommon.PLAYER_STATUS_OK);
        }

        private void IRM_RT_Click(object sender, EventArgs e)
        {
            UpdatePlayerIRM(GFCommon.PLAYER_STATUS_RTD);
        }

        private void IRM_WD_Click(object sender, EventArgs e)
        {
            UpdatePlayerIRM(GFCommon.PLAYER_STATUS_WD);
        }

        private void IRM_DQ_Click(object sender, EventArgs e)
        {
            UpdatePlayerIRM(GFCommon.PLAYER_STATUS_DQ);
        }

        private void btnx_Start_Click(object sender, EventArgs e)
        {
            if (!m_bStartClient)
            {
                try
                {
                    m_strServerAddr = this.tbIP.Text;
                    m_iPort = System.Convert.ToInt32(this.tbPort.Text);
                }
                catch (System.Exception ex)
                {
                    m_iPort = 0;
                    m_strServerAddr = null;
                }

                if (m_iPort == 0 || m_strServerAddr == null)
                    return;

                try
                {
                    m_client = new TcpClient(m_strServerAddr, m_iPort);

                    m_bStartClient = true;
                    m_ReveiveThread = new Thread(new ThreadStart(ReveiveThread));
                    m_ReveiveThread.IsBackground = true;
                    m_ReveiveThread.Start();
                    m_ParseThread = new Thread(new ThreadStart(ParseThread));
                    m_ParseThread.IsBackground = true;
                    m_ParseThread.Start();

                    this.btnx_Start.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxStop");
                    pb_Connect.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.Connected;
                    this.tbIP.Enabled = false;
                    this.tbPort.Enabled = false;
                }
                catch (SocketException ex)
                {
                    m_bStartClient = false;
                    this.btnx_Start.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxStart");
                    pb_Connect.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.DisConnected;
                    this.tbIP.Enabled = true;
                    this.tbPort.Enabled = true;
                }
            }
            else
            {
                m_bStartClient = false;
                m_client.Close();
                this.btnx_Start.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxStart");
                pb_Connect.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.DisConnected;
                this.tbIP.Enabled = true;
                this.tbPort.Enabled = true;
            }
        }

        public static Object g_messageSignal = new Object();
        public static Queue<string> g_messagesQueue = new Queue<string>();
        public static AutoResetEvent g_SerialEvent = new AutoResetEvent(false);
        public void ReveiveThread()
        {
            try
            {
                // 为读取数据而准备缓存
                Byte[] bytes = new Byte[1024];
                String strLastData = null;

                // 进入监听循环。
                while (true)
                {
                    // 获取一个数据流对象来进行读取和写入
                    NetworkStream stream = null;
                    stream = m_client.GetStream();

                    // 循环接收客户端所发送的所有数据。
                    while (true)
                    {
                        int nReadLength = stream.Read(bytes, 0, bytes.Length);
                        if (nReadLength != 0)
                        {
                            // 把数据字符转化成 UNICODE 字符串。
                            String strTempData = System.Text.Encoding.Unicode.GetString(bytes, 0, nReadLength);
                            String strAllData = strLastData + strTempData;
                            strLastData = "";

                            while (true)
                            {
                                string strEndFlag = "\r\n\u0003\u0004";
                                int nFindIndex = strAllData.IndexOf(strEndFlag);
                                if (nFindIndex < 0)
                                {//剩余数据
                                    strLastData = strAllData;
                                    break;
                                }
                                else
                                {//处理一个完整数据
                                    string strTemp = strAllData.Substring(0, nFindIndex + strEndFlag.Length);
                                    strAllData = strAllData.Substring(strTemp.Length);

                                    if (IsOnLive(strTemp))
                                    {//过滤心跳包数据
                                        continue;
                                    }
                                    string strOkMess = strTemp;
                                    DealTcpData(strOkMess, 1);
                                    /*
                                    lock (g_messageSignal)
                                    {
                                        g_messagesQueue.Enqueue(strOkMess);
                                        g_SerialEvent.Set();
                                    }*/
                                }
                                if (strAllData.Length == 0)
                                {
                                    break;
                                }
                            }
                        }
                        if (nReadLength < bytes.Length)
                        {
                            break;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                if (m_bStartClient)
                {
                    if (this.InvokeRequired)
                    {
                        DgTcpException dgTcpException = new DgTcpException(TcpException);
                        this.Invoke(dgTcpException);
                    }
                    else
                    {
                        TcpException();
                    }
                }
                string strExMessage = ex.Message.ToString();

                System.Threading.Thread.CurrentThread.Abort();
            }
        }

        public void ParseThread()
        {
            return;
            try
            {
                bool bIsLast = false;
                string message = null;
                int nBufCount = g_messagesQueue.Count;
                while (m_bStartClient || 0 != nBufCount)
                {
                    lock (g_messageSignal)
                    {
                        nBufCount = g_messagesQueue.Count;
                        if (0 != nBufCount)
                        {
                            message = g_messagesQueue.Dequeue();
                            nBufCount = g_messagesQueue.Count;
                            if (0 == nBufCount)
                            {
                                bIsLast = true;
                            }
                        }
                    }
                    if (m_bStartClient && !bIsLast && nBufCount == 0)
                    {
                        g_SerialEvent.WaitOne();
                    }

                    lock (g_messageSignal)
                    {
                        nBufCount = g_messagesQueue.Count;
                    }
                    if (null == message)
                    {
                        continue;
                    }

                    //处理客户端所发送的数据。
                    if (bIsLast == true)
                    {
                        DealTcpData(message, 1);
                        bIsLast = false;
                    }
                    else
                    {
                        DealTcpData(message, 0);
                    }
                    message = null;

                    lock (g_messageSignal)
                    {
                        nBufCount = g_messagesQueue.Count;
                    }
                }
            }
            catch (Exception ex)
            {
                if (m_bStartClient)
                {
                    if (this.InvokeRequired)
                    {
                        DgTcpException dgTcpException = new DgTcpException(TcpException);
                        this.Invoke(dgTcpException);
                    }
                    else
                    {
                        TcpException();
                    }
                }
                string strExMessage = ex.Message.ToString();

                System.Threading.Thread.CurrentThread.Abort();
            }
        }

        private void TcpException()
        {
            m_bStartClient = false;
            m_client.Close();
            this.btnx_Start.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxStart");
            pb_Connect.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.DisConnected;
            this.tbIP.Enabled = true;
            this.tbPort.Enabled = true;

            string strNetErr = "TcpException...Network disconnected...";
            DevComponents.DotNetBar.MessageBoxEx.Show(strNetErr);
        }

        private void checkTcp_CheckedChanged(object sender, EventArgs e)
        {
            if (checkTcp.Checked)
            {
                EnableTcpButton(true);
            }
            else
            {
                if (m_bStartClient)
                {
                    m_bStartClient = false;
                    m_client.Close();
                    this.btnx_Start.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxStart");
                    pb_Connect.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.DisConnected;
                    this.tbIP.Enabled = true;
                    this.tbPort.Enabled = true;
                }

                EnableTcpButton(false);
            }
        }

        public void TimeElapsed(object source, System.Timers.ElapsedEventArgs e)
        {
            if (m_client != null && m_bStartClient)
            {
                string str = "OnLive";
                byte[] buf = System.Text.Encoding.GetEncoding("gb2312").GetBytes(str);
                int nReturn = 0;
                try
                {
                    nReturn = m_client.Client.Send(buf);
                }
                catch (Exception ex)
                {
                    m_bStartClient = false;
                    m_client.Close();
                    this.btnx_Start.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxStart");
                    pb_Connect.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.DisConnected;
                    this.tbIP.Enabled = true;
                    this.tbPort.Enabled = true;

                    string strNetErr = "OnLive...Network disconnected...";
                    DevComponents.DotNetBar.MessageBoxEx.Show(strNetErr);
                }
            }
        }

        private void btnx_Update_Click(object sender, EventArgs e)
        {
            if (m_iCurMatchID > -1)
            {
                m_dtOldPlayer = new DataTable();
                m_dtOldPlayer = GFCommon.g_ManageDB.GetMatchResult(m_iCurMatchID);

                for (int nRow = 0; nRow < dgvPlayer.RowCount; nRow++)
                {
                    for (int nCol = 0; nCol < dgvPlayer.ColumnCount; nCol++)
                    {
                        string strOldValue = "";
                        if (dgvPlayer.Rows[nRow].Cells[nCol] != null)
                            strOldValue = dgvPlayer.Rows[nRow].Cells[nCol].Value.ToString();
                        string strNewValue = "";
                        if (m_dtOldPlayer.Rows[nRow][nCol] != DBNull.Value)
                            strNewValue = m_dtOldPlayer.Rows[nRow][nCol].ToString();
                        if (strOldValue != strNewValue)
                            dgvPlayer.Rows[nRow].Cells[nCol].Value = strNewValue;
                    }
                }
                FillGridViewPlayerColor();

                DataTable dtTeam = new DataTable();
                dtTeam = GFCommon.g_ManageDB.GetTeamResult(m_iCurMatchID);
                m_dtOldTeam = new DataTable();
                m_dtOldTeam = dtTeam;

                for (int nRow = 0; nRow < dgvTeam.RowCount; nRow++)
                {
                    for (int nCol = 0; nCol < dgvTeam.ColumnCount; nCol++)
                    {
                        string strOldValue = "";
                        if (dgvTeam.Rows[nRow].Cells[nCol] != null)
                            strOldValue = dgvTeam.Rows[nRow].Cells[nCol].Value.ToString();
                        string strNewValue = "";
                        if (dtTeam.Rows[nRow][nCol] != DBNull.Value)
                            strNewValue = dtTeam.Rows[nRow][nCol].ToString();

                        if (strOldValue != strNewValue)
                            dgvTeam.Rows[nRow].Cells[nCol].Value = strNewValue;
                    }
                }
            }
        }

        private void dgvTeam_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            Int32 nRowIndex = e.RowIndex;

            if (dgvTeam.Columns[e.ColumnIndex].Name.CompareTo("Pos") == 0)
            {
                string strOldData = m_dtOldTeam.Rows[nRowIndex]["Pos"].ToString();
                string strNewData = "";
                if (dgvTeam.Rows[e.RowIndex].Cells["Pos"].Value != null)
                {
                    strNewData = dgvTeam.Rows[e.RowIndex].Cells["Pos"].Value.ToString();

                    bool bIsInt = true;
                    for (int i = 0; i < strNewData.Length; i++)
                    {
                        if (!Char.IsNumber(strNewData, i))
                            bIsInt = false;
                    }
                    if (!bIsInt)
                    {
                        dgvTeam.Rows[e.RowIndex].Cells["Pos"].Value = strOldData;
                        return;
                    }
                    if (int.Parse(strNewData) <= 0)
                    {
                        dgvTeam.Rows[e.RowIndex].Cells["Pos"].Value = strOldData;
                        return;
                    }
                }

                if (strNewData == strOldData)
                    return;

                Int32 iTeamID = -1;
                string strTeamID = "";
                strTeamID = dgvTeam.Rows[e.RowIndex].Cells["F_TeamID"].Value.ToString();
                iTeamID = GFCommon.ConvertStrToInt(strTeamID);
                int nDisPos = int.Parse(strNewData);

                GFCommon.g_ManageDB.UpdateTeamDisPos(m_iCurMatchID, iTeamID, nDisPos);

                return;
            }
        }

        //郑金勇 2013-03-04
        //此按钮模拟填充比赛，纯粹为测试比赛录入是使用，建议正式版本是进行删除！
        private void btnAutoFillScore_Click(object sender, EventArgs e)
        {
            AutoFillScore(m_iCurMatchID);
            InitMatchResult();
        }

        public Boolean AutoFillScore(Int32 nMatchID)
        {
            Boolean bResult = false;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GFCommon.g_DataBaseCon;
                oneSqlCommand.CommandText = "Proc_GF_AutoFillScore";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);


                oneSqlCommand.Parameters.Add(cmdParameter1);


                if (GFCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    GFCommon.g_DataBaseCon.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {

                    bResult = true;
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bResult;
        }
    }
}
