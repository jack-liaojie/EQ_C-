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

namespace AutoSports.OVREQPlugin
{
    public partial class OVRDesInfoEditForm : UIForm
    {
        #region Property
        private SqlConnection m_dbConnect;
        public SqlConnection DBConnect
        {
            get { return m_dbConnect; }
            set { m_dbConnect = value; }
        }

        private int m_iOperateType = 0;//0,未指定;1,添加;2,修改
        public int OperateType
        {
            get { return m_iOperateType; }
            set { m_iOperateType = value; }
        }

        public EMInfoType m_emInfoType = EMInfoType.emUnKnown;

        private int m_iInfoID = -1;
        public int InfoID
        {
            get { return m_iInfoID; }
            set { m_iInfoID = value; }
        }

        private string m_strLongName = "";
        public string LongName
        {
            get { return m_strLongName; }
            set { m_strLongName = value; }
        }

        private string m_strShortName = "";
        public string ShortName
        {
            get { return m_strShortName; }
            set { m_strShortName = value; }
        }

        private string m_strLanguageCode = "";
        public string LanguageCode
        {
            get { return m_strLanguageCode; }
            set { m_strLanguageCode = value; }
        }

        private string m_strCode = "";

        private string m_strComment = "";
        public string Comment
        {
            get { return m_strComment; }
            set { m_strComment = value; }
        }

        private int m_iMatchConfigID;
        public int MatchConfigID
        {
            get { return m_iMatchConfigID; }
            set { m_iMatchConfigID = value; }
        }
        #endregion

        #region Constructor
        public OVRDesInfoEditForm(string strName)
        {
            InitializeComponent();
            this.Name = "OVRRegisterInfo";
            Localization();
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
        #endregion

        #region FormLoad
        private void frmOVRDesInfoEdit_Load(object sender, EventArgs e)
        {
            InitLanguageCombBox();

            if (m_emInfoType == EMInfoType.emMF)
            {
                txComment.Enabled = false;
                txCode.Enabled = false;
                txType.Enabled = false;
            }

            if(m_iOperateType == 2)
            {
                txCode.Text = m_strCode;
                txLongName.Text = m_strLongName;
                txShortName.Text = m_strShortName;
                txComment.Text = m_strComment;
            }
        }

        private void InitLanguageCombBox()
        {
            if (m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for lbLanguage Combo
                string strSQL = "SELECT F_LanguageDescription,F_LanguageCode FROM TC_Language Order By F_Order";
                SqlCommand cmd = new SqlCommand(strSQL, m_dbConnect);
                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                GVAR.FillCombox(cmbLanguage, dr, 0, 1, m_strLanguageCode);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

        }
        #endregion

        #region EventHandler
        private void cmbLanguage_SelectionChangeCommitted(object sender, EventArgs e)
        {
            if(cmbLanguage.SelectedIndex < 0)
            {
                return;
            }

            int nSelIdx = cmbLanguage.SelectedIndex;
            m_strLanguageCode = ((OVRCustomComboBoxItem)cmbLanguage.Items[nSelIdx]).Value.ToString();
           
            if(m_iOperateType == 2)
            {
               if(m_emInfoType == EMInfoType.emMF)
               {
                   GetMFInfo();
               }
               txCode.Text = m_strCode;
               txLongName.Text = m_strLongName;
               txShortName.Text = m_strShortName;
               txComment.Text = m_strComment;
            }
        }

        private void GetMFInfo()
        {
            if (m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Get MFInfo

                SqlCommand cmd = new SqlCommand("Proc_EQ_GetMFID", m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MFID", SqlDbType.Int);
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
                        m_strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_MFLongName");
                        m_strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_MFShortName");
                    }
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
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

            int nSelIdx = cmbLanguage.SelectedIndex;
            m_strLanguageCode = ((OVRCustomComboBoxItem)cmbLanguage.Items[nSelIdx]).Value.ToString();

            switch (m_iOperateType)
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

        private bool AddInfo()
        {
            bool bResult = false;

            switch (Convert.ToInt32(m_emInfoType))
            {
                case 6:
                    bResult = AddMF();
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
                case 6:
                    bResult = EditMF();
                    break;
                default:
                    break;
            }
            return bResult;
        }
        #endregion

        #region DataBase Functions
        private bool AddMF()
        {
            if (m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Add MF

                SqlCommand cmd = new SqlCommand("Proc_EQ_AddMF", m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter( "@MatchConfigID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter( "@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter2 = new SqlParameter( "@MFLongName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter3 = new SqlParameter( "@MFShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter4 = new SqlParameter( "@MFComment", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter5 = new SqlParameter( "@Result", SqlDbType.Int);

                cmdParameter0.Value = m_iMatchConfigID;
                cmdParameter1.Value = m_strLanguageCode;
                cmdParameter2.Value = m_strLongName;
                cmdParameter3.Value = m_strShortName;
                cmdParameter4.Value = m_strComment;
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

        private bool EditMF()
        {
            if (m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Edit MF

                SqlCommand cmd = new SqlCommand("Proc_EQ_EditMF", m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MFID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter2 = new SqlParameter("@MFLongName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter3 = new SqlParameter("@MFShortName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter4 = new SqlParameter("@MFComment", SqlDbType.NVarChar, 100);
                SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter0.Value = m_iInfoID;
                cmdParameter1.Value = m_strLanguageCode;
                cmdParameter2.Value = m_strLongName;
                cmdParameter3.Value = m_strShortName;
                cmdParameter4.Value = m_strComment;
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
        #endregion

    }
}