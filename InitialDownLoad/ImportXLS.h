////////////////////////////////////////////////////////////////////////////////////
//// Import AoShi CRS XLS data
//// Data Format: �˶�Ա��š��������Ա𡢳������ڡ����塢��ߡ����ء�ע��֤�š�
//// ������λ��������λ���롢˫�Ƿֵ�λ��˫�Ƿֵ�λ���롢�Ƿ�μ����塢������Ŀ��
//// ������Ŀ���롢�����ɼ����Ƿ�Ԥ����Ա����Ϻ���
///////////////////////////////////////////////////////////////////////////////////
#pragma once

#import "C:\\Program Files\\Common Files\\Microsoft Shared\\OFFICE14\\MSO.DLL" rename( "RGB", "MSORGB" )

using namespace Office;

#import "C:\\Program Files\\Common Files\\Microsoft Shared\\VBA\\VBA6\\VBE6EXT.OLB"

using namespace VBIDE;

#import "C:\\Program Files\\Microsoft Office\\OFFICE14\\EXCEL.EXE" \
		rename( "DialogBox", "ExcelDialogBox" ) \
		rename( "RGB", "ExcelRGB" ) \
		rename( "CopyFile", "ExcelCopyFile" ) \
		rename( "ReplaceText", "ExcelReplaceText" ) \
		rename( "ID", "ExcelID" )


struct SXLSRecord
{
	CStringArray aryFieldValues;

public:
	SXLSRecord()
	{
		aryFieldValues.RemoveAll();
	}

	SXLSRecord(SXLSRecord& copy)
	{
		*this = copy;
	}

	SXLSRecord& operator= (SXLSRecord& copy)
	{
		this->aryFieldValues.RemoveAll();

		CString strTemp;
		for (int i = 0; i < copy.aryFieldValues.GetCount(); i++)
		{
			strTemp = copy.aryFieldValues.GetAt(i);

			this->aryFieldValues.Add(strTemp);
		}

		return *this;
	}

	LPCTSTR operator[] (int nIndex)
	{
		if( nIndex < 0 || nIndex >= aryFieldValues.GetCount())
			return _T("");

		return aryFieldValues[nIndex];
	}

	LPCTSTR GetFieldValue(int nIndex)
	{
		if( nIndex < 0 || nIndex >= aryFieldValues.GetCount())
			return _T("");

		return aryFieldValues[nIndex];
	}
};

struct SXLSRecordSheet
{
	CStringArray aryFieldNames;
	CList<SXLSRecord, SXLSRecord> lstRecords;

public:
	SXLSRecordSheet()
	{
		aryFieldNames.RemoveAll();
		lstRecords.RemoveAll();
	}

	SXLSRecordSheet(SXLSRecordSheet& copy)
	{
		*this = copy;
	}

	SXLSRecordSheet& operator= (SXLSRecordSheet& copy)
	{
		this->aryFieldNames.RemoveAll();
		this->lstRecords.RemoveAll();

		CString strTemp;
		for (int i = 0; i < copy.aryFieldNames.GetCount(); i++)
		{
			strTemp = copy.aryFieldNames.GetAt(i);

			this->aryFieldNames.Add(strTemp);
		}

		POSITION pos = copy.lstRecords.GetHeadPosition();
		while( pos != NULL)
		{
			SXLSRecord pSet = copy.lstRecords.GetNext(pos);
			this->lstRecords.AddTail(pSet);
		}

		return *this;
	}

	LPCTSTR operator[] (int nFieldIdx)
	{
		if( nFieldIdx < 0 || nFieldIdx >= aryFieldNames.GetCount())
			return _T("");

		return aryFieldNames[nFieldIdx];
	}

	int GetRecordCount()
	{
		return (int)lstRecords.GetCount();
	}

	SXLSRecord& GetRecord(int nRowIdx)
	{
		ASSERT( nRowIdx >= 0 && nRowIdx < lstRecords.GetCount());

		POSITION pos = lstRecords.FindIndex(nRowIdx);

		return lstRecords.GetAt(pos);
	}

	int GetFieldCount()
	{
		return (int)aryFieldNames.GetSize();
	}

	LPCTSTR GetFieldName(int nFieldIdx) 
	{
		if( nFieldIdx < 0 || nFieldIdx >= aryFieldNames.GetSize())
			return _T("");

		return aryFieldNames[nFieldIdx];
	}

	int GetFieldIdx(LPCTSTR lpFieldName) 
	{
		CString strFieldName = CString(lpFieldName);
		for(int i = 0; i< aryFieldNames.GetSize(); i++)
		{	
			CString strTemp = aryFieldNames.GetAt(i);
			if( strTemp.CompareNoCase(strFieldName) == 0 )
			{
				return i;
			}
		}

		return -1;
	}

	LPCTSTR GetFieldValue(int nRowIdx, LPCTSTR pszFieldName)
	{
		if( nRowIdx < 0 || nRowIdx >= lstRecords.GetCount())
			return _T("");

		CString strFieldName = (CString)pszFieldName;
		for(int i = 0; i< aryFieldNames.GetSize(); i++)
		{	
			CString strTemp = aryFieldNames.GetAt(i);
			if( strTemp.CompareNoCase(strFieldName) == 0 )
			{
				SXLSRecord sTRecord = GetRecord(nRowIdx);
				return sTRecord.GetFieldValue(i);
			}
		}

		return _T("");
	}

	LPCTSTR GetFieldValue(int nRowIdx, int nFieldIdx)
	{
		if( nRowIdx < 0 || nRowIdx >= lstRecords.GetCount())
			return _T("");

		SXLSRecord sTRecord = GetRecord(nRowIdx);
		return sTRecord.GetFieldValue(nFieldIdx);
	}
};

class CAxXLSRecordSet 
{
public:
	CAxXLSRecordSet(LPCTSTR pszXLSFileName);
	virtual ~CAxXLSRecordSet();

	BOOL LoadRecords(SXLSRecordSheet& sheetXLS);

protected:
	CString m_strXLSFileName;
};