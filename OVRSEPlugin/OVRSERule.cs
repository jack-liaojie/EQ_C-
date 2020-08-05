using System;
using System.Collections;
using System.Collections.Generic;

namespace AutoSports.OVRSEPlugin
{
    public class OVRSERule
    {
        public OVRSERule(Int32 nMatchID)
        {
            m_nMatchID = nMatchID;
            m_nMatchType = -1;
            m_nTeamSplitCount = -1;
            m_nSetsCount = -1;
            m_nScore = -1;
            m_nMaxScore = 0;
            m_nAdvantage = 0;
            m_nTieScore = 0;
            m_nTieMaxScore = 0;
            m_bSetRule = false;
            m_bSplitRule = false;
            
            if (nMatchID > 0)
            {
                m_nMatchID = nMatchID;
                SECommon.g_ManageDB.GetMatchRule(nMatchID, out m_nMatchType, out m_nTeamSplitCount, out m_nSetsCount, out m_nScore, out m_nMaxScore,
                out m_nAdvantage, out m_nTieScore, out m_nTieMaxScore, out m_bSetRule, out m_bSplitRule);

                m_nMatchStatusID = SECommon.g_ManageDB.GetMatchStatus(nMatchID);
            }
        }

        public Int32 m_nMatchID;
        public Int32 m_nMatchType;
        public Int32 m_nMatchStatusID;

        public Int32 m_nSetsCount;
        public Int32 m_nTeamSplitCount;
        public Int32 m_nScore;
        public Int32 m_nMaxScore;
        public Int32 m_nAdvantage;
        public Int32 m_nTieScore;
        public Int32 m_nTieMaxScore;
        public Boolean m_bSetRule;
        public Boolean m_bSplitRule;

        public void PointsToRankResult(Int32 nPointsA, Int32 nPointsB, out Int32 pnRankA, out Int32 pnRankB, out Int32 pnResultA, out Int32 pnResultB)
        {
            Int32 nRankA = -1;
            Int32 nRankB = -1;
            Int32 nResultA = -1;
            Int32 nResultB = -1;

            if (nPointsA >= m_nSetsCount / 2 + 1)
            {
                nRankA = SECommon.RANK_TYPE_1ST;
                nRankB = SECommon.RANK_TYPE_2ND;
                nResultA = SECommon.RESULT_TYPE_WIN;
                nResultB = SECommon.RESULT_TYPE_LOSE;
            }
            else if (nPointsB >= m_nSetsCount / 2 + 1)
            {
                nRankA = SECommon.RANK_TYPE_2ND;
                nRankB = SECommon.RANK_TYPE_1ST;
                nResultA = SECommon.RESULT_TYPE_LOSE;
                nResultB = SECommon.RESULT_TYPE_WIN;
            }
            else
            {
                nRankA = SECommon.RANK_TYPE_TIE;
                nRankB = SECommon.RANK_TYPE_TIE;
                nResultA = SECommon.RESULT_TYPE_TIE;
                nResultB = SECommon.RESULT_TYPE_TIE;
            }

            pnRankA = nRankA;
            pnRankB = nRankB;
            pnResultA = nResultA;
            pnResultB = nResultB;
        }

        public bool GetMatchScoreFromTeamSplits(ref Int32 nPointsA, ref Int32 nPointsB)
        {
            if (m_nMatchID <= 0 || m_nMatchType != SECommon.MATCH_TYPE_TEAM || m_nTeamSplitCount <= 0) return false;

            Int32 nMatchScoreA = 0;
            Int32 nMatchScoreB = 0;

            STableRecordSet stRecords;
            if ( !SECommon.g_ManageDB.GetSubSplitInfo(m_nMatchID, 0, out stRecords) ) return false;

            Int32 nCount = stRecords.GetRecordCount();

            for (Int32 i = 0; i < nCount; i++)
            {
                Int32 nTeamSplitID = stRecords.GetFieldValue(i, "F_MatchSplitID") == String.Empty ? 0 : Convert.ToInt32(stRecords.GetFieldValue(i, "F_MatchSplitID"));

                STableRecordSet stSplitResults;
                if ( !SECommon.g_ManageDB.GetSplitResult(m_nMatchID, nTeamSplitID, out stSplitResults) ) continue;

                Int32 nSplitPointsA = stSplitResults.GetFieldValue(0, "F_Points") == String.Empty ? 0 : Convert.ToInt32(stSplitResults.GetFieldValue(0, "F_Points"));
                Int32 nSplitPointsB = stSplitResults.GetFieldValue(1, "F_Points") == String.Empty ? 0 : Convert.ToInt32(stSplitResults.GetFieldValue(1, "F_Points"));

                if (IsTotalScoreFinished(m_nSetsCount, nSplitPointsA, nSplitPointsB))
                {
                    if (SECommon.g_bUseSplitsRule && IsMatchScoreFinished(nMatchScoreA, nMatchScoreB)) break;

                    if (nSplitPointsA > nSplitPointsB) nMatchScoreA++; else nMatchScoreB++;
                }
                else if (SECommon.g_bUseSplitsRule)
                {
                    break;
                }
            }

            nPointsA = nMatchScoreA;
            nPointsB = nMatchScoreB;

            return true;

        }

        public bool GetTotalScoreFromSets(Int32 nSplitOffset, Int32 nTeamSplitID, ref Int32 nPointsA, ref Int32 nPointsB)
        {
            if (m_nMatchID <= 0 || nTeamSplitID < 0 || m_nSetsCount <= 0) return false;

            Int32 nTotalScoreA = 0;
            Int32 nTotalScoreB = 0;

            STableRecordSet stRecords;
            if (!SECommon.g_ManageDB.GetSubSplitInfo(m_nMatchID, nTeamSplitID, out stRecords)) return false;

            Int32 nCount = stRecords.GetRecordCount();

            for (Int32 i = 0; i < nCount; i++)
            {
                Int32 nSetID = Convert.ToInt32(stRecords.GetFieldValue(i, "F_MatchSplitID"));

                STableRecordSet stSplitResults;
                if (!SECommon.g_ManageDB.GetSplitResult(m_nMatchID, nSetID, out stSplitResults)) continue;

                Int32 nSplitPointsA = 0;
                try
                {
                    nSplitPointsA = Convert.ToInt32(stSplitResults.GetFieldValue(0, "F_Points"));
                }
                catch (System.Exception ex)
                {
                    nSplitPointsA = 0;
                }
                
                Int32 nSplitPointsB = 0; 
                try
                {
                    nSplitPointsB = Convert.ToInt32(stSplitResults.GetFieldValue(1, "F_Points"));
                }
                catch (System.Exception ex)
                {
                    nSplitPointsB = 0;
                }
                

                if (IsSetScoreFinished(i+1, nSplitPointsA, nSplitPointsB))
                {
                    if (SECommon.g_bUseSetsRule && IsTotalScoreFinished(nCount, nTotalScoreA, nTotalScoreB)) break;

                    if (nSplitPointsA > nSplitPointsB) nTotalScoreA++; else nTotalScoreB++;
                }
                else if (SECommon.g_bUseSetsRule)
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

            if (m_nMatchType == SECommon.MATCH_TYPE_TEAM)
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

            if (m_nMatchType == SECommon.MATCH_TYPE_TEAM)
            {
                if (nPointsA + nPointsB <= m_nSetsCount) return true;
            }

            return false;
        }

        public bool IsValidSetScore(Int32 nSet, Int32 nPointsA, Int32 nPointsB)
        {
            Int32 nScore = nSet == m_nSetsCount ? m_nTieScore : m_nScore;
            Int32 nMaxScore = nSet == m_nSetsCount ? m_nTieMaxScore : m_nMaxScore;

            if (nPointsA < 0 || nPointsB < 0 || nPointsA > nMaxScore || nPointsB > nMaxScore) return false;

            Int32 nDefer = nPointsA - nPointsB;
            if ((nPointsA > nScore || nPointsB > nScore) && (Math.Abs(nDefer) > m_nAdvantage)) return false;

            return true;
        }

        public bool IsSetScoreFinished(Int32 nSet, Int32 nPointsA, Int32 nPointsB)
        {
            Int32 nScore = nSet == m_nSetsCount ? m_nTieScore : m_nScore;
            Int32 nMaxScore = nSet == m_nSetsCount ? m_nTieMaxScore : m_nMaxScore;

            Int32 nDefer = nPointsA - nPointsB;

            if (nPointsA == nMaxScore || nPointsB == nMaxScore || ((nPointsA >= nScore || nPointsB >= nScore) && (Math.Abs(nDefer) >= m_nAdvantage)))
                return true;

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
            if (m_nMatchType == SECommon.MATCH_TYPE_TEAM)
            {
                nLimitCount = m_nTeamSplitCount;
            }
            else if (m_nMatchType == SECommon.MATCH_TYPE_REGU || m_nMatchType == SECommon.MATCH_TYPE_DOUBLE)
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
                if (!SECommon.g_ManageDB.SetMatchResultWithNull(m_nMatchID, nPosA, nPointsA)) return false;
                if (!SECommon.g_ManageDB.SetMatchResultWithNull(m_nMatchID, nPosB, nPointsB)) return false;

                return true;
            }

            Int32 nRankA, nRankB, nResultA, nResultB;
            PointsToRankResult(nPointsA, nPointsB, out nRankA, out nRankB, out nResultA, out nResultB);
            if (nRankA == -1 || nRankB == -1 || nResultA == -1 || nResultB == -1) return false;

            if (!SECommon.g_ManageDB.SetMatchResult(m_nMatchID, nPosA, nPointsA, nRankA, nResultA)) return false;
            if (!SECommon.g_ManageDB.SetMatchResult(m_nMatchID, nPosB, nPointsB, nRankB, nResultB)) return false;

            return true;
        }

        public bool UpdateTeamSplitResultToDB(Int32 nTeamSplitID, Int32 nPointsA, Int32 nPointsB, Int32 nPosA, Int32 nPosB)
        {
            if (!IsValidTeamSplitScore(nPointsA, nPointsB) || nTeamSplitID <= 0) return false;

            Int32 nRankA, nRankB, nResultA, nResultB;
            PointsToRankResult(nPointsA, nPointsB, out nRankA, out nRankB, out nResultA, out nResultB);
            if (nRankA == -1 || nRankB == -1 || nResultA == -1 || nResultB == -1) return false;

            if (!SECommon.g_ManageDB.SetSplitResult(m_nMatchID, nTeamSplitID, nPosA, nPointsA, nRankA, nResultA)) return false;
            if (!SECommon.g_ManageDB.SetSplitResult(m_nMatchID, nTeamSplitID, nPosB, nPointsB, nRankB, nResultB)) return false;

            return true;
        }

        //局点赛点计算
        public void StatGameMatchPoint(Int32 nSet, bool bServerA, bool bServerB, Int32 nGameA, Int32 nGameB, Int32 nMatchA, Int32 nMatchB, out Int32 nPointType)
        {
            nPointType = SECommon.NONE_POINT;

            Int32 nScore = nSet == m_nSetsCount ? m_nTieScore : m_nScore;
            Int32 nMaxScore = nSet == m_nSetsCount ? m_nTieMaxScore : m_nMaxScore;
            Int32 nDefer = nGameA - nGameB;
            Int32 nSplit = m_nSetsCount / 2 + 1;

            if ((nGameA < nMaxScore) && (nGameB < nMaxScore))
            {
                if ((nGameA == nMaxScore - 1) && (nGameB == nMaxScore - 1))
                {
                    if ((nMatchA == nSplit - 1) && bServerA)
                    {
                        nPointType = SECommon.A_MATCHPOINT;
                    }
                    else if ((nMatchA < nSplit - 1) && bServerA)
                    {
                        nPointType = SECommon.A_GAMEPOINT;
                    }
                    else if ((nMatchB == nSplit - 1) && bServerB)
                    {
                        nPointType = SECommon.B_MATCHPOINT;
                    }
                    else if ((nMatchB < nSplit - 1) && bServerB)
                    {
                        nPointType = SECommon.B_GAMEPOINT;
                    }
                }
                else if (((nGameA > nScore - 2) || (nGameB > nScore - 2)) && (Math.Abs(nDefer) == m_nAdvantage - 1) || ((nGameA == nScore - 1) && (nGameB < nGameA) && (Math.Abs(nDefer) >= m_nAdvantage - 1))
                || ((nGameB == nScore - 1) && (nGameA < nGameB) && (Math.Abs(nDefer) >= m_nAdvantage - 1)))
                {
                    if (nGameA > nGameB)
                    {
                        if (nMatchA == nSplit - 1)
                        {
                            nPointType = SECommon.A_MATCHPOINT;
                        }
                        else
                        {
                            nPointType = SECommon.A_GAMEPOINT;
                        }
                    }
                    else
                    {
                        if (nMatchB == nSplit - 1)
                        {
                            nPointType = SECommon.B_MATCHPOINT;
                        }
                        else
                        {
                            nPointType = SECommon.B_GAMEPOINT;
                        }
                    }
                }
            }
        }
    }
}
