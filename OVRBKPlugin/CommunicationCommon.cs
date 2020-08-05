using System.Net.Sockets;

#pragma warning disable 1591

namespace AutoSports.OVRBKPlugin
{
    public delegate void ClientChangedDelegate(TcpClient obTcpClient, string strIP, bool bAdd, int curCount);
  
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
        public static void SetKeepAlive(Socket socketToSet, ulong keepalive_time, ulong keepalive_interval)
        {
            int bytes_per_long = 32 / 8;
            byte[] keep_alive = new byte[3 * bytes_per_long];
            ulong[] input_params = new ulong[3];
            int i1;
            int bits_per_byte = 8;

            if (keepalive_time == 0 || keepalive_interval == 0)
                input_params[0] = 0;
            else
                input_params[0] = 1;
            input_params[1] = keepalive_time;
            input_params[2] = keepalive_interval;
            for (i1 = 0; i1 < input_params.Length; i1++)
            {
                keep_alive[i1 * bytes_per_long + 3] = (byte)(input_params[i1] >> ((bytes_per_long - 1) * bits_per_byte) & 0xff);
                keep_alive[i1 * bytes_per_long + 2] = (byte)(input_params[i1] >> ((bytes_per_long - 2) * bits_per_byte) & 0xff);
                keep_alive[i1 * bytes_per_long + 1] = (byte)(input_params[i1] >> ((bytes_per_long - 3) * bits_per_byte) & 0xff);
                keep_alive[i1 * bytes_per_long + 0] = (byte)(input_params[i1] >> ((bytes_per_long - 4) * bits_per_byte) & 0xff);
            }
            socketToSet.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.KeepAlive, keep_alive);
        } 
    }
}
