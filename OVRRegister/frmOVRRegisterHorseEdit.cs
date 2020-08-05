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
    public partial class RegisterHorseEditForm : UIForm
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
           public int iDelegationID;  
           public string strBirthDate;
           public decimal dcHeight;
           public decimal dcWeight;
           public string strLanguageCode;
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

           //horse属性
           public int iHorseSexID;
           public int iHorseColorID;
           public int iHorseBreedID;
           public string strHDes1;
           public string strHDes2;
           public string strHDes3;
           public string strHDes4;
           public string strHDes5;
           public string strHDes6;
        };
        public sRegisterInfo m_stRegister;


        public UpdateRegisterGrid m_dgUpdateRegisterGrid;

        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        private DataTable m_tbLanguage = new DataTable();
        private DataTable m_tbRegType = new DataTable();
        private DataTable m_tbNOC = new DataTable();
        private DataTable m_tbClub = new DataTable();
        private DataTable m_tbFederation = new DataTable();
        private DataTable m_tbDelegation = new DataTable();

        private DataTable m_tbHorseSex = new DataTable();
        private DataTable m_tbHorseColor = new DataTable();
        private DataTable m_tbHorseBreed = new DataTable();


        private bool m_bModified = false;


        public RegisterHorseEditForm(string strName)
        {
            InitializeComponent();
            this.Name = strName;

            //////////////////////////////////////////////////////////////////////////
            //Initial Language And Grid Style
            Localization();
            m_tbLanguage.Clear();
            m_tbRegType.Clear();
            m_tbNOC.Clear();
            m_tbFederation.Clear();
            m_tbClub.Clear();

            m_tbHorseSex.Clear();
            m_tbHorseColor.Clear();
            m_tbHorseBreed.Clear();
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "EditRegisterInfoFrm");
            this.lbLanguage.Text = LocalizationRecourceManager.GetString(this.Name, "lbLanguage");
            this.lbRegType.Text = LocalizationRecourceManager.GetString(this.Name, "lbRegType");
            this.lbRegCode.Text = LocalizationRecourceManager.GetString(this.Name, "lbRegCode");
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
            this.lbFederation.Text = LocalizationRecourceManager.GetString(this.Name, "lbFederation");
            this.lbClub.Text = LocalizationRecourceManager.GetString(this.Name, "lbClub");
            this.lbDelegation.Text = LocalizationRecourceManager.GetString(this.Name, "lbDelegation");
            this.lbHeight.Text = LocalizationRecourceManager.GetString(this.Name, "lbHeight");
            this.lbWeight.Text = LocalizationRecourceManager.GetString(this.Name, "lbWeight");
            this.lbBirthDate.Text = LocalizationRecourceManager.GetString(this.Name, "lbBirthDate");
            this.lbBirthCountry.Text = LocalizationRecourceManager.GetString(this.Name, "lbBirthCountry");
            this.lbBirthCity.Text = LocalizationRecourceManager.GetString(this.Name, "lbBirthCity");
            this.lbRecCountry.Text = LocalizationRecourceManager.GetString(this.Name, "lbRecCountry");
            this.lbRecCity.Text = LocalizationRecourceManager.GetString(this.Name, "lbRecCity"); 
            this.btnAutoName.Text = LocalizationRecourceManager.GetString(this.Name, "btnAutoName");
            this.btnEditComment.Text = LocalizationRecourceManager.GetString(this.Name, "btnEditComment");
            this.btnOK_Again.Text = LocalizationRecourceManager.GetString(this.Name, "btnOKAgain");

            this.lbFirstName.Text = LocalizationRecourceManager.GetString(this.Name, "lbHorseName");
            this.lbPlayerBib.Text = LocalizationRecourceManager.GetString(this.Name, "lbHorseBib");
            this.lbHorseSex.Text = LocalizationRecourceManager.GetString(this.Name, "lbSex");
            this.lbHorseColor.Text = LocalizationRecourceManager.GetString(this.Name, "lbHorseColor");
            this.lbHorseBreed.Text = LocalizationRecourceManager.GetString(this.Name, "lbHorseBreed");
            this.lbHDes1.Text = LocalizationRecourceManager.GetString(this.Name, "lbHDes1");
            this.lbHDes2.Text = LocalizationRecourceManager.GetString(this.Name, "lbHDes2");
            this.lbHDes3.Text = LocalizationRecourceManager.GetString(this.Name, "lbHDes3");
            this.lbHDes4.Text = LocalizationRecourceManager.GetString(this.Name, "lbHDes4");
            this.lbHDes5.Text = LocalizationRecourceManager.GetString(this.Name, "lbHDes5");
            this.lbHDes6.Text = LocalizationRecourceManager.GetString(this.Name, "lbHDes6");


        }

        public OVRModuleBase module = null;
      
	    public string    m_strRegID = "";
        public string    m_strRegCode = "";
	    public string    m_strLanguageCode = "";
	    public string    m_strRegTypeID  = "";
        public string    m_strNOCCode = "";
        public string    m_strFederationID  = "";
        public string    m_strClubID  = "";
        public string    m_strDelegationID = "";
        public string    m_strBirthCountry = "";
        public string    m_strRecCountry = "";
        public int       m_iNewRegisterID = 0;
        public int       m_iGroupType = 0;

        public string m_strHorseSexID = "";
        public string m_strHorseColorID = "";
        public string m_strHorseBreedID = "";

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

        private void frmRegisterEdit_Load(object sender, EventArgs e)
        {
            OVRDataBaseUtils.GetActiveInfo(this.sqlConnection, out m_iActiveSportID, out m_iAtciveDesciplineID, out m_strActiveLanguageCode);

            m_iDBGroupType = GetGroupType();

            //为队或组合添加队员或非运动员 或者修改队员

            if (m_stDlgParam.bEditCompetitorDlg)
            {
                InitRegInfo(m_strRegID);
            }

            //增加马,修改马信息

            if (m_stDlgParam.bAddHorseDlg || m_stDlgParam.bEditCompetitorDlg)
            {
                if (!m_stDlgParam.bEditCompetitorDlg)
                {
                    btnOK_Again.Visible = true;
                    m_strRegTypeID = m_strOrgRegTypeID;
                    m_strFederationID = m_strOrgFederationID;
                    m_strLanguageCode = m_strOrgLanguageCode;
                    m_strClubID = m_strOrgClubID;
                    m_strNOCCode = m_strOrgNOCCode;
                    m_strDelegationID = m_strOrgDelegationID;
                }
            }

   
            btnEditComment.Enabled = true;
            cmbRegType.Enabled = false;
            InitCombox();

            ///////////////////////////////////////////
            //修改运动员信息或修改队伍信息，不需要根据Delegation添加NOC
            if (!m_stDlgParam.bEditCompetitorDlg)
            {
                SetNOCByDelegation();
            }
            
        }
        
        private void RegisterHorseEditForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (m_bModified)
                this.DialogResult = DialogResult.OK;
        }

        protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
        {
            if (keyData == (Keys.Alt | Keys.A))
            {
                btnOKAgain_Click(null, null);

                return true;
            }

            return base.ProcessCmdKey(ref msg, keyData);
        }


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
                        m_strNOCCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_NOC");
                        m_strRegTypeID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_RegTypeID");
                        m_strFederationID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_FederationID");
                        m_strClubID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ClubID");
                        txHeight.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Height");
                        txWeight.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Weight");
                        dtBirthDate.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Birth_Date");
                        m_strDelegationID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DelegationID");
                        
                        txtBirthCity.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Birth_City");
                        m_strBirthCountry = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Birth_Country");
                        txtRecCity.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Residence_City");
                        m_strRecCountry = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Residence_Country");

                        m_strHorseSexID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_HorseSexID");
                        m_strHorseColorID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_HorseColorID");
                        m_strHorseBreedID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_HorseBreedID");

                        txtHDes1.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_HDes1");
                        txtHDes2.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_HDes2");
                        txtHDes3.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_HDes3");
                        txtHDes4.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_HDes4");
                        txtHDes5.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_HDes5");
                        txtHDes6.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_HDes6");





                    }
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void CleanAllContext()
        {
             m_strRegID = "";
             txFirstName.Text = "";
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
             txHeight.Text = "";
             txWeight.Text = "";
             dtBirthDate.Text = "";
             txRegCode.Text = "";
             txBib.Text = "";
             txtBirthCity.Text = "";
             txtRecCity.Text = "";
             cmbBirthCountry.SelectedIndex = -1;
             cmbRecCountry.SelectedIndex = -1;

             txtHDes1.Text = "";
             txtHDes2.Text = "";
             txtHDes3.Text = "";
             txtHDes4.Text = "";
             txtHDes5.Text = "";
             txtHDes6.Text = "";

        }

        private void GetComboxValue()
        {
            m_strRegTypeID = cmbRegType.SelectedValue.ToString();
            m_strHorseSexID = cmbHorseSex.SelectedValue.ToString();

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

            //horse
            if (cmbHorseSex.SelectedValue == null || Convert.ToInt32(cmbHorseSex.SelectedValue) == -1)
            {
                m_strHorseSexID = "0";
            }
            else
            {
                m_strHorseSexID = cmbHorseSex.SelectedValue.ToString();
            }

            if (cmbHorseColor.SelectedValue == null || Convert.ToInt32(cmbHorseColor.SelectedValue) == -1)
            {
                m_strHorseColorID = "0";
            }
            else
            {
                m_strHorseColorID = cmbHorseColor.SelectedValue.ToString();
            }

            if (cmbHorseBreed.SelectedValue == null || Convert.ToInt32(cmbHorseBreed.SelectedValue) == -1)
            {
                m_strHorseBreedID = "0";
            }
            else
            {
                m_strHorseBreedID = cmbHorseBreed.SelectedValue.ToString();
            }
        }


        private void AutoName()
        {
            string strLongName = txFirstName.Text;
            string strShortName = txFirstName.Text;
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

            if (cmbHorseSex.SelectedIndex < 0)
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
            m_stRegister.iDelegationID = Convert.ToInt32(m_strDelegationID);
            m_stRegister.strBirthDate = dtBirthDate.Text.ToString();

            m_stRegister.iHorseSexID = Convert.ToInt32(m_strHorseSexID);
            m_stRegister.iHorseColorID = Convert.ToInt32(m_strHorseColorID);
            m_stRegister.iHorseBreedID = Convert.ToInt32(m_strHorseBreedID);

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
            m_stRegister.strFirstName = txFirstName.Text.ToString();
            m_stRegister.strLastName = "";
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

            m_stRegister.strHDes1 = txtHDes1.Text.ToString();
            m_stRegister.strHDes2 = txtHDes2.Text.ToString();
            m_stRegister.strHDes3 = txtHDes3.Text.ToString();
            m_stRegister.strHDes4 = txtHDes4.Text.ToString();
            m_stRegister.strHDes5 = txtHDes5.Text.ToString();
            m_stRegister.strHDes6 = txtHDes6.Text.ToString();

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
                SqlCommand cmd = new SqlCommand("Proc_EQ_GetHorseColorInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter Parameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar);
                Parameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(Parameter1);

                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                DataTable table = new DataTable();
                table.Columns.Add("F_HorseColorLongName", typeof(string));
                table.Columns.Add("F_HorseColorID", typeof(int));
                table.Rows.Add("", "-1");
                table.Load(dr);

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
            InitRegTypeCombox();
            InitNOCCombox();
            InitFederationCombox();
            InitClubCombox();
            InitDelegationCombox();

            InitHorseSexCombox();
            InitHorseColorCombox();
            InitHorseBreedCombox();
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

        private void InitHorseSexCombox()
        {
            m_tbHorseSex.Clear();
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_EQ_GetHorseSexInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);

                SqlDataReader dr = cmd.ExecuteReader();
                m_tbHorseSex.Load(dr);
                dr.Close();

                cmbHorseSex.DisplayMember = "F_Name";
                cmbHorseSex.ValueMember = "F_Key";
                cmbHorseSex.DataSource = m_tbHorseSex;
                if (m_strHorseSexID.Length != 0)
                    cmbHorseSex.SelectedValue = m_strHorseSexID;
                else
                    cmbHorseSex.SelectedIndex = -1;
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

        private void InitHorseColorCombox()
        {
            m_tbHorseColor.Clear();
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_EQ_GetHorseColorInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);

                SqlDataReader dr = cmd.ExecuteReader();
                m_tbHorseColor.Load(dr);
                dr.Close();

                cmbHorseColor.DisplayMember = "F_Name";
                cmbHorseColor.ValueMember = "F_Key";
                cmbHorseColor.DataSource = m_tbHorseColor;

                if (m_strHorseColorID.Length != 0)
                    cmbHorseColor.SelectedValue = m_strHorseColorID;
                else
                    cmbHorseColor.SelectedIndex = -1;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void InitHorseBreedCombox()
        {
             m_tbHorseBreed.Clear();
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_EQ_GetHorseBreedInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);

                SqlDataReader dr = cmd.ExecuteReader();
                m_tbHorseBreed.Load(dr);
                dr.Close();

                cmbHorseBreed.DisplayMember = "F_Name";
                cmbHorseBreed.ValueMember = "F_Key";
                cmbHorseBreed.DataSource = m_tbHorseBreed;

                if (m_strHorseBreedID.Length != 0)
                    cmbHorseBreed.SelectedValue = m_strHorseBreedID;
                else
                    cmbHorseBreed.SelectedIndex = -1;
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
	        if(m_stDlgParam.bAddHorseDlg)
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

            if (m_stDlgParam.bEditCompetitorDlg)   //为队或组合添加队员或非运动员 或者修改队员


            {
                InitRegInfo(m_strRegID);

            }
            InitHorseSexCombox();
            InitRegTypeCombox();
            InitHorseBreedCombox();
            InitClubCombox();
            InitNOCCombox();
            InitFederationCombox();
            InitDelegationCombox();
        }

        private void btnAutoName_Click(object sender, EventArgs e)
        {
            AutoName();
        }

        private void btnHorseBreed_Click(object sender, EventArgs e)
        {
            string strOrgHorseBreedID = "";
            if(cmbHorseBreed.SelectedIndex >= 0)
            {
               strOrgHorseBreedID = cmbHorseBreed.SelectedValue.ToString();
            }

            OVRDesInfoListForm frmOVRDesInfoList = new OVRDesInfoListForm(this.Name,"TC_HorseBreed","HorseBreed");
            frmOVRDesInfoList.DatabaseConnection = DatabaseConnection;
            frmOVRDesInfoList.m_strLanguageCode = m_strLanguageCode;
            frmOVRDesInfoList.ShowDialog();

            InitHorseBreedCombox();

            if (strOrgHorseBreedID.Length == 0)
            {
                cmbHorseBreed.SelectedIndex = -1;
            }
            else
            {
                cmbHorseBreed.SelectedValue = strOrgHorseBreedID;
            }
        }

        private void btnClub_Click(object sender, EventArgs e)
        {
            string strOrgClubID = "";
            if (cmbClub.SelectedIndex >= 0)
            {
                strOrgClubID = cmbClub.SelectedValue.ToString();
            }

            OVRClubNationListForm frmOvrClubNationList = new OVRClubNationListForm(this.Name);
            frmOvrClubNationList.DatabaseConnection = DatabaseConnection;
            frmOvrClubNationList.m_emInfoType = EMInfoType.emClub;
            frmOvrClubNationList.m_strLanguageCode = m_strLanguageCode;
            frmOvrClubNationList.ShowDialog();

            InitClubCombox();

            if (strOrgClubID.Length == 0)
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
            if (cmbNOC.SelectedIndex >= 0)
            {
                strOrgNOC = cmbNOC.SelectedValue.ToString();
            }

            OVRClubNationListForm frmOvrClubNationList = new OVRClubNationListForm(this.Name);
            frmOvrClubNationList.DatabaseConnection = DatabaseConnection;
            frmOvrClubNationList.m_emInfoType = EMInfoType.emNOC;
            frmOvrClubNationList.m_strLanguageCode = m_strLanguageCode;
            frmOvrClubNationList.ShowDialog();

            InitNOCCombox();

            if (strOrgNOC.Length == 0)
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
            if (m_stDlgParam.bAddHorseDlg)   //如果是新建


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
                SqlCommand cmd = new SqlCommand("Proc_EQ_AddHorse", sqlConnection);
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

                //horse
                SqlParameter cmdParameter35 = new SqlParameter("@HorseSexID", SqlDbType.Int);
                SqlParameter cmdParameter36 = new SqlParameter("@HorseColorID", SqlDbType.Int);
                SqlParameter cmdParameter37 = new SqlParameter("@HorseBreedID", SqlDbType.Int);
                SqlParameter cmdParameter38 = new SqlParameter("@HDes1", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter39 = new SqlParameter("@HDes2", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter40 = new SqlParameter("@HDes3", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter41 = new SqlParameter("@HDes4", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter42 = new SqlParameter("@HDes5", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter43 = new SqlParameter("@HDes6", SqlDbType.NVarChar, 50);

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

                if (m_stRegister.strBirthDate.Length == 0)
                {
                    cmdParameter8.Value = DBNull.Value;
                }
                else
                    cmdParameter8.Value = Convert.ToDateTime(m_stRegister.strBirthDate);

                cmdParameter9.Value = m_stRegister.dcHeight;
                cmdParameter10.Value = m_stRegister.dcWeight;

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

                //horse
                cmdParameter7.Value = DBNull.Value;
                cmdParameter11.Value = DBNull.Value;
                cmdParameter26.Value = DBNull.Value;
                cmdParameter27.Value = DBNull.Value;

                if (m_stRegister.iHorseSexID == 0)
                {
                    cmdParameter35.Value = DBNull.Value;
                }
                else
                    cmdParameter35.Value = m_stRegister.iHorseSexID;

                if (m_stRegister.iHorseColorID == 0)
                {
                    cmdParameter36.Value = DBNull.Value;
                }
                else
                    cmdParameter36.Value = m_stRegister.iHorseColorID;

                if (m_stRegister.iHorseBreedID == 0)
                {
                    cmdParameter37.Value = DBNull.Value;
                }
                else
                    cmdParameter37.Value = m_stRegister.iHorseBreedID;

                cmdParameter38.Value = m_stRegister.strHDes1;
                cmdParameter39.Value = m_stRegister.strHDes2;
                cmdParameter40.Value = m_stRegister.strHDes3;
                cmdParameter41.Value = m_stRegister.strHDes4;
                cmdParameter42.Value = m_stRegister.strHDes5;
                cmdParameter43.Value = m_stRegister.strHDes6;

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
                cmd.Parameters.Add(cmdParameter35);
                cmd.Parameters.Add(cmdParameter36);
                cmd.Parameters.Add(cmdParameter37);
                cmd.Parameters.Add(cmdParameter38);
                cmd.Parameters.Add(cmdParameter39);
                cmd.Parameters.Add(cmdParameter40);
                cmd.Parameters.Add(cmdParameter41);
                cmd.Parameters.Add(cmdParameter42);
                cmd.Parameters.Add(cmdParameter43);
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

                SqlCommand cmd = new SqlCommand("Proc_EQ_EditHorse", sqlConnection);
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

                //horse
                SqlParameter cmdParameter35 = new SqlParameter("@HorseSexID", SqlDbType.Int);
                SqlParameter cmdParameter36 = new SqlParameter("@HorseColorID", SqlDbType.Int);
                SqlParameter cmdParameter37 = new SqlParameter("@HorseBreedID", SqlDbType.Int);
                SqlParameter cmdParameter38 = new SqlParameter("@HDes1", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter39 = new SqlParameter("@HDes2", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter40 = new SqlParameter("@HDes3", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter41 = new SqlParameter("@HDes4", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter42 = new SqlParameter("@HDes5", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter43 = new SqlParameter("@HDes6", SqlDbType.NVarChar, 50);

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

                if (m_stRegister.strBirthDate.Length == 0)
                {
                    cmdParameter8.Value = DBNull.Value;
                }
                else
                    cmdParameter8.Value = Convert.ToDateTime(m_stRegister.strBirthDate);

                cmdParameter9.Value = m_stRegister.dcHeight;
                cmdParameter10.Value = m_stRegister.dcWeight;

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

                //horse
                cmdParameter7.Value = DBNull.Value;
                cmdParameter11.Value = DBNull.Value;
                cmdParameter26.Value = DBNull.Value;
                cmdParameter27.Value = DBNull.Value;

                if (m_stRegister.iHorseSexID == 0)
                {
                    cmdParameter35.Value = DBNull.Value;
                }
                else
                    cmdParameter35.Value = m_stRegister.iHorseSexID;

                if (m_stRegister.iHorseColorID == 0)
                {
                    cmdParameter36.Value = DBNull.Value;
                }
                else
                    cmdParameter36.Value = m_stRegister.iHorseColorID;

                if (m_stRegister.iHorseBreedID == 0)
                {
                    cmdParameter37.Value = DBNull.Value;
                }
                else
                    cmdParameter37.Value = m_stRegister.iHorseBreedID;

                cmdParameter38.Value = m_stRegister.strHDes1;
                cmdParameter39.Value = m_stRegister.strHDes2;
                cmdParameter40.Value = m_stRegister.strHDes3;
                cmdParameter41.Value = m_stRegister.strHDes4;
                cmdParameter42.Value = m_stRegister.strHDes5;
                cmdParameter43.Value = m_stRegister.strHDes6;

                cmdParameter23.Direction = ParameterDirection.Output;

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
                cmd.Parameters.Add(cmdParameter35);
                cmd.Parameters.Add(cmdParameter36);
                cmd.Parameters.Add(cmdParameter37);
                cmd.Parameters.Add(cmdParameter38);
                cmd.Parameters.Add(cmdParameter39);
                cmd.Parameters.Add(cmdParameter40);
                cmd.Parameters.Add(cmdParameter41);
                cmd.Parameters.Add(cmdParameter42);
                cmd.Parameters.Add(cmdParameter43);

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


        #endregion

        private void btnHorseColor_Click(object sender, EventArgs e)
        {
            string strOrgHorseColorID = "";
            if (cmbHorseColor.SelectedIndex >= 0)
            {
                strOrgHorseColorID = cmbHorseColor.SelectedValue.ToString();
            }

            OVRDesInfoListForm frmOVRDesInfoList = new OVRDesInfoListForm(this.Name, "TC_HorseColor", "HorseColor");
            frmOVRDesInfoList.DatabaseConnection = DatabaseConnection;
            frmOVRDesInfoList.m_strLanguageCode = m_strLanguageCode;
            frmOVRDesInfoList.ShowDialog();

            InitHorseColorCombox();

            if (strOrgHorseColorID.Length == 0)
            {
                cmbHorseColor.SelectedIndex = -1;
            }
            else
            {
                cmbHorseColor.SelectedValue = strOrgHorseColorID;
            }
        }


    
    }
}