// TopicUpdateSettingDlg.cpp : implementation file
//

#include "stdafx.h"
#include "CRSInfoServer.h"
#include "CRSInfoServerDlg.h"
#include "TopicUpdateSettingDlg.h"
#include "NotifySettingDlg.h"


// CTopicUpdateSettingDlg dialog
#define IDC_GRID_NOTIFYMAP		15000

#define WM_USER_RECV_FRAME		WM_USER + 100
#define WM_USER_PROCESS_NOTIFY	WM_USER + 200

IMPLEMENT_DYNAMIC(CTopicUpdateSettingDlg, CDialog)

CTopicUpdateSettingDlg::CTopicUpdateSettingDlg()
	: CDialog(CTopicUpdateSettingDlg::IDD)
{
	m_pParent = NULL;

	m_bAdministrator = FALSE;
}

CTopicUpdateSettingDlg::~CTopicUpdateSettingDlg()
{
}

void CTopicUpdateSettingDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CTopicUpdateSettingDlg, CDialog)

	ON_BN_CLICKED(IDOK, OnOk)
	ON_WM_SHOWWINDOW()
	ON_WM_DESTROY()
	ON_MESSAGE(WM_USER_RECV_FRAME, OnFrameReceive)

	ON_BN_CLICKED(IDC_BTN_NOTIFY_MODIFY, OnBtnNotifyModify)
	ON_BN_CLICKED(IDC_BTN_NOTIFY_ADD, OnBtnNotifyAdd)
	ON_BN_CLICKED(IDC_BTN_NOTIFY_DEL, OnBtnNotifyDel)
END_MESSAGE_MAP()


// CTopicUpdateSettingDlg message handlers

BOOL CTopicUpdateSettingDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	m_XmlReceiver.SetRecvWndAndMsg(this, WM_USER_RECV_FRAME);

	m_hIconNetOk = LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDI_CONNECTED));
	m_hIconNetBroken = LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDI_DISCONNECTED));
	SetNetStateIcon(FALSE);

	m_NotifyManager.ReadConfig();
	SetIPAndPort(m_strServerPort, m_strServerIP);

	return TRUE;  
}

void CTopicUpdateSettingDlg::OnShowWindow(BOOL bShow, UINT nStatus)
{
	CDialog::OnShowWindow(bShow, nStatus);
	
	m_NotifyManager.ReadConfig();
	FillNotifyMapGrid();

	if (!m_bAdministrator)
	{
		GetDlgItem(IDC_BTN_NOTIFY_ADD)->EnableWindow(FALSE);
		GetDlgItem(IDC_BTN_NOTIFY_MODIFY)->EnableWindow(FALSE);
		GetDlgItem(IDC_BTN_NOTIFY_DEL)->EnableWindow(FALSE);
	}

	SetIPAndPort(m_strServerPort, m_strServerIP);
}

void CTopicUpdateSettingDlg::FillNotifyMapGrid()
{
	if (!::IsWindow(m_gridNotifyMap.GetSafeHwnd()))
	{
		CRect rcGrid;
		GetClientRect(rcGrid);
		rcGrid.top += 5;
		rcGrid.bottom -= 36;
		rcGrid.right -= 5;
		rcGrid.left += 5;

		if (!m_gridNotifyMap.Create(rcGrid, this, IDC_GRID_NOTIFYMAP))
			return;
	}
	
	int nTypesCount = m_NotifyManager.GetCount();

	m_gridNotifyMap.SetColumnCount(2);
	m_gridNotifyMap.SetRowCount(nTypesCount+1);
	m_gridNotifyMap.SetFixedRowCount();
	m_gridNotifyMap.SetItemText(0, 0, _T("NotifyType"));
	m_gridNotifyMap.SetItemText(0, 1, _T("Map MsgKeys"));
	m_gridNotifyMap.SetEditable(FALSE);
	m_gridNotifyMap.SetListMode();
	m_gridNotifyMap.SetFixedColumnSelection(FALSE);

	for (int i=0; i < nTypesCount; i++)
	{
		m_gridNotifyMap.SetItemText(i+1, 0, m_NotifyManager.GetTypeAt(i));
		m_gridNotifyMap.SetItemText(i+1, 1, m_NotifyManager.GetValuesAt(i));
	}
	
	m_gridNotifyMap.AutoSizeColumns();
	m_gridNotifyMap.ExpandLastColumn();
	m_gridNotifyMap.Refresh();
}

void CTopicUpdateSettingDlg::OnOk()
{
	m_NotifyManager.WriteConfig();

	OnOK();
}

void CTopicUpdateSettingDlg::OnDestroy()
{
	m_XmlReceiver.RemoveAllServer();

	CDialog::OnDestroy();
}

void CTopicUpdateSettingDlg::OnBtnNotifyModify()
{
	// Get Selected Notify
	CUIntArray naSelRows;
	m_gridNotifyMap.GetSelectedRows(naSelRows);
	if (naSelRows.GetCount() <= 0 || naSelRows[0] < 0) 
		return;

	int nSelIdx = naSelRows[0]-1;
	CNotifySettingDlg NotifySettingDlg(m_NotifyManager.GetTypeAt(nSelIdx), m_NotifyManager.GetValuesAt(nSelIdx), TRUE);
	if (NotifySettingDlg.DoModal() == IDOK)
	{
		m_NotifyManager.SetTypeAt(nSelIdx,  NotifySettingDlg.m_strNotifyType);
		m_NotifyManager.SetValuesAt(nSelIdx, NotifySettingDlg.m_strMapString);

		FillNotifyMapGrid();
	}
}

void CTopicUpdateSettingDlg::OnBtnNotifyAdd()
{
	CNotifySettingDlg NotifySettingDlg(_T(""), _T(""), FALSE);
	if (NotifySettingDlg.DoModal() == IDOK)
	{
		m_NotifyManager.AddType(NotifySettingDlg.m_strNotifyType, NotifySettingDlg.m_strMapString);

		FillNotifyMapGrid();
	}
}

void CTopicUpdateSettingDlg::OnBtnNotifyDel()
{
	// Get Selected Notify
	CUIntArray naSelRows;
	m_gridNotifyMap.GetSelectedRows(naSelRows);
	if (naSelRows.GetCount() <= 0 || naSelRows[0] < 0) 
		return;

	int nSelIdx = naSelRows[0]-1;

	if (AfxMessageBox(_T("Are you sure to delete the Notify mapping?"), MB_YESNO) == IDYES)
	{
		m_NotifyManager.DelTypeAt(nSelIdx);

		FillNotifyMapGrid();
	}
}


//////////////////////////////////////////////////////////////////////////
// Net environment setting
void CTopicUpdateSettingDlg::GetIPAndPort(CString &strPort, CString &strIP)
{
	if (!m_pParent)
		return;

	CIPAddressCtrl *pIPCtrl = (CIPAddressCtrl*) m_pParent->GetDlgItem(IDC_IP_SERVER);
	BYTE IP0,IP1,IP2,IP3;
	pIPCtrl->GetAddress(IP0, IP1, IP2, IP3);	

	m_pParent->GetDlgItemText(IDC_EDIT_PORT, strPort);
	strIP.Format(_T("%d.%d.%d.%d"), IP0, IP1, IP2, IP3);
}
void CTopicUpdateSettingDlg::SetIPAndPort(CString strPort, CString strIP)
{	
	if (!m_pParent)
		return;	

	m_pParent->SetDlgItemText(IDC_EDIT_PORT, strPort);

	if (strIP.IsEmpty()) return;

	CIPAddressCtrl *pIPCtrl = (CIPAddressCtrl*) m_pParent->GetDlgItem(IDC_IP_SERVER);
	if (!pIPCtrl)
		return;

	int IP0=0;
	int IP1=0;
	int IP2=0;
	int IP3=0;
	_stscanf(strIP, _T("%d.%d.%d.%d"), &IP0, &IP1, &IP2, &IP3);

	pIPCtrl->SetAddress(IP0, IP1, IP2, IP3);	
}

void CTopicUpdateSettingDlg::SetNetStateIcon(BOOL bConnected)
{
	if (!m_pParent)
		return;	

	CStatic *pStcNetIcon = (CStatic *) m_pParent->GetDlgItem(IDC_STC_NETICON);
	if (!pStcNetIcon)
		return;

	pStcNetIcon->ModifyStyle(NULL, SS_ICON);
	if (bConnected)
	{
		pStcNetIcon->SetIcon(m_hIconNetOk);
		m_pParent->GetDlgItem(IDC_BTN_CONNECT)->EnableWindow(FALSE);
		m_pParent->GetDlgItem(IDC_BTN_DISCONNECT)->EnableWindow(TRUE);

		g_Log.OutPutMsg(_T("Connect success!"));
	}
	else
	{
		pStcNetIcon->SetIcon(m_hIconNetBroken);
		m_pParent->GetDlgItem(IDC_BTN_CONNECT)->EnableWindow(TRUE);
		m_pParent->GetDlgItem(IDC_BTN_DISCONNECT)->EnableWindow(FALSE);

		g_Log.OutPutMsg(_T("Connection broken!"));
	}
}

void CTopicUpdateSettingDlg::OnBtnConnect()
{
	CString strIP;
	CString strPort;
	GetIPAndPort(strPort, strIP);

	if (m_XmlReceiver.IsConnected(_ttoi(strPort), strIP))
		return;

	// If IP or Port changed, remove the previous connection
	if (m_strServerIP != strIP || m_strServerPort != strPort)
	{
		if (m_XmlReceiver.IsConnected(_ttoi(m_strServerPort), m_strServerIP))
		{
			m_XmlReceiver.RemoveAllServer();
		}
	}

	if (m_XmlReceiver.AddServer(_ttoi(strPort), strIP))
	{
		m_strServerIP = strIP;
		m_strServerPort = strPort;

		SetNetStateIcon(TRUE);
	}
}

void CTopicUpdateSettingDlg::OnBtnDisconnect()
{
	m_XmlReceiver.RemoveAllServer();
	SetNetStateIcon(FALSE);
}


//////////////////////////////////////////////////////////////////////////
// Process Notify types
int CTopicUpdateSettingDlg::FrameReceive(LPBYTE lpFrame, int nFrameSize, LPVOID lpParam)
{
	CTopicUpdateSettingDlg* pDlg = (CTopicUpdateSettingDlg*)lpParam;
	if (pDlg)
	{
		//pDlg->SendMessage(WM_USER_RECV_FRAME, (WPARAM)lpFrame, (LPARAM)nFrameSize); // Switch to main thread
		pDlg->OnFrameReceive((WPARAM)lpFrame, (LPARAM)nFrameSize); // continue in work thread

		return TRUE;
	}
	return FALSE;
}

LRESULT CTopicUpdateSettingDlg::OnFrameReceive(WPARAM wParam, LPARAM lParam)
{
	//CStringW strMsgDoc((LPWSTR)wParam, (int)lParam/2); // UNICODE
	//CString strMsgDoc((LPCSTR)wParam, lParam); // ANSIC
	
	CStringW strMsgDoc;

	// UTF-8 to UNICODE
	UINT nDesLen = ::MultiByteToWideChar(CP_UTF8, 0, (LPCSTR)wParam, lParam, NULL, 0);
	if (nDesLen <= 0)
		return 0;
	::MultiByteToWideChar(CP_UTF8, 0, (LPCSTR)wParam, lParam, strMsgDoc.GetBuffer(nDesLen), nDesLen);
	strMsgDoc.ReleaseBuffer(nDesLen);
	
	ParseMessagePack(strMsgDoc);
	
	return -1;
}

void CTopicUpdateSettingDlg::ParseMessagePack(CString strXml)
{
	CAxMarkup XmlMarkup;
	try
	{		
		XmlMarkup.SetDoc(strXml.GetBuffer());
	}
	catch (...)
	{
		g_Log.OutPutMsg(_T("Xml notify message load error! The content is below : "));
		g_Log.OutPutMsg(strXml);
		return;
	}

	AryNotifyMsgs aryNotifyMsgs;
	GetNotifyTypeFromXml(XmlMarkup, aryNotifyMsgs);

	for (int i=0; i < aryNotifyMsgs.GetCount(); i++)
	{
		ProcessNotify(aryNotifyMsgs[i]); // no postpone process on this NotifyMsg level
	}

}

void CTopicUpdateSettingDlg::ProcessNotify(STNotifyMsg &sNotifyMsg)
{
	int nTypeIndex = m_NotifyManager.FindType(sNotifyMsg.strType);
	if (nTypeIndex < 0)
		return;

	CString strMapString = m_NotifyManager.GetValuesAt(nTypeIndex);
	if (strMapString.IsEmpty()) return;

	// Get the corresponding Items
	CStringArray straMapItems;
	CNotifySettingDlg::SplitStringToStra(strMapString, straMapItems);

	int nItemsCount = straMapItems.GetCount();
	// Log the Msg
	if (nItemsCount > 0)
	{	
		g_Log.OutPutMsg(_T("MSG : ") + sNotifyMsg.strType + 
			_T(",SessionID: ") + sNotifyMsg.strSessionID + 
			_T(",MatchID: ") + sNotifyMsg.strMatchID +
			_T(",CourtID: ") + sNotifyMsg.strCourtID);
	}

	// Update the each item
	for (int i=0; i < nItemsCount; i++)
	{
		CString strMsgKey = straMapItems[i];

		STopicItem *pTopicItem;
		pTopicItem = g_TopicManager.GetTopicItemByMsgKey(strMsgKey);
		if (!pTopicItem)
			continue;

		CCRSInfoServerDlg::SendMsgToCRSInfo(pTopicItem, 1, &sNotifyMsg);
	}
}

void CTopicUpdateSettingDlg::GetNotifyTypeFromXml(CAxMarkup &XmlDoc, OUT AryNotifyMsgs &aryNotifyMsgs)
{
	aryNotifyMsgs.RemoveAll();

	if (!XmlDoc.FindElem(_T("Message")))
		return;

	// Get message header
	STNotifyMsg sNotifyMsgHeader;
	CString strMessageType = XmlDoc.GetAttrib(_T("Type"));

	// Ensure message type is "NOTIFY"
	if (strMessageType.CompareNoCase(_T("NOTIFY")) != 0) 
		return;

	sNotifyMsgHeader.strRSCCode = XmlDoc.GetAttrib(_T("RSC"));
	sNotifyMsgHeader.strDate = XmlDoc.GetAttrib(_T("Date"));
	sNotifyMsgHeader.strGenderCode = XmlDoc.GetAttrib(_T("Gender"));

	sNotifyMsgHeader.strDisciplineCode = XmlDoc.GetAttrib(_T("Discipline"));
	sNotifyMsgHeader.strEventCode = XmlDoc.GetAttrib(_T("Event"));
	sNotifyMsgHeader.strPhaseCode = XmlDoc.GetAttrib(_T("Phase"));
	sNotifyMsgHeader.strUnitCode = XmlDoc.GetAttrib(_T("Unit"));

	if (!XmlDoc.IntoElem()) 
		return;

	while (XmlDoc.FindElem(_T("Item")))
	{
		STNotifyMsg sNotifyMsg;
		sNotifyMsg = sNotifyMsgHeader;
		sNotifyMsg.strType = XmlDoc.GetAttrib(_T("NotifyType"));
		sNotifyMsg.strDisciplineID = XmlDoc.GetAttrib(_T("DisciplineID"));
		sNotifyMsg.strEventID = XmlDoc.GetAttrib(_T("EventID"));
		sNotifyMsg.strPhaseID = XmlDoc.GetAttrib(_T("PhaseID"));
		sNotifyMsg.strMatchID = XmlDoc.GetAttrib(_T("MatchID"));
		sNotifyMsg.strSessionID = XmlDoc.GetAttrib(_T("SessionID"));
		sNotifyMsg.strCourtID = XmlDoc.GetAttrib(_T("CourtID"));

		aryNotifyMsgs.Add(sNotifyMsg);
	}
}

BOOL CTopicUpdateSettingDlg::Create(LPCTSTR lpszTemplateName, CWnd* pParentWnd)
{
	if (pParentWnd)
	{
		m_pParent = pParentWnd;
	}	

	return CDialog::Create(lpszTemplateName, pParentWnd);
}
