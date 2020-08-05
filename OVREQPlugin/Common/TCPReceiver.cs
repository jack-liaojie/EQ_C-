using System;
using System.Collections.Generic;
//using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Threading;
using System.Net;
using System.Windows.Forms;
using System.IO;
using System.IO.Ports;

namespace AutoSports.OVREQPlugin
{
    public delegate void DataReceivedHanlder(byte[] bytesData, int dataLength);
    public delegate void TCPServerDisconnectedHanlder();
    public class TCPReceiver : IDisposable
    {
        #region Field
        private TcpClient tcp;
        private bool isConnected;
        private Boolean disposed = false;
        private Thread receiveThread;
        private NetworkStream stream;
        public event DataReceivedHanlder DataReceived;
        public event TCPServerDisconnectedHanlder TCPServerDisconnected;
        public Boolean IsConnected
        {
            get
            {
                if (tcp == null)
                {
                    return false;
                }
                else
                {
                    return this.isConnected && tcp.Connected;
                }
            }
        }
        #endregion

        #region Method
        public TCPReceiver()
        {
            tcp = new TcpClient();
            stream = null;
            DataReceived = null;
            isConnected = false;
            tcp.LingerState = new LingerOption(false, 0);
        }
        public void TCPClose()
        {
            if (tcp != null)
                tcp.Close();
        }
        public bool Connect(string server, int port)
        {
            bool result = false;
            try
            {

                if (tcp == null)
                {
                    tcp = new TcpClient();
                }
                else
                {
                    if (!tcp.Connected)
                    {
                        try
                        {
                            tcp.Connect(server, port);
                            isConnected = tcp.Connected;
                            stream = tcp.GetStream();
                            if (stream != null && stream.CanRead)
                            {
                                //开新线程接收网络流数据
                                receiveThread = new Thread(new ThreadStart(Receive));
                                receiveThread.IsBackground = true;
                                receiveThread.Start();
                            }
                            result = true;
                        }
                        catch (SocketException e)
                        {
                            result = false;
                            MessageBox.Show(e.Message);
                        }
                    }
                }

            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message.ToString());
                result = false;
            }
            return result;

        }
        public void Send(string message)
        {
            try
            {
                Byte[] bytes = System.Text.Encoding.ASCII.GetBytes(message);
                if (tcp != null && tcp.Connected)
                {
                    stream = tcp.GetStream();
                    stream.Write(bytes, 0, bytes.Length);
                }
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message.ToString());
            }
        }
        private void Receive()
        {
            //后台线程Receive从网络流轮询获取数据
            while (true)
            {
                if (tcp != null && tcp.Connected)
                {
                    try
                    {
                        //初始化缓存空间
                        Byte[] buffer = new Byte[tcp.ReceiveBufferSize];
                        //读取网络流的数据到缓存
                        int bytesReaded = stream.Read(buffer, 0, buffer.Length);
                        // If no data any more or the Server is closed, Close Client itself.
                        if (bytesReaded <= 0)
                        {
                            isConnected = false;
                            stream.Close();
                            tcp.Close();
                            GVAR.MsgBox("Timming server disconnected!");
                            if (TCPServerDisconnected != null)
                                //将连接uncheck
                                TCPServerDisconnected();
                            receiveThread.Abort();  
                        }
                        if (DataReceived != null)
                            //交给GetSlalomMessage（得到有效的数据帧）解析
                            DataReceived(buffer, bytesReaded);
                    }
                    catch (IOException ie)
                    {
                        isConnected = false;
                        stream.Close();
                        tcp.Close();
                        tcp = null;
                        MessageBox.Show(ie.Message.ToString());
                        if (TCPServerDisconnected != null)
                            //将连接uncheck
                            TCPServerDisconnected();
                        receiveThread.Abort();
                    }
                    catch (SocketException e)
                    {
                        isConnected = false;
                        stream.Close();
                        tcp.Close();
                        tcp = null;
                        MessageBox.Show(e.Message.ToString());
                        if (TCPServerDisconnected != null)
                            //将连接uncheck
                            TCPServerDisconnected();
                        receiveThread.Abort();
                    }
                }
            }
        }
        #endregion

        #region IDisposable Members

        public void Dispose()
        {
            Dispose(true);
        }
        private void Dispose(bool disposing)
        {
            if (!disposed && disposing)
            {
                if (stream != null)
                    stream.Close();
                if (tcp != null)
                    tcp.Close();
                CloseThread();
                disposed = true;
            }
        }

        private void CloseThread()
        {
            if (receiveThread != null)
                receiveThread.Abort();
        }

        #endregion
    }
}
