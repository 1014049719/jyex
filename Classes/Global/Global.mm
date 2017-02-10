//
//  Global.m
//  NoteBook
//
//  Created by chen wu on 09-7-27.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Global.h"
#import "DBObject.h"
#import <Foundation/Foundation.h>
#include <sys/stat.h>
#include "Constant.h"
#import "logging.h"
#import "GlobalVar.h"
#import "CommonDefine.h"
#import "DBMngAll.h"


@implementation Global
@synthesize g_defaultCateID;
@synthesize g_nEditNoteFlag;
@synthesize g_strCatalogGuid;
@synthesize g_editNoteInfo;
@synthesize g_strSearchInNote;
@synthesize g_strCatalogForSearch;
@synthesize g_strParentFolderID;
@synthesize g_strCurrentConfigFolderID ;
@synthesize g_strLanMu;
@synthesize g_dicMsgNum;
@synthesize g_arrMsgNumSubLanMu;
@synthesize m_token;


- (void)dealloc 
{
    m_status = kReachableViaWiFi;
    
    self.g_defaultCateID = nil;
    
    //正在编辑增加笔记
    self.g_strCatalogGuid = nil;
    self.g_editNoteInfo = nil;
    
    //需要在笔记中搜索的字符串
    self.g_strSearchInNote = nil;
    self.g_strCatalogForSearch = nil;
    
    
    //add by zd 2013-02-27
    //文件夹管理->当前父亲文件夹
    self.g_strParentFolderID = nil;
    //当前设置文件夹
    self.g_strCurrentConfigFolderID = nil;
    //add by zd end
    
    //栏目
    self.g_strLanMu = nil;
    
    self.g_dicMsgNum = nil;
    self.g_arrMsgNumSubLanMu = nil;
    
    self.m_token = nil;
    
    [super dealloc];
}


-(id) init
{
	self = [super init];
	if (self) {
		//
        drawerState = STATE_DRAW;
        self.g_nEditNoteFlag = NEWNOTE_TEXT;
        
        for (int i=0;i<NoteFontMaxIndex;i++)
            g_Font[i] = 10 + i;
        
        NSString *strTemp = @"";
        [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"UserToken" value:strTemp];
        self.m_token = strTemp;
	}
	return self;
}

//生成单实例
+ (Global*) instance
{
    static id _instance = nil;
    if (!_instance) {
        @synchronized(self) {
            if(_instance == nil)
                _instance = [[Global alloc] init];
        }
    }
    return _instance;
}


// net work state
- (NetworkStatus)getNetworkStatus
{
	//Reachability * curReach = [Reachability reachabilityForInternetConnection];
	//NetworkStatus netStatus = [curReach currentReachabilityStatus];
	//return netStatus;
    return m_status;
	
}

- (void)setNetworkStatus:(NetworkStatus)status
{
    m_status = status;
}

/*
+ (BOOL)checkNetStateAndNotice:(BOOL)bShowTip {
	if ([Global getNetworkStatus] == NotReachable)
	{
		if (bShowTip) {
			UIAlertView *alView = [[UIAlertView alloc] initWithTitle:_(@"nonet")
															 message:_(@"check_net")
															delegate:self
												   cancelButtonTitle:_(@"iknow")
												   otherButtonTitles:nil];
			[alView show];
			[alView release];
		}
		return NO;
	}
	else {
		return YES;
	}
    
}
*/


- (NSString *)defaultCateID
{    
    return g_defaultCateID;
}

- (void)setDefaultCateID:(NSString *)guid
{
    self.g_defaultCateID = guid;
}


//drawer state
-(int)GetDrawerState
{
	return drawerState;
}

-(void)SetDrawerState:(int)newState
{
	drawerState = (DRAWER_STATE)newState;
}


//设置正在编辑的笔记或朝目录新增笔记(flag=0 新增 flag=1编辑)
-(void)setEditorAddNoteInfo:(int)flag catalog:(NSString *)strCatalogGuid noteinfo:(TNoteInfo *)pNoteInfo
{
    self.g_nEditNoteFlag = flag;
    self.g_strCatalogGuid = strCatalogGuid;
    self.g_editNoteInfo = pNoteInfo;
}

-(NSString *)getCurrentCateGUID
{
    return g_strCatalogGuid;
}
//获取编辑笔记标志
-(unsigned char)getEditFlag
{
    return g_nEditNoteFlag;
}
//获取编辑笔记所放目录的GUID
-(NSString *)getEditCatalogGuid
{
    return g_strCatalogGuid;
}
//获取所编辑的笔记
-(TNoteInfo *)getEditNoteInfo
{
    return g_editNoteInfo;
}

-(void)setSearchString:(NSString *)search
{
    if ( search == g_strSearchInNote ) return;
    self.g_strSearchInNote = search;
}

-(void)setSearchCatalog:(NSString *)strCatalog
{
    if ( strCatalog == g_strCatalogForSearch ) return;
    self.g_strCatalogForSearch = strCatalog;
}

-(NSString*)getSearchString
{
    return g_strSearchInNote;
}

-(NSString*)getSearchCatalog
{
    return g_strCatalogForSearch;
}

-(int)getFontWithIndex:(int)index
{
    return g_Font[ index ];
}


//文件夹管理->当前父亲文件夹
-(NSString*)getParentFolderID
{
    return g_strParentFolderID;
}

-(void)setParentFolderID:(NSString*)strFolderID
{
    if(g_strParentFolderID != nil)
       [g_strParentFolderID release];
    
    g_strParentFolderID = [[NSString alloc] initWithString:strFolderID];
}

//文件夹管理->设置文件夹
-(NSString*)getCurrentConfigFolderID
{
    return g_strCurrentConfigFolderID ;
}

-(void)setCurrentConfigFolderID:(NSString*)strFolderID
{
    self.g_strCurrentConfigFolderID = strFolderID;
}

//栏目
-(NSString *)getLanMu
{
    return g_strLanMu;
}

-(void)setLanMu:(NSString *)strLanMu
{
    self.g_strLanMu = strLanMu;
}


//消息更新数
-(void)setLanMuNewMessage:(NSDictionary *)dicMsgNum subLanMu:(NSArray *)arrMsgNumSubLanMu
{
    self.g_dicMsgNum = [NSMutableDictionary dictionaryWithDictionary:dicMsgNum];
    self.g_arrMsgNumSubLanMu = [NSMutableArray arrayWithArray:arrMsgNumSubLanMu];
    
    //发消息
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_LANMU_MSGNUM object:nil userInfo:nil];
    
    //保存
    [self saveMessageNum];
}


//取消息更新数
-(NSDictionary *)getLanMuNewMessage
{
    return g_dicMsgNum;
}

-(NSArray *)getSubLanMuNewMessage
{
    return g_arrMsgNumSubLanMu;
}



//更新时间点(没有新消息时)
-(void)setDateLineOnly:(NSNumber *)dateline
{
    if ( !g_dicMsgNum ) return;
    
    [self.g_dicMsgNum setObject:dateline forKey:@"dateline"];
}

//取时间点
-(int)getDateline
{
    if ( !g_dicMsgNum ) return 0;
    
    NSNumber *dateline = [g_dicMsgNum objectForKey:@"dateline"];
    if (!dateline ) return 0;
    return [dateline intValue];
}

//清除消息数
-(void)clearMessageNum:(NSString *)strLanMu
{
    if ( !g_dicMsgNum ) return;
    NSNumber *msgnum = [g_dicMsgNum objectForKey:strLanMu];
    if ( !msgnum ) return;
    if ( [msgnum intValue] == 0 ) return;
    
    [self.g_dicMsgNum setObject:[NSNumber numberWithInt:0] forKey:strLanMu];
    //发消息
    //不需要发消息了2015.2.12
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_LANMU_MSGNUM object:nil userInfo:nil];
    
    //保存
    [self saveMessageNum];
}

-(void)clearSubLanMuMessageNum:(NSString *)strSubLanMu
{
    if ( !g_arrMsgNumSubLanMu ) return;
    
    for (int jj=0;jj<[g_arrMsgNumSubLanMu count];jj++) {
        NSDictionary *dic = [g_arrMsgNumSubLanMu objectAtIndex:jj];
        NSString *elid = pickJsonStrValue(dic, @"elid");
        if ( elid && [elid isEqualToString:strSubLanMu] ) {
            NSMutableDictionary *dicNew = [NSMutableDictionary dictionaryWithDictionary:dic];
            [dicNew setObject:[NSNumber numberWithInt:0] forKey:@"num"];
            [self.g_arrMsgNumSubLanMu replaceObjectAtIndex:jj withObject:dicNew];
            
            //保存
            [self saveMessageNum];
            
            return;
        }
    }
    
}



//清除所有消息数
/*
-(void)clearAllMessageNum
{
    if ( !g_dicMsgNum ) return;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"dateline"];
    [self setLanMuNewMessage:dic];
}
*/

//保存连接数到缺省用户文件，关键字是登录用户名_msgnum
-(void)saveMessageNum
{
    if ( !g_dicMsgNum && !g_arrMsgNumSubLanMu) return;
    
    if ( g_dicMsgNum ) {
        NSString *strKey = [NSString stringWithFormat:@"%@_msgnum",TheCurUser.sUserName];
        [[NSUserDefaults standardUserDefaults] setObject:g_dicMsgNum forKey:strKey];
    }

    if ( g_arrMsgNumSubLanMu ) {
        NSString *strKey = [NSString stringWithFormat:@"%@_lanmu_msgnum",TheCurUser.sUserName];
        [[NSUserDefaults standardUserDefaults] setObject:g_arrMsgNumSubLanMu forKey:strKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)readMesageNum
{
    NSString *strKey = [NSString stringWithFormat:@"%@_msgnum",TheCurUser.sUserName];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:strKey];
    if ( !dic ) {
        NSMutableDictionary *dicnew = [NSMutableDictionary dictionary];
        [dicnew setObject:[NSNumber numberWithInt:0] forKey:LM_BJKJ];
        [dicnew setObject:[NSNumber numberWithInt:0] forKey:LM_GRKJ];
        [dicnew setObject:[NSNumber numberWithInt:0] forKey:LM_PAJS];
        [dicnew setObject:[NSNumber numberWithInt:0] forKey:LM_PM];
        [dicnew setObject:[NSNumber numberWithInt:0] forKey:LM_CZGS];
        [dicnew setObject:[NSNumber numberWithInt:0] forKey:LM_FMXT];
        [dicnew setObject:[NSNumber numberWithInt:0] forKey:LM_YEZZB];
        [dicnew setObject:[NSNumber numberWithInt:0] forKey:@"dateline"];
        [dicnew setObject:TheCurUser.sUserName forKey:@"username"];
        dic = dicnew;
    }
    
    strKey = [NSString stringWithFormat:@"%@_lanmu_msgnum",TheCurUser.sUserName];
    NSArray *arrLanmu = [[NSUserDefaults standardUserDefaults] arrayForKey:strKey];
    if ( !arrLanmu ) {
        arrLanmu = [NSMutableArray array];
    }
    
    [self setLanMuNewMessage:dic subLanMu:arrLanmu];
}




//保存token
-(void) setTokenString:(NSString *)tokenstring
{
    self.m_token = tokenstring;
    
    [AstroDBMng setCfg_cfgMgr:@"CommonCfg" name:@"UserToken" value:tokenstring];
    
}

//获取token
-(NSString *)getTokenString
{
    return self.m_token;
}


int g_nClassAlbumFlag;

//设置进入相册类型标志
-(void)setAlbumTypeFlag:(int)flag
{
    g_nClassAlbumFlag = flag;
}

//读取进入相册类型标志
-(int)getAlbumTypeFlag
{
    return g_nClassAlbumFlag;
}

/*
-(void)setUpdateSoft:(BOOL)bFlag
{
    m_bUpdateSoft = bFlag;
}
-(BOOL)getUpdateSoft
{
    return m_bUpdateSoft;
}
*/


@end
