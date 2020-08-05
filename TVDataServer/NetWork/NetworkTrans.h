/////////////////////////////////////////////////////////////////////////////
// File Name: NetworkTrans.h
// Date     : 2009.01.08
// Author   : YYH
/////////////////////////////////////////////////////////////////////////////

#pragma once

// #define NETWORK_EXP __declspec (dllexport)

#include <afxsock.h>
#include <MSTcpIP.h>

// Send/Receive data buffer object
class CSocketBuffer : public CObject
{
	DECLARE_DYNAMIC(CSocketBuffer);
public:
	CSocketBuffer();
	CSocketBuffer(const CSocketBuffer &ob);	// Copy the buffer
	~CSocketBuffer();

public:
	CSocketBuffer& operator = (const CSocketBuffer &ob);	// Copy the buffer

	BOOL AllocBuffer(DWORD dwBytes);

	void ReleaseBuffer();

public:
	LPBYTE m_pBuffer;
	LPBYTE m_pCurPtr;
	DWORD m_dwBytes;		// Bytes of the buffer
	DWORD m_dwBytesLeft;	// Bytes behind m_pCurPtr
};

class CNetworkTranscv;

// Socket used by CNetworkTranscv
class CNetworkSocket : public CAsyncSocket
{
	friend class CNetworkTranscv;

	DECLARE_DYNAMIC(CNetworkSocket);

public:
	CNetworkSocket(CNetworkTranscv* pTranscv);

	virtual ~CNetworkSocket();

protected:
	virtual void OnAccept(int nErrorCode);
	virtual void OnConnect(int nErrorCode);
	virtual void OnSend(int nErrorCode);
	virtual void OnReceive(int nErrorCode);
	virtual void OnClose(int nErrorCode);

protected:
	CNetworkTranscv* m_pTranscv;

	CList<CSocketBuffer> m_lstSendBuffers;
};

// Callback called by CNetworkTranscv when receiving the render command
enum
{
	transcv_fail_connect = 0,    // client connect to server failed.
	transcv_fail_disconnect,     // connection close between sockets failed 
	transcv_fail_send,           // socket write failed 
	transcv_fail_receive,        // socket read failed 
};

// Communication object used by the platform server and client app.
// Call AfxSocketInit() before using this class.
class CNetworkTranscv : public CObject
{
	friend class CNetworkSocket;
	DECLARE_DYNAMIC(CNetworkTranscv);
public:
	CNetworkTranscv();
	virtual ~CNetworkTranscv();

public:
	// Start listen at the specified port
	BOOL ListenAt(UINT nPort, LPCTSTR pszAddress = NULL);

	// For TCP socket, this function tries to connect to a server specified by nPort and pszAddress.
	// If bSynchOpen specifies the connection is synchronized or not. 
	// Synchronized connection returns when the connection finished.
	// If the connection succeeds synchronizingly, OnTranscvConnected callback is called.
	// If the connection needs to be finished asynchronizingly, the function returns succeeded, 
	// and OnTranscvConnected callback will be called when the connection succeeds.
	// If the connection fails immediately, the function returns failed.
	// For UDP socket, the nPort and pszAddress is of local machine, 
	// pszAddress can be NULL to use default IP address of local machine, but if the
	// machine has multiple network cards, then it's necessary to specify one IP.
	// it returns the index of the socket if succeed, else returns -1.
	BOOL  SocketOpen(UINT nPort, LPCTSTR pszAddress, int nSockType = SOCK_STREAM, BOOL bSynchOpen = TRUE);

	// Close the specified socket, it could be m_pLsnSocket or any one in m_aSockets
	void SocketClose(CNetworkSocket* pSocket);

	// Close all sockets
	void SocketCloseAll();

	int  GetSocketCount();
	int  SocketIndex(CNetworkSocket* pSocket);
	CNetworkSocket* GetSocketAt(int nIndex);
	CNetworkSocket* GetSocketFromPeerName(UINT nPeerPort, CString strPeerAddress);
	CNetworkSocket* GetListenSock(){return m_pLsnSocket;};

	// Send network data to socket connected to pSocket.
	// wParam specifies the length of data, lParam points to the data being sent.
	BOOL SendNetworkData(CNetworkSocket* pSocket, WPARAM wParam, LPARAM lParam);

	BOOL SendNetworkData(CNetworkSocket* pSocket, CSocketBuffer &oSocketBuf);

	void SetKeepAlive(u_long uOnOff, u_long uTime, u_long uInterval, CNetworkSocket* pSocket = NULL);

// Network callback function, overridable
public:
	// For following functions 
	// pSocket -  on server side, it is one of the sockets connected to one of the clients.
	//            on client side, it is always the client's socket connected to the server.

	// For a server, this function is called when the server accepted the connection request from a client. 
	// pSocket is the server's socket that has just been connected to the client.
	// For a client, this function is called when a client's connection to a server issued by
	// CNetworkTranscv::Connect() has been executed successfully. pSocket is the client's socket
	// that has just been connected to the server.
	virtual void OnTranscvConnected(CNetworkSocket* pSocket) { };

	// This function is called when a remote connection to this transceiver's socket has been closed.
	// pSocket - the socket whose connection has been closed.
	virtual void OnTranscvDisconnected(CNetworkSocket* pSocket) { };

	// This function is called when the transceiver detects a network error. 
	// pSocket - the socket that suffers the error.
	// nErrorCode - the socket error code WSAE... or E_OUTOFMEMORY or E_INVALIDARG (received invalid data).
	// nCause - transcv_fail_XXX enum defined above.
	virtual void OnTranscvFailure(CNetworkSocket* pSocket, int nErrorCode, int nCause) { };

	// This function is called when the transceiver received a XML message. 
	// pSocket - the socket that received the message.
	// wParam - [DWORD] Length of data.
	// lParam - [LPBYTE] Point to the buffer of data received.
	virtual void OnReceiveXmlMsg(CNetworkSocket* pSocket, WPARAM wParam, LPARAM lParam) { };

protected:
	void OnSocketAccept(CNetworkSocket* pSocket, int nErrorCode);
	void OnSocketConnect(CNetworkSocket* pSocket, int nErrorCode);
	void OnSocketSend(CNetworkSocket* pSocket, int nErrorCode);
	void OnSocketReceive(CNetworkSocket* pSocket, int nErrorCode);
	void OnSocketClose(CNetworkSocket* pSocket, int nErrorCode);

private:
	int WaitForEvent(CNetworkSocket* pSocket);

private:
	CString m_strTranscvID;

	BOOL m_bCanRead;

	CNetworkSocket* m_pLsnSocket;
	CArray<CNetworkSocket*> m_aSockets;

	int m_nTimeOut;

	tcp_keepalive m_sTcpKeepalive;
};

