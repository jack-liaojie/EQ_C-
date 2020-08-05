
// TVDataServerDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "TVDataServer.h"
#include "TVDataServerDlg.h"
#include "TVDataManager.h"
#include "TVTableSettingDlg.h"
#include "LogFunc.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

#define ID_TVFILE_OPEN 3300

CTVDataServerDlg::CTVDataServerDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CTVDataServerDlg::IDD, pParent)
	, m_bShowCourt(FALSE)
	, m_strExportPath(_T("D:\\TVResult\\"))
	, m_TVTableSettingExport(this)
{
	m_bShowCourt = FALSE;
	m_bAdministrator = FALSE;

	m_bResizeNS = FALSE;
	m_bResizeWE = FALSE;
	m_bLeftPartResize = FALSE;

	m_nCmbSelectedDateID = -1;
	m_nCmbSelectedSessionID = -1;
}

void CTVDataServerDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_TREE_TVDATE, m_treeTVData);
	DDX_Check(pDX, IDC_CHK_SHOWCOURT, m_bShowCourt);
	DDX_Text(pDX, IDC_EDIT_EXPORT_PATH, m_strExportPath);
}

BEGIN_MESSAGE_MAP(CTVDataServerDlg, CDialog)

	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_BTN_CONNECT, OnBtnConnect)
	ON_BN_CLICKED(IDC_BTN_DISCONNECT, OnBtnDisconnect)

	ON_BN_CLICKED(IDC_BTN_TABLE_ADD, OnBtnTableAdd)
	ON_BN_CLICKED(IDC_BTN_TABLE_MODIFY, OnBtnTableModify)
	ON_BN_CLICKED(IDC_BTN_TABLE_DEL, OnBtnTableDel)
	ON_BN_CLICKED(IDC_BTN_REFRESH, OnBtnRefresh)
	ON_BN_CLICKED(IDC_BTN_REBUILD, OnBtnRebuild)
	ON_BN_CLICKED(IDC_BTN_EXPORT_NODE, OnBtnExportNode)
	ON_BN_CLICKED(IDC_BTN_DELETE_NODE, OnBtnDeleteNode)

	ON_BN_CLICKED(IDC_BTN_EXPORT_PATHSEL, OnBtnSelExportPath)
	ON_BN_CLICKED(IDC_BTN_UPDATE_SETTING, OnBtnUpdateSetting)

	ON_NOTIFY(NM_DBLCLK, IDC_TREE_TVDATE, OnNMDblclkTreeTvdate)
	ON_NOTIFY(NM_RCLICK, IDC_GRID_TVTABLES, OnTVTableGridRClick)
	ON_NOTIFY(NM_RCLICK, IDC_TREE_TVDATE, OnNMRClickTreeTvdate)

	ON_WM_MOUSEMOVE()
	ON_WM_LBUTTONDOWN()
	ON_WM_LBUTTONUP()
	ON_WM_SIZE()

	ON_CBN_SELCHANGE(IDC_CMB_SESSION, OnSelchangeSession)
	ON_CBN_SELCHANGE(IDC_CMB_DATE, OnSelchangeDate)

	ON_BN_CLICKED(IDC_CHK_SHOWCOURT, OnChkShowcourt)
	
	ON_WM_CLOSE()
	ON_WM_DESTROY()

	// Tray Icon
	SIMPLETRAY_MESSAGEMAP()

	ON_COMMAND(ID_TVFILE_OPEN, OnTVFileOpen)

END_MESSAGE_MAP()

SIMPLETRAY_IMPLEMENT(CTVDataServerDlg);

// CTVDataServerDlg 消息处理程序

BOOL CTVDataServerDlg::OnInitDialog()
{
	CDialog::OnInitDialog();
	SetIcon(LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDR_MAINFRAME)), TRUE);

	CreateTVTableGrid();
	CreateSQLPreviewGrid();

	// Init Log
	g_Log.StartLogService((CEdit *)GetDlgItem(IDC_EDIT_LOG));

	// If the user is not administrator then refuse to modify topic define
	ReadConfig();
	UpdateData(FALSE);
	if (!m_bAdministrator)
	{
		GetDlgItem(IDC_BTN_TABLE_ADD)->EnableWindow(FALSE);
		GetDlgItem(IDC_BTN_TABLE_MODIFY)->EnableWindow(FALSE);
		GetDlgItem(IDC_BTN_TABLE_DEL)->EnableWindow(FALSE);
		GetDlgItem(IDC_CHK_SHOWCOURT)->EnableWindow(FALSE);
	}

	// Maximize the Window
	RECT rcWorkArea;
	SystemParametersInfo(SPI_GETWORKAREA, NULL, (PVOID)&rcWorkArea, 0);
	MoveWindow(CRect(rcWorkArea));
	
	m_TVTableSettingExport.InitExportDBSetting(theApp.GetDataBase(), _T("TI_TVResultTable"), theApp.GetDisciplineCode());
	LoadAndShowTVTables();

	// Initial all data
	OnBtnRebuild();						// Create TVG Data from Database
	//g_TVDataManager.ExportTVData();		// Export all TVG files to local disk

	OnBtnUpdateSetting();

	// Initial the Popup notifier window
	g_WndPopupNotifier.Create(this);
	g_WndPopupNotifier.SetSkin(IDB_BMP_NOTIFY, 255, 0, 255);
	g_WndPopupNotifier.SetTextFont(_T("Arial"), 90, TN_TEXT_BOLD, TN_TEXT_UNDERLINE);
	g_WndPopupNotifier.SetTextColor(RGB(0, 0, 0), RGB(0,0,200));

	return TRUE; 
}

void CTVDataServerDlg::LoadAndShowTVTables()
{
	// Try to import Table settings from file at the 1st time
	static BOOL bTryImport = TRUE;
	if (bTryImport)
	{
		bTryImport = FALSE;
		
		// Get all Tables from database
		SAxTableRecordSet stTableRecords;
		if (!CTVTableDBOperator::GetAllTVTables(stTableRecords, theApp.GetDisciplineCode())) return;

		if (stTableRecords.GetRowRecordsCount() <= 0)
		{			
			OnCommand(MAKEWPARAM(COMMANDID_IMPORT, NULL), NULL);
			return ;
		}
	}

	// Load TV table setting
	g_TVDataManager.LoadAndShowTableTemplates(&m_gridTVTables);
}

BOOL CTVDataServerDlg::CreateTVTableGrid()
{
	if (::IsWindow(m_gridTVTables.GetSafeHwnd()))
		return TRUE;

	CRect rcClient;
	GetDlgItem(IDC_GRID_TVTABLES)->GetWindowRect(rcClient);	
	ScreenToClient(rcClient);
	GetDlgItem(IDC_GRID_TVTABLES)->DestroyWindow();

	if (!m_gridTVTables.Create(rcClient, this, IDC_GRID_TVTABLES))
		return FALSE;
	m_gridTVTables.SetEditable(FALSE);
	m_gridTVTables.SetListMode();
	m_gridTVTables.SetSingleRowSelection();
	m_gridTVTables.SetFixedColumnSelection(FALSE);

	return TRUE;
}
BOOL CTVDataServerDlg::CreateSQLPreviewGrid()
{
	if (::IsWindow(m_gridSQLPreview.GetSafeHwnd()))
		return TRUE;

	CRect rcClient;
	GetDlgItem(IDC_GRID_SQLPREVIEW)->GetWindowRect(rcClient);	
	ScreenToClient(rcClient);
	GetDlgItem(IDC_GRID_SQLPREVIEW)->DestroyWindow();

	if (!m_gridSQLPreview.Create(rcClient, this, IDC_GRID_SQLPREVIEW))
		return FALSE;
	m_gridSQLPreview.SetEditable(FALSE);
	m_gridSQLPreview.SetListMode();

	return TRUE;
}
void CTVDataServerDlg::SetCmboxSelByItemData(CComboBox *pCmbox, int nItemData)
{
	if (!pCmbox)
		return;
	
	// Find the Item with the nItemData 
	int nFindIndex = -1;
	int nItemCount = pCmbox->GetCount();
	for (int i=0; i < nItemCount; i++)
	{
		int nCurItemData = pCmbox->GetItemData(i);
		if (nCurItemData == nItemData)
		{
			nFindIndex = i;
			break;
		}
	}
	
	if (nFindIndex >= 0)
	{
		pCmbox->SetCurSel(nFindIndex);
	}
	else
	{
		pCmbox->SetCurSel(0);
	}

}

void CTVDataServerDlg::OnBtnRefresh()
{
	CComboBox* pCmbDate = (CComboBox*)GetDlgItem(IDC_CMB_DATE);
	CComboBox* pCmbSession = (CComboBox*)GetDlgItem(IDC_CMB_SESSION);
	if (!pCmbDate || !pCmbSession)
	{
		g_Log.OutPutMsg(_T("Can't find Commobox for the session filter!"));
		return;
	}

	pCmbDate->ResetContent();
	pCmbSession->ResetContent();

	CStringArray straDateIDs;
	CStringArray straDateNames;
	if (g_DBAccess.GetAllDisciplineDates(theApp.GetDisciplineCode(), straDateIDs, straDateNames))
	{
		int nDateCount = straDateIDs.GetCount();
		for (int i = 0; i < nDateCount ; i++)
		{
			pCmbDate->AddString(straDateNames[i]);
			pCmbDate->SetItemData(i, _ttoi(straDateIDs[i]));
		}

		if (nDateCount > 0)
		{
			SetCmboxSelByItemData(pCmbDate, m_nCmbSelectedDateID);
			//pCmbDate->SetCurSel(0);

	 		//Send CBN_SELCHANGE
	 		WPARAM wParam = MAKEWPARAM(pCmbDate->GetDlgCtrlID(), CBN_SELCHANGE);     
	 		BOOL bResult = ::SendMessage(pCmbDate->GetParent()->GetSafeHwnd(), WM_COMMAND, wParam, (LPARAM)(pCmbDate->GetSafeHwnd()) );
		}
	}

}
void CTVDataServerDlg::OnSelchangeDate()
{
	CComboBox* pCmbDate = (CComboBox*)GetDlgItem(IDC_CMB_DATE);
	CComboBox* pCmbSession = (CComboBox*)GetDlgItem(IDC_CMB_SESSION);
	if (!pCmbDate || !pCmbSession)
	{
		g_Log.OutPutMsg(_T("Can't find Commobox for the session filter!"));
		return;
	}

	pCmbSession->ResetContent();

	int nCurSel = pCmbDate->GetCurSel();
	if (nCurSel < 0) 
		return;

	m_nCmbSelectedDateID = pCmbDate->GetItemData(nCurSel);
	CString strDateID = AxCommonInt2String(m_nCmbSelectedDateID);

	CStringArray straSessionIDs;
	CStringArray straSessionNames;
	if (g_DBAccess.GetDateSessions(theApp.GetDisciplineCode(), strDateID, straSessionIDs, straSessionNames))
	{
		int nSessionCount = straSessionIDs.GetCount();
		for (int i = 0; i < nSessionCount ; i++)
		{
			pCmbSession->AddString(straSessionNames[i]);
			pCmbSession->SetItemData(i, _ttoi(straSessionIDs[i]));
		}

		if (nSessionCount > 0)
		{
			SetCmboxSelByItemData(pCmbSession, m_nCmbSelectedSessionID);
			//pCmbSession->SetCurSel(0);
		}
	}

}

void CTVDataServerDlg::OnSelchangeSession()
{
	CComboBox* pCmbSession = (CComboBox*)GetDlgItem(IDC_CMB_SESSION);
	if (!pCmbSession)
	{
		g_Log.OutPutMsg(_T("Can't find Commobox for the session filter!"));
		return;
	}

	int nCurSel = pCmbSession->GetCurSel();
	if (nCurSel < 0) 
		return;

	m_nCmbSelectedSessionID = pCmbSession->GetItemData(nCurSel);
}

void CTVDataServerDlg::GetSessionIDsAndNames(OUT CStringArray &straSessionIDs, OUT CStringArray &straSessionNames)
{
	straSessionIDs.RemoveAll();
	straSessionNames.RemoveAll();

	CComboBox* pCmbSession = (CComboBox*)GetDlgItem(IDC_CMB_SESSION);
	if (!pCmbSession)
	{
		g_Log.OutPutMsg(_T("Can't find Commobox for the session filter!"));
		return;
	}

	int nSelSession = pCmbSession->GetCurSel();
	if (nSelSession < 0)
		return;

	if (nSelSession == 0) // invalid ID ==  "ALL"
	{
		int nSessionCount = pCmbSession->GetCount();
		for (int i=1; i < nSessionCount; i++)
		{
			CString strSessionID = AxCommonInt2String(pCmbSession->GetItemData(i));
			CString strSessionName;
			pCmbSession->GetLBText(i, strSessionName);

			straSessionIDs.Add(strSessionID);
			straSessionNames.Add(strSessionName);
		}
	}
	else
	{
		CString strSessionID = AxCommonInt2String(pCmbSession->GetItemData(nSelSession));
		CString strSessionName;
		pCmbSession->GetLBText(nSelSession, strSessionName);

		straSessionIDs.Add(strSessionID);
		straSessionNames.Add(strSessionName);	
	}
}

void CTVDataServerDlg::OnBtnRebuild()
{
	if (g_TVDataManager.m_EventExportIdle.m_hObject && WaitForSingleObject(g_TVDataManager.m_EventExportIdle.m_hObject, 0) == WAIT_TIMEOUT)
	{
		return;
	}	

	UpdateData();

	MGR_LOCK_TRACE;

	if (!g_TVDataManager.SetTVEnvironment(this, &m_treeTVData, theApp.GetDisciplineCode(), m_strExportPath, m_bShowCourt))
	{
		MGR_UNLOCK_TRACE;
		return;
	}

	OnBtnRefresh();

	if (!g_TVDataManager.CreateTVData())
	{
		MGR_UNLOCK_TRACE;
		return;
	}

	g_TVDataManager.ShowTVDataToTreeCtrl();

	g_TVDataManager.OpenExportService();

	MGR_UNLOCK_TRACE;
}

void CTVDataServerDlg::OnBtnExportNode()
{
	HTREEITEM hSelItem = m_treeTVData.GetSelectedItem();
	if (!hSelItem)
		return;
	CTVObject* pTVObj = (CTVObject*) m_treeTVData.GetItemData(hSelItem);

	CTVNodeBase *pSelNode = NULL;
	if (pTVObj->m_emObjType == emObjTypeTVNode)
	{
		pSelNode = (CTVNodeBase*)pTVObj;
	}
	else if (pTVObj->m_emObjType == emObjTypeTVTable)
	{
		pSelNode = ((CTVTable*)pTVObj)->m_pParentNode;
	}

	g_TVDataManager.ExportNodeTablesToFile(pSelNode);
}

void CTVDataServerDlg::OnBtnDeleteNode()
{
	HTREEITEM hSelItem = m_treeTVData.GetSelectedItem();
	if (!hSelItem)
		return;
	CTVObject* pTVObj = (CTVObject*) m_treeTVData.GetItemData(hSelItem);
	if (!pTVObj)
		return;

	CTVNodeBase *pSelNode = NULL;
	if (pTVObj->m_emObjType == emObjTypeTVNode)
	{
		pSelNode = (CTVNodeBase*)pTVObj;

		MGR_LOCK_TRACE;
		g_TVDataManager.DeleteNode(pSelNode);
		MGR_UNLOCK_TRACE;
	}
}

void CTVDataServerDlg::OnBtnTableAdd()
{
	CTVTable tmpTVTable;

	CTVTableSettingDlg dlgTVTableSetting(&tmpTVTable, FALSE);
	if (dlgTVTableSetting.DoModal() == IDOK)
	{
		if(!CTVTableDBOperator::InsertTVTable(&tmpTVTable))
		{
			AfxMessageBox(_T("Insert TVTable To Database ERROR!"));
		}

		g_TVDataManager.LoadAndShowTableTemplates(&m_gridTVTables);

		OnBtnRebuild();
	}
}

void CTVDataServerDlg::OnBtnTableModify()
{
	// Get Selected Table
	CUIntArray naSelRows;
	m_gridTVTables.GetSelectedRows(naSelRows);
	if (naSelRows.GetCount() <= 0) 
		return;

	int nSelTableIdx = naSelRows[0] - 1; // Modify the first selected Topic
	if (nSelTableIdx < 0 || nSelTableIdx >= g_TVDataManager.m_TableTemplates.GetTableCount()) 
		return;

	CTVTable *pTVTable  = g_TVDataManager.m_TableTemplates.GetTable(nSelTableIdx);

	// Modify Selected Table
	CTVTableSettingDlg dlgTVTableSetting(pTVTable, TRUE);
	if (dlgTVTableSetting.DoModal() == IDOK)
	{
		if(!CTVTableDBOperator::UpdateTVTable(pTVTable))
			AfxMessageBox(_T("Update TVTable To Database ERROR!"));

		g_TVDataManager.LoadAndShowTableTemplates(&m_gridTVTables);

		OnBtnRebuild();
	}
}

void CTVDataServerDlg::OnBtnTableDel()
{
	// Get Selected Table
	CUIntArray naSelRows;
	m_gridTVTables.GetSelectedRows(naSelRows);
	if (naSelRows.GetCount() <= 0) 
		return;

	int nSelTableIdx = naSelRows[0] - 1; // Modify the first selected Topic
	if (nSelTableIdx < 0 || nSelTableIdx >= g_TVDataManager.m_TableTemplates.GetTableCount()) 
		return;

	CTVTable *pTVTable  = g_TVDataManager.m_TableTemplates.GetTable(nSelTableIdx);

	// Can not delete the 'session.sts' and 'event.grd'
	if (pTVTable->m_strTableName == STR_EVENTGRD_TABLENAME || pTVTable->m_strTableName == STR_SESSIONSTS_TABLENAME)
	{
		return;
	}

	if (AfxMessageBox(_T("Are you sure to Delete ?"), MB_YESNO) == IDYES)
	{
		// Delete Selected Topic
		if(!CTVTableDBOperator::DeleteTVTable(pTVTable))
			AfxMessageBox(_T("Update TVTable From Database ERROR!"));

		g_TVDataManager.LoadAndShowTableTemplates(&m_gridTVTables);

		OnBtnRebuild();
	}	
}

void CTVDataServerDlg::OnBtnSelExportPath()
{
	UpdateData();

	if (AxCommonFolderDlg(_T("Select Base Export Patch for TVResult :"), m_strExportPath, this, m_strExportPath))
		UpdateData(FALSE);
	else
		UpdateData(TRUE);
}

void CTVDataServerDlg::OnChkShowcourt()
{
	UpdateData();
}

void CTVDataServerDlg::OnBtnUpdateSetting()
{
	if (!m_UpdateSettingDlg.GetSafeHwnd())
	{
		if (!m_UpdateSettingDlg.Create(MAKEINTRESOURCE(IDD_DLG_UPDATE_SETTING), this))
		{
			g_Log.OutPutMsg(_T("UpdateSettingDlg create failure!"));
		}
		//m_pUpdateSettingDlg->ShowWindow(SW_NORMAL);
	}
	else
	{
		m_UpdateSettingDlg.ShowWindow(SW_NORMAL);
	}
}

void CTVDataServerDlg::OnTVFileOpen()
{
	m_TVFileOpenDlg.DoModal();
}

void CTVDataServerDlg::OnNMRClickTreeTvdate(NMHDR *pNMHDR, LRESULT *pResult)
{
	*pResult = 0;

	// Get current mouse position
	CPoint ptClient, ptScr;
	GetCursorPos(&ptScr);
	ptClient = ptScr;
	m_treeTVData.ScreenToClient(&ptClient);

	// Ensure the Item is TVTable item
	HTREEITEM pHitItem = m_treeTVData.HitTest(ptClient);
	CTVObject* pTVObj = (CTVObject*)m_treeTVData.GetItemData(pHitItem);

	if (!m_treeTVData.ItemHasChildren(pHitItem) )
	{
		if (pTVObj && pTVObj->m_emObjType == emObjTypeTVTable)
		{
			CTVTable *pTable = (CTVTable*)pTVObj;

			CMenu menu;
			menu.CreatePopupMenu();
			menu.AppendMenu(MF_STRING, ID_TVFILE_OPEN, _T("Open Exproted File"));
			menu.TrackPopupMenu(TPM_LEFTALIGN|TPM_LEFTBUTTON, ptScr.x, ptScr.y, this);

			m_TVFileOpenDlg.SetTVTable(pTable);
		}
	}
}

void CTVDataServerDlg::OnNMDblclkTreeTvdate(NMHDR *pNMHDR, LRESULT *pResult)
{
	*pResult = 0;

	// Get current mouse position
	CPoint pt;
	GetCursorPos(&pt);
	m_treeTVData.ScreenToClient(&pt);
 			
	m_gridSQLPreview.SetRowCount(0);

	// Ensure the Item is TVTable item
	HTREEITEM pHitItem = m_treeTVData.HitTest(pt);
	CTVObject* pTVObj = (CTVObject*)m_treeTVData.GetItemData(pHitItem);

	if (!m_treeTVData.ItemHasChildren(pHitItem) )
	{
		if (pTVObj && pTVObj->m_emObjType == emObjTypeTVTable)
		{
			CTVTable *pTable = (CTVTable*)pTVObj;

			// Preview Table Recordset
			SAxTableRecordSet sRecordSet;
			pTable->GetSQLResults(sRecordSet);
			AxCommonFillGridCtrl(&m_gridSQLPreview, sRecordSet);
		}
	}	

	if (pTVObj && pTVObj->m_emObjType == emObjTypeTVNode)
	{
		CTVNodeBase* pNode = (CTVNodeBase*) pTVObj;

		g_Log.OutPutMsg(_T("ID: ") + pNode->m_strID +_T(", Name: ") + pNode->m_strName);
	}
}

void CTVDataServerDlg::OnTVTableGridRClick(NMHDR* pNmhdr, LRESULT* pResult)
{
	NM_GRIDVIEW *pGridItem = (NM_GRIDVIEW*) pNmhdr;

	//if (!m_gridTVTables.IsValid(pGridItem->iRow, pGridItem->iColumn))
	//	return;

	CPoint ptMouse;
	GetCursorPos(&ptMouse);
	if (m_bAdministrator)
	{
		m_TVTableSettingExport.ShowPopupMenu(ptMouse);
	}
}

void CTVDataServerDlg::OnDestroy()
{	
	UpdateData();

	WriteConfig();

	g_TVDataManager.CloseExportService();

	CDialog::OnDestroy();
}

void CTVDataServerDlg::ReadConfig()
{
	CString strConfigFile = CAxReadWriteINI::GetAppConfigFile();

	CAxReadWriteINI::IniReadString(_T("NOTIFY_SERVER"), _T("NOTIFY_Server_IP"), m_UpdateSettingDlg.m_strServerIP, strConfigFile);
	CAxReadWriteINI::IniReadString(_T("NOTIFY_SERVER"), _T("NOTIFY_Server_PORT"), m_UpdateSettingDlg.m_strServerPort, strConfigFile);
	CAxReadWriteINI::IniReadString(_T("COMMON_SETUP"), _T("EXPORT_PATH"), m_strExportPath, strConfigFile);

	CString strShowCourt;
	CAxReadWriteINI::IniReadString(_T("COMMON_SETUP"), _T("SHOW_COURT"), strShowCourt, strConfigFile);
	m_bShowCourt = _ttoi(strShowCourt);

	CString strIsAdministrator;
	CAxReadWriteINI::IniReadString(_T("COMMON_SETUP"), _T("USER_Administrator"), strIsAdministrator, strConfigFile);
	m_bAdministrator = _ttoi(strIsAdministrator);
}

void CTVDataServerDlg::WriteConfig()
{
	CString strConfigFile = CAxReadWriteINI::GetAppConfigFile();

	CAxReadWriteINI::IniWriteString(_T("NOTIFY_SERVER"), _T("NOTIFY_Server_IP"), m_UpdateSettingDlg.m_strServerIP, strConfigFile);
	CAxReadWriteINI::IniWriteString(_T("NOTIFY_SERVER"), _T("NOTIFY_Server_PORT"), m_UpdateSettingDlg.m_strServerPort, strConfigFile);
	CAxReadWriteINI::IniWriteString(_T("COMMON_SETUP"), _T("EXPORT_PATH"), m_strExportPath, strConfigFile);
	CAxReadWriteINI::IniWriteString(_T("COMMON_SETUP"), _T("SHOW_COURT"), AxCommonInt2String(m_bShowCourt), strConfigFile);

	CAxReadWriteINI::IniWriteString(_T("COMMON_SETUP"), _T("USER_Administrator"), AxCommonInt2String(FALSE), strConfigFile);	
}


//////////////////////////////////////////////////////////////////////////
// Resize frame between grids
void CTVDataServerDlg::OnMouseMove(UINT nFlags, CPoint point)
{	
	CDialog::OnMouseMove(nFlags, point);

	if (!::IsWindow(m_gridTVTables.GetSafeHwnd()) || !::IsWindow(m_gridSQLPreview.GetSafeHwnd())) return;

	CRect rcTablesGrid, rcSQLResultGrid, rcTreeWnd, rcLogWnd;
	m_gridSQLPreview.GetWindowRect(rcSQLResultGrid);
	m_gridTVTables.GetWindowRect(rcTablesGrid);	
	GetDlgItem(IDC_TREE_TVDATE)->GetWindowRect(rcTreeWnd);
	GetDlgItem(IDC_EDIT_LOG)->GetWindowRect(rcLogWnd);

	ScreenToClient(rcSQLResultGrid);
	ScreenToClient(rcTablesGrid);
	ScreenToClient(rcTreeWnd);
	ScreenToClient(rcLogWnd);

	if (nFlags & MK_LBUTTON )
	{
		if (m_bResizeWE)
		{
			rcSQLResultGrid.left = point.x + MID_FRAME_WIDTH/2;
			rcTablesGrid.left = point.x + MID_FRAME_WIDTH/2;
			rcTreeWnd.right = point.x - MID_FRAME_WIDTH/2;
			rcLogWnd.right = point.x - MID_FRAME_WIDTH/2;

			if (rcTreeWnd.Width() > MIN_WND_WIDTH && rcSQLResultGrid.Width() > MIN_WND_WIDTH) // Limit the resize range
			{
				m_gridSQLPreview.MoveWindow(rcSQLResultGrid);
				m_gridTVTables.MoveWindow(rcTablesGrid);
				GetDlgItem(IDC_TREE_TVDATE)->MoveWindow(rcTreeWnd);
				GetDlgItem(IDC_EDIT_LOG)->MoveWindow(rcLogWnd);
			}
		}
		else if (m_bResizeNS)
		{
			if (!m_bLeftPartResize) // ptClient between TableGrid and SQLResult Window
			{
				rcTablesGrid.bottom = point.y - MID_FRAME_WIDTH/2;
				rcSQLResultGrid.top = point.y + MID_FRAME_WIDTH/2;

				if (rcTablesGrid.Height() > MIN_WND_HEIGHT && rcSQLResultGrid.Height() > MIN_WND_HEIGHT) // Limit the resize range
				{
					m_gridSQLPreview.MoveWindow(rcSQLResultGrid);
					m_gridTVTables.MoveWindow(rcTablesGrid);
				}
			}
			else
			{
				rcTreeWnd.bottom = point.y - MID_FRAME_WIDTH/2;
				rcLogWnd.top = point.y + MID_FRAME_WIDTH/2;

				if (rcTreeWnd.Height() > MIN_WND_HEIGHT && rcLogWnd.Height() > MIN_WND_HEIGHT) // Limit the resize range
				{
					GetDlgItem(IDC_TREE_TVDATE)->MoveWindow(rcTreeWnd);
					GetDlgItem(IDC_EDIT_LOG)->MoveWindow(rcLogWnd);
				}
			}
		}
	}
	else if (point.x > rcTreeWnd.right && point.x <rcTablesGrid.left ) // Pt between TableGrid left and TreeWnd right
	{
		SetCursor(LoadCursor(NULL, IDC_SIZEWE));
	}
	else if (point.x > rcTablesGrid.left && point.y > rcTablesGrid.bottom && point.y < rcSQLResultGrid.top) // ptClient between TableGrid and SQLResult Window
	{
		SetCursor(LoadCursor(NULL, IDC_SIZENS));
	}
	else if (point.x < rcTreeWnd.right && point.y > rcTreeWnd.bottom && point.y < rcLogWnd.top)
	{
		SetCursor(LoadCursor(NULL, IDC_SIZENS));
	}

}

void CTVDataServerDlg::OnLButtonDown(UINT nFlags, CPoint point)
{
	CRect rcTablesGrid, rcSQLResultGrid, rcTreeWnd, rcLogWnd;
	m_gridSQLPreview.GetWindowRect(rcSQLResultGrid);
	m_gridTVTables.GetWindowRect(rcTablesGrid);	
	GetDlgItem(IDC_TREE_TVDATE)->GetWindowRect(rcTreeWnd);
	GetDlgItem(IDC_EDIT_LOG)->GetWindowRect(rcLogWnd);

	ScreenToClient(rcSQLResultGrid);
	ScreenToClient(rcTablesGrid);
	ScreenToClient(rcTreeWnd);
	ScreenToClient(rcLogWnd);

	if (point.x > rcTreeWnd.right && point.x <rcTablesGrid.left ) // Pt between TableGrid left and TreeWnd right
	{
		SetCapture();
		SetCursor(LoadCursor(NULL, IDC_SIZEWE));
		m_bResizeWE = TRUE;
	}
	else if (point.x > rcTablesGrid.left && point.y > rcTablesGrid.bottom && point.y < rcSQLResultGrid.top) // ptClient between TableGrid and SQLResult Window
	{
		SetCapture();
		SetCursor(LoadCursor(NULL, IDC_SIZENS));
		m_bResizeNS = TRUE;
		m_bLeftPartResize = FALSE;
	}
	else if (point.x < rcTreeWnd.right && point.y > rcTreeWnd.bottom && point.y < rcLogWnd.top)
	{
		SetCapture();
		SetCursor(LoadCursor(NULL, IDC_SIZENS));
		m_bResizeNS = TRUE;
		m_bLeftPartResize = TRUE;
	}

	CDialog::OnLButtonDown(nFlags, point);
}

void CTVDataServerDlg::OnLButtonUp(UINT nFlags, CPoint point)
{
	m_bResizeWE = FALSE;
	m_bResizeNS = FALSE;
	ReleaseCapture();

	CDialog::OnLButtonUp(nFlags, point);
}

void CTVDataServerDlg::OnSize(UINT nType, int cx, int cy)
{
	CDialog::OnSize(nType, cx, cy);

	CRect rcDlgClient, rcTablesGrid, rcSQLResultGrid, rcTreeWnd, rcLogWnd;
	GetClientRect(rcDlgClient);
	rcDlgClient.DeflateRect(MID_FRAME_WIDTH, MID_FRAME_WIDTH);

	// Reposition the Tree  Window
	CWnd *pTreeWnd = GetDlgItem(IDC_TREE_TVDATE);
	if (::IsWindow(pTreeWnd->GetSafeHwnd()))
	{
		pTreeWnd->GetWindowRect(&rcTreeWnd);
		ScreenToClient(rcTreeWnd);
		rcTreeWnd.top = rcDlgClient.top + 95;
		//rcTreeWnd.bottom = rcDlgClient.bottom - 150;
		pTreeWnd->MoveWindow(rcTreeWnd);
	}

	CWnd *pLogWnd = GetDlgItem(IDC_EDIT_LOG);
	if (::IsWindow(pLogWnd->GetSafeHwnd()))
	{
		pLogWnd->GetWindowRect(&rcLogWnd);
		ScreenToClient(rcLogWnd);
		rcLogWnd.top = rcTreeWnd.bottom + MID_FRAME_WIDTH;
		rcLogWnd.right = rcTreeWnd.right;
		rcLogWnd.bottom = rcDlgClient.bottom;
		pLogWnd->MoveWindow(rcLogWnd);
	}
	if (::IsWindow(m_gridTVTables.GetSafeHwnd()))
	{
		m_gridTVTables.GetWindowRect(rcTablesGrid);
		ScreenToClient(rcTablesGrid);
		rcTablesGrid.left = rcTreeWnd.right + MID_FRAME_WIDTH;
		rcTablesGrid.top = rcTreeWnd.top;
		rcTablesGrid.right = rcDlgClient.right;
		m_gridTVTables.MoveWindow(rcTablesGrid);
	}

	if (::IsWindow(m_gridSQLPreview.GetSafeHwnd()))
	{
		m_gridSQLPreview.GetWindowRect(rcSQLResultGrid);
		ScreenToClient(rcSQLResultGrid);
		rcSQLResultGrid.top = rcTablesGrid.bottom + MID_FRAME_WIDTH;
		rcSQLResultGrid.left = rcTreeWnd.right + MID_FRAME_WIDTH;
		rcSQLResultGrid.bottom = rcDlgClient.bottom;
		rcSQLResultGrid.right = rcDlgClient.right;
		m_gridSQLPreview.MoveWindow(rcSQLResultGrid);
	}

}

//////////////////////////////////////////////////////////////////////////
// Net environment setting
void CTVDataServerDlg::OnBtnConnect()
{
	if (!m_UpdateSettingDlg.GetSafeHwnd())
		return;

	m_UpdateSettingDlg.OnBtnConnect();

	// Refresh when network reconnection
	OnBtnRebuild();						// Create TVG Data from Database
	g_TVDataManager.ExportTVData();		// Export all TVG files to local disk
}

void CTVDataServerDlg::OnBtnDisconnect()
{
	if (!m_UpdateSettingDlg.GetSafeHwnd())
		return;

	m_UpdateSettingDlg.OnBtnDisconnect();	
}

// Export table settings
BOOL CTVDataServerDlg::OnCommand(WPARAM wParam, LPARAM lParam)
{
	m_TVTableSettingExport.OnCommand(wParam, lParam);

	return CDialog::OnCommand(wParam, lParam);
}

// Disenable to close by ESC, enable click to close 
void CTVDataServerDlg::OnClose()
{
	CDialog::OnCancel();
}
