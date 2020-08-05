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
using System.IO;
using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    public partial class frmModelInfo : UIForm
    {
        public Int32 m_iEventID { get; set; }
        public Int32 m_iOpearateTypeID { get; set; }
        public String m_strLanguageCode { get; set; }
        public SqlConnection m_DatabaseConnection { get; set; }
        private string m_strSectionName = "OVRDrawArrange";
        public Int32 m_iModelIDtoReplace = 0;
        public Int32 m_iOrdertoReplace = 0;
        public frmModelInfo()
        {
            InitializeComponent();
            Localization();
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvModels);
        }

        protected override void OnShown(EventArgs e)
        {
            base.OnShown(e);
            FillModels();
        }

        private void FillModels()
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetModels";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgvModels, sdr, "");
                sdr.Close();
                if (dgvModels.Columns["F_Order"] != null)
                {
                    dgvModels.Columns["F_Order"].ReadOnly = false;
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void btnSaveEventModel_Click(object sender, EventArgs e)
        {
            if (m_iModelIDtoReplace != 0)
            {
                try
                {
                    Int32 iResult;
                    SqlCommand oneSqlCommand = new SqlCommand();
                    oneSqlCommand.Connection = m_DatabaseConnection;
                    oneSqlCommand.CommandText = "proc_DelModelByID";
                    oneSqlCommand.CommandType = CommandType.StoredProcedure;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                 "@ModelID", SqlDbType.Int, 4,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, m_iModelIDtoReplace);
                    oneSqlCommand.Parameters.Add(cmdParameter1);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 4,
                                ParameterDirection.Output, true, 0, 0, "",
                                DataRowVersion.Current, 0);

                    oneSqlCommand.Parameters.Add(cmdParameterResult);

                    if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                    {
                        m_DatabaseConnection.Open();
                    }

                    if (oneSqlCommand.ExecuteNonQuery() != 0)
                    {
                        iResult = (Int32)cmdParameterResult.Value;
                        switch (iResult)
                        {
                            case 0:
                                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelEventModel3"));
                                break;
                            default://其余的需要为删除成功！
                                break;
                        }
                    }
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }

            try
            {
                Int32 iResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "proc_CopyModelFromEvent";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@ModelName", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextModelName.Text);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@ModelComment", SqlDbType.NVarChar, 200,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, TextModelComment.Text);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@Order", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, m_iOrdertoReplace);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@EventID", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, m_iEventID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iResult = (Int32)cmdParameterResult.Value;
                    switch (iResult)
                    {
                        case 0:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgSaveEventModel1"));
                            break;
                        default://其余的需要为添加成功！
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgSaveEventModel0"));
                            FillModels();
                            Int32 NewModelRow = FindRowNumberByModelID(iResult);
                            dgvModels.FirstDisplayedScrollingRowIndex = NewModelRow;
                            dgvModels.Rows[NewModelRow].Selected = true;
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private Int32 FindRowNumberByModelID(Int32 iModelID)
        {
            Int32 iCurrentModelID = 0;
            Int32 iRow;
            for (iRow = 0; iRow < dgvModels.RowCount; iRow++)
            {
                iCurrentModelID = Convert.ToInt32(dgvModels.Rows[iRow].Cells["F_ModelID"].Value);
                if (iCurrentModelID == iModelID)
                    return iRow;
            }

            return 0;
        }
       
        private void btnDelEventModel_Click(object sender, EventArgs e)
        {
            Int32 iModelID;
            Int32 iRow;
            if (dgvModels.SelectedRows == null || dgvModels.SelectedRows.Count == 0)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelEventModel1"));
                return;
            }
            else
            {
                string message = LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelEventModel2");
                string caption = "Draw Arrange";
                MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                if (DevComponents.DotNetBar.MessageBoxEx.Show(message, caption, buttons) == DialogResult.Yes)
                {
                    iRow = dgvModels.SelectedRows[0].Index;
                    iModelID = GetFieldValue(dgvModels, iRow, "F_ModelID");
                }
                else
                {
                    return;
                }
            }

            try
            {
                Int32 iResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "proc_DelModelByID";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@ModelID", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, iModelID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iResult = (Int32)cmdParameterResult.Value;
                    switch (iResult)
                    {
                        case 0:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelEventModel3"));
                            break;
                        default://其余的需要为删除成功！
                            FillModels();
                            Int32 iSelRow = iRow - 1;
                            if ((iSelRow >= 0) && (iSelRow < dgvModels.RowCount))
                            {
                                dgvModels.FirstDisplayedScrollingRowIndex = iSelRow;
                                dgvModels.Rows[iSelRow].Selected = true;
                            }

                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void btnCancle_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmModelInfo");
            this.btnSaveEventModel.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnSaveEventModel");
            this.btnDelEventModel.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnDelEventModel");
            this.lbModelComment.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbModelComment");
            this.lbModelName.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbModelName");
            this.lbModelList.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbModelList");
        }

        private Int32 GetFieldValue(DataGridView dgv, Int32 iRowIndex, String strFiledName)
        {
            Int32 iReturnValue = 0;
            if (dgv.Columns[strFiledName] == null || dgv.Rows[iRowIndex].Cells[strFiledName].Value.ToString() == "")
            {
                iReturnValue = 0;
            }
            else
            {
                iReturnValue = Convert.ToInt32(dgv.Rows[iRowIndex].Cells[strFiledName].Value);
            }
            return iReturnValue;
        }

        private String GetFieldStringValue(DataGridView dgv, Int32 iRowIndex, String strFiledName)
        {
            String iReturnValue = "";
            if (dgv.Columns[strFiledName] == null || dgv.Rows[iRowIndex].Cells[strFiledName].Value.ToString() == "")
            {
                iReturnValue = "";
            }
            else
            {
                iReturnValue = Convert.ToString(dgv.Rows[iRowIndex].Cells[strFiledName].Value);
            }
            return iReturnValue;
        }

        private void dgvModels_DoubleClick(object sender, EventArgs e)
        {
            Int32 iRow;
            String strModelName;
            String strModelComment;
            if (dgvModels.SelectedRows == null || dgvModels.SelectedRows.Count == 0)
            {
                return;
            }
            else
            {
                iRow = dgvModels.SelectedRows[0].Index;
                m_iModelIDtoReplace = GetFieldValue(dgvModels, iRow, "F_ModelID");
                m_iOrdertoReplace = GetFieldValue(dgvModels, iRow, "F_Order");
                strModelName = GetFieldStringValue(dgvModels, iRow, "F_ModelName");
                strModelComment = GetFieldStringValue(dgvModels, iRow, "F_ModelComment");
                TextModelName.Text = strModelName;
                TextModelComment.Text = strModelComment;
            }
        }

        private void dgvModels_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvModels.SelectedRows.Count < 1)
                return;
            m_iModelIDtoReplace = 0;
            m_iOrdertoReplace = 0;
            TextModelName.Text = null;
            TextModelComment.Text = null;
        }

        private void dgvModels_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;

            Int32 iModelID;

            String strColumnName = dgvModels.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvModels.Rows[iRowIndex].Cells[iColumnIndex];
            if (CurCell != null)
            {
                Int32 iInputValue = 0;

                String strInputString = "";

                if (CurCell.Value != null)
                {
                    strInputString = CurCell.Value.ToString();
                    try
                    {
                        iInputValue = Convert.ToInt32(CurCell.Value);
                    }
                    catch (System.Exception ex)
                    {
                        iInputValue = 0;
                    }
                }
                if (strColumnName.CompareTo("F_Order") == 0)
                {

                    iModelID = GetFieldValue(dgvModels, iRowIndex, "F_ModelID");
                    String strSql = "UPDATE TM_Model SET F_Order = " + iInputValue + " WHERE F_ModelID = " + iModelID;
                    try
                    {
                        SqlCommand oneSqlCommand = new SqlCommand();
                        oneSqlCommand.Connection = m_DatabaseConnection;
                        oneSqlCommand.CommandText = strSql;
                        oneSqlCommand.CommandType = CommandType.Text;
                        oneSqlCommand.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                    }
                }
            }
        }
    }
}