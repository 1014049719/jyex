//
//  UISelectFont.h
//  NoteBook
//
//  Created by cyl on 12-12-13.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Plist.h"

@interface UISelectFont : UIViewController
{
    IBOutlet UIButton *m_btnNavCancel;
    IBOutlet UIButton *m_btnNavFinish;
    
    IBOutlet UIScrollView *m_scrollFont;
    IBOutlet UIView *m_viewFontList;
    
    IBOutlet UIImageView *m_ivSelect0;
    IBOutlet UIImageView *m_ivSelect1;
    IBOutlet UIImageView *m_ivSelect2;
    IBOutlet UIImageView *m_ivSelect3;
    IBOutlet UIImageView *m_ivSelect4;
    IBOutlet UIImageView *m_ivSelect5;
    IBOutlet UIImageView *m_ivSelect6;
    IBOutlet UIImageView *m_ivSelect7;
    IBOutlet UIImageView *m_ivSelect8;
    IBOutlet UIImageView *m_ivSelect9;
    IBOutlet UIImageView *m_ivSelect10;
    IBOutlet UIImageView *m_ivSelect11;
    IBOutlet UIImageView *m_ivSelect12;
    IBOutlet UIImageView *m_ivSelect13;
    IBOutlet UIImageView *m_ivSelect14;
    IBOutlet UIImageView *m_ivSelect15;
    IBOutlet UIImageView *m_ivSelect16;
    IBOutlet UIImageView *m_ivSelect17;
    IBOutlet UIImageView *m_ivSelect18;
    IBOutlet UIImageView *m_ivSelect19;
    IBOutlet UIImageView *m_ivSelect20;
    UIImageView *m_ivArray[ 21 ];
    
    IBOutlet UIImageView *m_ivCurSelect;
    //PlistController		* pc;
    int m_iFontIndex;
}

-(IBAction)onSelectFont:(id)sender;
-(IBAction)onBack:(id)sender;
-(IBAction)onOk:(id)sender;

-(void)dealloc;

@end
