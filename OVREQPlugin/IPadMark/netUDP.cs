using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Diagnostics;

namespace AutoSports.OVREQPlugin
{
	public class NetUdp
	{
		private UdpClient m_oUdpRcv;
		private UdpClient m_oUdpSend;

		private string m_strLastErr;

        public string LastErrorMsg { get { return m_strLastErr; } }

		public event EventHandler<eventArgsDataRecv> eventHandlerDataRecv;

        //modify by huang
		private void _RcvCallback(IAsyncResult ar)
		{
            try
            {
                IPEndPoint ipSource = new IPEndPoint(IPAddress.Any, 0);

                UdpClient udpClient = (UdpClient)ar.AsyncState;
                Byte[] bytesRead = udpClient.EndReceive(ar, ref ipSource);

                if (eventHandlerDataRecv != null)
                {
                    eventHandlerDataRecv.Invoke(this, new eventArgsDataRecv(bytesRead, ipSource));
                }
                udpClient.BeginReceive(_RcvCallback, udpClient);
            }
            catch(Exception ex)
            {
                m_strLastErr = ex.ToString();
            }
			
		}

		public bool Send(Byte[] bytes, IPEndPoint ip)
		{
			if (bytes == null || ip == null)
			{
				return false;
			}

			try
			{
				m_oUdpSend.Send(bytes, bytes.Length, ip);
				return true;
			}
			catch (Exception ex)
			{
				m_strLastErr = ex.ToString();
				return false;
			}
		}

		public bool Open(int nPort)
		{
			Close();

			try
			{
				m_oUdpSend = new UdpClient();
				m_oUdpRcv = new UdpClient(nPort);
	            
				m_oUdpRcv.BeginReceive(_RcvCallback, m_oUdpRcv);
	
				return true;
			}
			catch (Exception ex)
			{
				m_strLastErr = ex.ToString();
				return false;
			}
		}

		public bool IsOpened()
		{
			return ( m_oUdpSend != null && m_oUdpRcv != null );
		}

		public void Close()
		{
			try
			{
				if (m_oUdpSend != null)
				{
					m_oUdpSend.Close();
					m_oUdpSend = null;
				}
	
				if (m_oUdpRcv != null)
				{
					m_oUdpRcv.Close();
					m_oUdpRcv = null;
				}
			}
			catch (Exception ex)
			{
				m_strLastErr = ex.ToString();
			}
		}
	}

    public class eventArgsDataRecv : EventArgs
    {
        public eventArgsDataRecv(byte[] bytes, IPEndPoint ip)
        {
			m_bytes = bytes;
			m_ipSource = ip;
        }

		public byte[] m_bytes;
		public IPEndPoint m_ipSource;
    }
}
