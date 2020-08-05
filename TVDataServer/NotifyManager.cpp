#include "StdAfx.h"
#include "NotifyManager.h"

CNotifyManager::CNotifyManager(void)
{
}

CNotifyManager::~CNotifyManager(void)
{
}

void CNotifyManager::ReadConfig()
{
	ENTER_THREAD_SAFETY

	CString strConfigFile = CAxReadWriteINI::GetAppConfigFile();

	// Get notify types count
	CString strTypeCounts;
	CAxReadWriteINI::IniReadString(_T("NOTIFYTYPE_DEF"), _T("NOTIFY_COUNT"), strTypeCounts, strConfigFile);

	int nTypesCount = _ttoi(strTypeCounts);
	SetSize(nTypesCount);

	// Load notify types mapping topicIDs
	for (int i=0; i < nTypesCount; i++)
	{
		CString strTypeDef;
		CAxReadWriteINI::IniReadString(_T("NOTIFYTYPE_DEF"), _T("NOTIFY_TYPE") + AxCommonInt2String(i+1), strTypeDef, strConfigFile);
		m_straAllNotifyTypes[i] = strTypeDef;	

		CString strTopicIDs;
		CAxReadWriteINI::IniReadString(_T("NOTIFYTYPE_VALUES"), m_straAllNotifyTypes[i], strTopicIDs, strConfigFile);
		m_straAllMapValues[i] = strTopicIDs;
	}
}

void CNotifyManager::WriteConfig()
{
	ENTER_THREAD_SAFETY

	CString strConfigFile = CAxReadWriteINI::GetAppConfigFile();

	int nTypesCount = m_straAllNotifyTypes.GetCount();
	CAxReadWriteINI::IniWriteString(_T("NOTIFYTYPE_DEF"), _T("NOTIFY_COUNT"), AxCommonInt2String(nTypesCount), strConfigFile);	

	for (int i=0; i < nTypesCount; i++)
	{
		CAxReadWriteINI::IniWriteString(_T("NOTIFYTYPE_DEF"), _T("NOTIFY_TYPE") + AxCommonInt2String(i+1), m_straAllNotifyTypes[i], strConfigFile);
		CAxReadWriteINI::IniWriteString(_T("NOTIFYTYPE_VALUES"), m_straAllNotifyTypes[i], m_straAllMapValues[i], strConfigFile);
	}

}

int CNotifyManager::GetCount()
{
	ENTER_THREAD_SAFETY

	return m_straAllNotifyTypes.GetCount();
}

void CNotifyManager::SetSize(int nSize)
{
	ENTER_THREAD_SAFETY	

	m_straAllNotifyTypes.SetSize(nSize);
	m_straAllMapValues.SetSize(nSize);
	m_naNotifyState.SetSize(nSize);
}

int CNotifyManager::FindType(CString strNotifyType)
{	
	ENTER_THREAD_SAFETY	

	int nFindIdx = -1;

	int nTypeCount = m_straAllNotifyTypes.GetCount();
	for (int i=0; i < nTypeCount; i++)
	{
		if (strNotifyType.CompareNoCase(m_straAllNotifyTypes[i]) == 0)
		{
			nFindIdx = i;
		}
	}

	return nFindIdx;
}

CString CNotifyManager::GetTypeAt(int nIndex)
{
	ENTER_THREAD_SAFETY	

	return m_straAllNotifyTypes[nIndex];
}
void CNotifyManager::SetTypeAt(int nIndex, CString strNewType)
{
	ENTER_THREAD_SAFETY

	m_straAllNotifyTypes[nIndex] = strNewType;

}
void CNotifyManager::SetTypeAt(CString strOldType, CString strNewType)
{
	ENTER_THREAD_SAFETY

	int nOldPos = FindType(strOldType);
	if (nOldPos >= 0)
		m_straAllNotifyTypes[nOldPos] = strNewType;
}
void CNotifyManager::AddType(CString strType, CString strValues)
{
	ENTER_THREAD_SAFETY	

	m_straAllNotifyTypes.Add(strType);
	m_straAllMapValues.Add(strValues);
	m_naNotifyState.Add(FALSE);
}
void CNotifyManager::DelTypeAt(int nIndex)
{
	ENTER_THREAD_SAFETY	

	m_straAllNotifyTypes.RemoveAt(nIndex);
	m_straAllMapValues.RemoveAt(nIndex);
	m_naNotifyState.RemoveAt(nIndex);
}


CString CNotifyManager::GetValuesAt(int nIndex)
{
	ENTER_THREAD_SAFETY	

	return m_straAllMapValues[nIndex];
}
CString CNotifyManager::GetValuesAt(CString strType)
{
	ENTER_THREAD_SAFETY	

	int nTypeIdx = FindType(strType);
	if (nTypeIdx < 0) 
		return _T("");

	return m_straAllMapValues[nTypeIdx];
}

void CNotifyManager::SetValuesAt(int nIndex, CString strValues)
{
	ENTER_THREAD_SAFETY

	m_straAllMapValues[nIndex] = strValues;
}
void CNotifyManager::SetValuesAt(CString strType, CString strValues)
{
	ENTER_THREAD_SAFETY

	int nTypeIdx = FindType(strType);
	if (nTypeIdx < 0) 
		return;

	m_straAllMapValues[nTypeIdx] = strValues;	
}

void CNotifyManager::SetTypeState(int nIndex)
{
	ENTER_THREAD_SAFETY

	m_naNotifyState[nIndex] = TRUE;
}
void CNotifyManager::ResetTypeState(int nIndex)
{
	ENTER_THREAD_SAFETY

	m_naNotifyState[nIndex] = FALSE;
}
BOOL CNotifyManager::GetTypeState(int nIndex)
{
	ENTER_THREAD_SAFETY

	return m_naNotifyState[nIndex];
}