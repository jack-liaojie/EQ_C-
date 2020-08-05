#pragma once

#define	NM_LINKCLICK	WM_APP + 0x200

class AX_OVRCOMMON_EXP CAxStaticLabel : public CStatic
{
public:
	CAxStaticLabel();
	virtual ~CAxStaticLabel();

// Construction
public:
	static enum LinkStyle { LinkNone, HyperLink, MailLink };
	static enum FlashType {None, Text, Background };
	static enum Type3D { Raised, Sunken};
	static enum BackFillMode { Normal, Gradient };

	virtual CAxStaticLabel& SetBkColor(COLORREF crBkgnd, COLORREF crBkgndHigh = 0, BackFillMode mode = Normal);
	virtual CAxStaticLabel& SetTextColor(COLORREF crText);
	virtual CAxStaticLabel& SetText(const CString& strText);
	virtual CAxStaticLabel& SetFontBold(BOOL bBold);
	virtual CAxStaticLabel& SetFontName(const CString& strFont, BYTE byCharSet = ANSI_CHARSET);
	virtual CAxStaticLabel& SetFontUnderline(BOOL bSet);
	virtual CAxStaticLabel& SetFontItalic(BOOL bSet);
	virtual CAxStaticLabel& SetFontSize(int nSize);
	virtual CAxStaticLabel& SetSunken(BOOL bSet);
	virtual CAxStaticLabel& SetBorder(BOOL bSet);
	virtual CAxStaticLabel& SetTransparent(BOOL bSet);
	virtual CAxStaticLabel& FlashText(BOOL bActivate);
	virtual CAxStaticLabel& FlashBackground(BOOL bActivate);
	virtual CAxStaticLabel& SetLink(BOOL bLink,BOOL bNotifyParent);
	virtual CAxStaticLabel& SetLinkCursor(HCURSOR hCursor);
	virtual CAxStaticLabel& SetFont3D(BOOL bSet,Type3D type=Raised);
	virtual CAxStaticLabel& SetRotationAngle(UINT nAngle,BOOL bRotation);
	virtual CAxStaticLabel& SetText3DHiliteColor(COLORREF cr3DHiliteColor);
	virtual CAxStaticLabel& SetFont(LOGFONT lf);
	virtual CAxStaticLabel& SetMailLink(BOOL bEnable, BOOL bNotifyParent);
	virtual CAxStaticLabel& SetHyperLink(const CString& sLink);

// Attributes
protected:
	void UpdateSurface();
	void ReconstructFont();
	void DrawGradientFill(CDC* pDC, CRect* pRect, COLORREF crStart, COLORREF crEnd, int nSegments);
protected:
	COLORREF		m_crText;
	COLORREF		m_cr3DHiliteColor;
	HBRUSH			m_hwndBrush;
	HBRUSH			m_hBackBrush;
	LOGFONT			m_lf;
	CFont			m_font;
	BOOL			m_bState;
	BOOL			m_bTimer;
	LinkStyle		m_Link;
	BOOL			m_bTransparent;
	BOOL			m_bFont3d;
	BOOL			m_bToolTips;
	BOOL			m_bNotifyParent;
	BOOL			m_bRotation;
	FlashType		m_Type;
	HCURSOR			m_hCursor;
	Type3D			m_3dType;
	BackFillMode	m_fillmode;
	COLORREF		m_crHiColor;
	COLORREF		m_crLoColor;
	CString			m_sLink;

	// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CLabel)
	protected:
	virtual void PreSubclassWindow();
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	//}}AFX_VIRTUAL

	// Generated message map functions
protected:
	//{{AFX_MSG(CLabel)
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg BOOL OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message);
	afx_msg void OnSysColorChange();
	afx_msg void OnPaint();
	afx_msg BOOL OnEraseBkgnd(CDC* pDC);
	//}}AFX_MSG

	DECLARE_MESSAGE_MAP()
};
