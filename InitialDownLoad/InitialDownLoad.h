
// InitialDownLoad.h : PROJECT_NAME Ӧ�ó������ͷ�ļ�
//

#pragma once

#ifndef __AFXWIN_H__
	#error "�ڰ������ļ�֮ǰ������stdafx.h�������� PCH �ļ�"
#endif

#include "resource.h"		// ������


// CInitialDownLoadApp:
// �йش����ʵ�֣������ InitialDownLoad.cpp
//

class CInitialDownLoadApp : public CWinApp
{
public:
	CInitialDownLoadApp();

// ��д
public:
	virtual BOOL InitInstance();

private:
	CAxADODataBase m_obDataBase;
	CString m_strDisciplineCode;

public:
	CAxADODataBase* GetDataBase();
	CString GetDisciplineCode() { return m_strDisciplineCode;}

// ʵ��

	DECLARE_MESSAGE_MAP()
};

extern CInitialDownLoadApp theApp;