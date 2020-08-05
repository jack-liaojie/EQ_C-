using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace AutoSports.OVRSEPlugin
{
    public class QueueDataProcess<T>
    {
        public delegate void ProcessErrorDelegate(Exception error);
        public event ProcessErrorDelegate OnProcessError;

        #region 私有成员
        private Thread m_processThread; //处理线程
        private Queue<T> m_queue;  //处理队列
        private bool m_bRunning; //运行标志

        private ManualResetEvent m_eventForProcessExit; //退出事件
        private ManualResetEvent m_eventForProcessWait; //空任务等待控制事件
        private IDataProcess m_iDataProcess;
        #endregion

        #region 错误原因

        private string m_strLastErrorMsg = "";
        public string LastErrorMsg { get { return m_strLastErrorMsg; } }
        #endregion


        public QueueDataProcess(IDataProcess iDataProcess)
        {
            System.Diagnostics.Debug.Assert(iDataProcess != null);
            m_iDataProcess = iDataProcess;
            m_bRunning = false;
            m_queue = new Queue<T>();
        }
   
        public bool StartProcess()
        {
            m_queue.Clear();
            if (m_bRunning)
            {
                m_strLastErrorMsg = "The process is already running!";
                return false;
            }
            try
            {
                m_bRunning = true;
                m_eventForProcessExit = new ManualResetEvent(false);
                m_eventForProcessWait = new ManualResetEvent(false);
                m_processThread = new Thread(() => this.ProcessProc());
                m_processThread.IsBackground = true;
                m_processThread.Start();
                return true;
            }
            catch (System.Exception ex)
            {
                m_bRunning = false;
                m_strLastErrorMsg = ex.Message;
                return false;
            }
        }

        public void ProcessProc()
        {
            m_eventForProcessExit.Reset();

            while (m_bRunning)
            {
                Monitor.Enter(m_queue);
                if (m_queue.Count > 0)
                {
                    object tObj = m_queue.Dequeue();
                    Monitor.Exit(m_queue);
                    try
                    {
                        bool bRes = m_iDataProcess.ProcessData(tObj);
                    }
                    catch (System.Exception ex)
                    {
                        if (OnProcessError != null)
                        {
                            OnProcessError(ex);
                        }
                    }
                }
                else
                {
                    m_eventForProcessWait.Reset();
                    Monitor.Exit(m_queue);
                    m_eventForProcessWait.WaitOne();
                }
            }
            m_bRunning = false;
            m_eventForProcessExit.Set();
        }

        public void AddTask(T task)
        {
            Monitor.Enter(m_queue);
            if ( m_queue.Contains(task) )
            {
                Monitor.Exit(m_queue);
                return;
            }
            m_queue.Enqueue(task);
            Monitor.Exit(m_queue);
            m_eventForProcessWait.Set();//发出工作信号
        }

        public void StopProcess()
        {
            if (m_bRunning)
            {
                m_bRunning = false;//发出停止命令
                m_eventForProcessExit.WaitOne();//等待处理线程退出
                m_eventForProcessExit.Close();//销毁事件对象
                m_eventForProcessExit = null;
            }
        }
    }
}
