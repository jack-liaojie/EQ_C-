
// InfoDataFeedServer.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols
#include "LogFunc.h"
#include "DFSTopicManager.h"
//#include "MSLDataFeedProvider.h"

class CCRSInfoServerApp : public CWinAppEx
{
public:
	CCRSInfoServerApp();

// Overrides
public:
	virtual BOOL InitInstance();

// Implementation
	DECLARE_MESSAGE_MAP()
private:
	CAxADODataBase m_obDataBase;
	CString m_strDisciplineCode;
public:
	CAxADODataBase* GetDataBase();
	CString GetDisciplineCode() { return m_strDisciplineCode;}
};

extern CCRSInfoServerApp		theApp;
extern CTopicManager			g_TopicManager;

BOOL DFSFillGridCtrl(CAsCoolGridCtrl* pGridCtrl, SAxTableRecordSet& rsTable, BOOL bRowNum = TRUE);
