using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoSports.OVRARPlugin
{
    public class AR_End
    {
        private string _endName;
        private List<AR_Arrow> _arrows;
        private string _point;
        private string _total;
        private string _10Num;
        private string _Xnum;
        private int _splitgroup;
        private string _endIndex;
        private int _matchid;
        private int _splitid;
        private int _competitionposition;
        private string _endComment;

        public string endName
        {
            get { return _endName; }
            set { _endName = value; }
        }

        public string Point
        {
            get { return _point; }
            set { _point = value; }
        }

        public string R10Num
        {
            get { return _10Num; }
            set { _10Num = value; }
        }

        public string Xnum
        {
            get { return _Xnum; }
            set { _Xnum = value; }
        }

        public int SplitGroup
        {
            get { return _splitgroup; }
            set { _splitgroup = value; }
        }
        public List<AR_Arrow> Arrows
        {
            get { return _arrows; }
            set { _arrows = value; }
        }

        public string Total
        {
            get { return _total; }
            set { _total = value; }
        }

        public string EndComment
        {
            get { return _endComment; }
            set { _endComment = value; }
        }


        public string EndIndex
        {
            get { return _endIndex; }
            set { _endIndex = value; }
        }
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
        public int CompetitionPosition
        {
            get { return _competitionposition; }
            set { _competitionposition = value; }
        }

        public int GetTotal()
        {
            int _total = 0;
            if (_arrows.Count > 0)
            {
                foreach (AR_Arrow ar in _arrows)
                {
                    int curArrow = 0;
                    if (ar.Ring.ToUpper() == "X")
                        curArrow = 10;
                    if (ar.Ring.ToUpper() == "M")
                        curArrow = 0;
                    else curArrow = ARFunctions.ConvertToIntFromString(ar.Ring);
                    _total += curArrow;
                }
            }

            return _total;
        }
    }
}
