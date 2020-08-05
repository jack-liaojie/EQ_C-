using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows;
using System.Windows.Forms;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

using DevComponents.DotNetBar;
using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    public partial class frmChosePhaseCompetitors : UIForm
    {
        private String m_strSectionName = "OVRDrawArrange";
        private System.Data.SqlClient.SqlConnection sqlConnection;

        private Int32 m_iEventID = 0;
        private Int32 m_iPhaseID = 0;
        private Int32 m_iNodeType = -100;
        private String m_strLanguageCode = "";

        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public frmChosePhaseCompetitors(Int32 iEventID, Int32 iPhaseID, Int32 iNodeType, String strLanguageCode)
        {
            InitializeComponent();
            Localization();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvEventCompetitors);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvPhaseCompetitors);
            this.dgvEventCompetitors.RowHeadersVisible = true;
            this.dgvPhaseCompetitors.RowHeadersVisible = true;

            m_iEventID = iEventID;
            m_iPhaseID = iPhaseID;
            m_iNodeType = iNodeType;
            m_strLanguageCode = strLanguageCode;
        }

        private void frmChosePhaseCompetitors_Load(object sender, EventArgs e)
        {
            ResetEventMember();
            ResetPhaseCompetitors();
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            Int32 iColIdx = dgvEventCompetitors.Columns["RegisterID"].Index;

            for (Int32 i = 0; i < dgvEventCompetitors.SelectedRows.Count; i++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvEventCompetitors.SelectedRows[i];
                Int32 iRowIdx = row.Index;

                string strRegisterID = dgvEventCompetitors.Rows[iRowIdx].Cells[iColIdx].Value.ToString();
                Int32 nRegisterID;
                nRegisterID = Convert.ToInt32(strRegisterID);
                AddPhaseCompetitors(m_iPhaseID, nRegisterID);
            }

            ResetEventMember();
            ResetPhaseCompetitors();
        }

        private void btnDel_Click(object sender, EventArgs e)
        {
            Int32 iColIdx = dgvPhaseCompetitors.Columns["RegisterID"].Index;

            for (Int32 i = 0; i < dgvPhaseCompetitors.SelectedRows.Count; i++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvPhaseCompetitors.SelectedRows[i];
                Int32 iRowIdx = row.Index;

                string strPlayerID = dgvPhaseCompetitors.Rows[iRowIdx].Cells[iColIdx].Value.ToString();
                Int32 nRegisterID;
                nRegisterID = Convert.ToInt32(strPlayerID);
                DelPhaseCompetitors(m_iPhaseID, nRegisterID);
            }

            ResetEventMember();
            ResetPhaseCompetitors();
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "titleChosePhaseCompetitors");
            this.lbEventPlayers.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbEventPlayers");
            this.lbPhasePlayers.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPhasePlayers");
        }

        private void ResetEventMember()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("proc_GetAvailbleCompetitorsForPhase", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@EventID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@PhaseID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@NodeType", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = m_iEventID;
                cmdParameter1.Value = m_iPhaseID;
                cmdParameter3.Value = m_iNodeType;
                cmdParameter2.Value = m_strLanguageCode;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgvEventCompetitors, dr, null, null);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void ResetPhaseCompetitors()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("proc_GetCompetitorsForPhase", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@EventID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@PhaseID", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@NodeType", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = m_iEventID;
                cmdParameter1.Value = m_iPhaseID;
                cmdParameter3.Value = m_iNodeType;
                cmdParameter2.Value = m_strLanguageCode;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter2);

                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgvPhaseCompetitors, dr, null, null);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void AddPhaseCompetitors(Int32 iPhaseID, Int32 iRegisterID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("proc_AddPhaseCompetitors", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@EventID",
                                                             DataRowVersion.Default, m_iEventID);
                SqlParameter cmdParameter2 = new SqlParameter("@PhaseID", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@PhaseID",
                                                             DataRowVersion.Default, m_iPhaseID);
                SqlParameter cmdParameter3 = new SqlParameter("@NodeType", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@NodeType",
                                                             DataRowVersion.Default, m_iNodeType);
                SqlParameter cmdParameter4 = new SqlParameter("@RegisterID", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@RegisterID",
                                                             DataRowVersion.Default, iRegisterID);
                SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int, 4,
                                                             ParameterDirection.Output, false, 0, 0, "@Result",
                                                             DataRowVersion.Default, DBNull.Value);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void DelPhaseCompetitors(Int32 iPhaseID, Int32 iRegisterID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("proc_DelPhaseCompetitors", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@EventID",
                                                             DataRowVersion.Default, m_iEventID);
                SqlParameter cmdParameter2 = new SqlParameter("@PhaseID", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@PhaseID",
                                                             DataRowVersion.Default, m_iPhaseID);
                SqlParameter cmdParameter3 = new SqlParameter("@NodeType", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@NodeType",
                                                             DataRowVersion.Default, m_iNodeType);
                SqlParameter cmdParameter4 = new SqlParameter("@RegisterID", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@RegisterID",
                                                             DataRowVersion.Default, iRegisterID);
                SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int, 4,
                                                             ParameterDirection.Output, false, 0, 0, "@Result",
                                                             DataRowVersion.Default, DBNull.Value);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                Int32 nRetValue = (Int32)cmd.Parameters["@Result"].Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelPhaseCompetitorsFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    default:
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
