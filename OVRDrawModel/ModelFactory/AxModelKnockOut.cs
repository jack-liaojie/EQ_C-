using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Diagnostics;

namespace AutoSports.OVRDrawModel
{
    public class AxModelKnockOut : AxModelBase
    {
        public override String GetDumpStr()
        {
            StringBuilder strOut = new StringBuilder();
            String strMsg = "";

            // 1. 打印内部结构
            {
                strMsg = String.Format("\r\n我们有{0:D}人比赛,产生{1:D}人名次,主塔{2:D}层,最多供{3:D}人比赛,\r\n", GetPlayerCnt(), GetPlayerResultCnt(), m_oEvent.GetLayerCount(), m_oEvent.GetMaxPlayerCount() );
                strOut.Append(strMsg);

                Int32 PyramidCnt = m_oEvent.GetPyramidCount();

                for (Int32 nPyramid = 0; nPyramid < PyramidCnt; nPyramid++)
                {
                    stKoPyramid pPyramid = m_oEvent.GetPyramidObj(nPyramid);
                    strMsg = String.Format("塔{0:D} \r\n", nPyramid + 1);
                    strOut.Append(strMsg);

                    for (Int32 nLayer = 0; nLayer < pPyramid.GetLayerCount(); nLayer++)
                    {
                        stKoLayer pLayer = pPyramid.GetLayerObj(nLayer);
                        strMsg = String.Format("第{0:D}层: ", nLayer + 1);
                        strOut.Append(strMsg);

                        for (Int32 nNode = 0; nNode < pLayer.GetNodeCount(); nNode++)
                        {
                            stKoMatchNode pNode = pLayer.GetNodeObj(nNode);

                            strMsg = String.Format("Node[{0:D}-{1:D}-{2:D} W:'{3:D}' L:'{4:D}' ] ", nPyramid + 1, nLayer + 1, nNode + 1,
                                pNode.m_oJumpWin.GetDesc(), pNode.m_oJumpLost.GetDesc());
                            strOut.Append(strMsg);
                        }

                        strOut.Append("\r\n");
                    }

                    strOut.Append("\r\n");
                }

                strOut.Append("\r\n");
            }

            // 2. 打印输出表
            AxDrawModelMatchList aryMatch = new AxDrawModelMatchList();
            GetModelExport(aryMatch);

            for (Int32 nCyc = 0; nCyc < aryMatch.m_aryMatchRow.Count; nCyc++)
            {
                AxDrawModelMatchRow pMatchInfo = aryMatch.m_aryMatchRow[nCyc];

                String strLeftFromDesc = "";
                {
                    if (pMatchInfo.m_eLeftFromKind == EKnockOutFromKind.emKoFromInit)
                    {
                        if (pMatchInfo.m_nLeftFromLineOrIndex == -1)
                            strLeftFromDesc = "BYE";
                        else
                            strLeftFromDesc = String.Format("源{0:D}", pMatchInfo.m_nLeftFromLineOrIndex + 1);
                    }
                    else if (pMatchInfo.m_eLeftFromKind == EKnockOutFromKind.emKoFromWin)
                        strLeftFromDesc = String.Format("{0:D}行Win", pMatchInfo.m_nLeftFromLineOrIndex);
                    else if (pMatchInfo.m_eLeftFromKind == EKnockOutFromKind.emKoFromLost)
                        strLeftFromDesc = String.Format("{0:D}行Lost", pMatchInfo.m_nLeftFromLineOrIndex);
                }

                String strRightFromDesc = "";
                {
                    if (pMatchInfo.m_eRightFromKind == EKnockOutFromKind.emKoFromInit)
                    {
                        if (pMatchInfo.m_nRightFromLineOrIndex == -1)
                            strRightFromDesc = "BYE";
                        else
                            strRightFromDesc = String.Format("源{0:D}", pMatchInfo.m_nRightFromLineOrIndex + 1);
                    }
                    else if (pMatchInfo.m_eRightFromKind == EKnockOutFromKind.emKoFromWin)
                        strRightFromDesc = String.Format("{0:D}行Win", pMatchInfo.m_nRightFromLineOrIndex);
                    else if (pMatchInfo.m_eRightFromKind == EKnockOutFromKind.emKoFromLost)
                        strRightFromDesc = String.Format("{0:D}行Lost", pMatchInfo.m_nRightFromLineOrIndex);
                }

                String strWinToDesc = "";
                {
                    if (pMatchInfo.m_eWinGotoKind == EKnockOutJumpKind.emkoJumpLeft)
                    {
                        strWinToDesc = String.Format("{0:D}行左", pMatchInfo.m_byWinGotoLineOrRank);
                    }
                    else if (pMatchInfo.m_eWinGotoKind == EKnockOutJumpKind.emkoJumpRight)
                    {
                        strWinToDesc = String.Format("{0:D}行右", pMatchInfo.m_byWinGotoLineOrRank);
                    }
                    else if (pMatchInfo.m_eWinGotoKind == EKnockOutJumpKind.emkoJumpRank)
                    {
                        strWinToDesc = String.Format("第{0:D}名", pMatchInfo.m_byWinGotoLineOrRank);
                    }
                    else if (pMatchInfo.m_eWinGotoKind == EKnockOutJumpKind.emkoJumpOut)
                    {
                        strWinToDesc = "淘汰";
                    }
                }

                String strLostToDesc = "";
                {
                    if (pMatchInfo.m_eLostGotoKind == EKnockOutJumpKind.emkoJumpLeft)
                    {
                        strLostToDesc = String.Format("{0:D}行左", pMatchInfo.m_byLostGotoLineOrRank);
                    }
                    else if (pMatchInfo.m_eLostGotoKind == EKnockOutJumpKind.emkoJumpRight)
                    {
                        strLostToDesc = String.Format("{0:D}行右", pMatchInfo.m_byLostGotoLineOrRank);
                    }
                    else if (pMatchInfo.m_eLostGotoKind == EKnockOutJumpKind.emkoJumpRank)
                    {
                        strLostToDesc = String.Format("第{0:D}名", pMatchInfo.m_byLostGotoLineOrRank);
                    }
                    else if (pMatchInfo.m_eLostGotoKind == EKnockOutJumpKind.emkoJumpOut)
                    {
                        strLostToDesc = "淘汰";
                    }
                }

                strMsg = String.Format("{0:D} {1} Round{2}:{3}. WinTo:{4}, LostTo:{5}, LeftFrom:{6}, RightFrom:{7} \r\n",
                    nCyc, pMatchInfo.m_strMatchDesc, pMatchInfo.m_byteRoundOrder, pMatchInfo.GetRoundDesc(),
                    strWinToDesc, strLostToDesc, strLeftFromDesc, strRightFromDesc);

                strOut.Append(strMsg);
            }

            strOut.Append("\r\n");

            return strOut.ToString();
        }

        public override Boolean GetModelExport(AxDrawModelMatchList drawModelModel)
        {
            drawModelModel.RemoveAll();
            Int32 nPyramidCnt = m_oEvent.GetPyramidCount();

            if (nPyramidCnt < 1)
            {
                return false;
            }

            //填入源信息时底层的需要排序位置
            Int32 nPosIndex = 0;	//来自人员的顺序ID
            //AryKoStartPos aryPos;	//来自人员序列
            ArrayList aryPos = new ArrayList();
            
            GetStartPos(m_oEvent.GetLayerCount(), aryPos);

            //1. 先循环一次,把所有比赛加入队列, 这样我们内存的结构里,就有了Match的RowNumber
            for (Int32 nPyramid = 0; nPyramid < nPyramidCnt; nPyramid++)
            {
                stKoPyramid pPrramid = m_oEvent.GetPyramidObj(nPyramid);
                Int32 nLayerCnt = pPrramid.GetLayerCount();

                for (Int32 nLayer = nLayerCnt - 1; nLayer >= 0; nLayer--)
                {
                    stKoLayer pLayer = pPrramid.GetLayerObj(nLayer);
                    Int32 nNodeCnt = pLayer.GetNodeCount();

                    for (Int32 nNode = 0; nNode < nNodeCnt; nNode++)
                    {
                        stKoMatchNode pNode = pLayer.GetNodeObj(nNode);

                        AxDrawModelMatchRow matchInfo = new AxDrawModelMatchRow();
                        matchInfo.m_byteRoundOrder = (Byte)(nLayerCnt - nLayer + nPyramid * 10);
                        matchInfo.m_strMatchDesc = String.Format("{0:D}-{1:D}-{2:D}", nPyramid + 1, nLayer + 1, nNode + 1);

                        //将此场比赛添加到列表后,会返还行号,正好填给内存中的塔
                        drawModelModel.m_aryMatchRow.Add(matchInfo);
                        Int32 nCurNodeRowInMatchList = drawModelModel.m_aryMatchRow.Count - 1;
                        pNode.m_nRowTemp = nCurNodeRowInMatchList;
                    }
                }
            }

            //2.再循环一次,把目标和源填入
            for (Int32 nPyramid = 0; nPyramid < nPyramidCnt; nPyramid++)
            {
                stKoPyramid pPyramid = m_oEvent.GetPyramidObj(nPyramid);
                Int32 nLayerCnt = pPyramid.GetLayerCount();

                for (Int32 nLayer = 0; nLayer < nLayerCnt; nLayer++)
                {
                    stKoLayer pLayer = pPyramid.GetLayerObj(nLayer);
                    Int32 nNodeCnt = pLayer.GetNodeCount();

                    for (Int32 nNode = 0; nNode < nNodeCnt; nNode++)
                    {
                        stKoMatchNode pNode = pLayer.GetNodeObj(nNode);
                        AxDrawModelMatchRow pMatchInfoInList = drawModelModel.m_aryMatchRow[pNode.m_nRowTemp];
                        

                        //1.轮次信息
                        {
                            if (nPyramid == 0) //第一个塔里的结构就是从金牌赛往下顺
                            {
                                switch (nLayer)
                                {
                                    case 8: pMatchInfoInList.m_emLayerCode = EDrawModelLayerCode.emLayerRound_512to256; break;
                                    case 7: pMatchInfoInList.m_emLayerCode = EDrawModelLayerCode.emLayerRound_256to128; break;
                                    case 6: pMatchInfoInList.m_emLayerCode = EDrawModelLayerCode.emLayerRound_128to64; break;
                                    case 5: pMatchInfoInList.m_emLayerCode = EDrawModelLayerCode.emLayerRound_64to32; break;
                                    case 4: pMatchInfoInList.m_emLayerCode = EDrawModelLayerCode.emLayerRound_32to16; break;
                                    case 3: pMatchInfoInList.m_emLayerCode = EDrawModelLayerCode.emLayerRound_16to8; break;
                                    case 2: pMatchInfoInList.m_emLayerCode = EDrawModelLayerCode.emLayerRound_8to4; break;
                                    case 1: pMatchInfoInList.m_emLayerCode = EDrawModelLayerCode.emLayerRound_4to2; break;
                                    case 0: pMatchInfoInList.m_emLayerCode = EDrawModelLayerCode.emLayerRound_2to1; break;
                                    default: break;
                                }
                            }
                            else if (nPyramid == 1) //第二个塔里只能有铜牌赛
                            {
                                pMatchInfoInList.m_emLayerCode = EDrawModelLayerCode.emLayerRound_34to3;
                            }
                            else if (nPyramid == 2) //第三个塔是5-8名
                            {
                                if (nLayer == 0)
                                    pMatchInfoInList.m_emLayerCode = EDrawModelLayerCode.emLayerRound_56to5;
                                else
                                    pMatchInfoInList.m_emLayerCode = EDrawModelLayerCode.emLayerRound_58to56;
                            }
                            else if (nPyramid == 3) //第四个塔是7,8名
                            {
                                pMatchInfoInList.m_emLayerCode = EDrawModelLayerCode.emLayerRound_78to7;
                            }
                        }

                        //2. 跳跃信息
                        pMatchInfoInList.m_eWinGotoKind = pNode.m_oJumpWin.m_byJumpKind;
                        pMatchInfoInList.m_eLostGotoKind = pNode.m_oJumpLost.m_byJumpKind;

                        if (pNode.m_oJumpWin.IsJumpPos()) //是跳跃到位置,那么在金字塔中找到那Node, Node里肯定有行号,把目标行号拿到即可
                        {
                            stKoMatchNode pNodeWinGoto = m_oEvent.GetMatchObj(pNode.m_oJumpWin);
                            pMatchInfoInList.m_byWinGotoLineOrRank = pNodeWinGoto.m_nRowTemp;
                        }
                        else // 不是跳到位置,那要么是Rank,或者是Out
                        {
                            pMatchInfoInList.m_byWinGotoLineOrRank = pNode.m_oJumpWin.m_byPyramindIndexOrRank;
                        }

                        if (pNode.m_oJumpLost.IsJumpPos())
                        {
                            stKoMatchNode pNodeLostGoto = m_oEvent.GetMatchObj(pNode.m_oJumpLost);
                            pMatchInfoInList.m_byLostGotoLineOrRank = pNodeLostGoto.m_nRowTemp;
                        }
                        else
                        {
                            pMatchInfoInList.m_byLostGotoLineOrRank = pNode.m_oJumpLost.m_byPyramindIndexOrRank;
                        }


                        //3. 来源信息
                        stKoJumpInfo JumpThisInfo = new stKoJumpInfo();
                        JumpThisInfo.SetJumpToPointer((Byte)nPyramid, (Byte)nLayer, (Byte)nNode, false); //本Node的Jump坐标
                        {
                            //左来源
                            stKoJumpInfo jumpFromLeft = m_oEvent.GetMatchPlayerFrom(JumpThisInfo, true);
                            if (jumpFromLeft.IsJumpAsPointer()) //从其他地方来的
                            {
                                stKoMatchNode pNodeLeftFrom = m_oEvent.GetMatchObj(jumpFromLeft);
                                pMatchInfoInList.m_eLeftFromKind = jumpFromLeft.m_byIsWin ? EKnockOutFromKind.emKoFromWin : EKnockOutFromKind.emKoFromLost;
                                pMatchInfoInList.m_nLeftFromLineOrIndex = pNodeLeftFrom.m_nRowTemp;
                            }
                            else //最底层的
                            {
                                pMatchInfoInList.m_eLeftFromKind = EKnockOutFromKind.emKoFromInit;
                                pMatchInfoInList.m_nLeftFromLineOrIndex = Convert.ToInt32(aryPos[nPosIndex++]);
                            }

                            //右来源
                            stKoJumpInfo jumpFromRight = m_oEvent.GetMatchPlayerFrom(JumpThisInfo, false);
                            if (jumpFromRight.IsJumpAsPointer())
                            {
                                stKoMatchNode pNodeRightFrom = m_oEvent.GetMatchObj(jumpFromRight);
                                pMatchInfoInList.m_eRightFromKind = jumpFromRight.m_byIsWin ? EKnockOutFromKind.emKoFromWin : EKnockOutFromKind.emKoFromLost;
                                pMatchInfoInList.m_nRightFromLineOrIndex = pNodeRightFrom.m_nRowTemp;
                            }
                            else
                            {
                                pMatchInfoInList.m_eRightFromKind = EKnockOutFromKind.emKoFromInit;
                                pMatchInfoInList.m_nRightFromLineOrIndex = Convert.ToInt32(aryPos[nPosIndex++]);
                            }
                        }

                    }//For Node
                }//For layer
            }//For Pyramid

            return true;
        }

        protected Int32 m_nPlayerResultCnt;
        protected String m_strLastError;
        public stKoStage m_oEvent = new stKoStage();	//一个Event,包含多个金字塔

	    //nLayerCnt: 参赛人数,最小1层,最大9人
	    //nResultLayerCnt: 最终需要决出多少人排名: 最小1人, 最大8人
        public Boolean Create(Int32 nLayerCnt, Int32 nResultPlayerCnt, Boolean bUseDouleOut)
        {
            // 1层:		2人 *		最终排名:
	        // 2层:		4人 *					2人		1个塔
	        // 3层:		8人						4人		2个塔
	        // 4层:	   16人						8人		4个塔
	        // 5层:	   32人)
	        // 6层:	   64人
	        // 7层:	  128人
	        // 8层:	  256人
	        // 9层:	  512人

	        Int32 nPlayerCnt = (Int32)Math.Pow(2, nLayerCnt);

	        if ( bUseDouleOut )
	        {
		        m_strLastError = "Err in CreateStage(): 目前不支持双败淘汰!";
		        return false;
	        }

	        // 1. 检测输入参数
	        if ( nLayerCnt < 1 || nLayerCnt > 9 )
	        {
		        m_strLastError = "Err in CreateStage(): nLayerCnt超出许可范围!";
		        return false;
	        }

	        if ( nResultPlayerCnt < 1 || nResultPlayerCnt > 8 )
	        {
		        m_strLastError = "Err in CreateStage(): nResultPlayerCnt超出许可范围!";
		        return false;
	        }

 	        if ( nResultPlayerCnt > nPlayerCnt )
 	        {
 		        m_strLastError = "Err in CreateStage(): 比赛人数小于最后取结果人数!";
 		        return false;
 	        }

	        // 2. 创建新的Stage
	        if( !_Create(nLayerCnt, nResultPlayerCnt) )
	        {
		        return false;
	        }
	        else
	        {
		        m_nPlayerResultCnt = nResultPlayerCnt;
	        }

	        return true;
        }

        public Int32 GetPlayerCnt()
        {
            return m_oEvent.GetMaxPlayerCount();
        }

        public Int32 GetPlayerResultCnt()
        {
            return m_nPlayerResultCnt;
        }

        public String GetLastError()
        {
            return m_strLastError;
        }
    	
	    //根据人数,推算层数
	    public static Int32 GetLayer(int nPlayer)
        {
            if ( nPlayer < 1 || nPlayer > 512 )
	        {
		        return -1;
	        }

	        if ( nPlayer > 256 )
		        return 9;
	        else if ( nPlayer > 128 )
		        return 8;
	        else if ( nPlayer > 64 )
		        return 7;
	        else if ( nPlayer > 32 )
		        return 6;
	        else if ( nPlayer >16 )
		        return 5;
	        else if ( nPlayer > 8 )
		        return 4;
	        else if ( nPlayer > 4 )
		        return 3;
	        else if ( nPlayer > 2 )
		        return 2;
	        else
		        return 1;
        }

	    //根据排名生成默认的开始序列表, nLayer表示几层,至少一层
	    public static Boolean GetStartPos(Int32 nLayer, ArrayList pStartPosAry)
        {
            if (nLayer < 1 || nLayer > 8)
            {
                return false;
            }

            ArrayList aryPosTemp = new ArrayList();

            for (Int32 nCyc = 0; nCyc < nLayer; nCyc++)
            {
                //第一次开始时,手动赋值
                if (nCyc == 0)
                {
                    if (aryPosTemp.Count == 0)
                    {
                        aryPosTemp.Add(0);	//从0开始计数
                        aryPosTemp.Add(1);
                    }  
                }
                else
                {
                    Int32 nCntHalf = aryPosTemp.Count; //新组的半区空间等于上一组总空间
                    ArrayList aryPosNew = new ArrayList(); //临时用的新区

                    //填入新组上半区内容
                    for (Int32 nCycNew = 0; nCycNew < nCntHalf; nCycNew++)
                    {
                        Byte byValue = Convert.ToByte(aryPosTemp[nCycNew]);

                        if (nCycNew % 2 == 0) //奇数位置和偶数位置
                            aryPosNew.Add((Byte)(((Int32)(byValue + 1)) * 2 - 1 - 1));
                        else
                            aryPosNew.Add((Byte)((Int32)(byValue + 1) * 2 - 1));
                    }

                    //填入下半区内容
                    for (Int32 nCycNew = 0; nCycNew < nCntHalf; nCycNew++)
                    {
                        //是根据上半区相对位置值决定的
                        Byte byValue = (Byte)aryPosNew[nCycNew];

                        if (nCycNew % 2 == 0)
                            aryPosNew.Add(byValue + 2);
                        else
                            aryPosNew.Add(byValue - 2);
                    }

                    //把新区内容付给临时区
                    aryPosTemp.Clear();
                    for (Int32 nCycNew = 0; nCycNew < aryPosNew.Count; nCycNew++)
                    {
                        Byte byValue = Convert.ToByte(aryPosNew[nCycNew]);
                        aryPosTemp.Add(byValue);
                    }
                }
            }

            //把临时数组输出
            pStartPosAry.Clear();
            for (Int32 nCycNew = 0; nCycNew < aryPosTemp.Count; nCycNew++)
            {
                Byte byValue = Convert.ToByte(aryPosTemp[nCycNew]);
                pStartPosAry.Add(byValue);
            }

            return true;
        }
    	
	    public Boolean _Create( int nLayerCnt, int nResultPlayerCnt )
        {
            //1. 先把内部所有内容清空
            {
                m_oEvent.RemoveAll();
                m_strLastError = "";
            }

            //2. 首先建立主 塔0
            {
                Int32 nPyramidIdx = 0;	//主金字塔位于第一个
                stKoPyramid matchPyramid0 = new stKoPyramid();

                //4人比赛,需要3层, 我们的内部只有2层就够, 因为我们不存在顶端的一层
                for (Int32 nLayer = 0; nLayer <= nLayerCnt - 1; nLayer++)
                {
                    stKoLayer matchLayer = new stKoLayer();

                    //第1层 2个节点; 第2层 4个节点; 第3层 8个节点...
                    Int32 nNodeCnt = (Int32)Math.Pow(2, nLayer);
                    for (Int32 nNode = 0; nNode < nNodeCnt; nNode++)
                    {
                        stKoMatchNode matchNode = new stKoMatchNode();

                        if (nLayer == 0) //第1层产生1,2名
                        {
                            matchNode.m_oJumpWin.SetJumpToRank(1);

                            if (nResultPlayerCnt > 1)
                                matchNode.m_oJumpLost.SetJumpToRank(2);
                            else
                                matchNode.m_oJumpLost.SetJumpToOut();
                        }
                        else
                        {
                            //这场比赛如果赢了应该去上层的一个节点
                            Int32 nTargetNode = (nNode / 2);  // 0,1->0; 2,3->1; 4,5->2; 6,7->3
                            Boolean bTargetLeft = (nNode % 2 == 0); // 0,2,4->Left; 1,3,5->Right

                            matchNode.m_oJumpWin.SetJumpToPos((Byte)nPyramidIdx, (Byte)(nLayer - 1), (Byte)nTargetNode, bTargetLeft);

                            //除了最冠军赛,其他失败的都淘汰
                            matchNode.m_oJumpLost.SetJumpToOut();
                        }

                        matchLayer.AddNodeObj(matchNode);
                    }//for Layer

                    matchPyramid0.AddLayerObj(matchLayer);
                }//for Pyramid

                m_oEvent.AddPyramidObj(matchPyramid0);
            }

            //3.根据需要建立其他附塔
            if (nResultPlayerCnt >= 3)
            {
                //建立争3,4名用的 塔1
                {
                    stKoMatchNode matchNode = new stKoMatchNode();
                    matchNode.m_oJumpWin.SetJumpToRank(3);

                    if (nResultPlayerCnt == 3) //如果只要3个排名的话,第4名置淘汰
                        matchNode.m_oJumpLost.SetJumpToOut();
                    else
                        matchNode.m_oJumpLost.SetJumpToRank(4);

                    stKoLayer matchLayer = new stKoLayer();
                    matchLayer.AddNodeObj(matchNode);

                    stKoPyramid matchPyramid1 = new stKoPyramid();
                    matchPyramid1.AddLayerObj(matchLayer);

                    m_oEvent.AddPyramidObj(matchPyramid1);
                }

                //更改主塔中3,4名的链接
                {
                    stKoJumpInfo jumpInfoL = new stKoJumpInfo(), jumpInfoR = new stKoJumpInfo();
                    jumpInfoL.SetJumpToPointer(0, 1, 0, false);
                    jumpInfoR.SetJumpToPointer(0, 1, 1, false);

                    stKoMatchNode pNodeL = m_oEvent.GetMatchObj(jumpInfoL);
                    stKoMatchNode pNodeR = m_oEvent.GetMatchObj(jumpInfoR);
                    if (pNodeL == null || pNodeR == null)
                    {
                        return false;
                    }

                    pNodeL.m_oJumpLost.SetJumpToPos(1, 0, 0, true);
                    pNodeR.m_oJumpLost.SetJumpToPos(1, 0, 0, false);
                }
            }//if

            if (nResultPlayerCnt >= 5)
            {
                //建立争5,6名用的 塔2
                {
                    stKoLayer matchLayer1 = new stKoLayer();
                    {
                        stKoMatchNode matchNode11 = new stKoMatchNode();
                        matchNode11.m_oJumpWin.SetJumpToRank(5);

                        if (nResultPlayerCnt == 5) //如果只要5个排名的话,第6名置淘汰
                            matchNode11.m_oJumpLost.SetJumpToOut();
                        else
                            matchNode11.m_oJumpLost.SetJumpToRank(6);

                        matchLayer1.AddNodeObj(matchNode11);
                    }

                    stKoLayer matchLayer2 = new stKoLayer();
                    {
                        stKoMatchNode matchNode21 = new stKoMatchNode();
                        stKoMatchNode matchNode22 = new stKoMatchNode();

                        matchNode21.m_oJumpLost.SetJumpToOut();
                        matchNode21.m_oJumpWin.SetJumpToPos(2, 0, 0, true);

                        matchNode22.m_oJumpLost.SetJumpToOut();
                        matchNode22.m_oJumpWin.SetJumpToPos(2, 0, 0, false);

                        matchLayer2.AddNodeObj(matchNode21);
                        matchLayer2.AddNodeObj(matchNode22);
                    }

                    stKoPyramid matchPyramid2 = new stKoPyramid();
                    matchPyramid2.AddLayerObj(matchLayer1);
                    matchPyramid2.AddLayerObj(matchLayer2);
                    m_oEvent.AddPyramidObj(matchPyramid2);
                }

                //更改主塔中5,6,7,8名的链接
                {
                    stKoJumpInfo jumpInfo1L = new stKoJumpInfo(), jumpInfo1R = new stKoJumpInfo(), jumpInfo2L = new stKoJumpInfo(), jumpInfo2R = new stKoJumpInfo();
                    jumpInfo1L.SetJumpToPointer(0, 2, 0, false);
                    jumpInfo1R.SetJumpToPointer(0, 2, 1, false);
                    jumpInfo2L.SetJumpToPointer(0, 2, 2, false);
                    jumpInfo2R.SetJumpToPointer(0, 2, 3, false);

                    stKoMatchNode pNode1L = m_oEvent.GetMatchObj(jumpInfo1L);
                    stKoMatchNode pNode1R = m_oEvent.GetMatchObj(jumpInfo1R);
                    stKoMatchNode pNode2L = m_oEvent.GetMatchObj(jumpInfo2L);
                    stKoMatchNode pNode2R = m_oEvent.GetMatchObj(jumpInfo2R);
                    if (pNode1L == null || pNode1R == null || pNode2L == null || pNode2R == null)
                    {
                        return false;
                    }

                    pNode1L.m_oJumpLost.SetJumpToPos(2, 1, 0, true);
                    pNode1R.m_oJumpLost.SetJumpToPos(2, 1, 0, false);
                    pNode2L.m_oJumpLost.SetJumpToPos(2, 1, 1, true);
                    pNode2R.m_oJumpLost.SetJumpToPos(2, 1, 1, false);
                }

            }//if

            if (nResultPlayerCnt >= 7)
            {
                //建立争7,8名用的 塔3
                {
                    stKoMatchNode matchNode = new stKoMatchNode();
                    matchNode.m_oJumpWin.SetJumpToRank(7);

                    if (nResultPlayerCnt == 7) //如果只要7个排名的话,第8名置淘汰
                        matchNode.m_oJumpLost.SetJumpToOut();
                    else
                        matchNode.m_oJumpLost.SetJumpToRank(8);

                    stKoLayer matchLayer = new stKoLayer();
                    matchLayer.AddNodeObj(matchNode);

                    stKoPyramid matchPyramid3 = new stKoPyramid();
                    matchPyramid3.AddLayerObj(matchLayer);

                    m_oEvent.AddPyramidObj(matchPyramid3);
                }

                //更改塔2中7,8名的链接
                {
                    stKoJumpInfo jumpInfoL = new stKoJumpInfo(), jumpInfoR = new stKoJumpInfo();
                    jumpInfoL.SetJumpToPointer(2, 1, 0, false);
                    jumpInfoR.SetJumpToPointer(2, 1, 1, false);

                    stKoMatchNode pNodeL = m_oEvent.GetMatchObj(jumpInfoL);
                    stKoMatchNode pNodeR = m_oEvent.GetMatchObj(jumpInfoR);
                    if (pNodeL == null || pNodeR == null)
                    {
                        return false;
                    }

                    pNodeL.m_oJumpLost.SetJumpToPos(3, 0, 0, true);
                    pNodeR.m_oJumpLost.SetJumpToPos(3, 0, 0, false);
                }
            }

            return true;
        }

	    public AxModelKnockOut()
        {
            m_nPlayerResultCnt = 0;
        }
    }
}
