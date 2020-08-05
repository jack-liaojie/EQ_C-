#include "StdAfx.h"
#include "TVTableSessionSts.h"
#include "TVEvent.h"

IMPLEMENT_DYNAMIC(CTVTableSessionSts, CTVTable)

CTVTableSessionSts::CTVTableSessionSts(void)
{
}

CTVTableSessionSts::~CTVTableSessionSts(void)
{
}

BOOL CTVTableSessionSts::GetSQLResults(OUT SAxTableRecordSet &sRecordSet, CString strParentNodeID, CString strParentNodeParentID /* = _T */)
{
	sRecordSet.RemoveAll();

	sRecordSet.m_aryFieldsName.Add(_T("DirectoryName"));
	sRecordSet.m_aryFieldsName.Add(_T("Status"));

	// Export children Nodes
	int nChildNodeCount = m_pParentNode->GetChildNodesCount();
	for (int i = 0; i < nChildNodeCount; i++)
	{
		CTVNodeBase *pChildNode = m_pParentNode->GetChildNode(i);
		if (!pChildNode->IsKindOf(RUNTIME_CLASS(CTVEvent)))
			continue;
		CTVEvent* pEventNode = (CTVEvent*)pChildNode;
		SAxRowRecord sRowRecord;
		sRowRecord.m_aryRowColValue.Add(pEventNode->m_strName);
		sRowRecord.m_aryRowColValue.Add(pEventNode->m_strStatus);
		sRecordSet.m_aryRowRecords.Add(sRowRecord);
	}

	return TRUE;
}

BOOL CTVTableSessionSts::GetSQLResults(OUT SAxTableRecordSet &sRecordSet)
{
	if (!m_pParentNode)
		return FALSE;

	if (m_emTableLevelType == emTypeCourt)
		return GetSQLResults(sRecordSet, m_pParentNode->m_strID, m_pParentNode->m_pParentNode->m_strID);
	else
		return GetSQLResults(sRecordSet, m_pParentNode->m_strID);
}