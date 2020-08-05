using System;
using System.ComponentModel;

namespace OVRRUPlugin.ViewModel
{
    public class MatchMemberAndAction : INotifyPropertyChanged
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

        #region private Fields

        private int m_number;
        private string m_name;
        private int m_registerID;
        private int m_try;
        private int m_conversionGoal;
        private int m_conversionMiss;
        private int m_penaltyGoal;
        private int m_penaltyMiss;
        private int m_dropGoal;
        private int m_dropMiss;
        private int m_yellowCard;
        private int m_redCard;
        private int m_comPos;
        private bool m_active;

        #endregion

        #region Public Properties

        public int Number
        {
            get { return m_number; }
            set
            {
                if (value != m_number)
                {
                    m_number = value;
                    NotifyPropertyChanged("Number");
                }
            }
        }

        public string Name
        {
            get { return m_name; }
            set
            {
                if (value!= m_name)
                {
                    m_name = value;
                    NotifyPropertyChanged("Name");
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

        public int TRY
        {
            get { return m_try; }
            set
            {
                if (value != m_try)
                {
                    m_try = value;
                    NotifyPropertyChanged("TRY");
                }
            }
        }

        public int ConversionGoal
        {
            get { return m_conversionGoal; }
            set
            {
                if (m_conversionGoal != value)
                {
                    m_conversionGoal= value;
                    NotifyPropertyChanged("ConversionGoal");
                }
            }
        }

        public int ConversionMiss
        {
            get { return m_conversionMiss; }
            set
            {
                if (m_conversionMiss != value)
                {
                    m_conversionMiss = value;
                    NotifyPropertyChanged("ConversionMiss");
                }
            }
        }

        public int PenaltyGoal
        {
            get { return m_penaltyGoal; }
            set
            {
                if (value != m_penaltyGoal)
                {
                    m_penaltyGoal = value;
                    NotifyPropertyChanged("PenaltyGoal");
                }
            }
        }

        public int PenaltyMiss
        {
            get { return m_penaltyMiss; }
            set {
                if (value != m_penaltyMiss)
                {
                    m_penaltyMiss = value;
                    NotifyPropertyChanged("PenaltyMiss");
                }
            }
        }

        public int DropGoal
        {
            get { return m_dropGoal; }
            set
            {
                if (value != m_dropGoal)
                {
                    m_dropGoal = value;
                    NotifyPropertyChanged("DropGoal");
                }
            }
        }

        public int DropMiss
        {
            get { return m_dropMiss; }
            set
            {
                if (m_dropMiss != value)
                {
                    m_dropMiss = value;
                    NotifyPropertyChanged("DropMiss");
                }
            }

        }

        public int YellowCard
        {
            get { return m_yellowCard; }
            set
            {
                if (m_yellowCard != value)
                {
                    m_yellowCard = value;
                    NotifyPropertyChanged("YellowCard");
                }
            }
        }

        public int RedCard
        {
            get { return m_redCard; }
            set
            {
                if (value != m_redCard)
                {
                    m_redCard = value;
                    NotifyPropertyChanged("RedCard");
                }
            }
        }

        public int ComPos
        {
            get { return m_comPos; }
            set
            {
                if (value != m_comPos)
                {
                    m_comPos = value;
                    NotifyPropertyChanged("ComPos");
                }
            }
        }

        public bool Active
        {
            get { return m_active; }
            set
            {
                if (value != m_active)
                {
                    m_active = value;
                    NotifyPropertyChanged("Active");
                }
            }
        }
        
        #endregion

    }
}
