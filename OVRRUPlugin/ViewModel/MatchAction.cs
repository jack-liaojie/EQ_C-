using System;
using System.ComponentModel;

namespace OVRRUPlugin.ViewModel
{
    public class MatchAction : INotifyPropertyChanged
    {
        #region private fields

        private int m_actionNumberID;

        private int m_matchID;
        private int m_compos;
        private int m_registerID;

        //private int m_registerID_Home;
        //private int m_registerID_Away;
        //private string m_noc_Home;
        //private string m_noc_Away;
        private string m_nocAndShirtNumber_Home;
        private string m_nocAndShirtNumber_Away;

        private int m_matchSplitID;
        private int m_scoreHome;
        private int m_scoreAway;
        private int m_shirtNmber;
        private int m_actionTypeID;
        private int m_period;

        private string m_actionTypeName;
        private string m_matchTime;
        private string m_noc;
        private string m_periodName;
        private string m_actionTypeCode;

        #endregion

        #region public properties

        public int ActionNumberID
        {
            get { return m_actionNumberID; }
            set { m_actionNumberID = value; }
        }

        public string ActionTypeCode
        {
            get { return m_actionTypeCode; }
            set
            {
                if (value != m_actionTypeCode)
                {
                    m_actionTypeCode = value;
                    NotifyPropertyChanged("ActionTypeCode");
                }
            }
        }

        public int MatchID
        {
            get { return m_matchID; }
            set
            {
                if (value != m_matchID)
                {
                    m_matchID = value;
                    NotifyPropertyChanged("MatchID");
                }
            }
        }

        public int ComPos
        {
            get { return m_compos; }
            set
            {
                if (m_compos != value)
                {
                    m_compos = value;
                    NotifyPropertyChanged("ComPos");
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
                    NotifyPropertyChanged("NocAndReg");
                }
            }
        }

        public int MatchSplitID
        {
            get { return m_matchSplitID; }
            set
            {
                if (value != m_matchSplitID)
                {
                    m_matchSplitID = value;
                    NotifyPropertyChanged("MatchSplitID");
                }
            }
        }

        public string MatchScore
        {
            get { return m_scoreHome.ToString() + ":" + m_scoreAway.ToString(); }
        }

        public int ScoreHome
        {
            get { return m_scoreHome; }
            set
            {
                if (value != m_scoreHome)
                {
                    m_scoreHome = value;
                    NotifyPropertyChanged("ScoreHome");
                    NotifyPropertyChanged("MatchScore");
                }
            }
        }

        public int ScoreAway
        {
            get { return m_scoreAway; }
            set
            {
                if (value != m_scoreAway)
                {
                    m_scoreAway = value;
                    NotifyPropertyChanged("ScoreAway");
                    NotifyPropertyChanged("MatchScore");
                }
            }
        }

        public String ScoreString
        {
            get { return m_scoreHome.ToString() + ":" + m_scoreAway.ToString(); }
        }

        public int ShirtNumber
        {
            get { return m_shirtNmber; }
            set
            {
                if (value != m_shirtNmber)
                {
                    m_shirtNmber = value;
                    NotifyPropertyChanged("ShirtNumber");
                }
            }
        }

        public int ActionTypeID
        {
            get { return m_actionTypeID; }
            set
            {
                if (value != m_actionTypeID)
                {
                    m_actionTypeID = value;
                    NotifyPropertyChanged("ActionTypeID");
                }
            }
        }

        public int Period
        {
            get { return m_period; }
            set
            {
                if (m_period != value)
                {
                    m_period = value;
                    NotifyPropertyChanged("Period");
                }
            }
        }

        public string PeriodName
        {
            get { return m_periodName; }
            set
            {
                if (m_periodName != value)
                {
                    m_periodName = value;
                    NotifyPropertyChanged("PeriodName");
                }
            }
        }

        public string ActionTypeName
        {
            get { return m_actionTypeName; }
            set
            {
                if (value != m_actionTypeName)
                {
                    m_actionTypeName = value;
                    NotifyPropertyChanged("ActionTypeName");
                }
            }
        }

        public string MatchTime
        {
            get { return m_matchTime; }
            set
            {
                if (m_matchTime != value)
                {
                    m_matchTime = value;
                    NotifyPropertyChanged("MatchTime");
                }
            }
        }

        public string Noc
        {
            get { return m_noc; }
            set
            {
                if (m_noc != value)
                {
                    m_noc = value;
                    NotifyPropertyChanged("Noc");
                    NotifyPropertyChanged("NocAndReg");
                }
            }
        }

        public string NocAndShirtNumber_Home
        {
            get { return m_nocAndShirtNumber_Home; }
            set
            {
                if (m_nocAndShirtNumber_Home != value)
                {
                    m_nocAndShirtNumber_Home = value;
                    NotifyPropertyChanged("NocAndReg_Home");
                }
            }
        }

        public string NocAndShirtNumber_Away
        {
            get { return m_nocAndShirtNumber_Away; }
            set
            {
                if (m_nocAndShirtNumber_Away != value)
                {
                    m_nocAndShirtNumber_Away = value;
                    NotifyPropertyChanged("NocAndReg_Away");
                }
            }
        }

        #endregion

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

    }
}
