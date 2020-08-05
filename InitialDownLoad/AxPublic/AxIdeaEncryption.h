
#pragma once

#include <stdio.h>
#include <time.h>
#include <process.h>
#include <io.h>
#include <string.h>
#include <conio.h>

#define IDEAKEYSIZE 16
#define IDEABLOCKSIZE 8
#define word16 unsigned short int
#define word32 unsigned long int
#define ROUNDS	8
#define KEYLEN	(6*ROUNDS+4)

#define low16(x) ((x) & 0xffff)

typedef unsigned short int uint16;
typedef word16 IDEAkey[KEYLEN];

// ×Ö·û×ª»»
LPSTR AsPublicUnicodeToAnsi( LPWSTR pSrc );
LPWSTR AsPublicToUnicode( LPSTR pSrc );


class  CAxIdeaEncryphtion
{
private:
	/*IDEA Algorithm functions */
	static void en_key_idea(word16 userkey[8],IDEAkey Z);
	static void de_key_idea(IDEAkey Z, IDEAkey DK);
	static void cipher_idea(word16 in[4],word16 out[4],const IDEAkey Z);
	static uint16 inv(uint16 x);
	static uint16 mul(uint16 a,uint16 b);

	/*file handling functions*/
	static char read_char_from_file(CFile &fp,int &end_of_file);
	static word16 read_word16_from_file(CFile &fp,int &end_of_file);
	static void write_char_to_file(char data,CFile &fp);
	static void write_word16_to_file(word16 data,CFile &fp);
	static void getuserkeyfromargv(word16 *key,char *arg);
public:
	static int CipherFile(CFile &in,CFile &out,CString strkey);
	static int DecipherFile(CFile &in,CFile &out,CString strkey);

	static int CipherFile(CString strInFilePath,CString strOutFilePath,CString strkey);
	static int DecipherFile(CString strInFilePath,CString strOutFilePath,CString strkey);

private:
	static char read_char_from_file(FILE *fp, int &end_of_file);
	static word16 read_word16_from_file(FILE *fp, int &end_of_file);
	static void write_char_to_file(char data,FILE *fp);
	static void write_word16_to_file(word16 data,FILE *fp);
public:
	static void CipherFile(FILE *in,FILE *out,word16 *key);
	static void DecipherFile(FILE *in,FILE *out,word16 *key);

public:
	static int CipherString(CString strIn,CString &strOut,CString strkey);
	static int DecipherString(CString strIn,CString &strOut,CString strkey);
};

CString StringEncryptEncode(CString strSource, CString strKey = _T("NewAuto")); // GRL Add
CString StringEncryptDecode(CString strSrcCode, CString strKey = _T("NewAuto"));


