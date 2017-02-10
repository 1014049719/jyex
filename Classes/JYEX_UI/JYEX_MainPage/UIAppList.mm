//
//  UIAppList.m
//  NoteBook
//
//  Created by cyl on 13-4-15.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import "PubFunction.h"
#import "BussDataDef.h"
#import "UIAppList.h"
#import "CommonAll.h"

@implementation UIAppList

@synthesize appList;
@synthesize vwEmptyView;
@synthesize appDelegate;
@synthesize onApp;
@synthesize sHaveNoAppString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self->m_width = frame.size.width;
        self.sHaveNoAppString = nil;
        self.vwEmptyView = nil;
        self.appDelegate = nil;
        self.onApp = nil;
    }
    return self;
}

-(void)dealloc
{
    self.appList = nil;
    self.sHaveNoAppString = nil;
    self.vwEmptyView = nil;
    self.appDelegate = nil;
    [super dealloc];
}


-(UIView*)drawEmptyView
{

    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    UIFont *textFont = FONT_24PX;
    [PubFunction getLableWithString:self->sHaveNoAppString \
        lable:l contentfont:textFont \
        maxsize:CGSizeMake(self->m_width, 100) origin:CGPointMake(0, 0)];
    l.textColor = [UIColor blackColor];
    
    UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self->m_width, l.frame.size.height * 5.0 )] autorelease];
    v.backgroundColor = [UIColor clearColor];
    l.center = v.center;
    
    [v addSubview:l];
    [l release];
    return v;
}


-(void)drawAppListView
{
    if ( self.appList && [self.appList count]) {
        CGRect btnRect = CGRectMake(0.0, 0.0, 0.0, 0.0);
        UIImage *image = [UIImage imageNamed:@"app_image_qqhk.png"];
        btnRect.size.width = self->m_width / 3.0;
        btnRect.size.height = image.size.height + 30.0;
        for (int i = 0; i < [self.appList count]; ++i ) {
            if ( i != 0 && i % 3 == 0 ) {
                btnRect.origin.y += btnRect.size.height;
                btnRect.origin.x = 0.0;
            }
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
            [self setButton:btn Frame:btnRect AppInfo:[self.appList objectAtIndex:i]  Taget:i];
            [self addSubview:btn];
            [btn release];
            btnRect.origin.x += btnRect.size.width;
        }
        
        CGRect frame = self.frame;
        frame.size.width = self->m_width;
        frame.size.height = btnRect.origin.y + btnRect.size.height;
        self.frame = frame;
    }
}

-(BOOL)setButton:(UIButton*)btn Frame:(CGRect)rect AppInfo:(JYEXUserAppInfo*)appinfo Taget:(int)taget
{

    btn.frame = rect;
    NSString *resource = [CommonFunc getResourceNameWithAppCode:appinfo.sAppCode];
    UIImage *image = [UIImage imageNamed:resource];
    CGSize imageSize = image.size;
    [btn setImage:image forState:nil];
    [btn setBackgroundImage:[UIImage imageNamed:@"divider_group.png"] forState:UIControlStateHighlighted];
    [btn setTitle:appinfo.sAppName forState:nil];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = FONT_24PX;
    btn.titleLabel.lineBreakMode   = NSLineBreakByTruncatingTail;
    [btn setTitleColor:[UIColor blackColor] forState:nil];
    btn.tag = taget;
    [btn addTarget:self action:@selector(onSelectAppButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //不同的水平和垂直对齐模式
    //imageEdgeInsets和titleEdgeInsets的计算方法不同
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    CGSize lineSize = {0, 0};
    CGRect imgRect = btn.imageView.frame; //不能删除这句
    CGRect labelRect = btn.titleLabel.frame;
    lineSize = [appinfo.sAppName sizeWithFont:btn.titleLabel.font  \
                            constrainedToSize:CGSizeMake(rect.size.width, labelRect.size.height) \
                                lineBreakMode: NSLineBreakByWordWrapping];

    //UIEdgeInsets imageInsets
    //= UIEdgeInsetsMake((rect.size.height - imageSize.height - labelRect.size.height) / 2.0
    //, (rect.size.width - imageSize.width)/2.0
    //,(rect.size.height - imageSize.height - labelRect.size.height) / 2.0 + labelRect.size.height
    //, (rect.size.width - imageSize.width)/2.0);
    //btn.imageEdgeInsets = imageInsets;
    UIEdgeInsets imageInsets
    = UIEdgeInsetsMake((rect.size.height - imageSize.height - lineSize.height) / 2.0
                       , (rect.size.width - imageSize.width)/2.0
                       ,(rect.size.height - imageSize.height - lineSize.height) / 2.0 + lineSize.height
                       , (rect.size.width - imageSize.width)/2.0);
    btn.imageEdgeInsets = imageInsets;

    

    //UIEdgeInsets textInsets =
    //UIEdgeInsetsMake(
    //                 (rect.size.height - image.size.height - lineSize.height) / 2.0 + imageSize.height - labelRect.origin.y
    //                 , (rect.size.width - lineSize.width) / 2.0 - labelRect.origin.x
    //                 , 0.0
    //                 , 0.0);
    //btn.titleEdgeInsets = textInsets;
    
    UIEdgeInsets textInsets =
    UIEdgeInsetsMake(
                     (rect.size.height - imageSize.height - lineSize.height) / 2.0 + imageSize.height - labelRect.origin.y
                     , (rect.size.width - lineSize.width) / 2.0 - labelRect.origin.x
                     , 0.0
                     , 0.0);
    btn.titleEdgeInsets = textInsets;
    
    
    UIImage *img = [UIImage imageNamed:@"xianshitiaoshu.png"];
    UIImageView *ivTips = [[[UIImageView alloc] initWithImage:img] autorelease];
    rect = CGRectMake(btn.frame.size.width-img.size.width-15, 5, img.size.width, img.size.height);
    ivTips.frame = rect;
    ivTips.tag = 1000;
    ivTips.hidden = YES;
  
    rect = ivTips.frame;
    UILabel *lbTips = [[[UILabel alloc] initWithFrame:rect] autorelease];
    lbTips.backgroundColor = [UIColor clearColor];
    lbTips.textColor = [UIColor whiteColor];
    lbTips.font = [UIFont systemFontOfSize:14];
    lbTips.textAlignment = NSTextAlignmentCenter;
    lbTips.tag = 1001;
    lbTips.text = @"1";
    lbTips.hidden = YES;
    
    [btn addSubview:ivTips];
    [btn addSubview:lbTips];
    
    return YES;
}

-(void)setTips:(int)tag msgnum:(int)msgnum
{
    for (UIView *view in self.subviews )
    {
        if ( view.tag == tag && [view isMemberOfClass:[UIButton class]]) {
            for ( UIView *subview in view.subviews) {
                if ( subview.tag == 1000 && [subview isMemberOfClass:[UIImageView class]]) {
                    if ( msgnum == 0 ) {
                        subview.hidden = YES;
                    }
                    else {
                        subview.hidden = NO;
                    }
                }
                else if ( subview.tag == 1001 && [subview isMemberOfClass:[UILabel class]]) {
                    if ( msgnum == 0 ) {
                        subview.hidden = YES;
                    }
                    else {
                        subview.hidden = NO;
                        UILabel *lbtips = (UILabel *)subview;
                        lbtips.text = [NSString stringWithFormat:@"%d",msgnum];
                    }
                }
            }
            break;
        }
    }
}

-(void)onSelectAppButton:(id)send
{
    UIButton *btn = (UIButton*)send;
    if ( btn && self.appList ) {
        NSInteger tag = btn.tag;
        if ( tag < [self.appList count] ) {
            JYEXUserAppInfo *appInfo = [self.appList objectAtIndex:tag];
            if ( appDelegate && [appDelegate respondsToSelector:onApp]) {
                [appDelegate  performSelectorOnMainThread:onApp withObject:appInfo waitUntilDone:NO];
            }
        }
    }
}

-(void)setAppDelegate:(NSObject *)appObject Select:(SEL)appFun
{
    self.appDelegate = appObject;
    self.onApp = appFun;
}

-(void)proDrawAppList
{
    if ( !self.appList || ![self.appList count] ) {
        UIView *v = [self drawEmptyView];
        CGRect r = self.frame;
        r.size.width = v.frame.size.width;
        r.size.height = v.frame.size.height;
        self.frame = r;
        [self addSubview:v];
    }
    else
    {
        [self drawAppListView];
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
