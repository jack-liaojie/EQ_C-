using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Diagnostics;
using System.Xml;
using System.Data;

//所有对客户端的操作,都在这里
namespace AutoSports.OVREQPlugin
{
	public enum EmMsgType
	{
		Normal = 1,
		Important = 2,
		Error = 3,
		Debug = 4,
	};

	public class JudgePanelInfo
	{
		public const int TIMEOUT_HEARTBEAT = 4000;

		public IPEndPoint _ip;				//此客户端Ip及接收端口, 为Null表示此客户端未启用
		public string _judgeDesc;			//裁判标示,在客户端登陆时自动从上层获取
		public string _version;
		public int _lastRcvTimeoutTickCnt;	//最后接收此客户端信息的时间
		public int _lastSendMatchTickCnt;	//最后一次发送MatchInfo的时间, 0表示未在等待回复状态
		public int _batteryPercent;			//电池%	0-100	如果AC,也为100

		public JudgePanelInfo()
		{
			_ip = null;
			_judgeDesc = "";
			_version = "";
			_lastRcvTimeoutTickCnt = 0;
			_lastSendMatchTickCnt = 0;
			_batteryPercent = 0;
		}

		public bool CanBeSendMatchInfo
		{
			get 
			{
				return this.HeartbeatStatus == EmJudgePanelStatus.Normal;
			}
		}

		/// <summary>
		/// Unused, Normal, Timeout
		/// </summary>
		public EmJudgePanelStatus HeartbeatStatus
		{
			get 
			{
				if (_ip == null)
				{
					return EmJudgePanelStatus.Unused;
				}
				else if (System.Environment.TickCount - _lastRcvTimeoutTickCnt > TIMEOUT_HEARTBEAT)
				{
					return EmJudgePanelStatus.Timeout;
				}
				else
				{
					return EmJudgePanelStatus.Normal;
				}
			}
		}

		/// <summary>
		/// Unused, Normal, Waiting, Timeout
		/// </summary>
		public EmJudgePanelStatus WaitResponseStatus
		{
			get
			{
				if (_ip == null )
				{
					return EmJudgePanelStatus.Unused;
				}
				else if (_lastSendMatchTickCnt <= 0)
				{
					return EmJudgePanelStatus.Normal;
				}
				else if (System.Environment.TickCount - _lastSendMatchTickCnt > TIMEOUT_HEARTBEAT)
				{
					return EmJudgePanelStatus.Timeout;
				}
				else
				{
					return EmJudgePanelStatus.Waiting;
				}
			}
		}

		public string Desc
		{
			get 
			{
				return string.Format("IP:{0} Battery:{1} Version:{2}", 
					_ip == null ? "N/A" : _ip.ToString(), 
					_ip == null ? "N/A" : _batteryPercent.ToString() + '%',
					_ip == null ? "N/A" : _version );
			}
		}
	}

	public enum EmJudgePanelStatus
	{
		Unused = 0,		//没有任何客户端信息
		Normal = 1,			//正常
		Waiting = 2,		//等待Response
		Timeout = 3,		//已经发现对方Heartbeat信息接收超时
	}

	public interface JudgePanelMgrCallBack
	{
		/// 当收到裁判打分时
		// <Scores>
		//		<Score JudgeNum="1" PlayerID="44" ScoreNum="2" ScoreValue="5"/>
		//		<Score JudgeNum="1" PlayerID="45" ScoreNum="3" ScoreValue="3.54"/>
		// </Scores>
		bool callbackJudgeScored(int judgeNum, XmlDocument xmlScore);

		/// 需要MatchInfo发送给裁判时,例如被调用SendMatchInfo时,或裁判打分后,需要将打分结果发给裁判时
		/// F_ScoreSerial F_JudgeNum F_PlayerOrder F_ScoreNum F_JudgeName F_ScoreDesc1 F_ScoreDesc2 F_ScoreValue F_ScoreResult F_ScoreStatus
		DataTable callbackNeedMatchInfoForJudge(int judgeNum = -1);

		/// 上层负责将二进制数据发送出去
		bool callbackSendDataToNetwork(byte[] bytes, IPEndPoint ip);

		/// 通知上层某个裁判台状态有变化
		/// 在新设备登录时, 某个设备电量有变化时, 向其发送MatchInfo, 收到MatchInfoResponse时
		bool callbackJudgePanelStatusChange(int judgeNum);

		bool callbackOutputMsg(string msg, EmMsgType type);
	}

	public class JudgePanelMgr
	{
		public const int MAX_JUDGE_INDEX = 99;

		private JudgePanelMgrCallBack _callback;		//回调函数

		private double _lowestJudgePanelVersion;		//最低要求的客户端版本号

		private string _matchInfoSerial;				//最新的MatchInfo的标示, Should be: MatchID-RoundID, 向裁判发送时, -JudgeNum
		private string _matchInfoDesc1;					//在裁判端展示的当前比赛描述, 第一行
		private string _matchInfoDesc2;
		private string _matchInfoDesc3;

		private JudgePanelInfo[] _JudgePanelList;		//存放所有客户端信息

		public void eventRcvUdp(byte[] bytes, IPEndPoint ip)
		{
			if (bytes == null || ip == null)
			{
				Debug.Assert(false);
				return;
			}

			// 1.尝试解析XML, 获取通用属性
			XmlDocument xml;
			XmlElement elmBody;
			String msgType;
			int judgeNum;

			try
			{
				string strXml = Encoding.UTF8.GetString(bytes);
				//_outputMsg("_onRcvUdp RcvXml: " + strXml, EmMsgType.Debug);

				//应该做串连接,分割的处理
				//以后再做

				xml = new XmlDocument();
				xml.InnerXml = strXml;
				elmBody = (XmlElement)xml.SelectSingleNode("/Body");

				msgType = elmBody.GetAttribute("MessageType");
				judgeNum = Str2Int(elmBody.GetAttribute("JudgeID"));

				if (msgType.Length == 0 || judgeNum <= 0 || judgeNum >= MAX_JUDGE_INDEX)
				{
					string errMsg = "MsgType or JudgeNum invalid!";
					_outputMsg(errMsg, EmMsgType.Error);
					return;
				}

				if (judgeNum > _JudgePanelList.Length)
				{
					string errMsg = string.Format("Rcv xml, the judgeNum={0}, we only have {1} judge(s)", judgeNum, _JudgePanelList.Length);
					_outputMsg(errMsg, EmMsgType.Error);
					return;
				}
			}
			catch (Exception e)
			{
				_outputMsg("Rcv xml, but it is invalid!", EmMsgType.Error);
				return;
			}

			// 2.判断不同类型,作不同处理
			if (msgType == "HeartBeat")
			{
				_onRcvXmlHeartbeat(judgeNum, xml, ip);
			}
			else if (msgType == "ScoreList")
			{
				_onRcvXmlJudgeScored(judgeNum, xml);
			}
			else if (msgType == "CompetitorInfoResponse")
			{
				_onRcvXmlMatchInfoResponse(judgeNum);
			}
			else
			{
				Debug.Assert(false);
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="callback"></param>
		/// <param name="judgeDesc">裁判的标题,同时也决定了裁判的个数</param>
		/// <param name="timeout"></param>
		/// <param name="lowestJudgePanelVersion"></param>
		public JudgePanelMgr(JudgePanelMgrCallBack callback, string[] lstJudgeDesc, double lowestJudgePanelVersion = 1.00)
		{
			if (callback == null || !(callback is JudgePanelMgrCallBack) ||
				 lstJudgeDesc == null || lstJudgeDesc.Length < 1 || lstJudgeDesc.Length > MAX_JUDGE_INDEX ||
				 lowestJudgePanelVersion < 1.00)
			{
				throw new Exception("Param error");
			}

			_callback = callback;
			_lowestJudgePanelVersion = lowestJudgePanelVersion;

			_JudgePanelList = new JudgePanelInfo[lstJudgeDesc.Length];
			for (int cycJudge = 0; cycJudge < _JudgePanelList.Length; cycJudge++)
			{
				_JudgePanelList[cycJudge] = new JudgePanelInfo();
				_JudgePanelList[cycJudge]._judgeDesc = lstJudgeDesc[cycJudge];
			}
		}

		/// <summary>
		/// 获取所有裁判台信息
		/// </summary>
		/// <returns></returns>
		public JudgePanelInfo[] judgePanelInfo()
		{
			return _JudgePanelList;
		}

		//由NeedMatchInfo来控制给几个选手同时打分,数据库内容决定给每个选手打几个分,分别是由哪几个裁判来打
		//如果MatchSerial为空,表示不允许裁判打分,将不获取MatchInfo,发送空数据给裁判台
		public bool setMatchInfo(string MatchSerial, string matchDesc1, string matchDesc2, string matchDesc3)
		{
			if (MatchSerial == null || matchDesc1 == null || matchDesc2 == null || matchDesc3 == null)
			{
				Debug.Assert(false);
				return false;
			}

			// 1.记录下最新的比赛信息
			_matchInfoSerial = MatchSerial;
			_matchInfoDesc1 = matchDesc1;
			_matchInfoDesc2 = matchDesc2;
			_matchInfoDesc3 = matchDesc3;

			// 2.从上层获取所有Judge的MatchInfo
			DataTable tblMatchInfo = null;
			if (_matchInfoSerial != "")
			{
				tblMatchInfo = _callback.callbackNeedMatchInfoForJudge();
				if (tblMatchInfo == null)
				{
					_outputMsg("RefreshMatchInfo failed! raison:get matchInfo failed", EmMsgType.Debug);
					return false;
				}
			}
			
			// 3.循环所有裁判,发送MatchInfo
			bool sendResult = true;
			for (int cycJudge = 1; cycJudge <= _JudgePanelList.Length; cycJudge++)
			{
				JudgePanelInfo judgePanel = _JudgePanelList[cycJudge - 1];

				//如果裁判台状态不可以接受
				if (!judgePanel.CanBeSendMatchInfo)
				{
					continue;
				}
				
				//是否发空, MatchInfo中筛选中此Judge的
				DataRow[] rowsCurJudge = null;
				if (_matchInfoSerial != "")
				{
					rowsCurJudge = tblMatchInfo.Select("F_JudgeNum = " + cycJudge.ToString());
				}

				//发送到此Judge
				sendResult &= _sendMatchInfoToJudge(cycJudge, rowsCurJudge);
			}

			return sendResult;
		}

		//手动发送MatchInfo到某个Judge
		public bool reSendMatchInfo(int judgeNum)
		{
			if (judgeNum < 1 || judgeNum > _JudgePanelList.Length)
			{
				Debug.Assert(false);
				return false;
			}

			// 1.此裁判台当前状态,不能接受
			JudgePanelInfo judgePanel = _JudgePanelList[judgeNum - 1];
			if (!judgePanel.CanBeSendMatchInfo)
			{
				return false;
			}
			
			// 2.如果不是空的情况,才去获取比分
			DataRow[] rowsCurJudge = null;
			if (_matchInfoSerial != "")
			{
				// 2.从上层获取所有Judge的MatchInfo
				DataTable tblMatchInfo = _callback.callbackNeedMatchInfoForJudge(judgeNum);
				if (tblMatchInfo == null)
				{
					_outputMsg("reSendMatchInfo failed! raison:get matchInfo failed", EmMsgType.Debug);
					return false;
				}

				//从MatchInfo中筛选中此Judge的
				rowsCurJudge = tblMatchInfo.Select("F_JudgeNum = " + judgeNum.ToString());
			}

			// 3.发送到此Judge
			bool result = _sendMatchInfoToJudge(judgeNum, rowsCurJudge);			
			return result;
		}

        //add by huang
        //手动发送MatchInfo到某个选定的register和选定的Judge
        public bool reSendMatchInfoToSelected(string MatchSerial, string matchDesc1, string matchDesc2, string matchDesc3,int judgeNum)
        {
            // 1.记录下最新的比赛信息
            _matchInfoSerial = MatchSerial;
            _matchInfoDesc1 = matchDesc1;
            _matchInfoDesc2 = matchDesc2;
            _matchInfoDesc3 = matchDesc3;

            if (judgeNum < 1 || judgeNum > _JudgePanelList.Length)
            {
                Debug.Assert(false);
                return false;
            }

            // 1.此裁判台当前状态,不能接受
            JudgePanelInfo judgePanel = _JudgePanelList[judgeNum - 1];
            if (!judgePanel.CanBeSendMatchInfo)
            {
                return false;
            }

            // 2.如果不是空的情况,才去获取比分
            DataRow[] rowsCurJudge = null;
            if (_matchInfoSerial != "")
            {
                // 2.从上层获取所有Judge的MatchInfo
                DataTable tblMatchInfo = _callback.callbackNeedMatchInfoForJudge(judgeNum);
                if (tblMatchInfo == null)
                {
                    _outputMsg("reSendMatchInfo failed! raison:get matchInfo failed", EmMsgType.Debug);
                    return false;
                }

                //从MatchInfo中筛选中此Judge的
                rowsCurJudge = tblMatchInfo.Select("F_JudgeNum = " + judgeNum.ToString());
            }

            // 3.发送到此Judge
            bool result = _sendMatchInfoToJudge(judgeNum, rowsCurJudge);
            return result;
        }

		private bool _sendXmlToJudge(XmlDocument xml, int judgeNum)
		{
			if (xml == null || judgeNum < 1 || judgeNum > _JudgePanelList.Length)
			{
				Debug.Assert(false);
				return false;
			}

			//_outputMsg("Send: " + xml.InnerXml, EmMsgType.Debug);

			// 1.准备好要发送的二进制串和目标IP地址
			byte[] bytes = Encoding.UTF8.GetBytes(xml.InnerXml);
			IPEndPoint ip = _JudgePanelList[judgeNum - 1]._ip;

			// 2.利用上层进行具体发送
			return _callback.callbackSendDataToNetwork(bytes, ip);
		}

		/// <summary>
		/// 发送MatchInfo到目标Panel,并处理超时等信息
		/// </summary>
		/// <param name="judgeNum">default: All judges</param>
		/// <returns></returns>
		private bool _sendMatchInfoToJudge(int judgeNum, DataRow[] matchInfo)
		{
			if (judgeNum < 1 || judgeNum > _JudgePanelList.Length)
			{
				Debug.Assert(false);
				return false;
			}

			// 1.创建出所需的XML
			XmlDocument xml = new XmlDocument();
			{
				XmlDeclaration xmlDec = xml.CreateXmlDeclaration("1.0", "UTF-8", null);
				xml.AppendChild(xmlDec);
				XmlElement xmlBody = xml.CreateElement("Body");
				xml.AppendChild(xmlBody);
				xmlBody.SetAttribute("MessageType", "CompetitorInfo");

				XmlElement xmlElem = xml.CreateElement("CompetitorInfo");
				xmlBody.AppendChild(xmlElem);
				xmlElem.SetAttribute("Event", _matchInfoDesc1);
				xmlElem.SetAttribute("Phase", _matchInfoDesc2);
				xmlElem.SetAttribute("CompetitorName", _matchInfoDesc3);
				xmlElem.SetAttribute("CompetitorID", _matchInfoSerial == "" ? "" : _matchInfoSerial + '-' + judgeNum.ToString() );

			//	_outputMsg("JudgeNum:" +judgeNum.ToString() +' ' + xmlElem.GetAttribute("CompetitorID"), EmMsgType.Debug);
				//xmlElem.SetAttribute("JudgeName", judgeNum.ToString() + "号裁判");
                //xmlElem.SetAttribute("JudgeName", _JudgePanelList[judgeNum-1]._judgeDesc+"点裁判");
                xmlElem.SetAttribute("JudgeName", _JudgePanelList[judgeNum - 1]._judgeDesc);

				if (matchInfo != null)
				{
					foreach (DataRow rowScoreInfo in matchInfo)
					{
						XmlElement xmlPlayer = xml.CreateElement("Score");
						xmlPlayer.SetAttribute("ScoreID", rowScoreInfo["F_ScoreSerial"].ToString());
						xmlPlayer.SetAttribute("ScoreName", rowScoreInfo["F_ScoreDesc1"].ToString());
						xmlPlayer.SetAttribute("ScoreValue", rowScoreInfo["F_ScoreValue"].ToString());
						xmlPlayer.SetAttribute("ScoreErrorMessage", rowScoreInfo["F_ScoreResult"].ToString());
						xmlPlayer.SetAttribute("ScoreStatus", rowScoreInfo["F_ScoreStatus"].ToString());
						xmlElem.AppendChild(xmlPlayer);
					}
				}
			}

			// 2.向指定客户端发送XML
			bool result = _sendXmlToJudge(xml, judgeNum);
			if (!result)
			{
				_outputMsg("_sendXmlToJudge faild!", EmMsgType.Debug);
				return false;
			}

			// 3.设定MatchInfo发送时间
			_JudgePanelList[judgeNum - 1]._lastSendMatchTickCnt = Environment.TickCount;
			
			// 4.通知上层此裁判台状态变化
			_callback.callbackJudgePanelStatusChange(judgeNum);

			return true;
		}

		private bool _sendJudgeScoredResponseToJudge(int judgeNum)
		{
			if (judgeNum < 1 || judgeNum > _JudgePanelList.Length)
			{
				Debug.Assert(false);
				return false;
			}

			//如果不是空分状态,就获取MatchInfo
			DataRow[] rowsCurJudge = null;
			if (_matchInfoSerial != "")
			{
				// 1.获取所需信息
				DataTable tblMatchInfo = _callback.callbackNeedMatchInfoForJudge(judgeNum);
				if (tblMatchInfo == null)
				{
					_outputMsg("_sendJudgeScoredResponseToJudge failed! raison:get matchInfo failed", EmMsgType.Debug);
					return false;
				}

				// 2. 从MatchInfo中筛选中此Judge的			
				rowsCurJudge = tblMatchInfo.Select("F_JudgeNum = " + judgeNum.ToString());
			}

			// 1.创建出所需的XML
			XmlDocument xml = new XmlDocument();
			{
				XmlDeclaration xmlDec = xml.CreateXmlDeclaration("1.0", "UTF-8", null);
				xml.AppendChild(xmlDec);
				XmlElement xmlBody = xml.CreateElement("Body");
				xml.AppendChild(xmlBody);
				xmlBody.SetAttribute("MessageType", "ScoreResponse");

				XmlElement xmlElem = xml.CreateElement("CompetitorInfo");
				xmlBody.AppendChild(xmlElem);
				xmlElem.SetAttribute("CompetitorID", _matchInfoSerial == "" ? "" : _matchInfoSerial + '-' + judgeNum.ToString() );

				foreach (DataRow rowScoreInfo in rowsCurJudge)
				{
					XmlElement xmlPlayer = xml.CreateElement("Score");
					xmlPlayer.SetAttribute("ScoreID", rowScoreInfo["F_ScoreSerial"].ToString());
                    xmlPlayer.SetAttribute("ScoreValue", rowScoreInfo["F_ScoreValue"].ToString());
					xmlPlayer.SetAttribute("ScoreStatus", rowScoreInfo["F_ScoreStatus"].ToString());
					xmlPlayer.SetAttribute("ScoreErrorMessage", rowScoreInfo["F_ScoreResult"].ToString());
					xmlElem.AppendChild(xmlPlayer);
				}
			}

			// 2.向指定客户端发送XML
			bool result = _sendXmlToJudge(xml, judgeNum);
			if (!result)
			{
				_outputMsg("_sendJudgeScoredResponseToJudge faild!", EmMsgType.Debug);
				return false;
			}

			return true;
		}

		private void _onRcvXmlHeartbeat(int judgeNum, XmlDocument xml, IPEndPoint ip)
		{
			// 1.尝试获取XML中属性值
			string strVersion = null;
			int nBattery = 0;
			int nPort = 0;

			try
			{
				XmlElement elmHeartbeat = (XmlElement)xml.SelectSingleNode("/Body/HeartBeat");
				strVersion = elmHeartbeat.GetAttribute("Version");
				nBattery = Str2Int(elmHeartbeat.GetAttribute("Battery"));
				nPort = Str2Int(elmHeartbeat.GetAttribute("RcvPort"));
			}
			catch (Exception e)
			{
				_outputMsg("Rcv Heartbeat, but analyse failed.", EmMsgType.Error);
				return;
			}

			if (nPort <= 0)
			{
				string err = string.Format("Rcv heartbeat but the rcvPort in JudgePanel{0}({1}) is invalid.", judgeNum, ip.Address.ToString());
				_outputMsg(err, EmMsgType.Error);

				return;
			}

			// 3. 此Panel未登录过或登录过已超时,更新此客户端状态,向其发送MatchInfo,并报告其状态改变
			//	  已登录过且未超时,更新其TickCount即可
			JudgePanelInfo judgePanelInfo = _JudgePanelList[judgeNum - 1];
			if (judgePanelInfo._ip != null && judgePanelInfo._ip.Address.ToString() == ip.Address.ToString() && judgePanelInfo._ip.Port == nPort) //IP Port是否一样,判断该Panel是否已经登录过
			{
				if (Environment.TickCount - judgePanelInfo._lastRcvTimeoutTickCnt > JudgePanelInfo.TIMEOUT_HEARTBEAT) //超时恢复
				{
					judgePanelInfo._batteryPercent = nBattery;
					judgePanelInfo._lastRcvTimeoutTickCnt = Environment.TickCount;

					reSendMatchInfo(judgeNum);

					//由于reSendMatchInfo时会自动向上层发送StatusChanged,所以这里不再发送
					//_callback.callbackJudgePanelStatusChange(judgeNum);

					_outputMsg("Judge" + judgeNum.ToString() + " who was timeout coming in!", EmMsgType.Important);
				}
				else //接收Heartbeat正常
				{
					judgePanelInfo._lastRcvTimeoutTickCnt = Environment.TickCount;

					if (judgePanelInfo._batteryPercent != nBattery)
					{
						judgePanelInfo._batteryPercent = nBattery;

						//电池电量有变化,需要向上层发送变化信息
						_callback.callbackJudgePanelStatusChange(judgeNum);
					}
				}
			}
			else // 新客户端 向其发送MatchInfo 并通知上层有变化
			{
				judgePanelInfo._ip = new IPEndPoint(ip.Address, nPort);
				judgePanelInfo._version = strVersion;
				judgePanelInfo._batteryPercent = nBattery;
				judgePanelInfo._lastRcvTimeoutTickCnt = Environment.TickCount;

				reSendMatchInfo(judgeNum);

				//由于reSendMatchInfo时会自动向上层发送StatusChanged,所以这里不再发送
				//_callback.callbackJudgePanelStatusChange(judgeNum);

				_outputMsg("Judge" + judgeNum.ToString() + "[" + judgePanelInfo._ip.ToString() + "]" + " coming in!", EmMsgType.Important);
			}
		}

		private void _onRcvXmlJudgeScored(int judgeNum, XmlDocument xml)
		{
			// 1.获取比赛标示和比分列表
			XmlNodeList xmlScoreList = null;
			string matchInfoSerial = null;

			try
			{
				XmlElement xmlElm = (XmlElement)xml.SelectSingleNode("/Body/ScoreList");
				matchInfoSerial = xmlElm.GetAttribute("CompetitorID");
				xmlScoreList = xml.SelectNodes("/Body/ScoreList/Score");
			}
			catch (Exception e)
			{
				Debug.Assert(false);
				_outputMsg("Rcv xml judge scored, but analyse failed!", EmMsgType.Error);
				return;
			}

			// 3.如果MatchInfoSerial不合法,就不计算比分
			if (matchInfoSerial != _matchInfoSerial + '-' + judgeNum.ToString())
			{
				_outputMsg("Rcv judgeScore from judge[" + judgeNum.ToString() + "], but the match info serial is out of date! pls send matchinfo to it!", EmMsgType.Error);
				return;
			}
			
			// 取出所有比分 并填入一个新格式的XML
			XmlDocument xmlForDB = new XmlDocument();
			XmlElement xmlBody = xmlForDB.CreateElement("Scores");
			xmlForDB.AppendChild(xmlBody);

			foreach (XmlNode xmlScoreNode in xmlScoreList)
			{
				string strScoreID = ((XmlElement)xmlScoreNode).GetAttribute("ScoreID");
				string strScoreValue = ((XmlElement)xmlScoreNode).GetAttribute("ScoreValue");

				XmlElement xmlScore = xmlForDB.CreateElement("Score");
				xmlBody.AppendChild(xmlScore);

				xmlScore.SetAttribute("ScoreID", strScoreID);
				xmlScore.SetAttribute("ScoreValue", strScoreValue);
			}

			//交给上层计算
			if (!_callback.callbackJudgeScored(judgeNum, xmlForDB))
			{
				_outputMsg("Rcv score, but process it faild!", EmMsgType.Error);
			}
			

			// 4.刷新其Heartbeat
			_JudgePanelList[judgeNum - 1]._lastRcvTimeoutTickCnt = Environment.TickCount;

			// 5.向其发送Response
			_sendJudgeScoredResponseToJudge(judgeNum);
		}

		private void _onRcvXmlMatchInfoResponse(int judgeNum)
		{
			JudgePanelInfo judgePanel = _JudgePanelList[judgeNum - 1];
			judgePanel._lastSendMatchTickCnt = 0;

			_callback.callbackJudgePanelStatusChange(judgeNum);
		}

		private bool _outputMsg(string msg, EmMsgType type = EmMsgType.Normal)
		{
			return _callback.callbackOutputMsg(msg, type);
		}



		public static string GetErrMsg(int nErrCode)
		{
			string strErrMsg;

			switch (nErrCode)
			{
				case 1: strErrMsg = "成功!"; break;
				case -1: strErrMsg = "XML解析失败!"; break;
				case -2: strErrMsg = "该客户端未登陆!"; break;



				case -1001: strErrMsg = "Login协议中客户端接收端口号不合法!"; break;
				case -1002: strErrMsg = "Login协议中裁判号超出有效范围!"; break;
				case -1003: strErrMsg = "Login协议中版本号已过期!"; break;
				case -1004: strErrMsg = "Login协议中客户端接收端口号不合法!"; break;
				case -1005: strErrMsg = "Login协议中客户端接收端口号不合法!"; break;
				case -1006: strErrMsg = "Login协议中客户端接收端口号不合法!"; break;
				case -1007: strErrMsg = "Login协议中客户端接收端口号不合法!"; break;

				case -2001: strErrMsg = "比分必须为数字!"; break;
				case -2002: strErrMsg = "比分非法!"; break;
				case -2003: strErrMsg = "一个或多个比分处理失败!"; break;



				case -9001: strErrMsg = "被强制Logout,因为其他客户端登陆!"; break;

				case -9996: strErrMsg = "存储过程检测失败!"; break;
				case -9997: strErrMsg = "参数错误!"; break;
				case -9998: strErrMsg = "存储过程执行失败!"; break;
				case -9999: strErrMsg = "程序内部错误!"; break;


				default: strErrMsg = "未知编号!"; break;
			}

			return strErrMsg;
		}

		public static Int32 Str2Int(Object strObj)
		{
			if (strObj == null) return 0;

			try
			{
				return Convert.ToInt32(strObj);
			}
			catch (Exception)
			{

			}
			return 0;
		}
	}
}