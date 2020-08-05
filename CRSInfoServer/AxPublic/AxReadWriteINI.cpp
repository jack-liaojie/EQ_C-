#include "stdafx.h"
#include "AxReadWriteINI.h"

//-----------------------------------------------------------------
// Variables
//-----------------------------------------------------------------

static TCHAR s_szAppName[100] = { _T("") };
static TCHAR s_szModulePath[_MAX_PATH]		= { _T("") };
static TCHAR s_szIniFileName[_MAX_PATH]		= { _T("") };

//-----------------------------------------------------------------
// Get application pathes
//-----------------------------------------------------------------
LPCTSTR CAxReadWriteINI::GetAppModulePath(LPCTSTR lpModuleName)
{
	// Init with the path of exe or the regular DLL that loads this MFC extension DLL 
	if (_tcslen(s_szModulePath) == 0)
	{
		TCHAR szPathName[_MAX_PATH], szDrv[_MAX_DRIVE], szDir[_MAX_DIR];
		GetModuleFileName(GetModuleHandle(lpModuleName), szPathName, _MAX_PATH);
		_tsplitpath(szPathName, szDrv, szDir, NULL, NULL);

		CString strModule;
		strModule = CString(szDrv) + CString(szDir);
		_tcscpy(s_szModulePath, strModule); 
	}
	
	return s_szModulePath; // return pointer to the static buffer
}
//-----------------------------------------------------------------
// Ini file operations
//-----------------------------------------------------------------

CString CAxReadWriteINI::GetAppConfigFile()
{
	CString strConfigFileName;
	CString strModulePath = GetAppModulePath();
	strConfigFileName = strModulePath.TrimRight(_T('\\')) + _T('\\') + AfxGetAppName() + _T(".cfg");

	return strConfigFileName;
}

LPCTSTR CAxReadWriteINI::GetIniFileName()
{
	if (_tcslen(s_szIniFileName) == 0)
	{
		_tcscpy(s_szIniFileName, GetAppModulePath());
		_tcscat(s_szIniFileName, _T("\\CommonConfig.cfg"));
	}

	return s_szIniFileName;
}

BOOL CAxReadWriteINI::IniWriteString(LPCTSTR pszSection, LPCTSTR pszKey, LPCTSTR pszData, LPCTSTR pszIniFile)
{
	return WritePrivateProfileString(pszSection, pszKey, pszData, (pszIniFile == NULL? GetIniFileName() : pszIniFile));
}

BOOL CAxReadWriteINI::IniWriteInt(LPCTSTR pszSection, LPCTSTR pszKey, INT nData, LPCTSTR pszIniFile)
{
	TCHAR szBuf[50];
	_stprintf(szBuf, _T("%d"), nData);

	return WritePrivateProfileString(pszSection, pszKey, szBuf, (pszIniFile == NULL? GetIniFileName() : pszIniFile));
}

BOOL CAxReadWriteINI::IniWriteLong(LPCTSTR pszSection, LPCTSTR pszKey, LONG lData, LPCTSTR pszIniFile)
{
	TCHAR szBuf[50];
	_stprintf(szBuf, _T("%ld"), lData);

	return WritePrivateProfileString(pszSection, pszKey, szBuf, (pszIniFile == NULL? GetIniFileName() : pszIniFile));
}

BOOL CAxReadWriteINI::IniWriteDouble(LPCTSTR pszSection, LPCTSTR pszKey, double fData, LPCTSTR pszIniFile)
{
	TCHAR szBuf[50];
	_stprintf(szBuf, _T("%f"), fData);

	return WritePrivateProfileString(pszSection, pszKey, szBuf, (pszIniFile == NULL? GetIniFileName() : pszIniFile));
}

BOOL CAxReadWriteINI::IniWriteRect(LPCTSTR pszSection, LPCTSTR pszKey, RECT rcData, LPCTSTR pszIniFile)
{
	TCHAR szBuf[50];
	_stprintf(szBuf, _T("%d, %d, %d, %d"), rcData.left, rcData.top, rcData.right, rcData.bottom);

	return WritePrivateProfileString(pszSection, pszKey, szBuf, (pszIniFile == NULL? GetIniFileName() : pszIniFile));
}

BOOL CAxReadWriteINI::IniWritePoint(LPCTSTR pszSection, LPCTSTR pszKey, POINT ptData, LPCTSTR pszIniFile)
{
	TCHAR szBuf[50];
	_stprintf(szBuf, _T("%d, %d"), ptData.x, ptData.y);

	return WritePrivateProfileString(pszSection, pszKey, szBuf, (pszIniFile == NULL? GetIniFileName() : pszIniFile));
}

BOOL CAxReadWriteINI::IniWriteSize(LPCTSTR pszSection, LPCTSTR pszKey, SIZE siData, LPCTSTR pszIniFile)
{
	TCHAR szBuf[50];
	_stprintf(szBuf, _T("%d, %d"), siData.cx, siData.cy);

	return WritePrivateProfileString(pszSection, pszKey, szBuf, (pszIniFile == NULL? GetIniFileName() : pszIniFile));
}

BOOL CAxReadWriteINI::IniWriteColor(LPCTSTR pszSection, LPCTSTR pszKey, DWORD dwColor, LPCTSTR pszIniFile)
{
	LPBYTE p = (LPBYTE)&dwColor;

	TCHAR szBuf[50];
	_stprintf(szBuf, _T("%d, %d, %d, %d"), p[0], p[1], p[2], p[3] );

	return WritePrivateProfileString(pszSection, pszKey, szBuf, (pszIniFile == NULL? GetIniFileName() : pszIniFile));
}

BOOL CAxReadWriteINI::IniReadString(LPCTSTR pszSection, LPCTSTR pszKey, LPTSTR pszData, DWORD dwChars, LPCTSTR pszIniFile)
{
	TCHAR szBuf[512];
	GetPrivateProfileString(pszSection, pszKey, _T(""), szBuf, sizeof(szBuf)/sizeof(TCHAR), (pszIniFile == NULL? GetIniFileName() : pszIniFile));

	// We do not allow empty string (key does not exist, or 0-length value, or all-space-char value)
	CString str = szBuf;
	str.TrimLeft(_T(' '));
	str.TrimRight(_T(' '));
	if (str.IsEmpty()) return FALSE;

	ZeroMemory(pszData, sizeof(TCHAR)*dwChars);
	_tcsncpy(pszData, str, dwChars);

	return TRUE;
}

BOOL CAxReadWriteINI::IniReadString(LPCTSTR pszSection, LPCTSTR pszKey, CString& strData, LPCTSTR pszIniFile)
{
	TCHAR szBuf[512];
	GetPrivateProfileString(pszSection, pszKey, _T(""), szBuf, sizeof(szBuf)/sizeof(TCHAR), (pszIniFile == NULL? GetIniFileName() : pszIniFile));

	// We do not allow empty string (key does not exist, or 0-length value, or all-space-char value)
	CString str = szBuf;
	str.TrimLeft(_T(' '));
	str.TrimRight(_T(' '));
	if (str.IsEmpty()) return FALSE;

	strData = str;

	return TRUE;
}

BOOL CAxReadWriteINI::IniReadInt(LPCTSTR pszSection, LPCTSTR pszKey, INT& nData, LPCTSTR pszIniFile)
{
	TCHAR szBuf[50];
	GetPrivateProfileString(pszSection, pszKey, _T(""), szBuf, sizeof(szBuf)/sizeof(TCHAR), (pszIniFile == NULL? GetIniFileName() : pszIniFile));

	if (_tcslen(szBuf) == 0) return FALSE;
	if (_stscanf(szBuf, _T("%d"), &nData) != 1) return FALSE;

	return TRUE;
}

BOOL CAxReadWriteINI::IniReadLong(LPCTSTR pszSection, LPCTSTR pszKey, LONG& lData, LPCTSTR pszIniFile)
{
	TCHAR szBuf[50];
	GetPrivateProfileString(pszSection, pszKey, _T(""), szBuf, sizeof(szBuf)/sizeof(TCHAR), (pszIniFile == NULL? GetIniFileName() : pszIniFile));

	if (_tcslen(szBuf) == 0) return FALSE;
	if (_stscanf(szBuf, _T("%ld"), &lData) != 1) return FALSE;

	return TRUE;
}

BOOL CAxReadWriteINI::IniReadDouble(LPCTSTR pszSection, LPCTSTR pszKey, double& fData, LPCTSTR pszIniFile)
{
	TCHAR szBuf[50];
	GetPrivateProfileString(pszSection, pszKey, _T(""), szBuf, sizeof(szBuf)/sizeof(TCHAR), (pszIniFile == NULL? GetIniFileName() : pszIniFile));

	if (_tcslen(szBuf) == 0) return FALSE;

	float f;
	if (_stscanf(szBuf, _T("%f"), &f) != 1) return FALSE;

	fData = f;
	return TRUE;
}

BOOL CAxReadWriteINI::IniReadRect(LPCTSTR pszSection, LPCTSTR pszKey, RECT& rcData, LPCTSTR pszIniFile)
{
	TCHAR szBuf[50];
	GetPrivateProfileString(pszSection, pszKey, _T(""), szBuf, sizeof(szBuf)/sizeof(TCHAR), (pszIniFile == NULL? GetIniFileName() : pszIniFile));

	if (_tcslen(szBuf) == 0) return FALSE;

	RECT rc;
	if (_stscanf(szBuf, _T("%d, %d, %d, %d"), &rc.left, &rc.top, &rc.right, &rc.bottom) != 4)
		return FALSE;

	rcData = rc;
	return TRUE;
}

BOOL CAxReadWriteINI::IniReadPoint(LPCTSTR pszSection, LPCTSTR pszKey, POINT& ptData, LPCTSTR pszIniFile)
{
	TCHAR szBuf[50];
	GetPrivateProfileString(pszSection, pszKey, _T(""), szBuf, sizeof(szBuf)/sizeof(TCHAR), (pszIniFile == NULL? GetIniFileName() : pszIniFile));

	if (_tcslen(szBuf) == 0) return FALSE;

	POINT pt;
	if (_stscanf(szBuf, _T("%d, %d"), &pt.x, &pt.y) != 2)
		return FALSE;

	ptData = pt;
	return TRUE;
}

BOOL CAxReadWriteINI::IniReadSize(LPCTSTR pszSection, LPCTSTR pszKey, SIZE& siData, LPCTSTR pszIniFile)
{
	TCHAR szBuf[50];
	GetPrivateProfileString(pszSection, pszKey, _T(""), szBuf, sizeof(szBuf)/sizeof(TCHAR), (pszIniFile == NULL? GetIniFileName() : pszIniFile));

	if (_tcslen(szBuf) == 0) return FALSE;

	SIZE si;
	if (_stscanf(szBuf, _T("%d, %d"), &si.cx, &si.cy) != 2)
		return FALSE;

	siData = si;
	return TRUE;
}

BOOL CAxReadWriteINI::IniReadColor(LPCTSTR pszSection, LPCTSTR pszKey, DWORD& dwColor, LPCTSTR pszIniFile)
{
	TCHAR szBuf[50];
	GetPrivateProfileString(pszSection, pszKey, _T(""), szBuf, sizeof(szBuf)/sizeof(TCHAR), (pszIniFile == NULL? GetIniFileName() : pszIniFile));

	if (_tcslen(szBuf) == 0) return FALSE;

	int t[4];
	if (_stscanf(szBuf, _T("%d, %d, %d, %d"), &t[0], &t[1], &t[2], &t[3]) != 4)
		return FALSE;

	LPBYTE p = (LPBYTE)&dwColor;
	for (int i=0; i<4; i++)
	{
		p[i] = (BYTE)t[i];
	}
	return TRUE;
}

