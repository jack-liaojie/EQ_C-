

#include "stdafx.h"
#include "XmlMessageTrans.h"
#include "..\TopicUpdateSettingDlg.h"

//////////////////////////////////////////////////////////////////////////
// CXmlMessageReceiver
IMPLEMENT_DYNAMIC(CXmlMessageReceiver, CNetworkTranscv);

CXmlMessageReceiver::CXmlMessageReceiver()
{
}

CXmlMessageReceiver::~CXmlMessageReceiver()
{
	RemoveAllServer();
}

void CXmlMessageReceiver::SetRecvWndAndMsg(CTopicUpdateSettingDlg *pParentDlg, UINT nMsgID)
{ 
	if (pParentDlg && pParentDlg->IsKindOf(RUNTIME_CLASS(CTopicUpdateSettingDlg)))
	{
		m_pParentDlg = pParentDlg; 
	}
	else 
	{
		AfxMessageBox(_T("SetParentDlg error!"));
		return;
	}
	
	// Init DataSpliter
	BYTE baBeginMark[] = {0x01};
	//BYTE baEndMark[] = {0x04, 0x00};
	m_Spliter.SetSplitMark(baBeginMark, sizeof(baBeginMark));
	m_Spliter.SetCallBack(pParentDlg->FrameReceive, (LPVOID)pParentDlg, TRUE);
};

BOOL CXmlMessageReceiver::AddServer(UINT nPort, LPCTSTR pszAddress)
{
	if (GetSocketFromPeerName(nPort, pszAddress))
		return TRUE;

	return SocketOpen(nPort, pszAddress);
}

void CXmlMessageReceiver::RemoveServer(UINT nPort, LPCTSTR pszAddress)
{
	SocketClose(GetSocketFromPeerName(nPort, pszAddress));
}

void CXmlMessageReceiver::RemoveAllServer()
{
	SocketCloseAll();
}

BOOL CXmlMessageReceiver::IsConnected(UINT nPort, LPCTSTR pszAddress)
{
	return (GetSocketFromPeerName(nPort, pszAddress) ? TRUE : FALSE);
}

void CXmlMessageReceiver::OnTranscvFailure(CNetworkSocket* pSocket, int nErrorCode, int nCause)
{
	UINT nPort = 0;
	CString strAddr, strName;
	pSocket->GetPeerName(strAddr, nPort);
	strName.Format(_T(":%d"), nPort);
	strName = strAddr + strName;

	CString strCause;
	switch (nCause)
	{
	case transcv_fail_connect:
		strCause.Format(_T("Error [%d] in connect!"), nErrorCode);
		break;
	case transcv_fail_disconnect:
		strCause.Format(_T("Error [%d] in close!"), nErrorCode);
		break;
	case transcv_fail_send:
		strCause.Format(_T("Error [%d] in send!"), nErrorCode);
		break;
	case transcv_fail_receive:
		strCause.Format(_T("Error [%d] in receive!"), nErrorCode);
		break;
	default:
		strCause = _T("Unknown Error.");
	}

	AfxMessageBox(strName + _T(" - ") + strCause);
}

void CXmlMessageReceiver::OnTranscvDisconnected(CNetworkSocket* pSocket)
{
	UINT nPort;
	CString strAddr;
	pSocket->GetPeerName(strAddr, nPort);

	//////////////////////////////////////////////////////////////////////////
	// Set CTopicUpdateSettingDlg NetWork status to Disconnected

	if (m_pParentDlg)
	{
		CTopicUpdateSettingDlg *pDlg = m_pParentDlg;
		if (pDlg->m_strServerIP == strAddr && pDlg->m_strServerPort == AxCommonInt2String(nPort))
		{
			pDlg->SetNetStateIcon(FALSE);
		}
	}

}

void CXmlMessageReceiver::OnReceiveXmlMsg(CNetworkSocket* pSocket, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(pSocket);

	LPBYTE lpData =  LPBYTE(lParam);
	int nSize = wParam;

	m_Spliter.FillData(lpData, nSize);
}

