// OVRCommon.cpp : Defines the initialization routines for the DLL.
//

#include "stdafx.h"
#include <afxdllx.h>
#include "AsianGamesCommonInit.h"
#include "SystemSetupDlg.h"


#ifdef _MANAGED
#error Please read instructions in OVRCommon.cpp to compile with /clr
// If you want to add /clr to your project you must do the following:
//	1. Remove the above include for afxdllx.h
//	2. Add a .cpp file to your project that does not have /clr thrown and has
//	   Precompiled headers disabled, with the following text:
//			#include <afxwin.h>
//			#include <afxdllx.h>
#endif

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


static AFX_EXTENSION_MODULE OVRCommonDLL = { NULL, NULL };

#ifdef _MANAGED
#pragma managed(push, off)
#endif

extern "C" int APIENTRY
DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID lpReserved)
{
	// Remove this if you use lpReserved
	UNREFERENCED_PARAMETER(lpReserved);

	if (dwReason == DLL_PROCESS_ATTACH)
	{
		TRACE0("OVRCommon.DLL Initializing!\n");
		
		// Extension DLL one-time initialization
		if (!AfxInitExtensionModule(OVRCommonDLL, hInstance))
			return 0;

		// Insert this DLL into the resource chain
		// NOTE: If this Extension DLL is being implicitly linked to by
		//  an MFC Regular DLL (such as an ActiveX Control)
		//  instead of an MFC application, then you will want to
		//  remove this line from DllMain and put it in a separate
		//  function exported from this Extension DLL.  The Regular DLL
		//  that uses this Extension DLL should then explicitly call that
		//  function to initialize this Extension DLL.  Otherwise,
		//  the CDynLinkLibrary object will not be attached to the
		//  Regular DLL's resource chain, and serious problems will
		//  result.

		new CDynLinkLibrary(OVRCommonDLL);

	}
	else if (dwReason == DLL_PROCESS_DETACH)
	{
		TRACE0("OVRCommon.DLL Terminating!\n");

		// Terminate the library before destructors are called
		AfxTermExtensionModule(OVRCommonDLL);
	}
	return 1;   // ok
}

HINSTANCE AxOVRCommonGetThisModule()
{
	return (HINSTANCE)OVRCommonDLL.hModule;
}

BOOL DoSystemSetup(CAxADODataBase *pDataBase, OUT CString &strDisciplineCode)
{
	if (!pDataBase) return FALSE;

	CSystemSetupDlg SystemSetupDlg(pDataBase);
	SystemSetupDlg.m_strAppConfigFile = CAxReadWriteINI::GetAppConfigFile();

	// Switch module environment
	HINSTANCE hOld = AfxGetResourceHandle();
	AfxSetResourceHandle(AxOVRCommonGetThisModule());
	int iRet = SystemSetupDlg.DoModal();		
	AfxSetResourceHandle( hOld );

	if( iRet == IDOK)
	{
		strDisciplineCode = SystemSetupDlg.m_strDisciplineCode;
		return TRUE;
	}

	return FALSE;
}


#ifdef _MANAGED
#pragma managed(pop)
#endif

