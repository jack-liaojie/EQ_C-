// TopicSettingDlg.cpp : implementation file
//

#include "stdafx.h"
#include "TVDataServer.h"
#include "TVTableSettingDlg.h"
#include "TVDataManager.h"

// CTVTableSettingDlg dialog

IMPLEMENT_DYNAMIC(CTVTableSettingDlg, CDialog)

//the key words used in SQL Script
static LPCTSTR s_SQLKeywords = _T(" ACTION ADD AGGREGATE ALL ALTER AFTER AND AS ")
_T(" ASC AVG AVG_ROW_LENGTH AUTO_INCREMENT BETWEEN BIGINT BIT BINARY BLOB BOOL BOTH BY ")
_T(" CASCADE CASE CHAR CHARACTER CHANGE CHECK CHECKSUM COLUMN COLUMNS COMMENT CONSTRAINT CREATE ") 
_T(" CROSS CURRENT_DATE CURRENT_TIME CURRENT_TIMESTAMP DATA DATABASE DATABASES DATE DAY_SECOND DAYOFMONTH DAYOFWEEK DAYOFYEAR ") 
_T(" DEC DECIMAL DEFAULT DELAYED DELAY_KEY_WRITE DELETE DESC DESCRIBE DISTINCT DISTINCTROW DOUBLE DROP ") 
_T(" END ELSE ESCAPE ESCAPED ENCLOSED ENUM EXPLAIN EXISTS ") 
_T(" FIELDS FILE FIRST FLOAT	FLOAT4 FLOAT8 FLUSH FOREIGN FROM FOR FULL FUNCTION ") 
_T(" GLOBAL GRANT GRANTS GROUP HAVING HEAP HIGH_PRIORITY HOUR HOUR_MINUTE HOUR_SECOND HOSTS IDENTIFIED ") 
_T(" IGNORE IN INDEX INFILE INNER INSERT INSERT_ID INT INTEGER INTERVAL INT1 INT2 ") 
_T(" INT3 INT4 INT8 INTO IF IS ISAM JOIN KEY KEYS KILL LAST_INSERT_ID LEADING LEFT LENGTH LIKE ") 
_T(" LINES LIMIT LOAD LOCAL LOCK LOGS LONG LONGBLOB LONGTEXT LOW_PRIORITY MAX MAX_ROWS MATCH MEDIUMBLOB MEDIUMTEXT MEDIUMINT ") 
_T(" MIDDLEINT MIN_ROWS MINUTE MINUTE_SECOND MODIFY MONTH MONTHNAME MYISAM NATURAL NUMERIC NO NOT ") 
_T(" NULL ON OPTIMIZE OPTION	OPTIONALLY OR ORDER OUTER OUTFILE PACK_KEYS PARTIAL PASSWORD ") 
_T(" PRECISION PRIMARY PROCEDURE PROCESS	PROCESSLIST PRIVILEGES READ REAL REFERENCES RELOAD REGEXP RENAME ") 
_T(" REPLACE RESTRICT RETURNS REVOKE RLIKE ROW ROWS SECOND SELECT SET SHOW SHUTDOWN ") 
_T(" SMALLINT SONAME SQL_BIG_TABLES SQL_BIG_SELECTS SQL_LOW_PRIORITY_UPDATES SQL_LOG_OFF SQL_LOG_UPDATE SQL_SELECT_LIMIT ") 
_T(" SQL_SMALL_RESULT SQL_BIG_RESULT SQL_WARNINGS STRAIGHT_JOIN STARTING STATUS STRING TABLE ") 
_T(" TABLES TEMPORARY TERMINATED TEXT THEN TIME TIMESTAMP TINYBLOB TINYTEXT TINYINT TRAILING TO ") 
_T(" TYPE USE USING UNIQUE 	UNLOCK UNSIGNED UPDATE USAGE VALUES VARCHAR VARIABLES VARYING ") 
_T(" VARBINARY WITH WRITE WHEN WHERE YEAR YEAR_MONTH ZEROFILL EXEC "); 

CTVTableSettingDlg::CTVTableSettingDlg(CTVTable *pTVTable, BOOL bModify)
: CDialog(CTVTableSettingDlg::IDD) 
,m_pTVTable(pTVTable), m_bModify(bModify)
, m_strTableName(_T(""))
, m_strTableLevelType(_T(""))
, m_strSQLExpression(_T(""))
, m_strParam1(_T(""))
, m_strParam2(_T(""))
, m_strSQLPreview(_T(""))

{
}

CTVTableSettingDlg::~CTVTableSettingDlg()
{
}

void CTVTableSettingDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);

	DDX_Text(pDX, IDC_EDIT_TABLE_NAME, m_strTableName);
	DDX_CBString(pDX, IDC_CMB_TABLELEVEL_TYPE, m_strTableLevelType);
	DDX_Text(pDX, IDC_EDIT_TABLE_SQLEXPRESSION, m_strSQLExpression);
	DDX_Text(pDX, IDC_EDIT_P1, m_strParam1);
	DDX_Text(pDX, IDC_EDIT_P2, m_strParam2);
	DDX_Text(pDX, IDC_EDIT_SQL_PREVIEW, m_strSQLPreview);
}


BEGIN_MESSAGE_MAP(CTVTableSettingDlg, CDialog)
	ON_BN_CLICKED(IDC_BTN_SQLPREVIEW, OnBtnSQLPreview)
	ON_CBN_SELCHANGE(IDC_CMB_TABLELEVEL_TYPE, &CTVTableSettingDlg::OnSelchangeCmbTablelevelType)
END_MESSAGE_MAP()


// CTVTableSettingDlg message handlers

BOOL CTVTableSettingDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	InitCtrls();

	UpdateTVTableItem(m_pTVTable, FALSE);
	UpdateData(FALSE);

	OnSelchangeCmbTablelevelType();

	return TRUE; 
}

void CTVTableSettingDlg::InitCtrls()
{
	// Init SQL EditCtrl with colored keywords
	CRect rcEditSQL;
	GetDlgItem(IDC_EDIT_TABLE_SQLEXPRESSION)->GetWindowRect(&rcEditSQL);
	GetDlgItem(IDC_EDIT_TABLE_SQLEXPRESSION)->DestroyWindow();
	ScreenToClient(&rcEditSQL);
	m_editSQL.Create(this, rcEditSQL, IDC_EDIT_TABLE_SQLEXPRESSION, WS_EX_STATICEDGE, WS_CHILD|WS_VISIBLE|WS_HSCROLL|WS_VSCROLL|ES_MULTILINE|ES_WANTRETURN );
	m_editSQL.AddKeywords( CString(s_SQLKeywords) );
	m_editSQL.SetFocus();

	InitComboBoxList();
	CreateSQLPreviewGrid();

	// Disable TopicID when modify mode
	if (m_bModify)
	{
		GetDlgItem(IDC_EDIT_TABLE_NAME)->EnableWindow(FALSE);
	}

	// Set Dlg title with Discipline Code
	CString strDlgTitle;
	GetWindowText(strDlgTitle);
	strDlgTitle += _T(" - ") + theApp.GetDisciplineCode();
	SetWindowText(strDlgTitle);
}

void CTVTableSettingDlg::InitComboBoxList()
{
	CComboBox* pCmbTableLevelType = (CComboBox*)GetDlgItem(IDC_CMB_TABLELEVEL_TYPE);
	ASSERT(pCmbTableLevelType != NULL);

	pCmbTableLevelType->ResetContent();

	pCmbTableLevelType->AddString(NodeType2String(emTypeUnknown));
	pCmbTableLevelType->AddString(NodeType2String(emTypeDiscipline));
	pCmbTableLevelType->AddString(NodeType2String(emTypeSession));
	pCmbTableLevelType->AddString(NodeType2String(emTypeEvent));
	pCmbTableLevelType->AddString(NodeType2String(emTypeCourt));
}

BOOL CTVTableSettingDlg::CreateSQLPreviewGrid()
{
	CRect rcSQLPreviewGrid;
	CWnd *pSQLPreviewWnd = GetDlgItem(IDC_STC_GRID_SQLPREVIEW);
	pSQLPreviewWnd->GetWindowRect(rcSQLPreviewGrid);
	ScreenToClient(rcSQLPreviewGrid);
	pSQLPreviewWnd->DestroyWindow();

	if (!m_gridSQLPreview.Create(rcSQLPreviewGrid, this, IDC_STC_GRID_SQLPREVIEW)) return FALSE;
	m_gridSQLPreview.SetEditable(FALSE);

	return TRUE;
}

BOOL CTVTableSettingDlg::UpdateTVTableItem(CTVTable *pTVTable, BOOL bSaveToItem)
{
	if (!pTVTable) return FALSE;

	if (bSaveToItem) // From Dlg to Item structure
	{
		pTVTable->m_strTableName = m_strTableName;
		pTVTable->m_emTableLevelType = Str2NodeType(m_strTableLevelType);
		pTVTable->m_strSQLProcedure = m_strSQLExpression;
	}
	else //  From Item structure to Dlg
	{	
		m_strTableName = pTVTable->m_strTableName;
		m_strTableLevelType = NodeType2String(pTVTable->m_emTableLevelType);

		m_strSQLExpression = pTVTable->m_strSQLProcedure;

		CComboBox* pCmbTableLevelType = (CComboBox*)GetDlgItem(IDC_CMB_TABLELEVEL_TYPE);

		if (!pCmbTableLevelType) return FALSE;

		pCmbTableLevelType->SelectString(-1, m_strTableLevelType);
	}

	return TRUE;
}

void CTVTableSettingDlg::OnOK()
{
	UpdateData();

	// TopicID validity check
	if (!m_bModify)
	{
		if ( g_TVDataManager.m_TableTemplates.FindTableIndex(m_strTableName) >= 0) // TableName must be unique
		{
			AfxMessageBox(_T("The TableName has been exist !"));
			return;
		}
	}
	
	// SQL Expression validity check	
	//BOOL bValidSQL = FALSE;
	//if (!m_strSQLExpression.IsEmpty())
	//{
	//	CAxADORecordSet mpRecordSet(theApp.GetDataBase());
	//	if ( mpRecordSet.Open(m_strSQLExpression) )
	//	{
	//		SAxTableRecordSet stRecordSet;
	//		AxCommonTransRecordSet(mpRecordSet, stRecordSet);
	//		if (stRecordSet.GetFieldsCount() > 0 )
	//		{
	//			bValidSQL = TRUE;
	//		}
	//	}
	//}
	//if (!bValidSQL)
	//{
	//	AfxMessageBox(_T("SQL Expression is invalid!"));
	//	return;
	//}

	// Save data to TopicItem
	UpdateTVTableItem(m_pTVTable, TRUE);

	CDialog::OnOK();
}

void CTVTableSettingDlg::OnCancel()
{
	CDialog::OnCancel();
}

void CTVTableSettingDlg::OnBtnSQLPreview()
{
	UpdateData();

	if (Str2NodeType(m_strTableLevelType) == emTypeUnknown)
		return;

	m_strSQLPreview = CTVTable::ParseSQLExpression(m_strSQLExpression, m_strParam1, m_strParam2);
	UpdateData(FALSE);

	m_gridSQLPreview.SetRowCount(0);

	try
	{
		CAxADORecordSet adoRecordSet(theApp.GetDataBase());	
		if (adoRecordSet.Open(m_strSQLPreview))
		{
			AxCommonFillGridCtrl(&m_gridSQLPreview, adoRecordSet);
		}
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
	}
	catch(...)
	{

	}
}

void CTVTableSettingDlg::OnSelchangeCmbTablelevelType()
{
	UpdateData();

	if (m_pTVTable->m_strTableName == STR_EVENTGRD_TABLENAME || m_pTVTable->m_strTableName == STR_SESSIONSTS_TABLENAME)
	{
		GetDlgItem(IDC_EDIT_P1)->EnableWindow(FALSE);
		GetDlgItem(IDC_EDIT_P2)->EnableWindow(FALSE);
		GetDlgItem(IDC_EDIT_TABLE_SQLEXPRESSION)->EnableWindow(FALSE);

		if (m_pTVTable->m_strTableName == STR_EVENTGRD_TABLENAME)
		{
			GetDlgItem(IDC_CMB_TABLELEVEL_TYPE)->EnableWindow(FALSE);
		}
		
		return;
	}

	switch (Str2NodeType(m_strTableLevelType))
	{
	case emTypeUnknown:
		GetDlgItem(IDC_EDIT_P1)->EnableWindow(FALSE);
		GetDlgItem(IDC_EDIT_P2)->EnableWindow(FALSE);
		SetDlgItemText(IDC_STC_P1, _T("[@P1]"));
		SetDlgItemText(IDC_STC_P2, _T("[@P2]"));

		break;
	case emTypeCourt:
		GetDlgItem(IDC_EDIT_P1)->EnableWindow(TRUE);
		GetDlgItem(IDC_EDIT_P2)->EnableWindow(TRUE);
		SetDlgItemText(IDC_STC_P1, _T("[@P1](=CourtID)"));
		SetDlgItemText(IDC_STC_P2, _T("[@P2](=SessionID)"));
		break;
	case emTypeSession:
		GetDlgItem(IDC_EDIT_P1)->EnableWindow(TRUE);
		GetDlgItem(IDC_EDIT_P2)->EnableWindow(FALSE);
		SetDlgItemText(IDC_STC_P1, _T("[@P1](=SessionID)"));
		SetDlgItemText(IDC_STC_P2, _T("[@P2]"));
		break;
	case emTypeEvent:
		GetDlgItem(IDC_EDIT_P1)->EnableWindow(TRUE);
		GetDlgItem(IDC_EDIT_P2)->EnableWindow(FALSE);
		SetDlgItemText(IDC_STC_P1, _T("[@P1](=EventID)"));
		SetDlgItemText(IDC_STC_P2, _T("[@P2]"));
		break;
	case emTypeDiscipline:
		GetDlgItem(IDC_EDIT_P1)->EnableWindow(TRUE);
		GetDlgItem(IDC_EDIT_P2)->EnableWindow(FALSE);
		SetDlgItemText(IDC_STC_P1, _T("[@P1](=DisciplineID)"));
		SetDlgItemText(IDC_STC_P2, _T("[@P2]"));

		break;
	}
}
