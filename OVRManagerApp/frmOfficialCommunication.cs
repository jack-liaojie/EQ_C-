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

namespace AutoSports.OVRManagerApp
{
    public partial class OVRCommunicationForm :UIPage
    {
        public event OVRModule2FrameEventHandler Module2FrameEvent = null;

        private int m_nDisciplineID;

        private string m_strVenueCode;
        public string VenueCode
        {
            get { return m_strVenueCode; }
            set { m_strVenueCode = value; }
        }

        private OVRReportInfo m_oReportInfoOfc;
        private OVRReportInfo m_oReportInfoOnDuty;
        private OVRReportInfo m_oReportInfoOffDuty;

        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        public OVRCommunicationForm()
        {
            InitializeComponent();

            m_oReportInfoOfc = new OVRReportInfo();
            m_oReportInfoOnDuty = new OVRReportInfo();
            m_oReportInfoOffDuty = new OVRReportInfo();

            OVRDataBaseUtils.SetDataGridViewStyle(dgvReportForDuty);
            OVRDataBaseUtils.SetDataGridViewStyle(dgvCommunication);

            dgvReportForDuty.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvReportForDuty.ReadOnly = false;
        }

        public void NotifyMainFrame(OVRModule2FrameEventType emType, object oArgs)
        {
            if (this.Module2FrameEvent != null)
            {
                this.Module2FrameEvent(this, new OVRModule2FrameEventArgs(emType, oArgs));
            }
        }

        public void DataChangedNotify(System.Collections.Generic.List<OVRDataChanged> changedList)
        {
            if (this.Module2FrameEvent != null)
            {
                OVRDataChangedNotifyArgs oArgs = new OVRDataChangedNotifyArgs();
                oArgs.ChangedList = changedList;
                this.Module2FrameEvent(this, new OVRModule2FrameEventArgs(OVRModule2FrameEventType.emDataChanged, oArgs));
            }
        }

        public void DataChangedNotify(OVRDataChangedType emType, int iDisciplineID, int iEventID,
                                      int iPhaseID, int iMatchID, object oID, string strData)
        {
            if (this.Module2FrameEvent != null)
            {
                OVRDataChangedNotifyArgs oArgs = new OVRDataChangedNotifyArgs();
                oArgs.ChangedList.Add(new OVRDataChanged(emType, iDisciplineID, iEventID, iPhaseID, iMatchID, oID, strData));

                this.Module2FrameEvent(this, new OVRModule2FrameEventArgs(OVRModule2FrameEventType.emDataChanged, oArgs));
            }
        }

        public void SetReportContext(string strName, string strValue)
        {
            if (this.Module2FrameEvent != null)
            {
                OVRReportContextChangedArgs oArgs = new OVRReportContextChangedArgs(strName, strValue);
                this.Module2FrameEvent(this, new OVRModule2FrameEventArgs(OVRModule2FrameEventType.emRptContextChanged, oArgs));
            }
        }

        private void CommunicationForm_Load(object sender, EventArgs e)
        {
            int nSportID;
            string strActiveLang;
            OVRCommon.OVRDataBaseUtils.GetActiveInfo(DatabaseConnection, out nSportID, out m_nDisciplineID, out strActiveLang);

            SetReportContext("DisciplineID", m_nDisciplineID.ToString());

            Localization();
            UpdateGridView();

            GetReportInfo();
        }

        private void GetReportInfo()
        {
            string strTemplateName;
            strTemplateName = ConfigurationManager.GetUserSettingString("TplCommunication");
            m_oReportInfoOfc.TemplateName = strTemplateName;

            strTemplateName = ConfigurationManager.GetUserSettingString("TplOnDuty");
            m_oReportInfoOnDuty.TemplateName = strTemplateName;

            strTemplateName = ConfigurationManager.GetUserSettingString("TplOffDuty");
            m_oReportInfoOffDuty.TemplateName = strTemplateName;

            // Query Official Communication Report Info
            OVRReportInfoQueryArgs oArgs = new OVRReportInfoQueryArgs();
            oArgs.Handled = false;
            oArgs.ReportInfo = m_oReportInfoOfc;
            NotifyMainFrame(OVRModule2FrameEventType.emReportInfoQuery, oArgs);

            // Query Official OnDuty Report Info
            oArgs.Handled = false;
            oArgs.ReportInfo = m_oReportInfoOnDuty;
            NotifyMainFrame(OVRModule2FrameEventType.emReportInfoQuery, oArgs);

            // Query Official OffDuty Report Info
            oArgs.Handled = false;
            oArgs.ReportInfo = m_oReportInfoOffDuty;
            NotifyMainFrame(OVRModule2FrameEventType.emReportInfoQuery, oArgs);

            // Update Communication Report User Interface
            chbCorrected.Checked = m_oReportInfoOfc.IsCorrected;
            chbTest.Checked = m_oReportInfoOfc.IsTest;
            tbRscCode.Text = m_oReportInfoOfc.RSC;
            tbRptType.Text = m_oReportInfoOfc.TemplateType;
            tbVersion.Text = m_oReportInfoOfc.TemplateVersion;
            tbDisVersion.Text = QueryDistrubutedVersion(m_oReportInfoOfc.TemplateType, m_oReportInfoOfc.RSC);

            // Update dgvReportForDuty
            DataGridViewColumn col = new DataGridViewTextBoxColumn();
            col.Name = "Report";
            col.HeaderText = "Report";
            col.ReadOnly = true;
            dgvReportForDuty.Columns.Add(col);
            col = new DataGridViewTextBoxColumn();
            col.Name = "Type";
            col.HeaderText = "Type";
            col.ReadOnly = true;
            dgvReportForDuty.Columns.Add(col);
            col = new DataGridViewTextBoxColumn();
            col.Name = "Version";
            col.HeaderText = "Version";
            col.ReadOnly = false;
            dgvReportForDuty.Columns.Add(col);
            col = new DataGridViewTextBoxColumn();
            col.Name = "Distrubuted Version";
            col.HeaderText = "Distrubuted Version";
            col.ReadOnly = true;
            dgvReportForDuty.Columns.Add(col);
            col = new DataGridViewTextBoxColumn();
            col.Name = "RSC";
            col.HeaderText = "RSC";
            col.ReadOnly = true;
            dgvReportForDuty.Columns.Add(col);

            DataGridViewRow dr = new DataGridViewRow();
            dr.CreateCells(dgvReportForDuty);
            dr.Selected = false;
            dr.Cells[0].Value = m_oReportInfoOnDuty.TemplateName;
            dr.Cells[1].Value = m_oReportInfoOnDuty.TemplateType;
            dr.Cells[2].Value = m_oReportInfoOnDuty.TemplateVersion;
            dr.Cells[3].Value = QueryDistrubutedVersion(m_oReportInfoOnDuty.TemplateType, m_oReportInfoOnDuty.RSC);
            dr.Cells[4].Value = m_oReportInfoOnDuty.RSC;
            dgvReportForDuty.Rows.Add(dr);

            dr = new DataGridViewRow();
            dr.CreateCells(dgvReportForDuty);
            dr.Selected = false;
            dr.Cells[0].Value = m_oReportInfoOffDuty.TemplateName;
            dr.Cells[1].Value = m_oReportInfoOffDuty.TemplateType;
            dr.Cells[2].Value = m_oReportInfoOffDuty.TemplateVersion;
            dr.Cells[3].Value = QueryDistrubutedVersion(m_oReportInfoOffDuty.TemplateType, m_oReportInfoOffDuty.RSC);
            dr.Cells[4].Value = m_oReportInfoOffDuty.RSC;
            dgvReportForDuty.Rows.Add(dr);
        }

        private void Localization()
        {
            string strSectionName = "OfficialCommunication";
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmOfficialCommunication");

            this.grpReportForDuty.Text = LocalizationRecourceManager.GetString(strSectionName, "grpReportForDuty");
            this.grpOfficialCom.Text = LocalizationRecourceManager.GetString(strSectionName, "grpOfficialCom");

            this.btnPreviewDuty.Text = LocalizationRecourceManager.GetString(strSectionName, "btnPreview");
            this.btnPrintToPdfDuty.Text = LocalizationRecourceManager.GetString(strSectionName, "btnPrintToPdf");
            this.btnPreview.Text = LocalizationRecourceManager.GetString(strSectionName, "btnPreview");
            this.btnPrintToPdf.Text = LocalizationRecourceManager.GetString(strSectionName, "btnPrintToPdf");
            this.lbRscCode.Text = LocalizationRecourceManager.GetString(strSectionName, "lbRscCode");
            this.lbRptType.Text = LocalizationRecourceManager.GetString(strSectionName, "lbRptType");
            this.lbVersion.Text = LocalizationRecourceManager.GetString(strSectionName, "lbVersion");
            this.lbDisVersion.Text = LocalizationRecourceManager.GetString(strSectionName, "lbDisVersion");
            this.chbCorrected.Text = LocalizationRecourceManager.GetString(strSectionName, "chbCorrected");
            this.chbTest.Text = LocalizationRecourceManager.GetString(strSectionName, "chbTest");

        }

        private void UpdateGridView()
        {
            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get Discipline Venues

                String strSQL;
                strSQL = String.Format(@"SELECT F_NewsID AS [ID], F_NewsItem AS [Item], F_SubTitle AS [SubTitle], F_Heading AS [Heading], F_Issued_by AS [IssuedBy], F_Date AS [Date]
					                       FROM  TS_Offical_Communication 
					                        WHERE F_DisciplineID = {0}", m_nDisciplineID);

                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgvCommunication, dr, null, null);
                dr.Close();

                dgvCommunication.Columns["ID"].Visible = false;
            }
            catch (System.Exception e)
            {
                UIMessageDialog.ShowMessageDialog(e.Message, "Information", false, this.Style);
            }       
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            OVROfficialItemForm frmOffcialItem = new OVROfficialItemForm(true, -1, sqlConnection);
            frmOffcialItem.m_iDisciplineID = m_nDisciplineID;
            frmOffcialItem.ShowDialog();

            if (frmOffcialItem.DialogResult == DialogResult.OK)
            {
                UpdateGridView();

                if (frmOffcialItem.m_iNewsID != -1)
                    DataChangedNotify(OVRDataChangedType.emOfficialComAdd, m_nDisciplineID, -1, -1, -1, frmOffcialItem.m_iNewsID, null);
            }
        }

        private void btnEdit_Click(object sender, EventArgs e)
        {
            if (dgvCommunication.SelectedRows.Count <= 0)
                return;

            int iSelRowsID = dgvCommunication.SelectedRows[0].Index;
            int iNewsID = Convert.ToInt32(dgvCommunication.Rows[iSelRowsID].Cells["ID"].Value);
            OVROfficialItemForm frmOffcialItem = new OVROfficialItemForm(false, iNewsID, sqlConnection);
            frmOffcialItem.m_iDisciplineID = m_nDisciplineID;
            frmOffcialItem.ShowDialog();

            if (frmOffcialItem.DialogResult == DialogResult.OK)
            {
                UpdateGridView();

                DataChangedNotify(OVRDataChangedType.emOfficialComModify, m_nDisciplineID, -1, -1, -1, frmOffcialItem.m_iNewsID, null);
            }
        }

        private void btnDel_Click(object sender, EventArgs e)
        {
            if (dgvCommunication.SelectedRows.Count <= 0)
                return;

            string strSectionName = "OfficialCommunication";
            string strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelete");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            int iSelRowsID = dgvCommunication.SelectedRows[0].Index;
            int iNewsID = Convert.ToInt32(dgvCommunication.Rows[iSelRowsID].Cells["ID"].Value);

            if (sqlConnection.State == System.Data.ConnectionState.Closed)
            {
                sqlConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get Discipline Venues

                String strSQL;
                strSQL = String.Format(@"Delete TS_Offical_Communication 
					                        WHERE F_NewsID = {0}", iNewsID);

                SqlCommand cmd = new SqlCommand(strSQL, sqlConnection);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgvCommunication, dr, null, null);
                dr.Close();
            }
            catch (System.Exception ex)
            {
                UIMessageDialog.ShowMessageDialog(ex.Message, "Information", false, this.Style);
            }
            UpdateGridView();

            DataChangedNotify(OVRDataChangedType.emOfficialComDel, m_nDisciplineID, -1, -1, -1, iNewsID, null);
        }

        private void dgvCommunication_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvCommunication.SelectedRows.Count <= 0)
                return;
            int iSelRowsID = dgvCommunication.SelectedRows[0].Index;
            int iNewsID = Convert.ToInt32(dgvCommunication.Rows[iSelRowsID].Cells["ID"].Value);

            string strNewsID = iNewsID.ToString();
            SetReportContext("NewsID", strNewsID);
        }

        private void chbCorrect_CheckedChanged(object sender, EventArgs e)
        {
            if (chbCorrected.Checked)
            {
                chbTest.Checked = false;
            }
        }

        private void chbTest_CheckedChanged(object sender, EventArgs e)
        {
            if (chbTest.Checked)
            {
                chbCorrected.Checked = false;
            }
        }

        private void btnPreview_Click(object sender, EventArgs e)
        {
            m_oReportInfoOfc.IsCorrected = chbCorrected.Checked;
            m_oReportInfoOfc.IsTest = chbTest.Checked;
            m_oReportInfoOfc.RSC = tbRscCode.Text;
            m_oReportInfoOfc.TemplateType = tbRptType.Text;
            m_oReportInfoOfc.TemplateVersion = tbVersion.Text;

            string strLang = "ENG";
            if (tbRptType.Text != null && 
                tbRptType.Text.Length > 0 && 
                tbRptType.Text.Substring(0, 1) == "Z") strLang = "CHI";

            m_oReportInfoOfc.ReportName = tbRscCode.Text + "_" + tbRptType.Text + "_" + tbVersion.Text;

            OVRDoReportArgs oArgs = new OVRDoReportArgs(OVRReportAction.emPreview, m_oReportInfoOfc);
            NotifyMainFrame(OVRModule2FrameEventType.emDoReport, oArgs);
        }

        private void btnPrintTpPdf_Click(object sender, EventArgs e)
        {
            m_oReportInfoOfc.IsCorrected = chbCorrected.Checked;
            m_oReportInfoOfc.IsTest = chbTest.Checked;
            m_oReportInfoOfc.RSC = tbRscCode.Text;
            m_oReportInfoOfc.TemplateType = tbRptType.Text;
            m_oReportInfoOfc.TemplateVersion = tbVersion.Text;

            string strLang = "ENG";
            if (tbRptType.Text != null &&
                tbRptType.Text.Length > 0 &&
                tbRptType.Text.Substring(0, 1) == "Z") strLang = "CHI";

            m_oReportInfoOfc.ReportName = tbRscCode.Text + "_" + tbRptType.Text + "_" + tbVersion.Text;

            OVRDoReportArgs oArgs = new OVRDoReportArgs(OVRReportAction.emPrintToPdf, m_oReportInfoOfc);
            NotifyMainFrame(OVRModule2FrameEventType.emDoReport, oArgs);
        }

        private void btnPreviewDuty_Click(object sender, EventArgs e)
        {
            if (dgvReportForDuty.SelectedRows.Count != 1)
                return;
            
            if (dgvReportForDuty.SelectedRows[0].Index == 0)
            {
                object obj = dgvReportForDuty.SelectedRows[0].Cells["Version"].Value;
                m_oReportInfoOnDuty.TemplateVersion = obj == null ? null : obj.ToString();

                string strLang = "ENG";
                if (m_oReportInfoOnDuty.TemplateType != null &&
                    m_oReportInfoOnDuty.TemplateType.Length > 0 &&
                    m_oReportInfoOnDuty.TemplateType.Substring(0, 1) == "Z") strLang = "CHI";

                m_oReportInfoOnDuty.ReportName = m_oReportInfoOnDuty.RSC + "." + m_oReportInfoOnDuty.TemplateType
                                                + "." + strLang + "." + m_oReportInfoOnDuty.TemplateVersion;

                OVRDoReportArgs oArgs = new OVRDoReportArgs(OVRReportAction.emPreview, m_oReportInfoOnDuty);
                NotifyMainFrame(OVRModule2FrameEventType.emDoReport, oArgs);
            }
            else if (dgvReportForDuty.SelectedRows[0].Index == 1)
            {
                object obj = dgvReportForDuty.SelectedRows[0].Cells["Version"].Value;
                m_oReportInfoOffDuty.TemplateVersion = obj == null ? null : obj.ToString();

                string strLang = "ENG";
                if (m_oReportInfoOffDuty.TemplateType != null &&
                    m_oReportInfoOffDuty.TemplateType.Length > 0 &&
                    m_oReportInfoOffDuty.TemplateType.Substring(0, 1) == "Z") strLang = "CHI";

                m_oReportInfoOffDuty.ReportName = m_oReportInfoOffDuty.RSC + "." + m_oReportInfoOffDuty.TemplateType
                                                + "." + strLang + "." + m_oReportInfoOffDuty.TemplateVersion;

                OVRDoReportArgs oArgs = new OVRDoReportArgs(OVRReportAction.emPreview, m_oReportInfoOffDuty);
                NotifyMainFrame(OVRModule2FrameEventType.emDoReport, oArgs);
            }
        }

        private void btnPrintTpPdfDuty_Click(object sender, EventArgs e)
        {
            if (dgvReportForDuty.SelectedRows.Count != 1)
                return;

            if (dgvReportForDuty.SelectedRows[0].Index == 0)
            {
                object obj = dgvReportForDuty.SelectedRows[0].Cells["Version"].Value;
                m_oReportInfoOnDuty.TemplateVersion = obj == null ? null : obj.ToString();

                string strLang = "ENG";
                if (m_oReportInfoOnDuty.TemplateType != null &&
                    m_oReportInfoOnDuty.TemplateType.Length > 0 &&
                    m_oReportInfoOnDuty.TemplateType.Substring(0, 1) == "Z") strLang = "CHI";

                m_oReportInfoOnDuty.ReportName = m_oReportInfoOnDuty.RSC + "." + m_oReportInfoOnDuty.TemplateType
                                                + "." + strLang + "." + m_oReportInfoOnDuty.TemplateVersion;

                OVRDoReportArgs oArgs = new OVRDoReportArgs(OVRReportAction.emPrintToPdf, m_oReportInfoOnDuty);
                NotifyMainFrame(OVRModule2FrameEventType.emDoReport, oArgs);
            }
            else if (dgvReportForDuty.SelectedRows[0].Index == 1)
            {
                object obj = dgvReportForDuty.SelectedRows[0].Cells["Version"].Value;
                m_oReportInfoOffDuty.TemplateVersion = obj == null ? null : obj.ToString();

                string strLang = "ENG";
                if (m_oReportInfoOffDuty.TemplateType != null &&
                    m_oReportInfoOffDuty.TemplateType.Length > 0 &&
                    m_oReportInfoOffDuty.TemplateType.Substring(0, 1) == "Z") strLang = "CHI";

                m_oReportInfoOffDuty.ReportName = m_oReportInfoOffDuty.RSC + "." + m_oReportInfoOffDuty.TemplateType
                                                + "." + strLang + "." + m_oReportInfoOffDuty.TemplateVersion;

                OVRDoReportArgs oArgs = new OVRDoReportArgs(OVRReportAction.emPrintToPdf, m_oReportInfoOffDuty);
                NotifyMainFrame(OVRModule2FrameEventType.emDoReport, oArgs);
            }
        }


        private string QueryDistrubutedVersion(string strTplType, string strRscCode)
        {
            string strDisVersion;

            strDisVersion = "";

            strDisVersion = strTplType + strRscCode;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = sqlConnection;
                oneSqlCommand.CommandText = "Proc_GetDistrubutedVersion";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@TplType", SqlDbType.NVarChar, 20,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strTplType);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@RscCode", SqlDbType.NVarChar, 50,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strRscCode);

                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (sqlConnection.State == System.Data.ConnectionState.Closed)
                {
                    sqlConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    if (sdr.Read())
                    {
                        strDisVersion = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_DistrubutedVersion");
                    }
                }
                sdr.Close();
            }
            catch (Exception ex)
            {
                UIMessageDialog.ShowMessageDialog(ex.Message, "Information", false, this.Style);
            }

            return strDisVersion;
        }

    }
}