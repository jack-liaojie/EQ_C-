/********************************************************************
	created:	2009/12/25
	filename: 	TVTableSessionSts.h

	author:		GRL
*********************************************************************/

#pragma once
#include "tvtable.h"

class CTVTableSessionSts :	public CTVTable
{
	DECLARE_DYNAMIC(CTVTableSessionSts)

public:
	CTVTableSessionSts(void);
	~CTVTableSessionSts(void);

	virtual BOOL GetSQLResults(OUT SAxTableRecordSet &sRecordSet, CString strParentNodeID, CString strParentNodeParentID = _T(""));
	virtual BOOL GetSQLResults(OUT SAxTableRecordSet &sRecordSet); 
};
