
// AdoQueryForm.cpp : implementation file
//

#include "stdafx.h"
#include "Resource.h"
#include "SystemSetupDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CSystemSetupDlg dialog

CSystemSetupDlg::CSystemSetupDlg(CAxADODataBase *pDataBase, CWnd* pParent /*=NULL*/)
: CDialog ( IDD, pParent ) , m_pDataBase(pDataBase)
{
	m_bNotEncrypte = FALSE;

	m_strDisciplineCode = _T(""); 
	m_strServer = _T("");
	m_strDatabase = _T("");
	m_strUser = _T("");
	m_strPassword = _T("");

	m_ftDisciplineCode.CreateFont( 20,0,0,0,700,0,0,0, ANSI_CHARSET,OUT_DEFAULT_PRECIS,
		CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH|FF_DONTCARE,
		_T("Arial Bold"));
}

CSystemSetupDlg::~CSystemSetupDlg()
{

}

void CSystemSetupDlg::OnDestroy()
{
	WriteConfig();

	CDialog::OnDestroy();
}

void CSystemSetupDlg::DoDataExchange(CDataExchange* pDX)
{	
	CDialog::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_EDIT_DISCIPLINE_CODE, m_strDisciplineCode);
	DDX_Text(pDX, IDC_EDIT_SERVER, m_strServer);
	DDX_Text(pDX, IDC_EDIT_DATABASE, m_strDatabase);
	DDX_Text(pDX, IDC_EDIT_USER, m_strUser);
	DDX_Text(pDX, IDC_EDIT_PASSWORD, m_strPassword);
}

BEGIN_MESSAGE_MAP( CSystemSetupDlg, CDialog )
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_BTN_TEST, OnBtnTest)
	ON_BN_CLICKED(IDC_BTN_DB_SETUP, OnBtnDBSetup)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSystemSetupDlg message handlers

#define IDR_MAINFRAME 128 // assume theApp icon ID is 128

BOOL CSystemSetupDlg::OnInitDialog() 
{
	CDialog:: OnInitDialog();

	SetIcon(LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDR_MAINFRAME)), TRUE);

	m_brDlgBkColor.CreateSolidBrush(OVR_CLIENT_3DFACE);

	CWnd* pEdit = GetDlgItem(IDC_EDIT_DISCIPLINE_CODE);
	AxCommonSetCtrlFont(pEdit, &m_ftDisciplineCode);

	pEdit = GetDlgItem(IDC_EDIT_SERVER);
	AxCommonSetCtrlFont(pEdit, &m_ftDisciplineCode);

	pEdit = GetDlgItem(IDC_EDIT_DATABASE);
	AxCommonSetCtrlFont(pEdit, &m_ftDisciplineCode);

	pEdit = GetDlgItem(IDC_EDIT_USER);
	AxCommonSetCtrlFont(pEdit, &m_ftDisciplineCode);

	pEdit = GetDlgItem(IDC_EDIT_PASSWORD);
	AxCommonSetCtrlFont(pEdit, &m_ftDisciplineCode);

	ReadConfig();

	UpdateData(FALSE);

	return TRUE;
}

void CSystemSetupDlg::OnBtnDBSetup()
{
	UpdateData();

	CAxADOOLEDBDataLink dtlnk;
	
	CString strRealPassword = StringEncryptEncode(m_strPassword);
	CString strConString = CAxADOUtils::MakeOLEDB_SQLServer(m_strServer, m_strDatabase, m_strUser, m_bNotEncrypte ? m_strPassword : strRealPassword);
	try
	{
		strConString = dtlnk.Edit(strConString, this->GetSafeHwnd());
	}
	catch(CAxADOOLEDBException &e)
	{
		AfxMessageBox(_T("原数据库配置不正确！"));

		try
		{
			strConString = dtlnk.New(this->GetSafeHwnd());
		}
		catch (CAxADOOLEDBException &e)
		{
			strConString = _T("");
		}
	}

	CAxADOUtils::ParseOLEDB_SQLServer_ConStr(strConString, m_strServer, m_strDatabase, m_strUser, strRealPassword);
	UpdateData(FALSE);

	return;
}

void CSystemSetupDlg::OnBtnTest() 
{
	UpdateData();

	if( m_strServer.IsEmpty() || m_strDatabase.IsEmpty() ||
		m_strUser.IsEmpty() || m_strPassword.IsEmpty())
		return;

	CString strRealPassword = StringEncryptEncode(m_strPassword);

	CString strConString = CAxADOUtils::MakeOLEDB_SQLServer(m_strServer, m_strDatabase, m_strUser, m_bNotEncrypte ? m_strPassword : strRealPassword);
	CAxADODataBase obDatabase;

	try
	{
		BOOL bRet = obDatabase.Open(strConString );
		if(bRet)
		{
			AfxMessageBox(_T("测试连接成功!"));
		}
		else
		{
			CString strError;
			strError.Format(_T("测试连接失败！%s."), obDatabase.GetLastErrorString());
			AfxMessageBox(strError);
		}	
		
		obDatabase.Close();
	}
	catch (CAxADOException& e)
	{
		AfxMessageBox(e.GetErrorMessage());
	}
}

void CSystemSetupDlg::ReadConfig()
{
	CAxReadWriteINI::IniReadString(_T("COMMON_SETUP"), _T("DB_DisciplineCode"), m_strDisciplineCode, m_strAppConfigFile);
	CAxReadWriteINI::IniReadString(_T("COMMON_SETUP"), _T("DB_Server"), m_strServer, m_strAppConfigFile);
	CAxReadWriteINI::IniReadString(_T("COMMON_SETUP"), _T("DB_Database"), m_strDatabase, m_strAppConfigFile);
	CAxReadWriteINI::IniReadString(_T("COMMON_SETUP"), _T("DB_User"), m_strUser, m_strAppConfigFile);
	CAxReadWriteINI::IniReadString(_T("COMMON_SETUP"), _T("DB_Password"), m_strPassword, m_strAppConfigFile);
	CAxReadWriteINI::IniReadInt(_T("COMMON_SETUP"), _T("DB_NotEncrypte"), m_bNotEncrypte, m_strAppConfigFile);
}

void CSystemSetupDlg::WriteConfig()
{
	CAxReadWriteINI::IniWriteString(_T("COMMON_SETUP"), _T("DB_DisciplineCode"), m_strDisciplineCode, m_strAppConfigFile);
	CAxReadWriteINI::IniWriteString(_T("COMMON_SETUP"), _T("DB_Server"), m_strServer, m_strAppConfigFile);
	CAxReadWriteINI::IniWriteString(_T("COMMON_SETUP"), _T("DB_Database"), m_strDatabase, m_strAppConfigFile);
	CAxReadWriteINI::IniWriteString(_T("COMMON_SETUP"), _T("DB_User"), m_strUser, m_strAppConfigFile);
	CAxReadWriteINI::IniWriteString(_T("COMMON_SETUP"), _T("DB_Password"), m_strPassword, m_strAppConfigFile);
	CAxReadWriteINI::IniWriteInt(_T("COMMON_SETUP"), _T("DB_NotEncrypte"), m_bNotEncrypte, m_strAppConfigFile);
}

void CSystemSetupDlg::OnOK() 
{
	UpdateData();

	if(m_strDisciplineCode.IsEmpty())
	{
		AfxMessageBox(_T("请输入当前项目编码!"));
		return ;
	}

	if(m_strServer.IsEmpty())
	{
		AfxMessageBox(_T("请输入服务器IP或名称!"));
		return ;
	}

	if(m_strDatabase.IsEmpty())
	{
		AfxMessageBox(_T("请输入数据库名称!"));
		return;
	}

	if(m_strUser.IsEmpty())
	{
		AfxMessageBox(_T("请输入正确的登录帐号!"));
		return ;
	}

	if(m_strPassword.IsEmpty())
	{
		AfxMessageBox(_T("请输入正确的登录密码!"));
		return ;
	}

	CString strRealPassword = StringEncryptEncode(m_strPassword);
	CString strConString = CAxADOUtils::MakeOLEDB_SQLServer(m_strServer, m_strDatabase, m_strUser, m_bNotEncrypte ? m_strPassword : strRealPassword);
	try
	{
		if( !m_pDataBase->Open(strConString))
		{
			AfxMessageBox(_T("打开数据库失败, 请重新设置!"));
			return;
		}
	}
	catch (CAxADOException &e)
	{
		AfxMessageBox(e.GetErrorMessage());
		return;
	}

	WriteConfig();	

	CDialog::OnOK();
}
