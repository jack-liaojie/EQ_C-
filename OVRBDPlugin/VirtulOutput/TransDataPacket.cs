using System;

namespace AutoSports.OVRBDPlugin
{
    /*传输层协议
     | 内容长度(4)(不包括包头) | 数据内容 |
     */
    public class TransDataPacket
    {
        private UInt32 m_headerFlag;
        private UInt32 m_extraFlag = 0;
        //private byte[] m_recvContent;
        //private UInt32 m_recvExtraFlag;
        //public byte[] RecvContentData { get { return m_recvContent; } }
        //public UInt32 RecvExtraFlag { get { return m_recvExtraFlag; } }
        public TransDataPacket(UInt32 headerFlag)
        {
            m_headerFlag = headerFlag;
        }
        public TransDataPacket(UInt32 headerFlag, UInt32 extraFlag)
        {
            m_headerFlag = headerFlag;
            m_extraFlag = extraFlag;
        }
        public byte[] MakePacket(byte[] data)
        {
            int dataLen = data == null ? 0 : data.Length;
            byte[] resData = new byte[8 + dataLen];
            Array.Copy(BitConverter.GetBytes(0xFFFFFFFF), 0, resData, 0, 4);
            Array.Copy(BitConverter.GetBytes(dataLen), 0, resData, 4, 4);//封装长度
            if (dataLen > 0)
            {
                Array.Copy(data, 0, resData, 8, data.Length);//封装数据
            }
            return resData;
        }

        public byte[] MakeNoContentPacket()
        {
            return MakePacket(null);
        }
    }
}
