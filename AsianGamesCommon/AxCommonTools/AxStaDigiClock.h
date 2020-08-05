#pragma once

#include <afxtempl.h>

#define	BLACK			RGB( 000, 000, 000 )
#define	DARKBLUE		RGB( 000, 000, 128 )
#define	DARKGREEN		RGB( 000, 064, 000 )
#define	DARKCYAN		RGB( 000, 064, 064 )
#define	DARKRED			RGB( 064, 000, 000 )
#define	DARKMAGENTA		RGB( 128, 000, 128 )
#define	BROWN			RGB( 128, 128, 000 )
#define	DARKGRAY		RGB( 128, 128, 128 )

#define	LIGHTGRAY		RGB( 192, 192, 192 )
#define	LIGHTBLUE		RGB( 000, 000, 255 )
#define	LIGHTGREEN		RGB( 000, 255, 000 )
#define	LIGHTCYAN		RGB( 000, 255, 255 )
#define	LIGHTRED		RGB( 255, 000, 000 )
#define	LIGHTMAGENTA	RGB( 255, 000, 255 )
#define	YELLOW			RGB( 255, 255, 000 )
#define	WHITE			RGB( 255, 255, 255 )

// CRect clAxs with double precision for accurate drawing.
class AX_OVRCOMMON_EXP CAxDoubleRect
{
public:
	void SetRect(double x1, double y1, double x2, double y2){ left = x1; top = y1; right = x2; bottom = y2;}
	double Width() const{return right - left;}
	double Height() const{return bottom - top;}
	void SetRectEmpty(){left = top = right = bottom = 0.0;}
public:
	double left, top, right, bottom; 
};

class AX_OVRCOMMON_EXP CAxDigiSegment
{
public:
	CAxDigiSegment();
	CAxDigiSegment(const CAxDigiSegment& Segment);
	~CAxDigiSegment();
	void DefPoints(const POINT* lpPoints, const BYTE* lpTypes, int nCount);
	void Draw(CDC *pDC,const CAxDoubleRect &DrawPlace, int iWidth) const;
	void FreeSegment();
	CAxDigiSegment operator=(const CAxDigiSegment &Segment);

	// Implementation
public:
	CPoint	  *	m_paPoints;			// array with point
	BYTE	  *	m_paTypes;			// array with connecting info for point
	int			m_nCount;			// number of points
};

typedef CArray< CAxDigiSegment, CAxDigiSegment> DSegmentArray;

class AX_OVRCOMMON_EXP CAxDigiChar
{
	// Construction
public:
	CAxDigiChar();
	CAxDigiChar(const CAxDigiChar& DigiChar);

	//Attributes:
public:
	virtual void SetElementData(WORD wSegmData, int iDispStyle);
	void	Draw(CDC *pDC, const CAxDoubleRect &DrawPlace, CPen *pOffPen, CPen *pOnPen,
				 CBrush *pOffBrush, CBrush *pOnBrush, CRgn* region = NULL);
	void SetColor(COLORREF OffColor, COLORREF OnColor);
	int GetNormWidth() const;
	CAxDigiChar operator=(const CAxDigiChar &DigiChar);
	COLORREF GetColor(void) const { return m_OnColor; }

protected:
	int				m_Width;		// Width of character
	WORD			m_wSegmData;	// segments to highlight (binairy encoded)
	DSegmentArray	m_SegmentArray;	// Character is array of segments
	int				m_NSegments;	// Number of segments
	COLORREF		m_OffColor;		// Color of segment when off
	COLORREF		m_OnColor;		// Color of segment when on
	BOOL			m_bNoOff;		// Do not draw segments that are off
};

typedef CArray<CAxDigiChar, CAxDigiChar> DigiCharArray;

/////////////////////////////////////////////////////////////////////////////
// CAxStaDigiClock clAxs
class AX_OVRCOMMON_EXP CAxStaDigiClock: public CStatic
{
	// Construction
public:
	CAxStaDigiClock();
	virtual ~CAxStaDigiClock();

	// Attributes
public:
	enum
	{
		DS_SMOOTH	=  1,	// Pioneer kind of characters
		DS_STYLE14	=  2,	// use allways 14 segment display.
		DS_SZ_PROP	=  4,	// size proportional(default)
		DS_NO_OFF	=  8,	// Don't draw the off segments
		DS_SOFT		= 16	// ambient bleeding to background
	};

protected:
	CString			m_strText;			// Current text
	BOOL			m_Modified;			// text is dirty
	DigiCharArray	m_CharArray;		// digistatic is an array of characters
	COLORREF		m_OffColor;			// Color of segment when off
	COLORREF		m_OnColor;			// Color of segment when on
	COLORREF		m_BackColor;		// Background color
	DWORD			m_DispStyle;		// DS_... may be bitwise OR-red
	BOOL			m_bImmediateUpdate;	// Enable/Disable immediate repaint
	BOOL			m_bTransparent;		// Enable/Disable transparent background

protected:
	//{{AFX_MSG(CDigiStatic)
	afx_msg void OnPaint();
	afx_msg BOOL OnErAxeBkgnd(CDC* pDC);
	//}}AFX_MSG

	DECLARE_MESSAGE_MAP()

public:
	void		SetText(LPCTSTR lpszText);
	CString		GetText();
	void		Format(LPCTSTR lpszFormat, ...);
	void		Format(UINT nFormatID, ...);
	void		SetColor(COLORREF OffColor, COLORREF OnColor);
	COLORREF	GetOnColor() const {return m_OnColor;}
	COLORREF	GetOffColor() const {return m_OffColor;}
	void		SetDrawImmediately(BOOL Enable = TRUE);
	COLORREF	SetBkColor(COLORREF BackColor = BLACK);
	void		SetTransparent(BOOL bSet = TRUE);
	BOOL		ModifyDigiStyle(DWORD dwRemove, DWORD dwAdd);

	// Generated message map functions
protected:
	CAxDigiChar * DefineChar(TCHAR cChar);
	void		BuildString();
	void DoInvalidate();
};

