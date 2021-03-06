﻿using System;
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
    public partial class OVRRegisterDisplayForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public int m_iActiveSportID;
        public int m_iActiveDisciplineID;
        public string m_strActiveLanguageCode;
        public int m_iGroupType;

        private DataTable m_dtSex = new DataTable();
        private DataTable m_dtEvent = new DataTable();
        private DataTable m_dtFederation = new DataTable();
        private DataTable m_dtRegType = new DataTable();

        OrientateSelPlayerDelegate dgOrientateSelPlayer;

        
        public OVRRegisterDisplayForm(string strName)
        {
            InitializeComponent();

            this.Name = strName;
            Localization();
            InitGridStyle();
        }

        private void OVRRegisterDisplayForm_Load(object sender, EventArgs e)
        {

        }

        private void OVRRegisterDisplayForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                if (this.Owner != null)
                    this.Owner.Activate();

                this.Visible = false;
                e.Cancel = true;
            }
        }

         private void OVRRegisterDisplayForm_VisibleChanged(object sender, EventArgs e)
        {
            if (dgvRegister.Visible == false)
                return;

            GetActiveInfo(ref m_iActiveSportID, ref m_iActiveDisciplineID, ref m_strActiveLanguageCode, ref m_iGroupType);

            if (m_iGroupType == 1)
            {
                this.lbFederation.Text = LocalizationRecourceManager.GetString(this.Name, "lbFederation");
            }
            else if (m_iGroupType == 2)
            {
                this.lbFederation.Text = LocalizationRecourceManager.GetString(this.Name, "lbNOC");
            }
            else if (m_iGroupType == 3)
            {
                this.lbFederation.Text = LocalizationRecourceManager.GetString(this.Name, "lbClub");
            }
            else if (m_iGroupType == 4)
            {
                this.lbFederation.Text = LocalizationRecourceManager.GetString(this.Name, "lbDelegation");
            }
            FillSexCombo();
            FillEventCombo();
            FillRegTypeCombo();
            FillFederationCombo();

            ResetRegisterGrid(false);
        }

        private void cmbSex_SelectionChangeCommitted(object sender, EventArgs e)
        {
            ResetRegisterGrid(false);
        }

        private void cmbEvent_SelectionChangeCommitted(object sender, EventArgs e)
        {
            ResetRegisterGrid(false);
        }

        private void cmbRegType_SelectionChangeCommitted(object sender, EventArgs e)
        {
            ResetRegisterGrid(false);
        }

        private void cmbFederation_SelectionChangeCommitted(object sender, EventArgs e)
        {
            ResetRegisterGrid(false);
        }

        private void dgvRegister_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex > dgvRegister.RowCount - 1 || e.RowIndex < 0)
                return;

            int iSelRowIdx = e.RowIndex;

            string strGroupID = dgvRegister.Rows[iSelRowIdx].Cells["GroupID"].Value.ToString();
            string strRegisterID = dgvRegister.Rows[iSelRowIdx].Cells["RegisterID"].Value.ToString();

            if(null != dgOrientateSelPlayer)
            {
                dgOrientateSelPlayer(strGroupID, strRegisterID);
            }
        }

        #region Method
        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "RegisterDisplayFrm");
            this.lbSex.Text = LocalizationRecourceManager.GetString(this.Name, "lbSex");
            this.lbEvent.Text = LocalizationRecourceManager.GetString(this.Name, "lbEvent");
            this.lbRegType.Text = LocalizationRecourceManager.GetString(this.Name, "lbRegType");
        }
        
        private void InitGridStyle()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvRegister);
            dgvRegister.RowHeadersVisible = true;
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
        
        public void ResetRegisterGrid(bool bUpdateSel)
        {
            int iSexID, iEventID, iRegTypeID;
            string strGroupID;
            int nSelIdx = -1;

            if (cmbSex.SelectedItem == null)
                return;
            nSelIdx = cmbSex.SelectedIndex;
            iSexID = Convert.ToInt32(cmbSex.SelectedValue);

            if (cmbEvent.SelectedItem == null)
                return;
            nSelIdx = cmbEvent.SelectedIndex;
            iEventID = Convert.ToInt32(cmbEvent.SelectedValue);

            if (cmbRegType.SelectedItem == null)
                return;
            nSelIdx = cmbRegType.SelectedIndex;
            iRegTypeID = Convert.ToInt32(cmbRegType.SelectedValue);

            if (cmbFederation.SelectedItem == null)
                return;
            nSelIdx = cmbFederation.SelectedIndex;
            strGroupID = cmbFederation.SelectedValue.ToString();


            int iSelIndex = -1;
            if(bUpdateSel)
            {
                iSelIndex = dgvRegister.SelectedRows[0].Index;
            }

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get Register

                SqlCommand cmd = new SqlCommand("Proc_SearchRegisters", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@SexCode", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@RegTypeID", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@EventID", SqlDbType.Int);
                SqlParameter cmdParameter5 = new SqlParameter("@GroupID", SqlDbType.NVarChar, 9);
                SqlParameter cmdParameter6 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter7 = new SqlParameter("@GroupType", SqlDbType.Int);

                cmdParameter1.Value = m_iActiveDisciplineID;
                cmdParameter2.Value = iSexID;
                cmdParameter3.Value = iRegTypeID;
                cmdParameter4.Value = iEventID;
                cmdParameter5.Value = strGroupID;
                cmdParameter6.Value = m_strActiveLanguageCode;
                cmdParameter7.Value = m_iGroupType;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.Parameters.Add(cmdParameter6);
                cmd.Parameters.Add(cmdParameter7);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgvRegister, dr, null, null);
                dr.Close();

                if(dgvRegister.Columns["RegisterID"] != null)
                {
                    dgvRegister.Columns["RegisterID"].Visible = false;
                }
                if(dgvRegister.Columns["GroupID"] != null)
                {
                    dgvRegister.Columns["GroupID"].Visible = false;
                }

                if(dgvRegister.Rows.Count > 0)
                {
                    if (bUpdateSel && iSelIndex >= 0)
                    {
                        if (iSelIndex >= dgvRegister.RowCount)
                        {
                            iSelIndex = dgvRegister.RowCount - 1;
                        }
                        dgvRegister.ClearSelection();
                        dgvRegister.Rows[iSelIndex].Selected = true;
                        dgvRegister.FirstDisplayedScrollingRowIndex = iSelIndex;
                    }
                }
              
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
           
        }

        private void FillSexCombo()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get Sex

                SqlCommand cmd = new SqlCommand("Proc_GetSexList", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strActiveLanguageCode;
                cmd.Parameters.Add(cmdParameter1);
                #endregion

                m_dtSex.Clear();
                SqlDataReader dr = cmd.ExecuteReader();
                m_dtSex.Load(dr);
                dr.Close();

                cmbSex.DisplayMember = "F_Name";
                cmbSex.ValueMember = "F_Key";
                cmbSex.DataSource = m_dtSex;
                cmbSex.SelectedIndex = 0;

                AdjustComboBoxDropDownListWidth(cmbSex, m_dtSex);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
          
        }

        private void FillEventCombo()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get Event

                SqlCommand cmd = new SqlCommand("Proc_GetEventListByDisciplineID", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter0.Value = m_iActiveDisciplineID;
                cmdParameter1.Value = m_strActiveLanguageCode;
                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                #endregion

                m_dtEvent.Clear();
                SqlDataReader dr = cmd.ExecuteReader();
                m_dtEvent.Load(dr);
                dr.Close();

                cmbEvent.DisplayMember = "F_Name";
                cmbEvent.ValueMember = "F_Key";
                cmbEvent.DataSource = m_dtEvent;
                cmbEvent.SelectedIndex = 0;

                AdjustComboBoxDropDownListWidth(cmbEvent, m_dtEvent);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
         
        }

        private void FillRegTypeCombo()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get RegType

                SqlCommand cmd = new SqlCommand("Proc_GetRegTypeList", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strActiveLanguageCode;
                cmd.Parameters.Add(cmdParameter1);
                #endregion

                m_dtRegType.Clear();
                SqlDataReader dr = cmd.ExecuteReader();
                m_dtRegType.Load(dr);
                dr.Close();

                cmbRegType.DisplayMember = "F_Name";
                cmbRegType.ValueMember = "F_Key";
                cmbRegType.DataSource = m_dtRegType;
                cmbRegType.SelectedIndex = 0;

                AdjustComboBoxDropDownListWidth(cmbRegType, m_dtRegType);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
          
        }

        private void FillFederationCombo()
        {
             if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get Federation

                SqlCommand cmd = new SqlCommand("Proc_GetGroupList", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter2 = new SqlParameter("@GroupType", SqlDbType.Int);
                cmdParameter0.Value = m_iActiveDisciplineID;
                cmdParameter1.Value = m_strActiveLanguageCode;
                cmdParameter2.Value = m_iGroupType;
                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                m_dtFederation = null;
                m_dtFederation = new DataTable();
                m_dtFederation.Clear();
                SqlDataReader dr = cmd.ExecuteReader();
                m_dtFederation.Load(dr);
                dr.Close();

                cmbFederation.DisplayMember = "F_Name";
                cmbFederation.ValueMember = "F_Key";
                cmbFederation.DataSource = m_dtFederation;
                cmbFederation.SelectedIndex = 0;

                AdjustComboBoxDropDownListWidth(cmbFederation, m_dtFederation);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
         
        }

        private void AdjustComboBoxDropDownListWidth(object comboBox, DataTable dt)
        {
            Graphics g = null;
            Font font = null;
            try
            {
                ComboBox senderComboBox = null;
                if (comboBox is ComboBox)
                    senderComboBox = (ComboBox)comboBox;
                else if (comboBox is ToolStripComboBox)
                    senderComboBox = ((ToolStripComboBox)comboBox).ComboBox;
                else
                    return;

                int width = senderComboBox.Width;
                g = senderComboBox.CreateGraphics();
                font = senderComboBox.Font;

                //checks if a scrollbar will be displayed.
                //If yes, then get its width to adjust the size of the drop down list.
                int vertScrollBarWidth =
                    (senderComboBox.Items.Count > senderComboBox.MaxDropDownItems)
                    ? SystemInformation.VerticalScrollBarWidth : 0;

                int newWidth;
                for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
                {
                    if (dt.Rows[nRow]["F_Name"] != null)
                    {
                        string strInfo = dt.Rows[nRow]["F_Name"].ToString();
                        newWidth = (int)g.MeasureString(strInfo.Trim(), font).Width + 10 + vertScrollBarWidth;
                        if (width < newWidth)
                            width = newWidth;   //set the width of the drop down list to the width of the largest item.
                    }
                }
                senderComboBox.DropDownWidth = width;
            }
            catch
            { }
            finally
            {
                if (g != null)
                    g.Dispose();
            }
        }
        #endregion
    }
}