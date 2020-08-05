
#pragma once

#include "TVDiscipline.h"
#include "TVSession.h"
#include "TVEvent.h"
#include "TVPublicDef.h"
#include "TVTableSessionSts.h"

// Default values for export
#define DEF_EXPORT_MAXOPENRETRIES		8
#define DEF_EXPORT_DELAYOPEN			200
#define DEF_EXPORT_DELAYGLOBALRETRY		4000
#define DEF_EXPORT_TIMEALIVE			(15*1000)

typedef struct {
	ULONG nExportedOk;      // Number of the times that data has been successfully
	// exported
	ULONG nGrdRetries;      // Number of opening retries made over guard file
	ULONG nGrdBusy;         // Number of times that guard file was permanent
	// busy after all retries
	ULONG nGrdFails;        // Number of errors in guard file other than access
	// denied
	ULONG nDataRetries;     // Number of opening retries made over a data file
	ULONG nDataBusy;        // Number of times that a data file was permanent
	// busy after all retries
	ULONG nDataFails;       // Number of errors in a data file other than access
	// denied
	ULONG nCloseSharedOk;   // Number of times that shared files were closed
	// successfully by the server
	ULONG nCloseSharedFail; // Number of times that shared files could not be
	// closed
} EXPORT_STATS;


//////////////////////////////////////////////////////////////////////////
//Class CTVExportManger
class CTVExportManger
{
public:
	CTVExportManger();
	~CTVExportManger();
	
	BOOL StartExportService(CTVDiscipline* pRootDiscipline,CCriticalSection* pCSData,CEvent* pEventQueueEmpty);
	void StopExportService();

	//for thread export notify, call this only after thread has been created 
	CWinThread* GetExportThread(){return m_pExportThread;}

private:
	//open file functions
	//returns NO_ERROR(0L) if data was successfully exported
	int OpenExportFile(CString strFileName,CAxStdioFileEx* pFile,BOOL bGrdFile = FALSE);
	//open export file with closing connection tries
	BOOL OpenExportFileEx(CString strFileName, CString strPathName, CAxStdioFileEx* pFile,BOOL bGrdFile = FALSE);
	//returns NO_ERROR(0L) if file(s) was successfully closed
	int CloseAllSharedOpenedFiles(CString strPathToClose);

	//export table/file functions
	BOOL ExportTable(CTVTable* pTable);
	BOOL ExportSTSFile(CTVTableSessionSts* pTable);
	BOOL WriteGuardFileAndClose(CAxStdioFileEx* pFile,CTVEvent* pNode, BOOL bFatalError = FALSE);

	//export node functions
	BOOL ExportNode(CTVNodeBase* pNode);
	BOOL ExportEventNode(CTVEvent* pNode);

	//export tree functions
	BOOL ExportTree(CTVNodeBase* pNode);

	//alive file functions
	BOOL AliveGRDFile(CTVEvent* pEvent);
	BOOL AliveSTSFile(CTVNodeBase* pNode);
	CTVTableSessionSts* GetNodeSTSFile(CTVNodeBase* pNode);
	BOOL AliveFilesFromNode(CTVNodeBase* pNode);

	//thread functions
	static UINT staticThreadProc(LPVOID pParam);
	UINT ThreadProc();
	BOOL CreateExportThread();
	void DestroyExportThread();

	//log function
	enum ELogType	
	{
		emLogExportOk = 0,
		emLogExportError,
		emLogAlive,
		emLogThread
	};
	void OutputMessage(CString strMsg,ELogType emLogType = emLogExportOk);

private:
	CTVDiscipline*		m_pRootDiscipline;
	EXPORT_STATS		m_sExportStats;
	CCriticalSection*	m_pCSData;// pointer to cs for tv data tree access
	CEvent*				m_pEventQueueEmpty;// pointer to event for empty msg queue notify 

	CWinThread*			m_pExportThread;

	BOOL				m_bOutputOkLog;
	BOOL				m_bOutputErrorLog;
	BOOL				m_bOutputAliveLog;
	BOOL				m_bOutputThreadLog;
};
