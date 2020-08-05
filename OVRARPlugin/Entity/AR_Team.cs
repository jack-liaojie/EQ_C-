using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoSports.OVRARPlugin
{


    public class AR_Team
    {
        private int _registerID;
        private string _name;
        private string _noc;
        private int _qrank;
        private List<AR_Archer> _archers;
        private string _target;
        private List<AR_End> _ends;
        private List<AR_Arrow> _arrows;
        private int _total;
        private int _result;

        public int RegisterID
        {
            get { return _registerID; }
            set { _registerID = value; }
        }
        public List<AR_Archer> Archers
        {
            get { return _archers; }
            set { _archers = value; }
        }

        public string Name
        {
            get { return _name; }
            set { _name = value; }
        }

        public string Noc
        {
            get { return _noc; }
            set { _noc = value; }
        }

        public int QRank
        {
            get { return _qrank; }
            set { _qrank = value; }
        }

        public List<AR_End> ends
        {
            get { return _ends; }
            set { _ends = value; }
        }

        public string Target
        {
            get { return _target; }
            set { _target = value; }

        }
        public List<AR_Arrow> Arrows
        {
            get { return _arrows; }
            set { _arrows = value; }
        }

        public int Total
        {
            get { return _total; }
            set { _total = value; }
        }
        public int Result
        {
            get { return _result; }
            set { _result = value; }
        }
    }
}
