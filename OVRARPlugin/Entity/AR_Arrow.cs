using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoSports.OVRARPlugin
{

    public class AR_Arrow
    {
        private int _matchid;
        private int _splitid;
        private int _fathersplitid;
        private int _competitionposition;
        private string _rings;
        private string _index;
        private string _endIndex;

        public int MatchID
        {
            get { return _matchid; }
            set { _matchid = value; }
        }
        public int SplitID
        {
            get { return _splitid; }
            set { _splitid = value; }
        }
        public int FatherSplitID
        {
            get { return _fathersplitid; }
            set { _fathersplitid = value; }
        }
        public int CompetitionPosition
        {
            get { return _competitionposition; }
            set { _competitionposition = value; }
        }
        public string Ring
        {
            get { return _rings; }
            set { _rings = value; }
        }
        public string ArrowIndex
        {
            get { return _index; }
            set { _index = value; }
        }
        public string EndIndex
        {
            get { return _endIndex; }
            set { _endIndex = value; }
        }

    }
}
