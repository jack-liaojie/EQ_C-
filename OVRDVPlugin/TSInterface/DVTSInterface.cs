using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.IO.Ports;
using AutoSports.OVRCommon;
using System.IO;

namespace OVRDVPlugin.TSInterface
{
    public partial class DVTSInterface : Office2007Form
    {
        private DVSerialDataManager m_manager;
        private int m_iMatchID;
        public const string DV_TS_DATA = "DV_TS_DATA";
        private string m_tsDataSaveDir = "";
        public event Action<bool> ConnectionChanged;
        public event Action OnTSUpdateDB;
        public DVTSInterface()
        {
            InitializeComponent();
            cmbPorts.DataSource = SerialPortConfig.GetPortNames();
            cmbDataBaud.DataSource = SerialPortConfig.GetBaudRate();
            cmbDataBaud.SelectedIndex = 5;
            cmbDataBits.DataSource = SerialPortConfig.GetDataBits();
            cmbDataBits.SelectedIndex = 2;
            cmbParity.DataSource = SerialPortConfig.GetParity();
            cmbStopBits.DataSource = SerialPortConfig.GetStopBits();
            cmbStopBits.SelectedIndex = 1;
            OVRDataBaseUtils.SetDataGridViewStyle(dgJudgeScore);
            OVRDataBaseUtils.SetDataGridViewStyle(dgRankList);
            dgJudgeScore.SelectionMode = DataGridViewSelectionMode.CellSelect;
            //dgRankList.SelectionMode = DataGridViewSelectionMode.CellSelect;
            m_tsDataSaveDir = Path.Combine(DVCommon.GetAppRootDir(), DV_TS_DATA);
            if (!Directory.Exists(m_tsDataSaveDir))
            {
                Directory.CreateDirectory(m_tsDataSaveDir);
            }
        }

        ~DVTSInterface()
        {
            if (m_manager != null)
            {
                m_manager.StopReceiver();
            }

        }

        public void m_manager_OnRecvData(TransmitStatus status, TSMatchInfo matchInfo)
        {
            Action<TransmitStatus, TSMatchInfo> action = (arg1, arg2) => this.UpdateUIFromOtherThread(arg1, arg2);
            this.Invoke(action, status, matchInfo);
        }

        private void UpdateUIFromOtherThread(TransmitStatus status, TSMatchInfo matchInfo)
        {
            if (status == TransmitStatus.StartList || status == TransmitStatus.RankList)
            {
                lbHeight.Text = matchInfo.StartInfo.Height;
                lbStartBib.Text = matchInfo.StartInfo.BibNumber;
                lbStartDiff.Text = matchInfo.StartInfo.Difficulty;
                lbStartDiveCode.Text = matchInfo.StartInfo.DiveCode;
                lbStartName.Text = matchInfo.StartInfo.PlayerName;
                lbStartRound.Text = matchInfo.StartInfo.RoundNumber;
                lbStartNO.Text = matchInfo.StartInfo.StartNumber;
                lbStartNOC.Text = matchInfo.StartInfo.NOC;
                lbStartPoints.Text = matchInfo.StartInfo.Points;
                lbStartRank.Text = matchInfo.StartInfo.Rank;
            }
            else if (status == TransmitStatus.Score)
            {
                OVRDataBaseUtils.FillDataGridView(dgJudgeScore, matchInfo.ScoreInfo);
                dgJudgeScore.ClearSelection();
            }
            if (status == TransmitStatus.RankList)
            {
                OVRDataBaseUtils.FillDataGridView(dgRankList, matchInfo.RankInfo);
                dgRankList.ClearSelection();
            }

            TSDlg_OnTSUpdateDB();
        }

        private void TSDlg_OnTSUpdateDB()
        {
            if (OnTSUpdateDB != null)
            {
                OnTSUpdateDB();
            }
        }

        public void SetMatchID(int matchID)
        {
            m_iMatchID = matchID;
            if (matchID <= 0)
            {
                this.Text = "DVTSInterface - No Match";
            }
            else
            {
                this.Text = "DVTSInterface - " + matchID.ToString();
            }

            if (m_manager != null)
            {
                m_manager.MatchID = matchID;
            }
        }

        private void DVTSInterface_Load(object sender, EventArgs e)
        {
        }

        private void btnOpen_Click(object sender, EventArgs e)
        {
            if (m_manager != null && m_manager.IsOpened)
            {
                m_manager.StopReceiver();
                btnOpen.Text = "Connect";
                PortCmbEnabled(true);
                if (ConnectionChanged != null)
                {
                    ConnectionChanged(false);
                }
                return;
            }
            int baudRate = Convert.ToInt32(cmbDataBaud.Text);
            int dataBits = Convert.ToInt32(cmbDataBits.Text);
            Parity parity = (Parity)Enum.Parse(typeof(Parity), cmbParity.Text);
            StopBits stopBits = (StopBits)Enum.Parse(typeof(StopBits), cmbStopBits.Text);
            if (m_manager == null)
            {
                m_manager = new DVSerialDataManager(cmbPorts.Text, baudRate, parity, dataBits, stopBits);
                m_manager.OnRecvData += new Action<TransmitStatus, TSMatchInfo>(m_manager_OnRecvData);
                m_manager.OnReportUpdateDBInfo += new Action<string, bool>(m_manager_OnReportUpdateDBInfo);
                m_manager.MatchID = m_iMatchID;
            }
            else
            {
                if (!m_manager.ModifyParam(cmbPorts.Text, baudRate, dataBits, parity, stopBits))
                {
                    MessageBoxEx.Show(m_manager.LastErrorMessage);
                    return;
                }
            }
            if (!m_manager.StartReceiver())
            {
                MessageBoxEx.Show(m_manager.LastErrorMessage);
                return;
            }
            else
            {
                PortCmbEnabled(false);
                btnOpen.Text = "Disconnect";
                if (ConnectionChanged != null)
                {
                    ConnectionChanged(true);
                }
            }
        }

        private void m_manager_OnReportUpdateDBInfo(string strInfo, bool bSucceed)
        {
            Action<string, bool> action = (p1, p2) => this.AddInfoToFileMonitor(p1, p2);
            this.Invoke(action, strInfo, bSucceed);
        }

        private void PortCmbEnabled(bool bEnabled)
        {
            cmbPorts.Enabled = bEnabled;
            cmbDataBaud.Enabled = bEnabled;
            cmbDataBits.Enabled = bEnabled;
            cmbParity.Enabled = bEnabled;
            cmbStopBits.Enabled = bEnabled;
        }

        private void DVTSInterface_FormClosing(object sender, FormClosingEventArgs e)
        {
            e.Cancel = true;
            this.Visible = false;
        }

        private void btnViewFile(object sender, EventArgs e)
        {
            if (m_iMatchID <= 0)
            {
                MessageBoxEx.Show("The match is not setted!");
                return;
            }
            string filePath = Path.Combine(m_tsDataSaveDir, string.Format("MatchData_{0}.txt", m_iMatchID));
            if (!File.Exists(filePath))
            {
                MessageBoxEx.Show("The TS data file of this match is not exist!");
                return;
            }
            DVCommon.OpenWithNotepad(filePath);
        }

        private void btnOpenFolder_Click(object sender, EventArgs e)
        {
            DVCommon.OpenFolderInExplorer(m_tsDataSaveDir);
        }

        public void AddInfoToFileMonitor(string strInfo, bool bNormal)
        {
            if (richTBFile.Lines.Length > 120)
            {
                richTBFile.Clear();
            }
            richTBFile.AppendText("\n");
            if (bNormal)
            {
                richTBFile.SelectionColor = Color.Black;
            }
            else
            {
                richTBFile.SelectionColor = Color.Red;
            }

            richTBFile.AppendText(strInfo);

            richTBFile.SelectionStart = richTBFile.MaxLength;
            richTBFile.SelectionLength = 0;
            richTBFile.ScrollToCaret();
        }

        private void btnClearMonitor_Click(object sender, EventArgs e)
        {
            richTBFile.Clear();
        }
    }
}
