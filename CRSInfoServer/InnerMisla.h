#pragma once

#include "DFSTopicManager.h"

class CAxDBOperator
{
public:
	static BOOL ValidateDBInfoTable();
	static BOOL GetAllTopicItems(SAxTableRecordSet& rsResult, CString strDisciplineCode = _T(""));

	static BOOL InsertTopicItem(STopicItem* pTopicItem);
	static BOOL UpdateTopicItem(STopicItem* pTopicItem);
	static BOOL DeleteTopicItem(STopicItem* pTopicItem);
	static BOOL GetScheduleTree(CAxADODataBase* pDB, int iID, int iType, CString strLanguageCode, OUT CAxADORecordSet& obRecordSet);
};