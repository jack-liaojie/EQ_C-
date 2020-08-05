#include "StdAfx.h"
#include "LogFunc.h"

#define MAX_MSG_LINE_COUNT			500
#define WM_USER_ADD_MSG	WM_USER+	500

CLogFunc g_Log;

CLogFunc::CLogFunc(void)
{
	m_Edit_ParentWnd = NULL;
	m_Edit_ID = 0;
	m_Edit_Font = NULL;
	m_Edit_Style = 0;
	m_Edit_ExStyle = 0;

	m_pThread = NULL;
	m_hEventCanStart = NULL;
}

CLogFunc::~CLogFunc(void)
{
	DestroyWorkThread();
}

BOOL CLogFunc::StartLogService(CEdit *pEdit)
{
	if (m_strFileName.IsEmpty())
	{
		CString strModulePath = CAxReadWriteINI::GetAppModulePath();
		m_strFileName = strModulePath.TrimRight(_T('\\')) + _T('\\') + AfxGetAppName() + _T(".log");

		SetLogFile(m_strFileName);
	}

	// Destroy the Edit control in UI thread, and then create another in the log thread
	if (pEdit && ::IsWindow(pEdit->GetSafeHwnd())) 
	{		
		if (m_Edit.SubclassWindow(pEdit->GetSafeHwnd()))
		{
			// Get Edit window info
			m_Edit_ParentWnd = m_Edit.GetParent();
			m_Edit.GetWindowRect(m_Edit_Rect);
			m_Edit_ParentWnd->ScreenToClient(m_Edit_Rect);
			m_Edit_ID = m_Edit.GetDlgCtrlID();
			m_Edit_Font = m_Edit.GetFont();
			m_Edit_Style = m_Edit.GetStyle();
			m_Edit_ExStyle = m_Edit.GetExStyle();

			m_Edit.DestroyWindow();
		}
	}

	if (CreateWorkThread())
	{
		return TRUE;
	}

	return FALSE;
}

BOOL CLogFunc::SetLogFile(CString strFilePath, BOOL bTruncate)
{
	UINT nOpenFlag;
	if (bTruncate)
		nOpenFlag = CFile::modeCreate|CFile::modeReadWrite|CFile::shareDenyNone;
	else
		nOpenFlag = CFile::modeCreate|CFile::modeNoTruncate|CFile::modeReadWrite|CFile::shareDenyNone;

	if (m_LogFile.Open(strFilePath, nOpenFlag))
	{
		return TRUE;
	}
	return FALSE;
}

void CLogFunc::OutPutMsg(CString strMsg)
{
	if (strMsg.IsEmpty()) return;

	if (m_pThread 
		&& WaitForSingleObject(m_pThread->m_hThread, 0) == WAIT_TIMEOUT // Thread is running
		&& WaitForSingleObject(m_hEventCanStart, 0) == WAIT_OBJECT_0 )  // Can receive log message
	{		
		CString *pstrMsg = new CString(strMsg);
		m_pThread->PostThreadMessage(WM_USER_ADD_MSG, (WPARAM)pstrMsg, (LPARAM)this);
	}
	//else // Use the calling thread to process
	//{
	//	OnAddMsg((WPARAM)pstrMsg, (LPARAM)this);
	//}
}

CString CLogFunc::FormatLogMsg(CString strMsg)
{
	CString strFmtMsg;

	SYSTEMTIME tm;
	GetLocalTime(&tm);

	strFmtMsg.Format(_T("[%02d:%02d:%02d.%03d] : "), tm.wHour, tm.wMinute, tm.wSecond, tm.wMilliseconds);

	strFmtMsg += strMsg + _T("\r\n");

	return strFmtMsg;
}

LRESULT CLogFunc::OnAddMsg(WPARAM wParam, LPARAM lParam)
{
	m_CriticalSection.Lock();

	CString* pstrMsg = (CString*)wParam;

	CString strFormatedMsg = FormatLogMsg(*pstrMsg);
	delete pstrMsg;

	// Output to window	
	CString strEditTxt;
	if (::IsWindow(m_Edit.GetSafeHwnd())) 
	{
		int nLineCount = m_Edit.GetLineCount();
		if (nLineCount > MAX_MSG_LINE_COUNT || nLineCount == 1)
			m_Edit.GetSafeHwnd() ? m_Edit.SetWindowText(_T("\n")) : NULL;
		else
			m_Edit.GetSafeHwnd() ? m_Edit.GetWindowText(strEditTxt) : NULL;

		int nTextLen = strEditTxt.GetLength() -1;
		m_Edit.GetSafeHwnd() ? m_Edit.SetSel(nTextLen, nTextLen) : NULL;
		m_Edit.GetSafeHwnd() ? m_Edit.ReplaceSel(strFormatedMsg, FALSE) : NULL;
	}

	// Output to LogFile
	CStringA cMsg(strFormatedMsg);
	m_LogFile.SeekToEnd();
	m_LogFile.Write(cMsg.GetBuffer(0), cMsg.GetLength());

	m_CriticalSection.Unlock();

	return 1;
}

//////////////////////////////////////////////////////////////////////////
// Thread control
void CLogFunc::DestroyWorkThread()
{
	if (m_pThread && WaitForSingleObject(m_pThread->m_hThread, 0) == WAIT_TIMEOUT) // Thread is running
	{
		m_pThread->PostThreadMessage(WM_QUIT, 0, 0);

		// Wait for thread exit, not block the main thread Windows message
		while (TRUE)
		{		
			DWORD dwResult = MsgWaitForMultipleObjects(1, &(m_pThread->m_hThread), FALSE, 5000, QS_ALLINPUT);
			if (dwResult == WAIT_OBJECT_0 + 1)
			{
				MSG msg;
				if(PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))     
				{     
					TranslateMessage(&msg);
					DispatchMessage(&msg);
				}
			}
			else if (dwResult == -1) // Error occur, error=6, Thread handle is invalid (work thread has exited)
			{
				break;
			}
			else if (dwResult == WAIT_TIMEOUT)
			{
				::TerminateThread(m_pThread->m_hThread, 0); // Force the thread exit
				break;
			}
			else if (dwResult == WAIT_OBJECT_0)
			{
				break;
			}
		}

		if (m_hEventCanStart)
		{
			CloseHandle(m_hEventCanStart);
			m_hEventCanStart = NULL;
		}

		if (m_LogFile.m_hFile != INVALID_HANDLE_VALUE)
		{
			m_LogFile.Flush();
			m_LogFile.Close();
		}

		m_pThread = NULL;
	}
}

BOOL CLogFunc::CreateWorkThread()
{
	if (m_pThread) return TRUE;

	m_hEventCanStart = CreateEvent(NULL, TRUE, FALSE, NULL);
	if (!m_hEventCanStart)
		return FALSE;

	m_pThread = AfxBeginThread(CLogFunc::ThreadProc, this);
	if (!m_pThread)
		return FALSE;

	// Waiting for the work thread can receive data, not block the main thread windows message
	while (TRUE)
	{
		DWORD dwResult = MsgWaitForMultipleObjects(1, &m_hEventCanStart, FALSE, 5000, QS_ALLINPUT);
		if (dwResult == WAIT_OBJECT_0)
		{
			return TRUE;
		}
		else if (dwResult == -1) // Error occur
		{
			return FALSE;
		}
		else
		{
			MSG msg;
			if(PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))     
			{     
				TranslateMessage(&msg);
				DispatchMessage(&msg);
			}
		}
	}
}

UINT CLogFunc::ThreadProc(LPVOID pParam)
{
	MSG msg;
	ZeroMemory(&msg, sizeof(MSG));
	PeekMessage(&msg, NULL, WM_USER, WM_USER, PM_NOREMOVE);

	CLogFunc *pLogFunc = (CLogFunc *)pParam;

	// If need to create an Edit control in the log working thread
	if (pLogFunc->m_Edit_ParentWnd && pLogFunc->m_Edit_ID != 0)
	{
		if (pLogFunc->m_Edit.Create(pLogFunc->m_Edit_Style | pLogFunc->m_Edit_ExStyle, 
			pLogFunc->m_Edit_Rect, pLogFunc->m_Edit_ParentWnd, pLogFunc->m_Edit_ID))
		{
			pLogFunc->m_Edit.SetFont(pLogFunc->m_Edit_Font);
			pLogFunc->m_Edit.ModifyStyleEx(0, pLogFunc->m_Edit_Style | pLogFunc->m_Edit_ExStyle, SWP_DRAWFRAME);
			pLogFunc->m_Edit.SetLimitText(0);
		}
	}

	SetEvent(pLogFunc->m_hEventCanStart); // Can receive Message

	BOOL bRet;
	while( (bRet=GetMessage(&msg, NULL, 0, 0)) != 0)
	{ 
		if (bRet == -1) // Error occur
		{
			break;
		}
		else 
		{
			if (msg.message == WM_USER_ADD_MSG)
			{
				if (::IsWindow(pLogFunc->m_Edit.GetSafeHwnd()))
				{
					pLogFunc->OnAddMsg(msg.wParam, msg.lParam);
				}
				continue;
			}
			else if (msg.message == WM_KEYDOWN)
			{
				if ( msg.wParam=='A' && GetKeyState(VK_CONTROL)<0 ) 
				{ 
					// User pressed Ctrl-A.  Let's select-all 
					CWnd * pFocusWnd = CWnd::GetFocus(); 
					if ( pFocusWnd && pLogFunc->m_Edit.GetSafeHwnd() == pFocusWnd->GetSafeHwnd() ) 
						pLogFunc->m_Edit.SetSel(0,-1); 
				}
			}

			TranslateMessage(&msg); 
			DispatchMessage(&msg);
		}
	}	

	ResetEvent(pLogFunc->m_hEventCanStart);

	return 1;
}
