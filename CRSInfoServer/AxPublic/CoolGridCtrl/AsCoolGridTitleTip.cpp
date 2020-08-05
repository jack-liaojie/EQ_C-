////////////////////////////////////////////////////////////////////////////
// TitleTip.cpp : implementation file
// Based on code by Zafir Anjum
/////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "AsCoolGridctrl.h"
#include "AsCoolGridTitleTip.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CTitleTip

CAsCoolGridTitleTip::CAsCoolGridTitleTip()
{
	// Register the window class if it has not already been registered.
	WNDCLASS wndcls;

	//HINSTANCE hInst = AfxGetInstanceHandle(); // When the Grid is Global variable, this function can cause ASSERT, because the AfxWinInit() has not been called. ( Guan changed )
	HINSTANCE hInst = ::GetModuleHandle(NULL);

	if(!(::GetClassInfo(hInst, TITLETIP_CLASSNAME, &wndcls)))
	{
		// otherwise we need to register a new class
		wndcls.style			= CS_SAVEBITS;
		wndcls.lpfnWndProc		= ::DefWindowProc;
		wndcls.cbClsExtra		= wndcls.cbWndExtra = 0;
		wndcls.hInstance		= hInst;
		wndcls.hIcon			= NULL;
		wndcls.hCursor			= LoadCursor( hInst, IDC_ARROW );
		wndcls.hbrBackground	= (HBRUSH)(COLOR_INFOBK +1);
		wndcls.lpszMenuName		= NULL;
		wndcls.lpszClassName	= TITLETIP_CLASSNAME;

		if (!AfxRegisterClass(&wndcls))
			AfxThrowResourceException();
	}
	m_nTimer			= 0;
	m_bTimeToShow		= FALSE;
	m_bCreated          = FALSE;
	m_pParentWnd        = NULL;
}

CAsCoolGridTitleTip::~CAsCoolGridTitleTip()
{
}


BEGIN_MESSAGE_MAP(CAsCoolGridTitleTip, CWnd)
	//{{AFX_MSG_MAP(CAsCoolGridTitleTip)
	ON_WM_MOUSEMOVE()
	ON_WM_TIMER()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CAsCoolGridTitleTip message handlers

BOOL CAsCoolGridTitleTip::Create(CWnd * pParentWnd)
{
	ASSERT_VALID(pParentWnd);

	// Already created?
	if (m_bCreated)
		return TRUE;

	DWORD dwStyle = WS_BORDER | WS_POPUP; 
	DWORD dwExStyle = WS_EX_TOOLWINDOW | WS_EX_TOPMOST;
	m_pParentWnd = pParentWnd;

	m_bCreated = CreateEx(dwExStyle, TITLETIP_CLASSNAME, NULL, dwStyle, 
		CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, 
		NULL, NULL, NULL );

	return m_bCreated;
}

BOOL CAsCoolGridTitleTip::DestroyWindow() 
{
	m_bCreated = FALSE;	
	return CWnd::DestroyWindow();
}

// Show 		 - Show the titletip if needed
// rtCell		 - The Current hovering Cell Rect 
// lpszTitleText - The text to be displayed
void CAsCoolGridTitleTip::Show( CRect rtCellRect, CString strCellText, const LOGFONT* lpLogFont,
							   COLORREF crTextClr /* CLR_DEFAULT */,
							   COLORREF crBackClr /* CLR_DEFAULT */)
{
	if (rtCellRect.IsRectEmpty() || strCellText.IsEmpty() || !lpLogFont || GetFocus() != m_pParentWnd)
	{
		return;
	}
	if (!IsWindow(m_hWnd))
		Create(m_pParentWnd);
	ASSERT( ::IsWindow( GetSafeHwnd() ) );

	// Whether current mouse position is in the available area (offset = 4)
	int nOffset = 4;
	CPoint CurMousePoint;
	GetCursorPos(&CurMousePoint);
	m_pParentWnd->ScreenToClient(&CurMousePoint);
	CRect rcParentClient;
	m_pParentWnd->GetClientRect(&rcParentClient);
	rcParentClient.DeflateRect(nOffset, nOffset);
	CRect rectDeflate = rtCellRect;
	rectDeflate.DeflateRect(nOffset, nOffset);
	if (!rectDeflate.PtInRect(CurMousePoint) || !rcParentClient.PtInRect(CurMousePoint))
	{
		Hide(); 
		return;
	}
	else if (IsWindowVisible())
	{	
		return;
	}

	// Determine the size(szTipWnd) and the position(ptDisplayPos) of the tip window
	CClientDC dc(this);
	CFont font, *pOldFont = NULL;
	if (lpLogFont)
	{
		font.CreateFontIndirect(lpLogFont);
		pOldFont = dc.SelectObject( &font );
	}
	CSize szTipWnd = dc.GetTextExtent(strCellText + _T("   ")); // Width
	if ( szTipWnd.cx < rtCellRect.Width() && szTipWnd.cy < rtCellRect.Height())
	{
		return;
	}
	szTipWnd.cy = (szTipWnd.cy+6) > rtCellRect.Height() ? (szTipWnd.cy+6) : rtCellRect.Height(); // Height
	int nLeftPos = rtCellRect.right > rcParentClient.right+nOffset ? rcParentClient.right+nOffset : rtCellRect.right; // Ensure left side of the tip in the parent GridCtrl
	CPoint ptDisplayPos(nLeftPos, rtCellRect.top);   

	// Start timer
	if (m_nTimer == 0)
	{
		m_nTimer = SetTimer(1, 1000, NULL);
	}

	// Show the titletip
	if (m_bTimeToShow)
	{	
		m_pParentWnd->ClientToScreen( &ptDisplayPos );		
		SetWindowPos( &wndTop, ptDisplayPos.x, ptDisplayPos.y, szTipWnd.cx, szTipWnd.cy, SWP_SHOWWINDOW|SWP_NOACTIVATE );

		// FNA - handle colors correctly
		if (crBackClr != CLR_DEFAULT)
		{
			CBrush backBrush(crBackClr);
			CBrush* pOldBrush = dc.SelectObject(&backBrush);
			CRect rect;
			dc.GetClipBox(&rect);     // Erase the area needed 
			dc.PatBlt(rect.left, rect.top, rect.Width(), rect.Height(),  PATCOPY);
			dc.SelectObject(pOldBrush);
		}
		// Set color
		if (crTextClr != CLR_DEFAULT)//FNA
			dc.SetTextColor(crTextClr);//FA

		dc.SetBkMode( TRANSPARENT );
		dc.TextOut( 0, 0, strCellText );

		// Close timer
		KillTimer(m_nTimer);
		m_nTimer = 0;
		m_bTimeToShow = FALSE;
	}    

	dc.SelectObject( pOldFont );
}

void CAsCoolGridTitleTip::Hide()
{
	if (!::IsWindow(GetSafeHwnd()))
		return;
	ShowWindow( SW_HIDE );

	if (m_nTimer != 0)
	{
		KillTimer(m_nTimer);
		m_nTimer = 0;
	}
	m_bTimeToShow = FALSE;
}

void CAsCoolGridTitleTip::OnMouseMove(UINT nFlags, CPoint point) 
{
	Hide();
}

void CAsCoolGridTitleTip::OnTimer(UINT nIDEvent)
{
	if (nIDEvent == 1)
	{
		m_bTimeToShow = TRUE;

		//  Trigger ShowWindow
		CPoint CurMousePoint;
		GetCursorPos(&CurMousePoint);
		if (m_pParentWnd->GetSafeHwnd())
		{		
			m_pParentWnd->ScreenToClient(&CurMousePoint);
			m_pParentWnd->SendMessage(WM_MOUSEMOVE, NULL, MAKELONG(CurMousePoint.x, CurMousePoint.y));
		}
		if (m_nTimer != 0)
		{
			KillTimer(m_nTimer);
			m_nTimer = 0;
		}
	}
	CWnd::OnTimer(nIDEvent);
}
