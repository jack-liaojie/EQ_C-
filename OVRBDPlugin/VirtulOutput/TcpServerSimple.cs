using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;

namespace AutoSports.OVRBDPlugin
{
    public class TcpServerSimple
    {
        #region 事件
        public event ClientChangedDelegate OnClientChanged;
        #endregion

        #region 私有成员

        private bool m_bRunning;
        private UInt32 m_headerFlag;
        private TcpListener m_tcpListener;//监听套接字
        private Thread m_listenThread;
        private UInt16 m_nPort;
        private ManualResetEvent m_recvExitEvent;
        private Dictionary<TcpClient, ClientInfo> m_recvClientsInfo = null;
        #endregion

        #region 构造函数

        public TcpServerSimple(UInt16 nPort, UInt32 headerFlag)
        {
            m_bRunning = false;
            m_nPort = nPort;

            m_headerFlag = headerFlag;
            m_recvClientsInfo = new Dictionary<TcpClient, ClientInfo>();
        }
        #endregion

        #region 错误处理
        private string m_strLastErrorMsg = "";
        public string LastErrorMsg { get { return m_strLastErrorMsg; } }
        #endregion

        #region 公有函数

        /// <summary>
        /// 开启tcp服务端
        /// </summary>
        /// <returns>成功：true;失败：false</returns>
        public bool StartServer()
        {
            if (m_bRunning)
            {
                m_strLastErrorMsg = "The service is already running!";
                return false;
            }
            //各事件初始化
            m_recvExitEvent = new ManualResetEvent(true);
            //启动监听
            try
            {
                m_tcpListener = new TcpListener(IPAddress.Any, m_nPort);
                CommunicationCommon.SetKeepAlive(m_tcpListener.Server, 10000, 5000);
                m_tcpListener.Start();
            }
            catch (System.Exception ex)
            {
                m_strLastErrorMsg = ex.Message;
                return false;
            }
            m_bRunning = true;
            try
            {
                m_listenThread = new Thread(() => this.ListenProc());
                m_listenThread.IsBackground = true;
                m_listenThread.Start();
            }
            catch (System.Exception ex)
            {
                m_bRunning = false;
                m_strLastErrorMsg = ex.Message;
                return false;
            }

            return true;
        }

        public void CloseServer()
        {
            if (!m_bRunning)
            {
                return;
            }
            m_bRunning = false;//设置停止标志

            //让监听线程退出
            m_tcpListener.Stop();
            //关闭所有客户端套接字
            Monitor.Enter(m_recvClientsInfo);
            foreach (TcpClient tcpClient in m_recvClientsInfo.Keys)
            {
                tcpClient.Close();
            }
            Monitor.Exit(m_recvClientsInfo);

            m_listenThread.Join();
            m_listenThread = null;

            m_recvExitEvent.WaitOne();//等待接收线程退出
        }

        /// <summary>
        /// 异步发送数据
        /// </summary>
        /// <param name="data">要发送的数据</param>
        /// <param name="client">执行发送TcpClient</param>
        public void BeginSendData(byte[] data, TcpClient client)
        {
            NetworkStream ns = client.GetStream();
            ns.BeginWrite(data, 0, data.Length, new AsyncCallback(SendCallBack), ns);
        }

        /// <summary>
        /// 发送数据到所有客户端
        /// </summary>
        /// <param name="data"></param>
        public void SendDataToAllClient(byte[] data)
        {
            if ( m_recvClientsInfo.Keys.Count <= 0 )
            {
                return;
            }
            TransDataPacket packet = new TransDataPacket(0xFFFFFFFF);
            byte[] packetData = packet.MakePacket(data);
            Monitor.Enter(m_recvClientsInfo);
            foreach (TcpClient client in m_recvClientsInfo.Keys)
            {
                try
                {
                    BeginSendData(packetData, client);
                }
                catch (System.Exception ex)
                {
                    IPEndPoint ipEndPt = client.Client.RemoteEndPoint as IPEndPoint;
                    
                }

            }
            Monitor.Exit(m_recvClientsInfo);
        }
        #endregion

        #region 私有函数

        /// <summary>
        /// 异步发送的回调函数
        /// </summary>
        /// <param name="result"></param>
        private void SendCallBack(IAsyncResult result)
        {
            NetworkStream ns = result.AsyncState as NetworkStream;
            ns.EndWrite(result);
        }

        /// <summary>
        /// 监听线程函数
        /// </summary>
        private void ListenProc()
        {
            while (m_bRunning)
            {
                try
                {
                    TcpClient tcpClient = m_tcpListener.AcceptTcpClient();
                    IPEndPoint ipEndPt = tcpClient.Client.RemoteEndPoint as IPEndPoint;
                    Thread recvThread = new Thread((param) => this.RecvProc(param));
                    recvThread.IsBackground = true;
                    recvThread.Start(tcpClient);

                    //将客户端信息添加到集合中
                    ClientInfo clientInfo = new ClientInfo();
                    clientInfo.RecvThread = recvThread;
                    clientInfo.LastHeartTime = DateTime.Now;
                    clientInfo.IpAddress = ipEndPt.Address.ToString();
                    Monitor.Enter(m_recvClientsInfo);
                    m_recvClientsInfo.Add(tcpClient, clientInfo);
                    Monitor.Exit(m_recvClientsInfo);
                }
                catch
                {
                    break;
                }
            }
        }

        /// <summary>
        /// 接收数据线程函数
        /// </summary>
        private void RecvProc(object param)
        {
            m_recvExitEvent.Reset();

            TcpClient tcpClient = param as TcpClient;
            if (OnClientChanged != null)
            {
                OnClientChanged( (tcpClient.Client.RemoteEndPoint as IPEndPoint).Address.ToString(), true, m_recvClientsInfo.Count);
            }
            NetworkStream netStream = tcpClient.GetStream();
            byte[] buffer = new byte[4];//
            while (m_bRunning)
            {
                //提取包长
                int dataLen = 0;
                if (CommunicationCommon.ReadAllData(netStream, buffer, 4))
                {
                    dataLen = BitConverter.ToInt32(buffer, 0);
                    if (dataLen < 0)
                    {
                        break;//非法数据，关闭客户端
                    }
                }
                else
                {
                    break;
                }

                if (dataLen > 0)
                {
                    buffer = new byte[dataLen];
                    if (CommunicationCommon.ReadAllData(netStream, buffer, dataLen))
                    {
                        //if (OnReceiveData != null)
                        //{
                        //    OnReceiveData((IPEndPoint)tcpClient.Client.RemoteEndPoint, buffer);
                        //}
                    }
                    else
                    {
                        break;
                    }
                }
            }
            
            netStream.Close();
            tcpClient.Close();
            Monitor.Enter(m_recvClientsInfo);
            string strIP = "";
            ClientInfo info = null;
            if ( m_recvClientsInfo.TryGetValue(tcpClient, out info))
            {
                strIP = info.IpAddress;
            }
            
            m_recvClientsInfo.Remove(tcpClient);
            if (OnClientChanged != null)
            {
                OnClientChanged(strIP, false, m_recvClientsInfo.Count);
            }

            if (m_recvClientsInfo.Count == 0)
            {
                m_recvExitEvent.Set();
            }
            Monitor.Exit(m_recvClientsInfo);

        }
        #endregion
    }

    public class ClientInfo
    {
        public Thread RecvThread;
        public DateTime LastHeartTime;
        public string IpAddress;
    }
}
