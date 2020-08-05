#include "StdAfx.h"
#include "TVObject.h"

IMPLEMENT_DYNAMIC(CTVObject, CObject)

CTVObject::CTVObject(void)
{
	m_emObjType = emObjTypeUnkown;
}

CTVObject::~CTVObject(void)
{
}
