using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Xml;
using System.Net;
using System.Net.Sockets;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using OVREQPlugin.Common;
using System.Text.RegularExpressions;
using System.Timers;
using System.Diagnostics;
using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    public delegate void UpdateMonitorDelegate();

    #region 打分器窗体
    //使用单例模式，实现JudgePanelMgrCallBack接口，实现了发打分列表，收打分列表，处理打分器状态改变，输出消息，发送UDP数据包在不同打分项目具体实现的分离
	public partial class frmOVREQIPadMark : UIForm, JudgePanelMgrCallBack
    {
        #region singleton
        private static volatile frmOVREQIPadMark frmIpadMark = null;
        private static object lockHelper = new Object();
        private frmOVREQIPadMark()
        {
            InitializeComponent();
            Localization();
        }
        public static frmOVREQIPadMark GetIPadMarkForm()
        {
            if (frmIpadMark == null || frmIpadMark.IsDisposed)
            {
                lock (lockHelper)
                {
                    if (frmIpadMark == null || frmIpadMark.IsDisposed)
                    {
                        frmIpadMark = new frmOVREQIPadMark();
                    }
                }
            }
            return frmIpadMark;
        }
        #endregion

        private UpdateMonitorDelegate updateMonitorDelegate = null;

        #region event
        //定义IpadMark窗体事件
        public event frmIpadMark2frmDataEntryEventHandler m_EventIpadMark;
        #endregion

        #region Fields
        private System.Windows.Forms.Timer m_oTimer; 
        private String m_strLanguageCode = "ENG";
		private NetUdp m_netUdp;
        private JudgePanelMgr m_judgeMgr;
        private DataTable m_dtMovementList;
        private int m_iPort;
        private string[] m_strArrJugdes;
        private DataTable m_dtJudgeStatus;
        private int m_iCurMatchID;
        private int m_iCurMatchConfigID;
        private int m_iCurRegisterID;
        private int m_iCurResultRow = 0;
        private string m_strCurMatchTitle;
        private string m_strCurRegisterName;
        private int m_iCurMovement = 0;

        private string[] m_GP = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" };
        private string[] m_GPF = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "0.5", "1.5", "2.5", "3.5", "4.5", "5.5", "6.5", "7.5", "8.5", "9.5"};
        #endregion

        #region Properties

        public String LanguageCode
        {
            get { return m_strLanguageCode; }
            set { m_strLanguageCode = value; }
        }

        public JudgePanelMgr JudgeMgr
        {
            get { return m_judgeMgr; }
            set { m_judgeMgr = value; }
        }

        public int Port
        {
            get { return m_iPort; }
            set { m_iPort = value; }
        }

        public int MatchID
        {
            get { return m_iCurMatchID; }
            set { m_iCurMatchID = value; }
        }

        public int MatchConfigID
        {
            get { return m_iCurMatchConfigID; }
            set { m_iCurMatchConfigID = value; }
        }

        public string MatchTitle
        {
            get { return m_strCurMatchTitle; }
            set { m_strCurMatchTitle = value; }
        }

        public int RegisterID
        {
            get { return m_iCurRegisterID; }
            set { m_iCurRegisterID = value; }
        }

        public string RegisterName
        {
            get { return m_strCurRegisterName; }
            set { m_strCurRegisterName = value; }
        }
        #endregion

        #region Form Load

        //OVR基于打分器的数量实例化打分器管理类，实例化网络通信类
		private void frmOVREQIPadMark_Load(object sender, EventArgs e)
		{
            //开启主裁动作分监控服务
            ServiceManager.EventMonitorServiceIsOnline += new MonitorServiceIsOnlineHandler(NotifyMonitorStatus);
            ServiceManager.Start();
            updateMonitorDelegate = this.MonitorUpdate;

            //启动自动刷新JudgePanel的Timer
            initTimer();

            //更新当前运动员姓名
            lb_CurrentRider.Text = RegisterName;

            //获取舞步列表
            m_dtMovementList = GVAR.g_EQDBManager.GetMatchMovementList(m_iCurMatchID);
            string m_strConfigJudge = GVAR.g_EQDBManager.GetMatchConfigJudge(m_iCurMatchConfigID);

			//Set Judge count.
            m_strArrJugdes = m_strConfigJudge.Split(',');
            //将callback实例（frm自身，frm实现了callback接口）和裁判名数组传入
            m_judgeMgr = new JudgePanelMgr(this, m_strArrJugdes); 

            //显示judge状态列表
            m_dtJudgeStatus = new System.Data.DataTable();
            m_dtJudgeStatus.TableName = "JudgeStatus";
            m_dtJudgeStatus.Columns.Add("F_JudgeNum");
            m_dtJudgeStatus.Columns.Add("F_Judge");
            m_dtJudgeStatus.Columns.Add("F_Status");
            m_dtJudgeStatus.Columns.Add("F_CurMovement");
            int i = 1;
            foreach (string str in m_strArrJugdes)
            {
                m_dtJudgeStatus.Rows.Add(i++, str, "",1);
            }
            this.dgvJudgeStatus.DataSource = m_dtJudgeStatus;
            dgvJudgeStatus.Columns[0].Visible = false;
            dgvJudgeStatus.Columns[3].Visible = false;
            dgvJudgeStatus.Columns[1].Width = 20;


            //Set net.
            m_netUdp = new NetUdp();
            m_netUdp.eventHandlerDataRecv += new EventHandler<eventArgsDataRecv>(_netUdp_eventHandlerDataRecv);

            //Start service.
            if (!m_netUdp.Open(m_iPort))
            {
                MessageBox.Show(m_netUdp.LastErrorMsg);
                return;
            }
		}

        //多语言
        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "OVREQIPadMark");
        }

        #endregion

        #region Timer

        void m_oTimer_Tick(object sender, EventArgs e)
        {
            //扫描所有客户端信息,把曾经接受过消息，之后无法收到消息的，置为红色
            refreshJudgeCtrl();
        }

        void initTimer()
        {
            m_oTimer = new System.Windows.Forms.Timer();
            m_oTimer.Interval = 3000;
            m_oTimer.Tick += new EventHandler(m_oTimer_Tick);
            m_oTimer.Start();
        }
        #endregion

        #region Judge
        ///默认刷新所有裁判台信息

        public bool refreshJudgeCtrl(int judgeNum = -1)
        {
            if (judgeNum == 0 || judgeNum < -1 || judgeNum > m_strArrJugdes.Length)
            {
                Debug.Assert(false);
                return false;
            }

            JudgePanelInfo[] lstjudgePanelInfo = m_judgeMgr.judgePanelInfo();
            Debug.Assert(m_strArrJugdes.Length == lstjudgePanelInfo.Length);

            for (int cycJudge = 1; cycJudge <= lstjudgePanelInfo.Length; cycJudge++)
            {
                if (judgeNum >= 1)	//如果参数指定只修改一个值,就只修改一个控件的值
                    cycJudge = judgeNum;

                {
                    //CtrlJudge ctrlJudge = _lstCtrlJudge[cycJudge - 1];
                    //JudgePanelInfo judgeInfo = lstjudgePanelInfo[cycJudge - 1];

                    //ctrlJudge.JudgeDesc = judgeInfo._judgeDesc;
                    //ctrlJudge.TimeoutStatus = (int)judgeInfo.HeartbeatStatus;
                    //ctrlJudge.WaitResponseStatus = (int)judgeInfo.WaitResponseStatus;
                    //ctrlJudge.BatteryPercent = judgeInfo._batteryPercent;
                    //ctrlJudge.ToolTip = judgeInfo.Desc;

                    JudgePanelInfo judgePanel = m_judgeMgr.judgePanelInfo()[cycJudge - 1];
                    //string strJudgeStatus = string.Format("状态:{0},回复:{1},电量:{2}",
                    string strJudgeStatus = string.Format("状态:{0},电量:{2}",
                    judgePanel.HeartbeatStatus.ToString(), judgePanel.WaitResponseStatus.ToString(), judgePanel._batteryPercent);

                    updatedgvJudgeStatus(cycJudge, strJudgeStatus);
                }

                if (judgeNum >= 1)
                    break;
            }

            return true;
        }

        /// 通知上层某个裁判台状态有变化
        /// 在新设备登录时, 某个设备电量有变化时, 向其发送MatchInfo, 收到MatchInfoResponse时
        public bool callbackJudgePanelStatusChange(int judgeNum)
        {
            if (this.InvokeRequired)
            {
                this.Invoke((MethodInvoker)delegate { callbackJudgePanelStatusChange(judgeNum); });
                return true;
            }

            JudgePanelInfo judgePanel = m_judgeMgr.judgePanelInfo()[judgeNum - 1];
            string strJudgeStatus = string.Format("状态:{0},回复:{1},电量:{2}",
            judgePanel.HeartbeatStatus.ToString(), judgePanel.WaitResponseStatus.ToString(), judgePanel._batteryPercent);

            return updatedgvJudgeStatus(judgeNum, strJudgeStatus);
        }

        //更新dgvjudgestatus
        private bool updatedgvJudgeStatus(int judgeNum, string strJudgeStatus)
        {
            m_dtJudgeStatus.Rows[judgeNum - 1]["F_Status"] = strJudgeStatus;

            //修改行的背景颜色
            for (int i = 0; i < dgvJudgeStatus.Rows.Count; i++)
            {
                if (dgvJudgeStatus.Rows[i].Cells["F_Status"].Value.ToString().Contains("Normal"))
                {
                    dgvJudgeStatus.Rows[i].DefaultCellStyle.ForeColor = Color.Green;
                }
                if (dgvJudgeStatus.Rows[i].Cells["F_Status"].Value.ToString().Contains("Timeout"))
                {
                    dgvJudgeStatus.Rows[i].DefaultCellStyle.ForeColor = Color.Red;
                }
            }
            return true;
        }

        //切换是否打分
        private void radio_Work_CheckedChanged(object sender, EventArgs e)
        {
            string matchSerial = null;
            if (radio_Work.Checked == true)
            {
                panel_Status.BackColor = Color.Green;
                matchSerial = Convert.ToString(m_iCurMatchID) + '-' + Convert.ToString(m_iCurRegisterID);
            }
            else
            {
                panel_Status.BackColor = Color.Red;
                matchSerial = "";
            }

            m_judgeMgr.setMatchInfo(matchSerial, MatchTitle, "", m_strCurRegisterName);
        }
        #endregion

        #region Score
        //Send the net data to judgeMgr Obj.
        //当收到UDP数据包时-》JudgePanelMgr类的eventRcvUdp解析-》基于解析得到的类型-》调用不同的处理函数-》例如（收到分数列表）-》判断分数列表是否合格-》合格则交给上层处理_callback.callbackJudgeScored(judgeNum, xmlForDB)该回调函数的实现在当前类
 		void _netUdp_eventHandlerDataRecv(object sender, eventArgsDataRecv e)
		{
			m_judgeMgr.eventRcvUdp(e.m_bytes, e.m_ipSource);
		}

        //OVR直接将打分结果入库，给打分器发送反馈（从数据库中查询最新存入的分数（包含分数的有效性信息）
		public bool callbackJudgeScored(int judgeNum, XmlDocument xmlScore)
		{
			if (this.InvokeRequired)
			{
				this.Invoke((MethodInvoker)delegate { callbackJudgeScored(judgeNum, xmlScore); });
				return true;
			}

			//_msg.Text += Environment.NewLine + xmlScore.InnerXml;
            msgShowAndLog("Judge"+judgeNum+": scored for"+m_strCurRegisterName);

            //OVR处理打分结果
            HandleXmlScore(judgeNum,xmlScore);

            return true;
		}

        //每个动作分打完后都需要发送一次分数给OVR，OVR需要计算当前的平均分
        private void HandleXmlScore(int judgeNum, XmlDocument xmlScore)
        {

            // 获取比赛标示和比分列表
            XmlNodeList xmlScoreList = null;
            xmlScoreList = xmlScore.SelectNodes("/Scores/Score");

            //分数是否有效
            bool bIsLegal = true;
            //是否确认提交
            bool bIsValidated = false;

            //当前舞步
            int iScore = 0;

            //直接入库，存入resultdetail
            foreach (XmlNode xmlScoreNode in xmlScoreList)
            {
                iScore++;
                string strScoreID = ((XmlElement)xmlScoreNode).GetAttribute("ScoreID");
                string strScoreValue = ((XmlElement)xmlScoreNode).GetAttribute("ScoreValue");
                //如果为"",表示没打分
                decimal fScore = GVAR.Str2Decimal(strScoreValue);
                if (!strScoreID.Equals("F_TotalScore") && !strScoreID.Equals("F_Status"))
                {
                    if (!strScoreID.Equals("F_0")&&!IslegalSocre(strScoreValue))
                        bIsLegal = false;
                    //将打过的分更新到数据库，调用存储过程更新resultdetail
                    if (strScoreValue != "")
                    {
                        GVAR.g_EQDBManager.UpdateDetailScore(m_iCurMatchID, m_iCurRegisterID, judgeNum, strScoreID, fScore);
                    }
                    else
                    {
                        GVAR.g_EQDBManager.UpdateDetailScoreNull(m_iCurMatchID, m_iCurRegisterID, judgeNum, strScoreID);
                    }
                }
                //如果扣分不为0
                if (strScoreID.Equals("F_0"))
                {
                    GVAR.g_EQDBManager.UpdateJudgePointsWhenDetailScoreChange(m_iCurMatchID, m_iCurRegisterID, 1);
                    GVAR.g_EQDBManager.UpdateJudgePointsWhenDetailScoreChange(m_iCurMatchID, m_iCurRegisterID, 2);
                    GVAR.g_EQDBManager.UpdateJudgePointsWhenDetailScoreChange(m_iCurMatchID, m_iCurRegisterID, 3);
                    GVAR.g_EQDBManager.UpdateJudgePointsWhenDetailScoreChange(m_iCurMatchID, m_iCurRegisterID, 4);
                    GVAR.g_EQDBManager.UpdateJudgePointsWhenDetailScoreChange(m_iCurMatchID, m_iCurRegisterID, 5);
                }
                //如果ipad发送了V按钮，同时分数都合法，则更新detail的状态为1
                if (strScoreID.Equals("F_Status")&&GVAR.Str2Int(strScoreValue)==1&&bIsLegal)
                {
                    GVAR.g_EQDBManager.UpdateDetailScore(m_iCurMatchID, m_iCurRegisterID, judgeNum, "F_Status", 1);
                    bIsValidated = true;
                }
            }

            //计算和更新裁判点总分和百分比分
            GVAR.g_EQDBManager.UpdateJudgePointsWhenDetailScoreChange(m_iCurMatchID, m_iCurRegisterID, judgeNum);

            //更新当前总
            GVAR.g_EQDBManager.UpdateCurPointsWhenScoreChanged(m_iCurMatchID, m_iCurRegisterID, 1);
            //更新累计总
            GVAR.g_EQDBManager.UpdateTotPointsWhenCurPointsChanged(m_iCurMatchID, m_iCurRegisterID);

            //触发dataentry刷新dgv
            //如果IPAD点击了确认，刷新主界面
            if (bIsValidated)
            {
                m_EventIpadMark(this, new frmIPadMark2frmDataEntryEventArgs(frmIPadMark2frmDataEntryEventType.emUpdateDgvResult, null));
            }
            m_EventIpadMark(this, new frmIPadMark2frmDataEntryEventArgs(frmIPadMark2frmDataEntryEventType.emUpdateDgvResultDetail, null));

            //自动显示下一个动作
            //MovementNextOperate();

        }

        private bool IslegalSocre(string score)
        {
            if (m_iCurMatchConfigID == 3)
            {
                if (m_GPF.Contains(score)) return true;
            }
            else
            {
                //if (m_GP.Contains(score))  return true;
                if (m_GPF.Contains(score)) return true;
            }
            return false;
        }


		/// 需要MatchInfo发送给裁判时,例如被调用SendMatchInfo时,或裁判打分后,需要将打分结果反馈发给裁判时
		/// -1 means for all judges.
		/// F_ScoreSerial F_JudgeNum F_PlayerOrder F_ScoreNum F_JudgeName F_ScoreDesc1 F_ScoreDesc2 F_ScoreValue F_ScoreResult F_ScoreStatus
		public DataTable callbackNeedMatchInfoForJudge(int iJudgeNum = -1)
		{
            //返回当前比赛，当前register的打分列表（判断是否已经接收过打分器的打分）
            if (radio_Work.Checked == true)
            {
                return GVAR.g_EQDBManager.GetIPadScoreList(m_iCurMatchID, m_iCurRegisterID, iJudgeNum);
            }
            else
            {
                return null;
            }
		}

		/// 上层负责将二进制数据发送出去
		public bool callbackSendDataToNetwork(byte[] bytes, IPEndPoint ip)
		{
			return m_netUdp.Send(bytes, ip);
		}

        //给打分器发打分列表,setMatchInfo将自动调用callbackNeedMatchInfoForJudge
        public void SendScoreList(int iMatchID, int iRegisterID, int iCurRegisterOrder, string strRegisterName, string strMatchDes1, string strMatchDes2, string strMatchDes3)
        {
            m_iCurRegisterID = iRegisterID;
            m_iCurResultRow = iCurRegisterOrder;
            m_strCurMatchTitle = strMatchDes1;
            m_strCurRegisterName = strRegisterName;
            //更新当前运动员姓名
            lb_CurrentRider.Text = strRegisterName;
            //MatchSerial格式为imatchid+'-'+iregisterid
            m_judgeMgr.setMatchInfo(Convert.ToString(iMatchID) + '-' + Convert.ToString(iRegisterID), strMatchDes1, strMatchDes2, strMatchDes3);

            DataGridView dgvMatchResultDetails = GVAR.g_EQPlugin.m_frmEQPlugin.GetDgvMatchResultDetails();
            dgvMatchResultDetails.Rows[0].Cells["F_1"].Selected = true;

            //更新当前舞步
            lb_CurrentMovement.Text = "";
            m_iCurMovement = 0;

            msgShowAndLog(strRegisterName + "started");
        }

        #endregion

        #region SendMatchInfo for Single

        private void toolStripMenuItem_SendMatchInfo_Click(object sender, EventArgs e)
        {
            if (this.dgvJudgeStatus.SelectedRows.Count < 0) return;
            DataGridViewRow CurRow = this.dgvJudgeStatus.SelectedRows[0];
            int iJudgeNum = Convert.ToInt32(CurRow.Cells["F_JudgeNum"].Value.ToString());
            m_judgeMgr.reSendMatchInfoToSelected(Convert.ToString(m_iCurMatchID) + '-' + Convert.ToString(m_iCurRegisterID), m_strCurMatchTitle, "", m_strCurRegisterName, iJudgeNum);

            DataGridView dgvMatchResultDetails = GVAR.g_EQPlugin.m_frmEQPlugin.GetDgvMatchResultDetails();
            dgvMatchResultDetails.Rows[0].Cells["F_1"].Selected = true;

            //更新当前舞步
            lb_CurrentMovement.Text = "";
            m_iCurMovement = 0;

            msgShowAndLog("Resend match info to selected register(" + m_strCurRegisterName + ") and selected judge" + iJudgeNum);

        }

        private void dgvJudgeStatus_CellMouseDown(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                if (e.RowIndex >= 0)
                {
                    //若行已是选中状态就不再进行设置
                    if (dgvJudgeStatus.Rows[e.RowIndex].Selected == false)
                    {
                        dgvJudgeStatus.ClearSelection();
                        dgvJudgeStatus.Rows[e.RowIndex].Selected = true;
                    }
                    //只选中一行时设置活动单元格，同时切换当前行
                    if (dgvJudgeStatus.SelectedRows.Count == 1)
                    {
                        dgvJudgeStatus.CurrentCell = dgvJudgeStatus.Rows[e.RowIndex].Cells[e.ColumnIndex];
                    }
                    //弹出操作菜单
                    dgvJudgeStatus.ContextMenuStrip = MenuStrip_SendMatchInfo;
                }
            }
 
        }

        #endregion

        #region Log

        private void msgShowAndLog(String str)
        {
            _msg.Items.Insert(0, DateTime.Now.ToString("HH:mm:ss: ")+str);
            _msg.SelectedIndex = 0;
            Log.WriteLog("IPadMark_Log", str);
            if (_msg.Items.Count >= 100)
                _msg.Items.Clear();

        }

        //输出OVR和打分器之间的通信记录
        //该方法使用UI线程调用
        public bool callbackOutputMsg(string msg, EmMsgType type)
        {
            //当前线程不是创建控件的线程时
            if (this.InvokeRequired)
            {
                //调用invoke来转给控件owner处理（UI线程）
                //Invoke一个匿名代理，代理实例为调用方法自己
                this.Invoke((MethodInvoker)delegate { callbackOutputMsg(msg, type); });
                return true;
            }

            msgShowAndLog(type.ToString() + ": " + msg.ToString());
            return true;
        }

        #endregion

        #region Form Close

        private void frmOVREQIPadMark_FormClosing(object sender, FormClosingEventArgs e)
        {
            //关闭服务
            if (m_oTimer != null)
            {
                m_oTimer.Dispose();
            }
            if (m_netUdp != null)
            {
                m_netUdp.Close();
            }
            ServiceManager.Stop();

        }

        private void frmOVREQIPadMark_FormClosed(object sender, FormClosedEventArgs e)
        {
            //触发窗体关闭事件
            m_EventIpadMark(this,new frmIPadMark2frmDataEntryEventArgs(frmIPadMark2frmDataEntryEventType.emfrmIPadMarkClosed,null));
        }

        #endregion

        #region Movement Change

        private void btnMovementNext_Click(object sender, EventArgs e)
        {
            MovementNextOperate();
        }

        private void MovementNextOperate()
        {
            //if (m_iCurMovement >= 0 && m_iCurMovement < m_dtMovementList.Rows.Count && GVAR.g_EQDBManager.IsValidatedMovementScore(m_iCurMatchID, m_iCurRegisterID, m_iCurMovement + 1))
            if (m_iCurMovement >= 0 && m_iCurMovement < m_dtMovementList.Rows.Count)
            {
                m_iCurMovement++;
                lb_CurrentMovement.Text = m_dtMovementList.Rows[m_iCurMovement - 1][1].ToString();

                DataGridView dgvMatchResultDetails = GVAR.g_EQPlugin.m_frmEQPlugin.GetDgvMatchResultDetails();
                dgvMatchResultDetails.Rows[0].Cells["F_" + m_iCurMovement].Selected = true;

                triggerSCBStayMovement(m_iCurMovement.ToString());

                MonitorUpdate_BackGround();
            }

        }

        private void btnMovementBack_Click(object sender, EventArgs e)
        {
            if (m_iCurMovement > 1 && m_iCurMovement <= m_dtMovementList.Rows.Count)
            {
                m_iCurMovement--;
                lb_CurrentMovement.Text = m_dtMovementList.Rows[m_iCurMovement - 1][1].ToString();

                DataGridView dgvMatchResultDetails = GVAR.g_EQPlugin.m_frmEQPlugin.GetDgvMatchResultDetails();
                dgvMatchResultDetails.Rows[0].Cells["F_" + m_iCurMovement].Selected = true;

                triggerSCBStayMovement(m_iCurMovement.ToString());

                MonitorUpdate_BackGround();
            }

        }

        #endregion

        #region Register Change

        private void btnRegisterNext_Click(object sender, EventArgs e)
        {

            DataGridView dgvMatchResults = GVAR.g_EQPlugin.m_frmEQPlugin.GetDgvMatchResults();
            if (m_iCurResultRow >= 0 && m_iCurResultRow < dgvMatchResults.Rows.Count)
            {
                m_iCurResultRow++;
                m_iCurRegisterID = GVAR.Str2Int(dgvMatchResults.Rows[m_iCurResultRow - 1].Cells["F_RegisterID"].Value.ToString());
                m_strCurRegisterName = dgvMatchResults.Rows[m_iCurResultRow - 1].Cells["RegisterName"].Value.ToString()
                    + "(" + dgvMatchResults.Rows[m_iCurResultRow - 1].Cells["F_DelegationShortName"].Value.ToString() + ")";
                lb_CurrentRider.Text = m_strCurRegisterName;

                dgvMatchResults.Rows[m_iCurResultRow-1].Selected = true;

                DataGridView dgvMatchResultDetails = GVAR.g_EQPlugin.m_frmEQPlugin.GetDgvMatchResultDetails();
                dgvMatchResultDetails.Rows[0].Cells["F_1"].Selected = true;

                //更新当前舞步
                lb_CurrentMovement.Text = "";
                m_iCurMovement = 0;

                //如果auto check，将发送当前运动员的打分列表给所有裁判
                if (chkX_ScoreListAuto.Checked)
                {
                    SendScoreList(m_iCurMatchID, m_iCurRegisterID, m_iCurResultRow, m_strCurRegisterName, m_strCurMatchTitle, "", m_strCurRegisterName);
                }
            }
        }

        private void btnRegisterBack_Click(object sender, EventArgs e)
        {
            DataGridView dgvMatchResults = GVAR.g_EQPlugin.m_frmEQPlugin.GetDgvMatchResults();
            if (m_iCurResultRow > 1 && m_iCurResultRow <= dgvMatchResults.Rows.Count)
            {
                m_iCurResultRow--;
                m_iCurRegisterID = GVAR.Str2Int(dgvMatchResults.Rows[m_iCurResultRow - 1].Cells["F_RegisterID"].Value.ToString());
                m_strCurRegisterName = dgvMatchResults.Rows[m_iCurResultRow - 1].Cells["RegisterName"].Value.ToString()
                    + "(" + dgvMatchResults.Rows[m_iCurResultRow - 1].Cells["F_DelegationShortName"].Value.ToString() + ")";
                lb_CurrentRider.Text = m_strCurRegisterName;

                dgvMatchResults.Rows[m_iCurResultRow-1].Selected = true;

                DataGridView dgvMatchResultDetails = GVAR.g_EQPlugin.m_frmEQPlugin.GetDgvMatchResultDetails();
                dgvMatchResultDetails.Rows[0].Cells["F_1"].Selected = true;

                //更新当前舞步
                lb_CurrentMovement.Text = "";
                m_iCurMovement = 0;

                //如果auto check，将发送当前运动员的打分列表给所有裁判
                if (chkX_ScoreListAuto.Checked)
                {
                    SendScoreList(m_iCurMatchID, m_iCurRegisterID, m_iCurResultRow, m_strCurRegisterName, m_strCurMatchTitle, "", m_strCurRegisterName);
                }
            }
        }

        #endregion

        #region SCB

        private void triggerSCBStayMovement(string strMid)
        {
            GVAR.g_EQPlugin.m_frmEQPlugin.TriggerAutoSports("v", "MID", strMid,MatchID, RegisterID);
            GVAR.g_EQPlugin.m_frmEQPlugin.TriggerAutoSports("stay", "DR-RunningResult-H", "", MatchID, RegisterID);
        }

        #endregion

        #region Score Monitor
        private bool NotifyMonitorStatus(bool isCon)
        {
            //当前线程不是创建控件的线程时
            if (this.InvokeRequired)
            {
                //调用invoke来转给控件owner处理（UI线程）
                //Invoke一个匿名代理，代理实例为调用方法自己
                this.Invoke((MethodInvoker)delegate { NotifyMonitorStatus(isCon); });
                return true;
            }
            if (!isCon)
                msgShowAndLog("Score Monitor is not online!");
            else
                msgShowAndLog("Score Monitor is online!");
            return true;
        }

        private void MonitorUpdate_BackGround()
        {
            //如果auto check，将发送当前运动员的打分列表给所有裁判
            if (chkX_ScoreMonitor.Checked)
            {
                updateMonitorDelegate.BeginInvoke(null,null);
            }
        }

        private void MonitorUpdate()
        {

            //同时触发裁判监控界面的显示
            ServiceReference1.BaseInfo bi = GVAR.g_EQDBManager.GetMonitorBaseInfo(m_iCurMatchID, m_iCurRegisterID, m_iCurMovement);
            DataTable jt = GVAR.g_EQDBManager.GetMonitorJudgeList(m_iCurMatchID);
            jt.TableName = "JudgeTable";
            DataTable st = GVAR.g_EQDBManager.GetMonitorScoreList(m_iCurMatchID, m_iCurRegisterID);
            st.TableName = "ScoreTable";
            ServiceManager.SendBaseInfoTableToMonitor(bi);
            ServiceManager.SendJudgeTableToMonitor(jt);
            ServiceManager.SendScoreTableToMonitor(st);

        }
        #endregion

        private void dgvJudgeStatus_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }


    }
    #endregion

    #region 与主窗口的消息通信

    //消息类型枚举
    public enum frmIPadMark2frmDataEntryEventType
    {
        emUnknown = -1,

        //frmIpadMark关闭
        emfrmIPadMarkClosed,

        // 更新dgvresultdetail 
        emUpdateDgvResultDetail,

        // 更新dgvresult 
        emUpdateDgvResult
    }
    //封装消息
    public class frmIPadMark2frmDataEntryEventArgs : EventArgs
    {
        private frmIPadMark2frmDataEntryEventType m_emType;
        private object m_oArgs;

        public frmIPadMark2frmDataEntryEventArgs(frmIPadMark2frmDataEntryEventType emType, object oArgs)
        {
            this.m_emType = emType;
            this.m_oArgs = oArgs;
        }

        public frmIPadMark2frmDataEntryEventType Type
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
    //定义IpadMark窗体消息的委托
    public delegate void frmIpadMark2frmDataEntryEventHandler(object sender, frmIPadMark2frmDataEntryEventArgs args);


    #endregion
}
