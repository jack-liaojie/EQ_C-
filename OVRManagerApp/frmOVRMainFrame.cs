using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Xml;

using DevComponents.DotNetBar;

using AutoSports.OVRCommon;
using AutoSports.OVRGeneralData;
using AutoSports.OVRRegister;
using AutoSports.OVRDrawArrange;
using AutoSports.OVRMatchSchedule;
using AutoSports.OVRPluginMgr;
using AutoSports.OVRRankMedal;
using AutoSports.OVRRecord;
using Sunny.UI;

namespace AutoSports.OVRManagerApp
{
    public partial class OVRMainFrameForm : UIForm
    {
        public enum EMainFormUIType
        {
            emUnknown = -1,
            emWndGeneralData = 0, // 基础数据
            emWndRegister,        // 报名报项
            emWndDrawArrange,	  // 抽签编排	
            emWndMatchSchedule,   // 比赛安排
            emWndPluginMgr,		  // 赛时数据
            emWndReports,	      // 报表管理
            emWndRankMedal,		  // 排名奖牌
            emWndBackupDB,		  // 数据库备份
            emWndCommunicate,	  // 官方公告
            emWndNetwork,		  // 网络功能
            emWndRecord 		  // 赛事纪录
        };

        private string strSectionName = "MainFrame";

        #region Module Members

        private OVRModuleBase m_ModuleGeneralData;
        private OVRModuleBase m_ModuleRegister;
        private OVRModuleBase m_ModuleDrawArrange;
        private OVRModuleBase m_ModuleMatchSchedule;
        private OVRModuleBase m_ModulePluginMgr;
        private OVRModuleBase m_ModuleRankMedal;
        private OVRModuleBase m_ModuleRecord;

        private OVRDataChangedFlags m_FlagsGeneralData;
        private OVRDataChangedFlags m_FlagsRegister;
        private OVRDataChangedFlags m_FlagsDrawArrange;
        private OVRDataChangedFlags m_FlagsMatchSchedule;
        private OVRDataChangedFlags m_FlagsPluginMgr;
        private OVRDataChangedFlags m_FlagsRankMedal;
        private OVRDataChangedFlags m_FlagsRecord;

        private event OVRFrame2ModuleEventHandler m_EventGeneralData;
        private event OVRFrame2ModuleEventHandler m_EventRegister;
        private event OVRFrame2ModuleEventHandler m_EventDrawArrange;
        private event OVRFrame2ModuleEventHandler m_EventMatchSchedule;
        private event OVRFrame2ModuleEventHandler m_EventPluginMgr;
        private event OVRFrame2ModuleEventHandler m_EventRankMedal;
        private event OVRFrame2ModuleEventHandler m_EventRecord;

        #endregion

        #region System Configurations

        private bool m_bIsServer;
        private string m_strServer;
        private int m_iPort;

        #endregion

        private OVRReportPrintingForm m_frmReportPrinting;
        private event OVRReportContextChangedEventHandler m_EventReportContextChanged;

        private bool m_bIsNetworkOpen;
        private OVRNetworkManagerForm m_frmNetworkManager;
        private OVRXmlMessagePacker m_xmlPacker;
        private string m_strVenueCode;
        private string m_strTplCommunication;

        private EMainFormUIType m_emMainFormUI;
        private List<int> m_lstRoleModuleID;

        private System.Data.SqlClient.SqlConnection m_sqlCon;
        private string m_strDiscCode;
        private int m_iRoleID;

        #region Properties

        public System.Data.SqlClient.SqlConnection SqlCon
        {
            get { return m_sqlCon; }
            set { this.m_sqlCon = value; }
        }

        public int RoleID
        {
            get { return m_iRoleID; }
            set { this.m_iRoleID = value; }
        }

        public string DiscCode
        {
            get { return m_strDiscCode; }
            set { this.m_strDiscCode = value; }
        }

        #endregion

        #region Event Handlers

        protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
        {
            if (keyData == (Keys.F5))
            {
                LoadData();

                return true;
            }

            return base.ProcessCmdKey(ref msg, keyData);
        }

        private void OnModuleEvent(object sender, OVRModule2FrameEventArgs e)
        {
            switch (e.Type)
            {
                case OVRModule2FrameEventType.emRptContextChanged:
                    {
                        OVRReportContextChangedArgs oArgs = e.Args as OVRReportContextChangedArgs;
                        if (oArgs == null) break;

                        if (m_EventReportContextChanged != null)
                            m_EventReportContextChanged(this, oArgs);
                        break;
                    }
                case OVRModule2FrameEventType.emDataChanged:
                    {
                        OnDataChangedNotify(sender, e.Args as OVRDataChangedNotifyArgs);
                        break;
                    }
                case OVRModule2FrameEventType.emDoReport:
                    {
                        DoReport(e.Args as OVRDoReportArgs);
                        break;
                    }
                case OVRModule2FrameEventType.emReportInfoQuery:
                    {
                        QueryReportInfo(e.Args as OVRReportInfoQueryArgs);
                        break;
                    }
                case OVRModule2FrameEventType.emVenueChanged:
                    {
                        m_strVenueCode = e.Args as string;
                        m_xmlPacker.VenueCode = m_strVenueCode;
                        ConfigurationManager.SetUserSettingString("Venue", m_strVenueCode);

                        if (m_EventReportContextChanged != null)
                            m_EventReportContextChanged(this, new OVRReportContextChangedArgs("VenueCode", m_strVenueCode));

                        break;
                    }
            }
        }

        private void OnNetworkStatus(bool bRunning)
        {
            if (bRunning)
                this.btnItemNetwork.Icon = global::AutoSports.OVRManagerApp.Properties.Resources.Network_OK;
            else
                this.btnItemNetwork.Icon = global::AutoSports.OVRManagerApp.Properties.Resources.Network_ERR;

            // Force btnItemNetwork to repaint.
            this.Focus();
        }

        private void OnMainFrameLoad(object sender, EventArgs e)
        {
            this.Location = Screen.PrimaryScreen.WorkingArea.Location;
            this.Size = Screen.PrimaryScreen.WorkingArea.Size;
        }

        private void OnMainFrameFormClosing(object sender, FormClosingEventArgs e)
        {
            string strText = LocalizationRecourceManager.GetString(strSectionName, "ExistSystem");
            e.Cancel = DevComponents.DotNetBar.MessageBoxEx.Show(strText, "Close System", MessageBoxButtons.YesNo) == DialogResult.No;
        }

        private void OnMainFrameFormClosed(object sender, FormClosedEventArgs e)
        {
            SystemClose();
        }

        private void OnGeneralDataClick(object sender, EventArgs e)
        {
            if (this.m_emMainFormUI != EMainFormUIType.emWndGeneralData)
            {
                this.m_emMainFormUI = EMainFormUIType.emWndGeneralData;
                CurrentModuleChanged();
            }
        }

        private void OnRegisterClick(object sender, EventArgs e)
        {
            if (this.m_emMainFormUI != EMainFormUIType.emWndRegister)
            {
                this.m_emMainFormUI = EMainFormUIType.emWndRegister;
                CurrentModuleChanged();
            }
        }

        private void OnDrawArrangeClick(object sender, EventArgs e)
        {
            if (this.m_emMainFormUI != EMainFormUIType.emWndDrawArrange)
            {
                this.m_emMainFormUI = EMainFormUIType.emWndDrawArrange;
                CurrentModuleChanged();
            }
        }

        private void OnMatchScheduleClick(object sender, EventArgs e)
        {
            if (this.m_emMainFormUI != EMainFormUIType.emWndMatchSchedule)
            {
                this.m_emMainFormUI = EMainFormUIType.emWndMatchSchedule;
                CurrentModuleChanged();
            }
        }

        private void OnPluginManagerClick(object sender, EventArgs e)
        {
            if (this.m_emMainFormUI != EMainFormUIType.emWndPluginMgr)
            {
                this.m_emMainFormUI = EMainFormUIType.emWndPluginMgr;
                CurrentModuleChanged();
            }
        }

        private void OnReportsClick(object sender, EventArgs e)
        {
            if (!m_frmReportPrinting.Visible)
                m_frmReportPrinting.Show();

            if (this.m_emMainFormUI == EMainFormUIType.emUnknown)
                m_frmReportPrinting.OnCurModuleChanged(null);
        }

        private void OnRankMedalClick(object sender, EventArgs e)
        {
            if (this.m_emMainFormUI != EMainFormUIType.emWndRankMedal)
            {
                this.m_emMainFormUI = EMainFormUIType.emWndRankMedal;
                CurrentModuleChanged();
            }
        }

        private void OnRecordClick(object sender, EventArgs e)
        {
            if (this.m_emMainFormUI != EMainFormUIType.emWndRecord)
            {
                this.m_emMainFormUI = EMainFormUIType.emWndRecord;
                CurrentModuleChanged();
            }
        }

        private void OnDatabaseBackupClick(object sender, EventArgs e)
        {
            if (SqlCon.State == System.Data.ConnectionState.Closed)
                SqlCon.Open();
          
            string strSectionName = "MainFrame";
            string strMsg, strCaption;
            strCaption = LocalizationRecourceManager.GetString(strSectionName, "BackupDBCaption");
            if (OVRDataBaseUtils.BackupDB(SqlCon))
            {
                strMsg = LocalizationRecourceManager.GetString(strSectionName, "BackupDBSuccessMsg");               
            }
            else
            {
                strMsg = LocalizationRecourceManager.GetString(strSectionName, "BackupDBFailMsg");     
            }
           
            UIMessageDialog.ShowMessageDialog(strMsg, strCaption, false, this.Style);
        }

        private void OnCommunicationClick(object sender, EventArgs e)
        {
            OVRCommunicationForm frmOfficialCommunication = new OVRCommunicationForm();
            frmOfficialCommunication.DatabaseConnection = SqlCon;
            frmOfficialCommunication.VenueCode = m_strVenueCode;
            frmOfficialCommunication.Module2FrameEvent += new OVRModule2FrameEventHandler(OnModuleEvent);

            frmOfficialCommunication.ShowDialog();

            // Force Report Print Module to update its parameters
            if (m_frmReportPrinting.Visible)
                CurrentModuleChanged();
        }

        private void OnNetworkClick(object sender, EventArgs e)
        {
            SetNetwork();
        }

        private void OnReportContextQuery(object sender, OVRReportContextQueryArgs e)
        {
            OVRFrame2ModuleEventArgs oEventArgs = new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emRptContextQuery, e);

            switch (m_emMainFormUI)
            {
                case EMainFormUIType.emWndGeneralData:
                    m_EventGeneralData(this, oEventArgs);
                    break;
                case EMainFormUIType.emWndRegister:
                    m_EventRegister(this, oEventArgs);
                    break;
                case EMainFormUIType.emWndDrawArrange:
                    m_EventDrawArrange(this, oEventArgs);
                    break;
                case EMainFormUIType.emWndMatchSchedule:
                    m_EventMatchSchedule(this, oEventArgs);
                    break;
                case EMainFormUIType.emWndPluginMgr:
                    m_EventPluginMgr(this, oEventArgs);
                    break;
                case EMainFormUIType.emWndRankMedal:
                    m_EventRankMedal(this, oEventArgs);
                    break;
            }
        }

        private void OnReportGenerated(object sender, OVRReportGeneratedArgs oArgs)
        {
            if (!m_bIsNetworkOpen || oArgs == null) return;

            string strMessage = m_xmlPacker.GetRPDSMessage(oArgs);

            m_frmNetworkManager.BroadcastMessage(strMessage);
        }

        private void OnDataChangedNotify(object sender, OVRDataChangedNotifyArgs oArgs)
        {
            if (oArgs == null) return;

            if (null != m_ModuleGeneralData && sender != m_ModuleGeneralData)
            {
                m_FlagsGeneralData.Signal(oArgs.ChangedList);
            }

            if (null != m_FlagsRegister && sender != m_ModuleRegister)
            {
                m_FlagsRegister.Signal(oArgs.ChangedList);
            }

            if (null != m_ModuleDrawArrange && sender != m_ModuleDrawArrange)
            {
                m_FlagsDrawArrange.Signal(oArgs.ChangedList);
            }

            if (null != m_FlagsMatchSchedule && sender != m_ModuleMatchSchedule)
            {
                m_FlagsMatchSchedule.Signal(oArgs.ChangedList);
            }

            if (null != m_FlagsPluginMgr && sender != m_ModulePluginMgr)
            {
                m_FlagsPluginMgr.Signal(oArgs.ChangedList);
            }

            if (null != m_FlagsRankMedal && sender != m_ModuleRankMedal)
            {
                m_FlagsRankMedal.Signal(oArgs.ChangedList);
            }

            if (!m_bIsNetworkOpen || !m_frmNetworkManager.IsRunning) return;

            // Send Notify or Data to TCP Clients
            foreach (OVRDataChanged item in oArgs.ChangedList)
            {
                string strMessage = m_xmlPacker.GetXmlMessage(item);
                m_frmNetworkManager.BroadcastMessage(strMessage);
            }
        }

        #endregion

        #region System Open Functions

        public bool SystemOpen()
        {
            if (SqlCon.State == System.Data.ConnectionState.Closed)
                SqlCon.Open();

            OVRDataBaseUtils.GetRoleModules(SqlCon, RoleID, out m_lstRoleModuleID);

            Localization();
            GetSystemConfiguration();

            btnItemGenData.Visible = false;
            btnItemRegister.Visible = false;
            btnItemDrawArrange.Visible = false;
            btnItemSchedule.Visible = false;
            btnItemMatchData.Visible = false;
            btnItemMedal.Visible = false;
            btnItemReports.Visible = false;
            btnItemBackup.Visible = false;
            btnItemCommunicate.Visible = false;
            btnItemNetwork.Visible = false;
            btnItemRecord.Visible = false;

            foreach (int id in m_lstRoleModuleID)
            {
                if (id == (int)EMainFormUIType.emWndGeneralData)
                {
                    GeneralDataOpen();
                    btnItemGenData.Visible = true;
                }
                else if (id == (int)EMainFormUIType.emWndRegister)
                {
                    RegisterOpen();
                    btnItemRegister.Visible = true;
                }
                else if (id == (int)EMainFormUIType.emWndDrawArrange)
                {
                    DrawArrangeOpen();
                    btnItemDrawArrange.Visible = true;
                }
                else if (id == (int)EMainFormUIType.emWndMatchSchedule)
                {
                    MatchScheduleOpen();
                    btnItemSchedule.Visible = true;
                }
                else if (id == (int)EMainFormUIType.emWndPluginMgr)
                {
                    PluginMgrOpen();
                    btnItemMatchData.Visible = true;
                }
                else if (id == (int)EMainFormUIType.emWndRankMedal)
                {
                    RankMedalOpen();
                    btnItemMedal.Visible = true;
                }
                else if (id == (int)EMainFormUIType.emWndReports)
                {
                    ReportsOpen();
                    btnItemReports.Visible = true;
                }
                else if (id == (int)EMainFormUIType.emWndBackupDB)
                {
                    btnItemBackup.Visible = true;
                }
                else if (id == (int)EMainFormUIType.emWndCommunicate)
                {
                    btnItemCommunicate.Visible = true;
                }
                else if (id == (int)EMainFormUIType.emWndNetwork)
                {
                    NetworkOpen();
                    btnItemNetwork.Visible = true;
                }
                else if (id == (int)EMainFormUIType.emWndRecord)
                {
                    RecordOpen();
                    btnItemRecord.Visible = true;
                }
            }


            return true;
        }

        public void SystemClose()
        {
            if (m_sqlCon != null)
                m_sqlCon.Close();

            if (m_frmNetworkManager != null)
                m_frmNetworkManager.UnInitialize();

            if (m_ModuleRegister != null)
                m_ModuleRegister.UnInitialize();

            if (m_ModuleDrawArrange != null)
                m_ModuleDrawArrange.UnInitialize();

            if (m_ModuleMatchSchedule != null)
                m_ModuleMatchSchedule.UnInitialize();

            if (m_ModulePluginMgr != null)
                m_ModulePluginMgr.UnInitialize();

            if (m_ModuleRankMedal != null)
                m_ModuleRankMedal.UnInitialize();
        }

        private void GeneralDataOpen()
        {
            if (m_ModuleGeneralData != null)
                return;

            m_ModuleGeneralData = new OVRGenDataModule();
            if (m_ModuleGeneralData.GetModuleUI != null)
            {
                m_FlagsGeneralData = new OVRDataChangedFlags();
                m_ModuleGeneralData.Module2FrameEvent += new OVRModule2FrameEventHandler(OnModuleEvent);
                m_EventGeneralData += m_ModuleGeneralData.Frame2ModuleEventHandler;
                m_ModuleGeneralData.Initialize(m_sqlCon);
                m_ModuleGeneralData.GetModuleUI.Visible = false;
                m_ModuleGeneralData.GetModuleUI.Dock = DockStyle.Fill;
                panelModuleForm.Controls.Add((m_ModuleGeneralData.GetModuleUI as Control));
            }
        }

        private void RegisterOpen()
        {
            if (m_ModuleRegister != null)
                return;

            m_ModuleRegister = new OVRRegisterModule();
            if (m_ModuleRegister.GetModuleUI != null)
            {
                m_FlagsRegister = new OVRDataChangedFlags();
                m_ModuleRegister.Module2FrameEvent += new OVRModule2FrameEventHandler(OnModuleEvent);
                m_EventRegister += m_ModuleRegister.Frame2ModuleEventHandler;
                m_ModuleRegister.Initialize(m_sqlCon);
                m_ModuleRegister.GetModuleUI.Visible = false;
                m_ModuleRegister.GetModuleUI.Dock = DockStyle.Fill;
                panelModuleForm.Controls.Add((m_ModuleRegister.GetModuleUI as Control));
            }
        }

        private void DrawArrangeOpen()
        {
            if (m_ModuleDrawArrange != null)
                return;

            m_ModuleDrawArrange = new OVRDrawArrangeModule();
            if (m_ModuleDrawArrange.GetModuleUI != null)
            {
                m_FlagsDrawArrange = new OVRDataChangedFlags();
                m_ModuleDrawArrange.Module2FrameEvent += new OVRModule2FrameEventHandler(OnModuleEvent);
                m_EventDrawArrange += m_ModuleDrawArrange.Frame2ModuleEventHandler;
                m_ModuleDrawArrange.Initialize(m_sqlCon);
                m_ModuleDrawArrange.GetModuleUI.Visible = false;
                m_ModuleDrawArrange.GetModuleUI.Dock = DockStyle.Fill;
                panelModuleForm.Controls.Add(m_ModuleDrawArrange.GetModuleUI);
            }
        }

        private void MatchScheduleOpen()
        {
            if (m_ModuleMatchSchedule != null)
                return;

            m_ModuleMatchSchedule = new OVRMatchScheduleModule();
            if (m_ModuleMatchSchedule.GetModuleUI != null)
            {
                m_FlagsMatchSchedule = new OVRDataChangedFlags();
                m_ModuleMatchSchedule.Module2FrameEvent += new OVRModule2FrameEventHandler(OnModuleEvent);
                m_EventMatchSchedule += m_ModuleMatchSchedule.Frame2ModuleEventHandler;
                m_ModuleMatchSchedule.Initialize(m_sqlCon);
                m_ModuleMatchSchedule.GetModuleUI.Visible = false;
                m_ModuleMatchSchedule.GetModuleUI.Dock = DockStyle.Fill;
                panelModuleForm.Controls.Add(m_ModuleMatchSchedule.GetModuleUI);
            }
        }

        private void PluginMgrOpen()
        {
            if (m_ModulePluginMgr != null)
                return;

            m_ModulePluginMgr = new OVRPluginMgrModule();
            if (m_ModulePluginMgr.GetModuleUI != null)
            {
                m_FlagsPluginMgr = new OVRDataChangedFlags();
                m_ModulePluginMgr.Module2FrameEvent += new OVRModule2FrameEventHandler(OnModuleEvent);
                m_EventPluginMgr += m_ModulePluginMgr.Frame2ModuleEventHandler;
                m_ModulePluginMgr.Initialize(m_sqlCon);
                m_ModulePluginMgr.GetModuleUI.Visible = false;
                m_ModulePluginMgr.GetModuleUI.Dock = DockStyle.Fill;
                panelModuleForm.Controls.Add(m_ModulePluginMgr.GetModuleUI);

                if (this.m_strDiscCode == null || this.m_strDiscCode.Length == 0) return;

                m_EventPluginMgr(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emLoadPlugin, this.m_strDiscCode));
            }
        }

        private void ReportsOpen()
        {
            if (m_frmReportPrinting != null)
                return;

            m_frmReportPrinting = new OVRReportPrintingForm();
            //m_frmReportPrinting.Owner = this;
            m_frmReportPrinting.DBConnection = SqlCon;

            m_frmReportPrinting.m_EventReportContextQuery += new OVRReportContextQueryEventHandler(OnReportContextQuery);
            m_frmReportPrinting.m_EventReportGenerated += new OVRReportGeneratedEventHandler(OnReportGenerated);
            m_EventReportContextChanged += m_frmReportPrinting.ReportChangedQueryEventHandler;
            m_frmReportPrinting.Initialize();

            if (m_EventReportContextChanged != null)
                m_EventReportContextChanged(this, new OVRReportContextChangedArgs("VenueCode", m_strVenueCode));
        }

        private void RankMedalOpen()
        {
            if (m_ModuleRankMedal != null)
                return;

            m_ModuleRankMedal = new OVRRankMedalModule();
            if (m_ModuleRankMedal.GetModuleUI != null)
            {
                m_FlagsRankMedal = new OVRDataChangedFlags();
                m_ModuleRankMedal.Module2FrameEvent += new OVRModule2FrameEventHandler(OnModuleEvent);
                m_EventRankMedal += m_ModuleRankMedal.Frame2ModuleEventHandler;
                m_ModuleRankMedal.Initialize(m_sqlCon);
                m_ModuleRankMedal.GetModuleUI.Visible = false;
                m_ModuleRankMedal.GetModuleUI.Dock = DockStyle.Fill;
                panelModuleForm.Controls.Add(m_ModuleRankMedal.GetModuleUI);
            }
        }

        private void RecordOpen()
        {
            if (m_ModuleRecord != null)
                return;

            m_ModuleRecord = new OVRRecordModule();
            if (m_ModuleRecord.GetModuleUI != null)
            {
                m_FlagsRecord = new OVRDataChangedFlags();
                m_ModuleRecord.Module2FrameEvent += new OVRModule2FrameEventHandler(OnModuleEvent);
                m_EventRecord += m_ModuleRecord.Frame2ModuleEventHandler;
                m_ModuleRecord.Initialize(m_sqlCon);
                m_ModuleRecord.GetModuleUI.Visible = false;
                m_ModuleRecord.GetModuleUI.Dock = DockStyle.Fill;
                panelModuleForm.Controls.Add(m_ModuleRecord.GetModuleUI);
            }
        }


        private void NetworkOpen()
        {
            m_frmNetworkManager = new OVRNetworkManagerForm();
            //m_frmNetworkManager.Owner = this;
            m_frmNetworkManager.EventNetworkStatus += new OVRNetworkStatus(OnNetworkStatus);

            // We need show the form before it receive any event, else error will be occurred.
            int xPos = (Screen.PrimaryScreen.WorkingArea.Size.Width - m_frmNetworkManager.Size.Width) / 2;
            int yPos = (Screen.PrimaryScreen.WorkingArea.Size.Height - m_frmNetworkManager.Size.Height) / 2;
            Point pt = new Point(xPos, yPos);
            m_frmNetworkManager.StartPosition = FormStartPosition.Manual;
            m_frmNetworkManager.Location = new System.Drawing.Point(pt.X, pt.Y + Screen.PrimaryScreen.WorkingArea.Size.Height);
            m_frmNetworkManager.Show();
            m_frmNetworkManager.Hide();
            m_frmNetworkManager.Location = pt;

            m_frmNetworkManager.Initialize(m_bIsServer);
            if (m_bIsServer)
            {
                System.Net.IPAddress[] addr = System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName()).AddressList;
                System.Net.IPAddress svrAddr = null;
                for (int i = 0; i < addr.Length; i++)
                {
                    string temp = addr[i].ToString();
                    if (addr[i].ToString() == m_strServer)
                    {
                        svrAddr = addr[i];
                        break;
                    }
                }

                if (svrAddr != null)
                {
                    m_frmNetworkManager.StartListen(svrAddr, m_iPort);
                }
                else
                    m_EventGeneralData(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emNetworkStatus, "ERROR"));
            } 
            else
            {
                if (m_strServer != null && m_strServer.Length > 6 && m_iPort >= 0)
                {
                    m_frmNetworkManager.Connect(m_strServer, m_iPort);
                }
            }

            m_xmlPacker = new OVRXmlMessagePacker();
            m_xmlPacker.Initialize(SqlCon, m_strVenueCode);

            m_bIsNetworkOpen = true;
        }
        
        #endregion

        #region Assist Functions

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "TitleMainFrame");
            this.sbItemGameMgr.Text = LocalizationRecourceManager.GetString(strSectionName, "sbItemGameMgr");
            this.btnItemGenData.Text = LocalizationRecourceManager.GetString(strSectionName, "btnItemGenData");
            this.btnItemRegister.Text = LocalizationRecourceManager.GetString(strSectionName, "btnItemRegister");
            this.btnItemDrawArrange.Text = LocalizationRecourceManager.GetString(strSectionName, "btnItemDrawArrange");
            this.btnItemSchedule.Text = LocalizationRecourceManager.GetString(strSectionName, "btnItemSchedule");
            this.btnItemMatchData.Text = LocalizationRecourceManager.GetString(strSectionName, "btnItemMatchData");
            this.btnItemReports.Text = LocalizationRecourceManager.GetString(strSectionName, "btnItemReports");
            this.btnItemMedal.Text = LocalizationRecourceManager.GetString(strSectionName, "btnItemMedal");
            this.btnItemBackup.Text = LocalizationRecourceManager.GetString(strSectionName, "btnItemBackup");
            this.btnItemCommunicate.Text = LocalizationRecourceManager.GetString(strSectionName, "btnItemCommunication");
            this.btnItemNetwork.Text = LocalizationRecourceManager.GetString(strSectionName, "btnItemNetwork");
        }

        private void CurrentModuleChanged()
        {
            if (btnItemGenData.Visible)
            {
                if (this.m_emMainFormUI == EMainFormUIType.emWndGeneralData)
                {
                    btnItemGenData.ForeColor = System.Drawing.Color.Red;
                    m_ModuleGeneralData.GetModuleUI.Visible = true;

                    m_EventGeneralData(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emUpdateData, m_FlagsGeneralData));
                    m_FlagsGeneralData.Reset();

                    if (m_frmReportPrinting != null)
                        m_frmReportPrinting.OnCurModuleChanged("M_G");
                }
                else
                {
                    btnItemGenData.ForeColor = System.Drawing.Color.White;
                    m_ModuleGeneralData.GetModuleUI.Visible = false;
                }
            }
            if (btnItemRegister.Visible)
            {
                if (this.m_emMainFormUI == EMainFormUIType.emWndRegister)
                {
                    btnItemRegister.ForeColor = System.Drawing.Color.Red;
                    m_ModuleRegister.GetModuleUI.Visible = true;

                    m_EventRegister(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emUpdateData, m_FlagsRegister));
                    m_FlagsRegister.Reset();

                    if (m_frmReportPrinting != null)
                        m_frmReportPrinting.OnCurModuleChanged("M_R");
                }
                else
                {
                    btnItemRegister.ForeColor = System.Drawing.Color.White;
                    m_ModuleRegister.GetModuleUI.Visible = false;
                }
            }
            if (btnItemDrawArrange.Visible)
            {
                if (this.m_emMainFormUI == EMainFormUIType.emWndDrawArrange)
                {
                    btnItemDrawArrange.ForeColor = System.Drawing.Color.Red;
                    m_ModuleDrawArrange.GetModuleUI.Visible = true;

                    m_EventDrawArrange(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emUpdateData, m_FlagsDrawArrange));
                    m_FlagsDrawArrange.Reset();

                    if (m_frmReportPrinting != null)
                        m_frmReportPrinting.OnCurModuleChanged("M_D");
                }
                else
                {
                    btnItemDrawArrange.ForeColor = System.Drawing.Color.White;
                    m_ModuleDrawArrange.GetModuleUI.Visible = false;
                }
            }
            if (btnItemSchedule.Visible)
            {
                if (this.m_emMainFormUI == EMainFormUIType.emWndMatchSchedule)
                {
                    btnItemSchedule.ForeColor = System.Drawing.Color.Red;
                    m_ModuleMatchSchedule.GetModuleUI.Visible = true;

                    m_EventMatchSchedule(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emUpdateData, m_FlagsMatchSchedule));
                    m_FlagsMatchSchedule.Reset();

                    if (m_frmReportPrinting != null)
                        m_frmReportPrinting.OnCurModuleChanged("M_S");
                }
                else
                {
                    btnItemSchedule.ForeColor = System.Drawing.Color.White;
                    m_ModuleMatchSchedule.GetModuleUI.Visible = false;
                }
            }
            if (btnItemMatchData.Visible)
            {
                if (this.m_emMainFormUI == EMainFormUIType.emWndPluginMgr)
                {
                    btnItemMatchData.ForeColor = System.Drawing.Color.Red;
                    m_ModulePluginMgr.GetModuleUI.Visible = true;

                    m_EventPluginMgr(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emUpdateData, m_FlagsPluginMgr));
                    m_FlagsPluginMgr.Reset();

                    if (m_frmReportPrinting != null)
                        m_frmReportPrinting.OnCurModuleChanged("M_E");
                }
                else
                {
                    btnItemMatchData.ForeColor = System.Drawing.Color.White;
                    m_ModulePluginMgr.GetModuleUI.Visible = false;
                }
            }
            if (btnItemMedal.Visible)
            {

                if (this.m_emMainFormUI == EMainFormUIType.emWndRankMedal)
                {
                    btnItemMedal.ForeColor = System.Drawing.Color.Red;
                    m_ModuleRankMedal.GetModuleUI.Visible = true;

                    m_EventRankMedal(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emUpdateData, m_FlagsRankMedal));
                    m_FlagsRankMedal.Reset();

                    if (m_frmReportPrinting != null)
                        m_frmReportPrinting.OnCurModuleChanged("M_M");
                }
                else
                {
                    btnItemMedal.ForeColor = System.Drawing.Color.White;
                    m_ModuleRankMedal.GetModuleUI.Visible = false;
                }
            }
            if (btnItemRecord.Visible)
            {
                if (this.m_emMainFormUI == EMainFormUIType.emWndRecord)
                {
                    btnItemRecord.ForeColor = System.Drawing.Color.Red;
                    m_ModuleRecord.GetModuleUI.Visible = true;

                    m_EventRecord(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emUpdateData, m_FlagsRecord));
                    m_FlagsRecord.Reset();

                    if (m_frmReportPrinting != null)
                        m_frmReportPrinting.OnCurModuleChanged("M_B");
                }
                else
                {
                    btnItemRecord.ForeColor = System.Drawing.Color.White;
                    m_ModuleRecord.GetModuleUI.Visible = false;
                }
            }
        }

        private void GetSystemConfiguration()
        {
            // System Initialize
            m_bIsServer = false;
            if ("1" == ConfigurationManager.GetUserSettingString("IsServer").Trim())
                m_bIsServer = true;

            m_strServer = ConfigurationManager.GetUserSettingString("Server").Trim();
            m_iPort = 6000;

            try
            {
                string strValue = ConfigurationManager.GetUserSettingString("Port");
                m_iPort = Convert.ToInt32(strValue);
            }
            catch (System.Exception ex)
            {
                ConfigurationManager.SetUserSettingString("Port", "5000");
            }

            m_strVenueCode = ConfigurationManager.GetUserSettingString("Venue").Trim();
            if (m_strVenueCode.Length == 0)
                m_strVenueCode = "NONE";

            m_strTplCommunication = ConfigurationManager.GetUserSettingString("TplCommunication");
        }

        private void LoadData()
        {
            OVRFrame2ModuleEventArgs oArgs = new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emLoadData, null);

            switch (m_emMainFormUI)
            {
            case EMainFormUIType.emWndGeneralData:
                m_EventGeneralData(this, oArgs);
            	break;
            case EMainFormUIType.emWndRegister:
                m_EventRegister(this, oArgs);
            	break;
            case EMainFormUIType.emWndDrawArrange:
                m_EventDrawArrange(this, oArgs);
            	break;
            case EMainFormUIType.emWndMatchSchedule:
                m_EventMatchSchedule(this, oArgs);
            	break;
            case EMainFormUIType.emWndPluginMgr:
                m_EventPluginMgr(this, oArgs);
            	break;
            case EMainFormUIType.emWndRankMedal:
                m_EventRankMedal(this, oArgs);
            	break;
            }
        }

        private void DoReport(OVRDoReportArgs oArgs)
        {
            if (oArgs == null || m_frmReportPrinting == null || oArgs.Action == OVRReportAction.emNone)
                return;

            m_frmReportPrinting.DoReport(oArgs.Action, oArgs.ReportInfo);
        }

        private void QueryReportInfo(OVRReportInfoQueryArgs oArgs)
        {
            if (oArgs == null || m_frmReportPrinting == null)
                return;

            oArgs.Handled = m_frmReportPrinting.QueryReportInfo(oArgs.ReportInfo);
        }

        private void SetNetwork()
        {
            if (m_frmNetworkManager != null)
            {
                m_frmNetworkManager.Show();
            }
        }

        #endregion


        public OVRMainFrameForm()
        {
            this.SuspendLayout();

            InitializeComponent();

            // Module Form
            this.panelModuleForm.SuspendLayout();
            this.panelModuleForm.Dock = DockStyle.Fill;

            this.Controls.AddRange(new System.Windows.Forms.Control[] {
                                                                           this.spliterGameMgr,
                                                                           this.panelModuleForm,
                                                                           this.sideBarGameMgr});
            this.panelModuleForm.ResumeLayout(false);
            this.ResumeLayout(false);

            this.m_emMainFormUI = EMainFormUIType.emUnknown;
            this.m_bIsNetworkOpen = false;
        }

    }





    public delegate void OVRReportContextQueryEventHandler(object sender, OVRReportContextQueryArgs args);

    public delegate void OVRReportContextChangedEventHandler(object sender, OVRReportContextChangedArgs args);

    public class OVRReportGeneratedArgs
    {
        private int m_iDisciplineID;    // Used for RSC Query
        private int m_iEventID;         // Used for RSC Query
        private int m_iPhaseID;         // Used for RSC Query
        private int m_iMatchID;         // Used for RSC Query

        private string m_strType;       // Report Type
        private string m_strVersion;    // Report Version
        private string m_strFileName;   // Report File Name
        private string m_strComment;    // Report Comment

        public OVRReportGeneratedArgs()
        {
            m_iDisciplineID = -1;
            m_iEventID = -1;
            m_iPhaseID = -1;
            m_iMatchID = -1;
            m_strType = null;
            m_strVersion = null;
            m_strFileName = null;
            m_strComment = null;
        }

        public OVRReportGeneratedArgs(int iDisciplineID, int iEventID, int iPhaseID, int iMatchID
                    , string strType, string strVersion, string strFileName, string strComment)
        {
            m_iDisciplineID = iDisciplineID;
            m_iEventID = iEventID;
            m_iPhaseID = iPhaseID;
            m_iMatchID = iMatchID;
            m_strType = strType;
            m_strVersion = strVersion;
            m_strFileName = strFileName;
            m_strComment = strComment;
        }

        public int DisciplineID
        {
            get { return m_iDisciplineID; }
            set { m_iDisciplineID = value; }
        }

        public int EventID
        {
            get { return m_iEventID; }
            set { m_iEventID = value; }
        }

        public int PhaseID
        {
            get { return m_iPhaseID; }
            set { m_iPhaseID = value; }
        }

        public int MatchID
        {
            get { return m_iMatchID; }
            set { m_iMatchID = value; }
        }

        public string ReportType
        {
            get { return m_strType; }
            set { m_strType = value; }
        }

        public string Version
        {
            get { return m_strVersion; }
            set { m_strVersion = value; }
        }

        public string FileName
        {
            get { return m_strFileName; }
            set { m_strFileName = value; }
        }

        public string Comment
        {
            get { return m_strComment; }
            set { m_strComment = value; }
        }
    }

    public delegate void OVRReportGeneratedEventHandler(object sender, OVRReportGeneratedArgs args);
}