
// InitialDownLoadDlg.h : ͷ�ļ�
//

#pragma once

#include "ImportXLS.h"

// CInitialDownLoadDlg �Ի���
class CInitialDownLoadDlg : public CDialogEx
{
// ����
public:
	CInitialDownLoadDlg(CWnd* pParent = NULL);	// ��׼���캯��

// �Ի�������
	enum { IDD = IDD_INITIALDOWNLOAD_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV ֧��


// ʵ��
protected:
	HICON m_hIcon;

	// ���ɵ���Ϣӳ�亯��
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnBtnOpenXLSData();
	afx_msg void OnBtnCleanAthletes();
	afx_msg void OnBtnImportAthletes();
	afx_msg void OnBnExportAthletes();
	afx_msg void OnBtnImportUnOfficals();
	afx_msg void OnBnExportOfficals();
	afx_msg void OnSize(UINT nType, int cx, int cy);
	DECLARE_MESSAGE_MAP()

	BOOL GetWorkSheets(CString strXLSName, CStringArray& arySheets);
	BOOL Write2Sheet(CString strXLSName, CAxADORecordSet& recordSet);

	BOOL CreateAthletesGrid();
	BOOL DisciplineExists();

protected:
	CString			m_strFilePath;
	CString			m_strSheetName;

	CComboBox		m_cbWorkSheets;
	CAsCoolGridCtrl	m_gridAthletes;

	CString         m_strDiscipline;
	int             m_nDisciplineID;
	CRect			m_rect;

private:
	void ReSize(int nID, int cx, int cy);
public:
	afx_msg void OnBnClickedBtnRefresh();
};
