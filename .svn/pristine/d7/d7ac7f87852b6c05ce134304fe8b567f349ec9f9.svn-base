//
//  UITest.h
//  NoteBook
//
//  Created by susn on 12-11-19.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIDrawerDelegate.h"



@interface UITest : UIViewController
{
    IBOutlet UIButton *m_btnNavCancel;
    IBOutlet UIButton *m_btnNavFinish;
    IBOutlet UISegmentedControl *m_segment;
    
    id<UIDrawerDelegate> delegate;
}


@property(nonatomic,retain)     id<UIDrawerDelegate> delegate;


- (IBAction) onNavCancel :(id)sender;
- (IBAction) onNavFinish:(id)sender;
- (IBAction) segmentAction:(id)sender;

@end
