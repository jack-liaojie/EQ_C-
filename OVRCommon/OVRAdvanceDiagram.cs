using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;


namespace AutoSports.OVRCommon
{
    public class OVRKnockOutNodeHeader
    {
        public OVRKnockOutNodeHeader()
        {
            m_strHeaderText = null;
        }

        public OVRKnockOutNodeHeader(string strHeaderText)
        {
            m_strHeaderText = strHeaderText;
        }

        private string m_strHeaderText;
        public string HeaderText
        {
            get { return this.m_strHeaderText; }
            set { this.m_strHeaderText = value; }
        }

        public override string ToString()
        {
            return m_strHeaderText;
        }
    }

    public class OVRRoundRobinHeader
    {
        public OVRRoundRobinHeader()
        {
            m_strHome = null;
            m_strAway = null;
            m_bIsVisible = false;
        }

        private string m_strHome;
        public string Home
        {
            get { return this.m_strHome; }
            set { this.m_strHome = value; }
        }

        private string m_strAway;
        public string Away
        {
            get { return this.m_strAway; }
            set { this.m_strAway = value; }
        }

        private bool m_bIsVisible;
        public bool IsVisible
        {
            get { return this.m_bIsVisible; }
            set { this.m_bIsVisible = value; }
        }

        public override string ToString()
        {
            return m_strHome + "/" + m_strAway;
        }
    }

    public enum OVRKnockOutNodeType
    {
        Left = 1,
        Right,
        NotSet
    }

    public class OVRParticipantInfo
    {
        public OVRParticipantInfo()
        {
            m_iDrawNum = null;
            m_iPoints = null;
            m_iParticipantID = null;
            m_strParticipantName = null;
            m_strTag = null;
        }

        private int? m_iDrawNum;
        public int? DrawNum
        {
            get { return this.m_iDrawNum; }
            set { this.m_iDrawNum = value; }
        }

        private int? m_iPoints;
        public int? Points
        {
            get { return this.m_iPoints; }
            set { this.m_iPoints = value; }
        }

        private int? m_iParticipantID;
        public int? ParticipantID
        {
            get { return this.m_iParticipantID; }
            set { this.m_iParticipantID = value; }
        }

        private string m_strParticipantName;
        public string ParticipantName
        {
            get { return this.m_strParticipantName; }
            set { this.m_strParticipantName = value; }
        }

        private string m_strTag; // Used to Identify a Participant
        public string Tag
        {
            get { return this.m_strTag; }
            set { this.m_strTag = value; }
        }

        public override string ToString()
        {
            if (this.m_strTag == null)
                return "Not Specified";

            string strText = "";
            if (this.m_iDrawNum != null)
                strText = String.Format("No.{0} ", this.m_iDrawNum);

            if (this.m_strParticipantName != null)
                return strText + this.m_strParticipantName;

            return strText;
        }

        public override bool Equals(object obj)
        {
            if (obj == null || !(obj is OVRParticipantInfo)) return false;

            return this.m_strTag == (obj as OVRParticipantInfo).m_strTag;
        }

        public override int GetHashCode()
        {
            return 0;
        }
    }

    public class OVRMatchInfo
    {
        private int? m_iMatchID;
        private int? m_iStatusID;
        private int? m_iSessionNum;
        private string m_strStartTime;
        private string m_strName;
        private string m_strResult;
        private string m_strPhaseName;

        public OVRMatchInfo()
        {
            m_iMatchID = null;
            m_iSessionNum = null;
            m_strStartTime = null;
            m_strName = null;
            m_strResult = null;
            m_strPhaseName = null;
        }

        public int? MatchID
        {
            get { return this.m_iMatchID; }
            set { this.m_iMatchID = value; }
        }

        public int? StatusID
        {
            get { return this.m_iStatusID; }
            set { this.m_iStatusID = value; }
        }

        public int? SessionNum
        {
            get { return this.m_iSessionNum; }
            set { this.m_iSessionNum = value; }
        }

        public string StartTime
        {
            get { return this.m_strStartTime; }
            set { this.m_strStartTime = value; }
        }

        public string Name
        {
            get { return this.m_strName; }
            set { this.m_strName = value; }
        }

        public string Result
        {
            get { return this.m_strResult; }
            set { this.m_strResult = value; }
        }

        public string PhaseName
        {
            get { return this.m_strPhaseName; }
            set { this.m_strPhaseName = value; }
        }

        public override string ToString()
        {
            if (this.m_iStatusID == 110)
                return this.m_strResult;

            string strText = "";
            if (this.m_iSessionNum != null)
                strText += String.Format("Session{0} ", m_iSessionNum);
            if (this.m_strStartTime != null)
                strText += this.m_strStartTime + " ";
            if (this.m_strName != null)
                strText += this.m_strName;

            return strText;
        }
    }

    public class OVRKnockOutNode
    {
        public OVRKnockOutNode()
        {
            m_ParticipantInfo = null;
            m_MatchInfo = null;
            m_LeftNode = null;
            m_RightNode = null;
            m_enType = OVRKnockOutNodeType.NotSet;
            m_bIsLeaf = true;
        }

        private OVRParticipantInfo m_ParticipantInfo;
        public OVRParticipantInfo ParticipantInfo
        {
            get { return this.m_ParticipantInfo; }
            set { this.m_ParticipantInfo = value; }
        }

        private OVRMatchInfo m_MatchInfo;
        public OVRMatchInfo MatchInfo
        {
            get { return this.m_MatchInfo; }
            set { this.m_MatchInfo = value; }
        }

        private OVRKnockOutNode m_LeftNode;
        public OVRKnockOutNode LeftNode
        {
            get { return this.m_LeftNode; }
            set
            {
                this.m_LeftNode = value;

                if (this.m_LeftNode != null)
                {
                    this.m_LeftNode.m_enType = OVRKnockOutNodeType.Left;
                    this.m_bIsLeaf = false;
                }
                else if (this.m_RightNode == null)
                    this.m_bIsLeaf = true;
            }
        }

        private OVRKnockOutNode m_RightNode;
        public OVRKnockOutNode RightNode
        {
            get { return this.m_RightNode; }
            set
            {
                this.m_RightNode = value;

                if (this.m_RightNode != null)
                {
                    this.m_RightNode.m_enType = OVRKnockOutNodeType.Right;
                    this.m_bIsLeaf = false;
                }
                else if (this.m_LeftNode == null)
                    this.m_bIsLeaf = true;
            }
        }

        private OVRKnockOutNodeType m_enType;
        public OVRKnockOutNodeType Type
        {
            get { return this.m_enType; }
        }

        private bool m_bIsLeaf;
        public bool IsLeaf
        {
            get { return this.m_bIsLeaf; }
        }

        public override string ToString()
        {
            if (this.m_bIsLeaf)
            {
                if (this.m_ParticipantInfo == null)
                    return "No Information Available";

                if (this.m_MatchInfo != null && this.m_MatchInfo.StatusID == 110 && this.m_MatchInfo.Result != null) // Match Finished with Result
                    return this.m_ParticipantInfo.ToString() + " " + this.m_MatchInfo.Result;

                return this.m_ParticipantInfo.ToString();
            }
            else
            {
                if (this.m_MatchInfo == null)
                    return "No Information Available";

                if (this.m_MatchInfo.StatusID != 110 || this.m_ParticipantInfo == null) // Match not Finished
                    return this.m_MatchInfo.ToString();

                if (this.m_MatchInfo.Result == null) // Match Finished with no Result
                    return this.m_ParticipantInfo.ToString();

                // Match Finished with Result
                return this.m_ParticipantInfo.ToString() + " " + this.m_MatchInfo.Result;
            }
        }

        public static void GenerateNodeList(DataTable dtKnockOutData, ref List<OVRKnockOutNode> lstNodeList)
        {
            string filterExpression = "F_NodeLevel = 0";
            DataRow[] drSel = dtKnockOutData.Select(filterExpression);

            foreach (DataRow dr in drSel)
            {
                OVRKnockOutNode nodeChild = new OVRKnockOutNode();

                if (!GenerateBinTree(dr, ref nodeChild, 1))
                    continue;

                OVRKnockOutNode nodeRoot = null;
                for (int i = 0; i < lstNodeList.Count; i++)
                {
                    if (lstNodeList[i].MatchInfo.MatchID == dr["F_MatchID"] as int?)
                    {
                        nodeRoot = lstNodeList[i];
                        break;
                    }
                }
                if (nodeRoot == null)
                {
                    nodeRoot = new OVRKnockOutNode();
                    nodeRoot.MatchInfo = new OVRMatchInfo();
                    nodeRoot.MatchInfo.MatchID = dr["F_MatchID"] as int?;
                    nodeRoot.MatchInfo.StatusID = dr["F_MatchStatusID"] as int?;
                    nodeRoot.MatchInfo.SessionNum = dr["F_MatchSessionNum"] as int?;
                    nodeRoot.MatchInfo.Name = dr["F_MatchLongName"] as string;
                    nodeRoot.MatchInfo.StartTime = dr["F_MatchTime"] as string;
                    nodeRoot.MatchInfo.PhaseName = dr["F_PhaseLongName"] as string;

                    lstNodeList.Add(nodeRoot);
                }

                if ((dr["F_MatchRank"] as int?) == 1)
                {
                    nodeRoot.ParticipantInfo = new OVRParticipantInfo();
                    nodeRoot.ParticipantInfo.ParticipantID = dr["F_ParticipantID"] as int?;
                    nodeRoot.ParticipantInfo.Points = dr["F_MatchPoints"] as int?;
                    nodeRoot.ParticipantInfo.ParticipantName = dr["F_ParLongName"] as string;
                    if (nodeRoot.MatchInfo.StatusID != 110)
                    {
                        nodeRoot.ParticipantInfo.Tag = String.Format("{0}_{1}", dr["F_SourceMatchID"], dr["F_SourceMatchRank"]);
                        nodeRoot.ParticipantInfo.ParticipantName = String.Format("Rk.{0} From {1}", dr["F_SourceMatchRank"], nodeRoot.MatchInfo.Name);
                    }
                    else
                    {
                        nodeRoot.ParticipantInfo.Tag = nodeRoot.ParticipantInfo.ParticipantID.ToString();
                    }
                    if (!Convert.IsDBNull(dr["F_StartPhasePosition"]))
                    {
                        nodeRoot.ParticipantInfo.DrawNum = Convert.ToInt32(dr["F_StartPhasePosition"]);
                    }
                }

                if (dr["F_CompetitionPosition"].ToString() == "1")
                    nodeRoot.LeftNode = nodeChild;
                else if (dr["F_CompetitionPosition"].ToString() == "2")
                    nodeRoot.RightNode = nodeChild;
                else
                    continue;
            }

            // Set Result
            for (int i = 0; i < lstNodeList.Count; i++)
            {
                if (lstNodeList[i].LeftNode != null && lstNodeList[i].LeftNode.ParticipantInfo != null && lstNodeList[i].LeftNode.ParticipantInfo.Points != null &&
                    lstNodeList[i].RightNode != null && lstNodeList[i].RightNode.ParticipantInfo != null && lstNodeList[i].RightNode.ParticipantInfo.Points != null)
                    lstNodeList[i].MatchInfo.Result = String.Format("{0} : {1}", lstNodeList[i].LeftNode.ParticipantInfo.Points,
                                                                                 lstNodeList[i].RightNode.ParticipantInfo.Points);
            }
        }

        private static bool GenerateBinTree(DataRow drCurRow, ref OVRKnockOutNode nodeCur, int iDepth)
        {
            if (drCurRow == null || nodeCur == null) return false;

            // Dead Lock, Aborted
            if (iDepth > drCurRow.Table.Rows.Count) return false;

            // Node of Participant, Return Here
            if (Convert.IsDBNull(drCurRow["F_SourceMatchID"]) || Convert.IsDBNull(drCurRow["F_SourceMatchRank"]))
            {
                nodeCur.ParticipantInfo = new OVRParticipantInfo();
                nodeCur.ParticipantInfo.ParticipantID = drCurRow["F_ParticipantID"] as int?;
                nodeCur.ParticipantInfo.Points = drCurRow["F_MatchPoints"] as int?;
                nodeCur.ParticipantInfo.ParticipantName = drCurRow["F_ParLongName"] as string;
                if (nodeCur.ParticipantInfo.ParticipantID != null)
                {
                    nodeCur.ParticipantInfo.Tag = nodeCur.ParticipantInfo.ParticipantID.ToString();
                }

                // Participant from StartPhase
                if (!Convert.IsDBNull(drCurRow["F_StartPhaseID"]) && !Convert.IsDBNull(drCurRow["F_StartPhasePosition"]))
                {
                    nodeCur.ParticipantInfo.Tag = String.Format("{0}_{1}", drCurRow["F_StartPhaseID"], drCurRow["F_StartPhasePosition"]);
                    nodeCur.ParticipantInfo.DrawNum = Convert.ToInt32(drCurRow["F_StartPhasePosition"]);
                }
                // Participant from SourcePhase
                else if (!Convert.IsDBNull(drCurRow["F_SourcePhaseID"]) && !Convert.IsDBNull(drCurRow["F_SourcePhaseRank"]))
                {
                    nodeCur.ParticipantInfo.Tag = String.Format("{0}_{1}", drCurRow["F_SourcePhaseID"], drCurRow["F_SourcePhaseRank"]);
                    nodeCur.ParticipantInfo.ParticipantName = String.Format("Rk.{0} From {1}", drCurRow["F_SourcePhaseRank"], drCurRow["F_SourcePhaseLongName"]);
                }
                // Participant BYE
                if (nodeCur.ParticipantInfo.ParticipantID == -1)
                {
                    nodeCur.ParticipantInfo.Tag = "-1";
                    nodeCur.ParticipantInfo.ParticipantName = "BYE";
                }
                nodeCur.MatchInfo = null;
                return true;
            }

            // Select Source Match
            string filterExpression = String.Format("F_MatchID = {0}", drCurRow["F_SourceMatchID"]);
            DataRow[] drSel = drCurRow.Table.Select(filterExpression);

            if (drSel.Length != 2) return false;

            // Set MatchInfo for Current Node
            nodeCur.MatchInfo = new OVRMatchInfo();
            nodeCur.MatchInfo.MatchID = drSel[0]["F_MatchID"] as int?;
            nodeCur.MatchInfo.StatusID = drSel[0]["F_MatchStatusID"] as int?;
            nodeCur.MatchInfo.SessionNum = drSel[0]["F_MatchSessionNum"] as int?;
            nodeCur.MatchInfo.Name = drSel[0]["F_MatchLongName"] as string;
            nodeCur.MatchInfo.StartTime = drSel[0]["F_MatchTime"] as string;
            nodeCur.MatchInfo.PhaseName = drSel[0]["F_PhaseLongName"] as string;

            // Set ParticipantInfo for Current Node
            nodeCur.ParticipantInfo = new OVRParticipantInfo();
            nodeCur.ParticipantInfo.ParticipantID = drCurRow["F_ParticipantID"] as int?;
            nodeCur.ParticipantInfo.Points = drCurRow["F_MatchPoints"] as int?;
            nodeCur.ParticipantInfo.ParticipantName = drCurRow["F_ParLongName"] as string;
            if (nodeCur.MatchInfo.StatusID != 110)
            {
                nodeCur.ParticipantInfo.Tag = String.Format("{0}_{1}", drCurRow["F_SourceMatchID"], drCurRow["F_SourceMatchRank"]);
                nodeCur.ParticipantInfo.ParticipantName = String.Format("Rk.{0} From {1}", drCurRow["F_SourceMatchRank"], nodeCur.MatchInfo.Name);
            }
            else
            {
                nodeCur.ParticipantInfo.Tag = nodeCur.ParticipantInfo.ParticipantID.ToString();
            }
            if (!Convert.IsDBNull(drCurRow["F_StartPhasePosition"]))
            {
                nodeCur.ParticipantInfo.DrawNum = Convert.ToInt32(drCurRow["F_StartPhasePosition"]);
            }

            // Node of a Match's Loser, Return Here
            if (Convert.ToInt32(drCurRow["F_SourceMatchRank"]) != 1)
            {
                nodeCur.MatchInfo = null;
                return true;
            }

            // Add Source Match to Current Node
            int iCount = 0;
            foreach (DataRow dr in drSel)
            {
                OVRKnockOutNode nodeChild = new OVRKnockOutNode();

                if (!GenerateBinTree(dr, ref nodeChild, iDepth + 1))
                    continue;

                if (dr["F_CompetitionPosition"].ToString() == "1")
                    nodeCur.LeftNode = nodeChild;
                else if (dr["F_CompetitionPosition"].ToString() == "2")
                    nodeCur.RightNode = nodeChild;
                else
                    continue;

                iCount++;
            }

            // Set Result
            if (nodeCur.ParticipantInfo.ParticipantID != null)
            {
                if (nodeCur.LeftNode != null && nodeCur.LeftNode.ParticipantInfo != null && nodeCur.LeftNode.ParticipantInfo.Points != null &&
                   nodeCur.RightNode != null && nodeCur.RightNode.ParticipantInfo != null && nodeCur.RightNode.ParticipantInfo.Points != null)
                    nodeCur.MatchInfo.Result = String.Format("{0} : {1}", nodeCur.LeftNode.ParticipantInfo.Points,
                                                                          nodeCur.RightNode.ParticipantInfo.Points);
            }

            return iCount == 2 ? true : false;
        }

    }

    public enum OVRAdvanceDiagramCellType
    {
        enParticipant = 1,
        enMatch,
        enUnknown
    }

    public class OVRAdvanceDiagramCellEventArgs : EventArgs
    {
        private OVRAdvanceDiagramCellType m_eType;
        private OVRParticipantInfo m_Participant;
        private OVRMatchInfo m_Match;
        private bool m_bHandled;

        public OVRAdvanceDiagramCellEventArgs()
        {
            m_eType = OVRAdvanceDiagramCellType.enUnknown;
            m_Participant = null;
            m_Match = null;
            m_bHandled = false;
        }

        public OVRAdvanceDiagramCellType Type
        {
            get { return this.m_eType; }
            set { this.m_eType = value; }
        }

        public OVRParticipantInfo Participant
        {
            get { return this.m_Participant; }
            set { this.m_Participant = value; }
        }

        public OVRMatchInfo Match
        {
            get { return this.m_Match; }
            set { this.m_Match = value; }
        }

        public bool Handled
        {
            get { return this.m_bHandled; }
            set { this.m_bHandled = value; }
        }
    }

    public delegate void OVRAdvanceDiagramCellEventHandler(object sender, OVRAdvanceDiagramCellEventArgs args);

    public class OVRAdvanceDiagram : DataGridView
    {
        public new bool AllowUserToAddRows
        {
            get { return base.AllowUserToAddRows; }
        }

        public new bool AllowUserToDeleteRows
        {
            get { return base.AllowUserToDeleteRows; }
        }

        public new DataGridViewCellBorderStyle CellBorderStyle
        {
            get { return base.CellBorderStyle; }
        }

        public OVRAdvanceDiagram()
        {
            Initialize();
        }

        private void Initialize()
        {
            cellStyleKOHeader = new DataGridViewCellStyle(this.RowTemplate.DefaultCellStyle);
            cellStyleKOHeader.WrapMode = DataGridViewTriState.True;
            cellStyleKOHeader.Alignment = DataGridViewContentAlignment.MiddleLeft;
            cellStyleKOHeader.Padding = new Padding(0);
            cellStyleKOHeader.SelectionBackColor = System.Drawing.SystemColors.Control;
            cellStyleKOHeader.SelectionForeColor = System.Drawing.SystemColors.ControlText;
            cellStyleKOHeader.BackColor = System.Drawing.SystemColors.Control;

            cellStyleKnockOut = new DataGridViewCellStyle(this.RowTemplate.DefaultCellStyle);
            cellStyleKnockOut.WrapMode = DataGridViewTriState.True;
            cellStyleKnockOut.Alignment = DataGridViewContentAlignment.MiddleLeft;
            cellStyleKnockOut.Padding = new Padding(15, 10, 5, 3);

            cellStyleRoundRobin = new DataGridViewCellStyle(this.RowTemplate.DefaultCellStyle);
            cellStyleRoundRobin.WrapMode = DataGridViewTriState.True;
            cellStyleRoundRobin.Alignment = DataGridViewContentAlignment.MiddleLeft;
            cellStyleRoundRobin.Padding = new Padding(3);

            m_TempNodeList = new List<OVRKnockOutNode>();
            m_TempNodesLevel = new List<int>();
            m_dtDiagramData = new DataTable();
            m_dtRoundRobinData = new DataTable();
            m_bMultiTree = false;

            m_fLineWidth = 1.5F;
            m_penSolid = new Pen(System.Drawing.Color.Black, m_fLineWidth);
            m_penSolid.DashStyle = System.Drawing.Drawing2D.DashStyle.Solid;

            base.AllowUserToAddRows = false;
            base.AllowUserToDeleteRows = false;
            base.CellBorderStyle = DataGridViewCellBorderStyle.None;
            this.RowHeadersVisible = false;
            // this.ColumnHeadersVisible = false;
            this.MultiSelect = false;
            this.SelectionMode = DataGridViewSelectionMode.CellSelect;
            this.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.None;
            this.AutoSizeRowsMode = DataGridViewAutoSizeRowsMode.AllCells;
            this.BackgroundColor = System.Drawing.Color.White;
            this.CausesValidation = false;
            this.ShowCellErrors = false;
            this.ShowCellToolTips = false;
            this.ShowEditingIcon = false;
            this.ShowRowErrors = false;
        }

        public void UpdateDiagram()
        {
            m_dtDiagramData.Clear();
            m_dtDiagramData.Columns.Clear();
            this.Rows.Clear();
            this.Columns.Clear();
            if (m_TempNodeList.Count < 1) return;

            // Put RoundRobin Match from m_TempNodeList to m_dsRoundRobinData
            RoundRobinAnalyze();

            // Put KnockOut Match from m_TempNodeList to m_dtDiagramData
            AddNodeListToDataTable();

            // Put RoundRobin Match from m_dsRoundRobinData to m_dtDiagramData
            AddRoundRobinToDataTable();
        }

        #region Data Analysis

        private void AddNodeToDataTable(OVRKnockOutNode node, int iLevel)
        {
            if (node == null) return;

            if (m_dtDiagramData.Columns[iLevel.ToString()] == null)
            {
                m_dtDiagramData.Columns.Add(new DataColumn(iLevel.ToString(), typeof(Object))); // , typeof(OVRKnockOutNode)
            }

            DataRow dr;
            if (node.IsLeaf)
            {
                dr = m_dtDiagramData.NewRow();
                dr[iLevel.ToString()] = node;
                m_dtDiagramData.Rows.Add(dr);
                return;
            }

            if (node.LeftNode == null || node.RightNode == null) return;

            AddNodeToDataTable(node.LeftNode, iLevel + 1);

            dr = m_dtDiagramData.NewRow();
            dr[iLevel.ToString()] = node;
            m_dtDiagramData.Rows.Add(dr);

            AddNodeToDataTable(node.RightNode, iLevel + 1);
        }

        private void AddNodeListToDataTable()
        {
            if (this.m_bMultiTree)
            {
                int iCount;
                for (int iIndex = 0; iIndex < m_TempNodeList.Count; iIndex++)
                {
                    iCount = m_dtDiagramData.Rows.Count;
                    AddNodeToDataTable(m_TempNodeList[iIndex], m_TempNodesLevel[iIndex]);

                    if (m_TempNodeList.Count != 1)
                    {
                        DataRow dr = m_dtDiagramData.NewRow();
                        for (int i = 0; i < m_dtDiagramData.Columns.Count; i++)
                        {
                            OVRKnockOutNodeHeader header = new OVRKnockOutNodeHeader();
                            for (int j = iCount; j < m_dtDiagramData.Rows.Count; j++)
                            {
                                OVRKnockOutNode nodeTemp = m_dtDiagramData.Rows[j][i] as OVRKnockOutNode;
                                if (nodeTemp != null)
                                {
                                    if (nodeTemp.IsLeaf)
                                        header.HeaderText = "Participant";
                                    else if (nodeTemp.MatchInfo != null && nodeTemp.MatchInfo.PhaseName != null)
                                        header.HeaderText = nodeTemp.MatchInfo.PhaseName;

                                    break;
                                }
                            }
                            dr[i] = header;
                        }
                        m_dtDiagramData.Rows.InsertAt(dr, iCount);
                        m_dtDiagramData.Rows.Add(m_dtDiagramData.NewRow());
                    }
                }
            }
            else
            {
                OVRKnockOutNode nodeRoot = GenerateBinTree();

                if (nodeRoot != null) AddNodeToDataTable(nodeRoot, 0);
            }

            // Change Direction from Right2Left to Left2Right
            for (int i = 0; i < m_dtDiagramData.Rows.Count; i++)
            {
                for (int j = 0; j < m_dtDiagramData.Columns.Count / 2; j++)
                {
                    object obj = m_dtDiagramData.Rows[i][j];
                    m_dtDiagramData.Rows[i][j] = m_dtDiagramData.Rows[i][m_dtDiagramData.Columns.Count - 1 - j];
                    m_dtDiagramData.Rows[i][m_dtDiagramData.Columns.Count - 1 - j] = obj;
                }
            }

            // Display in OVRAdvanceDiagram
            for (int i = 0; i < m_dtDiagramData.Columns.Count; i++)
            {
                DataGridViewColumn col = new DataGridViewTextBoxColumn();// new CustomComboBoxColumn();
                col.AutoSizeMode = DataGridViewAutoSizeColumnMode.NotSet;
                col.SortMode = DataGridViewColumnSortMode.NotSortable;

                // Get Column Header Text
                string strHeaderText = "";
                if (m_TempNodeList.Count == 1 || !this.m_bMultiTree)
                {
                    for (int j = 0; j < m_dtDiagramData.Rows.Count; j++)
                    {
                        OVRKnockOutNode nodeTemp = m_dtDiagramData.Rows[j][i] as OVRKnockOutNode;
                        if (nodeTemp != null)
                        {
                            if (nodeTemp.IsLeaf)
                                strHeaderText = "Participant";
                            else if (nodeTemp.MatchInfo != null && nodeTemp.MatchInfo.PhaseName != null)
                                strHeaderText = nodeTemp.MatchInfo.PhaseName;

                            break;
                        }
                    }
                }
                col.Name = i.ToString();
                col.HeaderText = strHeaderText;
                this.Columns.Add(col);
            }
            for (int i = 0; i < m_dtDiagramData.Rows.Count; i++)
            {
                DataGridViewRow dgvDataRow = new DataGridViewRow();
                dgvDataRow.CreateCells(this);
                dgvDataRow.Selected = false;

                bool bIsNodeHeader = false;
                for (int j = 0; j < m_dtDiagramData.Columns.Count; j++)
                {
                    dgvDataRow.Cells[j].Value = m_dtDiagramData.Rows[i][j].ToString();

                    if (!bIsNodeHeader && m_dtDiagramData.Rows[i][j] is OVRKnockOutNodeHeader)
                        bIsNodeHeader = true;
                }

                if (bIsNodeHeader)
                    dgvDataRow.DefaultCellStyle = this.cellStyleKOHeader;
                else
                    dgvDataRow.DefaultCellStyle = this.cellStyleKnockOut;

                this.Rows.Add(dgvDataRow);
            }

            // Clear Temp List
            m_TempNodeList.Clear();
            m_TempNodesLevel.Clear();
        }

        private void RoundRobinAnalyze()
        {
            // Test: Re-Order m_TempNodeList
            //             Random rand = new Random(DateTime.Now.Second);
            //             for (int i = 0; i < m_TempNodeList.Count; i++ )
            //             {
            //                 OVRKnockOutNode node = m_TempNodeList[m_TempNodeList.Count - 1];
            //                 m_TempNodeList.RemoveAt(m_TempNodeList.Count - 1);
            // 
            //                 m_TempNodeList.Insert(rand.Next(0, m_TempNodeList.Count - 1), node);
            //             }

            m_dtRoundRobinData.Clear();
            m_dtRoundRobinData.Columns.Clear();

            m_dtRoundRobinData.Columns.Add(new DataColumn("0", typeof(Object)));
            m_dtRoundRobinData.Rows.Add(m_dtRoundRobinData.NewRow());
            m_dtRoundRobinData.Rows[0][0] = new OVRRoundRobinHeader();

            List<int> lstRoundRobinNodes = new List<int>();

            // Add Matches to DataTable
            for (int i = 0; i < m_TempNodeList.Count; i++)
            {
                int iDepth = GetHighestLevel(m_TempNodeList[i], 0);
                if (GetHighestLevel(m_TempNodeList[i], 0) != 1) continue;

                if (m_TempNodeList[i].LeftNode == null || m_TempNodeList[i].RightNode == null)
                    continue;
                if (m_TempNodeList[i].LeftNode.ParticipantInfo == null || m_TempNodeList[i].RightNode.ParticipantInfo == null)
                    continue;
                if (m_TempNodeList[i].LeftNode.ParticipantInfo.Tag == null || m_TempNodeList[i].RightNode.ParticipantInfo.Tag == null)
                    continue;

                int iLeft = -1, iRight = -1;
                for (int j = 1; j < m_dtRoundRobinData.Columns.Count; j++)
                {
                    OVRParticipantInfo par = m_dtRoundRobinData.Rows[0][j] as OVRParticipantInfo;

                    if (par.Equals(m_TempNodeList[i].LeftNode.ParticipantInfo))
                    {
                        iLeft = j;
                        continue;
                    }
                    if (par.Equals(m_TempNodeList[i].RightNode.ParticipantInfo))
                    {
                        iRight = j;
                        continue;
                    }
                }

                if (iLeft == -1)
                {
                    iLeft = m_dtRoundRobinData.Columns.Count;
                    m_dtRoundRobinData.Columns.Add(new DataColumn(iLeft.ToString(), typeof(Object)));
                    m_dtRoundRobinData.Rows.Add(m_dtRoundRobinData.NewRow());

                    m_dtRoundRobinData.Rows[0][iLeft] = m_TempNodeList[i].LeftNode.ParticipantInfo;
                    m_dtRoundRobinData.Rows[iLeft][0] = m_TempNodeList[i].LeftNode.ParticipantInfo;
                }
                if (iRight == -1)
                {
                    iRight = m_dtRoundRobinData.Columns.Count;
                    m_dtRoundRobinData.Columns.Add(new DataColumn(iRight.ToString(), typeof(Object)));
                    m_dtRoundRobinData.Rows.Add(m_dtRoundRobinData.NewRow());

                    m_dtRoundRobinData.Rows[0][iRight] = m_TempNodeList[i].RightNode.ParticipantInfo;
                    m_dtRoundRobinData.Rows[iRight][0] = m_TempNodeList[i].RightNode.ParticipantInfo;
                }

                m_dtRoundRobinData.Rows[iLeft][iRight] = m_TempNodeList[i].MatchInfo;
                lstRoundRobinNodes.Add(i);
            }

            // Clear Non-RoundRobin Nodes from m_dtRoundRobinData and lstRoundRobinNodes
            bool bFind;
            do
            {
                bFind = false;
                for (int i = 1; i < m_dtRoundRobinData.Columns.Count; i++)
                {
                    int iMatchCount = 0;
                    int? iMatchID = null;
                    for (int iRowIdx = 1; iMatchCount < 2 && iRowIdx < m_dtRoundRobinData.Rows.Count; iRowIdx++)
                    {
                        if (m_dtRoundRobinData.Rows[iRowIdx][i] is OVRMatchInfo)
                        {
                            iMatchCount++;
                            iMatchID = (m_dtRoundRobinData.Rows[iRowIdx][i] as OVRMatchInfo).MatchID;
                        }
                    }
                    for (int iColIdx = 1; iMatchCount < 2 && iColIdx < m_dtRoundRobinData.Columns.Count; iColIdx++)
                    {
                        if (m_dtRoundRobinData.Rows[i][iColIdx] is OVRMatchInfo)
                        {
                            iMatchCount++;
                            iMatchID = (m_dtRoundRobinData.Rows[i][iColIdx] as OVRMatchInfo).MatchID;
                        }
                    }

                    if (iMatchCount < 2)
                    {
                        bFind = true;

                        // Delete Participant
                        m_dtRoundRobinData.Rows.RemoveAt(i);
                        m_dtRoundRobinData.Columns.RemoveAt(i);
                        i--;

                        // Delete Node from lstRoundRobinNodes
                        if (iMatchID != null)
                        {
                            for (int j = 0; j < lstRoundRobinNodes.Count; j++)
                            {
                                if (m_TempNodeList[lstRoundRobinNodes[j]].MatchInfo.MatchID == iMatchID)
                                {
                                    lstRoundRobinNodes.RemoveAt(j);
                                    break;
                                }
                            }
                        }
                    }
                }
            } while (bFind);

            // Clear RoundRobin Nodes from m_TempNodeList and m_TempNodesLevel
            for (int i = lstRoundRobinNodes.Count - 1; i >= 0; i--)
            {
                m_TempNodeList.RemoveAt(lstRoundRobinNodes[i]);
                m_TempNodesLevel.RemoveAt(lstRoundRobinNodes[i]);
            }

            // Adjust m_dtRoundRobinData to Upper Triangular Matrix if Possible
            for (int iRowIdx = 1; iRowIdx < m_dtRoundRobinData.Rows.Count; iRowIdx++)
            {
                for (int iColIdx = iRowIdx + 1; iColIdx < m_dtRoundRobinData.Columns.Count; iColIdx++)
                {
                    if (!(m_dtRoundRobinData.Rows[iRowIdx][iColIdx] is OVRMatchInfo) &&
                        (m_dtRoundRobinData.Rows[iColIdx][iRowIdx] is OVRMatchInfo))
                    {
                        m_dtRoundRobinData.Rows[iRowIdx][iColIdx] = m_dtRoundRobinData.Rows[iColIdx][iRowIdx];
                        m_dtRoundRobinData.Rows[iColIdx][iRowIdx] = null;
                    }
                }
            }

            // Adjust m_dtRoundRobinData to Partitioned Matrix
            for (int iRowIdx = 1; iRowIdx < m_dtRoundRobinData.Rows.Count; iRowIdx++)
            {
                List<int> lstColumnIndex = new List<int>();
                for (int iColIdx = iRowIdx + 1; iColIdx < m_dtRoundRobinData.Columns.Count; iColIdx++)
                {
                    if (m_dtRoundRobinData.Rows[iRowIdx][iColIdx] is OVRMatchInfo)
                        lstColumnIndex.Add(iColIdx);
                }

                // Put Matches of the Same RoundRobin Together
                for (int i = 0; i < lstColumnIndex.Count; i++)
                {
                    int iIndex = iRowIdx + 1 + i;
                    if (iIndex == lstColumnIndex[i]) continue;

                    for (int k = lstColumnIndex[i]; k > iIndex; k--)
                    {
                        // Switch Columns
                        for (int j = 0; j < m_dtRoundRobinData.Rows.Count; j++)
                        {
                            object oValue = m_dtRoundRobinData.Rows[j][k];
                            m_dtRoundRobinData.Rows[j][k] = m_dtRoundRobinData.Rows[j][k - 1];
                            m_dtRoundRobinData.Rows[j][k - 1] = oValue;
                        }
                        // Switch Rows
                        for (int j = 0; j < m_dtRoundRobinData.Columns.Count; j++)
                        {
                            object oValue = m_dtRoundRobinData.Rows[k][j];
                            m_dtRoundRobinData.Rows[k][j] = m_dtRoundRobinData.Rows[k - 1][j];
                            m_dtRoundRobinData.Rows[k - 1][j] = oValue;
                        }
                    }
                }
            }

            // Suppress m_dtRoundRobinData
            DataTable dt = new DataTable();
            int iStartCol = 1, iEndCol = 1;
            for (int iColIdx = 2; iColIdx < m_dtRoundRobinData.Columns.Count; iColIdx++)
            {
                bool bEnd = true;
                for (int i = iColIdx - 1; i > 0; i--)
                {
                    if (m_dtRoundRobinData.Rows[i][iColIdx] is OVRMatchInfo)
                    {
                        bEnd = false;
                        break;
                    }
                }
                if (iColIdx == m_dtRoundRobinData.Columns.Count - 1 && iColIdx > iEndCol)
                {
                    bEnd = true;  // this is the last part
                    iColIdx++;
                }

                if (bEnd)
                {
                    iEndCol = iColIdx;

                    if (dt.Columns.Count < iEndCol - iStartCol)
                    {
                        for (int i = dt.Columns.Count; i < iEndCol - iStartCol + 1; i++)
                        {
                            dt.Columns.Add(new DataColumn(i.ToString(), typeof(Object)));
                        }
                    }

                    // Add to DataTable dt
                    DataRow dr = dt.NewRow();
                    dr[0] = new OVRRoundRobinHeader();
                    for (int i = 0; i < iEndCol - iStartCol; i++)
                    {
                        dr[i + 1] = m_dtRoundRobinData.Rows[0][iStartCol + i];
                    }
                    dt.Rows.Add(dr);
                    for (int i = iStartCol; i < iEndCol; i++)
                    {
                        dr = dt.NewRow();
                        dr[0] = m_dtRoundRobinData.Rows[0][i];
                        for (int j = 0; j < iEndCol - iStartCol; j++)
                        {
                            dr[j + 1] = m_dtRoundRobinData.Rows[i][iStartCol + j];
                        }
                        dt.Rows.Add(dr);
                    }
                    dt.Rows.Add(dt.NewRow());

                    iStartCol = iEndCol;
                }
            }
            m_dtRoundRobinData = dt;
        }

        private void AddRoundRobinToDataTable()
        {
            for (int i = m_dtDiagramData.Columns.Count; i < m_dtRoundRobinData.Columns.Count; i++)
            {
                m_dtDiagramData.Columns.Add(new DataColumn(i.ToString(), typeof(Object)));

                DataGridViewColumn col = new DataGridViewTextBoxColumn(); // new CustomComboBoxColumn();
                col.AutoSizeMode = DataGridViewAutoSizeColumnMode.NotSet;
                col.SortMode = DataGridViewColumnSortMode.NotSortable;
                col.Name = i.ToString();
                col.HeaderText = "";
                this.Columns.Add(col);
            }

            m_iRoundRobinStartIndex = m_dtDiagramData.Rows.Count;
            for (int i = 0; i < m_dtRoundRobinData.Rows.Count; i++)
            {
                DataRow dr = m_dtDiagramData.NewRow();

                for (int j = 0; j < m_dtRoundRobinData.Columns.Count; j++)
                {
                    dr[j] = m_dtRoundRobinData.Rows[i][j];
                }

                m_dtDiagramData.Rows.Add(dr);
            }

            // Display in OVRAdvanceDiagram
            for (int i = m_iRoundRobinStartIndex; i < m_dtDiagramData.Rows.Count; i++)
            {
                DataGridViewRow dgvDataRow = new DataGridViewRow();
                dgvDataRow.CreateCells(this);
                dgvDataRow.Selected = false;

                for (int j = 0; j < m_dtDiagramData.Columns.Count; j++)
                {
                    dgvDataRow.Cells[j].Value = m_dtDiagramData.Rows[i][j].ToString();

                    if (GetRoundRobinCellType(i, j) == 3)
                    {
                        dgvDataRow.Cells[j].Style = this.cellStyleKOHeader;
                    }
                }

                dgvDataRow.DefaultCellStyle = this.cellStyleRoundRobin;
                this.Rows.Add(dgvDataRow);
            }

            m_dtRoundRobinData.Clear();
            m_dtRoundRobinData.Columns.Clear();
        }

        private void JoinPairs()
        {
            if (m_TempNodesLevel.Count < 1) return;

            // Get Lowest Level
            int iLowestLevel = m_TempNodesLevel[0];
            for (int i = 0; i < m_TempNodesLevel.Count; i++)
            {
                if (m_TempNodesLevel[i] < iLowestLevel) iLowestLevel = m_TempNodesLevel[i];
            }

            // Join Pairs
            List<OVRKnockOutNode> tempNodeList = new List<OVRKnockOutNode>();
            List<int> tempNodesLevel = new List<int>();
            OVRKnockOutNode tempNode = null;
            for (int i = 0; i < m_TempNodesLevel.Count; i++)
            {
                if (m_TempNodesLevel[i] == iLowestLevel)
                {
                    if (tempNode == null)
                    {
                        tempNode = new OVRKnockOutNode();
                        tempNode.LeftNode = m_TempNodeList[i];
                    }
                    else  // Join Pairs Successfully
                    {
                        tempNode.RightNode = m_TempNodeList[i];
                        tempNodeList.Add(tempNode);
                        tempNodesLevel.Add(iLowestLevel + 1);
                        tempNode = null;
                    }
                }
                else
                {
                    tempNodeList.Add(m_TempNodeList[i]);
                    tempNodesLevel.Add(m_TempNodesLevel[i]);
                }
            }
            if (tempNode != null)  // Join Pairs Failed, Promote to Next Level
            {
                if (tempNode.LeftNode == null || tempNode.RightNode != null) return;

                tempNodeList.Add(tempNode.LeftNode);
                tempNodesLevel.Add(iLowestLevel + 1);
            }

            m_TempNodeList = tempNodeList;
            m_TempNodesLevel = tempNodesLevel;
        }

        private OVRKnockOutNode GenerateBinTree()
        {
            while (m_TempNodeList.Count > 1)
            {
                JoinPairs();
            }

            if (m_TempNodeList.Count != 1) return null;

            return m_TempNodeList[0];
        }

        private int GetHighestLevel(OVRKnockOutNode node, int iDepth)
        {
            if (iDepth > 1000) return 1000;

            int iLeftDepth = iDepth;
            if (node.LeftNode != null)
            {
                iLeftDepth = GetHighestLevel(node.LeftNode, iDepth + 1);
            }
            if (iLeftDepth > 1000) return 1000;

            int iRightDepth = iDepth;
            if (node.RightNode != null)
            {
                iRightDepth = GetHighestLevel(node.RightNode, iDepth + 1);
            }
            if (iRightDepth > 1000) return 1000;

            return iLeftDepth > iRightDepth ? iLeftDepth : iRightDepth;
        }

        public void AddKnockOutNode(OVRKnockOutNode node)
        {
            // if the Depth of the node greater then 1000, it is treated as round list and will be aborted;
            int iDepth = GetHighestLevel(node, 0);
            if (iDepth >= 1000) return;

            this.m_TempNodeList.Add(node);
            this.m_TempNodesLevel.Add(0);
        }

        public void AddKnockOutNode(OVRKnockOutNode node, int level)
        {
            // if the Depth of the node greater then 1000, it is treated as round list and will be aborted;
            int iDepth = GetHighestLevel(node, 0);
            if (iDepth >= 1000) return;

            this.m_TempNodeList.Add(node);
            this.m_TempNodesLevel.Add(level < 0 ? 0 : level);
        }

        private bool IsMiddleOfPairs(int iRowIndex, int iColumnIndex)
        {
            if (iRowIndex >= m_dtDiagramData.Rows.Count || iColumnIndex >= m_dtDiagramData.Columns.Count) return false;

            bool bLeft = false;
            for (int i = iRowIndex - 1; i >= 0; i--)
            {
                if (m_dtDiagramData.Rows[i][iColumnIndex] is OVRKnockOutNode)
                {
                    bLeft = (m_dtDiagramData.Rows[i][iColumnIndex] as OVRKnockOutNode).Type == OVRKnockOutNodeType.Left;
                    break;
                }
            }

            return bLeft;
        }

        private bool IsRoundRobinRow(int iRowIndex)
        {
            return iRowIndex >= this.m_iRoundRobinStartIndex ? true : false;
        }

        private bool IsRoundRobinCell(int iRowIndex, int iColumnIndex)
        {
            if (iRowIndex >= m_dtDiagramData.Rows.Count || iColumnIndex >= m_dtDiagramData.Columns.Count) return false;

            return m_dtDiagramData.Rows[iRowIndex][0] is OVRParticipantInfo || m_dtDiagramData.Rows[iRowIndex][0] is OVRRoundRobinHeader;
        }

        private int GetRoundRobinCellType(int iRowIndex, int iColumnIndex)
        {
            if (iRowIndex >= m_dtDiagramData.Rows.Count || iColumnIndex >= m_dtDiagramData.Columns.Count) return -1;

            if (m_dtDiagramData.Rows[iRowIndex][iColumnIndex] is OVRRoundRobinHeader)
                return 0;

            if (m_dtDiagramData.Rows[iRowIndex][iColumnIndex] is OVRParticipantInfo)
                return 1;

            if (m_dtDiagramData.Rows[iRowIndex][0] is OVRParticipantInfo)
            {
                if (m_dtDiagramData.Rows[iRowIndex][iColumnIndex] is OVRMatchInfo)
                    return 2;

                int iOrder = -1;
                for (int i = iRowIndex; i >= 0; i--)
                {
                    if (m_dtDiagramData.Rows[i][0] is OVRRoundRobinHeader)
                    {
                        iOrder = iRowIndex - i;
                        break;
                    }
                }

                return iOrder == iColumnIndex ? 3 : 2;
            }

            return -1;
        }

        #endregion

        #region OVRAdvanceDiagram Property Definitions

        private DataGridViewCellStyle cellStyleKOHeader;
        private DataGridViewCellStyle cellStyleKnockOut;
        private DataGridViewCellStyle cellStyleRoundRobin;

        private float m_fLineWidth;

        private List<OVRKnockOutNode> m_TempNodeList;
        private List<int> m_TempNodesLevel;

        int m_iRoundRobinStartIndex;
        private DataTable m_dtDiagramData;

        private DataTable m_dtRoundRobinData;

        private bool m_bMultiTree;
        public bool MultiTree
        {
            get { return this.m_bMultiTree; }
            set { this.m_bMultiTree = value; }
        }

        public new event OVRAdvanceDiagramCellEventHandler CellBeginEdit;

        #endregion

        #region Override Methods

        private System.Drawing.Pen m_penSolid;

        protected override void OnCellPainting(DataGridViewCellPaintingEventArgs e)
        {
            if (e.RowIndex >= 0 && e.ColumnIndex >= 0)
            {
                // Paint OVRKnockOutNodeHeader
                if (m_dtDiagramData.Rows[e.RowIndex][e.ColumnIndex] is OVRKnockOutNodeHeader)
                {
                    if (!e.Handled) e.Paint(e.CellBounds, DataGridViewPaintParts.Background | DataGridViewPaintParts.ContentForeground);

                    e.Handled = true;

                    return;
                }

                // Paint OVRKnockOutNode
                if (m_dtDiagramData.Rows[e.RowIndex][e.ColumnIndex] is OVRKnockOutNode)
                {
                    if (!e.Handled) e.Paint(e.CellBounds, DataGridViewPaintParts.All ^ DataGridViewPaintParts.Focus);

                    e.Graphics.DrawLine(m_penSolid, e.CellBounds.Left, e.CellBounds.Bottom - m_fLineWidth / 2, e.CellBounds.Right, e.CellBounds.Bottom - m_fLineWidth / 2);

                    if (IsMiddleOfPairs(e.RowIndex, e.ColumnIndex))
                    {
                        e.Graphics.DrawLine(m_penSolid, e.CellBounds.Right - m_fLineWidth / 2, e.CellBounds.Top, e.CellBounds.Right - m_fLineWidth / 2, e.CellBounds.Bottom);
                    }
                    e.Handled = true;

                    return;
                }

                if (IsRoundRobinRow(e.RowIndex))
                {
                    // Paint OVRParticipantInfo
                    if (m_dtDiagramData.Rows[e.RowIndex][e.ColumnIndex] is OVRParticipantInfo)
                    {
                        if (!e.Handled) e.Paint(e.CellBounds, DataGridViewPaintParts.All ^ DataGridViewPaintParts.Focus);

                        e.Graphics.DrawRectangle(m_penSolid, e.CellBounds);

                        e.Handled = true;

                        return;
                    }

                    // Paint OVRMatchInfo
                    if (m_dtDiagramData.Rows[e.RowIndex][e.ColumnIndex] is OVRMatchInfo)
                    {
                        if (!e.Handled) e.Paint(e.CellBounds, DataGridViewPaintParts.All ^ DataGridViewPaintParts.Focus);

                        e.Graphics.DrawRectangle(m_penSolid, e.CellBounds);

                        e.Handled = true;

                        return;
                    }

                    if (IsRoundRobinCell(e.RowIndex, e.ColumnIndex))
                    {
                        e.Paint(e.CellBounds, DataGridViewPaintParts.Background | DataGridViewPaintParts.Border);

                        e.Graphics.DrawRectangle(m_penSolid, e.CellBounds);

                        e.Handled = true;

                        return;
                    }

                    e.Paint(e.CellBounds, DataGridViewPaintParts.Background | DataGridViewPaintParts.Border);
                    e.Graphics.DrawLine(m_penSolid, e.CellBounds.Left, e.CellBounds.Top, e.CellBounds.Right, e.CellBounds.Top);
                    e.Handled = true;
                    return;
                }

                if (IsMiddleOfPairs(e.RowIndex, e.ColumnIndex))
                {
                    e.Paint(e.CellBounds, DataGridViewPaintParts.Background | DataGridViewPaintParts.Border);

                    e.Graphics.DrawLine(m_penSolid, e.CellBounds.Right - m_fLineWidth / 2, e.CellBounds.Top, e.CellBounds.Right - m_fLineWidth / 2, e.CellBounds.Bottom);

                    e.Handled = true;

                    return;
                }

                e.Paint(e.CellBounds, DataGridViewPaintParts.Background | DataGridViewPaintParts.Border);
                e.Handled = true;
            }

            base.OnCellPainting(e);
        }

        protected override void OnCellBeginEdit(DataGridViewCellCancelEventArgs e)
        {
            base.OnCellBeginEdit(e);

            if (m_dtDiagramData.Rows[e.RowIndex][e.ColumnIndex] is OVRKnockOutNode)
            {
                OVRAdvanceDiagramCellEventArgs args = new OVRAdvanceDiagramCellEventArgs();

                OVRKnockOutNode node = m_dtDiagramData.Rows[e.RowIndex][e.ColumnIndex] as OVRKnockOutNode;
                if (node.IsLeaf)
                {
                    args.Type = OVRAdvanceDiagramCellType.enParticipant;
                    args.Participant = node.ParticipantInfo;
                }
                else
                {
                    args.Type = OVRAdvanceDiagramCellType.enMatch;
                    args.Match = node.MatchInfo;
                }

                CellBeginEdit(this, args);
                e.Cancel = args.Handled;
                return;
            }

            if (m_dtDiagramData.Rows[e.RowIndex][e.ColumnIndex] is OVRParticipantInfo)
            {
                OVRAdvanceDiagramCellEventArgs args = new OVRAdvanceDiagramCellEventArgs();

                args.Type = OVRAdvanceDiagramCellType.enParticipant;
                args.Participant = m_dtDiagramData.Rows[e.RowIndex][e.ColumnIndex] as OVRParticipantInfo;

                CellBeginEdit(this, args);
                e.Cancel = args.Handled;
                return;
            }

            if (m_dtDiagramData.Rows[e.RowIndex][e.ColumnIndex] is OVRMatchInfo)
            {
                OVRAdvanceDiagramCellEventArgs args = new OVRAdvanceDiagramCellEventArgs();

                args.Type = OVRAdvanceDiagramCellType.enMatch;
                args.Match = m_dtDiagramData.Rows[e.RowIndex][e.ColumnIndex] as OVRMatchInfo;

                CellBeginEdit(this, args);
                e.Cancel = args.Handled;
                return;
            }

            e.Cancel = true;
            return;
        }

        #endregion

    }

}