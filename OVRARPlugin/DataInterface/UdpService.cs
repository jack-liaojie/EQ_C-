using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace AutoSports.OVRARPlugin
{
    public delegate void ReceiveDataEventHandler();

    public class ARUdpService
    {
        public static ReceiveDataEventHandler ReceivedData;

        public static ARUdpService udpService = null;
        public static bool running = false;
        public static Thread udpThread;

        private static IPEndPoint _myEndPoint = new IPEndPoint(IPAddress.Any, 16666);
        private static UdpClient _myUdpClient = new UdpClient(_myEndPoint);

        public static AR_MatchInfo CurMatchInfo = new AR_MatchInfo();

        public static void Start()
        {
            running = true;
            udpService = new ARUdpService();
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
                    UdpHandler();
                    if (ReceivedData != null)
                        ReceivedData();
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

            AR_InfoHead reciveHead = InfoAnalyze.GetInfoHead(data);

            //收到,发送反馈包 
            byte[] feedback = InfoAnalyze.GetFeedbackBytes(reciveHead);
            _myUdpClient.Send(feedback, feedback.Length, _toEndPoint);

            //组织各种包数据 - 发送
            if (reciveHead.TaskNum < 30)
            {
                //任务码10：人员信息 //任务码15：赛程安排 //任务码20：站位表 
                int phaseId = InfoAnalyze.GetReceiveInt32(data);//默认为0
                byte[] sendData = InfoAnalyze.GetSendBytes(reciveHead, phaseId);
                _myUdpClient.Send(sendData, sendData.Length, _toEndPoint);
            }
            else if (reciveHead.TaskNum == 30)// &&CurMatchInfo.MatchStatusID == 50) // 接收成绩数据
            { 
                    InfoAnalyze.InsertArrowResultToOvr(data); 
            }
            else if (reciveHead.TaskNum == 31)// && CurMatchInfo.MatchStatusID == 50) // 接收附加赛成绩数据
            {
                InfoAnalyze.InsertArrowShootOffToOvr(data);
            } 
        }
    }
}
