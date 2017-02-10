//
//  PPProcessView.m
//  CallShow
//
//  Created by chen wu on 09-7-1.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPProcessView.h"
#import "Constant.h"
#import "Logger.h"

@implementation PPProcessView
@synthesize progbar;

- (id)initWithFrame:(CGRect) frame message:(NSString *)msg 
{
    
	if(CGRectEqualToRect(frame,CGRectZero))
		self = [super initWithFrame:CGRectMake(0, 480-216, 320, 216)];//480-64-216
	else
		self = [super initWithFrame:frame];
	
	[self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
	progbar = [[UIProgressView alloc] initWithFrame:CGRectMake(50.0f, 480-216-108-45, 220.0f, 40.0f)];
	[progbar setProgress:( amountDone=0.0f)];
	[progbar setProgressViewStyle: UIProgressViewStyleDefault];
	[self addSubview:progbar];
	
	message = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,108+10 , 320.0f, 45)];
	message.textAlignment = NSTextAlignmentCenter;
	message.backgroundColor = [UIColor clearColor];
	message.alpha =1;
	message.textColor = [UIColor whiteColor];
	message.highlighted = YES;
	message.text = msg;
	[self addSubview:message];
	speed = 0.5f;
	complented = NO;
	return self;
}

- (void)runIncrement
{
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	timer = [NSTimer scheduledTimerWithTimeInterval: 0.05 target: self selector: @selector(incrementBar:) userInfo: nil repeats: YES];
}
- (void)setMessages:(NSString *)msg
{
	message.text = msg;
}
- (void)resetIncrement
{
	amountDone = 0.0f;
}
- (void)removeFromSuperview
{
	[self  resetIncrement];
	[super removeFromSuperview];
}
- (void)complement:(BOOL)flag
{
	if(flag == YES)
	{
		speed = 2.0f;
		complented = YES;
		[self setMessages:_(@"Message sent success")];
	}
	else{
		if(amountDone<=20){
			complented = NO;
			[timer invalidate];
			message.text = _(@"SMS send Failed");
			speed = 0;
            
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
            
			[self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.8];
		}
	}
}
- (void)incrementBar:(id)sender
{
	@synchronized(self){
        amountDone += speed;
        printf("%f\n",amountDone);
        [progbar setProgress: (amountDone / 20.0)];
		//  如果没有完成绝对不让其消失
        if(!complented&&amountDone>12)
            amountDone = 12;
        if (amountDone > 20.0&&complented) //多加一个complented判断避免线程不同步,超量设置
        {
			
            [timer invalidate];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
            [self removeFromSuperview];
            
        }
	}
}
-(void)dealloc
{
	MLOG(@"@@@@@@@@@@@@@@dealloc PPProcessView@@@@@@@@@@@@@@");
	[message release];
	[progbar release];
	[super   dealloc];
}
@end
