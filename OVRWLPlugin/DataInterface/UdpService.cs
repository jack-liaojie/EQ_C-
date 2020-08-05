using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Data;
using System.Windows.Forms;

namespace AutoSports.OVRWLPlugin
{
    public delegate void UpdateDataViewEventHandler(DataGridView dgv);
    public delegate void ReceiveDataEventHandler(DataTable ts_dt);
    public delegate void UpdateDataEventHandler();
    public delegate void ToDBReceiveDataEventHandler();

    public class WLUdpService
    {
        public static ReceiveDataEventHandler ReceivedData;
        public static ToDBReceiveDataEventHandler ToDBReceivedData;

        public static WLUdpService udpService = null;
        public static bool running = false;
        public static Thread udpThread;
        public static bool toDB = false;

        private static IPEndPoint _myEndPoint = new IPEndPoint(IPAddress.Any, 30000);
        private static UdpClient _myUdpClient = new UdpClient(_myEndPoint);
        private static DataTable ts_dt = null;

        public static void Start()
        {
            running = true;
            udpService = new WLUdpService();
            udpService.Working();
        }
        public static void Stop()
        {
            running = false;
            if (udpThread != null && udpThread.ThreadState == ThreadState.Running)
                udpThread.Abort();
        }

        void Working()
        {
            udpThread = new Thread(OnUdpProcess);
            udpThread.IsBackground = true;
            udpThread.Start();
        }

        void OnUdpProcess()
        {
            while (running)
            {
                try
                {
                    if (toDB)
                    {
                        UdpHandlerToDB();
                        if (ToDBReceivedData != null)
                            ToDBReceivedData();
                    }
                    else
                    {
                        UdpHandler();
                        if (ReceivedData != null && ts_dt != null)
                            ReceivedData(ts_dt);
                    }
                }
                catch
                {
                    continue;
                }
            }
            Thread.Sleep(1000);
        }

        void UdpHandler()
        {
            IPEndPoint _toEndPoint = new IPEndPoint(IPAddress.Any, 0);
            byte[] data = _myUdpClient.Receive(ref _toEndPoint);

            ts_dt = InfoAnalyze.GetPlayerListData(data);
        }
        void UdpHandlerToDB()
        {
            IPEndPoint _toEndPoint = new IPEndPoint(IPAddress.Any, 0);
            byte[] data = _myUdpClient.Receive(ref _toEndPoint);

            InfoAnalyze.UpdatePlayerListData(data);
        }
    }
}
