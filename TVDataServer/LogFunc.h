#pragma once

class CLogFunc
{
public:
	CLogFunc(void);
	~CLogFunc(void);

public:
	BOOL StartLogService(CEdit *pEdit); // Set pCEdit control for display the message; If pCEdit==NULL, logs will only be stored in logfile
	void StopLogService() { DestroyWorkThread(); } 
	void OutPutMsg(CString strMsg);

	BOOL SetLogFile(CString strFilePath, BOOL bTruncate = TRUE); 

private:
	CString m_strFileName;
	CFile	m_LogFile;

	// Record the origin EditControl information
	CRect	m_Edit_Rect;
	CWnd*	m_Edit_ParentWnd;
	UINT	m_Edit_ID;
	CFont*	m_Edit_Font;
	DWORD	m_Edit_Style;
	DWORD	m_Edit_ExStyle;

	CEdit 	m_Edit;
	CCriticalSection m_CriticalSection;

	LRESULT OnAddMsg(WPARAM wParam, LPARAM lParam);

protected:
	virtual CString FormatLogMsg(CString strMsg);

	//////////////////////////////////////////////////////////////////////////
	// Work thread control
private:
	CWinThread* m_pThread;
	HANDLE m_hEventCanStart; // Indicate the work thread can start send WM_USER_ADD_MSG message

	BOOL CreateWorkThread();
	void DestroyWorkThread();
	static UINT ThreadProc(LPVOID pParam);
};

extern CLogFunc	g_Log;