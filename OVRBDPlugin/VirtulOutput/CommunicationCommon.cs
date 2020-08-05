using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Net;

namespace AutoSports.OVRBDPlugin
{
    public delegate void ClientChangedDelegate(string strIP, bool bAdd, int curCount);
    public delegate void RecvErrorDataDelegate(byte[] errorData);
    public delegate void ProcessErrorDelegate(Exception error);


   

    public enum NetDataDirection : uint
    {
        Request = 1,//请求，一般需要回复
        Reply = 2, //应答，不需要回复
        Action = 3,//动作，不需要回复
    }

    public static class CommunicationCommon
    {
        public static bool ReadAllData(NetworkStream netStream, byte[] buffer, int size)
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
                catch
                {
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// 设置socket的keep alive
        /// </summary>
        /// <param name="socketToSet">要设置keep alive的socket</param>
        /// <param name="keepalive_time">keep alive的发送间隔</param>
        /// <param name="keepalive_interval">无回复之后发送的间隔</param>
        public static void SetKeepAlive(Socket socketToSet, uint keepalive_time, uint keepalive_interval)
        {
            byte[] inValue = new byte[12];
            Array.Copy(BitConverter.GetBytes((int)1), 0, inValue, 0, 4);
            Array.Copy(BitConverter.GetBytes(keepalive_time), 0, inValue, 4, 4);
            Array.Copy(BitConverter.GetBytes(keepalive_interval), 0, inValue, 8, 4);

            socketToSet.IOControl(IOControlCode.KeepAliveValues, inValue, null);
        } 
    }
}
