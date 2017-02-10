//
//  HelpView.m
//  JYEX
//
//  Created by zd on 15-1-12.
//  Copyright (c) 2015年 广州洋基. All rights reserved.
//

#import "HelpView.h"

@implementation HelpView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect frm = frame ;
        frm.origin.x = 0 ;
        frm.origin.y = 0 ;
        bgImgView = [[UIImageView alloc] initWithFrame:frm];
        [bgImgView setBackgroundColor: [UIColor blackColor]];
        
        bgImgView.userInteractionEnabled = YES ;
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
        [bgImgView addGestureRecognizer:singleTap1];
        [singleTap1 release];
        
        [self addSubview:bgImgView];
        [bgImgView release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)onClick:(id)sender
{
    [self removeFromSuperview];
}

@end
