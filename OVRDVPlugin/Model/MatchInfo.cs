using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OVRDVPlugin.Model
{
    public enum MatchGroupType : int
    {
        General = 1,
        Detail = 2,
    }
    public class MatchRound
    {
        public int RoundID;
        public int RoundOrder;
    }
    public class JudgeGroup
    {
        public string JudgeGroupCode;
        public int JudgeGroupID;
        public string JudgeGroupFormat;
        public bool HasMultiPoints;
        public string JudgeGroupRqFormat;
    }

    public class JudgeGroupPoint
    {
        public JudgeGroupPoint()
        {
            GroupShowFactor = 1.0;
        }
        public string PointType;
        public string PointFormat;

        public double GroupShowFactor;
    }

    public class JudgePointCell
    {
        public string JudgeCode;
        public double Points;
        public string DataFormat;
        public int ScoreStatusID;
        public bool BReadOnly;
        public int JudgeOrder;

        public double TotalPoints;
        public double RqPoints;
    }

    public class Judge
    {
        public int Order;
        public string DataFormat;
        public string JudgeCode;
    }

}
