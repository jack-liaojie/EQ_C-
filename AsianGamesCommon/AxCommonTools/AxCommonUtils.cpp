
#include "stdafx.h"

#include "AxCommonUtils.h"

BOOL AxCommonGetModulePath(CString& strModulePath, LPCTSTR lpModuleName)
{
	strModulePath = _T("");

	TCHAR szPathName[_MAX_PATH], szDrv[_MAX_DRIVE], szDir[_MAX_DIR];
	GetModuleFileName(GetModuleHandle(lpModuleName), szPathName, _MAX_PATH);
	_tsplitpath(szPathName, szDrv, szDir, NULL, NULL);

	strModulePath = CString(szDrv) + szDir;
	return TRUE;
}

BOOL AxCommonSetCtrlFont(CWnd* pCtrl, CFont* pFont)
{
	if( pCtrl == NULL)
		return FALSE;

	if( pFont)
	{
		pCtrl->SetFont(pFont);
	}
	else
	{
		CFont ftCommonFont;
		LOGFONT lf;
		GetObject(GetStockObject(SYSTEM_FONT), sizeof(LOGFONT), &lf);
		ftCommonFont.CreateFontIndirect(&lf);
		pCtrl->SetFont(&ftCommonFont);
	}

	return TRUE;
}

LPWSTR AxCommonAnsiToUnicode( LPSTR lpszSrc )
{
	LPWSTR lpReturn = NULL;
	int iWLen = MultiByteToWideChar(CP_ACP,0,lpszSrc,-1,NULL,0);
	lpReturn = new WCHAR[iWLen];
	MultiByteToWideChar(CP_ACP,0,lpszSrc,strlen(lpszSrc),lpReturn,iWLen);
	lpReturn[iWLen-1] = L'\0';
	return lpReturn;
}

LPSTR AxCommonUnicodeToAnsi( LPWSTR lpszSrc )
{
	LPSTR lpReturn = NULL;
	int iLen = WideCharToMultiByte(CP_ACP,0,lpszSrc,-1,NULL,0,NULL,NULL);
	lpReturn = new char[iLen];
	WideCharToMultiByte(CP_ACP,0,lpszSrc,wcslen(lpszSrc),lpReturn,iLen,NULL,NULL);
	lpReturn[iLen-1] = '\0';
	return lpReturn;
}

int CALLBACK BrowseCallbackProc(HWND hwnd, UINT uMsg, LPARAM lParam, LPARAM lpData)   
{   
	CStringW strPreSelPath(*(CString*)lpData); // 预设的选中目录

	switch(uMsg)
	{
	case BFFM_INITIALIZED:
		if (!strPreSelPath.IsEmpty())
		{
			::SendMessage(hwnd,BFFM_SETSELECTION,TRUE,(LPARAM)strPreSelPath.GetBuffer(0));
		}
		break;
	case BFFM_SELCHANGED:   
		{ 
		}   
		break;
	}   
	return   0;   
} 

BOOL AxCommonFolderDlg(LPCTSTR lpszDesc, CString& strFolder, CWnd* pWnd, CString strPreSelPath)
{
	strFolder = _T("");

	CString str;
	if (lpszDesc == NULL)
		str = _T("");
	else
		str = CString(lpszDesc);

	TCHAR pszBuffer[_MAX_PATH];
	BROWSEINFO bi;
	LPITEMIDLIST pidl;
	if (pWnd != NULL)
		bi.hwndOwner = pWnd->GetSafeHwnd();
	else
		bi.hwndOwner = NULL;

	bi.pidlRoot = NULL;
	bi.pszDisplayName = pszBuffer;
	bi.lpszTitle = (LPCTSTR)str;
	bi.ulFlags = BIF_RETURNFSANCESTORS | BIF_RETURNONLYFSDIRS|BIF_USENEWUI;
	bi.lpfn = BrowseCallbackProc;
	bi.lParam = (LPARAM)&strPreSelPath;
	if ((pidl = SHBrowseForFolder(&bi)) != NULL)
	{
		if (SHGetPathFromIDList(pidl, pszBuffer))
		{
			strFolder.Format(pszBuffer);
			return TRUE;
		}
	}

	return FALSE;
}

BOOL AxCommonDoesFileExist(LPCTSTR lpFile)
{
	CFileStatus rStatus;
	if (!CFile::GetStatus(lpFile, rStatus))
		return FALSE;
	if (rStatus.m_attribute & CFile::directory)
		return FALSE;

	return TRUE;
}

BOOL AxCommonDoesDirExist(LPCTSTR lpDir)
{
	CString strDir = lpDir;
	strDir.MakeUpper();

	// take off the '\\' possibly at the end, CFile::GetStatus() does not accept this.
	while (strDir.Right(1)==_T("\\"))
	{
		int len = strDir.GetLength();
		strDir = strDir.Left(len-1);
	}

	// CFile::GetStatus() can not process root dir, we process here
	if (strDir.Right(1)==_T(":"))
	{
		TCHAR chDisk = strDir[0];
		TCHAR szBuf[101];
		DWORD dwLen = GetLogicalDriveStrings(100, szBuf);
		ASSERT((dwLen%4)==0);
		for (DWORD i=0; i<dwLen; i+=4)
		{
			if (szBuf[i] == chDisk)
				return TRUE;
		}
		return FALSE;
	}

	// now strDir must contain a subdir name
	CFileStatus rStatus;
	if (!CFile::GetStatus(strDir, rStatus))
		return FALSE;
	if (rStatus.m_attribute & CFile::directory)
		return TRUE;
	return FALSE;
}

BOOL AxCommonCreateDir(const CString &strDir )
{
	CString strTemp = strDir;

	strTemp = strTemp.TrimRight(_T('\\')) + _T('\\');
	CFileFind fFind;
	CStringArray straDir;

	while ( !fFind.FindFile(strTemp + _T("*.*")) )
	{
		straDir.Add( strTemp );
		strTemp.TrimRight(_T('\\'));
		strTemp = strTemp.Left( strTemp.ReverseFind(_T('\\'))+1 );
	}

	try
	{
		for (int i=straDir.GetCount(); i > 0; i--)
		{
			if (!CreateDirectory(straDir[i-1], NULL))
			{
				return FALSE;
			}
		}
	}
	catch (...)
	{	
		return FALSE;
	}

	return TRUE;
}

BOOL AxCommonDeleteDir(const CString &strDir) 
{
	if (!AxCommonDoesDirExist(strDir))
		return TRUE;

	CString strDelPath = strDir;
	strDelPath = strDelPath.TrimRight(_T("\\"));

	TCHAR   FromBuf[MAX_PATH]; 
	ZeroMemory(FromBuf,   sizeof(FromBuf)); 

	_tcscpy(FromBuf, strDelPath.GetBuffer(0));

	SHFILEOPSTRUCT FileOp; 
	ZeroMemory(&FileOp,sizeof(SHFILEOPSTRUCT));

	FileOp.fFlags = FOF_NOCONFIRMATION; 
	FileOp.hNameMappings = NULL; 
	FileOp.hwnd = NULL; 
	FileOp.lpszProgressTitle = NULL; 
	FileOp.pFrom = FromBuf; 
	FileOp.pTo = NULL; 
	FileOp.wFunc = FO_DELETE;  

	BOOL bRet = SHFileOperation(&FileOp);	

	return !bRet;
}


CString AxCommonAdjustFileName(LPCTSTR lpFileName )
{
	CString strFileName(lpFileName);
	if( strFileName.IsEmpty())
		return strFileName;

	strFileName.Replace(_T("\\"),_T("_"));
	strFileName.Replace(_T("/"),_T("_"));
	strFileName.Replace(_T(":"),_T("_"));
	strFileName.Replace(_T("*"),_T("_"));
	strFileName.Replace(_T("?"),_T("_"));
	strFileName.Replace(_T("\""),_T("_"));
	strFileName.Replace(_T("<"),_T("_"));
	strFileName.Replace(_T(">"),_T("_"));
	strFileName.Replace(_T("|"),_T("_"));

	strFileName.Trim();

	return strFileName;
}

BOOL AxCommonGetFileInfo( LPCTSTR lpFileName, CString& strDriverName, CString& strDirName, CString& strFileName, CString& strExtName)
{
	TCHAR szDrv[_MAX_DRIVE], szDir[_MAX_DIR];
	TCHAR szMain[_MAX_FNAME], szExt[_MAX_EXT];

	CString strFilePathName(lpFileName);
	_tsplitpath(strFilePathName, szDrv, szDir, szMain, szExt);

	strDriverName = szDrv;
	strDirName = szDir;
	strFileName = szMain;
	strExtName = szExt;

	return TRUE;
}

BOOL AxCommonFileDlg(BOOL bOpen, LPCTSTR lpszDefExt, LPCTSTR lpszFileName, DWORD dwFlags,
					 LPCTSTR lpszFilter, LPCTSTR lpszTitle, CString& strFilePath, CWnd* pWnd)
{
	CFileDialog dlg(bOpen, lpszDefExt, lpszFileName, dwFlags, lpszFilter, pWnd);

	dlg.m_ofn.Flags |= OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT;
	dlg.m_ofn.Flags |= dwFlags;
	dlg.m_ofn.lpstrTitle = lpszTitle;

	INT_PTR iReturn = dlg.DoModal();

	if (pWnd != NULL)
		pWnd->UpdateWindow();

	if (iReturn == IDCANCEL)
		return FALSE;

	strFilePath = dlg.GetPathName();

	return TRUE;
}

CString AxCommonOleVariant2String(const COleVariant& var)
{
	USES_CONVERSION;

	CString strRet;
	strRet = _T("Fish");
	switch(var.vt)
	{
	case VT_EMPTY:
	case VT_NULL:
		strRet = _T("NULL");
		break;
	case VT_I2:
		strRet.Format(_T("%hd"),V_I2(&var));
		break;
	case VT_I4:
		strRet.Format(_T("%d"),V_I4(&var));
		break;
	case VT_R4:
		strRet.Format(_T("%e"),(double)V_R4(&var));
		break;
	case VT_R8:
		strRet.Format(_T("%e"),V_R8(&var));
		break;
	case VT_CY:
		strRet = COleCurrency(var).Format();
		break;
	case VT_DATE:
		strRet = COleDateTime(var).Format(_T("%m %d %y"));
		break;
	case VT_BSTR:
		strRet = (TCHAR *)_bstr_t(&var);
		break;
	case VT_DISPATCH:
		strRet = _T("VT_DISPATCH");
		break;
	case VT_ERROR:
		strRet = _T("VT_ERROR");
		break;
	case VT_BOOL:
		return V_BOOL(&var) ? _T("TRUE") : _T("FALSE");
	case VT_VARIANT:
		strRet = _T("VT_VARIANT");
		break;
	case VT_UNKNOWN:
		strRet = _T("VT_UNKNOWN");
		break;
	case VT_I1:
		strRet = _T("VT_I1");
		break;
	case VT_UI1:
		strRet.Format(_T("0x%02hX"),(unsigned short)V_UI1(&var));
		break;
	case VT_UI2:
		strRet = _T("VT_UI2");
		break;
	case VT_UI4:
		strRet = _T("VT_UI4");
		break;
	case VT_I8:
		strRet = _T("VT_I8");
		break;
	case VT_UI8:
		strRet = _T("VT_UI8");
		break;
	case VT_INT:
		strRet = _T("VT_INT");
		break;
	case VT_UINT:
		strRet = _T("VT_UINT");
		break;
	case VT_VOID:
		strRet = _T("VT_VOID");
		break;
	case VT_HRESULT:
		strRet = _T("VT_HRESULT");
		break;
	case VT_PTR:
		strRet = _T("VT_PTR");
		break;
	case VT_SAFEARRAY:
		strRet = _T("VT_SAFEARRAY");
		break;
	case VT_CARRAY:
		strRet = _T("VT_CARRAY");
		break;
	case VT_USERDEFINED:
		strRet = _T("VT_USERDEFINED");
		break;
	case VT_LPSTR:
		strRet = _T("VT_LPSTR");
		break;
	case VT_LPWSTR:
		strRet = _T("VT_LPWSTR");
		break;
	case VT_FILETIME:
		strRet = _T("VT_FILETIME");
		break;
	case VT_BLOB:
		strRet = _T("VT_BLOB");
		break;
	case VT_STREAM:
		strRet = _T("VT_STREAM");
		break;
	case VT_STORAGE:
		strRet = _T("VT_STORAGE");
		break;
	case VT_STREAMED_OBJECT:
		strRet = _T("VT_STREAMED_OBJECT");
		break;
	case VT_STORED_OBJECT:
		strRet = _T("VT_STORED_OBJECT");
		break;
	case VT_BLOB_OBJECT:
		strRet = _T("VT_BLOB_OBJECT");
		break;
	case VT_CF:
		strRet = _T("VT_CF");
		break;
	case VT_CLSID:
		strRet = _T("VT_CLSID");
		break;
	}
	WORD vt = var.vt;
	if(vt & VT_ARRAY)
	{
		vt = vt & ~VT_ARRAY;
		strRet = _T("Array of ");
	}
	if(vt & VT_BYREF)
	{
		vt = vt & ~VT_BYREF;
		strRet += _T("Pointer to ");
	}
	if(vt != var.vt)
	{
		switch(vt)
		{
		case VT_EMPTY:
			strRet += _T("VT_EMPTY");
			break;
		case VT_NULL:
			strRet += _T("VT_NULL");
			break;
		case VT_I2:
			strRet += _T("VT_I2");
			break;
		case VT_I4:
			strRet += _T("VT_I4");
			break;
		case VT_R4:
			strRet += _T("VT_R4");
			break;
		case VT_R8:
			strRet += _T("VT_R8");
			break;
		case VT_CY:
			strRet += _T("VT_CY");
			break;
		case VT_DATE:
			strRet += _T("VT_DATE");
			break;
		case VT_BSTR:
			strRet += _T("VT_BSTR");
			break;
		case VT_DISPATCH:
			strRet += _T("VT_DISPATCH");
			break;
		case VT_ERROR:
			strRet += _T("VT_ERROR");
			break;
		case VT_BOOL:
			strRet += _T("VT_BOOL");
			break;
		case VT_VARIANT:
			strRet += _T("VT_VARIANT");
			break;
		case VT_UNKNOWN:
			strRet += _T("VT_UNKNOWN");
			break;
		case VT_I1:
			strRet += _T("VT_I1");
			break;
		case VT_UI1:
			strRet += _T("VT_UI1");
			break;
		case VT_UI2:
			strRet += _T("VT_UI2");
			break;
		case VT_UI4:
			strRet += _T("VT_UI4");
			break;
		case VT_I8:
			strRet += _T("VT_I8");
			break;
		case VT_UI8:
			strRet += _T("VT_UI8");
			break;
		case VT_INT:
			strRet += _T("VT_INT");
			break;
		case VT_UINT:
			strRet += _T("VT_UINT");
			break;
		case VT_VOID:
			strRet += _T("VT_VOID");
			break;
		case VT_HRESULT:
			strRet += _T("VT_HRESULT");
			break;
		case VT_PTR:
			strRet += _T("VT_PTR");
			break;
		case VT_SAFEARRAY:
			strRet += _T("VT_SAFEARRAY");
			break;
		case VT_CARRAY:
			strRet += _T("VT_CARRAY");
			break;
		case VT_USERDEFINED:
			strRet += _T("VT_USERDEFINED");
			break;
		case VT_LPSTR:
			strRet += _T("VT_LPSTR");
			break;
		case VT_LPWSTR:
			strRet += _T("VT_LPWSTR");
			break;
		case VT_FILETIME:
			strRet += _T("VT_FILETIME");
			break;
		case VT_BLOB:
			strRet += _T("VT_BLOB");
			break;
		case VT_STREAM:
			strRet += _T("VT_STREAM");
			break;
		case VT_STORAGE:
			strRet += _T("VT_STORAGE");
			break;
		case VT_STREAMED_OBJECT:
			strRet += _T("VT_STREAMED_OBJECT");
			break;
		case VT_STORED_OBJECT:
			strRet += _T("VT_STORED_OBJECT");
			break;
		case VT_BLOB_OBJECT:
			strRet += _T("VT_BLOB_OBJECT");
			break;
		case VT_CF:
			strRet += _T("VT_CF");
			break;
		case VT_CLSID:
			strRet += _T("VT_CLSID");
			break;
		}
	}
	return strRet;
}

// [12/21/2009 GRL Modify] Only 1 for-loop will be execute
// Use reference-parameter to avoid the SAxTableRecordSet be copy twice
void AxCommonTransRecordSet(CAxADORecordSet& recordSet, OUT SAxTableRecordSet &sTableRecords)
{
	sTableRecords.RemoveAll();

	if( recordSet.IsOpen())
	{
		int iFieldCount = recordSet.GetFieldCount();

		if( recordSet.GetRecordCount() == 0)
		{
			for( int nCycField=0; nCycField < iFieldCount; nCycField++)
			{
				sTableRecords.m_aryFieldsName.Add( recordSet.GetFieldName(nCycField) );
			}
		}
		else
		{
			BOOL bAddFieldName = TRUE;

			recordSet.MoveFirst();
			while( !recordSet.IsEOF() )
			{
				SAxRowRecord sRowRecord;

				for( int nCycField=0; nCycField < iFieldCount; nCycField++)
				{
					CString strValue;
					recordSet.GetFieldValue(nCycField, strValue);
					sRowRecord.m_aryRowColValue.Add(strValue);
					
					// Init the FieldName
					if (bAddFieldName)
					{
						sTableRecords.m_aryFieldsName.Add( recordSet.GetFieldName(nCycField) );
					}
				}

				bAddFieldName = FALSE;

				sTableRecords.m_aryRowRecords.Add(sRowRecord);

				recordSet.MoveNext();
			}
		}
	}
}

BOOL AxCommonFillGridCtrl(CAsCoolGridCtrl* pGridCtrl, CAxADORecordSet& recordSet, BOOL bColorRow/* = TRUE*/, COLORREF clrOddRow, COLORREF clrEvenRow, LOGFONT* lgHeaderFont/* = NULL*/, LOGFONT* lgCellTextFont/* = NULL*/)
{
	ASSERT( pGridCtrl != NULL);

	SAxTableRecordSet rsTbl;
	AxCommonTransRecordSet(recordSet, rsTbl);

	return AxCommonFillGridCtrl(pGridCtrl, rsTbl, bColorRow, clrOddRow, clrEvenRow, lgHeaderFont, lgCellTextFont);
}

BOOL AxCommonFillGridCtrl(CAsCoolGridCtrl* pGridCtrl, SAxTableRecordSet& rsTable, BOOL bColorRow/* = TRUE*/, COLORREF clrOddRow, COLORREF clrEvenRow, LOGFONT* lgHeaderFont/* = NULL*/, LOGFONT* lgCellTextFont/* = NULL*/)
{
	LOGFONT lf;
	GetObject(GetStockObject(SYSTEM_FONT), sizeof(LOGFONT), &lf);

	pGridCtrl->SetRowCount(0);
	pGridCtrl->SetColumnCount(rsTable.GetFieldsCount());
	pGridCtrl->SetRowCount(rsTable.GetRowRecordsCount() + 1);
	pGridCtrl->SetFixedRowCount();	

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
	}

	for( int iRowIdx = 0; iRowIdx < rsTable.GetRowRecordsCount(); iRowIdx++ )
	{
		for( int iFieldIdx = 0; iFieldIdx < rsTable.GetFieldsCount(); iFieldIdx++ )
		{
			pGridCtrl->SetItemText(iRowIdx + 1, iFieldIdx, rsTable.GetValue(iFieldIdx, iRowIdx));
			if( lgCellTextFont)		
			{
				pGridCtrl->SetItemFont(iRowIdx + 1, iFieldIdx, lgCellTextFont);
			}			
		}
		if( bColorRow)
		{
			if( iRowIdx % 2  == 1)
				pGridCtrl->SetRowBkColor(iRowIdx + 1, clrEvenRow);	
			else
				pGridCtrl->SetRowBkColor(iRowIdx + 1, clrOddRow);	
		}
	}

	pGridCtrl->AutoSizeColumns();
	pGridCtrl->ExpandLastColumn();
	pGridCtrl->Refresh();

	return TRUE;
}

int AxCommonGetColIdxByName(CAsCoolGridCtrl* pGridCtrl, CString strColumnName)
{
	for(int i = 0; i < pGridCtrl->GetColumnCount(); i++ )
	{
		CString strCurColumnName;
		strCurColumnName = pGridCtrl->GetItemText(0, i);
		if(strCurColumnName.CompareNoCase(strColumnName) == 0)
		{
			return i;
		}
	}
	return -1;
}

void AxCommonFillComboBox( AryAxCmbItems &aryCmb, CAxADORecordSet &RecordSet, int nValueIndex, int nKeyIndex )
{
	aryCmb.RemoveAll();

	int fieldCount = RecordSet.GetFieldCount();

	if ( fieldCount < nValueIndex || nValueIndex < 0 )
		return;

	if ( fieldCount < nKeyIndex || nKeyIndex < 0 )
		return;

	int nItem = 0;
	while( !RecordSet.IsEOF() )
	{
		CString strValue;
		int		intkey;
		RecordSet.GetFieldValue(nValueIndex, strValue);
		RecordSet.GetFieldValue(nKeyIndex, intkey);
		aryCmb.Add( STAxCmbItem(strValue, LPARAM(intkey)) );
		RecordSet.MoveNext();
	}
}

void AxCommonFillComboBox( CComboBox &ComboBox, CAxADORecordSet &RecordSet, int nValueIndex, int nKeyIndex )
{
	ComboBox.ModifyStyle( CBS_DROPDOWN, CBS_DROPDOWNLIST, SWP_DRAWFRAME );   
	//清空ComboBox
	ComboBox.ResetContent();
	int fieldCount = RecordSet.GetFieldCount();

	if ( fieldCount < nValueIndex || nValueIndex < 0 )
		return;

	if ( fieldCount < nKeyIndex || nKeyIndex < 0 )
		return;

	int nItem = 0;
	while( !RecordSet.IsEOF() )
	{
		CString strValue;
		int		intkey;
		RecordSet.GetFieldValue(nValueIndex,strValue);
		RecordSet.GetFieldValue(nKeyIndex,intkey);
		nItem = ComboBox.AddString(strValue);
		ComboBox.SetItemData(nItem, intkey);
		RecordSet.MoveNext();
	}
}

BOOL AxCommonGetActiveInfo(CAxADODataBase* pDB, int &iSportID, int &iDisciplineID, CString &strLanguageCode)
{
	iSportID = 0;
	iDisciplineID = 0;
	strLanguageCode = _T("CHN");

	if( !pDB )
		return FALSE;

	CAxADOParameter pParamIn1(CAxADORecordSet::emDataTypeInteger, sizeof(int), 
		CAxADOParameter::emParamOutput);
	CAxADOParameter pParamIn2(CAxADORecordSet::emDataTypeInteger, sizeof(int),
		CAxADOParameter::emParamOutput);
	CAxADOParameter pParamIn3(CAxADORecordSet::emDataTypeChar, sizeof(char) * 3,
		CAxADOParameter::emParamOutput);
	CAxADOParameter pParamIn4(CAxADORecordSet::emDataTypeInteger, sizeof(int),
		CAxADOParameter::emParamOutput);

	CAxADOCommand cmd(pDB, _T("Proc_GetActiveInfo"));

	cmd.AddParameter(&pParamIn1);
	cmd.AddParameter(&pParamIn2);
	cmd.AddParameter(&pParamIn3);
	cmd.AddParameter(&pParamIn4);

	if( cmd.Execute() )
	{
		int nRet;
		pParamIn4.GetValue(nRet);
		if (nRet)
		{
			pParamIn1.GetValue(iSportID);
			pParamIn2.GetValue(iDisciplineID);
			pParamIn3.GetValue(strLanguageCode);
			return TRUE;
		}
	}

	return FALSE;
}

BOOL AxCommonGetScheduleTree(CAxADODataBase* pDB, int iID, int iType, CString strLanguageCode, CAxADORecordSet& obRecordSet)
{
	if( !pDB )
		return FALSE;

	CAxADOCommand cmd(pDB, _T("Proc_GetScheduleTree"));

	cmd.AddParameter( _T("@ID"), CAxADORecordSet::emDataTypeInteger, 
		CAxADOParameter::emParamInput, sizeof(int), iID);
	cmd.AddParameter( _T("@Type"), CAxADORecordSet::emDataTypeInteger, 
		CAxADOParameter::emParamInput, sizeof(int), iType);
	cmd.AddParameter( _T("@LanguageCode"), CAxADORecordSet::emDataTypeChar, 
		CAxADOParameter::emParamInput, sizeof(char)*3, (_bstr_t)strLanguageCode);

	if( obRecordSet.Execute(&cmd) )
	{
		return TRUE;
	}

	return FALSE;
}

BOOL AxCommonGetOperators(CAxADODataBase* pDB, CAxADORecordSet& obRecordSet)
{
	if( !pDB )
		return FALSE;

	CString strSQL=_T("SELECT F_PersonLongName, F_PersonID FROM TO_Person");
	return ( obRecordSet.Open(strSQL) );

}

BOOL AxCommonGetRoles(CAxADODataBase* pDB, int iOperatorID, CAxADORecordSet& obRecordSet)
{
	if( !pDB )
		return FALSE;

	CString strSQL;
	strSQL.Format(_T("SELECT B.F_LongRoleName, B.F_RoleID FROM TO_Person_Role AS A LEFT JOIN TO_Role_Des AS B ON A.F_RoleID = B.F_RoleID WHERE B.F_LanguageCode = 'CHN' AND A.F_PersonID = %d"), iOperatorID);
	return ( obRecordSet.Open(strSQL) );
}

BOOL AxCommonGetOperatorPassWord(CAxADODataBase* pDB, int iOperatorID, CString& strPassWord)
{
	strPassWord = _T("");
	if( !pDB )
		return FALSE;

	CAxADORecordSet obRecordSet(pDB);
	CString strSQL;
	strSQL.Format(_T("SELECT F_PassWord FROM TO_Person WHERE F_PersonID = %d"), iOperatorID);

	if ( obRecordSet.Open(strSQL) )
	{
		if(!obRecordSet.IsEOF())
		{
			CString strInputPassWord;
			obRecordSet.GetFieldValue(_T("F_PassWord"), strInputPassWord);
			CAxIdeaEncryphtion::DecipherString(strInputPassWord, strPassWord, _T("Auto_OVR"));
			return TRUE;
		}
	}

	return FALSE;
}

BOOL AxCommonGetOperatorModules(CAxADODataBase* pDB, int iRoleID, CUIntArray& aryModuleID)
{
	aryModuleID.RemoveAll();

	if( !pDB )
		return FALSE;
	
	CAxADORecordSet obRecordSet(pDB);
	CString strSQL;
	strSQL.Format(_T("SELECT F_ModuleID FROM TO_Role_Module WHERE F_RoleID = %d"), iRoleID);

	if ( obRecordSet.Open(strSQL) )
	{
		while(!obRecordSet.IsEOF())
		{
			int iModuleID;
			obRecordSet.GetFieldValue(_T("F_ModuleID"), iModuleID);
			aryModuleID.Add(iModuleID);
			obRecordSet.MoveNext();
		}
		return TRUE;
	}

	return FALSE;
}

BOOL AxCommonGetSexList(CAxADODataBase* pDB, CAxADORecordSet& obRecordSet, CString strLanguageCode)
{
	if( !pDB )
		return FALSE;

	CAxADOCommand cmd(pDB, _T("Proc_GetSexList"));

	cmd.AddParameter( _T("@LanguageCode"), CAxADORecordSet::emDataTypeChar, 
		CAxADOParameter::emParamInput, sizeof(char)*3, (_bstr_t)strLanguageCode);

	if( obRecordSet.Execute(&cmd) )
	{
		return TRUE;
	}

	return FALSE;
}

BOOL AxCommonGetRegTypeList(CAxADODataBase* pDB, CAxADORecordSet& obRecordSet, CString strLanguageCode)
{
	if( !pDB )
		return FALSE;

	CAxADOCommand cmd(pDB, _T("Proc_GetRegTypeList"));
	cmd.AddParameter( _T("@LanguageCode"), CAxADORecordSet::emDataTypeChar, 
		CAxADOParameter::emParamInput, sizeof(char)*3, (_bstr_t)strLanguageCode);

	if( obRecordSet.Execute(&cmd) )
	{
		return TRUE;
	}

	return FALSE;
}

BOOL AxCommonGetFederationList(CAxADODataBase* pDB, CAxADORecordSet& obRecordSet, int iDisciplineID, CString strLanguageCode)
{
	if( !pDB )
		return FALSE;

	CAxADOCommand cmd(pDB, _T("Proc_GetFederationList"));

	cmd.AddParameter( _T("@DisciplineID"), CAxADORecordSet::emDataTypeInteger, 
		CAxADOParameter::emParamInput, sizeof(int), iDisciplineID);
	cmd.AddParameter( _T("@LanguageCode"), CAxADORecordSet::emDataTypeChar, 
		CAxADOParameter::emParamInput, sizeof(char)*3, (_bstr_t)strLanguageCode);

	if( obRecordSet.Execute(&cmd) )
	{
		return TRUE;
	}

	return FALSE;
}

BOOL AxCommonGetEventList(CAxADODataBase* pDB, CAxADORecordSet& obRecordSet, int iDisciplineID, CString strLanguageCode)
{
	if( !pDB )
		return FALSE;

	CAxADOCommand cmd(pDB, _T("Proc_GetEventListByDisciplineID"));

	cmd.AddParameter( _T("@DisciplineID"), CAxADORecordSet::emDataTypeInteger, 
		CAxADOParameter::emParamInput, sizeof(int), iDisciplineID);
	cmd.AddParameter( _T("@LanguageCode"), CAxADORecordSet::emDataTypeChar, 
		CAxADOParameter::emParamInput, sizeof(char)*3, (_bstr_t)strLanguageCode);

	if( obRecordSet.Execute(&cmd) )
	{
		return TRUE;
	}

	return FALSE;
}


// 生成格式化的txt或CSV文本
BOOL AxCommonBuildFile(const LPCTSTR lpFileName, CAxADORecordSet& recordSet, CString strFlag)
{
	SAxTableRecordSet rsTbl;
	AxCommonTransRecordSet(recordSet, rsTbl);

	return AxCommonBuildFile(lpFileName, rsTbl, strFlag);
}

BOOL AxCommonBuildFile(const LPCTSTR lpFileName, SAxTableRecordSet& rsTable, CString strFlag)
{
	CAxStdioFileEx hFile;
	if( hFile.Open( lpFileName, CFile::modeCreate|CFile::modeWrite|CFile::typeText) )
	{
		hFile.SeekToBegin();

		CString strHeader;
		for( int iFieldIdx = 0; iFieldIdx < rsTable.GetFieldsCount(); iFieldIdx++ )
		{			
			strHeader += rsTable.GetFieldName(iFieldIdx);
			strHeader += strFlag;				
		}
	
		hFile.WriteString(strHeader);
		hFile.WriteString(_T("\r\n"));
		
		for( int iRowIdx = 0; iRowIdx < rsTable.GetRowRecordsCount(); iRowIdx++ )
		{
			CString strRowValue;
			for( int iFieldIdx = 0; iFieldIdx < rsTable.GetFieldsCount(); iFieldIdx++ )
			{
				strRowValue += rsTable.GetValue(iFieldIdx, iRowIdx);
				strRowValue += strFlag;					
			}
			hFile.WriteString(strRowValue);
			hFile.WriteString(_T("\r\n"));
		}
	}
	else
	{
		//CString strFormat;
		//strFormat.Format(_T("创建或打开文件：%s 无效，请确认文件路径是否有效!"), CString(lpFileName));
		//AfxMessageBox(strFormat);

		return FALSE;
	}
	
	hFile.Close();

	return TRUE;
}

#define ROW_SPLIT_TOKEN		_T("\n")

BOOL AxCommonParseTxtToRecordSet(const CString &strCSVContent, OUT SAxTableRecordSet& sRecordSet, CString strSplitFlag)
{
	CString strText = strCSVContent;
	if (strText.IsEmpty()) return FALSE;

	sRecordSet.m_aryFieldsName.RemoveAll();
	sRecordSet.m_aryRowRecords.RemoveAll();

	// First Line is the FieldName
	int nFieldCount = 0;
	int posRow = strText.Find(ROW_SPLIT_TOKEN);
	if (posRow > 0)
	{
		CString strFieldLine = strText.Left(posRow);
		int posCol = strFieldLine.Find(strSplitFlag);
		while (posCol >= 0)
		{
			CString strFieldName = strFieldLine.Left(posCol);
			strFieldName.Trim();

			sRecordSet.m_aryFieldsName.Add(strFieldName); // Add Field Name
			nFieldCount++;

			strFieldLine = strFieldLine.Right(strFieldLine.GetLength() - posCol -1);
			posCol = strFieldLine.Find(strSplitFlag);
		}

		// Process the Last Col
		if (posCol < 0 && !strFieldLine.IsEmpty())
		{
			strFieldLine.Trim();
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

			int posCol = strRecordLine.Find(strSplitFlag);

			for (int i=0; i < nFieldCount; i++)
			{
				if (posCol >= 0)
				{
					CString strFieldValue = strRecordLine.Left(posCol);
					strFieldValue.Trim();

					sOneRecord.m_aryRowColValue.Add(strFieldValue); // Add Field Value

					strRecordLine = strRecordLine.Right(strRecordLine.GetLength() - posCol -1);
					posCol = strRecordLine.Find(strSplitFlag);
				}
				else // Ensure the each record has the correct col count
				{
					strRecordLine.Trim();
					sOneRecord.m_aryRowColValue.Add(strRecordLine.IsEmpty() ? NULL : strRecordLine); // Add Field Value
					strRecordLine = _T("");
				}
			}

			sRecordSet.m_aryRowRecords.Add(sOneRecord);
		}
	}

	return TRUE;
}

CString AxCommonInt2String(int nVal)
{
	CString strVal;
	strVal.Format(_T("%d"), nVal);
	return strVal;
}