//
//  UINotePhotoQuality.h
//  NoteBook
//
//  Created by cyl on 12-12-19.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINotePhotoQuality : UIViewController
{
    IBOutlet UIButton *m_btnNavCancel;
    IBOutlet UIButton *m_btnNavFinish;
    
    IBOutlet UIImageView *m_ivSelect0;
    IBOutlet UIImageView *m_ivSelect1;
    IBOutlet UIImageView *m_ivSelect2;
    IBOutlet UIImageView *m_ivCurSelect;
        
    NSString *m_strPQ;
}

-(IBAction)onSelect:(id)sender;
-(IBAction)onBack:(id)sender;
-(IBAction)onOk:(id)sender;

-(void) dealloc;

@end
