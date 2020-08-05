using System;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Threading;
using System.Net;
using System.IO;
using System.Net.Sockets;

namespace AutoSports.OVRWRPlugin
{
    public partial class OVRWRDataEntryForm : Office2007Form
    {
        #region Fields

        OVRWRMatch_Individual m_nMatch_Individual = new OVRWRMatch_Individual();

        private int m_nAddTime;

        bool m_nSplitInitial = false;

        private Thread m_nThread1;
        UdpClient m_nUdpClient1;

        private Thread myThread2;
        public delegate void ProcessDelegate(string str);
        ProcessDelegate showProcess;

        int m_nCurrentMatch;//1---下场比赛   2---本场比赛

        #endregion

        #region Constructor

        public OVRWRDataEntryForm()
        {
            InitializeComponent();

            showProcess = new ProcessDelegate(SetStringConst);
        }

        #endregion

        #region Message

        public void OnMsgFlushSelMatch(int nWndMode, int nMatchID)
        {
            try
            {
                if (nMatchID <= 0)
                {
                    MessageBoxEx.Show("Please select a match!");
                    return;
                }
             
                 if (GVAR.g_matchID ==nMatchID)
                {

                }
                 else
                 {
                     if (GVAR.g_matchID != 0)
                     {
                         MessageBoxEx.Show("please exit the current match");
                         return;
                     }
                     
                 }

                GVAR.g_matchID = nMatchID;
                btnExitMatch.Enabled = true;
                gp_MatchResult.Enabled = true;
                gp_MatchSplitResult.Enabled = true;
               // btnGetSplitNo.Text = "";
                btnStatusSplit.Text = "";
                m_nAddTime = 0;

                m_nMatch_Individual.StatusID = m_nMatch_Individual.GetMatchStatus(0);
                UpdateMatchStatus();

                m_nMatch_Individual.GetMatchResultPoints();
                UpdateControlFromDataBase();

                m_nMatch_Individual.GetMatch_IRMandHantei();
                refresh_cbxMatchHanteiAndIRMcode();

                m_nMatch_Individual.GetMatchDecisonCode();

                m_nMatch_Individual.GetMatchClassidicationPoints();
                refreshClassidicationPointsControl();

                m_nMatch_Individual.DecisionCode = "";

                if (GVAR.g_ManageDB.GetMatchCourtNumber(nMatchID) > 0)
                    this.cbx_Court.SelectedIndex = GVAR.g_ManageDB.GetMatchCourtNumber(nMatchID) - 1;

                if (!GVAR.g_ManageDB.IsHaveData(nMatchID))
                    GVAR.g_ManageDB.CreateMatchSplit(nMatchID, 1, 3, 0);

                this.lblTitle.Text = GVAR.g_ManageDB.GetDataEntryTitle(nMatchID);

                string[] NOCName_Red=GVAR.g_ManageDB.GetPlayerNoc(nMatchID, 1).Split('-');
                string[] NOCName_Blue = GVAR.g_ManageDB.GetPlayerNoc(nMatchID, 2).Split('-');

                this.lbl_RedNoc.Text = NOCName_Red[0];
                this.lbl_BlueNoc.Text= NOCName_Blue[0];

                if (NOCName_Blue.Length > 1)
                {
                    this.lbl_BlueNoc1.Text = NOCName_Blue[1];
                }
                else
                {
                    this.lbl_BlueNoc1.Text = "";
                }
                if (NOCName_Red.Length > 1)
                {
                    this.lbl_RedNoc1.Text = NOCName_Red[1];
                }
                else
                {
                    lbl_RedNoc1.Text = "";
                }
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }           
        }

        private void refreshClassidicationPointsControl()
        { 
            this.cmbDecision.SelectedValue = m_nMatch_Individual.DecisionCode;
            tb_ClassidicationPoints_Red.Text = m_nMatch_Individual.ClassidicationPoints_Red.ToString();
            tb_ClassidicationPoints_Blue.Text = m_nMatch_Individual.ClassidicationPoints_Blue.ToString();
        }

        private void OVRWRDataEntryForm_Load(object sender, EventArgs e)
        {
            try
            {
                InitCmbDecision();
                InitCmbIRM();

                m_nThread1 = new Thread(new ThreadStart(ReceiveData));
                m_nThread1.IsBackground = true;
                m_nThread1.Start();

                myThread2 = new Thread(new ThreadStart(GetStringConst));
                myThread2.IsBackground = true;
                myThread2.Start();


                this.cbx_Court.SelectedIndex = 0;
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
          
        }


        private void GetStringConst()
        {
            if (ConfigurationManager.GetPluginSettingString(GVAR.g_strDisplnCode, "FilePath") == "")
            {

                SetStringConst(@"C:\Seag2011Wrestling\");
            }
            else
            {
                SetStringConst(ConfigurationManager.GetPluginSettingString(GVAR.g_strDisplnCode, "FilePath"));
            }
        }

        private void SetStringConst(string str)
        {
            if (tbPath.InvokeRequired)
            {

                this.Invoke(showProcess, str);
            }
            else
            {
                tbPath.Text = str;
            }
        }

        private void ReceiveData()
        {
            IPEndPoint remote = null;
            m_nUdpClient1 = new UdpClient(8081);
            while(true)
            {
                try
                {
                    byte[] bytes = m_nUdpClient1.Receive(ref remote);
                    string strMessage = Encoding.Default.GetString(bytes);

                    Log.WriteLog("WR", strMessage);

                    GetDataFillDataBase(strMessage);

                    GVAR.g_WRPlugin.DataChangedNotify(OVRCommon.OVRDataChangedType.emMatchResult, -1, -1, -1, GVAR.g_matchID, GVAR.g_matchID, null);

                }
                catch (System.Exception ex)
                {
                    Log.WriteLog("WR_Error", ex.Message);
                }
                
            }
        }

        private void GetDataFillDataBase(string str)
        {
            try
            {
                string strStart = "Liaoning2013WR";

                if (!str.StartsWith(strStart)) return;

                string[] strSplit = str.Substring(strStart.Length).Split(',');


                string strMatchNo = strSplit[1];
                int redScore = GVAR.Str2Int(strSplit[9]);
                int blueScore = GVAR.Str2Int(strSplit[10]);

                int setNo = GVAR.Str2Int(strSplit[8]);


                if (GVAR.g_ManageDB.GetMatchSplitStatus(strMatchNo, setNo) ==110) return;

                int currentPointsRed = GVAR.g_ManageDB.GetMatchSplitPoints(strMatchNo, setNo, 1);

                int currentPointsBlue = GVAR.g_ManageDB.GetMatchSplitPoints(strMatchNo, setNo, 2);

                //if(redScore>currentPointsRed)
                GVAR.g_ManageDB.WR_TS_UpdateDatabase(strMatchNo, setNo, 1, redScore);

                //if(blueScore>currentPointsBlue)
                GVAR.g_ManageDB.WR_TS_UpdateDatabase(strMatchNo, setNo, 2, blueScore);

            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }

        }

        #endregion

        #region Status Event

        private void btn_Status_Click(object sender, EventArgs e)
        {
            try
            {
                if (sender == btn_StartList)
                    m_nMatch_Individual.StatusID = GVAR.STATUS_STARTLIST;
                else if (sender == btn_Schedule)
                    m_nMatch_Individual.StatusID = GVAR.STATUS_SCHEDULE;
                else if (sender == btn_Running)
                {
                    m_nCurrentMatch = 2;

                    GenerateDataForJin();

                    m_nMatch_Individual.StatusID = GVAR.STATUS_RUNNING;
                }
                else if (sender == btn_Suspend)
                    m_nMatch_Individual.StatusID = GVAR.STATUS_SUSPEND;
                else if (sender == btn_Unofficial)
                {
                    m_nMatch_Individual.StatusID = GVAR.STATUS_UNOFFICIAL;

                    m_nMatch_Individual.Decision();
                    m_nMatch_Individual.UpdateMatchDecisionCode();
                    m_nMatch_Individual.UpdateMatchClassidicationPoints();
                    refreshClassidicationPointsControl();
                    
                    m_nMatch_Individual.UpdateMatchResultandRank();

                    m_nCurrentMatch = 1;

                    GenerateDataForJin();
                }
                else if (sender == btn_Official)
                    m_nMatch_Individual.StatusID = GVAR.STATUS_OFFICIAL;
                else if (sender == btn_Revision)
                    m_nMatch_Individual.StatusID = GVAR.STATUS_REVISION;

                if (GVAR.g_ManageDB.SetMatchStatus(GVAR.g_matchID, m_nMatch_Individual.StatusID))
                {
                    UpdateMatchStatus();

                    if (m_nMatch_Individual.StatusID == GVAR.STATUS_UNOFFICIAL || m_nMatch_Individual.StatusID == GVAR.STATUS_OFFICIAL)
                    {
                        GVAR.g_ManageDB.AutoProgressMatch(GVAR.g_matchID);

                        GVAR.g_ManageDB.GetDataForTS_StartList_JinLing(GVAR.g_matchID, tbPath.Text,cbx_Court.Text);
                    }

                    /////////////////////////插入实时成绩代码////////////////

                    GVAR.g_WRPlugin.DataChangedNotify(OVRCommon.OVRDataChangedType.emMatchStatus, -1, -1, -1, GVAR.g_matchID, GVAR.g_matchID, null);
                    /////////////////////////////////////////////////
                }
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
           
        }

        private void GenerateDataForJin()
        {
            try
            {
                if (cbx_Court.Text == "") return;
                string fileName = this.tbPath.Text.Trim() + cbx_Court.Text + ".txt";

                string strMessage = GVAR.g_ManageDB.GetDataForJimLing(GVAR.g_matchID, m_nCurrentMatch);
                FileStream fs = new FileStream(fileName, FileMode.Create);
                byte[] data = new UTF8Encoding().GetBytes(strMessage);
                fs.Write(data, 0, data.Length);
                fs.Flush();
                fs.Close();
            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
            finally
            {
                
            }
        }

        private void btnGenerateData_Click(object sender, EventArgs e)
        {
            if (GVAR.g_matchID > 0 && !string.IsNullOrWhiteSpace(tbPath.Text))
                GVAR.g_ManageDB.GetDataForTS_StartList_JinLing(GVAR.g_matchID, tbPath.Text,cbx_Court.Text);
        }

        private void UpdateMatchStatus()
        {
            InitialStatusButton();

            switch (m_nMatch_Individual.StatusID)
            {
                case GVAR.STATUS_SCHEDULE:
                    {

                        btn_StartList.Enabled = true;
                        btn_StartList.Checked = true;
                        btnStatus.Text = btn_Schedule.Text;

                        break;
                    }
                case GVAR.STATUS_STARTLIST:
                    {
                        btn_Running.Enabled = true;
                        btn_Running.Checked = true;
                        btnStatus.Text = btn_StartList.Text;

                        break;
                    }
                case GVAR.STATUS_RUNNING:
                    {
                        btn_Suspend.Enabled = true;
                        btn_Suspend.Checked = true;

                        btn_Unofficial.Enabled=true;
                        btn_Unofficial.Checked = true;

                        btnStatus.Text = btn_Running.Text;

                        break;
                    }
                case GVAR.STATUS_SUSPEND:
                    {
                        btn_Running.Enabled = true;
                        btn_Running.Checked = true;
                        btnStatus.Text = btn_Suspend.Text;

                        break;
                    }
                case GVAR.STATUS_UNOFFICIAL:
                    {
                        btn_Official.Enabled = true;
                        btn_Official.Checked = true;

                        btn_Revision.Checked = true;
                        btn_Revision.Enabled = true;

                        btnStatus.Text = btn_Unofficial.Text;

                        break;
                    }
                case GVAR.STATUS_OFFICIAL:
                    {
                        btn_Revision.Enabled = true;
                        btn_Revision.Checked = true;
                        btnStatus.Text = btn_Official.Text;

                        break;
                    }
                case GVAR.STATUS_REVISION:
                    {
                        btn_Official.Enabled = true;
                        btn_Official.Checked = true;
                        btn_Unofficial.Enabled = true;
                        btn_Unofficial.Checked = true;

                        btnStatus.Text = btn_Revision.Text;

                        break;
                    }
                default:
                    return;
            }
        }

        private void InitialStatusButton()
        {
            btnStatus.Text = "";

            btn_StartList.Checked = false;
            btn_Schedule.Checked = false;
            btn_Running.Checked = false;
            btn_Unofficial.Checked = false;
            btn_Official.Checked = false;
            btn_Revision.Checked = false;
            btn_Suspend.Checked = false;

            btn_StartList.Enabled = false;
            btn_Schedule.Enabled = false;
            btn_Running.Enabled = false;
            btn_Unofficial.Enabled = false;
            btn_Official.Enabled = false;
            btn_Revision.Enabled = false;
            btn_Suspend.Enabled = false;
        }

        private void btn_StatusSplit_Click(object sender, EventArgs e)
        {
            try
            {
                if (sender == btn_StatusSplit_StartList)
                    m_nMatch_Individual.StatusIDSplit1st = GVAR.STATUS_STARTLIST;
                else if (sender == btn_StatusSplit_Running)
                    m_nMatch_Individual.StatusIDSplit1st = GVAR.STATUS_RUNNING;
                else if (sender == btn_StatusSplit_Official)
                    m_nMatch_Individual.StatusIDSplit1st = GVAR.STATUS_OFFICIAL;
                else if (sender == btn_StatusSplit_Revision)
                    m_nMatch_Individual.StatusIDSplit1st = GVAR.STATUS_REVISION;

                UpdateSplitStatus();

                if (m_nMatch_Individual.StatusIDSplit1st == GVAR.STATUS_OFFICIAL)
                {
                    //m_nMatch_Individual.Decision_MatchSplit();
                    //m_nMatch_Individual.UpateMatchSplitResultAndWinsets();
                    UpdateControlFromDataBase();
                }

            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
           
        }

        private void UpdateSplitStatus()
        {
            InitialStatusSplitButton();
            switch (m_nMatch_Individual.StatusIDSplit1st)
            {
                case GVAR.STATUS_STARTLIST:
                    {
                        btnStatusSplit.Text = btn_StatusSplit_StartList.Text;
                        btn_StatusSplit_Running.Enabled = true;
                        btn_StatusSplit_Running.Checked = true;
                        break;
                    }
                case GVAR.STATUS_RUNNING:
                    {
                        btnStatusSplit.Text = btn_StatusSplit_Running.Text;
                        btn_StatusSplit_Official.Enabled = true;
                        btn_StatusSplit_Official.Checked = true;
                        break;
                    }
                case GVAR.STATUS_OFFICIAL:
                    {
                        btn_StatusSplit_Revision.Checked = true;
                        btn_StatusSplit_Revision.Enabled = true;

                        btnStatusSplit.Text = btn_StatusSplit_Official.Text;
                        break;
                    }
                case GVAR.STATUS_REVISION:
                    {
                        btnStatusSplit.Text = btn_StatusSplit_Revision.Text;

                        btn_StatusSplit_Official.Enabled = true;
                        btn_StatusSplit_Official.Checked = true;
                        break;
                    }
                default:
                    break;
            }
            if (m_nSplitInitial)
                m_nSplitInitial = false;
            else
            m_nMatch_Individual.UpdateSplitStatusAndDecisionCode();
        }

        private void InitialStatusSplitButton()
        {
            btnStatusSplit.Text = "";

            btn_StatusSplit_StartList.Checked = false;

            btn_StatusSplit_Running.Checked = false;

            btn_StatusSplit_Official.Checked = false;
            btn_StatusSplit_Revision.Checked = false;

            btn_StatusSplit_StartList.Enabled = false;
            btn_StatusSplit_Running.Enabled = false;
            btn_StatusSplit_Official.Enabled = false;
            btn_StatusSplit_Revision.Enabled = false;
        }

        #endregion

        #region Add Referee

        private void btn_AddJudge_Click(object sender, EventArgs e)
        {
            if (GVAR.g_matchID > 0)
            {
                frmOVRWRMatchJudgeConfig OVRSPMatchJudgeConfig = new frmOVRWRMatchJudgeConfig();
                OVRSPMatchJudgeConfig.MatchID = GVAR.g_matchID;
                OVRSPMatchJudgeConfig.ShowDialog();
            }
        }

        #endregion

        #region GetSplitNo.

        private void btn_GetSplitNo(object sender, EventArgs e)
        {
            //try
            //{
            //    if (sender == btn_Split1)
            //    {
            //        GVAR.g_matchSplitID = 1;
            //        btnGetSplitNo.Text = btn_Split1.Text;

            //        lbl_Split1.BackColor = Color.Yellow;
            //        lbl_Split2.BackColor = Color.LawnGreen;
            //        lbl_Split3.BackColor = Color.LawnGreen;
            //    }
            //    else if (sender == btn_Split2)
            //    {
            //        GVAR.g_matchSplitID = 2;
            //        btnGetSplitNo.Text = btn_Split2.Text;

            //        lbl_Split1.BackColor = Color.LawnGreen;
            //        lbl_Split2.BackColor = Color.Yellow;
            //        lbl_Split3.BackColor = Color.LawnGreen;
            //    }
            //    else if (sender == btn_Split3)
            //    {
            //        GVAR.g_matchSplitID = 3;
            //        btnGetSplitNo.Text = btn_Split3.Text;

            //        lbl_Split1.BackColor = Color.LawnGreen;
            //        lbl_Split2.BackColor = Color.LawnGreen;
            //        lbl_Split3.BackColor = Color.Yellow;
            //    }

            //    if (GVAR.g_matchSplitID > 0 && GVAR.g_matchSplitID < 4)
            //    {
            //        m_nSplitInitial = true;
            //        m_nMatch_Individual.GetSplitDecisionCodeAndSplitStatus();
            //        refreshSplitStatusAndDecision();
            //        refresh_cbxHanteiSplit();
            //    }

            //}
            //catch (System.Exception ex)
            //{
            	
            //}
            
        }

        #endregion  

        #region Score Function

        private void AddScoreBlue(int number)
        {
            try
            {
                if (GVAR.g_matchSplitID == 1)
                {
                    if (m_nAddTime == 0)
                        m_nMatch_Individual.PointsSplit1st_Blue += number;
                    else if(m_nAddTime==1) 
                        m_nMatch_Individual.PointsSplit1st_AddTime_Blue += number;

                    m_nMatch_Individual.PointsTotal_Blue += number;
                }
                else if (GVAR.g_matchSplitID == 2)
                {
                    if (m_nAddTime == 0)
                        m_nMatch_Individual.PointsSplit2nd_Blue += number;
                    else if (m_nAddTime == 1)
                        m_nMatch_Individual.PointsSplit2nd_AddTime_Blue += number;

                    m_nMatch_Individual.PointsTotal_Blue += number;
                }
                else if (GVAR.g_matchSplitID == 3)
                {
                    if (m_nAddTime == 0)
                        m_nMatch_Individual.PointsSplit3rd_Blue += number;
                    else if (m_nAddTime == 1)
                        m_nMatch_Individual.PointsSplit3rd_AddTime_Blue += number;

                    m_nMatch_Individual.PointsTotal_Blue += number;
                }

                m_nMatch_Individual.UpdateMatchResultPoints();
                GVAR.g_WRPlugin.DataChangedNotify(OVRCommon.OVRDataChangedType.emMatchStatus, -1, -1, -1, GVAR.g_matchID, GVAR.g_matchID, null);
                GVAR.g_WRPlugin.DataChangedNotify(OVRCommon.OVRDataChangedType.emMatchResult, -1, -1, -1, GVAR.g_matchID, GVAR.g_matchID, null);

                //m_nMatch_Individual.GetMatchResultPoints();
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
            
        }

        private void  AddScoreRed(int number)
        {
            try
            {
                if (GVAR.g_matchSplitID == 1)
                {
                    if (m_nAddTime == 0)
                        m_nMatch_Individual.PointsSplit1st_Red += number;
                    else if (m_nAddTime == 1)
                        m_nMatch_Individual.PointsSplit1st_AddTime_Red += number;

                    m_nMatch_Individual.PointsTotal_Red += number;
                }
                else if (GVAR.g_matchSplitID == 2)
                {
                    if(m_nAddTime==0)
                    m_nMatch_Individual.PointsSplit2nd_Red += number;
                    else if(m_nAddTime==1)
                    m_nMatch_Individual.PointsSplit2nd_AddTime_Red += number;

                    m_nMatch_Individual.PointsTotal_Red += number;
                }
                else if (GVAR.g_matchSplitID == 3)
                {
                    if (m_nAddTime == 0)
                        m_nMatch_Individual.PointsSplit3rd_Red += number;
                    else if (m_nAddTime == 1)
                        m_nMatch_Individual.PointsSplit3rd_AddTime_Red += number;
                    m_nMatch_Individual.PointsTotal_Red += number;
                }

                m_nMatch_Individual.UpdateMatchResultPoints();
                GVAR.g_WRPlugin.DataChangedNotify(OVRCommon.OVRDataChangedType.emMatchStatus, -1, -1, -1, GVAR.g_matchID, GVAR.g_matchID, null);
                GVAR.g_WRPlugin.DataChangedNotify(OVRCommon.OVRDataChangedType.emMatchResult, -1, -1, -1, GVAR.g_matchID, GVAR.g_matchID, null);
               // m_nMatch_Individual.GetMatchResultPoints();
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
           
        }

        private void btnAdd_Red_Click(object sender, EventArgs e)
        {
            try
            {
                if (GVAR.g_matchSplitID < 1 && GVAR.g_matchSplitID > 3)
                {
                    MessageBox.Show("please select a manche");
                    return;
                }

                if (m_nMatch_Individual.StatusIDSplit1st == GVAR.STATUS_OFFICIAL)
                {
                    MessageBox.Show("please change the manche status");
                    return;
                }

                if (sender == btnAdd_Red_1)
                {
                    AddScoreRed(1);
                }
                else if (sender == btnAdd_Red_2)
                {
                    AddScoreRed(2);
                }
                else if (sender == btnAdd_Red_3)
                {
                    AddScoreRed(3);
                }
                else if (sender == btnAdd_Red5)
                {
                    AddScoreRed(5);
                }

                UpdateControlFromDataBase();
            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
        }

        private void btnAdd_Blue_Click(object sender, EventArgs e)
        {
            try
            {
                if (GVAR.g_matchSplitID < 1 && GVAR.g_matchSplitID > 3)
                {
                    MessageBox.Show("please select a manche");
                    return;
                }

                if (m_nMatch_Individual.StatusIDSplit1st == GVAR.STATUS_OFFICIAL)
                {
                    MessageBox.Show("please change the manche status");
                    return;
                }

                if (sender == btnAdd_Blue_1)
                {
                    AddScoreBlue(1);
                }
                else if (sender == btnAdd_Blue_2)
                {
                    AddScoreBlue(2);
                }
                else if (sender == btnAdd_Blue_3)
                {
                    AddScoreBlue(3);
                }
                else if (sender == btnAdd_Blue_5)
                {
                    AddScoreBlue(5);
                }

                UpdateControlFromDataBase();
            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
        }

        private void btn_Sub_Red_Click(object sender, EventArgs e)
        {
            
            try
            {
                if (GVAR.g_matchSplitID < 1 && GVAR.g_matchSplitID > 3)
                {
                    MessageBox.Show("please select a manche");
                    return;
                }

                if (m_nMatch_Individual.StatusIDSplit1st == GVAR.STATUS_OFFICIAL)
                {
                    MessageBox.Show("please change the manche status");
                    return;
                }

                if (GVAR.g_matchSplitID == 1)
                {
                    if (m_nAddTime == 0)
                    {
                        if (m_nMatch_Individual.PointsSplit1st_Red < 1)
                            return;
                    }
                    else if (m_nMatch_Individual.PointsSplit1st_AddTime_Red < 1) 
                        return;
                    

                    AddScoreRed(-1);
                }
                else if (GVAR.g_matchSplitID == 2)
                {
                    if (m_nAddTime == 0)
                    {
                        if (m_nMatch_Individual.PointsSplit2nd_Red < 1)
                            return;
                    }
                    else if (m_nMatch_Individual.PointsSplit2nd_AddTime_Red < 1) return;

                    AddScoreRed(-1);
                }
                else if (GVAR.g_matchSplitID == 3)
                {
                    if (m_nAddTime == 0)
                    {
                        if (m_nMatch_Individual.PointsSplit3rd_Red < 1)
                            return;
                    }
                    else if (m_nMatch_Individual.PointsSplit3rd_AddTime_Red < 1) return;

                    AddScoreRed(-1);
                }

                UpdateControlFromDataBase();
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
            
        }

        private void btn_Sub_Blue_Click(object sender, EventArgs e)
        {
            try
            {
                if (GVAR.g_matchSplitID < 1 && GVAR.g_matchSplitID > 3)
                {
                    MessageBox.Show("please select a manche");
                    return;
                }

                if (m_nMatch_Individual.StatusIDSplit1st == GVAR.STATUS_OFFICIAL)
                {
                    MessageBox.Show("please change the manche status");
                    return;
                }

                if (GVAR.g_matchSplitID == 1)
                {
                    if (m_nAddTime == 0)
                    {
                        if (m_nMatch_Individual.PointsSplit1st_Blue < 1)
                            return;
                    }
                    else if (m_nMatch_Individual.PointsSplit1st_AddTime_Blue < 1) return;

                    AddScoreBlue(-1);
                }
                else if (GVAR.g_matchSplitID == 2)
                {
                    if (m_nAddTime == 0)
                    {
                        if (m_nMatch_Individual.PointsSplit2nd_Blue < 1)
                            return;
                    }
                    else if (m_nMatch_Individual.PointsSplit2nd_AddTime_Blue < 1) return;


                    AddScoreBlue(-1);
                }
                else if (GVAR.g_matchSplitID == 3)
                {
                    if (m_nAddTime == 0)
                    {
                        if (m_nMatch_Individual.PointsSplit3rd_Blue < 1)
                            return;
                    }
                    else if (m_nMatch_Individual.PointsSplit3rd_AddTime_Blue < 1) return;

                    AddScoreBlue(-1);
                }

                UpdateControlFromDataBase();
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
           
        }

        #endregion

        #region InitialMatchResult

        private void UpdateControlFromDataBase()
        {
            try
            {
                this.tb_PointsBlue_1.Text = m_nMatch_Individual.PointsSplit1st_Blue.ToString();
                this.tb_PointsBlue_Addtime_1.Text = m_nMatch_Individual.PointsSplit1st_AddTime_Blue.ToString();
                this.tb_PointsBlue_2.Text = m_nMatch_Individual.PointsSplit2nd_Blue.ToString();
                this.tb_PointsBlue_Addtime_2.Text = m_nMatch_Individual.PointsSplit2nd_AddTime_Blue.ToString();
                this.tb_PointsBlue_3.Text = m_nMatch_Individual.PointsSplit3rd_Blue.ToString();
                this.tb_PointsBlue_Addtime_3.Text = m_nMatch_Individual.PointsSplit3rd_AddTime_Blue.ToString();
                this.tb_PointsBlue_Total.Text = m_nMatch_Individual.PointsTotal_Blue.ToString();

                this.tb_PointsRed_1.Text = m_nMatch_Individual.PointsSplit1st_Red.ToString();
                this.tb_PointsRed_Addtime_1.Text = m_nMatch_Individual.PointsSplit1st_AddTime_Red.ToString();
                this.tb_PointsRed_2.Text = m_nMatch_Individual.PointsSplit2nd_Red.ToString();
                this.tb_PointsRed_Addtime_2.Text = m_nMatch_Individual.PointsSplit2nd_AddTime_Red.ToString();
                this.tb_PointsRed_3.Text = m_nMatch_Individual.PointsSplit3rd_Red.ToString();
                this.tb_PointsRed_Addtime_3.Text = m_nMatch_Individual.PointsSplit3rd_AddTime_Red.ToString();
                this.tb_PointsRed_Total.Text = m_nMatch_Individual.PointsTotal_Red.ToString();

                this.tb_PointsRed_WinNum.Text = m_nMatch_Individual.Winset_A.ToString();
                this.tb_PointsBlue_WinNum.Text = m_nMatch_Individual.Winset_B.ToString();
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
           
        }

        private void refreshSplitStatusAndDecision()
        {
            UpdateSplitStatus();
            //this.cmbDecision.SelectedValue = m_nMatch_Individual.DecisionCodeSplit1st;
            
        }

        private void  InitMatchResult()
        {
            try
            {
                m_nMatch_Individual.PointsSplit1st_Blue = 0;
                m_nMatch_Individual.PointsSplit1st_AddTime_Blue = 0;
                m_nMatch_Individual.PointsSplit2nd_Blue = 0;
                m_nMatch_Individual.PointsSplit2nd_AddTime_Blue = 0;
                m_nMatch_Individual.PointsSplit3rd_Blue = 0;
                m_nMatch_Individual.PointsSplit3rd_AddTime_Blue = 0;
                m_nMatch_Individual.PointsTotal_Blue = 0;

                m_nMatch_Individual.PointsSplit1st_Red = 0;
                m_nMatch_Individual.PointsSplit1st_AddTime_Red = 0;
                m_nMatch_Individual.PointsSplit2nd_Red = 0;
                m_nMatch_Individual.PointsSplit2nd_AddTime_Red = 0;
                m_nMatch_Individual.PointsSplit3rd_Red = 0;
                m_nMatch_Individual.PointsSplit3rd_AddTime_Red = 0;
                m_nMatch_Individual.PointsTotal_Red = 0;
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
          
        }
       
        private void InitialMatch()
        {
            GVAR.g_matchSplitID = 0;
            GVAR.g_matchID = 0;
            m_nAddTime = 0;

        }

        #endregion

        #region InitialCmbDecision

        private void InitCmbIRM()
        {
            GVAR.g_ManageDB.FillIRMList(cbxIRM_A as System.Windows.Forms.ComboBox);
            GVAR.g_ManageDB.FillIRMList(cbxIRM_B as System.Windows.Forms.ComboBox);
        }

        private void InitCmbDecision()
        {
            GVAR.g_ManageDB.FillDecisionList(cmbDecision as System.Windows.Forms.ComboBox);
        }

        private void cmbDecision_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cmbDecision.SelectedIndex != -1)
            {
                m_nMatch_Individual.DecisionCode = cmbDecision.SelectedValue.ToString();
                //m_nMatch_Individual.UpdateSplitStatusAndDecisionCode();
                m_nMatch_Individual.UpdateMatchDecisionCode();
            }

        }
        #endregion

        #region Weigh

        private void btn_Weigh_Click(object sender, EventArgs e)
        {
            Weight weight = new Weight();
            weight.ShowDialog();
        }

        #endregion

        #region Exit button

        private void btnExitMatch_Click(object sender, EventArgs e)
        {
            InitialMatch();
            this.cmbDecision.SelectedIndex = -1;
            this.cbxIRM_A.SelectedIndex = -1;
            this.cbxIRM_B.SelectedIndex = -1;

            this.cbx_Hantei_A.Checked = false;
            this.cbx_Hantei_B.Checked = false;

            //this.btnGetSplitNo.Text = "";

            this.gp_MatchResult.Enabled = false;
            this.gp_MatchSplitResult.Enabled = false;

            this.btnStatus.Text = "";

            this.tb_PointsBlue_1.Text = "";
            this.tb_PointsBlue_Addtime_1.Text = "";
            this.tb_PointsBlue_Addtime_2.Text = "";
            this.tb_PointsBlue_Addtime_3.Text = "";
            this.tb_PointsBlue_2.Text = "";
            this.tb_PointsBlue_3.Text ="";
            this.tb_PointsBlue_Total.Text ="";
            this.tb_PointsRed_WinNum.Text = "";

            this.btnStatusSplit.Text = "";
           
            this.tb_PointsRed_1.Text = "";
            this.tb_PointsRed_Addtime_1.Text = "";
            this.tb_PointsRed_Addtime_2.Text = "";
            this.tb_PointsRed_Addtime_3.Text = "";
            this.tb_PointsRed_2.Text = "";
            this.tb_PointsRed_3.Text = "";
            this.tb_PointsRed_Total.Text ="";
            this.tb_PointsBlue_WinNum.Text = "";

            this.cbx_HanteiSplit_Red.Checked = false;
            this.cbx_HanteiSplit_Blue.Checked = false;

            this.lbl_Split1.BackColor = Color.LawnGreen;
            this.lbl_Split2.BackColor = Color.LawnGreen;
            this.lbl_Split3.BackColor = Color.LawnGreen;

            this.lbl_Split3_Addtime.BackColor = Color.LawnGreen;
            this.lbl_Split2_Addtime.BackColor = Color.LawnGreen;
            this.lbl_Split1_Addtime.BackColor = Color.LawnGreen;
            this.btnExitMatch.Enabled = false;

            m_nCurrentMatch = 0;
        }

        #endregion

        #region MatchSplit Hantei 设置和事件

        private void refresh_cbxHanteiSplit()
        {
            if (m_nMatch_Individual.HanteiSplit_A == 1)
            {
                cbx_HanteiSplit_Red.Checked = true;
            }
            else
            {
                cbx_HanteiSplit_Red.Checked = false;
            }

            if (m_nMatch_Individual.HanteiSplit_B == 1)
            {
                cbx_HanteiSplit_Blue.Checked = true;
            }
            else
            {
                cbx_HanteiSplit_Blue.Checked = false;
            }
        }


        private void cbx_HanteiSplit_Red_CheckedChanged(object sender, EventArgs e)
        {
            if (GVAR.g_matchSplitID > 3 || GVAR.g_matchSplitID < 1)
            {
                cbx_HanteiSplit_Red.Checked = false;
                return;
            }
            if (cbx_HanteiSplit_Red.Checked)
            {
                m_nMatch_Individual.HanteiSplit_A = 1;
                cbx_HanteiSplit_Blue.Checked = false;
            }
            else
            {
                m_nMatch_Individual.HanteiSplit_A = 0;
            }

            m_nMatch_Individual.UpdateMatchSplitHantei();

        }

        private void cbx_HanteiSplit_Blue_CheckedChanged(object sender, EventArgs e)
        {
            if (GVAR.g_matchSplitID > 3 || GVAR.g_matchSplitID < 1)
            {
                cbx_HanteiSplit_Blue.Checked = false;
                return;
            }

            if (cbx_HanteiSplit_Blue.Checked)
            {
                m_nMatch_Individual.HanteiSplit_B = 1;
                cbx_HanteiSplit_Red.Checked = false;
            }
            else
            {
                m_nMatch_Individual.HanteiSplit_B = 0;
            }

            m_nMatch_Individual.UpdateMatchSplitHantei();
        }

        #endregion

        #region Match Hantei

        private void refresh_cbxMatchHanteiAndIRMcode()
        {
            try
            {                 
                cbx_Hantei_A.Checked = m_nMatch_Individual.Hantei_A == 1 ? true : false;
                cbx_Hantei_B.Checked = m_nMatch_Individual.Hantei_B == 1 ? true : false;

                this.cbxIRM_A.SelectedValue = m_nMatch_Individual.IRMCode_Red;
                this.cbxIRM_B.SelectedValue = m_nMatch_Individual.IRMCode_Blue;
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
        }

        private void cbx_Hantei_A_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                if (cbx_Hantei_A.Checked)
                {
                    m_nMatch_Individual.Hantei_A = 1;
                    cbx_Hantei_B.Checked = false;
                }
                else
                {
                    m_nMatch_Individual.Hantei_A = 0;
                }
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
            m_nMatch_Individual.UpdateMatch_IRMandHantei();
        }

        private void cbx_Hantei_B_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                if (cbx_Hantei_B.Checked)
                {
                    m_nMatch_Individual.Hantei_B = 1;
                    cbx_Hantei_A.Checked = false;
                }
                else
                {
                    m_nMatch_Individual.Hantei_B = 0;
                }
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
            m_nMatch_Individual.UpdateMatch_IRMandHantei();

        }

        #endregion

        #region Match IRM


        private void cbxIRM_A_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (cbxIRM_A.SelectedIndex != -1)
                {
                    m_nMatch_Individual.IRMCode_Red = cbxIRM_A.SelectedValue.ToString();
                    m_nMatch_Individual.UpdateMatch_IRMandHantei();
                }
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
            
        }

        private void cbxIRM_B_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (cbxIRM_B.SelectedIndex != -1)
                {
                    m_nMatch_Individual.IRMCode_Blue = cbxIRM_B.SelectedValue.ToString();
                    m_nMatch_Individual.UpdateMatch_IRMandHantei();
                }
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
        }

        #endregion

        private void tb_ClassidicationPoints_Red_TextChanged(object sender, EventArgs e)
        {
            m_nMatch_Individual.ClassidicationPoints_Red = GVAR.Str2Int(tb_ClassidicationPoints_Red.Text);

        }

        private void tb_ClassidicationPoints_Blue_TextChanged(object sender, EventArgs e)
        {
            m_nMatch_Individual.ClassidicationPoints_Blue = GVAR.Str2Int(tb_ClassidicationPoints_Blue.Text);
        }

        private void lbl_Split_MouseDown(object sender, MouseEventArgs e)
        {
            //if (lbl_Split1.BackColor == Color.Yellow) lbl_Split1.BackColor = Color.LawnGreen;
            //else lbl_Split1.BackColor = Color.Yellow;
            if (sender == lbl_Split1)
            {
                GVAR.g_matchSplitID = 1;
                m_nAddTime = 0;
            }
            else if (sender==lbl_Split1_Addtime)
            {
                GVAR.g_matchSplitID = 1;
                m_nAddTime = 1;
            }
            else if (sender == lbl_Split2)
            {
                GVAR.g_matchSplitID = 2;
                m_nAddTime = 0;
            }
            else if (sender == lbl_Split2_Addtime)
            {
                GVAR.g_matchSplitID = 2;
                m_nAddTime = 1;
            }
            else if (sender == lbl_Split3)
            {
                GVAR.g_matchSplitID = 3;
                m_nAddTime = 0;
            }
            else if (sender == lbl_Split3_Addtime)
            {
                GVAR.g_matchSplitID = 3;
                m_nAddTime = 1;
            }

            SetLabelColor(GVAR.g_matchSplitID, m_nAddTime);

             if (GVAR.g_matchSplitID > 0 && GVAR.g_matchSplitID < 4)
             {
                 m_nSplitInitial = true;
                 m_nMatch_Individual.GetSplitDecisionCodeAndSplitStatus();
                 refreshSplitStatusAndDecision();
                 refresh_cbxHanteiSplit();
             }
        }

        private void SetLabelColor(int split, int addtime)
        {
            if (split == 1)
            {
                if (addtime == 1)
                {
                    lbl_Split1.BackColor = Color.LawnGreen;
                    lbl_Split1_Addtime.BackColor = Color.Yellow;
                    lbl_Split2.BackColor = Color.LawnGreen;
                    lbl_Split2_Addtime.BackColor = Color.LawnGreen;
                    lbl_Split3.BackColor = Color.LawnGreen;
                    lbl_Split3_Addtime.BackColor = Color.LawnGreen;
                }
                else
                {
                    lbl_Split1.BackColor = Color.Yellow;
                    lbl_Split1_Addtime.BackColor = Color.LawnGreen;
                    lbl_Split2.BackColor = Color.LawnGreen;
                    lbl_Split2_Addtime.BackColor = Color.LawnGreen;
                    lbl_Split3.BackColor = Color.LawnGreen;
                    lbl_Split3_Addtime.BackColor = Color.LawnGreen;
                }
            }
            else if (split == 2)
            {
                if (addtime == 1)
                {
                    this.lbl_Split2_Addtime.BackColor = Color.Yellow;
                    this.lbl_Split1.BackColor = this.lbl_Split1_Addtime.BackColor = this.lbl_Split2.BackColor = this.lbl_Split3.BackColor = this.lbl_Split3_Addtime.BackColor = Color.LawnGreen;
                }
                else
                {
                    this.lbl_Split2.BackColor = Color.Yellow;
                    this.lbl_Split1.BackColor = this.lbl_Split1_Addtime.BackColor = this.lbl_Split2_Addtime.BackColor = this.lbl_Split3.BackColor = this.lbl_Split3_Addtime.BackColor = Color.LawnGreen;
                }
            }
            else if (split == 3)
            {
                if (addtime == 1)
                {
                    this.lbl_Split3_Addtime.BackColor = Color.Yellow;
                    this.lbl_Split1.BackColor = this.lbl_Split1_Addtime.BackColor = this.lbl_Split2.BackColor = this.lbl_Split3.BackColor = this.lbl_Split2_Addtime.BackColor = Color.LawnGreen;
                }
                else
                {
                    this.lbl_Split3.BackColor = Color.Yellow;
                    this.lbl_Split1.BackColor = this.lbl_Split1_Addtime.BackColor = this.lbl_Split2_Addtime.BackColor = this.lbl_Split2.BackColor = this.lbl_Split3_Addtime.BackColor = Color.LawnGreen;
                }
            }

        }

        private void tb_PointsRed_Total_TextChanged(object sender, EventArgs e)
        {
            try
            {
                m_nMatch_Individual.PointsTotal_Red = GVAR.Str2Int(tb_PointsRed_Total.Text.Trim());
                m_nMatch_Individual.UpdateMatchResultPoints();
                UpdateControlFromDataBase();
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
        }

        private void tb_PointsBlue_Total_TextChanged(object sender, EventArgs e)
        {
            try
            {
                m_nMatch_Individual.PointsTotal_Blue = GVAR.Str2Int(tb_PointsBlue_Total.Text.Trim());
                m_nMatch_Individual.UpdateMatchResultPoints();
                UpdateControlFromDataBase();
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }

        }

        private void tbPath_TextChanged(object sender, EventArgs e)
        {
            if (tbPath.Text.Trim() != "" )
            {
                ConfigurationManager.SetPluginSettingString(GVAR.g_strDisplnCode, "FilePath", tbPath.Text);
            }
        }

        private void btnGenPlayers_Click(object sender, EventArgs e)
        {
            if(!string.IsNullOrWhiteSpace(tbPath.Text))
            GVAR.g_ManageDB.GetDataForTS_Players_JinLing(tbPath.Text);
        }
    }
}
