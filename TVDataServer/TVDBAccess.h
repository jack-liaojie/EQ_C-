/********************************************************************
	created:	2009/12/21
	filename: 	TVDBAccess.h

	author:		GRL
*********************************************************************/

#pragma once


class CTVDBAccess
{
public:
	CTVDBAccess(void);
	~CTVDBAccess(void);

public:
	BOOL	GetAllSessionIDsAndNums(CString strDisciplineCode, 
		OUT CStringArray &straSessionIDs, OUT CStringArray &straSessionNums, OUT CStringArray  &straSessionDays); // Order by session number
	BOOL	GetAllMatchIDsAndCourts(CString strSessionID, 
		OUT CStringArray &straMatchIDs, OUT CStringArray &straCourtIDs, OUT CStringArray &straCourtNames); // Order by CourtID order
	
	CString GetDisciplineID(CString strDisciplineCode);
	CString GetMatchFullName(CString strMatchID);

	CString GetMatchStatus(CString strMatchID);
	CString GetCourtName(CString strCourtID);
	CString GetSessionID(CString strMatchID, OUT CString *pstrCourtID = NULL); // Get SessionID and CourtID

	BOOL	GetAllDisciplineDates(CString strDisciplineCode, OUT CStringArray &straDateIDs, OUT CStringArray &straDateNames);
	BOOL	GetDateSessions(CString strDisciplineCode, CString strDateID, OUT CStringArray &straSessionIDs, OUT CStringArray &straSessionNames);

	BOOL	GetTVTableContent(CString strSQL, OUT SAxTableRecordSet &sRecordSet);

	//CString GetSessionNum(CString strSessionID);
	//CString GetMatchName(CString strMatchID);
	//CString GetPhaseName(CString strPhaseID);
	//CString GetEventName(CString strEventID);
};

class CTVTable;
class CTVTableDBOperator
{
public:
	static BOOL ValidateDBTable();
	static BOOL GetAllTVTables(OUT SAxTableRecordSet& rsResult, CString strDisciplineCode = _T(""));
	
	static BOOL IsTableExist(CString strTableName);
	static BOOL InsertTVTable(CTVTable* pTable);
	static BOOL UpdateTVTable(CTVTable* pTable);
	static BOOL DeleteTVTable(CTVTable* pTable);
};

extern CTVDBAccess g_DBAccess;
