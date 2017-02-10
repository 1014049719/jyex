/*
 *  LoginDelegate.h
 *  pass91
 *
 *  Created by Zhaolin He on 09-8-6.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#import "MBBaseStruct.h"

@protocol P91PassDelegate<NSObject>
@optional
-(void)loginDidSuccessWithData:(NSData *)data inputStream:(NSInputStream *)input outputStream:(NSOutputStream *)output;
-(void)loginDidFailedWithError:(NSError *)error;
-(void)justTestUse;

-(void)logoutDidSuccess;
-(void)logoutDidFailedWithError:(NSError *)error;

-(void)getDefDirDidSuccessWithData:(CMBGetDefCataListAck *)items;
-(void)getDefDirDidFailedWithError:(NSError *)error;

-(void)getSubDirDidSuccessWithData:(CMBSubDirListAck *)items;
-(void)getSubDirDidFailedWithError:(NSError *)error;

-(void)getAllDirListDidSuccessWithData:(CMBAllDirListAck *)items;
-(void)getAllDirListDidFailedWithError:(NSError*)error;

-(void)upLoadNoteDidSuccessWithData:(CMBUpLoadNoteExAck *)items; 
-(void)upLoadNoteDidFailedWithError:(NSError *)error;

-(void)upLoadA2BInfoDidSuccessWithData:(CMBUpLoadA2BInfoAck *)items; 
-(void)upLoadA2BInfoDidFailedWithError:(NSError *)error;

-(void)upLoadItemDidSuccessWithData:(CMBUpLoadItemNewAck *)items; 
-(void)upLoadItemDidFailedWithError:(NSError *)error;

// xia zai 
-(void)getNoteListDidSuccessWithData:(CMBNoteListExAck *)items; 
-(void)getNoteListDidFailedWithError:(NSError *)error;

-(void)getA2BListDidSuccessWithData:(CMBA2BListAck *)items; 
-(void)getA2BListDidFailedWithError:(NSError *)error;

-(void)getItemInfoDidSuccessWithData:(CMBItemNewAck *)items; 
-(void)getItemInfoDidFailedWithError:(NSError *)error;

-(void)getShareInfoDidSuccessWithData:(CMBShareByCataListAck *)items; 
-(void)getShareInfoDidFailedWithError:(NSError *)error;

-(void)requiredReLogin;
-(void)timeOut;

-(void)registerDidSuccessWithInfo:(NSDictionary *)info;
-(void)registerDidFailedWithError:(NSError *)error;

-(void)getBackPassDidSuccess;
-(void)getBackPassDidFailedWithError:(NSError *)error;

- (void)getA2BInfoDidSuccessWithData:(CMBA2BInfo)a2bInfo;
- (void)getA2bInfoDidFailedWithError:(NSError *)error;

- (void)getNoteThumbDidSuccessWithData:(CMBNoteThumbAck*)pThumbInfo;
- (void)getNoteThumbDidFailedWithError:(NSError*)error;

-(void)getSearchNoteDidSuccessWithData:(CMBSearchNoteExAck *)items; 
-(void)getSearchNoteDidFailedWithError:(NSError *)error;

-(void)startDisplayLoginInfo;
-(void)stopDisplayLoginInfo;

@end