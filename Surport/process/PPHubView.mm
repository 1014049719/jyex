//
//  UIHubProgressView.m
//  Verify
//
//  Created by Qiliang Shen on 09-2-23.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "Constant.h"
#import "PPHubView.h"
#import "Common.h"
#define  sytleSmall  0
#define  sytleLarge  1


@implementation PPHubView
@synthesize actview,bBlack,lbText;
- (id)initWithLargeIndicator:(CGRect)frame text:(NSString *)text showCancel:(BOOL)bShowCancel
{
    if (self = [super initWithFrame:frame]) 
    {
        // Initialization code
		bBlack = YES;
		actview = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[self addSubview:actview];
		[actview startAnimating];
		textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.textAlignment = NSTextAlignmentCenter;
		textLabel.textColor = [UIColor whiteColor];
		textLabel.highlighted = YES;
		textLabel.text = text;
		textLabel.font = [UIFont systemFontOfSize:14];
		[self addSubview:textLabel];
		self.backgroundColor = [UIColor clearColor];
		styles = sytleLarge;
		
		self->bShowCancel = bShowCancel;
		if (bShowCancel) {
			btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnCancel setBackgroundImage:[UIImage imageNamed:@"Resource/PPImage/cancel.png"] forState:UIControlStateNormal];
			[btnCancel setBackgroundImage:[UIImage imageNamed:@"Resource/PPImage/cancel.png"] forState:UIControlEventTouchUpInside];
			[btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:btnCancel];
			[btnCancel retain];
		}
    }
    return self;
}
-(id)initWithSmalllIndicator:(CGRect)frame showCancel:(BOOL)bShowCancel
{
	CGRect  rect = frame;
	if(CGRectEqualToRect(frame, CGRectZero))
	{
		rect = CGRectMake(160-66, 480-44-12-36-100-2, 138, 36);
	}
	if (self = [super initWithFrame:rect])
	{
		lbText = nil;
		bBlack = YES;
		styles = sytleSmall;
		
		self->bShowCancel = bShowCancel;
		if (bShowCancel) {
			btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnCancel setBackgroundImage:[UIImage imageNamed:@"Resource/PPImage/cancel.png"] forState:UIControlStateNormal];
			[btnCancel setBackgroundImage:[UIImage imageNamed:@"Resource/PPImage/cancel.png"] forState:UIControlEventTouchUpInside];
			[btnCancel addTarget:self action:@selector(willPlay) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:btnCancel];
			[btnCancel retain];
		}
	}
    return  self;
}
- (id)initWithSmalllIndicator:(CGRect)frame text:(NSString *)text showCancel:(BOOL)bShowCancel
{
	self = [self initWithSmalllIndicator:frame showCancel:bShowCancel];
	self.lbText = [text retain];
	return self;
}

- (void)drawRect:(CGRect)rect 
{
    if(bBlack)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetLineWidth(context, 1);
		CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
		CGContextSetFillColorWithColor(context, RGBACOLOR(27.5,27.8,28.6,0.8).CGColor);
		
		CGRect rrect = self.bounds;
		
		CGFloat radius ;
	
		radius = 8.0;
		CGFloat width = CGRectGetWidth(rrect);
		CGFloat height = CGRectGetHeight(rrect);
		
		// Make sure corner radius isn't larger than half the shorter side
		if (radius > width/2.0)
			radius = width/2.0;
		if (radius > height/2.0)
			radius = height/2.0;    
		
		CGFloat minx = CGRectGetMinX(rrect);
		CGFloat midx = CGRectGetMidX(rrect);
		CGFloat maxx = CGRectGetMaxX(rrect);
		CGFloat miny = CGRectGetMinY(rrect);
		CGFloat midy = CGRectGetMidY(rrect);
		CGFloat maxy = CGRectGetMaxY(rrect);
		CGContextMoveToPoint(context, minx, midy);
		CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
		CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
		CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
		CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
		CGContextClosePath(context);
		
		CGContextDrawPath(context, kCGPathFill);	
	}
}

- (void)setText:(NSString*)t
{
	textLabel.text = t;
}


- (void)layoutSubviews
{
	[super layoutSubviews];
	if(styles == sytleLarge)
	{	
		float  ACTVIEW_SIZE  = 30;
		actview.frame = CGRectMake((self.bounds.origin.x+self.bounds.size.width)/2-ACTVIEW_SIZE/2,
								   (self.bounds.origin.y+self.bounds.size.height)/2-ACTVIEW_SIZE/2,
								   ACTVIEW_SIZE,ACTVIEW_SIZE);
		textLabel.frame = CGRectMake(self.bounds.origin.x,self.bounds.size.height-25,self.frame.size.width,20);
		
		if (bShowCancel) {
			btnCancel.frame = CGRectMake(self.bounds.size.width - 25, self.bounds.size.height-27, 20, 20);
			textLabel.frame = CGRectMake(self.bounds.origin.x,self.bounds.size.height-25,self.frame.size.width-20,18);
		}
	}
    else
	{
		if (bShowCancel) {
			btnCancel.frame = CGRectMake(self.bounds.size.width - 25, self.bounds.size.height-27, 20, 20);
		}
		actview = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		CGRect rect = CGRectMake(14,7,actview.frame.size.width,actview.frame.size.height);
		actview.frame = rect;
		[self addSubview:actview];
		[actview startAnimating];
		textLabel = [[UILabel alloc] initWithFrame:CGRectMake(26,7, self.frame.size.width-actview.frame.size.width, actview.frame.size.height)];
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.textAlignment = NSTextAlignmentCenter;
		textLabel.textColor = [UIColor whiteColor];
		textLabel.highlighted = YES;
		textLabel.font = [UIFont boldSystemFontOfSize:16];
		if(lbText == nil)
			textLabel.text = _(@"Loading...");
		else
			textLabel.text = lbText;
		[self addSubview:textLabel];
		self.backgroundColor = [UIColor clearColor];
		

	}
}

- (void)dealloc {
	[lbText  release];
	[actview release];
	[textLabel release];
	
	if (btnCancel) {
		[btnCancel release];
	}
	
    [super dealloc];
}

-(void) cancel {
	[CommonFunc stopSync];
}


@end
