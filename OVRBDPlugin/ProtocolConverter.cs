using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Xml;
using Badminton2011;

namespace AutoSports.OVRBDPlugin
{
    public class ProtocolConverter
    {
        //结构转换成字节数组
        public static byte[] StructToBytes(object obj)
        {
            //得到结构体的大小
            int size = Marshal.SizeOf(obj);
            //创建byte数组
            byte[] bytes = new byte[size];
            //分配结构体大小的内存空间
            IntPtr structPtr = Marshal.AllocHGlobal(size);
            //将结构体拷到分配好的内存空间
            Marshal.StructureToPtr(obj, structPtr, false);
            //从内存空间拷到byte数组
            Marshal.Copy(structPtr, bytes, 0, size);
            //释放内存空间
            Marshal.FreeHGlobal(structPtr);
            //返回byte数组
            return bytes;

        }

        //字节数组转换成结构
        public static object BytesToStruct(byte[] bytes, Type type)
        {
            //得到结构的大小
            int size = Marshal.SizeOf(type);
            //byte数组长度小于结构的大小
            if (size > bytes.Length)
            {
                //返回空
                return null;
            }
            //分配结构大小的内存空间
            IntPtr structPtr = Marshal.AllocHGlobal(size);
            //将byte数组拷到分配好的内存空间
            Marshal.Copy(bytes, 0, structPtr, size);
            //将内存空间转换为目标结构
            object obj = Marshal.PtrToStructure(structPtr, type);
            //释放内存空间
            Marshal.FreeHGlobal(structPtr);
            //返回结构
            return obj;
        }

        public static object CreateStruct(Type type)
        {
            int size = Marshal.SizeOf(type);
            byte[] temp = new byte[size];
            return BytesToStruct(temp, type);
        }

        public static string ConvertToActionXml(SGameByteInfo gameInfo)
        {
            GameByteInfoParser parser = new GameByteInfoParser(gameInfo);
            int matchID = parser.MatchID % 100000;
            string matchCode = TSDataExchangeTT_Service.GetMatchCodeFromID(matchID);
            if (matchCode == null || matchCode == "")
            {
                return "";
            }
            MemoryStream stream = new MemoryStream();
            XmlTextWriter writter = new XmlTextWriter(stream, System.Text.Encoding.Default);
            writter.Formatting = Formatting.Indented;
            //第一级MatchInfo
            writter.WriteStartDocument();
            writter.WriteStartElement("MatchInfo");
            writter.WriteAttributeString("MatchCode", matchCode);
            writter.WriteAttributeString("CurSubMatch_No", parser.CurSubMatchNo.ToString());
            writter.WriteAttributeString("CurGame_No", parser.CurGameNo.ToString());
            //第二级Score
            writter.WriteStartElement("Score");
            writter.WriteAttributeString("SubMatch_No", parser.CurSubMatchNo.ToString());
            writter.WriteAttributeString("Game_No", parser.CurGameNo.ToString());
            writter.WriteAttributeString("Order", "1");
            writter.WriteAttributeString("Time", "20110810161846");
            writter.WriteAttributeString("Score", "1");
            writter.WriteAttributeString("GameScoreA", parser.CurGameScoreA.ToString());
            writter.WriteAttributeString("GameScoreB", parser.CurGameScoreB.ToString());
            writter.WriteAttributeString("MatchScoreA", parser.CurSetScoreA.ToString());
            writter.WriteAttributeString("MatchScoreB", parser.CurSetScoreB.ToString());
            writter.WriteAttributeString("DuelScoreA", parser.TotalScoreA.ToString());
            writter.WriteAttributeString("DuelScoreB", parser.TotalScoreB.ToString());
            writter.WriteAttributeString("Server", parser.ServerSide);
            //writter.WriteAttributeString("RecvSrv", parser.RecvSrv);
            writter.WriteEndElement();//第二级结束
            writter.WriteEndElement();//第一级结束

            writter.Flush();
            writter.Close();
            byte[] data = stream.ToArray();
            stream.Close();
            string strXml = System.Text.Encoding.Default.GetString(data);
            if (parser.MatchID >= 9000000 )
            {
                return "[TEMP]|" + parser.MatchID.ToString() + "|" + strXml;
            }
            return strXml;
        }

        public static string ConvertToMatchInfoXml(SGameByteInfo gameInfo)
        {
            GameByteInfoParser parser = new GameByteInfoParser(gameInfo);
            int matchID = parser.MatchID % 100000;
            string matchCode = TSDataExchangeTT_Service.GetMatchCodeFromID(matchID);
            if (matchCode == null || matchCode == "")
            {
                return "";
            }
            MemoryStream stream = new MemoryStream();
            XmlTextWriter writter = new XmlTextWriter(stream, System.Text.Encoding.Default);
            writter.Formatting = Formatting.Indented;
            //顶层描述
            writter.WriteStartDocument();
            //第一级MatchInfo开始
            writter.WriteStartElement("MatchInfo");
            writter.WriteAttributeString("MatchCode", matchCode);
            //第二级Duel开始
            writter.WriteStartElement("Duel");
            //第二级属性
            writter.WriteAttributeString("DuelState", parser.DuelState);
            writter.WriteAttributeString("DuelScoreA", parser.TotalScoreA.ToString());
            writter.WriteAttributeString("DuelScoreB", parser.TotalScoreB.ToString());
            writter.WriteAttributeString("DuelTime", parser.GetDuelTime());
            writter.WriteAttributeString("DuelWLA", parser.DuelWLA.ToString());
            writter.WriteAttributeString("DuelWLB", parser.DuelWLB.ToString());
            writter.WriteAttributeString("DuelStatusA", parser.DuelJugeA);
            writter.WriteAttributeString("DuelStatusB", parser.DuelJugeB);

            //第三级SubMatch
            for (int iMatchNo = 1; iMatchNo <= parser.CurSubMatchNo; iMatchNo++)
            {
                //第三级开始
                writter.WriteStartElement("SubMatch");
                //第三级属性
                writter.WriteAttributeString("Match_No", iMatchNo.ToString());
                writter.WriteAttributeString("MatchScoreA", parser.GetSetScoreA(iMatchNo).ToString());
                writter.WriteAttributeString("MatchScoreB", parser.GetSetScoreB(iMatchNo).ToString());
                writter.WriteAttributeString("MatchTime", parser.GetSetTime(iMatchNo).ToString());
                writter.WriteAttributeString("MatchWLA", parser.GetSetWLA(iMatchNo).ToString());
                writter.WriteAttributeString("MatchWLB", parser.GetSetWLB(iMatchNo).ToString());
                writter.WriteAttributeString("MatchStatusA", parser.GetSetJudgeA(iMatchNo));
                writter.WriteAttributeString("MatchStatusB", parser.GetSetJudgeB(iMatchNo));
                writter.WriteAttributeString("MatchState", parser.GetSetState(iMatchNo).ToString());

                //第四级Game
                for (int iGameNo = 1; iGameNo <= parser.GetSetMaxGameCount(iMatchNo); iGameNo++)
                {
                    //第四级开始
                    writter.WriteStartElement("Game");
                    //第四级属性
                    writter.WriteAttributeString("Game_No", iGameNo.ToString());
                    writter.WriteAttributeString("GameScoreA", parser.GetGameScoreA(iMatchNo, iGameNo).ToString());
                    writter.WriteAttributeString("GameScoreB", parser.GetGameScoreB(iMatchNo, iGameNo).ToString());
                    writter.WriteAttributeString("GameTime", parser.GetGameTime(iMatchNo, iGameNo));
                    writter.WriteAttributeString("GameWLA", parser.GetGameWLA(iMatchNo, iGameNo).ToString());
                    writter.WriteAttributeString("GameWLB", parser.GetGameWLB(iMatchNo, iGameNo).ToString());
                    writter.WriteAttributeString("GameStatusA", parser.GetGameJudgeA(iMatchNo, iGameNo));
                    writter.WriteAttributeString("GameStatusB", parser.GetGameJudgeB(iMatchNo, iGameNo));
                    writter.WriteAttributeString("GameState", parser.GetGameState(iMatchNo, iGameNo).ToString());
                    writter.WriteEndElement();
                    //第四级结束
                }
                writter.WriteEndElement();
                //第三级结束
            }
            writter.WriteEndElement();
            //第二级结束
            writter.WriteEndElement();
            //第一级结束

            writter.Flush();
            writter.Close();
            byte[] data = stream.ToArray();
            stream.Close();

            string strXml = System.Text.Encoding.Default.GetString(data);
            if (parser.MatchID >= 9000000)
            {
                return "[TEMP]|" + parser.MatchID.ToString() + "|" + strXml;
            }
            return strXml;
        }
    }

    public class GameByteInfoParser
    {
        private SGameByteInfo gameInfo_;
        public GameByteInfoParser(SGameByteInfo gameInfo)
        {
            gameInfo_ = gameInfo;
        }
        public int MatchID
        {
            get { return gameInfo_.m_nMatchID; }
        }
        public int CurSubMatchNo
        {
            get { return (int)(gameInfo_.m_byCurSet + 1); }
        }
        public int CurGameNo
        {
            get { return (int)(gameInfo_.m_byCurGame[CurSubMatchNo-1] + 1); }
        }
        public int GetGameScoreA(int setNo, int gameNo)
        {
            return gameInfo_.m_byScoreGameA[(setNo - 1) * 7 + (gameNo - 1)];
        }

        public int GetGameScoreB(int setNo, int gameNo)
        {
            return gameInfo_.m_byScoreGameB[(setNo - 1) * 7 + (gameNo - 1)];
        }

        public int GetSetScoreA(int setNo)
        {
            return gameInfo_.m_byScoreSetA[setNo - 1];
        }

        public int GetSetScoreB(int setNo)
        {
            return gameInfo_.m_byScoreSetB[setNo - 1];
        }

        public int TotalScoreA { get { return gameInfo_.m_byScoreMatchA; } }
        public int TotalScoreB { get { return gameInfo_.m_byScoreMatchB; } }

        public string ServerSide
        {
            get
            {
                if (gameInfo_.m_byServe == 0)
                {
                    return "00";
                }
                else if (gameInfo_.m_byServe == 1)
                {
                    return "A1";
                }
                else if (gameInfo_.m_byServe == 2)
                {
                    return "A2";
                }
                else if (gameInfo_.m_byServe == 3)
                {
                    return "B1";
                }
                else if (gameInfo_.m_byServe == 4)
                {
                    return "B2";
                }
                else
                {
                    return "00";
                }
            }
        }

        public string RecvSrv
        {
            get
            {
                if (gameInfo_.m_byRecv == 0)
                {
                    return "00";
                }
                else if (gameInfo_.m_byRecv == 1)
                {
                    return "A1";
                }
                else if (gameInfo_.m_byRecv == 2)
                {
                    return "A2";
                }
                else if (gameInfo_.m_byRecv == 3)
                {
                    return "B1";
                }
                else if (gameInfo_.m_byRecv == 4)
                {
                    return "B2";
                }
                else
                {
                    return "00";
                }
            }
        }

        public string DuelState
        {
            get
            {
                if (gameInfo_.m_byMatchStatus == 40)
                {
                    return "2";
                }
                else if (gameInfo_.m_byMatchStatus == 50)
                {
                    return "4";
                }
                else
                {
                    return "5";
                }
            }
        }

        public int GetSetState(int setNo)
        {
            if (setNo < CurSubMatchNo)
            {
                return 5;
            }
            else if (setNo > CurSubMatchNo)
            {
                return 2;
            }
            else
            {
                if (GetSetWLA(setNo) != 0)
                {
                    return 5;
                }
                else
                {
                    return 4;
                }
            }
        }

        private string ConvertMatchState(int matchIRM)
        {
            string strIRM = "";
            switch (matchIRM)
            {
                case 1:
                    strIRM = "RET";
                    break;
                case 2:
                    strIRM = "DSQ";
                    break;
                case 3:
                    strIRM = "WD";
                    break;
                case 4:
                    strIRM = "WO";
                    break;
                default:
                    strIRM = "";
                    break;
            }
            return strIRM;
        }

        public int GetGameState(int setNo, int gameNo)
        {
            if (setNo < CurSubMatchNo)
            {
                return 5;
            }
            else if (setNo > CurSubMatchNo)
            {
                return 2;
            }
            else
            {
                if (gameNo < GetSetMaxGameCount(setNo))
                {
                    return 5;
                }
                else if (gameNo > GetSetMaxGameCount(setNo))
                {
                    return 2;
                }
                else
                {
                    if (GetGameWLA(setNo, gameNo) != 0)
                    {
                        return 5;
                    }
                    else
                    {
                        return 4;
                    }
                }
            }
        }

        public string DuelJugeA
        {
            get { return ConvertMatchState(gameInfo_.m_byIrmMatchA); }
        }

        public string DuelJugeB
        {
            get { return ConvertMatchState(gameInfo_.m_byIrmMatchB); }
        }

        public string GetSetJudgeA(int setNo)
        {
            return ConvertMatchState((gameInfo_.m_byIrmSetA)[setNo - 1]);
        }

        public string GetSetJudgeB(int setNo)
        {
            return ConvertMatchState(gameInfo_.m_byIrmSetB[setNo - 1]);
        }

        public string GetGameJudgeA(int setNo, int gameNo)
        {
            return ConvertMatchState(gameInfo_.m_byIrmGameA[(setNo - 1) * 7 + (gameNo - 1)]);
        }

        public string GetGameJudgeB(int setNo, int gameNo)
        {
            return ConvertMatchState(gameInfo_.m_byIrmGameB[(setNo - 1) * 7 + (gameNo - 1)]);
        }

        public string GetTimeStringFromSeconds(uint seconds, string timeType)
        {
            string hour = ((int)(seconds / 3600)).ToString();
            hour = hour.PadLeft(2, '0');
            string min = ((int)((seconds % 3600) / 60)).ToString();
            min = min.PadLeft(2, '0');
            string sec = ((int)seconds % 60).ToString();
            sec = sec.PadLeft(2, '0');
            if (timeType == "HHMMSS")
            {
                return hour + min + sec;
            }
            else if (timeType == "MMSS")
            {
                return min + sec;
            }
            return "";
        }

        public string GetGameTime(int setNo, int gameNo)
        {
            uint gameTime = gameInfo_.m_dwTime[(setNo - 1) * 7 + (gameNo - 1)];
            return GetTimeStringFromSeconds(gameTime, "MMSS");
        }
        public string GetSetTime(int setNo)
        {
            uint setTime = 0;
            for (int i = (setNo - 1) * 7; i < setNo * 7; i++)
            {
                setTime += gameInfo_.m_dwTime[i];
            }
            return GetTimeStringFromSeconds(setTime, "HHMMSS");
        }

        public string GetDuelTime()
        {
            uint duelTime = 0;
            for (int i = 0; i < 5 * 7; i++)
            {
                duelTime += gameInfo_.m_dwTime[i];
            }
            return GetTimeStringFromSeconds(duelTime, "HHMMSS");
        }

        public int GetGameWLA(int setNo, int gameNo)
        {
            return gameInfo_.m_byWinResultGame[(setNo - 1) * 7 + (gameNo - 1)];
        }

        public int GetGameWLB(int setNo, int gameNo)
        {
            int res = gameInfo_.m_byWinResultGame[(setNo - 1) * 7 + (gameNo - 1)];
            if (res == 0)
            {
                return res;
            }
            if (res == 1)
            {
                return 2;
            }
            else
            {
                return 1;
            }
        }
        public int GetSetWLA(int setNo)
        {
            return gameInfo_.m_byWinResultSet[setNo - 1];
        }
        public int GetSetWLB(int setNo)
        {
            int res = gameInfo_.m_byWinResultSet[setNo - 1];
            if (res == 0)
            {
                return res;
            }
            if (res == 1)
            {
                return 2;
            }
            else
            {
                return 1;
            }
        }
        public int DuelWLA
        {
            get 
            {
                if ( DuelState != "5")
                {
                    return 0;
                }
                return gameInfo_.m_byWinResultMatch; 
            }
        }

        public int DuelWLB
        {
            get
            {
                if (DuelState != "5")
                {
                    return 0;
                }
                if (gameInfo_.m_byWinResultMatch == 0)
                {
                    return 0;
                }
                else if (gameInfo_.m_byWinResultMatch == 1)
                {
                    return 2;
                }
                else
                {
                    return 1;
                }
            }
        }

        public int CurSetScoreA
        {
            get { return gameInfo_.m_byScoreSetA[CurSubMatchNo - 1]; }
        }

        public int CurSetScoreB
        {
            get { return gameInfo_.m_byScoreSetB[CurSubMatchNo - 1]; }
        }

        public int CurGameScoreA
        {
            get { return GetGameScoreA(CurSubMatchNo, CurGameNo); }
        }
        public int CurGameScoreB
        {
            get { return GetGameScoreB(CurSubMatchNo, CurGameNo); }
        }

        public int GetSetMaxGameCount(int setNo)
        {
            return gameInfo_.m_byCurGame[setNo - 1] + 1;
        }
        public string ErrorInfo = "";
        public bool IsValid()
        {
            if (CurSubMatchNo < 1 || CurSubMatchNo > 5)
            {
                ErrorInfo = "SetNo不在1-5范围之内！";
                return false;
            }
            if (CurGameNo < 1 || CurGameNo > 3)
            {
                ErrorInfo = "GameNo不在1-3范围之内！";
                return false;
            }
            if (MatchID <= 0)
            {
                ErrorInfo = "MatchID小于等于0！";
                return false;
            }
            for (int i = 0; i < CurSubMatchNo; i++)
            {
                if (gameInfo_.m_byCurGame[i] < 0 || gameInfo_.m_byCurGame[i] > 2)
                {
                    ErrorInfo = string.Format("第{0}盘当前局的范围不在1-3范围之内", i + 1);
                    return false;
                }
            }
            if (gameInfo_.m_byServe < 0 || gameInfo_.m_byServe > 4)
            {
                ErrorInfo = string.Format("球权值不在0-4范围内！");
                return false;
            }

            return true;
        }

        public bool IsCurrentGameFinished()
        {
            int state = GetGameState(CurSubMatchNo, CurGameNo);
            if (state == 5)
            {
                return true;
            }
            else
            {
                state = GetSetState(CurSubMatchNo);
                if (state == 5)
                {
                    return true;
                }
                else
                {
                    state = Convert.ToInt32(DuelState);
                    if (state == 5)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }
        public bool IsMatchStarted()
        {
            if (CurGameScoreA == 0 && CurGameScoreB == 0)
            {
                return true;
            }
            return false;
        }
    }
}
