//
//  PPProcessView.h
//  CallShow
//
//  Created by chen wu on 09-7-1.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PPProcessView : UIView {
	NSTimer *timer;
	UIProgressView *progbar;
	float   amountDone ;
	UILabel*message;
	float speed;
	BOOL  complented;
}
//@property(nonatomic,retain) UILabel *message;
@property(nonatomic,retain) UIProgressView *progbar;
- (id)initWithFrame:(CGRect) frame message:(NSString *)msg; 
- (void)runIncrement;
- (void)setMessages:(NSString *)msg;
- (void)complement:(BOOL)flag;
@end
