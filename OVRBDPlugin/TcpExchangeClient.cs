using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Net;
using System.Threading;
using System.IO;

namespace AutoSports.OVRBDPlugin
{
    public class NotifyData
    {
        public NotifyData(string key,object obj)
        {
            Key = key;
            Obj = obj;
        }
        public string Key;
        public object Obj;
    }
    public class TcpExchangeClient
    {
        private static ManualResetEvent TimeoutObject_ = new ManualResetEvent(false);
        public TcpExchangeClient()
        {
            tcpClient_ = new TcpClient();
        }
        private TcpClient tcpClient_;
        private string remoteIP_;
        private int nPort_;
        private NetworkStream netWorkStream_;
        private Thread recvThread_;
       // private Thread sendHeartThread_;
        private ManualResetEvent recvEvent_ = new ManualResetEvent(false);
       // private ManualResetEvent heartExitEvent_ = new ManualResetEvent(false);
      //  private ManualResetEvent heartWaitEvent_ = new ManualResetEvent(false);
        private bool bRunning_;
        private bool bChatClient_;

        public bool Connect(string strIp, int nPort)
        {
            remoteIP_ = strIp;
            nPort_ = nPort;
            TimeoutObject_.Reset();
            tcpClient_ = new TcpClient();
            tcpClient_.BeginConnect(IPAddress.Parse(remoteIP_), nPort_, new AsyncCallback(ConnAsyncCallback), tcpClient_);
            TimeoutObject_.WaitOne(3000, false);
            if ( tcpClient_.Connected )
            {
                bChatClient_ = false;
                netWorkStream_ = tcpClient_.GetStream();
                recvThread_ = new Thread(new ThreadStart(RecvProc));
                recvThread_.IsBackground = true;
                recvThread_.Start();

                //sendHeartThread_ = new Thread(new ThreadStart(SendHeartProc));
                //sendHeartThread_.IsBackground = true;
                //sendHeartThread_.Start();
                if (!bChatClient_)
                {
                    System.Threading.Thread.Sleep(200);
                    if (SendStringData("CCCCCCCC"))
                    {
                        bChatClient_ = true;
                    }
                }
                return true;
            }
            else
            {
                tcpClient_.Close();
                return false;
            }
            
        }

        private static bool ReadAllData(NetworkStream netStream, byte[] buffer, int size)
        {
            int readTotal = 0;
            int readSingle = 0;
            while (readTotal < size)
            {
                try
                {
                    readSingle = netStream.Read(buffer, readTotal, size - readTotal);
                    if (readSingle == 0)
                    {
                        return false;
                    }
                    readTotal += readSingle;
                }
                catch (System.Exception e)
                {
                    return false;
                }
            }
            return true;
        }

        //public void SendHeartProc()
        //{
        //    heartExitEvent_.Reset();
        //    heartWaitEvent_.Reset();
        //    while(bRunning_)
        //    {
        //        heartWaitEvent_.WaitOne(10000);
        //        byte[] sendData = MakePackage(BitConverter.GetBytes((UInt32)0xFFFF0000));
        //        SendData(sendData);
        //    }
        //    heartExitEvent_.Set();
        //}
        public void RecvProc()
        {
            recvEvent_.Reset();
            byte[] buffer = new byte[1024 * 1024];
            bRunning_ = true;
            while (bRunning_)
            {
                //包头
                if (ReadAllData(netWorkStream_, buffer, 4))
                {
                    UInt32 header = BitConverter.ToUInt32(buffer, 0);
                    if (header != 0xFFFFFFFF)
                    {
                        continue;
                    }
                }
                else
                {
                    break;
                }
                //包长
                int dataLen = 0;
                if (ReadAllData(netWorkStream_, buffer, 4))
                {
                    dataLen = BitConverter.ToInt32(buffer, 0);
                    if (dataLen <= 0 || dataLen > 1024 * 1024)
                    {
                        continue;
                    }
                }
                else
                {
                    break;
                }
                if (ReadAllData(netWorkStream_, buffer, dataLen))
                {
                    if (dataLen == 4)
                    {
                        UInt32 heartFlag = BitConverter.ToUInt32(buffer, 0);
                        if (heartFlag == 0xFFFF0000)
                        {
                            continue;
                        }
                    }
                    string xml = System.Text.Encoding.UTF8.GetString(buffer, 0, dataLen);
                   // TTXmlItem item = new TTXmlItem(xml, dataLen, "TCP", "NULL", TTXmlItem.TTXmlItemType.NetTcp, new TTXmlExtraData(null, false), true);
                    DoInvoke(new NotifyData("ChatMsg", xml));
                    
                }
                else
                {
                    break;
                }
            }
            tcpClient_.Close();
            if ( netWorkStream_ != null )
            {
                netWorkStream_.Close();
            }
            
         
             
            
            netWorkStream_ = null;
            recvEvent_.Set();
            DoInvoke(new NotifyData("Disconnect", null));
        }
        public string LastErrorString {get;private set;}
        public void ConnAsyncCallback(IAsyncResult ar)
        {
            TimeoutObject_.Set();
        }
        public bool SendData(byte[] data)
        {
            if (!tcpClient_.Connected)
            {
                LastErrorString = "TCP连接已断开！";
                if (netWorkStream_ != null)
                {
                    netWorkStream_.Close();
                    netWorkStream_ = null;
                }
                
                tcpClient_.Close();
            }
            
            try
            {
                netWorkStream_.Write(data, 0, data.Length);
                return true;
            }
            catch (System.Exception e)
            {
                LastErrorString = e.Message;
                return false;
            }
        }

        public void Disconnect()
        {
            bRunning_ = false;
           // heartWaitEvent_.Set();//让心跳线程立即动作
            tcpClient_.Close();
            if ( netWorkStream_ != null )
            {
                netWorkStream_.Close();
                netWorkStream_ = null;
            }
           // heartExitEvent_.WaitOne();
            recvEvent_.WaitOne();
        }

        public bool SendStringData(string strData)
        {
            byte[] data = System.Text.Encoding.UTF8.GetBytes(strData);
            byte[] sendData = MakePackage(data);
            return SendData(sendData);
        }

        public bool SendChatMsg(string name,string strChatMsg)
        {
            if ( !bChatClient_)
            {
                if( SendStringData("CCCCCCCC") )
                {
                    bChatClient_ = true;
                }
            }
            string strChatData = string.Format("TTTTTTTT<MatchInfo><Chat Name=\"{0}\" IP=\"{1}\" Message=\"{2}\" /></MatchInfo>"
                , name, tcpClient_.Client.LocalEndPoint.ToString(), strChatMsg);
            return SendStringData(strChatData);
            
        }


        private byte[] MakePackage(byte []data)
        {
            MemoryStream stream = new MemoryStream();
            BinaryWriter writer = new BinaryWriter(stream);
            writer.Write((UInt32)0xFFFFFFFF);
            writer.Write(data.Length);
            writer.Write(data);
            writer.Flush();
            byte[] res = stream.ToArray();
            stream.GetBuffer();
            writer.Close();
            stream.Close();
            return res;
        }
        private void DoInvoke(NotifyData data)
        {
            if ( NotifyMsg == null )
            {
                return;
            }
            BDCommon.g_BDPlugin.GetModuleUI.Invoke(NotifyMsg, data);
        }
        public delegate void NotifyMsgDelegate(NotifyData obj);
        public NotifyMsgDelegate NotifyMsg { get; set; }

        public bool IsConnected
        {
            get
            {
                if ( tcpClient_ == null || tcpClient_.Connected == null)
                {
                    return false;
                }
                return tcpClient_.Connected;
            }
        }
    }
}
