//
//  UINoteSearch.h
//  NoteBook
//
//  Created by cyl on 12-11-21.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolderList.h"
#import "UIFolder.h"

@interface SearchFolderList : UIFolderList {
    NSString *m_strSearchString;
}
-(void)setSearchString:(NSString *)str;
- (id)initWithFrame:(CGRect)frame Search:(NSString *)str;

@end

@interface UINoteSearch : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
{
    IBOutlet UIButton *m_btnSearch;
    IBOutlet UIButton *m_btnDelSearchStr;
    IBOutlet UIImageView *m_ivSearchBk;
    IBOutlet UIButton *m_btnCancel;
    IBOutlet UITextField *m_tfSearchStrInput;
    //IBOutlet UIScrollView *m_svFolderList;
    IBOutlet UITableView *m_tvFilesList;
    
    CGRect m_rectFolderList;
    CGRect m_rectFilesList;
    SearchFolderList *m_Folder;
    FilesListDataOnMonth *m_FilesListArray;
    NSString *m_strSearchString;
    
    IBOutlet UIView* m_MainView1;
    IBOutlet UIScrollView *m_scrollMainView;
    IBOutlet UIView *m_subViewMain1;
    IBOutlet UIButton *m_btnScrollBtn;
    //IBOutlet UIButton *m_btnSearch;
    //IBOutlet UIButton *m_btnSearch2;
    //IBOutlet UIScrollView *m_scrollFolderList;
    //IBOutlet UIButton *m_btnAddFolder;
    //IBOutlet UIButton *m_btnSyc;
    //IBOutlet UIButton *m_btnManageFolder;
    //IBOutlet UITextField *m_textSearch;
    
    IBOutlet UIView* m_MainView2;
    IBOutlet UIView* m_vwSubView1;
    IBOutlet UIView* m_vwSubView2;
    IBOutlet UIImageView* m_ivCheHuaBk;
    IBOutlet UIImageView *m_ivBtnSelectBk;
    IBOutlet UIButton* m_btnMainPage;
    IBOutlet UILabel *m_lUserName;
    IBOutlet UIButton* m_btnUserName;
    IBOutlet UIImageView *m_ivSSJBk;
    IBOutlet UIImageView *m_ivSSHBk;
    IBOutlet UIImageView *m_ivSSLBk;
    IBOutlet UIImageView *m_ivSSPBk;
    IBOutlet UIButton* m_btnSSJ;
    IBOutlet UIButton* m_btnSSH;
    IBOutlet UIButton* m_btnSSL;
    IBOutlet UIButton* m_btnSSP;
    IBOutlet UIButton* m_btnZJBJ;
    IBOutlet UIButton* m_btnSetting;
    IBOutlet UIButton* m_btnShare;
    
    IBOutlet UIImageView *m_ivZhongFeng;
    
    IBOutlet UIButton      *m_btnFullScreen; //全屏幕按钮
    
    //UIFolderList *m_Folder;
    //int m_iSearchState;
    BOOL m_bSearchOrBack;
    
    BOOL m_bChehua; //标识主页当前是否已经侧滑
    float m_fMainViewOffset;
    CGSize m_ScrollMainViewContentSize;
}

-(IBAction)onBack:(id)sender;
-(IBAction)onSearch:(id)sender;
-(IBAction)onCleanSearchString:(id)sender;
- (IBAction) onCheHua :(id)sender;
- (IBAction) onDownBtnOnMainView2:(id)sender;
- (IBAction) onUpBtnOnMainView2:(id)sender;
-(IBAction)OnBtnFullScreen:(id)sender;

- (void) selectBusinessType:(int)type;
-(void)showNoSearchResult;

-(void)drawFolder;
-(void)drawMainPage;
-(void)getUserName;
@end
