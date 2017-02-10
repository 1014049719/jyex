//
//  NoteFolderOrder.m
//  NoteBook
//
//  Created by cyl on 13-3-3.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import "NoteFolderOrder.h"
#import "PubFunction.h"
#import "GlobalVar.h"
#import "Global.h"
#import "BizLogicAll.h"

@implementation NoteFolderOrder

+(void)OrderWithCateArray:(NSArray*)sourceCateArray DesArray:(NSMutableArray*)desCateArray
{
    if ( sourceCateArray && desCateArray ) {
        TCateInfo* info = nil;
        TCateInfo* temp = nil;
        int minOrder = 0;
        for ( int i = 0; i < [sourceCateArray count]; ++i ) {
            info  = (TCateInfo*)[sourceCateArray objectAtIndex:i];
            if ( info.nOrder <= minOrder || 0 == i ) {
                minOrder = info.nOrder;
                [desCateArray addObject:info];
                continue;
            }
            for ( int n = 0; n < i; ++n) {
                temp = (TCateInfo*)[desCateArray objectAtIndex:n];
                if ( info.nOrder > temp.nOrder ) {
                    [desCateArray insertObject:info atIndex:n];
                    break;
                }
            }
        }
    }
}

+(void)SetOrderWithCateArray:(NSArray*)cateArray
{
    if ( cateArray ) {
        int c = [cateArray count];
        TCateInfo* info = nil;
        for ( int i = 0; i < [cateArray count]; ++i ) {
            info = (TCateInfo*) [cateArray objectAtIndex:i];
            info.nOrder = (c--);
        }
    }
}
@end
