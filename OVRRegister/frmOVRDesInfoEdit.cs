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
    public partial class OVRDesInfoEditForm : UIForm
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

        private string m_strDesTableName;
        private string m_strDesName;

        public OVRDesInfoEditForm(string strName, string strDesTableName, string strDesName)
        {
            InitializeComponent();
            this.Name = "OVRRegisterInfo";
            m_strDesTableName = strDesTableName;
            m_strDesName = strDesName;
            Localization();
        }

        private void frmOVRDesInfoEdit_Load(object sender, EventArgs e)
        {
            InitLanguageCombBox();

            txComment.Enabled = false;
            txCode.Enabled = false;
            txType.Enabled = false;

            if(m_nOperateType == 2)
            {
                txCode.Text = m_strCode;
                txLongName.Text = m_strLongName;
                txShortName.Text = m_strShortName;
                txComment.Text = m_strComment;
                txType.Text = m_strDelegationType;
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
            txType.Text = m_strDelegationType;

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
            this.Text = LocalizationRecourceManager.GetString("OVRRegisterInfo", "InfoEditFrm");
            this.lbCode.Text = LocalizationRecourceManager.GetString("OVRRegisterInfo", "lbCode");
            this.lbLanguage.Text = LocalizationRecourceManager.GetString("OVRRegisterInfo", "lbLanguage");
            this.lbLongName.Text = LocalizationRecourceManager.GetString(this.Name, "lbLongName");
            this.lbShortName.Text = LocalizationRecourceManager.GetString(this.Name, "lbShortName");
            this.lbComment.Text = LocalizationRecourceManager.GetString(this.Name, "lbComment");
            this.lbType.Text = LocalizationRecourceManager.GetString(this.Name, "lbDelegationType");
        }

        private bool AddInfo()
        {
            bool bResult = false;
            bResult = AddDes();
            return bResult;
        }

        private bool EditInfo()
        {
            bool bResult = false;
            bResult = EditDes();
            return bResult;
        }

        private bool AddDes()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Add MF

                SqlCommand cmd = new SqlCommand("Proc_EQ_AddDes", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter( "@DesTableName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter1 = new SqlParameter( "@DesName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter2 = new SqlParameter( "@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter( "@LongName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter4 = new SqlParameter( "@ShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter( "@Comment", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter6 = new SqlParameter( "@Result", SqlDbType.Int);

                cmdParameter0.Value = m_strDesTableName;
                cmdParameter1.Value = m_strDesName;
                cmdParameter2.Value = m_strLanguageCode;
                cmdParameter3.Value = m_strLongName;
                cmdParameter4.Value = m_strShortName;
                cmdParameter5.Value = m_strComment;
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

        private bool EditDes()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Edit MF

                SqlCommand cmd = new SqlCommand("Proc_EQ_EditDes", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@DesTableName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter1 = new SqlParameter("@DesName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter2 = new SqlParameter("@ID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter4 = new SqlParameter("@LongName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter("@ShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter6 = new SqlParameter("@Comment", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter7 = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = m_strDesTableName;
                cmdParameter1.Value = m_strDesName;
                cmdParameter2.Value = m_iInfoID;
                cmdParameter3.Value = m_strLanguageCode;
                cmdParameter4.Value = m_strLongName;
                cmdParameter5.Value = m_strShortName;
                cmdParameter6.Value = m_strComment;
                cmdParameter7.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
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
                int nRetValue = (int)cmdParameter7.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "EditMF_Failed");
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

        private void FillCombox(UIComboBox cmb, SqlDataReader dr, int nValueIdx, int nKeyIdx, String strValue)
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