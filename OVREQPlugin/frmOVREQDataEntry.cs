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
using System.Xml.Serialization;
using System.Collections;
using System.IO;
using System.Text.RegularExpressions;
using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    public delegate void UpdateDgvMatchResultHandler();
    public delegate void UpdateWhenRegisterStatusHandler(int iMatchID, int iRegisterID);

    public partial class frmOVREQDataEntry : UIPage
    {
        #region Fields
        private Int32 m_iSportID;
        private Int32 m_iDisciplineID;
        private Int32 m_iCurMatchID;
        private Int32 m_iCurMatchConfigID;
        private String m_strCurMatchConfigCode;
        private Int32 m_iCurIndividualMatchID = -1;
        private Int32 m_iCurTeamMatchID = -1;
        private Int32 m_iCurStatusID;
        private Int32 m_iCurMatchRuleID = -1;
        private String m_strCurMatchRuleCode;
        private Int32 m_iCurRegisterID = -1;
        private Int32 m_iCurJudgePosition = -1;
        private Int32 m_iCurResultRowID = 0;
        private Int32 m_iCurResultDetailsRowID = 0;
        private String m_strCurEventConfigCode;
        //显示Team成绩
        private bool m_bIsTeamMatch = false;
        private bool m_bShowTeam = false;
        //当前比赛
        private bool m_bIsRunning;
        private String m_strLanguageCode = "ENG";
        private String m_strEventName = "";
        private String m_strMatchName = "";
        private String m_strDateDes = "";
        private String m_strVenueDes = "";
        private String m_strMatchTitle = "";
        //场地障碍，越野计时计分接口相关
        private TimingIF timingIF = null;
        private TCPReceiver tcpReceiver = null;
        private bool m_bReceData = true;
        //Ipad打分器监控窗口
        private frmOVREQIPadMark frmIpadMark;

        private DataTable m_dtMatchConfig;
        #endregion

        #region Properties
        public Int32 CurMatchID
        {
            get { return m_iCurMatchID; }
            set { m_iCurMatchID = value; }
        }

        public bool ReceData
        {
            get { return m_bReceData; }
            set { m_bReceData = value; }
        }


        public Int32 CurMatchConfigID
        {
            get { return m_iCurMatchConfigID; }
            set { m_iCurMatchConfigID = value; }
        }
        #endregion

        #region Constructor 构造函数

        public frmOVREQDataEntry()
        {
            InitializeComponent();

            //设置datagridview样式
            SetDataGridViewStyle();

            //界面按钮不可用
            m_bIsRunning = false;
            InitMatchBtnStatus();

        }

        //设置datagridview样式
        private void SetDataGridViewStyle()
        {
            //初始化dgv样式
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchResults);
            dgvMatchResults.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvMatchResults.MultiSelect = false;
            //设置列标题的高度
            dgvMatchResults.ColumnHeadersHeight = 60;

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchResultDetails);
            dgvMatchResultDetails.SelectionMode = DataGridViewSelectionMode.CellSelect;
            dgvMatchResultDetails.MultiSelect = false;

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchPenType);
        }

        //初始化按钮是否可点击和可见
        private void InitMatchBtnStatus()
        {
            btnx_Judges.Enabled = m_bIsRunning;
            btnx_Config.Enabled = m_bIsRunning;
            btnx_Exit.Enabled = m_bIsRunning;
            btnx_Status.Enabled = m_bIsRunning;
            btnx_ClearData.Enabled = m_bIsRunning;
            btnx_Refresh.Enabled = m_bIsRunning;
            btnx_TeamResult.Enabled = m_bIsRunning;
            btnx_TeamResult.Visible = m_bIsTeamMatch;
            g_NetServer.Enabled = m_bIsRunning;
            g_NetClient.Enabled = m_bIsRunning;
        }

        #endregion

        #region Form Load

        //窗体加载消息的响应函数
        private void frmOVREQDataEntry_Load(object sender, EventArgs e)
        {
            //加载多语言
            Localization();
            lb_EventDes.Text = "";
            lb_MatchDes.Text = "";
            lb_DateDes.Text = "";
            //lb_VenueDes.Text = "";
        }

        //多语言
        private void Localization()
        {
            btnx_Exit.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_Exit");
            btnx_Config.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_Config");
            btnx_Judges.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_Judges");
            btnx_ClearData.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_ClearData");
            btnx_Refresh.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_Refresh");

            lb_Event.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "lb_Event");
            //lb_Venue.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "lb_Venue");
            lb_Date.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "lb_Date");
            lb_Match.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "lb_Match");

            btnx_Status.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_Status");
            btnx_Schedule.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_Schedule");
            btnx_StartList.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_StartList");
            btnx_Running.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_Running");
            btnx_Suspend.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_Suspend");
            btnx_Unofficial.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_Unofficial");
            btnx_Finished.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_Finished");
            btnx_Revision.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_Revision");
            btnx_Canceled.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_Canceled");

            btnx_TeamResult.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_TeamResult");

            g_MatchInfo.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "g_MatchInfo");
            g_MatchScore.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "g_MatchScore");
            g_MatchScoreDetail.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "g_MatchScoreDetail");

            //障碍类计时接口参数
            string strIP = ConfigurationManager.GetPluginSettingString("EQ", "TCP_IP");
            string strPort = ConfigurationManager.GetPluginSettingString("EQ", "TCP_Port");
            if (strIP.Length == 0)
                this.ipAddressInput.Value = "192.168.1.100";
            else
                this.ipAddressInput.Value = strIP;
            if (strPort.Length == 0)
                this.txtBoxX_ConnectPort.Text = "12100";
            else
                this.txtBoxX_ConnectPort.Text = strPort;

            //盛装打分器接口参数
            string strUDPPort = ConfigurationManager.GetPluginSettingString("EQ", "UDP_Port");
            if (strUDPPort.Length == 0)
                this.txtBoxX_ListenPort.Text = "5000";
            else
                this.txtBoxX_ListenPort.Text = strUDPPort;


        }

        #endregion

        #region Match Selected

        public void OnMsgFlushSelMatch(Int32 iWndMode, Int32 iMatchID)
        {
            m_iCurMatchID = iMatchID;
            // Is Running 
            if (m_bIsRunning)
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "mbRunningMatch"), GVAR.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            m_iCurIndividualMatchID = GVAR.g_EQDBManager.GetIndividualMatchID(m_iCurMatchID);
            m_iCurTeamMatchID = GVAR.g_EQDBManager.GetTeamMatchID(m_iCurMatchID);

            //加载MatchConfig
            m_dtMatchConfig = GVAR.g_EQDBManager.GetMatchConfig(m_iCurIndividualMatchID);

            // 判断当前比赛是否存在比赛配置信息（比赛配置信息表在initialDB的时候导入）
            if (m_dtMatchConfig.Rows.Count < 1)
            {
                GVAR.MsgBox(LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "mbMatchNotConfiged"), GVAR.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            m_iCurMatchConfigID = GVAR.Str2Int(m_dtMatchConfig.Rows[0]["F_MatchConfigID"].ToString());
            m_strCurMatchConfigCode = m_dtMatchConfig.Rows[0]["F_MatchConfigCode"].ToString();
            m_iCurMatchRuleID = GVAR.Str2Int(m_dtMatchConfig.Rows[0]["F_MatchRuleID"].ToString());
            m_strCurMatchRuleCode = m_dtMatchConfig.Rows[0]["F_MatchRuleCode"].ToString();
            m_strCurEventConfigCode = m_dtMatchConfig.Rows[0]["F_EventConfigCode"].ToString();


            //获取当前比赛信息，填写页头内容,显示官员按钮和配置按钮
            InitMatchInfo(m_iCurMatchID);

            //判断是否有对应的团队比赛，如果是则显示Team按钮
            if (m_iCurTeamMatchID != -1)
            {
                m_bIsTeamMatch = true;
            }

            //判断当前显示团体比赛还是个人比赛
            if (m_iCurMatchID == m_iCurTeamMatchID)
            {
                m_bShowTeam = true;
            }

            //判断是否已经添加成绩行，如果未添加则添加
            if (!GVAR.g_EQDBManager.IsAddMatchResultsRows(m_iCurIndividualMatchID))
            {
                //每个Event的第一场比赛将该Event的所有报项数据插入TS_EQ_Match_Result,同时插入对应的TS_EQ_Match_ResultDetail
                //判断添加成绩行是否成功
                if (!GVAR.g_EQDBManager.AddMatchResultsRows(m_iCurIndividualMatchID))
                {
                    GVAR.MsgBox(LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "mbRegisterNotArranged"), GVAR.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                //复位比赛状态包括个人和团体
                m_iCurStatusID = GVAR.STATUS_STARTLIST;
                UpdateMatchStatusEQ();
            }

            //设置界面按钮可用
            m_bIsRunning = true;
            InitMatchBtnStatus();

            //盛装舞步使用UDP Server
            if (m_strCurMatchRuleCode.Equals("DR"))
            {
                g_NetClient.Visible = false;
                g_NetServer.Visible = true;
            }
            //场地障碍和越野使用TCP Client
            else
            {
                g_NetClient.Visible = true;
                g_NetServer.Visible = false;
            }

            //基于当前比赛状态，更新比赛状态按钮是否点击
            UpdateMatchStatus();

            //初始化选择行
            m_iCurResultRowID = 0;

            //dgv重新加载，重置readonly状态
            dgvMatchResults.ReadOnly = false;
            dgvMatchResultDetails.ReadOnly = false;

            //初始化比赛成绩数据
            //基于所选择的MatchID，初始化dgvMatchResults和dgvMatchResultDetails
            if (m_bShowTeam)
            {
                g_MatchScoreDetail.Visible = false;
                btnx_TeamResult.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_IndividualResult");
                InitDgvMatchResultList();
            }
            else
            {
                g_MatchScoreDetail.Visible = true;
                btnx_TeamResult.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_TeamResult");
                InitDgvMatchResultList();
                InitDgvMatchResultDetailList();
                InitDgvMatchPenTypeList();
            }

            //验马隐藏dgvdetail
            if (m_strCurMatchRuleCode.Equals("R") || m_strCurMatchRuleCode.Equals("BR"))
            {
                g_MatchScoreDetail.Visible = false;
            }

        }

        private void InitMatchInfo(Int32 iMatchID)
        {
            //获取比赛项目基本信息
            OVRDataBaseUtils.GetActiveInfo(GVAR.g_adoDataBase.DBConnect, out m_iSportID, out m_iDisciplineID, out m_strLanguageCode);
            GVAR.g_EQDBManager.GetActiveSportInfo();
            //比赛基本信息
            if (iMatchID != -1)
            {
                GVAR.g_EQDBManager.GetMatchInfo(iMatchID, ref m_strEventName, ref m_strMatchName, ref m_strDateDes, ref m_strVenueDes, ref m_iDisciplineID, ref m_iCurStatusID);

                lb_EventDes.Text = m_strEventName;
                lb_MatchDes.Text = m_strMatchName;
                lb_DateDes.Text = m_strDateDes;
                //lb_VenueDes.Text = m_strVenueDes;

                m_strMatchTitle = m_strEventName + m_strMatchName;

                btnx_Judges.Enabled = true;
                btnx_Config.Enabled = true;
            }
        }

        #endregion

        #region Report

        public void QueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;

            switch (args.Name)
            {
                case "MatchID":
                    {
                        args.Value = m_iCurMatchID.ToString();
                        args.Handled = true;
                    }
                    break;
                default:
                    break;
            }
        }

        #endregion

        #region MatchResult DGV

        public bool IsShowAllChecked()
        {
            return chkX_ShowAll.Checked;
        }

        private void InitDgvMatchResultList()
        {
            //列表加载时不响应selectionchanged消息
            this.dgvMatchResults.SelectionChanged -= new System.EventHandler(this.dgvMatchResults_SelectionChanged);
            this.dgvMatchResults.CellValidating -= new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgvMatchResults_CellValidating);
            this.dgvMatchResults.CellValueChanged -= new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchResults_CellValueChanged);
            //根据显示标志，选择调用个人或团体的取数据方法
            GVAR.g_EQDBManager.InitDgvMatchResultList(m_iCurMatchID, IsShowAllChecked(),ref dgvMatchResults);

            //如果dgvMatchResults内容为空，则退出
            if (dgvMatchResults.Columns.Count < 1)
                return;

            //不显示序号列
            dgvMatchResults.RowHeadersVisible = false;

            //修改rank列的颜色
            for (int i = 0; i < dgvMatchResults.Columns.Count; i++)
            {
                if (dgvMatchResults.Columns[i].Name.Contains("Rank"))
                {
                    dgvMatchResults.Columns[i].DefaultCellStyle.ForeColor = Color.Red;
                }
            }

            //公共部分
            //设置列标题名
            dgvMatchResults.Columns["F_DelegationCode"].HeaderText = "NOC";
            dgvMatchResults.Columns["F_Order"].HeaderText = "Ord";
            dgvMatchResults.Columns["F_Status"].HeaderText = "Status";
            dgvMatchResults.Columns["RegisterName"].HeaderText = "Register\nName";
            dgvMatchResults.Columns["HorseName"].HeaderText = "Horse\nName";
            dgvMatchResults.Columns["RegisterBib"].HeaderText = "Rider\nBib";
            dgvMatchResults.Columns["HorseBib"].HeaderText = "Horse\nBib";
            dgvMatchResults.Columns["F_CurPoints"].HeaderText = "Cur\nPoints";
            dgvMatchResults.Columns["F_CurRank"].HeaderText = "Cur\nRank";
            dgvMatchResults.Columns["F_TotPoints"].HeaderText = "Tot\nPoints";
            dgvMatchResults.Columns["F_TotRank"].HeaderText = "Tot\nRank";
            dgvMatchResults.Columns["F_CurIRM"].HeaderText = "IRM";
            dgvMatchResults.Columns["F_TotResult"].HeaderText = "Tot\nResult";
            dgvMatchResults.Columns["F_Qualify"].HeaderText = "Q";


            //列宽
            dgvMatchResults.Columns["F_DelegationCode"].Width = 60;
            dgvMatchResults.Columns["F_Order"].Width = 30;
            dgvMatchResults.Columns["RegisterName"].Width = 80;
            dgvMatchResults.Columns["HorseName"].Width = 80;
            dgvMatchResults.Columns["RegisterBib"].Width = 45;
            dgvMatchResults.Columns["HorseBib"].Width = 50;
            dgvMatchResults.Columns["F_CurPoints"].Width = 50;
            dgvMatchResults.Columns["F_CurRank"].Width = 50;
            dgvMatchResults.Columns["F_TotPoints"].Width = 60;
            dgvMatchResults.Columns["F_TotRank"].Width = 50;
            dgvMatchResults.Columns["F_CurIRM"].Width = 35;
            dgvMatchResults.Columns["F_TotResult"].Width = 60;
            dgvMatchResults.Columns["F_Qualify"].Width = 22;

            //可编辑
            dgvMatchResults.Columns["F_Order"].ReadOnly = false;
            dgvMatchResults.Columns["F_TotResult"].ReadOnly = false;
            dgvMatchResults.Columns["F_TotRank"].ReadOnly = false;
            dgvMatchResults.Columns["F_TotOrder"].ReadOnly = false;
            dgvMatchResults.Columns["F_Qualify"].ReadOnly = false;

            dgvMatchResults.Columns["RegisterBib"].ReadOnly = false;
            dgvMatchResults.Columns["HorseBib"].ReadOnly = false;
            dgvMatchResults.Columns["RegisterName"].ReadOnly = false;
            dgvMatchResults.Columns["HorseName"].ReadOnly = false;
            dgvMatchResults.Columns["F_CurIRM"].ReadOnly = false;

            //隐藏列
            dgvMatchResults.Columns["F_MatchID"].Visible = false;
            dgvMatchResults.Columns["F_DelegationLongName"].Visible = false;
            dgvMatchResults.Columns["F_DelegationShortName"].Visible = false;
            dgvMatchResults.Columns["F_RegisterID"].Visible = false;
            dgvMatchResults.Columns["F_HorseID"].Visible = false;


            //冻结列
            dgvMatchResults.Columns["RegisterName"].Frozen = true;


            //如果是个人比赛显示
            if (!m_bShowTeam)
            {
                //设置列标题名
                dgvMatchResults.Columns["F_Status"].HeaderText = "Status";
                dgvMatchResults.Columns["F_Team"].HeaderText = "T";
                dgvMatchResults.Columns["F_TotOrder"].HeaderText = "Tot\nOrder";
                //列宽
                dgvMatchResults.Columns["F_Status"].Width = 55;
                dgvMatchResults.Columns["F_Team"].Width = 22;
                dgvMatchResults.Columns["F_TotOrder"].Width = 50;

                dgvMatchResults.Columns["F_TeamRegisterID"].Visible = false;

                if (m_strCurMatchConfigCode.Equals("DRQ1") || m_strCurMatchConfigCode.Equals("DRRA") || m_strCurMatchConfigCode.Equals("DRRB") || m_strCurMatchConfigCode.Equals("EDR"))
                {
                    dgvMatchResults.Columns["F_StartTime"].HeaderText = "Start\nTime";
                    dgvMatchResults.Columns["F_BreakTime"].HeaderText = "Break\nTime";
                    dgvMatchResults.Columns["F_FinishTime"].HeaderText = "Finish\nTime";
                    dgvMatchResults.Columns["F_E"].HeaderText = "E";
                    dgvMatchResults.Columns["F_H"].HeaderText = "H";
                    dgvMatchResults.Columns["F_C"].HeaderText = "C";
                    dgvMatchResults.Columns["F_M"].HeaderText = "M";
                    dgvMatchResults.Columns["F_B"].HeaderText = "B";
                    dgvMatchResults.Columns["F_ERank"].HeaderText = "";
                    dgvMatchResults.Columns["F_HRank"].HeaderText = "";
                    dgvMatchResults.Columns["F_CRank"].HeaderText = "";
                    dgvMatchResults.Columns["F_MRank"].HeaderText = "";
                    dgvMatchResults.Columns["F_BRank"].HeaderText = "";

                    dgvMatchResults.Columns["F_StartTime"].Width = 60;
                    dgvMatchResults.Columns["F_BreakTime"].Width = 60;
                    dgvMatchResults.Columns["F_FinishTime"].Width = 60;
                    dgvMatchResults.Columns["F_E"].Width = 50;
                    dgvMatchResults.Columns["F_H"].Width = 50;
                    dgvMatchResults.Columns["F_C"].Width = 50;
                    dgvMatchResults.Columns["F_M"].Width = 50;
                    dgvMatchResults.Columns["F_B"].Width = 50;
                    dgvMatchResults.Columns["F_ERank"].Width = 22;
                    dgvMatchResults.Columns["F_HRank"].Width = 22;
                    dgvMatchResults.Columns["F_CRank"].Width = 22;
                    dgvMatchResults.Columns["F_MRank"].Width = 22;
                    dgvMatchResults.Columns["F_BRank"].Width = 22;

                    //可编辑
                    dgvMatchResults.Columns["F_StartTime"].ReadOnly = false;
                    dgvMatchResults.Columns["F_E"].ReadOnly = false;
                    dgvMatchResults.Columns["F_H"].ReadOnly = false;
                    dgvMatchResults.Columns["F_C"].ReadOnly = false;
                    dgvMatchResults.Columns["F_M"].ReadOnly = false;
                    dgvMatchResults.Columns["F_B"].ReadOnly = false;

                    //隐藏
                    dgvMatchResults.Columns["F_FinishTime"].Visible = false;

                    //隐藏不可用的裁判点位
                    string judge = m_dtMatchConfig.Rows[0]["F_Judge"].ToString();
                    if (!judge.Contains("E"))
                    {
                        dgvMatchResults.Columns["F_E"].Visible = false;
                        dgvMatchResults.Columns["F_ERank"].Visible = false;
                    }
                    if (!judge.Contains("H"))
                    {
                        dgvMatchResults.Columns["F_H"].Visible = false;
                        dgvMatchResults.Columns["F_HRank"].Visible = false;
                    }
                    if (!judge.Contains("C"))
                    {
                        dgvMatchResults.Columns["F_C"].Visible = false;
                        dgvMatchResults.Columns["F_CRank"].Visible = false;
                    }
                    if (!judge.Contains("M"))
                    {
                        dgvMatchResults.Columns["F_M"].Visible = false;
                        dgvMatchResults.Columns["F_MRank"].Visible = false;
                    }
                    if (!judge.Contains("B"))
                    {
                        dgvMatchResults.Columns["F_B"].Visible = false;
                        dgvMatchResults.Columns["F_BRank"].Visible = false;
                    }

                    if (m_strCurMatchConfigCode.Equals("DRRB"))
                    {
                        dgvMatchResults.Columns["F_ETec"].HeaderText = "ETec";
                        dgvMatchResults.Columns["F_ETecRank"].HeaderText = "";
                        dgvMatchResults.Columns["F_HTec"].HeaderText = "HTec";
                        dgvMatchResults.Columns["F_HTecRank"].HeaderText = "";
                        dgvMatchResults.Columns["F_CTec"].HeaderText = "CTec";
                        dgvMatchResults.Columns["F_CTecRank"].HeaderText = "";
                        dgvMatchResults.Columns["F_MTec"].HeaderText = "MTec";
                        dgvMatchResults.Columns["F_MTecRank"].HeaderText = "";
                        dgvMatchResults.Columns["F_BTec"].HeaderText = "BTec";
                        dgvMatchResults.Columns["F_BTecRank"].HeaderText = "";
                        dgvMatchResults.Columns["F_EArt"].HeaderText = "EArt";
                        dgvMatchResults.Columns["F_EArtRank"].HeaderText = "";
                        dgvMatchResults.Columns["F_HArt"].HeaderText = "HArt";
                        dgvMatchResults.Columns["F_HArtRank"].HeaderText = "";
                        dgvMatchResults.Columns["F_CArt"].HeaderText = "CArt";
                        dgvMatchResults.Columns["F_CArtRank"].HeaderText = "";
                        dgvMatchResults.Columns["F_MArt"].HeaderText = "MArt";
                        dgvMatchResults.Columns["F_MArtRank"].HeaderText = "";
                        dgvMatchResults.Columns["F_BArt"].HeaderText = "BArt";
                        dgvMatchResults.Columns["F_BArtRank"].HeaderText = "";
                        dgvMatchResults.Columns["F_TecPoints"].HeaderText = "Tec";
                        dgvMatchResults.Columns["F_TecRank"].HeaderText = "";
                        dgvMatchResults.Columns["F_ArtPoints"].HeaderText = "Art";
                        dgvMatchResults.Columns["F_ArtRank"].HeaderText = "";
                        dgvMatchResults.Columns["F_HarmonyPoints"].HeaderText = "Harmony\nPoints";

                        dgvMatchResults.Columns["F_ETec"].Width = 50;
                        dgvMatchResults.Columns["F_ETecRank"].Width = 22;
                        dgvMatchResults.Columns["F_HTec"].Width = 50;
                        dgvMatchResults.Columns["F_HTecRank"].Width = 22;
                        dgvMatchResults.Columns["F_CTec"].Width = 50;
                        dgvMatchResults.Columns["F_CTecRank"].Width = 22;
                        dgvMatchResults.Columns["F_MTec"].Width = 50;
                        dgvMatchResults.Columns["F_MTecRank"].Width = 22;
                        dgvMatchResults.Columns["F_BTec"].Width = 50;
                        dgvMatchResults.Columns["F_BTecRank"].Width = 22;
                        dgvMatchResults.Columns["F_EArt"].Width = 50;
                        dgvMatchResults.Columns["F_EArtRank"].Width = 22;
                        dgvMatchResults.Columns["F_HArt"].Width = 50;
                        dgvMatchResults.Columns["F_HArtRank"].Width = 22;
                        dgvMatchResults.Columns["F_CArt"].Width = 50;
                        dgvMatchResults.Columns["F_CArtRank"].Width = 22;
                        dgvMatchResults.Columns["F_MArt"].Width = 50;
                        dgvMatchResults.Columns["F_MArtRank"].Width = 22;
                        dgvMatchResults.Columns["F_BArt"].Width = 50;
                        dgvMatchResults.Columns["F_BArtRank"].Width = 22;
                        dgvMatchResults.Columns["F_TecPoints"].Width = 50;
                        dgvMatchResults.Columns["F_TecRank"].Width = 22;
                        dgvMatchResults.Columns["F_ArtPoints"].Width = 50;
                        dgvMatchResults.Columns["F_ArtRank"].Width = 22;
                        dgvMatchResults.Columns["F_HarmonyPoints"].Width = 80;
                    }
                }
                if(m_strCurMatchConfigCode.Equals("ECC")||m_strCurMatchConfigCode.Equals("EJP1")||m_strCurMatchConfigCode.Equals("EJP2")
                   || m_strCurMatchConfigCode.Equals("JPQ1") || m_strCurMatchConfigCode.Equals("JPQ2") || m_strCurMatchConfigCode.Equals("TJO")
                   || m_strCurMatchConfigCode.Equals("JPRA") || m_strCurMatchConfigCode.Equals("JPRB") || m_strCurMatchConfigCode.Equals("JO"))
                {
                    dgvMatchResults.Columns["F_StartTime"].HeaderText = "Start\nTime";
                    dgvMatchResults.Columns["F_BreakTime"].HeaderText = "Break\nTime";
                    dgvMatchResults.Columns["F_FinishTime"].HeaderText = "Finish\nTime";

                    dgvMatchResults.Columns["F_CurTime"].HeaderText = "Time";
                    dgvMatchResults.Columns["F_CurTimePen"].HeaderText = "Time\nPen";
                    dgvMatchResults.Columns["F_CurJumpPen"].HeaderText = "Jump\nPen";

                    dgvMatchResults.Columns["F_StartTime"].Width = 60;
                    dgvMatchResults.Columns["F_BreakTime"].Width = 60;
                    dgvMatchResults.Columns["F_FinishTime"].Width = 60;

                    dgvMatchResults.Columns["F_CurTime"].Width = 50;
                    dgvMatchResults.Columns["F_CurTimePen"].Width = 50;
                    dgvMatchResults.Columns["F_CurJumpPen"].Width = 50;

                    dgvMatchResults.Columns["F_CurTime"].ReadOnly = false;
                    dgvMatchResults.Columns["F_CurTimePen"].ReadOnly = false;
                    dgvMatchResults.Columns["F_CurJumpPen"].ReadOnly = false;

                    if(!m_strCurMatchConfigCode.Equals("ECC"))
                    {
                        dgvMatchResults.Columns["F_FinishTime"].Visible = false;
                    }
                                       
                }
                //如果是绕桶
                if (m_strCurMatchConfigCode.Equals("BRQ1") || m_strCurMatchConfigCode.Equals("BRQ2")
                || m_strCurMatchConfigCode.Equals("BRRA") || m_strCurMatchConfigCode.Equals("BRRB") || m_strCurMatchConfigCode.Equals("BRJO"))
                {
                    dgvMatchResults.Columns["F_StartTime"].HeaderText = "Start\nTime";
                    dgvMatchResults.Columns["F_BreakTime"].HeaderText = "Break\nTime";
                    dgvMatchResults.Columns["F_FinishTime"].HeaderText = "Finish\nTime";

                    dgvMatchResults.Columns["F_CurTime"].HeaderText = "Time";

                    dgvMatchResults.Columns["F_StartTime"].Width = 60;
                    dgvMatchResults.Columns["F_BreakTime"].Width = 60;
                    dgvMatchResults.Columns["F_FinishTime"].Width = 60;

                    dgvMatchResults.Columns["F_CurTime"].Width = 50;
                    dgvMatchResults.Columns["F_CurTime"].ReadOnly = false;

                    dgvMatchResults.Columns["F_CurPoints"].Visible = false;
                    dgvMatchResults.Columns["F_CurRank"].Visible = false;

                }
                //如果是耐力
                if (m_strCurMatchConfigCode.Equals("ED"))
                {
                    dgvMatchResults.Columns["F_FinishTime"].HeaderText = "Finish\nTime";
                    dgvMatchResults.Columns["F_FinishTime"].ReadOnly = false;
                    dgvMatchResults.Columns["F_FinishTime"].Width = 60;

                    dgvMatchResults.Columns["F_CurTime"].Visible = false;
                    dgvMatchResults.Columns["F_StartTime"].Visible = false;
                    dgvMatchResults.Columns["F_BreakTime"].Visible = false;
                    dgvMatchResults.Columns["F_CurPoints"].Visible = false;
                    dgvMatchResults.Columns["F_CurRank"].Visible = false;
                }

            }
            //如果是团体比赛显示
            else
            {
                //设置列标题名
                dgvMatchResults.Columns["F_TeamUsed"].HeaderText = "Team\nUsed";
                dgvMatchResults.Columns["F_TotOrder"].HeaderText = "Tot\nOrder";
                dgvMatchResults.Columns["F_StartTime"].HeaderText = "Start\nTime";
                dgvMatchResults.Columns["F_BreakTime"].HeaderText = "Break\nTime";
                dgvMatchResults.Columns["F_FinishTime"].HeaderText = "Finish\nTime";

                //列宽
                dgvMatchResults.Columns["F_TeamUsed"].Width = 60;
                dgvMatchResults.Columns["F_TotOrder"].Width = 80;
                dgvMatchResults.Columns["F_StartTime"].Width = 60;
                dgvMatchResults.Columns["F_BreakTime"].Width = 60;
                dgvMatchResults.Columns["F_FinishTime"].Width = 60;

                //隐藏列
                dgvMatchResults.Columns["F_TeamRegisterID"].Visible = false;
                dgvMatchResults.Columns["F_TeamRow"].Visible = false;
                dgvMatchResults.Columns["F_TeamOrder"].Visible = false;
                dgvMatchResults.Columns["F_TotTeamOrder"].Visible = false;
                dgvMatchResults.Columns["F_StartTime"].Visible = false;
                dgvMatchResults.Columns["F_BreakTime"].Visible = false;
                dgvMatchResults.Columns["F_FinishTime"].Visible = false;

                //禁止排序，dgv只读
                for (int i = 0; i < dgvMatchResults.Columns.Count; i++)
                {
                    dgvMatchResults.Columns[i].SortMode = DataGridViewColumnSortMode.NotSortable;
                    dgvMatchResults.Columns[i].ReadOnly = true;
                }

                //可编辑
                dgvMatchResults.Columns["F_Order"].ReadOnly = false;
                dgvMatchResults.Columns["F_TotResult"].ReadOnly = false;
                dgvMatchResults.Columns["F_TotRank"].ReadOnly = false;
                dgvMatchResults.Columns["F_TotOrder"].ReadOnly = false;
                dgvMatchResults.Columns["F_Qualify"].ReadOnly = false;

                //修改团体行的背景颜色
                for (int i = 0; i < dgvMatchResults.Rows.Count; i++)
                {
                    if (dgvMatchResults.Rows[i].Cells["F_TeamRow"].Value.ToString() == "1")
                    {
                        dgvMatchResults.Rows[i].DefaultCellStyle.BackColor = Color.Pink;
                    }
                }

                if (m_strCurMatchConfigCode.Equals("ECC") || m_strCurMatchConfigCode.Equals("EJP1") || m_strCurMatchConfigCode.Equals("EJP2")
                   || m_strCurMatchConfigCode.Equals("JPQ1") || m_strCurMatchConfigCode.Equals("JPQ2"))
                {
                    dgvMatchResults.Columns["F_CurTime"].HeaderText = "Time";
                    dgvMatchResults.Columns["F_CurTimePen"].HeaderText = "Time\nPen";
                    dgvMatchResults.Columns["F_CurJumpPen"].HeaderText = "Jump\nPen";

                    dgvMatchResults.Columns["F_CurTime"].Width = 50;
                    dgvMatchResults.Columns["F_CurTimePen"].Width = 50;
                    dgvMatchResults.Columns["F_CurJumpPen"].Width = 50;
                }
            }

            FontFamily fontFamily = new FontFamily("Arial");
            FontStyle fontStyle = new FontStyle();
            Font gridFont = new Font(fontFamily, 9, fontStyle);

            dgvMatchResults.Font = gridFont;

            if (dgvMatchResults.Columns.Count > 0)
            {
                dgvMatchResults.AllowUserToResizeColumns = false;
                dgvMatchResults.AllowUserToResizeRows = false;
                dgvMatchResults.AllowUserToOrderColumns = false;

            }

            //当前选择行设置为刷新前的行
            dgvMatchResults.ClearSelection();
            if (dgvMatchResults.RowCount > 0 && !m_bShowTeam)
            {
                if (m_iCurRegisterID != -1)
                {
                    for (int i = 0; i < dgvMatchResults.Rows.Count; i++)
                    {
                        if (dgvMatchResults.Rows[i].Cells["F_RegisterID"].Value.ToString() == m_iCurRegisterID.ToString())
                        {
                            dgvMatchResults.Rows[i].Selected = true;
                            //显示当前行的前两行
                            dgvMatchResults.FirstDisplayedScrollingRowIndex = (i-2>=0)?i-2:i;
                            break;
                        }
                    }
                }
                else
                {
                    dgvMatchResults.Rows[0].Selected = true;
                    m_iCurRegisterID = Convert.ToInt32(dgvMatchResults.Rows[0].Cells["F_RegisterID"].Value);
                }
            }

            //如果比赛状态为Finish，设置dgv只读
            if (m_iCurStatusID == GVAR.STATUS_FINISHED)
            {
                dgvMatchResults.ReadOnly = true;
            }


            this.dgvMatchResults.SelectionChanged += new System.EventHandler(this.dgvMatchResults_SelectionChanged);
            this.dgvMatchResults.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgvMatchResults_CellValidating);
            this.dgvMatchResults.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchResults_CellValueChanged);

        }

        private void dgvMatchResults_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            String strColumnName = dgvMatchResults.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvMatchResults.Rows[iRowIndex].Cells[iColumnIndex];
            Int32 iMatchID = GVAR.GetFieldValueFromDGV(dgvMatchResults, iRowIndex, "F_MatchID");
            Int32 iRegisterID = GVAR.GetFieldValueFromDGV(dgvMatchResults, iRowIndex, "F_RegisterID");
            Int32 iHorseID = GVAR.GetFieldValueFromDGV(dgvMatchResults, iRowIndex, "F_HorseID");

            Decimal fInputValue = 0;
            Int32 iInputValue = 0;
            string strInputValue = "";
            bool bNeedRefreshMatchResults = true;
            //IRM
            if (CurCell is DGVCustomComboBoxCell)
            {
                DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                strInputValue = CurCell1.Value.ToString();
                if (strColumnName.CompareTo("F_CurIRM") == 0)
                {
                    //更行IRM
                    GVAR.g_EQDBManager.UpdateIRM(iMatchID, iRegisterID, strInputValue);
                    //更新累计总罚分
                    GVAR.g_EQDBManager.UpdateTotPointsWhenCurPointsChanged(m_iCurMatchID, m_iCurRegisterID);
                }

            }
            //starttime
            if (strColumnName.CompareTo("F_StartTime") == 0)
            {
                string strStartTime = "";
                if (dgvMatchResults.Rows[iRowIndex].Cells["F_StartTime"].Value != null)
                    strStartTime = dgvMatchResults.Rows[iRowIndex].Cells["F_StartTime"].Value.ToString();
                bool bReturn = GVAR.g_EQDBManager.UpdateMatchTime(m_iCurMatchID, m_iCurRegisterID,
                        strStartTime, "-1", "-1");
                if (bReturn)
                {
                    dgvMatchResults.Rows[iRowIndex].Cells["F_StartTime"].Value = strStartTime;
                }
                bNeedRefreshMatchResults = false;
            }
            //finishtime
            if (strColumnName.CompareTo("F_FinishTime") == 0)
            {
                string strFinishTime = "";
                if (dgvMatchResults.Rows[iRowIndex].Cells["F_FinishTime"].Value != null)
                    strFinishTime = dgvMatchResults.Rows[iRowIndex].Cells["F_FinishTime"].Value.ToString();
                bool bReturn = GVAR.g_EQDBManager.UpdateMatchTime(m_iCurMatchID, m_iCurRegisterID,
                         "-1", "-1",strFinishTime);
                if (bReturn)
                {
                    dgvMatchResults.Rows[iRowIndex].Cells["F_FinishTime"].Value = strFinishTime;
                }
                bNeedRefreshMatchResults = false;
            }
            //breaktime
            if (strColumnName.CompareTo("F_BreakTime") == 0)
            {
                return;
            }

            //如果障碍或越野类的用时改变
            if (strColumnName.CompareTo("F_CurTime") == 0)
            {
                //如果是越野，将分秒格式转换成秒
                if (m_strCurMatchConfigCode.Equals("ECC"))
                {
                    fInputValue = GVAR.StrTime2Decimal(CurCell.Value);
                }
                else
                {
                    fInputValue = Convert.ToDecimal(CurCell.Value);
                }
                GVAR.g_EQDBManager.UpdateCurTimePen(iMatchID, iRegisterID, fInputValue);
                //计算Cur总分，并更新总分到result表
                GVAR.g_EQDBManager.UpdateCurPointsWhenScoreChanged(m_iCurMatchID, m_iCurRegisterID,0);
                GVAR.g_EQDBManager.UpdateTotPointsWhenCurPointsChanged(m_iCurMatchID, m_iCurRegisterID);

            }
            if (strColumnName.CompareTo("F_E") == 0 || strColumnName.CompareTo("F_H") == 0 || strColumnName.CompareTo("F_C") == 0
            || strColumnName.CompareTo("F_M") == 0 || strColumnName.CompareTo("F_B") == 0
            || strColumnName.CompareTo("F_CurTimePen") == 0
            || strColumnName.CompareTo("F_CurJumpPen") == 0)
            {
                fInputValue = Convert.ToDecimal(CurCell.Value);
                GVAR.g_EQDBManager.UpdateColumnPoint(iMatchID, iRegisterID, strColumnName, fInputValue);
                //计算Cur总分，并更新总分到result表
                GVAR.g_EQDBManager.UpdateCurPointsWhenScoreChanged(m_iCurMatchID, m_iCurRegisterID,0);
                GVAR.g_EQDBManager.UpdateTotPointsWhenCurPointsChanged(m_iCurMatchID, m_iCurRegisterID);

            }
            if (strColumnName.CompareTo("F_CurPoints") == 0 || strColumnName.CompareTo("F_TotPoints") == 0)
            {
                fInputValue = Convert.ToDecimal(CurCell.Value);
                GVAR.g_EQDBManager.UpdateColumnPoint(iMatchID, iRegisterID, strColumnName, fInputValue);
            }

            if (strColumnName.CompareTo("F_Order") == 0)
            {
                iInputValue = Convert.ToInt32(CurCell.Value);
                if(m_iCurMatchID == m_iCurIndividualMatchID)
                    GVAR.g_EQDBManager.UpdateColumnPoint(iMatchID, iRegisterID, strColumnName, iInputValue);
                if (m_iCurMatchID == m_iCurTeamMatchID)
                {
                    GVAR.g_EQDBManager.UpdateColumnPoint(iMatchID, iRegisterID, strColumnName, iInputValue);
                    GVAR.g_EQDBManager.UpdateTeamOrder(m_iCurIndividualMatchID,m_iCurTeamMatchID, iRegisterID, iInputValue);
                }
                bNeedRefreshMatchResults = false;
            }
            if (strColumnName.CompareTo("F_TotOrder") == 0)
            {
                iInputValue = Convert.ToInt32(CurCell.Value);
                if (m_iCurMatchID == m_iCurIndividualMatchID)
                {
                    GVAR.g_EQDBManager.UpdateColumnPoint(iMatchID, iRegisterID, strColumnName, iInputValue);
                    bNeedRefreshMatchResults = false;
                }
                if (m_iCurMatchID == m_iCurTeamMatchID)
                {
                    GVAR.g_EQDBManager.UpdateColumnPoint(iMatchID, iRegisterID, strColumnName, iInputValue);
                    GVAR.g_EQDBManager.UpdateTotTeamOrder(m_iCurIndividualMatchID,m_iCurTeamMatchID, iRegisterID, iInputValue);
                } 
            }
            if (strColumnName.CompareTo("RegisterBib") == 0 && btnx_StartList.Checked)
            {
                //iInputValue = Convert.ToInt32(CurCell.Value);
                if (CurCell.Value != null)
                {
                    strInputValue = "'" + CurCell.Value.ToString() + "'";
                }
                else
                {
                    strInputValue = "NULL";
                }
                GVAR.g_EQDBManager.UpdateRegisterBib(iRegisterID, strInputValue);
                bNeedRefreshMatchResults = false;
            }
            if (strColumnName.CompareTo("HorseBib") == 0 && btnx_StartList.Checked)
            {
                //iInputValue = Convert.ToInt32(CurCell.Value);
                if (CurCell.Value != null)
                {
                    strInputValue = "'" + CurCell.Value.ToString() + "'";
                }
                else
                {
                    strInputValue = "NULL";
                }
                GVAR.g_EQDBManager.UpdateRegisterBib(iHorseID, strInputValue);
                bNeedRefreshMatchResults = false;
            }
            if (strColumnName.CompareTo("RegisterName") == 0 && btnx_StartList.Checked)
            {
                if (CurCell.Value != null)
                {
                    strInputValue = "'" + CurCell.Value.ToString() + "'";
                }
                else
                {
                    strInputValue = "NULL";
                }
                GVAR.g_EQDBManager.UpdateRegisterName(iRegisterID, strInputValue);
                bNeedRefreshMatchResults = false;
            }
            if (strColumnName.CompareTo("HorseName") == 0 && btnx_StartList.Checked)
            {
                if (CurCell.Value != null)
                {
                    strInputValue = "'" + CurCell.Value.ToString() + "'";
                }
                else
                {
                    strInputValue = "NULL";
                }
                GVAR.g_EQDBManager.UpdateRegisterName(iHorseID, strInputValue);
                bNeedRefreshMatchResults = false;
            }
            if (strColumnName.CompareTo("F_TotResult") == 0
            || strColumnName.CompareTo("F_Qualify") == 0
            || strColumnName.CompareTo("F_TotRank") == 0)
            {
                if (CurCell.Value != null)
                {
                    strInputValue = "'" + CurCell.Value.ToString() + "'";
                }
                else
                {
                    strInputValue = "NULL";
                }
                GVAR.g_EQDBManager.UpdateColumnPoint(iMatchID, iRegisterID, strColumnName, strInputValue);
                bNeedRefreshMatchResults = false;
            }

            if (bNeedRefreshMatchResults)
            {
                //重新初始化dgvresult
                InitDgvMatchResultList();       
            }


            //this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emMatchCompetitor, -1, -1, -1, iMatchID, iRegisterID, null);

        }

        private void dgvMatchResults_SelectionChanged(object sender, EventArgs e)
        {

            if (dgvMatchResults.SelectedRows.Count > 0 && dgvMatchResults.CurrentRow != null && dgvMatchResults.SelectedRows[0].Cells["F_RegisterID"].Value.ToString().Length != 0)
            {
                m_iCurRegisterID = Convert.ToInt32(dgvMatchResults.SelectedRows[0].Cells["F_RegisterID"].Value);
                //如果是个人比赛，才更新resultdetail
                if (!m_bShowTeam)
                {
                    InitDgvMatchResultDetailList();
                }
            }
            else
                return;
        }

        private void dgvMatchResults_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            //当编辑combobox时，初始化列表
            if (dgvMatchResults.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                String strLanguageCode = m_strLanguageCode;

                if (dgvMatchResults.Columns[iColumnIndex].Name.CompareTo("F_CurIRM") == 0)
                {
                    GVAR.g_EQDBManager.InitIRMCombBox(ref dgvMatchResults, iColumnIndex, m_iDisciplineID, strLanguageCode);
                }
            }
        }

        private void dgvMatchResults_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if ((dgvMatchResults.Columns[e.ColumnIndex].Name == "F_StartTime"
                || dgvMatchResults.Columns[e.ColumnIndex].Name == "F_FinishTime")
                 && e.FormattedValue != null)
            {//DateTime
                DateTime dtOut;
                if (e.FormattedValue.ToString().Length != 0 &&
                    !DateTime.TryParse(e.FormattedValue.ToString(), out dtOut))
                    e.Cancel = true;
            }

            if (dgvMatchResults.Columns[e.ColumnIndex].Name == "F_CurTime")
            {
                //如果是越野时间验证
                if (m_strCurMatchConfigCode.Equals("ECC"))
                {
                    string pattern = @"^\d{1,2}'\d{2}''$";
                    if (e.FormattedValue.ToString().Length != 0 &&
                        !RegexDao.IsMatch(pattern, e.FormattedValue.ToString()))
                        e.Cancel = true;
                }
                //如果是绕桶
                if (m_strCurMatchRuleCode.Equals("BR"))
                {
                    string pattern = @"^\d{1,3}\.?\d{0,3}$";
                    if (e.FormattedValue.ToString().Length != 0 &&
                    !RegexDao.IsMatch(pattern, e.FormattedValue.ToString()))
                        e.Cancel = true;
                }
                //如果是场地障碍时间验证
                if (m_strCurMatchRuleCode.Equals("JP"))
                {
                    string pattern = @"^\d{1,3}\.?\d{0,2}$";
                    if (e.FormattedValue.ToString().Length != 0 &&
                    !RegexDao.IsMatch(pattern, e.FormattedValue.ToString()))
                        e.Cancel = true;
                }

            }

            if (m_strCurEventConfigCode == "DR" && 
                (dgvMatchResults.Columns[e.ColumnIndex].Name == "F_E"
                || dgvMatchResults.Columns[e.ColumnIndex].Name == "F_H"
                || dgvMatchResults.Columns[e.ColumnIndex].Name == "F_C"
                || dgvMatchResults.Columns[e.ColumnIndex].Name == "F_M"
                || dgvMatchResults.Columns[e.ColumnIndex].Name == "F_B")
                 && e.FormattedValue != null)
            {
                //开头有1到3个数字，中间有0个或者一个小数点，结尾有0到3个数字
                string pattern = @"^\d{1,3}\.?\d{0,3}$";
                if (e.FormattedValue.ToString().Length != 0 &&
                    !RegexDao.IsMatch(pattern, e.FormattedValue.ToString()))
                    e.Cancel = true;
            }

            if (m_strCurEventConfigCode == "E" &&
                (dgvMatchResults.Columns[e.ColumnIndex].Name == "F_E"
                || dgvMatchResults.Columns[e.ColumnIndex].Name == "F_H"
                || dgvMatchResults.Columns[e.ColumnIndex].Name == "F_C"
                || dgvMatchResults.Columns[e.ColumnIndex].Name == "F_M"
                || dgvMatchResults.Columns[e.ColumnIndex].Name == "F_B"
                || dgvMatchResults.Columns[e.ColumnIndex].Name == "F_CurTimePen")
                 && e.FormattedValue != null)
            {
                //开头有1到3个数字，中间有0个或者一个小数点，结尾有0到3个数字
                string pattern = @"^\d{1,3}\.?\d{0,2}$";
                if (e.FormattedValue.ToString().Length != 0 &&
                    !RegexDao.IsMatch(pattern, e.FormattedValue.ToString()))
                    e.Cancel = true;
            }

            if ((dgvMatchResults.Columns[e.ColumnIndex].Name == "F_TotOrder"
                || dgvMatchResults.Columns[e.ColumnIndex].Name == "F_Order"
                || dgvMatchResults.Columns[e.ColumnIndex].Name == "F_CurJumpPen")
                && e.FormattedValue != null)
            {  
                int iOut = 0;
                if ((e.FormattedValue.ToString().Length != 0 &&
                    !int.TryParse(e.FormattedValue.ToString(), out iOut)))
                    e.Cancel = true;
            }

            if (dgvMatchResults.Columns[e.ColumnIndex].Name == "F_Qualify"
                && e.FormattedValue != null)
            {
                if (!(e.FormattedValue.ToString().Equals("Q") || e.FormattedValue.ToString().Equals("")))
                    e.Cancel = true;
            }

        }

        public DataGridView GetDgvMatchResults()
        {
            return this.dgvMatchResults;
        }

        public void UpdateDgvMatchResultListSafe()
        {
            if (this.InvokeRequired)
            {
                UpdateDgvMatchResultHandler delegateUpdateDgvMatchResult = new UpdateDgvMatchResultHandler(InitDgvMatchResultList);

                this.Invoke(delegateUpdateDgvMatchResult);

                return;
            }

            InitDgvMatchResultList();
        }

        public void UpdateWhenRegisterStatus2FinishSafe(int iMatchID, int iRegisterID)
        {
            if (this.InvokeRequired)
            {
                UpdateWhenRegisterStatusHandler delegateUpdateWhenRegisterStatus = new UpdateWhenRegisterStatusHandler(UpdateWhenRegisterStatus2Finish);

                this.Invoke(delegateUpdateWhenRegisterStatus, new object[] {iMatchID,iRegisterID });

                return;
            }

            UpdateDBWhenRegisterStatus2Finish(iMatchID,iRegisterID);
        }

        public void UpdateWhenRegisterStatus2StartSafe(int iMatchID,int iRegisterID)
        {
            if (this.InvokeRequired)
            {
                UpdateWhenRegisterStatusHandler delegateUpdateWhenRegisterStatus = new UpdateWhenRegisterStatusHandler(UpdateWhenRegisterStatus2Start);

                this.Invoke(delegateUpdateWhenRegisterStatus, new object[] { iMatchID,iRegisterID });

                return;
            }

            UpdateDBWhenRegisterStatus2Start(iMatchID,iRegisterID);
        }

        private void chkX_ShowAll_CheckedChanged(object sender, EventArgs e)
        {
            if ((chkX_ShowAll.Checked && !m_bShowTeam)
                || (!chkX_ShowAll.Checked && !m_bShowTeam))
            {
                InitDgvMatchResultList();
            }
        }

        private void btnx_Refresh_Click(object sender, EventArgs e)
        {
            InitDgvMatchResultList();
        }

        #endregion

        #region MatchResultDetail DGV

        private void InitDgvMatchResultDetailList()
        {
            //列表加载时不响应验证消息
            this.dgvMatchResultDetails.CellValidating -= new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgvMatchResultDetails_CellValidating);
            this.dgvMatchResultDetails.CellValueChanged -= new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchResultDetails_CellValueChanged);
            GVAR.g_EQDBManager.InitDgvMatchResultDetailList(m_iCurIndividualMatchID, m_iCurRegisterID, ref dgvMatchResultDetails);
            this.dgvMatchResultDetails.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgvMatchResultDetails_CellValidating);
            this.dgvMatchResultDetails.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchResultDetails_CellValueChanged);

            //不显示序号列
            dgvMatchResultDetails.RowHeadersVisible = false;

            //设置所有列可以编辑
            for (int i = 0; i < dgvMatchResultDetails.Columns.Count; i++)
            {
                //设置所有列可编辑
                dgvMatchResultDetails.Columns[i].ReadOnly = false;
                if (!m_strCurMatchRuleCode.Equals("ED"))
                //设置列标题，截取列标题的F_
                dgvMatchResultDetails.Columns[i].HeaderText = dgvMatchResultDetails.Columns[i].Name.Substring(2);
            }

            //设置盛装舞步Validated的行的颜色
            if (m_strCurMatchRuleCode.Equals("DR"))
            {
                for (int i = 0; i < dgvMatchResultDetails.Rows.Count; i++)
                {
                    if (dgvMatchResultDetails.Rows[i].Cells["F_Status"].Value.ToString() == "1")
                    {
                        dgvMatchResultDetails.Rows[i].DefaultCellStyle.ForeColor = Color.Green;
                    }
                }
            }

            //隐藏列
            dgvMatchResultDetails.Columns["F_MatchID"].Visible = false;
            dgvMatchResultDetails.Columns["F_Status"].Visible = false;
            dgvMatchResultDetails.Columns["F_JudgePosition"].Visible = false;
            dgvMatchResultDetails.Columns["F_RegisterID"].Visible = false;

            //如果为盛装舞步
            if (m_strCurMatchRuleCode.Equals("DR"))
            {
                //设置DGV宽度
                dgvMatchResultDetails.Width = 1094;
                //设置只读列
                dgvMatchResultDetails.Columns["F_Judge"].ReadOnly = true;
                dgvMatchResultDetails.Columns["F_NumPoints"].ReadOnly = true;
                dgvMatchResultDetails.Columns["F_TecNumPoints"].ReadOnly = true;
                dgvMatchResultDetails.Columns["F_ArtNumPoints"].ReadOnly = true;

                //设置列标题名
                dgvMatchResultDetails.Columns["F_Judge"].HeaderText = "";
                dgvMatchResultDetails.Columns["F_NumPoints"].HeaderText = "Total";
                dgvMatchResultDetails.Columns["F_TecNumPoints"].HeaderText = "Tec";
                dgvMatchResultDetails.Columns["F_ArtNumPoints"].HeaderText = "Art";
                dgvMatchResultDetails.Columns["F_0"].HeaderText = "Pen";

                //设置列宽
                foreach (DataGridViewColumn c in this.dgvMatchResultDetails.Columns)
                {
                    c.Width = 30;
                    dgvMatchResultDetails.Columns["F_NumPoints"].Width = 45;
                    dgvMatchResultDetails.Columns["F_TecNumPoints"].Width = 45;
                    dgvMatchResultDetails.Columns["F_ArtNumPoints"].Width = 45;
                }

                //如果不是盛装舞步个人科目自选
                if (!m_strCurMatchConfigCode.Equals("DRRB"))
                {
                    dgvMatchResultDetails.Columns["F_TecNumPoints"].Visible = false;
                    dgvMatchResultDetails.Columns["F_ArtNumPoints"].Visible = false;
                }
            }
            //如果为耐力赛
            else if (m_strCurMatchRuleCode.Equals("ED"))
            {
                //设置DGV宽度
                dgvMatchResultDetails.Width = 1094;
                dgvMatchResultDetails.Columns["F_Judge"].HeaderText = "Phase";
                dgvMatchResultDetails.Columns["F_1"].HeaderText = "Distance";
                dgvMatchResultDetails.Columns["F_1Des"].HeaderText = "StartTime";
                dgvMatchResultDetails.Columns["F_2Des"].HeaderText = "ArrivalTime";
                dgvMatchResultDetails.Columns["F_3Des"].HeaderText = "VetInTime";
                dgvMatchResultDetails.Columns["F_4Des"].HeaderText = "RidingTime";
                dgvMatchResultDetails.Columns["F_5Des"].HeaderText = "TotalTime";
                dgvMatchResultDetails.Columns["F_6Des"].HeaderText = "MaxVetTime";
                dgvMatchResultDetails.Columns["F_7Des"].HeaderText = "RecoveryTime";
                dgvMatchResultDetails.Columns["F_8Des"].HeaderText = "PhaseSpeed";
                dgvMatchResultDetails.Columns["F_9Des"].HeaderText = "AvgSpeed";
                dgvMatchResultDetails.Columns["F_10Des"].HeaderText = "DepartureTime";
                dgvMatchResultDetails.Columns["F_11Des"].HeaderText = "IRM";


                //设置列宽
                foreach (DataGridViewColumn c in this.dgvMatchResultDetails.Columns)
                {
                    c.Width = 80;
                }
            }
            //如果是场地障碍或越野
            else
            {
                //设置DGV宽度
                dgvMatchResultDetails.Width = 850;
                //初始化PenType列表

                //设置只读列
                dgvMatchResultDetails.Columns["Col"].ReadOnly = true;

                //设置列标题名
                dgvMatchResultDetails.Columns["Col"].HeaderText = "";

                //隐藏列
                dgvMatchResultDetails.Columns["F_Judge"].Visible = false;

                //设置列宽
                foreach (DataGridViewColumn c in this.dgvMatchResultDetails.Columns)
                {
                    c.Width = 50;
                }

                //障碍标题修改
                DataTable dtFenceList;
                dtFenceList = GVAR.g_EQDBManager.GetMatchFenceList(m_iCurMatchConfigID);
                for (int i = 1; i <= dtFenceList.Rows.Count; i++)
                {
                    dgvMatchResultDetails.Columns["F_"+i].HeaderText = dtFenceList.Rows[i-1][1].ToString();
                }
            }


            //字体设置
            FontFamily fontFamily = new FontFamily("Arial");
            FontStyle fontStyle = new FontStyle();
            Font gridFont = new Font(fontFamily, 9, fontStyle);
            dgvMatchResultDetails.Font = gridFont;

            //设置不可以调整列宽和行宽
            dgvMatchResultDetails.AllowUserToResizeColumns = false;
            dgvMatchResultDetails.AllowUserToResizeRows = false;

            //设置不可以排序
            dgvMatchResultDetails.AllowUserToOrderColumns = false;

            //设置第一行为当前选择行
            dgvMatchResultDetails.ClearSelection();
            if (dgvMatchResultDetails.RowCount > 0)
            {
                dgvMatchResultDetails.Rows[0].Selected = true;
            }

            //如果比赛状态为Finish，dgv只读
            if (m_iCurStatusID == GVAR.STATUS_FINISHED)
            {
                dgvMatchResultDetails.ReadOnly = true;
            }

        }

        private void dgvMatchResultDetails_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            DataGridViewCell CurCell = dgvMatchResultDetails.Rows[iRowIndex].Cells[iColumnIndex];
            Object oValue = CurCell.Value;
            UpdateDgvMatchResultDetailsCell(iRowIndex, iColumnIndex,oValue);
        }

        private void UpdateDgvMatchResultDetailsCell(int iRowIndex, int iColumnIndex,Object oValue)
        {
            string strIRM = null;
            bool bNeedRefreshMatchResults = true;
            decimal fInputValue = 0;
            String strInputString = "";
            String strColumnName = dgvMatchResultDetails.Columns[iColumnIndex].Name;
            Int32 iJudgePosition = GVAR.GetFieldValueFromDGV(dgvMatchResultDetails, iRowIndex, "F_JudgePosition");
            String strJudge = dgvMatchResultDetails.Rows[iRowIndex].Cells["F_Judge"].Value.ToString();

            if (oValue == null)
            {
                GVAR.g_EQDBManager.UpdateDetailScoreNull(m_iCurMatchID, m_iCurRegisterID, iJudgePosition, dgvMatchResultDetails.Columns[iColumnIndex].Name);
            }
            else
            {   
                #region JP ECC
                //如果是场地障碍或越野
                if (strJudge.CompareTo("F") == 0)
                {
                    //如果是更新罚分描述
                    if (dgvMatchResultDetails.Rows[iRowIndex].Cells["Col"].Value.ToString() == "Des")
                    {
                        string strCode = oValue.ToString();
                        strInputString = "'" + strCode + "'";
                        //调用存储过程更新resultdetail的细节分描述
                        GVAR.g_EQDBManager.UpdateDetailScoreDes(m_iCurMatchID, m_iCurRegisterID, iJudgePosition, dgvMatchResultDetails.Columns[iColumnIndex].Name, strInputString);
                        //细节分描述自动触发罚分
                        for (int i = 0; i < dgvMatchPenType.Rows.Count; i++)
                        {
                            if (dgvMatchPenType.Rows[i].Cells["Code"].Value.Equals(strCode))
                            {
                                decimal fPen = GVAR.Str2Decimal(dgvMatchPenType.Rows[i].Cells["Pen"].Value.ToString());
                                //更新罚分
                                GVAR.g_EQDBManager.UpdateDetailScore(m_iCurMatchID, m_iCurRegisterID, iJudgePosition, dgvMatchResultDetails.Columns[iColumnIndex].Name, fPen);
                                //更新淘汰标记
                                strIRM = dgvMatchPenType.Rows[i].Cells["IRM"].Value.ToString();
                                if (strIRM == "EL")
                                {
                                    GVAR.g_EQDBManager.UpdateIRM(m_iCurMatchID, m_iCurRegisterID, "EL");
                                    GVAR.g_EQDBManager.UpdateDetailScoreNull(m_iCurMatchID, m_iCurRegisterID, iJudgePosition, dgvMatchResultDetails.Columns[iColumnIndex].Name);
                                }
                                break;
                            }
                        }

                    }
                    //如果是更新罚分
                    else
                    {
                        fInputValue = GVAR.Str2Decimal(oValue);
                        //调用存储过程更新resultdetail
                        GVAR.g_EQDBManager.UpdateDetailScore(m_iCurMatchID, m_iCurRegisterID, iJudgePosition, dgvMatchResultDetails.Columns[iColumnIndex].Name, fInputValue);
                    }
                    bNeedRefreshMatchResults = true;
                }
                #endregion
                #region DR
                //如果是盛装舞步
                else if (strJudge.CompareTo("E") == 0 || strJudge.CompareTo("H") == 0 || strJudge.CompareTo("C") == 0 || strJudge.CompareTo("M") == 0 || strJudge.CompareTo("B") == 0)
                {
                    fInputValue = GVAR.Str2Decimal(oValue);
                    //调用存储过程更新resultdetail
                    GVAR.g_EQDBManager.UpdateDetailScore(m_iCurMatchID, m_iCurRegisterID, iJudgePosition, dgvMatchResultDetails.Columns[iColumnIndex].Name, fInputValue);
                    //如果扣分不为0
                    if (strColumnName.Equals("F_0"))
                    {
                        GVAR.g_EQDBManager.UpdateJudgePointsWhenDetailScoreChange(m_iCurMatchID, m_iCurRegisterID, 1);
                        GVAR.g_EQDBManager.UpdateJudgePointsWhenDetailScoreChange(m_iCurMatchID, m_iCurRegisterID, 2);
                        GVAR.g_EQDBManager.UpdateJudgePointsWhenDetailScoreChange(m_iCurMatchID, m_iCurRegisterID, 3);
                        GVAR.g_EQDBManager.UpdateJudgePointsWhenDetailScoreChange(m_iCurMatchID, m_iCurRegisterID, 4);
                        GVAR.g_EQDBManager.UpdateJudgePointsWhenDetailScoreChange(m_iCurMatchID, m_iCurRegisterID, 5);
                    }
                    bNeedRefreshMatchResults = false;
                }
                #endregion
                #region ED
                //如果是耐力赛
                else
                {
                    string strCode = oValue.ToString();
                    strInputString = "'" + strCode + "'";
                    //调用存储过程更新resultdetail的细节分描述
                    GVAR.g_EQDBManager.UpdateDetailScore(m_iCurMatchID, m_iCurRegisterID, iJudgePosition, dgvMatchResultDetails.Columns[iColumnIndex].Name, strInputString);
                    bNeedRefreshMatchResults = false;
                }
                #endregion

                //计算和更新裁判点总分和百分比分
                GVAR.g_EQDBManager.UpdateJudgePointsWhenDetailScoreChange(m_iCurMatchID, m_iCurRegisterID, iJudgePosition);
                //更新当前总
                GVAR.g_EQDBManager.UpdateCurPointsWhenScoreChanged(m_iCurMatchID, m_iCurRegisterID, 1);
                //更新累计总
                GVAR.g_EQDBManager.UpdateTotPointsWhenCurPointsChanged(m_iCurMatchID, m_iCurRegisterID);

            }

            //重新初始化dgvresult
            if (bNeedRefreshMatchResults)
            {
                InitDgvMatchResultList();
            }

            //重新初始化dgvresultdetails
            InitDgvMatchResultDetailList();
            //保持选择还在当前单元格
            dgvMatchResultDetails.Rows[iRowIndex].Cells[iColumnIndex].Selected = true;
        }

        private void dgvMatchResultDetails_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (e.ColumnIndex > 0
                && e.FormattedValue != null
                && dgvMatchResultDetails.Columns[e.ColumnIndex].ReadOnly != true)//只读列不验证
            {
                //if (m_strCurMatchRuleCode.Equals("DR"))//如果是盛装舞步
                //{
                //    //如果是盛装舞步自选科目
                //    if (m_strCurMatchConfigCode.Equals("DRRB"))
                //    {
                //        float fOut = 0;
                //        //如果验证不通过
                //        if ((e.FormattedValue.ToString().Length != 0) &&
                //            !((float.TryParse(e.FormattedValue.ToString(), out fOut)) && fOut * 2 >= 0 && fOut * 2 <= 20 && (fOut * 10) % 5 == 0))
                //        {
                //            //未连接打分器时（打分器连接时不验证）
                //            if (!chkX_Listen.Checked)
                //            {
                //                e.Cancel = true;
                //                //还原原来的值
                //                dgvMatchResultDetails.CancelEdit();
                //            }
                //        }
                //    }
                //    else
                //    {
                //        int iOut = 0;
                //        if ((e.FormattedValue.ToString().Length != 0) &&
                //            !((int.TryParse(e.FormattedValue.ToString(), out iOut)) && iOut>=0 && iOut<=10))
                //        {
                //            //未连接打分器时（打分器连接时不验证）
                //            if (!chkX_Listen.Checked)
                //            {
                //                e.Cancel = true;
                //                //还原原来的值
                //                dgvMatchResultDetails.CancelEdit();
                //            }
                //        }
                //    }

                //}
                //如果是场地障碍或越野，只能输入2位整数
                if (m_strCurMatchRuleCode.Equals("JP") || m_strCurMatchRuleCode.Equals("ECC"))
                {
                    //如果是输入罚分
                    if (dgvMatchResultDetails.Rows[e.RowIndex].Cells["Col"].Value.ToString() == "Pen")
                    {
                        int iOut = 0;
                        if ((e.FormattedValue.ToString().Length != 0 &&
                            !int.TryParse(e.FormattedValue.ToString(), out iOut)) || e.FormattedValue.ToString().Length > 2)
                            e.Cancel = true;
                    }
                    //如果是输入罚分描述
                    else
                    {
                        if (!(e.FormattedValue.ToString() == ""
                            || e.FormattedValue.ToString() == "-"
                            || e.FormattedValue.ToString() == "FR"
                            || e.FormattedValue.ToString() == "FH"
                            || e.FormattedValue.ToString() == "R"
                            || e.FormattedValue.ToString() == "RR"
                            || e.FormattedValue.ToString() == "RE"
                            || e.FormattedValue.ToString() == "F"
                            || e.FormattedValue.ToString() == "F1"
                            || e.FormattedValue.ToString() == "F2"
                            || e.FormattedValue.ToString() == "RF"))
                            e.Cancel = true;
                    }
                }
            }

        }

        public DataGridView GetDgvMatchResultDetails()
        {
            return this.dgvMatchResultDetails;
        }

        //处理按键
        protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
        {
            //如果是场地障碍，对上下键做特殊处理
            if (m_strCurMatchRuleCode.Equals("JP"))
            {
                if (dgvMatchResultDetails != null
                && dgvMatchResultDetails.CurrentCell != null
                && dgvMatchResultDetails.CurrentCell.ColumnIndex > 0
                && dgvMatchResultDetails.Rows[dgvMatchResultDetails.CurrentCell.RowIndex].Cells["Col"].Value.ToString() == "Pen")
                {
                    //加4分
                    if (keyData == Keys.Up)
                    {
                        int iPrePen = GVAR.Str2Int(dgvMatchResultDetails.CurrentCell.Value.ToString());
                        UpdateDgvMatchResultDetailsCell(dgvMatchResultDetails.CurrentCell.RowIndex, dgvMatchResultDetails.CurrentCell.ColumnIndex, (4+iPrePen));
                        return true;
                    }
                    //减4分
                    if (keyData == Keys.Down)
                    {
                        int iPrePen = GVAR.Str2Int(dgvMatchResultDetails.CurrentCell.Value.ToString());
                        UpdateDgvMatchResultDetailsCell(dgvMatchResultDetails.CurrentCell.RowIndex, dgvMatchResultDetails.CurrentCell.ColumnIndex, (iPrePen-4>0?(iPrePen-4).ToString():null));
                        return true;
                    }
                }
            }
            return base.ProcessCmdKey(ref msg, keyData);
        }

        #endregion

        #region MatchPenType DGV
        private void InitDgvMatchPenTypeList()
        {
            //如果是场地障碍或越野
            if (m_strCurMatchRuleCode.Equals("JP")||m_strCurMatchRuleCode.Equals("ECC"))
            {
                GVAR.g_EQDBManager.InitDgvMatchPenTypeList(m_iCurMatchRuleID, ref dgvMatchPenType);
                //隐藏列
                dgvMatchPenType.Columns["F_PenTypeID"].Visible = false;
                dgvMatchPenType.Columns["F_MatchRuleID"].Visible = false;
                //宽度
                dgvMatchPenType.Columns["Code"].Width = 40;
                dgvMatchPenType.Columns["Description"].Width = 100;
                dgvMatchPenType.Columns["Pen"].Width = 30;
                dgvMatchPenType.Columns["IRM"].Width = 30;
                dgvMatchPenType.Visible = true;
            }
            else
            {
                dgvMatchPenType.Visible = false;
            }
        }
        #endregion

        #region Exit Match

        private void btnx_Exit_Click(object sender, EventArgs e)
        {
            if (!m_bIsRunning) return;

            if (MessageBox.Show(LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "mbExitMatch"), GVAR.g_strSectionName, MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                //点击退出按钮时不响应selectionchanged消息
                this.dgvMatchResults.SelectionChanged -= new System.EventHandler(this.dgvMatchResults_SelectionChanged);
                ExitMatch();
                this.dgvMatchResults.SelectionChanged += new System.EventHandler(this.dgvMatchResults_SelectionChanged);
            }
        }

        private void ExitMatch()
        {
            m_iCurMatchID = -1;
            m_iCurMatchConfigID = -1;
            m_iCurTeamMatchID = -1;
            m_iCurRegisterID = -1;
            m_iCurResultRowID = 0;
            m_bIsTeamMatch = false;
            m_bShowTeam = false;
            g_MatchScoreDetail.Visible = true;
            dgvMatchResultDetails.Visible = true;
            m_bIsRunning = false;
            InitMatchBtnStatus();
            CleanMatchInfo();
            CleanMatchResults();
            CleanMatchResultDetails();
            CleanMatchPenType();
            btnx_TeamResult.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_TeamResult");
            //退出打分器
            if (frmIpadMark != null) frmIpadMark.Close();
        }

        #endregion

        #region Match Config

        private void btnx_Config_Click(object sender, EventArgs e)
        {
            OVREQMatchConfig frmMatchConfig = new OVREQMatchConfig();
            frmMatchConfig.LanguageCode = m_strLanguageCode;
            frmMatchConfig.MatchID = m_iCurMatchID;
            frmMatchConfig.MatchConfigID = m_iCurMatchConfigID;
            frmMatchConfig.MatchConfigCode = m_strCurMatchConfigCode;
            frmMatchConfig.MatchRuleCode = m_strCurMatchRuleCode;
            frmMatchConfig.ShowDialog();
        }

        #endregion

        #region Match Judge

        private void btnx_Judges_Click(object sender, EventArgs e)
        {
            frmOVROfficialEntry frmJudges = new frmOVROfficialEntry(m_iCurMatchID);
            frmJudges.LanguageCode = m_strLanguageCode;
            frmJudges.DisciplineID = m_iDisciplineID;
            frmJudges.ShowDialog();
        }

        #endregion

        #region Match Status

        private void UpdateMatchStatus()
        {
            btnx_Schedule.Checked = false;
            btnx_StartList.Checked = false;
            btnx_Running.Checked = false;
            btnx_Suspend.Checked = false;
            btnx_Unofficial.Checked = false;
            btnx_Finished.Checked = false;
            btnx_Revision.Checked = false;
            btnx_Canceled.Checked = false;

            btnx_Schedule.Enabled = true;
            btnx_StartList.Enabled = true;
            btnx_Running.Enabled = false;
            btnx_Suspend.Enabled = false;
            btnx_Unofficial.Enabled = false;
            btnx_Finished.Enabled = false;
            btnx_Revision.Enabled = false;


            switch (m_iCurStatusID)
            {
                case GVAR.STATUS_SCHEDULE:
                    {
                        btnx_StartList.Enabled = true;

                        btnx_Schedule.Checked = true;

                        btnx_Status.Text = btnx_Schedule.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case GVAR.STATUS_STARTLIST:
                    {
                        btnx_Running.Enabled = true;

                        btnx_StartList.Checked = true;

                        btnx_Status.Text = btnx_StartList.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case GVAR.STATUS_RUNNING:
                    {
                        btnx_Suspend.Enabled = true;
                        btnx_Unofficial.Enabled = true;

                        btnx_Running.Checked = true;
                        btnx_Status.Text = btnx_Running.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.Red;

                        break;
                    }
                case GVAR.STATUS_SUSPEND:
                    {
                        btnx_Running.Enabled = true;

                        btnx_Suspend.Checked = true;
                        btnx_Status.Text = btnx_Suspend.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.Red;
                        break;
                    }
                case GVAR.STATUS_UNOFFICIAL:
                    {
                        btnx_Finished.Enabled = true;
                        btnx_Revision.Enabled = true;

                        btnx_Unofficial.Checked = true;
                        btnx_Status.Text = btnx_Unofficial.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case GVAR.STATUS_FINISHED:
                    {
                        btnx_Revision.Enabled = true;

                        btnx_Schedule.Enabled = false;
                        btnx_StartList.Enabled = false;

                        btnx_Finished.Checked = true;
                        btnx_Status.Text = btnx_Finished.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case GVAR.STATUS_REVISION:
                    {
                        btnx_Finished.Enabled = true;
                        btnx_Revision.Checked = true;
                        btnx_Status.Text = btnx_Revision.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case GVAR.STATUS_CANCELED:
                    {
                        btnx_Canceled.Checked = true;
                        btnx_Status.Text = btnx_Canceled.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                default:
                    return;
            }

        }

        private void UpdateMatchStatusEQ()
        {
            OVRDataBaseUtils.ChangeMatchStatus(m_iCurIndividualMatchID, m_iCurStatusID, GVAR.g_adoDataBase.DBConnect, GVAR.g_EQPlugin);
            if (m_bIsTeamMatch) OVRDataBaseUtils.ChangeMatchStatus(m_iCurTeamMatchID, m_iCurStatusID, GVAR.g_adoDataBase.DBConnect, GVAR.g_EQPlugin);
            UpdateMatchStatus();
        }

        private void btnx_Schedule_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = GVAR.STATUS_SCHEDULE;
            UpdateMatchStatusEQ();
        }

        private void btnx_StartList_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = GVAR.STATUS_STARTLIST;
            UpdateMatchStatusEQ();
        }

        private void btnx_Running_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = GVAR.STATUS_RUNNING;
            UpdateMatchStatusEQ();
        }

        private void btnx_Suspend_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = GVAR.STATUS_SUSPEND;
            UpdateMatchStatusEQ();
        }

        private void btnx_Unofficial_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = GVAR.STATUS_UNOFFICIAL;
            UpdateMatchStatusEQ();

            //更新Q标记到TS_EQ_MatchResult
            GVAR.g_EQDBManager.UpdateMatchResultQ(m_iCurIndividualMatchID);

            //刷新dgv
            InitDgvMatchResultList();
            InitDgvMatchResultDetailList();
        }

        private void btnx_Finished_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = GVAR.STATUS_FINISHED;
            UpdateMatchStatusEQ();

            //插入名次行到TS_Event
            GVAR.g_EQDBManager.UpdateEventResult(m_iCurIndividualMatchID);

            //刷新dgv
            InitDgvMatchResultList();
            InitDgvMatchResultDetailList();

        }

        private void btnx_Revision_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = GVAR.STATUS_REVISION;
            UpdateMatchStatusEQ();
            //dgv重新加载，重置readonly状态
            dgvMatchResults.ReadOnly = false;
            dgvMatchResultDetails.ReadOnly = false;
            InitDgvMatchResultList();
        }

        private void btnx_Canceled_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = GVAR.STATUS_CANCELED;
            UpdateMatchStatusEQ();
            //dgv重新加载，重置readonly状态
            dgvMatchResults.ReadOnly = false;
            dgvMatchResultDetails.ReadOnly = false;
            InitDgvMatchResultList();
        }

        #endregion

        #region Team

        private void btnx_Team_Click(object sender, EventArgs e)
        {
            //清空基础信息 dgvresult dgvresultdetail
            CleanMatchResults();
            CleanMatchResultDetails();
            m_iCurResultRowID = 0;
            //个人和团体成绩显示切换
            //显示个人界面
            if (m_bShowTeam)
            {
                m_bShowTeam = false;
                if (!m_strCurMatchRuleCode.Equals("BR"))
                {
                    g_MatchScoreDetail.Visible = true;
                }
                btnx_TeamResult.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_TeamResult");
                m_iCurMatchID = m_iCurIndividualMatchID;
                InitMatchInfo(m_iCurMatchID);
                //获取基础信息 dgvresult dgvresultdetail
                InitDgvMatchResultList();
                InitDgvMatchResultDetailList();
            }
            //显示团队界面
            else
            {
                m_bShowTeam = true;
                //不显示细节分
                g_MatchScoreDetail.Visible = false;
                btnx_TeamResult.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_IndividualResult");
                m_iCurMatchID = m_iCurTeamMatchID;
                InitMatchInfo(m_iCurMatchID);
                InitDgvMatchResultList();
            }
            GVAR.g_EQPlugin.SetReportContext("MatchID", m_iCurMatchID.ToString());
        }

        #endregion

        #region Clear Match Data

        private void btnx_ClearData_Click(object sender, EventArgs e)
        {
            //比赛状态为startlist时才可以清除数据
            if (m_iCurStatusID == GVAR.STATUS_STARTLIST)
            {
                //弹出对话框，确认是否将比赛设置为schedule
                if (GVAR.MsgBox(LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "mbClearData"), "", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) != DialogResult.Yes)
                    return;
                //删除成绩行,删除比赛配置信息
                GVAR.g_EQDBManager.RemoveMatchResultsRows(m_iCurIndividualMatchID);

                //复位比赛状态包括个人和团体
                m_iCurStatusID = GVAR.STATUS_SCHEDULE;
                UpdateMatchStatusEQ();

                //退出比赛
                ExitMatch();
                //dgv重置readonly状态
                dgvMatchResults.ReadOnly = false;
                dgvMatchResultDetails.ReadOnly = false;
            }
        }
        private void CleanMatchInfo()
        {
            m_strEventName = "";
            m_strMatchName = "";
            m_strVenueDes = "";
            m_strDateDes = "";
            lb_EventDes.Text = null;
            lb_MatchDes.Text = null;
            lb_DateDes.Text = null;
            //lb_VenueDes.Text = null;
        }
        private void CleanMatchResults()
        {
            this.dgvMatchResults.Rows.Clear();
            this.dgvMatchResults.Columns.Clear();

        }
        private void CleanMatchResultDetails()
        {
            this.dgvMatchResultDetails.Rows.Clear();
            this.dgvMatchResultDetails.Columns.Clear();

        }
        private void CleanMatchPenType()
        {
            this.dgvMatchPenType.Rows.Clear();
            this.dgvMatchPenType.Columns.Clear();

        }

        #endregion

        #region ToolStripMenu

        private void dgvMatchResults_CellMouseDown(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                if (e.RowIndex >= 0)
                {
                    //若行已是选中状态就不再进行设置
                    if (dgvMatchResults.Rows[e.RowIndex].Selected == false)
                    {
                        dgvMatchResults.ClearSelection();
                        dgvMatchResults.Rows[e.RowIndex].Selected = true;
                    }
                    //只选中一行时设置活动单元格，同时切换当前行
                    if (dgvMatchResults.SelectedRows.Count == 1)
                    {
                        dgvMatchResults.CurrentCell = dgvMatchResults.Rows[e.RowIndex].Cells[e.ColumnIndex];
                    }
                    //设置当前行为右键点击的行
                    m_iCurResultRowID = e.RowIndex;
                    m_iCurRegisterID = Convert.ToInt32(dgvMatchResults.Rows[m_iCurResultRowID].Cells["F_RegisterID"].Value.ToString());

                    //如果是个人比赛，才更新resultdetail
                    if (!m_bShowTeam)
                    {
                        InitDgvMatchResultDetailList();
                    }

                    //弹出操作菜单
                    if (dgvMatchResults.Columns[e.ColumnIndex].Name == "F_StartTime")
                    {
                        this.dgvMatchResults.ContextMenuStrip = MenuStrip_StartTime;
                    }
                    else if ((dgvMatchResults.Columns[e.ColumnIndex].Name == "RegisterName" || dgvMatchResults.Columns[e.ColumnIndex].Name == "F_Status") && !m_bShowTeam)
                    {
                        int iStatus;
                        iStatus = GVAR.Str2Int(dgvMatchResults.Rows[e.RowIndex].Cells["F_Status"].Value);
                        switch (iStatus)
                        {
                            case 0:
                                toolStripMenuItem_Status_NotStarted.Checked = true;
                                toolStripMenuItem_Status_Started.Checked = false;
                                toolStripMenuItem_Status_Finished.Checked = false;
                                break;
                            case 1:
                                toolStripMenuItem_Status_NotStarted.Checked = false;
                                toolStripMenuItem_Status_Started.Checked = true;
                                toolStripMenuItem_Status_Finished.Checked = false;
                                break;
                            case 2:
                                toolStripMenuItem_Status_NotStarted.Checked = false;
                                toolStripMenuItem_Status_Started.Checked = false;
                                toolStripMenuItem_Status_Finished.Checked = true;
                                break;
                        }
                        this.dgvMatchResults.ContextMenuStrip = MenuStrip_Status1;

                    }
                    else if (dgvMatchResults.Columns[e.ColumnIndex].Name == "F_CurTime")
                    {
                        this.dgvMatchResults.ContextMenuStrip = MenuStrip_JPTime;
                    }
                    else
                        this.dgvMatchResults.ContextMenuStrip = null;
                }
            }
        }
        //填出时间编辑框，默认获取该match的starttime和riderinterval，按照出发顺序更新所有rider的开始时间
        private void toolStripMenuItem_EditStartTime_Click(object sender, EventArgs e)
        {

            OVREQEditTimeForm frmOVREQEditTime = new OVREQEditTimeForm();
            frmOVREQEditTime.ShowDialog();

            if (frmOVREQEditTime.DialogResult != DialogResult.OK)
                return;

            string strStartTime = frmOVREQEditTime.StartTime;
            string strSpanTime = frmOVREQEditTime.SpanTime;
            string strFinishTime = "";

            if (strStartTime.Length == 0)
                strStartTime = "00:00:00";
            if (strSpanTime.Length == 0)
                strSpanTime = "00:00:00";
            DateTime tStartTime = DateTime.Parse(strStartTime);
            DateTime tCurStartTime;
            TimeSpan ts = TimeSpan.Parse(strSpanTime);
            bool bUpdate = false;

            for (int i = 0; i < dgvMatchResults.Rows.Count; i++)
            {
                tCurStartTime = tStartTime;
                int iOrderID = Convert.ToInt32(dgvMatchResults.Rows[i].Cells["F_Order"].Value.ToString());
                for (int j = 0; j < iOrderID - 1; j++)
                    tCurStartTime += ts;
                strStartTime = tCurStartTime.ToString("HH:mm:ss");
                if (m_strCurMatchRuleCode.Equals("CC"))//如果是越野比赛，计算FinishTime
                {
                    //string strCCRiderInterval = m_dtMatchConfig.Rows[0]["F_RiderInterval"].ToString();
                    string strCCTimeAllowed = GVAR.StrTime2SpanTime(m_dtMatchConfig.Rows[0]["F_TimeAllowed"].ToString());
                    strFinishTime = (tCurStartTime + TimeSpan.Parse(strCCTimeAllowed)).ToString("HH:mm:ss");
                }
                string strRegisterID = dgvMatchResults.Rows[i].Cells["F_RegisterID"].Value.ToString().Trim();
                //更新逐个更新所有starttime，同时将breaktime设置为null
                bool bReturn = GVAR.g_EQDBManager.UpdateMatchTime(m_iCurMatchID, int.Parse(strRegisterID),
                        strStartTime, "", strFinishTime);
                if (bReturn)
                {
                    bUpdate = true;
                    //更新界面starttime时禁用cellvaluechanged消息
                    this.dgvMatchResults.CellValueChanged -= new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchResults_CellValueChanged);
                    dgvMatchResults.Rows[i].Cells["F_StartTime"].Value = strStartTime;
                    dgvMatchResults.Rows[i].Cells["F_FinishTime"].Value = strFinishTime;
                    this.dgvMatchResults.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchResults_CellValueChanged);
                    dgvMatchResults.Rows[i].Cells["F_BreakTime"].Value = "";
                }
            }
            if (bUpdate)
            {
                //EQCommon.g_EQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_iCurMatchID, m_iCurMatchID, null);
            }
        }

        private void toolStripMenuItem_EditBreakTime_Click(object sender, EventArgs e)
        {
            if (this.dgvMatchResults.SelectedRows.Count < 0)
                return;
            DataGridViewRow CurRow = this.dgvMatchResults.SelectedRows[0];

            OVREQEditTimeForm frmOVREQEditTime = new OVREQEditTimeForm();
            frmOVREQEditTime.labX_SpanTime.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "labXBreakTime");
            frmOVREQEditTime.labX_StartTime.Visible = false;
            frmOVREQEditTime.dti_StartTime.Visible = false;
            frmOVREQEditTime.SpanTime = CurRow.Cells["F_BreakTime"].Value.ToString();
            frmOVREQEditTime.ShowDialog();

            if (frmOVREQEditTime.DialogResult != DialogResult.OK)
                return;

            string strStartTime = "";
            string strBreakTime = frmOVREQEditTime.SpanTime;
            CurRow.Cells["F_BreakTime"].Value = strBreakTime;

            if (strBreakTime.Length == 0)
                strBreakTime = "00:00:00";
            DateTime tOldStartTime = DateTime.Parse(CurRow.Cells["F_StartTime"].Value.ToString());
            DateTime tCurStartTime;
            TimeSpan ts = TimeSpan.Parse(strBreakTime);
            int iCurOrderID = Convert.ToInt32(CurRow.Cells["F_Order"].Value.ToString());
            bool bUpdate = false;
            string strRegisterID = dgvMatchResults.Rows[iCurOrderID - 1].Cells["F_RegisterID"].Value.ToString().Trim();
            //如果breaktime为0，则将数据库的breaktime设置为null
            if (strBreakTime.CompareTo("00:00:00") == 0)
            {
                GVAR.g_EQDBManager.UpdateMatchTime(m_iCurMatchID, int.Parse(strRegisterID),
                            "-1", "", "-1");
                CurRow.Cells["F_BreakTime"].Value = "";

            }
            //如果breaktime不为0，则将数据库的breaktime设置为当前breaktime，同时更新之后的starttime
            else
            {
                GVAR.g_EQDBManager.UpdateMatchTime(m_iCurMatchID, int.Parse(strRegisterID),
                            "-1", strBreakTime, "-1");
                //从当前行的下一行开始批量修改时间
                for (int i = iCurOrderID; i < dgvMatchResults.Rows.Count; i++)
                {
                    tOldStartTime = DateTime.Parse(dgvMatchResults.Rows[i].Cells["F_StartTime"].Value.ToString());
                    tCurStartTime = tOldStartTime + ts;
                    strStartTime = tCurStartTime.ToString("HH:mm:ss");
                    strRegisterID = dgvMatchResults.Rows[i].Cells["F_RegisterID"].Value.ToString().Trim();
                    //逐个更新starttime，同时将breaktime设置为null
                    bool bReturn = GVAR.g_EQDBManager.UpdateMatchTime(m_iCurMatchID, int.Parse(strRegisterID),
                            strStartTime, "", "-1");
                    if (bReturn)
                    {
                        bUpdate = true;
                        this.dgvMatchResults.CellValueChanged -= new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchResults_CellValueChanged);
                        dgvMatchResults.Rows[i].Cells["F_StartTime"].Value = strStartTime;
                        this.dgvMatchResults.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvMatchResults_CellValueChanged);
                        dgvMatchResults.Rows[i].Cells["F_BreakTime"].Value = "";
                    }
                }
            }
            if (bUpdate)
            {
                //EQCommon.g_EQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_iCurMatchID, m_iCurMatchID, null);
            }
        }

        private void toolStripMenuItem_Status_NotStarted_Click(object sender, EventArgs e)
        {
            if (this.dgvMatchResults.SelectedRows.Count < 0) return;
            DataGridViewRow CurRow = this.dgvMatchResults.SelectedRows[0];
            //修改当前运动员的打分状态
            GVAR.g_EQDBManager.UpdateRegisterStatus(m_iCurMatchID, m_iCurRegisterID, GVAR.SCORE_STATUS_NOTSTARTED);
            //更新成绩和排名，如果有团体比赛，更新团体的成绩和排名
            GVAR.g_EQDBManager.UpdateRegisterRankAndResult(m_iCurMatchID);
            if (m_bIsTeamMatch) GVAR.g_EQDBManager.UpdateRegisterRankAndResult(m_iCurTeamMatchID);
            InitDgvMatchResultList();
        }

        private void toolStripMenuItem_Status_Started_Click(object sender, EventArgs e)
        {
            if (this.dgvMatchResults.SelectedRows.Count < 0) return;
            DataGridViewRow CurRow = this.dgvMatchResults.SelectedRows[0];
            string strRegisterName = CurRow.Cells["RegisterName"].Value.ToString() + "(" + CurRow.Cells["F_DelegationShortName"].Value.ToString() + ")";
            
            //发送打分记录给打分器
            if (frmIpadMark != null)
            {
                frmIpadMark.SendScoreList(m_iCurMatchID, m_iCurRegisterID, m_iCurResultRowID + 1, strRegisterName, m_strMatchTitle, "", strRegisterName);
            }

            UpdateWhenRegisterStatus2Start(m_iCurMatchID,m_iCurRegisterID);

        }

        private void UpdateWhenRegisterStatus2Start(int iMatchID, int iRegisterID)
        {
            UpdateDBWhenRegisterStatus2Start(iMatchID,iRegisterID);
            UpdateSCBWhenRegisterStatus2Start(iMatchID, iRegisterID);
            InitDgvMatchResultList();
        }

        private void UpdateDBWhenRegisterStatus2Start(int iMatchID,int iRegisterID)
        {
            //更新当前运动员的状态，如果是团体成员，更新团体的状态
            GVAR.g_EQDBManager.UpdateRegisterStatus(iMatchID, iRegisterID, GVAR.SCORE_STATUS_STARTED);
            //更新成绩和排名，如果有团体比赛，更新团体的成绩和排名
            GVAR.g_EQDBManager.UpdateRegisterRankAndResult(iMatchID);
            if (m_bIsTeamMatch) GVAR.g_EQDBManager.UpdateRegisterRankAndResult(GVAR.g_EQDBManager.GetTeamMatchID(iMatchID));
    
            
        }

        private void UpdateSCBWhenRegisterStatus2Start(int iMatchID, int iRegisterID)
        {
            string strMatchRuleCode = GVAR.g_EQDBManager.GetMatchRuleCodeFromMatchID(iMatchID);
            //触发大屏显示当前运动员的成绩
            if (strMatchRuleCode.Equals("DR"))//如果是盛装舞步
            {
                TriggerAutoSports("out", "DR-CurrentResult", "", iMatchID, iRegisterID);
                TriggerAutoSports("in", "DR-RunningResult-H", "", iMatchID, iRegisterID);
                TriggerAutoSports("in", "Top3", "", iMatchID, iRegisterID);
                TriggerAutoSports("in", "DR-RunningResult-M", "", iMatchID, iRegisterID);
            }
            //越野和绕桶只显示实时屏
            if (strMatchRuleCode.Equals("CC")||strMatchRuleCode.Equals("BR"))
            {

            }
            if (strMatchRuleCode.Equals("JP"))
            {
                TriggerAutoSports("out", "JP-CurrentResult", "", iMatchID, iRegisterID);
                //清空正计时，倒计时，实时罚分
                TriggerAutoSports("v", "bib", "", iMatchID, iRegisterID);
                //TriggerAutoSports("v", "clock", "", iMatchID, iRegisterID);
                TriggerAutoSports("v", "clock", "45", iMatchID, iRegisterID);
                TriggerAutoSports("v", "correct", "", iMatchID, iRegisterID);
                TriggerAutoSports("v", "timepen", "", iMatchID, iRegisterID);
                TriggerAutoSports("v", "fencepen", "", iMatchID, iRegisterID);
                TriggerAutoSports("v", "totalpen", "", iMatchID, iRegisterID);

                TriggerAutoSports("in", "JP-RunningResult-H", "", iMatchID, iRegisterID);
                TriggerAutoSports("in", "Top3", "", iMatchID, iRegisterID);
                TriggerAutoSports("in", "JP-RunningResult-M", "", iMatchID, iRegisterID);
            }
        }

        private void toolStripMenuItem_Status_Finished_Click(object sender, EventArgs e)
        {
            if (this.dgvMatchResults.SelectedRows.Count < 0) return;
            
            //触发IPAD break
            if (frmIpadMark != null)
            {
                frmIpadMark.JudgeMgr.setMatchInfo("", "", "", "");
            }

            UpdateWhenRegisterStatus2Finish(m_iCurMatchID,m_iCurRegisterID);
        }

        private void UpdateWhenRegisterStatus2Finish(int iMatchID,int iRegisterID)
        {
            UpdateDBWhenRegisterStatus2Finish(iMatchID,iRegisterID);
            UpdateSCBWhenRegisterStatus2Finish(iMatchID, iRegisterID);
            InitDgvMatchResultList();
            //当一个骑手完成时，触发一次实时成绩给INFO
            GVAR.g_EQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_iCurMatchID, m_iCurMatchID, null);
            GVAR.g_EQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_iCurTeamMatchID, m_iCurTeamMatchID, null);

        }

        private void UpdateDBWhenRegisterStatus2Finish(int iMatchID,int iRegisterID)
        {
            //修改当前运动员的打分状态
            GVAR.g_EQDBManager.UpdateRegisterStatus(iMatchID, iRegisterID, GVAR.SCORE_STATUS_FINISHED);
            //更新成绩和排名，如果有团体比赛，更新团体的成绩和排名
            GVAR.g_EQDBManager.UpdateRegisterRankAndResult(iMatchID);
            if (m_bIsTeamMatch) GVAR.g_EQDBManager.UpdateRegisterRankAndResult(GVAR.g_EQDBManager.GetTeamMatchID(iMatchID));
       }

        private void UpdateSCBWhenRegisterStatus2Finish(int iMatchID, int iRegisterID)
        {
            string strMatchRuleCode = GVAR.g_EQDBManager.GetMatchRuleCodeFromMatchID(iMatchID);
            //触发大屏显示当前运动员的成绩
            //如果是盛装舞步
            if (strMatchRuleCode.Equals("DR"))
            {
                TriggerAutoSports("v", "MID", "0", iMatchID, iRegisterID);
                TriggerAutoSports("out", "DR-RunningResult-H", "", iMatchID, iRegisterID);
                TriggerAutoSports("out", "Top3", "", iMatchID, iRegisterID);
                TriggerAutoSports("out", "DR-RunningResult-M", "", iMatchID, iRegisterID);
                TriggerAutoSports("in", "DR-CurrentResult", "", iMatchID, iRegisterID);
            }
            //越野和绕桶只显示实时屏
            if (strMatchRuleCode.Equals("CC") || strMatchRuleCode.Equals("BR"))
            {
                TriggerAutoSports("stay", "Top3", "", iMatchID, iRegisterID);
            }
            if(strMatchRuleCode.Equals("JP"))
            {
                TriggerAutoSports("out", "JP-RunningResult-H", "", iMatchID, iRegisterID);
                TriggerAutoSports("out", "Top3", "", iMatchID, iRegisterID);
                TriggerAutoSports("out", "JP-RunningResult-M", "", iMatchID, iRegisterID);

                //清空正计时，倒计时，实时罚分
                TriggerAutoSports("v", "bib", "", iMatchID, iRegisterID);
                TriggerAutoSports("v", "clock", "", iMatchID, iRegisterID);
                TriggerAutoSports("v", "correct", "", iMatchID, iRegisterID);
                TriggerAutoSports("v", "timepen", "", iMatchID, iRegisterID);
                TriggerAutoSports("v", "fencepen", "", iMatchID, iRegisterID);
                TriggerAutoSports("v", "totalpen", "", iMatchID, iRegisterID);

                TriggerAutoSports("in", "JP-CurrentResult", "", iMatchID, iRegisterID);
            }
        }

        private void toolStripMenuItem_JPTime_Modify_Click(object sender, EventArgs e)
        {
            if (this.dgvMatchResults.SelectedRows.Count < 0) return;
            DataGridViewRow CurRow = this.dgvMatchResults.SelectedRows[0];
            Int32 iMatchID = GVAR.Str2Int(CurRow.Cells["F_MatchID"].Value.ToString());
            Int32 iRegisterID = GVAR.Str2Int(CurRow.Cells["F_RegisterID"].Value.ToString());
            //获取当前时间
            string strTime = CurRow.Cells["F_CurTime"].Value.ToString();

            OVREQJPTimeForm frmOVREQJPTime = new OVREQJPTimeForm(m_iCurMatchConfigID,strTime);
            frmOVREQJPTime.ShowDialog();

            if (frmOVREQJPTime.DialogResult != DialogResult.OK)
                return;

            //使用收到的用时计算并更新DB和dgvresult
            decimal fInputValue = frmOVREQJPTime.FinalTime;
            GVAR.g_EQDBManager.UpdateCurTimePen(iMatchID, iRegisterID, fInputValue);
            //计算Cur总分，并更新总分到result表
            GVAR.g_EQDBManager.UpdateCurPointsWhenScoreChanged(m_iCurMatchID, m_iCurRegisterID,0);
            GVAR.g_EQDBManager.UpdateTotPointsWhenCurPointsChanged(m_iCurMatchID, m_iCurRegisterID);


            InitDgvMatchResultList();
        }

        private void dgvMatchResultDetails_CellMouseDown(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                if (e.RowIndex >= 0)
                {
                    m_iCurResultDetailsRowID = e.RowIndex;
                    //弹出操作菜单
                    if (dgvMatchResultDetails.Columns[e.ColumnIndex].Name == "F_Judge")
                    {
                        dgvMatchResultDetails.Rows[e.RowIndex].Cells[e.ColumnIndex].Selected = true;
                        int iStatus;
                        iStatus = GVAR.Str2Int(dgvMatchResultDetails.Rows[e.RowIndex].Cells["F_Status"].Value);
                        m_iCurJudgePosition = GVAR.Str2Int(dgvMatchResultDetails.Rows[e.RowIndex].Cells["F_JudgePosition"].Value);
                        switch (iStatus)
                        {
                            case 0:
                                toolStripMenuItem_Status_NotValidated.Checked = true;
                                toolStripMenuItem_Status_Validated.Checked = false;
                                break;
                            case 1:
                                toolStripMenuItem_Status_NotStarted.Checked = false;
                                toolStripMenuItem_Status_Started.Checked = true;
                                break;
                        }
                        this.dgvMatchResultDetails.ContextMenuStrip = MenuStrip_Status2;
                    }
                    else
                        this.dgvMatchResultDetails.ContextMenuStrip = null;
                }
            }
        }

        private void toolStripMenuItem_Status_NotValidated_Click(object sender, EventArgs e)
        {
            GVAR.g_EQDBManager.UpdateDetailScoreNull(m_iCurMatchID, m_iCurRegisterID, m_iCurJudgePosition, "F_Status");
            dgvMatchResultDetails.Rows[m_iCurResultDetailsRowID].DefaultCellStyle.ForeColor = Color.Black;
        }

        private void toolStripMenuItem_Status_Validated_Click(object sender, EventArgs e)
        {
            GVAR.g_EQDBManager.UpdateDetailScore(m_iCurMatchID, m_iCurRegisterID, m_iCurJudgePosition, "F_Status", 1);
            dgvMatchResultDetails.Rows[m_iCurResultDetailsRowID].DefaultCellStyle.ForeColor = Color.Green;

            //计算和更新裁判点总分和百分比分
            GVAR.g_EQDBManager.UpdateJudgePointsWhenDetailScoreChange(m_iCurMatchID, m_iCurRegisterID, m_iCurJudgePosition);
            //更新当前总
            GVAR.g_EQDBManager.UpdateCurPointsWhenScoreChanged(m_iCurMatchID, m_iCurRegisterID, 1);
            //更新累计总
            GVAR.g_EQDBManager.UpdateTotPointsWhenCurPointsChanged(m_iCurMatchID, m_iCurRegisterID);

            //刷新dgv
            InitDgvMatchResultDetailList();
            InitDgvMatchResultList();
        }

        #endregion
       
        #region IPADMark   IPAD 打分器

        private void chkX_Listen_CheckedChanged(object sender, EventArgs e)
        {
            if (chkX_Listen.Checked)
            {
                int nPort = 1234;
                if (txtBoxX_ListenPort.Text.Length < 1||GVAR.Str2Int(txtBoxX_ListenPort.Text)==0)
                {
                    chkX_Listen.CheckState = CheckState.Unchecked;
                    return;
                }
                nPort = GVAR.Str2Int(txtBoxX_ListenPort.Text);
                ConfigurationManager.SetPluginSettingString("EQ", "UDP_Port", nPort.ToString());

                frmIpadMark = frmOVREQIPadMark.GetIPadMarkForm();
                frmIpadMark.TopMost = true;
                frmIpadMark.LanguageCode = m_strLanguageCode;
                frmIpadMark.MatchID = m_iCurMatchID;
                frmIpadMark.MatchConfigID = m_iCurMatchConfigID;
                frmIpadMark.Port = nPort;
                frmIpadMark.MatchTitle = m_strMatchTitle;
                if (this.dgvMatchResults.SelectedRows.Count > 0) 
                {
                    frmIpadMark.RegisterID = m_iCurRegisterID;
                    DataGridViewRow CurRow = this.dgvMatchResults.SelectedRows[0];
                    frmIpadMark.RegisterName = CurRow.Cells["RegisterName"].Value.ToString() + "(" + CurRow.Cells["F_DelegationShortName"].Value.ToString() + ")";
                }
                //frmIpadMark.Owner = this;
                //绑定IpadMark窗体事件对应的响应函数
                frmIpadMark.m_EventIpadMark += new frmIpadMark2frmDataEntryEventHandler(OnfrmIpadMarkEvent);
                frmIpadMark.Show();
            }
            else
            {
                if (frmIpadMark != null) frmIpadMark.Close();
            }

        }
        //响应函数基于消息类型，进行不同的处理
        void OnfrmIpadMarkEvent(object sender, frmIPadMark2frmDataEntryEventArgs e)
        {
            switch (e.Type)
            {
                case frmIPadMark2frmDataEntryEventType.emfrmIPadMarkClosed:
                    {
                        if (this.InvokeRequired)
                        {
                            this.Invoke((MethodInvoker)delegate { chkX_Listen.CheckState = CheckState.Unchecked; });
                        }
                        else
                        {
                            chkX_Listen.CheckState = CheckState.Unchecked;
                        }
                        break;
                    }
                case frmIPadMark2frmDataEntryEventType.emUpdateDgvResultDetail:
                    {
                        if (this.InvokeRequired)
                        {
                            this.Invoke((MethodInvoker)delegate { InitDgvMatchResultDetailList(); });
                        }
                        else
                        {
                            InitDgvMatchResultDetailList();
                        }
                        break;
                    }
                case frmIPadMark2frmDataEntryEventType.emUpdateDgvResult:
                    {
                        if (this.InvokeRequired)
                        {
                            this.Invoke((MethodInvoker)delegate { InitDgvMatchResultList(); });
                        }
                        else
                        {
                            InitDgvMatchResultList();
                        }
                        break;
                    }
            }
        }

        #endregion

        #region Timing Interface

        private void chkX_Connect_CheckedChanged(object sender, EventArgs e)    //Connect
        {
            if (chkX_Connect.Checked)
            {
                string strIP = ipAddressInput.Value;
                if (ipAddressInput.Value == null || strIP.Length < 1)
                {
                    chkX_Connect.CheckState = CheckState.Unchecked;
                    return;
                }
                int nPort = 3227;
                if (txtBoxX_ConnectPort.Text.Length < 1 || GVAR.Str2Int(txtBoxX_ConnectPort.Text) == 0)
                {
                    chkX_Connect.CheckState = CheckState.Unchecked;
                    return;
                }
                nPort = GVAR.Str2Int(txtBoxX_ConnectPort.Text); 

                if (timingIF == null)
                {
                    timingIF = new TimingIF();
                }
                Cursor.Current = Cursors.WaitCursor;

                if (OpenTCP(strIP, nPort))
                {
                    ConfigurationManager.SetPluginSettingString("EQ", "TCP_IP", strIP);
                    ConfigurationManager.SetPluginSettingString("EQ", "TCP_Port", nPort.ToString());
                }
                else
                {
                    CloseTCPConnection();
                    chkX_Connect.CheckState = CheckState.Unchecked;
                }
                Cursor.Current = Cursors.Arrow;
            }
            else
            {
                CloseTCPConnection();
            }
        }

        private void UncheckchkX_Connect()
        {
            //交给主线程处理
            if (this.InvokeRequired)
			{
				this.Invoke((MethodInvoker)delegate { UncheckchkX_Connect(); });
			}
           chkX_Connect.CheckState = CheckState.Unchecked;
           CloseTCPConnection();
        }

        private bool OpenTCP(string ip, int port)
        {
            bool result = false;
            if (tcpReceiver == null)
            {   //add process for: what if the network break when connected to host, and
                //how to reconnect to the host
                try
                {
                    tcpReceiver = new TCPReceiver();
                    tcpReceiver.DataReceived += timingIF.GetSlalomMessage;
                    tcpReceiver.TCPServerDisconnected += UncheckchkX_Connect;
                    result = true;
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message.ToString());
                    return result = false;
                }
            }
            if (tcpReceiver != null && !tcpReceiver.IsConnected)
            {
                try
                {
                    if (tcpReceiver.Connect(ip, port))
                        result = true;
                    else
                        result = false;
                }
                catch (Exception e)
                {
                    MessageBox.Show(e.Message.ToString());
                    result = false;
                }
            }
            return result;
        }

        private void CloseTCPConnection()
        {
            if (tcpReceiver != null)
            {
                tcpReceiver.Dispose();
                tcpReceiver = null;
            }
            if (timingIF != null)
            {
                timingIF.Dispose();
                timingIF = null;
            }
        }

        #endregion

        #region SCB

        public bool IsAutoSCBChecked()
        {
            return chkX_AutoSCB.Checked;
        }

        private void chkX_AutoSCB_CheckedChanged(object sender, EventArgs e)
        {
            if (chkX_AutoSCB.Checked)
            {
                asServiceControl1.Visible = true;
            }
            else
            {
                asServiceControl1.Visible = false;
            }
        }

        public void TriggerAutoSports(string strType,string strCMD,string strValue,int iMatchID,int iRegisterID)
        {
            try
            {
                //如果auto check同时autosports连接正常，将刷新大屏的当前动作
                if (IsAutoSCBChecked() && asServiceControl1.m_asDataProxy.IsConnected())
                {
                    asServiceControl1.m_asDataProxy.PushVariable("matchid", iMatchID.ToString());
                    asServiceControl1.m_asDataProxy.PushVariable("registerid", iRegisterID.ToString());
                    if(strType.Equals("stay"))
                    {
                        asServiceControl1.m_asDataProxy.PushTriggersTay(strCMD);
                    }
                    if (strType.Equals("in"))
                    {
                        asServiceControl1.m_asDataProxy.PushTriggerIn(strCMD);
                    }
                    if (strType.Equals("out"))
                    {
                        asServiceControl1.m_asDataProxy.PushTriggerOut(strCMD);
                    }
                    if (strType.Equals("v"))
                    {
                        asServiceControl1.m_asDataProxy.PushVariable(strCMD, strValue);
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        #endregion



    }
}
