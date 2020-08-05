/********************************************************************
created:	2010/01/07
filename: 	DataSpliter.h

author:		GRL
*********************************************************************/

#pragma once

#include "..\stdafx.h"

typedef int (*SPLITERCALLBACK)(LPBYTE lpFrame, int nFrameSize, LPVOID lpParam);

class CDataSpliter
{
	DECLARE_THREAD_SAFETY;
public:
	CDataSpliter(void);
	~CDataSpliter(void);

	// Action define
	void SetSplitMark(LPBYTE lpBeginMark, int nBeginMarkSize, LPBYTE lpEndMark, int nEndMarkSize); // Both begin and end mark
	void SetSplitMark(LPBYTE lpBeginMark, int nBeginMarkSize); // Only begin mark.(the frame size was stored in the 4 bytes UINT following the begin mark) 
	void SetCallBack(SPLITERCALLBACK pCallBackFunc, LPVOID lpParam = NULL, BOOL bCreateBufferThread = FALSE);
	void SetCallBack(HWND hWndRecvMsg, UINT nMsgID, BOOL bCreateBufferThread = FALSE); // WPARAM: lpFrame, LPARAM: nFrameSize
	void NeedSplitMark(BOOL bNeedSplitMark) {m_bNeedSplitMark = bNeedSplitMark;}; // default bNeedSplitMark=FALSE : In call-back function, the frame don't include split mark

	// This 2 functions allow copy data to the buffer directly, must be call in pair, otherwise, the thread maybe locked. 
	// careful to use before the blocking mode function(ex. synchronous socket receive function)
	LPBYTE GetWritableBlock(int &nBlockSize);
	void   SetWrittenBlock(LPBYTE lpBlockPos, int nBlockSize); // lpBlockPos is the return value of GetWritableBlock(). nBlockSize is actually written size

	void FillData(LPBYTE lpData, int nSize);
	void ProcessData(); // If data has been copy to buffer, can call this directly
	long GetDataSize();

private:

	// Data Frame Format local-storage
	LPBYTE	m_lpBeginMark;
	LPBYTE	m_lpEndMark;
	int		m_nBeginMarkSize;
	int		m_nEndMarkSize;
	BOOL	m_bHasEndMark;

	// Buffer info
	LPBYTE	m_lpBuffer;
	int		m_nBufSzie;
	LPBYTE	m_lpDataBeginPos;   // Valid-data begin position
	LPBYTE	m_lpDataEndPos;		// Valid-data size	

	// Frame parse
	LPBYTE	m_lpFrameBeginPos; // Begin position of 1 frame in the buffer
	LPBYTE	m_lpProcessBeginPos;

	// Outside Communication
	BOOL			m_bNeedSplitMark;
	SPLITERCALLBACK m_pCallBackFunc;
	LPVOID			m_lpCallBackParm;
	HWND			m_hWndRecvMsg;
	UINT			m_nMsgID;

private:
	void ClearData();
	void DeleteBuffer();
	BOOL ZoomBuffer(int nNewBufSize); // Alloc a larger buffer and keep the old data
	void ValidateBuffer(int nAddSize);
	void MoveDataToBufferHead();

	void CacheReceiveData(LPBYTE lpData, int nSize);
	void ProcessDataWithEnd();
	void ProcessDataNoEnd();
	void DoCallBackFunc(LPBYTE lpFrameSrc, int nFrameSize);

	void RemoveSplitMark();
	BOOL IsBeginMark(LPBYTE lpCheckPos);
	BOOL IsEndMark(LPBYTE lpCheckPos);

	BOOL IsSettingValid();

	//////////////////////////////////////////////////////////////////////////
	// Thread control 
private:
	CWinThread* m_pThread;
	HANDLE m_hEventCanStart; // Indicate the work thread can start send WM_USER_ADD_MSG message

	BOOL CreateWorkThread();
	void DestroyWorkThread();
	static UINT ThreadProc(LPVOID pParam);

};
