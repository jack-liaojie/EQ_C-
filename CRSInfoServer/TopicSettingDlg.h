#pragma once

#include "DFSTopicManager.h"
#include "InnerMisla.h"

// CTopicSettingDlg dialog

class CTopicSettingDlg : public CDialog
{
	DECLARE_DYNAMIC(CTopicSettingDlg)

public:
	CTopicSettingDlg(STopicItem *pTopicItem, BOOL bModify); // bModify=FALSE, then Add new Topic
	virtual ~CTopicSettingDlg();
	enum { IDD = IDD_DLG_TOPIC_SETTING };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);
	virtual BOOL OnInitDialog();

	virtual void OnOK();
	virtual void OnCancel();

	DECLARE_MESSAGE_MAP()

private:
	STopicItem *m_pTopicItem;
	BOOL		m_bModify; // Modify or Add new Topic

	CString m_strMsgKey;
	CString m_strMsgType;
	CString m_strMsgTypeDes;

	CString m_strSQLExpression;
	CString m_strLanguage;

	CAsCoolGridCtrl m_gridSQLPreview;
	CAxRichEditEx	m_editSQL;

private:
	void InitCtrls();

	BOOL UpdateTopicItem(STopicItem *pTopicItem, BOOL bSaveToItem);
};
