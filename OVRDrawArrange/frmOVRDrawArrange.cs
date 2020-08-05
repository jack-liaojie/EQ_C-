using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Collections;
using AutoSports.OVRCommon;
using AutoSports.OVRDrawModel;
using AutoSports.OVRRegister;

using DevComponents.DotNetBar;
using System.Diagnostics;
using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    struct SAxMatchInfo     //存储competitor列表中的比赛信息
    {
        public int iMatchID;
        public int iCompetitorPosition;
    }

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

    delegate void UpdatePosGridDelegate(bool bNext);

    public partial class OVRDrawArrangeForm : UIPage
    {
        private OVRDrawArrangeModule m_drawArrangeModule;
        private SqlCommand cmdSelCompetitors = new SqlCommand();
        private SqlCommand cmdSelMatches = new SqlCommand();

        private String m_strSectionName = "OVRDrawArrange";
        private Int32 m_iSportID = 0;
        private Int32 m_iDisciplineID = 0;
        private String m_strLanguageCode = "CHN";

        private bool m_bUpdateDrawPhaseTree = false;

        private Int32 m_iSelCompetitor = -1;
        private Int32 m_iSelMatch = -1;
        private string m_strLastSelPhaseTreeNodeKey;
        private Int32 m_iSelPhaseTreeEventID = -1;
        private Int32 m_iSelPhaseTreePhaseID = -1;
        private Int32 m_iSelPhaseTreeMatchID = -1;
        private Int32 m_iSelPhaseTreeNodeType = -4;

        public  ArrayList  m_aryMatchCompetitor = new  ArrayList();

        public OVRDrawArrangeModule DrawArrangeModule
        {
            set { m_drawArrangeModule = value; }
        }


        public OVRDrawArrangeForm(string strName)
        {
            InitializeComponent();

            Localization();
            InitDrawLocalization();

            this.Name = strName;
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvCompetitors);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatches);

        }

        private void OVRDrawArrangeForm_Load(object sender, EventArgs e)
        {
            IniCommands();

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
            OVRDataBaseUtils.GetActiveInfo(m_drawArrangeModule.DatabaseConnection, out m_iSportID, out m_iDisciplineID, out m_strLanguageCode);
            UpdatePhaseTree();
            UpdateDrawPhaseTree();
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

            if (flags.IsSignaled(OVRDataChangedType.emEventAdd) ||
                flags.IsSignaled(OVRDataChangedType.emEventDel) ||
                flags.IsSignaled(OVRDataChangedType.emEventStatus) ||
                flags.IsSignaled(OVRDataChangedType.emEventInfo) ||
                flags.IsSignaled(OVRDataChangedType.emPhaseStatus) ||
                flags.IsSignaled(OVRDataChangedType.emMatchStatus))
            {
                UpdatePhaseTree();
                UpdateDrawPhaseTree();
            }
            else if (flags.IsSignaled(OVRDataChangedType.emRegisterModify))
            {
                if (tvPhaseTree.SelectedNodes.Count > 0)
                {
                    UpdateCompetitors();
                    UpdateMatches();
                }
                if (tvDrawPhaseTree.SelectedNodes.Count > 0 && m_iSelDrawTreeNodeType == 0)
                {
                    UpdatePhaseCompetitors();
                    UpdatePhaseCompetitorsPosition();
                }
            }
            else if (flags.IsSignaled(OVRDataChangedType.emMatchCompetitor))
            {
                if (tvPhaseTree.SelectedNodes.Count > 0)
                {
                    UpdateCompetitors();
                    UpdateMatches();
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
                        if (tvPhaseTree.Visible && tvPhaseTree.SelectedNode != null)
                        {
                            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)tvPhaseTree.SelectedNode.Tag;
                            args.Value = oneSNodeInfo.iSportID.ToString();
                            args.Handled = true;
                        }
                        else if (tvDrawPhaseTree.Visible && tvDrawPhaseTree.SelectedNode != null)
                        {
                            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)tvDrawPhaseTree.SelectedNode.Tag;
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
                        else if (tvDrawPhaseTree.Visible && tvDrawPhaseTree.SelectedNode != null)
                        {
                            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)tvDrawPhaseTree.SelectedNode.Tag;
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
                        else if (tvDrawPhaseTree.Visible && tvDrawPhaseTree.SelectedNode != null)
                        {
                            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)tvDrawPhaseTree.SelectedNode.Tag;
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
                        else if (tvDrawPhaseTree.Visible && tvDrawPhaseTree.SelectedNode != null)
                        {
                            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)tvDrawPhaseTree.SelectedNode.Tag;
                            args.Value = oneSNodeInfo.iPhaseID.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "MatchID":
                    {
                        if (dgvMatches.Visible && dgvMatches.SelectedRows.Count > 0)
                        {
                            args.Value = dgvMatches.SelectedRows[0].Cells["F_MatchID"].Value.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "RegisterID":
                    {
                        if (dgvCompetitors.Visible && dgvCompetitors.SelectedRows.Count > 0)
                        {
                            args.Value = dgvCompetitors.SelectedRows[0].Cells["F_RegisterID"].Value.ToString();
                            args.Handled = true;
                        }
                        break;
                    }
            }
        }

        private bool IsUpdateAllData(OVRDataChangedFlags flags)
        {
            if (m_drawArrangeModule == null) return false;

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

            return false;
        }

        #region Assist Functions

        public void UpdatePosGridSel(bool bNext)
        {
            int iSelIndex = dgvCompetitors.SelectedRows[0].Index;
            if(bNext)
            {
                iSelIndex++;
            }
            else
            {
                iSelIndex--;
            }
            dgvCompetitors.ClearSelection();
            dgvCompetitors.FirstDisplayedScrollingRowIndex = iSelIndex;
            dgvCompetitors.Rows[iSelIndex].Selected = true;
            m_iSelCompetitor = iSelIndex;
        }

        private void IniCommands()
        {
            cmdSelCompetitors.Connection = m_drawArrangeModule.DatabaseConnection;
            cmdSelCompetitors.CommandText = "Proc_GetMatchCompetitors";
            cmdSelCompetitors.CommandType = CommandType.StoredProcedure;
            cmdSelCompetitors.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int));
            cmdSelCompetitors.Parameters.Add(new SqlParameter("@PhaseID", SqlDbType.Int));
            cmdSelCompetitors.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int));
            cmdSelCompetitors.Parameters.Add(new SqlParameter("@Type", SqlDbType.Int));
            cmdSelCompetitors.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3));

            cmdSelMatches.Connection = m_drawArrangeModule.DatabaseConnection;
            cmdSelMatches.CommandText = "Proc_GetMatchFullDes";
            cmdSelMatches.CommandType = CommandType.StoredProcedure;
            cmdSelMatches.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int));
            cmdSelMatches.Parameters.Add(new SqlParameter("@PhaseID", SqlDbType.Int));
            cmdSelMatches.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int));
            cmdSelMatches.Parameters.Add(new SqlParameter("@Type", SqlDbType.Int));
            cmdSelMatches.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3));
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

        private void UpdatePhaseTree()
        {
            tvPhaseTree.BeginUpdate();
            tvPhaseTree.Nodes.Clear();
            DevComponents.AdvTree.Node oLastSelNode = null;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
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
                            DataRowVersion.Current, 1);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@Option1", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "@Option1",
                            DataRowVersion.Current, 1);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguageCode);

                oneSqlCommand.Parameters.Add(cmdParameter5);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                int cols = sdr.FieldCount;  //获取结果行中的列数
                object[] values = new object[cols];
                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        String strNodeName = "";
                        String strNodeKey = "";
                        String strFatherNodeKey = "";
                        int iNodeType = -5; // -4表示所有Sport, -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase
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
                        oneNode.Expanded = false;

                        if (oneSNodeInfo.iNodeType == -3)
                        {
                            oneNode.Expanded = true;
                        }
                        if (oneSNodeInfo.iNodeType == -2 && oneSNodeInfo.iDisciplineID == m_iDisciplineID)
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

        private void UpdateCompetitors()
        {
            int iFirstDisplayedScrollingRowIndex = dgvCompetitors.FirstDisplayedScrollingRowIndex;
            int iFirstDisplayedScrollingColumnIndex = dgvCompetitors.FirstDisplayedScrollingColumnIndex;
            if (iFirstDisplayedScrollingRowIndex < 0) iFirstDisplayedScrollingRowIndex = 0;
            if (iFirstDisplayedScrollingColumnIndex < 0) iFirstDisplayedScrollingColumnIndex = 0;

            if (tvPhaseTree.SelectedNodes.Count < 1)
            {
                dgvCompetitors.Rows.Clear();
                dgvCompetitors.Columns.Clear();
                return;
            }

            cmdSelCompetitors.Parameters[0].Value = m_iSelPhaseTreeEventID;
            cmdSelCompetitors.Parameters[1].Value = m_iSelPhaseTreePhaseID;
            cmdSelCompetitors.Parameters[2].Value = m_iSelPhaseTreeMatchID;
            cmdSelCompetitors.Parameters[3].Value = m_iSelPhaseTreeNodeType;
            cmdSelCompetitors.Parameters[4].Value = m_strLanguageCode;

            if (cmdSelCompetitors.Connection.State == System.Data.ConnectionState.Closed)
            {
                cmdSelCompetitors.Connection.Open();
            }

            DataTable dt = new DataTable();
            SqlDataReader sdr = null;
            try
            {
                sdr = cmdSelCompetitors.ExecuteReader();
                dt.Load(sdr);
                sdr.Close();
                sdr = null;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                if (sdr != null)
                {
                    sdr.Close();
                }
            }
            OVRDataBaseUtils.FillDataGridViewWithCmb(dgvCompetitors, dt, "Competitor Name", "Competitor_Name",
                                                    "F_StartPhaseName", "F_SourcePhaseName", "F_SourceMatchName", "F_HistoryMatchName");

            if (dgvCompetitors.Columns["Position1"] != null)
            {
                dgvCompetitors.Columns["Position1"].ReadOnly = false;
            }

            if (dgvCompetitors.Columns["Position2"] != null)
            {
                dgvCompetitors.Columns["Position2"].ReadOnly = false;
            }

            if (dgvCompetitors.Columns["F_StartPhasePosition"] != null)
            {
                dgvCompetitors.Columns["F_StartPhasePosition"].ReadOnly = false;
            }

            if (dgvCompetitors.Columns["F_SourcePhaseRank"] != null)
            {
                dgvCompetitors.Columns["F_SourcePhaseRank"].ReadOnly = false;
            }

            if (dgvCompetitors.Columns["F_SourceMatchRank"] != null)
            {
                dgvCompetitors.Columns["F_SourceMatchRank"].ReadOnly = false;
            }

            if (dgvCompetitors.Columns["F_HistoryMatchRank"] != null)
            {
                dgvCompetitors.Columns["F_HistoryMatchRank"].ReadOnly = false;
            }

            if (dgvCompetitors.Columns["F_HistoryLevel"] != null)
            {
                dgvCompetitors.Columns["F_HistoryLevel"].ReadOnly = false;
            }

            if (dgvCompetitors.Columns["F_SouceProgressDes"] != null)
            {
                dgvCompetitors.Columns["F_SouceProgressDes"].ReadOnly = false;
            }

            if (dgvCompetitors.Columns["F_ProgressDes"] != null)
            {
                dgvCompetitors.Columns["F_ProgressDes"].ReadOnly = false;
            }

            dgvCompetitors.ClearSelection();
            if(m_iSelCompetitor < 0)
            {
                m_iSelCompetitor = 0;
            }
            if(m_iSelCompetitor > dgvCompetitors.RowCount - 1)
            {
                m_iSelCompetitor = dgvCompetitors.RowCount - 1;
            }

            if (0 <= m_iSelCompetitor && m_iSelCompetitor < dgvCompetitors.RowCount)
            {
                dgvCompetitors.FirstDisplayedScrollingRowIndex = m_iSelCompetitor;
                dgvCompetitors.Rows[m_iSelCompetitor].Selected = true;
            }

            m_aryMatchCompetitor.Clear();
            for(int i = 0; i< dgvCompetitors.RowCount; i++)
            {
                if (dgvCompetitors.Columns["F_MatchID"] == null)
                {
                    continue;
                }
                SAxMatchInfo stTempMatchInfo;
                stTempMatchInfo.iMatchID = Convert.ToInt32(dgvCompetitors.Rows[i].Cells["F_MatchID"].Value);
                stTempMatchInfo.iCompetitorPosition = Convert.ToInt32(dgvCompetitors.Rows[i].Cells["F_CompetitionPosition"].Value);
                m_aryMatchCompetitor.Add(stTempMatchInfo);
            }

            if (iFirstDisplayedScrollingRowIndex < dgvCompetitors.Rows.Count)
                dgvCompetitors.FirstDisplayedScrollingRowIndex = iFirstDisplayedScrollingRowIndex;
            if (iFirstDisplayedScrollingColumnIndex < dgvCompetitors.Columns.Count)
                dgvCompetitors.FirstDisplayedScrollingColumnIndex = iFirstDisplayedScrollingColumnIndex;
        }

        private void UpdateMatches()
        {
            int iFirstDisplayedScrollingRowIndex = dgvMatches.FirstDisplayedScrollingRowIndex;
            int iFirstDisplayedScrollingColumnIndex = dgvMatches.FirstDisplayedScrollingColumnIndex;
            if (iFirstDisplayedScrollingRowIndex < 0) iFirstDisplayedScrollingRowIndex = 0;
            if (iFirstDisplayedScrollingColumnIndex < 0) iFirstDisplayedScrollingColumnIndex = 0;

            if (tvPhaseTree.SelectedNodes.Count < 1)
            {
                dgvMatches.Rows.Clear();
                dgvMatches.Columns.Clear();
                return;
            }

            cmdSelMatches.Parameters[0].Value = m_iSelPhaseTreeEventID;
            cmdSelMatches.Parameters[1].Value = m_iSelPhaseTreePhaseID;
            cmdSelMatches.Parameters[2].Value = m_iSelPhaseTreeMatchID;
            cmdSelMatches.Parameters[3].Value = m_iSelPhaseTreeNodeType;
            cmdSelMatches.Parameters[4].Value = m_strLanguageCode;

            if (cmdSelMatches.Connection.State == System.Data.ConnectionState.Closed)
            {
                cmdSelMatches.Connection.Open();
            }

            SqlDataReader sdr = cmdSelMatches.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(sdr);
            sdr.Close();
            OVRDataBaseUtils.FillDataGridView(dgvMatches, dt, null, null);

            if (dgvMatches.Columns["M.Num"] != null)
            {
                dgvMatches.Columns["M.Num"].ReadOnly = false;
            }

            if (0 < m_iSelMatch && m_iSelMatch < dgvMatches.RowCount)
            {
                dgvMatches.FirstDisplayedScrollingRowIndex = m_iSelMatch;
                dgvMatches.Rows[m_iSelMatch].Selected = true;
            }

            if (iFirstDisplayedScrollingRowIndex < dgvMatches.Rows.Count)
                dgvMatches.FirstDisplayedScrollingRowIndex = iFirstDisplayedScrollingRowIndex;
            if (iFirstDisplayedScrollingColumnIndex < dgvMatches.Columns.Count)
                dgvMatches.FirstDisplayedScrollingColumnIndex = iFirstDisplayedScrollingColumnIndex;
        }

        #endregion

        #region User Interface Operations

        private void btnUpdateData_Click(object sender, EventArgs e)
        {
            OVRDataBaseUtils.GetActiveInfo(m_drawArrangeModule.DatabaseConnection, out m_iSportID, out m_iDisciplineID, out m_strLanguageCode);
            UpdatePhaseTree();
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
                            MenuSetEventModel.Enabled = false;
                            MenuLoadPartModel.Enabled = false;
                            MenuEditEventStatus.Enabled = false;
                            MenuAddPhase.Enabled = false;
                            MenuEditPhase.Enabled = false;
                            MenuDelPhase.Enabled = false;
                            MenuAddMatch.Enabled = false;
                            MenuEditMatch.Enabled = false;
                            MenuDelMatch.Enabled = false;
                            MenuSaveLoadEventModel.Enabled = false;
                            MenuSavePartModel.Enabled = false;
                            MenuSetMatchesRule.Enabled = false;
                            break;
                        case -2://Discipline
                            MenuSetEventModel.Enabled = false;
                            MenuLoadPartModel.Enabled = false;
                            MenuEditEventStatus.Enabled = false;
                            MenuAddPhase.Enabled = false;
                            MenuEditPhase.Enabled = false;
                            MenuDelPhase.Enabled = false;
                            MenuAddMatch.Enabled = false;
                            MenuEditMatch.Enabled = false;
                            MenuDelMatch.Enabled = false;
                            MenuSaveLoadEventModel.Enabled = false;
                            MenuSavePartModel.Enabled = false;
                            MenuSetMatchesRule.Enabled = false;
                            break;
                        case -1://Event
                            MenuSetEventModel.Enabled = true;
                            MenuLoadPartModel.Enabled = false;
                            MenuEditEventStatus.Enabled = true;
                            MenuAddPhase.Enabled = true;
                            MenuEditPhase.Enabled = false;
                            MenuDelPhase.Enabled = false;
                            MenuAddMatch.Enabled = false;
                            MenuEditMatch.Enabled = false;
                            MenuDelMatch.Enabled = false;
                            MenuSaveLoadEventModel.Enabled = true;
                            MenuSavePartModel.Enabled = false;
                            MenuSetMatchesRule.Enabled = true;
                            break;
                        case 0://Phase
                            MenuSetEventModel.Enabled = false;
                            MenuLoadPartModel.Enabled = true;
                            MenuEditEventStatus.Enabled = false;
                            MenuAddPhase.Enabled = true;
                            MenuEditPhase.Enabled = true;
                            MenuDelPhase.Enabled = true;
                            MenuAddMatch.Enabled = true;
                            MenuEditMatch.Enabled = false;
                            MenuDelMatch.Enabled = false;
                            MenuSaveLoadEventModel.Enabled = false;
                            MenuSavePartModel.Enabled = true;
                            MenuSetMatchesRule.Enabled = true;
                            break;
                        case 1://Match
                            MenuSetEventModel.Enabled = false;
                            MenuLoadPartModel.Enabled = true;
                            MenuEditEventStatus.Enabled = false;
                            MenuAddPhase.Enabled = false;
                            MenuEditPhase.Enabled = false;
                            MenuDelPhase.Enabled = false;
                            MenuAddMatch.Enabled = false;
                            MenuEditMatch.Enabled = true;
                            MenuDelMatch.Enabled = true;
                            MenuSaveLoadEventModel.Enabled = false;
                            MenuSavePartModel.Enabled = true;
                            MenuSetMatchesRule.Enabled = true;
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

        private void tvPhaseTree_AfterNodeSelect(object sender, DevComponents.AdvTree.AdvTreeNodeEventArgs e)
        {
            if (e.Node != null)
            {
                SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)e.Node.Tag;

                m_strLastSelPhaseTreeNodeKey = oneSNodeInfo.strNodeKey;
                m_iSelPhaseTreeNodeType = oneSNodeInfo.iNodeType;
                m_iSelPhaseTreeEventID = oneSNodeInfo.iEventID;
                m_iSelPhaseTreePhaseID = oneSNodeInfo.iPhaseID;
                m_iSelPhaseTreeMatchID = oneSNodeInfo.iMatchID;

                if (m_iSelPhaseTreeNodeType == 0)
                {
                    btnProgressByes.Enabled = true;
                    btnAutoProgress.Enabled = true;
                }
                UpdateCompetitors();
                UpdateMatches();

                // Update Report Context
                m_drawArrangeModule.SetReportContext("SportID", oneSNodeInfo.iSportID.ToString());
                m_drawArrangeModule.SetReportContext("DisciplineID", oneSNodeInfo.iDisciplineID.ToString());
                m_drawArrangeModule.SetReportContext("EventID", oneSNodeInfo.iEventID.ToString());
                m_drawArrangeModule.SetReportContext("PhaseID", oneSNodeInfo.iPhaseID.ToString());
            }
            else
            {
                // Update Report Context
                m_drawArrangeModule.SetReportContext("SportID", "-1");
                m_drawArrangeModule.SetReportContext("DisciplineID", "-1");
                m_drawArrangeModule.SetReportContext("EventID", "-1");
                m_drawArrangeModule.SetReportContext("PhaseID", "-1");
            }
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

                SetEventStatusForm.DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
                SetEventStatusForm.LanguageCode = m_strLanguageCode;

                SetEventStatusForm.EventID = oneSNodeInfo.iEventID;


                SetEventStatusForm.ShowDialog();

                if (SetEventStatusForm.DialogResult == DialogResult.OK)
                {
                    int iEventID = oneSNodeInfo.iEventID;
                    m_strLastSelPhaseTreeNodeKey = "E" + iEventID.ToString();

                    UpdatePhaseTree();

                    m_bUpdateDrawPhaseTree = true;

                    this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emEventStatus, -1, iEventID, -1, -1, iEventID, null);
                }
            }
        }

        private void MenuAddPhase_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == -1 || oneSNodeInfo.iNodeType == 0)
            {
                Int32 iEventID = oneSNodeInfo.iEventID;
                Int32 iPhaseID = oneSNodeInfo.iPhaseID;
                Int32 iSportID;
                Int32 iDisciplineID;

                AxDrawModelInfo drawInfo = new AxDrawModelInfo();
                AxDrawModelMatchList drawModel = AxModelMgr.CreateModelSingle(ref drawInfo);

                if (drawInfo.m_eType == EDrawModelType.emTypeNone)
                    return;

                AxOVRDrawModelHelper modelHelper = new AxOVRDrawModelHelper();
                modelHelper.m_DatabaseConnection = m_drawArrangeModule.DatabaseConnection;

                OVRDataBaseUtils.GetActiveInfo(m_drawArrangeModule.DatabaseConnection, out iSportID, out iDisciplineID, out modelHelper.m_strLanguageCode);
                List<AxDrawModelPlayerFrom> aryModelPlayerList = new List<AxDrawModelPlayerFrom>();

                Int32 nRetPhaseID = modelHelper.CreateSingleDrawModel(iEventID, iPhaseID, drawInfo, drawModel, aryModelPlayerList, -1);

                if (nRetPhaseID >= 0)
                {
                    m_strLastSelPhaseTreeNodeKey = String.Format("P{0}", nRetPhaseID);

                    UpdatePhaseTree();

                    m_bUpdateDrawPhaseTree = true;

                    this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emPhaseAdd, -1, -1, nRetPhaseID, -1, nRetPhaseID, null);
                }
                else if (nRetPhaseID == -2)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgAddPhase4"));
                }
            }
            else
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgAddPhase3"));
            }
        }

        private void MenuEditPhase_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == 0)
            {
                PhaseInfoForm frmPhaseInfo = new PhaseInfoForm();
                frmPhaseInfo.m_iOperateType = 2;
                frmPhaseInfo.Module = m_drawArrangeModule;
                frmPhaseInfo.m_DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
                frmPhaseInfo.m_strLanguageCode = m_strLanguageCode;
                frmPhaseInfo.m_iPhaseID = oneSNodeInfo.iPhaseID;

                frmPhaseInfo.ShowDialog();

                if (frmPhaseInfo.DialogResult == DialogResult.OK)
                {
                    UpdatePhaseTree();

                    m_bUpdateDrawPhaseTree = true;

                    if (frmPhaseInfo.IsInfoChanged)
                        this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emPhaseInfo, -1, -1, oneSNodeInfo.iPhaseID, -1, oneSNodeInfo.iPhaseID, null);

                    if (frmPhaseInfo.IsStatusChanged)
                        this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emPhaseStatus, -1, -1, oneSNodeInfo.iPhaseID, -1, oneSNodeInfo.iPhaseID, null);
                }
            }
        }

        private void MenuDelPhase_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == 0)
            {
                string message = LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelPhase1");
                string caption = "Draw Arrange";
                MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                if (DevComponents.DotNetBar.MessageBoxEx.Show(message, caption, buttons) == DialogResult.Yes)
                {
                    try
                    {
                        Int32 iOperateResult;
                        SqlCommand oneSqlCommand = new SqlCommand();
                        oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                        oneSqlCommand.CommandText = "proc_DelPhase";
                        oneSqlCommand.CommandType = CommandType.StoredProcedure;

                        SqlParameter cmdParameter1 = new SqlParameter(
                                    "@PhaseID", SqlDbType.Int, 4,
                                    ParameterDirection.Input, true, 0, 0, "",
                                    DataRowVersion.Current, oneSNodeInfo.iPhaseID);
                        oneSqlCommand.Parameters.Add(cmdParameter1);

                        SqlParameter cmdParameter2 = new SqlParameter(
                                    "@Result", SqlDbType.Int, 4,
                                    ParameterDirection.Output, true, 0, 0, "",
                                    DataRowVersion.Current, 0);

                        oneSqlCommand.Parameters.Add(cmdParameter2);

                        if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                        {
                            m_drawArrangeModule.DatabaseConnection.Open();
                        }

                        if (oneSqlCommand.ExecuteNonQuery() != 0)
                        {
                            iOperateResult = (Int32)cmdParameter2.Value;
                            switch (iOperateResult)
                            {
                                case 0:
                                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelPhase2"));
                                    break;
                                case -1:
                                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelPhase3"));
                                    break;
                                case -2:
                                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelPhase4"));
                                    break;
                                case -3:
                                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelPhase5"));
                                    break;
                                case -4:
                                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelPhase6"));
                                    break;
                                case -5:
                                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelPhase7"));
                                    break;
                                default://其余的需要为删除成功!
                                    if (oneSNodeInfo.iFatherPhaseID == 0)
                                        m_strLastSelPhaseTreeNodeKey = "E" + oneSNodeInfo.iEventID.ToString();
                                    else
                                        m_strLastSelPhaseTreeNodeKey = "P" + oneSNodeInfo.iFatherPhaseID.ToString();

                                    UpdatePhaseTree();

                                    m_bUpdateDrawPhaseTree = true;

                                    this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emPhaseDel, -1, -1, oneSNodeInfo.iPhaseID, -1, oneSNodeInfo.iPhaseID, null);

                                    break;
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                    }
                }
            }
        }

        private void MenuAddMatch_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == 0)
            {
                MatchInfoForm matchInfoForm = new MatchInfoForm();
                matchInfoForm.OperateType = 1;
                matchInfoForm.Module = m_drawArrangeModule;
                matchInfoForm.DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
                matchInfoForm.LanguageCode = m_strLanguageCode;

                matchInfoForm.EventID = oneSNodeInfo.iEventID;
                matchInfoForm.PhaseID = oneSNodeInfo.iPhaseID;

                matchInfoForm.ShowDialog();

                if (matchInfoForm.DialogResult == DialogResult.OK)
                {
                    int iMatchID = matchInfoForm.MatchID;
                    m_strLastSelPhaseTreeNodeKey = "M" + iMatchID.ToString();

                    UpdatePhaseTree();

                    m_bUpdateDrawPhaseTree = true;

                    this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emMatchAdd, -1, -1, -1, iMatchID, iMatchID, null);
                }
            }
        }

        private void MenuEditMatch_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == 1)
            {
                MatchInfoForm matchInfoForm = new MatchInfoForm();
                matchInfoForm.OperateType = 2;
                matchInfoForm.Module = m_drawArrangeModule;
                matchInfoForm.DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
                matchInfoForm.LanguageCode = m_strLanguageCode;

                matchInfoForm.EventID = oneSNodeInfo.iEventID;
                matchInfoForm.PhaseID = oneSNodeInfo.iPhaseID;
                matchInfoForm.MatchID = oneSNodeInfo.iMatchID;
                matchInfoForm.ShowDialog();

                if (matchInfoForm.DialogResult == DialogResult.OK)
                {
                    m_strLastSelPhaseTreeNodeKey = "M" + matchInfoForm.MatchID.ToString();

                    UpdatePhaseTree();

                    m_bUpdateDrawPhaseTree = true;

                    this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emMatchInfo, -1, -1, -1, oneSNodeInfo.iMatchID, oneSNodeInfo.iMatchID, null);
                }
            }
        }

        private void MenuDelMatch_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == 1)
            {
                string message = LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelMatch1");
                string caption = "Draw Arrange";
                MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                if (DevComponents.DotNetBar.MessageBoxEx.Show(message, caption, buttons) == DialogResult.Yes)
                {
                    try
                    {
                        Int32 iOperateResult;
                        SqlCommand oneSqlCommand = new SqlCommand();
                        oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                        oneSqlCommand.CommandText = "proc_DelMatch";
                        oneSqlCommand.CommandType = CommandType.StoredProcedure;

                        SqlParameter cmdParameter1 = new SqlParameter(
                                    "@MatchID", SqlDbType.Int, 4,
                                    ParameterDirection.Input, true, 0, 0, "",
                                    DataRowVersion.Current, oneSNodeInfo.iMatchID);
                        oneSqlCommand.Parameters.Add(cmdParameter1);

                        SqlParameter cmdParameter2 = new SqlParameter(
                                    "@Result", SqlDbType.Int, 4,
                                    ParameterDirection.Output, true, 0, 0, "",
                                    DataRowVersion.Current, 0);

                        oneSqlCommand.Parameters.Add(cmdParameter2);

                        if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                        {
                            m_drawArrangeModule.DatabaseConnection.Open();
                        }

                        if (oneSqlCommand.ExecuteNonQuery() != 0)
                        {
                            iOperateResult = (Int32)cmdParameter2.Value;
                            switch (iOperateResult)
                            {
                                case 0:
                                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelMatch2"));
                                    break;
                                case -1:
                                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelMatch3"));
                                    break;
                                case -2:
                                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelMatch4"));
                                    break;
                                case -3:
                                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelMatch5"));
                                    break;
                                default:// 删除成功
                                    m_strLastSelPhaseTreeNodeKey = "P" + oneSNodeInfo.iPhaseID.ToString();

                                    UpdatePhaseTree();

                                    m_bUpdateDrawPhaseTree = true;

                                    this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emMatchDel, -1, -1, -1, oneSNodeInfo.iMatchID, oneSNodeInfo.iMatchID, null);
                                    break;
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                    }
                }
            }
        }

        private void MenuSetEventModel_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == -1)
            {
                Int32 iEventID = oneSNodeInfo.iEventID;

                SetEventModelForm frmSetEventModel = new SetEventModelForm();
                frmSetEventModel.m_DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
                frmSetEventModel.m_strLanguageCode = m_strLanguageCode;
                frmSetEventModel.m_iEventID = iEventID;
                frmSetEventModel.ShowDialog();
                if (frmSetEventModel.DialogResult == DialogResult.OK)
                {
                    if (frmSetEventModel.m_iOpearateTypeID == 1)
                    {
                        if (DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelEventModel"), LocalizationRecourceManager.GetString(m_strSectionName, "MsgAutoEventModel"), MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                        {
                            return;
                        }
                        else
                        {
                            if (DeleteEventPhases(iEventID))
                            {
                                AxDrawModelEvent modelEvent = AxModelMgr.CreateModelEvent();
                                AxOVRDrawModelHelper modelHelper = new AxOVRDrawModelHelper();
                                modelHelper.m_DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
                                modelHelper.m_strLanguageCode = m_strLanguageCode;
                                bool bRet = modelHelper.CreteDrawEvent(iEventID, modelEvent);
                                if (bRet)
                                    m_strLastSelPhaseTreeNodeKey = "E" + iEventID.ToString();

                                UpdatePhaseTree();

                                m_bUpdateDrawPhaseTree = true;

                                this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emEventModel, -1, iEventID, -1, -1, iEventID, null);
                            }
                        }
                    }
                    else if (frmSetEventModel.m_iOpearateTypeID == 2)
                    {
                        m_strLastSelPhaseTreeNodeKey = "E" + iEventID.ToString();

                        UpdatePhaseTree();

                        m_bUpdateDrawPhaseTree = true;

                        this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emEventModel, -1, iEventID, -1, -1, iEventID, null);
                    }
                }
            }
        }

        private void MenuSaveLoadEventModel_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == -1)
            {
                frmModelInfo ModelInfofrm = new frmModelInfo();
                ModelInfofrm.m_DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
                ModelInfofrm.m_strLanguageCode = m_strLanguageCode;
                ModelInfofrm.m_iEventID = oneSNodeInfo.iEventID;
                ModelInfofrm.ShowDialog();

                UpdatePhaseTree();
            }
        }

        private void MenuLoadPartModel_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == 0 || oneSNodeInfo.iNodeType == 1)
            {
                Int32 iEventID = oneSNodeInfo.iEventID;
                Int32 iPhaseID = oneSNodeInfo.iPhaseID;
                Int32 iMatchID = oneSNodeInfo.iMatchID;

                SetPartModelForm frmSetPartModel = new SetPartModelForm();
                frmSetPartModel.m_DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
                frmSetPartModel.m_iNodeType = oneSNodeInfo.iNodeType;
                frmSetPartModel.m_iPhaseID = iPhaseID;
                frmSetPartModel.m_iMatchID = iMatchID;
                frmSetPartModel.ShowDialog();
                if (frmSetPartModel.DialogResult == DialogResult.OK)
                {
                    m_strLastSelPhaseTreeNodeKey = oneSNodeInfo.strNodeKey;

                    UpdatePhaseTree();

                    if (oneSNodeInfo.iNodeType == 0)
                    {
                        this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emPhaseModel, -1, -1, iPhaseID, -1, iPhaseID, null);
                    } 
                    else
                    {
                        this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emMatchModel, -1, -1, -1, iMatchID, iMatchID, null);
                    }
                }
            }
        }

        private void MenuSavePartModel_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == 0 || oneSNodeInfo.iNodeType == 1)
            {
                Int32 iEventID = oneSNodeInfo.iEventID;
                Int32 iPhaseID = oneSNodeInfo.iPhaseID;
                Int32 iMatchID = oneSNodeInfo.iMatchID;

                PartModelInfoForm frmPartModelInfo = new PartModelInfoForm();
                frmPartModelInfo.m_DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
                frmPartModelInfo.m_iNodeType = oneSNodeInfo.iNodeType;
                frmPartModelInfo.m_iPhaseID = iPhaseID;
                frmPartModelInfo.m_iMatchID = iMatchID;
                frmPartModelInfo.ShowDialog();

                UpdatePhaseTree();
            }
        }

        private void MenuSetMatchesRule_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == -1 || oneSNodeInfo.iNodeType == 0 || oneSNodeInfo.iNodeType == 1)
            {
                SetMatchesRuleForm frmSetMatchesRule = new SetMatchesRuleForm();
                frmSetMatchesRule.DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
                frmSetMatchesRule.LanguageCode = m_strLanguageCode;
                frmSetMatchesRule.NodeType = oneSNodeInfo.iNodeType;
                frmSetMatchesRule.DisciplineID = oneSNodeInfo.iDisciplineID;
                frmSetMatchesRule.EventID = oneSNodeInfo.iEventID;
                frmSetMatchesRule.PhaseID = oneSNodeInfo.iPhaseID;
                frmSetMatchesRule.MatchID = oneSNodeInfo.iMatchID;

                frmSetMatchesRule.ShowDialog();
                if (frmSetMatchesRule.DialogResult == DialogResult.OK)
                {
                    //this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emMatchInfo, -1, -1, -1, oneSNodeInfo.iMatchID, null, null);
                }
            }
        }

        private void dgvCompetitors_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvCompetitors.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                Int32 iEventID = GetFieldValue(dgvCompetitors, iRowIndex, "F_EventID");
                Int32 iPhaseID = GetFieldValue(dgvCompetitors, iRowIndex, "F_PhaseID");
                Int32 iMatchID = GetFieldValue(dgvCompetitors, iRowIndex, "F_MatchID");
                Int32 iPosition = GetFieldValue(dgvCompetitors, iRowIndex, "F_CompetitionPosition");
                Int32 iSourcePhaseID = GetFieldValue(dgvCompetitors, iRowIndex, "F_SourcePhaseID");
                String strLanguageCode = m_strLanguageCode;

                if (dgvCompetitors.Columns[iColumnIndex].Name.CompareTo("Competitor Name") == 0)
                {
                    InitCompetitorsCombBox(ref dgvCompetitors, iColumnIndex, iEventID, iPhaseID, iMatchID, iPosition, strLanguageCode);
                }
                else if (dgvCompetitors.Columns[iColumnIndex].Name.CompareTo("Competitor_Name") == 0)
                {
                    iPosition = GetFieldValue(dgvCompetitors, iRowIndex, "Position");
                    InitCompetitorsCombBox(ref dgvCompetitors, iColumnIndex, iEventID, iPhaseID, iMatchID, iPosition, strLanguageCode);
                }
                else if (dgvCompetitors.Columns[iColumnIndex].Name.CompareTo("F_StartPhaseName") == 0)
                {
                    InitPhaseCombBox(ref dgvCompetitors, iColumnIndex, iEventID, iPhaseID, iMatchID, strLanguageCode);
                }
                else if (dgvCompetitors.Columns[iColumnIndex].Name.CompareTo("F_SourcePhaseName") == 0)
                {
                    InitPhaseCombBox(ref dgvCompetitors, iColumnIndex, iEventID, iPhaseID, iMatchID, strLanguageCode);
                }
                else if (dgvCompetitors.Columns[iColumnIndex].Name.CompareTo("F_SourceMatchName") == 0)
                {
                    InitSourceMatchCombBox(ref dgvCompetitors, iColumnIndex, iEventID, iPhaseID, iMatchID, iSourcePhaseID, strLanguageCode);
                }
                else if (dgvCompetitors.Columns[iColumnIndex].Name.CompareTo("F_HistoryMatchName") == 0)
                {
                    InitHistoryMatchCombBox(ref dgvCompetitors, iColumnIndex, iEventID, iPhaseID, iMatchID, iSourcePhaseID, strLanguageCode);
                }
            }
        }

        private void dgvCompetitors_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            m_iSelCompetitor = iRowIndex;
            String strColumnName = dgvCompetitors.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvCompetitors.Rows[iRowIndex].Cells[iColumnIndex];
            if (CurCell != null)
            {
                Int32 iEventID = GetFieldValue(dgvCompetitors, iRowIndex, "F_EventID");
                Int32 iPhaseID = GetFieldValue(dgvCompetitors, iRowIndex, "F_PhaseID");
                Int32 iMatchID = GetFieldValue(dgvCompetitors, iRowIndex, "F_MatchID");
                Int32 iPosition = GetFieldValue(dgvCompetitors, iRowIndex, "F_CompetitionPosition");
                Int32 iSourcePhaseID = GetFieldValue(dgvCompetitors, iRowIndex, "F_SourcePhaseID");

                Int32 iInputValue = 0;
                Int32 iInputKey = 0;
                String strInputString = "";
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    iInputKey = Convert.ToInt32(CurCell1.Tag);
                }
                else
                {
                    if (CurCell.Value != null)
                    {
                        strInputString = CurCell.Value.ToString();
                        try
                        {
                            iInputValue = Convert.ToInt32(CurCell.Value);
                        }
                        catch (System.Exception ex)
                        {
                            iInputValue = -1;
                        }
                    }
                    else
                    {
                        iInputValue = -1;
                    }
                }
                bool bNeedRefreshCompetitors = true;
                bool bNeedRefreshMatches = true;

                if (strColumnName.CompareTo("Position1") == 0)
                {
                    UpdateMatchPositionDes1(iMatchID, iPosition, iInputValue);
                    bNeedRefreshCompetitors = false;
                }
                else if (strColumnName.CompareTo("Position2") == 0)
                {
                    UpdateMatchPositionDes2(iMatchID, iPosition, iInputValue);
                    bNeedRefreshCompetitors = false;
                }
                else if (strColumnName.CompareTo("F_StartPhasePosition") == 0)
                {
                    UpdateMatchStartPhasePosition(iMatchID, iPosition, iInputValue);
                }
                else if (strColumnName.CompareTo("F_SourcePhaseRank") == 0)
                {
                    UpdateMatchSourcePhaseRank(iMatchID, iPosition, iInputValue);
                }
                else if (strColumnName.CompareTo("F_SourceMatchRank") == 0)
                {
                    UpdateMatchSourceMatchRank(iMatchID, iPosition, iInputValue);
                }
                else if (strColumnName.CompareTo("F_HistoryMatchRank") == 0)
                {
                    UpdateMatchHistoryMatchRank(iMatchID, iPosition, iInputValue);
                }
                else if (strColumnName.CompareTo("F_HistoryLevel") == 0)
                {
                    UpdateMatchHistoryLevel(iMatchID, iPosition, iInputValue);
                }
                else if (strColumnName.CompareTo("F_SourcePhaseName") == 0)
                {
                    UpdateMatchSourcePhase(iMatchID, iPosition, iInputKey);
                }
                else if (strColumnName.CompareTo("F_SourceMatchName") == 0)
                {
                    UpdateMatchSourceMatch(iMatchID, iPosition, iInputKey);
                }
                else if (strColumnName.CompareTo("F_StartPhaseName") == 0)
                {
                    UpdateMatchStartPhase(iMatchID, iPosition, iInputKey);
                }
                else if (strColumnName.CompareTo("F_HistoryMatchName") == 0)
                {
                    UpdateMatchHistoryMatch(iMatchID, iPosition, iInputKey);
                }
                else if (strColumnName.CompareTo("Competitor Name") == 0)
                {
                    UpdateMatchRegister(iMatchID, iPosition, iInputKey);
                }
                else if (strColumnName.CompareTo("Competitor_Name") == 0)
                {
                    iPosition = GetFieldValue(dgvCompetitors, iRowIndex, "Position");
                    UpdateGroupRegister(iPhaseID, iPosition, iInputKey);
                }
                else if (strColumnName.CompareTo("F_SouceProgressDes") == 0)
                {
                    UpdateSourceProgressDes(iMatchID, iPosition, strInputString);
                }
                else if (strColumnName.CompareTo("F_ProgressDes") == 0)
                {
                    UpdateProgressDes(iMatchID, iPosition, strInputString);
                }

                if (bNeedRefreshCompetitors)
                {
                    UpdateCompetitors();
                    dgvCompetitors.Rows[iRowIndex].Selected = true;
                }

                if (bNeedRefreshMatches)
                {
                    UpdateMatches();
                }

                this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emMatchCompetitor, -1, -1, -1, iMatchID, iPosition, null);
            }
        }

        private void dgvCompetitors_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                MenuAddCompetitionPosition.Enabled = false;
                MenuEditCompetitionPostion.Enabled = false;
                MenuDeleteCompetitionPosition.Enabled = false;
                MenuAddMultiCompetitionPosition.Enabled = false;
                MenuCompetitionPos1Setting.Enabled = false;
                MenuCompetitionPos2Setting.Enabled = false;
                MenuCompetitionSourceSetting.Enabled = false;
                DevComponents.AdvTree.Node SelNode = this.tvPhaseTree.SelectedNode;
                if (SelNode != null)
                {
                    SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
                    if (oneSNodeInfo.iNodeType == 1)
                    {
                        MenuAddCompetitionPosition.Enabled = true;
                        MenuAddMultiCompetitionPosition.Enabled = true;
                        MenuCompetitionPos1Setting.Enabled = true;
                        MenuCompetitionPos2Setting.Enabled = true;
                        MenuCompetitionSourceSetting.Enabled = true;
                    }
                }

                if (dgvCompetitors.SelectedRows.Count > 0)
                {
                    MenuEditCompetitionPostion.Enabled = true;
                    MenuDeleteCompetitionPosition.Enabled = true;
                }
            }
        }

        private void MenuEditCompetitionPostion_Click(object sender, EventArgs e)
        {
            if (dgvCompetitors.SelectedRows.Count < 1)
                return;

            Int32 iRowIndex = dgvCompetitors.SelectedRows[0].Index;
            m_iSelCompetitor = iRowIndex;
            Int32 iEventID = GetFieldValue(dgvCompetitors, iRowIndex, "F_EventID");
            Int32 iPhaseID = GetFieldValue(dgvCompetitors, iRowIndex, "F_PhaseID");
            Int32 iMatchID = GetFieldValue(dgvCompetitors, iRowIndex, "F_MatchID");
            Int32 iPosition = GetFieldValue(dgvCompetitors, iRowIndex, "F_CompetitionPosition");

            if (iMatchID <= 0 || iPosition <= 0)
            {
                return;
            }

            MatchCompetitionPositionInfo CompetitionPositionInfoForm = new MatchCompetitionPositionInfo();
            CompetitionPositionInfoForm.OperateType = 1;
            CompetitionPositionInfoForm.DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
            CompetitionPositionInfoForm.LanguageCode = m_strLanguageCode;
            CompetitionPositionInfoForm.Module = m_drawArrangeModule;

            CompetitionPositionInfoForm.iSelPhaseTreeEventID = m_iSelPhaseTreeEventID;
            CompetitionPositionInfoForm.iSelPhaseTreePhaseID = m_iSelPhaseTreePhaseID;
            CompetitionPositionInfoForm.iSelPhaseTreeMatchID = m_iSelPhaseTreeMatchID;
            CompetitionPositionInfoForm.iSelPhaseTreeNodeType = 1;

            CompetitionPositionInfoForm.MatchID = iMatchID;
            CompetitionPositionInfoForm.CompetitionPosition = iPosition;
            CompetitionPositionInfoForm.m_aryMatchCompetitor = m_aryMatchCompetitor;
            
            SAxMatchInfo stTempMatchInfo;
            stTempMatchInfo.iMatchID = iMatchID;
            stTempMatchInfo.iCompetitorPosition = iPosition;
            CompetitionPositionInfoForm.m_iCurAryIndex = m_aryMatchCompetitor.IndexOf(stTempMatchInfo);
            CompetitionPositionInfoForm.m_ParentFrm = this;

            CompetitionPositionInfoForm.ShowDialog();
            if (CompetitionPositionInfoForm.DialogResult == DialogResult.OK)
            {
                UpdateCompetitors();
                UpdateMatches();
            }
        }

        private void MenuAddCompetitionPosition_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == 1)
            {
                try
                {
                    Int32 iOperateResult;
                    SqlCommand oneSqlCommand = new SqlCommand();
                    oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                    oneSqlCommand.CommandText = "proc_AddCompetitionPosition";
                    oneSqlCommand.CommandType = CommandType.StoredProcedure;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                "@MatchID", SqlDbType.Int, 4,
                                ParameterDirection.Input, true, 0, 0, "",
                                DataRowVersion.Current, oneSNodeInfo.iMatchID);
                    oneSqlCommand.Parameters.Add(cmdParameter1);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                "@Result", SqlDbType.Int, 4,
                                ParameterDirection.Output, true, 0, 0, "",
                                DataRowVersion.Current, 0);

                    oneSqlCommand.Parameters.Add(cmdParameter2);

                    if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                    {
                        m_drawArrangeModule.DatabaseConnection.Open();
                    }

                    if (oneSqlCommand.ExecuteNonQuery() != 0)
                    {
                        iOperateResult = (Int32)cmdParameter2.Value;
                        switch (iOperateResult)
                        {
                            case 0:
                                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgAddCompetitionPosition1"));
                                break;
                            case -1:
                                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgAddCompetitionPosition2"));
                                break;
                            default://其余为Position添加成功!
                                m_iSelCompetitor = dgvCompetitors.RowCount;
                                UpdateCompetitors();
                                UpdateMatches();

                                this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emMatchCompetitor, -1, -1, -1, oneSNodeInfo.iMatchID, iOperateResult, null);
                                break;
                        }
                    }
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void MenuAddMultiCompetitionPosition_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            
            frmSetPositionNum setPositionNum = new frmSetPositionNum();
            setPositionNum.m_bSetCompettionPos = true;
            setPositionNum.ShowDialog();

            if (setPositionNum.DialogResult == DialogResult.Cancel)
                return;

            Int32 nPostionNum = setPositionNum.m_nPositionNum;

            bool bResult = false;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == 1)
            {
                try
                {
                    Int32 iOperateResult;
                    SqlCommand oneSqlCommand = new SqlCommand();
                    oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                    oneSqlCommand.CommandText = "proc_AddCompetitionPosition";
                    oneSqlCommand.CommandType = CommandType.StoredProcedure;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                "@MatchID", SqlDbType.Int, 4,
                                ParameterDirection.Input, true, 0, 0, "",
                                DataRowVersion.Current, oneSNodeInfo.iMatchID);
                    oneSqlCommand.Parameters.Add(cmdParameter1);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                "@Result", SqlDbType.Int, 4,
                                ParameterDirection.Output, true, 0, 0, "",
                                DataRowVersion.Current, 0);

                    oneSqlCommand.Parameters.Add(cmdParameter2);

                    if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                    {
                        m_drawArrangeModule.DatabaseConnection.Open();
                    }


                    for (int i = 1; i <= nPostionNum; i++)
                    {
                         if (oneSqlCommand.ExecuteNonQuery() != 0)
                        {
                            iOperateResult = (Int32)cmdParameter2.Value;
                            switch (iOperateResult)
                            {
                                case 0:
                                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgAddCompetitionPosition1"));
                                    break;
                                case -1:
                                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgAddCompetitionPosition2"));
                                    break;
                                default://其余为Position添加成功!
                                    bResult = true;
                                    break;
                            }
                        }
                    }
                   
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }

                if(bResult)
                {
                    m_iSelCompetitor = dgvCompetitors.RowCount + nPostionNum - 1;
                    UpdateCompetitors();
                    this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emMatchCompetitor, -1, -1, -1, oneSNodeInfo.iMatchID, 1, null);
                    UpdateMatches();
                }
            }
           
        }

        private void MenuDeleteCompetitionPosition_Click(object sender, EventArgs e)
        {
            if (dgvCompetitors.SelectedRows.Count < 1)
                return;


            string message = LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelCompetitionPosition1");
            string caption = "Draw Arrange";
            MessageBoxButtons buttons = MessageBoxButtons.YesNo;

            if (DevComponents.DotNetBar.MessageBoxEx.Show(message, caption, buttons) == DialogResult.Yes)
            {
                m_iSelCompetitor = dgvCompetitors.SelectedRows[0].Index;
                for(int i = 0; i< dgvCompetitors.SelectedRows.Count; i++)
                {
                    Int32 iRowIndex = dgvCompetitors.SelectedRows[i].Index;

                    Int32 iEventID = GetFieldValue(dgvCompetitors, iRowIndex, "F_EventID");
                    Int32 iPhaseID = GetFieldValue(dgvCompetitors, iRowIndex, "F_PhaseID");
                    Int32 iMatchID = GetFieldValue(dgvCompetitors, iRowIndex, "F_MatchID");
                    Int32 iPosition = GetFieldValue(dgvCompetitors, iRowIndex, "F_CompetitionPosition");
                    try
                    {
                        Int32 iOperateResult;
                        SqlCommand oneSqlCommand = new SqlCommand();
                        oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                        oneSqlCommand.CommandText = "proc_DelCompetitionPosition";
                        oneSqlCommand.CommandType = CommandType.StoredProcedure;

                        SqlParameter cmdParameter1 = new SqlParameter(
                                    "@MatchID", SqlDbType.Int, 4,
                                    ParameterDirection.Input, true, 0, 0, "",
                                    DataRowVersion.Current, iMatchID);
                        oneSqlCommand.Parameters.Add(cmdParameter1);

                        SqlParameter cmdParameter2 = new SqlParameter(
                                    "@CompetitionPosition", SqlDbType.Int, 4,
                                    ParameterDirection.Input, true, 0, 0, "",
                                    DataRowVersion.Current, iPosition);
                        oneSqlCommand.Parameters.Add(cmdParameter2);

                        SqlParameter cmdParameter3 = new SqlParameter(
                                    "@Result", SqlDbType.Int, 4,
                                    ParameterDirection.Output, true, 0, 0, "",
                                    DataRowVersion.Current, 0);
                        oneSqlCommand.Parameters.Add(cmdParameter3);

                        if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                        {
                            m_drawArrangeModule.DatabaseConnection.Open();
                        }

                        if (oneSqlCommand.ExecuteNonQuery() != 0)
                        {
                            iOperateResult = (Int32)cmdParameter2.Value;
                            switch (iOperateResult)
                            {
                                case 0:
                                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelCompetitionPosition2"));
                                    continue;
                                case -1:
                                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelCompetitionPosition3"));
                                    continue;
                                default://其余的需要为删除成功!
                                    break;
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                    }
                    
                    this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emMatchCompetitor, -1, -1, -1, iMatchID, iPosition, null);
                }
                UpdateCompetitors();
                UpdateMatches();
            }
           
        }

        private void btnAutoProgress_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == 0)
            {
                bool bResult = false;
                bResult = OVRDataBaseUtils.AutoProgressPhase(oneSNodeInfo.iPhaseID, m_drawArrangeModule.DatabaseConnection, m_drawArrangeModule);
                if (bResult)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgAutoProgress1"));
                    UpdateCompetitors();
                    UpdateMatches();
                }
            }
            else if (oneSNodeInfo.iNodeType == 1)
            {
                bool bResult = false;
                bResult = OVRDataBaseUtils.AutoProgressMatch(oneSNodeInfo.iMatchID, m_drawArrangeModule.DatabaseConnection, m_drawArrangeModule);
                if (bResult)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgAutoProgress1"));
                    UpdateCompetitors();
                    UpdateMatches();
                }
            }
        }

        private void btnProgressByes_Click(object sender, EventArgs e)
        {
            if (tvPhaseTree.SelectedNodes.Count < 1 || tvPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == 0)
            {
                bool bResult = false;
                bResult = OVRDataBaseUtils.AutoProgressByePhase(oneSNodeInfo.iPhaseID, m_drawArrangeModule.DatabaseConnection, m_drawArrangeModule);
                if (bResult)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgProgressByes1"));
                    m_strLastSelPhaseTreeNodeKey = String.Format("P{0}", oneSNodeInfo.iPhaseID);
                    UpdatePhaseTree();
                    UpdateCompetitors();
                    UpdateMatches();
                }
            }
            else if (oneSNodeInfo.iNodeType == 1)
            {
                bool bResult = false;
                bResult = OVRDataBaseUtils.AutoProgressByeMatch(oneSNodeInfo.iMatchID, m_drawArrangeModule.DatabaseConnection, m_drawArrangeModule);
                if (bResult)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgProgressByes1"));

                    m_strLastSelPhaseTreeNodeKey = String.Format("M{0}", oneSNodeInfo.iMatchID);
                    UpdatePhaseTree();
                    UpdateCompetitors();
                    UpdateMatches();
                }
            }

        }

        private void dgvMatches_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            m_iSelMatch = iRowIndex;
            String strColumnName = dgvMatches.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvMatches.Rows[iRowIndex].Cells[iColumnIndex];
            if (CurCell != null)
            {
                Int32 iMatchID = GetFieldValue(dgvMatches, iRowIndex, "F_MatchID");
                Int32 iInputValue = 0;
                try
                {
                    iInputValue = Convert.ToInt32(CurCell.Value);
                }
                catch (System.Exception ex)
                {
                    ex.ToString();
                    iInputValue = 0;
                }

                if (strColumnName.CompareTo("M.Num") == 0)
                {
                    UpdateMatchNum(iMatchID, iInputValue);

                    this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emMatchInfo, -1, -1, -1, iMatchID, iMatchID, null);
                }
            }
        }

        private void tabItemDrawArrange_Click(object sender, EventArgs e)
        {
            UpdateReportContext();
        }

        private void tabItemDrawRep_Click(object sender, EventArgs e)
        {
            // Update Data In DrawRep Tab
            if (m_bUpdateDrawPhaseTree)
            {
                UpdateDrawPhaseTree();

                m_bUpdateDrawPhaseTree = false;
            }

            UpdateReportContext();
        }

        private void UpdateReportContext()
        {
            if (tvPhaseTree.Visible)
            {
                if (tvPhaseTree.SelectedNode != null)
                {
                    SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)tvPhaseTree.SelectedNode.Tag;

                    m_drawArrangeModule.SetReportContext("SportID", oneSNodeInfo.iSportID.ToString());
                    m_drawArrangeModule.SetReportContext("DisciplineID", oneSNodeInfo.iDisciplineID.ToString());
                    m_drawArrangeModule.SetReportContext("EventID", oneSNodeInfo.iEventID.ToString());
                    m_drawArrangeModule.SetReportContext("PhaseID", oneSNodeInfo.iPhaseID.ToString());
                }
                else
                {
                    m_drawArrangeModule.SetReportContext("SportID", "-1");
                    m_drawArrangeModule.SetReportContext("DisciplineID", "-1");
                    m_drawArrangeModule.SetReportContext("EventID", "-1");
                    m_drawArrangeModule.SetReportContext("PhaseID", "-1");
                }

                string strValue;
                if (dgvMatches.SelectedRows.Count > 0)
                {
                    strValue = dgvMatches.SelectedRows[0].Cells["F_MatchID"].Value.ToString();
                    m_drawArrangeModule.SetReportContext("MatchID", strValue);
                }
                else
                    m_drawArrangeModule.SetReportContext("MatchID", "-1");

                if (dgvCompetitors.SelectedRows.Count > 0)
                {
                    strValue = dgvCompetitors.SelectedRows[0].Cells["F_RegisterID"].Value.ToString();
                    m_drawArrangeModule.SetReportContext("RegisterID", strValue);
                }
                else
                    m_drawArrangeModule.SetReportContext("RegisterID", "-1");
            }

            if (tvDrawPhaseTree.Visible)
            {
                if (tvDrawPhaseTree.SelectedNode != null)
                {
                    SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)tvDrawPhaseTree.SelectedNode.Tag;

                    m_drawArrangeModule.SetReportContext("SportID", oneSNodeInfo.iSportID.ToString());
                    m_drawArrangeModule.SetReportContext("DisciplineID", oneSNodeInfo.iDisciplineID.ToString());
                    m_drawArrangeModule.SetReportContext("EventID", oneSNodeInfo.iEventID.ToString());
                    m_drawArrangeModule.SetReportContext("PhaseID", oneSNodeInfo.iPhaseID.ToString());
                }
                else
                {
                    m_drawArrangeModule.SetReportContext("SportID", "-1");
                    m_drawArrangeModule.SetReportContext("DisciplineID", "-1");
                    m_drawArrangeModule.SetReportContext("EventID", "-1");
                    m_drawArrangeModule.SetReportContext("PhaseID", "-1");
                }

                m_drawArrangeModule.SetReportContext("MatchID", "-1");
                m_drawArrangeModule.SetReportContext("RegisterID", "-1");
            }

        }

        private void dgvCompetitors_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvCompetitors.SelectedRows.Count > 0)
            {
                string strValue = dgvCompetitors.SelectedRows[0].Cells["F_RegisterID"].Value.ToString();
                m_drawArrangeModule.SetReportContext("RegisterID", strValue);
            }
            else
                m_drawArrangeModule.SetReportContext("RegisterID", "-1");
        }

        private void dgvMatches_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvMatches.SelectedRows.Count > 0)
            {
                string strValue = dgvMatches.SelectedRows[0].Cells["F_MatchID"].Value.ToString();
                m_drawArrangeModule.SetReportContext("MatchID", strValue);
            }
            else
                m_drawArrangeModule.SetReportContext("MatchID", "-1");
        }

        #endregion

        #region Control Initialize

        private void Localization()
        {
            this.tabItemDrawArrange.Text = LocalizationRecourceManager.GetString(m_strSectionName, "tabItemDrawArrange");
            this.tabItemDrawRep.Text = LocalizationRecourceManager.GetString(m_strSectionName, "tabItemDrawRep");
            this.btnAutoProgress.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnAutoProgress");
            this.btnProgressByes.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnProgressByes");
            this.MenuSetEventModel.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuSetEventModel");
            this.MenuEditEventStatus.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuEditEventStatus");
            this.MenuAddPhase.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuAddPhase");
            this.MenuEditPhase.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuEditPhase");
            this.MenuDelPhase.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuDelPhase");
            this.MenuAddMatch.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuAddMatch");
            this.MenuEditMatch.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuEditMatch");
            this.MenuDelMatch.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuDelMatch");
            this.MenuSaveLoadEventModel.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuSaveLoadEventModel");
            this.MenuSetMatchesRule.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuSetMatchesRule");
            this.MenuLoadPartModel.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuLoadPartModel");
            this.MenuSavePartModel.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuSavePartModel");

            this.MenuEditCompetitionPostion.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuEditCompetitionPostion");
            this.MenuAddCompetitionPosition.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuAddCompetitionPosition");
            this.MenuDeleteCompetitionPosition.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuDeleteCompetitionPosition");
            this.MenuAddMultiCompetitionPosition.Text = LocalizationRecourceManager.GetString(m_strSectionName, "MenuAddMultiCompetitionPosition");
        }

        private void InitCompetitorsCombBox(ref UIDataGridView GridCtrl, Int32 iColumnIndex, Int32 iEventID, Int32 iPhaseID, Int32 iMatchID, Int32 iPosition, String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetMatchCompetitorsList";
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
                            "@Position", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPosition);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                            "@SelEventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iSelPhaseTreeEventID);
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameter7 = new SqlParameter(
                            "@SelPhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iSelPhaseTreePhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter7);

                SqlParameter cmdParameter8 = new SqlParameter(
                            "@SelMatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iSelPhaseTreeMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter8);

                SqlParameter cmdParameter9 = new SqlParameter(
                            "@SelNodeType", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_iSelPhaseTreeNodeType);
                oneSqlCommand.Parameters.Add(cmdParameter9);


                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(sdr, 0, 1);
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void InitPhaseCombBox(ref UIDataGridView GridCtrl, Int32 iColumnIndex, Int32 iEventID, Int32 iPhaseID, Int32 iMatchID, String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
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

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
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
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
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

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
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

        private void InitHistoryMatchCombBox(ref UIDataGridView GridCtrl, Int32 iColumnIndex, Int32 iEventID, Int32 iPhaseID, Int32 iMatchID, Int32 iSourcePhaseID, String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetMatchHistoryMatches";
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

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
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

        #endregion

        #region  DataBase Functions

        private void UpdateMatchPositionDes1(Int32 iMatchID, Int32 iCompetitionPosition, Int32 iInputValue)
        {
            String strSql;
            if (iInputValue == -1)
            {
                strSql = "UPDATE TS_Match_Result SET F_CompetitionPositionDes1 = NULL  WHERE F_MatchID = " + iMatchID + " AND F_CompetitionPosition =" + iCompetitionPosition;
            }
            else
            {
                strSql = "UPDATE TS_Match_Result SET F_CompetitionPositionDes1 = " + iInputValue + " WHERE F_MatchID = " + iMatchID + " AND F_CompetitionPosition =" + iCompetitionPosition;
            }
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateMatchPositionDes2(Int32 iMatchID, Int32 iCompetitionPosition, Int32 iInputValue)
        {
             String strSql;
            if(iInputValue == -1)
            {
                strSql = "UPDATE TS_Match_Result SET F_CompetitionPositionDes2 = NULL  WHERE F_MatchID = " + iMatchID + " AND F_CompetitionPosition =" + iCompetitionPosition;
            }
            else
            {
                strSql = "UPDATE TS_Match_Result SET F_CompetitionPositionDes2 = " + iInputValue + " WHERE F_MatchID = " + iMatchID + " AND F_CompetitionPosition =" + iCompetitionPosition;
            }
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateMatchStartPhasePosition(Int32 iMatchID, Int32 iCompetitionPosition, Int32 iInputValue)
        {
            String strSql;
            if (iInputValue == -1)
            {
                strSql = "UPDATE TS_Match_Result SET F_StartPhasePosition = NULL WHERE F_MatchID = " + iMatchID + " AND F_CompetitionPosition =" + iCompetitionPosition;
            } 
            else
            {
                strSql = "UPDATE TS_Match_Result SET F_StartPhasePosition = " + iInputValue + " WHERE F_MatchID = " + iMatchID + " AND F_CompetitionPosition =" + iCompetitionPosition;
            }
         
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateMatchSourcePhaseRank(Int32 iMatchID, Int32 iCompetitionPosition, Int32 iInputValue)
        {
            String strSql;
            if (iInputValue == -1)
            {
                strSql = "UPDATE TS_Match_Result SET F_SourcePhaseRank = NULL WHERE F_MatchID = " + iMatchID + " AND F_CompetitionPosition =" + iCompetitionPosition;
            }
            else
            {
                strSql = "UPDATE TS_Match_Result SET F_SourcePhaseRank = " + iInputValue + " WHERE F_MatchID = " + iMatchID + " AND F_CompetitionPosition =" + iCompetitionPosition;
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateMatchSourceMatchRank(Int32 iMatchID, Int32 iCompetitionPosition, Int32 iInputValue)
        {
            String strSql;
            if (iInputValue == -1)
            {
                strSql = "UPDATE TS_Match_Result SET F_SourceMatchRank = NULL WHERE F_MatchID = " + iMatchID + " AND F_CompetitionPosition =" + iCompetitionPosition;
            }
            else
            {
                strSql = "UPDATE TS_Match_Result SET F_SourceMatchRank = " + iInputValue + " WHERE F_MatchID = " + iMatchID + " AND F_CompetitionPosition =" + iCompetitionPosition;
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateMatchHistoryMatchRank(Int32 iMatchID, Int32 iCompetitionPosition, Int32 iInputValue)
        {
            String strSql;
            if (iInputValue == -1)
            {
                strSql = "UPDATE TS_Match_Result SET F_HistoryMatchRank = NULL WHERE F_MatchID = " + iMatchID + " AND F_CompetitionPosition =" + iCompetitionPosition;
            }
            else
            {
                strSql = "UPDATE TS_Match_Result SET F_HistoryMatchRank = " + iInputValue + " WHERE F_MatchID = " + iMatchID + " AND F_CompetitionPosition =" + iCompetitionPosition;
            }
            
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateMatchHistoryLevel(Int32 iMatchID, Int32 iCompetitionPosition, Int32 iInputValue)
        {
            String strSql;
            if (iInputValue == -1)
            {
                strSql = "UPDATE TS_Match_Result SET F_HistoryLevel = NULL WHERE F_MatchID = " + iMatchID + " AND F_CompetitionPosition =" + iCompetitionPosition;
            }
            else
            {
                strSql = "UPDATE TS_Match_Result SET F_HistoryLevel = " + iInputValue + " WHERE F_MatchID = " + iMatchID + " AND F_CompetitionPosition =" + iCompetitionPosition;
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateSourceProgressDes(Int32 iMatchID, Int32 iCompetitionPosition, String strInputValue)
        {
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "proc_UpdateSoureProgressDes";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionPosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                           "@SouceProgressDes", SqlDbType.NVarChar, 100,
                           ParameterDirection.Input, true, 0, 0, "",
                           DataRowVersion.Current, strInputValue);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    switch (iOperateResult)
                    {
                        case 1://修改成功!
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdateSourceMatch1"));
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateProgressDes(Int32 iMatchID, Int32 iCompetitionPosition, String strInputValue)
        {
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "proc_UpdateProgressDes";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionPosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                           "@ProgressDes", SqlDbType.NVarChar, 100,
                           ParameterDirection.Input, true, 0, 0, "",
                           DataRowVersion.Current, strInputValue);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    switch (iOperateResult)
                    {
                        case 1://修改成功!
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdateProgressDes"));
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }
        
        private void UpdateMatchSourceMatch(Int32 iMatchID, Int32 iCompetitionPosition, Int32 iSourceMatchID)
        {
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_UpdateMatchSourceMatch";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionPosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@SourceMatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iSourceMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    switch (iOperateResult)
                    {
                        case 1://修改成功!
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdateProgressDes"));
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateMatchHistoryMatch(Int32 iMatchID, Int32 iCompetitionPosition, Int32 iSourceMatchID)
        {
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_UpdateMatchHistoryMatch";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionPosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@HistoryMatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iSourceMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    switch (iOperateResult)
                    {
                        case 1://修改成功!
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdateSourceMatch1"));
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateMatchStartPhase(Int32 iMatchID, Int32 iCompetitionPosition, Int32 iStartPhaseID)
        {
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_UpdateMatchStartPhase";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionPosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@StartPhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iStartPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    switch (iOperateResult)
                    {
                        case 1://修改成功!
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdateStartPhase1"));
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateMatchSourcePhase(Int32 iMatchID, Int32 iCompetitionPosition, Int32 iSourcePhaseID)
        {
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_UpdateMatchSourcePhase";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionPosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@SourcePhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iSourcePhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    switch (iOperateResult)
                    {
                        case 1://修改成功!
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdateSourcePhase1"));
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateMatchRegister(Int32 iMatchID, Int32 iCompetitionPosition, Int32 iRegisterID)
        {
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_UpdateMatchRegister";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@CompetitionPosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iCompetitionPosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iRegisterID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    switch (iOperateResult)
                    {
                        case 1://修改成功!
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdateMatchCompetitor1"));
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateGroupRegister(Int32 iPhaseID, Int32 iPhasePosition, Int32 iRegisterID)
        {
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_UpdatePhaseRegister";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PhasePosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhasePosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iRegisterID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    switch (iOperateResult)
                    {
                        case 1://修改成功!
                            break;
                        default:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdateGroupCompetitor1"));
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateMatchNum(Int32 iMatchID, Int32 iInputValue)
        {
            String strSql = "UPDATE TS_Match SET F_MatchNum = " + iInputValue + " WHERE F_MatchID = " + iMatchID;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private Boolean DeleteEventPhases(Int32 iEventID)
        {
            Boolean bResult = false;
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "proc_DelEventPhases";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iEventID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    switch (iOperateResult)
                    {
                        case 0:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelEventPhase1"));
                            bResult = false;
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelEventPhase2"));
                            bResult = false;
                            break;
                        case -2:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelEventPhase3"));
                            bResult = false;
                            break;
                        case -3:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelEventPhase4"));
                            bResult = false;
                            break;
                        case -4:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelEventPhase5"));
                            bResult = false;
                            break;
                        default://其余的为删除成功!
                            bResult = true;
                            break;
                    }
                }

            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            return bResult;
        }

        #endregion

        private void MenuCompetitionPos1Setting_Click(object sender, EventArgs e)
        {
            string strSectionName = m_strSectionName;
            CompetitionPosSetFrom frmCompetitionPosSet = new CompetitionPosSetFrom(strSectionName);
            frmCompetitionPosSet.DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
            frmCompetitionPosSet.ShowDialog();

            if (frmCompetitionPosSet.DialogResult != DialogResult.OK || this.dgvCompetitors.SelectedRows.Count < 1)
                return;

            DataGridViewSelectedRowCollection l_Rows = this.dgvCompetitors.SelectedRows;
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
                    Int32 iMatchID = GetFieldValue(dgvCompetitors, iSelIndex, "F_MatchID");
                    Int32 iPosition = GetFieldValue(dgvCompetitors, iSelIndex, "F_CompetitionPosition");

                    string strOldData = dgvCompetitors.Rows[iSelIndex].Cells["Position1"].Value.ToString();
                    string strNewData = "";

                    int iCode = frmCompetitionPosSet.StartNumber;
                    if (iCode > -1)
                    {
                        iCode += iRowIdx * frmCompetitionPosSet.Step;
                        strNewData = iCode.ToString();
                    }
                    int iLength = frmCompetitionPosSet.CodeLength;
                    if (iLength > -1)
                        strNewData = strNewData.PadLeft(iLength, '0');
                    else
                        strNewData = "-1";

                    iRowIdx++;

                    if (strNewData == strOldData)
                        continue;

                    string strOrder = strNewData;
                    int iOrder = int.Parse(strOrder);

                    this.UpdateMatchPositionDes1(iMatchID, iPosition, iOrder);

                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCompetitor, -1, -1, -1, iMatchID, iMatchID, null));
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }

            }
            UpdateCompetitors();
            if (changedList.Count > 0)
                m_drawArrangeModule.DataChangedNotify(changedList);
            UpdateMatches();
        }

        private void MenuCompetitionPos2Setting_Click(object sender, EventArgs e)
        {
            string strSectionName = m_strSectionName;
            CompetitionPosSetFrom frmCompetitionPosSet = new CompetitionPosSetFrom(strSectionName);
            frmCompetitionPosSet.DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
            frmCompetitionPosSet.ShowDialog();

            if (frmCompetitionPosSet.DialogResult != DialogResult.OK || this.dgvCompetitors.SelectedRows.Count < 1)
                return;

            DataGridViewSelectedRowCollection l_Rows = this.dgvCompetitors.SelectedRows;
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
                    Int32 iMatchID = GetFieldValue(dgvCompetitors, iSelIndex, "F_MatchID");
                    Int32 iPosition = GetFieldValue(dgvCompetitors, iSelIndex, "F_CompetitionPosition");


                    string strOldData = dgvCompetitors.Rows[iSelIndex].Cells["Position2"].Value.ToString();
                    string strNewData = "";

                    int iCode = frmCompetitionPosSet.StartNumber;
                    if (iCode > -1)
                    {
                        iCode += iRowIdx * frmCompetitionPosSet.Step;
                        strNewData = iCode.ToString();
                    }
                    int iLength = frmCompetitionPosSet.CodeLength;
                    if (iLength > -1)
                        strNewData = strNewData.PadLeft(iLength, '0');
                    else
                        strNewData = "-1";

                    iRowIdx++;

                    if (strNewData == strOldData)
                        continue;

                    string strOrder = strNewData;
                    int iOrder = int.Parse(strOrder);

                    this.UpdateMatchPositionDes2(iMatchID, iPosition, iOrder);

                    changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCompetitor, -1, -1, -1, iMatchID, iMatchID, null));
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }

            }

            UpdateCompetitors();
            if (changedList.Count > 0)
                m_drawArrangeModule.DataChangedNotify(changedList);
            UpdateMatches();
        }

        private void MenuCompetitionSourceSetting_Click(object sender, EventArgs e)
        {
            if (dgvCompetitors.SelectedRows.Count < 1)
                return;

            Int32 iRowIndex = dgvCompetitors.SelectedRows[0].Index;
            m_iSelCompetitor = iRowIndex;
            Int32 iEventID = GetFieldValue(dgvCompetitors, iRowIndex, "F_EventID");
            Int32 iPhaseID = GetFieldValue(dgvCompetitors, iRowIndex, "F_PhaseID");
            Int32 iMatchID = GetFieldValue(dgvCompetitors, iRowIndex, "F_MatchID");
            Int32 iPosition = GetFieldValue(dgvCompetitors, iRowIndex, "F_CompetitionPosition");

            if (iMatchID <= 0 || iPosition <= 0)
            {
                return;
            }

            CompetitionSourceSetFrom CompetitionPositionInfoForm = new CompetitionSourceSetFrom();
            CompetitionPositionInfoForm.OperateType = 1;
            CompetitionPositionInfoForm.DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
            CompetitionPositionInfoForm.LanguageCode = m_strLanguageCode;
            CompetitionPositionInfoForm.Module = m_drawArrangeModule;

            CompetitionPositionInfoForm.iSelPhaseTreeEventID = m_iSelPhaseTreeEventID;
            CompetitionPositionInfoForm.iSelPhaseTreePhaseID = m_iSelPhaseTreePhaseID;
            CompetitionPositionInfoForm.iSelPhaseTreeMatchID = m_iSelPhaseTreeMatchID;
            CompetitionPositionInfoForm.iSelPhaseTreeNodeType = 1;

            CompetitionPositionInfoForm.MatchID = iMatchID;
            CompetitionPositionInfoForm.CompetitionPosition = iPosition;

            CompetitionPositionInfoForm.ShowDialog();

            if (CompetitionPositionInfoForm.DialogResult != DialogResult.OK || this.dgvCompetitors.SelectedRows.Count < 1)
                return;

            DataGridViewSelectedRowCollection l_Rows = this.dgvCompetitors.SelectedRows;
            Int32[] arSelIndex = new Int32[l_Rows.Count];
            Int32 i = 0;
            foreach (DataGridViewRow r in l_Rows)
            {
                arSelIndex[i++] = r.Index;
            }
            Array.Sort(arSelIndex);

            Int32 iPositionSourceType = 0;
            Int32 iCurPosition = 0, iStarPhaseID = 0, iSourcePhaseID = 0, iSourceMatchID = 0;
            Int32 iInputVale = 0, iStep = 0;

            iPositionSourceType = CompetitionPositionInfoForm.PositionSourceType;
            iStarPhaseID = CompetitionPositionInfoForm.StartPhaseID;
            iSourcePhaseID = CompetitionPositionInfoForm.SourcePhaseID;
            iSourceMatchID = CompetitionPositionInfoForm.SourceMatchID;
            iInputVale = CompetitionPositionInfoForm.InputValue;
            iStep = CompetitionPositionInfoForm.Step;

            foreach (Int32 iRow in arSelIndex)
            {
                iCurPosition = GetFieldValue(dgvCompetitors, iRow, "F_CompetitionPosition");

                switch (iPositionSourceType)
                {
                    case 1:
                        UpdateStartPhaseInfo(iMatchID, iCurPosition, iStarPhaseID, iInputVale);
                        break;
                    case 2:
                        UpdateSourcePhaseInfo(iMatchID, iCurPosition, iSourcePhaseID, iInputVale);
                        break;
                    case 3:
                        UpdateSourceMatchInfo(iMatchID, iCurPosition, iSourcePhaseID, iSourceMatchID, iInputVale);
                        break;
                }

                
                iInputVale = iInputVale + iStep;
            }

            UpdateCompetitors();
            List<OVRDataChanged> changedList = new List<OVRDataChanged>();
            changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchCompetitor, -1, -1, -1, iMatchID, iMatchID, null));
            m_drawArrangeModule.DataChangedNotify(changedList);
            UpdateMatches();
        }

        private void UpdateStartPhaseInfo(Int32 iMatchID, Int32 iPosition, Int32 iStartPhaseID, Int32 iStartPosition)
        {
            UpdateMatchStartPhase(iMatchID, iPosition, iStartPhaseID);
            UpdateMatchStartPhasePosition(iMatchID, iPosition, iStartPosition);
        }

        private void UpdateSourcePhaseInfo(int iMatchID, int iPosition, int iSourcePhaseID, int iPhaseRank)
        {
            UpdateMatchSourcePhase(iMatchID, iPosition, iSourcePhaseID);
            UpdateMatchSourcePhaseRank(iMatchID, iPosition, iPhaseRank);
        }

        private void UpdateSourceMatchInfo(int iMatchID, int iPosition, int iSourcePhaseID, int iSourceMatchID, int iMatchRank)
        {
            UpdateMatchSourcePhase(iMatchID, iPosition, iSourcePhaseID);
            UpdateMatchSourceMatch(iMatchID, iPosition, iSourceMatchID);
            UpdateMatchSourceMatchRank(iMatchID, iPosition, iMatchRank);
        }
    }
}