using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Xml;
using System.IO;

using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRManagerApp
{
    public partial class OVRReportPrintingForm : UIPage
    {
        private Stimulsoft.Report.StiReport m_stiReportRender;

        private string strSectionName = "MainFrame";

        private string m_strTplPath;
        private string m_strReportPath;
        private string m_strPrintPath;
        private string m_strStampCorrected;
        private string m_strStampTest;
        private bool m_bShowSystemVariables = false;
        private bool m_bShowAllTpl = false;
        private bool m_bTplPathExist = false;
        private bool m_bRptPathExist = false;
        private bool m_bPrtPathExist = false;

        private DataSet m_dsDataSet;
        private SqlConnection m_sqlConnection;
        private SqlCommand m_sqlCmd;
        private SqlDataAdapter m_sqlAdapter;

        private Int32 m_iSportID = 0;
        private Int32 m_iDisciplineID = 0;
        private String m_strLanguageCode = "CHN";

        private Stimulsoft.Report.Export.StiPdfExportSettings stiPdfExportSettings;
        private Stimulsoft.Report.Export.StiWord2007ExportSettings stiWordExportSettings;

        public event OVRReportGeneratedEventHandler m_EventReportGenerated;

        public event OVRReportContextQueryEventHandler m_EventReportContextQuery;
        private OVRReportContextChangedEventHandler m_HandlerReportContextChanged;
        public OVRReportContextChangedEventHandler ReportChangedQueryEventHandler
        {
            get { return this.m_HandlerReportContextChanged; }
        }

        private DataRow m_drCurTemplatesRow = null;

        private string m_strCurModuleName;
        private string m_strFirstInvalidSysVar = null;
        private List<String> m_lstSysVariables;

        public SqlConnection DBConnection
        {
            get { return m_sqlConnection; }
            set { m_sqlConnection = value; }
        }

        public OVRReportPrintingForm()
        {
            InitializeComponent();

            InitReportRender();

            m_dsDataSet = new DataSet();
            m_sqlCmd = new SqlCommand();
            m_sqlAdapter = new SqlDataAdapter(m_sqlCmd);
            m_HandlerReportContextChanged = new OVRReportContextChangedEventHandler(OnReportContextChanged);

            stiPdfExportSettings = new Stimulsoft.Report.Export.StiPdfExportSettings();
            stiPdfExportSettings.ImageQuality = 1.0f;
            stiPdfExportSettings.ImageResolution = 500.0f;
            m_stiReportRender.Exported += new Stimulsoft.Report.Events.StiExportEventHandler(OnReportExported);


            stiWordExportSettings = new Stimulsoft.Report.Export.StiWord2007ExportSettings();
            stiWordExportSettings.ImageQuality = 1.0f;
            stiWordExportSettings.ImageResolution = 500.0f;


            SetDataGridViewStyle(this.dgvReportsTpl);
            SetDataGridViewStyle(this.dgvReportsParam);
            ReportInfoSetup();
            Localization();

            this.chbGenerateDoc.Checked = true;

        }

        private void InitReportRender()
        {
            m_stiReportRender = new Stimulsoft.Report.StiReport();

            // 
            // stiReportRender
            // 
            m_stiReportRender.EngineVersion = Stimulsoft.Report.Engine.StiEngineVersion.EngineV2;
            m_stiReportRender.ReferencedAssemblies = new string[] {
                                                                        "System.Dll",
                                                                        "System.Drawing.Dll",
                                                                        "System.Windows.Forms.Dll",
                                                                        "System.Data.Dll",
                                                                        "System.Xml.Dll",
                                                                        "Stimulsoft.Controls.Dll",
                                                                        "Stimulsoft.Base.Dll",
                                                                        "Stimulsoft.Report.Dll"};
            m_stiReportRender.ReportAlias = "Report";
            m_stiReportRender.ReportGuid = "c9a06146753e4df8ad902fe18af5d646";
            m_stiReportRender.ReportName = "Report";
            m_stiReportRender.ReportSource = null;
            m_stiReportRender.ReportUnit = Stimulsoft.Report.StiReportUnitType.Centimeters;
            m_stiReportRender.ScriptLanguage = Stimulsoft.Report.StiReportLanguageType.CSharp;
            m_stiReportRender.UseProgressInThread = false;
        }

        #region Assist Functions

        public void Initialize()
        {
            GetSystemConfiguration();

            LoadTemplates();

            UpdateStampString();
        }

        public bool QueryReportInfo(OVRReportInfo oReportInfo)
        {
            if (oReportInfo == null)
                return false;

            string strTemplateName = oReportInfo.TemplateName;

            // Find Template in dgvReportsTpl
            string strExpression = String.Format("F_TplName = '{0}'", strTemplateName);
            DataRow[] drSelRows = m_dsDataSet.Tables["Templates"].Select(strExpression);
            if (drSelRows.Length < 1)
            {
                string strText = LocalizationRecourceManager.GetString(strSectionName, "NoTemplatesFound");
                string strCaption = LocalizationRecourceManager.GetString(strSectionName, "GenRptError");
                UIMessageDialog.ShowMessageDialog(strText + strTemplateName + ".mrt", strCaption, false, this.Style);
                return false;
            }

            DataRow drOldTemplatesRow = m_drCurTemplatesRow;
            m_drCurTemplatesRow = drSelRows[0];

            oReportInfo.RSC = QueryRscCode();
            oReportInfo.TemplateType = m_drCurTemplatesRow["F_TplType"].ToString();
            oReportInfo.TemplateVersion = m_drCurTemplatesRow["F_TplVersion"].ToString();
            oReportInfo.ReportName = oReportInfo.RSC + "." + oReportInfo.TemplateType + "." + oReportInfo.TemplateVersion;
            oReportInfo.IsCorrected = this.chbCorrected.Checked;
            oReportInfo.IsTest = this.chbTest.Checked;

            m_drCurTemplatesRow = drOldTemplatesRow;
            return true;
        }

        public void DoReport(OVRReportAction eAction, OVRReportInfo oReportInfo)
        {
            if (oReportInfo == null)
                return;

            string strTemplateName = oReportInfo.TemplateName;

            // Find Template in dgvReportsTpl
            string strExpression = String.Format("F_TplName = '{0}'", strTemplateName);
            DataRow[] drSelRows = m_dsDataSet.Tables["Templates"].Select(strExpression);
            if (drSelRows.Length < 1)
            {
                string strText = LocalizationRecourceManager.GetString(strSectionName, "NoTemplatesFound");
                string strCaption = LocalizationRecourceManager.GetString(strSectionName, "GenRptError");
                UIMessageDialog.ShowMessageDialog(strText + strTemplateName + ".mrt", strCaption, false, this.Style);
                return;
            }

            DataRow drOldTemplatesRow = m_drCurTemplatesRow;
            m_drCurTemplatesRow = drSelRows[0];

            if (!VarValueValidating())
            {
                string strTextItem;
                if (m_strFirstInvalidSysVar != null)
                    strTextItem = m_strFirstInvalidSysVar + "_Error";
                else
                    strTextItem = "InvdVarValue";

                string strText = LocalizationRecourceManager.GetString(strSectionName, strTextItem);
                string strCaption = LocalizationRecourceManager.GetString(strSectionName, "GenRptError");
                UIMessageDialog.ShowMessageDialog(strText, strCaption, false, this.Style);
                return;
            }

            if (oReportInfo.IsCorrected != chbCorrected.Checked || oReportInfo.IsTest != chbTest.Checked)
            {
                chbCorrected.Checked = oReportInfo.IsCorrected;
                chbTest.Checked = oReportInfo.IsTest;
                UpdateStampString();
            }

            switch (eAction)
            {
                case OVRReportAction.emPreview:
                    Preview(oReportInfo.ReportName, oReportInfo.TemplateVersion);
                    break;
                case OVRReportAction.emExportMdc:
                    ExportMdc(oReportInfo.ReportName, oReportInfo.TemplateVersion);
                    break;
                case OVRReportAction.emPrintToPdf:
                    PrintToPdf(oReportInfo.ReportName, oReportInfo.TemplateVersion);
                    break;
            }

            m_drCurTemplatesRow = drOldTemplatesRow;
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRReportSettingForm");
            this.btnPreview.Text = LocalizationRecourceManager.GetString(strSectionName, "btnPreview");
            this.btnPrintToPdf.Text = LocalizationRecourceManager.GetString(strSectionName, "btnPrintToPdf");
            this.lbRscCode.Text = LocalizationRecourceManager.GetString(strSectionName, "lbRscCode");
            this.lbRptType.Text = LocalizationRecourceManager.GetString(strSectionName, "lbRptType");
            this.lbVersion.Text = LocalizationRecourceManager.GetString(strSectionName, "lbVersion");
            this.lbDisVersion.Text = LocalizationRecourceManager.GetString(strSectionName, "lbDisVersion");
            this.chbCorrected.Text = LocalizationRecourceManager.GetString(strSectionName, "chbCorrected");
            this.chbTest.Text = LocalizationRecourceManager.GetString(strSectionName, "chbTest");

            this._TplName.HeaderText = LocalizationRecourceManager.GetString(strSectionName, "_TplName");
            this._Parameters.HeaderText = LocalizationRecourceManager.GetString(strSectionName, "_Parameters");
            this._ParamType.HeaderText = LocalizationRecourceManager.GetString(strSectionName, "_ParamType");
            this._ParamValue.HeaderText = LocalizationRecourceManager.GetString(strSectionName, "_ParamValue");
        }

        private void GetSystemConfiguration()
        {
            // System Initialize
            float flQuality, flResolution;
            string strQuality = ConfigurationManager.GetUserSettingString("PdfImageQuality").Trim();
            string strResolution = ConfigurationManager.GetUserSettingString("PdfImageResolution").Trim();
            if (float.TryParse(strQuality, out flQuality))
            {
                stiPdfExportSettings.ImageQuality = flQuality;
            }
            if (float.TryParse(strResolution, out flResolution))
            {
                stiPdfExportSettings.ImageResolution = flResolution;
            }

            string strAppDir = System.IO.Path.GetDirectoryName(Application.ExecutablePath);

            m_strTplPath = ConfigurationManager.GetUserSettingString("TplPath").Trim();
            m_bTplPathExist = System.IO.Directory.Exists(m_strTplPath);
            if (m_strTplPath.Length == 0 || m_strTplPath.ToLower() == "default")
            {
                m_strTplPath = strAppDir + "\\Template";
                m_bTplPathExist = System.IO.Directory.Exists(m_strTplPath);
            }

            m_strReportPath = ConfigurationManager.GetUserSettingString("RptPath").Trim();
            m_bRptPathExist = System.IO.Directory.Exists(m_strReportPath);
            if (m_strReportPath.Length == 0 || m_strReportPath.ToLower() == "default")
            {
                m_strReportPath = strAppDir + "\\Report";
                m_bRptPathExist = System.IO.Directory.Exists(m_strReportPath);
            }

            m_strPrintPath = ConfigurationManager.GetUserSettingString("PrtPath").Trim();
            m_bPrtPathExist = System.IO.Directory.Exists(m_strPrintPath);

            m_strStampCorrected = ConfigurationManager.GetUserSettingString("StampCorrected");
            m_strStampTest = ConfigurationManager.GetUserSettingString("StampTest");

            m_bShowSystemVariables = false;
            if ("1" == ConfigurationManager.GetUserSettingString("ShowSysVar").Trim())
                m_bShowSystemVariables = true;

            m_bShowAllTpl = false;
            if ("1" == ConfigurationManager.GetUserSettingString("ShowAllTpl").Trim())
                m_bShowAllTpl = true;

            string strValue = ConfigurationManager.GetUserSettingString("RptWndSize");
            try
            {
                int index = strValue.IndexOf(',', 0);
                if (index != -1)
                {
                    int iWidth = Convert.ToInt32(strValue.Substring(0, index));
                    int iHeight = Convert.ToInt32(strValue.Substring(index + 1));
                    this.Size = new System.Drawing.Size(iWidth, iHeight);
                }
            }
            catch (System.Exception ex)
            {
            }

            strValue = ConfigurationManager.GetUserSettingString("RptWndSplit");
            try
            {
                this.splitContainerTpl.SplitterDistance = Convert.ToInt32(strValue);
            }
            catch (System.Exception ex)
            {
            }

            // Create Directories
            try
            {
                if (m_strPrintPath != null && m_strPrintPath.Length != 0 && !m_bPrtPathExist)
                {
                    System.IO.Directory.CreateDirectory(m_strPrintPath);
                    m_bPrtPathExist = true;
                }
            }
            catch (System.Exception ex)
            {
                m_strPrintPath = null;
                m_bPrtPathExist = false;

                string strCaption = LocalizationRecourceManager.GetString(strSectionName, "PrtDirCreateFailed");
                UIMessageDialog.ShowMessageDialog(ex.Message, strCaption, false, this.Style);
            }
        }

        private void SetDataGridViewStyle(DataGridView dgv)
        {
            if (dgv == null) return;
            dgv.AlternatingRowsDefaultCellStyle.BackColor = System.Drawing.Color.FromArgb(202, 221, 238);
            dgv.DefaultCellStyle.BackColor = System.Drawing.Color.FromArgb(230, 239, 248);
            dgv.BackgroundColor = System.Drawing.Color.FromArgb(212, 228, 242);
            dgv.GridColor = System.Drawing.Color.FromArgb(208, 215, 229);
            dgv.BorderStyle = BorderStyle.Fixed3D;
            dgv.CellBorderStyle = DataGridViewCellBorderStyle.Single;
            dgv.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgv.RowHeadersVisible = false;
            dgv.ColumnHeadersHeight = 25;
            dgv.RowHeadersWidthSizeMode = DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            dgv.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            dgv.AllowUserToAddRows = false;
            dgv.AllowUserToDeleteRows = false;
            dgv.AllowUserToOrderColumns = false;
            dgv.AllowUserToResizeRows = false;
        }

        private void ReportInfoSetup()
        {
            // System Variables
            m_lstSysVariables = new List<string>();
            m_lstSysVariables.Add("SportID");
            m_lstSysVariables.Add("DisciplineID");
            m_lstSysVariables.Add("EventID");
            m_lstSysVariables.Add("PhaseID");
            m_lstSysVariables.Add("MatchID");
            m_lstSysVariables.Add("RegisterID");
            m_lstSysVariables.Add("RoundID");
            m_lstSysVariables.Add("DateID");
            m_lstSysVariables.Add("SessionID");
            m_lstSysVariables.Add("SplitID");
            m_lstSysVariables.Add("GroupID");
            m_lstSysVariables.Add("FederationID");
            m_lstSysVariables.Add("DelegationID");
            m_lstSysVariables.Add("ClubID");
            m_lstSysVariables.Add("NOCID");
            m_lstSysVariables.Add("NewsID");
            m_lstSysVariables.Add("VenueCode");
            m_lstSysVariables.Add("StampString");

            // Templates
            DataTable tbTemplates = new DataTable("Templates");
            tbTemplates.Columns.Add(new DataColumn("F_TplName", typeof(string)));
            tbTemplates.Columns.Add(new DataColumn("F_TplFullName", typeof(string)));
            tbTemplates.Columns.Add(new DataColumn("F_TplID", typeof(int)));
            tbTemplates.Columns.Add(new DataColumn("F_TplType", typeof(string)));
            tbTemplates.Columns.Add(new DataColumn("F_TplVersion", typeof(string)));
            tbTemplates.Columns.Add(new DataColumn("F_TplRscQueryString", typeof(string)));
            tbTemplates.Columns.Add(new DataColumn("F_TplPrintInG", typeof(int))); // General Data
            tbTemplates.Columns.Add(new DataColumn("F_TplPrintInR", typeof(int))); // Register
            tbTemplates.Columns.Add(new DataColumn("F_TplPrintInD", typeof(int))); // Draw Arrange
            tbTemplates.Columns.Add(new DataColumn("F_TplPrintInS", typeof(int))); // Match Schedule
            tbTemplates.Columns.Add(new DataColumn("F_TplPrintInE", typeof(int))); // Data Entry
            tbTemplates.Columns.Add(new DataColumn("F_TplPrintInM", typeof(int))); // Medal

            m_dsDataSet.Tables.Add(tbTemplates);

            DataView dvReportsTpl = new DataView(m_dsDataSet.Tables["Templates"]);
            dvReportsTpl.RowFilter = "F_TplID = '-1'";
            dgvReportsTpl.AutoGenerateColumns = false;
            dgvReportsTpl.DataSource = dvReportsTpl;

            // Template Parameters
            DataTable tbTplParameters = new DataTable("TplParameters");
            tbTplParameters.Columns.Add(new DataColumn("F_ParamName", typeof(string)));
            tbTplParameters.Columns.Add(new DataColumn("F_ParamAlias", typeof(string)));
            tbTplParameters.Columns.Add(new DataColumn("F_ParamType", typeof(string)));
            tbTplParameters.Columns.Add(new DataColumn("F_ParamValue", typeof(string)));
            tbTplParameters.Columns.Add(new DataColumn("F_TplID", typeof(int)));
            tbTplParameters.Columns.Add(new DataColumn("F_ParamTypeName", typeof(string)));
            tbTplParameters.Columns.Add(new DataColumn("F_IsSystemVar", typeof(int)));

            m_dsDataSet.Tables.Add(tbTplParameters);

            DataView dvTplVariable = new DataView(m_dsDataSet.Tables["TplParameters"]);
            dvTplVariable.RowFilter = "F_TplID = '-1'";
            dgvReportsParam.AutoGenerateColumns = false;
            dgvReportsParam.DataSource = dvTplVariable;
        }

        private string TransUnicode(string strValue)
        {
            // Replace Unicode Encoding to Unicode Char
            string strTranslated = strValue;
            string strUnicodeValue, strUnicode;
            int iSta, iEnd;
            while (true)
            {
                iSta = strTranslated.IndexOf("_x", 0);
                if (iSta == -1) break;

                iEnd = strTranslated.IndexOf("_", iSta + 2);
                if (iEnd == -1) break;

                strUnicodeValue = strTranslated.Substring(iSta, iEnd - iSta + 1);
                int value = Int32.Parse(strUnicodeValue.Trim('_', 'x'), System.Globalization.NumberStyles.HexNumber);
                strUnicode = Convert.ToChar(value).ToString();
                strTranslated = strTranslated.Replace(strUnicodeValue, strUnicode);
            }
            return strTranslated;
        }

        private void LoadTemplates()
        {
            if (!m_bTplPathExist)
            {
                string strCaption = LocalizationRecourceManager.GetString(strSectionName, "TplDirNotExist");
                UIMessageDialog.ShowMessageDialog(strCaption + ": \n" + m_strTplPath, strCaption, false, this.Style);
                return;
            }

            try
            {
                m_dsDataSet.Tables["Templates"].Clear();
                m_dsDataSet.Tables["TplParameters"].Clear();

                string[] strFiles = Directory.GetFiles(m_strTplPath, "*.mrt");
                XmlDocument xmlDoc = new XmlDocument();
                for (int i = 0; i < strFiles.Length; i++)
                {
                    string strReportName = Path.GetFileName(strFiles[i]);
                    strReportName = strReportName.Remove(strReportName.Length - 4);

                    DataRow drLst = m_dsDataSet.Tables["Templates"].NewRow();
                    drLst["F_TplName"] = strReportName;
                    drLst["F_TplFullName"] = strFiles[i];
                    drLst["F_TplID"] = i;
                    drLst["F_TplVersion"] = "1.0";

                    xmlDoc.Load(strFiles[i]);

                    XmlNodeList ndLstMsg = xmlDoc.SelectNodes("StiSerializer/Dictionary/Variables/child::*");
                    foreach (XmlNode nd in ndLstMsg)
                    {
                        // Format: ,Name,Alias,TypeName,Value,ReadOnly,Function
                        string str = nd.InnerText;
                        // Name
                        int iSta = str.IndexOf(",", 0) + 1;
                        int iEnd = str.IndexOf(",", iSta);
                        string strName = str.Substring(iSta, iEnd - iSta);
                        strName = TransUnicode(strName);
                        // Alias
                        iSta = iEnd + 1;
                        iEnd = str.IndexOf(",", iSta);
                        string strAlias = str.Substring(iSta, iEnd - iSta);
                        strAlias = TransUnicode(strAlias);
                        // TypeName
                        iSta = iEnd + 1;
                        iEnd = str.IndexOf(",", iSta);
                        string strTypeName = str.Substring(iSta, iEnd - iSta);
                        // Value
                        iSta = iEnd + 1;
                        iEnd = str.IndexOf(",", iSta);
                        string strValue = str.Substring(iSta, iEnd - iSta);
                        strValue = TransUnicode(strValue);
                        //// ReadOnly
                        //iSta = iEnd + 1;
                        //iEnd = str.IndexOf(",", iSta);
                        //string strReadOnly = str.Substring(iSta, iEnd - iSta);
                        //// Function
                        //iSta = iEnd + 1;
                        //iEnd = str.Length;
                        //string strFunction = str.Substring(iSta, iEnd - iSta);

                        string strType = strTypeName;
                        if (Type.GetType(strType) == null)
                        {
                            continue;
                        }

                        if (Nullable.GetUnderlyingType(Type.GetType(strType)) == null)
                        {
                            strType = Type.GetTypeCode(Type.GetType(strType)).ToString();
                        }
                        else
                        {
                            strType = Type.GetTypeCode(Nullable.GetUnderlyingType(Type.GetType(strType))).ToString() + "?";
                        }

                        if (strName == "ReportType")
                        {
                            drLst["F_TplType"] = strValue;
                        }
                        else if (strName == "RscQueryString")
                        {
                            drLst["F_TplRscQueryString"] = strValue.Trim();
                        }
                        else if (strName == "Version")
                        {
                            drLst["F_TplVersion"] = strValue.Trim();
                        }
                        else if (strName == "PrintIn")
                        {
                            if (strValue.IndexOf("M_G", 0) != -1)
                                drLst["F_TplPrintInG"] = 1;
                            else
                                drLst["F_TplPrintInG"] = 0;

                            if (strValue.IndexOf("M_R", 0) != -1)
                                drLst["F_TplPrintInR"] = 1;
                            else
                                drLst["F_TplPrintInR"] = 0;

                            if (strValue.IndexOf("M_D", 0) != -1)
                                drLst["F_TplPrintInD"] = 1;
                            else
                                drLst["F_TplPrintInD"] = 0;

                            if (strValue.IndexOf("M_S", 0) != -1)
                                drLst["F_TplPrintInS"] = 1;
                            else
                                drLst["F_TplPrintInS"] = 0;

                            if (strValue.IndexOf("M_E", 0) != -1)
                                drLst["F_TplPrintInE"] = 1;
                            else
                                drLst["F_TplPrintInE"] = 0;

                            if (strValue.IndexOf("M_M", 0) != -1)
                                drLst["F_TplPrintInM"] = 1;
                            else
                                drLst["F_TplPrintInM"] = 0;
                        }
                        else
                        {
                            DataRow drVar = m_dsDataSet.Tables["TplParameters"].NewRow();

                            drVar["F_ParamName"] = strName;
                            drVar["F_ParamAlias"] = strAlias;
                            drVar["F_ParamType"] = strType;
                            drVar["F_ParamValue"] = strValue;
                            drVar["F_TplID"] = i;
                            drVar["F_ParamTypeName"] = strTypeName;
                            drVar["F_IsSystemVar"] = IsSystemVariable(strName);

                            m_dsDataSet.Tables["TplParameters"].Rows.Add(drVar);
                        }
                    }

                    m_dsDataSet.Tables["Templates"].Rows.Add(drLst);
                }
            }
            catch (System.IO.DirectoryNotFoundException ex)
            {
                string strCaption = LocalizationRecourceManager.GetString(strSectionName, "TplDirNotExist");
                UIMessageDialog.ShowMessageDialog(ex.Message, strCaption, false, this.Style);
            }
            catch (System.Exception ex)
            {
                string strCaption = LocalizationRecourceManager.GetString(strSectionName, "LoadTplFailed");
                UIMessageDialog.ShowMessageDialog(ex.Message, strCaption, false, this.Style);
            }
        }

        private void UpdateReportContext()
        {
            if (m_EventReportContextQuery == null) return;

            // Query Report Context and Update System Variables
            OVRReportContextQueryArgs oArgs = new OVRReportContextQueryArgs();
            string strValue;
            foreach (string strName in m_lstSysVariables)
            {
                if (strName == "StampString" || strName == "NewsID" || strName == "VenueCode")
                    continue;

                oArgs.Name = strName;
                oArgs.Value = null;
                oArgs.Handled = false;

                m_EventReportContextQuery(this, oArgs);

                if (oArgs.Handled)
                    strValue = oArgs.Value;
                else
                    strValue = "-1";

                // Update System Variables
                foreach (DataRow dr in m_dsDataSet.Tables["TplParameters"].Rows)
                {
                    if (strName == dr["F_ParamName"].ToString())
                    {
                        dr["F_ParamValue"] = strValue;
                    }
                }
            }
        }

        private void SetReportContext(string strParamName, string strValue)
        {
            foreach (DataRow dr in m_dsDataSet.Tables["TplParameters"].Rows)
            {
                if (strParamName == dr["F_ParamName"].ToString())
                {
                    // Update RSC Code
                    if (dgvReportsTpl.SelectedRows.Count == 1 &&
                        m_drCurTemplatesRow["F_TplID"].ToString() == dr["F_TplID"].ToString() &&
                        dr["F_ParamValue"].ToString() != strValue)
                    {
                        dr["F_ParamValue"] = strValue;
                        tbRscCode.Text = QueryRscCode();
                        tbDisVersion.Text = QueryDistrubutedVersion(tbRptType.Text, tbRscCode.Text);
                    }
                    dr["F_ParamValue"] = strValue;
                }
            }
        }

        private void UpdateStampString()
        {
            if (chbCorrected.Checked)
            {
                SetReportContext("StampString", m_strStampCorrected);
            }
            else if (chbTest.Checked)
            {
                SetReportContext("StampString", m_strStampTest);
            }
            else
                SetReportContext("StampString", null);
        }

        private void UpdateReportTemplateList()
        {
            if (m_bShowAllTpl && ((DataView)dgvReportsTpl.DataSource).RowFilter != null)
            {
                ((DataView)dgvReportsTpl.DataSource).RowFilter = null;
                return;
            }

            string strFilterString = null;
            switch (m_strCurModuleName)
            {
                case "M_G":
                    strFilterString = "F_TplPrintInG = '1'";
                    break;
                case "M_R":
                    strFilterString = "F_TplPrintInR = '1'";
                    break;
                case "M_D":
                    strFilterString = "F_TplPrintInD = '1'";
                    break;
                case "M_S":
                    strFilterString = "F_TplPrintInS = '1'";
                    break;
                case "M_E":
                    strFilterString = "F_TplPrintInE = '1'";
                    break;
                case "M_M":
                    strFilterString = "F_TplPrintInM = '1'";
                    break;
                default:
                    strFilterString = "F_TplID = '-1'";
                    break;
            }
            ((DataView)dgvReportsTpl.DataSource).RowFilter = strFilterString;
        }

        private int IsSystemVariable(string strVarName)
        {
            int iResult = 0;

            foreach (string str in m_lstSysVariables)
            {
                if (str == strVarName)
                {
                    iResult = 1;
                    break;
                }
            }

            return iResult;
        }

        private void Preview(string strRptName, string strVersion)
        {
            // 1. Render Report
            if (!RenderReport(strRptName, strVersion))
                return;

            if (m_stiReportRender.CompiledReport != null)
                m_stiReportRender.CompiledReport.Exported += new Stimulsoft.Report.Events.StiExportEventHandler(OnReportExported);

            // 2. View Report
            m_stiReportRender.Show(true);

            if (m_stiReportRender.CompiledReport != null)
                m_stiReportRender.CompiledReport.Exported -= new Stimulsoft.Report.Events.StiExportEventHandler(OnReportExported);
        }

        private void ExportMdc(string strRptName, string strVersion)
        {
            // 1. Render Report
            if (!RenderReport(strRptName, strVersion))
                return;

            // 2. Save Report
            String strRptFullName = m_strReportPath + @"\" + strRptName + ".mdc";
            m_stiReportRender.SaveDocument(strRptFullName);
        }

        private void PrintToPdf(string strRptName, string strVersion)
        {
            string strTemp;
            if (!m_bPrtPathExist)
            {
                string strMsg = LocalizationRecourceManager.GetString(strSectionName, "PrtDirectoryInvalid");
                UIMessageDialog.ShowMessageDialog(strMsg, "Information", false, this.Style);
                return;
            }

            string strRptFullName = m_strPrintPath + @"\" + strRptName + ".pdf";
            string strWordFullName = m_strPrintPath + @"\" + strRptName + ".docx";

            if (System.IO.File.Exists(strRptFullName))
            {
                strTemp = LocalizationRecourceManager.GetString(strSectionName, "OverWriteFileExistOrNot");
                DialogResult res = DevComponents.DotNetBar.MessageBoxEx.Show(strTemp + "\n\r" + strRptFullName, null, MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation);

                if (res == DialogResult.No) return;
            }

            // zjy 2012-08-21
            // 生成Docx操作，属于影子操作，不用在界面上做任何的体现。不用询问是否覆盖已有的Docx文件。
            //if (System.IO.File.Exists(strWordFullName))
            //{
            //    strTemp = LocalizationRecourceManager.GetString(strSectionName, "OverWriteFileExistOrNot");
            //    DialogResult res = UIMessageDialog.ShowMessageDialog(strTemp + "\n\r" + strWordFullName, null, MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation);

            //    if (res == DialogResult.No) return;
            //}

            // 1. Render Report
            if (!RenderReport(strRptName, strVersion))
                return;

            // 2. Print To PDF
            // zjy 2012-08-21
            // 3. Print To Docx
            try
            {
                m_stiReportRender.ExportDocument(Stimulsoft.Report.StiExportFormat.Pdf, strRptFullName, stiPdfExportSettings);
                
                if (chbGenerateDoc.Checked == true)
                {
                    m_stiReportRender.ExportDocument(Stimulsoft.Report.StiExportFormat.Word2007, strWordFullName, stiWordExportSettings);
                }

                strTemp = LocalizationRecourceManager.GetString(strSectionName, "RptPdfExportSucceed");
                UIMessageDialog.ShowMessageDialog(strTemp + "\n\r" + strRptFullName, "Information", false, this.Style);
            }
            catch (System.Exception ex)
            {
                strTemp = LocalizationRecourceManager.GetString(strSectionName, "RptPdfExportFailed");
                UIMessageDialog.ShowMessageDialog(ex.Message, strTemp,  false, this.Style);
            }
        }

        private bool RenderReport(string strRptName, string strVersion)
        {
            if (m_drCurTemplatesRow == null) return false;

            string strTplFullName = m_drCurTemplatesRow["F_TplFullName"].ToString();
            string iSelReportID = m_drCurTemplatesRow["F_TplID"].ToString();

            this.Cursor = System.Windows.Forms.Cursors.WaitCursor;

            try
            {
                // 0. Clear Report Cache
                Stimulsoft.Report.StiReport.ClearImageCache();
                Stimulsoft.Report.StiReport.ClearReportCache();

                // 1. Load Report Template
                m_stiReportRender.Load(strTplFullName);
                m_stiReportRender.ReportName = strRptName;

                // 2.Set Report DB Connection
                foreach (Stimulsoft.Report.Dictionary.StiDatabase stiDb in m_stiReportRender.Dictionary.Databases)
                {
                    if (stiDb.Name == "ReportDB")
                    {
                        ((Stimulsoft.Report.Dictionary.StiSqlDatabase)stiDb).ConnectionString = m_sqlConnection.ConnectionString;
                    }
                }

                // 3. Replace Variables Value
                string strExpression = String.Format("F_TplID = '{0}'", iSelReportID);
                DataRow[] drSelRows = m_dsDataSet.Tables["TplParameters"].Select(strExpression);
                for (int i = 0; i < drSelRows.Length; i++)
                {
                    string strVarName = drSelRows[i]["F_ParamName"].ToString();
                    string strVarValue = drSelRows[i]["F_ParamValue"].ToString();

                    m_stiReportRender.Dictionary.Variables[strVarName].Value = strVarValue;
                }

                // 4. Update Template Version
                if (m_stiReportRender.Dictionary.Variables["Version"] != null)
                {
                    m_stiReportRender.Dictionary.Variables["Version"].Value = strVersion;
                }

                // 5. Render Report
                m_stiReportRender.Render(false);
            }
            catch (System.Exception ex)
            {
                UIMessageDialog.ShowMessageDialog(ex.Message, "Information", false, this.Style);
                this.Cursor = System.Windows.Forms.Cursors.Arrow;
                return false;
            }

            this.Cursor = System.Windows.Forms.Cursors.Arrow;
            return true;
        }

        private string QueryRscCode()
        {
            if (m_drCurTemplatesRow == null) return null;

            m_sqlCmd.Connection = m_sqlConnection;
            if (m_sqlConnection.State != ConnectionState.Open)
                m_sqlConnection.Open();

            // Generate Query String
            string iSelReportID = m_drCurTemplatesRow["F_TplID"].ToString();
            string strRscQueryString = m_drCurTemplatesRow["F_TplRscQueryString"].ToString();
            string strRscCode = null;
            string strVarName, strVarValue;
            while (true)
            {
                int iSta = strRscQueryString.IndexOf("{", 0);
                if (iSta == -1) break;

                int iEnd = strRscQueryString.IndexOf("}", iSta);
                if (iEnd == -1) break;

                // Replace Variables
                strVarName = strRscQueryString.Substring(iSta, iEnd - iSta + 1);

                string strExpression = String.Format("F_TplID = '{0}' AND F_ParamName = '{1}'", iSelReportID, strVarName.Trim('{', '}'));
                DataRow[] drSelRows = m_dsDataSet.Tables["TplParameters"].Select(strExpression);
                if (drSelRows.Length > 0)
                {
                    strVarValue = drSelRows[0]["F_ParamValue"].ToString();
                }
                else
                    strVarValue = "-1";

                strRscQueryString = strRscQueryString.Replace(strVarName, strVarValue);
            }

            // Query RSC Code
            m_sqlCmd.CommandText = strRscQueryString;

            if (strRscQueryString != null && strRscQueryString.Length > 0)
            {
                try
                {
                    DataTable dt = new DataTable();
                    m_sqlAdapter.Fill(dt);

                    if (dt.Columns.Count > 0 && dt.Rows.Count > 0)
                        strRscCode = dt.Rows[0][0].ToString();
                }
                catch (System.Exception ex)
                {
                    string strCaption = LocalizationRecourceManager.GetString(strSectionName, "RscCodeQueryError");
                    UIMessageDialog.ShowMessageDialog(ex.Message, strCaption, false, this.Style);
                }
            }

            return strRscCode;
        }

        private string QueryDistrubutedVersion(string strTplType, string strRscCode)
        {
            string strDisVersion;

            strDisVersion = "";

            strDisVersion = strTplType + strRscCode;
            SqlDataReader sdr = null;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_sqlConnection;
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

                if (m_sqlConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_sqlConnection.Open();
                }

                sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    if (sdr.Read())
                    {
                        strDisVersion = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_DistrubutedVersion");
                    }
                }
                sdr.Close();
                sdr = null;
            }
            catch (Exception ex)
            {
                UIMessageDialog.ShowMessageDialog(ex.Message, "Information", false, this.Style);
                if (sdr != null)
                {
                    sdr.Close();
                }
            }

            return strDisVersion;
        }

        private void TriggerReportGeneratedEvent(string strRptName, string strVersion)
        {
            if (m_EventReportGenerated == null) return;

            OVRReportGeneratedArgs oArgs = new OVRReportGeneratedArgs();

            string iSelReportID = m_drCurTemplatesRow["F_TplID"].ToString();
            string strExpression = String.Format("F_TplID = '{0}' AND F_IsSystemVar = '1'", iSelReportID);
            DataRow[] drSelRows = m_dsDataSet.Tables["TplParameters"].Select(strExpression);
            for (int i = 0; i < drSelRows.Length; i++)
            {
                try
                {
	                string strVarName = drSelRows[i]["F_ParamName"].ToString();
	                if (strVarName == "DisciplineID")
	                {
	                    oArgs.DisciplineID = Convert.ToInt32(drSelRows[i]["F_ParamValue"]);
	                }
                    else if (strVarName == "EventID")
                    {
                        oArgs.EventID = Convert.ToInt32(drSelRows[i]["F_ParamValue"]);
                    }
                    else if (strVarName == "PhaseID")
                    {
                        oArgs.PhaseID = Convert.ToInt32(drSelRows[i]["F_ParamValue"]);
                    }
                    else if (strVarName == "MatchID")
                    {
                        oArgs.MatchID = Convert.ToInt32(drSelRows[i]["F_ParamValue"]);
                    }
                }
                catch (System.Exception ex)
                {
                }
            }

            oArgs.ReportType = m_drCurTemplatesRow["F_TplType"].ToString();
            oArgs.Version = strVersion;
            oArgs.FileName = strRptName;
            oArgs.Comment = m_drCurTemplatesRow["F_TplName"].ToString();

            m_EventReportGenerated(this, oArgs);
        }

        private bool VarValueValidating()
        {
            if (m_drCurTemplatesRow == null) return true;

            // Validating Variables
            m_strFirstInvalidSysVar = null;
            bool bIsValid = true;
            string strVarName = null, strVarTypeName, strVarValue;
            string iSelReportID = m_drCurTemplatesRow["F_TplID"].ToString();
            string strExpression = String.Format("F_TplID = '{0}'", iSelReportID);
            DataRow[] drSelRows = m_dsDataSet.Tables["TplParameters"].Select(strExpression);
            for (int i = 0; i < drSelRows.Length; i++)
            {
                try
                {
                    strVarName = drSelRows[i]["F_ParamName"].ToString();
                    strVarTypeName = drSelRows[i]["F_ParamTypeName"].ToString();
                    strVarValue = drSelRows[i]["F_ParamValue"].ToString();

                    Convert.ChangeType(strVarValue, Type.GetType(strVarTypeName));
                }
                catch (System.Exception ex)
                {
                    bIsValid = false;

                    if (m_strFirstInvalidSysVar == null && IsSystemVariable(strVarName) == 1)
                        m_strFirstInvalidSysVar = strVarName;
                }
            }

            // Update dgvReportsParam ErrorText
            for (int i = 0; i < dgvReportsParam.Rows.Count; i++)
            {
                try
                {
                    strVarTypeName = dgvReportsParam.Rows[i].Cells["_ParamTypeName"].Value.ToString();
                    strVarValue = dgvReportsParam.Rows[i].Cells["_ParamValue"].Value.ToString();

                    Convert.ChangeType(strVarValue, Type.GetType(strVarTypeName));
                    dgvReportsParam.Rows[i].Cells["_ParamValue"].ErrorText = "";
                }
                catch (System.FormatException ex)
                {
                    dgvReportsParam.Rows[i].Cells["_ParamValue"].ErrorText = ex.Message;
                }
                catch (System.InvalidCastException ex)
                {
                    dgvReportsParam.Rows[i].Cells["_ParamValue"].ErrorText = ex.Message;
                }
                catch (System.ArgumentNullException ex)
                {
                    dgvReportsParam.Rows[i].Cells["_ParamValue"].ErrorText = ex.Message;
                }
            }

            return bIsValid;
        }

        private bool IsVarInCurTemplate(string strVarName)
        {
            if (m_drCurTemplatesRow == null) return false;

            string iSelReportID = m_drCurTemplatesRow["F_TplID"].ToString();
            string strExpression = String.Format("F_TplID = '{0}'", iSelReportID);
            DataRow[] drSelRows = m_dsDataSet.Tables["TplParameters"].Select(strExpression);
            for (int i = 0; i < drSelRows.Length; i++)
            {
                if (strVarName == drSelRows[i]["F_ParamName"].ToString())
                {
                    return true;
                }
            }

            return false;
        }

        #endregion

        #region Event Handlers

        protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
        {
            if (keyData == (Keys.Alt | Keys.G))
            {
                btnPrintToPdf_Click(null, null);

                return true;
            }
            if (keyData == (Keys.Alt | Keys.P))
            {
                btnPreview_Click(null, null);

                return true;
            }

            return base.ProcessCmdKey(ref msg, keyData);
        }

        public void OnCurModuleChanged(string strModuleName)
        {
            m_strCurModuleName = strModuleName;

            if (this.Visible)
            {
                UpdateReportContext();
                UpdateReportTemplateList();
            }
        }

        private void OnReportContextChanged(object sender, OVRReportContextChangedArgs args)
        {
            if (args == null) return;

            SetReportContext(args.Name, args.Value);

            if (IsVarInCurTemplate(args.Name))
            {
                VarValueValidating();
            }
        }

        private void OVRReportPrintingForm_Load(object sender, EventArgs e)
        {
            OVRDataBaseUtils.GetActiveInfo(m_sqlConnection, out m_iSportID, out m_iDisciplineID, out m_strLanguageCode);
        }

        private void OVRReportPrintingForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                if (this.Owner != null)
                    this.Owner.Activate();

                this.Visible = false;
                e.Cancel = true;
            }
        }

        private void OVRReportPrintingForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            ConfigurationManager.SetUserSettingString("RptWndSize", this.Size.Width.ToString() + ", " + this.Size.Height.ToString());
            ConfigurationManager.SetUserSettingString("RptWndSplit", this.splitContainerTpl.SplitterDistance.ToString());
        }

        private void OVRReportPrintingForm_VisibleChanged(object sender, EventArgs e)
        {
            if (this.Visible)
            {
                UpdateReportContext();
                UpdateReportTemplateList();
            }
        }

        private void OVRReportPrintingForm_Deactivate(object sender, EventArgs e)
        {
            dgvReportsParam.EndEdit();
        }

        private void dgvReportsTpl_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvReportsTpl.SelectedRows.Count != 1)
            {
                if (dgvReportsParam.DataSource != null)
                {
                    ((DataView)dgvReportsParam.DataSource).RowFilter = "F_TplID = '-1'";
                }
                return;
            }

            int iSelReportID = Convert.ToInt32(dgvReportsTpl.SelectedRows[0].Cells["_TplID"].Value);

            string strExpression = String.Format("F_TplID = '{0}'", iSelReportID);
            DataRow[] drSelRows = m_dsDataSet.Tables["Templates"].Select(strExpression);
            if (drSelRows.Length != 1) return;

            m_drCurTemplatesRow = drSelRows[0];

            string strFilterString;
            if (m_bShowSystemVariables)
                strFilterString = String.Format("F_TplID = '{0}'", iSelReportID);
            else
                strFilterString = String.Format("F_TplID = '{0}' AND F_IsSystemVar = '0'", iSelReportID);

            ((DataView)dgvReportsParam.DataSource).RowFilter = strFilterString;
            VarValueValidating();

            tbRptType.Text = m_drCurTemplatesRow["F_TplType"].ToString();
            tbVersion.Text = m_drCurTemplatesRow["F_TplVersion"].ToString();
            tbRscCode.Text = QueryRscCode();

            tbDisVersion.Text = QueryDistrubutedVersion(tbRptType.Text, tbRscCode.Text);

            // Update StampString
            if (chbCorrected.Checked)
            {
                chbCorrected.Checked = false;
                chbTest.Checked = false;
                UpdateStampString();
            }
        }

        private void dgvReportsParam_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex != dgvReportsParam.Columns["_ParamValue"].Index) return;

            string strVarTypeName = dgvReportsParam.Rows[e.RowIndex].Cells["_ParamTypeName"].Value.ToString();
            string strVarValue = e.FormattedValue.ToString();

            try
            {
                Convert.ChangeType(strVarValue, Type.GetType(strVarTypeName));
                dgvReportsParam.Rows[e.RowIndex].Cells["_ParamValue"].ErrorText = "";
            }
            catch (System.FormatException ex)
            {
                dgvReportsParam.Rows[e.RowIndex].Cells["_ParamValue"].ErrorText = ex.Message;
                // e.Cancel = true;
            }
            catch (System.InvalidCastException ex)
            {
                dgvReportsParam.Rows[e.RowIndex].Cells["_ParamValue"].ErrorText = ex.Message;
                // e.Cancel = true;
            }
            catch (System.ArgumentNullException ex)
            {
                dgvReportsParam.Rows[e.RowIndex].Cells["_ParamValue"].ErrorText = ex.Message;
                // e.Cancel = true;
            }
        }

        private void dgvReportsParam_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            string strParamName = "";

            if (e.RowIndex >= 0 && dgvReportsParam.Rows[e.RowIndex].Cells["_Parameters"].Value != null)
            {
                strParamName = dgvReportsParam.Rows[e.RowIndex].Cells["_Parameters"].Value.ToString();
            }

            if (strParamName == "DisciplineID" || strParamName == "EventID" ||
                strParamName == "PhaseID" || strParamName == "MatchID")
            {
                tbRscCode.Text = QueryRscCode();
                tbDisVersion.Text = QueryDistrubutedVersion(tbRptType.Text, tbRscCode.Text);
            }
        }

        private void btnPreview_Click(object sender, EventArgs e)
        {
            if (dgvReportsTpl.SelectedRows.Count != 1) return;

            int iSelReportID = Convert.ToInt32(dgvReportsTpl.SelectedRows[0].Cells["_TplID"].Value);
            string strExpression = String.Format("F_TplID = '{0}'", iSelReportID);
            DataRow[] drSelRows = m_dsDataSet.Tables["Templates"].Select(strExpression);
            if (drSelRows.Length != 1) return;

            m_drCurTemplatesRow = drSelRows[0];

            if (!VarValueValidating())
            {
                string strTextItem;
                if (m_strFirstInvalidSysVar != null)
                    strTextItem = m_strFirstInvalidSysVar + "_Error";
                else
                    strTextItem = "InvdVarValue";

                string strText = LocalizationRecourceManager.GetString(strSectionName, strTextItem);
                string strCaption = LocalizationRecourceManager.GetString(strSectionName, "GenRptError");
                UIMessageDialog.ShowMessageDialog(strText, strCaption, false, this.Style);
                return;
            }

            string strRptLang = "ENG";
            String strRptType, strUploadRptType;
            strRptType = tbRptType.Text;

            //OVRDataBaseUtils.GetReportUploadType(m_sqlConnection, m_iDisciplineID, strRptType, out strUploadRptType, out strRptLang);
            Preview(tbRscCode.Text + "_" + strRptType +  "_" + tbVersion.Text, tbVersion.Text);
        }

        private void btnPrintToPdf_Click(object sender, EventArgs e)
        {
            if (dgvReportsTpl.SelectedRows.Count != 1) return;

            int iSelReportID = Convert.ToInt32(dgvReportsTpl.SelectedRows[0].Cells["_TplID"].Value);
            string strExpression = String.Format("F_TplID = '{0}'", iSelReportID);
            DataRow[] drSelRows = m_dsDataSet.Tables["Templates"].Select(strExpression);
            if (drSelRows.Length != 1) return;

            m_drCurTemplatesRow = drSelRows[0];

            if (!VarValueValidating())
            {
                string strTextItem;
                if (m_strFirstInvalidSysVar != null)
                    strTextItem = m_strFirstInvalidSysVar + "_Error";
                else
                    strTextItem = "InvdVarValue";

                string strText = LocalizationRecourceManager.GetString(strSectionName, strTextItem);
                string strCaption = LocalizationRecourceManager.GetString(strSectionName, "GenRptError");
                UIMessageDialog.ShowMessageDialog(strText, strCaption,false, this.Style);
                return;
            }

            string strRptLang = "ENG";
            String strRptType, strUploadRptType;
            strRptType = tbRptType.Text;

            //OVRDataBaseUtils.GetReportUploadType(m_sqlConnection, m_iDisciplineID, strRptType, out strUploadRptType, out strRptLang);
            PrintToPdf(tbRscCode.Text + "_" + strRptType + "_" + tbVersion.Text, tbVersion.Text);
        }

        private void chbCorrect_CheckedChanged(object sender, EventArgs e)
        {
            if (chbCorrected.Checked)
            {
                chbTest.Checked = false;

                UpdateStampString();
            }
            else if (!chbTest.Checked)
            {
                UpdateStampString();
            }
        }

        private void chbTest_CheckedChanged(object sender, EventArgs e)
        {
            if (chbTest.Checked)
            {
                chbCorrected.Checked = false;

                UpdateStampString();
            }
            else if (!chbCorrected.Checked)
            {
                UpdateStampString();
            }
        }

        private void OnReportExported(object sender, Stimulsoft.Report.Events.StiExportEventArgs e)
        {
            Stimulsoft.Report.StiReport rpt = sender as Stimulsoft.Report.StiReport;
            if (rpt == null) return;

            if (e.ExportFormat == Stimulsoft.Report.StiExportFormat.Pdf)
            {
                TriggerReportGeneratedEvent(rpt.ReportName + ".pdf", rpt["Version"].ToString());
            }
        }


        #endregion

        private void panel1_Paint(object sender, PaintEventArgs e)
        {

        }

    }
}
