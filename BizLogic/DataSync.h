/*
 *  Business.h
 *  NoteBook
 *
 *  Created by wangsc on 10-9-17.
 *  Copyright 2010 ND. All rights reserved.
 *
 */
#import "BizLogic.h"

#import "CateMgr.h"
#import "NoteMgr.h"
#import "ItemMgr.h"
#import "Note2ItemMgr.h"

#import "BussMng.h"


//同步类型
#define BIZ_SYNC_AllCATALOG_NOTE 0              //同步所有文件夹和笔记 (自动同步) (参数为空)
#define BIZ_SYNC_DOWNCATALOG_NOTE_UPLOADNOTE 1  //同步所有文件夹和笔记，并上传笔记 (按同步按钮,参数为文件夹guid)
#define BIZ_SYNC_NOTE 2                        //同步指定笔记 (参数为笔记结构)
#define BIZ_SYNC_UPLOAD_NOTE  3                //上传笔记  (参数为空)
#define BIZ_SYNC_UPLOAD_JYEX_NOTE 4     //上传家园e线日志
#define BIZ_SYNC_QUERYUPDATENUMBER 5     //查询文章更新数
#define BIZ_SYNC_DOWNLOAD_HTML  6        //下载html文件
#define BIZ_SYNC_AVATAR       7                //同步头像


//每个请求需保存的参数
@interface SyncRequest : NSObject 
{
    unsigned long syncid; 
	id param;	
	id	callbackObj;
	SEL callbackSel;
    int type;  //同步类型
    
    int nNetErorrFlag; //网络出错标志，需重执行
    int nExecNum;      //已执行次数
}

@property (nonatomic,retain) id param;

@property (nonatomic,assign) unsigned long syncid; 
@property (nonatomic,assign) id	callbackObj;
@property (nonatomic,assign) SEL callbackSel;
@property (nonatomic,assign) int type;
@property (nonatomic,assign) int nNetErorrFlag;
@property (nonatomic,assign) int nExecNum; 

@end



//和登录相关的业务逻辑
@interface DataSync : NSObject
{
    BussMng* bussRequest;
    NSMutableArray *arrayReq;
    unsigned long syncid;
    
    BOOL execflag;   //执行标志
    
    SyncRequest *curSync; //当前执行请求
    
    //笔记
    NSArray *arrNote;           //需上传或下载的笔记列表(只包含GUID)
    int nCurNote;               //当前笔记序号
    TNoteInfo *curNoteInfo;  //当前上传或下载的笔记
    
    //笔记项、笔记关联项
    NSArray *arrNoteXItem;     //笔记项关联项列表
    TNoteXItem *curNoteXitem;  //当前NoteXitem项
    TItemInfo *curItemInfo;  //当前Item项
    int nCurItem;              //当前item项 或 NoteXItem项
    
    //上传的文件夹
    NSArray *arrCatalog;  //需上传的文件夹列表(只包含GUID)
    int nCurCate;
    TCateInfo *uploadCateInfo;  //当前上传的文件夹
    
    //文件
    unsigned long nFileSize;   //item文件大小
    unsigned long nUploadFinishBytes; //已经上传的字节数
    unsigned long nCurUploadBytes; //当前上次的自己数
    
    int nConflictFlag;  //本次流程处理是否有冲突(1:有)
    unsigned char nSendNoteUpdateFlag; //发送笔记更新通知标志
    
    //需要处理默认文件夹的标志
    int nProcDefaultDir;
    
    //2015.1.8
    //当前下载的文件名
    NSString *m_strFullFilename;
    
    NSString *strAvatarTime;
}

@property (nonatomic,retain) BussMng *bussRequest;
@property (nonatomic,retain) NSMutableArray *arrayReq;
@property (nonatomic,assign) unsigned long syncid;
@property (nonatomic,assign) BOOL execflag;
@property (nonatomic,retain) SyncRequest *curSync;

@property (nonatomic,retain) NSArray *arrNote;
@property (nonatomic,assign) int nCurNote;         
@property (nonatomic,retain) TNoteInfo *curNoteInfo;

@property (nonatomic,retain) NSArray *arrNoteXItem;
@property (nonatomic,retain) TNoteXItem *curNoteXitem;
@property (nonatomic,retain) TItemInfo *curItemInfo;
@property (nonatomic,assign) int nCurItem;

@property (nonatomic,retain) NSArray *arrCatalog;
@property (nonatomic,assign) int nCurCate;
@property (nonatomic,retain) TCateInfo *uploadCateInfo;

@property (nonatomic,assign) unsigned long nFileSize;
@property (nonatomic,assign) unsigned long nUploadFinishBytes;
@property (nonatomic,assign) unsigned long nCurUploadBytes;

@property (nonatomic,assign) int nConflictFlag;
@property (nonatomic,assign) unsigned char nSendNoteUpdateFlag;

@property (nonatomic,retain) NSString *m_strFullFilename;
@property (nonatomic,retain) NSString *strAvatarTime;

//对外的接口,
//生成单实例
+ (DataSync*) instance;

- (BOOL)isExecuting;

//同步申请
- (unsigned long) syncRequest:(int)type :(id)obj :(SEL)sel :(id)p;
//取消同步
- (void) cacelSyncRequest:(unsigned long)sync_id;

//触发执行
- (void )execrequest;
//处理结束后的回调
-(void)requestEndProc:(TBussStatus*)sts;



-(void)uploadJYEXNoteProc;
//家园E线 上传日志附件
-(void)uploadJYEXItemFile;
-(void)uploadJYEXOneNoteProc:(TBussStatus*)sts;
-(void)uploadJYEXItemProc:(TBussStatus*)sts;


@end