
// TVDataServer.cpp : 定义应用程序的类行为。
//

#include "stdafx.h"
#include "TVDataServer.h"
#include "TVDataServerDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CTVDataServerApp

BEGIN_MESSAGE_MAP(CTVDataServerApp, CWinAppEx)
	ON_COMMAND(ID_HELP, &CWinApp::OnHelp)
END_MESSAGE_MAP()

CTVDataServerApp::CTVDataServerApp()
{

}

CTVDataServerApp theApp;

BOOL CTVDataServerApp::InitInstance()
{
	INITCOMMONCONTROLSEX InitCtrls;
	InitCtrls.dwSize = sizeof(InitCtrls);
	InitCtrls.dwICC = ICC_WIN95_CLASSES;
	InitCommonControlsEx(&InitCtrls);

	CWinAppEx::InitInstance();

	if (!AfxSocketInit())
	{
		AfxMessageBox(_T("Windows sockets initialization failed."));
		return FALSE;
	}

	AfxEnableControlContainer();

	SetRegistryKey(_T("TV Data Server"));

	if( !DoSystemSetup(GetDataBase(), m_strDisciplineCode))
		return FALSE;

	m_strConnectString = m_obDataBase.GetConnectionString();

	CTVDataServerDlg dlg;
	m_pMainWnd = &dlg;
	INT_PTR nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
	}
	else if (nResponse == IDCANCEL)
	{
	}

	if (m_obDataBase.IsOpen())
	{
		m_obDataBase.Close();
	}

	return FALSE;
}

CAxADODataBase* CTVDataServerApp::GetDataBase()
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
	}
	catch (...)
	{
		return NULL;
	}

	return &m_obDataBase;
}
