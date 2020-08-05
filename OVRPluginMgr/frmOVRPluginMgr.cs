using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

using AutoSports.OVRCommon;
using DevComponents.DotNetBar;
using Sunny.UI;

namespace AutoSports.OVRPluginMgr
{
    public delegate void OVRBasicMethods();

    public partial class OVRPluginMgrForm : UIPage
    {
        private DataTable dtMatchList;
        private DataTable dtFilterEvent;
        private DataTable dtFilterDate;
        private DataTable dtFilterVenue;
        private DataTable dtFilterPhase;
        private DataTable dtFilterCourt;


        private SqlCommand cmdSelMatchList;
        private SqlCommand cmdSelFilterEvent;
        private SqlCommand cmdSelFilterDate;
        private SqlCommand cmdSelFilterVenue;
        private SqlCommand cmdSelFilterPhase;
        private SqlCommand cmdSelFilterCourt;

        private SqlDataAdapter daFill;

        private int m_iStatusIndex;
        private string m_strDiscCode;
        private string strSectionName = "OVRPluginMgr";

        private OVRPluginBase m_Plugin;

        private OVRPluginMgrModule m_pluginMgrModule;

        private event OVRMgr2PluginEventHandler m_Mgr2PluginEvent = null;

        public OVRPluginMgrModule PluginMgrModule
        {
            set { m_pluginMgrModule = value; }
        }

        public OVRPluginMgrForm(string strName)
        {
            InitializeComponent();

            this.Name = strName;

            this.dtMatchList = new DataTable("MatchList");
            this.dtFilterEvent = new DataTable("FilterEvent");
            this.dtFilterDate = new DataTable("FilterDate");
            this.dtFilterVenue = new DataTable("FilterVenue");
            this.dtFilterPhase = new DataTable("FilterPhase");
            this.dtFilterCourt = new DataTable("FilterCourt");

            this.cmdSelMatchList = new SqlCommand();
            this.cmdSelFilterEvent = new SqlCommand();
            this.cmdSelFilterDate = new SqlCommand();
            this.cmdSelFilterVenue = new SqlCommand();
            this.cmdSelFilterPhase = new SqlCommand();
            this.cmdSelFilterCourt = new SqlCommand();

            this.daFill = new SqlDataAdapter();

            this.m_strDiscCode = "TS";
            this.m_iStatusIndex = -2;
        }

        public bool UnInitialize()
        {
            if (m_Plugin != null)
            {
                return m_Plugin.UnInitialize();
            }
            else
                return true;
        }

        public void OnMainFrameEvent(object sender, OVRFrame2ModuleEventArgs e)
        {
            switch (e.Type)
            {
                case OVRFrame2ModuleEventType.emLoadPlugin:
                    {
                        LoadPlugin(e.Args as String);
                        break;
                    }
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

        private void QueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;

            if (m_Plugin != null)
            {
                OVRReportContextQueryArgs oArgs = new OVRReportContextQueryArgs();
                OVRMgr2PluginEventArgs oEventArgs = new OVRMgr2PluginEventArgs(OVRMgr2PluginEventType.emRptContextQuery, oArgs);

                oArgs.Name = args.Name;
                m_Mgr2PluginEvent(this, oEventArgs);
                if (oArgs.Handled)
                {
                    args.Value = oArgs.Value;
                    args.Handled = true;
                }
            }
        }

        private void LoadPlugin(string strDiscCode)   //加载插件
        {
            try
            {
                this.m_strDiscCode = strDiscCode;
                string strFile = System.IO.Path.GetDirectoryName(Application.ExecutablePath) + "\\Plugin\\{0}.dll";
                strFile = String.Format(strFile, strDiscCode);
                System.Reflection.Assembly asmPlugin = System.Reflection.Assembly.LoadFile(strFile);
                //System.Reflection.Assembly asmPlugin = System.Reflection.Assembly.LoadFrom(strFile);

                Type[] types = asmPlugin.GetTypes();
                foreach (Type type in types)
                {
                    if (type.IsSubclassOf(typeof(OVRPluginBase)))
                    {
                        OVRPluginBase plugin = (OVRPluginBase)Activator.CreateInstance(type);
                        if (String.Compare(strDiscCode, plugin.DiscCode, true) == 0)
                        {
                            this.m_Plugin = plugin;

                            this.m_Plugin.Plugin2MgrEvent += new OVRPlugin2MgrEventHandler(OnPluginEvent);
                            this.m_Mgr2PluginEvent += this.m_Plugin.PluginEventHandler;
                            this.m_Plugin.Initialize(this.m_pluginMgrModule.DatabaseConnection);
                            this.panelPluginMgr.Controls.Add(this.m_Plugin.GetModuleUI);
                            this.m_Plugin.GetModuleUI.Visible = true;
                            this.m_Plugin.GetModuleUI.Dock = DockStyle.Fill;
                        }
                    }
                }
            }
            catch (System.Exception ex)
            {
                string strCaption = LocalizationRecourceManager.GetString(strSectionName, "LoadPluginError");
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, strCaption, MessageBoxButtons.OK);
            }

        }
        #region   刷新按钮
        private void LoadData()       
        {
            UpdateDate();
            UpdateEvent();
            UpdatePhase();
            UpdateVenue();
            UpdateCourt();
            UpdateMatchList();
        }
        #endregion
        private void UpdateData(OVRDataChangedFlags flags)  //数据变化之后一系列的变化
        {
            if (flags == null || !flags.HasSignal)
                return;

            if (flags.IsSignaled(OVRDataChangedType.emLangActive))
            {
                LoadData();
                return;
            }

            bool bUpdateFilter = false;

            if (flags.IsSignaled(OVRDataChangedType.emEventInfo) ||
                flags.IsSignaled(OVRDataChangedType.emEventAdd)  ||
                flags.IsSignaled(OVRDataChangedType.emEventDel))
            {
                UpdateEvent();
                bUpdateFilter = true;
            }

            if (flags.IsSignaled(OVRDataChangedType.emDateAdd) ||
                flags.IsSignaled(OVRDataChangedType.emDateDel) ||
                flags.IsSignaled(OVRDataChangedType.emDateInfo))
            {
                UpdateDate();
                bUpdateFilter = true;
            }

            if (flags.IsSignaled(OVRDataChangedType.emVenueAdd) ||
                flags.IsSignaled(OVRDataChangedType.emVenueDel) ||
                flags.IsSignaled(OVRDataChangedType.emVenueInfo))
            {
                UpdateVenue();
                bUpdateFilter = true;
            }

            if (flags.IsSignaled(OVRDataChangedType.emPhaseAdd) ||
                flags.IsSignaled(OVRDataChangedType.emPhaseDel) ||
                flags.IsSignaled(OVRDataChangedType.emPhaseInfo))
            {
                UpdatePhase();
                bUpdateFilter = true;
            }

            if (flags.IsSignaled(OVRDataChangedType.emCourtAdd) ||
               flags.IsSignaled(OVRDataChangedType.emCourtDel) ||
               flags.IsSignaled(OVRDataChangedType.emCourtInfo))
            {
                UpdateCourt();
                bUpdateFilter = true;
            }

            if (bUpdateFilter ||
                flags.IsSignaled(OVRDataChangedType.emEventModel) ||
                flags.IsSignaled(OVRDataChangedType.emPhaseAdd) ||
                flags.IsSignaled(OVRDataChangedType.emPhaseDel) ||
                flags.IsSignaled(OVRDataChangedType.emPhaseModel) ||
                flags.IsSignaled(OVRDataChangedType.emPhaseProgress) ||
                flags.IsSignaled(OVRDataChangedType.emMatchAdd) ||
                flags.IsSignaled(OVRDataChangedType.emMatchDel) ||
                flags.IsSignaled(OVRDataChangedType.emMatchInfo) ||
                flags.IsSignaled(OVRDataChangedType.emMatchCompetitor) ||
                flags.IsSignaled(OVRDataChangedType.emMatchStatus) ||
                flags.IsSignaled(OVRDataChangedType.emMatchDate) ||
                flags.IsSignaled(OVRDataChangedType.emMatchSessionSet) ||
                flags.IsSignaled(OVRDataChangedType.emMatchSessionReset) ||
                flags.IsSignaled(OVRDataChangedType.emMatchCourtSet) ||
                flags.IsSignaled(OVRDataChangedType.emMatchCourtReset) ||
                flags.IsSignaled(OVRDataChangedType.emMatchProgress) ||
                flags.IsSignaled(OVRDataChangedType.emRegisterModify))
            {
                UpdateMatchList();
            }
        }

        private void OnPluginEvent(object sender, OVRPlugin2MgrEventArgs e)
        {
            switch (e.Type)
            {
                case OVRPlugin2MgrEventType.emDataEntry:
                    {
                        OVRDataChangedNotifyArgs oArgs = e.Args as OVRDataChangedNotifyArgs;
                        if (oArgs != null)
                        {
                            m_pluginMgrModule.DataChangedNotify(oArgs.ChangedList);
                            bool bStatusChanged = false;
                            foreach (OVRDataChanged item in oArgs.ChangedList)
                            {
                                if (item.Type == OVRDataChangedType.emMatchStatus)
                                {
                                    bStatusChanged = true;
                                    break;
                                }
                            }
                            if (bStatusChanged)
                                UpdateMatchListThreadSafe();
                        }

                        break;
                    }
                case OVRPlugin2MgrEventType.emUpdateMatchList:
                    {
                        UpdateMatchListThreadSafe();

                        break;
                    }
                case OVRPlugin2MgrEventType.emRptContextChanged:
                    {
                        OVRReportContextChangedArgs oArgs = e.Args as OVRReportContextChangedArgs;
                        if (oArgs != null)
                            m_pluginMgrModule.SetReportContext(oArgs.Name, oArgs.Value);
                        break;
                    }
                case OVRPlugin2MgrEventType.emToMainFrame:
                    {
                        OVRModule2FrameEventArgs oArgs = e.Args as OVRModule2FrameEventArgs;
                        if (oArgs != null)
                            m_pluginMgrModule.NotifyMainFrame(oArgs.Type, oArgs.Args);
                        break;
                    }
            }
        }

        private void UpdateMatchListThreadSafe()
        {
            if (this.InvokeRequired)
            {
                OVRBasicMethods delegateUpdateMatchList = new OVRBasicMethods(UpdateMatchList);

                this.Invoke(delegateUpdateMatchList);

                return;
            }

            UpdateMatchList();
        }


        private void OVRPluginMgrForm_Load(object sender, EventArgs e)
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchList);

            Localization();

            SelCommandSetup();

            LoadData();
        }

        private void Localization()
        {
            this.btnUpdate.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "Update");
            this.lbMatchList.Text = LocalizationRecourceManager.GetString(strSectionName, "MatchList");
            this.lbFilterEvent.Text = LocalizationRecourceManager.GetString(strSectionName, "Event");
            this.lbFilterDate.Text = LocalizationRecourceManager.GetString(strSectionName, "Date");
            this.lbFilterVenue.Text = LocalizationRecourceManager.GetString(strSectionName, "Venue");
            this.lbFilterPhase.Text = LocalizationRecourceManager.GetString(strSectionName, "Phase");
            this.lbFilterCourt.Text = LocalizationRecourceManager.GetString(strSectionName, "Court");
        }

        private void SelCommandSetup() //用到了存储过程
        {
            //this.cmdSelFilterEvent.Connection = this.m_pluginMgrModule.DatabaseConnection;
            //this.cmdSelFilterEvent.CommandText = "Proc_GetDisciplineEventList";
            //this.cmdSelFilterEvent.CommandType = CommandType.StoredProcedure;
            //this.cmdSelFilterEvent.Parameters.Add(new SqlParameter("@DisciplineCode", SqlDbType.Char, 2));

            //this.cmdSelFilterDate.Connection = this.m_pluginMgrModule.DatabaseConnection;
            //this.cmdSelFilterDate.CommandText = "Proc_GetEventDateList";
            //this.cmdSelFilterDate.CommandType = CommandType.StoredProcedure;
            //this.cmdSelFilterDate.Parameters.Add(new SqlParameter("@DisciplineCode", SqlDbType.Char, 2));
            //this.cmdSelFilterDate.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int));
            //this.cmdSelFilterDate.Parameters.Add(new SqlParameter("@PhaseID", SqlDbType.Int));

            this.cmdSelFilterDate.Connection = this.m_pluginMgrModule.DatabaseConnection;
            this.cmdSelFilterDate.CommandText = "Proc_GetDisciplineDateList";       //得到比赛实际的列表
            this.cmdSelFilterDate.CommandType = CommandType.StoredProcedure;
            this.cmdSelFilterDate.Parameters.Add(new SqlParameter("@DisciplineCode", SqlDbType.Char, 2));

            this.cmdSelFilterEvent.Connection = this.m_pluginMgrModule.DatabaseConnection;
            this.cmdSelFilterEvent.CommandText = "Proc_GetDisciplineEventList";    //得到比赛的列表（5个组别）
            this.cmdSelFilterEvent.CommandType = CommandType.StoredProcedure;
            this.cmdSelFilterEvent.Parameters.Add(new SqlParameter("@DisciplineCode", SqlDbType.Char, 2));
            this.cmdSelFilterEvent.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.NVarChar, 50));


            this.cmdSelFilterPhase.Connection = this.m_pluginMgrModule.DatabaseConnection;
            this.cmdSelFilterPhase.CommandText = "Proc_GetEventPhaseList";      //得到每组比赛的轮次信息（热身赛，1轮，2轮，附加赛）
            this.cmdSelFilterPhase.CommandType = CommandType.StoredProcedure;
            this.cmdSelFilterPhase.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int));
            this.cmdSelFilterPhase.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.NVarChar, 50));


            this.cmdSelFilterVenue.Connection = this.m_pluginMgrModule.DatabaseConnection;
            this.cmdSelFilterVenue.CommandText = "Proc_GetVenueList";           // 得到场馆的信息
            this.cmdSelFilterVenue.CommandType = CommandType.StoredProcedure;
            this.cmdSelFilterVenue.Parameters.Add(new SqlParameter("@DisciplineCode", SqlDbType.Char, 2));

            this.cmdSelFilterCourt.Connection = this.m_pluginMgrModule.DatabaseConnection;
            this.cmdSelFilterCourt.CommandText = "Proc_GetVenueCourtList";      //表中好像没有
            this.cmdSelFilterCourt.CommandType = CommandType.StoredProcedure;
            this.cmdSelFilterCourt.Parameters.Add(new SqlParameter("@VenueID", SqlDbType.Int));

            this.cmdSelMatchList.Connection = this.m_pluginMgrModule.DatabaseConnection;
            this.cmdSelMatchList.CommandText = "Proc_AutoSwitch_SearchMatches";    // 自动查找符合的存储过程
            this.cmdSelMatchList.CommandType = CommandType.StoredProcedure;
            this.cmdSelMatchList.Parameters.Add(new SqlParameter("@DisciplineCode", SqlDbType.Char, 2));
            this.cmdSelMatchList.Parameters.Add(new SqlParameter("@EventID", SqlDbType.Int));
            this.cmdSelMatchList.Parameters.Add(new SqlParameter("@DateTime", SqlDbType.NVarChar, 50));
            this.cmdSelMatchList.Parameters.Add(new SqlParameter("@VenueID", SqlDbType.Int));
            this.cmdSelMatchList.Parameters.Add(new SqlParameter("@PhaseID", SqlDbType.Int));
            this.cmdSelMatchList.Parameters.Add(new SqlParameter("@CourtID", SqlDbType.Int));
        }
        #region 刷新功能
        private void UpdateDate()
        {
            object dateSelValue = this.cmbFilterDate.SelectedValue;
          
            this.cmdSelFilterDate.Parameters[0].Value = this.m_strDiscCode;
            this.dtFilterDate.Clear();
            this.daFill.SelectCommand = this.cmdSelFilterDate;
            this.daFill.Fill(this.dtFilterDate);
            this.cmbFilterDate.DisplayMember = "F_Date";
            this.cmbFilterDate.ValueMember = "F_Date";
            this.cmbFilterDate.DataSource = this.dtFilterDate;

            if (dateSelValue != null)
                this.cmbFilterDate.SelectedValue = dateSelValue;

            if (this.cmbFilterDate.SelectedValue == null && this.cmbFilterDate.Items.Count > 0)
                this.cmbFilterDate.SelectedIndex = 0;
        }

        private void UpdateEvent()
        {
            object eventSelValue = this.cmbFilterEvent.SelectedValue;
            this.cmdSelFilterEvent.Parameters[0].Value = this.m_strDiscCode;
            this.cmdSelFilterEvent.Parameters[1].Value = this.cmbFilterDate.SelectedValue;

            this.dtFilterEvent.Clear();
            this.daFill.SelectCommand = this.cmdSelFilterEvent;
            this.daFill.Fill(this.dtFilterEvent);
            this.cmbFilterEvent.DisplayMember = "F_EventLongName";
            this.cmbFilterEvent.ValueMember = "F_EventID";
            this.cmbFilterEvent.DataSource = this.dtFilterEvent;

            if (eventSelValue != null)
                this.cmbFilterEvent.SelectedValue = eventSelValue;

            if (this.cmbFilterEvent.SelectedValue == null && this.cmbFilterEvent.Items.Count > 0)
                this.cmbFilterEvent.SelectedIndex = 0;
        }

        private void UpdatePhase()
        {
            object phaseSelValue = this.cmbFilterPhase.SelectedValue;

            this.cmdSelFilterPhase.Parameters[0].Value = this.cmbFilterEvent.SelectedValue;
            this.cmdSelFilterPhase.Parameters[1].Value = this.cmbFilterDate.SelectedValue;
         
            this.dtFilterPhase.Clear();
            this.daFill.SelectCommand = this.cmdSelFilterPhase;
            this.daFill.Fill(this.dtFilterPhase);
            this.cmbFilterPhase.DisplayMember = "F_PhaseLongName";
            this.cmbFilterPhase.ValueMember = "F_PhaseID";
            this.cmbFilterPhase.DataSource = this.dtFilterPhase;

            if (phaseSelValue != null)
                this.cmbFilterPhase.SelectedValue = phaseSelValue;

            if (this.cmbFilterPhase.SelectedValue == null && this.cmbFilterPhase.Items.Count > 0)
                this.cmbFilterPhase.SelectedIndex = 0;
        }

        private void UpdateVenue()
        {
            object venueSelValue = this.cmbFilterVenue.SelectedValue;
          
            this.cmdSelFilterVenue.Parameters[0].Value = this.m_strDiscCode;
            this.dtFilterVenue.Clear();
            this.daFill.SelectCommand = this.cmdSelFilterVenue;
            this.daFill.Fill(this.dtFilterVenue);
            this.cmbFilterVenue.DisplayMember = "F_VenueLongName";
            this.cmbFilterVenue.ValueMember = "F_VenueID";
            this.cmbFilterVenue.DataSource = this.dtFilterVenue;

            if (venueSelValue != null)
                this.cmbFilterVenue.SelectedValue = venueSelValue;

            if (this.cmbFilterVenue.SelectedValue == null && this.cmbFilterVenue.Items.Count > 0)
                this.cmbFilterVenue.SelectedIndex = 0;
        }

        private void UpdateCourt()
        {
            object courtSelValue = this.cmbFilterCourt.SelectedValue;
            this.cmdSelFilterCourt.Parameters[0].Value = this.cmbFilterVenue.SelectedValue;
            
            this.dtFilterCourt.Clear();
            this.daFill.SelectCommand = this.cmdSelFilterCourt;
            this.daFill.Fill(this.dtFilterCourt);
            this.cmbFilterCourt.DisplayMember = "F_CourtShortName";
            this.cmbFilterCourt.ValueMember = "F_CourtID";
            this.cmbFilterCourt.DataSource = this.dtFilterCourt;

            if (courtSelValue != null)
                this.cmbFilterCourt.SelectedValue = courtSelValue;

            if (this.cmbFilterCourt.SelectedValue == null && this.cmbFilterCourt.Items.Count > 0)
                this.cmbFilterCourt.SelectedIndex = 0;
        }

        private void UpdateMatchList()
        {
            if (this.cmdSelMatchList.Parameters.Count != 6) return;

            int iFirstDisplayedScrollingRowIndex = dgvMatchList.FirstDisplayedScrollingRowIndex;
            int iFirstDisplayedScrollingColumnIndex = dgvMatchList.FirstDisplayedScrollingColumnIndex;
            if (iFirstDisplayedScrollingRowIndex < 0) iFirstDisplayedScrollingRowIndex = 0;
            if (iFirstDisplayedScrollingColumnIndex < 0) iFirstDisplayedScrollingColumnIndex = 0;

            int iSelMatchID = -1;
            if (dgvMatchList.SelectedRows.Count == 1)
            {
                iSelMatchID = Convert.ToInt32(this.dgvMatchList.SelectedRows[0].Cells["F_MatchID"].Value);
            }

            this.cmdSelMatchList.Parameters[0].Value = this.m_strDiscCode;
            this.cmdSelMatchList.Parameters[1].Value = this.cmbFilterEvent.SelectedValue;
            this.cmdSelMatchList.Parameters[2].Value = this.cmbFilterDate.SelectedValue;
            this.cmdSelMatchList.Parameters[3].Value = this.cmbFilterVenue.SelectedValue;
            this.cmdSelMatchList.Parameters[4].Value = this.cmbFilterPhase.SelectedValue;
            this.cmdSelMatchList.Parameters[5].Value = this.cmbFilterCourt.SelectedValue;


            this.dtMatchList.Clear();
            this.daFill.SelectCommand = this.cmdSelMatchList;
            this.daFill.Fill(this.dtMatchList);

            if (this.dtMatchList.Columns["Status"] != null)
            {
                this.m_iStatusIndex = this.dtMatchList.Columns["Status"].Ordinal;
            }

            OVRCommon.OVRDataBaseUtils.FillDataGridView(dgvMatchList, dtMatchList, null, null);

            // Sort by specified column
            if (dgvMatchList.SortedColumn != null && dgvMatchList.SortOrder != System.Windows.Forms.SortOrder.None)
            {
                if (dgvMatchList.SortOrder == System.Windows.Forms.SortOrder.Ascending)
                {
                    dgvMatchList.Sort(dgvMatchList.SortedColumn, ListSortDirection.Ascending);
                }
                else
                {
                    dgvMatchList.Sort(dgvMatchList.SortedColumn, ListSortDirection.Descending);
                }
            }

            for (int i = 0; i < this.dgvMatchList.RowCount; i++ )
            {
                int iMatchID = Convert.ToInt32(this.dgvMatchList.Rows[i].Cells["F_MatchID"].Value);

                if (iMatchID == iSelMatchID)
                {
                    this.dgvMatchList.Rows[i].Selected = true;
                    break;
                }
            }

            if (iFirstDisplayedScrollingRowIndex < dgvMatchList.Rows.Count)
                dgvMatchList.FirstDisplayedScrollingRowIndex = iFirstDisplayedScrollingRowIndex;
            if (iFirstDisplayedScrollingColumnIndex < dgvMatchList.Columns.Count)
                dgvMatchList.FirstDisplayedScrollingColumnIndex = iFirstDisplayedScrollingColumnIndex;
        }
        #endregion
        private void btnUpdate_Click(object sender, EventArgs e)
        {
            LoadData();
        }

        private void cmbFilterDate_SelectionChangeCommitted(object sender, EventArgs e)
        {
            UpdateEvent();
            UpdatePhase();
            UpdateMatchList();
        }

        private void cmbFilterEvent_SelectionChangeCommitted(object sender, EventArgs e)
        {
            UpdatePhase();
            UpdateMatchList();
        }

        private void cmbFilterPhase_SelectionChangeCommitted(object sender, EventArgs e)
        {
            UpdateMatchList();
        }

        private void cmbFilterVenue_SelectionChangeCommitted(object sender, EventArgs e)
        {
            UpdateCourt();
            UpdateMatchList();
        }

        private void cmbFilterCourt_SelectionChangeCommitted(object sender, EventArgs e)
        {
            UpdateMatchList();
        }

        private void dgvMatchList_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.ColumnIndex < 0 || e.RowIndex < 0) return;

            if (this.m_Mgr2PluginEvent != null)
            {
                int iMatchID = Convert.ToInt32(this.dgvMatchList.Rows[e.RowIndex].Cells["F_MatchID"].Value);
                this.m_Mgr2PluginEvent(this, new OVRMgr2PluginEventArgs(OVRMgr2PluginEventType.emMatchSelected, iMatchID));
            }
        }

        private void dgvMatchList_CellPainting(object sender, DataGridViewCellPaintingEventArgs e)
        {
            if (this.m_iStatusIndex == e.ColumnIndex)
            {
                if (String.Compare(e.Value.ToString(), "RUNNING", true) == 0 ||
                    String.Compare(e.Value.ToString(), "SUSPEND", true) == 0)
                {
                    e.CellStyle.ForeColor = System.Drawing.Color.Red;
                }
                else if (String.Compare(e.Value.ToString(), "OFFICIAL", true) == 0 ||
                         String.Compare(e.Value.ToString(), "UNOFFICIAL", true) == 0 ||
                         String.Compare(e.Value.ToString(), "REVISION", true) == 0 ||
                         String.Compare(e.Value.ToString(), "FINISHED", true) == 0)
                {
                    e.CellStyle.ForeColor = System.Drawing.Color.LimeGreen;
                }
            }
        }

        private void panelFilter_Resize(object sender, EventArgs e)
        {
            this.SuspendLayout();
            int iWidth = panelFilter.Width - 45;
            cmbFilterEvent.Width = iWidth;
            cmbFilterDate.Width = iWidth;
            cmbFilterVenue.Width = iWidth;
            cmbFilterPhase.Width = iWidth;
            cmbFilterCourt.Width = iWidth;
            this.ResumeLayout();
        }

     

    }
}
