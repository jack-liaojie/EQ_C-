#include "stdafx.h"
#include "AxIPAddressCtrl.h"
#include <malloc.h>		// for _alloca

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#pragma warning(disable:4267)

IMPLEMENT_DYNAMIC(CAxIPAddressCtrl, CIPAddressCtrl)

int CAxIPAddressCtrl::GetAddress(CString& strAddress)
{
	BYTE nField0, nField1, nField2, nField3;

	int rc = CIPAddressCtrl::GetAddress(nField0, nField1, nField2, nField3);

	strAddress = ByteAddressToString(nField0, nField1, nField2, nField3);

	return rc;
}

void CAxIPAddressCtrl::SetAddress(LPCTSTR lpszAddress)
{
	ASSERT(lpszAddress && lpszAddress[0] != _T('\0'));

	BYTE nField0, nField1, nField2, nField3;

	StringAddressToByte(lpszAddress, nField0, nField1, nField2, nField3);

	CIPAddressCtrl::SetAddress(nField0, nField1, nField2, nField3);
}


CString CAxIPAddressCtrl::ByteAddressToString(BYTE nField0, 
											 BYTE nField1, 
											 BYTE nField2, 
											 BYTE nField3)
{
	CString strIP = _T("");

	strIP.Format(_T("%u.%u.%u.%u"), nField0, nField1, nField2, nField3);

	return strIP;
}

void CAxIPAddressCtrl::StringAddressToByte(LPCTSTR lpszAddress,
										  BYTE& nField0, 
										  BYTE& nField1, 
										  BYTE& nField2, 
										  BYTE& nField3)
{
	ASSERT(lpszAddress && lpszAddress[0] != _T('\0'));

	// get copy of string for _tcstok
	int len = _tcslen(lpszAddress)+2;		// size in TCHARs
	TCHAR *buf = (TCHAR *) _alloca(len * sizeof(TCHAR));
	memset(buf, 0, len * sizeof(TCHAR));
	_tcscpy(buf, lpszAddress);

	TCHAR *seps = _T(".\r\n");
	TCHAR *field = NULL;
	BYTE fields[4] = { 0 };
	field = _tcstok(buf, seps);

	// loop to get all 4 fields
	for (int i = 0; i < 4; i++)
	{
		if (!field)
			break;
		fields[i] = (BYTE) _tcstoul(field, NULL, 10);
		field = _tcstok(NULL, seps);
	}

	nField0 = fields[0];
	nField1 = fields[1];
	nField2 = fields[2];
	nField3 = fields[3];
}

CString CAxIPAddressCtrl::ReadProfileAddress(LPCTSTR lpszSection,
											LPCTSTR lpszEntry,
											LPCTSTR lpszDefault /*= _T("0.0.0.0")*/)
{
	ASSERT(lpszSection && lpszSection[0] != _T('\0'));
	ASSERT(lpszEntry && lpszEntry[0] != _T('\0'));

	CString strDefault = lpszDefault;

	CString strIP = AfxGetApp()->GetProfileString(lpszSection, lpszEntry, strDefault);

	SetAddress(strIP);

	return strIP;
}

void CAxIPAddressCtrl::WriteProfileAddress(LPCTSTR lpszSection, 
										  LPCTSTR lpszEntry)
{
	ASSERT(lpszSection && lpszSection[0] != _T('\0'));
	ASSERT(lpszEntry && lpszEntry[0] != _T('\0'));

	CString strIP = _T("");

	GetAddress(strIP);

	AfxGetApp()->WriteProfileString(lpszSection, lpszEntry, strIP);
}
