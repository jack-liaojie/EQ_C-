#pragma once

#include "resource.h"
// CNotifySettingDlg dialog

class CNotifySettingDlg : public CDialog
{
	DECLARE_DYNAMIC(CNotifySettingDlg)

public:
	CNotifySettingDlg(CString strNotifyType, CString strMapTopicIDs, BOOL bModify);   // standard constructor
	virtual ~CNotifySettingDlg();
	enum { IDD = IDD_DLG_NOTIFY_SETTING };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual BOOL OnInitDialog();	
	virtual BOOL OnNotify(WPARAM wParam, LPARAM lParam, LRESULT* pResult);
	virtual void OnOK();
	DECLARE_MESSAGE_MAP()

public:
	BOOL		m_bModify;
	CString		m_strNotifyType;
	CString		m_strMapString;

private:
	CStringArray		m_straAllItems;
	CStringArray		m_straAllItemsNames;

	CStringArray		m_straSelectedItems;
	CStringArray		m_straRemainItems;

	CAsCoolGridCtrl		m_gridRemainItems;
	CAsCoolGridCtrl		m_gridSelectedItems;

	void GetAllItems(OUT CStringArray &straAllItems);

	void FillRemainTablesGrid();
	void FillSelectedTableGrid();

	void ParseMapString(CString strMapString, OUT CStringArray &straSelectedItems, OUT CStringArray &straRemainItems);
	int StraValueToIndex(CStringArray &straArray, CString strValue);
	// String operation tools
public:
	static CString GetAssembledStr(CStringArray &straArray, CString strSplitMark, BOOL bWithEnd=TRUE);
	static void SplitStringToStra(CString strMapString, OUT CStringArray &straMapItems);
	static void GetTVOperationAndTables(CStringArray &straMapItems, OUT CStringArray &straTVOperations, OUT CStringArray &straTVTables);

};

