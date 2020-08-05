using System;
using System.Net;
using System.Net.Sockets;
using System.Threading;

#pragma warning disable 1591

namespace AutoSports.OVRBKPlugin
{
    public class TcpClientEx
    {
        #region 构造函数

        public TcpClientEx(int clientID)
        {
            m_clientID = clientID;
            m_bRunning = false;
            m_connectEvent = new ManualResetEvent(false);
            
        }

        #endregion

        #region 私有成员
        private bool m_bRunning;
        private TcpClient m_tcpClient;
        private string m_serverIP;
        private UInt16 m_serverPort;
        private IPEndPoint m_ipEndPoint;
        private int m_clientID;

        private NetworkStream m_netWorkStream;
        private Thread m_connectWaitThread;
        private Thread m_recvThread;
        private ManualResetEvent m_connectEvent;
        #endregion

        #region 属性

        public int ClientID
        {
            get { return m_clientID; }
        }

        public bool Connected
        {
            get { return m_bRunning; }
        }
        #endregion

        #region 事件
        public event Action<object, byte[]> OnReceiveData;  //收到数据
        public event Action<object, bool> OnConnectionChanged; //连接更改
        //public event Action<object, bool> ConnectedEnd; //异步连接结束
        #endregion

        #region 错误处理
        private string m_strLastErrorMsg = "";
        public string LastErrorMsg { get { return m_strLastErrorMsg; } }
        #endregion

        #region 事件处理

        /// <summary>
        /// 异步连接结束的回调
        /// </summary>
        /// <param name="ar"></param>
        private void ConnAsyncCallback(IAsyncResult ar)
        {
            m_connectEvent.Set();
        }

        /// <summary>
        /// 异步连接结束后，发出事件
        /// </summary>
        private void EndConnect()
        {
            if (m_tcpClient.Connected)
            {
                InitWorkers();
            }

            if (OnConnectionChanged != null)
            {
                OnConnectionChanged(this, m_tcpClient.Connected);
            }
        }
        #endregion

        #region 私有方法

        

        /// <summary>
        /// 连接成功后，启动后台线程
        /// </summary>
        private void InitWorkers()
        {
            m_bRunning = true;
            m_ipEndPoint = new IPEndPoint(IPAddress.Parse(m_serverIP), m_serverPort);
            m_netWorkStream = m_tcpClient.GetStream();
            m_recvThread = new Thread(() => this.RecvProc());
            m_recvThread.IsBackground = true;
            m_recvThread.Start();

        }
        /// <summary>
        /// 异步连接的等待线程函数
        /// </summary>
        /// <param name="param"></param>
        private void ConnectWaitProc(object param)
        {
            int waitTime = (int)param;
            m_connectEvent.WaitOne(waitTime);
            Action action = () => this.EndConnect();
            action.Invoke();
        }

        /// <summary>
        /// 接收数据线程的线程函数
        /// </summary>
        private void RecvProc()
        {
            if (OnConnectionChanged != null)
            {
                OnConnectionChanged(this, true);
            }
            byte[] buffer = new byte[4];
            while (m_bRunning)
            {
                //提取包长
                int dataLen = 0;
                if (CommunicationCommon.ReadAllData(m_netWorkStream, buffer, 4))
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
                    if (CommunicationCommon.ReadAllData(m_netWorkStream, buffer, dataLen))
                    {
                        if (OnReceiveData != null)
                        {
                            OnReceiveData((IPEndPoint)m_ipEndPoint, buffer);
                        }
                    }
                    else
                    {
                        break;
                    }
                }
            }

            m_netWorkStream.Close();
            m_tcpClient.Close();
            m_bRunning = false;
            if (OnConnectionChanged != null)
            {
                OnConnectionChanged(this, false);
            }
        }

        #endregion

        #region 公有方法

        /// <summary>
        /// 同步连接到一个IP
        /// </summary>
        /// <param name="strIp">IP地址</param>
        /// <param name="nPort">端口</param>
        /// <param name="timeOut">超时</param>
        /// <returns>成功:true;失败：false</returns>
        public bool Connect(string strIp, UInt16 nPort, int timeOut)
        {
            m_serverIP = strIp;
            m_serverPort = nPort;
            m_connectEvent.Reset();
            m_tcpClient = new TcpClient();
            try
            {
                CommunicationCommon.SetKeepAlive(m_tcpClient.Client, 5000, 1500);
                m_tcpClient.BeginConnect(IPAddress.Parse(strIp), nPort, new AsyncCallback(ConnAsyncCallback), m_tcpClient);
                m_connectEvent.WaitOne(timeOut);
                if (m_tcpClient.Connected)
                {
                    InitWorkers();
                    return true;
                }
                else
                {
                    m_tcpClient.Close();
                    m_bRunning = false;
                    return false;
                }
            }
            catch (System.Exception ex)
            {
                m_strLastErrorMsg = ex.Message;
                return false;
            }

        }

        /// <summary>
        /// 异步连接到一个TCP服务器
        /// </summary>
        /// <param name="strIp">IP地址</param>
        /// <param name="nPort">端口</param>
        /// <param name="timeOut">超时</param>
        /// <returns></returns>
        public bool BeginConnect(string strIp, UInt16 nPort, int timeOut)
        {
            m_serverIP = strIp;
            m_serverPort = nPort;
            m_connectEvent.Reset();
            m_tcpClient = new TcpClient();
            try
            {
                m_connectWaitThread = new Thread(new ParameterizedThreadStart(ConnectWaitProc));
                m_connectWaitThread.IsBackground = true;
                m_tcpClient.BeginConnect(IPAddress.Parse(strIp), nPort, new AsyncCallback(ConnAsyncCallback), m_tcpClient);
                m_connectWaitThread.Start(timeOut);//启动延时线程
                return true;
            }
            catch (System.Exception ex)
            {
                m_strLastErrorMsg = ex.Message;
                return false;
            }
        }

        /// <summary>
        /// 强制断开连接
        /// </summary>
        public void Disconnect()
        {
            if (!m_bRunning)
            {
                return;
            }
            m_bRunning = false;
            m_netWorkStream.Close();
            m_tcpClient.Close();
            m_recvThread.Join();
            m_recvThread = null;
        }



        #endregion

    }
}
