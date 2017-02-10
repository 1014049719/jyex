//
//  mtextView.m
//  PPDialog
//
//  Created by wu chen on 09-4-1.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPTextView.h"
#import "Constant.h"
#import "Logger.h"

#define kHOffset 25
#define kUpOffset 0//64
@implementation PPTextView

@synthesize  _LeftMargin,_ButtomMargin,_TopMargin,_RightMargin,_font,delegate,_style,content;
@synthesize _isSelf,shadowView,_tv,myPostItem,titleView,toolBar,clearItem;
@synthesize centerItem,maxInput,_boundView,placeHolder = _placeHolder;

- (void)dealloc {
	[myPostItem release];
	[clearItem  release];
	[titleView  release];
	[shadowView release];
	[content    release];
	[_font		release];
	[toolBar	release];
	[_tv		release];
	[_boundView release];
	[centerItem release];
	MLOG(@"PPtextView dealloc");
    [super		dealloc];
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
		content = nil;				
		_LeftMargin = 10;
		_TopMargin = 10;
		_ButtomMargin = 270;
		_RightMargin = 0;
		self._font = [UIFont  systemFontOfSize:16.0f];
		_style = PPTextViewStyleInput;
		_tv = nil;
		_boundView = nil;
		shadowView = nil;
		_isSelf = NO;
		_isPost = NO;
		self.delegate = nil;
		self.myPostItem = nil;
		toolBar = nil;
		self.titleView = nil;
		self.maxInput = DEFAULT_MAX_ROW;
        //
	}
    return self;
}

- (void)show{
	if(_style == PPTextViewStyleInput)
	{
		self.shadowView = [[[UIButton  alloc] initWithFrame:CGRectZero] autorelease];
		shadowView.backgroundColor = [UIColor clearColor];
		//[UIColor  colorWithWhite:0.0 alpha:0.8];
		
		
		self._tv = [[[UITextView  alloc] initWithFrame:CGRectZero] autorelease];
		_tv.font = self._font;
		_tv.text = content;
		
		_tv.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight); 
		_tv.delegate = self;
		[_tv  setBackgroundColor:[UIColor  clearColor]];
		
		_tv.showsVerticalScrollIndicator = NO;
		//	tool bar.....
		
		UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
		clearItem = [[UIBarButtonItem alloc] initWithTitle:_(@"Clear") style:UIBarButtonItemStyleBordered target:self action:@selector(clearText)];
		UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		myPostItem = [[UIBarButtonItem alloc] initWithTitle:_(@"Post") style:UIBarButtonItemStyleDone target:self action:@selector(PostAction)];
		toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480, 320, 44)];
		toolBar.barStyle = UIBarStyleBlackTranslucent;
		self.titleView = [[UIView  alloc] initWithFrame:CGRectZero];
		centerItem= [[UIBarButtonItem alloc] initWithCustomView:self.titleView];
		NSArray  * items = [NSArray arrayWithObjects:cancelItem,clearItem,space1,centerItem,space2,self.myPostItem,nil];
		toolBar.items = items;
		[self  addSubview:toolBar];
		
		[cancelItem release];
		[space1		release];
		[space2		release];
		
		_boundView = [[UIImageView  alloc] initWithFrame:CGRectZero];	
		[_boundView  setBackgroundColor:[UIColor  clearColor]];
		//self.backgroundColor = [UIColor  clearColor];
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
		if(_isSelf)
			[_boundView  setFrame:CGRectMake(320, 0, 0, 0)];
		[self  addSubview:shadowView];
		[self  addSubview:_boundView];
		[self  addSubview:_tv];
	}
	else if(_style == PPTextViewStyleSMS)
	{
        UIToolbar *bar = [[UIToolbar alloc]initWithFrame:self.bounds];//CGRectMake(0, 0, 320, 40)];
		self.toolBar = bar;
        [bar release];
		
		UIImage	*backTool = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg" ofType:@"png" inDirectory:@""]];
		UIImage	*imgTool = [backTool stretchableImageWithLeftCapWidth:1 topCapHeight:3];
		toolBar.layer.contents = (id)imgTool.CGImage;
		
		UIImage *backImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input" ofType:@"png" inDirectory:@""]];
		UIImage *strectImage = [backImage stretchableImageWithLeftCapWidth:70 topCapHeight:17];
		_boundView = [[UIImageView alloc]initWithImage:strectImage];
		_boundView.frame = CGRectMake(3, 4, 255, 35);
		_boundView.userInteractionEnabled = YES;
		
		_tv = [[UITextView alloc]initWithFrame:CGRectZero];//CGRectMake(13, 2, 235, 25)];
		_tv.font = self._font;
		_tv.backgroundColor = [UIColor clearColor];
		_tv.delegate = self;
		_tv.showsVerticalScrollIndicator = NO;
		_tv.clipsToBounds = YES;
		
		[_boundView addSubview:_tv];
		
		[toolBar addSubview:_boundView];
		
		sendBn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		sendBn.frame = CGRectMake(256,7, 55, 27);
		sendBn.titleLabel.font = [UIFont systemFontOfSize:13];
		[sendBn setTitle:_(@"Send") forState:UIControlStateNormal];
		[sendBn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		
		NSString	*pathAdd = [[NSBundle mainBundle] pathForResource:@"addButton" ofType:@"png" inDirectory:@""];
		UIImage		*imgAdd = [UIImage imageWithContentsOfFile:pathAdd];
		[sendBn setBackgroundImage:imgAdd forState:UIControlStateNormal];
		[sendBn addTarget:self action:@selector(sendAction) forControlEvents:254];
		[toolBar addSubview:sendBn];
		
		hideBn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		hideBn.frame = CGRectMake(256-65,7, 55, 27);
		hideBn.titleLabel.font = [UIFont systemFontOfSize:13];
		[hideBn setTitle:_(@"Hide") forState:UIControlStateNormal];
		[hideBn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		NSString	*pathHide = [[NSBundle mainBundle] pathForResource:@"addButton" ofType:@"png" inDirectory:@""];
		UIImage		*imgHide = [UIImage imageWithContentsOfFile:pathHide];
		[hideBn setBackgroundImage:imgHide forState:UIControlStateNormal];
		[hideBn addTarget:self action:@selector(hideKeyBoard) forControlEvents:254];
		hideBn.hidden = true;
		hideBn.tag = 134591;
		[toolBar addSubview:hideBn];
		
		[sendBn release];
		[hideBn release];
        
		[self addSubview:toolBar];
		[self setBackgroundColor:[UIColor clearColor]];
	}
    
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	if(_style == PPTextViewStyleInput)
	{
		UIImage *backImg;
		
		if(!_isSelf)
		{
			_LeftMargin = -4;
			_TopMargin = 10;
			_ButtomMargin = 270;
			_RightMargin = 10;			
			backImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wallBubble_left" 
																					   ofType:@"png" 
																				  inDirectory:@""]];
		}else{
			_LeftMargin = 10;
			_TopMargin = 10;
			_ButtomMargin = 270;
			_RightMargin = -4;	
			backImg = [UIImage imageWithContentsOfFile:[[NSBundle  mainBundle] pathForResource:@"wallBubble_right" 
																						ofType:@"png" 
																				   inDirectory:@""]];
		}
		
		CGSize size = backImg.size;
		[_boundView  setImage:[backImg  stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height/2]];
		//layout
		
		shadowView.frame = CGRectMake(0, 0, 320, 156);
		
		//  mtextView    adjustment
		
		float  left   =  self.bounds.origin.x+_LeftMargin;
		float  top	  =  self.bounds.origin.y+_TopMargin;
		float  length =  self.bounds.size.width-_LeftMargin-_RightMargin;
		float  height =  self.bounds.size.height-_TopMargin-_ButtomMargin;
		_boundRect	  = CGRectMake(left,top,length,height);
		
		
		[UIView beginAnimations:@"134591" context:UIGraphicsGetCurrentContext()];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		
		[_boundView  setFrame:_boundRect];
		_tv.frame	 = CGRectMake(15, 20, 320-15*2, 165);
		
		[UIView commitAnimations];
		[NSTimer  scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(showkeybroad:) userInfo:nil repeats:NO];
	}else if(_style == PPTextViewStyleSMS)
	{
		CGRect rect = self.bounds;
		
		_boundView.frame = CGRectMake(_boundView.frame.origin.x
									  , 4
									  , _boundView.frame.size.width,
									  self.frame.size.height-5);
        
		if(!isUp)//down
		{
			_tv.frame = CGRectMake(_boundView.frame.origin.x+8,
                                   4,
                                   _boundView.frame.size.width-16,
                                   25);//20
			if([[_tv text] length]>0){
                
				[_tv  scrollRangeToVisible:NSMakeRange(0,0)];
                
			}
            
		}else{
			_tv.frame = CGRectMake(_boundView.frame.origin.x+8,
								   4,
								   _boundView.frame.size.width-16,
								   self.frame.size.height-15);
            
            //	MLOG(@"lay out  when up");
		}
		
		//MLOG(@"_tv.frame height**********= %f",_tv.frame.size.height);
		sendBn.frame = CGRectMake(sendBn.frame.origin.x, 
								  rect.size.height - 6-27, 
								  sendBn.frame.size.width, 
								  27);
		hideBn.frame = CGRectMake(hideBn.frame.origin.x, 
								  rect.size.height - 6-27, 
								  hideBn.frame.size.width, 
								  27);
		toolBar.frame = self.bounds;
		UIImage	*backTool = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg" ofType:@"png" inDirectory:@""]];
		UIImage	*imgTool = [backTool stretchableImageWithLeftCapWidth:1 topCapHeight:20];
		toolBar.layer.contents = (id)imgTool.CGImage;
		
		[self filterToActiveSend];
    }
}
//
-(void)filterToActiveSend
{
	NSString * str = _tv.text;
	NSString *str2 = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if([str2 length] == 0)
	{
		[sendBn  setTitleColor:RGBACOLOR(255,255,200,1) forState:UIControlStateNormal];
		[sendBn  setEnabled:NO];
	}else
	{
		[sendBn  setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
		[sendBn  setEnabled:YES];
	}
	
}
// 发送
-(void)sendAction
{
	if([delegate respondsToSelector:@selector(PPTextViewSMSSend: text:)]&&!_isPost)
	{
		_isPost = YES;
		[delegate PPTextViewSMSSend:self text:_tv.text];
	}
}

-(void)showkeybroad:(id)sender
{
	[_tv  becomeFirstResponder];
}
// 发送结束调用postend 解锁
- (void)postEnd
{
	_isPost = NO;
}
// 点击取消按钮
-(void)cancelAction
{
	if([_tv.text length] == 0) 
	{
		[self editEnd];
		return;
	}
    
	UIActionSheet * act = [[UIActionSheet alloc] initWithTitle:_(@"Do you really want to cancel ?")
													  delegate:self
											 cancelButtonTitle:_(@"Cancel") 
										destructiveButtonTitle:nil
											 otherButtonTitles:_(@"OK"),nil];
	act.tag = 1;
	[act showInView:[UIApplication sharedApplication].keyWindow];
	[act release];
}

-(void)editEnd
{	
	if(_isPost) return;
	[self  hideKeyBoard];
	[self  removeFromSuperview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	printf("you press index %d\n",buttonIndex);
	if(buttonIndex == 0&&actionSheet.tag ==1){
		[self  hideKeyBoard];
		[self  removeFromSuperview];
	}else if(buttonIndex == 0&&actionSheet.tag == 2)
	{
		[self setText:@""];
	}
}
#pragma mark 
#pragma mark  parameter  operate
#pragma mark 
// 获取文本内容
- (NSString *) getText
{
	return  _tv.text;
}
// 设置文本内容
- (void) setText:(NSString *)text
{
	_tv.text = text;
}
// 清除文本
-(void)clearText
{
	if(_isPost) return;
	if([_tv.text length] == 0) 
	{
		[self setText:@""];
		return;
	}
	
	UIActionSheet * act = [[UIActionSheet alloc] initWithTitle:_(@"Do you really want to clear text ?")
													  delegate:self
											 cancelButtonTitle:_(@"Cancel") 
										destructiveButtonTitle:nil
											 otherButtonTitles:_(@"OK"),nil];
	act.tag = 2;
	[act showInView:[UIApplication sharedApplication].keyWindow];
	[act release];
}

- (void) hideKeyBoard
{
	if(!_isPost)
        [_tv  resignFirstResponder];
}
// 点击发送
- (void)PostAction
{
	if([delegate respondsToSelector:@selector(PPTextViewDidPost:item:)]&&_isPost != YES)
	{
		_isPost = YES;
		[delegate PPTextViewDidPost:self item:myPostItem];
	}
}

/*****************************************
 设置post Item 比如小菊花 用于INPUTStyle
 ****************************************/
- (void)setPostItem:(UIBarButtonItem*)bbi{
	[bbi retain];
	NSMutableArray *arr = [NSMutableArray arrayWithArray:toolBar.items];
	
	if([arr count]){
		[arr removeLastObject];
		[arr addObject:bbi];
		toolBar.items = arr;
	}
	[myPostItem release];
	myPostItem = bbi;
}
/*****************************************
 设置中间的标题	用于INPUTStyle		
 ****************************************/
-(void)setTilteView:(UIView *)view
{
	[centerItem release];
	centerItem = [[UIBarButtonItem alloc] initWithCustomView:view];
	NSMutableArray *arr = [NSMutableArray arrayWithArray:toolBar.items];
	
	if([arr count]){
		[arr removeObjectAtIndex:3];
		[arr insertObject:centerItem atIndex:3];
		toolBar.items = arr;
	}
}
/*****************************************
 设置中间的标题	以string的方式设置,用在INPUTSTYLE	
 ****************************************/
- (void)setContentTitle:(NSString *)title
{
	UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 80, 44)];
	l.text = title;
	l.backgroundColor = [UIColor clearColor];
	l.textColor = [UIColor whiteColor];
	[self setTilteView:l];
    [l release];
}
/**
 *  表示是否键盘已经弹起,用在SMSStyle
 */
- (BOOL)isScrollUp
{
	return isUp;
}
/**
 *  键盘弹起时的坐标变换,不属于接口方法,用在SMSStyle
 */
- (void)scrollForInput:(BOOL) upOrDown
{
	MLOG(@"scroll for Input 1");
	if(isUp == upOrDown)
		return;//如果已经滚上去了就不必再重新设置大小.
	isUp = upOrDown;
	if(isUp)//up
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		self.frame = CGRectMake(0, 480-40-216-kUpOffset-kHOffset, 320,40+kHOffset);
        
		_boundView.frame = CGRectMake(3, 4, 255-65, 35);
        
		if([_tv.text length]>0)
		{
			NSRange range = NSMakeRange([_tv.text length], 0);
			[_tv scrollRangeToVisible:range];
		}
		[UIView commitAnimations];
		
		hideBn.hidden	=	NO;
		[self layoutSubviews];	
		
	}else//down
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		self.frame = CGRectMake(0, 480-40-kUpOffset, 320,40);
		_boundView.frame = CGRectMake(3,4, 255, 35);
		
		[UIView commitAnimations];
		
		hideBn.hidden	=	YES;
		
	}
}

#pragma mark 
#pragma mark  delegate
#pragma mark 

- (void)textViewDidChange:(UITextView *)mtextView {
	if([_tv.text length] == 0)
	{
		if(lb == nil)
		{
			CGSize  sz = [_placeHolder sizeWithFont:self._font constrainedToSize:CGSizeMake(280,500)];
			lb = [[UILabel alloc] initWithFrame:CGRectMake(10-2,8, sz.width, sz.height)];
			//		lb.tag = 134591;
			lb.backgroundColor = [UIColor clearColor];
			lb.text = _placeHolder;
			lb.font = self._font;
			lb.textColor = [UIColor lightGrayColor];
			[_tv addSubview:lb];
			[lb release];
		}
		inputFlag = YES;
	}
	
	if(_style == PPTextViewStyleSMS){	
		NSString * str = [_tv text];
		CGSize size = [str sizeWithFont:self._font constrainedToSize:CGSizeMake(160,500)];
        //	MLOG(@"size.height = %f",size.height);
		if(size.height>20&&size.height<=100)
		{//顶点坐标 - 字体高度 + 20(self的高度和_tv高度的差值)-kUpOffset(用来调整父VIEW的可适应高度)-kHOffset(起始行高度)
			self.frame = CGRectMake(self.frame.origin.x, 480-40-216-size.height+20-kUpOffset-kHOffset,self.frame.size.width,size.height+20+kHOffset);
            //	self.frame = CGRectMake(self.frame.origin.x, 480-216-size.height-20-kUpOffset-kHOffset,self.frame.size.width, size.height+20+kHOffset);
        }
		else if(size.height>100){
            //	self.frame = CGRectMake(self.frame.origin.x, 480-216-100-20-kUpOffset-kHOffset,self.frame.size.width, 100+20+kHOffset);
			self.frame = CGRectMake(self.frame.origin.x, 480-40-216-100+20-kUpOffset-kHOffset,self.frame.size.width, 100+20+kHOffset);
        }
		else if(size.height == 0){
			self.frame = CGRectMake(0, 480-40-216-kUpOffset-kHOffset, 320, 40+kHOffset);
        }
        //		if((size.height == 20||size.height== 40||size.height== 60||size.height== 80)&&[replaceWord isEqualToString:@"\n"])
        //			self.frame = CGRectMake(self.frame.origin.x, 480-216-size.height-40-kUpOffset-5,self.frame.size.width, size.height+40+5);//(5=kHOffset-oneLineSize)
        //		MLOG(@"self.height = %f",self.frame.size.height);
		
	}
    //	if(replaceWord!=nil)
    //	{
    //		[replaceWord release];
    //		replaceWord = nil;
    //	}
	[self filterToActiveSend];
}

- (BOOL)textView:(UITextView *)mtextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //	replaceWord = [text copy];
	
	if(inputFlag)
	{
		if(lb)
		{
			[lb removeFromSuperview];
			lb = nil;
		}
		inputFlag = NO;
	}
	
	if(_isPost) 
		return NO;
	if(range.location>self.maxInput)
	{
		return  NO;
	}
	
	if([text length]>0 && [mtextView.text length] >= self.maxInput)
	{
		return  NO;
	}
	else
	{
		return YES;
	}
    
	return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)mtextView
{
	if(_style == PPTextViewStyleInput){
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		
		toolBar.frame = CGRectMake(0, 156+44, 320, 44);
		[UIView commitAnimations];
		
	}else if(_style == PPTextViewStyleSMS)
	{
		[self scrollForInput:YES];
	}
	// place holder
	if([_tv.text length] == 0)
	{
		if(lb == nil)
		{
			CGSize  sz = [_placeHolder sizeWithFont:self._font constrainedToSize:CGSizeMake(280,500)];
			lb = [[UILabel alloc] initWithFrame:CGRectMake(10-2,8, sz.width, sz.height)];
			//		lb.tag = 134591;
			lb.backgroundColor = [UIColor clearColor];
			lb.text = _placeHolder;
			lb.font = self._font;
			lb.textColor = [UIColor lightGrayColor];
			[_tv addSubview:lb];
			[lb release];
		}
		inputFlag = YES;
	}	
	BOOL ret = YES;	
	if([delegate respondsToSelector:@selector(PPTextViewShouldBeginEditing:)])
		ret = [delegate  PPTextViewShouldBeginEditing:self];
	
	return  ret;
}

- (void)textViewDidBeginEditing:(UITextView *)mtextView
{
	if([delegate respondsToSelector:@selector(PPTextViewDidBeginEditing:)])
		[delegate  PPTextViewDidBeginEditing:self];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)mtextView
{	
	BOOL ret = YES;
	if([delegate respondsToSelector:@selector(PPTextViewShouldEndEditing:)])
		ret = [delegate  PPTextViewShouldEndEditing:self];
	if(ret == YES&&_style==PPTextViewStyleSMS)
		[self scrollForInput:NO];//down
	return  ret;
}
- (void)textViewDidEndEditing:(UITextView *)mtextView
{
	if([delegate respondsToSelector:@selector(PPTextViewDidEndEditing:)])
		[delegate PPTextViewDidEndEditing:self];
	
}

- (void)drawRect:(CGRect)rect {
	
}

@end
