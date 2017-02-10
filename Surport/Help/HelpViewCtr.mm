/*
 *  HelpViewCtr.mm
 *  NoteBook
 *
 *  Created by Huang Yan on 9/10/09.
 *  Copyright 2009 fj. All rights reserved.
 *
 */

#include "HelpViewCtr.h"
#import "logging.h"
#import "Constant.h"

@implementation HelpViewCtr

- (id)init
{
    self = [super init];
	if (self )
	{
		self.title = _(@"Help");
	}
	
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)loadView
{
	[super loadView];
	UIImage *img = [UIImage imageNamed:@"Resource/PPImage/ar-meter-background.png"];
	UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
	imgView.frame = CGRectMake(self.view.center.x, self.view.center.y, 32, 32);
	imgView.userInteractionEnabled = YES;
	
	CALayer *reflectionLayer = [CALayer layer];
    reflectionLayer.contents = [imgView layer].contents; // share the contents image with the screen layer
    reflectionLayer.opacity = 0.4;
    reflectionLayer.frame = CGRectOffset([imgView layer].frame, 0.5, 416.0f + 0.5); // NSHeight(displayBounds)
    reflectionLayer.transform = CATransform3DMakeScale(1.0, -1.0, 1.0); // flip the y-axis
    reflectionLayer.sublayerTransform = reflectionLayer.transform;
    [[imgView layer] addSublayer:reflectionLayer];
	
	[self.view addSubview:imgView];
	[imgView release];
}

@end
