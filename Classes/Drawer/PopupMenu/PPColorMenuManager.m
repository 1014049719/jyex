//
//  PPColorMenuManager.m
//  test2
//
//  Created by chen wu on 09-10-14.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPColorMenuManager.h"
static float RGBColors[16][4] = {
{0.80, 0.91, 0.81, 1}, {0.97, 0.78, 0.62, 1}, {0.86, 0.44, 0.36, 1}, {0.736, 0.291, 0.595, 1},
{0.03, 0.07, 0.17, 1}, {0.57, 0.62, 0.84, 1}, {0.72, 0.85, 0.95, 1}, {0.98, 0.85, 0.85, 1},  
{0.87, 0.93, 0.51, 1}, {0.94, 0.87, 0.69, 1}, {0.57, 0.54, 0.44, 1}, {0.35, 0.34, 0.34, 1},
{0.86, 0.86, 0.81, 1}, {0.47, 0.69, 0.40, 1}, {0.76, 0.69, 0.90, 1}, {1, 1, 1, 1},
};
#define COLOR(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]

@implementation PPColorMenuManager
#define ColorRect CGRectMake(20, 170, 180, 20)
#define TranscurentRect CGRectMake(20,10, 180, 20)

- (id) initWithFrame:(CGRect)frame color:(UIColor *)color
{
	if(self = [super initWithFrame:frame])
	{
		colorNum = 16;
		UILabel * colorLabel = [[UILabel alloc] initWithFrame:ColorRect];
		colorLabel.backgroundColor = [UIColor clearColor];
		colorLabel.textColor = [UIColor whiteColor];
		colorLabel.font = [UIFont systemFontOfSize:16];
		colorLabel.text = @"Color:";//-------
		colorLabel.highlighted = YES;
		[self addSubview:colorLabel];
		[colorLabel release];
		
		UILabel * TransLabel = [[UILabel alloc] initWithFrame:TranscurentRect];
		TransLabel.backgroundColor = [UIColor clearColor];
		TransLabel.highlighted = YES;
		TransLabel.textColor = [UIColor whiteColor];
		TransLabel.font = [UIFont systemFontOfSize:16];
		TransLabel.text = @"Option Color:";
		[self addSubview:TransLabel];
		[TransLabel release];
		
		menu = [[PPScrollmenu alloc] initWithFrame:CGRectMake(20,195, 280, 80)];
		NSMutableArray * itemArray = [[NSMutableArray alloc] initWithCapacity:4];
		for(int i = 0; i < colorNum; i++)
		{
			[itemArray addObject:[[[PPScrollmenuItem alloc] initWithFrame:CGRectZero
																	color:COLOR(RGBColors[i][0],RGBColors[i][1],RGBColors[i][2],RGBColors[i][3])] autorelease]];
		}
		menu.items = itemArray;
		
		menu.delegate = self;
		[self addSubview:menu];
		//		[menu	release];	
		
		//		CGColorRef tmpColor = color.CGColor;
		//		const CGFloat * colors = CGColorGetComponents(tmpColor);
		//		CGFloat red = colors[0];
		//		CGFloat green = colors[1];
		//		CGFloat blue = colors[2];
		//		CGFloat alpha = CGColorGetAlpha(tmpColor);
		pcolor = color;//[UIColor colorWithRed:red green:green blue:blue alpha:alpha];
		[pcolor retain];
		/*		
		 slider = [[PPColorSlider alloc] initWithFrame:CGRectMake(30, 120, 260, 30)];
		 [slider  setColor:red green:green blue:blue alpha:alpha];
		 [self addSubview:slider];
		 */		
		customColor = [[PPCustomColor alloc] initWithFrame:CGRectMake(20, 40, 280, 119)];
		customColor.delegate = self;
		[self addSubview:customColor];
		
	}
	return self;
}

-(void)PPScrollmenu:(PPScrollmenu *)menu didSelectdItem:(PPScrollmenuItem *)menuItem atIndex:(NSInteger) index;
{
	[menuItem.contentColor retain];
	[pcolor release];
	pcolor = menuItem.contentColor;
	[customColor disSelected];
	/*	CGColorRef tmpColor = menuItem.contentColor.CGColor;
	 const CGFloat * colors = CGColorGetComponents(tmpColor);
	 CGFloat red = colors[0];
	 CGFloat green = colors[1];
	 CGFloat blue = colors[2];
	 //CGFloat alpha = CGColorGetAlpha(tmpColor);
	 */	
	
	//	[slider setColor:red green:green blue:blue alpha:[slider getAlpha]];
}

- (void)PPCustomColorDelegate:(PPCustomColor *) cus willSeletedColorAtPoint:(CGPoint) pt
{
	[menu disSelected];
}
- (void)PPCustomColorDelegate:(PPCustomColor *) cus deSelectedColor:(UIColor *)color
{
	[color retain];
	[pcolor release];
	pcolor = color;
}
- (UIColor *) getColor
{
	//	return [slider getColor];
	return pcolor;
}

- (void)dealloc
{
//	MLOG(@"<PPColorManager dealloc>");
	menu.delegate = nil;
	customColor.delegate = nil;
	[pcolor release];
	[menu	release];
	[customColor release];
	//[slider release];
	[super dealloc];
//	MLOG(@"<PPColorManager deallco end>");
}
@end
