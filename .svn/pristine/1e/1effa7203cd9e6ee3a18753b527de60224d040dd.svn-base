//
//  UIVCSettingBlog.h
//  Weather
//
//  Created by nd on 11-11-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIVCSettingBlogSet.h"
#import "SSTextView.h"
//#import "MBProgressHUD.h"
//#import "BaseViewController.h"

@interface UIVCSettingBlog : UIViewController<UITextViewDelegate> 
{
	IBOutlet SSTextView *txtBlog;
    IBOutlet UILabel *lbWordLimit, *lbCap;
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton  *btnSend;
    
    UIImage *image;
    NSString *text;
    
    BOOL isBack;
    BOOL isShowNavWhenBack;
    BOOL backNoAnim;
}
@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) NSString *text;


- (IBAction)returnBtnPress:(id)sender;
- (IBAction)btnSendClick: (id)sender;
- (IBAction)btnClearText:(id)sender;


           
@end
