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
    public partial class OVRClubNationListForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public EMInfoType m_emInfoType = EMInfoType.emUnKnown;
        public string m_strLanguageCode = "";
        private string strInfoValue = "";
        private int m_iSelRowIdx = -1;

        private bool m_bModified = false;

        public OVRClubNationListForm(string strName)
        {
            InitializeComponent();
            this.Name = strName;
            
        }
       
        private void OVRClubNationListForm_Load(object sender, EventArgs e)
        {
            InitLanguageCombBox();
            InitGridStyle();
            Localization();

            switch(Convert.ToInt32(m_emInfoType))
            {
                case 0:
                    FillInfoGridOfNation();
                    break;
                case 1:
                    FillInfoGridOfClub();
                    break;
                case 2:
                    FillInfoGridOfColor();
                    break;
                case 4:
                    FillInfoGridOfNOC();
                    break;
                default:
                    break;
            }
        }

        private void OVRClubNationListForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (m_bModified)
                this.DialogResult = DialogResult.OK;
        }

        private void cmbLanguage_SelectionChangeCommitted(object sender, EventArgs e)
        {
            if (cmbLanguage.SelectedItem == null)
                return;

            int iSelectIdx = cmbLanguage.SelectedIndex;
            m_strLanguageCode = ((OVRCustomComboBoxItem)cmbLanguage.Items[iSelectIdx]).Value.ToString();
            switch (Convert.ToInt32(m_emInfoType))
            {
                case 0:
                    FillInfoGridOfNation();
                    break;
                case 1:
                    FillInfoGridOfClub();
                    break;
                case 2:
                    FillInfoGridOfColor();
                    break;
                case 4:
                    FillInfoGridOfNOC();
                    break;
                default:
                    break;
            }
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            OVRClubNationInfoForm frmClubNationInfo = new OVRClubNationInfoForm(this.Name);
            frmClubNationInfo.DatabaseConnection = DatabaseConnection;
            frmClubNationInfo.m_nOperateType = 1;
            frmClubNationInfo.m_emInfoType = m_emInfoType;
            frmClubNationInfo.m_strLanguageCode = m_strLanguageCode;
            frmClubNationInfo.ShowDialog();
          
            if (frmClubNationInfo.DialogResult == DialogResult.OK)
            {
                m_bModified = true;

                m_iSelRowIdx = dgvInfo.Rows.Count;
                switch (Convert.ToInt32(m_emInfoType))
                {
                    case 0:
                        FillInfoGridOfNation();
                        return;
                    case 1:
                        FillInfoGridOfClub();
                        return;
                    case 2:
                        FillInfoGridOfColor();
                        return;
                    case 4:
                        FillInfoGridOfNOC();
                        return;
                }
            }
        }

        private void btnDel_Click(object sender, EventArgs e)
        {
            if (dgvInfo.SelectedRows.Count < 1)
                return;

            int nRowIdx = dgvInfo.SelectedRows[0].Index;

            string strMsgBox = LocalizationRecourceManager.GetString(this.Name, "DelInfoMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            int iInfoID = 0;
            string strNOC = "";
            if (Convert.ToInt32(m_emInfoType) != 4)
            {
                iInfoID = Convert.ToInt32(dgvInfo.Rows[nRowIdx].Cells["ID"].Value);
            }
            else if (Convert.ToInt32(m_emInfoType) == 4)
            {
                strNOC = Convert.ToString(dgvInfo.Rows[nRowIdx].Cells["NOC"].Value);
            }

            if (nRowIdx == dgvInfo.Rows.Count - 1)
            {
                m_iSelRowIdx = nRowIdx - 1;
            }
            else
            {
                m_iSelRowIdx = nRowIdx;
            }
            switch (Convert.ToInt32(m_emInfoType))
            {
                case 0:
                    DelInfoOfNation(iInfoID);
                    FillInfoGridOfNation();
                    break;
                case 1:
                    DelInfoOfClub(iInfoID);
                    FillInfoGridOfClub();
                    break;
                case 2:
                    DelInfoOfColor(iInfoID);
                    FillInfoGridOfColor();
                    break;
                case 4:
                    DelInfoOfNOC(strNOC);
                    FillInfoGridOfNOC();
                    break;
                default:
                    break;
            }
        }

        private void btnEdit_Click(object sender, EventArgs e)
        {
            if (dgvInfo.SelectedRows.Count <= 0)
                return;

            OVRClubNationInfoForm frmClubNationInfo = new OVRClubNationInfoForm(this.Name);
            frmClubNationInfo.DatabaseConnection = DatabaseConnection;
            frmClubNationInfo.m_nOperateType = 2;
            frmClubNationInfo.m_emInfoType = m_emInfoType;
            frmClubNationInfo.m_strLanguageCode = m_strLanguageCode;
           
            int nRowIdx = dgvInfo.SelectedRows[0].Index;
            if (m_emInfoType == EMInfoType.emNation || m_emInfoType== EMInfoType.emColor)
            {
                frmClubNationInfo.m_iInfoID = Convert.ToInt32(dgvInfo.Rows[nRowIdx].Cells["ID"].Value);

                frmClubNationInfo.m_strLongName = dgvInfo.Rows[nRowIdx].Cells["Long Name"].Value.ToString();
                frmClubNationInfo.m_strShortName = dgvInfo.Rows[nRowIdx].Cells["Short Name"].Value.ToString();
                frmClubNationInfo.m_strComment = dgvInfo.Rows[nRowIdx].Cells["Comment"].Value.ToString();
            }
            else if (m_emInfoType == EMInfoType.emClub)
            {
                frmClubNationInfo.m_iInfoID = Convert.ToInt32(dgvInfo.Rows[nRowIdx].Cells["ID"].Value);
                frmClubNationInfo.m_strCode = dgvInfo.Rows[nRowIdx].Cells["Code"].Value.ToString();
                frmClubNationInfo.m_strLongName = dgvInfo.Rows[nRowIdx].Cells["Long Name"].Value.ToString();
                frmClubNationInfo.m_strShortName = dgvInfo.Rows[nRowIdx].Cells["Short Name"].Value.ToString();
            }
            else if (m_emInfoType == EMInfoType.emNOC)
            {
                frmClubNationInfo.m_strCode = dgvInfo.Rows[nRowIdx].Cells["NOC"].Value.ToString();
                frmClubNationInfo.m_strLongName = dgvInfo.Rows[nRowIdx].Cells["Long Name"].Value.ToString();
                frmClubNationInfo.m_strShortName = dgvInfo.Rows[nRowIdx].Cells["Short Name"].Value.ToString();

            }
            frmClubNationInfo.ShowDialog();

            if (frmClubNationInfo.DialogResult == DialogResult.OK)
            {
                m_bModified = true;

                m_iSelRowIdx = nRowIdx;
                switch (Convert.ToInt32(m_emInfoType))
                {
                    case 0:
                        FillInfoGridOfNation();
                        return;
                    case 1:
                        FillInfoGridOfClub();
                        return;
                    case 2:
                        FillInfoGridOfColor();
                        return;
                    case 4:
                        FillInfoGridOfNOC();
                        return;
                }
            }
        }       

        #region Assist Functions

        private void Localization()
        {
            //this.Text = LocalizationRecourceManager.GetString(this.Name, "InfoListFrm");
            this.lbLanguage.Text = LocalizationRecourceManager.GetString(this.Name, "lbLanguage");
            this.btnAdd.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnAddInfo");
            this.btnDel.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnDelInfo");
            this.btnEdit.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnEditInfo");

            switch (Convert.ToInt32(m_emInfoType))
            {
                case 0:
                  strInfoValue = LocalizationRecourceManager.GetString(this.Name, "lbListInfo_Nation");
                  break;
                case 1:
                  strInfoValue = LocalizationRecourceManager.GetString(this.Name, "lbListInfo_Club");
                  break;
                case 2:
                  strInfoValue = LocalizationRecourceManager.GetString(this.Name, "lbListInfo_Color");
                  break;
                case 4:
                  strInfoValue = LocalizationRecourceManager.GetString(this.Name, "lbListInfo_NOC");
                  break;
            }
            this.Text = strInfoValue;
        }

        private void InitGridStyle()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvInfo);
            dgvInfo.RowHeadersVisible = true;
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
                SqlCommand cmd = new SqlCommand("Proc_GetLanguageCode", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;
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
            if(dr.HasRows)
            {
                while(dr.Read())
                {
                   cmb.Items.Add(new OVRCustomComboBoxItem(dr[nKeyIdx].ToString(), dr[nValueIdx].ToString()));   
                   
                    if(dr[nKeyIdx].ToString().CompareTo(m_strLanguageCode) == 0)
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
        
        private void FillInfoGridOfNation()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Nation Info
                SqlCommand cmd = new SqlCommand("Proc_GetNationList", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);
                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                OVRDataBaseUtils.FillDataGridView(dgvInfo, dr, null, null);
                dr.Close();

                if(dgvInfo.Rows.Count > 0)
                {
                    if (m_iSelRowIdx < 0)
                    {
                        return;
                    }
                    else if (m_iSelRowIdx > dgvInfo.RowCount - 1)
                    {
                        m_iSelRowIdx = dgvInfo.RowCount - 1;
                    }
                    dgvInfo.Rows[m_iSelRowIdx].Selected = true;
                    dgvInfo.FirstDisplayedScrollingRowIndex = m_iSelRowIdx;
                }
              
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }          
        }

        private void FillInfoGridOfClub()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Club Info
                SqlCommand cmd = new SqlCommand("Proc_GetClubList", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);
                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                OVRDataBaseUtils.FillDataGridView(dgvInfo, dr, null, null);
                dr.Close();

                if(dgvInfo.Rows.Count > 0)
                {
                    if (m_iSelRowIdx < 0)
                    {
                        return;
                    }
                    else if (m_iSelRowIdx > dgvInfo.RowCount - 1)
                    {
                        m_iSelRowIdx = dgvInfo.RowCount - 1;
                    }
                    dgvInfo.Rows[m_iSelRowIdx].Selected = true;
                    dgvInfo.FirstDisplayedScrollingRowIndex = m_iSelRowIdx;
                }
              
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }        
        }

        private void FillInfoGridOfNOC()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for NOC Info
                SqlCommand cmd = new SqlCommand("proc_GetCountryList", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);
                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                OVRDataBaseUtils.FillDataGridView(dgvInfo, dr, null, null);
                dr.Close();

                if(dgvInfo.Rows.Count > 0)
                {
                    if (m_iSelRowIdx < 0)
                    {
                        return;
                    }
                    else if (m_iSelRowIdx > dgvInfo.RowCount - 1)
                    {
                        m_iSelRowIdx = dgvInfo.RowCount - 1;
                    }
                    dgvInfo.Rows[m_iSelRowIdx].Selected = true;
                    dgvInfo.FirstDisplayedScrollingRowIndex = m_iSelRowIdx;
                }
              
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void FillInfoGridOfColor()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Club Info

                SqlCommand cmd = new SqlCommand("Proc_GetColorList", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);
                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                OVRDataBaseUtils.FillDataGridView(dgvInfo, dr, null, null);
                dr.Close();

                if(dgvInfo.Rows.Count > 0)
                {
                    if (m_iSelRowIdx < 0)
                    {
                        return;
                    }
                    else if (m_iSelRowIdx > dgvInfo.RowCount - 1)
                    {
                        m_iSelRowIdx = dgvInfo.RowCount - 1;
                    }
                    dgvInfo.Rows[m_iSelRowIdx].Selected = true;
                    dgvInfo.FirstDisplayedScrollingRowIndex = m_iSelRowIdx;
                }
             
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        #endregion

        #region DataBase Functions

        private bool DelInfoOfClub(int nInfoID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Del Club

                SqlCommand cmd = new SqlCommand("proc_DelClub", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@ClubID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameter1.Value = nInfoID;
                cmdParameter2.Direction = ParameterDirection.Output;
                
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter2.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelFailed_ID");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelFailed_Player");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default://其余的为修改成功
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

        private bool DelInfoOfNation(int nInfoID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Del Nation

                SqlCommand cmd = new SqlCommand("proc_DelNation", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@NationID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameter1.Value = nInfoID;
                cmdParameter2.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter2.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelFailed_ID");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelFailed_Player");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default://其余的为修改成功
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

        private bool DelInfoOfColor(int nInfoID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Del Color

                SqlCommand cmd = new SqlCommand("proc_DelColor", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@ColorID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameter1.Value = nInfoID;
                cmdParameter2.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter2.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelFailed_ID");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelColor_Used");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default://其余的为修改成功
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

        private bool DelInfoOfNOC(string strNOC)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Del Color

                SqlCommand cmd = new SqlCommand("proc_DelCountry", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@NOC", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter2 = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameter1.Value = strNOC;
                cmdParameter2.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter2.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelFailed_ID");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default://其余的为修改成功
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

    }
}