using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Windows.Forms;
using System.Windows;
using System.Windows.Media;
using System.Runtime.InteropServices;
using OVRDVPlugin.Model;
using OVRDVPlugin.View;

namespace OVRDVPlugin
{
    class DatabaseOperation
    {
        public static bool CheckDBConnection()
        {
            try
            {
                if (DVCommon.g_DataBaseCon.State != ConnectionState.Open)
                {
                    DVCommon.g_DataBaseCon.Open();
                }
                return true;
            }
            catch (Exception error)
            {
                AthleticsCommon.LastErrorMsg = error.Message;
                return false;
            }
        }

        private static object GetNoNullValue(SqlDataReader sr, string fieldName, SqlDbType type, object defaultValue)
        {
            if (sr[fieldName] == DBNull.Value)
            {
                return defaultValue;
            }
            switch (type)
            {
                case SqlDbType.Int:
                    return (int)sr[fieldName];
                case SqlDbType.NVarChar:
                    return (string)sr[fieldName];
                case SqlDbType.Decimal:
                    return (double)sr[fieldName];
            }
            return "";
        }

        private static object GetNoNullValue(SqlDataReader sr, string fieldName, object defaultValue)
        {
            if (sr[fieldName] == DBNull.Value)
            {
                return defaultValue;
            }
            return sr[fieldName];
        }

        public static int CreateMatch(int iMatchID, bool bDelOldMatch)
        {
            if (!CheckDBConnection())
            {
                return -1;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_CreateMatchSplits";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = iMatchID;
                sqlCmd.Parameters.Add("@CreateType", SqlDbType.Int).Value = bDelOldMatch ? 1 : 0;
                SqlParameter sqlParam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                sqlParam.Direction = ParameterDirection.Output;
                sqlCmd.ExecuteNonQuery();
                int res = (int)sqlParam.Value;
                if (res == 1)
                {
                    return 1;
                }
                else if (res == -1)
                {
                    AthleticsCommon.LastErrorMsg = "CreateMatch():Create match split failed!";
                    return 0;
                }
                return 0;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = ex.Message;
                return -1;
            }
        }

        public static List<MatchRound> GetRoundList(int iMatchID)
        {
            if (!CheckDBConnection())
            {
                return null;
            }
            SqlDataReader sr = null;
            List<MatchRound> rounds = new List<MatchRound>();
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_1_GetMatchRounds";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = iMatchID;
                sr = sqlCmd.ExecuteReader();

                while (sr.Read())
                {
                    MatchRound round = new MatchRound();
                    round.RoundID = (int)sr["F_MatchSplitID"];
                    round.RoundOrder = Convert.ToInt32(sr["SplitOrder"]);
                    rounds.Add(round);
                }
                return rounds;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "GetRoundList():" + ex.Message;
                return null;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }

        public static List<JudgeGroup> GetJudgeGroupList(int iMatchID, int roundID)
        {
            if (!CheckDBConnection())
            {
                return null;
            }
            SqlDataReader sr = null;
            List<JudgeGroup> groupList = new List<JudgeGroup>();
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_2_GetJudgeGroups";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = iMatchID;
                sqlCmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = roundID;
                sr = sqlCmd.ExecuteReader();

                while (sr.Read())
                {
                    JudgeGroup group = new JudgeGroup();
                    group.JudgeGroupID = (int)sr["F_MatchSplitID"];
                    group.JudgeGroupCode = (string)sr["JudgeGroupCode"];
                    group.JudgeGroupFormat = (string)sr["JudgeGroupPointsFormate"];
                    group.HasMultiPoints = (int)sr["JudgeOrPointTypePrior"] == (int)MatchGroupType.Detail;
                    group.JudgeGroupRqFormat = (string)GetNoNullValue(sr, "RqPenFormate", null);
                    //group.JudgeGroupRqFormat = "-SS.###";
                    groupList.Add(group);
                }
                return groupList;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "GetJudgeGroupList():" + ex.Message;
                return null;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }

        public static List<JudgeGroupPoint> GetJudgeGroupPointsList(int iMatchID, int groupID)
        {
            if (!CheckDBConnection())
            {
                return null;
            }
            SqlDataReader sr = null;
            List<JudgeGroupPoint> pointList = new List<JudgeGroupPoint>();
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_32_GetJudgePointTypes";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = iMatchID;
                sqlCmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = groupID;
                sr = sqlCmd.ExecuteReader();

                while (sr.Read())
                {
                    JudgeGroupPoint point = new JudgeGroupPoint();
                    point.PointType = (string)sr["PointCode"];
                    point.PointFormat = (string)sr["PointTypePointsFormate"];
                    point.GroupShowFactor = Convert.ToDouble(GetNoNullValue(sr, "ShowFactor", 1.0));
                    pointList.Add(point);
                }
                return pointList;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "GetJudgeGroupPointsList():" + ex.Message;
                return null;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }

        public static List<Judge> GetGroupJudges(int iMatchID, int groupID)
        {
            if (!CheckDBConnection())
            {
                return null;
            }
            SqlDataReader sr = null;
            List<Judge> judgeList = new List<Judge>();
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_3_GetJudges";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = iMatchID;
                sqlCmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = groupID;
                sr = sqlCmd.ExecuteReader();

                while (sr.Read())
                {
                    Judge judge = new Judge();
                    judge.JudgeCode = (string)sr["JudgeCode"];
                    judge.DataFormat = (string)sr["JudgePointsFormate"];
                    judge.Order = Convert.ToInt32(sr["JudgeOrder"]);
                    judgeList.Add(judge);
                }
                return judgeList;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "GetGroupJudges():" + ex.Message;
                return null;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }

        public static List<JudgePointCell> GetJudgeGroupPointCellList(int iMatchID, int roundID, int registerID,
                string judgeGroupCode, string pointTypeCode, bool hasMultiPoints, Dictionary<string, List<Judge>> judgeListDict)
        {
            if (!CheckDBConnection())
            {
                return null;
            }
            SqlDataReader sr = null;
            object pointType = string.IsNullOrEmpty(pointTypeCode) ? (object)DBNull.Value : (object)pointTypeCode;
            List<JudgePointCell> cellList = new List<JudgePointCell>();
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_GetScoreDetail";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = iMatchID;
                sqlCmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = roundID;
                sqlCmd.Parameters.Add("@RegisterID", SqlDbType.Int).Value = registerID;
                sqlCmd.Parameters.Add("@JudgeGroupCode", SqlDbType.NVarChar, 10).Value = judgeGroupCode;
                sqlCmd.Parameters.Add("@PointTypeCode", SqlDbType.NVarChar, 10).Value = pointType;
                sr = sqlCmd.ExecuteReader();

                while (sr.Read())
                {
                    JudgePointCell cell = new JudgePointCell();
                    cell.BReadOnly = hasMultiPoints;

                    if (sr["F_JudgeCode"] != DBNull.Value)//自由自选
                    {
                        int judgeOrder = (int)sr["F_JudgeOrder"] - 1;
                        cell.JudgeCode = (string)sr["F_JudgeCode"];
                        List<Judge> judgeList = null;

                        if (judgeListDict.TryGetValue(judgeGroupCode, out judgeList))
                        {
                            cell.DataFormat = (judgeList[judgeOrder]).DataFormat;
                        }
                        cell.JudgeOrder = (int)sr["F_JudgeOrder"];
                        cell.Points = Convert.ToDouble(GetNoNullValue(sr, "F_Points", -1.0));
                        cell.TotalPoints = Convert.ToDouble(GetNoNullValue(sr, "F_TotalPoints", -1.0));

                    }
                    else
                    {
                        //组的分数
                        cell.DataFormat = "S.#";
                        cell.JudgeOrder = -1;
                        cell.JudgeCode = "";
                        cell.Points = -1.0;
                        cell.TotalPoints = Convert.ToDouble(GetNoNullValue(sr, "F_Points", -1.0));
                    }


                    cell.RqPoints = Convert.ToDouble(GetNoNullValue(sr, "F_RqPenPoints", 1.0));
                    cell.ScoreStatusID = (int)GetNoNullValue(sr, "F_PointsStatusID", 0);

                    cellList.Add(cell);
                }
                return cellList;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "GetJudgeGroupPointCellList():" + ex.Message;
                return null;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }

        public static int UpdateScore(int iMatchID, int roundID, int registerID,
                string judgeGroupCode, string pointCode, string pointTypeCode, string judgeCode, double point, int pointStatus,
               bool isAutoCalculate)
        {
            if (!CheckDBConnection())
            {
                return -1;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_UpdatePlayerPoint";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = iMatchID;
                sqlCmd.Parameters.Add("@MatchSplitID", SqlDbType.Int).Value = roundID;
                sqlCmd.Parameters.Add("@RegisterID", SqlDbType.Int).Value = registerID;
                sqlCmd.Parameters.Add("@JudgeGroupCode", SqlDbType.NVarChar, 10).Value = judgeGroupCode;
                sqlCmd.Parameters.Add("@JudgeCode", SqlDbType.NVarChar, 10).Value = judgeCode;
                sqlCmd.Parameters.Add("@PointCode", SqlDbType.NVarChar, 10).Value = pointCode;
                sqlCmd.Parameters.Add("@PointTypeCode", SqlDbType.NVarChar, 10).Value = pointTypeCode;
                sqlCmd.Parameters.Add("@Point", SqlDbType.Decimal).Value = point;
                sqlCmd.Parameters.Add("@PointsStatusID", SqlDbType.Int).Value = pointStatus;
                sqlCmd.Parameters.Add("@IsAutoCalcuate", SqlDbType.Int).Value = isAutoCalculate ? 1 : 0;
                SqlParameter sqlParam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                sqlParam.Direction = ParameterDirection.Output;
                sqlCmd.ExecuteNonQuery();

                return (int)sqlParam.Value;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "UpdateScore():" + ex.Message;
                return -1;
            }
        }

        public static bool SetPlayerRank(int iMatchID, int registerID, string rank, bool automatic)
        {
            if (!CheckDBConnection())
            {
                return true;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_SY_SetPlayerMatchRank";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = iMatchID;
                sqlCmd.Parameters.Add("@RegisterID", SqlDbType.Int).Value = registerID;
                sqlCmd.Parameters.Add("@Rank", SqlDbType.Int).Value = ConvertToDBNull(rank);
                sqlCmd.Parameters.Add("@Automatic", SqlDbType.Int).Value = automatic ? 1 : 0;
                sqlCmd.ExecuteNonQuery();

                return true;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "SetPlayerRank():" + ex.Message;
                return false;
            }
        }


        public static bool SetPlayerIRM(int iMatchID, int roundID, int registerID, string irmCode, bool automatic)
        {
            if (!CheckDBConnection())
            {
                return true;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_SY_SetPlayerIRM";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = iMatchID;
                sqlCmd.Parameters.Add("@RoundID", SqlDbType.Int).Value = roundID;
                sqlCmd.Parameters.Add("@RegisterID", SqlDbType.Int).Value = registerID;
                sqlCmd.Parameters.Add("@IRMCode", SqlDbType.NVarChar, 10).Value = irmCode;
                sqlCmd.Parameters.Add("@Automatic", SqlDbType.Int).Value = automatic ? 1 : 0;
                SqlParameter sqlParam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                sqlParam.Direction = ParameterDirection.Output;

                sqlCmd.ExecuteNonQuery();

                int res = (int)sqlParam.Value;
                if (res == 0)
                {
                    AthleticsCommon.LastErrorMsg = "The irm code is not exists in database.";
                    return false;
                }


                return true;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "SetPlayerIRM():" + ex.Message;
                return false;
            }
        }

        public static bool SetPlayerCurrentStatus(int iMatchID, int roundID, int registerID, bool isCurrent, bool automatic)
        {
            if (!CheckDBConnection())
            {
                return true;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_SY_SetCurrentPlayer";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = iMatchID;
                sqlCmd.Parameters.Add("@RoundID", SqlDbType.Int).Value = roundID;
                sqlCmd.Parameters.Add("@RegisterID", SqlDbType.Int).Value = registerID;
                sqlCmd.Parameters.Add("@Current", SqlDbType.Int).Value = isCurrent ? 1 : 0;
                sqlCmd.Parameters.Add("@Automatic", SqlDbType.Int).Value = automatic ? 1 : 0;
                sqlCmd.ExecuteNonQuery();

                return true;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "SetPlayerCurrentStatus():" + ex.Message;
                return false;
            }
        }

        public static string SY_ImportFromTS(int matchID, string importType, string strToImport)
        {
            if (!CheckDBConnection())
            {
                return null;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "[Proc_SY_TS_ImportResult]";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@ImportType", SqlDbType.NVarChar, 10).Value = importType;
                sqlCmd.Parameters.Add("@ImportString", SqlDbType.NVarChar, 3000).Value = strToImport;
                SqlParameter sqlParam = sqlCmd.Parameters.Add("@Result", SqlDbType.NVarChar, 100);
                sqlParam.Direction = ParameterDirection.Output;

                sqlCmd.ExecuteNonQuery();

                return (string)sqlParam.Value;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "SY_ImportFromTS():" + ex.Message;
                return null;
            }
        }

        private static object ConvertToDBNull(object obj)
        {
            if (obj == null)
            {
                return DBNull.Value;
            }
            else if (obj is string)
            {
                if ((string)obj == "")
                {
                    return DBNull.Value;
                }
            }
            return obj;
        }

        public static ObservableCollection<JudgeInfo> GetAvailableOfficial(int matchID)
        {
            if (!CheckDBConnection())
            {
                return null;
            }
            SqlDataReader sr = null;
            ObservableCollection<JudgeInfo> judgeInfos = new ObservableCollection<JudgeInfo>();
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_GetAvailableOfficial";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 10).Value = "ENG";
                sr = sqlCmd.ExecuteReader();

                while (sr.Read())
                {
                    JudgeInfo judge = new JudgeInfo();
                    judge.Function = (string)GetNoNullValue(sr, "Function", "");
                    judge.Name = (string)GetNoNullValue(sr, "LongName", "");
                    judge.NOC = (string)GetNoNullValue(sr, "NOC", "");
                    judge.FunctionID = (int)GetNoNullValue(sr, "F_FunctionID", -1);
                    judge.RegisterID = (int)GetNoNullValue(sr, "F_RegisterID", -1);
                    judgeInfos.Add(judge);
                }
                return judgeInfos;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "GetAvailableOfficial():" + ex.Message;
                return null;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }

        public static ObservableCollection<JudgeInfo> GetMatchOfficials(int matchID,int serverGroupID)
        {
            if (!CheckDBConnection())
            {
                return null;
            }
            SqlDataReader sr = null;
            ObservableCollection<JudgeInfo> judgeInfos = new ObservableCollection<JudgeInfo>();
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_GetMatchOfficial";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 10).Value = "ENG";
                sqlCmd.Parameters.Add("@ServerGroupID", SqlDbType.Int).Value = serverGroupID;
                sr = sqlCmd.ExecuteReader();

                while (sr.Read())
                {
                    JudgeInfo judge = new JudgeInfo();
                    judge.Function = (string)GetNoNullValue(sr, "F_Function", "");
                    judge.Name = (string)GetNoNullValue(sr, "F_RegisterName", "");
                    judge.NOC = (string)GetNoNullValue(sr, "NOC", "");
                    judge.FunctionID = (int)GetNoNullValue(sr, "F_FunctionID", -1);
                    judge.RegisterID = (int)GetNoNullValue(sr, "F_RegisterID", -1);
                    judge.Position = (string)GetNoNullValue(sr, "F_Position", "");
                    judge.ServantNum = (int)GetNoNullValue(sr, "F_ServantNum", -1);
                    judge.PositionID = (int)GetNoNullValue(sr, "F_PositionID", -1);
                    judge.GroupID = (int)GetNoNullValue(sr, "F_ServantGroupID", -1);
                    judge.Group = (string)GetNoNullValue(sr, "F_ServantGroup", "");
                    judgeInfos.Add(judge);
                }
                return judgeInfos;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "GetMatchOfficials():" + ex.Message;
                return null;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }

        public static ObservableCollection<JudgeFunction> GetJudgeFunctions(int matchID)
        {
            if (!CheckDBConnection())
            {
                return null;
            }
            SqlDataReader sr = null;
            ObservableCollection<JudgeFunction> functions = new ObservableCollection<JudgeFunction>();
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_SY_GetJudgeFunctions";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 10).Value = "ENG";
                sr = sqlCmd.ExecuteReader();

                while (sr.Read())
                {
                    JudgeFunction judge = new JudgeFunction();
                    judge.Function = (string)GetNoNullValue(sr, "FunctionName", "");
                    judge.FunctionID = (int)GetNoNullValue(sr, "F_FunctionID", -1);
                    judge.FunctionCode = (string)GetNoNullValue(sr, "F_FunctionCode", "");
                    functions.Add(judge);
                }
                return functions;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "GetJudgeFunctions():" + ex.Message;
                return null;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }

       

        public static ObservableCollection<JudgePosition> GetJudgePositions(int matchID)
        {
            if (!CheckDBConnection())
            {
                return null;
            }
            SqlDataReader sr = null;
            ObservableCollection<JudgePosition> positions = new ObservableCollection<JudgePosition>();
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_SY_GetJudgePositions";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 10).Value = "ENG";
                sr = sqlCmd.ExecuteReader();

                while (sr.Read())
                {
                    JudgePosition pos = new JudgePosition();
                    pos.Position = (string)GetNoNullValue(sr, "F_PositionShortName", "");
                    pos.PositionID = (int)GetNoNullValue(sr, "F_PositionID", "");
                    positions.Add(pos);
                }
                return positions;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "GetJudgePositions():" + ex.Message;
                return null;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }


        public static bool UpdateJudgeFunction(int matchID, int servantNum, int functionID)
        {
            if (!CheckDBConnection())
            {
                return false;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "[Proc_JudgePoint_UpdateMatchOfficialFunction]";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@ServantNum", SqlDbType.Int).Value = servantNum;
                sqlCmd.Parameters.Add("@FunctionID", SqlDbType.Int).Value = functionID;
                SqlParameter sqlparam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                sqlparam.Direction = ParameterDirection.Output;
                sqlCmd.ExecuteNonQuery();

                if ((int)sqlparam.Value == 1)
                {
                    return true;
                }
                return false;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "UpdateJudgeFunction():" + ex.Message;
                return false;
            }
        }

        public static bool UpdateJudgePosition(int matchID, int servantNum, int positionID)
        {
            if (!CheckDBConnection())
            {
                return false;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "[Proc_JudgePoint_UpdateMatchOfficialPosition]";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@ServantNum", SqlDbType.Int).Value = servantNum;
                sqlCmd.Parameters.Add("@PositionID", SqlDbType.Int).Value = positionID;
                SqlParameter sqlparam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                sqlparam.Direction = ParameterDirection.Output;
                sqlCmd.ExecuteNonQuery();

                if ((int)sqlparam.Value == 1)
                {
                    return true;
                }
                return false;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "UpdateJudgePosition():" + ex.Message;
                return false;
            }
        }


        public static bool AddMatchOfficial(int matchID,int serverGroupID)
        {
            if (!CheckDBConnection())
            {
                return false;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "[Proc_JudgePoint_AddMatchOfficial]";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@RegisterID", SqlDbType.Int).Value = DBNull.Value;
                sqlCmd.Parameters.Add("@FunctionID", SqlDbType.Int).Value = DBNull.Value;
                sqlCmd.Parameters.Add("@PositionID", SqlDbType.Int).Value = DBNull.Value;
                sqlCmd.Parameters.Add("@ServantGroupID", SqlDbType.Int).Value =serverGroupID;
                SqlParameter sqlparam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                sqlparam.Direction = ParameterDirection.Output;
                sqlCmd.ExecuteNonQuery();

                if ((int)sqlparam.Value == 1)
                {
                    return true;
                }
                return false;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "AddMatchOfficial():" + ex.Message;
                return false;
            }
        }


        public static bool DelMatchOfficial(int matchID, int ServantNum)
        {
            if (!CheckDBConnection())
            {
                return false;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "[Proc_JudgePoint_RemoveMatchOfficial]";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@ServantNum", SqlDbType.Int).Value = ServantNum;
                SqlParameter sqlparam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                sqlparam.Direction = ParameterDirection.Output;
                sqlCmd.ExecuteNonQuery();

                if ((int)sqlparam.Value == 1)
                {
                    return true;
                }
                return false;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "DelMatchOfficial():" + ex.Message;
                return false;
            }
        }


        public static bool UpdateMatchOfficial(int matchID, int ServantNum, int registerID)
        {
            if (!CheckDBConnection())
            {
                return false;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "[Proc_JudgePoint_UpdateMatchOfficialID]";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@ServantNum", SqlDbType.Int).Value = ServantNum;
                sqlCmd.Parameters.Add("@RegisterID", SqlDbType.Int).Value = registerID <= 0 ? (object)DBNull.Value : (object)registerID;
                SqlParameter sqlparam = sqlCmd.Parameters.Add("@Result", SqlDbType.Int);
                sqlparam.Direction = ParameterDirection.Output;
                sqlCmd.ExecuteNonQuery();

                if ((int)sqlparam.Value == 1)
                {
                    return true;
                }
                return false;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "UpdateMatchOfficial():" + ex.Message;
                return false;
            }
        }

        public static string GetMatchRuleDes(int matchID)
        {
            if (!CheckDBConnection())
            {
                return "";
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_SY_GetMatchRuleDes";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                object obj = sqlCmd.ExecuteScalar();
                if (obj == DBNull.Value)
                {
                    return "";
                }
                return (string)obj;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "GetMatchRuleDes():" + ex.Message;
                return "";
            }
        }
        public static bool ClearOfficialPosition(int matchID,int serverGroupID)
        {
            if (!CheckDBConnection())
            {
                return false;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.Text;
                sqlCmd.CommandText = string.Format("DELETE FROM TS_Match_Servant WHERE F_MatchID = {0} and (F_ServantGroupID={1} OR -1={1})", matchID,serverGroupID);
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "ClearOfficialPosition():" + ex.Message;
                return false;
            }
        }
        public static bool InitOfficialPosition(int matchID,int servantGroupID)
        {
            if (!CheckDBConnection())
            {
                return false;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_InitialMatchJudgePosition";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 10).Value = "ENG";
                sqlCmd.Parameters.Add("@ServantGroupID", SqlDbType.Int).Value = servantGroupID;
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "InitOfficialPosition():" + ex.Message;
                return false;
            }
        }

        public static bool InitExtraOfficialPosition(int matchID)
        {
            if (!CheckDBConnection())
            {
                return false;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_SY_InitExtraOfficials";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.ExecuteNonQuery();
                return true;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "InitExtraOfficialPosition():" + ex.Message;
                return false;
            }
        }

        #region ServerGroup

        public static ObservableCollection<ServerGroup> GetServerGroups(int matchID)
        {
            if (!CheckDBConnection())
            {
                return null;
            }
            SqlDataReader sr = null;
            ObservableCollection<ServerGroup> serverGroups = new ObservableCollection<ServerGroup>();
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_GetMatchServerGroup";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 10).Value = "ENG";
                sr = sqlCmd.ExecuteReader();

                while (sr.Read())
                {
                    ServerGroup group = new ServerGroup();
                    group.GroupLongName = (string)GetNoNullValue(sr, "ServerGroupLongName", "");
                    group.GroupShortName = (string)GetNoNullValue(sr, "ServerGroupShortName", "");
                    group.GroupID = (int)GetNoNullValue(sr, "GroupID", -1);
                    group.Order = (int)GetNoNullValue(sr, "Order", -1);
                    serverGroups.Add(group);
                }
                return serverGroups;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "GetServerGroups():" + ex.Message;
                return null;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }

        public static ObservableCollection<ServerGroup> GetServerGroups_All(int matchID)
        {
            if (!CheckDBConnection())
            {
                return null;
            }
            SqlDataReader sr = null;
            ObservableCollection<ServerGroup> serverGroups = new ObservableCollection<ServerGroup>();
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_GetMatchServerGroup_All";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 10).Value = "ENG";
                sr = sqlCmd.ExecuteReader();

                while (sr.Read())
                {
                    ServerGroup group = new ServerGroup();
                    group.GroupLongName = (string)GetNoNullValue(sr, "ServerGroupLongName", "");
                    group.GroupShortName = (string)GetNoNullValue(sr, "ServerGroupShortName", "");
                    group.GroupID = (int)GetNoNullValue(sr, "GroupID", -1);
                    group.Order = (int)GetNoNullValue(sr, "Order", -1);
                    serverGroups.Add(group);
                }
                return serverGroups;
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "GetServerGroups():" + ex.Message;
                return null;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                }
            }
        }

        public static void AddServerGroup(int matchID,string longName,string shortName)
        {
            if (!CheckDBConnection())
            {
                return ;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_AddMatchServerGroup";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@GroupLongName", SqlDbType.NVarChar).Value = longName;
                sqlCmd.Parameters.Add("@GroupShortName", SqlDbType.NVarChar).Value = shortName;     
                sqlCmd.ExecuteNonQuery(); 
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "AddServerGroups():" + ex.Message;
                return ;
            }
        }

        public static void DeleteServerGroup(int matchID, int order)
        {
            if (!CheckDBConnection())
            {
                return;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_RemoveMatchServerGroup";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@Order", SqlDbType.NVarChar).Value = order;
                sqlCmd.ExecuteNonQuery();
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "AddServerGroups():" + ex.Message;
                return;
            }
        }

        public static void UpdateServerGroup(int matchID, int order,string longName,string shortName)
        {
            if (!CheckDBConnection())
            {
                return;
            }
            try
            {
                SqlCommand sqlCmd = DVCommon.g_DataBaseCon.CreateCommand();
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "Proc_JudgePoint_UpdateMatchServerGroup";
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = matchID;
                sqlCmd.Parameters.Add("@Order", SqlDbType.NVarChar).Value = order;
                sqlCmd.Parameters.Add("@LongName", SqlDbType.NVarChar).Value = longName;
                sqlCmd.Parameters.Add("@ShortName", SqlDbType.NVarChar).Value = shortName;
                sqlCmd.ExecuteNonQuery();
            }
            catch (System.Exception ex)
            {
                AthleticsCommon.LastErrorMsg = "AddServerGroups():" + ex.Message;
                return;
            }
        }

        #endregion
    }

    public class AthleticsCommon
    {
        [DllImport("shell32.dll", CharSet = CharSet.Unicode)]
        public static extern IntPtr ShellExecute(IntPtr hwnd, string lpOperation, string lpFile, IntPtr lpParameters, IntPtr lpDirectory, UInt32 nShowCmd);
        public static string g_strName = "Athletics";
        public static string g_strDiscCode = "SY";
        public static SqlConnection g_sqlConn;

        public static string LastErrorMsg = "";
        public static System.Text.Encoding g_tsFileCharSet;
        public static Dictionary<string, int> g_bindFileMap;

        public static void OpenWithNotepad(string strFilePath)
        {
            ShellExecute(IntPtr.Zero, "edit", strFilePath, IntPtr.Zero, IntPtr.Zero, 1);
        }

        

        public static string GetAppRootDir()
        {
            string curExePath = System.AppDomain.CurrentDomain.BaseDirectory;
            return System.IO.Path.GetDirectoryName(curExePath);
        }

        public static void MsgBox(string strInfo)
        {
            MsgBox(strInfo, MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        public static void MsgBox(string strInfo, string strTitle)
        {
            MsgBox(strInfo, strTitle, MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        public static void MsgBox(string strInfo, MessageBoxIcon msgIcon)
        {
            MsgBox(strInfo, MessageBoxButtons.OK, msgIcon);
        }

        public static DialogResult MsgBox(string strInfo, MessageBoxButtons msgBtn, MessageBoxIcon msgIcon)
        {
            return DevComponents.DotNetBar.MessageBoxEx.Show(strInfo, "Athletics", msgBtn, msgIcon);
        }

        public static void MsgBox(string strInfo, string strTitle, MessageBoxIcon msgIcon)
        {
            MsgBox(strInfo, strTitle, MessageBoxButtons.OK, msgIcon);
        }

        public static DialogResult MsgBox(string strInfo, string title, MessageBoxButtons msgBtn, MessageBoxIcon msgIcon)
        {
            return DevComponents.DotNetBar.MessageBoxEx.Show(strInfo, title, msgBtn, msgIcon, MessageBoxDefaultButton.Button2);
        }
        public static void OpenSqlConn()
        {
            if (g_sqlConn.State == ConnectionState.Closed)
            {
                g_sqlConn.Open();
            }
        }

        public static void CloseSqlConn()
        {
            if (g_sqlConn.State == ConnectionState.Open)
            {
                g_sqlConn.Close();
            }
        }
        public static void ShowLastErrorBox()
        {
            AthleticsCommon.MsgBox(AthleticsCommon.LastErrorMsg, MessageBoxIcon.Error);
        }

        public static T GetVisualChild<T>(Visual parent) where T : Visual
        {
            T child = default(T);
            int numVisuals = VisualTreeHelper.GetChildrenCount(parent);
            for (int i = 0; i < numVisuals; i++)
            {
                Visual v = (Visual)VisualTreeHelper.GetChild(parent, i);
                child = v as T;
                if (child == null)
                {
                    child = GetVisualChild<T>(v);
                }
                if (child != null)
                {
                    break;
                }
            }
            return child;
        }

        public static DependencyObject VisualTreeSearchUp(DependencyObject obj, Type type)
        {
            DependencyObject objRes = null;
            do
            {
                objRes = VisualTreeHelper.GetParent(obj);
                if (objRes.GetType() == type)
                {
                    return objRes;
                }
                obj = objRes;
            } while (objRes != null);
            return objRes;
        }
    }


    public class ErrorLog
    {
        private string m_strLogFilePath;
        private bool bInit = false;
        private const bool FLAG_WRITE_LOG = true;
        public ErrorLog()
        {
        }
        private static ErrorLog g_errLog;
        public static ErrorLog GetLogInstance()
        {
            if (g_errLog == null)
            {
                g_errLog = new ErrorLog();
                g_errLog.Initialize();
            }
            return g_errLog;
        }
        public static void WriteErrorLog(string errDiscribe, string errReason)
        {
            ErrorLog err = ErrorLog.GetLogInstance();
            err.Writelog(errDiscribe, errReason);
        }
        public static void WriteErrorLog(string errDiscribe)
        {
            ErrorLog err = ErrorLog.GetLogInstance();
            err.Writelog(errDiscribe, AthleticsCommon.LastErrorMsg);
        }
        public void Initialize()
        {
            if (FLAG_WRITE_LOG)
            {
                if (CreateLogDir())
                {
                    bInit = true;
                }
                else
                {
                    bInit = false;
                }
            }
        }

        public void Writelog(string errDiscribe, string errReason = "")
        {
            if (!FLAG_WRITE_LOG || !bInit)
            {
                return;
            }
            try
            {
                string strDateTime = DateTime.Now.ToString("u");
                strDateTime = strDateTime.TrimEnd('Z');
                string strMsg = "";
                if (errReason == "")
                {
                    strMsg = string.Format("[{0}]日志信息：{1}", strDateTime, errDiscribe);
                }
                else
                {
                    strMsg = string.Format("[{0}]日志信息：{1}|原因：{2}", strDateTime, errDiscribe, errReason);
                }
                StreamWriter sWriter = new StreamWriter(File.Open(m_strLogFilePath, FileMode.OpenOrCreate));
                sWriter.BaseStream.Seek(0, SeekOrigin.End);
                sWriter.WriteLine(strMsg);
                sWriter.Close();
            }
            catch
            {

            }

        }
        private bool CreateLogDir()
        {
            try
            {
                if (!Directory.Exists(@"C:\AthleticsLog"))
                {
                    Directory.CreateDirectory(@"C:\AthleticsLog");
                }

                m_strLogFilePath = @"C:\AthleticsLog\AT_Error.log";
                return true;
            }
            catch
            {
                return false;
            }

        }


    }
}
