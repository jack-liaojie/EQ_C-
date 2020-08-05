using System;
using System.Collections.Generic;
using System.Text;

namespace AutoSports.OVRDrawModel
{
    public enum EShowType
    {
        emShowMain = 0,		      //欢迎页
        emShowGroupM,		      //设置多小组	
        emShowKnockM,		      //设置多淘汰
        emShowKnockSingle,	      //设置单淘汰
        emShowKnockMFinal,	      //设置多淘汰，特殊的，能分1-4名，5-8名的
    }

    public enum EUseEventModel
    {
        emModelKnockOut = 0,	//淘汰赛
        emModelGroup,		    //小组赛
        emModelmGtoK,		    //多组去单淘汰
        emModelmKtoK,		    //多淘汰去单淘汰
        emModelmGtomK,		    //多组去多淘汰
    }
}
