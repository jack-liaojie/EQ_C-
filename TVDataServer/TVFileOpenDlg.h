#pragma once

#include "TVTable.h"

// CTVFileOpenDlg dialog

class CTVFileOpenDlg : public CDialog
{
	DECLARE_DYNAMIC(CTVFileOpenDlg)

public:
	CTVFileOpenDlg(CWnd* pParent = NULL);
	virtual ~CTVFileOpenDlg();

	enum { IDD = IDD_DLG_TVFILE_OPEN };

protected:
	virtual void DoDataExchange(CDataExchange* pDX); 
	virtual BOOL OnInitDialog();
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	afx_msg void OnDestroy();	
	afx_msg void OnSize(UINT nType, int cx, int cy);
	DECLARE_MESSAGE_MAP()

private:
	CTVTable*			m_pTVTable;

	CAsCoolGridCtrl		m_TVFileGrid;

	SAxTableRecordSet	m_DBRecordSet;
	SAxTableRecordSet	m_TVTableRecordSet;

	void CreateTVFileGrid();

	void ReloadTVFile();

	BOOL FillTVTableGridCtrl(CAsCoolGridCtrl* pGridCtrl, SAxTableRecordSet& rsTable, BOOL bColorRow = TRUE, COLORREF clrOddRow = OVR_GRID_ODD_ROW_COLOR, COLORREF clrEvenRow = OVR_GRID_EVEN_ROW_COLOR, LOGFONT* lgHeaderFont = NULL, LOGFONT* lgCellTextFont = NULL);

	// Import File
	CString OpenFileToStr(CString strFullFileName);
	static BOOL ParseFileToTable(CString strText, SAxTableRecordSet &sRecordSet);
	static CString DecodeTextToCString(LPBYTE lpByte, int nLen); // Trans ASCII, UNICODE, UTF-8 to CString
	static BOOL IsUTF8(LPVOID lpBuffer, long size);

public:

	void SetTVTable(CTVTable *pTVTable); // Must call before show the dialog

};
