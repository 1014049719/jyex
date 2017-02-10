//
//  UIFolderPaiXu.h
//  NoteBook
//
//  Created by zd on 13-2-21.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolderItemView.h"

@interface UIFolderOrderItem : UIFolderItemView
{
    BOOL m_bOrderChange;
}
-(void)setOrder:(int)newOrder SetChengeFlag:(BOOL)bFlag;
-(BOOL)orderIsChage;
@end

@interface UIFolderOrderCell : UITableViewCell {
@private
    UIFolderOrderItem *m_FolderItem;
    //UIFolderItemView *m_FolderItem;
}
-(void)setFolderItem:(UIFolderOrderItem*)item;
//-(void)setFolderItem:(UIFolderItemView*)item;
@end

@interface UIFolderPaiXu : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIButton *m_btnBack ;
    IBOutlet UIButton *m_btnFinish ;
    IBOutlet UITableView *m_tvFolderList;
    
    NSString *m_strFolderGuid;
    NSMutableArray *m_FolderList;
    BOOL m_bNeedUpdata;
}

-(void)dealloc;
-(IBAction)OnBack:(id)sender ;
-(IBAction)OnFinish:(id)sender ;

-(BOOL)updataFolderOrder;
-(int)getFolderListFromDB;
-(void)resetOrder;
//-(void)cleanFolderList;
@end
