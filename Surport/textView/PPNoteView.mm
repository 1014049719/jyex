//
//  PPNoteView.m
//  NoteBook
//
//  Created by huang yan on 09-7-20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPNoteView.h"
#import <QuartzCore/QuartzCore.h>
#import "HtmlTextCollector.h"
#import "Constant.h"
#import "Logger.h"

#define NOTE_HEIGHT		20
#define KEYBOARD_HEIGHT 131


@interface UITextView (extended)
//- (void)setContentToHTMLString:(NSString *) contentText;
//- (id)contentAsHTMLString;
@end

@implementation PPNoteView 

@synthesize mtextView = _mtextView,toolBar = _toolBar,delegate;
@synthesize mtext,mLastEditTime,_font, title = _title, tagStr = _tagStr;
@synthesize textColor = _textColor,backgroundColor = _backgroundColor,isToolBarHidden = _isToolBarHidden;
@synthesize starlevel;

- (void)initParam
{
	_mtextView			= nil;
	_toolBar			= nil;
	mtext				= nil;
	mLastEditTime		= nil;
	_title				= nil;
	_tagStr				= nil;
	_textColor			= nil;
	_backgroundColor	= nil;
	_isToolBarHidden	= YES;
	mTipLabel			= nil;
	self._font			= [UIFont  systemFontOfSize:16.0f];
	self.delegate		= nil;
}

- (id)initWithFrame:(CGRect)frame withBackImage:(UIImage *)img
{
	if(self = [super initWithFrame:frame])
	{		
		self.backgroundColor = [UIColor whiteColor];
		[self initParam];
		[self loadViewWithFrame:frame withBackImage:img];
        
        btnStar[0] = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [btnStar[0] addTarget:self action:@selector(btnstar0) forControlEvents:UIControlEventTouchDown];
        btnStar[0].frame = CGRectMake(20, 5, 20, 20);
        [self addSubview:btnStar[0]];
        btnStar[1] = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [btnStar[1] addTarget:self action:@selector(btnstar1) forControlEvents:UIControlEventTouchDown];
        btnStar[1].frame = CGRectMake(45, 5, 20, 20);
        [self addSubview:btnStar[1]];
        btnStar[2] = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [btnStar[2] addTarget:self action:@selector(btnstar2) forControlEvents:UIControlEventTouchDown];
        btnStar[2].frame = CGRectMake(70, 5, 20, 20);
        [self addSubview:btnStar[2]];
        btnStar[3] = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [btnStar[3] addTarget:self action:@selector(btnstar3) forControlEvents:UIControlEventTouchDown];
        btnStar[3].frame = CGRectMake(95, 5, 20, 20);
        [self addSubview:btnStar[3]];
        btnStar[4] = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [btnStar[4] addTarget:self action:@selector(btnstar4) forControlEvents:UIControlEventTouchDown];
        btnStar[4].frame = CGRectMake(120, 5, 20, 20);
        [self addSubview:btnStar[4]];
        btnStar[5] = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [btnStar[5] addTarget:self action:@selector(btnstar5) forControlEvents:UIControlEventTouchDown];
        btnStar[5].frame = CGRectMake(145, 5, 20, 20);
        [self addSubview:btnStar[5]];
        [btnStar[0] setImage:[UIImage imageNamed:@"Resource/PPImage/starnull.png"] forState:UIControlStateNormal];
        [btnStar[1] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
        [btnStar[2] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
        [btnStar[3] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
        [btnStar[4] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
        [btnStar[5] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
        starlevel = 0;
	}
    
	return self;
}

- (void)dealloc
{
	if(_mtextView != nil)
	{
		[_mtextView release];
		_mtextView = nil;
	}
	if(mTipLabel != nil)
	{
		[mTipLabel release];
		mTipLabel = nil;
	}
	if(mLastEditTime != nil)
	{
		[mLastEditTime release];
		mLastEditTime = nil;
	}
	[_font release];
    
    [btnStar[0] release];
    [btnStar[1] release];
    [btnStar[2] release];
    [btnStar[3] release];
    [btnStar[4] release];
    [btnStar[5] release];
    
	[super dealloc];
}

#pragma mark view

- (void)loadViewWithFrame:(CGRect)frame withBackImage:(UIImage *)img
{
	
	[self showTextView];
	[self showToolBar];
	[self showLabelView];
	//MLOG(@"%d", _mtextView.text.length);
	
}

- (void)showTips
{
	if(mTipLabel == nil)
	{
		float width = self.bounds.size.width*2/3;
		float height = 20;
		float x = self.center.x - width/2;
		float y = self.bounds.origin.y + NOTE_HEIGHT;
		
		//mTipLabel = [[UILabel alloc] initWithFrame:TIPS_LABEL_RECT];
		mTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
		//MLOG(@"\nlabel\nx[%f]\ny[%f]\nwidth[%f]\nheight[%f]\n",x,y,width,height);
		mTipLabel.font = [UIFont systemFontOfSize:14];
		mTipLabel.text = _(@"click here to write");
		mTipLabel.textColor = [UIColor darkGrayColor];
		mTipLabel.backgroundColor = [UIColor clearColor];
		mTipLabel.textAlignment = NSTextAlignmentCenter;
		mTipLabel.alpha = 0.3;
		[_mtextView addSubview: mTipLabel];
	}
	
}

- (void)destroyTips
{
	if(mTipLabel != nil)
	{
		[mTipLabel removeFromSuperview];
		[mTipLabel release];
		mTipLabel = nil;
	}
}

- (void)showToolBar
{
	if(_isToolBarHidden == YES)
		return;
	
	UIView *toolBar = nil;
	toolBar = [[UIView alloc] init];
	toolBar.frame = TOOL_BAR_RECT;
	toolBar.backgroundColor = [UIColor orangeColor];
	toolBar.alpha = TOOLBAR_ALPA;
	
	UIImage *normalImgD = [UIImage imageNamed:@"Resource/Skin/friend_guy.png"];
	UIImage *selectImgD = [UIImage imageNamed:@"Resource/Skin/friend_guy.png"];
	UIButton *deleteButton = [[UIButton alloc] initWithFrame:DELETE_BUTTON_RECT];
	[deleteButton addTarget:self action:@selector(textViewShouldDelete) forControlEvents:UIControlEventTouchDown];
	[deleteButton setImage:normalImgD forState:UIControlStateNormal];
	[deleteButton setBackgroundImage:selectImgD forState:UIControlStateSelected];
	[toolBar addSubview:deleteButton];
	[deleteButton release];
	deleteButton = nil;
	
	UIImage *normalImgT = [UIImage imageNamed:@"Resource/Skin/friend_guy.png"];
	UIImage *selectImgT = [UIImage imageNamed:@"Resource/Skin/friend_guy.png"];
	UIButton *tagButton = [[UIButton alloc] initWithFrame:LAST_BUTTON_RECT];
	[tagButton addTarget:self action:@selector(textViewShouldAddTag) forControlEvents:UIControlEventTouchDown];
	[tagButton setImage:normalImgT forState:UIControlStateNormal];
	[tagButton setBackgroundImage:selectImgT forState:UIControlStateSelected];
	[toolBar addSubview:tagButton];
	[tagButton release];
	tagButton = nil;
	
	//[_backgroundImage addSubview:toolBar];
	[self addSubview:toolBar];
	[toolBar release];
	toolBar = nil;
}

- (void)showLabelView
{
	float x;
	float y;
	float width;
	float height;
	
	//x = self.center.x + 10;
	width = 120;
	height = 20;
	x = self.bounds.size.width - width;
	y = self.bounds.origin.y + 2;
	
	
	//UILabel *timelabel = [[UILabel alloc] initWithFrame:TIME_LABEL_RECT];
	mLastEditTime = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    //	NSString *time = [[[NSString alloc] init] autorelease];
    //	time = [NSString stringWithFormat:@"%@", [NSDate date]];
    //	NSString* newtime = [time substringToIndex:TIME_STRING_COUNT];
    //	mLastEditTime.text = newtime;
	mLastEditTime.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
	mLastEditTime.textColor = [UIColor grayColor];
	mLastEditTime.backgroundColor = [UIColor clearColor];
	
	x = 10;
	y = 10;
	width = 50;
	height = 20;
	
	//UILabel *zonelabel = [[UILabel alloc] initWithFrame:ZONE_LABEL_RECT];
	UILabel *zonelabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
	zonelabel.text = _(@"");
	zonelabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
	zonelabel.textColor = [UIColor grayColor];
	zonelabel.backgroundColor = [UIColor clearColor];	
	
	[self addSubview:mLastEditTime];
	[self addSubview:zonelabel];
	
	//[mLastEditTime release];
	[zonelabel release];
	
	//timelabel = nil;
	zonelabel = nil;
}

- (void)showTextView
{
	if(_mtextView == nil)
	{
		float x = self.bounds.origin.x + 10;
		float y = self.bounds.origin.y + NOTE_HEIGHT;
		float width = self.bounds.size.width - 20;
		float height = self.bounds.size.height - NOTE_HEIGHT;
		//_mtextView = [[UITextView alloc] initWithFrame:TEXT_RECT_MAX];
		_mtextView = [[UITextView alloc] initWithFrame:CGRectMake(x, y, width, height)];
		//_mtextView.backgroundColor = (_backgroundColor == nil)?[UIColor clearColor]:_backgroundColor;
		_mtextView.backgroundColor = [UIColor clearColor];
		_mtextView.font = _font;
		_mtextView.delegate = self;
		_mtextView.text = mtext;
		_mtextView.textColor = (_textColor == nil)?[UIColor blackColor]:_textColor;
		_mtextView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight); 
		_mtextView.clipsToBounds = YES;
		_mtextView.showsVerticalScrollIndicator = NO;
        //_mtextView.autocorrectionType = UITextAutocorrectionTypeNo;
		//_mtextView.alpha = 0.3f;
	}
	
	[self addSubview:_mtextView];
    
}

- (void)btnstar0 {
    starlevel = 0;
    [btnStar[1] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    [btnStar[2] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    [btnStar[3] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    [btnStar[4] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    [btnStar[5] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    if(self.delegate != nil) {
		[self.delegate  PPStar];
	}
}
- (void)btnstar1{
    starlevel = 1;
    [btnStar[1] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    [btnStar[2] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    [btnStar[3] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    [btnStar[4] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    [btnStar[5] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    if(self.delegate != nil) {
		[self.delegate  PPStar];
	}
}
- (void)btnstar2{
    starlevel = 2;
    [btnStar[1] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    [btnStar[2] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    [btnStar[3] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    [btnStar[4] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    [btnStar[5] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    if(self.delegate != nil) {
		[self.delegate  PPStar];
	}
}
- (void)btnstar3{
    starlevel = 3;
    [btnStar[1] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    [btnStar[2] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    [btnStar[3] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    [btnStar[4] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    [btnStar[5] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    if(self.delegate != nil) {
		[self.delegate  PPStar];
	}
}
- (void)btnstar4{
    starlevel = 4;
    [btnStar[1] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    [btnStar[2] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    [btnStar[3] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    [btnStar[4] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    [btnStar[5] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
    if(self.delegate != nil) {
		[self.delegate  PPStar];
	}
}
- (void)btnstar5{
    starlevel = 5;
    [btnStar[1] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    [btnStar[2] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    [btnStar[3] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    [btnStar[4] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    [btnStar[5] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
    if(self.delegate != nil) {
		[self.delegate  PPStar];
	}
}

- (id)getTextView
{
	return _mtextView;
}

- (void)setText:(NSString *)str bNeedTransform:(BOOL)b
{
	self.mtext = str;

	if (YES == b) {
		CHtmlTextCollector htmlText([str UTF8String]);
		char *htmlstring = htmlText.GetTextInHtml();
		if (htmlstring)
			_mtextView.text = [NSString stringWithUTF8String:htmlstring];
		else {
			_mtextView.text = @"";
		}

	}
	else {
		_mtextView.text = mtext;
	}

	if(_mtextView.text.length == 0)
	{
		[self showTips];
	}
    else
	{
		//[_mtextView setContentToHTMLString:mtext];
	}
	//FreeTextFromHtmlString(htmlString);
}

- (void)setLastEditTime:(NSString *)str
{
	if((str.length == 0)||(str == nil))
	{
		NSString *time = [[[NSString alloc] init] autorelease];
		time = [NSString stringWithFormat:@"%@", [NSDate date]];
		NSString* newtime = [time substringToIndex:TIME_STRING_COUNT];
		mLastEditTime.text = newtime;
	}
	else
		mLastEditTime.text = str;
}

- (BOOL)isToolBarHidden
{
	return _isToolBarHidden;
}

- (NSString *)getText
{  
	NSString * tt = _mtextView.text;
	
	if((tt == nil)||(tt.length == 0))
		return nil;
	
	return tt;
}

- (NSString *)getHTMLText
{
    //DOMDocument* document = [_mtextView domDocument];
    //DOMHTMLElement* htmlElement = [document documentElement];
    //return [htmlElement outerHTML];
    //NSString* html = _mtextView.text;//[_mtextView contentAsHTMLString];
	
	//NSLog(html);
	
    //NSString* ret = [NSString stringWithFormat:@"<html contenteditable=\"true\"><HEAD><META http-equiv=Content-Type content=\"text/html; charset=utf-16\"></HEAD>%@</html>",html];
	
	//NSLog(ret);
	
    return _mtextView.text;
}

- (void)resignFirstResponder
{
    //	NSArray *rr = [self subviews];
    //	for(UIView *a in rr)
    //		MLOG([a description]);
    //	UIImageView *imageView = [rr objectAtIndex:0];
    //	
    //	NSArray *tt = [imageView subviews];
    //	for(UIView *a in tt)
    //		MLOG([a description]);
	
	if(_mtextView != nil)
	{
		[_mtextView resignFirstResponder];
	}
}

- (void)setStarLevel:(int)level {
    starlevel = level;
    for (int i = 1; i <= 5; i ++) {
        if (i <= level) {
            [btnStar[i] setImage:[UIImage imageNamed:@"Resource/PPImage/star.png"] forState:UIControlStateNormal];
        }
        else {
            [btnStar[i] setImage:[UIImage imageNamed:@"Resource/PPImage/stardisable.png"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark animations
- (void)showInView:(UIView *)aView animated:(BOOL)animated 
{
	[self setCenter:CGPointMake(aView.frame.size.width / 2, self.frame.size.height / 2)];
	
	//[self setUpCalendarWithDate:pageDate];
	
	if (animated) {
		[self setAlpha:0.0f];
		[aView addSubview:self];
		
		CGRect frame = [self frame];
		frame.origin.y = frame.origin.y - frame.size.height / 2;
		self.frame = frame;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:NO];
		[self setAlpha:1.0f];
		frame.origin.y = frame.origin.y + frame.size.height / 2;
		self.frame = frame;
		[UIView commitAnimations];
	} else {
		[aView addSubview:self];
	}
}

- (void)showAtPoint:(CGPoint)point inView:(UIView *)aView animated:(BOOL)animated 
{
	//[self setUpCalendarWithDate:pageDate];
	
	if (animated) {
		[self setAlpha:0.0f];
		[aView addSubview:self];
		
		CGRect frame = [self frame];
		frame.origin.x = point.x;
		frame.origin.y = point.y - frame.size.height / 2;
		self.frame = frame;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:NO];
		[self setAlpha:1.0f];
		frame.origin.y = frame.origin.y + frame.size.height / 2;
		self.frame = frame;
		[UIView commitAnimations];
	} else {
		CGRect frame = [self frame];
		frame.origin.x = point.x;
		frame.origin.y = point.y;
		self.frame = frame;
		[aView addSubview:self];
	}
}

#pragma mark self_defined_delegate

- (void)textViewShouldDelete
{
	UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil 
														delegate:self
											   cancelButtonTitle:@"Cancel"
										  destructiveButtonTitle:@"Delete note"
											   otherButtonTitles:nil];
	
	[action showInView:self];
	[action release];
	action = nil;
}

- (void)textViewShouldAddTag
{
	if(self.delegate != nil)
	{
		[delegate PPNoteViewAddTag:self];
		MLOG(@"add tag>>>");
	}
}

#pragma mark delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) 
	{
		case 0:
		{
			if(self.delegate != nil)
			{
				MLOG(@"begin delete>>>");
				//[_toolBar removeFromSuperview];
				[delegate PPNoteViewDeleteNote:self animated:YES];
				//UIImage *img = [UIImage imageNamed:@"Resource/Skin/friend_guy.png"];
				//[self DeleteAnimation:img];
				MLOG(@"delete>>>");
			}
			
			break;
		}
		default:
			break;
	}
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)mtextView
{
	[self destroyTips];
	float x;// = self.bounds.origin.x;
	float y;// = self.bounds.origin.y;
	float width;// = self.bounds.size.width;
	float height;// = self.bounds.size.height*2/3;
	//MLOG(@"\n[textViewShouldBeginEditing]\nself\nx[%f]\ny[%f]\nwidth[%f]\nheight[%f]\n",x,y,width,height);
	//self.frame = CGRectMake(x, y, width, height);
	x = self.bounds.origin.x + 10;
	y = self.bounds.origin.y + NOTE_HEIGHT;
	width = self.bounds.size.width - 20;
	height = self.bounds.size.height - NOTE_HEIGHT - KEYBOARD_HEIGHT -40;
    //	[UIView beginAnimations:@"upTextView" context:UIGraphicsGetCurrentContext()];
    //	[UIView setAnimationDuration:0.3];
    //	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	_mtextView.frame = CGRectMake(x, y, width, height);
    //	[UIView commitAnimations];
	//MLOG(@"\n[textViewShouldBeginEditing]\ntextView\nx[%f]\ny[%f]\nwidth[%f]\nheight[%f]\n",x,y,width,height);
    
	BOOL ret= YES;
	
	if(self.delegate != nil)
	{
		ret = [delegate  PPNoteViewShouldBeginEditing:self];
	}
	
	return  ret;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)mtextView
{
	float x;// = self.bounds.origin.x;
	float y;// = self.bounds.origin.y;
	float width;// = self.bounds.size.width;
	float height;// = self.bounds.size.height*3/2;
	//self.frame = CGRectMake(x, y, width, height);
	//MLOG(@"\n[textViewShouldEndEditing]\nself\nx[%f]\ny[%f]\nwidth[%f]\nheight[%f]\n",x,y,width,height);
	
	x = self.bounds.origin.x + 10;
	y = self.bounds.origin.y + NOTE_HEIGHT;
	width = self.bounds.size.width - 20;
	height = self.bounds.size.height - NOTE_HEIGHT;
    //	[UIView beginAnimations:@"downTextView" context:UIGraphicsGetCurrentContext()];
    //	[UIView setAnimationDuration:0.3];
    //	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	_mtextView.frame = CGRectMake(x, y, width, height);
    //	[UIView commitAnimations];
	//MLOG(@"\n[textViewShouldEndEditing]\ntextView\nx[%f]\ny[%f]\nwidth[%f]\nheight[%f]\n",x,y,width,height);
    
	if(_mtextView.text.length == 0)
	{
		[self showTips];
	}
	
	BOOL ret= YES;	
	
	if(self.delegate != nil)
	{
		ret = [delegate  PPNoteViewShouldEndEditing:self];
	}
	
	return  ret;
}

- (void)textViewDidChange:(UITextView *)textView
{
	if(self.delegate != nil)
	{
		[delegate PPNoteViewDidChange:self];
	}
	
    
	//NSRange range = NSMakeRange(0, 0);
	//[_mtextView scrollRangeToVisible:range];
    
    //	NSString * str = [_mtextView text];
    //	CGSize size = [str sizeWithFont:self._font constrainedToSize:CGSizeMake(160,500)];
    //	if(size.height>20&&size.height<=100)
    //	{
    //		//顶点坐标 - 字体高度 + 20(self的高度和_tv高度的差值)-kUpOffset(用来调整父VIEW的可适应高度)-kHOffset(起始行高度)
    //		_mtextView.frame = CGRectMake(self.bounds.origin.x + 10, self.bounds.origin.y + 40,_mtextView.frame.size.width,size.height+20+kHOffset);
    //	}
    //	else if(size.height>100)
    //	{
    //		_mtextView.frame = CGRectMake(self.bounds.origin.x + 10, self.bounds.origin.y + 40,_mtextView.frame.size.width, 100+20+kHOffset);
    //	}
    //	else if(size.height == 0){
    //		_mtextView.frame = CGRectMake(self.bounds.origin.x + 10, self.bounds.origin.y + 40, _mtextView.frame.size.width, 40+kHOffset);
    //	}
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{	
	if(self.delegate != nil)
	{
		[delegate PPNoteView:self shouldChangeTextInRange:range replacementText:text];
	}
	
	return YES;
}

- (void)drawRect:(CGRect)rect
{
	//self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"/Resource/Image/ar-brushed_background.png"]];
	UIImage *img = [UIImage imageNamed:@"/Resource/PPImage/ar-brushed_background.png"];
	[img drawInRect:rect];
}


@end
