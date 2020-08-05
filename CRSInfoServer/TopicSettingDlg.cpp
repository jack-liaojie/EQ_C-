// TopicSettingDlg.cpp : implementation file
//

#include "stdafx.h"
#include "CRSInfoServer.h"
#include "TopicSettingDlg.h"
#include "CRSPublicDef.h"

extern CCRSInfoServerApp theApp;

// CTopicSettingDlg dialog

IMPLEMENT_DYNAMIC(CTopicSettingDlg, CDialog)

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
_T(" LINES LIMIT LOAD LOCAL LOCK LOGS LONG LONGBLOB LONGTEXT LOW_PRIORITY MAX MAX_ROWS MEDIUMBLOB MEDIUMTEXT MEDIUMINT ") // MATCH -- deleted
_T(" MIDDLEINT MIN_ROWS MINUTE MINUTE_SECOND MODIFY MONTH MONTHNAME MYISAM NATURAL NUMERIC NO NOT ") 
_T(" NULL ON OPTIMIZE OPTION	OPTIONALLY OR ORDER OUTER OUTFILE PACK_KEYS PARTIAL PASSWORD ") 
_T(" PRECISION PRIMARY PROCEDURE PROCESS	PROCESSLIST PRIVILEGES READ REAL REFERENCES RELOAD REGEXP RENAME ") 
_T(" REPLACE RESTRICT RETURNS REVOKE RLIKE ROW ROWS SECOND SELECT SET SHOW SHUTDOWN ") 
_T(" SMALLINT SONAME SQL_BIG_TABLES SQL_BIG_SELECTS SQL_LOW_PRIORITY_UPDATES SQL_LOG_OFF SQL_LOG_UPDATE SQL_SELECT_LIMIT ") 
_T(" SQL_SMALL_RESULT SQL_BIG_RESULT SQL_WARNINGS STRAIGHT_JOIN STARTING STATUS STRING TABLE ") 
_T(" TABLES TEMPORARY TERMINATED TEXT THEN TIME TIMESTAMP TINYBLOB TINYTEXT TINYINT TRAILING TO ") 
_T(" USE USING UNIQUE 	UNLOCK UNSIGNED UPDATE USAGE VALUES VARCHAR VARIABLES VARYING ") //TYPE
_T(" VARBINARY WITH WRITE WHEN WHERE YEAR YEAR_MONTH ZEROFILL EXEC "); 

CTopicSettingDlg::CTopicSettingDlg(STopicItem *pTopicItem, BOOL bModify)
: CDialog(CTopicSettingDlg::IDD) 
,m_pTopicItem(pTopicItem), m_bModify(bModify)
{
}

CTopicSettingDlg::~CTopicSettingDlg()
{
}

void CTopicSettingDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_EDIT_TOPIC_KEY, m_strMsgKey);
	DDX_Text(pDX, IDC_EDIT_TOPIC_ID, m_strMsgType);
	DDX_Text(pDX, IDC_EDIT_TOPIC_NAME, m_strMsgTypeDes);

	DDX_Text(pDX, IDC_EDIT_TOPIC_SQLEXPRESSION, m_strSQLExpression);
	DDX_Text(pDX, IDC_EDIT_LANG, m_strLanguage);
}


BEGIN_MESSAGE_MAP(CTopicSettingDlg, CDialog)
END_MESSAGE_MAP()


// CTopicSettingDlg message handlers

BOOL CTopicSettingDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	InitCtrls();

	UpdateTopicItem(m_pTopicItem, FALSE);
	UpdateData(FALSE);

	return TRUE; 
}

void CTopicSettingDlg::InitCtrls()
{
	// Init SQL EditCtrl with colored keywords
	CRect rcEditSQL;
	GetDlgItem(IDC_EDIT_TOPIC_SQLEXPRESSION)->GetWindowRect(&rcEditSQL);
	GetDlgItem(IDC_EDIT_TOPIC_SQLEXPRESSION)->DestroyWindow();
	ScreenToClient(&rcEditSQL);
	m_editSQL.Create(this, rcEditSQL, IDC_EDIT_TOPIC_SQLEXPRESSION, WS_EX_STATICEDGE, WS_CHILD|WS_VISIBLE|WS_HSCROLL|WS_VSCROLL|ES_MULTILINE|ES_WANTRETURN );
	m_editSQL.AddKeywords( CString(s_SQLKeywords) );
	m_editSQL.SetFocus();

	// Disable TopicID when modify mode
	if (m_bModify)
	{
		GetDlgItem(IDC_EDIT_TOPIC_KEY)->EnableWindow(FALSE);
	}

	// Set Dlg title with Discipline Code
	CString strDlgTitle;
	GetWindowText(strDlgTitle);
	strDlgTitle += _T(" - ") + theApp.GetDisciplineCode();
	SetWindowText(strDlgTitle);

	// Set node level combobox
	CComboBox *pCmb = (CComboBox *)GetDlgItem(IDC_CMB_LEVEL);
	if (pCmb)
	{
		pCmb->Clear();
		for (int i=emTypeUnknown; i <= emTypeMatch; i++)
		{
			pCmb->AddString(NodeType2String((EMCRSNodeType)i));
		}
	}

	// Set Default key words
	SetDlgItemText(IDC_EDIT_KEYWORDS, _T("Key Words:\r\n@Lang @RSC @Discipline @Event @Phase @Unit @Gender @Venue @Date @DisciplineID @EventID @PhaseID @MatchID @SessionID @CourtID @MsgType @bAuto"));
}

BOOL CTopicSettingDlg::UpdateTopicItem(STopicItem *pTopicItem, BOOL bSaveToItem)
{
	if (!pTopicItem) return FALSE;

	ENTER_OBJ_THREAD_SAFETY(pTopicItem->m_CriticalSection)

	if (bSaveToItem) // From Dlg to Item structure
	{
		pTopicItem->m_strDisciplineCode = theApp.GetDisciplineCode();
		pTopicItem->m_strMsgKey = m_strMsgKey;
		pTopicItem->m_strMsgType = m_strMsgType;
		pTopicItem->m_strMsgName = m_strMsgTypeDes;

		GetDlgItemText(IDC_CMB_LEVEL, pTopicItem->m_strMsgLevel);

		pTopicItem->m_strSQLProcedure = m_strSQLExpression;
		pTopicItem->m_strLanguage = m_strLanguage;	
	}
	else //  From Item structure to Dlg
	{	
		m_strMsgKey = pTopicItem->m_strMsgKey;
		m_strMsgType = pTopicItem->m_strMsgType;
		m_strMsgTypeDes = pTopicItem->m_strMsgName;

		CComboBox *pCmb = (CComboBox*)GetDlgItem(IDC_CMB_LEVEL);
		pCmb->SelectString(-1, pTopicItem->m_strMsgLevel);

		m_strSQLExpression = pTopicItem->m_strSQLProcedure;
		m_strLanguage = pTopicItem->m_strLanguage;
	}

	return TRUE;
}

void CTopicSettingDlg::OnOK()
{
	UpdateData();

	// TopicID validity check
	if (!m_bModify)
	{
		if ( g_TopicManager.DoesTopicItemExist(m_strMsgKey) ) // TopicKey must be unique
		{
			AfxMessageBox(_T("The MsgType has been exist !"));
			return;
		}
	}

	// Save data to TopicItem
	UpdateTopicItem(m_pTopicItem, TRUE);

	CDialog::OnOK();
}

void CTopicSettingDlg::OnCancel()
{
	CDialog::OnCancel();
}

