//
//  MBDataStruct.h
//  NoteBook
//
//  Created by chen wu on 09-9-3.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//
//#import "MBBaseStruct.h"
//#import "UpStruct.h"
//
//@class MBListener;
//NSString * GUID2NSString(GUID *pGuid);
//BOOL NSString2GUID(GUID *pGuid,NSString *strGUID);
//
//typedef struct UPLOAD_STURCT UP_STRUCT;
//
//@interface MBDataStruct : NSObject {
//	//id<P91PassDelegate> delegate;
//	CMBItemNew itemInfo;
//	CMBNoteInfoEx noteInfo;
//	CMBA2BInfo  relateInfo;
//}
//
//@property(nonatomic,assign)id<P91PassDelegate> delegate;
// note
//- (void)setNoteInfo:(UP_STRUCT*)upObj;
//- (CMBNoteInfoEx)getNoteInfo;
//- (BOOL)isEmptyNote;
//
// item
//- (void)setItemInfo:(id)item type:(ENUM_ITEM_TYPE)type	itemId:(NSString *)itemId  fExt:(NSString *)ext;
//- (CMBItemNew)getItemInfo;
//- (BOOL)isEmptyItem;
//
//relation
//- (CMBA2BInfo)getRelation;
//- (BOOL)setRelationWithNoteId:(NSString *)noteId itemId:(NSString *)itemId state:(NO_STATE)nState;
//
//share
//- (void)releaseBuffer;
//
//@end
