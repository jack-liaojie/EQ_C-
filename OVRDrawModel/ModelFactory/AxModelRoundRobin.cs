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

            // 1. ��ӡ�ڲ��ṹ
            {
                strMsg = String.Format("���ǹ���{0:D}���� \r\n", m_oGroup.GetPlayerCnt());
                StrOut = strMsg;

                for (Int32 nRound = 0; nRound < m_oGroup.GetRoundCount(); nRound++)
                {
                    stRrRound pRound = m_oGroup.GetRoundObj(nRound);
                    strMsg = String.Format("��{0:D}��: \r\n", nRound + 1);
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

            // 2.��ӡ����ṹ
            {
                AxDrawModelMatchList aryMatch = new AxDrawModelMatchList();
                GetModelExport(aryMatch);

                for (Int32 nCycRow = 0; nCycRow < (Int32)aryMatch.m_aryMatchRow.Count; nCycRow++)
                {
                    AxDrawModelMatchRow pMatchRow = aryMatch.m_aryMatchRow[nCycRow];

                    strMsg = String.Format("{0:D} ��{1:D}��-��{2:D}��", nCycRow + 1,
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

	    //nPlayerCnt: ��������,��С2��,���32��
	    //bUseBegol: ʹ�ñ������ŷ�
	    public Boolean Create(Int32 nPlayerCnt, Boolean bUseBegol)
        {
            // 1. ����������
            if (nPlayerCnt < 2 || nPlayerCnt > 32)
            {
                m_strLastError = "Err in CreateStage(): nPlayerCnt������ɷ�Χ!";
                return false;
            }

            // 2. �����µ�Stage
            Boolean bRet = _Create(nPlayerCnt, bUseBegol);

            // 3.������������Ĭ����ӱ�(λ����Ʊ�)
            {
                //ѭ����Ŀǰ������ʲôվλ����
                //��ӱ�����ǽ���������,�����Ȳ�����
            }

            return true;
        }

	    //�������һ�������Ĵ������������
	    //�����һ�������޴���,���� _T("")
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

        //��ѭ��
	    protected Boolean _Create(Int32 nPlayerCnt, Boolean bUseBegol )
        {
            //2. ���ɴ������õĶ�Ա����
            //CArray<int, int> aryRound;
            ArrayList aryRound = new ArrayList();
            int nPlayerCntInAry = 0;
            {
                for (Int32 nCycPlayer = 0; nCycPlayer < nPlayerCnt; nCycPlayer++)
                {
                    aryRound.Add(nCycPlayer + 1);	//��1��ʼ
                }

                //�����Ա�ǵ���,����ֿ��õ�0�Ŷ�
                if (nPlayerCnt % 2 == 1)
                {
                    if (bUseBegol)
                        aryRound.Add(0);	//������㷨ʱ,�ֿռ������
                    else
                        aryRound.Add(0);	//��ͨ��ѭ��,�ֿռ������	
                }

                nPlayerCntInAry = aryRound.Count;
                //ASSERT(nPlayerCntInAry % 2 == 0);
            }

            //3. ѭ�����ɱ����������
            m_oGroup.SetPlayerCnt((Byte)nPlayerCnt); //Ϊһ�����ֶ� �����ж���ֻ������ ����Ϣ

            Int32 nRoundCnt = nPlayerCntInAry - 1; // ����ʱ�Ѿ��������ֿ�

            for (Int32 nRound = 0; nRound < nRoundCnt; nRound++)
            {
                stRrRound matchRound = new stRrRound();

                for (int nMatch = 0; nMatch < nPlayerCntInAry / 2; nMatch++)
                {
                    stRrMatch matchObj = new stRrMatch();
                    matchObj.m_byPlayerL = Convert.ToByte(aryRound[nMatch]);	//��ǰ����
                    matchObj.m_byPlayerR = Convert.ToByte(aryRound[nPlayerCntInAry - nMatch - 1]); //�Ӻ���ǰ

                    //������㷨��,�����ֵĵ�һ������,���ҶԵ�
                    if (bUseBegol && nRound % 2 == 1 && nMatch == 0)
                    {
                        Byte byTemp = matchObj.m_byPlayerL;
                        matchObj.m_byPlayerL = matchObj.m_byPlayerR;
                        matchObj.m_byPlayerR = byTemp;
                    }

                    matchRound.AddMatchObj(matchObj);
                }

                //�����һλ������Ų���ڶ�λ,�ڱ�����㷨��,����λ,�൱��ת���
                if (!bUseBegol)
                {
                    Int32 nMoveTarget = Convert.ToInt32(aryRound[nPlayerCntInAry - 1]); //��ͨ�㷨,�Ͱ����һλŲ���ڶ�λ
                    aryRound.RemoveAt(nPlayerCntInAry - 1);
                    aryRound.Insert(1, nMoveTarget);
                }
                else
                {
                    int nJump = _GetBegolJumpCnt(nPlayerCntInAry); //ÿ����ת��λ��
                    for (int nCyc = 0; nCyc < nJump; nCyc++)
                    {
                        int nMoveTarget = Convert.ToInt32(aryRound[nPlayerCntInAry - 2]); //�����,�����ڶ�λŲ����һλ,Ų���
                        aryRound.RemoveAt(nPlayerCntInAry - 2);
                        aryRound.Insert(0, nMoveTarget);
                    }
                }

                m_oGroup.AddRoundObj(matchRound);
            }//For Round	

            m_bIsUseBegol = bUseBegol;
            return true;
        }

	    //�ڱ����ѭ����,ÿ�δ����������ǰ��������
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
	    protected stRrGroup m_oGroup = new stRrGroup();	//һ������
    }
}
