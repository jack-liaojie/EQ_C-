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

namespace AutoSports.OVRDrawArrange
{
    public partial class PartModelInfoForm : UIForm
    {
        public Int32 m_iNodeType { get; set; }//0 Phase 1 Match
        public Int32 m_iPhaseID { get; set; }
        public Int32 m_iMatchID { get; set; }

        public Int32 m_iOpearateTypeID { get; set; }
        public String m_strLanguageCode { get; set; }
        public SqlConnection m_DatabaseConnection { get; set; }
        private string m_strSectionName = "OVRDrawArrange";
        public Int32 m_iPhaseIDtoReplace = 0;
        public Int32 m_iMatchIDtoReplace = 0;
        public Int32 m_iModelIDtoReplace = 0;
        public Int32 m_iOrdertoReplace = 0;

        public PartModelInfoForm()
        {
            InitializeComponent();
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvModels);
        }

        protected override void OnShown(EventArgs e)
        {
            base.OnShown(e);
            Localization();
            FillModels();
        }

        private void FillModels()
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                if (m_iNodeType == 0)
                {
                    oneSqlCommand.CommandText = "Proc_GetPhaseModels";

                    SqlParameter cmdParameter1 = new SqlParameter(
                                 "@PhaseID", SqlDbType.Int, 4,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, m_iPhaseID);
                    oneSqlCommand.Parameters.Add(cmdParameter1);
                }
                else if (m_iNodeType == 1)
                {
                    oneSqlCommand.CommandText = "Proc_GetMatchModels";

                    SqlParameter cmdParameter1 = new SqlParameter(
                                 "@MatchID", SqlDbType.Int, 4,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, m_iMatchID);
                    oneSqlCommand.Parameters.Add(cmdParameter1);
                }

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgvModels, sdr, "");
                if (dgvModels.Columns["F_Order"] != null)
                {
                    dgvModels.Columns["F_Order"].ReadOnly = false;
                }
                sdr.Close();
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
            this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmPartModelInfo");
            this.btnSavePartModel.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnSavePartModel");
            this.btnDelPartModel.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnDelPartModel");
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

        private void btnSavePartModel_Click(object sender, EventArgs e)
        {
            //首先删除要覆盖的子模型
            if (m_iPhaseIDtoReplace != 0 || m_iMatchIDtoReplace != 0)
            {
                try
                {
                    Int32 iResult;
                    SqlCommand oneSqlCommand = new SqlCommand();
                    oneSqlCommand.Connection = m_DatabaseConnection;


                    if (m_iNodeType == 0 && m_iPhaseIDtoReplace != 0)
                    {
                        oneSqlCommand.CommandText = "proc_DelPhaseModel";
                        oneSqlCommand.CommandType = CommandType.StoredProcedure;

                        SqlParameter cmdParameter1 = new SqlParameter(
                                     "@PhaseID", SqlDbType.Int, 4,
                                     ParameterDirection.Input, true, 0, 0, "",
                                     DataRowVersion.Current, m_iPhaseIDtoReplace);
                        oneSqlCommand.Parameters.Add(cmdParameter1);

                        SqlParameter cmdParameter2 = new SqlParameter(
                                     "@PhaseModelID", SqlDbType.Int, 4,
                                     ParameterDirection.Input, true, 0, 0, "",
                                     DataRowVersion.Current, m_iModelIDtoReplace);
                        oneSqlCommand.Parameters.Add(cmdParameter2);

                    }
                    else if (m_iNodeType == 1 && m_iMatchIDtoReplace != 0)
                    {
                        oneSqlCommand.CommandText = "Proc_DelMatchModel";
                        oneSqlCommand.CommandType = CommandType.StoredProcedure;

                        SqlParameter cmdParameter1 = new SqlParameter(
                                     "@MatchID", SqlDbType.Int, 4,
                                     ParameterDirection.Input, true, 0, 0, "",
                                     DataRowVersion.Current, m_iMatchIDtoReplace);
                        oneSqlCommand.Parameters.Add(cmdParameter1);

                        SqlParameter cmdParameter2 = new SqlParameter(
                                     "@MatchModelID", SqlDbType.Int, 4,
                                     ParameterDirection.Input, true, 0, 0, "",
                                     DataRowVersion.Current, m_iModelIDtoReplace);
                        oneSqlCommand.Parameters.Add(cmdParameter2);
                    }

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
                                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelPartModel3"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                break;
                            default://其余的需要为删除成功！
                                //FillModels();
                                break;
                        }
                    }
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
            
            //真实的存储子模型
            try
            {
                Int32 iResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                if (m_iNodeType == 0)
                {
                    oneSqlCommand.CommandText = "Proc_SavePhaseModel";

                    SqlParameter cmdParameter0 = new SqlParameter(
                                 "@PhaseID", SqlDbType.Int, 4,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, m_iPhaseID);
                    oneSqlCommand.Parameters.Add(cmdParameter0);

                    SqlParameter cmdParameter1 = new SqlParameter(
                                 "@PhaseModelName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, TextModelName.Text);
                    oneSqlCommand.Parameters.Add(cmdParameter1);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                 "@PhaseModelComment", SqlDbType.NVarChar, 200,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, TextModelComment.Text);
                    oneSqlCommand.Parameters.Add(cmdParameter2);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                 "@Order", SqlDbType.Int, 4,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, m_iOrdertoReplace);
                    oneSqlCommand.Parameters.Add(cmdParameter3);

                }
                else
                {
                    oneSqlCommand.CommandText = "Proc_SaveMatchModel";

                    SqlParameter cmdParameter0 = new SqlParameter(
                                 "@MatchID", SqlDbType.Int, 4,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, m_iMatchID);
                    oneSqlCommand.Parameters.Add(cmdParameter0);

                    SqlParameter cmdParameter1 = new SqlParameter(
                                 "@MatchModelName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, TextModelName.Text);
                    oneSqlCommand.Parameters.Add(cmdParameter1);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                 "@MatchModelComment", SqlDbType.NVarChar, 200,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, TextModelComment.Text);
                    oneSqlCommand.Parameters.Add(cmdParameter2);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                 "@Order", SqlDbType.Int, 4,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, m_iOrdertoReplace);
                    oneSqlCommand.Parameters.Add(cmdParameter3);
                }

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
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgSavePartModel1"));
                            break;
                        default://其余的需要为添加成功！
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgSavePartModel0"));
                            FillModels();
                            Int32 iSelRow = FindRowNumberByModelID(iResult);
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

        private void btnDelPartModel_Click(object sender, EventArgs e)
        {
            Int32 iPhaseID;
            Int32 iMatchID;
            Int32 iPhaseModelID;
            Int32 iMatchModelID;
            Int32 iRow;
            if (dgvModels.SelectedRows == null || dgvModels.SelectedRows.Count == 0)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelPartModel1"));
                return;
            }
            else
            {
                string message = LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelPartModel2");
                string caption = "Draw Arrange";
                if (DevComponents.DotNetBar.MessageBoxEx.Show(message, caption, MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                {
                    iRow = dgvModels.SelectedRows[0].Index;
                    iPhaseID = GetFieldValue(dgvModels, iRow, "F_PhaseID");
                    iPhaseModelID = GetFieldValue(dgvModels, iRow, "F_PhaseModelID");
                    iMatchID = GetFieldValue(dgvModels, iRow, "F_MatchID");
                    iMatchModelID = GetFieldValue(dgvModels, iRow, "F_MatchModelID");
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


                if (m_iNodeType == 0)
                {
                    oneSqlCommand.CommandText = "proc_DelPhaseModel";
                    oneSqlCommand.CommandType = CommandType.StoredProcedure;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                 "@PhaseID", SqlDbType.Int, 4,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, iPhaseID);
                    oneSqlCommand.Parameters.Add(cmdParameter1);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                 "@PhaseModelID", SqlDbType.Int, 4,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, iPhaseModelID);
                    oneSqlCommand.Parameters.Add(cmdParameter2);

                }
                else if (m_iNodeType == 1)
                {
                    oneSqlCommand.CommandText = "Proc_DelMatchModel";
                    oneSqlCommand.CommandType = CommandType.StoredProcedure;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                 "@MatchID", SqlDbType.Int, 4,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, iMatchID);
                    oneSqlCommand.Parameters.Add(cmdParameter1);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                 "@MatchModelID", SqlDbType.Int, 4,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, iMatchModelID);
                    oneSqlCommand.Parameters.Add(cmdParameter2);
                }


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
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelPartModel3"),"Draw Arrange",MessageBoxButtons.OK, MessageBoxIcon.Error);
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

        private void dgvModels_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;

            Int32 iPhaseID;
            Int32 iPhaseModelID;
            Int32 iMatchID;
            Int32 iMatchModelID;

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
                    if (m_iNodeType == 0)
                    {
                        iPhaseID = GetFieldValue(dgvModels, iRowIndex, "F_PhaseID");
                        iPhaseModelID = GetFieldValue(dgvModels, iRowIndex, "F_PhaseModelID");
                        String strSql = "UPDATE TS_Phase_Model SET F_Order = " + iInputValue + " WHERE F_PhaseID = " + iPhaseID + " AND F_PhaseModelID = " + iPhaseModelID;
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
                    else if (m_iNodeType == 1)
                    {

                        iMatchID = GetFieldValue(dgvModels, iRowIndex, "F_MatchID");
                        iMatchModelID = GetFieldValue(dgvModels, iRowIndex, "F_MatchModelID");

                        String strSql = "UPDATE TS_Match_Model SET F_Order = " + iInputValue + " WHERE F_MatchID = " + iMatchID + " AND F_MatchModelID = " + iMatchModelID;
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

        private void btnRefresh_Click(object sender, EventArgs e)
        {
            FillModels();
        }

        private void dgvModels_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvModels.SelectedRows.Count < 1)
                return;
            m_iPhaseIDtoReplace = 0;
            m_iMatchIDtoReplace = 0;
            m_iModelIDtoReplace = 0;
            m_iOrdertoReplace = 0;
            TextModelName.Text = null;
            TextModelComment.Text = null;
        }

        private void dgvModels_DoubleClick(object sender, EventArgs e)
        {
            Int32 iRow;
            string strModelName = "";
            string strModelComment = "";
            if (dgvModels.SelectedRows == null || dgvModels.SelectedRows.Count == 0)
            {
                return;
            }
            else
            {
                iRow = dgvModels.SelectedRows[0].Index;
                if (m_iNodeType == 0)
                {
                    m_iPhaseIDtoReplace = GetFieldValue(dgvModels, iRow, "F_PhaseID");
                    m_iMatchIDtoReplace = 0;
                    m_iModelIDtoReplace = GetFieldValue(dgvModels, iRow, "F_PhaseModelID");
                    m_iOrdertoReplace = GetFieldValue(dgvModels, iRow, "F_Order");
                    strModelName = GetFieldStringValue(dgvModels, iRow, "F_PhaseModelName");
                    strModelComment = GetFieldStringValue(dgvModels, iRow, "F_PhaseModelComment");
                }
                else if (m_iNodeType == 1)
                {
                    m_iPhaseIDtoReplace = 0;
                    m_iMatchIDtoReplace = GetFieldValue(dgvModels, iRow, "F_MatchID");
                    m_iModelIDtoReplace = GetFieldValue(dgvModels, iRow, "F_MatchModelID");
                    m_iOrdertoReplace = GetFieldValue(dgvModels, iRow, "F_Order");
                    strModelName = GetFieldStringValue(dgvModels, iRow, "F_MatchModelName");
                    strModelComment = GetFieldStringValue(dgvModels, iRow, "F_MatchModelComment");
                }

                TextModelName.Text = strModelName;
                TextModelComment.Text = strModelComment;
            }
        }

        private Int32 FindRowNumberByModelID(Int32 iModelID)
        {
            Int32 iCurrentModelID = 0;
            Int32 iRow;
            string strColumnName = "";

            if (m_iNodeType == 0)
            {
                strColumnName = "F_PhaseModelID";
            }
            else
            {
                strColumnName = "F_MatchModelID";
            }

            for (iRow = 0; iRow < dgvModels.RowCount; iRow++)
            {
                iCurrentModelID = Convert.ToInt32(dgvModels.Rows[iRow].Cells[strColumnName].Value);
                if (iCurrentModelID == iModelID)
                    return iRow;
            }

            return 0;
        }

    }
}