using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO.Ports;
using System.Threading;
using System.Text.RegularExpressions;
using System.IO;

namespace OVRDVPlugin.TSInterface
{
    public class DVSerialDataManager
    {
        private Thread m_recvThread;
        private Thread m_processThread;
        private ManualResetEvent m_recvExitEvent;
        private ManualResetEvent m_processExitEvent;
        private ManualResetEvent m_processWaitEvent;
        private bool m_bRunning = false;
        private DivingProcess m_diveProcess;
        private SerialByteQueue m_serialBytes;
        private string m_tsDataSaveDir;
        private StreamWriter m_streamWriter;
        public string LastErrorMessage { private set; get; }
        public int MatchID
        {
            get { return m_diveProcess.MatchID; }
            set { m_diveProcess.MatchID = value; }
        }

        public event Action<TransmitStatus, TSMatchInfo> OnRecvData;
        public event Action<string, bool> OnReportUpdateDBInfo;
        public DVSerialDataManager(string portName, int baudRate, Parity parity, int dataBits, StopBits stopBits)
        {
            m_tsDataSaveDir = Path.Combine(DVCommon.GetAppRootDir(), DVTSInterface.DV_TS_DATA);
            m_serialPort = new SerialPort(portName, baudRate, parity, dataBits, stopBits);
            m_serialPort.ReadTimeout = SerialPort.InfiniteTimeout;
            m_serialPort.ReadBufferSize = 1024 * 100;
            m_recvThread = new Thread(new ThreadStart(RecvProc));
            m_recvThread.IsBackground = true;
            m_processThread = new Thread(new ThreadStart(ProcessProc));
            m_processThread.IsBackground = true;
            m_recvExitEvent = new ManualResetEvent(false);
            m_processExitEvent = new ManualResetEvent(false);
            m_processWaitEvent = new ManualResetEvent(false);
            m_recvThread.IsBackground = true;
            m_serialBytes = new SerialByteQueue(2048, 0x04);
            m_diveProcess = new DivingProcess();
            m_diveProcess.RecvData += new Action<TransmitStatus, TSMatchInfo>(m_diveProcess_RecvData);
            m_diveProcess.TransimitAction += new Action<bool, string>(m_diveProcess_TransimitAction);
            m_diveProcess.OnUpdateDBResult += new Action<string, bool>(m_diveProcess_OnUpdateDBResult);
        }

        private void m_diveProcess_OnUpdateDBResult(string strInfo, bool succeed)
        {
            if (OnReportUpdateDBInfo != null )
            {
                OnReportUpdateDBInfo(strInfo, succeed);
            }
        }

        private void m_diveProcess_TransimitAction(bool bStart, string strData)
        {
            if ( bStart )
            {
                string filePath = Path.Combine(m_tsDataSaveDir, string.Format("MatchData_{0}.txt", MatchID));
                if (m_streamWriter != null )
                {
                    m_streamWriter.Close();
                    m_streamWriter = null;
                }
                m_streamWriter = new StreamWriter(File.Open(filePath, FileMode.Create, FileAccess.Write, FileShare.Read));
                m_streamWriter.WriteLine(strData);
            }
            else
            {
                if ( m_streamWriter != null )
                {
                    m_streamWriter.Close();
                    m_streamWriter = null;
                }
            }
        }

        private void m_diveProcess_RecvData(TransmitStatus arg1, TSMatchInfo arg2)
        {
            if (OnRecvData != null)
            {
                OnRecvData(arg1, arg2);
            }
        }
        private SerialPort m_serialPort;
        public bool StartReceiver()
        {
            m_bRunning = true;
            if (!m_serialPort.IsOpen)
            {
                try
                {
                    m_serialPort.Open();
                }
                catch (System.Exception ex)
                {
                    LastErrorMessage = ex.Message;
                    m_bRunning = false;
                    return false;
                }
                m_recvThread = new Thread(new ThreadStart(RecvProc));
                m_recvThread.IsBackground = true;
                m_processThread = new Thread(new ThreadStart(ProcessProc));
                m_processThread.IsBackground = true;
                m_recvThread.Start();//启动接收线程
                m_processThread.Start();//启动处理线程
            }
            return true;
        }

        public void StopReceiver()
        {
            m_bRunning = false;
            m_processWaitEvent.Set();//处理线程立即动作
            m_processExitEvent.WaitOne();//等待处理线程退出
            m_serialPort.Close();//关闭串口
            m_recvExitEvent.WaitOne();//等待接收线程退出
            //m_processExitEvent.Close();
            //m_processWaitEvent.Close();
            //m_recvExitEvent.Close();
            //m_serialPort.Dispose();
            //m_serialPort = null;
        }

        public bool ModifyParam(string portName, int baudRate, int dataBits, Parity parity, StopBits stopBits)
        {
            if (m_bRunning)
            {
                LastErrorMessage = "Cannot modify params during running time.";
                return false;
            }
            m_serialPort.PortName = portName;
            m_serialPort.BaudRate = baudRate;
            m_serialPort.DataBits = dataBits;
            m_serialPort.Parity = parity;
            m_serialPort.StopBits = stopBits;
            return true;
        }

        public bool IsOpened
        {
            get { return m_serialPort.IsOpen; }
        }

        public void RecvProc()
        {
            m_recvExitEvent.Reset();

            while (m_bRunning)
            {
                int toReadCount = m_serialPort.BytesToRead;
                if (toReadCount == 0)
                {
                    toReadCount = 4;
                }
                byte[] readBuffer = new byte[toReadCount];
                try
                {
                    int readCount = m_serialPort.Read(readBuffer, 0, toReadCount);
                    Monitor.Enter(m_serialBytes);
                    m_serialBytes.Write(readBuffer, 0, readCount);//保存接收到的数据
                    Monitor.Exit(m_serialBytes);
                    m_processWaitEvent.Set();//发出处理信号
                }
                catch (System.Exception ex)
                {
                    LastErrorMessage = ex.Message;
                    break;
                }
            }

            m_recvExitEvent.Set();
        }

        public void ProcessProc()
        {
            m_processExitEvent.Reset();

            while (m_bRunning)
            {
                Monitor.Enter(m_serialBytes);
                byte[] recvBuffer = m_serialBytes.ReadToLastFlag();
                if (recvBuffer != null)
                {
                    Monitor.Exit(m_serialBytes);
                    if ( MatchID <= 0 )
                    {
                        continue;
                    }
                    //处理
                    string strText = System.Text.Encoding.Default.GetString(recvBuffer);
                    string pattern = string.Format("({0}[\\s\\S]*?{1})", "\x01", "\x04");
                    Regex rgx = new Regex(pattern);
                    MatchCollection matchCollection = rgx.Matches(strText);
                    
                    foreach (Match m in matchCollection)
                    {
                        
                        string strValue = m.Groups[1].Value.ToString();
                        strValue = strValue.Replace('\x0A', 'A');
                        strValue = strValue.Replace('\x13', '$');
                        if ( m_streamWriter != null )
                        {
                            m_streamWriter.WriteLine(strValue);
                        }
                        m_diveProcess.ProcessData(strValue);
                    }
                }
                else
                {
                    m_processWaitEvent.Reset();
                    Monitor.Exit(m_serialBytes);
                    m_processWaitEvent.WaitOne();
                }
            }

            m_processExitEvent.Set();
        }
    }
}
