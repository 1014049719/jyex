//
//  UILastNote.h
//  NoteBook
//
//  Created by cyl on 12-11-23.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolderList.h"
#import "UIFolder.h"
#import "EGORefreshTableHeaderView.h"

@interface UILastNote : UIViewController<UITableViewDataSource, UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    IBOutlet UIButton *m_btnBack;
    IBOutlet UITableView *m_tvFilesList;
    IBOutlet UIImageView *m_ivHead;
    
    //IBOutlet UIView *m_viewSynAndSearch;
    //IBOutlet UIButton *m_btnSyn;
    //IBOutlet UIButton *m_btnSearch;
    //IBOutlet UILabel *m_labelSysString;
    //IBOutlet UILabel *m_labelLastSynTime;
    //IBOutlet UIImageView *m_ivSearchBk;
    //IBOutlet UITextField *m_tfSearchInput;
    //IBOutlet UIImageView *m_ivSync;

    float m_filesListOffset;
     NSUInteger m_uMiniFiles;
    NSUInteger m_uFilesCount;
    FilesListDataOnMonth *m_FilesListArray;
    unsigned long syncid;  //同步返回的ID，用于取消同步的回调
    unsigned char syncflag;
    unsigned char nNeedSyncFlag;
    CGPoint offset;
    BOOL m_bHuadong;
    
    unsigned char loginflag; //登录标志

    EGORefreshTableHeaderView *_refreshHeaderView;
    
}
-(IBAction)onBack:(id)sender;
//同步当前文件夹
-(BOOL)syncCatalog;
//同步的回调
- (void)syncCallback:(TBussStatus*)sts;
//-(IBAction)onSearch:(id)sender;

@end
