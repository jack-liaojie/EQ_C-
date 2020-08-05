using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoSports.OVRSEPlugin
{
    public interface IDataProcess
    {
        string LastErrorMessage{ get;set;}
        bool ProcessData(object task);
    }
}
