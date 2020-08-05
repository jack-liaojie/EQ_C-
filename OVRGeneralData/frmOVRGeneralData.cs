using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRGeneralData
{
    public partial class OVRGeneralDataForm : UIPage//Office2007Form
    {
        private OVRGenDataModule m_genDataModule;
        private bool m_bUpdatingUI = false;

        public OVRGenDataModule GenDataModule
        {
            set { m_genDataModule = value; }
        }

        public OVRGeneralDataForm(string strName)
        {
            InitializeComponent();
            this.Name = "General Data";
            this.lbVenueSet.Text = ConfigurationManager.GetUserSettingString("Venue");
            this.Name = strName;

            //////////////////////////////////////////////////////////////////////////
            //Initial BasicInfo Tab Language And Grid Style
            BasicInfoLocalization();
            InitGridViewStyleInBasicInfo();

            //////////////////////////////////////////////////////////////////////////
            //Initial SystemSetting Tab Language And Grid Style
            SystemSettingLocalization();
            InitGridViewStyleInSystemSetting();
        }

        ////////////////////////////// Methods //////////////////////////////


        public void OnMainFrameEvent(object sender, OVRFrame2ModuleEventArgs e)
        {
            switch (e.Type)
            {
                case OVRFrame2ModuleEventType.emLoadData:
                {
                    LoadData();
                    break;
                }
                case OVRFrame2ModuleEventType.emUpdateData:
                {
                    UpdateData(e.Args as OVRDataChangedFlags);
                    break;
                }
                case OVRFrame2ModuleEventType.emRptContextQuery:
                {
                    QueryReportContext(e.Args as OVRReportContextQueryArgs);
                    break;
                }
            }
        }

        private void LoadData()
        {
            //Initial BasicInfo Tab
            BasicInfoTabLoad();
            //Initial SystemSetting Tab
            SystemSettingTabLoad();
        }

        private void UpdateData(OVRDataChangedFlags flags)
        {
            if (flags == null || !flags.HasSignal)
                return;

            // Check if Data Changed
            if (flags.IsSignaled(OVRDataChangedType.emEventStatus))
            {
                // Update Event Settings
                UpdateEventGrid();
                flags.Unsignal(OVRDataChangedType.emEventStatus);
            }
        }

        private void QueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;

            switch (args.Name)
            {
                case "SportID":
                    {
                        if (dgvSportInfo.Visible)
                        {
                            if (dgvSportInfo.SelectedRows.Count > 0)
                            {
                                args.Value = GetCurSelItemID(dgvSportInfo).ToString();
                                args.Handled = true;
                            }
                        }
                        else
                        {
                            args.Value = GetActiveSport().ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "DisciplineID":
                    {
                        if (dgvDisciplineInfo.Visible)
                        {
                            if (dgvDisciplineInfo.SelectedRows.Count > 0)
                            {
                                args.Value = GetCurSelItemID(dgvDisciplineInfo).ToString();
                                args.Handled = true;
                            }
                        }
                        else
                        {
                            args.Value = GetCurActivedDisciplineID().ToString();
                            args.Handled = true;
                        }
                        break;
                    }
                case "EventID":
                    {
                        if (dgvEventInfo.Visible && dgvEventInfo.SelectedRows.Count > 0)
                        {
                            args.Value = GetCurSelItemID(dgvEventInfo).ToString();
                            args.Handled = true;
                        }
                        break;
                    }
            }
        }

        private void OnGeneralDataLoad(object sender, EventArgs e)
        {
            LoadData();
        }

        public string GetCurActivedLanguageCode()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            string strSQLDes;
            strSQLDes = "SELECT F_LanguageCode FROM TC_Language WHERE F_Active = 1";
            SqlCommand cmd = new SqlCommand(strSQLDes, m_genDataModule.DatabaseConnection);

            string strLanguage = "";
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                strLanguage = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_LanguageCode");
            }
            dr.Close();
            return strLanguage;
        }

        public Int32 GetActiveSport()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            string strSQLDes;
            strSQLDes = "SELECT F_SportID FROM TS_Sport WHERE F_Active = 1";
            SqlCommand cmd = new SqlCommand(strSQLDes, m_genDataModule.DatabaseConnection);

            int iActiveInfo = 0;
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                iActiveInfo = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_SportID");
            }
            dr.Close();
            return iActiveInfo;
        }

        public Int32 GetCurActivedDisciplineID()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            SqlCommand cmdDiscipline = new SqlCommand("Proc_GetActiveDiscipline", m_genDataModule.DatabaseConnection);
            cmdDiscipline.CommandType = CommandType.StoredProcedure;
            SqlDataReader dr = cmdDiscipline.ExecuteReader();
            Int32 iDisciplineID = -1;
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    iDisciplineID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_DisciplineID");
                }
            }
            dr.Close();

            return iDisciplineID;
        }

        private void UpdateGridViewWithChk(DataGridView dgv, SqlDataReader sdr, int index, object trueValue, object falseValue)
        {
            m_bUpdatingUI = true;
            Int32 iCurSel = -1;
            if (dgv.SelectedRows.Count != 0)
                iCurSel = dgv.SelectedRows[0].Index;
            OVRDataBaseUtils.FillDataGridViewWithChk(dgv, sdr, 0, 1, 0);
            if (dgv.Columns["ID"] != null)
                dgv.Columns["ID"].Visible = false;

            while (iCurSel >= dgv.Rows.Count)
                iCurSel--;

            if (iCurSel != -1)
            {
                dgv.Rows[iCurSel].Selected = true;
                dgv.FirstDisplayedScrollingRowIndex = iCurSel;
            }
            m_bUpdatingUI = false;
        }

        private void UpdateGridViewWithChk(DataGridView dgv, DataTable dt, int index, object trueValue, object falseValue)
        {
            m_bUpdatingUI = true;
            Int32 iCurSel = -1;
            if (dgv.SelectedRows.Count != 0)
                iCurSel = dgv.SelectedRows[0].Index;
            OVRDataBaseUtils.FillDataGridViewWithChk(dgv, dt, 0, 1, 0);
            if (dgv.Columns["ID"] != null)
                dgv.Columns["ID"].Visible = false;

            while (iCurSel >= dgv.Rows.Count)
                iCurSel--;

            if (iCurSel != -1)
            {
                dgv.Rows[iCurSel].Selected = true;
                dgv.FirstDisplayedScrollingRowIndex = iCurSel;
            }
            m_bUpdatingUI = false;
        }

        private void UpdateGridView(DataGridView dgv, SqlDataReader sdr)
        {
            m_bUpdatingUI = true;
            Int32 iCurSel = -1;
            if (dgv.SelectedRows.Count != 0)
                iCurSel = dgv.SelectedRows[0].Index;
            OVRDataBaseUtils.FillDataGridView(dgv, sdr, null, null);
            if (dgv.Columns["ID"] != null)
                dgv.Columns["ID"].Visible = false;

            while (iCurSel >= dgv.Rows.Count)
                iCurSel--;

            if (iCurSel != -1)
            {
                dgv.Rows[iCurSel].Selected = true;
                dgv.FirstDisplayedScrollingRowIndex = iCurSel;
            }
            m_bUpdatingUI = false;
        }

        private void tabItemBasicInfo_Click(object sender, EventArgs e)
        {
            UpdateReportContext();
        }

        private void tabSystemSetting_Click(object sender, EventArgs e)
        {
            UpdateReportContext();
        }

        private void UpdateReportContext()
        {
            if (dgvSportInfo.Visible && dgvSportInfo.SelectedRows.Count > 0)
                m_genDataModule.SetReportContext("SportID", GetCurSelItemID(dgvSportInfo).ToString());
            else
                m_genDataModule.SetReportContext("SportID", GetActiveSport().ToString());

            if (dgvDisciplineInfo.Visible && dgvDisciplineInfo.SelectedRows.Count > 0)
                m_genDataModule.SetReportContext("DisciplineID", GetCurSelItemID(dgvDisciplineInfo).ToString());
            else
                m_genDataModule.SetReportContext("DisciplineID", GetCurActivedDisciplineID().ToString());

            if (dgvEventInfo.Visible && dgvEventInfo.SelectedRows.Count > 0)
                m_genDataModule.SetReportContext("EventID", GetCurSelItemID(dgvEventInfo).ToString());
            else
                m_genDataModule.SetReportContext("EventID", "-1");
        }

    }
}