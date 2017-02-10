//
//  AppServerLogin.h
//  idCard91
//
//  Created by Zhaolin He on 09-8-21.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "91NoteAppStruct.h"
#import "NoteLoginLBSStruct.h"
#import "MBBaseStruct.h"

@protocol P91PassDelegate;
@interface AppServerLogin : NSObject {
	NSString *username;
	NSString *password;
	id<P91PassDelegate> delegate;
    BOOL isLogined;
@private
	NSInputStream *input; 
	NSOutputStream *output;
	NSMutableData *temp_data;
	NSTimer *timer;
    NSTimer *sendTickTimer;
}
-(id)initWithSrvInfo:(NOTE_LOGIN_LBS_REPLY)info;
-(int)startRequest;

@property(nonatomic,retain)NSString *username;
@property(nonatomic,retain)NSString *password;
@property(nonatomic,assign)id<P91PassDelegate> delegate;
@property BOOL isLogined;
@end
