/********************************************************************
	created:	2009/12/25
	filename: 	TVObject.h

	author:		GRL
*********************************************************************/

#pragma once
#include "stdafx.h"

enum EMTVObjType
{
	emObjTypeUnkown = 0,
	emObjTypeTVNode,
	emObjTypeTVTable
};

// Basic class for TVTables and TVNodes
class CTVObject : public CObject
{
	DECLARE_DYNAMIC(CTVObject)

public:
	CTVObject()	;
	//CTVObject( const CTVObject& copy )	{ *this = copy; }
	//CTVObject& operator=( const CTVObject& copy )	{ m_emObjType = copy.m_emObjType; return *this; };
	virtual ~CTVObject();

public:
	EMTVObjType m_emObjType;
};