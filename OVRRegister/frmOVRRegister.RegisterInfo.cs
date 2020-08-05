using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;

namespace AutoSports.OVRRegister
{
    public delegate void UpdateRegisterGrid(sDlgParam stDlgParam, int iNewRegisterID);

    public partial class OVRRegisterForm
    {
        struct SNodeInfo   //树控件节点定义

        {
            public string strNodeKey;
            public string strFatherKey;
            public int iNodeType;       //-1:Discipline节点，0,Federation\Club\NOC 节点，1...:子节点

            public string strGroupID;   //如果为Federation,则为FederationID；为NOC，则NOC；为Club，则ClubID
            public int iRegisterID;
            public int iRegTypeID;      // 1:Player;3:Team;2:Pair;0:Federation\Club\NOC
            public int iSexCode;    
        };

        private string m_strLastSelNodeKey;
        private string m_strSelNodeKey;
        private string m_strSelGroupID;
        private int m_nSelNodeType;
        private int m_nSelNodeID;
        private int m_nSelPlayerGridIndex = -1;    //the selected index of the player grid
        private int m_iCurGroupType = -1;          //1:Federation, 2:NOC, 3:Club, 4:Delegation

        static string strRegisterSectionName = "OVRRegisterInfo";
        static int    nRegTypeOfPlayer = 1;
        static int    nRegTypeOfTeam = 3;
        static int    nRegTypeOfPair = 2;
        static int    nRegTypeOfHorse = 7;

        private bool m_bUpdateTree = false;

        private void RegisterLabLocalization()
        {
            this.tabRegister.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "tabItemBasicInfo");
            this.lbFliter.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "lbFliter");
            this.bm_AddTeam.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "MenuAddTeam");
            this.bm_AddPair.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "MenuAddPair");
            this.bm_AddAthlete.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "MenuAddAthlete");
            this.bm_AddNonAthlete.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "MenuAddNonAthlete");
            this.bm_DelTeam.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "MenuDelTeam");
            this.bm_DelPair.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "MenuDelPair");
            this.bm_EditItem.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "MenuEditItem");

            this.bm_AddHorse.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "MenuAddHorse");

            this.cmbFliter.Items.Add(LocalizationRecourceManager.GetString(strRegisterSectionName, "cmbFliter_None"));
            this.cmbFliter.Items.Add(LocalizationRecourceManager.GetString(strRegisterSectionName, "cmbFliter_Athlete"));
            this.cmbFliter.Items.Add(LocalizationRecourceManager.GetString(strRegisterSectionName, "cmbFliter_NonAthlete"));

            string strName = "OVRBasicItemEditForm";
            lbGroup.Text = LocalizationRecourceManager.GetString(strName, "lbGroup");
            this.cmbGroup.Items.Add(LocalizationRecourceManager.GetString(strName, "cmb_Federation"));
            this.cmbGroup.Items.Add(LocalizationRecourceManager.GetString(strName, "cmb_NOC"));
            this.cmbGroup.Items.Add(LocalizationRecourceManager.GetString(strName, "cmb_Club"));
            this.cmbGroup.Items.Add(LocalizationRecourceManager.GetString(strName, "cmb_Delegation"));
        }

        private void InitGridViewStyleInRegister()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgv_Athlete);
            dgv_Athlete.RowHeadersVisible = true;
        }

        #region UI Update Functions

        private void RegisterInfoLoadData()
        {
            ShowCurSportGroupType();
            SetGroupUIText();
            RefreshTree();
            UpdateAthleteGrid();
        }

        private void ShowCurSportGroupType()
        {
            m_iCurGroupType = m_iSportGroupType;
            ////////////////////////////////////////
            //1-Federation,2-NOC, 3-Club, 4-Delegation
            if (m_iCurGroupType == 1)
            {
                cmbGroup.SelectedIndex = 0;
            }
            else if (m_iCurGroupType == 2)
            {
                cmbGroup.SelectedIndex = 1;
            }
            else if (m_iCurGroupType == 3)
            {
                cmbGroup.SelectedIndex = 2;
            }
            else if (m_iCurGroupType == 4)
            {
                cmbGroup.SelectedIndex = 3;
            }
        }

        private void SetGroupUIText()
        {
            if (m_iCurGroupType == 1)
            {
                this.btn_Delegation.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "btnFederation");
                this.bm_EditFederation.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "MenuEditFederation");
            }
            else if (m_iCurGroupType == 2)
            {
                this.btn_Delegation.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "btnNOC");
                this.bm_EditFederation.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "MenuEditNOC");
            }
            else if (m_iCurGroupType == 3)
            {
                this.btn_Delegation.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "btnClub");
                this.bm_EditFederation.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "MenuEditClub");
            }
            else if (m_iCurGroupType == 4)
            {
                this.btn_Delegation.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "btnDelegation");
                this.bm_EditFederation.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "MenuEditDelegation");
            }
        }

        private void RefreshTree()
        {
            adv_RegisterTree.BeginUpdate();
            m_bUpdateTree = true;
            adv_RegisterTree.Nodes.Clear();
            DevComponents.AdvTree.Node oLastSelNode = null;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand("Proc_GetAthleteTree",m_RegisterModule.DatabaseConnection);
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@GroupTypeID", SqlDbType.Int);
                cmdParameter1.Value = m_iCurGroupType;
                oneSqlCommand.Parameters.Add(cmdParameter1);

                if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_RegisterModule.DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                
                if(sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        string strNodeName = "";
                        string strNodeKey = "";
                        string strFatherNodeKey = "";
                        int iNodeType = -2;  //-1:Discipline节点，0:Federation\Club\NOC 节点，1...:子节点


                        //int iFederationID = -1;
                        string strGroupID;  //0:其他节点
                        int iRegisterID = -1;
                        int iRegTypeID = 0; // 1:Player;3:Team;2:Pair
                        int nImage = 0;
                        int nSelectedImage = 0;
                        int iSexCode = 0;

                        strNodeName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_NodeName");
                        strNodeKey = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_NodeKey");
                        strFatherNodeKey = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_FatherNodeKey");
                        iNodeType = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_NodeType");
                        strGroupID = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_GroupTypeID");
                        iRegisterID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_RegisterID");
                        iRegTypeID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_RegTypeID");
                        iSexCode = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_SexCode");
                        nImage = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_ImageIdx");
                        nSelectedImage = nImage;

                        SNodeInfo stNodeInfo = new SNodeInfo();
                        stNodeInfo.strNodeKey = strNodeKey;
                        stNodeInfo.iNodeType = iNodeType;
                        stNodeInfo.strGroupID = strGroupID;
                        stNodeInfo.iRegisterID = iRegisterID;
                        stNodeInfo.iRegTypeID = iRegTypeID;
                        stNodeInfo.strFatherKey = strFatherNodeKey;
                        stNodeInfo.iSexCode = iSexCode;

                        DevComponents.AdvTree.Node oneNode = new DevComponents.AdvTree.Node();
                        oneNode.Text = strNodeName;
                        oneNode.ImageIndex = nImage;
                        oneNode.ImageExpandedIndex = nSelectedImage;
                        oneNode.Tag = stNodeInfo;
                        oneNode.DataKey = strNodeKey;
                        oneNode.Expanded = false;

                        if (stNodeInfo.iNodeType == -1)
                        {
                            oneNode.Expanded = true;
                        }
                        if (stNodeInfo.iNodeType == 0 && m_strLastSelNodeKey == strNodeKey)
                        {
                            oneNode.Expanded = true;
                        }

                        DevComponents.AdvTree.Node FatherNode = adv_RegisterTree.FindNodeByDataKey(strFatherNodeKey);
                        if (FatherNode == null)
                        {
                            adv_RegisterTree.Nodes.Add(oneNode);
                        }
                        else
                        {
                            FatherNode.Nodes.Add(oneNode);
                        }

                        if (m_strLastSelNodeKey == strNodeKey)
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

            adv_RegisterTree.SelectedNode = oLastSelNode;
            if(adv_RegisterTree.SelectedNode != null)
            {
                SNodeInfo oneSelNode = (SNodeInfo)adv_RegisterTree.SelectedNode.Tag;
                GetSelNodeInfo(ref oneSelNode);
            }
            else
            {
                m_strSelNodeKey = "";
                m_strSelGroupID = "";
                m_nSelNodeID = -1;
                m_nSelNodeType = -1;
            }
            m_bUpdateTree = false;
            adv_RegisterTree.EndUpdate();
        }

        public void UpdateAthleteGridForAdd(sDlgParam stDlgParam, int iNewRegID)
        {
            if(stDlgParam.bAddTeamDlg)
            {
                if (iNewRegID > 0)
                {
                    m_strLastSelNodeKey = "T" + iNewRegID.ToString();
                }

                RefreshTree();
                UpdateAthleteGrid();
            }
            else if(stDlgParam.bAddPairDlg)
            {
                if (iNewRegID > 0)
                {
                    if (m_nSelNodeType == 3)
                    {
                        if (!AddPairToTeam(m_nSelNodeID, iNewRegID)) return;

                        m_strLastSelNodeKey = "P" + iNewRegID.ToString();
                    }
                    else
                        m_strLastSelNodeKey = "T" + iNewRegID.ToString();
                }

                RefreshTree();
                UpdateAthleteGrid();
            }
            else if(stDlgParam.bAddNoAthleteDlg || stDlgParam.bAddCompetitorDlg)
            {
                RefreshTree();
                m_nSelPlayerGridIndex = dgv_Athlete.RowCount;
                UpdateAthleteGrid();

            }
            // Cause Data Update In Inscription
            m_bInsTab_RegChanged = true;
        }

        private void UpdateAthleteGrid()
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            string strProcName = "";
            if(cmbFliter.SelectedIndex == 1)
            {
                strProcName = "Proc_GetCompetitors";
            }
            else if(cmbFliter.SelectedIndex == 2)
            {
                strProcName = "Proc_GetNoAthlete";
            }
            else 
            {
                strProcName = "Proc_GetAthlete_All";
            }

            #region DML Command Setup for daSetAthlete
            try
            {
                SqlCommand cmd = new SqlCommand(strProcName, m_RegisterModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter("@GroupID", SqlDbType.NVarChar, 9); 
              
                SqlParameter cmdParameter2 = new SqlParameter(
                             "@RegisterID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@RegisterID",
                             DataRowVersion.Current, m_nSelNodeID);
                
                SqlParameter cmdParameter3 = new SqlParameter(
                             "@NodeType", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@NodeType",
                             DataRowVersion.Current, m_nSelNodeType);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@GroupType", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@GroupType",
                             DataRowVersion.Current, m_iCurGroupType);
                
                if(m_strSelGroupID == "0" || m_strSelGroupID == null)
                {
                    cmdParameter1.Value = DBNull.Value;
                }
                else 
                {
                    cmdParameter1.Value = m_strSelGroupID;
                }
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
            #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgv_Athlete, dr, null, null);

                if(dgv_Athlete.Rows.Count <= 0 )
                {
                    dr.Close();
                    return;
                }

                if(dgv_Athlete.Columns["MemberID"] != null)
                {
                    dgv_Athlete.Columns["MemberID"].Visible = false;
                }
                if (dgv_Athlete.Columns["RegTypeID"] != null)
                {
                    dgv_Athlete.Columns["RegTypeID"].Visible = false;
                }
                if (dgv_Athlete.Columns["BIB"] != null)
                {
                    dgv_Athlete.Columns["BIB"].ReadOnly = false;
                }
                dr.Close();

                if (m_nSelPlayerGridIndex < 0)
                {
                    return;
                }
                else if (m_nSelPlayerGridIndex > dgv_Athlete.RowCount - 1)
                {
                    m_nSelPlayerGridIndex = dgv_Athlete.RowCount - 1;
                }
                dgv_Athlete.Rows[m_nSelPlayerGridIndex].Selected = true;
                dgv_Athlete.FirstDisplayedScrollingRowIndex = m_nSelPlayerGridIndex;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        #endregion

        #region User Interface Operation

        private void btn_Update_Click(object sender, EventArgs e)
        {
            RegisterInfoLoadData();
        }

        private void btn_Delegation_Click(object sender, EventArgs e)
        {
            OVRFederationListForm frmOVRFederationList = new OVRFederationListForm(strRegisterSectionName);
            frmOVRFederationList.DatabaseConnection = m_RegisterModule.DatabaseConnection;
            frmOVRFederationList.m_iGroupType = m_iCurGroupType;
            frmOVRFederationList.ShowDialog();

            if (frmOVRFederationList.FederationActived || 
                frmOVRFederationList.FederationAdd_Del || 
                frmOVRFederationList.FederationModify)
            {
                RefreshTree();

                // Cause Data Update In Inscription
                m_bInsTab_FedChanged = true;
            }

            if (frmOVRFederationList.FederationModify)
            {
                m_RegisterModule.DataChangedNotify(OVRDataChangedType.emDelegationModify, m_iActiveDiscipline, -1, -1, -1, null, null);
            }
        }

        private void cmbGroup_SelectionChangeCommitted(object sender, EventArgs e)
        {
            if (cmbGroup.SelectedIndex == 0)
            {
                m_iCurGroupType = 1;    // Federation
            }
            else if (cmbGroup.SelectedIndex == 1)
            {
                m_iCurGroupType = 2;    // NOC
            }
            else if (cmbGroup.SelectedIndex == 2)
            {
                m_iCurGroupType = 3;    // Club
            }
            else if (cmbGroup.SelectedIndex == 3)
            {
                m_iCurGroupType = 4;    // Delegation
            }

            SetGroupUIText();

            RefreshTree();
        }

        private void adv_RegisterTree_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                DevComponents.AdvTree.Node SelNode = this.adv_RegisterTree.GetNodeAt(this.PointToClient(this.PointToScreen(new Point(e.X, e.Y))));
                // Get right click node!
                if (SelNode != null)
                {
                    SNodeInfo oneSNodeInfo = (SNodeInfo)SelNode.Tag;
                    if(oneSNodeInfo.iNodeType != -1)
                    {
                        SelNode.ContextMenu = bm_AllMenu;

                        bm_AddTeam.Enabled = true;
                        bm_AddPair.Enabled = true;
                        bm_AddAthlete.Enabled = true;
                        bm_AddNonAthlete.Enabled = true;
                        bm_DelTeam.Enabled = true;
                        bm_DelPair.Enabled = true;
                        bm_EditItem.Enabled = true;
                        bm_EditFederation.Enabled = true;

                        switch (oneSNodeInfo.iRegTypeID)
                        {
                            case 0://Federation 
                                bm_DelPair.Enabled = false;
                                bm_DelTeam.Enabled = false;
                                bm_EditItem.Enabled = false;
                                if (oneSNodeInfo.strGroupID == "0")
                                {
                                    bm_AddAthlete.Enabled = false;
                                    bm_AddTeam.Enabled = false;
                                    bm_AddPair.Enabled = false;
                                    bm_EditFederation.Enabled = false;
                                    bm_AddNonAthlete.Enabled = false;
                                }
                               
                                break;
                            case 3://Team
                                bm_AddTeam.Enabled = false;
                                bm_AddAthlete.Enabled = false;
                                bm_AddNonAthlete.Enabled = false;
                                bm_DelPair.Enabled = false;
                                bm_EditFederation.Enabled = false;
                                if (oneSNodeInfo.strGroupID == "0")
                                {
                                    bm_AddPair.Enabled = false;
                                }
                                break;
                            case 2://Pair
                                bm_AddTeam.Enabled = false;
                                bm_AddPair.Enabled = false;
                                bm_AddAthlete.Enabled = false;
                                bm_AddNonAthlete.Enabled = false;
                                bm_DelTeam.Enabled = false;
                                bm_EditFederation.Enabled = false;
                                break;
                            default://其余的不需要处理!                           
                                break;
                        }
                    }
                }
            }
        }

        private void adv_RegisterTree_AfterNodeSelect(object sender, DevComponents.AdvTree.AdvTreeNodeEventArgs e)
        {
            if (m_bUpdateTree)
                return;

            if (e.Node != null)
            {
        
                SNodeInfo oneSNodeInfo = (SNodeInfo)e.Node.Tag;
                GetSelNodeInfo(ref oneSNodeInfo);

                m_nSelPlayerGridIndex = -1;
                string strFederationID = "-1";
                string strDelegationID = "-1";
                string strClubID = "-1";
                string strNOCID = "-1";
                string strRegisterID = "-1";
                switch (oneSNodeInfo.iRegTypeID)
                {
                    case -1://DisciplineNode
                        dgv_Athlete.Columns.Clear();
                        dgv_Athlete.Rows.Clear();
                        break;
                    case 0://Federation
                        UpdateAthleteGrid();

                        switch (m_iCurGroupType)
                        {
                        case 1:
                            strFederationID = oneSNodeInfo.strGroupID;
                	        break;
                        case 2:
                            strNOCID = oneSNodeInfo.strGroupID;
                            break;
                        case 3:
                            strClubID = oneSNodeInfo.strGroupID;
                            break;
                        case 4:
                            strDelegationID = oneSNodeInfo.strGroupID;
                            break;
                        }
                        break;
                    case 2://Pair
                    case 3://Team
                        UpdateAthleteGrid();

                        switch (m_iCurGroupType)
                        {
                        case 1:
                            strFederationID = oneSNodeInfo.strGroupID;
                	        break;
                        case 2:
                            strNOCID = oneSNodeInfo.strGroupID;
                            break;
                        case 3:
                            strClubID = oneSNodeInfo.strGroupID;
                            break;
                        case 4:
                            strDelegationID = oneSNodeInfo.strGroupID;
                            break;
                        }
                        strRegisterID = oneSNodeInfo.iRegisterID.ToString();
                        break;
                    default:
                        break;
                }
                // Update Report Context
                m_RegisterModule.SetReportContext("FederationID", strFederationID);
                m_RegisterModule.SetReportContext("DelegationID", strDelegationID);
                m_RegisterModule.SetReportContext("ClubID", strClubID);
                m_RegisterModule.SetReportContext("NOCID", strNOCID);
                m_RegisterModule.SetReportContext("RegisterID", strRegisterID);
            }
            else
            {
                m_strSelNodeKey = "";
                m_strSelGroupID = "";
                m_nSelNodeID = -1;
                m_nSelNodeType = -1;

                m_RegisterModule.SetReportContext("FederationID", "-1");
                m_RegisterModule.SetReportContext("DelegationID", "-1");
                m_RegisterModule.SetReportContext("ClubID", "-1");
                m_RegisterModule.SetReportContext("NOCID", "-1");
                m_RegisterModule.SetReportContext("RegisterID", "-1");
            }
        }

        private void cmbFliter_SelectionChangeCommitted(object sender, EventArgs e)
        {
            if (adv_RegisterTree.SelectedNodes.Count > 0)
            {
                UpdateAthleteGrid();
            }
        }

        private void btn_EditRegister_Click(object sender, EventArgs e)
        {
            if (dgv_Athlete.SelectedRows.Count <= 0)
            {
                string strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "Operation_Msg");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }
            
            int iSelRowIdx = dgv_Athlete.SelectedRows[0].Index;
            if (iSelRowIdx > dgv_Athlete.RowCount - 1 || iSelRowIdx < 0)
                return;
           
            string strPlayerID = dgv_Athlete.Rows[iSelRowIdx].Cells["MemberID"].Value.ToString();
            string strRegTypeID = dgv_Athlete.Rows[iSelRowIdx].Cells["RegTypeID"].Value.ToString();

            if (Convert.ToInt32(strRegTypeID) == 7)
            {
                RegisterHorseEditForm frmRegisterEdit = new RegisterHorseEditForm(strRegisterSectionName);
                frmRegisterEdit.DatabaseConnection = m_RegisterModule.DatabaseConnection;
                frmRegisterEdit.Owner = this;
                frmRegisterEdit.module = m_RegisterModule;

                sDlgParam sEditMember = new sDlgParam();
                sEditMember.bEditCompetitorDlg = true;
                frmRegisterEdit.m_stDlgParam = sEditMember;

                if (m_iCurGroupType == 1)
                {
                    frmRegisterEdit.m_strFederationID = m_strSelGroupID;
                }
                else if (m_iCurGroupType == 2)
                {
                    frmRegisterEdit.m_strNOCCode = m_strSelGroupID;
                }
                else if (m_iCurGroupType == 3)
                {
                    frmRegisterEdit.m_strClubID = m_strSelGroupID;
                }
                else if (m_iCurGroupType == 4)
                {
                    frmRegisterEdit.m_strDelegationID = m_strSelGroupID;
                }

                frmRegisterEdit.m_strRegID = strPlayerID;
                frmRegisterEdit.m_strRegTypeID = strRegTypeID;
                frmRegisterEdit.m_strLanguageCode = m_strActiveLanguage;
                frmRegisterEdit.m_iGroupType = m_iCurGroupType;
                frmRegisterEdit.ShowDialog();

                if (frmRegisterEdit.DialogResult == DialogResult.OK)
                {
                    m_nSelPlayerGridIndex = iSelRowIdx;
                    RefreshTree();
                    UpdateAthleteGrid();

                    // Cause Data Update In Inscription
                    m_bInsTab_RegChanged = true;
                }
            }
            else
            {
                RegisterEditForm frmRegisterEdit = new RegisterEditForm(strRegisterSectionName);
                frmRegisterEdit.DatabaseConnection = m_RegisterModule.DatabaseConnection;
                frmRegisterEdit.Owner = this;
                frmRegisterEdit.module = m_RegisterModule;

                sDlgParam sEditMember = new sDlgParam();
                sEditMember.bEditCompetitorDlg = true;
                frmRegisterEdit.m_stDlgParam = sEditMember;

                if (m_iCurGroupType == 1)
                {
                    frmRegisterEdit.m_strFederationID = m_strSelGroupID;
                }
                else if (m_iCurGroupType == 2)
                {
                    frmRegisterEdit.m_strNOCCode = m_strSelGroupID;
                }
                else if (m_iCurGroupType == 3)
                {
                    frmRegisterEdit.m_strClubID = m_strSelGroupID;
                }
                else if (m_iCurGroupType == 4)
                {
                    frmRegisterEdit.m_strDelegationID = m_strSelGroupID;
                }

                frmRegisterEdit.m_strRegID = strPlayerID;
                frmRegisterEdit.m_strRegTypeID = strRegTypeID;
                frmRegisterEdit.m_strLanguageCode = m_strActiveLanguage;
                frmRegisterEdit.m_iGroupType = m_iCurGroupType;
                frmRegisterEdit.ShowDialog();

                if (frmRegisterEdit.DialogResult == DialogResult.OK)
                {
                    m_nSelPlayerGridIndex = iSelRowIdx;
                    RefreshTree();
                    UpdateAthleteGrid();

                    // Cause Data Update In Inscription
                    m_bInsTab_RegChanged = true;
                }
            }
            
        }

        private void btn_DelRegister_Click(object sender, EventArgs e)
        {
            string strMsgBox = "";
            if (dgv_Athlete.SelectedRows.Count <= 0)
            {
                strMsgBox = LocalizationRecourceManager.GetString(strRegisterSectionName, "Operation_Msg");
                DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox);
                return;
            }

            int iSelRowIdx = dgv_Athlete.SelectedRows[0].Index;
            if (iSelRowIdx > dgv_Athlete.RowCount - 1 || iSelRowIdx < 0)
                return;

            strMsgBox = LocalizationRecourceManager.GetString(strRegisterSectionName, "DelAthleteMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            string strPlayerID = dgv_Athlete.Rows[iSelRowIdx].Cells["MemberID"].Value.ToString();
            bool bResult = DeleteRegister(Convert.ToInt32(strPlayerID));
            if(bResult)
            {
                RefreshTree();
                if(iSelRowIdx == dgv_Athlete.Rows.Count -1)
                {
                    m_nSelPlayerGridIndex = iSelRowIdx - 1;
                }
                else 
                {
                    m_nSelPlayerGridIndex = iSelRowIdx;
                }
                UpdateAthleteGrid();

                // Cause Data Update In Inscription
                m_bInsTab_RegChanged = true;

                m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterDel, m_iActiveDiscipline, -1, -1, -1, Convert.ToInt32(strPlayerID), null);
            }
        }

        private void dgv_Athlete_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            int iRowIndex = e.RowIndex;
            int iColIndex = e.ColumnIndex;
            if (iRowIndex < 0 || iRowIndex >= dgv_Athlete.Rows.Count
                || iColIndex < 0 || iColIndex >= dgv_Athlete.Columns.Count)
                return;


            int iRegisterID = Convert.ToInt32(dgv_Athlete.Rows[iRowIndex].Cells["MemberID"].Value);
            string strBib = "";
            bool bUpdateResult = true;
            if (dgv_Athlete.Columns[iColIndex].HeaderText.CompareTo("BIB") == 0)
            {
                if (dgv_Athlete.Rows[iRowIndex].Cells[iColIndex].Value != null)
                {
                    strBib = dgv_Athlete.Rows[iRowIndex].Cells[iColIndex].Value.ToString();
                }
                bUpdateResult = UpdateRegisterBib(iRegisterID, strBib);

                if (bUpdateResult)
                    m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterModify, m_iActiveDiscipline, -1, -1, -1, iRegisterID, null);
            }
            if(!bUpdateResult)
            {
                m_nSelPlayerGridIndex = dgv_Athlete.SelectedRows[0].Index;
                UpdateAthleteGrid();
            }
        }

        private void dgv_Athlete_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button != MouseButtons.Right)
                return;
            dgv_Athlete.ContextMenuStrip = null;

            if (m_nSelNodeType == 2 || m_nSelNodeType == 3)
            {
                dgv_Athlete.ContextMenuStrip = EditMembercontextMenu;
            }

        }

        private void dgv_Athlete_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex > dgv_Athlete.RowCount - 1 || e.RowIndex < 0)
                return;

            int iSelRowIdx = e.RowIndex;
            string strPlayerID = dgv_Athlete.Rows[iSelRowIdx].Cells["MemberID"].Value.ToString();
            string strRegTypeID = dgv_Athlete.Rows[iSelRowIdx].Cells["RegTypeID"].Value.ToString();


            RegisterEditForm frmRegisterEdit = new RegisterEditForm(strRegisterSectionName);
            frmRegisterEdit.DatabaseConnection = m_RegisterModule.DatabaseConnection;
            frmRegisterEdit.Owner = this;
            frmRegisterEdit.module = m_RegisterModule;

            sDlgParam sEditMember = new sDlgParam();
            sEditMember.bEditCompetitorDlg = true;
            frmRegisterEdit.m_stDlgParam = sEditMember;

            int iGroupType = m_iCurGroupType;
            if (iGroupType == 1)
            {
                frmRegisterEdit.m_strFederationID = m_strSelGroupID;
            }
            else if (iGroupType == 2)
            {
                frmRegisterEdit.m_strNOCCode = m_strSelGroupID;
            }
            else if(iGroupType == 3)
            {
                frmRegisterEdit.m_strClubID = m_strSelGroupID;
            }
            else if (iGroupType == 4)
            {
                frmRegisterEdit.m_strDelegationID = m_strSelGroupID;
            }

            frmRegisterEdit.m_strRegID = strPlayerID;
            frmRegisterEdit.m_strRegTypeID = strRegTypeID;
            frmRegisterEdit.m_strLanguageCode = m_strActiveLanguage;
            frmRegisterEdit.m_iGroupType = iGroupType;
            frmRegisterEdit.ShowDialog();

            if (frmRegisterEdit.DialogResult == DialogResult.OK)
            {
                m_nSelPlayerGridIndex = iSelRowIdx;
                RefreshTree();
                UpdateAthleteGrid();

                // Cause Data Update In Inscription
                m_bInsTab_RegChanged = true;
            }
        }

        private void MenuEditMember_Click(object sender, EventArgs e)
        {
            DevComponents.AdvTree.Node SelNode = adv_RegisterTree.SelectedNode;
            SNodeInfo snode = (SNodeInfo)SelNode.Tag;

            MemberEditForm frmMemberEdit = new MemberEditForm(strRegisterSectionName);
            frmMemberEdit.DatabaseConnection = m_RegisterModule.DatabaseConnection;

            frmMemberEdit.m_strGroupID = m_strSelGroupID;
            frmMemberEdit.m_iGroupType = m_iCurGroupType;
            frmMemberEdit.m_strRegisterID = m_nSelNodeID.ToString();
            frmMemberEdit.m_strLanguageCode = m_strActiveLanguage;
            frmMemberEdit.m_strRegisterName = SelNode.Text;
            frmMemberEdit.m_strSexCode = snode.iSexCode.ToString();
            frmMemberEdit.ShowDialog();

            if (frmMemberEdit.DialogResult == DialogResult.OK)
            {
                RefreshTree();
                UpdateAthleteGrid();

                int iRegID = Convert.ToInt32(frmMemberEdit.m_strRegisterID);
                m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterModify, m_iActiveDiscipline, -1, -1, -1, iRegID, null);
            }
        }

        private void bm_AddTeam_Click(object sender, EventArgs e)
        {
            RegisterEditForm frmRegisterEdit = new RegisterEditForm(strRegisterSectionName);
            frmRegisterEdit.DatabaseConnection = m_RegisterModule.DatabaseConnection;
            frmRegisterEdit.Owner = this;
            frmRegisterEdit.module = m_RegisterModule;

            sDlgParam  sAddCompetitor = new sDlgParam();
            sAddCompetitor.bAddTeamDlg = true;
            frmRegisterEdit.m_stDlgParam = sAddCompetitor;

            if (m_iCurGroupType == 1)
            {
                frmRegisterEdit.m_strOrgFederationID = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 2)
            {
                frmRegisterEdit.m_strOrgNOCCode = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 3)
            {
                frmRegisterEdit.m_strOrgClubID = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 4)
            {
                frmRegisterEdit.m_strOrgDelegationID = m_strSelGroupID;
            }

            frmRegisterEdit.m_strOrgRegTypeID = nRegTypeOfTeam.ToString();
            frmRegisterEdit.m_strOrgLanguageCode = m_strActiveLanguage;
            frmRegisterEdit.m_iGroupType = m_iCurGroupType;
            frmRegisterEdit.ShowDialog();

            if (frmRegisterEdit.DialogResult == DialogResult.OK)
            {
                if (frmRegisterEdit.m_iNewRegisterID > 0)
                {
                    int iRegisterID = frmRegisterEdit.m_iNewRegisterID;
                    m_strLastSelNodeKey = "T" + iRegisterID.ToString();
                }

                RefreshTree();
                UpdateAthleteGrid();

                // Cause Data Update In Inscription
                m_bInsTab_RegChanged = true;
            }
        }

        private void bm_AddPair_Click(object sender, EventArgs e)
        {
            RegisterEditForm frmRegisterEdit = new RegisterEditForm(strRegisterSectionName);
            frmRegisterEdit.DatabaseConnection = m_RegisterModule.DatabaseConnection;
            frmRegisterEdit.Owner = this;
            frmRegisterEdit.module = m_RegisterModule;

            sDlgParam sAddCompetitor = new sDlgParam();
            sAddCompetitor.bAddPairDlg = true;
            frmRegisterEdit.m_stDlgParam = sAddCompetitor;

            if (m_iCurGroupType == 1)
            {
                frmRegisterEdit.m_strOrgFederationID = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 2)
            {
                frmRegisterEdit.m_strOrgNOCCode = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 3)
            {
                frmRegisterEdit.m_strOrgClubID = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 4)
            {
                frmRegisterEdit.m_strOrgDelegationID = m_strSelGroupID;
            }

            frmRegisterEdit.m_strOrgRegTypeID = nRegTypeOfPair.ToString();
            frmRegisterEdit.m_strOrgLanguageCode = m_strActiveLanguage;
            frmRegisterEdit.m_iGroupType = m_iCurGroupType;
            frmRegisterEdit.ShowDialog();

            if (frmRegisterEdit.DialogResult == DialogResult.OK)
            {
                int iNewRegisterID = frmRegisterEdit.m_iNewRegisterID;
                if (iNewRegisterID > 0)
                {
                    if (m_nSelNodeType == 3)
                    {
                        if (!AddPairToTeam(m_nSelNodeID, iNewRegisterID)) return;

                        m_strLastSelNodeKey = "P" + iNewRegisterID.ToString();
                    }
                    else
                        m_strLastSelNodeKey = "T" + iNewRegisterID.ToString();
                }

                RefreshTree();
                UpdateAthleteGrid();

                // Cause Data Update In Inscription
                m_bInsTab_RegChanged = true;
            }
        }

        private void bm_AddAthlete_Click(object sender, EventArgs e)
        {
            RegisterEditForm frmRegisterEdit = new RegisterEditForm(strRegisterSectionName);
            frmRegisterEdit.DatabaseConnection = m_RegisterModule.DatabaseConnection;
            frmRegisterEdit.Owner = this;
            frmRegisterEdit.module = m_RegisterModule;

            sDlgParam sAddCompetitor = new sDlgParam();
            sAddCompetitor.bAddCompetitorDlg = true;
            frmRegisterEdit.m_stDlgParam = sAddCompetitor;

            if (m_iCurGroupType == 1)
            {
                frmRegisterEdit.m_strOrgFederationID = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 2)
            {
                frmRegisterEdit.m_strOrgNOCCode = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 3)
            {
                frmRegisterEdit.m_strOrgClubID = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 4)
            {
                frmRegisterEdit.m_strOrgDelegationID = m_strSelGroupID;
            }

            frmRegisterEdit.m_strOrgRegTypeID = nRegTypeOfPlayer.ToString();
            frmRegisterEdit.m_strOrgLanguageCode = m_strActiveLanguage;
            frmRegisterEdit.m_iGroupType = m_iCurGroupType;
            frmRegisterEdit.ShowDialog();

            if (frmRegisterEdit.DialogResult == DialogResult.OK)
            {
                RefreshTree();
                m_nSelPlayerGridIndex = dgv_Athlete.RowCount;
                UpdateAthleteGrid();

                // Cause Data Update In Inscription
                m_bInsTab_RegChanged = true;
            }
        }

        private void bm_AddNonAthlete_Click(object sender, EventArgs e)
        {
            RegisterEditForm frmRegisterEdit = new RegisterEditForm(strRegisterSectionName);
            frmRegisterEdit.DatabaseConnection = m_RegisterModule.DatabaseConnection;
            frmRegisterEdit.Owner = this;
            frmRegisterEdit.module = m_RegisterModule;

            sDlgParam sAddNoAthlete = new sDlgParam();
            sAddNoAthlete.bAddNoAthleteDlg = true;
            frmRegisterEdit.m_stDlgParam = sAddNoAthlete;

            if (m_iCurGroupType == 1)
            {
                frmRegisterEdit.m_strOrgFederationID = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 2)
            {
                frmRegisterEdit.m_strOrgNOCCode = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 3)
            {
                frmRegisterEdit.m_strOrgClubID = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 4)
            {
                frmRegisterEdit.m_strOrgDelegationID = m_strSelGroupID;
            }

            frmRegisterEdit.m_strOrgRegTypeID = "";
            frmRegisterEdit.m_strOrgLanguageCode = m_strActiveLanguage;
            frmRegisterEdit.m_iGroupType = m_iCurGroupType;
            frmRegisterEdit.ShowDialog();

            if (frmRegisterEdit.DialogResult == DialogResult.OK)
            {
                m_nSelPlayerGridIndex = dgv_Athlete.RowCount;
                RefreshTree();
                UpdateAthleteGrid();

                // Cause Data Update In Inscription
                m_bInsTab_RegChanged = true;
            }
        }

        private void bm_AddHorse_Click(object sender, EventArgs e)
        {
            RegisterHorseEditForm frmRegisterEdit = new RegisterHorseEditForm(strRegisterSectionName);
            frmRegisterEdit.DatabaseConnection = m_RegisterModule.DatabaseConnection;
            frmRegisterEdit.Owner = this;
            frmRegisterEdit.module = m_RegisterModule;

            sDlgParam sAddCompetitor = new sDlgParam();
            sAddCompetitor.bAddHorseDlg = true;
            frmRegisterEdit.m_stDlgParam = sAddCompetitor;

            if (m_iCurGroupType == 1)
            {
                frmRegisterEdit.m_strOrgFederationID = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 2)
            {
                frmRegisterEdit.m_strOrgNOCCode = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 3)
            {
                frmRegisterEdit.m_strOrgClubID = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 4)
            {
                frmRegisterEdit.m_strOrgDelegationID = m_strSelGroupID;
            }

            frmRegisterEdit.m_strOrgRegTypeID = nRegTypeOfHorse.ToString();
            frmRegisterEdit.m_strOrgLanguageCode = m_strActiveLanguage;
            frmRegisterEdit.m_iGroupType = m_iCurGroupType;
            frmRegisterEdit.ShowDialog();

            if (frmRegisterEdit.DialogResult == DialogResult.OK)
            {
                RefreshTree();
                m_nSelPlayerGridIndex = dgv_Athlete.RowCount;
                UpdateAthleteGrid();

                // Cause Data Update In Inscription
                m_bInsTab_RegChanged = true;
            }
        }

        private void bm_DelTeam_Click(object sender, EventArgs e)
        {
            if (adv_RegisterTree.SelectedNode == null) return;

            DevComponents.AdvTree.Node SelNode = adv_RegisterTree.SelectedNode;
            SNodeInfo snode = (SNodeInfo)SelNode.Tag;

            string strMsgBox = LocalizationRecourceManager.GetString(strRegisterSectionName, "DelTeamMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            int iTeamID = snode.iRegisterID;
            bool bResult = DeleteRegister(iTeamID);
            if(bResult)
            {
                m_strLastSelNodeKey = snode.strFatherKey;
                RefreshTree();
                UpdateAthleteGrid();

                // Cause Data Update In Inscription
                m_bInsTab_RegChanged = true;

                m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterDel, m_iActiveDiscipline, -1, -1, -1, iTeamID, null);
            }
        }

        private void bm_DelPair_Click(object sender, EventArgs e)
        {
            if (adv_RegisterTree.SelectedNode == null) return;

            DevComponents.AdvTree.Node SelNode = adv_RegisterTree.SelectedNode;
            SNodeInfo snode = (SNodeInfo)SelNode.Tag;

            string strMsgBox = LocalizationRecourceManager.GetString(strRegisterSectionName, "DelPairMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            int iPairID = snode.iRegisterID;
            bool bResult = DeleteRegister(iPairID);
            if (bResult)
            {
                m_strLastSelNodeKey = snode.strFatherKey;
                RefreshTree();
                UpdateAthleteGrid();

                // Cause Data Update In Inscription
                m_bInsTab_RegChanged = true;

                m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterDel, m_iActiveDiscipline, -1, -1, -1, iPairID, null);
            }
        }

        private void bm_EditItem_Click(object sender, EventArgs e)
        {
            if (adv_RegisterTree.SelectedNode == null) return;

            DevComponents.AdvTree.Node SelNode = adv_RegisterTree.SelectedNode;
            SNodeInfo snode = (SNodeInfo)SelNode.Tag;

            RegisterEditForm frmRegisterEdit = new RegisterEditForm(strRegisterSectionName);
            frmRegisterEdit.DatabaseConnection = m_RegisterModule.DatabaseConnection;
            frmRegisterEdit.Owner = this;
            frmRegisterEdit.module = m_RegisterModule;

            sDlgParam sEditMember = new sDlgParam();
            sEditMember.bEditMemberDlg = true;
            frmRegisterEdit.m_stDlgParam = sEditMember;

            if (m_iCurGroupType == 1)
            {
                frmRegisterEdit.m_strFederationID = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 2)
            {
                frmRegisterEdit.m_strNOCCode = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 3)
            {
                frmRegisterEdit.m_strClubID = m_strSelGroupID;
            }
            else if (m_iCurGroupType == 4)
            {
                frmRegisterEdit.m_strDelegationID = m_strSelGroupID;
            }

            frmRegisterEdit.m_strRegID = m_nSelNodeID.ToString();
            frmRegisterEdit.m_strRegTypeID = m_nSelNodeType.ToString();
            frmRegisterEdit.m_strLanguageCode = m_strActiveLanguage;
            frmRegisterEdit.m_iGroupType = m_iCurGroupType;
            frmRegisterEdit.ShowDialog();

            if (frmRegisterEdit.DialogResult == DialogResult.OK)
            {
                RefreshTree();
                UpdateAthleteGrid();

                // Cause Data Update In Inscription
                m_bInsTab_RegChanged = true;
            }
        }

        private void bm_EditFederation_Click(object sender, EventArgs e)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for Find OneFederation

                SqlCommand cmd = new SqlCommand("Proc_GetOneGroupInfo", m_RegisterModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@GroupID", SqlDbType.NVarChar, 9);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@GroupType", SqlDbType.Int, 4);
                cmdParameter1.Value = m_strSelGroupID;
                cmdParameter2.Value = m_strActiveLanguage;
                cmdParameter3.Value = m_iCurGroupType;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                SqlDataReader sdr = cmd.ExecuteReader();
                OVRClubNationInfoForm frmClubNationInfo = new OVRClubNationInfoForm(strRegisterSectionName);
                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        if (m_iCurGroupType == 1 || m_iCurGroupType == 3)
                        {
                            frmClubNationInfo.m_iInfoID = Convert.ToInt32(m_strSelGroupID);
                            frmClubNationInfo.m_strCode = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_GroupCode");
                            frmClubNationInfo.m_strLongName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_LongName");
                            frmClubNationInfo.m_strShortName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_ShortName");
                            frmClubNationInfo.m_strComment = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_Comment");

                        }
                        else if (m_iCurGroupType == 2)
                        {
                            frmClubNationInfo.m_strCode = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_GroupCode");
                            frmClubNationInfo.m_strLongName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_LongName");
                            frmClubNationInfo.m_strShortName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_ShortName");
                            frmClubNationInfo.m_strComment = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_Comment");
                        }
                        else if (m_iCurGroupType == 4)
                        {
                            frmClubNationInfo.m_iInfoID = Convert.ToInt32(m_strSelGroupID);
                            frmClubNationInfo.m_strCode = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_GroupCode");
                            frmClubNationInfo.m_strLongName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_LongName");
                            frmClubNationInfo.m_strShortName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_ShortName");
                            frmClubNationInfo.m_strComment = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_Comment");
                            frmClubNationInfo.m_strDelegationType = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_Type");
                        }
                    }
                    sdr.Close();

                    frmClubNationInfo.DatabaseConnection = m_RegisterModule.DatabaseConnection;
                    frmClubNationInfo.m_nOperateType = 2;
                    if (m_iCurGroupType == 1)
                    {
                        frmClubNationInfo.m_emInfoType = EMInfoType.emFederation;
                    }
                    else if (m_iCurGroupType == 2)
                    {
                        frmClubNationInfo.m_emInfoType = EMInfoType.emNOC;
                    }
                    else if (m_iCurGroupType == 3)
                    {
                        frmClubNationInfo.m_emInfoType = EMInfoType.emClub;
                    }
                    else if (m_iCurGroupType == 4)
                    {
                        frmClubNationInfo.m_emInfoType = EMInfoType.emDelegation;
                    }
                    frmClubNationInfo.m_strLanguageCode = m_strActiveLanguage;
                    frmClubNationInfo.ShowDialog();
                    if (frmClubNationInfo.DialogResult == DialogResult.OK)
                    {
                        RefreshTree();

                        // Cause Data Update In Inscription
                        m_bInsTab_FedChanged = true;

                        m_RegisterModule.DataChangedNotify(OVRDataChangedType.emDelegationModify, m_iActiveDiscipline, -1, -1, -1, null, null);
                    }
                }
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        #endregion

        #region DataBase Functions

        private void GetSelNodeInfo(ref SNodeInfo SelNodeInfo)
        {
            SNodeInfo oneSNodeInfo = SelNodeInfo;
            m_strLastSelNodeKey = oneSNodeInfo.strNodeKey;
            m_strSelNodeKey = oneSNodeInfo.strNodeKey;
            m_strSelGroupID = oneSNodeInfo.strGroupID;
            m_nSelNodeID = oneSNodeInfo.iRegisterID;
            m_nSelNodeType = oneSNodeInfo.iRegTypeID;
        }

        private bool DeleteRegister(int nRegisterID)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for Del Athlete

                SqlCommand cmd = new SqlCommand("proc_DelRegister", m_RegisterModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@RegisterID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@RegisterID",
                             DataRowVersion.Current, nRegisterID);
              
                SqlParameter cmdParameter2 = new SqlParameter(
                             "@Result", SqlDbType.Int, 4,
                             ParameterDirection.Output, false, 0, 0, "@Result",
                             DataRowVersion.Default, null);
                
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "DelAthletePromotion_Failed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "DelAthletePromotion_Uneffect");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -4:
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "DelAthletePromotion_HasMatch");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default://其余的为删除成功！




                        return true;
                }	
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        private bool AddPairToTeam(int nRegisterID, int nMemberRegisterID)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for Add Pair To Team

                SqlCommand cmd = new SqlCommand("proc_AddMemberRegister", m_RegisterModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@RegisterID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@RegisterID",
                             DataRowVersion.Current, nRegisterID);
                
                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MemberRegisterID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MemberRegisterID",
                             DataRowVersion.Default, nMemberRegisterID);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@FunctionID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@FunctionID",
                             DataRowVersion.Default, DBNull.Value);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@PositionID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@PositionID",
                             DataRowVersion.Default, DBNull.Value);

                SqlParameter cmdParameter5 = new SqlParameter(
                             "@Order", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Order",
                             DataRowVersion.Default, DBNull.Value);

                SqlParameter cmdParameter6 = new SqlParameter(
                             "@ShirtNum", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@ShirtNum",
                             DataRowVersion.Default, DBNull.Value);

                SqlParameter cmdParameter7 = new SqlParameter(
                         "@Result", SqlDbType.Int, 4,
                         ParameterDirection.Output, false, 0, 0, "@Result",
                         DataRowVersion.Default, DBNull.Value);
               
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameter6);
                cmd.Parameters.Add(cmdParameter7);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "AddMember_Failed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "AddMember_Team");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "AddMember_Pair");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default://其余的为删除成功！




                        return true;
                }	
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        private bool UpdateRegisterBib(int iRegisterID, string strBib)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for UpdateRegisterBib
                string strSQLDes;

                if (strBib.Length == 0)
                {
                    strSQLDes = String.Format("UPDATE TR_Register SET F_Bib = NULL WHERE F_RegisterID = {0} ", iRegisterID);
                }
                else
                {
                    strSQLDes = String.Format("UPDATE TR_Register SET F_Bib = '{0}' WHERE F_RegisterID = {1}", strBib, iRegisterID);
                }
                SqlCommand cmd = new SqlCommand(strSQLDes, m_RegisterModule.DatabaseConnection);
                cmd.ExecuteNonQuery();
                #endregion
                return true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }
        #endregion
    }
}