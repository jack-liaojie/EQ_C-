using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Xml;

namespace AutoSports.OVRBDPlugin
{
    public enum XmlTypeEnum
    {
        XmlTypeMatchInfo,
        XmlTypeAcitonListSingle,
        XmlTypeAcitonListAll,
        XmlTypeClientExportSchedule,
        XmlTypeClientChat
    }
    public enum ExtraWorkEnum : int
    {
        ExtraWorkNotifyProgress = 0x01,
        ExtraWorkNotifyStatusRunning = 0x02,
        ExtraWorkNotifySplitInfo = 0x04,
        ExtraWorkNotifySetCurrentFlag = 0x08,
        ExtraWorkNotifyStatusUnofficial = 0x10,
        ExtraWorkNotifyStatusStartList = 0x20,
        ExtraWorkNotifyExportSchedule = 0x40,
        ExtraWorkNotifyChat = 0x80,
    }

    public class ExtraTaskInfo
    {
        public ExtraTaskInfo()
        {

        }
        public ExtraTaskInfo(int flag, int matchID, int setOrder, int gameOrder,bool bTaskOK)
        {
            TaskFlags = flag;
            MatchID = matchID;
            SetOrder = setOrder;
            GameOrder = gameOrder;
            BTaskOK = bTaskOK;
        }
        public int TaskFlags;
        public int MatchID;
        public int SetOrder;
        public int GameOrder;
        public bool BTaskOK;//标志task是否获取正常
        public string ChatName;
        public string ChatIP;
        public string ChatContent;
        public ExtraTaskInfo Clone()
        {
            ExtraTaskInfo info = new ExtraTaskInfo(TaskFlags, MatchID, SetOrder, GameOrder,BTaskOK);
            info.ChatName = this.ChatName;
            info.ChatIP = this.ChatIP;
            info.ChatContent = this.ChatContent;
            return info;
        }
    }
    public class DataProcessTT
    {

        public DataProcessTT(SqlConnection sqlConn)
        {
            sqlConnection_ = sqlConn;
            curGameScores_ = new Dictionary<string, CurrentGameScore>();
            lastMatchInfos_ = new Dictionary<string, LastMatchStatusInfo>();
            ExtraTask = new ExtraTaskInfo();
            ExtraTask.BTaskOK = false;
        }

        public ExtraTaskInfo ExtraTask { private set; get; }


        public XmlTypeEnum XmlType { private set; get; }

        private Dictionary<string, CurrentGameScore> curGameScores_;
        private Dictionary<string, LastMatchStatusInfo> lastMatchInfos_;
        public void ClearMemory()
        {
            if (curGameScores_ != null)
            {
                curGameScores_.Clear();
            }
        }

        private SqlConnection sqlConnection_;

        public string GetRscStringFromMatchID(int matchID)
        {
            SqlConnection sqlConnection = new SqlConnection();
            sqlConnection.ConnectionString = sqlConnection_.ConnectionString;
            try
            {
                if (sqlConnection.State != ConnectionState.Open)
                {
                    sqlConnection.Open();
                }
            }
            catch (System.Exception e)
            {
                LastErrorString = e.Message;
                BDCommon.Writelog("打开数据库失败！", e.Message);
                return "";
            }
            SqlCommand sqlCmd = sqlConnection.CreateCommand();
            sqlCmd.CommandText = "Fun_BDTT_GetMatchRscCode";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
            SqlParameter param = sqlCmd.Parameters.Add("@returnString", SqlDbType.NVarChar, 100);
            param.Direction = ParameterDirection.ReturnValue;
            SqlDataReader dr = null;
            try
            {
                //sqlCmd.ExecuteScalar();
                //dr = sqlCmd.ExecuteReader();
                //if (dr.Read())
                //{
                //    return dr.GetString(0);
                //}
                //return "";
                sqlCmd.ExecuteNonQuery();
                if ( param.Value == null )
                {
                    return "";
                }
                return param.Value.ToString();
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("Fun_BDTT_GetMatchRscCode异常", e.Message);
                return "";
            }
            finally
            {
                if ( sqlConnection != null )
                {
                    sqlConnection.Close();
                }
            }
        }

        public int GetMatchIDFromRSC(string matchRsc)
        {
            if (matchRsc.Length != 9)
            {
                return -2;
            }
            SqlConnection sqlConnection = new SqlConnection();
            sqlConnection.ConnectionString = sqlConnection_.ConnectionString;
            try
            {
                if (sqlConnection.State != ConnectionState.Open)
                {
                    sqlConnection.Open();
                }
            }
            catch (System.Exception e)
            {
                LastErrorString = e.Message;
                BDCommon.Writelog("打开数据库失败！", e.Message);
                return -1;
            }
            SqlCommand sqlCmd = sqlConnection.CreateCommand();
            sqlCmd.CommandText = "Fun_BDTT_GetMatchIDFromRsc";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.Add("@MatchRsc", SqlDbType.NVarChar).Value = matchRsc;
            SqlParameter param = sqlCmd.Parameters.Add("@returnInt", SqlDbType.Int);
            param.Direction = ParameterDirection.ReturnValue;
            try
            {
                //sqlCmd.ExecuteScalar();
                //if (param.Value.GetType().Name == "DBNull")
                //{
                //    return -3;
                //}
                sqlCmd.ExecuteNonQuery();
                if (param.Value == null)
                {
                    return -3;
                }
                return Convert.ToInt32(param.Value);
            }
            catch (System.Exception e)
            {
                BDCommon.Writelog("Fun_BDTT_GetMatchIDFromRsc异常", e.Message);
                return -1;
            }
            finally
            {
                if ( sqlConnection != null )
                {
                    sqlConnection_.Close();
                }
            }
        }

        private bool ImportMatchInfoXml(XmlTypeEnum type, string strMatchCode, string strXml)
        {
            SqlConnection sqlConnection = new SqlConnection();
            sqlConnection.ConnectionString = sqlConnection_.ConnectionString;
            try
            {
                if (sqlConnection.State != ConnectionState.Open)
                {
                    sqlConnection.Open();
                }
            }
            catch (System.Exception e)
            {
                LastErrorString = e.Message;
                BDCommon.Writelog("打开数据库失败！", e.Message);
                return false;
            }


            try
            {
                SqlCommand sqlCmd = sqlConnection.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                SqlParameter sqlParam = null;
                if (type == XmlTypeEnum.XmlTypeMatchInfo)
                {
                    sqlCmd.CommandText = string.Format("Proc_{0}_ImportMatchInfoXML",BDCommon.g_strDisplnCode) ;
                    sqlCmd.Parameters.Add("@MatchRsc", SqlDbType.NVarChar, 30).Value = strMatchCode;
                    sqlCmd.Parameters.Add("@MatchInfoXML", SqlDbType.NVarChar, 2000000).Value = strXml;
                    sqlCmd.Parameters.Add("@BForce", SqlDbType.Int).Value = 0;//非强制导入时,official状态下不允许导入数据
                    sqlParam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                    sqlParam.Direction = ParameterDirection.Output;
                }
                else if (type == XmlTypeEnum.XmlTypeAcitonListAll)
                {
                    sqlCmd.CommandText = string.Format("Proc_{0}_ImportActionAll", BDCommon.g_strDisplnCode);
                    sqlCmd.Parameters.Add("@MatchRsc", SqlDbType.NVarChar, 30).Value = strMatchCode;
                    sqlCmd.Parameters.Add("@MatchInfoXML", SqlDbType.NVarChar, 2000000).Value = strXml;
                    sqlParam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                    sqlParam.Direction = ParameterDirection.Output;
                }
                else
                {
                    LastErrorString = "错误的XML枚举类型！";
                    return false;
                }

                sqlCmd.ExecuteNonQuery();
                ErrorIntDes = (int)sqlParam.Value;
                if ((int)sqlParam.Value > 0)
                {
                    return true;
                }
                if (type == XmlTypeEnum.XmlTypeMatchInfo)
                {
                    if (ErrorIntDes == -2 )
                    {
                        LastErrorString = string.Format("Official之后拒绝再次导入，matchCode:{0}", strMatchCode);
                    }
                    else
                    {
                        LastErrorString = string.Format("Proc_TT_ImportMatchInfoXML错误，错误码：{0}", sqlParam.Value);
                    }
                }
                else
                {
                    LastErrorString = string.Format("Proc_TT_ImportActionAll错误，错误码：{0}", sqlParam.Value);
                }
                
                BDCommon.Writelog(LastErrorString);
                return false;
            }
            catch (System.Exception e)
            {
                LastErrorString = e.Message;
                BDCommon.Writelog("导入Match xml数据异常", e.Message);
                return false;
            }
            finally
            {
                if ( sqlConnection != null )
                {
                    sqlConnection.Close();
                }
            }
        }
        //错误时为存储过程返回的错误码，正确时为MatchID
        public int ErrorIntDes { get; private set; }
        public string MatchCode { get; private set; }

        private bool ImportAcitonListSingle(string matchCode, int matchNo, int gameNo, string strXml)
        {
            SqlConnection sqlConnection = new SqlConnection();
            sqlConnection.ConnectionString = sqlConnection_.ConnectionString;
            try
            {
                if (sqlConnection.State != ConnectionState.Open)
                {
                    sqlConnection.Open();
                }
            }
            catch (System.Exception e)
            {
                LastErrorString = e.Message;
                BDCommon.Writelog("打开数据库失败！", e.Message);
                return false;
            }

            try
            {
                SqlCommand sqlCmd = sqlConnection.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                SqlParameter sqlParam = null;
                sqlCmd.CommandText = string.Format("Proc_{0}_ImportActionSingle", BDCommon.g_strDisplnCode);
                sqlCmd.Parameters.Add("@MatchRsc", SqlDbType.NVarChar, 30).Value = matchCode;
                sqlCmd.Parameters.Add("@MatchNo", SqlDbType.Int).Value = matchNo;
                sqlCmd.Parameters.Add("@GameNo", SqlDbType.Int).Value = gameNo;
                sqlCmd.Parameters.Add("@MatchInfoXML", SqlDbType.NVarChar, 2000000).Value = strXml;
                sqlParam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                sqlParam.Direction = ParameterDirection.Output;

                sqlCmd.ExecuteNonQuery();
                ErrorIntDes = (int)sqlParam.Value;
                if ((int)sqlParam.Value > 0)
                {
                    return true;
                }
                LastErrorString = string.Format("ImportAcitonListSingle错误，错误码：{0}", sqlParam.Value);
                BDCommon.Writelog(LastErrorString);
                return false;
            }
            catch (System.Exception e)
            {
                LastErrorString = e.Message;
                BDCommon.Writelog("导入Match Action xml数据异常", e.Message);
                return false;
            }
            finally
            {
                if ( sqlConnection != null )
                {
                    sqlConnection.Close();
                }
            }
        }

        private CurrentGameScore GetOrCreateGameScore(string matchCode)
        {
            if (curGameScores_.ContainsKey(matchCode))
            {
                CurrentGameScore curGame = null;
                if (curGameScores_.TryGetValue(matchCode, out curGame))
                {
                    return curGame;
                }
                else
                {
                    LastErrorString = "例程字典出现错误！";
                    return null;
                }
            }
            else
            {
                CurrentGameScore gameScore = new CurrentGameScore();
                curGameScores_.Add(matchCode, gameScore);
                return gameScore;
            }
        }

        private LastMatchStatusInfo GetOrCreateLastMatchStatusInfo(string matchCode)
        {
            if ( lastMatchInfos_.ContainsKey(matchCode))
            {
                LastMatchStatusInfo lastInfo = null;
                if (lastMatchInfos_.TryGetValue(matchCode, out lastInfo))
                {
                    return lastInfo;
                }
                else
                {
                    LastErrorString = "LastInfo例程字典出现错误！";
                    return null;
                }
            }
            else
            {
                LastMatchStatusInfo lastInfo = new LastMatchStatusInfo();
                lastMatchInfos_.Add(matchCode, lastInfo);
                return lastInfo;
            }
        }

        public bool ProcessXmlData(string strXml, object extraData)
        {
            if (strXml.Length <= 8)
            {
                LastErrorString = "xml文件字节小于等于8，为无效文件";
                return false;
            }
            if (strXml.Substring(0, 2) == "<?")
            {
                int endIndex = strXml.IndexOf("?>");
                if (endIndex == -1)
                {
                    LastErrorString = "xml文件头非法！未找到头结束标志";
                    return false;
                }
                strXml = strXml.Substring(endIndex + 2);
            }

            try
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(strXml);
                XmlNode xmlNode = xmlDoc.SelectSingleNode("/MatchInfo");
                if (xmlNode == null)
                {
                    LastErrorString = "查找<MatchInfo 失败";
                    return false;
                }
                XmlNode firstNode = xmlNode.FirstChild;
                if (firstNode == null)
                {
                    LastErrorString = "查找<MatchInfo的第一子级失败";
                    return false;
                }
                if (firstNode.Name == "Duel")
                {
                    XmlType = XmlTypeEnum.XmlTypeMatchInfo;
                    string matchCode = xmlNode.Attributes["MatchCode"].Value.ToString();
                    MatchCode = matchCode;
                    if (ImportMatchInfoXml(XmlTypeEnum.XmlTypeMatchInfo, matchCode, xmlNode.InnerXml))
                    {
                        UpdateExtraTaskInfo(strXml);
                        return true;
                    }
                    {
                        return false;
                    }

                }
                else if (firstNode.Name == "Score")
                {
                    XmlType = XmlTypeEnum.XmlTypeAcitonListSingle;
                    string matchCode = xmlNode.Attributes["MatchCode"].Value.ToString();
                    MatchCode = matchCode;
                    bool bActionAll = (bool)((extraData as TTXmlExtraData).Data);
                    int curMatchNo = Convert.ToInt32( xmlNode.Attributes["CurSubMatch_No"].Value);
                    int curGameNo = Convert.ToInt32(xmlNode.Attributes["CurGame_No"].Value);

                    //TT的处理
                    if (BDCommon.g_strDisplnCode == "TT")
                    {
                        string matchStatus = xmlNode.Attributes["Match_State"].Value.ToString();
                        if (matchStatus != "5")
                        {
                            if (ImportAcitonListSingle(matchCode, curMatchNo, curGameNo, strXml))
                            {
                                UpdateExtraTaskInfo(strXml);
                                return true;
                            }
                            else
                            {
                                return false;
                            }
                        }
                        else
                        {
                            if (ImportMatchInfoXml(XmlTypeEnum.XmlTypeAcitonListAll, matchCode, strXml))
                            {
                                UpdateExtraTaskInfo(strXml);
                                return true;
                            }
                            {
                                return false;
                            }

                        }
                    }
                    else//BD的处理
                    {
                        TTXmlExtraData ttItemExtra = extraData as TTXmlExtraData;
                        if ( (bool)ttItemExtra.Data)
                        {
                            if (ImportMatchInfoXml(XmlTypeEnum.XmlTypeAcitonListAll, matchCode, strXml))
                            {
                                UpdateExtraTaskInfo(strXml);
                                return true;
                            }
                            {
                                return false;
                            }
                        }
                        else
                        {
                            if (ImportAcitonListSingle(matchCode, curMatchNo, curGameNo, strXml))
                            {
                                UpdateExtraTaskInfo(strXml);
                                return true;
                            }
                            else
                            {
                                return false;
                            }
                        }
                    }
                        
                }
                else if (firstNode.Name == "Export")
                {
                    XmlType = XmlTypeEnum.XmlTypeClientExportSchedule;
                    UpdateExtraTaskInfo(strXml);
                    return true;
                }
                else if ( firstNode.Name == "Chat")
                {
                    XmlType = XmlTypeEnum.XmlTypeClientChat;
                    UpdateExtraTaskInfo(strXml);
                    return true;
                }
                else
                {
                    LastErrorString = "不能识别的协议类型";
                    return false;
                }
            }
            catch (System.Exception e)
            {
                LastErrorString = e.Message;
                BDCommon.Writelog("解析xml文件失败！", e.Message);
                return false;
            }


            return true;
        }

        //更新额外的任务
        public bool UpdateExtraTaskInfo(string strXml)
        {
            try
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(strXml);
                XmlNode xmlNode = xmlDoc.SelectSingleNode("/MatchInfo");
                if (xmlNode == null)
                {
                    LastErrorString = "查找<MatchInfo 失败";
                    ExtraTask.BTaskOK = false;
                    return false;
                }
                XmlNode firstNode = xmlNode.FirstChild;
                if (firstNode == null)
                {
                    LastErrorString = "查找<MatchInfo的第一子级失败";
                    ExtraTask.BTaskOK = false;
                    return false;
                }
               
                //MatchInfo信息
                if (firstNode.Name == "Duel")
                {
                    ExtraTask.MatchID = GetMatchIDFromRSC(MatchCode);
                    if (ExtraTask.MatchID <= 0)
                    {
                        ExtraTask.BTaskOK = false;
                        return false;
                    }
                    ExtraTask.TaskFlags = (int)ExtraWorkEnum.ExtraWorkNotifyProgress;
                    ExtraTask.TaskFlags |= (int)ExtraWorkEnum.ExtraWorkNotifySplitInfo;
                    LastMatchStatusInfo lastInfo = GetOrCreateLastMatchStatusInfo(MatchCode);
                    string newStatus = firstNode.Attributes["DuelState"].Value.ToString();
                    if ( lastInfo.LastMatchStatus != newStatus)
                    {
                        if ( newStatus == "4" )
                        {
                            ExtraTask.TaskFlags |= (int)ExtraWorkEnum.ExtraWorkNotifyStatusRunning;
                        }
                        else if ( newStatus == "5")
                        {
                            ExtraTask.TaskFlags |= (int)ExtraWorkEnum.ExtraWorkNotifyStatusUnofficial;
                        }
                        else if ( newStatus == "2")
                        {
                            ExtraTask.TaskFlags |= (int)ExtraWorkEnum.ExtraWorkNotifyStatusStartList;
                        }
                        lastInfo.LastMatchStatus = newStatus;
                    }
                    else if ( newStatus == "5")//unofficial永远都触发
                    {
                        ExtraTask.TaskFlags |= (int)ExtraWorkEnum.ExtraWorkNotifyStatusUnofficial;
                    }
                }
                else if (firstNode.Name == "Score")
                {
                    ExtraTask.MatchID = GetMatchIDFromRSC(MatchCode);
                    if (ExtraTask.MatchID <= 0)
                    {
                        ExtraTask.BTaskOK = false;
                        return false;
                    }
                    ExtraTask.TaskFlags = (int)ExtraWorkEnum.ExtraWorkNotifyProgress;
                }
                else if ( firstNode.Name == "Export")
                {
                    ExtraTask.TaskFlags = (int)ExtraWorkEnum.ExtraWorkNotifyExportSchedule;
                }
                else if ( firstNode.Name == "Chat")
                {
                    ExtraTask.TaskFlags = (int)ExtraWorkEnum.ExtraWorkNotifyChat;
                    ExtraTask.ChatName = firstNode.Attributes["Name"].Value.ToString();
                    ExtraTask.ChatIP = firstNode.Attributes["IP"].Value.ToString();
                    ExtraTask.ChatContent = firstNode.Attributes["Message"].Value.ToString();
                }
                else
                {
                    ExtraTask.BTaskOK = false;
                    return false;
                }
            }
            catch (Exception e)
            {
                LastErrorString = e.Message;
                return false;
            }
            ExtraTask.BTaskOK = true;
            return true;
        }

        public string LastErrorString { get; private set; }
    }

    public class ScoreItem
    {
        public int ActionOrder;
        public int GameScoreA;
        public int GameScoreB;
        public int CompareTo(ScoreItem item)
        {
            if (this.ActionOrder == item.ActionOrder && this.GameScoreA == item.GameScoreA
                    && this.GameScoreB == item.GameScoreB)
            {
                return 0;
            }
            else
            {
                return 1;
            }
        }
    }

    public class CurrentGameScore
    {
        public CurrentGameScore()
        {
            curGameOrder_ = -1;
            curMatchOrder_ = -1;
            actionList_ = new List<ScoreItem>();
        }
        private int curMatchOrder_;

        public int CurMatchOrder
        {
            get { return curMatchOrder_; }
        }
        public int CurGameOrder
        {
            get { return curGameOrder_; }
        }
        private int curGameOrder_;
        private List<ScoreItem> actionList_;
        //public int UpdateData( string xmlAction)
        //{


        //}

        public int AdvisedOrder
        {
            private set;
            get;
        }

        public string LastErrorString { private set; get; }
        public string NewXml { private set; get; }

        public bool UpdateData(string xmlAction)
        {
            try
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(xmlAction);
                XmlNode xmlNode = xmlDoc.SelectSingleNode("/MatchInfo");
                if (xmlNode == null)
                {
                    LastErrorString = "查找<MatchInfo 失败";
                    return false;
                }
                XmlNodeList xmlList = xmlNode.ChildNodes;
                if (xmlList.Count == 0)
                {
                    LastErrorString = "Acition list xml \"MatchInfo\"子节点为空";
                    return false;
                }
                if (xmlList[0].Name != "Score")
                {
                    LastErrorString = "节点名不为Score，违反协议";
                    return false;
                }

                string curMatch = xmlNode.Attributes["CurSubMatch_No"].Value.ToString();
                string curGame = xmlNode.Attributes["CurGame_No"].Value.ToString();


                List<ScoreItem> scoreItems = new List<ScoreItem>();
                List<string> gameXmlAll = new List<string>();

                //保存当前局的所有Score和xml
                foreach (XmlNode sNode in xmlList)
                {
                    if (sNode.Attributes["Match_No"].Value.ToString() == curMatch
                        && sNode.Attributes["Game_No"].Value.ToString() == curGame)
                    {
                        ScoreItem item = new ScoreItem();
                        item.ActionOrder = Convert.ToInt32(sNode.Attributes["Order"].Value);
                        item.GameScoreA = Convert.ToInt32(sNode.Attributes["GameScoreA"].Value);
                        item.GameScoreB = Convert.ToInt32(sNode.Attributes["GameScoreB"].Value);
                        scoreItems.Add(item);
                        gameXmlAll.Add(sNode.OuterXml);
                    }
                }
                if (scoreItems.Count == 0)
                {
                    LastErrorString = "当前局下没有action，请检查xml文件";
                    return false;
                }

                if (scoreItems[0].ActionOrder != 0)
                {
                    LastErrorString = "actionList_不是从1开始，请检查文件";
                    return false;
                }

                //判断当前局是否变化，如果当前局变化则设置修改编号为0
                if (curMatch != curMatchOrder_.ToString() || curGame != curGameOrder_.ToString())
                {
                    AdvisedOrder = 0;
                }
                else
                {
                    //当前局未变化，则首先取出历史记录和新获取的记录数中最少的一个
                    int count = actionList_.Count <= scoreItems.Count ? actionList_.Count : scoreItems.Count;

                    //首先判断前面的数据是否有改变，如果有改变，则设置改变的那一条为修改编号
                    bool bChanged = false;
                    for (int i = 0; i < count; i++)
                    {
                        if (actionList_[i].ActionOrder != scoreItems[i].ActionOrder
                            || actionList_[i].GameScoreA != scoreItems[i].GameScoreA
                            || actionList_[i].GameScoreB != scoreItems[i].GameScoreB)
                        {
                            AdvisedOrder = actionList_[i].ActionOrder;
                            bChanged = true;
                            break;
                        }
                    }

                    //前面的数据对比无误
                    if (!bChanged)
                    {
                        //如果数量也相等，说明完全相同，则只取最后一条用于更新比分
                        if (actionList_.Count == scoreItems.Count)
                        {
                            AdvisedOrder = -1;
                            NewXml = gameXmlAll[gameXmlAll.Count - 1];
                            NewXml = "<MatchInfo>" + NewXml + "</MatchInfo>";
                            return true;
                        }
                        else
                        {
                            //数量不等，如果原记录小于新记录，则设置原记录为修改编号，如果原记录大于新记录，则从新记录设置为修改标志
                            AdvisedOrder = actionList_.Count < scoreItems.Count ? actionList_.Count: scoreItems.Count;
                        }
                    }
                }

                actionList_.Clear();
                foreach (ScoreItem sItem in scoreItems)
                {
                    actionList_.Add(sItem);
                }

                string strNewXml = "";
                //提取修改部分的xml，如果修改编号大于xml的数量，则说明是删除操作，strNewXml为空
                if (AdvisedOrder <= gameXmlAll.Count-1)
                {
                    for (int i = AdvisedOrder; i < gameXmlAll.Count; i++)
                    {
                        strNewXml += gameXmlAll[i];
                    }
                }
                else
                {
                    strNewXml = "";
                }
                NewXml = strNewXml;
                if ( NewXml.Trim() != "" )
                {
                    NewXml = "<MatchInfo>" + NewXml + "</MatchInfo>";
                }

                curMatchOrder_ = Convert.ToInt32(curMatch);
                curGameOrder_ = Convert.ToInt32(curGame);
                return true;
            }
            catch (System.Exception e)
            {
                LastErrorString = e.ToString();
                BDCommon.Writelog("ParsedActionXml异常", e.ToString());
                return false;
            }

        }
    }

    public class LastMatchStatusInfo
    {
        public LastMatchStatusInfo()
        {
            LastMatchStatus = "";
            LastMatchOrder = "";
            LastMatchStatus = "";
        }
        public string LastMatchStatus;
        public string LastMatchOrder;
        public string LastGameOrder;
    }
}
