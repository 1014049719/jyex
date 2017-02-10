/*
 *  ItemMgr.cpp
 *  NoteBook
 *
 *  Created by wangsc on 10-9-15.
 *  Copyright 2010 ND. All rights reserved.
 *
 */

#import "ItemMgr.h"
#import "CfgMgr.h"

#import "DbMngDataDef.h"
#import "ComCustomConstantDef.h"
#import "PubFunction.h"
#import "GlobalVar.h"
#import "BussComdIDDef.h"

#import "Common.h"

#import "CommonDirectory.h"


#define HASH_LEN		16
#define MAX_FINGERPRINTER_LEN	1024 * 1024

// 指纹信息，前两个字节是长度，包括自身长度
//static unsigned char m_ucFingerPrinter[MAX_FINGERPRINTER_LEN];

@implementation AstroDBMng (ForItemMgr)

+ (TItemInfo* )getItem:(NSString*)strItemGuid
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"SELECT * FROM tb_item_info WHERE item_id='%@';",strItemGuid];
        
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
		if ( !query.Eof()) 
		{ 
            TRecHead *pHead = [[TRecHead new] autorelease];
            TItemInfo *pItemInfo = [[TItemInfo new] autorelease];
            pItemInfo.tHead = pHead; 
            
            [self objFromQuery_ItemMgr:pItemInfo query:&query];
            
            return pItemInfo;
		}
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询笔记项信息表失败!");
		return nil;
	}
	return nil;
}



+ (NSArray *)getItemListBySQL:(NSString *)strSQL
{
    @try
	{
        //int nNowCount;
        NSMutableArray* aryData = [NSMutableArray array];
        
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:strSQL];
		while ( !query.Eof()) 
		{ 
            TRecHead *pHead = [[TRecHead new] autorelease];
            TItemInfo *pInfo = [[TItemInfo new] autorelease];
            pInfo.tHead = pHead;
			
            [self objFromQuery_ItemMgr:pInfo query:&query];
			[aryData addObject:pInfo];
            
            //nNowCount++;
            //if ( nLimitCount>0 && nNowCount>= nLimitCount ) break;
            
			query.NextRow();
		}
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询笔记项列表失败!");
		return nil;
	}
	return nil;
}

//某条笔记需上传的笔记项
+ (NSArray *)getNeedUploadItemListByNote:(NSString *)guidNote
{
    
    NSString *strSQL;
    strSQL = [NSString stringWithFormat:@"SELECT * FROM tb_item_info WHERE note_id='%@' AND edit_state=%d;",guidNote,EDITSTATE_EDITED];
    return [self getItemListBySQL:strSQL];
}

+ (NSArray *)getItemListByNote:(NSString *)guidNote includeDelete:(BOOL)includeDelete
{
    
    NSString *strSQL;
    if ( includeDelete )
        strSQL = [NSString stringWithFormat:@"select * from tb_item_info where note_id='%@';",guidNote];
    else
        strSQL = [NSString stringWithFormat:@"select * from tb_item_info where note_id='%@' AND delete_state=%d;",guidNote,DELETESTATE_NODELETE];
    
    return [self getItemListBySQL:strSQL];
}


+ (BOOL)addItem:(TItemInfo*)pItemInfo
{
    return [self saveItem:pItemInfo];;
}

+ (BOOL)deleteItem:(NSString *)strItemGuid
{
    TItemInfo* itemInfo = [self getItem:strItemGuid];
    if ( !itemInfo )
    {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* filePath = [CommonFunc getItemPath:strItemGuid fileExt:itemInfo.strItemExt];
    if ([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:NULL];
    }
    
    if (itemInfo.tHead.nCreateVerID == 0)
    {
        return [self deleteItemFromDB:strItemGuid];
    }
    else
    {
        itemInfo.tHead.nEditState = EDITSTATE_EDITED;
        itemInfo.tHead.nDelState = DELETESTATE_DELETE;
        return [self saveItem:itemInfo];
    }
}

+ (BOOL)deleteItemFromDB:(NSString *)strItemGuid
{
    TItemInfo* itemInfo = [self getItem:strItemGuid];
    if (!itemInfo)
    {
        return NO;
    }

    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* filePath = [CommonFunc getItemPath:strItemGuid fileExt:itemInfo.strItemExt];
    if ([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:NULL];
    }
    
    BOOL bRet = NO;
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"DELETE FROM tb_item_info WHERE item_id='%@'", strItemGuid];
		[[AstroDBMng getDb91Note] execDML:sql];
		bRet = YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除笔记项目失败!");
	}
	return bRet;
}

+ (BOOL)saveItem:(TItemInfo*)itemInfo
{
    return [self saveToDB_ItemMgr:itemInfo];
}

//数据库操作
+ (int)saveToDB_ItemMgr:(TItemInfo*)obj
{
    NSLog(@"***-----item:itemguid=%@, ext=%@,noteguid=%@,delete_flag=%d",obj.strItemIdGuid,obj.strItemExt,obj.strNoteIdGuid,obj.tHead.nDelState);
    
    
    /*
    string strSQL = "REPLACE INTO tb_item_info (" + [super commonFields] + ","
    + "item_id, creator_id, encrypt_flag, item_type, item_ext, item_size"
    + ") values(" + [super commonFieldsValue:obj.tHead] +
    + "'" + [CommonFunc guidToString:obj.guid] + "', "			// 自身GUID
    + [CommonFunc i2a:obj.nCreatorID] + ", "				// item的创建者ID
    + [CommonFunc i2a:obj.nEncryptFlag] + ", "				// 加密标识
    + [CommonFunc i2a:obj.nNoteItemType] + ", "            // item的类型
    + "'" + [CommonFunc unicodeToUTF8:obj.wszFileExt] + "', "                    // item文件的扩展名
    + [CommonFunc ul2a:obj.m_unDataLen] + ");";			// item长度		
    
	MLOG(@"%s", strSQL.c_str());
	
    try
    {
        CppSQLite3Statement stmt = [[DBObject shareDB] compileStatement:strSQL.c_str()];
        stmt.execDML();   
    }
    catch(CppSQLite3Exception& e)
    {
        MLOG(@"SQL: %s\n Exception:%s", strSQL.c_str(), e.errorMessage());
        return NO;
    }

    return YES;
    */
    
    @try
	{
		NSString* sql = [NSString stringWithFormat:@"replace into %@"
						 "( [user_id],"
						 "[curr_ver], "
						 "[create_ver], "
						 "[create_time], "
						 "[modify_time], "
						 "[delete_state], "
						 "[edit_state], "
						 "[conflict_state], "
						 "[sync_state], "
						 "[need_upload], "
                         
						 "[item_id], "
                         "[note_id], "
						 "[creator_id], "
						 "[item_type], "
						 "[item_ext], "
						 "[item_size], "
						 "[encrypt_flag], "
						 "[item_title], "
                         "[upload_size],"
                         "[server_path])"
						 "values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);",
						 TB_ITEM_INFO];
		
		DbItem *db = [AstroDBMng getDb91Note];
		CppSQLite3Statement stmt;
		if (![db pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新笔记项目信息出错");
			return -1;
		}
		
		int i = 1;
		stmt.Bind(i++, obj.tHead.nUserID);
		stmt.Bind(i++, obj.tHead.nCurrVerID);
		stmt.Bind(i++, obj.tHead.nCreateVerID);
		stmt.Bind(i++, [obj.tHead.strCreateTime UTF8String]);
		stmt.Bind(i++, [obj.tHead.strModTime UTF8String]);
		stmt.Bind(i++, obj.tHead.nDelState);
		stmt.Bind(i++, obj.tHead.nEditState);
		stmt.Bind(i++, obj.tHead.nConflictState);
		stmt.Bind(i++, obj.tHead.nSyncState);
		stmt.Bind(i++, obj.tHead.nNeedUpload);
        
		stmt.Bind(i++, [obj.strItemIdGuid UTF8String]);
        stmt.Bind(i++, [obj.strNoteIdGuid UTF8String]);
        stmt.Bind(i++, obj.nCreatorID);
        stmt.Bind(i++, obj.nItemType);
        stmt.Bind(i++, [obj.strItemExt UTF8String]);
        stmt.Bind(i++, obj.nItemSize);
        stmt.Bind(i++, obj.nEncryptFlag);
        stmt.Bind(i++, [obj.strItemTitle UTF8String]);
        stmt.Bind(i++, obj.nUploadSize);
        stmt.Bind(i++, [obj.strServerPath UTF8String]);
        
  		return [db commitStatement:&stmt];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新笔记项目表出错");
		return -1;
	}
	return -1;  
}

+ (BOOL)objFromQuery_ItemMgr:(TItemInfo*)obj query:(CppSQLite3Query*)query
{
    obj.tHead.nUserID = query->GetIntField("user_id", 0); // 用户编号
    obj.tHead.nCurrVerID = query->GetIntField("curr_ver", 0);                // 当前版本号
    obj.tHead.nCreateVerID = query->GetIntField("create_ver", 0);             // 创建版本号
    
    obj.tHead.strCreateTime = [NSString stringWithUTF8String:query->GetStringField("create_time","")];     // 创建时间
    obj.tHead.strModTime = [NSString stringWithUTF8String:query->GetStringField("modify_time","")];      // 修改时间
    
    obj.tHead.nDelState = query->GetIntField("delete_state", 0);                 // 删除状态
    obj.tHead.nEditState = query->GetIntField("edit_state", 0);                // 编辑状态
    obj.tHead.nConflictState = query->GetIntField("conflict_state", 0);             // 冲突状态
    obj.tHead.nSyncState = query->GetIntField("sync_state", 0);                 // 同步状态，1表示正在同步
    obj.tHead.nNeedUpload = query->GetIntField("need_upload", 0);                // 是否上传
    
    
    obj.strItemIdGuid = [NSString stringWithUTF8String:query->GetStringField("item_id","")]; //项目编号
    obj.strNoteIdGuid = [NSString stringWithUTF8String:query->GetStringField("note_id","")]; //项目编号
    obj.nCreatorID = query->GetIntField("creator_id", 0);         //ITEM创建者编号,备用
    obj.nItemType = query->GetIntField("item_type", 0);          //ITEM的类型
    obj.strItemExt = [NSString stringWithUTF8String:query->GetStringField("item_ext","")];   //ITEM的扩展名
    obj.nItemSize = query->GetIntField("item_size", 0);          //项目大小 
    obj.nEncryptFlag = query->GetIntField("encrypt_flag", 0);	    //加密标识
    obj.strItemTitle = [NSString stringWithUTF8String:query->GetStringField("item_title","")];  //文件名  
    obj.nUploadSize = query->GetIntField("upload_size",0);
    
    //家园e线
    obj.strServerPath = [NSString stringWithUTF8String:query->GetStringField("server_path","")];
    //NSLog(@"&&item:%@.%@ note:%@ edit:%d needdown:%d delete:%d",obj.strItemIdGuid,obj.strItemExt,obj.strNoteIdGuid,
    //      obj.tHead.nEditState,obj.tHead.nNeedUpload,obj.tHead.nDelState);

    
    return YES;
}


/*
+ (int)translateWordKey:(unsigned char*)pucWorkKey password:(string)password
{
    char szMd5Result[32];
	ZeroMemory(szMd5Result, sizeof(szMd5Result));
    
	char* pszMd5Src = new char[password.length()];
	memcpy(pszMd5Src, password.c_str(), password.length());
	MD5_GetMD5a(pszMd5Src, (unsigned int)password.length(), szMd5Result);
    
	unsigned char ucMasterKey[8];
	if (![CfgMgr getMyMasterKey:ucMasterKey])
	{
        MLOG(@"getMyMasterKey Failed");
		SAFE_DELETE_ARRAY(pszMd5Src);
		return RET_MASTERKEY_ERROR;
	}
    
	if (DES_Encrypt2(szMd5Result, (char *)pucWorkKey, (char *)ucMasterKey, WORK_KEY_LEN) != 1)
	{
		MLOG(@"加密失败");
        SAFE_DELETE_ARRAY(pszMd5Src);
		return RET_CRYPT_ERROR;
	}
    
	SAFE_DELETE_ARRAY(pszMd5Src);
    return RET_SUCCESS;
}

+ (BOOL)getMD5:(unsigned char*)pszSrc length:(int)length md5:(unsigned char*)pszMD5
{
    unsigned char ucDataHashStr[2 * HASH_LEN + 1];
	ZeroMemory(ucDataHashStr, sizeof(ucDataHashStr));
	MD5_GetMD5a((char *)pszSrc, length, (char *)ucDataHashStr);
	if (StrToBCD((char *)ucDataHashStr, pszMD5, 0) == -1)
	{
		MLOG(@"字符串转BCD码失败");
		return NO;
	}
	return YES;
}

+ (int)decryptItem:(ItemInfo*)pItemInfo workKey:(unsigned char*)pucWorkKey
{
    if (pItemInfo->m_pData == NULL)
    {
        if (![CommonFunc loadItemData:pItemInfo])
            return RET_FILE_NOT_EXIST;
    }
    
    int nDestBufLen = pItemInfo->m_unDataLen;
    unsigned char* pszDestBuf = new unsigned char[nDestBufLen];
    if (![CommonFunc decrypt_Tea:pItemInfo->m_pData len:pItemInfo->m_unDataLen buf:pszDestBuf outLen:&nDestBufLen key:pucWorkKey])
    {
        if (![CommonFunc VerifyCheckBlock:pszDestBuf len:8])
        {
            SAFE_DELETE_ARRAY(pszDestBuf);
            MLOG(@"密码错误");
            return RET_CRYPT_PWD_WRONG;
        }
        else
        {
            SAFE_DELETE_ARRAY(pszDestBuf);
            MLOG(@"解密错误");
            return RET_CRYPT_ERROR;
        }
    }
    
    if (![CommonFunc VerifyCheckBlock:pszDestBuf len:8])
    {
        SAFE_DELETE_ARRAY(pszDestBuf);
        MLOG(@"密码错误");
        return RET_CRYPT_PWD_WRONG;
    }
    
    pItemInfo->ReleaseBuf();
    
    //写到临时文件
    NSData* data = [NSData dataWithBytes:(pszDestBuf + 8) length:(nDestBufLen - 8)]; //去除校验位
    NSString* decryptItemPath = [CommonFunc getDecryptItemPath:pItemInfo->guid fileExt:pItemInfo->wszFileExt];
    [data writeToFile:decryptItemPath atomically:NO];
    SAFE_DELETE_ARRAY(pszDestBuf);
    
    return RET_SUCCESS;
}

+ (int)decryptItemEx:(ItemInfo*)pItemInfo workKey:(unsigned char*)pucWorkKey
{
    if (pItemInfo->m_pData == NULL)
    {
        if (![CommonFunc loadItemData:pItemInfo])
            return RET_FILE_NOT_EXIST;
    }
        
    // 计算密钥
	unsigned char ucWorkKey[HASH_LEN];
	ZeroMemory(ucWorkKey, sizeof(ucWorkKey));
	const unsigned char ucPwd[] = {"tes001rj.91.com"};
	[self getMD5:(unsigned char*)ucPwd length:sizeof(ucPwd) md5:(unsigned char*)ucWorkKey];

    // 输出的缓冲区不需要比输入的大
	int nDestBufLen = pItemInfo->m_unDataLen;
	unsigned char* pszDestBuf = new unsigned char[nDestBufLen];
    
	// 解密
    if (![CommonFunc decrypt_Tea:pItemInfo->m_pData len:pItemInfo->m_unDataLen buf:pszDestBuf outLen:&nDestBufLen key:pucWorkKey])
    {
        MLOG(@"解密错误");
        SAFE_DELETE_ARRAY(pszDestBuf);
        return RET_CRYPT_ERROR;
    }
    
    unsigned char ucPwdHash[HASH_LEN];
	memcpy(ucPwdHash, pszDestBuf, sizeof(ucPwdHash));
	unsigned short usPrinterLen = *(unsigned short*)(pszDestBuf + HASH_LEN);
    
    // 测试密码的正确性
	if (memcmp(pucWorkKey, pszDestBuf, WORK_KEY_LEN) != 0)
	{
        SAFE_DELETE_ARRAY(pszDestBuf);
		return RET_CRYPT_PWD_WRONG;
	}
    
    unsigned char ucMsgDigest[HASH_LEN];
    [self getMD5:pszDestBuf length:nDestBufLen - HASH_LEN md5:(unsigned char*)ucMsgDigest];
    
	// 测试数据的完整性
	if (memcmp(ucMsgDigest, pszDestBuf + nDestBufLen - HASH_LEN, sizeof(ucMsgDigest)) != 0)
	{
		MLOG(@"加密数据被破坏");
        SAFE_DELETE_ARRAY(pszDestBuf);
		return RET_DATA_DESTROYED;
	}
    
    pItemInfo->ReleaseBuf();
    
    //写到临时文件
    NSData* data = [NSData dataWithBytes:(pszDestBuf + usPrinterLen + HASH_LEN) length:(nDestBufLen - usPrinterLen - 2 * HASH_LEN)]; //去除校验位
    NSString* decryptItemPath = [CommonFunc getDecryptItemPath:pItemInfo->guid fileExt:pItemInfo->wszFileExt];
    [data writeToFile:decryptItemPath atomically:NO];
    SAFE_DELETE_ARRAY(pszDestBuf);
    
    return RET_SUCCESS;
}

+ (BOOL)encryptItem:(ItemInfo*)pItemInfo workKey:(unsigned char*)pucWorkKey
{
    NSData* srcData;
    if (pItemInfo->nEncryptFlag == EF_NOT_ENCRYPTED)
    {
        srcData = [NSData dataWithContentsOfFile:[CommonFunc getItemPath:pItemInfo->guid fileExt:pItemInfo->wszFileExt]];
    }
    else
    {
        srcData = [NSData dataWithContentsOfFile:[CommonFunc getDecryptItemPath:pItemInfo->guid fileExt:pItemInfo->wszFileExt]];
    }
                    
    int nOutLen = [srcData length];
    nOutLen = ((nOutLen - 1) / 4 + 1) * 4 + 4 + 8;
	unsigned char* pszOutBuf = new unsigned char[nOutLen];
	unsigned char* pszTempBuf = new unsigned char[nOutLen];
	// 数据在第8个字节之后
	memcpy(pszTempBuf + 8, [srcData bytes], [srcData length]);
	// 这里执行不会失败,0到7字节填充加密正确性的验证字符
    [CommonFunc createCheckBlock:pszTempBuf len:8];
    
    // 1到4字节填充实际数据 和 验证字符的长度   ---这部分有加密函数来做
    // 到了加密部分，后面有可能会有0填充的部分
    // 所以在这里记住总长度，为解密提供数据实际长度的依据
    // 总长度不包括自身 ------这些注释暂时注释掉
	int nTotalLen = [srcData length] + 8;
    
    if (![CommonFunc encrypt_Tea:pszTempBuf len:nTotalLen buf:pszOutBuf outLen:&nOutLen key:pucWorkKey])
    {
        SAFE_DELETE_ARRAY(pszTempBuf);
		SAFE_DELETE_ARRAY(pszOutBuf);
		return NO;
    }
    
    NSData* encryptData = [NSData dataWithBytes:pszOutBuf length:nOutLen];
    if (![encryptData writeToFile:[CommonFunc getItemPath:pItemInfo->guid fileExt:pItemInfo->wszFileExt] atomically:NO])
    {
        MLOG(@"writeToFile failed");
        SAFE_DELETE_ARRAY(pszTempBuf);
		SAFE_DELETE_ARRAY(pszOutBuf);
        return NO;
    }
    
    pItemInfo->m_unDataLen = nOutLen;
    pItemInfo->nEncryptFlag = EF_HIGH_ENCRYPTED;
    [super updateHead:&pItemInfo->tHead];
    [self saveItem:*pItemInfo];
    
    SAFE_DELETE(pszTempBuf);
    SAFE_DELETE(pszOutBuf);
    
    return YES;
}

+ (BOOL)encryptItemEx:(ItemInfo*)pItemInfo workKey:(unsigned char*)pucWorkKey
{
    NSData* srcData;
    if (pItemInfo->nEncryptFlag == EF_NOT_ENCRYPTED)
    {
        srcData = [NSData dataWithContentsOfFile:[CommonFunc getItemPath:pItemInfo->guid fileExt:pItemInfo->wszFileExt]];
    }
    else
    {
        srcData = [NSData dataWithContentsOfFile:[CommonFunc getDecryptItemPath:pItemInfo->guid fileExt:pItemInfo->wszFileExt]];
    }
    
    unsigned short MsgLen = sizeof(unsigned short);
    *(unsigned short *)m_ucFingerPrinter = MsgLen;
    
    // 计算密钥
	unsigned char ucWorkKey[HASH_LEN];
	ZeroMemory(ucWorkKey, sizeof(ucWorkKey));
	const unsigned char ucPwd[] = {"tes001rj.91.com"};
    [self getMD5:(unsigned char*)ucPwd length:sizeof(ucPwd) md5:(unsigned char*)ucWorkKey];
    
	int nPrinterLen = *(unsigned short *)m_ucFingerPrinter;
	int nOutLen = [srcData length];
	// 增加4个字节的长度位，不定长的指纹信息，密码散列，数据摘要
	nOutLen = (((nOutLen + 4 + nPrinterLen + 2 * HASH_LEN) - 1)/4 + 1) * 4;
	unsigned char* pszOutBuf = new unsigned char[nOutLen];
	unsigned char* pszTempBuf = new unsigned char[nOutLen];
    
	// 第1到16字节填充密码散列
	memcpy(pszTempBuf, ucWorkKey, WORK_KEY_LEN);
    
	// 第16个字节后面填充指纹信息
	memcpy(pszTempBuf + HASH_LEN, m_ucFingerPrinter, nPrinterLen);
    
	// 数据在第16个字节的密码散列 和 指纹信息后面
	memcpy(pszTempBuf + HASH_LEN + nPrinterLen, [srcData bytes], [srcData length]);
    
	// 1到4字节填充实际数据 和 验证字符的长度
	// 到了加密部分，后面有可能会有0填充的部分
	// 所以在这里记住总长度，为解密提供数据实际长度的依据
	// 总长度不包括自身
	int nTotalLen = [srcData length] + nPrinterLen + 2 * HASH_LEN;
	// 填充最后的数据摘要
    [self getMD5:pszTempBuf length:nTotalLen - HASH_LEN md5:(unsigned char*)(pszTempBuf+ nTotalLen - HASH_LEN)];
	// 加密
    if (![CommonFunc encrypt_Tea:pszTempBuf len:nTotalLen buf:pszOutBuf outLen:&nOutLen key:ucWorkKey])
	{
		SAFE_DELETE_ARRAY(pszTempBuf);
		SAFE_DELETE_ARRAY(pszOutBuf);
		return NO;
	}
    
    NSData* encryptData = [NSData dataWithBytes:pszOutBuf length:nOutLen];
    if (![encryptData writeToFile:[CommonFunc getItemPath:pItemInfo->guid fileExt:pItemInfo->wszFileExt] atomically:NO])
    {
        MLOG(@"writeToFile failed");
        SAFE_DELETE_ARRAY(pszTempBuf);
		SAFE_DELETE_ARRAY(pszOutBuf);
        return NO;
    }
    
    pItemInfo->m_unDataLen = nOutLen;
    pItemInfo->nEncryptFlag = EF_HIGH_ENCRYPTED;
    [super updateHead:&pItemInfo->tHead];
    [self saveItem:*pItemInfo];
    
    SAFE_DELETE(pszTempBuf);
    SAFE_DELETE(pszOutBuf);
    
    return YES;
}
*/


@end
