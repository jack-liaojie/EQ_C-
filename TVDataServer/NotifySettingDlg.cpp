// NotifySettingDlg.cpp : implementation file
//

#include "stdafx.h"
#include "TVDataServer.h"
#include "NotifySettingDlg.h"

#define IDC_GRID_SELECTED_TABLES		1500
#define IDC_GRID_REMAIN_TABLES			1600


// CNotifySettingDlg dialog
IMPLEMENT_DYNAMIC(CNotifySettingDlg, CDialog)

CNotifySettingDlg::CNotifySettingDlg(CString strNotifyType, CString strMapStrings, BOOL bModify)
	: CDialog(CNotifySettingDlg::IDD)
{
	m_strNotifyType = strNotifyType;
	m_strMapString = strMapStrings;
	m_bModify = bModify;
}

CNotifySettingDlg::~CNotifySettingDlg()
{
}

void CNotifySettingDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_EDIT_NOTIFY_NAME, m_strNotifyType);
}

BEGIN_MESSAGE_MAP(CNotifySettingDlg, CDialog)
END_MESSAGE_MAP()

// CNotifySettingDlg message handlers

BOOL CNotifySettingDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	GetAllItems(m_straAllItems);

	// Get remain and selected topics
	ParseMapString(m_strMapString, m_straSelectedItems, m_straRemainItems);

	FillSelectedTableGrid();
	FillRemainTablesGrid();

	UpdateData(FALSE);

	return TRUE;
}

void CNotifySettingDlg::GetAllItems(CStringArray &straAllItems)
{	
	straAllItems.RemoveAll();

	CStringArray straAllOperations;
	CStringArray straAllTables;
	GetAllTVOperations(straAllOperations);
	g_TVDataManager.GetAllTableTemplateNames(straAllTables);

	int nFindEventGrdIdx = -1;
	int nTableCount = straAllTables.GetCount();
	for (int i=0; i < nTableCount; i++)
	{
		CString strTableName = straAllTables[i];
		if (strTableName.CompareNoCase(STR_EVENTGRD_TABLENAME) == 0)
			nFindEventGrdIdx = i;

		straAllTables[i] = _T("UPTABLE_") + strTableName;
	}
	if (nFindEventGrdIdx >= 0) // Ignore the event.grd
		straAllTables.RemoveAt(nFindEventGrdIdx);

	straAllItems.Copy(straAllTables);
	straAllItems.Append(straAllOperations);
}

void CNotifySettingDlg::GetAllTVOperations(CStringArray &straAllTVOperations)
{
	straAllTVOperations.RemoveAll();

	for (EMTVOperationType emOpType = emTVOPRebuildAll; emOpType <= emTVOPDelEvent; emOpType = (EMTVOperationType)(emOpType+1))
	{
		straAllTVOperations.Add(OperationType2String(emOpType));
	}
}

void CNotifySettingDlg::ParseMapString(CString strMapString, OUT CStringArray &straSelectedItems,	OUT CStringArray &straRemainItems)
{
	straSelectedItems.RemoveAll();
	straRemainItems.RemoveAll();

	if (strMapString.IsEmpty())
	{		
		straRemainItems.Copy(m_straAllItems);
		return;
	}

	// Get selected Items
	SplitStringToStra(strMapString, straSelectedItems);

	// Get remain Items
	int nAllItemsCount = m_straAllItems.GetCount();
	for (int i=0; i < nAllItemsCount; i++)
	{
		if (StraValueToIndex(straSelectedItems, m_straAllItems[i]) < 0)
		{
			straRemainItems.Add(m_straAllItems[i]);
		}
	}
}

void CNotifySettingDlg::FillRemainTablesGrid()
{
	if (!::IsWindow(m_gridRemainItems.GetSafeHwnd()))
	{
		CRect rcGrid;
		GetClientRect(rcGrid);
		rcGrid.right -= 6;
		rcGrid.top += 43;
		rcGrid.bottom -= 40;
		rcGrid.left = rcGrid.Width()/3 + 4;

		if (!m_gridRemainItems.Create(rcGrid, this, IDC_GRID_REMAIN_TABLES))
			return;
	}

	int nCount = m_straRemainItems.GetCount();
	m_gridRemainItems.SetRowCount(nCount+1);
	m_gridRemainItems.SetColumnCount(1);
	m_gridRemainItems.SetFixedRowCount();
	m_gridRemainItems.SetEditable(FALSE);
	m_gridRemainItems.SetListMode();
	m_gridRemainItems.SetFixedColumnSelection(FALSE);

	m_gridRemainItems.SetItemText(0, 0, _T("Remain Items"));

	for (int i=0; i < nCount; i++)
	{
		m_gridRemainItems.SetItemText(i+1, 0, m_straRemainItems[i]);
	}

	m_gridRemainItems.AutoSizeColumns();
	m_gridRemainItems.ExpandLastColumn();
	m_gridRemainItems.Refresh();

}
void CNotifySettingDlg::FillSelectedTableGrid()
{
	if (!::IsWindow(m_gridSelectedItems.GetSafeHwnd()))
	{
		CRect rcGrid;
		GetClientRect(rcGrid);
		rcGrid.left += 6;
		rcGrid.top += 43;
		rcGrid.bottom -= 40;
		rcGrid.right = rcGrid.Width()/3 - 4;

		if (!m_gridSelectedItems.Create(rcGrid, this, IDC_GRID_SELECTED_TABLES))
			return;
	}

	int nCount = m_straSelectedItems.GetCount();
	m_gridSelectedItems.SetRowCount(nCount+1);
	m_gridSelectedItems.SetColumnCount(1);
	m_gridSelectedItems.SetFixedRowCount();
	m_gridSelectedItems.SetEditable(FALSE);
	m_gridSelectedItems.SetListMode();
	m_gridSelectedItems.SetFixedColumnSelection(FALSE);

	m_gridSelectedItems.SetItemText(0, 0, _T("Selected Items"));

	for (int i=0; i < nCount; i++)
	{
		m_gridSelectedItems.SetItemText(i+1, 0, m_straSelectedItems[i]);
	}

	m_gridSelectedItems.AutoSizeColumns();
	m_gridSelectedItems.ExpandColumnsToFit();
	m_gridSelectedItems.Refresh();

}



void CNotifySettingDlg::SplitStringToStra(CString strMapString, CStringArray &straMapItems)
{
	if (strMapString.IsEmpty())
		return;

	straMapItems.RemoveAll();

	// Get selected Items
	CAxSplitString split;
	split.SetData(strMapString);
	split.SetSplitFlag(_T(","));
	split.GetSplitStrArray(straMapItems);
}
void CNotifySettingDlg::GetTVOperationAndTables(CStringArray &straMapItems, CStringArray &straTVOperations, CStringArray &straTVTables)
{
	straTVOperations.RemoveAll();
	straTVTables.RemoveAll();

	// Get remain Items
	int nAllItemsCount = straMapItems.GetCount();
	for (int i=0; i < nAllItemsCount; i++)
	{
		if (straMapItems[i].Left(3) == _T("OP_"))
			straTVOperations.Add(straMapItems[i]);
		else
			straTVTables.Add(straMapItems[i]);
	}
}

CString CNotifySettingDlg::GetAssembledStr(CStringArray &straArray, CString strSplitMark, BOOL bWithEnd)
{
	CString strValues;

	CString strOperations;
	CString strTables;

	int nCount = straArray.GetCount();
	for (int i=0; i < nCount; i++)
	{
		if (straArray[i].Left(3) == _T("OP_"))
			strOperations += straArray[i] + strSplitMark;
		else 
			strTables += straArray[i] + strSplitMark;
	}

	strValues = strOperations + strTables;

	if (!bWithEnd)
	{
		strValues = strValues.Left(strValues.GetLength() - strSplitMark.GetLength());
	}

	return strValues;
}

BOOL CNotifySettingDlg::OnNotify(WPARAM wParam, LPARAM lParam, LRESULT* pResult)
{
	if (wParam == IDC_GRID_SELECTED_TABLES)
	{
		NM_GRIDVIEW *pNMGrid = (NM_GRIDVIEW*)lParam;
		if (pNMGrid->hdr.code == NM_DBLCLK)
		{
			int nRow = pNMGrid->iRow - 1;
			int nCol = pNMGrid->iColumn;

			if (nCol >= 0 && nRow >= 0)
			{
				CString strSelTopicID = m_straSelectedItems[nRow];
				int nTopicIDIndex = StraValueToIndex(m_straAllItems, strSelTopicID);
				if (nTopicIDIndex < 0) return FALSE;

				m_straRemainItems.Add(strSelTopicID);

				m_straSelectedItems.RemoveAt(nRow);

				FillRemainTablesGrid();
				FillSelectedTableGrid();
			}
		}
	}
	else if (wParam == IDC_GRID_REMAIN_TABLES)
	{
		NM_GRIDVIEW *pNMGrid = (NM_GRIDVIEW*)lParam;
		if (pNMGrid->hdr.code == NM_DBLCLK)
		{
			int nRow = pNMGrid->iRow - 1;
			int nCol = pNMGrid->iColumn;

			if (nCol >= 0 && nRow >= 0)
			{
				m_straSelectedItems.Add(m_straRemainItems[nRow]);
				m_straRemainItems.RemoveAt(nRow);

				FillRemainTablesGrid();
				FillSelectedTableGrid();
			}
		}
	}

	return CDialog::OnNotify(wParam, lParam, pResult);
}

void CNotifySettingDlg::OnOK()
{
	UpdateData();
	m_strMapString = GetAssembledStr(m_straSelectedItems, _T(","), FALSE);

	CDialog::OnOK();
}

//////////////////////////////////////////////////////////////////////////
// enum Type exchange to string tools
CString OperationType2String(EMTVOperationType eType)
{
	CString strType;

	switch (eType)
	{
	case emTVOPRebuildAll:
		strType = STR_TVOPERATION_REBUILD_ALL;
		break;
	case emTVOPExportAll:
		strType = STR_TVOPERATION_EXPORT_ALL;
		break;
	case emTVOPRebuildSession:
		strType = STR_TVOPERATION_REBUILD_SESSION;
		break;
	case emTVOPExportSession:
		strType = STR_TVOPERATION_EXPORT_SESSION;
		break;
	case emTVOPAddEvent:
		strType = STR_TVOPERATION_EVENT_ADD;
		break;
	case emTVOPDelEvent:
		strType = STR_TVOPERATION_EVENT_DEL;
		break;
	//case emTVOPSessionDel:
	//	strType = STR_TVOPERATION_SESSION_DEL;
	//	break;
	//case emTVOPCourtAdd:
	//	strType = STR_TVOPERATION_COURT_ADD;
	//	break;
	//case emTVOPCourtUpdate:
	//	strType = STR_TVOPERATION_COURT_UPDATE;
	//	break;
	//case emTVOPCourtDel:
	//	strType = STR_TVOPERATION_COURT_DEL;
	//	break;
	case emTVOPUnknown:
		strType = STR_TYPE_UNKNOWN;
		break;
	default:
		strType = STR_TYPE_UNKNOWN;
	}

	return strType;
}

EMTVOperationType Str2OperationType(CString strType)
{
	EMTVOperationType eType;
	
	if (strType == STR_TVOPERATION_REBUILD_ALL)				eType = emTVOPRebuildAll;
	else if (strType == STR_TVOPERATION_EXPORT_ALL)			eType = emTVOPExportAll;
	else if (strType == STR_TVOPERATION_REBUILD_SESSION)	eType = emTVOPRebuildSession;
	else if (strType == STR_TVOPERATION_EXPORT_SESSION)		eType = emTVOPExportSession;
	else if (strType == STR_TVOPERATION_EVENT_ADD)			eType = emTVOPAddEvent;
	else if (strType == STR_TVOPERATION_EVENT_DEL)			eType = emTVOPDelEvent;

	//else if (strType == STR_TVOPERATION_COURT_ADD)			eType = emTVOPCourtAdd;
	//else if (strType == STR_TVOPERATION_COURT_UPDATE)		eType = emTVOPCourtUpdate;
	//else if (strType == STR_TVOPERATION_COURT_DEL)			eType = emTVOPCourtDel;
	else eType = emTVOPUnknown;

	return eType;
}
