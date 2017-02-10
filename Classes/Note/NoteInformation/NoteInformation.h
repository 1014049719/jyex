//
//  NoteInformation.h
//  NoteBook
//
//  Created by mwt on 12-11-8.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DbMngDataDef.h"

@interface NoteInformation : UIViewController{
    IBOutlet UIButton *m_btnTitle ; //笔记标题按钮
    IBOutlet UIButton *m_btnStart1 ; //笔记星级
    IBOutlet UIButton *m_btnStart2 ;
    IBOutlet UIButton *m_btnStart3 ;
    IBOutlet UIButton *m_btnStart4 ;
    IBOutlet UIButton *m_btnStart5 ;
    IBOutlet UILabel *m_lbFolder ; //文件夹
    IBOutlet UILabel *m_lbLabel ; //标签
    IBOutlet UILabel *m_lbCreateTime ;//创建时间
    IBOutlet UILabel *m_lbUpdateTime ; //修改时间
    IBOutlet UILabel *m_lbLYWZ ; //来源网址
    
    IBOutlet UIButton *m_btnFolder ;
    IBOutlet UIButton *m_btnlable ;
    IBOutlet UIButton *m_btnLYWZ ;
    
    BOOL  m_StartStatus[5] ; //星星亮暗状态 
    int   m_StartSelectIndex ;//当前点击那个星星按钮，以0开始
    int m_iStar;
    NSString *m_strNoteGuid;
    TNoteInfo *m_NoteInfo;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NoteGuid:(TNoteInfo*)NoteInfo;

-(void)InitStartStatus ; //初始化星星亮暗状态
-(void)ShowStart ; //显示星星

-(IBAction)OnTitle:(id)sender ;
-(IBAction)OnStart1:(id)sender ;
-(IBAction)OnStart2:(id)sender ;
-(IBAction)OnStart3:(id)sender ;
-(IBAction)OnStart4:(id)sender ;
-(IBAction)OnStart5:(id)sender ;
-(IBAction)OnFolder:(id)sender ;
-(IBAction)OnLabel:(id)sender ;
-(IBAction)OnLYWZ:(id)sender ;
-(IBAction)OnOpenSourceURL:(id)sender;

-(void)DrawView;

-(void)ShowNoteInfo ;
-(void)ChangeStartLevel;

@end

