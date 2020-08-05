// XmlDisplayDlg.cpp : implementation file
//

#include "stdafx.h"
#include "CRSInfoServer.h"
#include "XmlDisplayDlg.h"

// CXmlDisplayDlg dialog

IMPLEMENT_DYNAMIC(CXmlDisplayDlg, CDialog)

CXmlDisplayDlg::CXmlDisplayDlg(CString strXmlFile)
:CDialog(IDD),m_strXmlFile(strXmlFile)
{
	
}

CXmlDisplayDlg::~CXmlDisplayDlg()
{
}

void CXmlDisplayDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CXmlDisplayDlg, CDialog)
	ON_WM_DESTROY()
	ON_WM_SIZE()
END_MESSAGE_MAP()


// CXmlDisplayDlg message handlers

BOOL CXmlDisplayDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	CRect	rcClient;
	GetClientRect(rcClient);

 	if (m_HtmlView.Create(NULL, NULL, (WS_CHILD | WS_VISIBLE|WS_VSCROLL|WS_HSCROLL), rcClient, this, 0x1234, NULL))
 	{
 		m_HtmlView.Navigate(m_strXmlFile);
 	}	

	return TRUE;  // return TRUE unless you set the focus to a control
}

void CXmlDisplayDlg::OnDestroy()
{
	m_HtmlView.CloseWindow();

	CDialog::OnDestroy();
}

void CXmlDisplayDlg::OnSize(UINT nType, int cx, int cy)
{
	CDialog::OnSize(nType, cx, cy);

	if (m_HtmlView.GetSafeHwnd())
	{
		CRect	rcClient;
		GetClientRect(rcClient);

		m_HtmlView.MoveWindow(rcClient);
	}

}
