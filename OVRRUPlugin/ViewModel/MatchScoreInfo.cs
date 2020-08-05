using System;
using System.ComponentModel;

namespace OVRRUPlugin.ViewModel
{
    public class MatchScoreInfo:INotifyPropertyChanged
    {
        #region INotifyPropertyChanged Members

        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(String info)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(info));
            }
        }

        #endregion

        #region constructor

        public MatchScoreInfo() { }


        #endregion

        #region Private Fields

        private string m_noc;
        private string m_teamName;
        private int m_scoreTotal;
        private int m_scoreFirst;
        private int m_scoreSecond;
        private int m_scoreExt;

        private string m_teamLongName;
        private int m_registerID;

        private int m_rankID;
        private int m_resultID;

        private int m_tryNum;
        

        #endregion

        #region Public Properties

        public int TryNum
        {
            get { return m_tryNum; }
            set
            {
                if (m_tryNum != value)
                {
                    m_tryNum = value;
                    NotifyPropertyChanged("TryNum");
                }
            }
        }


        public int RankID
        {
            get { return m_rankID; }
            set
            {
                if (m_rankID != value)
                {
                    m_rankID = value;
                    NotifyPropertyChanged("RankID");
                }
            }
        }

        public int ResultID
        {
            get { return m_resultID; }
            set
            {
                if (m_resultID != value)
                {
                    m_resultID = value;
                    NotifyPropertyChanged("ResultID");
                }
            }
        }

        public int RegisterID
        {
            get { return m_registerID; }
            set
            {
                if (value != m_registerID)
                {
                    m_registerID = value;
                    NotifyPropertyChanged("RegisterID");
                }
            }
        }

        public string NOC
        {
            get { return m_noc; }
            set 
            {
                if (m_noc != value)
                {
                    m_noc = value;
                    NotifyPropertyChanged("NOC");
                }
            }
        }

        public string TeamName
        {
            get { return m_teamName; }
            set
            {
                if (value != m_teamName)
                {
                    m_teamName = value;
                    NotifyPropertyChanged("TeamName");
                }
            }
        }

        public string TeamLongName
        {
            get { return m_teamLongName; }
            set
            {
                if (m_teamLongName != value)
                {
                    m_teamLongName = value;
                    NotifyPropertyChanged("TeamLongName");
                }
            }
        }

        public int ScoreTotal
        {
            get { return m_scoreTotal; }
            set
            {
                if(value!=m_scoreTotal)
                {
                    m_scoreTotal=value;
                    NotifyPropertyChanged("ScoreTotal");
                }
            }
        }

        public int ScoreFirst
        {
            get { return m_scoreFirst; }
            set
            {
                if (value != m_scoreFirst)
                {
                    m_scoreFirst = value;
                    NotifyPropertyChanged("ScoreFirst");
                    if (m_scoreFirst <= 0)
                    {
                        ScoreFirst = 0;
                    }
                }
            }
        }

        public int ScoreSecond
        {
            get { return m_scoreSecond; }
            set
            {
                if (value != m_scoreSecond)
                {
                    m_scoreSecond = value;
                    NotifyPropertyChanged("ScoreSecond");
                    if (m_scoreSecond <= 0)
                    {
                        ScoreSecond = 0;
                    }
                }
            }
        }

        public int ScoreExt
        {
            get { return m_scoreExt; }
            set
            {
                if (value != m_scoreExt)
                {
                    m_scoreExt = value;
                    NotifyPropertyChanged("ScoreExt");
                    if (m_scoreExt <= 0)
                    {
                        ScoreExt = 0;
                    }
                }
            }
        }

        #endregion

    }
}
