/********************************************************************
	created:	2009/12/23
	filename: 	TVTableSettingDlg.h

	author:		GRL
*********************************************************************/



#pragma once

// CTVTableSettingDlg dialog
class CTVTable;

class CTVTableSettingDlg : public CDialog
{
	DECLARE_DYNAMIC(CTVTableSettingDlg)

public:
	CTVTableSettingDlg(CTVTable *pTVTable, BOOL bModify); // bModify=FALSE, then Add new Topic
	virtual ~CTVTableSettingDlg();
	enum { IDD = IDD_DLG_TVTABLE_SETTING };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);
	virtual BOOL OnInitDialog();

	virtual void OnOK();
	virtual void OnCancel();

	afx_msg void OnBtnSQLPreview();
	DECLARE_MESSAGE_MAP()

private:
	CTVTable*	m_pTVTable;
	BOOL		m_bModify; // Modify or Add new Topic

	CAsCoolGridCtrl m_gridSQLPreview;
	CAxRichEditEx	m_editSQL;

private:
	void InitCtrls();
	void InitComboBoxList();
	BOOL CreateSQLPreviewGrid();

	BOOL UpdateTVTableItem(CTVTable *pTVTable, BOOL bSaveToItem);

private:
	CString m_strTableName;
	CString m_strTableLevelType;
	CString m_strSQLExpression;
public:
	afx_msg void OnSelchangeCmbTablelevelType();
	CString m_strParam1;
	CString m_strParam2;
	CString m_strSQLPreview;
};
