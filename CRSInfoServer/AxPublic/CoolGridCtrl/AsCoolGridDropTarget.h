//////////////////////////////////////////////////////////////////////
// AsCoolGridDropTarget.h : header file
// MFC Grid Control - Drag/Drop target implementation

#pragma once

#include <afxole.h>

class CAsCoolGridCtrl;

/////////////////////////////////////////////////////////////////////////////
// CAsCoolGridDropTarget command target

class  CAsCoolGridDropTarget : public COleDropTarget
{
public:
    CAsCoolGridDropTarget();
    virtual ~CAsCoolGridDropTarget();

// Attributes
public:
    CAsCoolGridCtrl* m_pGridCtrl;
    BOOL       m_bRegistered;

// Operations
public:
    BOOL Register(CAsCoolGridCtrl *pGridCtrl);
    virtual void Revoke();

    BOOL        OnDrop(CWnd* pWnd, COleDataObject* pDataObject, DROPEFFECT dropEffect, CPoint point);
    DROPEFFECT  OnDragEnter(CWnd* pWnd, COleDataObject* pDataObject, DWORD dwKeyState, CPoint point);
    void        OnDragLeave(CWnd* pWnd);
    DROPEFFECT  OnDragOver(CWnd* pWnd, COleDataObject* pDataObject, DWORD dwKeyState, CPoint point);
    DROPEFFECT  OnDragScroll(CWnd* pWnd, DWORD dwKeyState, CPoint point);

// Overrides
    // ClassWizard generated virtual function overrides
    //{{AFX_VIRTUAL(CGridDropTarget)
    //}}AFX_VIRTUAL

// Implementation
protected:
    // Generated message map functions
    //{{AFX_MSG(CGridDropTarget)
    //}}AFX_MSG

    DECLARE_MESSAGE_MAP()
};
