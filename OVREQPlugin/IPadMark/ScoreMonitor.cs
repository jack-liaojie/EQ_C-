 using System;
using System.Collections.Generic;
using System.Configuration;
using System.ServiceModel;
using System.Threading;
using AutoSports.OVREQPlugin.ServiceReference1;
using System.Data;

namespace AutoSports.OVREQPlugin
{
    public delegate bool MonitorServiceIsOnlineHandler(bool IsConnect);

    public class ServiceManager
    {
        #region static members
        private static ServiceManager manager = null;
        private static MonitorClient monitorClient = null;
        private static bool Running = false;
        private static bool monitorIsOnline = false;
        public static event MonitorServiceIsOnlineHandler EventMonitorServiceIsOnline;
        private static Thread ovrThread = null;
        #endregion

        #region service客户端管理
        public static void Start()
        {
            Running = true;
            if (null == manager)
            {
                manager = new ServiceManager();
            }
            if (null == monitorClient)
            {
                monitorClient = new MonitorClient();
            }
            manager.Working();
        }

        public static void Stop()
        {
            Running = true;
            ovrThread.Abort();
        }

        private void Working()
        {
            ovrThread = new Thread(OnMonitorProcess);
            ovrThread.Start();
        }

        void OnMonitorProcess()
        {
            while (Running)
            {
                try
                {
                    MonitorHandler();
                    if (!monitorIsOnline)
                    {
                        monitorIsOnline = true;
                        if (EventMonitorServiceIsOnline != null)
                            EventMonitorServiceIsOnline(monitorIsOnline);
                    }
                }
                catch (Exception ex)
                {
                    string error = ex.Message;
                    if (monitorIsOnline)
                    {
                        monitorIsOnline = false;
                        if (EventMonitorServiceIsOnline != null)
                            EventMonitorServiceIsOnline(monitorIsOnline);
                    }
                }
                Thread.Sleep(1000);
            }
        }

        private void MonitorHandler()
        {
            //定时触发;  
        }
        #endregion

        #region 外部Service调用
        public static bool SendBaseInfoTableToMonitor(BaseInfo bi)
        {
            bool r = false;
            try
            {
                if (monitorIsOnline)
                {
                    r = monitorClient.RecevieBaseInfoTable(bi);
                }
            }
            catch (Exception ex)
            {
                string error = ex.Message;
            }

            return r;
        }

        public static bool SendJudgeTableToMonitor(DataTable jt)
        {
            bool r = false;
            try
            {
                if (monitorIsOnline)
                {
                    r = monitorClient.RecevieJudgeTable(jt);
                }
            }
            catch (Exception ex)
            {
                //System.Windows.Forms.MessageBox.Show(ex.Message);
                string error = ex.Message;
            }

            return r;
        }

        public static bool SendScoreTableToMonitor(DataTable st)
        {
            bool r = false;
            try
            {
                if (monitorIsOnline)
                {
                    r = monitorClient.RecevieScoreTable(st);
                }
            }
            catch (Exception ex)
            {
                string error = ex.Message;
            }

            return r;
        }
        #endregion
    }
}
