#pragma once

#include "AxCoolADO.h"
#include "AxTableRecordDef.h"

#define CLIENT_3DFACE RGB(184, 207, 233)
#define CTRL_3DFACE RGB(212, 228, 242)
#define GRID_ODD_ROW_COLOR RGB(230, 239, 248)
#define GRID_EVEN_ROW_COLOR RGB(202, 221, 238)

class CAsCoolGridCtrl;

// 获得主进程路径
 BOOL AxCommonGetModulePath(CString& strModulePath, LPCTSTR lpModuleName);

// 设置控件的字体
 BOOL AxCommonSetCtrlFont(CWnd* pCtrl, CFont* pFont = NULL);

// 字符转换转换COleVariant 到字符串
 LPSTR AxCommonUnicodeToAnsi( LPWSTR pSrc );
 LPWSTR AxCommonAnsiToUnicode( LPSTR pSrc );
 CString AxCommonOleVariant2String(const COleVariant& varVar);

// 选择文件夹及文件
 BOOL AxCommonFolderDlg( LPCTSTR lpszDesc, OUT CString& strFolder,  CWnd* pWnd=NULL , CString strPreSelPath = _T("")); // 
 BOOL AxCommonFileDlg( BOOL bOpen, LPCTSTR lpszDefExt, LPCTSTR lpszFileName, DWORD dwFlags, LPCTSTR lpszFilter, LPCTSTR lpszTitle, CString& strFilePath, CWnd* pWnd);

// 文件操作
 BOOL AxCommonGetFileInfo( LPCTSTR lpFileName, CString& strDriverName, CString& strDirName, CString& strFileName, CString& strExtName);
 BOOL AxCommonDoesFileExist(LPCTSTR lpFile);
 BOOL AxCommonDoesDirExist(LPCTSTR lpDir);
 CString AxCommonAdjustFileName(LPCTSTR lpFileName );
 BOOL AxCommonCreateDir(const CString &strDir ); // 创建指定路径，解决中间路径不存在时使用CreateDirectory()失败问题
 BOOL AxCommonDeleteDir(const CString &strDir ); // 删除指定路径下的文件及子目录，解决DeleteDirectory()只能删除空目录的问题

// 生成格式化的txt或CSV文本
 BOOL AxCommonBuildFile(const LPCTSTR lpFileName, CAxADORecordSet& recordSet, CString strFlag = _T(","));
 BOOL AxCommonBuildFile(const LPCTSTR lpFileName, SAxTableRecordSet& rsTable, CString strFlag = _T(","));

// 将CSV文件内容转换为 SAxTableRecordSet 记录集
 BOOL AxCommonParseTxtToRecordSet(const CString &strCSVContent, OUT SAxTableRecordSet& rsTable, CString strFlag = _T(","));

 CString AxCommonInt2String(int nVal);

// 为了方便数据库使用
 void AxCommonTransRecordSet(CAxADORecordSet& recordSet, OUT SAxTableRecordSet &sTableRecords);

 BOOL DoSystemSetup(CAxADODataBase *pDataBase, OUT CString &strDisciplineCode);