//
//  UapMgr.h
//  NoteBook
//
//  Created by wangsc on 10-11-25.
//  Copyright 2010 ND. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UapMgr : NSObject {
	NSString *sessionId;
}
@property (nonatomic, copy) NSString* sessionId;

+ (UapMgr*)instance;

- (void)uapLogin;

- (BOOL)uapLoginAsync;


@end
