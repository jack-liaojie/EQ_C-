using System;
using System.Data;
using System.Windows.Forms;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

namespace AutoSports.OVRWRPlugin
{
    public partial class Weight : Form
    {
        string strOldweight = "";
        string strOldRemark = "";
        string strNewWeight = "";
        string strNewRemark = "";

        int EventID = 0;

        public Weight()
        {
            InitializeComponent();

            FillEventComboBox();
        }

        private DataTable m_dtEvent = new DataTable();

        private void FillEventComboBox()
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                #region DML Command Setup for Get Event

                SqlCommand cmd = new SqlCommand("Proc_WR_GetEventListByDisciplineCode", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = "ENG";
                cmd.Parameters.Add(cmdParameter1);
                #endregion

                m_dtEvent.Clear();
                SqlDataReader dr = cmd.ExecuteReader();
                m_dtEvent.Load(dr);
                dr.Close();

                cmbEvent.DisplayMember = "F_Name";
                cmbEvent.ValueMember = "F_Key";
                cmbEvent.DataSource = m_dtEvent;
                cmbEvent.SelectedIndex = 0;

                //AdjustComboBoxDropDownListWidth(cmbEvent, m_dtEvent);
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void cmbEvent_SelectedIndexChanged(object sender, EventArgs e)
        {
            int iEventID, nSelIdx;
            if (cmbEvent.SelectedItem == null)
                return;

            nSelIdx = cmbEvent.SelectedIndex;

            iEventID = Convert.ToInt32(cmbEvent.SelectedValue);
            if (iEventID < 0) return;
            EventID = iEventID;
            SetDataGridView(iEventID);
        }

        private void SetDataGridView(int iEventId)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                #region DML Command Setup for Get Event

                SqlCommand cmd = new SqlCommand("Proc_WR_GetWeight", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int);
                cmdParameter1.Value = iEventId;
                cmd.Parameters.Add(cmdParameter1);
                #endregion
                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgvWeight, dr, null, null);
                dr.Close();
                this.dgvWeight.Columns["Weight (kg)"].ReadOnly = false;
                this.dgvWeight.Columns["Remark"].ReadOnly = false;

            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void dgvWeight_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if(this.dgvWeight.Rows[e.RowIndex].Cells["Weight (kg)"].Value!=null)
                strOldweight = this.dgvWeight.Rows[e.RowIndex].Cells["Weight (kg)"].Value.ToString();
            if(this.dgvWeight.Rows[e.RowIndex].Cells["Remark"].Value!=null)
                strOldRemark = this.dgvWeight.Rows[e.RowIndex].Cells["Remark"].Value.ToString();
        }

        private void dgvWeight_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (this.dgvWeight.Rows[e.RowIndex].Cells["Weight (kg)"].Value != null)
                strNewWeight = this.dgvWeight.Rows[e.RowIndex].Cells["Weight (kg)"].Value.ToString();
            else strNewWeight = "0";

            if (this.dgvWeight.Rows[e.RowIndex].Cells["Remark"].Value != null)
                strNewRemark = this.dgvWeight.Rows[e.RowIndex].Cells["Remark"].Value.ToString();
            else 
                strNewRemark = "";

            if (strOldweight == strNewWeight && strOldRemark == strNewRemark)
                return;

            string NocCode = this.dgvWeight.Rows[e.RowIndex].Cells["NOC Code"].Value.ToString();
            string Name = this.dgvWeight.Rows[e.RowIndex].Cells["Name"].Value.ToString();

            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                SqlCommand cmd = new SqlCommand("Proc_WR_UpdatetWeight", GVAR.g_adoDataBase.DBConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int);
                cmdParameter1.Value = EventID;
                cmd.Parameters.Add(cmdParameter1);
                SqlParameter cmdParameter2 = new SqlParameter("@Noc", SqlDbType.NVarChar,3);
                cmdParameter2.Value = NocCode;
                cmd.Parameters.Add(cmdParameter2);
                SqlParameter cmdParameter3 = new SqlParameter("@Name", SqlDbType.NVarChar,50);
                cmdParameter3.Value = Name;
                cmd.Parameters.Add(cmdParameter3);
                SqlParameter cmdParameter4 = new SqlParameter("@Weight", SqlDbType.NVarChar,10);
                cmdParameter4.Value = strNewWeight;
                cmd.Parameters.Add(cmdParameter4);
                SqlParameter cmdParameter5 = new SqlParameter("@Reamrk", SqlDbType.NVarChar,20);
                cmdParameter5.Value = strNewRemark;
                cmd.Parameters.Add(cmdParameter5);

                cmd.ExecuteNonQuery();
                
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

        }

        private bool IsDNS(int w)
        {
            bool rtn = true;

            int max=1000, min=0;
            switch (EventID)
            {
                case 1:
                    max = 60;
                    break;
                case 2:
                    min=60;
                    max = 66;
                    break;
                case 3:
                    min = 66;
                    max = 73;
                    break;
                case 4:
                    min = 73;
                    max = 81;
                    break;
                case 5:
                    min = 81;
                    max = 90;
                    break;
                case 6:
                    min = 90;
                    max = 100;
                    break;
                case 7:
                    min = 100;
                    break;
                case 8:
                    break;
                case 9:
                    max = 48;
                    break;
                case 10:
                    min = 48;
                    max = 52;
                    break;
                case 11:
                    min = 52;
                    max = 57;
                    break;
                case 12:
                    min = 57;
                    max = 63;
                    break;
                case 13:
                    min = 63;
                    max = 70;
                    break;
                case 14:
                    min = 70;
                    max = 78;
                    break;
                case 15:
                    min = 78;
                    break;
                case 16:
                    break;

            }
            if (w < min || w > max || w == min)
                rtn = false;
            return rtn;
        }
    }
}
