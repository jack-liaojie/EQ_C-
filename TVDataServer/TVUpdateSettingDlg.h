#pragma once

#include "resource.h"

#include "NotifyManager.h"
#include ".\NetWork\XmlMessageTrans.h"


// CTVUpdateSettingDlg dialog

class CTVUpdateSettingDlg : public CDialog
{
	DECLARE_DYNAMIC(CTVUpdateSettingDlg)

public:
	CTVUpdateSettingDlg();   // standard constructor
	virtual ~CTVUpdateSettingDlg();

	// Dialog Data
	enum { IDD = IDD_DLG_UPDATE_SETTING };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual BOOL OnInitDialog();


	afx_msg void OnOk();
	afx_msg void OnShowWindow(BOOL bShow, UINT nStatus);
	afx_msg void OnDestroy();
	afx_msg LRESULT OnFrameReceive(WPARAM wParam, LPARAM lParam); // wParam= lpFrame, lParam= FrameSize

	afx_msg void OnBtnNotifyModify();
	afx_msg void OnBtnNotifyAdd();
	afx_msg void OnBtnNotifyDel();
	DECLARE_MESSAGE_MAP()
	
private:
	HICON m_hIconNetOk;
	HICON m_hIconNetBroken;
	CWnd* m_pParent;

	CNotifyManager		m_NotifyManager;
	CAsCoolGridCtrl		m_gridNotifyMap;
	
	BOOL				m_bAdministrator;

	void ReadConfig();
	void WriteConfig();
	
	void FillNotifyMapGrid();
	void GetIPAndPort(OUT CString &strPort, OUT CString &strIP);
	void SetIPAndPort(CString strPort, CString strIP);

	void ParseMessagePack(CString strXml);
	void GetNotifyTypeFromXml(CAxMarkup &XmlDoc, OUT AryNotifyMsgs &aryNotifyMsgs);
	void ProcessNotify(STNotifyMsg &sNotifyMsg);

public:
	CString				m_strServerPort;
	CString				m_strServerIP;

	CXmlMessageReceiver m_XmlReceiver;
	
	void OnBtnConnect();
	void OnBtnDisconnect();
	void SetNetStateIcon(BOOL bConnected);


	static int FrameReceive(LPBYTE lpFrame, int nFrameSize, LPVOID lpParam); // NetWork Callback function

	virtual BOOL Create(LPCTSTR lpszTemplateName, CWnd* pParentWnd = NULL);
};
