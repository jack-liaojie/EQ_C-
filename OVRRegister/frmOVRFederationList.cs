using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Collections;
using DevComponents.DotNetBar;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRRegister
{
    public partial class OVRFederationListForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        private bool m_bFederationActived = false;
        public bool FederationActived
        {
            get { return m_bFederationActived; }
        }

        private bool m_bFederationAdd_Del = false;
        public bool FederationAdd_Del
        {
            get { return m_bFederationAdd_Del; }
        }

        private bool m_bFederationModify = false;
        public bool FederationModify
        {
            get { return m_bFederationModify; }
        }

        public int m_iActiveSportID;
        public int m_iActiveDisciplineID;
        public string m_strActiveLanguageCode;
        public int m_iGroupType;

        private int m_iCurSelIdex = -1;    //记录当前选中的Federation的行号

        private ArrayList  m_arySelIndex = new ArrayList();


        public OVRFederationListForm(string strName)
        {
            InitializeComponent();

            this.Name = strName;
            Localization();
            InitGridStyle();
        }

        private void OVRFederationListForm_Load(object sender, EventArgs e)
        {
            OVRDataBaseUtils.GetActiveInfo(sqlConnection, out m_iActiveSportID, out m_iActiveDisciplineID, out m_strActiveLanguageCode);
            ResetFederationList(m_iActiveDisciplineID, m_strActiveLanguageCode, m_iGroupType);
        }

        private void btnUpdate_Click(object sender, EventArgs e)
        {
            ResetFederationList(m_iActiveDisciplineID, m_strActiveLanguageCode,m_iGroupType);
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            OVRClubNationInfoForm frmClubNationInfo = new OVRClubNationInfoForm(this.Name);
            frmClubNationInfo.DatabaseConnection = DatabaseConnection;
            frmClubNationInfo.m_nOperateType = 1;

            if(m_iGroupType == 1)
            {
                frmClubNationInfo.m_emInfoType = EMInfoType.emFederation;
            }
            else if(m_iGroupType == 2)
            {
                frmClubNationInfo.m_emInfoType = EMInfoType.emNOC;
            }
            else if(m_iGroupType == 3)
            {
                frmClubNationInfo.m_emInfoType = EMInfoType.emClub;
            }
            else if (m_iGroupType == 4)
            {
                frmClubNationInfo.m_emInfoType = EMInfoType.emDelegation;
            }
            frmClubNationInfo.m_strLanguageCode = m_strActiveLanguageCode;
            frmClubNationInfo.ShowDialog();

            if(frmClubNationInfo.DialogResult == DialogResult.OK)
            {
                m_arySelIndex.Clear();
                m_arySelIndex.Add(dgvFederation.RowCount);//增加的行号

                //m_iCurSelIdex = dgvFederation.RowCount;  
                m_bFederationAdd_Del = true;
                ResetFederationList(m_iActiveDisciplineID, m_strActiveLanguageCode, m_iGroupType);
            }
        }

        private void btnEdit_Click(object sender, EventArgs e)
        {
            int iSelRowsCount = dgvFederation.SelectedRows.Count;
            if(iSelRowsCount <= 0)
            {
                string strPromotion = LocalizationRecourceManager.GetString(this.Name, "Operation_Msg");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }
            int iSelRowIdx = dgvFederation.SelectedRows[0].Index;
            m_arySelIndex.Clear();
            m_arySelIndex.Add(iSelRowIdx);//修改的行号


            OVRClubNationInfoForm frmClubNationInfo = new OVRClubNationInfoForm(this.Name);
            frmClubNationInfo.DatabaseConnection = DatabaseConnection;
            frmClubNationInfo.m_nOperateType = 2;
            frmClubNationInfo.m_strLanguageCode = m_strActiveLanguageCode;

            if(m_iGroupType == 1)
            {
                frmClubNationInfo.m_emInfoType = EMInfoType.emFederation;
                frmClubNationInfo.m_iInfoID = Convert.ToInt32(dgvFederation.Rows[iSelRowIdx].Cells["ID"].Value);
                frmClubNationInfo.m_strComment = dgvFederation.Rows[iSelRowIdx].Cells["Comment"].Value.ToString();
            }
            else if(m_iGroupType == 2)
            {
                frmClubNationInfo.m_emInfoType = EMInfoType.emNOC;
                frmClubNationInfo.m_strComment = "";
            }
            else if(m_iGroupType == 3)
            {
                frmClubNationInfo.m_emInfoType = EMInfoType.emClub;
                frmClubNationInfo.m_iInfoID = Convert.ToInt32(dgvFederation.Rows[iSelRowIdx].Cells["ID"].Value);
                frmClubNationInfo.m_strComment = "";
            }
            else if (m_iGroupType == 4)
            {
                frmClubNationInfo.m_emInfoType = EMInfoType.emDelegation;
                frmClubNationInfo.m_iInfoID = Convert.ToInt32(dgvFederation.Rows[iSelRowIdx].Cells["ID"].Value);
                frmClubNationInfo.m_strComment = "";
                frmClubNationInfo.m_strDelegationType = dgvFederation.Rows[iSelRowIdx].Cells["Type"].Value.ToString();
                frmClubNationInfo.m_strComment = dgvFederation.Rows[iSelRowIdx].Cells["Comment"].Value.ToString();
            }
            frmClubNationInfo.m_strCode = dgvFederation.Rows[iSelRowIdx].Cells["Code"].Value.ToString();
            frmClubNationInfo.m_strLanguageCode = dgvFederation.Rows[iSelRowIdx].Cells["LanguageCode"].Value.ToString();
            frmClubNationInfo.m_strLongName = dgvFederation.Rows[iSelRowIdx].Cells["LongName"].Value.ToString();
            frmClubNationInfo.m_strShortName = dgvFederation.Rows[iSelRowIdx].Cells["ShortName"].Value.ToString();
            frmClubNationInfo.ShowDialog();

            if (frmClubNationInfo.DialogResult == DialogResult.OK)
            {
                m_bFederationModify = true;
                ResetFederationList(m_iActiveDisciplineID, m_strActiveLanguageCode, m_iGroupType);
            }
        }

        private void btnDel_Click(object sender, EventArgs e)
        {
            int iSelRowsCount = dgvFederation.SelectedRows.Count;
            string strPromotion;
            if (iSelRowsCount <= 0)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "Operation_Msg");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }
            strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelInfoMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            int iSelRowIdx = dgvFederation.SelectedRows[0].Index;
            string strGroupID = dgvFederation.Rows[iSelRowIdx].Cells["ID"].Value.ToString();

            if(iSelRowIdx == dgvFederation.Rows.Count -1)
            {
                if (dgvFederation.Rows.Count == 1)
                {
                    iSelRowIdx = -1;
                }
                else
                    iSelRowIdx = dgvFederation.Rows.Count - 2;
            }
            m_arySelIndex.Clear();
            m_arySelIndex.Add(iSelRowIdx);//删除的行号


            if (DelFederation(strGroupID))
            {
                m_bFederationAdd_Del = true;
                ResetFederationList(m_iActiveDisciplineID, m_strActiveLanguageCode,m_iGroupType);
            }
        }

        private void btnActive_Click(object sender, EventArgs e)
        {
            int iSelRowsCount = dgvFederation.SelectedRows.Count;
            string strPromotion;
            if (iSelRowsCount <= 0)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "Operation_Msg");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }

            m_arySelIndex.Clear();
            for(int nIndex = 0; nIndex < iSelRowsCount; nIndex++)
            {
                int iRowIndex = dgvFederation.SelectedRows[nIndex].Index;
                string strGroupID = dgvFederation.Rows[iRowIndex].Cells["ID"].Value.ToString();
                
                int iInputKey = 1;
                UpdateFedarationActive(strGroupID, m_iActiveDisciplineID, iInputKey);

                m_arySelIndex.Add(iRowIndex);
            }
            m_iCurSelIdex = dgvFederation.SelectedRows[0].Index;
            m_bFederationActived = true;
            ResetFederationList(m_iActiveDisciplineID, m_strActiveLanguageCode, m_iGroupType);
        }

        private void btnNonActive_Click(object sender, EventArgs e)
        {
            int iSelRowsCount = dgvFederation.SelectedRows.Count;
            string strPromotion;
            if (iSelRowsCount <= 0)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "Operation_Msg");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }

            m_arySelIndex.Clear();
            for (int nIndex = 0; nIndex < iSelRowsCount; nIndex++)
            {
                int iRowIndex = dgvFederation.SelectedRows[nIndex].Index;
                string strGroupID = dgvFederation.Rows[iRowIndex].Cells["ID"].Value.ToString();

                int iInputKey = 0;
                UpdateFedarationActive(strGroupID, m_iActiveDisciplineID, iInputKey);

                m_arySelIndex.Add(iRowIndex);
            }
            m_iCurSelIdex = dgvFederation.SelectedRows[0].Index;
            m_bFederationActived = true;
            ResetFederationList(m_iActiveDisciplineID, m_strActiveLanguageCode, m_iGroupType);

        }

        private void dgvFederation_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            int iColumnIndex = e.ColumnIndex;
            if (iColumnIndex < 0)
                return;
           
            if (dgvFederation.Columns[iColumnIndex].Name.CompareTo("Active") == 0)
            {
                FillActiveCombo();
            }
        }
     
        private void dgvFederation_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            int iColumnIndex = e.ColumnIndex;
            int iRowIndex = e.RowIndex;
            if (iColumnIndex < 0 || iRowIndex < 0)
                return;

            m_arySelIndex.Clear();
            m_arySelIndex.Add(iRowIndex);
            int iInputKey = -1;
            String strColumnName = dgvFederation.Columns[iColumnIndex].Name;
            if (strColumnName.CompareTo("Active") == 0)
            {
                string strGroupID = dgvFederation.Rows[iRowIndex].Cells["ID"].Value.ToString();

                DGVCustomComboBoxCell CurCell = dgvFederation.Rows[iRowIndex].Cells[iColumnIndex] as DGVCustomComboBoxCell;
                iInputKey = Convert.ToInt32(CurCell.Tag);

                UpdateFedarationActive(strGroupID, m_iActiveDisciplineID, iInputKey);
            }
            //m_iCurSelIdex = iRowIndex;
            m_bFederationActived = true;
        }

     
        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "FederationListFrm");
            this.btnActive.Text = LocalizationRecourceManager.GetString(this.Name, "btnActive");
            this.btnNonActive.Text = LocalizationRecourceManager.GetString(this.Name, "btnNonActive");
        }

        private void InitGridStyle()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvFederation);
            dgvFederation.RowHeadersVisible = true;
        }
      
        private void GetActiveInfo(ref int iSportID, ref int iDisciplineID, ref string strLanguageCode, ref int iGroupType)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }
            iSportID = 0;
            iDisciplineID = 0;
            strLanguageCode = "CHN";
            iGroupType = 1;

            try
            {
                #region DML Command Setup for Get Active Info

                SqlCommand cmd = new SqlCommand("Proc_GetActiveInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@SportID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter4 = new SqlParameter("@Result", SqlDbType.Int);

                cmdParameter1.Direction = ParameterDirection.Output;
                cmdParameter2.Direction = ParameterDirection.Output;
                cmdParameter3.Direction = ParameterDirection.Output;
                cmdParameter4.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter4.Value;
                if (nRetValue == 1)
                {
                    iSportID = (int)cmdParameter1.Value;
                    iDisciplineID = (int)cmdParameter2.Value;
                    strLanguageCode = cmdParameter3.Value.ToString();

                    string strSQLDes;
                    strSQLDes = string.Format("SELECT F_ConfigValue FROM TS_Sport_Config WHERE F_ConfigType = 1 AND F_SportID = {0}", iSportID);
                    SqlCommand cmd_GroupType = new SqlCommand(strSQLDes, DatabaseConnection);
                    SqlDataReader dr = cmd_GroupType.ExecuteReader();
                    while (dr.Read())
                    {
                        iGroupType = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ConfigValue");
                    }
                    dr.Close();
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void ResetFederationList(int iDisciplineID, string strLanguageCode, int iGroupType)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }
       
            try
            {
                #region DML Command Setup for Get Federation List

                SqlCommand cmd = new SqlCommand("Proc_GetGroupInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@GroupType", SqlDbType.Int);
                cmdParameter1.Value = iDisciplineID;
                cmdParameter2.Value = strLanguageCode;
                cmdParameter3.Value = iGroupType;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();

                OVRDataBaseUtils.FillDataGridViewWithCmb(dgvFederation, dr, 0);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            if(dgvFederation.Rows.Count > 0)
            {
                dgvFederation.ClearSelection();

                for (int i = 0; i < m_arySelIndex.Count; i++)
                {
                    int iSelIndex = (int)m_arySelIndex[i];

                    if (i == 0)
                    {
                        dgvFederation.FirstDisplayedScrollingRowIndex = iSelIndex;
                    }
                    dgvFederation.Rows[iSelIndex].Selected = true;
                }             
            }
        }

        private bool DelFederation(string strGroupID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Del Federation

                SqlCommand cmd = new SqlCommand("proc_DeleteGroupInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@GroupID", SqlDbType.NVarChar, 9);
                SqlParameter cmdParameter2 = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@GroupType", SqlDbType.Int);
                cmdParameter1.Value = strGroupID;
                cmdParameter2.Direction = ParameterDirection.Output;
                cmdParameter3.Value = m_iGroupType;

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
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelFailed_Player");
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

        private void FillActiveCombo()
        {
            DataTable table = new DataTable();
            table.Columns.Add("F_Active", typeof(string));
            table.Columns.Add("F_Vaule", typeof(int));

            table.Rows.Add("Yes", "1");
            table.Rows.Add("No", "0");
            (dgvFederation.Columns[0] as DGVCustomComboBoxColumn).FillComboBoxItems(table, "F_Active", "F_Vaule");
        }

        private void UpdateFedarationActive(string strGroupID, int nActiveDisciplineID, int nInputKey)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Active Federation

                SqlCommand cmd = new SqlCommand("proc_AciveGroup", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@GroupID", SqlDbType.NVarChar, 9);
                SqlParameter cmdParameter2 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@ActiveType", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameter cmdParameter5 = new SqlParameter("@GroupType", SqlDbType.Int);

                cmdParameter1.Value = strGroupID;
                cmdParameter2.Value = nActiveDisciplineID;
                cmdParameter3.Value = nInputKey;
                cmdParameter4.Direction = ParameterDirection.Output;
                cmdParameter5.Value = m_iGroupType;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter4.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 1:
                        break;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "EditFederation_Failed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelFederation_Player");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    default://其余的为修改成功
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
           
        }



    }
}