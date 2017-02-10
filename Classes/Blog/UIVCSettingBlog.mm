//
//  UIVCSettingBlog
//  Weather
//
//  Created by nd on 11-11-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIVCSettingBlog.h"
#import "AstroAppDelegate.h"
#import "PubFunction.h"
#import "BlogIntf.h"
#import "MTStatusBarOverlay.h"
#import "UIAstroAlert.h"

@implementation UIVCSettingBlog
@synthesize image;
@synthesize text;

//@synthesize txtBlog;
//@synthesize lbWordLimit;
//@synthesize imageView, imageClear, image, text;
//@synthesize btnClear;

- (void)  showSendResult:(NSString*)msg
{
    [UIAstroAlert info:msg :3.0 :NO :LOC_MID :NO];
    [self retain];
    [self performSelector:@selector(release) withObject:nil afterDelay:0.1];
}

- (void) sendBlogInBackground: (NSDictionary *) args 
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSString* msg = @"";
    if ([[BlogIntf instance] SendBlog :[args objectForKey:@"text"] :[args objectForKey:@"image"] : &msg])	
    {
        if ([PubFunction stringIsNullOrEmpty:msg])
            msg = @"分享成功";
    } 
    else 
    {
        if ([PubFunction stringIsNullOrEmpty:msg])
            msg = LOC_STR("bg_fxsb");
    }
    
    // ViewController 的释放必须放到主线程中完成
    [self performSelectorOnMainThread:@selector(showSendResult:) withObject:msg waitUntilDone:NO];
    [pool release];
}


- (void)textViewDidChange:(UITextView *)textView 
{
    for (UIView* v in textView.subviews)
    {
        // 处于输入法模式下，不进行截断处理，直接返回
        if ([NSStringFromClass([v class]) isEqualToString:@"UIAutocorrectInlinePrompt"])
            return;
    }

    NSInteger text_max_length = kMaxBlogLength - [BlogIntf productInfo].length;    
    if (textView.text.length > text_max_length) 
    {
        textView.text = [textView.text substringToIndex:text_max_length];
    }
    
    lbWordLimit.text = [NSString stringWithFormat: @"%d  ", text_max_length - txtBlog.text.length];
}

//当用户触摸的时候，隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{    
    [txtBlog resignFirstResponder];	 
	[super touchesBegan:touches withEvent:event];
}

/*
- (void)didBlogBind:(BOOL) binded 
{
    if (!binded) 
    {
        [PubFunction SendMessageToViewCenter:NMBack :0 :0 :nil];
    }
}
*/

- (IBAction)returnBtnPress:(id)sender 
{ 
    isBack = YES;
	[PubFunction SendMessageToViewCenter:NMBack :0 :(backNoAnim ? 0 : 1) :nil];
    if (isShowNavWhenBack)
    {
       [PubFunction SendMessageToViewCenter:NMNavFuncShow :0 :0 :nil]; 
    }
}

- (IBAction)btnSendClick: (id)sender 
{
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
                          txtBlog.text, @"text",
                          self.image, @"image",
                          nil];
    
    [self performSelectorInBackground:@selector(sendBlogInBackground:) withObject:args];
    
	[self returnBtnPress:nil];
}

- (IBAction)btnClearText:(id)sender 
{
    NSInteger text_max_length = kMaxBlogLength - [BlogIntf productInfo].length;
    txtBlog.text = @"";
    lbWordLimit.text = [NSString stringWithFormat: @"%d  ", text_max_length - txtBlog.text.length];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
 */

- (void)blogSetCallback:(NSString*)result
{
    if (![[BlogIntf instance] IsBinded])
    {
        backNoAnim = YES;
        [self returnBtnPress:nil];
    }
}
 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if (IS_FT)
    {
        [btnSend setTitle:LOC_STR("bg_fs") forState:UIControlStateNormal];
    }
	
	// 设置输入框圆角及黄色边框
    txtBlog.layer.cornerRadius = 5.0f;
    txtBlog.layer.masksToBounds = YES;
    txtBlog.layer.borderWidth = 1.0f;
    txtBlog.layer.borderColor = [[UIColor colorWithRed:(float)(230.0f/255.0f) green:(float)(157.0f/255.0f) blue:(float)(33.0f/255.0f) alpha:1.0f] CGColor];
    
    // 字符个数背景圆角
    lbWordLimit.layer.cornerRadius = 5.0f;
    lbWordLimit.layer.masksToBounds = YES;
	
    txtBlog.placeholder = LOC_STR("bg_sdsm");
    txtBlog.text = self.text;
    imageView.image = self.image;
    NSInteger text_max_length = kMaxBlogLength - [BlogIntf productInfo].length;
    lbWordLimit.text = [NSString stringWithFormat: @"%d  ", text_max_length - txtBlog.text.length];

	//NSLog(@"setting blog %d", [[self.navigationController viewControllers] count]);
    
    if (![[BlogIntf instance] IsBinded]) 
    {
        [PubFunction SendMessageToViewCenter:NMSettingBlogSet :0 :0 :[MsgParam param:self :@selector(blogSetCallback:) :nil :0]];
    }
    
    AstroAppDelegate *dg = (AstroAppDelegate *)[UIApplication sharedApplication].delegate;
    if (![dg isNavHidden])
    {
        [PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
        isShowNavWhenBack = YES;
    }

}
 
- (void)viewWillAppear:(BOOL)animated 
{
    // listen for keyboard hide/show notifications so we can properly adjust the table's height
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];    
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    [txtBlog becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification 
{
    // the keyboard is showing so resize the table's height
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect frame = CGRectMake(0, 0, self.view.superview.frame.size.width, self.view.superview.frame.size.height - keyboardRect.size.height);
    if (frame.size.width > 0 && frame.size.height > 0)
        self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification 
{
    // the keyboard is hiding reset the table's height
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect frame = CGRectMake(0, 0, self.view.superview.frame.size.width, self.view.superview.frame.size.height);
    if (frame.size.width > 0 && frame.size.height > 0)
        self.view.frame = frame;
    [UIView commitAnimations];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    /*
    self.txtBlog = nil;
    self.lbWordLimit = nil;
    self.imageView = nil;
    self.imageClear = nil;
    self.btnClear = nil;
    self.btnBackground = nil;
    */
}

- (void)dealloc 
{
    self.image = nil;
    self.text = nil;
    
    /*
    self.txtBlog = nil;
    self.lbWordLimit = nil;
    self.imageView = nil;
    self.imageClear = nil;
    self.btnClear = nil;
    self.btnBackground = nil;
     */
    
    [super dealloc];
}




@end
