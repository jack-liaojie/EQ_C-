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

namespace AutoSports.OVRGeneralData
{
    public partial class OVRDisciplineVenueEditForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }
        public string m_strLanguageCode = "";
        public OVRModuleBase module = null;

        private DataTable m_dtDiscipline = new DataTable();

        public OVRDisciplineVenueEditForm()
        {
            InitializeComponent();

            Localization();
            InitGridStyle();
        }

        private void cmbDiscipline_SelectionChangeCommitted(object sender, EventArgs e)
        {
            int iDisciplineID = Convert.ToInt32(cmbDiscipline.SelectedValue.ToString());
            ResetDisciplineVenueGrid(iDisciplineID, m_strLanguageCode);
        }

        private void btnAddDisVenue_Click(object sender, EventArgs e)
        {
            String strPromotion = "";
             int iDisciplineID;
            if(cmbDiscipline.SelectedIndex < 0)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "PromotionSelDiscipline");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }
            else
            {
                 iDisciplineID = Convert.ToInt32(cmbDiscipline.SelectedValue.ToString());
            }
            if(dgvAllVenues.SelectedRows.Count <= 0)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "PromotionSelVenue");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }

            int iColIdx = dgvAllVenues.Columns["ID"].Index;
            for (int i = 0; i < dgvAllVenues.SelectedRows.Count; i++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvAllVenues.SelectedRows[i];
                int iRowIdx = row.Index;

                int iVenueID = Convert.ToInt32(dgvAllVenues.Rows[iRowIdx].Cells[iColIdx].Value.ToString());

                AddDisciplineVenue(iDisciplineID, iVenueID);
            }
            ResetAllVenuesGrid(m_strLanguageCode);
            ResetDisciplineVenueGrid(iDisciplineID, m_strLanguageCode);
        }

        private void btnRemoveDisVenue_Click(object sender, EventArgs e)
        {
            String strPromotion = "";
            
            int iDisciplineID;
            if (cmbDiscipline.SelectedIndex < 0)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "PromotionSelDiscipline");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }
            else
            {
                iDisciplineID = Convert.ToInt32(cmbDiscipline.SelectedValue.ToString());
            }

            if (dgvDisciplineVenue.SelectedRows.Count <= 0)
            {
                strPromotion = LocalizationRecourceManager.GetString(this.Name, "PromotionSelVenue");
                DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                return;
            }

            int iColIdx = dgvDisciplineVenue.Columns["F_VenueID"].Index;
            for (int i = 0; i < dgvDisciplineVenue.SelectedRows.Count; i++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row = dgvDisciplineVenue.SelectedRows[i];
                int iRowIdx = row.Index;

                int iVenueID = Convert.ToInt32(dgvDisciplineVenue.Rows[iRowIdx].Cells[iColIdx].Value.ToString());
                RemoveDisciplineVenue(iDisciplineID, iVenueID);
            }
            ResetAllVenuesGrid(m_strLanguageCode);
            ResetDisciplineVenueGrid(iDisciplineID, m_strLanguageCode);
        }

        private void frmOVRDisciplineVenueEdit_FormClosed(object sender, FormClosedEventArgs e)
        {
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "frmOVRDisciplineVenueEdit");
            this.lbDiscipline.Text = LocalizationRecourceManager.GetString(this.Name, "lbDiscipline");
            this.btnAddDisVenue.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnAddDisVenue");
            this.btnRemoveDisVenue.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnRemoveDisVenue");
        }

        private void InitGridStyle()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvAllVenues);
            //dgvAllVenues.RowHeadersVisible = true;
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvDisciplineVenue);
            //dgvDisciplineVenue.RowHeadersVisible = true;
        }

        private void DisciplineVenueForm_Load(object sender, EventArgs e)
        {
            InitDisciplineCombo();
            ResetAllVenuesGrid(m_strLanguageCode);
        }

        private void InitDisciplineCombo()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get Discipline

                SqlCommand cmd = new SqlCommand("Proc_GetDisciplineList", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);
                #endregion

                m_dtDiscipline.Clear();
                SqlDataReader dr = cmd.ExecuteReader();
                m_dtDiscipline.Load(dr);
                dr.Close();

                cmbDiscipline.DisplayMember = "F_Name";
                cmbDiscipline.ValueMember = "F_Key";
                cmbDiscipline.DataSource = m_dtDiscipline;

                if(cmbDiscipline.Items.Count > 0)
                {
                    cmbDiscipline.SelectedItem = null;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void ResetAllVenuesGrid(String strLanguageCode)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get All Venues

                String strSQL;
                strSQL= String.Format(@"SELECt F_VenueLongName AS [Venue LongName], F_VenueShortName AS [Venue ShortName], F_VenueID AS [ID] FROM TC_Venue_Des  
                               WHERE F_LanguageCode = '{0}'", strLanguageCode);

                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgvAllVenues, dr, null, null);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }       
        }

        private void ResetDisciplineVenueGrid(int iDisciplineID, String strLanguageCode)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get Discipline Venues

                String strSQL;
                strSQL = String.Format(@"SELECT B.F_VenueLongName AS [Venue LongName], B.F_VenueShortName AS [Venue ShortName], A.F_VenueID, A.F_DisciplineID 
					                       FROM  TD_Discipline_Venue AS A LEFT JOIN TC_Venue_Des AS B ON A.F_VenueID = B.F_VenueID 
					                        WHERE B.F_LanguageCode = '{0}' AND A.F_DisciplineID = {1}", strLanguageCode, iDisciplineID);

                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgvDisciplineVenue, dr, null, null);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }       
        }

        private void AddDisciplineVenue(int iDisciplineID, int iVenueID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Add RegisterMember
                SqlCommand cmd = new SqlCommand("Proc_AddVenueIntoDiscipline", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@DisciplineID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                             DataRowVersion.Current, iDisciplineID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@VenueID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@VenueID",
                             DataRowVersion.Default, iVenueID);

                 SqlParameter cmdParameterResult = new SqlParameter(
                         "@Result", SqlDbType.Int, 4,
                         ParameterDirection.Output, false, 0, 0, "@Result",
                         DataRowVersion.Default, DBNull.Value);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "AddDisVenue_Failed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "AddDisVenue_FailedForDis");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "AddDisVenue_FailedForVenue");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    case -3:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "AddDisVenue_FailedForExists");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    default:
                        if (module != null)
                            module.DataChangedNotify(OVRDataChangedType.emVenueAdd, iDisciplineID, -1, -1, -1, iVenueID, null);
                        break;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void RemoveDisciplineVenue(int iDisciplineID, int iVenueID)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Add RegisterMember
                SqlCommand cmd = new SqlCommand("proc_DelVenueFromDiscipline", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@DisciplineID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                             DataRowVersion.Current, iDisciplineID);

                SqlParameter cmdParameter2 = new SqlParameter(
                             "@VenueID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@VenueID",
                             DataRowVersion.Default, iVenueID);

                SqlParameter cmdParameterResult = new SqlParameter(
                        "@Result", SqlDbType.Int, 4,
                        ParameterDirection.Output, false, 0, 0, "@Result",
                        DataRowVersion.Default, DBNull.Value);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "RemoveDisVenue_Failed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "RemoveDisVenue_FailedForMatch");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    default:
                        if (module != null)
                            module.DataChangedNotify(OVRDataChangedType.emVenueDel, iDisciplineID, -1, -1, -1, iVenueID, null);
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