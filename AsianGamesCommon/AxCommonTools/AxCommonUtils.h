#pragma once

#include "AxCoolADO.h"
#include "AxTableRecordDef.h"


#define CLR_RED RGB(255, 0, 0)
#define GRID_MS_RUNNING_SUSPEND RGB(0, 255, 0)
#define GRID_MS_OFFICIAL_UNOFFICIAL_REVISION RGB(255, 0, 0)

//#define OVR_CLIENT_3DFACE (XTPPaintManager()->GetXtremeColor(XPCOLOR_3DFACE))
#define OVR_CLIENT_3DFACE RGB(184, 207, 233)
#define OVR_CTRL_3DFACE RGB(212, 228, 242)
#define OVR_CTRL_TEXT_COLOR (XTPPaintManager()->GetXtremeColor(XPCOLOR_PUSHED_TEXT))
#define OVR_GRID_ODD_ROW_COLOR RGB(230, 239, 248)
#define OVR_GRID_EVEN_ROW_COLOR RGB(202, 221, 238)

class CAsCoolGridCtrl;

enum EMainViewUIType
{
	emUnknown = -1,
	emWndGeneralData = 0, // ��������
	emWndDrawArrange,	  // ��ǩ����	
	emWndMatchSchedule,   // ��������
	emWndDataEntry,		  // ��ʱ����
	emWndReportManager,	  // �������
	emWndRankMedal,		  // ��������
};

struct SAxUserRoleInfo  // �ʺš���ɫ����
{
	int		iUserID;		    // �û��˺�ID
	int		iRoleID;			// �û���ɫID
	CUIntArray aryModuleID;     // ��ɫ��ӵ�еĹ���ID����

	SAxUserRoleInfo(){}

	SAxUserRoleInfo(const SAxUserRoleInfo& copy)
	{
		*this = copy;
	}

	SAxUserRoleInfo& operator= (const SAxUserRoleInfo& copy)
	{
		iUserID = copy.iUserID;
		iRoleID = copy.iRoleID;
		
		aryModuleID.RemoveAll();

		for(int i = 0; i < copy.aryModuleID.GetCount(); i++)
		{
			aryModuleID.Add(copy.aryModuleID.GetAt(i));
		}	

		return *this;
	}	
};
typedef CArray<SAxUserRoleInfo, SAxUserRoleInfo&> AxArrayUserRoleInfo;
typedef CArray<SAxUserRoleInfo*, SAxUserRoleInfo*> PAxArrayUserRoleInfo;

struct SAxTreeNodeInfo  // ���ؼ��ڵ㶨��
{
	CString strNodeKey;
	int		iNodeType;
	int		iSportID;
	int		iDisciplineID;
	int		iEventID;
	int		iPhaseID;
	int		iFatherPhaseID;
	int		iMatchID;
	int		iPhaseType;
	int		iPhaseSize;

	SAxTreeNodeInfo(){}

	SAxTreeNodeInfo(const SAxTreeNodeInfo& copy)
	{
		*this = copy;
	}

	SAxTreeNodeInfo& operator= (const SAxTreeNodeInfo& copy)
	{
		strNodeKey = copy.strNodeKey;
		iNodeType = copy.iNodeType;
		iSportID = copy.iSportID;
		iDisciplineID = copy.iDisciplineID;
		iEventID = copy.iEventID;
		iPhaseID = copy.iPhaseID;
		iFatherPhaseID = copy.iFatherPhaseID;
		iMatchID = copy.iMatchID;
		iPhaseType = copy.iPhaseType;
		iPhaseSize = copy.iPhaseSize;

		return *this;
	}	
};
typedef CArray<SAxTreeNodeInfo, SAxTreeNodeInfo&> AxArrayTreeNodeInfo;
typedef CArray<SAxTreeNodeInfo*, SAxTreeNodeInfo*> PAxArrayTreeNodeInfo;

// ���������·��
AX_OVRCOMMON_EXP BOOL AxCommonGetModulePath(CString& strModulePath, LPCTSTR lpModuleName);

// ���ÿؼ�������
AX_OVRCOMMON_EXP BOOL AxCommonSetCtrlFont(CWnd* pCtrl, CFont* pFont = NULL);

// �ַ�ת��ת��COleVariant ���ַ���
AX_OVRCOMMON_EXP LPSTR AxCommonUnicodeToAnsi( LPWSTR pSrc );
AX_OVRCOMMON_EXP LPWSTR AxCommonAnsiToUnicode( LPSTR pSrc );
AX_OVRCOMMON_EXP CString AxCommonOleVariant2String(const COleVariant& varVar);

// ѡ���ļ��м��ļ�
AX_OVRCOMMON_EXP BOOL AxCommonFolderDlg( LPCTSTR lpszDesc, OUT CString& strFolder,  CWnd* pWnd=NULL , CString strPreSelPath = _T("")); // 
AX_OVRCOMMON_EXP BOOL AxCommonFileDlg( BOOL bOpen, LPCTSTR lpszDefExt, LPCTSTR lpszFileName, DWORD dwFlags, LPCTSTR lpszFilter, LPCTSTR lpszTitle, CString& strFilePath, CWnd* pWnd);

// �ļ�����
AX_OVRCOMMON_EXP BOOL AxCommonGetFileInfo( LPCTSTR lpFileName, CString& strDriverName, CString& strDirName, CString& strFileName, CString& strExtName);
AX_OVRCOMMON_EXP BOOL AxCommonDoesFileExist(LPCTSTR lpFile);
AX_OVRCOMMON_EXP BOOL AxCommonDoesDirExist(LPCTSTR lpDir);
AX_OVRCOMMON_EXP CString AxCommonAdjustFileName(LPCTSTR lpFileName );
AX_OVRCOMMON_EXP BOOL AxCommonCreateDir(const CString &strDir ); // ����ָ��·��������м�·��������ʱʹ��CreateDirectory()ʧ������
AX_OVRCOMMON_EXP BOOL AxCommonDeleteDir(const CString &strDir ); // ɾ��ָ��·���µ��ļ�����Ŀ¼�����DeleteDirectory()ֻ��ɾ����Ŀ¼������

// Ϊ�˷������ݿ�ʹ��
AX_OVRCOMMON_EXP void AxCommonTransRecordSet(CAxADORecordSet& recordSet, OUT SAxTableRecordSet &sTableRecords);

// ���Grid �ؼ�
AX_OVRCOMMON_EXP BOOL AxCommonFillGridCtrl(CAsCoolGridCtrl* pGridCtrl, CAxADORecordSet& recordSet, BOOL bColorRow = TRUE, COLORREF clrOddRow = OVR_GRID_ODD_ROW_COLOR, COLORREF clrEvenRow = OVR_GRID_EVEN_ROW_COLOR, LOGFONT* lgHeaderFont = NULL, LOGFONT* lgCellTextFont = NULL);

AX_OVRCOMMON_EXP BOOL AxCommonFillGridCtrl(CAsCoolGridCtrl* pGridCtrl, SAxTableRecordSet& rsTable, BOOL bColorRow = TRUE, COLORREF clrOddRow = OVR_GRID_ODD_ROW_COLOR, COLORREF clrEvenRow = OVR_GRID_EVEN_ROW_COLOR, LOGFONT* lgHeaderFont = NULL, LOGFONT* lgCellTextFont = NULL);

// ����Grid��������ȡ��Index
AX_OVRCOMMON_EXP int AxCommonGetColIdxByName(CAsCoolGridCtrl* pGridCtrl, CString strColumnName);

// ���Grid��ǶCombBox������
AX_OVRCOMMON_EXP void AxCommonFillComboBox( AryAxCmbItems &aryCmb, CAxADORecordSet &RecordSet, int nValueIndex, int nKeyIndex );
AX_OVRCOMMON_EXP void AxCommonFillComboBox( CComboBox &ComboBox, CAxADORecordSet &RecordSet, int nValueIndex, int nKeyIndex );

// ���õ����ݲ�ѯ
AX_OVRCOMMON_EXP BOOL AxCommonGetActiveInfo(CAxADODataBase* pDB, int &iSportID, int &iDisciplineID, CString &strLanguageCode);
AX_OVRCOMMON_EXP BOOL AxCommonGetScheduleTree(CAxADODataBase* pDB, int iID, int iType, CString strLanguageCode, CAxADORecordSet& obRecordSet);

AX_OVRCOMMON_EXP BOOL AxCommonGetOperators(CAxADODataBase* pDB, CAxADORecordSet& obRecordSet);
AX_OVRCOMMON_EXP BOOL AxCommonGetRoles(CAxADODataBase* pDB, int iOperatorID, CAxADORecordSet& obRecordSet);
AX_OVRCOMMON_EXP BOOL AxCommonGetOperatorPassWord(CAxADODataBase* pDB, int iOperatorID, CString& strPassWord);
AX_OVRCOMMON_EXP BOOL AxCommonGetOperatorModules(CAxADODataBase* pDB, int iRoleID, CUIntArray& aryModuleID);

AX_OVRCOMMON_EXP BOOL AxCommonGetSexList(CAxADODataBase* pDB, CAxADORecordSet& obRecordSet, CString strLanguageCode);
AX_OVRCOMMON_EXP BOOL AxCommonGetRegTypeList(CAxADODataBase* pDB, CAxADORecordSet& obRecordSet, CString strLanguageCode);
AX_OVRCOMMON_EXP BOOL AxCommonGetFederationList(CAxADODataBase* pDB, CAxADORecordSet& obRecordSet, int iDisciplineID, CString strLanguageCode);
AX_OVRCOMMON_EXP BOOL AxCommonGetEventList(CAxADODataBase* pDB, CAxADORecordSet& obRecordSet, int iDisciplineID, CString strLanguageCode);

// ���ɸ�ʽ����txt��CSV�ı�
AX_OVRCOMMON_EXP BOOL AxCommonBuildFile(const LPCTSTR lpFileName, CAxADORecordSet& recordSet, CString strFlag = _T(","));
AX_OVRCOMMON_EXP BOOL AxCommonBuildFile(const LPCTSTR lpFileName, SAxTableRecordSet& rsTable, CString strFlag = _T(","));

// ��CSV�ļ�����ת��Ϊ SAxTableRecordSet ��¼��
AX_OVRCOMMON_EXP BOOL AxCommonParseTxtToRecordSet(const CString &strCSVContent, OUT SAxTableRecordSet& rsTable, CString strFlag = _T(","));

AX_OVRCOMMON_EXP CString AxCommonInt2String(int nVal);
