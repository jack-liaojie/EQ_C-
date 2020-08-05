using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;

namespace AutoSports.OVRBDPlugin.MatchNavigate
{
    public class BaseViewModel
    {
        public event PropertyChangedEventHandler PropertyChanged;

        protected void NotifyPropertyChanged(String propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }
    }
}
