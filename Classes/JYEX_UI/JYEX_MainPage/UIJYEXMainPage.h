//
//  UIJYEXMainPage.h
//  NoteBook
//
//  Created by cyl on 13-4-24.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussMng.h"

@class UIAppList;
@interface UIJYEXMainPage : UIViewController
{
    IBOutlet UILabel *m_lableSection1;
    IBOutlet UILabel *m_lableSection2;
    IBOutlet UIScrollView *m_swAppList;
    
    IBOutlet UIButton *m_btnCamer;
    IBOutlet UIButton *m_btnEditLog;
    IBOutlet UIButton *m_btnSend;
    IBOutlet UIButton *m_btnSetting;
    
    IBOutlet UIView *m_vwComBack;
    IBOutlet UILabel *m_labelComTitle;
    IBOutlet UITextView *m_twComText;
    IBOutlet UIButton *m_btnClostCom;
    
    IBOutlet UIImageView *m_imTips;
    IBOutlet UILabel *m_lbTips;
    
    
    NSArray *boughtApp;
    NSArray *nominateApp;
    
    NSTimer *timer;  //刷新定时器
    NSTimeInterval m_timeinterval;
    
    BussMng* bussRequest;
}

@property(nonatomic, retain) NSArray *boughtApp;
@property(nonatomic, retain) NSArray *nominateApp;
@property (nonatomic,retain) BussMng *bussRequest;


-(void)drawAppList;
-(void)onSelectApp:(id)appInfo;
-(IBAction)onBlog:(id)sender;
-(IBAction)onSend:(id)sender;
-(IBAction)onCamera:(id)sender;
-(IBAction)onSetting:(id)sender;
-(IBAction)onCloseCom:(id)sender;
//test
-(IBAction)onPictureSend:(id)sender ;
-(IBAction)onTest:(id)sender ;


@end
