
// InitialDownLoadDlg.cpp : ʵ���ļ�
//

#include "stdafx.h"
#include "InitialDownLoad.h"
#include "InitialDownLoadDlg.h"
#include "afxdialogex.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// ����Ӧ�ó��򡰹��ڡ��˵���� CAboutDlg �Ի���

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

	// �Ի�������
	enum { IDD = IDD_ABOUTBOX };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

	// ʵ��
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CInitialDownLoadDlg �Ի���




CInitialDownLoadDlg::CInitialDownLoadDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(CInitialDownLoadDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CInitialDownLoadDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_COMBO_WORK_SHEETS, m_cbWorkSheets);
}

BEGIN_MESSAGE_MAP(CInitialDownLoadDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_SIZE()
	ON_BN_CLICKED(IDC_BTN_OPEN_XLS_DATA, OnBtnOpenXLSData)
	ON_BN_CLICKED(IDC_BTN_CLEAN_ATHLETES, OnBtnCleanAthletes)
	ON_BN_CLICKED(IDC_BTN_IMPORT_ATHLETES, OnBtnImportAthletes)
	ON_BN_CLICKED(IDC_BTN_EXPORT_ATHLETES, OnBnExportAthletes)
	ON_BN_CLICKED(IDC_BTN_IMPORT_UNOFFICALS, OnBtnImportUnOfficals)
	ON_BN_CLICKED(IDC_BTN_EXPORT_OFFICALS, OnBnExportOfficals)
	ON_BN_CLICKED(IDC_BTN_REFRESH, &CInitialDownLoadDlg::OnBnClickedBtnRefresh)
END_MESSAGE_MAP()


// CInitialDownLoadDlg ��Ϣ�������

BOOL CInitialDownLoadDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// ��������...���˵�����ӵ�ϵͳ�˵��С�

	// IDM_ABOUTBOX ������ϵͳ���Χ�ڡ�
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// ���ô˶Ի����ͼ�ꡣ��Ӧ�ó��������ڲ��ǶԻ���ʱ����ܽ��Զ�
	//  ִ�д˲���
	SetIcon(m_hIcon, TRUE);			// ���ô�ͼ��
	SetIcon(m_hIcon, FALSE);		// ����Сͼ��

	// TODO: �ڴ���Ӷ���ĳ�ʼ������
	m_strDiscipline = theApp.GetDisciplineCode();
	CreateAthletesGrid();

	GetClientRect(&m_rect); //��Ӵ���

	return TRUE;  // ���ǽ��������õ��ؼ������򷵻� TRUE
}

void CInitialDownLoadDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// �����Ի��������С����ť������Ҫ����Ĵ���
//  �����Ƹ�ͼ�ꡣ����ʹ���ĵ�/��ͼģ�͵� MFC Ӧ�ó���
//  �⽫�ɿ���Զ���ɡ�

void CInitialDownLoadDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // ���ڻ��Ƶ��豸������

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// ʹͼ���ڹ����������о���
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// ����ͼ��
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

//���û��϶���С������ʱϵͳ���ô˺���ȡ�ù��
//��ʾ��
HCURSOR CInitialDownLoadDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}


//��Dialog���ReSize������

void CInitialDownLoadDlg::ReSize(int nID, int cx, int cy)
{
	CWnd *pWnd;
	pWnd = GetDlgItem(nID); //��ȡ�ؼ����
	if(pWnd)
	{
		CRect rect; //��ȡ�ؼ��仯ǰ��С
		pWnd->GetWindowRect(&rect);
		ScreenToClient(&rect);//���ؼ���Сת��Ϊ�ڶԻ����е���������
		rect.left=(int)(rect.left*((float)cx/(float)m_rect.Width()));//�����ؼ���С
		rect.right=(int)(rect.right*((float)cx/(float)m_rect.Width()));
		rect.top=(int)(rect.top*((float)cy/(float)m_rect.Height()));
		rect.bottom = (int)(rect.bottom*((float)cy/(float)m_rect.Height()));
		pWnd->MoveWindow(rect);//���ÿؼ�λ��
	}
} 


void CInitialDownLoadDlg::OnSize(UINT nType, int cx, int cy)
{
	CDialog::OnSize(nType, cx, cy);
	// TODO: Add your message handler code here
	if(nType!=SIZE_MINIMIZED) //�ж��Ƿ�Ϊ��С��
	{
		//ReSize(IDC_BTN_OPEN_XLS_DATA, cx, cy);
		GetClientRect(&m_rect);
	}
}

void CInitialDownLoadDlg::OnBtnOpenXLSData()
{
	CFileDialog dlg(TRUE, NULL, NULL, OFN_HIDEREADONLY|OFN_FILEMUSTEXIST, _T("*.xls|*.xls||"), this); 
	if (dlg.DoModal() == IDCANCEL) return;

	m_strFilePath = dlg.GetPathName();
	CEdit* pEditFilePath=(CEdit*)GetDlgItem(IDC_EDIT_FILE_PATH);
	pEditFilePath->SetWindowTextW(m_strFilePath);

	CEdit* pEditSheetName=(CEdit*)GetDlgItem(IDC_EDIT_SHEET_NAME);
	pEditSheetName->SetWindowTextW(_T("Sheet1"));

	//CStringArray arySheets;
	//if(GetWorkSheets(dlg.GetPathName(), arySheets))
	//{
	//	m_cbWorkSheets.ResetContent();
	//	for(int i = 0; i < arySheets.GetCount(); i++)
	//	{
	//		m_cbWorkSheets.AddString(arySheets.GetAt(i));
	//	}

	//	m_cbWorkSheets.SetCurSel(0);
	//	m_strSheetName = arySheets.GetAt(0);

	//}
}

void CInitialDownLoadDlg::OnBnClickedBtnRefresh()
{

	CEdit* pEditFilePath=(CEdit*)GetDlgItem(IDC_EDIT_FILE_PATH);
	pEditFilePath->GetWindowText(m_strFilePath);

	CEdit* pEditSheetName=(CEdit*)GetDlgItem(IDC_EDIT_SHEET_NAME);
	pEditSheetName->GetWindowText(m_strSheetName);
	


	CAxADODataBase obDataBase;

	CString strConString = _T("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=");
	strConString += m_strFilePath;
	strConString += _T(";Persist Security Info=False;Mode=Share Deny None");
	strConString += _T(";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=1\"");

	try
	{
		if( obDataBase.Open(strConString))
		{
			CString  strSQL;
			strSQL.Format(_T("SELECT * FROM [%s$]"), m_strSheetName);

			CAxADORecordSet obRecordSet(&obDataBase);
			if(obRecordSet.Open(strSQL))
			{
				AxCommonFillGridCtrl(&m_gridAthletes, obRecordSet);
			}
		}	
	}
	catch (CAxADOException &e)
	{
		AfxMessageBox(e.GetErrorMessage());
	}
}

BOOL CInitialDownLoadDlg::GetWorkSheets(CString strXLSName, CStringArray& arySheets)
{
	// Load the Excel application in the background.
	Excel::_ApplicationPtr pApplication;

	if ( FAILED( pApplication.CreateInstance( _T("Excel.Application") ) ) )
	{
		AfxMessageBox( _T("Failed to initialize Excel::_Application!") );
		return FALSE;
	}

	_variant_t	varOption( (long) DISP_E_PARAMNOTFOUND, VT_ERROR );
	Excel::_WorkbookPtr pBook = pApplication->Workbooks->Open( _bstr_t(strXLSName), varOption, varOption, varOption, varOption, varOption, varOption, varOption, varOption, varOption, varOption, varOption, varOption );

	if ( pBook == NULL )
	{
		AfxMessageBox( _T("Failed to open Excel file!") );
		pApplication->Quit( );
		return FALSE;
	}

	Excel::SheetsPtr pSheets = pBook ->GetWorksheets();
	if ( pSheets == NULL )
	{
		AfxMessageBox( _T("Failed to get Worksheets!") );
		pBook->Close( VARIANT_FALSE );
		pApplication->Quit( );
		return FALSE;
	}

	for(int i = 1; i <= pSheets->GetCount();i++ )
	{
		Excel::_WorksheetPtr pSheet = pBook->Sheets->Item[ i ];
		_bstr_t bstrSheetName;

		if ( pSheet == NULL ) continue;

		bstrSheetName = pSheet->GetName();
		arySheets.Add((LPCTSTR)bstrSheetName);
	}

	pBook->Close( VARIANT_FALSE );
	pApplication->Quit( );
	return TRUE;
}

void CInitialDownLoadDlg::OnBnExportAthletes()
{
	CFileDialog dlg(TRUE, NULL, NULL, OFN_HIDEREADONLY, _T("*.xls|*.xls||"), this); 
	if (dlg.DoModal() == IDCANCEL) return;

	CString strOutXLSFileName = dlg.GetPathName();
	strOutXLSFileName.Replace(_T(".xls"),_T(""));
	strOutXLSFileName = strOutXLSFileName +_T(".xls");

	//File Not Exists, Copy template!
	if (!AxCommonDoesFileExist(strOutXLSFileName))
	{
		CString strModualPath;
		AxCommonGetModulePath(strModualPath, NULL);
		CopyFile(strModualPath + _T("\ExportAthleteTemplate.xls"), strOutXLSFileName, FALSE);
	}

	try
	{
		CAxADOCommand cmd(theApp.GetDataBase(), _T("Proc_InitialDownload_GetDisciplineAthletes"));

		cmd.AddParameter(_T("@DisciplineCode"),CAxADORecordSet::emDataTypeVarWChar, CAxADOParameter::emParamInput,
			50, m_strDiscipline);

		CAxADORecordSet mpRecordSet(theApp.GetDataBase());

		if( mpRecordSet.Execute(&cmd) )
		{
			Write2Sheet(strOutXLSFileName, mpRecordSet);
		}

	}
	catch (CAxADOException &e)
	{
		AfxMessageBox(e.GetErrorMessage());
	}
}

BOOL CInitialDownLoadDlg::Write2Sheet(CString strXLSName, CAxADORecordSet& recordSet)
{
	SAxTableRecordSet rsTable;
	AxCommonTransRecordSet(recordSet, rsTable);

	// Load the Excel application in the background.
	Excel::_ApplicationPtr pApplication;

	if ( FAILED( pApplication.CreateInstance( _T("Excel.Application")) ) )
	{
		AfxMessageBox( _T("Failed to initialize Excel::_Application!") );
		return FALSE;
	}
	//Show Excel application.
	pApplication->Visible[0] = true;

	_variant_t	varOption( (long) DISP_E_PARAMNOTFOUND, VT_ERROR );
	Excel::_WorkbookPtr pBook = pApplication->Workbooks->Open( _bstr_t(strXLSName), varOption, varOption, varOption, varOption, varOption, varOption, varOption, varOption, varOption, varOption, varOption, varOption );

	if ( pBook == NULL )
	{
		AfxMessageBox( _T("Failed to open Excel file!") );
		pApplication->Quit( );
		return FALSE;
	}

	Excel::SheetsPtr pSheets = pBook ->GetWorksheets();
	if ( pSheets == NULL )
	{
		AfxMessageBox( _T("Failed to get Worksheets!") );
		pBook->Close( VARIANT_FALSE );
		pApplication->Quit( );
		return FALSE;
	}

	Excel::_WorksheetPtr pSheet = pBook->Sheets->Item[1];

	Excel::RangesPtr xlsCells;

	if(pSheet != NULL)
	{
		Excel::RangePtr pAllRange = pSheet->GetCells();

		for( int iFieldIdx = 0; iFieldIdx < rsTable.GetFieldsCount(); iFieldIdx++ )
		{
			pAllRange->Item[1][iFieldIdx + 1] =  _variant_t(rsTable.GetFieldName(iFieldIdx));
		}

		for( int iRowIdx = 0; iRowIdx < rsTable.GetRowRecordsCount(); iRowIdx++ )
		{
			for( int iFieldIdx = 0; iFieldIdx < rsTable.GetFieldsCount(); iFieldIdx++ )
			{
				pAllRange->Item[iRowIdx + 2][iFieldIdx + 1] = _variant_t(rsTable.GetValue(iFieldIdx, iRowIdx));
			}
		}
	}

	pBook->Save();
	pBook->Close( VARIANT_FALSE );
	pApplication->Quit( );


	return TRUE;
}

BOOL CInitialDownLoadDlg::CreateAthletesGrid()
{
	CRect rcAthletesGrid;
	GetDlgItem(IDC_GRID_RECT)->GetWindowRect(rcAthletesGrid);
	ScreenToClient(rcAthletesGrid);

	if (!m_gridAthletes.Create(rcAthletesGrid, this, IDC_GRID_RECT)) return FALSE;

	return TRUE;
}

void CInitialDownLoadDlg::OnBtnCleanAthletes()
{
	if (AfxMessageBox(_T("ɾ�����޷��ָ�����ע�⣡����ô��"),MB_OKCANCEL) == IDCANCEL)
		return;

	if ( !DisciplineExists() )
	{
		AfxMessageBox(_T("��@DisciplineCode��Ч!"));
		return;
	}

	try
	{
		CAxADOCommand cmd(theApp.GetDataBase(), _T("Proc_InitialDownload_DelRegisterByDiscipline"));

		CAxADOParameter pParamResult(CAxADORecordSet::emDataTypeInteger, sizeof(int),
			CAxADOParameter::emParamOutput);//result

		cmd.AddParameter(_T(""),CAxADORecordSet::emDataTypeInteger, CAxADOParameter::emParamInput,
			sizeof(int), m_nDisciplineID);

		cmd.AddParameter(&pParamResult);

		CAxADORecordSet mpRecordSet(theApp.GetDataBase());

		int nRetValue;

		if( mpRecordSet.Execute(&cmd) )
		{
			pParamResult.GetValue(nRetValue);
		}
		switch(nRetValue)
		{
		case 1:
			AfxMessageBox(_T("�����ɣ�"));
			break;
		case 0:
			AfxMessageBox(_T("���ʧ�ܣ�"));
			break;
		case -1:
			AfxMessageBox(_T("���ʧ�ܣ���@DisciplineID��Ч"));
			break;
		case -2:
			AfxMessageBox(_T("���ʧ�ܣ���@DisciplineID�µ��˶�Ա�Ѿ��вμӱ�������"));
			break;
		}

	}
	catch (CAxADOException &e)
	{
		AfxMessageBox(e.GetErrorMessage());
	}
}

void CInitialDownLoadDlg::OnBtnImportAthletes()
{
	if ( !DisciplineExists() )
	{
		AfxMessageBox(_T("��@DisciplineCode��Ч!"));
		return;
	}

	try
	{
		//��ʼ����ʱ��
		{
			CAxADOCommand cmdIntiTempTable(theApp.GetDataBase(), _T("Proc_InitialDownload_IntiTempRegisterTable"));

			CAxADOParameter pParamResult(CAxADORecordSet::emDataTypeInteger, sizeof(int),
				CAxADOParameter::emParamOutput);//result

			cmdIntiTempTable.AddParameter(&pParamResult);

			int nRetValue;

			if( cmdIntiTempTable.Execute() )
			{
				pParamResult.GetValue(nRetValue);
				if (nRetValue != 1)
				{
					AfxMessageBox(_T("��Ա�ͱ�����Ϣ����ʧ�ܣ���ʼ����ʱ����"));
					return;
				}
			}
		}

		//����Ա�ͱ�����Ϣ���뵽���ݿ��е���ʱ��
		{
			int iAthleteCount = m_gridAthletes.GetRowCount();
			//int iColumnCount = m_gridAthletes.GetColumnCount();
			int iColumnCount = 20;
			for (int i = 1; i < iAthleteCount; i++)
			{
				CAxADOCommand cmdInsertTempTable(theApp.GetDataBase(), _T("Proc_InitialDownload_Insert2TempTable"));

				cmdInsertTempTable.AddParameter(_T(""),CAxADORecordSet::emDataTypeVarChar, CAxADOParameter::emParamInput,
					sizeof(char)*50, m_strDiscipline);

				for(int j = 0; j<iColumnCount; j++)
				{
					cmdInsertTempTable.AddParameter(_T(""),CAxADORecordSet::emDataTypeVarChar, CAxADOParameter::emParamInput,
						sizeof(char)*255, m_gridAthletes.GetItemText(i,j));
				}

				CAxADOParameter pParamResult(CAxADORecordSet::emDataTypeInteger, sizeof(int), CAxADOParameter::emParamOutput);//result

				cmdInsertTempTable.AddParameter(&pParamResult);

				int nRetValue;

				if( cmdInsertTempTable.Execute() )
				{
					pParamResult.GetValue(nRetValue);
					if (nRetValue != 1)
						AfxMessageBox(_T("��Ա�ͱ�����Ϣ������ʱ�����"));
				}
			}
		}

		//����ʱ���е���Ա�ͱ�����Ϣ���µ����ݿ���
		{
			CAxADOCommand cmdUpdate2DB(theApp.GetDataBase(), _T("Proc_InitialDownload_UpdateRegister2DB"));

			cmdUpdate2DB.AddParameter(_T(""),CAxADORecordSet::emDataTypeVarChar, CAxADOParameter::emParamInput,
				sizeof(char)*50, m_strDiscipline);

			CAxADOParameter pParamResult(CAxADORecordSet::emDataTypeInteger, sizeof(int),
				CAxADOParameter::emParamOutput);//result

			cmdUpdate2DB.AddParameter(&pParamResult);

			int nRetValue;

			if( cmdUpdate2DB.Execute() )
			{
				pParamResult.GetValue(nRetValue);
				if (nRetValue != 1)
				{
					AfxMessageBox(_T("��Ա�ͱ�����Ϣ����ʧ�ܣ��������ݵ����ݿ����"));
					return;
				}
				else
				{
					AfxMessageBox(_T("��Ա�ͱ�����Ϣ����ɹ���"));
					return;
				}
			}
		}

	}
	catch (CAxADOException &e)
	{
		AfxMessageBox(e.GetErrorMessage());
	}
}

BOOL CInitialDownLoadDlg::DisciplineExists()
{
	CString  strSQL;
	strSQL.Format(_T("SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = '%s'"), m_strDiscipline);

	CAxADORecordSet obRecordSet(theApp.GetDataBase());

	try
	{
		if(	obRecordSet.Open(strSQL) )
		{
			if ( obRecordSet.GetRecordCount() > 0 )
			{
				obRecordSet.GetFieldValue(0, m_nDisciplineID);
				return TRUE;
			}
		}

		return FALSE;
	}
	catch (CAxADOException &e)
	{
		AfxMessageBox(e.GetErrorMessage());
		return FALSE;
	}
}




void CInitialDownLoadDlg::OnBtnImportUnOfficals()
{
	if ( !DisciplineExists() )
	{
		AfxMessageBox(_T("��@DisciplineCode��Ч!"));
		return;
	}

	try
	{
		//��ʼ����ʱ��
		{
			CAxADOCommand cmdIntiTempTable(theApp.GetDataBase(), _T("Proc_InitialDownload_IntiTempUnOfficialTable"));

			CAxADOParameter pParamResult(CAxADORecordSet::emDataTypeInteger, sizeof(int),
				CAxADOParameter::emParamOutput);//result

			cmdIntiTempTable.AddParameter(&pParamResult);

			int nRetValue;

			if( cmdIntiTempTable.Execute() )
			{
				pParamResult.GetValue(nRetValue);
				if (nRetValue != 1)
				{
					AfxMessageBox(_T("�Ǿ�����Ա��Ϣ����ʧ�ܣ���ʼ����ʱ����"));
					return;
				}
			}
		}

		//����Ա�ͱ�����Ϣ���뵽���ݿ��е���ʱ��
		{
			int iAthleteCount = m_gridAthletes.GetRowCount();
			//int iColumnCount = m_gridAthletes.GetColumnCount();
			int iColumnCount = 12;
			for (int i = 1; i < iAthleteCount; i++)
			{
				CAxADOCommand cmdInsertTempTable(theApp.GetDataBase(), _T("Proc_InitialDownload_InsertUnOfficials2TempTable"));

				cmdInsertTempTable.AddParameter(_T(""),CAxADORecordSet::emDataTypeVarChar, CAxADOParameter::emParamInput,
					sizeof(char)*50, m_strDiscipline);

				for(int j = 0; j<iColumnCount; j++)
				{
					cmdInsertTempTable.AddParameter(_T(""),CAxADORecordSet::emDataTypeVarChar, CAxADOParameter::emParamInput,
						sizeof(char)*255, m_gridAthletes.GetItemText(i,j));
				}

				CAxADOParameter pParamResult(CAxADORecordSet::emDataTypeInteger, sizeof(int), CAxADOParameter::emParamOutput);//result

				cmdInsertTempTable.AddParameter(&pParamResult);

				int nRetValue;

				if( cmdInsertTempTable.Execute() )
				{
					pParamResult.GetValue(nRetValue);
					if (nRetValue != 1)
						AfxMessageBox(_T("�Ǿ�����Ա��Ϣ������ʱ�����"));
				}
			}
		}

		//����ʱ���е���Ա�ͱ�����Ϣ���µ����ݿ���
		{
			CAxADOCommand cmdUpdate2DB(theApp.GetDataBase(), _T("Proc_InitialDownload_AutoSwitch_UpdateUnOfficials2DB"));

			cmdUpdate2DB.AddParameter(_T(""),CAxADORecordSet::emDataTypeVarChar, CAxADOParameter::emParamInput,
				sizeof(char)*50, m_strDiscipline);

			CAxADOParameter pParamResult(CAxADORecordSet::emDataTypeInteger, sizeof(int),
				CAxADOParameter::emParamOutput);//result

			cmdUpdate2DB.AddParameter(&pParamResult);

			int nRetValue;

			if( cmdUpdate2DB.Execute() )
			{
				pParamResult.GetValue(nRetValue);
				if (nRetValue != 1)
				{
					AfxMessageBox(_T("�Ǿ�����Ա��Ϣ����ʧ�ܣ��������ݵ����ݿ����"));
					return;
				}
				else
				{
					AfxMessageBox(_T("�Ǿ�����Ա��Ϣ����ɹ���"));
					return;
				}
			}
		}

	}
	catch (CAxADOException &e)
	{
		AfxMessageBox(e.GetErrorMessage());
	}
}


void CInitialDownLoadDlg::OnBnExportOfficals()
{
	// TODO: Add your control notification handler code here
}



