#import "StatusBarWindow.h"


@implementation StatusBarWindow

@synthesize iconImage, textLabel, clickCount;

static const CGRect windowFrame0 = {{0, 20}, {320, 0}};
static const CGRect windowFrame1 = {{0, 0}, {320, 20}};
//static const CGRect imageFrame0 = {{6, 1}, {16, 16}};
//static const CGRect imageFrame1 = {{2, 1}, {16, 16}};
static const CGRect textFrame = {{30, 0}, {260, 20}};

+ (StatusBarWindow *)newStatusBarWindow {
	StatusBarWindow *statusBar = [[StatusBarWindow alloc] initWithFrame:windowFrame0];
	if (statusBar) {
		statusBar.windowLevel = UIWindowLevelStatusBar + 1;
		
		//UIImageView *background = [[UIImageView alloc] initWithFrame:windowFrame1];
		//background.image = [UIImage imageNamed:@"background.png"];
		//[statusBar addSubview:background];
		//[background release];
		
		//UIImageView *icon = [[UIImageView alloc] initWithFrame:imageFrame0];
		//icon.image = [UIImage imageNamed:@"clock.png"];
		//statusBar.iconImage = icon;
		//[statusBar addSubview:icon];
		//[icon release];
        
        statusBar.backgroundColor = [UIColor blackColor];
		
		UILabel *text = [[UILabel alloc] initWithFrame:textFrame];
		text.backgroundColor = [UIColor clearColor];
		text.textAlignment = NSTextAlignmentCenter;
        text.text = @"同步完成";
        text.font = [UIFont boldSystemFontOfSize:14];
        text.textColor = [UIColor whiteColor];
		statusBar.textLabel = text;
		[statusBar addSubview:text];
		[text release];
	}
	
	return statusBar;
}

-(void)dispStatusBar
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    self.hidden = NO;
    self.frame = windowFrame1;
    self.textLabel.text = @"同步完成";
    [UIView commitAnimations];
}

-(void)dispStatusBar:(NSString *)strText
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    self.hidden = NO;
    self.frame = windowFrame1;
    self.textLabel.text = strText;
    [UIView commitAnimations];
    
    [self performSelector:@selector(hideStatusBar) withObject:self afterDelay:3.0];
    
}


-(void)dispStatusBar:(NSString *)strText timeout:(NSInteger)timeout
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    self.hidden = NO;
    self.frame = windowFrame1;
    self.textLabel.text = strText;
    [UIView commitAnimations];
    
    [self performSelector:@selector(hideStatusBar) withObject:self afterDelay:timeout];
    
}


-(void)hideStatusBar
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    self.frame = windowFrame0;
    [UIView commitAnimations];
    self.hidden = YES;
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
	textLabel.text = [NSString stringWithFormat:@"已点击%d次状态栏", ++clickCount];
	if (clickCount % 2) {
		self.frame = windowFrame1;
		//iconImage.frame = imageFrame1;
	} else {
		self.frame = windowFrame0;
		//iconImage.frame = imageFrame0;
	}
	[UIView commitAnimations];
}
*/

@end

