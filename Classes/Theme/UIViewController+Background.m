#import "UIViewController+Background.h"

#define KBackgroundViewTag 1024768
#define KOverViewTag 1024769
#define KSplitViewTag 1024770
#define KMainViewTag 1024771
#define KTopViewTag 1024772

@implementation UIViewController (Background)

- (void)setBackgroundImage:(UIImage *)image imageOver:(UIImage *)imageOver imageSplit:(UIImage *)imageSplit imageMain:(UIImage*)imageMain imageTop:(UIImage*)imageTop{
    self.view.backgroundColor = [UIColor clearColor];
    
    // 设置分割图片
    UIImageView *splitView = (UIImageView *)[self.view viewWithTag:KSplitViewTag];
    if (splitView == nil)
    {
        splitView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 55, self.view.bounds.size.width, 3)] autorelease];
        splitView.tag = KSplitViewTag;
        [self.view addSubview:splitView];
        [self.view sendSubviewToBack:splitView];
    }
    [splitView setImage:imageSplit];
    
    // 设置遮罩图片
    UIImageView *overView = (UIImageView *)[self.view viewWithTag:KOverViewTag];
    if (overView == nil)
    {
        overView = [[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
        overView.tag = KOverViewTag;
        [self.view addSubview:overView];
        [self.view sendSubviewToBack:overView];
    }
    [overView setImage:imageOver];
    
	// 设置顶部的分隔图片
    UIImageView *topView = (UIImageView *)[self.view viewWithTag:KTopViewTag];
    if (topView == nil && imageTop != nil)
    {
        topView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 36, self.view.bounds.size.width, 8)] autorelease];
        topView.tag = KTopViewTag;
        [self.view addSubview:topView];
        [self.view sendSubviewToBack:topView];
    }
    [topView setImage:imageTop];
	
	// 设置背景图片
    UIImageView *mainView = (UIImageView *)[self.view viewWithTag:KMainViewTag];
    if (mainView == nil)
    {
        mainView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 43, self.view.bounds.size.width, self.view.bounds.size.height-43)] autorelease];
        mainView.tag = KMainViewTag;
        [self.view addSubview:mainView];
        [self.view sendSubviewToBack:mainView];
    }
    [mainView setImage:imageMain];
	
	// 设置背景图片
    UIImageView *bgView = (UIImageView *)[self.view viewWithTag:KBackgroundViewTag];
    if (bgView == nil)
    {
        bgView = [[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
        bgView.tag = KBackgroundViewTag;
        [self.view addSubview:bgView];
        [self.view sendSubviewToBack:bgView];
    }
    [bgView setImage:image];
	
	
}

@end
