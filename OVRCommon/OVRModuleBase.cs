using System;
using Sunny.UI;

namespace AutoSports.OVRCommon
{
    public enum OVRFrame2ModuleEventType
    {
        emUnknown = -1,

        // Query Value of System Variables in Templates.
        // Type of OVRFrame2ModuleEventArgs.Args is OVRReportContextQueryArgs
        emRptContextQuery,

        // Notify Module to Update Data According OVRDataChangedFlags. 
        // Type of OVRFrame2ModuleEventArgs.Args is OVRDataChangedFlags
        emUpdateData,
        
        // Notify Module to Load Data. 
        // Type of OVRFrame2ModuleEventArgs.Args is NULL
        emLoadData,

        // Notify PluginManager Module to Load Plug in  According Discipline Code.
        // Type of OVRFrame2ModuleEventArgs.Args is string, which specifies the Discipline Code
        emLoadPlugin,

        // Notify GeneralData Module to Update the Network Status.
        // Type of OVRModule2FrameEventArgs.Args is string, which specifies Network Status "OK" or "ERROR"
        emNetworkStatus,

        // Notify ReportManager Module to Load Report Template at the Specified Path.
        // Type of OVRFrame2ModuleEventArgs.Args is string, which specifies Template Path
        emLoadReportTpl
    };

    public enum OVRModule2FrameEventType
    {
        emUnknown = -1,
        
        // Notify Framework Some Data Changed.
        // Type of OVRModule2FrameEventArgs.Args is OVRDataChangedNotifyArgs.
        emDataChanged,

        // Notify Framework System Variables in Templates have Changed.
        // Type of OVRModule2FrameEventArgs.Args is OVRReportContextChangedArgs
        emRptContextChanged,

        // Query Report Info of Current Templates in Report Module.
        // Type of OVRModule2FrameEventArgs.Args is OVRReportInfoQueryArgs
        emReportInfoQuery,

        // Notify Framework to Print the Specified Report.
        // Type of OVRModule2FrameEventArgs.Args is OVRDoReportArgs, which specifies Action Type and Template Name
        emDoReport,
        
        // Notify Framework Current Venue Changed.
        // Type of OVRModule2FrameEventArgs.Args is string, which specifies Venue Code
        emVenueChanged,

        // Notify Framework to Set the Network.
        // Type of OVRModule2FrameEventArgs.Args is NULL
        emNetwork
    };

    public enum OVRReportAction
    {
        emNone = -1,
        emPreview,
        emExportMdc,
        emPrintToPdf
    }

    public class OVRReportInfo
    {
        private string m_strTemplateName;
        public string TemplateName
        {
            get { return m_strTemplateName; }
            set { m_strTemplateName = value; }
        }

        private string m_strReportName;
        public string ReportName
        {
            get { return m_strReportName; }
            set { m_strReportName = value; }
        }

        private string m_strRSC;
        public string RSC
        {
            get { return m_strRSC; }
            set { m_strRSC = value; }
        }

        private string m_strTemplateType;
        public string TemplateType
        {
            get { return m_strTemplateType; }
            set { m_strTemplateType = value; }
        }

        private string m_strTemplateVersion;
        public string TemplateVersion
        {
            get { return m_strTemplateVersion; }
            set { m_strTemplateVersion = value; }
        }

        private bool m_bIsTest;
        public bool IsTest
        {
            get { return m_bIsTest; }
            set { m_bIsTest = value; }
        }

        private bool m_bIsCorrected;
        public bool IsCorrected
        {
            get { return m_bIsCorrected; }
            set { m_bIsCorrected = value; }
        }

        public OVRReportInfo()
        {
            this.m_strTemplateName = null;
            this.m_strReportName = null;
            this.m_strRSC = null;
            this.m_strTemplateType = null;
            this.m_strTemplateVersion = null;
            this.m_bIsTest = false;
            this.m_bIsCorrected = false;
        }
    }

    public class OVRReportInfoQueryArgs
    {
        private OVRReportInfo m_oReportInfo;
        private bool m_bHandled;

        public OVRReportInfoQueryArgs()
        {
            this.m_oReportInfo = null;
            this.m_bHandled = false;
        }

        public OVRReportInfo ReportInfo
        {
            get { return m_oReportInfo; }
            set { m_oReportInfo = value; }
        }

        public bool Handled
        {
            get { return m_bHandled; }
            set { m_bHandled = value; }
        }
    }

    public class OVRDoReportArgs
    {
        private OVRReportAction m_eAction;
        private OVRReportInfo m_oReportInfo;

        public OVRDoReportArgs()
        {
            this.m_eAction = OVRReportAction.emNone;
            this.m_oReportInfo = null;
        }

        public OVRDoReportArgs(OVRReportAction eAction, OVRReportInfo oReportInfo)
        {
            this.m_eAction = eAction;
            this.m_oReportInfo = oReportInfo;
        }

        public OVRReportAction Action
        {
            get { return m_eAction; }
            set { m_eAction = value; }
        }

        public OVRReportInfo ReportInfo
        {
            get { return m_oReportInfo; }
            set { m_oReportInfo = value; }
        }
    }

    public enum OVRDataChangedType
    {
        emUnknown = -1,         // ****(注: ID指的是OVRDataChanged.ID属性)****
        emLangActive,           // ID为变化后的F_LanguageCode
        emSportActive,          // ID为变化后的F_SportID
        emSportInfo,            // ID为F_SportID
        emDisciplineActive,     // ID为变化后的F_DisciplineID
        emDisciplineInfo,       // ID为F_DisciplineID
        emEventAdd,             // ID为F_EventID
        emEventDel,             // ID同上
        emEventInfo,            // ID同上
        emEventModel,           // ID同上
        emEventStatus,          // ID同上
        emEventResult,          // ID同上
        emPhaseAdd,             // ID为F_PhaseID
        emPhaseDel,             // ID同上
        emPhaseInfo,            // ID同上
        emPhaseModel,           // ID同上
        emPhaseStatus,          // ID同上
        emPhaseResult,          // ID同上
        emPhaseProgress,        // ID同上
        emPhaseDraw,            // ID同上
        emMatchAdd,             // ID为F_MatchID
        emMatchDel,             // ID同上
        emMatchInfo,            // ID同上
        emMatchOrderInSession,  // ID同上
        emMatchOrderInRound,    // ID同上
        emMatchWeather,         // ID同上
        emMatchModel,           // ID同上
        emMatchStatus,          // ID同上
        emMatchDate,            // ID同上
        emMatchResult,          // ID同上
        emMatchProgress,        // ID同上
        emMatchOfficials,       // ID同上
        emMatchCompetitor,      // 为该比赛的F_CompetitionPosition
        emMatchCompetitorMember,// ID同上
        emMatchStatistic,       // ID同上
        emMatchSessionSet,      // ID为新设置的F_SessionID
        emMatchSessionReset,    // ID为复位前的F_SessionID
        emMatchCourtSet,        // ID为新设置的F_CourtID
        emMatchCourtReset,      // ID为复位前的F_CourtID
        emSplitAdd,             // ID为F_MatchSplitID
        emSplitDel,             // ID同上
        emSplitInfo,            // ID同上
        emSplitCompetitorMember,// ID同上
        emSplitCompetitor,      // ID同上
        emSplitResult,          // ID同上
        emDateInfo,             // ID为F_DateID
        emDateAdd,              // ID同上
        emDateDel,              // ID同上
        emSessionInfo,          // ID为F_SessionID
        emSessionAdd,           // ID同上
        emSessionDel,           // ID同上
        emVenueInfo,            // ID为F_VenueID
        emVenueAdd,             // ID同上
        emVenueDel,             // ID同上
        emCourtInfo,            // ID为F_CourtID
        emCourtAdd,             // ID同上
        emCourtDel,             // ID同上
        emRegisterAdd,          // ID为F_RegisterID
        emRegisterDel,          // ID同上
        emRegisterModify,       // ID同上
        emRegisterInscription,  // ID均为-1
        emDelegationModify,     // ID均为-1
        emOfficialComAdd,       // ID为F_NewsID
        emOfficialComDel,       // ID同上
        emOfficialComModify,    // ID同上
        Capacity
    };

    public class OVRDataChanged
    {
        private OVRDataChangedType m_emDataChangedType; // Changed Data Type

        private int m_iDisciplineID;// Used for RSC Query
        private int m_iEventID;     // Used for RSC Query
        private int m_iPhaseID;     // Used for RSC Query
        private int m_iMatchID;     // Used for RSC Query

        private object m_oID;       // ID of Changed Data Object
        private string m_strData;   // Actual Data Changed

        public OVRDataChanged()
        {
            m_emDataChangedType = OVRDataChangedType.emUnknown;
            m_iDisciplineID = -1;
            m_iEventID = -1;
            m_iPhaseID = -1;
            m_iMatchID = -1;
            m_oID = null;
            m_strData = null;
        }

        public OVRDataChanged(OVRDataChangedType type, int iDisciplineID, int iEventID, 
                              int iPhaseID, int iMatchID, object oID, string strData)
        {
            m_emDataChangedType = type;
            m_iDisciplineID = iDisciplineID;
            m_iEventID = iEventID;
            m_iPhaseID = iPhaseID;
            m_iMatchID = iMatchID;
            m_oID = oID;
            m_strData = strData;
        }

        public OVRDataChangedType Type
        {
            get { return m_emDataChangedType; }
            set { m_emDataChangedType = value; }
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

        public object ID
        {
            get { return m_oID; }
            set { m_oID = value; }
        }

        public string Data
        {
            get { return m_strData; }
            set { m_strData = value; }
        }
    }

    public class OVRDataChangedNotifyArgs
    {
        private System.Collections.Generic.List<OVRDataChanged> m_ChangedList;

        public OVRDataChangedNotifyArgs()
        {
            this.m_ChangedList = new System.Collections.Generic.List<OVRDataChanged>();
        }

        public System.Collections.Generic.List<OVRDataChanged> ChangedList
        {
            get { return m_ChangedList; }
            set { m_ChangedList = value; }
        }
    }

    public class OVRDataChangedFlags
    {
        private System.Collections.Generic.List<bool> m_lstDataChangedType;
        private int m_nCapacity;

        public OVRDataChangedFlags()
        {
            m_nCapacity = System.Convert.ToInt32(OVRDataChangedType.Capacity);
            m_lstDataChangedType = new System.Collections.Generic.List<bool>();

            for (int i = 0; i < m_nCapacity; i++ )
            {
                m_lstDataChangedType.Add(false);
            }
        }

        public int Capacity
        {
            get { return m_nCapacity; }
        }

        public bool HasSignal
        {
            get
            {
                for (int i = 0; i < m_nCapacity; i++)
                {
                    if (m_lstDataChangedType[i] == true)
                        return true;
                }
                return false;
            }
        }

        public bool IsSignaled(OVRDataChangedType emType)
        {
            int iIndex = System.Convert.ToInt32(emType);

            if (iIndex < 0 || iIndex >= m_nCapacity) return false;

            return m_lstDataChangedType[iIndex];
        }

        public void Signal(OVRDataChangedType emType)
        {
            int iIndex = System.Convert.ToInt32(emType);

            if (iIndex < 0 || iIndex >= m_nCapacity) return;

            m_lstDataChangedType[iIndex] = true;
        }

        public void Signal(System.Collections.Generic.List<OVRDataChanged> changedList)
        {
            if (changedList == null || changedList.Count < 1) return;

            int iIndex;
            for (int i = 0; i < changedList.Count; i++ )
            {
                iIndex = System.Convert.ToInt32(changedList[i].Type);

                if (iIndex >= 0 && iIndex < m_nCapacity)
                    m_lstDataChangedType[iIndex] = true;
            }
        }

        public void Unsignal(OVRDataChangedType emType)
        {
            int iIndex = System.Convert.ToInt32(emType);

            if (iIndex < 0 || iIndex >= m_nCapacity) return;

            m_lstDataChangedType[iIndex] = false;
        }
        
        public void Reset()
        {
            for (int i = 0; i < m_nCapacity; i++ )
            {
                m_lstDataChangedType[i] = false;
            }
        }
    }

    public class OVRReportContextQueryArgs
    {
        private String m_strName;
        private String m_strValue;
        private bool m_bHandled;

        public OVRReportContextQueryArgs()
        {
            this.m_strName  = null;
            this.m_strValue = null;
            this.m_bHandled = false;
        }

        public String Name
        {
            get { return m_strName; }
            set { m_strName = value; }
        }

        public String Value
        {
            get { return m_strValue; }
            set { m_strValue = value; }
        }

        public bool Handled
        {
            get { return m_bHandled; }
            set { m_bHandled = value; }
        }
    }

    public class OVRReportContextChangedArgs
    {
        private String m_strName;
        private String m_strValue;

        public OVRReportContextChangedArgs()
        {
            this.m_strName = null;
            this.m_strValue = null;
        }

        public OVRReportContextChangedArgs(string strName, string strValue)
        {
            this.m_strName = strName;
            this.m_strValue = strValue;
        }

        public String Name
        {
            get { return m_strName; }
            set { m_strName = value; }
        }

        public String Value
        {
            get { return m_strValue; }
            set { m_strValue = value; }
        }
    }

    public class OVRFrame2ModuleEventArgs : EventArgs
    {
        private OVRFrame2ModuleEventType m_emType;
        private object m_oArgs;

        public OVRFrame2ModuleEventArgs()
        {
            this.m_emType = OVRFrame2ModuleEventType.emUnknown;
            this.m_oArgs = null;
        }

        public OVRFrame2ModuleEventArgs(OVRFrame2ModuleEventType emType, object oArgs)
        {
            this.m_emType = emType;
            this.m_oArgs = oArgs;
        }

        public OVRFrame2ModuleEventType Type
        {
            get { return this.m_emType; }
            set { this.m_emType = value; }
        }

        public object Args
        {
            get { return this.m_oArgs; }
            set { this.m_oArgs = value; }
        }
    }

    public class OVRModule2FrameEventArgs : EventArgs
    {
        private OVRModule2FrameEventType m_emType;
        private object m_oArgs;

        public OVRModule2FrameEventArgs()
        {
            this.m_emType = OVRModule2FrameEventType.emUnknown;
            this.m_oArgs = null;
        }

        public OVRModule2FrameEventArgs(OVRModule2FrameEventType emType, object oArgs)
        {
            this.m_emType = emType;
            this.m_oArgs = oArgs;
        }

        public OVRModule2FrameEventType Type
        {
            get { return this.m_emType; }
            set { this.m_emType = value; }
        }

        public object Args
        {
            get { return this.m_oArgs; }
            set { this.m_oArgs = value; }
        }
    }

    public delegate void OVRFrame2ModuleEventHandler(object sender, OVRFrame2ModuleEventArgs args);

    public delegate void OVRModule2FrameEventHandler(object sender, OVRModule2FrameEventArgs args);

    //为项目返回连接对象
    public abstract class OVRDBConnection
    {
        private System.Data.SqlClient.SqlConnection m_sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return this.m_sqlConnection; }
        }
        public virtual bool Initialize(System.Data.SqlClient.SqlConnection con)
        {
            this.m_sqlConnection = con;

            return true;
        }

    }

    public abstract class OVRModuleBase
    {
        protected string m_strName;
        private OVRFrame2ModuleEventHandler m_Frame2ModuleEventHandler;
        private System.Data.SqlClient.SqlConnection m_sqlConnection;

        public OVRModuleBase()
        {
            this.m_strName = "";
            this.m_Frame2ModuleEventHandler = new OVRFrame2ModuleEventHandler(this.OnMainFrameEvent);
        }

        public OVRModuleBase(string strName)
        {
            this.m_strName = strName;
            this.m_Frame2ModuleEventHandler = new OVRFrame2ModuleEventHandler(this.OnMainFrameEvent);
        }

        public string Name
        {
            get { return this.m_strName; }
        }

        public OVRFrame2ModuleEventHandler Frame2ModuleEventHandler
        {
            get { return this.m_Frame2ModuleEventHandler; }
        }

        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return this.m_sqlConnection; }
        }


        public event OVRModule2FrameEventHandler Module2FrameEvent = null;


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

        //public abstract System.Windows.Forms.Control GetModuleUI
        //{
        //    get;
        //}

        public abstract UIPage GetModuleUI
        {
            get;
        }

        public virtual bool Initialize(System.Data.SqlClient.SqlConnection con)
        {
            this.m_sqlConnection = con;

            return true;
        }

        public abstract bool UnInitialize();

        protected abstract void OnMainFrameEvent(object sender, OVRFrame2ModuleEventArgs e);
    }

    //public abstract class OVRModuleBase
    //{
    //    protected string m_strName;
    //    private OVRFrame2ModuleEventHandler m_Frame2ModuleEventHandler;
    //    private System.Data.SqlClient.SqlConnection m_sqlConnection;

    //    public OVRModuleBase()
    //    {
    //        this.m_strName = "";
    //        this.m_Frame2ModuleEventHandler = new OVRFrame2ModuleEventHandler(this.OnMainFrameEvent);
    //    }

    //    public OVRModuleBase(string strName)
    //    {
    //        this.m_strName = strName;
    //        this.m_Frame2ModuleEventHandler = new OVRFrame2ModuleEventHandler(this.OnMainFrameEvent);
    //    }

    //    public string Name
    //    {
    //        get { return this.m_strName; }
    //    }

    //    public OVRFrame2ModuleEventHandler Frame2ModuleEventHandler
    //    {
    //        get { return this.m_Frame2ModuleEventHandler; }
    //    }

    //    public System.Data.SqlClient.SqlConnection DatabaseConnection
    //    {
    //        get { return this.m_sqlConnection; }
    //    }


    //    public event OVRModule2FrameEventHandler Module2FrameEvent = null;


    //    public void NotifyMainFrame(OVRModule2FrameEventType emType, object oArgs)
    //    {
    //        if (this.Module2FrameEvent != null)
    //        {
    //            this.Module2FrameEvent(this, new OVRModule2FrameEventArgs(emType, oArgs));
    //        }
    //    }

    //    public void DataChangedNotify(System.Collections.Generic.List<OVRDataChanged> changedList)
    //    {
    //        if (this.Module2FrameEvent != null)
    //        {
    //            OVRDataChangedNotifyArgs oArgs = new OVRDataChangedNotifyArgs();
    //            oArgs.ChangedList = changedList;
    //            this.Module2FrameEvent(this, new OVRModule2FrameEventArgs(OVRModule2FrameEventType.emDataChanged, oArgs));
    //        }
    //    }

    //    public void DataChangedNotify(OVRDataChangedType emType, int iDisciplineID, int iEventID, 
    //                                  int iPhaseID, int iMatchID, object oID, string strData)
    //    {
    //        if (this.Module2FrameEvent != null)
    //        {
    //            OVRDataChangedNotifyArgs oArgs = new OVRDataChangedNotifyArgs();
    //            oArgs.ChangedList.Add(new OVRDataChanged(emType, iDisciplineID, iEventID, iPhaseID, iMatchID, oID, strData));

    //            this.Module2FrameEvent(this, new OVRModule2FrameEventArgs(OVRModule2FrameEventType.emDataChanged, oArgs));
    //        }
    //    }

    //    public void SetReportContext(string strName, string strValue)
    //    {
    //        if (this.Module2FrameEvent != null)
    //        {
    //            OVRReportContextChangedArgs oArgs = new OVRReportContextChangedArgs(strName, strValue);
    //            this.Module2FrameEvent(this, new OVRModule2FrameEventArgs(OVRModule2FrameEventType.emRptContextChanged, oArgs));
    //        }
    //    }

    //    public abstract System.Windows.Forms.Control GetModuleUI
    //    {
    //        get;
    //    }

    //    public virtual bool Initialize(System.Data.SqlClient.SqlConnection con)
    //    {
    //        this.m_sqlConnection = con;

    //        return true;
    //    }

    //    public abstract bool UnInitialize();

    //    protected abstract void OnMainFrameEvent(object sender, OVRFrame2ModuleEventArgs e);
    //}

}