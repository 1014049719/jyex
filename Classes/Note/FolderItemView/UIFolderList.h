//
//  UIFolderList.h
//  NoteBook
//
//  Created by cyl on 12-11-5.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolderItemView.h"

@interface UIFolderList : UIView
{
    NSMutableArray *m_FolderItemList;
}

-(void)drawFolderListWithGUID:(NSString*)strGUID;
-(void)drawFolderList;
-(NSArray *)getFolderListData;
-(NSArray *)getFolderListDataWithGUID:(NSString*)strGUID;
-(int)getFolderCount;
@end
