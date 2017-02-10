//
//  UIFilePaiXuSelect.m
//  NoteBook
//
//  Created by zd on 13-3-4.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//
#import "PubFunction.h"
#import "UIFilePaiXuSelect.h"

@implementation UIFilePaiXuSelect

@synthesize vcParent;
@synthesize closeCallback;
@synthesize PaiXuYiJu;
@synthesize PaiXuFangShi;

+ (UIViewController*) addToWnd :(UIViewController*)vcParent :(SEL)closeCallback;
{
    
	UIFilePaiXuSelect *vc = [[UIFilePaiXuSelect alloc] initWithNibName:@"UIFilePaiXuSelect" bundle:nil];
	[vc autorelease];
	
	vc.vcParent = vcParent;
	vc.closeCallback = closeCallback;
	vc.view.frame = CGRectMake(0, 0, 320, 480);
	//[[[UIApplication sharedApplication] keyWindow] addSubview:vc.view];
	[vcParent.view addSubview:vc.view];
	return vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)OnBack:(id)sender
{
    //[PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
    //[self.view removeFromSuperview];
    //[self release];
    [vcParent performSelector:closeCallback withObject:self withObject:nil];
}

- (void)dealloc
{
    SAFEREMOVEANDFREE_OBJECT(m_imgaview11);
    SAFEREMOVEANDFREE_OBJECT(m_imgaview12);
    SAFEREMOVEANDFREE_OBJECT(m_imgaview21);
    SAFEREMOVEANDFREE_OBJECT(m_imgaview22);
    SAFEREMOVEANDFREE_OBJECT(m_imgaview31);
    SAFEREMOVEANDFREE_OBJECT(m_imgaview32);
    SAFEREMOVEANDFREE_OBJECT(m_imgaview41);
    SAFEREMOVEANDFREE_OBJECT(m_imgaview42);
    SAFEREMOVEANDFREE_OBJECT(m_imgaview51);
    SAFEREMOVEANDFREE_OBJECT(m_imgaview52);
    [super dealloc];
}

//排序依据选择
-(IBAction)OnPaiXuSelect:(id)sender
{
    int i = ((UIButton*)sender).tag ;
    switch (i)
    {
       case 1://按标题排序
            m_imgaview11.hidden = NO ;
            m_imgaview12.hidden = NO ;
            m_imgaview21.hidden = YES ;
            m_imgaview22.hidden = YES ;
            m_imgaview31.hidden = YES ;
            m_imgaview32.hidden = YES ;
            m_imgaview41.hidden = YES ;
            m_imgaview42.hidden = YES ;
            m_imgaview51.hidden = YES ;
            m_imgaview52.hidden = YES ;
            break;
       case 2://按创建时间排序
            m_imgaview11.hidden = YES ;
            m_imgaview12.hidden = YES ;
            m_imgaview21.hidden = NO ;
            m_imgaview22.hidden = NO ;
            m_imgaview31.hidden = YES ;
            m_imgaview32.hidden = YES ;
            m_imgaview41.hidden = YES ;
            m_imgaview42.hidden = YES ;
            m_imgaview51.hidden = YES ;
            m_imgaview52.hidden = YES ;
            break;
       case 3://按修改时间排序
            m_imgaview11.hidden = YES ;
            m_imgaview12.hidden = YES ;
            m_imgaview21.hidden = YES ;
            m_imgaview22.hidden = YES ;
            m_imgaview31.hidden = NO ;
            m_imgaview32.hidden = NO ;
            m_imgaview41.hidden = YES ;
            m_imgaview42.hidden = YES ;
            m_imgaview51.hidden = YES ;
            m_imgaview52.hidden = YES ;
            break;
       case 4://按大小排序
            m_imgaview11.hidden = YES ;
            m_imgaview12.hidden = YES ;
            m_imgaview21.hidden = YES ;
            m_imgaview22.hidden = YES ;
            m_imgaview31.hidden = YES ;
            m_imgaview32.hidden = YES ;
            m_imgaview41.hidden = NO ;
            m_imgaview42.hidden = NO ;
            m_imgaview51.hidden = YES ;
            m_imgaview52.hidden = YES ;
            break;
       case 5://按星级排序
            m_imgaview11.hidden = YES ;
            m_imgaview12.hidden = YES ;
            m_imgaview21.hidden = YES ;
            m_imgaview22.hidden = YES ;
            m_imgaview31.hidden = YES ;
            m_imgaview32.hidden = YES ;
            m_imgaview41.hidden = YES ;
            m_imgaview42.hidden = YES ;
            m_imgaview51.hidden = NO ;
            m_imgaview52.hidden = NO ;
            break;
    }
    self.PaiXuYiJu = i ;
}


-(IBAction)OnPaiXuFangShi:(id)sender
{
    int i = ((UIButton*)sender).tag ;
    switch (i)
    {
        case 1://降序
            self.PaiXuFangShi = 1 ;
            break;
            
        case 2://升序
            self.PaiXuFangShi = 2 ;
            break;
    }
}

@end
