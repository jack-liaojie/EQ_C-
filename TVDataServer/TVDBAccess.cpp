#include "StdAfx.h"
#include "TVDataServer.h"
#include "TVDBAccess.h"
#include "TVTable.h"
#include "TVNodeBase.h"

CTVDBAccess g_DBAccess;

CTVDBAccess::CTVDBAccess(void)
{
}

CTVDBAccess::~CTVDBAccess(void)
{
}

CString CTVDBAccess::GetDisciplineID(CString strDisciplineCode)
{
	if (strDisciplineCode.IsEmpty())
		return _T("");

	CString strFmt = _T("EXEC [Proc_TV_APP_GetDisciplineID] '%s' ");
	CString strSQL;
	strSQL.Format(strFmt, strDisciplineCode);

	CString strDisciplineID;
	try
	{
		CAxADORecordSet adoRecordSet(theApp.GetDataBase());	
		if (adoRecordSet.Open(strSQL))
		{
			adoRecordSet.GetFieldValue(0, strDisciplineID);
			adoRecordSet.Close();
		}
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return _T("");
	}
	catch (...)
	{
		return _T("");
	}

	return strDisciplineID;
}

CString CTVDBAccess::GetMatchFullName(CString strMatchID)
{
	if (!IsValidID(strMatchID))
		return _T("");

	CString strFmt = _T("EXEC [Proc_TV_APP_GetMatchFullName] %s ");

	CString strSQL;
	strSQL.Format(strFmt, strMatchID);

	CString strMatchFullName;

	try
	{
		CAxADORecordSet adoRecordSet(theApp.GetDataBase());	
		if (adoRecordSet.Open(strSQL))
		{
			adoRecordSet.GetFieldValue(0, strMatchFullName);

			adoRecordSet.Close();
		}
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return _T("");
	}
	catch (...)
	{
		return _T("");
	}

	return AxCommonAdjustFileName(strMatchFullName);
}

BOOL CTVDBAccess::GetAllSessionIDsAndNums(CString strDisciplineCode, OUT CStringArray &straSessionIDs, OUT CStringArray &straSessionNums, OUT CStringArray  &straSessionDays)
{
	if (strDisciplineCode.IsEmpty())
		return TRUE;

	CString strFmt = _T("EXEC [Proc_TV_APP_GetAllSessionIDs_SessionNums] '%s' ");
	CString strSQL;
	strSQL.Format(strFmt, strDisciplineCode);

	try
	{
		CAxADORecordSet adoRecordSet(theApp.GetDataBase());
		if (adoRecordSet.Open(strSQL))
		{
			while (!adoRecordSet.IsEOF())
			{
				CString strSessionID, strSessionNum, strSeesionDay;
				adoRecordSet.GetFieldValue(0, strSessionID);
				adoRecordSet.GetFieldValue(1, strSessionNum);
				adoRecordSet.GetFieldValue(2, strSeesionDay);
				straSessionIDs.Add(strSessionID);
				straSessionNums.Add(strSessionNum);
				straSessionDays.Add(strSeesionDay);
				adoRecordSet.MoveNext();
			}
			adoRecordSet.Close();
		}
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}
	
	return TRUE;
}

BOOL CTVDBAccess::GetAllDisciplineDates(CString strDisciplineCode, OUT CStringArray &straDateIDs, OUT CStringArray &straDateNames)
{
	if (strDisciplineCode.IsEmpty())
		return FALSE;

	CString strFmt = _T("EXEC [Proc_TV_APP_GetDisciplineDates] '%s' ");
	CString strSQL;
	strSQL.Format(strFmt, strDisciplineCode);

	try
	{
		CAxADORecordSet adoRecordSet(theApp.GetDataBase());	
		if (adoRecordSet.Open(strSQL))
		{
			while (!adoRecordSet.IsEOF())
			{
				CString strDateID, strDateName;
				adoRecordSet.GetFieldValue(0, strDateID);
				adoRecordSet.GetFieldValue(1, strDateName);
				straDateIDs.Add(strDateID);
				straDateNames.Add(strDateName);

				adoRecordSet.MoveNext();
			}
			adoRecordSet.Close();
		}
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}

	return TRUE;
}

BOOL CTVDBAccess::GetDateSessions(CString strDisciplineCode, CString strDateID, OUT CStringArray &straSessionIDs, OUT CStringArray &straSessionNames)
{
	if (strDisciplineCode.IsEmpty())
		return FALSE;

	CString strFmt = _T("EXEC [Proc_TV_APP_GetDateSessions] '%s', %d ");
	CString strSQL;
	strSQL.Format(strFmt, strDisciplineCode, _ttoi(strDateID));

	try
	{
		CAxADORecordSet adoRecordSet(theApp.GetDataBase());
		if (adoRecordSet.Open(strSQL))
		{
			while (!adoRecordSet.IsEOF())
			{
				CString strSessionID, strSessionName;
				adoRecordSet.GetFieldValue(0, strSessionID);
				adoRecordSet.GetFieldValue(1, strSessionName);
				straSessionIDs.Add(strSessionID);
				straSessionNames.Add(AxCommonAdjustFileName(strSessionName));

				adoRecordSet.MoveNext();
			}
			adoRecordSet.Close();
		}
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}

	return TRUE;
}

BOOL CTVDBAccess::GetAllMatchIDsAndCourts(CString strSessionID, OUT CStringArray &straMatchIDs, OUT CStringArray &straCourtIDs, OUT CStringArray &straCourtNames)
{
	if (!IsValidID(strSessionID))
		return TRUE;

	CString strFmt = _T("EXEC [Proc_TV_APP_GetAllMatchIDs_CourtIDs_CourtNames] %s ");
	CString strSQL;
	strSQL.Format(strFmt, strSessionID);

	try
	{
		CAxADORecordSet adoRecordSet(theApp.GetDataBase());	
		if (adoRecordSet.Open(strSQL))
		{
			while (!adoRecordSet.IsEOF())
			{
				CString strMatchID;
				CString strCourtID;
				CString strCourtName;

				adoRecordSet.GetFieldValue(0, strMatchID);
				adoRecordSet.GetFieldValue(1, strCourtID);
				adoRecordSet.GetFieldValue(2, strCourtName);

				straMatchIDs.Add(strMatchID);
				straCourtIDs.Add(strCourtID);
				straCourtNames.Add(AxCommonAdjustFileName(strCourtName));

				adoRecordSet.MoveNext();
			}
			adoRecordSet.Close();
		}
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}

	return TRUE;
}

CString CTVDBAccess::GetMatchStatus(CString strMatchID)
{
	if (!IsValidID(strMatchID))
		return _T("");

	CString strFmt = _T("EXEC [Proc_TV_APP_GetMatchStatus] %s ");
	CString strSQL;
	strSQL.Format(strFmt, strMatchID);

	CString strMatchStatus;
	try
	{
		CAxADORecordSet adoRecordSet(theApp.GetDataBase());
		if (adoRecordSet.Open(strSQL))
		{
			adoRecordSet.GetFieldValue(0, strMatchStatus);
			adoRecordSet.Close();
		}
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return _T("");
	}
	catch (...)
	{
		return _T("");
	}

	return strMatchStatus;
}

CString CTVDBAccess::GetCourtName(CString strCourtID)
{
	if (!IsValidID(strCourtID))
		return _T("");

	CString strFmt = _T("EXEC [Proc_TV_APP_GetCourtName] %s ");
	CString strSQL;
	strSQL.Format(strFmt, strCourtID);

	CString strCourtName;
	try
	{	
		CAxADORecordSet adoRecordSet(theApp.GetDataBase());	
		if (adoRecordSet.Open(strSQL))
		{
			adoRecordSet.GetFieldValue(0, strCourtName);
			adoRecordSet.Close();
		}
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return _T("");
	}
	catch (...)
	{
		return _T("");
	}

	return AxCommonAdjustFileName(strCourtName);
}

CString CTVDBAccess::GetSessionID(CString strMatchID, OUT CString *pstrCourtID/* = NULL*/)
{
	if (!IsValidID(strMatchID))
		return _T("");

	CString strFmt = _T("EXEC [Proc_TV_APP_GetSessionIDAndCourtID] %s ");
	CString strSQL;
	strSQL.Format(strFmt, strMatchID);
	
	CString strSessionID;
	try
	{
		CAxADORecordSet adoRecordSet(theApp.GetDataBase());	
		if (adoRecordSet.Open(strSQL))
		{
			adoRecordSet.GetFieldValue(0, strSessionID);

			if (pstrCourtID)
			{
				adoRecordSet.GetFieldValue(1, *pstrCourtID);
			}

			adoRecordSet.Close();
		}
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return _T("");
	}
	catch (...)
	{
		return _T("");
	}

	return strSessionID;
}


//CString CTVDBAccess::GetSessionNum(CString strDateID)
//{
//	CString strFmt = _T("SELECT F_SessionNumber FROM TS_Session \
//						WHERE F_SessionID=%s");
//	CString strSQL;
//	strSQL.Format(strFmt, strDateID);
//
//	CAxADORecordSet adoRecordSet(theApp.GetDataBase());	
//	CString strDateName;
//	try
//	{
//		if (adoRecordSet.Open(strSQL))
//		{
//			adoRecordSet.GetFieldValue(0, strDateName);
//			adoRecordSet.Close();
//		}
//	}
//	catch (CAxADOException &e)
//	{
//		return _T("");
//	}	
//
//	return strDateName;
//}
//
//CString CTVDBAccess::GetMatchName(CString strMatchID)
//{
//	CString strFmt = _T("SELECT F_MatchShortName FROM TS_Match_Des \
//						WHERE F_MatchID=%s AND F_LanguageCode = 'ENG'");
//	CString strSQL;
//	strSQL.Format(strFmt, strMatchID);
//
//	CAxADORecordSet adoRecordSet(theApp.GetDataBase());	
//	CString strMatchName;
//	try
//	{
//		if (adoRecordSet.Open(strSQL))
//		{
//			adoRecordSet.GetFieldValue(0, strMatchName);
//			adoRecordSet.Close();
//		}
//	}
//	catch (CAxADOException &e)
//	{
//		g_Log.OutPutMsg(e.GetErrorMessage());
//		return _T("");
//	}	
//
//	return strMatchName;
//}
//
//CString CTVDBAccess::GetPhaseName(CString strPhaseID)
//{
//	CString strFmt = _T("SELECT F_PhaseShortName FROM TS_Phase_Des \
//						WHERE F_PhaseID=%s AND F_LanguageCode = 'ENG'");
//	CString strSQL;
//	strSQL.Format(strFmt, strPhaseID);
//
//	CAxADORecordSet adoRecordSet(theApp.GetDataBase());	
//	CString strPhaseName;
//	try
//	{
//		if (adoRecordSet.Open(strSQL))
//		{
//			adoRecordSet.GetFieldValue(0, strPhaseName);
//			adoRecordSet.Close();
//		}
//	}
//	catch (CAxADOException &e)
//	{
//		return _T("");
//	}	
//
//	return strPhaseName;
//}
//CString CTVDBAccess::GetEventName(CString strEventID)
//{
//	CString strFmt = _T("SELECT F_EventShortName FROM TS_Event_Des \
//						WHERE F_EventID=%s AND F_LanguageCode = 'ENG'");
//	CString strSQL;
//	strSQL.Format(strFmt, strEventID);
//
//	CAxADORecordSet adoRecordSet(theApp.GetDataBase());	
//	CString strEventName;
//	try
//	{
//		if (adoRecordSet.Open(strSQL))
//		{
//			adoRecordSet.GetFieldValue(0, strEventName);
//			adoRecordSet.Close();
//		}
//	}
//	catch (CAxADOException &e)
//	{
//		return _T("");
//	}	
//
//	return strEventName;
//}
//

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//////// CAxDBOperator//////////////////////////////////////////////////////////////////////////////////
BOOL CTVTableDBOperator::GetAllTVTables(SAxTableRecordSet& rsResult, CString strDisciplineCode /*= _T("")*/)
{
	ValidateDBTable();

	CString strSQL;
	strSQL.Format(_T("SELECT F_TableName, F_TableLevelType, F_SqlProcedure FROM TI_TVResultTable"));
	if (!strDisciplineCode.IsEmpty())
	{
		strSQL += _T(" WHERE F_DisciplineCode = '") + strDisciplineCode + _T("'");
	}

	try
	{
		CAxADORecordSet obRecordSet(theApp.GetDataBase());
		obRecordSet.Open(strSQL);
		AxCommonTransRecordSet(obRecordSet, rsResult);
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}

	return TRUE;
}

// Create TI_TVResultTable if it's not exist
BOOL CTVTableDBOperator::ValidateDBTable()
{
	CString strSQL;
	strSQL = _T("IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TI_TVResultTable]') AND type in (N'U')) \
				\
				CREATE TABLE [dbo].[TI_TVResultTable]( \
				[F_DisciplineCode] [nvarchar](10) COLLATE Chinese_PRC_CI_AS NOT NULL, \
				[F_TableName] [nvarchar](50) COLLATE Chinese_PRC_CI_AS NOT NULL, \
				[F_TableLevelType] [nvarchar](50) COLLATE Chinese_PRC_CI_AS NULL, \
				[F_SqlProcedure] [nvarchar](2000) COLLATE Chinese_PRC_CI_AS NULL, \
				[F_UpdateType] [int] NULL, \
				CONSTRAINT [PK_TI_TVResultTable] PRIMARY KEY CLUSTERED  \
				( \
				[F_DisciplineCode] ASC, \
				[F_TableName] ASC \
				)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY] \
				) ON [PRIMARY] \
				");

	try
	{
		CAxADOCommand cmdADO(theApp.GetDataBase());
		cmdADO.SetText(strSQL);

		if (!cmdADO.Execute(CAxADOCommand::emTypeCmdText))
			return FALSE;
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return FALSE;		
	}
	catch (...)
	{
		return FALSE;
	}

	return TRUE;
}

BOOL CTVTableDBOperator::IsTableExist(CString strTableName)
{
	if( strTableName.IsEmpty())
		return FALSE;

	CString strSQL;
	strSQL.Format(_T("SELECT F_TableName FROM TI_TVResultTable \
					 WHERE F_DisciplineCode='%s' AND F_TableName='%s'"),					 
					 theApp.GetDisciplineCode(), strTableName);

	try
	{
		CAxADORecordSet obRecordSet(theApp.GetDataBase());
		if (obRecordSet.Open(strSQL))
		{
			if (obRecordSet.GetRecordCount() <= 0)
				return FALSE;
		}
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}

	return TRUE;
}

BOOL CTVTableDBOperator::InsertTVTable(CTVTable* pTable)
{
	if( pTable == NULL)
		return FALSE;

	// 处理单引号
	CString strSqlProcedure = pTable->m_strSQLProcedure;
	strSqlProcedure.Replace(_T("'"),_T("''"));

	CString strSQL;
	strSQL.Format(_T("INSERT INTO TI_TVResultTable (F_DisciplineCode, F_TableName, F_TableLevelType, F_SqlProcedure) \
					 VALUES('%s', '%s', '%s', '%s')"), 
					 theApp.GetDisciplineCode(),
					 pTable->m_strTableName, NodeType2String(pTable->m_emTableLevelType), strSqlProcedure);

	try
	{
		CAxADOCommand cmdADO(theApp.GetDataBase());
		cmdADO.SetText(strSQL);
		if (!cmdADO.Execute(CAxADOCommand::emTypeCmdText))
			return FALSE;
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}

	return TRUE;
}

BOOL CTVTableDBOperator::UpdateTVTable(CTVTable* pTable)
{
	if( pTable == NULL)
		return FALSE;

	// 处理单引号
	CString strSqlProcedure = pTable->m_strSQLProcedure;
	strSqlProcedure.Replace(_T("'"),_T("''"));

	CString strSQL;
	strSQL.Format(_T("UPDATE TI_TVResultTable \
					 SET F_TableLevelType='%s', F_SqlProcedure='%s' \
					 WHERE F_DisciplineCode='%s' AND F_TableName='%s'"),					 
					 NodeType2String(pTable->m_emTableLevelType), strSqlProcedure, theApp.GetDisciplineCode(), pTable->m_strTableName);

	try
	{
		CAxADOCommand cmdADO(theApp.GetDataBase());
		cmdADO.SetText(strSQL);
		if (!cmdADO.Execute(CAxADOCommand::emTypeCmdText))
			return FALSE;
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}

	return TRUE;
}

BOOL CTVTableDBOperator::DeleteTVTable(CTVTable* pTable)
{
	if( pTable == NULL)
		return FALSE;

	CString strSQL;
	strSQL.Format(_T("DELETE FROM TI_TVResultTable WHERE F_DisciplineCode ='%s' AND F_TableName = '%s'"), 
		theApp.GetDisciplineCode(), pTable->m_strTableName);

	try
	{
		CAxADOCommand cmdADO(theApp.GetDataBase());
		cmdADO.SetText(strSQL);
		if (!cmdADO.Execute(CAxADOCommand::emTypeCmdText))
			return FALSE;
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}

	return TRUE;
}

BOOL CTVDBAccess::GetTVTableContent(CString strSQL, OUT SAxTableRecordSet &sRecordSet )
{
	try
	{
		CAxADODataBase adoTempConn; // Create new connection for each call
		if (!adoTempConn.Open(theApp.GetConnectString()))
			return FALSE;

		CAxADORecordSet adoRecordSet(&adoTempConn);	
		if (adoRecordSet.Open(strSQL))
		{
			AxCommonTransRecordSet(adoRecordSet, sRecordSet);		
		}
	}
	catch (CAxADOException &e)
	{
		g_Log.OutPutMsg(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}

	return TRUE;
}