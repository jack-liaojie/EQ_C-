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
    public partial class OVRCommentEditForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public int m_iRegisterID;
        public int m_iCommentID;
        public int m_iCommentOrder;
        public string m_strCommentTitle;
        public string m_strComment;
        private int m_iSelRowIdx = -1;

        private bool m_bModified = false;

        public OVRCommentEditForm(string strName)
        {
            InitializeComponent();

            this.Name = strName;
            Localization();
            InitGridStyle();
        }

        private void OVRCommentEditForm_Load(object sender, EventArgs e)
        {
            ResetCommetGrid();
           
            //Set Comment Grid Style
            dgvComment.Columns[0].ReadOnly = false;
            dgvComment.Columns[1].ReadOnly = false;
            dgvComment.Columns[2].ReadOnly = false;
        }

        private void OVRCommentEditForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (m_bModified)
                this.DialogResult = DialogResult.OK;
        }
    
        private void dgvComment_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            int iRowIndex = e.RowIndex;
            int iColIndex = e.ColumnIndex;
            if (iRowIndex < 0 || iRowIndex >= dgvComment.Rows.Count 
                || iColIndex < 0 || iColIndex >= dgvComment.Columns.Count)
                return;

           
            int iCommentID = Convert.ToInt32(dgvComment.Rows[iRowIndex].Cells["ID"].Value);
            string strOrder = "";
            string strTitle = "";
            string strComment = "";

            if(dgvComment.Rows[iRowIndex].Cells["Order"].Value != null)
            {
                strOrder = dgvComment.Rows[iRowIndex].Cells["Order"].Value.ToString();
            }
            if(dgvComment.Rows[iRowIndex].Cells["Title"].Value != null)
            {
                strTitle = dgvComment.Rows[iRowIndex].Cells["Title"].Value.ToString();
            }
            if(dgvComment.Rows[iRowIndex].Cells["Comment"].Value != null)
            {
                strComment = dgvComment.Rows[iRowIndex].Cells["Comment"].Value.ToString();
            }

            
            if(UpdateComment(iCommentID, m_iRegisterID, strOrder,strTitle,strComment))
            {
                m_iSelRowIdx = iRowIndex;
                ResetCommetGrid();
            }
            else
            {
                m_iSelRowIdx = iRowIndex;
                ResetCommetGrid();
            }
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            if(AddCommentInfo(m_iRegisterID))
            {
                m_iSelRowIdx = dgvComment.Rows.Count;
                ResetCommetGrid();
            }
        }

        private void btnDel_Click(object sender, EventArgs e)
        {
            int iSelRowCount = dgvComment.SelectedRows.Count;
            if(iSelRowCount <= 0)
                return;

            int iSelRowIdx = dgvComment.SelectedRows[0].Index;
            int iCommentID = Convert.ToInt32(dgvComment.Rows[iSelRowIdx].Cells["ID"].Value);

            if(DelCommentInfo(iCommentID))
            {
                if(iSelRowIdx == dgvComment.Rows.Count -1)
                {
                    m_iSelRowIdx = iSelRowIdx - 1;
                }
                else
                {
                    m_iSelRowIdx = iSelRowIdx;
                }
                ResetCommetGrid();
            }
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "CommentEditFrm");
            this.btnAdd.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnAddInfo");
            this.btnDel.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnDelInfo");
        }

        private void InitGridStyle()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvComment);
        }

        private void ResetCommetGrid()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Reset CommentGrid
                string strSQL = String.Format(@"SELECT F_Comment_Order AS [Order], F_Title AS [Title], F_Comment AS [Comment],F_CommentID AS [ID]
					                         FROM TR_Register_Comment WHERE F_RegisterID = {0}", m_iRegisterID);

                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                OVRDataBaseUtils.FillDataGridView(dgvComment, dr, null, null);
                dr.Close();

                if(dgvComment.Rows.Count > 0)
                {
                    if (m_iSelRowIdx < 0)
                    {
                        return;
                    }
                    else if (m_iSelRowIdx > dgvComment.RowCount - 1)
                    {
                        m_iSelRowIdx = dgvComment.RowCount - 1;
                    }
                    dgvComment.Rows[m_iSelRowIdx].Selected = true;
                    dgvComment.FirstDisplayedScrollingRowIndex = m_iSelRowIdx;
                }
              
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
          
        }

        private bool UpdateComment(int nCommentID,int nRegisterID, string strOrder,string strTitle,string strComment)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Update Comment
                SqlCommand cmd = new SqlCommand("Proc_EditComment", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@CommentID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@Order", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@Title", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter4 = new SqlParameter("@Comment", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameter0.Value = nCommentID;
                cmdParameter1.Value = nRegisterID;
                if (strOrder.Length == 0)
                {
                    cmdParameter2.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter2.Value = Convert.ToInt32(strOrder);
                }
                cmdParameter3.Value = strTitle;
                cmdParameter4.Value = strComment;
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
                int nRetValue = Convert.ToInt32(cmdParameter5.Value);
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "CommentEdit_ID");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "CommetEdit_Title");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -3:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "CommentEdit_PlayerID");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default:
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
      
        private bool AddCommentInfo(int nRegisterID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Add Comment
                SqlCommand cmd = new SqlCommand("proc_AddComment", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@Order", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@Title", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter4 = new SqlParameter("@Comment", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameter1.Value = nRegisterID;
                cmdParameter2.Value = DBNull.Value;
                cmdParameter3.Value = DBNull.Value;
                cmdParameter4.Value = DBNull.Value;
                cmdParameter5.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = Convert.ToInt32(cmdParameter5.Value);
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "CommetEdit_Title");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default:
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
      
        private bool DelCommentInfo(int nCommentID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Del Comment
                SqlCommand cmd = new SqlCommand("Proc_DelComment", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@CommentID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameter1.Value = nCommentID;
                cmdParameter2.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = Convert.ToInt32(cmdParameter2.Value);
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "CommentEdit_ID");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default:
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

    }
}