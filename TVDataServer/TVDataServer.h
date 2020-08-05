
// TVDataServer.h : PROJECT_NAME Ӧ�ó������ͷ�ļ�
//

#pragma once

#ifndef __AFXWIN_H__
	#error "�ڰ������ļ�֮ǰ������stdafx.h�������� PCH �ļ�"
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