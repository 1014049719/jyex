//
//  UINoteEdit.h
//  NoteBook
//
//  Created by susn on 12-11-15.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PubFunction.h"
#import "DBMngAll.h"
//#import "UIDrawerDelegate.h"
#import "RecordView.h"
#import "PlayView.h"
#import "CameraOverlayView.h"
#import "UICameraOverlay.h"

//#import "UIMyWebView.h"

//#import "RTEGestureRecognizer.h"

#define _USE_NOTEWEBVIEW

#ifdef _USE_NOTEWEBVIEW
#define _mywebview  m_noteContentWebView
#endif



@interface UINoteEdit : UIViewController<UIWebViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,
    UIImagePickerControllerDelegate,UINavigationControllerDelegate,RecordViewDelegate,PlayViewDelegate,UICameraDelegate,CameraOverlayViewDelegate,UITableViewDataSource, UITableViewDelegate>
{
    //导航栏
    IBOutlet UIView* m_navView;
    IBOutlet UIButton *m_btnNavCancel;
    IBOutlet UIButton *m_btnNavCamera;
    IBOutlet UIButton *m_btnNavPhoto;
    IBOutlet UIButton *m_btnNavDraw;
    IBOutlet UIButton *m_btnNavRecord;
    IBOutlet UIButton *m_btnNavFinish;
    
    //工具栏
    IBOutlet UIView* m_toolView;
    IBOutlet UIButton *m_btnToolBold;
    IBOutlet UIButton *m_btnToolUnderline;
    IBOutlet UIButton *m_btnToolItalic;
    IBOutlet UIButton *m_btnToolInfo;
    IBOutlet UIButton *m_btnToolHide;
    
    IBOutlet UIButton *m_btnToolShow;
    
    //标题view
    IBOutlet UIView  *m_titleView;
    //标题
    IBOutlet UITextField *m_tfTitleField;
    //WEB页面
    IBOutlet UIWebView  *m_noteContentWebView;
 
    //scrollview
    IBOutlet UIScrollView *m_scrollview;
    
    
#ifdef _USE_NOTEWEBVIEW   
    //RTEGestureRecognizer *_singleRecognizer; //2015.3.31
#else
    //UIMyWebView *_mywebview;
#endif    
    
    
    RecordView *m_RecordView;
    PlayView *m_PlayView;
    
    CGFloat webviewheight; //webview的原始高度
    
    //参数，noteGuid或空
    MsgParam* msgParam;
    
    //笔记Guid
    NSString *m_strNoteGuid;
    //取笔记内容
    TNoteInfo *m_NoteInfo;
    
    //临时笔记对象,用于存储修改后的星级
    TNoteInfo *m_TempNoteInfo;
    
    //存放项目项的item
    NSMutableArray *m_ItemArr;
    //存放保存到日志图片的item //2014.9.23
    NSMutableArray *m_arrItemGuid;
    NSMutableArray *m_arrPicItemGuid;
    
    //scrollview, webview变化的高度
    CGFloat changeheigt;
    
    //按钮的image
    UIImage *imgBold1;
    UIImage *imgBold2;
    UIImage *imgUnderline1;
    UIImage *imgUnderline2;
    UIImage *imgItalic1;
    UIImage *imgItalic2;
    BOOL bBold;
    BOOL bUnderline;
    BOOL bItalic;
    NSTimer *timer;  //刷新定时器
    
 
    int  nNotProcessKeyboard;
    
    BOOL bWebIsEdit;
    CGPoint touchpoint;
    CGPoint  weboffset;
    CGSize m_contentSize;
    int  m_returnKeyNum;
    int keyboardShowNum;
    
    //点击图像
    int m_hintImageFlag;
    CGPoint hintpoint;
    
    //cotent 和 scrollview之间的高度差距
    int heightInterval;
    
    //是否已设置字体
    BOOL bSetFontSize;
    
    BOOL bFirst;
    
    NSMutableArray *arrayNoteTypeList;
    int nNoteTypeIndex;
    NSString *strCurNoteType;
    IBOutlet UILabel *labelNoteType;
    IBOutlet UIButton *btnDropNoteList;
    IBOutlet UIView *vwNoteType;
    IBOutlet UITableView *twNoteTypeList;
    IBOutlet UIButton *btnHideNoteTypeList;
}


@property (nonatomic, retain) MsgParam  *msgParam;
@property (nonatomic, retain) NSString  *m_strNoteGuid;
@property (nonatomic, retain) TNoteInfo *m_NoteInfo;
@property (nonatomic, retain) NSMutableArray *m_ItemArr;
@property (nonatomic, retain) NSMutableArray *m_arrItemGuid;
@property (nonatomic, retain) NSMutableArray *m_arrPicItemGuid;
@property (nonatomic, retain) UIImage *imgBold1;
@property (nonatomic, retain) UIImage *imgBold2;
@property (nonatomic, retain) UIImage *imgUnderline1;
@property (nonatomic, retain) UIImage *imgUnderline2;
@property (nonatomic, retain) UIImage *imgItalic1;
@property (nonatomic, retain) UIImage *imgItalic2;
@property (nonatomic, retain) NSMutableArray *arrayNoteTypeList;
@property (nonatomic, retain) NSString *strCurNoteType;


- (IBAction) onNavCancel :(id)sender;
- (IBAction) onNavCamera :(id)sender;
- (IBAction) onNavPhoto:(id)sender;
- (IBAction) onNavDraw:(id)sender;
- (IBAction) onNavRecord:(id)sender;
- (IBAction) onNavFinish:(id)sender;

- (IBAction) onToolBold:(id)sender;
- (IBAction) onToolUnderline:(id)sender;
- (IBAction) onToolItalic:(id)sender;
- (IBAction) onToolInfo:(id)sender;
- (IBAction) onToolHide:(id)sender;
- (IBAction) onToolShow:(id)sender;
- (IBAction)onDispOrHideNoteType:(id)sender;

-(void) flashContent;
-(void)updataNoteStar:(NSNotification *)note;
//录音的代理
-(void) RecordFinish:(RecordView *) RecordView successfully:(BOOL)flag;
-(void)insertRecordFile:(NSString *)strRecordFile;

//播放的代理
-(void) PlayFinish;
-(void) playFile:(NSString *)strFileName;

//手势的回调函数
-(void) hangleSingleTapFrom;

- (void)loadCamera;
- (void)loadPhoto;

- (void)webViewhideKeyBoard;

//设置高度
-(void)setWebViewHeight;


@end
