/////////////////////////////////////////////////////////////////////////////
// AsCoolGridTitletip.h : header file
// MFC Grid Control - cell titletips
#pragma once

#define TITLETIP_CLASSNAME _T("GridTitleTip")

/////////////////////////////////////////////////////////////////////////////
// CAsCoolGridTitleTip window

class AX_OVRCOMMON_EXP CAsCoolGridTitleTip : public CWnd
{
	// Construction
public:
	CAsCoolGridTitleTip();
	virtual ~CAsCoolGridTitleTip();
	virtual BOOL Create( CWnd *pParentWnd);

	// Attributes
public:
	void SetParentWnd(CWnd* pParentWnd)  { m_pParentWnd = pParentWnd; }
	CWnd* GetParentWnd()                 { return m_pParentWnd;       }

	// Operations
public:
	void Show(CRect rtCellRect, CString strCellText, const LOGFONT* lpLogFont,
		COLORREF crTextClr = CLR_DEFAULT, COLORREF crBackClr = CLR_DEFAULT);
	void Hide();

	// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CTitleTip)
public:
	virtual BOOL DestroyWindow();
	//}}AFX_VIRTUAL

	// Implementation
protected:
	CWnd  *m_pParentWnd;
	BOOL   m_bCreated;
	BOOL   m_bTimeToShow;
	int	   m_nTimer;

	// Generated message map functions
protected:
	//{{AFX_MSG(CTitleTip)
	afx_msg void OnMouseMove(UINT nFlags, CPoint point);
	afx_msg void OnTimer(UINT nIDEvent);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};
