// NotifySettingDlg.cpp : implementation file
//

#include "stdafx.h"
#include "CRSInfoServer.h"
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

	int nTopicCount = g_TopicManager.GetCount();
	for (int i=0; i < nTopicCount; i++)
	{
		STopicItem *pTopicItem = g_TopicManager.GetTopicItem(i);
		if (!pTopicItem) continue;

		straAllItems.Add(pTopicItem->m_strMsgKey);
		m_straAllItemsNames.Add(pTopicItem->m_strMsgName);
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

int CNotifySettingDlg::StraValueToIndex(CStringArray &straArray, CString strValue)
{
	int nIndex = -1;
	int nCount = straArray.GetCount();
	for (int i=0; i < nCount; i++)
	{
		if (straArray[i] == strValue )
		{
			nIndex = i;
			break;
		}
	}

	return nIndex;
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
	m_gridRemainItems.SetColumnCount(2);
	m_gridRemainItems.SetFixedRowCount();
	m_gridRemainItems.SetEditable(FALSE);
	m_gridRemainItems.SetListMode();
	m_gridRemainItems.SetFixedColumnSelection(FALSE);

	m_gridRemainItems.SetItemText(0, 0, _T("Remain Items"));
	m_gridRemainItems.SetItemText(0, 1, _T("Remain ItemsNames"));

	for (int i=0; i < nCount; i++)
	{
		m_gridRemainItems.SetItemText(i+1, 0, m_straRemainItems[i]);
		m_gridRemainItems.SetItemText(i+1, 1, m_straAllItemsNames[StraValueToIndex(m_straAllItems, m_straRemainItems[i])]);
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
