using System;
using System.Collections.Generic;
using System.Text;
using System.Net.Sockets;
using System.Net;
using System.Threading;
using System.IO;
using System.Drawing;

namespace RomoteControl
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
        private ManualResetEvent recvEvent_ = new ManualResetEvent(false);
        private bool bRunning_;

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
                netWorkStream_ = tcpClient_.GetStream();
                recvThread_ = new Thread(new ThreadStart(RecvProc));
                recvThread_.IsBackground = true;
                recvThread_.Start();
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
                    ProcessMessage(buffer);
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
                netWorkStream_ = null;
            }
            if ( SocketExitEvent != null )
            {
                m_exUI.BeginInvoke(SocketExitEvent);
            }
            netWorkStream_ = null;
            recvEvent_.Set();
        }
        public void ProcessMessage(byte []data)
        {
            MemoryStream stream = new MemoryStream(data);
            BinaryReader reader = new BinaryReader(stream);
            PackageType pType = (PackageType)reader.ReadInt32();
            switch (pType)
            {
                case PackageType.DeskPicture:
                    int dataLen = reader.ReadInt32();
                    byte[] picData = reader.ReadBytes(dataLen);
                    MemoryStream picStream = new MemoryStream(picData);
                    Bitmap map = new Bitmap(picStream);
                    stream.Close();
                    m_exUI.BeginInvoke(new SetImageDelegate(SetBitmap), map);
                    break;
                case PackageType.MouseClick:
                  
                    break;
                case PackageType.MouseMove:
                    
                    break;
                case PackageType.RequestControl:
                   
                    break;
                case PackageType.KeybdEventDown:
                    
                    break;
                case PackageType.KeybdEventUp:
                    break;
            }
            reader.Close();
            stream.Close();
        }
        public delegate void SetImageDelegate(Bitmap map);
        public void SetBitmap( Bitmap map)
        {
            m_exUI.SetMonitorImage(map);
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
            tcpClient_.Close();
            if ( netWorkStream_ != null )
            {
                netWorkStream_.Close();
                netWorkStream_ = null;
            }
            recvEvent_.WaitOne();
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
        }
        public delegate void NotifyMsgDelegate(NotifyData obj);
        public NotifyMsgDelegate NotifyMsg { get; set; }
        public delegate void ExitDelegate();
        public event ExitDelegate SocketExitEvent;

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
        private RemoteUI m_exUI;
        public void SetUI( RemoteUI ui)
        {
            m_exUI = ui;
        }
    }
}
