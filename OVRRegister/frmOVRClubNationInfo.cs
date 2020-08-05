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
using Sunny.UI;

namespace AutoSports.OVRRegister
{
    public partial class OVRClubNationInfoForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public int m_nOperateType = 0;//0,未指定;1,添加;2,修改

        public EMInfoType m_emInfoType = EMInfoType.emUnKnown;
        public int m_iInfoID = -1;
        public string m_strLongName = "";
        public string m_strShortName = "";
        public string m_strLanguageCode = "";
        public string m_strCode = "";
        public string m_strComment = "";
        public string m_strDelegationType = "";

        public OVRClubNationInfoForm(string strName)
        {
            InitializeComponent();
            this.Name = strName;
            Localization();
        }

        private void frmOVRClubNationInfo_Load(object sender, EventArgs e)
        {
            InitLanguageCombBox();

            if (m_emInfoType == EMInfoType.emNation || m_emInfoType == EMInfoType.emColor)
            {
                txComment.Enabled = true;
                txCode.Enabled = false;
                txType.Enabled = false;
            }
            else if (m_emInfoType == EMInfoType.emClub)
            {
                txComment.Enabled = false;
                txCode.Enabled = true;
                txType.Enabled = false;
            }
            else if (m_emInfoType == EMInfoType.emNOC)
            {
                txCode.Enabled = true;
                txComment.Enabled = false;
                txType.Enabled = false;
            }
            else if (m_emInfoType == EMInfoType.emFederation)
            {
                txCode.Enabled = true;
                txComment.Enabled = true;
                txType.Enabled = false;
            }

            if(m_nOperateType == 2)
            {
                txCode.Text = m_strCode;
                txLongName.Text = m_strLongName;
                txShortName.Text = m_strShortName;
                txComment.Text = m_strComment;
                txType.Text = m_strDelegationType;

                if (m_emInfoType == EMInfoType.emNOC)
                {
                    txCode.Enabled = false;
                }
            }
        }

        private void cmbLanguage_SelectionChangeCommitted(object sender, EventArgs e)
        {
            if(cmbLanguage.SelectedIndex < 0)
            {
                return;
            }

            int nSelIdx = cmbLanguage.SelectedIndex;
            m_strLanguageCode = ((OVRCustomComboBoxItem)cmbLanguage.Items[nSelIdx]).Value.ToString();
           
            if(m_nOperateType == 2)
            {
               if(m_emInfoType == EMInfoType.emNation)
               {
                   GetNationInfo();
               }
               else if(m_emInfoType == EMInfoType.emClub)
               {
                   GetClubInfo();
               }
               else if(m_emInfoType == EMInfoType.emColor)
               {
                   GetColorInfo();
               }
               else if(m_emInfoType == EMInfoType.emDelegation)
               {
                   GetDelegationInfo();
               }
               else if(m_emInfoType == EMInfoType.emFederation)
               {
                   GetFederationInfo();
               }
               else if(m_emInfoType == EMInfoType.emNOC)
               {
                   GetNOCInfo();
               }

               txCode.Text = m_strCode;
               txLongName.Text = m_strLongName;
               txShortName.Text = m_strShortName;
               txComment.Text = m_strComment;
               txType.Text = m_strDelegationType;
            }
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            if(cmbLanguage.SelectedIndex < 0)
            {
                string strPromotion = LocalizationRecourceManager.GetString(this.Name, "LanguageMsgBox");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }

            m_strCode = txCode.Text;
            m_strLongName = txLongName.Text;
            m_strShortName = txShortName.Text;
            m_strComment = txComment.Text;
            m_strDelegationType = txType.Text;

            int nSelIdx = cmbLanguage.SelectedIndex;
            m_strLanguageCode = ((OVRCustomComboBoxItem)cmbLanguage.Items[nSelIdx]).Value.ToString();

            switch (m_nOperateType)
            {
                case 1:
                    if (!AddInfo()) return;
                    break;
                case 2:
                    if (!EditInfo()) return;
                    break;
                default:
                   break;
            }

            this.DialogResult = DialogResult.OK;
            return;
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "InfoEditFrm");
            this.lbCode.Text = LocalizationRecourceManager.GetString(this.Name, "lbCode");
            this.lbLanguage.Text = LocalizationRecourceManager.GetString(this.Name, "lbLanguage");
            this.lbLongName.Text = LocalizationRecourceManager.GetString(this.Name, "lbLongName");
            this.lbShortName.Text = LocalizationRecourceManager.GetString(this.Name, "lbShortName");
            this.lbComment.Text = LocalizationRecourceManager.GetString(this.Name, "lbComment");
            this.lbType.Text = LocalizationRecourceManager.GetString(this.Name, "lbDelegationType");
            this.btnOK.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnOK");
            this.btnCancel.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnCancel");
        }

        private bool AddInfo()
        {
            bool bResult = false;

            switch (Convert.ToInt32(m_emInfoType))
            {
                case 0:
                    bResult = AddNation();
                    break;
                case 1:
                    bResult = AddClub();
                    break;
                case 2:
                    bResult = AddColor();
                    break;
                case 3:
                    bResult = AddFederation();
                    break;
                case 4:
                    bResult = AddNOC();
                    break;
                case 5:
                    bResult = AddDelegation();
                    break;
                default:
                    break;
            }
            return bResult;
        }

        private bool EditInfo()
        {
            bool bResult = false;

            switch (Convert.ToInt32(m_emInfoType))
            {
                case 0:
                    bResult = EditNation();
                    break;
                case 1:
                    bResult = EditClub();
                    break;
                case 2:
                    bResult = EditColor();
                    break;
                case 3:
                    bResult = EditFederation();
                    break;
                case 4:
                    bResult = EditNOC();
                    break;
                case 5:
                    bResult = EditDelegation();
                    break;
                default:
                    break;
            }
            return bResult;
        }

        private void GetClubInfo()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get ClubInfo

                SqlCommand cmd = new SqlCommand("Proc_GetClubByID", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@ClubID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter1.Value = m_iInfoID;
                cmdParameter2.Value = m_strLanguageCode;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                if(dr.HasRows)
                {
                    while(dr.Read())
                    {
                        m_strCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ClubCode");
                        m_strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ClubLongName");
                        m_strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ClubShortName");
                        m_strComment = "";
                        m_strDelegationType = "";
                    }
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private bool AddClub()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Add Club

                SqlCommand cmd = new SqlCommand("proc_AddClub", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter( "@ClubCode", SqlDbType.NVarChar,10);
                SqlParameter cmdParameter2 = new SqlParameter( "@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter( "@ClubLongName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter4 = new SqlParameter( "@ClubShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter( "@Result", SqlDbType.Int);

                cmdParameter1.Value = m_strCode;
                cmdParameter2.Value = m_strLanguageCode;
                cmdParameter3.Value = m_strLongName;
                cmdParameter4.Value = m_strShortName;
                cmdParameter5.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter5.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
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

        private bool EditClub()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Edit Club

                SqlCommand cmd = new SqlCommand("Proc_EditClub", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@ClubID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@ClubCode", SqlDbType.NVarChar, 10);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@ClubLongName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter4 = new SqlParameter("@ClubShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = m_iInfoID;
                cmdParameter1.Value = m_strCode;
                cmdParameter2.Value = m_strLanguageCode;
                cmdParameter3.Value = m_strLongName;
                cmdParameter4.Value = m_strShortName;
                cmdParameter5.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter5.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "EditClub_Failed");
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

        private void GetNationInfo()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get NationInfo

                SqlCommand cmd = new SqlCommand("Proc_GetNationByID", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@NationID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter1.Value = m_iInfoID;
                cmdParameter2.Value = m_strLanguageCode;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        m_strCode = "";
                        m_strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_NationLongName");
                        m_strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_NationShortName");
                        m_strComment = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_NationComment");
                        m_strDelegationType = "";
                    }
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private bool AddNation()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Add Nation

                SqlCommand cmd = new SqlCommand("proc_AddNation", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@NationComment", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@NationLongName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter4 = new SqlParameter("@NationShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter1.Value = m_strComment;
                cmdParameter2.Value = m_strLanguageCode;
                cmdParameter3.Value = m_strLongName;
                cmdParameter4.Value = m_strShortName;
                cmdParameter5.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter5.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
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

        private bool EditNation()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Edit Nation

                SqlCommand cmd = new SqlCommand("Proc_EditNation", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@NationID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@NationComment", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@NationLongName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter4 = new SqlParameter("@NationShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = m_iInfoID;
                cmdParameter1.Value = m_strComment;
                cmdParameter2.Value = m_strLanguageCode;
                cmdParameter3.Value = m_strLongName;
                cmdParameter4.Value = m_strShortName;
                cmdParameter5.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter5.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "EditNation_Failed");
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

        private void GetColorInfo()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get ColorInfo

                SqlCommand cmd = new SqlCommand("Proc_GetColorByID", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@ColorID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter1.Value = m_iInfoID;
                cmdParameter2.Value = m_strLanguageCode;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        m_strCode = "";
                        m_strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ColorLongName");
                        m_strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ColorShortName");
                        m_strComment = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_ColorComment");
                        m_strDelegationType = "";
                    }
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private bool AddColor()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
               #region DML Command Setup for Add Color

                SqlCommand cmd = new SqlCommand("proc_AddColor", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@ColorComment", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@ColorLongName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter4 = new SqlParameter("@ColorShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter1.Value = m_strComment;
                cmdParameter2.Value = m_strLanguageCode;
                cmdParameter3.Value = m_strLongName;
                cmdParameter4.Value = m_strShortName;
                cmdParameter5.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter5.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
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

        private bool EditColor()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Edit Color

                SqlCommand cmd = new SqlCommand("Proc_EditColor", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@ColorID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@ColorComment", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@ColorLongName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter4 = new SqlParameter("@ColorShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = m_iInfoID;
                cmdParameter1.Value = m_strComment;
                cmdParameter2.Value = m_strLanguageCode;
                cmdParameter3.Value = m_strLongName;
                cmdParameter4.Value = m_strShortName;
                cmdParameter5.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter5.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "EditColor_Failed");
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

        private void GetFederationInfo()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get FederationInfo

                SqlCommand cmd = new SqlCommand("Proc_GetFederationByID", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@FederationID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter1.Value = m_iInfoID;
                cmdParameter2.Value = m_strLanguageCode;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        m_strCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_FederationCode");
                        m_strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_FederationLongName");
                        m_strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_FederationShortName");
                        m_strComment = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_FederationComment");
                        m_strDelegationType = "";
                    }
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private bool AddFederation()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Add Federation

                SqlCommand cmd = new SqlCommand("proc_AddFederation", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@FederationCode", SqlDbType.NVarChar, 10);
                SqlParameter cmdParameter1 = new SqlParameter("@FederationComment", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@FederationLongName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter4 = new SqlParameter("@FederationShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = m_strCode;
                cmdParameter1.Value = m_strComment;
                cmdParameter2.Value = m_strLanguageCode;
                cmdParameter3.Value = m_strLongName;
                cmdParameter4.Value = m_strShortName;
                cmdParameter5.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter5.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "AddFederation_Code");
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

        private bool EditFederation()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Edit Federation
                SqlCommand cmd = new SqlCommand("proc_EditFederation", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@FederationID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@FederationCode", SqlDbType.NVarChar, 10);
                SqlParameter cmdParameter2 = new SqlParameter("@FederationComment", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter3 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter4 = new SqlParameter("@FederationLongName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter("@FederationShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter6 = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = m_iInfoID;
                cmdParameter1.Value = m_strCode;
                cmdParameter2.Value = m_strComment;
                cmdParameter3.Value = m_strLanguageCode;
                cmdParameter4.Value = m_strLongName;
                cmdParameter5.Value = m_strShortName;
                cmdParameter6.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameter6);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter6.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "EditFederation_Failed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "AddFederation_Code");
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

        private void GetNOCInfo()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get NOCInfo

                SqlCommand cmd = new SqlCommand("Proc_GetNOCByID", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@NOC", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter1.Value = m_strCode;
                cmdParameter2.Value = m_strLanguageCode;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        m_strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_CountryLongName");
                        m_strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_CountryShortName");
                        m_strComment = "";
                        m_strDelegationType = "";
                    }
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private bool AddNOC()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Add Color

                SqlCommand cmd = new SqlCommand("proc_AddCountry", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@NOC", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@CountryLongName", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter4 = new SqlParameter("@CountryShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter1.Value = m_strCode;
                cmdParameter2.Value = m_strLanguageCode;
                cmdParameter3.Value = m_strLongName;
                cmdParameter4.Value = m_strShortName;
                cmdParameter5.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter5.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
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

        private bool EditNOC()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Edit Country

                SqlCommand cmd = new SqlCommand("Proc_EditCountry", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@NOC", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@CountryLongName", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter4 = new SqlParameter("@CountryShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter1.Value = m_strCode;
                cmdParameter2.Value = m_strLanguageCode;
                cmdParameter3.Value = m_strLongName;
                cmdParameter4.Value = m_strShortName;
                cmdParameter5.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter5.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
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

        private void GetDelegationInfo()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get DelegationInfo

                SqlCommand cmd = new SqlCommand("Proc_GetDelegationByID", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@DelegationID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter1.Value = m_iInfoID;
                cmdParameter2.Value = m_strLanguageCode;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        m_strCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DelegationCode");
                        m_strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DelegationLongName");
                        m_strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DelegationShortName");
                        m_strComment = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DelegationComment");
                        m_strDelegationType = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DelegationType");
                    }
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private bool AddDelegation()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Add Delegation

                SqlCommand cmd = new SqlCommand("proc_AddDelegation", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@DelegationCode", SqlDbType.NVarChar, 10);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@DelegationLongName", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter4 = new SqlParameter("@DelegationShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter("@DelegationComment", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter6 = new SqlParameter("@DelegationType", SqlDbType.NVarChar, 10);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter1.Value = m_strCode;
                cmdParameter2.Value = m_strLanguageCode;
                cmdParameter3.Value = m_strLongName;
                cmdParameter4.Value = m_strShortName;
                cmdParameter5.Value = m_strComment;
                cmdParameter6.Value = m_strDelegationType;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameter6);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameterResult.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
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

        private bool EditDelegation()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Edit Delegation

                SqlCommand cmd = new SqlCommand("Proc_EditDelegation", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@DelegationID", SqlDbType.Int); 
                SqlParameter cmdParameter2 = new SqlParameter("@DelegationCode", SqlDbType.NVarChar, 10);
                SqlParameter cmdParameter3 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter4 = new SqlParameter("@DelegationLongName", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter5 = new SqlParameter("@DelegationShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter6 = new SqlParameter("@DelegationComment", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter7 = new SqlParameter("@DelegationType", SqlDbType.NVarChar, 10);
                SqlParameter cmdParameterResult= new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter1.Value = m_iInfoID;
                cmdParameter2.Value = m_strCode;
                cmdParameter3.Value = m_strLanguageCode;
                cmdParameter4.Value = m_strLongName;
                cmdParameter5.Value = m_strShortName;
                cmdParameter6.Value = m_strComment;
                cmdParameter7.Value = m_strDelegationType;
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameter6);
                cmd.Parameters.Add(cmdParameter7);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameterResult.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
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

        private void InitLanguageCombBox()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for lbLanguage Combo
                string strSQL = "SELECT F_LanguageDescription,F_LanguageCode FROM TC_Language Order By F_Order";
                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                FillCombox(cmbLanguage, dr, 0, 1, m_strLanguageCode);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
           
        }

        private void FillCombox(ComboBox cmb, SqlDataReader dr, int nValueIdx, int nKeyIdx, String strValue)
        {
            cmb.Items.Clear();

            if (nValueIdx > dr.FieldCount || nValueIdx < 0
                || nKeyIdx > dr.FieldCount || nKeyIdx < 0)
                return;

            int nSelItemIdx = -1;
            int nItemIdx = 0;
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    cmb.Items.Add(new OVRCustomComboBoxItem(dr[nKeyIdx].ToString(), dr[nValueIdx].ToString()));

                    if (dr[nKeyIdx].ToString().CompareTo(m_strLanguageCode) == 0)
                    {
                        nSelItemIdx = nItemIdx;
                    }
                    nItemIdx++;
                }
                cmb.DisplayMember = "Tag";
                cmb.ValueMember = "Value";
                cmb.SelectedIndex = nSelItemIdx;
            }
        }
    }
}