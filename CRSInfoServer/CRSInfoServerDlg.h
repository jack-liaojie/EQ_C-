
// InfoDataFeedServerDlg.h : header file

#pragma once

#include "DFSTopicManager.h"
#include "TopicUpdateSettingDlg.h"
#include "LogFunc.h"
#include "CRSPublicDef.h"
#include "ExportDBSetting.h"
#include "compeerx1.h"
#include "XmlDisplayDlg.h"


// CCRSInfoServerDlg dialog
class CCRSInfoServerDlg : public CDialog
{
public:
	CCRSInfoServerDlg();
	enum { IDD = IDD_INFODATAFEEDSERVER_DIALOG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);
	virtual BOOL OnInitDialog();
	virtual BOOL OnCommand(WPARAM wParam, LPARAM lParam);

	afx_msg void OnBtnConnect();
	afx_msg void OnBtnDisconnect();

	afx_msg void OnBtnTopicAdd();
	afx_msg void OnBtnTopicModify();
	afx_msg void OnBtnTopicDel();

	afx_msg void OnBtnUpdateSetting();

	afx_msg void OnBtnExport();
	afx_msg void OnBtnPreview();
	afx_msg void OnBtnRefresh();
	afx_msg void OnBtnSetFilePath();

	afx_msg void OnTextFilePathKillfocus();

	afx_msg void OnTopicSelChange(NMHDR* pNmhdr, LRESULT* pResult);
	afx_msg void OnTopicListGridRClick(NMHDR* pNmhdr, LRESULT* pResult); 
	afx_msg void OnTvnSelchangedTreeSport(NMHDR *pNMHDR, LRESULT *pResult);

	afx_msg void OnSelchangeDate();

	afx_msg void OnDestroy();

	DECLARE_MESSAGE_MAP()

private:
	BOOL					m_bAdministrator;

	CAsCoolGridCtrl			m_gridTopics;
	CTopicUpdateSettingDlg	m_UpdateSettingDlg; // Including Network Operation
	CExportDBSetting		m_TopicsSettingExport;

	// Sport Node tree process
	void ReleaseNodeInfoAry();
	void RefreshPhaseTree();
	void RefreshDateCombobox();
	BOOL TreeNodeInfo2NotifyMsg(IN SCRSTreeNodeInfo *pTreeNodeInfo, OUT STNotifyMsg &sNotifyMsg);
	BOOL GetCurSelMsgAndTreeNode(OUT STopicItem **pTopicItem, OUT SCRSTreeNodeInfo **pTreeNodeInfo);
	BOOL ExportMsgFromNode(STopicItem *pTopicItem, SCRSTreeNodeInfo *pTreeNodeInfo, BOOL bPreview =FALSE);
	BOOL GetAllDisciplineDates(CString strDisciplineCode, OUT CStringArray &straDateIDs, OUT CStringArray &straDateNames);
	void EnableControlBtn();

	void SetCmboxSelByItemData(CComboBox *pCmbox, CString strCmbSelDate);

	PAryTreeNodeInfo		m_pAryTreeNodeInfo;	
	CMapStringToPtr			m_mapKeyToNodePtr;
	CMapStringToString		m_mapDateToDateID;
	CTreeCtrl				m_treeSport;
	CImageList				m_iconLists;
	int						m_nCurSelTopicIdx;
	int						m_nCmbSelectedDateID;
	CString					m_strCmbSelDate;
	CString					m_strCmbSelDateID;

public:	
	BOOL CreateTopicListGrid();

	BOOL LoadTopicList();
	void ShowTopicList();

	void ReadConfig();
	void WriteConfig();

	static CString			m_strFilePath;

	static BOOL SendMsgToCRSInfo(STopicItem *pTopicItem, int bAuto, STNotifyMsg *pNotifyMsgParam = NULL, BOOL bPreview = FALSE);
	static BOOL GetDataFromDBAndSend(CString strSQL, CString strDisplnCode, CString strMsgKey, CString strMsgTypeID, BOOL bPreview = FALSE);
	static CString ParseSQLExpressWithParams(CString strSrcSQLExpress, STNotifyMsg *pNotifyMsgParam, int bAuto);
	static void PreviewXMLResult(CString &strXmlResult);
	
	//zjy 2012-08-17 Delete ComPeerX Control.
	/*DECLARE_EVENTSINK_MAP()*/

	////////////////////////////////////////////////////////////////////////
	// MsgPeerCom
	CString		m_strMsgPeerComServerPort;	

	void OnIsRunningChangedCompeerx1();
	void OnOnlineChangedCompeerx1();
	void OnReceiveMsgCompeerx1(LPCTSTR AMsgType, LPCTSTR ASportCode, LPCTSTR AMsgData, LPCTSTR AMsgGuid);

};
