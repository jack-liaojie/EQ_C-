#pragma once

class CNotifyManager
{
public:
	DECLARE_THREAD_SAFETY

	CNotifyManager(void);
	virtual ~CNotifyManager(void);

private:

	CStringArray		m_straAllNotifyTypes;
	CStringArray		m_straAllMapValues;

	CUIntArray			m_naNotifyState;

public:
	void ReadConfig();
	void WriteConfig();

	int GetCount();
	void SetSize(int nSize);

	int FindType(CString strNotifyType);
	CString GetTypeAt(int nIndex);
	void SetTypeAt(int nIndex, CString strNewType);
	void SetTypeAt(CString strOldType, CString strNewType);
	void AddType(CString strType, CString strIDs = _T(""));
	void DelTypeAt(int nIndex);

	void SetValuesAt(int nIndex, CString strIDs);
	void SetValuesAt(CString strType, CString strIDs);
	CString GetValuesAt(int nIndex);
	CString GetValuesAt(CString strType);

	// NotifyStatus 
	void SetTypeState(int nIndex);
	void ResetTypeState(int nIndex);
	BOOL GetTypeState(int nIndex);

};
