//
//  GlobalPictureCounter.h
//  JYEX
//
//  Created by zd on 15-2-3.
//  Copyright (c) 2015年 广州洋基. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalPictureCounter : NSObject

+ (GlobalPictureCounter*) getGlobalPictureCounterInstance;
- (int)getPictureCount;
- (void)setPictureCount:(int)count;
@end
