using System;
using System.Collections;
using System.Text;
using System.Data;
using System.Windows.Forms;
using System.Collections.Generic;
using System.Diagnostics;

//编排公共内容

// SAxDrawModelEvent 整个赛事描述
//		┣ ,nTempEventID 整个赛事的数据库ID
//		┣ <AryDrawModelPlayerFrom> 赛事的比赛结果排名来源,整个Events产生多少个排名,就有多少个
//		┃		 ┣, (SAxDrawModelPlayerFrom)
//		┃		 ┃			 ┣, byStageOrder;	 位于哪个阶段
//		┃		 ┃			 ┣, byModelOrder; 	 位于此阶段的哪个模型
//		┃		 ┃			 ┣, byResultRank;     位于模型输出的第几名
//		┃		 ┃			 ┗, nTempFromModelID; 把目标结构的数据库ID放在这里,方便插入使用
//		┃		 ┃
//		┃		 ┣, (SAxDrawModelPlayerFrom)
//		┃		 ┗, (SAxDrawModelPlayerFrom)
//		┃			
//		┃		
//		┗ <AryModelStage> 阶段信息列表	
//				 ┣, (SAxDrawModelStage)
//				 ┃			 ┣, nTempStageID;	为保存数据库方便,这个阶段的ID
//				 ┃			 ┣, strStageName;	阶段标题
//				 ┃			 ┗, <AryDrawModelModelExport>	这个阶段中的所有模型
//				 ┃		 					┣, (SAxDrawModelModelExport)
//				 ┃							┃			 ┣, nTempModelID	 	 	  这个模型的数据库ID
//				 ┃							┃			 ┣, (SAxDrawModelInfo)		  基本信息
//				 ┃							┃			 ┣, (SAxDrawModelModel)	  一个模型中所有比赛列表
//				 ┃							┃			 ┗, <AryDrawModelPlayerFrom> 队员来源信息
//				 ┃							┃
//				 ┃							┃
//				 ┃		 					┣, (SAxDrawModelModelExport)
//				 ┃		 					┗, (SAxDrawModelModelExport)
//				 ┃	
//				 ┃	
//				 ┣, (SAxDrawModelStage)
//				 ┗, (SAxDrawModelStage)



namespace AutoSports.OVRDrawModel
{
    //主要为数据库方便标识使用 对应PhaseType
    //指出数据中PhaseType是什么类型

    public enum EDrawModelType
    {
        emTypeNone = 0,				//未初始化
        emTypeManual,				//手工比赛
        emTypeRoundRobin,			//循环赛模型
        emTypeKonckOut,				//淘汰赛模型

        emTypeRoundRobinRound = 21,	//循环赛轮
        emTypeKnockOutRound = 31,		//淘汰赛轮
    }

    //主要为插入数据库使用 对应PhaseCode
    //数据库中Phase为嵌套利用，表明每一层的概念
    public enum EDrawModelLayerCode
    {
        emLayerNone = 0,	//未初始化
        emLayerStage,	//Stage,	预赛,决赛
        emLayerDraw,	//Draw,		小组赛,淘汰赛


        emLayerRound_RoundRobin = 11,	//RoundRobin中的一轮，11-30为RoundBobin轮描述


        emLayerRound_2to1 = 31,	//KnockOut中的一轮, 金字塔最顶尖的比赛 31-50为KnockOut轮描述
        emLayerRound_4to2,
        emLayerRound_8to4,
        emLayerRound_16to8,
        emLayerRound_32to16,
        emLayerRound_64to32,
        emLayerRound_128to64,
        emLayerRound_256to128,
        emLayerRound_512to256,

        emLayerRound_34to3 = 41,	//3,4名争第三名

        emLayerRound_58to56,
        emLayerRound_56to5,
        emLayerRound_78to7,
    }

    //淘汰赛中，根据本场的输赢，定下一场比赛的位置
    public enum EMatchResult
    {
        emResultNone = 0,	//未知
        emResultWin,	    //赢
        emResultLost,	    //输
        emResultDraw,	    //平
    }

    //KnockOut类型中，此场比赛选手来源类型
    public enum EKnockOutFromKind
    {
        emKoFromNone = 0,	//未初始化
        emKoFromInit,	    //最底层的來自DrawNumber, 序号为m_n*FromLine    // -1时表BYE *：Left or Right
        emKoFromWin,	    //来自某一场比赛的胜者 行号为m_n*FromLine
        emKoFromLost,	    //来自某一场比赛的败者 行号为m_n*FromLine
    }

    //KnockOut类型中，此场比赛选手去向类型
    public enum EKnockOutJumpKind
    {
        emkoJumpNone = 0,		//未初始化
        emkoJumpOut,			//被淘汰

        emkoJumpRank,			//产生名次
        emkoJumpLeft,			//跳跃到其他位置的左侧
        emkoJumpRight,			//跳跃到其他位置的右侧
        emkoAsPointer,			//被当成指针来用
    }

    //创建模型后导出的比赛列表
    public class AxDrawModelMatchRow
    {
        public UInt32 m_dwMatchNum;      //在Events或Model中,此场比赛的统一编号
        public Byte m_byteRoundOrder;    //轮序号
        public Byte m_byteMatchOrder;    //比赛场次序号

        public Int32 m_nLeftFromLineOrIndex;   //左边选手来自哪行 循环赛中为签位, 循环赛
        public Int32 m_nRightFromLineOrIndex;  //右边选手来自哪行 循环赛中为签位

        public EKnockOutFromKind m_eLeftFromKind;   //左边选手来自的类别，循环赛中无用
        public EKnockOutFromKind m_eRightFromKind;  //右边选手来自的类别，循环赛中无用

        public Int32 m_byWinGotoLineOrRank;         //赢了去的具体行数或排名，循环赛中无用
        public Int32 m_byLostGotoLineOrRank;        //输了去的具体行数或排名，循环赛无用

        public EKnockOutJumpKind m_eWinGotoKind;    //赢了去哪，循环赛无用
        public EKnockOutJumpKind m_eLostGotoKind;   //输了去哪，循环赛无用

        public Int32 m_nTempPhaseID;                //为了插入数据库方便使用
        public Int32 m_nTempMatchID;                //为了插入数据库方便使用

        public String m_strMatchDesc;               //对于此比赛的描述
        public EDrawModelLayerCode m_emLayerCode;   //当前轮次的类型定义

        public AxDrawModelMatchRow()
        {
            m_dwMatchNum = 0;
            m_nTempPhaseID = 0;
            m_nTempMatchID = 0;
            m_byteRoundOrder = 0;
            m_byteMatchOrder = 0;
            m_emLayerCode = EDrawModelLayerCode.emLayerNone;

            m_byWinGotoLineOrRank = 0;
            m_byLostGotoLineOrRank = 0;
            m_eWinGotoKind = EKnockOutJumpKind.emkoJumpNone;
            m_eLostGotoKind = EKnockOutJumpKind.emkoJumpNone;

            m_nLeftFromLineOrIndex = 0;
            m_nRightFromLineOrIndex = 0;
            m_eLeftFromKind = EKnockOutFromKind.emKoFromNone;
            m_eRightFromKind = EKnockOutFromKind.emKoFromNone;

            m_strMatchDesc = "";
        }

        public String GetRoundDesc()
        {
            String strDesc = "";

            switch (m_emLayerCode)
            {
                case EDrawModelLayerCode.emLayerNone: strDesc = ""; break;
                case EDrawModelLayerCode.emLayerRound_2to1: strDesc = "2to1"; break;
                case EDrawModelLayerCode.emLayerRound_4to2: strDesc = "4to2"; break;
                case EDrawModelLayerCode.emLayerRound_8to4: strDesc = "8to4"; break;
                case EDrawModelLayerCode.emLayerRound_16to8: strDesc = "16to8"; break;
                case EDrawModelLayerCode.emLayerRound_32to16: strDesc = "32to16"; break;
                case EDrawModelLayerCode.emLayerRound_64to32: strDesc = "64to32"; break;
                case EDrawModelLayerCode.emLayerRound_128to64: strDesc = "128to64"; break;
                case EDrawModelLayerCode.emLayerRound_256to128: strDesc = "256to128"; break;
                case EDrawModelLayerCode.emLayerRound_512to256: strDesc = "512to256"; break;
                case EDrawModelLayerCode.emLayerRound_34to3: strDesc = "34to3"; break;
                case EDrawModelLayerCode.emLayerRound_58to56: strDesc = "58to56"; break;
                case EDrawModelLayerCode.emLayerRound_56to5: strDesc = "56to5"; break;
                case EDrawModelLayerCode.emLayerRound_78to7: strDesc = "78to7"; break;
                case EDrawModelLayerCode.emLayerRound_RoundRobin: strDesc = "RoundRobin"; break;

                default: 
                    strDesc = "";
                    Debug.Assert(false); // 在SAxDrawModelMatchRow中,不应该出现其他的值
                    break;
            }

            return strDesc;
        }
    }

    //输出的每场比赛具体信息的组合
    public class AxDrawModelMatchList
    {
        public List<AxDrawModelMatchRow> m_aryMatchRow;

        public AxDrawModelMatchList()
        {
            m_aryMatchRow = new List<AxDrawModelMatchRow>();
        }

        public void RemoveAll()
        {
            m_aryMatchRow.Clear();
        }

        public void CreateMatchNum()
        {
            for (Int32 nCyc = 0; nCyc < m_aryMatchRow.Count; nCyc++)
            {
                AxDrawModelMatchRow pMatchRow = m_aryMatchRow[nCyc];
                pMatchRow.m_dwMatchNum = (UInt32)(nCyc + 1);
            }
        }
    }

    //一个模型的描述,只有描述信息,没有实际比赛信息
    public class AxDrawModelInfo
    {
        public EDrawModelType m_eType;	//结构类型
        public Int32 m_nSize;		    //结构人数
        public Int32 m_nRank;		    //输出多少人

        public Boolean m_bBogol;		//是否为贝格尔算法
        public Boolean m_bQual;			//是否输出
        public String m_strTitle;		//该结构标题

        public void RemoveAll()
        {
            m_nSize = 0;
            m_nRank = 0;
            m_bBogol = false;
            m_bQual = false;
            m_eType = EDrawModelType.emTypeManual;
        }
    }

    //一个队员来源信息
    public class AxDrawModelPlayerFrom
    {
        public Byte m_byStageOrder;		//位于Event中哪个Stage
        public Byte m_byModelOrder;		//位于Stage中的哪个Model
        public Byte m_byResultRank;		//位于目标模型中输出的第几名

        public Int32 m_nTempFromModelID;	//把目标模型的数据库ID放在这里,方便插入使用

        public AxDrawModelPlayerFrom()
        {
            m_byStageOrder = 0;
            m_byModelOrder = 0;
            m_byResultRank = 0;
            m_nTempFromModelID = 0;
        }
    }

    //一个模型所有信息,具体每场比赛,模型描述信息,队员来源信息
    public class AxDrawModelModelExport
    {
        public Int32 m_nTempModelID;		        //此模型的数据库ID
        public AxDrawModelInfo m_drawInfo;		    //基本信息
        public AxDrawModelMatchList m_matchList;	//所有比赛列表
        public List<AxDrawModelPlayerFrom> m_aryPlayerFrom;	//此模型队员来源信息

        public AxDrawModelModelExport()
        {
            m_aryPlayerFrom = new List<AxDrawModelPlayerFrom>();

            m_nTempModelID = 0;
            m_drawInfo = new AxDrawModelInfo();
            m_matchList = new AxDrawModelMatchList();
        }

        public Int32 GetMatchCnt()
        {
            return m_matchList.m_aryMatchRow.Count;
        }

        public AxDrawModelMatchRow GetMatchObj(int nMatchIdx)
        {
            if ( nMatchIdx < 0 || nMatchIdx >= GetMatchCnt() )
            {
                return null;
            }

            return m_matchList.m_aryMatchRow[nMatchIdx];
        }
    }

    //一个阶段的描述
    public class AxDrawModelStage
    {
        public Int32 m_nTempStageID;			              //此阶段的数据库ID
        public String m_strStageName;		                  //阶段标题
        public List<AxDrawModelModelExport> m_aryModelList;   //比赛模型链表
        //public List<AxDrawModelPlayerFrom> m_aryPlayerFrom;	  //此阶段的签位表,

        public AxDrawModelStage()
        {
            m_aryModelList = new List<AxDrawModelModelExport>();
            m_nTempStageID = 0;
            m_strStageName = "";
        }

        public Int32 GetModelCnt()
        {
            return m_aryModelList.Count;
        }

        public AxDrawModelModelExport GetModelExpObj(int nModelExpIdx)
        {
            if ( nModelExpIdx < 0 || nModelExpIdx >= GetModelCnt() )
            {
                Debug.Assert(false);
                return null;
            }

            return m_aryModelList[nModelExpIdx];
        }
    }

    //整个赛事
    public class AxDrawModelEvent
    {
        public Int32 m_nTempEventID;						 //此赛事的数据库ID
        public List<AxDrawModelStage> m_aryStageList;	     //阶段链表
        public List<AxDrawModelPlayerFrom> m_aryEventRank;	 //整个赛事的比赛结果排名来源,链表中的顺序即为最后EventRank

        public AxDrawModelEvent()
        {
            m_nTempEventID = 0;
            m_aryStageList = new List<AxDrawModelStage>();
            m_aryEventRank = new List<AxDrawModelPlayerFrom>();
        }

        public void RemoveAll()
        {
            m_nTempEventID = 0;
            m_aryStageList.Clear();
            m_aryEventRank.Clear();
        }

        public int GetStageCnt()
        {
            return m_aryStageList.Count;
        }

        public AxDrawModelStage GetStageObj(int nStageIdx)
        {
            if ( nStageIdx < 0 || nStageIdx >= m_aryStageList.Count )
            {
                Debug.Assert(false);
                return null;
            }

            return m_aryStageList[nStageIdx];
        }

        public AxDrawModelModelExport GetModelExport(int nStageIdx, int nModelExpIdx)
        {
            AxDrawModelStage pStage = GetStageObj(nStageIdx);
            if ( pStage == null )
            {
                return null;
            }

            if ( nModelExpIdx < 0 || nModelExpIdx >= (int)pStage.m_aryModelList.Count )
            {
                Debug.Assert(false);
                return null;
            }

            return pStage.m_aryModelList[nModelExpIdx];
        }

	    //将整个Event中所有比赛编号,按照Event的轮为单位

        public Boolean CreateMatchNum()
        {
            Int32 dwMatchNum = 1; //从1开始

            for (Int32 nStage = 0; nStage < GetStageCnt(); nStage++)
            {
                AxDrawModelStage pStage = GetStageObj(nStage);

                ArrayList aryDwCurMatchIdxInModel = new ArrayList();	//目前Stage中每个Model进行到第几场比赛了,用来在循环中作记忆

                //把个数设为Model个数,并且每个都是先从第一个开始

                for (Int32 nCyc = 0; nCyc < pStage.GetModelCnt(); nCyc++ )
                {
                    aryDwCurMatchIdxInModel.Add(0);
                }            

                do//填序号,直到每个Model的所有比赛都填了序号
                {
                    //循环每个Model,进行排号,每个Model有一次机会时,把这轮所有的号拍完,
                    //之后释放机会,等下次机会再排下一轮
                    for (Int32 nModel = 0; nModel < pStage.GetModelCnt(); nModel++)
                    {
                        AxDrawModelModelExport pModel = pStage.GetModelExpObj(nModel);

                        //获取阶段中当前模型排号到哪场比赛了
                        Int32 dwCurMatchIdxInModel = (Int32)aryDwCurMatchIdxInModel[nModel];
                        if ( dwCurMatchIdxInModel < 0 || dwCurMatchIdxInModel > pModel.GetMatchCnt() )
                        {
                            Debug.Assert(false);
                            return false;
                        }

                        if (dwCurMatchIdxInModel >= pModel.GetMatchCnt())
                        {
                            //如果存的标志大于本Model比赛个数,说明此Model比赛都添加过了
                            continue;
                        }

                        AxDrawModelMatchRow pMatch = pModel.GetMatchObj(dwCurMatchIdxInModel); //得到当前的比赛
                        Int32 byCurRound = Convert.ToInt32(pMatch.m_byteRoundOrder);
                        pMatch.m_dwMatchNum = Convert.ToUInt32(dwMatchNum++);
                        dwCurMatchIdxInModel++;

                        while (dwCurMatchIdxInModel < pModel.GetMatchCnt() &&
                               Convert.ToUInt32(pModel.GetMatchObj(dwCurMatchIdxInModel).m_byteRoundOrder) == byCurRound)
                        {
                            pModel.GetMatchObj(dwCurMatchIdxInModel).m_dwMatchNum = Convert.ToUInt32(dwMatchNum++);
                            dwCurMatchIdxInModel++;
                        }

                        aryDwCurMatchIdxInModel[nModel] = dwCurMatchIdxInModel; //把此Model下次该进行场次排号的Index写入记忆数组
                    }

                    //查找是否还有需要填写的
                    Boolean bNeedFill = false;
                    for (Int32 nCycModel = 0; nCycModel < pStage.GetModelCnt(); nCycModel++)
                    {
                        Int32 dwCurMatchIdx = (Int32)aryDwCurMatchIdxInModel[nCycModel];
                        if (dwCurMatchIdx < pStage.GetModelExpObj(nCycModel).GetMatchCnt())
                        {
                            bNeedFill = true;
                            break;
                        }
                    }

                    if (!bNeedFill)
                        break; //此Stage填数完成,进入下一个Stage
                }
                while (true);

            }//for Stage

            return true;
        }

	    //把此来源链表中所有队员来源添上,前提是所有需要的来源都已经有ID了

        public Boolean FillPlayerInfo(List<AxDrawModelPlayerFrom> aryPlayerFromInfo)
        {
            Boolean bRet = true;

            for (Int32 nCyc = 0; nCyc < aryPlayerFromInfo.Count; nCyc++)
            {
                AxDrawModelPlayerFrom pPlayerFrom = aryPlayerFromInfo[nCyc];

                AxDrawModelModelExport pModelExp = GetModelExport(pPlayerFrom.m_byStageOrder, pPlayerFrom.m_byModelOrder);
                if (pModelExp.m_nTempModelID > 0)
                {
                    pPlayerFrom.m_nTempFromModelID = pModelExp.m_nTempModelID;
                }
                else
                {
                    bRet = false;
                    Debug.Assert(false);
                    //该来源还没有被插入数据库
                    pPlayerFrom.m_nTempFromModelID = 0;
                }
            }

            return bRet;
        }
    }
}
