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
	emWndGeneralData = 0, // 基础数据
	emWndDrawArrange,	  // 抽签编排	
	emWndMatchSchedule,   // 比赛安排
	emWndDataEntry,		  // 赛时数据
	emWndReportManager,	  // 报表管理
	emWndRankMedal,		  // 排名奖牌
};

struct SAxUserRoleInfo  // 帐号、角色定义
{
	int		iUserID;		    // 用户账号ID
	int		iRoleID;			// 用户角色ID
	CUIntArray aryModuleID;     // 角色所拥有的功能ID定义

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

struct SAxTreeNodeInfo  // 树控件节点定义
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

// 获得主进程路径
AX_OVRCOMMON_EXP BOOL AxCommonGetModulePath(CString& strModulePath, LPCTSTR lpModuleName);

// 设置控件的字体
AX_OVRCOMMON_EXP BOOL AxCommonSetCtrlFont(CWnd* pCtrl, CFont* pFont = NULL);

// 字符转换转换COleVariant 到字符串
AX_OVRCOMMON_EXP LPSTR AxCommonUnicodeToAnsi( LPWSTR pSrc );
AX_OVRCOMMON_EXP LPWSTR AxCommonAnsiToUnicode( LPSTR pSrc );
AX_OVRCOMMON_EXP CString AxCommonOleVariant2String(const COleVariant& varVar);

// 选择文件夹及文件
AX_OVRCOMMON_EXP BOOL AxCommonFolderDlg( LPCTSTR lpszDesc, OUT CString& strFolder,  CWnd* pWnd=NULL , CString strPreSelPath = _T("")); // 
AX_OVRCOMMON_EXP BOOL AxCommonFileDlg( BOOL bOpen, LPCTSTR lpszDefExt, LPCTSTR lpszFileName, DWORD dwFlags, LPCTSTR lpszFilter, LPCTSTR lpszTitle, CString& strFilePath, CWnd* pWnd);

// 文件操作
AX_OVRCOMMON_EXP BOOL AxCommonGetFileInfo( LPCTSTR lpFileName, CString& strDriverName, CString& strDirName, CString& strFileName, CString& strExtName);
AX_OVRCOMMON_EXP BOOL AxCommonDoesFileExist(LPCTSTR lpFile);
AX_OVRCOMMON_EXP BOOL AxCommonDoesDirExist(LPCTSTR lpDir);
AX_OVRCOMMON_EXP CString AxCommonAdjustFileName(LPCTSTR lpFileName );
AX_OVRCOMMON_EXP BOOL AxCommonCreateDir(const CString &strDir ); // 创建指定路径，解决中间路径不存在时使用CreateDirectory()失败问题
AX_OVRCOMMON_EXP BOOL AxCommonDeleteDir(const CString &strDir ); // 删除指定路径下的文件及子目录，解决DeleteDirectory()只能删除空目录的问题

// 为了方便数据库使用
AX_OVRCOMMON_EXP void AxCommonTransRecordSet(CAxADORecordSet& recordSet, OUT SAxTableRecordSet &sTableRecords);

// 填充Grid 控件
AX_OVRCOMMON_EXP BOOL AxCommonFillGridCtrl(CAsCoolGridCtrl* pGridCtrl, CAxADORecordSet& recordSet, BOOL bColorRow = TRUE, COLORREF clrOddRow = OVR_GRID_ODD_ROW_COLOR, COLORREF clrEvenRow = OVR_GRID_EVEN_ROW_COLOR, LOGFONT* lgHeaderFont = NULL, LOGFONT* lgCellTextFont = NULL);

AX_OVRCOMMON_EXP BOOL AxCommonFillGridCtrl(CAsCoolGridCtrl* pGridCtrl, SAxTableRecordSet& rsTable, BOOL bColorRow = TRUE, COLORREF clrOddRow = OVR_GRID_ODD_ROW_COLOR, COLORREF clrEvenRow = OVR_GRID_EVEN_ROW_COLOR, LOGFONT* lgHeaderFont = NULL, LOGFONT* lgCellTextFont = NULL);

// 根据Grid的列名获取列Index
AX_OVRCOMMON_EXP int AxCommonGetColIdxByName(CAsCoolGridCtrl* pGridCtrl, CString strColumnName);

// 填充Grid内嵌CombBox的内容
AX_OVRCOMMON_EXP void AxCommonFillComboBox( AryAxCmbItems &aryCmb, CAxADORecordSet &RecordSet, int nValueIndex, int nKeyIndex );
AX_OVRCOMMON_EXP void AxCommonFillComboBox( CComboBox &ComboBox, CAxADORecordSet &RecordSet, int nValueIndex, int nKeyIndex );

// 公用的数据查询
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

// 生成格式化的txt或CSV文本
AX_OVRCOMMON_EXP BOOL AxCommonBuildFile(const LPCTSTR lpFileName, CAxADORecordSet& recordSet, CString strFlag = _T(","));
AX_OVRCOMMON_EXP BOOL AxCommonBuildFile(const LPCTSTR lpFileName, SAxTableRecordSet& rsTable, CString strFlag = _T(","));

// 将CSV文件内容转换为 SAxTableRecordSet 记录集
AX_OVRCOMMON_EXP BOOL AxCommonParseTxtToRecordSet(const CString &strCSVContent, OUT SAxTableRecordSet& rsTable, CString strFlag = _T(","));

AX_OVRCOMMON_EXP CString AxCommonInt2String(int nVal);
