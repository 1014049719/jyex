//
//  UIProgress.h
//  JYEX
//
//  Created by lzd on 14-3-13.
//  Copyright (c) 2014年 广州洋基. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIProgressDelegate.h"


@interface UIProgress : UIViewController<ASIProgressDelegate>
{
    IBOutlet UILabel *m_title;
    IBOutlet UIProgressView *m_progressview;
    
    BOOL bVisable;
    BOOL bManualClose;
}

//生成单实例
+ (UIProgress*) instance;
+ (void)dispProgress;


-(IBAction)onClose:(id)sender;


@end
