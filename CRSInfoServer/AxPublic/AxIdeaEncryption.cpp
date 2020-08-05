/*IDEA.C   v2.2
c source code for IDEA block cipher. IDEA (International Data
Encryption Algorithm), formerly known as IPES (Improved Proposed
Encryption Standard). Algorithm developed by Xuejia Lai and James L.
Massey, of ETH Zurich. This implementation modified and derived from
original C code developed by Xuejia Lai. Zero-based indexing added,
names changed from IPES to IDEA. CFB functions added. Random Number
routines added. Optimized for speed 21 Oct 92 by Colin Plumb
<colin@nsq.gts.org>  This code assumes that each pair of 8-bit bytes
comprising a 16-bit word in the key and in the cipher block are
externally represented with the Most Significant Byte (MSB) first,
regardless of internal native byte order of the target cpu.
modified for use with PC files by Colin Maroney 4/1/94*/

/*   USAGE:     pass a key made up of 8 16-bit numbers (word16) in an array
("word16 key[8];"), an input FILE * and an output temporary
FILE * to either encode_file() or decode_file().
where the key comes from is up to you.
then call swap_files_and_clean_up() with the original file's
name as the argument, to replace the original file
with the encoded data (stored in the temporary file).

you can remname the tempfile to be used in idea.h
noisy is an integer which tells encrypting/decrypting
functions to echo a "." every 256 writes, so the user can
see that something is happening. set it to 0 for quiet
running.

please note that for really good security the original file
is overwritten before being erased if you use the w switch.
otherwise it outputs a file "<filename>.enc"

the main() used here as illustration reads the filename
from the command line arguments, as well as a command
"e" or "d" to tell it whether to encrypt or
decrypt, and a key.  the older versions had an interface
for when a command line was not use.  lack of editing 
features made this buggy, so i axed it. */

#include "stdafx.h"
#include "AxIdeaEncryption.h"

CString StringEncryptEncode(CString strSrcCode, CString strKey /*= _T("NewAuto")*/)
{
	// Get Key char summary
	int nKeySum = 0;
	for (int i=0; i < strKey.GetLength(); i++)
	{
		nKeySum += (int)(strKey[i]);
	}
	int nKey = nKeySum % 26;
	
	CString strDesCode;
	for (int i=0; i < strSrcCode.GetLength(); i++)
	{
		int nSrcCode = strSrcCode[i];

		int nDesCode = nSrcCode + nKey;

		if ((nDesCode >= 48 && nDesCode <= 57)  // digital
			|| (nDesCode >= 65 && nDesCode <= 90) // upper char
			|| (nDesCode >= 97 && nDesCode <= 122) ) // lower char
		{
			strDesCode += CString(char(nDesCode)) + CString(char( (nDesCode * nKey + i)%26  + 65));
		}
		else
		{
			strDesCode += CString(char(nSrcCode)) +CString(char( (nDesCode * nKey +i)%9 + 48));
		}
		
	}

	return strDesCode;
}

CString StringEncryptDecode(CString strDesCode, CString strKey /*= _T("NewAuto")*/)
{
	// Get Key char summary
	int nKeySum = 0;
	for (int i=0; i < strKey.GetLength(); i++)
	{
		nKeySum += (int)(strKey[i]);
	}
	int nKey = nKeySum % 26;


	CString strSrcCode;
	int nDesLen = strDesCode.GetLength();
	if (nDesLen%2) 
		return _T("");

	for (int i=0; i < nDesLen; i=i+2)
	{
		int nDesCode = strDesCode[i];
		int nDesCodeMark = strDesCode[i+1];

		if ((nDesCodeMark >= 65 && nDesCodeMark <= 90)) // 
		{
			strSrcCode += CString(char(nDesCode - nKey));
		}
		else
		{
			strSrcCode += strDesCode[i];
		}
	}

	return strSrcCode;
}

uint16 CAxIdeaEncryphtion::inv(uint16 x)
{
	uint16 t0,t1;
	uint16 q,y;
	if (x<=1)
		return x;
	t1=(uint16)(0x10001l/x);
	y=(uint16)(0x10001l%x);
	if (y==1)
		return low16(1-t1);
	t0=1;
	do
	{
		q=x/y;
		x=x%y;
		t0+=q*t1;
		if (x==1)
			return t0;
		q=y/x;
		y=y%x;
		t1+=q*t0;
	} while (y!=1);
	return low16(1-t1);
}

void CAxIdeaEncryphtion::en_key_idea(word16 *userkey, word16 *Z)
{
	int i,j;
	/* shifts */
	for (j=0;j<8;j++)
		Z[j]=*userkey++;
	for (i=0;j<KEYLEN;j++)
	{
		i++;
		Z[i+7]=((Z[i&7] << 9) | (Z[i+1 & 7] >> 7));
		Z+=i&8;
		i&=7;
	}
}

void CAxIdeaEncryphtion::de_key_idea(IDEAkey Z,IDEAkey DK)
{
	int j;
	uint16 t1,t2,t3;
	IDEAkey T;
	word16 *p=T+KEYLEN;
	t1=inv(*Z++);
	t2=-*Z++;
	t3=-*Z++;
	*--p=inv(*Z++);
	*--p=t3;
	*--p=t2;
	*--p=t1;
	for (j=1;j<ROUNDS;j++)
	{
		t1=*Z++;
		*--p=*Z++;
		*--p=t1;
		t1=inv(*Z++);
		t2=-*Z++;
		t3=-*Z++;
		*--p=inv(*Z++);
		*--p=t2;
		*--p=t3;
		*--p=t1;
	}
	t1=*Z++;
	*--p=*Z++;
	*--p=t1;
	t1=inv(*Z++);
	t2=-*Z++;
	t3=-*Z++;
	*--p=inv(*Z++);
	*--p=t3;
	*--p=t2;
	*--p=t1;
	/*copy and destroy temp copy*/
	for(j=0,p=T;j<KEYLEN;j++)
	{
		*DK++=*p;
		*p++=0;
	}
}


uint16 CAxIdeaEncryphtion::mul(uint16 a, uint16 b)
{
	word32 p;

	if (a)
	{
		if (b)
		{
			p=(word32)a*b;
			b=(uint16)(low16(p));
			a=(uint16)(p>>16);
			return b-a+(b<a);
		}
		else
		{
			return 1-a;
		}
	}
	else
		return 1-b;
}

#define MUL(x,y) (x=mul(low16(x),y))

void CAxIdeaEncryphtion::cipher_idea(word16 in[4],word16 out[4],const IDEAkey Z)
{
	register uint16 x1,x2,x3,x4,t1,t2;
	int r=ROUNDS;
	x1=*in++; x2=*in++;
	x3=*in++; x4=*in;
	do
	{
		MUL(x1,*Z++);
		x2+=*Z++;
		x3+=*Z++;
		MUL(x4,*Z++);
		t2=x1^x3;
		MUL(t2,*Z++);
		t1=t2+(x2^x4);
		MUL(t1,*Z++);
		t2=t1+t2;
		x1^=t1;
		x4^=t2;
		t2^=x2;
		x2=x3^t1;
		x3=t2;
	} while (--r);
	MUL(x1,*Z++);
	*out++=x1;
	*out++=(x3+*Z++);
	*out++=(x2+*Z++);
	MUL(x4,*Z);
	*out=x4;
}

char CAxIdeaEncryphtion::read_char_from_file( CFile &fp,int &end_of_file )
{
	char temp=0;
	if (fp.Read(&temp,sizeof(char))!=1)
		end_of_file=1;

	return (temp);
}

word16 CAxIdeaEncryphtion::read_word16_from_file( CFile &fp,int &end_of_file )
{
	word16 temp=0;
	if (fp.Read(&temp,sizeof(word16))!=2)
		end_of_file=1;

	return temp;
}

void CAxIdeaEncryphtion::write_char_to_file( char data,CFile &fp )
{
	fp.Write(&data,sizeof(char));
}

void CAxIdeaEncryphtion::write_word16_to_file( word16 data,CFile &fp )
{
	fp.Write(&data,sizeof(word16));
}

void CAxIdeaEncryphtion::getuserkeyfromargv(word16 *key,char *arg)
{
	unsigned int x;
	for (x=0;x<strlen(arg) && x<8;x++)
	{
		if (x==0) key[x]=arg[x]<<8;
		else key[x]=((arg[x]<<8)|(key[x-1]>>8));
	}

	if (strlen(arg)>8) 
	{
		//AfxMessageBox(_T("密码最长为八位! "));
	}

	if (x<8) while (x<8) key[x++]=0;
}

int CAxIdeaEncryphtion::CipherFile( CFile &in,CFile &out,CString strkey )
{
	word16 input[4],output[4];
	IDEAkey Z;
	int x,y;
	int count=0;
	ULONGLONG length;
	int temp;

	char* char_temp;
	char Input_userkey[8];

	int KeyLength=strkey.GetLength();
	char_temp=(char*)(LPCTSTR)(strkey);

	for (int i=0;i<8 && i<KeyLength;i++)
	{
		Input_userkey[i]=char_temp[i*2]; 
	}
	word16 userkey[8];
	getuserkeyfromargv(userkey,Input_userkey);

	en_key_idea(userkey,Z);

	int end_of_file=0;

	length=in.GetLength();
	//length=filelength(fileno(in));

	out.Write(&length,sizeof(ULONGLONG));
	//fwrite(&length,sizeof(ULONGLONG),1,out);

	while (!end_of_file)
	{
		x=0;

		while (x<4)
		{
			input[x]=((word16)(read_char_from_file(in,end_of_file)<<8));
			if (!end_of_file)
			{
				temp=read_char_from_file(in,end_of_file);
				if (temp<0) temp+=256;
				input[x]=input[x]|temp;
				x++;
			}
			if (end_of_file)
			{
				while (x<4) input[x++]=0;
				break;
			}
		}

		cipher_idea(input,output,Z);

		for (y=0;y<x;y++)
		{
			write_word16_to_file(output[y],out);
		}
	}

	return 1;
}

int CAxIdeaEncryphtion::DecipherFile( CFile &in,CFile &out,CString strkey )
{
	word16 input[4],output[4];
	int x,y;
	IDEAkey Z,DK;
	int count=0;
	ULONGLONG length=0;

	char* char_temp;
	char Input_userkey[8];

	int KeyLength=strkey.GetLength();
	char_temp=(char*)(LPCTSTR)(strkey);

	for (int i=0;i<8 && i<KeyLength;i++)
	{
		Input_userkey[i]=char_temp[i*2]; 
	}
	word16 userkey[8];
	getuserkeyfromargv(userkey,Input_userkey);

	en_key_idea(userkey,Z);
	de_key_idea(Z,DK);

	int end_of_file=0;

	in.Read(&length,sizeof(ULONGLONG));


	while (!end_of_file)
	{
		x=0;
		while (x<4)
		{
			input[x]=read_word16_from_file(in,end_of_file);
			if (end_of_file)
				break;
			x++;
		}
		cipher_idea(input,output,DK);
		for (y=0;y<x;y++)
		{
			if (length-->0)
				write_char_to_file(((char)(output[y]>>8)),out);
			if (length-->0)
				write_char_to_file(((char)(output[y]&255)),out);
		}
	}

	return 1;
}

int CAxIdeaEncryphtion::CipherFile( CString strInFilePath,CString strOutFilePath,CString strkey )
{
	//返回值 1表示成功
	//返回值 2表示密码长度超过8位
	//返回值 3表示输入文件无效
	//返回值 4表示输出文件无效
	int KeyLength=strkey.GetLength();
	if (KeyLength>8)
	{
		//AfxMessageBox(_T("密码长度超过八位! "));
		return 2;//
	}

	FILE* hFileOrignal;
	FILE* hFileNew;

	if((hFileOrignal=fopen(AsPublicUnicodeToAnsi((LPWSTR)(LPCTSTR)strInFilePath),"rb"))==NULL)
	{
		//AfxMessageBox(_T("待加密的文件无效! "));
		return 3;
	}

	if((hFileNew=fopen(AsPublicUnicodeToAnsi((LPWSTR)(LPCTSTR)strOutFilePath),"w+b"))==NULL)
	{
		//AfxMessageBox(_T("指定的加密后的文件无效! "));
		return 4;
	}

	char* char_temp;
	char Input_userkey[8];

	KeyLength=strkey.GetLength();
	char_temp=(char*)(LPCTSTR)(strkey);

	for (int i=0;i<8 && i<KeyLength;i++)
	{
		Input_userkey[i]=char_temp[i*2]; 
	}
	word16 userkey[8];
	getuserkeyfromargv(userkey,Input_userkey);

	CipherFile( hFileOrignal, hFileNew, userkey );

	fclose(hFileOrignal);
	fclose(hFileNew);
	return 1;
}

int CAxIdeaEncryphtion::DecipherFile( CString strInFilePath,CString strOutFilePath,CString strkey )
{
	//返回值 1表示成功
	//返回值 2表示密码长度超过8位
	//返回值 3表示输入文件无效
	//返回值 4表示输出文件无效
	int KeyLength = strkey.GetLength();
	if (KeyLength > 8)
	{
		//AfxMessageBox(_T("密码长度超过八位! "));
		return 2;//
	}

	FILE* hFileOrignal;
	FILE* hFileNew;

	LPSTR lpIn = AsPublicUnicodeToAnsi((LPWSTR)(LPCTSTR)strInFilePath);
	if((hFileOrignal=fopen(lpIn,"rb"))==NULL)
	{
		//AfxMessageBox(_T("待解密的文件无效! "));
		return 3;
	}

	LPSTR lpOut = AsPublicUnicodeToAnsi((LPWSTR)(LPCTSTR)strOutFilePath);
	if((hFileNew=fopen(lpOut,"w+b"))==NULL)
	{
		//AfxMessageBox(_T("指定的解密后的文件无效! "));
		return 4;
	}

	LPSTR lpKey = AsPublicUnicodeToAnsi((LPWSTR)(LPCTSTR)strkey);
	word16 userkey[8];
	getuserkeyfromargv(userkey, lpKey);

	DecipherFile( hFileOrignal, hFileNew, userkey );

	fclose(hFileOrignal);
	fclose(hFileNew);

	delete lpIn;
	delete lpOut;
	delete lpKey;

	return 1;
}

char CAxIdeaEncryphtion::read_char_from_file(FILE *fp, int &end_of_file)
{
	char temp=0;

	if ((fread(&temp,sizeof(char),1,fp))!=1)
		end_of_file=1;

	return (temp);
}

word16 CAxIdeaEncryphtion::read_word16_from_file(FILE *fp,int &end_of_file)
{
	word16 temp=0;

	if ((fread(&temp,sizeof(word16),1,fp))!=1)
		//if(watch!=1)
		end_of_file=1;

	return temp;
}

void CAxIdeaEncryphtion::write_char_to_file(char data,FILE *fp)
{
	if ((fwrite(&data,sizeof(char),1,fp))!=1)
	{
		//printf("Fatal Error writing output file!!!\n");
		//exit(-1);
	}
}

void CAxIdeaEncryphtion::write_word16_to_file(word16 data,FILE *fp)
{
	if ((fwrite(&data,sizeof(word16),1,fp))!=1)
	{
		//printf("Fatal Error writing output file!!!\n");
		//exit(-1);
	}
}

void CAxIdeaEncryphtion::CipherFile(FILE *in,FILE *out,word16 *key)
{
	word16 input[4],output[4];
	IDEAkey Z;
	int x,y;
	int count=0;
	ULONGLONG length;
	int temp;

	en_key_idea(key,Z);
	int end_of_file=0;

	length=_filelength(_fileno(in));
	fwrite(&length,sizeof(ULONGLONG),1,out);

	while (!end_of_file)
	{
		x=0;

		while (x<4)
		{
			input[x]=((word16)(read_char_from_file(in,end_of_file)<<8));
			if (!end_of_file)
			{
				temp=read_char_from_file(in,end_of_file);
				if (temp<0) temp+=256;
				input[x]=input[x]|temp;
				x++;
			}
			if (end_of_file)
			{
				while (x<4) input[x++]=0;
				break;
			}
		}

		cipher_idea(input,output,Z);

		for (y=0;y<x;y++)
		{
			//if (noisy) if (count++%256==0) printf(".");
			write_word16_to_file(output[y],out);
		}
	}
}

void CAxIdeaEncryphtion::DecipherFile(FILE *in,FILE *out,word16 *key)
{
	word16 input[4],output[4];
	int x,y;
	IDEAkey Z,DK;
	int count=0;
	ULONGLONG length=0;

	en_key_idea(key,Z);
	de_key_idea(Z,DK);

	int end_of_file=0;

	fread(&length,sizeof(ULONGLONG),1,in);


	while (!end_of_file)
	{
		x=0;
		while (x<4)
		{
			input[x]=read_word16_from_file(in,end_of_file);
			if (end_of_file)
				break;
			x++;
		}
		cipher_idea(input,output,DK);
		for (y=0;y<x;y++)
		{
			//if (noisy) if (count++%256==0) printf(".");
			if (length-->0)
				write_char_to_file(((char)(output[y]>>8)),out);
			if (length-->0)
				write_char_to_file(((char)(output[y]&255)),out);
		}
	}
}

int CAxIdeaEncryphtion::CipherString( CString strIn,CString &strOut,CString strkey )
{
	char* char_temp;
	char Input_userkey[8];

	int KeyLength = strkey.GetLength();
	char_temp = (char*)(LPCTSTR)(strkey);

	for (int i=0; i<8 && i<KeyLength; i++)
	{
		Input_userkey[i] = char_temp[i*2]; 
	}
	word16 userkey[8];
	getuserkeyfromargv(userkey,Input_userkey);

	IDEAkey Z, DK;
	en_key_idea(userkey, Z);
	de_key_idea(Z, DK);

	TCHAR* char_temp1;
	int nInputLen = strIn.GetLength();
	int nGroupNum = (nInputLen / 4) + 1;
	char_temp1=(TCHAR*)(LPCTSTR)(strIn);

	for(int i = 0; i< nGroupNum; i++)
	{
		word16 input[4],output[4];
		memset(input, 0, 8);
		memset(output, 0, 8);
		for(int j=0; j<4 && (j+(i*4)) < nInputLen; j++)
		{
			input[j] = char_temp1[j+(i*4)]; 
		}

		cipher_idea(input, output, Z);
		strOut += (TCHAR)output[0];
		strOut += (TCHAR)output[1];
		strOut += (TCHAR)output[2];
		strOut += (TCHAR)output[3];
	}

	return 1;
}

int CAxIdeaEncryphtion::DecipherString( CString strIn,CString &strOut,CString strkey )
{
	strOut = _T("");
	char* char_temp;
	char Input_userkey[8];

	int KeyLength=strkey.GetLength();
	char_temp=(char*)(LPCTSTR)(strkey);

	for (int i=0;i<8 && i<KeyLength;i++)
	{
		Input_userkey[i] = char_temp[i*2]; 
	}
	word16 userkey[8];
	getuserkeyfromargv(userkey,Input_userkey);

	IDEAkey Z, DK;
	en_key_idea(userkey, Z);
	de_key_idea(Z,DK);


	TCHAR* char_temp1;
	int nInputLen = strIn.GetLength();
	int nGroupNum = (nInputLen / 4) + 1;
	char_temp1=(TCHAR*)(LPCTSTR)(strIn);

	for(int i = 0; i< nGroupNum; i++)
	{
		word16 input[4],output[4];
		memset(input, 0, 8);
		memset(output, 0, 8);
		for(int j=0; j<4 && (j+(i*4)) < nInputLen; j++)
		{
			input[j] = char_temp1[j+(i*4)]; 
		}

		cipher_idea(input, output, DK);
		strOut += (TCHAR)output[0];
		strOut += (TCHAR)output[1];
		strOut += (TCHAR)output[2];
		strOut += (TCHAR)output[3];
	}

	return 1;
}

LPWSTR AsPublicToUnicode( LPSTR lpszSrc )
{
	LPWSTR lpReturn = NULL;
	int iWLen = MultiByteToWideChar(CP_ACP,0,lpszSrc,-1,NULL,0);
	lpReturn = new WCHAR[iWLen];
	MultiByteToWideChar(CP_ACP,0,lpszSrc,strlen(lpszSrc),lpReturn,iWLen);
	lpReturn[iWLen-1] = L'\0';
	return lpReturn;
}

LPSTR AsPublicUnicodeToAnsi( LPWSTR lpszSrc )
{
	LPSTR lpReturn = NULL;
	int iLen = WideCharToMultiByte(CP_ACP,0,lpszSrc,-1,NULL,0,NULL,NULL);
	lpReturn = new char[iLen];
	WideCharToMultiByte(CP_ACP,0,lpszSrc,wcslen(lpszSrc),lpReturn,iLen,NULL,NULL);
	lpReturn[iLen-1] = '\0';
	return lpReturn;
}