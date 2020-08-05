//////////////////////////////////////////////////////////////////////////
// File Name: NetworkTrans.cpp
// Date     : 2008.12.07
// Author   : YYH
//////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "NetworkTrans.h"


//////////////////////////////////////////////////////////////////////////
// CSocketBuffer

#define  RECEIVE_BUFFER_SIZE	4096

IMPLEMENT_DYNAMIC(CSocketBuffer, CObject);

CSocketBuffer::CSocketBuffer()
{
	m_pBuffer = NULL;
	m_pCurPtr = NULL;
	m_dwBytes = 0;
	m_dwBytesLeft = 0;
}

CSocketBuffer::CSocketBuffer(const CSocketBuffer &ob)
{
	m_pBuffer = NULL;
	m_pCurPtr = NULL;
	m_dwBytes = 0;
	m_dwBytesLeft = 0;

	*this = ob;
}
CSocketBuffer::~CSocketBuffer()
{
	if (m_pBuffer) GlobalFree(m_pBuffer);
}

CSocketBuffer& CSocketBuffer::operator = (const CSocketBuffer& ob)
{
	if(AllocBuffer(ob.m_dwBytes))
		memcpy(m_pBuffer, ob.m_pBuffer, ob.m_dwBytes);

	return *this;
}

BOOL CSocketBuffer::AllocBuffer(DWORD dwBytes)
{
	// Current buffer can be reused
	if (m_pBuffer && dwBytes == m_dwBytes) 
	{
		m_pCurPtr = m_pBuffer;
		m_dwBytesLeft = dwBytes;
		return TRUE;
	}

	// Free current buffer
	if (m_pBuffer) 
	{
		GlobalFree(m_pBuffer);
		m_pBuffer = NULL;
		m_pCurPtr = NULL;
		m_dwBytes = 0;
		m_dwBytesLeft = 0;
	}	

	// Allocate new buffer
	m_pBuffer = (LPBYTE)GlobalAlloc(GPTR, dwBytes);
	if (m_pBuffer == NULL)
	{
		TRACE("Socket buffer allocation failed.\n");
		return FALSE;
	}

	// Reset params
	m_pCurPtr = m_pBuffer;
	m_dwBytes = dwBytes;
	m_dwBytesLeft = dwBytes;
	return TRUE;
}

void CSocketBuffer::ReleaseBuffer()
{
	if (m_pBuffer) 
	{
		GlobalFree(m_pBuffer);
		m_pBuffer = NULL;
		m_pCurPtr = NULL;
		m_dwBytes = 0;
		m_dwBytesLeft = 0;
	}	
}

//////////////////////////////////////////////////////////////////////////
// CNetworkSocket

IMPLEMENT_DYNAMIC(CNetworkSocket, CObject);

CNetworkSocket::CNetworkSocket(CNetworkTranscv* pTranscv)
{
	m_pTranscv = pTranscv;
}

CNetworkSocket::~CNetworkSocket()
{
}

void CNetworkSocket::OnAccept(int nErrorCode)
{
	CAsyncSocket::OnAccept(nErrorCode);

	m_pTranscv->OnSocketAccept(this, nErrorCode);
}

void CNetworkSocket::OnConnect(int nErrorCode)
{
	CAsyncSocket::OnConnect(nErrorCode);

	m_pTranscv->OnSocketConnect(this, nErrorCode);
}

void CNetworkSocket::OnSend(int nErrorCode)
{
	CAsyncSocket::OnSend(nErrorCode);

	m_pTranscv->OnSocketSend(this, nErrorCode);
}

void CNetworkSocket::OnReceive(int nErrorCode)
{
	CAsyncSocket::OnReceive(nErrorCode);

	m_pTranscv->OnSocketReceive(this, nErrorCode);
}

void CNetworkSocket::OnClose(int nErrorCode)
{
	CAsyncSocket::OnClose(nErrorCode);

	m_pTranscv->OnSocketClose(this, nErrorCode);
}

//////////////////////////////////////////////////////////////////////////
// CNetworkTranscv

IMPLEMENT_DYNAMIC(CNetworkTranscv, CObject);

CNetworkTranscv::CNetworkTranscv()
{
	// Create GUID string as ID of this object
	GUID guid;
	CoCreateGuid(&guid);
	TCHAR szBuf[100];
	StringFromGUID2(guid, szBuf, 100);

	m_strTranscvID = szBuf;

	m_nTimeOut = 3000;

	m_sTcpKeepalive.onoff = 1;
	m_sTcpKeepalive.keepalivetime = 1000;
	m_sTcpKeepalive.keepaliveinterval = 1000;

	m_pLsnSocket = NULL;
	m_bCanRead   = FALSE;
}

CNetworkTranscv::~CNetworkTranscv()
{
	SocketCloseAll();
}

BOOL CNetworkTranscv::ListenAt(UINT nPort, LPCTSTR pszAddress /* = NULL */)
{
	try
	{
		if(m_pLsnSocket != NULL)
			SocketClose(m_pLsnSocket);

		m_pLsnSocket = new CNetworkSocket(this);
		ASSERT(m_pLsnSocket != NULL);

		// Create socket and bind it to the given port and address (can be NULL)
		if (!m_pLsnSocket->Create(nPort, SOCK_STREAM, FD_READ|FD_WRITE|FD_OOB|FD_ACCEPT|FD_CONNECT|FD_CLOSE, pszAddress))
		{
			TRACE("Socket Create() failed, err = %d\n", CAsyncSocket::GetLastError());
			throw -1;
		}

		// Start listening to the client connection requests
		if (!m_pLsnSocket->Listen())
		{
			TRACE("Socket Listen() failed, err = %d\n", CAsyncSocket::GetLastError());
			throw -1;
		}
	}
	catch (int e) 
	{
		UNREFERENCED_PARAMETER(e);

		delete m_pLsnSocket;
		m_pLsnSocket = NULL;

		return FALSE;
	}
	return TRUE;
}

BOOL CNetworkTranscv::SocketOpen(UINT nPort, LPCTSTR pszAddress, int nSockType /* = SOCK_STREAM */, BOOL bSynchOpen /* = FALSE*/)
{
	CNetworkSocket* pSocket = new CNetworkSocket(this);
	ASSERT(pSocket != NULL);

	m_aSockets.Add(pSocket);
	try
	{
		if (nSockType == SOCK_STREAM) // TCP
		{
			// Create socket and bind it to default port and address
			if (!pSocket->Create())
			{
				TRACE("Socket Create() failed, err = %d\n", CAsyncSocket::GetLastError());
				throw -1;
			}

			// Connect to server at the given port and address
			if (pSocket->Connect(pszAddress, nPort))
			{
				// Succeeded, sync notify the app, since the TRUE return value does not mean the connection succeeds
				OnTranscvConnected(pSocket);

				SetKeepAlive(m_sTcpKeepalive.onoff, m_sTcpKeepalive.keepalivetime, m_sTcpKeepalive.keepaliveinterval, pSocket);
			}
			else
			{
				// If the connection does not succeed when the function returns, either we need to wait for
				// the socket's OnConnect() to be called if the err is WSAEWOULDBLOCK, or it is a real failure.
				if (CAsyncSocket::GetLastError() == WSAEWOULDBLOCK)
				{
					TRACE("Client socket connection to server can not complete immediately.\n");

					// synchronize connect
					if (bSynchOpen)
					{
						int nResult = WaitForEvent(pSocket);

						if (nResult == 0) // OK
						{
							return TRUE;
						}
						else
						{
							OnTranscvFailure(pSocket, nResult, transcv_fail_connect);
							throw -1;							
						}
					}
				}
				else // The connection failed
				{
					throw -1;
				}
			}
		} 
		else // UDP
		{
			if (!pSocket->Create(nPort, SOCK_DGRAM, FD_READ|FD_WRITE|FD_OOB|FD_ACCEPT|FD_CONNECT|FD_CLOSE, pszAddress))
			{
				throw -1;
			}
		}
	}
	catch (int e) 
	{
		UNREFERENCED_PARAMETER(e);

		SocketClose(pSocket);		

		return FALSE;
	}

	return TRUE;
}

void CNetworkTranscv::SocketClose(CNetworkSocket* pSocket)
{
	if (pSocket == NULL)
		return;

	if (pSocket == m_pLsnSocket)
	{
		m_pLsnSocket->Close();
		delete m_pLsnSocket;
		m_pLsnSocket = NULL;
		return;
	}

	for (int i=0; i<(int)m_aSockets.GetCount(); i++)
	{
		if (pSocket == m_aSockets[i])
		{
			m_aSockets[i]->Close();
			delete m_aSockets[i];
			m_aSockets.RemoveAt(i);
			return;
		}
	}
}

void CNetworkTranscv::SocketCloseAll()
{
	// Close main socket
	if (m_pLsnSocket)
	{
		m_pLsnSocket->Close();
		delete m_pLsnSocket;
		m_pLsnSocket = NULL;
	}

	// Close accepted sockets
	for (int i=0; i<(int)m_aSockets.GetCount(); i++)
	{
		m_aSockets[i]->Close();
		delete m_aSockets[i];
	}
	m_aSockets.RemoveAll();
}

int  CNetworkTranscv::GetSocketCount()
{
	return (int)m_aSockets.GetCount();
}

CNetworkSocket* CNetworkTranscv::GetSocketAt(int nIndex)
{
	if (nIndex < 0 || nIndex >= m_aSockets.GetCount())
		return NULL;

	return m_aSockets[nIndex];
}

CNetworkSocket* CNetworkTranscv:: GetSocketFromPeerName(UINT nPeerPort, CString strPeerAddress)
{
	UINT nPort;
	CString strAddr;
	for (int i=0; i<m_aSockets.GetCount(); i++)
	{
		m_aSockets[i]->GetPeerName(strAddr, nPort);
		if (strAddr == strPeerAddress && nPort == nPeerPort)
			return m_aSockets[i];
	}
	return NULL;
}

int  CNetworkTranscv::SocketIndex(CNetworkSocket* pSocket)
{
	for (int i=0; i<(int)m_aSockets.GetCount(); i++)
	{
		if (pSocket == m_aSockets[i])
			return i;
	}
	return -1;
}

void CNetworkTranscv::SetKeepAlive(u_long uOnOff, u_long uTime, u_long uInterval, CNetworkSocket* pSocket /* = NULL*/)
{
	tcp_keepalive sKeepAlive;
	sKeepAlive.onoff = uOnOff;

	m_sTcpKeepalive.onoff = uOnOff;
	m_sTcpKeepalive.keepalivetime = uTime;
	m_sTcpKeepalive.keepaliveinterval = uInterval;

	tcp_keepalive outKeepAlive = {0};
	DWORD dwSize = sizeof(tcp_keepalive);
	DWORD dwOutBuffer = 0;

	if (pSocket == NULL)
	{
		for (int i=0; i<(int)m_aSockets.GetCount(); i++)
		{
			::WSAIoctl((m_aSockets[i])->m_hSocket, SIO_KEEPALIVE_VALS, (LPVOID)&m_sTcpKeepalive, 
				dwSize, (LPVOID)&outKeepAlive, dwSize,	&dwOutBuffer, NULL, NULL);
		}
	} 
	else
	{
		::WSAIoctl(pSocket->m_hSocket, SIO_KEEPALIVE_VALS, (LPVOID)&m_sTcpKeepalive, 
			dwSize, (LPVOID)&outKeepAlive, dwSize,	&dwOutBuffer, NULL, NULL);
	}
}

void CNetworkTranscv::OnSocketAccept(CNetworkSocket* pSocket, int nErrorCode)
{
	ASSERT_VALID(pSocket);
	ASSERT(pSocket == m_pLsnSocket);
	UNREFERENCED_PARAMETER(pSocket);

	// If there is an error
	if (nErrorCode)
	{
		TRACE("Socket OnAccept() gets error %d\n", nErrorCode);

		OnTranscvFailure(m_pLsnSocket, nErrorCode, transcv_fail_connect);

		return;
	}

	// Create a receiving socket to accept this connection request.
	// The receiving socket then starts to receive.
	CNetworkSocket* pConnSock = new CNetworkSocket(this);
	if (m_pLsnSocket->Accept(*pConnSock))
	{
		m_aSockets.Add(pConnSock);

		TRACE("One client connection is accepted by the server.\n");

		OnTranscvConnected(pConnSock);

		SetKeepAlive(m_sTcpKeepalive.onoff, m_sTcpKeepalive.keepalivetime, m_sTcpKeepalive.keepaliveinterval, pConnSock);
	}
	else // error
	{
		int err = CAsyncSocket::GetLastError();
		TRACE("One client connection is NOT accepted by the server. err = %d\n", err);

		delete pConnSock;

		OnTranscvFailure(m_pLsnSocket, err, transcv_fail_connect);
	}
}

void CNetworkTranscv::OnSocketConnect(CNetworkSocket* pSocket, int nErrorCode)
{
	ASSERT_VALID(pSocket);

	// Connection succeeded
	if (nErrorCode == 0)
	{
		OnTranscvConnected(pSocket);

		SetKeepAlive(m_sTcpKeepalive.onoff, m_sTcpKeepalive.keepalivetime, m_sTcpKeepalive.keepaliveinterval, pSocket);
	}
}

void CNetworkTranscv::OnSocketSend(CNetworkSocket* pSocket, int nErrorCode)
{
	// This happens when the asynchronous socket is notified to continue sending data
	// after a previous send call returns WSAEWOULDBLOCK. 
	// This function is also called in SendNetworkData() to initiate the sending.
	ASSERT_VALID(pSocket);

	// If there is an error
	if (nErrorCode)
	{
		TRACE("Socket OnSend() gets an error %d\n", nErrorCode);

		OnTranscvFailure(pSocket, nErrorCode, transcv_fail_send);

		return;
	}

	// We keep on sending data until data is all sent or an error occurs
	CSocketBuffer oBuffer;

	while(1) 
	{
		// If we do not have a buffer yet...
		if (oBuffer.m_pBuffer == NULL)
		{
			// The socket's sending queue is now empty, nothing more to send
			if (pSocket->m_lstSendBuffers.IsEmpty())
				return;

			// Next buffer to send
			oBuffer = pSocket->m_lstSendBuffers.GetHead();
			ASSERT(oBuffer.m_pBuffer);
		}

		// Try to send all the remaining data in the buffer
		int r = pSocket->Send(oBuffer.m_pCurPtr, oBuffer.m_dwBytesLeft);
		if (r == SOCKET_ERROR)
		{
			int err = CAsyncSocket::GetLastError();
			if (err == WSAEWOULDBLOCK)
			{
				TRACE("Socket Send() returns WSAEWOULDBLOCK, need to wait next OnSend() notifcation to continue sending.\n");
			}
			else // Network failure
			{
				TRACE("Network error occured when sending data. err = %d\n", err);

				OnTranscvFailure(pSocket, err, transcv_fail_send);
			}
			return; // break out to wait for next OnSend() notification or next SendNetworkData() call.
		}

		// Update the data ptr/size in the buffer
		ASSERT(r <=  (int)oBuffer.m_dwBytesLeft);
		oBuffer.m_pCurPtr += r;
		oBuffer.m_dwBytesLeft -= r;

		// All data in the buffer has been sent, remove it from the queue
		if (oBuffer.m_dwBytesLeft == 0)
		{
			pSocket->m_lstSendBuffers.RemoveHead();
			oBuffer.ReleaseBuffer();
		}
	}
}

void CNetworkTranscv::OnSocketReceive(CNetworkSocket* pSocket, int nErrorCode)
{
	// This function is called when a socket is notified that there is data for it to receive.
	ASSERT_VALID(pSocket);

	// If there is an error
	if (nErrorCode)
	{
		TRACE("Socket OnReceive() gets an error %d\n", nErrorCode);

		OnTranscvFailure(pSocket, nErrorCode, transcv_fail_receive);

		return;
	}

	LPBYTE lpBuffer = new BYTE[RECEIVE_BUFFER_SIZE];
	ZeroMemory(lpBuffer, RECEIVE_BUFFER_SIZE);

	// Receive data from the socket to the current position inside the buffer
	int nRetSize = pSocket->Receive(lpBuffer, RECEIVE_BUFFER_SIZE);
	if (nRetSize == SOCKET_ERROR)
	{
		int err = CAsyncSocket::GetLastError();
		if (err == WSAEWOULDBLOCK)
		{
			TRACE("Socket Receive() returns WSAEWOULDBLOCK, need to wait next OnReceive() notifcation to continue receiving.\n");
		}
		else // Network failure
		{
			OnTranscvFailure(pSocket, nErrorCode, transcv_fail_receive);

			TRACE("Network error occured when receiving data. err = %d\n", err);
		}
		return;
	}

	// Process the received data
	OnReceiveXmlMsg(pSocket, WPARAM(nRetSize), LPARAM(lpBuffer));

	delete []lpBuffer;
}

void CNetworkTranscv::OnSocketClose(CNetworkSocket* pSocket, int nErrorCode)
{
	// This function is called when a socket's connection is closed on the other end.
	ASSERT_VALID(pSocket);

	// Close succeeded
	if (nErrorCode == 0)
	{
		TRACE("Socket OnClose() reports success.\n");
	}
	else // If there is an error
	{
		TRACE("Socket OnClose() reports failure. err = %d.\n", nErrorCode);

		OnTranscvFailure(pSocket, nErrorCode, transcv_fail_disconnect);
	}

	OnTranscvDisconnected(pSocket);

	// Close the socket
	SocketClose(pSocket);
}

BOOL CNetworkTranscv::SendNetworkData(CNetworkSocket* pSocket, WPARAM wParam, LPARAM lParam)
{
	CSocketBuffer oSocketBuf;
	if(!oSocketBuf.AllocBuffer( (DWORD)wParam ))
		return FALSE;

	memcpy(oSocketBuf.m_pBuffer, (LPVOID)lParam, wParam);

	pSocket->m_lstSendBuffers.AddTail(oSocketBuf);
	OnSocketSend(pSocket, 0);

	return TRUE;
}

BOOL CNetworkTranscv::SendNetworkData(CNetworkSocket* pSocket, CSocketBuffer &oSocketBuf)
{
	pSocket->m_lstSendBuffers.AddTail(oSocketBuf);
	OnSocketSend(pSocket, 0);

	return TRUE;
}


int CNetworkTranscv::WaitForEvent(CNetworkSocket* pSocket)
{
	AFX_MODULE_THREAD_STATE* pState = AfxGetModuleThreadState();

	ASSERT(pState->m_hSocketWindow != NULL);

	CWinThread* pThread = AfxGetThread();

	UINT_PTR nTimerID = ::SetTimer(pState->m_hSocketWindow, 1, m_nTimeOut, NULL);

	int nResult = 0;

	while (TRUE)
	{
		MSG msg;

		if (::PeekMessage(&msg, pState->m_hSocketWindow,
			WM_SOCKET_NOTIFY, WM_SOCKET_DEAD, PM_REMOVE))
		{
			if (msg.message == WM_SOCKET_NOTIFY && (SOCKET)msg.wParam == pSocket->m_hSocket )
			{
				if (WSAGETSELECTEVENT(msg.lParam) == FD_CONNECT)
				{	
					nResult = WSAGETSELECTERROR(msg.lParam);
					::DispatchMessage(&msg);						
					break;
				}
			}
		}
		else if (::PeekMessage(&msg, pState->m_hSocketWindow,
			WM_TIMER, WM_TIMER, PM_REMOVE))
		{
			nResult = WSAETIMEDOUT;
			break;
		}

		if (::PeekMessage(&msg, NULL, 0, 0, PM_NOREMOVE))
		{
			if (::PeekMessage(&msg, NULL, WM_PAINT, WM_PAINT, PM_REMOVE))
				::DispatchMessage(&msg);
			else
				pThread->OnIdle(-1);
		}
		else
		{
			// no work to do -- allow CPU to sleep
			WaitMessage();
		}
	
	}

	::KillTimer(pState->m_hSocketWindow, nTimerID);

	return nResult;
}
