//
//  UIPresentImage.m
//  NoteBook
//
//  Created by susn on 13-1-17.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import "UIPresentImage.h"
#import "CommonDef.h"
#import "PubFunction.h"

@implementation UIPresentImage

@synthesize m_arrItem;
@synthesize m_pos;
@synthesize strUrl;

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
    
    m_scrollView.delegate = self;
    
    // Setup image dragging/moving
    if ( _singleRecognizer ) {
        [m_scrollView removeGestureRecognizer:_singleRecognizer];
        _singleRecognizer = nil;
    }
    
    RTEGestureRecognizer *tapInterceptor = [[RTEGestureRecognizer alloc] init];
    
    tapInterceptor.touchesBeganCallback = ^(NSSet *touches, UIEvent *event) {
        // Here we just get the location of the touch
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint touchPoint = [touch locationInView:m_scrollView];
        hintpoint = touchPoint;
        
         NSLog(@"touch begin.point=%@",NSStringFromCGPoint(hintpoint));
        //}
    };
    
    tapInterceptor.touchesEndedCallback = ^(NSSet *touches, UIEvent *event) {
        // Let's get the finished touch point
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint touchPoint = [touch locationInView:m_scrollView];
        
        if ( ABS(touchPoint.x - hintpoint.x )<10 && ABS(touchPoint.y - hintpoint.y )<10 )
        {
            //m_toolView.hidden = ! m_toolView.hidden;
            self->navigationBar.hidden = !self->navigationBar.hidden;
            self->m_Toolbar.hidden = !self->m_Toolbar.hidden;
        }
        else if ( touchPoint.x - hintpoint.x  >= 40 ) { //向左翻页
            if ( m_pos > 0 ) {
                m_pos--;
                [self showTitle];
                [self dispImage];
            }
        }
        else if ( touchPoint.x - hintpoint.x  <= -40 ) { //向右翻页
            if ( m_pos + 1 < [m_arrItem count] ) {
                m_pos++;
                [self showTitle];
                [self dispImage];
            }
        }
        
        NSLog(@"touch end.point=%@",NSStringFromCGPoint(touchPoint));
        NSLog(@"scrollview: frame=%@ contentsize=%@ contentoffset=%@",
              NSStringFromCGRect(m_scrollView.frame),
              NSStringFromCGSize(m_scrollView.contentSize),
              NSStringFromCGPoint(m_scrollView.contentOffset) );
    };
    
    [m_scrollView addGestureRecognizer:tapInterceptor];
    _singleRecognizer = tapInterceptor;
    [tapInterceptor release];
    
    //CGSize s = CGSizeMake(self.view.frame.size.width + 40, self.view.frame.size.height);
    //[m_scrollView setContentSize:s];
    //[m_scrollView setContentOffset:CGPointMake(20, 0.0)];
    [self showTitle];
    [self dispImage];
    
    
    //update for jyex 2014.4.14
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        navigationBar.translucent = NO;
        navigationBar.tintColor = [UIColor colorWithRed:0x2d/255.0 green:0x9c/255.0 blue:0x2f/255.0 alpha:1.0];
    }
    else {
        navigationBar.translucent = NO;
        navigationBar.barTintColor = [UIColor colorWithRed:0x2d/255.0 green:0x9c/255.0 blue:0x2f/255.0 alpha:1.0];
        navigationBar.tintColor = [UIColor whiteColor];
        
        NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:navigationBar.titleTextAttributes];
        [textAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        navigationBar.titleTextAttributes = textAttributes;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //NSLog(@"self.view: frame=%@ scrollview frame=%@",NSStringFromCGRect(self.view.frame),
    //      NSStringFromCGRect(m_scrollView.frame));
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    NSLog(@"UIPresentImage dealloc");
    
    self.m_arrItem = nil;
    self.strUrl = nil;
    
    SAFEREMOVEANDFREE_OBJECT(m_imageView);
    SAFEREMOVEANDFREE_OBJECT(self->navigationBar);
    SAFEREMOVEANDFREE_OBJECT(self->m_Toolbar);
    SAFEFREE_OBJECT(self->m_btnLastImage);
    SAFEFREE_OBJECT(self->m_btnNextImage);
    //SAFEREMOVEANDFREE_OBJECT(self->m_btnLastImage);
    //SAFEREMOVEANDFREE_OBJECT(self->m_btnNextImage);
    SAFEREMOVEANDFREE_OBJECT(m_scrollView);
    
    [super dealloc];
    
}

- (void)threeSecondsTimeout
{
    //隐藏工具栏
     //m_toolView.hidden = YES;
    self->navigationBar.hidden = YES;
    self->m_Toolbar.hidden = YES;
}

- (void)execSyncAfterThreeSeconds
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(threeSecondsTimeout) object:nil];
    [self performSelector:@selector(threeSecondsTimeout) withObject:nil afterDelay:3.5];
}

- (IBAction) onToolCancel:(id)sender
{
    _singleRecognizer.touchesBeganCallback = nil;
    _singleRecognizer.touchesEndedCallback = nil;
    [m_scrollView removeGestureRecognizer:_singleRecognizer];
    _singleRecognizer = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(threeSecondsTimeout) object:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction) onToolLast:(id)sender
{
    if ( m_pos <= 0 ) return;
    
    m_pos--;
    [self showTitle];
    [self dispImage];
}

- (IBAction) onToolNext:(id)sender
{
    if ( m_pos+1 >= [m_arrItem count] ) return;
    m_pos++;
    [self showTitle];
    [self dispImage];
}

- (IBAction) onToolOprNote:(id)sender
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"保存",@"全部保存", @"复制", @"取消", nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionsheet.destructiveButtonIndex = 3;
    [actionsheet showInView:self.view];
    [actionsheet release];
}

- (IBAction)onJumpURL:(id)sender
{
    NSLog(@"select jump url button\r\n");
    
    [PubFunction SendMessageToViewCenter:NMWebView :0 :1 :[MsgParam param:nil :nil :strUrl :0]];
    
}

-(void)showJumpURLBtn:(BOOL)show
{
    if ( show ) {
        if ( [m_Toolbar.items count] != 7 ) {
            NSMutableArray *items = [[m_Toolbar.items mutableCopy] autorelease];	
            [items insertObject:m_btnJump atIndex:2];
            m_Toolbar.items = items;
        }
    }
    else
    {
        if ( [m_Toolbar.items count] == 7 ) {
            NSMutableArray *items = [[m_Toolbar.items mutableCopy] autorelease];	
            [items removeObject: m_btnJump];	
            m_Toolbar.items = items;
        }
    }
}

-(void)showTitle
{
    if ( strUrl ) [self showJumpURLBtn:YES];
    else [self showJumpURLBtn:NO];
    
    navigationBar.topItem.title = [NSString stringWithFormat:@"图像 %d/%d"
                                   , m_pos+1, m_arrItem.count ];
    if ( !m_pos ) {
        self->m_btnLastImage.enabled = NO;
    }
    else
    {
        self->m_btnLastImage.enabled = YES;
    }
    
    if ( m_pos >= (m_arrItem.count - 1)) {
        self->m_btnNextImage.enabled = NO;
    }
    else
    {
        self->m_btnNextImage.enabled = YES;
    }
}

- (void)dispImage
{
    NSString *strFileName = [m_arrItem objectAtIndex:m_pos];
    UIImage *image = [UIImage imageWithContentsOfFile:strFileName];
    
    NSLog(@"imageFile=%@",strFileName);
    NSLog(@"image size:%@ orient=%d scale=%.0f view:%@",NSStringFromCGSize(image.size),image.imageOrientation,image.scale,NSStringFromCGRect(m_scrollView.frame));
    
    m_imageView.image = image;
    [m_imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    /*
    CGRect frame = m_imageView.frame;
    frame.size.width = image.size.width;
    frame.size.height = image.size.height;
    m_imageView.frame = frame;
    m_imageView.image = image;
    
    CGFloat viewwidth = self.view.frame.size.width;
    CGFloat viewheight = self.view.frame.size.height;
    
    if ( image.size.width <= viewwidth && image.size.height <= viewheight ) {
        m_imageView.center = m_scrollView.center;
    }
    else {
        float widthscale = image.size.width / viewwidth;
        float heightscale = image.size.height / viewheight;
        if ( widthscale > heightscale ) {
            frame.size.width = viewwidth;
            frame.size.height = image.size.height * viewwidth / image.size.width;
        }
        else {
            frame.size.width = image.size.width * viewheight / image.size.height;
            frame.size.height = viewheight;
        }
        
        m_imageView.frame = frame;
        [m_imageView setContentMode:UIViewContentModeScaleAspectFit];
    }

    
    CGSize s = m_scrollView.contentSize;
    m_imageView.center = CGPointMake(s.width/2.0, s.height / 2.0);
    
    NSLog(@"image center:%@",NSStringFromCGPoint( m_imageView.center));
    
    
    //float minzoomx = m_scrollView.frame.size.width /image.size.width;
    //float minzoomy = m_scrollView.frame.size.height /image.size.height;
    //m_scrollView.minimumZoomScale = MIN(minzoomx, minzoomy);
    //m_scrollView.maximumZoomScale = 3.0f;
    */
    

    [self execSyncAfterThreeSeconds];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return m_imageView;
}

-(void)savePhotoToAlbumWithIndex:(NSInteger)index
{
    NSString *strFileName = [m_arrItem objectAtIndex:index];
    UIImage *image = [UIImage imageWithContentsOfFile:strFileName];
    
    //Now it will do this for each photo in the array
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

-(void)saveAllPhoto
{
    for (int i = 0; i < m_arrItem.count; ++i ) {
        [self savePhotoToAlbumWithIndex:i];
    }
}


-(void)setUrl:(NSString *)url
{
    self.strUrl = url;
}


#pragma mark -
#pragma mark ACTIONSHEET
//ACTIONSHEET的代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex  
{
    if (buttonIndex == 0) {  //保存
        [self savePhotoToAlbumWithIndex:m_pos];
        return;
    }
    else if (buttonIndex == 1) {  //全部保存
        [self saveAllPhoto];
    }
    else if(buttonIndex == 2) {   //复制
        NSString *strFileName = [m_arrItem objectAtIndex:m_pos];
        UIImage *image = [UIImage imageWithContentsOfFile:strFileName];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];        
        NSData *imgData = UIImagePNGRepresentation(image);
        [pasteboard setData:imgData forPasteboardType:[UIPasteboardTypeListImage objectAtIndex:0]];  
    }
    else
    {
        
    }
}  

#pragma mark -
#pragma mark UIScrollVIEW
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"UISCrollView Scroll.offset-x:%f",scrollView.contentOffset.x);
    xoffset = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0)
{
     
    NSLog(@"UISCrollView Scroll.offset-x:%f",scrollView.contentOffset.x);
    
    /*
    if ( xoffset < - 40 ) { //前一个
        if ( m_pos > 0 ) {
            m_pos--;
            [self showTitle];
            [self dispImage];
        }
    }
    else if ( xoffset > scrollView.contentSize.width-scrollView.frame.size.width + 40 ) { //下一个
        if ( m_pos + 1 < [m_arrItem count] ) {
            m_pos++;
            [self showTitle];
            [self dispImage];
        }
    }
    */
}


@end
