/*
 *  Business.mm
 *  NoteBook
 *
 *  Created by wangsc on 10-9-17.
 *  Copyright 2010 ND. All rights reserved.
 *
 */

#import "DataSync.h"

#import "BizLogicAll.h"

#import "CateMgr.h"
#import "NoteMgr.h"
#import "ItemMgr.h"
#import "Note2ItemMgr.h"
#import "CfgMgr.h"
#import "DbMngDataDef.h"

#import "CommonDateTime.h"
#import "CommonNoteOpr.h"
#import "CommonDirectory.h"
#import "UIImage+Scale.h"

#import "Global.h"
#import "logging.h"
#import "PubFunction.h"
#import "CommonAll.h"
#import "PFunctions.h"
#import "NSObject+SBJson.h"

#import "BussMng.h"
#import "GlobalVar.h"

#import "UIAstroAlert.h"

//每次上传的包大小
#define  PACKET_SIZE (1024*50)

//下载包中最大的记录数
#define MAX_DOWNLOAD_ITEM_NUM 20



//请求事件数据结构
@implementation SyncRequest
@synthesize param;
@synthesize syncid; 
@synthesize	callbackObj;
@synthesize callbackSel;
@synthesize type;
@synthesize nExecNum;
@synthesize nNetErorrFlag;

-(void)dealloc
{
    self.param = nil;
    
    [super dealloc];
}

@end


@implementation DataSync
@synthesize bussRequest;
@synthesize arrayReq;
@synthesize syncid;
@synthesize execflag;
@synthesize curSync;
@synthesize arrNote;
@synthesize nCurNote;  
@synthesize curNoteInfo;
@synthesize arrNoteXItem;
@synthesize curNoteXitem;
@synthesize curItemInfo;
@synthesize nCurItem;
@synthesize arrCatalog;
@synthesize nCurCate;
@synthesize uploadCateInfo;

@synthesize nFileSize;
@synthesize nUploadFinishBytes;
@synthesize nCurUploadBytes;
@synthesize nConflictFlag;
@synthesize nSendNoteUpdateFlag;
@synthesize m_strFullFilename;
@synthesize strAvatarTime;

-(id) init
{
	self = [super init];
	if (self) {
		self.arrayReq = [[[NSMutableArray alloc]init] autorelease]; 
	}
	return self;
}

-(void) dealloc
{
    self.uploadCateInfo = nil;
    self.arrCatalog = nil;
    
    self.arrNote = nil;
    self.curNoteInfo = nil;
    
    self.curItemInfo = nil;
    self.curNoteXitem = nil;
    self.arrNoteXItem = nil;
    
    self.curSync = nil;
    
	self.arrayReq = nil;
    
    self.m_strFullFilename = nil;
    self.strAvatarTime = nil;
    
    [self.bussRequest cancelBussRequest];
    self.bussRequest = nil;
    
	[super dealloc];
}

//生成单实例
+ (DataSync*) instance 
{
    static id _instance = nil;
    if (!_instance) {
        @synchronized(self) {
            if(_instance == nil) 
                _instance = [[DataSync alloc] init];
        }
    }
    return _instance;
}

- (BOOL)isExecuting
{
    return self.execflag;
}

//对外的接口,同步申请
//入口参数：命令字、调用接口的对象id、回调函数、参数值
- (unsigned long) syncRequest:(int)type :(id)obj :(SEL)sel :(id)p
{
    
    SyncRequest *sync = [[SyncRequest new] autorelease];

    @synchronized(self)
    {
        sync.type = type;
        
        sync.callbackObj = obj;
        sync.callbackSel = sel;
        sync.param = p;
        sync.syncid = ++self.syncid;
        [self.arrayReq addObject:sync];
    }

    //触发执行
    [self execrequest];
    
    return sync.syncid;
}

//取消同步
- (void) cacelSyncRequest:(unsigned long)sync_id
{
    @synchronized(self)
    {
        if ( self.curSync )
        {
            if ( sync_id == self.curSync.syncid ) 
            {
                self.curSync.callbackObj = nil;
                self.curSync.callbackSel = nil;
                return;
            }
        }
        
        for (id obj in self.arrayReq)
        {  
            SyncRequest *sync = (SyncRequest *)obj;
            if ( sync_id < sync.syncid ) break;  //已释放
            if ( sync_id == sync.syncid ) {
                sync.callbackObj = nil;
                sync.callbackSel = nil;
                break;
            }
        }
    }
}


//触发执行
- (void )execrequest
{
    @synchronized(self)
    {
        //正在执行
        if ( self.execflag ) return;
        
        //取第一个请求执行
        if ( [self.arrayReq count] <= 0 ) return;
        
        self.curSync = (SyncRequest *)[self.arrayReq objectAtIndex:0];
        [self.arrayReq removeObjectAtIndex:0];  //移出队列
        
        //开始执行
        self.execflag = YES;
        self.nConflictFlag = 0;
        self.nSendNoteUpdateFlag = 0;
        
        if ([[Global instance] getNetworkStatus] == NotReachable
            || ([TheCurUser.sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME] || ( !TheCurUser.isLogined && TheCurUser.iSavePasswd != 1)))
        {
            NSString *strMsg;
            if ([[Global instance] getNetworkStatus] == NotReachable) strMsg = @"网络无法连接，请检查网络设置";
            else {
                strMsg = @"无法同步，请先登录";
            }
            //[UIAstroAlert info:strMsg :2.0 :NO :LOC_MID :NO];
            
            TBussStatus *sts = [[TBussStatus new] autorelease];
            sts.iCode = 0;
            sts.sInfo = strMsg;
            [self requestEndProc:sts];
           
            return;
        }
        
        //根据命令字走相应的流程
        switch (self.curSync.type)
        {
            case BIZ_SYNC_UPLOAD_NOTE: //上传笔记
            case BIZ_SYNC_AllCATALOG_NOTE:  //同步所有目录和笔记
            case BIZ_SYNC_UPLOAD_JYEX_NOTE:
            {
                [self uploadJYEXNoteProc];
            }
                break;
                
            case BIZ_SYNC_QUERYUPDATENUMBER:
            {
                [self queryUpdateNumber];
            }
                break;
                
            case BIZ_SYNC_DOWNLOAD_HTML:
            {
                //下载html文件
                [self downloadHtmlFileProc];
            }
                break;
            
            case BIZ_SYNC_AVATAR: //同步头像
            {
                [self queryAvatar];
            }
                break;
                
            default:
            {
                TBussStatus *sts = [[TBussStatus new] autorelease];
                sts.iCode = 0;
                sts.sInfo = @"";
                [self requestEndProc:sts];
            }
                break;
        }

    }
}


//整个流程处理结束后的反馈
-(void)requestEndProc:(TBussStatus*)sts
{
    if ( 1 == self.nSendNoteUpdateFlag ) //有消息更新
    {
        self.nSendNoteUpdateFlag = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_NOTE object:nil userInfo:nil];
    }
    
    self.curSync.nExecNum++; //执行次数增加
    
    //如果有冲突，再执行一遍, 或者有网络错误，再执行1遍
    if ( 1 == self.nConflictFlag || (1==self.curSync.nNetErorrFlag && self.curSync.nExecNum<3 &&
        [[Global instance] getNetworkStatus] != NotReachable) ) {
        
        LOG_ERROR(@"sync retry:conflictflag=%d nExecNum=%d",self.nConflictFlag,self.curSync.nExecNum);
        
        SyncRequest *sync = [[SyncRequest new] autorelease];
        @synchronized(self)
        {
            sync.type = self.curSync.type;
            sync.callbackObj = self.curSync.callbackObj;
            sync.callbackSel = self.curSync.callbackSel;
            sync.param = self.curSync.param;
            sync.nExecNum = self.curSync.nExecNum;
            sync.nNetErorrFlag = 0;
            sync.syncid = ++self.syncid;
            [self.arrayReq addObject:sync];
        }
    }
    else {
        if (self.curSync.callbackObj )  //调用回调
        {
            sts.srcParam = self.curSync.param;  //2015.1.27 返回原参数
            [self.curSync.callbackObj performSelector:self.curSync.callbackSel withObject:sts]; 
        }
    }
    
    self.curNoteInfo = nil;
    self.arrNote = nil;
    
    self.arrNoteXItem = nil;
    self.curNoteXitem = nil;
    self.curItemInfo = nil;
    
    self.arrCatalog = nil; 
    self.uploadCateInfo = nil;
    
    //执行及处理完毕
    self.execflag = NO;
    self.curSync = nil;
    
    NSLog(@"本次同步执行结束");
    
    if ( sts.iCode == 200 || !sts.sInfo ) {
        if ( [self.arrayReq count] <= 0 ){ //没有别的请求
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SYNC_FINISH object:@"同步完成" userInfo:nil];
        }
    }
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SYNC_FINISH object:sts.sInfo userInfo:nil];
    
    //继续执行下一请求
    [self execrequest];
}



//-------------------------上传笔记  START--------------------------------------------

-(void)uploadJYEXAllNoteEndProc:(TBussStatus *)sts
{
     [self requestEndProc:sts];
}

//上传1条笔记结束后处理
-(void)uploadNoteEndProc:(TBussStatus *)sts
{
    //更改当前上传笔记标志为不上传
    /*
    if ( sts.iCode == 409 )  //版本冲突
    {
        //变更笔记
        [BizLogic changeNote:curNoteInfo.strNoteIdGuid];
        self.nConflictFlag = 1; 
    }*/
    
    
    if ( 200 == sts.iCode ) self.curSync.nExecNum = 0; //有成功，重试次数清0
    
    //如果是网络原因，退出,否则继续处理
    if (sts.iCode == 1)
    {
        if ([[Global instance] getNetworkStatus] == NotReachable )
        {
            [self requestEndProc:sts];
            return;
        }
        
        self.curSync.nNetErorrFlag = 1; //置网络失败标志
    }
    
    //处理下一条笔记
    self.nCurNote++;
    [self uploadJYEXOneNoteProc:sts];
    return;
}



//上传日志附件
-(void)uploadJYEXItemFile
{
    self.nCurUploadBytes = 0;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          curItemInfo.strItemIdGuid,@"itemguid",
                          curItemInfo.strItemExt,@"itemext",
                          [NSNumber numberWithInt:0],@"rs",
                          [NSNumber numberWithInt:(int)self.nFileSize-1],@"re",
                          nil];   

    [bussRequest cancelBussRequest];
    self.bussRequest = [BussMng bussWithType:BMJYEXUploadItemFile];
    [bussRequest request:self :@selector(syncCallback_UploadJYEXItemFile:) :dict]; 
    return;

}


//家园e线 上传日志
-(void) uploadJYEXNote
{ 
    [bussRequest cancelBussRequest];
    self.bussRequest = [BussMng bussWithType:BMJYEXJYEXNote];
    [bussRequest request:self :@selector(syncCallback_UploadJYEXNote:) :curNoteInfo]; 
    return;  
}

//上传照片
-(void)uploadJYEXPhote
{
    [bussRequest cancelBussRequest];
    self.bussRequest = [BussMng bussWithType:BMJYEXUploadPhoto];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                curNoteInfo.strNoteSrc,@"albumid",curNoteInfo.strFirstItemGuid,@"itemguid",
                curNoteInfo.strNoteTitle,@"title",curNoteInfo.strContent,@"albumname",
                curNoteInfo.strNoteClassId,@"uid",curNoteInfo.strJYEXTag,@"username",nil];
    
    [bussRequest request:self :@selector(syncCallback_UploadJYEXPhote:) :dic];
    return;
}



-(void)uploadJYEXNoteProc
{
    TBussStatus *sts = [[TBussStatus new] autorelease];
    sts.iCode = 200;
    sts.rtnData = nil;
    
    self.arrNote = [AstroDBMng getNeedUploadNoteListGuid];
    if ( self.arrNote )
    {
        //置所有笔记上传标志为true为true?
        
        self.nCurNote = 0;
        [self uploadJYEXOneNoteProc:sts];
        return;
    }
    
    //如果没有，就结束处理
    [self uploadJYEXAllNoteEndProc:sts];
}


//上传家园e线日志附件
-(void)uploadJYEXOneNoteProc:(TBussStatus*)sts
{
    if ( self.arrNote ) 
    {
        for (;self.nCurNote < [self.arrNote count]; self.nCurNote++) 
        {
            self.curNoteInfo = [AstroDBMng getNote:[self.arrNote objectAtIndex:self.nCurNote]];
            if ( self.curNoteInfo ) {
                //置笔记上传标志为true,用于阻止编辑
                
                if ( curNoteInfo.nNoteType == NOTE_PIC ) { //上传照片
                    
                    NSString *strFileName = [CommonFunc getItemPathAddSrc:curNoteInfo.strFirstItemGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]];
                    if ( ![CommonFunc isFileExisted:strFileName] ) {
                        curNoteInfo.tHead.nEditState = EDITSTATE_NOEDIT;
                        curNoteInfo.strNoteTitle = @"图片文件不存在";
                        [AstroDBMng updateNote:curNoteInfo];
                        continue;
                    }
                    
                    [self uploadJYEXPhote];
                    return;
                }
                else {
                    //取所有NoteXItem
                    self.arrNoteXItem = [AstroDBMng getNeedUploadNote2ItemListByNote:curNoteInfo.strNoteIdGuid];
                    self.nCurItem = 0;
                    [self uploadJYEXItemProc:sts];
                    return;
                }
            }
        }
    }
    
    //结束处理
    [self uploadJYEXAllNoteEndProc:sts];
    

}
-(void)uploadJYEXItemProc:(TBussStatus*)sts
{
   // [self uploadJYEXItemFile];
    if ( self.arrNoteXItem )
    {
        for (;self.nCurItem < [self.arrNoteXItem count]; self.nCurItem++) 
        {
            
            self.curNoteXitem = [self.arrNoteXItem objectAtIndex:self.nCurItem];
            self.curItemInfo = [AstroDBMng getItem:curNoteXitem.strItemIdGuid];
            
            //正文需要替换，先不传
            if ( [self.curItemInfo.strItemIdGuid isEqualToString: self.curNoteInfo.strFirstItemGuid] ) {
                continue;
            }
            NSString *strFileName = [CommonFunc getItemPath:curItemInfo.strItemIdGuid fileExt:curItemInfo.strItemExt];
            if ( [CommonFunc isImageFile:curItemInfo.strItemExt] ) {
                NSString *strFileNameSrc = [CommonFunc getItemPathAddSrc:curItemInfo.strItemIdGuid fileExt:curItemInfo.strItemExt];
                if ([CommonFunc isFileExisted:strFileNameSrc] ) strFileName = strFileNameSrc;
            }
            self.nFileSize = (int)[CommonFunc GetFileSize:strFileName];
            if ( self.nFileSize == 0 )  self.nFileSize = 1;  //例外处理
            self.nUploadFinishBytes = 0;
            [self uploadJYEXItemFile];
            return;
        }
    }
    
    self.curItemInfo = nil;
    self.curNoteXitem = nil;
    
    //上传笔记
    [self uploadJYEXNote];
    return;
}



- (void)syncCallback_UploadJYEXItemFile:(TBussStatus*)sts
{
	[bussRequest cancelBussRequest];
	self.bussRequest = nil;
	
	if ( sts.iCode == 200) //成功
	{
		//[UIAstroAlert info:@"上传笔记项文件成功" :2.0 :NO :LOC_MID :NO];
	}
    else
	{
		[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
        
        LOG_ERROR(@"Err:upload ItemFile:%@", curNoteInfo.strNoteTitle);
	}
    
    if ( sts.iCode == 200 )
    {
        int succ = pickJsonIntValue(sts.rtnData, @"result", 0 );
        if ( !succ ) {
            NSString *msg = pickJsonStrValue(sts.rtnData, @"message");
            if ( msg && [msg length]>0)
                [UIAstroAlert info:msg :2.0 :NO :LOC_MID :NO];
            else {
                [UIAstroAlert info:@"上传附件失败" :2.0 :NO :LOC_MID :NO];
                msg = @"";
            }
            
            //self.curNoteInfo.tHead.nEditState = EDITSTATE_UPLOAD_FAILURE;  //上传失败，不再上传
            self.curNoteInfo.strEditLocation = msg;
            self.curNoteInfo.nFailTimes++;
            [AstroDBMng updateNote:curNoteInfo];
            
            //处理下一条
            [self uploadNoteEndProc:sts];
            return;
        }
        
        NSDictionary *dic = pickJsonValue(sts.rtnData, @"attachment", nil);
        if ( dic ) {
            self.curItemInfo.strServerPath = pickJsonStrValue(dic, @"path");
            dic = nil;
        }
        else
        {
            [self uploadNoteEndProc:sts];
            return;
        }

        self.nUploadFinishBytes += self.nCurUploadBytes;
        //更改编辑标志为不编辑，更新当前版本号
        //self.curItemInfo.tHead.nUserID = [TheCurUser.sNoteUserId intValue];
        self.curItemInfo.tHead.nEditState = EDITSTATE_NOEDIT;
        [AstroDBMng addItem:self.curItemInfo];
        
        NSLog(@"itemver=%d",self.curItemInfo.tHead.nCurrVerID);
        
        //更改NoteXItem 里面的三项
        self.curNoteXitem.tHead.nEditState = EDITSTATE_NOEDIT;
        self.curNoteXitem.tHead.nUserID = [TheCurUser.sNoteUserId intValue];
        //self.curNoteXitem.nItemVer = self.curItemInfo.tHead.nCurrVerID;  //更改似乎有问题
        [AstroDBMng updateNote2Item:curNoteXitem];
        
        //要传 NOTEXITEM
        //[self uploadNoteXItem];
        self.nCurItem++;
        [self uploadJYEXItemProc:sts];
        return;
    }
    else 
    {
        //失败处理
        [self uploadNoteEndProc:sts];
    }
    
}


//上传笔记回调
- (void)syncCallback_UploadJYEXNote:(TBussStatus*)sts
{
	[bussRequest cancelBussRequest];
	self.bussRequest = nil;
	
	if ( sts.iCode == 200) //成功
	{
		//[UIAstroAlert info:@"上传笔记信息成功" :2.0 :NO :LOC_MID :NO];
	}
    else
	{
		[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
        
        LOG_ERROR(@"Err:upload note:%@", curNoteInfo.strNoteTitle);
	}
    
    if ( sts.iCode == 200 ) 
    {
        self.nSendNoteUpdateFlag = 1; //通知更新
        
        int succ = pickJsonIntValue(sts.rtnData, @"result", 0 );
        if ( succ ) {
            curNoteInfo.strEditLocation = @"";
            curNoteInfo.tHead.nEditState = EDITSTATE_NOEDIT;
            [AstroDBMng updateNote:curNoteInfo];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_UPLOADNUM object:nil userInfo:nil];
            
            [UIAstroAlert info:@"上传日志成功" :2.0 :NO :LOC_MID :NO];
        }
        else
        {
            NSString *msg = pickJsonStrValue(sts.rtnData, @"msg");
            if ( msg && [msg length]>0)
                [UIAstroAlert info:msg :2.0 :NO :LOC_MID :NO];
            else {
                [UIAstroAlert info:@"上传日志失败" :2.0 :NO :LOC_MID :NO];
                msg = @"";
            }

            //self.curNoteInfo.tHead.nEditState = EDITSTATE_UPLOAD_FAILURE;  //上传失败，不再上传
            self.curNoteInfo.strEditLocation = msg;
            self.curNoteInfo.nFailTimes++;
            [AstroDBMng updateNote:curNoteInfo];
        }     
        
        NSLog(@"notever=%d",curNoteInfo.tHead.nCurrVerID);
    }   
    
    //结束该条笔记处理
    [self uploadNoteEndProc:sts];
    
}


//上传照片回调
- (void)syncCallback_UploadJYEXPhote:(TBussStatus*)sts
{
	[bussRequest cancelBussRequest];
	self.bussRequest = nil;
	
	if ( sts.iCode == 200) //成功
	{
		//[UIAstroAlert info:@"上传笔记信息成功" :2.0 :NO :LOC_MID :NO];
	}
    else
	{
		[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
        
        LOG_ERROR(@"Err:upload note:%@", curNoteInfo.strNoteTitle);
	}
    
    if ( sts.iCode == 200 )
    {
        self.nSendNoteUpdateFlag = 1; //通知更新
        
        int succ = pickJsonIntValue(sts.rtnData, @"res", 0 );
        if ( succ ) {
            curNoteInfo.strEditLocation = @"";
            curNoteInfo.tHead.nEditState = EDITSTATE_NOEDIT;
            [AstroDBMng updateNote:curNoteInfo];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_UPLOADNUM object:nil userInfo:nil];
            
            [UIAstroAlert info:@"上传照片成功" :2.0 :NO :LOC_MID :NO];
        }
        else
        {
            //提取失败信息
            NSString *msg = pickJsonStrValue(sts.rtnData, @"msg");
            if ( msg && [msg length]>0)
                [UIAstroAlert info:msg :2.0 :NO :LOC_MID :NO];
            else {
                msg = @"";
                [UIAstroAlert info:@"上传照片失败" :2.0 :NO :LOC_MID :NO];
            }
            
            self.curNoteInfo.strEditLocation = msg;
            self.curNoteInfo.nFailTimes++;
            [AstroDBMng updateNote:curNoteInfo];
            
            
            
            //自动处理，把照片压缩
            NSString *strFileName = [CommonFunc getItemPathAddSrc:curNoteInfo.strFirstItemGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]];
            if ( [CommonFunc isFileExisted:strFileName] ) {
                long long nSize = [CommonFunc GetFileSize:strFileName];
                if ( nSize >= 1024*600) { //大于600K
                    UIImage *img = [UIImage imageWithContentsOfFile:strFileName];
                    
                    
                    NSData *data = UIImageJPEGRepresentation(img, 0.5);
                    BOOL ret = [data writeToFile:strFileName atomically:YES];
                    if ( !ret ) {
                        [UIAstroAlert info:@"压缩照片失败" :2.0 :NO :LOC_MID :NO];
                    }
                    else {
                        long long nSizeNew = [CommonFunc GetFileSize:strFileName];
                        NSLog(@"%@ old size=%lld new size=%lld",strFileName,nSize,nSizeNew);
                    }
                }
            }
        }
        
        NSLog(@"notever=%d",curNoteInfo.tHead.nCurrVerID);
    }
    
    //结束该条照片处理
    [self uploadNoteEndProc:sts];
    
}


//-------------------------上传笔记 END--------------------------------------------




-(void)queryUpdateNumber
{
    [bussRequest cancelBussRequest];
    self.bussRequest = [BussMng bussWithType:BMJYEXGetUpdateNumber];
    [bussRequest request:self :@selector(syncCallback_QueryUpdateNumber:) :[NSNumber numberWithInt:[_GLOBAL getDateline]]];
    return;
}


-(int)getLanmuNo:(NSArray *)arr elid:(NSString *)strLanMu
{
    for (int jj=0;jj<[arr count];jj++) {
        NSDictionary *dic = [arr objectAtIndex:jj];
        NSString *elid = pickJsonStrValue(dic, @"elid");
        if ( elid && [elid isEqualToString:strLanMu] ) return jj;
    }
    
    return -1;
}


//查询更新数回调
- (void)syncCallback_QueryUpdateNumber:(TBussStatus*)sts
{
	[bussRequest cancelBussRequest];
	self.bussRequest = nil;
	
	if ( sts.iCode == 200) //成功
	{
		//[UIAstroAlert info:@"上传笔记信息成功" :2.0 :NO :LOC_MID :NO];
	}
    else
	{
		[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
        
    }
    
    if ( sts.iCode == 200 )
    {
        //处理数据
        NSDictionary *dict =(NSDictionary *)(sts.rtnData);
        NSLog(@"%@",dict);
        
        NSDictionary *dicOldMsg = [_GLOBAL getLanMuNewMessage];
        int nOldDateline = 0;
        if ( dicOldMsg ) nOldDateline = pickJsonIntValue(dicOldMsg, @"dateline");
        
        NSArray *arrOldLanMuMsg = [_GLOBAL getSubLanMuNewMessage];
        NSMutableArray *arrNewLanMuMsg;
        
        if ( arrOldLanMuMsg ) arrNewLanMuMsg = [NSMutableArray arrayWithArray:arrOldLanMuMsg];
        else arrNewLanMuMsg = [NSMutableArray array];
        
        
        int nDateline = pickJsonIntValue(dict, @"dateline");
        int nStoryMsgNum = pickJsonIntValue(dict, @"czgs");
        int nParentsMsgNum = pickJsonIntValue(dict, @"yezx");
        int nClassMsgNum=0;  //班级空间
        int nPersonalMsgNum=0; //个人空间
        int nYuErMsgNum = nStoryMsgNum + nParentsMsgNum;  //育儿掌中宝
        int nCZMYTMsgNum = 0; //成长每一天
        int nJYZTCMsgNum = 0; //家园直通车
        int nAllMsg = 0;
        
        
        if ( nOldDateline == 0 ) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSNumber numberWithInt:0] forKey:LM_BJKJ];
            [dic setObject:[NSNumber numberWithInt:0] forKey:LM_GRKJ];
            [dic setObject:[NSNumber numberWithInt:0] forKey:LM_YEZZB];
            [dic setObject:[NSNumber numberWithInt:0] forKey:LM_CZMYT];
            [dic setObject:[NSNumber numberWithInt:0] forKey:LM_JYZTC];
            
            [dic setObject:[NSNumber numberWithInt:nDateline] forKey:@"dateline"];
            [dic setObject:TheCurUser.sUserName forKey:@"username"];
            
            [_GLOBAL setLanMuNewMessage:dic subLanMu:arrNewLanMuMsg];
        }
        else {
            NSArray *arr = [dict objectForKey:@"class"];
            if ( arr && [arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary *nslog in arr ) {
                    NSString *catname = pickJsonStrValue(nslog, @"catname");
                    int num = pickJsonIntValue(nslog, @"num");
                    nClassMsgNum += num;
            
                    NSLog(@"班级空间:catname=%@ num=%d",catname,num);
                }
            }
        
            arr = [dict objectForKey:@"person"];
            if ( arr && [arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary *nslog in arr ) {
                    NSString *catname = pickJsonStrValue(nslog, @"catname");
                    int num = pickJsonIntValue(nslog, @"num");
                    nPersonalMsgNum += num;
                
                    NSLog(@"个人空间:catname=%@ num=%d",catname,num);
                }
            }
        
            arr = [dict objectForKey:@"czmyt"];
            if ( arr && [arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary *nslog in arr ) {
                    NSString *catname = pickJsonStrValue(nslog, @"catname");
                    int num = pickJsonIntValue(nslog, @"num");
                    nCZMYTMsgNum += num;
                
                    NSLog(@"成长每一天:catname=%@ num=%d",catname,num);
                }
            }
        
            arr = [dict objectForKey:@"ztc"];
            if ( arr && [arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary *nslog in arr ) {
                    NSString *catname = pickJsonStrValue(nslog, @"catname");
                    int num = pickJsonIntValue(nslog, @"num");

                    nJYZTCMsgNum += num;
                
                    NSLog(@"家园直通车:catname=%@ num=%d",catname,num);
                }
            }
        
    
            nAllMsg = nClassMsgNum + nPersonalMsgNum + nYuErMsgNum + nCZMYTMsgNum + nJYZTCMsgNum;
        
            if ( dicOldMsg ) {
                nClassMsgNum += pickJsonIntValue(dicOldMsg, LM_BJKJ);
                nPersonalMsgNum += pickJsonIntValue(dicOldMsg, LM_GRKJ);
                nYuErMsgNum += pickJsonIntValue(dicOldMsg, LM_YEZZB);
                nCZMYTMsgNum += pickJsonIntValue(dicOldMsg, LM_CZMYT);
                nJYZTCMsgNum += pickJsonIntValue(dicOldMsg, LM_JYZTC);
            }
        

            //--------------------------------------------------------------------
        
        
            if ( nAllMsg > 0 )  {
            
                arr = [dict objectForKey:@"class"];
                if ( arr && [arr isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *nslog in arr ) {
                        NSString *catname = pickJsonStrValue(nslog, @"catname");
                        NSString *lanmuid = pickJsonStrValue(nslog, @"elid");
                        int num = pickJsonIntValue(nslog, @"num");
                
                        int oldnum = 0;
                        int no = [self getLanmuNo:arrNewLanMuMsg elid:lanmuid];
                        if ( no >= 0 ) {
                            NSDictionary *dic = [arrNewLanMuMsg objectAtIndex:no];
                            oldnum = pickJsonIntValue(dic, @"num");
                        }
                        num += oldnum;
                    
                        NSDictionary *dicLanmu = @{@"elid": lanmuid,@"num":[NSNumber numberWithInt:num],@"lanmutype":@"class" };
                        if ( no >= 0 ) {
                            [arrNewLanMuMsg replaceObjectAtIndex:no withObject:dicLanmu];
                        }
                        else {
                            [arrNewLanMuMsg addObject:dicLanmu];
                        }
                
                        NSLog(@"班级空间:catname=%@ lanid=%@ num=%d",catname,lanmuid,num);
                    }
                }
        
                arr = [dict objectForKey:@"person"];
                if ( arr && [arr isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *nslog in arr ) {
                        NSString *catname = pickJsonStrValue(nslog, @"catname");
                        NSString *lanmuid = pickJsonStrValue(nslog, @"elid");
                        int num = pickJsonIntValue(nslog, @"num");
                    
                        int oldnum = 0;
                        int no = [self getLanmuNo:arrNewLanMuMsg elid:lanmuid];
                        if ( no >= 0 ) {
                            NSDictionary *dic = [arrNewLanMuMsg objectAtIndex:no];
                            oldnum = pickJsonIntValue(dic, @"num");
                        }
                        num += oldnum;
                    
                        NSDictionary *dicLanmu = @{@"elid": lanmuid,@"num":[NSNumber numberWithInt:num],@"lanmutype":@"person" };
                        if ( no >= 0 ) {
                            [arrNewLanMuMsg replaceObjectAtIndex:no withObject:dicLanmu];
                        }
                        else {
                            [arrNewLanMuMsg addObject:dicLanmu];
                        }

                
                        NSLog(@"个人空间:catname=%@ lanid=%@ num=%d",catname,lanmuid,num);
                    }
                }
        
                arr = [dict objectForKey:@"czmyt"];
                if ( arr && [arr isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *nslog in arr ) {
                        NSString *catname = pickJsonStrValue(nslog, @"catname");
                        NSString *lanmuid = pickJsonStrValue(nslog, @"elid");
                        int num = pickJsonIntValue(nslog, @"num");
                
                        int oldnum = 0;
                        int no = [self getLanmuNo:arrNewLanMuMsg elid:lanmuid];
                        if ( no >= 0 ) {
                            NSDictionary *dic = [arrNewLanMuMsg objectAtIndex:no];
                            oldnum = pickJsonIntValue(dic, @"num");
                        }
                        num += oldnum;
                    
                        NSDictionary *dicLanmu = @{@"elid": lanmuid,@"num":[NSNumber numberWithInt:num],@"lanmutype":@"czmyt" };
                        if ( no >= 0 ) {
                            [arrNewLanMuMsg replaceObjectAtIndex:no withObject:dicLanmu];
                        }
                        else {
                            [arrNewLanMuMsg addObject:dicLanmu];
                        }
                
                        NSLog(@"成长每一天:catname=%@ lanid=%@ num=%d",catname,lanmuid,num);
                    }
                }
       
    
                arr = [dict objectForKey:@"ztc"];
                if ( arr && [arr isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *nslog in arr ) {
                        NSString *catname = pickJsonStrValue(nslog, @"catname");
                        NSString *lanmuid = pickJsonStrValue(nslog, @"elid");
                        int num = pickJsonIntValue(nslog, @"num");
                
                        int oldnum = 0;
                        int no = [self getLanmuNo:arrNewLanMuMsg elid:lanmuid];
                        if ( no >= 0 ) {
                            NSDictionary *dic = [arrNewLanMuMsg objectAtIndex:no];
                            oldnum = pickJsonIntValue(dic, @"num");
                        }
                        num += oldnum;
                    
                        NSDictionary *dicLanmu = @{@"elid": lanmuid,@"num":[NSNumber numberWithInt:num],@"lanmutype":@"ztc" };
                        if ( no >= 0 ) {
                            [arrNewLanMuMsg replaceObjectAtIndex:no withObject:dicLanmu];
                        }
                        else {
                            [arrNewLanMuMsg addObject:dicLanmu];
                        }

                        NSLog(@"家园直通车:catname=%@ lanid=%@ num=%d",catname,lanmuid,num);
                    }
                }
            }
       
            //----------------------------------------------------------------
            if ( nAllMsg > 0  ) { //有更新才更改
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:[NSNumber numberWithInt:nClassMsgNum] forKey:LM_BJKJ];
                [dic setObject:[NSNumber numberWithInt:nPersonalMsgNum] forKey:LM_GRKJ];
                [dic setObject:[NSNumber numberWithInt:nYuErMsgNum] forKey:LM_YEZZB];
                [dic setObject:[NSNumber numberWithInt:nCZMYTMsgNum] forKey:LM_CZMYT];
                [dic setObject:[NSNumber numberWithInt:nJYZTCMsgNum] forKey:LM_JYZTC];
                
                
                [dic setObject:[NSNumber numberWithInt:nDateline] forKey:@"dateline"];
                [dic setObject:TheCurUser.sUserName forKey:@"username"];
                
                [_GLOBAL setLanMuNewMessage:dic subLanMu:arrNewLanMuMsg];
            }
            else { //只更新时间点
                [_GLOBAL setDateLineOnly:[NSNumber numberWithInt:nDateline]];
            }
        }
    }
    
    
    //执行结束，返回反馈,及继续执行
    [self requestEndProc:sts];
}


//-----------------------下载文件 start------------------------------------
-(void)downloadHtmlFileProc
{
    //申请异步网络接口对象
    [bussRequest cancelBussRequest];
    self.bussRequest = [BussMng bussWithType:BMJYEXDownloadFile];
    
    //从入口参数提取url、文件名、下载内容类型等
    NSString *strUrl = pickJsonStrValue(self.curSync.param,@"url");
    NSString *strFilename = pickJsonStrValue(self.curSync.param, @"filename");
    if ( [strFilename isEqualToString:@""]) {
        strFilename = [PFunctions md5Digest:strUrl];
        strFilename = [strFilename stringByAppendingString:@".html"];
    }
    NSString *strExt = [strFilename pathExtension];
    NSString *strContentType = [CommonFunc getStreamTypeByExt:strExt];
    NSString *strFullFilename = [CommonFunc getTempDownDir];
    self.m_strFullFilename = [strFullFilename stringByAppendingPathComponent:strFilename];
    
    //形成参数字典
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         strUrl,@"url",self.m_strFullFilename,@"filename",strContentType,@"contenttype", nil];
    
    //调用异步网络接口对象接口（对象、接口名，参数（回调的对象、回调的方法名、参数）
    [bussRequest request:self :@selector(syncCallback_downloadHtmlFileProc:) :dic];
    return;
}

//下载html文件回调函数
- (void)syncCallback_downloadHtmlFileProc:(TBussStatus*)sts
{
	[bussRequest cancelBussRequest];
	self.bussRequest = nil;
	
    NSLog(@"syncCallback_downloadHtmlFileProc ret=%d",sts.iCode);
    
	if ( sts.iCode == 200 ) //成功
	{
		//[UIAstroAlert info:@"从服务器同步文件成功" :2.0 :NO :LOC_MID :NO];
	}
    else
	{
        [UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
		//[self dispMsg:sts.sInfo];
        
        LOG_ERROR(@"Err:download getfile:%@", curNoteInfo.strNoteTitle);
	}
    
    //成功流程
    if ( sts.iCode == 200 ) {
       
        NSString *strFileName = [m_strFullFilename lastPathComponent];
        //正式存放目录文件
        NSString *strDownFile = [[CommonFunc getTempDir] stringByAppendingPathComponent:strFileName];
        
        //先删除
        [[NSFileManager defaultManager] removeItemAtPath:strDownFile error:nil];
        //拷贝文件
        NSError *error =nil;
        if ( ![[NSFileManager defaultManager] copyItemAtPath:m_strFullFilename toPath:strDownFile error:&error] )
        {
            NSLog(@"拷贝文件失败.src=%@,dest=%@",m_strFullFilename,strDownFile);
            NSLog(@"error:code=%d,desc=%@,reason=%@",(int)[error code],[error localizedDescription],[error localizedFailureReason]);
        }
        else
        {
            NSLog(@"拷贝文件成功");
            //删除临时文件
            [[NSFileManager defaultManager] removeItemAtPath:m_strFullFilename error:nil];
            
            //提取img_json数组
            NSString *strJson = [CommonFunc getTagValueFromHtml:strDownFile tagname:@"img_json"];
            if ( [strJson isEqualToString:@""]) {
                //执行结束，返回反馈,及继续执行
                [self requestEndProc:sts];
                return;
            }
            
            id retJsObj = [strJson JSONValue];
            if ( ![retJsObj isKindOfClass:[NSArray class]] || [(NSArray *)retJsObj count]<1 ) {
                //执行结束，返回反馈,及继续执行
                [self requestEndProc:sts];
                return;
            }
            
            //根据数组下载图片文件
            self.arrNote = retJsObj;
            self.nCurNote = 0;
            [self downloadImagFile:sts];
            return;
        }
    }
    
    if ( sts.iCode == 200
        || sts.iCode == 206  //断点续传成功
        || sts.iCode == 404 ) //文件不存在
    {
        //更改NoteXItem标志为已下载
        //TNoteXItem *pNoteXItem = [self.arrNoteXItem objectAtIndex:self.nCurItem];
        //pNoteXItem.nNeedDownlord = DOWNLOAD_NONEED;  //改为不再需要下载
        //[AstroDBMng updateNote2Item:pNoteXItem];
        //self.curItemInfo.nNeedDownlord = DOWNLOAD_NONEED;
        //[AstroDBMng addItem:self.curItemInfo];
        
        //继续取下一条笔记项
        //self.nCurItem++;
        //[self getNoteItemFile:sts];
    }
    else
    {
        //错误处理
        //[self downloadNoteEndProc:sts];
        
        //继续取下一条笔记项
        //self.nCurItem++;
        //[self getNoteItemFile:sts];
    }
    
    
    //执行结束，返回反馈,及继续执行
    [self requestEndProc:sts];
}


//下载图片文件
-(void)downloadImagFile:(TBussStatus*)sts
{
    //逐个下载
    for (;self.nCurNote<[self.arrNote count];self.nCurNote++) {
    
        //提取图片参数
        NSDictionary *dic = [arrNote objectAtIndex:self.nCurNote];
    
        NSString *strUrl = pickJsonStrValue(dic,@"imgsrc");
        NSString *strFilename = pickJsonStrValue(dic, @"filename");
    
        //判断文件是否已存在，存在就不取了
        NSString *strImgFile = [[CommonFunc getImgDir] stringByAppendingPathComponent:strFilename];
        if([[NSFileManager defaultManager] fileExistsAtPath:strImgFile]) {
            continue;
        }
    
        NSString *strExt = [strFilename pathExtension];
        NSString *strContentType = [CommonFunc getStreamTypeByExt:strExt];
        NSString *strFullFilename = [CommonFunc getTempDownDir];
        self.m_strFullFilename = [strFullFilename stringByAppendingPathComponent:strFilename];
    
        //形成参数
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:
                         strUrl,@"url",self.m_strFullFilename,@"filename",strContentType,@"contenttype", nil];
    
        //创建网络接口对象
        [bussRequest cancelBussRequest];
        self.bussRequest = [BussMng bussWithType:BMJYEXDownloadFile];

         //调用网络接口对象方法
        [bussRequest request:self :@selector(syncCallback_downloadImgFileProc:) :dic1];
        return;
    }
  
    //执行结束，返回反馈,及继续执行
    [self requestEndProc:sts];
    return;
    
}


//下载图片文件回调函数
- (void)syncCallback_downloadImgFileProc:(TBussStatus*)sts
{
	[bussRequest cancelBussRequest];
	self.bussRequest = nil;
	
    NSLog(@"syncCallback_downloadImgFileProc ret=%d",sts.iCode);
    
	if ( sts.iCode == 200 ) //成功
	{
		//[UIAstroAlert info:@"从服务器同步文件成功" :2.0 :NO :LOC_MID :NO];
	}
    else
	{
        [UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
		//[self dispMsg:sts.sInfo];
        
        LOG_ERROR(@"Err:download imgfile:%@", self.m_strFullFilename);
	}
    
    
    if ( sts.iCode == 200 ) {
        
        NSString *strFileName = [m_strFullFilename lastPathComponent];
    
        //正式存放目录文件
        NSString *strDownFile = [[CommonFunc getImgDir] stringByAppendingPathComponent:strFileName];
        
        //先删除
        [[NSFileManager defaultManager] removeItemAtPath:strDownFile error:nil];
        //拷贝文件
        NSError *error =nil;
        if ( ![[NSFileManager defaultManager] copyItemAtPath:m_strFullFilename toPath:strDownFile error:&error] )
        {
            NSLog(@"拷贝文件失败.src=%@,dest=%@",m_strFullFilename,strDownFile);
            NSLog(@"error:code=%d,desc=%@,reason=%@",(int)[error code],[error localizedDescription],[error localizedFailureReason]);
        }
        else
        {
            NSLog(@"拷贝文件成功.src=%@,dest=%@",m_strFullFilename,strDownFile);
            //删除临时文件
            [[NSFileManager defaultManager] removeItemAtPath:m_strFullFilename error:nil];
        }
    }
    
    if ( sts.iCode == 200
        || sts.iCode == 206  //断点续传成功
        || sts.iCode == 404 ) //文件不存在
    {
        //更改NoteXItem标志为已下载
        //TNoteXItem *pNoteXItem = [self.arrNoteXItem objectAtIndex:self.nCurItem];
        //pNoteXItem.nNeedDownlord = DOWNLOAD_NONEED;  //改为不再需要下载
        //[AstroDBMng updateNote2Item:pNoteXItem];
        //self.curItemInfo.nNeedDownlord = DOWNLOAD_NONEED;
        //[AstroDBMng addItem:self.curItemInfo];
        
        //继续取下一条笔记项
        //self.nCurItem++;
        //[self getNoteItemFile:sts];
    }
    else
    {
        //错误处理
        //[self downloadNoteEndProc:sts];
        
        //继续取下一条笔记项
        //self.nCurItem++;
        //[self getNoteItemFile:sts];
    }
    
    //继续取下一条笔记项
    self.nCurNote++;
    [self downloadImagFile:sts];
    
}


//-----------------------下载文件 end--------------------------------------

//-----------------------下载头像 start------------------------------------


//查询头像是否存在
-(void)queryAvatar
{
    [bussRequest cancelBussRequest];
    self.bussRequest = [BussMng bussWithType:BMQueryAvatar];
    [bussRequest request:self :@selector(syncQueryAvatarCallback:) :TheCurUser.sUserID];
}


- (void)syncQueryAvatarCallback:(TBussStatus*)sts
{
    [bussRequest cancelBussRequest];
	self.bussRequest = nil;
	
	if ( sts.iCode == 200) //成功
	{
		//[UIAstroAlert info:@"查询头像成功" :2.0 :NO :LOC_MID :NO];
	}
	else
	{
		//[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
	}
    
    //错误处理
    
    //处理结果
    if ( sts.iCode == 200 ) {
        //读取时间
        NSDictionary *obj = (NSDictionary *)(sts.rtnData);
        long nTime = pickJsonIntValue(obj, @"ctime");
        NSString *strTime = [NSString stringWithFormat:@"%ld",nTime];
        if ( nTime <= 0 ) {
            //执行结束，返回反馈,及继续执行
            [self requestEndProc:sts];
            return;
        }
        
        self.strAvatarTime = strTime;
        
        NSString *strCurTime = @"";
        [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"avatarTime" value:strCurTime];  //取得头像的最后更新时间戳
        NSInteger nLastTime = 0;
        if ([strCurTime length] > 0 ) {
            nLastTime = [strCurTime integerValue];
        }
        if ( nTime > nLastTime ) {//下载更新的
            [self downloadAvatar];
            return;
        }
    }
    
    //执行结束，返回反馈,及继续执行
    [self requestEndProc:sts];
    
}



//获取头像
-(void)downloadAvatar
{
    [bussRequest cancelBussRequest];
    self.bussRequest = [BussMng bussWithType:BMGetAvatar];
    [bussRequest request:self :@selector(syncGetAvatarCallback:) :TheCurUser.sUserID];
}


-(void)syncGetAvatarCallback:(TBussStatus*)sts
{
    [bussRequest cancelBussRequest];
	self.bussRequest = nil;
	
	if ( sts.iCode == 200) //成功
	{
		//[UIAstroAlert info:@"查询头像成功" :2.0 :NO :LOC_MID :NO];
	}
	else
	{
		
	}
    
    //错误处理
    
    //处理结果
    if ( sts.iCode == 200 ) {
        //读取时间
        NSString *time = self.strAvatarTime;
        [AstroDBMng setCfg_cfgMgr:@"CommonCfg" name:@"avatarTime" value:time];  //更新头像的最后更新时间戳
        //拷贝文件
        [CommonFunc CopySouceToTarget:[CommonFunc getAvatarDownloadPath] Target:[CommonFunc getAvatarPath]];
        
        //发更新头像消息
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_AVATAR object:nil userInfo:nil];
    }
    
    //执行结束，返回反馈,及继续执行
    [self requestEndProc:sts];
}



@end



