
#include "stdafx.h"
#include "TVEvent.h"

IMPLEMENT_DYNAMIC(CTVEvent, CTVNodeBase)

CTVEvent::CTVEvent()
{
	m_emNodeType = emTypeEvent;
}

CTVEvent::~CTVEvent()
{

}
