//
//  MBListener.h
//  NoteBook
//
//  Created by chen wu on 09-9-7.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "MBBaseStruct.h"
#import <Foundation/Foundation.h>
#import "P91PassDelegate.h"
#import "MBBaseStruct.h"
#import "MBUpLoadNoteMsg.h"
#import "MBUpLoadItemMsg.h"
#import "MBUpLoadA2BInfoMsg.h"
#import "MBGetDefCataListMsg.h"
#import "LbsServer.h"

@protocol P91PassDelegate;

typedef enum UPLOAD_STATE
	{
		UP_NOTE,
		UP_A2B,
		UP_ITEM,
		UP_IDLE
	}UP_STATE;


@interface MBListener : NSObject<UIActionSheetDelegate,P91PassDelegate> 
{
//	MBDataStruct * uploadObj;
//	UP_STRUCT * uploadData;
//	NSString  * msgName;
//	id		   msgTarget;
    
	id<P91PassDelegate> delegate;
    MBGetDefCataListMsg *dirMsg;
//	UP_STATE	upState;
	
	NSString *usrName;
	NSString *passWd;

    std::list<NoteInfo> noteList;
    std::list<ItemInfo> itemList;
    std::list<NoteInfo>::iterator noteIterator;
    std::list<ItemInfo>::iterator itemIterator;
    BOOL                isItemUploadSuccess; //记录当前是否发生上传失败
	//LbsServer *server;
    PSocket*    currentSocket;
}
@property(nonatomic,assign)id<P91PassDelegate> delegate;

+ (id)defaultListener;

- (void)stop;
- (void)uploadNoteList:(std::list<NoteInfo>*)pNoteList;
- (void)uploadFinished:(BOOL)isSuccess;
- (void)startUpload;

- (void)getANoteThumb;
- (void)uploadANote;
- (void)uploadAItem;
- (void)uploadItemInfo;
- (void)uploadNoteInfo;
- (void)uploadMore;
- (void)uploadFinished:(BOOL)isSuccess;

@end;
