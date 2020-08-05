
// CRSInfoServer.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "CRSInfoServer.h"
#include "CRSInfoServerDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

CCRSInfoServerApp	theApp;

CTopicManager		g_TopicManager;

BEGIN_MESSAGE_MAP(CCRSInfoServerApp, CWinAppEx)
	ON_COMMAND(ID_HELP, OnHelp)
END_MESSAGE_MAP()

CCRSInfoServerApp::CCRSInfoServerApp()
{
}

BOOL CCRSInfoServerApp::InitInstance()
{
	// InitCommonControlsEx() is required on Windows XP if an application
	// manifest specifies use of ComCtl32.dll version 6 or later to enable
	// visual styles.  Otherwise, any window creation will fail.
	INITCOMMONCONTROLSEX InitCtrls;
	InitCtrls.dwSize = sizeof(InitCtrls);
	// Set this to include all the common control classes you want to use
	// in your application.
	InitCtrls.dwICC = ICC_WIN95_CLASSES;
	InitCommonControlsEx(&InitCtrls);

	CWinAppEx::InitInstance();

	if (!AfxSocketInit())
	{
		AfxMessageBox(IDP_SOCKETS_INIT_FAILED);
		return FALSE;
	}

	AfxEnableControlContainer();

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	// of your final executable, you should remove from the following
	// the specific initialization routines you do not need
	// Change the registry key under which our settings are stored
	// TODO: You should modify this string to be something appropriate
	// such as the name of your company or organization
	SetRegistryKey(_T("CSIC Info DataFeed Server"));

	if( !DoSystemSetup(GetDataBase(), m_strDisciplineCode))
		return FALSE;

	CCRSInfoServerDlg dlg;
	m_pMainWnd = &dlg;
	INT_PTR nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
	}
	else if (nResponse == IDCANCEL)
	{
	}

	return FALSE;
}

CAxADODataBase* CCRSInfoServerApp::GetDataBase()
{
	// Check validation
	try
	{
		if (m_obDataBase.IsOpen())
		{
			CAxADORecordSet TestConnection(&m_obDataBase);
			if (TestConnection.Open(_T("SELECT @@Version")))
				return &m_obDataBase;
		}
	}
	catch (CAxADOException &e)
	{
	}
	catch (...)
	{
	}

	// Reconnect to the database
	try
	{
		m_obDataBase.Open(m_obDataBase.GetConnectionString());
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(_T("Database can not be connected! Please check the Network and Database server!"));
		return NULL;
	}
	catch (...)
	{
		return NULL;
	}

	return &m_obDataBase;

}

BOOL DFSFillGridCtrl(CAsCoolGridCtrl* pGridCtrl, SAxTableRecordSet& rsTable, BOOL bRowNum)
{
	LOGFONT lf;
	GetObject(GetStockObject(SYSTEM_FONT), sizeof(LOGFONT), &lf);

	pGridCtrl->SetRowCount(rsTable.GetRowRecordsCount() + 1);
	pGridCtrl->SetColumnCount(rsTable.GetFieldsCount() + 1);
	pGridCtrl->SetFixedRowCount();
	pGridCtrl->SetFixedColumnCount();

	for( int iFieldIdx = 0; iFieldIdx < rsTable.GetFieldsCount(); iFieldIdx++ )
	{
		pGridCtrl->SetItemText(0, iFieldIdx+1, rsTable.GetFieldName(iFieldIdx));
		pGridCtrl->SetRowHeight(0, 23);

		pGridCtrl->SetItemFont(0, iFieldIdx+1, &lf);
	}

	for( int iRowIdx = 0; iRowIdx < rsTable.GetRowRecordsCount(); iRowIdx++ )
	{
		for( int iFieldIdx = 0; iFieldIdx < rsTable.GetFieldsCount(); iFieldIdx++ )
		{
			pGridCtrl->SetItemText(iRowIdx + 1, iFieldIdx+1, rsTable.GetValue(iFieldIdx, iRowIdx));		
		}
		// Row Number
		pGridCtrl->SetItemText(iRowIdx + 1, 0, AxCommonInt2String(iRowIdx+1));	

		if( iRowIdx % 2  == 1)
			pGridCtrl->SetRowBkColor(iRowIdx + 1, GRID_EVEN_ROW_COLOR);	
		else
			pGridCtrl->SetRowBkColor(iRowIdx + 1, GRID_ODD_ROW_COLOR);	

	}

	pGridCtrl->AutoSizeColumns();
	pGridCtrl->ExpandLastColumn();
	pGridCtrl->Refresh();

	return TRUE;
}
