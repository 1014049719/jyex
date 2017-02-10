//
//  PPNoteView.h
//  NoteBook
//
//  Created by huang yan on 09-7-20.
//  Copyright 2009 NetDragon. All rights reserved.
//

#define TIME_STRING_COUNT	16
#define TEXTVIEW_FONT_SIZE	18
#define TOOLBAR_ALPA		0.3
#define kHOffset 25
#define kUpOffset 0//64

#define TEXT_RECT_MAX		CGRectMake(10.0f, 40.0f, 300.0f, 300.0f)
#define TEXT_RECT_MIN		CGRectMake(10.0f, 40.0f, 300.0f, 100.0f)
#define TIME_LABEL_RECT     CGRectMake(210.0f, 10.0f, 120.0f, 20.0f)
#define ZONE_LABEL_RECT		CGRectMake(10.0f, 10.0f, 50.0f, 20.0f)
#define TIPS_LABEL_RECT		CGRectMake(70.0f, 0.0f, 180.0, 32.0f)
#define TOOL_BAR_RECT		CGRectMake(0.0f, 200.0f, 320.0f, 44.0f)
#define DELETE_BUTTON_RECT  CGRectMake(150.0f, 10.0f, 32.0f, 32.0f)
#define LAST_BUTTON_RECT    CGRectMake(100.0f, 10.0f, 32.0f, 32.0f)
#define NEXT_BUTTON_RECT    CGRectMake(200.0f, 10.0f, 32.0f, 32.0f)


//#import <UIKit/UIKit.h>
//#import <QuartzCore/QuartzCore.h>

@protocol PPNoteViewDelegate;

/**
 * PPNoteView is a singleton which holds some styles used by note views.
 * 
 * When you 'd like to create a note like apple supperted. You can use this.
 * How to create a note? you can just modify the properties of PPNoteView.
 *
 */

@interface PPNoteView : UIView <UITextViewDelegate, UIActionSheetDelegate> 
{
	UITextView				*_mtextView;
	UIImageView				*_toolBar;
	UIColor					*_textColor;
	
	UIFont					*_font;
	NSString				*mtext;
	NSString				*_title;
	NSString				*_tagStr;
	UIColor					*_backgroundColor;
	UILabel					*mTipLabel;
	UILabel					*mLastEditTime;
	
	BOOL					_isToolBarHidden;
	
	id<PPNoteViewDelegate>	delegate;
    
    UIButton *btnStar[6];
    int starlevel;
}

@property(nonatomic, retain) UITextView				*mtextView;
@property(nonatomic, retain) UIImageView			*toolBar;
@property(nonatomic, retain) UIColor				*textColor;
@property(nonatomic, retain) UIFont					*_font;
/**
 * NSString used for the note as a text content in a UILabel.
 */
@property(nonatomic, retain) NSString				*mtext;
@property(nonatomic, retain) UILabel				*mLastEditTime;
/**
 * NSString used for the note as a title in a UILabel.
 */
@property(nonatomic, retain) NSString				*title;
/**
 * NSString used for the note as a tag in a UILabel.
 */
@property(nonatomic, retain) NSString				*tagStr;
@property(nonatomic, retain) UIColor				*backgroundColor;
@property(nonatomic)		 BOOL					isToolBarHidden;
@property(nonatomic,assign)  id<PPNoteViewDelegate> delegate;

@property(nonatomic, assign) int starlevel;

- (id)initWithFrame:(CGRect)frame withBackImage:(UIImage *)img;
- (void)loadViewWithFrame:(CGRect)frame withBackImage:(UIImage *)img;

- (void)showTextView;
- (void)showTips;
- (void)showToolBar;
- (void)showLabelView;

#pragma mark animations
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)showAtPoint:(CGPoint)point inView:(UIView *)aView animated:(BOOL)animated;

#pragma mark inParam
- (void)setLastEditTime:(NSString *)str;
- (void)setText:(NSString *)str bNeedTransform:(BOOL)b;

- (BOOL)isToolBarHidden;
- (NSString *)getText;
- (NSString *)getHTMLText;
- (void)resignFirstResponder;


- (void)btnstar0;
- (void)btnstar1;
- (void)btnstar2;
- (void)btnstar3;
- (void)btnstar4;
- (void)btnstar5;

- (void)setStarLevel:(int)level;

/**
 * Animation used for the note when delete a note.
 */
//- (void)DeleteAnimation:(UIImage *)image;

@end

@protocol PPNoteViewDelegate

- (void)PPNoteViewDeleteNote:(PPNoteView *)noteView animated:(BOOL)animation;
- (void)PPNoteViewAddTag:(PPNoteView *)noteView;
- (void)PPStar;

- (BOOL)PPNoteViewShouldBeginEditing:(PPNoteView *)noteView;
- (BOOL)PPNoteViewShouldEndEditing:(PPNoteView *)noteView;
- (void)PPNoteViewDidChange:(PPNoteView *)noteView;
- (BOOL)PPNoteView:(PPNoteView *)noteView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end

