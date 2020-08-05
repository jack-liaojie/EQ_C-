#include "StdAfx.h"
#include "DFSTopicManager.h"

CTopicManager::CTopicManager()
{
}

CTopicManager::~CTopicManager()
{
	DeleteAll();
}

void CTopicManager::AddTail(STopicItem* pTopicItem) 
{
	ASSERT(pTopicItem != NULL);

	ENTER_THREAD_SAFETY

	m_aryTopicItems.Add(pTopicItem);	
}

void CTopicManager::SwapTopicItems(int iIdx1,int iIdx2) 
{
	ASSERT(iIdx1 >= 0 && iIdx1 < m_aryTopicItems.GetSize());

	ASSERT(iIdx2 >= 0 && iIdx2 < m_aryTopicItems.GetSize()) ;

	ENTER_THREAD_SAFETY

	STopicItem* pTemp = m_aryTopicItems[iIdx1];
	m_aryTopicItems[iIdx1] = m_aryTopicItems[iIdx2];
	m_aryTopicItems[iIdx2] = pTemp;

}

void CTopicManager::DeleteItem(const STopicItem* pTopicItem)
{
	if( pTopicItem == NULL )
		return ;

	ENTER_THREAD_SAFETY

	int nTopicCount = m_aryTopicItems.GetSize();
	for (int i = 0; i < nTopicCount; i++)
	{
		if ( m_aryTopicItems[i] == pTopicItem )
		{
			delete m_aryTopicItems[i];
			m_aryTopicItems.RemoveAt(i);
			break;
		}
	}
}

void CTopicManager::DeleteItem(int iIdx)
{
	ENTER_THREAD_SAFETY

	if( iIdx >= 0 && iIdx < m_aryTopicItems.GetSize())
	{
		STopicItem *pTopicItem = m_aryTopicItems[iIdx];
		
		delete pTopicItem;
		m_aryTopicItems.RemoveAt(iIdx);	
	}
}

int	 CTopicManager::FindIndex( STopicItem* pTopicItem) 
{
	int iIdx = -1;

	ENTER_THREAD_SAFETY
	
	if (!pTopicItem)
		return -1;

	int nTopicCount = m_aryTopicItems.GetSize();
	for (int i=0; i < nTopicCount; i++)
	{
		if( m_aryTopicItems[i] == pTopicItem )
		{
			iIdx = i;
			break ;
		}
	}

	return iIdx;
}

STopicItem* CTopicManager::DoesTopicItemExist(CString strMsgKey)
{
	ENTER_THREAD_SAFETY

	int nTopicCount = m_aryTopicItems.GetSize();
	for(int i = 0; i < nTopicCount; i++)
	{
		STopicItem* pItem = (STopicItem*)m_aryTopicItems[i];
		if( pItem->m_strMsgKey == strMsgKey)
		{
			return pItem;
		}	
	}

	return NULL;
}

void CTopicManager::DeleteAll()
{
	ENTER_THREAD_SAFETY

	while (m_aryTopicItems.GetSize() > 0)
	{
		STopicItem* pTopicItem = m_aryTopicItems[m_aryTopicItems.GetSize()-1];
		delete pTopicItem;

		m_aryTopicItems.RemoveAt(m_aryTopicItems.GetSize()-1);
	}
}

