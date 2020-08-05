using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoSports.OVRARPlugin
{

    public class AR_Archer
    {
        private int _registerID;
        private string _name;
        private string _bib;
        private string _noc;
        private string _sex;
        private string _qrank;
        private string _target;
        private List<AR_End> _shootends;
        private List<AR_End> _ends;
        private List<AR_Arrow> _arrows;
        private List<AR_Archer> _archers;
        private string _total;
        private string _10s;
        private string _Xs;
        private string _totalLongA;
        private string _totalLongB;
        private string _totalShortA;
        private string _totalShortB;
        private string _result;
        private string _IRM;
        private int _position;
        private int _matchid;
        private int _competitionposition;
        private int _rowIndex;
        private string _remark;
        private string _records;
        private string _comment;
        private string _shootOff;

        public int MatchID
        {
            get { return _matchid; }
            set { _matchid = value; }
        }

        public int CompetitionPosition
        {
            get { return _competitionposition; }
            set { _competitionposition = value; }
        }
        public int RegisterID
        {
            get { return _registerID; }
            set { _registerID = value; }
        }

        public int RowIndex
        {
            get { return _rowIndex; }
            set { _rowIndex = value; }
        }

        public string Name
        {
            get { return _name; }
            set { _name = value; }
        }
        public string Bib
        {
            get { return _bib; }
            set { _bib = value; }
        }

        public string Noc
        {
            get { return _noc; }
            set { _noc = value; }
        }

        public string Sex
        {
            get { return _sex; }
            set { _sex = value; }
        }
        public string QRank
        {
            get { return _qrank; }
            set { _qrank = value; }
        }


        public List<AR_End> ShootEnds
        {
            get { return _shootends; }
            set { _shootends = value; }
        }
        public List<AR_End> Ends
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

        public string Num10S
        {
            get { return _10s; }
            set { _10s = value; }
        }
        public string NumXS
        {
            get { return _Xs; }
            set { _Xs = value; }
        }
        public string Total
        {
            get { return _total; }
            set { _total = value; }
        }
        public string TotalLongA
        {
            get { return _totalLongA; }
            set { _totalLongA = value; }
        }
        public string TotalLongB
        {
            get { return _totalLongB; }
            set { _totalLongB = value; }
        }
        public string TotalShortA
        {
            get { return _totalShortA; }
            set { _totalShortA = value; }
        }
        public string TotalShortB
        {
            get { return _totalShortB; }
            set { _totalShortB = value; }
        }
        public string Result
        {
            get { return _result; }
            set { _result = value; }
        }
        public int DisplayPosition
        {
            get { return _position; }
            set { _position = value; }
        }
        public string IRM
        {
            get { return _IRM; }
            set { _IRM = value; }
        }

        public string Remark
        {
            get { return _remark; }
            set { _remark = value; }
        }
        public string Records
        {
            get { return _records; }
            set { _remark = value; }
        }
        public string Comment
        {
            get { return _comment; }
            set { _comment = value; }
        }
        public string ShootOff
        {
            get { return _shootOff; }
            set { _shootOff = value; }
        }
        public List<AR_Archer> Members
        {
            get { return _archers; }
            set { _archers = value; }
        }
        public string GetTatalRings()
        {
            int LA = ARFunctions.ConvertToIntFromObject(_totalLongA);
            int LB = ARFunctions.ConvertToIntFromObject(_totalLongB);
            int SA = ARFunctions.ConvertToIntFromObject(_totalShortA);
            int SB = ARFunctions.ConvertToIntFromObject(_totalShortB);
            int tempTotal = LA + LB + SA + SB;
            return tempTotal == 0 ? "" : tempTotal.ToString();
        }
    }
}
