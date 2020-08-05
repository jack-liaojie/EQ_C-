using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;

namespace AutoSports.OVRVBPlugin
{
	[DefaultPropertyAttribute("Name")]
	public class cPropertyGridClass
	{
		[CategoryAttribute("比赛"), DescriptionAttribute("比赛结束时间")]
		public string MatchEndTime
		{
			get
			{
				return Common.dbMatchTimeEndGet();
			}
			set
			{
				Common.dbMatchTimeEndSet(value);
				Common.dbMatchModifyTimeSet();
			}
		}

		[CategoryAttribute("比赛"), DescriptionAttribute("观众人数")]
		public string Spectators
		{
			get
			{
				return Common.dbSpectatorGet();
			}
			set
			{
				Common.dbSpectatorSet(value);
				Common.dbMatchModifyTimeSet();
			}
		}

		public cPropertyGridClass()
		{

		}
	}


}
