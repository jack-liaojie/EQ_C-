using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace OVRDVPlugin.TSInterface
{
    public class ScoreInfo : DataTable
    {
        public ScoreInfo()
        {
            //m_dt = new DataTable();
            //this.Columns.Add("KK")
        }
        public void AddValue(string fieldName, string filedValue)
        {
            if (!this.Columns.Contains(fieldName))
            {
                this.Columns.Add(fieldName);
            }

            if (this.Rows.Count == 0)
            {
                DataRow dr = this.NewRow();
                dr[fieldName] = filedValue;
                this.Rows.Add(dr);
            }
            else
            {
                DataRow dr = this.Rows[0];
                dr[fieldName] = filedValue;
            }
        }
    }

    public class TSMatchInfo
    {
        public TSMatchInfo()
        {
            m_startInfo = new PlayerStartInfo();
            m_scoreInfo = new ScoreInfo();
        }
        private PlayerStartInfo m_startInfo;
        private ScoreInfo m_scoreInfo;
        private RankList m_rankInfo;
        public PlayerStartInfo StartInfo
        {
            get { return m_startInfo; }
        }

        public RankList RankInfo
        {
            get { return m_rankInfo; }
        }

        public ScoreInfo ScoreInfo
        {
            get { return m_scoreInfo; }
        }

        public void ReInitJudgeScore()
        {
            m_scoreInfo = new ScoreInfo();
        }

        public void ReInitRankInfo()
        {
            m_rankInfo = new RankList();
        }
    }

    public class PlayerStartInfo
    {
        public string RoundNumber;
        public string BibNumber;
        public string StartNumber;
        public string DiveCode;
        public string Difficulty;
        public string Height;
        public string Points;
        public string Rank;
        public string PlayerName;
        public string NOC;
    }

    

    public class RankList : DataTable
    {
        public RankList()
        {
            this.Columns.Add("Code");
            this.Columns.Add("Rank");
            this.Columns.Add("Name");
            this.Columns.Add("NOC");
            this.Columns.Add("Points");
        }
        public void AddValue(string strCode ,string fieldName, string strValue)
        {
            DataRow dr = null;
            bool bExists = false;
            for (int i = 0; i < this.Rows.Count; i++ )
            {
                dr = this.Rows[i];
                if ( (string)dr["Code"] == strCode)
                {
                    bExists = true;
                    break;
                }
            }
            if ( !bExists )
            {
                dr = this.NewRow();
                dr["Code"] = strCode;
                this.Rows.Add(dr);
            }

            dr[fieldName] = strValue;
        }
    }
}
