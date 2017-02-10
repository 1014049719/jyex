//
//  UIHubProgressView.h
//  Verify
//
//  Created by Qiliang Shen on 09-2-23.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPHubView : UIView 
{
	UILabel *textLabel;
	UIActivityIndicatorView *actview;
	int     styles;
	bool    bBlack;
	NSString *lbText;
	
	UIButton *btnCancel;
	BOOL	bShowCancel;
}
- (id)initWithLargeIndicator:(CGRect)frame text:(NSString *)text showCancel:(BOOL)bShowCancel;
-(id)initWithSmalllIndicator:(CGRect)frame text:(NSString *)text showCancel:(BOOL)bShowCancel;
-(id)initWithSmalllIndicator:(CGRect)frame showCancel:(BOOL)bShowCancel;
- (void)setText:(NSString*)t;

@property(nonatomic,retain) UIActivityIndicatorView *actview;
@property(nonatomic,assign)bool    bBlack;
@property(nonatomic,retain)NSString *lbText;
@end
