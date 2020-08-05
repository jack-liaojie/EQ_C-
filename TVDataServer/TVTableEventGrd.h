/********************************************************************
	created:	2009/12/25
	filename: 	TVTableEventGrd.h

	author:		GRL
*********************************************************************/

#pragma once
#include "tvtable.h"

class CTVTableEventGrd : public CTVTable
{
	DECLARE_DYNAMIC(CTVTableEventGrd)

public:
	CTVTableEventGrd(void);
	~CTVTableEventGrd(void);

	virtual BOOL GetSQLResults(OUT SAxTableRecordSet &sRecordSet, CString strParentNodeID, CString strParentNodeParentID = _T(""));
	virtual BOOL GetSQLResults(OUT SAxTableRecordSet &sRecordSet); 

};
