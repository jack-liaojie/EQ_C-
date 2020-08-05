// GridDropTarget.cpp : implementation file
// MFC Grid Control - Drag/Drop target implementation

#include "stdafx.h"
#include "AsCoolGridCtrl.h"
#include "AsCoolGridDropTarget.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAsCoolGridDropTarget
CAsCoolGridDropTarget::CAsCoolGridDropTarget()
{
    m_pGridCtrl = NULL;
    m_bRegistered = FALSE;
}

CAsCoolGridDropTarget::~CAsCoolGridDropTarget()
{
}

// Overloaded Register() function performs the normal COleDropTarget::Register
// but also serves to connect this COleDropTarget with the parent grid control,
// where all drop messages will ultimately be forwarded.
BOOL CAsCoolGridDropTarget::Register(CAsCoolGridCtrl *pGridCtrl)
{
    if (m_bRegistered)
        return FALSE;

    // Stop re-entry problems
    static BOOL bInProcedure = FALSE;
    if (bInProcedure)
        return FALSE;
    bInProcedure = TRUE;

    ASSERT(pGridCtrl->IsKindOf(RUNTIME_CLASS(CAsCoolGridCtrl)));
    ASSERT(pGridCtrl);

    if (!pGridCtrl || !pGridCtrl->IsKindOf(RUNTIME_CLASS(CAsCoolGridCtrl)))
    {
        bInProcedure = FALSE;
        return FALSE;
    }

    m_pGridCtrl = pGridCtrl;

    m_bRegistered = COleDropTarget::Register(pGridCtrl);

    bInProcedure = FALSE;
    return m_bRegistered;
}

void CAsCoolGridDropTarget::Revoke()
{
    m_bRegistered = FALSE;
    COleDropTarget::Revoke();
}

BEGIN_MESSAGE_MAP(CAsCoolGridDropTarget, COleDropTarget)
    //{{AFX_MSG_MAP(CGridDropTarget)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CGridDropTarget message handlers

DROPEFFECT CAsCoolGridDropTarget::OnDragScroll(CWnd* pWnd, DWORD dwKeyState, CPoint /*point*/)
{
//    TRACE("In CGridDropTarget::OnDragScroll\n");
    if (pWnd->GetSafeHwnd() == m_pGridCtrl->GetSafeHwnd())
    {
        if (dwKeyState & MK_CONTROL)
            return DROPEFFECT_COPY;
        else
            return DROPEFFECT_MOVE;
    } else
        return DROPEFFECT_NONE;
}

DROPEFFECT CAsCoolGridDropTarget::OnDragEnter(CWnd* pWnd, COleDataObject* pDataObject, 
                                        DWORD dwKeyState, CPoint point)
{
    TRACE(_T("In CGridDropTarget::OnDragEnter\n"));
    ASSERT(m_pGridCtrl);

    if (pWnd->GetSafeHwnd() == m_pGridCtrl->GetSafeHwnd())
        return m_pGridCtrl->OnDragEnter(pDataObject, dwKeyState, point);
    else
        return DROPEFFECT_NONE;
}

void CAsCoolGridDropTarget::OnDragLeave(CWnd* pWnd)
{
    TRACE(_T("In CGridDropTarget::OnDragLeave\n"));
    ASSERT(m_pGridCtrl);

    if (pWnd->GetSafeHwnd() == m_pGridCtrl->GetSafeHwnd())
        m_pGridCtrl->OnDragLeave();
}

DROPEFFECT CAsCoolGridDropTarget::OnDragOver(CWnd* pWnd, COleDataObject* pDataObject, 
                                       DWORD dwKeyState, CPoint point)
{
//    TRACE("In CGridDropTarget::OnDragOver\n");
    ASSERT(m_pGridCtrl);

    if (pWnd->GetSafeHwnd() == m_pGridCtrl->GetSafeHwnd())
        return m_pGridCtrl->OnDragOver(pDataObject, dwKeyState, point);
    else
        return DROPEFFECT_NONE;
}

BOOL CAsCoolGridDropTarget::OnDrop(CWnd* pWnd, COleDataObject* pDataObject,
                             DROPEFFECT dropEffect, CPoint point)
{
    TRACE(_T("In CGridDropTarget::OnDrop\n"));
    ASSERT(m_pGridCtrl);

    if (pWnd->GetSafeHwnd() == m_pGridCtrl->GetSafeHwnd())
        return m_pGridCtrl->OnDrop(pDataObject, dropEffect, point);
    else
        return FALSE;
}

