#include "stdafx.h"
#include "InnerMisla.h"
#include "CRSInfoServer.h"

extern CCRSInfoServerApp theApp;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//////// CAxDBOperator//////////////////////////////////////////////////////////////////////////////////
BOOL CAxDBOperator::GetAllTopicItems(SAxTableRecordSet& rsResult, CString strDisciplineCode /*= _T("")*/)
{
	ValidateDBInfoTable();

	CString strSQL;
	strSQL.Format(_T("SELECT * FROM TI_CRS_Info"));
	if (!strDisciplineCode.IsEmpty())
	{
		strSQL += _T(" WHERE F_DisciplineCode = '") + strDisciplineCode + _T("'");
	}
	strSQL += _T(" ORDER BY F_MsgTypeID");

	CAxADORecordSet obRecordSet(theApp.GetDataBase());
	obRecordSet.Open(strSQL);
	AxCommonTransRecordSet(obRecordSet, rsResult);

	return TRUE;	
}
// Create TI_CRS_Info if it's not exist
BOOL CAxDBOperator::ValidateDBInfoTable()
{
	CString strSQL;
	strSQL = _T("IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TI_CRS_Info]') AND type in (N'U')) \
				 \
				 CREATE TABLE [dbo].[TI_CRS_Info](\
				 [F_MsgKey] [nvarchar](50) COLLATE Chinese_PRC_CI_AS NOT NULL,\
				 [F_DisciplineCode] [nvarchar](10) COLLATE Chinese_PRC_CI_AS NOT NULL,\
				 [F_MsgTypeID] [nvarchar](50) COLLATE Chinese_PRC_CI_AS NOT NULL,\
				 [F_MsgTypeDes] [nvarchar](50) COLLATE Chinese_PRC_CI_AS NULL,\
				 [F_SqlProcedure] [nvarchar](2000) COLLATE Chinese_PRC_CI_AS NULL,\
				 [F_Language] [nvarchar](50) COLLATE Chinese_PRC_CI_AS NULL,\
				 [F_MsgLevel] [nvarchar](50) COLLATE Chinese_PRC_CI_AS NULL,\
				 CONSTRAINT [PK_TI_CRS_Info] PRIMARY KEY CLUSTERED \
				 (\
				 [F_MsgKey] ASC\
				 )WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]\
	) ON [PRIMARY]\
				");

	CAxADOCommand cmdADO(theApp.GetDataBase());
	cmdADO.SetText(strSQL);
	try 
	{
		if ( cmdADO.Execute(CAxADOCommand::emTypeCmdText))
		{
			return TRUE;
		}
		return FALSE;
	}
	catch (CAxADOException &e)
	{
		AfxMessageBox(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}
}

BOOL CAxDBOperator::InsertTopicItem(STopicItem* pTopicItem)
{
	if( pTopicItem == NULL)
		return FALSE;

	// 处理单引号
	CString strSqlProcedure = pTopicItem->m_strSQLProcedure;
	strSqlProcedure.Replace(_T("'"),_T("''"));

	CString strSQL;
	strSQL.Format(_T("INSERT INTO TI_CRS_Info (F_MsgKey, F_DisciplineCode, F_MsgTypeID, F_MsgTypeDes, F_SqlProcedure, F_Language, F_MsgLevel) \
					  VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s') \
					  SET NOCOUNT OFF "), 
					  pTopicItem->m_strMsgKey, pTopicItem->m_strDisciplineCode, pTopicItem->m_strMsgType, pTopicItem->m_strMsgName, 
					  strSqlProcedure, pTopicItem->m_strLanguage, pTopicItem->m_strMsgLevel);

	CAxADOCommand cmdADO(theApp.GetDataBase());
	cmdADO.SetText(strSQL);
	try
	{
		if ( cmdADO.Execute(CAxADOCommand::emTypeCmdText))
		{
			return TRUE;
		}
		return FALSE;

	}
	catch (CAxADOException &e)
	{
		AfxMessageBox(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}
}

BOOL CAxDBOperator::UpdateTopicItem(STopicItem* pTopicItem)
{
	if( pTopicItem == NULL)
		return FALSE;

	// 处理单引号
	CString strSqlProcedure = pTopicItem->m_strSQLProcedure;
	strSqlProcedure.Replace(_T("'"),_T("''"));

	CString strSQL;
	strSQL.Format(_T("UPDATE TI_CRS_Info \
					  SET F_MsgTypeDes='%s', F_SqlProcedure='%s', F_Language='%s', F_MsgLevel='%s' \
					  WHERE F_DisciplineCode ='%s' AND F_MsgKey = '%s'")
					  ,pTopicItem->m_strMsgName, strSqlProcedure, pTopicItem->m_strLanguage, pTopicItem->m_strMsgLevel,
					  pTopicItem->m_strDisciplineCode, pTopicItem->m_strMsgKey);

	CAxADOCommand cmdADO(theApp.GetDataBase());
	cmdADO.SetText(strSQL);
	try
	{
		if ( cmdADO.Execute(CAxADOCommand::emTypeCmdText))
		{
			return TRUE;
		}
		return FALSE;

	}
	catch (CAxADOException &e)
	{
		AfxMessageBox(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}
}

BOOL CAxDBOperator::DeleteTopicItem(STopicItem* pTopicItem)
{
	if( pTopicItem == NULL)
		return FALSE;

	CString strSQL;
	strSQL.Format(_T("DELETE FROM TI_CRS_Info WHERE F_DisciplineCode ='%s' AND F_MsgKey = '%d'"), pTopicItem->m_strDisciplineCode, pTopicItem->m_strMsgKey);

	CAxADOCommand cmdADO(theApp.GetDataBase());
	cmdADO.SetText(strSQL);
	try
	{
		if ( cmdADO.Execute(CAxADOCommand::emTypeCmdText))
		{
			return TRUE;
		}
		return FALSE;

	}
	catch (CAxADOException &e)
	{
		AfxMessageBox(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}
}

BOOL CAxDBOperator::GetScheduleTree(CAxADODataBase* pDB, int iID, int iType, CString strLanguageCode, CAxADORecordSet& obRecordSet)
{
	if( !pDB )
		return FALSE;

	CAxADOCommand cmd(pDB, _T("Proc_GetScheduleTreeForInfo"));

	cmd.AddParameter( _T("@ID"), CAxADORecordSet::emDataTypeInteger, 
		CAxADOParameter::emParamInput, sizeof(int), iID);
	cmd.AddParameter( _T("@Type"), CAxADORecordSet::emDataTypeInteger, 
		CAxADOParameter::emParamInput, sizeof(int), iType);
	cmd.AddParameter( _T("@Option"), CAxADORecordSet::emDataTypeInteger, 
		CAxADOParameter::emParamInput, sizeof(int), 1);
	cmd.AddParameter( _T("@Option1"), CAxADORecordSet::emDataTypeInteger, 
		CAxADOParameter::emParamInput, sizeof(int), 0);

	cmd.AddParameter( _T("@LanguageCode"), CAxADORecordSet::emDataTypeChar, 
		CAxADOParameter::emParamInput, sizeof(char)*3, (_bstr_t)strLanguageCode);

	try
	{
		if( obRecordSet.Execute(&cmd) )
		{
			return TRUE;
		}

		return FALSE;

	}
	catch (CAxADOException &e)
	{
		AfxMessageBox(e.GetErrorMessage());
		return FALSE;
	}
	catch (...)
	{
		return FALSE;
	}
}