using System;
using System.Collections.Generic;

namespace AutoSports.OVRBDPlugin
{
    public enum TeamSubMatchType : int
    {
        TypeSubMatchMenSingle = 1,
        TypeSubMatchWomenSingle = 2,
        TypeSubMatchMenDouble = 3,
        TypeSubMatchWomenDouble = 4,
        TypeSubMatchMixedDouble = 5,
    }
    public enum ServiceType: int
    {
        TypeServiceA = 1,
        TypeServiceNULL = 0,
        TypeServiceB = -1
    }
    public class OVRBDRule
    {
        public Int32 m_nMatchID;
        public Int32 m_nMatchType;
        private String m_strTeamSubMatchTypes;//转成整数后不可超过MAX_INT
        private List<int> m_arraySumMatchTypes = new List<int>();
        
        public List<int> TeamSubMatchTypes
        {
            get { return m_arraySumMatchTypes; }
        }
        public Int32 m_nMatchStatusID;
        
        public Int32 m_nGamesCount;
        public Int32 m_nSplitsCount;
        public Int32 m_nGamePoint;
        public Int32 m_nMaxGameScore;
        public Int32 m_nAdvantageDiffer;        

        public bool m_bScoredOwnServe;       // Attach the serve status and the scored status
        public bool m_bNeedAllGamesCompleted;
        public bool m_bNeedAllSplitsCompleted;

        public OVRBDRule(Int32 nMatchID)
        {
            m_nMatchID = -1;
            m_nMatchType = -1;            
            m_nGamesCount = -1;
            m_nSplitsCount = -1;
            m_nGamePoint = -1;
            m_nMaxGameScore = 0;
            m_nAdvantageDiffer = 0;

            m_bScoredOwnServe = false;
            m_bNeedAllGamesCompleted = false;
            m_bNeedAllSplitsCompleted = false;

            if (nMatchID > 0)
            {
                m_nMatchID = nMatchID;
                BDCommon.g_ManageDB.GetMatchRule(nMatchID, out m_nMatchType, out m_strTeamSubMatchTypes, out m_nSplitsCount, out m_nGamesCount,
                    out m_nGamePoint, out m_nMaxGameScore, out m_nAdvantageDiffer, 
                    out m_bScoredOwnServe, out m_bNeedAllGamesCompleted, out m_bNeedAllSplitsCompleted);

                m_arraySumMatchTypes = ConvertToIntArray(m_strTeamSubMatchTypes);
                FiltrateWithGender();//通过性别再次过滤团体赛的SubMatch类型
                m_nMatchStatusID = BDCommon.g_ManageDB.GetMatchStatus(nMatchID);
            }
        }

        private void FiltrateWithGender()
        {
            if ( m_nMatchID <= 0 )
            {
                return;
            }
            int sexCode = BDCommon.g_ManageDB.GetSexCodeByMatchID(m_nMatchID);
          
            if ( sexCode == 1 )//男子比赛
            {
                m_strTeamSubMatchTypes = "";//先清空
                foreach( int sex in m_arraySumMatchTypes )
                {
                    if (sex == (int)TeamSubMatchType.TypeSubMatchMenSingle
                        || sex == (int)TeamSubMatchType.TypeSubMatchMenDouble)
                    {
                        m_strTeamSubMatchTypes += sex.ToString();
                    }
                }
                if ( m_strTeamSubMatchTypes != "" )
                {
                    m_arraySumMatchTypes = ConvertToIntArray(m_strTeamSubMatchTypes);
                }
                else
                {
                    if ( m_arraySumMatchTypes != null )
                    {
                        m_arraySumMatchTypes.Clear();
                    }
                    
                }
            }
            else if ( sexCode == 2 )//女子比赛
            {
                m_strTeamSubMatchTypes = "";//先清空
                foreach (int sex in m_arraySumMatchTypes)
                {
                    if (sex == (int)TeamSubMatchType.TypeSubMatchWomenSingle
                        || sex == (int)TeamSubMatchType.TypeSubMatchWomenDouble)
                    {
                        m_strTeamSubMatchTypes += sex.ToString();
                    }
                }
                if (m_strTeamSubMatchTypes != "")
                {
                    m_arraySumMatchTypes = ConvertToIntArray(m_strTeamSubMatchTypes);
                }
                else
                {
                    m_arraySumMatchTypes.Clear();
                }
            }
            else if( sexCode == 3 )//团体比赛
            {
                ;//暂时不过滤
            }
        }
        
        private List<int> ConvertToIntArray( string strNumbers)
        {
            if ( string.IsNullOrEmpty(strNumbers) )
            {
                return null;
            }
            List<int> ret = new List<int>();
            int typeNum = Convert.ToInt32(strNumbers);
            do 
            {
                ret.Add(typeNum%10);
                typeNum /= 10;
            } while ( typeNum != 0 );
            return ret;
        }

        public bool IsContainSubMatchType(TeamSubMatchType subMatchType )
        {
            return (m_strTeamSubMatchTypes.IndexOf(((int)subMatchType).ToString()) != -1);
        }

        public void PointsToRankResult(Int32 nPointsA, Int32 nPointsB, out Int32 pnRankA, out Int32 pnRankB, out Int32 pnResultA, out Int32 pnResultB)
        {
            Int32 nRankA = -1;
            Int32 nRankB = -1;
            Int32 nResultA = -1;
            Int32 nResultB = -1;

            if (nPointsA > nPointsB)
            {
                nRankA = BDCommon.RANK_TYPE_1ST;
                nRankB = BDCommon.RANK_TYPE_2ND;
                nResultA = BDCommon.RESULT_TYPE_WIN;
                nResultB = BDCommon.RESULT_TYPE_LOSE;
            }
            else if (nPointsA < nPointsB)
            {
                nRankA = BDCommon.RANK_TYPE_2ND;
                nRankB = BDCommon.RANK_TYPE_1ST;
                nResultA = BDCommon.RESULT_TYPE_LOSE;
                nResultB = BDCommon.RESULT_TYPE_WIN;
            }
            else if (nPointsA == nPointsB)
            {
                nRankA = BDCommon.RANK_TYPE_TIE;
                nRankB = BDCommon.RANK_TYPE_TIE;
                nResultA = BDCommon.RESULT_TYPE_TIE;
                nResultB = BDCommon.RESULT_TYPE_TIE;
            }

            pnRankA = nRankA;
            pnRankB = nRankB;
            pnResultA = nResultA;
            pnResultB = nResultB;
        }

        #region Match rules apply

        private bool IsValidCompetitionScore(Int32 nPointsA, Int32 nPointsB, Int32 nCompetitionCount, bool bNeedAllCompetitionCompleted)
        {
            if (nPointsA + nPointsB <= nCompetitionCount)
            {
                if (bNeedAllCompetitionCompleted)
                    return true;
                else
                    return IsValidBestOfXScore(nCompetitionCount, nPointsA, nPointsB);
            }
            return false;
        }
        private bool IsCompetitionScoreFinished(Int32 nPointsA, Int32 nPointsB, Int32 nCompetitionCount, bool bNeedAllCompetitionCompleted)
        {
            if (nPointsA + nPointsB <= nCompetitionCount)
            {
                if (bNeedAllCompetitionCompleted)
                    return (nPointsA + nPointsB == nCompetitionCount);
                else
                    return IsBestOfXFinished(nCompetitionCount, nPointsA, nPointsB);
            }

            return false;
        }

        private bool IsValidBestOfXScore(Int32 nXCount, Int32 nPointsA, Int32 nPointsB)
        {
            if (nXCount <= 0 || nPointsA < 0 || nPointsB < 0) return false;

            if (nPointsA + nPointsB <= nXCount)
            {
                Int32 nSeperateCount = nXCount / 2 + 1;
                if (nPointsA <= nSeperateCount && nPointsB <= nSeperateCount) return true;
            }

            return false;
        }
        private bool IsBestOfXFinished(Int32 nXCount, Int32 nPointsA, Int32 nPointsB)
        {
            if (nXCount <= 0 || nPointsA < 0 || nPointsB < 0) return false;

            Int32 nSeperateCount = nXCount / 2 + 1;
            if (nPointsA >= nSeperateCount || nPointsB >= nSeperateCount) return true;

            return false;
        }

        public bool IsValidMatchScore(Int32 nPointsA, Int32 nPointsB)
        {
            if (m_nMatchID <= 0 || nPointsA < 0 || nPointsB < 0) return false;

            int nCompetitionCount = m_nMatchType == BDCommon.MATCH_TYPE_TEAM ? m_nSplitsCount : m_nGamesCount;
            bool bNeedAllCompetitionCompleted = m_nMatchType == BDCommon.MATCH_TYPE_TEAM ? m_bNeedAllSplitsCompleted : m_bNeedAllGamesCompleted;

            return IsValidCompetitionScore(nPointsA, nPointsB, nCompetitionCount, bNeedAllCompetitionCompleted);
        }
        public bool IsMatchScoreFinished(Int32 nPointsA, Int32 nPointsB)
        {
            if (m_nMatchID <= 0 || nPointsA < 0 || nPointsB < 0) return false;

            int nCompetitionCount = m_nMatchType == BDCommon.MATCH_TYPE_TEAM ? m_nSplitsCount : m_nGamesCount;
            bool bNeedAllCompetitionCompleted = m_nMatchType == BDCommon.MATCH_TYPE_TEAM ? m_bNeedAllSplitsCompleted : m_bNeedAllGamesCompleted;

            return IsCompetitionScoreFinished(nPointsA, nPointsB, nCompetitionCount, bNeedAllCompetitionCompleted);
        }

        public bool IsValidGamesTotalScore(Int32 nPointsA, Int32 nPointsB)
        {
            if (m_nMatchID <= 0 || nPointsA < 0 || nPointsB < 0) return false;

            return IsValidCompetitionScore(nPointsA, nPointsB, m_nGamesCount, m_bNeedAllGamesCompleted);
        }
        public bool IsGamesTotalScoreFinished(Int32 nPointsA, Int32 nPointsB)
        {
            if (m_nMatchID <= 0 || nPointsA < 0 || nPointsB < 0) return false;

            return IsCompetitionScoreFinished(nPointsA, nPointsB, m_nGamesCount, m_bNeedAllGamesCompleted);
        }

        public bool IsValidGameScore(Int32 nPointsA, Int32 nPointsB)
        {
            if (nPointsA < 0 || nPointsB < 0 || nPointsA > m_nMaxGameScore || nPointsB > m_nMaxGameScore) 
                return false;

            int nDiffer = nPointsA - nPointsB;
            if ((nPointsA > m_nGamePoint || nPointsB > m_nGamePoint) && (Math.Abs(nDiffer) > m_nAdvantageDiffer)) 
                return false;

            return true;
        }
        public bool IsGameScoreFinished(Int32 nPointsA, Int32 nPointsB)
        {
            if (!IsValidGameScore(nPointsA, nPointsB)) return false;

            if (nPointsA >= m_nMaxGameScore || nPointsB >= m_nMaxGameScore) return true;

            Int32 nDiffer = nPointsA - nPointsB;
            if ((nPointsA >= m_nGamePoint || nPointsB >= m_nGamePoint) && (Math.Abs(nDiffer) >= m_nAdvantageDiffer)) 
                return true;

            return false;
        }

        #endregion 

        #region Database operation

        public bool GetMatchScoreFromTeamSplits(ref Int32 nPointsA, ref Int32 nPointsB)
        {
            if (m_nMatchID <= 0 || m_nMatchType != BDCommon.MATCH_TYPE_TEAM || m_nSplitsCount <= 0) return false;

            Int32 nMatchScoreA = 0;
            Int32 nMatchScoreB = 0;

            STableRecordSet stRecords;
            if (!BDCommon.g_ManageDB.GetSubSplitInfo(m_nMatchID, 0, out stRecords)) return false;

            Int32 nCount = stRecords.GetRecordCount();

            for (Int32 i = 0; i < nCount; i++)
            {
                Int32 nTeamSplitID = BDCommon.Str2Int(stRecords.GetFieldValue(i, "F_MatchSplitID"));

                STableRecordSet stSplitResults;
                if (!BDCommon.g_ManageDB.GetMatchSplitResult(m_nMatchID, nTeamSplitID, out stSplitResults)) continue;

                Int32 nResultA = BDCommon.Str2Int(stSplitResults.GetFieldValue(0, "F_ResultID"));
                Int32 nResultB = BDCommon.Str2Int(stSplitResults.GetFieldValue(1, "F_ResultID"));
                              
                // Statistic the score of each valid team split
                if (nResultA == BDCommon.RESULT_TYPE_WIN && nResultB == BDCommon.RESULT_TYPE_LOSE)
                {
                    nMatchScoreA++;
                }
                else if (nResultB == BDCommon.RESULT_TYPE_WIN && nResultA == BDCommon.RESULT_TYPE_LOSE)
                {
                    nMatchScoreB++;
                }
                else if (nResultA == BDCommon.RESULT_TYPE_TIE && nResultB == BDCommon.RESULT_TYPE_TIE)
                {
                    nMatchScoreA++;
                    nMatchScoreB++;
                }
                else
                    continue; // The Split has not been completed
                
                if (IsValidMatchScore(nMatchScoreA, nMatchScoreB) && IsMatchScoreFinished(nMatchScoreA, nMatchScoreB)) 
                    break;
            }

            nPointsA = nMatchScoreA;
            nPointsB = nMatchScoreB;

            return true;
        }

        public bool GetGamesTotalFromGames(Int32 nTeamSplitID, ref Int32 nPointsA, ref Int32 nPointsB)
        {
            if (m_nMatchID <= 0 || nTeamSplitID < 0 || m_nGamesCount <= 0) return false;

            // nTeamSplitID=0, means not team type match
            if (nTeamSplitID == 0 && m_nMatchType == BDCommon.MATCH_TYPE_TEAM) return false; 

            Int32 nTotalScoreA = 0;
            Int32 nTotalScoreB = 0;

            STableRecordSet stRecords;
            if (!BDCommon.g_ManageDB.GetSubSplitInfo(m_nMatchID, nTeamSplitID, out stRecords)) return false;

            Int32 nCount = stRecords.GetRecordCount();

            for (Int32 i = 0; i < nCount; i++)
            {
                Int32 nGameID = Convert.ToInt32(stRecords.GetFieldValue(i, "F_MatchSplitID"));

                STableRecordSet stSplitResults;
                if (!BDCommon.g_ManageDB.GetMatchSplitResult(m_nMatchID, nGameID, out stSplitResults)) continue;

                Int32 nResultA = BDCommon.Str2Int(stSplitResults.GetFieldValue(0, "F_ResultID"));
                Int32 nResultB = BDCommon.Str2Int(stSplitResults.GetFieldValue(1, "F_ResultID"));

                if (nResultA == BDCommon.RESULT_TYPE_WIN && nResultB == BDCommon.RESULT_TYPE_LOSE)
                {
                    nTotalScoreA++;
                }
                else if (nResultB == BDCommon.RESULT_TYPE_WIN && nResultA == BDCommon.RESULT_TYPE_LOSE)
                {
                    nTotalScoreB++;
                }
                else if (nResultA == BDCommon.RESULT_TYPE_TIE && nResultB == BDCommon.RESULT_TYPE_TIE)
                {
                    nTotalScoreA++;
                    nTotalScoreB++;
                }
                else
                    continue; // The Game has not been completed
            }

            nPointsA = nTotalScoreA;
            nPointsB = nTotalScoreB;

            return true;
        }

        public bool UpdateMatchResultsToDB(Int32 nPointsA, Int32 nPointsB, Int32 nPosA, Int32 nPosB)
        {
            if (!IsValidMatchScore(nPointsA, nPointsB)) 
                return false;

            if (!IsMatchScoreFinished(nPointsA, nPointsB))
            {
                if (!BDCommon.g_ManageDB.SetMatchPoints(m_nMatchID, nPosA, nPointsA)) return false;
                if (!BDCommon.g_ManageDB.SetMatchPoints(m_nMatchID, nPosB, nPointsB)) return false;
            }
            else
            {
                Int32 nRankA, nRankB, nResultA, nResultB;
                PointsToRankResult(nPointsA, nPointsB, out nRankA, out nRankB, out nResultA, out nResultB);
                if (nRankA == -1 || nRankB == -1 || nResultA == -1 || nResultB == -1) return false;

                if (!BDCommon.g_ManageDB.SetMatchResults(m_nMatchID, nPosA, nPointsA, nRankA, nResultA)) return false;
                if (!BDCommon.g_ManageDB.SetMatchResults(m_nMatchID, nPosB, nPointsB, nRankB, nResultB)) return false;
            }

            return true;
        }

        public bool UpdateTeamSplitResultsToDB(Int32 nTeamSplitID, Int32 nPointsA, Int32 nPointsB, Int32 nPosA, Int32 nPosB)
        {
            if (nTeamSplitID <= 0 || m_nMatchType != BDCommon.MATCH_TYPE_TEAM || !IsValidGamesTotalScore(nPointsA, nPointsB)) return false;
            
            //Modify
            bool bFinish = IsGamesTotalScoreFinished(nPointsA, nPointsB);
            Int32 nRankA = -1, nRankB = -1, nResultA = -1, nResultB = -1;

            if (bFinish)
            {
                PointsToRankResult(nPointsA, nPointsB, out nRankA, out nRankB, out nResultA, out nResultB);
                if (nRankA == -1 || nRankB == -1 || nResultA == -1 || nResultB == -1) return false;
            }

            if (!BDCommon.g_ManageDB.SetMatchSplitPointsAndResults(m_nMatchID, nTeamSplitID, nPosA, nPointsA, nResultA, nRankA, bFinish)) return false;
            if (!BDCommon.g_ManageDB.SetMatchSplitPointsAndResults(m_nMatchID, nTeamSplitID, nPosB, nPointsB, nResultB, nRankB, bFinish)) return false;

            return true;
        }

        //局点赛点计算
        public void StatGameMatchPoint(Int32 nGameA, Int32 nGameB, Int32 nMatchA, Int32 nMatchB, out Int32 nPointType)
        {
            nPointType = BDCommon.NONE_POINT;

            Int32 nDiffer = nGameA - nGameB;
            Int32 nSeperateCount = m_nGamesCount / 2 + 1;

            if (((nGameA > m_nGamePoint - 2) || (nGameB > m_nGamePoint - 2)) && 
                (Math.Abs(nDiffer) == m_nAdvantageDiffer - 1) || 
                ((nGameA == m_nGamePoint - 1) && (nGameB < nGameA) && (Math.Abs(nDiffer) >= m_nAdvantageDiffer - 1)) || 
                ((nGameB == m_nGamePoint - 1) && (nGameA < nGameB) && (Math.Abs(nDiffer) >= m_nAdvantageDiffer - 1)))
            {
                if (nGameA > nGameB)
                {
                    if (nMatchA == nSeperateCount - 1)
                    {
                        nPointType = BDCommon.A_MATCHPOINT;
                    }
                    else
                    {
                        nPointType = BDCommon.A_GAMEPOINT;
                    }
                }
                else
                {
                    if (nMatchB == nSeperateCount - 1)
                    {
                        nPointType = BDCommon.B_MATCHPOINT;
                    }
                    else
                    {
                        nPointType = BDCommon.B_GAMEPOINT;
                    }
                }
            }
        }

        /// <summary>
        /// 获取是否需要改变service
        /// </summary>
        /// <param name="curType"></param>
        /// <param name="scoreHome"></param>
        /// <param name="scoreAway"></param>
        /// <returns></returns>
        public static ServiceType GetTableTennisService(ServiceType curType, int scoreHome, int scoreAway)
        {
            int sumScore = scoreHome + scoreAway;
            if ( curType == ServiceType.TypeServiceNULL )
            {
                return ServiceType.TypeServiceNULL;
            }
            if ( sumScore == 0 )
            {
                return ServiceType.TypeServiceNULL;
            }
            if ( scoreHome < 10 || scoreAway < 10)
            {
                if ( sumScore % 2 == 0 )
                {
                    if ( curType == ServiceType.TypeServiceA )
                    {
                        return ServiceType.TypeServiceB;
                    }
                    else
                    {
                        return ServiceType.TypeServiceA;
                    }
                }
                else
                {
                    return ServiceType.TypeServiceNULL;
                }
            }
            else
            {
                if (curType == ServiceType.TypeServiceA)
                {
                    return ServiceType.TypeServiceB;
                }
                else
                {
                    return ServiceType.TypeServiceA;
                }
            }
        }
        
        #endregion   
    }
}
