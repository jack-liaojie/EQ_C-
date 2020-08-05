
#pragma once

#include "TVNodeBase.h"

class CTVEvent : public CTVNodeBase
{
	DECLARE_DYNAMIC(CTVEvent)

public:
	CTVEvent();
	virtual ~CTVEvent();
	
	CString m_strStatus;
};