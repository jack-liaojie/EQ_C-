using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoSports.OVRBDPlugin
{
    public class AutoGenerateScore
    {
        private bool m_isTeam;
        private bool m_finishFullSets;
        private int m_maxSetCount;
        private int m_maxGameCount;
        private Random m_rand;
        private int m_gamePoints;
        public AutoGenerateScore(bool isTeam, bool finishFullSets, int setMaxCount, int gameMaxCount, int gameMaxPoint)
        {
            m_isTeam = isTeam;
            m_finishFullSets = finishFullSets;
            m_maxSetCount = setMaxCount;
            m_maxGameCount = gameMaxCount;
            m_rand = new Random(DateTime.Now.Millisecond);
            m_gamePoints = gameMaxPoint;
        }

        public SetScore GetRandomScoreSet()
        {
            if ( m_isTeam )
            {
                return null;
            }
            SetScore setScore = new SetScore();
            setScore.RandomScore(m_rand, m_maxGameCount);
            int[] gameArray = GetRandomWinnerArray(m_rand, setScore.SetScoreA, setScore.SetScoreB);
            foreach (int winGameA in gameArray)
            {
                GameScore gameScore = new GameScore();
                gameScore.RandomScore(m_rand, m_gamePoints, Probability(10), winGameA);
                setScore.Add(gameScore);
            }
            return setScore;
        }

        public MatchScore GetRandomScoreTeam()
        {
            if ( !m_isTeam)
            {
                return null;
            }
            MatchScore matchScore = new MatchScore();
            matchScore.RandomScore(m_rand, m_maxSetCount, m_finishFullSets );//随机大比分分数和胜负
            int[] winArray = GetRandomWinnerArray(m_rand, matchScore.MatchScoreA, matchScore.MatchScoreB, m_finishFullSets);//根据比分，随机一个Set胜负数组
            foreach ( int winSetA in winArray )
            {
                SetScore setScore = new SetScore();
                setScore.RandomScore(m_rand, m_maxGameCount, winSetA); //随机一个Set比分
                int[] gameArray = GetRandomWinnerArray(m_rand, setScore.SetScoreA, setScore.SetScoreB ); //根据随机的Set比分随机一个Game胜负数组
                foreach ( int winGameA in gameArray )
                {
                    GameScore gameScore = new GameScore();
                    gameScore.RandomScore(m_rand, m_gamePoints, Probability(10), winGameA);//给予10%的概率出现追分
                    setScore.Add(gameScore);
                }
                matchScore.Add(setScore);
            }
            return matchScore;
        }

        private bool Probability(int rate)
        {
            int res = m_rand.Next(100);
            if ( res < rate )
            {
                return true;
            }
            return false;
        }

        private int[] GetRandomWinnerArray(Random rand, int scoreA, int scoreB, bool bFullSets = false)
        {
            int[] resArray = new int[scoreA+scoreB];
            //如果不是打满所有盘的比赛，最后一盘必须是分数大者获胜
            if ( !bFullSets )
            {
                resArray[scoreA + scoreB - 1] = scoreA > scoreB ? 1 : 2;
                if (scoreA > scoreB)
                {
                    scoreA--;
                }
                else
                {
                    scoreB--;
                }
            }
            
            int n = scoreA + scoreB;//共有n个位置需要随机
            int m = scoreA < scoreB? scoreA: scoreB;

            int inMValue = scoreA < scoreB? 1 : 2;
            int outMValue = scoreA < scoreB? 2 : 1;
            for(int i = 0; i < n; i++)
            {
                if(m > 0 && rand.Next(n-i) < m)
                {
                    resArray[i] = inMValue;
                    m--;
                }
                else
                {
                    resArray[i] = outMValue;
                }
            }
            return resArray;
        }
    }

    public class GameScore
    {
        public int GameScoreA;
        public int GameScoreB;
        public int Winner;

        public void RandomScore(Random rand, int maxGamePoints, bool bExceedMaxPoints, int fixWinner = 0)
        {
            Winner = fixWinner == 0? rand.Next(1,3): fixWinner;
            int maxPoints = bExceedMaxPoints? rand.Next(maxGamePoints+1, maxGamePoints+4): maxGamePoints;
            if ( Winner == 1 )
            {
                GameScoreA = maxPoints;
                GameScoreB = bExceedMaxPoints?GameScoreA-2:rand.Next(maxGamePoints-1);
            }
            else
            {
                GameScoreB = maxPoints;
                GameScoreA = bExceedMaxPoints?GameScoreB-2:rand.Next(maxGamePoints-1);
            }
        }
    }

    public class SetScore : List<GameScore>
    {
        public int SetScoreA;
        public int SetScoreB;
        public int Winner;

        public void RandomScore(Random rand, int gameCount, int fixWinner = 0 )
        {
            Winner = fixWinner ==0? rand.Next(1, 3):fixWinner;
            if ( Winner == 1 )
            {
                SetScoreA = gameCount / 2 + 1;
                SetScoreB = rand.Next(SetScoreA);
            }
            else
            {
                SetScoreB = gameCount / 2 + 1;
                SetScoreA = rand.Next(SetScoreB);
            }
        }
    }
    public class MatchScore : List<SetScore>
    {
        public int MatchScoreA;
        public int MatchScoreB;
        public int Winner;

        public void RandomScore(Random rand, int setCount, bool bFinishAllSet, int fixWinner = 0)
        {
            Winner = fixWinner == 0? rand.Next(1, 3):fixWinner;
            if ( bFinishAllSet)
            {
                if ( Winner == 1 )
                {
                    MatchScoreA = rand.Next(setCount / 2 + 1, setCount + 1);
                    MatchScoreB = setCount - MatchScoreA;
                }
                else
                {
                    MatchScoreB = rand.Next(setCount / 2 + 1, setCount + 1);
                    MatchScoreA = setCount - MatchScoreB;
                }
            }
            else
            {
                if (Winner == 1)
                {
                    MatchScoreA = setCount / 2 + 1;
                    MatchScoreB = rand.Next(MatchScoreA);
                }
                else
                {
                    MatchScoreB = setCount / 2 + 1;
                    MatchScoreA = rand.Next(MatchScoreB);
                }
            }
           
        }
    }
}
