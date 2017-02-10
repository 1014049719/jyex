//
//  idCard91ViewController.h
//  idCard91
//
//  Created by Zhaolin He on 09-8-18.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//  

#import <UIKit/UIKit.h>
#import "P91PassDelegate.h"
#import "NoteLoginLBSStruct.h"

#define _INTERNET_SERVER_

//服务器信息
#ifdef _INTERNET_SERVER_
//外网服务器
#define NOTE_HOST	@"mbsrv.91.com"
#define NOTE_PORT 81
#define NOTE_SVRTYPE @"6"
#define NOTE_LBS_SVRNAME @"appsvr"//	//负载均衡服务器的名字

#else

//内网服务器
#define NOTE_HOST	@"192.168.94.17"
#define NOTE_PORT 10043
#define NOTE_SVRTYPE @"6"
#define NOTE_LBS_SVRNAME @"appsvr"//	//负载均衡服务器的名字
#endif


@protocol P91PassDelegate;
@class AppServerLogin;
@interface LbsServer : NSObject <P91PassDelegate,NSStreamDelegate> {
	id<P91PassDelegate> delegate;
@private
	NSString *username;
	NSString *pass;
	NSString *appType;
	
	NSInputStream *input; 
	NSOutputStream *output;
	NSMutableData *temp_data;
	NSTimer *timer;
	AppServerLogin *appBusiness;
    
    BOOL bIsLBSLogined;   //LBS是否登录
}

+(LbsServer *)shareLbServer;

-(void)createWithUsername:(NSString *)uname Password:(NSString *)passwd APpType:(NSString *)type delegate:(id)obj;
-(id)initWithUsername:(NSString *)uname Password:(NSString *)passwd AppType:(NSString *)type delegate:(id)obj;
-(void)startLogin;
-(void)reloginAppSvr;
@property(nonatomic,assign)id<P91PassDelegate> delegate;
@property BOOL bIsLBSLogined;
@end

