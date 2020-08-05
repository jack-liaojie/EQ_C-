using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Diagnostics;
using AutoSports.OVRCommon;
using DevComponents.DotNetBar;
using Sunny.UI;

namespace AutoSports.OVRRegister
{
    public struct sDlgParam            //struct for the dialog type
    {
        public bool bAddTeamDlg;        //AddTeamDlg
        public bool bAddPairDlg;        //AddPairDlg
        public bool bAddCompetitorDlg;  //AddAthleteDlg
        public bool bAddNoAthleteDlg;   //AddNoAthleteDlg
        public bool bAddDlg;
        public bool bEditMemberDlg;     //EditTeam/Pair's MemberDlg
        public bool bEditCompetitorDlg; //EditAthleteDlg
        public bool bAddHorseDlg;   //AddHorseDlg
    };

    public partial class RegisterEditForm : UIForm
    {
        public sDlgParam m_stDlgParam;

        public struct sRegisterInfo       //struct for the player info
        {
	       public int iRegID;
           public int iRegTypeID;
           public string strRegCode;
           public string strPlayerBib;
           public string strNOC;
           public int iClubID;
           public int iFederationID;
           public int iNationID;
           public int iDelegationID;
           public int iFunctionID;
           public int iSexCode;
           public string strBirthDate;
           public decimal dcHeight;
           public decimal dcWeight;
           public string strLanguageCode;
           public string strIFNum;
           public string strFirstName;
           public string strLastName;
           public string strLongName;
           public string strShortName;
           public string strTVLongName;
           public string strTVShortName;
           public string strSCBLongName;
           public string strSCBShortName;
           public string strPrintLongName;
           public string strPrintShortName;
           public string strWNPAFirstName;
           public string strWNPALastName;
           public string strBirthCountry;
           public string strBirthCity;
           public string strResidenceCountry;
           public string strResidenceCity;
           public int iIsRecord;
        };
        public sRegisterInfo m_stRegister;

        struct SPairName
        {
            public string strLongName;
            public string strShortName;
            public string strTVLongName;
            public string strTVShortName;
            public string strSCBLongName;
            public string strSCBShortName;
            public string strPrintLongName;
            public string strPrintShortName;
        };
        public UpdateRegisterGrid m_dgUpdateRegisterGrid;

        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        private DataTable m_tbLanguage = new DataTable();
        private DataTable m_tbSex = new DataTable();
        private DataTable m_tbRegType = new DataTable();
        private DataTable m_tbNOC = new DataTable();
        private DataTable m_tbClub = new DataTable();
        private DataTable m_tbFederation = new DataTable();
        private DataTable m_tbNation = new DataTable();
        private DataTable m_tbDelegation = new DataTable();
        private DataTable m_tbFunction = new DataTable();

        private int m_iSelUniformIdx = -1;

        private bool m_bModified = false;


        public RegisterEditForm(string strName)
        {
            InitializeComponent();
            this.Name = strName;

            //////////////////////////////////////////////////////////////////////////
            //Initial Language And Grid Style
            Localization();
            m_tbLanguage.Clear();
            m_tbSex.Clear();
            m_tbRegType.Clear();
            m_tbNOC.Clear();
            m_tbFederation.Clear();
            m_tbNation.Clear();
            m_tbClub.Clear();
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "EditRegisterInfoFrm");
            this.lbLanguage.Text = LocalizationRecourceManager.GetString(this.Name, "lbLanguage");
            this.lbRegType.Text = LocalizationRecourceManager.GetString(this.Name, "lbRegType");
            this.lbPlayerBib.Text = LocalizationRecourceManager.GetString(this.Name, "lbPlayerBib");
            this.lbSex.Text = LocalizationRecourceManager.GetString(this.Name, "lbSex");
            this.lbRegCode.Text = LocalizationRecourceManager.GetString(this.Name, "lbRegCode");
            this.lbFirstName.Text = LocalizationRecourceManager.GetString(this.Name, "lbFirstName");
            this.lbLastName.Text = LocalizationRecourceManager.GetString(this.Name, "lbLastName");
            this.lbLongName.Text = LocalizationRecourceManager.GetString(this.Name, "lbLongName");
            this.lbShortName.Text = LocalizationRecourceManager.GetString(this.Name, "lbShortName");
            this.lbPrintLongName.Text = LocalizationRecourceManager.GetString(this.Name, "lbPrintLongName");
            this.lbPrintShortName.Text = LocalizationRecourceManager.GetString(this.Name, "lbPrintShortName");
            this.lbSCBLongName.Text = LocalizationRecourceManager.GetString(this.Name, "lbSCBLongName");
            this.lbSCBShortName.Text = LocalizationRecourceManager.GetString(this.Name, "lbSCBShortName");
            this.lbTVLongName.Text = LocalizationRecourceManager.GetString(this.Name, "lbTVLongName");
            this.lbTVShortName.Text = LocalizationRecourceManager.GetString(this.Name, "lbTVShortName");
            this.lbWNPAFirstName.Text = LocalizationRecourceManager.GetString(this.Name, "lbWNPAFirstName");
            this.lbWNPALastName.Text = LocalizationRecourceManager.GetString(this.Name, "lbWNPALastName");
            this.lbNOC.Text = LocalizationRecourceManager.GetString(this.Name, "lbNOC");
            this.lbNation.Text = LocalizationRecourceManager.GetString(this.Name, "lbNation");
            this.lbFederation.Text = LocalizationRecourceManager.GetString(this.Name, "lbFederation");
            this.lbClub.Text = LocalizationRecourceManager.GetString(this.Name, "lbClub");
            this.lbDelegation.Text = LocalizationRecourceManager.GetString(this.Name, "lbDelegation");
            this.lbFunction.Text = LocalizationRecourceManager.GetString(this.Name, "lbFunction");
            this.lbIFNum.Text = LocalizationRecourceManager.GetString(this.Name, "lbIFNum");
            this.lbHeight.Text = LocalizationRecourceManager.GetString(this.Name, "lbHeight");
            this.lbWeight.Text = LocalizationRecourceManager.GetString(this.Name, "lbWeight");
            this.lbBirthDate.Text = LocalizationRecourceManager.GetString(this.Name, "lbBirthDate");
            this.lbUniform.Text = LocalizationRecourceManager.GetString(this.Name, "lbUniform");
            this.lbBirthCountry.Text = LocalizationRecourceManager.GetString(this.Name, "lbBirthCountry");
            this.lbBirthCity.Text = LocalizationRecourceManager.GetString(this.Name, "lbBirthCity");
            this.lbRecCountry.Text = LocalizationRecourceManager.GetString(this.Name, "lbRecCountry");
            this.lbRecCity.Text = LocalizationRecourceManager.GetString(this.Name, "lbRecCity"); 
            this.btnAutoName.Text = LocalizationRecourceManager.GetString(this.Name, "btnAutoName");
            this.btnEditMember.Text = LocalizationRecourceManager.GetString(this.Name, "btnEditMember");
            this.btnEditComment.Text = LocalizationRecourceManager.GetString(this.Name, "btnEditComment");
            this.btnAutoPairName.Text = LocalizationRecourceManager.GetString(this.Name, "btnAutoPairName");
            this.btnOK_Again.Text = LocalizationRecourceManager.GetString(this.Name, "btnOKAgain");

            this.chkIsRecord.Text = LocalizationRecourceManager.GetString(this.Name, "chkIsRecord");
        }

        public OVRModuleBase module = null;
      
	    public string    m_strRegID = "";
        public string    m_strRegCode = "";
	    public string    m_strLanguageCode = "";
	    public string    m_strRegTypeID  = "";
	    public string    m_strSexCode  = "";
        public string    m_strNOCCode = "";
        public string    m_strFederationID  = "";
        public string    m_strClubID  = "";
        public string    m_strNationID  = "";
        public string    m_strDelegationID = "";
        public string    m_strFunctionID = "";
        public string    m_strBirthCountry = "";
        public string    m_strRecCountry = "";
        public int       m_iNewRegisterID = 0;
        public int       m_iGroupType = 0;

        public string   m_strOrgRegTypeID = "";
        public string   m_strOrgFederationID = "";
        public string   m_strOrgLanguageCode = "";
        public string   m_strOrgClubID = "";
        public string   m_strOrgNOCCode = "";
        public string   m_strOrgDelegationID = "";
        public string   m_strOrgFunctionID = "";

        public int      m_iActiveSportID = 0;
        public int      m_iAtciveDesciplineID = 0;
        public string   m_strActiveLanguageCode = "";

        private int     m_iDBGroupType = -1;

        public int m_iIsRecord = 0;


        private void frmRegisterEdit_Load(object sender, EventArgs e)
        {
            OVRDataBaseUtils.GetActiveInfo(this.sqlConnection, out m_iActiveSportID, out m_iAtciveDesciplineID, out m_strActiveLanguageCode);

            m_iDBGroupType = GetGroupType();

            //为队或组合添加队员或非运动员 或者修改队员

            if (m_stDlgParam.bEditMemberDlg || m_stDlgParam.bEditCompetitorDlg)
            {
                InitRegInfo(m_strRegID); 
                if ((Convert.ToInt32(m_strRegTypeID) == 3 || Convert.ToInt32(m_strRegTypeID) == 2) && m_stDlgParam.bEditMemberDlg)
                {
                    ResetRegUniformInfo();
                    dgvUniform.Visible = true;
                    btnAddUniform.Visible = true;
                    btnDelUniform.Visible = true;
                    btnEditColor.Visible = true;
                    lbUniform.Visible = true;
                }
            }
   
            //增加队员或增加非运动员,修改运动员信息

            if (m_stDlgParam.bAddCompetitorDlg || m_stDlgParam.bAddNoAthleteDlg || m_stDlgParam.bEditCompetitorDlg)
            {
                cmbRegType.Enabled = !m_stDlgParam.bAddCompetitorDlg;

                if(!m_stDlgParam.bEditCompetitorDlg)
                {
                    btnOK_Again.Visible = true;
                    m_strRegTypeID = m_strOrgRegTypeID;
                    m_strFederationID = m_strOrgFederationID;
                    m_strLanguageCode = m_strOrgLanguageCode;
                    m_strClubID = m_strOrgClubID;
                    m_strNOCCode = m_strOrgNOCCode;
                    m_strDelegationID = m_strOrgDelegationID;
                    m_strFunctionID = m_strOrgFunctionID;
                }
                btnEditMember.Enabled = false;
                btnAutoPairName.Enabled = false;
            }
            else if (m_stDlgParam.bAddTeamDlg || m_stDlgParam.bAddPairDlg || m_stDlgParam.bEditMemberDlg)   //增加队或组合
            {
                txHeight.Enabled = false;
                txWeight.Enabled = false;
                txBib.Enabled = true;
                dtBirthDate.Enabled = false;
                txFirstName.Enabled = false;
                txLastName.Enabled = false;
                btnAutoName.Enabled = false;
                btnEditMember.Enabled = true;
                btnAutoPairName.Enabled = true;
                cmbFunction.Enabled = false;
                cmbBirthCountry.Enabled = false;
                cmbRecCountry.Enabled = false;
                txtBirthCity.Enabled = false;
                txtRecCity.Enabled = false;

                if (!m_stDlgParam.bEditMemberDlg)
                {
                    btnOK_Again.Visible = true;
                    m_strRegTypeID = m_strOrgRegTypeID;
                    m_strFederationID = m_strOrgFederationID;
                    m_strLanguageCode = m_strOrgLanguageCode;
                    m_strClubID = m_strOrgClubID;
                    m_strNOCCode = m_strOrgNOCCode;
                    m_strDelegationID = m_strOrgDelegationID;
                    m_strFunctionID = m_strOrgFunctionID;
                }
            }

            btnEditComment.Enabled = true;
            InitCombox();

            ///////////////////////////////////////////
            //修改运动员信息或修改队伍信息，不需要根据Delegation添加NOC
            if (!m_stDlgParam.bEditMemberDlg && !m_stDlgParam.bEditCompetitorDlg)
            {
                SetNOCByDelegation();
            }
            
        }
        
        //private void RegisterEditForm_FormClosed(object sender, FormClosedEventArgs e)
        //{
        //    if (m_bModified)
        //        this.DialogResult = DialogResult.OK;
        //}

        //protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
        //{
        //    if (keyData == (Keys.Alt | Keys.A))
        //    {
        //        btnOKAgain_Click(null, null);

        //        return true;
        //    }

        //    return base.ProcessCmdKey(ref msg, keyData);
        //}


        #region  Assist Functions

        private void SetNOCByDelegation()
        {
            ////////////////////////////////////////
            //当m_DBGrouptype为4时，且Register为空时，保证delegation与noc一致


            if (m_iDBGroupType == 4)
            {
                if (m_strNOCCode.Length == 0 && m_strDelegationID.Length != 0)
                {
                    if (cmbDelegation.SelectedItem != null)
                    {
                        string strDelegationName = cmbDelegation.SelectedValue.ToString();
                        string strDelegationCode = GetDelegationCode(strDelegationName);
                        cmbNOC.SelectedValue = strDelegationCode;
                    }
                }
            }
        }

        private void InitRegInfo(string strRegID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_GetRegisterInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = Convert.ToInt32(strRegID);
                cmdParameter2.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        txBib.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Bib");
                        txFirstName.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_FirstName");
                        txLastName.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_LastName");
                        txLongName.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_LongName");
                        txShortName.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ShortName");
                        txTVLongName.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_TVLongName");
                        txTVShortName.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_TVShortName");
                        txSCBLongName.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_SBLongName");
                        txSCBShortName.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_SBShortName");
                        txPrintLongName.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_PrintLongName");
                        txPrintShortName.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_PrintShortName");
                        txWNPAFirstName.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_WNPA_FirstName");
                        txWNPALastName.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_WNPA_LastName");
                        txRegCode.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_RegisterCode");
                        m_strSexCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_SexCode");
                        m_strNationID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_NationID");
                        m_strNOCCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_NOC");
                        m_strRegTypeID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_RegTypeID");
                        m_strFederationID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_FederationID");
                        m_strClubID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ClubID");
                        textIFNum.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_RegisterNum");
                        txHeight.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Height");
                        txWeight.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Weight");
                        dtBirthDate.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Birth_Date");
                        m_strDelegationID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DelegationID");
                        m_strFunctionID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_FunctionID");
                        
                        m_iIsRecord = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_IsRecord");
                        txtBirthCity.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Birth_City");
                        m_strBirthCountry = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Birth_Country");
                        txtRecCity.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Residence_City");
                        m_strRecCountry = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Residence_Country");

                        if (m_iIsRecord == 0)
                        {
                            chkIsRecord.Checked = false;
                        }
                        else
                        {
                            chkIsRecord.Checked = true;
                        }
                    }
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void ResetRegUniformInfo()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(dgvUniform);
            UpdateUniformGrid();
        }

        private void UpdateUniformGrid()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get UniformInfo
                SqlCommand cmd = new SqlCommand("Proc_GetUniformInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter Parameter1 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter Parameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                Parameter1.Value = Convert.ToInt32(m_strRegID);
                Parameter2.Value = m_strLanguageCode;
                cmd.Parameters.Add(Parameter1);
                cmd.Parameters.Add(Parameter2);

                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                OVRDataBaseUtils.FillDataGridViewWithCmb(dgvUniform, dr, 1, 2, 3);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            /////////////////////////////////////////////
            //Set Grid Style
            if(dgvUniform.Rows.Count > 0)
            {
                dgvUniform.Columns[0].ReadOnly = false;
                if (m_iSelUniformIdx < 0)
                {
                    return;
                }
                else if (m_iSelUniformIdx > dgvUniform.RowCount - 1)
                {
                    m_iSelUniformIdx = dgvUniform.RowCount - 1;
                }
                dgvUniform.FirstDisplayedScrollingRowIndex = m_iSelUniformIdx;      
                dgvUniform.Rows[m_iSelUniformIdx].Selected = true;
            }
             
        }

        private void CleanAllContext()
        {
             m_strRegID = "";
             txFirstName.Text = "";
             txLastName.Text = "";
             txLongName.Text = "";
             txShortName.Text = "";
             txTVLongName.Text = "";
             txTVShortName.Text = "";
             txPrintLongName.Text = "";
             txPrintShortName.Text = "";
             txSCBLongName.Text = "";
             txSCBShortName.Text = "";
             txPrintLongName.Text = "";
             txPrintShortName.Text = "";
             txWNPAFirstName.Text = "";
             txWNPALastName.Text = "";
             textIFNum.Text = "";
             txHeight.Text = "";
             txWeight.Text = "";
             dtBirthDate.Text = "";
             txRegCode.Text = "";
             txBib.Text = "";
             txtBirthCity.Text = "";
             txtRecCity.Text = "";
             cmbBirthCountry.SelectedIndex = -1;
             cmbRecCountry.SelectedIndex = -1;
        }

        private void GetComboxValue()
        {
            m_strRegTypeID = cmbRegType.SelectedValue.ToString();
            m_strSexCode = cmbSex.SelectedValue.ToString();

            if (cmbNOC.SelectedValue == null || cmbNOC.SelectedValue.ToString() == "-1")
            {
                m_strNOCCode = "0";
            }
            else
            {
                m_strNOCCode = cmbNOC.SelectedValue.ToString();
            }

            if (cmbFederation.SelectedValue == null || Convert.ToInt32(cmbFederation.SelectedValue) == -1)
            {
                m_strFederationID = "0";
            }
            else
            {
                m_strFederationID = cmbFederation.SelectedValue.ToString();
            }

            if (cmbNation.SelectedValue == null || Convert.ToInt32(cmbNation.SelectedValue) == -1)
            {
                m_strNationID = "0";
            }
            else
            {
                m_strNationID = cmbNation.SelectedValue.ToString();
            }

            if (cmbClub.SelectedValue == null || Convert.ToInt32(cmbClub.SelectedValue) == -1)
            {
                m_strClubID = "0";
            }
            else
            {
                m_strClubID = cmbClub.SelectedValue.ToString();
            }


            if (cmbDelegation.SelectedValue == null || Convert.ToInt32(cmbDelegation.SelectedValue) == -1)
            {
                m_strDelegationID = "0";
            }
            else
            {
                m_strDelegationID = cmbDelegation.SelectedValue.ToString();
            }


            if (cmbFunction.SelectedValue == null || Convert.ToInt32(cmbFunction.SelectedValue) == -1)
            {
                m_strFunctionID = "0";
            }
            else
            {
                m_strFunctionID = cmbFunction.SelectedValue.ToString();
            }

            if (cmbBirthCountry.SelectedValue == null || cmbBirthCountry.SelectedValue.ToString() == "-1")
            {
                m_strBirthCountry = "0";
            }
            else
            {
                m_strBirthCountry = cmbBirthCountry.SelectedValue.ToString();
            }

            if (cmbRecCountry.SelectedValue == null || cmbRecCountry.SelectedValue.ToString() == "-1")
            {
                m_strRecCountry = "0";
            }
            else
            {
                m_strRecCountry = cmbRecCountry.SelectedValue.ToString();
            }
        }

        private bool CreatePairName(string strRegisterID, ref SPairName stPairname)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Create Pair Name

                SqlCommand cmd = new SqlCommand("proc_CreateDoubleName_Without_Result", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter(
                             "@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter1.Value = Convert.ToInt32(strRegisterID);
                cmdParameter2.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        stPairname.strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_LongName");
                        stPairname.strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ShortName");
                        stPairname.strTVLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_TVLongName");
                        stPairname.strTVShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_TVShortName");
                        stPairname.strSCBLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_SBLongName");
                        stPairname.strSCBShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_SBShortName");
                        stPairname.strPrintLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_PrintLongName");
                        stPairname.strPrintShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_PrintShortName");
                    }
                    dr.Close();
                    return true;
                }
                else
                {
                    stPairname.strLongName = "";
                    stPairname.strShortName = "";
                    stPairname.strTVLongName = "";
                    stPairname.strTVShortName = "";
                    stPairname.strSCBLongName = "";
                    stPairname.strSCBShortName = "";
                    stPairname.strPrintLongName = "";
                    stPairname.strPrintShortName = "";

                    dr.Close();
                    return true;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        private bool CreateTeamName(string strGroupID, ref SPairName stPairname)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                string strFederation = "";
                #region DML Command Setup for Get Federation Name
                SqlCommand FederationCmd = new SqlCommand("Proc_CreateTeamName", sqlConnection);
                FederationCmd.CommandType = CommandType.StoredProcedure;

                SqlParameter Parameter1 = new SqlParameter("@GroupID", SqlDbType.NVarChar, 9);
                SqlParameter Parameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter Parameter3 = new SqlParameter("@GroupType", SqlDbType.Int);

                Parameter1.Value = strGroupID;
                Parameter2.Value = m_strLanguageCode;
                Parameter3.Value = m_iGroupType;
                FederationCmd.Parameters.Add(Parameter1);
                FederationCmd.Parameters.Add(Parameter2);
                FederationCmd.Parameters.Add(Parameter3);
                SqlDataReader dr = FederationCmd.ExecuteReader();

                if (!dr.HasRows)
                {
                    dr.Close();
                    return false;
                }
                while (dr.Read())
                {
                    strFederation = OVRDataBaseUtils.GetFieldValue2String(ref dr, "TeamShortName");
                }
                #endregion
                stPairname.strLongName = strFederation;
                stPairname.strShortName = strFederation;
                stPairname.strTVLongName = strFederation;
                stPairname.strTVShortName = strFederation;
                stPairname.strSCBLongName = strFederation;
                stPairname.strSCBShortName = strFederation;
                stPairname.strPrintLongName = strFederation;
                stPairname.strPrintShortName = strFederation;
                dr.Close();
                return true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        private void AutoName()
        {
            string strLongName = txFirstName.Text + " " + txLastName.Text;
            string strShortName = txLastName.Text;
            txLongName.Text = strLongName;
            txPrintLongName.Text = strLongName;
            txSCBLongName.Text = strLongName;
            txTVLongName.Text = strLongName;

            txShortName.Text = strShortName;
            txPrintShortName.Text = strShortName;
            txSCBShortName.Text = strShortName;
            txTVShortName.Text = strShortName;
        }

        private bool GetRegisterInfo()
        {
            string strPromotion = "";

            if (cmbLanguage.SelectedIndex < 0)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "LanguageMsgBox");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return false;
            }

            if (cmbRegType.SelectedIndex < 0)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "RegTypeMsgBox");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return false;
            }

            if (cmbSex.SelectedIndex < 0)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "SexMsgBox");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return false;
            }

            m_stRegister.strRegCode = txRegCode.Text.ToString();
            if (m_stRegister.strRegCode.Length == 0 )
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "RegCodeMsgBox");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return false;
            }

            if(m_iDBGroupType == 1 && cmbFederation.SelectedIndex <= 0 )   //1-Federation,2-NOC, 3-Club, 4-Delegation
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "FederationMsgBox");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return false;
            }
            else if(m_iDBGroupType == 2 && cmbNOC.SelectedIndex <= 0)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "NOCMsgBox");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return false;
            }
            else if(m_iDBGroupType == 3 && cmbClub.SelectedIndex <= 0)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "ClubMsgBox");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return false;
            }
            else if(m_iDBGroupType == 4 && cmbDelegation.SelectedIndex <= 0)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelegationMsgBox");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return false;
            }

            GetComboxValue();

            m_stRegister.iRegTypeID = Convert.ToInt32(m_strRegTypeID);
            m_stRegister.strRegCode = txRegCode.Text.ToString();
            m_stRegister.strNOC = m_strNOCCode;
            m_stRegister.iClubID = Convert.ToInt32(m_strClubID);
            m_stRegister.iFederationID = Convert.ToInt32(m_strFederationID);
            m_stRegister.iNationID = Convert.ToInt32(m_strNationID);
            m_stRegister.iFunctionID = Convert.ToInt32(m_strFunctionID);
            m_stRegister.iDelegationID = Convert.ToInt32(m_strDelegationID);
            m_stRegister.iSexCode = Convert.ToInt32(m_strSexCode);
            m_stRegister.strBirthDate = dtBirthDate.Text.ToString();
            if (txHeight.Text.ToString().Length == 0)
            {
                m_stRegister.dcHeight = 0.00m;
            }
            else
            {
                try
                {
                    m_stRegister.dcHeight = Convert.ToDecimal(txHeight.Text.ToString());
                }
                catch (System.Exception ex)
                {
                    string strMsgBox = LocalizationRecourceManager.GetString(this.Name, "Number_Msg");
                    DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox);
                    return false;
                }
            }
            if (txWeight.Text.ToString().Length == 0)
            {
                m_stRegister.dcWeight = 0.00m;
            }
            else
            {
                try
                {
                    m_stRegister.dcWeight = Convert.ToDecimal(txWeight.Text.ToString());
                }
                catch (System.Exception ex)
                {
                    string strMsgBox = LocalizationRecourceManager.GetString(this.Name, "Number_Msg");
                    DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox);
                    return false;
                }
            }

            m_stRegister.strPlayerBib = txBib.Text.ToString();
            m_stRegister.strLanguageCode = m_strLanguageCode;
            m_stRegister.strIFNum = textIFNum.Text.ToString();
            m_stRegister.strFirstName = txFirstName.Text.ToString();
            m_stRegister.strLastName = txLastName.Text.ToString();
            m_stRegister.strLongName = txLongName.Text.ToString();
            m_stRegister.strShortName = txShortName.Text.ToString();
            m_stRegister.strTVLongName = txTVLongName.Text.ToString();
            m_stRegister.strTVShortName = txTVShortName.Text.ToString();
            m_stRegister.strSCBLongName = txSCBLongName.Text.ToString();
            m_stRegister.strSCBShortName = txSCBShortName.Text.ToString();
            m_stRegister.strPrintLongName = txPrintLongName.Text.ToString();
            m_stRegister.strPrintShortName = txPrintShortName.Text.ToString();
            m_stRegister.strWNPAFirstName = txWNPAFirstName.Text.ToString();
            m_stRegister.strWNPALastName = txWNPALastName.Text.ToString();

            m_stRegister.strBirthCity = txtBirthCity.Text.ToString();
            m_stRegister.strBirthCountry = m_strBirthCountry;
            m_stRegister.strResidenceCity = txtRecCity.Text.ToString();
            m_stRegister.strResidenceCountry = m_strRecCountry;
            m_stRegister.iIsRecord = m_iIsRecord;

            return true;
        }

        private void FillColorComboBox(int nColIdx)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Fill Color combo
                SqlCommand cmd = new SqlCommand("Proc_GetColorInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter Parameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar);
                Parameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(Parameter1);

                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                DataTable table = new DataTable();
                table.Columns.Add("F_ColorLongName", typeof(string));
                table.Columns.Add("F_ColorID", typeof(int));
                table.Rows.Add("", "-1");
                table.Load(dr);

                (dgvUniform.Columns[nColIdx] as DGVCustomComboBoxColumn).FillComboBoxItems(table, "F_ColorLongName", "F_ColorID");
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

        }

        #endregion

        #region  Init the ComboBox

        private void InitCombox()
        {
            InitLanguageCombox();
            InitSexCombox();
            InitRegTypeCombox();
            InitNOCCombox();
            InitNationCombox();
            InitFederationCombox();
            InitClubCombox();
            InitDelegationCombox();
            InitFunctionCombox();
        }

        private void InitLanguageCombox()
        {
            m_tbLanguage.Clear();
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_GetLanguageCode", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataReader dr = cmd.ExecuteReader();
                m_tbLanguage.Load(dr);
                dr.Close();

                cmbLanguage.DisplayMember = "F_LanguageDescription";
                cmbLanguage.ValueMember = "F_LanguageCode";
                cmbLanguage.DataSource = m_tbLanguage;
                if (m_strLanguageCode.Length != 0)
                    cmbLanguage.SelectedValue = m_strLanguageCode;
                else
                    cmbLanguage.SelectedIndex = -1;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }       
        }

        private void InitSexCombox()
        {
            m_tbSex.Clear();
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_GetSexInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);

                SqlDataReader dr = cmd.ExecuteReader();
                m_tbSex.Load(dr);
                dr.Close();

                cmbSex.DisplayMember = "F_SexLongName";
                cmbSex.ValueMember = "F_SexCode";
                cmbSex.DataSource = m_tbSex;
                if (m_strSexCode.Length != 0)
                    cmbSex.SelectedValue = m_strSexCode;
                else
                    cmbSex.SelectedIndex = -1;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }        
        }

        private void InitRegTypeCombox()
        {
             m_tbRegType.Clear();
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_GetRegTypeInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);

                SqlDataReader dr = cmd.ExecuteReader();
                m_tbRegType.Load(dr);
                dr.Close();

                cmbRegType.DisplayMember = "F_RegTypeLongDescription";
                cmbRegType.ValueMember = "F_RegTypeID";
                cmbRegType.DataSource = m_tbRegType;

                if (m_strRegTypeID.Length != 0)
                    cmbRegType.SelectedValue = m_strRegTypeID;
                else
                    cmbRegType.SelectedIndex = -1;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void InitNOCCombox()
        {
             m_tbNOC.Clear();
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_GetNOCInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);

                SqlDataReader dr = cmd.ExecuteReader();
                m_tbNOC.Load(dr);
                dr.Close();

                ////////////////////
                //NOC ComboBox
                cmbNOC.DisplayMember = "F_Name";
                cmbNOC.ValueMember = "F_Key";
                cmbNOC.DataSource = m_tbNOC;

                if (m_strNOCCode.Length != 0)
                    cmbNOC.SelectedValue = m_strNOCCode;
                else
                    cmbNOC.SelectedIndex = -1;

                ////////////////////
                //BirthCountry ComboBox
                cmbBirthCountry.DisplayMember = "F_Name";
                cmbBirthCountry.ValueMember = "F_Key";
                cmbBirthCountry.DataSource = m_tbNOC.Copy();

                if (m_strBirthCountry.Length != 0)
                    cmbBirthCountry.SelectedValue = m_strBirthCountry;
                else
                    cmbBirthCountry.SelectedIndex = -1;

                ////////////////////
                //RecCountry ComboBox
                cmbRecCountry.DisplayMember = "F_Name";
                cmbRecCountry.ValueMember = "F_Key";
                cmbRecCountry.DataSource = m_tbNOC.Copy();

                if (m_strRecCountry.Length != 0)
                    cmbRecCountry.SelectedValue = m_strRecCountry;
                else
                    cmbRecCountry.SelectedIndex = -1;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }         
        }

        private void InitNationCombox()
        {
             m_tbNation.Clear();
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_GetNationInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);

                SqlDataReader dr = cmd.ExecuteReader();
                m_tbNation.Load(dr);
                dr.Close();

                cmbNation.DisplayMember = "F_Name";
                cmbNation.ValueMember = "F_Key";
                cmbNation.DataSource = m_tbNation;

                if (m_strNationID.Length != 0)
                    cmbNation.SelectedValue = m_strNationID;
                else
                    cmbNation.SelectedIndex = -1;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }        
        }

        private void InitFederationCombox()
        {
            m_tbFederation.Clear();
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                string strDisciplineID = "";
                #region DML Command Setup for Active Discipline

                SqlCommand cmdDiscipline = new SqlCommand("Proc_GetActiveDiscipline", sqlConnection);
                cmdDiscipline.CommandType = CommandType.StoredProcedure;
                SqlDataReader dr = cmdDiscipline.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        strDisciplineID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DisciplineID");
                    }
                }
                dr.Close();
                #endregion

                SqlCommand cmd = new SqlCommand("Proc_GetFederationInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);

                SqlDataReader drFederation = cmd.ExecuteReader();
                m_tbFederation.Load(drFederation);
                drFederation.Close();

                cmbFederation.DisplayMember = "F_Name";
                cmbFederation.ValueMember = "F_Key";
                cmbFederation.DataSource = m_tbFederation;

                if (cmbFederation.Items.Count > 0)
                {
                    if (m_strFederationID.Length != 0)
                        cmbFederation.SelectedValue = m_strFederationID;
                    else
                        cmbFederation.SelectedIndex = -1;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }       
        }

        private void InitClubCombox()
        {
             m_tbClub.Clear();
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_GetClubInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);

                SqlDataReader dr = cmd.ExecuteReader();
                m_tbClub.Load(dr);
                dr.Close();

                cmbClub.DisplayMember = "F_Name";
                cmbClub.ValueMember = "F_Key";
                cmbClub.DataSource = m_tbClub;

                if (m_strClubID.Length != 0)
                    cmbClub.SelectedValue = m_strClubID;
                else
                    cmbClub.SelectedIndex = -1;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void InitDelegationCombox()
        {
            m_tbDelegation.Clear();
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_GetDelegationInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);

                SqlDataReader dr = cmd.ExecuteReader();
                m_tbDelegation.Load(dr);
                dr.Close();

                cmbDelegation.DisplayMember = "F_Name";
                cmbDelegation.ValueMember = "F_Key";
                cmbDelegation.DataSource = m_tbDelegation;

                if (m_strDelegationID.Length != 0)
                    cmbDelegation.SelectedValue = m_strDelegationID;
                else
                    cmbDelegation.SelectedIndex = -1;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void InitFunctionCombox()
        {
            m_tbFunction.Clear();
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_GetFunctionInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter2 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@RegType",      SqlDbType.Int);

                cmdParameter1.Value = m_strLanguageCode;
                cmdParameter2.Value = m_iAtciveDesciplineID;

                if (m_strRegTypeID.Length == 0)
                {
                    cmdParameter3.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter3.Value = Convert.ToInt32(m_strRegTypeID);
                }
                
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);

                SqlDataReader dr = cmd.ExecuteReader();
                m_tbFunction.Load(dr);
                dr.Close();

                cmbFunction.DisplayMember = "F_Name";
                cmbFunction.ValueMember = "F_Key";
                cmbFunction.DataSource = m_tbFunction;

                if (m_strFunctionID.Length != 0)
                    cmbFunction.SelectedValue = m_strFunctionID;
                else
                    cmbFunction.SelectedIndex = -1;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private Int32 GetGroupType()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            int iSportID = m_iActiveSportID;

            string strSQLDes;
            strSQLDes = string.Format("SELECT F_ConfigValue FROM TS_Sport_Config WHERE F_ConfigType = 1 AND F_SportID = {0}", iSportID);
            SqlCommand cmd = new SqlCommand(strSQLDes, sqlConnection);

            int iGroupType = -1;
            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                iGroupType = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ConfigValue");
            }
            dr.Close();
            return iGroupType;
        }

        private string GetDelegationCode(string strDelegationID)
        {
            string strDelegationCode = "";
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            string strSQLDes;
            strSQLDes = string.Format("SELECT F_DelegationCode FROM TC_Delegation WHERE F_DelegationID = '{0}'", strDelegationID);
            SqlCommand cmd = new SqlCommand(strSQLDes, sqlConnection);

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                strDelegationCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DelegationCode");
            }
            dr.Close();

            return strDelegationCode;
        }
        #endregion

        #region User Interface Operation

        private void btnOK_Click(object sender, EventArgs e)
        {
            if (! GetRegisterInfo())
                return;

            String strPromotion;
            if((m_stRegister.strFirstName.Length != 0 && m_stRegister.strLastName.Length != 0) && (m_stRegister.strLongName.Length == 0 && m_stRegister.strShortName.Length == 0))
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "AutoName_Msg");
                
                if(DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion,"",MessageBoxButtons.YesNo) == DialogResult.Yes)
                {
                    AutoName();
                    return;
                }
            }

            bool bResult = false;
	        if(m_stDlgParam.bAddCompetitorDlg || m_stDlgParam.bAddTeamDlg || m_stDlgParam.bAddPairDlg || m_stDlgParam.bAddNoAthleteDlg || m_stDlgParam.bAddDlg)
	        {
                if (m_strRegID.Length == 0)
                {
                    bResult = AddRegister();
                }
                else
                {
                    bResult = UpdateRegister();
                }
	        }
	        else
	        {
                m_stRegister.iRegID = Convert.ToInt32(m_strRegID);
		        bResult = UpdateRegister();
	        }
            if(bResult)
            {
                this.Close();
            } 
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    
        private void btnOKAgain_Click(object sender, EventArgs e)
        {
            if(!GetRegisterInfo())
                return;

            String strPromotion;
            if ((m_stRegister.strFirstName.Length != 0 && m_stRegister.strLastName.Length != 0) && (m_stRegister.strLongName.Length == 0 && m_stRegister.strShortName.Length == 0))
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "AutoName_Msg");

                if (DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion, "", MessageBoxButtons.YesNo) == DialogResult.Yes)
                {
                    AutoName();
                    return;
                }
            }

            bool bResult = false;

            if (m_strRegID.Length == 0)
            {
                bResult = AddRegister();
            }
            else
            {
                bResult = UpdateRegister();
            }

            if (bResult)
            {
                if(null ==  m_dgUpdateRegisterGrid)
                {
                    ///////////////////////////////////////////////
                    //代理刷新
                    OVRRegisterForm frmRegister = (OVRRegisterForm)this.Owner;
                    m_dgUpdateRegisterGrid = new UpdateRegisterGrid(frmRegister.UpdateAthleteGridForAdd);
                }
                m_dgUpdateRegisterGrid(m_stDlgParam, Convert.ToInt32(m_iNewRegisterID));
                CleanAllContext();
            } 
        }       

        private void cmbLanguage_SelectionChangeCommitted(object sender, EventArgs e)
        {
            m_strLanguageCode = Convert.ToString(cmbLanguage.SelectedValue);

            if (m_stDlgParam.bEditMemberDlg || m_stDlgParam.bEditCompetitorDlg)   //为队或组合添加队员或非运动员 或者修改队员


            {
                InitRegInfo(m_strRegID);

                if ((Convert.ToInt32(m_strRegTypeID) == 3 || Convert.ToInt32(m_strRegTypeID) == 2) && m_stDlgParam.bEditMemberDlg)
                {
                    ResetRegUniformInfo();
                }
            }
            InitSexCombox();
            InitRegTypeCombox();
            InitNationCombox();
            InitClubCombox();
            InitNOCCombox();
            InitFederationCombox();
            InitDelegationCombox();
            InitFunctionCombox();
        }

        private void cmbRegType_SelectionChangeCommitted(object sender, EventArgs e)
        {
            int iRegTypeID = Convert.ToInt32(cmbRegType.SelectedValue);
            m_strRegTypeID = cmbRegType.SelectedValue.ToString();
            if(iRegTypeID == 2 || iRegTypeID == 3)
            {
                txBib.Text = "";
                txFirstName.Text = "";
                txLastName.Text = "";
                txHeight.Text = "";
                txWeight.Text = "";
                dtBirthDate.Text = "";

                txBib.Enabled = true;
                txFirstName.Enabled = false;
                txLastName.Enabled = false;
                txHeight.Enabled = false;
                txWeight.Enabled = false;
                dtBirthDate.Enabled = false;
                btnAutoName.Enabled = false;
                cmbFunction.Enabled = false;
               
                if(m_stDlgParam.bEditMemberDlg || m_stDlgParam.bEditCompetitorDlg)
                {
                    dgvUniform.Visible = true;
                    ResetRegUniformInfo();

                    btnAddUniform.Visible = true;
                    btnDelUniform.Visible = true;
                    btnEditColor.Visible = true;
                    lbUniform.Visible = true;
                }

            }
            else
            {
                txBib.Enabled = true;
                txFirstName.Enabled = true;
                txLastName.Enabled = true;
                txHeight.Enabled = true;
                txWeight.Enabled = true;
                dtBirthDate.Enabled = true;
                btnAutoName.Enabled = true;

                dgvUniform.Visible = false;
                btnAddUniform.Visible = false;
                btnDelUniform.Visible = false;
                btnEditColor.Visible = false;
                lbUniform.Visible = false;
                cmbFunction.Enabled = true;

                InitFunctionCombox();
            }
        }

        private void btnEditMember_Click(object sender, EventArgs e)
        {
            if(m_stDlgParam.bAddTeamDlg || m_stDlgParam.bAddPairDlg || m_stDlgParam.bAddDlg)   //如果是新建
            {
                if (!GetRegisterInfo())
                    return;

                bool bResult;
                if (m_strRegID.Length == 0)
                {
                    bResult = AddRegister();
                    if (bResult)
                    {
                        m_stRegister.iRegID = m_iNewRegisterID;
                        m_strRegID = Convert.ToString(m_iNewRegisterID);
                    }
                }
                else
                {
                    bResult = UpdateRegister();                    
                }
               
                if (!bResult)
                    return;
            }

            MemberEditForm frmMemberEdit = new MemberEditForm(this.Name);
            frmMemberEdit.DatabaseConnection = DatabaseConnection;

            frmMemberEdit.m_iGroupType = this.m_iGroupType;
            if(m_iGroupType == 1)
            {
                frmMemberEdit.m_strGroupID = this.m_strFederationID;
            }
            else if(m_iGroupType == 2)
            {
                frmMemberEdit.m_strGroupID = this.m_strNOCCode;
            }
            else if(m_iGroupType == 3)
            {
                frmMemberEdit.m_strGroupID = this.m_strClubID;
            }
            else if (m_iGroupType == 4)
            {
                frmMemberEdit.m_strGroupID = this.m_strDelegationID;
            }
            frmMemberEdit.m_strRegisterID = this.m_strRegID;
            frmMemberEdit.m_strLanguageCode = this.m_strLanguageCode;
            frmMemberEdit.m_strRegisterName = this.txLongName.Text;
            frmMemberEdit.m_strSexCode = this.m_strSexCode;
            frmMemberEdit.ShowDialog();

            if (frmMemberEdit.DialogResult == DialogResult.OK)
            {
                int iRegID = Convert.ToInt32(m_strRegID);
                if (module != null)
                    module.DataChangedNotify(OVRDataChangedType.emRegisterModify, m_iAtciveDesciplineID, -1, -1, -1, iRegID, null);
                m_bModified = true;
            }
        }

        private void btnAutoName_Click(object sender, EventArgs e)
        {
            AutoName();
        }

        private void btnAutoPairName_Click(object sender, EventArgs e)
        {
            bool bResult = false;
            if (m_stDlgParam.bAddTeamDlg || m_stDlgParam.bAddPairDlg || m_stDlgParam.bAddDlg)   //如果是新建

            {
                if (!GetRegisterInfo())
                    return;

                if (m_strRegID.Length == 0)
                {
                    bResult = AddRegister();
                    if (bResult)
                    {
                        m_stRegister.iRegID = m_iNewRegisterID;
                        m_strRegID = Convert.ToString(m_iNewRegisterID);
                    }
                }
                else
                {
                    bResult = UpdateRegister();
                }

                if (!bResult)
                    return;
            }

            SPairName  stPairName = new SPairName();
            bResult = false;

            if(cmbRegType.SelectedValue == null)
            {
                string strPromotion = LocalizationRecourceManager.GetString(this.Name, "RegTypeMsgBox");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }
            string strRegCode = cmbRegType.SelectedValue.ToString();
            if(strRegCode.CompareTo("2") == 0)
            {
                bResult = CreatePairName(m_strRegID, ref stPairName);
            }
            else if(strRegCode.CompareTo("3") == 0)
            {
                string strGroupID = "";
                if(m_iGroupType == 1)
                {
                    strGroupID = m_strFederationID;
                }
                else if(m_iGroupType == 2)
                {
                    strGroupID = m_strNOCCode;
                }
                else if(m_iGroupType == 3)
                {
                    strGroupID = m_strClubID;
                }
                else if(m_iGroupType == 4)
                {
                    strGroupID = m_strDelegationID;
                }
                bResult = CreateTeamName(strGroupID, ref stPairName);
            }
            if (bResult)
            {
                txLongName.Text = stPairName.strLongName;
                txPrintLongName.Text = stPairName.strPrintLongName;
                txSCBLongName.Text = stPairName.strSCBLongName;
                txTVLongName.Text = stPairName.strTVLongName;

                txShortName.Text = stPairName.strShortName;
                txPrintShortName.Text = stPairName.strPrintShortName;
                txSCBShortName.Text = stPairName.strSCBShortName;
                txTVShortName.Text = stPairName.strTVShortName;
            }
        }

        private void btnNation_Click(object sender, EventArgs e)
        {
            string strOrgNationID = "";
            if(cmbNation.SelectedIndex >= 0)
            {
               strOrgNationID = cmbNation.SelectedValue.ToString();
            }
            
            OVRClubNationListForm frmOvrClubNationList = new OVRClubNationListForm(this.Name);
            frmOvrClubNationList.DatabaseConnection = DatabaseConnection;
            frmOvrClubNationList.m_emInfoType = EMInfoType.emNation;
            frmOvrClubNationList.m_strLanguageCode = m_strLanguageCode;
            frmOvrClubNationList.ShowDialog();

            InitNationCombox();

            if (strOrgNationID.Length == 0)
            {
                cmbNation.SelectedIndex = -1;
            }
            else
            {
                cmbNation.SelectedValue = strOrgNationID;
            }
        }

        private void btnClub_Click(object sender, EventArgs e)
        {
            string strOrgClubID = "";
            if(cmbClub.SelectedIndex >= 0)
            {
                strOrgClubID = cmbClub.SelectedValue.ToString();
            }

            OVRClubNationListForm frmOvrClubNationList = new OVRClubNationListForm(this.Name);
            frmOvrClubNationList.DatabaseConnection = DatabaseConnection;
            frmOvrClubNationList.m_emInfoType = EMInfoType.emClub;
            frmOvrClubNationList.m_strLanguageCode = m_strLanguageCode;
            frmOvrClubNationList.ShowDialog();

            InitClubCombox();

            if(strOrgClubID.Length == 0)
            {
                cmbClub.SelectedIndex = -1;
            }
            else
            {
                cmbClub.SelectedValue = strOrgClubID;
            }
        }

        private void btnNOC_Click(object sender, EventArgs e)
        {
            string strOrgNOC = "";
            if(cmbNOC.SelectedIndex >= 0)
            {
                strOrgNOC = cmbNOC.SelectedValue.ToString();
            }

            OVRClubNationListForm frmOvrClubNationList = new OVRClubNationListForm(this.Name);
            frmOvrClubNationList.DatabaseConnection = DatabaseConnection;
            frmOvrClubNationList.m_emInfoType = EMInfoType.emNOC;
            frmOvrClubNationList.m_strLanguageCode = m_strLanguageCode;
            frmOvrClubNationList.ShowDialog();

            InitNOCCombox();

            if(strOrgNOC.Length == 0 )
            {
                cmbNOC.SelectedIndex = -1;
            }
            else
            {
                cmbNOC.SelectedValue = strOrgNOC;
            }
        }

        private void btnEditComment_Click(object sender, EventArgs e)
        {
            if (m_stDlgParam.bAddTeamDlg || m_stDlgParam.bAddPairDlg || m_stDlgParam.bAddNoAthleteDlg || m_stDlgParam.bAddCompetitorDlg || m_stDlgParam.bAddDlg)   //如果是新建


            {
                if (!GetRegisterInfo())
                    return;

                bool bResult;
                if (m_strRegID.Length == 0)
                {
                    bResult = AddRegister();
                    if (bResult)
                    {
                        m_stRegister.iRegID = m_iNewRegisterID;
                        m_strRegID = Convert.ToString(m_iNewRegisterID);
                    }
                }
                else
                {
                    bResult = UpdateRegister();
                }

                if (!bResult)
                    return;
            }

            OVRCommentEditForm frmCommentEdit = new OVRCommentEditForm(this.Name);
            frmCommentEdit.DatabaseConnection = DatabaseConnection;
            frmCommentEdit.m_iRegisterID =Convert.ToInt32(m_strRegID);
            frmCommentEdit.ShowDialog();

            if (frmCommentEdit.DialogResult == DialogResult.OK)
            {
                if (module != null)
                    module.DataChangedNotify(OVRDataChangedType.emRegisterModify, m_iAtciveDesciplineID, -1, -1, -1, m_stRegister.iRegID, null);
                m_bModified = true;
            }
        }

        private void btnAddUniform_Click(object sender, EventArgs e)
        {
            int nRegisterID = Convert.ToInt32(m_strRegID);
            if (InsertTeamUniform(nRegisterID))
            {
                m_iSelUniformIdx = dgvUniform.Rows.Count;
                UpdateUniformGrid();
            }
        }

        private void btnDelUniform_Click(object sender, EventArgs e)
        {
            int nSelRowCount = dgvUniform.SelectedRows.Count;
            if(nSelRowCount <= 0)
            {
                string strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelUniform_Chose");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }

            String strUniformId = dgvUniform.SelectedRows[0].Cells["ID"].Value.ToString();
            int nRegisterID = Convert.ToInt32(m_strRegID);
            int nUniformID = Convert.ToInt32(strUniformId);
            if (DelTeamUniform(nRegisterID, nUniformID))
            {
                if(m_iSelUniformIdx == dgvUniform.Rows.Count -1)
                    m_iSelUniformIdx = dgvUniform.Rows.Count - 2;
                else
                    m_iSelUniformIdx = dgvUniform.SelectedRows[0].Index;

                UpdateUniformGrid();
            }
        }

        private void btnEditColor_Click(object sender, EventArgs e)
        {
            OVRClubNationListForm frmOvrClubNationList = new OVRClubNationListForm(this.Name);
            frmOvrClubNationList.DatabaseConnection = DatabaseConnection;
            frmOvrClubNationList.m_emInfoType = EMInfoType.emColor;
            frmOvrClubNationList.m_strLanguageCode = m_strLanguageCode;

            frmOvrClubNationList.ShowDialog();
        }

        private void dgvUniform_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            int iColumnIndex = e.ColumnIndex;
            if (dgvUniform.Columns[iColumnIndex].Name.CompareTo("Shirt Color") == 0
                || dgvUniform.Columns[iColumnIndex].Name.CompareTo("Shorts Color") == 0
                || dgvUniform.Columns[iColumnIndex].Name.CompareTo("Socks Color") == 0)
            {
                FillColorComboBox(iColumnIndex);
            }
        }

        private void dgvUniform_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex < 0 || e.RowIndex < 0)
                return;

            int iColumnIndex = e.ColumnIndex;
            int iRowIndex = e.RowIndex;
            String strColumnName = dgvUniform.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvUniform.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                string strInputValue = "";
                int iInputKey = 0;
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    iInputKey = Convert.ToInt32(CurCell1.Tag);
                }
                else if (CurCell.Value != null)
                {
                    strInputValue = CurCell.Value.ToString();
                }
                
                int nUniformID = Convert.ToInt32(dgvUniform.Rows[iRowIndex].Cells["ID"].Value);
                if (strColumnName.CompareTo("Order") == 0)
                {
                    UpdateTeamUniformOrder(nUniformID, strInputValue);
                }
                else if (strColumnName.CompareTo("Shirt Color") == 0)
                {
                    UpdateTeamUniformColor(nUniformID, iInputKey,0);
                }
                else if (strColumnName.CompareTo("Shorts Color") == 0)
                {
                    UpdateTeamUniformColor(nUniformID, iInputKey, 1);
                }
                else if (strColumnName.CompareTo("Socks Color") == 0)
                {
                    UpdateTeamUniformColor(nUniformID, iInputKey, 2);
                }
            }
            m_iSelUniformIdx = iRowIndex;
            UpdateUniformGrid();
        }

        #endregion

        #region DataBase Functions

        private bool AddRegister()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            string strDisciplineID = "";
            try
            {
                #region DML Command Setup for Active Discipline

                SqlCommand cmdDiscipline = new SqlCommand("Proc_GetActiveDiscipline", sqlConnection);
                cmdDiscipline.CommandType = CommandType.StoredProcedure;
                SqlDataReader dr = cmdDiscipline.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        strDisciplineID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DisciplineID");
                    }
                }
                dr.Close();
                #endregion
            
                #region DML Command Setup for Add Register
                SqlCommand cmd = new SqlCommand("proc_AddRegisterWithDelegationFunction", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@RegTypeID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@RegisterCode", SqlDbType.NVarChar, 20);
                SqlParameter cmdParameter4 = new SqlParameter("@NOC", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter5 = new SqlParameter("@ClubID", SqlDbType.Int);
                SqlParameter cmdParameter6 = new SqlParameter("@FederationID", SqlDbType.Int);
                SqlParameter cmdParameter7 = new SqlParameter("@SexCode", SqlDbType.Int);
                SqlParameter cmdParameter8 = new SqlParameter("@BirthDate", SqlDbType.DateTime);
                SqlParameter cmdParameter9 = new SqlParameter("@Height", SqlDbType.Decimal);
                SqlParameter cmdParameter10 = new SqlParameter("@Weight", SqlDbType.Decimal);
                SqlParameter cmdParameter11 = new SqlParameter("@NationID", SqlDbType.Int);
                SqlParameter cmdParameter12 = new SqlParameter("@languageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter13 = new SqlParameter("@FirstName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter14 = new SqlParameter("@LastName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter15 = new SqlParameter("@LongName", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter16 = new SqlParameter("@ShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter17 = new SqlParameter("@TvLongName", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter18 = new SqlParameter("@TvShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter19 = new SqlParameter("@SBLongName", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter20 = new SqlParameter("@SBShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter21 = new SqlParameter("@PrintLongName", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter22 = new SqlParameter("@PrintShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter23 = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameter cmdParameter24 = new SqlParameter("@Bib", SqlDbType.NVarChar, 20);
                SqlParameter cmdParameter25 = new SqlParameter("@DelegationID", SqlDbType.Int);
                SqlParameter cmdParameter26 = new SqlParameter("@FunctionID", SqlDbType.Int);
                SqlParameter cmdParameter27 = new SqlParameter("@RegisterNum", SqlDbType.NVarChar, 20);
                SqlParameter cmdParameter28 = new SqlParameter("@WNPAFirstName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter29 = new SqlParameter("@WNPALastName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter30 = new SqlParameter("@BirthCountry", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter31 = new SqlParameter("@BirthCity", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter32 = new SqlParameter("@ResidenceCountry", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter33 = new SqlParameter("@ResidenceCity", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter34 = new SqlParameter("@IsRecord", SqlDbType.Int);

                int iDisciplineID = Convert.ToInt32(strDisciplineID);
                cmdParameter1.Value = iDisciplineID;
                cmdParameter2.Value = m_stRegister.iRegTypeID;
                cmdParameter3.Value = m_stRegister.strRegCode;
                if (m_stRegister.strNOC.CompareTo("0") == 0)
                {
                    cmdParameter4.Value = DBNull.Value;
                }
                else
                    cmdParameter4.Value = m_stRegister.strNOC;

                if (m_stRegister.iClubID == 0)
                {
                    cmdParameter5.Value = DBNull.Value;
                }
                else
                    cmdParameter5.Value = m_stRegister.iClubID;

                if (m_stRegister.iFederationID == 0)
                {
                    cmdParameter6.Value = DBNull.Value;
                }
                else
                    cmdParameter6.Value = m_stRegister.iFederationID;

                if (m_stRegister.iSexCode == 0)
                {
                    cmdParameter7.Value = DBNull.Value;
                }
                else
                    cmdParameter7.Value = m_stRegister.iSexCode;

                if (m_stRegister.strBirthDate.Length == 0)
                {
                    cmdParameter8.Value = DBNull.Value;
                }
                else
                    cmdParameter8.Value = Convert.ToDateTime(m_stRegister.strBirthDate);

                cmdParameter9.Value = m_stRegister.dcHeight;
                cmdParameter10.Value = m_stRegister.dcWeight;

                if (m_stRegister.iNationID == 0)
                {
                    cmdParameter11.Value = DBNull.Value;
                }
                else
                    cmdParameter11.Value = m_stRegister.iNationID;

                cmdParameter12.Value = m_stRegister.strLanguageCode;
                cmdParameter13.Value = m_stRegister.strFirstName;
                cmdParameter14.Value = m_stRegister.strLastName;
                cmdParameter15.Value = m_stRegister.strLongName;
                cmdParameter16.Value = m_stRegister.strShortName;
                cmdParameter17.Value = m_stRegister.strTVLongName;
                cmdParameter18.Value = m_stRegister.strTVShortName;
                cmdParameter19.Value = m_stRegister.strSCBLongName;
                cmdParameter20.Value = m_stRegister.strSCBShortName;
                cmdParameter21.Value = m_stRegister.strPrintLongName;
                cmdParameter22.Value = m_stRegister.strPrintShortName;
                cmdParameter28.Value = m_stRegister.strWNPAFirstName;
                cmdParameter29.Value = m_stRegister.strWNPALastName;
                cmdParameter24.Value = m_stRegister.strPlayerBib;

                if (m_stRegister.iDelegationID == 0)
                {
                    cmdParameter25.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter25.Value = m_stRegister.iDelegationID;
                }

                if(m_stRegister.iFunctionID == 0)
                {
                    cmdParameter26.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter26.Value = m_stRegister.iFunctionID;
                }

                cmdParameter27.Value = m_stRegister.strIFNum;


                if (m_stRegister.strBirthCountry.CompareTo("0") == 0)
                {
                    cmdParameter30.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter30.Value = m_stRegister.strBirthCountry;
                }

                if (m_stRegister.strBirthCity == null || m_stRegister.strBirthCity.Length == 0)
                {
                    cmdParameter31.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter31.Value = m_stRegister.strBirthCity;
                }

                if (m_stRegister.strResidenceCountry.CompareTo("0") == 0)
                {
                    cmdParameter32.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter32.Value = m_stRegister.strResidenceCountry;
                }

                if (m_stRegister.strResidenceCity == null || m_stRegister.strResidenceCity.Length == 0 )
                {
                    cmdParameter33.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter33.Value = m_stRegister.strResidenceCity;
                }
                cmdParameter34.Value = m_stRegister.iIsRecord; 


                cmdParameter23.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameter6);
                cmd.Parameters.Add(cmdParameter7);
                cmd.Parameters.Add(cmdParameter8);
                cmd.Parameters.Add(cmdParameter9);
                cmd.Parameters.Add(cmdParameter10);
                cmd.Parameters.Add(cmdParameter11);
                cmd.Parameters.Add(cmdParameter12);
                cmd.Parameters.Add(cmdParameter13);
                cmd.Parameters.Add(cmdParameter14);
                cmd.Parameters.Add(cmdParameter15);
                cmd.Parameters.Add(cmdParameter16);
                cmd.Parameters.Add(cmdParameter17);
                cmd.Parameters.Add(cmdParameter18);
                cmd.Parameters.Add(cmdParameter19);
                cmd.Parameters.Add(cmdParameter20);
                cmd.Parameters.Add(cmdParameter21);
                cmd.Parameters.Add(cmdParameter22);
                cmd.Parameters.Add(cmdParameter23);
                cmd.Parameters.Add(cmdParameter24);
                cmd.Parameters.Add(cmdParameter25);
                cmd.Parameters.Add(cmdParameter26);
                cmd.Parameters.Add(cmdParameter27);
                cmd.Parameters.Add(cmdParameter28);
                cmd.Parameters.Add(cmdParameter29);
                cmd.Parameters.Add(cmdParameter30);
                cmd.Parameters.Add(cmdParameter31);
                cmd.Parameters.Add(cmdParameter32);
                cmd.Parameters.Add(cmdParameter33);
                cmd.Parameters.Add(cmdParameter34);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "AddRegister_Failed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "AddRegister_RegType");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -3:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "AddRegister_RegCode2");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default://其余的为添加成功
                        m_iNewRegisterID = nRetValue;
                        if (module != null)
                            module.DataChangedNotify(OVRDataChangedType.emRegisterAdd, iDisciplineID, -1, -1, -1, m_iNewRegisterID, null);
                        m_bModified = true;
                        return true;
                }	
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        private bool UpdateRegister()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }
            string strDisciplineID = "";
            try
            {
                #region DML Command Setup for Active Discipline
                SqlCommand cmdDiscipline = new SqlCommand("Proc_GetActiveDiscipline", sqlConnection);
                cmdDiscipline.CommandType = CommandType.StoredProcedure;
                SqlDataReader dr = cmdDiscipline.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        strDisciplineID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DisciplineID");
                    }
                }
                dr.Close();
                #endregion

                #region DML Command Setup for Add Register

                SqlCommand cmd = new SqlCommand("proc_EditRegisterWithFunctionDelegation", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@RegTypeID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@RegisterCode", SqlDbType.NVarChar, 20);
                SqlParameter cmdParameter4 = new SqlParameter("@NOC", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter5 = new SqlParameter("@ClubID", SqlDbType.Int);
                SqlParameter cmdParameter6 = new SqlParameter("@FederationID", SqlDbType.Int);
                SqlParameter cmdParameter7 = new SqlParameter("@SexCode", SqlDbType.Int);
                SqlParameter cmdParameter8 = new SqlParameter("@BirthDate", SqlDbType.DateTime);
                SqlParameter cmdParameter9 = new SqlParameter("@Height", SqlDbType.Decimal, 10);
                SqlParameter cmdParameter10 = new SqlParameter("@Weight", SqlDbType.Decimal, 10);
                SqlParameter cmdParameter11 = new SqlParameter("@NationID", SqlDbType.Int);
                SqlParameter cmdParameter12 = new SqlParameter("@languageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter13 = new SqlParameter("@FirstName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter14 = new SqlParameter("@LastName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter15 = new SqlParameter("@LongName", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter16 = new SqlParameter("@ShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter17 = new SqlParameter("@TvLongName", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter18 = new SqlParameter("@TvShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter19 = new SqlParameter("@SBLongName", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter20 = new SqlParameter("@SBShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter21 = new SqlParameter("@PrintLongName", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter22 = new SqlParameter("@PrintShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter23 = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameter cmdParameter24 = new SqlParameter("@Bib", SqlDbType.NVarChar, 20);
                SqlParameter cmdParameter25 = new SqlParameter("@DelegationID", SqlDbType.Int);
                SqlParameter cmdParameter26 = new SqlParameter("@FunctionID", SqlDbType.Int);
                SqlParameter cmdParameter27 = new SqlParameter("@RegisterNum", SqlDbType.NVarChar, 20);
                SqlParameter cmdParameter28 = new SqlParameter("@WNPAFirstName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter29 = new SqlParameter("@WNPALastName", SqlDbType.NVarChar, 50);

                SqlParameter cmdParameter30 = new SqlParameter("@BirthCountry", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter31 = new SqlParameter("@BirthCity", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter32 = new SqlParameter("@ResidenceCountry", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter33 = new SqlParameter("@ResidenceCity", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter34 = new SqlParameter("@IsRecord", SqlDbType.Int);

                cmdParameter0.Value = m_stRegister.iRegID;
                cmdParameter1.Value = Convert.ToInt32(strDisciplineID);
                cmdParameter2.Value = m_stRegister.iRegTypeID;
                cmdParameter3.Value = m_stRegister.strRegCode;
                if (m_stRegister.strNOC.CompareTo("0") == 0)
                {
                    cmdParameter4.Value = DBNull.Value;
                }
                else
                    cmdParameter4.Value = m_stRegister.strNOC;

                if (m_stRegister.iClubID == 0)
                {
                    cmdParameter5.Value = DBNull.Value;
                }
                else
                    cmdParameter5.Value = m_stRegister.iClubID;

                if (m_stRegister.iFederationID == 0)
                {
                    cmdParameter6.Value = DBNull.Value;
                }
                else
                    cmdParameter6.Value = m_stRegister.iFederationID;

                if (m_stRegister.iSexCode == 0)
                {
                    cmdParameter7.Value = DBNull.Value;
                }
                else
                    cmdParameter7.Value = m_stRegister.iSexCode;

                if (m_stRegister.strBirthDate.Length == 0)
                {
                    cmdParameter8.Value = DBNull.Value;
                }
                else
                    cmdParameter8.Value = Convert.ToDateTime(m_stRegister.strBirthDate);

                cmdParameter9.Value = m_stRegister.dcHeight;
                cmdParameter10.Value = m_stRegister.dcWeight;

                if (m_stRegister.iNationID == 0)
                {
                    cmdParameter11.Value = DBNull.Value;
                }
                else
                    cmdParameter11.Value = m_stRegister.iNationID;

                cmdParameter12.Value = m_stRegister.strLanguageCode;
                cmdParameter13.Value = m_stRegister.strFirstName;
                cmdParameter14.Value = m_stRegister.strLastName;
                cmdParameter15.Value = m_stRegister.strLongName;
                cmdParameter16.Value = m_stRegister.strShortName;
                cmdParameter17.Value = m_stRegister.strTVLongName;
                cmdParameter18.Value = m_stRegister.strTVShortName;
                cmdParameter19.Value = m_stRegister.strSCBLongName;
                cmdParameter20.Value = m_stRegister.strSCBShortName;
                cmdParameter21.Value = m_stRegister.strPrintLongName;
                cmdParameter22.Value = m_stRegister.strPrintShortName;
                cmdParameter28.Value = m_stRegister.strWNPAFirstName;
                cmdParameter29.Value = m_stRegister.strWNPALastName;
                cmdParameter24.Value = m_stRegister.strPlayerBib;

                if (m_stRegister.iDelegationID == 0)
                {
                    cmdParameter25.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter25.Value = m_stRegister.iDelegationID;
                }

                if (m_stRegister.iFunctionID == 0)
                {
                    cmdParameter26.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter26.Value = m_stRegister.iFunctionID;
                }
                cmdParameter27.Value = m_stRegister.strIFNum;
                cmdParameter23.Direction = ParameterDirection.Output;

                if (m_stRegister.strBirthCountry.CompareTo("0") == 0)
                {
                    cmdParameter30.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter30.Value = m_stRegister.strBirthCountry;
                }

                if (m_stRegister.strBirthCity == null || m_stRegister.strBirthCity.Length == 0)
                {
                    cmdParameter31.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter31.Value = m_stRegister.strBirthCity;
                }

                if (m_stRegister.strResidenceCountry.CompareTo("0") == 0)
                {
                    cmdParameter32.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter32.Value = m_stRegister.strResidenceCountry;
                }

                if (m_stRegister.strResidenceCity == null || m_stRegister.strResidenceCity.Length == 0)
                {
                    cmdParameter33.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter33.Value = m_stRegister.strResidenceCity;
                }

                cmdParameter34.Value = m_stRegister.iIsRecord; 

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameter6);
                cmd.Parameters.Add(cmdParameter7);
                cmd.Parameters.Add(cmdParameter8);
                cmd.Parameters.Add(cmdParameter9);
                cmd.Parameters.Add(cmdParameter10);
                cmd.Parameters.Add(cmdParameter11);
                cmd.Parameters.Add(cmdParameter12);
                cmd.Parameters.Add(cmdParameter13);
                cmd.Parameters.Add(cmdParameter14);
                cmd.Parameters.Add(cmdParameter15);
                cmd.Parameters.Add(cmdParameter16);
                cmd.Parameters.Add(cmdParameter17);
                cmd.Parameters.Add(cmdParameter18);
                cmd.Parameters.Add(cmdParameter19);
                cmd.Parameters.Add(cmdParameter20);
                cmd.Parameters.Add(cmdParameter21);
                cmd.Parameters.Add(cmdParameter22);
                cmd.Parameters.Add(cmdParameter23);
                cmd.Parameters.Add(cmdParameter24);
                cmd.Parameters.Add(cmdParameter25);
                cmd.Parameters.Add(cmdParameter26);
                cmd.Parameters.Add(cmdParameter27);
                cmd.Parameters.Add(cmdParameter28);
                cmd.Parameters.Add(cmdParameter29);
                cmd.Parameters.Add(cmdParameter30);
                cmd.Parameters.Add(cmdParameter31);
                cmd.Parameters.Add(cmdParameter32);
                cmd.Parameters.Add(cmdParameter33);
                cmd.Parameters.Add(cmdParameter34);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "EditRegister_Failed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "EditRegister_Discipline");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "EditRegister_RegType");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -3:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "EditRegister_RegCode2");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default://其余的为修改成功
                        int iDisciplineID = Convert.ToInt32(strDisciplineID);
                        if (module != null)
                            module.DataChangedNotify(OVRDataChangedType.emRegisterModify, iDisciplineID, -1, -1, -1, m_stRegister.iRegID, null);
                        m_bModified = true;
                        return true;
                }	
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        private bool InsertTeamUniform(int nRegisterID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Add Uniform

                SqlCommand cmd = new SqlCommand("proc_InsertTeamUniform", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter(
                             "@ShirtColorID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter(
                            "@ShortsColorID", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter(
                           "@SocksColorID", SqlDbType.Int);
                SqlParameter cmdParameter5 = new SqlParameter(
                           "@Order", SqlDbType.Int);
                SqlParameter cmdParameter6 = new SqlParameter(
                          "@Result", SqlDbType.Int);

                cmdParameter1.Value = nRegisterID;
                cmdParameter2.Value = DBNull.Value;
                cmdParameter3.Value = DBNull.Value;
                cmdParameter4.Value = DBNull.Value;
                cmdParameter5.Value = DBNull.Value;
                cmdParameter6.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameter6);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "AddMember_Team");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "AddUniform_Color");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default://其余的为修改成功
                        return true;
                }	
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        private bool DelTeamUniform(int nRegisterID, int nUniformId)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }
            try
            {
                #region DML Command Setup for Del Uniform

                SqlCommand cmd = new SqlCommand("proc_DelTeamUniform", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter(
                             "@UniformID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter(
                          "@Result", SqlDbType.Int);

                cmdParameter1.Value = nRegisterID;
                cmdParameter2.Value = nUniformId;
                cmdParameter3.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelUniform_Uniform");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelUniform_Uniform");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -3:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelUniform_Match");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default://其余的为修改成功
                        return true;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        private void UpdateTeamUniformOrder(int nUniformId, string strOrder)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Update Uniform Order
                string strSQL;
                if(strOrder.Length == 0)
                {
                    strSQL = String.Format("UPDATE TR_Uniform SET F_Order = NULL WHERE F_UniformID = {0}", nUniformId);
                }
                else
                {
                    strSQL = String.Format("UPDATE TR_Uniform SET F_Order = '{0}' WHERE F_UniformID = {1}", strOrder, nUniformId);
                }
                #endregion

                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                cmd.ExecuteNonQuery();

                m_bModified = true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void UpdateTeamUniformColor(int nUniformID, int nColorID, int nUniformIdx)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Update Uniform Color
                string strSQL;
                if (nColorID == -1)
                {
                    switch (nUniformIdx)
                    {
                        case 0:
                            strSQL = String.Format("UPDATE TR_Uniform SET F_Shirt = NULL WHERE F_UniformID = {0}", nUniformID);
                            break;
                        case 1:
                            strSQL = String.Format("UPDATE TR_Uniform SET F_Shorts = NULL WHERE F_UniformID = {0}", nUniformID);
                            break;
                        case 2:
                            strSQL = String.Format("UPDATE TR_Uniform SET F_Socks = NULL WHERE F_UniformID = {0}", nUniformID);
                            break;
                        default:
                            return;
                    }
                }
                else
                {
                    switch (nUniformIdx)
                    {
                        case 0:
                            strSQL = String.Format("UPDATE TR_Uniform SET F_Shirt = {0} WHERE F_UniformID = {1}", nColorID, nUniformID);
                            break;
                        case 1:
                            strSQL = String.Format("UPDATE TR_Uniform SET F_Shorts = {0} WHERE F_UniformID = {1}", nColorID, nUniformID);
                            break;
                        case 2:
                            strSQL = String.Format("UPDATE TR_Uniform SET F_Socks = {0} WHERE F_UniformID = {1}", nColorID, nUniformID);
                            break;
                        default:
                            return;
                    }
                }
                #endregion

                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                cmd.ExecuteNonQuery();

                m_bModified = true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        #endregion
        private void chkIsRecord_CheckedChanged(object sender, EventArgs e)
        {
            if (chkIsRecord.Checked == true)
            {
                m_iIsRecord = 1;
            }
            else
            {
                m_iIsRecord = 0;
            }
        }

    
    }
}