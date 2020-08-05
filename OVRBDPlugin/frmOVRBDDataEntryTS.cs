using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Xml;
using System.Collections;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using System.Text.RegularExpressions;
using System.Threading;
using System.Text.RegularExpressions;
using System.Runtime.InteropServices;
using Badminton2011;
using System.Net;
using System.Net.Sockets;
using RomoteControl;

namespace AutoSports.OVRBDPlugin
{
    //计时计分部分
    public partial class frmOVRBDDataEntry : Office2007Form
    {
        private TcpExchangeClient tcpClient_;
        private frmStateMonitor m_stateMonitor;

        private System.Windows.Forms.Timer m_heartTestTimer;
        private DateTime m_lastHeartTime;
        private TSDataExchangeTT_TCP m_exchangeTcp;
        private TSDataExchangeTT_UDP m_exchangeUdp;
        private TSDataExchangeTT_File m_exchangeFile;
        private TS_TTConfig m_tsTTconfig;
        private UdpClient m_udpClient = new UdpClient();
        private RemoteUI m_remoteUI;
   

        //导出路径选择
        private void btnxExPathSel_Click(object sender, EventArgs e)
        {
            if (folderSelDlg.ShowDialog() == DialogResult.OK)
            {
                tbExportPath.Text = folderSelDlg.SelectedPath;
                if (m_tsTTconfig != null)
                {
                    m_tsTTconfig.ExportPath = tbExportPath.Text;
                    m_tsTTconfig.SaveConfig();
                }

                if (!Directory.Exists(tbExportPath.Text))
                {
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgExportPath"));
                    return;
                }
            }
        }

        private void btnxExAthlete_Click(object sender, EventArgs e)
        {
            ExportAthleteXml();
        }

        private void btnxExSchedule_Click(object sender, EventArgs e)
        {
            ExportScheduleXml();
        }

        private void btnxImPathSel_Click(object sender, EventArgs e)
        {
            if (folderSelDlg.ShowDialog() == DialogResult.OK)
            {
                tbImportPath.Text = folderSelDlg.SelectedPath;
                if (m_tsTTconfig != null)
                {
                    m_tsTTconfig.ImportPath = tbImportPath.Text;
                    m_tsTTconfig.SaveConfig();
                }
                if (!Directory.Exists(tbImportPath.Text))
                {
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgImportPath"));
                    return;
                }

                filewatcher.Path = tbImportPath.Text;
            }
        }

        private void btnxImMatchInfo_Click(object sender, EventArgs e)
        {
            string strImportPath = tbImportPath.Text;
            string strPort = tbTcpPort.Text == "" ? "2102" : tbTcpPort.Text;
            if (strImportPath == "")
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("Please select an import path first!");
                return;
            }
            if (m_tsTTconfig.ImportType == "1")
            {
                if (m_exchangeFile == null)
                {
                    m_exchangeFile = TSDataExchangeTT_File.GetDataExchangeTT_File(BDCommon.g_adoDataBase.strConnection, strImportPath);
                }
            }
            else
            {
                if (m_exchangeTcp == null)
                {
                    m_exchangeTcp = TSDataExchangeTT_TCP.GetDataExchangeTT_TCP(BDCommon.g_adoDataBase.strConnection, Convert.ToInt32(strPort));
                }
            }
            frmImportMatchInfo frm = new frmImportMatchInfo(strImportPath, XmlTypeEnum.XmlTypeMatchInfo);
            frm.ShowDialog();

        }

        private void btnxImAction_Click(object sender, EventArgs e)
        {
            if (tbImportPath.Text == "")
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("The path is not exist!");
                tbImportPath.Clear();
                return;
            }
            string strImportPath = tbImportPath.Text;
            string strPort = tbTcpPort.Text == "" ? "2102" : tbTcpPort.Text;
            if (strImportPath == "")
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("Please select an import path first!");
                return;
            }
            if (m_tsTTconfig.ImportType == "1")
            {
                if (m_exchangeFile == null)
                {
                    m_exchangeFile = TSDataExchangeTT_File.GetDataExchangeTT_File(BDCommon.g_adoDataBase.strConnection, strImportPath);
                }
            }
            else
            {
                if (m_exchangeTcp == null)
                {
                    m_exchangeTcp = TSDataExchangeTT_TCP.GetDataExchangeTT_TCP(BDCommon.g_adoDataBase.strConnection, Convert.ToInt32(strPort));
                }
            }
            frmImportMatchInfo frm = new frmImportMatchInfo(strImportPath, XmlTypeEnum.XmlTypeAcitonListSingle);
            frm.ShowDialog();

        }

        private void chkOuterData_CheckedChanged(object sender, EventArgs e)
        {
            if (chkOuterData.Checked == true)
            {
                EnableExportImport(true);
                InitDateList();
                if (m_tsTTconfig != null)
                {
                    tbExportPath.Text = m_tsTTconfig.ExportPath;
                    tbImportPath.Text = m_tsTTconfig.ImportPath;
                    tbTcpPort.Text = m_tsTTconfig.TcpPort;
                    if (m_tsTTconfig.ImportType == "2")
                    {
                        tbImportPath.Text = TSDataExchangeTT_Service.TS_DATA_BACKUP_PATH;
                    }
                }

            }
            else
            {
                EnableExportImport(false);
            }
        }

        public void AddInfoToFileBox(string info, bool bNormalMsg = true)
        {
            m_stateMonitor.AddInfoToFileMonitor(info, bNormalMsg);
        }

        public void RecvHeartMsg()
        {
            m_lastHeartTime = DateTime.Now;
            string info = string.Format("{0:D2}:{1:D2}:{2:D2} Heartbeat!", m_lastHeartTime.Hour, m_lastHeartTime.Minute, m_lastHeartTime.Second);
            AddInfoToHeartBox(info, true);
        }

        public void AddInfoToHeartBox(string strInfo, bool bNormalMsg = true)
        {
            m_stateMonitor.AddInfoToHeartMonitor(strInfo, bNormalMsg);
        }

        public void AddOrRemoveClient(string strClient, bool bAdd)
        {
            int pos = strClient.IndexOf("(");
            string strIp = "";
            if (pos != -1)
            {
                strIp = strClient.Substring(0, pos);
            }
            else
            {
                strIp = strClient;
            }

            if (bAdd)
            {
             //   lstboxClients.Items.Add(strClient);
                bool bFound = false;

                //先查找是否存在该IP的客户端
                foreach (string s in lstboxClients.Items)
                {
                    if (s.Contains(strIp))
                    {
                        bFound = true;
                        if (s != strClient)//存在且不等则更新
                        {
                            lstboxClients.Items.Remove(s);
                            lstboxClients.Items.Add(strClient);
                        }
                        break;
                    }
                }
                //不存在则添加
                if (!bFound)
                {
                    lstboxClients.Items.Add(strClient);
                }

                bFound = false;

                //先查找是否存在该IP的客户端
                foreach (string s in lbClientForControl.Items)
                {
                    if ( s.Contains(strIp))
                    {
                        bFound = true;
                        if ( s != strClient)//存在且不等则更新
                        {
                            lbClientForControl.Items.Remove(s);
                            lbClientForControl.Items.Add(strClient);
                        }
                        break;
                    }
                }
                //不存在则添加
                if (!bFound)
                {
                    lbClientForControl.Items.Add(strClient);
                }
                
            }
            else
            {
                foreach (string s in lstboxClients.Items)
                {
                    if (s.Contains(strIp))
                    {
                        lstboxClients.Items.Remove(s);
                        break;
                    }
                }
                foreach (string s in lbClientForControl.Items)
                {
                    if (s.Contains(strIp))
                    {
                        lbClientForControl.Items.Remove(s);
                        break;
                    }
                }
            }
        }

        private void heartTestTimer_Tick(object sender, EventArgs e)
        {
            TimeSpan tmSpan = DateTime.Now - m_lastHeartTime;
            if (tmSpan.TotalSeconds > 10)
            {
                if (!m_exchangeFile.Errored)
                {
                    AddInfoToHeartBox("HeartBeat is out of setting time!", false);
                }

            }
        }

        private void btnStartTcpListener_Click(object sender, EventArgs e)
        {
            string btnText = btnStartTcpListener.Text;
            if (btnText == "Start Server")
            {
                tbTcpPort.Text = tbTcpPort.Text.Trim();
                if (tbTcpPort.Text == "")
                {
                    MessageBox.Show("Please input port number!");
                    return;
                }
                if (Regex.IsMatch(tbTcpPort.Text, "[^0-9]"))
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show("Please input number!");
                    tbTcpPort.SelectAll();
                    tbTcpPort.Focus();
                    return;
                }

                if ( radModeTCP.Checked )
                {
                    m_exchangeTcp = TSDataExchangeTT_TCP.GetDataExchangeTT_TCP(BDCommon.g_adoDataBase.strConnection, Convert.ToInt32(tbTcpPort.Text));
                    if (!m_exchangeTcp.StartServer())
                    {
                        MessageBox.Show(m_exchangeTcp.LastErrMsg);
                        return;
                    }
                    else
                    {
                        if (m_tsTTconfig != null)
                        {
                            m_tsTTconfig.TcpPort = tbTcpPort.Text;
                            m_tsTTconfig.SaveConfig();
                        }
                        
                    }
                }
                else if (radModeUDP.Checked)
                {
                    m_exchangeUdp = TSDataExchangeTT_UDP.GetDataExchangeTT_UDP(BDCommon.g_adoDataBase.strConnection, Convert.ToInt32(tbTcpPort.Text));
                    if (!m_exchangeUdp.StartServer())
                    {
                        MessageBox.Show(m_exchangeUdp.LastErrMsg);
                        return;
                    }
                    else
                    {
                        if (m_tsTTconfig != null)
                        {
                            m_tsTTconfig.TcpPort = tbTcpPort.Text;
                            m_tsTTconfig.SaveConfig();
                        }

                    }
                }
                else
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show("Please select communication mode first!");
                    return;
                }

                btnStartTcpListener.Text = "Stop Server";
                tbTcpPort.ReadOnly = true;
                radModeTCP.Enabled = false;
                radModeUDP.Enabled = false;
            }
            else
            {
                if (MessageBox.Show("Are you sure to close the server?", "OVR", MessageBoxButtons.OKCancel) == DialogResult.Cancel)
                {
                    return;
                }
                if ( radModeTCP.Checked )
                {
                    m_exchangeTcp.CloseServer();
                }
                else if (radModeUDP.Checked)
                {
                    m_exchangeUdp.CloseServer();
                    lstboxClients.Items.Clear();
                    lbClientForControl.Items.Clear();
                }
                btnStartTcpListener.Text = "Start Server";
                tbTcpPort.ReadOnly = false;
                radModeTCP.Enabled = true;
                radModeUDP.Enabled = true;
            }

        }


        private void btnOpenConfig_Click(object sender, EventArgs e)
        {
            if (m_tsTTconfig != null)
            {
                TS_TTConfig.ShellOpenConfig();
            }
        }

        private void btnAutoImport_Click(object sender, EventArgs e)
        {
            string btnText = btnAutoImport.Text;
            if (btnText == "StartAutoImport")
            {
                if (tbImportPath.Text == "")
                {
                    MessageBox.Show("select import path first!");
                    return;
                }
                if (!Directory.Exists(tbImportPath.Text))
                {
                    MessageBox.Show("The path is not exist!");
                    tbImportPath.Clear();
                    return;
                }
                m_exchangeFile = TSDataExchangeTT_File.GetDataExchangeTT_File(BDCommon.g_adoDataBase.strConnection, tbImportPath.Text);
                if (!m_exchangeFile.StartMonitor())
                {
                    MessageBox.Show(m_exchangeFile.LastErrMsg);
                    return;
                }
                m_exchangeFile.SetUserStoppedFlag(false);
                if (m_heartTestTimer != null)
                {
                    m_heartTestTimer.Dispose();
                }
                //m_heartTestTimer = new System.Windows.Forms.Timer();
                //m_heartTestTimer.Interval = 4000;
                //m_heartTestTimer.Tick += new EventHandler(heartTestTimer_Tick);
                //m_lastHeartTime = DateTime.Now;
                //m_heartTestTimer.Start();
                AddInfoToHeartBox("Monitor Started!");
                btnAutoImport.Text = "StopAutoImport";
                btnxImPathSel.Enabled = false;
            }
            else
            {
                if (m_heartTestTimer != null)
                {
                    if (m_heartTestTimer.Enabled)
                    {
                        m_heartTestTimer.Stop();
                    }
                    m_heartTestTimer.Dispose();
                }
                if (m_exchangeFile != null)
                {
                    m_exchangeFile.SetUserStoppedFlag(true);
                    m_exchangeFile.StopMonitor();
                    AddInfoToHeartBox("User stopped!");
                }
                btnAutoImport.Text = "StartAutoImport";
                btnxImPathSel.Enabled = true;
            }
        }

        private void btnOpenMonitor_Click_1(object sender, EventArgs e)
        {
            if (m_stateMonitor == null)
            {
                m_stateMonitor = new frmStateMonitor();
            }
            m_stateMonitor.Owner = this;
            m_stateMonitor.Show();
            m_stateMonitor.WindowState = FormWindowState.Normal;
            m_stateMonitor.Activate();

            return;
        }

        private void secretClearMemory(object sender, KeyEventArgs e)
        {
            if (e.KeyData == Keys.F12)
            {
                if (DialogResult.Cancel == MessageBox.Show("Do your want to clear DiffQueue?", "OVRBDPlugin", MessageBoxButtons.OKCancel))
                {
                    return;
                }
                TSDataExchangeTT_Service.SetDiffQueueToDiff();
            }

            if (e.KeyData == Keys.F11)
            {
                if (DialogResult.Cancel == MessageBox.Show("Do your want to clear Action List History?", "OVRBDPlugin", MessageBoxButtons.OKCancel))
                {
                    return;
                }
                TSDataExchangeTT_Service.ClearAcitonCookie();
            }
        }

        bool bLeftSearch = true;//用于表示上次查的是RSC还是查的MatchID

        private void btnConvertRsc_Click(object sender, EventArgs e)
        {
            string strRsc = tbRSC.Text.Trim();  
            string strMatchID = tbMatchID.Text.Trim();
            if (strRsc == "" && strMatchID == "")
            {
                return;
            }
            if ( strRsc == "1" )
            {
                btnAutoScore.Enabled = true;
                return;
            }
            if (strRsc != "" && strMatchID != "")
            {
                if (bLeftSearch)
                {
                    tbMatchID.Clear();
                    tbRSC.SelectAll();
                    tbRSC.Focus();
                }
                else
                {
                    tbRSC.Clear();
                    tbMatchID.SelectAll();
                    tbMatchID.Focus();
                }
            }

            if (strRsc == "" && strMatchID != "")
            {
                if (Regex.IsMatch(strMatchID, "[^0-9]"))
                {
                    tbMatchID.SelectAll();
                    tbMatchID.Focus();
                    return;
                }

                string strText = BDCommon.g_ManageDB.GetRscStringFromMatchID(Convert.ToInt32(strMatchID));
                tbRSC.Text = strText;
                if (strText == "")
                {

                    tbMatchID.SelectAll();
                    tbMatchID.Focus();
                }
                bLeftSearch = false;
            }

            if (strMatchID == "" && strRsc != "")
            {
                if (strRsc.Length != 9)
                {
                    tbRSC.SelectAll();
                    tbRSC.Focus();
                    return;
                }

                int matchID = BDCommon.g_ManageDB.GetMatchIDFromRSC(strRsc);
                if (matchID >= 1)
                {
                    tbMatchID.Text = matchID.ToString();
                }
                else
                {
                    tbRSC.SelectAll();
                    tbRSC.Focus();
                }
                bLeftSearch = true;
            }
        }

        public void OutputXmlToXuNi(int matchID)
        {
            if ( BDCommon.g_strDisplnCode != "TT" )
            {
                return;
            }
            string strXml = BDCommon.g_ManageDB.GetXuNiOutputXml(matchID);
            if ( strXml != "" ) 
            {
                byte[] data = Encoding.UTF8.GetBytes(strXml);
                BDCommon.g_vTcpServer.SendDataToAllClient(data);
            }
        }

        //计时计分xml更新到数据库之后，通知外围系统状态改变
        public void OnRecvExtraTaskPackage(ExtraTaskInfo extraInfo)
        {
            if (!extraInfo.BTaskOK)
            {
                return;
            }
            if ((extraInfo.TaskFlags & (int)ExtraWorkEnum.ExtraWorkNotifyProgress) != 0)
            {
                BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchProgress, -1, -1, -1, extraInfo.MatchID, -1, null);
                OutputXmlToXuNi(extraInfo.MatchID);
            }

            if ((extraInfo.TaskFlags & (int)ExtraWorkEnum.ExtraWorkNotifySplitInfo) != 0)
            {
                BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, extraInfo.MatchID, -1, null);
                OutputXmlToXuNi(extraInfo.MatchID);
            }
            if ((extraInfo.TaskFlags & (int)ExtraWorkEnum.ExtraWorkNotifyStatusStartList) != 0)
            {
                BDCommon.g_ManageDB.SetCurrentSplitFlag(extraInfo.MatchID, 1, 1);
                BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatus, -1, -1, -1, extraInfo.MatchID, -1, null);
            }
            if ((extraInfo.TaskFlags & (int)ExtraWorkEnum.ExtraWorkNotifyStatusRunning) != 0)
            {
                BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatus, -1, -1, -1, extraInfo.MatchID, -1, null);
                OutputXmlToXuNi(extraInfo.MatchID);
            }
            if ((extraInfo.TaskFlags & (int)ExtraWorkEnum.ExtraWorkNotifyStatusUnofficial) != 0)
            {
                // UpdateRank
                BDCommon.g_ManageDB.UpdateMatchRankSets(extraInfo.MatchID);
                BDCommon.g_ManageDB.CreateGroupResult(extraInfo.MatchID);
                OVRDataBaseUtils.AutoProgressMatch(extraInfo.MatchID, BDCommon.g_adoDataBase.m_dbConnect, BDCommon.g_BDPlugin);//自动晋级
                BDCommon.g_ManageDB.SetCurrentSplitFlag(extraInfo.MatchID, -1, 3);//设置比赛结束

              //  BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, extraInfo.MatchID, extraInfo.MatchID, null);

                Int32 iPhaseID = BDCommon.g_ManageDB.GetPhaseID(extraInfo.MatchID);
                BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);
                BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatus, -1, -1, -1, extraInfo.MatchID, extraInfo.MatchID, null);
                OutputXmlToXuNi(extraInfo.MatchID);
            }
            //收到导出schedule的消息
            if ((extraInfo.TaskFlags & (int)ExtraWorkEnum.ExtraWorkNotifyExportSchedule) != 0)
            {
                if (chkOuterData.Checked)
                {
                    string strRes = ExportScheduleXml2();
                    if (strRes == "")
                    {
                        AddInfoToFileBox("收到客户端导出schedule消息成功！");
                    }
                    else
                    {
                        AddInfoToFileBox("收到客户端导出消息，" + strRes, false);
                    }
                }
                else
                {
                    AddInfoToFileBox("收到客户端导出schedule消息，未勾选External data", false);
                }
            }
        }


        private void AddInfoToChatMsgBox(string strData, bool bHeader)
        {
            if (bHeader)
            {
                richTBMsg.SelectionColor = Color.Blue;
            }
            else
            {
                richTBMsg.SelectionColor = Color.Black;
            }

            richTBMsg.AppendText(strData + "\r\n");

            richTBMsg.SelectionStart = richTBMsg.MaxLength;
            richTBMsg.SelectionLength = 0;
            richTBMsg.ScrollToCaret();
        }

        private void RecvNotify(NotifyData data)
        {
            switch (data.Key)
            {
                case "Disconnect":
                    btnConnectOvr.Text = "Connect";
                    tbServerIP.Enabled = true;
                    tbRemotePort.Enabled = true;
                    btnSendPlayerChangedMsg.Enabled = false;
                    tbChatName.Enabled = false;
                    tbChatMsg.Enabled = false;
                    btnSendMsg.Enabled = false;
                    btnClearChatMsg.Enabled = false;
                    break;
                case "ChatMsg":
                    {
                        string xml = (string)data.Obj;
                        XmlDocument doc = new XmlDocument();
                        try
                        {
                            int pos = xml.IndexOf("|");
                            if (pos == -1)
                            {
                                return;
                            }
                            string strIp = xml.Substring(0, pos);
                            doc.LoadXml(xml.Substring(pos + 1));
                            XmlNode node = doc.SelectSingleNode("/MatchInfo/Chat");
                            if (node != null)
                            {
                                string strName = node.Attributes["Name"].Value.ToString();
                                // string strIp = node.Attributes["IP"].Value.ToString();
                                string strMsg = node.Attributes["Message"].Value.ToString();
                                string strTime = DateTime.Now.ToString("T");
                                AddInfoToChatMsgBox(string.Format("{0} ({1}) {2}", strName, strIp, strTime), true);
                                AddInfoToChatMsgBox(strMsg, false);
                                FlashWindow(this.Handle, true);
                            }

                        }
                        catch (System.Exception e)
                        {

                        }
                    }
                    break;
                default:
                    break;
            }
        }
        private void btnConnectOvr_Click(object sender, EventArgs e)
        {
            if (btnConnectOvr.Text == "Connect")
            {
                if (tbRemotePort.Text == "")
                {
                    MessageBox.Show("Please input port number!");
                    return;
                }
                if (Regex.IsMatch(tbRemotePort.Text, "[^0-9]"))
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show("Please input number!");
                    tbRemotePort.SelectAll();
                    tbRemotePort.Focus();
                    return;
                }
                string strIP = tbServerIP.Text;
                if (tcpClient_ == null)
                {
                    tcpClient_ = new TcpExchangeClient();
                    tcpClient_.NotifyMsg = RecvNotify;
                }
                if (tcpClient_.Connect(strIP, Convert.ToInt32(tbRemotePort.Text)))
                {
                    btnConnectOvr.Text = "Disconnect";
                    tbServerIP.Enabled = false;
                    tbRemotePort.Enabled = false;
                    btnSendPlayerChangedMsg.Enabled = true;
                    tbChatName.Enabled = true;
                    tbChatMsg.Enabled = true;
                    btnSendMsg.Enabled = true;
                    btnClearChatMsg.Enabled = true;
                    m_tsTTconfig.CtrlCenterIP = tbServerIP.Text;
                    m_tsTTconfig.CenterPort = tbRemotePort.Text;
                    m_tsTTconfig.SaveConfig();
                }
                else
                {
                    MessageBox.Show("Connect to server failed!");
                }
            }
            else
            {
                if (tcpClient_ != null)
                {
                    tcpClient_.Disconnect();
                }
                tbServerIP.Enabled = true;
                tbRemotePort.Enabled = true;
                btnSendPlayerChangedMsg.Enabled = false;
                tbChatName.Enabled = false;
                tbChatMsg.Enabled = false;
                btnSendMsg.Enabled = false;
                btnClearChatMsg.Enabled = false;
            }

        }


        private void btnSendPlayerChangedMsg_Click(object sender, EventArgs e)
        {
            if (tcpClient_ == null || !tcpClient_.IsConnected)
            {
                MessageBox.Show("Please connect to central console first!");
                return;
            }
            tcpClient_.SendStringData(string.Format("<MatchInfo> <Export MatchID=\"{0}\"/> </MatchInfo>", m_nCurMatchID));
            if ( m_nCurMatchID >= 1 )
            {
                BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatus, -1, -1, -1, m_nCurMatchID, m_nCurMatchID,null);
            }
        }

        private void btnClearChatMsg_Click(object sender, EventArgs e)
        {
            richTBMsg.Clear();
        }

        private void btnSendMsg_Click(object sender, EventArgs e)
        {
            if (tbChatName.Text.Trim() == "")
            {
                MessageBox.Show("Please input your name!");
                tbChatName.Focus();
                return;
            }
            if (tbChatMsg.Text.Trim() == "")
            {
                MessageBox.Show("Please input msg!");
                return;
            }
            tcpClient_.SendChatMsg(tbChatName.Text.Trim(), tbChatMsg.Text);
            tbChatMsg.Clear();
            tbChatMsg.Focus();
        }

        //处理跨国组合
        private void btnCreateCrossPair_Click(object sender, EventArgs e)
        {
            string codeA = tbCrossCodeA.Text.Trim();
            string codeB = tbCrossCodeB.Text.Trim();
            string codePair = tbCrossCodePair.Text.Trim();
            if (codeA == "" || codeB == "" || codePair == "")
            {
                MessageBox.Show("Please input full info!");
                return;
            }
            int nRet = BDCommon.g_ManageDB.CreateDoublePair(codePair, codeA, codeB);
            if (nRet > 0)
            {
                MessageBox.Show("Create succeed!");
                UpdateCrossPair();
            }
        }

        private void ShowCurrentCrossPair()
        {

        }

        private void UpdateCrossPair()
        {
            DataTable dt = BDCommon.g_ManageDB.GetCrossPairInfo();
            if (dt == null)
            {
                dgCrossPair.Rows.Clear();
                return;
            }
            OVRDataBaseUtils.FillDataGridViewWithChk(dgCrossPair, dt, 4, 1, 0);
            if (dgCrossPair.Columns["RegID"] != null)
            {
                dgCrossPair.Columns["RegID"].ReadOnly = true;
            }
            if (dgCrossPair.Columns["RegCode"] != null)
            {
                dgCrossPair.Columns["RegCode"].ReadOnly = true;
            }
            if (dgCrossPair.Columns["PairName"] != null)
            {
                dgCrossPair.Columns["PairName"].ReadOnly = true;
            }
            if (dgCrossPair.Columns["Sex"] != null)
            {
                dgCrossPair.Columns["Sex"].ReadOnly = true;
            }
            if (dgCrossPair.Columns["Inscription"] != null)
            {
                dgCrossPair.Columns["Inscription"].ReadOnly = false;
            }
        }

        private void OnRefreshCrossPair(object sender, EventArgs e)
        {
            UpdateCrossPair();
        }
        private void OnCrossDGContentClicked(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex != 4)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            int regPairID = Convert.ToInt32(dgCrossPair.Rows[iRowIndex].Cells[0].Value);
            int bAdd = Convert.ToInt32(dgCrossPair.Rows[iRowIndex].Cells[4].Value);
            if (bAdd == 0)
            {
                bAdd = 1;
            }
            else
            {
                bAdd = 0;
            }

            DataGridViewCell CurCell = dgCrossPair.Rows[iRowIndex].Cells[iColumnIndex];
            if (!BDCommon.g_ManageDB.CrossPairInscription(regPairID, bAdd))
            {

            }
            UpdateCrossPair();
        }

        private void SendControlCommand(string ipAddr, string strControl)
        {
            if ( BDCommon.g_strDisplnCode != "BD")
            {
                return;
            }
            MemoryStream memStream = new MemoryStream();
            BinaryWriter writer = new BinaryWriter(memStream);
            writer.Write(BDCommon.MSG_FLAG_CONTROL);
            writer.Write(strControl);
            byte []sendData = memStream.ToArray();
            try
            {
                if ( m_udpClient != null )
                {
                    m_udpClient.Send(sendData, sendData.Length, new IPEndPoint(IPAddress.Parse(ipAddr), BDCommon.UDP_CTRL_PORT));
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
            writer.Close();
            memStream.Close();
            
        }

        private void SendCmdToSelectClients(string strCmd)
        {
            if (lbClientForControl.SelectedItems.Count == 0)
            {
                return;
            }
            int pos = -1;
            foreach (string s in lbClientForControl.SelectedItems)
            {
                pos = s.IndexOf("(");
                if (pos != -1)
                {
                    SendControlCommand(s.Substring(0, pos), strCmd);
                }
            }

        }
        private void btnSendSynchor_Click(object sender, EventArgs e)
        {
            SendCmdToSelectClients("Synchronize");
        }

        private void btnUnlockCourt_Click(object sender, EventArgs e)
        {
            SendCmdToSelectClients("UnlockCourt");
        }

        private void btnLockCourt_Click(object sender, EventArgs e)
        {
            SendCmdToSelectClients("LockCourt");
        }
        private void btnDelAllData_Click(object sender, EventArgs e)
        {
            if (DialogResult.Cancel == MessageBoxEx.Show("This is a very dangerous operation, do you want to continue? ", "DelData", MessageBoxButtons.OKCancel,
                            MessageBoxIcon.Warning))
                return;
            SendCmdToSelectClients("DelData");
        }
        private void btnRequestMatchInfo_Click(object sender, EventArgs e)
        {
            SendCmdToSelectClients("GetMatchData");
        }

        private void btnSendShortMsg_Click(object sender, EventArgs e)
        {
            string strMsg = tbUdpMsg.Text.Trim();
            if ( strMsg == "")
            {
                return;
            }
            if (lbClientForControl.SelectedItems.Count == 0)
            {
                return;
            }
            int pos = -1;
            foreach (string s in lbClientForControl.SelectedItems)
            {
                pos = s.IndexOf("(");
                if (pos != -1)
                {
                    MemoryStream memStream = new MemoryStream();
                    BinaryWriter writer = new BinaryWriter(memStream);
                    writer.Write(BDCommon.MSG_FLAG_MSG);
                    writer.Write(strMsg);
                    byte[] sendData = memStream.ToArray();
                    try
                    {
                        if (m_udpClient != null)
                        {
                            m_udpClient.Send(sendData, sendData.Length, new IPEndPoint(IPAddress.Parse(s.Substring(0,pos)), BDCommon.UDP_CTRL_PORT));
                        }
                    }
                    catch (System.Exception ex)
                    {
                        MessageBox.Show(ex.ToString());
                    }
                    writer.Close();
                    memStream.Close();
                }
            }
            tbUdpMsg.Clear();
            tbUdpMsg.Focus();
        }
        private void btnStartRemoteClicked(object sender, EventArgs e)
        {
            if ( m_remoteUI != null && m_remoteUI.Visible)
            {
                m_remoteUI.Show();
                m_remoteUI.WindowState = FormWindowState.Maximized;
                m_remoteUI.BringToFront();
                m_remoteUI.Activate();
                return;
            }
            string strIP = "";
            if ( !chkIPSwitch.Checked)
            {
                if (lbClientForControl.SelectedItems.Count == 0)
                {
                    MessageBox.Show("请选择要控制的客户端！");
                    return;
                }
                if (lbClientForControl.SelectedItems.Count > 1)
                {
                    MessageBox.Show("只能选择一个客户端进行控制！");
                    return;
                }
                strIP = (string)lbClientForControl.SelectedItem;
                int pos = strIP.IndexOf("(");
                if (pos != -1)
                {
                    strIP = strIP.Substring(0, pos);
                }
            }
            else
            {
                strIP = tbIpAddress.Text.Trim();
                if (strIP == "")
                {
                    MessageBox.Show("请输入IP地址！");
                    tbIpAddress.Focus();
                    return;
                }
                IPAddress ip;
                if (!IPAddress.TryParse(strIP, out ip))
                {
                    MessageBox.Show("IP地址非法，请重新输入！");
                    tbIpAddress.SelectAll();
                    tbIpAddress.Focus();
                    return;
                }
            }

            if (m_remoteUI == null )
            {
                m_remoteUI = new RemoteUI(strIP, 24321, (int)cmbFrameRate.SelectedItem);
            }
            m_remoteUI.SetIpAndFrameRate(strIP, (int)cmbFrameRate.SelectedItem);
            
            if (!m_remoteUI.ConnectToServer())
            {
                MessageBox.Show(m_remoteUI.LastErrorMsg);
                return;
            }
            m_remoteUI.Show();
            m_remoteUI.SetNoControl();
            m_remoteUI.WindowState = FormWindowState.Maximized;
            m_remoteUI.BringToFront();
            m_remoteUI.Activate();
        }

        private void chkIPClicked(object sender, EventArgs e)
        {
            if (chkIPSwitch.Checked)
            {
                tbIpAddress.Enabled = true;
            }
            else
            {
                tbIpAddress.Enabled = false;
            }
        }
    }
}
