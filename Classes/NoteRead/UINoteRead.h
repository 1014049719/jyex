//
//  UINoteRead.h
//  NoteBook
//
//  Created by susn on 12-11-21.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBMngAll.h"
#import "PlayView.h"
#import "UIMyWebView.h"

#import "RTEGestureRecognizer.h"

#define _USE_NOTEWEBVIEW

#ifdef _USE_NOTEWEBVIEW
#define _mywebview  m_noteContentWebView
#endif


@interface UINoteRead : UIViewController<UIWebViewDelegate,PlayViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIScrollViewDelegate,MyWebViewDelegate>
{
    //标题
    IBOutlet UILabel  *m_lbTitle;
    //WEB页面
    IBOutlet UIWebView  *m_noteContentWebView;  //不再使用
    //scrollview
    IBOutlet UIScrollView *m_scrollview;
    IBOutlet UIView *m_barView;
    
    IBOutlet UIButton *m_btnToolCancel;
    IBOutlet UIButton *m_btnToolOpr;
    IBOutlet UIButton *m_btnToolLastNote;
    IBOutlet UIButton *m_btnToolNextNote;
    //工具栏整体按钮
    IBOutlet UIView *m_toolView;
    
#ifdef _USE_NOTEWEBVIEW   
    RTEGestureRecognizer *_singleRecognizer;
#else
    //UIMyWebView *_mywebview;
#endif    
    
    CGFloat webviewheight; //webview的原始高度
    
    PlayView *m_PlayView;
    
    //取笔记内容
    TNoteInfo *m_NoteInfo;

    //取本目录内所有笔记的GUID
    NSArray *m_arrNoteGuid;
    int curnotepos;  //当前笔记在笔记列表中的位置。
    
    //同步数据
    unsigned long syncid;
    int syncflag;  //0:没有同步 1:正在同步
    
    //是否需要编辑引起的同步
    BOOL bNeedEdit;
    
    NSMutableArray *arrSyncNoteGuid; //已经同步过的GUID
    
    CGPoint m_velocity;
    
    CGPoint touchpoint;
    //点击图像
    int m_hintImageFlag;
    CGPoint hintpoint;    
    int tapImageFlag; //是否点击了图片
    int tapTriggerFlag; //是否已触发了图片展示。
    NSString *strTapImageFile; //点击的图片文件名
    NSString *strTapImageUrl;  //图片关联的URL链接.
    
    //滚动
    CGPoint startPoint;
}

@property (nonatomic, retain) TNoteInfo *m_NoteInfo;
@property (nonatomic, retain) NSArray *m_arrNoteGuid;
@property (nonatomic, assign) unsigned long syncid;
@property (nonatomic, assign) int syncflag;
@property (nonatomic, retain) NSMutableArray *arrSyncNoteGuid;
@property (nonatomic, retain) NSString *strTapImageFile;
@property (nonatomic, retain) NSString *strTapImageUrl;


- (IBAction) onToolCancel:(id)sender;
- (IBAction) onToolOprNote:(id)sender;
- (IBAction) onToolLastNote:(id)sender;
- (IBAction) onToolNextNote:(id)sender;

- (IBAction) onClickScreen:(id)sender;

-(BOOL) procChangeNote;
- (void)flashContent;

- (void)reRoadData;

//同步当前笔记
-(void)syncNote;

- (void)execSyncAfterThreeSeconds;

//-(void)dispImage:(NSString *)strFileName;

//显示工具栏
- (void)displayToolView;
- (void)hideToolView;

- (IBAction) onNoteInfo:(id)sender;

//更新星级
-(void)updataNoteStar:(NSNotification *)note; 
@end
