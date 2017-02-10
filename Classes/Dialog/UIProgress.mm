//
//  UIProgress.m
//  JYEX
//
//  Created by lzd on 14-3-13.
//  Copyright (c) 2014年 广州洋基. All rights reserved.
//

#import "UIProgress.h"
#import "PubFunction.h"

@interface UIProgress ()

@end


static UIProgress *_instance = nil;


@implementation UIProgress


//生成单实例
+ (UIProgress*) instance
{
    
    if (!_instance) {
        @synchronized(self) {
            if(_instance == nil) {
                _instance = [[UIProgress alloc] initWithNibName:@"UIProgress" bundle:nil];
                
                _instance.view.frame = WINDOW_FRAME;
                

            }
            
        }
    }
    return _instance;
}


+ (void)dispProgress
{
    [[UIProgress instance] dispProgress];
}



-(void) dealloc
{
    SAFEREMOVEANDFREE_OBJECT(m_title);
    SAFEREMOVEANDFREE_OBJECT(m_progressview);
    
    [super dealloc];
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)visible
{
    if ( !bVisable ) {
        bVisable = TRUE;
        m_title.text = @"";
        [m_progressview setProgress:0.0];
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    }
}


- (void)invisible
{
    if ( bVisable) {
        bVisable = FALSE;
        [self.view removeFromSuperview];
    }
}



-(IBAction)onClose:(id)sender
{
    bManualClose = YES;
    bVisable = FALSE;
    [self.view removeFromSuperview];
}


-(void)dispProgress
{
    bManualClose = NO;
}



//ASIProgress delegate
- (void)setProgress:(float)newProgress
{
    NSLog(@"newProgress=%.2f",newProgress);
    [m_progressview setProgress:newProgress];
    
    if ( newProgress < 1.0 ) {
        m_title.text = @"正在上传";
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    else {
        m_title.text = @"服务端处理中";
        [self performSelector:@selector(invisible) withObject:nil afterDelay:2.0];
    }
    
    if ( !bManualClose) {
        [self visible];
    }
}



// Called when a request needs to change the length of the content to download
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
    NSLog(@"allReceiveBytes=%lld bytes",newLength);
}

// Called when a request needs to change the length of the content to upload
// newLength may be less than zero when a request needs to remove the size of the internal buffer from progress tracking
- (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength
{
    NSLog(@"allSendBytes=%lld bytes",newLength);
}


@end
