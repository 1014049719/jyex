//
//  MJPhotoBrowser.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "SDWebImageManager+MJ.h"
#import "MJPhotoView.h"
#import "MJPhotoToolbar.h"

#import "YcKeyBoardView.h"

#define kWinSize [UIScreen mainScreen].bounds.size

#define kPadding 10
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface MJPhotoBrowser () <MJPhotoViewDelegate,YcKeyBoardViewDelegate>
{
    // 滚动的view
	UIScrollView *_photoScrollView;
    // 所有的图片view
	NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
    // 工具条
    MJPhotoToolbar *_toolbar;
    
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
}

/////
@property (nonatomic,strong)YcKeyBoardView *key;
@property (nonatomic,assign) CGFloat keyBoardHeight;
@property (nonatomic,assign) CGRect originalKey;
@property (nonatomic,assign) CGRect originalText;

@end

@implementation MJPhotoBrowser
@synthesize imageOpDelegate;


#pragma mark - Lifecycle
- (void)loadView
{
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)updateTitle:(NSString*)title
{
    lbTitle.text = @"";
    if( title == nil || [title isEqualToString:@""]) return ;
    lbTitle.text = title ;
}

- (void)createNavView
{
    float dy = 0.0f ;
    
    navView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 )
    {
        navView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 64) ;
        dy = 20.0f;
    }
    else
    {
        navView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44+dy) ;
        dy = 0.0f;
    }
    
    navView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self->navView];
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, dy, self.view.bounds.size.width, 44)];
    //lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44+dx)];
    lbTitle.backgroundColor = [UIColor clearColor] ;
    lbTitle.textColor = [UIColor whiteColor];
    lbTitle.font = [UIFont boldSystemFontOfSize:17];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.text = @"相片查看" ;
    [navView addSubview:lbTitle];
    
    float btnWidth = 44;
    UIButton *btGoback = nil;
    btGoback = [UIButton buttonWithType:UIButtonTypeCustom];
    btGoback.frame = CGRectMake(10, dy, btnWidth, btnWidth);
    btGoback.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [btGoback setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
    [btGoback setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
    [btGoback addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btGoback] ;
    //[self.view addSubview:btGoback];
    //[self.view bringSubviewToFront:btGoback];
    
    UIButton *btGoDone = nil;
    btGoDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btGoDone.frame = CGRectMake( self.view.bounds.size.width - btnWidth - 10, dy, btnWidth, btnWidth);
    btGoDone.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [btGoDone setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
    [btGoDone setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
    [btGoDone addTarget:self action:@selector(godone:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btGoDone] ;
    //[self.view addSubview:btGoDone];
    //[self.view bringSubviewToFront:btGoDone];
    
    //[self.view addSubview:self->navView];
    
    //[self.view bringSubviewToFront:navView];
}

- (void)createImageXQ
{
    float h = 53.0f;
    CGRect frame = self.view.frame;
    frame.origin.x = 5.0f;
    frame.origin.y = frame.size.height - 44.0f - h ;
    frame.size.height = h;
    frame.size.width = frame.size.width - 10.0f;
    
    self->tvImageXQ = [[UITextView alloc] initWithFrame:frame];
    tvImageXQ.backgroundColor = [UIColor clearColor];
    tvImageXQ.textColor = [UIColor whiteColor];
    tvImageXQ.font = [UIFont systemFontOfSize:12.0f];
    tvImageXQ.text = @"图片详细情况111\n图片详细情况222\n图片详细情况333";
    
    tvImageXQ.delegate = self ;
    
    [self.view addSubview:tvImageXQ] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    flag = true ;
    
    [self createNavView];
    
    
    
    // 1.创建UIScrollView
    [self createScrollView];
    
    // 2.创建工具条
    [self createToolbar];
    
    [self createImageXQ];
    
    //test
    //[self fullScreen] ;
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];

    if (_currentPhotoIndex == 0) {
        [self showPhotos];
    }
}

#pragma mark - 私有方法
#pragma mark 创建工具条
- (void)createToolbar
{
    CGFloat barHeight = 44.0f;
    //CGFloat barHeight = 55;
    CGFloat barY = self.view.frame.size.height - barHeight;
    _toolbar = [[MJPhotoToolbar alloc] init];
    _toolbar.frame = CGRectMake(0, barY, self.view.frame.size.width, barHeight);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _toolbar.photos = _photos;
    _toolbar->callobject = self;
    _toolbar->callbackSEL = @selector(updateTitle:);
    [self.view addSubview:_toolbar];
    
    [self updateTollbarState];
}

#pragma mark 创建UIScrollView
- (void)createScrollView
{
    float dy1 = 0.0f;

    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 )
    {
        dy1 = 64.0f;
    }
    else
    {
        dy1 = 44.0f;
    }
    
    CGRect frame = self.view.bounds;
    frame.origin.x -= kPadding;
    frame.origin.y = dy1 ;
    frame.size.width += (2 * kPadding);
    frame.size.height = self.view.bounds.size.height - dy1 - 44.0f;
	_photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
	_photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photoScrollView.pagingEnabled = YES;
	_photoScrollView.delegate = self;
	_photoScrollView.showsHorizontalScrollIndicator = NO;
	_photoScrollView.showsVerticalScrollIndicator = NO;
	_photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count + 200, 0);
	[self.view addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}

#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }
    
    if ([self isViewLoaded]) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        
        // 显示所有的相片
        [self showPhotos];
    }
}

#pragma mark - MJPhotoView代理
- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    [UIApplication sharedApplication].statusBarHidden = _statusBarHiddenInited;
    self.view.backgroundColor = [UIColor clearColor];
    
    // 移除工具条
    [_toolbar removeFromSuperview];
}

- (void)photoViewDidEndZoom:(MJPhotoView *)photoView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark 显示照片
- (void)showPhotos
{
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
	int firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
	int lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
	
	// 回收不再显示的ImageView
    NSInteger photoViewIndex;
	for (MJPhotoView *photoView in _visiblePhotoViews) {
        photoView.parentVC = self ;
        photoViewIndex = kPhotoViewIndex(photoView);
		if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
			[_reusablePhotoViews addObject:photoView];
			[photoView removeFromSuperview];
		}
	}
    
	[_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
	
	for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
		if (![self isShowingPhotoViewAtIndex:index]) {
			[self showPhotoViewAtIndex:index];
		}
	}
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(int)index
{
    MJPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[MJPhotoView alloc] init];
        photoView.parentVC = self ;
        photoView.photoViewDelegate = self;
    }
    
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * kPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    photoView.tag = kPhotoViewTagOffset + index;
    
    MJPhoto *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
}

#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(int)index
{
    if (index > 0) {
        MJPhoto *photo = _photos[index - 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
    
    if (index < _photos.count - 1) {
        MJPhoto *photo = _photos[index + 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
	for (MJPhotoView *photoView in _visiblePhotoViews) {
        photoView.parentVC = self; 
		if (kPhotoViewIndex(photoView) == index) {
           return YES;
        }
    }
	return  NO;
}

#pragma mark 循环利用某个view
- (MJPhotoView *)dequeueReusablePhotoView
{
    MJPhotoView *photoView = [_reusablePhotoViews anyObject];
	if (photoView) {
        photoView.parentVC = self;
		[_reusablePhotoViews removeObject:photoView];
	}
	return photoView;
}

#pragma mark 更新toolbar状态
- (void)updateTollbarState
{

    /*
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
    */
    
    
    
    //原组件的计算方法有问题
    int count = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    
    if( count >= [_toolbar.photos count])
    {
        count = [_toolbar.photos count] - 1 ;
    }
    _currentPhotoIndex = count ;
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self showPhotos];
    [self updateTollbarState];
}


- (void)goback
{
    NSLog( @"goback" ) ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (void)godone:(NSDictionary*)imageDic
{
    NSLog(@"godone");
    
    /*
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@"相片操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil] ;
    ac.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [ac showInView:self.view];
     */
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSLog( @"buttonIndex == 0" );
    }
    else if(buttonIndex == 1)
    {
        NSLog( @"buttonIndex == 1" );
    }
}


-(void)sendPL:(NSDictionary*)imageDic
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    if(self.key==nil){
        self.key=[[YcKeyBoardView alloc]initWithFrame:CGRectMake(0, kWinSize.height-44, kWinSize.width, 44)];
    }
    self.key.delegate=self;
    [self.key.textView becomeFirstResponder];
    self.key.textView.returnKeyType=UIReturnKeySend;
    [self.view addSubview:self.key];
    curImageDic = imageDic;
}


-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    self.keyBoardHeight=deltaY;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.key.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}
-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.key.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        self.key.textView.text=@"";
        [self.key removeFromSuperview];
    }];
    
}

-(void)keyBoardViewHide:(YcKeyBoardView *)keyBoardView textView:(UITextView *)contentView
{
    [contentView resignFirstResponder];
    //接口请求
    NSLog( @"输入内容为：[%@]", contentView.text ) ;
    //curImageDic保存有需要操作的图片信息
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//控制导航栏与工具栏显示的函数
- (void)controlTS
{
    flag = !flag ;
    if( flag )
    {
        [self resetScreen] ;
    }
    else
    {
        [self fullScreen];
    }
}

- (void)fullScreen
{
    _toolbar.hidden = YES ;
    navView.hidden = YES ;
    
    /*
    
    CGRect frame = [[UIScreen mainScreen] bounds] ;

    CGRect f = CGRectMake( 0, 0, frame.size.width, frame.size.height);
    _photoScrollView.frame = f ;
     
    */
}

- (void)resetScreen
{
    /*
    float dy1 = 0.0f;
    
    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 )
    {
        dy1 = 64.0f;
    }
    else
    {
        dy1 = 44.0f;
    }
    
    CGRect frame = _photoScrollView.frame;
    frame.origin.y = dy1 ;
    frame.size.height = self.view.bounds.size.height - dy1 - 52;
    _photoScrollView.frame = frame ;
    */
    
    _toolbar.hidden = NO ;
    navView.hidden = NO ;
}

//点攒
- (void)imageDZ:(NSDictionary*)imageDic
{
    NSLog( @"imageDZ" ) ;
}

//详情
- (void)imageXQ:(NSDictionary*)imageDic
{
     NSLog( @"imageXQ" ) ;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO ;
}


- (void)showImageXQ:(NSString*)imageXQStr
{
    if( imageXQStr == nil )
    {
        self->tvImageXQ.text = @"";
        return;
    }
    self->tvImageXQ.text = imageXQStr ;
}

@end