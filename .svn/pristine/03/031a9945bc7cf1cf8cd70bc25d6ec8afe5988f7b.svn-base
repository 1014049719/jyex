/*----------------------------------------------------------------
// Copyright (C) 2008 “¸—ß‘®
// ∞Ê»®À˘”–°£
//
// Œƒº˛√˚£∫yxyDES2.h
// Œƒº˛π¶ƒ‹√Ë ˆ£∫DES2º”√‹ƒ£øÈ c”Ô—‘∞Ê
//
//
// ¥¥Ω®»À£∫“¸—ß‘®
//
// –ﬁ∏ƒ»À£∫
// –ﬁ∏ƒ√Ë ˆ£∫
//
// –ﬁ∏ƒ»À£∫
// –ﬁ∏ƒ√Ë ˆ£∫
//----------------------------------------------------------------*/

#ifndef DESH
#define DESH

#include <string.h>

#ifdef __cplusplus
extern "C" {
#endif

// char szSubKeys[16][48];//¥¢¥Ê16◊È48Œª√‹‘ø
// char szCiphertextRaw[64]; //¥¢¥Ê∂˛Ω¯÷∆√‹Œƒ(64∏ˆBits) int 0,1
//  char szPlaintextRaw[64]; //¥¢¥Ê∂˛Ω¯÷∆√‹Œƒ(64∏ˆBits) int 0,1
//  char szCiphertextInBytes[8];//¥¢¥Ê8Œª√‹Œƒ
//  char szPlaintextInBytes[8];//¥¢¥Ê8Œª√˜Œƒ◊÷∑˚¥Æ
// 
//  char szCiphertextInBinary[65]; //¥¢¥Ê∂˛Ω¯÷∆√‹Œƒ(64∏ˆBits) char '0','1',◊Ó∫Û“ªŒª¥Ê'\0'
//  char szCiphertextInHex[17]; //¥¢¥Ê Æ¡˘Ω¯÷∆√‹Œƒ,◊Ó∫Û“ªŒª¥Ê'\0' 
//  char szPlaintext[9];//¥¢¥Ê8Œª√˜Œƒ◊÷∑˚¥Æ,◊Ó∫Û“ªŒª¥Ê'\0'
// 
//  char szFCiphertextAnyLength[8192];//»Œ“‚≥§∂»√‹Œƒ
//  char szFPlaintextAnyLength[8192];//»Œ“‚≥§∂»√˜Œƒ◊÷∑˚¥Æ
// 

//extern  char szSubKeys[16][48];//¥¢¥Ê16◊È48Œª√‹‘ø
//extern  char szCiphertextRaw[64]; //¥¢¥Ê∂˛Ω¯÷∆√‹Œƒ(64∏ˆBits) int 0,1
//extern  char szPlaintextRaw[64]; //¥¢¥Ê∂˛Ω¯÷∆√‹Œƒ(64∏ˆBits) int 0,1
//extern  char szCiphertextInBytes[8];//¥¢¥Ê8Œª√‹Œƒ
//extern  char szPlaintextInBytes[8];//¥¢¥Ê8Œª√˜Œƒ◊÷∑˚¥Æ
//
//extern  char szCiphertextInBinary[65]; //¥¢¥Ê∂˛Ω¯÷∆√‹Œƒ(64∏ˆBits) char '0','1',◊Ó∫Û“ªŒª¥Ê'\0'
//extern char szCiphertextInHex[17]; //¥¢¥Ê Æ¡˘Ω¯÷∆√‹Œƒ,◊Ó∫Û“ªŒª¥Ê'\0' 
//extern  char szPlaintext[9];//¥¢¥Ê8Œª√˜Œƒ◊÷∑˚¥Æ,◊Ó∫Û“ªŒª¥Ê'\0'
//
//extern  char szFCiphertextAnyLength[8192];//»Œ“‚≥§∂»√‹Œƒ
//extern  char szFPlaintextAnyLength[8192];//»Œ“‚≥§∂»√˜Œƒ◊÷∑˚¥Æ


//extern "C" char szSubKeys[16][48];//¥¢¥Ê16◊È48Œª√‹‘ø
//extern "C" char szCiphertextRaw[64]; //¥¢¥Ê∂˛Ω¯÷∆√‹Œƒ(64∏ˆBits) int 0,1
//extern "C" char szPlaintextRaw[64]; //¥¢¥Ê∂˛Ω¯÷∆√‹Œƒ(64∏ˆBits) int 0,1
//extern "C" char szCiphertextInBytes[8];//¥¢¥Ê8Œª√‹Œƒ
//extern "C" char szPlaintextInBytes[8];//¥¢¥Ê8Œª√˜Œƒ◊÷∑˚¥Æ
//
//extern "C" char szCiphertextInBinary[65]; //¥¢¥Ê∂˛Ω¯÷∆√‹Œƒ(64∏ˆBits) char '0','1',◊Ó∫Û“ªŒª¥Ê'\0'
//extern "C" char szCiphertextInHex[17]; //¥¢¥Ê Æ¡˘Ω¯÷∆√‹Œƒ,◊Ó∫Û“ªŒª¥Ê'\0' 
//extern "C" char szPlaintext[9];//¥¢¥Ê8Œª√˜Œƒ◊÷∑˚¥Æ,◊Ó∫Û“ªŒª¥Ê'\0'
//
//extern "C" char szFCiphertextAnyLength[8192];//»Œ“‚≥§∂»√‹Œƒ
//extern "C" char szFPlaintextAnyLength[8192];//»Œ“‚≥§∂»√˜Œƒ◊÷∑˚¥Æ



//¿‡ππ‘Ï∫Ø ˝
void yxyDES2_Initialize(); 

//π¶ƒ‹:≤˙…˙16∏ˆ28Œªµƒkey
//≤Œ ˝:‘¥8Œªµƒ◊÷∑˚¥Æ(key)
//Ω·π˚:∫Ø ˝Ω´µ˜”√private CreateSubKeyΩ´Ω·π˚¥Ê”⁄char SubKeys[16][48]
void yxyDES2_InitializeKey(char* srcBytes);

//π¶ƒ‹:º”√‹8Œª◊÷∑˚¥Æ
//≤Œ ˝:8Œª◊÷∑˚¥Æ
//Ω·π˚:∫Ø ˝Ω´º”√‹∫ÛΩ·π˚¥Ê∑≈”⁄private szCiphertext[16]
//      ”√ªßÕ®π˝ Ù–‘Ciphertextµ√µΩ
void yxyDES2_EncryptData(char* _srcBytes);

//π¶ƒ‹:Ω‚√‹16Œª Æ¡˘Ω¯÷∆◊÷∑˚¥Æ
//≤Œ ˝:16Œª Æ¡˘Ω¯÷∆◊÷∑˚¥Æ
//Ω·π˚:∫Ø ˝Ω´Ω‚√‹∫ÚΩ·π˚¥Ê∑≈”⁄private szPlaintext[8]
//      ”√ªßÕ®π˝ Ù–‘Plaintextµ√µΩ
void yxyDES2_DecryptData(char* _srcBytes);

//π¶ƒ‹:º”√‹»Œ“‚≥§∂»◊÷∑˚¥Æ
//≤Œ ˝:»Œ“‚≥§∂»◊÷∑˚¥Æ,≥§∂»
//Ω·π˚:∫Ø ˝Ω´º”√‹∫ÛΩ·π˚¥Ê∑≈”⁄private szFCiphertextAnyLength[8192]
//      ”√ªßÕ®π˝ Ù–‘CiphertextAnyLengthµ√µΩ
void yxyDES2_EncryptAnyLength(char* _srcBytes,unsigned int _bytesLength);

//π¶ƒ‹:Ω‚√‹»Œ“‚≥§∂» Æ¡˘Ω¯÷∆◊÷∑˚¥Æ
//≤Œ ˝:»Œ“‚≥§∂»◊÷∑˚¥Æ,≥§∂»
//Ω·π˚:∫Ø ˝Ω´º”√‹∫ÛΩ·π˚¥Ê∑≈”⁄private szFPlaintextAnyLength[8192]
//      ”√ªßÕ®π˝ Ù–‘PlaintextAnyLengthµ√µΩ
void yxyDES2_DecryptAnyLength(char* _srcBytes,unsigned int _bytesLength);

//π¶ƒ‹:BytesµΩBitsµƒ◊™ªª,
//≤Œ ˝:¥˝±‰ªª◊÷∑˚¥Æ,¥¶¿Ì∫ÛΩ·π˚¥Ê∑≈ª∫≥Â«¯÷∏’Î,Bitsª∫≥Â«¯¥Û–°
void yxyDES2_Bytes2Bits(char *srcBytes, char* dstBits, unsigned int sizeBits);

//π¶ƒ‹:BitsµΩBytesµƒ◊™ªª,
//≤Œ ˝:¥˝±‰ªª◊÷∑˚¥Æ,¥¶¿Ì∫ÛΩ·π˚¥Ê∑≈ª∫≥Â«¯÷∏’Î,Bitsª∫≥Â«¯¥Û–°
void yxyDES2_Bits2Bytes(char *dstBytes, char* srcBits, unsigned int sizeBits);

//π¶ƒ‹:IntµΩBitsµƒ◊™ªª,
//≤Œ ˝:¥˝±‰ªª◊÷∑˚¥Æ,¥¶¿Ì∫ÛΩ·π˚¥Ê∑≈ª∫≥Â«¯÷∏’Î
void yxyDES2_Int2Bits(unsigned int srcByte, char* dstBits);
		
//π¶ƒ‹:BitsµΩHexµƒ◊™ªª
//≤Œ ˝:¥˝±‰ªª◊÷∑˚¥Æ,¥¶¿Ì∫ÛΩ·π˚¥Ê∑≈ª∫≥Â«¯÷∏’Î,Bitsª∫≥Â«¯¥Û–°
void yxyDES2_Bits2Hex(char *dstHex, char* srcBits, unsigned int sizeBits);
		
//π¶ƒ‹:BitsµΩHexµƒ◊™ªª
//≤Œ ˝:¥˝±‰ªª◊÷∑˚¥Æ,¥¶¿Ì∫ÛΩ·π˚¥Ê∑≈ª∫≥Â«¯÷∏’Î,Bitsª∫≥Â«¯¥Û–°
void yxyDES2_Hex2Bits(char *srcHex, char* dstBits, unsigned int sizeBits);

//szCiphertextInBinaryµƒget∫Ø ˝
char* yxyDES2_GetCiphertextInBinary();

//szCiphertextInHexµƒget∫Ø ˝
char* yxyDES2_GetCiphertextInHex();

//Ciphertextµƒget∫Ø ˝
char* yxyDES2_GetCiphertextInBytes();

//Plaintextµƒget∫Ø ˝
char* yxyDES2_GetPlaintext();

//CiphertextAnyLengthµƒget∫Ø ˝
char* yxyDES2_GetCiphertextAnyLength();

//PlaintextAnyLengthµƒget∫Ø ˝
char* yxyDES2_GetPlaintextAnyLength();

//π¶ƒ‹:…˙≥…◊”√‹‘ø
//≤Œ ˝:æ≠π˝PC1±‰ªªµƒ56Œª∂˛Ω¯÷∆◊÷∑˚¥Æ
//Ω·π˚:Ω´±£¥Ê”⁄char szSubKeys[16][48]
void yxyDES2_CreateSubKey(char* sz_56key);

//π¶ƒ‹:DES÷–µƒF∫Ø ˝,
//≤Œ ˝:◊Û32Œª,”“32Œª,key–Ú∫≈(0-15)
//Ω·π˚:æ˘‘⁄±‰ªª◊Û”“32Œª
void yxyDES2_FunctionF(char* sz_Li,char* sz_Ri,unsigned int iKey);

//π¶ƒ‹:IP±‰ªª
//≤Œ ˝:¥˝¥¶¿Ì◊÷∑˚¥Æ,¥¶¿Ì∫ÛΩ·π˚¥Ê∑≈÷∏’Î
//Ω·π˚:∫Ø ˝∏ƒ±‰µ⁄∂˛∏ˆ≤Œ ˝µƒƒ⁄»›
void yxyDES2_InitialPermuteData(char* _src,char* _dst);

//π¶ƒ‹:Ω´”“32ŒªΩ¯––¿©’πŒª48Œª,
//≤Œ ˝:‘≠32Œª◊÷∑˚¥Æ,¿©’π∫ÛΩ·π˚¥Ê∑≈÷∏’Î
//Ω·π˚:∫Ø ˝∏ƒ±‰µ⁄∂˛∏ˆ≤Œ ˝µƒƒ⁄»›
void yxyDES2_ExpansionR(char* _src,char* _dst);

//π¶ƒ‹:“ÏªÚ∫Ø ˝,
//≤Œ ˝:¥˝“ÏªÚµƒ≤Ÿ◊˜◊÷∑˚¥Æ1,◊÷∑˚¥Æ2,≤Ÿ◊˜ ˝≥§∂»,¥¶¿Ì∫ÛΩ·π˚¥Ê∑≈÷∏’Î
//Ω·π˚: ∫Ø ˝∏ƒ±‰µ⁄Àƒ∏ˆ≤Œ ˝µƒƒ⁄»›
void yxyDES2_XOR(char* szParam1,char* szParam2, unsigned int uiParamLength, char* szReturnValueBuffer);

//π¶ƒ‹:S-BOX ,  ˝æ›—πÀı,
//≤Œ ˝:48Œª∂˛Ω¯÷∆◊÷∑˚¥Æ,
//Ω·π˚:∑µªÿΩ·π˚:32Œª◊÷∑˚¥Æ
void yxyDES2_CompressFuncS(char* _src48, char* _dst32);

//π¶ƒ‹:IPƒÊ±‰ªª,
//≤Œ ˝:¥˝±‰ªª◊÷∑˚¥Æ,¥¶¿Ì∫ÛΩ·π˚¥Ê∑≈÷∏’Î
//Ω·π˚:∫Ø ˝∏ƒ±‰µ⁄∂˛∏ˆ≤Œ ˝µƒƒ⁄»›
void yxyDES2_PermutationP(char* _src,char* _dst);
	


#ifdef __cplusplus
};
#endif


#endif
 