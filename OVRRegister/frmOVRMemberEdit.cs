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

namespace AutoSports.OVRRegister
{
    public partial class MemberEditForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public string   m_strRegisterID;
        public string   m_strDisciplineID = "";
	    public string   m_strGroupID = "";
        public string   m_strSexCode = "";
        public string   m_strLanguageCode = "";
        public string   m_strRegisterName = "";
        public int      m_iGroupType = 0;

        private bool    m_bModified = false;

        private DataTable m_dtGroup = new DataTable();
        private DataTable m_dtSex = new DataTable();

        public MemberEditForm(string strName)
        {
            InitializeComponent();

            this.Name = strName;

            //Initial Language And Grid Style
            InitGridStyle();
        }

        private void frmMemberEdit_Load(object sender, EventArgs e)
        {
            GetActiveDisciplineID();
            Localization();
            InitDelegationCobo();
            InitSexCombo();
            ResetMemberGrid();
            ResetRegisterGrid();

            lbTeamName.Text = m_strRegisterName;
        }

        private void MemberEditForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (m_bModified)
                this.DialogResult = DialogResult.OK;
        }
       
        #region User Interface Operation

        private void cmbGroup_SelectionChangeCommitted(object sender, EventArgs e)
        {
            ResetRegisterGrid();
        }

        private void cmbSex_SelectionChangeCommitted(object sender, EventArgs e)
        {
            ResetRegisterGrid();
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            AddMember();
        }

        private void btnRemove_Click(object sender, EventArgs e)
        {
            RemoveMember();
        }

        private void dgvMember_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex < 0 || e.RowIndex < 0)
                return;

            int iColumnIndex = e.ColumnIndex;
            int iRowIndex = e.RowIndex;
            String strColumnName = dgvMember.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvMember.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                string strInputVaule = "";
                int iInputKey = 0;
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    iInputKey = Convert.ToInt32(CurCell1.Tag);
                }
                else
                {
                    if(CurCell.Value != null)
                        strInputVaule = Convert.ToString(CurCell.Value);
                }

                int iRegisterID = Convert.ToInt32(m_strRegisterID);
                int iMemberID = Convert.ToInt32(dgvMember.Rows[iRowIndex].Cells["RegisterID"].Value);

                bool bResult = true;
                if (strColumnName.CompareTo("Function") == 0)
                {
                    bResult = UpdateMemberFunction(iRegisterID, iMemberID, iInputKey);
                }
                else if (strColumnName.CompareTo("Position") == 0)
                {
                    bResult = UpdateMemberPosition(iRegisterID, iMemberID, iInputKey);
                }
                else if (strColumnName.CompareTo("Order") == 0)
                {
                    bResult = UpdateMemberOrder(iRegisterID, iMemberID, strInputVaule);
                }
                else if (strColumnName.CompareTo("ShirtNumber") == 0)
                {
                    bResult = UpdateMemberShirtNum(iRegisterID, iMemberID, strInputVaule);
                }
                else if (strColumnName.CompareTo("Comment") == 0)
                {
                    bResult = UpdateMemberComment(iRegisterID, iMemberID, strInputVaule);
                }

                if (!bResult)
                {
                    int iSelIndex = e.RowIndex;
                    ResetMemberGrid();

                    if(dgvMember.Rows.Count > 0)
                    {
                        dgvMember.ClearSelection();
                        if (iSelIndex < 0 || iSelIndex > dgvMember.Rows.Count)
                        {
                            iSelIndex = 0;
                        }
                        dgvMember.Rows[iSelIndex].Selected = true;
                        dgvMember.FirstDisplayedScrollingRowIndex = iSelIndex;
                    }
                 
                }
            }
        }

        private void dgvMember_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            int iColumnIndex = e.ColumnIndex;
            if (e.RowIndex < 0 || e.RowIndex > dgvMember.RowCount)
                return;
            if (dgvMember.Rows[e.RowIndex].Cells["RegisterID"] == null)
                return;

            int iMemberID = Convert.ToInt32(dgvMember.Rows[e.RowIndex].Cells["RegisterID"].Value);
            if (dgvMember.Columns[iColumnIndex].Name.CompareTo("Function") == 0)
            {
                FillFunctionComboBox(iMemberID);
            }
            else if (dgvMember.Columns[iColumnIndex].Name.CompareTo("Position") == 0)
            {
                FillPositionComboBox();
            }
        }

        #endregion

        #region Assist Functions

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "EditMemberFrm");
            this.lbSex.Text = LocalizationRecourceManager.GetString(this.Name, "lbSex");
            SetGroupUIText();
        }

        private void SetGroupUIText()
        {
            if (m_iGroupType == 1)
            {
                this.lbGroup.Text = LocalizationRecourceManager.GetString(this.Name, "lbFederation");
            }
            else if (m_iGroupType == 2)
            {
                this.lbGroup.Text = LocalizationRecourceManager.GetString(this.Name, "lbNOC");
            }
            else if (m_iGroupType == 3)
            {
                this.lbGroup.Text = LocalizationRecourceManager.GetString(this.Name, "lbClub");
            }
            else if (m_iGroupType == 4)
            {
                this.lbGroup.Text = LocalizationRecourceManager.GetString(this.Name, "lbDelegation");
            }
        }

        private void InitGridStyle()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvAllRegister);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMember);
        }

        private void InitDelegationCobo()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get Group List
                SqlCommand cmd = new SqlCommand("Proc_GetActiveGroupInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                          "@DisciplineID", SqlDbType.Int, 0,
                           ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                          DataRowVersion.Current, m_strDisciplineID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguageCode);

                SqlParameter cmdParameter3 = new SqlParameter(
                          "@GroupType", SqlDbType.Int, 0,
                          ParameterDirection.Input, false, 0, 0, "@GroupType",
                          DataRowVersion.Current, m_iGroupType);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                SqlDataReader newdr = cmd.ExecuteReader();
                m_dtGroup.Load(newdr);
                newdr.Close();

                cmbGroup.DisplayMember = "Code";
                cmbGroup.ValueMember = "ID";
                cmbGroup.DataSource = m_dtGroup;

                if (cmbGroup.Items.Count > 0)
                {
                    if (m_strGroupID.Length != 0)
                        cmbGroup.SelectedValue = m_strGroupID;
                    else
                        cmbGroup.SelectedIndex = 0;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void InitSexCombo()
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
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);
                #endregion

                m_dtSex.Clear();
                SqlDataReader dr = cmd.ExecuteReader();
                m_dtSex.Load(dr);
                dr.Close();

                cmbSex.DisplayMember = "F_Name";
                cmbSex.ValueMember = "F_Key";
                cmbSex.DataSource = m_dtSex;
                
                if(cmbSex.Items.Count > 0)
                {
                    if (m_strSexCode.Length != 0)
                        cmbSex.SelectedValue = m_strSexCode;
                    else
                        cmbSex.SelectedIndex = 0;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void GetActiveDisciplineID()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

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
                        m_strDisciplineID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DisciplineID");
                    }
                }
                dr.Close();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
       
        private void ResetRegisterGrid()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }
           
            try
            {

                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("proc_GetAvailbleMember_With_Language", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@GroupID", SqlDbType.NVarChar, 9);
                SqlParameter cmdParameter2 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@SexCode", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter5 = new SqlParameter("@GroupType", SqlDbType.Int);


                m_strGroupID = cmbGroup.SelectedValue.ToString();
                m_strSexCode = cmbSex.SelectedValue.ToString();

                cmdParameter0.Value = Convert.ToInt32(m_strDisciplineID);
                cmdParameter1.Value = Convert.ToInt32(m_strGroupID);
                cmdParameter2.Value = Convert.ToInt32(m_strRegisterID);
                cmdParameter3.Value = Convert.ToInt32(m_strSexCode);
                cmdParameter4.Value = m_strLanguageCode;
                cmdParameter5.Value = m_iGroupType;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgvAllRegister, dr, null, null);
                dr.Close();

                SetGridStyle(dgvAllRegister);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }       
        }

        private void ResetMemberGrid()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Active Discipline
                string strDisciplineID = "0";
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

                #region DML Command Setup for Get Member
                int nRegisterID = Convert.ToInt32(m_strRegisterID);
                int nDisciplineID = Convert.ToInt32(strDisciplineID);

                SqlCommand cmd = new SqlCommand("Proc_GetMember_WithOrder", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter0.Value = Convert.ToInt32(strDisciplineID);
                cmdParameter1.Value = Convert.ToInt32(m_strRegisterID);
                cmdParameter2.Value = m_strLanguageCode;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgvMember, dr, 3, 4);
                dr.Close();

                SetGridStyle(dgvMember);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }         
        }

        private void SetGridStyle(DataGridView dgv)
        {
            dgv.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;

            if (dgv == dgvMember)
            {
                dgvMember.Columns[2].ReadOnly = false;
                dgvMember.Columns[5].ReadOnly = false;
                dgvMember.Columns[6].ReadOnly = false;
            }
        }

        private void AddMember()
        {
            int iColIdx = dgvAllRegister.Columns["MemberID"].Index;

            for (int i = 0; i < dgvAllRegister.SelectedRows.Count; i++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvAllRegister.SelectedRows[i];
                int iRowIdx = row.Index;

                string strPlayerID = dgvAllRegister.Rows[iRowIdx].Cells[iColIdx].Value.ToString();
                int nRegisterID, nMemberID;
                nRegisterID = Convert.ToInt32(m_strRegisterID);
                nMemberID = Convert.ToInt32(strPlayerID);
                AddRegisterMember(nRegisterID, nMemberID);
            }
            ResetRegisterGrid();
            ResetMemberGrid();

            if(dgvMember.Rows.Count > 0)
            {
                dgvMember.ClearSelection();

                int iSelRowIndex = dgvMember.Rows.Count - 1;
                dgvMember.Rows[iSelRowIndex].Selected = true;
                dgvMember.FirstDisplayedScrollingRowIndex = iSelRowIndex;
            }
        }

        private void RemoveMember()
        {
            int iColIdx = dgvMember.Columns["RegisterID"].Index;

            for (int i = 0; i < dgvMember.SelectedRows.Count; i++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvMember.SelectedRows[i];
                int iRowIdx = row.Index;

                string strPlayerID = dgvMember.Rows[iRowIdx].Cells[iColIdx].Value.ToString();
                int nRegisterID, nMemberID;
                nRegisterID = Convert.ToInt32(m_strRegisterID);
                nMemberID = Convert.ToInt32(strPlayerID);
                RemoveMember(nRegisterID, nMemberID);
            }
            ResetRegisterGrid();
            ResetMemberGrid();
        }

        private void FillFunctionComboBox(int iMemberID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Active Discipline
                string strDisciplineID = "0";
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

                int nDisciplineID = Convert.ToInt32(strDisciplineID);

                #endregion

                #region DML Command Setup for Register RegType
                string strRegType = "";
                string strSQL = string.Format("SELECT F_RegTypeID FROM TR_Register WHERE F_RegisterID = {0}", iMemberID);
                SqlCommand RegTypecmd = new SqlCommand(strSQL, sqlConnection);

                dr = RegTypecmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        strRegType = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_RegTypeID");
                    }
                }
                dr.Close();

                #endregion


                #region DML Command Setup for Fill Function combo

                SqlCommand cmd = new SqlCommand("Proc_GetFunctionInfo", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter2 = new SqlParameter("@RegType", SqlDbType.Int);

                cmdParameter0.Value = nDisciplineID;
                cmdParameter1.Value = m_strLanguageCode;
                if (strRegType.Length == 0)
                {
                    cmdParameter2.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter2.Value = Convert.ToInt32(strRegType);
                }
                

               
                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                dr = cmd.ExecuteReader();
                #endregion

                DataTable table = new DataTable();
                table.Columns.Add("F_Name", typeof(string));
                table.Columns.Add("F_Key", typeof(int));
                table.Load(dr);

                (dgvMember.Columns[3] as DGVCustomComboBoxColumn).FillComboBoxItems(table, "F_Name", "F_Key");
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void FillPositionComboBox()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Active Discipline
                string strDisciplineID = "0";
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

                int nDisciplineID = Convert.ToInt32(strDisciplineID);

                #region DML Command Setup for Fill position combo
                SqlCommand cmd = new SqlCommand("Proc_GetPosition", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter0.Value = nDisciplineID;
                cmdParameter1.Value = m_strLanguageCode;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                dr = cmd.ExecuteReader();
                #endregion


                DataTable table = new DataTable();
                table.Columns.Add("F_PositionLongName", typeof(string));
                table.Columns.Add("F_PositionID", typeof(int));
                table.Rows.Add("", "-1");
                table.Load(dr);

                (dgvMember.Columns[4] as DGVCustomComboBoxColumn).FillComboBoxItems(table, "F_PositionLongName", "F_PositionID");
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        #endregion

        #region DataBase Functions

        private void AddRegisterMember(int nRegisterID, int nMemberID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Find Member Basic Funciton

                int iFunctionID = 0;
                String strSQL = string.Format("SELECT F_FunctionID FROM TR_Register WHERE F_RegisterID = {0}", nMemberID);
                SqlCommand cmd_Func = new SqlCommand(strSQL, sqlConnection);

                SqlDataReader dr = cmd_Func.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        iFunctionID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, 0);
                    }
                }
                dr.Close();
                #endregion

                #region DML Command Setup for Add RegisterMember
                SqlCommand cmd = new SqlCommand("proc_AddMemberRegister_WithOrder", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@RegisterID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@RegisterID",
                             DataRowVersion.Current, nRegisterID);
               
                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MemberRegisterID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MemberRegisterID",
                             DataRowVersion.Default, nMemberID);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@FunctionID", SqlDbType.Int, 4);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@PositionID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@PositionID",
                             DataRowVersion.Default, DBNull.Value);

                SqlParameter cmdParameter5 = new SqlParameter(
                             "@Order", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@Order",
                             DataRowVersion.Default, DBNull.Value);

                SqlParameter cmdParameter6 = new SqlParameter(
                             "@ShirtNum", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@ShirtNum",
                             DataRowVersion.Default, DBNull.Value);

                SqlParameter cmdParameter7 = new SqlParameter(
                         "@Result", SqlDbType.Int, 4,
                         ParameterDirection.Output, false, 0, 0, "@Result",
                         DataRowVersion.Default, DBNull.Value);

                if (iFunctionID != 0)
                {
                    cmdParameter3.Value = iFunctionID;
                }
                else
                {
                    cmdParameter3.Value = DBNull.Value;
                }
                
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
                int nRetValue = (int)cmd.Parameters["@Result"].Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "AddMember_Failed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "AddMember_Team");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "AddMember_Pair");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    default:
                        m_bModified = true; 
                        break;
                }	
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void RemoveMember(int nRegisterID, int nMemberID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for RemoveMember
                SqlCommand cmd = new SqlCommand("proc_RemoveMemberRegister", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@RegisterID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@RegisterID",
                             DataRowVersion.Current, nRegisterID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@MemberRegisterID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@MemberRegisterID",
                             DataRowVersion.Default, nMemberID);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, DBNull.Value);

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
                    case -1:
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    default:
                        m_bModified = true;
                        break;
                }	
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }         
        }

        private bool UpdateMemberOrder(int nRegisterID, int nMemberID, string strOrder)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                string strSQL;
                if (strOrder.Length == 0)
                {
                    strSQL = String.Format("UPDATE TR_Register_Member SET F_Order = NULL WHERE F_MemberRegisterID = {0} AND F_RegisterID = {1} ", nMemberID, nRegisterID);
                }
                else
                {
                    int iOrder = -1;
                    try
                    {
                        iOrder = Convert.ToInt32(strOrder);
                    }
                    catch (System.Exception ex)
                    {
                        string strPromotion = LocalizationRecourceManager.GetString(this.Name, "Number_Msg");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    }
                    strSQL = String.Format("UPDATE TR_Register_Member SET F_Order = '{0}' WHERE F_MemberRegisterID = {1} AND F_RegisterID = {2} ", strOrder, nMemberID, nRegisterID);
                }
                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                cmd.ExecuteNonQuery();

                m_bModified = true;
                return true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }
        }

        private bool UpdateMemberFunction(int nRegisterID, int nMemberID, int nFunctionID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                string strSQL;
                if (nFunctionID == -1)
                {
                    strSQL = String.Format("UPDATE TR_Register_Member SET F_FunctionID = NULL WHERE F_MemberRegisterID = {0} AND F_RegisterID = {1} ", nMemberID, nRegisterID);
                }
                else
                {
                    strSQL = String.Format("UPDATE TR_Register_Member SET F_FunctionID = {0} WHERE F_MemberRegisterID = {1} AND F_RegisterID = {2} ", nFunctionID, nMemberID, nRegisterID);
                }
                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                cmd.ExecuteNonQuery();
               
                m_bModified = true;
                return true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }
        }

        private bool UpdateMemberPosition(int nRegisterID, int nMemberID, int nPositionID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                string strSQL;

                if (nPositionID == -1)
                {
                    strSQL = String.Format("UPDATE TR_Register_Member SET F_PositionID = NULL WHERE F_MemberRegisterID = {0} AND F_RegisterID = {1} ", nMemberID, nRegisterID);
                }
                else
                {
                    strSQL = String.Format("UPDATE TR_Register_Member SET F_PositionID = {0} WHERE F_MemberRegisterID = {1} AND F_RegisterID = {2} ", nPositionID, nMemberID, nRegisterID);
                }
                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                cmd.ExecuteNonQuery();

                m_bModified = true;
                return true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }
        }

        private bool UpdateMemberShirtNum(int nRegisterID, int nMemberID, string strShirtNum)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                string strSQL;
                if (strShirtNum.Length == 0)
                {
                    strSQL = String.Format("UPDATE TR_Register_Member SET F_ShirtNumber = NULL WHERE F_MemberRegisterID = {0} AND F_RegisterID = {1} ", nMemberID, nRegisterID);
                }
                else
                {
                    int iShirtNumber;
                    try
                    {
                        iShirtNumber = Convert.ToInt32(strShirtNum);
                    }
                    catch (System.Exception ex)
                    {
                        string strPromotion = LocalizationRecourceManager.GetString(this.Name, "Number_Msg");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    }

                    strSQL = String.Format("UPDATE TR_Register_Member SET F_ShirtNumber = '{0}' WHERE F_MemberRegisterID = {1} AND F_RegisterID = {2} ", strShirtNum, nMemberID, nRegisterID);
                }
                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                cmd.ExecuteNonQuery();

                m_bModified = true;
                return true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }
        }

        private bool UpdateMemberComment(int nRegisterID, int nMemberID, string strComment)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                string strSQL;
                if (strComment.Length == 0)
                {
                    strSQL = String.Format("UPDATE TR_Register_Member SET F_Comment = NULL WHERE F_MemberRegisterID = {0} AND F_RegisterID = {1} ", nMemberID, nRegisterID);
                }
                else
                {
                    strSQL = String.Format("UPDATE TR_Register_Member SET F_Comment = '{0}' WHERE F_MemberRegisterID = {1} AND F_RegisterID = {2} ", strComment, nMemberID, nRegisterID);
                }
                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                cmd.ExecuteNonQuery();

                m_bModified = true;
                return true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }
        }

        
        #endregion


    }
}