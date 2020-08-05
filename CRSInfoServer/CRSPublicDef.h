/********************************************************************
	created:	2010/12/16
	filename: 	CRSPublicDef.h

	author:		GRL
*********************************************************************/

#pragma once

#include "stdafx.h"

#define STR_TYPE_UNKNOWN				_T("Unknown")
#define STR_NODETYPE_SPORT				_T("Sport")
#define STR_NODETYPE_DISCIPLINE			_T("Discipline")
#define STR_NODETYPE_EVENT				_T("Event")
#define STR_NODETYPE_PHASE				_T("Phase")
#define STR_NODETYPE_MATCH				_T("Match")

enum EMCRSNodeType
{
	emTypeUnknown = -4,
	emTypeSport,
	emTypeDiscipline,
	emTypeEvent,
	emTypePhase,
	emTypeMatch
};

//////////////////////////////////////////////////////////////////////////
// enum Type exchange to string tools
static CString NodeType2String(EMCRSNodeType eNodeType)
{
	CString strType;

	switch (eNodeType)
	{
	case emTypeSport:
		strType = STR_NODETYPE_SPORT;
		break;
	case emTypeDiscipline:
		strType = STR_NODETYPE_DISCIPLINE;
		break;
	case emTypeEvent:
		strType = STR_NODETYPE_EVENT;
		break;
	case emTypePhase:
		strType = STR_NODETYPE_PHASE;
		break;
	case emTypeMatch:
		strType = STR_NODETYPE_MATCH;
		break;
	default:
		strType = STR_TYPE_UNKNOWN;
	}

	return strType;
}

static EMCRSNodeType Str2NodeType(CString strNodeType)
{
	EMCRSNodeType eType;

	if (strNodeType == STR_NODETYPE_SPORT)				eType = emTypeSport;
	else if (strNodeType == STR_NODETYPE_DISCIPLINE)	eType = emTypeDiscipline;
	else if (strNodeType == STR_NODETYPE_EVENT)			eType = emTypeEvent;
	else if (strNodeType == STR_NODETYPE_PHASE)			eType = emTypePhase;
	else if (strNodeType == STR_NODETYPE_MATCH)			eType = emTypeMatch;
	else eType = emTypeUnknown;

	return eType;
}

struct SCRSTreeNodeInfo  // 树控件节点定义
{
	CString strNodeKey;
	CString strFatherNodeKey;
	CString strNodeStatusName;
	CString strNodeName;
	CString strNodeShortName;
	CString strNodeLongName;

	CString strDisciplineCode;
	CString strEventCode;
	CString strPhaseCode;
	CString strMatchCode;
	CString strGenderCode;
	CString strVenueCode;

	int		iNodeType;  // -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase，1表示Match

	int		iSportID;
	int		iDisciplineID;
	int		iEventID;
	int		iPhaseID;
	int		iFatherPhaseID;
	int		iMatchID;
	int		iSessionID;
	int		iCourtID;
	int		iStatusID;
};

typedef CArray<SCRSTreeNodeInfo*, SCRSTreeNodeInfo*> PAryTreeNodeInfo;