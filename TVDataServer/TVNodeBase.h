
/********************************************************************
	created:	2009/12/22
	filename: 	TVNodeBase.h

	author:		GRL
*********************************************************************/

#pragma once

#include "TVTable.h"
#include "TVTableSessionSts.h"
#include "TVTableEventGrd.h"

enum EMTVNodeType
{
	emTypeUnknown = 0,
	emTypeDiscipline,
	emTypeSession,
	emTypeCourt,
	emTypeEvent

};
CString NodeType2String(EMTVNodeType eNodeType);
EMTVNodeType Str2NodeType(CString strNodeType);

class CTVNodeBase;
typedef CArray<CTVNodeBase*, CTVNodeBase*>	AryNodes;

class CTVNodeBase : public CTVObject
{
	DECLARE_DYNAMIC(CTVNodeBase)

public:
	CTVNodeBase();
	CTVNodeBase( const CTVNodeBase& copy ) {*this = copy;}
	CTVNodeBase& operator=( const CTVNodeBase& copy );

	virtual ~CTVNodeBase();

public:
	CString			m_strName;
	CString			m_strPath;
	CString			m_strID;		// Used for MatchID, SessionID, DisciplineID
	EMTVNodeType	m_emNodeType;

	CTVTableManager	m_ChildTables;

	HTREEITEM		m_hTreeCtrlItem; // Used for display the node on tree control
	CTVNodeBase*	m_pParentNode;

private:
	AryNodes		m_aryChildNodes;

public:

	// Child nodes operation
	CTVNodeBase *GetChildNode(int nIndex);
	void AddChildNode(CTVNodeBase *pNodeChild);
	int GetChildNodesCount();
	int FindChildIndex(CString strIDOrChildName, BOOL bFindID = TRUE); // bFindID= FALSE, then Find the Node by it's Name
	int FindChildIndex(CTVNodeBase *pNodeChild);
	void InsertChildNode(int nIndex, CTVNodeBase *pNodeChild);
	void DelChildNode(int nIndex);
	void RemoveAllChildNodes();

	// 
	void ClearAllData();

};


