 
#include "StdAfx.h"
#include "TVExportManager.h"
#include "TVDBAccess.h"
#include <Lm.h>

CTVExportManger::CTVExportManger()
{
	m_pRootDiscipline = NULL;
	m_pCSData = NULL;

	m_bOutputOkLog = TRUE;
	m_bOutputErrorLog = TRUE;
	m_bOutputAliveLog = FALSE;
	m_bOutputThreadLog = TRUE;
}

CTVExportManger::~CTVExportManger()
{
	StopExportService();
}

BOOL CTVExportManger::StartExportService(CTVDiscipline* pRootDiscipline,CCriticalSection* pCSData,CEvent* pEventQueueEmpty)
{
	//argument check
	if (!pRootDiscipline||!pCSData||!pEventQueueEmpty)
		return FALSE;

	if (!pRootDiscipline->IsKindOf(RUNTIME_CLASS(CTVDiscipline)))
		return FALSE;

	m_pRootDiscipline = (CTVDiscipline*)pRootDiscipline;
	m_pCSData = pCSData;
	m_pEventQueueEmpty = pEventQueueEmpty;

	return CreateExportThread();
}

void CTVExportManger::StopExportService()
{
	DestroyExportThread();

	m_pRootDiscipline = NULL;
	m_pCSData = NULL;
}


//////////////////////////////////////////////////////////////////////////
//private methods
BOOL CTVExportManger::ExportTree(CTVNodeBase* pNode)
{
	if (!pNode)
		return FALSE;

	if (pNode->IsKindOf(RUNTIME_CLASS(CTVEvent)))
	{
		if (!ExportEventNode((CTVEvent*)pNode))
			return FALSE;
	}
	else
	{
		if (!ExportNode(pNode))
			return FALSE;
	}

	// Export children Nodes
	int nChildNodeCount = pNode->GetChildNodesCount();
	for (int i=0; i < nChildNodeCount; i++)
	{
		CTVNodeBase *pChildNode = pNode->GetChildNode(i);

		if (!ExportTree(pChildNode))
			return FALSE;
	}

	return TRUE;
}

BOOL CTVExportManger::ExportNode(CTVNodeBase* pNode)
{
	if (!pNode)
		return FALSE;

	if (!AxCommonDoesDirExist(pNode->m_strPath))
		if (!AxCommonCreateDir(pNode->m_strPath))
			return FALSE;

	int nTableCount = pNode->m_ChildTables.GetTableCount();
	for (int i = 0; i < nTableCount; i++)
	{
		CTVTable *pTable = pNode->m_ChildTables.GetTable(i);
		
		if (!pTable->m_bUpdated)
			continue;

		if (pTable->IsKindOf(RUNTIME_CLASS(CTVTableSessionSts)))
		{
			if (!ExportSTSFile((CTVTableSessionSts*)pTable))
				return FALSE;
			OutputMessage(_T("Exported: ")+pTable->m_strTableFileName,emLogExportOk);
		}
		else
		{
			if (!ExportTable(pTable))
				return FALSE;
		}
	}
	return TRUE;
}

BOOL CTVExportManger::ExportEventNode(CTVEvent* pNode)
{
	if (!pNode)
		return FALSE;

	if (!pNode->IsKindOf(RUNTIME_CLASS(CTVEvent)))
		return FALSE;

	if (!AxCommonDoesDirExist(pNode->m_strPath))
		if (!AxCommonCreateDir(pNode->m_strPath))
			return FALSE;
	
	//open event.grd for files control
	CAxStdioFileEx fGRDFile;
	CString strGRDFileName = pNode->m_strPath + _T("\\") + STR_EVENTGRD_TABLENAME;
	if (!OpenExportFileEx(strGRDFileName, pNode->m_strPath, &fGRDFile, TRUE))
		return FALSE;
//	OutputMessage(_T("GRD Opened: ")+strGRDFileName,emLogExportOk);

	//now we can export tables in event
	if (!ExportNode(pNode))
	{
		WriteGuardFileAndClose(&fGRDFile,pNode,TRUE);
//		OutputMessage(_T("GRD Closed: ")+strGRDFileName,emLogExportOk);
		return FALSE;
	}

	//all tables exported ok, write and close event.grd
	m_sExportStats.nExportedOk++;
	WriteGuardFileAndClose(&fGRDFile,pNode);
//	OutputMessage(_T("GRD Closed: ")+strGRDFileName,emLogExportOk);
	return TRUE;
}

BOOL CTVExportManger::ExportSTSFile(CTVTableSessionSts* pTable)
{
	if (!pTable)
		return FALSE;

	if (!pTable->IsKindOf(RUNTIME_CLASS(CTVTableSessionSts)))
		return FALSE;

	SAxTableRecordSet sRecordSet;
	if (!pTable->GetSQLResults(sRecordSet))
		return FALSE;

	CAxStdioFileEx fTableFile;
	if (!OpenExportFileEx(pTable->m_strTableFileName, pTable->m_pParentNode->m_strPath, &fTableFile))
		return FALSE;

	//Finally, we can do export
	fTableFile.SeekToBegin();

	CString strRowValue;
	for( int iRowIdx = 0; iRowIdx < sRecordSet.GetRowRecordsCount(); iRowIdx++ )
	{
		strRowValue = STR_EXPORT_SPECIALTOKEN;
		for( int iFieldIdx = 0; iFieldIdx < sRecordSet.GetFieldsCount(); iFieldIdx++ )
		{
			strRowValue += sRecordSet.GetValue(iFieldIdx, iRowIdx);
			strRowValue += STR_EXPORT_SPECIALTOKEN;					
		}
		fTableFile.WriteString(strRowValue);
		fTableFile.WriteString(_T("\r\n"));
	}

	fTableFile.Close();
	pTable->m_bUpdated = FALSE;
	return TRUE;
}

BOOL CTVExportManger::ExportTable(CTVTable* pTable)
{
	if (!pTable)
		return FALSE;

	if (pTable->IsKindOf(RUNTIME_CLASS(CTVTableEventGrd)))
		return TRUE;

	if (pTable->IsKindOf(RUNTIME_CLASS(CTVTableSessionSts)))
		return TRUE;

	SAxTableRecordSet sRecordSet;
	if (!pTable->GetSQLResults(sRecordSet))
		return FALSE;

	//if column count of record set if zero, we will not create this file
	int iFieldCount = sRecordSet.GetFieldsCount();
	if (iFieldCount == 0)
	{
		pTable->m_bUpdated = FALSE;
		return TRUE;
	}
	CAxStdioFileEx fTableFile;
	if (!OpenExportFileEx(pTable->m_strTableFileName, pTable->m_pParentNode->m_strPath, &fTableFile))
		return FALSE;

	//Finally, we can do export
	fTableFile.SeekToBegin();

	CString strHeader;
	for( int iFieldIdx = 0; iFieldIdx < iFieldCount; iFieldIdx++ )
	{
		if (sRecordSet.GetFieldName(iFieldIdx) != _T(""))
		{
			strHeader += _T("\"");
			strHeader += sRecordSet.GetFieldName(iFieldIdx);
			strHeader += _T("\"");
		}

		if (iFieldIdx != iFieldCount -1)
			strHeader += STR_EXPORT_CSVSPLITTOKEN;				
	}

	fTableFile.WriteString(strHeader);
	fTableFile.WriteString(_T("\r\n"));

	for( int iRowIdx = 0; iRowIdx < sRecordSet.GetRowRecordsCount(); iRowIdx++ )
	{
		CString strRowValue;
		for( int iFieldIdx = 0; iFieldIdx < iFieldCount; iFieldIdx++ )
		{
			if (sRecordSet.GetValue(iFieldIdx, iRowIdx) != _T(""))
			{
				strRowValue += _T("\"");
				strRowValue += sRecordSet.GetValue(iFieldIdx, iRowIdx);
				strRowValue += _T("\"");
			}

			if (iFieldIdx != iFieldCount -1)
				strRowValue += STR_EXPORT_CSVSPLITTOKEN;					
		}
		fTableFile.WriteString(strRowValue);
		fTableFile.WriteString(_T("\r\n"));
	}
	
	fTableFile.Close();
	//after exported the table, we need to recalculate checksum and mark this table as exported
	pTable->m_bUpdated = FALSE;
	pTable->UpdateChecksum();
	OutputMessage(_T("Exported: ")+pTable->m_strTableFileName,emLogExportOk);
	return TRUE;
}

BOOL CTVExportManger::WriteGuardFileAndClose(CAxStdioFileEx* pFile,CTVEvent* pNode, BOOL bFatalError /* = FALSE */)
{
	if (!pFile)
		return FALSE;

	if (!pNode)
		return FALSE;

	if (!pNode->IsKindOf(RUNTIME_CLASS(CTVEvent)))
		return FALSE;

	//Finally, we can do export
	pFile->SeekToBegin();

	//write exported number
	CString strLine = _T("");
	if (!bFatalError)
		strLine.Format(_T("|%d|"),m_sExportStats.nExportedOk);
	else
		strLine.Format(_T("|-1|"));

	pFile->WriteString(strLine);
	pFile->WriteString(_T("\r\n"));

	//write filenames and checksum if there is no fatal error
	if (!bFatalError)
	{
		CString strChecksum = _T("");
		int nTableCount = pNode->m_ChildTables.GetTableCount();
		for (int i = 0; i < nTableCount; i++)
		{
			CTVTable *pTable = pNode->m_ChildTables.GetTable(i);
			if (pTable->IsKindOf(RUNTIME_CLASS(CTVTableEventGrd)))
				continue;
			
			//if checksum of this table is empty, we can assume that this file is not exist.
			//so we will pass this file
			if (pTable->m_strChecksum == _T(""))
				continue;
			
			strLine.Format(_T("|") + pTable->m_strTableName + STR_EXPORT_FILEEXTNAME
				+ _T("|") + pTable->m_strChecksum + _T("|"));
			pFile->WriteString(strLine);
			pFile->WriteString(_T("\r\n"));
		}
	}

	pFile->Close();
	return TRUE;
}

BOOL CTVExportManger::OpenExportFileEx(CString strFileName, CString strPathName, CAxStdioFileEx* pFile,BOOL bGrdFile /* = FALSE */)
{
	if (!pFile)
		return FALSE;

	int iErrCode = OpenExportFile(strFileName, pFile, bGrdFile);
	if (iErrCode)
	{
		// Process error in creation of guard file
		if((iErrCode == ERROR_ACCESS_DENIED) ||
			(iErrCode == ERROR_SHARING_VIOLATION) ||
			(iErrCode == ERROR_LOCK_VIOLATION)) 
		{
			// If access is denied we will try to closed all opened connections
			if (bGrdFile)
				m_sExportStats.nGrdBusy++;
			else
				m_sExportStats.nDataBusy++;
			OutputMessage(_T("Access denied: ")+strFileName,emLogExportError);

			if(CloseAllSharedOpenedFiles(strPathName))//return 0 if success
			{
				m_sExportStats.nCloseSharedFail++;
				OutputMessage(_T("Closing shared files error: ")+strPathName,emLogExportError);
				return FALSE;
			}
			else
			{
				OutputMessage(_T("Closed shared file : ")+strFileName,emLogExportError);
				m_sExportStats.nCloseSharedOk++;
			}

			//Retry
			iErrCode = OpenExportFile(strFileName, pFile, bGrdFile);
			if (iErrCode)
			{
				// Process error in creation of guard file
				if((iErrCode == ERROR_ACCESS_DENIED) ||
					(iErrCode == ERROR_SHARING_VIOLATION) ||
					(iErrCode == ERROR_LOCK_VIOLATION)) 
				{
					// Report error: after closing connections, guard file could not be opened
					OutputMessage(_T("Access denied after closing share: ")+strFileName,emLogExportError);
					return FALSE;
				}
			}
		}
		if (bGrdFile)
			m_sExportStats.nGrdFails++;
		else
			m_sExportStats.nDataFails++;
		// Report error: Unable to open file
		OutputMessage(_T("Unable to open file: ")+strFileName,emLogExportError);
		return FALSE;
	}
	return TRUE;
}

int CTVExportManger::OpenExportFile(CString strFileName,CAxStdioFileEx* pFile,BOOL bGrdFile /* = FALSE */)
{
	if (!pFile)
		return FALSE;

	ULONG* pRetryNum;
	if (bGrdFile)
		pRetryNum = &(m_sExportStats.nDataRetries);
	else
		pRetryNum = &(m_sExportStats.nGrdRetries);
	
	int iErrCode = 0;
	if(pFile->Open( strFileName, CFile::modeCreate|CFile::modeWrite|CFile::typeText|CFile::shareExclusive))
	{
		return 0;
	}
	else
	{
		iErrCode = GetLastError();
		if((iErrCode != ERROR_ACCESS_DENIED) && (iErrCode != ERROR_SHARING_VIOLATION)
			&& (iErrCode != ERROR_LOCK_VIOLATION))
			return iErrCode;
	}
	
	//locked error, let's do something
	int iDelayTime;
	for(int iRetry = 0; iRetry < DEF_EXPORT_MAXOPENRETRIES; iRetry++) 
	{
		// Increment number of retries and delay process
		(*pRetryNum)++;

		iDelayTime = DEF_EXPORT_DELAYOPEN + (rand()*DEF_EXPORT_DELAYOPEN/2)/RAND_MAX;
		Sleep(iDelayTime);

		if(pFile->Open( strFileName, CFile::modeCreate|CFile::modeWrite|CFile::typeText|CFile::shareExclusive|CAxStdioFileEx::modeWriteUnicode))
		{
			return 0;
		}
		else
		{
			iErrCode = GetLastError();
			if((iErrCode != ERROR_ACCESS_DENIED) && (iErrCode != ERROR_SHARING_VIOLATION)
				&& (iErrCode != ERROR_LOCK_VIOLATION))
				return iErrCode;
		}
	}
	//still locked
	return iErrCode;
}

int CTVExportManger::CloseAllSharedOpenedFiles(CString strPathToClose)
{
	CString strHostName = _T("");
	CString strResPath = _T("");
	SHARE_INFO_2 *shareInfo;      // Information about a shared resource
	FILE_INFO_2 *arrFiles;        // Array of opened resources
	DWORD itemsRead;              // Number of resources read in 'arrFiles'
	DWORD itemsTotal;             // Total number of resources (Must be equal to 'itemsRead')
	NET_API_STATUS errCode;       // Error code returns by network APIs
	int len;
	int maxLength;

	// Check minimum length of path
	if(strPathToClose.GetLength() < 3)
		return ERROR_INVALID_PARAMETER;

	// Initialize variables
	shareInfo = NULL;
	arrFiles = NULL;

	if((strPathToClose.Left(2) == _T("\\\\"))) 
	{
		// Path is referencing a remote host
		// Get remote host name
		int idxHost = strPathToClose.Find(_T("\\"),2);
		if (idxHost == -1)
			return ERROR_INVALID_PARAMETER;

		strHostName = strPathToClose.Mid(2,idxHost - 2);

		int idxRes = strPathToClose.Find(_T("\\"),idxHost + 1);
		if (idxRes == -1)
			strResPath = strPathToClose.Mid(idxHost + 1);
		else
			strResPath = strPathToClose.Mid(idxHost + 1, idxRes - idxHost - 1);

		// Get information about the shared resource to get the local path used
		// to share it
		errCode = NetShareGetInfo(strHostName.GetBuffer(), strResPath.GetBuffer(), 2, (LPBYTE *)&shareInfo);
		if(errCode != NERR_Success)
			return errCode;
		strResPath = shareInfo->shi2_path;
	} 
	else 
	{
		// Path is referencing a local host
		strHostName = _T("");
		
		// Enumerate all shared resources in local machine
		errCode = NetShareEnum(NULL, 2, (LPBYTE *)&shareInfo, MAX_PREFERRED_LENGTH,
			&itemsRead, &itemsTotal, NULL);
		if(errCode != NERR_Success)
			return errCode;

		// Look for the shared resource that better math with the diven path.
		// It is used the resource that more characters matches with the resource
		// (special resources will be ignored).
		maxLength = 0;
		for(DWORD idx = 0 ; idx<itemsRead ; idx++) 
		{
			len = lstrlenW(shareInfo[idx].shi2_path);
			if((len == 0) || (shareInfo[idx].shi2_type))
				continue;

			if(CompareStringW(LOCALE_SYSTEM_DEFAULT, NORM_IGNORECASE,
				shareInfo[idx].shi2_path, len, strPathToClose, len) == 2) 
			{
				// Check if the name of the resource is complete
				if ((strPathToClose.GetLength() != len)&&(strPathToClose.Right(1) != _T("\\")))
					continue;

				if(len > maxLength) 
				{
					maxLength = len;
					strResPath = shareInfo[idx].shi2_path;
				}
			}
		}

		if(maxLength == 0) 
		{
			if(shareInfo)
				NetApiBufferFree(shareInfo);
			return NERR_NetNameNotFound;
		}
	}

	// Enumerate all opened file connections
	arrFiles = NULL;
	errCode = NetFileEnum(strHostName.GetBuffer(), strResPath.GetBuffer(), NULL, 2, (LPBYTE *)&arrFiles,
		MAX_PREFERRED_LENGTH, &itemsRead, &itemsTotal, NULL);
	if(errCode != NERR_Success) 
	{
		if(shareInfo)
			NetApiBufferFree(shareInfo);
		return errCode;
	}

	// Loop over all opened file connections for closing their
	errCode = NERR_Success;
	for(DWORD idx = 0 ; idx < itemsRead ; idx++) 
	{
		// Close resource
		errCode = NetFileClose(strHostName.GetBuffer(), arrFiles[idx].fi2_id);
		if(errCode != NERR_Success) 
		{
			if(errCode == ERROR_ACCESS_DENIED) 
			{
				// It must be taken into account that a previously enumerated file
				// can has been closed: so error code ERROR_FILE_NOT_FOUND is not
				// reported
				break;
			}
			errCode=NERR_Success;
		}
	}

	// Clear buffers
	if(shareInfo)
		NetApiBufferFree(shareInfo);
	if(arrFiles)
		NetApiBufferFree(arrFiles);

	// Return error code
	return errCode;
}

CTVTableSessionSts* CTVExportManger::GetNodeSTSFile(CTVNodeBase* pNode)
{
	if (!pNode)
		return NULL;

	if ((pNode->m_emNodeType == emTypeSession)||(pNode->m_emNodeType == emTypeCourt))
	{
		int nTableCount = pNode->m_ChildTables.GetTableCount();
		for (int i = 0; i < nTableCount; i++)
		{
			CTVTable *pTable = pNode->m_ChildTables.GetTable(i);

			if (pTable->IsKindOf(RUNTIME_CLASS(CTVTableSessionSts)))
				return (CTVTableSessionSts*)pTable;
		}
	}
	
	return NULL;
}

BOOL CTVExportManger::AliveGRDFile(CTVEvent* pEvent)
{
	if (!pEvent)
		return FALSE;

	if (!pEvent->IsKindOf(RUNTIME_CLASS(CTVEvent)))
		return FALSE;

	CAxStdioFileEx fGRDFile;
	CString strGRDFileName = pEvent->m_strPath + _T("\\") + STR_EVENTGRD_TABLENAME;
	//is file exist?  if no, we don't need to create it.
	if (!AxCommonDoesFileExist(strGRDFileName))
		return TRUE;
	//now try to open and write to it
	if (!OpenExportFileEx(strGRDFileName, pEvent->m_strPath, &fGRDFile, TRUE))
		return FALSE;

	if (!WriteGuardFileAndClose(&fGRDFile,pEvent))
		return FALSE;

	OutputMessage(_T("Alived File: ")+strGRDFileName,emLogAlive);
	return TRUE;
}


BOOL CTVExportManger::AliveSTSFile(CTVNodeBase* pNode)
{
	if (!pNode)
		return FALSE;

	CTVTableSessionSts* pSTS = GetNodeSTSFile(pNode);
	if (!pSTS)
		return TRUE;//this node has no sts file, we treat this situation as update successful

	//is file exist?  if no, we don't need to create it.
	if (!AxCommonDoesFileExist(pSTS->m_strTableFileName))
		return TRUE;

	if (!ExportSTSFile(pSTS))
		return FALSE;

	OutputMessage(_T("Alived File: ")+pSTS->m_strTableFileName,emLogAlive);
	return TRUE;
}

BOOL CTVExportManger::AliveFilesFromNode(CTVNodeBase* pNode)
{
	if (!pNode)
		return FALSE;

	if (pNode->IsKindOf(RUNTIME_CLASS(CTVEvent)))
	{
		//this is a event node, alive event.grd file
		CTVEvent* pEvent = (CTVEvent*)pNode;
		if (!AliveGRDFile(pEvent))
			return FALSE;
	}
	else if ((pNode->m_emNodeType == emTypeSession)||(pNode->m_emNodeType == emTypeCourt))
	{
		//this is a session node or a court node,alive session.sts file if it does exist
		if (!AliveSTSFile(pNode))
			return FALSE;
	}

	// Export children Nodes
	int nChildNodeCount = pNode->GetChildNodesCount();
	for (int i=0; i < nChildNodeCount; i++)
	{
		CTVNodeBase *pChildNode = pNode->GetChildNode(i);

		if (!AliveFilesFromNode(pChildNode))
			return FALSE;
	}

	return TRUE;
}

//////////////////////////////////////////////////////////////////////////
//Thread Functions
BOOL CTVExportManger::CreateExportThread()
{
	if (m_pExportThread) 
		return TRUE;
	
	OutputMessage(_T("Creating export thread..."),emLogThread);

	m_pExportThread = AfxBeginThread(CTVExportManger::staticThreadProc, this);

	if (!m_pExportThread)
	{
		ASSERT(FALSE);
		OutputMessage(_T("Creating export thread failed!"),emLogThread);
		return FALSE;
	}
	ASSERT_VALID(m_pExportThread);

	return TRUE;
}

void CTVExportManger::DestroyExportThread()
{
	// Stop the thread
	if (m_pExportThread)
	{
		OutputMessage(_T("Stopping export thread..."),emLogThread);
		m_pExportThread->PostThreadMessage(WM_QUIT, 0, 0);
		WaitForSingleObject(m_pExportThread->m_hThread, 10000);
		m_pExportThread = NULL;
	}
}

UINT CTVExportManger::staticThreadProc(LPVOID pParam)
{
	CTVExportManger* pExportManager = (CTVExportManger*)pParam;
	return pExportManager->ThreadProc();
}

UINT CTVExportManger::ThreadProc()
{
	BOOL	bLastExportOk = TRUE;       // Indicate if last data export was Ok

	//create message queue
	MSG msg;
	ZeroMemory(&msg, sizeof(MSG));
	PeekMessage(&msg, NULL, WM_USER, WM_USER, PM_NOREMOVE);

	OutputMessage(_T("Export thread has been created"),emLogThread);

	CTVNodeBase* pNode = NULL;
	DWORD dwTickTimeOut = GetTickCount() + DEF_EXPORT_TIMEALIVE;
	DWORD dwTickNow;
	while (1)
	{
		dwTickNow = GetTickCount();		//get current time
		if (dwTickNow >= dwTickTimeOut)	//timeout occurs
		{
			m_pCSData->Lock();
			if(bLastExportOk)
			{
				// time to alive files
				AliveFilesFromNode(m_pRootDiscipline);
			} 
			else 
			{
				// try to export again
				bLastExportOk = ExportTree(m_pRootDiscipline);
			}
			m_pCSData->Unlock();
			// set new timeout time
			if(bLastExportOk)
				dwTickTimeOut = dwTickNow + DEF_EXPORT_TIMEALIVE;
			else
				dwTickTimeOut = dwTickNow + DEF_EXPORT_DELAYGLOBALRETRY;

			continue;
		}
		else	//no timeout occur, now we should check whether new msg comes
		{
			if (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)) // new msg
			{
				if (msg.message == WM_QUIT)
				{
					break;
				}
				else if (msg.message == MSG_EXPORT_NOTIFY)
				{
					m_pCSData->Lock();
					pNode = (CTVNodeBase*)msg.wParam;

					if (pNode)
						bLastExportOk = ExportTree(pNode);
					else
						bLastExportOk = ExportTree(m_pRootDiscipline);

					m_pCSData->Unlock();
				}
			}
			else // no msg
			{
				m_pEventQueueEmpty->SetEvent();
				Sleep(1);
			}
		}
	}

	OutputMessage(_T("Export thread has been stopped"),emLogThread);
	return 0;
}

void CTVExportManger::OutputMessage(CString strMsg,ELogType emLogType /* = emLogExportOk */)
{
	switch (emLogType)
	{
	case emLogExportOk:
		if (m_bOutputOkLog)
			g_Log.OutPutMsg(strMsg);
		break;
	case emLogExportError:
		if (m_bOutputErrorLog)
			g_Log.OutPutMsg(strMsg);
		break;
	case emLogAlive:
		if (m_bOutputAliveLog)
			g_Log.OutPutMsg(strMsg);
		break;
	case emLogThread:
		if (m_bOutputThreadLog)
			g_Log.OutPutMsg(strMsg);
		break;
	default:
		break;
	}
	
}