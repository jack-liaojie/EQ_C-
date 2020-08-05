/********************************************************************
	created:	2009/12/23
	filename: 	TVDataManager.h

	author:		GRL
*********************************************************************/

#pragma once

#include "TVNodeBase.h"
#include "TVDiscipline.h"
#include "TVSession.h"
#include "TVEvent.h"
#include "TVDBAccess.h"
#include "TVExportManager.h"

class CTVDataManager
{
public:
	CTVDataManager();
	~CTVDataManager();

private:

	// TV Environment setting
	BOOL				m_bInitialized;
	BOOL				m_bExportStarted;
	BOOL				m_bShowCourt;
	CString				m_strExportPath;
	CString				m_strDisciplineCode;

	CTreeCtrl*			m_pTreeToShow;
	CImageList			m_iconList;
	CWnd*				m_pParentWnd;

	// Data structure
	CTVDiscipline		m_TVData;
	CTVExportManger		m_ExportMgr;

	BOOL InitDiscipline(CString strDisciplineCode, CString strExportRootPath, BOOL bShowCourt = FALSE);
	BOOL InitSessions(CTVNodeBase* pNodeDiscipline);
	BOOL InitEvents(CTVNodeBase* pNodeSession);
	BOOL InitNodeTables(CTVNodeBase* pNode);
	BOOL IsInitialized();

	CTVNodeBase* OnRebuildAll();	
	CTVNodeBase* OnExportAll();
	CTVNodeBase* OnEventAdd(STNotifyMsg &sNotifyMsg);
	CTVNodeBase* OnEventDel(STNotifyMsg &sNotifyMsg);
	CTVNodeBase* OnSessionRebuild(STNotifyMsg &sNotifyMsg);
	CTVNodeBase* OnSessionExport(STNotifyMsg &sNotifyMsg);

	//-- not used
	CTVNodeBase* OnEventExport(STNotifyMsg &sNotifyMsg, CStringArray *pstraTVTables = NULL);
	CTVNodeBase* OnSessionDel(STNotifyMsg &sNotifyMsg);
	CTVNodeBase* OnCourtAdd(STNotifyMsg &sNotifyMsg);
	CTVNodeBase* OnCourtUpdate(STNotifyMsg &sNotifyMsg);
	CTVNodeBase* OnCourtDel(STNotifyMsg &sNotifyMsg);
	//-- not used 

	BOOL SetEventStatus(CTVNodeBase* pSessionStsNode);
	void SetTableUpdateMark(CTVNodeBase* pStartNode, CStringArray *pstraTVTables = NULL);

	CTVNodeBase* FindDeepMostNode(STNotifyMsg &sNotifyMsg, EMTVNodeType emDeepMostLevel = emTypeUnknown); // emTypeUnknown: Find the deep most node from STNotifyMsg
	CTVNodeBase* FindNode(CString strNodeID, EMTVNodeType emNodeType, CTVNodeBase* pStartParentNode);

	static CString FormatSessionName(CString strDisciplineCode, CString strSessionNum, CString strSessionDay);
	static CString FormatTableFileName(CString strTableName);

	void NodeToTreeCtrl(CTreeCtrl *pTree, CTVNodeBase *pNode);

public:	

	CTVCriticalSection	m_CriticalSection;
	CEvent				m_EventExportIdle;
	CTVTableManager		m_TableTemplates;
	
	// TVResult data manage
	BOOL SetTVEnvironment(CWnd *pParentWnd, CTreeCtrl *pTreeToShow,	CString strDisciplineCode, CString strExportRootPath, BOOL bShowCourt = FALSE);
	BOOL CreateTVData();
	void ExportTVData();
	CTVNodeBase* GetBaseNode(){ return &m_TVData; };
	BOOL IsShowCourt(){ return m_bShowCourt; };
	void DeleteNode(CTVNodeBase* pNode);

	// UI Display
	void ShowTVDataToTreeCtrl();
	//void AddChildNodesToCmb(CComboBox *pCmb, CTVNodeBase *pNode);

	// Table templates
	BOOL LoadAndShowTableTemplates(CAsCoolGridCtrl *pGrid);
	BOOL GetAllTableTemplateNames(OUT CStringArray &straTableNames);

	// TV triggered Operation process
	void ProcessTVTableUpdate(STNotifyMsg &sNotifyMsg, CString &strTableName);
	void ProcessTVOperation(STNotifyMsg &sNotifyMsg, EMTVOperationType emTVOperation, CStringArray *pstraTVTables = NULL);	

	// Export Mgr
	BOOL OpenExportService();
	void CloseExportService();
	void TriggerExport(CTVNodeBase* pUpdateNode);
	BOOL ExportNodeTablesToFile(CTVNodeBase* pNode);
};

extern CTVDataManager	g_TVDataManager;
