// TopicUpdateSettingDlg.cpp : implementation file
//

#include "stdafx.h"
#include "TVDataServer.h"
#include "TVUpdateSettingDlg.h"
#include "NotifySettingDlg.h"


// CTVUpdateSettingDlg dialog
#define IDC_GRID_NOTIFYMAP		15000

#define WM_USER_RECV_FRAME		WM_USER + 100
#define WM_USER_PROCESS_NOTIFY	WM_USER + 200

IMPLEMENT_DYNAMIC(CTVUpdateSettingDlg, CDialog)

CTVUpdateSettingDlg::CTVUpdateSettingDlg()
	: CDialog(CTVUpdateSettingDlg::IDD)
{
	m_strServerPort = _T("");
	m_strServerIP = _T("");
	m_pParent = NULL;

	m_bAdministrator = FALSE;
}

CTVUpdateSettingDlg::~CTVUpdateSettingDlg()
{
}

void CTVUpdateSettingDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CTVUpdateSettingDlg, CDialog)

	ON_BN_CLICKED(IDOK, OnOk)
	ON_WM_SHOWWINDOW()
	ON_WM_DESTROY()
	ON_MESSAGE(WM_USER_RECV_FRAME, OnFrameReceive)

	ON_BN_CLICKED(IDC_BTN_NOTIFY_MODIFY, OnBtnNotifyModify)
	ON_BN_CLICKED(IDC_BTN_NOTIFY_ADD, OnBtnNotifyAdd)
	ON_BN_CLICKED(IDC_BTN_NOTIFY_DEL, OnBtnNotifyDel)
END_MESSAGE_MAP()


// CTVUpdateSettingDlg message handlers

BOOL CTVUpdateSettingDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	m_XmlReceiver.SetRecvWndAndMsg(this, WM_USER_RECV_FRAME);

	m_hIconNetOk = LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDI_ICON_NETOK));
	m_hIconNetBroken = LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDI_ICON_NETBROKEN));
	SetNetStateIcon(FALSE);

	m_NotifyManager.ReadConfig();
	ReadConfig();
	SetIPAndPort(m_strServerPort, m_strServerIP);

	return TRUE;

}

void CTVUpdateSettingDlg::OnShowWindow(BOOL bShow, UINT nStatus)
{
	CDialog::OnShowWindow(bShow, nStatus);
	
	m_NotifyManager.ReadConfig();
	ReadConfig();
	FillNotifyMapGrid();

	if (!m_bAdministrator)
	{
		GetDlgItem(IDC_BTN_NOTIFY_ADD)->EnableWindow(FALSE);
		GetDlgItem(IDC_BTN_NOTIFY_MODIFY)->EnableWindow(FALSE);
		GetDlgItem(IDC_BTN_NOTIFY_DEL)->EnableWindow(FALSE);
	}

	SetIPAndPort(m_strServerPort, m_strServerIP);
}

void CTVUpdateSettingDlg::ReadConfig()
{
	CString strConfigFile = CAxReadWriteINI::GetAppConfigFile();

	CString strIsAdministrator;
	CAxReadWriteINI::IniReadString(_T("COMMON_SETUP"), _T("USER_Administrator"), strIsAdministrator, strConfigFile);
	m_bAdministrator = _ttoi(strIsAdministrator);
}

void CTVUpdateSettingDlg::WriteConfig()
{
	CString strConfigFile = CAxReadWriteINI::GetAppConfigFile();

}

void CTVUpdateSettingDlg::FillNotifyMapGrid()
{
	if (!::IsWindow(m_gridNotifyMap.GetSafeHwnd()))
	{
		CRect rcGrid;
		GetClientRect(rcGrid);
		rcGrid.top += MID_FRAME_WIDTH;
		rcGrid.bottom -= 36;
		rcGrid.right -= MID_FRAME_WIDTH;
		rcGrid.left += MID_FRAME_WIDTH;

		if (!m_gridNotifyMap.Create(rcGrid, this, IDC_GRID_NOTIFYMAP))
			return;
	}
	
	int nTypesCount = m_NotifyManager.GetCount();

	m_gridNotifyMap.SetColumnCount(2);
	m_gridNotifyMap.SetRowCount(nTypesCount+1);
	m_gridNotifyMap.SetFixedRowCount();
	m_gridNotifyMap.SetItemText(0, 0, _T("Notify Types"));
	m_gridNotifyMap.SetItemText(0, 1, _T("Map TV Tables And Operations"));
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

void CTVUpdateSettingDlg::OnOk()
{
	m_NotifyManager.WriteConfig();
	WriteConfig();

	OnOK();
}

void CTVUpdateSettingDlg::OnDestroy()
{
	m_XmlReceiver.RemoveAllServer();

	CDialog::OnDestroy();
}

void CTVUpdateSettingDlg::OnBtnNotifyModify()
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

void CTVUpdateSettingDlg::OnBtnNotifyAdd()
{
	CNotifySettingDlg NotifySettingDlg(_T(""), _T(""), FALSE);
	if (NotifySettingDlg.DoModal() == IDOK)
	{
		m_NotifyManager.AddType(NotifySettingDlg.m_strNotifyType, NotifySettingDlg.m_strMapString);
		
		FillNotifyMapGrid();
	}
}

void CTVUpdateSettingDlg::OnBtnNotifyDel()
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
void CTVUpdateSettingDlg::OnBtnConnect()
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

void CTVUpdateSettingDlg::OnBtnDisconnect()
{
	m_XmlReceiver.RemoveAllServer();
	SetNetStateIcon(FALSE);
}

void CTVUpdateSettingDlg::GetIPAndPort(CString &strPort, CString &strIP)
{
	if (!m_pParent)
		return;

	CIPAddressCtrl *pIPCtrl = (CIPAddressCtrl*) m_pParent->GetDlgItem(IDC_IP_SERVER);
	BYTE IP0,IP1,IP2,IP3;
	pIPCtrl->GetAddress(IP0, IP1, IP2, IP3);	

	m_pParent->GetDlgItemText(IDC_EDIT_PORT, strPort);
	strIP.Format(_T("%d.%d.%d.%d"), IP0, IP1, IP2, IP3);
}
void CTVUpdateSettingDlg::SetIPAndPort(CString strPort, CString strIP)
{	
	if (!m_pParent)
		return;	
	
	m_pParent->SetDlgItemText(IDC_EDIT_PORT, strPort);

	if (strIP.IsEmpty()) return;

	CIPAddressCtrl *pIPCtrl = (CIPAddressCtrl*) m_pParent->GetDlgItem(IDC_IP_SERVER);
	
	int IP0=0;
	int IP1=0;
	int IP2=0;
	int IP3=0;
	_stscanf(strIP, _T("%d.%d.%d.%d"), &IP0, &IP1, &IP2, &IP3);

	pIPCtrl->SetAddress(IP0, IP1, IP2, IP3);	
}

void CTVUpdateSettingDlg::SetNetStateIcon(BOOL bConnected)
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

//////////////////////////////////////////////////////////////////////////
// Process Notify types
int CTVUpdateSettingDlg::FrameReceive(LPBYTE lpFrame, int nFrameSize, LPVOID lpParam)
{
	CTVUpdateSettingDlg* pDlg = (CTVUpdateSettingDlg*)lpParam;
	if (pDlg)
	{
		//pDlg->SendMessage(WM_USER_RECV_FRAME, (WPARAM)lpFrame, (LPARAM)nFrameSize); // Switch to main thread
		pDlg->OnFrameReceive((WPARAM)lpFrame, (LPARAM)nFrameSize); // continue in work thread

		return TRUE;
	}
	return FALSE;
}

LRESULT CTVUpdateSettingDlg::OnFrameReceive(WPARAM wParam, LPARAM lParam)
{
	CStringW strMsgDoc((LPWSTR)wParam, (int)lParam/2); // UNICODE

	//CString strMsgDoc((LPCSTR)wParam, lParam); // ANSIC
	
	ParseMessagePack(strMsgDoc);
	
	return -1;
}

void CTVUpdateSettingDlg::ParseMessagePack(CString strXml)
{
	CAxMarkup XmlMarkup;
	XmlMarkup.SetDoc(strXml.GetBuffer());

	AryNotifyMsgs aryNotifyMsgs;
	GetNotifyTypeFromXml(XmlMarkup, aryNotifyMsgs);

	for (int i=0; i < aryNotifyMsgs.GetCount(); i++)
	{
		ProcessNotify(aryNotifyMsgs[i]); // no postpone process on this NotifyMsg level
	}

}

void CTVUpdateSettingDlg::ProcessNotify(STNotifyMsg &sNotifyMsg)
{
	int nTypeIndex = m_NotifyManager.FindType(sNotifyMsg.strType);
	if (nTypeIndex < 0)
		return;

	CString strMapString = m_NotifyManager.GetValuesAt(nTypeIndex);
	if (strMapString.IsEmpty()) return;

	// Get the corresponding Operation and Tables update
	CStringArray straMapItems, straTVOperations, straTVTables;
	CNotifySettingDlg::SplitStringToStra(strMapString, straMapItems);
	CNotifySettingDlg::GetTVOperationAndTables(straMapItems, straTVOperations, straTVTables);

	int nOperationCount = straTVOperations.GetCount();	
	int nTableCount = straTVTables.GetCount();

	// Log the Msg
	if (nOperationCount > 0 || nTableCount > 0)
	{	g_Log.OutPutMsg(_T("MSG : ") + sNotifyMsg.strType + 
						_T(",SessionID: ") + sNotifyMsg.strSessionID + 
						_T(",MatchID: ") + sNotifyMsg.strMatchID +
						_T(",CourtID: ") + sNotifyMsg.strCourtID);
	}

	// Get the sessionID from database 
	if (!IsValidID(sNotifyMsg.strSessionID) && IsValidID(sNotifyMsg.strMatchID))
	{
		sNotifyMsg.strSessionID = g_DBAccess.GetSessionID(sNotifyMsg.strMatchID, &sNotifyMsg.strCourtID);
		
		// validate check
		if (!IsValidID(sNotifyMsg.strSessionID))
		{
			g_Log.OutPutMsg(_T("SessionID is invalid!"));
			return;
		}
		if (g_TVDataManager.IsShowCourt() && !IsValidID(sNotifyMsg.strCourtID))
		{
			g_Log.OutPutMsg(_T("CourtID is invalid"));
			return;	
		}
	}

	// Update each Operation
	for (int i=0; i < nOperationCount; i++)
	{
		CString strOperation = straTVOperations[i];
		strOperation.Trim(_T(","));

		EMTVOperationType emOperation = Str2OperationType(strOperation);
		if (emOperation != emTVOPUnknown)
		{
			g_TVDataManager.ProcessTVOperation(sNotifyMsg, emOperation, &straTVTables);
		}		
	}

	// Update each Table
	for (int i=0; i < nTableCount; i++)
	{
		CString strUpdateTable = straTVTables[i];
		strUpdateTable.Trim(_T(","));
		strUpdateTable = strUpdateTable.Right(strUpdateTable.GetLength() - CString(_T("UPTABLE_")).GetLength());
		
		g_TVDataManager.ProcessTVTableUpdate(sNotifyMsg, strUpdateTable);
	}

}

void CTVUpdateSettingDlg::GetNotifyTypeFromXml(CAxMarkup &XmlDoc, OUT AryNotifyMsgs &aryNotifyMsgs)
{
	aryNotifyMsgs.RemoveAll();

	if (!XmlDoc.FindElem(_T("Message")))
		return;

	CString strMessageType = XmlDoc.GetAttrib(_T("Type"));
	if (strMessageType.CompareNoCase(_T("NOTIFY")) != 0) return;

	if (!XmlDoc.IntoElem()) return;

	while (XmlDoc.FindElem(_T("Item")))
	{
		STNotifyMsg sNotifyMsg;
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


BOOL CTVUpdateSettingDlg::Create(LPCTSTR lpszTemplateName, CWnd* pParentWnd)
{
	if (pParentWnd)
	{
		m_pParent = pParentWnd;
	}	

	return CDialog::Create(lpszTemplateName, pParentWnd);
}
