//
//  UIFilesItem.m
//  NoteBook
//
//  Created by cyl on 12-11-6.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "PubFunction.h"
#import "Global.h"
#import "UIFilesItem.h"
//#import "FlurryAnalytics.h"

@interface UIFilesItem()
-(void)initFrame;
-(void)drawItemAnimation;
-(UIView*) drawDayWithOriginX:(float)x;
-(void) drawBackGround;
-(UIView*) drawFileContentWithOriginX:(float)x;
-(void) drawFileContent;
-(UIView*)getBackGround;
@end

@implementation UIFilesItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self->m_scrollFileContent = nil;
        self->m_viewContent = nil;
        self->m_BackGroundRight = nil;
        self->m_viewFile = nil;
        self->m_labelDay = nil;
        self->m_labelWeek = nil;
        self->m_viewDay = nil;
        self->m_labelTitle = nil;
        self->m_labelSynopsis = nil;
        self->m_noteInfor = nil;
        
        m_sizeScreen = [UIScreen mainScreen].bounds.size;
        self->m_iChehuaType = 0;
        [self initFrame];
        //[self drawFileItem];
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame FilesInfo:(TNoteInfo*)noteInfor
{
    self = [super initWithFrame:frame];
    if (self) {
        self->m_scrollFileContent = nil;
        self->m_viewContent = nil;
        self->m_BackGroundRight = nil;
        self->m_viewFile = nil;
        self->m_labelDay = nil;
        self->m_labelWeek = nil;
        self->m_viewDay = nil;
        self->m_labelTitle = nil;
        self->m_labelSynopsis = nil;
        
        m_sizeScreen = [UIScreen mainScreen].bounds.size;
        self->m_iChehuaType = 0;
        [self initFrame];
        
        self->m_noteInfor = [noteInfor retain];
        
        self->m_Title = noteInfor.strNoteTitle;
        
        //2014.4.9
        if ( noteInfor.strEditLocation && [noteInfor.strEditLocation length]>0 && ![noteInfor.strEditLocation isEqualToString:@"IOS"])
            noteInfor.strContent = [NSString stringWithFormat:@"上传失败，原因：%@",noteInfor.strEditLocation];
        self->m_Synopsis = noteInfor.strContent;
        
        self->m_strFilesGUID = noteInfor.strNoteIdGuid;
        
        NSDate *date = [PubFunction \
        convertString2NSDate:noteInfor.tHead.strModTime \
        :CS_DATE_FORMAT_YYYY_MM_DD_HH_mm_ss];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps;
        // 年月日获得
        comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit)
                            fromDate:date];
        self->m_Year = [comps year];
        self->m_Month = [comps month];
        self->m_Day = [comps day];
        self->m_Week = [comps weekday];
        
        //[self drawFileItem];
        // Initialization code
    }
    return self;
}
-(void)dealloc
{
    [self freeItem];
    [super dealloc];
}

-(void)freeItem
{
    SAFEFREE_OBJECT( self->m_noteInfor );
    
    SAFEFREE_OBJECT( self->m_scrollFileContent );
    SAFEFREE_OBJECT( self->m_viewContent );
    SAFEFREE_OBJECT( self->m_BackGroundLeft );
    SAFEFREE_OBJECT( self->m_BackGroundRight );
    SAFEFREE_OBJECT( self->m_viewFile );
    SAFEFREE_OBJECT( self->m_labelDay );
    SAFEFREE_OBJECT( self->m_labelWeek );
    SAFEFREE_OBJECT( self->m_viewDay );
    SAFEFREE_OBJECT( self->m_labelTitle );
    SAFEFREE_OBJECT( self->m_labelSynopsis );
}

-(void)initFrame
{
    UIImage *ditu = [UIImage imageNamed:@"ShiKaiXiaoGuo.png"];
    assert( ditu );
    UIImage *fengge = [UIImage imageNamed:@"BJY_Fengge.png"];
    assert( fengge );
    self->m_fOffSet = ditu.size.width + 2;
    CGRect framRect
    = CGRectMake(self.frame.origin.x, self.frame.origin.y
                 , fengge.size.width, ditu.size.height);
    self.frame = framRect;
    [self setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:244.0/255.0 blue:221.0/255.0 alpha:1.0]];
}

-(UIView*)getBackGround
{
    UIImage *ditu = [UIImage imageNamed:@"ShiKaiXiaoGuo.png"];
    assert( ditu );
    UIImage *fengge = [UIImage imageNamed:@"BJY_Fengge.png"];
    assert( fengge );
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:ditu];
    imageView.frame = CGRectMake(0.0, 0.0, ditu.size.width, ditu.size.height);
    imageView.userInteractionEnabled = YES;
    
    UIImage *icon = [UIImage imageNamed:@"btn_HuaDong_Edit.png"];
    assert( icon );
    UIButton *btnCheHua = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCheHua.tag = 1;
    [btnCheHua addTarget:self action:@selector(onSelectBKButton:) forControlEvents:UIControlEventTouchUpInside];
    //占时先改成不要移动按钮，只有两个按钮
    //float f1 = (ditu.size.width - 3.0 * icon.size.width) / 4.0;
    float f1 = (ditu.size.width - 2.0 * icon.size.width) / 3.0;
    CGRect rectBtn
    = CGRectMake(f1, (ditu.size.height - icon.size.height) / 2.0
                 , icon.size.width, icon.size.height);
    btnCheHua.frame = rectBtn;
    [btnCheHua setImage:icon forState:UIControlStateNormal];
    [imageView addSubview:btnCheHua];

//占时先改成不要移动按钮，只有两个按钮
//    rectBtn.origin.x += (f1 + icon.size.width);
//    icon = [UIImage imageNamed:@"btn_HuaDong_Move.png"];
//    assert( icon );
//    btnCheHua = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnCheHua.tag = 2;
//    [btnCheHua addTarget:self action:@selector(onSelectBKButton:) forControlEvents:UIControlEventTouchUpInside];
//    btnCheHua.frame = rectBtn;
//    [btnCheHua setImage:icon forState:UIControlStateNormal];
//    [imageView addSubview:btnCheHua];
    
    rectBtn.origin.x += (f1 + icon.size.width);
    icon = [UIImage imageNamed:@"btn_HuaDong_Delete.png"];
    assert( icon );
    btnCheHua = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCheHua.tag = 3;
    [btnCheHua addTarget:self action:@selector(onSelectBKButton:) forControlEvents:UIControlEventTouchUpInside];
    btnCheHua.frame = rectBtn;
    [imageView addSubview:btnCheHua];
    [btnCheHua setImage:icon forState:UIControlStateNormal];
    imageView.hidden = YES;
    return imageView;
}

-(void)onSelectBKButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ( btn ) {
        int tag = btn.tag;
        if ( tag == 1 ) { //编辑
            if( self->m_noteInfor.nNoteType == 0 )  return ;
            [_GLOBAL setEditorAddNoteInfo:NEWNOTE_EDIT catalog:self->m_noteInfor.strNoteIdGuid noteinfo:self->m_noteInfor];
            [PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
            [PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
        }
        else if ( tag == 2 ) { //移动
            //[FlurryAnalytics logEvent:@"文件夹-移动"];
        }
        else if ( tag == 3 ) { //删除
            //[FlurryAnalytics logEvent:@"文件夹-删除"];
            
            UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除该文件吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",nil];
            [alertview show];
            [alertview release]; 
        }
    }
}

//UIAlertView的代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) { //取消
        return;
    }
    else { //删除笔记(包括刷新)
        [BizLogic deleteNote:m_noteInfor.strNoteIdGuid SendUpdataMsg:YES];
    }
}


-(void) drawBackGround
{
    if ( self->m_BackGroundLeft ) {
        self->m_BackGroundLeft.hidden = YES;
        self->m_BackGroundRight.hidden = YES;
        return;
    }
    self->m_BackGroundLeft = [self getBackGround];
    assert( self->m_BackGroundLeft );
    self->m_BackGroundLeft.hidden = YES;
    [self addSubview:self->m_BackGroundLeft];
    
    self->m_BackGroundRight = [self getBackGround];
    assert( self->m_BackGroundRight );
    self->m_BackGroundRight.hidden = YES;
    CGRect r = self->m_BackGroundRight.frame;
    r.origin.x = self.frame.size.width - r.size.width;
    self->m_BackGroundRight.frame = r;
    [self addSubview:self->m_BackGroundRight];
}

+(NSString*)getWeekWithInt:(NSUInteger)week
{
    NSString *strWeek = nil;
    switch ( week ) {
        case 1:
            strWeek = LOC_STR("file_week_1");
            break;
        case 2:
            strWeek = LOC_STR("file_week_2");
            break;
        case 3:
            strWeek = LOC_STR("file_week_3");
            break;
        case 4:
            strWeek = LOC_STR("file_week_4");
            break;
        case 5:
            strWeek = LOC_STR("file_week_5");
            break;
        case 6:
            strWeek = LOC_STR("file_week_6");
            break;
        case 7:
            strWeek = LOC_STR("file_week_7");
            break;
        default:
            assert( 0 );
            break;
    }
    return strWeek;
}

-(UIView*) drawDayWithOriginX:(float)x
{
    if ( self->m_viewDay ) {
        [self->m_labelWeek setText:[UIFilesItem getWeekWithInt:self->m_Week]];
        [self->m_labelDay setText:[NSString stringWithFormat:@"%02d", self->m_Day]];
        return self->m_viewDay;
    }
    
    CGSize s
    = CGSizeMake(66.5, 60);
    UIImage *image = [UIImage imageNamed:@"RiQiXianShi.png"];
    assert(image);
    UIImageView *imageView
    = [[UIImageView alloc] initWithFrame:CGRectMake( x
        , (self.frame.size.height - s.height) / 2.0, s.width, s.height )];
    [imageView setImage:[image stretchableImageWithLeftCapWidth:15 topCapHeight:15]];
    NSString *strWeek = [UIFilesItem getWeekWithInt:self->m_Week];
        
    UILabel *day = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    day.textAlignment = NSTextAlignmentCenter;
    [PubFunction getLableWithString:strWeek lable:day contentfont:FONT_30PX maxsize:CGSizeMake(s.width, 25) origin:CGPointMake(0.0, 0.0)];
    CGRect r = day.frame;
    r.origin.x = (s.width - r.size.width) / 2.0;
    day.frame = r;
    [day setTextColor:[UIColor colorWithRed:130.0/255.0 \
                        green:77.0/255.0 blue:29.0/255.0 alpha:1.0]];
    self->m_labelWeek = day;
    [imageView addSubview:self->m_labelWeek];
    day = nil;
    
    strWeek = [NSString stringWithFormat:@"%02d", self->m_Day];
    day = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    day.textAlignment = NSTextAlignmentCenter;
    [PubFunction getLableWithString:strWeek lable:day contentfont:[UIFont systemFontOfSize:28] maxsize:CGSizeMake(s.width, 26) origin:CGPointMake(0.0, 24.0)];
    r = day.frame;
    r.origin.x = (s.width - r.size.width) / 2.0;
    day.frame = r;
    day.textColor = self->m_labelWeek.textColor;
    self->m_labelDay = day;
    [imageView addSubview:day];
    day = nil;
    
    self->m_viewDay = imageView;
    return self->m_viewDay;
}

-(UIView*) drawFileContentWithOriginX:(float)x
{
    if ( self->m_viewContent ) {
        [self->m_labelTitle setText:self->m_Title];
        [self->m_labelSynopsis setText:self->m_Synopsis];
        return self->m_viewContent;
    }
    
    UIView *v
    = [[UIView alloc] initWithFrame:CGRectMake(x, 5
    , self.frame.size.width - x, self.frame.size.height - 10 )];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    l.textAlignment = NSTextAlignmentLeft;
    [PubFunction getLableWithString:self->m_Title lable:l \
    contentfont:FONT_30PX maxsize:CGSizeMake(self.frame.size.width - 135, 25) \
    origin:CGPointMake(0.0, 0.0)];
    CGRect r = l.frame;
    if ( r.size.width > v.frame.size.width ) {  
        r.size.width = v.frame.size.width;
        l.frame = r;
    }
    l.lineBreakMode = NSLineBreakByTruncatingTail;
    //l.lineBreakMode = NSLineBreakByTruncatingMiddle ;
    self->m_labelTitle = l;
    [v addSubview:self->m_labelTitle];
    float y = self->m_labelTitle.frame.size.height + 2;
    l = nil;
    
    r = self->m_labelTitle.frame;
    l = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    l.textAlignment = NSTextAlignmentLeft;
    
    NSString *sNoUpdata = @" (未上传)";
    if ( m_noteInfor.tHead.nEditState == EDITSTATE_NOEDIT )
        sNoUpdata = @" (已上传)";
    else if( m_noteInfor.tHead.nEditState == EDITSTATE_UPLOAD_FAILURE )
        sNoUpdata = @" (上传失败)";
    [PubFunction getLableWithString:sNoUpdata lable:l \
                        contentfont:FONT_30PX maxsize:CGSizeMake(10000, 25) \
                             origin:CGPointMake(r.origin.x + r.size.width , r.origin.y)];
    [l setTextColor:[UIColor grayColor]];
    [v addSubview:l];
    SAFEFREE_OBJECT(l);
    
    
    l = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    l.textAlignment = NSTextAlignmentLeft;
    [PubFunction getLableWithString:self->m_Synopsis lable:l \
    contentfont:FONT_20PX maxsize:CGSizeMake(v.frame.size.width - 30
    , v.frame.size.height - y ) origin:CGPointMake(0.0, y)];
    l.lineBreakMode = NSLineBreakByTruncatingTail;
    float fcolor = (float)0x7B/255.0;
    [l setTextColor:[UIColor colorWithRed:fcolor green:fcolor blue:fcolor alpha:1.0]];
    self->m_labelSynopsis = l;
    [v addSubview:self->m_labelSynopsis];
    l = nil;
    
    self->m_viewContent = v;
    return self->m_viewContent;
}

-(void) drawFileContent
{
    float x = 3.0;
    CGRect r = self.frame;
    r.origin.x = r.origin.y = 0.0;
    if ( self->m_viewFile ) {
        [self drawDayWithOriginX:x];
        [self drawFileContentWithOriginX:x];
        CGRect r2 = self->m_scrollFileContent.frame;
        if ( r2.origin.x != 0.0 ) {
            r2.origin.x = 0.0;
            self->m_scrollFileContent.frame = r2;
            r.size.width += 2.0 * self->m_fOffSet;
            [self->m_scrollFileContent setContentSize:r.size];
            //update by zd 2014-3-19
            self->m_scrollFileContent.contentOffset = CGPointMake(self->m_fOffSet, 0.0);
        }
        return;
    }
    self->m_scrollFileContent = [[UIScrollView alloc] initWithFrame:r];
    [self->m_scrollFileContent setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:244.0/255.0 blue:221.0/255.0 alpha:1.0]];
    self->m_scrollFileContent.bounces = NO;
    self->m_scrollFileContent.showsHorizontalScrollIndicator = NO;
    self->m_scrollFileContent.showsVerticalScrollIndicator = NO;
    //update by zd 2014-3-20
    self->m_viewFile = [[UIView alloc] initWithFrame:CGRectMake( self->m_fOffSet, 0.0, r.size.width, r.size.height)];
    //self->m_viewFile = [[UIView alloc] initWithFrame:CGRectMake(0, 0, r.size.width, r.size.height )] ;
    [self drawDayWithOriginX:x];
    assert( self->m_viewDay );
    [self->m_viewFile addSubview:self->m_viewDay];
    x += self->m_viewDay.frame.size.width;
    x += 7.0;
    [self drawFileContentWithOriginX:x];
    assert( self->m_viewContent );
    [self->m_viewFile addSubview:self->m_viewContent];
    [self->m_scrollFileContent addSubview: self->m_viewFile];
    
    r.size.width += 2.0 * self->m_fOffSet;
    [self->m_scrollFileContent setContentSize:r.size];//不设置滚动了 update by zd 2014-3-19
    [self->m_scrollFileContent setContentOffset:CGPointMake(self->m_fOffSet, 0.0)];
    self->m_scrollFileContent.delegate = self;//不设置滚动了 update by zd 2014-3-19
    [self addSubview:self->m_scrollFileContent];
    
    CGSize size = self->m_scrollFileContent.frame.size ;
    self->m_picture = [[UIImageView alloc] initWithFrame:CGRectMake( size.width + 110 /*-size.height + 10*/, 23, size.height - 25, size.height - 25 )] ;
    [self->m_scrollFileContent addSubview:m_picture] ;
    //m_picture.backgroundColor = [UIColor blackColor] ;
    [m_picture release] ;
}

-(void)drawItemAnimation
{
    float newX;
    CGRect rectOld = self->m_scrollFileContent.frame;
    
    if ( 0 == self->m_iChehuaType ) {
        newX = 0;
    }
    else if ( 1 == self->m_iChehuaType )
    {
        newX = self->m_fOffSet;
    }
    else
    {
        newX = 0 - (self->m_fOffSet);
    }
    self->m_scrollFileContent.contentOffset
    = CGPointMake(self->m_fOffSet, 0.0);
    CGContextRef contex = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:contex];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2];
    [self->m_scrollFileContent setFrame:CGRectMake(newX
    , rectOld.origin.y, rectOld.size.width, rectOld.size.height )];
    [UIView commitAnimations];
}

-(void)drawFileItem
{
    [self drawBackGround];
    [self drawFileContent];
}
#pragma mark - srcoll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if( scrollView == self->m_scrollFileContent )
    {
        CGPoint p = scrollView.contentOffset;
        CGRect r = self->m_scrollFileContent.frame;
        r.origin.x += (self->m_fOffSet - p.x);
        //NSLog(@"offset1:%f %f\r\n", p.x, r.origin.x);
        
        p.x = self->m_fOffSet;
        scrollView.contentOffset = p;
        if ( 0 == self->m_iChehuaType ) {
            if ( r.origin.x > self->m_fOffSet ) {
                r.origin.x = self->m_fOffSet;
                //return;
            }
            else if( r.origin.x < ( 0-self->m_fOffSet ) )
            {
                r.origin.x = ( 0-self->m_fOffSet );
                //return;
            }
        }
        else if( 1 == self->m_iChehuaType )
        {
            if ( r.origin.x < 0.0 ) {
                r.origin.x = 0.0;
            }
            else if ( r.origin.x > self->m_fOffSet ) {
                r.origin.x = self->m_fOffSet;
                //return;
            }
        }
        else
        {
            if( r.origin.x < ( 0-self->m_fOffSet ) )
            {
                r.origin.x = ( 0-self->m_fOffSet );
                //return;
            }
            else if( r.origin.x > 0.0 )
            {
                r.origin.x = 0.0;
            }
        }
               
        //NSLog(@"offset1:%f \r\n", r.origin.x);
        
        if ( r.origin.x > 0.0 ) {
            self->m_BackGroundLeft.hidden = NO;
            self->m_BackGroundRight.hidden = YES;
        }
        else
        {
            self->m_BackGroundLeft.hidden = YES;
            self->m_BackGroundRight.hidden = NO;
        }
        [self->m_scrollFileContent setFrame:r];
//        CGSize s = self->m_ScrollMainViewContentSize;
//        s.width += r.origin.x;
//        [scrollView setContentSize:s];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ( NO == decelerate ) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}  

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    CGPoint pt = scrollView.contentOffset;
    //    pt.x = 0.0f;
    //    scrollView.contentOffset = pt;
     if( scrollView == self->m_scrollFileContent )
     {
         CGRect rectOld = self->m_scrollFileContent.frame;
         NSLog(@"EndScroll:%f\r\n", rectOld.origin.x);
         if ( self->m_iChehuaType == 0 ) {
             if ( rectOld.origin.x >= (self->m_fOffSet * 0.6) ) {
                 self->m_iChehuaType = 1;
             }
             else if( rectOld.origin.x <= (-(self->m_fOffSet * 0.6)))
             {
                self->m_iChehuaType = 2;
             }
         }
        else if( self->m_iChehuaType == 1 )
        {
//            if( rectOld.origin.x <= (-(self->m_fOffSet * 0.1)) )
//            {
//                self->m_iChehuaType = 2;
//            }
//            else if( rectOld.origin.x <= (self->m_fOffSet * 0.8) )
//            {
//                self->m_iChehuaType = 0;
//            }
            if( rectOld.origin.x <= (self->m_fOffSet * 0.8) )
            {
                self->m_iChehuaType = 0;
            }
        }
        else if( self->m_iChehuaType == 2 )
        {
//            if( rectOld.origin.x >= (self->m_fOffSet * 0.1) )
//            {
//                self->m_iChehuaType = 1;
//            }
//            else if( rectOld.origin.x >= (-(self->m_fOffSet * 0.8)) )
//            {
//                self->m_iChehuaType = 0;
//            }
            if( rectOld.origin.x >= (-(self->m_fOffSet * 0.8)) )
            {
                self->m_iChehuaType = 0;
            }

        }
         scrollView.contentOffset = CGPointMake(self->m_fOffSet, 0.0);
        [self drawItemAnimation];
     }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
