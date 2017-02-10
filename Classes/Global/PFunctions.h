//
//  PFunctions.h
//  pass91
//
//  Created by Zhaolin He on 09-8-6.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>


@interface PFunctions : NSObject 
{

}


+(NSString *)md5Digest:(NSString *)str;

+(void)createConfigFile;
+(NSString *)getConfigFile;

+(void)setBackgroudLogin:(BOOL)login;
+(BOOL)getBackgroudLogin;

+(void)initUsername:(NSString *)userName;
+(void)initPassname:(NSString *)passName;
+(NSString *)getUsernameFromKeyboard;
+(NSString *)getPassnameFromKeyboard;

+(NSString *)getUserName;
+(NSString *)getPassword;
+(NSData *)getMasterKey;
+(NSString *)getSavedState;
+(NSString *)getLoginKeepState;
+(NSString *)getAccount;
+(NSString *)getLoginfo;
+(NSString *)getUserId;
+(NSString *)getPhotoQuality;

+(void)setUsername:(NSString *)user Password:(NSString *)pass;
+(void)setSavedState:(NSString *)state;
//+(void)setMasterKey:(NSString *)key;
+(void)setMasterKey:(NSData *)data;
+(void)setLoginKeepState:(NSString *)state;
+(void)setAccount:(NSString *)account;
+(void)setLogInfo:(NSString *)loginfo;
+(void)setPhotoQuality:(NSString *)quality;


@end
