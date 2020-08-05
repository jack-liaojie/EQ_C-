
// InitialDownLoad.h : PROJECT_NAME 应用程序的主头文件
//

#pragma once

#ifndef __AFXWIN_H__
	#error "在包含此文件之前包含“stdafx.h”以生成 PCH 文件"
#endif

#include "resource.h"		// 主符号


// CInitialDownLoadApp:
// 有关此类的实现，请参阅 InitialDownLoad.cpp
//

class CInitialDownLoadApp : public CWinApp
{
public:
	CInitialDownLoadApp();

// 重写
public:
	virtual BOOL InitInstance();

private:
	CAxADODataBase m_obDataBase;
	CString m_strDisciplineCode;

public:
	CAxADODataBase* GetDataBase();
	CString GetDisciplineCode() { return m_strDisciplineCode;}

// 实现

	DECLARE_MESSAGE_MAP()
};

extern CInitialDownLoadApp theApp;