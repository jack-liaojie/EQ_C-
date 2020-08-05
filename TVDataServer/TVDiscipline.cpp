/********************************************************************
	created:	2009/12/21
	created:	21:12:2009
	filename: 	TVDiscipline.cpp

	author:		GRL
*********************************************************************/

#include "stdafx.h"
#include "TVDiscipline.h"

IMPLEMENT_DYNAMIC(CTVDiscipline, CTVNodeBase)

CTVDiscipline::CTVDiscipline()
{
	m_emNodeType = emTypeDiscipline;
}
CTVDiscipline::~CTVDiscipline()
{

}
