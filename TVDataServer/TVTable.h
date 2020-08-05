
#pragma once

#include "TVObject.h"

enum EMTVNodeType;

class CTVNodeBase;
class CTVTable : public CTVObject
{
	DECLARE_DYNAMIC(CTVTable)

public:
	CTVTable();
	CTVTable( const CTVTable& copy ) {*this = copy;}
	CTVTable& operator=( const CTVTable& copy );
	virtual ~CTVTable();

	//basic
	CString			m_strTableName;					// Table名
	CString			m_strSQLProcedure;				// Table所对应的查询语句或者存储过程
	
	//for export use
	CString			m_strTableFileName;				// Table所对应文件名
	BOOL			m_bUpdated;						// 标识是否有数据更新
	CString			m_strChecksum;					// 标识是否有数据更新

	//node related
	CTVNodeBase*	m_pParentNode;
	HTREEITEM		m_hTreeCtrlItem;
	EMTVNodeType	m_emTableLevelType;

public:
	// Only if (m_emTableLevelType=emTypeCourt), the strParentNodeID is CourtID and the strParentNodeParentID is the related SessionID.
	// Otherwise, strParentNodeID is m_pParentNode->m_strID
	virtual BOOL GetSQLResults(OUT SAxTableRecordSet &sRecordSet, CString strParentNodeID, CString strParentNodeParentID = _T(""));
	virtual BOOL GetSQLResults(OUT SAxTableRecordSet &sRecordSet); // Only if (m_pParentNode != NULL), this function can be called

	static CString ParseSQLExpression(CString strSourceSQL, CString strParam1, CString strParam2); // Replace the "[@P1]" and "[@P2]" in the m_strSQLProcedure

	//call this ONLY after this table has been exported to csv
	BOOL UpdateChecksum();

private:
	BOOL CalcFileChecksum(const LPCTSTR lpFileName, OUT CString &strChecksum);
};

typedef CArray<CTVTable*,CTVTable*> typeARRAYTVTABLE;

class CTVTableManager
{
public:
	CTVTableManager(){};
	virtual ~CTVTableManager();

	BOOL AddTable(CTVTable* pTVTable);
	void DeleteTable(CTVTable* pTVTable);
	void DeleteTable(int iIdx);
	void DeleteAllTable();

	//after get the table, you must enter critical section before doing operations.
	CTVTable* GetTable(int iIdx);
	CTVTable* GetTableByName(const CString strTableName);

	int FindTableIndex(const CString strTableName);
	int FindTableIndex(const CTVTable* pTVTable);
	int GetTableCount(){ return (int)m_aryTables.GetSize(); }

protected:
	typeARRAYTVTABLE m_aryTables;
};

