
#include "stdafx.h"
#include "ExportDBSetting.h"
#include "CRSInfoServerDlg.h"

CExportDBSetting::CExportDBSetting(CWnd *pParent)
{
	m_pParent = pParent;
	m_pDatabase = NULL;
}

CExportDBSetting::~CExportDBSetting()
{

}

void CExportDBSetting::InitExportDBSetting(CAxADODataBase* pDatabase, CString strDBTableName, CString strDisciplineCode)
{
	m_pDatabase = pDatabase;
	m_strDBTableName = strDBTableName;
	m_strDisciplineCode = strDisciplineCode;

	CString strModualPath;
	AxCommonGetModulePath(strModualPath, NULL);

	m_strExportFileFullName = strModualPath.TrimRight(_T("\\")) + _T("\\") + strDBTableName + _T("_") + strDisciplineCode + _T(".sql");

}

void CExportDBSetting::ShowPopupMenu(CPoint &pt)
{
	CMenu menu;
	menu.CreatePopupMenu();

	menu.AppendMenu(MF_ENABLED|MF_STRING, COMMANDID_EXPORT, _T("Export CRSInfo setting"));
	menu.AppendMenu(MF_ENABLED|MF_STRING, COMMANDID_IMPORT, _T("Import CRSInfo setting"));

	menu.TrackPopupMenu(TPM_LEFTALIGN, pt.x, pt.y, m_pParent);
}

BOOL CExportDBSetting::OnCommand(WPARAM wParam, LPARAM lParam)
{
	UINT nCmdID = LOWORD(wParam);
	if (nCmdID == COMMANDID_IMPORT)
	{
		ImportSettingFromFile();
		return TRUE;
	}
	else if (nCmdID == COMMANDID_EXPORT)
	{
		ExportSettingToFile();
		return TRUE;
	}

	return FALSE;
}

void CExportDBSetting::ExportSettingToFile()
{
	if( !m_pDatabase->IsOpen())
	{
		m_pDatabase->Open(m_pDatabase->GetConnectionString());
	}

	// Open destination file
	CAxStdioFileEx file;
	if (!file.Open(m_strExportFileFullName, CFile::modeCreate|CFile::modeReadWrite|CFile::typeText|CFile::shareDenyWrite|CAxStdioFileEx::modeWriteUnicode))
	{
		AfxMessageBox(_T("Open File \"") + m_strExportFileFullName + _T("\" error!"));
		return;
	}

	// Get Export content
	CString strSQL;
	strSQL.Format(_T("EXEC [Proc_Gen_Config_InsertSQL] '%s','%s' "), m_strDBTableName, m_strDisciplineCode);
	CAxADORecordSet recordSet(m_pDatabase);
	
	// Export to file

	try
	{
		if( recordSet.Open(strSQL))
		{
			recordSet.MoveFirst();
			while( !recordSet.IsEOF() )
			{
				CString strValue;
				recordSet.GetFieldValue(0, strValue);

				file.WriteString(strValue + _T(" \r\n"));

				recordSet.MoveNext();
			}	
			file.Close();
		}
		else
		{
			AfxMessageBox(_T("Export File \"") + m_strExportFileFullName + _T("\" fail!"));
			return;
		}

		AfxMessageBox(_T("Export File \"") + m_strExportFileFullName + _T("\" success!"));

	}
	catch (CAxADOException &e)
	{
		AfxMessageBox(e.GetErrorMessage());
	}
	catch (...)
	{
		return;
	}
}

void CExportDBSetting::ImportSettingFromFile()
{
	if( !m_pDatabase->IsOpen())
	{
		m_pDatabase->Open(m_pDatabase->GetConnectionString());
	}

	// Open destination file
	CAxStdioFileEx file;
	if (!file.Open(m_strExportFileFullName, CFile::modeRead|CFile::typeText|CFile::shareDenyWrite))
	{
		AfxMessageBox(_T("Open File \"") + m_strExportFileFullName + _T("\" error!"));
		return;
	}

	CString strSQL;
	CString strLine;
	while (file.ReadString(strLine))
	{
		strSQL += strLine;
	}

	CAxADOCommand cmdADO(m_pDatabase);
	cmdADO.SetText(strSQL);
	try
	{
		if ( cmdADO.Execute(CAxADOCommand::emTypeCmdText))
		{
			AfxMessageBox(_T("Import ") + m_strDBTableName + _T(" success!"));
		}
		else
		{
			AfxMessageBox(_T("Import ") + m_strDBTableName + _T(" fail!"));
		}
	}
	catch (CAxADOException &e)
	{
		AfxMessageBox(e.GetErrorMessage());
	}

	file.Close();

	// Update the UI
	if (m_pParent->IsKindOf(RUNTIME_CLASS(CCRSInfoServerDlg)))
	{
		CCRSInfoServerDlg* pDlg = (CCRSInfoServerDlg*)m_pParent;

		pDlg->LoadTopicList();
		pDlg->ShowTopicList();
	}
}