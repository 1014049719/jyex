    //
//  NDFavorTip.m
//  SparkEnglish
//
//  Created by nd on 11-5-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NDFavorTip.h"


static NDFavorTip * fNDFavorTip = nil;

@implementation NDFavorTip


+ (NDFavorTip *) getInstance;
{
	if (fNDFavorTip == nil)
		fNDFavorTip = [[NDFavorTip alloc] init];
	return fNDFavorTip;
	
}

- (void)dealloc {
	if (fNDFavorTip)
		[fNDFavorTip release];
    [super dealloc];
}


- (void) HideTip: (NSTimer *)timer
{
	[lbTip setHidden: YES];
	[lbTip release];
} 


- (void) SetTip: (UILabel*)lb : (NSString*)tip : (float)delay
{
	lbTip = lb;
	[lbTip retain];
    [NSTimer scheduledTimerWithTimeInterval:delay target:self selector: @selector(HideTip:)
                                   userInfo:nil repeats:NO];

	lbTip.text = tip;
	lbTip.textAlignment = NSTextAlignmentCenter;
	[lbTip setHidden: NO];
}

@end
