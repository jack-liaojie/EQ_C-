using System;
using System.IO;
using System.Data.SqlClient;
using System.Data;
using AutoSports.OVRCommon;
using System.Collections;
using System.Text;

namespace AutoSports.OVRWRPlugin
{
    public class OVRWRManageDB
    {
        public string GetDataEntryTitle(int matchID)
        {
            string result = "";
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paramTitle = new SqlParameter("@Title", DBNull.Value);
                paramTitle.Size = 200;
                paramTitle.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_GetDataEntryTitle", paramMatchID, paramTitle);
                result = paramTitle.Value.ToString();
            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
            return result;
        }

        public string GetPlayerNoc(int matchID, int nColor)
        {
            string result = "";
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paraCompos = new SqlParameter("@Compos", nColor);
                SqlParameter paramTitle = new SqlParameter("@Title", DBNull.Value);

                paramTitle.Size = 200;
                paramTitle.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_GetPlayerNoc", paramMatchID, paraCompos, paramTitle);
                result = paramTitle.Value.ToString();
            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }

            return result;

        }

        public int GetMatchID(int sID, int courtID, int MatchNo)
        {
            int result = 0;
            try
            {
                SqlParameter paramSessionID = new SqlParameter("@SessionNumber", sID);
                SqlParameter paramcourtID = new SqlParameter("@CourtID", courtID);
                SqlParameter paramMatchNo = new SqlParameter("@MatchNo", MatchNo);
                SqlParameter paramTitle = new SqlParameter("@MatchID", DBNull.Value);
                paramTitle.Size = 4;
                paramTitle.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_GetMatchID", paramSessionID, paramcourtID, paramMatchNo, paramTitle);
                result = GVAR.Str2Int(paramTitle.Value.ToString());
            }
            catch (Exception ee)
            {
                Log.WriteLog("JU_TS", ee.Message);
            }
            return result;
        }

        public int GetMatchStatus(int MatchID, int MatchSplitID)
        {
            int result = 0;
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", MatchID);
                SqlParameter paraMatchSplitID = new SqlParameter("@MatchSplitID", MatchSplitID);
                SqlParameter paramTitle = new SqlParameter("@MatchStatus", DBNull.Value);
                paramTitle.Size = 4;
                paramTitle.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_GetMatchStatus", paramMatchID, paraMatchSplitID, paramTitle);
                result = GVAR.Str2Int(paramTitle.Value.ToString());
            }
            catch (Exception ee)
            {
                Log.WriteLog("WR_TS", ee.Message);
            }
            return result;
        }

        public int GetMatchSplitStatus(string MatchNo, int MatchSplitID)
        {
            int result = 0;
            try
            {
                SqlParameter paramMatchNo = new SqlParameter("@MatchNo", MatchNo);
                SqlParameter paraMatchSplitID = new SqlParameter("@MatchSplitID", MatchSplitID);
                SqlParameter paramTitle = new SqlParameter("@MatchStatus", DBNull.Value);
                paramTitle.Size = 4;
                paramTitle.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_GetMatchSplitStatus", paramMatchNo, paraMatchSplitID, paramTitle);
                result = GVAR.Str2Int(paramTitle.Value.ToString());
            }
            catch (Exception ee)
            {
                Log.WriteLog("WR_TS", ee.Message);
            }
            return result;
        }

        public int GetMatchSplitPoints( string MatchNo, int MatchSplitID, int Compos)
        {
            int result = 0;
            try
            {
                
                SqlParameter paramMatchNo = new SqlParameter("@MatchNo", MatchNo);
                SqlParameter paraMatchSplitID = new SqlParameter("@MatchSplitID", MatchSplitID);
                SqlParameter paraCompos = new SqlParameter("@Compos", Compos);
                SqlParameter paramTitle = new SqlParameter("@MatchSplitPoints", DBNull.Value);
                paramTitle.Size = 4;
                paramTitle.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_GetMatchSplitPoints", paramMatchNo, paraMatchSplitID, paraCompos, paramTitle);
                result = GVAR.Str2Int(paramTitle.Value.ToString());
            }
            catch (Exception ee)
            {
                Log.WriteLog("WR_TS", ee.Message);
            }
            return result;
        }

        public void WR_TS_UpdateDatabase(string MatchNo, int MatchSplitID, int Compos, int MatchSplitPoints)
        {
            try
            {
               
                SqlParameter paramMatchNo = new SqlParameter("@MatchNo", MatchNo);
                SqlParameter paraMatchSplitID = new SqlParameter("@MatchSplitID", MatchSplitID);
                SqlParameter paraCompos = new SqlParameter("@Compos", Compos);
                SqlParameter paramSplitPoints = new SqlParameter("@MatchSplitPoints", MatchSplitPoints);
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_TS_WR_UpdatePoints", paramMatchNo, paraMatchSplitID, paraCompos, paramSplitPoints);

            }
            catch (Exception ee)
            {
                Log.WriteLog("WR_TS", ee.Message);
            }

        }

        public string GetDataForJimLing(int MatchID, int currentID)
        {
            string strResult = "";
            try
            {

                SqlParameter paraMatchID = new SqlParameter("@MatchID", MatchID);
                SqlParameter paraCompos = new SqlParameter("@currentID", currentID);
                SqlParameter paramTitle = new SqlParameter("@TSResult", DBNull.Value);
                paramTitle.Size = 200;
                paramTitle.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_GetDataForTS", paraMatchID, paraCompos, paramTitle);
                strResult = paramTitle.Value.ToString();

            }
            catch (Exception ee)
            {
                Log.WriteLog("WR_TS", ee.Message);
            }

            return strResult;
        }

        public void UpdateMatchSplitResultAndWinsets(int matchID, int matchSplitID, int nCompos, int resultSplitID)
        {
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paramMatchSplitID = new SqlParameter("@MatchSplitID", matchSplitID);
                SqlParameter paramCompos = new SqlParameter("@Compos", nCompos);
                SqlParameter paramResultSplitID = new SqlParameter("@ResultSplitID", resultSplitID);
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_UpdateMatchSplitResultAndWinset", paramMatchID, paramMatchSplitID, paramCompos, paramResultSplitID);

            }
            catch (Exception w)
            {
                Log.WriteLog("WR_Error", w.Message);
            }
        }

        public int GetTeamMatchRegisterID(int matchID, string name, int compos)
        {
            int result = 0;
            try
            {
                SqlParameter paraMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paraName = new SqlParameter("@Name", name);
                SqlParameter paraCompos = new SqlParameter("@Compos", compos);
                SqlParameter paraResult = new SqlParameter("@RegisterID", DBNull.Value);
                paraResult.Size = 4;
                paraResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_GetRegisterIDByName", paraMatchID, paraName, paraCompos, paraResult);
                result = GVAR.Str2Int(paraResult.Value.ToString());
            }
            catch (System.Exception ex)
            {
                Log.WriteLog("JU_TS", ex.Message);
            }
            return result;
        }

        public string GetDataCompName(int matchID, int numCompPos)
        {
            string result = "";
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paramCompPos = new SqlParameter("@CompPos", numCompPos);
                SqlParameter paramTitle = new SqlParameter("@Title", DBNull.Value);
                paramTitle.Size = 100;
                paramTitle.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_GeTeamTtile", paramMatchID, paramCompPos, paramTitle);
                result = paramTitle.Value.ToString();
            }
            catch (Exception)
            {

            }
            return result;
        }

        public string GetMatchMessage(int SessionNumber, string courtCode, int matchType)
        {
            string result = "";
            try
            {
                SqlParameter paramSessionNumber = new SqlParameter("@SessionNumber", SessionNumber);
                SqlParameter paramCourtCode = new SqlParameter("@CourtCode", courtCode);
                SqlParameter paramMatchType = new SqlParameter("@MatchType", matchType);
                SqlParameter paramResult = new SqlParameter("@Result", DBNull.Value);
                paramResult.Size = 65535;
                paramResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_GetMatchMessage", paramSessionNumber, paramCourtCode, paramMatchType, paramResult);
                result = paramResult.Value.ToString();
            }
            catch (Exception ee)
            {
                Log.WriteLog("JU", ee.Message);
            }

            return result;
        }

        public string GetJudgeMessageForMatch(int SessionNumber, string courtCode, int matchType)
        {
            string result = "";
            try
            {
                SqlParameter paramSessionNumber = new SqlParameter("@SessionNumber", SessionNumber);
                SqlParameter paramCourtCode = new SqlParameter("@CourtCode", courtCode);
                SqlParameter paramMatchType = new SqlParameter("@MatchType", matchType);
                SqlParameter paramResult = new SqlParameter("@Result", DBNull.Value);
                paramResult.Size = 65535;
                paramResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_GetJudgeMessage_ForMatch", paramSessionNumber, paramCourtCode, paramMatchType, paramResult);
                result = paramResult.Value.ToString();
            }
            catch (Exception ee)
            {
                Log.WriteLog("JU", ee.Message);
            }

            return result;
        }

        public string GetJudgeMessage()
        {
            string result = "";
            try
            {
                SqlParameter paramResult = new SqlParameter("@Result", DBNull.Value);
                paramResult.Size = 65535;
                paramResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_GetJudgeMessage", paramResult);
                result = paramResult.Value.ToString();
            }
            catch (Exception ee)
            {
                Log.WriteLog("JU", ee.Message);
            }

            return result;
        }

        public int GetMatchTypeID(int matchID)
        {
            int result = 0;
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paraTypeID = new SqlParameter("@MatchTypeID", DbType.Int32);
                paraTypeID.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_GetMatchType", paramMatchID, paraTypeID);
                result = int.Parse(paraTypeID.Value.ToString());
            }
            catch (Exception w)
            {
                string str = w.Message.ToString();
            }
            return result;
        }

        public string GetMessageForLastResult(int matchID, int matchSplitID)
        {
            string result = "";
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paraSplitID = new SqlParameter("@MatchSplitID", matchSplitID);
                SqlParameter paramResult = new SqlParameter("@strResult", DBNull.Value);
                paramResult.Size = 20;
                paramResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_GetMessageForGetLastResult", paramMatchID, paraSplitID, paramResult);
                result = paramResult.Value.ToString();
            }
            catch (Exception w)
            {
                Log.WriteLog("JU_GetMessageForLastResult", w.Message);
            }
            return result;
        }

        public int GetMatchSessionNumber(int matchID)
        {
            int result = 0;
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paraTypeID = new SqlParameter("@MatchSessionNumber", DbType.Int32);
                paraTypeID.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_GetMatchSessionNumber", paramMatchID, paraTypeID);
                result = int.Parse(paraTypeID.Value.ToString());
            }
            catch (Exception w)
            {
                Log.WriteLog("JU", w.Message);
            }
            return result;
        }

        public int GetMatchCourtNumber(int matchID)
        {
            int result = 0;
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paraTypeID = new SqlParameter("@MatchCourtNumber", DbType.Int32);
                paraTypeID.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_GetMatchCourtNumber", paramMatchID, paraTypeID);
                result = int.Parse(paraTypeID.Value.ToString());
            }
            catch (Exception w)
            {
                Log.WriteLog("WR", w.Message);
            }
            return result;
        }

        public void UpdateMatchResultandRank(int matchID, int nCompos, int nResultID, int nRank)
        {
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paramCompos = new SqlParameter("@Compos", nCompos);
                SqlParameter paramResultID = new SqlParameter("@ResultID", nResultID);
                SqlParameter paramRank = new SqlParameter("@Rank", nRank);
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_UpdateMatchResultandRank", paramMatchID, paramCompos, paramResultID, paramRank);

            }
            catch (Exception w)
            {
                Log.WriteLog("JU", w.Message);
            }

        }

        public int GetMatchRaceNum(int matchID)
        {
            int result = 0;
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paraRaceNum = new SqlParameter("@MatchRaceNum", DbType.Int32);
                paraRaceNum.Direction = ParameterDirection.Output;
                SqlParameter SessionID = new SqlParameter("@SessionID", DbType.Int32);
                SessionID.Direction = ParameterDirection.Output;
                SqlParameter MatchDay = new SqlParameter("@MatchDay", DbType.Int32);
                MatchDay.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_GetMatchRaceNum", paramMatchID, paraRaceNum, SessionID, MatchDay);
                result = int.Parse(paraRaceNum.Value.ToString());
                GVAR.g_matchDay = int.Parse(MatchDay.ToString());
                GVAR.g_sessionNumber = int.Parse(SessionID.Value.ToString());
            }
            catch (Exception w)
            {
                string str = w.Message.ToString();

            }
            return result;
        }

        public bool IsHaveData(int matchID)
        {
            bool rtnResult = false;
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paraResultID = new SqlParameter("@ResultID", DbType.Int32);
                paraResultID.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_MatchsHasData", paramMatchID, paraResultID);
                if (int.Parse(paraResultID.Value.ToString()) > 0)
                {
                    rtnResult = true;
                }
            }
            catch (Exception w)
            {
                string str = w.Message.ToString();
            }
            return rtnResult;
        }

        public int GetTeamStatusID(int matchID)
        {
            int mId = 0;
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                SqlParameter paraMatchStatusID = new SqlParameter("@MatchStatusID", DbType.Int32);
                paraMatchStatusID.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_GetTeamMatchStatus", paramMatchID, paraMatchStatusID);
                mId = int.Parse(paraMatchStatusID.Value.ToString());
            }
            catch (Exception w)
            {
                string str = w.Message.ToString();
            }
            return mId;
        }

        public int CreateMatchSplit(Int32 nMatchID, Int32 nMatchType, Int32 nGamesCount, Int32 nTeamSplitCount)
        {
            int result = 0;
            ArrayList paramCollection = new ArrayList();
            string strStoreProcName = "proc_CreateMatchSplits_1_Level";

            paramCollection.Add(new SqlParameter("@MatchID", nMatchID));
            paramCollection.Add(new SqlParameter("@MatchType", nMatchType));
            paramCollection.Add(new SqlParameter("@Level_1_SplitNum", nGamesCount));

            paramCollection.Add(new SqlParameter("@CreateType", 1)); // @CreateType = 1 : Create Delete Old and Create New Splits
            paramCollection.Add(new SqlParameter("@Result", -1));
            ((SqlParameter)paramCollection[4]).Direction = ParameterDirection.Output;
            SqlParameter[] aryParams = new SqlParameter[paramCollection.Count];

            paramCollection.CopyTo(aryParams, 0);

            try
            {
                GVAR.g_adoDataBase.ExecuteProcNoQuery(strStoreProcName, aryParams);

                result = (Int32)aryParams[aryParams.Length - 1].Value;
            }
            catch
            {

                return -1;
            }

            return result;
        }

        public void GetMatchResultPoints(int nMatchID, int nColor, ref int PointsTotal, ref int PointsSplit1st, ref int PointsSplit2nd, ref int PointsSplit3rd, ref int nWinsets, ref int PointsSplit1stAddtime, ref int PointsSplit2ndAddtime, ref int PointsSplit3rdAddtime)
        {

            STableRecordSet tb = new STableRecordSet();
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", nMatchID);
                SqlParameter paramColor = new SqlParameter("@Compos", nColor);
                GVAR.g_adoDataBase.ExecuteProc("Proc_WR_GetMatchResultPoints", tb, paramMatchID, paramColor);

                PointsTotal = GVAR.Str2Int(tb.GetFieldValue(0, "PointsTotal"));
                PointsSplit1st = GVAR.Str2Int(tb.GetFieldValue(0, "PointsSplit1st"));
                PointsSplit2nd = GVAR.Str2Int(tb.GetFieldValue(0, "PointsSplit2nd"));
                PointsSplit3rd = GVAR.Str2Int(tb.GetFieldValue(0, "PointsSplit3rd"));
                nWinsets = GVAR.Str2Int(tb.GetFieldValue(0, "WinSets"));
                PointsSplit1stAddtime = GVAR.Str2Int(tb.GetFieldValue(0, "PointsSplit1stAddTime"));
                PointsSplit2ndAddtime = GVAR.Str2Int(tb.GetFieldValue(0, "PointsSplit2ndAddTime"));
                PointsSplit3rdAddtime = GVAR.Str2Int(tb.GetFieldValue(0, "PointsSplit3rdAddTime"));
            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
        }

        public void GetMatchSplitStatusAndDesicionCode(int nMatchID, int nMatchSplitID, ref int nStatusID, ref string strDecisionCode, ref int nHanteisplitA, ref int nHanteisplitB)
        {

            STableRecordSet tb = new STableRecordSet();
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", nMatchID);
                SqlParameter paraMatchSplitID = new SqlParameter("@MatchSplitID", nMatchSplitID);
                GVAR.g_adoDataBase.ExecuteProc("Proc_WR_GetMatch_StatusAndDecisionCode", tb, paramMatchID, paraMatchSplitID);

                nStatusID = GVAR.Str2Int(tb.GetFieldValue(0, "StatusID"));
                strDecisionCode = tb.GetFieldValue(0, "DecisionCode");
                nHanteisplitA = GVAR.Str2Int(tb.GetFieldValue(0, "HanteiSplitA"));
                nHanteisplitB = GVAR.Str2Int(tb.GetFieldValue(0, "HanteiSplitB"));
            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
        }

        public int UpdateMatchResultPoints(int nMatchID, int nCompPos, int nPointsTotal, int nPointsSplit1st, int nPointsSplit2nd, int nPointsSplit3rd, int nPointsSplit1stAddtime, int nPointsSplit2ndAddtime, int nPointsSplit3rdAddtime)
        {
            int nResult = 0;
            try
            {
                SqlParameter[] aryProcParams = new SqlParameter[9];
                aryProcParams[0] = new SqlParameter("@MatchID", nMatchID);
                aryProcParams[1] = new SqlParameter("@Compos", nCompPos);
                aryProcParams[2] = new SqlParameter("@PointsTotal", nPointsTotal);
                aryProcParams[3] = new SqlParameter("@PointsSplit1st", nPointsSplit1st);
                aryProcParams[4] = new SqlParameter("@PointsSplit2nd", nPointsSplit2nd);
                aryProcParams[5] = new SqlParameter("@PointsSplit3rd", nPointsSplit3rd);
                aryProcParams[6] = new SqlParameter("@PointsSplit1st_AddTime", nPointsSplit1stAddtime);
                aryProcParams[7] = new SqlParameter("@PointsSplit2nd_AddTime", nPointsSplit2ndAddtime);
                aryProcParams[8] = new SqlParameter("@PointsSplit3rd_AddTime", nPointsSplit3rdAddtime);
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_UpdatetMatchResultPoints", aryProcParams);

                nResult = 1;
            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
            return nResult;
        }

        public int UpdateMatchSplitHantei(int nMatchID, int nMatchSplitID, int nHanteiSplitA, int nHanteiSplitB)
        {
            int result = 0;
            try
            {
                SqlParameter[] aryProcParams = new SqlParameter[4];
                aryProcParams[0] = new SqlParameter("@MatchID", nMatchID);
                aryProcParams[1] = new SqlParameter("@MatchSplitID", nMatchSplitID);
                aryProcParams[2] = new SqlParameter("@HanteiSplitIDA", nHanteiSplitA);
                aryProcParams[3] = new SqlParameter("@HanteiSplitIDB", nHanteiSplitB);


                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_UpdateMatchSplit_Hantei", aryProcParams);

                result = 1;
            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
            return result;
        }

        public int UpdateSplitStatusAndDecisionCode(int nMatchID, int nMatchSplitID, int nStatusID, string nDecisinCode)
        {
            int result = 0;
            try
            {
                SqlParameter[] aryProcParams = new SqlParameter[4];
                aryProcParams[0] = new SqlParameter("@MatchID", nMatchID);
                aryProcParams[1] = new SqlParameter("@MatchSplitID", nMatchSplitID);
                aryProcParams[2] = new SqlParameter("@MatchSplitStatusID", nStatusID);

                aryProcParams[3] = new SqlParameter("@MatchSplitDecisionCode", nDecisinCode);


                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_UpdateMatchSplit_StatusIDAndDecision", aryProcParams);

                result = 1;
            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
            return result;
        }

        public void GetMatchIRMandHantei(int nMatchID, int nCompPos, ref int nHanteiID, ref string nIRMCode)
        {
            STableRecordSet tb = new STableRecordSet();
            try
            {
                SqlParameter[] para = new SqlParameter[2];
                para[0] = new SqlParameter("@MatchID", nMatchID);
                para[1] = new SqlParameter("@Compos", nCompPos);

                GVAR.g_adoDataBase.ExecuteProc("Proc_WR_GetMatchIRMandHantei", tb, para);

                nHanteiID = GVAR.Str2Int(tb.GetFieldValue(0, "HanteiID"));
                nIRMCode = tb.GetFieldValue(0, "IRMCode");

            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
        }

        public int UpdateMatchIRMandHantei(int nMatchID, int nCompPos, int nHantei, string nIRMCode)
        {
            int nResult = 0;
            try
            {
                SqlParameter[] aryProcParams = new SqlParameter[4];
                aryProcParams[0] = new SqlParameter("@MatchID", nMatchID);
                aryProcParams[1] = new SqlParameter("@Compos", nCompPos);
                aryProcParams[2] = new SqlParameter("@HanteiID", nHantei);
                aryProcParams[3] = new SqlParameter("@IRMCode", nIRMCode);
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_UpdateMatchIRMandHantei", aryProcParams);

                nResult = 1;
            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
            return nResult;
        }

        public int UpdateMatchDecision(int nMatchID, string nDecisionCode)
        {
            int nResult = 0;
            try
            {
                SqlParameter[] aryProcParams = new SqlParameter[2];
                aryProcParams[0] = new SqlParameter("@MatchID", nMatchID);
                aryProcParams[1] = new SqlParameter("@DecisionCode", nDecisionCode);
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_UpdateMatchDecisionCode", aryProcParams);

                nResult = 1;
            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
            return nResult;
        }

        public void GetMatchDecisionCode(int nMatchID, ref string nDecisionCode)
        {
            STableRecordSet tb = new STableRecordSet();
            try
            {
                SqlParameter[] para = new SqlParameter[1];
                para[0] = new SqlParameter("@MatchID", nMatchID);

                GVAR.g_adoDataBase.ExecuteProc("Proc_WR_GetMatchDecisionCode", tb, para);

                nDecisionCode = tb.GetFieldValue(0, "DecisionCode");

            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
        }

        public int UpdateMatchClassidicationPoints(int nMatchID, int nCompos, int nClassPoints)
        {
            int nResult = 0;
            try
            {
                SqlParameter[] aryProcParams = new SqlParameter[3];
                aryProcParams[0] = new SqlParameter("@MatchID", nMatchID);
                aryProcParams[1] = new SqlParameter("@Compos", nCompos);
                aryProcParams[2] = new SqlParameter("@ClassidicatonPints", nClassPoints);
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_UpdateMatchClassidicationPoints", aryProcParams);

                nResult = 1;
            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
            return nResult;
        }

        public void GetMatchClassidicationPoints(int nMatchID, int nCompos, ref int nPoints)
        {
            STableRecordSet tb = new STableRecordSet();
            try
            {
                SqlParameter[] para = new SqlParameter[2];
                para[0] = new SqlParameter("@MatchID", nMatchID);
                para[1] = new SqlParameter("@Compos", nCompos);

                GVAR.g_adoDataBase.ExecuteProc("Proc_WR_GetMatchClassidicationPoints", tb, para);

                nPoints = GVAR.Str2Int(tb.GetFieldValue(0, "ClassidicationPoints"));

            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
        }

        public int UpdateMatch_Individual(int nMatchID, int nGoldenScore
            , string strContestTime, string strTechnique, int nStatusID, string strDecisionCode)
        {
            int nResult = 0;
            if (3 == GVAR.g_matchTypeID)
            {
                nResult = UpdateMatchSplitInfo_Team(nMatchID, GVAR.g_matchSplitID, nGoldenScore, strContestTime, strTechnique, nStatusID, strDecisionCode);
                return nResult;
            }

            try
            {
                SqlParameter[] aryProcParams = new SqlParameter[7];
                aryProcParams[0] = new SqlParameter("@MatchID", nMatchID);
                aryProcParams[1] = new SqlParameter("@GoldenScore", nGoldenScore);
                aryProcParams[2] = new SqlParameter("@ContestTime", strContestTime);
                aryProcParams[3] = new SqlParameter("@Technique", strTechnique);
                aryProcParams[4] = new SqlParameter("@StatusID", nStatusID);
                aryProcParams[5] = new SqlParameter("@DecisionCode", strDecisionCode);
                aryProcParams[6] = new SqlParameter("@Result", DBNull.Value);
                aryProcParams[6].Size = 4;
                aryProcParams[6].Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_SetMatch_Individual", aryProcParams);

                nResult = GVAR.Str2Int(aryProcParams[6].Value.ToString());
            }
            catch (Exception ex)
            {
                Log.WriteLog("JU_Error", ex.Message);
            }
            return nResult;
        }

        public int UpdateMatchSplitInfo_Team(int nMatchID, int nMatchSplitID, int nGoldenScore
            , string strContestTime, string strTechnique, int nStatusID, string strDecisionCode)
        {
            int nResult = 0;
            try
            {
                SqlParameter[] aryProcParams = new SqlParameter[8];
                aryProcParams[0] = new SqlParameter("@MatchID", nMatchID);
                aryProcParams[1] = new SqlParameter("@MatchSplitID", nMatchSplitID);
                aryProcParams[2] = new SqlParameter("@GoldenScore", nGoldenScore);
                aryProcParams[3] = new SqlParameter("@ContestTime", strContestTime);
                aryProcParams[4] = new SqlParameter("@Technique", strTechnique);
                aryProcParams[5] = new SqlParameter("@StatusID", nStatusID);
                aryProcParams[6] = new SqlParameter("@DecisionCode", strDecisionCode);
                aryProcParams[7] = new SqlParameter("@Result", DBNull.Value);
                aryProcParams[7].Size = 4;
                aryProcParams[7].Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_SetMatchSplitInfo_Team", aryProcParams);

                nResult = GVAR.Str2Int(aryProcParams[7].Value.ToString());
            }
            catch (Exception ex)
            {
                Log.WriteLog("JU_Error", ex.Message);
            }
            return nResult;
        }

        public int SetMatchGoldenAndHantei_Team(int nMatchID, int nGoldenScore, int HanteiA, int HanteiB)
        {
            int nResult = 0;
            try
            {
                SqlParameter[] aryProcParams = new SqlParameter[5];
                aryProcParams[0] = new SqlParameter("@MatchID", nMatchID);
                aryProcParams[1] = new SqlParameter("@GoldenScore", nGoldenScore);
                aryProcParams[2] = new SqlParameter("@HanteiA", HanteiA);
                aryProcParams[3] = new SqlParameter("@HanteiB", HanteiB);
                aryProcParams[4] = new SqlParameter("@Result", DBNull.Value);
                aryProcParams[4].Size = 4;
                aryProcParams[4].Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_SetMatchGoldenAndHantei_Team", aryProcParams);

                nResult = GVAR.Str2Int(aryProcParams[4].Value.ToString());
            }
            catch (Exception ex)
            {
                Log.WriteLog("JU_Error", ex.Message);
            }
            return nResult;
        }

        public void GetMatchGoldenAndHantei_Team(int nMatchID, ref int nGoldenScore, ref int HanteiA, ref int HanteiB)
        {
            STableRecordSet tb = new STableRecordSet();
            try
            {
                SqlParameter para = new SqlParameter("@MatchID", nMatchID);
                GVAR.g_adoDataBase.ExecuteProc("Proc_JU_GetMatchGoldenAndHantei_Team", tb, para);

                nGoldenScore = GVAR.Str2Int(tb.GetFieldValue(0, "GoldenScore"));
                HanteiA = GVAR.Str2Int(tb.GetFieldValue(0, "HanteiA"));
                HanteiB = GVAR.Str2Int(tb.GetFieldValue(0, "HanteiB"));

            }
            catch (Exception ex)
            {
                Log.WriteLog("JU_Error", ex.Message);
            }
        }

        public void GetDecisionList(ref System.Data.DataTable table)
        {
            GVAR.g_adoDataBase.ExecuteProc("Proc_WR_GetDecisionList", ref table, null);
        }

        public void FillDecisionList(System.Windows.Forms.ComboBox cmb)
        {
            GVAR.g_adoDataBase.FillComb("Proc_WR_GetDecisionList", "Decision", "DecisionCode", cmb, null);
        }

        public void FillIRMList(System.Windows.Forms.ComboBox cmb)
        {
            GVAR.g_adoDataBase.FillComb("Proc_WR_GetIRMList", "IRM", "IRMCode", cmb, null);
        }

        public bool SetMatchStatus(int nMatchID, int nStatusID)
        {
            return (OVRDataBaseUtils.ChangeMatchStatus(nMatchID, nStatusID, GVAR.g_adoDataBase.DBConnect, GVAR.g_WRPlugin) == 1);
        }

        public bool AutoProgressMatch(int nMatchID)
        {
            return OVRDataBaseUtils.AutoProgressMatch(nMatchID, GVAR.g_adoDataBase.DBConnect, GVAR.g_WRPlugin);
        }

        #region Match Judge

        //*************************************************************
        //set frmOVRSPMatchJudgeConfig's Judge's Name with NOC(Without LanguageCode)
        //*************************************************************
        public DataTable GetJudgeName(int MatchID)
        {
            DataTable dt = new DataTable();

            //SQL Command
            SqlCommand sqlCommand = new SqlCommand();
            sqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
            sqlCommand.CommandText = "Proc_WR_ListCompetitionOfficials";
            sqlCommand.CommandType = CommandType.StoredProcedure;
            //SqlParameter cmdParameter = new SqlParameter(
            //                "@MatchID", SqlDbType.Int, 4,
            //                ParameterDirection.Input, true, 0, 0, "",
            //                DataRowVersion.Current, MatchID);
            //sqlCommand.Parameters.Add(cmdParameter);

            sqlCommand.Parameters.AddWithValue("@MatchID", MatchID);

            SqlDataAdapter sqlDataAdapter = new SqlDataAdapter();
            sqlDataAdapter.SelectCommand = sqlCommand;
            try
            {
                sqlDataAdapter.Fill(dt);
            }
            catch (Exception ex)
            {
                Log.WriteLog("WR_Error", ex.Message);
            }
            return dt;
        }

        //*************************************************************
        //set frmOVRSPMatchJudgeConfig's Judge's Function(Without LanguageCode)
        //*************************************************************
        public DataTable GetJudgeFunction(int MatchID)
        {
            DataTable dt = new DataTable();

            //SQL Command
            SqlCommand sqlCommand = new SqlCommand();
            sqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
            sqlCommand.CommandText = "Proc_WR_ListFunctions";
            sqlCommand.CommandType = CommandType.StoredProcedure;
            //SqlParameter cmdParameter = new SqlParameter(
            //                "@MatchID", SqlDbType.Int, 4,
            //                ParameterDirection.Input, true, 0, 0, "",
            //                DataRowVersion.Current, MatchID);
            //sqlCommand.Parameters.Add(cmdParameter);

            sqlCommand.Parameters.AddWithValue("@MatchID", MatchID);

            SqlDataAdapter sqlDataAdapter = new SqlDataAdapter();
            sqlDataAdapter.SelectCommand = sqlCommand;
            try
            {
                sqlDataAdapter.Fill(dt);
            }
            catch (Exception ex)
            {
                Log.WriteLog("JU_Error", ex.Message);
            }
            return dt;
        }

        //*************************************************************
        //set frmOVRSPMatchJudgeConfig's all controls'data(Without LanguageCode)
        //*************************************************************
        public DataTable GetMatchJudgeControlData(int MatchID)
        {
            DataTable dt = new DataTable();

            //SQL Command
            SqlCommand sqlCommand = new SqlCommand();
            sqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
            sqlCommand.CommandText = "Proc_WR_GetMatchJudges";
            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.AddWithValue("@MatchID", MatchID);

            SqlDataAdapter sqlDataAdapter = new SqlDataAdapter();
            sqlDataAdapter.SelectCommand = sqlCommand;
            try
            {
                sqlDataAdapter.Fill(dt);
            }
            catch (Exception)
            {

            }
            return dt;
        }

        //*************************************************************
        //Save frmOVRSPMatchJudgeConfig's match judges' data
        //*************************************************************
        public void UpdateMatchJudgeDataToDB(int MatchID, string ServantNum, string RegisterID, string FunctionID, string Order, int ManageState)
        {
            if (ManageState == 0)
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", MatchID);
                int intRegisterID = Convert.ToInt32(RegisterID);
                SqlParameter paramRegisterID = new SqlParameter("@RegisterID", intRegisterID);
                int intFunctionID = Convert.ToInt32(FunctionID);
                SqlParameter paramFunctionID = new SqlParameter("@FunctionID", intFunctionID);
                SqlParameter paramResult = new SqlParameter("@Result", DBNull.Value);
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_AddMatchJudge", paramMatchID, paramRegisterID, paramFunctionID, paramResult);
            }
            if (ManageState == 1)
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", MatchID);
                SqlParameter paramServantNum = new SqlParameter("@ServantNum", Convert.ToInt32(ServantNum));
                SqlParameter paramResult = new SqlParameter("@Result", DBNull.Value);

                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_DeleteMatchJudge", paramMatchID, paramServantNum, paramResult);
            }
            if (ManageState == 2)
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", MatchID);
                SqlParameter paramServantNum = new SqlParameter("@ServantNum", Convert.ToInt32(ServantNum));
                SqlParameter paramRegisterID = new SqlParameter("@RegisterID", Convert.ToInt32(RegisterID));

                SqlParameter paramFunctionID = new SqlParameter("@FunctionID", Convert.ToInt32(FunctionID));
                //SqlParameter paramOrder = new SqlParameter("@Order", Convert.ToInt32(Order));
                SqlParameter paramOrder = new SqlParameter("@Order", DBNull.Value);
                SqlParameter paramResult = new SqlParameter("@Result", DBNull.Value);

                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_UpdateMatchJudge", paramMatchID, paramServantNum, paramRegisterID, paramFunctionID, paramOrder, paramResult);
            }
            if (ManageState == 3)
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", MatchID);
                SqlParameter paramServantNum = new SqlParameter("@ServantNum", Convert.ToInt32(ServantNum));
                //SqlParameter paramRegisterID = new SqlParameter("@RegisterID", Convert.ToInt32(RegisterID));
                SqlParameter paramRegisterID = new SqlParameter("@RegisterID", DBNull.Value);

                //SqlParameter paramFunctionID = new SqlParameter("@FunctionID", Convert.ToInt32(FunctionID));
                SqlParameter paramFunctionID = new SqlParameter("@FunctionID", DBNull.Value);
                SqlParameter paramOrder = new SqlParameter("@Order", Convert.ToInt32(Order));
                SqlParameter paramResult = new SqlParameter("@Result", DBNull.Value);

                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_WR_UpdateMatchJudge", paramMatchID, paramServantNum, paramRegisterID, paramFunctionID, paramOrder, paramResult);
            }
        }

        #endregion

        #region 计时计分更新数据库

        public int UpdateMatch_Individual_ForTS(int sessionNumber, int courtID, int matchNo, int splitID, int GS, string time, string technique)
        {
            int nResult = 0;
            try
            {
                SqlParameter[] aryProcParams = new SqlParameter[8];
                aryProcParams[0] = new SqlParameter("@SessionNumber", sessionNumber);
                aryProcParams[1] = new SqlParameter("@CourtID", courtID);
                aryProcParams[2] = new SqlParameter("@MatchNo", matchNo);
                aryProcParams[3] = new SqlParameter("@SplitID", splitID);
                aryProcParams[4] = new SqlParameter("@GoldenScore", GS);
                aryProcParams[5] = new SqlParameter("@ContestTime", time);
                aryProcParams[6] = new SqlParameter("@Technique", technique);
                aryProcParams[7] = new SqlParameter("@Result", DBNull.Value);
                aryProcParams[7].Size = 4;
                aryProcParams[7].Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_TS_SetMatch_Individual", aryProcParams);

                nResult = GVAR.Str2Int(aryProcParams[7].Value.ToString());
            }
            catch (Exception ee)
            {
                Log.WriteLog("JU_TS", ee.Message);
            }
            return nResult;
        }

        public int UpdateMatchResult_Individual_ForTS(int sessionNumber, int courtID, int matchNo, int splitID, int Compos, int Ippon, int Waza, int Yuko, int BS, int BKIK, int BFUS, int BH, int BX, int BHantei)
        {
            int nResult = 0;
            try
            {
                SqlParameter[] aryProcParams = new SqlParameter[15];
                aryProcParams[0] = new SqlParameter("@SessionNumber", sessionNumber);
                aryProcParams[1] = new SqlParameter("@CourtID", courtID);
                aryProcParams[2] = new SqlParameter("@MatchNo", matchNo);
                aryProcParams[3] = new SqlParameter("@SplitID", splitID);
                aryProcParams[4] = new SqlParameter("@CompPos", Compos);
                aryProcParams[5] = new SqlParameter("@IPP", Ippon);
                aryProcParams[6] = new SqlParameter("@WAZ", Waza);
                aryProcParams[7] = new SqlParameter("@YUK", Yuko);
                aryProcParams[8] = new SqlParameter("@S", BS);
                aryProcParams[9] = new SqlParameter("@Kik", BKIK);
                aryProcParams[10] = new SqlParameter("@FUS", BFUS);
                aryProcParams[11] = new SqlParameter("@SH", BH);
                aryProcParams[12] = new SqlParameter("@SX", BX);
                aryProcParams[13] = new SqlParameter("@Hantei", BHantei);
                aryProcParams[14] = new SqlParameter("@Result", DBNull.Value);
                aryProcParams[14].Size = 4;
                aryProcParams[14].Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_TS_SetMatchResult_Individual", aryProcParams);

                nResult = GVAR.Str2Int(aryProcParams[14].Value.ToString());
            }
            catch (Exception ee)
            {
                Log.WriteLog("JU_TS", ee.Message);
            }
            return nResult;
        }

        public int UpdateMatch_Team_ForTS(int sessionNumber, int courtID, int matchNo, int splitID, int GS, string time, string technique)
        {
            int nResult = 0;
            try
            {
                SqlParameter[] aryProcParams = new SqlParameter[8];
                aryProcParams[0] = new SqlParameter("@SessionNumber", sessionNumber);
                aryProcParams[1] = new SqlParameter("@CourtID", courtID);
                aryProcParams[2] = new SqlParameter("@MatchNo", matchNo);
                aryProcParams[3] = new SqlParameter("@SplitID", splitID);
                aryProcParams[4] = new SqlParameter("@GoldenScore", GS);
                aryProcParams[5] = new SqlParameter("@ContestTime", time);
                aryProcParams[6] = new SqlParameter("@Technique", technique);
                aryProcParams[7] = new SqlParameter("@Result", DBNull.Value);
                aryProcParams[7].Size = 4;
                aryProcParams[7].Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_TS_SetMatchSplitInfo_Team", aryProcParams);

                nResult = GVAR.Str2Int(aryProcParams[7].Value.ToString());
            }
            catch (Exception ee)
            {
                Log.WriteLog("JU_TS", ee.Message);
            }
            return nResult;
        }

        public int UpdateMatchResult_Team_ForTS(int sessionNumber, int courtID, int matchNo, int splitID, int Compos, int Ippon, int Waza, int Yuko, int BS, int BKIK, int BFUS, int BH, int BX, int BHantei)
        {
            int nResult = 0;
            try
            {
                SqlParameter[] aryProcParams = new SqlParameter[15];
                aryProcParams[0] = new SqlParameter("@SessionNumber", sessionNumber);
                aryProcParams[1] = new SqlParameter("@CourtID", courtID);
                aryProcParams[2] = new SqlParameter("@MatchNo", matchNo);
                aryProcParams[3] = new SqlParameter("@SplitID", splitID);
                aryProcParams[4] = new SqlParameter("@CompPos", Compos);
                aryProcParams[5] = new SqlParameter("@IPP", Ippon);
                aryProcParams[6] = new SqlParameter("@WAZ", Waza);
                aryProcParams[7] = new SqlParameter("@YUK", Yuko);
                aryProcParams[8] = new SqlParameter("@S", BS);
                aryProcParams[9] = new SqlParameter("@Kik", BKIK);
                aryProcParams[10] = new SqlParameter("@FUS", BFUS);
                aryProcParams[11] = new SqlParameter("@SH", BH);
                aryProcParams[12] = new SqlParameter("@SX", BX);
                aryProcParams[13] = new SqlParameter("@Hantei", BHantei);
                aryProcParams[14] = new SqlParameter("@Result", DBNull.Value);
                aryProcParams[14].Size = 4;
                aryProcParams[14].Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_JU_TS_SetMatchSplitResult_Team", aryProcParams);

                nResult = GVAR.Str2Int(aryProcParams[14].Value.ToString());
            }
            catch (Exception ee)
            {
                Log.WriteLog("JU_TS", ee.Message);
            }
            return nResult;
        }

        #endregion

        #region 计时计分导出程序

        public void GetDataForTS_Players_JinLing(string path)
        {
            string fileName = path + "wr2013players.txt";

            STableRecordSet tb = new STableRecordSet();

            StreamWriter sw = null;

            try
            {
                UTF8Encoding utf8 = new UTF8Encoding(true);

                sw = new StreamWriter(fileName, false,Encoding.Unicode);

                GVAR.g_adoDataBase.ExecuteProc("Proc_WR_GetTSPlayers", tb);

                int playersCount = tb.GetRecordCount();

                if (playersCount > 0)
                {
                    string strMessage = "";

                    for (int i = 0; i < playersCount; i++)
                    {
                        strMessage = tb.GetFieldValue(i, "MatchNo") + ',' + tb.GetFieldValue(i, "PlayerName") + ',' + tb.GetFieldValue(i, "TeamName") + ',' + tb.GetFieldValue(i, "EventName") + ',' + tb.GetFieldValue(i, "Gender") + ',';

                        sw.WriteLine(strMessage);
                    }
                    //清空缓冲区
                    sw.Flush();
                }
            }
            catch (Exception ee)
            {
                Log.WriteLog("WRTS", ee.Message);
            }
            finally
            {
                //关闭流
                if (sw != null)
                    sw.Close();
            }
        }

        public void GetDataForTS_StartList_JinLing(int matchID, string path,string courtName)
        {
            string fileName = path +courtName+@"\"+ "wr2013startlist.txt";

            STableRecordSet tb = new STableRecordSet();

            StreamWriter sw = null;

            try
            {
                sw = new StreamWriter(fileName, false, Encoding.Unicode);

                SqlParameter paramMatchID = new SqlParameter("@MatchID", matchID);
                GVAR.g_adoDataBase.ExecuteProc("Proc_WR_GetTSStartLsits", tb, paramMatchID);

                int playersCount = tb.GetRecordCount();

                if (playersCount > 0)
                {
                    string strMessage = "";

                    for (int i = 0; i < playersCount; i++)
                    {
                        strMessage = tb.GetFieldValue(i, "MatchDate") + ','
                            + tb.GetFieldValue(i, "CourtNo") + ','
                            + tb.GetFieldValue(i, "MatchNo") + ','
                            + tb.GetFieldValue(i, "PhaseName") + ','

                            + tb.GetFieldValue(i, "EventName") + ','
                            + tb.GetFieldValue(i, "Gender") + ','
                            + tb.GetFieldValue(i, "MatchStyle") + ','

                            + tb.GetFieldValue(i, "RedNo") + ','
                            + tb.GetFieldValue(i, "RedName") + ','
                            + tb.GetFieldValue(i, "RedTeam") + ','
                            + tb.GetFieldValue(i, "BlueNo") + ','
                            + tb.GetFieldValue(i, "BlueName") + ','
                            + tb.GetFieldValue(i, "BlueTeam") + ',';

                        sw.WriteLine(strMessage);

                    }
                    //清空缓冲区
                    sw.Flush();
                }
            }
            catch (Exception ee)
            {
                Log.WriteLog("WRTS", ee.Message);
            }
            finally
            {
                //关闭流
                if (sw != null) 
                sw.Close();

            }
        }

        #endregion
    }
}
