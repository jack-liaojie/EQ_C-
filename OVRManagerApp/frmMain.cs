
using System.Windows.Forms;
using Sunny.UI;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Xml;


using AutoSports.OVRGeneralData;
using AutoSports.OVRRegister;
using AutoSports.OVRDrawArrange;
using AutoSports.OVRMatchSchedule;
using AutoSports.OVRRankMedal;
using AutoSports.OVRRecord;
using AutoSports.OVREQPlugin;
using AutoSports.OVRCommon;
using AutoSports.OVRPluginMgr;
using System.Net.Sockets;

namespace AutoSports.OVRManagerApp
{
    public partial class frmMain : UIHeaderAsideMainFooterFrame
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
        private OVRCommunicationForm frmOfficialCommunication;
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

        private void OnMainFrameFormClosing(object sender, FormClosingEventArgs e)
        {
            string strText = LocalizationRecourceManager.GetString(strSectionName, "ExistSystem");
            e.Cancel = DevComponents.DotNetBar.MessageBoxEx.Show(strText, "Close System", MessageBoxButtons.YesNo) == DialogResult.No;
        }

        private void OnMainFrameFormClosed(object sender, FormClosedEventArgs e)
        {
            SystemClose();
        }

        private void OnCommunication()
        {
            frmOfficialCommunication = new OVRCommunicationForm();
            frmOfficialCommunication.DatabaseConnection = SqlCon;
            frmOfficialCommunication.VenueCode = m_strVenueCode;
            frmOfficialCommunication.Module2FrameEvent += new OVRModule2FrameEventHandler(OnModuleEvent);

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

            GetSystemConfiguration();

            

            foreach (int id in m_lstRoleModuleID)
            {
                if (id == (int)EMainFormUIType.emWndGeneralData)
                {
                    GeneralDataOpen();
                }
                else if (id == (int)EMainFormUIType.emWndRegister)
                {
                    RegisterOpen();
                }
                else if (id == (int)EMainFormUIType.emWndDrawArrange)
                {
                    DrawArrangeOpen();
                }
                else if (id == (int)EMainFormUIType.emWndMatchSchedule)
                {
                    MatchScheduleOpen();
                }
                else if (id == (int)EMainFormUIType.emWndPluginMgr)
                {
                    PluginMgrOpen();
                }
                else if (id == (int)EMainFormUIType.emWndRankMedal)
                {
                    RankMedalOpen();
                }
                else if (id == (int)EMainFormUIType.emWndReports)
                {
                    ReportsOpen();
                }
                else if (id == (int)EMainFormUIType.emWndBackupDB)
                {
                }
                else if (id == (int)EMainFormUIType.emWndCommunicate)
                {
                    OnCommunication();
                }
                else if (id == (int)EMainFormUIType.emWndNetwork)
                {
                    NetworkOpen();
                }
                else if (id == (int)EMainFormUIType.emWndRecord)
                {
                    RecordOpen();
                }
            }

            AddAside();
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
            }
        }

        private void OnNetworkStatus(bool bRunning)
        {
          
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

        private void DatabaseBackup()
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

            UIMessageDialog.ShowMessageDialog(strMsg, strCaption,false,this.Style);
        }
        #endregion

        #region Assist Functions

        private void ItemRecord()
        {
            if (this.m_emMainFormUI == EMainFormUIType.emWndRecord)
            {
                m_ModuleRecord.GetModuleUI.Visible = true;

                m_EventRecord(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emUpdateData, m_FlagsRecord));
                m_FlagsRecord.Reset();

                if (m_frmReportPrinting != null)
                    m_frmReportPrinting.OnCurModuleChanged("M_B");
            }
            else
            {
                m_ModuleRecord.GetModuleUI.Visible = false;
            }
        }

        private void ItemMedal()
        {
            if (this.m_emMainFormUI == EMainFormUIType.emWndRankMedal)
            {
                m_ModuleRankMedal.GetModuleUI.Visible = true;

                m_EventRankMedal(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emUpdateData, m_FlagsRankMedal));
                m_FlagsRankMedal.Reset();

                if (m_frmReportPrinting != null)
                    m_frmReportPrinting.OnCurModuleChanged("M_M");
            }
            else
            {
                m_ModuleRankMedal.GetModuleUI.Visible = false;
            }
        }

        private void ItemMatchData()
        {
            if (this.m_emMainFormUI == EMainFormUIType.emWndPluginMgr)
            {
                m_ModulePluginMgr.GetModuleUI.Visible = true;

                m_EventPluginMgr(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emUpdateData, m_FlagsPluginMgr));
                m_FlagsPluginMgr.Reset();

                if (m_frmReportPrinting != null)
                    m_frmReportPrinting.OnCurModuleChanged("M_E");
            }
            else
            {
                m_ModulePluginMgr.GetModuleUI.Visible = false;
            }
        }

        private void ItemSchedule()
        {
            if (this.m_emMainFormUI == EMainFormUIType.emWndMatchSchedule)
            {
                m_ModuleMatchSchedule.GetModuleUI.Visible = true;

                m_EventMatchSchedule(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emUpdateData, m_FlagsMatchSchedule));
                m_FlagsMatchSchedule.Reset();

                if (m_frmReportPrinting != null)
                    m_frmReportPrinting.OnCurModuleChanged("M_S");
            }
            else
            {
                m_ModuleMatchSchedule.GetModuleUI.Visible = false;
            }
        }

        private void ItemDrawArrage()
        {
            if (this.m_emMainFormUI == EMainFormUIType.emWndDrawArrange)
            {
                m_ModuleDrawArrange.GetModuleUI.Visible = true;

                m_EventDrawArrange(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emUpdateData, m_FlagsDrawArrange));
                m_FlagsDrawArrange.Reset();

                if (m_frmReportPrinting != null)
                    m_frmReportPrinting.OnCurModuleChanged("M_D");
            }
            else
            {
                m_ModuleDrawArrange.GetModuleUI.Visible = false;
            }
        }

        private void ItemRegister()
        {
            if (this.m_emMainFormUI == EMainFormUIType.emWndRegister)
            {
                m_ModuleRegister.GetModuleUI.Visible = true;

                m_EventRegister(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emUpdateData, m_FlagsRegister));
                m_FlagsRegister.Reset();

                if (m_frmReportPrinting != null)
                    m_frmReportPrinting.OnCurModuleChanged("M_R");
            }
            else
            {
                m_ModuleRegister.GetModuleUI.Visible = false;
            }
        }

        private void ItemGenData()
        {
            if (this.m_emMainFormUI == EMainFormUIType.emWndGeneralData)
            {
                m_ModuleGeneralData.GetModuleUI.Visible = true;

                m_EventGeneralData(this, new OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType.emUpdateData, m_FlagsGeneralData));
                m_FlagsGeneralData.Reset();

                if (m_frmReportPrinting != null)
                    m_frmReportPrinting.OnCurModuleChanged("M_G");
            }
            else
            {
                m_ModuleGeneralData.GetModuleUI.Visible = false;
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

        /*------------------------------------------------------------------------------------------------------------------------*/
        public frmMain()
        {
            InitializeComponent();
            //AddAside();

        }

        public void AddAside()
        {
            int pageIndex = 1000;
            Header.SetNodePageIndex(Header.Nodes[0], pageIndex);
            Header.SetNodeSymbol(Header.Nodes[0], 61451);
            TreeNode parent = Aside.CreateNode("基础数据", 61451, 24, pageIndex);
            //通过设置PageIndex关联
            //Aside.CreateChildNode(parent, 61842, 24, AddPage(new OVRGeneralDataForm("GeneralData"), ++pageIndex));
            Aside.CreateChildNode(parent, 61842, 24, AddPage(m_ModuleGeneralData.GetModuleUI, ++pageIndex));
            //Aside.CreateChildNode(parent, 61776, 24, AddPage(new FCombobox(), ++pageIndex));
            //Aside.CreateChildNode(parent, 61646, 24, AddPage(new FDataGridView(), ++pageIndex));
            //Aside.CreateChildNode(parent, 61474, 24, AddPage(new FListBox(), ++pageIndex));
            //Aside.CreateChildNode(parent, 61499, 24, AddPage(new FTreeView(), ++pageIndex));
            //Aside.CreateChildNode(parent, 61912, 24, AddPage(new FNavigation(), ++pageIndex));
            //Aside.CreateChildNode(parent, 61716, 24, AddPage(new FTabControl(), ++pageIndex));
            //Aside.CreateChildNode(parent, 61544, 24, AddPage(new FLine(), ++pageIndex));
            //Aside.CreateChildNode(parent, 61590, 24, AddPage(new FPanel(), ++pageIndex));
            //Aside.CreateChildNode(parent, 61516, 24, AddPage(new FTransfer(), ++pageIndex));
            //Aside.CreateChildNode(parent, 61447, 24, AddPage(new FAvatar(), ++pageIndex));
            //Aside.CreateChildNode(parent, 62104, 24, AddPage(new FContextMenuStrip(), ++pageIndex));
            //Aside.CreateChildNode(parent, 61668, 24, AddPage(new FMeter(), ++pageIndex));
            //Aside.CreateChildNode(parent, 62173, 24, AddPage(new FOther(), ++pageIndex));
            Aside.SetNodeTipsText(parent.Nodes[0], "1");

            pageIndex = 2000;
            Header.SetNodePageIndex(Header.Nodes[1], pageIndex);
            Header.SetNodeSymbol(Header.Nodes[1], 61818);
            parent = Aside.CreateNode("报名报项", 61818, 24, pageIndex);
            //通过设置GUID关联，节点字体图标和大小由UIPage设置
            Aside.CreateChildNode(parent, AddPage(m_ModuleRegister.GetModuleUI));
            //Aside.CreateChildNode(parent, AddPage(new FEditor(), Guid.NewGuid()));
            //Aside.CreateChildNode(parent, AddPage(new FFrames(), Guid.NewGuid()));

            pageIndex = 3000;
            Header.SetNodePageIndex(Header.Nodes[2], pageIndex);
            Header.SetNodeSymbol(Header.Nodes[2], 61950);
            parent = Aside.CreateNode("抽签编排", 61950, 24, pageIndex);
            //直接关联（默认自动生成GUID）
            Aside.CreateChildNode(parent, AddPage(m_ModuleDrawArrange.GetModuleUI));
            //Aside.CreateChildNode(parent, AddPage(new FBarChart()));
            //Aside.CreateChildNode(parent, AddPage(new FDoughnutChart()));


            pageIndex = 4000;
            Header.SetNodePageIndex(Header.Nodes[3], pageIndex);
            Header.SetNodeSymbol(Header.Nodes[3], 62082);
            parent = Aside.CreateNode("比赛安排", 62082, 24, pageIndex);
            //直接关联（默认自动生成GUID）
            Aside.CreateChildNode(parent, AddPage(m_ModuleMatchSchedule.GetModuleUI));
            //Aside.CreateChildNode(parent, AddPage(new OVRRegisterForm()));
            //Aside.CreateChildNode(parent, AddPage(new FDoughnutChart()));



            pageIndex = 5000;
            Header.SetNodePageIndex(Header.Nodes[4], pageIndex);
            Header.SetNodeSymbol(Header.Nodes[4], 61962);
            parent = Aside.CreateNode("赛时数据", 61962, 24, pageIndex);
            //直接关联（默认自动生成GUID）
            Aside.CreateChildNode(parent, AddPage(m_ModulePluginMgr.GetModuleUI));
            //Aside.CreateChildNode(parent, AddPage(new FBarChart()));
            //Aside.CreateChildNode(parent, AddPage(new FDoughnutChart()));


            pageIndex = 6000;
            Header.SetNodePageIndex(Header.Nodes[5], pageIndex);
            Header.SetNodeSymbol(Header.Nodes[5], 61776);
            parent = Aside.CreateNode("报表管理", 61776, 24, pageIndex);
            //直接关联（默认自动生成GUID）
            Aside.CreateChildNode(parent, AddPage(new OVRReportPrintingForm()));
            //Aside.CreateChildNode(parent, AddPage(new FBarChart()));
            //Aside.CreateChildNode(parent, AddPage(new FDoughnutChart()));

            pageIndex = 7000;
            Header.SetNodePageIndex(Header.Nodes[6], pageIndex);
            Header.SetNodeSymbol(Header.Nodes[6], 61646);
            parent = Aside.CreateNode("排名奖牌", 61646, 24, pageIndex);
            //直接关联（默认自动生成GUID）
            Aside.CreateChildNode(parent, AddPage(m_ModuleRankMedal.GetModuleUI));
            //Aside.CreateChildNode(parent, AddPage(new FBarChart()));
            //Aside.CreateChildNode(parent, AddPage(new FDoughnutChart()));

            pageIndex = 8000;
            Header.SetNodePageIndex(Header.Nodes[7], pageIndex);
            Header.SetNodeSymbol(Header.Nodes[7], 61499);
            parent = Aside.CreateNode("数据库备份", 61499, 24, pageIndex);
            //直接关联（默认自动生成GUID）
            //Aside.CreateChildNode(parent, AddPage(new FPieChart()));
            //Aside.CreateChildNode(parent, AddPage(new FBarChart()));
            //Aside.CreateChildNode(parent, AddPage(new FDoughnutChart()));

            pageIndex = 9000;
            Header.SetNodePageIndex(Header.Nodes[8], pageIndex);
            Header.SetNodeSymbol(Header.Nodes[8], 61516);
            parent = Aside.CreateNode("官方公告", 61516, 24, pageIndex);
            //直接关联（默认自动生成GUID）
            Aside.CreateChildNode(parent, AddPage(frmOfficialCommunication));
            //Aside.CreateChildNode(parent, AddPage(new FBarChart()));
            //Aside.CreateChildNode(parent, AddPage(new FDoughnutChart()));


            pageIndex = 10000;
            Header.SetNodePageIndex(Header.Nodes[9], pageIndex);
            Header.SetNodeSymbol(Header.Nodes[9], 61668);
            parent = Aside.CreateNode("网络功能", 61668, 24, pageIndex);
            //直接关联（默认自动生成GUID）
            Aside.CreateChildNode(parent, AddPage(new OVRNetworkManagerForm()));
            //Aside.CreateChildNode(parent, AddPage(new FBarChart()));
            //Aside.CreateChildNode(parent, AddPage(new FDoughnutChart()));

            pageIndex = 11000;
            Header.SetNodePageIndex(Header.Nodes[10], pageIndex);
            Header.SetNodeSymbol(Header.Nodes[10], 62104);
            parent = Aside.CreateNode("赛事纪录", 62104, 24, pageIndex);
            //直接关联（默认自动生成GUID）
            Aside.CreateChildNode(parent, AddPage(m_ModuleRecord.GetModuleUI));
            //Aside.CreateChildNode(parent, AddPage(new FBarChart()));
            //Aside.CreateChildNode(parent, AddPage(new FDoughnutChart()));


            Header.SetNodeSymbol(Header.Nodes[11], 61502);
            var styles = UIStyles.PopularStyles();
            foreach (UIStyle style in styles)
            {
                Header.CreateChildNode(Header.Nodes[11], style.DisplayText(), style.Value());
            }
            Aside.SelectFirst();
        }

         private void Header_MenuItemClick(string text, int menuIndex, int pageIndex)
        {
            switch (menuIndex)
            {
                case 0:
                    //ItemGenData();
                    GeneralDataOpen();
                    Aside.SelectPage(pageIndex);
                    break;
                case 1:
                    //ItemRegister();
                    RegisterOpen();
                    Aside.SelectPage(pageIndex);
                    break;
                case 2:
                    //ItemDrawArrage();
                    DrawArrangeOpen();
                    Aside.SelectPage(pageIndex);
                    break;
                case 3:
                    //ItemSchedule();
                    MatchScheduleOpen();
                    Aside.SelectPage(pageIndex);
                    break;
                case 4:
                    //ItemMatchData();
                    PluginMgrOpen();
                    Aside.SelectPage(pageIndex);
                    break;
                case 5:
                    //ItemMedal();
                    RankMedalOpen();
                    Aside.SelectPage(pageIndex);
                    break;
                case 6:
                    //ItemRecord();
                    RecordOpen();
                    Aside.SelectPage(pageIndex);
                    break;
                case 7:
                    DatabaseBackup();
                    Aside.SelectPage(pageIndex);
                    break;
                case 8:
                    OnCommunication();
                    Aside.SelectPage(pageIndex);
                    break;
                case 9:
                    ReportsOpen();
                    Aside.SelectPage(pageIndex);
                    break;
                case 10:

                    Aside.SelectPage(pageIndex);
                    break;

                case 11:
                    UIStyle style = (UIStyle)pageIndex;
                    StyleManager.Style = style;
                    break;
            }
        }

    }

}
