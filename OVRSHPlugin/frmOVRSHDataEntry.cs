using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using System.Net;
using System.Net.Sockets;
using System.IO;
using System.Threading;

namespace AutoSports.OVRSHPlugin
{
    public partial class frmOVRSHDataEntry : DevComponents.DotNetBar.Office2007Form
    {
        bool bTcpIsConnect = false;

        TcpClient tc;
        Thread recThread;

        int iHeaderCount = 6;
        int m_nCurMatchID = -1;
        int m_nShotCount = 0;
        int m_nRemarkIndex = 0;
        int m_nCurRow = 0;

        public string m_strEventCode = "";
        public string m_strPhaseCode = "";
        public string m_strMatchCode = "";
        public int m_nMatchStatusID = -1;

        public string m_multiIpAddress = "224.8.8.8";
        public int m_multiIpPort = 5100;
        public string m_strODFPath = "";

        private OVRSHPlugin m_oPlugin;

        public OVRSHPlugin Plugin
        {
            set { m_oPlugin = value; }
        }

        public frmOVRSHDataEntry()
        {
            InitializeComponent();
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgv_List);
        }

        public void OnMsgFlushSelMatch(Int32 iWndMode, Int32 iMatchID)
        {
            m_nCurRow = 0;
            m_nCurMatchID = iMatchID;

            GetCommonCode();
            GetShotCount();

            InitMatchResult(m_nCurMatchID);
            UpdateUIMatchInfo();

            dgv_List.Columns[4].Frozen = true;

            if (m_oPlugin != null)
            {
                m_oPlugin.SetReportContext("MatchID", m_nCurMatchID.ToString());
            }

            ShowManualInputControls();
        }

        private void ShowManualInputControls()
        {
            if (m_strPhaseCode == "1")
            {
                btnUpdate.Visible = false;
                textFp.Visible = false;
                textInx.Visible = false;
                textSeries.Visible = false;
                textScore.Visible = false;
                textRelay.Visible = false;
                labelInx.Visible = false;
                labelSeries.Visible = false;
                labelScore.Visible = false;
                labelPF.Visible = false;
                labelRelay.Visible = false;
            }
            else
            {
                btnUpdate.Visible = true;
                btnUpdate.Visible = true;
                textFp.Visible = true;
                textInx.Visible = true;
                textSeries.Visible = true;
                textScore.Visible = true;
                textRelay.Visible = true;
                labelInx.Visible = true;
                labelSeries.Visible = true;
                labelScore.Visible = true;
                labelPF.Visible = true;
                labelRelay.Visible = true;
            }
        }

        public void QueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;
            switch (args.Name)
            {
                case "MatchID":
                    args.Value = m_nCurMatchID.ToString();
                    args.Handled = true;
                    break;
                default:
                    break;
            }
        }

        private void InitMatchResult(int iMatchID)
        {
            try
            {
                string strSQL = string.Format("exec Proc_SH_GetMatchResult {0} ", iMatchID);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }

                SqlDataReader sdr = SqlCommand.ExecuteReader();
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgv_List, sdr, "Remark");
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            int iColumn = dgv_List.Columns.Count;

            if (iColumn <= 0)
            {
                return;
            }


            for (int i = 0; i < iColumn; i++)
            {
                dgv_List.Columns[i].ReadOnly = true;
                dgv_List.Columns[i].HeaderCell.Style.BackColor = Color.AliceBlue;
                if (dgv_List.Columns[i].HeaderText == "Soff" || dgv_List.Columns[i].HeaderText == "CB")
                {
                    dgv_List.Columns[i].ReadOnly = false;
                }
            }


            dgv_List.Columns[0].Width = 30;
            dgv_List.Columns[0].Visible = false;
            dgv_List.Columns[1].Width = 30;
            dgv_List.Columns[2].Width = 40;

            if (iColumn >= (iHeaderCount + m_nShotCount))
            {
                    for (int i = iHeaderCount; i < iHeaderCount + m_nShotCount; i++)
                    {
                        dgv_List.Columns[i].ReadOnly = false;
                        dgv_List.Columns[i].HeaderCell.Style.BackColor = Color.Yellow;
                        dgv_List.Columns[i].SortMode = DataGridViewColumnSortMode.NotSortable;
                        dgv_List.Columns[i].Width = 40;
                    }
                }

                dgv_List.Columns["Remark"].HeaderCell.Style.BackColor = Color.Yellow;
                dgv_List.Columns["Remark"].ReadOnly = false;
                m_nRemarkIndex = dgv_List.Columns["Remark"].Index;

            // Add DNS,DSQ,.. Combobox
            DGVCustomComboBoxColumn TypeCmbCol = (DGVCustomComboBoxColumn)dgv_List.Columns["Remark"];
            if (TypeCmbCol != null)
            {
                DataTable TypeCmbContent = new DataTable();
                TypeCmbContent.Columns.Add();
                TypeCmbContent.Rows.Add("");
                TypeCmbContent.Rows.Add("DNS");
                TypeCmbContent.Rows.Add("DSQ");
                TypeCmbContent.Rows.Add("DNF");
                TypeCmbCol.FillComboBoxItems(TypeCmbContent, 0, 0);
            }

            UpdateMatchStatus();
        }

        public void UpdateUIMatchInfo()
        {
            try
            {
                string strSQL = string.Format("exec Proc_Report_SH_GetReportHeaderInfo {0} ", m_nCurMatchID);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }

                SqlDataReader reader = SqlCommand.ExecuteReader();
                while (reader.Read())
                {
                    label_EventName.Text = reader[3].ToString();
                    label_PhaseName.Text = reader[4].ToString();
                }
                reader.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        public void GetShotCount()
        {
            try
            {
                string strSQL = string.Format("SELECT DBO.Func_SH_GetShotCount({0})", m_nCurMatchID);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }
                SqlDataReader reader = SqlCommand.ExecuteReader();
                while (reader.Read())
                {
                    m_nShotCount = SHCommon.Str2Int(reader[0]);
                }
                reader.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

        }

        public void GetCommonCode()
        {
            try
            {
                string strSQL = string.Format("SELECT Phase_Code, Event_Code, Match_Code FROM dbo.Func_SH_GetEventCommonCodeInfo({0})", m_nCurMatchID);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }
                SqlDataReader reader = SqlCommand.ExecuteReader();
                while (reader.Read())
                {
                    m_strPhaseCode = reader[0].ToString();
                    m_strEventCode = reader[1].ToString();
                    m_strMatchCode = reader[2].ToString();
                }
                reader.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

        }

        private void UpdateIRM(int iRegisterID, string strIRM)
        {
            try
            {
                string strSQL = string.Format("exec Proc_SH_UpdateIRM {0}, {1}, '{2}' ", m_nCurMatchID, iRegisterID, strIRM);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }

                SqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateOneShot(int iRegisterID, int iShotType, int iShotIndex, int iShotValue)
        {
            if (!ValidateInputData(iShotValue))
            {
                return;
            }

            try
            {
                string strSQL = string.Format("exec Proc_SH_Add_One_Shot {0}, {1}, {2}, {3}, {4}", m_nCurMatchID, iRegisterID, iShotType, iShotIndex, iShotValue);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }

                SqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }


        private bool PlayerScoreIsExit(int iRegisterID, int iShotIndex)
        {
            bool bret = false;
            try
            {
                string strSQL = string.Format("EXEC Proc_PlayerScoreIsExist {0},{1},{2} ", m_nCurMatchID, iRegisterID, iShotIndex);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }

                SqlDataReader reader = SqlCommand.ExecuteReader();

                while (reader.Read())
                {
                    if(reader[0].ToString() != "")
                    {
                        bret = true;
                    }
                }
                reader.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return bret;
        }
        
        private bool ValidateInputData(int iShotValue)
        {
            if (iShotValue == -1)
            {
                return true;
            }

            if (m_strPhaseCode == "1")
            {
                if (iShotValue >= 0 && iShotValue < 1100)
                {
                    return true;
                }
            }

            else
            {
                if (iShotValue >= 0 && iShotValue <= 2000)
                {
                    return true;
                }

            }

            MessageBox.Show("Input Value is NOT valid");

            return false;
        }

        private void UpdateRecord(int iRegisterID)
        {
            try
            {
                string strSQL = string.Format("exec Proc_SH_SetRecord {0}, {1} ", m_nCurMatchID, iRegisterID);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }

                SqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            string strRegisterID = "-1";
            string strShotValue = "";
            int iShotType = 10;//not use
            int iShotIndex = e.ColumnIndex - iHeaderCount + 1;

            if (dgv_List.Rows[e.RowIndex].Cells["REG_ID"].Value != null)
                strRegisterID = dgv_List.Rows[e.RowIndex].Cells["REG_ID"].Value.ToString();

            if (dgv_List.Rows[e.RowIndex].Cells[e.ColumnIndex].Value != null)
                strShotValue = dgv_List.Rows[e.RowIndex].Cells[e.ColumnIndex].Value.ToString();

            if (e.ColumnIndex >= iHeaderCount && e.ColumnIndex < iHeaderCount + m_nShotCount)
            {
                if (strShotValue == "")
                {
                    UpdateOneShot(SHCommon.Str2Int(strRegisterID), iShotType, iShotIndex, -1);
                }
                else
                {
                    int iScore = -1;
                    if (m_strPhaseCode == "1")
                    {
                        iScore = (int)(10 * SHCommon.Str2Double(strShotValue));
                    }
                    else
                    {
                        iScore = (int)(10 * SHCommon.Str2Double(strShotValue));
                    }
                    UpdateOneShot(SHCommon.Str2Int(strRegisterID), iShotType, iShotIndex, iScore);
                }
            }

            if (dgv_List.Columns[e.ColumnIndex].HeaderText == "Soff")
            {
                int iOffScore = -1;

                if (dgv_List.Rows[e.RowIndex].Cells["Soff"].Value != null)
                {
                    string strOffvalue = dgv_List.Rows[e.RowIndex].Cells["Soff"].Value.ToString();
                    if (strOffvalue != "")
                    {
                        iOffScore = (int)(10 * SHCommon.Str2Double(strOffvalue));
                    }
                }

                UpdateOneShot(SHCommon.Str2Int(strRegisterID), 30, 1, iOffScore);

            }

            if (dgv_List.Columns[e.ColumnIndex].HeaderText == "CB")
            {
                int iOffScore = -1;

                if (dgv_List.Rows[e.RowIndex].Cells["CB"].Value != null)
                {
                    string strOffvalue = dgv_List.Rows[e.RowIndex].Cells["CB"].Value.ToString();
                    if (strOffvalue != "")
                    {
                        iOffScore = (int)(10 * SHCommon.Str2Double(strOffvalue));
                    }
                }

                UpdateOneShot(SHCommon.Str2Int(strRegisterID), 20, 1, iOffScore);

            }

            if (e.ColumnIndex == m_nRemarkIndex)
            {
                if (SHCommon.Str2Int(strRegisterID) > 0)
                {
                    UpdateIRM(SHCommon.Str2Int(strRegisterID), strShotValue);
                }
            }

            UpdateRecord(SHCommon.Str2Int(strRegisterID));

            ShowMatchResult();

            m_oPlugin.DataChangedNotify(OVRDataChangedType.emSplitResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);

        }

        private void ShowMatchResult()
        {
            try
            {
                string strSQL = string.Format("exec Proc_SH_GetMatchResult {0} ", m_nCurMatchID);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }

                SqlDataReader reader = SqlCommand.ExecuteReader();
                int iRow = 0;
                while (reader.Read())
                {
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        dgv_List.Rows[iRow].Cells[i].Value = reader[i].ToString();
                    }

                    iRow++;
                }
                reader.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            UpdateMatchStatus();
        }

        public bool UpdateMatchStatus(int nMatchID, int nMatchStatusID)
        {
            Int32 nChangeStatusResult = 0;

            nChangeStatusResult = OVRDataBaseUtils.ChangeMatchStatus(
                nMatchID, nMatchStatusID,
                SHCommon.g_DataBaseCon, m_oPlugin);

            if (nChangeStatusResult == 1)
            {
                UpdateMatchStatus();
                return true;
            }
            else
                return false;
        }

        private int GetMatchStatusID()
        {
            int iStatus = -1;
            try
            {
                string strSQL = string.Format("SELECT F_MatchStatusID FROM TS_Match WHERE F_MatchID = {0}", m_nCurMatchID);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }
                SqlDataReader reader = SqlCommand.ExecuteReader();
                while (reader.Read())
                {
                    iStatus = SHCommon.Str2Int(reader[0]);
                }
                reader.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return iStatus;
        }

        private void setStartTimeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            frmInputTime oneForm = new frmInputTime();
            if (oneForm.ShowDialog() == DialogResult.Cancel)
                return;

            string stime = oneForm.strInputTime;

            foreach (DataGridViewRow i in dgv_List.SelectedRows)
            {
                string strBib = i.Cells[2].Value.ToString();
                UpdateMatchStartTime(strBib, stime);
            }

            ShowMatchResult();
        }

        private void UpdateMatchStartTime(string strBib, string stime)
        {
            try
            {
                string strSQL = string.Format("exec Proc_SH_SetMatchStartTime {0},'{1}','{2}' ", m_nCurMatchID, strBib, stime);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }

                SqlDataReader reader = SqlCommand.ExecuteReader();
                reader.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateMatchStatus()
        {
            m_nMatchStatusID = GetMatchStatusID();

            switch (m_nMatchStatusID)
            {
                case 30:
                    this.btnX_StatusSetting.Text = this.buttonItem_Scheduled.Text;
                    break;
                case 40:
                    this.btnX_StatusSetting.Text = this.buttonItem_StartList.Text;
                    break;
                case 50:
                    this.btnX_StatusSetting.Text = this.buttonItem_Running.Text;
                    break;
                case 60:
                    this.btnX_StatusSetting.Text = this.buttonItem_Suspend.Text;
                    break;
                case 100:
                    this.btnX_StatusSetting.Text = this.buttonItem_Unofficial.Text;
                    break;
                case 110:
                    this.btnX_StatusSetting.Text = this.buttonItem_Finished.Text;
                    break;
                case 120:
                    this.btnX_StatusSetting.Text = this.buttonItem_Revision.Text;
                    break;
                case 130:
                    this.btnX_StatusSetting.Text = this.buttonItem_Canceled.Text;
                    break;
                default:
                    this.btnX_StatusSetting.Text = LocalizationRecourceManager.GetString(m_oPlugin.GetSectionName(), "OVRSHPlugin_OVRSGDataEntryForm_btnX_StatusSetting");
                    break;
            }
        }

        private void buttonItem_Scheduled_Click(object sender, EventArgs e)
        {
            m_nMatchStatusID = 30;
            bool bStatus = UpdateMatchStatus(m_nCurMatchID, m_nMatchStatusID);
        }

        private void buttonItem_StartList_Click(object sender, EventArgs e)
        {
            m_nMatchStatusID = 40;
            bool bStatus = UpdateMatchStatus(m_nCurMatchID, m_nMatchStatusID);
        }

        private void buttonItem_Running_Click(object sender, EventArgs e)
        {
            m_nMatchStatusID = 50;
            bool bStatus = UpdateMatchStatus(m_nCurMatchID, m_nMatchStatusID);
        }

        private void buttonItem_Suspend_Click(object sender, EventArgs e)
        {
            m_nMatchStatusID = 60;
            bool bStatus = UpdateMatchStatus(m_nCurMatchID, m_nMatchStatusID);
        }

        private void buttonItem_Unofficial_Click(object sender, EventArgs e)
        {
            m_nMatchStatusID = 100;
            bool bStatus = UpdateMatchStatus(m_nCurMatchID, m_nMatchStatusID);
        }

        private void buttonItem_Finished_Click(object sender, EventArgs e)
        {
            m_nMatchStatusID = 110;
            bool bStatus = UpdateMatchStatus(m_nCurMatchID, m_nMatchStatusID);
            AutoProcessMatch();
        }

        private void buttonItem_Revision_Click(object sender, EventArgs e)
        {
            m_nMatchStatusID = 120;
            bool bStatus = UpdateMatchStatus(m_nCurMatchID, m_nMatchStatusID);
        }

        private void buttonItem_Canceled_Click(object sender, EventArgs e)
        {
            m_nMatchStatusID = 130;
            bool bStatus = UpdateMatchStatus(m_nCurMatchID, m_nMatchStatusID);
        }

        private void AutoProcessMatch()
        {
            try
            {
                string strSQL = string.Format("exec Proc_SH_AutoProcessToFinal {0}", m_nCurMatchID);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }

                SqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void btnImportCSV_Click(object sender, EventArgs e)
        {
            DataSourceForm dataForm = new DataSourceForm();
            if (dataForm.ShowDialog() != DialogResult.OK)
                return;

            m_multiIpAddress = dataForm.m_strIP;
            m_multiIpPort = int.Parse(dataForm.m_strPort);
            m_strODFPath = dataForm.m_strPath;

            if (!backgroundWorker_udp.IsBusy)
            {
                backgroundWorker_udp.RunWorkerAsync();
            }
        }

        private void btnImportCSV_Click_tcp()
        {
            DataSourceForm dataForm = new DataSourceForm();
            if (dataForm.ShowDialog() != DialogResult.OK)
                return;
            
            string strIp = dataForm.m_strIP;
            string strPort = dataForm.m_strPort;
            string strPath = dataForm.m_strPath;

            if (strIp == string.Empty || strPort == string.Empty || strPath == string.Empty)
                return;


            try
            {
                tc = new TcpClient();
                tc.Connect(new IPEndPoint(IPAddress.Parse(strIp), Int32.Parse(strPort)));
                bTcpIsConnect = tc.Connected;
                if(bTcpIsConnect)
                {
                    MessageBox.Show("Connected Successfully");
                }
            }

            catch (Exception ex)
            {
                MessageBox.Show(ex.StackTrace, ex.Message, MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            recThread = new Thread(new ThreadStart(ThreadReceive));
            recThread.Start();

        }

        private void ThreadReceive()
        {

            while (bTcpIsConnect)
            {
                Byte[] data = new Byte[1024];
                NetworkStream ns = tc.GetStream();
                int irec = ns.Read(data, 0, data.Length);
                string strMessage = System.Text.Encoding.ASCII.GetString(data, 0, irec);
                int iBegin = strMessage.IndexOf('_');
                int iEnd = strMessage.IndexOf("\r\n", iBegin + 1);
                string[] strMessageArray = strMessage.Split('_');
                foreach (string strOneMessage in strMessageArray)
                {
                    string[] strSplit = strOneMessage.Split(';');
                    if (strSplit.Length > 15)
                    {
                        string strFlag = strSplit[0];
                        string strBib = strSplit[3];
                        string strShotOwn = strSplit[7];
                        string strShotAttribute = strSplit[9];
                        string strPirmaryScore = strSplit[10];
                        string strSecondScore = strSplit[11];
                        string strLogicTargetIndex = strSplit[12];
                        string strShotNumber = strSplit[13];
                        string strCroodinateX = strSplit[14];
                        string strCroodinateY = strSplit[15];

                        if (strFlag == "SHOT")
                        {
                            int iRegisterID = GetRegisterIDByBib(strBib);
                            int iShotIndex = SHCommon.Str2Int(strShotNumber);

                            int iShotAttr = SHCommon.Str2Int(strShotAttribute);

                            if (strFlag == "SHOT" && iRegisterID > 0
                                && iShotIndex <= m_nShotCount
                                && m_strEventCode != "25R"
                                && strShotOwn == "3"
                                && (iShotAttr & 0x0020) == 0)
                            {
                                if (strPirmaryScore == "")
                                {
                                    UpdateOneShot(iRegisterID, 10, iShotIndex, -1);
                                }
                                else
                                {
                                    int iScore = (int)SHCommon.Str2Int(strPirmaryScore);

                                    UpdateOneShot(iRegisterID, 10, iShotIndex, iScore);
                                }

                                UpdateRecord(iRegisterID);
                                ShowMatchResult();

                                m_oPlugin.DataChangedNotify(OVRDataChangedType.emSplitResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);

                            }

                        }


                    }

                }
            }
            
 
        }

        private int GetRegisterIDByBib(string strBib)
        {

            int iRegister = -1;
            try
            {
                string strSQL = string.Format("select F_RegisterID FROM TS_Match_Result AS M LEFT JOIN TR_Register AS R ON M.F_RegisterID = R.F_RegisterID WHERE M.F_MatchID = {0} AND R.F_Bib = {1} "
                , m_nCurMatchID, strBib);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }

                SqlDataReader reader = SqlCommand.ExecuteReader();
                while (reader.Read())
                {
                    string strRegisterID = reader[0].ToString();
                    iRegister = SHCommon.Str2Int(strRegisterID);
                }
                reader.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }


            return iRegister;
        }

        private int GetRegisterIDByFP(string strRelay, string strFP)
        {
            int iRegisterID = -1;

            int iFP = SHCommon.Str2Int(strFP);
            if(iFP<=0)
            {
                MessageBox.Show("Invalid FirePoint");
                return iRegisterID;
            }

            int iRelay = SHCommon.Str2Int(strRelay);
            if (iRelay <= 0)
            {
                MessageBox.Show("Invalid Relay");
                return iRegisterID;
            }

            try
            {
                string strSQL = string.Format("select F_RegisterID FROM TS_Match_Result WHERE F_MatchID = {0} AND F_CompetitionPositionDes1 = {1} AND F_CompetitionPositionDes2 = {1}", m_nCurMatchID, iRelay, iFP);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }

                SqlDataReader reader = SqlCommand.ExecuteReader();
                while (reader.Read())
                {
                    string strRegisterid = reader[0].ToString();
                    iRegisterID = SHCommon.Str2Int(strRegisterid);
                }
                reader.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }


            return iRegisterID;
        }


        private void btnUpdate_Click(object sender, EventArgs e)
        {
            if (m_strPhaseCode == "1")
            {
                MessageBox.Show("Final Match can't be put here ");
                return;
            }

            if (textSeries.Text == "" || textFp.Text == "" || textRelay.Text == "")
            {
                MessageBox.Show("ShotIndex Valid ");
                return;
            }

            int iRegisterid = GetRegisterIDByFP(textRelay.Text, textFp.Text);
            if (iRegisterid <= 0)
            {
                return;
            }

            int iShotIndex = SHCommon.Str2Int(textSeries.Text);
            if(iShotIndex > m_nShotCount)
            {
                MessageBox.Show("ShotIndex Valid ");
                return;
            }

            int iShotTypeNormal = 10;//正常成绩
            int iShotTypeInx = 20;//内10环成绩

            int iquestion = 6;
            if (PlayerScoreIsExit(iRegisterid, iShotIndex))
            {
                DialogResult r1 = MessageBox.Show("Data already exit, override it ?", "Input information", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                iquestion = (int)r1;
            }

            if (iquestion != 6)
            {
                return;
            }

            int iShotValue = -1;
            int iInxValue = -1;

            if (textScore.Text != "")
            {
                iShotValue = SHCommon.Str2Int(textScore.Text);
            }
            if (textInx.Text != "")
            {
                iInxValue = SHCommon.Str2Int(textInx.Text);
            }

            UpdateOneShot(iRegisterid, iShotTypeNormal, iShotIndex, iShotValue);
            UpdateOneShot(iRegisterid, iShotTypeInx, iShotIndex, iInxValue);
            UpdateRecord(iRegisterid);
            ShowMatchResult();

            m_oPlugin.DataChangedNotify(OVRDataChangedType.emSplitResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);


            textFp.Focus();
        }

 
        private void textFP_MouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left && (bool)textFp.Tag == true)
            {
                textFp.SelectAll();
            }
            textFp.Tag = false;
        }

        private void textFP_GotFocus(object sender, EventArgs e)
        {
            textFp.Tag = true;    
            textFp.SelectAll();  
        }

        private void textSeries_MouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left && (bool)textSeries.Tag == true)
            {
                textSeries.SelectAll();
            }
            textSeries.Tag = false;
        }

        private void textSeries_GotFocus(object sender, EventArgs e)
        {
            textSeries.Tag = true;    
            textSeries.SelectAll();  
        }
        private void textScore_MouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left && (bool)textScore.Tag == true)
            {
                textScore.SelectAll();
            }
            textScore.Tag = false;
        }

        private void textScore_GotFocus(object sender, EventArgs e)
        {
            textScore.Tag = true;    
            textScore.SelectAll();  
        }
        private void textInx_MouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left && (bool)textInx.Tag == true)
            {
                textInx.SelectAll();
            }
            textInx.Tag = false;
        }

        private void textInx_GotFocus(object sender, EventArgs e)
        {
            textInx.Tag = true;   
            textInx.SelectAll();   
        }

        private void textFp_TextChanged(object sender, EventArgs e)
        {
            if (textFp.Text == "")
                return;

            int iRegisterID = GetRegisterIDByFP(textRelay.Text, textFp.Text);
            for(int i=0; i<dgv_List.RowCount; i++)
            {
                string regid = string.Empty;
                if (dgv_List.Rows[i].Cells[0].Value != null)
                {
                    regid = dgv_List.Rows[i].Cells[0].Value.ToString();
                    if (SHCommon.Str2Int(regid) == iRegisterID)
                    {
                        dgv_List.Rows[i].Selected = true;
                        m_nCurRow = i;
                    }
                    else
                    {
                        dgv_List.Rows[i].Selected = false;
                    }
                }
            }

        }

        private void textSeries_TextChanged(object sender, EventArgs e)
        {
            if(textSeries.Text == "")
            {
                return;
            }

            string strShotValue = textScore.Text;
            int iShotIndex = SHCommon.Str2Int(textSeries.Text);
            if (iShotIndex > m_nShotCount)
            {
                MessageBox.Show("ShotIndex Valid ");
                return;
            }

            int icol = SHCommon.Str2Int(textSeries.Text) + iHeaderCount -1;
            Color oldColor = dgv_List.Rows[0].Cells[0].Style.SelectionBackColor;
            for (int i = 0; i < dgv_List.Rows[m_nCurRow].Cells.Count; i++)
            {
                dgv_List.Rows[m_nCurRow].Cells[i].Style.SelectionBackColor = oldColor;
            }
            dgv_List.Rows[m_nCurRow].Cells[icol].Style.SelectionBackColor = Color.Red;
        }

        private void CellClick(object sender, DataGridViewCellEventArgs e)
        {
            Color oldColor = dgv_List.Rows[0].Cells[0].Style.SelectionBackColor;
            for (int i = 0; i < dgv_List.Rows[m_nCurRow].Cells.Count; i++)
            {
                dgv_List.Rows[m_nCurRow].Cells[i].Style.SelectionBackColor = oldColor;
            }

        }

        private void backgroundWorker_udp_DoWork(object sender, DoWorkEventArgs e)
        {
            UdpClient client = new UdpClient(m_multiIpPort);
            IPAddress multicastIP = IPAddress.Parse(m_multiIpAddress);
            try
            {
                client.JoinMulticastGroup(multicastIP, 10);
            }
            catch (SocketException me)
            {
                MessageBox.Show(me.Message);
            }
            while (true)
            {
                IPEndPoint RemoteIpEndPoint = new IPEndPoint(multicastIP, 0);
                try
                {
                    Byte[] receiveBytes = client.Receive(ref RemoteIpEndPoint);
                    if (this.InvokeRequired)
                    {
                        UpdateScoreHandler del = new UpdateScoreHandler(UpdateScore);
                        this.Invoke(del, receiveBytes);
                    }
                }
                catch (System.Net.Sockets.SocketException ske)
                {
                    break;
                }
                catch (System.Exception ex)
                {
                    MessageBox.Show(ex.Message);
                    break;
                }
            }
        }

        private delegate void UpdateScoreHandler(byte[] buf);
        private void UpdateScore(byte[] buf)
        {
            string receivedText = ASCIIEncoding.UTF8.GetString(buf);
            string strFile = m_strODFPath + @"\" + receivedText;
            ParseOdfFile(strFile);
        }

        private void ParseOdfFile(string strFile)
        {
            try
            {
                string strSQL = string.Format("exec [Proc_SH_ImportResult_FromOdf] {0}, '{1}' ", m_nCurMatchID, strFile);

                SqlCommand SqlCommand = new SqlCommand();
                SqlCommand.Connection = SHCommon.g_DataBaseCon;
                SqlCommand.CommandText = strSQL;

                if (SHCommon.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
                {
                    SHCommon.g_DataBaseCon.Open();
                }

                SqlCommand.ExecuteNonQuery();

                m_oPlugin.DataChangedNotify(OVRDataChangedType.emSplitResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);

            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

        }



    }
        
 }




