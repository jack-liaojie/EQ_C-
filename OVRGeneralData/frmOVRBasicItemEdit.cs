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

namespace AutoSports.OVRGeneralData
{
    public enum EItemype
    {
        emUnknown = -1,
        emSport = 0,            // 赛事
        emDiscipline,	       // 大项	
        emEvent,              // 小项
        emLanguage,		      // 语言
        emFunction,	         // 职责
        emPosition,		     // 位置
        emRegType,		     // 注册类型
        emIRM,               // IRM类型
        emWeather,           //天气
        emCity,              //城市
        emVenue,             //场馆
        emCourt,             //场地
    };

    public partial class OVRBasicItemEditForm : UIForm
    {
        public struct sDlgParam
        {
            public bool bEnableLanguage;
            public bool bEnableDate;    
            public bool bEnableSex;   
            public bool bEnableOrder;        
            public bool bEnableRegType;
            public bool bEnableRegCode;
            public bool bEnableCompetitionType;
            public bool bVisibleGroup;
            public bool bEnableComment;
        };
        public sDlgParam m_sDlgParam;

      
        public EItemype m_emItemType;
        public EItemype ItemType
        {
            set { m_emItemType = value; }
        }

        public struct sBasicItemInfo
        {
            public string strLanguageCode;
            public string strLongName;
            public string strShortName;
            public string strRegCode;
            public string strStartTime;
            public string strEndTime;
            public string strSexID;
            public string strRegTypeID;
            public string strCompetitionTypeID;
            public string strOrder;
            public string strInfo;
            public string strComment;
            public int iGroupType;    //1:Federation, 2:NOC, 3:Club, 4:Delegation
        };
        public sBasicItemInfo m_sBasicItem;

        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public OVRBasicItemEditForm()
        {
            InitializeComponent();
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "frmOVRBasicItemEdit");
            lbLanguage.Text = LocalizationRecourceManager.GetString(this.Name, "lbLanguage");
            lbLongName.Text = LocalizationRecourceManager.GetString(this.Name, "lbLongName");
            lbShortName.Text = LocalizationRecourceManager.GetString(this.Name, "lbShortName");
            lbRegCode.Text = LocalizationRecourceManager.GetString(this.Name, "lbRegCode");
            lbStartDate.Text = LocalizationRecourceManager.GetString(this.Name, "lbStartDate");
            lbEndDate.Text = LocalizationRecourceManager.GetString(this.Name, "lbEndDate");
            lbSex.Text = LocalizationRecourceManager.GetString(this.Name, "lbSex");
            lbComment.Text = LocalizationRecourceManager.GetString(this.Name, "lbComment");
           
            lbCompetitionType.Text = LocalizationRecourceManager.GetString(this.Name, "lbCompetitionType");
            if (m_emItemType == EItemype.emFunction)
            {
                lbRegType.Text = LocalizationRecourceManager.GetString(this.Name, "lbFunctionCategoryCode");
            }
            else
            {
                lbRegType.Text = LocalizationRecourceManager.GetString(this.Name, "lbType");
            }
            lbOrder.Text = LocalizationRecourceManager.GetString(this.Name, "lbOrder");
            lbGroup.Text = LocalizationRecourceManager.GetString(this.Name, "lbGroup");
            this.cmbGroup.Items.Add(LocalizationRecourceManager.GetString(this.Name, "cmb_Federation"));
            this.cmbGroup.Items.Add(LocalizationRecourceManager.GetString(this.Name, "cmb_NOC"));
            this.cmbGroup.Items.Add(LocalizationRecourceManager.GetString(this.Name, "cmb_Club"));
            this.cmbGroup.Items.Add(LocalizationRecourceManager.GetString(this.Name, "cmb_Delegation"));
            btnOK.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnOK");
            btnCancel.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnCancel");
        }

        private void SetDlgFunction()
        {
            cmbLanguage.Enabled = m_sDlgParam.bEnableLanguage;
            dtStartDate.Enabled = m_sDlgParam.bEnableDate;
            dtEndDate.Enabled = m_sDlgParam.bEnableDate;
            cmbSex.Enabled = m_sDlgParam.bEnableSex;
            cmbRegType.Enabled = m_sDlgParam.bEnableRegType;
            cmbCompetitionType.Enabled = m_sDlgParam.bEnableCompetitionType;
            txOrder.Enabled = m_sDlgParam.bEnableOrder;
            txRegCode.Enabled = m_sDlgParam.bEnableRegCode;
            txComment.Enabled = m_sDlgParam.bEnableComment;

            lbGroup.Visible = m_sDlgParam.bVisibleGroup;
            cmbGroup.Visible = m_sDlgParam.bVisibleGroup;
        }

        private void OnLoad(object sender, EventArgs e)
        {
            Localization();

            txLongName.Text = m_sBasicItem.strLongName;
            txShortName.Text = m_sBasicItem.strShortName;
            txRegCode.Text = m_sBasicItem.strRegCode;
            dtStartDate.Text = m_sBasicItem.strStartTime;
            dtEndDate.Text = m_sBasicItem.strEndTime;
            txOrder.Text = m_sBasicItem.strOrder;
            txComment.Text = m_sBasicItem.strComment;

            InitLanguageCombox();
            if (m_sDlgParam.bEnableSex)
                InitSexCombox();
            if (m_sDlgParam.bEnableRegType)
                InitRegTypeCombox();
            if (m_sDlgParam.bEnableCompetitionType)
                InitCompetitionTypeCombox();
            if (m_emItemType == EItemype.emFunction)
                InitRegTypeComboxForFunctionType();

            SetDlgFunction();

            if(m_sDlgParam.bVisibleGroup)
            {
                ShowCurSportGroupType();
            }
        }

        private void InitLanguageCombox()
        {
            string strSQL;
            strSQL = String.Format("SELECT F_LanguageDescription,F_LanguageCode FROM TC_Language Order By F_Order");

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
            SqlDataReader dr = cmd.ExecuteReader();
            FillComboBox(cmbLanguage, dr, m_sBasicItem.strLanguageCode);
            dr.Close();
        }

        private void InitSexCombox()
        {
            string strSQL;
            strSQL = String.Format("SELECT B.F_SexLongName,A.F_SexCode FROM TC_Sex as A LEFT JOIN TC_Sex_Des as B ON A.F_SexCode = B.F_SexCode WHERE B.F_LanguageCode='{0}'", m_sBasicItem.strLanguageCode);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
            SqlDataReader dr = cmd.ExecuteReader();
            FillComboBox(cmbSex, dr, m_sBasicItem.strSexID);
            dr.Close();
        }

        private void InitRegTypeCombox()
        {
            string strSQL;
            strSQL = String.Format("SELECT B.F_RegTypeLongDescription,A.F_RegTypeID FROM TC_RegType AS A LEFT JOIN TC_RegType_Des AS B ON A.F_RegTypeID = B.F_RegTypeID WHERE B.F_LanguageCode='{0}' AND A.F_RegTypeID IN (1,2,3)", m_sBasicItem.strLanguageCode);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
            SqlDataReader dr = cmd.ExecuteReader();
            FillComboBox(cmbRegType, dr, m_sBasicItem.strRegTypeID);
            dr.Close();
        }

        private void InitRegTypeComboxForFunctionType()
        {
            SqlCommand cmd = new SqlCommand("Proc_GetFunctionCategoryCode", sqlConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;
            SqlDataReader dr = cmd.ExecuteReader();
            FillComboBox(cmbRegType, dr, m_sBasicItem.strRegTypeID);
            dr.Close();
        }

        private void InitCompetitionTypeCombox()
        {
            string strSQL;
            strSQL = String.Format("SELECT B.F_CompetitionTypeLongName,A.F_CompetitionTypeID FROM TC_CompetitionType AS A LEFT JOIN TC_CompetitionType_Des AS B ON A.F_CompetitionTypeID = B.F_CompetitionTypeID WHERE B.F_LanguageCode='{0}'", m_sBasicItem.strLanguageCode);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
            SqlDataReader dr = cmd.ExecuteReader();
            FillComboBox(cmbCompetitionType, dr, m_sBasicItem.strCompetitionTypeID);
            dr.Close();
        }

        private void FillComboBox(DevComponents.DotNetBar.Controls.ComboBoxEx combo, SqlDataReader dr, String strValue)
        {
            combo.Items.Clear();
            if (dr.HasRows)
            {
                int nItemIdx = 0;
                int nSelItemIdx = -1;
                while (dr.Read())
                {
                    ComboBoxItem item = new ComboBoxItem();

                    if (dr.FieldCount >= 2)
                    {
                        item.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, dr.GetName(0));
                        item.Tag = OVRDataBaseUtils.GetFieldValue2String(ref dr, dr.GetName(1));
                    }
                    else if(dr.FieldCount == 1)
                    {
                        item.Text = OVRDataBaseUtils.GetFieldValue2String(ref dr, dr.GetName(0));
                        item.Tag = OVRDataBaseUtils.GetFieldValue2String(ref dr, dr.GetName(0));
                    }
                    combo.Items.Add(item);

                    if (item.Tag.ToString().CompareTo(strValue) == 0)
                    {
                        nSelItemIdx = nItemIdx;
                    }
                    nItemIdx++;
                }

                if (nSelItemIdx >= 0)
                {
                    combo.Text = combo.Items[nSelItemIdx].ToString();
                }
            }
        }

        private void ShowCurSportGroupType()
        {
            ////////////////////////////////////////
            //1-Federation,2-NOC, 3-Club, 4-Delegation
            if (m_sBasicItem.iGroupType == 1)
            {
                cmbGroup.SelectedIndex = 0;
            }
            else if (m_sBasicItem.iGroupType == 2)
            {
                cmbGroup.SelectedIndex = 1;
            }
            else if (m_sBasicItem.iGroupType == 3)
            {
                cmbGroup.SelectedIndex = 2;
            }
            else if(m_sBasicItem.iGroupType == 4)
            {
                cmbGroup.SelectedIndex = 3;
            }
        }

        private void cmbGroup_SelectionChangeCommitted(object sender, EventArgs e)
        {
            if (cmbGroup.SelectedIndex == 0)
            {
                m_sBasicItem.iGroupType = 1;
            }
            else if (cmbGroup.SelectedIndex == 1)
            {
                m_sBasicItem.iGroupType = 2;
            }
            else if (cmbGroup.SelectedIndex == 2)
            {
                m_sBasicItem.iGroupType = 3;
            }
            else if(cmbGroup.SelectedIndex == 3)
            {
                m_sBasicItem.iGroupType = 4;
            }
        }

        private void OnOk(object sender, EventArgs e)
        {
            ComboBoxItem cbitem = (ComboBoxItem)cmbLanguage.SelectedItem;
            if (cbitem != null) 
                m_sBasicItem.strLanguageCode = cbitem.Tag.ToString();

            m_sBasicItem.strLongName = txLongName.Text;
            m_sBasicItem.strShortName = txShortName.Text;
            m_sBasicItem.strRegCode = txRegCode.Text;
            m_sBasicItem.strStartTime = dtStartDate.Text;
            m_sBasicItem.strEndTime = dtEndDate.Text;
            m_sBasicItem.strComment = txComment.Text;

            cbitem = (ComboBoxItem)cmbSex.SelectedItem;
            if (cbitem != null) 
                m_sBasicItem.strSexID = cbitem.Tag.ToString();

            cbitem = (ComboBoxItem)cmbRegType.SelectedItem;
            if (cbitem != null) 
            m_sBasicItem.strRegTypeID = cbitem.Tag.ToString();

            cbitem = (ComboBoxItem)cmbCompetitionType.SelectedItem;
            if (cbitem != null)
                m_sBasicItem.strCompetitionTypeID = cbitem.Tag.ToString();

            try
            {
                m_sBasicItem.strOrder = txOrder.Text;
                int iOrder = Convert.ToInt32(m_sBasicItem.strOrder);
            }
            catch (System.Exception ex)
            {
                m_sBasicItem.strOrder = "";
            }

            string strPromotion = "";

            if (m_sDlgParam.bEnableRegCode && m_sBasicItem.strRegCode == "")
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "PromotionMissingRegCode");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }
            if (m_sDlgParam.bEnableDate && m_sBasicItem.strStartTime == "")
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "PromotionMissingDate");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }
            if (m_sDlgParam.bEnableDate && m_sBasicItem.strEndTime == "")
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "PromotionMissingDate");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }
            if (m_sDlgParam.bEnableSex && m_sBasicItem.strSexID == null)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "PromotionMissingSexID");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }
            if (m_sDlgParam.bEnableRegType && m_sBasicItem.strRegTypeID == null)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "PromotionMissingRegTypeID");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }
            if ((m_sDlgParam.bEnableCompetitionType && m_sBasicItem.strCompetitionTypeID == null) ||
                (m_sDlgParam.bEnableCompetitionType && m_sBasicItem.strCompetitionTypeID == ""))
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "PromotionMissingCompetitionTypeID");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }


            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void OnCancel(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        private void txOrder_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar < (int)Keys.D0 || (int)e.KeyChar > (int)Keys.D9)
            {
                if (e.KeyChar == (int)Keys.Back || e.KeyChar == (int)Keys.Right || e.KeyChar == (int)Keys.Left)
                {
                    return;
                }
                e.Handled = true;
            }
        }

       
    }
}