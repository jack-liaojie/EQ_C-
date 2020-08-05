using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRRegister
{
    public enum EMInfoType
    {
        emUnKnown = -1,
        emNation = 0,
        emClub = 1,
        emColor = 2,
        emFederation = 3,
        emNOC = 4,
        emDelegation = 5
    }

    public partial class OVRRegisterForm : UIPage
    {
        private string m_strActiveLanguage = "";
        private int m_iActiveSport = -1;
        private int m_iSportGroupType = -1;
        private int m_iActiveDiscipline = -1;

        private bool m_bRegTab_RegChanged = false;
        private bool m_bInsTab_RegChanged = false;
        private bool m_bInsTab_FedChanged = false;

        private OVRRegisterModule m_RegisterModule;
        public OVRRegisterModule RegisterModule
        {
            set { m_RegisterModule = value; }
        }

        public OVRRegisterForm(string strName)
        {
            InitializeComponent();
            this.Name = strName;


            //////////////////////////////////////////////////////////////////////////
            //Initial Register Tab Language And Grid Style
            RegisterLabLocalization();
            InitGridViewStyleInRegister();

            //////////////////////////////////////////////////////////////////////////
            //Initial Inscription Tab Language And Grid Style
            InscriptionLabLocalization();
            InitGridViewStyleInInscription();
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
            // Load Active Info
            OVRDataBaseUtils.GetActiveInfo(m_RegisterModule.DatabaseConnection, out m_iActiveSport, out m_iActiveDiscipline, out m_strActiveLanguage);
            m_iSportGroupType = GetGroupType();

            //Register Tab
            RegisterInfoLoadData();

            //Inscription Tab
            InscriptionLoadData();
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

            if (flags.IsSignaled(OVRDataChangedType.emSportInfo))
            {
                int iGroupType = GetGroupType();
                if (iGroupType != m_iSportGroupType)
                {
                    m_iSportGroupType = iGroupType;
                    InscriptionLoadData();
                }
            }
            else if (flags.IsSignaled(OVRDataChangedType.emEventInfo) ||
                     flags.IsSignaled(OVRDataChangedType.emEventAdd) ||
                     flags.IsSignaled(OVRDataChangedType.emEventDel))
            {
                UpdateEventCombo();
                UpdatePlayerGrid();
            }
        }

        private void QueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;

            switch (args.Name)
            {
                case "DisciplineID":
                    args.Value = m_iActiveDiscipline.ToString();
                    args.Handled = true;
                    break;
                case "EventID":
                    if (this.cmbEvent.Visible)
                    {
                        args.Value = this.m_iSelEventID.ToString();
                        args.Handled = true;
                    }
                    break;
                case "FederationID":
                    {
                        if (adv_RegisterTree.Visible && adv_RegisterTree.SelectedNode != null)
                        {
                            SNodeInfo oneSNodeInfo = (SNodeInfo)adv_RegisterTree.SelectedNode.Tag;
                            if (m_iCurGroupType == 1)
                                args.Value = oneSNodeInfo.strGroupID;
                            else
                                args.Value = "-1";
                            args.Handled = true;
                        }
                        break;
                    }
                case "NOCID":
                    {
                        if (adv_RegisterTree.Visible && adv_RegisterTree.SelectedNode != null)
                        {
                            SNodeInfo oneSNodeInfo = (SNodeInfo)adv_RegisterTree.SelectedNode.Tag;
                            if (m_iCurGroupType == 2)
                                args.Value = oneSNodeInfo.strGroupID;
                            else
                                args.Value = "-1";
                            args.Handled = true;
                        }
                        break;
                    }
                case "ClubID":
                    {
                        if (adv_RegisterTree.Visible && adv_RegisterTree.SelectedNode != null)
                        {
                            SNodeInfo oneSNodeInfo = (SNodeInfo)adv_RegisterTree.SelectedNode.Tag;
                            if (m_iCurGroupType == 3)
                                args.Value = oneSNodeInfo.strGroupID;
                            else
                                args.Value = "-1";
                            args.Handled = true;
                        }
                        break;
                    }
                case "DelegationID":
                    {
                        if (adv_RegisterTree.Visible && adv_RegisterTree.SelectedNode != null)
                        {
                            SNodeInfo oneSNodeInfo = (SNodeInfo)adv_RegisterTree.SelectedNode.Tag;
                            if (m_iCurGroupType == 4)
                                args.Value = oneSNodeInfo.strGroupID;
                            else
                                args.Value = "-1";
                            args.Handled = true;
                        }
                        break;
                    }
                case "RegisterID":
                    {
                        if (adv_RegisterTree.Visible && adv_RegisterTree.SelectedNode != null)
                        {
                            SNodeInfo oneSNodeInfo = (SNodeInfo)adv_RegisterTree.SelectedNode.Tag;
                            if (oneSNodeInfo.iRegTypeID == 2 || oneSNodeInfo.iRegTypeID == 3)
                                args.Value = oneSNodeInfo.iRegisterID.ToString();
                            else
                                args.Value = "-1";
                            args.Handled = true;
                        }
                        break;
                    }
            }
        }

        private void OVRRegisterForm_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        private bool IsUpdateAllData(OVRDataChangedFlags flags)
        {
            if (m_RegisterModule == null) return false;

            if (flags.IsSignaled(OVRDataChangedType.emLangActive))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emSportActive))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emDisciplineActive))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emDisciplineInfo))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emRegisterModify))
                return true;
            if (flags.IsSignaled(OVRDataChangedType.emDelegationModify))
                return true;

            return false;
        }

        private void tabRegister_Click(object sender, EventArgs e)
        {
            // Update Data In RegisterInfo
            if (m_bRegTab_RegChanged)
            {
                RefreshTree();
                m_bRegTab_RegChanged = false;
            }

            UpdateReportContext();
        }

        private void tabInscription_Click(object sender, EventArgs e)
        {
            // Update Data In Inscription
            if (m_bInsTab_FedChanged)
            {
                UpdateFederationList();
                m_bInsTab_FedChanged = false;
                m_bInsTab_RegChanged = false;
            }
            else if (m_bInsTab_RegChanged)
            {
                UpdateAvailableGrid();
                UpdatePlayerGrid();
                m_bInsTab_RegChanged = false;
            }

            UpdateReportContext();
        }

        private void UpdateReportContext()
        {
            if (adv_RegisterTree.Visible)
            {
                string strFedID = "-1";
                string strNOCID = "-1";
                string strClbID = "-1";
                string strDlgID = "-1";
                string strRegID = "-1";


                if (adv_RegisterTree.SelectedNode != null)
                {
	                SNodeInfo oneSNodeInfo = (SNodeInfo)adv_RegisterTree.SelectedNode.Tag;
	                // -1:Discipline节点，0:Federation\Club\NOC 节点，1...:子节点

	                if (oneSNodeInfo.iNodeType != -1)
	                {
	                    if (m_iCurGroupType == 1)
	                        strFedID = oneSNodeInfo.strGroupID;
	                    else if (m_iCurGroupType == 2)
	                        strNOCID = oneSNodeInfo.strGroupID;
	                    else if (m_iCurGroupType == 3)
	                        strClbID = oneSNodeInfo.strGroupID;
	                    else if (m_iCurGroupType == 4)
	                        strDlgID = oneSNodeInfo.strGroupID;
	                }
	
	                if (oneSNodeInfo.iRegTypeID == 2 || oneSNodeInfo.iRegTypeID == 3)
	                    strRegID = oneSNodeInfo.iRegisterID.ToString();
                }

                m_RegisterModule.SetReportContext("EventID", "-1");

                m_RegisterModule.SetReportContext("FederationID", strFedID);
                m_RegisterModule.SetReportContext("NOCID", strNOCID);
                m_RegisterModule.SetReportContext("ClubID", strClbID);
                m_RegisterModule.SetReportContext("DelegationID", strDlgID);
                m_RegisterModule.SetReportContext("RegisterID", strRegID);
            }
            else
            {
                m_RegisterModule.SetReportContext("EventID", m_iSelEventID.ToString());

                string strFedID = "-1";
                string strNOCID = "-1";
                string strClbID = "-1";
                string strDlgID = "-1";
                if (m_strSelGroupID_Ins.Length > 0)
                {
	                if (m_iSportGroupType == 1)
	                    strFedID = m_strSelGroupID_Ins;
	                else if (m_iSportGroupType == 2)
	                    strNOCID = m_strSelGroupID_Ins;
	                else if (m_iSportGroupType == 3)
	                    strClbID = m_strSelGroupID_Ins;
	                else if (m_iSportGroupType == 4)
	                    strDlgID = m_strSelGroupID_Ins;
                }

                m_RegisterModule.SetReportContext("FederationID", strFedID);
                m_RegisterModule.SetReportContext("NOCID", strNOCID);
                m_RegisterModule.SetReportContext("ClubID", strClbID);
                m_RegisterModule.SetReportContext("DelegationID", strDlgID);
                m_RegisterModule.SetReportContext("RegisterID", "-1");
            }
        }

        private Int32 GetGroupType()
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            int iSportID = m_iActiveSport;

            string strSQLDes;
            strSQLDes = string.Format("SELECT F_ConfigValue FROM TS_Sport_Config WHERE F_ConfigType = 1 AND F_SportID = {0}", iSportID);
            SqlCommand cmd = new SqlCommand(strSQLDes, m_RegisterModule.DatabaseConnection);

            int iGroupType = -1;
            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                iGroupType = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ConfigValue");
            }
            dr.Close();
            return iGroupType;
        }

    }
}
