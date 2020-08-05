#if _MSC_VER > 1000
#pragma once
#endif 

#include "stdafx.h"
#include "Resource.h"

class CSystemSetupDlg : public CDialog
{
public:
	CSystemSetupDlg(CAxADODataBase *pDataBase, CWnd* pParent = NULL);
	virtual ~CSystemSetupDlg();

protected:
	virtual void OnOK();
	virtual BOOL OnInitDialog();
	virtual void DoDataExchange(CDataExchange* pDX);
	afx_msg void OnDestroy();
	afx_msg void OnBtnTest();
	afx_msg void OnBtnDBSetup();

	enum{IDD = IDD_DLG_DB_SETUP};

	DECLARE_MESSAGE_MAP()

public:
	CString m_strDisciplineCode;
	CString m_strAppConfigFile;

private:
	BOOL	m_bNotEncrypte;

 	CString m_strServer;
 	CString m_strDatabase;
 	CString m_strUser;
 	CString m_strPassword;

	CFont m_ftDisciplineCode;
	CBrush m_brDlgBkColor;

	CAxADODataBase *m_pDataBase;
public:
	void ReadConfig();
	void WriteConfig();
};