/********************************************************************
created:	2010/01/07
filename: 	DataSpliter.cpp

author:		GRL
*********************************************************************/

#include "StdAfx.h"
#include "DataSpliter.h"

#define MAX_BUFFER_SIZE		0x500000 // 5MB
#define DEFAULT_BUFFER_SIZE	0x100000 // 1MB

#define WM_USER_RECV_DATA	WM_USER+ 555

CDataSpliter::CDataSpliter(void)
{
	m_lpBeginMark = NULL;
	m_lpEndMark = NULL;
	m_nBeginMarkSize = 0;
	m_nEndMarkSize = 0;
	m_bHasEndMark = TRUE;
	m_nFrameSize = 0;

	m_lpBuffer = NULL;
	m_nBufSzie = 0;
	m_lpDataBeginPos = NULL;
	m_lpDataEndPos = NULL;

	m_lpFrameBeginPos = NULL;
	m_lpProcessBeginPos = NULL;

	m_bNeedSplitMark = FALSE;
	m_pCallBackFunc = NULL;
	m_lpCallBackParm = NULL;
	m_hWndRecvMsg = NULL;
	m_nMsgID = 0;

	ZoomBuffer(DEFAULT_BUFFER_SIZE);

	m_pThread = NULL;
	m_hEventCanStart = NULL;
}

CDataSpliter::~CDataSpliter(void)
{
	DestroyWorkThread();
	RemoveSplitMark();
	DeleteBuffer();
}

BOOL CDataSpliter::ZoomBuffer(int nNewBufSize)
{
	ENTER_THREAD_SAFETY;

	if (nNewBufSize <= m_nBufSzie) return TRUE;

	LPBYTE lpNewBuff = new BYTE[nNewBufSize];
	if (!lpNewBuff) return FALSE;

	// Old data status
	int nDataSize = m_lpDataEndPos - m_lpDataBeginPos;
	int nFrameBeginOffset   = m_lpFrameBeginPos ? (m_lpFrameBeginPos-m_lpDataBeginPos) : -1;
	int nProcessBeginOffset = m_lpProcessBeginPos ? (m_lpFrameBeginPos-m_lpProcessBeginPos) : -1;

	if (m_lpBuffer) // zoom buffer
	{
		if ( nDataSize > 0)
		{
			memcpy(lpNewBuff, m_lpDataBeginPos, nDataSize);
		}
		delete []m_lpBuffer;
	}

	// Set new buffer info
	m_lpBuffer = lpNewBuff;
	m_nBufSzie = nNewBufSize;

	m_lpDataBeginPos = m_lpBuffer;
	m_lpDataEndPos = m_lpDataBeginPos + nDataSize;

	m_lpFrameBeginPos   = (nFrameBeginOffset<0) ? NULL: (m_lpDataBeginPos+nFrameBeginOffset);
	m_lpProcessBeginPos = (nProcessBeginOffset<0) ? NULL: (m_lpDataBeginPos+nProcessBeginOffset);

	return TRUE;
}

void CDataSpliter::ClearData()
{	
	ENTER_THREAD_SAFETY;

	m_lpDataBeginPos = m_lpBuffer;
	m_lpDataEndPos = m_lpDataBeginPos;

	m_lpFrameBeginPos = NULL;
	m_lpProcessBeginPos = NULL;
}
void CDataSpliter::DeleteBuffer()
{
	ENTER_THREAD_SAFETY;

	if (m_lpBuffer)
	{
		delete []m_lpBuffer;
		m_lpBuffer = NULL;
		m_nBufSzie = 0;

		ClearData();
	}
}
void CDataSpliter::ValidateBuffer(int nAddSize)
{
	ENTER_THREAD_SAFETY;

	int nHeadFreeSize = m_lpDataBeginPos - m_lpBuffer;
	int nTailFreeSize = m_nBufSzie - (m_lpDataEndPos - m_lpBuffer);

	if (nTailFreeSize < nAddSize)
	{
		if (nHeadFreeSize + nTailFreeSize > nAddSize) // Enough free space in buffer, 
		{
			MoveDataToBufferHead();
		}
		else // Not enough free space, 
		{
			int nNeedSize = m_nBufSzie + nAddSize;
			int nNewBufSize = nNeedSize + nNeedSize/2; // new buffer size is larger than really needed

			if (nNewBufSize > MAX_BUFFER_SIZE) 
			{
				AfxMessageBox(_T("Receiving buffer overflow, the previous data will be discarded!"));
				DeleteBuffer();
				nNewBufSize = MAX_BUFFER_SIZE;
			}

			ZoomBuffer(nNewBufSize);			
		}
	}
}

void CDataSpliter::MoveDataToBufferHead()
{
	ENTER_THREAD_SAFETY;

	int nDataSize = m_lpDataEndPos - m_lpDataBeginPos;
	int nDataOffset = m_lpDataBeginPos - m_lpBuffer;
	if (nDataSize > 0 && nDataOffset > 0)
	{
		memmove(m_lpBuffer, m_lpDataBeginPos, nDataSize);	
	}		

	// Reset data position pointer
	m_lpDataBeginPos = m_lpBuffer;
	m_lpDataEndPos = m_lpDataBeginPos + nDataSize;

	if (m_lpFrameBeginPos)
		m_lpFrameBeginPos -= nDataOffset;
	if (m_lpProcessBeginPos)
		m_lpProcessBeginPos -= nDataOffset;	
}

LPBYTE CDataSpliter::GetWritableBlock(int &nBlockSize)
{
	m_CriticalSection.Lock();

	int nTailFreeSize = m_nBufSzie - (m_lpDataEndPos - m_lpBuffer);
	if (nTailFreeSize < nBlockSize)
	{
		m_CriticalSection.Unlock();
		return NULL;
	}

	nBlockSize = nTailFreeSize;
	return m_lpDataEndPos;

}
void  CDataSpliter::SetWrittenBlock(LPBYTE lpBlockPos, int nBlockSize)
{
	if (lpBlockPos == m_lpDataEndPos)
	{
		m_lpDataEndPos += nBlockSize;
	}

	m_CriticalSection.Unlock();
}

long CDataSpliter::GetDataSize()
{
	return m_lpDataEndPos - m_lpDataBeginPos;
}

void CDataSpliter::RemoveSplitMark()
{
	if (m_lpBeginMark)
	{
		delete [] m_lpBeginMark;
		m_lpBeginMark = NULL;
	}
	if (m_lpEndMark)
	{
		delete [] m_lpEndMark;
		m_lpEndMark = NULL;
	}
}
void CDataSpliter::SetSplitMark(LPBYTE lpBeginMark, int nBeginMarkSize, LPBYTE lpEndMark, int nEndMarkSize)
{
	RemoveSplitMark();
	if (nBeginMarkSize > 0)
	{
		m_lpBeginMark = new BYTE[nBeginMarkSize];
		memcpy(m_lpBeginMark, lpBeginMark, nBeginMarkSize);
	}

	if (nEndMarkSize > 0)
	{
		m_lpEndMark = new BYTE[nEndMarkSize];
		memcpy(m_lpEndMark, lpEndMark, nEndMarkSize);
	}

	m_nBeginMarkSize = nBeginMarkSize;
	m_nEndMarkSize = nEndMarkSize;

	m_bHasEndMark = TRUE;
}
void CDataSpliter::SetSplitMark(LPBYTE lpBeginMark, int nBeginMarkSize, int nFrameSize)
{
	RemoveSplitMark();
	if (nBeginMarkSize > 0)
	{
		m_lpBeginMark = new BYTE[nBeginMarkSize];
		memcpy(m_lpBeginMark, lpBeginMark, nBeginMarkSize);
		m_nBeginMarkSize = nBeginMarkSize;
	}

	m_lpEndMark = NULL;
	m_nEndMarkSize = 0;
	m_bHasEndMark = FALSE;
	m_nFrameSize = nFrameSize;
}

void CDataSpliter::SetCallBack(SPLITERCALLBACK pCallBackFunc, LPVOID lpParam, BOOL bCreateBufferThread)
{
	if (pCallBackFunc)
	{
		m_pCallBackFunc = pCallBackFunc;
		m_lpCallBackParm = lpParam;

		if (bCreateBufferThread && !m_pThread)
		{
			CreateWorkThread();
		}
	}
}
void CDataSpliter::SetCallBack(HWND hWndRecvMsg, UINT nMsgID, BOOL bCreateBufferThread)
{
	if (::IsWindow(hWndRecvMsg))
	{
		m_hWndRecvMsg = hWndRecvMsg;
		m_nMsgID = nMsgID;

		if (bCreateBufferThread && !m_pThread)
		{
			CreateWorkThread();
		}
	}
}


BOOL CDataSpliter::IsBeginMark(LPBYTE lpCheckPos)
{
	ENTER_THREAD_SAFETY;

	// Check position too near to the End of valid data
	if (lpCheckPos + m_nBeginMarkSize > m_lpDataEndPos)
		return FALSE;

	return !memcmp(lpCheckPos, m_lpBeginMark, m_nBeginMarkSize);
}
BOOL CDataSpliter::IsEndMark(LPBYTE lpCheckPos)
{
	ENTER_THREAD_SAFETY;

	// Check position too near to the End of valid data
	if (lpCheckPos + m_nEndMarkSize > m_lpDataEndPos)
		return FALSE;

	return !memcmp(lpCheckPos, m_lpEndMark, m_nEndMarkSize);
}
BOOL CDataSpliter::IsSettingValid()
{
	// validate check
	if (!m_lpBeginMark || m_nBeginMarkSize<=0 )
	{
		AfxMessageBox(_T("DataSpliter Begin mark setting error!"));
	}
	else if (m_bHasEndMark && m_lpEndMark && m_nEndMarkSize<=0)
	{
		AfxMessageBox(_T("DataSpliter End mark setting error!"));
	}
	else if (!m_lpCallBackParm && !m_hWndRecvMsg)
	{
		AfxMessageBox(_T("DataSpliter Callback can not be NULL!"));
	}
	else
		return TRUE;

	return FALSE;
}

void CDataSpliter::FillData(LPBYTE lpData, int nSize)
{
	if (!lpData || nSize<=0)
		return;

	if (m_pThread  // Asynchronous
		&& WaitForSingleObject(m_pThread->m_hThread, 0) == WAIT_TIMEOUT // Thread is running
		&& WaitForSingleObject(m_hEventCanStart, 0) == WAIT_OBJECT_0 )  // Can receive Data
	{
		LPBYTE lpLocalData = new BYTE[nSize];
		if (!lpLocalData)
		{
			AfxMessageBox(_T("Heap overflow! program will exit!"));
			return;
		}

		memcpy(lpLocalData, lpData, nSize);

		m_pThread->PostThreadMessage(WM_USER_RECV_DATA, (WPARAM)lpLocalData, (LPARAM)nSize);
	}
	else // Synchronous
	{
		CacheReceiveData(lpData, nSize);
	}

}

void CDataSpliter::CacheReceiveData(LPBYTE lpData, int nSize)
{
	if (!IsSettingValid())
		return;

	ValidateBuffer(nSize);

	ENTER_THREAD_SAFETY;

	memcpy(m_lpDataEndPos, lpData, nSize); // Copy lpData to buffer
	m_lpDataEndPos += nSize;

	if (m_pThread && WaitForSingleObject(m_pThread->m_hThread, 0) == WAIT_TIMEOUT) // Asynchronous
		delete []lpData;

	ProcessData();
}

void CDataSpliter::ProcessData()
{
	ENTER_THREAD_SAFETY;

	if (m_bHasEndMark)
	{
		ProcessDataWithEnd();
	}
	else
	{
		ProcessDataNoEnd();
	}
}

void CDataSpliter::ProcessDataWithEnd()
{
	// Not enough valid data
	int nDataSize = GetDataSize();
	if (nDataSize < m_nBeginMarkSize && nDataSize < m_nEndMarkSize)
		return;

	LPBYTE lpCurPos = m_lpProcessBeginPos ? m_lpProcessBeginPos : m_lpDataBeginPos;
	while ( lpCurPos < m_lpDataEndPos )
	{
		if (!m_lpFrameBeginPos && IsBeginMark(lpCurPos)) // Has not received begin mark
		{				
			lpCurPos += m_nBeginMarkSize;			
			m_lpFrameBeginPos = lpCurPos;

			if (m_bNeedSplitMark)
				m_lpFrameBeginPos = lpCurPos - m_nBeginMarkSize;			
		}

		// Get 1 frame data
		if (m_lpFrameBeginPos && IsEndMark(lpCurPos)) // Has received begin mark
		{
			int nFrameSize = lpCurPos - m_lpFrameBeginPos;;

			if (m_bNeedSplitMark)
				nFrameSize = lpCurPos - m_lpFrameBeginPos + m_nEndMarkSize;

			if (nFrameSize > 0)
			{
				DoCallBackFunc(m_lpFrameBeginPos, nFrameSize);
			}

			// Record the processed position, and adjust the lpCurPos			
			lpCurPos += m_nEndMarkSize;
			m_lpDataBeginPos = lpCurPos;
			m_lpFrameBeginPos = NULL;
		}
		else 
			lpCurPos++;
	}

	nDataSize = GetDataSize();
	if (nDataSize == 0)
	{
		ClearData();
		return;
	}

	if (nDataSize < max(m_nBeginMarkSize, m_nEndMarkSize))
	{
		m_lpProcessBeginPos = NULL;
	}
	else
	{
		// Next time start from the m_lpProcessBeginPos
		m_lpProcessBeginPos = m_lpDataEndPos - max(m_nBeginMarkSize, m_nEndMarkSize);
	}

	// exclude the begin mark
	if (m_lpFrameBeginPos)
		m_lpDataBeginPos = m_lpFrameBeginPos;

}
void CDataSpliter::ProcessDataNoEnd()
{
	// Not enough valid data
	int nDataSize = m_lpDataEndPos - m_lpDataBeginPos;
	if (nDataSize < m_nBeginMarkSize)
		return;

	LPBYTE lpCurPos = m_lpProcessBeginPos ? m_lpProcessBeginPos : m_lpDataBeginPos;
	while ( lpCurPos < m_lpDataEndPos )
	{
		if (!m_lpFrameBeginPos && IsBeginMark(lpCurPos)) // Has not received begin mark
		{
			lpCurPos += m_nBeginMarkSize;
			m_lpFrameBeginPos = lpCurPos;

			if (m_bNeedSplitMark)
				m_lpFrameBeginPos = lpCurPos - m_nBeginMarkSize;	
		}

		// Get 1 frame data
		if (m_lpFrameBeginPos ) // Has received begin mark
		{
			if (m_nFrameSize > 0)
			{
				if ((m_lpDataEndPos-m_lpFrameBeginPos) >= m_nFrameSize) // Enough data in buffer
				{
					DoCallBackFunc(m_lpFrameBeginPos, m_nFrameSize);

					// Record the processed position, and adjust the lpCurPos			
					lpCurPos = m_lpFrameBeginPos + m_nFrameSize;
					m_lpDataBeginPos = lpCurPos;
					m_lpFrameBeginPos = NULL;
				}
				else
					break;
			}
			else if (IsBeginMark(lpCurPos)) // Find next begin mark
			{
				int nFrameSize = lpCurPos - m_lpFrameBeginPos;

				if (m_bNeedSplitMark)
					nFrameSize = lpCurPos - m_lpFrameBeginPos + m_nEndMarkSize;

				if (nFrameSize > 0)
				{
					DoCallBackFunc(m_lpFrameBeginPos, nFrameSize);
				}

				// Record the processed position, and adjust the lpCurPos
				m_lpDataBeginPos = lpCurPos;
				m_lpFrameBeginPos = NULL;
			}
			else
				lpCurPos++;
		}
		else 
			lpCurPos++;
	}

	nDataSize = GetDataSize();
	if (nDataSize == 0)
	{
		ClearData();
		return;
	}

	if (nDataSize < max(m_nBeginMarkSize, m_nEndMarkSize))
	{
		m_lpProcessBeginPos = NULL;
	}
	else
	{
		// Next time start from the m_lpProcessBeginPos
		m_lpProcessBeginPos = m_lpDataEndPos - max(m_nBeginMarkSize, m_nEndMarkSize);
	}

	// exclude the begin mark
	if (m_lpFrameBeginPos)
		m_lpDataBeginPos = m_lpFrameBeginPos;

}

void CDataSpliter::DoCallBackFunc(LPBYTE lpFrameSrc, int nFrameSize)
{
	// Process frame
	if (m_hWndRecvMsg) // Asynchronous, need delete lpFrame in Message process function
	{	
		LPBYTE lpFrame = new BYTE[nFrameSize];
		memcpy(lpFrame, lpFrameSrc, nFrameSize);

		PostMessage(m_hWndRecvMsg, m_nMsgID, (WPARAM)lpFrame, (LPARAM)nFrameSize);
	}
	else if (m_pCallBackFunc) // synchronous
	{
		m_pCallBackFunc(lpFrameSrc, nFrameSize, m_lpCallBackParm);
	}
}

//////////////////////////////////////////////////////////////////////////
// Thread control function
//////////////////////////////////////////////////////////////////////////

void CDataSpliter::DestroyWorkThread()
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

		m_pThread = NULL;
	}
}

BOOL CDataSpliter::CreateWorkThread()
{
	if (m_pThread) return TRUE;

	m_hEventCanStart = CreateEvent(NULL, TRUE, FALSE, NULL);
	if (!m_hEventCanStart)
		return FALSE;

	m_pThread = AfxBeginThread(CDataSpliter::ThreadProc, this);
	if (!m_pThread)
		return FALSE;

	// Waiting for the work thread can receive data, not block the main thread windows message
	while (TRUE)
	{
		DWORD dwResult = MsgWaitForMultipleObjects(1, &m_hEventCanStart, FALSE, INFINITE, QS_ALLINPUT);
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

UINT CDataSpliter::ThreadProc(LPVOID pParam)
{
	MSG msg;
	ZeroMemory(&msg, sizeof(MSG));

	PeekMessage(&msg, NULL, WM_USER, WM_USER, PM_NOREMOVE);

	CDataSpliter *pSpliter = (CDataSpliter *)pParam;

	SetEvent(pSpliter->m_hEventCanStart); // Can receive Message

	BOOL bRet;
	while( (bRet = GetMessage( &msg, NULL, 0, 0 )) != 0)
	{ 
		if (bRet == -1) // Error occur
		{
			break;
		}
		else 
		{
			if (msg.message == WM_USER_RECV_DATA)
			{
				if (pSpliter->m_lpBuffer)
				{
					pSpliter->CacheReceiveData((LPBYTE)msg.wParam, (int)msg.lParam);
				}				
			}

			TranslateMessage(&msg); 
			DispatchMessage(&msg);
		}
	}	

	ResetEvent(pSpliter->m_hEventCanStart);

	return 1;
}
