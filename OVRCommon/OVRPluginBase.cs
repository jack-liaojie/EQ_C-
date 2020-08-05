using System;
using System.Collections.Generic;
using System.Text;

namespace AutoSports.OVRCommon
{
    public enum OVRMgr2PluginEventType
    {
        emUnknown = -1,
        emRptContextQuery,
        emMatchSelected
    };

    public enum OVRPlugin2MgrEventType
    {
        emUnknown = -1,
        emDataEntry,
        emRptContextChanged,
        emUpdateMatchList,
        emToMainFrame
    };

    public class OVRMgr2PluginEventArgs : EventArgs
    {
        private OVRMgr2PluginEventType m_emType;
        private object m_oArgs;

        public OVRMgr2PluginEventArgs()
        {
            this.m_emType = OVRMgr2PluginEventType.emUnknown;
            this.m_oArgs = null;
        }

        public OVRMgr2PluginEventArgs(OVRMgr2PluginEventType emType, object oArgs)
        {
            this.m_emType = emType;
            this.m_oArgs = oArgs;
        }

        public OVRMgr2PluginEventType Type
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

    public class OVRPlugin2MgrEventArgs : EventArgs
    {
        private OVRPlugin2MgrEventType m_emType;
        private object m_oArgs;

        public OVRPlugin2MgrEventArgs()
        {
            this.m_emType = OVRPlugin2MgrEventType.emUnknown;
            this.m_oArgs = null;
        }

        public OVRPlugin2MgrEventArgs(OVRPlugin2MgrEventType emType, object oArgs)
        {
            this.m_emType = emType;
            this.m_oArgs = oArgs;
        }

        public OVRPlugin2MgrEventType Type
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

    public delegate void OVRMgr2PluginEventHandler(object sender, OVRMgr2PluginEventArgs args);

    public delegate void OVRPlugin2MgrEventHandler(object sender, OVRPlugin2MgrEventArgs args);

    public abstract class OVRPluginBase
    {
        protected string m_strName;

        protected string m_strDiscCode;

        private OVRMgr2PluginEventHandler m_PluginEventHandler;

        private System.Data.SqlClient.SqlConnection m_sqlConnection;

        public OVRPluginBase()
        {
            this.m_strName = "";
            this.m_strDiscCode = "";
            this.m_PluginEventHandler = new OVRMgr2PluginEventHandler(this.OnMgrEvent);
        }


        public string Name
        {
            get { return this.m_strName; }
        }

        public string DiscCode
        {
            get { return this.m_strDiscCode; }
        }

        public OVRMgr2PluginEventHandler PluginEventHandler
        {
            get { return this.m_PluginEventHandler; }
        }

        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return this.m_sqlConnection; }
        }


        public event OVRPlugin2MgrEventHandler Plugin2MgrEvent = null;


        public void NotifyPluginMgr(OVRPlugin2MgrEventArgs e)
        {
            if (this.Plugin2MgrEvent != null)
            {
                this.Plugin2MgrEvent(this, e);
            }
        }

        public void UpdateMatchList()
        {
            if (this.Plugin2MgrEvent != null)
            {
                this.Plugin2MgrEvent(this, new OVRPlugin2MgrEventArgs(OVRPlugin2MgrEventType.emUpdateMatchList, null));
            }
        }

        public void DataChangedNotify(OVRDataChangedType emType)
        {
            if (this.Plugin2MgrEvent != null)
            {
                OVRDataChangedNotifyArgs oArgs = new OVRDataChangedNotifyArgs();
                oArgs.ChangedList.Add(new OVRDataChanged(emType, -1, -1, -1, -1, null, null));
                this.Plugin2MgrEvent(this, new OVRPlugin2MgrEventArgs(OVRPlugin2MgrEventType.emDataEntry, oArgs));
            }
        }

        public void DataChangedNotify(System.Collections.Generic.List<OVRDataChanged> changedList)
        {
            if (this.Plugin2MgrEvent != null)
            {
                OVRDataChangedNotifyArgs oArgs = new OVRDataChangedNotifyArgs();
                oArgs.ChangedList = changedList;
                this.Plugin2MgrEvent(this, new OVRPlugin2MgrEventArgs(OVRPlugin2MgrEventType.emDataEntry, oArgs));
            }
        }

        public void DataChangedNotify(OVRDataChangedType emType, int iDisciplineID, int iEventID,
                                      int iPhaseID, int iMatchID, object oID, string strData)
        {
            if (this.Plugin2MgrEvent != null)
            {
                OVRDataChangedNotifyArgs oArgs = new OVRDataChangedNotifyArgs();
                oArgs.ChangedList.Add(new OVRDataChanged(emType, iDisciplineID, iEventID, iPhaseID, iMatchID, oID, strData));

                this.Plugin2MgrEvent(this, new OVRPlugin2MgrEventArgs(OVRPlugin2MgrEventType.emDataEntry, oArgs));
            }
        }

        public void SetReportContext(string strName, string strValue)
        {
            if (this.Plugin2MgrEvent != null)
            {
                OVRReportContextChangedArgs oArgs = new OVRReportContextChangedArgs(strName, strValue);
                this.Plugin2MgrEvent(this, new OVRPlugin2MgrEventArgs(OVRPlugin2MgrEventType.emRptContextChanged, oArgs));
            }
        }

        public abstract System.Windows.Forms.Control GetModuleUI
        {
            get;
        }

        public virtual bool Initialize(System.Data.SqlClient.SqlConnection con)
        {
            this.m_sqlConnection = con;

            return true;
        }

        public virtual bool UnInitialize()
        {
            return true;
        }

        protected abstract void OnMgrEvent(object sender, OVRMgr2PluginEventArgs e);
    }
}
