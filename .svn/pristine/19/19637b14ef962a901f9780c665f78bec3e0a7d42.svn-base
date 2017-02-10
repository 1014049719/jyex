//
//  MBDataStruct.mm
//  NoteBook
//
//  Created by chen wu on 09-9-3.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

//#import "MBDataStruct.h"
//#import "Global.h"
//#import "DBObject.h"
//#import "Categorys.h"
//
//NSString * GUID2NSString(GUID *pGuid)
//{
//	char  strGUID[36] = {0};
//	
//	if (pGuid == NULL)
//	{
//		return NULL;
//	}
//	
//	int data1;
//	int data2;
//	int data3;
//	unsigned short int data4[8];
//    
//	data1 = pGuid->Data1;
//	data2 = pGuid->Data2;
//	data3 = pGuid->Data3;
//	
//	data4[0] = static_cast<unsigned short int>(pGuid->Data4[0]);
//	data4[1] = static_cast<unsigned short int>(pGuid->Data4[1]);
//	data4[2] = static_cast<unsigned short int>(pGuid->Data4[2]);
//	data4[3] = static_cast<unsigned short int>(pGuid->Data4[3]);
//	data4[4] = static_cast<unsigned short int>(pGuid->Data4[4]);
//	data4[5] = static_cast<unsigned short int>(pGuid->Data4[5]);
//	data4[6] = static_cast<unsigned short int>(pGuid->Data4[6]);
//	data4[7] = static_cast<unsigned short int>(pGuid->Data4[7]);
//    
//	
//	sprintf(strGUID,"%08x-%04x-%04x-%02x%02x-%02x%02x%02x%02x%02x%02x"
//			,	data1   
//			,   data2  
//			,   data3  
//			,   data4[0],   data4[1]   
//			,   data4[2],   data4[3],  data4[4],  data4[5]   
//			,	data4[6],	data4[7]   
//			);
//	
//    
//	return [[NSString stringWithFormat:@"%s",strGUID] uppercaseString];
//}
//
//
//BOOL NSString2GUID(GUID *pGuid,NSString *strGUID)
//{
//    
//    //	MLOG(strGUID);
//    
//	int data1;
//	int data2;
//	int data3;
//	int data4[8] = {0};	
//    
//    
//	int n = sscanf([strGUID UTF8String], "%08x-%04x-%04x-%02x%02x-%02x%02x%02x%02x%02x%02x", 
//                   &data1, &data2, &data3,
//                   &data4[0], &data4[1], &data4[2], &data4[3], &data4[4], &data4[5], &data4[6], &data4[7]);
//	
//	
//	
//	if(11 != n)
//	{
//		return FALSE;
//	}
//	
//	pGuid->Data1 = data1;
//	pGuid->Data2 = data2;
//	pGuid->Data3 = data3;
//	pGuid->Data4[0] = static_cast<char>(data4[0]);
//	pGuid->Data4[1] = static_cast<char>(data4[1]);
//	pGuid->Data4[2] = static_cast<char>(data4[2]);
//	pGuid->Data4[3] = static_cast<char>(data4[3]);
//	pGuid->Data4[4] = static_cast<char>(data4[4]);
//	pGuid->Data4[5] = static_cast<char>(data4[5]);
//	pGuid->Data4[6] = static_cast<char>(data4[6]);
//	pGuid->Data4[7] = static_cast<char>(data4[7]);
//    
//    //  test
//    //	NSString * str = GUID2NSString(pGuid);
//    //	MLOG(str);
//	return TRUE;
//}
//
////@synthesize delegate;
//@implementation MBDataStruct
//
//- (id)init
//{
//	if(self = [super init])
//	{
////		itemInfo = NULL;
////		noteInfo = NULL;
//	}
//	return self;
//}
//
//- (void)setNoteInfo:(UP_STRUCT *) upObj
//{
//	if([upObj->title length]<1)	
//	{
//		upObj->title = @" ";
//	}
//	
//	SAFE_DELETE(noteInfo);
//    
////	if([Global GetCateSturct]==nil) return; 
//    
//    
//	noteInfo = new CMBNoteInfoEx();
//	
////	noteInfo->guidCate = [Global GetCateSturct]->guid;
//	
//	NSString2GUID(&noteInfo->guidFirstItem,upObj->itemId);
//	NSString2GUID(&noteInfo->guid , upObj->noteId);
//	
//	noteInfo->dwSize = upObj->len;
//	noteInfo->dwType = upObj->noteType;
//	
//	// 在默认构造函数中已经将类的所有空间清零
//	if([upObj->title length]>0)
//	{
//        
//		unichar  aTitle[128] = {0};
//		[upObj->title getCharacters:aTitle];
//		
//        //这里分配的空间在 SAFE_DELETE 中释放
//        noteInfo->strTitle = aTitle;
////		noteInfo->pwszTitle = new unichar((wcslen_m((char *)aTitle)+1)*2);
////		
////		if(noteInfo->pwszTitle == NULL)
////		{
////			MLOG(@"malloc failed");
////			return;
////		}
////		
////		memset(noteInfo->pwszTitle,0x0,(wcslen_m((char *)aTitle)+1)*2);
////		memcpy(noteInfo->pwszTitle, aTitle, wcslen_m((char *)aTitle)*2);
//		
//        //		test
//        //		NSString * str = [[NSString alloc] initWithCharacters:noteInfo->pwszTitle length:(wcslen_m((char *)aTitle)+1)*2];//[NSString stringWithCString:(char *)noteInfo->pwszTitle encoding:NSUnicodeStringEncoding];
//        //		MLOG(str);
//        //		[str release];
//	}
//    
//	
//	if([upObj->firstExt length]>0)
//	{
//		unichar aExt[8] = {0};
//		[upObj->firstExt getCharacters:aExt];
//		memset(noteInfo->wszFileExt,0x0, 8);
//		memcpy(noteInfo->wszFileExt,aExt, 8);
//        
//		
//        //		test code
//        //		NSString * str = [[NSString alloc] initWithCharacters:noteInfo->wszFileExt length:8];
//        //		MLOG(str);
//	}
//	
//	// 暂时都不知道怎么设置
////	noteInfo->pwszSrc = new unichar[6];
////	noteInfo->pwszAddr = new unichar[2];
//    
//	if(noteInfo->strSrc.empty())
//	{		
//        noteInfo->strSrc = [[NSString stringWithString:@"iPhone"] getUnistring];
////		NSString * str = @"iPhone";
////		memset(noteInfo->pwszSrc,0x0,14);
////		[str getCharacters:noteInfo->pwszSrc];
////		
////		memset(noteInfo->pwszAddr,0x0,4);
//	}
//	
//    //  tHead	
////	noteInfo->tHead.dwUserID = [Global GetCateSturct]->tHead.dwUserID;
//	noteInfo->tHead.nConflictState = CP_USE_LOCAL;
//	
////	NSString * cTime = nil;
////	NSString * eTime = nil;	
//	
//	if(upObj->nState == NOTE_EDIT || upObj->nState == NOTE_NEW)
//	{
//		noteInfo->tHead.nDelState = STATE_NORMAL;
////		cTime = [Global GetCurrentTime];
////		eTime = cTime;
//	}
//	else
//	{
//		noteInfo->tHead.nDelState = STATE_DELETE;
////		cTime = [[DBObject shareDB] getCreateTime:upObj->noteId];
////		eTime = [[DBObject shareDB] getEditTime:upObj->noteId];
//	}
//	
//    
////	[cTime getCharacters:noteInfo->tHead.wszCreateTime];
////	[eTime getCharacters:noteInfo->tHead.wszModTime];
//    
//	noteInfo->tHead.dwCreateVerID = upObj->cVerId;
//	noteInfo->tHead.dwCurVerID = upObj->mVerId;
//	//MLOG(@"创建版本号 ＝ %d \n",upObj->cVerId);
//    
//}
//
//- (CMBNoteInfoEx)getNoteInfo
//{
//	return noteInfo;
//}
//
//- (BOOL)isEmptyNote
//{
//	return noteInfo == NULL;
//}
//
//- (void)setItemInfo:(id)item type:(ENUM_ITEM_TYPE)type	itemId:(NSString *)itemId  fExt:(NSString *)ext
//{
//	SAFE_DELETE(itemInfo);
//	
//	itemInfo = new CMBItemNew();
//	
//	unsigned char	*content = NULL;
//	unsigned int	length	 = 0;
//	
//	if(type == NI_PIC)					//图片
//	{
//		UIImage * image = (UIImage *)item;
//		NSData  * data	= UIImageJPEGRepresentation(image,1);
//		content = (unsigned char *)[data bytes];
//		length  = [data length];
//	}else if (type == NI_HTML)	
//	{
//		NSString *str = nil;
//		if (item)
//			str = [NSString stringWithString:(NSString *)item];
//		else
//			str = @" ";
//        
//#ifdef USE_UTF8
//        NSStringEncoding htmlEncoding = NSUTF8StringEncoding;
//#else 
//        NSStringEncoding htmlEncoding = NSUnicodeStringEncoding;
//#endif
//        
//        content = (unsigned char *)[str cStringUsingEncoding:htmlEncoding];
//		MLOG(str);
//		length  = [str lengthOfBytesUsingEncoding:htmlEncoding];   
//        
//	}else if (type == NI_NOTEINFO)		
//	{
//        
//	}else if (type == NI_AUDIO)
//	{
//		NSData * audioData = (NSData *)item;
//		content = (unsigned char *)[audioData	bytes];
//		length = [audioData length];
//	}
//	
//	itemInfo->nCreatorID = [[Global GetUsrID] intValue];
//	itemInfo->tHead = noteInfo->tHead;
//	
//	unichar * myext = new unichar[8];
//	memset(myext,0x0,8);
//	[ext getCharacters:myext];
//	memcpy(itemInfo->wszFileExt, myext, 8);
//	
//	itemInfo->nNoteItemType = type;
//	
//	itemInfo->m_pData = new unsigned char [length];
//	memset(itemInfo->m_pData, 0x0, length);
//	memcpy(itemInfo->m_pData, content, length);
//    
//	GUID  iid;
//	NSString2GUID(&iid, itemId);
//	memcpy(&itemInfo->guid, &iid, sizeof(itemInfo->guid));
//	
//	itemInfo->m_unDataLen = length;
//	
//	delete myext;
//}
//
//- (CMBItemNew *)getItemInfo
//{
//	return itemInfo;
//}
//
//- (BOOL)isEmptyItem
//{
//	return noteInfo == NULL;
//}
//
//- (BOOL)setRelationWithNoteId:(NSString *)noteId itemId:(NSString *)itemId state:(NO_STATE)nState
//{
//	SAFE_DELETE(relateInfo);
//	
//	relateInfo = new CMBA2BInfo();
//	
//	if(!(NSString2GUID(&(relateInfo->key.guidFirst), noteId) 
//		 && NSString2GUID(&(relateInfo->key.guidSecond), itemId)))
//	{
//		MLOG(@"setRelationWithNoteId failed");
//		SAFE_DELETE(relateInfo);
//		return FALSE;
//	}
//	
//	relateInfo->dwRightUserID = [[Global GetUsrID] intValue];
//	relateInfo->tHead = noteInfo->tHead;
//    //	relateInfo->tHead.dwUserID = [Global GetCateSturct]->tHead.dwUserID;
//    //	relateInfo->tHead.nConflictState = CP_USE_LOCAL;
//    //	
//    //	NSString * cTime = nil;
//    //	NSString * eTime = nil;	
//    //	
//    //	if(nState == NOTE_EDIT || nState == NOTE_NEW)
//    //	{
//    //		relateInfo->tHead.nDelState = STATE_NORMAL;
//    //		cTime = [Global GetCurrentTime];
//    //		eTime = cTime;
//    //	}
//    //	else
//    //	{
//    //		relateInfo->tHead.nDelState = STATE_DELETE;
//    //		cTime = [[DBObject shareDB] getCreateTime:noteId];
//    //		eTime = [[DBObject shareDB] getEditTime:noteId];
//    //	}
//    //	
//    //	
//    //	[cTime getCharacters:itemInfo->tHead.wszCreateTime];
//    //	[eTime getCharacters:itemInfo->tHead.wszModTime];
//    //	
//    //	relateInfo->tHead.dwCreateVerID = noteInfo->tHead.dwCreateVerID;
//    //	relateInfo->tHead.dwCurVerID = noteInfo->tHead.dwCurVerID;
//	
//	return true;
//}
//
//- (CMBA2BInfo *)getRelation
//{
//	return relateInfo;
//}
//
//- (void)releaseBuffer
//{
//	SAFE_DELETE(itemInfo);
//	SAFE_DELETE(noteInfo);
//	SAFE_DELETE(relateInfo);
//}
//- (void)dealloc
//{
//	[self  releaseBuffer];
//	[super dealloc];
//}
//@end

