using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.IO.Ports;
using System.Threading;
using System.Windows.Forms;
namespace AutoSports.OVRWPPlugin
{
    public delegate void DataReceivedHanlder(byte[] bytesData, int dataLength);
    enum ReceiverType
    {
        UDP = 0,
        SerialPort = 1
    }
    public class SerialPortReceiver : IDisposable
    {
        private const byte SOH = 0xDF;
        private const byte EOT = 0xCF;
        Byte[] m_TextBuffer;
        int m_TextBufferIndex;
        private bool m_bFrameStart = false;
        private String m_strText = String.Empty;
        private const int BUFFER_SIZE = 1024;
        public SerialPort m_SerialPort;

        private bool _timeOut;
        private Boolean disposed = false;

        public SerialPortReceiver()
        {
            m_SerialPort = new SerialPort();
            m_SerialPort.Handshake = Handshake.None;
            m_SerialPort.ReadBufferSize = 10240;
            m_SerialPort.ReadTimeout = 10000;
            m_SerialPort.WriteTimeout = 10000;
            m_SerialPort.DataReceived += new SerialDataReceivedEventHandler(com_DataReceived);
        }
        public void OpenSerial()
        {
            m_SerialPort.Open();
        }
        public void CloseSerial()
        {
            m_SerialPort.Close();
        }
        void com_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            if (m_SerialPort != null)
            {
                if (m_TextBuffer == null)
                {
                    m_TextBuffer = new Byte[BUFFER_SIZE];
                }
                int bytesReaded = 0;
                Byte[] buffer = new Byte[BUFFER_SIZE];
                do
                {
                    try
                    {
                        bytesReaded = m_SerialPort.Read(buffer, 0, buffer.Length);
                        if (bytesReaded > 0)
                        {
                            for (int i = 0; i < bytesReaded; i++)
                            {
                                if (buffer[i] == SOH)
                                {
                                    m_bFrameStart = true;
                                    m_TextBufferIndex = 0;
                                    continue;
                                }
                                if (buffer[i] == EOT)
                                {
                                    if (m_TextBufferIndex == 6)
                                    {
                                        m_strText = (((m_TextBuffer[0] & 0xF0) >> 4) * 600 + (m_TextBuffer[0] & 0x0F) * 60 + ((m_TextBuffer[1] & 0xF0) >> 4) * 10 + (m_TextBuffer[1] & 0x0F)).ToString();
                                    }
                                    m_bFrameStart = false;
                                    m_TextBufferIndex = 0;
                                    lock (GVAR.g_messageSignal)
                                    {

                                        GVAR.g_messagesQueue.Enqueue(m_strText);
                                        GVAR.g_SerialEvent.Set();
                                    }
                                    continue;
                                }

                                if (m_bFrameStart)
                                {
                                    m_TextBuffer[m_TextBufferIndex] = buffer[i];
                                    m_TextBufferIndex++;
                                }
                            }
                        }
                    }
                    catch (Exception)
                    {
                    }
                } while (bytesReaded == buffer.Length);

            }
        }

        public bool TimeOut
        {
            get { return _timeOut; }
            set { _timeOut = value; }
        }

        #region IDisposable Members

        public void Dispose()
        {
            Dispose(true);
        }

        private void Dispose(bool disposing)
        {
            if (!disposed && disposing && m_SerialPort != null && m_SerialPort.IsOpen)
            {
                m_SerialPort.Close();
                disposed = true;

            }
        }

        #endregion
    }

}
