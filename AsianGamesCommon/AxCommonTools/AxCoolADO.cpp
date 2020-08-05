#include "stdafx.h"
#include <odbcinst.h>
#include <afxdb.h>
#include "AxCoolADO.h"
#include "AxCommonUtils.h"



#define ChunkSize 100

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////CAxADOUtils////////////////////////////////////////////

CString CAxADOUtils::IntToStr(int nVal)
{
	CString strRet;
	char buff[10];
	
	_itoa_s(nVal, buff, 10);
	strRet = buff;

	return strRet;
}

CString CAxADOUtils::LongToStr(long lVal)
{
	CString strRet;
	char buff[20];
	
	_ltoa_s(lVal, buff, 10);
	strRet = buff;

	return strRet;
}

CString CAxADOUtils::ULongToStr(unsigned long ulVal)
{
	CString strRet;
	char buff[20];
	
	_ultoa_s(ulVal, buff, 10);
	strRet = buff;

	return strRet;
}

CString CAxADOUtils::DblToStr(double dblVal, int ndigits)
{
	CString strRet;
	char buff[50];

   _gcvt(dblVal, ndigits, buff);
	strRet = buff;

	return strRet;
}

CString CAxADOUtils::DblToStr(float fltVal)
{
	CString strRet;
	char buff[50];
	
   _gcvt(fltVal, 10, buff);
	strRet = buff;

	return strRet;
}

CString CAxADOUtils::ADODataTypeToSQLServerDataTypeStr(DataTypeEnum eType)
{
	CString strDataType;

	switch (eType)
	{
	case adEmpty:
		strDataType = _T("Empty");
		break;
	case adTinyInt:
		strDataType = _T("tinyint");
		break;
	case adSmallInt:
		strDataType = _T("smallint");
		break;
	case adInteger:
		strDataType = _T("int");
		break;
	case adBigInt:
		strDataType = _T("bigint");
		break;
	case adUnsignedTinyInt:
		strDataType = _T("tinyint");
		break;
	case adUnsignedSmallInt:
		strDataType = _T("smallint");
		break;
	case adUnsignedInt:
		strDataType = _T("int");
		break;
	case adUnsignedBigInt:
		strDataType = _T("bigint");
		break;
	case adSingle:
		strDataType = _T("real");
		break;
	case adDouble:
		strDataType = _T("float");
		break;
	case adCurrency:
		strDataType = _T("money");
		break;
	case adDecimal:
		strDataType = _T("decimal");
		break;
	case adNumeric:
		strDataType = _T("numeric");
		break;
	case adBoolean:
		strDataType = _T("bit");
		break;
	case adError:
		strDataType = _T("Error");
		break;
	case adUserDefined:
		strDataType = _T("UserDefined");
		break;
	case adVariant:
		strDataType = _T("Variant");
		break;
	case adIDispatch:
		strDataType = _T("IDispatch");
		break;
	case adIUnknown:
		strDataType = _T("IUnknown");
		break;
	case adGUID:
		strDataType = _T("uniqueidentifier");
		break;
	case adDate:
		strDataType = _T("Date");
		break;
	case adDBDate:
		strDataType = _T("DBDate");
		break;
	case adDBTime:
		strDataType = _T("DBTime");
		break;
	case adDBTimeStamp:
		strDataType = _T("datetime");
		break;
	case adBSTR:
		strDataType = _T("BSTR");
		break;
	case adChar:
		strDataType = _T("char");
		break;
	case adVarChar:
		strDataType = _T("varchar");
		break;
	case adLongVarChar:
		strDataType = _T("LongVarChar");
		break;
	case adWChar:
		strDataType = _T("nchar");
		break;
	case adVarWChar:
		strDataType = _T("nvarchar");
		break;
	case adLongVarWChar:
		strDataType = _T("LongVarWChar");
		break;
	case adBinary:
		strDataType = _T("binary");
		break;
	case adVarBinary:
		strDataType = _T("varbinary");
		break;
	case adLongVarBinary:
		strDataType = _T("LongVarBinary");
		break;
	case adChapter:
		strDataType = _T("Chapter");
		break;
	case adFileTime:
		strDataType = _T("FileTime");
		break;
	case adPropVariant:
		strDataType = _T("PropVariant");
		break;
	case adVarNumeric:
		strDataType = _T("VarNumeric");
		break;
	case adArray:
		strDataType = _T("Array");
		break;
	default:
		strDataType = _T("");
		break;
	}

	return strDataType;
}

CString CAxADOUtils::MakeOLEDB_SQLServer(LPCTSTR lpszServer, LPCTSTR lpszDatabase,
										 LPCTSTR lpszUID, LPCTSTR lpszPWD)
{
	CString str;

	str.Format(_T("Provider=SQLOLEDB.1;Password=%s;Persist Security Info=True;User ID=%s;Initial Catalog=%s;Data Source=%s;Connect Timeout=2"),
		CString(lpszPWD), CString(lpszUID), CString(lpszDatabase), CString(lpszServer));

	return str;
}

BOOL CAxADOUtils::ParseOLEDB_SQLServer_ConStr(CString strConnection, 
										OUT CString &strServer, OUT CString &strDatabase, OUT CString &strUserID, OUT CString &strPassword)
{
	strServer.Empty();
	strDatabase.Empty();
	strUserID.Empty();
	strPassword.Empty();

	if (strConnection.IsEmpty())
		return FALSE;

	CString strServerMark(_T("Data Source="));
	CString strDatabaseMark(_T("Initial Catalog="));
	CString strUserIDMark(_T("User ID="));
	CString strPasswordMark(_T("Password="));

	if (strConnection.Find(strServerMark) < 0 || strConnection.Find(strDatabaseMark) < 0 ||
		strConnection.Find(strUserIDMark) < 0 || strConnection.Find(strPasswordMark) < 0 )
		return FALSE;

	// Get Server
	int nServerPos = strConnection.Find(strServerMark) + strServerMark.GetLength();
	int nEndPos = strConnection.Find(_T(";"), nServerPos);
	if (nEndPos < 0) nEndPos = strConnection.GetLength();
	strServer = strConnection.Mid(nServerPos, nEndPos - nServerPos);
	strServer.Trim();

	// Get Database
	int nDatabasePos = strConnection.Find(strDatabaseMark) + strDatabaseMark.GetLength();
	nEndPos = strConnection.Find(_T(";"), nDatabasePos);
	if (nEndPos < 0) nEndPos = strConnection.GetLength()-1;
	strDatabase = strConnection.Mid(nDatabasePos, nEndPos - nDatabasePos);
	strDatabase.Trim();

	// Get UserID
	int nUserIDPos = strConnection.Find(strUserIDMark) + strUserIDMark.GetLength();
	nEndPos = strConnection.Find(_T(";"), nUserIDPos);
	if (nEndPos < 0) nEndPos = strConnection.GetLength()-1;
	strUserID = strConnection.Mid(nUserIDPos, nEndPos - nUserIDPos);
	strUserID.Trim();

	// Get Password
	int nPasswordPos = strConnection.Find(strPasswordMark) + strPasswordMark.GetLength();
	nEndPos = strConnection.Find(_T(";"), nPasswordPos);
	if (nEndPos < 0) nEndPos = strConnection.GetLength()-1;
	strPassword = strConnection.Mid(nPasswordPos, nEndPos - nPasswordPos);
	strPassword.Trim();

	return TRUE;
}

BOOL CAxADOUtils::CreateDatabase_Jet(LPCTSTR lpszFileName)
{
	BOOL bRet = FALSE;
	try
	{
		_CatalogPtr pCat;
		pCat.CreateInstance(__uuidof(Catalog));

		CString str;
		str.Format(_T("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s"), lpszFileName);
		pCat->Create(_bstr_t(str));

		bRet = TRUE;
	}
	catch(_com_error &e)
	{
		AfxMessageBox(Get_ComError(e));
		return FALSE;
	}

	return bRet;
}

BOOL CAxADOUtils::CreateDatabase_SQLServer(LPCTSTR lpszServer, LPCTSTR lpszUID, 
										  LPCTSTR lpszPWD, LPCTSTR lpszDatabaseName,
										  LPCTSTR lpszFileName, long lSize, 
										  long lMaxSize, long lFileGrowth)
{
	BOOL bRet = FALSE;
	try
	{
		_ConnectionPtr pConn;
		pConn.CreateInstance(__uuidof(Connection));

		CString strConn;
		strConn.Format(_T("Provider=SQLOLEDB.1;Persist Security Info=False;User ID=%s;Password=%s;Data Source=%s"),
			CString(lpszUID), CString(lpszPWD), CString(lpszServer));

		pConn->Open(_bstr_t(strConn), lpszUID, lpszPWD, -1);
		CString strSQL;
		if(lpszFileName != NULL)
		{
			strSQL.Format(_T("CREATE DATABASE %s ON("), lpszDatabaseName);
			CString str;
			str.Format(_T("NAME=%s_dat,FILENAME='%s',"),
				lpszDatabaseName, lpszFileName);

			strSQL += str;
			{
				CString str;
				str.Format(_T("SIZE=%d,"), lSize);
				strSQL += str;
			}
			if(lMaxSize > 0)
			{
				CString str;
				str.Format(_T("MAXSIZE=%d,"), lMaxSize);
				strSQL += str;
			}
			{
				CString str;
				str.Format(_T("FILEGROWTH=%d)"), lFileGrowth);
				strSQL += str;
			}
		}
		else
		{
			strSQL.Format(_T("CREATE DATABASE %s"), lpszDatabaseName);
		}

		pConn->Execute(_bstr_t(strSQL), NULL, adExecuteNoRecords | adCmdText);

		pConn->Close();

		bRet = TRUE;
	}
	catch(_com_error &e)
	{
		AfxMessageBox(Get_ComError(e));
		return FALSE;
	}

	return bRet;
}

BOOL CAxADOUtils::DeleteDatabase_SQLServer(LPCTSTR lpszServer, LPCTSTR lpszUID, 
										  LPCTSTR lpszPWD, LPCTSTR lpszDatabaseName)
{
	BOOL bRet = FALSE;
	try
	{
		_ConnectionPtr pConn;
		pConn.CreateInstance(__uuidof(Connection));

		CString strConn;
		strConn.Format(_T("Provider=SQLOLEDB.1;Persist Security Info=False;User ID=%s;Password=%s;Data Source=%s"),
			lpszUID, lpszPWD, lpszServer);

		pConn->Open(_bstr_t(strConn), lpszUID, lpszPWD, -1);

		CString strSQL;
		strSQL.Format(_T("DROP DATABASE %s"), lpszDatabaseName);
		pConn->Execute(_bstr_t(strSQL), NULL, adExecuteNoRecords | adCmdText);

		pConn->Close();

		bRet = TRUE;
	}
	catch(_com_error &e)
	{
		AfxMessageBox(Get_ComError(e));
		return FALSE;
	}

	return bRet;
}

CString CAxADOUtils::MakeOLEDB_Jet(LPCTSTR lpszDataSource,
								  LPCTSTR lpszUID, LPCTSTR lpszPWD)
{
	CString str;

	str.Format(_T("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;User Id=%s;Password=%s;"),
		CString(lpszDataSource), CString(lpszUID), CString(lpszPWD));

	return str;
}

CString CAxADOUtils::Get_ComError(_com_error &e)
{
	CString strError;
	strError.Format(_T("[0x%x]%s"), e.Error(), (TCHAR *)e.Description());
	return strError;
}

///////////////////////////////////////////////CAxADODataBase/////////////////////
/////////////////////////////////////////////////////////////////////////////////
CAxADODataBase::CAxADODataBase()
{
	::CoInitialize(NULL);
		
	m_pConnection = NULL;
	m_strConnection = _T("");
	m_strLastError = _T("");
	m_dwLastError = 0;
	m_pConnection.CreateInstance(__uuidof(Connection));
	m_nRecordsAffected = 0;
	m_nConnectionTimeout = 0;
}

CAxADODataBase::~CAxADODataBase()
{
	Close();

	m_pConnection.Release();
	m_pConnection = NULL;
	m_strConnection = _T("");
	m_strLastError = _T("");
	m_dwLastError = 0;

	::CoUninitialize();
}

DWORD CAxADODataBase::GetRecordCount(_RecordsetPtr pRs)
{
	DWORD numRows = 0;
	
	numRows = pRs->GetRecordCount();

	if(numRows == -1)
	{
		if(pRs->adoEOF != VARIANT_TRUE)
			pRs->MoveFirst();

		while(pRs->adoEOF != VARIANT_TRUE)
		{
			numRows++;
			pRs->MoveNext();
		}

		if(numRows > 0)
			pRs->MoveFirst();
	}

	return numRows;
}

BOOL CAxADODataBase::Open(LPCTSTR lpstrConnection, LPCTSTR lpstrUserID, LPCTSTR lpstrPassword)
{
	HRESULT hr = S_OK;

	if(IsOpen())
		Close();

	if(_tcscmp(lpstrConnection, _T("")) != 0)
		m_strConnection = lpstrConnection;

	if(m_strConnection.IsEmpty())
		return FALSE;

	try
	{
		if(m_nConnectionTimeout != 0)
			m_pConnection->PutConnectionTimeout(m_nConnectionTimeout);

		hr = m_pConnection->Open(_bstr_t(m_strConnection), _bstr_t(lpstrUserID), _bstr_t(lpstrPassword), NULL);
		
		return hr == S_OK;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}

	return TRUE;
}

BOOL CAxADODataBase::Execute(LPCTSTR lpstrExec)
{
	ASSERT(m_pConnection != NULL);
	ASSERT(_tcscmp(lpstrExec, _T("")) != 0);
	_variant_t vRecords;
	
	m_nRecordsAffected = 0;

	try
	{
		m_pConnection->CursorLocation = adUseClient;
		m_pConnection->Execute(_bstr_t(lpstrExec), &vRecords, adExecuteNoRecords);
		m_nRecordsAffected = vRecords.iVal;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;	
	}
}

void CAxADODataBase::dump_com_error(_com_error &e)
{
	CString strError;
	
	_bstr_t bstrSource(e.Source());
	_bstr_t bstrDescription(e.Description());

	LPWSTR lpUSource = AxCommonAnsiToUnicode((LPSTR)bstrSource);
	LPWSTR lpUDescription = AxCommonAnsiToUnicode((LPSTR)bstrDescription);

	CString strSource, strDescription;
	strSource = (CString)lpUSource;
	strDescription = (CString)lpUDescription;


	delete []lpUSource;
	delete []lpUDescription;


	strError.Format( _T("CAxADODataBase Error\r\n\tCode = %08lx\n\tCode meaning = %s\r\n\tSource = %s\r\n\tDescription = %s\r\n"),
		            e.Error(), e.ErrorMessage(), strSource, strDescription);

	m_strErrorDescription = (LPCSTR)bstrDescription ;
	m_strLastError = _T("Connection String = \" " + GetConnectionString() + " \"\r\n" + strError);
	m_dwLastError = e.Error(); 

	//AfxMessageBox(strError, MB_OK | MB_ICONERROR );
	throw CAxADOException(e.Error(), m_strLastError);
}

BOOL CAxADODataBase::IsOpen()
{
	if(m_pConnection )
		return m_pConnection->GetState() != adStateClosed;

	return FALSE;
}

void CAxADODataBase::Close()
{
	if(IsOpen())
		m_pConnection->Close();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CAxADORecordSet Class
CAxADORecordSet::CAxADORecordSet()
{
	m_pRecordset = NULL;
	m_pCommand = NULL;
	m_strQuery = _T("");
	m_strLastError = _T("");
	m_dwLastError = 0;
	m_pRecordBinding = NULL;
	m_pRecordset.CreateInstance(__uuidof(Recordset));
	m_pCommand.CreateInstance(__uuidof(Command));
	m_nEditStatus = CAxADORecordSet::emDBEditNone;
	m_nSearchDirection = CAxADORecordSet::emSearchForward;
}

CAxADORecordSet::CAxADORecordSet(CAxADODataBase* pAdoDatabase)
{
	m_pRecordset = NULL;
	m_pCommand = NULL;
	m_strQuery = _T("");
	m_strLastError = _T("");
	m_dwLastError = 0;
	m_pRecordBinding = NULL;
	m_pRecordset.CreateInstance(__uuidof(Recordset));
	m_pCommand.CreateInstance(__uuidof(Command));
	m_nEditStatus = CAxADORecordSet::emDBEditNone;
	m_nSearchDirection = CAxADORecordSet::emSearchForward;

	m_pConnection = pAdoDatabase->GetActiveConnection();
}

CAxADORecordSet::~CAxADORecordSet()
{
	Close();

	if(m_pRecordset)
		m_pRecordset.Release();

	if(m_pCommand)
		m_pCommand.Release();

	m_pRecordset = NULL;
	m_pCommand = NULL;
	m_pRecordBinding = NULL;
	m_strQuery = _T("");
	m_strLastError = _T("");
	m_dwLastError = 0;
	m_nEditStatus = emDBEditNone;
}

BOOL CAxADORecordSet::Open(_ConnectionPtr mpdb, LPCTSTR lpstrExecSql, int nOption)
{	
	Close();
	
	if(_tcscmp(lpstrExecSql, _T("")) != 0)
		m_strQuery = lpstrExecSql;

	if(m_strQuery.IsEmpty())
		return FALSE;

	if(m_pConnection == NULL)
		m_pConnection = mpdb;

	BOOL bIsSelect = m_strQuery.Mid(0, _tcslen(_T("Select "))).CompareNoCase(_T("select ")) == 0 && nOption == emOpenUnknown;

	_variant_t vtQuery;
	vtQuery.vt = VT_BSTR;	
	vtQuery.bstrVal = m_strQuery.AllocSysString();

	try
	{
		m_pRecordset->CursorType = adOpenStatic;
		m_pRecordset->CursorLocation = adUseClient;
		if(bIsSelect || nOption == emOpenQuery || nOption == emOpenUnknown)
		{

			m_pRecordset->Open(vtQuery, _variant_t((IDispatch*)mpdb, TRUE), 
							    adOpenStatic, adLockOptimistic, adCmdUnknown);			
		}
		else if(nOption == emOpenTable)
		{
			m_pRecordset->Open(vtQuery, _variant_t((IDispatch*)mpdb, TRUE), 
							   adOpenKeyset, adLockOptimistic, adCmdTable);
		}
		else if(nOption == emOpenStoredProc)
		{
			m_pCommand->ActiveConnection = mpdb;
			m_pCommand->CommandText = _bstr_t(m_strQuery);
			m_pCommand->CommandType = adCmdStoredProc;
			m_pConnection->CursorLocation = adUseClient;
			
			m_pRecordset = m_pCommand->Execute(NULL, NULL, adCmdText);
		}
		else
		{
			TRACE( "Unknown parameter. %d", nOption);
			SysFreeString(vtQuery.bstrVal);
			return FALSE;
		}
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		SysFreeString(vtQuery.bstrVal);
		return FALSE;
	}

	SysFreeString(vtQuery.bstrVal);

	return m_pRecordset != NULL && m_pRecordset->GetState()!= adStateClosed;
}

BOOL CAxADORecordSet::Open(LPCTSTR lpstrExecSql, int nOption)
{
	ASSERT(m_pConnection != NULL);
	ASSERT(m_pConnection->GetState() != adStateClosed);

	return Open(m_pConnection, lpstrExecSql, nOption);
}

BOOL CAxADORecordSet::OpenSchema(int nSchema, LPCTSTR SchemaID /*= _T("")*/)
{
	try
	{
		_variant_t vtSchemaID = vtMissing;

		if(_tcslen(SchemaID) != 0)
		{
			vtSchemaID = SchemaID;
			nSchema = adSchemaProviderSpecific;
		}
			
		m_pRecordset = m_pConnection->OpenSchema((enum SchemaEnum)nSchema, vtMissing, vtSchemaID);
		
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::Requery()
{
	if(IsOpen())
	{
		try
		{
			m_pRecordset->Requery(adExecuteRecord);
		}
		catch(_com_error &e)
		{
			dump_com_error(e);
			return FALSE;
		}
	}
	return TRUE;
}


BOOL CAxADORecordSet::GetFieldValue(LPCTSTR lpFieldName, double& dbValue)
{	
	double val = (double)NULL;
	_variant_t vtFld;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(lpFieldName)->Value;
		switch(vtFld.vt)
		{
		case VT_R4:
			val = vtFld.fltVal;
			break;
		case VT_R8:
			val = vtFld.dblVal;
			break;
		case VT_DECIMAL:
			val = vtFld.decVal.Lo32;
			val *= (vtFld.decVal.sign == 128)? -1 : 1;
			val /= pow((double)10, (int)(vtFld.decVal.scale)); 
			break;
		case VT_UI1:
			val = vtFld.iVal;
			break;
		case VT_I2:
		case VT_I4:
			val = vtFld.lVal;
			break;
		case VT_INT:
			val = vtFld.intVal;
			break;
		case VT_CY:  
			vtFld.ChangeType(VT_R8);
			val = vtFld.dblVal;
			break;
		case VT_NULL:
		case VT_EMPTY:
			val = 0;
			break;
		default:
			val = vtFld.dblVal;
		}
		dbValue = val;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(int nIndex, double& dbValue)
{	
	double val = (double)NULL;
	_variant_t vtFld;
	_variant_t vtIndex;

	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(vtIndex)->Value;
		switch(vtFld.vt)
		{
		case VT_R4:
			val = vtFld.fltVal;
			break;
		case VT_R8:
			val = vtFld.dblVal;
			break;
		case VT_DECIMAL:
			val = vtFld.decVal.Lo32;
			val *= (vtFld.decVal.sign == 128)? -1 : 1;
			val /= pow((double)10, (int)(vtFld.decVal.scale)); 
			break;
		case VT_UI1:
			val = vtFld.iVal;
			break;
		case VT_I2:
		case VT_I4:
			val = vtFld.lVal;
			break;
		case VT_INT:
			val = vtFld.intVal;
			break;
		case VT_CY:   
			vtFld.ChangeType(VT_R8);
			val = vtFld.dblVal;
			break;
		case VT_NULL:
		case VT_EMPTY:
			val = 0;
			break;
		default:
			val = 0;
		}
		dbValue = val;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(LPCTSTR lpFieldName, long& lValue)
{
	long val = (long)NULL;
	_variant_t vtFld;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(lpFieldName)->Value;
		if(vtFld.vt != VT_NULL && vtFld.vt != VT_EMPTY)
			val = vtFld.lVal;
		lValue = val;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(int nIndex, long& lValue)
{
	long val = (long)NULL;
	_variant_t vtFld;
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;

	try
	{
		vtFld = m_pRecordset->Fields->GetItem(vtIndex)->Value;
		if(vtFld.vt != VT_NULL && vtFld.vt != VT_EMPTY)
			val = vtFld.lVal;
		lValue = val;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(LPCTSTR lpFieldName, unsigned long& ulValue)
{
	long val = (long)NULL;
	_variant_t vtFld;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(lpFieldName)->Value;
		if(vtFld.vt != VT_NULL && vtFld.vt != VT_EMPTY)
			val = vtFld.ulVal;
		ulValue = val;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(int nIndex, unsigned long& ulValue)
{
	long val = (long)NULL;
	_variant_t vtFld;
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;

	try
	{
		vtFld = m_pRecordset->Fields->GetItem(vtIndex)->Value;
		if(vtFld.vt != VT_NULL && vtFld.vt != VT_EMPTY)
			val = vtFld.ulVal;
		ulValue = val;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(LPCTSTR lpFieldName, int& nValue)
{
	int val = NULL;
	_variant_t vtFld;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(lpFieldName)->Value;
		switch(vtFld.vt)
		{
		case VT_BOOL:
			val = vtFld.boolVal;
			break;
		case VT_I2:
		case VT_UI1:
			val = vtFld.iVal;
			break;
		case VT_INT:
			val = vtFld.intVal;
			break;
		case VT_NULL:
		case VT_EMPTY:
			val = 0;
			break;
		default:
			val = vtFld.iVal;
		}	
		nValue = val;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(int nIndex, int& nValue)
{
	int val = (int)NULL;
	_variant_t vtFld;
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;

	try
	{
		vtFld = m_pRecordset->Fields->GetItem(vtIndex)->Value;
		switch(vtFld.vt)
		{
		case VT_BOOL:
			val = vtFld.boolVal;
			break;
		case VT_I2:
		case VT_UI1:
			val = vtFld.iVal;
			break;
		case VT_INT:
			val = vtFld.intVal;
			break;
		case VT_NULL:
		case VT_EMPTY:
			val = 0;
			break;
		default:
			val = vtFld.iVal;
		}	
		nValue = val;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(LPCTSTR lpFieldName, CString& strValue, CString strDateFormat)
{
	CString str;
	_variant_t vtFld;

	try
	{
		vtFld = m_pRecordset->Fields->GetItem(lpFieldName)->Value;
		switch(vtFld.vt) 
		{
		case VT_R4:
			str = CAxADOUtils::DblToStr(vtFld.fltVal);
			break;
		case VT_R8:
			str = CAxADOUtils::DblToStr(vtFld.dblVal);
			break;
		case VT_BSTR:
			str = vtFld.bstrVal;
			break;
		case VT_I2:
		case VT_UI1:
			str = CAxADOUtils::IntToStr(vtFld.iVal);
			break;
		case VT_INT:
			str = CAxADOUtils::IntToStr(vtFld.intVal);
			break;
		case VT_I4:
			str = CAxADOUtils::LongToStr(vtFld.lVal);
			break;
		case VT_UI4:
			str = CAxADOUtils::ULongToStr(vtFld.ulVal);
			break;
		case VT_DECIMAL:
			{
			double val = vtFld.decVal.Lo32;
			val *= (vtFld.decVal.sign == 128)? -1 : 1;
			val /= pow((double)10, (int)(vtFld.decVal.scale)); 
			str = CAxADOUtils::DblToStr(val);
			}
			break;
		case VT_DATE:
			{
				COleDateTime dt(vtFld);

				if(strDateFormat.IsEmpty())
					strDateFormat = _T("%Y-%m-%d %H:%M:%S");
				str = dt.Format(strDateFormat);
			}
			break;
		case VT_CY:	
			{
				vtFld.ChangeType(VT_R8);
 
				CString str;
				str.Format(_T("%f"), vtFld.dblVal);
 
				_TCHAR pszFormattedNumber[64];
 
				//	LOCALE_USER_DEFAULT
				if(GetCurrencyFormat( LOCALE_USER_DEFAULT,	// locale for which string is to be formatted 
					                  0,						// bit flag that controls the function's operation
									  str,					// pointer to input number string
                                      NULL,					// pointer to a formatting information structure												//	NULL = machine default locale settings
									  pszFormattedNumber,		// pointer to output buffer
									  63))					// size of output buffer
				{
					str = pszFormattedNumber;
				}
			}
			break;
		case VT_EMPTY:
		case VT_NULL:
			str.Empty();
			break;
		case VT_BOOL:
			str = vtFld.boolVal == VARIANT_TRUE? 'T':'F';
			break;
		default:
			str.Empty();
			return FALSE;
		}
		strValue = str;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(int nIndex, CString& strValue, CString strDateFormat)
{
	CString str;
	_variant_t vtFld;
	_variant_t vtIndex;

	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(vtIndex)->Value;
		switch(vtFld.vt) 
		{
		case VT_R4:
			str = CAxADOUtils::DblToStr(vtFld.fltVal);
			break;
		case VT_R8:
			str = CAxADOUtils::DblToStr(vtFld.dblVal);
			break;
		case VT_BSTR:
			str = vtFld.bstrVal;
			break;
		case VT_I2:
		case VT_UI1:
			str = CAxADOUtils::IntToStr(vtFld.iVal);
			break;
		case VT_INT:
			str = CAxADOUtils::IntToStr(vtFld.intVal);
			break;
		case VT_I4:
			str = CAxADOUtils::LongToStr(vtFld.lVal);
			break;
		case VT_UI4:
			str = CAxADOUtils::ULongToStr(vtFld.ulVal);
			break;
		case VT_DECIMAL:
			{
			double val = vtFld.decVal.Lo32;
			val *= (vtFld.decVal.sign == 128)? -1 : 1;
			val /= pow((double)10, (int)(vtFld.decVal.scale)); 
			str = CAxADOUtils::DblToStr(val);
			}
			break;
		case VT_DATE:
			{
				COleDateTime dt(vtFld);
				
				if(strDateFormat.IsEmpty())
					strDateFormat = _T("%Y-%m-%d %H:%M:%S");
				str = dt.Format(strDateFormat);
			}
			break;
		case VT_CY:	
			{
				vtFld.ChangeType(VT_R8);
 
				CString str;
				str.Format(_T("%f"), vtFld.dblVal);
 
				_TCHAR pszFormattedNumber[64];
 
				//	LOCALE_USER_DEFAULT
				if(GetCurrencyFormat(
									LOCALE_USER_DEFAULT,	// locale for which string is to be formatted 
									0,						// bit flag that controls the function's operation
									str,					// pointer to input number string
									NULL,					// pointer to a formatting information structure
															//	NULL = machine default locale settings
									pszFormattedNumber,		// pointer to output buffer
									63))					// size of output buffer
				{
					str = pszFormattedNumber;
				}
			}
			break;
		case VT_BOOL:
			str = vtFld.boolVal == VARIANT_TRUE? 'T':'F';
			break;
		case VT_EMPTY:
		case VT_NULL:
			str.Empty();
			break;
		default:
			str.Empty();
			return FALSE;
		}
		strValue = str;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(LPCTSTR lpFieldName, COleDateTime& time)
{
	_variant_t vtFld;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(lpFieldName)->Value;
		switch(vtFld.vt) 
		{
		case VT_DATE:
			{
				COleDateTime dt(vtFld);
				time = dt;
			}
			break;
		case VT_EMPTY:
		case VT_NULL:
			time.SetStatus(COleDateTime::null);
			break;
		default:
			return FALSE;
		}
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(int nIndex, COleDateTime& time)
{
	_variant_t vtFld;
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(vtIndex)->Value;
		switch(vtFld.vt) 
		{
		case VT_DATE:
			{
				COleDateTime dt(vtFld);
				time = dt;
			}
			break;
		case VT_EMPTY:
		case VT_NULL:
			time.SetStatus(COleDateTime::null);
			break;
		default:
			return FALSE;
		}
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(LPCTSTR lpFieldName, bool& bValue)
{
	_variant_t vtFld;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(lpFieldName)->Value;
		switch(vtFld.vt) 
		{
		case VT_BOOL:
			bValue = vtFld.boolVal == VARIANT_TRUE? true: false;
			break;
		case VT_EMPTY:
		case VT_NULL:
			bValue = false;
			break;
		default:
			return FALSE;
		}
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(int nIndex, bool& bValue)
{
	_variant_t vtFld;
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(vtIndex)->Value;
		switch(vtFld.vt) 
		{
		case VT_BOOL:
			bValue = vtFld.boolVal == VARIANT_TRUE? true: false;
			break;
		case VT_EMPTY:
		case VT_NULL:
			bValue = false;
			break;
		default:
			return FALSE;
		}
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(LPCTSTR lpFieldName, COleCurrency& cyValue)
{
	_variant_t vtFld;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(lpFieldName)->Value;
		switch(vtFld.vt) 
		{
		case VT_CY:
			cyValue = (CURRENCY)vtFld.cyVal;
			break;
		case VT_EMPTY:
		case VT_NULL:
			{
			cyValue = COleCurrency();
			cyValue.m_status = COleCurrency::null;
			}
			break;
		default:
			return FALSE;
		}
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(int nIndex, COleCurrency& cyValue)
{
	_variant_t vtFld;
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(vtIndex)->Value;
		switch(vtFld.vt) 
		{
		case VT_CY:
			cyValue = (CURRENCY)vtFld.cyVal;
			break;
		case VT_EMPTY:
		case VT_NULL:
			{
			cyValue = COleCurrency();
			cyValue.m_status = COleCurrency::null;
			}
			break;
		default:
			return FALSE;
		}
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(LPCTSTR lpFieldName, _variant_t& vtValue)
{
	try
	{
		vtValue = m_pRecordset->Fields->GetItem(lpFieldName)->Value;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::GetFieldValue(int nIndex, _variant_t& vtValue)
{
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	try
	{
		vtValue = m_pRecordset->Fields->GetItem(vtIndex)->Value;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::IsFieldNull(LPCTSTR lpFieldName)
{
	_variant_t vtFld;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(lpFieldName)->Value;
		return vtFld.vt == VT_NULL;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::IsFieldNull(int nIndex)
{
	_variant_t vtFld;
	_variant_t vtIndex;

	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(vtIndex)->Value;
		return vtFld.vt == VT_NULL;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::IsFieldEmpty(LPCTSTR lpFieldName)
{
	_variant_t vtFld;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(lpFieldName)->Value;
		return vtFld.vt == VT_EMPTY || vtFld.vt == VT_NULL;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::IsFieldEmpty(int nIndex)
{
	_variant_t vtFld;
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	try
	{
		vtFld = m_pRecordset->Fields->GetItem(vtIndex)->Value;
		return vtFld.vt == VT_EMPTY || vtFld.vt == VT_NULL;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::SetFieldEmpty(LPCTSTR lpFieldName)
{
	_variant_t vtFld;
	vtFld.vt = VT_EMPTY;
	
	return PutFieldValue(lpFieldName, vtFld);
}

BOOL CAxADORecordSet::SetFieldEmpty(int nIndex)
{
	_variant_t vtFld;
	vtFld.vt = VT_EMPTY;

	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	return PutFieldValue(vtIndex, vtFld);
}

DWORD CAxADORecordSet::GetRecordCount()
{
	DWORD nRows = 0;
	
	try
	{
		nRows = m_pRecordset->GetRecordCount();

		if(nRows == -1)
		{
			nRows = 0;
			if(m_pRecordset->adoEOF != VARIANT_TRUE)
				m_pRecordset->MoveFirst();

			while(m_pRecordset->adoEOF != VARIANT_TRUE)
			{
				nRows++;
				m_pRecordset->MoveNext();
			}
			if(nRows > 0)
				m_pRecordset->MoveFirst();
		}
	}
	catch (_com_error &e)
	{
		/*dump_com_error(e);*/ 
		return -1;
	}

	return nRows;
}

BOOL CAxADORecordSet::IsOpen()
{
	if(m_pRecordset != NULL && IsConnectionOpen())
		return m_pRecordset->GetState() != adStateClosed;
	return FALSE;
}

void CAxADORecordSet::Close()
{
	if(IsOpen())
	{
		if (m_nEditStatus != emDBEditNone)
		      CancelUpdate();

		m_pRecordset->PutSort(_T(""));
		m_pRecordset->Close();	
	}
}

BOOL CAxADORecordSet::RecordBinding(CADORecordBinding &pAdoRecordBinding)
{
	HRESULT hr;
	m_pRecordBinding = NULL;

	//Open the binding interface.
	if(FAILED(hr = m_pRecordset->QueryInterface(__uuidof(IADORecordBinding), (LPVOID*)&m_pRecordBinding )))
	{
		_com_issue_error(hr);
		return FALSE;
	}
	
	//Bind the recordset to class
	if(FAILED(hr = m_pRecordBinding->BindToRecordset(&pAdoRecordBinding)))
	{
		_com_issue_error(hr);
		return FALSE;
	}
	return TRUE;
}

BOOL CAxADORecordSet::GetFieldInfo(LPCTSTR lpFieldName, SAxADOFieldInfo* fldInfo)
{
	FieldPtr pField = m_pRecordset->Fields->GetItem(lpFieldName);
	
	return GetFieldInfo(pField, fldInfo);
}

BOOL CAxADORecordSet::GetFieldInfo(int nIndex, SAxADOFieldInfo* fldInfo)
{
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;

	FieldPtr pField = m_pRecordset->Fields->GetItem(vtIndex);

	return GetFieldInfo(pField, fldInfo);
}

BOOL CAxADORecordSet::GetFieldInfo(FieldPtr pField, SAxADOFieldInfo* fldInfo)
{
	memset(fldInfo, 0, sizeof(SAxADOFieldInfo));

	_tcscpy(fldInfo->m_strName, (LPCTSTR)pField->GetName());
	fldInfo->m_lDefinedSize = pField->GetDefinedSize();
	fldInfo->m_nType = pField->GetType();
	fldInfo->m_lAttributes = pField->GetAttributes();
	if(!IsEof())
		fldInfo->m_lSize = pField->GetActualSize();
	return TRUE;
}

CString CAxADORecordSet::GetFieldName(int nIndex)
{
	_variant_t vtIndex;

	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;

	FieldPtr pField = m_pRecordset->Fields->GetItem(vtIndex);
	if (pField)
	{
		return CString((LPCTSTR)(pField->GetName()));
	}
	return _T("");
}

BOOL CAxADORecordSet::GetChunk(LPCTSTR lpFieldName, CString& strValue)
{
	FieldPtr pField = m_pRecordset->Fields->GetItem(lpFieldName);
	
	return GetChunk(pField, strValue);
}

BOOL CAxADORecordSet::GetChunk(int nIndex, CString& strValue)
{
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;

	FieldPtr pField = m_pRecordset->Fields->GetItem(vtIndex);
	
	return GetChunk(pField, strValue);
}

BOOL CAxADORecordSet::GetChunk(FieldPtr pField, CString& strValue)
{
	CString str;
	long lngSize, lngOffSet = 0;
	_variant_t varChunk;

	lngSize = pField->ActualSize;
	
	str.Empty();
	while(lngOffSet < lngSize)
	{ 
		try
		{
			varChunk = pField->GetChunk(ChunkSize);
			
			str += varChunk.bstrVal;
			lngOffSet += ChunkSize;
		}
		catch(_com_error &e)
		{
			dump_com_error(e);
			return FALSE;
		}
	}

	lngOffSet = 0;
	strValue = str;
	return TRUE;
}

BOOL CAxADORecordSet::GetChunk(LPCTSTR lpFieldName, LPVOID lpData)
{
	FieldPtr pField = m_pRecordset->Fields->GetItem(lpFieldName);

	return GetChunk(pField, lpData);
}

BOOL CAxADORecordSet::GetChunk(int nIndex, LPVOID lpData)
{
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;

	FieldPtr pField = m_pRecordset->Fields->GetItem(vtIndex);

	return GetChunk(pField, lpData);
}

BOOL CAxADORecordSet::GetChunk(FieldPtr pField, LPVOID lpData)
{
	long lngSize, lngOffSet = 0;
	_variant_t varChunk;    
	UCHAR chData;
	HRESULT hr;
	long lBytesCopied = 0;

	lngSize = pField->ActualSize;
	
	while(lngOffSet < lngSize)
	{ 
		try
		{
			varChunk = pField->GetChunk(ChunkSize);

			//Copy the data only upto the Actual Size of Field.  
            for(long lIndex = 0; lIndex <= (ChunkSize - 1); lIndex++)
            {
                hr= SafeArrayGetElement(varChunk.parray, &lIndex, &chData);
                if(SUCCEEDED(hr))
                {
                    //Take BYTE by BYTE and advance Memory Location
                    //hr = SafeArrayPutElement((SAFEARRAY FAR*)lpData, &lBytesCopied ,&chData); 
					((UCHAR*)lpData)[lBytesCopied] = chData;
                    lBytesCopied++;
                }
                else
                    break;
            }
			lngOffSet += ChunkSize;
		}
		catch(_com_error &e)
		{
			dump_com_error(e);
			return FALSE;
		}
	}

	lngOffSet = 0;
	return TRUE;
}

BOOL CAxADORecordSet::AppendChunk(LPCTSTR lpFieldName, LPVOID lpData, UINT nBytes)
{

	FieldPtr pField = m_pRecordset->Fields->GetItem(lpFieldName);

	return AppendChunk(pField, lpData, nBytes);
}

BOOL CAxADORecordSet::AppendChunk(int nIndex, LPVOID lpData, UINT nBytes)
{
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;

	FieldPtr pField = m_pRecordset->Fields->GetItem(vtIndex);

	return AppendChunk(pField, lpData, nBytes);
}

BOOL CAxADORecordSet::AppendChunk(FieldPtr pField, LPVOID lpData, UINT nBytes)
{
	HRESULT hr;
	_variant_t varChunk;
	long lngOffset = 0;
	UCHAR chData;
	SAFEARRAY FAR *psa = NULL;
	SAFEARRAYBOUND rgsabound[1];

	try
	{
		//Create a safe array to store the array of BYTES 
		rgsabound[0].lLbound = 0;
		rgsabound[0].cElements = nBytes;
		psa = SafeArrayCreate(VT_UI1,1,rgsabound);

		while(lngOffset < (long)nBytes)
		{
			chData	= ((UCHAR*)lpData)[lngOffset];
			hr = SafeArrayPutElement(psa, &lngOffset, &chData);

			if(FAILED(hr))
				return FALSE;
			
			lngOffset++;
		}
		lngOffset = 0;

		//Assign the Safe array  to a variant. 
		varChunk.vt = VT_ARRAY|VT_UI1;
		varChunk.parray = psa;

		hr = pField->AppendChunk(varChunk);

		if(SUCCEEDED(hr)) return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}

	return FALSE;
}

CString CAxADORecordSet::GetRecordSetString(LPCTSTR lpCols, LPCTSTR lpRows, LPCTSTR lpNull, long numRows)
{
	_bstr_t varOutput;
	_bstr_t varNull("");
	_bstr_t varCols("\t");
	_bstr_t varRows("\r");

	if(_tcslen(lpCols) != 0)
		varCols = _bstr_t(lpCols);

	if(_tcslen(lpRows) != 0)
		varRows = _bstr_t(lpRows);
	
	if(numRows == 0)
		numRows =(long)GetRecordCount();			
			
	varOutput = m_pRecordset->GetString(adClipString, numRows, varCols, varRows, varNull);

	return (LPCTSTR)varOutput;
}

void CAxADORecordSet::Edit()
{
	m_nEditStatus = emDBEdit;
}

BOOL CAxADORecordSet::AddNew()
{
	m_nEditStatus = emDBEditNone;
	if(m_pRecordset->AddNew() != S_OK)
		return FALSE;

	m_nEditStatus = emDBEditNew;
	return TRUE;
}

BOOL CAxADORecordSet::AddNew(CADORecordBinding &pAdoRecordBinding)
{
	try
	{
		if(m_pRecordBinding->AddNew(&pAdoRecordBinding) != S_OK)
		{
			return FALSE;
		}
		else
		{
			m_pRecordBinding->Update(&pAdoRecordBinding);
			return TRUE;
		}
			
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}	
}

BOOL CAxADORecordSet::Update()
{
	BOOL bret = TRUE;

	if(m_nEditStatus != emDBEditNone)
	{
		try
		{
			if(m_pRecordset->Update() != S_OK)
				bret = FALSE;
		}
		catch(_com_error &e)
		{
			dump_com_error(e);
			bret = FALSE;
		}

		if(!bret)
			m_pRecordset->CancelUpdate();
		m_nEditStatus = emDBEditNone;
	}
	return bret;
}

void CAxADORecordSet::CancelUpdate()
{
	m_pRecordset->CancelUpdate();
	m_nEditStatus = emDBEditNone;
}

BOOL CAxADORecordSet::SetFieldValue(int nIndex, CString strValue)
{
	_variant_t vtFld;
	_variant_t vtIndex;	
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;

	if(!strValue.IsEmpty())
		vtFld.vt = VT_BSTR;
	else
		vtFld.vt = VT_NULL;

	vtFld.bstrVal = strValue.AllocSysString();

	BOOL bret = PutFieldValue(vtIndex, vtFld);

	SysFreeString(vtFld.bstrVal);

	return bret;
}

BOOL CAxADORecordSet::SetFieldValue(LPCTSTR lpFieldName, CString strValue)
{
	_variant_t vtFld;

	if(!strValue.IsEmpty())
		vtFld.vt = VT_BSTR;
	else
		vtFld.vt = VT_NULL;

	vtFld.bstrVal = strValue.AllocSysString();

	BOOL bret =  PutFieldValue(lpFieldName, vtFld);

	SysFreeString(vtFld.bstrVal);

	return bret;
}

BOOL CAxADORecordSet::SetFieldValue(int nIndex, int nValue)
{
	_variant_t vtFld;
	
	vtFld.vt = VT_I2;
	vtFld.iVal = nValue;
	
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	return PutFieldValue(vtIndex, vtFld);
}

BOOL CAxADORecordSet::SetFieldValue(LPCTSTR lpFieldName, int nValue)
{
	_variant_t vtFld;
	
	vtFld.vt = VT_I2;
	vtFld.iVal = nValue;
	
	
	return PutFieldValue(lpFieldName, vtFld);
}

BOOL CAxADORecordSet::SetFieldValue(int nIndex, long lValue)
{
	_variant_t vtFld;
	vtFld.vt = VT_I4;
	vtFld.lVal = lValue;
	
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	return PutFieldValue(vtIndex, vtFld);	
}

BOOL CAxADORecordSet::SetFieldValue(LPCTSTR lpFieldName, long lValue)
{
	_variant_t vtFld;
	vtFld.vt = VT_I4;
	vtFld.lVal = lValue;
	
	return PutFieldValue(lpFieldName, vtFld);
}

BOOL CAxADORecordSet::SetFieldValue(int nIndex, unsigned long ulValue)
{
	_variant_t vtFld;
	vtFld.vt = VT_UI4;
	vtFld.ulVal = ulValue;
	
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	return PutFieldValue(vtIndex, vtFld);	
}

BOOL CAxADORecordSet::SetFieldValue(LPCTSTR lpFieldName, unsigned long ulValue)
{
	_variant_t vtFld;
	vtFld.vt = VT_UI4;
	vtFld.ulVal = ulValue;
	
	return PutFieldValue(lpFieldName, vtFld);
}

BOOL CAxADORecordSet::SetFieldValue(int nIndex, double dblValue)
{
	_variant_t vtFld;
	vtFld.vt = VT_R8;
	vtFld.dblVal = dblValue;

	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;

	return PutFieldValue(vtIndex, vtFld);
}

BOOL CAxADORecordSet::SetFieldValue(LPCTSTR lpFieldName, double dblValue)
{
	_variant_t vtFld;
	vtFld.vt = VT_R8;
	vtFld.dblVal = dblValue;
		
	return PutFieldValue(lpFieldName, vtFld);
}

BOOL CAxADORecordSet::SetFieldValue(int nIndex, COleDateTime time)
{
	_variant_t vtFld;
	vtFld.vt = VT_DATE;
	vtFld.date = time;
	
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	return PutFieldValue(vtIndex, vtFld);
}

BOOL CAxADORecordSet::SetFieldValue(LPCTSTR lpFieldName, COleDateTime time)
{
	_variant_t vtFld;
	vtFld.vt = VT_DATE;
	vtFld.date = time;
	
	return PutFieldValue(lpFieldName, vtFld);
}

BOOL CAxADORecordSet::SetFieldValue(int nIndex, bool bValue)
{
	_variant_t vtFld;
	vtFld.vt = VT_BOOL;
	vtFld.boolVal = bValue;
	
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	return PutFieldValue(vtIndex, vtFld);
}

BOOL CAxADORecordSet::SetFieldValue(LPCTSTR lpFieldName, bool bValue)
{
	_variant_t vtFld;
	vtFld.vt = VT_BOOL;
	vtFld.boolVal = bValue;
	
	return PutFieldValue(lpFieldName, vtFld);
}

BOOL CAxADORecordSet::SetFieldValue(int nIndex, COleCurrency cyValue)
{
	if(cyValue.m_status == COleCurrency::invalid)
		return FALSE;

	_variant_t vtFld;
		
	vtFld.vt = VT_CY;
	vtFld.cyVal = cyValue.m_cur;
	
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	return PutFieldValue(vtIndex, vtFld);
}

BOOL CAxADORecordSet::SetFieldValue(LPCTSTR lpFieldName, COleCurrency cyValue)
{
	if(cyValue.m_status == COleCurrency::invalid)
		return FALSE;

	_variant_t vtFld;

	vtFld.vt = VT_CY;
	vtFld.cyVal = cyValue.m_cur;	
		
	return PutFieldValue(lpFieldName, vtFld);
}

BOOL CAxADORecordSet::SetFieldValue(int nIndex, _variant_t vtValue)
{
	_variant_t vtIndex;
	
	vtIndex.vt = VT_I2;
	vtIndex.iVal = nIndex;
	
	return PutFieldValue(vtIndex, vtValue);
}

BOOL CAxADORecordSet::SetFieldValue(LPCTSTR lpFieldName, _variant_t vtValue)
{	
	return PutFieldValue(lpFieldName, vtValue);
}

BOOL CAxADORecordSet::SetBookmark()
{
	if(m_varBookmark.vt != VT_EMPTY)
	{
		m_pRecordset->Bookmark = m_varBookmark;
		return TRUE;
	}
	return FALSE;
}

BOOL CAxADORecordSet::Delete()
{
	if(m_pRecordset->Delete(adAffectCurrent) != S_OK)
		return FALSE;

	if(m_pRecordset->Update() != S_OK)
		return FALSE;
	
	m_nEditStatus = emDBEditNone;
	return TRUE;
}

BOOL CAxADORecordSet::Find(LPCTSTR lpFind, int nSearchDirection)
{
	m_strFind = lpFind;
	m_nSearchDirection = nSearchDirection;

	ASSERT(!m_strFind.IsEmpty());

	if(m_nSearchDirection == emSearchForward)
	{
		m_pRecordset->Find(_bstr_t(m_strFind), 0, adSearchForward, "");
		if(!IsEof())
		{
			m_varBookFind = m_pRecordset->Bookmark;
			return TRUE;
		}
	}
	else if(m_nSearchDirection == emSearchBackward)
	{
		m_pRecordset->Find(_bstr_t(m_strFind), 0, adSearchBackward, "");
		if(!IsBof())
		{
			m_varBookFind = m_pRecordset->Bookmark;
			return TRUE;
		}
	}
	else
	{
		TRACE("Unknown parameter. %d", nSearchDirection);
		m_nSearchDirection = emSearchForward;
	}
	return FALSE;
}

BOOL CAxADORecordSet::FindFirst(LPCTSTR lpFind)
{
	m_pRecordset->MoveFirst();
	return Find(lpFind);
}

BOOL CAxADORecordSet::FindNext()
{
	if(m_nSearchDirection == emSearchForward)
	{
		m_pRecordset->Find(_bstr_t(m_strFind), 1, adSearchForward, m_varBookFind);
		if(!IsEof())
		{
			m_varBookFind = m_pRecordset->Bookmark;
			return TRUE;
		}
	}
	else
	{
		m_pRecordset->Find(_bstr_t(m_strFind), 1, adSearchBackward, m_varBookFind);
		if(!IsBof())
		{
			m_varBookFind = m_pRecordset->Bookmark;
			return TRUE;
		}
	}
	return FALSE;
}

BOOL CAxADORecordSet::PutFieldValue(LPCTSTR lpFieldName, _variant_t vtFld)
{
	if(m_nEditStatus == emDBEditNone)
		return FALSE;
	
	try
	{
		m_pRecordset->Fields->GetItem(lpFieldName)->Value = vtFld; 
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;	
	}
}

BOOL CAxADORecordSet::PutFieldValue(_variant_t vtIndex, _variant_t vtFld)
{
	if(m_nEditStatus == emDBEditNone)
		return FALSE;

	try
	{
		m_pRecordset->Fields->GetItem(vtIndex)->Value = vtFld;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::Clone(CAxADORecordSet &pRs)
{
	try
	{
		pRs.m_pRecordset = m_pRecordset->Clone(adLockUnspecified);
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::SetFilter(LPCTSTR strFilter)
{
	ASSERT(IsOpen());
	
	try
	{
		m_pRecordset->PutFilter(strFilter);
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::SetSort(LPCTSTR strCriteria)
{
	ASSERT(IsOpen());
	
	try
	{
		m_pRecordset->PutSort(strCriteria);
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::SaveAsXML(LPCTSTR lpstrXMLFile)
{
	HRESULT hr;

	ASSERT(IsOpen());
	
	try
	{
		hr = m_pRecordset->Save(lpstrXMLFile, adPersistXML);
		return hr == S_OK;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
	return TRUE;
}

BOOL CAxADORecordSet::OpenXML(LPCTSTR lpstrXMLFile)
{
	HRESULT hr = S_OK;

	if(IsOpen())
		Close();

	try
	{
		hr = m_pRecordset->Open(lpstrXMLFile, "Provider=MSPersist;", adOpenForwardOnly, adLockOptimistic, adCmdFile);
		return hr == S_OK;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADORecordSet::Execute(CAxADOCommand* pAdoCommand)
{
	if(IsOpen())
		Close();

	ASSERT(!pAdoCommand->GetText().IsEmpty());
	try
	{
		m_pConnection->CursorLocation = adUseClient;
		m_pRecordset = pAdoCommand->GetCommand()->Execute(NULL, NULL, pAdoCommand->GetType());
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

void CAxADORecordSet::dump_com_error(_com_error &e)
{
	CString strError;
	
	
	_bstr_t bstrSource(e.Source());
	_bstr_t bstrDescription(e.Description());

	LPWSTR lpUSource = AxCommonAnsiToUnicode((LPSTR)bstrSource);
	LPWSTR lpUDescription = AxCommonAnsiToUnicode((LPSTR)bstrDescription);

	CString strSource, strDescription;
	strSource = (CString)lpUSource;
	strDescription = (CString)lpUDescription;


	delete []lpUSource;
	delete []lpUDescription;

	strError.Format( _T("CAxADORecordSet Error\r\n\tCode = %08lx\r\n\tCode meaning = %s\r\n\tSource = %s\r\n\tDescription = %s\r\n"),
		             e.Error(), e.ErrorMessage(), strSource, strDescription );
	
	m_strLastError = _T("Query = \" " + GetQuery() + " \"\r\n" + strError);
	m_dwLastError = e.Error();

	//AfxMessageBox(strError, MB_OK | MB_ICONERROR );
	throw CAxADOException(e.Error(), m_strLastError);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CAxADOParameter Class

CAxADOParameter::CAxADOParameter(int nType, long lSize, int nDirection, CString strName)
{
	m_pParameter = NULL;
	m_pParameter.CreateInstance(__uuidof(Parameter));
	m_strName = _T("");
	m_pParameter->Direction = (ParameterDirectionEnum)nDirection;
	m_strName = strName;
	m_pParameter->Name = m_strName.AllocSysString();
	m_pParameter->Type = (DataTypeEnum)nType;
	m_pParameter->Size = lSize;
	m_nType = nType;
}

CAxADOParameter::~CAxADOParameter()
{
	m_pParameter.Release();
	m_pParameter = NULL;
	m_strName = _T("");
}

BOOL CAxADOParameter::SetValue(int nValue)
{
	_variant_t vtVal;

	ASSERT(m_pParameter != NULL);
	
	vtVal.vt = VT_I2;
	vtVal.iVal = nValue;

	try
	{
		if(m_pParameter->Size == 0)
			m_pParameter->Size = sizeof(int);

		m_pParameter->Value = vtVal;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}


BOOL CAxADOParameter::SetValue(long lValue)
{
	_variant_t vtVal;

	ASSERT(m_pParameter != NULL);
	
	vtVal.vt = VT_I4;
	vtVal.lVal = lValue;

	try
	{
		if(m_pParameter->Size == 0)
			m_pParameter->Size = sizeof(long);

		m_pParameter->Value = vtVal;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADOParameter::SetValue(double dblValue)
{
	_variant_t vtVal;

	ASSERT(m_pParameter != NULL);
	
	vtVal.vt = VT_R8;
	vtVal.dblVal = dblValue;

	try
	{
		if(m_pParameter->Size == 0)
			m_pParameter->Size = sizeof(double);

		m_pParameter->Value = vtVal;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADOParameter::SetValue(CString strValue)
{
	_variant_t vtVal;

	ASSERT(m_pParameter != NULL);
	
	if(!strValue.IsEmpty())
		vtVal.vt = VT_BSTR;
	else
		vtVal.vt = VT_NULL;

	vtVal.bstrVal = strValue.AllocSysString();

	try
	{
		if(m_pParameter->Size == 0)
			m_pParameter->Size = sizeof(char) * strValue.GetLength();

		m_pParameter->Value = vtVal;
		::SysFreeString(vtVal.bstrVal);
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		::SysFreeString(vtVal.bstrVal);
		return FALSE;
	}
}

BOOL CAxADOParameter::SetValue(COleDateTime time)
{
	_variant_t vtVal;

	ASSERT(m_pParameter != NULL);
	
	vtVal.vt = VT_DATE;
	vtVal.date = time;

	try
	{
		if(m_pParameter->Size == 0)
			m_pParameter->Size = sizeof(DATE);

		m_pParameter->Value = vtVal;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADOParameter::SetValue(_variant_t vtValue)
{
	ASSERT(m_pParameter != NULL);

	try
	{
		if(m_pParameter->Size == 0)
			m_pParameter->Size = sizeof(VARIANT);
		
		m_pParameter->Value = vtValue;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADOParameter::GetValue(int& nValue)
{
	_variant_t vtVal;
	int nVal = 0;

	try
	{
		vtVal = m_pParameter->Value;

		switch(vtVal.vt)
		{
		case VT_BOOL:
			nVal = vtVal.boolVal;
			break;
		case VT_I2:
		case VT_UI1:
			nVal = vtVal.iVal;
			break;
		case VT_INT:
			nVal = vtVal.intVal;
			break;
		case VT_NULL:
		case VT_EMPTY:
			nVal = 0;
			break;
		default:
			nVal = vtVal.iVal;
		}	
		nValue = nVal;
		return TRUE;
	}
	catch(_com_error& e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADOParameter::GetValue(long& lValue)
{
	_variant_t vtVal;
	long lVal = 0;

	try
	{
		vtVal = m_pParameter->Value;
		if(vtVal.vt != VT_NULL && vtVal.vt != VT_EMPTY)
			lVal = vtVal.lVal;
		lValue = lVal;
		return TRUE;
	}
	catch(_com_error& e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADOParameter::GetValue(double& dbValue)
{
	_variant_t vtVal;
	double dblVal;
	try
	{
		vtVal = m_pParameter->Value;
		switch(vtVal.vt)
		{
		case VT_R4:
			dblVal = vtVal.fltVal;
			break;
		case VT_R8:
			dblVal = vtVal.dblVal;
			break;
		case VT_DECIMAL:
			dblVal = vtVal.decVal.Lo32;
			dblVal *= (vtVal.decVal.sign == 128)? -1 : 1;
			dblVal /= pow((double)10, (int)(vtVal.decVal.scale)); 
			break;
		case VT_UI1:
			dblVal = vtVal.iVal;
			break;
		case VT_I2:
		case VT_I4:
			dblVal = vtVal.lVal;
			break;
		case VT_INT:
			dblVal = vtVal.intVal;
			break;
		case VT_NULL:
		case VT_EMPTY:
			dblVal = 0;
			break;
		default:
			dblVal = 0;
		}
		dbValue = dblVal;
		return TRUE;
	}
	catch(_com_error& e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADOParameter::GetValue(CString& strValue, CString strDateFormat)
{
	_variant_t vtVal;
	CString strVal;

	try
	{
		vtVal = m_pParameter->Value;
		switch(vtVal.vt) 
		{
		case VT_R4:
			strVal = CAxADOUtils::DblToStr(vtVal.fltVal);
			break;
		case VT_R8:
			strVal = CAxADOUtils::DblToStr(vtVal.dblVal);
			break;
		case VT_BSTR:
			strVal = vtVal.bstrVal;
			break;
		case VT_I2:
		case VT_UI1:
			strVal = CAxADOUtils::IntToStr(vtVal.iVal);
			break;
		case VT_INT:
			strVal = CAxADOUtils::IntToStr(vtVal.intVal);
			break;
		case VT_I4:
			strVal = CAxADOUtils::LongToStr(vtVal.lVal);
			break;
		case VT_DECIMAL:
			{
			double val = vtVal.decVal.Lo32;
			val *= (vtVal.decVal.sign == 128)? -1 : 1;
			val /= pow((double)10, (int)(vtVal.decVal.scale)); 
			strVal = CAxADOUtils::DblToStr(val);
			}
			break;
		case VT_DATE:
			{
				COleDateTime dt(vtVal);

				if(strDateFormat.IsEmpty())
					strDateFormat = _T("%Y-%m-%d %H:%M:%S");
				strVal = dt.Format(strDateFormat);
			}
			break;
		case VT_EMPTY:
		case VT_NULL:
			strVal.Empty();
			break;
		default:
			strVal.Empty();
			return FALSE;
		}
		strValue = strVal;
		return TRUE;
	}
	catch(_com_error& e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADOParameter::GetValue(COleDateTime& time)
{
	_variant_t vtVal;

	try
	{
		vtVal = m_pParameter->Value;
		switch(vtVal.vt) 
		{
		case VT_DATE:
			{
				COleDateTime dt(vtVal);
				time = dt;
			}
			break;
		case VT_EMPTY:
		case VT_NULL:
			time.SetStatus(COleDateTime::null);
			break;
		default:
			return FALSE;
		}
		return TRUE;
	}
	catch(_com_error& e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADOParameter::GetValue(_variant_t& vtValue)
{
	try
	{
		vtValue = m_pParameter->Value;
		return TRUE;
	}
	catch(_com_error& e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

void CAxADOParameter::dump_com_error(_com_error &e)
{
	CString strError;	
	

	_bstr_t bstrSource(e.Source());
	_bstr_t bstrDescription(e.Description());

	LPWSTR lpUSource = AxCommonAnsiToUnicode((LPSTR)bstrSource);
	LPWSTR lpUDescription = AxCommonAnsiToUnicode((LPSTR)bstrDescription);

	CString strSource, strDescription;
	strSource = (CString)lpUSource;
	strDescription = (CString)lpUDescription;


	delete []lpUSource;
	delete []lpUDescription;


	strError.Format(_T("CAxADOParameter Error\r\n\tCode = %08lx\r\n\tCode meaning = %s\r\n\tSource = %s\r\n\tDescription = %s\r\n"),
		            e.Error(), e.ErrorMessage(), strSource, strDescription );
	
	m_strLastError = strError;
	m_dwLastError = e.Error();

	//AfxMessageBox(strError, MB_OK | MB_ICONERROR );
	throw CAxADOException(e.Error(), m_strLastError);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CAxADOCommand Class

CAxADOCommand::CAxADOCommand(CAxADODataBase* pAdoDatabase, CString strCommandText, int nCommandType)
{
	m_pCommand = NULL;
	m_pCommand.CreateInstance(__uuidof(Command));
	m_strCommandText = strCommandText;
	m_pCommand->CommandText = m_strCommandText.AllocSysString();
	m_nCommandType = nCommandType;
	m_pCommand->CommandType = (CommandTypeEnum)m_nCommandType;
	m_pCommand->ActiveConnection = pAdoDatabase->GetActiveConnection();	
	m_nRecordsAffected = 0;
}

CAxADOCommand::~CAxADOCommand()
{
	::SysFreeString(m_pCommand->CommandText);
	m_pCommand.Release();
	m_pCommand = NULL;
	m_strCommandText = _T("");
}

BOOL CAxADOCommand::AddParameter(CAxADOParameter* pAdoParameter)
{
	ASSERT(pAdoParameter->GetParameter() != NULL);

	try
	{
		m_pCommand->Parameters->Append(pAdoParameter->GetParameter());
		return TRUE;
	}
	catch(_com_error& e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

BOOL CAxADOCommand::AddParameter(CString strName, int nType, int nDirection, long lSize, int nValue)
{
	_variant_t vtValue;

	vtValue.vt = VT_I2;
	vtValue.iVal = nValue;

	return AddParameter(strName, nType, nDirection, lSize, vtValue);
}

BOOL CAxADOCommand::AddParameter(CString strName, int nType, int nDirection, long lSize, long lValue)
{
	_variant_t vtValue;

	vtValue.vt = VT_I4;
	vtValue.lVal = lValue;

	return AddParameter(strName, nType, nDirection, lSize, vtValue);
}

BOOL CAxADOCommand::AddParameter(CString strName, int nType, int nDirection, long lSize, double dblValue, int nPrecision, int nScale)
{
	_variant_t vtValue;

	vtValue.vt = VT_R8;
	vtValue.dblVal = dblValue;

	return AddParameter(strName, nType, nDirection, lSize, vtValue, nPrecision, nScale);
}

BOOL CAxADOCommand::AddParameter(CString strName, int nType, int nDirection, long lSize, CString strValue)
{
	_variant_t vtValue;

	vtValue.vt = VT_BSTR;
	vtValue.bstrVal = strValue.AllocSysString();

	return AddParameter(strName, nType, nDirection, lSize, vtValue);
}

BOOL CAxADOCommand::AddParameter(CString strName, int nType, int nDirection, long lSize, COleDateTime time)
{
	_variant_t vtValue;

	vtValue.vt = VT_DATE;
	vtValue.date = time;

	return AddParameter(strName, nType, nDirection, lSize, vtValue);
}

BOOL CAxADOCommand::AddParameter(CString strName, int nType, int nDirection, long lSize, _variant_t vtValue, int nPrecision, int nScale)
{
	try
	{
		_ParameterPtr pParam = m_pCommand->CreateParameter(strName.AllocSysString(), (DataTypeEnum)nType, (ParameterDirectionEnum)nDirection, lSize, vtValue);
		pParam->PutPrecision(nPrecision);
		pParam->PutNumericScale(nScale);
		m_pCommand->Parameters->Append(pParam);
		
		return TRUE;
	}
	catch(_com_error& e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

void CAxADOCommand::SetText(CString strCommandText)
{
	ASSERT(!strCommandText.IsEmpty());

	m_strCommandText = strCommandText;
	m_pCommand->CommandText = m_strCommandText.AllocSysString();
}

void CAxADOCommand::SetType(int nCommandType)
{
	m_nCommandType = nCommandType;
	m_pCommand->CommandType = (CommandTypeEnum)m_nCommandType;
}

BOOL CAxADOCommand::Execute(int nCommandType /*= typeCmdStoredProc*/)
{
	_variant_t vRecords;
	m_nRecordsAffected = 0;
	try
	{
		m_nCommandType = nCommandType;
		m_pCommand->Execute(&vRecords, NULL, nCommandType);
		m_nRecordsAffected = vRecords.iVal;
		return TRUE;
	}
	catch(_com_error &e)
	{
		dump_com_error(e);
		return FALSE;
	}
}

void CAxADOCommand::dump_com_error(_com_error &e)
{
	CString strError;


	_bstr_t bstrSource(e.Source());
	_bstr_t bstrDescription(e.Description());

	LPWSTR lpUSource = AxCommonAnsiToUnicode((LPSTR)bstrSource);
	LPWSTR lpUDescription = AxCommonAnsiToUnicode((LPSTR)bstrDescription);

	CString strSource, strDescription;
	strSource = (CString)lpUSource;
	strDescription = (CString)lpUDescription;


	delete []lpUSource;
	delete []lpUDescription;

	strError.Format( _T("CAxADORecordSet Error\r\n\tCode = %08lx\r\n\tCode meaning = %s\r\n\tSource = %s\r\n\tDescription = %s\r\n"),
		            e.Error(), e.ErrorMessage(), strSource, strDescription );

	m_strLastError = _T("Command = \" " + m_strCommandText + " \"\r\n" + strError);
	m_dwLastError = e.Error();
	
	//AfxMessageBox(strError, MB_OK | MB_ICONERROR );
	throw CAxADOException(e.Error(), m_strLastError);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CAxADOOLEDBDataLink Class

CAxADOOLEDBDataLink::CAxADOOLEDBDataLink()
{
	m_pDataLink = NULL;
}

CAxADOOLEDBDataLink::~CAxADOOLEDBDataLink()
{
	m_pDataLink = NULL;
}

CString CAxADOOLEDBDataLink::New(HWND hWnd /*= NULL*/)
{
	m_pDataLink = NULL;
	m_pDataLink.CreateInstance(__uuidof(oledb::DataLinks));

	try
	{
		if(hWnd = NULL)
			m_pDataLink->PuthWnd(reinterpret_cast<long>(hWnd));

		IDispatchPtr pDisp = m_pDataLink->PromptNew();
		
		_ConnectionPtr conn = pDisp;

		CString strReturn = conn->GetConnectionString().copy();

		m_pDataLink.Release();
		m_pDataLink = NULL;

		return strReturn;
	}
	catch(_com_error &e)
	{
		throw CAxADOOLEDBException(e.WCode(), e.Description());
	}
}

CString CAxADOOLEDBDataLink::Edit(CString strConnectionString, HWND hWnd)
{
	BOOL bRet;
	m_pDataLink = NULL;
	IDispatch* pDispatch = NULL;
	_ConnectionPtr pAdoConnection;

	m_pDataLink.CreateInstance(__uuidof(oledb::DataLinks));
	HRESULT hr = pAdoConnection.CreateInstance((__uuidof(Connection)));

	LPSTR lpSrcConnection = AxCommonUnicodeToAnsi(LPWSTR((LPCTSTR)strConnectionString));
	_bstr_t bstrConnectionString = _bstr_t(lpSrcConnection);

	delete []lpSrcConnection;
	
	try
	{
		m_pDataLink->PuthWnd(reinterpret_cast<long>(hWnd));
		pAdoConnection->PutConnectionString(bstrConnectionString);
		pAdoConnection.QueryInterface(IID_IDispatch, (LPVOID*)&pDispatch);

		bRet = m_pDataLink->PromptEdit(&pDispatch) == VARIANT_TRUE;

		_ConnectionPtr conn = pDispatch;
		CString strReturn = conn->GetConnectionString().copy();

		m_pDataLink.Release();
		pAdoConnection.Release();

		return strReturn;
	}
	catch(_com_error &e)
	{
		throw CAxADOOLEDBException(e.WCode(), e.Description());
	}
}