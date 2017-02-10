//
//  NoteFolderOrder.h
//  NoteBook
//
//  Created by cyl on 13-3-3.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteFolderOrder : NSObject
{
    
}
+(void)OrderWithCateArray:(NSArray*)sourceCateArray DesArray:(NSMutableArray*)desCateArray;

+(void)SetOrderWithCateArray:(NSArray*)cateArray;
@end
