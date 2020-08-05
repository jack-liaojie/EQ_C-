/********************************************************************
	created:	2009/12/21
	created:	21:12:2009
	filename: 	TVSession.cpp

	author:		GRL
*********************************************************************/

#include "stdafx.h"
#include "TVSession.h"

IMPLEMENT_DYNAMIC(CTVSession, CTVNodeBase)

CTVSession::CTVSession()
{
	 m_emNodeType = emTypeSession;

}
CTVSession::~CTVSession()
{

}