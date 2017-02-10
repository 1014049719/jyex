//
//  GlobalPictureCounter.m
//  JYEX
//
//  Created by zd on 15-2-3.
//  Copyright (c) 2015年 广州洋基. All rights reserved.
//

#import "GlobalPictureCounter.h"

@implementation GlobalPictureCounter

static GlobalPictureCounter *sharedInstance = nil;
static int PictureCount = 0 ;

+ (GlobalPictureCounter*) getGlobalPictureCounterInstance
{
    if( sharedInstance == nil )
    {
        sharedInstance = [[GlobalPictureCounter alloc] init];
    }
    return sharedInstance;
}

- (int)getPictureCount
{
    return PictureCount;
}

- (void)setPictureCount:(int)count
{
    PictureCount = count;
}

@end
