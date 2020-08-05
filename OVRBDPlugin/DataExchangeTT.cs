using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.IO;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Data;
using System.ComponentModel;
using System.Windows.Forms;
using System.Net;
using System.Net.Sockets;
using Badminton2011;

namespace AutoSports.OVRBDPlugin
{
    public enum TTXmlType
    {
        ActionList,
        MatchInfo,
    }

    public class TSDataExchangeTT_Service
    {
        public static string TS_DATA_BACKUP_PATH;
        private delegate void AddInfoBoxDelegate(string str, bool bNormal);
        private delegate void SendHeartMsgDelegate();
        private delegate void OnRecvExtraPackageDelegate(ExtraTaskInfo extraInfo);
        private delegate void AddClientDeleagte(string strClient, bool bAdd);
        protected static DataProcessTT dataProcessTT_;
        protected static ManualResetEvent manualEvent_;
        protected static SqlConnection dbConn_;//数据库连接
        protected static DiffQueue workQueue_;//工作队列
        private static BackgroundWorker workThread_;//工作线程
        protected TSDataExchangeTT_Service(string dbStr)
        {
            TSDataExchangeTT_Service.TS_DATA_BACKUP_PATH = string.Format("C:\\{0}_T&S_Data", BDCommon.g_strDisplnCode);
            if (!Directory.Exists(TS_DATA_BACKUP_PATH))
            {
                try
                {
                    Directory.CreateDirectory(TS_DATA_BACKUP_PATH);
                }
                catch (System.Exception e)
                {
                    lastErrorMsg_ = string.Format("创建拷贝目录失败！原因：{0}", e.Message);
                    BDCommon.g_errorLog.Writelog("创建拷贝目录失败！原因：{0}", e.Message);
                }
            }
            if (dbConn_ == null)
            {
                dbConn_ = new SqlConnection(dbStr);
            }
            if (dataProcessTT_ == null)
            {
                dataProcessTT_ = new DataProcessTT(dbConn_);
            }
            if (workQueue_ == null)
            {
                workQueue_ = new DiffQueue();
            }
            if (manualEvent_ == null)
            {
                manualEvent_ = new ManualResetEvent(false);
            }
            if (workThread_ == null)
            {
                workThread_ = new BackgroundWorker();
                workThread_.WorkerSupportsCancellation = true;
                workThread_.DoWork += new DoWorkEventHandler(workThread__DoWork);
                workThread_.RunWorkerAsync((object)workThread_);
            }

        }
        public static string GetMatchCodeFromID(int matchID)
        {
            return dataProcessTT_.GetRscStringFromMatchID(matchID);
        }
        ~TSDataExchangeTT_Service()
        {
            workThread_.CancelAsync();
        }

        public static void SetDiffQueueToDiff()
        {
            if (workQueue_ != null)
            {
                workQueue_.MakeDiff();
            }
        }
        public static void ClearAcitonCookie()
        {
            if (dataProcessTT_ != null)
            {
                dataProcessTT_.ClearMemory();
            }
        }
        protected string lastErrorMsg_;
        public string LastErrMsg
        {
            get { return lastErrorMsg_; }
        }
        protected bool bErrored_ = false;
        public bool Errored
        {
            get { return bErrored_; }
        }



        private void AddFileInfoBox(string strMsg, bool bNormalMsg)
        {
            (BDCommon.g_BDPlugin.GetModuleUI as frmOVRBDDataEntry).AddInfoToFileBox(strMsg, bNormalMsg);
        }

        private void AddHeartInfoBox(string strMsg, bool bNormalMsg)
        {
            (BDCommon.g_BDPlugin.GetModuleUI as frmOVRBDDataEntry).AddInfoToHeartBox(strMsg, bNormalMsg);
        }

        private void SendExtraTaskPackage(ExtraTaskInfo extraInfo)
        {
            (BDCommon.g_BDPlugin.GetModuleUI as frmOVRBDDataEntry).OnRecvExtraTaskPackage(extraInfo);
        }

        private void SendHeartMsg()
        {
            (BDCommon.g_BDPlugin.GetModuleUI as frmOVRBDDataEntry).RecvHeartMsg();
        }

        protected void SendFileInfoToUI(string strInfo, bool bNormal)
        {
            BDCommon.g_BDPlugin.GetModuleUI.BeginInvoke(new AddInfoBoxDelegate(AddFileInfoBox), strInfo, bNormal);
        }
        protected void SendHeartInfoToUI(string strInfo, bool bNormal)
        {
            BDCommon.g_BDPlugin.GetModuleUI.BeginInvoke(new AddInfoBoxDelegate(AddHeartInfoBox), strInfo, bNormal);
        }
        protected void SendHeartMsgToUI()
        {
            BDCommon.g_BDPlugin.GetModuleUI.BeginInvoke(new SendHeartMsgDelegate(SendHeartMsg));
        }
        private void SendExtraTaskDelg(ExtraTaskInfo extraInfo)
        {
            BDCommon.g_BDPlugin.GetModuleUI.Invoke(new OnRecvExtraPackageDelegate(SendExtraTaskPackage), extraInfo);
        }
        private bool ProcessTTItem(TTXmlItem item)
        {
            bool bRes = dataProcessTT_.ProcessXmlData(item.StrData, item.ExtraData);
            if (!bRes)
            {
                lastErrorMsg_ = dataProcessTT_.LastErrorString;
            }
            return bRes;
        }
        protected void AddOrRemoveClientInfoToUI(string strClient, bool bAdd)
        {
            (BDCommon.g_BDPlugin.GetModuleUI as frmOVRBDDataEntry).AddOrRemoveClient(strClient, bAdd);
        }

        protected void AddClient(string strClient, bool bAdd)
        {
            BDCommon.g_BDPlugin.GetModuleUI.BeginInvoke(new AddClientDeleagte(AddOrRemoveClientInfoToUI), strClient, bAdd);
        }

        protected bool TestDBConnection()
        {
            if (dbConn_.State != ConnectionState.Open)
            {
                try
                {
                    dbConn_.Open();
                    return true;
                }
                catch (System.Exception e)
                {
                    this.lastErrorMsg_ = e.Message;
                    return false;
                }
            }
            return true;
        }

        //添加额外的工作任务
        public void AddExtraTask(string strOldFilePath, bool bActionAll)
        {
            string fileName = Path.GetFileName(strOldFilePath);
            string newPath = Path.Combine(TS_DATA_BACKUP_PATH, fileName);
            //路径不同才进行拷贝
            if (string.Compare(strOldFilePath, newPath, true) != 0)
            {
                BDCommon.ForceCopyFile(strOldFilePath, newPath);
            }

            if (!File.Exists(newPath))
            {
                SendFileInfoToUI(string.Format("Import {0} failed because of copying failed!", newPath), false);
                return;
            }
            FileInfo fInfo = new FileInfo(newPath);
            TTXmlItem item = new TTXmlItem(File.ReadAllText(newPath, System.Text.Encoding.UTF8), fInfo.Length, strOldFilePath, newPath, TTXmlItem.TTXmlItemType.FileShare, new TTXmlExtraData(null as TcpClient, bActionAll), true);
            bool bAdded = false;
            Monitor.Enter(workQueue_);
            bAdded = workQueue_.Enqueue(item);
            Monitor.Exit(workQueue_);
            if (bAdded)
            {
                manualEvent_.Set();//添加成功则发信号通知工作线程处理
            }
            else
            {
                SendFileInfoToUI(string.Format("The same file \"{0}\" has been imported already!", newPath), false);
            }
        }

        //工作线程
        protected void workThread__DoWork(object sender, DoWorkEventArgs e)
        {
            BackgroundWorker worker = (BackgroundWorker)e.Argument;
            while (!worker.CancellationPending)
            {
                Monitor.Enter(workQueue_);
                if (workQueue_.Count > 0)
                {
                    TTXmlItem dataItem = workQueue_.Dequeue();

                    System.Diagnostics.Trace.WriteLine(string.Format("队列中剩余任务数量：{0}", workQueue_.Count));
                    Monitor.Exit(workQueue_);

                    if (dataItem.ItemType == TTXmlItem.TTXmlItemType.FileShare)
                    {
                        //1为心跳文件
                        if (dataItem.FileLength == 1)
                        {
                            bErrored_ = false;
                            SendHeartMsgToUI();
                        }
                        else//否则为数据文件
                        {
                            //处理dataItem
                            if (ProcessTTItem(dataItem))
                            {
                                SendFileInfoToUI(string.Format("Import file \"{0}\" succeed!MatchID:{1}", Path.GetFileName(dataItem.NewPath), TSDataExchangeTT_Service.dataProcessTT_.ErrorIntDes), true);
                                SendExtraTaskDelg(dataProcessTT_.ExtraTask.Clone());
                            }
                            else
                            {
                                SendFileInfoToUI(string.Format("Import file \"{0}\" failed!{1}", Path.GetFileName(dataItem.NewPath), lastErrorMsg_), false);
                            }
                        }

                    }
                    else if (dataItem.ItemType == TTXmlItem.TTXmlItemType.NetTcp)
                    {
                        if (ProcessTTItem(dataItem))
                        {
                            if (TSDataExchangeTT_Service.dataProcessTT_.XmlType != XmlTypeEnum.XmlTypeClientExportSchedule
                                || TSDataExchangeTT_Service.dataProcessTT_.XmlType != XmlTypeEnum.XmlTypeClientChat)
                            {
                                SendFileInfoToUI(string.Format("Import matchcode:\"{0}\" succeed!MatchID:{1}", TSDataExchangeTT_Service.dataProcessTT_.MatchCode, TSDataExchangeTT_Service.dataProcessTT_.ErrorIntDes), true);
                            }

                            SendExtraTaskDelg(dataProcessTT_.ExtraTask.Clone());
                        }
                        else
                        {
                            SendFileInfoToUI(string.Format("Import matchcode:\"{0}\" failed!{1}", TSDataExchangeTT_Service.dataProcessTT_.MatchCode, lastErrorMsg_), false);
                        }
                        string xmlName = TSDataExchangeTT_Service.dataProcessTT_.MatchCode;


                        if (TSDataExchangeTT_Service.dataProcessTT_.XmlType == XmlTypeEnum.XmlTypeMatchInfo)
                        {
                            xmlName += "_Result.xml";
                        }
                        else if (TSDataExchangeTT_Service.dataProcessTT_.XmlType == XmlTypeEnum.XmlTypeAcitonListSingle
                                || TSDataExchangeTT_Service.dataProcessTT_.XmlType == XmlTypeEnum.XmlTypeAcitonListAll)
                        {
                            xmlName += "_Score.xml";
                        }
                        else
                        {
                            xmlName = "";
                        }

                        if (xmlName != null && xmlName != "")
                        {
                            xmlName = Path.Combine(TS_DATA_BACKUP_PATH, xmlName);
                            try
                            {
                                // File.WriteAllText(@"D:\"+xmlName, dataItem.StrData)

                                //File.WriteAllText(dataItem.StrData, Path.Combine("c:\\xml", "test.xml"), System.Text.Encoding.UTF8);
                                File.WriteAllText(xmlName, dataItem.StrData, System.Text.Encoding.UTF8);
                            }
                            catch (System.Exception err)
                            {
                                SendFileInfoToUI(string.Format("Save tcp data to file {0} failed!Reason:{1}", xmlName, err.Message), false);
                            }
                        }

                    }
                    else if (dataItem.ItemType == TTXmlItem.TTXmlItemType.NetUdp)
                    {
                        byte[] bytedata = (byte[])(((TTXmlExtraData)dataItem.ExtraData).Data);
                        byte[] gamedata = new byte[bytedata.Length - 4];
                        Array.ConstrainedCopy(bytedata, 4, gamedata, 0, gamedata.Length);
                        UInt32 headFlag = BitConverter.ToUInt32(bytedata, 0);
                        //心跳
                        if (headFlag == BDCommon.MSG_FLAG_HEART)
                        {
                            int courtNo = BitConverter.ToInt32(bytedata, 4);
                            AddClient(string.Format("{0}(Court{1})", dataItem.StrData, courtNo), true);
                            continue;
                        }
                        else if (headFlag == BDCommon.MSG_FLAG_CTRL_RES)
                        {
                            ResultType resType = (ResultType)BitConverter.ToInt32(bytedata, 4);
                            int res = BitConverter.ToInt32(bytedata, 8);
                            if (resType == ResultType.Synchronize)
                            {
                                if (res == 1)
                                {
                                    SendHeartInfoToUI(string.Format("{0}同步数据成功！", dataItem.StrData), true);
                                }
                                else if (res == -1)
                                {
                                    SendHeartInfoToUI(string.Format("{0}同步数据失败：数据库未连接！", dataItem.StrData), false);
                                }
                                else if (res == -2)
                                {
                                    SendHeartInfoToUI(string.Format("{0}同步数据失败！", dataItem.StrData), false);
                                }
                            }
                            else if (resType == ResultType.UnlockCourt)
                            {
                                if (res == 1)
                                {
                                    SendHeartInfoToUI(string.Format("{0}解锁Court成功！", dataItem.StrData), true);
                                }
                            }
                            else if (resType == ResultType.LockCourt)
                            {
                                if (res == 1)
                                {
                                    SendHeartInfoToUI(string.Format("{0}加锁Court成功！", dataItem.StrData), true);
                                }
                            }
                            else if (resType == ResultType.DelData)
                            {
                                if (res == 1)
                                {
                                    SendHeartInfoToUI(string.Format("{0}删除Data目录成功！", dataItem.StrData), true);
                                }
                                else if (res == -1)
                                {
                                    SendHeartInfoToUI(string.Format("{0}删除Data目录失败！", dataItem.StrData), false);
                                }
                            }
                            else if (resType == ResultType.GetMatchData)
                            {
                                if ( res == 1 )
                                {
                                    SendHeartInfoToUI(string.Format("{0}发送比赛数据成功！", dataItem.StrData), true);
                                }
                                else if(res == -1)
                                {
                                    SendHeartInfoToUI(string.Format("{0}客户端未选择任何一场比赛！", dataItem.StrData), false);
                                }
                            }
                            else if ( resType == ResultType.RecvMsg)
                            {
                                if ( res == 1 )
                                {
                                    SendHeartInfoToUI(string.Format("{0}收到控制台文本消息！", dataItem.StrData), true);
                                }
                            }
                            else if ( resType == ResultType.TransData)
                            {
                                if ( res == 1 )
                                {
                                    SendHeartInfoToUI(string.Format("{0}传输比赛数据成功！", dataItem.StrData), true);
                                }
                                else if ( res == -1 )
                                {
                                    SendHeartInfoToUI(string.Format("{0}源比赛数据获取失败！", dataItem.StrData), false);
                                }
                                else if ( res == -2 )
                                {
                                    SendHeartInfoToUI(string.Format("{0}目标场次比赛处于激活状态，拒绝修改！", dataItem.StrData), false);
                                }
                            }
                            else if ( resType == ResultType.CreateTempMatch )
                            {
                                if ( res == 1 )
                                {
                                    SendHeartInfoToUI(string.Format("{0}发送临时比赛成功！", dataItem.StrData), true);
                                }
                                else
                                {
                                    SendHeartInfoToUI(string.Format("{0}发送临时比赛失败！", dataItem.StrData), false);
                                }
                            }
                            continue;
                        }
                        object gameobj = ProtocolConverter.BytesToStruct(gamedata, typeof(SGameByteInfo));
                        if (gameobj == null)
                        {
                            SendFileInfoToUI("Received an invalid game byte info!", false);
                            continue;
                        }
                        SGameByteInfo gameInfo = (SGameByteInfo)gameobj;
                        GameByteInfoParser gbiParser = new GameByteInfoParser(gameInfo);

                        //先提取Action
                        string xmlAction = "";
                        if (gbiParser.IsValid())
                        {
                            xmlAction = ProtocolConverter.ConvertToActionXml(gameInfo);
                            if (xmlAction == "")
                            {
                                SendFileInfoToUI(string.Format("Get match code from matchID:{0} failed", gbiParser.MatchID), false);
                                continue;
                            }
                            else if ( xmlAction.StartsWith("[TEMP]") )//临时数据则存储
                            {
                                string[] strArray = xmlAction.Split('|');
                                string strActionPath = BDCommon.GetTempMatchDir();
                                strActionPath = Path.Combine(strActionPath, string.Format("{0}_Score.xml", strArray[1]));
                                File.WriteAllText(strActionPath, strArray[2]);

                                //继续解析MatchInfo
                                string xmlMatchInfo = ProtocolConverter.ConvertToMatchInfoXml(gameInfo);
                                if (xmlMatchInfo.StartsWith("[TEMP]") )
                                {
                                    strArray = xmlMatchInfo.Split('|');
                                    string strInfoPath = BDCommon.GetTempMatchDir();
                                    strInfoPath = Path.Combine(strInfoPath, string.Format("{0}_Result.xml", strArray[1]));
                                    File.WriteAllText(strInfoPath, strArray[2]);
                                    SendFileInfoToUI(string.Format("The action data of temp match {0} is saved.", gbiParser.MatchID), true);
                                }
                                else
                                {
                                    File.Delete(strActionPath);
                                    SendFileInfoToUI(string.Format("The action data of temp match {0} is parsed failed.", gbiParser.MatchID), false);
                                }
                                continue;
                            }
                        }
                        else
                        {
                            SendFileInfoToUI(string.Format("Games byte info error:{0}", gbiParser.ErrorInfo), false);
                            continue;
                        }

                        dataItem.StrData = xmlAction;
                        dataItem.FileLength = xmlAction.Length;

                        dataItem.ExtraData = new TTXmlExtraData(null as TcpClient, false);


                        if (ProcessTTItem(dataItem))
                        {
                            SendFileInfoToUI(string.Format("Import action matchcode:\"{0}\" succeed!MatchID:{1}", TSDataExchangeTT_Service.dataProcessTT_.MatchCode, TSDataExchangeTT_Service.dataProcessTT_.ErrorIntDes), true);
                            SendExtraTaskDelg(dataProcessTT_.ExtraTask.Clone());
                        }
                        else
                        {
                            SendFileInfoToUI(string.Format("Import action matchcode:\"{0}\" failed!{1}", TSDataExchangeTT_Service.dataProcessTT_.MatchCode, lastErrorMsg_), false);
                        }
                        string xmlName = TSDataExchangeTT_Service.dataProcessTT_.MatchCode;
                        xmlName += "_Score.xml";
                        if (xmlName != null && xmlName != "")
                        {
                            xmlName = Path.Combine(TS_DATA_BACKUP_PATH, xmlName);
                            try
                            {
                                File.WriteAllText(xmlName, dataItem.StrData, System.Text.Encoding.ASCII);
                            }
                            catch (System.Exception err)
                            {
                                SendFileInfoToUI(string.Format("Save udp data to file {0} failed!Reason:{1}", xmlName, err.Message), false);
                            }
                        }
                        //再判断是否需要MatchInfo
                        //if (gbiParser.IsCurrentGameFinished() || gbiParser.IsMatchStarted())
                        //{
                            string xmlNormalMatchInfo = ProtocolConverter.ConvertToMatchInfoXml(gameInfo);
                            if (xmlNormalMatchInfo == "")
                            {
                                SendFileInfoToUI(string.Format("Get match code from matchID:{0} failed", gbiParser.MatchID), false);
                                continue;
                            }
                            dataItem.StrData = xmlNormalMatchInfo;
                            dataItem.FileLength = xmlNormalMatchInfo.Length;

                            dataItem.ExtraData = new TTXmlExtraData(null as TcpClient, false);

                            if (ProcessTTItem(dataItem))
                            {
                                SendFileInfoToUI(string.Format("Import matchinfo matchcode:\"{0}\" succeed!MatchID:{1}", TSDataExchangeTT_Service.dataProcessTT_.MatchCode, TSDataExchangeTT_Service.dataProcessTT_.ErrorIntDes), true);
                                SendExtraTaskDelg(dataProcessTT_.ExtraTask.Clone());
                            }
                            else
                            {
                                SendFileInfoToUI(string.Format("Import matchinfo matchcode:\"{0}\" failed!{1}", TSDataExchangeTT_Service.dataProcessTT_.MatchCode, lastErrorMsg_), false);
                            }
                            xmlName = TSDataExchangeTT_Service.dataProcessTT_.MatchCode;
                            xmlName += "_Result.xml";
                            if (xmlName != null && xmlName != "")
                            {
                                xmlName = Path.Combine(TS_DATA_BACKUP_PATH, xmlName);
                                try
                                {
                                    File.WriteAllText(xmlName, dataItem.StrData, System.Text.Encoding.ASCII);
                                }
                                catch (System.Exception err)
                                {
                                    SendFileInfoToUI(string.Format("Save udp data to file {0} failed!Reason:{1}", xmlName, err.Message), false);
                                }
                            }
                       // }

                    }

                }
                else
                {
                    manualEvent_.Reset();
                    Monitor.Exit(workQueue_);
                    manualEvent_.WaitOne();//无数据则等待
                }
            }
            manualEvent_.Close();
        }
    }

    //文件监控类
    public class TSDataExchangeTT_File : TSDataExchangeTT_Service
    {
        private TSDataExchangeTT_File(string dbStr, string monitPath)
            : base(dbStr)
        {
            monitorFolderPath_ = monitPath;
            heartThread_ = new BackgroundWorker();

            heartThread_.WorkerSupportsCancellation = true;
            heartThread_.DoWork += new DoWorkEventHandler(heartThread__DoWork);
            heartThread_.RunWorkerAsync((object)heartThread_);


        }

        ~TSDataExchangeTT_File()
        {
            StopMonitor();
            heartThread_.CancelAsync();
        }


        private static TSDataExchangeTT_File s_ttTSExchange = null;

        private string monitorFolderPath_;
        private BackgroundWorker heartThread_;//心跳线程
        private FileSystemWatcher fileWatcher_;


        private bool bUserStopped_;

        //心跳线程
        private void heartThread__DoWork(object sender, DoWorkEventArgs e)
        {
            BackgroundWorker workder = (BackgroundWorker)e.Argument;
            int index = 0;
            while (!workder.CancellationPending)
            {
                Thread.Sleep(10000);
                continue;
                if (s_ttTSExchange.fileWatcher_ != null && s_ttTSExchange.fileWatcher_.EnableRaisingEvents)
                {
                    string pathHeartFile = Path.Combine(s_ttTSExchange.monitorFolderPath_, BDCommon.HEART_FILE_NAME);
                    try
                    {
                        File.WriteAllText(pathHeartFile, ((++index) % 10).ToString(), System.Text.Encoding.ASCII);
                    }
                    catch (System.Exception err)
                    {
                        SendHeartInfoToUI(string.Format("Write heart file failed!Reason:{0}", err.Message), false);
                    }
                }
            }
        }



        //SingleTon模型
        public static TSDataExchangeTT_File GetDataExchangeTT_File(string dbStr, string monitPath)
        {
            if (s_ttTSExchange == null)
            {
                s_ttTSExchange = new TSDataExchangeTT_File(dbStr, monitPath);
            }
            else
            {
                if (dbStr != dbConn_.ConnectionString)
                {
                    s_ttTSExchange.StopMonitor();
                    dbConn_.Close();
                    dbConn_.Dispose();
                    dbConn_ = new SqlConnection(dbStr);
                }

                if (monitPath.TrimEnd('\\').ToUpper() != s_ttTSExchange.monitorFolderPath_.TrimEnd('\\').ToUpper())
                {
                    s_ttTSExchange.StopMonitor();
                    s_ttTSExchange.monitorFolderPath_ = monitPath;
                }
            }
            return s_ttTSExchange;
        }




        public bool StartMonitor()
        {
            //首先检查数据库连接情况
            if (!TestDBConnection())
            {
                return false;
            }

            if (!Directory.Exists(TS_DATA_BACKUP_PATH))
            {
                try
                {
                    Directory.CreateDirectory(TS_DATA_BACKUP_PATH);
                }
                catch (System.Exception e)
                {
                    lastErrorMsg_ = string.Format("创建拷贝目录失败！原因：{0}", e.Message);
                    BDCommon.g_errorLog.Writelog("创建拷贝目录失败！原因：{0}", e.Message);
                    return false;
                }
            }
            string heartFilePath = Path.Combine(monitorFolderPath_, BDCommon.HEART_FILE_NAME);
            if (File.Exists(heartFilePath))
            {
                try
                {
                    File.Delete(heartFilePath);
                }
                catch
                {

                }
            }
            //启动监视
            RestartFileSystemWatcher();

            return true;
        }

        public void SetUserStoppedFlag(bool bStoped)
        {
            bUserStopped_ = bStoped;
        }

        public void StopMonitor()
        {
            if (fileWatcher_ != null)
            {
                fileWatcher_.EnableRaisingEvents = false;
                fileWatcher_.Dispose();
                fileWatcher_ = null;
            }
        }

        private void RestartFileSystemWatcher()
        {
            if (fileWatcher_ != null)
            {
                fileWatcher_.Dispose();
            }
            fileWatcher_ = new FileSystemWatcher();
            fileWatcher_.InternalBufferSize = 4096 * 4;
            fileWatcher_.Path = monitorFolderPath_;
            fileWatcher_.Filter = "*.xml";
            fileWatcher_.IncludeSubdirectories = false;
            fileWatcher_.NotifyFilter = NotifyFilters.LastWrite;
            fileWatcher_.Changed += new FileSystemEventHandler(fileWatcher__Changed);
            fileWatcher_.Error += new ErrorEventHandler(fileWatcher__Error);
            fileWatcher_.EnableRaisingEvents = true;
            bErrored_ = false;
        }

        private void fileWatcher__Error(object sender, ErrorEventArgs e)
        {
            s_ttTSExchange.bErrored_ = true;
            Exception myReturnedException = e.GetException();
            string strerror = string.Format("OnError event occured!{0}", myReturnedException.Message);
            BDCommon.g_errorLog.Writelog("文件监控发生OnError事件", myReturnedException.Message);
            SendHeartInfoToUI(strerror, false);
            // StopMonitor();//发生错误则立即停止监视器
            s_ttTSExchange.StopMonitor();//先停止监控
            SendHeartInfoToUI("Monitor Stopped!", false);
            while (!s_ttTSExchange.bUserStopped_)
            {
                SendHeartInfoToUI("Begin reconnecting...", true);
                if (Directory.Exists(s_ttTSExchange.monitorFolderPath_))
                {
                    if (s_ttTSExchange.bUserStopped_)
                    {
                        break;
                    }
                    SendHeartInfoToUI("Reconnect succeed!", true);
                    if (s_ttTSExchange.StartMonitor())
                    {
                        s_ttTSExchange.bErrored_ = false;
                        SendHeartInfoToUI("Start Monitor Succeed!", true);
                    }
                    else
                    {
                        SendHeartInfoToUI("Restart Monitor failed!You need to handle the problem manully!", false);
                    }
                    break;
                }
                else
                {
                    SendHeartInfoToUI("Reconnect failed!", false);
                }

                Thread.Sleep(2000);//每两秒判断一次连接
            }

            if (s_ttTSExchange.bUserStopped_)
            {
                s_ttTSExchange.StopMonitor();
                SendHeartInfoToUI("Reconnecting is canceled by user!", false);
            }
        }

        private void fileWatcher__Changed(object sender, FileSystemEventArgs e)
        {
            string desFile = Path.Combine(TS_DATA_BACKUP_PATH, e.Name);

            BDCommon.ForceCopyFile(e.FullPath, desFile);

            FileInfo info = new FileInfo(desFile);
            TTXmlItem item = new TTXmlItem(File.ReadAllText(desFile, System.Text.Encoding.UTF8), info.Length, e.FullPath, desFile, TTXmlItem.TTXmlItemType.FileShare, new TTXmlExtraData(null as TcpClient, false));
            bool bAdded;
            Monitor.Enter(workQueue_);
            bAdded = workQueue_.Enqueue(item);
            System.Diagnostics.Trace.WriteLine(desFile);
            Monitor.Exit(workQueue_);
            if (bAdded)
            {
                manualEvent_.Set();//添加成功则发信号通知工作线程处理
            }
        }
    }

    //TCP数据交换类
    public class TSDataExchangeTT_TCP : TSDataExchangeTT_Service
    {
        private TSDataExchangeTT_TCP(string dbStr, int port)
            : base(dbStr)
        {
            tcpPort_ = port;
            tcpListener_ = new TcpListener(IPAddress.Any, tcpPort_);
            s_listenerEvent = new ManualResetEvent(true);
            s_recvEvent = new ManualResetEvent(true);
            //s_heartCheck = new ManualResetEvent(true);
            s_heartWait = new ManualResetEvent(false);
            recvThreads_ = new Dictionary<TcpClient, ClientsInfo>();


        }
        private int tcpPort_;
        private string strIP_;
        private TcpListener tcpListener_;
        private static TSDataExchangeTT_TCP s_ttTSExchangeTcp = null;
        private Dictionary<TcpClient, ClientsInfo> recvThreads_;
        private Thread listenThread_;
        //private Thread heartCheckThread_;
        private static bool s_bRunning = false;
        private static ManualResetEvent s_listenerEvent = null;
        private static ManualResetEvent s_recvEvent = null;
        //private static ManualResetEvent s_heartCheck = null;
        private static ManualResetEvent s_heartWait = null;

        ~TSDataExchangeTT_TCP()
        {
            s_bRunning = false;
            if (s_listenerEvent != null)
            {
                s_listenerEvent.Close();
                s_listenerEvent = null;
            }
            if (s_recvEvent != null)
            {
                s_recvEvent.Close();
                s_recvEvent = null;
            }
        }

        //SingleTon模型
        public static TSDataExchangeTT_TCP GetDataExchangeTT_TCP(string dbStr, int port)
        {
            if (s_ttTSExchangeTcp == null)
            {
                s_ttTSExchangeTcp = new TSDataExchangeTT_TCP(dbStr, port);
            }
            else
            {
                if (dbStr != dbConn_.ConnectionString)
                {
                    dbConn_.Close();
                    dbConn_.Dispose();
                    dbConn_ = new SqlConnection(dbStr);
                }

                if (port != s_ttTSExchangeTcp.tcpPort_)
                {
                    s_ttTSExchangeTcp.tcpListener_.Stop();
                    s_ttTSExchangeTcp.tcpListener_ = new TcpListener(IPAddress.Any, port);
                    s_ttTSExchangeTcp.tcpPort_ = port;
                }
            }
            return s_ttTSExchangeTcp;
        }
        private void HeartCheckProc()
        {
            TSDataExchangeTT_TCP.s_bRunning = true;
            //s_heartCheck.Reset();
            s_heartWait.Reset();
            while (s_bRunning)
            {
                s_heartWait.WaitOne(10000);//每隔10秒检测
                Monitor.Enter(s_ttTSExchangeTcp.recvThreads_);
                foreach (TcpClient client in s_ttTSExchangeTcp.recvThreads_.Keys)
                {
                    ClientsInfo clientInfo;
                    s_ttTSExchangeTcp.recvThreads_.TryGetValue(client, out clientInfo);
                    if (clientInfo != null && clientInfo.LastHeartTime != null)
                    {
                        TimeSpan timeSpan = DateTime.Now - clientInfo.LastHeartTime;
                        if (timeSpan.TotalSeconds > 25)
                        {
                            client.Close();
                        }
                    }
                }
                Monitor.Exit(s_ttTSExchangeTcp.recvThreads_);
            }

            //s_heartCheck.Set();
        }

        private void ListenProc()
        {
            TSDataExchangeTT_TCP.s_bRunning = true;

            SendHeartInfoToUI("Listen thread has started!", true);
            s_listenerEvent.Reset();
            while (s_bRunning)
            {
                try
                {
                    TcpClient tcpClient = s_ttTSExchangeTcp.tcpListener_.AcceptTcpClient();
                    if (tcpListener_ == null)
                    {
                        break;
                    }
                    IPEndPoint ipEndPt = tcpClient.Client.RemoteEndPoint as IPEndPoint;
                    string info = string.Format("Received a connection from ip:{0} port:{1}", ipEndPt.Address.ToString(), ipEndPt.Port);
                    SendHeartInfoToUI(info, true);
                    Thread clientThread = new Thread(new ParameterizedThreadStart(RecvProc));
                    clientThread.IsBackground = true;
                    clientThread.Start(tcpClient);
                    ClientsInfo clientInfo = new ClientsInfo();
                    clientInfo.RecvThread = clientThread;
                    clientInfo.LastHeartTime = DateTime.Now;
                    Monitor.Enter(s_ttTSExchangeTcp.recvThreads_);
                    s_ttTSExchangeTcp.recvThreads_.Add(tcpClient, clientInfo);
                    Monitor.Exit(s_ttTSExchangeTcp.recvThreads_);
                }
                catch (System.Exception e)
                {
                    break;
                }
            }

            SendHeartInfoToUI("Listen thread exit!", true);
            s_listenerEvent.Set();
            s_bRunning = false;
        }

        private static bool ReadAllData(NetworkStream netStream, byte[] buffer, int size)
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
                catch (System.Exception e)
                {
                    return false;
                }
            }
            return true;
        }

        public void SendStringData(string strData)
        {
            string strNewData = "";


            Monitor.Enter(s_ttTSExchangeTcp.recvThreads_);
            foreach (TcpClient tcpClient in s_ttTSExchangeTcp.recvThreads_.Keys)
            {
                try
                {
                    ClientsInfo clientInfo;
                    s_ttTSExchangeTcp.recvThreads_.TryGetValue(tcpClient, out clientInfo);
                    if (clientInfo == null || !clientInfo.BChatClient)
                    {
                        continue;
                    }

                    strNewData = tcpClient.Client.RemoteEndPoint.ToString() + "|" + strData;
                    byte[] data = System.Text.Encoding.UTF8.GetBytes(strNewData);
                    byte[] sendData = MakePackage(data);
                    NetworkStream netStream = tcpClient.GetStream();
                    netStream.Write(sendData, 0, sendData.Length);
                    netStream.Flush();
                    //  netStream.Close();
                }
                catch (System.Exception e)
                {

                }

            }
            Monitor.Exit(s_ttTSExchangeTcp.recvThreads_);
        }

        private byte[] MakePackage(byte[] data)
        {
            MemoryStream stream = new MemoryStream();
            BinaryWriter writer = new BinaryWriter(stream);
            writer.Write((UInt32)0xFFFFFFFF);
            writer.Write(data.Length);
            writer.Write(data);
            writer.Flush();
            byte[] res = stream.ToArray();
            stream.GetBuffer();
            writer.Close();
            stream.Close();
            return res;
        }

        private void RecvProc(object obj)
        {
            s_recvEvent.Reset();
            TcpClient tcpClient = obj as TcpClient;
            NetworkStream netStream = tcpClient.GetStream();

            IPEndPoint ipEndPt = tcpClient.Client.RemoteEndPoint as IPEndPoint;
            string info = string.Format("Client ip:{0} port:{1} disconnected!", ipEndPt.Address.ToString(), ipEndPt.Port);
            string connInfo = string.Format("Recv thread of ip:{0} port:{1} has started!", ipEndPt.Address.ToString(), ipEndPt.Port);
            SendHeartInfoToUI(connInfo, true);
            string strClient = string.Format("{0}:{1}", ipEndPt.Address.ToString(), ipEndPt.Port);
            AddClient(strClient, true);
            byte[] buffer = new byte[1024 * 1024];
            while (s_bRunning)
            {
                //包头
                if (ReadAllData(netStream, buffer, 4))
                {
                    UInt32 header = BitConverter.ToUInt32(buffer, 0);
                    if (header != 0xFFFFFFFF)
                    {
                        continue;
                    }
                }
                else
                {
                    break;
                }
                //包长
                int dataLen = 0;
                if (ReadAllData(netStream, buffer, 4))
                {
                    dataLen = BitConverter.ToInt32(buffer, 0);
                    if (dataLen <= 0 || dataLen > 1024 * 1024)
                    {
                        continue;
                    }
                }
                else
                {
                    break;
                }
                if (ReadAllData(netStream, buffer, dataLen))
                {
                    UInt32 heartTest = BitConverter.ToUInt32(buffer, 0);
                    if (heartTest == 0xFFFF0000)
                    {
                        Monitor.Enter(s_ttTSExchangeTcp.recvThreads_);
                        ClientsInfo clientInfo;
                        s_ttTSExchangeTcp.recvThreads_.TryGetValue(tcpClient, out clientInfo);
                        if (clientInfo != null)
                        {
                            clientInfo.LastHeartTime = DateTime.Now;
                        }
                        Monitor.Exit(s_ttTSExchangeTcp.recvThreads_);
                        //回复心跳包
                        byte[] sendData = MakePackage(BitConverter.GetBytes((UInt32)0xFFFF0000));
                        netStream.Write(sendData, 0, sendData.Length);
                        continue;
                    }
                    string xml = System.Text.Encoding.UTF8.GetString(buffer, 0, dataLen);
                    if (xml.Substring(0, 8) == "TTTTTTTT")
                    {
                        SendStringData(xml.Substring(8));
                        continue;
                    }
                    if (xml.Substring(0, 8) == "CCCCCCCC")
                    {
                        ClientsInfo clientsInfo;
                        Monitor.Enter(s_ttTSExchangeTcp.recvThreads_);
                        s_ttTSExchangeTcp.recvThreads_.TryGetValue(tcpClient, out clientsInfo);
                        if (clientsInfo != null)
                        {
                            clientsInfo.BChatClient = true;
                        }
                        Monitor.Exit(s_ttTSExchangeTcp.recvThreads_);
                        continue;
                    }
                    TTXmlItem item = new TTXmlItem(xml, dataLen, "TCP", "NULL", TTXmlItem.TTXmlItemType.NetTcp, new TTXmlExtraData(tcpClient, false), true);
                    bool bAdded = false;
                    Monitor.Enter(workQueue_);
                    bAdded = workQueue_.Enqueue(item);
                    Monitor.Exit(workQueue_);
                    if (bAdded)
                    {
                        manualEvent_.Set();//添加成功则发信号通知工作线程处理
                    }
                    else
                    {
                        SendFileInfoToUI(string.Format("The same data has been imported already!"), false);
                    }

                }
                else
                {
                    break;
                }
            }
            AddClient(strClient, false);
            SendHeartInfoToUI(info, false);
            tcpClient.Close();
            netStream.Close();
            Monitor.Enter(s_ttTSExchangeTcp.recvThreads_);
            s_ttTSExchangeTcp.recvThreads_.Remove(tcpClient);
            if (s_ttTSExchangeTcp.recvThreads_.Count == 0)
            {
                Monitor.Exit(s_ttTSExchangeTcp.recvThreads_);
                s_recvEvent.Set();//所有客户端线程均结束之后再设置信号
            }
            else
            {
                Monitor.Exit(s_ttTSExchangeTcp.recvThreads_);
            }

        }

        public bool StartServer()
        {
            if (s_bRunning)
            {
                lastErrorMsg_ = "Server is running!";
                return false;
            }
            if (!TestDBConnection())
            {
                return false;
            }
            try
            {
                tcpListener_.Start();
            }
            catch (System.Exception e)
            {
                lastErrorMsg_ = e.Message;
                return false;
            }
            if (listenThread_ == null)
            {
                listenThread_ = new Thread(new ThreadStart(ListenProc));
                listenThread_.IsBackground = true;
            }
            //心跳检测线程
            //if (heartCheckThread_ == null )
            //{
            //    heartCheckThread_ = new Thread(new ThreadStart(HeartCheckProc));
            //    heartCheckThread_.IsBackground = true;
            //}
            listenThread_.Start();
            //heartCheckThread_.Start();
            return true;
        }

        public void CloseServer()
        {
            s_bRunning = false;
            s_heartWait.Set();//使得心跳检测线程停止阻塞
            if (tcpListener_ != null)
            {
                tcpListener_.Stop();
            }
            Monitor.Enter(recvThreads_);
            foreach (TcpClient tcpClient in recvThreads_.Keys)
            {
                tcpClient.Close();
            }
            Monitor.Exit(recvThreads_);
            s_listenerEvent.WaitOne();//等待监听线程退出
            //  s_heartCheck.WaitOne();
            s_recvEvent.WaitOne();//等待工作线程退出

            if (listenThread_ != null)
            {
                listenThread_ = null;
            }
            recvThreads_.Clear();
        }
    }

    //UDP数据交换类
    public class TSDataExchangeTT_UDP : TSDataExchangeTT_Service
    {
        private TSDataExchangeTT_UDP(string dbStr, int port)
            : base(dbStr)
        {
            udpPort_ = port;
            s_recvEvent = new ManualResetEvent(true);
            s_heartCheck = new ManualResetEvent(false);
            s_heartWait = new ManualResetEvent(false);
            udpClient_ = new UdpClient();
            clientList_ = new Dictionary<string, ClientsInfo>();
        }
        private int udpPort_;
        private string strIP_;
        private static TSDataExchangeTT_UDP s_ttTSExchangeUdp = null;
        private static bool s_bRunning = false;
        private static ManualResetEvent s_recvEvent = null;
        private UdpClient udpClient_ = null;
        private Thread recvThread_ = null;
        private Thread heartCheckThread_;
        private static ManualResetEvent s_heartCheck = null;
        private static ManualResetEvent s_heartWait = null;
        private Dictionary<string, ClientsInfo> clientList_;

        ~TSDataExchangeTT_UDP()
        {
            s_bRunning = false;
            if (s_recvEvent != null)
            {
                s_recvEvent.Close();
                s_recvEvent = null;
            }
        }

        //SingleTon模型
        public static TSDataExchangeTT_UDP GetDataExchangeTT_UDP(string dbStr, int port)
        {
            if (s_ttTSExchangeUdp == null)
            {
                s_ttTSExchangeUdp = new TSDataExchangeTT_UDP(dbStr, port);
            }
            else
            {
                if (dbStr != dbConn_.ConnectionString)
                {
                    dbConn_.Close();
                    dbConn_.Dispose();
                    dbConn_ = new SqlConnection(dbStr);
                }

                if (port != s_ttTSExchangeUdp.udpPort_)
                {
                    s_ttTSExchangeUdp.udpClient_.Close();
                    s_ttTSExchangeUdp.udpClient_ = new UdpClient();
                    s_ttTSExchangeUdp.udpPort_ = port;
                }
            }
            return s_ttTSExchangeUdp;
        }

        private void RecvProc()
        {
            s_recvEvent.Reset();
            s_bRunning = true;
            while (s_bRunning)
            {
                IPEndPoint remoteIP = null;
                try
                {
                    byte[] recvData = udpClient_.Receive(ref remoteIP);
                    string strRemoteIP = remoteIP.Address.ToString();
                    Monitor.Enter(clientList_);
                    if (!clientList_.ContainsKey(strRemoteIP))
                    {
                        ClientsInfo clInfo = new ClientsInfo();
                        clInfo.LastHeartTime = DateTime.Now;
                        clientList_.Add(strRemoteIP, clInfo);
                        Monitor.Exit(clientList_);

                        //AddClient(strRemoteIP, true);
                        string connInfo = string.Format("Received a client:{0}", strRemoteIP);
                        SendHeartInfoToUI(connInfo, true);
                    }
                    else
                    {
                        ClientsInfo clInfo = null;
                        bool bFind = clientList_.TryGetValue(strRemoteIP, out clInfo);
                        if (bFind)
                        {
                            clInfo.LastHeartTime = DateTime.Now;//更新最后接收时间
                        }
                        Monitor.Exit(clientList_);
                    }

                    TTXmlItem item = new TTXmlItem(strRemoteIP, strRemoteIP.Length, "UDP", "NULL", TTXmlItem.TTXmlItemType.NetUdp, new TTXmlExtraData(remoteIP, recvData), true);
                    bool bAdded = false;
                    Monitor.Enter(workQueue_);
                    bAdded = workQueue_.Enqueue(item);
                    Monitor.Exit(workQueue_);
                    if (bAdded)
                    {
                        manualEvent_.Set();//添加成功则发信号通知工作线程处理
                    }
                    else
                    {
                        SendFileInfoToUI(string.Format("The same data has been imported already!"), false);
                    }
                }
                catch (System.Exception ex)
                {
                    lastErrorMsg_ = ex.Message;
                    break;
                }

            }
            s_bRunning = false;

            s_recvEvent.Set();

        }

        private void HeartCheckProc()
        {
            TSDataExchangeTT_UDP.s_bRunning = true;
            s_heartWait.Reset();
            while (s_bRunning)
            {
                s_heartWait.WaitOne(10000);//每隔10秒检测
                Monitor.Enter(s_ttTSExchangeUdp.clientList_);
            recheck:
                foreach (string clientIp in s_ttTSExchangeUdp.clientList_.Keys)
                {
                    ClientsInfo clientInfo;
                    s_ttTSExchangeUdp.clientList_.TryGetValue(clientIp, out clientInfo);
                    if (clientInfo != null && clientInfo.LastHeartTime != null)
                    {
                        TimeSpan timeSpan = DateTime.Now - clientInfo.LastHeartTime;
                        if (timeSpan.TotalSeconds > 25)
                        {
                            s_ttTSExchangeUdp.clientList_.Remove(clientIp);
                            AddClient(clientIp, false);
                            string connInfo = string.Format("{0}:heart checking is out of time! ", clientIp);
                            SendHeartInfoToUI(connInfo, false);
                            goto recheck;
                        }
                    }
                }
                Monitor.Exit(s_ttTSExchangeUdp.clientList_);
            }

            s_heartCheck.Set();
        }
        public bool StartServer()
        {
            if (s_bRunning)
            {
                lastErrorMsg_ = "Server is running!";
                return false;
            }
            if (!TestDBConnection())
            {
                return false;
            }
            try
            {
                if (udpClient_ != null)
                {
                    udpClient_.Close();
                }
                udpClient_ = new UdpClient();
                udpClient_.Client.Bind(new IPEndPoint(IPAddress.Any, udpPort_));
            }
            catch (System.Exception e)
            {
                lastErrorMsg_ = e.Message;
                return false;
            }
            if (recvThread_ == null)
            {
                recvThread_ = new Thread(new ThreadStart(RecvProc));
                recvThread_.IsBackground = true;
            }
            //心跳检测线程
            if (heartCheckThread_ == null)
            {
                heartCheckThread_ = new Thread(new ThreadStart(HeartCheckProc));
                heartCheckThread_.IsBackground = true;
            }
            //启动接收线程
            recvThread_.Start();
            heartCheckThread_.Start();
            return true;
        }

        public void CloseServer()
        {
            s_bRunning = false;
            s_heartWait.Set();//使心跳检测立即执行
            if (udpClient_ != null)
            {
                udpClient_.Close();
                udpClient_ = null;
            }
            s_recvEvent.WaitOne();//等待接收线程退出
            s_heartCheck.WaitOne();//等待心跳线程退出
            if (recvThread_ != null)
            {
                recvThread_ = null;
            }
            if (heartCheckThread_ != null)
            {
                heartCheckThread_ = null;
            }
            Monitor.Enter(clientList_);
            clientList_.Clear();
            Monitor.Exit(clientList_);
        }
    }

    public class TS_TTConfig
    {
        public string ExportPath { set; get; }
        public string ImportPath { set; get; }
        public string TcpPort { set; get; }
        public string ImportType { set; get; }
        public string CtrlCenterIP { set; get; }
        public string CenterPort { set; get; }
        public TS_TTConfig()
        {
        }
        public static string GetConfigFilePath()
        {
            string path = System.Environment.GetFolderPath(System.Environment.SpecialFolder.LocalApplicationData);
            path = Path.Combine(path, string.Format("OVRConfig\\{0}_Plugin", BDCommon.g_strDisplnCode));
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            path = Path.Combine(path, string.Format("{0}_config.ini", BDCommon.g_strDisplnCode));
            return path;
        }
        public static void ShellOpenConfig()
        {

            BDCommon.ShellOpenFile(GetConfigFilePath());
        }
        public void LoadConfig()
        {
            ExportPath = "";
            ImportPath = "";
            TcpPort = "";
            ImportType = "2";
            string filePath = GetConfigFilePath();
            if (!File.Exists(filePath))
            {
                SaveConfig();
                return;
            }
            INIClass ini = new INIClass(filePath);
            ExportPath = ini.IniReadValue("TT_TS", "ExportPath");
            ImportPath = ini.IniReadValue("TT_TS", "ImportPath");
            TcpPort = ini.IniReadValue("TT_TS", "TcpPort");
            ImportType = ini.IniReadValue("TT_TS", "ImportType");
            CtrlCenterIP = ini.IniReadValue("TT_TS", "CenterIP");
            CenterPort = ini.IniReadValue("TT_TS", "CenterPort");
        }

        public void SaveConfig()
        {
            string strFile = GetConfigFilePath();
            INIClass ini = new INIClass(strFile);
            ini.IniWriteValue("TT_TS", "ExportPath", ExportPath);
            ini.IniWriteValue("TT_TS", "ImportPath", ImportPath);
            ini.IniWriteValue("TT_TS", "TcpPort", TcpPort);
            ini.IniWriteValue("TT_TS", "ImportType", ImportType);
            ini.IniWriteValue("TT_TS", "CenterIP", CtrlCenterIP);
            ini.IniWriteValue("TT_TS", "CenterPort", CenterPort);
        }
    }

    public class ClientsInfo
    {
        public ClientsInfo()
        {
            BChatClient = false;
        }
        public Thread RecvThread;
        public bool BChatClient;
        public DateTime LastHeartTime;
    }
    public enum ResultType : int
    {
        Synchronize = 1,
        UnlockCourt = 2,
        LockCourt = 3,
        DelData = 4,
        GetMatchData = 5,
        RecvMsg = 6,
        TransData = 7,//res = 1成功，res = -1，源端获取原始数据失败, res = -2 为当前比赛正在进行，不接收外部数据
        CreateTempMatch = 8,//res = 1成功, res = -1失败
    }
}




