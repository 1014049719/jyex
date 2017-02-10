//
//  CommonReconnectObject.m
//  NoteBook
//
//  Created by nd on 11-7-4.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CommonReconnectObject.h"
#import "Global.h"
#import "PFunctions.h"
#import "MBBaseStruct.h"
#import "Business.h"
#import "UapMgr.h"
#import "MyStruct.h"
#import "MBGetDefCataListMsg.h"

static CommonReconnectObject *g_cro = nil;
@implementation CommonReconnectObject

#pragma mark -
#pragma mark Singletone
+(CommonReconnectObject *) shareCommonReconnectObject {
	if (nil == g_cro) {
		g_cro = [[CommonReconnectObject alloc] init];
	}
	return g_cro;
}
+(void) clearCommonreconnectObject {
	if (g_cro) {
		[g_cro release];
		g_cro = nil;
	}
}

#pragma mark -
#pragma mark <loginDelegate>
-(void)loginDidSuccessWithData:(NSData *)data inputStream:(NSInputStream *)input outputStream:(NSOutputStream *)output
{
	[Global InitConnectState:YES];
    [Global setUserAccount:[PFunctions getUsernameFromKeyboard]];
	CMBUserLoginExAck ack;
	memcpy(&ack, [data bytes], [data length]);
	
	[Global AckCpy:data];
	[Global SaveInputStream:input];
	[Global SaveOutputStream:output];
	int userID = ack.m_dwAppUserID;
	NSString *uID = [NSString stringWithFormat:@"%d", userID];
	[Global InitUsrID:uID];
	MLOG(@"userid = [%d]", userID);
	[Global setLogin:YES];
	
	//登陆UAP
	[[UapMgr instance] uapLoginAsync];
	
	[PFunctions setAccount:[Global userAccount]];
	[PFunctions setLogInfo:[Global userAccount]];
	[PFunctions setUserId:uID];
	
    [Business setDBPath:[CommonFunc getDBPath]];
    [Business setMasterKey:ack.m_ucMasterKey length:sizeof(ack.m_ucMasterKey)];
	
    [Global setDefaultCateID:GUID_NULL];
    if ([Global defaultCateID] == GUID_NULL)
    {
        MBGetDefCataListMsg* dirMsg = [[MBGetDefCataListMsg shareMsg] initWithInput:input Output:output target:self];
        [dirMsg sendPacketWithData:data];       
    }
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"unUploadCountCallback" object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"noteStateCallback" object:nil];
}

-(void)loginDidFailedWithError:(NSError *)error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
	[Global InitConnectState:NO];
	[Global InitUsrID:nil];
	[Global InitUsrLogInfo:@"lose_connect"];
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统提示" message:[error localizedDescription] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"unUploadCountCallback" object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"noteStateCallback" object:nil];
}

-(void)requiredReLogin
{
}

-(void)justTestUse
{
	[Global InitConnectState:NO];
	[Global InitUsrID:nil];
	[Global setUserAccount:@"guest"];
	[PFunctions setAccount:@"guest"];
	[Global InitUsrLogInfo:_(@"unlogin")];
	[PFunctions setLogInfo:_(@"unlogin")];
    [Business setCfgString:"user" name:"defaultCateID" value:""];
    [Global setDefaultCateID:GUID_NULL];
	[Global setLogin:NO];
	
	[Business setDBPath:[CommonFunc getDBPath]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"unUploadCountCallback" object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"noteStateCallback" object:nil];
}

-(void)getDefDirDidSuccessWithData:(CMBGetDefCataListAck *)items
{
	if ([Global defaultCateID] == GUID_NULL)
	{
		MLOG(@"获取目录成功!");
		CMBCateInfo cateInfo = *(items->m_lstPMBCateInfo.begin());
        cateInfo.tHead.nEditState = 0;
        [Business saveCate:cateInfo];
        
        //保持默认文件夹GUID
        string strDefaultId = [CommonFunc guidToString:cateInfo.guid];
        [Business setCfgString:"user" name:"defaultCateID" value:strDefaultId.c_str()];
        [Global setDefaultCateID:cateInfo.guid];
	}
}

-(void)getDefDirDidFailedWithError:(NSError *)error
{
	//	[Global SaveCateStruct:nil];
	LOG(@"getDefDirDidFailedWithError");
}


@end
