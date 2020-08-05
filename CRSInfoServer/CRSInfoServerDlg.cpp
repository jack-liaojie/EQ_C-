
// CRSInfoServerDlg.cpp : implementation file
//

#include "stdafx.h"
#include "CRSInfoServer.h"
#include "CRSInfoServerDlg.h"
#include "TopicSettingDlg.h"
#include "TopicUpdateSettingDlg.h"
#include <locale>//头文件


#ifdef _DEBUG
#define new DEBUG_NEW
#endif

//zjy 2012-08-17 Delete ComPeerX Control.
/*CCompeerx1 m_ComPeerX;*/

// CCRSInfoServerDlg dialog
CString	CCRSInfoServerDlg::m_strFilePath = _T("");

CCRSInfoServerDlg::CCRSInfoServerDlg()
	: CDialog(CCRSInfoServerDlg::IDD)
	, m_TopicsSettingExport(this)
{
	m_bAdministrator = FALSE;
	m_strMsgPeerComServerPort = _T("");
	m_nCurSelTopicIdx = -1;

	m_iconLists.Create(24, 24, ILC_COLOR32, 3, 1);
	m_iconLists.Add( LoadIcon(::GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_SPORT)) );
	m_iconLists.Add( LoadIcon(::GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_DISCIPLINE)) );
	m_iconLists.Add( LoadIcon(::GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_EVENT)) );
	m_iconLists.Add( LoadIcon(::GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_PHASE)) );
	m_iconLists.Add( LoadIcon(::GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_MATCH)) );
	m_iconLists.Add( LoadIcon(::GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_SELECTED)) );
}

void CCRSInfoServerDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//zjy 2012-08-17 Delete ComPeerX Control.
	/*DDX_Control(pDX, IDC_COMPEERX1, m_ComPeerX);*/
	DDX_Control(pDX, IDC_TREE_SPORT, m_treeSport);
}

BEGIN_MESSAGE_MAP(CCRSInfoServerDlg, CDialog)
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_BTN_CONNECT, OnBtnConnect)
	ON_BN_CLICKED(IDC_BTN_DISCONNECT, OnBtnDisconnect)

	ON_BN_CLICKED(IDC_BTN_TOPIC_ADD, OnBtnTopicAdd)
	ON_BN_CLICKED(IDC_BTN_TOPIC_MODIFY, OnBtnTopicModify)
	ON_BN_CLICKED(IDC_BTN_TOPIC_DEL, OnBtnTopicDel)
	//ON_BN_CLICKED(IDC_BTN_UPDATE_ALL_TOPICS, OnBtnUpdateAllTopics)
	//ON_BN_CLICKED(IDC_BTN_UPDATE_SEL_TOPIC, OnBtnUpdateSelTopic)
	ON_BN_CLICKED(IDC_BTN_UPDATE_SETTING, OnBtnUpdateSetting)
	ON_BN_CLICKED(IDC_BTN_EXPORT, OnBtnExport)
	ON_BN_CLICKED(IDC_BTN_PREVIEW, OnBtnPreview)
	ON_BN_CLICKED(IDC_BTN_FILEPATH, OnBtnSetFilePath)

	ON_NOTIFY(GVN_SELCHANGED, IDC_STC_GRID_TOPICS, OnTopicSelChange)
	ON_NOTIFY(NM_RCLICK, IDC_STC_GRID_TOPICS, OnTopicListGridRClick)
	ON_NOTIFY(TVN_SELCHANGED, IDC_TREE_SPORT, OnTvnSelchangedTreeSport)

	ON_WM_MOUSEMOVE()
	ON_WM_LBUTTONDOWN()
	ON_WM_LBUTTONUP()
	ON_WM_SIZE()

	ON_CBN_SELCHANGE(IDC_CMB_DATE, OnSelchangeDate)

	ON_WM_DESTROY()

	ON_BN_CLICKED(IDC_BTN_REFRESH, &CCRSInfoServerDlg::OnBtnRefresh)

	ON_EN_KILLFOCUS(IDC_EDIT_FILEPATH, &CCRSInfoServerDlg::OnTextFilePathKillfocus)
END_MESSAGE_MAP()

// CCRSInfoServerDlg message handlers

BOOL CCRSInfoServerDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	SetIcon(LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDR_MAINFRAME)), TRUE);
	// Maximize the Window
	RECT rcWorkArea;
	SystemParametersInfo(SPI_GETWORKAREA, NULL, (PVOID)&rcWorkArea, 0);
	MoveWindow(CRect(rcWorkArea));

	// if the user is not administrator then refuse to modify topic define
	ReadConfig();
	CEdit* pTextFilePath = (CEdit*)GetDlgItem(IDC_EDIT_FILEPATH);
	pTextFilePath->SetWindowTextW(CCRSInfoServerDlg::m_strFilePath);

	if (!m_bAdministrator)
	{
		GetDlgItem(IDC_BTN_TOPIC_ADD)->EnableWindow(FALSE);
		GetDlgItem(IDC_BTN_TOPIC_MODIFY)->EnableWindow(FALSE);
		GetDlgItem(IDC_BTN_TOPIC_DEL)->EnableWindow(FALSE);
	}

	g_Log.StartLogService((CEdit *)GetDlgItem(IDC_EDIT_LOG));
	m_TopicsSettingExport.InitExportDBSetting(theApp.GetDataBase(), _T("TI_CRS_Info"), theApp.GetDisciplineCode());

	CreateTopicListGrid();

	LoadTopicList();
	ShowTopicList();
	RefreshPhaseTree();
	RefreshDateCombobox();

	OnBtnUpdateSetting();

	//zjy 2012-08-17 Delete ComPeerX Control.
	/*
	//////////////////////////////////////////////////////////////////////////
	// Start MsgPeerCom Service
	//////////////////////////////////////////////////////////////////////////

	m_ComPeerX.put_Visible(FALSE);

	if (!m_strMsgPeerComServerPort.IsEmpty())
	m_ComPeerX.put_Port(_ttoi(m_strMsgPeerComServerPort));

	m_ComPeerX.DoStart();

	g_Log.OutPutMsg(_T("MsgPeerCom.DoStart() -- Port: ") + AxCommonInt2String(m_ComPeerX.get_Port()));

	if (m_ComPeerX.get_IsRunning())
	g_Log.OutPutMsg(_T("MsgPeerCom Service start success!"));
	else
	g_Log.OutPutMsg(_T("MsgPeerCom Service start fail!"));
	*/
	return TRUE;
}

BOOL CCRSInfoServerDlg::CreateTopicListGrid()
{
	CRect rcTopicsGrid;
	GetDlgItem(IDC_GRID_RECT)->GetWindowRect(rcTopicsGrid);
	ScreenToClient(rcTopicsGrid);

	if (!m_gridTopics.Create(rcTopicsGrid, this, IDC_STC_GRID_TOPICS)) return FALSE;

	m_gridTopics.SetRowCount(1);
	m_gridTopics.SetColumnCount(6);
	m_gridTopics.SetFixedRowCount();
	m_gridTopics.SetListMode();
	m_gridTopics.SetSingleRowSelection();
	m_gridTopics.SetEditable(FALSE);
	m_gridTopics.SetFixedColumnSelection(FALSE);

	m_gridTopics.SetItemText(0, 0, _T("MessageKey"));
	m_gridTopics.SetItemText(0, 1, _T("MessageType"));
	m_gridTopics.SetItemText(0, 2, _T("MessageDes"));
	m_gridTopics.SetItemText(0, 3, _T("MessageLanguage"));
	m_gridTopics.SetItemText(0, 4, _T("Level"));
	m_gridTopics.SetItemText(0, 5, _T("SQLExpression"));
	m_gridTopics.SetBkColor(RGB(255, 255, 255));

	return TRUE;
}

BOOL CCRSInfoServerDlg::LoadTopicList()
{
	SAxTableRecordSet stTopicsRecords;
	if (!CAxDBOperator::GetAllTopicItems(stTopicsRecords, theApp.GetDisciplineCode())) return FALSE;

	// Try to import topics settings from file at the 1st time
	static BOOL bTryImport = TRUE;
	if (bTryImport)
	{
		bTryImport = FALSE;
		if (stTopicsRecords.GetRowRecordsCount() <= 0)
		{
			OnCommand(MAKEWPARAM(COMMANDID_IMPORT, NULL), NULL);
			return TRUE;
		}
	}

	g_TopicManager.DeleteAll();

	int nRecordCount = stTopicsRecords.GetRowRecordsCount();

	for (int i=0; i < nRecordCount; i++)
	{
		STopicItem *pTopicItem = new STopicItem;

		pTopicItem->m_strMsgKey = stTopicsRecords.GetValue(_T("F_MsgKey"), i);
		pTopicItem->m_strDisciplineCode = stTopicsRecords.GetValue(_T("F_DisciplineCode"), i);
		pTopicItem->m_strMsgType = stTopicsRecords.GetValue(_T("F_MsgTypeID"), i);
		pTopicItem->m_strMsgName = stTopicsRecords.GetValue(_T("F_MsgTypeDes"), i);
		pTopicItem->m_strMsgLevel = stTopicsRecords.GetValue(_T("F_MsgLevel"), i);
		pTopicItem->m_strSQLProcedure = stTopicsRecords.GetValue(_T("F_SqlProcedure"), i);
		pTopicItem->m_strLanguage = stTopicsRecords.GetValue(_T("F_Language"), i);

		g_TopicManager.AddTail(pTopicItem);
	}

	return TRUE;
}
void CCRSInfoServerDlg::ShowTopicList()
{
	int nTopicCount = g_TopicManager.GetCount();
	m_gridTopics.SetRowCount(nTopicCount + 1);

	for (int i=0; i < nTopicCount; i++)
	{
		STopicItem *pTopicItem = g_TopicManager.GetTopicItem(i);

		m_gridTopics.SetItemText(i+1, 0, pTopicItem->m_strMsgKey);
		m_gridTopics.SetItemText(i+1, 1, pTopicItem->m_strMsgType);
		m_gridTopics.SetItemText(i+1, 2, pTopicItem->m_strMsgName);
		m_gridTopics.SetItemText(i+1, 3, pTopicItem->m_strLanguage);
		m_gridTopics.SetItemText(i+1, 4, pTopicItem->m_strMsgLevel);
		m_gridTopics.SetItemText(i+1, 5, pTopicItem->m_strSQLProcedure);

		m_gridTopics.SetRowBkColor(i + 1, (i%2 == 0) ? GRID_EVEN_ROW_COLOR : GRID_ODD_ROW_COLOR);	
	}

	m_nCurSelTopicIdx = 0;
	m_gridTopics.SetSelectedRow(m_nCurSelTopicIdx + 1);
	m_gridTopics.AutoSizeColumns();
	m_gridTopics.ExpandLastColumn();
	m_gridTopics.Refresh();
}

void CCRSInfoServerDlg::OnBtnTopicAdd()
{
	STopicItem *pTopicItem = new STopicItem;

	CTopicSettingDlg dlgTopicSetting(pTopicItem, FALSE);
	if (dlgTopicSetting.DoModal() == IDOK)
	{
		g_TopicManager.AddTail(pTopicItem);
		if(!CAxDBOperator::InsertTopicItem(pTopicItem))
		{
			AfxMessageBox(_T("Insert TopicItem To Database ERROR!"));
		}

		ShowTopicList();
	}
}

void CCRSInfoServerDlg::OnBtnTopicModify()
{
	// Get Selected Topic
	CUIntArray naSelRows;
	m_gridTopics.GetSelectedRows(naSelRows);
	if (naSelRows.GetCount() <= 0) 
		return;

	int nSelTopicIdx = naSelRows[0] - 1; // Modify the first selected Topic
	if (nSelTopicIdx < 0 || nSelTopicIdx >= g_TopicManager.GetCount()) 
		return;

	STopicItem *pTopicItem = g_TopicManager.GetTopicItem(nSelTopicIdx);

	// Modify Selected Topic
	CTopicSettingDlg dlgTopicSetting(pTopicItem, TRUE);
	if (dlgTopicSetting.DoModal() == IDOK)
	{
		if(!CAxDBOperator::UpdateTopicItem(pTopicItem))
			AfxMessageBox(_T("Update TopicItem To Database ERROR!"));
		else
			AfxMessageBox(pTopicItem->m_strMsgName + _T(" -- If the topic define has changed, \r\n")
			_T("please restart the InfoDataFeedServer and it's clients to validate the change!"));

		ShowTopicList();
	}

}

void CCRSInfoServerDlg::OnBtnTopicDel()
{
	// Get Selected Topic
	CUIntArray naSelRows;
	m_gridTopics.GetSelectedRows(naSelRows);
	if (naSelRows.GetCount() <= 0) 
		return;

	int nSelTopicIdx = naSelRows[0] - 1; // Modify the first selected Topic
	if (nSelTopicIdx < 0 || nSelTopicIdx >= g_TopicManager.GetCount()) 
		return;

	STopicItem *pTopicItem = g_TopicManager.GetTopicItem(nSelTopicIdx);

	if (AfxMessageBox(_T("Are you sure to Delete ?"), MB_YESNO) == IDYES)
	{
		// Delete Selected Topic
		if(!CAxDBOperator::DeleteTopicItem(pTopicItem))
			AfxMessageBox(_T("Update TopicItem To Database ERROR!"));
		else
		{
			g_TopicManager.DeleteItem(nSelTopicIdx);
		}

		ShowTopicList();
	}	
}

void CCRSInfoServerDlg::OnBtnUpdateSetting()
{
	if (!m_UpdateSettingDlg.GetSafeHwnd())
	{
		if (!m_UpdateSettingDlg.Create(MAKEINTRESOURCE(IDD_DLG_UPDATE_SETTING), this))
		{
			g_Log.OutPutMsg(_T("UpdateSettingDlg create failure!"));
		}
	}
	else
	{
		m_UpdateSettingDlg.ShowWindow(SW_NORMAL);
	}
}

void CCRSInfoServerDlg::OnTopicSelChange(NMHDR* pNmhdr, LRESULT* pResult)
{
	NM_GRIDVIEW *pGridItem = (NM_GRIDVIEW*) pNmhdr;

	// Current click point must in the selected cell
	CRect rcCell;
	m_gridTopics.GetCellRect(pGridItem->iRow, pGridItem->iColumn, rcCell);
	POINT ptMouse;
	GetCursorPos(&ptMouse);
	m_gridTopics.ScreenToClient(&ptMouse);
	if (!rcCell.PtInRect(ptMouse)) 
		return;

	// Get Selected topic
	int nSelTopicIdx = pGridItem->iRow - 1;
	if (nSelTopicIdx < 0 || nSelTopicIdx >= g_TopicManager.GetCount()) return;
	m_nCurSelTopicIdx = nSelTopicIdx;

	EnableControlBtn();
}

void CCRSInfoServerDlg::OnTvnSelchangedTreeSport(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMTREEVIEW pNMTreeView = reinterpret_cast<LPNMTREEVIEW>(pNMHDR);
	*pResult = 1;

	EnableControlBtn();
}

void CCRSInfoServerDlg::OnTopicListGridRClick(NMHDR* pNmhdr, LRESULT* pResult)
{
	NM_GRIDVIEW *pGridItem = (NM_GRIDVIEW*) pNmhdr;

	if (!m_gridTopics.IsValid(pGridItem->iRow, pGridItem->iColumn))
		return;

	CPoint ptMouse;
	GetCursorPos(&ptMouse);

	if (m_bAdministrator)
	{
		m_TopicsSettingExport.ShowPopupMenu(ptMouse);
	}
}

BOOL CCRSInfoServerDlg::OnCommand(WPARAM wParam, LPARAM lParam)
{
	if (m_TopicsSettingExport.OnCommand(wParam, lParam))
		return TRUE;

	return CDialog::OnCommand(wParam, lParam);
}

void CCRSInfoServerDlg::OnDestroy()
{	
	ReleaseNodeInfoAry();

	m_mapDateToDateID.RemoveAll();

	//zjy 2012-08-17 Delete ComPeerX Control.
	//////////////////////////////////////////////////////////////////////////
	// Stop MsgPeerCom Service
	/*
	m_ComPeerX.DoStop();
	g_Log.OutPutMsg(_T("MsgPeerCom Service stoped!"));
	*/

	g_Log.StopLogService();

	UpdateData(TRUE);

	WriteConfig();

	CDialog::OnDestroy();
}

void CCRSInfoServerDlg::ReadConfig()
{
	CString strConfigFile = CAxReadWriteINI::GetAppConfigFile();

	CAxReadWriteINI::IniReadString(_T("NOTIFY_SERVER"), _T("NOTIFY_Server_IP"), m_UpdateSettingDlg.m_strServerIP, strConfigFile);
	CAxReadWriteINI::IniReadString(_T("NOTIFY_SERVER"), _T("NOTIFY_Server_PORT"), m_UpdateSettingDlg.m_strServerPort, strConfigFile);

	CAxReadWriteINI::IniReadInt(_T("COMMON_SETUP"), _T("USER_Administrator"), m_bAdministrator, strConfigFile);
	m_UpdateSettingDlg.m_bAdministrator = m_bAdministrator;

	CAxReadWriteINI::IniReadString(_T("COMMON_SETUP"), _T("USER_MsgPeerComServerPort"), m_strMsgPeerComServerPort, strConfigFile);
	CAxReadWriteINI::IniReadString(_T("COMMON_SETUP"), _T("OUTPU_FILE_PATH"), CCRSInfoServerDlg::m_strFilePath, strConfigFile);
}

void CCRSInfoServerDlg::WriteConfig()
{
	CString strConfigFile = CAxReadWriteINI::GetAppConfigFile();

	CAxReadWriteINI::IniWriteString(_T("NOTIFY_SERVER"), _T("NOTIFY_Server_IP"), m_UpdateSettingDlg.m_strServerIP, strConfigFile);
	CAxReadWriteINI::IniWriteString(_T("NOTIFY_SERVER"), _T("NOTIFY_Server_PORT"), m_UpdateSettingDlg.m_strServerPort, strConfigFile);

	CAxReadWriteINI::IniWriteString(_T("COMMON_SETUP"), _T("USER_Administrator"), AxCommonInt2String(TRUE), strConfigFile);

	CAxReadWriteINI::IniWriteString(_T("COMMON_SETUP"), _T("USER_MsgPeerComServerPort"), m_strMsgPeerComServerPort, strConfigFile);
	CAxReadWriteINI::IniWriteString(_T("COMMON_SETUP"), _T("OUTPU_FILE_PATH"), CCRSInfoServerDlg::m_strFilePath, strConfigFile);
}

void CCRSInfoServerDlg::OnBtnConnect()
{
	if (!m_UpdateSettingDlg.GetSafeHwnd())
		return;

	m_UpdateSettingDlg.OnBtnConnect();
}

void CCRSInfoServerDlg::OnBtnDisconnect()
{
	if (!m_UpdateSettingDlg.GetSafeHwnd())
		return;

	m_UpdateSettingDlg.OnBtnDisconnect();	
}

//zjy 2012-08-17 Delete ComPeerX Control.
/*
BEGIN_EVENTSINK_MAP(CCRSInfoServerDlg, CPropertyPage)
ON_EVENT(CCRSInfoServerDlg, IDC_COMPEERX1, 201, CCRSInfoServerDlg::OnIsRunningChangedCompeerx1, VTS_NONE)
ON_EVENT(CCRSInfoServerDlg, IDC_COMPEERX1, 202, CCRSInfoServerDlg::OnOnlineChangedCompeerx1, VTS_NONE)
ON_EVENT(CCRSInfoServerDlg, IDC_COMPEERX1, 203, CCRSInfoServerDlg::OnReceiveMsgCompeerx1, VTS_BSTR VTS_BSTR VTS_BSTR VTS_BSTR)
END_EVENTSINK_MAP()

void CCRSInfoServerDlg::OnIsRunningChangedCompeerx1()
{
if (m_ComPeerX.get_IsRunning())
g_Log.OutPutMsg(_T("MsgPeerCom Service is running !"));
else
g_Log.OutPutMsg(_T("MsgPeerCom Service is not running!"));
}

void CCRSInfoServerDlg::OnOnlineChangedCompeerx1()
{
if (m_ComPeerX.get_Online())
g_Log.OutPutMsg(_T("MsgPeerCom Service is Online !"));
else
g_Log.OutPutMsg(_T("MsgPeerCom Service is not Online !"));
}

void CCRSInfoServerDlg::OnReceiveMsgCompeerx1(LPCTSTR AMsgType, LPCTSTR ASportCode, LPCTSTR AMsgData, LPCTSTR AMsgGuid)
{
g_Log.OutPutMsg(_T("OnRecieve:  ") + CString(AMsgType));

//CInitailDownLoadDBOper cInitialDownLoadOper;
//cInitialDownLoadOper.DealXml(ASportCode, AMsgType, AMsgData);
}
*/

BOOL CCRSInfoServerDlg::SendMsgToCRSInfo(STopicItem *pTopicItem, int bAuto, STNotifyMsg *pNotifyMsgParam /*=NULL*/, BOOL bPreview /*=FALSE*/)
{
	if (pTopicItem == NULL)
		return FALSE;

	CString strDisplnCode = pTopicItem->m_strDisciplineCode;
	CString strMsgType = pTopicItem->m_strMsgType;
	CString strMsgKey = pTopicItem->m_strMsgKey;

	CString strSQLWithLang = ParseSQLExpressWithParams(pTopicItem->m_strSQLProcedure, pNotifyMsgParam, bAuto);
	strSQLWithLang.Replace(_T("@MsgType"), strMsgType); // @MsgType => strMsgType

	// Get separate languages
	CStringArray straLanguages;
	CAxSplitString split;
	split.SetSplitFlag(_T(","));
	split.SetData(pTopicItem->m_strLanguage);
	split.GetSplitStrArray(straLanguages);

	if (straLanguages.GetCount() <= 0)
	{
		CString strExecSQL = strSQLWithLang;
		strExecSQL.Replace(_T("@Lang"), _T(""));
		GetDataFromDBAndSend(strExecSQL, strDisplnCode, strMsgKey, strMsgType, bPreview);
	}
	else
	{
		for (int i=0; i < straLanguages.GetCount(); i++)
		{
			CString strExecSQL = strSQLWithLang;
			strExecSQL.Replace(_T("@Lang"), straLanguages[i].Trim());
			GetDataFromDBAndSend(strExecSQL, strDisplnCode, strMsgKey, strMsgType, bPreview);
		}
	}

	return TRUE;
}

BOOL CCRSInfoServerDlg::GetDataFromDBAndSend(CString strSQL, CString strDisplnCode, CString strMsgKey, CString strMsgTypeID, BOOL bPreview /*=FALSE*/)
{
	// Get data from Database
	SAxTableRecordSet sTblRecords;		
	CString strData;
	CString strDataFileName;//Data RscCode, for Data File Name.

	if ( strSQL != _T("") )
	{	
		CAxADORecordSet mpRecordSet(theApp.GetDataBase());
		try
		{
			if ( mpRecordSet.Open(strSQL) )
			{			
				// Get  the 1st FieldValue
				if (mpRecordSet.GetRecordCount() > 0)
				{
					mpRecordSet.MoveFirst();
					mpRecordSet.GetFieldValue(0, strData);
					if(mpRecordSet.GetFieldCount() > 1)
					{
						mpRecordSet.GetFieldValue(1, strDataFileName);
					}
				}
			}
		}
		catch (CAxADOException* e)
		{
			g_Log.OutPutMsg(e->GetErrorMessage());
			return FALSE;
		}
		catch(...)
		{
			return FALSE;
		}
	}

	if (strData.IsEmpty())
	{
		g_Log.OutPutMsg(_T("Empty ----- : MsgKey= ") + strMsgKey + _T( ", MsgType= ") + strMsgTypeID + _T(", SQL: ") + strSQL + _T("\r\n"));
		return FALSE;
	}

	g_Log.OutPutMsg(_T("MsgKey= ") + strMsgKey + _T( ", MsgType= ") + strMsgTypeID + _T(", SQL: ") + strSQL);

	if (bPreview)
	{
		PreviewXMLResult(strData);
		return TRUE;
	}
	else
	{
		//Send Data
		//zjy 2012-08-17 Delete ComPeerX Control.
		/*if (!m_ComPeerX.get_Online())
		g_Log.OutPutMsg(_T("MsgPeerCom is not Online !!! Data may be lost!"));

		m_ComPeerX.DoSendMsg(strMsgTypeID, strDisplnCode, strData);
		g_Log.OutPutMsg(_T("Send OK : ") + strDisplnCode + strMsgTypeID + _T("\r\n"));*/

		//Write Data to file
		CString strFileName;
		strFileName = CCRSInfoServerDlg::m_strFilePath + _T("\\") + strDataFileName  + _T(".xml");

		CAxStdioFileEx fOutputFile;
		if(fOutputFile.Open( strFileName, CFile::modeCreate|CFile::modeWrite|CFile::typeText|CFile::shareExclusive))
		{
			fOutputFile.SetCodePage(CP_UTF8);

			fOutputFile.SeekToBegin();
			fOutputFile.Write("\xef\xbb\xbf", 3);//输出文本的BOM头信息
			fOutputFile.SeekToEnd();
			fOutputFile.WriteString(strData);
			fOutputFile.WriteString(_T("\r\n"));

			fOutputFile.Close();

			g_Log.OutPutMsg(_T("Write Data Succeed : ") + strDataFileName + _T("\r\n"));
		}
		else
		{
			g_Log.OutPutMsg(_T("Write Data Failed : ") + strDataFileName + _T("\r\n"));
		}

	}

	return TRUE;
}

CString CCRSInfoServerDlg::ParseSQLExpressWithParams( CString strSrcSQLExpress, STNotifyMsg *pNotifyMsgParam, int bAuto )
{
	CString strbAuto;
	strbAuto.Format(_T("%d"), bAuto);

	if (strSrcSQLExpress.IsEmpty())
		return strSrcSQLExpress;

	strSrcSQLExpress.Replace(_T("@DATE"),_T("@Date"));

	if (pNotifyMsgParam)
	{
		strSrcSQLExpress.Replace(_T("@RSC"), pNotifyMsgParam->strRSCCode);
		strSrcSQLExpress.Replace(_T("@Gender"), pNotifyMsgParam->strGenderCode);
		strSrcSQLExpress.Replace(_T("@Date"), pNotifyMsgParam->strDate);
		strSrcSQLExpress.Replace(_T("@Venue"), pNotifyMsgParam->strVenueCode);

		strSrcSQLExpress.Replace(_T("@DisciplineID"), pNotifyMsgParam->strDisciplineID);
		strSrcSQLExpress.Replace(_T("@EventID"), pNotifyMsgParam->strEventID);
		strSrcSQLExpress.Replace(_T("@PhaseID"), pNotifyMsgParam->strPhaseID);
		strSrcSQLExpress.Replace(_T("@MatchID"), pNotifyMsgParam->strMatchID);
		strSrcSQLExpress.Replace(_T("@SessionID"), pNotifyMsgParam->strSessionID);
		strSrcSQLExpress.Replace(_T("@CourtID"), pNotifyMsgParam->strCourtID);

		strSrcSQLExpress.Replace(_T("@Discipline"), pNotifyMsgParam->strDisciplineCode);
		strSrcSQLExpress.Replace(_T("@Event"), pNotifyMsgParam->strEventCode);
		strSrcSQLExpress.Replace(_T("@Phase"), pNotifyMsgParam->strPhaseCode);
		strSrcSQLExpress.Replace(_T("@Unit"), pNotifyMsgParam->strUnitCode);

		strSrcSQLExpress.Replace(_T("@bAuto"), strbAuto);
	}
	else
	{
		strSrcSQLExpress.Replace(_T("@RSC"), _T(""));
		strSrcSQLExpress.Replace(_T("@Gender"), _T(""));
		strSrcSQLExpress.Replace(_T("@Date"), _T(""));
		strSrcSQLExpress.Replace(_T("@Venue"), _T(""));

		strSrcSQLExpress.Replace(_T("@DisciplineID"), _T("0"));
		strSrcSQLExpress.Replace(_T("@EventID"), _T("0"));
		strSrcSQLExpress.Replace(_T("@PhaseID"), _T("0"));
		strSrcSQLExpress.Replace(_T("@MatchID"), _T("0"));
		strSrcSQLExpress.Replace(_T("@SessionID"), _T("0"));
		strSrcSQLExpress.Replace(_T("@CourtID"), _T("0"));

		strSrcSQLExpress.Replace(_T("@Discipline"), _T(""));
		strSrcSQLExpress.Replace(_T("@Event"), _T(""));
		strSrcSQLExpress.Replace(_T("@Phase"), _T(""));
		strSrcSQLExpress.Replace(_T("@Unit"), _T(""));

		strSrcSQLExpress.Replace(_T("@bAuto"), _T("0"));
	}

	return strSrcSQLExpress;
}

void CCRSInfoServerDlg::PreviewXMLResult( CString &strXmlResult )
{
	CString strTempFile = _T(".\~TempXmlResult.xml");
	CFile file;
	if (!file.Open(strTempFile, CFile::modeReadWrite|CFile::modeCreate))
	{
		g_Log.OutPutMsg(_T("Create temporary file failed! Make sure the directory is writable!"));
		return;
	}
	CString strFileName = file.GetFilePath();

	int nXmlLen = strXmlResult.GetLength();

	// UNICODE to UTF-8
	int nDeslen = ::WideCharToMultiByte(CP_UTF8, 0, strXmlResult.GetBuffer(nXmlLen), nXmlLen, NULL, 0, NULL, NULL);   
	if (nDeslen == 0) 
		return;

	CStringA strUTF8;
	::WideCharToMultiByte(CP_UTF8, 0, strXmlResult.GetBuffer(nXmlLen), nXmlLen, strUTF8.GetBuffer(nDeslen), nDeslen, NULL, NULL);   

	file.Write(strUTF8.GetBuffer(nDeslen), nDeslen);
	file.Close();

	CXmlDisplayDlg xmlDlg(strFileName);
	xmlDlg.DoModal();

	DeleteFile(strTempFile);	
}

void CCRSInfoServerDlg::ReleaseNodeInfoAry()
{
	int iCount = m_pAryTreeNodeInfo.GetCount();
	for(int i=0; i<iCount; i++)
	{
		SCRSTreeNodeInfo* pNode = (SCRSTreeNodeInfo*)m_pAryTreeNodeInfo[i];
		delete pNode;
	}
	m_pAryTreeNodeInfo.RemoveAll();
}

void CCRSInfoServerDlg::RefreshPhaseTree()
{
	if( !m_treeSport.GetSafeHwnd())
		return;
	m_treeSport.SetImageList(&m_iconLists, TVSIL_NORMAL);

	m_treeSport.DeleteAllItems();

	ReleaseNodeInfoAry();
	m_mapKeyToNodePtr.RemoveAll();

	CAxADORecordSet RecordSet(theApp.GetDataBase());

	if( CAxDBOperator::GetScheduleTree(theApp.GetDataBase(), 0, -5, _T("ENG"), RecordSet) )
	{
		HTREEITEM hItemRoot = NULL;
		while(!RecordSet.IsEOF())
		{
			HTREEITEM hItemOne,hItemFather;
			SCRSTreeNodeInfo* pTreeNodeInfo = new SCRSTreeNodeInfo;

			int		nImage = 0;
			int		nSelectedImage = 0;

			RecordSet.GetFieldValue(_T("F_NodeKey"), pTreeNodeInfo->strNodeKey);
			RecordSet.GetFieldValue(_T("F_FatherNodeKey"), pTreeNodeInfo->strFatherNodeKey);
			RecordSet.GetFieldValue(_T("F_NodeType"), pTreeNodeInfo->iNodeType);

			RecordSet.GetFieldValue(_T("F_NodeName"), pTreeNodeInfo->strNodeName);
			RecordSet.GetFieldValue(_T("F_NodeShortName"), pTreeNodeInfo->strNodeShortName);
			RecordSet.GetFieldValue(_T("F_NodeLongName"), pTreeNodeInfo->strNodeLongName);
			RecordSet.GetFieldValue(_T("F_NodeStatusDes"), pTreeNodeInfo->strNodeStatusName);

			RecordSet.GetFieldValue(_T("F_SportID"), pTreeNodeInfo->iSportID);
			RecordSet.GetFieldValue(_T("F_DisciplineID"), pTreeNodeInfo->iDisciplineID);
			RecordSet.GetFieldValue(_T("F_EventID"), pTreeNodeInfo->iEventID);
			RecordSet.GetFieldValue(_T("F_PhaseID"), pTreeNodeInfo->iPhaseID);
			RecordSet.GetFieldValue(_T("F_MatchID"), pTreeNodeInfo->iMatchID);

			RecordSet.GetFieldValue(_T("F_SessionID"), pTreeNodeInfo->iSessionID);
			RecordSet.GetFieldValue(_T("F_CourtID"), pTreeNodeInfo->iCourtID);
			RecordSet.GetFieldValue(_T("F_NodeStatusID"), pTreeNodeInfo->iStatusID);

			RecordSet.GetFieldValue(_T("F_DisciplineCode"), pTreeNodeInfo->strDisciplineCode);
			RecordSet.GetFieldValue(_T("F_EventCode"), pTreeNodeInfo->strEventCode);
			RecordSet.GetFieldValue(_T("F_PhaseCode"), pTreeNodeInfo->strPhaseCode);
			RecordSet.GetFieldValue(_T("F_MatchCode"), pTreeNodeInfo->strMatchCode);
			RecordSet.GetFieldValue(_T("F_Gender"), pTreeNodeInfo->strGenderCode);
			RecordSet.GetFieldValue(_T("F_VenueCode"), pTreeNodeInfo->strVenueCode);

			nImage = pTreeNodeInfo->iNodeType + 3;
			nSelectedImage = 5;

			if (pTreeNodeInfo->strFatherNodeKey.CompareNoCase(_T("NULL")) == 0 || pTreeNodeInfo->strFatherNodeKey.IsEmpty())
			{
				hItemRoot = m_treeSport.InsertItem(pTreeNodeInfo->strNodeName, nImage, nSelectedImage, TVI_ROOT);

				m_treeSport.SetItemData(hItemRoot, DWORD_PTR(pTreeNodeInfo));
				m_mapKeyToNodePtr.SetAt(pTreeNodeInfo->strNodeKey,hItemRoot);
			}
			else
			{
				m_mapKeyToNodePtr.Lookup(pTreeNodeInfo->strFatherNodeKey, (void*&) hItemFather);
				hItemFather=(HTREEITEM)hItemFather;
				hItemOne = m_treeSport.InsertItem(pTreeNodeInfo->strNodeName, nImage, nSelectedImage, hItemFather);
				m_treeSport.SetItemData(hItemOne,DWORD_PTR(pTreeNodeInfo));
				m_mapKeyToNodePtr.SetAt(pTreeNodeInfo->strNodeKey, hItemOne);
			}
			m_pAryTreeNodeInfo.Add(pTreeNodeInfo);
			RecordSet.MoveNext();
		}

		if( hItemRoot )
		{
			HTREEITEM hItemDiscipline = m_treeSport.GetChildItem(hItemRoot);
			m_treeSport.SelectItem(hItemDiscipline);
			m_treeSport.Expand(hItemDiscipline, TVE_EXPAND);
		}
	}
}

void CCRSInfoServerDlg::RefreshDateCombobox()
{
	CComboBox* pCmbDate = (CComboBox*)GetDlgItem(IDC_CMB_DATE);

	if (!pCmbDate)
	{
		g_Log.OutPutMsg(_T("Can't find Commobox for the session filter!"));
		return;
	}

	pCmbDate->ResetContent();
	m_mapDateToDateID.RemoveAll();

	CStringArray straDateIDs;
	CStringArray straDateNames;
	if (GetAllDisciplineDates(theApp.GetDisciplineCode(), straDateIDs, straDateNames))
	{
		int nDateCount = straDateIDs.GetCount();
		for (int i = 0; i < nDateCount ; i++)
		{
			pCmbDate->AddString(straDateNames[i]);
			pCmbDate->SetItemData(i, _ttoi(straDateIDs[i]));

			m_mapDateToDateID.SetAt(straDateNames[i], straDateIDs[i]);
		}

		if (nDateCount > 0)
		{
			SetCmboxSelByItemData(pCmbDate, m_strCmbSelDate);
			//pCmbDate->SetCurSel(0);

	 		//Send CBN_SELCHANGE
	 		WPARAM wParam = MAKEWPARAM(pCmbDate->GetDlgCtrlID(), CBN_SELCHANGE);     
	 		BOOL bResult = ::SendMessage(pCmbDate->GetParent()->GetSafeHwnd(), WM_COMMAND, wParam, (LPARAM)(pCmbDate->GetSafeHwnd()) );
		}
	}

}

BOOL CCRSInfoServerDlg::GetAllDisciplineDates(CString strDisciplineCode, OUT CStringArray &straDateIDs, OUT CStringArray &straDateNames)
{
	if (strDisciplineCode.IsEmpty())
		return FALSE;

	CString strFmt = _T("EXEC [Proc_TV_APP_GetDisciplineDates] '%s' ");
	CString strSQL;
	strSQL.Format(strFmt, strDisciplineCode);

	try
	{
		CAxADORecordSet adoRecordSet(theApp.GetDataBase());	
		if (adoRecordSet.Open(strSQL))
		{
			while (!adoRecordSet.IsEOF())
			{
				CString strDateID, strDateName;
				adoRecordSet.GetFieldValue(0, strDateID);
				adoRecordSet.GetFieldValue(1, strDateName);
				straDateIDs.Add(strDateID);
				straDateNames.Add(strDateName);

				adoRecordSet.MoveNext();
			}
			adoRecordSet.Close();
		}
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}

	return TRUE;
}

void CCRSInfoServerDlg::OnSelchangeDate()
{
	CComboBox* pCmbDate = (CComboBox*)GetDlgItem(IDC_CMB_DATE);

	if (!pCmbDate)
	{
		g_Log.OutPutMsg(_T("Can't find Commobox for the session filter!"));
		return;
	}

	int nCurSel = pCmbDate->GetCurSel();
	if (nCurSel < 0) 
		return;

	pCmbDate->GetWindowText(m_strCmbSelDate);

	m_mapDateToDateID.Lookup(m_strCmbSelDate, m_strCmbSelDateID);

}


void CCRSInfoServerDlg::SetCmboxSelByItemData(CComboBox *pCmbox, CString strCmbSelDate)
{
	if (!pCmbox)
		return;
	
	// Find the Item with the nItemData 
	int nFindIndex = -1;
	int nItemCount = pCmbox->GetCount();
	for (int i=0; i < nItemCount; i++)
	{
		CString strCurDate;
		pCmbox->GetLBText(i,strCurDate);
		if (strCmbSelDate == strCurDate)
		{
			nFindIndex = i;
			break;
		}
	}
	
	if (nFindIndex >= 0)
	{
		pCmbox->SetCurSel(nFindIndex);
	}
	else
	{
		pCmbox->SetCurSel(0);
	}

}

void CCRSInfoServerDlg::OnBtnExport()
{
	// Get Selected Msg and TreeNode
	STopicItem *pCurTopic = NULL;
	SCRSTreeNodeInfo *pCurNodeInfo = NULL;
	if (!GetCurSelMsgAndTreeNode(&pCurTopic, &pCurNodeInfo))
		return;

	ExportMsgFromNode(pCurTopic, pCurNodeInfo);
}

void CCRSInfoServerDlg::OnBtnPreview()
{
	// Get Selected Msg and TreeNode
	STopicItem *pCurTopic = NULL;
	SCRSTreeNodeInfo *pCurNodeInfo = NULL;
	if (!GetCurSelMsgAndTreeNode(&pCurTopic, &pCurNodeInfo))
		return;	

	ExportMsgFromNode(pCurTopic, pCurNodeInfo, TRUE);
}

void CCRSInfoServerDlg::OnBtnRefresh()
{
	RefreshPhaseTree();
	RefreshDateCombobox();
}

BOOL CCRSInfoServerDlg::TreeNodeInfo2NotifyMsg( IN SCRSTreeNodeInfo *pTreeNodeInfo, OUT STNotifyMsg &sNotifyMsg )
{
	if (!pTreeNodeInfo)
		return FALSE;

	sNotifyMsg.strDisciplineID = AxCommonInt2String(pTreeNodeInfo->iDisciplineID);
	sNotifyMsg.strEventID = AxCommonInt2String(pTreeNodeInfo->iEventID);
	sNotifyMsg.strPhaseID = AxCommonInt2String(pTreeNodeInfo->iPhaseID);
	sNotifyMsg.strMatchID = AxCommonInt2String(pTreeNodeInfo->iMatchID);
	sNotifyMsg.strSessionID = AxCommonInt2String(pTreeNodeInfo->iSessionID);
	sNotifyMsg.strCourtID = AxCommonInt2String(pTreeNodeInfo->iCourtID);

	sNotifyMsg.strDisciplineCode = pTreeNodeInfo->strDisciplineCode;
	sNotifyMsg.strEventCode = pTreeNodeInfo->strEventCode;
	sNotifyMsg.strPhaseCode = pTreeNodeInfo->strPhaseCode;
	sNotifyMsg.strUnitCode = pTreeNodeInfo->strMatchCode;

	sNotifyMsg.strVenueCode = pTreeNodeInfo->strVenueCode;
	sNotifyMsg.strGenderCode = pTreeNodeInfo->strGenderCode;

	return TRUE;
}

BOOL CCRSInfoServerDlg::GetCurSelMsgAndTreeNode( OUT STopicItem **pTopicItem, OUT SCRSTreeNodeInfo **pTreeNodeInfo )
{
	// Get Selected Topic
	if (m_nCurSelTopicIdx < 0 || m_nCurSelTopicIdx >= g_TopicManager.GetCount())
	{
		g_Log.OutPutMsg(_T("Please select one Message first!"));
		return FALSE;
	}

	*pTopicItem = g_TopicManager.GetTopicItem(m_nCurSelTopicIdx);
	if (!pTopicItem)
		return FALSE;

	// Get Selected Tree Node
	HTREEITEM treeItem = m_treeSport.GetSelectedItem();
	if (!treeItem)
	{
		g_Log.OutPutMsg(_T("Please select one Tree Node first!"));
		return FALSE;
	}

	// Find the Node information
	*pTreeNodeInfo = (SCRSTreeNodeInfo*)m_treeSport.GetItemData(treeItem);
	if (!pTreeNodeInfo)
		return FALSE;

	return TRUE;
}

void CCRSInfoServerDlg::EnableControlBtn()
{
	// Get Selected Msg and TreeNode
	STopicItem *pCurTopic = NULL;
	SCRSTreeNodeInfo *pCurNodeInfo = NULL;
	if (!GetCurSelMsgAndTreeNode(&pCurTopic, &pCurNodeInfo))
		return;	

	EMCRSNodeType MsgLevel = Str2NodeType(pCurTopic->m_strMsgLevel);
	if ((int)MsgLevel < pCurNodeInfo->iNodeType)
	{
		GetDlgItem(IDC_BTN_EXPORT)->EnableWindow(FALSE);
		GetDlgItem(IDC_BTN_PREVIEW)->EnableWindow(FALSE);
	}
	else if ((int)MsgLevel == pCurNodeInfo->iNodeType)
	{
		GetDlgItem(IDC_BTN_EXPORT)->EnableWindow(TRUE);
		GetDlgItem(IDC_BTN_PREVIEW)->EnableWindow(TRUE);
	}
	else
	{
		GetDlgItem(IDC_BTN_EXPORT)->EnableWindow(TRUE);
		GetDlgItem(IDC_BTN_PREVIEW)->EnableWindow(FALSE);
	}
}

BOOL CCRSInfoServerDlg::ExportMsgFromNode( STopicItem *pTopicItem, SCRSTreeNodeInfo *pTreeNodeInfo, BOOL bPreview /*=FALSE*/)
{
	if (!pTopicItem || !pTreeNodeInfo)
		return FALSE;

	EMCRSNodeType MsgLevel = Str2NodeType(pTopicItem->m_strMsgLevel);

	if (MsgLevel < pTreeNodeInfo->iNodeType)		// Msg not belongs to Node then return
	{
		return TRUE;
	}
	else if (MsgLevel == pTreeNodeInfo->iNodeType)	// level of Msg equal to the Node
	{
		STNotifyMsg sNotifyMsg;
		TreeNodeInfo2NotifyMsg(pTreeNodeInfo, sNotifyMsg);
		sNotifyMsg.strDate = m_strCmbSelDateID;
		
		SendMsgToCRSInfo(pTopicItem, 0, &sNotifyMsg, bPreview);

		return TRUE;
	}
	else
	{
		HTREEITEM hCurItem = NULL;
		m_mapKeyToNodePtr.Lookup(pTreeNodeInfo->strNodeKey, (void*&)hCurItem);
		if (!hCurItem)
			return FALSE;

		HTREEITEM hChildItem = m_treeSport.GetChildItem(hCurItem);
		while (hChildItem != NULL)
		{
			SCRSTreeNodeInfo *pChildTreeNodeInfo = (SCRSTreeNodeInfo *)m_treeSport.GetItemData(hChildItem);
			ExportMsgFromNode(pTopicItem, pChildTreeNodeInfo, bPreview);

			hChildItem = m_treeSport.GetNextSiblingItem(hChildItem);
		}

		return TRUE;
	}

}

void CCRSInfoServerDlg::OnBtnSetFilePath()
{
	if (AxCommonFolderDlg(_T("Select Base Export Patch for TVResult :"), CCRSInfoServerDlg::m_strFilePath, this, CCRSInfoServerDlg::m_strFilePath))
	{
		CEdit* pTextFilePath = (CEdit*)GetDlgItem(IDC_EDIT_FILEPATH);
		pTextFilePath->SetWindowTextW(CCRSInfoServerDlg::m_strFilePath);
	}
	else
	{
		CEdit* pTextFilePath = (CEdit*)GetDlgItem(IDC_EDIT_FILEPATH);
		pTextFilePath->GetWindowTextW(CCRSInfoServerDlg::m_strFilePath);
	}
}


void CCRSInfoServerDlg::OnTextFilePathKillfocus()
{
	CEdit* pTextFilePath = (CEdit*)GetDlgItem(IDC_EDIT_FILEPATH);
	pTextFilePath->GetWindowTextW(CCRSInfoServerDlg::m_strFilePath);
}
