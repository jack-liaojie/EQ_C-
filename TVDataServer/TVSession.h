/********************************************************************
	created:	2009/12/17
	filename: 	TVSession.h

	author:		GRL
*********************************************************************/

#pragma once

#include "TVNodeBase.h"

class CTVSession : public CTVNodeBase
{
	DECLARE_DYNAMIC(CTVSession)

public:
	CTVSession();
	~CTVSession();

private:

	CTVSession& operator= (CTVSession &copy)
	{
		m_strName = copy.m_strName;
		m_strPath = copy.m_strPath;

		return *this;
	};

	int nt;
};
