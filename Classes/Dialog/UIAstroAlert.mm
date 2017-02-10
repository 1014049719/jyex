//
//  UIAstroAlert.mm
//  Astro
//
//  Created by liuyfmac on 12-2-15.
//  Copyright 2012 洋基科技. All rights reserved.
//

#import "UIAstroAlert.h"
#import "PubFunction.h"
#import "UIImage+Scale.h"

UIAstroAlert* gAlert=nil;


@implementation UIAstroAlert
@synthesize idx;

//tmo:显示的时长（秒）
//spin:是否显示滚动轮
//loc:显示位置
//mask:屏蔽交互
//navActive:有半截不屏蔽（为YES时）

+ (void) info :(NSString*)str :(float)tmo :(BOOL)spin :(int)loc :(BOOL)mask
{
	if (gAlert==nil)
	{
		gAlert = [[UIAstroAlert alloc] initWithNibName:@"UIAstroAlert" bundle:nil];
		gAlert.view.frame = WINDOW_FRAME;//CGRectMake(0, 20, 320, 460);
		
		[[[UIApplication sharedApplication] keyWindow] addSubview:gAlert.view];
	}
	
	if (mask)
	{
		gAlert.view.userInteractionEnabled = YES;
		gAlert.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4];
	}
	else
	{
		gAlert.view.userInteractionEnabled = NO;
		gAlert.view.backgroundColor = [UIColor clearColor];
	}
	
	[gAlert showInfo:str :tmo :spin :loc];
}

+ (void) info :(NSString*)str :(BOOL)spin :(BOOL)navActive
{
	[UIAstroAlert infoCancel];
	
	gAlert = [[UIAstroAlert alloc] initWithNibName:@"UIAstroAlert" bundle:nil];
	
    CGRect frame = WINDOW_FRAME;
    
	if (navActive) {
        frame.size.height -= 50;
		gAlert.view.frame = frame;//CGRectMake(0, 20, 320, 410);
	}else
		gAlert.view.frame = frame;//CGRectMake(0, 20, 320, 460);
	
	[[[UIApplication sharedApplication] keyWindow] addSubview:gAlert.view];
	
	gAlert.view.userInteractionEnabled = YES;
	gAlert.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4];
	
	[gAlert showInfo:str :0.0 :spin :LOC_MID];
}




+ (void) infoCancel
{
	if (gAlert!=nil)
	{
		[gAlert.view removeFromSuperview];
		[gAlert release];
		gAlert = nil;
	}
}


+ (int) askWait :(NSString*)str :(NSArray*)btns
{
	UIAstroAlert* alert = [[UIAstroAlert alloc] initWithNibName:@"UIAstroAlert" bundle:nil];
	alert.view.frame = WINDOW_FRAME;//CGRectMake(0, 20, 320, 460);
	alert.view.userInteractionEnabled = YES;
	[[[UIApplication sharedApplication] keyWindow] addSubview:alert.view];
	[alert showAskWait:str :btns];	
	CFRunLoopRun();
	int rtn = alert.idx;
	[alert.view removeFromSuperview];
	[alert release];
	return rtn;
}



+ (UIAstroAlert*) ask :(NSString*)str :(float)tmo :(BOOL)spin :(NSArray*)btns :(id)obsv :(SEL)callback
{
	return nil;
}

- (void) showInfo :(NSString*)str :(float)tmo :(BOOL)spin :(int)loc
{
	float lbX = 50;
	float lbW = 220;
	if (spin) //显示滚轮
	{
		lbX = 95;
		lbW = 175;
	}
	
	CGRect f = lbInfo.frame;
	f.origin.x = lbX;
	f.size.width = lbW;
	CGSize size = f.size;
    
	size.height = 440;
	size = [str sizeWithFont:lbInfo.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
	f.size.height = size.height;
	CGRect ff = ivBk.frame;
    
    
	float h =  f.size.height+20; //显示字体的高度
	if (h < 60) h = 60;
	
    //ff.size.height = h;
    
	
	if (loc==LOC_MID)
	{
		//ff.origin.y = (WINDOW_HEIGHT-h)/2;
	}
	else if (loc==LOC_UP)
	{
		float y = 80 - h/2;
		if (y<0.0) y = 0.0;
		ff.origin.y = y;
	}
	else if (loc==LOC_DOWN)
	{
        float y = 80 - h/2;
		if (y<0.0) y = 0.0;
        ff.origin.y = WINDOW_HEIGHT - ff.size.height - y;
	}
	ivBk.frame = ff;
	
    
    if ( loc != LOC_MID) {
        f.origin.y = ff.origin.y+(ff.size.height-f.size.height)/2;
        //lbInfo.textAlignment = NSTextAlignmentCenter;
        lbInfo.frame = f;
    }
	lbInfo.text = str;
	
	if (spin && !_spin)
	{
		UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		aiv.tag = 1000;
		f = aiv.frame;
		f.origin.y = ff.origin.y+10;
		f.origin.x = 50;
		aiv.frame = f;
		[self.view addSubview:aiv];
		[aiv startAnimating];
		[aiv release];
	}
	else if (!spin && _spin)
	{
		UIView* aiv = [self.view viewWithTag:1000];
		if (aiv!=nil)
			[aiv removeFromSuperview];
	}
	
	_spin = spin;
	
	if (tmo>0.001) 
		[NSTimer scheduledTimerWithTimeInterval:tmo target:self selector:@selector(onTimer:) userInfo:nil repeats:NO]; 
}

- (void) onTimer: (NSTimer*)timer
{
	[UIAstroAlert infoCancel];
}

- (void) showAskWait :(NSString*)str :(NSArray*)btns
{
	CGRect f = lbInfo.frame;
	CGSize size = f.size;
	size.height = 440;
	size = [str sizeWithFont:lbInfo.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
	f.size.height = size.height;
	
	float btnHeight = 0;
	if (btns.count==2) btnHeight = 40;
	else if (btns.count==4) btnHeight = 80;
	else btnHeight = btns.count*40;
	
	CGRect ff = ivBk.frame;
	float h =  f.size.height+25+btnHeight;
	ff.size.height = h;
	ff.origin.y = (WINDOW_HEIGHT-h)/2;
	ivBk.frame = ff;
	
	
	f.origin.y = ff.origin.y + 10;
	lbInfo.frame = f;
	lbInfo.text = str;
	
	
	float y = f.origin.y + f.size.height + 5;
	if (btns.count==2)
	{
		f = CGRectMake(50, y, 105, 35);
		[self addBtn :(NSString*)[btns objectAtIndex:0] :f :0];
		f = CGRectMake(163, y, 105, 35);
		[self addBtn :(NSString*)[btns objectAtIndex:1] :f :1];
	}
	else if (btns.count==4)
	{
		f = CGRectMake(50, y, 105, 35);
		[self addBtn :(NSString*)[btns objectAtIndex:0] :f :0];
		f = CGRectMake(163, y, 105, 35);
		[self addBtn :(NSString*)[btns objectAtIndex:1] :f :1];
		f = CGRectMake(50, y+40, 105, 35);
		[self addBtn :(NSString*)[btns objectAtIndex:2] :f :2];
		f = CGRectMake(163, y+40, 105, 35);
		[self addBtn :(NSString*)[btns objectAtIndex:3] :f :3];
	}
	else
	{
		int i=0;
		f = btnModel.frame; 
		f.origin.y = y;
		for (NSString* tt in btns)
		{
			[self addBtn :tt :f :i];
			i++;
			f.origin.y += 40;
		}
	}
}

- (void) addBtn :(NSString*)title :(CGRect)f :(int)tag
{
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = f;
	btn.tag = tag;
	btn.titleLabel.font = btnModel.titleLabel.font;
	[btn setCustomButtonDefaultImage];
	[btn setTitleColor:[btnModel titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
	[btn setTitleColor:[btnModel titleColorForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
	[btn setTitle:title forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];
}

- (void) onButtonClick :(id)sender
{
	idx = ((UIButton*)sender).tag;
	CFRunLoopStop(CFRunLoopGetCurrent());
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _spin = NO;
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //ivBk.image = [[UIImage imageNamed:@"popup.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30];
	[btnModel setCustomButtonDefaultImage];
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
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
