using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;
using System.Diagnostics;
using AutoSports.OVRCommon;

using AutoSports.OVRDrawModel;

namespace AutoSports.OVRDrawArrange
{
    class AxOVRDrawModelHelper
    {
        public String m_strLanguageCode = "CHN";
        public SqlConnection m_DatabaseConnection { get; set; }
        
	    //将创建好的单一赛事模型插入数据库，返回该模型PhaseID， <0 表示插入失败
	    public Int32 CreateSingleDrawModel(Int32 nEventId, Int32 nFatherPhaseId, 
		    AxDrawModelInfo drawInfo, AxDrawModelMatchList modelModel, 
		    List<AxDrawModelPlayerFrom> pAryPlayerFrom, Int32 nMatchOffSet)
        {
            nFatherPhaseId = nFatherPhaseId == -1 ? 0 : nFatherPhaseId;

            if (nEventId <= 0 || nFatherPhaseId < 0)
            {
                Debug.Assert(false);
                return -1;
            }

            if (nMatchOffSet == -1) //如果给的默认值的话,自己取一个最大值

            {
                nMatchOffSet = GetMatchNumMax(nEventId);
            }

            if (nMatchOffSet < 0)
            {
                Debug.Assert(false);
                return -1;
            }

            if (drawInfo.m_eType == EDrawModelType.emTypeManual)
            {
                return _CreateSimplePhase(nEventId, nFatherPhaseId, drawInfo, nMatchOffSet);
            }
            else
                if (drawInfo.m_eType == EDrawModelType.emTypeKonckOut)
                {
                    return _CreateDrawKnockOut(nEventId, nFatherPhaseId, drawInfo, nMatchOffSet, modelModel, pAryPlayerFrom);
                }
                else
                    if (drawInfo.m_eType == EDrawModelType.emTypeRoundRobin)
                    {
                        return _CreateDrawRoundRobin(nEventId, nFatherPhaseId, drawInfo, nMatchOffSet, modelModel, pAryPlayerFrom);
                    }
                    else
                    {
                        Debug.Assert(false);
                        return -1;
                    }
        }

	    //利用EventInfo,在数据中创建整个Event
	    public Boolean CreteDrawEvent(Int32 nEventId, AxDrawModelEvent modelEvent)
        {
            if (nEventId <= 0)
            {
                Debug.Assert(false);
                return false;
            }

            Int32 nMatchOffSet = GetMatchNumMax(nEventId);

            if (nMatchOffSet < 0)
            {
                Debug.Assert(false);
                return false;
            }

            modelEvent.m_nTempEventID = nEventId;

            //循环阶段
            for (Int32 nStage = 0; nStage < modelEvent.GetStageCnt(); nStage++)
            {
                AxDrawModelStage pModelStage = modelEvent.GetStageObj(nStage);

                //先处理本阶段的Model来源问题,除了第一阶段
                if (nStage > 0)
                {
                    for (Int32 nModel = 0; nModel < pModelStage.GetModelCnt(); nModel++)
                    {
                        AxDrawModelModelExport pModelExp = pModelStage.GetModelExpObj(nModel);
                        modelEvent.FillPlayerInfo(pModelExp.m_aryPlayerFrom);
                    }
                }

                //这个阶段如有只有一场比赛,那么就没有阶段名了

                if (pModelStage.GetModelCnt() == 1)
                {
                    //插入这唯一一个Model
                    AxDrawModelModelExport pModelExport = pModelStage.GetModelExpObj(0);
                    pModelExport.m_nTempModelID = CreateSingleDrawModel(modelEvent.m_nTempEventID, 0,
                        pModelExport.m_drawInfo, pModelExport.m_matchList, pModelExport.m_aryPlayerFrom, nMatchOffSet);
                    if (pModelExport.m_nTempModelID <= 0)
                    {
                        Debug.Assert(false);
                        return false;
                    }
                }
                else
                {
                    //插入阶段
                    pModelStage.m_nTempStageID = AddPhase(modelEvent.m_nTempEventID, 0, 0, 0, (Int32)EDrawModelType.emTypeManual, 0, 0, 0, "由Event向导创建的阶段",
                                                    pModelStage.m_strStageName, pModelStage.m_strStageName, "");
                    if (pModelStage.m_nTempStageID <= 0)
                    {
                        Debug.Assert(false);
                        return false;
                    }

                    //循环该阶段的每个模型
                    for (Int32 nModel = 0; nModel < pModelStage.GetModelCnt(); nModel++)
                    {
                        AxDrawModelModelExport pModelExport = pModelStage.GetModelExpObj(nModel);

                        pModelExport.m_nTempModelID = CreateSingleDrawModel(modelEvent.m_nTempEventID, pModelStage.m_nTempStageID,
                                                            pModelExport.m_drawInfo, pModelExport.m_matchList, pModelExport.m_aryPlayerFrom, nMatchOffSet);
                        if (pModelExport.m_nTempModelID <= 0)
                        {
                            return false;
                        }
                    }
                }

            }

            //最后处理Event排名问题
            modelEvent.FillPlayerInfo(modelEvent.m_aryEventRank);
            for (Int32 nCyc = 0; nCyc < (Int32)modelEvent.m_aryEventRank.Count; nCyc++) //循环每个人,填入数据库
            {
                AxDrawModelPlayerFrom pPlayerFrom = modelEvent.m_aryEventRank[nCyc];

                if ( !AddEventResultWithDetail( modelEvent.m_nTempEventID, nCyc+1, pPlayerFrom.m_nTempFromModelID, pPlayerFrom.m_byResultRank, 0, 0 ) )                
                {
                    Debug.Assert(false);
                    return false;
                }
            }

            return true;
        }

	    //创建细项，返回数据库的PhaseID值 ,对于nMatchOffset,程序会在此数值的后一个开始插入,返回最后一个成功插入的
	    protected Int32 _CreateSimplePhase(Int32 nEventID, Int32 nPhaseID, AxDrawModelInfo drawInfo, Int32 nMatchOffSet)
        {
            Int32 nPhaseIdDraw = AddPhase(nEventID, nPhaseID, (Int32)EDrawModelLayerCode.emLayerDraw, 0, (Int32)EDrawModelType.emTypeManual, 0, 0,
                                          0, "手工Phase", drawInfo.m_strTitle, drawInfo.m_strTitle, "");

            return nPhaseIdDraw;
        }

        protected Int32 _CreateDrawKnockOut(Int32 nEventID, Int32 nPhaseID, AxDrawModelInfo drawInfo, Int32 nMatchOffSet, AxDrawModelMatchList modelModel, List<AxDrawModelPlayerFrom> pAryPlayerFrom)
        {
            if (nEventID <= 0 || nPhaseID < 0 || modelModel.m_aryMatchRow.Count <= 0)
            {
                return -1;
            }

            // 1. 先插入整个Draw
            Int32 nQual;
            if (drawInfo.m_bQual)
                nQual = 1;
            else
                nQual = 0;

            Int32 nPhaseIdDraw = AddPhase(nEventID, nPhaseID, (Int32)EDrawModelLayerCode.emLayerDraw, 0, (Int32)EDrawModelType.emTypeKonckOut,
                drawInfo.m_nSize, drawInfo.m_nRank,
                nQual, "赛事模型-淘汰赛", drawInfo.m_strTitle, drawInfo.m_strTitle, "");
            if (nPhaseIdDraw < 1)
            {
                Debug.Assert(false);
                return -1;
            }

            // 2. 再插入签位表
            int nPlayerCnt = (Int32)Math.Pow(2, drawInfo.m_nSize);
            for (Int32 nCycPlayer = 0; nCycPlayer < nPlayerCnt; nCycPlayer++)
            {
                int nPlayerFromPhaseID = 0;
                int nPlayerFromPhaseRank = 0;

                if ( nCycPlayer < pAryPlayerFrom.Count )
                {
                    nPlayerFromPhaseID = pAryPlayerFrom[nCycPlayer].m_nTempFromModelID;
                    nPlayerFromPhaseRank = pAryPlayerFrom[nCycPlayer].m_byResultRank;
                }

                if ( !AddPhasePosition(nPhaseIdDraw, nCycPlayer+1, 0, 0, nPlayerFromPhaseID, nPlayerFromPhaseRank, 0, 0) )
                {
                    Debug.Assert(false);
                    return -1;
                }
            }

            Int32 nRound = -1;		    //碰到不同的轮序号,就建立新轮次
            Int32 nMatchOrder = 1;		//这场比赛在此轮中试第几场
            Int32 nCurRoundID = -1;	    //每场比赛所属轮次在数据库的ID

            for (Int32 nCycRow = 0; nCycRow < modelModel.m_aryMatchRow.Count; nCycRow++) //循环每场比赛
            {
                AxDrawModelMatchRow pMatchRow = modelModel.m_aryMatchRow[nCycRow];

                //轮次变了,建立新轮,并且之后比赛插入此轮次

                if (pMatchRow.m_byteRoundOrder != nRound)
                {
                    nRound = pMatchRow.m_byteRoundOrder;
                    nMatchOrder = 1;

                    String strRoundInfo;
                    strRoundInfo = String.Format("轮次-淘汰赛-第{0:D}轮-{1}", nRound, pMatchRow.GetRoundDesc());
                    Int32 nRetRound = AddPhase(nEventID, nPhaseIdDraw, (Int32)pMatchRow.m_emLayerCode, 1, (Int32)EDrawModelType.emTypeKnockOutRound, 0, 0, 0, strRoundInfo,
                        pMatchRow.GetRoundDesc(), pMatchRow.GetRoundDesc(), "");

                    if (nRetRound < 1)
                    {
                        Debug.Assert(false);
                        return -1;
                    }

                    nCurRoundID = nRetRound;
                }

                int nMatchStartPosA = 0;
                int nMatchFromIdA = 0;
                int nMatchFromRankA = 0;
                int nPhaseFromIdA = 0;
                int nPhaseFromRankA = 0;
                if (pMatchRow.m_eLeftFromKind == EKnockOutFromKind.emKoFromInit)
                {
                    nMatchStartPosA = pMatchRow.m_nLeftFromLineOrIndex + 1;
                }
                else if (pMatchRow.m_eLeftFromKind == EKnockOutFromKind.emKoFromWin)
                {
                    nMatchFromIdA = modelModel.m_aryMatchRow[pMatchRow.m_nLeftFromLineOrIndex].m_nTempMatchID;
                    nMatchFromRankA = (Int32)EMatchResult.emResultWin;
                }
                else if (pMatchRow.m_eLeftFromKind == EKnockOutFromKind.emKoFromLost)
                {
                    nMatchFromIdA = modelModel.m_aryMatchRow[pMatchRow.m_nLeftFromLineOrIndex].m_nTempMatchID;
                    nMatchFromRankA = (Int32)EMatchResult.emResultLost;
                }
                else
                {
                    Debug.Assert(false);
                    return -1;
                }

                int nMatchStartPosB = 0;
                int nMatchFromIdB = 0;
                int nMatchFromRankB = 0;
                int nPhaseFromIdB = 0;
                int nPhaseFromRankB = 0;
                if (pMatchRow.m_eRightFromKind == EKnockOutFromKind.emKoFromInit)
                {
                    nMatchStartPosB = pMatchRow.m_nRightFromLineOrIndex + 1;
                }
                else if (pMatchRow.m_eRightFromKind == EKnockOutFromKind.emKoFromWin)
                {
                    nMatchFromIdB = modelModel.m_aryMatchRow[pMatchRow.m_nRightFromLineOrIndex].m_nTempMatchID;
                    nMatchFromRankB = (Int32)EMatchResult.emResultWin;
                }
                else if (pMatchRow.m_eRightFromKind == EKnockOutFromKind.emKoFromLost)
                {
                    nMatchFromIdB = modelModel.m_aryMatchRow[pMatchRow.m_nRightFromLineOrIndex].m_nTempMatchID;
                    nMatchFromRankB = (Int32)EMatchResult.emResultLost;
                }
                else
                {
                    return -1;
                }

                String strMatchName = String.Format("Match {0:D}", nMatchOrder);
                String strMatchInfo = String.Format("比赛-淘汰赛-第{0:D}轮-第{1:D}场", nRound, nMatchOrder);

                int nRetMatchID = AddMatch(nCurRoundID, 0, strMatchInfo, strMatchName, strMatchName, strMatchInfo,
                    1, 0, nPhaseIdDraw, nMatchStartPosA, nPhaseFromIdA, nPhaseFromRankA, nMatchFromIdA, nMatchFromRankA, 0, 0, 0, 0,
                    2, 0, nPhaseIdDraw, nMatchStartPosB, nPhaseFromIdB, nPhaseFromRankB, nMatchFromIdB, nMatchFromRankB, 0, 0, 0, 0, (Int32)(nMatchOffSet + pMatchRow.m_dwMatchNum), 0);
                if (nRetMatchID < 1)
                {
                    return -1;
                }

                pMatchRow.m_nTempMatchID = nRetMatchID;

                //如果这场比赛的结果将导致名次
                if ( pMatchRow.m_eWinGotoKind == EKnockOutJumpKind.emkoJumpRank )
                {
                    if ( !AddPhaseResultWithDetail(nPhaseIdDraw, pMatchRow.m_byWinGotoLineOrRank, 0, 0, nRetMatchID, (Int32)EMatchResult.emResultWin) )
                    {
                        Debug.Assert(false);
                        return -1;
                    }
                }

                if ( pMatchRow.m_eLostGotoKind == EKnockOutJumpKind.emkoJumpRank )
                {
                    if ( !AddPhaseResultWithDetail(nPhaseIdDraw, pMatchRow.m_byLostGotoLineOrRank, 0, 0, nRetMatchID, (Int32)EMatchResult.emResultLost) )
                    {
                        Debug.Assert(false);
                        return -1;
                    }
                }

                nMatchOrder++;
            }

            return nPhaseIdDraw;
        }

	    protected Int32 _CreateDrawRoundRobin(Int32 nEventID, Int32 nPhaseID, AxDrawModelInfo drawInfo, Int32 nMatchOffSet, AxDrawModelMatchList modelModel, List<AxDrawModelPlayerFrom> pAryPlayerFrom)
        {
            if (nEventID <= 0 || nPhaseID < 0 || modelModel.m_aryMatchRow.Count <= 0)
            {
                Debug.Assert(false);
                return -1;
            }

            // 1. 先插入整个Draw的Phase
            Int32 nQual = drawInfo.m_bQual ? 1 : 0;

            Int32 nPhaseIdDraw = AddPhase(nEventID, nPhaseID, (Int32)EDrawModelLayerCode.emLayerDraw, 0, (Int32)EDrawModelType.emTypeRoundRobin,
                drawInfo.m_nSize, drawInfo.m_nRank,
                nQual, "赛事模型-循环赛", drawInfo.m_strTitle, drawInfo.m_strTitle, "");
            if (nPhaseIdDraw < 1)
            {
                Debug.Assert(false);
                return -1;
            }

            Boolean bHaveBye = (drawInfo.m_nSize % 2 != 0) ? true : false;

            //如果有轮空,那么先插入轮空位,Pos为1,且对应RegID-1,不能再被修改
            if (bHaveBye) //目前用总人数%2的方法判断是否存在轮空
            {
                if ( !AddPhasePosition(nPhaseIdDraw, -1, 0, 0, 0, 0, 0, 0) )
                {
                    Debug.Assert(false);
                    return -1;
                }
            }

            //有轮空情况,从2开始,没有从1开始
            Int32 byPosOffset = bHaveBye ? 2 : 1;
            for (Int32 nCycPlayer = 0; nCycPlayer < drawInfo.m_nSize; nCycPlayer++)
            {
                Int32 nSourcePhaseID = 0;
                Int32 nSourcePhaseRank = 0;

                //根据参数,确认跨Model的来源表
                if (pAryPlayerFrom.Count > 0 && nCycPlayer < pAryPlayerFrom.Count)
                {
                    nSourcePhaseID = pAryPlayerFrom[nCycPlayer].m_nTempFromModelID;
                    nSourcePhaseRank = pAryPlayerFrom[nCycPlayer].m_byResultRank;
                }

                if ( !AddPhasePosition(nPhaseIdDraw, nCycPlayer + byPosOffset, 0, 0, nSourcePhaseID, nSourcePhaseRank, 0, 0) )
                {
                    Debug.Assert(false);
                    return -1;
                }
            }
            
            // 3. 插入每场比赛
            Int32 byRound = -1;			//碰到不同的轮序号,就建立新轮次
            Int32 nCurRoundID = -1;		//目前轮次在数据库的ID

            //循环每场比赛
            for (Int32 nCycRow = 0; nCycRow < modelModel.m_aryMatchRow.Count; nCycRow++)
            {
                AxDrawModelMatchRow pMatchRow = (AxDrawModelMatchRow)modelModel.m_aryMatchRow[nCycRow];

                ////轮次变了,建立新轮,并且之后比赛插入此轮次
                //if (Convert.ToInt32(pMatchRow.m_byteRoundOrder) != byRound)
                //{
                //    byRound = Convert.ToInt32(pMatchRow.m_byteRoundOrder);

                //    String strRoundName;
                //    strRoundName = String.Format("Round{0:D}", Convert.ToInt32(pMatchRow.m_byteRoundOrder));

                //    String strRoundInfo;
                //    strRoundInfo = String.Format("循环赛-{0}-Round{1}", drawInfo.m_strTitle, Convert.ToInt32(pMatchRow.m_byteRoundOrder));

                //    int nRetRound = AddPhase(nEventID, nPhaseIdDraw, Convert.ToInt32(pMatchRow.m_emLayerCode), 1, Convert.ToInt32(EDrawModelType.emTypeRoundRobinRound), 0, 0, 0, strRoundInfo,
                //        strRoundName, strRoundName, strRoundInfo);

                //    if (nRetRound < 1)
                //    {
                //        Debug.Assert(false);
                //        return -1;
                //    }

                //    nCurRoundID = nRetRound;
                //}

                //为了兼容有轮空的情况,轮空算作1
                Int32 byPlayerL = bHaveBye ? pMatchRow.m_nLeftFromLineOrIndex + 1 : pMatchRow.m_nLeftFromLineOrIndex;
                Int32 byPlayerR = bHaveBye ? pMatchRow.m_nRightFromLineOrIndex + 1 : pMatchRow.m_nRightFromLineOrIndex;

                Int32 nRegIdA = 0;
                Int32 nRegIdB = 0;

                if (bHaveBye && byPlayerL == 1) nRegIdA = -1;
                if (bHaveBye && byPlayerR == 1) nRegIdB = -1;

                String strMatchInfo;
                strMatchInfo = String.Format("循环赛-{0}-第{1:D}轮-第{2:D}场", drawInfo.m_strTitle, Convert.ToInt32(pMatchRow.m_byteRoundOrder), Convert.ToInt32(pMatchRow.m_byteRoundOrder));
                String strMatchName;
                strMatchName = String.Format("Match {0:D}", nCycRow + 1);

                int nRetMatchID = AddMatch(nPhaseIdDraw, 0, strMatchInfo, strMatchName, strMatchName, "",
                    1, nRegIdA, nPhaseIdDraw, byPlayerL, 0, 0, 0, 0, 0, 0, 0, 0,
                    2, nRegIdB, nPhaseIdDraw, byPlayerR, 0, 0, 0, 0, 0, 0, 0, 0,
                    Convert.ToInt32(nMatchOffSet + pMatchRow.m_dwMatchNum), nCycRow + 1);
                if (nRetMatchID < 1)
                {
                    return -1;
                }

                pMatchRow.m_nTempMatchID = nRetMatchID;
            }

            //插入名次输出信息,循环赛结果的产生,只能靠程序后期判断
            for (int nCycPlayer = 0; nCycPlayer < drawInfo.m_nRank; nCycPlayer++ )
            {
                if ( !AddPhaseResultWithDetail(nPhaseIdDraw, nCycPlayer+1, 0, 0, 0, 0) )
                {
                    Debug.Assert(false);
                    return -1;
                }
            }

            return nPhaseIdDraw;
        }

	    //为了方便取消,再封装一下

	    protected Boolean BeginTrans()
        {
            return true;
        }

	    protected Boolean CommitTrans()
        {
            return true;
        }

	    protected Boolean RollbackTrans()
        {
            return true;
        }

	    //返回插入成功的Phase的ID,这个Phase可能是阶段,模型,轮

	    protected Int32 AddPhase(Int32 nEventID, Int32 nFatherPhaseID, Int32 nPhaseCode, Int32 nPhaseNodeType, Int32 nPhaseType,
		    Int32 nPhaseSize, Int32 nPhaseRankSize, Int32 nPhaseIsQual, String strPhaseInfo,
		    String strPhaseNameLong, String strPhaseNameShort, String strPhaseComment)
        {
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_AddPhase";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nEventID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@FatherPhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nFatherPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@PhaseCode", SqlDbType.NVarChar, 10,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, nPhaseCode.ToString());
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@OpenDate", SqlDbType.NVarChar, 10,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@CloseDate", SqlDbType.NVarChar, 10,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                            "@PhaseStatusID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameter7 = new SqlParameter(
                            "@PhaseNodeType", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseRankSize);
                oneSqlCommand.Parameters.Add(cmdParameter7);

                SqlParameter cmdParameter8 = new SqlParameter(
                            "@Order", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter8);

                SqlParameter cmdParameter9 = new SqlParameter(
                            "@PhaseType", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseType);
                oneSqlCommand.Parameters.Add(cmdParameter9);

                SqlParameter cmdParameter10 = new SqlParameter(
                             "@PhaseSize", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, nPhaseSize);
                oneSqlCommand.Parameters.Add(cmdParameter10);

                SqlParameter cmdParameter11 = new SqlParameter(
                             "@PhaseRankSize", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, nPhaseRankSize);
                oneSqlCommand.Parameters.Add(cmdParameter11);

                SqlParameter cmdParameter12 = new SqlParameter(
                             "@PhaseIsQual", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, nPhaseIsQual);
                oneSqlCommand.Parameters.Add(cmdParameter12);

                SqlParameter cmdParameter13 = new SqlParameter(
                             "@PhaseInfo", SqlDbType.NVarChar, 50,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, strPhaseInfo);
                oneSqlCommand.Parameters.Add(cmdParameter13);

                SqlParameter cmdParameter14 = new SqlParameter(
                             "@languageCode", SqlDbType.Char, 3,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, m_strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter14);

                SqlParameter cmdParameter15 = new SqlParameter(
                             "@PhaseLongName", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, strPhaseNameLong);
                oneSqlCommand.Parameters.Add(cmdParameter15);

                SqlParameter cmdParameter16 = new SqlParameter(
                             "@PhaseShortName", SqlDbType.NVarChar, 50,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, strPhaseNameShort);
                oneSqlCommand.Parameters.Add(cmdParameter16);

                SqlParameter cmdParameter17 = new SqlParameter(
                             "@PhaseComment", SqlDbType.NVarChar, 100,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, strPhaseComment);
                oneSqlCommand.Parameters.Add(cmdParameter17);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    Int32 nNewPhaseID = iOperateResult;
                    switch (iOperateResult)
                    {
                        case 0:
                            //DevComponents.DotNetBar.MessageBoxEx.Show("添加失败!");
                            nNewPhaseID = - 1;
                            break;
                        case -1:
                            //DevComponents.DotNetBar.MessageBoxEx.Show("添加Phase失败，@EventID无效、@FatherPhaseID无效!");
                            nNewPhaseID = - 1;
                            break;
                        case -2:
                            //DevComponents.DotNetBar.MessageBoxEx.Show("添加Phase失败，该节点的状态不允许添加Phase!");
                            nNewPhaseID = -2;
                            break;
                        default://其余的需要为添加成功！
                            break;
                    }
                    return nNewPhaseID;
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return -1;
        }



	    //出入一个Match,返回插入成功的MatchID
	    protected Int32 AddMatch(
		    Int32 nPhaseID, //父节点,应该是轮次Phase
		    Int32 MatchType, //单项使用
		    String strMatchInfo, String strMatchNameLong,
		    String strMatchNameShort,  String strMatchComment,
		    Int32 nPosA,			    //左边选手,右边选手,1,2
		    Int32 nRegIdA,		        //选手ID, -1轮空,
		    Int32 nPhaseStartIdA,       //整个Draw节点ID
		    Int32 nPhaseStartPosA,      //Stage节点中签位序号

		    Int32 nPhaseSourceIdA,      //选手来源,跨Draw的,是哪个Phase,类型肯定是一个Draw
		    Int32 nPhaseSourceRankA,    //跨Draw来源表中序号
		    Int32 nMatchSourceIdA,	    //在本Draw中的来源,必须是个Match类型
		    Int32 nMatchSourceRankA,	//来源是胜方还是败方 1:胜利, 2:失败, 在KnockOut中使用

		    Int32 nResultA,			
		    Int32 nRankA, 
		    Int32 nPointA, 
		    Int32 nServiceA,
		    Int32 nPosB, Int32 nRegIdB, Int32 nPhaseStartIdB, Int32 nPhaseStartPosB, Int32 nPhaseSourceIdB, 
		    Int32 nPhaseSourceRankB, Int32 nMatchSourceIdB, Int32 nMatchSourceRankB, Int32 nResultB, Int32 nRankB, Int32 nPointB, Int32 nServiceB,
		    Int32 nMatchNum,	//比赛序号
		    Int32 nOrder	//这场比赛的序号,默认自动递增
	    )
        {
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "proc_AddMatchWithCompetitors";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@MatchStatusID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@VenueID", SqlDbType.NVarChar, 10,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                             "@CourtID", SqlDbType.NVarChar, 50,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                             "@WeatherID", SqlDbType.NVarChar, 50,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                            "@SessionID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameter7 = new SqlParameter(
                             "@MatchDate", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter7);

                SqlParameter cmdParameter8 = new SqlParameter(
                             "@StartTime", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter8);

                SqlParameter cmdParameter9 = new SqlParameter(
                             "@EndTime", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter9);

                SqlParameter cmdParameter10 = new SqlParameter(
                            "@SpendTime", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter10);

                SqlParameter cmdParameter11 = new SqlParameter(
                            "@Order", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nOrder);
                oneSqlCommand.Parameters.Add(cmdParameter11);

                SqlParameter cmdParameter12 = new SqlParameter(
                            "@MatchType", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, MatchType);
                oneSqlCommand.Parameters.Add(cmdParameter12);

                SqlParameter cmdParameter13 = new SqlParameter(
                             "@MatchInfo", SqlDbType.NVarChar, 10,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, strMatchInfo);
                oneSqlCommand.Parameters.Add(cmdParameter13);

                SqlParameter cmdParameter14 = new SqlParameter(
                             "@languageCode", SqlDbType.NVarChar, 10,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, m_strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter14);

                SqlParameter cmdParameter15 = new SqlParameter(
                             "@MatchLongName", SqlDbType.NVarChar, 10,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, strMatchNameLong);
                oneSqlCommand.Parameters.Add(cmdParameter15);

                SqlParameter cmdParameter16 = new SqlParameter(
                             "@MatchShortName", SqlDbType.NVarChar, 10,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, strMatchNameShort);
                oneSqlCommand.Parameters.Add(cmdParameter16);

                SqlParameter cmdParameter17 = new SqlParameter(
                             "@MatchComment", SqlDbType.NVarChar, 10,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, strMatchComment);
                oneSqlCommand.Parameters.Add(cmdParameter17);

                SqlParameter cmdParameter18 = new SqlParameter(
                            "@APosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPosA);
                if(nPosA == 0)
                {
                    cmdParameter18.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter18);

                SqlParameter cmdParameter19 = new SqlParameter(
                            "@ARegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nRegIdA);
                if (nRegIdA == 0)
                {
                    cmdParameter19.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter19);

                SqlParameter cmdParameter20 = new SqlParameter(
                            "@AStartPhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseStartIdA);
                if (nPhaseStartIdA == 0)
                {
                    cmdParameter20.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter20);

                SqlParameter cmdParameter21 = new SqlParameter(
                            "@AStartPhasePosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseStartPosA);
                if (nPhaseStartPosA == 0)
                {
                    cmdParameter21.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter21);

                SqlParameter cmdParameter22 = new SqlParameter(
                            "@ASourcePhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseSourceIdA);
                if (nPhaseSourceIdA == 0)
                {
                    cmdParameter22.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter22);

                SqlParameter cmdParameter23 = new SqlParameter(
                            "@ASourcePhaseRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseSourceRankA);
                if (nPhaseSourceRankA == 0)
                {
                    cmdParameter23.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter23);

                SqlParameter cmdParameter24 = new SqlParameter(
                            "@ASourceMatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchSourceIdA);
                if (nMatchSourceIdA == 0)
                {
                    cmdParameter24.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter24);

                SqlParameter cmdParameter25 = new SqlParameter(
                            "@ASourceMatchRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchSourceRankA);
                if (nMatchSourceRankA == 0)
                {
                    cmdParameter25.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter25);

                SqlParameter cmdParameter26 = new SqlParameter(
                            "@AResult", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nResultA);
                if (nResultA == 0)
                {
                    cmdParameter26.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter26);

                SqlParameter cmdParameter27 = new SqlParameter(
                            "@ARank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nRankA);
                if (nRankA == 0)
                {
                    cmdParameter27.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter27);

                SqlParameter cmdParameter28 = new SqlParameter(
                            "@APoints", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPointA);
                if (nPointA == 0)
                {
                    cmdParameter28.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter28);

                SqlParameter cmdParameter29 = new SqlParameter(
                            "@AService", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nServiceA);
                if (nServiceA == 0)
                {
                    cmdParameter29.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter29);

                SqlParameter cmdParameter30 = new SqlParameter(
                            "@BPosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPosB);
                if (nPosB == 0)
                {
                    cmdParameter30.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter30);

                SqlParameter cmdParameter31 = new SqlParameter(
                            "@BRegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nRegIdB);
                if (nRegIdB == 0)
                {
                    cmdParameter31.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter31);

                SqlParameter cmdParameter32 = new SqlParameter(
                            "@BStartPhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseStartIdB);
                if (nPhaseStartIdB == 0)
                {
                    cmdParameter32.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter32);

                SqlParameter cmdParameter33 = new SqlParameter(
                            "@BStartPhasePosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseStartPosB);
                if (nPhaseStartPosB == 0)
                {
                    cmdParameter33.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter33);

                SqlParameter cmdParameter34 = new SqlParameter(
                            "@BSourcePhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseSourceIdB);
                if (nPhaseSourceIdB == 0)
                {
                    cmdParameter34.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter34);

                SqlParameter cmdParameter35 = new SqlParameter(
                            "@BSourcePhaseRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseSourceRankB);
                if (nPhaseSourceRankB == 0)
                {
                    cmdParameter35.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter35);

                SqlParameter cmdParameter36 = new SqlParameter(
                            "@BSourceMatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchSourceIdB);
                if (nMatchSourceIdB == 0)
                {
                    cmdParameter36.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter36);

                SqlParameter cmdParameter37 = new SqlParameter(
                            "@BSourceMatchRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchSourceRankB);
                if (nMatchSourceRankB == 0)
                {
                    cmdParameter37.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter37);

                SqlParameter cmdParameter38 = new SqlParameter(
                            "@BResult", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nResultB);
                if (nResultB == 0)
                {
                    cmdParameter38.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter38);

                SqlParameter cmdParameter39 = new SqlParameter(
                            "@BRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nRankB);
                if (nRankB == 0)
                {
                    cmdParameter39.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter39);

                SqlParameter cmdParameter40 = new SqlParameter(
                            "@BPoints", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPointB);
                if (nPointB == 0)
                {
                    cmdParameter40.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter40);

                SqlParameter cmdParameter41 = new SqlParameter(
                            "@BService", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nServiceB);
                if (nServiceB == 0)
                {
                    cmdParameter41.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter41);

                SqlParameter cmdParameter42 = new SqlParameter(
                            "@MatchNum", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchNum);
                oneSqlCommand.Parameters.Add(cmdParameter42);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    Int32 nNewMatchID = iOperateResult;
                    switch (iOperateResult)
                    {
                        case 0:
                            //DevComponents.DotNetBar.MessageBoxEx.Show("添加失败!");
                            nNewMatchID = -1;
                            break;
                        case -1:
                            //DevComponents.DotNetBar.MessageBoxEx.Show("添加Phase失败，@PhaseID无效!");
                            nNewMatchID = -1;
                            break;
                        default://其余的需要为添加成功！
                            break;
                    }
                    return nNewMatchID;
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return -1;
        }

	    //对于淘汰赛,一场比赛的输赢将产生名次,这个信息由另外的表维护

	    protected Int32 AddMatchRankToPhaseRank(
            Int32 nMatchID,	//这场比赛的ID
            Int32 nMatchRank, //比赛输赢选手
            Int32 nPhaseID,	//属于那个Phase
            Int32 nPhaseRank	//排名
	    )
        {
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "proc_AddMatchRank2PhaseRank";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@MatchRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nMatchRank);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@PhaseRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseRank);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    Int32 nResult;
                    switch (iOperateResult)
                    {
                        case 0:
                            //DevComponents.DotNetBar.MessageBoxEx.Show("添加失败，@MatchID、@PhaseID无效");
                            nResult = -1;
                            break;
                        case -1:
                            //DevComponents.DotNetBar.MessageBoxEx.Show("添加失败，一场比赛的同一名次在指定Phase中的排名应该是唯一的，不允许重复添加");
                            nResult = -1;
                            break;
                        default://其余的需要为添加成功！
                            nResult = 1;
                            break;
                    }
                    return nResult;
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return -1;
        }

        //一个Event最后的排名,来自他所属的某个Phase的排名或Match的排名

        protected Boolean AddEventResultWithDetail(
            Int32 nEventID,
            Int32 nEventRank,
            Int32 nSourcePhaseID,
            Int32 nSourcePhaseRank,
            Int32 nSourceMatchID,
            Int32 nSourceMatchRank
            )
        {
            if (nEventID < 1 || nEventRank < 1 )
            {
                return false;
            }

            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_AddEventResultWithDetail";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nEventID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@EventRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nEventRank);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@SourcePhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nSourcePhaseID);
                if (nSourcePhaseID == 0)
                {
                    cmdParameter3.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@SourcePhaseRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nSourcePhaseRank);
                if (nSourcePhaseRank == 0)
                {
                    cmdParameter4.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@SourceMatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nSourceMatchID);
                if (nSourceMatchID == 0)
                {
                    cmdParameter5.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                            "@SourceMatchRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nSourceMatchRank);
                if (nSourceMatchRank == 0)
                {
                    cmdParameter6.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    Boolean bResult;
                    switch (iOperateResult)
                    {
                        case 0:
                            bResult = false;
                            break;
                        case -1:
                            bResult = false;
                            break;
                        default://其余的需要为添加成功！
                            bResult = true;
                            break;
                    }
                    return bResult;
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return false;
        }

        //一个Phase最后的排名,来自他所属的某个Phase的排名或Match的排名
        protected Boolean AddPhaseResultWithDetail(
            Int32 nPhaseID,
            Int32 nPhaseRank,
            Int32 nSourcePhaseID,
            Int32 nSourcePhaseRank,
            Int32 nSourceMatchID,
            Int32 nSourceMatchRank
            )
        {
            if (nPhaseID < 1 || nPhaseRank < 1)
            {
                return false;
            }

            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_AddPhaseResultWithDetail";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PhaseRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseRank);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@SourcePhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nSourcePhaseID);
                if (nSourcePhaseID == 0)
                {
                    cmdParameter3.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@SourcePhaseRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nSourcePhaseRank);
                if (nSourcePhaseRank == 0)
                {
                    cmdParameter4.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@SourceMatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nSourceMatchID);
                if (nSourceMatchID == 0)
                {
                    cmdParameter5.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                            "@SourceMatchRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nSourceMatchRank);
                if (nSourceMatchRank == 0)
                {
                    cmdParameter6.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    Boolean bResult;
                    switch (iOperateResult)
                    {
                        case 0:
                            bResult = false;
                            break;
                        case -1:
                            bResult = false;
                            break;
                        default://其余的需要为添加成功！
                            bResult = true;
                            break;
                    }
                    return bResult;
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return false;
        }

        //一个Phase的签位信息，来自初始Phase的签位信息或他所属的某个Phase的排名或Match的排名
        protected Boolean AddPhasePosition(
            Int32 nPhaseID,
            Int32 nPhasePosition,
            Int32 nStartPhaseID,
            Int32 nStartPhasePosition,
            Int32 nSourcePhaseID,
            Int32 nSourcePhaseRank,
            Int32 nSourceMatchID,
            Int32 nSourceMatchRank
            )
        {
            if ( nPhaseID < 1 || nPhasePosition < -1 || nPhasePosition == 0 )
            {
                Debug.Assert(false);
                return false;
            }

            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "proc_AddPhasePosition";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PhasePosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhasePosition);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@StartPhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nStartPhaseID);
                if (nStartPhaseID == 0)
                {
                    cmdParameter3.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@StartPhasePosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nStartPhasePosition);
                if (nStartPhasePosition == 0)
                {
                    cmdParameter4.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@SourcePhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nSourcePhaseID);
                if (nSourcePhaseID == 0)
                {
                    cmdParameter5.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter5);

                SqlParameter cmdParameter6 = new SqlParameter(
                            "@SourcePhaseRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nSourcePhaseRank);
                if (nSourcePhaseRank == 0)
                {
                    cmdParameter6.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter6);

                SqlParameter cmdParameter7 = new SqlParameter(
                            "@SourceMatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nSourceMatchID);
                if (nSourceMatchID == 0)
                {
                    cmdParameter7.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter7);

                SqlParameter cmdParameter8 = new SqlParameter(
                            "@SourceMatchRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nSourceMatchRank);
                if (nSourceMatchRank == 0)
                {
                    cmdParameter8.Value = DBNull.Value;
                }
                oneSqlCommand.Parameters.Add(cmdParameter8);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    Boolean bResult;
                    switch (iOperateResult)
                    {
                        case 0:
                            bResult = false;
                            break;
                        default://其余的需要为添加成功！
                            bResult = true;
                            break;
                    }
                    return bResult;
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return false;
        }


	    //一个Event最后的排名,来自他所属的某个Phase的排名

	    protected Boolean AddPhaseRankToEventRank(
            Int32 nPhaseID,	//所属PhaseID
            Int32 nPhaseRank, //Phase上的排名
            Int32 nEventID,	//对应于哪个Event
            Int32 nEventRank	//对应于那个Event的排名

	    )
        {
            if (nPhaseID < 1 || nPhaseRank < 1 || nEventID < 1 || nEventRank < 1)
            {
                return false;
            }

            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "proc_AddPhaseRank2EventRank";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PhaseRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nPhaseRank);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nEventID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@EventRank", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nEventRank);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameterResult.Value;
                    Boolean bResult;
                    switch (iOperateResult)
                    {
                        case 0:
                            //DevComponents.DotNetBar.MessageBoxEx.Show("添加失败");
                            bResult = false;
                            break;
                        case -1:
                            //DevComponents.DotNetBar.MessageBoxEx.Show("添加失败，@MatchID、@PhaseID无效");
                            bResult = false;
                            break;
                        case 1:
                            //DevComponents.DotNetBar.MessageBoxEx.Show("");
                            bResult = true;
                            break;
                        default://其余的需要为添加成功！
                            bResult = false;
                            break;
                    }
                    return bResult;
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return false;
        }

	    //获取目前数据库此Event中最大的MatchNum,
	    //在插入Match时,有一个MatchNum,需要累积增大

	    //0以上表示成功,0和0以下表示失败
        protected Int32 GetMatchNumMax(Int32 nEventID)
        {
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "proc_GetMatchNumMax";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, nEventID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    if (cmdParameterResult.Value is DBNull)
                    {
                        iOperateResult = 0;
                    }
                    else
                    {
                        iOperateResult = Convert.ToInt32(cmdParameterResult.Value);
                    }
                    // 小于0失败,大于等于0成功
                    return iOperateResult;
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            return -1;
        }
    }
}
