//
//  UIMyWebView.h
//  NoteBook
//
//  Created by susn on 12-11-22.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyWebViewDelegate;

@interface UIMyWebView : UIWebView
{
    BOOL multitouch;
	BOOL finished;
	CGPoint startPoint;
	NSUInteger touchtype;
	NSUInteger pointCount;
    
    id<MyWebViewDelegate> mydelegate;
}
@property (nonatomic,assign) id<MyWebViewDelegate> mydelegate;


@end



@protocol MyWebViewDelegate<NSObject>

-(void) touchEnd:(NSSet *)touches;

@end
