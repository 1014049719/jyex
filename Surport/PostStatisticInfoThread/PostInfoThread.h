/*
 *  PostInfoThread.h
 *  NoteBook
 *
 *  Created by Huang Yan on 9/7/09.
 *  Copyright 2009 fj. All rights reserved.
 *
 */

#if !defined POST_INFO_THREAD_H_
#define POST_INFO_THREAD_H_

#import <UIKit/UIKit.h>
#import "Logger.h"
//#import "Responds.h"
#import <CommonCrypto/CommonDigest.h>

const int product_id = 15;

@interface PostInfoThread : NSOperation

+ (void)Post;

@end

#endif
