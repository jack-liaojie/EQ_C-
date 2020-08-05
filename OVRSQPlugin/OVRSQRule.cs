using System;
using System.Collections;
using System.Collections.Generic;

namespace AutoSports.OVRSQPlugin
{
    public class OVRSQRule
    {
        public Int32 m_nMatchID;
        public Int32 m_nMatchType;
        public Int32 m_nMatchStatusID;

        public Int32 m_nServerType;
        public Int32 m_nSetsCount;
        public Int32 m_nTeamSplitCount;
        public Int32 m_nMaxScore;
        public Int32 m_nAdvantage;

        public Boolean m_bSetRule;
        public Boolean m_bSplitRule;

        public OVRSQRule(Int32 nMatchID)
        {
            m_nMatchID = -1;
            m_nMatchType = -1;
            m_nServerType = -1;
            m_nSetsCount = -1;
            m_nTeamSplitCount = -1;
            m_nMaxScore = 0;
            m_nAdvantage = 0;

            if (nMatchID > 0)
            {
                m_nMatchID = nMatchID;
                SQCommon.g_ManageDB.GetMatchRule(nMatchID, out m_nMatchType, out m_nServerType, out m_nSetsCount, out m_nTeamSplitCount, out m_nMaxScore,
                out m_nAdvantage, out m_bSetRule, out m_bSplitRule);

                m_nMatchStatusID = SQCommon.g_ManageDB.GetMatchStatus(nMatchID);
            }
        }

        public void PointsToRankResult(Int32 nPointsA, Int32 nPointsB, out Int32 pnRankA, out Int32 pnRankB, out Int32 pnResultA, out Int32 pnResultB)
        {
            Int32 nRankA = -1;
            Int32 nRankB = -1;
            Int32 nResultA = -1;
            Int32 nResultB = -1;

            if (nPointsA > nPointsB)
            {
                nRankA = SQCommon.RANK_TYPE_1ST;
                nRankB = SQCommon.RANK_TYPE_2ND;
                nResultA = SQCommon.RESULT_TYPE_WIN;
                nResultB = SQCommon.RESULT_TYPE_LOSE;
            }
            else if (nPointsA < nPointsB)
            {
                nRankA = SQCommon.RANK_TYPE_2ND;
                nRankB = SQCommon.RANK_TYPE_1ST;
                nResultA = SQCommon.RESULT_TYPE_LOSE;
                nResultB = SQCommon.RESULT_TYPE_WIN;
            }
            else if (nPointsA == nPointsB)
            {
                nRankA = SQCommon.RANK_TYPE_TIE;
                nRankB = SQCommon.RANK_TYPE_TIE;
                nResultA = SQCommon.RESULT_TYPE_TIE;
                nResultB = SQCommon.RESULT_TYPE_TIE;
            }

            pnRankA = nRankA;
            pnRankB = nRankB;
            pnResultA = nResultA;
            pnResultB = nResultB;
        }

        public bool GetMatchScoreFromTeamSplits(ref Int32 nPointsA, ref Int32 nPointsB)
        {
            if (m_nMatchID <= 0 || m_nMatchType != SQCommon.MATCH_TYPE_TEAM || m_nTeamSplitCount <= 0) return false;

            Int32 nMatchScoreA = 0;
            Int32 nMatchScoreB = 0;

            STableRecordSet stRecords;
            if ( !SQCommon.g_ManageDB.GetSubSplitInfo(m_nMatchID, 0, out stRecords) ) return false;

            Int32 nCount = stRecords.GetRecordCount();

            for (Int32 i = 0; i < nCount; i++)
            {
                Int32 nTeamSplitID = stRecords.GetFieldValue(i, "F_MatchSplitID") == String.Empty ? 0 : Convert.ToInt32(stRecords.GetFieldValue(i, "F_MatchSplitID"));

                STableRecordSet stSplitResults;
                if ( !SQCommon.g_ManageDB.GetSplitResult(m_nMatchID, nTeamSplitID, out stSplitResults) ) continue;

                Int32 nResultA = stSplitResults.GetFieldValue(0, "F_ResultID") == String.Empty ? 0 : Convert.ToInt32(stSplitResults.GetFieldValue(0, "F_ResultID"));
                Int32 nResultB = stSplitResults.GetFieldValue(1, "F_ResultID") == String.Empty ? 0 : Convert.ToInt32(stSplitResults.GetFieldValue(1, "F_ResultID"));

                if (nResultA == SQCommon.RESULT_TYPE_WIN || nResultB == SQCommon.RESULT_TYPE_WIN)
                {
                    if (SQCommon.g_bUseSplitsRule && IsMatchScoreFinished(nMatchScoreA, nMatchScoreB)) break;

                    if (nResultA == SQCommon.RESULT_TYPE_WIN && nResultB == SQCommon.RESULT_TYPE_LOSE)
                    {
                        nMatchScoreA++;
                    }
                    else if (nResultB == SQCommon.RESULT_TYPE_WIN && nResultA == SQCommon.RESULT_TYPE_LOSE)
                    {
                        nMatchScoreB++;
                    }
                }
                else if (SQCommon.g_bUseSplitsRule)
                {
                    break;
                }
            }

            nPointsA = nMatchScoreA;
            nPointsB = nMatchScoreB;

            return true;

        }

        public bool GetTotalScoreFromSets(Int32 nTeamSplitID, ref Int32 nPointsA, ref Int32 nPointsB)
        {
            if (m_nMatchID <= 0 || nTeamSplitID < 0 || m_nSetsCount <= 0) return false;

            Int32 nTotalScoreA = 0;
            Int32 nTotalScoreB = 0;

            STableRecordSet stRecords;
            if (!SQCommon.g_ManageDB.GetSubSplitInfo(m_nMatchID, nTeamSplitID, out stRecords)) return false;

            Int32 nCount = stRecords.GetRecordCount();

            for (Int32 i = 0; i < nCount; i++)
            {
                Int32 nSetID = Convert.ToInt32(stRecords.GetFieldValue(i, "F_MatchSplitID"));

                STableRecordSet stSplitResults;
                if (!SQCommon.g_ManageDB.GetSplitResult(m_nMatchID, nSetID, out stSplitResults)) continue;

                Int32 nResultA = stSplitResults.GetFieldValue(0, "F_ResultID") == String.Empty ? 0 : Convert.ToInt32(stSplitResults.GetFieldValue(0, "F_ResultID"));
                Int32 nResultB = stSplitResults.GetFieldValue(1, "F_ResultID") == String.Empty ? 0 : Convert.ToInt32(stSplitResults.GetFieldValue(1, "F_ResultID"));
                
                if (nResultA == SQCommon.RESULT_TYPE_WIN || nResultB == SQCommon.RESULT_TYPE_WIN)
                {
                    if (SQCommon.g_bUseSetsRule && IsTotalScoreFinished(nCount, nTotalScoreA, nTotalScoreB)) break;

                    if (nResultA == SQCommon.RESULT_TYPE_WIN && nResultB == SQCommon.RESULT_TYPE_LOSE)
                    {
                        nTotalScoreA++;
                    }
                    else if(nResultB == SQCommon.RESULT_TYPE_WIN && nResultA == SQCommon.RESULT_TYPE_LOSE)
                    {
                        nTotalScoreB++;
                    }
                }
                else if (SQCommon.g_bUseSetsRule)
                {
                    break;
                }
            }

            nPointsA = nTotalScoreA;
            nPointsB = nTotalScoreB;

            return true;
        }

        public bool IsValidMatchScore(Int32 nPointsA, Int32 nPointsB)
        {
            if (m_nMatchID <= 0 || nPointsA < 0 || nPointsB < 0) return false;

            Int32 nSeperateSplit = m_nTeamSplitCount / 2 + 1;
            Int32 nSeperateSet = m_nSetsCount / 2 + 1;

            if (m_nMatchType == SQCommon.MATCH_TYPE_TEAM)
            {
                if (nPointsA >= nSeperateSplit || nPointsB >= nSeperateSplit)
                    return true;
            }
            else
            {
                if (nPointsA >= nSeperateSet || nPointsB >= nSeperateSet)
                    return true;
            }

            return false;
        }

        public bool IsValidTeamSplitScore(Int32 nPointsA, Int32 nPointsB)
        {
            if (m_nMatchID <= 0 || nPointsA < 0 || nPointsB < 0) return false;

            if (m_nMatchType == SQCommon.MATCH_TYPE_TEAM)
            {
                if (nPointsA + nPointsB <= m_nSetsCount) return true;
            }

            return false;
        }

        public bool IsValidSetScore(Int32 nPointsA, Int32 nPointsB)
        {
            Int32 nDefer = nPointsA - nPointsB;
            if ((nPointsA > m_nMaxScore || nPointsB > m_nMaxScore) && (Math.Abs(nDefer) > m_nAdvantage)) return false;

            return true;
        }

        public bool IsSetScoreFinished(Int32 nPointsA, Int32 nPointsB)
        {
            Int32 nDefer = nPointsA - nPointsB;

            if ((nPointsA >= m_nMaxScore || nPointsB >= m_nMaxScore) && (Math.Abs(nDefer) >= m_nAdvantage)) return true;

            return false;
        }

        public bool IsTotalScoreFinished(Int32 nSetsCount, Int32 nPointsA, Int32 nPointsB)
        {
            if (nSetsCount <= 0 || nPointsA < 0 || nPointsB < 0) return false;

            bool bFinished = false;
            Int32 nSeperateCount = nSetsCount / 2 + 1;
            if (nPointsA >= nSeperateCount || nPointsB >= nSeperateCount) bFinished = true;

            return bFinished;
        }

        public bool IsMatchScoreFinished(Int32 nPointsA, Int32 nPointsB)
        {
            if (m_nMatchID <= 0 || nPointsA < 0 || nPointsB < 0) return false;

            bool bFinished = false;
            Int32 nLimitCount = 0;
            if (m_nMatchType == SQCommon.MATCH_TYPE_TEAM)
            {
                nLimitCount = m_nTeamSplitCount;
            }
            else if (m_nMatchType == SQCommon.MATCH_TYPE_SINGLE)
            {
                nLimitCount = m_nSetsCount;
            }

            Int32 nSeperateCount = nLimitCount / 2 + 1;
            if (nPointsA >= nSeperateCount || nPointsB >= nSeperateCount) bFinished = true;

            return bFinished;
        }

        public bool UpdateMatchResultToDB(Int32 nPointsA, Int32 nPointsB, Int32 nPosA, Int32 nPosB)
        {
            if (!IsValidMatchScore(nPointsA, nPointsB))
            {
                if (!SQCommon.g_ManageDB.SetMatchResultWithNull(m_nMatchID, nPosA, nPointsA)) return false;
                if (!SQCommon.g_ManageDB.SetMatchResultWithNull(m_nMatchID, nPosB, nPointsB)) return false;

                return true;
            }

            Int32 nRankA, nRankB, nResultA, nResultB;
            PointsToRankResult(nPointsA, nPointsB, out nRankA, out nRankB, out nResultA, out nResultB);
            if (nRankA == -1 || nRankB == -1 || nResultA == -1 || nResultB == -1) return false;

            if (!SQCommon.g_ManageDB.SetMatchResult(m_nMatchID, nPosA, nPointsA, nRankA, nResultA)) return false;
            if (!SQCommon.g_ManageDB.SetMatchResult(m_nMatchID, nPosB, nPointsB, nRankB, nResultB)) return false;

            return true;
        }

        public bool UpdateTeamSplitResultToDB(Int32 nTeamSplitID, Int32 nPointsA, Int32 nPointsB, Int32 nPosA, Int32 nPosB)
        {
            if (!IsValidTeamSplitScore(nPointsA, nPointsB) || nTeamSplitID <= 0) return false;
            
            //Modify
            bool bFinish = IsTotalScoreFinished(m_nSetsCount, nPointsA, nPointsB);

            Int32 nRankA, nRankB, nResultA, nResultB;
            PointsToRankResult(nPointsA, nPointsB, out nRankA, out nRankB, out nResultA, out nResultB);
            if (nRankA == -1 || nRankB == -1 || nResultA == -1 || nResultB == -1) return false;

            if (!SQCommon.g_ManageDB.SetSplitPoints(m_nMatchID, nTeamSplitID, nPosA, nPointsA, nResultA, nRankA, bFinish)) return false;
            if (!SQCommon.g_ManageDB.SetSplitPoints(m_nMatchID, nTeamSplitID, nPosB, nPointsB, nResultB, nRankB, bFinish)) return false;

            return true;
        }

        //局点赛点计算
        public void StatGameMatchPoint(Int32 nGameA, Int32 nGameB, Int32 nMatchA, Int32 nMatchB, out Int32 nPointType)
        {
            nPointType = SQCommon.NONE_POINT;

            Int32 nDefer = nGameA - nGameB;
            Int32 nSplit = m_nSetsCount / 2 + 1;
            if (((nGameA > m_nMaxScore - 2) || (nGameB > m_nMaxScore - 2)) && (Math.Abs(nDefer) == m_nAdvantage - 1) || ((nGameA == m_nMaxScore - 1) && (nGameB < nGameA) && (Math.Abs(nDefer) >= m_nAdvantage - 1))
                || ((nGameB == m_nMaxScore - 1) && (nGameA < nGameB) && (Math.Abs(nDefer) >= m_nAdvantage - 1)))
            {
                if (nGameA > nGameB)
                {
                    if (nMatchA == nSplit - 1)
                    {
                        nPointType = SQCommon.A_MATCHPOINT;
                    }
                    else
                    {
                        nPointType = SQCommon.A_GAMEPOINT;
                    }
                }
                else
                {
                    if (nMatchB == nSplit - 1)
                    {
                        nPointType = SQCommon.B_MATCHPOINT;
                    }
                    else
                    {
                        nPointType = SQCommon.B_GAMEPOINT;
                    }
                }
            }
        }
    }
}
