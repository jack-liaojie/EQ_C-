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
    public partial class OVRDesInfoListForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public string m_strLanguageCode = "";
        private string strInfoValue = "";
        private int m_iSelRowIdx = -1;

        private string m_strDesTableName;
        private string m_strDesName;

        private bool m_bModified = false;

        public OVRDesInfoListForm(string strName,string strDesTableName,string strDesName)
        {
            InitializeComponent();
            this.Name = strName;
            m_strDesTableName = strDesTableName;
            m_strDesName = strDesName;

            
        }
       
        private void OVRDesInfoListForm_Load(object sender, EventArgs e)
        {
            InitLanguageCombBox();
            InitGridStyle();
            Localization();
            FillInfoGrid();
        }

        private void OVRDesInfoListForm_FormClosed(object sender, FormClosedEventArgs e)
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
            FillInfoGrid();
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            OVRDesInfoEditForm frmDesInfoEdit = new OVRDesInfoEditForm(this.Name, m_strDesTableName, m_strDesName);
            frmDesInfoEdit.DatabaseConnection = DatabaseConnection;
            frmDesInfoEdit.m_nOperateType = 1;
            frmDesInfoEdit.m_strLanguageCode = m_strLanguageCode;
            frmDesInfoEdit.ShowDialog();
          
            if (frmDesInfoEdit.DialogResult == DialogResult.OK)
            {
                m_bModified = true;

                m_iSelRowIdx = dgvInfo.Rows.Count;
                FillInfoGrid();

            }
        }

        private void btnDel_Click(object sender, EventArgs e)
        {
            if (dgvInfo.SelectedRows.Count < 1)
                return;

            int nRowIdx = dgvInfo.SelectedRows[0].Index;

            string strMsgBox = LocalizationRecourceManager.GetString("OVRRegisterInfo", "DelInfoMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            int iInfoID = 0;
            iInfoID = Convert.ToInt32(dgvInfo.Rows[nRowIdx].Cells["ID"].Value);

            if (nRowIdx == dgvInfo.Rows.Count - 1)
            {
                m_iSelRowIdx = nRowIdx - 1;
            }
            else
            {
                m_iSelRowIdx = nRowIdx;
            }

            DelInfo(iInfoID);
            FillInfoGrid();

        }

        private void btnEdit_Click(object sender, EventArgs e)
        {
            if (dgvInfo.SelectedRows.Count <= 0)
                return;

            OVRDesInfoEditForm frmDesInfoEdit = new OVRDesInfoEditForm(this.Name,m_strDesTableName,m_strDesName);
            frmDesInfoEdit.DatabaseConnection = DatabaseConnection;
            frmDesInfoEdit.m_nOperateType = 2;
            frmDesInfoEdit.m_strLanguageCode = m_strLanguageCode;
           
            int nRowIdx = dgvInfo.SelectedRows[0].Index;

            frmDesInfoEdit.m_iInfoID = Convert.ToInt32(dgvInfo.Rows[nRowIdx].Cells["ID"].Value);

            frmDesInfoEdit.m_strLongName = dgvInfo.Rows[nRowIdx].Cells["Long Name"].Value.ToString();
            frmDesInfoEdit.m_strShortName = dgvInfo.Rows[nRowIdx].Cells["Short Name"].Value.ToString();
            frmDesInfoEdit.m_strComment = dgvInfo.Rows[nRowIdx].Cells["Comment"].Value.ToString();

            frmDesInfoEdit.ShowDialog();

            if (frmDesInfoEdit.DialogResult == DialogResult.OK)
            {
                m_bModified = true;
                m_iSelRowIdx = nRowIdx;
                FillInfoGrid();

            }
        }       

        #region Assist Functions

        private void Localization()
        {
            //this.Text = LocalizationRecourceManager.GetString(this.Name, "InfoListFrm");
            this.lbLanguage.Text = LocalizationRecourceManager.GetString(this.Name, "lbLanguage");
            strInfoValue = LocalizationRecourceManager.GetString("OVRRegister", "lbListInfo_MF");
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

        private void FillCombox(UIComboBox cmb, SqlDataReader dr, int nValueIdx, int nKeyIdx, String strValue)
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
        

        private void FillInfoGrid()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for NOC Info
                SqlCommand cmd = new SqlCommand("Proc_EQ_GetDesInfoList", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@DesTableName", SqlDbType.NVarChar,50);
                SqlParameter cmdParameter1 = new SqlParameter("@DesName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter0.Value = m_strDesTableName;
                cmd.Parameters.Add(cmdParameter0);
                cmdParameter1.Value = m_strDesName;
                cmd.Parameters.Add(cmdParameter1);
                cmdParameter2.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter2);
                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                OVRDataBaseUtils.FillDataGridView(dgvInfo, dr, null, null);
                dr.Close();
                //隐藏ID列
                dgvInfo.Columns[0].Visible = false;
                if (dgvInfo.Rows.Count > 0)
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

        private bool DelInfo(int nInfoID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Del Color

                SqlCommand cmd = new SqlCommand("Proc_EQ_DelDes", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@DesTableName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter1 = new SqlParameter("@DesName", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter2 = new SqlParameter("@ID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameter0.Value = m_strDesTableName;
                cmdParameter1.Value = m_strDesName;
                cmdParameter2.Value = nInfoID;
                cmdParameter3.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
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
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelMF_Used");
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