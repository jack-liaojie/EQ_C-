
#include "StdAfx.h"
#include "TVDataServer.h"
#include "TVDataManager.h"
#include "TVDataServerDlg.h"

CTVDataManager g_TVDataManager;

CTVDataManager::CTVDataManager():m_EventExportIdle(TRUE, TRUE)
{
	m_bInitialized = FALSE;
	m_bExportStarted = FALSE;

	m_bShowCourt = FALSE;
	m_pTreeToShow = NULL;
	m_pParentWnd = NULL;

	m_iconList.Create(19, 19, ILC_COLOR32, 3, 1);
	m_iconList.Add( LoadIcon(::GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_ICON_FOLDER)) );
	m_iconList.Add( LoadIcon(::GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_ICON_FILE)) );
	m_iconList.Add( LoadIcon(::GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_ICON_FILEGRD)) );
}

CTVDataManager::~CTVDataManager()
{
	CloseExportService();
	m_TVData.ClearAllData();
}

inline BOOL CTVDataManager::IsInitialized()
{
	return m_bInitialized;
}

BOOL CTVDataManager::SetTVEnvironment(CWnd *pParentWnd, CTreeCtrl *pTreeToShow, CString strDisciplineCode, CString strExportRootPath, BOOL bShowCourt)
{
	m_bInitialized = FALSE;

	if (!pParentWnd || !::IsWindow(pParentWnd->GetSafeHwnd()))
		return FALSE;
	if (!pTreeToShow || !::IsWindow(pTreeToShow->GetSafeHwnd()))
		return FALSE;

	if (g_DBAccess.GetDisciplineID(strDisciplineCode).IsEmpty())
	{
		g_Log.OutPutMsg(_T("Get disciplineID fail. Ensure the discipline code is valid!"));
		return FALSE;
	}

	if (!AxCommonDoesDirExist(strExportRootPath))
	{
		if (!AxCommonCreateDir(strExportRootPath))
		{
			g_Log.OutPutMsg(_T("Export root path does not exist!"));
			return FALSE;
		}
	}

	m_pParentWnd = pParentWnd;
	m_pTreeToShow = pTreeToShow;

	m_strDisciplineCode = strDisciplineCode;
	m_strExportPath = strExportRootPath;		
	m_bShowCourt = bShowCourt;

	m_TVData.ClearAllData();

	m_bInitialized = TRUE;

	return TRUE;
}

BOOL CTVDataManager::CreateTVData()
{
	if (!m_bInitialized)
	{
		AfxMessageBox(_T("Please Set TV Environment First!"));
		return FALSE;
	}
	
	if (!InitDiscipline(m_strDisciplineCode, m_strExportPath, m_bShowCourt))
		return FALSE;

	return TRUE;
}

void CTVDataManager::ExportTVData()
{
	MGR_LOCK_TRACE;

	CTVNodeBase* pRootNode = OnExportAll();

	MGR_UNLOCK_TRACE;

	TriggerExport(pRootNode);
}

BOOL CTVDataManager::OpenExportService()
{
	if (m_bExportStarted)
		return TRUE;

	if (m_ExportMgr.StartExportService(&m_TVData, &m_CriticalSection, &m_EventExportIdle))
		m_bExportStarted = TRUE;
	else
		m_bExportStarted = FALSE;

	return m_bExportStarted;
}
void CTVDataManager::CloseExportService()
{
	if (m_bExportStarted)
	{
		m_ExportMgr.StopExportService();
	}

	m_bExportStarted = FALSE;	
}

BOOL CTVDataManager::InitDiscipline(CString strDisciplineCode, CString strExportRootPath, BOOL bShowCourt /*= FALSE*/)
{
	// Init Discipline
	m_TVData.m_strName = strDisciplineCode;
	m_TVData.m_strID = g_DBAccess.GetDisciplineID(strDisciplineCode);
	m_TVData.m_emNodeType = emTypeDiscipline;
	m_TVData.m_strPath = strExportRootPath.TrimRight(_T("\\")) + _T("\\") + strDisciplineCode;

	InitSessions(&m_TVData);
	InitNodeTables(&m_TVData);

	return TRUE;
}

BOOL CTVDataManager::InitSessions(CTVNodeBase* pNodeDiscipline)
{
	if (!pNodeDiscipline)
		return NULL;

	pNodeDiscipline->RemoveAllChildNodes();

	// GetSessions
	CStringArray straSessionIDs;
	CStringArray straSessionNames;
	if (m_pParentWnd && m_pParentWnd->IsKindOf(RUNTIME_CLASS(CTVDataServerDlg)))
	{
		CTVDataServerDlg* pDlg = (CTVDataServerDlg*)m_pParentWnd;
		pDlg->GetSessionIDsAndNames(straSessionIDs, straSessionNames);
	}
	if (straSessionIDs.GetCount() <= 0)
	{	
		CStringArray straSessionNums;
		CStringArray straSessionDays;
		g_DBAccess.GetAllSessionIDsAndNums(pNodeDiscipline->m_strName, straSessionIDs, straSessionNums, straSessionDays);
		int nSessionCount = straSessionIDs.GetCount();
		for (int i=0; i < nSessionCount; i++)
		{
			straSessionNames.Add(FormatSessionName(pNodeDiscipline->m_strName, straSessionNums[i], straSessionDays[i]));
		}
	}

	// Create session Nodes
	int nSessionCount = straSessionIDs.GetCount();
	for (int i=0; i < nSessionCount; i++)
	{
		CTVNodeBase* pNodeSession = new CTVSession;

		// Init One Session
		pNodeSession->m_strID = straSessionIDs[i];
		pNodeSession->m_strName = straSessionNames[i];
		pNodeSession->m_emNodeType = emTypeSession;
		pNodeSession->m_strPath = pNodeDiscipline->m_strPath.TrimRight(_T("\\")) + _T("\\") + pNodeSession->m_strName;
		pNodeSession->m_pParentNode = pNodeDiscipline;

		InitEvents(pNodeSession);
		InitNodeTables(pNodeSession);

		pNodeDiscipline->AddChildNode(pNodeSession);
	}

	return TRUE;
}

BOOL CTVDataManager::InitEvents(CTVNodeBase* pNodeSession)
{
	if (!pNodeSession)
		return NULL;

	pNodeSession->RemoveAllChildNodes();

	// GetMatchs
	CStringArray straMatchIDs;
	CStringArray straCourtIDs;
	CStringArray straCourtNames;
	g_DBAccess.GetAllMatchIDsAndCourts(pNodeSession->m_strID, straMatchIDs, straCourtIDs, straCourtNames);

	CTVNodeBase* pEventParentNode = pNodeSession; // default session is the parent of event;
	int nEventCount = straMatchIDs.GetCount();
	for (int i=0; i < nEventCount; i++)
	{
		// Insert Court node, if m_bShowCourt is TRUE
		if (m_bShowCourt)
		{
			CString strCourtID = straCourtIDs[i];
			if (strCourtID.IsEmpty())
				continue;

			CTVNodeBase* pNodeCourt = FindNode(strCourtID, emTypeCourt, pNodeSession);
			
			// Add new court node
			if (!pNodeCourt)
			{
				pNodeCourt = new CTVNodeBase;			
				pNodeCourt->m_strID = strCourtID;
				pNodeCourt->m_strName = straCourtNames[i];
				pNodeCourt->m_emNodeType = emTypeCourt;
				pNodeCourt->m_strPath = pNodeSession->m_strPath.TrimRight(_T("\\")) + _T("\\") + pNodeCourt->m_strName;
				pNodeCourt->m_pParentNode = pNodeSession;
				InitNodeTables(pNodeCourt);
				pNodeSession->AddChildNode(pNodeCourt);				
			}

			pEventParentNode = pNodeCourt;
		}

		// Insert One Event
		CTVEvent* pNodeEvent = new CTVEvent;
		pNodeEvent->m_strID = straMatchIDs[i];
		pNodeEvent->m_strName = g_DBAccess.GetMatchFullName(pNodeEvent->m_strID);
		pNodeEvent->m_strStatus = g_DBAccess.GetMatchStatus(pNodeEvent->m_strID);
		pNodeEvent->m_emNodeType = emTypeEvent;
		pNodeEvent->m_strPath = pEventParentNode->m_strPath.TrimRight(_T("\\")) + _T("\\") + pNodeEvent->m_strName;
		pNodeEvent->m_pParentNode = pEventParentNode;

		InitNodeTables(pNodeEvent);
		pEventParentNode->AddChildNode(pNodeEvent);
	}

	return TRUE;
}

void CTVDataManager::DeleteNode(CTVNodeBase* pNode)
{
	if (!pNode || pNode->m_emNodeType < emTypeDiscipline || pNode->m_emNodeType > emTypeEvent)
		return;
	if (!IsValidID(pNode->m_strID) || pNode->m_strPath.IsEmpty())
		return;

	// Delete path
	CString strDelPath = pNode->m_strPath;
	if (AxCommonDoesDirExist(strDelPath))
	{
		if (!AxCommonDeleteDir(strDelPath))
			g_Log.OutPutMsg(_T("Delete path \"") + strDelPath + _T("\" failed!"));
	}

	// Delete node
	if (pNode->m_emNodeType != emTypeDiscipline)
	{
		CTVNodeBase* pParentNode = pNode->m_pParentNode;
		if (pParentNode)
			pParentNode->DelChildNode(pParentNode->FindChildIndex(pNode));
	}
	else
	{
		pNode->ClearAllData();
	}

	ShowTVDataToTreeCtrl();
}

BOOL CTVDataManager::InitNodeTables(CTVNodeBase* pNode)
{
	if (!pNode)
		return FALSE;

	pNode->m_ChildTables.DeleteAllTable();

	int nTableCount = m_TableTemplates.GetTableCount();
	for (int i=0; i < nTableCount; i++)
	{
		CTVTable *pTable = m_TableTemplates.GetTable(i);
		if (pTable->m_emTableLevelType == pNode->m_emNodeType)
		{
			CTVTable* pFindTable = NULL;
			if (pTable->m_strTableName.CompareNoCase(STR_SESSIONSTS_TABLENAME) == 0)
			{
				pFindTable = new CTVTableSessionSts;
			}				
			else if (pTable->m_strTableName.CompareNoCase(STR_EVENTGRD_TABLENAME) == 0)
			{
				pFindTable = new CTVTableEventGrd;
			}
			else
			{
				pFindTable = new CTVTable;
			}

			*pFindTable = *pTable;
			
			pFindTable->m_pParentNode = pNode;
			pFindTable->m_strTableFileName = pNode->m_strPath.TrimRight(_T("\\")) + _T("\\") + FormatTableFileName(pFindTable->m_strTableName);
			pNode->m_ChildTables.AddTable(pFindTable);
		}
	}

	return TRUE;
}

CString CTVDataManager::FormatSessionName(CString strDisciplineCode, CString strSessionNum, CString strSessionDay)
{
	int nSessionNum = _ttoi(strSessionNum);
	strSessionNum.Format(_T("%s Session %s%02d"), strSessionDay, strDisciplineCode, nSessionNum);
	
	return AxCommonAdjustFileName(strSessionNum);
}
CString CTVDataManager::FormatTableFileName(CString strTableName)
{
	strTableName = AxCommonAdjustFileName(strTableName);

	if (strTableName.CompareNoCase(STR_EVENTGRD_TABLENAME) == 0)
	{
	}
	else if (strTableName.CompareNoCase(STR_SESSIONSTS_TABLENAME) == 0)
	{
	}
	else
	{
		strTableName += _T(".csv");
	}

	return strTableName;
}

void CTVDataManager::NodeToTreeCtrl(CTreeCtrl *pTree, CTVNodeBase *pNode)
{
	// Insert this Node
	HTREEITEM hParentNode = pNode->m_pParentNode ? pNode->m_pParentNode->m_hTreeCtrlItem : NULL;
	HTREEITEM hThisNode = pTree->InsertItem(pNode->m_strName, 0, 0, hParentNode);
	pNode->m_hTreeCtrlItem = hThisNode;
	pTree->SetItemData(hThisNode, (DWORD_PTR)pNode);

	// Insert child nodes
	int nChildCount = pNode->GetChildNodesCount();
	for (int i=0; i < nChildCount; i++)
	{
		NodeToTreeCtrl(pTree, pNode->GetChildNode(i));
	}

	// Insert related TVTables
	int nTableCount = pNode->m_ChildTables.GetTableCount();
	for (int i=0; i < nTableCount; i++)
	{
		CTVTable *pTable = pNode->m_ChildTables.GetTable(i);

		CString strTableFileName = FormatTableFileName(pTable->m_strTableName);

		int nIconIndex = 1;
		if (strTableFileName.Find(_T(".csv")) < 0)
		{
			nIconIndex = 2;
		}

		HTREEITEM hTableNode = pTree->InsertItem(strTableFileName , nIconIndex, nIconIndex, pNode->m_hTreeCtrlItem);


		pTable->m_hTreeCtrlItem = hThisNode;
		pTree->SetItemData(hTableNode, (DWORD_PTR)pTable);
	}
}

void CTVDataManager::ShowTVDataToTreeCtrl()
{
	if (!m_bInitialized)
		return;

	m_pTreeToShow->EnableWindow(FALSE);

	m_pTreeToShow->DeleteAllItems();

	m_pTreeToShow->SetImageList(&m_iconList, TVSIL_NORMAL);

	NodeToTreeCtrl(m_pTreeToShow, &m_TVData);

	m_pTreeToShow->Expand(m_TVData.m_hTreeCtrlItem, TVE_EXPAND );

	m_pTreeToShow->EnableWindow(TRUE);

}

//void CTVDataManager::AddChildNodesToCmb(CComboBox *pCmb, CTVNodeBase *pNode)
// {
// 	if (!pCmb || !::IsWindow(pCmb->GetSafeHwnd()))
// 		return;
// 
// 	pCmb->ResetContent();
// 
// 	// Insert child nodes
// 	int nChildCount = pNode->GetChildNodesCount();
// 	for (int i=0; i < nChildCount; i++)
// 	{
// 		CTVNodeBase *pChildNode = pNode->GetChildNode(i);
// 		pCmb->AddString(pChildNode->m_strName);
// 		pCmb->SetItemDataPtr(i, pChildNode);
// 	}
// 
// 	if (nChildCount >= 0)
// 	{
// 		pCmb->SetCurSel(0);
// 
// 		//Send CBN_SELCHANGE
// 		WPARAM wParam = MAKEWPARAM(pCmb->GetDlgCtrlID(), CBN_SELCHANGE);     
// 		BOOL bResult = ::SendMessage(pCmb->GetParent()->GetSafeHwnd(), WM_COMMAND, wParam, (LPARAM)(pCmb->GetSafeHwnd()) );
// 	}
// }


BOOL CTVDataManager::LoadAndShowTableTemplates(CAsCoolGridCtrl *pGrid)
{
	MGR_LOCK_TRACE;

	m_TableTemplates.DeleteAllTable();

	// Ensure the 'session.sts' exist
	if (!CTVTableDBOperator::IsTableExist(STR_SESSIONSTS_TABLENAME))
	{
		CTVTable TVTable;
		TVTable.m_strTableName = STR_SESSIONSTS_TABLENAME;
		TVTable.m_emTableLevelType = emTypeCourt;

		CTVTableDBOperator::InsertTVTable(&TVTable);
	}
	// Ensure the 'event.grd' exist
	if (!CTVTableDBOperator::IsTableExist(STR_EVENTGRD_TABLENAME))
	{
		CTVTable TVTable;
		TVTable.m_strTableName = STR_EVENTGRD_TABLENAME;
		TVTable.m_emTableLevelType = emTypeEvent;

		CTVTableDBOperator::InsertTVTable(&TVTable);
	}

	// Get all Tables from database
	SAxTableRecordSet stTableRecords;
	if (!CTVTableDBOperator::GetAllTVTables(stTableRecords, theApp.GetDisciplineCode())) return FALSE;

	int nRecordCount = stTableRecords.GetRowRecordsCount();
	for (int i=0; i < nRecordCount; i++)
	{
		CTVTable *pTVTable = new CTVTable;

		pTVTable->m_strTableName = stTableRecords.GetValue(_T("F_TableName"), i);

		pTVTable->m_strSQLProcedure = stTableRecords.GetValue(_T("F_SqlProcedure"), i);
		pTVTable->m_emTableLevelType = Str2NodeType(stTableRecords.GetValue(_T("F_TableLevelType"), i));

		m_TableTemplates.AddTable(pTVTable);
	}

	AxCommonFillGridCtrl(pGrid, stTableRecords);
	//pGrid->SetRowHeight(1, 0);
	pGrid->Refresh();

	MGR_UNLOCK_TRACE;

	return TRUE;
}

//////////////////////////////////////////////////////////////////////////
//
BOOL CTVDataManager::GetAllTableTemplateNames(OUT CStringArray &straTableNames)
{
	straTableNames.RemoveAll();

	MGR_LOCK_TRACE;

	// Get all the TVTable templates names
	int nTableCount = m_TableTemplates.GetTableCount();
	for (int i=0; i < nTableCount; i++)
	{
		CTVTable *pTable = m_TableTemplates.GetTable(i);
		straTableNames.Add(pTable->m_strTableName);
	}

	MGR_UNLOCK_TRACE;

	return TRUE;
}

BOOL CTVDataManager::ExportNodeTablesToFile(CTVNodeBase* pNode)
{
	if (!pNode)
		return FALSE;

	MGR_LOCK_TRACE;

	SetTableUpdateMark(pNode);

	MGR_UNLOCK_TRACE;

	TriggerExport(pNode);

	return TRUE;
}

void CTVDataManager::ProcessTVTableUpdate(STNotifyMsg &sNotifyMsg, CString &strTableName)
{
	MGR_LOCK_TRACE;

	CTVTable* pTemplateTable = m_TableTemplates.GetTableByName(strTableName);
	if (!pTemplateTable)
	{
		MGR_UNLOCK_TRACE;
		return;
	}
	
	EMTVNodeType emTableLevel = pTemplateTable->m_emTableLevelType;

	CTVNodeBase* pStartNode = FindDeepMostNode(sNotifyMsg, emTableLevel);
	if (!pStartNode)
	{
		MGR_UNLOCK_TRACE;
		return;
	}
	
	CStringArray straMarkTableNames;
	straMarkTableNames.Add(strTableName);
	SetTableUpdateMark(pStartNode, &straMarkTableNames);
	if (strTableName == STR_SESSIONSTS_TABLENAME) // Set m_strStatus of CEvent
	{
		SetEventStatus(pStartNode);
	}

	MGR_UNLOCK_TRACE;

	TriggerExport(pStartNode);
}

void CTVDataManager::ProcessTVOperation(STNotifyMsg &sNotifyMsg, EMTVOperationType emTVOperation, CStringArray *pstraTVTables)
{
	CTVNodeBase *pUpdateNode = NULL;

	if (emTVOperation == emTVOPRebuildAll || emTVOperation == emTVOPRebuildSession || emTVOperation == emTVOPDelEvent)
	{
		WaitForSingleObject(m_EventExportIdle.m_hObject, INFINITE);
	}

	MGR_LOCK_TRACE;

	switch (emTVOperation)
	{
	case emTVOPRebuildAll:
		pUpdateNode = OnRebuildAll();
		break;
	case emTVOPExportAll:
		pUpdateNode = OnExportAll();
		break;
	case emTVOPAddEvent:
		pUpdateNode = OnEventAdd(sNotifyMsg);
		break;
	case emTVOPDelEvent:
		pUpdateNode = OnEventDel(sNotifyMsg);
		break;

	case emTVOPRebuildSession:
		pUpdateNode = OnSessionRebuild(sNotifyMsg);
		break;

	case emTVOPExportSession:
		pUpdateNode = OnSessionExport(sNotifyMsg);
		break;

	//case emTVOPSessionDel:
	//	OnSessionDel(sNotifyMsg);
	//	break;
	//case emTVOPCourtAdd:
	//	OnCourtAdd(sNotifyMsg);
	//	break;
	//case emTVOPCourtUpdate:
	//	OnCourtUpdate(sNotifyMsg);
	//	break;
	//case emTVOPCourtDel:
	//	OnCourtDel(sNotifyMsg);
	//	break;
	case emTVOPUnknown:

		break;
	default:

		break;
	}

	MGR_UNLOCK_TRACE;

	if (pUpdateNode)
	{
		TriggerExport(pUpdateNode);
	}
}
CTVNodeBase* CTVDataManager::OnRebuildAll()
{
	if (m_pParentWnd && m_pParentWnd->IsKindOf(RUNTIME_CLASS(CTVDataServerDlg)))
	{
		CTVDataServerDlg* pDlg = (CTVDataServerDlg*)m_pParentWnd;
		pDlg->GetDlgItem(IDC_BTN_REBUILD)->EnableWindow(FALSE);
		
		pDlg->OnBtnRefresh();

		CreateTVData();

		pDlg->GetDlgItem(IDC_BTN_REBUILD)->EnableWindow(TRUE);

		ShowTVDataToTreeCtrl();
	}
	else
		g_Log.OutPutMsg(_T("Ensure rebuild button has been clicked first!"));

	return NULL;
}

CTVNodeBase* CTVDataManager::OnExportAll()
{
	SetTableUpdateMark(&m_TVData);	
	return &m_TVData;
}

CTVNodeBase* CTVDataManager::OnSessionRebuild(STNotifyMsg &sNotifyMsg)
{
	if (!IsValidID(sNotifyMsg.strSessionID))
	{
		g_Log.OutPutMsg(_T("NotifyMsg SessionID is invalid : ") + sNotifyMsg.strSessionID);
		return NULL;
	}

	CTVNodeBase *pSessionNode = FindNode(sNotifyMsg.strSessionID, emTypeSession, &m_TVData);
	if (!pSessionNode || pSessionNode->m_emNodeType != emTypeSession)
		return NULL;

	// Rebuild session Nodes
	InitEvents(pSessionNode);
	InitNodeTables(pSessionNode);

	ShowTVDataToTreeCtrl();

	return NULL;
}

CTVNodeBase* CTVDataManager::OnSessionExport(STNotifyMsg &sNotifyMsg)
{
	if (!IsValidID(sNotifyMsg.strSessionID))
	{
		g_Log.OutPutMsg(_T("NotifyMsg SessionID is invalid : ") + sNotifyMsg.strSessionID);
		return NULL;
	}

	CTVNodeBase *pSessionNode = FindNode(sNotifyMsg.strSessionID, emTypeSession, &m_TVData);
	if (!pSessionNode || pSessionNode->m_emNodeType != emTypeSession)
		return NULL;

	SetTableUpdateMark(pSessionNode);

	return pSessionNode;

}
CTVNodeBase* CTVDataManager::OnSessionDel(STNotifyMsg &sNotifyMsg)
{
	if (!IsValidID(sNotifyMsg.strSessionID))
	{
		g_Log.OutPutMsg(_T("NotifyMsg SessionID is invalid : ") + sNotifyMsg.strSessionID);
		return NULL;
	}

	return OnRebuildAll();
}

CTVNodeBase* CTVDataManager::OnCourtAdd(STNotifyMsg &sNotifyMsg)
{
	if (!m_bShowCourt)
	{
		OnSessionExport(sNotifyMsg);
		return NULL;
	}

	if (!IsValidID(sNotifyMsg.strCourtID))
	{
		g_Log.OutPutMsg(_T("NotifyMsg CourtID is invalid : ") + sNotifyMsg.strCourtID);
		return NULL;
	}

	return OnRebuildAll();

}
CTVNodeBase* CTVDataManager::OnCourtUpdate(STNotifyMsg &sNotifyMsg)
{
	if (!m_bShowCourt)
	{
		OnSessionExport(sNotifyMsg);
		return NULL;
	}

	if (!IsValidID(sNotifyMsg.strCourtID))
	{
		g_Log.OutPutMsg(_T("NotifyMsg CourtID is invalid : ") + sNotifyMsg.strCourtID);
		return NULL;
	}

	CTVNodeBase *pCourtNode = FindNode(sNotifyMsg.strCourtID, emTypeCourt, &m_TVData);
	if (!pCourtNode || pCourtNode->m_emNodeType != emTypeCourt)
		return NULL;

	SetTableUpdateMark(pCourtNode);

	return pCourtNode;
}
CTVNodeBase* CTVDataManager::OnCourtDel(STNotifyMsg &sNotifyMsg)
{
	if (!m_bShowCourt)
	{
		OnSessionExport(sNotifyMsg);
		return NULL;
	}

	if (!IsValidID(sNotifyMsg.strCourtID))
	{
		g_Log.OutPutMsg(_T("NotifyMsg CourtID is invalid : ") + sNotifyMsg.strCourtID);
		return NULL;
	}

	// Trigger Delete
	return OnRebuildAll();
}

CTVNodeBase* CTVDataManager::OnEventAdd(STNotifyMsg &sNotifyMsg)
{
	if (!IsValidID(sNotifyMsg.strMatchID))
	{
		g_Log.OutPutMsg(_T("MatchID is invalid"));
		return NULL; 
	}
	if (!IsValidID(sNotifyMsg.strSessionID))
	{
		g_Log.OutPutMsg(_T("SessionID is invalid"));
		return NULL; 
	}
	
	// Find session node
	CString strNodeIDAddTo = sNotifyMsg.strSessionID;
	CTVNodeBase* pNodeAddTo = FindNode(strNodeIDAddTo, emTypeSession, NULL);

	// If the EventNode has been exist, then abort the adding
	if (pNodeAddTo && FindNode(sNotifyMsg.strMatchID, emTypeEvent, pNodeAddTo))
		return NULL;
	
	if (m_bShowCourt)
	{		
		if (!IsValidID(sNotifyMsg.strCourtID))
		{
			g_Log.OutPutMsg(_T("CourtID is invalid"));
			return NULL;
		}
		
		CTVNodeBase* pNodeSession = pNodeAddTo;

		// Find court node
		strNodeIDAddTo = sNotifyMsg.strCourtID;
		pNodeAddTo = FindNode(strNodeIDAddTo, emTypeCourt, pNodeSession);
		
		// Create a Court Node
		if (!pNodeAddTo) 
		{
			CTVNodeBase* pNodeCourt = new CTVNodeBase;			
			pNodeCourt->m_strID = strNodeIDAddTo;
			pNodeCourt->m_strName = g_DBAccess.GetCourtName(strNodeIDAddTo);
			pNodeCourt->m_emNodeType = emTypeCourt;
			pNodeCourt->m_strPath = pNodeSession->m_strPath.TrimRight(_T("\\")) + _T("\\") + pNodeCourt->m_strName;
			pNodeCourt->m_pParentNode = pNodeSession;
			InitNodeTables(pNodeCourt);
			pNodeSession->AddChildNode(pNodeCourt);

			pNodeAddTo = pNodeCourt;
		}
	}

	if (!pNodeAddTo)
		return NULL;

	// Add One EventNode
	CTVEvent* pEventNode = new CTVEvent;
	pEventNode->m_strID = sNotifyMsg.strMatchID;
	pEventNode->m_strName = g_DBAccess.GetMatchFullName(pEventNode->m_strID);
	pEventNode->m_strStatus = g_DBAccess.GetMatchStatus(pEventNode->m_strID);
	pEventNode->m_emNodeType = emTypeEvent;
	pEventNode->m_strPath = pNodeAddTo->m_strPath.TrimRight(_T("\\")) + _T("\\") + pEventNode->m_strName;
	pEventNode->m_pParentNode = pNodeAddTo;
	InitNodeTables(pEventNode);
	pNodeAddTo->AddChildNode(pEventNode);

	ShowTVDataToTreeCtrl();

	// trigger
	SetTableUpdateMark(pEventNode);

	return pEventNode;

}
CTVNodeBase* CTVDataManager::OnEventExport(STNotifyMsg &sNotifyMsg, CStringArray *pstraTVTables)
{
	if (!IsValidID(sNotifyMsg.strMatchID))
	{
		g_Log.OutPutMsg(_T("MatchID is invalid"));
		return NULL;
	}

	CTVNodeBase *pEventNode = FindDeepMostNode(sNotifyMsg);
	if (!pEventNode || pEventNode->m_emNodeType != emTypeEvent)
		return NULL;

	SetTableUpdateMark(pEventNode, pstraTVTables);

	return pEventNode;
}

CTVNodeBase* CTVDataManager::OnEventDel(STNotifyMsg &sNotifyMsg)
{
	if (!IsValidID(sNotifyMsg.strMatchID))
	{
		g_Log.OutPutMsg(_T("MatchID is invalid"));
		return NULL;
	}

	CTVNodeBase *pEventNode = FindDeepMostNode(sNotifyMsg);
	if (!pEventNode || pEventNode->m_emNodeType != emTypeEvent)
		return NULL;

	CTVNodeBase* pParentNode = pEventNode->m_pParentNode;
	if (!pParentNode)
		return NULL;

	// Delete the Event Node
	pParentNode->DelChildNode(pParentNode->FindChildIndex(pEventNode));

	// Delete the empty court node
	if (m_bShowCourt && pParentNode->m_emNodeType == emTypeCourt)
	{
		CTVNodeBase* pCourtNode = pParentNode;
		if ( pCourtNode->GetChildNodesCount() <= 0)
		{
			CTVNodeBase* pSessionNode = pCourtNode->m_pParentNode;
			if (pSessionNode)
			{
				// Delete the Court Node
				pSessionNode->DelChildNode(pSessionNode->FindChildIndex(pCourtNode));				
			}
		}
	}

	ShowTVDataToTreeCtrl();
 
	return NULL;
}

BOOL CTVDataManager::SetEventStatus(CTVNodeBase* pSessionStsNode)
{
	if (!pSessionStsNode)
		return FALSE;

	// Update Event status
	int nEventCount = pSessionStsNode->GetChildNodesCount();
	for (int i=0; i < nEventCount; i++)
	{
		CTVNodeBase* pChildNode = pSessionStsNode->GetChildNode(i);
		if (pChildNode && pChildNode->m_emNodeType == emTypeEvent)
		{
			((CTVEvent*)pChildNode)->m_strStatus = g_DBAccess.GetMatchStatus(pChildNode->m_strID);
		}
	}

	return TRUE;
}

void CTVDataManager::SetTableUpdateMark(CTVNodeBase* pStartNode, CStringArray *pstraTVTables)
{
	if (!pStartNode)
		pStartNode = &m_TVData;

	int nTableCount = pStartNode->m_ChildTables.GetTableCount();
	for (int i=0; i < nTableCount; i++)
	{
		CTVTable *pTable = pStartNode->m_ChildTables.GetTable(i);
		if (pstraTVTables && pstraTVTables->GetCount() > 0)
		{
			if (StraValueToIndex(*pstraTVTables, pTable->m_strTableName) < 0)
				continue;
		}

		pTable->m_bUpdated = TRUE;
	}	
	
	for (int idx = 0; idx < pStartNode->GetChildNodesCount(); idx++)
	{
		SetTableUpdateMark(pStartNode->GetChildNode(idx), pstraTVTables);
	}

}

void CTVDataManager::TriggerExport(CTVNodeBase* pUpdateNode)
{
	if (!pUpdateNode)
		pUpdateNode = &m_TVData;

	//////////////////////////////////////////////////////////////////////////
	// Notify Export module to update

	CWinThread* pThreadExport = m_ExportMgr.GetExportThread();
	if (pThreadExport)
	{
		pThreadExport->PostThreadMessage(MSG_EXPORT_NOTIFY, (WPARAM)pUpdateNode, NULL);
		m_EventExportIdle.ResetEvent();
	}
}

// if sNotifyMsg's level is lower than emDeepMostLevel, than return the sNotifyMsg's deepest level node
CTVNodeBase* CTVDataManager::FindDeepMostNode(STNotifyMsg &sNotifyMsg, EMTVNodeType emDeepMostLevel)
{
	CTVNodeBase* pFindNode = &m_TVData;

	if ( IsValidID(sNotifyMsg.strSessionID) &&									// check level in STNotifyMsg
		 (emDeepMostLevel==emTypeUnknown || emDeepMostLevel>=emTypeSession) )	// check hoped level
	{
		pFindNode = FindNode(sNotifyMsg.strSessionID, emTypeSession, pFindNode);

		if (m_bShowCourt)
		{
			if ( IsValidID(sNotifyMsg.strCourtID) &&
				 (emDeepMostLevel==emTypeUnknown || emDeepMostLevel >= emTypeCourt) )
			{
				pFindNode = FindNode(sNotifyMsg.strCourtID, emTypeCourt, pFindNode);
			}
		}
	}

	if ( IsValidID(sNotifyMsg.strMatchID) && 
		 (emDeepMostLevel==emTypeUnknown || emDeepMostLevel >= emTypeEvent) )
	{
		pFindNode = FindNode(sNotifyMsg.strMatchID, emTypeEvent, pFindNode);
	}

	return pFindNode;
}

CTVNodeBase* CTVDataManager::FindNode(CString strNodeID, EMTVNodeType emNodeType, CTVNodeBase* pStartParentNode)
{
	if (strNodeID.IsEmpty() || emNodeType == emTypeUnknown)
		return NULL;

	if (pStartParentNode)
	{
		int nChildCount = pStartParentNode->GetChildNodesCount();
		for (int i=0; i < nChildCount; i++)
		{
			CTVNodeBase* pChildNode = pStartParentNode->GetChildNode(i);
			if (emNodeType == pChildNode->m_emNodeType) // Find the expected level
			{
				if (strNodeID == pChildNode->m_strID)
				{
					return pChildNode;
				}
			}
			else // Search the child level
			{
				CTVNodeBase* pFindNode = NULL;
				pFindNode = FindNode(strNodeID, emNodeType, pChildNode);
				if (pFindNode)
					return pFindNode;
			}			
		}
	}
	else
	{
		return FindNode(strNodeID, emNodeType, &m_TVData);
	}

	return NULL;
}
