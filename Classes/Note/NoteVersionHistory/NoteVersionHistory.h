//
//  NoteVersionHistory.h
//  NoteBook
//
//  Created by mwt on 12-11-8.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteVersionHistory : UIViewController{
    IBOutlet UIButton *m_btnFinish ; //头栏完成按钮
    IBOutlet UILabel  *m_lbVersion ; //版本号显示
    IBOutlet UIScrollView *m_viVersionHistory ;
    
    IBOutlet UILabel *m_lbTitleSample;
    IBOutlet UILabel *m_lbContentSample;
}

-(IBAction)OnFinish:(id)sender ;
-(void) ShowVersionHistory:(NSString *)VersionInfo ;
-(float) addKeyValue:(NSString*)key :(NSString*)val :(float)y;

-(void) DrawView ;

-(void) dealloc ;

@end
