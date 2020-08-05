
#pragma once

#include "stdafx.h"

#define COMMANDID_EXPORT	1234
#define COMMANDID_IMPORT	5678

class CExportDBSetting
{
public:
	CExportDBSetting(CWnd *pParent);
	~CExportDBSetting();

	void InitExportDBSetting(CAxADODataBase* pDatabase, CString strDBTableName, CString strDisciplineCode);
	void ShowPopupMenu(CPoint &pt);

	BOOL OnCommand(WPARAM wParam, LPARAM lParam);

private:
	CWnd* m_pParent;
	CAxADODataBase* m_pDatabase;
	CString m_strDBTableName;
	CString m_strDisciplineCode;

	CString m_strExportFileFullName;

	void ExportSettingToFile();
	void ImportSettingFromFile();
};

