//
//  mtextView.h
//  PPDialog
//  输入框界面显示
//  Created by wu chen on 09-4-1.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CALayer.h>
#define  DEFAULT_MAX_ROW  180


typedef enum PPTextViewStyle {
	PPTextViewStyleInput,
	PPTextViewStyleSMS
} PPTextViewStyle;

@protocol  PPTextViewDeletgate;
@interface PPTextView : UIView <UITextViewDelegate,UIActionSheetDelegate>{

	int						 maxInput;
	UITextView				* _tv;
	UIImageView				*_boundView;
	CGRect					_boundRect;
	float					_LeftMargin;
	float					_TopMargin;
	float					_ButtomMargin;
	float					_RightMargin;
	UIFont					*_font;
	UIButton				*shadowView;
	id<PPTextViewDeletgate>  delegate;
	PPTextViewStyle			_style;
	NSString				*content;
	BOOL					_isSelf;
	BOOL					_isPost;
	NSString		* _placeHolder;
	UIView			* titleView;
	UIToolbar		* toolBar; 
	UIBarButtonItem * myPostItem;
	UIBarButtonItem * clearItem;
	UIBarButtonItem * centerItem;
	float			inputFlag; // for placeHolder
	UILabel			* lb;	   // for plaveHolder
// for sms	
	BOOL			  isUp;
	UIButton		* sendBn;
	UIButton		* hideBn;
//	NSString		* replaceWord;
}
@property(nonatomic,retain) NSString * placeHolder;
@property(nonatomic)		int		 maxInput;
@property(nonatomic,assign) id<PPTextViewDeletgate>  delegate;
@property(nonatomic,retain) UIBarButtonItem * centerItem;
@property(nonatomic,retain) UITextView		* _tv;
@property(nonatomic,retain) UIButton*shadowView;
@property(nonatomic)		float	_LeftMargin;
@property(nonatomic)		float	_TopMargin;
@property(nonatomic)		float	_ButtomMargin;
@property(nonatomic)		float	_RightMargin;
@property(nonatomic)		PPTextViewStyle	_style;
@property(nonatomic,retain)	NSString *content;
@property(nonatomic,retain) UIFont	 *_font;
@property(nonatomic)		BOOL     _isSelf;
@property(nonatomic,retain) UIView			* titleView;
@property(nonatomic,retain)	UIBarButtonItem * myPostItem;
@property(nonatomic,retain)	UIBarButtonItem * clearItem;
@property(nonatomic,retain) UIToolbar		* toolBar; 
@property(nonatomic,retain) UIImageView		*_boundView;
- (void)postEnd;
- (void)editEnd;
- (void) setText:(NSString *)text;
- (void) show;
- (NSString *) getText;
- (void)layoutSubviews;
- (void) hideKeyBoard;
- (void)setPostItem:(UIBarButtonItem*)bbi;
- (void)setTilteView:(UIView *)view;
- (void)setContentTitle:(NSString *)title;
- (BOOL)isScrollUp;
-(void)filterToActiveSend;
- (void)scrollForInput:(BOOL) upOrDown;// for SMS style
@end

@protocol PPTextViewDeletgate<NSObject>
@optional
- (void)PPTextViewDidBeginEditing:(PPTextView *)mtextView;
- (BOOL)PPTextViewShouldBeginEditing:(PPTextView *)mtextView;
- (BOOL)PPTextViewShouldEndEditing:(PPTextView *)mtextView;

- (void)PPTextViewDidEndEditing:(PPTextView *)mtextView;
- (void)PPTextViewDidPost:(PPTextView*)mtextView item:(UIBarButtonItem *)postItem;
// for sms
- (void)PPTextViewSMSSend:(PPTextView*)mtextView text:(NSString *)text;
@end
