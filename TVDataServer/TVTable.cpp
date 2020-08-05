#include "StdAfx.h"
#include "TVTable.h"
#include "TVDataServer.h"
#include "TVDataManager.h"

IMPLEMENT_DYNAMIC(CTVTable, CTVObject)

//CTVTable
CTVTable::CTVTable()
{
	m_emObjType = emObjTypeTVTable;
	m_emTableLevelType = emTypeUnknown;

	m_bUpdated = FALSE;

	m_pParentNode = NULL;
	m_hTreeCtrlItem = NULL;

	m_strChecksum = _T("");
	m_strTableName = _T("");
	m_strTableFileName = _T("");
	m_strSQLProcedure = _T("");
}

CTVTable& CTVTable::operator= (const CTVTable& copy)
{
	m_strTableName = copy.m_strTableName;
	m_strSQLProcedure = copy.m_strSQLProcedure;
	m_strTableFileName = copy.m_strTableFileName;	
	m_emTableLevelType = copy.m_emTableLevelType;

	return *this;
}

CTVTable::~CTVTable()
{
	m_pParentNode = NULL;
	m_hTreeCtrlItem = NULL;
}

BOOL CTVTable::GetSQLResults(OUT SAxTableRecordSet &sRecordSet, CString strParentNodeID, CString strParentNodeParentID /* = _T */)
{
	CString strSQL = ParseSQLExpression(m_strSQLProcedure, strParentNodeID, strParentNodeParentID);

	return g_DBAccess.GetTVTableContent(strSQL, sRecordSet);
}
BOOL CTVTable::GetSQLResults(OUT SAxTableRecordSet &sRecordSet)
{
	if (!m_pParentNode)
		return FALSE;
	
	if (m_emTableLevelType == emTypeCourt)
		return GetSQLResults(sRecordSet, m_pParentNode->m_strID, m_pParentNode->m_pParentNode->m_strID);
	else
		return GetSQLResults(sRecordSet, m_pParentNode->m_strID);
}

CString CTVTable::ParseSQLExpression(CString strSourceSQL, CString strParam1, CString strParam2)
{
	CString strSQL = strSourceSQL;
	strSQL.Replace(_T("[@P1]"), strParam1);
	strSQL.Replace(_T("[@P2]"), strParam2);

	return strSQL;
}

BOOL CTVTable::UpdateChecksum()
{
	return CalcFileChecksum(m_strTableFileName,m_strChecksum);
}

BOOL CTVTable::CalcFileChecksum(const LPCTSTR lpFileName, OUT CString &strChecksum)
{
	if (!lpFileName)
		return FALSE;

	DWORD dwSum = 0;
	BYTE* pByteRead = new BYTE;
	CAxStdioFileEx fFile;
	if( fFile.Open( lpFileName, CFile::modeRead|CFile::typeBinary))
	{
		fFile.SeekToBegin();
		while (fFile.Read(pByteRead,1) != 0)
		{
			dwSum += *pByteRead;
		}
		fFile.Close();
		delete pByteRead;
		strChecksum.Format(_T("%08X"),dwSum);
		return TRUE;
	}
	delete pByteRead;
	return FALSE;
}

//////////////////////////////////////////////////////////////////////////
// TableManager implement

CTVTableManager::~CTVTableManager()
{
	DeleteAllTable();
}
BOOL CTVTableManager::AddTable(CTVTable* pTVTable)
{
	if (!pTVTable)
		return FALSE;
	return m_aryTables.Add(pTVTable);
}


CTVTable* CTVTableManager::GetTable(int iIdx) 
{
	if( iIdx >= 0 && iIdx < m_aryTables.GetSize() )
		return m_aryTables[iIdx];

	return NULL;
}

CTVTable* CTVTableManager::GetTableByName(const CString strTableName) 
{
	int nTableCount = m_aryTables.GetSize();
	for(int i = 0; i < nTableCount; i++)
	{
		CTVTable* pItem = (CTVTable*)m_aryTables[i];
		if( pItem->m_strTableName.CompareNoCase(strTableName) == 0 )
			return pItem;
	}
	return NULL;
}


void CTVTableManager::DeleteTable(CTVTable* pTVTable)
{
	if( pTVTable == NULL )
		return;

	int nTableIdx = FindTableIndex(pTVTable);
	if (nTableIdx < 0)
		return;

	delete m_aryTables[nTableIdx];
	m_aryTables.RemoveAt(nTableIdx);

}
void CTVTableManager::DeleteTable(int iIdx)
{
	if( iIdx >= 0 && iIdx < m_aryTables.GetSize() )
		return;

	delete m_aryTables[iIdx];
	m_aryTables.RemoveAt(iIdx);
}
void CTVTableManager::DeleteAllTable()
{
	int nTableCount = m_aryTables.GetSize();
	for (int i = 0; i < nTableCount; i++)
	{
		delete m_aryTables[i];
	}
	m_aryTables.RemoveAll();
}

int CTVTableManager::FindTableIndex(const CTVTable* pTVTable)
{
	int nTableCount = m_aryTables.GetSize();
	for (int i = 0; i < nTableCount; i++)
	{
		if ( m_aryTables[i] == pTVTable )
			return i;
	}

	return -1;
}
int CTVTableManager::FindTableIndex(const CString strTableName)
{
	int nTableCount = m_aryTables.GetSize();
	for (int i = 0; i < nTableCount; i++)
	{
		if ( m_aryTables[i]->m_strTableName == strTableName )
			return i;
	}

	return -1;
}