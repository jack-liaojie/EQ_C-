#pragma once


struct STopicItem
{
	DECLARE_THREAD_SAFETY

	CString m_strDisciplineCode;
	CString	m_strMsgType;
	CString m_strMsgName;
	CString m_strMsgLevel;

	CString m_strSQLProcedure;				
	CString m_strLanguage;

	CString m_strMsgKey;

	STopicItem()
	{
		m_strDisciplineCode = m_strMsgName = _T("");
		m_strMsgType = _T("-1");

		m_strSQLProcedure = _T("");
		m_strLanguage = _T("");

		m_strMsgKey = _T("");

	}

	STopicItem(const STopicItem& copy)
	{
		*this = copy;
	}

	STopicItem& operator= (const STopicItem& copy)
	{
		ENTER_THREAD_SAFETY

		m_strDisciplineCode = copy.m_strDisciplineCode;
		m_strMsgType = copy.m_strMsgType;
		m_strMsgName = copy.m_strMsgName;

		m_strSQLProcedure = copy.m_strSQLProcedure;
		m_strLanguage = copy.m_strLanguage;

		m_strMsgKey = copy.m_strMsgKey;

		return *this;
	}
};

typedef CArray<STopicItem*,STopicItem*> typeARRAYTOPICITEM;

class CTopicManager
{
public:
	DECLARE_THREAD_SAFETY
	CTopicManager();
	virtual ~CTopicManager();

	void AddTail(STopicItem* pTopicItem);
	void DeleteItem(const STopicItem* pTopicItem);
	void DeleteItem(int iIdx);
	void DeleteAll();

	STopicItem* DoesTopicItemExist(CString strMsgKey);
	STopicItem* GetTopicItem(int iIdx);
	STopicItem* GetTopicItemByID(CString strTopicID);
	STopicItem* GetTopicItemByMsgKey(CString strMsgKey);

	int FindIndex( STopicItem* pTopicItem );
	int GetCount()
	{
		ENTER_THREAD_SAFETY
		return (int)m_aryTopicItems.GetSize(); 
	}

	void SwapTopicItems(int iIdx1,int iIdx2); 

private:
	typeARRAYTOPICITEM	m_aryTopicItems;	
};

inline STopicItem* CTopicManager::GetTopicItem(int iIdx) 
{
	ENTER_THREAD_SAFETY

	if( iIdx >= 0 && iIdx < m_aryTopicItems.GetSize() )
		return m_aryTopicItems[iIdx];

	return NULL;
}

inline STopicItem* CTopicManager::GetTopicItemByID(CString strTopicID) 
{
	ENTER_THREAD_SAFETY

	for(int i = 0; i < m_aryTopicItems.GetSize(); i++)
	{
		STopicItem* pItem = (STopicItem*)m_aryTopicItems[i];
		if( pItem->m_strMsgType == strTopicID)
			return pItem;
	}
	return NULL;
}

inline STopicItem* CTopicManager::GetTopicItemByMsgKey(CString strMsgKey) 
{
	ENTER_THREAD_SAFETY

	for(int i = 0; i < m_aryTopicItems.GetSize(); i++)
	{
		STopicItem* pItem = (STopicItem*)m_aryTopicItems[i];
		if( pItem->m_strMsgKey == strMsgKey)
			return pItem;
	}
	return NULL;
}
