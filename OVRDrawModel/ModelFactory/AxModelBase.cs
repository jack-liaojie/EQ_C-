using System;
using System.Collections.Generic;
using System.Text;

namespace AutoSports.OVRDrawModel
{
    public abstract class AxModelBase
    {
        public abstract String GetDumpStr();
	    public abstract Boolean GetModelExport(AxDrawModelMatchList drawModelModel);
    }
}
