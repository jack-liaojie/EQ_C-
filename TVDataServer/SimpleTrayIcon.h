/********************************************************************
created:	2010/06/13
filename: 	SimpleTrayIcon.h
author:		GUAN

purpose:	Implement a simple tray icon function. 
To show or hide the specified dialog from the system taskbar.

Important:	If this simple tray icon is used, then the Message ON_WM_SYSCOMMAND and ON_WM_SHOWWINDOW of the specified dialog 
can not be used as other purpuse any more.

*********************************************************************/

#pragma once

#include "stdafx.h"

#define WM_SIMPLETRAY_MSG	WM_USER+550
#define ID_TRAYMENU_OPEN	40000
#define ID_TRAYMENU_EXIT	40001

#define	SIMPLETRAY_DECLARE \
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam); \
	afx_msg LRESULT OnTrayIconMessage(WPARAM wParam, LPARAM lParam); \
	afx_msg void OnTraymenuOpen(); \
	afx_msg void OnTraymenuExit(); \
	afx_msg void OnShowWindow(BOOL bShow, UINT nStatus); \
	NOTIFYICONDATA NotifyData;\

// This MACRO must be added between BEGIN_MESSAGE_MAP(XXX, XXX) and END_MESSAGE_MAP()
#define	SIMPLETRAY_MESSAGEMAP() \
	ON_MESSAGE(WM_SIMPLETRAY_MSG, OnTrayIconMessage) \
	ON_WM_SYSCOMMAND() \
	ON_WM_SHOWWINDOW() \
	ON_COMMAND(ID_TRAYMENU_OPEN, OnTraymenuOpen) \
	ON_COMMAND(ID_TRAYMENU_EXIT, OnTraymenuExit) \

// Specify theClassName to the specified dialog
#define SIMPLETRAY_IMPLEMENT(theClassName) \
	\
	void theClassName::OnSysCommand(UINT nID, LPARAM lParam) \
				{ \
				if (nID == SC_MINIMIZE || nID == SC_CLOSE) \
					{ \
					CString strPrompt; \
					GetWindowText(strPrompt); \
					ShowWindow(SW_HIDE); \
					ZeroMemory(&NotifyData, sizeof(NOTIFYICONDATA)); \
					NotifyData.cbSize = sizeof(NOTIFYICONDATA); \
					NotifyData.hIcon = GetIcon(true); \
					NotifyData.hWnd = m_hWnd; \
					NotifyData.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP; \
					NotifyData.uCallbackMessage = WM_SIMPLETRAY_MSG; \
					memcpy(NotifyData.szTip, strPrompt.GetBufferSetLength(100), 100); \
					\
					Shell_NotifyIcon(NIM_ADD, &NotifyData); \
					} \
					else \
					{ \
					CDialog::OnSysCommand(nID, lParam); \
					} \
				} \
				\
				void theClassName::OnShowWindow(BOOL bShow, UINT nStatus) \
				{ \
				CDialog::OnShowWindow(bShow, nStatus); \
				Shell_NotifyIcon(NIM_DELETE, &NotifyData); \
				} \
				\
				void theClassName::OnTraymenuOpen() \
				{ \
				ShowWindow(SW_NORMAL); \
				SetForegroundWindow(); \
				} \
				\
				void theClassName::OnTraymenuExit() \
				{ \
				Shell_NotifyIcon(NIM_DELETE, &NotifyData); \
				EndDialog(IDOK); \
				} \
				\
				LRESULT theClassName::OnTrayIconMessage(WPARAM  wParam, LPARAM lParam) \
				{ \
				if (lParam == WM_LBUTTONDBLCLK) \
					{ \
					OnTraymenuOpen(); \
					} \
					else if (lParam == WM_RBUTTONUP) \
					{ \
					POINT pt; \
					GetCursorPos(&pt); \
					\
					CMenu menu; \
					menu.CreatePopupMenu(); \
					menu.AppendMenu(MF_STRING, ID_TRAYMENU_OPEN, _T("Open")); \
					menu.AppendMenu(MF_STRING, ID_TRAYMENU_EXIT, _T("Exit")); \
					\
					menu.TrackPopupMenu(TPM_LEFTALIGN|TPM_LEFTBUTTON, pt.x, pt.y, this); \
					} \
					return 0; \
				}; 


