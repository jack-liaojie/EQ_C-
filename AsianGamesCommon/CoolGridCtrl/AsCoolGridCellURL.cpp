// AsCoolGridCellURL.cpp: implementation of the CAsCoolGridCellURL class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "AsCoolGridCellURL.h"
#include "AsCoolGridCtrl.h"

IMPLEMENT_DYNCREATE(CAsCoolGridCellURL, CAsCoolGridCell)

#ifndef _WIN32_WCE
HCURSOR CAsCoolGridCellURL::g_hLinkCursor = NULL;
#endif

#pragma warning(disable: 4267)

// Possible prefixes that indicate a hyperlink
URLStruct CAsCoolGridCellURL::g_szURIprefixes[] = { 
    { _T("www."),    _tcslen(_T("www."))    },
    { _T("http:"),   _tcslen(_T("http:"))   },
    { _T("mailto:"), _tcslen(_T("mailto:")) },
    { _T("ftp:"),    _tcslen(_T("ftp:"))    },
    { _T("https:"),  _tcslen(_T("https:"))  },
    { _T("news:"),   _tcslen(_T("news:"))   },
    { _T("gopher:"), _tcslen(_T("gopher:")) },
    { _T("telnet:"), _tcslen(_T("telnet:")) },
    { _T("url:"),    _tcslen(_T("url:"))    },
    { _T("file:"),   _tcslen(_T("file:"))   },
    { _T("ftp."),    _tcslen(_T("ftp."))    }
};

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CAsCoolGridCellURL::CAsCoolGridCellURL()
{
#ifndef _WIN32_WCE
    g_hLinkCursor = GetHandCursor();
#endif
	m_bLaunchUrl = TRUE;
	m_clrUrl = GetSysColor(COLOR_HIGHLIGHT);
}

CAsCoolGridCellURL::~CAsCoolGridCellURL()
{
}

BOOL CAsCoolGridCellURL::Draw(CDC* pDC, int nRow, int nCol, CRect rect, BOOL bEraseBkgnd)
{
	// If url is present then change text color
	if (HasUrl(GetText()))
		SetTextClr(m_clrUrl);

    // Good a place as any to store the bounds of the rect
    m_Rect = rect;

    return CAsCoolGridCell::Draw(pDC, nRow, nCol, rect, bEraseBkgnd);
}

#pragma warning(disable:4100)
BOOL CAsCoolGridCellURL::Edit(int nRow, int nCol, CRect rect, CPoint point, UINT nID, UINT nChar)
{
    return FALSE;
}
#pragma warning(default:4100)

void CAsCoolGridCellURL::OnClick(CPoint PointCellRelative)
{
#ifndef _WIN32_WCE
    CString strURL;
    if (GetAutoLaunchUrl() && OverURL(PointCellRelative, strURL))
		ShellExecute(NULL, _T("open"), strURL, NULL,NULL, SW_SHOW);
#endif
}

// Return TRUE if you set the cursor
BOOL CAsCoolGridCellURL::OnSetCursor()
{
#ifndef _WIN32_WCE
    CString strURL;
    CPoint pt(GetMessagePos());
    GetGrid()->ScreenToClient(&pt);
    pt = pt - m_Rect.TopLeft();

    if (OverURL(pt, strURL))
    {
        SetCursor(g_hLinkCursor);
		return TRUE;
	}
	else
#endif
		return CAsCoolGridCell::OnSetCursor();
}

#ifndef _WIN32_WCE
HCURSOR CAsCoolGridCellURL::GetHandCursor()
{
	if (g_hLinkCursor == NULL)		// No cursor handle - load our own
	{
        // Get the windows directory
		CString strWndDir;
		GetWindowsDirectory(strWndDir.GetBuffer(MAX_PATH), MAX_PATH);
		strWndDir.ReleaseBuffer();

		strWndDir += _T("\\winhlp32.exe");
		// This retrieves cursor #106 from winhlp32.exe, which is a hand pointer
		HMODULE hModule = LoadLibrary(strWndDir);
		if( hModule )
		{
			HCURSOR hHandCursor = ::LoadCursor(hModule, MAKEINTRESOURCE(106));
			if( hHandCursor )
			{
				g_hLinkCursor = CopyCursor(hHandCursor);
			}
		}
		FreeLibrary(hModule);
	}

	return g_hLinkCursor;
}
#endif

////////////////////////////////////////////////////////////////////////////////////////////
// Helper functions

BOOL CAsCoolGridCellURL::HasUrl(CString str)
{
    int nNumPrefixes = sizeof(g_szURIprefixes) / sizeof(g_szURIprefixes[0]);
    for (int i = 0; i < nNumPrefixes; i++)
        //if (str.Left(g_szURIprefixes[i].nLength) == g_szURIprefixes[i].szURLPrefix)
        if (str.Find(g_szURIprefixes[i].szURLPrefix) >= 0)
            return TRUE;

    return FALSE;
}

// here we figure out if we are over a URL or not
BOOL CAsCoolGridCellURL::OverURL(CPoint& pt, CString& strURL)
{
    //TRACE2("Checking point %d,%d\n",pt.x,pt.y);

	BOOL bOverURL = FALSE;
	CSize size = GetTextExtent(GetText());

	// Add left of cell so we know if we clicked on text or not
	pt.x += m_Rect.left;
	CPoint center = m_Rect.CenterPoint();

	if ((m_nFormat & DT_RIGHT) && pt.x >= (m_Rect.right - size.cx))
	{
		bOverURL = TRUE;
	}	
	else if ((m_nFormat & DT_CENTER) && 
             ((center.x - (size.cx/2)) <= pt.x) && (pt.x <= (center.x + (size.cx/2))) )
	{
		bOverURL = TRUE;
	}
	else if (pt.x <= (size.cx + m_Rect.left))
	{
		bOverURL = TRUE;
	}

    if (!bOverURL)
        return FALSE;

    // We are over text - but are we over a URL?
	bOverURL = FALSE;
	strURL = GetText();

	// Use float, otherwise we get an incorrect letter from the point
	float width = (float)size.cx/(float)strURL.GetLength();

	// remove left of cell so we have original point again 
	pt.x -= m_Rect.left;
	if (m_nFormat & DT_RIGHT)
	{
		int wide = m_Rect.Width() - size.cx;
		pt.x -= wide;
		if (pt.x <= 0)
			return FALSE;
	}

	if (m_nFormat & DT_CENTER)
	{
		int wide = m_Rect.Width() - size.cx;
		pt.x -= (wide/2);
		if (pt.x <= 0 || pt.x > (size.cx + (wide/2)))
			return FALSE;
	}

	// Turn point into a letter
	int ltrs = (int)((float)pt.x/width);

	// Does text have url
	return HasUrl(strURL);
}

#pragma warning(default: 4267)