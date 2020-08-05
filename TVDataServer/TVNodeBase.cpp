#include "StdAfx.h"
#include "TVNodeBase.h"


IMPLEMENT_DYNAMIC(CTVNodeBase, CTVObject)

CTVNodeBase::CTVNodeBase(void)
{
	m_emObjType = emObjTypeTVNode;

	ClearAllData();
}

CTVNodeBase& CTVNodeBase::operator= (const CTVNodeBase& copy)
{
	ClearAllData();	

	m_strName = copy.m_strName;
	m_strPath = copy.m_strPath;
	m_strID = copy.m_strID;

	m_emObjType = copy.m_emObjType;
	m_emNodeType = copy.m_emNodeType;

	return *this;
}

CTVNodeBase::~CTVNodeBase(void)
{
	ClearAllData();
}

void CTVNodeBase::ClearAllData()
{
	RemoveAllChildNodes();
	m_ChildTables.DeleteAllTable();

	m_strID.Empty();
	m_strName.Empty();
	m_strPath.Empty();

	m_emObjType = emObjTypeTVNode;
	m_emNodeType = emTypeUnknown;
	m_pParentNode = NULL;
	m_hTreeCtrlItem = NULL;
}

//////////////////////////////////////////////////////////////////////////
// Child Nodes operation
CTVNodeBase* CTVNodeBase::GetChildNode(int nIndex)
{
	if (nIndex < 0 || nIndex >= GetChildNodesCount())
		return NULL;
	return m_aryChildNodes.GetAt(nIndex);
}
void CTVNodeBase::AddChildNode(CTVNodeBase *pNodeChild)
{
	if (pNodeChild)
	{
		m_aryChildNodes.Add(pNodeChild);
	}
}
inline int CTVNodeBase::GetChildNodesCount()
{
	return m_aryChildNodes.GetCount();
}
int CTVNodeBase::FindChildIndex(CString strIDOrChildName, BOOL bFindID)
{
	int nChildCount = m_aryChildNodes.GetCount();
	for (int i=0; i < nChildCount; i++)
	{
		CTVNodeBase *pNode = m_aryChildNodes.GetAt(i);
		if (!pNode)
			continue;

		if (strIDOrChildName == (bFindID ? pNode->m_strID : pNode->m_strName) )
			return i;
	}

	return -1;
}
int CTVNodeBase::FindChildIndex(CTVNodeBase *pNodeChild)
{
	int nChildCount = m_aryChildNodes.GetCount();
	for (int i=0; i < nChildCount; i++)
	{
		CTVNodeBase *pNode = m_aryChildNodes.GetAt(i);
		if (pNode == pNodeChild)
			return i;
	}

	return -1;	
}
void CTVNodeBase::InsertChildNode(int nIndex, CTVNodeBase *pNodeChild)
{
	if (nIndex < 0 || nIndex >= GetChildNodesCount())
		return;

	m_aryChildNodes.InsertAt(nIndex, pNodeChild);
}
void CTVNodeBase::DelChildNode(int nIndex)
{
	if (nIndex < 0 || nIndex >= GetChildNodesCount())
		return;

	delete m_aryChildNodes[nIndex];
	m_aryChildNodes.RemoveAt(nIndex);
}
void CTVNodeBase::RemoveAllChildNodes()
{
	int nCount = m_aryChildNodes.GetCount();
	for (int i=0; i < nCount; i++)
	{
		delete m_aryChildNodes[i];
	}

	m_aryChildNodes.RemoveAll();
}

//////////////////////////////////////////////////////////////////////////
// enum Type exchange to string tools
CString NodeType2String(EMTVNodeType eNodeType)
{
	CString strType;

	switch (eNodeType)
	{
	case emTypeDiscipline:
		strType = STR_NODETYPE_DISCIPLINE;
		break;
	case emTypeSession:
		strType = STR_NODETYPE_SESSION;
		break;
	case emTypeEvent:
		strType = STR_NODETYPE_EVENT;
		break;
	case emTypeCourt:
		strType = STR_NODETYPE_COURT;
		break;
	case emTypeUnknown:
		strType = STR_TYPE_UNKNOWN;
		break;
	default:
		strType = STR_TYPE_UNKNOWN;
	}

	return strType;
}

EMTVNodeType Str2NodeType(CString strNodeType)
{
	EMTVNodeType eType;

	if (strNodeType == STR_NODETYPE_DISCIPLINE)			eType = emTypeDiscipline;
	else if (strNodeType == STR_NODETYPE_SESSION)		eType = emTypeSession;
	else if (strNodeType == STR_NODETYPE_EVENT)			eType = emTypeEvent;
	else if (strNodeType == STR_NODETYPE_COURT)			eType = emTypeCourt;
	else eType = emTypeUnknown;

	return eType;
}