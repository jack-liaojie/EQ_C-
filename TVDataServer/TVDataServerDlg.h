
// TVDataServerDlg.h : 头文件
//

#pragma once

#include "stdafx.h"
#include "TVUpdateSettingDlg.h"
#include "ExportDBSetting.h"
#include "SimpleTrayIcon.h"
#include "TVFileOpenDlg.h"

// CTVDataServerDlg 对话框
class CTVDataServerDlg : public CDialog
{
public:
	CTVDataServerDlg(CWnd* pParent = NULL);	
	~CTVDataServerDlg(){};

	enum { IDD = IDD_TVDATASERVER_DIALOG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);
	virtual BOOL OnInitDialog();
	virtual BOOL OnCommand(WPARAM wParam, LPARAM lParam);
	virtual void OnCancel(){};
	virtual void OnOK(){};

	SIMPLETRAY_DECLARE;

	DECLARE_MESSAGE_MAP()

private:

	BOOL CreateTVTableGrid();
	BOOL CreateSQLPreviewGrid();

	void ReadConfig();
	void WriteConfig();

	void SetCmboxSelByItemData(CComboBox *pCmbox, int nItemData);

private:
	BOOL				m_bResizeWE;
	BOOL				m_bResizeNS;
	BOOL				m_bLeftPartResize;

	BOOL				m_bAdministrator;

	BOOL				m_bShowCourt;
	CString				m_strExportPath;
	CTreeCtrl			m_treeTVData;

	int					m_nCmbSelectedDateID;
	int					m_nCmbSelectedSessionID;

	CAsCoolGridCtrl		m_gridTVTables;
	CAsCoolGridCtrl		m_gridSQLPreview;

	CTVUpdateSettingDlg m_UpdateSettingDlg;

	CExportDBSetting	m_TVTableSettingExport;

	CTVFileOpenDlg		m_TVFileOpenDlg;

public:
	afx_msg void OnChkShowcourt();

	afx_msg void OnBtnConnect();
	afx_msg void OnBtnDisconnect();

	afx_msg void OnBtnRefresh();
	afx_msg void OnBtnRebuild();
	afx_msg void OnBtnExportNode();
	afx_msg void OnBtnDeleteNode();

	afx_msg void OnBtnTableAdd();
	afx_msg void OnBtnTableModify();
	afx_msg void OnBtnTableDel();
	afx_msg void OnNMDblclkTreeTvdate(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnNMRClickTreeTvdate(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnBtnUpdateSetting();
	afx_msg void OnBtnSelExportPath();
	afx_msg void OnDestroy();

	// Size control
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnMouseMove(UINT nFlags, CPoint point);
	afx_msg void OnSize(UINT nType, int cx, int cy);

	afx_msg void OnClose();

	afx_msg void OnSelchangeSession();
	afx_msg void OnSelchangeDate();

	afx_msg void OnTVTableGridRClick(NMHDR* pNmhdr, LRESULT* pResult); 
	afx_msg void OnTVFileOpen();

public:

	void LoadAndShowTVTables();
	void GetSessionIDsAndNames(OUT CStringArray &straSessionIDs, OUT CStringArray &straSessionNames);
};
