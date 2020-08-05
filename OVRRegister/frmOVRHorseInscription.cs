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

namespace AutoSports.OVRRegister
{
    public partial class HorseInscriptionForm : UIForm
    {
        private String m_strSectionName = "OVRRegister";
        private System.Data.SqlClient.SqlConnection sqlConnection;

        private Int32 m_iEventID = -1;
        private Int32 m_iRegisterID = -1;
        private String m_strLanguageCode = "";

        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public HorseInscriptionForm(Int32 iEventID, Int32 iRegisterID, String strLanguageCode)
        {
            InitializeComponent();
            Localization();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvAvailableHorses);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvHorseInscription);
            this.dgvAvailableHorses.RowHeadersVisible = true;
            this.dgvHorseInscription.RowHeadersVisible = true;
            dgvAvailableHorses.MultiSelect = false;
            dgvHorseInscription.MultiSelect = false;

            m_iEventID = iEventID;
            m_iRegisterID = iRegisterID;
            m_strLanguageCode = strLanguageCode;
        }

        private void HorseInscriptionForm_Load(object sender, EventArgs e)
        {
            GetHorses();
            GetHorseInscription();
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            if(dgvAvailableHorses.SelectedRows.Count > 0)
            {
                string HorseID = dgvAvailableHorses.SelectedRows[0].Cells["HorseID"].Value.ToString();
                Int32 nHorseID;
                nHorseID = Convert.ToInt32(HorseID);
                HorseInscription(nHorseID ,m_iEventID, m_iRegisterID);
            }

            GetHorseInscription();
        }

        private void btnDel_Click(object sender, EventArgs e)
        {
            DelHorseInscription(m_iEventID,m_iRegisterID);
            GetHorseInscription();
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "titleChosePhaseCompetitors");
            this.lbHorses.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbEventPlayers");
            this.lbHorseInscription.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPhasePlayers");
        }

        private void GetHorses()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_EQ_GetRegisterAvailableHorses", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = m_iRegisterID;
                cmdParameter1.Value = m_strLanguageCode;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);

                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgvAvailableHorses, dr, null, null);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void GetHorseInscription()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailbleMember
                SqlCommand cmd = new SqlCommand("Proc_EQ_GetRegisterHorse", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@EventID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = m_iEventID;
                cmdParameter1.Value = m_iRegisterID;
                cmdParameter2.Value = m_strLanguageCode;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);

                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgvHorseInscription, dr, null, null);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void HorseInscription(Int32 iHorseID, Int32 iEventID, Int32 iRegisterID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            String strFmt, strSQL;

            try
            {
                #region DML Command Setup for Update MatchResultDetail

                strFmt = @"UPDATE TR_Inscription SET F_HorseID = {0}
                                WHERE F_EventID = {1} AND F_RegisterID = {2}";
                strSQL = String.Format(strFmt, iHorseID, iEventID, iRegisterID);

                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                cmd.ExecuteNonQuery();
                #endregion
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        public void DelHorseInscription(Int32 iEventID, Int32 iRegisterID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }
            String strFmt, strSQL;

            try
            {
                #region DML Command Setup for Update MatchResultDetail

                strFmt = @"UPDATE TR_Inscription SET F_HorseID = null
                                WHERE F_EventID = {0} AND F_RegisterID = {1}";
                strSQL = String.Format(strFmt, iEventID, iRegisterID);

                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                cmd.ExecuteNonQuery();
                #endregion
            }

            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
    }
}
