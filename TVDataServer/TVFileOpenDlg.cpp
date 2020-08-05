// TVFileOpenDlg.cpp : implementation file
//

#include "stdafx.h"
#include "TVDataServer.h"
#include "TVFileOpenDlg.h"

#define	IDC_Grid_TVFile		2001

#define ROW_SPLIT_TOKEN		STR_EXPORT_CSVROWTOKEN
#define COL_SPLIT_TOKEN		STR_EXPORT_CSVSPLITTOKEN
#define STRING_DEF_TOKEN	STR_EXPORT_CSVSTRINGTOKEN


// CTVFileOpenDlg dialog

IMPLEMENT_DYNAMIC(CTVFileOpenDlg, CDialog)

CTVFileOpenDlg::CTVFileOpenDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CTVFileOpenDlg::IDD, pParent)
{
	m_pTVTable = NULL;
}

CTVFileOpenDlg::~CTVFileOpenDlg()
{
}

void CTVFileOpenDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CTVFileOpenDlg, CDialog)
	ON_WM_DESTROY()
	ON_WM_SIZE()
END_MESSAGE_MAP()


// CTVFileOpenDlg message handlers

BOOL CTVFileOpenDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	if (!m_pTVTable)
	{
		AfxMessageBox(_T("No valid TV table selected!"));
		PostMessage(WM_CLOSE);
		return FALSE;
	}

	SetWindowText(m_pTVTable->m_strTableFileName);

	CreateTVFileGrid();

	ReloadTVFile();

	return TRUE;
}

void CTVFileOpenDlg::OnDestroy()
{
	CDialog::OnDestroy();

	m_pTVTable = NULL;
	m_DBRecordSet.RemoveAll();
	m_TVTableRecordSet.RemoveAll();
}

void CTVFileOpenDlg::OnSize(UINT nType, int cx, int cy)
{
	CDialog::OnSize(nType, cx, cy);
	
	if (::IsWindowEnabled(m_TVFileGrid.GetSafeHwnd()))
	{
		CRect rctClient;
		GetClientRect(rctClient);

		m_TVFileGrid.MoveWindow(rctClient);
		m_TVFileGrid.Refresh();
	}
}

BOOL CTVFileOpenDlg::PreTranslateMessage(MSG* pMsg)
{
	if (pMsg->message == WM_KEYDOWN && pMsg->wParam == VK_F5)
	{
		ReloadTVFile();
	}

	return CDialog::PreTranslateMessage(pMsg);
}

void CTVFileOpenDlg::SetTVTable( CTVTable *pTVTable )
{
	m_pTVTable = pTVTable;
}

void CTVFileOpenDlg::CreateTVFileGrid()
{
	CRect rctClient;
	GetClientRect(rctClient);

	if (!m_TVFileGrid.Create(rctClient, this, IDC_Grid_TVFile))
	{
		AfxMessageBox(_T("Create datagrid error!"));
		return;
	}

	m_TVFileGrid.SetEditable(FALSE);
}

void CTVFileOpenDlg::ReloadTVFile()
{
	//// Preview Table Recordset
	m_pTVTable->GetSQLResults(m_DBRecordSet);

	CString strTVTable = OpenFileToStr(m_pTVTable->m_strTableFileName);
	ParseFileToTable(strTVTable, m_TVTableRecordSet);

	FillTVTableGridCtrl(&m_TVFileGrid, m_TVTableRecordSet);
}

BOOL CTVFileOpenDlg::FillTVTableGridCtrl(CAsCoolGridCtrl* pGridCtrl, SAxTableRecordSet& rsTable, BOOL bColorRow/* = TRUE*/, COLORREF clrOddRow, COLORREF clrEvenRow, LOGFONT* lgHeaderFont/* = NULL*/, LOGFONT* lgCellTextFont/* = NULL*/)
{
	LOGFONT lf;
	GetObject(GetStockObject(SYSTEM_FONT), sizeof(LOGFONT), &lf);

	pGridCtrl->SetRowCount(0);
	pGridCtrl->SetColumnCount(rsTable.GetFieldsCount());
	pGridCtrl->SetRowCount(rsTable.GetRowRecordsCount() + 1);
	pGridCtrl->SetFixedRowCount();

	// Check Field and Row count difference from database
	BOOL bDiffCol = FALSE;
	BOOL bDiffRow = FALSE;
	if (rsTable.GetFieldsCount() != m_DBRecordSet.GetFieldsCount())
	{
		if (m_pTVTable->m_strTableName != _T("session.sts") && m_pTVTable->m_strTableName != _T("event.grd"))
		{
			AfxMessageBox(_T("The field count is different from Database!"));
			bDiffCol = TRUE;
		}
	}
	if (rsTable.GetRowRecordsCount() != m_DBRecordSet.GetRowRecordsCount())
	{
		if (m_pTVTable->m_strTableName != _T("session.sts") && m_pTVTable->m_strTableName != _T("event.grd"))
		{
			AfxMessageBox(_T("The row count is different from Database!"));
			bDiffRow = TRUE;
		}
	}

	// Fill Header column
	for( int iFieldIdx = 0; iFieldIdx < rsTable.GetFieldsCount(); iFieldIdx++ )
	{
		pGridCtrl->SetItemText(0, iFieldIdx, rsTable.GetFieldName(iFieldIdx));
		pGridCtrl->SetRowHeight(0, 23);
		if( lgHeaderFont )
		{
			pGridCtrl->SetItemFont(0, iFieldIdx, lgHeaderFont);
		}
		else
		{
			pGridCtrl->SetItemFont(0, iFieldIdx, &lf);
		}

		// Mark different FieldName
		if (!bDiffCol)
		{
			if (rsTable.GetFieldName(iFieldIdx) != m_DBRecordSet.GetFieldName(iFieldIdx))
			{
				pGridCtrl->SetItemBkColour(0, iFieldIdx, RGB(200, 100, 0));
			}
		}
	}

	// Fill Rows 
	for( int iRowIdx = 0; iRowIdx < rsTable.GetRowRecordsCount(); iRowIdx++ )
	{
		if( bColorRow)
		{
			if( iRowIdx % 2  == 1)
				pGridCtrl->SetRowBkColor(iRowIdx + 1, clrEvenRow);	
			else
				pGridCtrl->SetRowBkColor(iRowIdx + 1, clrOddRow);	
		}

		for( int iFieldIdx = 0; iFieldIdx < rsTable.GetFieldsCount(); iFieldIdx++ )
		{
			CString strValue = rsTable.GetValue(iFieldIdx, iRowIdx);
			pGridCtrl->SetItemText(iRowIdx + 1, iFieldIdx, strValue);
			if( lgCellTextFont)		
			{
				pGridCtrl->SetItemFont(iRowIdx + 1, iFieldIdx, lgCellTextFont);
			}

			// Mark different FieldVale
			if (!bDiffRow)
			{
				if (strValue != m_DBRecordSet.GetValue(iFieldIdx, iRowIdx))
				{
					pGridCtrl->SetItemBkColour(iRowIdx + 1, iFieldIdx, RGB(200, 100, 0));
				}
			}
		}
	}

	pGridCtrl->AutoSizeColumns();
	pGridCtrl->ExpandLastColumn();
	pGridCtrl->Refresh();

	return TRUE;
}

//////////////////////////////////////////////////////////////////////////
// Utilize
CString CTVFileOpenDlg::OpenFileToStr(CString strFullFileName)
{
	if (!AxCommonDoesFileExist(strFullFileName))
	{
		AfxMessageBox(_T("File: \" ") + strFullFileName + _T(" \" not exist!"));
		return _T("");
	}

	// Open File
	CFile file;
	BOOL bCanbeRead = FALSE;
	int nReadCount = 0;
	while( nReadCount < 3 ) // Try 3 times
	{
		if (file.Open(strFullFileName, CFile::modeRead))
		{
			bCanbeRead = TRUE;
			break;
		}
		Sleep(10);
		nReadCount++;
	}

	if (!bCanbeRead) 
		return _T("");

	// Read File
	CString strText; // File content

	int nFileLen = file.GetLength();
	LPBYTE lpText = new BYTE[nFileLen + 2];
	memset(lpText, 0, nFileLen + 2);
	int nReadLen = file.Read(lpText, nFileLen);

	strText = DecodeTextToCString(lpText, nReadLen);

	delete []lpText;
	file.Close();

	return strText;
}

BOOL CTVFileOpenDlg::ParseFileToTable(CString strText, SAxTableRecordSet &sRecordSet)
{
	if (strText.IsEmpty()) return FALSE;

	sRecordSet.RemoveAll();

	// First Line is the FieldName
	int nFieldCount = 0; // Count the Field num
	int posRow = strText.Find(ROW_SPLIT_TOKEN);
	if (posRow > 0)
	{
		CString strFieldLine = strText.Left(posRow);
		int posCol = strFieldLine.Find(COL_SPLIT_TOKEN);
		while (posCol >= 0)
		{
			CString strFieldName = strFieldLine.Left(posCol);
			strFieldName.Trim();
			strFieldName.Trim(STRING_DEF_TOKEN);

			sRecordSet.m_aryFieldsName.Add(strFieldName); // Add Field Name
			nFieldCount++;

			strFieldLine = strFieldLine.Right(strFieldLine.GetLength() - posCol -1);
			posCol = strFieldLine.Find(COL_SPLIT_TOKEN);
		}

		// Process the Last Col
		if (posCol < 0 && !strFieldLine.IsEmpty())
		{
			strFieldLine.Trim();
			strFieldLine.Trim(STRING_DEF_TOKEN);

			sRecordSet.m_aryFieldsName.Add(strFieldLine);
			nFieldCount++;
		}
	}
	else 
		return FALSE;

	// Parse Record
	while (posRow >= 0)
	{
		strText = strText.Right(strText.GetLength() - posRow -1);
		posRow = strText.Find(ROW_SPLIT_TOKEN);

		CString strRecordLine;
		BOOL bValidLine = TRUE;
		if (posRow > 0)
		{
			strRecordLine= strText.Left(posRow);
		}
		else if (!strText.IsEmpty())
		{
			strRecordLine = strText;
		}
		else
		{
			bValidLine = FALSE;
		}

		if ( bValidLine )
		{
			SAxRowRecord sOneRecord; // Create one Record

			int posCol = strRecordLine.Find(COL_SPLIT_TOKEN);

			for (int i=0; i < nFieldCount; i++)
			{
				if (posCol >= 0)
				{
					CString strFieldValue = strRecordLine.Left(posCol);
					strFieldValue.Trim();
					strFieldValue.Trim(STRING_DEF_TOKEN);

					sOneRecord.m_aryRowColValue.Add(strFieldValue); // Add Field Value

					strRecordLine = strRecordLine.Right(strRecordLine.GetLength() - posCol -1);
					posCol = strRecordLine.Find(COL_SPLIT_TOKEN);
				}
				else // Ensure the each record has the correct col count
				{
					strRecordLine.Trim();
					strRecordLine.Trim(STRING_DEF_TOKEN);
					sOneRecord.m_aryRowColValue.Add(strRecordLine.IsEmpty() ? NULL : strRecordLine); // Add Field Value
					strRecordLine = _T("");
				}
			}

			sRecordSet.m_aryRowRecords.Add(sOneRecord);
		}
	}

	return TRUE;
}

CString CTVFileOpenDlg::DecodeTextToCString(LPBYTE lpByte, int nLen)
{
	CString strResult;

	if ( *((LPWORD)lpByte) == 0xFEFF) // Unicode
	{
		strResult = LPCWSTR(lpByte);
	}
	else if ( *((LPWORD)lpByte) == 0xFFFE) // BigEndian Unicode
	{
		LPBYTE lpPos = lpByte;
		while( lpPos < lpByte + nLen)
		{
			BYTE tmpByte = *lpPos;
			*lpPos = *(lpPos+1);
			*(lpPos+1) = tmpByte;
			lpPos += 2;
		}
		strResult = LPCWSTR(lpByte);
	}
	else if (IsUTF8(lpByte, nLen)) // UTF-8 
	{
		int iLen = MultiByteToWideChar(CP_UTF8, 0, LPCSTR(lpByte), -1, NULL, 0);
		MultiByteToWideChar(CP_UTF8, 0, LPCSTR(lpByte), -1, LPWSTR(strResult.GetBuffer(iLen)), iLen);
		strResult.ReleaseBuffer();
	}
	else
	{
		strResult = LPCSTR(lpByte);
	}

	return strResult;
}

BOOL CTVFileOpenDlg::IsUTF8(LPVOID lpBuffer, long size)
{
	bool IsUTF8 = true;
	unsigned char* start = (unsigned char*)lpBuffer;
	unsigned char* end = (unsigned char*)lpBuffer + size;
	while (start < end)
	{
		if (*start < 0x80) // (10000000): 值小于0x80的为ASCII字符
		{
			start++;
		}
		else if (*start < (0xC0)) // (11000000): 值介于0x80与0xC0之间的为无效UTF-8字符
		{
			IsUTF8 = false;
			break;
		}
		else if (*start < (0xE0)) // (11100000): 此范围内为2字节UTF-8字符
		{
			if (start >= end - 1) 
				break;
			if ((start[1] & (0xC0)) != 0x80)
			{
				IsUTF8 = false;
				break;
			}
			start += 2;
		} 
		else if (*start < (0xF0)) // (11110000): 此范围内为3字节UTF-8字符
		{
			if (start >= end - 2) 
				break;
			if ((start[1] & (0xC0)) != 0x80 || (start[2] & (0xC0)) != 0x80)
			{
				IsUTF8 = false;
				break;
			}
			start += 3;
		} 
		else
		{
			IsUTF8 = false;
			break;
		}
	}
	return IsUTF8;
}

