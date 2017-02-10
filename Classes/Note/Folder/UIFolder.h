//
//  UIFolder.h
//  NoteBook
//
//  Created by cyl on 12-11-12.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFilesItem.h"
#import "UIFolderList.h"
#import "EGORefreshTableHeaderView.h"

#pragma mark - FilesListDataOnMonth
@interface FilesListDataOnMonth : NSObject {
@public
    NSUInteger m_Year;
    NSUInteger m_Month;
    NSMutableArray *m_FilesList;
}
-(void)addFilesItem:(UIFilesItem*)filesItem;
-(UIFilesItem *)getFilesItemWithIndex:(NSUInteger)index;
-(NSInteger)getCount;
-(void)FreeFileListUI;
@end

#pragma mark - UIFileItemCell
@interface UIFileItemCell : UITableViewCell {
@public
    UIFilesItem *m_FilesItem;
    UIImageView *m_Separator;
    NSString *m_strFileGUID;
    
    //add by zd 2014-03-19
    //UIImageView *m_picture ;
}

-(void)setFilesItem:(UIFilesItem*)fileItem ShowSeparator:(BOOL)separator;
@end

#pragma mark - EmptyCell
@interface EmptyCell : UITableViewCell {
}

-(void)setBackgroundFram:(CGRect)r;
@end

#pragma mark - UISysAndSearchCell
/*
@interface UISysAndSearchCell : UITableViewCell {
@private
    UIView *m_viewSynAndSearch;
}
-(void)setSynAndSearchView:(UIView*)view WithOriginY:(float)y;
@end
*/

#pragma mark - UIFolderListCell
@interface UIFolderListCell : UITableViewCell
{
    UIFolderList *m_Folder;
    UIView *m_viewBackground;
}

-(void)setFolderList:(UIFolderList*)folderList WithWidth:(int)width;
@end


//#pragma mark - UIEmptyCell
//@interface UIEmptyCell : UITableViewCell {
//@private
//    UIView *m_viewSynAndSearch;
//}
//-(void)setSynAndSearchView:(UIView*)view WithOriginY:(float)y;
//@end

@interface UIFolder : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,EGORefreshTableHeaderDelegate>
{
    IBOutlet UITableView *m_tvFilesList;
    IBOutlet UIImageView *m_ivHead;
    IBOutlet UILabel *m_labelFolderName;
    IBOutlet UIButton *m_btnBack;
    IBOutlet UIButton *m_btnNewFiles;
    //IBOutlet UIView *m_viewSynAndSearch;
    //IBOutlet UIButton *m_btnSyn;
    //IBOutlet UIButton *m_btnSearch;
    //IBOutlet UILabel *m_labelSysString;
    //IBOutlet UILabel *m_labelLastSynTime;
    //IBOutlet UIImageView *m_ivSearchBk;
    //IBOutlet UITextField *m_tfSearchInput;
    //IBOutlet UIImageView *m_ivSync;
    
    UIFolderList *m_Folder;
    float m_filesListOffset;
    NSMutableArray *m_FilesOnMonth;
    NSUInteger m_uFilesCount;
    NSUInteger m_uMiniFiles;
    NSString *m_strFolderGUID;
    BOOL m_bHuadong;
    
    unsigned long syncid;  //同步返回的ID，用于取消同步的回调
    unsigned char syncflag;
    unsigned char nNeedSyncFlag;
    CGPoint offset;
    
    unsigned char loginflag; //登录标志
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    UIViewController *m_Menu;
    
    //NSTimer *timer; //同步刷新图符
    //CGFloat angle; //转的角度
    BOOL m_bFirstGetNavTitle;
    
    UIViewController*		vcMenu;
    IBOutlet UIImageView *m_TouLanMenu ;
}

@property (nonatomic, retain) UIViewController* vcMenu;

-(IBAction)onBack:(id)sender;
-(IBAction)onAddFile:(id)sender;
//-(IBAction)onSearch:(id)sender;
-(IBAction)onFilePaiXuSelect:(id)sender;

-(IBAction)onDisplay:(id)sender;

-(void)drawFolderList;
- (void) reRoadTableView;
-(void)drawFolderContent;
-(NSUInteger)getFilesListData;
-(void)FreeFilesList;
-(void)drawHeadBk;
-(void)drawFilesListAnimation:(BOOL)animated;

- (void) onChildClose :(id)child :(id)state;

//同步当前文件夹
-(BOOL)syncCatalog;
//同步的回调
- (void)syncCallback:(TBussStatus*)sts;

- (void)egoRefreshTableHeaderDidSearch:(EGORefreshTableHeaderView*)view text:(NSString *)text;
-(void)dealloc;

@end
