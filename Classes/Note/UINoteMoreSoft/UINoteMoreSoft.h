//
//  UINoteMoreSoft.h
//  NoteBook
//
//  Created by cyl on 12-12-20.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINoteMoreSoft : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIButton *m_btnBack;
    IBOutlet UIWebView *m_webView;
    
    UIActivityIndicatorView *activityIndicator;
}

-(IBAction)OnBack:(id)sender ;
@end
