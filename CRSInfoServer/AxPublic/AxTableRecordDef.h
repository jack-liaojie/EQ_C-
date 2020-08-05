//AxTableRecordDef.h
//为了方便使用,对RecordSet的一个转换
#pragma once

#ifndef ConstStr
#define ConstStr const CString&
#endif

#include <afxtempl.h>
#include <afxmt.h>

#define DECLARE_THREAD_SAFETY				CCriticalSection m_CriticalSection;
#define ENTER_THREAD_SAFETY					CSingleLock singleLock((CSyncObject *)&m_CriticalSection, TRUE);
#define ENTER_OBJ_THREAD_SAFETY(syncObj)	CSingleLock singleLock(&syncObj, TRUE);

struct SAxRowRecord
{
	DECLARE_THREAD_SAFETY

	CStringArray m_aryRowColValue;

	SAxRowRecord(){}

	SAxRowRecord(const SAxRowRecord& copy)
	{
		*this = copy;
	}

	SAxRowRecord& operator= (const SAxRowRecord& copy)
	{
		ENTER_THREAD_SAFETY

		m_aryRowColValue.RemoveAll();

		CString strTemp;
		for (int i = 0; i < copy.m_aryRowColValue.GetCount(); i++)
		{
			strTemp = copy.m_aryRowColValue.GetAt(i);
			m_aryRowColValue.Add(strTemp);
		}

		return *this;
	}

	int GetColumnCount() const
	{
		ENTER_THREAD_SAFETY

		return (int)m_aryRowColValue.GetCount();
	}

	CString operator[] (int nColumnIdx) const
	{
		ENTER_THREAD_SAFETY

		if ( m_aryRowColValue.GetCount() <= nColumnIdx )
		{
			ASSERT(FALSE);
			return _T("");
		}
		else
		{
			return m_aryRowColValue.GetAt(nColumnIdx);
		}
	}
};



struct SAxTableRecordSet 
{
	DECLARE_THREAD_SAFETY

public:
	CStringArray m_aryFieldsName;
	CArray<SAxRowRecord, SAxRowRecord> m_aryRowRecords;

	SAxTableRecordSet(){}

	SAxTableRecordSet(const SAxTableRecordSet& copy)
	{
		*this = copy;
	}

	SAxTableRecordSet& operator= (const SAxTableRecordSet& copy)
	{
		ENTER_THREAD_SAFETY

		CString strTemp;
		m_aryFieldsName.RemoveAll();
		for (int i = 0; i < copy.m_aryFieldsName.GetCount(); i++)
		{
			strTemp = copy.m_aryFieldsName.GetAt(i);

			m_aryFieldsName.Add(strTemp);
		}

		m_aryRowRecords.RemoveAll();
		for (int i = 0; i < copy.m_aryRowRecords.GetCount(); i++)
		{
			SAxRowRecord tempRow = copy.m_aryRowRecords.GetAt(i);
			m_aryRowRecords.Add(tempRow);
		}
		
		return *this;
	}

	int GetRowRecordsCount() const
	{
		ENTER_THREAD_SAFETY

		return (int)m_aryRowRecords.GetCount();
	}

	int GetFieldsCount() const
	{
		ENTER_THREAD_SAFETY

		return (int)m_aryFieldsName.GetCount();
	}

	CString GetFieldName(int iFieldIdx)
	{
		ENTER_THREAD_SAFETY

		if( iFieldIdx < 0 || iFieldIdx >= m_aryFieldsName.GetCount())
			return _T("");

		return m_aryFieldsName.GetAt(iFieldIdx);
	}

	int GetFieldIdx(ConstStr strFieldName) const // 没有目标列,返回-1
	{
		ENTER_THREAD_SAFETY

		for (int nCyc=0; nCyc < m_aryFieldsName.GetCount(); nCyc++)
		{
			if ( strFieldName == m_aryFieldsName.GetAt(nCyc) )
			{
				return nCyc;
			}
		}

		return -1;
	}

	CString GetValue(int nColumn, int nRow, OUT BOOL* pbSuccess=NULL) const
	{
		ENTER_THREAD_SAFETY

		if ( pbSuccess )
		{
			*pbSuccess = FALSE;
		}

		if ( nColumn < 0 || nRow < 0 )
		{
			ASSERT(FALSE);
			return _T("");
		}

		if ( m_aryRowRecords.GetCount() <= nRow )
		{
			ASSERT(FALSE);
			return _T("");
		}

		const SAxRowRecord& stCurRow = m_aryRowRecords.GetAt(nRow);
		if ( stCurRow.GetColumnCount() <= nColumn )
		{
			ASSERT(FALSE);
			return _T("");
		}
		
		if ( pbSuccess )
		{
			*pbSuccess = TRUE;
		}

		return stCurRow[nColumn];
	}

	CString GetValue(ConstStr strFieldName, int nRow, OUT BOOL* pbSuccess=NULL) const
	{
		ENTER_THREAD_SAFETY

		if ( pbSuccess )
		{
			*pbSuccess = FALSE;
		}

		int nFieldIdx = GetFieldIdx(strFieldName);
		if ( nFieldIdx < 0 )
		{
			ASSERT(FALSE);
			return _T("");
		}

		return GetValue(nFieldIdx, nRow, pbSuccess);
	}

	void RemoveAll()
	{
		ENTER_THREAD_SAFETY

		m_aryFieldsName.RemoveAll();
		m_aryRowRecords.RemoveAll();
	}
};
