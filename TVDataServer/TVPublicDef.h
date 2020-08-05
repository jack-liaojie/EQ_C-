/********************************************************************
	created:	2009/12/28
	filename: 	TVPublicDef.h

	author:		GRL
*********************************************************************/
#pragma once

#define STR_SESSIONSTS_TABLENAME		_T("session.sts")
#define STR_EVENTGRD_TABLENAME			_T("event.grd")

#define STR_EXPORT_SPECIALTOKEN			_T("|")
#define STR_EXPORT_FILEEXTNAME			_T(".csv")
#define STR_EXPORT_CSVROWTOKEN			_T("\n")
#define STR_EXPORT_CSVSTRINGTOKEN		_T("\"")
#define STR_EXPORT_CSVSPLITTOKEN		_T(";")

#define STR_TYPE_UNKNOWN				_T("Type_Unknown")
#define STR_NODETYPE_DISCIPLINE			_T("Type_Discipline")
#define STR_NODETYPE_SESSION			_T("Type_Session")
#define STR_NODETYPE_EVENT				_T("Type_Event")
#define STR_NODETYPE_COURT				_T("Type_Court")

#define STR_TVOPERATION_REBUILD_ALL		_T("OP_RebuildAll")
#define STR_TVOPERATION_EXPORT_ALL		_T("OP_ExportAll")
#define STR_TVOPERATION_REBUILD_SESSION	_T("OP_RebuildSession")
#define STR_TVOPERATION_EXPORT_SESSION	_T("OP_ExportSession")
#define STR_TVOPERATION_EVENT_ADD		_T("OP_AddEvent")
#define STR_TVOPERATION_EVENT_DEL		_T("OP_DelEvent")


#define MSG_EXPORT_NOTIFY				WM_USER + 1000
//#define MSG_REBUILD_TREE				WM_USER + 1001

//#define STR_TVOPERATION_EVENT_UPDATE	_T("OP_EventUpdate")
//#define STR_TVOPERATION_EVENT_DEL		_T("OP_EventDel")
//#define STR_TVOPERATION_SESSION_ADD		_T("OP_SessionAdd")
//#define STR_TVOPERATION_SESSION_UPDATE	_T("OP_SessionUpdate")
//#define STR_TVOPERATION_SESSION_DEL		_T("OP_SessionDel")
//#define STR_TVOPERATION_COURT_ADD		_T("OP_CourtAdd")
//#define STR_TVOPERATION_COURT_UPDATE	_T("OP_CourtUpdate")
//#define STR_TVOPERATION_COURT_DEL		_T("OP_CourtDel")	

#define MID_FRAME_WIDTH				9
#define MIN_WND_HEIGHT				50
#define MIN_WND_WIDTH				50

enum EMTVOperationType
{
	emTVOPUnknown = 0,
	emTVOPRebuildAll,
	emTVOPExportAll,
	emTVOPRebuildSession,
	emTVOPExportSession,	
	emTVOPAddEvent,
	emTVOPDelEvent
};

CString OperationType2String(EMTVOperationType eType);
EMTVOperationType Str2OperationType(CString strType);

struct STNotifyMsg 
{
	CString strType;
	CString strDisciplineID;
	CString strEventID;
	CString strPhaseID;
	CString strMatchID;
	CString strSessionID;
	CString strCourtID;
};

typedef CArray<STNotifyMsg, STNotifyMsg&> AryNotifyMsgs;

class CTVCriticalSection : public CCriticalSection
{
public:
	BOOL Unlock()				{ 	return __super::Unlock();	};//TRACE(_T("Unlock() \n"));
	BOOL Lock()					{ 	return __super::Lock();		};//TRACE(_T("Lock() \n"));
	BOOL Lock(DWORD dwTimeout)	{ 	return __super::Lock();		};//TRACE(_T("Lock() \n"));
};

#define DECLARE_THREAD_SAFETY	CTVCriticalSection m_CriticalSection;
#define ENTER_THREAD_SAFETY		CSingleLock singleLock((CSyncObject *)&m_CriticalSection, TRUE); 

#define MGR_LOCK_TRACE		g_TVDataManager.m_CriticalSection.Lock(); TRACE(_T("MGR Lock(), "));
#define MGR_UNLOCK_TRACE	TRACE(_T("MGR Unlock() \n")); g_TVDataManager.m_CriticalSection.Unlock(); 

static BOOL IsValidID(CString strID)
{
	return _ttoi(strID) > 0;
}

static int StraValueToIndex(CStringArray &straArray, CString strValue)
{
	int nIndex = -1;
	int nCount = straArray.GetCount();
	for (int i=0; i < nCount; i++)
	{
		if (straArray[i].CompareNoCase(strValue) == 0 )
		{
			nIndex = i;
			break;
		}
	}

	return nIndex;
}