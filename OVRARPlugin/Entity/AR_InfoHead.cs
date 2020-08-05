using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoSports.OVRARPlugin
{
    public class AR_InfoHead
    {
        private int _headMark;
        public int HeadMark
        {
            get { return _headMark; }
            set { _headMark = value; }
        }
        private int _taskNum;
        public int TaskNum
        {
            get { return _taskNum; }
            set { _taskNum = value; }
        }
        private int _confirmMark;
        public int ConfirmMark
        {
            get { return _confirmMark; }
            set { _confirmMark = value; }
        }
        private int _infoLength;
        public int InfoLength
        {
            get { return _infoLength; }
            set { _infoLength = value; }
        } 
        private int _endMark;
        public int EndMark
        {
            get { return _endMark; }
            set { _endMark = value; }
        }
    }
}
