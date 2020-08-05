#pragma once

#include "resource.h"

#include "NotifyManager.h"
#include ".\NetWork\XmlMessageTrans.h"

// CTopicUpdateSettingDlg dialog

struct STNotifyMsg 
{
	CString strRSCCode;
	CString strDate;
	CString strVenueCode;
	CString strGenderCode;

	CString strDisciplineCode;
	CString strEventCode;
	CString strPhaseCode;
	CString strUnitCode;

	CString strType;
	CString strDisciplineID;
	CString strEventID;
	CString strPhaseID;
	CString strMatchID;
	CString strSessionID;
	CString strCourtID;
};

typedef CArray<STNotifyMsg, STNotifyMsg&> AryNotifyMsgs;

class CTopicUpdateSettingDlg : public CDialog
{
	DECLARE_DYNAMIC(CTopicUpdateSettingDlg)

public:
	CTopicUpdateSettingDlg();   // standard constructor
	virtual ~CTopicUpdateSettingDlg();

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

	void GetIPAndPort(OUT CString &strPort, OUT CString &strIP);
	void SetIPAndPort(CString strPort, CString strIP);
	
	void FillNotifyMapGrid();

	void ParseMessagePack(CString strXml);
	void GetNotifyTypeFromXml(CAxMarkup &XmlDoc, OUT AryNotifyMsgs &aryNotifyMsgs);
	void ProcessNotify(STNotifyMsg &sNotifyMsg);

public:
	CString				m_strServerPort;
	CString				m_strServerIP;
	BOOL				m_bAdministrator;
	CXmlMessageReceiver m_XmlReceiver;

	void OnBtnConnect();
	void OnBtnDisconnect();
	void SetNetStateIcon(BOOL bConnected);
	
	static int FrameReceive(LPBYTE lpFrame, int nFrameSize, LPVOID lpParam); // NetWork Callback function

	virtual BOOL Create(LPCTSTR lpszTemplateName, CWnd* pParentWnd = NULL);
};
