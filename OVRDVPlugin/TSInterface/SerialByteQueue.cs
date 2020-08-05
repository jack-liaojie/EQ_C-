using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace OVRDVPlugin.TSInterface
{
    public class SerialByteQueue
    {
        public SerialByteQueue(int growSize, byte packEndFlag)
        {
            m_memStream = new MemoryStream(growSize);
            m_growSize = growSize;
            m_endFlag = packEndFlag;
        }
        private MemoryStream m_memStream;
        private int m_growSize;
        private byte m_endFlag;
        public void Write(byte[] data)
        {
            this.Write(data, 0, data.Length);
        }
        public void Write(byte[] data, int offset, int length)
        {
            m_memStream.Seek(0, SeekOrigin.End);//移动到末尾
            m_memStream.Write(data, offset, length);
        }

        public byte[] Read(int count)
        {
            if (count >= m_memStream.Length)
            {
                byte[] retData = m_memStream.ToArray();
                m_memStream.Dispose();
                m_memStream = new MemoryStream(m_growSize);
                return retData;
            }
            else
            {
                byte[] retData = new byte[count];
                m_memStream.Seek(0, SeekOrigin.Begin);
                m_memStream.Read(retData, 0, count);

                int remainLen = (int)m_memStream.Length - count;
                byte[] remainData = new byte[remainLen];
                m_memStream.Read(remainData, 0, remainLen);
                m_memStream.Dispose();
                m_memStream = new MemoryStream(m_growSize);
                this.Write(remainData);
                return retData;
            }
        }

        public byte[] ToArray()
        {
            return m_memStream.ToArray();
        }

        public byte[] ReadToLastFlag()
        {
            int lastIndex = LastFlagIndex();
            if (lastIndex == -1)
            {
                return null;
            }
            return Read(lastIndex + 1);
        }

        public int LastFlagIndex()
        {
            byte[] data = ToArray();
            for (int i = data.Length - 1; i >= 0; i-- )
            {
                if (data[i] == m_endFlag)
                {
                    return i;
                }
            }
            return -1;
        }
    }
}
