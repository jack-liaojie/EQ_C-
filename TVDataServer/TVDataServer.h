
// TVDataServer.h : PROJECT_NAME 应用程序的主头文件
//

#pragma once

#ifndef __AFXWIN_H__
	#error "在包含此文件之前包含“stdafx.h”以生成 PCH 文件"
#endif

#include "resource.h"
#include "TVDataManager.h"

class CTVDataServerApp : public CWinAppEx
{
public:
	CTVDataServerApp();

	public:
	virtual BOOL InitInstance();

	DECLARE_MESSAGE_MAP()

private:
	CAxADODataBase m_obDataBase;
	CString m_strDisciplineCode;
	CString m_strConnectString;

public:
	CAxADODataBase* GetDataBase();
	inline CString GetDisciplineCode() { return m_strDisciplineCode;}

	inline CString GetConnectString() { return m_strConnectString;}
};

extern CTVDataServerApp theApp;