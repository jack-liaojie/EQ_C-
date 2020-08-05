#pragma once

#include "AxCoolADO.h"
#include "AxTableRecordDef.h"

#define CLIENT_3DFACE RGB(184, 207, 233)
#define CTRL_3DFACE RGB(212, 228, 242)
#define GRID_ODD_ROW_COLOR RGB(230, 239, 248)
#define GRID_EVEN_ROW_COLOR RGB(202, 221, 238)

class CAsCoolGridCtrl;

// ���������·��
 BOOL AxCommonGetModulePath(CString& strModulePath, LPCTSTR lpModuleName);

// ���ÿؼ�������
 BOOL AxCommonSetCtrlFont(CWnd* pCtrl, CFont* pFont = NULL);

// �ַ�ת��ת��COleVariant ���ַ���
 LPSTR AxCommonUnicodeToAnsi( LPWSTR pSrc );
 LPWSTR AxCommonAnsiToUnicode( LPSTR pSrc );
 CString AxCommonOleVariant2String(const COleVariant& varVar);

// ѡ���ļ��м��ļ�
 BOOL AxCommonFolderDlg( LPCTSTR lpszDesc, OUT CString& strFolder,  CWnd* pWnd=NULL , CString strPreSelPath = _T("")); // 
 BOOL AxCommonFileDlg( BOOL bOpen, LPCTSTR lpszDefExt, LPCTSTR lpszFileName, DWORD dwFlags, LPCTSTR lpszFilter, LPCTSTR lpszTitle, CString& strFilePath, CWnd* pWnd);

// �ļ�����
 BOOL AxCommonGetFileInfo( LPCTSTR lpFileName, CString& strDriverName, CString& strDirName, CString& strFileName, CString& strExtName);
 BOOL AxCommonDoesFileExist(LPCTSTR lpFile);
 BOOL AxCommonDoesDirExist(LPCTSTR lpDir);
 CString AxCommonAdjustFileName(LPCTSTR lpFileName );
 BOOL AxCommonCreateDir(const CString &strDir ); // ����ָ��·��������м�·��������ʱʹ��CreateDirectory()ʧ������
 BOOL AxCommonDeleteDir(const CString &strDir ); // ɾ��ָ��·���µ��ļ�����Ŀ¼�����DeleteDirectory()ֻ��ɾ����Ŀ¼������

// ���ɸ�ʽ����txt��CSV�ı�
 BOOL AxCommonBuildFile(const LPCTSTR lpFileName, CAxADORecordSet& recordSet, CString strFlag = _T(","));
 BOOL AxCommonBuildFile(const LPCTSTR lpFileName, SAxTableRecordSet& rsTable, CString strFlag = _T(","));

// ��CSV�ļ�����ת��Ϊ SAxTableRecordSet ��¼��
 BOOL AxCommonParseTxtToRecordSet(const CString &strCSVContent, OUT SAxTableRecordSet& rsTable, CString strFlag = _T(","));

 CString AxCommonInt2String(int nVal);

// Ϊ�˷������ݿ�ʹ��
 void AxCommonTransRecordSet(CAxADORecordSet& recordSet, OUT SAxTableRecordSet &sTableRecords);

 BOOL DoSystemSetup(CAxADODataBase *pDataBase, OUT CString &strDisciplineCode);