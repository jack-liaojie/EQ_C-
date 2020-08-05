/////////////////////////////////////////////////////////////////////////
// FileName: AxCoolADO2.h
// Description: Use ADO LINQ to Database. the ADO provides the full Function
// Date: 2009.02.25
// Author: Zhao Haijun
/////////////////////////////////////////////////////////////////////////

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#include <icrsint.h>
#include <math.h>
#include <afxdb.h>


#pragma warning( push )
#pragma warning(disable : 4146)
#pragma warning(disable : 4192)

//#import "c:\program files\common files\system\ado\msado15.dll" no_namespace \
//		rename ("EOF", "adoEOF") 
//	
//#import "C:\\Program Files\\Common Files\\System\\ADO\\msadox.dll" no_namespace \
//	rename ("_Collection", "_CollectionX") \
//	rename("_DynaCollection", "_DynaCollectionX") \
//	rename("Properties", "PropertiesX") \
//	rename("Property", "PropertyX") \
//	exclude("DataTypeEnum")\
//
//#import "C:\\Program Files\\Common Files\\System\\ado\\MSJRO.dll" no_namespace rename("ReplicaTypeEnum", "_ReplicaTypeEnum") 
//#import "C:\\Program Files\\Common Files\\System\\ole db\\oledb32.dll" rename_namespace("oledb")

#import "AdoDlls\msado15.dll" no_namespace \
	rename ("EOF", "adoEOF") 

#import "AdoDlls\msadox.dll" no_namespace \
	rename ("_Collection", "_CollectionX") \
	rename("_DynaCollection", "_DynaCollectionX") \
	rename("Properties", "PropertiesX") \
	rename("Property", "PropertyX") \
	exclude("DataTypeEnum")\

#import "AdoDlls\MSJRO.dll" no_namespace rename("ReplicaTypeEnum", "_ReplicaTypeEnum") 
#import "AdoDlls\oledb32.dll" rename_namespace("oledb")

#pragma warning( pop )

class CAxADOCommand;

struct SAxADOFieldInfo
{
	TCHAR m_strName[50]; 
	short m_nType;
	long m_lSize; 
	long m_lDefinedSize;
	long m_lAttributes;
	short m_nOrdinalPosition;
	BOOL m_bRequired;   
	BOOL m_bAllowZeroLength; 
	long m_lCollatingOrder;  
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Utils For AxADO

class  CAxADOUtils
{
public:
	static CString Get_ComError(_com_error &e);

// 1. data type convert to String 
	static CString IntToStr(int nVal);
	static CString LongToStr(long lVal);
	static CString ULongToStr(unsigned long ulVal);
	static CString DblToStr(double dblVal, int ndigits = 20);
	static CString DblToStr(float fltVal);
	static CString ADODataTypeToSQLServerDataTypeStr(DataTypeEnum eType);

// Create/delete Database
	static BOOL CreateDatabase_Jet(LPCTSTR lpszFileName);
	static BOOL CreateDatabase_SQLServer(LPCTSTR lpszServer, LPCTSTR lpszUID, LPCTSTR lpszPWD, LPCTSTR lpszDatabaseName, LPCTSTR lpszFileName = NULL, long lSize = 1, long lMaxSize = -1, long lFileGrowth = 1);
	static BOOL DeleteDatabase_SQLServer(LPCTSTR lpszServer, LPCTSTR lpszUID, LPCTSTR lpszPWD, LPCTSTR lpszDatabaseName);

	static CString MakeOLEDB_Jet(LPCTSTR lpszDataSource, LPCTSTR lpszUID = NULL, LPCTSTR lpszPWD = NULL);
	static CString MakeOLEDB_SQLServer(LPCTSTR lpszServer, LPCTSTR lpszDatabase = NULL, LPCTSTR lpszUID = NULL, LPCTSTR lpszPWD = NULL);

// 2. ADO Connection String
	static BOOL ParseOLEDB_SQLServer_ConStr(CString strConnection, 
									OUT CString &strServer, OUT CString &strDatabase, OUT CString &strUserID, OUT CString &strPassword);
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// CADOException Process the exception

class  CAxADOException
{
public:
	CAxADOException(): m_lErrorCode(0),	m_strError(_T("")){}
	CAxADOException(long lErrorCode): m_lErrorCode(lErrorCode), m_strError(_T("")){}
	CAxADOException(long lErrorCode, const CString& strError): m_lErrorCode(lErrorCode), m_strError(strError){}
	CAxADOException(const CString& strError):m_lErrorCode(0), m_strError(strError){}
	CAxADOException(long lErrorCode, const char* szError): m_lErrorCode(lErrorCode), m_strError(szError){}
	CAxADOException(const char* szError):m_lErrorCode(0),m_strError(szError){}

	virtual ~CAxADOException(){}

	CString GetErrorMessage() const	{return m_strError; };
	void SetErrorMessage(LPCTSTR lpstrError = _T("")){ m_strError = lpstrError; };
	long GetError(){ return m_lErrorCode; };
	void SetError(long lErrorCode = 0){ m_lErrorCode = lErrorCode; };

protected:
	CString m_strError;
	long m_lErrorCode;
};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// The CAxADODataBase class has a set of functions 
// that corresponds to the _ConnectionPtr.

class  CAxADODataBase
{
public:
	CAxADODataBase();
	virtual ~CAxADODataBase();

public:
	_ConnectionPtr m_pConnection;
	
	enum EADOConnectMode
    {	
		emConModeUnknown = adModeUnknown,
		emConModeRead = adModeRead,
		emConModeWrite = adModeWrite,
		emConModeReadWrite = adModeReadWrite,
		emConModeShareDenyRead = adModeShareDenyRead,
		emConModeShareDenyWrite = adModeShareDenyWrite,
		emConModeShareExclusive = adModeShareExclusive,
		emConModeShareDenyNone = adModeShareDenyNone
    };

protected:
	CString m_strConnection;
	CString m_strLastError;
	CString m_strErrorDescription;
	DWORD m_dwLastError;
	int m_nRecordsAffected;
	long m_nConnectionTimeout;

public:
	//Opens a connection to a database.
	BOOL Open(LPCTSTR lpstrConnection = _T(""), LPCTSTR lpstrUserID = _T(""), LPCTSTR lpstrPassword = _T(""));
	
	// Returns the status of the connection with the database
	BOOL IsOpen();

	// closes the connection to the database
	void Close();

	//The Execute function executes a SQL statement in the open database.
	BOOL Execute(LPCTSTR lpstrExecSql);

	//Returns the active connection
	_ConnectionPtr GetActiveConnection(){ return m_pConnection; };
	
	//Returns the number of records affected by the last SQL statement executed.
	int GetRecordsAffected(){ return m_nRecordsAffected; };

	//Returns the number of records affected in a query
	DWORD GetRecordCount(_RecordsetPtr pRs);
	
	// Transaction Operator
	long BeginTransaction(){ return m_pConnection->BeginTrans(); };
	long CommitTransaction(){ return m_pConnection->CommitTrans(); };
	long RollbackTransaction(){ return m_pConnection->RollbackTrans(); };

	// these Functions must be Execute before Open(....);
	void SetConnectionTimeout(long nConnectionTimeout = 30){ m_nConnectionTimeout = nConnectionTimeout; };
	void SetConnectionMode(EADOConnectMode nMode){ m_pConnection->PutMode((enum ConnectModeEnum)nMode); };
	void SetConnectionString(LPCTSTR lpstrConnection){ m_strConnection = lpstrConnection; };
	CString GetConnectionString() {return m_strConnection; };
	
	// Error Process
	CString GetLastErrorString(){ return m_strLastError; };
	DWORD GetLastError(){ return m_dwLastError; };
	CString GetErrorDescription(){ return m_strErrorDescription; };

protected:
	void dump_com_error(_com_error &e);
};

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
// The CAxADORecordSet class has a set of functions 
// that corresponds to the _RecordsetPtr.

class  CAxADORecordSet
{
public:
	CAxADORecordSet();
	CAxADORecordSet(CAxADODataBase* pAdoDatabase);
	virtual ~CAxADORecordSet();

	BOOL Clone(CAxADORecordSet& pRs);	

public:
	enum EAxADOOpen
	{
		emOpenUnknown = 0,
		emOpenQuery = 1,
		emOpenTable = 2,
		emOpenStoredProc = 3
	};

	enum EAxADOEdit
	{
		emDBEditNone = 0,
		emDBEditNew = 1,
		emDBEdit = 2
	};
	
	enum EAxADOPosition
	{
		emPositionUnknown = -1,
		emPositionBOF = -2,
		emPositionEOF = -3
	};
	
	enum EAxADOSearch
	{	
		emSearchForward = 1,
		emSearchBackward = -1
	};

	enum EAxADODataType
	{
		emDataTypeEmpty = adEmpty,
		emDataTypeTinyInt = adTinyInt,
		emDataTypeSmallInt = adSmallInt,
		emDataTypeInteger = adInteger,
		emDataTypeBigInt = adBigInt,
		emDataTypeUnsignedTinyInt = adUnsignedTinyInt,
		emDataTypeUnsignedSmallInt = adUnsignedSmallInt,
		emDataTypeUnsignedInt = adUnsignedInt,
		emDataTypeUnsignedBigInt = adUnsignedBigInt,
		emDataTypeSingle = adSingle,
		emDataTypeDouble = adDouble,
		emDataTypeCurrency = adCurrency,
		emDataTypeDecimal = adDecimal,
		emDataTypeNumeric = adNumeric,
		emDataTypeBoolean = adBoolean,
		emDataTypeError = adError,
		emDataTypeUserDefined = adUserDefined,
		emDataTypeVariant = adVariant,
		emDataTypeIDispatch = adIDispatch,
		emDataTypeIUnknown = adIUnknown,
		emDataTypeGUID = adGUID,
		emDataTypeDate = adDate,
		emDataTypeDBDate = adDBDate,
		emDataTypeDBTime = adDBTime,
		emDataTypeDBTimeStamp = adDBTimeStamp,
		emDataTypeBSTR = adBSTR,
		emDataTypeChar = adChar,
		emDataTypeVarChar = adVarChar,
		emDataTypeLongVarChar = adLongVarChar,
		emDataTypeWChar = adWChar,
		emDataTypeVarWChar = adVarWChar,
		emDataTypeLongVarWChar = adLongVarWChar,
		emDataTypeBinary = adBinary,
		emDataTypeVarBinary = adVarBinary,
		emDataTypeLongVarBinary = adLongVarBinary,
		emDataTypeChapter = adChapter,
		emDataTypeFileTime = adFileTime,
		emDataTypePropVariant = adPropVariant,
		emDataTypeVarNumeric = adVarNumeric,
		emDataTypeArray = adVariant
	};
	
	enum EAxADOSchemaType 
	{
		emSchemaSpecific = adSchemaProviderSpecific,	
		emSchemaAsserts = adSchemaAsserts,
		emSchemaCatalog = adSchemaCatalogs,
		emSchemaCharacterSet = adSchemaCharacterSets,
		emSchemaCollections = adSchemaCollations,
		emSchemaColumns = adSchemaColumns,
		emSchemaConstraints = adSchemaCheckConstraints,
		emSchemaConstraintColumnUsage = adSchemaConstraintColumnUsage,
		emSchemaConstraintTableUsage  = adSchemaConstraintTableUsage,
		emShemaKeyColumnUsage = adSchemaKeyColumnUsage,
		emSchemaTableConstraints = adSchemaTableConstraints,
		emSchemaColumnsDomainUsage = adSchemaColumnsDomainUsage,
		emSchemaIndexes = adSchemaIndexes,
		emSchemaColumnPrivileges = adSchemaColumnPrivileges,
		emSchemaTablePrivileges = adSchemaTablePrivileges,
		emSchemaUsagePrivileges = adSchemaUsagePrivileges,
		emSchemaProcedures = adSchemaProcedures,
		emSchemaTables = adSchemaTables,
		emSchemaProviderTypes = adSchemaProviderTypes,
		emSchemaViews = adSchemaViews,
		emSchemaViewTableUsage = adSchemaViewTableUsage,
		emSchemaProcedureParameters = adSchemaProcedureParameters,
		emSchemaForeignKeys = adSchemaForeignKeys,
		emSchemaPrimaryKeys = adSchemaPrimaryKeys,
		emSchemaProcedureColumns = adSchemaProcedureColumns,
		emSchemaDBInfoKeywords = adSchemaDBInfoKeywords,
		emSchemaDBInfoLiterals = adSchemaDBInfoLiterals,
		emSchemaCubes = adSchemaCubes,
		emSchemaDimensions = adSchemaDimensions,
		emSchemaHierarchies  = adSchemaHierarchies, 
		emSchemaLevels = adSchemaLevels,
		emSchemaMeasures = adSchemaMeasures,
		emSchemaProperties = adSchemaProperties,
		emSchemaMembers = adSchemaMembers,
	}; 

public:
	_RecordsetPtr m_pRecordset;
	_CommandPtr m_pCommand;
	
protected:
	_ConnectionPtr m_pConnection;
	int m_nSearchDirection;
	CString m_strFind;
	_variant_t m_varBookFind;
	_variant_t m_varBookmark;
	int m_nEditStatus;
	CString m_strLastError;
	DWORD m_dwLastError;
	IADORecordBinding *m_pRecordBinding;
	CString m_strQuery;

public:
	// Opens a recordset
	BOOL Open(_ConnectionPtr mpdb, LPCTSTR lpstrExec = _T(""), int nOption = CAxADORecordSet::emOpenUnknown);
	BOOL Open(LPCTSTR lpstrExecSql = _T(""), int nOption = CAxADORecordSet::emOpenUnknown);

	BOOL OpenSchema(int nSchema, LPCTSTR SchemaID = _T(""));

    // Determines if the recordset is open
	BOOL IsOpen();

	// Closes the recordset.
	void Close();
	
	// Member Object Operator
	BOOL IsConnectionOpen()	{ return m_pConnection != NULL && m_pConnection->GetState() != adStateClosed; };
	_RecordsetPtr GetRecordset(){ return m_pRecordset; };
	_ConnectionPtr GetActiveConnection(){ return m_pConnection; };

	// indicates a filter for data in an open Recordset
	// LPCTSTR strFilter - a string composed by one or more individual clauses concatenated with AND or OR operators
	BOOL SetFilter(LPCTSTR strFilter);

	// sets the sort order for records in a CAxADORecordset object
	// LPCTSTR lpstrCriteria - A string that contains the ORDER BY clause of an SQL statement
	BOOL SetSort(LPCTSTR lpstrCriteria);

	BOOL Execute(CAxADOCommand* pCommand);
	
	// Adds a record in the open recordset
	BOOL AddNew();
	BOOL AddNew(CADORecordBinding &pAdoRecordBinding);

	// allows changes to the current record in the open recordset
	void Edit();

	// updates the pending updates in the current record
	BOOL Update();
	void CancelUpdate();

	// deletes the current record in the open recordset
	BOOL Delete();

	// locates a string from the current position in the open recordset using an operator of comparison
	BOOL Find(LPCTSTR lpFind, int nSearchDirection = CAxADORecordSet::emSearchForward);
	BOOL FindFirst(LPCTSTR lpFind);
	BOOL FindNext();

	// Returns the string containing the SQL SELECT statement.
	CString GetQuery(){ return m_strQuery;};
	BOOL Requery();
	void SetQuery(LPCTSTR strQuery){ m_strQuery = strQuery; };

	BOOL RecordBinding(CADORecordBinding &pAdoRecordBinding);
	
	// Returns the number of records accessed in the recordset
	DWORD GetRecordCount();

	// Returns the number of fields in the recordset
	long GetFieldCount(){ try {return m_pRecordset->Fields->GetCount(); }	catch(_com_error &e){/*dump_com_error(e); */return -1;} };

	BOOL GetFieldInfo(LPCTSTR lpFieldName, SAxADOFieldInfo* fldInfo);
	BOOL GetFieldInfo(int nIndex, SAxADOFieldInfo* fldInfo);

	//  Returns a value that contains the value of a field
	//  strDateFormat - A formatting time string similar to the strftime formatting string. The more common are: 
	//					%a - Abbreviated weekday name 
	//					%A - Full weekday name 
	//					%b - Abbreviated month name 
	///					%B - Full month name 
	//					%c - Date and time representation appropriate for locale 
	//					%d - Day of month as decimal number (01 - 31) 
	//					%H - Hour in 24-hour format (00 - 23) 
	//					%I - Hour in 12-hour format (01 - 12) 
	//					%j - Day of year as decimal number (001 - 366) 
	//					%m - Month as decimal number (01 - 12) 
	//					%M - Minute as decimal number (00 - 59) 
	//					%p - Current locale¡¯s A.M./P.M. indicator for 12-hour clock 
	//					%S - Second as decimal number (00 - 59) 
	//					%U - Week of year as decimal number, with Sunday as first day of week (00 - 53) 
	//					%w - Weekday as decimal number (0 - 6; Sunday is 0) 
	//					%W - Week of year as decimal number, with Monday as first day of week (00 - 53) 
	//					%x - Date representation for current locale 
	//					%X - Time representation for current locale 
	//					%y - Year without century, as decimal number (00 - 99) 
	//					%Y - Year with century, as decimal number 

	CString GetFieldName(int nIndex); //  [12/21/2009 GRL Add]

	BOOL GetFieldValue(LPCTSTR lpFieldName, int& nValue);
	BOOL GetFieldValue(int nIndex, int& nValue);
	BOOL GetFieldValue(LPCTSTR lpFieldName, long& lValue);
	BOOL GetFieldValue(int nIndex, long& lValue);
	BOOL GetFieldValue(LPCTSTR lpFieldName, unsigned long& ulValue);
	BOOL GetFieldValue(int nIndex, unsigned long& ulValue);
	BOOL GetFieldValue(LPCTSTR lpFieldName, double& dbValue);
	BOOL GetFieldValue(int nIndex, double& dbValue);
	BOOL GetFieldValue(LPCTSTR lpFieldName, CString& strValue, CString strDateFormat = _T(""));
	BOOL GetFieldValue(int nIndex, CString& strValue, CString strDateFormat = _T(""));
	BOOL GetFieldValue(LPCTSTR lpFieldName, COleDateTime& time);
	BOOL GetFieldValue(int nIndex, COleDateTime& time);
	BOOL GetFieldValue(int nIndex, bool& bValue);
	BOOL GetFieldValue(LPCTSTR lpFieldName, bool& bValue);
	BOOL GetFieldValue(int nIndex, COleCurrency& cyValue);
	BOOL GetFieldValue(LPCTSTR lpFieldName, COleCurrency& cyValue);
	BOOL GetFieldValue(int nIndex, _variant_t& vtValue);
	BOOL GetFieldValue(LPCTSTR lpFieldName, _variant_t& vtValue);

	BOOL SetFieldValue(int nIndex, int nValue);
	BOOL SetFieldValue(LPCTSTR lpFieldName, int nValue);
	BOOL SetFieldValue(int nIndex, long lValue);
	BOOL SetFieldValue(LPCTSTR lpFieldName, long lValue);
	BOOL SetFieldValue(int nIndex, unsigned long lValue);
	BOOL SetFieldValue(LPCTSTR lpFieldName, unsigned long lValue);
	BOOL SetFieldValue(int nIndex, double dblValue);
	BOOL SetFieldValue(LPCTSTR lpFieldName, double dblValue);
	BOOL SetFieldValue(int nIndex, CString strValue);
	BOOL SetFieldValue(LPCTSTR lpFieldName, CString strValue);
	BOOL SetFieldValue(int nIndex, COleDateTime time);
	BOOL SetFieldValue(LPCTSTR lpFieldName, COleDateTime time);
	BOOL SetFieldValue(int nIndex, bool bValue);
	BOOL SetFieldValue(LPCTSTR lpFieldName, bool bValue);
	BOOL SetFieldValue(int nIndex, COleCurrency cyValue);
	BOOL SetFieldValue(LPCTSTR lpFieldName, COleCurrency cyValue);
	BOOL SetFieldValue(int nIndex, _variant_t vtValue);
	BOOL SetFieldValue(LPCTSTR lpFieldName, _variant_t vtValue);

	BOOL SetFieldEmpty(int nIndex);
	BOOL SetFieldEmpty(LPCTSTR lpFieldName);

	BOOL IsFieldNull(LPCTSTR lpFieldName);
	BOOL IsFieldNull(int nIndex);
	BOOL IsFieldEmpty(LPCTSTR lpFieldName);
	BOOL IsFieldEmpty(int nIndex);	

	BOOL IsEof(){ return m_pRecordset->adoEOF == VARIANT_TRUE; };
	BOOL IsEOF(){ return m_pRecordset->adoEOF == VARIANT_TRUE; };
	BOOL IsBof(){ return m_pRecordset->BOF == VARIANT_TRUE; };
	BOOL IsBOF(){ return m_pRecordset->BOF == VARIANT_TRUE; };

	void MoveFirst()	{ try {m_pRecordset->MoveFirst();}		catch(_com_error &e){dump_com_error(e);} };
	void MoveNext()		{ try {m_pRecordset->MoveNext();}		catch(_com_error &e){dump_com_error(e);} };
	void MovePrevious()	{ try {m_pRecordset->MovePrevious();}	catch(_com_error &e){dump_com_error(e);} };
	void MoveLast()		{ try {m_pRecordset->MoveLast();}		catch(_com_error &e){dump_com_error(e);} };

	// Indicates on which page the current record resides
	long GetAbsolutePage(){ return m_pRecordset->GetAbsolutePage(); };
	void SetAbsolutePage(int nPage /* starting from 1*/){ m_pRecordset->PutAbsolutePage((enum PositionEnum)nPage); };

	// Returns the number of pages in the recordset.
	long GetPageCount(){ return m_pRecordset->GetPageCount(); };
    
	// Indicates the number of records per page.
	long GetPageSize(){ return m_pRecordset->GetPageSize(); };
	void SetPageSize(int nSize){ m_pRecordset->PutPageSize(nSize); };

	// Indicates the position of the record in the recordset
	long GetAbsolutePosition(){ return m_pRecordset->GetAbsolutePosition(); };
	void SetAbsolutePosition(int nPosition){ m_pRecordset->PutAbsolutePosition((enum PositionEnum)nPosition); };
	
	BOOL AppendChunk(LPCTSTR lpFieldName, LPVOID lpData, UINT nBytes);
	BOOL AppendChunk(int nIndex, LPVOID lpData, UINT nBytes);

	// This function returns all, or a portion, of the contents of a large text or binary data Field object.
	BOOL GetChunk(LPCTSTR lpFieldName, CString& strValue);
	BOOL GetChunk(int nIndex, CString& strValue);
	BOOL GetChunk(LPCTSTR lpFieldName, LPVOID pData);
	BOOL GetChunk(int nIndex, LPVOID pData);

	// Returns a recordset as a string
	CString GetRecordSetString(LPCTSTR lpCols, LPCTSTR lpRows, LPCTSTR lpNull, long numRows = 0);
	
	CString GetLastErrorString(){ return m_strLastError; };
	DWORD GetLastError(){ return m_dwLastError; };

	// saves the position of the current record
	void GetBookmark(){ m_varBookmark = m_pRecordset->Bookmark; };
	BOOL SetBookmark();

	// opens a XML file format in a recordset
	BOOL OpenXML(LPCTSTR lpstrXMLFile);

	// Saves the open recordset in a file with XML format
	BOOL SaveAsXML(LPCTSTR lpstrXMLFile);
	
protected:
	BOOL PutFieldValue(LPCTSTR lpFieldName, _variant_t vtFld);
	BOOL PutFieldValue(_variant_t vtIndex, _variant_t vtFld);
	BOOL GetFieldInfo(FieldPtr pField, SAxADOFieldInfo* fldInfo);
	BOOL GetChunk(FieldPtr pField, CString& strValue);
	BOOL GetChunk(FieldPtr pField, LPVOID lpData);
	BOOL AppendChunk(FieldPtr pField, LPVOID lpData, UINT nBytes);
	
	void dump_com_error(_com_error &e);	
};

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
// a set of functions 
// that corresponds to the _ParameterPtr

class  CAxADOParameter
{
public:
	//If you are using CAxADORecordset::emDataTypeNumeric or CAxADORecordset::emDataTypeDecimal, you must define the precision and scale values
	CAxADOParameter(int nType, long lSize = 0, int nDirection = emParamInput, CString strName = _T(""));
	virtual ~CAxADOParameter();
	
public:
	enum EAxADOParameterDirection
	{
		emParamUnknown = adParamUnknown,
		emParamInput = adParamInput,
		emParamOutput = adParamOutput,
		emParamInputOutput = adParamInputOutput,
		emParamReturnValue = adParamReturnValue 
	};

protected:
	_ParameterPtr m_pParameter;
	CString m_strName;
	int m_nType;
	CString m_strLastError;
	DWORD m_dwLastError;

public:
	void SetPrecision(int nPrecision){ m_pParameter->PutPrecision(nPrecision); };
	void SetScale(int nScale){ m_pParameter->PutNumericScale(nScale); };

	void SetName(CString strName){ m_strName = strName; };
	CString GetName(){ return m_strName; };

	int GetType(){ return m_nType; };
	_ParameterPtr GetParameter(){ return m_pParameter; };

	BOOL SetValue(int nValue);
	BOOL SetValue(long lValue);
	BOOL SetValue(double dbValue);
	BOOL SetValue(CString strValue);
	BOOL SetValue(COleDateTime time);
	BOOL SetValue(_variant_t vtValue);

	BOOL GetValue(int& nValue);
	BOOL GetValue(long& lValue);
	BOOL GetValue(double& dbValue);
	BOOL GetValue(CString& strValue, CString strDateFormat = _T(""));
	BOOL GetValue(COleDateTime& time);
	BOOL GetValue(_variant_t& vtValue);

protected:
	void dump_com_error(_com_error &e);	
};

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
// a set of functions that corresponds to the _CommandPtr

class  CAxADOCommand
{
public:
	CAxADOCommand(CAxADODataBase* pAdoDatabase, CString strCommandText = _T(""), int nCommandType = emTypeCmdStoredProc);
	virtual ~CAxADOCommand();
	
public:
	enum EAxADOCommandType
	{
		emTypeCmdText = adCmdText,
		emTypeCmdTable = adCmdTable,
		emTypeCmdTableDirect = adCmdTableDirect,
		emTypeCmdStoredProc = adCmdStoredProc,
		emTypeCmdUnknown = adCmdUnknown,
		emTypeCmdFile = adCmdFile
	};
		
public:
	void SetTimeout(long nTimeOut){ m_pCommand->PutCommandTimeout(nTimeOut); };
	
	void SetText(CString strCommandText);
	CString GetText(){ return m_strCommandText; };

	void SetType(int nCommandType);
	int GetType(){ return m_nCommandType; };

	BOOL AddParameter(CAxADOParameter* pAdoParameter);
	BOOL AddParameter(CString strName, int nType, int nDirection, long lSize, int nValue);
	BOOL AddParameter(CString strName, int nType, int nDirection, long lSize, long lValue);
	BOOL AddParameter(CString strName, int nType, int nDirection, long lSize, double dblValue, int nPrecision = 0, int nScale = 0);
	BOOL AddParameter(CString strName, int nType, int nDirection, long lSize, CString strValue);
	BOOL AddParameter(CString strName, int nType, int nDirection, long lSize, COleDateTime time);
	BOOL AddParameter(CString strName, int nType, int nDirection, long lSize, _variant_t vtValue, int nPrecision = 0, int nScale = 0);

	BOOL Execute(int nCommandType = emTypeCmdStoredProc);
	int GetRecordsAffected(){ return m_nRecordsAffected; };
	_CommandPtr GetCommand(){ return m_pCommand; };

protected:
	void dump_com_error(_com_error &e);

protected:
	_CommandPtr m_pCommand;
	int m_nCommandType;
	int m_nRecordsAffected;
	CString m_strCommandText;
	CString m_strLastError;
	DWORD m_dwLastError;
};

/////////////////////////////////////////////////////////////////////
//	CAxADOOLEDBException Class
//  an utility class to create and edit datalinks

class  CAxADOOLEDBDataLink
{
public:
	CAxADOOLEDBDataLink();
	virtual ~CAxADOOLEDBDataLink();

	CString New(HWND hWnd = NULL);
	CString Edit(CString strConnectionString, HWND hWnd);

private:
	oledb::IDataSourceLocatorPtr m_pDataLink;
};


/////////////////////////////////////////////////////////////////////
//	CAxADOOLEDBException Class
//

class  CAxADOOLEDBException
{
public:
	CAxADOOLEDBException() :m_lErrorCode(0),m_strError(_T("")){}
	CAxADOOLEDBException(long lErrorCode) :m_lErrorCode(lErrorCode),	m_strError(_T("")){}
	CAxADOOLEDBException(long lErrorCode, const CString& strError) :	m_lErrorCode(lErrorCode),m_strError(strError){}
	CAxADOOLEDBException(const CString& strError) :m_lErrorCode(0),m_strError(strError){}
	CAxADOOLEDBException(long lErrorCode, const char* szError) :	m_lErrorCode(lErrorCode),m_strError(szError){}
	CAxADOOLEDBException(const char* szError) :m_lErrorCode(0),m_strError(szError){}

	virtual ~CAxADOOLEDBException(){}

public:
	CString GetErrorMessage() const { return m_strError; };
	void SetError(LPCTSTR lpstrError = _T("")){ m_strError = lpstrError; };
	long GetError(){ return m_lErrorCode; };
	void SetError(long lErrorCode = 0){ m_lErrorCode = lErrorCode; };

protected:
	CString m_strError;
	long m_lErrorCode;
};
