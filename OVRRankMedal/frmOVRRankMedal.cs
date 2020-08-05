using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using System.Data.SqlClient;
using System.IO;
using Sunny.UI;

namespace AutoSports.OVRRankMedal
{
    struct SAxTreeNodeInfo  // 树控件节点定义


    {
        public String strNodeKey;
        public int iNodeType;
        public int iSportID;
        public int iDisciplineID;
        public int iEventID;
        public int iPhaseID;
        public int iFatherPhaseID;
        public int iMatchID;
        public int iPhaseType;
        public int iPhaseSize;
    }

    public partial class OVRRankMedalForm : UIPage
    {
        OVRRankMedalModule m_RankMedal;
        int m_iActiveSportID = 0;
        int m_iActiveDiscID = 0;
        string m_strActiveLanuageCode = "CHN";
        string strSectionName = "OVRRankMedal";

        private string m_strLastSelPhaseTreeNodeKey;
        private Int32 m_iSelPhaseTreeEventID = -1;
        private Int32 m_iSelPhaseTreePhaseID = -1;
        private Int32 m_iSelPhaseTreeMatchID = -1;
        private Int32 m_iSelPhaseTreeNodeType = -4;

        public OVRRankMedalModule PropRankMedal
        {
            set { m_RankMedal = value; }
        }

        public OVRRankMedalForm()
        {
            InitializeComponent();
        }

        private void Localization()
        {
            this.lbResult.Text = LocalizationRecourceManager.GetString(strSectionName, "lbResult");
            this.btnEventResult.Text = LocalizationRecourceManager.GetString(strSectionName, "btnEventResult");
            this.btnGroupResult.Text = LocalizationRecourceManager.GetString(strSectionName, "btnGroupResult");
            this.btnGroupPoints.Text = LocalizationRecourceManager.GetString(strSectionName, "btnGroupPoints");
            this.btnSendEventResult.Text = LocalizationRecourceManager.GetString(strSectionName, "btnSendEventResult");
            this.cmdAddResult.Text = LocalizationRecourceManager.GetString(strSectionName, "cmdAddResult");
            this.cmdDelResult.Text = LocalizationRecourceManager.GetString(strSectionName, "cmdDelResult");
            this.cmdExportResult.Text = LocalizationRecourceManager.GetString(strSectionName, "cmdExportResult");
            this.btnEventDateSetting.Text = LocalizationRecourceManager.GetString(strSectionName, "btnEventDateSetting");
            this.btnMedalDateSetting.Text = LocalizationRecourceManager.GetString(strSectionName, "btnMedalDateSetting");
        }

        private void FrmOVRRankMedal_Load(object sender, EventArgs e)
        {
            Localization();
            OVRDataBaseUtils.SetDataGridViewStyle(dgridResult);

            LoadData();
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

        private void LoadData()
        {
            OVRDataBaseUtils.GetActiveInfo(m_RankMedal.DatabaseConnection, out m_iActiveSportID, out m_iActiveDiscID, out m_strActiveLanuageCode);
            UpdatePhaseTree();
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

            if (flags.IsSignaled(OVRDataChangedType.emRegisterModify))
            {
                UpdateResultList();
            }
        }

        private void QueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;

            switch (args.Name)
            {
                case "SportID":
                    {
                        if (tvPhaseTree.Visible && tvPhaseTree.SelectedNode != null)
                        {
                            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)tvPhaseTree.SelectedNode.Tag;
                            args.Value = oneSNodeInfo.iSportID.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "DisciplineID":
                    {
                        if (tvPhaseTree.Visible && tvPhaseTree.SelectedNode != null)
                        {
                            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)tvPhaseTree.SelectedNode.Tag;
                            args.Value = oneSNodeInfo.iDisciplineID.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "EventID":
                    {
                        if (tvPhaseTree.Visible && tvPhaseTree.SelectedNode != null)
                        {
                            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)tvPhaseTree.SelectedNode.Tag;
                            args.Value = oneSNodeInfo.iEventID.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "PhaseID":
                    {
                        if (tvPhaseTree.Visible && tvPhaseTree.SelectedNode != null)
                        {
                            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)tvPhaseTree.SelectedNode.Tag;
                            args.Value = oneSNodeInfo.iPhaseID.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "MatchID":
                    {
                        if (tvPhaseTree.Visible && tvPhaseTree.SelectedNode != null)
                        {
                            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)tvPhaseTree.SelectedNode.Tag;
                            args.Value = oneSNodeInfo.iMatchID.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "RegisterID":
                    {
                        if (dgridResult.Visible && dgridResult.SelectedRows.Count > 0)
                        {
                            args.Value = dgridResult.SelectedRows[0].Cells["F_RegisterID"].Value.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
            }
        }

        private bool IsUpdateAllData(OVRDataChangedFlags flags)
        {
            if (m_RankMedal == null) return false;

            if (flags.IsSignaled(OVRDataChangedType.emLangActive))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emSportActive))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emSportInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emDisciplineActive))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emDisciplineInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventAdd))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventDel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emEventStatus))
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
            if (flags.IsSignaled(OVRDataChangedType.emPhaseStatus))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchAdd))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchDel))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emMatchStatus))
                return true;

            return false;
        }

        #region User Interface Operation

        private void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadData();
        }

        private void btnExportResult_Click(object sender, EventArgs e)
        {
            DevComponents.AdvTree.Node selectedNode = tvPhaseTree.SelectedNode;
            if (selectedNode == null) return;

            SAxTreeNodeInfo msNodeInfo = (SAxTreeNodeInfo)selectedNode.Tag;
            switch (msNodeInfo.iNodeType)
            {
                case -3://Sport
                case -2://Discipline
                    break;
                case -1://Event
                    if (msNodeInfo.iEventID > 0)
                    {
                        string eventName = selectedNode.Text;
                        int endPos = eventName.IndexOf('<');
                        if ( endPos != -1 )
                        {
                            eventName = eventName.Substring(0, endPos);
                            eventName = eventName.Trim();
                        }
                        eventName += "名次公告";
                        if (OutPutEventResult(msNodeInfo.iEventID, eventName))
                        {
                            string strText = LocalizationRecourceManager.GetString(strSectionName, "ExpResSucceed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                        }
                        else
                        {
                            string strText = LocalizationRecourceManager.GetString(strSectionName, "ExpResFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                        }
                    }
                    break;
                case 0://Phase
                    break;
                case 1://Match
                default:
                    break;
            }

        }

        private void btnEventResult_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNode == null)
                return;

            DevComponents.AdvTree.Node selectedNode = tvPhaseTree.SelectedNode;
            SAxTreeNodeInfo msNodeInfo = (SAxTreeNodeInfo)selectedNode.Tag;
            switch (msNodeInfo.iNodeType)
            {
                case -3://Sport
                case -2://Discipline
                    break;
                case -1://Event
                    if (msNodeInfo.iEventID > 0)
                    {
                        SqlCommand oneSqlCommand = new SqlCommand();
                        oneSqlCommand.Connection = m_RankMedal.DatabaseConnection;
                        oneSqlCommand.CommandText = "Proc_CreateEventResult";
                        oneSqlCommand.CommandType = CommandType.StoredProcedure;
                        oneSqlCommand.Parameters.AddWithValue("@EventID", msNodeInfo.iEventID);
                        try
                        {
                            oneSqlCommand.ExecuteNonQuery();
                        }
                        catch (System.Exception errorProc)
                        {
                            DevComponents.DotNetBar.MessageBoxEx.Show(errorProc.Message);
                            break;
                        }

                        string strText = LocalizationRecourceManager.GetString(strSectionName, "CalRankSucceed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strText);

                        UpdateResultList();

                        //m_RankMedal.DataChangedNotify(OVRDataChangedType.emEventResult, -1, msNodeInfo.iEventID, -1, -1, msNodeInfo.iEventID, null);
                    }
                    break;
                case 0://Phase
                    break;
                case 1://Match
                default:
                    break;
            }
        }

        private void btnGroupResult_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNode == null)
                return;

            DevComponents.AdvTree.Node selectedNode = tvPhaseTree.SelectedNode;
            SAxTreeNodeInfo msNodeInfo = (SAxTreeNodeInfo)selectedNode.Tag;
            switch (msNodeInfo.iNodeType)
            {
                case -3://Sport
                case -2://Discipline
                case -1://Event
                    break;
                case 0://Phase
                    if (msNodeInfo.iPhaseID > 0)
                    {
                        SqlCommand oneSqlCommand = new SqlCommand();
                        oneSqlCommand.Connection = m_RankMedal.DatabaseConnection;
                        oneSqlCommand.CommandText = "Proc_CreateGroupResult";
                        oneSqlCommand.CommandType = CommandType.StoredProcedure;
                        oneSqlCommand.Parameters.AddWithValue("@PhaseID", msNodeInfo.iPhaseID);
                        try
                        {
                            oneSqlCommand.ExecuteNonQuery();
                        }
                        catch (System.Exception errorProc)
                        {
                            DevComponents.DotNetBar.MessageBoxEx.Show(errorProc.Message);
                            break;
                        }

                        string strText = LocalizationRecourceManager.GetString(strSectionName, "CalGrpResSucceed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                        
                        UpdateResultList();

                        m_RankMedal.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, msNodeInfo.iPhaseID, -1, msNodeInfo.iPhaseID, null);
                    }
                    break;
                case 1://Match
                default:
                    break;
            }
        }

        private void btnGroupPoints_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNode == null)
                return;

            DevComponents.AdvTree.Node selectedNode = tvPhaseTree.SelectedNode;
            SAxTreeNodeInfo msNodeInfo = (SAxTreeNodeInfo)selectedNode.Tag;
            switch (msNodeInfo.iNodeType)
            {
                case -3://Sport
                case -2://Discipline
                case -1://Event
                    break;
                case 0://Phase
                    OVRGroupMatchPointForm GroupMatchPointDlg = new OVRGroupMatchPointForm();
                    GroupMatchPointDlg.DBConnection = m_RankMedal.DatabaseConnection;
                    GroupMatchPointDlg.PhaseID = msNodeInfo.iPhaseID.ToString();
                    GroupMatchPointDlg.ShowDialog();

                    break;
                case 1://Match
                default:
                    break;
            }
        }

        private void cmdAddResult_Click(object sender, EventArgs e)
        {
            // Get Current Selected Event Node
            DevComponents.AdvTree.Node SecectedNode = tvPhaseTree.SelectedNode;
            if (SecectedNode == null) return;
            SAxTreeNodeInfo msNodeInfo = (SAxTreeNodeInfo)SecectedNode.Tag;
            if (msNodeInfo.iNodeType == -1)  // Event
            {
                if (m_RankMedal.DatabaseConnection.State != ConnectionState.Open)
                {
                    m_RankMedal.DatabaseConnection.Open();
                }

                SqlCommand cmdAddEventResult = new SqlCommand("Proc_AddEventResult", m_RankMedal.DatabaseConnection);
                cmdAddEventResult.CommandType = CommandType.StoredProcedure;
                cmdAddEventResult.Parameters.AddWithValue("@EventID", msNodeInfo.iEventID);

                SqlParameter ParamOut = new SqlParameter();
                ParamOut.ParameterName = "@Result";
                ParamOut.Direction = ParameterDirection.Output;
                ParamOut.Size = 4;
                cmdAddEventResult.Parameters.Add(ParamOut);

                try
                {
                    cmdAddEventResult.ExecuteNonQuery();
                }
                catch (System.Exception errorProc)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(errorProc.Message);
                    return;
                }

                int nRetValue = Convert.ToInt32(ParamOut.Value);
                string strText;
                switch (nRetValue)
                {
                    case 0:
                        strText = LocalizationRecourceManager.GetString(strSectionName, "AddResultFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                        break;
                    case -1:
                        strText = LocalizationRecourceManager.GetString(strSectionName, "AddResultFailed_InvdEvtID");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                        break;
                    default: // Succeed
                        //m_RankMedal.DataChangedNotify(OVRDataChangedType.emEventResult, -1, msNodeInfo.iEventID, -1, -1, msNodeInfo.iEventID, null);
                        break;
                }
            }
            else if (msNodeInfo.iNodeType == 0)  // Phase
            {
                if (m_RankMedal.DatabaseConnection.State != ConnectionState.Open)
                {
                    m_RankMedal.DatabaseConnection.Open();
                }

                SqlCommand cmdAddEventResult = new SqlCommand("Proc_AddPhaseResult", m_RankMedal.DatabaseConnection);
                cmdAddEventResult.CommandType = CommandType.StoredProcedure;
                cmdAddEventResult.Parameters.AddWithValue("@PhaseID", msNodeInfo.iPhaseID);

                SqlParameter ParamOut = new SqlParameter();
                ParamOut.ParameterName = "@Result";
                ParamOut.Direction = ParameterDirection.Output;
                ParamOut.Size = 4;
                cmdAddEventResult.Parameters.Add(ParamOut);

                try
                {
                    cmdAddEventResult.ExecuteNonQuery();
                }
                catch (System.Exception errorProc)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(errorProc.Message);
                    return;
                }

                int nRetValue = Convert.ToInt32(ParamOut.Value);
                string strText;
                switch (nRetValue)
                {
                    case 0:
                        strText = LocalizationRecourceManager.GetString(strSectionName, "AddResultFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                        break;
                    case -1:
                        strText = LocalizationRecourceManager.GetString(strSectionName, "AddResultFailed_InvdEvtID");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                        break;
                    default: // Succeed
                        m_RankMedal.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, msNodeInfo.iPhaseID, -1, msNodeInfo.iPhaseID, null);
                        break;
                }
            }

            UpdateResultList();
        }

        private void cmdDelResult_Click(object sender, EventArgs e)
        {
            // Get Current Selected Event Node
            DevComponents.AdvTree.Node SecectedNode = tvPhaseTree.SelectedNode;
            if (SecectedNode == null) return;
            SAxTreeNodeInfo msNodeInfo = (SAxTreeNodeInfo)SecectedNode.Tag;
            if (msNodeInfo.iNodeType == -1)  // Event
            {
                // Get selected Record
                if (dgridResult.Columns["F_EventResultNumber"] == null) return;
                if (dgridResult.SelectedRows.Count <= 0) return;

                string strText = LocalizationRecourceManager.GetString(strSectionName, "DelResultConfirm");
                if (DevComponents.DotNetBar.MessageBoxEx.Show(strText, null, MessageBoxButtons.YesNo) == DialogResult.No)
                    return;

                if (m_RankMedal.DatabaseConnection.State != ConnectionState.Open)
                {
                    m_RankMedal.DatabaseConnection.Open();
                }
                SqlCommand cmdDelEventResult = new SqlCommand("Proc_DelEventResult", m_RankMedal.DatabaseConnection);
                cmdDelEventResult.CommandType = CommandType.StoredProcedure;
                cmdDelEventResult.Parameters.AddWithValue("@EventID", msNodeInfo.iEventID);
                String strEventPosition = dgridResult.SelectedRows[0].Cells["F_EventResultNumber"].Value.ToString();
                cmdDelEventResult.Parameters.AddWithValue("@EventResultNumber", strEventPosition);

                SqlParameter ParamOut = new SqlParameter();
                ParamOut.ParameterName = "@Result";
                ParamOut.Direction = ParameterDirection.Output;
                ParamOut.Size = 4;
                cmdDelEventResult.Parameters.Add(ParamOut);

                try
                {
                    cmdDelEventResult.ExecuteNonQuery();
                }
                catch (System.Exception errorProc)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(errorProc.Message);
                    return;
                }

                int nRetValue = Convert.ToInt32(ParamOut.Value);
                switch (nRetValue)
                {
                    case 0:
                        strText = LocalizationRecourceManager.GetString(strSectionName, "DelResultFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                        break;
                    case -1:
                        strText = LocalizationRecourceManager.GetString(strSectionName, "DelResultFailed_Invd");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                        break;
                    default: // Succeed
                        //m_RankMedal.DataChangedNotify(OVRDataChangedType.emEventResult, -1, msNodeInfo.iEventID, -1, -1, msNodeInfo.iEventID, null);
                        break;
                }
            }
            else if (msNodeInfo.iNodeType == 0)  // Phase
            {
                // Get selected Record
                if (dgridResult.Columns["F_PhaseResultNumber"] == null) return;
                if (dgridResult.SelectedRows.Count <= 0) return;

                string strText = LocalizationRecourceManager.GetString(strSectionName, "DelResultConfirm");
                if (DevComponents.DotNetBar.MessageBoxEx.Show(strText, null, MessageBoxButtons.YesNo) == DialogResult.No)
                    return;

                if (m_RankMedal.DatabaseConnection.State != ConnectionState.Open)
                {
                    m_RankMedal.DatabaseConnection.Open();
                }
                SqlCommand cmdDelEventResult = new SqlCommand("Proc_DelPhaseResult", m_RankMedal.DatabaseConnection);
                cmdDelEventResult.CommandType = CommandType.StoredProcedure;
                cmdDelEventResult.Parameters.AddWithValue("@PhaseID", msNodeInfo.iPhaseID);
                String strEventPosition = dgridResult.SelectedRows[0].Cells["F_PhaseResultNumber"].Value.ToString();
                cmdDelEventResult.Parameters.AddWithValue("@PhaseResultNumber", strEventPosition);

                SqlParameter ParamOut = new SqlParameter();
                ParamOut.ParameterName = "@Result";
                ParamOut.Direction = ParameterDirection.Output;
                ParamOut.Size = 4;
                cmdDelEventResult.Parameters.Add(ParamOut);

                try
                {
                    cmdDelEventResult.ExecuteNonQuery();
                }
                catch (System.Exception errorProc)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(errorProc.Message);
                    return;
                }

                int nRetValue = Convert.ToInt32(ParamOut.Value);
                switch (nRetValue)
                {
                    case 0:
                        strText = LocalizationRecourceManager.GetString(strSectionName, "DelResultFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                        break;
                    case -1:
                        strText = LocalizationRecourceManager.GetString(strSectionName, "DelResultFailed_Invd");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                        break;
                    default:  // Succeed
                        m_RankMedal.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, msNodeInfo.iPhaseID, -1, msNodeInfo.iPhaseID, null);
                        break;
                }
            }

            UpdateResultList();
        }

        private void cmdExportResult_Click(object sender, EventArgs e)
        {
            // Get Current Selected Event Node
            DevComponents.AdvTree.Node SecectedNode = tvPhaseTree.SelectedNode;
            if (SecectedNode == null) return;
            SAxTreeNodeInfo msNodeInfo = (SAxTreeNodeInfo)SecectedNode.Tag;

            // Get selected Record
            if (dgridResult.SelectedRows.Count <= 0) return;

            String strEventID, strPhaseID, strRegisterID;
            String strRegisterName;
            strEventID = msNodeInfo.iEventID.ToString();
            strRegisterID = dgridResult.Columns["F_RegisterID"] == null ? "0" : dgridResult.SelectedRows[0].Cells["F_RegisterID"].Value.ToString();
            if (msNodeInfo.iNodeType == -1)
            {
                strPhaseID = "0";
                strRegisterName = dgridResult.Columns["Competitor Name"] == null ? "0" : dgridResult.SelectedRows[0].Cells["Competitor Name"].Value.ToString();
                OutHistoryResult(strEventID, strPhaseID, strRegisterID, strRegisterName, "-1");
            }
            else if (msNodeInfo.iNodeType == 0)
            {
                strPhaseID = dgridResult.Columns["F_PhaseID"] == null ? "0" : dgridResult.SelectedRows[0].Cells["F_PhaseID"].Value.ToString();
                strRegisterName = dgridResult.Columns["Competitor_Name"] == null ? "0" : dgridResult.SelectedRows[0].Cells["Competitor_Name"].Value.ToString();
                OutHistoryResult(strEventID, strPhaseID, strRegisterID, strRegisterName, "0");
            }
            else
            {
                return;
            }
        }

        private void tvPhaseTree_AfterNodeSelect(object sender, DevComponents.AdvTree.AdvTreeNodeEventArgs e)
        {
            // DisEnable the buttons
            btnExportResult.Enabled = false;
            btnEventResult.Enabled = false;
            btnSendEventResult.Enabled = false;
            btnGroupResult.Enabled = false;
            btnGroupPoints.Enabled = false;

            btnMedalDateSetting.Enabled = false;
            btnEventDateSetting.Enabled = false;

            if (e.Node != null)
            {
                SAxTreeNodeInfo msNodeInfo = (SAxTreeNodeInfo)e.Node.Tag;

                m_strLastSelPhaseTreeNodeKey = msNodeInfo.strNodeKey;
                m_iSelPhaseTreeNodeType = msNodeInfo.iNodeType;
                m_iSelPhaseTreeEventID = msNodeInfo.iEventID;
                m_iSelPhaseTreePhaseID = msNodeInfo.iPhaseID;
                m_iSelPhaseTreeMatchID = msNodeInfo.iMatchID;


                switch (msNodeInfo.iNodeType)
                {
                    case -3://Sport
                    case -2://Discipline
                        ClearResultList();
                        break;
                    case -1://Event
                        btnExportResult.Enabled = true;
                        btnEventResult.Enabled = true;
                        btnSendEventResult.Enabled = true;
                        btnMedalDateSetting.Enabled = true;
                        btnEventDateSetting.Enabled = true;
                        UpdateResultList();
                        break;
                    case 0://Phase
                        if (msNodeInfo.iPhaseType == 2)
                        {
                            btnGroupResult.Enabled = true;
                            btnGroupPoints.Enabled = true;
                        }
                        UpdateResultList();
                        break;
                    case 1://Match
                        ClearResultList();
                        break;
                    default:
                        break;
                }
                m_RankMedal.SetReportContext("SportID", msNodeInfo.iSportID.ToString());
                m_RankMedal.SetReportContext("DisciplineID", msNodeInfo.iDisciplineID.ToString());
                m_RankMedal.SetReportContext("EventID", msNodeInfo.iEventID.ToString());
                m_RankMedal.SetReportContext("PhaseID", msNodeInfo.iPhaseID.ToString());
                m_RankMedal.SetReportContext("MatchID", msNodeInfo.iMatchID.ToString());
            }
            else
            {
                m_RankMedal.SetReportContext("SportID", "-1");
                m_RankMedal.SetReportContext("DisciplineID", "-1");
                m_RankMedal.SetReportContext("EventID", "-1");
                m_RankMedal.SetReportContext("PhaseID", "-1");
                m_RankMedal.SetReportContext("MatchID", "-1");
            }
        }

        private void dgridResult_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgridResult.Columns[e.ColumnIndex].HeaderText == "Competitor Name") // Edit the Competitor Name column
            {
                int nCol = e.ColumnIndex;
                int nRow = e.RowIndex;

                DGVCustomComboBoxColumn CompetitorCol = (DGVCustomComboBoxColumn)dgridResult.Columns["Competitor Name"];
                if (CompetitorCol == null) return;

                DevComponents.AdvTree.Node SecectedNode = tvPhaseTree.SelectedNode;
                if (SecectedNode == null) return;
                SAxTreeNodeInfo msNodeInfo = (SAxTreeNodeInfo)SecectedNode.Tag;
                if (msNodeInfo.iNodeType == -1)//Event
                {
                    String strEventID = GetFieldValue2Str(dgridResult, nRow, "F_EventID");
                    String strRegisterID = GetFieldValue2Str(dgridResult, nRow, "F_RegisterID");

                    // Get Candidature Competitors
                    if (m_RankMedal.DatabaseConnection.State != ConnectionState.Open)
                    {
                        m_RankMedal.DatabaseConnection.Open();
                    }
                    SqlCommand cmdGetCompetitors = new SqlCommand("Proc_GetEventCompetitorsList", m_RankMedal.DatabaseConnection);
                    cmdGetCompetitors.CommandType = CommandType.StoredProcedure;
                    cmdGetCompetitors.Parameters.AddWithValue("@EventID", strEventID);
                    cmdGetCompetitors.Parameters.AddWithValue("@RegisterID", strRegisterID);
                    cmdGetCompetitors.Parameters.AddWithValue("@LanguageCode", m_strActiveLanuageCode);

                    try
                    {
                        SqlDataReader candidateCompetitors = cmdGetCompetitors.ExecuteReader();
                        if (cmdGetCompetitors == null) return;

                        DataTable CompetitorCmbContent = new DataTable();
                        CompetitorCmbContent.Load(candidateCompetitors);
                        CompetitorCol.FillComboBoxItems(CompetitorCmbContent, 0, 1);

                        candidateCompetitors.Close();
                    }
                    catch (System.Exception errorProc)
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(errorProc.Message);
                    }
                }
                else if (msNodeInfo.iNodeType == 0)//Phase
                {
                    String strPhaseID = GetFieldValue2Str(dgridResult, nRow, "F_PhaseID");
                    String strRegisterID = GetFieldValue2Str(dgridResult, nRow, "F_RegisterID");

                    // Get Candidature Competitors
                    if (m_RankMedal.DatabaseConnection.State != ConnectionState.Open)
                    {
                        m_RankMedal.DatabaseConnection.Open();
                    }
                    SqlCommand cmdGetCompetitors = new SqlCommand("Proc_GetPhaseCompetitorsList", m_RankMedal.DatabaseConnection);
                    cmdGetCompetitors.CommandType = CommandType.StoredProcedure;
                    cmdGetCompetitors.Parameters.AddWithValue("@PhaseID", strPhaseID);
                    cmdGetCompetitors.Parameters.AddWithValue("@RegisterID", strRegisterID);
                    cmdGetCompetitors.Parameters.AddWithValue("@LanguageCode", m_strActiveLanuageCode);

                    try
                    {
                        SqlDataReader candidateCompetitors = cmdGetCompetitors.ExecuteReader();
                        if (cmdGetCompetitors == null) return;

                        DataTable CompetitorCmbContent = new DataTable();
                        CompetitorCmbContent.Load(candidateCompetitors);
                        CompetitorCol.FillComboBoxItems(CompetitorCmbContent, 0, 1);

                        candidateCompetitors.Close();
                    }
                    catch (System.Exception errorProc)
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(errorProc.Message);
                    }
                }
            }
            else if (dgridResult.Columns[e.ColumnIndex].Name.CompareTo("F_SourcePhaseName") == 0)
            {
                if (dgridResult.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn)
                {
                    Int32 iRowIndex = e.RowIndex;
                    Int32 iColumnIndex = e.ColumnIndex;

                    Int32 iEventID = GetFieldValue(dgridResult, iRowIndex, "F_EventID");
                    Int32 iPhaseID = GetFieldValue(dgridResult, iRowIndex, "F_PhaseID");
                    InitPhaseCombBox(ref dgridResult, e.ColumnIndex, iEventID, iPhaseID, 0, m_strActiveLanuageCode);
                }

            }
            else if (dgridResult.Columns[e.ColumnIndex].Name.CompareTo("F_SourceMatchName") == 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                Int32 iEventID = GetFieldValue(dgridResult, iRowIndex, "F_EventID");
                Int32 iPhaseID = GetFieldValue(dgridResult, iRowIndex, "F_PhaseID");
                Int32 iSourcePhaseID = GetFieldValue(dgridResult, iRowIndex, "F_SourcePhaseID");
                InitSourceMatchCombBox(ref dgridResult, e.ColumnIndex, iEventID, iPhaseID, 0, iSourcePhaseID, m_strActiveLanuageCode);
            }
            else if (dgridResult.Columns[e.ColumnIndex].Name.CompareTo("IRM") == 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                Int32 iPhaseID = GetFieldValue(dgridResult, iRowIndex, "F_PhaseID");
                InitPhaseIRMCombBox(ref dgridResult, e.ColumnIndex, iPhaseID, m_strActiveLanuageCode);
            }
        }

        private void dgridResult_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            DevComponents.AdvTree.Node SecectedNode = tvPhaseTree.SelectedNode;
            if (SecectedNode == null)
                return;

            SAxTreeNodeInfo msNodeInfo = (SAxTreeNodeInfo)SecectedNode.Tag;
            Int32 iNodeType = msNodeInfo.iNodeType;

            int nCol = e.ColumnIndex;
            int nRow = e.RowIndex;

            String strColumnName = dgridResult.Columns[nCol].HeaderText;
            String strInputValue = GetFieldValue2Str(dgridResult, nRow, nCol);// dgridResult.Rows[nRow].Cells[nCol].Value.ToString();
            String strInputKey = "";
            object TagKey = dgridResult.Rows[nRow].Cells[nCol].Tag;
            if (TagKey != null)
                strInputKey = TagKey.ToString();

            string strEventID = GetFieldValue2Str(dgridResult, nRow, "F_EventID");
            string strPhaseID = GetFieldValue2Str(dgridResult, nRow, "F_PhaseID");
            string strEventResultNumber = GetFieldValue2Str(dgridResult, nRow, "F_EventResultNumber");
            string strPhaseResultNumber = GetFieldValue2Str(dgridResult, nRow, "F_PhaseResultNumber");

            String strUpdateSQL = null;

            if (String.Compare("Group Points", strColumnName, true) == 0)
            {
                strUpdateSQL = String.Format("UPDATE TS_Phase_Result SET [F_PhasePoints] = {0} WHERE F_PhaseID = {1} AND F_PhaseResultNumber ={2}", strInputValue, strPhaseID, strPhaseResultNumber);
            }
            else if (String.Compare("Group Rank", strColumnName, true) == 0)
            {
                strUpdateSQL = String.Format("UPDATE TS_Phase_Result SET [F_PhaseRank] = {0} WHERE F_PhaseID = {1} AND F_PhaseResultNumber ={2}", strInputValue, strPhaseID, strPhaseResultNumber);
            }
            else if (String.Compare("Display Position", strColumnName, true) == 0)
            {
                strUpdateSQL = String.Format("UPDATE TS_Phase_Result SET [F_PhaseDisplayPosition] = {0} WHERE F_PhaseID = {1} AND F_PhaseResultNumber ={2}", strInputValue, strPhaseID, strPhaseResultNumber);
            }
            else if (String.Compare("Event Rank", strColumnName, true) == 0)
            {
                strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_EventRank] = {0} WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputValue, strEventID, strEventResultNumber);
            }
            else if (String.Compare("Phase Rank", strColumnName, true) == 0)
            {
                strUpdateSQL = String.Format("UPDATE TS_Phase_Result SET [F_PhaseRank] = {0} WHERE F_PhaseID = {1} AND F_PhaseResultNumber ={2}", strInputValue, strPhaseID, strPhaseResultNumber);
            }
            else if (String.Compare("Event Points", strColumnName, true) == 0)
            {
                strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_EventPoints] = {0} WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputValue, strEventID, strEventResultNumber);
            }               
            else if (String.Compare("Event Display Position", strColumnName, true) == 0)
            {
                strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_EventDisplayPosition] = {0} WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputValue, strEventID, strEventResultNumber);
            }
            else if (String.Compare("Medal Date", strColumnName, true) == 0)
            {
                if (strInputValue == "" || strInputValue == "0")
                {
                    strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_MedalCreateDate] = NULL WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputValue, strEventID, strEventResultNumber);
                }
                else
                {
                    strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_MedalCreateDate] = '{0}' WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputValue, strEventID, strEventResultNumber);
                }
            }
            else if (String.Compare("Result Date", strColumnName, true) == 0)
            {
                if (strInputValue == "" || strInputValue == "0")
                {
                    strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_ResultCreateDate] = NULL WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputValue, strEventID, strEventResultNumber);
                }
                else
                {
                    strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_ResultCreateDate] = '{0}' WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputValue, strEventID, strEventResultNumber);
                }
            }
            else if (String.Compare("Medal", strColumnName, true) == 0)
            {
                UpdateEventMedal(strEventID, strEventResultNumber, strInputKey);
                UpdateResultList();

                int iEventID = Convert.ToInt32(strEventID);
                //m_RankMedal.DataChangedNotify(OVRDataChangedType.emEventResult, -1, iEventID, -1, -1, iEventID, null);
            }
            else if (String.Compare("Competitor Name", strColumnName, true) == 0)
            {
                if (iNodeType == -1)//Event
                {
                    if (strInputKey == "0")
                    {
                    }
                    else if (strInputKey == "-2")
                    {
                        strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_RegisterID] = NULL WHERE F_EventID = {0} AND F_EventResultNumber ={1}", strEventID, strEventResultNumber);
                    }
                    else
                    {
                        strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_RegisterID] = {0} WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputKey, strEventID, strEventResultNumber);
                    }
                }
                else if (iNodeType == 0)//Phase
                {
                    if (strInputKey == "0")
                    {
                    }
                    else if (strInputKey == "-2")
                    {
                        strUpdateSQL = String.Format("UPDATE TS_Phase_Result SET [F_RegisterID] = NULL WHERE F_PhaseID = {0} AND F_PhaseResultNumber ={1}", strPhaseID, strPhaseResultNumber);
                    }
                    else
                    {
                        strUpdateSQL = String.Format("UPDATE TS_Phase_Result SET [F_RegisterID] = {0} WHERE F_PhaseID = {1} AND F_PhaseResultNumber ={2}", strInputKey, strPhaseID, strPhaseResultNumber);
                    }
                }
            }
            else if (String.Compare("F_SourcePhaseName", strColumnName, true) == 0)
            {
                if (iNodeType == -1)//Event
                {
                    if (strInputKey == "0")
                    {
                    }
                    else if (strInputKey == "-1")
                    {
                        strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_SourcePhaseID] = NULL WHERE F_EventID = {0} AND F_EventResultNumber ={1}", strEventID, strEventResultNumber);
                    }
                    else
                    {
                        strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_SourcePhaseID] = {0} WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputKey, strEventID, strEventResultNumber);
                    }
                }
                else if (iNodeType == 0)//Phase
                {
                    if (strInputKey == "0")
                    {
                    }
                    else if (strInputKey == "-1")
                    {
                        strUpdateSQL = String.Format("UPDATE TS_Phase_Result SET [F_SourcePhaseID] = NULL WHERE F_PhaseID = {0} AND F_PhaseResultNumber ={1}", strPhaseID, strPhaseResultNumber);
                    }
                    else
                    {
                        strUpdateSQL = String.Format("UPDATE TS_Phase_Result SET [F_SourcePhaseID] = {0} WHERE F_PhaseID = {1} AND F_PhaseResultNumber ={2}", strInputKey, strPhaseID, strPhaseResultNumber);
                    }
                }
            }
            else if (String.Compare("F_SourcePhaseRank", strColumnName, true) == 0)
            {
                if (strInputValue == "0")
                {
                    strInputValue = "NULL";
                }
                if (iNodeType == -1)//Event
                {
                    strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_SourcePhaseRank] = {0} WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputValue, strEventID, strEventResultNumber);
                }
                else if (iNodeType == 0)//Phase
                {
                    strUpdateSQL = String.Format("UPDATE TS_Phase_Result SET [F_SourcePhaseRank] = {0} WHERE F_PhaseID = {1} AND F_PhaseResultNumber ={2}", strInputValue, strPhaseID, strPhaseResultNumber);
                }
            }
            else if (String.Compare("F_SourceMatchName", strColumnName, true) == 0)
            {
                if (iNodeType == -1)//Event
                {
                    if (strInputKey == "0")
                    {
                    }
                    else if (strInputKey == "-1")
                    {
                        strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_SourceMatchID] = NULL WHERE F_EventID = {0} AND F_EventResultNumber ={1}", strEventID, strEventResultNumber);
                    }
                    else
                    {
                        strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_SourceMatchID] = {0} WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputKey, strEventID, strEventResultNumber);
                    }
                }
                else if (iNodeType == 0)//Phase
                {
                    if (strInputKey == "0")
                    {
                    }
                    else if (strInputKey == "-1")
                    {
                        strUpdateSQL = String.Format("UPDATE TS_Phase_Result SET [F_SourceMatchID] = NULL WHERE F_PhaseID = {0} AND F_PhaseResultNumber ={1}", strPhaseID, strPhaseResultNumber);
                    }
                    else
                    {
                        strUpdateSQL = String.Format("UPDATE TS_Phase_Result SET [F_SourceMatchID] = {0} WHERE F_PhaseID = {1} AND F_PhaseResultNumber ={2}", strInputKey, strPhaseID, strPhaseResultNumber);
                    }
                }
            }
            else if (String.Compare("F_SourceMatchRank", strColumnName, true) == 0)
            {
                if (strInputValue == "0")
                {
                    strInputValue = "NULL";
                }

                if (iNodeType == -1)//Event
                {
                    strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_SourceMatchRank] = {0} WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputValue, strEventID, strEventResultNumber);
                }
                else if (iNodeType == 0)//Phase
                {
                    strUpdateSQL = String.Format("UPDATE TS_Phase_Result SET [F_SourceMatchRank] = {0} WHERE F_PhaseID = {1} AND F_PhaseResultNumber ={2}", strInputValue, strPhaseID, strPhaseResultNumber);
                }
            }
            else if (String.Compare("IRM", strColumnName, true) == 0)
            {

                if (iNodeType == 0)//Phase
                {
                    if (strInputKey == "-1")
                    {
                        strUpdateSQL = String.Format("UPDATE TS_Phase_Result SET [F_IRMID] = NULL WHERE F_PhaseID = {1} AND F_PhaseResultNumber ={2}", strInputKey, strPhaseID, strPhaseResultNumber);
                    }
                    else
                    {
                        strUpdateSQL = String.Format("UPDATE TS_Phase_Result SET [F_IRMID] = {0} WHERE F_PhaseID = {1} AND F_PhaseResultNumber ={2}", strInputKey, strPhaseID, strPhaseResultNumber);
                    }
                }
            }

            if (strUpdateSQL != null)
            {
                if (m_RankMedal.DatabaseConnection.State != ConnectionState.Open)
                {
                    m_RankMedal.DatabaseConnection.Open();
                }

                using (SqlCommand cmdUpdateResult = new SqlCommand(strUpdateSQL, m_RankMedal.DatabaseConnection))
                {
                    try
                    {
                        cmdUpdateResult.ExecuteNonQuery();
                    }
                    catch (System.Exception errorUpdate)
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(errorUpdate.Message);
                        return;
                    }
                }

                UpdateResultList();

                if (iNodeType == -1)//Event
                {
                    int iEventID = Convert.ToInt32(strEventID);
                    //m_RankMedal.DataChangedNotify(OVRDataChangedType.emEventResult, -1, iEventID, -1, -1, iEventID, null);
                }
                else if (iNodeType == 0)//Phase
                {
                    int iPhaseID = Convert.ToInt32(strPhaseID);
                    m_RankMedal.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);
                }
            }
        }

        private void dgridResult_SelectionChanged(object sender, EventArgs e)
        {
            if (dgridResult.SelectedRows.Count > 0)
            {
                string strValue = dgridResult.SelectedRows[0].Cells["F_RegisterID"].Value.ToString();
                m_RankMedal.SetReportContext("RegisterID", strValue);
            }
            else
                m_RankMedal.SetReportContext("RegisterID", "-1");
        }

        private void topItem_PopupOpen(object sender, PopupOpenEventArgs e)
        {
            DevComponents.AdvTree.Node SecectedNode = tvPhaseTree.SelectedNode;
            if (SecectedNode != null)
            {
                SAxTreeNodeInfo msNodeInfo = (SAxTreeNodeInfo)SecectedNode.Tag;

                switch (msNodeInfo.iNodeType)
                {
                    case -1://Event
                        topItem.SubItems[0].Enabled = true;
                        topItem.SubItems[1].Enabled = true;
                        break;
                    case 0://Phase
                        topItem.SubItems[0].Enabled = true;
                        topItem.SubItems[1].Enabled = true;
                        break;
                    case 1://Match
                    case -3://Sport
                    case -2://Discipline
                    default:
                        e.Cancel = true;
                        break;
                }
            }
        }

        #endregion

        private void UpdatePhaseTree()
        {
            tvPhaseTree.BeginUpdate();
            tvPhaseTree.Nodes.Clear();
            DevComponents.AdvTree.Node oLastSelNode = null;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_RankMedal.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetScheduleTree";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@ID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "@ID",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@Type", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "@Type",
                            DataRowVersion.Current, -5);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@Option", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "@Option",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@Option1", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "@Option1",
                            DataRowVersion.Current, 1);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strActiveLanuageCode);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                if (m_RankMedal.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_RankMedal.DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                int cols = sdr.FieldCount;                                          //获取结果行中的列数





                object[] values = new object[cols];
                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        String strNodeName = "";
                        String strNodeKey = "";
                        String strFatherNodeKey = "";
                        int iNodeType = -5;//-4表示所有Sport, -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase
                        int iSportID = 0;
                        int iDisciplineID = 0;
                        int iEventID = 0;
                        int iPhaseID = 0;
                        int iPhaseType = 0;
                        int iPhaseSize = 0;
                        int iFatherPhaseID = 0;
                        int iMatchID = 0;
                        int nImage = 0;
                        int nSelectedImage = 0;

                        strNodeName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_NodeName");
                        strNodeKey = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_NodeKey");
                        strFatherNodeKey = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_FatherNodeKey");
                        iNodeType = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_NodeType");
                        iSportID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_SportID");
                        iDisciplineID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_DisciplineID");
                        iEventID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_EventID");
                        iPhaseID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_PhaseID");
                        iPhaseType = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_PhaseType");
                        iPhaseSize = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_PhaseSize");
                        iFatherPhaseID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_FatherPhaseID");
                        iMatchID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_MatchID");
                        nImage = iNodeType + 3;
                        nSelectedImage = iNodeType + 3;

                        SAxTreeNodeInfo oneSNodeInfo = new SAxTreeNodeInfo();
                        oneSNodeInfo.strNodeKey = strNodeKey;
                        oneSNodeInfo.iNodeType = iNodeType;
                        oneSNodeInfo.iSportID = iSportID;
                        oneSNodeInfo.iDisciplineID = iDisciplineID;
                        oneSNodeInfo.iEventID = iEventID;
                        oneSNodeInfo.iPhaseID = iPhaseID;
                        oneSNodeInfo.iPhaseType = iPhaseType;
                        oneSNodeInfo.iPhaseSize = iPhaseSize;
                        oneSNodeInfo.iFatherPhaseID = iFatherPhaseID;
                        oneSNodeInfo.iMatchID = iMatchID;

                        DevComponents.AdvTree.Node oneNode = new DevComponents.AdvTree.Node();
                        oneNode.Text = strNodeName;
                        oneNode.ImageIndex = nImage;
                        oneNode.ImageExpandedIndex = nSelectedImage;
                        oneNode.Tag = oneSNodeInfo;
                        oneNode.DataKey = strNodeKey;

                        if (oneSNodeInfo.iNodeType == -3)
                        {
                            oneNode.Expanded = true;
                        }
                        if (oneSNodeInfo.iNodeType == -2 && oneSNodeInfo.iDisciplineID == m_iActiveDiscID)
                        {
                            oneNode.Expanded = true;
                        }

                        DevComponents.AdvTree.Node FatherNode = tvPhaseTree.FindNodeByDataKey(strFatherNodeKey);
                        if (FatherNode == null)
                        {
                            tvPhaseTree.Nodes.Add(oneNode);
                        }
                        else
                        {
                            FatherNode.Nodes.Add(oneNode);
                        }

                        if (m_strLastSelPhaseTreeNodeKey == strNodeKey)
                        {
                            oLastSelNode = oneNode;
                            oneNode.Expanded = true;

                            // Expand All Parent Node
                            DevComponents.AdvTree.Node node = oLastSelNode;
                            while (node.Parent != null)
                            {
                                node.Parent.Expanded = true;
                                node = node.Parent;
                            }
                        }
                    }
                }
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            tvPhaseTree.EndUpdate();
            tvPhaseTree.SelectedNode = oLastSelNode;
        }

        private void UpdateResultList()
        {
            if (m_RankMedal.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RankMedal.DatabaseConnection.Open();
            }

            // Get PhaseResult from db
            SqlCommand oneSqlCommand = new SqlCommand();
            oneSqlCommand.Connection = m_RankMedal.DatabaseConnection;
            oneSqlCommand.CommandText = "Proc_GetPhaseResults";
            oneSqlCommand.CommandType = CommandType.StoredProcedure;

            oneSqlCommand.Parameters.AddWithValue("@EventID", m_iSelPhaseTreeEventID);
            oneSqlCommand.Parameters.AddWithValue("@PhaseID", m_iSelPhaseTreePhaseID);
            oneSqlCommand.Parameters.AddWithValue("@MatchID", m_iSelPhaseTreeMatchID);
            oneSqlCommand.Parameters.AddWithValue("@Type", m_iSelPhaseTreeNodeType);
            oneSqlCommand.Parameters.AddWithValue("@LanguageCode", m_strActiveLanuageCode);

            // Fill data to grid
            try
            {
                SqlDataReader recordset = oneSqlCommand.ExecuteReader();
                if (recordset == null) return;
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgridResult, recordset, "Medal", "Competitor Name", "F_SourcePhaseName", "F_SourceMatchName", "IRM");
                recordset.Close();
            }
            catch (System.Exception errorProc)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(errorProc.Message);
                return;
            }

            // Make the following cols editable
            DataGridViewColumn editableCol = dgridResult.Columns["Group Points"];
            if (editableCol != null)
                editableCol.ReadOnly = false;

            editableCol = dgridResult.Columns["Group Rank"];
            if (editableCol != null)
                editableCol.ReadOnly = false;

            editableCol = dgridResult.Columns["Display Position"];
            if (editableCol != null)
                editableCol.ReadOnly = false;

            editableCol = dgridResult.Columns["Event Points"];
            if (editableCol != null)
                editableCol.ReadOnly = false;

            editableCol = dgridResult.Columns["Event Rank"];
            if (editableCol != null)
                editableCol.ReadOnly = false;

            editableCol = dgridResult.Columns["Phase Rank"];
            if (editableCol != null)
                editableCol.ReadOnly = false;

            editableCol = dgridResult.Columns["Event Display Position"];
            if (editableCol != null)
                editableCol.ReadOnly = false;

            editableCol = dgridResult.Columns["F_SourcePhaseRank"];
            if (editableCol != null)
                editableCol.ReadOnly = false;

            editableCol = dgridResult.Columns["F_SourceMatchRank"];
            if (editableCol != null)
                editableCol.ReadOnly = false;

            editableCol = dgridResult.Columns["Medal Date"];
            if (editableCol != null)
                editableCol.ReadOnly = false;

            editableCol = dgridResult.Columns["Result Date"];
            if (editableCol != null)
                editableCol.ReadOnly = false;

            // GetMedalCombbox content
            oneSqlCommand.Connection = m_RankMedal.DatabaseConnection;
            oneSqlCommand.CommandText = @"SELECT B.F_MedalLongName, A.F_MedalID 
                                          FROM TC_Medal AS A LEFT JOIN TC_Medal_Des AS B ON A.F_MedalID = B.F_MedalID 
                                          WHERE B.F_LanguageCode='" + m_strActiveLanuageCode + "'";
            oneSqlCommand.CommandType = CommandType.Text;

            try
            {
                SqlDataReader recordset = oneSqlCommand.ExecuteReader();
                if (recordset == null) return;

                DGVCustomComboBoxColumn medalCol = (DGVCustomComboBoxColumn)dgridResult.Columns["Medal"];
                if (medalCol != null)
                {
                    DataTable medalCmbContent = new DataTable();
                    medalCmbContent.Load(recordset);
                    medalCmbContent.Rows.Add("NONE", -1);
                    medalCol.FillComboBoxItems(medalCmbContent, 0, 1);
                }

                recordset.Close();
            }
            catch (System.Exception errorSQL)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(errorSQL.Message);
            }
        }

        private void ClearResultList()
        {
            dgridResult.Columns.Clear();
            dgridResult.Rows.Clear();
        }

        private bool UpdateEventMedal(String strEventID, String strPosition, String strMedal)
        {
            if (strMedal == null || strMedal == "0" || strMedal == "") return false;

            if (m_RankMedal.DatabaseConnection.State != ConnectionState.Open)
            {
                m_RankMedal.DatabaseConnection.Open();
            }

            SqlCommand cmdUpdateMedal = new SqlCommand("Proc_UpdateEventMedal", m_RankMedal.DatabaseConnection);
            cmdUpdateMedal.CommandType = CommandType.StoredProcedure;

            cmdUpdateMedal.Parameters.AddWithValue("@EventID", strEventID);
            cmdUpdateMedal.Parameters.AddWithValue("@Position", strPosition);
            if (strMedal == "-1")
            {
                cmdUpdateMedal.Parameters.AddWithValue("@MedalID", DBNull.Value);
            }
            else
            {
                cmdUpdateMedal.Parameters.AddWithValue("@MedalID", strMedal);
            }
            

            SqlParameter ParamOut = new SqlParameter();
            ParamOut.ParameterName = "@Result";
            ParamOut.Size = 4;
            ParamOut.Direction = ParameterDirection.Output;

            cmdUpdateMedal.Parameters.Add(ParamOut);

            try
            {
                cmdUpdateMedal.ExecuteNonQuery();
            }
            catch (System.Exception errorProc)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(errorProc.Message);
                return false;
            }

            string strText;
            int nRetValue = Convert.ToInt32(ParamOut.Value);
            switch (nRetValue)
            {
                case 0:
                    strText = LocalizationRecourceManager.GetString(strSectionName, "UpdEvtMdlFailed");
                    DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                    break;
                case 1:
                    //DevComponents.DotNetBar.MessageBoxEx.Show("更改获奖情况成功！");
                    break;
                case -1:
                    strText = LocalizationRecourceManager.GetString(strSectionName, "UpdEvtMdlFailed_InvdParam");
                    DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                    break;
                case -2:
                    strText = LocalizationRecourceManager.GetString(strSectionName, "UpdEvtMdlFailed_NotAllowed");
                    DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                    break;
            }

            return false;
        }

        private bool OutPutEventResult(int iEventID, string eventText)
        {
            if (iEventID <= 0) return false;

            if (m_RankMedal.DatabaseConnection.State != ConnectionState.Open)
            {
                m_RankMedal.DatabaseConnection.Open();
            }

            SqlCommand cmdOutPutResult = new SqlCommand("Proc_Info_OutPutEventResult_AutoSwitch", m_RankMedal.DatabaseConnection);
            cmdOutPutResult.CommandType = CommandType.StoredProcedure;
            cmdOutPutResult.Parameters.AddWithValue("@EventID", iEventID);
            cmdOutPutResult.Parameters.AddWithValue("@LanguageCode", m_strActiveLanuageCode);

            SqlDataReader HistoryResult = null;
            bool ret = false;
            try
            {   
                String strFileName = null;
                saveResultDlg.FileName = eventText;
                if (saveResultDlg.ShowDialog() == DialogResult.OK)
                {
					//Modified by WangZheng, we should show Dialog first, and then executeReader.
					HistoryResult = cmdOutPutResult.ExecuteReader();
                    strFileName = saveResultDlg.FileName;
                    ret = DataReaderToCSVFile(HistoryResult, strFileName, ",");
                }
            }
            catch (System.Exception errorProc)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(errorProc.Message);
            }
            finally
            {
                if (HistoryResult != null)
                {
                    HistoryResult.Close();
                }
            }
            return ret;
        }

        private String GetEventCode(int iEventID)
        {
            if (iEventID <= 0) return null;
            if (m_RankMedal.DatabaseConnection.State != ConnectionState.Open)
            {
                m_RankMedal.DatabaseConnection.Open();
            }
            String strEventCode = "";
            SqlCommand cmdGetEventCode = new SqlCommand("SELECT F_EventCode FROM TS_Event WHERE F_EventID = " + iEventID.ToString(), m_RankMedal.DatabaseConnection);
            try
            {
                strEventCode = cmdGetEventCode.ExecuteScalar().ToString();
            }
            catch (System.Exception errorSQL)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(errorSQL.Message);
            }

            return strEventCode;
        }

        private Int32 GetFieldValue(DataGridView dgv, Int32 iRowIndex, String strFiledName)
        {
            Int32 iReturnValue = 0;
            if (dgv.Columns[strFiledName] == null || dgv.Rows[iRowIndex].Cells[strFiledName].Value.ToString() == "")
            {
                iReturnValue = 0;
            }
            else
            {
                iReturnValue = Convert.ToInt32(dgv.Rows[iRowIndex].Cells[strFiledName].Value);
            }
            return iReturnValue;
        }

        private String GetFieldValue2Str(DataGridView dgv, Int32 iRowIndex, String strFiledName)
        {
            String strReturnValue = "0";
            if (dgv.Columns[strFiledName] == null || dgv.Rows[iRowIndex].Cells[strFiledName].Value.ToString() == "")
            {
                strReturnValue = "0";
            }
            else
            {
                strReturnValue = Convert.ToString(dgv.Rows[iRowIndex].Cells[strFiledName].Value);
            }
            return strReturnValue;
        }

        private String GetFieldValue2Str(DataGridView dgv, Int32 iRowIndex, Int32 iColIndex)
        {
            String strReturnValue = "0";
            if (dgv.Columns[iColIndex] == null || dgv.Rows[iRowIndex].Cells[iColIndex].Value == null || dgv.Rows[iRowIndex].Cells[iColIndex].Value.ToString() == "")
            {
                strReturnValue = "0";
            }
            else
            {
                strReturnValue = Convert.ToString(dgv.Rows[iRowIndex].Cells[iColIndex].Value);
            }
            return strReturnValue;
        }

        private void InitPhaseCombBox(ref UIDataGridView GridCtrl, Int32 iColumnIndex, Int32 iEventID, Int32 iPhaseID, Int32 iMatchID, String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_RankMedal.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetMatchSourcePhases";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iEventID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                if (m_RankMedal.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_RankMedal.DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(sdr, "F_LongName", "F_ID");
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void InitSourceMatchCombBox(ref UIDataGridView GridCtrl, Int32 iColumnIndex, Int32 iEventID, Int32 iPhaseID, Int32 iMatchID, Int32 iSourcePhaseID, String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_RankMedal.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetMatchSourceMatches";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iEventID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@SourcePhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iSourcePhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                if (m_RankMedal.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_RankMedal.DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(sdr, "F_LongName", "F_ID");
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void InitPhaseIRMCombBox(ref UIDataGridView GridCtrl, Int32 iColumnIndex, Int32 iPhaseID, String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_RankMedal.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetPhaseIRMsList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter1);


                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (m_RankMedal.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_RankMedal.DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(sdr, "F_LongName", "F_IRMID");
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public bool DataReaderToCSVFile(SqlDataReader tableRecords, String SavePath, String splitToken)
        {
            if (tableRecords.FieldCount <= 0) return false;

            try
            {
                StreamWriter fileWriter = new StreamWriter(SavePath, false, Encoding.Default);

                // Fill the field names
                String strFieldName = "";
                for (int i = 0; i < tableRecords.FieldCount; i++)
                {
                    strFieldName += tableRecords.GetName(i) + splitToken;
                }
                fileWriter.WriteLine(strFieldName);

                // File the Records               
                while (tableRecords.Read())
                {
                    String strRecord = "";
                    for (int i = 0; i < tableRecords.FieldCount; i++)
                    {
                        strRecord += tableRecords[i].ToString() + splitToken;
                    }
                    fileWriter.WriteLine(strRecord);
                }

                fileWriter.Flush();
                fileWriter.Close();
            }
            catch (System.Exception eFile)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(eFile.Message);
                return false;
            }

            return true;
        }

        private bool OutHistoryResult(String strEventID, String strPhaseID, String strRegisterID, String strRegisterName, String strType)
        {
            if (m_RankMedal.DatabaseConnection.State != ConnectionState.Open)
            {
                m_RankMedal.DatabaseConnection.Open();
            }
            SqlCommand cmdHistoryResult = new SqlCommand("Proc_OutPutHistoryResult", m_RankMedal.DatabaseConnection);
            cmdHistoryResult.CommandType = CommandType.StoredProcedure;
            cmdHistoryResult.Parameters.AddWithValue("@EventID", strEventID);
            cmdHistoryResult.Parameters.AddWithValue("@PhaseID", strPhaseID);
            cmdHistoryResult.Parameters.AddWithValue("@RegisterID", strRegisterID);
            cmdHistoryResult.Parameters.AddWithValue("@LanguageCode", m_strActiveLanuageCode);
            cmdHistoryResult.Parameters.AddWithValue("@Type", strType);

            SqlDataReader HistoryResult = null;
            bool ret = false;
            try
            {
                HistoryResult = cmdHistoryResult.ExecuteReader();
                String strFileName = null;
                if (saveResultDlg.ShowDialog() == DialogResult.OK)
                {
                    strFileName = saveResultDlg.FileName;
                    ret = DataReaderToCSVFile(HistoryResult, strFileName, ",");
                }
            }
            catch (System.Exception errorProc)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(errorProc.Message);
            }
            finally
            {
                HistoryResult.Close();
            }
            return ret;
        }

        private void MenuEditEventStatus_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == -1)
            {
                frmSetEventStatus SetEventStatusForm = new frmSetEventStatus();

                SetEventStatusForm.DatabaseConnection = m_RankMedal.DatabaseConnection;
                SetEventStatusForm.LanguageCode = m_strActiveLanuageCode;

                SetEventStatusForm.EventID = oneSNodeInfo.iEventID;


                SetEventStatusForm.ShowDialog();

                if (SetEventStatusForm.DialogResult == DialogResult.OK)
                {
                    int iEventID = oneSNodeInfo.iEventID;
                    m_strLastSelPhaseTreeNodeKey = "E" + iEventID.ToString();

                    UpdatePhaseTree();

                    this.m_RankMedal.DataChangedNotify(OVRDataChangedType.emEventStatus, -1, iEventID, -1, -1, iEventID, null);
                }
            }
        }

        private void tvPhaseTree_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                // Get right click node!
                DevComponents.AdvTree.Node SelNode = this.tvPhaseTree.GetNodeAt(this.PointToClient(this.PointToScreen(new Point(e.X, e.Y))));
                if (SelNode != null)
                {
                    SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
                    switch (oneSNodeInfo.iNodeType)
                    {
                        case -3://Sport
                            MenuEditEventStatus.Enabled = false;
                            break;
                        case -2://Discipline
                            MenuEditEventStatus.Enabled = false;
                            break;
                        case -1://Event
                            MenuEditEventStatus.Enabled = true;
                            break;
                        case 0://Phase
                            MenuEditEventStatus.Enabled = false;
                            break;
                        case 1://Match
                            MenuEditEventStatus.Enabled = false;
                            break;
                        default://其余的不需要处理!
                            break;
                    }
                }
                else
                {
                    //DevComponents.DotNetBar.MessageBoxEx.Show("Right Click on Nothing!");
                }
            }
        }

        private void btnSendEventResult_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNode == null)
                return;

            DevComponents.AdvTree.Node selectedNode = tvPhaseTree.SelectedNode;
            SAxTreeNodeInfo msNodeInfo = (SAxTreeNodeInfo)selectedNode.Tag;
            switch (msNodeInfo.iNodeType)
            {
                case -3://Sport
                case -2://Discipline
                    break;
                case -1://Event
                    if (msNodeInfo.iEventID > 0)
                    {
                        m_RankMedal.DataChangedNotify(OVRDataChangedType.emEventResult, -1, msNodeInfo.iEventID, -1, -1, msNodeInfo.iEventID, null);
                        DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(strSectionName, "MsgSendEventResult")); 
                    }
                    break;
                case 0://Phase
                    break;
                case 1://Match
                default:
                    break;
            }
        }

        private void btnEventDateSetting_Click(object sender, EventArgs e)
        {
            frmDateInput DateInputForm = new frmDateInput();

            DateInputForm.ShowDialog();

            if (DateInputForm.DialogResult == DialogResult.OK)
            {
                string strInputDate = DateInputForm.m_InputDate;
                DataGridViewRow row = new DataGridViewRow();

                if (dgridResult.SelectedRows.Count > 0)
                {
                    try
                    {
                        SqlCommand oneSqlCommand = new SqlCommand();
                        oneSqlCommand.Connection = m_RankMedal.DatabaseConnection;
                        oneSqlCommand.CommandType = CommandType.Text;

                        for (int i = 0; i < dgridResult.SelectedRows.Count; i++)
                        {
                            row = dgridResult.SelectedRows[i];
                            Int32 iRowIdx = row.Index;
                            string strEventID = GetFieldValue2Str(dgridResult, iRowIdx, "F_EventID");
                            string strEventResultNumber = GetFieldValue2Str(dgridResult, iRowIdx, "F_EventResultNumber");

                            string strUpdateSQL;

                            if (strInputDate == "")
                            {
                               strUpdateSQL  = String.Format("UPDATE TS_Event_Result SET [F_ResultCreateDate] = NULL WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputDate, strEventID, strEventResultNumber);
                            }
                            else
                            {
                                strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_ResultCreateDate] = '{0}' WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputDate, strEventID, strEventResultNumber);
                            }

                            if (strUpdateSQL != null)
                            {
                                oneSqlCommand.CommandText = strUpdateSQL;
                                if (m_RankMedal.DatabaseConnection.State != ConnectionState.Open)
                                {
                                    m_RankMedal.DatabaseConnection.Open();
                                }

                                oneSqlCommand.ExecuteNonQuery();
                            }
                        }
                    }
                    catch (System.Exception ee)
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(ee.Message);
                    }
                }
            }

            UpdateResultList();
        }

        private void btnMedalDateSetting_Click(object sender, EventArgs e)
        {
            frmDateInput DateInputForm = new frmDateInput();

            DateInputForm.ShowDialog();

            if (DateInputForm.DialogResult == DialogResult.OK)
            {
                string strInputDate = DateInputForm.m_InputDate;
                DataGridViewRow row = new DataGridViewRow();

                if (dgridResult.SelectedRows.Count > 0)
                {
                    try
                    {
                        SqlCommand oneSqlCommand = new SqlCommand();
                        oneSqlCommand.Connection = m_RankMedal.DatabaseConnection;
                        oneSqlCommand.CommandType = CommandType.Text;

                        for (int i = 0; i < dgridResult.SelectedRows.Count; i++)
                        {
                            row = dgridResult.SelectedRows[i];
                            Int32 iRowIdx = row.Index;
                            string strEventID = GetFieldValue2Str(dgridResult, iRowIdx, "F_EventID");
                            string strEventResultNumber = GetFieldValue2Str(dgridResult, iRowIdx, "F_EventResultNumber");

                            string strUpdateSQL;

                            if (strInputDate == "")
                            {
                                strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_MedalCreateDate] = NULL WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputDate, strEventID, strEventResultNumber);
                            }
                            else
                            {
                                strUpdateSQL = String.Format("UPDATE TS_Event_Result SET [F_MedalCreateDate] = '{0}' WHERE F_EventID = {1} AND F_EventResultNumber ={2}", strInputDate, strEventID, strEventResultNumber);
                            }

                            if (strUpdateSQL != null)
                            {
                                oneSqlCommand.CommandText = strUpdateSQL;
                                if (m_RankMedal.DatabaseConnection.State != ConnectionState.Open)
                                {
                                    m_RankMedal.DatabaseConnection.Open();
                                }

                                oneSqlCommand.ExecuteNonQuery();
                            }
                        }
                    }
                    catch (System.Exception ee)
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(ee.Message);
                    }
                }
            }

            UpdateResultList();
        }

    }
}