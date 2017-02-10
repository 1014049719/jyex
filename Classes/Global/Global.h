//
//  Global.h
//  NoteBook
//
//  Created by chen wu on 09-7-27.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "Reachability.h"
//#import "MBBaseStruct.h"
//#import "Plist.h"
//#import "ReConnectDelegate.h"
#import <UIKit/UIKit.h>
#import "DbMngDataDef.h"


#define _GLOBAL [Global instance]


//笔记处理标志
#define  NEWNOTE_TEXT 0
#define  NEWNOTE_EDIT   1
#define  NEWNOTE_EDIT_FROM_READ 2
#define  NEWNOTE_CAMERA  3
#define  NEWNOTE_RECORD 4
#define  NEWNOTE_DRAW   5

#define NoteFontMaxIndex 21

enum DRAWER_STATE 
{
	STATE_DRAW = 1,
	STATE_ERASE = 3,
	STATE_MOVE = 5,
	STATE_TOOL_DRAW = STATE_DRAW<<1,
	STATE_TOOL_ERASE = STATE_ERASE<<1
};


@interface Global : NSObject 
{
    NetworkStatus m_status;
    
    DRAWER_STATE drawerState;
    NSString     *g_defaultCateID;
    
    //正在编辑增加笔记
    unsigned char g_nEditNoteFlag;
    NSString *g_strCatalogGuid;
    TNoteInfo *g_editNoteInfo;
    
    //需要在笔记中搜索的字符串
    NSString *g_strSearchInNote;
    NSString *g_strCatalogForSearch;
    
    
    int g_Font[ NoteFontMaxIndex ];
    
    //add by zd 2013-02-27
    //文件夹管理->当前父亲文件夹
    NSString *g_strParentFolderI ;
    //当前设置文件夹
    NSString *g_strCurrentConfigFolderID ;
    //add by zd end
    
    //栏目
    NSString *g_strLanMu;
    
    //通知数
    NSMutableDictionary *g_dicMsgNum;
    NSMutableArray *g_arrMsgNumSubLanMu;
    
    //token
    NSString *m_token;
    
    //是否选择发送班级相册
    int g_nClassAlbumFlag;
    
    //是否需要升级
    BOOL m_bUpdateSoft;
	
}

@property(nonatomic,retain) NSString *g_defaultCateID;
@property(nonatomic,assign) unsigned char g_nEditNoteFlag;
@property(nonatomic,retain) NSString *g_strCatalogGuid;
@property(nonatomic,retain) TNoteInfo *g_editNoteInfo;
@property(nonatomic,retain) NSString *g_strSearchInNote;
@property(nonatomic,retain) NSString *g_strCatalogForSearch;
@property(nonatomic,retain) NSString *g_strParentFolderID;
@property(nonatomic,retain) NSString *g_strCurrentConfigFolderID ;
@property(nonatomic,retain) NSString *g_strLanMu;
@property(nonatomic,retain) NSMutableDictionary *g_dicMsgNum;
@property(nonatomic,retain) NSMutableArray *g_arrMsgNumSubLanMu;
@property(nonatomic,retain) NSString *m_token;


//生成单实例
+ (Global*) instance;

-(NetworkStatus)getNetworkStatus;
//+(BOOL)checkNetStateAndNotice:(BOOL)bShowTip;
-(void)setNetworkStatus:(NetworkStatus)status;

- (NSString *)defaultCateID;
- (void)setDefaultCateID:(NSString *)guid;

-(int)GetDrawerState;
-(void)SetDrawerState:(int)newState;

//设置正在编辑的笔记或朝目录新增笔记
-(void)setEditorAddNoteInfo:(int)flag catalog:(NSString *)strCatalogGuid noteinfo:(TNoteInfo *)pNoteInfo;
//获取编辑笔记标志
-(unsigned char)getEditFlag;
//获取编辑笔记所放目录的GUID
-(NSString *)getEditCatalogGuid;
//获取所编辑的笔记
-(TNoteInfo *)getEditNoteInfo;
-(NSString *)getCurrentCateGUID;
//需要查询的字符串
-(void)setSearchString:(NSString *)search;
-(void)setSearchCatalog:(NSString *)strCatalog;
-(NSString*)getSearchString;
-(NSString*)getSearchCatalog;

//笔记显示的字号
-(int)getFontWithIndex:(int)index;

//文件夹管理->当前父亲文件夹
-(NSString*)getParentFolderID;
-(void)setParentFolderID:(NSString*)strFolderID;

//文件夹管理->设置文件夹
-(NSString*)getCurrentConfigFolderID;
-(void)setCurrentConfigFolderID:(NSString*)strFolderID;


//栏目
-(NSString *)getLanMu;
-(void)setLanMu:(NSString *)strLanMu;

//消息更新数
-(void)setLanMuNewMessage:(NSDictionary *)dicMsgNum subLanMu:(NSArray *)arrMsgNumSubLanMu;
//取消息更新数
-(NSDictionary *)getLanMuNewMessage;
-(NSArray *)getSubLanMuNewMessage;

//更新时间点(消息数没更新时)
-(void)setDateLineOnly:(NSNumber *)dateline;
//取时间点
-(int)getDateline;
//清除消息数
-(void)clearMessageNum:(NSString *)strLanMu;
-(void)clearSubLanMuMessageNum:(NSString *)strSubLanMu;


//清除所有消息数
//-(void)clearAllMessageNum;
//保存连接数到缺省用户文件，关键字是登录用户名_msgnum
-(void)saveMessageNum;
-(void)readMesageNum;

//保存token
-(void) setTokenString:(NSString *)tokenstring;
//获取token
-(NSString *)getTokenString;


//设置进入相册类型标志
-(void)setAlbumTypeFlag:(int)flag;
//读取进入相册类型标志
-(int)getAlbumTypeFlag;


//是否需要升级
-(void)setUpdateSoft:(BOOL)bFlag;
-(BOOL)getUpdateSoft;


@end


