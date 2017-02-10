//
//  UINoteLabel.h
//  NoteBook
//
//  Created by zd on 13-2-19.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINoteLabel : UIViewController
{
    IBOutlet UIButton *m_btnBack ;
    IBOutlet UILabel  *m_lbNoteLabel ;
}

-(IBAction)OnBack:(id)sender;

-(void)dealloc;

@end
