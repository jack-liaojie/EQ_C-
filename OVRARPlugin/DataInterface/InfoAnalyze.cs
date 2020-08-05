using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoSports.OVRARPlugin
{
    public class InfoAnalyze
    {
        public static AR_InfoHead GetInfoHead(byte[] data)
        {
            AR_InfoHead head = new AR_InfoHead();
            try
            {
                if (data.Length >= 4)
                {
                    head.HeadMark = BitConverter.ToInt32(data, 0);
                    //head.HeadMark = Convert.ToInt32(Encoding.UTF8.GetString(data, 0, 4));
                }
                if (data.Length >= 8)
                {
                    head.TaskNum = BitConverter.ToInt32(data, 4);
                    //Encoding.UTF8.GetString(data, 4, 4);
                    //head.TaskNum = Convert.ToInt32(strTask);
                }
                if (data.Length >= 12)
                {
                    head.ConfirmMark = BitConverter.ToInt32(data, 8);
                    //head.ConfirmMark = Convert.ToInt32(Encoding.UTF8.GetString(data, 8, 4));
                }
                if (data.Length >= 16)
                {
                    head.InfoLength = BitConverter.ToInt32(data, 12);
                    //head.InfoLength = Convert.ToInt32(Encoding.UTF8.GetString(data, 12, 4));
                }
                if (data.Length >= 20)
                {
                    head.EndMark = BitConverter.ToInt32(data, data.Length - 4);
                    //head.InfoLength = Convert.ToInt32(Encoding.UTF8.GetString(data, 12, 4));
                }
            }
            catch { }
            return head;
        }

        public static string GetReceiveString(byte[] data)
        {
            string reStr = string.Empty;
            int ilength = data.Length - 20;
            if (ilength > 0)
            {
                byte[] receiveData = new byte[ilength];
                Array.Copy(data, 16, receiveData, 0, ilength);
                reStr = Encoding.UTF8.GetString(receiveData);
            }

            return reStr;
        }
        public static int GetReceiveInt32(byte[] data)
        {
            int reInt = 0;
            int ilength = data.Length - 20;
            if (ilength > 0)
            {
                byte[] receiveData = new byte[ilength];
                Array.Copy(data, 16, receiveData, 0, ilength);
                Encoding.Convert(Encoding.Default, Encoding.UTF8, receiveData);
                reInt = Convert.ToInt32(Encoding.UTF8.GetString(receiveData));
            }

            return reInt;
        }
        public static byte[] GetPackageBytes(AR_InfoHead head, byte[] data)
        {
            byte[] hmByte = BitConverter.GetBytes(head.HeadMark);
            byte[] taskByte = BitConverter.GetBytes(head.TaskNum);
            byte[] confirmByte = BitConverter.GetBytes(head.ConfirmMark);
            byte[] lenghByte = BitConverter.GetBytes(data.Length);
            byte[] lastByte = BitConverter.GetBytes(head.EndMark);

            byte[] sendData = new byte[hmByte.Length + taskByte.Length +
                confirmByte.Length + lenghByte.Length + data.Length + lastByte.Length];

            hmByte.CopyTo(sendData, 0);
            taskByte.CopyTo(sendData, hmByte.Length);
            confirmByte.CopyTo(sendData, hmByte.Length + taskByte.Length);
            lenghByte.CopyTo(sendData, hmByte.Length + taskByte.Length + confirmByte.Length);
            data.CopyTo(sendData, hmByte.Length + taskByte.Length + confirmByte.Length + lenghByte.Length);
            lastByte.CopyTo(sendData, hmByte.Length + taskByte.Length + confirmByte.Length + lenghByte.Length + data.Length);
            return sendData;
        }
        public static byte[] GetFeedbackBytes(AR_InfoHead head)
        {
            AR_InfoHead fdHead = new AR_InfoHead();
            fdHead.HeadMark = head.HeadMark;
            fdHead.EndMark = head.EndMark;
            fdHead.ConfirmMark = head.ConfirmMark;
            fdHead.TaskNum = 254;
            byte[] data = Encoding.UTF8.GetBytes(head.ConfirmMark.ToString());
            return GetPackageBytes(fdHead, data);
        }
        public static byte[] GetSendBytes(AR_InfoHead head)
        {
            return GetSendBytes(head, 0);
        }
        public static byte[] GetSendBytes(AR_InfoHead head, int para)
        {
            AR_InfoHead sendHead = new AR_InfoHead();
            sendHead.HeadMark = head.HeadMark;
            sendHead.EndMark = head.EndMark;
            sendHead.ConfirmMark = head.ConfirmMark;
            sendHead.TaskNum += head.TaskNum + 1;
            string strData = string.Empty;
            switch (head.TaskNum)
            {
                case 10:
                    strData = GVAR.g_ManageDB.InterfaceGetRegisterInfo(GVAR.g_strDisplnCode);
                    break;
                case 15:
                    strData = GVAR.g_ManageDB.InterfaceGetScheduleInfo(GVAR.g_strDisplnCode);
                    break;
                case 20:
                    strData = GVAR.g_ManageDB.InterfaceGetMatchStartList(para);
                    break;
            }
            byte[] dataBytes = Encoding.UTF8.GetBytes(strData);
            sendHead.InfoLength = dataBytes.Length;
            byte[] sendData = InfoAnalyze.GetPackageBytes(sendHead, dataBytes);

            return sendData;
        }
        public static void InsertArrowResultToOvr(byte[] data)
        {
            try
            {
                string strRecData = GetReceiveString(data);

                string[] arrRecData = strRecData.Split(new char[] { ';' });
                for (int i = 0; i < arrRecData.Length; i++)
                {
                    string strEnds = arrRecData[i];
                    if (!string.IsNullOrEmpty(strEnds))
                    {
                        string[] arrEnd = strEnds.Split(new char[] { ',' });

                        int phaseId = Convert.ToInt32(arrEnd[0]);
                        if (phaseId == 0)
                            phaseId = ARUdpService.CurMatchInfo.PhaseID;
                        int matchId = Convert.ToInt32(arrEnd[1]);
                        if (matchId == 0)
                            matchId = ARUdpService.CurMatchInfo.MatchID;
                        int playerId = Convert.ToInt32(arrEnd[2]);

                        if (playerId == -1)
                            playerId = ARUdpService.CurMatchInfo.PlayerA;
                        else if (playerId == -2)
                            playerId = ARUdpService.CurMatchInfo.PlayerB;

                        string endIndex = arrEnd[3];

                        for (int arrInx = 1; arrInx < arrEnd.Length - 3; arrInx++)
                        {
                            string ring = arrEnd[arrInx + 3];
                            bool bReture = GVAR.g_ManageDB.InterfaceUpdatePlayerArrow(matchId, playerId, endIndex, arrInx.ToString(), ring);
                        }
                    }
                }
            }
            catch { }
        }
        public static void InsertArrowShootOffToOvr(byte[] data)
        {
            try
            {
                string strRecData = GetReceiveString(data);

                string[] arrRecData = strRecData.Split(new char[] { ';' });
                for (int i = 0; i < arrRecData.Length; i++)
                {
                    string strEnds = arrRecData[i];
                    if (!string.IsNullOrEmpty(strEnds))
                    {
                        string[] arrEnd = strEnds.Split(new char[] { ',' });

                        int phaseId = Convert.ToInt32(arrEnd[0]);
                        if (phaseId == 0)
                            phaseId = ARUdpService.CurMatchInfo.PhaseID;
                        int matchId = Convert.ToInt32(arrEnd[1]);
                        if (matchId == 0)
                            matchId = ARUdpService.CurMatchInfo.MatchID;
                        int playerId = Convert.ToInt32(arrEnd[2]);

                        if (playerId == -1)
                            playerId = ARUdpService.CurMatchInfo.PlayerA;
                        else if (playerId == -2)
                            playerId = ARUdpService.CurMatchInfo.PlayerB;

                        string endIndex = arrEnd[3];

                        for (int arrInx = 1; arrInx < arrEnd.Length - 3; arrInx++)
                        {
                            string temp = arrEnd[arrInx + 3];
                            string[] arrowResult = temp.Split(new char[] { ':' });
                            string ring = arrowResult[0];
                            string distance = arrowResult[1];
                            bool bReture = GVAR.g_ManageDB.InterfaceUpdatePlayerShootOffArrow(matchId, playerId, endIndex, arrInx.ToString(), ring, distance);
                        }
                    }
                }
            }
            catch { }
        }

    }
}
