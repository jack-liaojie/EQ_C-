#include "StdAfx.h"
#include "TVTableEventGrd.h"
#include "TVEvent.h"

IMPLEMENT_DYNAMIC(CTVTableEventGrd, CTVTable)

CTVTableEventGrd::CTVTableEventGrd(void)
{
}

CTVTableEventGrd::~CTVTableEventGrd(void)
{
}

BOOL CTVTableEventGrd::GetSQLResults(OUT SAxTableRecordSet &sRecordSet, CString strParentNodeID, CString strParentNodeParentID /* = _T */)
{
	sRecordSet.RemoveAll();

	sRecordSet.m_aryFieldsName.Add(_T("Filename"));
	sRecordSet.m_aryFieldsName.Add(_T("Checksum"));

	int nTableCount = m_pParentNode->m_ChildTables.GetTableCount();
	for (int i = 0; i < nTableCount; i++)
	{
		CTVTable *pTable = m_pParentNode->m_ChildTables.GetTable(i);
		if (pTable->IsKindOf(RUNTIME_CLASS(CTVTableEventGrd)))
			continue;
		
		//if checksum of this table is empty, we can assume that this file is not exist.
		//so we will pass this file
		if (pTable->m_strChecksum == _T(""))
			continue;

		SAxRowRecord sRowRecord;
		sRowRecord.m_aryRowColValue.Add(pTable->m_strTableName);
		sRowRecord.m_aryRowColValue.Add(pTable->m_strChecksum);
		sRecordSet.m_aryRowRecords.Add(sRowRecord);
	}

	return TRUE;
}
BOOL CTVTableEventGrd::GetSQLResults(OUT SAxTableRecordSet &sRecordSet)
{
	if (!m_pParentNode)
		return FALSE;

	return GetSQLResults(sRecordSet, m_pParentNode->m_strID);
}