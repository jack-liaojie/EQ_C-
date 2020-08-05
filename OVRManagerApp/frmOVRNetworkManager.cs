using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRManagerApp
{
    public delegate void OVRNetworkStatus(bool bRunning);

    public partial class OVRNetworkManagerForm : UIPage
    {
        private bool m_IsServer;
        private bool m_IsServerRunning;
        private bool m_IsClientRunning;
        private System.Net.IPAddress m_strServerEndAddr;
        private int m_iServerPort;
        private string m_strClientHost;
        private int m_iClientPort;
        private OVRSocketsServer m_server;
        private OVRSocketClient m_client;

        private DataTable m_dtServerClients;

        public event OVRSocketDataHandler EventDataReceived;
        public event OVRNetworkStatus EventNetworkStatus;

        public bool IsRunning
        {
            get { return m_IsServer ? m_IsServerRunning : m_IsClientRunning; }
        }

        public OVRNetworkManagerForm()
        {
            InitializeComponent();
            Localization();

            m_server = null;
            m_client = null;

            pbConnectedStatus.Image = global::AutoSports.OVRManagerApp.Properties.Resources.DisConnected;
            pbListenStatus.Image = global::AutoSports.OVRManagerApp.Properties.Resources.DisConnected;
        }

        private void Localization()
        {
            string strSectionName = "OVRNetworkManager";
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "OVRNetworkManager");
            this.btnConnect.Text = LocalizationRecourceManager.GetString(strSectionName, "gpClient");
            this.lbServerIP.Text = LocalizationRecourceManager.GetString(strSectionName, "lbServerIP");
            this.lbServerPort.Text = LocalizationRecourceManager.GetString(strSectionName, "lbServerPort");
            this.btnConnectServer.Text = LocalizationRecourceManager.GetString(strSectionName, "btnConnectServer");
           
            this.gpServer.Text = LocalizationRecourceManager.GetString(strSectionName, "gpServer");
            this.lbListenPort.Text = LocalizationRecourceManager.GetString(strSectionName, "lbListenPort");
            this.btnStartListen.Text = LocalizationRecourceManager.GetString(strSectionName, "btnStartListen");
        }

        public new void Initialize(bool bServer)
        {
            UnInitialize();

            m_IsServer = bServer;

            if (m_IsServer)
            {
                gpServer.Enabled = true;
                btnConnect.Enabled = false;
                m_server = new OVRSocketsServer();
                m_server.EventClientAccepted += new OVRSocketAcceptedHandler(OnClientAccepted);
                m_server.EventConnectionDroped += new OVRSocketErrorHandler(OnConnectionDroped);
                m_server.EventDataReceived += new OVRSocketDataHandler(OnSocketData);
                m_server.EventSocketError += new OVRSocketErrorHandler(OnSocketError);
            } 
            else
            {
                gpServer.Enabled = false;
                btnConnect.Enabled = true;
                m_client = new OVRSocketClient();
                m_client.EventConnectionDroped += new OVRSocketErrorHandler(OnConnectionDroped);
                m_client.EventDataReceived += new OVRSocketDataHandler(OnSocketData);
                m_client.EventSocketError += new OVRSocketErrorHandler(OnSocketError);
            }

            m_dtServerClients = new DataTable("ServerClients");
            m_dtServerClients.Columns.Add(new DataColumn("Clients Control", typeof(string)));

            dgvServerClients.DataSource = m_dtServerClients;
            dgvServerClients.AutoGenerateColumns = true;
        }

        public void UnInitialize()
        {
            if (m_server != null)
            {
                m_server.StopAllClients();
                m_server.StopListen();

                if (m_IsServerRunning && EventNetworkStatus != null)
                    EventNetworkStatus(false);

                m_IsServerRunning = false;
                m_server = null;
            }

            if (m_client != null)
            {
                m_client.Stop();
                m_client = null;
            }
        }

        public bool StartListen(System.Net.IPAddress localAddr, int port)
        {
            if (!m_IsServer || m_server == null) return false;

            m_strServerEndAddr = localAddr;
            m_iServerPort = port;

            this.tbListenPort.Text = m_iServerPort.ToString();

            return StartListen();
        }

        public bool Connect(string hostName, int port)
        {
            if (m_IsServer || m_client == null) return false;

            m_strClientHost = hostName;
            m_iClientPort = port;

            return Connect();
        }

        public void BroadcastMessage(string message)
        {
            if (!m_IsServer)
            {
                if (m_client == null || !m_IsClientRunning) return;

                m_client.SendMessage(message);
            }
            else
            {
                if (m_server == null || !m_IsServerRunning) return;

                m_server.BroadcastMessage(message);
            }
        }

        private bool StartListen()
        {
            if (m_iServerPort == 0)
                return false;

            string strSectionName = "OVRNetworkManager";
            m_IsServerRunning = m_server.StartListen(m_strServerEndAddr, m_iServerPort);           
            if (m_IsServerRunning)
            {
                this.btnStartListen.Text = LocalizationRecourceManager.GetString(strSectionName, "btnStopListen");
                pbListenStatus.Image = global::AutoSports.OVRManagerApp.Properties.Resources.Connected;
                this.tbListenPort.Enabled = false;
            }
            else
            {
                this.btnStartListen.Text = LocalizationRecourceManager.GetString(strSectionName, "btnStartListen");
                pbListenStatus.Image = global::AutoSports.OVRManagerApp.Properties.Resources.DisConnected;
                this.tbListenPort.Enabled = true;
            }

            if (EventNetworkStatus != null)
                EventNetworkStatus(m_IsServerRunning);

            return m_IsServerRunning;
        }

        private bool Connect()
        {
            if (m_strClientHost == null || 
                m_strClientHost == "" ||
                m_iClientPort == 0)
                return false;

            this.tbServerIP.Value = m_strClientHost;
            this.tbServerPort.Text = m_iClientPort.ToString();

            string strSectionName = "OVRNetworkManager";
           
            m_IsClientRunning = m_client.Start(m_strClientHost, m_iClientPort);
            if (m_IsClientRunning)
            {
                this.btnConnectServer.Text = LocalizationRecourceManager.GetString(strSectionName, "btnDisConnectServer");
                pbConnectedStatus.Image = global::AutoSports.OVRManagerApp.Properties.Resources.Connected;
                this.tbServerIP.Enabled = false;
                this.tbServerPort.Enabled = false;
            }
            else
            {
                this.btnConnectServer.Text = LocalizationRecourceManager.GetString(strSectionName, "btnConnectServer");
                pbConnectedStatus.Image = global::AutoSports.OVRManagerApp.Properties.Resources.DisConnected;
                this.tbServerIP.Enabled = true;
                this.tbServerPort.Enabled = true;
            }

            if (EventNetworkStatus != null)
                EventNetworkStatus(m_IsClientRunning);

            return m_IsClientRunning;
        }

        #region MultiThread Calling Function

        private void OnClientAccepted(string strEndPoint)
        {
            if (this.InvokeRequired)
            {
                OVRSocketAcceptedHandler delegateClientAccepted = new OVRSocketAcceptedHandler(OnInokeClientAccepted);

                this.Invoke(delegateClientAccepted, strEndPoint);

                return;
            }

            OnInokeClientAccepted(strEndPoint);
        }

        private void OnConnectionDroped(string strEndPoint, System.Net.Sockets.SocketError errorCode)
        {
            if (this.InvokeRequired)
            {
                OVRSocketErrorHandler delegateConnectionDroped = new OVRSocketErrorHandler(OnInokeConnectionDroped);

                this.Invoke(delegateConnectionDroped, strEndPoint, errorCode);

                return;
            }

            OnInokeConnectionDroped(strEndPoint, errorCode);
        }

        private void OnSocketError(string strEndPoint, System.Net.Sockets.SocketError errorCode)
        {
            if (this.InvokeRequired)
            {
                OVRSocketErrorHandler delegateSocketError = new OVRSocketErrorHandler(OnInokeSocketError);

                this.Invoke(delegateSocketError, strEndPoint, errorCode);

                return;
            }

            OnInokeSocketError(strEndPoint, errorCode);
        }

        private void OnSocketData(string strEndPoint, OVRSocketBuffer data)
        {
            if (EventDataReceived != null)
                EventDataReceived(strEndPoint, data);
        }

        #endregion

        #region Event Handler

        private void OnInokeClientAccepted(string strEndPoint)
        {
            if (!m_IsServer || m_server == null) return;

            DataRow dr = m_dtServerClients.NewRow();
            dr[0] = strEndPoint;
            m_dtServerClients.Rows.Add(dr);
        }

        private void OnInokeConnectionDroped(string strEndPoint, System.Net.Sockets.SocketError errorCode)
        {
            if (!m_IsServer)
            {
                 if (m_client == null) return;

                pbConnectedStatus.Image = global::AutoSports.OVRManagerApp.Properties.Resources.DisConnected;
                this.tbServerIP.Enabled = true;
                this.tbServerPort.Enabled = true;

                this.btnConnectServer.Text = LocalizationRecourceManager.GetString("OVRNetworkManager", "btnConnectServer");

                m_IsClientRunning = false;

                if (EventNetworkStatus != null)
                    EventNetworkStatus(m_IsClientRunning);
            }
            else
            {
                if (m_server == null) return;

                for (int i = 0; i < m_dtServerClients.Rows.Count; i++)
                {
                    if (m_dtServerClients.Rows[i][0].ToString() == strEndPoint)
                    {
                        m_dtServerClients.Rows.RemoveAt(i);
                        i--;
                    }
                }
            }
        }

        private void OnInokeSocketError(string strEndPoint, System.Net.Sockets.SocketError errorCode)
        {

        }

        private void OnInokeSocketData(string strEndPoint, OVRSocketBuffer data)
        {

        }

        private void OVRReportPrintingForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                if (this.Owner != null)
                    this.Owner.Activate();

                this.Visible = false;
                e.Cancel = true;
            }
        }
             

        private void dgvServerClients_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (!m_IsServer || m_server == null) return;

            if (e.RowIndex < 0 || e.ColumnIndex < 0) return;

            string strEndPoint = dgvServerClients.Rows[e.RowIndex].Cells[e.ColumnIndex].Value.ToString();

            m_server.StopClient(strEndPoint);
        }

        private void tbServerIP_TextChanged(object sender, EventArgs e)
        {
            m_strClientHost = this.tbServerIP.Text;
            ConfigurationManager.SetUserSettingString("Server", m_strClientHost);
        }

        private void tbServerPort_TextChanged(object sender, EventArgs e)
        {
            try
            {
                m_iClientPort = System.Convert.ToInt32(this.tbServerPort.Text);
            }
            catch (System.Exception ex)
            {
                m_iClientPort = 0;
            }
            ConfigurationManager.SetUserSettingString("Port", m_iClientPort.ToString());
        }

        private void tbListenPort_TextChanged(object sender, EventArgs e)
        {
            try
            {
                m_iServerPort = System.Convert.ToInt32(this.tbListenPort.Text);
            }
            catch (System.Exception ex)
            {
                m_iServerPort = 0;
            }
            ConfigurationManager.SetUserSettingString("Port", m_iServerPort.ToString());
        }

        private void btnConnectServer_Click(object sender, EventArgs e)
        {
            if (m_IsServer || m_client == null) return;

            if (m_IsClientRunning)
            {
                string strSectionName = "OVRNetworkManager";
                string strMsgTile = LocalizationRecourceManager.GetString(strSectionName, "ClientStoppedMsgTitle");
                string strMsgInfo = LocalizationRecourceManager.GetString(strSectionName, "ClientStoppedMsgInfo");
                if (DevComponents.DotNetBar.MessageBoxEx.Show(this, strMsgInfo, strMsgTile, MessageBoxButtons.YesNo) == DialogResult.No) return;

                m_client.Stop();

                this.btnConnectServer.Text = LocalizationRecourceManager.GetString(strSectionName, "btnConnectServer");
                pbConnectedStatus.Image = global::AutoSports.OVRManagerApp.Properties.Resources.DisConnected;
                m_IsClientRunning = false;
            }
            else
            {
                Connect();
            }
        }

        private void btnStartListen_Click(object sender, EventArgs e)
        {
            if (!m_IsServer || m_server == null) return;

            if (m_IsServerRunning)
            {
                string strSectionName = "OVRNetworkManager";
                string strMsgTile = LocalizationRecourceManager.GetString(strSectionName, "ServerStoppedMsgTitle");
                string strMsgInfo = LocalizationRecourceManager.GetString(strSectionName, "ServerStoppedMsgInfo");
                if (DevComponents.DotNetBar.MessageBoxEx.Show(this, strMsgInfo, strMsgTile, MessageBoxButtons.YesNo) == DialogResult.No) return;

                m_server.StopListen();

                this.tbListenPort.Enabled = true;
                pbListenStatus.Image = global::AutoSports.OVRManagerApp.Properties.Resources.DisConnected;
                this.btnStartListen.Text = LocalizationRecourceManager.GetString(strSectionName, "btnStartListen");

                m_IsServerRunning = false;

                if (EventNetworkStatus != null)
                    EventNetworkStatus(m_IsServerRunning);
            }
            else
            {
                StartListen();
            }
        }
        #endregion       

        private void OVRNetworkManagerForm_Load(object sender, EventArgs e)
        {

        }
    }
}
