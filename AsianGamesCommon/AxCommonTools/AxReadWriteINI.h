#pragma once

class AX_OVRCOMMON_EXP CAxReadWriteINI
{
public:
	//-----------------------------------------------------------------
	// Get application pathes.
	//-----------------------------------------------------------------
public:
	// the returned value is a pointer to an internal static buffer,
	// which contains full dir path with a backslash at the end.
	static LPCTSTR GetAppModulePath(LPCTSTR lpModuleName = NULL);	// 

	//-----------------------------------------------------------------
	// Ini file operations
	//-----------------------------------------------------------------
public:
	// Full pathname of the application's ini file.
	// Following functions use this file if pszIniFile is NULL
	static LPCTSTR GetIniFileName();	// return "CommonConfig.cfg" as file name
	static CString GetAppConfigFile();	// return "[ApplicatinName].cfg" as file name

	// Ini file write functions
	static BOOL IniWriteString(LPCTSTR pszSection, LPCTSTR pszKey, LPCTSTR pszData, LPCTSTR pszIniFile = NULL);
	static BOOL IniWriteInt(LPCTSTR pszSection, LPCTSTR pszKey, INT nData, LPCTSTR pszIniFile = NULL);
	static BOOL IniWriteLong(LPCTSTR pszSection, LPCTSTR pszKey, LONG lData, LPCTSTR pszIniFile = NULL);
	static BOOL IniWriteDouble(LPCTSTR pszSection, LPCTSTR pszKey, double fData, LPCTSTR pszIniFile = NULL);
	static BOOL IniWriteRect(LPCTSTR pszSection, LPCTSTR pszKey, RECT rcData, LPCTSTR pszIniFile = NULL);
	static BOOL IniWritePoint(LPCTSTR pszSection, LPCTSTR pszKey, POINT ptData, LPCTSTR pszIniFile = NULL);
	static BOOL IniWriteSize(LPCTSTR pszSection, LPCTSTR pszKey, SIZE siData, LPCTSTR pszIniFile = NULL);
	static BOOL IniWriteColor(LPCTSTR pszSection, LPCTSTR pszKey, DWORD dwColor, LPCTSTR pszIniFile = NULL);

	// Ini file read functions.
	// Return FALSE if the key or valid value does not exist, the value in the variable is not changed.
	static BOOL IniReadString(LPCTSTR pszSection, LPCTSTR pszKey, LPTSTR pszData, DWORD dwChars, LPCTSTR pszIniFile = NULL);
	static BOOL IniReadString(LPCTSTR pszSection, LPCTSTR pszKey, CString& strData, LPCTSTR pszIniFile = NULL);
	static BOOL IniReadInt(LPCTSTR pszSection, LPCTSTR pszKey, INT& nData, LPCTSTR pszIniFile = NULL);
	static BOOL IniReadLong(LPCTSTR pszSection, LPCTSTR pszKey, LONG& lData, LPCTSTR pszIniFile = NULL);
	static BOOL IniReadDouble(LPCTSTR pszSection, LPCTSTR pszKey, double& fData, LPCTSTR pszIniFile = NULL);
	static BOOL IniReadRect(LPCTSTR pszSection, LPCTSTR pszKey, RECT& rcData, LPCTSTR pszIniFile = NULL);
	static BOOL IniReadPoint(LPCTSTR pszSection, LPCTSTR pszKey, POINT& ptData, LPCTSTR pszIniFile = NULL);
	static BOOL IniReadSize(LPCTSTR pszSection, LPCTSTR pszKey, SIZE& siData, LPCTSTR pszIniFile = NULL);
	static BOOL IniReadColor(LPCTSTR pszSection, LPCTSTR pszKey, DWORD& dwColor, LPCTSTR pszIniFile = NULL);
};

