using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRGeneralData
{
    public partial class OVRVenueListForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        private string m_strSelVenueCode;
        public string VenueCode
        {
            get { return m_strSelVenueCode; }
        }

        public OVRVenueListForm()
        {
            InitializeComponent();

            OVRDataBaseUtils.SetDataGridViewStyle(dgvVenueList);
        }

        private void OVRVenueListForm_Load(object sender, EventArgs e)
        {
            Localization();

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            int iActiveSport, iActiveDiscipline;
            string strLanguageCode;
            OVRDataBaseUtils.GetActiveInfo(sqlConnection, out iActiveDiscipline, out iActiveDiscipline, out strLanguageCode);

            #region DML Command Setup for Get Discipline Venues

            String strSQL;
            strSQL = String.Format(@" SELECT 'NONE' AS [Venue]
                                       UNION
                                      SELECT  C.F_VenueCode + '('+ B.F_VenueLongName + ')' AS [Venue]
				                       FROM  TD_Discipline_Venue  AS  A 
                                        LEFT JOIN TC_Venue_Des  AS  B  ON  A.F_VenueID = B.F_VenueID 
                                        LEFT JOIN TC_Venue  AS  C  ON  A.F_VenueID = C.F_VenueID 
				                       WHERE B.F_LanguageCode = '{0}' AND A.F_DisciplineID = {1}", strLanguageCode, iActiveDiscipline);

            SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
            #endregion

            SqlDataReader dr = null;
            try
            {
                dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgvVenueList, dr, null, null);
                dr.Close();
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);

                if (dr != null && !dr.IsClosed)
                    dr.Close();
            }
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "frmOVRVenueList");
        }

        private void OVRVenueListForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (dgvVenueList.SelectedRows.Count > 0)
            {
                string strVenue = dgvVenueList.SelectedRows[0].Cells[0].Value.ToString();
                int iIndex = strVenue.IndexOf('(');

                if (iIndex != -1)
                    m_strSelVenueCode = strVenue.Substring(0, iIndex).Trim();
                else
                    m_strSelVenueCode = "NONE";
            }
            else
                m_strSelVenueCode = "NONE";
        }
    }
}
