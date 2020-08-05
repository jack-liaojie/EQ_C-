using System;
using System.Collections;
using System.Text;
using System.Net.Sockets;
using System.Net;
using System.Threading;


namespace AutoSports.OVRManagerApp
{
    public delegate void OVRSocketAcceptedHandler(string strEndPoint);

    public delegate void OVRSocketErrorHandler(string strEndPoint, System.Net.Sockets.SocketError errorCode);

    public delegate void OVRSocketDataHandler(string strEndPoint, OVRSocketBuffer buffer);

    public class OVRSocketBuffer
    {
        public OVRSocketBuffer()
        {
            m_buffer = null;
            m_iDataBytes = 0;
        }

        public OVRSocketBuffer(int size)
        {
            if (size <= 0)
            {
                m_buffer = null;
                m_iDataBytes = 0;
                return;
            }

            m_buffer = new Byte[size];
            m_iDataBytes = 0;
        }

        public void ReAlloc(int size)
        {
            if (size <= 0)
            {
                m_buffer = null;
                m_iDataBytes = 0;
                return;
            }

            if (m_buffer != null && size == m_buffer.Length)
            {
                m_iDataBytes = 0;
                return;
            }

            m_buffer = new Byte[size];
            m_iDataBytes = 0;
        }

        public Byte[] Buffer
        {
            get { return m_buffer; }
        }

        public int Size
        {
            get { return m_buffer == null ? 0 : m_buffer.Length; }
        }

        public int DataBytes
        {
            get { return m_iDataBytes; }
            set { m_iDataBytes = value; }
        }

        private Byte[] m_buffer;
        private int m_iDataBytes;
    }

    public class OVRSocketClient
    {
        private int MAX_QUEUE_SIZE = 100;
        private int BUFFER_SIZE = 256 * 1024;
        private byte[] keep_alive;

        private TcpClient client;
        private Thread threadSend;
        private Thread threadReceive;

        private object syncStop = new object();
        private EventWaitHandle eventReceiveStop;
        private EventWaitHandle eventSendStop;
        private EventWaitHandle eventConnectionDroped;
        private AutoResetEvent eventSendData;

        private OVRSocketBuffer sendBuffer;
        private Queue sendBufferQueue;

        public event OVRSocketDataHandler EventDataReceived;
        public event OVRSocketErrorHandler EventConnectionDroped;
        public event OVRSocketErrorHandler EventSocketError;

        private string strRemoteEndPoint = "NONE";
        public string RemoteEndPoint
        {
            get
            {
                lock (strRemoteEndPoint)
                {
                    return strRemoteEndPoint;
                }
            }
        }


        public OVRSocketClient()
        {
            client = null;
            EventDataReceived = null;
            EventConnectionDroped = null;
            EventSocketError = null;
            eventReceiveStop = new EventWaitHandle(true, EventResetMode.ManualReset);
            eventSendStop = new EventWaitHandle(true, EventResetMode.ManualReset);
            eventConnectionDroped = new EventWaitHandle(false, EventResetMode.ManualReset);
            eventSendData = new AutoResetEvent(false);
            sendBuffer = new OVRSocketBuffer();
            sendBufferQueue = new Queue();

            keep_alive = new byte[sizeof(uint) * 3];
            //OnOff
            //    - This parameter determines whether keep alive is on or off.  0: off, 1: on
            BitConverter.GetBytes((uint)1).CopyTo(keep_alive, 0);
            //KeepAliveInterval 
            //    - This parameter determines the interval separating keep alive retransmissions until a response is received. 
            BitConverter.GetBytes((uint)5000).CopyTo(keep_alive, sizeof(uint));
            //KeepAliveTime 
            //    - This parameter controls how often TCP attempts to verify that an idle connection is still intact by sending a keep alive packet. 
            BitConverter.GetBytes((uint)1000).CopyTo(keep_alive, sizeof(uint) * 2);
        }

        public OVRSocketClient(TcpClient tcpClient)
        {
            client = tcpClient;
            EventDataReceived = null;
            EventConnectionDroped = null;
            EventSocketError = null;
            eventReceiveStop = new EventWaitHandle(true, EventResetMode.ManualReset);
            eventSendStop = new EventWaitHandle(true, EventResetMode.ManualReset);
            eventConnectionDroped = new EventWaitHandle(false, EventResetMode.ManualReset);
            eventSendData = new AutoResetEvent(false);
            sendBuffer = new OVRSocketBuffer();
            sendBufferQueue = new Queue();

            keep_alive = new byte[sizeof(uint) * 3];
            //OnOff
            //    - This parameter determines whether keep alive is on or off. 0: off, 1: on
            BitConverter.GetBytes((uint)1).CopyTo(keep_alive, 0);
            //KeepAliveInterval 
            //    - This parameter determines the interval separating keep alive retransmissions until a response is received. 
            BitConverter.GetBytes((uint)5000).CopyTo(keep_alive, sizeof(uint));
            //KeepAliveTime 
            //    - This parameter controls how often TCP attempts to verify that an idle connection is still intact by sending a keep alive packet. 
            BitConverter.GetBytes((uint)1000).CopyTo(keep_alive, sizeof(uint) * 2);

            lock (strRemoteEndPoint)
            {
                strRemoteEndPoint = client.Client.RemoteEndPoint.ToString();
            }
        }

        public bool Start(string hostName, int port)
        {
            Stop();

            try
            {
                this.client = new TcpClient();
                IAsyncResult iAsyncRes = this.client.BeginConnect(hostName, port, new AsyncCallback(ConnectCallback), this.client);
                if (!iAsyncRes.AsyncWaitHandle.WaitOne(2000))
                {
                    this.client.Client.Close();
                    return false;
                }
            }
            catch (System.Net.Sockets.SocketException ex)
            {
                System.Diagnostics.Trace.Write("Connection Error: " + ex.Message + " Error Code: " + ex.SocketErrorCode.ToString() + "\n");

                return false;
            }
            catch (ArgumentException ex)
            {
                System.Diagnostics.Trace.Write("Connection Error: " + ex.Message + "\n");

                return false;
            }

            if (!this.client.Client.Connected)
            {
                this.client.Client.Close();
                this.client.Close();
                return false;
            }

            lock (strRemoteEndPoint)
            {
                strRemoteEndPoint = client.Client.RemoteEndPoint.ToString();
            }

            return Start();
        }

        public bool Start()
        {
            if (this.client == null || this.client.Client == null || !this.client.Client.Connected)
                return false;

            if (threadSend != null && threadSend.ThreadState != ThreadState.Stopped)
            {
                threadSend.Abort();
                threadSend = null;
            }
            if (threadReceive != null && threadReceive.ThreadState != ThreadState.Stopped)
            {
                threadReceive.Abort();
                threadReceive = null;
            }

            sendBuffer.ReAlloc(BUFFER_SIZE);
            sendBufferQueue.Clear();

            this.client.Client.IOControl(IOControlCode.KeepAliveValues, keep_alive, null);

            threadReceive = new Thread(new ThreadStart(Receive));
            threadReceive.Start();
            threadSend = new Thread(new ThreadStart(Send));
            threadSend.Start();

            return true;
        }

        public void Stop()
        {
            lock (syncStop)
            {
                if (this.client == null)
                    return;

                System.Diagnostics.Trace.Write("Initiative Stop Begin: " + strRemoteEndPoint + "\n");

                bool bConnected = this.client.Client == null ? false : this.client.Connected;

                CloseSocket(null);

                if (threadSend != null && threadSend.ThreadState != ThreadState.Stopped &&
                    !eventSendStop.WaitOne(5000) && threadSend.ThreadState != ThreadState.Stopped)
                {
                    threadSend.Abort();
                }
                threadSend = null;

                if (threadReceive != null && threadReceive.ThreadState != ThreadState.Stopped &&
                    !eventReceiveStop.WaitOne(5000) && threadReceive.ThreadState != ThreadState.Stopped)
                {
                    threadReceive.Abort();
                }
                threadReceive = null;

                if (EventConnectionDroped != null && bConnected)
                    EventConnectionDroped(this.RemoteEndPoint, SocketError.ConnectionAborted);

                System.Diagnostics.Trace.Write("Initiative Stop End: " + strRemoteEndPoint + "\n");
            }
        }

        public bool SendMessage(string message)
        {
            if (message == null) return true;

            lock (this.client)
            {
                if (this.client == null || this.client.Client == null || !this.client.Client.Connected)
                    return false;
            }

            bool bQueueIt = true;

            if (Monitor.TryEnter(sendBuffer, 100))
            {
                try
                {
                    if (sendBuffer.DataBytes < 1)   // sendBuffer is Empty
                    {
                        // Put message in sendBuffer
                        int iByteCount = Encoding.UTF8.GetByteCount(message);
                        if (iByteCount + 5 > sendBuffer.Size)
                        {
                            sendBuffer.ReAlloc(iByteCount * 2);
                            System.Diagnostics.Trace.Write("sendBuffer.ReAlloc.\n");
                        }

                        sendBuffer.Buffer[0] = 0x01; //sendBuffer.Buffer[1] = 0x00; // SOH
                        int iBytes = Encoding.UTF8.GetBytes(message, 0, message.Length, sendBuffer.Buffer, 5);
                        BitConverter.GetBytes(iBytes).CopyTo(sendBuffer.Buffer, 1);
                        //sendBuffer.Buffer[iBytes + 2] = 0x04; sendBuffer.Buffer[iBytes + 3] = 0x00; // EOT

                        sendBuffer.DataBytes = iBytes + 5;

                        System.Diagnostics.Trace.Write("Data Filled in sendBuffer.\n");

                        bQueueIt = false;
                    }
                }
                finally
                {
                    Monitor.Exit(sendBuffer);
                }
            }

            if (bQueueIt)  // queue it...
            {
                lock (sendBufferQueue)
                {
                    if (sendBufferQueue.Count >= MAX_QUEUE_SIZE)   // sendBufferQueue Overflow.
                        return false;

                    int iByteCount = Encoding.Unicode.GetByteCount(message);
                    OVRSocketBuffer buffer = new OVRSocketBuffer(iByteCount + 5);

                    sendBuffer.Buffer[0] = 0x01; //sendBuffer.Buffer[1] = 0x00; // SOH
                    int iBytes = Encoding.UTF8.GetBytes(message, 0, message.Length, sendBuffer.Buffer, 5);
                    BitConverter.GetBytes(iBytes).CopyTo(sendBuffer.Buffer, 1);
                    //sendBuffer.Buffer[iBytes + 2] = 0x04; sendBuffer.Buffer[iBytes + 3] = 0x00; // EOT

                    sendBuffer.DataBytes = iBytes + 5;

                    sendBufferQueue.Enqueue(buffer);

                    System.Diagnostics.Trace.Write("Data Enqueued at sendBufferQueue: " + sendBufferQueue.Count.ToString() + "\n");
                }
            }

            eventSendData.Set();

            return true;
        }

        public bool SendData(Byte[] data)
        {
            lock (this.client)
            {
                if (this.client == null || this.client.Client == null || !this.client.Client.Connected)
                    return false;
            }

            bool bQueueIt = true;

            if (Monitor.TryEnter(sendBuffer, 100))
            {
                try
                {
                    if (sendBuffer.DataBytes < 1)   // sendBuffer is Empty
                    {
                        // Put message in sendBuffer
                        if (data.Length > sendBuffer.Size)
                        {
                            sendBuffer.ReAlloc(data.Length);
                            System.Diagnostics.Trace.Write("sendBuffer.ReAlloc.\n");
                        }

                        data.CopyTo(sendBuffer.Buffer, 0);
                        sendBuffer.DataBytes = data.Length;

                        System.Diagnostics.Trace.Write("Data Filled in sendBuffer.\n");

                        bQueueIt = false;
                    }
                }
                finally
                {
                    Monitor.Exit(sendBuffer);
                }
            }

            if (bQueueIt)  // queue it...
            {
                lock (sendBufferQueue)
                {
                    if (sendBufferQueue.Count >= MAX_QUEUE_SIZE)   // sendBufferQueue Overflow.
                        return false;

                    OVRSocketBuffer buffer = new OVRSocketBuffer(data.Length);
                    data.CopyTo(buffer.Buffer, 0);
                    buffer.DataBytes = data.Length;
                    sendBufferQueue.Enqueue(buffer);

                    System.Diagnostics.Trace.Write("Data Enqueued at sendBufferQueue: " + sendBufferQueue.Count.ToString() + "\n");
                }
            }

            eventSendData.Set();

            return true;
        }

        private void CloseSocket(SocketException ex)
        {
            lock (this.client)
            {
                if (this.client.Client != null && client.Client.Connected)
                {
                    System.Diagnostics.Trace.Write("Socket Closing: " + strRemoteEndPoint + "\n");
                    client.Client.Close(-1);
                    System.Diagnostics.Trace.Write("Socket Closed: " + strRemoteEndPoint + "\n");

                    client.Close();
                }
            }
        }

        private void ConnectCallback(IAsyncResult ar)
        {
            TcpClient s = (TcpClient)ar.AsyncState;
            if (!ar.IsCompleted)
                s.EndConnect(ar);
        }

        private void Receive()
        {
            if (this.client == null)
                return;

            eventReceiveStop.Reset();

            System.Diagnostics.Trace.Write("Receive Thread Enter: " + strRemoteEndPoint + "\n");

            OVRSocketBuffer rcvdBuffer = new OVRSocketBuffer(BUFFER_SIZE);
            while (true)
            {
                try
                {
                    int bytesReaded = client.Client.Receive(rcvdBuffer.Buffer);
                    // If no data any more or the Server is closed, Close Client itself.client.ReceiveBufferSize
                    if (bytesReaded <= 0)
                    {
                        System.Diagnostics.Trace.Write("Receive Thread Break On Disconnect: " + strRemoteEndPoint + "\n");

                        eventConnectionDroped.Set();

                        System.Diagnostics.Trace.Write("OnConnectionDroped Called At Receive Disconnect: " + strRemoteEndPoint + "\n");

                        if (EventConnectionDroped != null)
                            EventConnectionDroped(this.RemoteEndPoint, SocketError.ConnectionReset);

                        break;
                    }

                    rcvdBuffer.DataBytes += bytesReaded;

                    System.Diagnostics.Trace.Write("Receive Bytes: " + bytesReaded.ToString() + "\n");

                    // Process Received Data
                    if (EventDataReceived != null)
                    {
                        EventDataReceived(this.RemoteEndPoint, rcvdBuffer);
                    }

                    // Reset Received Buffer
                    rcvdBuffer.DataBytes = 0;
                }
                catch (SocketException ex)
                {
                    if (IsConnectionDroped(ex.SocketErrorCode))
                    {
                        System.Diagnostics.Trace.Write("Receive Thread Break On Exception: " + strRemoteEndPoint + "---" + ex.Message + "Error Code: " + ex.SocketErrorCode.ToString() + "\n");

                        eventConnectionDroped.Set();

                        if (Monitor.TryEnter(syncStop, 10)) // 如果进入则表明Socket不是主动关闭的。

                        {
                            System.Diagnostics.Trace.Write("OnConnectionDroped Called At Receive Exception: " + strRemoteEndPoint + "\n");

                            try
                            {
                                if (EventConnectionDroped != null)
                                    EventConnectionDroped(this.RemoteEndPoint, ex.SocketErrorCode);
                            }
                            finally
                            {
                                Monitor.Exit(syncStop);
                            }
                        }

                        break;
                    }
                    else
                    {
                        System.Diagnostics.Trace.Write("Receive Error: " + strRemoteEndPoint + "---" + ex.Message + "Error Code: " + ex.SocketErrorCode.ToString() + "\n");

                        if (EventSocketError != null)
                            EventSocketError(this.RemoteEndPoint, ex.SocketErrorCode);
                    }
                }
            }

            System.Diagnostics.Trace.Write("Receive Thread Exit: " + strRemoteEndPoint + "\n");

            eventReceiveStop.Set();
        }

        private void Send()
        {
            if (this.client == null)
                return;

            eventSendStop.Reset();
            eventConnectionDroped.Reset();

            System.Diagnostics.Trace.Write("Send Thread Enter: " + strRemoteEndPoint + "\n");
            Queue workQueue = new Queue();

            WaitHandle[] handles = new WaitHandle[2];
            handles[0] = eventConnectionDroped;
            handles[1] = eventSendData;
            while (true)
            {
                try
                {
                    int index = WaitHandle.WaitAny(handles);

                    if (index == 0)
                        break;

                    // Get Data In sendBufferQueue
                    lock (sendBufferQueue)
                    {
                        if (sendBufferQueue.Count > 0)
                        {
                            foreach (OVRSocketBuffer buffer in sendBufferQueue)
                            {
                                workQueue.Enqueue(buffer);
                            }
                            sendBufferQueue.Clear();

                            System.Diagnostics.Trace.Write("sendBufferQueue Moved to workQueue.\n");
                        }
                    }

                    // Send Data in sendBuffer
                    lock (sendBuffer)
                    {
                        if (sendBuffer.DataBytes > 0)
                        {
                            System.Diagnostics.Trace.Write("Data Sending in sendBuffer.\n");
                            int bytesSend = 0;
                            while (sendBuffer.DataBytes > bytesSend)
                            {
                                bytesSend += client.Client.Send(sendBuffer.Buffer, bytesSend, sendBuffer.DataBytes - bytesSend, SocketFlags.None);
                            }
                            sendBuffer.DataBytes = 0;
                            System.Diagnostics.Trace.Write(String.Format("Data Sent in sendBuffer: {0}B.\n", bytesSend));
                        }
                    }

                    // Send Data in workQueue
                    foreach (OVRSocketBuffer buffer in workQueue)
                    {
                        System.Diagnostics.Trace.Write("Data Sending in workQueue.\n");
                        int bytesSend = 0;
                        while (buffer.DataBytes > bytesSend)
                        {
                            bytesSend += client.Client.Send(buffer.Buffer, bytesSend, buffer.DataBytes - bytesSend, SocketFlags.None);
                        }
                        System.Diagnostics.Trace.Write(String.Format("Data Sent in workQueue: {0}B.\n", bytesSend));
                    }
                    if (workQueue.Count > 0)
                    {
                        workQueue.Clear();
                    }
                }
                catch (SocketException ex)
                {
                    if (IsConnectionDroped(ex.SocketErrorCode))
                    {
                        System.Diagnostics.Trace.Write("Send Thread Break On Exception: " + strRemoteEndPoint + "---" + ex.Message + "Error Code: " + ex.SocketErrorCode.ToString() + "\n");

                        break;
                    }
                    else
                    {
                        System.Diagnostics.Trace.Write("Send Error: " + strRemoteEndPoint + "---" + ex.Message + "Error Code: " + ex.SocketErrorCode.ToString() + "\n");

                        if (EventSocketError != null)
                            EventSocketError(this.RemoteEndPoint, ex.SocketErrorCode);
                    }
                }
            }

            System.Diagnostics.Trace.Write("Send Thread Exit: " + strRemoteEndPoint + "\n");

            eventSendStop.Set();
        }

        private bool IsConnectionDroped(SocketError error)
        {
            switch (error)
            {
                case SocketError.ConnectionAborted:
                case SocketError.ConnectionRefused:
                case SocketError.ConnectionReset:
                case SocketError.Disconnecting:
                case SocketError.HostDown:
                case SocketError.HostNotFound:
                case SocketError.HostUnreachable:
                case SocketError.Interrupted:
                case SocketError.NetworkDown:
                case SocketError.NetworkReset:
                case SocketError.NetworkUnreachable:
                case SocketError.NotConnected:
                case SocketError.Shutdown:
                    return true;
            }

            return false;
        }
    }

    public class OVRSocketsServer
    {
        private TcpListener listen;
        private Thread threadListen;
        private EventWaitHandle eventListenStop;
        private ArrayList clientsList;
        private string strListeningLocalEndPoint = "NONE";
        public string ListeningLocalEndPoint
        {
            get
            {
                lock (strListeningLocalEndPoint)
                {
                    return strListeningLocalEndPoint;
                }
            }
        }

        public event OVRSocketAcceptedHandler EventClientAccepted;
        public event OVRSocketDataHandler EventDataReceived;
        public event OVRSocketErrorHandler EventConnectionDroped;
        public event OVRSocketErrorHandler EventSocketError;

        public OVRSocketsServer()
        {
            listen = null;
            EventClientAccepted = null;
            EventDataReceived = null;
            EventConnectionDroped = null;
            EventSocketError = null;
            eventListenStop = new EventWaitHandle(true, EventResetMode.ManualReset);
            clientsList = new ArrayList();
        }

        public bool StartListen(IPAddress localAddr, int port)
        {
            StopListen();

            bool bValidAddr = false;
            IPAddress[] addrList = Dns.GetHostEntry(Dns.GetHostName()).AddressList;
            for (int i = 0; i < addrList.Length; i++)
            {
                if (localAddr.Equals(addrList[i]))
                {
                    bValidAddr = true;
                    break;
                }
            }

            if (!bValidAddr) return false;

            listen = new TcpListener(localAddr, port);

            lock (strListeningLocalEndPoint)
            {
                strListeningLocalEndPoint = listen.LocalEndpoint.ToString();
            }

            threadListen = new Thread(new ThreadStart(Listen));

            try
            {
                listen.Start();
                threadListen.Start();
            }
            catch (System.Exception ex)
            {
                System.Diagnostics.Trace.Write(ex.Message + "\n");

                StopListen();

                return false;
            }
            return true;
        }

        public void StopListen()
        {
            if (listen != null)
            {
                listen.Stop();
                listen = null;
            }

            WaitHandle[] handles = new WaitHandle[1];
            handles[0] = eventListenStop;
            int iRes = WaitHandle.WaitAny(handles, 20000);
            if (threadListen != null && threadListen.ThreadState != ThreadState.Stopped && iRes == WaitHandle.WaitTimeout)
            {
                threadListen.Abort();
                threadListen = null;
            }
        }

        public void StopClient(string strEndPoint)
        {
            for (int i = clientsList.Count - 1; i >= 0; i--)
            {
                OVRSocketClient client = ((OVRSocketClient)clientsList[i]);
                if (client.RemoteEndPoint == strEndPoint)
                {
                    client.Stop();
                    break;
                }
            }
        }

        public void StopAllClients()
        {
            for (int i = clientsList.Count - 1; i >= 0; i--)
            {
                ((OVRSocketClient)clientsList[i]).Stop();
            }
            clientsList.Clear();
        }

        public void BroadcastMessage(string message)
        {
            if (message == null) return;

            lock (clientsList)
            {
                for (int i = clientsList.Count - 1; i >= 0; i--)
                {
                    OVRSocketClient client = (OVRSocketClient)clientsList[i];
                    if (client != null)
                    {
                        client.SendMessage(message);
                    }
                }
            }
        }

        private void Listen()
        {
            eventListenStop.Reset();
            try
            {
                System.Diagnostics.Trace.Write("Listen Start.\n");

                while (true)
                {
                    TcpClient client = listen.AcceptTcpClient();

                    OVRSocketClient socketClient = new OVRSocketClient(client);
                    socketClient.EventConnectionDroped += new OVRSocketErrorHandler(OnConnectionDroped);
                    socketClient.EventSocketError += new OVRSocketErrorHandler(OnSocketError);
                    socketClient.EventDataReceived += new OVRSocketDataHandler(OnSocketData);

                    socketClient.Start();
                    clientsList.Add(socketClient);

                    if (EventClientAccepted != null)
                    {
                        EventClientAccepted(socketClient.RemoteEndPoint);
                    }

                    System.Diagnostics.Trace.Write("Client Added.\n");
                }
            }
            catch (SocketException ex)
            {

            }
            finally
            {
                if (listen != null)
                {
                    listen.Stop();
                    listen = null;
                }
            }
            System.Diagnostics.Trace.Write("Listen Stop.\n");

            eventListenStop.Set();
        }

        private void OnConnectionDroped(string strEndPoint, SocketError errorCode)
        {
            if (EventConnectionDroped != null)
                EventConnectionDroped(strEndPoint, errorCode);

            lock (clientsList)
            {
                for (int i = clientsList.Count - 1; i >= 0; i--)
                {
                    if (((OVRSocketClient)clientsList[i]).RemoteEndPoint == strEndPoint)
                    {
                        clientsList.RemoveAt(i);
                        break;
                    }
                }
            }
        }

        private void OnSocketError(string strEndPoint, SocketError errorCode)
        {
            if (EventSocketError != null)
                EventSocketError(strEndPoint, errorCode);
        }

        private void OnSocketData(string strEndPoint, OVRSocketBuffer data)
        {
            if (EventDataReceived != null)
                EventDataReceived(strEndPoint, data);
        }
    }
}
