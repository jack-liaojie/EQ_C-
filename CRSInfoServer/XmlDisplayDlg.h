
#pragma once
#include "stdafx.h"

#ifdef _WIN32_WCE
#error "CHtmlView is not supported for Windows CE."
#endif 

// CHtmlCtrl html view
class CHtmlCtrl : public CHtmlView
{
public:
	CHtmlCtrl(){};   
	virtual ~CHtmlCtrl(){};

	virtual void PostNcDestroy(){};
};

// CXmlDisplayDlg dialog

class CXmlDisplayDlg : public CDialog
{
	DECLARE_DYNAMIC(CXmlDisplayDlg)

public:
	CXmlDisplayDlg(CString strXmlFile);   // standard constructor
	virtual ~CXmlDisplayDlg();

// Dialog Data
	enum { IDD = IDD_DLG_XML_DISP };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	afx_msg void OnDestroy();
	afx_msg void OnSize(UINT nType, int cx, int cy);
	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();

	CHtmlCtrl m_HtmlView;
	CString   m_strXmlFile;

};
