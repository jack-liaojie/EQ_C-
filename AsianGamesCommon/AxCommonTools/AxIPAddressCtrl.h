/////////////////////////////////////////////////////////////////////////////
// File Name: AsIPAddressCtrl.h
// Date: 2006.12.28
// Author: Haijun ZHAO
/////////////////////////////////////////////////////////////////////////////

#pragma once

class AX_OVRCOMMON_EXP CAxIPAddressCtrl : public CIPAddressCtrl
{
	DECLARE_DYNAMIC(CAxIPAddressCtrl)

public:
	CAxIPAddressCtrl() {};

	// Attributes
public:
	int GetAddress(CString& strAddress);

	int GetAddress(BYTE& nField0, BYTE& nField1, BYTE& nField2, BYTE& nField3)
	{
		return CIPAddressCtrl::GetAddress(nField0, nField1, nField2, nField3);
	}

	int GetAddress(DWORD& dwAddress)
	{
		return CIPAddressCtrl::GetAddress(dwAddress);
	}

	void SetAddress(LPCTSTR lpszAddress);

	void SetAddress(BYTE nField0, BYTE nField1, BYTE nField2, BYTE nField3)
	{
		CIPAddressCtrl::SetAddress(nField0, nField1, nField2, nField3);
	}

	void SetAddress(DWORD dwAddress)
	{
		CIPAddressCtrl::SetAddress(dwAddress);
	}

	// Operations
public:
	CString	ReadProfileAddress(LPCTSTR lpszSection,	LPCTSTR lpszEntry,	LPCTSTR lpszDefault = _T("0.0.0.0"));

	void	WriteProfileAddress(LPCTSTR lpszSection, LPCTSTR lpszEntry);

	// Implementation
public:
	CString	ByteAddressToString(BYTE nField0, 
								BYTE nField1, 
								BYTE nField2, 
								BYTE nField3);

	void StringAddressToByte(LPCTSTR lpszAddress,
								BYTE& nField0, 
								BYTE& nField1, 
								BYTE& nField2, 
								BYTE& nField3);
};


