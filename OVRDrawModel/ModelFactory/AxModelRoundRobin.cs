using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace AutoSports.OVRDrawModel
{
    public class AxModelRoundRobin : AxModelBase
    {
        public override String GetDumpStr()
        {
            String StrOut;
            String strMsg;

            // 1. 打印内部结构
            {
                strMsg = String.Format("我们共有{0:D}个人 \r\n", m_oGroup.GetPlayerCnt());
                StrOut = strMsg;

                for (Int32 nRound = 0; nRound < m_oGroup.GetRoundCount(); nRound++)
                {
                    stRrRound pRound = m_oGroup.GetRoundObj(nRound);
                    strMsg = String.Format("第{0:D}轮: \r\n", nRound + 1);
                    StrOut += strMsg;

                    for (Int32 nMatch = 0; nMatch < pRound.GetMatchCount(); nMatch++)
                    {
                        stRrMatch pMatch = pRound.GetMatchObj(nMatch);

                        strMsg = String.Format("Match[{0:D}-{1:D} {2:D} vs {3:D} ] ", nRound + 1, nMatch + 1,
                            pMatch.m_byPlayerL, pMatch.m_byPlayerR);
                        StrOut += strMsg;
                    }

                    StrOut += "\r\n";
                }

                StrOut += "\r\n";
            }

            // 2.打印输出结构
            {
                AxDrawModelMatchList aryMatch = new AxDrawModelMatchList();
                GetModelExport(aryMatch);

                for (Int32 nCycRow = 0; nCycRow < (Int32)aryMatch.m_aryMatchRow.Count; nCycRow++)
                {
                    AxDrawModelMatchRow pMatchRow = aryMatch.m_aryMatchRow[nCycRow];

                    strMsg = String.Format("{0:D} 第{1:D}轮-第{2:D}场", nCycRow + 1,
                        pMatchRow.m_byteRoundOrder, pMatchRow.m_byteMatchOrder);

                    //pMatchRow->nLeftFromLineOrIndex, pMatchRow->nLeftFromLineOrIndex, 
                    //pMatchRow->GetVsDesc() );

                    StrOut += strMsg;
                    StrOut += "\r\n";
                }

                StrOut += "\r\n";
            }

            return StrOut;
        }

        public override Boolean GetModelExport(AxDrawModelMatchList drawModelModel)
        {
            drawModelModel.RemoveAll();

            if (m_oGroup.GetPlayerCnt() < 1)
            {
                return false;
            }

            Int32 nRoundCnt = m_oGroup.GetRoundCount();
            for (Int32 nCycRound = 0; nCycRound < nRoundCnt; nCycRound++)
            {
                stRrRound pRound = m_oGroup.GetRoundObj(nCycRound);
                Int32 nMatchCnt = pRound.GetMatchCount();
                for (Int32 nCycMatch = 0; nCycMatch < nMatchCnt; nCycMatch++)
                {
                    stRrMatch pMatch = pRound.GetMatchObj(nCycMatch);

                    AxDrawModelMatchRow MatchRow = new AxDrawModelMatchRow();
                    MatchRow.m_nLeftFromLineOrIndex = pMatch.m_byPlayerL;
                    MatchRow.m_nRightFromLineOrIndex = pMatch.m_byPlayerR;
                    MatchRow.m_byteRoundOrder = (Byte)(nCycRound + 1);
                    MatchRow.m_byteMatchOrder = (Byte)(nCycMatch + 1);
                    MatchRow.m_emLayerCode = EDrawModelLayerCode.emLayerRound_RoundRobin;

                    drawModelModel.m_aryMatchRow.Add(MatchRow);
                }
            }

            return true;
        }

	    //nPlayerCnt: 参赛人数,最小2人,最大32人
	    //bUseBegol: 使用贝尔编排法
	    public Boolean Create(Int32 nPlayerCnt, Boolean bUseBegol)
        {
            // 1. 检测输入参数
            if (nPlayerCnt < 2 || nPlayerCnt > 32)
            {
                m_strLastError = "Err in CreateStage(): nPlayerCnt超出许可范围!";
                return false;
            }

            // 2. 创建新的Stage
            Boolean bRet = _Create(nPlayerCnt, bUseBegol);

            // 3.根据人数创建默认填坑表(位置设计表)
            {
                //循环赛目前不存在什么站位问题
                //填坑表可能是晋级的问题,现在先不考虑
            }

            return true;
        }

	    //返回最后一个产生的错误的中文描述
	    //如最后一个操作无错误,返回 _T("")
	    String GetLastError()
        {
            return m_strLastError;
        }

	    Int32 GetPlayerCnt()
        {
            return m_oGroup.GetPlayerCnt();
        }

	    Int32 GetPlayerResultCnt()
        {
            return m_oGroup.GetPlayerCnt();
        }
		
	    Boolean IsHaveBye()
        {
            return (GetPlayerCnt() % 2 == 1);
        }

        //单循环
	    protected Boolean _Create(Int32 nPlayerCnt, Boolean bUseBegol )
        {
            //2. 生成此轮中用的队员序列
            //CArray<int, int> aryRound;
            ArrayList aryRound = new ArrayList();
            int nPlayerCntInAry = 0;
            {
                for (Int32 nCycPlayer = 0; nCycPlayer < nPlayerCnt; nCycPlayer++)
                {
                    aryRound.Add(nCycPlayer + 1);	//从1开始
                }

                //如果队员是单数,添加轮空用的0号队
                if (nPlayerCnt % 2 == 1)
                {
                    if (bUseBegol)
                        aryRound.Add(0);	//贝格尔算法时,轮空加在最后
                    else
                        aryRound.Add(0);	//普通单循环,轮空加在最后	
                }

                nPlayerCntInAry = aryRound.Count;
                //ASSERT(nPlayerCntInAry % 2 == 0);
            }

            //3. 循环生成本组比赛对阵
            m_oGroup.SetPlayerCnt((Byte)nPlayerCnt); //为一个组手动 加上有多少只参赛队 的信息

            Int32 nRoundCnt = nPlayerCntInAry - 1; // 奇数时已经算上了轮空

            for (Int32 nRound = 0; nRound < nRoundCnt; nRound++)
            {
                stRrRound matchRound = new stRrRound();

                for (int nMatch = 0; nMatch < nPlayerCntInAry / 2; nMatch++)
                {
                    stRrMatch matchObj = new stRrMatch();
                    matchObj.m_byPlayerL = Convert.ToByte(aryRound[nMatch]);	//从前往后
                    matchObj.m_byPlayerR = Convert.ToByte(aryRound[nPlayerCntInAry - nMatch - 1]); //从后往前

                    //贝格尔算法下,奇数轮的第一场比赛,左右对调
                    if (bUseBegol && nRound % 2 == 1 && nMatch == 0)
                    {
                        Byte byTemp = matchObj.m_byPlayerL;
                        matchObj.m_byPlayerL = matchObj.m_byPlayerR;
                        matchObj.m_byPlayerR = byTemp;
                    }

                    matchRound.AddMatchObj(matchObj);
                }

                //把最后一位的数据挪到第二位,在贝格尔算法下,跳多位,相当于转多次
                if (!bUseBegol)
                {
                    Int32 nMoveTarget = Convert.ToInt32(aryRound[nPlayerCntInAry - 1]); //普通算法,就把最后一位挪到第二位
                    aryRound.RemoveAt(nPlayerCntInAry - 1);
                    aryRound.Insert(1, nMoveTarget);
                }
                else
                {
                    int nJump = _GetBegolJumpCnt(nPlayerCntInAry); //每次轮转的位数
                    for (int nCyc = 0; nCyc < nJump; nCyc++)
                    {
                        int nMoveTarget = Convert.ToInt32(aryRound[nPlayerCntInAry - 2]); //贝格尔,倒数第二位挪到第一位,挪多次
                        aryRound.RemoveAt(nPlayerCntInAry - 2);
                        aryRound.Insert(0, nMoveTarget);
                    }
                }

                m_oGroup.AddRoundObj(matchRound);
            }//For Round	

            m_bIsUseBegol = bUseBegol;
            return true;
        }

	    //在贝格尔循环下,每次从数组最后往前倒换几次
	    Int32 _GetBegolJumpCnt(Int32 nPlayerCnt)
        {
            if (nPlayerCnt < 4)
            {
                return 1;
            }

            int nJumpCnt = (nPlayerCnt + 1) / 2 - 1;
            return nJumpCnt;
        }

	    public AxModelRoundRobin()
        {
            m_bIsUseBegol = false;
        }

	    protected Boolean m_bIsUseBegol;
	    protected String m_strLastError;
	    protected stRrGroup m_oGroup = new stRrGroup();	//一个对象
    }
}
