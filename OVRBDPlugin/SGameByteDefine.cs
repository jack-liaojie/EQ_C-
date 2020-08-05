using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

//2011大运会 羽毛球 计时计分 与 OVR 通讯协议

//2011-06-28	Created
namespace Badminton2011
{	
	[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi, Pack = 1)]
	public struct SGameByteInfo
	{
        const int MAX_MATCH = 5;
        const int MAX_SET = 7;

        //public byte m_byStart;				//should be '[' 为了兼容以前的协议，被征用为接发球方
        public byte m_byRecv;            //接发球方，参照EGbServe
        public Int32 m_nMatchID;			//外部ID

        public byte m_byCurSet;			//当前盘


        public byte m_byServe;				//球权,参照EGbServe

        [MarshalAs(UnmanagedType.ByValArray, SizeConst = MAX_MATCH)]
        public byte[] m_byCurGame;			//当前局

        //各种局信息
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = MAX_MATCH * MAX_SET)]
        public byte[] m_byScoreGameA;		//比分-局
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = MAX_MATCH * MAX_SET)]
        public byte[] m_byScoreGameB;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = MAX_MATCH * MAX_SET)]
        public byte[] m_byIrmGameA;		//判罚A方-局 参照EGbIRM
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = MAX_MATCH * MAX_SET)]
        public byte[] m_byIrmGameB;		//判罚B方-局
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = MAX_MATCH * MAX_SET)]
        public byte[] m_byWinTypeGame;		//获胜方式-局 参照EGbAbsWin
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = MAX_MATCH * MAX_SET)]
        public byte[] m_byWinResultGame;	//获胜结果-局 参照EGbTeam

        //各种盘信息

        [MarshalAs(UnmanagedType.ByValArray, SizeConst = MAX_MATCH)]
        public byte[] m_byScoreSetA;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = MAX_MATCH)]
        public byte[] m_byScoreSetB;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = MAX_MATCH)]
        public byte[] m_byIrmSetA;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = MAX_MATCH)]
        public byte[] m_byIrmSetB;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = MAX_MATCH)]
        public byte[] m_byWinTypeSet;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = MAX_MATCH)]
        public byte[] m_byWinResultSet;

        //各种赛结果

        public byte m_byScoreMatchA;
        public byte m_byScoreMatchB;
        public byte m_byIrmMatchA;
        public byte m_byIrmMatchB;
        public byte m_byWinTypeMatch;
        public byte m_byWinResultMatch;

        //Time
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = MAX_MATCH * MAX_SET)]
        public UInt32[] m_dwTime;		//以秒为单位


        //Others
        public byte m_byFlagA;			//判罚牌A方	参照EGbFlag
        public byte m_byFlagB;
        public byte m_byMatchStatus;	//比赛状态 参照EGbMatchStatus

        public byte m_byEnd; //should be ']'
	};
}
