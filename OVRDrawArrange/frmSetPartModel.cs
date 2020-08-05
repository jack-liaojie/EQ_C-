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
    public partial class SetPartModelForm : UIForm
    {
        public Int32 m_iNodeType { get; set; }//0 Phase 1 Match
        public Int32 m_iPhaseID { get; set; }
        public Int32 m_iMatchID { get; set; }

        public Int32 m_iOpearateTypeID { get; set; }
        public String m_strLanguageCode { get; set; }
        public SqlConnection m_DatabaseConnection { get; set; }
        private string m_strSectionName = "OVRDrawArrange";

        public SetPartModelForm()
        {
            InitializeComponent();
        }

        protected override void OnShown(EventArgs e)
        {
            base.OnShown(e);
            Localization();
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvModels);
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
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmSetPartModel");
            this.lbModelList.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbModelList");
            this.btnLoadModel.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnLoadModel");
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

        private void btnLoadModel_Click(object sender, EventArgs e)
        {
            Int32 iPhaseID;
            Int32 iMatchID;
            Int32 iPhaseModelID;
            Int32 iMatchModelID;
            Int32 iRow;
            if (dgvModels.SelectedRows == null || dgvModels.SelectedRows.Count == 0)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgLoadPartModel1"));
                return;
            }
            else
            {
                string message = LocalizationRecourceManager.GetString(m_strSectionName, "MsgLoadPartModel2");
                string caption = "Draw Arrange";
                MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                if (DevComponents.DotNetBar.MessageBoxEx.Show(message, caption, buttons, MessageBoxIcon.Question) == DialogResult.Yes)
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
                    oneSqlCommand.CommandText = "proc_LoadPhaseModel";
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
                    oneSqlCommand.CommandText = "Proc_LoadMatchModel";
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
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgLoadPartModel3"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        case 1://为LoadModel成功！
                            this.DialogResult = DialogResult.OK;
                            break;
                        case -1://Phase/Match Status is not allowed to Change Model!
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgLoadPartModel4"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        default://其余的为LoadModel失败！
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgLoadPartModel5"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Error);
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
    }
}