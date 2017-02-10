//
//  NoteConfig.h
//  NoteBook
//
//  Created by mwt on 12-11-8.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface NoteConfig : UIViewController
{
    IBOutlet  UIButton  *m_btnFinish ;
    IBOutlet  UIScrollView *m_ScrollView ;
    IBOutlet  UILabel *m_lbUserName ;
    IBOutlet  UILabel *m_lbPassWordSet ;//软件启动密码
    IBOutlet  UIImageView *m_ivTBSSCGX ; //同步上传更新复选框图像视图
    IBOutlet  UIImageView *m_ivTBSXZWZBJ ; //同步时下载完整笔记
    IBOutlet  UILabel *m_lbTXZL ; //图像质量
    IBOutlet  UILabel *m_lbZTDX ; //字体大小
    IBOutlet  UILabel *m_lbWBGS ; //文本格式
    IBOutlet  UILabel *m_lbFolderPassWordSet ; //文件夹密码设置
    IBOutlet  UILabel *m_lbVersion ; //版本信息
    IBOutlet  UIView  *m_viLast;
    
    IBOutlet UIButton *m_btnFirst1;
    IBOutlet UIButton *m_btnFirst2;
    IBOutlet UIButton *m_btnFirst3;
    IBOutlet UIButton *m_btnFirst4;
    IBOutlet UIButton *m_btnFirst5;
    
    IBOutlet UIButton *m_btnInter1;
    IBOutlet UIButton *m_btnInter2;
    IBOutlet UIButton *m_btnInter3;
    IBOutlet UIButton *m_btnInter4;
    IBOutlet UIButton *m_btnInter5;
    
    IBOutlet UIButton *m_btnEnd1;
    IBOutlet UIButton *m_btnEnd2;
    IBOutlet UIButton *m_btnEnd3;
    IBOutlet UIButton *m_btnEnd4;
    IBOutlet UIButton *m_btnEnd5;
    

    BOOL  m_bTBWifiOnly ; //仅在WiFi连接时自动同步
    BOOL  m_bTBSXZWZBJ ; //同步时下载完整笔记内容复选框控制标志,默为不选中
}

@property BOOL m_bTBWifiOnly ;
@property BOOL m_bTBSXZWZBJ ;

-(IBAction)OnFinish:(id)sender ;//头栏完成按钮
-(IBAction)OnChangeUser:(id)sender ;//用户切换
-(IBAction)OnPassWordSet:(id)sender ;//软件启动密码
-(IBAction)OnTBSSCGX:(id)sender ; //同步时上传更新内容
-(IBAction)OnTBSXZWZBJ:(id)sender ; //同步时下载完整笔记内容
-(IBAction)OnTXZL:(id)sender ; //图像质量
-(IBAction)OnZTDX:(id)sender ; //字体大小
-(IBAction)OnBJBCGS:(id)sender ; //笔记保存格式
-(IBAction)OnFolderManage:(id)sender ; //文件夹管理
-(IBAction)OnFolderPassWordSet:(id)sender ; //文件夹密码设置
-(IBAction)OnYHFK:(id)sender ; //用户反馈
-(IBAction)OnCheckUpdate:(id)sender ; //检查更新
-(IBAction)OnAbout:(id)sender ; //关于本软件
-(IBAction)OnVersionHistory:(id)sender ; //版本履历
-(IBAction)OnHelp:(id)sender ;//帮助
-(IBAction)OnMore91Soft:(id)sender ; //更多91软件
-(IBAction)OnPingFen:(id)sender ; //评分

-(void)getConfigFromSystem;
-(void) DrawView ;

-(void) dealloc ;

@end











