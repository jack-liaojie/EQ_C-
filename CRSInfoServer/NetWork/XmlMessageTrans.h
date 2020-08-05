
#pragma once

#include "NetworkTrans.h"
#include "DataSpliter.h"

class CTopicUpdateSettingDlg;
class CXmlMessageReceiver : private CNetworkTranscv
{
	DECLARE_DYNAMIC(CXmlMessageReceiver);

public:
	CXmlMessageReceiver();
	virtual ~CXmlMessageReceiver();

public:
	BOOL AddServer(UINT nPort, LPCTSTR pszAddress);
	void RemoveServer(UINT nPort, LPCTSTR pszAddress);
	void RemoveAllServer();
	BOOL IsConnected(UINT nPort, LPCTSTR pszAddress);

	// Must be called before others
	void SetRecvWndAndMsg(CTopicUpdateSettingDlg *pParentDlg, UINT nMsgID);

private:
	//void OnTranscvConnected(CNetworkSocket* pSocket);
	void OnTranscvDisconnected(CNetworkSocket* pSocket);
	void OnTranscvFailure(CNetworkSocket* pSocket, int nErrorCode, int nCause);
	void OnReceiveXmlMsg(CNetworkSocket* pSocket, WPARAM wParam, LPARAM lParam);

	CTopicUpdateSettingDlg *m_pParentDlg;
	CDataSpliter			m_Spliter;

};