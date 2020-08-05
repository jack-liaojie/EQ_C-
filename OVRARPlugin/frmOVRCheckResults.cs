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

namespace AutoSports.OVRARPlugin
{
    public partial class frmOVRCheckResults : Office2007Form
    {
        private System.Data.SqlClient.SqlConnection sqlConnection = GVAR.g_adoDataBase.DBConnect;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public int m_iMatchID;
        private string tmpCellValue = string.Empty;

        public frmOVRCheckResults()
        {
            InitializeComponent();

            Localization();
            InitGridStyle();
            InitControlData();
        }
        public frmOVRCheckResults(AR_MatchInfo curMatchInfo)
        {
            InitializeComponent();
            Localization();

            m_iMatchID = curMatchInfo.MatchID; 
            InitGridStyle();
            InitControlData();
        }

        private void OVRARAutoDrawForm_Load(object sender, EventArgs e)
        { 

        }

        private void OVRWLAutoDrawForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                if (this.Owner != null)
                    this.Owner.Activate();

                this.Visible = false;
                e.Cancel = true;
            }
        }

        #region Init Method
        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString("OVRARPlugin", "OVRARPlugin_OVRARDataEntryForm_labX_CheckTital");
        }

        private void InitGridStyle()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvRegister);
            dgvRegister.RowHeadersVisible = true;
        }

        private void InitControlData()
        {
            ResetRegisterGrid(false);
        } 

        #endregion
        
        #region Database Access Method
         
        public void ResetRegisterGrid(bool bUpdateSel)
        {
            int iSelIndex = -1;
            if (bUpdateSel)
            {
                if (dgvRegister.SelectedRows.Count > 0)
                    iSelIndex = dgvRegister.SelectedRows[0].Index;
            }

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get Register

                SqlCommand cmd = new SqlCommand("Proc_AR_GetCheckResults", sqlConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter1.Value = m_iMatchID;
                cmdParameter2.Value = GVAR.g_strLang;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgvRegister, dr, null, null);
                dr.Close();

                if (dgvRegister.Columns["F_MatchID"] != null)
                {
                    dgvRegister.Columns["F_MatchID"].Visible = false;
                }
                if (dgvRegister.Columns["F_CompetitionPosition"] != null)
                {
                    dgvRegister.Columns["F_CompetitionPosition"].Visible = false;
                } 
                if (dgvRegister.Rows.Count > 0)
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
          
        public int ModifyInscriptionValue(int nMatchID, int nComPosID, String strField, String strFieldValue)
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            String strFmt = @"UPDATE TS_Match_Result SET {0} = '{1}' WHERE F_CompetitionPosition = {2:D} AND F_MatchID = {3:D}";

            String strSQL = String.Format(strFmt, strField, strFieldValue, nComPosID, nMatchID);

            SqlCommand dbCommand = new SqlCommand(strSQL, sqlConnection);
            int nRet = -1;
            try
            {
                nRet = dbCommand.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                MessageBoxEx.Show(ex.Message.ToString());
            }

            return nRet;
        }

        #endregion
    }
}
