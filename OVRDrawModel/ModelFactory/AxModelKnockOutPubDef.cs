using System;
using System.Collections.Generic;
using System.Text;

// ����ģ�������ṹ,��8��4��, ���Ҫ����ǰ8�����ṹ����
// �������Ҫ����������2�������,����ڶ��������

// stMatchEvent
// <AryKoPyramids>
//		��
//		��	,stKoPyramid (������,����1,2��) 1-X-X		����Ϊ����
//		��	 <AryKoLayers>
//		��		 ��
//		��		 ��		
//		��		 �� ,stKoLayer (��1��, 2��) 1-1-X
//		��		 ��	 <AryKoMatchNodes>	
//		��		 ��		�� ,stKoMatchNode 1-3-1
//		��		 ��				��	 
//		��		 ��			 ,Win:  goto Rank1
//		��		 ��			 ,Lost: goto Rank2
//		��       ��
//		��       ��
//		��		 �� ,stKoLayer (��2��, 4��) 1-2-X
//		��		 ��	 <AryKoMatchNodes>	
//		��		 ��		�� ,stKoMatchNode 1-2-1
//		��		 ��		��		��	 
//		��		 ��		��	 ,Win:  goto 1-3-1-L
//		��		 ��		��	 ,Lost: goto 2-1-1-L
//		��		 ��     ��
//		��		 ��		�� ,stKoMatchNode 1-2-2
//		��		 ��				��	 
//		��		 ��			 ,Win:  goto 1-3-1-R
//		��		 ��			 ,Lost: goto 2-1-1-R
//		��		 ��	
//		��       ��
//		��		 �� ,stKoLayer (��3��, 8��) 1-3-X
//		��		 	 <AryKoMatchNodes>	
//		��		 		�� ,stKoMatchNode 1-3-1
//		��		 		��		��	    
//		��		 		��	 ,PlayerL:  Player1
//		��		 		��	 ,PlayerR:  Player2
//		��		 		��	 ,Win:	goto 1-2-1-L
//		��		 		��	 ,Lost: goto 3-2-1-L
//		��		        ��
//		��		 		�� ,stKoMatchNode 1-3-2
//		��		 		��		��	    
//		��		 		��	 ,PlayerL:  Player3
//		��		 		��	 ,PlayerR:  Player4
//		��		 		��	 ,Win:	goto 1-2-1-R
//		��		 		��	 ,Lost: goto 3-2-1-R
//		��		        ��
//		��		 		�� ,stKoMatchNode 1-3-3
//		��		 		��		��	    
//		��		 		��	 ,PlayerL:  Player5
//		��		 		��	 ,PlayerR:  Player6
//		��		 		��	 ,Win:	goto 1-2-2-L
//		��		 		��	 ,Lost: goto 3-2-2-L
//		��		        ��
//		��		 		�� ,stKoMatchNode 1-3-4
//		��		 				��	    
//		��		 			 ,PlayerL:  Player7
//		��		 			 ,PlayerR:  Player8
//		��		 			 ,Win:	goto 1-2-2-R
//		��		 			 ,Lost: goto 3-2-2-R
//		��
//		��
//		��
//		��	,stKoPyramid (������,����3,4��) 2-X-X		ǰ4��,��Ҫ������
//		��	 <AryKoLayers>
//		��		 ��
//		��		 �� ,stKoLayer (��1��, 2��) 2-1-X
//		��		  	 <AryKoMatchNodes>	
//		��		 		�� ,stKoMatchNode 2-2-1
//		��		 				��	 
//		��		 			 ,Win:  goto Rank3
//		��		 			 ,Lost: goto Rank4
//		��
//		��
//		��	,stKoPyramid (������,����5,6��) 3-X-X		ǰ6��,��Ҫ������
//		��	 <AryKoLayers>
//		��		 ��
//		��		 �� ,stKoLayer (��1��, 2��) 3-1-X
//		��		 ��	 <AryKoMatchNodes>	
//		��		 ��		�� ,stKoMatchNode 3-1-1
//		��		 ��				��	    
//		��		 ��			 ,Win:	Rank5
//		��		 ��			 ,Lost: Rank6
//		��		 ��     
//		��		 ��		
//		��		 �� ,stKoLayer (��2��, 4��) 3-2-X
//		��		 	 <AryKoMatchNodes>	
//		��		 		�� ,stKoMatchNode 3-2-1
//		��		 		��		��	 
//		��		 		��	 ,Win:  goto 3-1-1-L
//		��		 		��	 ,Lost: goto 4-1-1-L
//		��		        ��
//		��		 		�� ,stKoMatchNode 3-2-2
//		��		 				��	 
//		��		 			 ,Win:  goto 3-1-1-R
//		��		 			 ,Lost: goto 4-1-1-R
//		��
//		��
//		��	,stKoPyramid (������,����7,8��) 4-X-X		ǰ8��,��Ҫ������
//			 <AryKoLayers>
//				 ��
//				 �� ,stKoLayer (��1��, 2��) 4-1-X
//				 	 <AryKoMatchNodes>	
//				 		�� ,stKoMatchNode 4-1-1
//				 				��	    
//				 			 ,Win:	Rank7
//				 			 ,Lost: Rank8

namespace AutoSports.OVRDrawModel
{
    //һ���ڵ�ı�����ɺ�,��Ծ��ʽ����
    public class stKoJumpInfo
    {
        public Int32 m_MAX_RANK = 8;
        public EKnockOutJumpKind m_byJumpKind;	//��Ծ����
        public Byte m_byPyramindIndexOrRank;	//��������Ż���������
        public Byte m_byLayerIndex;			    //�����
        public Byte m_byNodeIndex;				//�ڵ����
        public Boolean m_byIsWin;			    //ʤ����ʧ��, ��GetMatchPlayerFrom()����Ľ����ʹ��

	    public stKoJumpInfo()
        {
            Clean();
        }

        public void Clean()
        {
            m_byJumpKind = EKnockOutJumpKind.emkoJumpNone;
	        m_byPyramindIndexOrRank = 0;
	        m_byLayerIndex = 0;
	        m_byNodeIndex = 0;

	        m_byIsWin = false;
        }

	    //����Jump��������
        public Boolean SetJumpToOut()
        {
            Clean();
            m_byJumpKind = EKnockOutJumpKind.emkoJumpOut;

	        return true;
        }

        public Boolean SetJumpToRank(Int32 nRank)
        {
            if (nRank < 0 || nRank > m_MAX_RANK)
	        {
		        return false;
	        }

	        Clean();
            m_byJumpKind = EKnockOutJumpKind.emkoJumpRank;
	        m_byPyramindIndexOrRank = (Byte)nRank;

	        return true;
        }

        public Boolean SetJumpToPos(Byte byPyramind, Byte byLayer, Byte byNode, Boolean bIsLeft)
        {
            Clean();
            m_byJumpKind = bIsLeft ? EKnockOutJumpKind.emkoJumpLeft : EKnockOutJumpKind.emkoJumpRight;
	        m_byPyramindIndexOrRank = byPyramind;
	        m_byLayerIndex = byLayer;
	        m_byNodeIndex = byNode;

	        return true;
        }

        public Boolean SetJumpToPointer(Byte byPyramind, Byte byLayer, Byte byNode, Boolean bIsWin)
        {
            Clean();
            m_byJumpKind = EKnockOutJumpKind.emkoAsPointer;
	        m_byPyramindIndexOrRank = byPyramind;
	        m_byLayerIndex = byLayer;
	        m_byNodeIndex = byNode;
	        m_byIsWin = bIsWin;

	        return true;
        }

        public Boolean IsJumpOut()
        {
            return (m_byJumpKind == EKnockOutJumpKind.emkoJumpOut);
        }

        public Boolean IsJumpPos()
        {
            return (m_byJumpKind == EKnockOutJumpKind.emkoJumpLeft || m_byJumpKind == EKnockOutJumpKind.emkoJumpRight);
        }

        public Boolean IsJumpRank()
        {
            return (m_byJumpKind == EKnockOutJumpKind.emkoJumpRank);
        }

        public Boolean IsJumpLeft()
        {
            return (m_byJumpKind == EKnockOutJumpKind.emkoJumpLeft);
        }

        public Boolean IsJumpRight()
        {
            return (m_byJumpKind == EKnockOutJumpKind.emkoJumpRight);
        }

        public Boolean IsJumpAsPointer()
        {
            return (m_byJumpKind == EKnockOutJumpKind.emkoAsPointer);
        }

        public String GetDesc()   //��ȡ��������
        {
            String strMsg = "";

	        if ( IsJumpOut() )
		        strMsg = "Out";
	        else if ( IsJumpRank() )
		        strMsg = String.Format("Rank{0}", m_byPyramindIndexOrRank);
	        else if ( IsJumpPos() )
                strMsg = String.Format("{0}-{1}-{2}-'{3}'", m_byPyramindIndexOrRank + 1, m_byLayerIndex + 1, m_byNodeIndex + 1, IsJumpLeft() ? "L" : "R");

            return strMsg;
        }
    }

    //һ���ڵ����
    public class stKoMatchNode
    {
        public stKoJumpInfo m_oJumpWin;	//ʤ����ȥ�ĸ��ڵ�
        public stKoJumpInfo m_oJumpLost;	//ʧ�ܺ�ȥ�ĸ��ڵ�

        public Int32 m_nRowTemp;				//�ڵ����˽ṹʱ,��ʱ�����к���

        public stKoMatchNode()
        {
            m_nRowTemp = 0;
            m_oJumpWin = new stKoJumpInfo();
            m_oJumpLost = new stKoJumpInfo();
        }
    }

    //�������е�һ��
    public class stKoLayer
    {
        public List<stKoMatchNode> m_aryOneLayer;

	    public stKoLayer()
        {
            m_aryOneLayer = new List<stKoMatchNode>();
        }

        public void RemoveAll()
        {
            m_aryOneLayer.Clear();
        }

        public Int32 GetNodeCount()
        {
            return m_aryOneLayer.Count;
        }

        public Int32 AddNodeObj(stKoMatchNode matchNode)
        {
            m_aryOneLayer.Add(matchNode);
            return m_aryOneLayer.Count;
        }

        public stKoMatchNode GetNodeObj(int nIndex)
        {
            if (nIndex < 0 || nIndex >= GetNodeCount())
            {
                return null;
            }

            return m_aryOneLayer[nIndex];
        }
    }

    //һ��������,ֻ��һ������Ҳ��һ��������
    public class stKoPyramid
    {
        public List<stKoLayer> m_aryAllLayer;

	    public stKoPyramid()
        {
            m_aryAllLayer = new List<stKoLayer>();
        }

	    public void RemoveAll()
        {
            m_aryAllLayer.Clear();
        }

	    public Int32 GetLayerCount()
        {
            return m_aryAllLayer.Count;
        }

	    public Int32 AddLayerObj(stKoLayer matchLayer)
        {
            m_aryAllLayer.Add(matchLayer);
            return m_aryAllLayer.Count;
        }

	    public stKoLayer GetLayerObj(int nIndex)
        {
            if (nIndex < 0 || nIndex >= GetLayerCount())
            {
                return null;
            }

            return m_aryAllLayer[nIndex];
        }
    }

    //һ���׶ε���̭��
    public class stKoStage
    {
        public List<stKoPyramid> m_aryAllPyramid;

	    public stKoStage()
        {
            m_aryAllPyramid = new List<stKoPyramid>();
        }

        public void RemoveAll()
        {
            m_aryAllPyramid.Clear();
        }

        public Int32 GetPyramidCount()
        {
            return m_aryAllPyramid.Count;
        }

        public Int32 AddPyramidObj(stKoPyramid matchPyramid)
        {
            m_aryAllPyramid.Add(matchPyramid);
            return m_aryAllPyramid.Count;
        }

	    //�����̭���ж��ٲ�
        public Int32 GetLayerCount()
        {
            if (GetPyramidCount() < 1)
                return 0;

            stKoPyramid pMainPyramid = GetPyramidObj(0);
            return pMainPyramid.GetLayerCount();
        }

	    //�����̭�������ɶ�����
        public Int32 GetMaxPlayerCount()
        {
            return (Int32)Math.Pow( 2, GetLayerCount() );
        }

        public stKoPyramid GetPyramidObj(int nIndex)
        {
            if (nIndex < 0 || nIndex > GetPyramidCount())
            {
                return null;
            }

            return m_aryAllPyramid[nIndex];
        }

        public stKoMatchNode GetMatchObj(stKoJumpInfo JumpInfo)
        {
            if (!JumpInfo.IsJumpPos() && !JumpInfo.IsJumpAsPointer())
            {
                return null;
            }

            stKoPyramid pPyramindObj = GetPyramidObj(JumpInfo.m_byPyramindIndexOrRank);
            if ( pPyramindObj == null )
            {
                return null;
            }

            stKoLayer pLayerObj = pPyramindObj.GetLayerObj(JumpInfo.m_byLayerIndex);
            if ( pLayerObj == null )
            {
                return null;
            }

            stKoMatchNode pNodeObj = pLayerObj.GetNodeObj(JumpInfo.m_byNodeIndex);
            if ( pNodeObj == null )
            {
                return null;
            }

            return pNodeObj;
        }

	    //һ���ڵ�����˶�Ա������
        public stKoJumpInfo GetMatchPlayerFrom(stKoJumpInfo jumpInfo, Boolean bIsFromLeft)
        {
            stKoJumpInfo jumpInfoRet = new stKoJumpInfo();

            int nPyramidCnt = GetPyramidCount();

            for (int nPyramid = 0; nPyramid < nPyramidCnt; nPyramid++)
            {
                stKoPyramid pPyramid = GetPyramidObj(nPyramid);
                if (pPyramid == null )
                {
                    return null;
                }

                int nLayerCnt = pPyramid.GetLayerCount();

                for (Int32 nLayer = 0; nLayer < nLayerCnt; nLayer++)
                {
                    stKoLayer pLayer = pPyramid.GetLayerObj(nLayer);
                    if(pLayer == null)
                    {
                        return null;
                    }

                    int nNodeCnt = pLayer.GetNodeCount();

                    for (int nNode = 0; nNode < nNodeCnt; nNode++)
                    {
                        stKoMatchNode pNode = pLayer.GetNodeObj(nNode);
                        if(pNode == null)
                        {
                            return null;
                        }

                        if (pNode.m_oJumpWin.IsJumpPos())
                        {
                            if (pNode.m_oJumpWin.m_byPyramindIndexOrRank == jumpInfo.m_byPyramindIndexOrRank &&
                                 pNode.m_oJumpWin.m_byLayerIndex == jumpInfo.m_byLayerIndex &&
                                 pNode.m_oJumpWin.m_byNodeIndex == jumpInfo.m_byNodeIndex &&
                                 pNode.m_oJumpWin.IsJumpLeft() == bIsFromLeft)
                            {
                                jumpInfoRet.SetJumpToPointer((Byte)nPyramid, (Byte)nLayer, (Byte)nNode, true);
                                return jumpInfoRet;
                            }
                        }

                        if (pNode.m_oJumpLost.IsJumpPos())
                        {
                            if (pNode.m_oJumpLost.m_byPyramindIndexOrRank == jumpInfo.m_byPyramindIndexOrRank &&
                                pNode.m_oJumpLost.m_byLayerIndex == jumpInfo.m_byLayerIndex &&
                                pNode.m_oJumpLost.m_byNodeIndex == jumpInfo.m_byNodeIndex &&
                                pNode.m_oJumpLost.IsJumpLeft() == bIsFromLeft)
                            {
                                jumpInfoRet.SetJumpToPointer((Byte)nPyramid, (Byte)nLayer, (Byte)nNode, false);
                                return jumpInfoRet;
                            }
                        }
                    }
                }
            }

            return jumpInfoRet;
        }
    }
}
