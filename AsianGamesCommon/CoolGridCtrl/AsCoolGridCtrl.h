/////////////////////////////////////////////////////////////////////////////
// AsCoolGridCtrl.h : header file
// MFC Grid Control - main header
#pragma once

#include "AsCoolGridCellRange.h"
#include "AsCoolGridCell.h"
#include "AsCoolGridTitleTip.h"
#include "AsCoolGridDropTarget.h"
#include <afxole.h>
#include <afxtempl.h>
#include <vector>

// Use this as the classname when inserting this control as a custom control
// in the MSVC++ dialog editor
#define GRIDCTRL_CLASSNAME    _T("AsCoolGridCtrl")  // Window class name
#define IDC_INPLACE_CONTROL   8                     // ID of inplace edit controls

// Handy functions
#define IsSHIFTpressed() ( (GetKeyState(VK_SHIFT) & (1 << (sizeof(SHORT)*8-1))) != 0   )
#define IsCTRLpressed()  ( (GetKeyState(VK_CONTROL) & (1 << (sizeof(SHORT)*8-1))) != 0 )

// Backwards compatibility for pre 2.20 grid versions
#define DDX_GridControl(pDX, nIDC, rControl)  DDX_Control(pDX, nIDC, rControl)     

//  This structure sent to Grid's parent in a WM_NOTIFY message
typedef struct tagNM_GRIDVIEW 
{
	NMHDR hdr;
	int   iRow;
	int   iColumn;
} NM_GRIDVIEW;

// This is sent to the Grid from child in-place edit controls
typedef struct tagGV_DISPINFO 
{
	NMHDR   hdr;
	GV_ITEM item;
} GV_DISPINFO;

// This is sent to the Grid from child in-place edit controls
typedef struct tagGV_CACHEHINT 
{
	NMHDR      hdr;
	CAsCoolGridCellRange range;
} GV_CACHEHINT;

// storage typedef for each row in the grid
typedef CTypedPtrArray<CObArray, CAsCoolGridCellBase*> GRID_ROW;

// For virtual mode callback
typedef BOOL (CALLBACK* GRIDCALLBACK)(GV_DISPINFO *, LPARAM);

// Grid line/scrollbar selection
#define GVL_NONE                0L      // Neither
#define GVL_HORZ                1L      // Horizontal line or scrollbar
#define GVL_VERT                2L      // Vertical line or scrollbar
#define GVL_BOTH                3L      // Both

// Autosizing option
#define GVS_DEFAULT             0
#define GVS_HEADER              1       // Size using column fixed cells data only
#define GVS_DATA                2       // Size using column non-fixed cells data only
#define GVS_BOTH                3       // Size using column fixed and non-fixed

// Cell Searching options
#define GVNI_FOCUSED            0x0001
#define GVNI_SELECTED           0x0002
#define GVNI_DROPHILITED        0x0004
#define GVNI_READONLY           0x0008
#define GVNI_FIXED              0x0010
#define GVNI_MODIFIED           0x0020

#define GVNI_ABOVE              LVNI_ABOVE
#define GVNI_BELOW              LVNI_BELOW
#define GVNI_TOLEFT             LVNI_TOLEFT
#define GVNI_TORIGHT            LVNI_TORIGHT
#define GVNI_ALL                (LVNI_BELOW|LVNI_TORIGHT|LVNI_TOLEFT)
#define GVNI_AREA               (LVNI_BELOW|LVNI_TORIGHT)

// Hit test values (not yet implemented)
#define GVHT_DATA               0x0000
#define GVHT_TOPLEFT            0x0001
#define GVHT_COLHDR             0x0002
#define GVHT_ROWHDR             0x0004
#define GVHT_COLSIZER           0x0008
#define GVHT_ROWSIZER           0x0010
#define GVHT_LEFT               0x0020
#define GVHT_RIGHT              0x0040
#define GVHT_ABOVE              0x0080
#define GVHT_BELOW              0x0100

// Messages sent to the grid's parent (More will be added in future)
//including NM_CLICK, NM_DBLCLK, NM_RCLICK
#define GVN_BEGINDRAG           LVN_BEGINDRAG        // LVN_FIRST-9
#define GVN_BEGINLABELEDIT      LVN_BEGINLABELEDIT   // LVN_FIRST-5
#define GVN_COLUMNCLICK         LVN_COLUMNCLICK
#define GVN_ENDLABELEDIT        LVN_ENDLABELEDIT     // LVN_FIRST-6
#define GVN_SELCHANGING         LVN_ITEMCHANGING
#define GVN_SELCHANGED          LVN_ITEMCHANGED
#define GVN_GETDISPINFO         LVN_GETDISPINFO 
#define GVN_ODCACHEHINT         LVN_ODCACHEHINT 

// Have not been implemented messages
#define GVN_BEGINRDRAG          LVN_BEGINRDRAG
#define GVN_DELETEITEM          LVN_DELETEITEM

class CAsCoolGridCtrl;

/////////////////////////////////////////////////////////////////////////////
// CAsCoolGridCtrl window

typedef bool (*PVIRTUALCOMPARE)(int, int);

class AX_OVRCOMMON_EXP CAsCoolGridCtrl : public CWnd
{
	DECLARE_DYNCREATE(CAsCoolGridCtrl)
	friend class CAsCoolGridCell;
	friend class CAsCoolGridCellBase;

	// Construction
public:
	CAsCoolGridCtrl(int nRows = 0, int nCols = 0, int nFixedRows = 0, int nFixedCols = 0);
	virtual ~CAsCoolGridCtrl();

	BOOL Create(const RECT& rect, CWnd* parent, UINT nID,
		DWORD dwStyle = WS_CHILD | WS_BORDER | WS_TABSTOP | WS_VISIBLE);

	///////////////////////////////////////////////////////////////////////////////////
	// Attributes
	///////////////////////////////////////////////////////////////////////////////////
public:
	int  GetRowCount() const                    { return m_nRows;		}
	int  GetColumnCount() const                 { return m_nCols;		}
	int  GetFixedRowCount() const               { return m_nFixedRows;	}
	int  GetFixedColumnCount() const            { return m_nFixedCols;	}
	virtual BOOL SetRowCount(int nRows = 10);
	virtual BOOL SetColumnCount(int nCols = 10);
	virtual BOOL SetFixedRowCount(int nFixedRows = 1);
	virtual BOOL SetFixedColumnCount(int nFixedCols = 1);

			int  GetRowHeight(int nRow) const;
	virtual BOOL SetRowHeight(int row, int height);
			int  GetColumnWidth(int nCol) const;
	virtual BOOL SetColumnWidth(int col, int width);

	BOOL GetCellOrigin(int nRow, int nCol, LPPOINT p);
	BOOL GetCellOrigin(const CAsCoolGridCellID& cell, LPPOINT p);
	BOOL GetCellRect(int nRow, int nCol, LPRECT pRect);
	BOOL GetCellRect(const CAsCoolGridCellID& cell, LPRECT pRect);

	BOOL GetTextRect(const CAsCoolGridCellID& cell, LPRECT pRect);
	BOOL GetTextRect(int nRow, int nCol, LPRECT pRect);

	CAsCoolGridCellID GetCellFromPt(CPoint point, BOOL bAllowFixedCellCheck = TRUE);

	int  GetFixedRowHeight() const;
	int  GetFixedColumnWidth() const;
	long GetVirtualWidth() const;
	long GetVirtualHeight() const;

	CSize GetTextExtent(int nRow, int nCol, LPCTSTR str);
	// EFW - Get extent of current text in cell
	inline CSize GetCellTextExtent(int nRow, int nCol)			{ return GetTextExtent(nRow, nCol, GetItemText(nRow,nCol)); }

	virtual void SetGridBkColor(COLORREF clr)					{ m_crGridBkColour = clr;       }
	COLORREF GetGridBkColor() const								{ return m_crGridBkColour;      }
	virtual void SetGridLineColor(COLORREF clr)					{ m_crGridLineColour = clr;     }
	COLORREF GetGridLineColor() const							{ return m_crGridLineColour;    }

	virtual void SetTitleTipBackClr(COLORREF clr = CLR_DEFAULT) { m_crTTipBackClr = clr;		}
	COLORREF GetTitleTipBackClr()								{ return m_crTTipBackClr;		}
	virtual void SetTitleTipTextClr(COLORREF clr = CLR_DEFAULT) { m_crTTipTextClr = clr;		}
	COLORREF GetTitleTipTextClr()								{ return m_crTTipTextClr;		}

	// ***************************************************************************** //
	// These have been deprecated. Use GetDefaultCell and then set the colors
	void     SetTextColor(COLORREF clr)      { m_cellDefault.SetTextClr(clr);			}
	COLORREF GetTextColor()                  { return m_cellDefault.GetTextClr();		}
	void     SetTextBkColor(COLORREF clr)    { m_cellDefault.SetBackClr(clr);			}
	COLORREF GetTextBkColor()                { return m_cellDefault.GetBackClr();		}
	void     SetFixedTextColor(COLORREF clr) { m_cellFixedRowDef.SetTextClr(clr); 
												m_cellFixedColDef.SetTextClr(clr); 
												m_cellFixedRowColDef.SetTextClr(clr);	}
	COLORREF GetFixedTextColor() const       { return m_cellFixedRowDef.GetTextClr();	}
	void     SetFixedBkColor(COLORREF clr)   { m_cellFixedRowDef.SetBackClr(clr); 
												m_cellFixedColDef.SetBackClr(clr); 
												m_cellFixedRowColDef.SetBackClr(clr);	}
	COLORREF GetFixedBkColor() const         { return m_cellFixedRowDef.GetBackClr();	}
	void     SetGridColor(COLORREF clr)      { SetGridLineColor(clr);					}
	COLORREF GetGridColor()                  { return GetGridLineColor();				}
	void     SetBkColor(COLORREF clr)        { SetGridBkColor(clr);						}
	COLORREF GetBkColor()                    { return GetGridBkColor();					}

	void     SetDefCellMargin( int nMargin)  { m_cellDefault.SetMargin(nMargin); 
												m_cellFixedRowDef.SetMargin(nMargin); 
												m_cellFixedColDef.SetMargin(nMargin); 
												m_cellFixedRowColDef.SetMargin(nMargin);}
	int      GetDefCellMargin() const        { return m_cellDefault.GetMargin();		}

	int      GetDefCellHeight() const        { return m_cellDefault.GetHeight();		}
	void     SetDefCellHeight(int nHeight)   { m_cellDefault.SetHeight(nHeight); 
												m_cellFixedRowDef.SetHeight(nHeight); 
												m_cellFixedColDef.SetHeight(nHeight); 
												m_cellFixedRowColDef.SetHeight(nHeight);}
	int      GetDefCellWidth() const         { return m_cellDefault.GetWidth();			}
	void     SetDefCellWidth(int nWidth)     { m_cellDefault.SetWidth(nWidth); 
												m_cellFixedRowDef.SetWidth(nWidth); 
												m_cellFixedColDef.SetWidth(nWidth); 
												m_cellFixedRowColDef.SetWidth(nWidth);	}
	// *********************************************************************************** //
	// ***********************************************************************************//

	int GetSelectedCount() const							{ return (int)m_SelectedCellMap.GetCount(); }

	virtual CAsCoolGridCellID SetFocusCell(CAsCoolGridCellID cell);
	virtual CAsCoolGridCellID SetFocusCell(int nRow, int nCol);
			CAsCoolGridCellID GetFocusCell() const          { return m_idCurrentCell;           }


	virtual void SetVirtualMode(BOOL bVirtual);
			BOOL GetVirtualMode() const						{ return m_bVirtualMode;            }
	virtual void SetCallbackFunc(GRIDCALLBACK pCallback, LPARAM lParam){ m_pfnCallback = pCallback; m_lParam = lParam; }
	GRIDCALLBACK GetCallbackFunc()							{ return m_pfnCallback;             }


	virtual void SetImageList(CImageList* pList)			{ m_pImageList = pList;             }
	CImageList* GetImageList() const						{ return m_pImageList;              }

	virtual void SetGridLines(int nWhichLines = GVL_BOTH);
			int  GetGridLines() const						{ return m_nGridLines;              }
	virtual void SetEditable(BOOL bEditable = TRUE)			{ m_bEditable = bEditable;          }
			BOOL IsEditable() const							{ return m_bEditable;               }
	virtual void SetListMode(BOOL bEnableListMode = TRUE);
			BOOL GetListMode() const						{ return m_bListMode;               }
	virtual void SetSingleRowSelection(BOOL bSing = TRUE)	{ m_bSingleRowSelection = bSing;    }
			BOOL GetSingleRowSelection()					{ return m_bSingleRowSelection & m_bListMode; }
	virtual void SetSingleColSelection(BOOL bSing = TRUE)	{ m_bSingleColSelection = bSing;    }
			BOOL GetSingleColSelection()					{ return m_bSingleColSelection;     }
	virtual void EnableSelection(BOOL bEnable = TRUE)		{ ResetSelectedRange(); m_bEnableSelection = bEnable; ResetSelectedRange(); }
			BOOL IsSelectable() const						{ return m_bEnableSelection;        }
	virtual void SetFixedColumnSelection(BOOL bSelect)		{ m_bFixedColumnSelection = bSelect;}
			BOOL GetFixedColumnSelection()					{ return m_bFixedColumnSelection;   }
	virtual void SetFixedRowSelection(BOOL bSelect)			{ m_bFixedRowSelection = bSelect;   }
			BOOL GetFixedRowSelection()						{ return m_bFixedRowSelection;      }
	virtual void EnableDragAndDrop(BOOL bAllow = TRUE)		{ m_bAllowDragAndDrop = bAllow;     }
			BOOL GetDragAndDrop() const						{ return m_bAllowDragAndDrop;       }
	virtual void SetRowResize(BOOL bResize = TRUE)			{ m_bAllowRowResize = bResize;      }
			BOOL GetRowResize() const						{ return m_bAllowRowResize;         }
	virtual void SetColumnResize(BOOL bResize = TRUE)		{ m_bAllowColumnResize = bResize;   }
			BOOL GetColumnResize() const					{ return m_bAllowColumnResize;      }
	virtual void SetHeaderSort(BOOL bSortOnClick = TRUE)	{ m_bSortOnClick = bSortOnClick;    }
			BOOL GetHeaderSort() const						{ return m_bSortOnClick;            }
	virtual void SetHandleTabKey(BOOL bHandleTab = TRUE)	{ m_bHandleTabKey = bHandleTab;     }
			BOOL GetHandleTabKey() const					{ return m_bHandleTabKey;           }
	virtual void SetDoubleBuffering(BOOL bBuffer = TRUE)	{ m_bDoubleBuffer = bBuffer;        }
			BOOL GetDoubleBuffering() const					{ return m_bDoubleBuffer;           }
	virtual void EnableTitleTips(BOOL bEnable = TRUE)		{ m_bTitleTips = bEnable;           }
			BOOL GetTitleTips()								{ return m_bTitleTips;              }
	virtual void SetSortColumn(int nCol);
			int  GetSortColumn() const						{ return m_nSortColumn;             }
	virtual void SetSortAscending(BOOL bAscending)			{ m_bAscending = bAscending;        }
			BOOL GetSortAscending() const					{ return m_bAscending;              }
	virtual void SetTrackFocusCell(BOOL bTrack)				{ m_bTrackFocusCell = bTrack;       }
			BOOL GetTrackFocusCell()						{ return m_bTrackFocusCell;         }
	virtual void SetFrameFocusCell(BOOL bFrame)				{ m_bFrameFocus = bFrame;           }
			BOOL GetFrameFocusCell()						{ return m_bFrameFocus;             }
	virtual void SetAutoSizeStyle(int nStyle = GVS_BOTH)	{ m_nAutoSizeColumnStyle = nStyle;  }
			int  GetAutoSizeStyle()							{ return m_nAutoSizeColumnStyle;	}

	virtual void EnableHiddenColUnhide(BOOL bEnable = TRUE)	{ m_bHiddenColUnhide = bEnable;		}
			BOOL GetHiddenColUnhide()						{ return m_bHiddenColUnhide;        }
	virtual void EnableHiddenRowUnhide(BOOL bEnable = TRUE)	{ m_bHiddenRowUnhide = bEnable;		}
			BOOL GetHiddenRowUnhide()						{ return m_bHiddenRowUnhide;        }

	virtual void EnableColumnHide(BOOL bEnable = TRUE)		{ m_bAllowColHide = bEnable;        }
			BOOL GetColumnHide()							{ return m_bAllowColHide;           }
	virtual void EnableRowHide(BOOL bEnable = TRUE)			{ m_bAllowRowHide = bEnable;        }
			BOOL GetRowHide()								{ return m_bAllowRowHide;           }

	///////////////////////////////////////////////////////////////////////////////////
	// default Grid cells. Use these for setting default values such as colors and fonts
	///////////////////////////////////////////////////////////////////////////////////
public:
	CAsCoolGridCellBase* GetDefaultCell(BOOL bFixedRow, BOOL bFixedCol) const;

	///////////////////////////////////////////////////////////////////////////////////
	// Grid cell Attributes
	///////////////////////////////////////////////////////////////////////////////////
public:
	CAsCoolGridCellBase* GetCell(int nRow, int nCol) const;   // Get the actual cell!

	virtual void SetModified(BOOL bModified = TRUE, int nRow = -1, int nCol = -1);
	BOOL GetModified(int nRow = -1, int nCol = -1);
	BOOL IsCellFixed(int nRow, int nCol);

	virtual BOOL   SetItem(const GV_ITEM* pItem);
			BOOL   GetItem(GV_ITEM* pItem);
	virtual BOOL   SetItemText(int nRow, int nCol, LPCTSTR str);
	// The following was virtual. If you want to override, use 
	//  CGridCellBase-derived class's GetText() to accomplish same thing
	CString GetItemText(int nRow, int nCol) const;

	// EFW - 06/13/99 - Added to support printf-style formatting codes.
	// Also supports use with a string resource ID
	virtual BOOL   SetItemTextFmt(int nRow, int nCol, LPCTSTR szFmt, ...);
	virtual BOOL   SetItemTextFmtID(int nRow, int nCol, UINT nID, ...);

	virtual BOOL   SetItemData(int nRow, int nCol, LPARAM lParam);
			LPARAM GetItemData(int nRow, int nCol) const;
	virtual BOOL   SetItemImage(int nRow, int nCol, int iImage);
			int    GetItemImage(int nRow, int nCol) const;
	virtual BOOL   SetItemState(int nRow, int nCol, UINT state);
			UINT   GetItemState(int nRow, int nCol) const;
	virtual BOOL   SetItemFormat(int nRow, int nCol, UINT nFormat);
			UINT   GetItemFormat(int nRow, int nCol) const;
	virtual BOOL   SetItemBkColour(int nRow, int nCol, COLORREF cr = CLR_DEFAULT);
			COLORREF GetItemBkColour(int nRow, int nCol) const;
	virtual BOOL   SetItemFgColour(int nRow, int nCol, COLORREF cr = CLR_DEFAULT);
			COLORREF GetItemFgColour(int nRow, int nCol) const;
	virtual BOOL SetItemFont(int nRow, int nCol, const LOGFONT* lf);
	const LOGFONT* GetItemFont(int nRow, int nCol);

	BOOL IsItemEditing(int nRow, int nCol);

	virtual BOOL SetCellEditalbe(int nRow, int nCol, BOOL bEnable);
	virtual BOOL SetCellType(int nRow, int nCol, CRuntimeClass* pRuntimeClass);
	virtual BOOL SetDefaultCellType( CRuntimeClass* pRuntimeClass);

	///////////////////////////////////////////////////////////////////////////////////
	// Rows and Colums Attribute setting
	///////////////////////////////////////////////////////////////////////////////////
public:
	virtual BOOL SetColumnBkColor(int nCol, COLORREF clr = CLR_DEFAULT);
	virtual BOOL SetRowBkColor(int nRow, COLORREF clr = CLR_DEFAULT);
	virtual BOOL SetColumnFgColor(int nCol, COLORREF clr = CLR_DEFAULT);
	virtual BOOL SetRowFgColor(int nRow, COLORREF clr = CLR_DEFAULT);
	virtual BOOL SetColEditable(int nCol, BOOL bEnable);
	virtual BOOL SetRowEditable(int nRow, BOOL bEnable);

	///////////////////////////////////////////////////////////////////////////////////
	// Operations
	///////////////////////////////////////////////////////////////////////////////////
public:
	virtual int  InsertColumn(LPCTSTR strHeading, UINT nFormat = DT_CENTER|DT_VCENTER|DT_SINGLELINE, int nColumn = -1);									
	virtual int  InsertRow(LPCTSTR strHeading, int nRow = -1);
	virtual BOOL DeleteColumn(int nColumn);
	virtual BOOL DeleteRow(int nRow);
	virtual BOOL DeleteNonFixedRows();
	virtual BOOL DeleteAllItems();

	virtual void ClearCells(CAsCoolGridCellRange Selection);

	virtual BOOL AutoSizeRow(int nRow, BOOL bResetScroll = TRUE);
	virtual BOOL AutoSizeColumn(int nCol, UINT nAutoSizeStyle = GVS_DEFAULT, BOOL bResetScroll = TRUE);
	virtual void AutoSizeRows();
	virtual void AutoSizeColumns(UINT nAutoSizeStyle = GVS_DEFAULT);
	virtual void AutoSize(UINT nAutoSizeStyle = GVS_DEFAULT);
	virtual void ExpandColumnsToFit(BOOL bExpandFixed = TRUE);
	virtual void ExpandLastColumn();
	virtual void ExpandRowsToFit(BOOL bExpandFixed = TRUE);
	virtual void ExpandToFit(BOOL bExpandFixed = TRUE);

	virtual void Refresh();
	virtual void AutoFill();   // Fill grid with blank cells

			void EnsureVisible(CAsCoolGridCellID &cell)       { EnsureVisible(cell.m_nRow, cell.m_nCol); }
	virtual void EnsureVisible(int nRow, int nCol);
	virtual BOOL IsCellVisible(int nRow, int nCol);
	BOOL IsCellVisible(CAsCoolGridCellID cell);
	virtual BOOL IsCellEditable(int nRow, int nCol) const;
	BOOL IsCellEditable(CAsCoolGridCellID &cell) const;
	virtual BOOL IsCellSelected(int nRow, int nCol) const;
	BOOL IsCellSelected(CAsCoolGridCellID &cell) const;

	// SetRedraw stops/starts redraws on things like changing the # rows/columns
	// and autosizing, but not for user-intervention such as resizes
	virtual void SetRedraw(BOOL bAllowDraw, BOOL bResetScrollBars = FALSE);
	virtual BOOL RedrawCell(int nRow, int nCol, CDC* pDC = NULL);
			BOOL RedrawCell(const CAsCoolGridCellID& cell, CDC* pDC = NULL);
	virtual BOOL RedrawRow(int row);
	virtual BOOL RedrawColumn(int col);

	virtual BOOL Save(LPCTSTR filename, TCHAR chSeparator = _T(','));
	virtual BOOL Load(LPCTSTR filename, TCHAR chSeparator = _T(','));

	///////////////////////////////////////////////////////////////////////////////////
	// Cell Ranges
	///////////////////////////////////////////////////////////////////////////////////
public:
	int GetSelectedCells(CArray<CAsCoolGridCellID> &arraySelCells) const;   // return selected cells's ID array and it's count
	int GetSelectedRows(CUIntArray &naSelRowsIndex) const;					
	int GetSelectedColumns(CUIntArray &naSelColsIndex) const;				// return Columns's index and it's count
	virtual void SetSelectedColumn(int nCol, BOOL bAddSelCol = FALSE);				// bAddSelCol = TRUE, add current selected col to the previous selected
	virtual void SetSelectedRow(int nRow, BOOL bAddSelRow = FALSE);				

	CAsCoolGridCellRange GetCellRange() const;
	CAsCoolGridCellRange GetSelectedCellRange() const;
	virtual void SetSelectedRange(const CAsCoolGridCellRange& Range, BOOL bForceRepaint = FALSE, BOOL bSelectCells = TRUE);
	virtual void SetSelectedRange(int nMinRow, int nMinCol, int nMaxRow, int nMaxCol,
		BOOL bForceRepaint = FALSE, BOOL bSelectCells = TRUE);
	BOOL IsValid(int nRow, int nCol) const;
	BOOL IsValid(const CAsCoolGridCellID& cell) const;
	BOOL IsValid(const CAsCoolGridCellRange& range) const;

	///////////////////////////////////////////////////////////////////////////////////
	// Clipboard, drag and drop, and cut n' paste operations
	///////////////////////////////////////////////////////////////////////////////////
	virtual void CutSelectedText();
	virtual COleDataSource* CopyTextFromGrid();
	virtual BOOL PasteTextToGrid(CAsCoolGridCellID cell, COleDataObject* pDataObject, BOOL bSelectPastedCells=TRUE);

	virtual void OnBeginDrag();
	virtual DROPEFFECT OnDragEnter(COleDataObject* pDataObject, DWORD dwKeyState, CPoint point);
	virtual DROPEFFECT OnDragOver(COleDataObject* pDataObject, DWORD dwKeyState, CPoint point);
	virtual void OnDragLeave();
	virtual BOOL OnDrop(COleDataObject* pDataObject, DROPEFFECT dropEffect, CPoint point);

	virtual void OnEditCut();
	virtual void OnEditCopy();
	virtual void OnEditPaste();

	virtual void OnEditSelectAll();
	///////////////////////////////////////////////////////////////////////////////////
	// Misc.
	///////////////////////////////////////////////////////////////////////////////////
public:
	CAsCoolGridCellID GetNextItem(CAsCoolGridCellID& cell, int nFlags) const;

	virtual BOOL SortItems(int nCol, BOOL bAscending, LPARAM data = 0);
	virtual BOOL SortTextItems(int nCol, BOOL bAscending, LPARAM data = 0);
	virtual BOOL SortItems(PFNLVCOMPARE pfnCompare, int nCol, BOOL bAscending, LPARAM data = 0);

	virtual void SetCompareFunction(PFNLVCOMPARE pfnCompare);

	// in-built sort functions
	static int CALLBACK pfnCellTextCompare(LPARAM lParam1, LPARAM lParam2, LPARAM lParamSort);
	static int CALLBACK pfnCellNumericCompare(LPARAM lParam1, LPARAM lParam2, LPARAM lParamSort);

	///////////////////////////////////////////////////////////////////////////////////
	// Printing
	///////////////////////////////////////////////////////////////////////////////////
public:
	void Print(CPrintDialog* pPrntDialog = NULL);

	// EFW - New printing support functions
	void EnableWysiwygPrinting(BOOL bEnable = TRUE) { m_bWysiwygPrinting = bEnable;     }
	BOOL GetWysiwygPrinting()                       { return m_bWysiwygPrinting;        }

	void SetShadedPrintOut(BOOL bEnable = TRUE)     {   m_bShadedPrintOut = bEnable;    }
	BOOL GetShadedPrintOut(void)                    {   return m_bShadedPrintOut;       }

	// Use -1 to have it keep the existing value
	void SetPrintMarginInfo(int nHeaderHeight, int nFooterHeight,
		int nLeftMargin, int nRightMargin, int nTopMargin,
		int nBottomMargin, int nGap);

	void GetPrintMarginInfo(int &nHeaderHeight, int &nFooterHeight,
		int &nLeftMargin, int &nRightMargin, int &nTopMargin,
		int &nBottomMargin, int &nGap);

	///////////////////////////////////////////////////////////////////////////////////
	// Printing overrides for derived classes
	///////////////////////////////////////////////////////////////////////////////////
public:
	virtual void OnBeginPrinting(CDC *pDC, CPrintInfo *pInfo);
	virtual void OnPrint(CDC *pDC, CPrintInfo *pInfo);
	virtual void OnEndPrinting(CDC *pDC, CPrintInfo *pInfo);

protected:
	virtual BOOL RegisterWindowClass();
	virtual BOOL Initialise();
	virtual void SetupDefaultCells();

	virtual LRESULT SendMessageToParent(int nRow, int nCol, int nMessage) const;
	virtual LRESULT SendDisplayRequestToParent(GV_DISPINFO* pDisplayInfo) const;
	virtual LRESULT SendCacheHintToParent(const CAsCoolGridCellRange& range) const;

	virtual BOOL InvalidateCellRect(const int row, const int col);
			BOOL InvalidateCellRect(const CAsCoolGridCellID& cell);
	virtual BOOL InvalidateCellRect(const CAsCoolGridCellRange& cellRange);
	virtual void EraseBkgnd(CDC* pDC);

	BOOL GetCellRangeRect(const CAsCoolGridCellRange& cellRange, LPRECT lpRect);

	virtual BOOL SetCell(int nRow, int nCol, CAsCoolGridCellBase* pCell);

	virtual int  SetMouseMode(int nMode) { int nOldMode = m_MouseMode; m_MouseMode = nMode; return nOldMode; }
			int  GetMouseMode() const    { return m_MouseMode; }

	BOOL MouseOverRowResizeArea(CPoint& point);
	BOOL MouseOverColumnResizeArea(CPoint& point);

	CAsCoolGridCellID GetTopleftNonFixedCell(BOOL bForceRecalculation = FALSE);
	CAsCoolGridCellRange GetUnobstructedNonFixedCellRange(BOOL bForceRecalculation = FALSE);
	CAsCoolGridCellRange GetVisibleNonFixedCellRange(LPRECT pRect = NULL, BOOL bForceRecalculation = FALSE);

	BOOL IsVisibleVScroll() { return ( (m_nBarState & GVL_VERT) > 0); } 
	BOOL IsVisibleHScroll() { return ( (m_nBarState & GVL_HORZ) > 0); }
	virtual void ResetSelectedRange();
	virtual void ResetScrollBars();
	virtual void EnableScrollBars(int nBar, BOOL bEnable = TRUE);
			int  GetScrollPos32(int nBar, BOOL bGetTrackPos = FALSE);
	virtual BOOL SetScrollPos32(int nBar, int nPos, BOOL bRedraw = TRUE);

	// BOOL SortTextItems(int nCol, BOOL bAscending, int low, int high); // no implement
	virtual BOOL SortItems(PFNLVCOMPARE pfnCompare, int nCol, BOOL bAscending, LPARAM data,
		int low, int high);

	CPoint GetPointClicked(int nRow, int nCol, const CPoint& point);

	virtual void ValidateAndModifyCellContents(int nRow, int nCol, LPCTSTR strText);

	// Overrrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAsCoolGridCtrl)
protected:
	virtual void PreSubclassWindow();
	//}}AFX_VIRTUAL

protected:
	// Printing
	virtual void PrintFixedRowCells(int nStartColumn, int nStopColumn, int& row, CRect& rect,
		CDC *pDC, BOOL& bFirst);
	virtual void PrintColumnHeadings(CDC *pDC, CPrintInfo *pInfo);
	virtual void PrintHeader(CDC *pDC, CPrintInfo *pInfo);
	virtual void PrintFooter(CDC *pDC, CPrintInfo *pInfo);
	virtual void PrintRowButtons(CDC *pDC, CPrintInfo* /*pInfo*/);

	// Drag n' drop
	virtual CImageList* CreateDragImage(CPoint *pHotSpot);    // no longer necessary

	// Mouse Clicks
	virtual void  OnFixedColumnClick(CAsCoolGridCellID& cell);
	virtual void  OnFixedRowClick(CAsCoolGridCellID& cell);

	// Editing
	virtual void  OnEditCell(int nRow, int nCol, CPoint point, UINT nChar);
	virtual void  OnEndEditCell(int nRow, int nCol, CString str);
	virtual BOOL  ValidateEdit(int nRow, int nCol, LPCTSTR str);
	virtual void  EndEditing();

	// Drawing
	virtual void  OnDraw(CDC* pDC);

	// CAsCoolGridCellBase Creation and Cleanup
	virtual CAsCoolGridCellBase* CreateCell(int nRow, int nCol);
	virtual void DestroyCell(int nRow, int nCol);

	// Attributes
protected:
	// General attributes
	COLORREF    m_crFixedTextColour, m_crFixedBkColour;
	COLORREF    m_crGridBkColour, m_crGridLineColour;
	COLORREF    m_crWindowText, m_crWindowColour, m_cr3DFace,     // System colours
		m_crShadow;
	COLORREF    m_crTTipBackClr, m_crTTipTextClr;                 // Titletip colours - FNA

	BOOL        m_bVirtualMode;
	LPARAM      m_lParam;                                           // lParam for callback
	GRIDCALLBACK m_pfnCallback;                                     // The callback function

	int         m_nGridLines;
	BOOL        m_bEditable;
	BOOL        m_bModified;
	BOOL        m_bAllowDragAndDrop;
	BOOL        m_bListMode;
	BOOL        m_bSingleRowSelection;
	BOOL        m_bSingleColSelection;
	BOOL        m_bAllowDraw;
	BOOL        m_bEnableSelection;
	BOOL        m_bFixedRowSelection, m_bFixedColumnSelection;
	BOOL        m_bSortOnClick;
	BOOL        m_bHandleTabKey;
	BOOL        m_bDoubleBuffer;
	BOOL        m_bTitleTips;
	int         m_nBarState;
	BOOL        m_bWysiwygPrinting;
	BOOL        m_bHiddenColUnhide, m_bHiddenRowUnhide;
	BOOL        m_bAllowColHide, m_bAllowRowHide;
	BOOL        m_bAutoSizeSkipColHdr;
	BOOL        m_bTrackFocusCell;
	BOOL        m_bFrameFocus;
	UINT        m_nAutoSizeColumnStyle;

	// Cell size details
	int         m_nRows, m_nFixedRows, m_nCols, m_nFixedCols;
	CUIntArray  m_arRowHeights, m_arColWidths;
	int         m_nVScrollMax, m_nHScrollMax;

	// Fonts and images
	CRuntimeClass*   m_pRtcDefault; // determines kind of Grid Cell created by default
	CAsCoolGridDefaultCell m_cellDefault;  // "default" cell. Contains default colours, font etc.
	CAsCoolGridDefaultCell m_cellFixedColDef, m_cellFixedRowDef, m_cellFixedRowColDef;
	CFont       m_PrinterFont;  // for the printer
	CImageList* m_pImageList;

	// Cell data
	CTypedPtrArray<CObArray, GRID_ROW*> m_RowData;

	// Mouse operations such as cell selection
	int         m_MouseMode;
	BOOL        m_bLMouseButtonDown, m_bRMouseButtonDown;
	CPoint      m_LeftClickDownPoint, m_LastMousePoint;
	CAsCoolGridCellID     m_LeftClickDownCell, m_SelectionStartCell;
	CAsCoolGridCellID     m_idCurrentCell, m_idTopLeftCell;
	int         m_nTimerID;
	int         m_nTimerInterval;
	int         m_nResizeCaptureRange;
	BOOL        m_bAllowRowResize, m_bAllowColumnResize;
	int         m_nRowsPerWheelNotch;
	typedef CMap<DWORD,DWORD, CAsCoolGridCellID, CAsCoolGridCellID&> SELECTEDCELLSMAP;
	SELECTEDCELLSMAP	m_SelectedCellMap, m_PrevSelectedCellMap;

	CAsCoolGridTitleTip   m_TitleTip;             // Title tips for cells

	// Drag and drop
	CAsCoolGridCellID     m_LastDragOverCell;
	CAsCoolGridDropTarget m_DropTarget;       // OLE Drop target for the grid

	// Printing information
	CSize       m_CharSize;
	int         m_nPageHeight;
	CSize       m_LogicalPageSize,      // Page size in gridctrl units.
		m_PaperSize;            // Page size in device units.
	// additional properties to support Wysiwyg printing
	int         m_nPageWidth;
	int         m_nPrintColumn;
	int         m_nCurrPrintRow;
	int         m_nNumPages;
	int         m_nPageMultiplier;

	// sorting
	int          m_bAscending;
	int          m_nSortColumn;
	PFNLVCOMPARE m_pfnCompare;

	// EFW - Added to support shaded/unshaded printout.  If true, colored
	// cells will print as-is.  If false, all text prints as black on white.
	BOOL        m_bShadedPrintOut;

	// EFW - Added support for user-definable margins.  Top and bottom are in 
	// lines.  Left, right, and gap are in characters (avg width is used).
	int         m_nHeaderHeight, m_nFooterHeight, m_nLeftMargin,
		m_nRightMargin, m_nTopMargin, m_nBottomMargin, m_nGap;

protected:
	virtual void SelectAllCells();
	virtual void SelectColumns(CAsCoolGridCellID currentCell, BOOL bForceRedraw=FALSE, BOOL bSelectCells=TRUE);
	virtual void SelectRows(CAsCoolGridCellID currentCell, BOOL bForceRedraw=FALSE, BOOL bSelectCells=TRUE);
	virtual void SelectCells(CAsCoolGridCellID currentCell, BOOL bForceRedraw=FALSE, BOOL bSelectCells=TRUE);
	virtual void OnSelecting(const CAsCoolGridCellID& currentCell);

	// Generated message map functions
	//{{AFX_MSG(CAsCoolGridCtrl)
	afx_msg void OnPaint();
	afx_msg void OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
	afx_msg void OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnMouseMove(UINT nFlags, CPoint point);
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg UINT OnGetDlgCode();
	afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg void OnKeyUp(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg void OnLButtonDblClk(UINT nFlags, CPoint point);
	afx_msg BOOL OnEraseBkgnd(CDC* pDC);
	afx_msg void OnSysKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg void OnUpdateEditSelectAll(CCmdUI* pCmdUI);
	//}}AFX_MSG

	afx_msg BOOL OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message);
	afx_msg void OnRButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnRButtonUp(UINT nFlags, CPoint point);    // EFW - Added
	afx_msg void OnSysColorChange();
	afx_msg void OnCaptureChanged(CWnd *pWnd);
	afx_msg void OnUpdateEditCopy(CCmdUI* pCmdUI);
	afx_msg void OnUpdateEditCut(CCmdUI* pCmdUI);
	afx_msg void OnUpdateEditPaste(CCmdUI* pCmdUI);

	afx_msg void OnSettingChange(UINT uFlags, LPCTSTR lpszSection);
	afx_msg BOOL OnMouseWheel(UINT nFlags, short zDelta, CPoint pt);

	afx_msg LRESULT OnSetFont(WPARAM hFont, LPARAM lParam);
	afx_msg LRESULT OnGetFont(WPARAM hFont, LPARAM lParam);
	afx_msg LRESULT OnImeChar(WPARAM wCharCode, LPARAM lParam);
	afx_msg void OnEndInPlaceEdit(NMHDR* pNMHDR, LRESULT* pResult);
	DECLARE_MESSAGE_MAP()

	enum eMouseModes
	{ MOUSE_NOTHING, MOUSE_SELECT_ALL, MOUSE_SELECT_COL, MOUSE_SELECT_ROW,
	MOUSE_SELECT_CELLS, MOUSE_SCROLLING_CELLS,
	MOUSE_OVER_ROW_DIVIDE, MOUSE_SIZING_ROW,
	MOUSE_OVER_COL_DIVIDE, MOUSE_SIZING_COL,
	MOUSE_PREPARE_EDIT,
	MOUSE_PREPARE_DRAG, MOUSE_DRAGGING
	};


};

// Returns the default cell implementation for the given grid region
inline CAsCoolGridCellBase* CAsCoolGridCtrl::GetDefaultCell(BOOL bFixedRow, BOOL bFixedCol) const
{ 
	if (bFixedRow && bFixedCol) return (CAsCoolGridCellBase*) &m_cellFixedRowColDef;
	if (bFixedRow)              return (CAsCoolGridCellBase*) &m_cellFixedRowDef;
	if (bFixedCol)              return (CAsCoolGridCellBase*) &m_cellFixedColDef;

	return (CAsCoolGridCellBase*) &m_cellDefault;
}

inline CAsCoolGridCellBase* CAsCoolGridCtrl::GetCell(int nRow, int nCol) const
{
	if (nRow < 0 || nRow >= m_nRows || nCol < 0 || nCol >= m_nCols) 
		return NULL;

	if (GetVirtualMode())
	{
		CAsCoolGridCellBase* pCell = GetDefaultCell(nRow < m_nFixedRows, nCol < m_nFixedCols);
		static GV_DISPINFO gvdi;
		gvdi.item.row     = nRow;
		gvdi.item.col     = nCol;
		gvdi.item.mask    = 0xFFFFFFFF;
		gvdi.item.nState  = 0;
		gvdi.item.nFormat = pCell->GetFormat();
		gvdi.item.iImage  = pCell->GetImage();
		gvdi.item.crBkClr = pCell->GetBackClr();
		gvdi.item.crFgClr = pCell->GetTextClr();
		gvdi.item.lParam  = pCell->GetData();
		memcpy(&gvdi.item.lfFont, pCell->GetFont(), sizeof(LOGFONT));
		gvdi.item.nMargin = pCell->GetMargin();
		gvdi.item.strText.Empty();

		// Fix the state bits
		if (IsCellSelected(nRow, nCol))   gvdi.item.nState |= GVIS_SELECTED;
		if (nRow < GetFixedRowCount())    gvdi.item.nState |= (GVIS_FIXED | GVIS_FIXEDROW);
		if (nCol < GetFixedColumnCount()) gvdi.item.nState |= (GVIS_FIXED | GVIS_FIXEDCOL);
		if (GetFocusCell() == CAsCoolGridCellID(nRow, nCol)) gvdi.item.nState |= GVIS_FOCUSED;
		if (m_pfnCallback)
			m_pfnCallback(&gvdi, m_lParam);
		else
			SendDisplayRequestToParent(&gvdi);

		static CAsCoolGridCell cell;
		cell.SetState(gvdi.item.nState);
		cell.SetFormat(gvdi.item.nFormat);
		cell.SetImage(gvdi.item.iImage);
		cell.SetBackClr(gvdi.item.crBkClr);
		cell.SetTextClr(gvdi.item.crFgClr);
		cell.SetData(gvdi.item.lParam);
		cell.SetFont(&(gvdi.item.lfFont));
		cell.SetMargin(gvdi.item.nMargin);
		cell.SetText(gvdi.item.strText);
		cell.SetGrid((CAsCoolGridCtrl*)this);

		return (CAsCoolGridCellBase*) &cell;
	}

	GRID_ROW* pRow = m_RowData[nRow];
	if (!pRow)
		return NULL;

	return pRow->GetAt(nCol);
}

inline BOOL CAsCoolGridCtrl::SetCell(int nRow, int nCol, CAsCoolGridCellBase* pCell)
{
	if (GetVirtualMode())
		return FALSE;

	if (nRow < 0 || nRow >= m_nRows || nCol < 0 || nCol >= m_nCols) 
		return FALSE;

	GRID_ROW* pRow = m_RowData[nRow];
	if (!pRow) return FALSE;

	pCell->SetCoords( nRow, nCol); 
	pRow->SetAt(nCol, pCell);

	return TRUE;
}
